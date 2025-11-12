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

# Fusionne les PDFs diatoniques
for pdf in partitions_diat:
    chemin_pdf = os.path.join(dossier, pdf)
    print(f"Ajout de {chemin_pdf}")
    merger_diat.append(chemin_pdf)

# Sauvegarde le résultat final dans le dossier output
merger_diat.write(os.path.join(dossier, "all_diatonique.pdf"))
merger_diat.close()

# Fusionne les PDFs chromatiques
for pdf in partitions_chro:
    chemin_pdf = os.path.join(dossier, pdf)
    print(f"Ajout de {chemin_pdf}")
    merger_chro.append(chemin_pdf)

# Sauvegarde le résultat final dans le dossier output
merger_chro.write(os.path.join(dossier, "all_chromatique.pdf"))
merger_chro.close()

print("Fusion terminéee avec succès !")
