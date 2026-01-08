/*
US Flight Delays (MySQL) - Step 04: KPI Analysis Queries (YoY)
Compare Apr 2020 (COVID shock) vs Apr 2021 (1 year later)

Key idea:
- Do NOT rely only on delay rate.
- Focus on YoY comparison: volume recovery + cancellation reliability + operated-flight delay performance.
- For delay KPIs, use operated flights only (cancelled = 0).

Tables assumed:
- flight_delay.flight_ontime_clean_2020_04
- flight_delay.flight_ontime_clean_2021_04
- flight_delay.dim_carrier (op_unique_carrier -> carrier_name)
*/

USE flight_delay;

-- ============================================================
-- 0) QUICK DATA CHECK (optional)
-- ============================================================
SELECT '2020-04' AS period, COUNT(*) AS total_rows
FROM flight_delay.flight_ontime_clean_2020_04
UNION ALL
SELECT '2021-04' AS period, COUNT(*) AS total_rows
FROM flight_delay.flight_ontime_clean_2021_04;


-- ============================================================
-- 1) OVERALL KPI (YoY): volume recovery + cancellations + on-time/delay (operated only)
-- ============================================================
WITH
base_2020 AS (
    SELECT
        '2020-04' AS period,
        COUNT(*) AS flights_total,
        SUM(cancelled = 1) AS flights_cancelled,
        SUM(cancelled = 0) AS flights_operated,

        -- Operated only
        AVG(CASE WHEN cancelled = 0 THEN dep_del15 END) AS dep15_rate_operated,
        AVG(CASE WHEN cancelled = 0 THEN arr_del15 END) AS arr15_rate_operated,
        AVG(CASE WHEN cancelled = 0 THEN dep_delay END) AS avg_dep_delay_min_operated,
        AVG(CASE WHEN cancelled = 0 THEN arr_delay END) AS avg_arr_delay_min_operated,
        AVG(CASE WHEN cancelled = 0 THEN (arr_del15 = 0) END) AS ontime_rate_operated
    FROM flight_delay.flight_ontime_clean_2020_04
),
base_2021 AS (
    SELECT
        '2021-04' AS period,
        COUNT(*) AS flights_total,
        SUM(cancelled = 1) AS flights_cancelled,
        SUM(cancelled = 0) AS flights_operated,

        -- Operated only
        AVG(CASE WHEN cancelled = 0 THEN dep_del15 END) AS dep15_rate_operated,
        AVG(CASE WHEN cancelled = 0 THEN arr_del15 END) AS arr15_rate_operated,
        AVG(CASE WHEN cancelled = 0 THEN dep_delay END) AS avg_dep_delay_min_operated,
        AVG(CASE WHEN cancelled = 0 THEN arr_delay END) AS avg_arr_delay_min_operated,
        AVG(CASE WHEN cancelled = 0 THEN (arr_del15 = 0) END) AS ontime_rate_operated
    FROM flight_delay.flight_ontime_clean_2021_04
)
SELECT
    'OVERALL' AS level,

    -- volume
    b20.flights_total AS flights_total_2020,
    b21.flights_total AS flights_total_2021,
    ROUND(b21.flights_total / NULLIF(b20.flights_total, 0), 4) AS volume_recovery_ratio,

    -- cancellations
    ROUND(b20.flights_cancelled / NULLIF(b20.flights_total, 0), 4) AS cancel_rate_2020,
    ROUND(b21.flights_cancelled / NULLIF(b21.flights_total, 0), 4) AS cancel_rate_2021,
    ROUND((b21.flights_cancelled / NULLIF(b21.flights_total, 0)) - (b20.flights_cancelled / NULLIF(b20.flights_total, 0)), 4) AS cancel_rate_delta,

    -- operated base (context)
    b20.flights_operated AS flights_operated_2020,
    b21.flights_operated AS flights_operated_2021,

    -- delay / on-time (operated only)
    ROUND(b20.dep15_rate_operated, 4) AS dep15_rate_operated_2020,
    ROUND(b21.dep15_rate_operated, 4) AS dep15_rate_operated_2021,
    ROUND(b21.dep15_rate_operated - b20.dep15_rate_operated, 4) AS dep15_rate_operated_delta,

    ROUND(b20.arr15_rate_operated, 4) AS arr15_rate_operated_2020,
    ROUND(b21.arr15_rate_operated, 4) AS arr15_rate_operated_2021,
    ROUND(b21.arr15_rate_operated - b20.arr15_rate_operated, 4) AS arr15_rate_operated_delta,

    ROUND(b20.ontime_rate_operated, 4) AS ontime_rate_operated_2020,
    ROUND(b21.ontime_rate_operated, 4) AS ontime_rate_operated_2021,
    ROUND(b21.ontime_rate_operated - b20.ontime_rate_operated, 4) AS ontime_rate_operated_delta,

    ROUND(b20.avg_dep_delay_min_operated, 2) AS avg_dep_delay_min_operated_2020,
    ROUND(b21.avg_dep_delay_min_operated, 2) AS avg_dep_delay_min_operated_2021,
    ROUND(b21.avg_dep_delay_min_operated - b20.avg_dep_delay_min_operated, 2) AS avg_dep_delay_min_operated_delta,

    ROUND(b20.avg_arr_delay_min_operated, 2) AS avg_arr_delay_min_operated_2020,
    ROUND(b21.avg_arr_delay_min_operated, 2) AS avg_arr_delay_min_operated_2021,
    ROUND(b21.avg_arr_delay_min_operated - b20.avg_arr_delay_min_operated, 2) AS avg_arr_delay_min_operated_delta
FROM base_2020 b20
JOIN base_2021 b21;


-- ============================================================
-- 2) CARRIER KPI (YoY): compare airlines (join dim_carrier)
--    - Includes minimum sample filter for operated flights
-- ============================================================
WITH
c20 AS (
    SELECT
        op_unique_carrier,
        COUNT(*) AS flights_total_2020,
        SUM(cancelled = 1) AS flights_cancelled_2020,
        SUM(cancelled = 0) AS flights_operated_2020,

        AVG(CASE WHEN cancelled = 0 THEN arr_del15 END) AS arr15_rate_operated_2020,
        AVG(CASE WHEN cancelled = 0 THEN (arr_del15 = 0) END) AS ontime_rate_operated_2020,
        AVG(CASE WHEN cancelled = 0 THEN arr_delay END) AS avg_arr_delay_min_operated_2020
    FROM flight_delay.flight_ontime_clean_2020_04
    GROUP BY op_unique_carrier
),
c21 AS (
    SELECT
        op_unique_carrier,
        COUNT(*) AS flights_total_2021,
        SUM(cancelled = 1) AS flights_cancelled_2021,
        SUM(cancelled = 0) AS flights_operated_2021,

        AVG(CASE WHEN cancelled = 0 THEN arr_del15 END) AS arr15_rate_operated_2021,
        AVG(CASE WHEN cancelled = 0 THEN (arr_del15 = 0) END) AS ontime_rate_operated_2021,
        AVG(CASE WHEN cancelled = 0 THEN arr_delay END) AS avg_arr_delay_min_operated_2021
    FROM flight_delay.flight_ontime_clean_2021_04
    GROUP BY op_unique_carrier
)
SELECT
    COALESCE(c21.op_unique_carrier, c20.op_unique_carrier) AS op_unique_carrier,
    d.carrier_name,

    -- volume
    c20.flights_total_2020,
    c21.flights_total_2021,
    ROUND(c21.flights_total_2021 / NULLIF(c20.flights_total_2020, 0), 4) AS volume_recovery_ratio,

    -- cancellations
    ROUND(c20.flights_cancelled_2020 / NULLIF(c20.flights_total_2020, 0), 4) AS cancel_rate_2020,
    ROUND(c21.flights_cancelled_2021 / NULLIF(c21.flights_total_2021, 0), 4) AS cancel_rate_2021,
    ROUND(
        (c21.flights_cancelled_2021 / NULLIF(c21.flights_total_2021, 0))
        - (c20.flights_cancelled_2020 / NULLIF(c20.flights_total_2020, 0))
    , 4) AS cancel_rate_delta,

    -- operated context
    c20.flights_operated_2020,
    c21.flights_operated_2021,

    -- performance (operated only)
    ROUND(c20.arr15_rate_operated_2020, 4) AS arr15_rate_operated_2020,
    ROUND(c21.arr15_rate_operated_2021, 4) AS arr15_rate_operated_2021,
    ROUND(c21.arr15_rate_operated_2021 - c20.arr15_rate_operated_2020, 4) AS arr15_rate_operated_delta,

    ROUND(c20.ontime_rate_operated_2020, 4) AS ontime_rate_operated_2020,
    ROUND(c21.ontime_rate_operated_2021, 4) AS ontime_rate_operated_2021,
    ROUND(c21.ontime_rate_operated_2021 - c20.ontime_rate_operated_2020, 4) AS ontime_rate_operated_delta,

    ROUND(c20.avg_arr_delay_min_operated_2020, 2) AS avg_arr_delay_min_operated_2020,
    ROUND(c21.avg_arr_delay_min_operated_2021, 2) AS avg_arr_delay_min_operated_2021,
    ROUND(c21.avg_arr_delay_min_operated_2021 - c20.avg_arr_delay_min_operated_2020, 2) AS avg_arr_delay_min_operated_delta
FROM c20
JOIN c21
    ON c20.op_unique_carrier = c21.op_unique_carrier
LEFT JOIN flight_delay.dim_carrier d
    ON d.op_unique_carrier = COALESCE(c21.op_unique_carrier, c20.op_unique_carrier)
WHERE
    c20.flights_operated_2020 >= 200
    AND c21.flights_operated_2021 >= 200
ORDER BY volume_recovery_ratio DESC;


-- ============================================================
-- 3) STATE KPI (YoY): origin_state_nm recovery & on-time
-- ============================================================
WITH
s20 AS (
    SELECT
        origin_state_nm,
        COUNT(*) AS flights_total_2020,
        SUM(cancelled = 1) AS flights_cancelled_2020,
        SUM(cancelled = 0) AS flights_operated_2020,
        AVG(CASE WHEN cancelled = 0 THEN (arr_del15 = 0) END) AS ontime_rate_operated_2020
    FROM flight_delay.flight_ontime_clean_2020_04
    GROUP BY origin_state_nm
),
s21 AS (
    SELECT
        origin_state_nm,
        COUNT(*) AS flights_total_2021,
        SUM(cancelled = 1) AS flights_cancelled_2021,
        SUM(cancelled = 0) AS flights_operated_2021,
        AVG(CASE WHEN cancelled = 0 THEN (arr_del15 = 0) END) AS ontime_rate_operated_2021
    FROM flight_delay.flight_ontime_clean_2021_04
    GROUP BY origin_state_nm
)
SELECT
    COALESCE(s21.origin_state_nm, s20.origin_state_nm) AS origin_state_nm,
    s20.flights_total_2020,
    s21.flights_total_2021,
    ROUND(s21.flights_total_2021 / NULLIF(s20.flights_total_2020, 0), 4) AS volume_recovery_ratio,

    ROUND(s20.flights_cancelled_2020 / NULLIF(s20.flights_total_2020, 0), 4) AS cancel_rate_2020,
    ROUND(s21.flights_cancelled_2021 / NULLIF(s21.flights_total_2021, 0), 4) AS cancel_rate_2021,
    ROUND(
        (s21.flights_cancelled_2021 / NULLIF(s21.flights_total_2021, 0))
        - (s20.flights_cancelled_2020 / NULLIF(s20.flights_total_2020, 0))
    , 4) AS cancel_rate_delta,

    ROUND(s20.ontime_rate_operated_2020, 4) AS ontime_rate_operated_2020,
    ROUND(s21.ontime_rate_operated_2021, 4) AS ontime_rate_operated_2021,
    ROUND(s21.ontime_rate_operated_2021 - s20.ontime_rate_operated_2020, 4) AS ontime_rate_operated_delta
FROM s20
JOIN s21
    ON s20.origin_state_nm = s21.origin_state_nm
WHERE
    s20.flights_operated_2020 >= 200
    AND s21.flights_operated_2021 >= 200
ORDER BY volume_recovery_ratio DESC;


-- ============================================================
-- 4) TOP ROUTES (YoY): origin -> dest (filter by minimum operated flights)
-- ============================================================
WITH
r20 AS (
    SELECT
        origin,
        dest,
        COUNT(*) AS flights_total_2020,
        SUM(cancelled = 1) AS flights_cancelled_2020,
        SUM(cancelled = 0) AS flights_operated_2020,
        AVG(CASE WHEN cancelled = 0 THEN (arr_del15 = 0) END) AS ontime_rate_operated_2020
    FROM flight_delay.flight_ontime_clean_2020_04
    GROUP BY origin, dest
),
r21 AS (
    SELECT
        origin,
        dest,
        COUNT(*) AS flights_total_2021,
        SUM(cancelled = 1) AS flights_cancelled_2021,
        SUM(cancelled = 0) AS flights_operated_2021,
        AVG(CASE WHEN cancelled = 0 THEN (arr_del15 = 0) END) AS ontime_rate_operated_2021
    FROM flight_delay.flight_ontime_clean_2021_04
    GROUP BY origin, dest
)
SELECT
    CONCAT(r20.origin, '-', r20.dest) AS route,
    r20.flights_total_2020,
    r21.flights_total_2021,
    ROUND(r21.flights_total_2021 / NULLIF(r20.flights_total_2020, 0), 4) AS volume_recovery_ratio,

    ROUND(r20.flights_cancelled_2020 / NULLIF(r20.flights_total_2020, 0), 4) AS cancel_rate_2020,
    ROUND(r21.flights_cancelled_2021 / NULLIF(r21.flights_total_2021, 0), 4) AS cancel_rate_2021,
    ROUND(
        (r21.flights_cancelled_2021 / NULLIF(r21.flights_total_2021, 0))
        - (r20.flights_cancelled_2020 / NULLIF(r20.flights_total_2020, 0))
    , 4) AS cancel_rate_delta,

    ROUND(r20.ontime_rate_operated_2020, 4) AS ontime_rate_operated_2020,
    ROUND(r21.ontime_rate_operated_2021, 4) AS ontime_rate_operated_2021,
    ROUND(r21.ontime_rate_operated_2021 - r20.ontime_rate_operated_2020, 4) AS ontime_rate_operated_delta
FROM r20
JOIN r21
    ON r20.origin = r21.origin AND r20.dest = r21.dest
WHERE
    r20.flights_operated_2020 >= 150
    AND r21.flights_operated_2021 >= 150
ORDER BY volume_recovery_ratio DESC
LIMIT 50;
