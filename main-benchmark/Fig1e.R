#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(ggplot2)
  library(scales)
})

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) {
  stop("Please provide the path to a TSV file.\nUsage: Rscript plot_tsv.R input.tsv [output.png] [\"Plot Title\"]", call. = FALSE)
}

in_path  <- args[1]
out_path <- if (length(args) >= 2) args[2] else sub("\\.tsv$|$", ".png", in_path, perl = TRUE)
plot_title <- if (length(args) >= 3) args[3] else "Cluster count"

if (!file.exists(in_path)) stop(paste0("File not found: ", in_path), call. = FALSE)

first_line <- readLines(in_path, n = 1, warn = FALSE)
parts <- strsplit(first_line, "\t", fixed = TRUE)[[1]]
second_is_numeric <- suppressWarnings(!is.na(as.numeric(parts[2])))
has_header <- !second_is_numeric

df_raw <- readr::read_tsv(
  in_path,
  col_names = has_header,
  show_col_types = FALSE,
  progress = FALSE
)

if (has_header) {
  if (ncol(df_raw) < 2) stop("Expected at least two columns in the TSV.", call. = FALSE)
  names(df_raw)[1:2] <- c("dataset", "count")
} else {
  if (ncol(df_raw) < 2) stop("Expected at least two columns in the TSV.", call. = FALSE)
  names(df_raw)[1:2] <- c("dataset", "count")
}

df <- df_raw %>%
  transmute(
    dataset = trimws(as.character(.data$dataset)),
    count   = suppressWarnings(as.numeric(.data$count))
  ) %>%
  filter(!is.na(dataset), dataset != "") %>%
  group_by(dataset) %>%
  summarise(count = sum(count, na.rm = TRUE), .groups = "drop") %>%
  arrange(desc(count))

if (nrow(df) == 0) stop("No valid rows found (check your file formatting).", call. = FALSE)

plot_height <- max(4, nrow(df) * 0.35)
df$dataset <- factor(df$dataset, c("DIAMOND DeepClust (uni-dir. coverage)","MMseqs2/Linclust","FLSHclust","DIAMOND DeepClust (linear mode)","MMseqs2","DIAMOND DeepClust"))

p <- ggplot(df, aes(x = dataset, y = count, fill = dataset)) +
  geom_col(width = 0.7) +
  coord_flip() +
  geom_text(aes(label = comma(count)),
            hjust = -0.1, size = 4) +
  scale_y_continuous(
    expand = expansion(mult = c(0, 0.1)),
    labels = comma
  ) +
  labs(
    title = plot_title,
    x = NULL,
    y = "Cluster count (millions)",
    caption = basename(in_path)
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 18, margin = margin(b = 6)),
    axis.text.y = element_text(size = 12),
    axis.title.x = element_text(margin = margin(t = 6), size=18, face = "bold"),
	axis.text.x      = ggplot2::element_text(size = 14),
	strip.text.x     = ggplot2::element_text(
        size           = 18,
        colour         = "black",
        face           = "bold"
      )
  ) +
  scale_fill_manual(values = ggsci::pal_npg("nrc")(6)[c(2, 6, 1, 5, 4, 3)]) +  
  theme(legend.position="none") +
  labs(tag = "e") +
  theme(
    plot.tag = element_text(size = 36, face = "bold", hjust = 0, vjust = 1),
    plot.tag.position = c(0.01, 0.99)
  )

cowplot::save_plot("fig1e.svg", p, base_height = 6, base_width = 8)