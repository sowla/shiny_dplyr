library(tibble)
library(glue)
library(purrr)
library(dplyr)
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
    
    column(3,
      h4("Drag from here:"),
      div(id = "Available", style = "min-height: 1000px;",
        map(1:3, function(x, df) verb_box_UI(id = x, df = my_mtcars))
      )
    ),
    column(3,
      h4("Drop here:"),
      div(id = "Picked", style = "min-height: 1000px;")
    ),
    column(6,
      textOutput("data"),
      verbatimTextOutput("print")
    )
  ),
  dragulaOutput("dragula")
  
)

server <- function(input, output) {
  
  output$dragula <- renderDragula({
    dragula(c("Available", "Picked"))
  })
  
  output$data <- renderPrint({
    req(input$dragula)
    state <- dragulaValue(input$dragula)
    validate(need(state$Picked, message = "Please select at least one function."))
      
      orig_df <- my_mtcars
      
      for (i in 1:length(state$Picked)) {
        pos <- reactive({state$Picked[i]})
        verb <- input[[glue("{pos()}-verb")]]
        cols <- input[[glue("{pos()}-cols")]]
        
        processed_df <-  # selects all if select verb but no col - add logic
          reactive({
            case_when(
              verb == "select" ~ glue("{verb}(cols)"),
              TRUE ~ glue("{verb}({cols})")
            ) %>%
              c("orig_df", .) %>%
              glue_collapse(" %>% ") %>%
              parse(text = .) %>%
              eval()
          })
      }
      processed_df()
      
  })
  
  output$print <- renderText({
    state <- dragulaValue(input$dragula)
    print(state$Picked)
  })
  
}

shinyApp(ui = ui, server = server)
