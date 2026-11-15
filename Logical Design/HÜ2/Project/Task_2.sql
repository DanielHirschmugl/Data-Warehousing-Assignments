DROP TABLE IF EXISTS ft_measurement;
DROP TABLE IF EXISTS dt_cross_data;
DROP TABLE IF EXISTS dt_agent;
DROP TABLE IF EXISTS bt_agent_specification;
DROP TABLE IF EXISTS specification;
DROP TABLE IF EXISTS dt_time;
DROP TABLE IF EXISTS dt_date;
DROP TABLE IF EXISTS dt_measurement_type;
DROP TABLE IF EXISTS dt_location;

CREATE TABLE dt_location(
    location_id INTEGER PRIMARY KEY,
    location VARCHAR(300) NOT NULL,
    longitude VARCHAR(300) NOT NULL,
    latitude VARCHAR(300) NOT NULL,
    current_functional_area_id INTEGER NOT NULL,
    current_functional_area VARCHAR(300) NOT NULL,
    previous_functional_area_id INTEGER NOT NULL,
    previous_functional_area VARCHAR(300) NOT NULL
);

INSERT INTO dt_location VALUES (0, 'n/a', 'n/a', 'n/a', 0, 'n/a', 0, 'n/a');
INSERT INTO dt_location VALUES (1, 'Halle A - Maschine 1', '14.2858', '48.3069', 1, 'Produktion', 0, 'n/a');
INSERT INTO dt_location VALUES (2, 'Halle B - Lager Regal 3', '14.2861', '48.3072', 2, 'Logistik', 0, 'n/a');

CREATE TABLE dt_measurement_type(
    measurement_type_id INTEGER PRIMARY KEY,
    measurement_type VARCHAR(300) NOT NULL,
    unit VARCHAR(300) NOT NULL
);

INSERT INTO dt_measurement_type VALUES (1, 'Temperatur', '°C');
INSERT INTO dt_measurement_type VALUES (2, 'Luftfeuchtigkeit', '%');
INSERT INTO dt_measurement_type VALUES (3, 'Druck', 'bar');

CREATE TABLE dt_date (
    date_id       INTEGER PRIMARY KEY,
    full_date     DATE NOT NULL UNIQUE,
    day_of_month  INTEGER NOT NULL,
    month_of_year INTEGER NOT NULL,
    year          INTEGER NOT NULL,
    day_name      VARCHAR(300) NOT NULL,
    month_name    VARCHAR(300) NOT NULL
);

INSERT INTO dt_date VALUES (20261115, '2026-11-15', 15, 11, 2026, 'Sonntag', 'November');
INSERT INTO dt_date VALUES (20261116, '2026-11-16', 16, 11, 2026, 'Montag', 'November');

CREATE TABLE dt_time (
    time_id          INTEGER PRIMARY KEY,
    hour_of_day      INTEGER NOT NULL,
    minute_of_hour   INTEGER NOT NULL,
    second_of_minute INTEGER NOT NULL
);

INSERT INTO dt_time VALUES (153045, 15, 30, 45);
INSERT INTO dt_time VALUES (153047, 15, 30, 47);
INSERT INTO dt_time VALUES (80000, 8, 0, 0);
INSERT INTO dt_time VALUES (80002, 8, 0, 2);

CREATE TABLE specification(
    specification_id INTEGER PRIMARY KEY,
    specification VARCHAR(300) NOT NULL
);

INSERT INTO specification VALUES (0, 'n/a');
INSERT INTO specification VALUES (1, 'IP67');
INSERT INTO specification VALUES (2, 'ATEX');
INSERT INTO specification VALUES (3, 'CE');

CREATE TABLE bt_agent_specification(
    agent_specification_id INTEGER NOT NULL,
    specification_id INTEGER REFERENCES specification(specification_id),
    PRIMARY KEY(agent_specification_id, specification_id)
);

INSERT INTO bt_agent_specification VALUES (0, 0);
INSERT INTO bt_agent_specification VALUES (1, 1);
INSERT INTO bt_agent_specification VALUES (1, 3);
INSERT INTO bt_agent_specification VALUES (2, 1);
INSERT INTO bt_agent_specification VALUES (2, 2);
INSERT INTO bt_agent_specification VALUES (2, 3);

CREATE TABLE dt_agent(
    agent_id INTEGER PRIMARY KEY,
    agent VARCHAR(300) NOT NULL,
    agent_type_id INTEGER NOT NULL,
    agent_type VARCHAR(300) NOT NULL,
    age_id INTEGER NOT NULL,
    age VARCHAR(300) NOT NULL,
    position_id INTEGER NOT NULL,
    position VARCHAR(300) NOT NULL,
    process_type_id INTEGER NOT NULL,
    process_type VARCHAR(300) NOT NULL,
    physical_device_id INTEGER NOT NULL,
    physical_device VARCHAR(300) NOT NULL,
    agent_specification INTEGER NOT NULL,
    nominalAccuracy INTEGER NOT NULL,
    logical_device_id INTEGER NOT NULL,
    logical_device VARCHAR(300) NOT NULL,
    part_of_id INTEGER NOT NULL,
    part_of VARCHAR(300) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES dt_location(location_id),
    logical_device_type_id INTEGER NOT NULL,
    logical_device_type VARCHAR(300) NOT NULL,
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    is_current BOOLEAN NOT NULL,
    UNIQUE(agent, valid_from), --Zweimal derselbe Agent darf nicht am selben Tag beginnen
    CHECK(valid_from <= valid_to)
);

INSERT INTO dt_agent VALUES (1, 'Max Mustermann', 1, 'Person', 1, '30-39', 2, 'Techniker', 0, 'n/a', 0, 'n/a', 0, 0, 0, 'n/a', 0, 'n/a', 0, 0, 'n/a', '2025-01-01', '9999-12-31', TRUE);
INSERT INTO dt_agent VALUES (2, 'Qualitätsprüfung Linie 1', 2, 'Process', 0, 'n/a', 0, 'n/a', 1, 'Qualitätskontrolle', 0, 'n/a', 0, 0, 0, 'n/a', 0, 'n/a', 0, 0, 'n/a', '2025-01-01', '9999-12-31', TRUE);
INSERT INTO dt_agent VALUES (3, 'Temperatursensor TS-01', 3, 'Device', 0, 'n/a', 0, 'n/a', 0, 'n/a', 1, 'Sensor SN-48213', 1, 1, 2, 'Temperaturfühler Maschine 1', 1, 'Steuerung Maschine 1', 1, 1, 'Temperaturfühler', '2025-01-01', '9999-12-31', TRUE);
INSERT INTO dt_agent VALUES (4, 'Drucksensor PS-07', 3, 'Device', 0, 'n/a', 0, 'n/a', 0, 'n/a', 2, 'Sensor SN-77120', 2, 2, 3, 'Druckmessung Lager', 0, 'n/a', 2, 2, 'Druckfühler', '2025-01-01', '9999-12-31', TRUE);


CREATE TABLE dt_cross_data(
    cross_id INTEGER PRIMARY KEY,
    transformation VARCHAR(300) NOT NULL
);

INSERT INTO dt_cross_data VALUES (1, 'raw');
INSERT INTO dt_cross_data VALUES (2, 'calibrated');
INSERT INTO dt_cross_data VALUES (3, 'averaged');

CREATE TABLE ft_measurement (
    agent INTEGER REFERENCES dt_agent(agent_id),
    location INTEGER REFERENCES dt_location(location_id),
    measurement_type INTEGER REFERENCES dt_measurement_type(measurement_type_id),
    sensing_date_id     INTEGER NOT NULL REFERENCES dt_date(date_id),
    sensing_time_id     INTEGER NOT NULL REFERENCES dt_time(time_id),
    reception_date_id   INTEGER NOT NULL REFERENCES dt_date(date_id),
    reception_time_id   INTEGER NOT NULL REFERENCES dt_time(time_id),
    cross_data INTEGER REFERENCES dt_cross_data(cross_id),
    value NUMERIC NOT NULL,
    accuracy NUMERIC NOT NULL,
    PRIMARY KEY(agent, location, measurement_type, cross_data, sensing_date_id, sensing_time_id, reception_date_id, reception_time_id)
);

INSERT INTO ft_measurement VALUES (3, 1, 1, 20261115, 153045, 20261115, 153047, 1, 72.4, 0.5);
INSERT INTO ft_measurement VALUES (3, 1, 1, 20261115, 153045, 20261115, 153047, 2, 72.1, 0.2);
INSERT INTO ft_measurement VALUES (4, 2, 3, 20261116, 80000, 20261116, 80002, 1, 2.35, 0.01);
INSERT INTO ft_measurement VALUES (1, 2, 2, 20261116, 80000, 20261116, 80000, 1, 45.0, 2.0);
INSERT INTO ft_measurement VALUES (2, 0, 1, 20261115, 153045, 20261115, 153047, 3, 71.9, 0.3);





--Max wird ab 01.12.2026 Schichtleiter.
UPDATE dt_agent SET valid_to = '2026-11-30', is_current = FALSE WHERE agent = 'Max Mustermann' AND is_current = TRUE;
INSERT INTO dt_agent VALUES (5, 'Max Mustermann', 1, 'Person', 1, '30-39', 1, 'Schichtleiter', 0, 'n/a', 0, 'n/a', 0, 0, 0, 'n/a', 0, 'n/a', 0, 0, 'n/a', '2026-12-01', '9999-12-31', TRUE);

--Drucksensor ziehm ab 01.12.2026 an Maschine 1 um
UPDATE dt_agent SET valid_to = '2026-11-30', is_current = FALSE WHERE agent = 'Drucksensor PS-07' AND is_current = TRUE;
INSERT INTO dt_agent VALUES (6, 'Drucksensor PS-07', 3, 'Device', 0, 'n/a', 0, 'n/a', 0, 'n/a', 2, 'Sensor SN-77120', 2, 2, 3, 'Druckmessung Maschine 1', 0, 'n/a', 1, 2, 'Druckfühler', '2026-12-01', '9999-12-31', TRUE);

--Maschine 1 wechselt von Produktion zu Qualitätssicherung
UPDATE dt_location SET previous_functional_area_id = current_functional_area_id, previous_functional_area = current_functional_area, current_functional_area_id = 3, current_functional_area = 'Qualitätssicherung' WHERE location_id = 1;
