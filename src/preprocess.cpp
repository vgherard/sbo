// [[Rcpp::plugins(cpp11)]]
#include <Rcpp.h>
#include "sbo.h"

// Desired features: customizable EOS tokens and allowed chars.

//' @export
// [[Rcpp::export]]
std::vector<std::string> preprocess(const std::vector<std::string>& lines) {
        std::vector<std::string> sentences;
        std::regex invalid_chars = std::regex(R"([^'.?!:;\w\s])");
        std::regex multiple_EOS = std::regex(R"((\s*[.?!:;]+\s*)+)");
        for(std::string line : lines){
                line += ".";
                line = std::regex_replace(line, invalid_chars, "");
                line = std::regex_replace(line, multiple_EOS, ".");
                for(char& c: line) c = std::tolower(c);
                size_t end; size_t start = 0;
                while((end = line.find_first_of(".", start)) !=
                      std::string::npos)
                        {
                        sentences.push_back(line.substr(start, end - start));
                        start = end + 1;
                        }
        }
        return sentences;
}
