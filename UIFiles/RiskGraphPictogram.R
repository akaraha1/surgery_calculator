library(png)
library(ggplot2)
library(grid)
library(reshape2)

fill_images <- function() {
  withProgress(message = 'Building The Graphs', value = 0, {

    l <- list()
    for (i in 1:nrow(newDF))
    {
      for (j in 1:dfMaster[1,'MajorComplications'])#ceiling(newDF$units[i]))
      {
        
       print(paste0(i, "-", newDF$what[i], "-", j))
        
        incProgress(i/nrow(newDF))
       # img <- readPNG("www/Heart_symbol_c00.png")
        
        if(newDF$what[i]=="Baseline Risk" && j <= floor(expMajorRisk(CalcBaselineRisk())) )  #newDF$units[i]))
          #Calculate the pt's baseline risk and then fill the graph
          #with green hearts up to that level of risk
          img <- readPNG("www/green-heart-md.png")
        # else if(i == nrow(newDF)) {
        #   print("in here")
        #   img <- readPNG("www/1x1.png")
        # }
        else if(j <= ceiling(expMajorRisk(CalcBaselineRisk())))  #newDF$units[i]))
          img <- readPNG("www/green-heart-md.png")
        else if(newDF$what[i]!="Baseline Risk" && j >= ceiling(expMajorRisk(CalcBaselineRisk()))) {
          img <- readPNG("www/Heart_symbol_c00.png")
        print("in here")
          }
                  else
          img <- readPNG("www/1x1.png")
        
        g <- rasterGrob(img, interpolate=TRUE)
        l <- c(l, annotation_custom(g, xmin = i-1/2, xmax = i+1/2, ymin = j-1, ymax = j))
      }
    }
  })
  l
}

clip_images <- function(restore_grid = TRUE)
{
  l <- list()
  for (i in 1:nrow(newDF)) {
    l <- c(l, geom_rect(xmin = i-1/2,
                        xmax = i+1/2,
                        ymin = newDF$units[i],
                        ymax = ceiling(newDF$units[i]),
                        colour = "transparent",
                        fill = "white"))
    if (restore_grid && ceiling(newDF$units[i]) %in% major_grid)
      l <- c(l, geom_segment(x = i-1,
                             xend = i+1,
                             y = ceiling(newDF$units[i]),
                             yend = ceiling(newDF$units[i]),
                             colour = grid_col,
                             size = grid_size))
  }
  l
}

grid_col <- "grey50"
grid_size <- 0.6
major_grid <- 0:10 * 2
# 
# newRiskDF <- data.frame(
#   units = c(),
#   what = c())
# 
# print("------")
# 
# for(i in 1:ncol(newDF)) {
#   if(newDF$what != "Current Risk" || newDF$what != "Baseline Risk") {
#     newRiskDF <- rbind(newRiskDF, data.frame(
#       units = c(dfMaster[1,'MajorComplications']-13.6),
#       what = c(colnames(newDF)[i])
#     ))
#   }
# }
# 
# print(newRiskDF)
# 
# 
# df.mrg <- merge(newDF,newRiskDF)
# gg.df  <- melt(df.mrg, id="what", variable.name="what", value.name="units")
# 
# print(gg.df)

pp1 <<- ggplot(newDF,aes(what, units)) +
  geom_bar(stat="identity",position = "identity", alpha=.3) +
  #geom_bar(fill=NA, colour="transparent", size=1.2, alpha=0.5, stat="identity") +
  fill_images() + clip_images() +
    theme_bw() +
    theme(axis.title.x  = element_blank(),
          axis.title.y  = element_blank(),
          panel.grid.major.x = element_blank(),
          panel.grid.major.y = element_blank()) +
  scale_x_discrete() +
  scale_y_discrete()
pp1
# +
#   scale_fill_manual("legend", values = c("Steroid" = "black", "Baseline Risk" = "orange", "Current Risk" = "blue"))









# 
# p <- ggplot(newDF, aes(what, units)) +
#   fill_images() +
#   clip_images() +
#   geom_bar(fill=NA, colour="transparent", size=1.2, alpha=0.5, stat="identity") +
#   coord_flip() +
#   scale_y_continuous(breaks=seq(0, 20, 2)) +
#   scale_x_discrete() +
#   theme_bw() +
#   theme(axis.title.x  = element_blank(), axis.title.y  = element_blank(),
#         panel.grid.major.x = element_line(colour = grid_col, size = grid_size),
#         panel.grid.major.y = element_line(colour = NA))
# p