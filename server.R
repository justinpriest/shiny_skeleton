# The Shiny server file is the "backend" and creates datasets, plots, tables, etc
# Anything to be shown in the UI starts with "output$". 
# Any input from the UI begins with "input$"
# e.g., notice that sppchoice is one of the dropdown menus in the UI


shinyServer(
  # Function takes input from ui.R and returns output objects.
  function(input, output) {
    
    dataset.new <- reactive({
      if(input$maturitysel != "All") {testdata %>% filter(Species == input$sppchoice, Maturity == input$maturitysel, 
                                                    Year == input$year)
      } else {testdata %>% filter(Species == input$sppchoice, Year == input$year) %>%
          group_by(Year, Species, std_date) %>%
          summarise(Count = sum(Count, na.rm = TRUE))}
    })
    

    cumulativedata <- reactive({
      if(input$maturitysel != "All") {testdata %>% 
          filter(Species == input$sppchoice, Maturity == input$maturitysel) %>%
          group_by(Year) %>%
          mutate(cummsum = cumsum(Count))
      } else {testdata %>% 
          filter(Species == input$sppchoice) %>%
          group_by(Year, Species, std_date) %>%
          summarise(Count = sum(Count, na.rm = TRUE)) %>%
          group_by(Year) %>%
          mutate(cummsum = cumsum(Count))}

    })
    

    
    output$annualcountplot <- renderPlot({
      
      t <- ggplot(dataset.new(), aes(x=std_date, y=Count)) + 
        geom_line(color = "deepskyblue1", size = 1.5) + labs(title = paste0(input$sppchoice,", ", input$year)) 
      
      print(t)
    })
    
    
    output$cumulativeplot <- renderPlot({
      
      t <- ggplot(cumulativedata(), aes(x = std_date, y = cummsum, group = Year, color = Year)) +
        geom_line() +
        geom_line(data = . %>% filter(Year == 2021), color = "red", size = 1.5)
      
  
      
      print(t)
    })
    
    
    
    # output$text1 <- renderText({ 
    #   paste0("Selected dataset consists of ", input$chart_type)
    # })


    output$catchsumm = renderTable(catchsumm)

    
    
    output$outlierplot <- renderPlot({
      if(input$showoutliers == TRUE) {
      t <- ggplot(mtadata, aes(x = Fish_length, y = Fish_weight)) +
      geom_ribbon(aes(ymin=lenwtlow, ymax=lenwt_hi), fill = "grey70") +
      geom_point(aes(color = outlier), size = 3) +
      geom_line(data = data.frame(Fish_length = seq(from=1, to=800), Fish_weight = pred), 
                aes(x = Fish_length, y = Fish_weight)) +
      scale_x_continuous(limits = c(300, 750)) +
        scale_color_manual(values = c("black", "firebrick1")) +
      theme_bw() +
        theme(legend.position=c(0.15, 0.85), 
              legend.title = element_blank(),
              legend.key.size = unit(2,"line"))
      print(t)
      } else{
        t <- ggplot(mtadata, aes(x = Fish_length, y = Fish_weight)) +
          geom_point(size = 3) +
          geom_line(data = data.frame(Fish_length = seq(from=1, to=800), Fish_weight = pred), 
                    aes(x = Fish_length, y = Fish_weight)) +
          scale_x_continuous(limits = c(300, 750)) +
          theme_bw()
        print(t)
      }
      
    })

  }
)


