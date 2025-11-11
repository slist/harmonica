from PyPDF2 import PdfMerger
import os, glob

dossier = "output"  # dossier contenant PDFs, MIDIs et MP3s
fichiers = os.listdir(dossier)

# Filtrer les fichiers à inclure
partitions_diat = [f for f in fichiers if f.endswith("_diatonique.pdf")]
partitions_chro = [f for f in fichiers if f.endswith("_chromatique.pdf")]

partitions_diat.sort()
partitions_chro.sort()

# Crée les objets de fusion
merger_diat = PdfMerger()
merger_chro = PdfMerger()

# Ajoute chaque PDF dans l’ordre
for pdf in partitions_diat:
    print(f"Ajout de {pdf}")
    merger_diat.append(pdf)

# Sauvegarde le résultat final
merger_diat.write("all_diatonique.pdf")
merger_diat.close()

# Ajoute chaque PDF dans l’ordre
for pdf in partitions_chro:
    print(f"Ajout de {pdf}")
    merger_chro.append(pdf)

# Sauvegarde le résultat final
merger_chro.write("all_chromatique.pdf")
merger_chro.close()


print("Fusion terminéee avec succès !")
