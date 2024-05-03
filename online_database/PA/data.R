chip_page<-fluidPage(
  fluidRow(
      column(width = 3,
    selectInput("chip_select", "ChIP-seq:",
                choices = c("AlgR"))),
      column(width =8,
             h4("You could download all the data here."),
             downloadButton("Download_ChIP",label = "Download",icon = icon("download")))
    
  ),
  
  tabsetPanel(
      tabPanel("chart",verbatimTextOutput("chip_tf",placeholder = FALSE),simpleNetworkOutput("chip_chart")),
      tabPanel("data",br(),dataTableOutput("chip",width="100%")))
  )

HT_page<-fluidPage(
  fluidRow(
    column(width = 3,
           selectInput("HT_select", "HT_SELEX:",
                       choices = c("AlgR"))),
    column(width =8,             
           h4("You could download all the data here."),
           downloadButton("Download_HT",label = "Download",icon = icon("download")))
    
  ),
  
    tabsetPanel(
      tabPanel("chart",verbatimTextOutput("HT_tf",placeholder = FALSE),simpleNetworkOutput("HT_chart")),
      tabPanel("data",br(),dataTableOutput("HT"))
    )
)
