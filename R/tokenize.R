################################################################################
# Word tokenization
# @param text a character vector.
# @param dictionary a character vector.
################################################################################

tokenize_ <- function(text, dict){
        V <- length(dict) + 3 # dict. length including BOS, EOS, UNK
        text %>%
                stri_split_fixed(" ", omit_empty = TRUE) %>%
                unlist %>%
                match(table = c("_BOS_", dict, "_EOS_"), nomatch = V) %>%
                subtract(1)
}
