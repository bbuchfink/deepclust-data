library(readr)
library(ggplot2)

df <- readr::read_tsv("data.tsv", col_names = TRUE)
df$`Wall-clock time (hours)` <- df$`Wall-clock time (seconds)` / 3600
df$label <- "observed"

df2 <- data.frame(
  `Compute nodes` = 1:32,
  `Wall-clock time (seconds)` = 54905/(1:32),
  `Wall-clock time (hours)` = 54905/3600/(1:32),
  `label` = "ideal",
  check.names = FALSE
)

df3 <- rbind(df, df2)
print(df3, n = Inf)
df3$label <- factor(df3$label, levels = c("observed", "ideal"))

Fig <- ggplot(data=df3, aes(x=`Compute nodes`, y=`Wall-clock time (hours)`, group=`label`)) +
  geom_line(aes(linetype=label, color=label)) +
  scale_linetype_manual(values = c("solid", "dotted"), labels = c("Observed runtime", "Ideal scaling")) +
  scale_color_manual(values = c("blue", "black"), labels = c("Observed runtime", "Ideal scaling")) +
  geom_point(data = subset(df3, label == "observed")) +
  scale_x_continuous(breaks=c(1, 2, 4, 8, 16, 32), limits=c(1,32), name="Number of compute nodes") +
  theme(text = element_text(size=16), legend.text = element_text(size=16), legend.title = element_blank(), axis.text.x = element_text(size=16), axis.text.y = element_text(size=16))
  #geom_text(
  #  label=round(df$`Wall-clock time (hours)`, 2), 
  #  nudge_x = 0.07, nudge_y = 0.25, 
  #  check_overlap = T
  #)
  
cowplot::save_plot("suppl1.svg",
                   Fig,
                   base_height = 8,
                   base_width = 10)