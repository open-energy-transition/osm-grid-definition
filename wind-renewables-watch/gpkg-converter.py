import geopandas as gpd
import os

# Load the GPKG
gdf = gpd.read_file('wind_all_2024q2_v1.gpkg')

# Reproject to EPSG:4326 (WGS84 lat/lon)
gdf = gdf.to_crs(epsg=4326)

os.makedirs('outputgeo', exist_ok=True)

# Split by country and save as GeoJSON
for country in gdf['COUNTRY'].unique():
    country_data = gdf[gdf['COUNTRY'] == country]
    filename = country.replace(' ', '_') + '.geojson'
    country_data.to_file(f'outputgeo/{filename}', driver='GeoJSON')
    print(f"✓ Created {filename} with {len(country_data)} features")