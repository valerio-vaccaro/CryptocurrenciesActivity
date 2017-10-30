## ui.R ##
library(shinydashboard)
library(leaflet)

ui <- dashboardPage(
        dashboardHeader(title = "Cryptocurrencies" ),
        
        ## Sidebar content
        dashboardSidebar(
                sidebarMenu(
                        menuItem("Bitcoin dashboard", tabName = "bitcoin_dashboard", icon = icon("dashboard")),
                        menuItem("Ethereum dashboard", tabName = "ethereum_dashboard", icon = icon("dashboard")),
                        menuItem("Wallet transactions", tabName = "wallet", icon = icon("dashboard")),
                        menuItem("Credits", tabName = "credits", icon = icon("th"))
                )
        ),
        dashboardBody(
                tabItems(
                        # dashboard content
                        tabItem(tabName = "bitcoin_dashboard",
                                fluidRow(
                                        infoBoxOutput("dateBox"),
                                        infoBoxOutput("speedBox"),
                                        infoBoxOutput("pulseBox")
                                ),
                                fluidRow(
                                        box(title = "Monthly activity", status = "primary", solidHeader = TRUE,
                                            plotOutput("ma", height = 300) ),
                                        box(title = "Monthly histogram", status = "primary", solidHeader = TRUE,
                                            plotOutput("mh", height = 300) ) 
                                ),
                                fluidRow(
                                        box(title = "Daily activity", status = "primary", solidHeader = TRUE,
                                            plotOutput("da", height = 300) ),
                                        box(title = "Daily histogram", status = "primary", solidHeader = TRUE,
                                            plotOutput("dh", height = 300) )
                                )
                                
                        ),
                        # dashboard content
                        tabItem(tabName = "ethereum_dashboard",
                                fluidRow(
                                  infoBoxOutput("ethdateBox"),
                                  infoBoxOutput("ethspeedBox"),
                                  infoBoxOutput("ethpulseBox")
                                ),
                                fluidRow(
                                  box(title = "Monthly activity", status = "primary", solidHeader = TRUE,
                                      plotOutput("ethma", height = 300) ),
                                  box(title = "Monthly histogram", status = "primary", solidHeader = TRUE,
                                      plotOutput("ethmh", height = 300) ) 
                                ),
                                fluidRow(
                                  box(title = "Daily activity", status = "primary", solidHeader = TRUE,
                                      plotOutput("ethda", height = 300) ),
                                  box(title = "Daily histogram", status = "primary", solidHeader = TRUE,
                                      plotOutput("ethdh", height = 300) )
                                )
                                
                        ),
                        # wallet content
                        tabItem(tabName = "wallet",
                                fluidRow(
                                   box(title = "Wallet", status = "primary", solidHeader = TRUE, width = 12,
                                       textInput("wallet", "Wallet", "1HB5XMLmzFVj8ALj6mfBsbifRoD4miY36v"),
                                       dataTableOutput('wallet'))
                                ),
                                fluidRow(
                                   box(title = "Transactions", status = "primary", solidHeader = TRUE, width = 12,
                                       plotOutput("pl", height = 300),
                                       dataTableOutput('transactions'))
 
                                )
                                
                        ),
                        # credits content
                        tabItem(tabName = "credits",
                                h2("Cryptocurrencies activity"),
                                "Cryptocurrencies activity is a dashboard developed in R and shiny and able to show:", br(),
                                "- the value of one bitcoin/ethereum in EUR and USD in the last 24 hours and in last 30 days", br(),
                                "- the transactions connected with one bitcoin wallet address",
                                br(),"Valerio Vaccaro", a("http://www.valeriovaccaro.it")
                        )
                )
        )
)

