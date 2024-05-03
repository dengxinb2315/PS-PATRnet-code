introducion_page <- fluidPage(
  includeMarkdown("www/home.md"),
  div(style="display:flex; align-items: center;",
      img(src="ChIP-seq.jpg", style="width:49%; height:49%;"),
      img(src="HT-SELEX.jpg", style="width:49%; height:49%; margin-left: 2%"),
      ),
  
)