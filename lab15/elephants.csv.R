##load the libraries
library(tidyverse)
library(janitor)
library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  
  dashboardHeader(title="The Range of Age and Height by Sex"),
  
  dashboardSidebar(
    
    selectInput("y",
                "Select Variable",
                choices = c("age",
                            "height"),
                selected = "age")
  ),
  
  dashboardBody(
    
    plotOutput("plot", width = "500px", height = "400px")
    
  ),
  
)

server <- function(input, output, session) {
  
  output$plot <- renderPlot({
    
    elephants %>% 
      ggplot(aes(x=sex, 
                 y=.data[[input$y]],
                 fill=sex))+
      geom_boxplot(alpha=0.8, color="black")+
      theme_light()
    
  })
  
}

shinyApp(ui, server)
