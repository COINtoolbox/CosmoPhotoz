library(shiny)

# Define the user interface
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("CosmoPhotoz - GLM PhotoZ estimation"),

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

tabsetPanel(
    tabPanel("Data",
      h4("Data Input"),
      checkboxInput('dataSourceFlag', 'Use PHAT0 data', FALSE),
#    conditionalPanel(
 #     condition = "input.dataSourceFlag == TRUE",
        fileInput('file1', 'Data for training', accept=c('.dat', '.txt')),
        fileInput('file2', 'Data to estimate photoZ', accept=c('.dat', '.txt'))
    #),
),

    tabPanel("Control",
    h4("Control and options"),
    checkboxInput('useRobustPCA', 'Use robust PCA', FALSE),
    numericInput("numberOfPcs", "Number of Principal Components:", 4),
    numericInput("numberOfPoints", "Points in Pred vs. Obs. plot: ", 0),
    helpText("Note: if 0, all points will be used."),
    br(),
    selectInput("method", "Method:",
                list("Bayesian" = "Bayesian",
                     "Frequentist" = "Frequentist")),
    selectInput("family", "Family:",
                list("Gamma" = "gamma", 
                     "Inverse Gaussian" = "inverse.gaussian"))
)
),
    br(), 
    submitButton("Run analysis"),
    br(),
    downloadButton('downloadData', 'Download photoZ results')

  ),

  # Show output plot
  mainPanel(
    tabsetPanel(
      tabPanel("Error Distribution", plotOutput("errorDistPlot")), 
      tabPanel("Prediction", plotOutput("predictObs")), 
      tabPanel("Violins", plotOutput("violins")),
      tabPanel("Box", plotOutput("box")),
      tabPanel("Diagnostics", verbatimTextOutput("diagnostics"))
    )
  )
))
