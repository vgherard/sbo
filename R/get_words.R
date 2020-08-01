################################################################################
# Word tokenization
# @param text a character vector.
# @param dictionary a character vector.
################################################################################

get_words <- function(text, dictionary){
        V <- length(dictionary) + 3 # dict. length including BOS, EOS, UNK
        text %>%
                stri_split_fixed(" ", omit_empty = TRUE) %>% unlist %>%
                match(table = c("_BOS_", dictionary, "_EOS_"),
                      nomatch = V
                ) %>%
                subtract(1)
}
