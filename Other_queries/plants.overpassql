[out:json][timeout:400];

// Find a random node inside the bounding box
node["place"~"country|state|province"]({{bbox}}) -> .places;

relation["boundary"="administrative"]["admin_level"="2"](bn.places) -> .admin_boundary;

// Convert the relation to an area
.admin_boundary map_to_area -> .searchArea;



// Include power plants within the administrative boundary
node["power"="plant"](area.searchArea) -> .plant_nodes;
way["power"="plant"](area.searchArea) -> .plant_ways;
relation["power"="plant"](area.searchArea) -> .plant_relations;

// Include generators within the administrative boundary
node["power"="generator"](area.searchArea) -> .generator_nodes;
way["power"="generator"](area.searchArea) -> .generator_ways;
relation["power"="generator"](area.searchArea) -> .generator_relations;



// Combine all relevant results
(

  .plant_nodes;
  .plant_ways;
  .plant_relations;
  .generator_nodes;
  .generator_ways;
  .generator_relations;

);

out body;
>;
out skel qt;
