chip_page<-fluidPage(
  fluidRow(
      column(width = 3,
    selectInput("chip_select", "ChIP-seq:",
                choices = c("AlgR"))),
      column(width =8,
             downloadButton("Download_ChIP",label = "Download",icon = icon("download")))
    
  ),
  tabsetPanel(
      tabPanel("chart",verbatimTextOutput("chip_tf",placeholder = FALSE),simpleNetworkOutput("chip_chart")),
      tabPanel("data",br(),dataTableOutput("chip",width = ))
    )
  )

HT_page<-fluidPage(
  fluidRow(
    column(width = 3,
           selectInput("SELEX_select", "SELEX:",
                       choices = c("AlgR"))),
    column(width =3,downloadButton("Download_HT",label = "Download",icon = icon("download")))
    
  ),
    tabsetPanel(
      tabPanel("chart",verbatimTextOutput("HT_tf",placeholder = FALSE),simpleNetworkOutput("HT_chart")),
      tabPanel("data",br(),dataTableOutput("HT"))
    )
)
