[out:xml][timeout:300];
  
// Get the complete administrative boundary relation and its members
relation["boundary"~"administrative|disputed"]["admin_level"="2"]["ISO3166-1:alpha2"="${iso}"]->.admin_boundary;
(.admin_boundary; >;);
// Convert the full relation into an area, which we use for the subsequent search
.admin_boundary map_to_area ->.searchArea;
// ================================
// Industrial-Related Features
// ================================

// General industrial landuse
way["landuse"="industrial"](area.searchArea) -> .industrial_landuse;

// ================================
// Combine and output all results
// ================================
(
  .industrial_landuse;
);

// First output: all elements with metadata
out meta;
// Second recursion: fetch all members of multipolygon relations, etc.
>;
// Output the full geometry (again with meta) so JOSM receives complete data
out meta;
