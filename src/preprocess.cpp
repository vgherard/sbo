#include "sbo.h"

//' @export
// [[Rcpp::export]]
std::vector<std::string> preprocess(std::vector<std::string> input,
                                    std::string erase = "[^.?!:;'\\w\\s]",
                                    bool lower_case = true){
        std::regex _erase(erase);
        for(std::string& str : input){
                str = std::regex_replace(str, _erase, "");
                if (lower_case) for (char& c : str) c = tolower(c);
        }
        return input;
}
