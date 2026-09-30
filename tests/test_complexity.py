"""Tests for the difficulty analysis in complexity.py.

Each analyze_difficulty() fixture below mirrors how real scores are written:
notes live in a `melodie = { ... }` block, and `\\relative` / the harmonica
tab command appear elsewhere in the file (see e.g. partitions/ah-les-crocodiles.ly).
"""

from complexity import (
    analyze_difficulty,
    brace_block,
    difficulty_cell,
    difficulty_sort_value,
    speed_index,
    strip_comments,
    technique_score,
)


def test_strip_comments_removes_block_and_line_comments():
    text = "a %{ block\ncomment %} b % line comment\nc"
    assert strip_comments(text) == "a  b \nc"


def test_brace_block_extracts_matching_nested_braces():
    text = "{ outer { inner } tail } trailing"
    start = text.index("{") + 1
    assert brace_block(text, start) == " outer { inner } tail "


def test_natural_scale_reports_a_jump_and_a_high_note():
    content = r"""
melodie = {
  \tempo 4 = 120
  c4 d e f g a b c'
}
\diatonicHarmonicaTab \relative c'' { \melodie }
"""
    diff = analyze_difficulty(content)
    assert diff == {
        "bends": 0,
        "overblows": 0,
        "overdraws": 0,
        "jumps": 1,
        "jump_holes": 1,
        "high_notes": 1,
        "tempo": 120,
        "fastest_note": 4,
    }


def test_french_note_names_match_english_equivalent():
    content = r"""
\language "français"
melodie = {
  \tempo 4 = 120
  do4 re mi fa sol la si do'
}
\diatonicHarmonicaTab \relative do'' { \melodie }
"""
    assert analyze_difficulty(content) == {
        "bends": 0,
        "overblows": 0,
        "overdraws": 0,
        "jumps": 1,
        "jump_holes": 1,
        "high_notes": 1,
        "tempo": 120,
        "fastest_note": 4,
    }


def test_bend_is_detected():
    content = r"""
melodie = { c4 f }
\diatonicHarmonicaTab \relative c' { \melodie }
"""
    diff = analyze_difficulty(content)
    assert diff["bends"] == 1
    assert diff["overblows"] == 0
    assert diff["overdraws"] == 0


def test_overblow_is_detected():
    content = r"""
melodie = { c4 dis }
\diatonicHarmonicaTab \relative c' { \melodie }
"""
    diff = analyze_difficulty(content)
    assert diff["overblows"] == 1
    assert diff["bends"] == 0


def test_overdraw_is_detected():
    content = r"""
melodie = { c4 cis'' }
\diatonicHarmonicaTab \relative c' { \melodie }
"""
    diff = analyze_difficulty(content)
    assert diff["overdraws"] == 1


def test_suzuki_five_layout_has_no_bend_or_overblow_notes():
    # The 5-hole Suzuki layout models only natural notes: unlike the Richter
    # layout, no offset in SUZUKI_FIVE_LAYOUT maps to a bend/overblow/overdraw.
    content = r"""
melodie = { c4 d e f g }
\diatonicSuzukiFiveHarmonicaTab \relative c' { \melodie }
"""
    diff = analyze_difficulty(content)
    assert diff["bends"] == 0
    assert diff["overblows"] == 0
    assert diff["overdraws"] == 0


def test_key_signature_tonic_is_not_counted_as_a_note():
    # Regression test: `\key sol \major` used to leave "sol" behind as a
    # phantom extra note once the generic backslash-command stripping
    # removed only the `\key` token (see complexity.py's comment on this).
    without_key = analyze_difficulty(r"""
\language "français"
melodie = {
  do4 re mi
}
\diatonicHarmonicaTab \relative do'' { \melodie }
""")
    with_key = analyze_difficulty(r"""
\language "français"
melodie = {
  \key sol \major
  do4 re mi
}
\diatonicHarmonicaTab \relative do'' { \melodie }
""")
    assert with_key == without_key


def test_defaults_when_tempo_and_duration_are_absent():
    content = r"""
melodie = { c d e }
\diatonicHarmonicaTab \relative c'' { \melodie }
"""
    diff = analyze_difficulty(content)
    assert diff["tempo"] is None
    assert diff["fastest_note"] is None


def test_technique_score_weighs_overblows_and_overdraws_more_than_bends():
    bend_only = {"bends": 2}
    overblow_only = {"overblows": 1}
    assert technique_score(overblow_only) > technique_score(bend_only)


def test_speed_index_uses_defaults_when_missing():
    assert speed_index({}) == speed_index({"tempo": 100, "fastest_note": 4})


def test_difficulty_sort_value_combines_technique_and_speed():
    diff = {"bends": 2, "tempo": 120, "fastest_note": 8}
    assert difficulty_sort_value(diff) == technique_score(diff) + speed_index(diff)


def test_difficulty_cell_marks_note_free_melody_as_easy():
    html = difficulty_cell({"tempo": 100, "fastest_note": 4})
    assert "🟢" in html
    assert "facile" in html
    assert "data-sort='1.67'" in html


def test_difficulty_cell_reports_each_factor_in_the_tooltip():
    diff = {
        "bends": 2,
        "overblows": 1,
        "overdraws": 0,
        "jumps": 1,
        "high_notes": 3,
        "tempo": 120,
        "fastest_note": 8,
    }
    html = difficulty_cell(diff)
    assert "↕2" in html
    assert "⊕1" in html
    assert "⊗" not in html  # no overdraws
    assert "↔1" in html
    assert "▲3" in html
    assert "2 altération(s) / bend(s)" in html
    assert "1 overblow(s)" in html
