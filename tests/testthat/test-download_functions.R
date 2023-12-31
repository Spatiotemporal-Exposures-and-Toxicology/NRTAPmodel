#' @author Mitchell Manware
#' @description Unit test for for checking data download functions.
testthat::test_that("Error when data_download_acknowledgement = FALSE", {
  download_datasets <- c("aqs", "ecoregion", "geos", "gmted", "koppen",
                         "koppengeiger", "merra2", "merra", "narr_monolevel",
                         "narr_p_levels", "nlcd", "noaa", "sedac_groads",
                         "sedac_population", "groads", "population", "plevels",
                         "p_levels", "monolevel", "hms", "smoke")
  for (d in seq_along(download_datasets)) {
    expect_message(
      download_data(dataset_name = download_datasets[d],
                    data_download_acknowledgement = FALSE),
      paste0("Please refer to the argument list and the error message above ",
             "to rectify the error.")
    )
  }
})

testthat::test_that("Error when one parameter is NULL.", {
  download_datasets <- c("aqs", "ecoregion", "geos", "gmted", "koppen",
                         "koppengeiger", "merra2", "merra", "narr_monolevel",
                         "narr_p_levels", "nlcd", "noaa", "sedac_groads",
                         "sedac_population", "groads", "population", "plevels",
                         "p_levels", "monolevel", "hms", "smoke")
  for (d in seq_along(download_datasets)) {
    expect_message(
      download_data(dataset_name = download_datasets[d],
                    data_download_acknowledgement = TRUE,
                    directory_to_save = NULL),
      paste0("Please refer to the argument list and the error message above ",
             "to rectify the error.")
    )
  }
})

testthat::test_that("EPA AQS download URLs have HTTP status 200.", {
  withr::local_package("httr")
  withr::local_package("stringr")
  # function parameters
  year_start <- 2018
  year_end <- 2022
  resolution_temporal <- "daily"
  parameter_code <- 88101
  directory_to_download <- "../testdata/"
  directory_to_save <- "../testdata/"
  # run download function
  download_data(dataset_name = "aqs",
                year_start = year_start,
                year_end = year_end,
                directory_to_save = directory_to_save,
                directory_to_download = directory_to_download,
                data_download_acknowledgement = TRUE,
                unzip = FALSE,
                remove_zip = FALSE,
                download = FALSE,
                remove_command = FALSE)
  # define file path with commands
  commands_path <-
    paste0(
           directory_to_download,
           "aqs_",
           parameter_code,
           "_",
           year_start, "_", year_end,
           "_",
           resolution_temporal,
           "_curl_commands.txt")
  # import commands
  commands <- read_commands(commands_path = commands_path)
  # extract urls
  urls <- extract_urls(commands = commands, position = 2)
  # check HTTP URL status
  url_status <- check_urls(urls = urls, size = length(urls), method = "HEAD")
  # implement unit tets
  test_download_functions(directory_to_save = directory_to_save,
                          commands_path = commands_path,
                          url_status = url_status)
  # remove file with commands after test
  file.remove(commands_path)
})


testthat::test_that("Ecoregion download URLs have HTTP status 200.", {
  withr::local_package("httr")
  withr::local_package("stringr")
  # function parameters
  directory_to_download <- "../testdata/"
  directory_to_save <- "../testdata/"
  certificate <- system.file("extdata/cacert_gaftp_epa.pem",
                             package = "NRTAPmodel")
  # run download function
  download_data(dataset_name = "ecoregion",
                directory_to_save = directory_to_save,
                directory_to_download = directory_to_download,
                data_download_acknowledgement = TRUE,
                unzip = FALSE,
                remove_zip = FALSE,
                download = FALSE,
                remove_command = FALSE,
                epa_certificate_path = certificate)
  # define file path with commands
  commands_path <- paste0(
    directory_to_download,
    "us_eco_l3_state_boundaries_",
    Sys.Date(),
    "_curl_command.txt"
  )
  # import commands
  commands <- read_commands(commands_path = commands_path)
  # extract urls
  urls <- extract_urls(commands = commands, position = 3)
  # check HTTP URL status
  url_status <-
    httr::HEAD(urls, config = httr::config(cainfo = certificate))
  url_status <- url_status$status_code
  # implement unit tets
  test_download_functions(directory_to_save = directory_to_save,
                          commands_path = commands_path,
                          url_status = url_status)
  # remove file with commands after test
  file.remove(commands_path)
})

testthat::test_that("GEOS-CF download URLs have HTTP status 200.", {
  withr::local_package("httr")
  withr::local_package("stringr")
  # function parameters
  date_start <- "2019-09-09"
  date_end <- "2019-09-21"
  collections <- c("aqc_tavg_1hr_g1440x721_v1",
                   "chm_inst_1hr_g1440x721_p23")
  directory_to_save <- "../testdata/"
  for (c in seq_along(collections)) {
    # run download function
    download_data(dataset_name = "geos",
                  date_start = date_start,
                  date_end = date_end,
                  collection = collections[c],
                  directory_to_save = directory_to_save,
                  data_download_acknowledgement = TRUE,
                  download = FALSE)
    # define file path with commands
    commands_path <- paste0(directory_to_save,
                            collections[c],
                            "_",
                            date_start,
                            "_",
                            date_end,
                            "_wget_commands.txt")
    # import commands
    commands <- read_commands(commands_path = commands_path)
    # extract urls
    urls <- extract_urls(commands = commands, position = 2)
    # check HTTP URL status
    url_status <- check_urls(urls = urls, size = 20L, method = "HEAD")
    # implement unit tests
    test_download_functions(directory_to_save = directory_to_save,
                            commands_path = commands_path,
                            url_status = url_status)
    # remove file with commands after test
    file.remove(commands_path)
  }
})

testthat::test_that("GMTED download URLs have HTTP status 200.", {
  withr::local_package("httr")
  # function parameters
  statistics <- c("Breakline Emphasis",
                  # "Systematic Subsample",
                  # "Median Statistic", "Minimum Statistic",
                  # "Mean Statistic", "Maximum Statistic",
                  "Standard Deviation Statistic")
  resolution <- "7.5 arc-seconds"
  directory_to_download <- "../testdata/"
  directory_to_save <- "../testdata/"
  for (s in seq_along(statistics)) {
    # run download function
    download_data(dataset_name = "gmted",
                  statistic = statistics[s],
                  resolution = resolution,
                  directory_to_download = directory_to_download,
                  directory_to_save = directory_to_save,
                  data_download_acknowledgement = TRUE,
                  unzip = FALSE,
                  remove_zip = FALSE,
                  download = FALSE)
    # define file path with commands
    commands_path <- paste0(directory_to_download,
                            "gmted_",
                            gsub(" ", "", statistics[s]),
                            "_",
                            gsub(" ", "", resolution),
                            "_",
                            Sys.Date(),
                            "_curl_command.txt")
    # import commands
    commands <- read_commands(commands_path = commands_path)
    # extract urls
    urls <- extract_urls(commands = commands, position = 6)
    # check HTTP URL status
    url_status <- check_urls(urls = urls, size = 1L, method = "HEAD")
    # implement unit tests
    test_download_functions(directory_to_save = directory_to_save,
                            commands_path = commands_path,
                            url_status = url_status)
    # remove file with commands after test
    file.remove(commands_path)
  }
})

testthat::test_that("MERRA2 download URLs have HTTP status 200.", {
  withr::local_package("httr")
  withr::local_package("stringr")
  # function parameters
  date_start <- "2022-02-14"
  date_end <- "2022-03-08"
  collections <- c("inst1_2d_asm_Nx", "inst3_3d_asm_Np")
  directory_to_save <- "../testdata/"
  for (c in seq_along(collections)) {
    # run download function
    download_data(dataset_name = "merra2",
                  date_start = date_start,
                  date_end = date_end,
                  collection = collections[c],
                  directory_to_save = directory_to_save,
                  data_download_acknowledgement = TRUE,
                  download = FALSE)
    # define path with commands
    commands_path <- paste0(directory_to_save,
                            collections[c],
                            "_",
                            date_start,
                            "_",
                            date_end,
                            "_wget_commands.txt")
    # import commands
    commands <- read_commands(commands_path = commands_path)
    # extract urls
    urls <- extract_urls(commands = commands, position = 2)
    # check HTTP URL status
    url_status <- check_urls(urls = urls, size = 30L, method = "HEAD")
    # implement unit tests
    test_download_functions(directory_to_save = directory_to_save,
                            commands_path = commands_path,
                            url_status = url_status)
    # remove file with commands after test
    file.remove(commands_path)
  }
})

testthat::test_that("NARR monolevel download URLs have HTTP status 200.", {
  withr::local_package("httr")
  withr::local_package("stringr")
  # function parameters
  year_start <- 2018
  year_end <- 2018
  variables <- c("weasd", "air.2m")
  directory_to_save <- "../testdata/"
  # run download function
  download_data(dataset_name = "narr_monolevel",
                year_start = year_start,
                year_end = year_end,
                variables = variables,
                directory_to_save = directory_to_save,
                data_download_acknowledgement = TRUE,
                download = FALSE)
  # define path with commands
  commands_path <- paste0(directory_to_save,
                          "narr_monolevel_",
                          year_start, "_", year_end,
                          "_curl_commands.txt")
  # import commands
  commands <- read_commands(commands_path = commands_path)
  # extract urls
  urls <- extract_urls(commands = commands, position = 6)
  # check HTTP URL status
  url_status <- check_urls(urls = urls, size = 5L, method = "HEAD")
  # implement unit tests
  test_download_functions(directory_to_save = directory_to_save,
                          commands_path = commands_path,
                          url_status = url_status)
  # remove file with commands after test
  file.remove(commands_path)
})

testthat::test_that("NARR p-levels download URLs have HTTP status 200.", {
  withr::local_package("httr")
  withr::local_package("stringr")
  # function parameters
  year_start <- 2020
  year_end <- 2021
  variables <- c("shum", "omega")
  directory_to_save <- "../testdata/"
  # run download function
  download_data(dataset_name = "narr_p_levels",
                year_start = year_start,
                year_end = year_end,
                variables = variables,
                directory_to_save = directory_to_save,
                data_download_acknowledgement = TRUE,
                download = FALSE)
  # define file path with commands
  commands_path <- paste0(directory_to_save,
                          "narr_p_levels_",
                          year_start, "_", year_end,
                          "_curl_commands.txt")
  # import commands
  commands <- read_commands(commands_path = commands_path)
  # extract urls
  urls <- extract_urls(commands = commands, position = 6)
  # check HTTP URL status
  url_status <- check_urls(urls = urls, size = 20L, method = "HEAD")
  # implement unit tests
  test_download_functions(directory_to_save = directory_to_save,
                          commands_path = commands_path,
                          url_status = url_status)
  # remove file with commands after test
  file.remove(commands_path)
})

testthat::test_that("NOAA HMS Smoke download URLs have HTTP status 200.", {
  withr::local_package("httr")
  withr::local_package("stringr")
  # function parameters
  date_start <- "2022-08-12"
  date_end <- "2022-09-21"
  directory_to_download <- "../testdata/"
  directory_to_save <- "../testdata/"
  # run download function
  download_data(dataset_name = "smoke",
                date_start = date_start,
                date_end = date_end,
                directory_to_download = directory_to_download,
                directory_to_save = directory_to_save,
                data_download_acknowledgement = TRUE,
                download = FALSE,
                remove_command = FALSE,
                unzip = FALSE,
                remove_zip = FALSE)
  # define file path with commands
  commands_path <- paste0(directory_to_download,
                          "hms_smoke_",
                          gsub("-", "", date_start),
                          "_",
                          gsub("-", "", date_end),
                          "_curl_commands.txt")
  # import commands
  commands <- read_commands(commands_path = commands_path)
  # extract urls
  urls <- extract_urls(commands = commands, position = 6)
  # check HTTP URL status
  url_status <- check_urls(urls = urls, size = 30L, method = "HEAD")
  # implement unit tests
  test_download_functions(directory_to_save = directory_to_save,
                          commands_path = commands_path,
                          url_status = url_status)
  # remove file with commands after test
  file.remove(commands_path)
})

testthat::test_that("NLCD download URLs have HTTP status 200.", {
  withr::local_package("httr")
  withr::local_package("stringr")
  # function parameters
  years <- c(2021, 2019, 2016)
  collections <- c(rep("Coterminous United States", 2), "Alaska")
  collection_codes <- c(rep("l48", 2), "ak")
  directory_to_download <- "../testdata/"
  directory_to_save <- "../testdata/"
  # run download function
  for (y in seq_along(years)) {
    download_data(dataset_name = "nlcd",
                  year = years[y],
                  collection = collections[y],
                  directory_to_download = directory_to_download,
                  directory_to_save = directory_to_save,
                  data_download_acknowledgement = TRUE,
                  download = FALSE,
                  remove_command = FALSE,
                  unzip = FALSE,
                  remove_zip = FALSE)
    # define file path with commands
    commands_path <- paste0(directory_to_download,
                            "nlcd_",
                            years[y],
                            "_land_cover_",
                            collection_codes[y],
                            "_",
                            Sys.Date(),
                            "_curl_command.txt")
    # import commands
    commands <- read_commands(commands_path = commands_path)
    # extract urls
    urls <- extract_urls(commands = commands, position = 5)
    # check HTTP URL status
    url_status <- check_urls(urls = urls, size = 1L, method = "HEAD")
    # implement unit tests
    test_download_functions(directory_to_download = directory_to_download,
                            directory_to_save = directory_to_save,
                            commands_path = commands_path,
                            url_status = url_status)
    # remove file with commands after test
    file.remove(commands_path)
  }
})

testthat::test_that("SEDAC groads download URLs have HTTP status 200.", {
  withr::local_package("httr")
  withr::local_package("stringr")
  # function parameters
  data_regions <- c("Americas")
  data_formats <- c("Geodatabase", "Shapefile")
  directory_to_download <- "../testdata/"
  directory_to_save <- "../testdata/"
  # run download function
  for (r in seq_along(data_regions)) {
    data_region <- data_regions[r]
    for (f in seq_along(data_formats)) {
      download_data(dataset_name = "sedac_groads",
                    data_format = data_formats[f],
                    data_region = data_region,
                    directory_to_download = directory_to_download,
                    directory_to_save = directory_to_save,
                    data_download_acknowledgement = TRUE,
                    download = FALSE,
                    unzip = FALSE,
                    remove_zip = FALSE,
                    remove_command = FALSE)
      # define file path with commands
      commands_path <- paste0(directory_to_download,
                              "sedac_groads_",
                              gsub(" ", "_", tolower(data_region)),
                              "_",
                              Sys.Date(),
                              "_curl_command.txt")
      # import commands
      commands <- read_commands(commands_path = commands_path)
      # extract urls
      urls <- extract_urls(commands = commands, position = 11)
      # check HTTP URL status
      url_status <- check_urls(urls = urls, size = 1L, method = "GET")
      # implement unit tests
      test_download_functions(directory_to_download = directory_to_download,
                              directory_to_save = directory_to_save,
                              commands_path = commands_path,
                              url_status = url_status)
      # remove file with commands after test
      file.remove(commands_path)
    }
  }
})

testthat::test_that("SEDAC population download URLs have HTTP status 200.", {
  withr::local_package("httr")
  withr::local_package("stringr")
  # function parameters
  years <- c("2020")
  data_formats <- c("GeoTIFF")
  data_resolutions <- cbind(c("30 second"),
                            c("30_sec"))
  directory_to_download <- "../testdata/"
  directory_to_save <- "../testdata/"
  for (f in seq_along(data_formats)) {
    data_format <- data_formats[f]
    for (y in seq_along(years)) {
      year <- years[y]
      for (r in seq_len(nrow(data_resolutions))) {
        # run download function
        download_data(dataset_name = "sedac_population",
                      year = year,
                      data_format = data_format,
                      data_resolution = data_resolutions[r, 1],
                      directory_to_download = directory_to_download,
                      directory_to_save = directory_to_save,
                      data_download_acknowledgement = TRUE,
                      download = FALSE,
                      unzip = FALSE,
                      remove_zip = FALSE,
                      remove_command = FALSE)
        # define file path with commands
        if (year == "all") {
          year <- "totpop"
        } else {
          year <- year
        }
        if (year == "totpop" && data_resolutions[r, 2] == "30_sec") {
          resolution <- "2pt5_min"
        } else {
          resolution <- data_resolutions[r, 2]
        }
        commands_path <- paste0(directory_to_download,
                                "sedac_population_",
                                year,
                                "_",
                                resolution,
                                "_",
                                Sys.Date(),
                                "_curl_commands.txt")
        # import commands
        commands <- read_commands(commands_path = commands_path)
        # extract urls
        urls <- extract_urls(commands = commands, position = 11)
        # check HTTP URL status
        url_status <- check_urls(urls = urls, size = 1L, method = "GET")
        # implement unit tests
        test_download_functions(directory_to_download = directory_to_download,
                                directory_to_save = directory_to_save,
                                commands_path = commands_path,
                                url_status = url_status)
        # remove file with commands after test
        file.remove(commands_path)
      }
    }
  }
})

testthat::test_that("Koppen Geiger download URLs have HTTP status 200.", {
  withr::local_package("httr")
  withr::local_package("stringr")
  # function parameters
  time_periods <- c("Present", "Future")
  data_resolutions <- c("0.0083")
  directory_to_download <- "../testdata/"
  directory_to_save <- "../testdata/"
  # run download function
  for (p in seq_along(time_periods)) {
    time_period <- time_periods[p]
    for (d in seq_along(data_resolutions)) {
      download_data(dataset_name = "koppen",
                    time_period = time_period,
                    data_resolution = data_resolutions[d],
                    directory_to_download = directory_to_download,
                    directory_to_save = directory_to_save,
                    data_download_acknowledgement = TRUE,
                    unzip = FALSE,
                    remove_zip = FALSE,
                    download = FALSE,
                    remove_command = FALSE)
      # define file path with commands
      commands_path <- paste0(directory_to_download,
                              "koppen_geiger_",
                              time_period,
                              "_",
                              gsub("\\.",
                                   "p",
                                   data_resolutions[d]),
                              "_",
                              Sys.Date(),
                              "_wget_command.txt")
      # import commands
      commands <- read_commands(commands_path = commands_path)
      # extract urls
      urls <- extract_urls(commands = commands, position = 2)
      # check HTTP URL status
      url_status <- check_urls(urls = urls, size = 1L, method = "GET")
      # implement unit tests
      test_download_functions(directory_to_download = directory_to_download,
                              directory_to_save = directory_to_save,
                              commands_path = commands_path,
                              url_status = url_status)
      # remove file with commands after test
      file.remove(commands_path)
    }
  }
})

testthat::test_that("MODIS-MOD09GA download URLs have HTTP status 200.", {
  withr::local_package("httr")
  withr::local_package("stringr")
  # function parameters
  years <- 2020
  product <- "MOD09GA"
  version <- "61"
  horizontal_tiles <- c(12, 13)
  vertical_tiles <- c(5, 6)
  nasa_earth_data_token <- "tOkEnPlAcEhOlDeR"
  directory_to_save <- "../testdata/"
  for (y in seq_along(years)) {
    date_start <- paste0(years[y], "-06-20")
    date_end <- paste0(years[y], "-06-24")
    # run download function
    download_data(dataset_name = "modis",
                  date_start = date_start,
                  date_end = date_end,
                  product = product,
                  version = version,
                  horizontal_tiles = horizontal_tiles,
                  vertical_tiles = vertical_tiles,
                  nasa_earth_data_token = nasa_earth_data_token,
                  directory_to_save = directory_to_save,
                  data_download_acknowledgement = TRUE,
                  download = FALSE,
                  remove_command = FALSE)
    # define file path with commands
    commands_path <- paste0(
      directory_to_save,
      product,
      "_",
      date_start,
      "_",
      date_end,
      "_wget_commands.txt"
    )
    # import commands
    commands <- read_commands(commands_path = commands_path)[, 2]
    # extract urls
    urls <- extract_urls(commands = commands, position = 4)
    # check HTTP URL status
    url_status <- check_urls(urls = urls, size = 10L, method = "HEAD")
    # implement unit tests
    test_download_functions(directory_to_save = directory_to_save,
                            commands_path = commands_path,
                            url_status = url_status)
    # remove file with commands after test
    file.remove(commands_path)
  }
})


testthat::test_that("MODIS-MOD06L2 download URLs have HTTP status 200.", {
  withr::local_package("httr")
  withr::local_package("stringr")
  # function parameters
  product <- "MOD06_L2"
  version <- "61"
  date_start <- "2019-02-18"
  date_end <- "2022-03-22"
  nasa_earth_data_token <- "tOkEnPlAcEhOlDeR"
  horizontal_tiles <- c(8, 10)
  vertical_tiles <- c(4, 5)
  directory_to_save <- "./tests/testdata/"

  kax <- download_data(dataset_name = "modis",
                  date_start = date_start,
                  date_end = date_end,
                  product = product,
                  version = version,
                  horizontal_tiles = horizontal_tiles,
                  vertical_tiles = vertical_tiles,
                  nasa_earth_data_token = nasa_earth_data_token,
                  directory_to_save = directory_to_save,
                  data_download_acknowledgement = TRUE,
                  download = FALSE,
                  mod06_links = NULL,
                  remove_command = FALSE)
  testthat::expect_true(is.null(kax))

  # link check
  tdir <- tempdir()
  faux_urls <-
    rbind(
      c(4387858920,
        "/archive/allData/61/MOD06_L2/2019/049/MOD06_L2.A2019049.0720.061.2019049194350.hdf",
        28267915),
      c(6845623203,
        "/archive/allData/61/MOD06_L2/2022/033/MOD06_L2.A2022033.0435.061.2022035152913.hdf",
        26393941),
      c(6898699552,
        "/archive/allData/61/MOD06_L2/2022/081/MOD06_L2.A2022081.0620.061.2022092003817.hdf",
        28878947)
    )
  faux_urls <- data.frame(faux_urls)
  mod06_scenes <- paste0(tdir, "/mod06_example.csv")
  write.csv(faux_urls, mod06_scenes, row.names = FALSE)

  download_data(dataset_name = "modis",
                  date_start = date_start,
                  date_end = date_end,
                  product = product,
                  version = version,
                  horizontal_tiles = horizontal_tiles,
                  vertical_tiles = vertical_tiles,
                  nasa_earth_data_token = nasa_earth_data_token,
                  directory_to_save = directory_to_save,
                  data_download_acknowledgement = TRUE,
                  download = FALSE,
                  mod06_links = mod06_scenes,
                  remove_command = FALSE)
  
  # define file path with commands
  commands_path <- paste0(
    directory_to_save,
    product,
    "_",
    date_start,
    "_",
    date_end,
    "_wget_commands.txt"
  )
  # import commands
  commands <- read_commands(commands_path = commands_path)[, 2]
  # extract urls
  urls <- extract_urls(commands = commands, position = 4)
  # check HTTP URL status
  url_status <- check_urls(urls = urls, size = 10L, method = "HEAD")
  # implement unit tests
  test_download_functions(directory_to_save = directory_to_save,
                          commands_path = commands_path,
                          url_status = url_status)
  # remove file with commands after test
  file.remove(commands_path)
})
