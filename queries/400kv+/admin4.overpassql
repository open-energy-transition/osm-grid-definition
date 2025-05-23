[out:xml][timeout:300];
  
  // Get the complete administrative boundary relation and its members
  relation["boundary"="administrative"]["admin_level"="4"]["ISO3166-2"="${iso}"]->.admin_boundary;
  (.admin_boundary; >;);
  // Convert the full relation into an area, which we use for the subsequent search
  .admin_boundary map_to_area ->.searchArea;
  
  // Get towers, poles, lines, cables, etc.
  way["power"="line"]["voltage"](if:t["voltage"] >= 400000)(area.searchArea) -> .high_voltage_lines;
  node(w.high_voltage_lines)["power"="tower"](area.searchArea) -> .towers;
  
  // Get substations 
  nwr["power"="substation"](area.searchArea) -> .all_substations;

(node.all_substations(around.towers:200);
way.all_substations(around.towers:200);
 relation.all_substations(around.towers:200);
)-> .connected_substations;
  
  


node["power"="portal"](area.searchArea) -> .portals;

.connected_substations map_to_area -> .substation_areas;
node.portals(area.substation_areas)->.portals_insidesub;
  


  
  // Union all elements – note that we also include the original admin boundary
  (
    .towers;
    .high_voltage_lines;
    .connected_substations;
    .portals_insidesub;
    .admin_boundary;
  );
  
  // First output: all elements with metadata
  out meta;
  // Second recursion: fetch all members of multipolygon relations, etc.
  >;
  // Output the full geometry (again with meta) so JOSM receives complete data
  out meta;
