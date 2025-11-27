import pandas as pd
import os

# Load the CSV
df = pd.read_csv('2025_Q3_raw_polygons.csv')

# Create output directory
os.makedirs('outputcsv', exist_ok=True)

# Split by country and save
for country in df['country'].unique():
    country_data = df[df['country'] == country]
    filename = country.replace(' ', '_') + '.csv'
    country_data.to_csv(f'outputcsv/{filename}', index=False)
    print(f"✓ Created {filename} with {len(country_data)} rows")