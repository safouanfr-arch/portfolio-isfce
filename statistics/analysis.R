args <- commandArgs(trailingOnly = TRUE)
out <- if (length(args) > 0) args[1] else "reports"
dir.create(out, recursive = TRUE, showWarnings = FALSE)

sample_values <- c(7, 5, 1, 5, 12, 3, 2, 1, 4, 7, 6, 4, 1, 8, 10, 3, 3, 6,
                   5, 2, 5, 8, 2, 6, 0, 7, 4, 4, 6, 8, 5, 5, 4, 7, 8, 10, 6, 3, 5, 3)
counts <- table(sample_values)
modes <- names(counts)[counts == max(counts)]
summary_table <- data.frame(
  observations = length(sample_values), mean = mean(sample_values),
  median = median(sample_values), variance = var(sample_values),
  sd = sd(sample_values), mode = paste(modes, collapse = ", ")
)
write.csv(summary_table, file.path(out, "descriptive.csv"), row.names = FALSE)

set.seed(106)
dice <- data.frame(first = sample(1:6, 1000, replace = TRUE),
                   second = sample(1:6, 1000, replace = TRUE))
joint <- with(dice, table(first, second))
conditional <- prop.table(joint, margin = 1)
write.csv(as.data.frame(joint), file.path(out, "dice.csv"), row.names = FALSE)

swiss_fit <- lm(Fertility ~ Education, data = swiss)
outages <- 0:12
n <- 150
p <- 0.02
pois_mean <- n * p
comparison <- data.frame(
  outages = outages, binomial = dbinom(outages, n, p), poisson = dpois(outages, pois_mean)
)
write.csv(comparison, file.path(out, "probabilities.csv"), row.names = FALSE)

capture.output(
  summary_table, quantile(sample_values), addmargins(joint), conditional,
  cor(dice$first, dice$second), summary(swiss_fit),
  qbinom(0.99, n, p), qpois(0.99, pois_mean),
  shapiro.test(trees$Volume), t.test(trees$Volume, mu = 32),
  file = file.path(out, "summary.txt")
)

pdf(file.path(out, "figures.pdf"), width = 9, height = 6)
barplot(counts, col = "#206568", main = "Observed frequencies", xlab = "Value")
boxplot(sample_values, horizontal = TRUE, col = "#df9c47", main = "Sample spread")
barplot(t(conditional), beside = TRUE, col = hcl.colors(6, "YlGnBu"),
        main = "Second die given the first result", xlab = "First result",
        legend.text = colnames(joint))
plot(Fertility ~ Education, data = swiss, pch = 19, col = "#206568",
     main = "Swiss dataset: education and fertility")
abline(swiss_fit, col = "#a94235", lwd = 2)
matplot(outages, comparison[, c("binomial", "poisson")], type = "b", pch = c(16, 1),
        col = c("#206568", "#a94235"), xlab = "Outages", ylab = "Probability",
        main = "Binomial and Poisson")
legend("topright", legend = c("Binomial", "Poisson"), col = c("#206568", "#a94235"),
       pch = c(16, 1), bty = "n")
invisible(dev.off())

stopifnot(length(sample_values) == 40, median(sample_values) == 5, sum(joint) == 1000,
          all(abs(rowSums(conditional) - 1) < 1e-10))
cat("Statistics report generated in", out, "\n")
