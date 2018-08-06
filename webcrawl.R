library(Rcrawler)
library(rvest)
url <- 'http://www.nsrcel.org/portfolio/our-incubatees/?by_author=&sort=alphabetical&filter_category=&filter_tag='
webpage <- read_html(url)


title_data_html <- html_nodes(webpage,'article > section > div > h2')


title_data <- html_text(title_data_html)
titles <- title_data

write.csv(titles, "C:/Users/debapriyag/Documents/IIMB.csv")

description_data_html <- html_nodes(webpage, 'div')

description_data <- html_text(description_data_html)
description_data<-gsub("\n","",description_data)
description_data<-gsub("\t","",description_data)
description1 <- description_data
class(description1)
write.csv(description1, "C:/Users/debapriyag/Documents/IIMB2.csv", quote = TRUE)

description_data_html <- html_nodes(webpage, 'div > p:nth-child(2)')
description_data <- html_text(description_data_html)
write.csv(description_data, "C:/Users/debapriyag/Documents/IIMBdesc.csv", quote = TRUE)

#popmake-2843 > div > p:nth-child(1)




