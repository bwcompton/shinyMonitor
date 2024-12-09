# shinyMonitor - Monitor Shiny apps on shinyapps.io
# B. Compton, 9 Dec 2024



library(shiny)
library(bslib)
library(rsconnect)
library(RCurl)
library(dygraphs)
library(slider)
library(dplyr)
library(lubridate)
library(shinybusy)
library(shinyWidgets)
library(shinyjs)
library(bslib)
library(bsicons)


source('smPlot.R')

statisticChoices <- c('Connections' = 'connects', 'Memory' = 'mem', 'CPU' = 'cpu', 'Network' = 'net')
resolutionChoices <- c('1 sec' = '1s', '5 sec' = '5s', '10 sec' = '10s', '30 sec' = '30s', 
                      '1 min' = '1m', '5 min' = '5m', '10 min' = '10m', '1 hour' = '1h')



# User interface ---------------------
ui <- fluidPage(
   titlePanel('Shiny Monitor'),
   
   # theme = bs_theme(bootswatch = 'cosmo', version = 5),     # bslib version defense. Use version_default() to update
   theme = bs_theme(bootswatch = 'cerulean', version = 5),   # bslib version defense. Use version_default() to update
   
   useShinyjs(),
   
   
   add_busy_spinner(spin = 'fading-circle', position = 'bottom-left', onstart = FALSE, timeout = 500),
   
   card(
      fluidRow(
         column(width = 10,
                dygraphOutput('plot')
         )
      )
   ), 
   
   layout_column_wrap(
      width = 1/2, height = 400,
      
      card(
         selectInput('account', label = 'Account', choices = accounts()$name),
         
         selectInput('app', label = 'App', choices = NULL),
         #, choices =  applications(input$account)$name),
         
         sliderInput('period', label = 'Time period', min = 0, max = 0, value = c(0, 0)),
      ),
      card(
         selectInput('statistic', label = 'Statistic', choices = statisticChoices, selected = 'connects'),
         
         selectInput('resolution', label = 'Time resolution', choices = resolutionChoices, selected = '10m'),
         
         helpText('Last refreshed 5 min ago'),
         
         actionButton('refresh', 'Refresh data', width = '25%')
         
         
      )
   )
)



# Server -----------------------------
server <- function(input, output, session) {
   
   # bs_themer()                                                     # uncomment to select a new theme
   # print(getDefaultReactiveDomain())
   
   session$userData$init <- TRUE                                     # draw initial plot
   
   
   # observeEvent(input$period, {                                      # --- Period selected. Select site, year, and period
   #    session$userData$period <- as.POSIXct(input$period)
   #    session$userData$dataset <- data[data$Site_Year == input$Site_Year &
   #                                        data$Date_Time >= session$userData$period[1] & data$Date_Time <= session$userData$period[2], ]
   # })
   # 
   
   observeEvent(list(session$userData$init, input$refresh), {                                      # --- Download and plot data on init or refresh
      retrieving <- showNotification('Retrieving data...', duration = NULL, closeButton = FALSE)
      session$userData$data$connects <- showMetrics('container_status', c('connect_count', 'connect_procs'), 
                                                    server = 'shinyapps.io', account = 'umassdsl', appName = 'EcoAssess', 
                                                    from = '90d', interval = input$resolution)[, -1]
      removeNotification(retrieving)
      #data$connects <- connects
      
      xxdata <<- session$userData$data
      
      smPlot(session$userData$data, input, output, session = getDefaultReactiveDomain())
      #renderDygraph(smPlot(session$userData$data, input, output, session = getDefaultReactiveDomain())
      session$userData$init <- FALSE
   })
   
   
   # --- Replot data on changes
   #smPlot(session$userData$data, input, output, session = getDefaultReactiveDomain())
   
}

shinyApp(ui, server)
