# Shiny Skeleton
This is the framework of a Shiny app that can easily be modified for future apps. 
Using the code in this app, you can easily modify aspects and learn the working of a Shiny app.  
Once imported into a local directory, open this project in RStudio. 
To run the app, open either file _ui.R_ or _server.R_ and click the button 
"Run App" in the top right of the script pane.  


# Code Outline
There are three R files that help create a Shiny app 
(_ui.R_, _server.R_, and _helpers_dataloading.R_). For this demo we also
have two data files (_hughsmith.csv_ and _mtalenweight.csv_). All of these files must 
be in the same root folder as the RProject file. Alternatively, data can be 
loaded from internet.  

## ui.R
The UI file is the user interface and here we set what will be displayed. 
Code written in this file controls what users see and can interact with. 
For this script I've used a "fluidpage" layout which just means that things
can move when resized. I also set a theme using package `shinythemes`
First, I set 3 tabs: Charts, Summary, and About.  
Summary and About have no divisions within them and are straightforward.  
Charts is the first tab but most complex. Within this tab, I set up a 
sidebar for changing settings and a main panel for showing charts. 
The main panel has three tabs, one for each chart. 
The sidebar is conditional, that is, it shows you different things depending
on which main panel chart tab is selected.  

There are also a few shiny html commands to format text:  
`p()` = paragraph text, `h3()` = headings size 3, `hr()` = horizontal rule (line), `br()`=break


## server.R
The Shiny server file is the "backend" and creates datasets, plots, tables, etc. 
Anything to be shown in the UI starts with `output$`. 
Any input from the UI begins with `input$`.  
For example, notice that _sppchoice_ is one of the dropdown menus in the UI


## helpers_dataloading.R
The helpers file runs just once, at the start of the app. This file is optional to include
but is a nice place to import, clean up, and organize any data. 
