# Shiny Demo
# This is a relatively simple Shiny app designed to demonstrate how to use Shiny
# The three files (ui.R, server.R, and helpers_dataloading.R) must be in the 
# same folder as the data to be loaded (or data can be loaded from internet).


# The UI file is the user interface and here we set what will be displayed
# For this script I've used a "fluidpage" layout which just means that things
# can move when resized. I also set a theme using package shinythemes
# First, I set 3 tabs: Charts, Summary, and About
# Summary and About have no divisions within them and are straightforward.
# Charts is the first tab but most complex. Within this tab, I set up a 
# sidebar for changing settings and a main panel for showing charts. 
# The main panel has three tabs, one for each chart. 
# The sidebar is conditional, that is, it shows you different things depending
# on which main panel chart tab is selected. 

# These are a few shiny html commands to format text:
# p()=paragraph text, h3()=headings size 3, hr()=horizontal rule (line), br()=break


source("helpers_dataloading.R") # this runs once, before the app is shown

shinyUI(fluidPage(theme = shinytheme("sandstone"),
                  navbarPage("This is my project's title", 
                             tabPanel("Charts",
                                      sidebarLayout(
                                        sidebarPanel(
                                          tags$head(tags$style(HTML("hr {border-top: 1px solid #b3b3b3;}"))), # optional. sets color/width of horiz line in hr()  
                                          h2("Side panel name"),
                                          hr(), # we defined this style up above in tags$head
                                          # I use conditional panels here in the sidebar
                                          conditionalPanel(condition = "input.mainpanels_id == 'Annual Hugh Smith Counts' || input.mainpanels_id == 'Cumulative Catch'",
                                                           selectInput("sppchoice", label = h3("Select species"), 
                                                                       choices = list("Sockeye Salmon" = "Sockeye",  "Coho Salmon" = "Coho", 
                                                                                      selected = "Coho")),
                                                           selectInput("maturitysel", "Choose maturity:", 
                                                                       choices = list("All" = "All", "Jack only" = "Jack", "Adult only" = "Adult"), 
                                                                       selected = c("All"))),

                                          conditionalPanel(condition = "input.mainpanels_id == 'Annual Hugh Smith Counts'",
                                                           selectInput("year", "Choose Year:", choices = rev(unique(testdata$Year)), 
                                                                       selected = 2020),
                                                           hr(), # we defined this style up above in tags$head
                                                           p("this is text")),
                                          
                                          conditionalPanel(condition = "input.mainpanels_id == 'Outliers Plot'",
                                                           checkboxInput("showoutliers", "Highlight outliers?", value = FALSE) ),
                                        ), # end sidebar panel
                                        
                                        
                                        
                                        mainPanel(
                                          tabsetPanel(
                                            tabPanel("Annual Hugh Smith Counts", plotOutput("annualcountplot")),
                                            tabPanel("Cumulative Catch", plotOutput("cumulativeplot")),
                                            tabPanel("Outliers Plot", plotOutput("outlierplot")),
                                            id="mainpanels_id"
                                          )
                                        ) # end main panel of charts tab
                                        
                                      )
                             ),#end charts tab
                             
                             tabPanel("Summary", h1("Summary of Results"),
                                      h2(paste0("Total catch so far is ", prettyNum(sum(testdata$Count, na.rm = TRUE), big.mark=","))),
                                             h3("Top Species Caught"), tableOutput("catchsumm")), #end summary tabpanel
            
                             tabPanel("About", h3("About this application:"),
                                      h4("Enter some interesting info here."), 
                                      h4("Enter another line here"), br(),
                                      p("If you have questions or comments, contact Justin Priest,
                             justin.priest@alaska.gov"),
                                      br(),
                                      p("Application version 0.1")) #end about tabpanel
                             )
                  )
        )