library(shiny)
library(shinyalert)
library(shinycssloaders)
library(shinythemes)
library(shinydashboard)
library(shinyWidgets)

shinyUI(dashboardPage(
    dashboardHeader(title = "Boardgames"),
    dashboardSidebar(
        sidebarMenu(
            menuItem('Boardgame Recommendation', tabName = 'reco', icon = icon("chess-knight")),
            menuItem('History', tabName = 'history', icon = icon("dice"))
        )
    ),
    dashboardBody(
        # TODO: will I need shiny alert?
        # useShinyalert(),
        tabItems(
        tabItem(tabName = 'reco',
                fluidRow(
                    tabBox(
                        title = "Boardgame Recommendation",
                        id = "tabset1", 
                        width = "12",
                        tabPanel("Select Parameters", 
                                 fluidRow(column(12, 'Choose your filters, then click on Recommendation tab to see results.')),
                                 fluidRow(
                                     column(4, uiOutput('players')),
                                     column(4, uiOutput('rating')),
                                     column(4, uiOutput('min_age'))
                                 ),
                                 fluidRow(
                                     column(4, uiOutput('categories')),
                                     column(4, uiOutput('play_time')),
                                     column(4, uiOutput('year'))
                                 )),
                                 # Use a button to update the filters
                                 # fluidRow(
                                 #     column(1, actionButton('params_update', 'Filter'), offset = 11)
                                 # )),
                        tabPanel("Recommendation", dataTableOutput("recos"))
                    ))),
                # uiOutput('players')),
        tabItem(tabName = 'history',
                h1('hello CEU'))#,
                # verbatimTextOutput('test'))
        )

    )
))

