from PyPDF2 import PdfMerger
import os, glob

dossier = "output"  # dossier contenant PDFs, MIDIs et MP3s
fichiers = os.listdir(dossier)

# Filtrer les fichiers à inclure
partitions_diat = sorted(f for f in fichiers if f.endswith("_diatonique.pdf"))
partitions_chro = sorted(f for f in fichiers if f.endswith("_chromatique.pdf"))

def fusionner_avec_index(liste_pdfs, sortie):
    merger = PdfMerger()
    page_offset = 0  # permet de suivre à quelle page commence chaque document

    for pdf in liste_pdfs:
        chemin_pdf = os.path.join(dossier, pdf)
        nom_sans_ext = os.path.splitext(pdf)[0]
        print(f"Ajout de {chemin_pdf}")
        merger.append(chemin_pdf)
        # Ajoute un signet pointant vers la première page du document ajouté
        merger.add_outline_item(nom_sans_ext, page_offset)
        # Met à jour l’offset pour le prochain fichier
        num_pages = merger.pages[-1].get("/Count", 1) if merger.pages else 1
        page_offset += num_pages

    # Sauvegarde le PDF final
    merger.write(sortie)
    merger.close()
    print(f"Fichier généré : {sortie}")

# Fusionne les diatoniques
fusionner_avec_index(partitions_diat, os.path.join(dossier, "all_diatonique.pdf"))

# Fusionne les chromatiques
fusionner_avec_index(partitions_chro, os.path.join(dossier, "all_chromatique.pdf"))

print("Fusion terminée avec succès avec index !")