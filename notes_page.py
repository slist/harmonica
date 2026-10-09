"""Generate static/notes-harmonica.html: note diagrams for every harmonica model.

The layouts never change, so this is run by hand (`python notes_page.py`) and the
resulting HTML file is committed; generate_index.py just copies it to output/.
"""
import os
from html import escape

from complexity import TUNING_ROOTS
from generate_index import render

OUT_PATH = os.path.join("static", "notes-harmonica.html")

NOTES_EN_FLAT  = ['C', 'D♭', 'D', 'E♭', 'E', 'F', 'F♯', 'G', 'A♭', 'A', 'B♭', 'B']
NOTES_EN_SHARP = ['C', 'C♯', 'D', 'D♯', 'E', 'F', 'F♯', 'G', 'G♯', 'A', 'A♯', 'B']
NOTES_FR_FLAT  = ['Do', 'Ré♭', 'Ré', 'Mi♭', 'Mi', 'Fa', 'Fa♯', 'Sol', 'La♭', 'La', 'Si♭', 'Si']
NOTES_FR_SHARP = ['Do', 'Do♯', 'Ré', 'Ré♯', 'Mi', 'Fa', 'Fa♯', 'Sol', 'Sol♯', 'La', 'La♯', 'Si']

# Richter layout, in semitones above the harmonica's root (hole 1 blow = 0).
# Mirrors include/harmonica.ly; tests/test_notes_page.py checks it against
# complexity.RICHTER_LAYOUT.
RICHTER_BLOW = [0, 4, 7, 12, 16, 19, 24, 28, 31, 36]
RICHTER_DRAW = [2, 7, 11, 14, 17, 21, 23, 26, 29, 33]
# hole -> offsets, ordered from the smallest bend (½ ton) to the deepest
RICHTER_BLOW_BENDS = {8: [27], 9: [30], 10: [35, 34]}
RICHTER_DRAW_BENDS = {1: [1], 2: [6, 5], 3: [10, 9, 8], 4: [13], 5: [16], 6: [20]}
RICHTER_OVERBLOW   = {1: 3, 4: 15, 5: 18, 6: 22}
RICHTER_OVERDRAW   = {7: 25, 9: 32}

SUZUKI_BLOW = [0, 4, 7, 12, 16]
SUZUKI_DRAW = [2, 5, 9, 11, 14]

# Chromatic 12 holes (solo tuning, as in include/harmonica.ly); 10 holes = first 10.
CHROMATIC_BLOW = [0, 4, 7, 12, 12, 16, 19, 24, 24, 28, 31, 36]
CHROMATIC_DRAW = [2, 5, 9, 11, 14, 17, 21, 23, 26, 29, 33, 35]

CELL_W, ROW_H, LABEL_W, PAD = 62, 32, 128, 8


def _note_text(x: float, y: float, pc: int, sharps: bool) -> str:
    fr = (NOTES_FR_SHARP if sharps else NOTES_FR_FLAT)[pc % 12]
    en = (NOTES_EN_SHARP if sharps else NOTES_EN_FLAT)[pc % 12]
    return (f"<text class='n-fr' x='{x}' y='{y}'>{fr}</text>"
            f"<text class='n-en' x='{x}' y='{y}'>{en}</text>")


class Diagram:
    """Rows of cells placed on a hole grid, rendered as one inline SVG."""

    def __init__(self, n_holes: int, root: int, sharps: bool = False):
        self.n, self.root, self.sharps = n_holes, root, sharps
        self.rows: list[tuple[str, str, dict[int, tuple[int, str]]]] = []  # (label, kind, {hole: (offset, cls)})

    def add_row(self, label: str, kind: str, cells: dict[int, int]) -> None:
        """kind is a css class: blow, draw, bend-blow, bend-draw, over, slide-blow, slide-draw."""
        self.rows.append((label, kind, {h: (off, kind) for h, off in cells.items()}))

    def add_hole_numbers(self) -> None:
        self.rows.append(("Trou", "hole", {h: (h, "hole") for h in range(1, self.n + 1)}))

    def svg(self, aria: str) -> str:
        width = LABEL_W + self.n * CELL_W + PAD
        height = len(self.rows) * ROW_H + 2 * PAD
        parts = [(f"<svg viewBox='0 0 {width} {height}' role='img' aria-label='{escape(aria)}' "
                  f"xmlns='http://www.w3.org/2000/svg'>")]
        for r, (label, kind, cells) in enumerate(self.rows):
            y = PAD + r * ROW_H
            if kind == "hole":
                parts.append(f"<rect class='body' x='{LABEL_W - 4}' y='{y + 2}' "
                             f"width='{self.n * CELL_W + 8}' height='{ROW_H - 4}' rx='4'/>")
            parts.append(f"<text class='row-label' x='{LABEL_W - 12}' y='{y + ROW_H / 2 + 4}'>{escape(label)}</text>")
            for hole, (val, cls) in sorted(cells.items()):
                cx = LABEL_W + (hole - 1) * CELL_W + CELL_W / 2
                if cls == "hole":
                    parts.append(f"<text class='hole-num' x='{cx}' y='{y + ROW_H / 2 + 5}'>{val}</text>")
                    continue
                parts.append(f"<rect class='cell {cls}' x='{cx - CELL_W / 2 + 3}' y='{y + 3}' "
                             f"width='{CELL_W - 6}' height='{ROW_H - 6}' rx='6'/>")
                parts.append(_note_text(cx, y + ROW_H / 2 + 4.5, self.root + val, self.sharps))
        parts.append("</svg>")
        return "".join(parts)


def diatonic_diagram(root: int) -> Diagram:
    d = Diagram(10, root)
    d.add_row("Overblow", "over", {h: o for h, o in RICHTER_OVERBLOW.items()})
    d.add_row("Soufflé", "blow", {h: o for h, o in enumerate(RICHTER_BLOW, 1)})
    for depth, label in enumerate(["½ ton", "1 ton"]):
        d.add_row(f"Bend soufflé {label}", "bend-blow",
                  {h: offs[depth] for h, offs in RICHTER_BLOW_BENDS.items() if len(offs) > depth})
    d.add_hole_numbers()
    d.add_row("Aspiré", "draw", {h: o for h, o in enumerate(RICHTER_DRAW, 1)})
    for depth, label in enumerate(["½ ton", "1 ton", "1½ ton"]):
        d.add_row(f"Bend aspiré {label}", "bend-draw",
                  {h: offs[depth] for h, offs in RICHTER_DRAW_BENDS.items() if len(offs) > depth})
    d.add_row("Overdraw", "over", {h: o for h, o in RICHTER_OVERDRAW.items()})
    return d


def suzuki_diagram() -> Diagram:
    d = Diagram(5, 0)
    d.add_row("Soufflé", "blow", {h: o for h, o in enumerate(SUZUKI_BLOW, 1)})
    d.add_hole_numbers()
    d.add_row("Aspiré", "draw", {h: o for h, o in enumerate(SUZUKI_DRAW, 1)})
    return d


def chromatic_diagram(n_holes: int) -> Diagram:
    d = Diagram(n_holes, 0, sharps=True)
    blow, draw = CHROMATIC_BLOW[:n_holes], CHROMATIC_DRAW[:n_holes]
    d.add_row("Soufflé + bouton", "slide-blow", {h: o + 1 for h, o in enumerate(blow, 1)})
    d.add_row("Soufflé", "blow", {h: o for h, o in enumerate(blow, 1)})
    d.add_hole_numbers()
    d.add_row("Aspiré", "draw", {h: o for h, o in enumerate(draw, 1)})
    d.add_row("Aspiré + bouton", "slide-draw", {h: o + 1 for h, o in enumerate(draw, 1)})
    return d


def _tuning_name(fn: str) -> str:
    return fn.removeprefix("diatonic").removesuffix("HarmonicaTab") or "C"


def build_sections() -> list[dict]:
    sections = []
    for fn, root in TUNING_ROOTS.items():
        if "Suzuki" in fn:
            continue
        name = _tuning_name(fn)
        sections.append({
            "id": f"diatonique-{name.lower()}",
            "title": f"Diatonique {name} (Richter, 10 trous)",
            "svg": diatonic_diagram(root).svg(f"Harmonica diatonique en {name}"),
        })
    sections.append({
        "id": "diatonique-suzuki-5", "title": "Diatonique 5 trous (Suzuki, Do)",
        "svg": suzuki_diagram().svg("Harmonica diatonique 5 trous en Do"),
    })
    for n in (10, 12):
        sections.append({
            "id": f"chromatique-{n}", "title": f"Chromatique {n} trous (Do)",
            "svg": chromatic_diagram(n).svg(f"Harmonica chromatique {n} trous en Do"),
        })
    return sections


def main() -> None:
    html = render(
        "notes.html",
        title="Notes des harmonicas",
        title_html="<h1>Notes des harmonicas</h1>",
        sections=build_sections(),
    )
    os.makedirs(os.path.dirname(OUT_PATH), exist_ok=True)
    with open(OUT_PATH, "w", encoding="utf-8") as f:
        f.write(html)
    print(f"✓ {OUT_PATH} généré")


if __name__ == "__main__":
    main()
