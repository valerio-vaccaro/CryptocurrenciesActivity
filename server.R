# server.R
library(ggplot2)
library(grid)
library(stringr)
#library(leaflet)
library(RJSONIO)
library(Rbitcoin)
library(plyr)
library(igraph)

# Get data
temp <- fromJSON("https://apiv2.bitcoinaverage.com/indices/global/history/BTCUSD?period=daily&format=json")
temp <- do.call(rbind,temp)
data.BTCUSD.daily <- as.data.frame(temp,stringsAsFactors=FALSE)
data.BTCUSD.daily$time <- as.POSIXct(unlist(data.BTCUSD.daily$time))
data.BTCUSD.daily$average <- unlist(data.BTCUSD.daily$average)
data.BTCUSD.daily$cur <- "USD"

temp <- fromJSON("https://apiv2.bitcoinaverage.com/indices/global/history/BTCEUR?period=daily&format=json")
temp <- do.call(rbind,temp)
data.BTCEUR.daily <- as.data.frame(temp,stringsAsFactors=FALSE)
data.BTCEUR.daily$time <- as.POSIXct(unlist(data.BTCEUR.daily$time))
data.BTCEUR.daily$average <- unlist(data.BTCEUR.daily$average)
data.BTCEUR.daily$cur <- "EUR"

temp <- fromJSON("https://apiv2.bitcoinaverage.com/indices/global/history/BTCUSD?period=monthly&format=json")
temp <- do.call(rbind,temp)
data.daily <- rbind(data.BTCUSD.daily, data.BTCEUR.daily)
data.BTCUSD.monthly <- as.data.frame(temp,stringsAsFactors=FALSE)
data.BTCUSD.monthly$time <- as.POSIXct(unlist(data.BTCUSD.monthly$time))
data.BTCUSD.monthly$average <- unlist(data.BTCUSD.monthly$average)
data.BTCUSD.monthly$cur <- "USD"

temp <- fromJSON("https://apiv2.bitcoinaverage.com/indices/global/history/BTCEUR?period=monthly&format=json")
temp <- do.call(rbind,temp)
data.BTCEUR.monthly <- as.data.frame(temp,stringsAsFactors=FALSE)
data.BTCEUR.monthly$time <- as.POSIXct(unlist(data.BTCEUR.monthly$time))
data.BTCEUR.monthly$average <- unlist(data.BTCEUR.monthly$average)
data.BTCEUR.monthly$cur <- "EUR"
data.monthly <- rbind(data.BTCUSD.monthly[, c("average","time","cur")], data.BTCEUR.monthly[, c("average","time","cur")])

act_eur <- data.BTCEUR.daily[1, ]$average
act_usd <- data.BTCUSD.daily[1, ]$average
daily_eur <- round(mean(data.BTCEUR.daily$average), digits = 2)
daily_usd <- round(mean(data.BTCUSD.daily$average), digits = 2)
monthly_eur <- round(mean(data.BTCEUR.monthly$average), digits = 2)
monthly_usd <- round(mean(data.BTCUSD.monthly$average), digits = 2)

# Get data
temp <- fromJSON("https://apiv2.bitcoinaverage.com/indices/global/history/ETHUSD?period=daily&format=json")
temp <- do.call(rbind,temp)
data.ETHUSD.daily <- as.data.frame(temp,stringsAsFactors=FALSE)
data.ETHUSD.daily$time <- as.POSIXct(unlist(data.ETHUSD.daily$time))
data.ETHUSD.daily$average <- unlist(data.ETHUSD.daily$average)
data.ETHUSD.daily$cur <- "USD"

temp <- fromJSON("https://apiv2.bitcoinaverage.com/indices/global/history/ETHEUR?period=daily&format=json")
temp <- do.call(rbind,temp)
data.ETHEUR.daily <- as.data.frame(temp,stringsAsFactors=FALSE)
data.ETHEUR.daily$time <- as.POSIXct(unlist(data.ETHEUR.daily$time))
data.ETHEUR.daily$average <- unlist(data.ETHEUR.daily$average)
data.ETHEUR.daily$cur <- "EUR"

temp <- fromJSON("https://apiv2.bitcoinaverage.com/indices/global/history/ETHUSD?period=monthly&format=json")
temp <- do.call(rbind,temp)
ethdata.daily <- rbind(data.ETHUSD.daily, data.ETHEUR.daily)
data.ETHUSD.monthly <- as.data.frame(temp,stringsAsFactors=FALSE)
data.ETHUSD.monthly$time <- as.POSIXct(unlist(data.ETHUSD.monthly$time))
data.ETHUSD.monthly$average <- unlist(data.ETHUSD.monthly$average)
data.ETHUSD.monthly$cur <- "USD"

temp <- fromJSON("https://apiv2.bitcoinaverage.com/indices/global/history/ETHEUR?period=monthly&format=json")
temp <- do.call(rbind,temp)
data.ETHEUR.monthly <- as.data.frame(temp,stringsAsFactors=FALSE)
data.ETHEUR.monthly$time <- as.POSIXct(unlist(data.ETHEUR.monthly$time))
data.ETHEUR.monthly$average <- unlist(data.ETHEUR.monthly$average)
data.ETHEUR.monthly$cur <- "EUR"
ethdata.monthly <- rbind(data.ETHUSD.monthly[, c("average","time","cur")], data.ETHEUR.monthly[, c("average","time","cur")])

eth_act_eur <- data.ETHEUR.daily[1, ]$average
eth_act_usd <- data.ETHUSD.daily[1, ]$average
eth_daily_eur <- round(mean(data.ETHEUR.daily$average), digits = 2)
eth_daily_usd <- round(mean(data.ETHUSD.daily$average), digits = 2)
eth_monthly_eur <- round(mean(data.ETHEUR.monthly$average), digits = 2)
eth_monthly_usd <- round(mean(data.ETHUSD.monthly$average), digits = 2)



server <- function(input, output) {

        output$dateBox <- renderInfoBox({
                infoBox(
                        "Monthly average", paste(monthly_eur,"EUR"),paste(monthly_usd, "USD"), icon = icon("calendar"),
                        color = "green"
                )
        })

        output$speedBox <- renderInfoBox({
                infoBox(
                        "Daily average",  paste(daily_eur,"EUR"),paste(daily_usd, "USD"), icon = icon("road"),
                        color = "yellow"
                )
        })

        output$pulseBox <- renderInfoBox({
                infoBox(
                        "Actual value",  paste(act_eur,"EUR"),paste(act_usd, "USD"), icon = icon("heart"),
                        color = "red"
                )
        })

        output$ethdateBox <- renderInfoBox({
          infoBox(
            "Monthly average", paste(eth_monthly_eur,"EUR"),paste(eth_monthly_usd, "USD"), icon = icon("calendar"),
            color = "green"
          )
        })
        
        output$ethspeedBox <- renderInfoBox({
          infoBox(
            "Daily average",  paste(eth_daily_eur,"EUR"),paste(eth_daily_usd, "USD"), icon = icon("road"),
            color = "yellow"
          )
        })
        
        output$ethpulseBox <- renderInfoBox({
          infoBox(
            "Actual value",  paste(eth_act_eur,"EUR"),paste(eth_act_usd, "USD"), icon = icon("heart"),
            color = "red"
          )
        })
        
        output$ma <- renderPlot({
           ggplot(data.monthly, aes(x=time, color=cur)) +
              geom_line(aes(y=average)) +
              geom_hline(aes(yintercept=act_eur), color="red", linetype="dotted")+
              geom_hline(aes(yintercept=act_usd), color="red", linetype="dashed")+
              geom_hline(aes(yintercept=daily_eur), color="yellow", linetype="dotted")+
              geom_hline(aes(yintercept=daily_usd), color="yellow", linetype="dashed")+
              geom_hline(aes(yintercept=monthly_eur), color="green", linetype="dotted")+
              geom_hline(aes(yintercept=monthly_usd), color="green", linetype="dashed")
        })

        output$mh <- renderPlot({
           ggplot(data.monthly, aes(x=average, fill=cur)) +
              geom_histogram() +
              scale_y_continuous(labels = scales::percent)
          
        })

        output$da <- renderPlot({
           ggplot(data.daily, aes(x=time, color=cur)) +
              geom_line(aes(y=average)) +
              geom_hline(aes(yintercept=act_eur), color="red", linetype="dotted")+
              geom_hline(aes(yintercept=act_usd), color="red", linetype="dashed")+
              geom_hline(aes(yintercept=daily_eur), color="yellow", linetype="dotted")+
              geom_hline(aes(yintercept=daily_usd), color="yellow", linetype="dashed")+
              geom_hline(aes(yintercept=monthly_eur), color="green", linetype="dotted")+
              geom_hline(aes(yintercept=monthly_usd), color="green", linetype="dashed")
        })

        output$dh <- renderPlot({
           ggplot(data.daily, aes(x=average, fill=cur)) +
              geom_histogram() +
              scale_y_continuous(labels = scales::percent)
        })
        
        output$ethma <- renderPlot({
          ggplot(ethdata.monthly, aes(x=time, color=cur)) +
            geom_line(aes(y=average)) +
            geom_hline(aes(yintercept=eth_act_eur), color="red", linetype="dotted")+
            geom_hline(aes(yintercept=eth_act_usd), color="red", linetype="dashed")+
            geom_hline(aes(yintercept=eth_daily_eur), color="yellow", linetype="dotted")+
            geom_hline(aes(yintercept=eth_daily_usd), color="yellow", linetype="dashed")+
            geom_hline(aes(yintercept=eth_monthly_eur), color="green", linetype="dotted")+
            geom_hline(aes(yintercept=eth_monthly_usd), color="green", linetype="dashed")
        })
        
        output$ethmh <- renderPlot({
          ggplot(ethdata.monthly, aes(x=average, fill=cur)) +
            geom_histogram() +
            scale_y_continuous(labels = scales::percent)
        })
        
        output$ethda <- renderPlot({
          ggplot(ethdata.daily, aes(x=time, color=cur)) +
            geom_line(aes(y=average)) +
            geom_hline(aes(yintercept=eth_act_eur), color="red", linetype="dotted")+
            geom_hline(aes(yintercept=eth_act_usd), color="red", linetype="dashed")+
            geom_hline(aes(yintercept=eth_daily_eur), color="yellow", linetype="dotted")+
            geom_hline(aes(yintercept=eth_daily_usd), color="yellow", linetype="dashed")+
            geom_hline(aes(yintercept=eth_monthly_eur), color="green", linetype="dotted")+
            geom_hline(aes(yintercept=eth_monthly_usd), color="green", linetype="dashed")
        })
        
        output$ethdh <- renderPlot({
          ggplot(ethdata.daily, aes(x=average, fill=cur)) +
            geom_histogram() +
            scale_y_continuous(labels = scales::percent)
        })
        
        output$pl <- renderPlot({
           seed <- input$wallet
           singleaddress <- blockchain.api.query(method = 'Single Address', bitcoin_address = seed, limit=10000)
           txs <- singleaddress$txs
           bc <- data.frame()
           for (t in txs) {
              hash <- t$hash
              for (inputs in t$inputs) {
                 from <- inputs$prev_out$addr
                 for (out in t$out) {
                    to <- out$addr
                    va <- out$value
                    bc <- rbind(bc, data.frame(from=from,to=to,value=va, stringsAsFactors=F))
                 }
              }
           }
           
           
           btc <- ddply(bc, c("from", "to"), summarize, value=sum(value))
           btc.net <- graph.data.frame(btc, directed=T)
           V(btc.net)$color <- "blue"
           V(btc.net)$color[unlist(V(btc.net)$name) == seed] <- "red"
           nodes <- unlist(V(btc.net)$name)
           E(btc.net)$width <- log(E(btc.net)$value)/10
           plot.igraph(btc.net, vertex.size=5, edge.arrow.size=0.1, vertex.label=NA, main=paste("BTC transaction network for\n", seed))
           
        })
        
        output$wallet <- renderDataTable({
            blockchain.api.process(input$wallet)
        })
        
        output$transactions <- renderDataTable({
           seed <- input$wallet
           singleaddress <- blockchain.api.query(method = 'Single Address', bitcoin_address = seed, limit=10000)
           txs <- singleaddress$txs
           bc <- data.frame()
           for (t in txs) {
              hash <- t$hash
              for (inputs in t$inputs) {
                 from <- inputs$prev_out$addr
                 for (out in t$out) {
                    to <- out$addr
                    va <- out$value
                    bc <- rbind(bc, data.frame(from=from,to=to,value=va, stringsAsFactors=F))
                 }
              }
           }
           bc
        })
            
}