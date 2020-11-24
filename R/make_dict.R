make_dict <- function(object, ...)
        UseMethod("make_dict")

make_dict.sbo_dictionary <- function(object, ...) 
        return(object)
        
make_dict.character <- function(object, .preprocess, EOS, ...) 
        return(as_sbo_dictionary(object, .preprocess, EOS))
        
make_dict.formula <- function(object, .preprocess, EOS, corpus, ...) {
        object <- deparse(object) %>% strsplit(" ~ ") %>% unlist
        args <- list(corpus = corpus, 
                     as.numeric(object[2]), 
                     .preprocess = .preprocess, 
                     EOS = "")
        names(args)[2] <- object[1]
        return(do.call(what = sbo_dictionary, args))
}