

CREATE TABLE dt_location(
    location_id INTEGER PRIMARY KEY,
    location VARCHAR(300),
    longitude VARCHAR(300),
    latitude VARCHAR(300),
    functionalArea VARCHAR(300)
);

CREATE TABLE dt_measurement_type(
    measurement_type_id INTEGER PRIMARY KEY,
    measurement_type VARCHAR,
    unit VARCHAR
)

CREATE TABLE ft_measurement (
    value NUMERIC,
    accuracy NUMERIC,
    PRIMARY KEY(value, accuracy)
);