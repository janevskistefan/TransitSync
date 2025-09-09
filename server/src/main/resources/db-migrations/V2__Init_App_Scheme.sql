CREATE SCHEMA IF NOT EXISTS app;

CREATE TABLE
    IF NOT EXISTS app.gtfs_service_id_names (
        service_id UUID NOT NULL REFERENCES gtfs.calendar (service_id),
        name TEXT NOT NULL
    );