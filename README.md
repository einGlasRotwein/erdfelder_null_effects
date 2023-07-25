
# Uncovering Null Effects

This repository contains the `R` code behind the analyses and the supplementary material for the Article "Uncovering Null Effects in Null Fields: The Case of Homeopathy".

## Authors

Edgar Erdfelder - [orcid](https://orcid.org/0000-0003-1032-3981)
Juliane Nagel - [orcid](https://orcid.org/0000-0002-5310-8088)
Daniel W. Heck - [orcid](https://orcid.org/0000-0002-6302-9252)
Nils Petras - [orcid](https://orcid.org/0000-0001-9528-2298)

## Files

The supplementary material can be directly rendered from the [Quarto](https://quarto.org/) document `erdfelder_supplement.R`.
(See the pre-rendered `erdfelder_supplement.html`.)

If you prefer a more lightweight version without having to render a Quarto document, an R script containting the same code (`erdfelder_supplement.R`) is also available.

You can find any other files belonging to the project at its [OSF repository]().

## metamix

The analyses rely on the package `metamix` (described in the article). 
It can be found on [GitHub](https://github.com/NilsPetras/metamix) and can be installed as follows:

```R
library("devtools") # if not available: install.packages("devtools")
install_github("NilsPetras/metamix")

# load the package via
library("metamix")
```
