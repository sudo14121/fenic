from pathlib import Path

script_dir = Path(__file__).parent

index_file = script_dir / "index.md"

files_to_append = [
    script_dir / "components_elitan.md",
    script_dir / "components_other.md"
]

with open(index_file, "a", encoding="utf-8") as index:
    for fpath in files_to_append:
        with open(fpath, "r", encoding="utf-8") as f:
            index.write("\n\n")
            index.write(f.read())
