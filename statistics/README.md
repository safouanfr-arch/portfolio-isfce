# Statistics Workshops in R

Two ISFCE statistics workshops grouped into one reproducible base-R report. It uses the original univariate sample, a seeded simulation of paired dice, and the public datasets included with R. [Preview the generated figures](sample-report.pdf).

```sh
Rscript statistics/analysis.R reports
```

The script generates `figures.pdf`, three CSV tables and a text summary. It covers:

- Descriptive statistics, frequency distributions and boxplots.
- Joint, marginal and conditional distributions of dice rolls.
- Correlation and a linear fit for the `swiss` dataset. An association in these historical observations is not evidence of causality.
- Binomial and Poisson probability comparisons, plus a Shapiro-Wilk test and a one-sample t-test using `trees`.
