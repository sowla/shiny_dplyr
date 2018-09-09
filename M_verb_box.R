action_box_UI <- function(id, df) {
  ns <- NS(id)
  
  div(class = "well",  # if shinytheme
  # wired_card(  # if wired
    drag = id,
    # div(strong(paste0("action", id))),
    # div(strong(func), br(), "description goes here")
    fluidRow(
      column(6,
        selectizeInput(
          ns("verb"),
          label = "verb",
          c("select",  ##TODO: add helper functions
            "pull",  ##TODO: diff output for pull
            "arrange",  ##TODO: add `desc()`
            "group_by",
            "count",
            "add_count"
            ##TODO: ask Susan if she'd like to help with designing app?
          )
        )
      ),
      column(6,
        selectizeInput(
          ns("cols"),
          label = "cols",  # change to fit functions' parameters
          names(df),
          selected = NULL,
          multiple = TRUE
        )
      )
    ),
    uiOutput(
      ns("desc")
    )
    ##TODO: add button to remove UI
  )
}



action_box <- function(input, output, session) {
    
    verb <- input$verb
    cols <- input$cols
    
    if (verb == "select"){
      cols <- glue("c({edit})", edit = glue("'{cols}'") %>% glue_collapse(", "))
    }
    
    if (verb == "arrange"){
      cols <- glue("{cols}") %>% glue_collapse(", ")
    }

    glue("{verb}({cols})")

}


ft_opt_cols <- function(input, output, session, string) {
  
  # if (!(verb %in% c("group_by"))){  # in case add others
  if (input$verb == "add_count"){
    list(input$cols, "n")  # allow input col name
  } else if (input$verb != "group_by"){
    input$cols
  } else {
    NULL
  }
  
}

ft_opt_fmt <- function(input, output, session, string) {
  
  if (input$verb == "arrange"){
    ~color_tile('white', 'lightgreen')
    # ~color_tile('white', 'lightgreen')
  } else if (input$verb == "add_count") {
    list(
      color_tile('lightgreen', 'lightgreen'), 
      color_tile('lightblue', 'lightblue')
    )
  } else {
    ~color_tile('lightgreen', 'lightgreen')
  }
  
}


DT_fmt_style <- function(input, output, session, string) {
  
  if (input$verb == "group_by"){
    input$cols
  } else {
    NULL
  }
  
}


update_action_box <- function(input, output, session, string) {
  
  output$desc <- renderUI({
    

    ##TODO: use verbatim text output/different font to make it more obvious it's code?
    span(strong("code: "), string())
    
  })
  
}



