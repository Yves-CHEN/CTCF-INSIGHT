library(shiny)
ui <- fluidPage(

  tags$div(tags$h2("Step 1"), style = "height: 40px; background-color: #f0f0f0; "),
  tags$div( style = "height: 100px; ",
  tags$b("You need to generate the features locally, using the R script at: https://github.com/Yves-CHEN/CTCF-INSIGHT."),
  tags$b("The script takes the output file, *.narrowpeaks, from MACS2 analysis of ChIP-seq data. It generates a feature file, *.gz, for each sample. The feature file is then used to predict the persistence of CTCF binding sites."),
  tags$br(),
  tags$a(href="https://drive.google.com/file/d/1v8Ew0DKiz5qWkhWoNNI0snRvHcGt6wwk/view?usp=sharing", "example") ),
  tags$b("Note: you can use the above sample feature file to test the step2."),
  # ===========================
  # Input Area
  # ===========================
  # Create a file input component to upload the file
  tags$div(tags$h2("Step 2"), style = "height: 40px; background-color: #f0f0f0;"),
  tags$b("Note: the input file is expected to be <5Mb. If not, try gzip it with higher compression level."),
  tags$br(),
  fileInput("file", "Upload your file",
            accept = c(
              "text/csv",
              "text/comma-separated-values,text/plain",
              ".gz",
              ".csv")
            ),
  # Create a button to trigger the processing
  actionButton("process", "Process the file"),
  # ===========================
  # Output area
  # ===========================
  tags$div(tags$h2("Output"), style = "height: 40px; background-color: #f0f0f0;"),
  # Once output is generated, this would be resplace by downloadButton
  plotOutput("density_plot", width = "500px", height = "500px"),
  uiOutput("download_button")
)

# ui <- fluidPage(
#   # Create a file input component to upload the file
#   fileInput("file", "Upload your file",
#             accept = c(
#               "text/csv",
#               "text/comma-separated-values,text/plain",
#               ".gz",
#               ".csv")
#             ),
#   # Create a button to trigger the processing
#   actionButton("process", "Process the file"),
# 
#   # Create an area to show the results
#   verbatimTextOutput("result")
# )
# 
#
#
## Training set
#TrainSet <- read.csv("training.csv", header = TRUE)
#TrainSet <- TrainSet[,-1]
#
#pageWithSidebar(
#
#  # Page header
#  headerPanel('Iris Predictor'),
#
#  # Input values
#  sidebarPanel(
#    HTML("<h3>Input parameters</h4>"),
#    sliderInput("Sepal.Length", label = "Sepal Length", value = 5.0,
#                min = min(TrainSet$Sepal.Length),
#                max = max(TrainSet$Sepal.Length)
#    ),
#    sliderInput("Sepal.Width", label = "Sepal Width", value = 3.6,
#                min = min(TrainSet$Sepal.Width),
#                max = max(TrainSet$Sepal.Width)),
#    sliderInput("Petal.Length", label = "Petal Length", value = 1.4,
#                min = min(TrainSet$Petal.Length),
#                max = max(TrainSet$Petal.Length)),
#    sliderInput("Petal.Width", label = "Petal Width", value = 0.2,
#                min = min(TrainSet$Petal.Width),
#                max = max(TrainSet$Petal.Width)),
#
#    actionButton("submitbutton", "Submit", class = "btn btn-primary")
#  ),
#
#  mainPanel(
#    tags$label(h3('Status/Output')), # Status/Output Text Box
#    verbatimTextOutput('contents'),
#    tableOutput('tabledata') # Prediction results table
#
#  )
#)
