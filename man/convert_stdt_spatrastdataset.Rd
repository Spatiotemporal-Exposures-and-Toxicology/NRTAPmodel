% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/manipulate_spacetime_data.R
\name{convert_stdt_spatrastdataset}
\alias{convert_stdt_spatrastdataset}
\title{Convert a stdtobj to SpatRasterDataset}
\usage{
convert_stdt_spatrastdataset(stdt)
}
\arguments{
\item{stdt}{A stdt object}
}
\value{
a SpatRasterDataset with each raster corresponding to one variable
(layers are the time series)
}
\description{
Convert a stdtobj to SpatRasterDataset
}
\author{
Eva Marques
}
