# Load necessary libraries
library(ggplot2)
library(readxl)
library(dplyr)
library(randomForest)
library(caret)

# Load Dataset
file_path <- "C:/Users/shint/Desktop/Fortray/5. Data Analytics with R/Project 2_Bike Rental Prediction/bike_rental_dataset.xlsx"
bike_df <- read_excel(file_path)

# Data type conversion
bike_df <- bike_df %>%
  mutate(
    dteday = as.Date(dteday),  
    yr = as.factor(yr),
    mnth = as.factor(mnth),
    season = as.factor(season),
    holiday = as.factor(holiday),
    weekday = as.factor(weekday),
    workingday = as.factor(workingday),
    weathersit = as.factor(weathersit) 
  )

# Missing value analysis
missing_val <- colSums(is.na(bike_df))
print(missing_val)

# Plot monthly distribution of total bike rentals
monthly_plot <- bike_df %>%
  group_by(mnth) %>%
  summarise(total_rentals = sum(cnt)) %>%
  ggplot(aes(x = mnth, y = total_rentals, fill = mnth)) +
  geom_bar(stat = "identity") +
  labs(x = "Month", y = "Total Rentals", title = "Monthly Distribution of Bike Rentals") +
  theme_minimal()

print(monthly_plot)

# Plot yearly distribution of total bike rentals
yearly_plot <- bike_df %>%
  group_by(yr) %>%
  summarise(total_rentals = sum(cnt)) %>%
  ggplot(aes(x = yr, y = total_rentals, fill = yr)) +
  geom_bar(stat = "identity") +
  labs(x = "Year", y = "Total Rentals", title = "Yearly Distribution of Bike Rentals") +
  theme_minimal()

print(yearly_plot)

# Outlier Analysis 
# Section: Boxplot for Bike Rental Count with Outliers

# Boxplot for bike rental count with outliers
boxplot(bike_df$cnt, main = 'Bike Rental Count', sub = ifelse(length(boxplot.stats(bike_df$cnt)$out) == 0, "No Outliers", paste("Outliers: ", boxplot.stats(bike_df$cnt)$out)),
        ylab = 'Count', col = "cyan", border = "blue")

# Add statistical values
text(1, boxplot.stats(bike_df$cnt)$stats[1], paste("Min:", round(boxplot.stats(bike_df$cnt)$stats[1], 2)), pos = 4, cex = 1)
text(1, boxplot.stats(bike_df$cnt)$stats[2], paste("1st Quartile:", round(boxplot.stats(bike_df$cnt)$stats[2], 2)), pos = 4, cex = 1)
text(1, boxplot.stats(bike_df$cnt)$stats[3], paste("Median:", round(boxplot.stats(bike_df$cnt)$stats[3], 2)), pos = 4, cex = 1)
text(1, boxplot.stats(bike_df$cnt)$stats[4], paste("Mean:", round(mean(bike_df$cnt), 2)), pos = 4, cex = 1)
text(1, boxplot.stats(bike_df$cnt)$stats[5], paste("3rd Quartile:", round(boxplot.stats(bike_df$cnt)$stats[5], 2)), pos = 4, cex = 1)
text(1, boxplot.stats(bike_df$cnt)$stats[6], paste("Max:", round(boxplot.stats(bike_df$cnt)$stats[6], 2)), pos = 4, cex = 1)


# Section: Boxplots for Outliers in Temperature, Feel-like Temperature, Humidity, and Windspeed

# Set up the layout for multiple boxplots
par(mfrow = c(2, 2))

# Box plot for temperature outliers
boxplot(bike_df$temp, main = "Temperature", sub = ifelse(length(boxplot.stats(bike_df$temp)$out) == 0, "No Outliers", paste("Outliers: ", boxplot.stats(bike_df$temp)$out)),
        col = "#FF6347", border = "#8B0000", notch = TRUE, outline = FALSE)

# Box plot for feel-like temperature outliers
boxplot(bike_df$atemp, main = "Feel-like Temperature", sub = ifelse(length(boxplot.stats(bike_df$atemp)$out) == 0, "No Outliers", paste("Outliers: ", boxplot.stats(bike_df$atemp)$out)),
        col = "pink", border = "red", notch = TRUE, outline = FALSE)

# Box plot for humidity outliers
boxplot(bike_df$hum, main = "Humidity", sub = ifelse(length(boxplot.stats(bike_df$hum)$out) == 0, "No Outliers", paste("Outliers: ", boxplot.stats(bike_df$hum)$out)),
        col = "#87CEEB", border = "#1E90FF", notch = TRUE, outline = FALSE)

# Box plot for windspeed outliers
boxplot(bike_df$windspeed, main = "Windspeed", sub = ifelse(length(boxplot.stats(bike_df$windspeed)$out) == 0, "No Outliers", paste("Outliers: ", boxplot.stats(bike_df$windspeed)$out)),
        col = "#98FB98", border = "#008000", notch = TRUE, outline = FALSE)


# Outlier Replacement and Imputation
# Section: Replacing and Imputing Outliers in Humidity and Windspeed

# Function to replace outliers with NA
replace_outliers <- function(x) {
  q <- quantile(x, c(0.25, 0.75))
  iqr <- q[2] - q[1]
  lower_bound <- q[1] - 1.5 * iqr
  upper_bound <- q[2] + 1.5 * iqr
  x[x < lower_bound | x > upper_bound] <- NA
  return(x)
}

# Apply the function to windspeed and humidity
bike_df$windspeed <- replace_outliers(bike_df$windspeed)
bike_df$hum <- replace_outliers(bike_df$hum)

# Impute missing values using mean imputation method
bike_df$windspeed[is.na(bike_df$windspeed)] <- mean(bike_df$windspeed, na.rm = TRUE)
bike_df$hum[is.na(bike_df$hum)] <- mean(bike_df$hum, na.rm = TRUE)

# Plot for numerical variables in combined dataset
# Select numerical columns for histogram and normal probability plot
numerical_columns <- sapply(bike_df[, 8:15], is.numeric)

# Histograms for numerical variables
for (column in names(bike_df[, 8:15][, numerical_columns])) {
  hist(bike_df[, column], main = paste("Histogram for", column),
       xlab = column, col = "skyblue", border = "black")
}

# Normal probability plots for numerical variables
for (column in names(bike_df[, 8:15][, numerical_columns])) {
  qqnorm(bike_df[, column], main = paste("Normal Probability Plot for", column))
  qqline(bike_df[, column], col = 2)
  
  # Add insight annotation
  annotation <- "Some data points are deviating from normality in a good way."
  text(quantile(bike_df[, column], 1.0), quantile(bike_df[, column], 0.1), annotation, adj = c(0, 1), cex = 0.8, col = "darkgreen")
}


# Section: Correlation Analysis of Numerical Variables in Combined Dataset

# Identify numeric columns for correlation analysis
numeric_columns <- sapply(bike_df[, 8:15], is.numeric)

# Create a correlation plot
corrgram(bike_df[, 8:15][, numeric_columns], order = FALSE, upper.panel = panel.pie, text.panel = panel.txt, main = 'Correlation Plot')

# Add insight on positive and negative correlations
cat("Positive Correlations: temp, atemp, and yr have positive correlations with the target variable.\n")
cat("Negative Correlations: weathersit, hum, and windspeed have negative correlations with the target variable.\n")

# Identify variables that may not be needed for further analysis based on correlation
cat("\nVariables with weak correlation (abs(correlation) <= 0.1) with the target variable:\n")
weak_corr_vars <- names(bike_df[, 8:15][, numeric_columns])[sapply(bike_df[, 8:15][, numeric_columns], function(x) abs(cor(x, bike_df$cnt)) <= 0.1)]
print(weak_corr_vars)

# Split the dataset into training and testing sets
set.seed(123)  # for reproducibility
train_index <- sample(1:nrow(bike_df), 0.7 * nrow(bike_df))
train_data <- bike_df[train_index, ]
test_data <- bike_df[-train_index, ]

# Confirm dimensions of the training and testing datasets
cat("Dimensions of Training Data:", dim(train_data), "\n")
cat("Dimensions of Testing Data:", dim(test_data), "\n")

# Train the Random Forest model
set.seed(456)  # for reproducibility
rf_model <- randomForest(cnt ~ ., data = train_data, ntree = 200)

# Display the trained model
print(rf_model)

# Predict using the trained model
rf_predictions <- predict(rf_model, newdata = test_data)

# Evaluate model performance
rmse <- sqrt(mean((rf_predictions - test_data$cnt)^2))
mae <- mean(abs(rf_predictions - test_data$cnt))

cat("Random Forest Model Performance on Test Data:\n")
cat("RMSE:", rmse, "\n")
cat("MAE:", mae, "\n")

# Reset the plotting area
dev.off()

# Set up a new plotting window with larger dimensions
windows(width = 12, height = 8)

# Increase plot size and adjust margins
par(mar = c(5, 5, 4, 2) + 0.1, oma = c(1, 1, 1, 1), cex = 1.5)

# Plot actual vs predicted values with increased line width and point size
plot(test_data$cnt, col = 'blue', type = 'l', ylim = c(0, max(test_data$cnt, rf_predictions)), 
     xlab = 'Index', ylab = 'Count', main = 'Actual vs Predicted Values', lwd = 3, cex.lab = 1.5, cex.axis = 1.5, cex.main = 2)
lines(rf_predictions, col = 'red', lwd = 3)

# Add points for better visibility
points(test_data$cnt, col = 'blue', pch = 16, cex = 1.5)
points(rf_predictions, col = 'red', pch = 16, cex = 1.5)

# Add legend with increased text size and position it outside the plot
legend("topright", inset = c(-0.2, 0), legend = c("Actual", "Predicted"), col = c("blue", "red"), 
       lty = 1, lwd = 3, cex = 1.5, pch = 16, xpd = TRUE)

