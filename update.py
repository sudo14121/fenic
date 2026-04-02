import pandas as pd

sheets = {
    "components_elitan.md": "https://docs.google.com/spreadsheets/d/1ndCj3_NiKzpPOuhefEcadm_SQtO8BG06wTF4i4alSe8/export?format=csv&gid=1323661768",
    "components_other.md": "https://docs.google.com/spreadsheets/d/1ndCj3_NiKzpPOuhefEcadm_SQtO8BG06wTF4i4alSe8/export?format=csv&gid=76825789"
}

for filename, url in sheets.items():
    df = pd.read_csv(url).fillna("")
    with open(filename, "w", encoding="utf-8") as f:
        f.write(df.to_markdown(index=False))
