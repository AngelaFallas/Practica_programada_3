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
    plotOutput("grafico_1")
  )
)

server <- function(input, output, session) {
  output$grafico_1 <- renderPlot({
    ggplot(data = datos_spotify) +
      geom_point(mapping = aes_string(x = "bpm", y = "popularity"))
  })
}

shinyApp(ui = ui, server = server)


#shinyApp(ui, server)
