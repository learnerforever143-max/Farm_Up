# FARM UP Database Schema Design

## Overview
This document outlines the database schema for the FARM UP application, which stores farmer data, soil analysis results, crop recommendations, financial information, and more.

## Database Technology
For mobile applications, we'll use SQLite with Flutter's built-in support through the `sqflite` package. For cloud synchronization, we can use Firebase Firestore or a custom REST API with a backend database like PostgreSQL.

## Core Tables

### 1. Users
Stores farmer profile information.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| user_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier for each user |
| full_name | TEXT | NOT NULL | Farmer's full name |
| phone_number | TEXT | UNIQUE, NOT NULL | Phone number for authentication |
| email | TEXT | UNIQUE | Email address (optional) |
| language_preference | TEXT | NOT NULL DEFAULT 'en' | Preferred language code |
| registration_date | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Account creation date |
| last_login | DATETIME |  | Last login timestamp |

### 2. Farms
Represents individual farms managed by users.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| farm_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier for each farm |
| user_id | INTEGER | NOT NULL, FOREIGN KEY (users.user_id) | Owner of the farm |
| farm_name | TEXT | NOT NULL | Name of the farm |
| location | TEXT |  | GPS coordinates or address |
| area_hectares | REAL |  | Total area in hectares |
| soil_type | TEXT |  | Classification of soil type |
| irrigation_type | TEXT |  | Type of irrigation system |
| created_date | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Farm registration date |

### 3. SoilAnalysis
Stores soil test results for farms.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| analysis_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| farm_id | INTEGER | NOT NULL, FOREIGN KEY (farms.farm_id) | Associated farm |
| analysis_date | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Date of analysis |
| ph_level | REAL |  | pH level of soil |
| nitrogen_ppm | REAL |  | Nitrogen content in ppm |
| phosphorus_ppm | REAL |  | Phosphorus content in ppm |
| potassium_ppm | REAL |  | Potassium content in ppm |
| moisture_percent | REAL |  | Moisture percentage |
| organic_matter_percent | REAL |  | Organic matter percentage |
| notes | TEXT |  | Additional observations |

### 4. CropRecommendations
Stores AI-generated crop recommendations.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| recommendation_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| analysis_id | INTEGER | NOT NULL, FOREIGN KEY (soilanalysis.analysis_id) | Source soil analysis |
| crop_name | TEXT | NOT NULL | Recommended crop |
| confidence_score | REAL |  | AI confidence level (0-1) |
| expected_yield_tons_per_ha | REAL |  | Expected yield per hectare |
| season | TEXT |  | Recommended planting season |
| profitability_index | REAL |  | Profitability score (0-10) |
| recommendation_date | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Date of recommendation |

### 5. BudgetItems
Tracks financial expenses and investments.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| budget_item_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| user_id | INTEGER | NOT NULL, FOREIGN KEY (users.user_id) | Associated user |
| farm_id | INTEGER | FOREIGN KEY (farms.farm_id) | Associated farm (optional) |
| item_name | TEXT | NOT NULL | Name of expense/item |
| category | TEXT | NOT NULL | Expense category (seeds, fertilizer, etc.) |
| amount | REAL | NOT NULL | Cost amount |
| currency | TEXT | NOT NULL DEFAULT 'USD' | Currency code |
| transaction_date | DATETIME | NOT NULL | Date of transaction |
| notes | TEXT |  | Additional information |

### 6. WeatherData
Stores weather forecasts and historical data.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| weather_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| farm_id | INTEGER | NOT NULL, FOREIGN KEY (farms.farm_id) | Associated farm |
| forecast_date | DATE | NOT NULL | Date of forecast |
| temperature_celsius | REAL |  | Temperature in Celsius |
| humidity_percent | REAL |  | Humidity percentage |
| rainfall_mm | REAL |  | Expected rainfall in mm |
| wind_speed_kmh | REAL |  | Wind speed in km/h |
| weather_condition | TEXT |  | Text description (sunny, rainy, etc.) |

### 7. WaterManagement
Tracks irrigation schedules and water usage.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| water_record_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| farm_id | INTEGER | NOT NULL, FOREIGN KEY (farms.farm_id) | Associated farm |
| irrigation_date | DATETIME | NOT NULL | Date of irrigation |
| water_amount_liters | REAL |  | Amount of water used |
| irrigation_method | TEXT |  | Method (drip, sprinkler, etc.) |
| duration_minutes | INTEGER |  | Duration of irrigation |
| notes | TEXT |  | Additional observations |

### 8. DiseaseDetection
Stores plant disease identification results.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| detection_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| farm_id | INTEGER | NOT NULL, FOREIGN KEY (farms.farm_id) | Associated farm |
| detection_date | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Date of detection |
| photo_path | TEXT |  | Path to uploaded image |
| detected_disease | TEXT |  | Identified disease name |
| confidence_score | REAL |  | AI confidence level |
| suggested_treatment | TEXT |  | Recommended treatment |
| treatment_applied | BOOLEAN | DEFAULT FALSE | Whether treatment was applied |

### 9. MarketPrices
Tracks crop market prices across regions.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| price_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| crop_name | TEXT | NOT NULL | Name of crop |
| region | TEXT | NOT NULL | Geographic region |
| price_per_unit | REAL | NOT NULL | Price per unit |
| currency | TEXT | NOT NULL DEFAULT 'USD' | Currency code |
| unit | TEXT | NOT NULL DEFAULT 'kg' | Unit of measurement |
| recorded_date | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Date of recording |
| market_source | TEXT |  | Source of price information |

### 10. Videos
Catalog of educational farming videos.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| video_id | INTEGER | PRIMARY KEY AUTOINCREMENT | Unique identifier |
| title | TEXT | NOT NULL | Video title |
| description | TEXT |  | Detailed description |
| category | TEXT |  | Topic category |
| duration_seconds | INTEGER |  | Video length |
| url | TEXT | NOT NULL | Link to video content |
| thumbnail_url | TEXT |  | Link to thumbnail image |
| upload_date | DATETIME | NOT NULL DEFAULT CURRENT_TIMESTAMP | Date uploaded |

## Relationship Diagram

```
Users 1 ---< Farms 1 ---< SoilAnalysis 1 ---< CropRecommendations
Users 1 ---< BudgetItems
Farms 1 ---< WeatherData
Farms 1 ---< WaterManagement
Farms 1 ---< DiseaseDetection
MarketPrices
Videos
```

## Indexes for Performance

1. INDEX idx_users_phone ON Users(phone_number)
2. INDEX idx_farms_user ON Farms(user_id)
3. INDEX idx_soil_analysis_farm ON SoilAnalysis(farm_id)
4. INDEX idx_budget_items_user ON BudgetItems(user_id)
5. INDEX idx_weather_farm_date ON WeatherData(farm_id, forecast_date)
6. INDEX idx_market_prices_crop_region ON MarketPrices(crop_name, region)

## Notes

- All tables include timestamps for audit trails
- Foreign keys enforce referential integrity
- Nullable columns allow for partial data entry
- Text fields are used for flexibility in data entry
- Real number types accommodate decimal precision for measurements