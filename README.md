# SQL Data Warehouse Project  
**Jovan Bogoeski – Modern Data Engineering & Analytics Portfolio**

This project implements a complete data warehouse solution using SQL, structured around a modern layered architecture (**Bronze–Silver–Gold**) to support data integration, cleansing, and business-ready reporting.

---

## 🏗️ Data Architecture

The project follows a **Medallion Architecture** design:

> **Bronze → Silver → Gold** layers for progressively refining raw data:

- **Bronze Layer**: Ingests raw source data directly from CSVs or APIs  
- **Silver Layer**: Applies cleansing, standardization, normalization, and resolves quality issues  
- **Gold Layer**: Hosts curated, business-ready fact and dimension tables modeled in a star schema for analytics

---

## 📌 Project Overview

This project includes:

- 🧩 **Data Modeling**: Designing tables following star schema patterns  
- 🔁 **ETL Pipelines**: SQL-based processes to populate Bronze, Silver, and Gold layers  
- 📊 **Analytics**: SQL reports built on the Gold schema to extract business insights  
- 📄 **Documentation**: Architecture diagrams, data catalogs, and project notes

---

## 🗂️ Project Structure

```text
sql-data-warehouse-project/
├── 01_init/
│   └── create_database_and_schemas.sql
├── 02_bronze/
│   ├── 01_create_bronze_tables.sql
│   └── 02_load_bronze_procedure.sql
├── 03_silver/
│   ├── 00_create_silver_tables.sql
│   ├── 01_transform_crm_cust_info.sql
│   ├── 02_transform_crm_prd_info.sql
│   ├── 03_transform_crm_sales_details.sql
│   ├── 04_transform_erp_cust_az12.sql
│   ├── 05_transform_erp_px_cat_g1v2.sql
│   └── 06_transform_erp_loc_a101.sql
├── 04_gold/
│   └── 01_create_gold_views.sql
├── 05_audit/
│   ├── create_audit_tables.sql
│   └── seed_audit_config.sql
├── 06_quality_checks/
│   ├── 01_quality_checks_silver.sql
│   └── 02_quality_checks_gold.sql
├── datasets/
│   ├── source_crm/
│   └── source_erp/
├── docs/
│   ├── data_architecture.png
│   ├── data_flow.png
│   ├── data_integration.png
│   └── data_model.png
├── LICENSE
└── README.md

🔗 Tools & Technologies
All tools used in this project are freely available:

Datasets: Raw CSVs or source extract files

SQL Server Express / PostgreSQL: Data warehouse host

SQL IDE: SSMS, Azure Data Studio, or equivalent

Draw.io (diagrams.net): For architecture and ER diagrams

Git / GitHub: Version control and documentation

🧱 A. Data Engineering – Warehouse Build
Objective: Design and deploy a modern data warehouse using SQL to consolidate ERP and CRM data, enabling analytics-ready datasets.

Source Data: Two systems’ outputs (CRM & ERP), loaded as CSV or JSON

Data Quality: Trim, deduplicate, handle missing values, and normalize in Silver

Integration: Use consistent PK/FK keys to integrate sources into fact and dimension models in Gold

Documentation: Provide clear README, diagrams, and metadata files for stakeholders

📊 B. BI & Reporting – Analytics Layer
Objective: Build insightful SQL-based analytics such as:

Total and breakdown of sales trends over time

Customer behavior analysis

Product performance and maintenance reports

📖 Workflow Overview
Design tables via naming conventions and schema definitions

Extract and load raw data into the Bronze layer

Clean and enrich data in the Silver layer

Build views or tables in Gold using joins on surrogate keys

Validate results with data quality rules and test scripts

Document architecture and source-to-target mappings
