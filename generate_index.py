# generate_index.py
import os

dossier = "output"  # dossier contenant PDFs, MIDIs et MP3s
fichiers = os.listdir(dossier)

# Filtrer les fichiers à inclure
partitions_diat = [f for f in fichiers if f.endswith("_diatonique.pdf")]
partitions_chro = [f for f in fichiers if f.endswith("_chromatique.pdf")]
midis = [f for f in fichiers if f.endswith(".midi") or f.endswith(".mid")]
mp3s = [f for f in fichiers if f.endswith(".mp3")]

partitions_diat.sort()
partitions_chro.sort()
midis.sort()
mp3s.sort()

html = """<html>
<head>
<meta charset="UTF-8">
<title>Partitions</title>
<style>
    table { border-collapse: collapse; width: 100%; }
    th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
    th { background-color: #f2f2f2; }
</style>
</head>
<body>
<h1>Partitions Harmonica</h1>
<table>
<tr>
    <th>Diatonique</th>
    <th>Chromatique</th>
    <th>MIDI</th>
    <th>MP3</th>
</tr>
"""

for d, c, m, z in zip(partitions_diat, partitions_chro, midis, mp3s):
    html += f"<tr>"
    html += f"<td><a href='{d}'>{d}</a></td>"
    html += f"<td><a href='{c}'>{c}</a></td>"
    html += f"<td><a href='{m}'>{m}</a></td>"
    html += f"<td><a href='{z}'>{z}</a></td>"
    html += "</tr>\n"

html += "</table>\n</body>\n</html>"

with open(os.path.join(dossier, "index.html"), "w", encoding="utf-8") as f:
    f.write(html)

# Affiche le nombre de partitions traitées
print(f"Nombre de partitions diatoniques: {len(partitions_diat)}")
print(f"Nombre de partitions chromatiques: {len(partitions_chro)}")
print(f"Nombre de fichiers MIDI: {len(midis)}")
print(f"Nombre de fichiers MP3: {len(mp3s)}")

print("index.html généré avec succès !")
