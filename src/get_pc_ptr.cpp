#include "sbo.h"
using namespace Rcpp;

// [[Rcpp::export]]
SEXP get_pc_ptr(const List & object) {
        XPtr<PrefixCompletion> ptr(new PrefixCompletion(object), true);
        return ptr;
}