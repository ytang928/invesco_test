library(shiny)
library(dygraphs)
library(xts)
library(zoo)

ui <- fluidPage(
  headerPanel('Candlestick and peer correlations'),
  sidebarPanel(
    dateInput(inputId = "start", label = "Start Date", value = "2015-01-02", min = "2015-01-02", max = NULL,
              format = "yyyy-mm-dd", startview = "month"),
    dateInput(inputId = "end", label = "End Date", value = "2017-12-29", min = NULL, max = "2017-12-29",
              format = "yyyy-mm-dd", startview = "month"),
    textInput(inputId = "symbol", "Symbol", value = "AAPL", width = NULL, placeholder = NULL),
    actionButton(inputId = "update", "Update", icon = NULL, width = NULL)
    ),
  mainPanel(
    dygraphOutput("dygraph"),
    textOutput("textout"),
    tableOutput("tableout")
  )
  
)

loaddata <- function(){
  dataOpen <<- read.csv(file="./data/dataOpen.csv",row.names = 1, header=TRUE, sep=",")
  dataHigh <<- read.csv(file="./data/dataHigh.csv",row.names = 1, header=TRUE, sep=",")
  dataLow <<- read.csv(file="./data/dataLow.csv",row.names = 1, header=TRUE, sep=",")
  dataClose <<- read.csv(file="./data/dataClose.csv",row.names = 1, header=TRUE, sep=",")
  dataReturn <<- read.csv(file="./data/dataReturn.csv",row.names = 1, header=TRUE, sep=",")
  dateindex <<- rownames(dataOpen)
  colindex <<- c('Open','High','Low','Close')
  
}

server <- function(input, output) {
  loaddata()

  data <- eventReactive(input$update, {
    drange <- (rownames(dataOpen) >= input$start & rownames(dataOpen) <=input$end)
    tmpOpen <- (dataOpen[[input$symbol]][drange])
    tmpHigh <- (dataHigh[[input$symbol]][drange])
    tmpLow <- (dataLow[[input$symbol]][drange])
    tmpClose <- (dataClose[[input$symbol]][drange])
    testdata <- cbind(tmpOpen,tmpHigh,tmpLow,tmpClose)
    rownames(testdata) <- dateindex[drange]
    colnames(testdata)<- colindex
    return(testdata)
  })
  
  ret <- eventReactive(input$update, {
    drange <- (rownames(dataOpen) >= input$start & rownames(dataClose) <input$end)
    tmpReturn <- as.data.frame(dataReturn[[input$symbol]][drange])
    allReturn <- dataReturn[drange,]
    rownames(tmpReturn) <- dateindex[drange]
    colnames(tmpReturn)<- c('Return')
    result <- colnames(allReturn)[order(cor(tmpReturn,allReturn),decreasing = TRUE)[1:6]]
    cor_matrix <- cor(allReturn[,result])
    return(cor_matrix)
  })
  
  txt <- eventReactive(input$update, {
    return(c('The pairwise correlation for ',input$symbol,' and its peers are:'))
  })
  
  output$dygraph <- renderDygraph({
    dyCandlestick(dyOptions(dygraph(data()),connectSeparatedPoints = TRUE, drawGapEdgePoints = TRUE))
    })
  
  output$textout <- renderText({
    txt()
  })
  output$tableout <- renderTable({
    ret()
  })
}

shinyApp(ui = ui, server = server)