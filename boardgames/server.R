library(shiny)
library(shinyWidgets)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    # UI elements for filters
    output$players <- renderUI({
        sliderInput(
            inputId = "players", label = "Select number of players",
            value = c(0, 99), min = param_min_player, max = param_max_player
        )
    })
    output$play_time <- renderUI({
        numericInput(
            inputId = "play_time",
            label = "Enter average play time (minutes)",
            value = 0
        )
    })
    output$min_age <- renderUI({
        sliderInput(
            inputId = "min_age", label = "Select minimum age",
            value = 0, min = 0, max = 50
        )
    })
    output$year <- renderUI({
        airYearpickerInput(
            inputId = "year",
            label = "Select publication year interval",
            value = c(as.Date(paste0(min(df$year_published), "-01-01")), as.Date(paste0(max(df$year_published), "-01-01"))),
            range = T,
            minDate = as.Date(paste0(min(df$year_published), "-01-01")),
            maxDate = as.Date(paste0(max(df$year_published), "-01-01")),
            autoClose = T
        )
    })
    output$categories <- renderUI({
        multiInput(
            inputId = "categories",
            label = "Select categories", 
            choices = cats,
            choiceNames = cats,
            choiceValues = cats
        )
    })
    output$rating <- renderUI({
        knobInput(
            inputId = "rating",
            label = "Select minimum rating",
            value = 0,
            min = 0,
            displayPrevious = T,
            lineCap = "round",
            fgColor = "#428BCA",
            inputColor = "#428BCA"
        )
    })
    
    # Reactive Values for filtering
    params <- reactiveValues()
    observeEvent(input$tabset1, {
        params$min_player <- input$players[1]
        params$max_player <- input$players[2]
        params$play_time <- input$play_time
        params$min_age <- input$min_age
        params$year <- input$year
        params$categories <- input$categories
        params$rating <- input$rating
    })
    
    # Return the filtered DF as a separate UI element
    output$recos <- renderDataTable({
        df_display <- filter_df(df, params)
        return(df_display)
    })
    
    # output$test <- renderText(params$categories)
})
