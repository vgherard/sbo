context("prune")

test_that("pruned kgram_freqs coincides with the correct object", {
        seed <- sample(1:2^30, 1)
        set.seed(seed)
        train <- paste(sample(letters, 10000, replace = T, prob = rnorm(26)^2), 
                       collapse = " ")
        dict <- sample(letters, size = 13)
        lambda <- runif(n = 1, min = 0, max = 1)
        L <- sample(1:13, size = 1)
        f3 <- kgram_freqs(train, N = 3, dict = dict)
        f2 <- kgram_freqs(train, N = 2, dict = dict)
        f2_pruned <- prune(f3, 2)
        
        on_failure <- paste("Seed:", seed, "\n")
        expect_identical(f2, f2_pruned, label = on_failure)
})

test_that("pruned predtable coincides with the correct object", {
        seed <- sample(1:2^30, 1)
        set.seed(seed)
        train <- paste(sample(letters, 10000, replace = T, prob = rnorm(26)^2), 
                       collapse = " ")
        dict <- sample(letters, size = 13)
        lambda <- runif(n = 1, min = 0, max = 1)
        L <- sample(1:13, size = 1)
        p3 <- sbo_predtable(object = train, N = 3, dict = dict, L = L,
                            lambda = lambda)
        p2 <- sbo_predtable(object = train, N = 2, dict = dict, L = L,
                            lambda = lambda)
        p2_pruned <- prune(p3, 2)
        
        on_failure <- paste("Seed:", seed, "\n")
        expect_identical(p2, p2_pruned, label = on_failure)
})
test_that("errors on invalid N: type and length", {
        err <- "sbo_domain_error"
        expect_error(prune(twitter_freqs, N = "2"), class = err)
        expect_error(prune(twitter_freqs, N = c(1,2)), class = err)
})

test_that("errors on invalid N: N < 1", {
        err <- "sbo_domain_error"
        expect_error(prune(twitter_freqs, N = 0), class = err)
})

test_that("errors on invalid N: N > N_max", {
        err <- "sbo_domain_error"
        expect_error(prune(twitter_freqs, N = 4), class = err)
})