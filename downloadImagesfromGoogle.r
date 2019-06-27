library("rjson")
library("httr")
library("filesstrings")

credentials<- fromJSON(file = "../credentials/google-search.json")
key <- credentials["apiKey"]
cx <- credentials ["searchEngineId"]
cs1<- "https://www.googleapis.com/customsearch/v1?key="
cs2<-"&googlehost=.de&num=1"
type <-"&searchType=image"
####################

num <- 10
q <- ("cat")
dir.create(q)

####################

query=paste(cs1,key,"&cx=",cx,"&q=",q,type,"&num=",num,cs2,sep ="")
web <- content(GET(query))
exportJson <- toJSON(web)
write(exportJson,"results.json")
items <- fromJSON(file ="results.json")

######################

i<-1
while (i< num){
  imageURL<- items$items[[i]]$link
  print(imageURL)
  rand = sample(1:100000, 1)
  nameImage <- paste(q,rand,".jpg",sep ="")
  print(nameImage)
  download.file(imageURL,nameImage,mode = "wb")
  file.move(nameImage,paste("./",q,sep="") )
  i = i+1
}


