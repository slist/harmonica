#!/usr/bin/env python3
"""Liste les variantes transposées à compiler en CI, une par ligne :

    <fichier.ly> <demi-tons> <nom_de_tonalité>

Chaque partition diatonique Richter est compilée pour les 11 autres tonalités
d'harmonica (option LilyPond -dplay-on=<demi-tons>, voir include/harmonica.ly).
Sont exclues : les partitions Suzuki 5 trous, les partitions cachées
(hidden = "true") et celles dont l'en-tête contient transposition = "false".
"""

import os
import re
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", ".."))

from complexity import RICHTER_LAYOUT, parse_melody

# Nom de tonalité (aussi utilisé comme nom de dossier) -> demi-tons au-dessus de do
KEYS = {
    "C": 0, "Db": 1, "D": 2, "Eb": 3, "E": 4, "F": 5,
    "Fsharp": 6, "G": 7, "Ab": 8, "A": 9, "Bb": 10, "B": 11,
}

PARTITIONS_DIR = "partitions"


def header_flag(content: str, name: str) -> bool:
    return bool(re.search(rf'^\s*{name}\s*=\s*"(?:true)"', content, re.MULTILINE | re.IGNORECASE))


def main() -> None:
    for fname in sorted(os.listdir(PARTITIONS_DIR)):
        if not fname.endswith(".ly") or fname.endswith("-suzuki.ly"):
            continue
        path = os.path.join(PARTITIONS_DIR, fname)
        with open(path, encoding="utf-8") as f:
            content = f.read()
        if header_flag(content, "hidden") or re.search(
            r'^\s*transposition\s*=\s*"false"', content, re.MULTILINE | re.IGNORECASE
        ):
            continue
        parsed = parse_melody(content)
        if parsed["layout"] is not RICHTER_LAYOUT or not parsed["notes"]:
            continue
        for key, semitones in KEYS.items():
            if semitones != parsed["root"]:
                print(path, semitones, key)


if __name__ == "__main__":
    main()
