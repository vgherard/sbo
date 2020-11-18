#include "sbo.h"
using namespace Rcpp;

// [[Rcpp::export]]
List get_sbo_kgramfreqsC(const std::vector<std::string>& sentences,
                      int N,
                      const std::vector<std::string>& dict){
        List l;
        kgramFreqs(sentences, dict, N).save_to_R_list(l);
        return l;
}
