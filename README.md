# Bike Rental Prediction

## Project Overview

In this project, we explore and analyze a dataset from a bike-sharing system to predict the daily rental count of bikes. The data includes environmental and seasonal factors, making it ideal for machine learning predictions. The goal is to develop an accurate predictive model using the Random Forest algorithm.

## Problem Statement

Bike-sharing systems automate the process of bike rental and return. The primary challenge for companies operating such systems is to predict the number of bikes rented daily based on environmental and seasonal settings. This information helps optimize inventory management and operational planning.

## Objective

To predict daily bike rental counts based on environmental and seasonal settings using machine learning.

## Dataset Description

The dataset, `bike_rental_dataset.xlsx`, consists of the following variables:

| Variable       | Description                                                                 |
|----------------|-----------------------------------------------------------------------------|
| instant        | Record index                                                               |
| dteday         | Date                                                                       |
| season         | Season (1: spring, 2: summer, 3: fall, 4: winter)                         |
| yr             | Year (0: 2011, 1: 2012)                                                   |
| mnth           | Month (1 to 12)                                                           |
| holiday        | Whether the day is a holiday or not                                       |
| weekday        | Day of the week                                                           |
| workingday     | Whether it is a working day (1: yes, 0: no)                               |
| weathersit     | Weather situation (1: clear, 2: misty, 3: light snow/rain, 4: heavy rain) |
| temp           | Normalized temperature in Celsius (scaled 0 to 1)                        |
| atemp          | Normalized "feels like" temperature in Celsius (scaled 0 to 1)           |
| hum            | Normalized humidity (scaled 0 to 1)                                       |
| windspeed      | Normalized wind speed (scaled 0 to 1)                                     |
| casual         | Count of casual (non-registered) users                                    |
| registered     | Count of registered users                                                |
| cnt            | Total rental bike count (target variable)                                |

## Steps Performed

### 1. Exploratory Data Analysis (EDA)

- Loaded dataset using `readxl` and other R libraries.
- Converted data types for attributes like `dteday`, `season`, and `weathersit`.
- Analyzed missing values.

### 2. Attribute Distribution and Trends

- **Monthly Distribution**: Created bar charts to visualize total rentals for each month.
- **Yearly Distribution**: Visualized yearly rental trends.
- **Outlier Analysis**: Used boxplots to identify outliers in variables like `cnt`, `temp`, and `hum`.

### 3. Data Preprocessing

- Identified and replaced outliers with `NA`.
- Imputed missing values with the mean.

### 4. Model Building

- Split data into training (70%) and testing (30%) sets.
- Trained a Random Forest model on the training data using `randomForest`.

### 5. Model Evaluation

- Predicted bike rental counts for the test dataset.
- Evaluated performance using:
  - **Root Mean Square Error (RMSE)**
  - **Mean Absolute Error (MAE)**
- Plotted actual vs. predicted values for visualization.

## Results

- **Random Forest Model Performance**:
  - RMSE: 272.4494
  - MAE: 188.9383

### Insights

- **Positive Correlations**:
  - Temperature (`temp`) and "feels like" temperature (`atemp`) positively correlate with bike rentals.
- **Negative Correlations**:
  - Humidity (`hum`) and windspeed negatively correlate with bike rentals.

## Visualizations

1. Monthly and yearly distribution of bike rentals.
2. Boxplots for outliers.
3. Actual vs. predicted values comparison.
