import notes_page
from complexity import RICHTER_LAYOUT, SUZUKI_FIVE_LAYOUT


def _richter_positions() -> dict[int, set[tuple[int, str]]]:
    pos: dict[int, set[tuple[int, str]]] = {}

    def add(offset, hole, tech):
        pos.setdefault(offset, set()).add((hole, tech))

    for hole, off in enumerate(notes_page.RICHTER_BLOW, 1):
        add(off, hole, 'natural')
    for hole, off in enumerate(notes_page.RICHTER_DRAW, 1):
        add(off, hole, 'natural')
    for bends in (notes_page.RICHTER_BLOW_BENDS, notes_page.RICHTER_DRAW_BENDS):
        for hole, offs in bends.items():
            for off in offs:
                add(off, hole, 'bend')
    for hole, off in notes_page.RICHTER_OVERBLOW.items():
        add(off, hole, 'overblow')
    for hole, off in notes_page.RICHTER_OVERDRAW.items():
        add(off, hole, 'overdraw')
    return pos


def test_richter_diagram_matches_complexity_layout():
    pos = _richter_positions()
    for offset, expected in RICHTER_LAYOUT.items():
        assert expected in pos.get(offset, set()), (offset, expected)


def test_suzuki_diagram_matches_complexity_layout():
    notes = {}
    for hole, off in enumerate(notes_page.SUZUKI_BLOW + [], 1):
        notes[off] = hole
    for hole, off in enumerate(notes_page.SUZUKI_DRAW, 1):
        notes[off] = hole
    assert {off: (hole, 'natural') for off, hole in notes.items()} == SUZUKI_FIVE_LAYOUT
