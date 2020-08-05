################################################################################
# Build prefix-prediction-score tables
# @param counts a list.
# @param n an integer.
# @param lambda a double.
# @param V an integer.
# @param filtered an integer.
# @param L an integer.
#' @importFrom utils tail
################################################################################



build_pps_tables <- function(counts, N, lambda, V, filtered, L){
        k <- length(counts)
        if(k == 0)return(list())
        counts[[k]] %<>% rename("pred" = paste0("w",N))
        pref <- names(counts[[k]]) %>% .[!(. %in% c("pred", "n"))]

        pps <- counts[[k]] %>%
                filter( !(pred %in% filtered) )%>%
                group_by_at(all_of(pref)) %>%
                mutate(score = n / sum(n)) %>%
                ungroup %>%
                select(pref, pred, score)

        pps_lower <- build_pps_tables(counts[-k], N, lambda, V, filtered, L)

        pps_backoff <-
                {if(k>1) pps_lower[[k-1]] else tibble(pred = integer())} %>%
                mutate( across(any_of("score"), function(x)lambda*x) ) %>%
                left_join(distinct(select(pps, any_of(pref))),
                          by = tail(pref,-1)
                ) %>%
                anti_join( select(pps, -score), by = c("pred", pref) )

        pps %<>% bind_rows(pps_backoff) %>%
                group_by_at(all_of(pref)) %>%
                slice_max(score, n = L, with_ties = FALSE) %>%
                arrange(desc(score), by_group = TRUE) %>%
                ungroup

        append(pps_lower, list(pps))
}
