library(ggplot2)
library(patchwork)

args = commandArgs(trailingOnly=TRUE)

make_plot <- function(type) {
label <- ifelse(type == "prec", "Precision", ifelse(type == "sens", "Sensitivity", "Clan-level sensitivity"))
Fig1b_data <-
  list(
    `DIAMOND DeepClust` = as.double(readr::read_lines(paste("diamond", type, "gz", sep='.'))),
    `FLSHclust` = as.double(readr::read_lines(paste("flshclust",type,"gz", sep='.'))),
    `MMseqs2` = as.double(readr::read_lines(paste("mmseqs",type,"gz",sep='.'))),
    `DIAMOND DeepClust (uni-directional coverage)` = as.double(readr::read_lines(paste("diamond-uni",type,"gz", sep='.'))),
	`MMseqs2/Linclust` = as.double(readr::read_lines(paste("linclust",type,"gz",sep='.'))),
	`DIAMOND DeepClust (linear mode)` = as.double(readr::read_lines(paste("diamond-lin",type,"gz", sep='.')))
  )

lapply(Fig1b_data, length)

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
  "MMseqs2",
  "DIAMOND DeepClust (linear mode)",
  "FLSHclust",
  "MMseqs2/Linclust",
  "DIAMOND DeepClust (uni-directional coverage)"
)))

plt <- ggplot(
      Fig1b_data_tibble_tidy,
      aes(
        x = factor(
          Software
        ),
        y = Distribution,
        colour = Software
      )
    ) +
    geom_boxplot(size = 2, outlier.shape = NA) +
    theme_bw()  +
    labs(x = "Software", y = label, title = paste(label, "(NR database)",sep=' ')) +
    theme(
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
    scale_y_continuous(breaks = scales::pretty_breaks(n = 20)) +
    scale_color_manual(values = ggsci::pal_npg("nrc")(6)[c(3, 4, 5, 1, 6, 2)]) +
    scale_fill_manual(values = ggsci::pal_npg("nrc")(6)[c(3, 4, 5, 1, 6, 2)]) +
	guides(colour=ggplot2::guide_legend(ncol=2,nrow=3,byrow=TRUE))	
		
	if(type == "sens") {
		plt <- plt + ggplot2::labs(tag = "c") +
		ggplot2::stat_summary(fun=mean, geom="text", ggplot2::aes(label=round(..y.., digits=3)), vjust=0.3, hjust = -0.4, color="black", size=5) +
		stat_summary(
		fun.y = mean,
		geom = "point",
		shape = 20,
		size = 14,
		color = "black",
		fill = "black"
		) +
		geom_violin(alpha = 0.3, size = 1.5, scale = "width") +
		ggplot2::theme(plot.tag = ggplot2::element_text(size = 36, face = "bold", hjust = 0, vjust = 1),
		plot.tag.position = c(0.01, 0.99))
	}
	
	if(type == "sens_clan") {
		plt <- plt + ggplot2::labs(tag = "d") +
		ggplot2::theme(plot.tag = ggplot2::element_text(size = 36, face = "bold", hjust = 0, vjust = 1),
		plot.tag.position = c(0.01, 0.99))
	}
	
return(plt)
}

filename <- paste("Fig1c.svg")
combined <- (make_plot("sens") + theme(legend.position="bottom")) | (make_plot("prec") + theme(legend.position="bottom"))
combined <- combined + plot_layout(guides = "collect") & theme(legend.position = 'bottom')
cowplot::save_plot(filename, combined, base_height = 8, base_width = 16)

cowplot::save_plot("Fig1d.svg", make_plot("sens_clan") + theme(legend.position="none"), base_height = 6, base_width = 8)