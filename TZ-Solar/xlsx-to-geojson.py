import pandas as pd
import json
from pathlib import Path

# Read the Excel file
df = pd.read_excel('/home/user/Documents/OSM_Project/gem1/GEM-Global-Integrated-Power-February-2025-update-II.xlsx', sheet_name=1)

# Group by country and create GeoJSON for each
for country, group in df.groupby('Country/area'):
    features = []
    
    for _, row in group.iterrows():
        # Skip rows with missing coordinates
        if pd.isna(row['Latitude']) or pd.isna(row['Longitude']):
            continue
        
        # Create feature with all row data as properties
        feature = {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [float(row['Longitude']), float(row['Latitude'])]
            },
            "properties": {k: (None if pd.isna(v) else v) for k, v in row.items() 
                          if k not in ['Latitude', 'Longitude']}
        }
        features.append(feature)
    
    # Create GeoJSON structure
    geojson = {
        "type": "FeatureCollection",
        "features": features
    }
    
    # Save to file with sanitized country name
    filename = f"{country.replace('/', '_').replace(' ', '_')}.geojson"
    with open(filename, 'w', encoding='utf-8') as f:
        json.dump(geojson, f, indent=2, ensure_ascii=False)
    
    print(f"Created {filename} with {len(features)} points")

print("Conversion complete!")