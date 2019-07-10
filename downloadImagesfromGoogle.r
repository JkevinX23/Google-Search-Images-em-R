library("rjson")
library("httr")
library("filesstrings")
library('rvest')
library("RCurl")

getImages <- function(num,q){
  credentials<- fromJSON(file = "../credentials/google-search.json")
  key <- credentials["apiKey"]
  cx <- credentials ["searchEngineId"]
  cs1<- "https://www.googleapis.com/customsearch/v1?key="
  cs2<-"&googlehost=.de&num=1"
  type <-"&searchType=image"
  query=paste(cs1,key,"&cx=",cx,"&q=",q,type,"&num=",num,cs2,sep ="")
  web <- content(GET(query))
  exportJson <- toJSON(web)
  write(exportJson,"results.json")
  items <- fromJSON(file ="results.json")
  i<-1
  while (i< num){
    imageURL<- items$items[[i]]$link
    print(imageURL)
    rand = sample(1:100000, 1)
    nameImage <- paste(q,rand,".jpg",sep ="")
    print(nameImage)
    download.file(imageURL,nameImage,mode = "wb")
    file.move(nameImage,paste("./",q,"/images",sep="") )
    i = i+1
  }
}
getWikiLinks<- function(q,n){
  n=num
  wikiURL <- "https://pt.wikipedia.org/w/api.php?"
  action <-"query"
  list <-"search"
  srsearch <- q
  wlink<- paste(wikiURL,"action=",action,"&","list=",list,"&","srsearch=",srsearch,"&","format=json",sep="")
  wikiJson<- content(GET(wlink))
  forWrite <- file(paste(q,".txt",sep = ""),open = "wt",encoding = "UTF-8")
  way<- paste(q,".txt",sep = "")
  i=1
  sink(way)
  while(i<10){
    pageID<- wikiJson$query$search[[i]]$pageid
    urlFull<- paste(wikiURL,"action=",action,"&prop=info&pageids=",pageID,"&inprop=url|talkid","&format=json",sep="")
    fullWikiPage<- content(GET(urlFull))
    pageID<- toString(pageID)
    fullurl<-fullWikiPage$query$pages[[1]]$fullurl
      cat(fullurl)
      cat("\n")
    i <- i+1
  }
  sink()
  return (way);
}
getLines<-function(way)
{
  itens <-list()
  fileLinks<- file(way,"r")
  while ( TRUE ) {
    line <- readLines(fileLinks, n = 1)
    if ( length(line) == 0 ) {
      break
    }
    itens<-c(itens,line)
  }
  close(fileLinks)
  return (itens)
}

getHtmlText<- function(way)
{
  wayText<- paste("text_",way,sep = "") 
  links<-getLines(way)
  i<-1
  sink(wayText)
  while(i<length(links)){
    wikilink<- links[[i]]
    c<-read_html(wikilink)
    j<-1
    cssParth<-list()
    while(j<20){
      cssParth<-(paste('.mw-parser-output > p:nth-child(',j,')',sep = ""))
      data_html <- html_nodes(c,cssParth)
      textData <- html_text(data_html)
      if(!identical(textData, character(0))){
        cat(textData)
      }
      j<-j+1
    }
    i<-i+1
    
  }
  sink()
  #close(wayText)
  return(wayText)
}
finish<- function(way,textWay,q)
{
  file.rename(way,"wikilinks.txt")
  file.move("./wikilinks.txt",paste("./",q,"/textos",sep = ""))
  file.move(textWay,paste("./",q,"/textos",sep = ""))
  file.remove("results.json")
  
}

num <- 10 #(+1)
q <- ("IFNMG")
dir.create(q)
dir.create(paste(q,"/images",sep = ""))
dir.create(paste(q,"/textos",sep = ""))
getImages(num,q)
way<-getWikiLinks(q,num)
textWay<-getHtmlText(way)
finish(way,textWay,q)

