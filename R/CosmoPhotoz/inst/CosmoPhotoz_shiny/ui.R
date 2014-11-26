#  R package CosmoPhotoz file inst/glmPhotoZ-2/ui.R
#  Copyright (C) 2014  COIN
#
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License version 3 as published by
#the Free Software Foundation.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#  A copy of the GNU General Public License is available at
#  http://www.r-project.org/Licenses/
#
library(shiny)
library(markdown)
library(shinyIncubator)
# Define the user interface
shinyUI(fluidPage(theme = "bootstrapblue.css",

  # Application title
  headerPanel("CosmoPhotoz - GLM PhotoZ estimation"),
  img(src='COIN.jpg',height = 95, width = 650,align="right"),
# Sidebar with controls
  sidebarPanel(
    tags$head(tags$style(type="text/css", "
             #loadmessage {
               position: fixed;
               top: 50%;
               left: 0px;
               width: 100%;
               padding: 5px 0px 5px 0px;
               text-align: center;
               font-weight: bold;
               font-size: 125%;
               color: #FFFFFF;
               background-color: #B22222;
               z-index: 105;
             }
          ")),
    
    
           conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                            tags$div("Calculating... you can get a coffee.", id="loadmessage")),

    h4("Data Input"),
    div(checkboxInput('dataSourceFlag', 'Use PHAT0 data', TRUE),class="radio"),
    fileInput('file1', 'Data for training', accept=c('.dat', '.txt')),
    fileInput('file2', 'Data to estimate photoZ', accept=c('.dat', '.txt')),

    h4("Control and options"),
    div(checkboxInput('useRobustPCA', 'Use robust PCA', FALSE),class="radio"),
    numericInput("numberOfPcs", "Number of Principal Components:", value=4, min=1),
    numericInput("numberOfPoints", "Points in Pred vs. Obs. plot: ", 5000, min=0),
    helpText("Note: if 0, all points will be used."),
    br(),
    selectInput("method", "Method:",
                list("Bayesian" = "Bayesian",
                     "Frequentist" = "Frequentist")),
    selectInput("family", "Family:",
                list("Gamma" = "gamma", 
                     "Inverse Gaussian" = "inverse.gaussian")),

    br(), 
    submitButton("Run analysis", icon("refresh")),
    br(),
    downloadButton('downloadData', 'Download photoZ results')
  ),

  # Show output plot
  mainPanel(
    tabsetPanel(
      tabPanel("Introduction", includeMarkdown("help.md")),
      tabPanel("Error Distribution", plotOutput("errorDistPlot")), 
      tabPanel("Violins", plotOutput("violins")),
      tabPanel("Box", plotOutput("box")),
      tabPanel("Prediction", plotOutput("predictObs")), 
      tabPanel("Diagnostics", verbatimTextOutput("diagnostics")),
      tabPanel('Photo-z',dataTableOutput("photoz_out")),
      tabPanel("Copyright", includeMarkdown("Copyright.md")),
      tabPanel("COIN", includeMarkdown("COIN.md"))
    ))
))
