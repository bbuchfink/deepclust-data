library(ggplot2)

data <- read.csv(file = 'umap.tsv', sep='\t', header=FALSE)
data$V3 <- as.factor(data$V3)
#data <- dplyr::filter(data, V3 == 4)

ggplot(data, aes(x=V1, y=V2, color=V3)) + geom_point(size=0.05) +
#scale_color_manual(values=c("#000C7B","#58135E","#73FBFD","#FFFD55","#EA3FF7"),labels = c("None", "BFD+MGnify", "UniProt","Pfam","SCOP+ECOD+CATH"),name="Annotation") +
scale_color_manual(values=c("#000000","#88438E","#73FBFD","#FFFD55","#EA3FF7"),labels = c("None", "BFD+MGnify", "UniProt","Pfam","SCOP+ECOD+CATH"),name="Annotation") +
guides(colour = guide_legend(override.aes = list(size=20), title.theme = element_text(size=50), label.theme = element_text(size=50))) + xlab("")+ylab("") +
theme_bw() +
ylim(-3,14) + xlim(-3,17) + theme(axis.text=element_text(size=30))

ggsave('umap.png', device=png, width=10000, height=6000, units='cm', dpi=300, limitsize=FALSE)
#ggsave('umap4.png', device=png, width=5000, height=3000, units='px', dpi=300, limitsize=FALSE)
