library(Rcrawler)
library(rvest)
url[1] <- 'http://www.iimlincubator.com/jan-elaaj'
url[2] <- 'http://www.iimlincubator.com/hypothyzer'
url[3] <- 'http://www.iimlincubator.com/techny-birds'
url[4] <- 'http://www.iimlincubator.com/target-plus'

for(i in 1:4)
{webpage[i] <- read_html(url[i])

title_data_html[i] <- html_nodes(webpage[i],'body > div.body > div > div > div:nth-child(2) > div.col-md-8')

title_data[i] <- html_text(title_data_html[i])
title_data[i] <- gsub("\n","",title_data[i])
title_data[i] <- gsub("\t","",title_data[i])
title_data[i]
i = i +1
}

titles <- title_data

write.csv(titles, "C:/Users/debapriyag/Documents/IIMB.csv")

description_data_html <- html_nodes(webpage, 'div')

description_data <- html_text(description_data_html)
description_data<-gsub("\n","",description_data)
description_data<-gsub("\t","",description_data)
description1 <- description_data