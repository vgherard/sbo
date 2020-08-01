################################################################################
# Read/write \eqn{latex}{k}-gram frequency tables
#
# Functions for storing and loading \eqn{latex}{k}-gram frequency tables
# in .csv format.
#
#' @author Valerio Gherardi
#' @md
#'
#' @importFrom readr read_lines
#' @importFrom readr write_lines
#' @importFrom readr read_csv
#' @importFrom readr write_csv
#'
#' @name readwrite_kgram_freqs
#'
#' @param freqs a \code{kgram_freqs} object.
#' @param directory a length one character. Directory for reading/writing
#' \code{kgram_freqs} object files.
#' @return A \code{kgram_freq} object for \code{read_kgram_freqs}, \code{NULL}
#' for \code{write_kgram_freqs}.
################################################################################
NULL

# @export
# @rdname readwrite_kgram_freqs
write_kgram_freqs <- function(freqs, directory){
        stopifnot(is.character(directory) & length(directory)==1)
        if( !dir.exists(directory) ) dir.create(directory)
        files <- data.frame(name = c("n", "dict"), ext = c("txt", "txt"))
        for(i in 1:nrow(files)){
                path <- paste0(directory, "/", files$name[i], ".", files$ext[i])
                write_lines(freqs[[ files$name[i] ]], path)
        }
        for(i in 1:freqs$n){
                filename <- paste0("counts", i, ".csv")
                path <- paste(directory, filename, sep = "/")
                write_csv(freqs$counts[[i]], path)
        }
        cat( paste0("kgram_freqs object successfully stored in '/",
                    directory, "'")
             )
}

# @export
# @rdname readwrite_kgram_freqs
read_kgram_freqs <- function(directory){
        if(!dir.exists(directory))
                stop( paste0("Directory '/", directory, "' does not exist.") )

        files <- data.frame(name = c("n", "dict"), ext = c("txt", "txt"))
        for(i in 1:nrow(files)){
                path <- paste0(directory, "/", files$name[i], ".", files$ext[i])
                if(!file.exists(path)) stop( paste0("Failed to read '/", path) )
                assign(files$name[i], read_lines(path))
        }
        n %<>% as.integer
        counts <- list()
        for(i in 1:n){
                filename <- paste0("counts", i, ".csv")
                path <- paste(directory, filename, sep = "/")
                col_types <- paste0(rep("i", i+1), collapse = "")
                counts[[i]] <- read_csv(path, col_types = col_types)
        }
        structure(list(n = n, dict = dict, counts = counts),
                  class = "kgram_freqs"
        )
}

