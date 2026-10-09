# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A collection of songs ("partitions") written in LilyPond for harmonica (diatonic and
chromatic), published as PDF/MIDI/MP3 via GitHub Pages at https://slist.github.io/harmonica/.
Each song's `.ly` source is compiled into several outputs (per-tuning PDF with harmonica
tab, plain sheet music, MIDI, and MP3), then a Python pipeline generates the site's index
pages (song list, difficulty rating, copyright status, audio/PDF player pages).

## Commands

- Run tests: `pytest` (config in `pytest.ini`, `pythonpath = .`)
- Run a single test: `pytest tests/test_complexity.py::test_natural_scale_reports_a_jump_and_a_high_note`
- Lint: `ruff check .` (CI uses `astral-sh/ruff-action`, no local `ruff.toml` — defaults apply)
- Install Python deps for development: `pip install -r requirements-dev.txt`
- Generate the site locally (needs `output/` to already exist, and compiled `.ly` outputs in
  it to enrich rows with PDF/MP3 links — otherwise it still runs but every song shows no
  players): `mkdir -p output && python generate_index.py`
- Merge per-song PDFs into the combined `all_*.pdf` files (reads `output/*.pdf`, must run
  after LilyPond compilation and before/independently of `generate_index.py`):
  `python merge_pdf.py`
- Compile one score locally (mirrors CI, requires `lilypond`, `fluidsynth`, `lame` installed):
  ```
  lilypond -dcompile-diatonique  -o output/<base>_diatonique  partitions/<base>.ly
  lilypond -dcompile-chromatique -o output/<base>_chromatique partitions/<base>.ly
  lilypond -dcompile-partition   -o output/<base>_partition   partitions/<base>.ly
  lilypond --formats=midi -dcompile-midi -o output/<base> partitions/<base>.ly
  ```

## Architecture

### Two build stages, three CI workflows

1. **`.github/workflows/compile-lilypond.yml`** (triggers on `.ly`/`.py` changes): installs the
   latest LilyPond release dynamically (not pinned), compiles every `partitions/*.ly` and
   `gammes/*.ly` into diatonic/chromatic/plain-score PDFs + MIDI (a gamme is compiled for one
   instrument only: chromatic if its `instrument` header says so, diatonic otherwise), renders MIDI → WAV → MP3 via
   `fluidsynth` + `lame`, runs `merge_pdf.py`, then `generate_index.py`, checks for broken
   links with `lychee`, and deploys `output/` to GitHub Pages.
2. **`.github/workflows/tests.yml`** and **`lint.yml`**: pytest and ruff, independent of the
   LilyPond toolchain.

Each compile step passes a `-dcompile-<mode>` LilyPond option, and every `.ly` file reads
these via `ly:get-option` and conditionally includes the matching `\score` block (see
"Anatomy of a partition" below) — this is how one source file produces four different
outputs without recompiling by hand for each.

`scripts/ci/strip_ci_ignored.sh` strips a `.ly` file of everything from a
`% CI-IGNORE-BELOW` marker onward before compilation — the safety net for manual test/scratch
lines left at the bottom of a file during editing.

### Anatomy of a partition (`partitions/*.ly`)

Every song file follows the same shape (see `partitions/mon-ane.ly` for a minimal example):
- `\header { title, composer, composerNationality, copyrightStatus, lyricsLang, youtube, ... }`
  — these fields are scraped by `generate_index.py`'s regex-based parser, not read via
  LilyPond itself.
- `\include "../include/harmonica.ly"` and `"../include/style.ly"` — shared tab-notation
  machinery and visual style.
- A single `melodie = { ... }` block holding the actual notes/rhythm — this is the only part
  `complexity.py` parses to compute difficulty.
- Four `\score` blocks (`diatoniqueScore`, `chromatiqueScore`, `partitionScore`,
  `midiScore`), each wrapping `\melodie` with a different harmonica tab command
  (`\diatonicHarmonicaTab`, `\chromaticHarmonicaTab`, or none), included conditionally based
  on the `compile-*` LilyPond options set from the CLI flags above.
- Non-C-key songs use `\diatonicDHarmonicaTab`, `\diatonicGHarmonicaTab`, etc. (see
  `TUNING_ROOTS` in `complexity.py` and the `add-diatonic-*-ritcher-tabs` definitions in
  `include/harmonica.ly`) when the song is meant to be played on a differently-tuned
  harmonica; `\diatonicSuzukiFiveHarmonicaTab` is used for the 5-hole Suzuki model, and files
  with that variant end in `-suzuki.ly` and get bundled into their own merged PDF (see
  `est_suzuki5` in `merge_pdf.py`) rather than duplicated into the general diatonic PDF.

`include/harmonica.ly` is the notation engine: it defines the harmonica tab glyphs
(blow/draw/bend/overblow/overdraw markups), the hole-mapping tables per tuning
(`get-diatonic-*-ritcher-tab`, `get-diatonic-suzuki-5-c-tab`), and the music functions
(`\diatonicHarmonicaTab`, etc.) that attach tab numbers to notes. `complexity.py`'s
`RICHTER_LAYOUT` / `SUZUKI_FIVE_LAYOUT` tables are a **Python mirror** of this Scheme logic
(semitone offset → hole + technique) — if the tab layout in `include/harmonica.ly` ever
changes, the corresponding table in `complexity.py` must be updated to match, or difficulty
scoring will silently drift out of sync with the actual generated tab.

### The Python site generator (`generate_index.py`, `complexity.py`, `merge_pdf.py`)

- `complexity.py` re-parses the `melodie` block with regexes (it does not use LilyPond) to
  estimate playability: it walks the note sequence tracking absolute pitch (handling
  `\relative` and octave marks `'`/`,`), maps each note to a harmonica hole via the
  layout tables, and scores bends/overblows/overdraws/jumps/high notes plus a tempo-based
  speed index. The full formula is documented (and regenerated) as `output/difficulte.html`
  by `generate_index_html_difficulte` in `generate_index.py` — **update that generator's
  prose alongside any weight/threshold constant changed in `complexity.py`**, since it's
  meant to stay in sync with the code, not just describe it once.
- `generate_index.py` scans `partitions/` and `gammes/`, extracts header metadata per file via
  regex (`parse_ly_metadata`), pairs each song with whatever compiled outputs already exist in
  `output/` (`collect_outputs`, matched by filename convention
  `<base>_diatonique(-N)?.pdf` / `_chromatique(-N)?.pdf` / `<base>(-N)?.mp3`), and renders HTML
  through Jinja2 templates in `templates/` (`index.html`, `gammes.html`, `private.html`,
  `content_page.html`, `player.html`, plus shared `templates/partials/`). It also builds one
  standalone "player" HTML page per song+tuning combining the PDF viewer with a sticky
  audio/YouTube player and prev/next navigation across the song list.
- The `private.html` page (all songs, including copyrighted ones) is gated by a **client-side**
  SHA-256 password check (`PRIVATE_PASSWORD` env var, default `"harmonica"`) — this only hides
  links in the UI; the underlying PDFs/MP3s are still published unauthenticated at their normal
  URL under `output/`. Treat `copyrightStatus` as a display/organization label, not a real
  access control, when reasoning about what's actually public.
- `merge_pdf.py` runs after LilyPond compilation and reads `generate_index.py`'s
  `parse_ly_metadata`/`title_sort_key` to build combined, bookmarked PDFs
  (`all_diatonique.pdf`, `all_chromatique.pdf`, `all_partition.pdf`, `all_suzuki5.pdf`, and the
  `gammes/` equivalents). It runs its work at module import time (no `main()`/entry-point
  guard) — importing it anywhere executes the merge immediately.

### Testing

Only `complexity.py` has tests (`tests/test_complexity.py`). They construct minimal `.ly`
snippets (a `melodie` block + a tab command) rather than depending on files under
`partitions/`, since `analyze_difficulty` only needs that shape — follow the same pattern for
new difficulty-related tests. `generate_index.py` and `merge_pdf.py` currently have no test
coverage.
