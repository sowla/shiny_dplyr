verb_box_UI <- function(id, df) {
  ns <- NS(id)
  
  # div(class = "well",  # if shinytheme
  wired_card(  # if wired
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
    )
  )
}


verb_box <- function(input, output, session) {
  input$verb
}

