library(shinytest)
library(testthat)

context("test action entry")

app <- ShinyDriver$new("../.")

test_that("expected action output is displayed", {
  app$setInputs(`1-verb` = "pull", `1-cols` = "cyl")
  all_values <- app$getAllValues()
  # print(all_values)
  
  expect_equal(all_values$input$`2-verb`, "select")
  expect_null(all_values$input$`2-cols`)
  
  expect_equal(
    all_values$output$`1-desc`$html %>% as.character() %>% gsub("\\s", "", .) ,
    "<span><strong>code:</strong>pull(cyl)</span>"
  )
  
})

app$stop()

# https://blog.daqana.com/en/unit-testing-shiny-apps-using-testthat/
# https://rstudio.github.io/shinytest/reference/ShinyDriver.html
# https://rstudio.github.io/shinytest/articles/package.html
# https://ropensci.github.io/RSelenium/articles/shinytesting.html