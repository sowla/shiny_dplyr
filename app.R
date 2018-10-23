library(tibble)
library(formattable)
library(RColorBrewer)
library(glue)
library(purrr)
library(dplyr)
library(shiny)
library(shinythemes)
library(DT)
library(dragulaR)


source("utils.R")
source("M_action_box.R")


ui <- fluidPage(
  
  titlePanel("shiny dplyr"),
  theme = shinytheme("flatly"),
  
  fluidRow(
    
    column(3,
      h4("Where UI will get added:"),
      div(id = "Available", style = "min-height: 600px;",
        map(1:3, function(x, df) action_box_UI(id = x, df = my_mtcars))
      )
    ),
    column(3,
      h4("Build dplyr pipeline:"),
      div(id = "Picked", style = "min-height: 600px;")
    ),
    column(6,
      tabsetPanel(
        id = "display",
        tabPanel(
          title = "data",
          br(),
          DTOutput("data_df"),
          uiOutput("data_text")
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
  
  
  ##TODO: refactor once settled on a particular way to build the functions
  
  ### make action_string -----
  action_string <- list()
  action_string[[1]] <- reactive({ callModule(action_box, 1) })
  action_string[[2]] <- reactive({ callModule(action_box, 2) })
  action_string[[3]] <- reactive({ callModule(action_box, 3) })
  
  
  ### show code at the bottom of action box -----
  observeEvent(
    input$`1-cols`,
    callModule(update_action_box, 1, action_string[[1]])
  )
  observeEvent(
    input$`2-cols`,
    callModule(update_action_box, 2, action_string[[2]])
  )
  observeEvent(
    input$`3-cols`,
    callModule(update_action_box, 3, action_string[[3]])
  )
  
  
  ### save often used values as reactive expressions -----
  state <- reactive({
    req(input$dragula)
    dragulaValue(input$dragula)
  })
  
  last_box <- reactive({
    state()$Picked[length(state()$Picked)] 
  })
  
  verb <- reactive({ 
    callModule(input_verb, last_box()) 
  })
  
  cols <- reactive({ 
    callModule(input_cols, last_box()) 
  })
  
  
  ### formatting options for formattable -----
  ft_opts <- reactive({
    
    if (verb() == "arrange"){
      return(
        map(cols(), ~color_tile('white', 'lightgreen')) %>%
          setNames(cols())
      )
    }
    
    if (verb() %in% c("count", "add_count")){
      return(
        setNames(
          list(
            color_tile('lightgreen', 'lightgreen'), 
            color_tile('lightblue', 'lightblue')
          ), 
          list(cols(), "n")
        )
      )
    }
    
    if (verb() == "group_by"){
      return(list())
    }
    
    if (verb() == "select"){
      return(
        map(cols(), ~color_tile('lightgreen', 'lightgreen')) %>%
          setNames(cols())
      )
    }
    
    if (verb() == "pull"){
      return(NULL)
    }
    
  })
  
  
  ### formatting options for DT -----
  DT_opts <- reactive({
    
    if (verb() == "group_by"){
      cols()
    } else {
      NULL
    }
    
  })
  
  
  df <- reactive({
    df_string <- "my_mtcars"
    
    for (i in 1:length(state()$Picked)) {
      
      pos <- state()$Picked[i] %>% as.numeric()
      
      df_string <-
        action_string[[pos]]() %>%
        c(df_string, .) %>%
        glue_collapse(" %>% ")
    }
    df_string %>%
      parse(text = .) %>%
      eval()
  })
  
  
  ### combine strings and eval to dplyr pipeline -----
  output$data_df <- renderDT({
    validate(need(state()$Picked, message = "Please select at least one function."))
    
    if (verb() == "pull") {
      return(NULL)
    }

    if (is.null(DT_opts())) {
      df() %>%
        formattable(ft_opts()) %>%
        as.datatable(
          rownames = TRUE, filter = "none", selection = "none"
        )
    } else {
      unique_df_subset <- unique(df()[[DT_opts()]])
      datatable(df()) %>%
        formatStyle(
          DT_opts(),
          target = "row",
          backgroundColor = styleEqual(
            unique_df_subset,
            scale_colour(length(unique_df_subset))
          )
        )
    }
    
  })
  
  
  output$data_text <- renderUI({
    req(state()$Picked)
    

    if (verb() != "pull") {
      return(NULL)
    } else {
      verbatimTextOutput("pull")
    }
    
  })
  
  
  output$pull <- renderPrint({
    
    df()
    
  })
  
}

shinyApp(ui = ui, server = server)
