import os
import re

dossier = "output"
fichiers = os.listdir(dossier)

# --------- Parsing LilyPond ---------

def parse_ly_metadata(base_name):
    """
    Cherche un fichier .ly correspondant et extrait
    copyrightStatus et lyricsLang depuis le \\header
    """

    # Chercher d'abord dans le dossier partitions
    ly_file = os.path.join("partitions", f"{base_name}.ly")
    
    # Si pas trouvé, chercher dans output (fallback)
    if not os.path.exists(ly_file):
        ly_file = os.path.join(dossier, f"{base_name}.ly")
    
    metadata = {
        "copyrightStatus": "unknown",
        "lyricsLang": []
    }

    if not os.path.exists(ly_file):
        return metadata

    with open(ly_file, "r", encoding="utf-8") as f:
        content = f.read()

    # copyrightStatus = "public-domain"
    m = re.search(r'copyrightStatus\s*=\s*"([^"]+)"', content)
    if m:
        metadata["copyrightStatus"] = m.group(1)

    # lyricsLang = #'(fr en)
    m = re.search(r'lyricsLang\s*=\s*#\'\(([^)]*)\)', content)
    if m:
        metadata["lyricsLang"] = m.group(1).split()

    return metadata


def copyright_icon(status):
    return {
        "public-domain": "🆓",
        "copyrighted": "©",
        "arrangement-copyrighted": "©✍️",
        "unknown": "⚠️",
        "forbidden": "🚫"
    }.get(status, "⚠️")


def lyrics_icon(langs):
    icons = {
        "fr": "🇫🇷",
        "en": "🇬🇧"
    }
    return "".join(icons.get(l, "") for l in langs) or "🎵"


# --------- Collecte fichiers ---------

partitions_diat = sorted([f for f in fichiers if f.endswith("_diatonique.pdf")])
partitions_chro = sorted([f for f in fichiers if f.endswith("_chromatique.pdf")])
midis = sorted([f for f in fichiers if f.endswith(".midi") or f.endswith(".mid")])
mp3s = sorted([f for f in fichiers if f.endswith(".mp3")])

# --------- HTML ---------

html = """<html>
<head>
<meta charset="UTF-8">
<title>Partitions Harmonica</title>
<style>
table { border-collapse: collapse; width: 100%; }
th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
th { background-color: #f2f2f2; }
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
  <th>Diatonique</th>
  <th>Chromatique</th>
  <th>MIDI</th>
  <th>MP3</th>
  <th>Paroles</th>
  <th>Droits</th>
</tr>
"""

for d, c, m, z in zip(partitions_diat, partitions_chro, midis, mp3s):
    base = d.replace("_diatonique.pdf", "")
    meta = parse_ly_metadata(base)

    status = meta["copyrightStatus"]
    lyrics = meta["lyricsLang"]

    html += "<tr>"
    html += f"<td>{base}</td>"

    if status == "public-domain":
        html += f"<td><a href='{d}'>PDF</a></td>"
        html += f"<td><a href='{c}'>PDF</a></td>"
    else:
        html += "<td class='hidden'>non affiché</td>"
        html += "<td class='hidden'>non affiché</td>"

    html += f"<td><a href='{m}'>MIDI</a></td>"
    html += f"<td><a href='{z}'>MP3</a></td>"
    html += f"<td class='badge'>{lyrics_icon(lyrics)}</td>"
    html += f"<td class='badge'>{copyright_icon(status)}</td>"
    html += "</tr>\n"

html += """
</table>
</body>
</html>
"""

with open(os.path.join(dossier, "index.html"), "w", encoding="utf-8") as f:
    f.write(html)

# Affiche le nombre de partitions traitées
print(f"Nombre de partitions diatoniques: {len(partitions_diat)}")
print(f"Nombre de partitions chromatiques: {len(partitions_chro)}")
print(f"Nombre de fichiers MIDI: {len(midis)}")
print(f"Nombre de fichiers MP3: {len(mp3s)}")

print("index.html généré avec succès !")
