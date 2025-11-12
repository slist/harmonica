from PyPDF2 import PdfMerger, PdfReader
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from reportlab.lib.colors import HexColor
from reportlab.lib.units import cm
import os

dossier = "output"
fichiers = os.listdir(dossier)

# Filtrer les fichiers à inclure
partitions_diat = sorted(f for f in fichiers if f.endswith("_diatonique.pdf"))
partitions_chro = sorted(f for f in fichiers if f.endswith("_chromatique.pdf"))


def creer_page_index(titre, liste_pdfs, fichier_sortie):
    """Crée une page PDF élégante contenant la liste des fichiers."""
    c = canvas.Canvas(fichier_sortie, pagesize=A4)
    largeur, hauteur = A4

    # Bandeau titre coloré
    c.setFillColor(HexColor("#e0e0e0"))
    c.rect(0, hauteur - 80, largeur, 80, fill=1, stroke=0)
    c.setFillColor(HexColor("#000000"))

    # Titre principal
    c.setFont("Helvetica-Bold", 22)
    c.drawCentredString(largeur / 2, hauteur - 55, titre)

    # Ligne de séparation
    c.setStrokeColor(HexColor("#999999"))
    c.setLineWidth(0.5)
    c.line(2 * cm, hauteur - 90, largeur - 2 * cm, hauteur - 90)

    # Liste des morceaux
    c.setFont("Helvetica", 12)
    y = hauteur - 120
    numero = 1

    for pdf in liste_pdfs:
        nom = os.path.splitext(pdf)[0]
        texte = f"{numero:>2}. {nom}"
        c.drawString(2 * cm, y, texte)
        y -= 16

        if y < 80:
            c.showPage()
            c.setFont("Helvetica", 12)
            y = hauteur - 80

        numero += 1

    # Pied de page
    c.setFont("Helvetica-Oblique", 10)
    c.setFillColor(HexColor("#555555"))
    c.drawCentredString(largeur / 2, 40, "Généré automatiquement avec amour 💙")

    c.save()


def fusionner_avec_index(liste_pdfs, sortie, titre_index):
    merger = PdfMerger()
    page_offset = 0

    # 1️⃣ Crée la page d’index temporaire
    index_pdf = os.path.join(dossier, "temp_index.pdf")
    creer_page_index(titre_index, liste_pdfs, index_pdf)
    merger.append(index_pdf)
    page_offset += len(PdfReader(index_pdf).pages)

    # 2️⃣ Ajoute les fichiers un par un
    for pdf in liste_pdfs:
        chemin_pdf = os.path.join(dossier, pdf)
        try:
            reader = PdfReader(chemin_pdf)
            num_pages = len(reader.pages)
        except Exception as e:
            print(f"⚠️ Impossible de lire {pdf} : {e}")
            continue

        nom_sans_ext = os.path.splitext(pdf)[0]
        print(f"Ajout de {chemin_pdf} ({num_pages} pages)")
        merger.append(chemin_pdf)
        merger.add_outline_item(nom_sans_ext, page_offset)
        page_offset += num_pages

    # 3️⃣ Écrit le résultat final
    merger.write(sortie)
    merger.close()

    # 4️⃣ Supprime la page d’index temporaire
    os.remove(index_pdf)

    print(f"✅ PDF généré avec page d’index : {sortie}")


# Fusionne les diatoniques
fusionner_avec_index(partitions_diat, os.path.join(dossier, "all_diatonique.pdf"),
                     "Index des partitions diatoniques")

# Fusionne les chromatiques
fusionner_avec_index(partitions_chro, os.path.join(dossier, "all_chromatique.pdf"),
                     "Index des partitions chromatiques")

print("🎶 Fusion terminée avec succès avec page d’index et signets cliquables !")
