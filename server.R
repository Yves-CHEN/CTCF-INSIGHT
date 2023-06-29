library(randomForest)
library(shiny)


options(shiny.maxRequestSize = 9* 1024^2)
# Read in the RF model
server <- function(input, output) {
    is_processing <- reactiveVal(FALSE)
    results <- reactiveVal(NULL)
    lastProcessedFile <- reactiveVal(NULL)
    output$is_processing <- reactive({
        is_processing()
    })
    outputOptions(output, "is_processing", suspendWhenHidden = FALSE)
    # Define the function that will process the file
    generate <- function(featureFile) {
        #load RF model
        load("./RF.model.Mar2023.dat")
        model = models[["full"]]
        #dat = read_table2(featureFile)
        dat = read.table(featureFile,header =T, as.is =T)
        pred_persistent <- predict(model, dat,  type='prob')
        pred_persistent [, 2]
    }

    observeEvent(input$process, {

        if (is.null(input$file) || identical(input$file, lastProcessedFile())) {
            print("No file selected")
            # Show an error message and return
            showModal(modalDialog(
              title = "Error",
              "No new file selected. Please select a new file and try again.",
              easyClose = TRUE
            ))
            return()
        }
        # notify the user that the file is being processed
        showModal(modalDialog(
            title = "Please wait",
            "Your file is being processed ...",
            easyClose = FALSE
        ))


        
        # Read the file
        inFile <- input$file
        result <- generate(inFile$datapath)
        unlink(inFile$datapath)
        results(as.character(result))
        lastProcessedFile(inFile)
        # Update the result output
        
        # Set is_processing back to FALSE
        is_processing(FALSE)
    })



    # Only show download button if processing has finished and there's a result
    output$download_button <- renderUI({
        if(!is_processing() && !is.null(results())) {
            downloadButton("download", "Download Result")
        }
    })
    output$download <- downloadHandler(
      filename = function() {
        paste("results-", Sys.Date(), ".txt", sep="")
      },
      content = function(file) {
        writeLines(results(), file)
      }
    )

  
    # Render a density plot of the result data
    output$density_plot <- renderPlot({
      req(results())
      if(!is_processing() && !any(is.null(results()))) {
          dd = results()
          dd = dd[!is.na(dd)]
          plot(density(as.numeric(dd), na.rm = TRUE), main = "Estimated persistence" , col=2, lwd=2 )
      }
    })

            #output$result <- renderPrint({
        #    result
        #})
}


