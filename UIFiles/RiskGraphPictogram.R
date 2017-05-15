library(png)
library(ggplot2)
library(grid)

fill_images <- function() {
  withProgress(message = 'Building The Graphs', value = 0, {
    
  l <- list()
  for (i in 1:nrow(df3)) 
  {
    for (j in 1:ceiling(df3$units[i]))
    {
      incProgress(i/nrow(df3))
      img <- readPNG("Heart_symbol_c00.png")
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
  for (i in 1:nrow(df3)) 
  {
    l <- c(l, geom_rect(xmin = i-1/2, xmax = i+1/2, 
                        ymin = df3$units[i], ymax = ceiling(df3$units[i]),
                        colour = "white", fill = "white"))
    if (restore_grid && ceiling(df3$units[i]) %in% major_grid) 
      l <- c(l, geom_segment(x = i-1, xend = i+1,
                             y = ceiling(df3$units[i]), 
                             yend = ceiling(df3$units[i]),
                             colour = grid_col, size = grid_size))
  }
  l
}

grid_col <- "grey50"
grid_size <- 0.6
major_grid <- 0:10 * 2
p <- ggplot(df3, aes(what, units)) + 
  fill_images() + 
  clip_images() +
  geom_bar(fill=NA, colour="darkgreen", size=1.2, alpha=0.5, stat="identity") + 
  coord_flip() + 
  scale_y_continuous(breaks=seq(0, 20, 2)) + 
  scale_x_discrete() + 
  theme_bw() + 
  theme(axis.title.x  = element_blank(), axis.title.y  = element_blank(),
        panel.grid.major.x = element_line(colour = grid_col, size = grid_size), 
        panel.grid.major.y = element_line(colour = NA)) 
p