---
title: "Homework 8"
author: "Ruolin Huang"
date: "2026-02-04"
output:
  html_document: 
    theme: spacelab
    keep_md: yes
---

## Instructions
Answer the following questions and/or complete the exercises in RMarkdown. Please embed all of your code and push the final work to your repository. Your report should be organized, clean, and run free from errors. Remember, you must remove the `#` for any included code chunks to run.  

## Load the libraries

``` r
library("tidyverse")
library("janitor")
#library("naniar")
options(scipen = 999)
```

## About the Data
For this assignment we are going to work with a data set from the [United Nations Food and Agriculture Organization](https://www.fao.org/fishery/en/collection/capture) on world fisheries. These data were downloaded and cleaned using the `fisheries_clean.Rmd` script.  

Load the data `fisheries_clean.csv` as a new object titled `fisheries_clean`.

``` r
fisheries_clean <- read_csv("data/fisheries_clean.csv")
```

1. Explore the data. What are the names of the variables, what are the dimensions, are there any NA's, what are the classes of the variables, etc.? You may use the functions that you prefer.

``` r
names(fisheries_clean)
```

```
## [1] "period"          "continent"       "geo_region"      "country"        
## [5] "scientific_name" "common_name"     "taxonomic_code"  "catch"          
## [9] "status"
```


``` r
glimpse(fisheries_clean)
```

```
## Rows: 1,055,015
## Columns: 9
## $ period          <dbl> 1950, 1951, 1952, 1953, 1954, 1955, 1956, 1957, 1958, …
## $ continent       <chr> "Asia", "Asia", "Asia", "Asia", "Asia", "Asia", "Asia"…
## $ geo_region      <chr> "Southern Asia", "Southern Asia", "Southern Asia", "So…
## $ country         <chr> "Afghanistan", "Afghanistan", "Afghanistan", "Afghanis…
## $ scientific_name <chr> "Osteichthyes", "Osteichthyes", "Osteichthyes", "Ostei…
## $ common_name     <chr> "Freshwater fishes NEI", "Freshwater fishes NEI", "Fre…
## $ taxonomic_code  <chr> "1990XXXXXXXX106", "1990XXXXXXXX106", "1990XXXXXXXX106…
## $ catch           <dbl> 100, 100, 100, 100, 100, 200, 200, 200, 200, 200, 200,…
## $ status          <chr> "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A",…
```

``` r
summary(fisheries_clean)
```

```
##      period      continent          geo_region          country         
##  Min.   :1950   Length:1055015     Length:1055015     Length:1055015    
##  1st Qu.:1980   Class :character   Class :character   Class :character  
##  Median :1996   Mode  :character   Mode  :character   Mode  :character  
##  Mean   :1994                                                           
##  3rd Qu.:2010                                                           
##  Max.   :2023                                                           
##  scientific_name    common_name        taxonomic_code         catch           
##  Length:1055015     Length:1055015     Length:1055015     Min.   :       0.0  
##  Class :character   Class :character   Class :character   1st Qu.:       0.0  
##  Mode  :character   Mode  :character   Mode  :character   Median :       2.9  
##                                                           Mean   :    5089.9  
##                                                           3rd Qu.:     400.0  
##                                                           Max.   :12277000.0  
##     status         
##  Length:1055015    
##  Class :character  
##  Mode  :character  
##                    
##                    
## 
```

2. Convert the following variables to factors: `period`, `continent`, `geo_region`, `country`, `scientific_name`, `common_name`, `taxonomic_code`, and `status`.

``` r
fisheries_clean <- fisheries_clean %>% 
  mutate(across(c(period, continent, geo_region, country, scientific_name, common_name, taxonomic_code, status), as.factor))
```

##3. Are there any missing values in the data? If so, which variables contain missing values and how many are missing for each variable?


4. How many countries are represented in the data?

``` r
fisheries_clean %>% 
  summarize(n_country=n_distinct(country))
```

```
## # A tibble: 1 × 1
##   n_country
##       <int>
## 1       249
```

5. The variables `common_name` and `taxonomic_code` both refer to species. How many unique species are represented in the data based on each of these variables? Are the numbers the same or different?

``` r
fisheries_clean %>% 
  summarize(n_distinct(common_name), n_distinct(scientific_name))
```

```
## # A tibble: 1 × 2
##   `n_distinct(common_name)` `n_distinct(scientific_name)`
##                       <int>                         <int>
## 1                      3390                          3710
```

6. In 2023, what were the top five countries that had the highest overall catch?


``` r
fisheries_clean %>% 
  filter(period=="2023") %>% 
  group_by(country) %>% 
  summarise(catch_total=sum(catch)) %>% 
  arrange(desc(catch_total), n=5)
```

```
## # A tibble: 238 × 2
##    country                  catch_total
##    <fct>                          <dbl>
##  1 China                      13424705.
##  2 Indonesia                   7820833.
##  3 India                       6177985.
##  4 Russian Federation          5398032 
##  5 United States of America    4623694 
##  6 Peru                        3519381.
##  7 Viet Nam                    3417238.
##  8 Japan                       2904942.
##  9 Chile                       2596488.
## 10 Norway                      2546846.
## # ℹ 228 more rows
```


7. In 2023, what were the top 10 most caught species? To keep things simple, assume `common_name` is sufficient to identify species. What does `NEI` stand for in some of the common names? How might this be concerning from a fisheries management perspective?

``` r
fisheries_clean %>% 
  filter(period=="2023") %>% 
  group_by(common_name) %>% 
  summarise(total_catch=sum(catch),
            .groups = "keep") %>% 
  arrange(desc(total_catch))
```

```
## # A tibble: 2,870 × 2
## # Groups:   common_name [2,870]
##    common_name                    total_catch
##    <fct>                                <dbl>
##  1 Marine fishes NEI                 8553907.
##  2 Freshwater fishes NEI             5880104.
##  3 Alaska pollock(=Walleye poll.)    3543411.
##  4 Skipjack tuna                     2954736.
##  5 Anchoveta(=Peruvian anchovy)      2415709.
##  6 Blue whiting(=Poutassou)          1739484.
##  7 Pacific sardine                   1678237.
##  8 Yellowfin tuna                    1601369.
##  9 Atlantic herring                  1432807.
## 10 Scads NEI                         1344190.
## # ℹ 2,860 more rows
```
NEI stands for Not Elsewhere Included. Species with NEI are in danger.

8. For the species that was caught the most above (not NEI), which country had the highest catch in 2023?

``` r
fisheries_clean %>% 
  filter(period=="2023" & common_name=="Alaska pollock(=Walleye poll.)") %>% 
  group_by(country) %>% 
  summarise(total_catch=sum(catch),
            .groups = "keep") %>% 
  arrange(desc(total_catch))
```

```
## # A tibble: 6 × 2
## # Groups:   country [6]
##   country                               total_catch
##   <fct>                                       <dbl>
## 1 Russian Federation                       1893924 
## 2 United States of America                 1433538 
## 3 Japan                                     122900 
## 4 Democratic People's Republic of Korea      58730 
## 5 Republic of Korea                          28432.
## 6 Canada                                      5887.
```


9. How has fishing of this species changed over the last decade (2013-2023)? Create a  plot showing total catch by year for this species.

``` r
fisheries_clean %>% 
  filter(period %in% 2013:2023 & common_name=="Alaska pollock(=Walleye poll.)") %>% 
  group_by(period) %>% 
  summarize(total_catch=sum(catch)) %>% 
  ggplot(mapping=aes(x=period, y=total_catch))+
  geom_col(mapping=aes(fill=period))+
  labs(title="total catch by year for Alaska pollock(=Walleye poll.)", x="year", y="total catch")
```

![](hw8_files/figure-html/unnamed-chunk-13-1.png)<!-- -->



10. Perform one exploratory analysis of your choice. Make sure to clearly state the question you are asking before writing any code.
Question: which geo_region had the lowest catch in 2020?

``` r
fisheries_clean %>% 
  filter(period=="2020" & !geo_region=="NA") %>% 
  group_by(geo_region) %>% 
  summarise(total_catch=sum(catch)) %>% 
  arrange(total_catch)
```

```
## # A tibble: 22 × 2
##    geo_region                total_catch
##    <fct>                           <dbl>
##  1 Polynesia                      38494.
##  2 Central Asia                  105132.
##  3 Caribbean                     128112.
##  4 Melanesia                     369245.
##  5 Australia and New Zealand     570843.
##  6 Micronesia                    587924.
##  7 Southern Africa               990374.
##  8 Western Europe               1031394.
##  9 Middle Africa                1081034.
## 10 Southern Europe              1256738.
## # ℹ 12 more rows
```
Polynesia had the lowest catch in 2020.


## Knit and Upload
Please knit your work as an .html file and upload to Canvas. Homework is due before the start of the next lab. No late work is accepted. Make sure to use the formatting conventions of RMarkdown to make your report neat and clean!  
