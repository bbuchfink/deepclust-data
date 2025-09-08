#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(optparse)
  library(ggplot2); library(dplyr); library(purrr); library(stringr)
  library(tidyr); library(tools); library(scales)
  library(paletteer)
})

parser <- OptionParser()
parser <- add_option(parser, c("-t","--total"), type="integer",
                     help="Fixed total number of queries (used for padding). REQUIRED.")
parser <- add_option(parser, c("-o","--out"), type="character", default=NULL,
                     help="Output image path (png/pdf/svg). If omitted, displays interactively.")
parser <- add_option(parser, c("-l","--labels"), type="character", default=NULL,
                     help="Comma-separated labels for datasets (must match number of files).")
parser <- add_option(parser, c("-s","--step"), type="integer", default=1,
                     help="Coverage step size in percent for x-axis (default: 1).")
parser <- add_option(parser, c("--title"), type="character", default="Query coverage curves",
                     help="Plot title.")

parsed <- parse_args(parser, positional_arguments = TRUE)
opt   <- parsed$options
args  <- c("scop-covs.txt", "uniprot-covs.txt", "pfam-covs.txt", "mgnify-covs.txt", "bfd-covs.txt", "cath-covs.txt", "ecod-covs.txt" )

if (is.null(opt$total) || length(args) < 1) {
  cat("ERROR: --total and at least one input file are required.\n",
      "Example: Rscript fig2.R --total 1000000 data/a.txt data/b.txt\n", sep="")
  quit(status = 2)
}

file_labels <- {
  labs = c("ASTRAL SCOPe", "UniProtKB/TrEMBL", "Pfam-A", "MGnify", "Big Fantastic Database", "CATH", "ECOD") 
  labs
}

read_numeric_column <- function(path) {
  con <- if (grepl("\\.gz$", path, ignore.case = TRUE)) gzfile(path, "rt") else path
  vals <- tryCatch(
    scan(con, what = numeric(), quiet = TRUE, comment.char = "#"),
    error = function(e) {
      stop(sprintf("Failed to read numbers from %s: %s", path, e$message))
    }
  )
  vals
}

build_curve <- function(path, label, total, by_step = 0.1) {
  x <- read_numeric_column(path)
  x <- x * 100
  bad <- sum(!is.finite(x))
  if (bad > 0) message(sprintf("Warning: %s had %d non-numeric values; they were ignored.", path, bad))
  x <- x[is.finite(x)]

  out_of_range <- sum(x < 0 | x > 100)
  if (out_of_range > 0) {
    message(sprintf("Warning: %s had %d values outside [0,100]; they were clipped.", path, out_of_range))
    x <- pmin(pmax(x, 0), 100)
  }

  n_in <- length(x)

  if (n_in < total) {
    x <- c(x, rep(0, total - n_in))
    n_den <- total
  } else if (n_in > total) {
    message(sprintf("Notice: %s has %d rows which exceeds --total=%d; using %d as denominator.", path, n_in, total, n_in))
    n_den <- n_in
  } else {
    n_den <- total
  }

  grid <- seq(0, 100, by = by_step)
  x_sorted <- sort(x, method = "quick")
  at_least <- function(c) {
    lt_c <- findInterval(c, x_sorted, left.open = TRUE, rightmost.closed = TRUE)
    (n_den - lt_c) / n_den
  }
  frac <- vapply(grid, at_least, numeric(1))

  tibble(
    coverage = grid,
    fraction = frac,
    Database  = label
  )
}

curves <- map2_dfr(args, file_labels, ~build_curve(.x, .y, total = opt$total, by_step = opt$step))
curves <- dplyr::filter(curves, coverage > 0)
curves$Database <- factor(curves$Database, c("Big Fantastic Database", "MGnify", "UniProtKB/TrEMBL", "Pfam-A", "ECOD", "CATH", "ASTRAL SCOPe"))

write.table(curves, file='fig2.tsv', quote=FALSE, sep='\t')

p <- ggplot(curves, aes(x = coverage, y = fraction, color = Database)) +
  geom_line(linewidth = 1.15, lineend = "round") +
  scale_y_continuous(limits = c(0, 0.8), breaks = seq(0, 1, by = 0.05), labels = percent_format(accuracy = 1), expand = expansion(mult = c(0, 0.02))) +
  scale_x_continuous(breaks = seq(0, 100, by = 10), limits = c(0, 100), expand = expansion(mult = 0)) +
  labs(
    title = opt$title,
    x = "Query coverage threshold (%)",
    y = "Fraction of annotated clusters (%)"
  ) +
  theme_minimal(base_size = 13) +
  #scale_fill_paletteer_d("nbapalettes::supersonics_holiday") +
  scale_colour_manual(values = c("#a58aff","#00b6eb","#53b400","#00c094","#fb61d7","#f8766d","#c49a00")) +
  ggtitle("") +
  theme(
    panel.grid.minor = element_blank(),
    legend.position = "right",
    legend.key.height = unit(14, "pt")
  )

cowplot::save_plot("fig2.svg", p, base_height = 8, base_width = 9)