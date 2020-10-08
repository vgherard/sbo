#include <Rcpp.h>
#include "sbo.h"
using namespace Rcpp;

//' @export
// [[Rcpp::export]]
std::map<std::string, int> get_word_freqsC(const std::vector<std::string>& text)
        {
        std::map<std::string, int> word_freqs;
        for(auto line: text){
                if(line == "") continue;
                size_t start = 0; size_t end;
                while((end = line.find_first_of(" ", start)) !=
                      std::string::npos){
                        std::string word = line.substr(start, end - start);
                        word_freqs[word]++;
                        start = line.find_first_not_of(" ", end);
                }
                std::string last_word = line.substr(start);
                word_freqs[last_word]++;
        }
        return word_freqs;
}
