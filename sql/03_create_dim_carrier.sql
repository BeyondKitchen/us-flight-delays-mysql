/*
  Step 03: Create dimension table for carriers (op_unique_carrier -> carrier_name)
*/

CREATE DATABASE IF NOT EXISTS flight_delay;
USE flight_delay;

DROP TABLE IF EXISTS flight_delay.dim_carrier;

CREATE TABLE flight_delay.dim_carrier (
  op_unique_carrier VARCHAR(10) PRIMARY KEY,
  carrier_name VARCHAR(100) NOT NULL
);

INSERT INTO flight_delay.dim_carrier (op_unique_carrier, carrier_name) VALUES
('9E', 'Endeavor Air'),
('AA', 'American Airlines'),
('AS', 'Alaska Airlines'),
('B6', 'JetBlue Airways'),
('DL', 'Delta Air Lines'),
('EV', 'ExpressJet Airlines'),
('F9', 'Frontier Airlines'),
('G4', 'Allegiant Air'),
('HA', 'Hawaiian Airlines'),
('MQ', 'Envoy Air'),
('NK', 'Spirit Airlines'),
('OH', 'PSA Airlines'),
('OO', 'SkyWest Airlines'),
('UA', 'United Airlines'),
('WN', 'Southwest Airlines'),
('YV', 'Mesa Airlines'),
('YX', 'Republic Airways');

-- Validation: check if any carrier codes in clean tables are missing in dim table
SELECT
  COUNT(*) AS total_rows,
  SUM(d.op_unique_carrier IS NULL) AS unmatched_rows
FROM flight_delay.flight_ontime_clean_2020_04 f
LEFT JOIN flight_delay.dim_carrier d
  ON TRIM(f.op_unique_carrier) = d.op_unique_carrier;
