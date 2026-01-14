import os
import re

dossier = "output"

print("=" * 60)
print("DÉBUT DU SCRIPT DE GÉNÉRATION D'INDEX")
print("=" * 60)

# Vérification de l'existence du dossier output
if not os.path.exists(dossier):
    print(f"❌ ERREUR: Le dossier '{dossier}' n'existe pas!")
    exit(1)
else:
    print(f"✓ Dossier '{dossier}' trouvé")

fichiers = os.listdir(dossier)
print(f"✓ {len(fichiers)} fichiers trouvés dans '{dossier}'")
print(f"  Fichiers: {', '.join(fichiers[:5])}{'...' if len(fichiers) > 5 else ''}")

# Vérification de l'existence du dossier partitions
if not os.path.exists("partitions"):
    print("⚠️  ATTENTION: Le dossier 'partitions' n'existe pas!")
else:
    print("✓ Dossier 'partitions' trouvé")
    partitions_files = os.listdir("partitions")
    print(f"  {len(partitions_files)} fichiers dans 'partitions'")
    print(f"  Fichiers .ly: {', '.join([f for f in partitions_files if f.endswith('.ly')])}")

print()

# --------- Parsing LilyPond ---------

def parse_ly_metadata(base_name):
    """
    Cherche un fichier .ly correspondant et extrait
    copyrightStatus et lyricsLang depuis le \\header
    """
    print(f"\n--- Analyse de '{base_name}' ---")
    
    # Chercher d'abord dans le dossier partitions
    ly_file = os.path.join("partitions", f"{base_name}.ly")
    print(f"  Recherche: {ly_file}")
    
    # Si pas trouvé, chercher dans output (fallback)
    if not os.path.exists(ly_file):
        print(f"  ❌ Non trouvé dans partitions")
        ly_file = os.path.join(dossier, f"{base_name}.ly")
        print(f"  Recherche fallback: {ly_file}")
    else:
        print(f"  ✓ Fichier trouvé!")
    
    metadata = {
        "copyrightStatus": "unknown",
        "lyricsLang": []
    }

    if not os.path.exists(ly_file):
        print(f"  ❌ Fichier .ly introuvable pour '{base_name}'")
        return metadata

    print(f"  Lecture du fichier...")
    with open(ly_file, "r", encoding="utf-8") as f:
        content = f.read()
    
    print(f"  Taille du contenu: {len(content)} caractères")

    # copyrightStatus = "public-domain"
    m = re.search(r'copyrightStatus\s*=\s*"([^"]+)"', content)
    if m:
        metadata["copyrightStatus"] = m.group(1)
        print(f"  ✓ copyrightStatus trouvé: '{metadata['copyrightStatus']}'")
    else:
        print(f"  ⚠️  copyrightStatus non trouvé (par défaut: 'unknown')")

    # lyricsLang = #'(fr en)
    m = re.search(r'lyricsLang\s*=\s*#\'\(([^)]*)\)', content)
    if m:
        metadata["lyricsLang"] = m.group(1).split()
        print(f"  ✓ lyricsLang trouvé: {metadata['lyricsLang']}")
    else:
        print(f"  ⚠️  lyricsLang non trouvé")

    return metadata


def copyright_icon(status):
    icons = {
        "public-domain": "🆓",
        "copyrighted": "©",
        "arrangement-copyrighted": "©✍️",
        "unknown": "⚠️",
        "forbidden": "🚫"
    }
    return icons.get(status, "⚠️")


def lyrics_icon(langs):
    icons = {
        "fr": "🇫🇷",  # Français
        "en": "🇬🇧",  # Anglais
        "de": "🇩🇪",  # Allemand
        "es": "🇪🇸",  # Espagnol
        "it": "🇮🇹",  # Italien
        "pt": "🇵🇹",  # Portugais
        "nl": "🇳🇱",  # Néerlandais
        "pl": "🇵🇱",  # Polonais
        "ru": "🇷🇺",  # Russe
        "sv": "🇸🇪",  # Suédois
        "da": "🇩🇰",  # Danois
        "no": "🇳🇴",  # Norvégien
        "fi": "🇫🇮",  # Finnois
        "el": "🇬🇷",  # Grec
        "cs": "🇨🇿",  # Tchèque
        "ro": "🇷🇴",  # Roumain
        "hu": "🇭🇺",  # Hongrois
        "bg": "🇧🇬",  # Bulgare
        "hr": "🇭🇷",  # Croate
        "sk": "🇸🇰",  # Slovaque
        "sl": "🇸🇮",  # Slovène
        "et": "🇪🇪",  # Estonien
        "lv": "🇱🇻",  # Letton
        "lt": "🇱🇹",  # Lituanien
        "ga": "🇮🇪",  # Irlandais
        "mt": "🇲🇹",  # Maltais
        "cy": "🏴󠁧󠁢󠁷󠁬󠁳󠁿",  # Gallois
    }
    result = "".join(icons.get(l, f"[{l}]") for l in langs) or "🎵"
    if langs:
        print(f"    Icônes langues: {langs} -> {result}")
    return result


# --------- Collecte fichiers ---------

print("\n" + "=" * 60)
print("COLLECTE DES FICHIERS")
print("=" * 60)

partitions_diat = sorted([f for f in fichiers if f.endswith("_diatonique.pdf")])
partitions_chro = sorted([f for f in fichiers if f.endswith("_chromatique.pdf")])
midis = sorted([f for f in fichiers if f.endswith(".midi") or f.endswith(".mid")])
mp3s = sorted([f for f in fichiers if f.endswith(".mp3")])

print(f"✓ {len(partitions_diat)} partitions diatoniques")
for p in partitions_diat:
    print(f"  - {p}")

print(f"\n✓ {len(partitions_chro)} partitions chromatiques")
for p in partitions_chro:
    print(f"  - {p}")

print(f"\n✓ {len(midis)} fichiers MIDI")
for m in midis:
    print(f"  - {m}")

print(f"\n✓ {len(mp3s)} fichiers MP3")
for m in mp3s:
    print(f"  - {m}")

# Vérifier que les listes ont la même longueur
if not (len(partitions_diat) == len(partitions_chro) == len(midis) == len(mp3s)):
    print("\n⚠️  ATTENTION: Les nombres de fichiers ne correspondent pas!")
    print(f"  Diatonique: {len(partitions_diat)}")
    print(f"  Chromatique: {len(partitions_chro)}")
    print(f"  MIDI: {len(midis)}")
    print(f"  MP3: {len(mp3s)}")

# --------- HTML ---------

print("\n" + "=" * 60)
print("GÉNÉRATION DU HTML")
print("=" * 60)

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

ligne_count = 0
for d, c, m, z in zip(partitions_diat, partitions_chro, midis, mp3s):
    ligne_count += 1
    base = d.replace("_diatonique.pdf", "")
    print(f"\nLigne {ligne_count}: {base}")
    
    meta = parse_ly_metadata(base)

    status = meta["copyrightStatus"]
    lyrics = meta["lyricsLang"]
    
    print(f"  Status final: {status}")
    print(f"  Langues finales: {lyrics}")

    html += "<tr>"
    html += f"<td>{base}</td>"

    if status == "public-domain":
        print(f"  ✓ Fichiers PDF affichés (domaine public)")
        html += f"<td><a href='{d}'>PDF</a></td>"
        html += f"<td><a href='{c}'>PDF</a></td>"
    else:
        print(f"  ⚠️  Fichiers PDF masqués (status: {status})")
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

output_file = os.path.join(dossier, "index.html")
print(f"\n✓ Écriture du fichier: {output_file}")
with open(output_file, "w", encoding="utf-8") as f:
    f.write(html)

print(f"✓ Fichier écrit: {len(html)} caractères")

# Affiche le résumé final
print("\n" + "=" * 60)
print("RÉSUMÉ FINAL")
print("=" * 60)
print(f"✓ Nombre de partitions diatoniques: {len(partitions_diat)}")
print(f"✓ Nombre de partitions chromatiques: {len(partitions_chro)}")
print(f"✓ Nombre de fichiers MIDI: {len(midis)}")
print(f"✓ Nombre de fichiers MP3: {len(mp3s)}")
print(f"✓ Nombre de lignes dans le tableau: {ligne_count}")
print(f"\n✓ index.html généré avec succès!")
print("=" * 60)