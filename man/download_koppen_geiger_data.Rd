% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download.R
\name{download_koppen_geiger_data}
\alias{download_koppen_geiger_data}
\title{download_koppen_geiger_data: download climate classification data from the
Present and future Köppen-Geiger climate classification maps.}
\usage{
download_koppen_geiger_data(
  time_period = c("Present", "Future"),
  data_resolution = c("0.0083", "0.083", "0.5"),
  directory_to_download = "./input/koppen_geiger/",
  directory_to_save = "./input/koppen_geiger/",
  data_download_acknowledgement = FALSE,
  download = FALSE,
  unzip = TRUE,
  remove_zip = FALSE,
  remove_command = FALSE
)
}
\arguments{
\item{time_period}{character(1). Available times are "Present" (1980-206) and
"Future" (2071-2100). ("Future" classifications are based on scenario
RCP8.5).}

\item{data_resolution}{character(1). Available resolutions are "0.0083"
degrees (~1km), "0.083" degrees (~10km), and "0.5" degrees (~50km).}

\item{directory_to_download}{character(1). Directory to download zip files
from Present and future Köppen-Geiger climate classification maps at 1-km
resolution.}

\item{directory_to_save}{character(1). Directory to decompress zip files.}

\item{data_download_acknowledgement}{logical(1). By setting `= TRUE` the
user acknowledge that the data downloaded using this function may be very
large and use lots of machine storage and memory.}

\item{download}{logical(1). `= FALSE` will generate a `.txt` file containing
all download commands. By setting `= TRUE` the function will download all of
the requested data files.}

\item{unzip}{logical(1). Unzip zip files. Default = `TRUE`.}

\item{remove_zip}{logical(1). Remove zip files from directory_to_download.
Default = `FALSE`.}

\item{remove_command}{logical(1). Remove (\code{TRUE}) or keep (\code{FALSE})
the text file containing download commands.}
}
\value{
NULL;
}
\description{
The `download_koppen_geiger_data()` function accesses and downloads climate
classification data from the Present and future Köppen-Geiger climate
classification maps at 1-km resolution ([link for article]
(https://www.nature.com/articles/sdata2018214); [link for data]
(https://figshare.com/articles/dataset/Present_and_future_K_ppen-Geiger_
climate_classification_maps_at_1-km_resolution/6396959/2)).
}
\author{
Mitchell Manware, Insang Song
}
