# Clean up all variables
rm(list = ls())

# Libraries to load
library(tidyverse)
library(psych)

# Files to be read
maxTempFilename = "IDCJAC0010_023034_1800_Data.csv"
maxTempData = readr::read_csv(maxTempFilename)

# Dimensions
dim(maxTempData) 

# Column names
colnames(maxTempData)

minTempFilename = "IDCJAC0011_023034_1800_Data.csv"
minTempData = readr::read_csv(minTempFilename)

# Dimensions
dim(minTempData) 

# Column names
colnames(minTempData)

# Join year, month, and day columns into a single date column
maxTempData$Date <- as.Date(paste(maxTempData$Year, maxTempData$Month, 
                                  maxTempData$Day, sep = "-"))

minTempData$Date <- as.Date(paste(minTempData$Year, minTempData$Month, 
                                  minTempData$Day, sep = "-"))

# Convert months to month names
maxTempData$Month <- month.name[as.numeric(maxTempData$Month)]
minTempData$Month <- month.name[as.numeric(minTempData$Month)]

# Convert Day values to numeric type
maxTempData$Day <- as.numeric(maxTempData$Day)
minTempData$Day <- as.numeric(minTempData$Day)

# Identify rows with complete cases (no missing values) in Temperature column
maxTempData <- maxTempData[complete.cases(maxTempData[, c("Maximum temperature (Degree C)")]), ]
minTempData <- minTempData[complete.cases(minTempData[, c("Minimum temperature (Degree C)")]), ]

# Group the data by year and find the highest maximum temperature
maxTempEachYear <- maxTempData %>%
  group_by(Year) %>%
  filter(`Maximum temperature (Degree C)` == max(`Maximum temperature (Degree C)`)) %>%
  select(Year, Month, `Maximum temperature (Degree C)`)

# Find the maximum temperature across all years
max_temp <- max(maxTempData$`Maximum temperature (Degree C)`)

# Find the year corresponding to the maximum temperature
year_with_max_temp <- maxTempData$Year[maxTempData$`Maximum temperature (Degree C)` == max_temp]

# Display the maximum temperature and the corresponding year
cat("Maximum Temperature:", max_temp, "°C\n")
cat("Year with Maximum Temperature:", year_with_max_temp, "\n")

maxTempSummary <- maxTempData %>%
  group_by(Year, Month) %>%
  summarize(Max_Temperature = mean(`Maximum temperature (Degree C)`))

# Reorder the Month variable in calendar order
maxTempSummary$Month <- factor(maxTempSummary$Month, levels = month.name)

# Create the line plot
ggplot(maxTempSummary, aes(x = Year, y = Max_Temperature, color = Month)) +
  geom_line() +
  labs(
    title = "Mean Maximum Temperatures by Month and Year",
    x = "Year",
    y = "Maximum Temperature (°C)"
  ) +
  facet_wrap(~Month, ncol = 4) +
  theme_light() +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(
    text = element_text(size = 14)  
  )

# Group the data by year and find the lowest minimum temperature
minTempEachYear <- minTempData %>%
  group_by(Year) %>%
  filter(`Minimum temperature (Degree C)` == min(`Minimum temperature (Degree C)`)) %>%
  select(Year, Month, `Minimum temperature (Degree C)`)

# Find the minimum temperature across all years
min_temp <- min(minTempData$`Minimum temperature (Degree C)`)

# Find the year corresponding to the maximum temperature
year_with_min_temp <- minTempData$Year[minTempData$`Minimum temperature (Degree C)` == min_temp]

# Display the maximum temperature and the corresponding year
cat("Minimum Temperature:", min_temp, "°C\n")
cat("Year with Minimum Temperature:", year_with_min_temp, "\n")

minTempSummary <- minTempData %>%
  group_by(Year, Month) %>%
  summarize(Min_Temperature = mean(`Minimum temperature (Degree C)`))

# Reorder the Month variable in calendar order
minTempSummary$Month <- factor(minTempSummary$Month, levels = month.name)

# Create the line plot
ggplot(minTempSummary, aes(x = Year, y = Min_Temperature, color = Month)) +
  geom_line() +
  labs(
    title = "Mean Minimum Temperatures by Month and Year",
    x = "Year",
    y = "Minimum Temperature (°C)"
  ) +
  facet_wrap(~Month, ncol = 4) +
  theme_light() +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(
    text = element_text(size = 14) 
  )

# Function to calculate and present descriptive statistics for any given month and year
calculateDescriptiveStats <- function(data, years, months) {
  data %>%
    filter(Year %in% years, Month %in% months) %>%
    group_by(Year, Month) %>%
    summarise(
      Mean = mean(`Maximum temperature (Degree C)`, na.rm = TRUE),
      SD = sd(`Maximum temperature (Degree C)`, na.rm = TRUE),
      Skewness = skew(`Maximum temperature (Degree C)`, na.rm = TRUE),
      Kurtosis = kurtosi(`Maximum temperature (Degree C)`, na.rm = TRUE),
      Median = median(`Maximum temperature (Degree C)`, na.rm = TRUE),
      IQR = IQR(`Maximum temperature (Degree C)`, na.rm = TRUE)
    ) %>%
    mutate(across(where(is.numeric), ~round(., 2))) %>%  # Round numeric columns
    ungroup()
}

# Example usage: Analyze for multiple years and months
years_to_analyze <- c(1961, 1971, 1981, 1991, 2001, 2011, 2021)
months_to_analyze <- c('January', 'July') 

descriptiveStats <- calculateDescriptiveStats(maxTempData, years_to_analyze, months_to_analyze)
print(descriptiveStats)

# Convert Year to a factor to treat it as categorical
descriptiveStats$Year <- factor(descriptiveStats$Year)

# Create the line graph to study means
ggplot(descriptiveStats, aes(x = Year, y = Mean, fill = Month)) +
  geom_line(color = "#69b3a2", linewidth = 1, alpha = 0.9, linetype = 2, group = 1) +
  geom_point(aes(label = round(Mean, 2)), color = "red", size = 3) +  
  geom_text(aes(label = round(Mean, 2)), vjust = -1) +  
  labs(
    title = "Study of Mean Maximum Temperature over Six Decades",
    x = "Year",
    y = "Mean Maximum Temperature (°C)"
  ) +
  facet_wrap(~Month, ncol = 1) +
  theme_light() +
  ylim(0, 35) +
  theme(
    plot.title = element_text(hjust = 0.5),
    text = element_text(size = 12)  
  ) +
  guides(fill = FALSE)  # Remove the legend


# Boxplot to study medians of temperatures
custom_palette <- c("darkgoldenrod", "darkcyan", "darkmagenta", "darkgreen", "darkred", "darkblue", "red")

filteredData <- maxTempData %>% filter(Month %in% descriptiveStats$Month, Year %in% descriptiveStats$Year)

# Create the boxplots and add dots for individual data points
ggplot(filteredData, aes(x = Year, y = `Maximum temperature (Degree C)`, fill = Month, color = factor(Year))) +
  geom_boxplot(position = position_dodge()) +  # Add boxplots
  geom_jitter() +  # Add data points
  labs(
    title = "Comparison of Maximum Temperatures",
    x = "Year",
    y = "Temperature (°C)"
  ) +
  theme_minimal() +
  scale_color_manual(values = custom_palette) +
  scale_fill_manual(values = c("coral", "cadetblue1")) +
  labs(fill = "Month", color = "Year") +  
  theme(
    plot.title = element_text(hjust = 0.5),
    text = element_text(size = 12)
  ) 

# Combine two data sets together and calculate a daily range between maximal
# and minimal temperature
minMaxTemp <- left_join(maxTempData, 
                    minTempData %>% 
                      select(`Minimum temperature (Degree C)`, 
                             `Days of accumulation of minimum temperature`, 
                             Date),
                    by = "Date")  %>%
  mutate(`Daily Range` = `Maximum temperature (Degree C)` - `Minimum temperature (Degree C)`
  )

# Filter data for specific years
filteredData <- minMaxTemp[minMaxTemp$Year %in% years_to_analyze, ]
filteredData$Month <- factor(filteredData$Month, levels = month.name)

# Create the faceted violin plot
ggplot(filteredData, aes(x = Month, y = `Daily Range`, fill = Year)) +
  geom_violin() +
  labs(
    title = "Daily Temperature Range by Month and Year",
    x = "Month",
    y = "Daily Temperature Range (°C)"
  ) +
  theme_light() +
  facet_wrap(~Year, ncol = 1)   +
  theme(
    plot.title = element_text(hjust = 0.5),
    text = element_text(size = 12) 
  ) 

# Filter the data for temperatures >= 35 degrees
heatwaveData <- maxTempData %>%
  filter(`Maximum temperature (Degree C)` >= 35)

# Group the data by year and count the number of days per year
countPerYear <- heatwaveData %>%
  group_by(Year) %>%
  summarise(Count = n())

# Create the bar chart
ggplot(countPerYear, aes(x = Year, y = Count, fill = Year)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  labs(
    title = "Number of Days with Max Temperature Above 35°C",
    x = "Year",
    y = "Count"
  ) +
  theme_minimal() + 
  geom_text(aes(label = Count), hjust = -0.3, size=3)  +
  theme(
    plot.title = element_text(hjust = 0.5),
    text = element_text(size = 12)  
  ) 

# Filter the data for temperatures <=3 degrees
coldspellData <- minTempData %>%
  filter(`Minimum temperature (Degree C)` <= 3)

# Group the data by year and count the number of days per year
countPerYear <- coldspellData %>%
  group_by(Year) %>%
  summarise(Count = n())

ggplot(countPerYear, aes(x = Year, y = Count, fill = Year)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  labs(
    title = "Number of Days with Min Temperature Below 4°C",
    x = "Year",
    y = "Count"
  ) +
  theme_minimal() +
  geom_text(aes(label = Count), hjust = -0.3, size=3)  +
  theme(
    plot.title = element_text(hjust = 0.5),
    text = element_text(size = 12)  
  ) 
