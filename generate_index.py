"""Generate index.html, gammes/index.html, and private.html for the harmonica site."""

import hashlib
import logging
import os
import re
import sys
from html import escape

logging.basicConfig(level=logging.INFO, format="%(message)s")
logger = logging.getLogger(__name__)

# --------- Constants ---------

FRENCH_NOTES  = {'sol': 7, 'do': 0, 're': 2, 'mi': 4, 'fa': 5, 'la': 9, 'si': 11}
ENGLISH_NOTES = {'c': 0, 'd': 2, 'e': 4, 'f': 5, 'g': 7, 'a': 9, 'b': 11}

TUNING_ROOTS: dict[str, int] = {
    'diatonicHarmonicaTab':   0,
    'diatonicDHarmonicaTab':  2,
    'diatonicGHarmonicaTab':  7,
    'diatonicAHarmonicaTab':  9,
    'diatonicFHarmonicaTab':  5,
    'diatonicBbHarmonicaTab': 10,
}

# Semitone offsets (from harmonica root) requiring special technique
BEND_OFFSETS     = {1, 5, 6, 8, 9, 10, 13, 20, 27, 30, 34, 35}
OVERBLOW_OFFSETS = {3, 15, 18, 22}
OVERDRAW_OFFSETS = {25, 32}

COUNTRY_FLAGS: dict[str, str] = {
    'ar': '🇦🇷', 'at': '🇦🇹', 'de': '🇩🇪', 'fr': '🇫🇷', 'gb': '🇬🇧',
    'ie': '🇮🇪', 'it': '🇮🇹', 'ru': '🇷🇺', 'us': '🇺🇸',
}

LIBRARY_FILES  = {"harmonica.ly", "style.ly"}
OUTPUT_DIR     = "output"
PARTITIONS_DIR = "partitions"
GAMMES_SUBDIR  = "gammes"

# Password hash for the private page (override with PRIVATE_PASSWORD env var)
_pw = os.environ.get("PRIVATE_PASSWORD", "harmonica")
PRIVATE_HASH = hashlib.sha256(_pw.encode()).hexdigest()


# --------- Difficulty analysis ---------

def _strip_comments(text: str) -> str:
    text = re.sub(r'%\{.*?%\}', '', text, flags=re.DOTALL)
    return re.sub(r'%[^\n]*', '', text)


def _brace_block(text: str, start: int) -> str:
    depth, i = 1, start
    while i < len(text) and depth:
        c = text[i]
        if c == '{':   depth += 1
        elif c == '}': depth -= 1
        i += 1
    return text[start:i - 1]


def analyze_difficulty(content: str) -> dict:
    content = _strip_comments(content)
    is_french = bool(re.search(r'language\s*"fran', content))
    notes_map = FRENCH_NOTES if is_french else ENGLISH_NOTES

    root = 0
    for fn, r in TUNING_ROOTS.items():
        if re.search(rf'\\{fn}\b', content):
            root = r
            break

    tempo = None
    m = re.search(r'\\tempo\s+\d+\.?\s*=\s*(\d+)', content)
    if m:
        tempo = int(m.group(1))

    m_mel = re.search(r'\bmelodie\s*=\s*\{', content)
    melody = _brace_block(content, m_mel.end()) if m_mel else content

    current = 60
    names_sorted = sorted(notes_map.keys(), key=len, reverse=True)
    names_alt = '|'.join(names_sorted)
    m_rel = re.search(rf'\\relative\s+({names_alt})([\',]*)', content)
    if m_rel:
        start_class = notes_map[m_rel.group(1)]
        mods = m_rel.group(2)
        current = 48 + start_class + mods.count("'") * 12 - mods.count(",") * 12

    melody = re.sub(r'\\[a-zA-Z]+(?:\s*\{[^{}]*\})?', ' ', melody)
    melody = re.sub(r'"[^"]*"', ' ', melody)
    melody = re.sub(r'#[^|\n{} ]*', ' ', melody)

    if is_french:
        note_re = re.compile(
            rf'(?<![a-zA-Z])({names_alt})(dd|d|bb|b)?([\',]*)(\d+)?(\.+)?(?![a-zA-Z])'
        )
    else:
        note_re = re.compile(
            r"(?<![a-zA-Z])([cdefgab])(isis|eses|is|es)?([\',]*)(\d+)?(\.+)?(?![a-zA-Z])"
        )

    bends = overblows = overdraws = 0
    fastest = None

    for m in note_re.finditer(melody):
        name    = m.group(1)
        acc     = m.group(2) or ''
        oct_str = m.group(3) or ''
        dur_str = m.group(4)

        base = notes_map.get(name, 0)
        if is_french:
            base += acc.count('d') - acc.count('b')
        else:
            if 'isis' in acc:   base += 2
            elif 'is' in acc:   base += 1
            elif 'eses' in acc: base -= 2
            elif 'es' in acc:   base -= 1
        base %= 12

        diff_up = (base - current % 12) % 12
        abs_p   = (current + diff_up) if diff_up <= 6 else (current - (12 - diff_up))
        abs_p  += oct_str.count("'") * 12 - oct_str.count(",") * 12
        current = abs_p

        if dur_str:
            d = int(dur_str)
            if fastest is None or d > fastest:
                fastest = d

        offset = abs_p - 60 - root
        if offset in BEND_OFFSETS:
            bends += 1
        elif offset in OVERBLOW_OFFSETS:
            overblows += 1
        elif offset in OVERDRAW_OFFSETS:
            overdraws += 1

    return {
        'bends': bends, 'overblows': overblows, 'overdraws': overdraws,
        'tempo': tempo, 'fastest_note': fastest,
    }


def difficulty_sort_value(diff: dict) -> float:
    bends     = diff.get('bends', 0)
    overblows = diff.get('overblows', 0)
    overdraws = diff.get('overdraws', 0)
    tempo     = diff.get('tempo') or 100
    fastest   = diff.get('fastest_note') or 4
    weight = bends + overblows * 3 + overdraws * 3
    speed  = tempo * fastest / 240
    return weight + speed


def difficulty_cell(diff: dict) -> str:
    bends     = diff.get('bends', 0)
    overblows = diff.get('overblows', 0)
    overdraws = diff.get('overdraws', 0)
    tempo     = diff.get('tempo') or 100
    fastest   = diff.get('fastest_note') or 4

    speed = tempo * fastest / 240
    if speed >= 7:
        speed_badge, speed_label = '⚡', 'très rapide'
    elif speed >= 4:
        speed_badge, speed_label = '🏃', 'rapide'
    elif speed >= 2:
        speed_badge, speed_label = '🎵', 'modéré'
    else:
        speed_badge, speed_label = '🐢', 'lent'

    weight = bends + overblows * 3 + overdraws * 3
    if weight == 0:
        level, level_label = '🟢', 'facile'
    elif weight <= 5:
        level, level_label = '🟡', 'moyen'
    else:
        level, level_label = '🔴', 'difficile'

    parts   = [level]
    details = [level_label]
    if bends:
        parts.append(f'↕{bends}')
        details.append(f'{bends} bend(s)')
    if overblows:
        parts.append(f'⊕{overblows}')
        details.append(f'{overblows} overblow(s)')
    if overdraws:
        parts.append(f'⊗{overdraws}')
        details.append(f'{overdraws} overdraw(s)')
    parts.append(speed_badge)
    details.append(f'{speed_label} (♩={tempo}, 1/{fastest})')

    sort_val = difficulty_sort_value(diff)
    tooltip  = escape(' | '.join(details))
    content  = ' '.join(parts)
    return f"<td data-sort='{sort_val:.2f}' title='{tooltip}' style='white-space:nowrap'>{content}</td>"


# --------- LilyPond metadata parsing ---------

def parse_ly_metadata(ly_path: str) -> dict:
    metadata: dict = {
        "copyrightStatus": "unknown", "lyricsLang": [],
        "key": "unknown", "composer": "", "title": "",
        "composerNationality": "", "difficulty": {},
    }
    if not os.path.exists(ly_path):
        logger.warning(f"  ⚠️  Fichier .ly introuvable : '{ly_path}'")
        return metadata

    with open(ly_path, encoding="utf-8") as f:
        content = f.read()

    def find(pattern, flags=0):
        m = re.search(pattern, content, flags)
        return m.group(1).strip() if m else ""

    metadata["copyrightStatus"]      = find(r'copyrightStatus\s*=\s*"([^"]+)"') or "unknown"
    metadata["composer"]             = find(r'^\s*composer\s*=\s*"([^"]*)"', re.MULTILINE)
    metadata["title"]                = find(r'^\s*title\s*=\s*"([^"]*)"', re.MULTILINE)
    metadata["composerNationality"]  = find(r'composerNationality\s*=\s*"([^"]*)"')

    m = re.search(r'lyricsLang\s*=\s*#\'\(([^)]*)\)', content)
    if m:
        metadata["lyricsLang"] = m.group(1).split()

    m = re.search(r'\\key\s+([a-z]+)\s+\\major', content)
    if m:
        metadata["key"] = m.group(1)

    metadata["difficulty"] = analyze_difficulty(content)
    return metadata


def copyright_icon(status: str) -> str:
    return {
        "public-domain": "🆓", "copyrighted": "©",
        "arrangement-copyrighted": "©✍️", "unknown": "⚠️", "forbidden": "🚫",
    }.get(status, "⚠️")


def lyrics_icon(langs: list) -> str:
    icons = {
        "fr": "🇫🇷", "en": "🇬🇧", "de": "🇩🇪", "es": "🇪🇸",
        "it": "🇮🇹", "pt": "🇵🇹", "nl": "🇳🇱", "pl": "🇵🇱",
        "ru": "🇷🇺", "sv": "🇸🇪", "da": "🇩🇰", "no": "🇳🇴",
    }
    return "".join(icons.get(lang, f"[{lang}]") for lang in langs) or "🎵"


def key_to_french(key: str) -> str:
    if not key or key == "unknown":
        return "Do"
    mapping = {
        "c": "Do", "d": "Ré", "e": "Mi", "f": "Fa",
        "g": "Sol", "a": "La", "b": "Si",
        "ces": "Do♭", "des": "Ré♭", "ees": "Mi♭", "fes": "Fa♭",
        "ges": "Sol♭", "aes": "La♭", "bes": "Si♭",
        "cis": "Do♯", "dis": "Ré♯", "eis": "Mi♯", "fis": "Fa♯",
        "gis": "Sol♯", "ais": "La♯", "bis": "Si♯",
        "re": "Ré", "reb": "Ré♭", "red": "Ré♯",
    }
    return mapping.get(key.strip().lower(), key.capitalize())


# --------- File collection ---------

def collect_outputs(base: str, output_dir: str) -> dict:
    """Return lists of diatonic PDFs, chromatic PDFs, and MP3s for a base name."""
    if not os.path.exists(output_dir):
        return {'diat': [], 'chro': [], 'mp3s': []}
    files = set(os.listdir(output_dir))
    pat_diat = re.compile(rf'^{re.escape(base)}_diatonique(-\d+)?\.pdf$')
    pat_chro = re.compile(rf'^{re.escape(base)}_chromatique(-\d+)?\.pdf$')
    pat_mp3  = re.compile(rf'^{re.escape(base)}(-\d+)?\.mp3$')
    return {
        'diat': sorted(f for f in files if pat_diat.match(f)),
        'chro': sorted(f for f in files if pat_chro.match(f)),
        'mp3s': sorted(f for f in files if pat_mp3.match(f)),
    }


def collect_songs() -> list[dict]:
    """Scan partitions/*.ly (not gammes/) and return enriched song list."""
    if not os.path.isdir(PARTITIONS_DIR):
        logger.warning(f"⚠️  Dossier '{PARTITIONS_DIR}' introuvable")
        return []
    songs = []
    for fname in sorted(os.listdir(PARTITIONS_DIR)):
        if fname in LIBRARY_FILES or not fname.endswith(".ly"):
            continue
        full = os.path.join(PARTITIONS_DIR, fname)
        if not os.path.isfile(full):
            continue
        base = fname[:-3]
        meta = parse_ly_metadata(full)
        meta['base'] = base
        meta['outputs'] = collect_outputs(base, OUTPUT_DIR)
        songs.append(meta)
    return songs


def collect_gammes() -> list[dict]:
    """Scan partitions/gammes/*.ly and return enriched gamme list."""
    gammes_src = os.path.join(PARTITIONS_DIR, GAMMES_SUBDIR)
    gammes_out = os.path.join(OUTPUT_DIR, GAMMES_SUBDIR)
    if not os.path.isdir(gammes_src):
        return []
    gammes = []
    for fname in sorted(os.listdir(gammes_src)):
        if not fname.endswith(".ly"):
            continue
        full = os.path.join(gammes_src, fname)
        if not os.path.isfile(full):
            continue
        base = fname[:-3]
        meta = parse_ly_metadata(full)
        meta['base'] = base
        meta['outputs'] = collect_outputs(base, gammes_out)
        gammes.append(meta)
    return gammes


# --------- HTML helpers ---------

_CSS = """\
<style>
*{box-sizing:border-box}
body{font-family:sans-serif;max-width:1400px;margin:0 auto;padding:1em;background:#fafafa}
h1{color:#333}
nav a{margin-right:1em;text-decoration:none;color:#1565c0;font-weight:bold}
nav a:hover{text-decoration:underline}
table{border-collapse:collapse;width:100%;font-size:0.88em;background:#fff}
thead th{background:#f0f0f0;cursor:pointer;user-select:none;white-space:nowrap;
         padding:7px 9px;border:1px solid #ccc;text-align:center}
thead th:hover{background:#dde}
thead th.sort-asc::after{content:" ▲";font-size:.8em}
thead th.sort-desc::after{content:" ▼";font-size:.8em}
tbody td{border:1px solid #ccc;padding:5px 8px;text-align:center}
tbody td:first-child{text-align:left}
tbody td:nth-child(2){text-align:left;font-size:0.85em}
tbody tr:hover{background:#f5f5f5}
.hidden{color:#bbb;font-style:italic}
.badge{font-size:1.1em}
/* login form */
#login-section{max-width:340px;margin:4em auto;padding:2em;background:#fff;
               border:1px solid #ccc;border-radius:8px;text-align:center;box-shadow:0 2px 8px #0001}
#login-section h2{margin-top:0}
#pwd-input{width:100%;padding:.5em;font-size:1em;margin:.5em 0;border:1px solid #aaa;border-radius:4px}
#login-btn{padding:.5em 1.5em;font-size:1em;background:#1565c0;color:#fff;border:none;
           border-radius:4px;cursor:pointer}
#login-btn:hover{background:#0d47a1}
#login-error{color:#c62828;margin-top:.5em;display:none}
</style>"""

_SORT_JS = """\
<script>
(function(){
  var _col=-1,_asc=true;
  window.sortTable=function(th){
    var table=th.closest('table');
    var tbody=table.tBodies[0];
    var rows=Array.from(tbody.rows);
    var col=th.cellIndex;
    if(_col===col){_asc=!_asc;}else{_col=col;_asc=true;}
    rows.sort(function(a,b){
      var va=(a.cells[col]&&a.cells[col].dataset.sort!==undefined)?a.cells[col].dataset.sort:a.cells[col].textContent.trim();
      var vb=(b.cells[col]&&b.cells[col].dataset.sort!==undefined)?b.cells[col].dataset.sort:b.cells[col].textContent.trim();
      var na=parseFloat(va),nb=parseFloat(vb);
      if(!isNaN(na)&&!isNaN(nb)){return _asc?na-nb:nb-na;}
      return _asc?va.localeCompare(vb,'fr'):vb.localeCompare(va,'fr');
    });
    rows.forEach(function(r){tbody.appendChild(r);});
    table.querySelectorAll('thead th').forEach(function(t,i){
      t.classList.remove('sort-asc','sort-desc');
      if(i===col){t.classList.add(_asc?'sort-asc':'sort-desc');}
    });
  };
})();
</script>"""


def _pdf_links(files: list[str], prefix: str = "") -> str:
    if not files:
        return "<span class='hidden'>—</span>"
    links = [f"<a href='{escape(prefix + f)}'>PDF</a>" for f in files]
    return " ".join(links)


def _mp3_link(files: list[str], prefix: str = "") -> str:
    if not files:
        return "<span class='hidden'>—</span>"
    return f"<a href='{escape(prefix + files[0])}'>MP3</a>"


def _table_header(cols: list[tuple]) -> str:
    """cols = list of (label, sort_type) where sort_type is unused but kept for data-sort."""
    ths = "".join(
        f"<th onclick='sortTable(this)'>{escape(label)}</th>"
        for label, _ in cols
    )
    return f"<thead><tr>{ths}</tr></thead>"


def _song_row(meta: dict, public_only: bool, pdf_prefix: str = "") -> str:
    base      = meta['base']
    status    = meta['copyrightStatus']
    lyrics    = meta['lyricsLang']
    key       = key_to_french(meta['key'])
    composer  = meta['composer']
    title     = meta['title'] or base
    nat       = meta['composerNationality'].lower()
    flag      = COUNTRY_FLAGS.get(nat, '')
    diff      = meta['difficulty']
    outputs   = meta['outputs']
    diat      = outputs['diat']
    chro      = outputs['chro']
    mp3s      = outputs['mp3s']

    composer_cell = f"{flag} {escape(composer)}".strip() if composer else flag
    key_num = {
        'do': 0, 'ré': 2, 'mi': 4, 'fa': 5, 'sol': 7, 'la': 9, 'si': 11,
    }.get(key.lower().split('♭')[0].split('♯')[0], 0)

    is_free = status in ("public-domain", "public domain")
    show_links = is_free or not public_only

    row  = "<tr>"
    row += f"<td data-sort='{escape(title.lower())}'>{escape(title)}</td>"
    row += f"<td data-sort='{escape(composer.lower())}'>{composer_cell}</td>"
    row += f"<td data-sort='{key_num}'>{escape(key)}</td>"
    if show_links:
        row += f"<td>{_pdf_links(diat, pdf_prefix)}</td>"
        row += difficulty_cell(diff)
        row += f"<td>{_pdf_links(chro, pdf_prefix)}</td>"
        row += f"<td>{_mp3_link(mp3s, pdf_prefix)}</td>"
    else:
        row += "<td class='hidden'>non affiché</td>"
        row += difficulty_cell(diff)
        row += "<td class='hidden'>non affiché</td>"
        row += "<td class='hidden'>non affiché</td>"
    row += f"<td class='badge'>{lyrics_icon(lyrics)}</td>"
    row += f"<td class='badge' data-sort='{escape(status)}'>{copyright_icon(status)}</td>"
    row += "</tr>\n"
    return row


# --------- Page generators ---------

_TABLE_COLS = [
    ("Œuvre", "str"), ("Compositeur", "str"), ("Clé", "num"),
    ("Diatonique", "str"), ("Difficulté 🎵", "num"),
    ("Chromatique", "str"), ("MP3", "str"),
    ("Paroles", "str"), ("Droits", "str"),
]

_DIFFICULTY_HELP = (
    "🟢 facile · 🟡 moyen · 🔴 difficile — "
    "↕ bends · ⊕ overblows · ⊗ overdraws — vitesse"
)


def generate_index_html(songs: list[dict]) -> None:
    free   = [s for s in songs if s['copyrightStatus'] in ("public-domain", "public domain")]
    locked = [s for s in songs if s['copyrightStatus'] not in ("public-domain", "public domain")]

    thead = _table_header(_TABLE_COLS)
    rows  = "".join(_song_row(s, public_only=True) for s in songs)

    html = f"""<!DOCTYPE html>
<html lang="fr">
<head><meta charset="UTF-8"><title>Partitions Harmonica</title>{_CSS}</head>
<body>
<h1>Partitions Harmonica</h1>
<nav>
  <a href="gammes/">📖 Gammes &amp; Scales</a>
</nav>
<br>
<h2>Compilation PDF complète</h2>
<ul>
  <li><a href="all_diatonique.pdf">Toutes les partitions diatoniques (PDF)</a></li>
  <li><a href="all_chromatique.pdf">Toutes les partitions chromatiques (PDF)</a></li>
</ul>
<p>
  {len(songs)} partitions · {len(free)} libres de droits · {len(locked)} sous droits
  <span title="{escape(_DIFFICULTY_HELP)}" style="cursor:help;margin-left:.5em">ℹ️</span>
</p>
<table id="data-table">
{thead}
<tbody>
{rows}
</tbody>
</table>
{_SORT_JS}
</body>
</html>
"""
    out = os.path.join(OUTPUT_DIR, "index.html")
    with open(out, "w", encoding="utf-8") as f:
        f.write(html)
    logger.info(f"✓ index.html généré ({len(songs)} partitions, {len(free)} libres)")


def generate_gammes_html(gammes: list[dict]) -> None:
    gammes_out = os.path.join(OUTPUT_DIR, GAMMES_SUBDIR)
    os.makedirs(gammes_out, exist_ok=True)

    cols = [
        ("Titre", "str"), ("Instrument", "str"),
        ("Diatonique", "str"), ("Chromatique", "str"), ("MP3", "str"), ("Droits", "str"),
    ]
    thead = _table_header(cols)

    rows = ""
    for g in gammes:
        title    = g['title'] or g['base']
        instru   = g.get('composer', '') or ""
        diat     = g['outputs']['diat']
        chro     = g['outputs']['chro']
        mp3s     = g['outputs']['mp3s']
        status   = g['copyrightStatus']
        rows += "<tr>"
        rows += f"<td data-sort='{escape(title.lower())}'>{escape(title)}</td>"
        rows += f"<td>{escape(instru)}</td>"
        rows += f"<td>{_pdf_links(diat)}</td>"
        rows += f"<td>{_pdf_links(chro)}</td>"
        rows += f"<td>{_mp3_link(mp3s)}</td>"
        rows += f"<td class='badge'>{copyright_icon(status)}</td>"
        rows += "</tr>\n"

    # links to merged gamme PDFs (if they exist)
    merged_links = ""
    for fname, label in [
        ("all_gammes_diatonique.pdf", "Toutes les gammes diatoniques (PDF)"),
        ("all_gammes_chromatique.pdf", "Toutes les gammes chromatiques (PDF)"),
    ]:
        if os.path.exists(os.path.join(gammes_out, fname)):
            merged_links += f'<li><a href="{escape(fname)}">{escape(label)}</a></li>\n'

    html = f"""<!DOCTYPE html>
<html lang="fr">
<head><meta charset="UTF-8"><title>Gammes Harmonica</title>{_CSS}</head>
<body>
<h1>Gammes &amp; Références</h1>
<nav>
  <a href="../">← Partitions</a>
</nav>
<br>
{f"<ul>{merged_links}</ul>" if merged_links else ""}
<p>{len(gammes)} fiches de gammes</p>
<table id="data-table">
{thead}
<tbody>
{rows}
</tbody>
</table>
{_SORT_JS}
</body>
</html>
"""
    out = os.path.join(gammes_out, "index.html")
    with open(out, "w", encoding="utf-8") as f:
        f.write(html)
    logger.info(f"✓ gammes/index.html généré ({len(gammes)} gammes)")


def generate_private_html(songs: list[dict], sha256_hash: str) -> None:
    thead = _table_header(_TABLE_COLS)
    rows  = "".join(_song_row(s, public_only=False) for s in songs)

    protected_content = f"""
<h1>Partitions Harmonica — Accès complet</h1>
<nav>
  <a href="gammes/">📖 Gammes</a>
</nav>
<br>
<ul>
  <li><a href="all_diatonique.pdf">Toutes les partitions diatoniques (PDF)</a></li>
  <li><a href="all_chromatique.pdf">Toutes les partitions chromatiques (PDF)</a></li>
</ul>
<p>{len(songs)} partitions (toutes, y compris sous droits)</p>
<table id="data-table">
{thead}
<tbody>
{rows}
</tbody>
</table>
{_SORT_JS}
"""

    login_form = f"""
<div id="login-section">
  <h2>🔒 Accès protégé</h2>
  <p>Entrez le mot de passe pour accéder aux partitions complètes.</p>
  <input type="password" id="pwd-input" placeholder="Mot de passe"
         onkeydown="if(event.key==='Enter')checkPwd()">
  <br>
  <button id="login-btn" onclick="checkPwd()">Connexion</button>
  <p id="login-error">Mot de passe incorrect.</p>
</div>
<div id="protected-content" style="display:none">
{protected_content}
</div>
<script>
(function(){{
  var H="{sha256_hash}";
  async function sha256(s){{
    var b=await crypto.subtle.digest("SHA-256",new TextEncoder().encode(s));
    return Array.from(new Uint8Array(b)).map(function(x){{return x.toString(16).padStart(2,"0");}}).join("");
  }}
  function show(){{
    document.getElementById("login-section").style.display="none";
    document.getElementById("protected-content").style.display="block";
  }}
  window.checkPwd=async function(){{
    var v=document.getElementById("pwd-input").value;
    var h=await sha256(v);
    if(h===H){{sessionStorage.setItem("ph",h);show();}}
    else{{document.getElementById("login-error").style.display="block";}}
  }};
  document.addEventListener("DOMContentLoaded",function(){{
    if(sessionStorage.getItem("ph")===H)show();
  }});
}})();
</script>
"""

    html = f"""<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<title>Partitions — Accès privé</title>
<meta name="robots" content="noindex,nofollow">
{_CSS}
</head>
<body>
{login_form}
</body>
</html>
"""
    out = os.path.join(OUTPUT_DIR, "private.html")
    with open(out, "w", encoding="utf-8") as f:
        f.write(html)
    logger.info(f"✓ private.html généré ({len(songs)} partitions, hash={sha256_hash[:8]}…)")


# --------- Summary ---------

def log_summary(songs: list[dict]) -> None:
    key_counts: dict[str, int]    = {}
    status_counts: dict[str, int] = {}
    lang_counts: dict[str, int]   = {}
    missing_diat = []
    missing_chro = []

    for meta in songs:
        k = key_to_french(meta.get("key", "unknown"))
        key_counts[k] = key_counts.get(k, 0) + 1
        s = meta.get("copyrightStatus", "unknown")
        status_counts[s] = status_counts.get(s, 0) + 1
        for lang in meta.get("lyricsLang", []):
            lang_counts[lang] = lang_counts.get(lang, 0) + 1
        if not meta['outputs']['diat']:
            missing_diat.append(meta['base'])
        if not meta['outputs']['chro']:
            missing_chro.append(meta['base'])

    logger.info(f"  Statuts copyright : {status_counts}")
    logger.info(f"  Clés : {key_counts}")
    if lang_counts:
        logger.info(f"  Langues : {lang_counts}")
    if missing_diat:
        logger.warning(f"  ⚠️  Sans diatonique : {missing_diat}")
    if missing_chro:
        logger.warning(f"  ⚠️  Sans chromatique : {missing_chro}")


# --------- Entry point ---------

def main() -> None:
    if not os.path.exists(OUTPUT_DIR):
        logger.error(f"❌ ERREUR: Le dossier '{OUTPUT_DIR}' n'existe pas!")
        sys.exit(1)

    logger.info("Lecture des partitions .ly...")
    songs  = collect_songs()
    gammes = collect_gammes()
    logger.info(f"✓ {len(songs)} partitions · {len(gammes)} gammes")

    generate_index_html(songs)
    generate_gammes_html(gammes)
    generate_private_html(songs, PRIVATE_HASH)
    log_summary(songs)


if __name__ == "__main__":
    main()
