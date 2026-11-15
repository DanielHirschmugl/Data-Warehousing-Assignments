--Task 3

DROP TABLE IF EXISTS ft_passenger_booking;
DROP TABLE IF EXISTS dt_booking;
DROP TABLE IF EXISTS dt_flight;
DROP TABLE IF EXISTS dt_passenger;
DROP TABLE IF EXISTS bt_airline_alliance;
DROP TABLE IF EXISTS dt_airline;
DROP TABLE IF EXISTS dt_alliance;
DROP TABLE IF EXISTS dt_airport;
DROP TABLE IF EXISTS dt_date;
DROP TABLE IF EXISTS dt_cross_data;

CREATE TABLE dt_cross_data(
    cross_data_id INTEGER PRIMARY KEY,
    booking_class VARCHAR(50) NOT NULL,
    booking_type VARCHAR(50) NOT NULL,
    UNIQUE(booking_class, booking_type)
);

INSERT INTO dt_cross_data VALUES (1, 'Economy', 'Online');
INSERT INTO dt_cross_data VALUES (2, 'Economy', 'Reisebüro');
INSERT INTO dt_cross_data VALUES (3, 'Business', 'Online');
INSERT INTO dt_cross_data VALUES (4, 'Business', 'Reisebüro');

CREATE TABLE dt_date (
    date_id       INTEGER PRIMARY KEY,
    full_date     DATE NOT NULL UNIQUE,
    day_of_month  INTEGER NOT NULL,
    day_of_week   INTEGER NOT NULL,
    day_name      VARCHAR(20) NOT NULL,
    month_of_year INTEGER NOT NULL,
    month_name    VARCHAR(20) NOT NULL,
    quarter       INTEGER NOT NULL,
    year          INTEGER NOT NULL
);

INSERT INTO dt_date VALUES (0, '1900-01-01', 1, 1, 'n/a', 1, 'n/a', 1, 1900);
INSERT INTO dt_date VALUES (20261101, '2026-11-01', 1, 7, 'Sonntag', 11, 'November', 4, 2026);
INSERT INTO dt_date VALUES (20261115, '2026-11-15', 15, 7, 'Sonntag', 11, 'November', 4, 2026);
INSERT INTO dt_date VALUES (20261201, '2026-12-01', 1, 2, 'Dienstag', 12, 'Dezember', 4, 2026);

CREATE TABLE dt_airport(
    airport_id INTEGER PRIMARY KEY,
    airport VARCHAR(100) NOT NULL UNIQUE,
    city_id INTEGER NOT NULL,
    city VARCHAR(100) NOT NULL,
    country_id INTEGER NOT NULL,
    country VARCHAR(100) NOT NULL
);

INSERT INTO dt_airport VALUES (1, 'VIE Wien-Schwechat', 1, 'Wien', 1, 'Österreich');
INSERT INTO dt_airport VALUES (2, 'FRA Frankfurt am Main', 2, 'Frankfurt am Main', 2, 'Deutschland');
INSERT INTO dt_airport VALUES (3, 'JFK John F. Kennedy', 3, 'New York', 3, 'USA');

CREATE TABLE dt_alliance(
    alliance_id INTEGER PRIMARY KEY,
    alliance VARCHAR(100) NOT NULL UNIQUE,
    headquarter_country_id INTEGER NOT NULL,
    headquarter_country VARCHAR(100) NOT NULL
);

INSERT INTO dt_alliance VALUES (1, 'Star Alliance', 1, 'Deutschland');
INSERT INTO dt_alliance VALUES (2, 'SkyTeam', 2, 'Niederlande');

CREATE TABLE dt_airline(
    airline_id INTEGER PRIMARY KEY,
    airline VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO dt_airline VALUES (0, 'n/a');
INSERT INTO dt_airline VALUES (1, 'Austrian Airlines');
INSERT INTO dt_airline VALUES (2, 'Lufthansa');
INSERT INTO dt_airline VALUES (3, 'Air France');
INSERT INTO dt_airline VALUES (4, 'Condor');

CREATE TABLE bt_airline_alliance(
    airline INTEGER NOT NULL REFERENCES dt_airline(airline_id),
    alliance INTEGER NOT NULL REFERENCES dt_alliance(alliance_id),
    PRIMARY KEY(airline, alliance)
);

INSERT INTO bt_airline_alliance VALUES (1, 1);
INSERT INTO bt_airline_alliance VALUES (2, 1);
INSERT INTO bt_airline_alliance VALUES (3, 2);

CREATE TABLE dt_passenger(
    passenger_id INTEGER PRIMARY KEY,
    passenger VARCHAR(100) NOT NULL,
    passenger_type_id INTEGER NOT NULL,
    passenger_type VARCHAR(30) NOT NULL,
    gender_id INTEGER NOT NULL,
    gender VARCHAR(20) NOT NULL,
    nationality_id INTEGER NOT NULL,
    nationality VARCHAR(100) NOT NULL,
    membership_program_id INTEGER NOT NULL,
    membership_program_name VARCHAR(100) NOT NULL
);

INSERT INTO dt_passenger VALUES (1, 'Anna Huber', 1, 'Erwachsener', 1, 'weiblich', 1, 'Österreich', 1, 'Miles & More');
INSERT INTO dt_passenger VALUES (2, 'Lukas Huber', 2, 'Kind', 2, 'männlich', 1, 'Österreich', 0, 'n/a');
INSERT INTO dt_passenger VALUES (3, 'John Smith', 1, 'Erwachsener', 2, 'männlich', 2, 'USA', 2, 'Flying Blue');

CREATE TABLE dt_flight(
    flight_id INTEGER PRIMARY KEY,
    flight VARCHAR(20) NOT NULL,
    date INTEGER NOT NULL REFERENCES dt_date(date_id),
    operator_id INTEGER NOT NULL REFERENCES dt_airline(airline_id),
    route_id INTEGER NOT NULL,
    route VARCHAR(50) NOT NULL,
    great_circle_distance NUMERIC(8,1) NOT NULL,
    origin INTEGER NOT NULL REFERENCES dt_airport(airport_id),
    destination INTEGER NOT NULL REFERENCES dt_airport(airport_id),
    UNIQUE(flight, date)
);

INSERT INTO dt_flight VALUES (1, 'OS 121', 20261201, 1, 1, 'VIE-FRA', 620.0, 1, 2);
INSERT INTO dt_flight VALUES (2, 'LH 400', 20261201, 2, 2, 'FRA-JFK', 6204.0, 2, 3);
INSERT INTO dt_flight VALUES (3, 'OS 87', 20261201, 1, 3, 'VIE-JFK', 6838.0, 1, 3);
INSERT INTO dt_flight VALUES (4, 'DE 2310', 20261201, 4, 1, 'VIE-FRA', 620.0, 1, 2);

CREATE TABLE dt_booking(
    booking_id INTEGER PRIMARY KEY,
    booking VARCHAR(20) NOT NULL UNIQUE,
    date INTEGER NOT NULL REFERENCES dt_date(date_id),
    seller_id INTEGER NOT NULL REFERENCES dt_airline(airline_id)
);

INSERT INTO dt_booking VALUES (0, 'n/a', 0, 0);
INSERT INTO dt_booking VALUES (1, 'K7XQ2M', 20261101, 1);
INSERT INTO dt_booking VALUES (2, 'P4LT9Z', 20261115, 2);

CREATE TABLE ft_passenger_booking(
    flight INTEGER NOT NULL REFERENCES dt_flight(flight_id),
    booking INTEGER NOT NULL REFERENCES dt_booking(booking_id),
    passenger INTEGER NOT NULL REFERENCES dt_passenger(passenger_id),
    cross_data INTEGER NOT NULL REFERENCES dt_cross_data(cross_data_id),
    price NUMERIC(10,2) NOT NULL,
    tax NUMERIC(10,2) NOT NULL,
    PRIMARY KEY(flight, passenger)
);

INSERT INTO ft_passenger_booking VALUES (1, 1, 1, 1, 129.00, 38.50);
INSERT INTO ft_passenger_booking VALUES (2, 1, 1, 1, 540.00, 112.30);
INSERT INTO ft_passenger_booking VALUES (1, 1, 2, 1, 96.75, 38.50);
INSERT INTO ft_passenger_booking VALUES (2, 1, 2, 1, 405.00, 112.30);
INSERT INTO ft_passenger_booking VALUES (3, 2, 3, 3, 2350.00, 187.90);
INSERT INTO ft_passenger_booking VALUES (4, 0, 3, 4, 0.00, 0.00);