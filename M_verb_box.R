verb_box_UI <- function(id, df) {
  ns <- NS(id)
  
  div(style = "border-width:1px;border-style:solid;min-height:30px",
    drag = id,
    div(strong(paste0("action", id))),
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
          multiple = TRUE
        )
      )
    )
  )
}

verb_box <- function(input, output, session) {
  input$verb
}
