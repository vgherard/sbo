#include "kgramFreqs.h"
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
SEXP kgram_freqs_cpp(const std::vector<std::string>& sentences,
                     const int N,
                     const std::vector<std::string>& dict) {
        Dictionary dict_hash;
        for (const auto& x : dict) dict_hash.insert(x);
        dict_hash.insert("<BOS>"); dict_hash.insert("<EOS>");
        XPtr<kgramFreqs> ptr(new kgramFreqs(sentences, dict_hash, N), true);
        return ptr;
}

// [[Rcpp::export]]
long query_kgram(SEXP ptr_sexp, int k,
                 const std::string& prefix, const std::string& completion) {
        XPtr<kgramFreqs> ptr(ptr_sexp);
        return ptr->operator[](k - 1)[prefix][completion];
}