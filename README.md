# shiny_dplyr

trying to make a shiny app based on [Jesse](https://twitter.com/kierisi)'s [tweet](https://twitter.com/kierisi/status/1036293295352229889) (with her [permission](https://twitter.com/kierisi/status/1036395821091172353)) :)  

not gonna touch the conceptual visualisation/gganimate part until [Garrick](https://twitter.com/grrrck) and [Dav](https://twitter.com/dav_zim) have done their [magic](https://twitter.com/grrrck/status/1036304447385870336) :P

<hr />

**current status:**  
At the moment, the data transformation works by creating a string to represent each action, putting them together in the dragged order, then parsing and evaluating the combined string. A few verbs are supported, but the only arguments accepted are column names. For some verbs, the formatting only works with one column right now.  

Also: thank you for dropping by! I'm new to programming and I'm very open to suggestions! :)

![](current_app.gif)

<br />

**brainstorm:**  

- left column:  
    - file upload input
    - area where 'action box' UIs can get inserted

- middle column:  
    - drag action boxes around to build dplyr pipeline  

- right column:  
    - data tab - data displayed, with formatting to highlight the effect of the last transformation in the pipeline on the data  
    - animated tab - gifs would be complementary to data tab :)  
    - info tab - more information on the verb used in the last transformation or the error displayed. Would love for this to be localised one day! :D  
    - links tab - so many resources out there!