library(shiny)
library(ggplot2)
library(shinydashboard)
library(dplyr)
library(readxl)
library(ggplot2)
library(gapminder)
library(readr)
library(plotly)

datos_spotify <- read.csv2("datos/spotify_2000_2023.csv", header = TRUE)

ui <- dashboardPage(
  skin = "purple",
  dashboardHeader(title = "Análisis de Spotify"),
  dashboardSidebar(
    sidebarMenu(
      selectInput(inputId = "year",
                  label = "Año",
                  choices = unique(datos_spotify$year),
                  selected = unique(datos_spotify$year)[4]),
      selectInput(inputId = "top.genre",
                  label = "Género",
                  choices = unique(datos_spotify$top.genre),
                  selected = unique(datos_spotify$top.genre)[3])
    )
  ),
  dashboardBody(
    fluidRow(
      column(width = 6, plotOutput("grafico_1")),
      column(width = 6, tableOutput("table_1"), 
             label = "Tabla")
    )
  )
)

server <- function(input, output, session) {
  output$grafico_1 <- renderPlot({
    filtered_data <- datos_spotify[
      datos_spotify$year == input$year &
        datos_spotify$top.genre == input$top.genre, ]
    
    ggplot(data = filtered_data) +
      geom_point(mapping = aes(x = bpm, y = popularity)) +
      theme_classic()
  })
  top_popularity <- top_n(datos_spotify, n = input)
  output$table_1 <- renderTable({
    datos_spotify
  })
}

shinyApp(ui, server)
