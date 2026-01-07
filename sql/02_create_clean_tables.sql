/* ============================================================
   Project: US Flight Delays (MySQL)
   Step 01: Create cleaned tables for Apr 2020 and Apr 2021
   ============================================================ */

-- ------------------------------------------------------------
-- Clean table: 2020-04
-- ------------------------------------------------------------
DROP TABLE IF EXISTS flight_delay.flight_ontime_clean_2020_04;

CREATE TABLE flight_delay.flight_ontime_clean_2020_04 AS
SELECT
  CAST(NULLIF(TRIM(YEAR),  '') AS UNSIGNED) AS year,
  CAST(NULLIF(TRIM(MONTH), '') AS UNSIGNED) AS month,

  STR_TO_DATE(
    NULLIF(SUBSTRING_INDEX(TRIM(FL_DATE), ' ', 1), ''),
    '%c/%e/%Y'
  ) AS fl_date,

  TRIM(OP_UNIQUE_CARRIER) AS op_unique_carrier,

  CASE
    WHEN TRIM(OP_CARRIER_AIRLINE_ID) REGEXP '^[0-9]+$'
      THEN CAST(TRIM(OP_CARRIER_AIRLINE_ID) AS UNSIGNED)
    ELSE NULL
  END AS op_carrier_airline_id,

  TRIM(ORIGIN) AS origin,
  TRIM(ORIGIN_CITY_NAME) AS origin_city_name,
  TRIM(ORIGIN_STATE_NM) AS origin_state_nm,

  TRIM(DEST) AS dest,
  TRIM(DEST_CITY_NAME) AS dest_city_name,
  TRIM(DEST_STATE_NM) AS dest_state_nm,

  CAST(NULLIF(TRIM(DEP_DELAY), '') AS DECIMAL(10,2)) AS dep_delay,

  CASE
    WHEN TRIM(DEP_DEL15) REGEXP '^[0-9]+(\\.[0-9]+)?$'
      THEN CAST(ROUND(CAST(TRIM(DEP_DEL15) AS DECIMAL(10,2))) AS UNSIGNED)
    ELSE NULL
  END AS dep_del15,

  CAST(NULLIF(TRIM(ARR_DELAY), '') AS DECIMAL(10,2)) AS arr_delay,

  CASE
    WHEN TRIM(ARR_DEL15) REGEXP '^[0-9]+(\\.[0-9]+)?$'
      THEN CAST(ROUND(CAST(TRIM(ARR_DEL15) AS DECIMAL(10,2))) AS UNSIGNED)
    ELSE NULL
  END AS arr_del15,

  CASE
    WHEN TRIM(CANCELLED) REGEXP '^[0-9]+(\\.[0-9]+)?$'
      THEN CAST(ROUND(CAST(TRIM(CANCELLED) AS DECIMAL(10,2))) AS UNSIGNED)
    ELSE NULL
  END AS cancelled

FROM flight_delay.flight_ontime_raw_2020_04;

-- ------------------------------------------------------------
-- Clean table: 2021-04
-- ------------------------------------------------------------
DROP TABLE IF EXISTS flight_delay.flight_ontime_clean_2021_04;

CREATE TABLE flight_delay.flight_ontime_clean_2021_04 AS
SELECT
  CAST(NULLIF(TRIM(YEAR),  '') AS UNSIGNED) AS year,
  CAST(NULLIF(TRIM(MONTH), '') AS UNSIGNED) AS month,

  STR_TO_DATE(
    NULLIF(SUBSTRING_INDEX(TRIM(FL_DATE), ' ', 1), ''),
    '%c/%e/%Y'
  ) AS fl_date,

  TRIM(OP_UNIQUE_CARRIER) AS op_unique_carrier,

  CASE
    WHEN TRIM(OP_CARRIER_AIRLINE_ID) REGEXP '^[0-9]+$'
      THEN CAST(TRIM(OP_CARRIER_AIRLINE_ID) AS UNSIGNED)
    ELSE NULL
  END AS op_carrier_airline_id,

  TRIM(ORIGIN) AS origin,
  TRIM(ORIGIN_CITY_NAME) AS origin_city_name,
  TRIM(ORIGIN_STATE_NM) AS origin_state_nm,

  TRIM(DEST) AS dest,
  TRIM(DEST_CITY_NAME) AS dest_city_name,
  TRIM(DEST_STATE_NM) AS dest_state_nm,

  CAST(NULLIF(TRIM(DEP_DELAY), '') AS DECIMAL(10,2)) AS dep_delay,

  CASE
    WHEN TRIM(DEP_DEL15) REGEXP '^[0-9]+(\\.[0-9]+)?$'
      THEN CAST(ROUND(CAST(TRIM(DEP_DEL15) AS DECIMAL(10,2))) AS UNSIGNED)
    ELSE NULL
  END AS dep_del15,

  CAST(NULLIF(TRIM(ARR_DELAY), '') AS DECIMAL(10,2)) AS arr_delay,

  CASE
    WHEN TRIM(ARR_DEL15) REGEXP '^[0-9]+(\\.[0-9]+)?$'
      THEN CAST(ROUND(CAST(TRIM(ARR_DEL15) AS DECIMAL(10,2))) AS UNSIGNED)
    ELSE NULL
  END AS arr_del15,

  CASE
    WHEN TRIM(CANCELLED) REGEXP '^[0-9]+(\\.[0-9]+)?$'
      THEN CAST(ROUND(CAST(TRIM(CANCELLED) AS DECIMAL(10,2))) AS UNSIGNED)
    ELSE NULL
  END AS cancelled

FROM flight_delay.flight_ontime_raw_2021_04;
