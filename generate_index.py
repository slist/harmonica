# generate_index.py
import os

dossier = "output"  # dossier contenant PDFs et MIDIs
fichiers = os.listdir(dossier)

# Filtrer les fichiers à inclure
partitions_diat = [f for f in fichiers if f.endswith("_diatonique.pdf")]
partitions_chro = [f for f in fichiers if f.endswith("_chromatique.pdf")]
midis = [f for f in fichiers if f.endswith(".midi") or f.endswith(".mid")]

partitions_diat.sort()
partitions_chro.sort()
midis.sort()

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
<tr><th>Diatonique</th><th>Chromatique</th><th>MIDI</th></tr>
"""

for d, c, m in zip(partitions_diat, partitions_chro, midis):
    html += f"<tr>"
    html += f"<td><a href='{d}'>{d}</a></td>"
    html += f"<td><a href='{c}'>{c}</a></td>"
    html += f"<td><a href='{m}'>{m}</a></td>"
    html += "</tr>\n"

html += "</table>\n</body>\n</html>"

with open(os.path.join(dossier, "index.html"), "w", encoding="utf-8") as f:
    f.write(html)

print("index.html généré avec succès !")
