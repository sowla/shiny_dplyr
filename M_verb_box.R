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
            "pull",
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
    
    glue("{verb}({cols})")

}


# output$desc <- renderUI({
#   ##TODO: fix that code only comes up once dragged to picked
#   ## use verbatim text output or different font to make it more obvious it's code?
#   span(strong("code: "), glue("{verb}({cols})"))
# })

