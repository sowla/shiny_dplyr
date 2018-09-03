verb_box_UI <- function(id, label) {
  ns <- NS(id)
  
  div(style = "border-width:1px;border-style:solid;min-height:30px;margin:4px",
    drag = id,
    strong(label)
  )
}

verb_box <- function(input, output, session) {
  input$verb
}
