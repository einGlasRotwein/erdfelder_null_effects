
# Analysis script for the article Article “Uncovering Null Effects in Null 
# Fields: The Case of Homeopathy”
# Consists of the same code as the Quarto document of the same name, but offers 
# a more lightweight version for those who do not want to render a Quarto 
# document.

## SETUP -----------------------------------------------------------------------

# R version: 4.3.1 (2023-06-16 ucrt)

library(openxlsx) # 4.2.5.2
library(ggplot2) # 3.4.2
library(metamix) # 0.1.0

# Plot settings
reproducibilitea_blue1 <- "#0086cf"
reproducibilitea_blue2 <- "#004c6c"

custom_theme <- 
  theme(
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 14),
    plot.title = element_text(
      size = 14,
      face = "bold",
      hjust = .5)
  )

# Function that converts Hedges' g to t
# hedges_g: Double. The Hedges' g value(s) to convert.
# n1:       Integer. Sample size group 1.
# n2:       Integer. Sample size group 2.
# correct:  Logical. Indicates whether the Hedges' g provided has been 
#           corrected by the correction factor J, where
#           J = 1 - 3 / (4v-1)
#           and
#           v = n1 + n2 - 2

h_to_t <- function(hedges_g, n1, n2, correct = FALSE) {
  if (correct) {
    hedges_g <- hedges_g / (1 - 3 / (4 * (n1 + n2 - 2) - 1))
  }
  t <- hedges_g * 1 / sqrt(1 / n1 + 1 / n2)
  return(t)
}

## READ AND PREPARE DATA -------------------------------------------------------

homeopathy_sheet <- 
  read.xlsx(
    "./data/1-s2.0-S0895435623000100-mmc2.xlsx",
    "Homeopathy"
  )

# Select relevant columns
cols <- c(
  "Index",
  "PMIDs",
  "Effect.size",
  "Measurement",
  "SD",
  "Sample.size", 
  "Number.of.groups"
)

homeopathy_sheet <- homeopathy_sheet[cols]

stats_sheet <- 
  read.xlsx(
    "./data/1-s2.0-S0895435623000100-mmc2.xlsx",
    "Effect sizes raw data"
  )

group_ns <- 
  stats_sheet[c("Index", "Placebo.group.n", "Treatment.group.n")]

# Add group ns to info sheet
data <- merge.data.frame(
  homeopathy_sheet,
  group_ns,
  by = "Index")

## CALCULATE T-VALUES ----------------------------------------------------------

# Isolate studies where the outcome is the standardized mean difference
data$Effect.size.smd <- 
  ifelse(data$Measurement == "SMD", data$Effect.size, NA)

# Calculate df for studies with two groups or more
data$df[data$Number.of.groups > 1] <- 
  data$Placebo.group.n[data$Number.of.groups > 1] +
  data$Treatment.group.n[data$Number.of.groups > 1] - 2

# Calculate corrected t values for studies with two groups or more
data$corrt[data$Number.of.groups > 1] <- 
  h_to_t(
    data$Effect.size.smd[data$Number.of.groups > 1],
    data$Placebo.group.n[data$Number.of.groups > 1],
    data$Treatment.group.n[data$Number.of.groups > 1],
    correct = TRUE
  )

## FIG 1 - HEDGES' G DISTRIBUTION ----------------------------------------------

main <- data[data$Measurement == "SMD" & data$Number.of.groups > 1, ]

mean_effect_subset <- mean(main$Effect.size.smd)

ci_effect_subset <- 
  c(
    mean(main$Effect.size.smd) - qnorm(.975) * sd(main$Effect.size.smd) / 
      sqrt(nrow(main)),
    mean(main$Effect.size.smd) + qnorm(.975) * sd(main$Effect.size.smd) / 
      sqrt(nrow(main))
  )

# Fig 1
# Distribution of Hedges' g effect sizes in the subset of studies taken from 
# Sigurdson’s homeopathy data set that consist of more than one group.
# The dashed line and the colored area indicate the mean and its 95% confidence 
# interval.
ggplot(
  data[data$Measurement == "SMD" & data$Number.of.groups > 1, ],
  aes(x = Effect.size.smd)
) +
  annotate(
    "rect",
    xmin = ci_effect_subset[1], xmax = ci_effect_subset[2],
    ymin = -Inf, ymax = Inf,
    fill = reproducibilitea_blue1,
    alpha = .1) +
  geom_vline(
    xintercept = mean_effect_subset,
    linetype = "dashed",
    color = reproducibilitea_blue2) +
  geom_histogram(
    bins = 20,
    colour = "black",
    fill = NA) +
  labs(x = "Adjusted Hedges' g") +
  scale_y_continuous(
    "Count",
    limits = c(0, 8),
    breaks = seq(0, 8, 2)) +
  scale_x_continuous(
    limits = c(-1.8, 1.8),
    breaks = round(c(-1, 0, mean_effect_subset, 1), 2)) +
  labs(title = "Effect sizes of included studies") +
  theme_classic() +
  custom_theme

## MAIN ANALYSIS ---------------------------------------------------------------

cat("number of selected studies (k) in the main analysis:")
nrow(main)
cat("mean effect size of the k selected studies:")
mean(main$Effect.size.smd)
cat("with a confidence interval of")
ci_effect_subset

main_results <- metamix(
  t = main$corrt,
  n1 = main$Treatment.group.n,
  n2 = main$Placebo.group.n,
  nrep = 5e5
)

main_results

## FIG 2 - METAMIX RESULTS -----------------------------------------------------

# Fig 2
# Model implied distribution of t-values and publication status
mixplot(main_results) + xlim(-5, 5) + custom_theme
