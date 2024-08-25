# Cricket Analytics using Snowflake
-------------------------------------------------------------

The project begins with the collection of live cricket data and ingested into Snowflake. Raw data is ingested undergoes transformation processes. It involves cleaning, filtering, and structuring the data to make it suitable for analysis. It also includes calculations of key cricket metrics like batting averages, strike rates, etc. The structured data can be organized into different tables, schemas, or databases for easy access and management.
Snowflake's native visualization features is used to create dashboards, providing intuitive and interactive ways to explore the cricket data. A pipeline is automated to handle real-time data with minimal manual intervention.


## Project Structure:

1. Land Layer: The initial landing layer where raw data in JSON format is stored.
2. RAW Layer: The raw layer stores the ingested data without any transformation. It includes tasks to load data from JSON files into Snowflake tables.
3. Clean Layer: The clean layer is responsible for cleaning and transforming the raw data. It includes tasks to create clean tables that are more suitable for analysis.
4. Consumption Layer: The consumption layer is designed for analytics and reporting. It includes the final tables and views that are used for creating dashboards.
5. Dashboard: The dashboard layer utilizes Snowsight to visualize the analytics results. It can be accessed for insightful data analysis and reporting.
6. Automate Continuous Data Flow: Automating continuous data flow, specifically by creating automated tasks to listen to change data capture (CDC) and update data in all tables.

 

----------------------------------------------------------------
Credits: Data Engineering Simplified
