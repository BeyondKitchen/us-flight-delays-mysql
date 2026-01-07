/*
  Step 01: Load CSV files into raw tables (Apr 2020 / Apr 2021)

  - This script assumes raw tables already exist (see 00_create_raw_tables.sql).
  - Replace the file paths below with your local CSV paths.
  - CSV files are NOT committed to GitHub.
*/

USE flight_delay;

-- IMPORTANT: Replace these paths with your local file paths
SET @csv_2020 = 'C:/PATH/TO/flight_ontime_2020_04.csv';
SET @csv_2021 = 'C:/PATH/TO/flight_ontime_2021_04.csv';

-- If you re-run, clear existing rows first (optional but recommended)
TRUNCATE TABLE flight_delay.flight_ontime_raw_2020_04;
TRUNCATE TABLE flight_delay.flight_ontime_raw_2021_04;

-- Load Apr 2020
LOAD DATA LOCAL INFILE @csv_2020
INTO TABLE flight_delay.flight_ontime_raw_2020_04
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Load Apr 2021
LOAD DATA LOCAL INFILE @csv_2021
INTO TABLE flight_delay.flight_ontime_raw_2021_04
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Quick row count checks
SELECT 'raw_2020_04' AS table_name, COUNT(*) AS row_cnt
FROM flight_delay.flight_ontime_raw_2020_04
UNION ALL
SELECT 'raw_2021_04' AS table_name, COUNT(*) AS row_cnt
FROM flight_delay.flight_ontime_raw_2021_04;
