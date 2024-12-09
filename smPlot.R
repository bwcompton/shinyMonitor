'smPlot' <- function(data, input, output, session) {
   
   # Plot data for shinyMonitor
   # B. Compton, 9 Dec 2024
   
   
   
   output$plot <- renderDygraph({                                                      # --- time series plot
      dygraph(data$connects) |>
         dySeries('connect_count', label = 'Connections', color = '#3C2692') |>
         dySeries('connect_procs', label = 'Workers', color = '#DB5920') |>
         dyAxis('x', gridLineColor = '#D0D0D0') |>
         dyAxis('y', gridLineColor = '#D0D0D0', valueRange = c(-0.2, max(data$connects
                                                                         [, c('connect_count', 'connect_procs')]) + 0.2)) |>
         dyRangeSelector(retainDateWindow = TRUE) |>
         dyCrosshair(direction = 'vertical') |>
         dyLegend(show = 'always')
   })
}