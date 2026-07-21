Order Data Pipeline Project

Overview
This project demonstrates an end-to-end **batch order data pipeline** that processes daily incremental order data from CSV files and transforms raw transactional data into analytics-ready datasets.

The pipeline follows a ELT architecture with multiple data layers:

**Raw → Staging → Warehouse → Data Mart**

Every day, new incremental CSV files are generated from source systems. The pipeline loads only new and changed records, performs data cleansing and transformation, and produces business-ready tables for reporting and analytics.

Technology Stack
| Component            | Technology     |
| -------------------- | -------------- |
| Cloud Data Warehouse | Snowflake      |
| Transformation       | dbt            |
| Programming Language | SQL            |
| Orchestration        | Airflow        |
| Data Processing      | Python         |
| Version Control      | GitHub         |
| Data Quality         | dbt Tests      |
| Data Modelling       | Star Schema    |
