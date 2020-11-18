new_sbo_dictionary <- function(dictionary) {
        stopifnot(is.character(dictionary))
        structure(dictionary, class = "sbo_dictionary")
}
