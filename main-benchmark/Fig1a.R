# Import data for Fig 1a
Fig1a_data <- readr::read_tsv("Fig1a_data.tsv", col_names = TRUE)
Fig1a_data_tidy <-
  tidyr::pivot_longer(Fig1a_data, `MMseqs2`:FLSHclust)
names(Fig1a_data_tidy)[2:3] <-
  c("Software", "Clustering Runtime (hours)")

####### Runtime in Days

Fig1a_data_tidy_days <-
  dplyr::mutate(Fig1a_data_tidy, `Clustering Runtime (days)` = `Clustering Runtime (hours)` / 24)
Fig1a_days <-
  ggplot2::ggplot(
    Fig1a_data_tidy_days,
    ggplot2::aes(
      x = `Number of sequences (millions)` / 1000000,
      y = `Clustering Runtime (days)`,
      colour = Software,
      label = Software
    )
  ) +
  ggplot2::geom_point(size = 7) +
  ggplot2::geom_point(alpha = 0.7) +
  ggplot2::geom_smooth(
    method = "loess",
    alpha = 0,
    size = 1.6,
    span = 1
  ) +
  ggplot2::theme_bw()  +
  ggplot2::labs(x = "Number of sequences (millions)", y = "Clustering Runtime (days)", title = "Scaling benchmark using NCBI NR Database \n (~550M seqs)") +
  ggplot2::theme(
    title            = ggplot2::element_text(size = 18, face = "bold"),
    legend.title     = ggplot2::element_text(size = 18, face = "bold"),
    legend.text      = ggplot2::element_text(size = 18, face = "bold"),
	legend.position = "bottom",
    axis.title       = ggplot2::element_text(size = 18, face = "bold"),
    axis.text.y      = ggplot2::element_text(size = 18, face = "bold"),
    axis.text.x      = ggplot2::element_text(size = 18, face = "bold"),
    panel.background = ggplot2::element_blank(),
    strip.text.x     = ggplot2::element_text(
      size           = 18,
      colour         = "black",
      face           = "bold"
    )
  ) + ggplot2::theme(axis.text.x = ggplot2::element_text(
    angle = 90,
    vjust = 1,
    hjust = 1
  ))  +  ggplot2::ylim(1, 33) +
  ggplot2::scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) +
  ggplot2::scale_y_continuous(breaks = scales::pretty_breaks(n = 20)) +
  ggplot2::scale_color_manual(values = ggsci::pal_npg("nrc")(4)[c(3, 1, 4, 2)]) +
  ggrepel::geom_text_repel(
   data = subset(Fig1a_data_tidy_days, `Number of sequences (millions)` > 250000000, select = c(`Number of sequences (millions)`, Software, `Clustering Runtime (days)`)),
    ggplot2::aes(
      x = `Number of sequences (millions)` / 1000000,
      y = `Clustering Runtime (days)`,
      label = round(`Clustering Runtime (days)`, 1)
    ),
    nudge_x = .15,
    box.padding = 0.5,
    nudge_y = 1.5,
    segment.curvature = -0.1,
    segment.ncp = 3,
    segment.angle = 20,
    size = 5
  ) + ggplot2::guides(colour=ggplot2::guide_legend(ncol=2,nrow=2,byrow=TRUE)) +
  ggplot2::labs(tag = "a") +
  ggplot2::theme(
    plot.tag = ggplot2::element_text(size = 36, face = "bold", hjust = 0, vjust = 1),
    plot.tag.position = c(0.01, 0.99)  # top-left, slightly inset
  )

cowplot::save_plot("Fig1a.svg",
                   Fig1a_days,
                   base_height = 8,
                   base_width = 10)