# Load the required packages if not installed
    packages = c("shiny", "manhattanly", "shinyFiles", "plotly")
    package.check <- lapply(packages, FUN = function(x) {
     if (!require(x, character.only = TRUE)) {
        install.packages(x, dependencies = TRUE)
        library(x, character.only = TRUE)
      }
   })
# Load the required packages  
library(shiny)
library(shinyFiles)
library(manhattanly)
library(plotly)

shinyServer(function(input, output, session) {
  shinyFileChoose(input, 'file', roots=c(wd='/srv/shiny-server'), filetypes=c('', 'csv'))
  shinySaveButton("save", "Save file", "Save file as ...", filetype=c('', "csv"))
  output$contents <- renderDataTable({
    inFile <- parseFilePaths(roots=c(wd='/srv/shiny-server'), input$file)
    if( NROW(inFile)) {
      df <- read.csv(as.character(inFile$datapath),
                     header = input$header,
                     sep = input$sep,
                     quote = input$quote)
      if(input$disp == "head") {
        return(head(df))
      }
      else {
        return(df)
      }
    }
  })


  output$summary <- renderPrint({
    inFile <- parseFilePaths(roots=c(wd='/srv/shiny-server'), input$file)
    if( NROW(inFile)) {
      df <- read.csv(as.character(inFile$datapath),
                     header = input$header,
                     sep = input$sep,
                     quote = input$quote)

      summary(df)
    }
  })

  output$plt <- renderPlotly({
    inFile <- parseFilePaths(roots=c(wd='/srv/shiny-server'), input$file)
    if( NROW(inFile)) {
      df <- read.csv(as.character(inFile$datapath),
                     header = input$header,
                     sep = input$sep,
                     quote = input$quote)
      if(input$sho == "yes") {
        manh2 <- manhattanr(df, chr = "chrom", bp = "pos", p = "P", snp = "marker")
        manhattanly(manh2, col=c("#D2691E","#800080","#6495ED","#9ACD32"), point_size=7, showlegend = FALSE,
                    xlab = "Chromosome", ylab = "-log10(p)", suggestiveline_color = "blue", suggestiveline_width = 2,
                    genomewideline =FALSE, title = "")
      }
      
    }
  })

})