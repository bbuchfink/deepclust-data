#### Figure 1B
args = commandArgs(trailingOnly=TRUE)
type <- args[1]
label <- ifelse(type == "prec", "Precision", "Sensitivity")
# import sensitivity distributions
Fig1b_data <-
  list(
    `DIAMOND DeepClust` = as.double(readr::read_lines(paste("diamond", type, "gz", sep='.'))),
    `FLSHclust` = as.double(readr::read_lines(paste("flshclust",type,"gz", sep='.'))),
    `MMseqs2` = as.double(readr::read_lines(paste("mmseqs",type,"gz",sep='.'))),
    `DIAMOND DeepClust (uni-directional coverage)` = as.double(readr::read_lines(paste("diamond-uni",type,"gz", sep='.'))),
	`MMseqs2/Linclust` = as.double(readr::read_lines(paste("mmseqs-linclust",type,"gz",sep='.'))),
	`DIAMOND DeepClust (linear mode)` = as.double(readr::read_lines(paste("diamond-linear",type,"gz", sep='.')))
  )

# look at differences in distribution sizes
lapply(Fig1b_data, length)

# DeepClust vs MMSeqs2: 149824975 - 149823344 = 1631 missing elements that need to be set to 0
# DeepClust vs FLSHClust: 149824975 - 149824832 = 143 missing elements that need to be set to 0

Fig1b_data_tibble <-
  tibble::tibble(
    `DIAMOND DeepClust` = Fig1b_data[[1]],
    `FLSHclust` = Fig1b_data[[2]],
    `MMseqs2` = Fig1b_data[[3]],
    `DIAMOND DeepClust (uni-directional coverage)` = Fig1b_data[[4]],
	`MMseqs2/Linclust` = Fig1b_data[[5]],
	`DIAMOND DeepClust (linear mode)` = Fig1b_data[[6]]
  )

Fig1b_data_tibble_tidy <- tidyr::pivot_longer(Fig1b_data_tibble, `DIAMOND DeepClust`:`DIAMOND DeepClust (linear mode)`)
names(Fig1b_data_tibble_tidy) <- c("Software", "Distribution")


Fig1b_data_tibble_tidy <- dplyr::mutate(Fig1b_data_tibble_tidy, Software = factor(Software, levels = c(
  "DIAMOND DeepClust",
  "DIAMOND DeepClust (linear mode)",
  "MMseqs2",
  "FLSHclust",
  "MMseqs2/Linclust",
  "DIAMOND DeepClust (uni-directional coverage)"
)))

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
      Fig1b_data_tibble_tidy,
      ggplot2::aes(
        x = factor(
          Software
        ),
        y = Distribution,
        colour = Software
      )
    ) +
    ggplot2::geom_boxplot(size = 2, outlier.shape = NA) +
    ggplot2::stat_summary(
      fun.y = mean,
      geom = "point",
      shape = 20,
      size = 14,
      color = "black",
      fill = "black"
    ) +
    ggplot2::geom_violin(alpha = 0.3, size = 1.5) +
    #ggplot2::geom_boxplot() +
    # ggplot2::geom_point(alpha = 0.7) +
    ggplot2::theme_bw()  +
    ggplot2::labs(x = "Software", y = label, title = paste(label, "(NR database)",sep=' ')) +
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
    
    ggplot2::scale_y_continuous(breaks = scales::pretty_breaks(n = 20)) +
    ggplot2::scale_color_manual(values = ggsci::pal_npg("nrc")(6)[c(3, 5, 4, 1, 6, 2)]) +
    ggplot2::scale_fill_manual(values = ggsci::pal_npg("nrc")(6)[c(3, 5, 4, 1, 6, 2)]) +
	ggplot2::guides(colour=ggplot2::guide_legend(ncol=2,nrow=3,byrow=TRUE))
    # ggplot2::scale_x_discrete(labels = table(dplyr::slice_sample(Fig1b_data_tibble_tidy, n = 1000)$Software))
  
  
filename <- paste("Fig1c",type,"pdf", sep='.')
cowplot::save_plot(filename, Fig1b_1, base_height = 8, base_width = 8)
