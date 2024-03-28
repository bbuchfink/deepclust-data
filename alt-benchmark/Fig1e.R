# Import data for Fig 1a
df <- data.frame()
names <- c("DIAMOND DeepClust", "MMseqs2", "DIAMOND DeepClust (linear mode)", "FLSHclust", "MMseqs2/Linclust", "DIAMOND DeepClust (uni-dir. coverage)")
i <- 1
for( tool in c("diamond", "mmseqs", "diamond-lin", "flshclust", "linclust", "diamond-uni")) {
	table = read.table(paste(tool,"tsv",sep='.'), header = F, sep = "\t", col.names = c("id", "frac"))
	table$Software <- names[i]
	table$Software <- factor(table$Software)
	df <- rbind(df, table)
	i <- i+1
}

#print(table)
  
####### Runtime in Days

Fig1a_days <-
  ggplot2::ggplot(
    df,
    ggplot2::aes(
      x = `id`,
      y = `frac`,
      colour = Software,
      label = Software
    )
  ) +
  ggplot2::geom_line(size = 1.4) +
  ggplot2::theme_bw()  +
  ggplot2::labs(x = "Sequence identity% to nearest neighbor", y = "Fraction of representative sequences", title = "Cumulative distance distribution between\nrepresentative sequences") +
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
  ggplot2::scale_color_manual(values = ggsci::pal_npg("nrc")(6)[c(3, 4, 5, 1, 6, 2)]) +
  ggplot2::guides(colour=ggplot2::guide_legend(ncol=2,nrow=3,byrow=TRUE))



cowplot::save_plot("Fig1d.pdf",
                   Fig1a_days,
                   base_height = 8,
                   base_width = 10)
