% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generic_pipeline_example.R
\name{build_pipeline}
\alias{build_pipeline}
\title{Title Build_Pipeline}
\usage{
build_pipeline(
  base_learner_list,
  base_attr_list,
  meta_learner,
  response,
  covariate,
  obs_locs,
  pred_locs
)
}
\arguments{
\item{base_learner_list}{list of the base predictor output}

\item{base_attr_list}{list of the base predictor attributes}

\item{meta_learner}{list of meta learner attributes}

\item{response}{the dependent variable, numeric, vector}

\item{covariate}{independent variables, design matrix, numeric}

\item{obs_locs}{geospatial locations as sf object}

\item{pred_locs}{geospatial information on the locations for predicting}
}
\value{
put it all together
}
\description{
Title Build_Pipeline
}
\examples{
NULL
}
