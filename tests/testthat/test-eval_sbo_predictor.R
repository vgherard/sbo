context("eval_sbo_predictor")

test_that("doesn't throw errors with twitter_test sample",{
        p <- sbo_predictor(twitter_predtable)
        
        expect_error(eval_sbo_predictor(p, twitter_test[1:100]), NA)
})

test_that("output has the correct structure",{
        n_test <- 100
        p <- sbo_predictor(twitter_predtable)
        p_eval <- eval_sbo_predictor(p, twitter_test[1:100])
        expect_s3_class(p_eval, class(tibble()))
        expect_true(nrow(p_eval) == n_test)
        classes <- list(input = "character", 
                        true = "character", 
                        preds = c("matrix", "array"), 
                        correct = "logical")
        expect_identical(lapply(p_eval, class), classes)
})

test_that("correctly identifies correct prediction",{
        n_test <- 100
        p <- sbo_predictor(twitter_predtable)
        p_eval <- eval_sbo_predictor(p, twitter_test[1:100])
        correct <- logical(n_test)
        for (i in seq_len(n_test)) {
                correct[[i]] <- p_eval[["true"]][[i]] %in% p_eval[["preds"]][i, ]
                
        }
        expect_identical(correct, p_eval[["correct"]])
})