[out:xml][timeout:300];
  
  // Get the complete administrative boundary relation and its members
  relation["boundary"~"administrative|disputed"]["admin_level"="4"]["ISO3166-1:alpha2"="${iso}"]->.admin_boundary;
  (.admin_boundary; >;);
  // Convert the full relation into an area, which we use for the subsequent search
  .admin_boundary map_to_area ->.searchArea;
  
  way["landuse"="industrial"](area.searchArea)
  
  // First output: all elements with metadata
  out meta;
  // Second recursion: fetch all members of multipolygon relations, etc.
  >;
  // Output the full geometry (again with meta) so JOSM receives complete data
  out meta;
