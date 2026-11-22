import generate_index


def test_parse_ly_metadata_reads_category(tmp_path):
    ly_file = tmp_path / "song.ly"
    ly_file.write_text(
        '\\header {\n  title = "Song"\n  category = "Comptine"\n}\nmelodie = { c\'4 }\n',
        encoding="utf-8",
    )

    metadata = generate_index.parse_ly_metadata(str(ly_file))

    assert metadata["category"] == "Comptine"


def test_parse_ly_metadata_defaults_missing_category(tmp_path):
    ly_file = tmp_path / "song.ly"
    ly_file.write_text('\\header {\n  title = "Song"\n}\nmelodie = { c\'4 }\n', encoding="utf-8")

    metadata = generate_index.parse_ly_metadata(str(ly_file))

    assert metadata["category"] == "Non classée"
