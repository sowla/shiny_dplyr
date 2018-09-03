library(glue)
library(purrr)
library(dplyr)
library(shiny)
library(dragulaR)

my_mtcars <- 
  tibble::rownames_to_column(mtcars, "model") %>% 
  as_tibble()
box_names <- c("select 'model', 'mpg', 'hp'", "select 'model', 'mpg'", "pull 'mpg'")

source("M_verb_box.R")


ui <- fluidPage(
  titlePanel("shiny dplyr"),
  
  fluidRow(
    column(3,
      h4("Drag from here:"),
      div(id = "Available", style = "min-height: 1000px;",
        map2(1:3, box_names, function(x, y) verb_box_UI(id = x, label = y))
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
      
      test <- list(func = c("select", "select", "pull"), var = c("'model', 'mpg', 'hp'", "'model', 'mpg'", "'mpg'"))
      
      df <- my_mtcars
      
      for (i in 1:length(state$Picked)) {

        pos <- reactive({state$Picked[i]})
        df <- 
          glue("{test$func[[{{pos()}}]]}({test$var[[{{pos()}}]]})", 
            .open = "{{", 
            .close = "}}"
          ) %>%
          glue() %>%
          c("df", .) %>%
          glue_collapse(" %>% ") %>%
          parse(text = .) %>%
          eval()
      }
      df
  })
  
  output$print <- renderText({
    state <- dragulaValue(input$dragula)
    print("order of verb boxes:")
    print(state$Picked)
  })
  
}

shinyApp(ui = ui, server = server)
