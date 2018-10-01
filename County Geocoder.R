require(httr)
require(jsonlite)

countyGeoSingle <- function(address) {
  options(digits = 15)
  address2 <-  gsub(', USA', '', as.character(address))
  address3 <-  gsub(' ', '+', as.character(address2))
  url <- urlEncode(paste0("http://gisdata.alleghenycounty.us/arcgis/rest/services/Geocoders/Composite/GeocodeServer/findAddressCandidates?Street=&City=&State=&ZIP=&SingleLine=", address5, '&category=&outFields=&maxLocations=&outSR=4326&searchExtent=&location=&distance=&magicKey=&f=pjson'))
  r <- httr::GET(url)
  if (r$status_code != 400 & length(jsonlite::fromJSON(httr::content(r))$candidates) > 0) {
    c <- jsonlite::fromJSON(httr::content(r))
    x <- c$candidates$location[1,1]
    y <- c$candidates$location[1,2]
  } else {
    x <- NA
    y <- NA
  }
  return(data.frame(address, x , y))
}

countyGeoCol <- function(addresses) {
  first <- T
  for (i in addresses) {
    if (first){
      final <- countyGeoSingle(i)
      first <- F
    } else {
      join <- countyGeoSingle(i)
      final <- rbind(final, join)
    }
  }
  return(final)
}