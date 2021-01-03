#include <Rcpp.h>
#include "sboPredictor.h"
using namespace Rcpp;

// [[Rcpp::plugins(cpp11)]]
// [[Rcpp::export]]
SEXP sbo_predictor_cpp(SEXP freqs_ptr_sexp,
                       double lambda,
                       int L,
                       std::vector<std::string> banned) {
        XPtr<kgramFreqs> freqs(freqs_ptr_sexp);
        Dictionary banned_hash;
        for (auto & x : banned) banned_hash.insert(x);
        XPtr<sboPredictor> ptr(new sboPredictor(*freqs, lambda, L, banned_hash), 
                               true);
        return ptr;
}

// [[Rcpp::export]]
int sbo_predictor_size(SEXP preds_ptr_sexp) {
        XPtr<sboPredictor> preds(preds_ptr_sexp);
        return preds->memory_size();
}