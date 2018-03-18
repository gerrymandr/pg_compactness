CREATE OR REPLACE FUNCTION polsby_popper(poly1 geometry) RETURNS double precision AS $$
DECLARE
  is_projected boolean;
BEGIN
  SELECT split_part(proj4text, ' ', 1) != '+proj=longlat' INTO is_projected
  FROM spatial_ref_sys
  WHERE srid = ST_SRID(poly1);

  IF NOT is_projected THEN
    RAISE EXCEPTION 'Cast lat-long coordinates to geography type before calling this function.';
  END IF;

  RETURN 4 * pi() * ST_Area(poly1) / (ST_Perimeter(poly1) ^ 2);
    
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION polsby_popper(poly1 geography) RETURNS double precision AS $$
BEGIN

  RETURN 4 * pi() * ST_Area(poly1) / (ST_Perimeter(poly1) ^ 2);
    
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION schwartzberg(poly1 geometry) RETURNS double precision AS $$
BEGIN

  RETURN sqrt(polsby_popper(poly1));
    
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION schwartzberg(poly1 geography) RETURNS double precision AS $$
BEGIN

  RETURN sqrt(polsby_popper(poly1));
    
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION reock(poly1 geometry) RETURNS double precision AS $$
DECLARE
  is_projected boolean;
BEGIN
  SELECT split_part(proj4text, ' ', 1) != '+proj=longlat' INTO is_projected
  FROM spatial_ref_sys
  WHERE srid = ST_SRID(poly1);

  IF NOT is_projected THEN
    RAISE EXCEPTION 'Measure not appropriate for long-lat coordinates.';
  END IF;

  RETURN ST_Area(poly1) / ST_Area(ST_MinimumBoundingCircle(ST_ConvexHull(poly1)));
    
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION area_convex_hull(poly1 geometry) RETURNS double precision AS $$
DECLARE
  is_projected boolean;
BEGIN
  SELECT split_part(proj4text, ' ', 1) != '+proj=longlat' INTO is_projected
  FROM spatial_ref_sys
  WHERE srid = ST_SRID(poly1);

  IF NOT is_projected THEN
    RAISE EXCEPTION 'Measure not appropriate for long-lat coordinates.';
  END IF;

  RETURN ST_Area(poly1) / ST_Area(ST_ConvexHull(poly1));
    
END;
$$ LANGUAGE plpgsql;
