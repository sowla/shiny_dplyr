# not sure utils is the right name; function definittions that only have to be loaded once

### save rownames as column -----
##TODO: make selectable function and let people select column name?

  my_mtcars <-
    rownames_to_column(mtcars, "model") %>%
    as_tibble()

  
### for DT formatting-----
# scale_colour <- colorRampPalette(brewer.pal(9, "Pastel1"))  # light
scale_colour <- colorRampPalette(brewer.pal(8, "Set2"))  # colourblind-friendly