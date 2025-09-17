[out:xml][timeout:500];

// Get the complete administrative boundary relation and its members
relation["boundary"~"administrative|disputed"]["admin_level"~"3|4"]["ISO3166-2"="${iso}"]->.admin_boundary;
(.admin_boundary; >;);
// Convert the full relation into an area, which we use for the subsequent search
.admin_boundary map_to_area ->.searchArea;

// Power line segments and their supports
node(area.searchArea)[~"^(construction:|disused:)?power$"~"^pole|tower|terminal|insulator|portal$"] -> .supports;
way(area.searchArea)[~"^(construction:|disused:)?power$"~"portal"] -> .linear_supports;
way(area.searchArea)[~"^(construction:|disused:)?power$"~"^line|cable$"] -> .segments;
way(area.searchArea)[~"^(construction:|disused:)?power$"~"minor_line"]["voltage"](if:t["voltage"] >= 50000) -> .hv_minorlines;
node.supports[~"^(construction:|disused:)?power$"~"^tower$"] -> .towers;
node.supports(w.segments) -> .supports_hv;

// Substation facilities
nwr(area.searchArea)[~"^(construction:|disused:)?power$"~"substation"] -> .substations;
nw(area.searchArea)[~"^(construction:|disused:)?power$"~"^switchgear|transformer$"] -> .switchgears;

// Generation facilities
nwr(area.searchArea)[~"^(construction:|disused:)?power$"~"^plant|generator$"] -> .generation;

// Circuits and sections relations
rel(bw.segments)[~"^(construction:|disused:)?power$"~"^line_section$"] -> .sections;
rel(bw.segments)[~"^(construction:|disused:)?power$"~"^circuit$"] -> .circuits_simple;
rel(br.sections)[~"^(construction:|disused:)?power$"~"^circuit$"] -> .complex_circuits;

(.circuits_simple; .complex_circuits;) -> .circuits;

// Dependencies gathering
(
  .supports_hv;
  .towers;
  .linear_supports;
  .segments;
  .hv_minorlines;
  .sections;
  .circuits;
  .substations;
  .switchgears;
  .generation;
  .admin_boundary;
);
(._;>;);

out meta;
