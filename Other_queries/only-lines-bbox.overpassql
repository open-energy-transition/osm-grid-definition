[out:json][timeout:300];

node["place"~"country|state|province"]({{bbox}}) -> .places;
relation["boundary"="administrative"]["admin_level"="2"](bn.places) -> .admin_boundary;

  .admin_boundary map_to_area ->.searchArea;
  

  way["power"="line"](area.searchArea) -> .lines_connected;
  way["power"="line"]["voltage"](if:t["voltage"] >= 90000)(area.searchArea) -> .high_voltage_lines;
  way["power"="cable"](area.searchArea) -> .cables;
  
  // Union all elements – note that we also include the original admin boundary
  (
    .cables;
    .lines_connected;
    .high_voltage_lines;
  );
  

  out body;
  >;
  out skel qt;
