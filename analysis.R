# Alcohol Content and Red Wine Quality: A Simple Linear Regression Model
#
# How to run:
#   1. Install packages once:  install.packages(c("tidyverse","ggpubr","broom","car"))
#   2. Open this project folder in RStudio (or set it as your working directory
#      with setwd()) so the relative path "data/winequality-red.csv" resolves.
#   3. Run the script top to bottom (source it, or run section by section).
#
# Data: UCI Machine Learning Repository, Wine Quality (red wine subset)
#   https://archive.ics.uci.edu/dataset/186/wine+quality
#   Included at data/winequality-red.csv (semicolon-delimited).

# SECTION 0: setup ------------------------------------------------------
library(tidyverse)
library(ggpubr)
library(broom)
library(car)
theme_set(theme_pubr())

# SECTION 1: load and clean ----------------------------------------------
wine <- readr::read_delim("data/winequality-red.csv", delim = ";", show_col_types = FALSE)
dim(wine)
names(wine)
summary(wine[, c("alcohol", "quality")])

df <- wine %>% select(alcohol, quality)
colSums(is.na(df))
df <- df %>% drop_na()

# SECTION 2: explore relationship ----------------------------------------
p_scatter <- ggplot(df, aes(x = alcohol, y = quality)) +
  geom_point(alpha = 0.5) +
  stat_smooth(method = lm, se = TRUE) +
  labs(title = "Quality vs Alcohol (Full Data)",
       x = "Alcohol (% by volume)",
       y = "Quality")
p_scatter
cor(df$quality, df$alcohol)

# SECTION 3: train/test split ---------------------------------------------
set.seed(456)
n <- nrow(df)
train_idx <- sample(seq_len(n), size = floor(0.7 * n))
train <- df[train_idx, ]
test  <- df[-train_idx, ]
n_train <- nrow(train)
n_test  <- nrow(test)
n_train; n_test

# SECTION 4: initial model fit on training set -----------------------------
model <- lm(quality ~ alcohol, data = train)
model

# SECTION 5: model summary and formatted output ----------------------------
sum_model <- summary(model)
sum_model
confint(model)
tidy(model)
glance(model)

# SECTION 6: diagnostic plots ----------------------------------------------
par(mfrow = c(2, 2))
plot(model)
par(mfrow = c(1, 1))
qqnorm(residuals(model), main = "Normal Q-Q Plot (Diagonal Plot Check)")
qqline(residuals(model))

# SECTION 7: remove influential points and refit ---------------------------
cooks <- cooks.distance(model)
cook_threshold <- 4 / n_train
which_influential <- which(cooks > cook_threshold)
length(which_influential)
cook_threshold

train_clean <- train
if (length(which_influential) > 0) {
  train_clean <- train[-which_influential, ]
}
model_final <- lm(quality ~ alcohol, data = train_clean)
summary(model_final)

# SECTION 8: evaluate on the test set ---------------------------------------
test$pred <- predict(model_final, newdata = test)
rmse <- sqrt(mean((test$quality - test$pred)^2))
mae  <- mean(abs(test$quality - test$pred))
sst_test <- sum((test$quality - mean(test$quality))^2)
sse_test <- sum((test$quality - test$pred)^2)
r2_test <- 1 - (sse_test / sst_test)
rmse; mae; r2_test

p_avp <- ggplot(test, aes(x = quality, y = pred)) +
  geom_point(alpha = 0.6) +
  geom_abline(slope = 1, intercept = 0) +
  labs(title = "Test Set: Actual vs Predicted Quality",
       x = "Actual quality",
       y = "Predicted quality")
p_avp

# SECTION 9: final model summary ---------------------------------------------
summary(model_final)

# SECTION 10: example prediction with intervals -------------------------------
x_star <- 12.0
new_x <- data.frame(alcohol = x_star)
predict(model_final, newdata = new_x, interval = "confidence", level = 0.95)
predict(model_final, newdata = new_x, interval = "prediction", level = 0.95)
