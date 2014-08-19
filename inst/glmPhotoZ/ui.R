library(shiny)

# Define the user interface
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("GLM PhotoZ"),

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
    checkboxInput('dataSourceFlag', 'Use PHAT0 data', FALSE),
    fileInput('file1', 'Data for training', accept=c('.dat', '.txt')),
    fileInput('file2', 'Data to estimate photoZ', accept=c('.dat', '.txt')),
    h4("Control and options"),
    selectInput("method", "Method:",
                list("Frequentist" = "Frequentist", 
                     "Bayesian" = "Bayesian")),
    selectInput("family", "Family:",
                list("Gamma" = "gamma", 
                     "Inverse Gaussian" = "inverse.gaussian")),
    sliderInput("fracDataDiag", "Train data fraction for diagnostics:", 
                min = 0, max = 1, value = 0.2, step= 0.01),
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
