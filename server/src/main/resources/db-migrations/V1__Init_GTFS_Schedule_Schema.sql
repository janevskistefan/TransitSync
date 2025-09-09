CREATE SCHEMA IF NOT EXISTS gtfs;
-- =================================================================
-- 1. HELPER FUNCTIONS & CUSTOM DOMAINS
-- =================================================================
-- A helper function to validate a timezone name against the internal pg_timezone_names view.
CREATE OR REPLACE FUNCTION gtfs.is_valid_timezone(tz_name TEXT) RETURNS BOOLEAN LANGUAGE plpgsql STABLE AS $$ BEGIN RETURN EXISTS (
		SELECT 1
		FROM pg_timezone_names
		WHERE name = tz_name
	);
END;
$$;
-- Creates a reusable latitude type that must be between -90 and 90.
CREATE DOMAIN gtfs.latitude AS DOUBLE PRECISION CHECK (
	VALUE >= -90
	AND VALUE <= 90
);
-- Creates a reusable longitude type that must be between -180 and 180.
CREATE DOMAIN gtfs.longitude AS DOUBLE PRECISION CHECK (
	VALUE >= -180
	AND VALUE <= 180
);
-- Creates a reusable type for non-negative integers.
CREATE DOMAIN gtfs.non_negative_int AS INTEGER CHECK (VALUE >= 0);
-- Creates a reusable type for non-negative real numbers.
CREATE DOMAIN gtfs.non_negative_real AS REAL CHECK (VALUE >= 0.0);
-- Creates a reusable type for IETF BCP 47 language codes.
CREATE DOMAIN gtfs.language_code AS TEXT CHECK (
	VALUE ~ '^[a-zA-Z]{2,3}(-[a-zA-Z]{3})?(-[a-zA-Z]{4})?(-[a-zA-Z]{2}|-[0-9]{3})?$'
);
-- Creates a reusable type for a valid URL format (http or https).
CREATE DOMAIN gtfs.url AS TEXT CHECK (
	VALUE ~ '^(https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$'
);
-- Creates a reusable type for a valid email format.
CREATE DOMAIN gtfs.email AS TEXT CHECK (VALUE ~ '^\S+@\S+\.\S+$');
-- =================================================================
-- 2. LOOKUP & DICTIONARY TABLES
-- =================================================================
-- Stores ISO 4217 currency codes.
CREATE TABLE IF NOT EXISTS gtfs.currencies (
	code CHAR(3) PRIMARY KEY,
	name TEXT NOT NULL
);
INSERT INTO gtfs.currencies (code, name)
VALUES ('USD', 'United States Dollar'),
	('EUR', 'Euro'),
	('JPY', 'Japanese Yen'),
	('GBP', 'British Pound'),
	('CAD', 'Canadian Dollar') ON CONFLICT (code) DO NOTHING;
-- Stores the GTFS route_type options (e.g., Bus, Rail, Ferry).
CREATE TABLE IF NOT EXISTS gtfs.route_types (id SMALLINT PRIMARY KEY, name TEXT NOT NULL);
INSERT INTO gtfs.route_types (id, name)
VALUES (0, 'Tram, Streetcar, Light rail'),
	(1, 'Subway, Metro'),
	(2, 'Rail'),
	(3, 'Bus'),
	(4, 'Ferry'),
	(5, 'Cable tram'),
	(6, 'Aerial lift, suspended cable car'),
	(7, 'Funicular'),
	(11, 'Trolleybus'),
	(12, 'Monorail') ON CONFLICT (id) DO NOTHING;
-- Stores the GTFS direction_id options, indicating the direction of travel for a trip.
CREATE TABLE IF NOT EXISTS gtfs.directions (id SMALLINT PRIMARY KEY, name TEXT NOT NULL);
INSERT INTO gtfs.directions (id, name)
VALUES (0, 'Outbound travel'),
	(1, 'Inbound travel') ON CONFLICT (id) DO NOTHING;
-- Stores the GTFS options for wheelchair accessibility and bike/car accommodation.
CREATE TABLE IF NOT EXISTS gtfs.accommodation_types (
	id SMALLINT PRIMARY KEY,
	description TEXT NOT NULL
);
INSERT INTO gtfs.accommodation_types (id, description)
VALUES (0, 'No information available'),
	(1, 'Accommodation is available for at least one'),
	(2, 'No accommodation is available') ON CONFLICT (id) DO NOTHING;
-- Stores the GTFS pickup_type and drop_off_type options for regularly scheduled service.
CREATE TABLE IF NOT EXISTS gtfs.pickup_drop_off_types (
	id SMALLINT PRIMARY KEY,
	description TEXT NOT NULL
);
INSERT INTO gtfs.pickup_drop_off_types (id, description)
VALUES (0, 'Regularly scheduled'),
	(1, 'No pickup/drop off available'),
	(2, 'Must phone agency to arrange'),
	(3, 'Must coordinate with driver to arrange') ON CONFLICT (id) DO NOTHING;
-- Stores the GTFS options for continuous "hail and ride" style pickup and drop-off.
CREATE TABLE IF NOT EXISTS gtfs.continuous_pickup_drop_off_types (
	id SMALLINT PRIMARY KEY,
	description TEXT NOT NULL
);
INSERT INTO gtfs.continuous_pickup_drop_off_types (id, description)
VALUES (0, 'Continuous stopping available'),
	(1, 'No continuous stopping available'),
	(
		2,
		'Must phone agency to arrange continuous stopping'
	),
	(
		3,
		'Must coordinate with driver to arrange continuous stopping'
	) ON CONFLICT (id) DO NOTHING;
-- Stores the GTFS options for a stop's location_type (e.g., Stop, Station, Entrance).
CREATE TABLE IF NOT EXISTS gtfs.stop_location_types (id SMALLINT PRIMARY KEY, name TEXT NOT NULL);
INSERT INTO gtfs.stop_location_types (id, name)
VALUES (0, 'Stop or Platform'),
	(1, 'Station'),
	(2, 'Entrance or Exit'),
	(3, 'Generic Node'),
	(4, 'Boarding Area') ON CONFLICT (id) DO NOTHING;
-- Stores the GTFS options for wheelchair boarding at a specific stop.
CREATE TABLE IF NOT EXISTS gtfs.wheelchair_boarding_types (id SMALLINT PRIMARY KEY, name TEXT NOT NULL);
INSERT INTO gtfs.wheelchair_boarding_types (id, name)
VALUES (0, 'No information'),
	(1, 'Some wheelchair boarding is possible'),
	(2, 'No wheelchair boarding is possible') ON CONFLICT (id) DO NOTHING;
-- Stores the GTFS options for fare_attributes.payment_method.
CREATE TABLE IF NOT EXISTS gtfs.payment_methods (id SMALLINT PRIMARY KEY, name TEXT NOT NULL);
INSERT INTO gtfs.payment_methods (id, name)
VALUES (0, 'Fare is paid on board'),
	(1, 'Fare must be paid before boarding') ON CONFLICT (id) DO NOTHING;
-- Stores the GTFS options for transfers.transfer_type.
CREATE TABLE IF NOT EXISTS gtfs.transfer_types (id SMALLINT PRIMARY KEY, name TEXT NOT NULL);
INSERT INTO gtfs.transfer_types (id, name)
VALUES (0, 'Recommended transfer point'),
	(1, 'Timed transfer point'),
	(2, 'Minimum time required for transfer'),
	(3, 'Transfers are not possible') ON CONFLICT (id) DO NOTHING;
-- Stores the GTFS options for service availability (0 or 1) for days of the week.
CREATE TABLE IF NOT EXISTS gtfs.service_availability (id SMALLINT PRIMARY KEY, name TEXT NOT NULL);
INSERT INTO gtfs.service_availability (id, name)
VALUES (0, 'Service is not available'),
	(1, 'Service is available') ON CONFLICT (id) DO NOTHING;
-- Stores the GTFS options for calendar_dates.exception_type.
CREATE TABLE IF NOT EXISTS gtfs.exception_types (id SMALLINT PRIMARY KEY, name TEXT NOT NULL);
INSERT INTO gtfs.exception_types (id, name)
VALUES (1, 'Service has been added'),
	(2, 'Service has been removed') ON CONFLICT (id) DO NOTHING;
-- Stores the GTFS options for stop_times.timepoint.
CREATE TABLE IF NOT EXISTS gtfs.timepoints (id SMALLINT PRIMARY KEY, name TEXT NOT NULL);
INSERT INTO gtfs.timepoints (id, name)
VALUES (0, 'Times are considered approximate'),
	(1, 'Times are considered exact') ON CONFLICT (id) DO NOTHING;
-- =================================================================
-- 3. CORE GTFS DATA TABLES
-- =================================================================
-- Corresponds to agency.txt and defines the transit operator.
CREATE TABLE IF NOT EXISTS gtfs.agency (
	agency_id UUID PRIMARY KEY,
	agency_name TEXT NOT NULL,
	agency_url gtfs.url NOT NULL,
	agency_timezone TEXT NOT NULL CHECK (gtfs.is_valid_timezone(agency_timezone)),
	agency_lang gtfs.language_code,
	agency_phone TEXT,
	agency_fare_url gtfs.url,
	agency_email gtfs.email
);
-- Corresponds to stops.txt and lists all physical stop locations.
CREATE TABLE IF NOT EXISTS gtfs.stops (
	stop_id UUID PRIMARY KEY,
	stop_code TEXT,
	stop_name TEXT NOT NULL,
	tts_stop_name TEXT,
	stop_desc TEXT,
	stop_lat gtfs.latitude,
	stop_lon gtfs.longitude,
	zone_id UUID,
	stop_url gtfs.url,
	location_type SMALLINT DEFAULT 0 REFERENCES gtfs.stop_location_types (id),
	parent_station UUID REFERENCES gtfs.stops (stop_id),
	stop_timezone TEXT CHECK (gtfs.is_valid_timezone(stop_timezone)),
	wheelchair_boarding SMALLINT DEFAULT 0 REFERENCES gtfs.wheelchair_boarding_types (id),
	level_id UUID,
	platform_code TEXT
);
-- Corresponds to routes.txt and defines a single transit route or line.
CREATE TABLE IF NOT EXISTS gtfs.routes (
	route_id UUID PRIMARY KEY,
	agency_id UUID NOT NULL REFERENCES gtfs.agency (agency_id),
	route_short_name TEXT,
	route_long_name TEXT NOT NULL,
	route_desc TEXT,
	route_type SMALLINT NOT NULL REFERENCES gtfs.route_types (id),
	route_url gtfs.url,
	route_color TEXT CHECK (
		route_color IS NULL
		OR route_color ~ '^[0-9A-Fa-f]{6}$'
	),
	route_text_color TEXT CHECK (
		route_text_color IS NULL
		OR route_text_color ~ '^[0-9A-Fa-f]{6}$'
	),
	route_sort_order gtfs.non_negative_int,
	continuous_pickup SMALLINT REFERENCES gtfs.continuous_pickup_drop_off_types (id),
	continuous_drop_off SMALLINT REFERENCES gtfs.continuous_pickup_drop_off_types (id),
	network_id UUID
);
-- Corresponds to calendar.txt and defines regular, week-based service patterns.
CREATE TABLE IF NOT EXISTS gtfs.calendar (
	service_id UUID PRIMARY KEY,
	monday SMALLINT NOT NULL REFERENCES gtfs.service_availability (id),
	tuesday SMALLINT NOT NULL REFERENCES gtfs.service_availability (id),
	wednesday SMALLINT NOT NULL REFERENCES gtfs.service_availability (id),
	thursday SMALLINT NOT NULL REFERENCES gtfs.service_availability (id),
	friday SMALLINT NOT NULL REFERENCES gtfs.service_availability (id),
	saturday SMALLINT NOT NULL REFERENCES gtfs.service_availability (id),
	sunday SMALLINT NOT NULL REFERENCES gtfs.service_availability (id),
	start_date DATE NOT NULL,
	end_date DATE NOT NULL
);
-- Corresponds to calendar_dates.txt and defines exceptions to the regular service schedule.
CREATE TABLE IF NOT EXISTS gtfs.calendar_dates (
	service_id UUID NOT NULL REFERENCES gtfs.calendar (service_id) ON DELETE CASCADE,
	date DATE NOT NULL,
	exception_type SMALLINT NOT NULL REFERENCES gtfs.exception_types (id),
	PRIMARY KEY (service_id, date)
);
-- Corresponds to shapes.txt and defines the physical path a vehicle follows on a map.
CREATE TABLE IF NOT EXISTS gtfs.shapes (
	shape_id TEXT NOT NULL,
	shape_pt_lat gtfs.latitude NOT NULL,
	shape_pt_lon gtfs.longitude NOT NULL,
	shape_pt_sequence gtfs.non_negative_int NOT NULL,
	shape_dist_traveled gtfs.non_negative_real,
	PRIMARY KEY (shape_id, shape_pt_sequence)
);
-- Corresponds to trips.txt and defines a single journey along a route.
CREATE TABLE IF NOT EXISTS gtfs.trips (
	trip_id UUID PRIMARY KEY,
	route_id UUID NOT NULL REFERENCES gtfs.routes (route_id),
	service_id UUID NOT NULL REFERENCES gtfs.calendar (service_id),
	trip_headsign TEXT,
	trip_short_name TEXT,
	direction_id SMALLINT REFERENCES gtfs.directions (id),
	block_id TEXT,
	shape_id TEXT,
	wheelchair_accessible SMALLINT REFERENCES gtfs.accommodation_types (id),
	bikes_allowed SMALLINT REFERENCES gtfs.accommodation_types (id),
	cars_allowed SMALLINT REFERENCES gtfs.accommodation_types (id)
);
-- Corresponds to stop_times.txt and lists the arrival/departure times for each stop on a trip.
CREATE TABLE IF NOT EXISTS gtfs.stop_times (
	trip_id UUID NOT NULL REFERENCES gtfs.trips (trip_id) ON DELETE CASCADE,
	arrival_time TEXT,
	departure_time TEXT,
	stop_id UUID NOT NULL REFERENCES gtfs.stops(stop_id),
	location_group_id UUID,
	location_id UUID,
	stop_sequence gtfs.non_negative_int NOT NULL,
	stop_headsign TEXT,
	start_pickup_drop_off_window TEXT,
	end_pickup_drop_off_window TEXT,
	pickup_type SMALLINT DEFAULT 0 REFERENCES gtfs.pickup_drop_off_types (id),
	drop_off_type SMALLINT DEFAULT 0 REFERENCES gtfs.pickup_drop_off_types (id),
	continuous_pickup SMALLINT DEFAULT 1 REFERENCES gtfs.continuous_pickup_drop_off_types (id),
	continuous_drop_off SMALLINT DEFAULT 1 REFERENCES gtfs.continuous_pickup_drop_off_types (id),
	shape_dist_traveled gtfs.non_negative_real,
	timepoint SMALLINT DEFAULT 0 REFERENCES gtfs.timepoints (id),
	pickup_booking_rule_id UUID,
	drop_off_booking_rule_id UUID,
	PRIMARY KEY (trip_id, stop_sequence),
	-- Check constraint to validate the HH:MM:SS format and allow hours > 23
	CONSTRAINT time_format_check CHECK (
		(
			arrival_time IS NULL
			OR arrival_time ~ '^[0-9]+:[0-5][0-9]:[0-5][0-9]$'
		)
		AND (
			departure_time IS NULL
			OR departure_time ~ '^[0-9]+:[0-5][0-9]:[0-5][0-9]$'
		)
		AND (
			start_pickup_drop_off_window IS NULL
			OR start_pickup_drop_off_window ~ '^[0-9]+:[0-5][0-9]:[0-5][0-9]$'
		)
		AND (
			end_pickup_drop_off_window IS NULL
			OR end_pickup_drop_off_window ~ '^[0-9]+:[0-5][0-9]:[0-5][0-9]$'
		)
	)
);
-- Corresponds to feed_info.txt and contains metadata about the GTFS feed itself.
CREATE TABLE IF NOT EXISTS gtfs.feed_info (
	feed_publisher_name TEXT NOT NULL,
	feed_publisher_url gtfs.url NOT NULL,
	feed_lang gtfs.language_code NOT NULL,
	default_lang gtfs.language_code,
	feed_start_date DATE,
	feed_end_date DATE,
	feed_version TEXT NOT NULL,
	feed_contact_email gtfs.email NOT NULL,
	feed_contact_url gtfs.url
);
-- Corresponds to fare_attributes.txt and defines a fare class and its cost.
CREATE TABLE IF NOT EXISTS gtfs.fare_attributes (
	fare_id UUID PRIMARY KEY,
	price gtfs.non_negative_real NOT NULL,
	currency_type CHAR(3) NOT NULL REFERENCES gtfs.currencies(code),
	payment_method SMALLINT NOT NULL REFERENCES gtfs.payment_methods (id),
	transfers gtfs.non_negative_int,
	agency_id UUID NOT NULL REFERENCES gtfs.agency(agency_id),
	transfer_duration gtfs.non_negative_int
);
-- Corresponds to fare_rules.txt and links a fare to a specific route or origin/destination pair.
CREATE TABLE IF NOT EXISTS gtfs.fare_rules (
	fare_id UUID NOT NULL REFERENCES gtfs.fare_attributes (fare_id) ON DELETE CASCADE,
	route_id UUID REFERENCES gtfs.routes (route_id),
	origin_id UUID,
	destination_id UUID,
	contains_id UUID,
	-- Ensures that no two fare rules are identical, acting as a natural key.
	UNIQUE (
		fare_id,
		route_id,
		origin_id,
		destination_id,
		contains_id
	)
);