#!/usr/bin/env python3
"""Quelles harmoniques diatoniques (Richter, 10 trous) conviennent à une partition ?

Pour chaque tonalité d'harmonica (C, Db, D, ...), compte les notes de la mélodie
qui sont jouées « naturellement » (soufflé/aspiré) et celles qui demandent une
altération : note bendée, overblow, overdraw, ou hors tessiture.

Ensuite, cherche pour chaque harmonica la meilleure TRANSPOSITION de la mélodie
(de -6 à +5 demi-tons ; l'octave est choisie librement) et classe les résultats.

Usage :
    python harmonica_compat.py partitions/believe-me-if-all-those-endearing-young-charms.ly
    python harmonica_compat.py <fichier.ly> --top 8
"""

import argparse
import re
import sys
from collections import Counter

from complexity import (
    ENGLISH_NOTES,
    FRENCH_NOTES,
    RICHTER_LAYOUT,
    WEIGHT_BEND,
    WEIGHT_OVERBLOW,
    WEIGHT_OVERDRAW,
    brace_block,
    parse_melody,
    strip_comments,
)

WEIGHT_OUT_OF_RANGE = 5  # note injouable sur l'harmonica : pire qu'un overblow

# Tonalité de l'harmonica -> demi-tons au-dessus de do
HARP_KEYS = {
    'C': 0, 'Db': 1, 'D': 2, 'Eb': 3, 'E': 4, 'F': 5,
    'F#': 6, 'G': 7, 'Ab': 8, 'A': 9, 'Bb': 10, 'B': 11,
}
PITCH_NAMES = {v: k for k, v in HARP_KEYS.items()}

# Position (1re, 2e, ...) -> demi-tons entre la tonalité de l'harmonica et la tonique du morceau
POSITIONS = {n: (7 * (n - 1)) % 12 for n in range(1, 13)}
POSITION_BY_OFFSET = {off: n for n, off in POSITIONS.items()}

OCTAVES = (-24, -12, 0, 12, 24)
TRANSPOSITIONS = range(-6, 6)


def detect_tonic(content: str) -> tuple[int, str] | None:
    """Première armure `\\key <tonique> \\major|\\minor` de la mélodie (hors commentaires)."""
    content = strip_comments(content)
    m_mel = re.search(r'\bmelodie\s*=\s*\{', content)
    scope = brace_block(content, m_mel.end()) if m_mel else content
    m = re.search(r'\\key\s+(\S+)\s+\\(major|minor)', scope)
    if not m:
        return None
    name, mode = m.groups()
    name = name.replace('é', 'e')
    is_french = bool(re.search(r'language\s*"fran', content))
    if is_french:
        m_note = re.fullmatch(r'(sol|do|re|mi|fa|la|si)(dd|d|bb|b)?', name)
        if not m_note:
            return None
        pc = FRENCH_NOTES[m_note.group(1)]
        acc = m_note.group(2) or ''
        pc += acc.count('d') - acc.count('b')
    else:
        m_note = re.fullmatch(r'([a-g])(isis|eses|is|es|s)?', name)
        if not m_note:
            return None
        pc = ENGLISH_NOTES[m_note.group(1)]
        acc = m_note.group(2) or ''
        if acc in ('is', 'isis'):
            pc += len(acc) // 2
        elif acc in ('es', 'eses', 's'):
            pc -= max(len(acc) // 2, 1)
    return pc % 12, mode


def evaluate(pitches: list[int], offset: int) -> Counter:
    """Compte les techniques requises quand la tonique de l'harmonica est à `offset` demi-tons de do."""
    counts: Counter = Counter()
    for p in pitches:
        entry = RICHTER_LAYOUT.get(p - 60 - offset)
        counts['out' if entry is None else entry[1]] += 1
    return counts


def penalty(c: Counter) -> int:
    return (c['bend'] * WEIGHT_BEND + c['overblow'] * WEIGHT_OVERBLOW
            + c['overdraw'] * WEIGHT_OVERDRAW + c['out'] * WEIGHT_OUT_OF_RANGE)


def best_octave(pitches: list[int], offset: int, shift: int) -> tuple[int, Counter]:
    """Octave (multiple de 12) qui minimise la pénalité pour cette harmonica/transposition."""
    best = None
    for o in OCTAVES:
        c = evaluate([p + shift + o for p in pitches], offset)
        key = (penalty(c), abs(o))
        if best is None or key < best[0]:
            best = (key, o, c)
    return best[1], best[2]


def fmt_key(pc: int) -> str:
    return PITCH_NAMES[pc % 12]


def fmt_counts(c: Counter) -> str:
    parts = []
    if c['bend']:
        parts.append(f"{c['bend']} bend")
    if c['overblow']:
        parts.append(f"{c['overblow']} overblow")
    if c['overdraw']:
        parts.append(f"{c['overdraw']} overdraw")
    if c['out']:
        parts.append(f"{c['out']} hors tessiture")
    return ', '.join(parts) or 'aucune'


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('ly_file', help='partition .ly à analyser')
    ap.add_argument('--top', type=int, default=6, help='nombre de meilleures combinaisons à afficher')
    args = ap.parse_args()

    with open(args.ly_file, encoding='utf-8') as f:
        content = f.read()

    parsed = parse_melody(content)
    pitches = [p for p, _ in parsed['notes']]
    if not pitches:
        print('Aucune note trouvée dans le bloc melodie.', file=sys.stderr)
        return 1

    tonic = detect_tonic(content)
    tonic_txt = f"{fmt_key(tonic[0])} {'majeur' if tonic[1] == 'major' else 'mineur'}" if tonic else 'inconnue'
    print(f"{args.ly_file}")
    print(f"{len(pitches)} notes, tonalité du morceau : {tonic_txt}")
    print(f"Hauteurs : {min(pitches)}..{max(pitches)} (MIDI, 60 = do central)\n")

    # 1) Sans transposition : chaque harmonica, octave libre
    print("== 1. Mélodie telle quelle (octave libre) ==")
    print(f"{'Harmonica':<10}{'Position':<10}{'Altérations':<8}  Détail")
    rows = []
    for name, off in HARP_KEYS.items():
        octv, c = best_octave(pitches, off, 0)
        alt = c['bend'] + c['overblow'] + c['overdraw'] + c['out']
        pos = ''
        if tonic:
            n = POSITION_BY_OFFSET.get((tonic[0] - off) % 12)
            pos = f"{n}e" if n else ''
        rows.append((penalty(c), name, pos, alt, octv, c))
    for pen, name, pos, alt, octv, c in sorted(rows):
        note = f" [octave {octv // 12:+d}]" if octv else ''
        print(f"{name:<10}{pos:<10}{alt:<8}  {fmt_counts(c)}{note}")

    # 2) Avec transposition
    print(f"\n== 2. Meilleures transpositions (-6..+5 demi-tons), top {args.top} ==")
    print(f"{'Harmonica':<10}{'Transpo':<9}{'Nouvelle tonique':<18}{'Altérations':<8}  Détail")
    results = []
    for name, off in HARP_KEYS.items():
        for t in TRANSPOSITIONS:
            octv, c = best_octave(pitches, off, t)
            alt = c['bend'] + c['overblow'] + c['overdraw'] + c['out']
            results.append((penalty(c), abs(t), name, t, alt, octv, c))
    for pen, _, name, t, alt, octv, c in sorted(results)[:args.top]:
        new_tonic = fmt_key(tonic[0] + t) if tonic else '?'
        note = f" [octave {octv // 12:+d}]" if octv else ''
        print(f"{name:<10}{t:+d} ½ton   {new_tonic:<18}{alt:<8}  {fmt_counts(c)}{note}")

    print(f"\nPénalité : bend={WEIGHT_BEND}, overblow={WEIGHT_OVERBLOW}, "
          f"overdraw={WEIGHT_OVERDRAW}, hors tessiture={WEIGHT_OUT_OF_RANGE} par note.")
    return 0


if __name__ == '__main__':
    sys.exit(main())
