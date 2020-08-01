################################################################################
# Read/write Stupid Backoff prediction tables
#
# Functions for storing and loading Stupid Backoff prediction tables in .csv
# format.
#
#' @author Valerio Gherardi
#' @md
#'
#' @param model a \code{sbo_preds} object.
#' @param directory a length one character. Directory for reading/writing
#' \code{sbo_preds} object files.
#' @return A \code{sbo_preds} object for \code{read_sbo_preds}, \code{NULL}
#' for \code{write_sbo_preds}.
#' @importFrom readr read_lines
#' @importFrom readr write_lines
#' @importFrom readr read_csv
#' @importFrom readr write_csv
#' @name readwrite_sbo_preds
################################################################################
NULL

# @export
# @rdname readwrite_sbo_preds
write_sbo_preds <- function(model, directory){
        stopifnot(is.character(directory) & length(directory)==1)
        if( !dir.exists(directory) ) dir.create(directory)
        files <- data.frame(name = c("n", "L", "lambda", "dict"),
                            ext = c("txt", "txt", "txt", "txt") )
        for(i in 1:nrow(files)){
                path <- paste0(directory, "/", files$name[i], ".", files$ext[i])
                write_lines(model[[ files$name[i] ]], path)
        }
        for(i in 1:model$n){
                filename <- paste0("preds", i, ".csv")
                path <- paste(directory, filename, sep = "/")
                write_csv(model$preds[[i]], path)
        }
        cat( paste0("sbo_preds object successfully stored in '/",
                    directory, "'")
        )
}

# @export
# @rdname readwrite_sbo_preds
read_sbo_preds <- function(directory){
        if(!dir.exists(directory))
                stop( paste0("Directory '/", directory, "' does not exist.") )
        files <- data.frame(name = c("n", "L", "lambda", "dict"),
                            ext = c("txt", "txt", "txt", "txt") )
        for(i in 1:nrow(files)){
                path <- paste0(directory, "/", files$name[i], ".", files$ext[i])
                if(!file.exists(path)) stop( paste0("Failed to read '/", path) )
                assign(files$name[i], read_lines(path))
        }
        n %<>% as.integer; L %<>% as.integer; lambda %<>% as.double
        preds <- list()
        for(i in 1:n){
                filename <- paste0("preds", i, ".csv")
                path <- paste(directory, filename, sep = "/")
                col_types <- paste0(rep("i", i + L - 1), collapse = "")
                preds[[i]] <- read_csv(path, col_types = col_types)
        }
        structure(list(n = n, L = L, lambda = lambda, dict = dict,
                       preds = preds
        ),
        class = "sbo_preds")
}
