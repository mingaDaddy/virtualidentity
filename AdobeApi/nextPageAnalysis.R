# Configuration:
reportSuiteId <- "X"
userAPI <- "X"
secretAPI <- "X"
dateFrom <- "2016-06-01" # YYYY-mm-dd
dateTo <- "2016-06-30" # YYYY-mm-dd
topPages <- "1000" # Number of next pages to get (max. 10000)

# Install needed packages
list.of.packages <- c("xlsx", "RSiteCatalyst")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# Load packages
require("xlsx")
require("RSiteCatalyst")

# New variable for connection via API with Adobe Analytics and autorisation
Login <- SCAuth(userAPI,secretAPI)

#Connection via API with Adobe Analytics and autorisation
Login 

# Segments ID
segment_visits_monthly <- "537c0396e4b074a3c232e5d6"
excludeIntern <- "s195_57836336e4b08f6fae1aa455"

# CSV File with pages for whom we want the nextPages info
nextPagesFor <- read.csv("C:/Test/5/prod.csv", header = F, sep = ";") #Doubleckeck working directory

# For Loop - Creates a new API Request for every page
for (i in 1:nrow(nextPagesFor)){
        pathpattern <- c(as.character(nextPagesFor$V1[i]),"::anything::")
        queue_pathing_pages <- QueuePathing(reportSuiteId,
                                            dateFrom,
                                            dateTo,
                                            metric="pageviews",
                                            element="page",
                                            pathpattern,
                                            top = topPages,
                                            segment.id = c(segment_visits_monthly,
                                                           excludeIntern),
                                            max.attempts = 400)
        assign(paste0("pathing",i),queue_pathing_pages)
}

# Create a list with all API response dataframes
l.df <- lapply(ls(pattern="pathing[0-9]+"), function(x) get(x))

# Create an aggregated dataframe with all next Page Information
nextPagesdf <- do.call("rbind", l.df)

# Save dataframe to Excel File
wirte.xlsx2(nextPagesdf, "nextpages.xlsx")
