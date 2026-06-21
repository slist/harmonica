"""Fusion des PDFs LilyPond avec page d'index et signets cliquables."""

import os
import re

from pypdf import PdfReader, PdfWriter
from reportlab.lib.colors import HexColor
from reportlab.lib.pagesizes import A4
from reportlab.lib.units import cm
from reportlab.pdfgen import canvas

from generate_index import parse_ly_metadata, title_sort_key

DOSSIER        = "output"
PARTITIONS_DIR = "partitions"
GAMMES_DIR     = "gammes"
GAMMES_DOSSIER = os.path.join(DOSSIER, "gammes")
SUFFIXES = ("_diatonique", "_chromatique")


def base_de_pdf(pdf: str) -> str:
    """Extrait le nom de base d'un PDF (sans extension, suffixe ni numéro de page)."""
    nom = os.path.splitext(pdf)[0]
    for suffixe in SUFFIXES:
        nom = nom.removesuffix(suffixe)
    return re.sub(r'-\d+$', '', nom)


def construire_table_titres(src_dir: str) -> dict[str, str]:
    """Mappe le nom de base d'un fichier .ly vers le titre extrait des métadonnées."""
    table: dict[str, str] = {}
    if not os.path.isdir(src_dir):
        return table
    for fname in os.listdir(src_dir):
        if not fname.endswith(".ly"):
            continue
        base = fname[:-3]
        meta = parse_ly_metadata(os.path.join(src_dir, fname))
        table[base] = meta.get("title") or base
    return table


def titre_de_pdf(pdf: str, titres: dict[str, str]) -> str:
    base = base_de_pdf(pdf)
    return titres.get(base, base)


def creer_page_index(
    titre: str,
    liste_pdfs: list[str],
    fichier_sortie: str,
    titres: dict[str, str],
) -> None:
    """Crée une page PDF élégante contenant la liste des fichiers."""
    c = canvas.Canvas(fichier_sortie, pagesize=A4)
    largeur, hauteur = A4

    c.setFillColor(HexColor("#e0e0e0"))
    c.rect(0, hauteur - 80, largeur, 80, fill=1, stroke=0)
    c.setFillColor(HexColor("#000000"))

    c.setFont("Helvetica-Bold", 22)
    c.drawCentredString(largeur / 2, hauteur - 55, titre)

    c.setStrokeColor(HexColor("#999999"))
    c.setLineWidth(0.5)
    c.line(2 * cm, hauteur - 90, largeur - 2 * cm, hauteur - 90)

    c.setFont("Helvetica", 12)
    y = hauteur - 120

    for numero, pdf in enumerate(liste_pdfs, start=1):
        texte = f"{numero:>2}. {titre_de_pdf(pdf, titres)}"
        c.drawString(2 * cm, y, texte)
        y -= 16
        if y < 80:
            c.showPage()
            c.setFont("Helvetica", 12)
            y = hauteur - 80

    c.save()


def fusionner_avec_index(
    liste_pdfs: list[str],
    sortie: str,
    titre_index: str,
    titres: dict[str, str],
    base_dir: str = DOSSIER,
) -> None:
    """Fusionne une liste de PDFs en ajoutant une page d'index et des signets."""
    writer = PdfWriter()
    page_offset = 0

    index_pdf = os.path.join(base_dir, "temp_index.pdf")
    creer_page_index(titre_index, liste_pdfs, index_pdf, titres)
    writer.append(index_pdf)
    page_offset += len(PdfReader(index_pdf).pages)

    for pdf in liste_pdfs:
        chemin_pdf = os.path.join(base_dir, pdf)
        try:
            reader = PdfReader(chemin_pdf)
            num_pages = len(reader.pages)
        except Exception as e:  # pylint: disable=broad-exception-caught
            print(f"⚠️ Impossible de lire {pdf} : {e}")
            continue

        print(f"Ajout de {chemin_pdf} ({num_pages} pages)")
        writer.append(chemin_pdf)
        writer.add_outline_item(titre_de_pdf(pdf, titres), page_offset)
        page_offset += num_pages

    try:
        writer.write(sortie)
    finally:
        os.remove(index_pdf)

    print(f"✅ PDF généré avec page d'index : {sortie}")


# --------- Partitions (chansons) ---------

titres_partitions = construire_table_titres(PARTITIONS_DIR)

fichiers = os.listdir(DOSSIER)

partitions_diat = sorted(
    (f for f in fichiers if f.endswith("_diatonique.pdf")),
    key=lambda f: title_sort_key(titre_de_pdf(f, titres_partitions)),
)
partitions_chro = sorted(
    (f for f in fichiers if f.endswith("_chromatique.pdf")),
    key=lambda f: title_sort_key(titre_de_pdf(f, titres_partitions)),
)

fusionner_avec_index(
    partitions_diat,
    os.path.join(DOSSIER, "all_diatonique.pdf"),
    "Index des partitions pour harmonica diatonique",
    titres_partitions,
)

fusionner_avec_index(
    partitions_chro,
    os.path.join(DOSSIER, "all_chromatique.pdf"),
    "Index des partitions pour harmonica chromatique",
    titres_partitions,
)

# --------- Gammes ---------

if os.path.isdir(GAMMES_DOSSIER):
    titres_gammes = construire_table_titres(GAMMES_DIR)
    gammes_fichiers = os.listdir(GAMMES_DOSSIER)

    gammes_diat = sorted(
        (f for f in gammes_fichiers if f.endswith("_diatonique.pdf")),
        key=lambda f: title_sort_key(titre_de_pdf(f, titres_gammes)),
    )
    gammes_chro = sorted(
        (f for f in gammes_fichiers if f.endswith("_chromatique.pdf")),
        key=lambda f: title_sort_key(titre_de_pdf(f, titres_gammes)),
    )

    if gammes_diat:
        fusionner_avec_index(
            gammes_diat,
            os.path.join(GAMMES_DOSSIER, "all_gammes_diatonique.pdf"),
            "Gammes pour harmonica diatonique",
            titres_gammes,
            base_dir=GAMMES_DOSSIER,
        )

    if gammes_chro:
        fusionner_avec_index(
            gammes_chro,
            os.path.join(GAMMES_DOSSIER, "all_gammes_chromatique.pdf"),
            "Gammes pour harmonica chromatique",
            titres_gammes,
            base_dir=GAMMES_DOSSIER,
        )

print("🎶 Fusion terminée avec succès !")
