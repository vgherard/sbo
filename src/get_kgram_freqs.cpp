// [[Rcpp::plugins(cpp11)]]
#include <Rcpp.h>
#include "sbo.h"
using namespace Rcpp;

//' @export
// [[Rcpp::export]]
List get_kgram_freqsC(const std::vector<std::string>& sentences,
                      const std::vector<std::string>& dict,
                      int N){
        return kgramFreqs(sentences, dict, N).make_R_list();
}
