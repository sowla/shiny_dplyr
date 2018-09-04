library(tibble)
library(DT)
library(glue)
library(purrr)
library(dplyr)
library(wired)  # https://github.com/dreamRs/wired
library(shiny)
library(shinythemes)
library(dragulaR)


my_mtcars <- 
  tibble::rownames_to_column(mtcars, "model") %>% 
  as_tibble()

source("M_verb_box.R")

ui <- fluidPage(
  
  titlePanel("shiny dplyr"),
  theme = shinytheme("flatly"),
  
  fluidRow(
    
    column(3,  # if use wired, will have to change to splitcells
      h4("Where UI will get added:"),
      div(id = "Available", style = "min-height: 1000px;",
        map(1:3, function(x, df) action_box_UI(id = x, df = my_mtcars))
      )
    ),
    column(3,
      h4("Build dplyr pipeline:"),
      div(id = "Picked", style = "min-height: 1000px;")
    ),
    column(6,
      tabsetPanel(
        id = "display",
        tabPanel(
          title = "data",
          textOutput("print"),
          DTOutput("data")
        ) 
      )
    )
  ),
  dragulaOutput("dragula")
  
)

server <- function(input, output) {
  
  output$dragula <- renderDragula({
    dragula(c("Available", "Picked"))
  })
  
  action_string <- list()
  action_string[[1]] <- reactive({ callModule(action_box, 1) })
  action_string[[2]] <- reactive({ callModule(action_box, 2) })
  action_string[[3]] <- reactive({ callModule(action_box, 3) })
  
  output$data <- renderDT({
    req(input$dragula)
    state <- dragulaValue(input$dragula)
    validate(need(state$Picked, message = "Please select at least one function."))
    
    df <- my_mtcars
    
    for (i in 1:length(state$Picked)) {
      
      pos <- state$Picked[i] %>% as.numeric()
      
      df <-
        action_string[[pos]]() %>%
        c("df", .) %>%
        glue_collapse(" %>% ") %>%
        parse(text = .) %>%
        eval()
    }
    
    datatable(df)
    
  })
  
  output$print <- renderPrint({
    state <- dragulaValue(input$dragula)
    print(state$Picked)
  })
  
}

shinyApp(ui = ui, server = server)
