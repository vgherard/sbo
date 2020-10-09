#include <Rcpp.h>
#include "sbo.h"
using namespace Rcpp;
using std::string;
using std::vector;

std::regex invalid_chars = std::regex(R"([^'.?!:;\w\s])");
std::regex multiple_EOS = std::regex(R"((\s*[.?!:;]+\s*)+)");

unsigned short int match(const string& word, const vector<string>& dict){
        auto it = find(dict.begin(), dict.end(), word);
        if (it == dict.end()) return dict.size() + 2;
        return 1 + distance(dict.begin(), it);
}

inline void ltrim(std::string &s) {
        s.erase(s.begin(), std::find_if(s.begin(), s.end(), [](unsigned char ch) {
                return !std::isspace(ch);
        }));
}

inline void rtrim(std::string &s) {
        s.erase(std::find_if(s.rbegin(), s.rend(), [](unsigned char ch) {
                return !std::isspace(ch);
        }).base(), s.end());
}

inline void trim(std::string &s) {
        ltrim(s); rtrim(s);
}

std::string format_input(std::string& input){
        input = std::regex_replace(input, invalid_chars, "");
        input = input.substr( input.find_last_of(".?!:;") + 1 );
        trim(input);
        for(char& c: input) c = std::tolower(c);
        return input;
}

IntegerVector make_Ngram_prefix(std::string input, int N,
                                const std::vector<std::string>& dict){
        IntegerVector prefix(N - 1, 0);
        format_input(input);
        if(input == "") return prefix;
        size_t end; size_t start = 0;
        while((end = input.find_first_of(" ", start)) !=
              std::string::npos)
        {
                prefix.push_back(
                        match(input.substr(start, end - start), dict)
                );
                prefix.erase(0);
                start = input.find_first_not_of(" ", end);
        }
        prefix.push_back(match(input.substr(start), dict));
        prefix.erase(0);
        return prefix;
}
