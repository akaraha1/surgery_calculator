df <- data.frame(
  riskType=c(
    "Total Risk           ",
    "Steroid Risk + Baseline",
    "CHF Risk + Baseline",
    "Shortness of Breath + Baseline",
    "COPD + Baseline",
    "Smoking + Baseline",
    "Diabetes + Baseline",
    "Hypertension + Baseline",
    #BMI
    "Baseline Risk           "),
  start=c(
    dfMaster[1,'MajorComplications'],
    dfRiskChanges[,'Steroid'] + expMajorRisk(CalcBaselineRisk()),
    dfRiskChanges[,'HxCHF'] + expMajorRisk(CalcBaselineRisk()),
    dfRiskChanges[,'SOB'] + expMajorRisk(CalcBaselineRisk()),
    dfRiskChanges[,'HxCOPD'] + expMajorRisk(CalcBaselineRisk()),
    dfRiskChanges[,'Smoker'] + expMajorRisk(CalcBaselineRisk()),
    dfRiskChanges[,'DMAll'] + expMajorRisk(CalcBaselineRisk()),
    dfRiskChanges[,'HTNMed'] + expMajorRisk(CalcBaselineRisk()),
   # dfRiskChanges[,'BMI']*-1+expMajorRisk(CalcBaselineRisk()),
   expMajorRisk(CalcBaselineRisk())),
  color = c("green", "black", "purple", "green", "red", "yellow", "purple", "red", "green"),
  
  end = expMajorRisk(CalcBaselineRisk()))#c(0, expMajorRisk(CalcBaselineRisk()), 0, 0, 0, 0, 0, 0, 0))


df <- df[!(df$start == -1+expMajorRisk(CalcBaselineRisk())),]


circle <- function(center,radius) {
  th <- seq(0,2*pi,len=200)
  data.frame(x=center[1]+radius*cos(th),y=center[2]+radius*sin(th))
}

max <- max(df$start)
n.bubbles <- nrow(df)
scale <- 0.4/sum(sqrt(df$start))

# calculate scaled centers and radii of bubbles
radii <- scale*sqrt(df$start)
ctr.x <- cumsum(c(radii[1],head(radii,-1)+tail(radii,-1)+.01))

# starting (larger) bubbles
gg.1  <- do.call(rbind,lapply(1:n.bubbles,function(i)cbind(group=i,circle(c(ctr.x[i],radii[i]),radii[i]))))

text.1 <- data.frame()

trim.trailing <- function (x) sub("\\s+$", "", x) #create the function


if(nrow(df) >= 7) {
  textSize <- 3
  text.1 <- data.frame(x = ctr.x,
                       y = -0.05,
                       label = gsub('.{11}$', '', df$riskType))
} else if(nrow(df) >= 4) {
  textSize <- 5
  text.1 <- data.frame(x = ctr.x,
                       y = -0.05,
                       label = gsub('.{11}$', '', df$riskType))
  
  
} else {
  textSize <- 5
  print(df[1,1])
  # df[1,1] <- "Total Risk"
  df$riskType <- trim.trailing(df$riskType)
  print(df[1,1])
  
  text.1 <- data.frame(x = ctr.x,
                       y = -0.05,
                       label = paste(df$riskType,
                                     formatC(df$start, digits = 1, format = "f"), "%"),
                       sep="\n")
  
}

# col_list<-c("#FF222C", "#1DFBFF", "#FDFF24", "#2CFF18", "#FF38F4", "#C3C4C9", "#000000")
# col_list5<-c("#FF222C", "#1DFBFF", "#FDFF24", "#2CFF18", "#FF38F4")


# ending (smaller) bubbles
radii <- scale*sqrt(df$end)
gg.2  <- do.call(rbind,lapply(1:n.bubbles,function(i)cbind(group=i,circle(c(ctr.x[i],radii[i]),radii[i]))))
text.2 <- data.frame(x=ctr.x, y=2*radii+0.02, label= "")#paste0("Baseline ",formatC(df$end, digits = 1, format = "f"), "%"))
color <- df$color

# risk1 <- paste0(formatC(dfMaster[1,'MajorComplications'], digits = 1, format = "f"), "% vs. ",
#                 formatC(expMajorRisk(CalcBaselineRisk()), digits = 1, format = "f"), "%")

# make the plot
p2 <- ggplot() +
  geom_polygon(data = gg.1,
               aes(x,y,group = group, fill = factor(color)),
               fill = "#005eb8") +
  geom_path(data = gg.1,aes(x, y, group = group), color = "grey50") +
  
  # geom_text(data = text.1,aes(x, y, label = risk1)) +
  # geom_polygon(data = gg.2,aes(x, y, group=group),fill = "green2") +
  # geom_path(data = gg.2,aes(x, y, group=group),color="grey50") +
  # geom_text(data = text.2,aes(x, y, label = "Your Current Risk"), color="white") +
  
  
  geom_text(data=text.1, aes(x, y, label = label), size = textSize) +
  geom_polygon(data=gg.2, aes(x, y, group = group), fill="#FFCD00") +
  geom_path(data=gg.2, aes(x, y, group = group), color = "grey50") +
  geom_text(data=text.2, aes(x, y, label = label), color = "black") +
  
  
  labs(x = "", y = "") +
  scale_y_continuous(limits = c(-0.1, 2.5*scale*sqrt(max(df$start)))) +
  coord_fixed() +
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank()
  )
p2


# library(egg)
# ggarrange(p2, ncol = 1,  widths = c(22))



# cat<-c("A", "A", "B", "B", "C", "C")
# chara<-c("1", "0", "1", "0", "1", "0")
# percent<-c(80, 20, 60, 40, 90,10)
# xcoord<-c(10,10,11,11,12,12)
# ycoord<-c(10,10,10,10,10,10)


# cat<-c("A", "B", "C")
# chara<-c("1", "1", "1")
# percent<-c(30, 25, 6)
# xcoord<-c(10,11,12)
# ycoord<-c(10,10,10)
# label<-c("aa", "bbb", "ccc")
# 
# DF<-data.frame(cat,chara, percent, xcoord, ycoord, label)
# print(DF)
# 
# NewBubbleChart <- ggplot(DF, aes(x = cat, y = "", size = percent, label = label, fill = chara),
#                          legend = FALSE) +
#   geom_point(color = "grey50", shape = 21, alpha = 0.99) +  
#   #geom_text(size=4) +
#   theme_bw() +
#   scale_size(range = c(0, 75))
# 
# NewBubbleChart <- NewBubbleChart +
#   scale_fill_manual(name = "Type",
#                     values = c("darkblue", "lightblue"),
#                     labels = NULL)
# 
# NewBubbleChart
