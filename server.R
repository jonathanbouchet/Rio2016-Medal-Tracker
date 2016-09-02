library(shiny)
library(ggplot2)

#read dataset 
df<-read.csv('Rio-ALL.csv',sep=',')
df$gold<-as.numeric(as.character(df$gold))

# Define a server for the Shiny app
shinyServer(function(input, output) {

#save the summary of medals for the selected country
#returns a ggplot  
out<-reactive({
	med<-t(df[df$country == input$countryInput & df$date == '2016-08-21', 4:6])
	colnames(med)<-c('count')
	d <- med
	names <- rownames(d)
	rownames(d) <- NULL
	data <- cbind(names,d)
	data<-as.data.frame(data)
	data$count<-as.numeric(levels(data$count))[data$count]
	colnames(data)<-c('type','count')
	data<-data[order(data$type),]
	colors <- c('orange','gold','grey')
	tempo<-ggplot(data, aes(x=type, y=data[,2]))+geom_bar(fill=colors,width = .1, stat = "identity") + ylab('') + xlab('') + theme(axis.text.x = element_text(hjust=1,size=20)) + 	theme(axis.text.y = element_text(size=20)) + theme(plot.title = element_text(lineheight=.8,face="bold",size=20)) + ggtitle('total number of medals') + theme(plot.title  =element_text(lineheight=.8,face="bold",size=20))
	return(tempo)
})

#save the details for a selected country
#return a dataframe
dataOut<-reactive({
	selectedCountry<-df[df$country == input$countryInput, c(2,4,5,6,7)]
	return(selectedCountry)
  })
  
output$myplot<-renderPlot({
  	ggplot(df[df$country == input$countryInput, ], aes(date, y = value, color = variable)) + 
  	geom_point(aes(y=total,color='black'),size=5,data=subset(df,country==input$countryInput)) + geom_point(aes(y=gold,color='gold'),pch=1,stroke=2,size=5,data=subset(df,country==input$countryInput)) + 
  	geom_point(aes(y=silver,color='grey'),pch=2,stroke=2,size=5,data=subset(df,country==input$countryInput)) + 
  	geom_point(aes(y=bronze,color='orange'),pch=6,stroke=2,size=5,data=subset(df,country==input$countryInput)) + 
  	labs(x='',y='') + theme(axis.text.x = element_text(angle=90, hjust=1,size=20)) + 
  	theme(axis.text.y = element_text(size=20)) + ggtitle('medals per day') + 
  	theme(plot.title = element_text(lineheight=.8,face="bold",size=20)) + 
  	theme(legend.justification=c(0,0), legend.position=c(0,.6)) + 
  	scale_colour_manual(values = c("black", "gold","grey","orange"),labels = c("Total", "Gold","Silver","Bronze"),name='') + 
  	guides(colour = guide_legend(override.aes = list(shape = c(19, 1, 2, 6))))+
  	theme(legend.text = element_text(size = 20))
	})
		
output$myplot2<-renderPlot({
	out()
	})
	
output$view<-renderTable({
	print(dataOut())
    })
})