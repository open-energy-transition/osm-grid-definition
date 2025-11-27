import pandas as pd
import os
import json

# Load the CSV
df = pd.read_csv('2025_Q3_raw_polygons.csv')

# Expected coordinate column names
LAT_COL = 'latitude' if 'latitude' in df.columns else 'lat'
LON_COL = 'longitude' if 'longitude' in df.columns else 'lon'

# Create output directory
os.makedirs('outputgeo', exist_ok=True)

# Split by country and save GeoJSON
for country in df['country'].unique():
    country_data = df[df['country'] == country]

    features = []
    for _, row in country_data.iterrows():
        lat = row[LAT_COL]
        lon = row[LON_COL]

        # Skip invalid coordinates
        if pd.isna(lat) or pd.isna(lon):
            continue

        feature = {
            "type": "Feature",
            "properties": row.drop([LAT_COL, LON_COL]).to_dict(),
            "geometry": {
                "type": "Point",
                "coordinates": [float(lon), float(lat)]  # correct GeoJSON order
            }
        }
        features.append(feature)

    geojson = {
        "type": "FeatureCollection",
        "features": features
    }

    filename = country.replace(' ', '_') + '.geojson'
    with open(f'outputgeo/{filename}', 'w', encoding='utf-8') as f:
        json.dump(geojson, f, indent=2)

    print(f"✓ Created {filename} with {len(features)} valid features")
