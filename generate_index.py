import logging
import os
import re
import sys
from html import escape

logging.basicConfig(level=logging.INFO, format="%(message)s")
logger = logging.getLogger(__name__)

# --------- Constantes harmonica ---------

# Classes de semitones pour les noms de notes (Do/C = 0)
FRENCH_NOTES = {'sol': 7, 'do': 0, 're': 2, 'mi': 4, 'fa': 5, 'la': 9, 'si': 11}
ENGLISH_NOTES = {'c': 0, 'd': 2, 'e': 4, 'f': 5, 'g': 7, 'a': 9, 'b': 11}

# Décalage de la note racine (au-dessus de Do) selon l'accordage
TUNING_ROOTS = {
    'diatonicHarmonicaTab': 0,
    'diatonicDHarmonicaTab': 2,
    'diatonicGHarmonicaTab': 7,
    'diatonicAHarmonicaTab': 9,
    'diatonicFHarmonicaTab': 5,
    'diatonicBbHarmonicaTab': 10,
}

# Décalages (depuis la racine de l'harmonica, 0 = trou 1 soufflé) nécessitant une technique spéciale.
# Tirés directement de la fonction get-diatonic-ritcher-tab dans harmonica.ly.
BEND_OFFSETS    = {1, 5, 6, 8, 9, 10, 13, 20, 27, 30, 34, 35}
OVERBLOW_OFFSETS = {3, 15, 18, 22}
OVERDRAW_OFFSETS = {25, 32}

# Drapeaux de nationalité (codes ISO 3166-1 alpha-2)
COUNTRY_FLAGS: dict[str, str] = {
    'ar': '🇦🇷', 'at': '🇦🇹', 'de': '🇩🇪', 'fr': '🇫🇷', 'gb': '🇬🇧',
    'ie': '🇮🇪', 'it': '🇮🇹', 'ru': '🇷🇺', 'us': '🇺🇸',
}


# --------- Analyse de difficulté ---------

def _strip_comments(text: str) -> str:
    text = re.sub(r'%\{.*?%\}', '', text, flags=re.DOTALL)
    return re.sub(r'%[^\n]*', '', text)


def _brace_block(text: str, start: int) -> str:
    """Retourne le contenu entre accolades appariées à partir de `start` (après le `{`)."""
    depth, i = 1, start
    while i < len(text) and depth:
        c = text[i]
        if c == '{':
            depth += 1
        elif c == '}':
            depth -= 1
        i += 1
    return text[start:i - 1]


def analyze_difficulty(content: str) -> dict:
    """
    Analyse un fichier LilyPond et retourne les métriques de difficulté pour l'harmonica
    diatonique : nombre de bends, overblows, overdraws, tempo, valeur de note la plus courte.
    """
    content = _strip_comments(content)
    is_french = bool(re.search(r'language\s*"fran', content))
    notes_map = FRENCH_NOTES if is_french else ENGLISH_NOTES

    # Accordage de l'harmonica → décalage de la racine
    root = 0
    for fn, r in TUNING_ROOTS.items():
        if re.search(rf'\\{fn}\b', content):
            root = r
            break

    # Tempo : \tempo N = BPM ou \tempo N. = BPM
    tempo = None
    m = re.search(r'\\tempo\s+\d+\.?\s*=\s*(\d+)', content)
    if m:
        tempo = int(m.group(1))

    # Bloc mélodique
    m_mel = re.search(r'\bmelodie\s*=\s*\{', content)
    melody = _brace_block(content, m_mel.end()) if m_mel else content

    # Hauteur de départ pour le mode \relative (cherche dans tout le fichier)
    current = 60  # Do4 = MIDI 60 par défaut
    names_sorted = sorted(notes_map.keys(), key=len, reverse=True)
    names_alt = '|'.join(names_sorted)
    m_rel = re.search(rf'\\relative\s+({names_alt})([\',]*)', content)
    if m_rel:
        start_class = notes_map[m_rel.group(1)]
        mods = m_rel.group(2)
        # Do sans modificateur = Do3 (MIDI 48), Do' = Do4 (MIDI 60), Do'' = Do5 (MIDI 72)
        current = 48 + start_class + mods.count("'") * 12 - mods.count(",") * 12

    # Nettoyage du bloc mélodique pour réduire les faux positifs
    melody = re.sub(r'\\[a-zA-Z]+(?:\s*\{[^{}]*\})?', ' ', melody)
    melody = re.sub(r'"[^"]*"', ' ', melody)
    melody = re.sub(r'#[^|\n{} ]*', ' ', melody)

    # Regex de note : Français ou Anglais
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
        name = m.group(1)
        acc = m.group(2) or ''
        oct_str = m.group(3) or ''
        dur_str = m.group(4)

        # Classe chromatique de la note (0–11)
        base = notes_map.get(name, 0)
        if is_french:
            base += acc.count('d') - acc.count('b')
        else:
            if 'isis' in acc:   base += 2
            elif 'is' in acc:   base += 1
            elif 'eses' in acc: base -= 2
            elif 'es' in acc:   base -= 1
        base %= 12

        # Résolution du mode relatif : choisit l'octave la plus proche
        diff_up = (base - current % 12) % 12
        abs_p = (current + diff_up) if diff_up <= 6 else (current - (12 - diff_up))
        abs_p += oct_str.count("'") * 12 - oct_str.count(",") * 12
        current = abs_p

        # Note la plus courte (valeur de durée la plus grande = durée réelle la plus courte)
        if dur_str:
            d = int(dur_str)
            if fastest is None or d > fastest:
                fastest = d

        # Classement selon la table de l'harmonica diatonique
        offset = abs_p - 60 - root
        if offset in BEND_OFFSETS:
            bends += 1
        elif offset in OVERBLOW_OFFSETS:
            overblows += 1
        elif offset in OVERDRAW_OFFSETS:
            overdraws += 1

    return {
        'bends': bends,
        'overblows': overblows,
        'overdraws': overdraws,
        'tempo': tempo,
        'fastest_note': fastest,
    }


def difficulty_cell(diff: dict) -> str:
    """Génère le contenu HTML de la cellule de difficulté."""
    bends     = diff.get('bends', 0)
    overblows = diff.get('overblows', 0)
    overdraws = diff.get('overdraws', 0)
    tempo     = diff.get('tempo') or 100
    fastest   = diff.get('fastest_note') or 4

    # Score de vitesse ≈ notes par seconde
    speed = tempo * fastest / 240

    if speed >= 7:
        speed_badge, speed_label = '⚡', 'très rapide'
    elif speed >= 4:
        speed_badge, speed_label = '🏃', 'rapide'
    elif speed >= 2:
        speed_badge, speed_label = '🎵', 'modéré'
    else:
        speed_badge, speed_label = '🐢', 'lent'

    # Niveau global
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

    tooltip = escape(' | '.join(details))
    content = ' '.join(parts)
    return f"<td title='{tooltip}' style='white-space:nowrap'>{content}</td>"


# --------- Parsing LilyPond ---------

dossier = "output"

if not os.path.exists(dossier):
    logger.error(f"❌ ERREUR: Le dossier '{dossier}' n'existe pas!")
    sys.exit(1)

fichiers = os.listdir(dossier)
logger.info(f"✓ {len(fichiers)} fichiers trouvés dans '{dossier}'")

if not os.path.exists("partitions"):
    logger.warning("⚠️  ATTENTION: Le dossier 'partitions' n'existe pas!")


def parse_ly_metadata(base_name: str) -> dict:
    """
    Cherche un fichier .ly correspondant et extrait toutes les métadonnées :
    titre, compositeur, nationalité, copyright, paroles, tonalité, difficulté.
    """
    ly_file = os.path.join("partitions", f"{base_name}.ly")
    if not os.path.exists(ly_file):
        ly_file = os.path.join(dossier, f"{base_name}.ly")

    metadata: dict = {
        "copyrightStatus": "unknown",
        "lyricsLang": [],
        "key": "unknown",
        "composer": "",
        "title": "",
        "composerNationality": "",
        "difficulty": {},
    }

    if not os.path.exists(ly_file):
        logger.warning(f"  ⚠️  Fichier .ly introuvable pour '{base_name}'")
        return metadata

    with open(ly_file, "r", encoding="utf-8") as f:
        content = f.read()

    def find(pattern, flags=0):
        m = re.search(pattern, content, flags)
        return m.group(1).strip() if m else ""

    metadata["copyrightStatus"] = find(r'copyrightStatus\s*=\s*"([^"]+)"') or "unknown"
    metadata["composer"]         = find(r'^\s*composer\s*=\s*"([^"]*)"', re.MULTILINE)
    metadata["title"]            = find(r'^\s*title\s*=\s*"([^"]*)"', re.MULTILINE)
    metadata["composerNationality"] = find(r'composerNationality\s*=\s*"([^"]*)"')

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
        "public-domain": "🆓",
        "copyrighted": "©",
        "arrangement-copyrighted": "©✍️",
        "unknown": "⚠️",
        "forbidden": "🚫",
    }.get(status, "⚠️")


def lyrics_icon(langs: list) -> str:
    icons = {
        "fr": "🇫🇷", "en": "🇬🇧", "de": "🇩🇪", "es": "🇪🇸",
        "it": "🇮🇹", "pt": "🇵🇹", "nl": "🇳🇱", "pl": "🇵🇱",
        "ru": "🇷🇺", "sv": "🇸🇪", "da": "🇩🇰", "no": "🇳🇴",
        "fi": "🇫🇮", "el": "🇬🇷", "cs": "🇨🇿", "ro": "🇷🇴",
        "hu": "🇭🇺", "bg": "🇧🇬", "hr": "🇭🇷", "sk": "🇸🇰",
        "sl": "🇸🇮", "et": "🇪🇪", "lv": "🇱🇻", "lt": "🇱🇹",
        "ga": "🇮🇪", "mt": "🇲🇹", "cy": "🏴󠁧󠁢󠁷󠁬󠁳󠁿",
    }
    return "".join(icons.get(lang, f"[{lang}]") for lang in langs) or "🎵"


def key_to_french(key: str) -> str:
    """Retourne la clé en notation française (Do, Ré, Mi, ...)."""
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


# --------- Collecte fichiers ---------

partitions_diat = sorted(f for f in fichiers if f.endswith("_diatonique.pdf"))
partitions_chro = sorted(f for f in fichiers if f.endswith("_chromatique.pdf"))
midis = sorted(f for f in fichiers if f.endswith(".midi") or f.endswith(".mid"))
mp3s  = sorted(f for f in fichiers if f.endswith(".mp3"))

logger.info(
    f"✓ {len(partitions_diat)} diatoniques, {len(partitions_chro)} chromatiques, "
    f"{len(midis)} MIDI, {len(mp3s)} MP3"
)

if not (len(partitions_diat) == len(partitions_chro) == len(midis) == len(mp3s)):
    logger.error("❌ ERREUR: Les nombres de fichiers ne correspondent pas!")
    logger.error(
        f"  Diatonique: {len(partitions_diat)}, Chromatique: {len(partitions_chro)}, "
        f"MIDI: {len(midis)}, MP3: {len(mp3s)}"
    )
    sys.exit(1)


# --------- Cache des métadonnées ---------

logger.info("Lecture des métadonnées + analyse de difficulté...")
metadata_cache: dict[str, dict] = {}
for d in partitions_diat:
    base = d.replace("_diatonique.pdf", "")
    metadata_cache[base] = parse_ly_metadata(base)


# --------- HTML ---------

html = """<html>
<head>
<meta charset="UTF-8">
<title>Partitions Harmonica</title>
<style>
body { font-family: sans-serif; }
table { border-collapse: collapse; width: 100%; font-size: 0.9em; }
th, td { border: 1px solid #ccc; padding: 6px 8px; text-align: center; }
th { background-color: #f2f2f2; }
td:first-child { text-align: left; }
td:nth-child(2) { text-align: left; font-size: 0.85em; }
.hidden { color: #aaa; font-style: italic; }
.badge { font-size: 1.2em; }
</style>
</head>
<body>

<h1>Partitions Harmonica</h1>
<h2>Compilation de toutes les partitions</h2>
<ul>
<li><a href="all_diatonique.pdf">Toutes les partitions diatoniques (PDF)</a></li>
<li><a href="all_chromatique.pdf">Toutes les partitions chromatiques (PDF)</a></li>
</ul>
<br>
<table>
<tr>
  <th>Œuvre</th>
  <th>Compositeur</th>
  <th>Clé</th>
  <th>Diatonique</th>
  <th title="🟢 facile · 🟡 moyen · 🔴 difficile — ↕ bends · ⊕ overblows · ⊗ overdraws — vitesse">Difficulté 🎵</th>
  <th>Chromatique</th>
  <th>MP3</th>
  <th>Paroles</th>
  <th>Droits</th>
</tr>
"""

for d, c, _midi, z in zip(partitions_diat, partitions_chro, midis, mp3s):
    base = d.replace("_diatonique.pdf", "")
    meta = metadata_cache[base]
    status    = meta["copyrightStatus"]
    lyrics    = meta["lyricsLang"]
    key       = key_to_french(meta["key"])
    composer  = meta["composer"]
    title     = meta["title"] or base
    nat       = meta["composerNationality"].lower()
    flag      = COUNTRY_FLAGS.get(nat, '')
    diff      = meta["difficulty"]

    composer_cell = f"{flag} {escape(composer)}".strip() if composer else flag

    html += "<tr>"
    html += f"<td>{escape(title)}</td>"
    html += f"<td>{composer_cell}</td>"
    html += f"<td>{escape(key)}</td>"

    if status in ("public-domain", "public domain"):
        html += f"<td><a href='{escape(d)}'>PDF</a></td>"
        html += difficulty_cell(diff)
        html += f"<td><a href='{escape(c)}'>PDF</a></td>"
        html += f"<td><a href='{escape(z)}'>MP3</a></td>"
    else:
        html += "<td class='hidden'>non affiché</td>"
        html += difficulty_cell(diff)
        html += "<td class='hidden'>non affiché</td>"
        html += "<td class='hidden'>non affiché</td>"

    html += f"<td class='badge'>{lyrics_icon(lyrics)}</td>"
    html += f"<td class='badge'>{copyright_icon(status)}</td>"
    html += "</tr>\n"

html += """
</table>
</body>
</html>
"""

output_file = os.path.join(dossier, "index.html")
with open(output_file, "w", encoding="utf-8") as f:
    f.write(html)

logger.info(f"✓ index.html généré ({len(partitions_diat)} partitions)")

# --------- Résumé final ---------

key_counts: dict[str, int] = {}
status_counts: dict[str, int] = {}
lang_counts: dict[str, int] = {}

for meta in metadata_cache.values():
    k = key_to_french(meta.get("key", "unknown"))
    key_counts[k] = key_counts.get(k, 0) + 1
    s = meta.get("copyrightStatus", "unknown")
    status_counts[s] = status_counts.get(s, 0) + 1
    for lang in meta.get("lyricsLang", []):
        lang_counts[lang] = lang_counts.get(lang, 0) + 1

logger.info(f"  Statuts copyright : {status_counts}")
logger.info(f"  Clés : {key_counts}")
if lang_counts:
    logger.info(f"  Langues : {lang_counts}")
