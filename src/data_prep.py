import os

import pandas as pd

input_path = "data/raw/Historical Station Counts by State 2007-2021.xlsx"

def clean_data(df: pd.DataFrame) -> pd.DataFrame:
    df_cleaned = df.dropna(how="all")
    df_cleaned = df_cleaned.rename(columns={"Totald" : "Total"})
    df_cleaned = df_cleaned[["State", "Total"]]
    df_cleaned = df_cleaned.dropna()
    df_cleaned['State'] = df_cleaned['State'].astype('category')
    return df_cleaned

df_total = pd.DataFrame()
for n in range(2007, 2022, 1):
    df = pd.read_excel(input_path, sheet_name=str(n), skiprows=1)
    df_cleaned = clean_data(df)
    df_cleaned["Year"] = pd.to_datetime(n, format="%Y")
    df_total = pd.concat([df_total, df_cleaned])

df_total = df_total[df_total['State'] == 'Total']
df_total = df_total.drop('State', axis=1)
df_total = df_total.reset_index(drop=True)
df_total = df_total.set_index('Year')

# Save the csv
output_path = "data/processed/cleaned.csv"
dir = os.path.dirname(output_path)
if not os.path.exists(dir):
    os.mkdir(dir)
df_total.to_csv(output_path)