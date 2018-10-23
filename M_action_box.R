##### UI #####

action_box_UI <- function(id, df) {
  ns <- NS(id)
  
  div(class = "well",
    drag = id,
    fluidRow(
      column(6,
        selectizeInput(
          ns("verb"),
          label = "verb",
          c("select",
            "pull",
            "arrange",
            "group_by",
            "count",
            "add_count"
          )
        )
      ),
      column(6,
        selectizeInput(
          ns("cols"),
          label = "cols",
          names(df),
          selected = NULL,
          multiple = TRUE
        )
      )
    ),
    uiOutput(
      ns("description")
    )
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
  
  output$description <- renderUI({

    span(strong("code: "), string())
    
  })
  
}



