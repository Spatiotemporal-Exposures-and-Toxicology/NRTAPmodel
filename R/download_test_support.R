###############################################################################
# Functions used to implement and simplify unit tests on data download
# functions
# Date created: 2023-11-30
# Date modified: 2023-12-12
###############################################################################

#' Check if sample of download URLs have HTTP Status 200
#' @param url Download URL to be checked.
#' @param method httr method to obtain URL ("HEAD" or "GET")
#' @author Insang Song; Mitchell Manware
#' based on comment #164 Location of download functions
#' @importFrom httr HEAD
#' @importFrom httr GET
#' @export
check_url_file_exist <- function(
  url,
  method = "HEAD"
) {
  http_status_ok <- 200
  if (method == "HEAD") {
    hd <- httr::HEAD(url)
  } else if (method == "GET") {
    hd <- httr::GET(url)
  }

  status <- hd$status_code
  return(status == http_status_ok)
}

#' Read commands and convert to character vector
#' @param commands_path file path with wget/curl commands
#' @return character vector containing download commands
#' @importFrom utils read.csv
#' @export
read_commands <- function(
    commands_path = commands_path) {
  commands <- utils::read.csv(commands_path, header = FALSE)
  commands <- commands[seq_len(nrow(commands)), ]
  return(commands)
}

#' Extract URLs from download commands
#' @param commands character vector containing download commands
#' @param position URL position in the vector
#' @importFrom stringr str_split_i
#' @return character vector containing download URLs
#' @export
extract_urls <- function(
    commands = commands,
    position = NULL) {
  if (is.null(position)) {
    cat(paste0("URL position in command is not defined.\n"))
    return(NULL)
  }
  url_list <- NULL
  for (c in seq_along(commands)) {
    url <- stringr::str_split_i(commands[c], " ", position)
    url_list <- c(url_list, url)
  }
  return(url_list)
}

#' Sample download URLs and apply `check_url_file_exist` function
#' @param urls character vector of URLs
#' @param size number of observations to be sampled from `urls`
#' @param method httr method to obtain URL ("HEAD" or "GET")
#' @return logical vector for URL status = 200
#' @export
check_urls <- function(
    urls = urls,
    size = NULL,
    method = "HEAD") {
  if (is.null(size)) {
    cat(paste0("URL sample size is not defined.\n"))
    return(NULL)
  }
  if (length(urls) < size) {
    size <- length(urls)
  }
  url_sample <- sample(urls, size, replace = FALSE)
  url_status <- sapply(url_sample,
                       check_url_file_exist,
                       method = method)
  return(url_status)
}

#' Apply download function-specific unit tests
#' @param directory_to_save directory to test saving
#' @param directory_to_download directory to test download
#' @param commands_path file path with download commands
#' @param url_status logical vector for URL status = 200
#' @importFrom testthat expect_true
#' @return NULL
#' @export
test_download_functions <- function(
    directory_to_download = NULL,
    directory_to_save = directory_to_save,
    commands_path = commands_path,
    url_status = url_status) {
  # test that directory_to_download exists
  # skip test if directory_to_download is default (NULL)
  if (!(is.null(directory_to_download))) {
    testthat::expect_true(dir.exists(directory_to_download))
  }
  # test that directory_to_save exists
  testthat::expect_true(dir.exists(directory_to_save))
  # test that commands_path exists
  testthat::expect_true(file.exists(commands_path))
  # test that sample of download URLs all have HTTP status 200
  testthat::expect_true(all(url_status))
}
