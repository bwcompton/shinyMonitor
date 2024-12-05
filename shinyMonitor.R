



library(rsconnect)
library(RCurl)
library(dygraphs)

cpu <- showMetrics('docker_container_cpu', c('usage_in_usermode'), server = 'shinyapps.io', account = 'umassdsl', appName = 'EcoAssess', from = '90d', interval = '1m')
dygraph(cpu) |>
   dySeries('usage_in_usermode')

connects <- showMetrics('container_status', c('connect_count', 'connect_procs'), server = 'shinyapps.io', account = 'umassdsl', appName = 'EcoAssess', from = '90d', interval = '1m')
#memory <- showMetrics('docker_container_mem', 'total_rss', server = 'shinyapps.io', account = 'umassdsl', appName = 'EcoAssess', from = '90d', interval = '1m')
#connects <- cbind(connects, memory)
dygraph(connects) |>
   dySeries('connect_count', label = 'Connections') |>
   dySeries('connect_procs', label = 'Workers') 
# |>
#    dySeries('total_rss', label = 'Total memory')
#    
#    


# save everything for train
connects <- showMetrics('container_status', c('connect_count', 'connect_procs'), server = 'shinyapps.io', account = 'umassdsl', appName = 'EcoAssess', from = '90d', interval = '1m')
memory <- showMetrics('docker_container_mem', 'total_rss', server = 'shinyapps.io', account = 'umassdsl', appName = 'EcoAssess', from = '90d', interval = '1m')
network <- showMetrics('docker_container_net', c('tx_bytes', 'rx_bytes'), server = 'shinyapps.io', account = 'umassdsl', appName = 'EcoAssess', from = '90d', interval = '1m')
cpu <- showMetrics('docker_container_cpu', 'usage_in_usermode', server = 'shinyapps.io', account = 'umassdsl', appName = 'EcoAssess', from = '90d', interval = '1m')
saveRDS(list(cpu = cpu, memory = memory, network = network, connects = connects), 'c:/work/r/shinyMonitor/inst/data.RDS')

# load everything
x <- readRDS('c:/work/r/shinyMonitor/inst/data.RDS')
cpu <- x$cpu
memory <- x$memory
network <- x$network
connects <- x$connects



'do.plot' <- function() {
   connects <- showMetrics('container_status', c('connect_count', 'connect_procs'), server = 'shinyapps.io', account = 'umassdsl', appName = 'EcoAssess', from = '90d', interval = '1m')
   dygraph(connects) |>
      dySeries('connect_count', label = 'Connections') |>
      dySeries('connect_procs', label = 'Workers') 
   
}