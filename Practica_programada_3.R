library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(readr)

datos_spotify <- read.csv2("datos/spotify_2000_2023.csv", header = TRUE)

ui <- dashboardPage(
  skin = "purple",
  dashboardHeader(title = "Análisis de Spotify"),
  dashboardSidebar(
    sidebarMenu(
      selectInput(inputId = "year",
                  label = "Año",
                  choices = unique(datos_spotify$year),
                  selected = unique(datos_spotify$year)[1]),  
      selectInput(inputId = "top.genre",
                  label = "Género",
                  choices = unique(datos_spotify$top.genre),
                  selected = unique(datos_spotify$top.genre)[1]),
      style = "text-align: center;",
      downloadButton("descargar_datos", "Descargar Datos")
    )
  ),
  dashboardBody(
    fluidRow(
      column(width = 5, plotOutput("grafico_1")),
      column(width = 7,  dataTableOutput("table_1"), 
             label = "Tabla")
    )
  )
)

server <- function(input, output, session) {
  filtered_data <- reactive({
    datos_spotify |> 
      filter(year == input$year, top.genre == input$top.genre)
  })
  
  output$grafico_1 <- renderPlot({
    ggplot(data = filtered_data(), aes(x = bpm, y = popularity)) +
      geom_point() +
      theme_classic()
  })
  
  output$table_1 <- renderDataTable({
    filtered_data()
  })
  
  output$descargar_datos <- downloadHandler(
    filename = function() {
      paste("datos_", input$top.genre, "_", input$year, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(filtered_data(), file, row.names = FALSE)
    }
  )
}

shinyApp(ui, server)
