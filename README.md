# Alcohol Content and Red Wine Quality: A Simple Linear Regression Model

Team project for Math 456 (Mathematical Modeling). We use simple linear
regression to model red wine quality as a function of alcohol content, using
the UCI Machine Learning Repository's [Wine Quality dataset](https://archive.ics.uci.edu/dataset/186/wine+quality)
(red wine subset, n = 1,599).

**Authors:** Shreyes Balaji, Marwan Hegab, Mazin Hussein, Mikael Rotberg,
Roberto Rubio, Jordan Woda

## Summary

- 70/30 train/test split (1,119 / 480 observations), `set.seed(456)` for reproducibility.
- Alcohol and quality show a moderate positive correlation (r = 0.476).
- 49 influential training points (Cook's distance > 4/n) were removed before the final fit.
- Final model: `quality_hat = 1.3817 + 0.4131 * alcohol`
- Training fit: RSE = 0.609, R² = 0.313 (adjusted 0.312), F = 485.8, p < 2e-16.
- Test-set performance: RMSE = 0.706, MAE = 0.551, R² = 0.215.
- Example: at 12.0% alcohol, predicted quality = 6.339 (95% CI [6.268, 6.410], 95% PI [5.141, 7.537]).

Alcohol content is a statistically significant predictor of quality, but on its
own explains only a limited share of the variation — expected, since wine
quality depends on many chemical properties beyond alcohol. See the essay for
full discussion, diagnostics, and limitations.

## Files

- [`project_1_essay.pdf`](project_1_essay.pdf) — full write-up (introduction, data
  description, analysis, model evaluation, conclusion, references).
- [`analysis.R`](analysis.R) — R code for the full analysis, from data loading
  through diagnostics, influential-point removal, test-set evaluation, and prediction.
- [`data/winequality-red.csv`](data/winequality-red.csv) — the dataset (semicolon-delimited).

## Reproducing the analysis

```r
install.packages(c("tidyverse", "ggpubr", "broom", "car"))
```

Open this folder as your working directory (e.g. open `project_1/` in RStudio),
then run `analysis.R` top to bottom. It reads `data/winequality-red.csv` using
a relative path, so no `setwd()` edits should be needed if the folder structure
is kept intact.

## References

1. UCI Machine Learning Repository — Wine Quality dataset: https://archive.ics.uci.edu/dataset/186/wine+quality
2. STHDA — Simple Linear Regression in R: http://www.sthda.com/english/articles/40-regression-analysis/167-simple-linear-regression-in-r/
3. Moore, I. — Back to Basics: Linear Regression with R: https://medium.com/@ian.moore_83986/back-to-basics-linear-regression-with-r-931d22409d24
