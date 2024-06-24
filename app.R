# Importing the ui and server file
source("server.R")
source("ui.R")

# Create the App
shinyApp(ui = ui, server = server)