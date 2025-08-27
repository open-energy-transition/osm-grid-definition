[out:xml][timeout:300];

// Get the complete administrative boundary relation and its members
relation["boundary"="administrative"]["admin_level"="2"]["ISO3166-1:alpha2"="${iso}"]->.admin_boundary;
(.admin_boundary; >;);
// Convert the full relation into an area, which we use for the subsequent search
.admin_boundary map_to_area ->.searchArea;

// Power segments
way(area.searchArea)[~"(construction:|disused:)?power$"~"line|cable"]["voltage"](if:t["voltage"] >= 400000) -> .segments;
node(w.segments)[~"(construction:|disused:)?power$"~"tower|pole|portal|insulator|terminal"] -> .supports;

// Substations 
nwr(area.searchArea)[~"(construction:|disused:)?power$"~"substation"] -> .substations_all;

(node.substations_all(around.supports:200);
way.substations_all(around.supports:200);
relation.substations_all(around.supports:200);
)-> .substations;

.connected_substations map_to_area -> .substation_areas;
nw(area.substations)["power"~"tower|pole|portal|insulator|terminal"]->.substations_supports;
nw(area.substations)[~"^(construction:|disused:)?power$"~"^switchgear|transformer$"]->.substations_switchgears;

// Circuits and sections relations
rel(bw.segments)["power"="line_section"] -> .sections;
rel(bw.segments)["power"="circuit"] -> .circuits_simple;
rel(br.sections)["power"="circuit"] -> .complex_circuits;


// Union all elements – note that we also include the original admin boundary
(
  .segments;
  .supports;
  .substations;
  .substations_supports;
  .substations_switchgears;
  .sections;
  .circuits_simple;
  .complex_circuits;
  .admin_boundary;
);
(._;>;);

out meta;
