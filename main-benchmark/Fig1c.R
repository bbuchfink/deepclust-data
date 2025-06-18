#### Figure 1B
library(ggplot2)
#library(devEMF)

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
	`MMseqs2/Linclust` = as.double(readr::read_lines(paste("linclust",type,"gz",sep='.'))),
	`DIAMOND DeepClust (linear mode)` = as.double(readr::read_lines(paste("diamond-lin",type,"gz", sep='.')))
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
  "MMseqs2",
  "DIAMOND DeepClust (linear mode)",
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

#Fig1b_1 <- ggplot(Fig1b_data_tibble_tidy, aes(x=Distribution, fill=Software)) + geom_density(alpha=.3)

#Fig1b_1 <- ggplot(Fig1b_data_tibble_tidy, aes(x=Software, y=Distribution, fill=Software)) + ggdist::stat_halfeye()
      

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
    #ggplot2::geom_boxplot() +
    # ggplot2::geom_point(alpha = 0.7) +
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
    # ggplot2::scale_x_discrete(labels = table(dplyr::slice_sample(Fig1b_data_tibble_tidy, n = 1000)$Software))

filename <- paste("Fig1c",type,"svg", sep='.')
cowplot::save_plot(filename, plt, base_height = 8, base_width = 8)
#ggsave("plot.emf", width = 6, height = 4, device = {function(filename, ...) devEMF::emf(file = filename, ...)})

#ggsave(filename,    Fig1b_1, height = 8, width = 8,
       #device = {\(filename, ...) devEMF::emf(file = filename, ...)})
	  
#library(officer)
#doc_gg <- read_docx()
#doc_gg <- body_add_gg(x = doc_gg, value = plt, style = "centered")
#print(doc_gg, target = "fig1c.docx")

#doc <- read_pptx()
#doc <- add_slide(doc)
#doc <- ph_with(x = doc, value = plt, 
#               location = ph_location_fullsize() )
#doc <- ph_with(x = doc, "a ggplot example", 
#               location = ph_location_type(
#                 type = "title") )
#print(doc, target = "fig1c.pptx")