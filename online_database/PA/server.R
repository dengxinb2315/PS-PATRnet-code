library(shiny)
library(shinythemes)
library(shinycssloaders)
library(shinydashboard)
library(DT)
library(dplyr)
library(igraph)
library(markdown)
library(networkD3)
source('introduction.R')
source('data.R')
source('help.R')
source('contact.R')

# Define server logic required to draw a histogram
function(input, output, session){
  ##load data from db
  ChIP_seq<-read.csv("ChIP_seq.csv")
  ChIP_seq<-na.omit(ChIP_seq)
  chip_col<-ChIP_seq$tf_ID
  
  HT_SELEX <-read.csv("HT_SELEX.csv", row.names = 1)
  for(i in 1:length(HT_SELEX$annoInfo)){
    HT_SELEX$annoInfo[i] <- strsplit(HT_SELEX$annoInfo[i],split = "[\\||_|.]")[[1]][1]
    
  }
  HT_col <- HT_SELEX$tf_ID
  ##Draw graph
  network <- function(data){
    if(nrow(data)>50){
      data<-data[sample(nrow(data),50),]
    }
    simpleNetwork(data, height="100px", width="100px",        
                  Source = 1,                 # column number of source
                  Target = 2,                 # column number of target
                  linkDistance = 15,          # distance between node. Increase this value to have more space between nodes
                  charge = -900,                # numeric value indicating either the strength of the node repulsion (negative value) or attraction (positive value)
                  fontSize = 10,               # size of the node names
                  fontFamily = "sans-serif",       # font og node names
                  linkColour = "#666",        # colour of edges, MUST be a common colour for the whole graph
                  nodeColour = "#69b3a2",     # colour of nodes, MUST be a common colour for the whole graph
                  opacity = 0.9,              # opacity of nodes. 0=transparent. 1=no transparency
                  zoom = T                    # Can you zoom on the figure?
    )
  }
  
  ## update data for chip_seq
  updateSelectInput(session = getDefaultReactiveDomain(), "chip_select",
                    choices = chip_col
  )
  
  observeEvent(input$chip_select,{
    
    chip_seq_selected<-ChIP_seq[ChIP_seq[,1] == input$chip_select,]
    
    chip_chart_data <- chip_seq_selected[,c("tf_ID","locus_tag")]
    
    output$chip_chart <-renderSimpleNetwork({
      network(chip_chart_data)
    })
    
    output$chip <- DT::renderDataTable({
      DT::datatable(chip_seq_selected, filter = "top", options = list(pageLength = 15,scrollX = TRUE))
    })
  })
  
  output$Download_ChIP <- downloadHandler(
    filename = function() {
      paste("ChIP_seq", ".csv", sep = "")
    },
    content = function(file) {
      write.csv(ChIP_seq, file, row.names = FALSE)
    }
  )
  
  ##update data for HT
  updateSelectInput(session = getDefaultReactiveDomain(), "HT_select",
                    choices = HT_col
  )
  
  observeEvent(input$HT_select,{
    
    HT_SELEX_selected<-HT_SELEX[HT_SELEX[,1] == input$HT_select,]
    
    HT_chart_data <- HT_SELEX_selected[,c("tf_ID","annoInfo")]
    
    output$HT_chart <-renderSimpleNetwork({
      network(HT_chart_data)
    })
    
    output$HT <- DT::renderDataTable({
      DT::datatable(HT_SELEX_selected, filter = "top", options =  list(pageLength = 15))
    })
  })
  
  output$Download_HT <- downloadHandler(
    filename = function() {
      paste("HT_SELEX", ".csv", sep = "")
    },
    content = function(file) {
      print(file)
      write.csv(HT_SELEX, file, row.names = FALSE)
    }
  )
}