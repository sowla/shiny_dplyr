library(tibble)
library(formattable)
library(glue)
library(purrr)
library(dplyr)
# library(wired)  # https://github.com/dreamRs/wired
library(shiny)
library(shinythemes)
library(DT)
library(dragulaR)
# library(shinydashboardPlus) # https://github.com/DivadNojnarg/shinydashboardPlus


source("utils.R")
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
  

  ### formatting options for formattable -----
  ft_opts <- reactive({
    req(input$dragula)
    state <- dragulaValue(input$dragula)
    
    fmt_cols <- callModule(ft_opt_cols, state$Picked[length(state$Picked)])
    fmt_func <- callModule(ft_opt_fmt, state$Picked[length(state$Picked)])
    
    if (is.null(fmt_cols)) {
      temp_opts <- list()
    } else if (is.list(fmt_cols)) {
      temp_opts <- setNames(fmt_func, fmt_cols)
    } else {
      temp_opts <- map(fmt_cols, fmt_func) %>%
        setNames(fmt_cols)
    }
    
    temp_opts
  })
  
  DT_opts <- reactive({
    req(input$dragula)
    state <- dragulaValue(input$dragula)
    
    callModule(DT_fmt_style, state$Picked[length(state$Picked)])
    
  })
  
  ### combine strings and eval to dplyr pipeline -----
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
    
    if (is.null(DT_opts())){
      df %>%
        formattable(ft_opts()) %>%
        as.datatable(
          rownames = TRUE, filter = "none", selection = "none"
        )
    } else {
      datatable(df) %>%
        formatStyle(
          DT_opts(),
          target = "row",
          backgroundColor = styleEqual(
            unique(df[[DT_opts()]]), 
            scale_colour(length(unique(df[[DT_opts()]])))
          )
        )  # only works for one column!!
    }
    
  })
  
  output$print <- renderPrint({
    state <- dragulaValue(input$dragula)
    # print(length(ft_opts()))
    print(DT_opts())
  })
  
}

shinyApp(ui = ui, server = server)
