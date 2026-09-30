"""Generate index.html, gammes/index.html, private.html and difficulte.html for the harmonica site."""

import hashlib
import logging
import os
import re
import sys
import unicodedata
from html import escape

import markdown
from jinja2 import Environment, FileSystemLoader, select_autoescape
from markdown.extensions.toc import slugify_unicode

import complexity
from complexity import analyze_difficulty, brace_block, difficulty_cell, strip_comments

logging.basicConfig(level=logging.INFO, format="%(message)s")
logger = logging.getLogger(__name__)

TEMPLATES_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "templates")
_jinja_env = Environment(
    loader=FileSystemLoader(TEMPLATES_DIR),
    autoescape=select_autoescape(["html", "svg", "xml"]),
    keep_trailing_newline=True,
    trim_blocks=True,
    lstrip_blocks=True,
)


def render(template_name: str, **context) -> str:
    return _jinja_env.get_template(template_name).render(**context)


# --------- Constants ---------

# Non-key-letter \diatonic*HarmonicaTab suffixes, mapped to their display label.
SPECIAL_TAB_LABELS: dict[str, str] = {
    'SuzukiFive': 'Suzuki 5',
}

COUNTRY_FLAGS: dict[str, str] = {
    'ar': '🇦🇷', 'at': '🇦🇹', 'ca': '🇨🇦', 'de': '🇩🇪', 'fr': '🇫🇷', 'gb': '🇬🇧',
    'ie': '🇮🇪', 'it': '🇮🇹', 'ru': '🇷🇺', 'us': '🇺🇸',
}

COUNTRY_NAMES: dict[str, str] = {
    'ar': 'Argentine', 'at': 'Autriche', 'ca': 'Canada', 'de': 'Allemagne', 'fr': 'France',
    'gb': 'Royaume-Uni', 'ie': 'Irlande', 'it': 'Italie', 'ru': 'Russie',
    'us': 'États-Unis',
}

OUTPUT_DIR     = "output"
PARTITIONS_DIR = "partitions"
GAMMES_DIR     = "gammes"
LIENS_UTILES_MD = "liens_utiles.md"

# Password hash for the private page (override with PRIVATE_PASSWORD env var)
_pw = os.environ.get("PRIVATE_PASSWORD") or "harmonica"
PRIVATE_HASH = hashlib.sha256(_pw.encode()).hexdigest()

# Cache-busting token: GitHub Pages / browsers cache PDFs and MP3s under the
# same filename across recompiles, so append the commit SHA to force a fresh
# fetch whenever the content actually changes.
CACHE_BUST = os.environ.get("GITHUB_SHA", "")[:7]


# --------- LilyPond metadata parsing ---------

_DIATONIC_TAB_RE = re.compile(r'\\diatonic([A-Za-z]*)HarmonicaTab')


def diatonic_harmonica_keys(content: str) -> str:
    """Harmonica key(s)/model(s) used for the diatonic tab (e.g. 'C', 'D+G' when
    the song needs a tuning change mid-piece, or 'Suzuki 5' for the 5-hole
    model), from \\diatonicHarmonicaTab / \\diatonicXHarmonicaTab calls. Bare
    \\diatonicHarmonicaTab means C."""
    keys = []
    for m in _DIATONIC_TAB_RE.finditer(strip_comments(content)):
        suffix = m.group(1) or "C"
        key = SPECIAL_TAB_LABELS.get(suffix, suffix)
        if key not in keys:
            keys.append(key)
    return "+".join(keys) if keys else "C"


def parse_ly_metadata(ly_path: str) -> dict:
    metadata: dict = {
        "copyrightStatus": "unknown", "lyricsLang": [],
        "key": "unknown", "composer": "", "title": "",
        "composerNationality": "", "difficulty": {}, "youtube": "",
        "diatonicHarmonicaKeys": "C",
    }
    if not os.path.exists(ly_path):
        logger.warning(f"  ⚠️  Fichier .ly introuvable : '{ly_path}'")
        return metadata

    with open(ly_path, encoding="utf-8") as f:
        content = f.read()

    _QUOTED = r'((?:[^"\\]|\\.)*)'  # matches content inside "..." tolerating \"

    def find(pattern, flags=0):
        m = re.search(pattern, content, flags)
        if not m:
            return ""
        return m.group(1).strip().replace('\\"', '"')

    metadata["copyrightStatus"]      = find(rf'copyrightStatus\s*=\s*"{_QUOTED}"') or "unknown"
    metadata["composer"]             = find(rf'^\s*composer\s*=\s*"{_QUOTED}"', re.MULTILINE)
    if not metadata["composer"]:
        # Fallback: extract text from \markup { ... } form (skip URL strings)
        m_markup = re.search(r'composer\s*=\s*\\markup\s*\{', content)
        if m_markup:
            block = brace_block(content, m_markup.end())
            for s in re.findall(r'"([^"]+)"', block):
                if not s.startswith('http') and s.strip():
                    metadata["composer"] = s.strip()
                    break
    metadata["title"]                = find(rf'^\s*title\s*=\s*"{_QUOTED}"', re.MULTILINE)
    metadata["composerNationality"]  = find(rf'composerNationality\s*=\s*"{_QUOTED}"')
    metadata["youtube"]               = find(rf'youtube\s*=\s*"{_QUOTED}"')

    m = re.search(r'lyricsLang\s*=\s*#\'\(([^)]*)\)', content)
    if m:
        metadata["lyricsLang"] = m.group(1).split()

    m = re.search(r'\\key\s+([a-z]+)\s+\\major', content)
    if m:
        metadata["key"] = m.group(1)

    metadata["difficulty"] = analyze_difficulty(content)
    metadata["diatonicHarmonicaKeys"] = diatonic_harmonica_keys(content)
    return metadata


def copyright_icon(status: str) -> str:
    return {
        "public-domain": "🆓", "copyrighted": "©",
        "arrangement-copyrighted": "©✍️", "unknown": "⚠️", "forbidden": "🚫",
    }.get(status, "⚠️")


def copyright_cell(status: str, composer: str) -> str:
    icon = copyright_icon(status)
    if status in ("public-domain", "public domain"):
        tooltip = "Domaine public — libre de droits"
    elif status == "unknown":
        tooltip = "Statut inconnu"
    elif status == "forbidden":
        tooltip = "Reproduction interdite"
    else:
        m = re.search(r'\((?:\d{4})\s*[–\-]\s*(\d{4})\)', composer)
        if m:
            free_year = int(m.group(1)) + 71
            tooltip = f"Sous droits — libre à partir du 1er janvier {free_year} (70 ans après la mort de l'auteur)"
        else:
            tooltip = "Sous droits — libre 70 ans après la mort de l'auteur"
    return f"<td class='badge' data-sort='{escape(status)}' title='{escape(tooltip)}'>{icon}</td>"


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

def title_sort_key(s: str) -> str:
    """Accent- and case-insensitive sort key for French titles."""
    return unicodedata.normalize('NFD', s or '').encode('ascii', 'ignore').decode('ascii').lower()


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
    """Scan partitions/*.ly and return enriched song list."""
    if not os.path.isdir(PARTITIONS_DIR):
        logger.warning(f"⚠️  Dossier '{PARTITIONS_DIR}' introuvable")
        return []
    songs = []
    for fname in sorted(os.listdir(PARTITIONS_DIR)):
        if not fname.endswith(".ly"):
            continue
        full = os.path.join(PARTITIONS_DIR, fname)
        if not os.path.isfile(full):
            continue
        base = fname[:-3]
        meta = parse_ly_metadata(full)
        meta['base'] = base
        meta['outputs'] = collect_outputs(base, OUTPUT_DIR)
        songs.append(meta)
    songs.sort(key=lambda s: title_sort_key(s.get('title') or s['base']))
    return songs


def collect_gammes() -> list[dict]:
    """Scan gammes/*.ly and return enriched gamme list."""
    gammes_out = os.path.join(OUTPUT_DIR, "gammes")
    if not os.path.isdir(GAMMES_DIR):
        return []
    gammes = []
    for fname in sorted(os.listdir(GAMMES_DIR)):
        if not fname.endswith(".ly"):
            continue
        full = os.path.join(GAMMES_DIR, fname)
        if not os.path.isfile(full):
            continue
        base = fname[:-3]
        meta = parse_ly_metadata(full)
        meta['base'] = base
        meta['outputs'] = collect_outputs(base, gammes_out)
        gammes.append(meta)
    gammes.sort(key=lambda g: title_sort_key(g.get('title') or g['base']))
    return gammes


# --------- HTML helpers ---------
#
# Page shells live under templates/ (Jinja2); the helpers below only build
# the small, data-driven HTML snippets (table cells, player controls, ...)
# that get passed into those templates.


def _cache_bust(url: str) -> str:
    return f"{url}?v={CACHE_BUST}" if CACHE_BUST else url


def _mp3_link(files: list[str], prefix: str = "") -> str:
    if not files:
        return "<span class='hidden'>—</span>"
    return f"<a href='{escape(_cache_bust(prefix + files[0]))}'>MP3</a>"


def _youtube_video_id(url: str) -> str:
    if not url:
        return ""
    m = re.search(r'(?:youtube\.com/watch\?v=|youtu\.be/|youtube\.com/embed/)([A-Za-z0-9_-]{11})', url)
    return m.group(1) if m else ""


_SPEED_OPTIONS = [0.25, 0.5, 0.75, 1, 1.25, 1.5, 2]


def _speed_select_html(onchange_js: str) -> str:
    """Shared 0.25x-2x playback-speed <select>, used by both the MP3 and YouTube controls."""
    opts = "".join(
        f'<option value="{v}"{" selected" if v == 1 else ""}>{v}×</option>'
        for v in _SPEED_OPTIONS
    )
    return f'<select onchange="{onchange_js}" title="Vitesse de lecture">{opts}</select>'


def _nav_link_html(direction: str, href: str, title: str) -> str:
    """Prev/next-song arrow shown at either end of the player header.
    Rendered as a disabled span (no href) at the start/end of the list."""
    arrow = "◀" if direction == "prev" else "▶"
    cls = f"nav-{direction}"
    if not href:
        return f"<span class='{cls} nav-disabled' aria-hidden='true'>{arrow}</span>"
    return f"<a class='{cls}' href='{escape(href)}' title='{escape(title)}'>{arrow}</a>"


def _player_page_html(
    title: str, mp3_file: str, pdf_files: list[str], back_href: str, youtube_id: str = "",
    prev_href: str = "", prev_title: str = "", next_href: str = "", next_title: str = "",
) -> str:
    prev_btn = _nav_link_html("prev", prev_href, prev_title)
    next_btn = _nav_link_html("next", next_href, next_title)
    if mp3_file:
        audio_html = f"""\
<div id="audio-controls">
  <audio id='audio-player' controls src='{escape(_cache_bust(mp3_file))}'>
    Votre navigateur ne supporte pas la lecture audio.
  </audio>
  <button class="play-btn" onclick="audioPlay()" title="Démarrer depuis le début">▶ Play</button>
  <button class="play-btn" id="audio-play-delay" onclick="audioPlayDelayed()"
          title="Démarrer depuis le début après un compte à rebours de 3 secondes">▶ Play in 3s</button>
  {_speed_select_html("audioSetSpeed(this.value)")}
</div>"""
        audio_script = f"<script>\n{render('partials/audio.js')}</script>"
    else:
        audio_html = "<span id='no-audio'>Pas d'enregistrement audio disponible</span>"
        audio_script = ""
    if youtube_id:
        yt_toggle = render("partials/youtube_toggle.html").rstrip("\n")
        yt_html = render(
            "partials/youtube_block.html",
            video_id=youtube_id,
            speed_select=_speed_select_html("ytSetSpeed(this.value)"),
        ).rstrip("\n")
        yt_script = render("partials/youtube_script.js", video_id=youtube_id).rstrip("\n")
    else:
        yt_toggle = yt_html = yt_script = ""
    pdf_html = "".join(
        f"<iframe class='pdf-page' src='{escape(_cache_bust(f))}'></iframe>"
        for f in pdf_files
    )
    return render(
        "player.html",
        title=title,
        back_href=back_href,
        prev_btn=prev_btn, next_btn=next_btn,
        yt_toggle=yt_toggle, yt_html=yt_html, yt_script=yt_script,
        audio_html=audio_html, audio_script=audio_script,
        pdf_html=pdf_html,
    )


def _write_player_page(
    output_dir: str, base: str, tuning: str, title: str,
    pdf_files: list[str], mp3_files: list[str], back_href: str, prefix: str = "",
    youtube_url: str = "", prev_song: dict | None = None, next_song: dict | None = None,
) -> str:
    """Write a standalone page combining the sheet music PDF with a sticky audio player."""
    fname = f"{base}_{tuning}.html"
    mp3_file = prefix + mp3_files[0] if mp3_files else ""

    def _neighbor(song: dict | None) -> tuple[str, str]:
        if not song:
            return "", ""
        return f"{prefix}{song['base']}_{tuning}.html", song['title'] or song['base']

    prev_href, prev_title = _neighbor(prev_song)
    next_href, next_title = _neighbor(next_song)
    html = _player_page_html(
        title=f"{title} — {tuning.capitalize()}",
        mp3_file=mp3_file,
        pdf_files=[prefix + f for f in pdf_files],
        back_href=back_href,
        youtube_id=_youtube_video_id(youtube_url),
        prev_href=prev_href, prev_title=f"Précédent : {prev_title}" if prev_title else "",
        next_href=next_href, next_title=f"Suivant : {next_title}" if next_title else "",
    )
    with open(os.path.join(output_dir, fname), "w", encoding="utf-8") as fh:
        fh.write(html)
    return fname


def _pdf_cell(
    files: list[str], mp3_files: list[str], output_dir: str, base: str, tuning: str,
    title: str, back_href: str, prefix: str = "", youtube_url: str = "",
    prev_song: dict | None = None, next_song: dict | None = None, harmonica_keys: str = "",
) -> str:
    if not files:
        return "<span class='hidden'>—</span>"
    fname = _write_player_page(
        output_dir, base, tuning, title, files, mp3_files, back_href, prefix, youtube_url,
        prev_song, next_song,
    )
    href = escape(prefix + fname)
    if harmonica_keys:
        return f"<a class='harmo-key' href='{href}' title='Écouter + partition — harmonica {escape(harmonica_keys)}'>{escape(harmonica_keys)}</a>"
    return f"<a href='{href}' title='Écouter + partition'>🎵🎼</a>"


def _table_header(cols: list[tuple]) -> str:
    """cols = list of (label, css_class)."""
    def _th(label: str, cls: str) -> str:
        class_attr = f" class='{cls}'" if cls else ""
        return f"<th onclick='sortTable(this)'{class_attr}>{escape(label)}</th>"
    ths = "".join(_th(label, cls) for label, cls in cols)
    return f"<thead><tr>{ths}</tr></thead>"


def _build_nav_maps(songs: list[dict]) -> dict[str, dict[str, tuple]]:
    """For 'diat' and 'chro', map a song's base -> (prev_song, next_song) among the
    songs that actually have a page for that tuning, in table order."""
    maps: dict[str, dict[str, tuple]] = {}
    for tuning_key in ("diat", "chro"):
        ordered = [s for s in songs if s["outputs"][tuning_key]]
        nav = {}
        for i, s in enumerate(ordered):
            prev_s = ordered[i - 1] if i > 0 else None
            next_s = ordered[i + 1] if i + 1 < len(ordered) else None
            nav[s["base"]] = (prev_s, next_s)
        maps[tuning_key] = nav
    return maps


def _song_row(meta: dict, public_only: bool, pdf_prefix: str = "", nav_maps: dict | None = None) -> str:
    base      = meta['base']
    status    = meta['copyrightStatus']
    lyrics    = meta['lyricsLang']
    key       = key_to_french(meta['key'])
    composer  = meta['composer']
    title     = meta['title'] or base
    nat        = meta['composerNationality'].lower()
    flag_emoji = COUNTRY_FLAGS.get(nat, '')
    country    = COUNTRY_NAMES.get(nat, '')
    flag       = f"<span title='{escape(country)}'>{flag_emoji}</span>" if flag_emoji and country else flag_emoji
    diff       = meta['difficulty']
    youtube    = meta.get('youtube', '')
    diat_keys  = meta.get('diatonicHarmonicaKeys', 'C')
    outputs    = meta['outputs']
    diat       = outputs['diat']
    chro       = outputs['chro']
    mp3s       = outputs['mp3s']

    composer_cell = f"{flag} {escape(composer)}".strip() if composer else flag
    key_num = {
        'do': 0, 'ré': 2, 'mi': 4, 'fa': 5, 'sol': 7, 'la': 9, 'si': 11,
    }.get(key.lower().split('♭')[0].split('♯')[0], 0)

    is_free = status in ("public-domain", "public domain")
    show_links = is_free or not public_only

    nav_maps = nav_maps or {}
    diat_prev, diat_next = nav_maps.get("diat", {}).get(base, (None, None))
    chro_prev, chro_next = nav_maps.get("chro", {}).get(base, (None, None))

    row  = "<tr>"
    row += f"<td data-sort='{escape(title.lower())}'>{escape(title)}</td>"
    row += f"<td data-sort='{escape(composer.lower())}'>{composer_cell}</td>"
    row += f"<td data-sort='{key_num}'>{escape(key)}</td>"
    if show_links:
        row += f"<td class='col-pdf'>{_pdf_cell(diat, mp3s, OUTPUT_DIR, base, 'diatonique', title, 'index.html', pdf_prefix, youtube, diat_prev, diat_next, diat_keys)}</td>"
        row += difficulty_cell(diff)
        row += f"<td class='col-pdf'>{_pdf_cell(chro, mp3s, OUTPUT_DIR, base, 'chromatique', title, 'index.html', pdf_prefix, youtube, chro_prev, chro_next)}</td>"
    else:
        row += "<td class='hidden col-pdf'>—</td>"
        row += difficulty_cell(diff)
        row += "<td class='hidden col-pdf'>—</td>"
    row += f"<td class='badge'>{lyrics_icon(lyrics)}</td>"
    row += copyright_cell(status, composer)
    row += "</tr>\n"
    return row


# --------- Page generators ---------

_TABLE_COLS = [
    ("Œuvre", ""), ("Compositeur", ""), ("Clé", ""),
    ("Diatonique", "col-pdf"), ("Difficulté 🎵", ""),
    ("Chromatique", "col-pdf"),
    ("Paroles", ""), ("Droits", ""),
]

_DIFFICULTY_HELP = (
    "🟢 facile · 🟡 moyen · 🔴 difficile — "
    "↕ bends · ⊕ overblows · ⊗ overdraws · ↔ grands écarts · ▲ aigus — vitesse"
)


def generate_index_html(songs: list[dict]) -> None:
    free   = [s for s in songs if s['copyrightStatus'] in ("public-domain", "public domain")]
    locked = [s for s in songs if s['copyrightStatus'] not in ("public-domain", "public domain")]

    nav_maps = _build_nav_maps(songs)
    thead = _table_header(_TABLE_COLS)
    rows  = "".join(_song_row(s, public_only=True, nav_maps=nav_maps) for s in songs)

    html = render(
        "index.html",
        title="Partitions Harmonica",
        title_html="<h1>Partitions Harmonica</h1>",
        songs_count=len(songs), free_count=len(free), locked_count=len(locked),
        difficulty_help=_DIFFICULTY_HELP,
        thead=thead, rows=rows,
    )
    out = os.path.join(OUTPUT_DIR, "index.html")
    with open(out, "w", encoding="utf-8") as f:
        f.write(html)
    logger.info(f"✓ index.html généré ({len(songs)} partitions, {len(free)} libres)")


def generate_gammes_html(gammes: list[dict]) -> None:
    gammes_out = os.path.join(OUTPUT_DIR, "gammes")
    os.makedirs(gammes_out, exist_ok=True)

    cols = [
        ("Titre", ""), ("Instrument", ""),
        ("Diatonique", "col-pdf"), ("Chromatique", "col-pdf"), ("MP3", ""), ("Droits", ""),
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
        rows += f"<td class='col-pdf'>{_pdf_cell(diat, mp3s, gammes_out, g['base'], 'diatonique', title, 'index.html')}</td>"
        rows += f"<td class='col-pdf'>{_pdf_cell(chro, mp3s, gammes_out, g['base'], 'chromatique', title, 'index.html')}</td>"
        rows += f"<td>{_mp3_link(mp3s)}</td>"
        rows += copyright_cell(status, instru)
        rows += "</tr>\n"

    # links to merged gamme PDFs (if they exist)
    merged_links = ""
    for fname, label in [
        ("all_gammes_diatonique.pdf", "Toutes les gammes diatoniques (PDF)"),
        ("all_gammes_chromatique.pdf", "Toutes les gammes chromatiques (PDF)"),
    ]:
        if os.path.exists(os.path.join(gammes_out, fname)):
            merged_links += f'<li><a href="{escape(_cache_bust(fname))}">{escape(label)}</a></li>\n'

    html = render(
        "gammes.html",
        title="Gammes Harmonica",
        title_html="<h1>Gammes &amp; Références</h1>",
        merged_links=merged_links,
        gammes_count=len(gammes),
        thead=thead, rows=rows,
    )
    out = os.path.join(gammes_out, "index.html")
    with open(out, "w", encoding="utf-8") as f:
        f.write(html)
    logger.info(f"✓ gammes/index.html généré ({len(gammes)} gammes)")


def generate_private_html(songs: list[dict], sha256_hash: str) -> None:
    nav_maps = _build_nav_maps(songs)
    thead = _table_header(_TABLE_COLS)
    rows  = "".join(_song_row(s, public_only=False, nav_maps=nav_maps) for s in songs)

    html = render(
        "private.html",
        title="Partitions — Accès privé",
        title_html="<h1>Partitions Harmonica — Accès complet</h1>",
        sha256_hash=sha256_hash,
        songs_count=len(songs),
        thead=thead, rows=rows,
        all_diatonique_href=_cache_bust("all_diatonique.pdf"),
        all_chromatique_href=_cache_bust("all_chromatique.pdf"),
        all_partition_href=_cache_bust("all_partition.pdf"),
        all_suzuki5_href=_cache_bust("all_suzuki5.pdf"),
    )
    out = os.path.join(OUTPUT_DIR, "private.html")
    with open(out, "w", encoding="utf-8") as f:
        f.write(html)
    logger.info(f"✓ private.html généré ({len(songs)} partitions, hash={sha256_hash[:8]}…)")


def generate_liens_utiles_html(md_path: str = LIENS_UTILES_MD) -> None:
    """Convert liens_utiles.md to a standalone HTML page in the output dir."""
    if not os.path.exists(md_path):
        logger.warning(f"⚠️  Fichier '{md_path}' introuvable")
        return

    with open(md_path, encoding="utf-8") as f:
        text = f.read()
    body = markdown.markdown(
        text,
        extensions=["toc"],
        extension_configs={"toc": {"slugify": slugify_unicode}},
        tab_length=2,
    )

    extra_style = """\
.content{background:var(--surface);padding:1.5em 2em;border:1px solid var(--border);
         border-radius:4px;max-width:900px}
.content h1{margin-top:0}
.content ul{padding-left:1.4em}
.content a{color:var(--accent)}"""

    html = render(
        "content_page.html",
        title="Liens utiles",
        extra_style=extra_style,
        content=body,
    )
    out = os.path.join(OUTPUT_DIR, "liens-utiles.html")
    with open(out, "w", encoding="utf-8") as f:
        f.write(html)
    logger.info("✓ liens-utiles.html généré")


def _fr_num(x: float) -> str:
    """Format a number the French way (0.5 -> '0,5', 3.0 -> '3')."""
    return f"{x:g}".replace(".", ",")


def _mn(x: float) -> str:
    return f"<mn>{_fr_num(x)}</mn>"


def generate_difficulte_html() -> None:
    """Document the difficulty formula of complexity.py, with its current weights."""
    c = complexity
    s = c.JUMP_MIN_HOLES
    speed_rows = "".join(
        f"<tr><td>{badge}</td><td>{label}</td><td>V ≥ {_fr_num(threshold)}</td></tr>\n"
        for threshold, badge, label in c.SPEED_LEVELS
    )

    extra_style = """\
.content{background:var(--surface);padding:1.5em 2em;border:1px solid var(--border);
         border-radius:4px;max-width:900px}
.content h1{margin-top:0}
.content a{color:var(--accent)}
.content math[display=block]{margin:1em 0;font-size:1.15em}
.content table{width:auto}"""

    content = f"""\
<h1>Calcul de la difficulté</h1>

<p>La difficulté de chaque partition est calculée automatiquement à partir de la mélodie
du fichier LilyPond (variable <code>melodie</code>), pour l'harmonica diatonique utilisé par
la tablature : Richter 10 trous (Do, Ré, Mi, Fa, Sol, La, Si♭) ou Suzuki 5 trous.</p>

<h2>1. Position des notes</h2>
<p>Chaque note est convertie en écart en demi-tons par rapport à la tonique de l'harmonica,
puis associée à un trou <i>h</i> et à une technique (souffle/aspiré, bend, overblow, overdraw),
avec la même table que la tablature. Les notes hors de la tessiture sont ignorées.</p>

<h2>2. Score technique <i>T</i></h2>
<table>
<thead><tr><th>Symbole</th><th>Variable</th><th>Ce qui est compté</th><th>Poids</th></tr></thead>
<tbody>
<tr><td>↕</td><td><i>B</i></td><td>notes demandant un bend (altération)</td><td>{_fr_num(c.WEIGHT_BEND)}</td></tr>
<tr><td>⊕</td><td><i>O</i></td><td>notes demandant un overblow</td><td>{_fr_num(c.WEIGHT_OVERBLOW)}</td></tr>
<tr><td>⊗</td><td><i>D</i></td><td>notes demandant un overdraw</td><td>{_fr_num(c.WEIGHT_OVERDRAW)}</td></tr>
<tr><td>↔</td><td><i>J</i></td><td>grands écarts : sauts d'au moins {s} trous entre deux notes successives,
  pondérés par leur taille</td><td>{_fr_num(c.WEIGHT_JUMP)}</td></tr>
<tr><td>▲</td><td><i>A</i></td><td>notes jouées dans les aigus (trous {c.HIGH_HOLE_MIN} et 10)</td><td>{_fr_num(c.WEIGHT_HIGH)}</td></tr>
</tbody>
</table>

<math display="block">
  <mi>T</mi><mo>=</mo>
  <msub><mi>w</mi><mi>B</mi></msub><mi>B</mi><mo>+</mo>
  <msub><mi>w</mi><mi>O</mi></msub><mi>O</mi><mo>+</mo>
  <msub><mi>w</mi><mi>D</mi></msub><mi>D</mi><mo>+</mo>
  <msub><mi>w</mi><mi>J</mi></msub><mi>J</mi><mo>+</mo>
  <msub><mi>w</mi><mi>A</mi></msub><mi>A</mi>
</math>

<p>Avec les poids actuels :</p>
<math display="block">
  <mi>T</mi><mo>=</mo>
  {_mn(c.WEIGHT_BEND)}<mi>B</mi><mo>+</mo>
  {_mn(c.WEIGHT_OVERBLOW)}<mi>O</mi><mo>+</mo>
  {_mn(c.WEIGHT_OVERDRAW)}<mi>D</mi><mo>+</mo>
  {_mn(c.WEIGHT_JUMP)}<mi>J</mi><mo>+</mo>
  {_mn(c.WEIGHT_HIGH)}<mi>A</mi>
</math>

<p>En notant <i>h<sub>i</sub></i> le trou de la <i>i</i>-ème note et
<i>s</i> = {s} le seuil d'un grand écart :</p>
<math display="block">
  <mi>J</mi><mo>=</mo>
  <munder>
    <mo>∑</mo>
    <mrow><mi>i</mi><mo>:</mo><mo>|</mo><msub><mi>h</mi><mi>i</mi></msub><mo>−</mo>
      <msub><mi>h</mi><mrow><mi>i</mi><mo>−</mo><mn>1</mn></mrow></msub><mo>|</mo><mo>≥</mo><mi>s</mi></mrow>
  </munder>
  <mrow><mo>(</mo><mo>|</mo><msub><mi>h</mi><mi>i</mi></msub><mo>−</mo>
    <msub><mi>h</mi><mrow><mi>i</mi><mo>−</mo><mn>1</mn></mrow></msub><mo>|</mo>
    <mo>−</mo><mi>s</mi><mo>+</mo><mn>1</mn><mo>)</mo></mrow>
  <mspace width="2em"/>
  <mi>A</mi><mo>=</mo>
  <mo>#</mo><mrow><mo>{{</mo><mi>i</mi><mo>:</mo><msub><mi>h</mi><mi>i</mi></msub><mo>≥</mo>{_mn(c.HIGH_HOLE_MIN)}<mo>}}</mo></mrow>
</math>

<p>Un saut de {s} trous compte donc 1, un saut de {s + 1} trous compte 2, etc.
Le badge ↔ affiche le nombre de grands écarts, et <i>J</i> leur somme pondérée.</p>

<table>
<thead><tr><th>Niveau</th><th>Condition</th></tr></thead>
<tbody>
<tr><td>🟢 facile</td><td>T = 0</td></tr>
<tr><td>🟡 moyen</td><td>0 &lt; T ≤ {_fr_num(c.LEVEL_MEDIUM_MAX)}</td></tr>
<tr><td>🔴 difficile</td><td>T &gt; {_fr_num(c.LEVEL_MEDIUM_MAX)}</td></tr>
</tbody>
</table>

<h2>3. Indice de vitesse <i>V</i></h2>
<p>À partir du tempo (<code>\\tempo 4 = …</code>, {c.DEFAULT_TEMPO} par défaut) et de la plus petite
valeur de note <i>d</i> de la mélodie (4 = noire, 8 = croche, 16 = double croche ;
{c.DEFAULT_FASTEST} par défaut) :</p>
<math display="block">
  <mi>V</mi><mo>=</mo>
  <mfrac><mrow><mi>tempo</mi><mo>×</mo><mi>d</mi></mrow>{_mn(c.SPEED_DIVISOR)}</mfrac>
</math>
<table>
<thead><tr><th></th><th>Vitesse</th><th>Condition</th></tr></thead>
<tbody>
{speed_rows}</tbody>
</table>

<h2>4. Tri de la colonne Difficulté</h2>
<math display="block"><mi>S</mi><mo>=</mo><mi>T</mi><mo>+</mo><mi>V</mi></math>

<h2>Limites</h2>
<ul>
  <li>Les notes sont comptées, pas les passages : une chanson longue a un score plus élevé.</li>
  <li>Les silences et les respirations ne sont pas pris en compte dans les écarts.</li>
  <li>Un seul accordage est utilisé par partition (un changement d'harmonica en cours de morceau est ignoré).</li>
</ul>
"""

    html = render(
        "content_page.html",
        title="Calcul de la difficulté",
        extra_style=extra_style,
        content=content,
    )
    out = os.path.join(OUTPUT_DIR, "difficulte.html")
    with open(out, "w", encoding="utf-8") as f:
        f.write(html)
    logger.info("✓ difficulte.html généré")


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
    generate_liens_utiles_html()
    generate_difficulte_html()
    log_summary(songs)


if __name__ == "__main__":
    main()
