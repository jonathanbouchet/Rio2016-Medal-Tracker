library(shiny)
library(ggplot2)
library(dplyr)

#read dataset 
df<-read.csv('Rio-ALL.csv',sep=',')
df$gold<-as.numeric(as.character(df$gold))
good<-!is.na(df$gold)
df<-df[good,]
cc<-as.character(unique(df$country))

# Define the overall UI
shinyUI(
	# Use a fluid Bootstrap layout
	fluidPage(
		# Give the page a title
		titlePanel('Medals per country in Rio 2016 Olympic games'),
		
			# Generate a row with a sidebar
			sidebarLayout(
				# Define the sidebar with one input
				sidebarPanel(
					selectInput('countryInput','Country',choices=cc),
					hr(),
       				helpText("Select a country")
							),
			# Create a spot for the barplot
			mainPanel(
				tabsetPanel(
				tabPanel('plot',plotOutput('myplot'),plotOutput('myplot2')),
				tabPanel('data',tableOutput('view'))
            	)
            )
		)
	)
)