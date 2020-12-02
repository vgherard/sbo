context("Stupid Back-Off algorithm: build_pps()")

test_that("Scores correctly assigned: 3-gram model predictions",{
        train <- c("a a b a", "a b b a", "a c b", "b c a a b")
        dict <- c("a", "b")
        lambda <- 0.3
        expected <- list(
                tribble(
                        ~prediction, ~score,
                        1          , 8 / 20,
                        2          , 6 / 20,
                        3          , 4 / 20
                        ),
                tribble(
                        ~w2, ~prediction, ~score,
                        0  , 1          , (lambda ^ 0) * (3 / 4),
                        0  , 2          , (lambda ^ 0) * (1 / 4),
                        0  , 3          , (lambda ^ 1) * (4 / 20),
                        1  , 1          , (lambda ^ 0) * (2 / 8),
                        1  , 2          , (lambda ^ 0) * (3 / 8),
                        1  , 3          , (lambda ^ 0) * (2 / 8),
                        2  , 1          , (lambda ^ 0) * (2 / 6),
                        2  , 2          , (lambda ^ 0) * (1 / 6),
                        2  , 3          , (lambda ^ 0) * (2 / 6),
                        4  , 1          , (lambda ^ 0) * (1 / 2),
                        4  , 2          , (lambda ^ 0) * (1 / 2),
                        4  , 3          , (lambda ^ 1) * (4 / 20), 
                        ),
                tribble(
                        ~w1, ~w2, ~prediction, ~score,
                        0  , 0  , 1          , (lambda ^ 0) * (3 / 4),
                        0  , 0  , 2          , (lambda ^ 0) * (1 / 4),
                        0  , 0  , 3          , (lambda ^ 2) * (4 / 20),
                        0  , 1  , 1          , (lambda ^ 0) * (1 / 3),
                        0  , 1  , 2          , (lambda ^ 0) * (1 / 3),
                        0  , 1  , 3          , (lambda ^ 1) * (2 / 8),
                        0  , 2  , 1          , (lambda ^ 1) * (2 / 6),
                        0  , 2  , 2          , (lambda ^ 1) * (1 / 6),
                        0  , 2  , 3          , (lambda ^ 1) * (2 / 6),
                        1  , 1  , 1          , (lambda ^ 1) * (2 / 8),
                        1  , 1  , 2          , (lambda ^ 0) * (2 / 2),
                        1  , 1  , 3          , (lambda ^ 1) * (2 / 8),
                        1  , 2  , 1          , (lambda ^ 0) * (1 / 3),
                        1  , 2  , 2          , (lambda ^ 0) * (1 / 3),
                        1  , 2  , 3          , (lambda ^ 0) * (1 / 3),
                        1  , 4  , 1          , (lambda ^ 1) * (1 / 2),
                        1  , 4  , 2          , (lambda ^ 0) * (1 / 1),
                        1  , 4  , 3          , (lambda ^ 2) * (4 / 20),
                        2  , 1  , 1          , (lambda ^ 1) * (2 / 8),
                        2  , 1  , 2          , (lambda ^ 1) * (3 / 8),
                        2  , 1  , 3          , (lambda ^ 0) * (2 / 2),
                        2  , 2  , 1          , (lambda ^ 0) * (1 / 1),
                        2  , 2  , 2          , (lambda ^ 1) * (1 / 6),
                        2  , 2  , 3          , (lambda ^ 1) * (2 / 6),
                        2  , 4  , 1          , (lambda ^ 0) * (1 / 1),
                        2  , 4  , 2          , (lambda ^ 1) * (1 / 2),
                        2  , 4  , 3          , (lambda ^ 2) * (4 / 20),
                        4  , 1  , 1          , (lambda ^ 0) * (1 / 1),
                        4  , 1  , 2          , (lambda ^ 1) * (3 / 8),
                        4  , 1  , 3          , (lambda ^ 1) * (2 / 8),
                        4  , 2  , 1          , (lambda ^ 1) * (2 / 6),
                        4  , 2  , 2          , (lambda ^ 1) * (1 / 6),
                        4  , 2  , 3          , (lambda ^ 0) * (1 / 1)
                )
        )
        f <- kgram_freqs(corpus = train, N = 3, dict = dict, 
                         .preprocess = identity, EOS = "")
        actual <- build_pps(f, N = 3, lambda = lambda, filtered = 4, L = 3)
        for (k in 1:3) {
                t1 <- anti_join(expected[[k]], actual[[k]])
                t2 <- anti_join(actual[[k]], expected[[k]])
                expect_true(nrow(t1) == 0 && nrow(t2) == 0)
        }
})
