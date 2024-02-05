#### Figure 1C with DOTS
Fig1c_data <- readr::read_tsv("Suppl1_data.tsv", col_names = TRUE)
col_custom <- ggsci::pal_npg("nrc")(6)[c(2, 3, 1, 4, 5, 6)]
Fig1c_dots <- ggplot2::ggplot(
  Fig1c_data,
  ggplot2::aes(
    x = `Sensitivity`,
    y = `Run time (min)`,
    colour = Software,
    fill = Software,
    label = round(`Run time (min)`, 2)
  )
) +
  ggplot2::geom_point(size = 7) +
  ggplot2::geom_point(alpha = 0.7) +
  ggplot2::theme_bw()  +
  ggplot2::labs(x = "Clustering Sensitivity", y = "Run time (min)", title = "Small database benchmark \n (10M sequences)") +
  ggplot2::theme(
    title            = ggplot2::element_text(size = 18, face = "bold"),
    legend.title     = ggplot2::element_text(size = 18, face = "bold"),
    legend.text      = ggplot2::element_text(size = 18, face = "bold"),
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
  )) +
  ggplot2::scale_x_continuous(breaks = scales::pretty_breaks(n = 20)) +
  ggplot2::scale_y_continuous(breaks = scales::pretty_breaks(n = 20)) +
  ggrepel::geom_text_repel(nudge_x = .10,
                           box.padding = 0.5,
                           nudge_y = 1,
                           segment.curvature = -0.1,
                           segment.ncp = 3,
                           segment.angle = 10,
                           size = 7) +
  ggplot2::scale_color_manual(values = c("#c51b8a", col_custom[c(2,5)], col_custom[3], "#7E6148B2", col_custom[4], col_custom[6], "#67001f"))+
  ggplot2::scale_fill_manual(values = c("#c51b8a", col_custom[c(2,5)], col_custom[3], "#7E6148B2", col_custom[4], col_custom[6], "#67001f"))
  #ggplot2::geom_vline(xintercept = 0.651034,
                      #size = 1.3,
                      #alpha = 0.7,
                      #linetype="dotted") 


cowplot::save_plot("Supll1.pdf",
                   Fig1c_dots,
                   base_height = 8,
                   base_width = 12)


