/**
SET search_path = scratch, public;
**/

SELECT district_1, polsby_popper(geom), polsby_popper(ST_Transform(geom, 4326)::geography)
FROM geo_cd_proposed_utm18n
ORDER BY 1;

SELECT district_1, schwartzberg(geom), schwartzberg(ST_Transform(geom, 4326)::geography)
FROM geo_cd_proposed_utm18n
ORDER BY 1;

SELECT district_1, reock(geom), area_convex_hull(geom)
FROM geo_cd_proposed_utm18n
ORDER BY 1;

