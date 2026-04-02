import pandas as pd

sheets = {
    "components_elitan.md": "https://docs.google.com/spreadsheets/d/1ndCj3_NiKzpPOuhefEcadm_SQtO8BG06wTF4i4alSe8/gviz/tq?tqx=out:csv&gid=1323661768",
    "components_other.md": "https://docs.google.com/spreadsheets/d/1ndCj3_NiKzpPOuhefEcadm_SQtO8BG06wTF4i4alSe8/gviz/tq?tqx=out:csv&gid=76825789"
}

for filename, url in sheets.items():
    df = pd.read_csv(url)

    df = df.fillna("")

    with open(f"docx/fenic_docx/docs/{filename}", "w", encoding="utf-8") as f:
        f.write(df.to_markdown(index=False))