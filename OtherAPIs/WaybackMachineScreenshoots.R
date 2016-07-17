## Config:
workingDirectory <- "C:/test/webseite"
from <- "2015/1/1" # format Year/Month/Day
to <- "2015/12/31" # format Year/Month/Day
by <- "month" # possible values: day, week, month, quarter, year
page <- "http://www.infineon.com" # page for analysis. Check first with Waybackmachine

## Do not edit after this line!

# Install needed packages
list.of.packages <- c("webshot", "RJSONIO", "xlsx")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# Load packages
require(webshot)
require(RJSONIO)
require(xlsx)

if(!file.exists(workingDirectory)){
        dir.create(workingDirectory)
}

setwd(workingDirectory)
sequence <- data.frame(date = seq.Date(as.Date(from), 
                                       as.Date(to), 
                                       by),
                       closestUrl = "",
                       timestamp = "",
                       status = "",
                       stringsAsFactors=FALSE)


for (i in 1:nrow(sequence)){
        temp <- fromJSON(paste0("http://archive.org/wayback/available?url=",page,"&timestamp=",format(strptime(sequence$date[i],"%Y-%m-%d"),"%Y%m%d")))
        sequence$closestUrl[i] <- temp$archived_snapshots$closest$url
        sequence$timestamp[i] <- temp$archived_snapshots$closest$timestamp
        sequence$status[i] <- temp$archived_snapshots$closest$status
        webshot(temp$archived_snapshots$closest$url, paste0(by,i,"-screenshot.png"))
}
