[out:xml][timeout:500];

// Get the complete administrative boundary relation and its members
relation["boundary"~"administrative|disputed"]["admin_level"="2"]["ISO3166-1:alpha2"="${iso}"]->.admin_boundary;
(.admin_boundary; >;);
// Convert the full relation into an area, which we use for the subsequent search
.admin_boundary map_to_area ->.searchArea;

// Generation facilities
nwr(area.searchArea)[~"^(construction:|disused:)?power$"~"^generator$"]["generator:source"="solar"] -> .solar_generators;
nwr(area.searchArea)[~"^(construction:|disused:)?power$"~"^plant$"]["plant:source"="solar"] -> .solar_plants;

// Dependencies gathering
(
  .solar_generators;
  .solar_plants;
  .admin_boundary;
);
(._;>;);

out meta;
