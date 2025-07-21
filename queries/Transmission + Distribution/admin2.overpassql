[out:xml][timeout:350];
  
  // Get the complete administrative boundary relation and its members
  relation["boundary"="administrative"]["admin_level"="2"]["ISO3166-1:alpha2"="${iso}"]->.admin_boundary;
  (.admin_boundary; >;);
  // Convert the full relation into an area, which we use for the subsequent search
  .admin_boundary map_to_area ->.searchArea;
  
  // Get towers, poles, lines, cables, etc.
  node["power"="tower"](area.searchArea) -> .towers;
  node["power"="pole"](area.searchArea) -> .poles;
  way["power"="line"](area.searchArea) -> .lines_connected;
  way["power"="cable"](area.searchArea) -> .cables;
  node.poles(w.high_voltage_lines) -> .hv_poles;
  // INCLUDE MINOR LINES
  way["power"="minor_line"](area.searchArea) -> .minor_lines;
  
  // Get substations explicitly as nodes, ways, and relations
  node["power"="substation"](area.searchArea) -> .substation_nodes;
  way["power"="substation"](area.searchArea) -> .substation_ways;
  relation["power"="substation"](area.searchArea) -> .substation_relations;
  
  // And similarly for power plants, generators, and transformers
  node["power"="plant"](area.searchArea) -> .plant_nodes;
  way["power"="plant"](area.searchArea) -> .plant_ways;
  relation["power"="plant"](area.searchArea) -> .plant_relations;
  
  node["power"="generator"](area.searchArea) -> .generator_nodes;
  way["power"="generator"](area.searchArea) -> .generator_ways;
  relation["power"="generator"](area.searchArea) -> .generator_relations;
  
  node["power"="transformer"](area.searchArea) -> .transformer_nodes;
  way["power"="transformer"](area.searchArea) -> .transformer_ways;
  relation["power"="transformer"](area.searchArea) -> .transformer_relations;
  
  node["power"="portal"](area.searchArea) -> .portal_nodes;

  // Get under construction infra
  node["construction:power"](area.searchArea) -> .construction_nodes;
  way["construction:power"](area.searchArea) -> .construction_ways;
  relation["construction:power"](area.searchArea) -> .construction_relations;
  
  
  // Union all elements – note that we also include the original admin boundary. INCLUDE POLES and MINOR_LINES
  (
    .towers;
    .hv_poles;
    .cables;
    .poles;
    .lines_connected;
    .minor_lines;
    .substation_nodes;
    .substation_ways;
    .substation_relations;
    .plant_nodes;
    .plant_ways;
    .plant_relations;
    .generator_nodes;
    .generator_ways;
    .generator_relations;
    .portal_nodes;
    .transformer_nodes;
    .transformer_ways;
    .transformer_relations;
    .construction_nodes;
    .construction_ways;
    .construction_relations;
    .admin_boundary;
  );
  
  // First output: all elements with metadata
  out meta;
  // Second recursion: fetch all members of multipolygon relations, etc.
  >;
  // Output the full geometry (again with meta) so JOSM receives complete data
  out meta;
