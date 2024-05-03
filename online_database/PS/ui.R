#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(shinycssloaders)
library(shinydashboard)
library(DT)
library(dplyr)
library(igraph)
library(markdown)
library(networkD3)
source('config.R')
source('introduction.R')
source('data.R')
#source('help.R')
source('contact.R')

# Define UI for application that draws a histogram
dashboardPage(
  skin = color,
  dashboardHeader(title = em(title)),
  dashboardSidebar(
    hr(),
    sidebarMenu(id="tabs",
                menuItem("Introduction", tabName="Introduction", icon=icon("line-chart"),selected=TRUE),
                menuItem("Data",  icon = icon("table"),
                         menuSubItem("ChIP_seq", tabName = "ChIP_seq", icon = icon("angle-right")),
                         menuSubItem("HT_SELEX", tabName = "HT_SELEX", icon = icon("angle-right"))
                ),
                menuItem("Contact", tabName = "Contact", icon = icon("question"))
    ),
    hr()
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "Introduction",
              introducion_page
      ),
      tabItem(tabName = "ChIP_seq",
              chip_page
      ),

      tabItem(tabName = "HT_SELEX",
              HT_page
      ),
      
      tabItem(tabName = "Contact",
              contact_page
      )
      
    )
  )
)
