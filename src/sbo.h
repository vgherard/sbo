#include <Rcpp.h>
#include <string>
#include <vector>
#include <queue>
#include <unordered_map>
#include <map>
#include <regex>
#include <algorithm>
// [[Rcpp::plugins(cpp11)]]

// Classes

class kgramFreqs{
        std::vector<std::unordered_map<std::string,  int>> freqs;
        int N;
public:
        kgramFreqs(const std::vector<std::string>& sentences,
                   const std::vector<std::string>& dict,
                   int _N);
        void push(const std::deque<std::string>&);
        Rcpp::List make_R_list() const;
};

// Functions

unsigned short int match(const std::string&, const std::vector<std::string>&);

// Global variables

extern std::regex invalid_chars;
extern std::regex multiple_EOS;
