
<!-- README.md is generated from README.Rmd. Please edit that file -->

# whereabouts

<!-- badges: start -->

<!-- badges: end -->

The goal of whereabouts is to …

## Installation

You can install the released version of whereabouts from Github with:

``` r
remotes::install_github("mkearney/whereabouts")
```

## Basic Use

The package converts a character vector of location strings (like the
‘location’ column returned by Twitter’s API) into a data frame with
geopolitical information.

``` r
## load whereabouts package
library(whereabouts)

## search for verified tweets
vrf_twt <- rtweet::search_tweets("filter:verified", n = 500)

## get the whereabouts of those tweets
w <- where(vrf_twt)

## preview geopolitical data and location field in returned data
w[!is.na(geoname_country), 
  .(location, geoname_name, geoname_region, geoname_country_name,
    geoname_lat, geoname_long)]
#>                            location geoname_name geoname_region     geoname_country_name geoname_lat geoname_long
#>   1:                   New York, NY         <NA>             NY United States of America       41.94       -74.87
#>   2:    Distrito Capital, Venezuela         <NA>           <NA>                  Bolivia      -18.04       -65.21
#>   3:                 United Kingdom         <NA>           <NA>           United Kingdom       52.88        -1.86
#>   4:                        Finland         <NA>           <NA>                  Finland       62.26        24.89
#>   5:                       New York         <NA>             NY United States of America       41.94       -74.87
#>   6:                   New York, NY         <NA>             NY United States of America       41.94       -74.87
#>   7:                        Ukraine         <NA>           <NA>                  Ukraine       47.78        31.51
#>   8: Worldwide community. HQ CA, US         <NA>           <NA> United States of America       38.60       -90.53
#>   9:                          Chile         <NA>           <NA>                 Colombia        5.67       -74.75
#>  10:                  New York, NY          <NA>             NY United States of America       41.94       -74.87
#>  ---                                                                                                             
#> 180:                    Seattle, WA      Seattle             WA United States of America       47.61      -122.33
#> 181:                      Vancouver    Vancouver             WA United States of America       45.64      -122.66
#> 182:                  Vancouver, WA    Vancouver             WA United States of America       45.64      -122.66
#> 183:                    Kelowna, BC      Kelowna             02                   Canada       49.88      -119.49
#> 184:                    Kelowna, BC      Kelowna             02                   Canada       49.88      -119.49
#> 185:           Mississauga, Ontario  Mississauga             08                   Canada       43.58       -79.66
#> 186:      Kyiv, вул. Антоновича, 46         Kyiv             12                  Ukraine       50.45        30.52
#> 187:              İstanbul, Türkiye     Istanbul             34                   Turkey       41.01        28.95
#> 188:              İstanbul, Türkiye     Istanbul             34                   Turkey       41.01        28.95
#> 189:               Johannesburg, SA Johannesburg             06             South Africa      -26.20        28.04
```
