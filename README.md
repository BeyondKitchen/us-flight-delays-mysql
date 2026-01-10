# ✈️ US Flight Recovery & Operational Performance Analysis  
**(Apr 2021 vs Apr 2020)**

## 📌 Project Overview
This project analyzes **U.S. flight volume recovery and operational performance** by comparing **April 2021 vs April 2020**, a critical period representing early post-pandemic recovery.

The analysis focuses on how flight volume rebounded year-over-year and how operational quality (cancellations and on-time performance) changed during the recovery phase.  
The project demonstrates an end-to-end workflow using **SQL for analysis** and **Tableau for visualization**, with an emphasis on business-oriented insights rather than raw metrics.

---

## 🎯 Business Objectives
- Quantify overall flight volume recovery after the COVID-19 downturn
- Identify airlines that recovered fastest in terms of flight volume
- Measure year-over-year improvement or deterioration in:
  - Cancellation rates
  - On-time performance
- Highlight problematic routes that experienced significant operational degradation

---

## 🧠 Key Business Questions
- How much did total flight volume recover in April 2021 compared to April 2020?
- Which airlines led the recovery, and which lagged behind?
- Did operational reliability improve as flight volume increased?
- Which routes suffered the worst on-time performance decline?

---

## 🛠️ Tools & Technologies
- **MySQL**
  - Data filtering and cleaning
  - KPI calculations
  - Carrier and route-level aggregation
- **Tableau Public**
  - KPI dashboards
  - Comparative visual analysis
  - Executive-style summary views
- **GitHub**
  - Version control
  - Project documentation

---

## 🗂️ Dataset
- Source: U.S. flight delay & cancellation dataset
- Timeframe: **April 2020 vs April 2021**
- Granularity:
  - Airline (Carrier)
  - Route (Origin → Destination)
- Metrics include:
  - Flight counts
  - Cancellation rates
  - On-time performance rates

---

## 📊 Key KPIs
- **Total Flights (2021)**
- **Volume Recovery Rate (%)**
- **YoY Cancellation Rate Delta (percentage points)**
- **YoY On-Time Performance Delta (percentage points)**

> *Note: “pp” refers to percentage points.*

---

## 🔍 Analysis Workflow

### 1️⃣ Data Preparation (SQL)
- Filtered flight data to April 2020 and April 2021
- Standardized carrier identifiers
- Joined carrier dimension tables
- Removed incomplete and irrelevant records

### 2️⃣ KPI Calculation (SQL)
- Calculated total flights by year
- Computed volume recovery ratio (2021 vs 2020)
- Derived year-over-year deltas for:
  - Cancellation rates
  - On-time performance

### 3️⃣ Aggregation Levels
- Overall (system-wide)
- Carrier level
- Route level

### 4️⃣ Visualization (Tableau)
- KPI summary cards for high-level insights
- Bar charts for:
  - Top 10 carriers by volume recovery
  - Top 10 carriers by cancellation improvement
  - Worst 10 routes by on-time performance decline

---

## 📈 Tableau Dashboard
**Interactive Dashboard (Tableau Public):**  
👉 https://public.tableau.com/views/USFlightRecoveryAnalysis2021vs2020/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link

The dashboard enables users to:
- Quickly assess recovery magnitude
- Compare airline-level operational performance
- Identify operational risks at the route level

---

## 💡 Key Insights
- Total flight volume in April 2021 exceeded April 2020 levels by **43.8%**, indicating strong recovery momentum.
- Several carriers showed exceptionally high volume recovery ratios, driven by aggressive capacity restoration.
- Cancellation rates improved year-over-year, suggesting better schedule stability.
- Despite recovery, **on-time performance declined**, indicating operational strain during rapid capacity expansion.
- Certain high-traffic routes experienced the most severe on-time performance deterioration.

---

### 📂 Repository Structure

```text
us-flight-delays-mysql/
├── sql/
│   ├── 00_create_raw_tables.sql
│   ├── 01_load_raw_template.sql
│   ├── 02_create_clean_tables.sql
│   ├── 03_create_dim_carrier.sql
│   └── 04_analysis_queries.sql
└── README.md
```
---

## 🚀 Potential Enhancements
- Extend analysis across multiple months for trend analysis
- Incorporate delay duration metrics
- Normalize results for seasonality
- Add interactive filters in Tableau (carrier, route, metric)

---

## 👤 Author
**Beom Kwon Cho**  
Aspiring Data Analyst  
Skills: SQL, Tableau, Data Analysis, Data Visualization  

This project is part of a growing portfolio focused on real-world operational and business data analysis.
