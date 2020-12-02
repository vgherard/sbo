################################################################################
# Build prefix-prediction-score tables from k-gram frequencies. 
################################################################################

build_pps <- function(freqs, N, lambda, filtered, L) {
        k <- length(freqs)
        if (k == 0) return(list())
        freqs[[k]] <- rename(freqs[[k]], "prediction" = paste0("w", N))
        prefixes <- names(freqs[[k]]) %>% .[!(. %in% c("prediction", "n"))]

        pps <- freqs[[k]] %>%
                group_by_at(all_of(prefixes)) %>%
                mutate(score = n / sum(n)) %>%
                ungroup %>%
                select(prefixes, .data$prediction, .data$score)
        
        pps_lower <- build_pps(freqs[-k], N, lambda, filtered, L)
        
        base_case <- tibble(prediction = integer())
        pps_backoff <- 
                (if (k > 1) pps_lower[[k - 1]] else base_case) %>%
                mutate(across(any_of("score"), function(x) lambda * x)) %>%
                left_join(distinct(select(pps, any_of(prefixes))), 
                          by = tail(prefixes, -1)) %>%
                anti_join(select(pps, -.data$score), 
                          by = c("prediction", prefixes)
                          )

        pps %>% 
                bind_rows(pps_backoff) %>%
                filter(!(.data$prediction %in% filtered)) %>%
                arrange(desc(.data$score), .data$prediction, .by_group = TRUE
                        ) %>%
                group_by_at(all_of(prefixes)) %>%
                filter(row_number() <= L) %>%
                ungroup -> pps
        if (k == 1) pps_lower <- list()
        return(append(pps_lower, list(pps)))
}
