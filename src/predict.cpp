#include "sboPredictor.h"
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
std::vector<std::string> query_sbo_predictor(SEXP ptr_sexp, std::string input, int k) {
        XPtr<sboPredictor> ptr(ptr_sexp);
        auto end = ptr->operator[](k - 1).end();
        if (ptr->operator[](k - 1).find(input) != end)
                return ptr->operator[](k - 1)[input];
        else
                return std::vector<std::string>(1);
}