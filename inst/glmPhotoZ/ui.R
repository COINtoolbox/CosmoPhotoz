library(shiny)

# Define the user interface
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("GLM PhotoZ"),

  # Sidebar with controls
  sidebarPanel(

    h4("Data Input"),
    checkboxInput('dataSourceFlag', 'Used PHAT0 data', FALSE),
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
      tabPanel("Diagnostics", verbatimTextOutput("diagnostics"))
    )
  )
))
