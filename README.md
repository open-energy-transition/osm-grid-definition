# osm-grid-definition

This is repository contains all the overpass queries linked to the OhMyGrid Map It📍 page on https://ohmygrid.org/

The query folder is directly linked to the source code of the page, and every query type is linked to a button on the website. 
When you add a folder, it will automatically create a button for that query type.

**How to add queries**
1. Create a folder inside the queries folder, and name it (this name will also be the button name on the website). One exception is the Default folder, which is in the code of map_it.md.
2. Create three files inside the folder: admin2.overpassql, admin4.overpassql, and version.txt
3. In admin2, add the query making sure the admin_level is set to 2, and the iso_code is the national one. Same goes for admin4
4. Version.txt is just there to add the version number of the query, and will update on the website automatically.

Overall, just follow the current examples.
