##### UI #####

action_box_UI <- function(id, df) {
  ns <- NS(id)
  
  div(class = "well",  # colour-code based on type of verb?
    drag = id,
    fluidRow(
      column(6,
        selectizeInput(
          ns("verb"),
          label = "verb",
          c("select",  ##TODO: add helper functions
            "pull",  ##TODO: diff output for pull
            "arrange",  ##TODO: add `desc()`
            "group_by",  # only works for one column
            "count",  # only works for one column
            "add_count"  # only works for one column
          )
        )
      ),
      column(6,
        selectizeInput(
          ns("cols"),
          label = "cols",  ##TODO: change to fit functions' parameters
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



##### server #####

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


input_verb <- function(input, output, session) {
  input$verb 
}


input_cols <- function(input, output, session) {
  input$cols 
}


update_action_box <- function(input, output, session, string) {
  
  output$desc <- renderUI({

    ##TODO: use verbatim text output/different font to make it more obvious it's code?
    span(strong("code: "), string())
    
  })
  
}



