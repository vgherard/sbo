#include "sbo.h"

//' Preprocess text corpus
//'
//' A simple text preprocessing utility.
//'
//' @export
//'
//' @author Valerio Gherardi
//' @md
//'
//' @param input a character vector.
//' @param erase a length one character vector. Regular expression matching parts of
//' text to be erased from input. The default removes anything not alphanumeric,
//' white space, apostrophes or punctuation characters (i.e. ".?!:;").
//' @param lower_case a length one logical vector. If TRUE, puts everything to lower
//' case.
//' @return a character vector containing the processed output.
//' @examples
//' preprocess("Hi @@ there! I'm using `sbo`.")
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
