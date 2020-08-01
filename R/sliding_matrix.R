################################################################################
# Create a 'col' column matrix by vertically "sliding" a vector
# @param x an atomic vector.
# @param ncol an integer.
################################################################################

sliding_matrix <- function(x, ncol){
        len <- length(x)
        sapply(1:ncol, function(i) x[i:(len-ncol+i)] )
}
