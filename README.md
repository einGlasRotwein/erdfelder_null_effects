
# Uncovering Null Effects

This repository contains the `R` code behind the analyses and the supplementary material for the Article "Uncovering Null Effects in Null Fields: The Case of Homeopathy".

## Authors

- Edgar Erdfelder - [orcid](https://orcid.org/0000-0003-1032-3981)
- Juliane Nagel - [orcid](https://orcid.org/0000-0002-5310-8088)
- Daniel W. Heck - [orcid](https://orcid.org/0000-0002-6302-9252)
- Nils Petras - [orcid](https://orcid.org/0000-0001-9528-2298)

## Files

For all files related to the the project, please visit the project's [OSF repository](https://osf.io/wuq2h/).

### Analysis Code

The supplementary material can be directly rendered from the [Quarto](https://quarto.org/) document `erdfelder_supplement.R`.
(See the pre-rendered `erdfelder_supplement.html`.)

If you prefer a more lightweight version without having to render a Quarto document, an R script containing the same code (`erdfelder_supplement.R`) is also available.

### Data

In the folder `data`, you can find two data files:

1) The full data set accompanying the Sigurdson et al. article, which our analysis is based on.

2) For convenience, we also uploaded a reduced data set that only contains the subset of studies we analyzed. This subset of the data also contains the t-values we calculated from the Hedges' g reported in the Sigurdson data.

See the codebook in the `data` folder for further details.

## metamix

The analyses rely on the package `metamix` (described in the article). 
It can be found on [GitHub](https://github.com/NilsPetras/metamix) and can be installed as follows:

```R
library("devtools") # if not available: install.packages("devtools")
install_github("NilsPetras/metamix")

# load the package via
library("metamix")
```
