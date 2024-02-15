Fig1a_data <- readr::read_tsv("Fig1b_data.tsv", col_names = TRUE)
Fig1a_data_tidy <-
  tidyr::pivot_longer(Fig1a_data, `DIAMOND DeepClust (uni-directional coverage)`:`DIAMOND DeepClust`)
#Fig1a_data_tidy <- Fig1a_data
names(Fig1a_data_tidy)[2:3] <-
  c("Software", "Clustering Runtime (hours)")

####### Runtime in Days

Fig1a_days <-
  ggplot2::ggplot(
    Fig1a_data_tidy,
    ggplot2::aes(
      x = `Number of sequences (millions)` / 1000000,
      y = `Clustering Runtime (hours)`,
      colour = Software,
      label = Software
    )
  ) +
  ggplot2::geom_point(size = 7) +
  ggplot2::geom_point(alpha = 0.7) +
  ggplot2::geom_smooth(data = subset(Fig1a_data_tidy, Software %in% c('DIAMOND DeepClust', 'DIAMOND DeepClust (linear mode)'), select = c(`Number of sequences (millions)`, Software, `Clustering Runtime (hours)`)),
    method = "loess",
    alpha = 0,
    size = 1.6,
    span = 1
  ) +
  ggplot2::theme_bw()  +
  ggplot2::labs(x = "Number of sequences (millions)", y = "Clustering Runtime (hours)", title = "Scaling benchmark using NCBI NR Database \n (~550M seqs) (Zoom-in for <1 day)") +
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
  ggplot2::scale_color_manual(values = ggsci::pal_npg("nrc")(6)[c(3, 5, 6)]) +
  ggplot2::guides(colour=ggplot2::guide_legend(ncol=2,nrow=2,byrow=TRUE))



cowplot::save_plot("Fig1b.pdf",
                   Fig1a_days,
                   base_height = 8,
                   base_width = 10)
