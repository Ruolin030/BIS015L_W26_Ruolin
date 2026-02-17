library(lme4) ## for generalised linear mixed models - glmer command
library(DHARMa) ## to check residuals/model fit (simulateResiduals)
library(pbkrtest) ## for paremetric  bootstrapping (PBmodcomp)
library(emmeans) ## for posthoc tests (emmeans)
library(ggplot2) ## for creating plots
library(reshape2) ## for melting data

## amount of BTF calling

## load CSV
BTF_events <- read.csv(file.choose()) ##1175 observations
## removes NA's
BTF_events <-BTF_events[complete.cases(BTF_events),] ##1174 observations

## add durations to create a single measurement per location per day
BTF_summs <- aggregate(data = BTF_events, duration ~ trial+treatment+location, FUN = sum) #59 observations
## add 1 sec to measurements to ensure values are positive (required for Gamma GLMM)
BTF_summs$duration_1 <- BTF_summs$duration+1

## run Gamma GLMM
BTF_glm = glmer(duration_1~treatment+(1|location),
                family=Gamma(link="log"), nAGQ=0, data=BTF_summs)

## check residuals
plot(BTF_glm)
qqnorm(resid(BTF_glm))
qqline(resid(BTF_glm))
plot( simulateResiduals(BTF_glm, 1000))

## summary of model
summary(BTF_glm)

## create null model without treatment
minus.treatment = glmer(duration_1~1+(1|location),
                        family=Gamma(link="log"), nAGQ=0, data=BTF_summs)
## run parametric bootstrapping on full and null models
bootstrap<-PBmodcomp(BTF_glm, minus.treatment, nsim = 1000, ref = NULL, seed = NULL,cl = NULL, details = 0) 
## view results of parametric bootstrapping
summary(bootstrap) 

## run posthoc tests
BTF_posthoc <- emmeans(BTF_glm, ~treatment)
BTF_posthoc <- as.data.frame (pairs(BTF_posthoc, adjust="none"))
## view results
BTF_posthoc

## add fitted values from model into data frame
BTF_summs$fitted <- fitted(BTF_glm)

## create colourblind-friendly palette
cbp1 <- c("#B3B3B3","#66C2A5", "#FC8D62","#E78AC3", "#A6D854", "#FFD92F")
# create shapes
jshapes <- c(19,18,15,17)

## create scatterplot of raw and model-fitted values
ggplot(BTF_summs, aes(x=location, y=fitted, color=treatment, shape=treatment)) +
  geom_point(size=4, )+
  geom_point(aes(x=location, y=duration_1),position=position_jitterdodge())+
  geom_line(aes(group=treatment))+
  scale_colour_manual(values=cbp1)+
  scale_shape_manual(values=jshapes)+
  theme_bw(base_size=12)+
  theme(text = element_text(color="black", size=12),
        axis.text.y = element_text(color="black",size=10),
        axis.text.x = element_text(color="black",size=10))+
  theme(panel.background = element_rect(fill="white"))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  theme(legend.title = element_blank())+
  theme(legend.key = element_rect(fill = "white"))+
  theme(legend.background = element_rect(fill="white", color="black"))+
  theme(legend.text=element_text(size=10))


## spectral measurements

calls <- read.csv(file.choose()) ## 497 observations

## generate means and standard deviations of call measurements
BTF_summs <- aggregate(data = calls, dom_fr ~ species, FUN = mean)
BTF_min_fr <- aggregate(data = calls, min_fr ~ species, FUN = mean)
BTF_max_fr <- aggregate(data = calls, max_fr ~ species, FUN = mean)
BTF_min_TM <- aggregate(data = calls, min_fr_TM ~ species, FUN = mean)
BTF_summs$min_fr <- BTF_min_fr$min_fr
BTF_summs$max_fr <- BTF_max_fr$max_fr
BTF_summs$min_TM <- BTF_min_TM$min_fr_TM
BTF_summs_melt <- melt(BTF_summs, ID="species")
names(BTF_summs_melt)[names(BTF_summs_melt) == "variable"] <- "call_property"
names(BTF_summs_melt)[names(BTF_summs_melt) == "value"] <- "mean"

BTF_sd <- aggregate(data = calls, dom_fr ~ species, FUN = sd)
BTF_min_fr <- aggregate(data = calls, min_fr ~ species, FUN = sd)
BTF_max_fr <- aggregate(data = calls, max_fr ~ species, FUN = sd)
BTF_min_TM <- aggregate(data = calls, min_fr_TM ~ species, FUN = sd)
BTF_sd$dom_fr <- BTF_dom_fr$dom_fr
BTF_sd$min_fr <- BTF_min_fr$min_fr
BTF_sd$max_fr <- BTF_max_fr$max_fr
BTF_sd$min_TM <- BTF_min_TM$min_fr_TM
BTF_SD_melt <- melt(BTF_sd, ID="species")
names(BTF_SD_melt)[names(BTF_SD_melt) == "variable"] <- "call_property"
names(BTF_SD_melt)[names(BTF_SD_melt) == "value"] <- "SD"

## melt means and standard deviations together
BTF_summs_melt$SD <- BTF_SD_melt$SD
BTF_summs_melt <- melt(BTF_summs_melt, ID="species")
BTF_summs_dcast <- dcast(BTF_summs_melt, species~call_property+variable)

## relevel species
BTF_summs_dcast$species<-relevel(BTF_summs_dcast$species, ref="pink")
BTF_summs_dcast$species<-relevel(BTF_summs_dcast$species, ref="myna")
BTF_summs_dcast$species<-relevel(BTF_summs_dcast$species, ref="mannikin")
BTF_summs_dcast$species<-relevel(BTF_summs_dcast$species, ref="BTF")

## create plot to examine spectral overlap
ggplot(data=BTF_summs_dcast, aes(x=species, y=dom_fr_mean))+
  geom_point(size=4, shape=19)+
  geom_point(size=2, shape=15, aes(y=min_fr_mean))+
  geom_point(size=2, shape=17, aes(y=max_fr_mean))+
  geom_point(size=2, shape=0, aes(y=min_TM_mean))+
  geom_errorbar(aes(x=species, ymin=dom_fr_mean-dom_fr_SD, ymax=dom_fr_mean+dom_fr_SD),
                width=0.1) +
  geom_errorbar(aes(x=species, ymin=min_fr_mean-min_fr_SD, ymax=min_fr_mean+min_fr_SD),
                width=0.1) +
  geom_errorbar(aes(x=species, ymin=max_fr_mean-max_fr_SD, ymax=max_fr_mean+max_fr_SD),
                width=0.1) +
  geom_errorbar(aes(x=species, ymin=min_TM_mean-min_TM_SD, ymax=min_TM_mean+min_TM_SD),
                width=0.1) +
  theme_bw(base_size=12)+
  theme(text = element_text(color="black", size=12),
        axis.text.y = element_text(color="black",size=10),
        axis.text.x = element_text(color="black",size=10))+
  scale_y_continuous(name="Frequency (Hz)")+
  theme(panel.background = element_rect(fill="white"))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

