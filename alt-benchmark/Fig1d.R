#### Figure 1B

df <- data.frame()
names <- c("DIAMOND DeepClust", "MMseqs2", "d2")
i <- 1
for( tool in c("diamond", "mmseqs")) {
	table = read.table(paste(tool,"clust_cor.gz",sep='.'), header = F, sep = "\t", col.names = c("value"))
	table$Software <- names[i]
	table$Software <- factor(table$Software)
	df <- rbind(df, table)
	i <- i+1
}

# remotes::install_github('jorvlan/raincloudplots')

# install.packages(c("ggstatsplot", "rstantools"))

#   
#   Fig1b_1 <- ggstatsplot::ggbetweenstats(
#   #ggstatsplot::grouped_ggbetweenstats(
#   data             = dplyr::slice_sample(Fig1b_data_tibble_tidy, n = 1000),
#   #  data             = Fig1b_data_tibble_tidy,
#   x                = Software,
#   y                = Distribution,
#   # grouping.var     = Software,
#   colour = Software,
#   ggsignif.args    = list(textsize = 4, tip_length = 0.01),
#   p.adjust.method  = "bonferroni",
#   palette          = "default_jama",
#   package          = "ggsci",
#   point.args = list(alpha = 0),
#   plotgrid.args    = list(nrow = 1),
#   annotation.args  = list(title = "Sensitivity Benchmark \n (~150M seqs)") 
# ) 
      
    Fig1b_1 <- ggplot2::ggplot(
      df,
      ggplot2::aes(
        x = factor(
          Software
        ),
        y = value,
        colour = Software
      )
    ) +
    ggplot2::geom_boxplot(size = 2, outlier.shape=NA) +
    ggplot2::geom_violin(alpha = 0.3, size = 1.5) +
    #ggplot2::geom_boxplot() +
    # ggplot2::geom_point(alpha = 0.7) +
    ggplot2::theme_bw()  +
    ggplot2::labs(x = "Software", y = "Pfam correspondence", title = paste("Pfam correspondence over input sequences", "(NR database)",sep=' ')) +
    ggplot2::theme(
      title            = ggplot2::element_text(size = 18, face = "bold"),
      legend.title     = ggplot2::element_text(size = 18, face = "bold"),
      legend.text      = ggplot2::element_text(size = 18, face = "bold"),
	  legend.position  = "bottom",
      axis.title       = ggplot2::element_text(size = 18, face = "bold"),
      axis.text.y      = ggplot2::element_text(size = 18, face = "bold"),
	  axis.text.x      = ggplot2::element_blank(),
      panel.background = ggplot2::element_blank(),
      strip.text.x     = ggplot2::element_text(
        size           = 18,
        colour         = "black",
        face           = "bold"
      )
    ) +    
    ggplot2::scale_y_continuous() +
    ggplot2::scale_color_manual(values = ggsci::pal_npg("nrc")(6)[c(3, 4, 5, 1, 6, 2)]) +
    ggplot2::scale_fill_manual(values = ggsci::pal_npg("nrc")(6)[c(3, 4, 5, 1, 6, 2)]) +
	ggplot2::guides(colour=ggplot2::guide_legend(ncol=2,nrow=3,byrow=TRUE)) +
	ggplot2::stat_summary(fun=mean, geom="text", ggplot2::aes(label=round(..y.., digits=2)), vjust=0.3, hjust = -0.4, color="black", size=7) +
	ggplot2::stat_summary(
      fun.y = mean,
      geom = "point",
      shape = 20,
      size = 14,
      color = "black",
      fill = "black"
    )
    # ggplot2::scale_x_discrete(labels = table(dplyr::slice_sample(Fig1b_data_tibble_tidy, n = 1000)$Software))
  
  
filename <- paste("fig1d","pdf", sep='.')
cowplot::save_plot(filename, Fig1b_1, base_height = 8, base_width = 8)
