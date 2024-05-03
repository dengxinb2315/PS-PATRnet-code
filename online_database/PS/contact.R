source('config.R')

contact_page <- fluidPage(
  includeMarkdown(con_path)
)