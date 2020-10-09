#include <Rcpp.h>
#include <string>
#include <vector>
#include <queue>
#include <unordered_map>
#include <map>
#include <regex>
#include <algorithm>
using FreqsContainer = std::vector<std::unordered_map<std::string, int>>;
using PredsContainer = std::vector<
        std::unordered_map<std::string, std::vector<std::string>>
        >;
// [[Rcpp::plugins(cpp11)]]

// Classes

class kgramFreqs{
        FreqsContainer _freqs;
        int _N;
public:
        kgramFreqs(const std::vector<std::string>& sentences,
                   const std::vector<std::string>& dict,
                   int N);
        void push(const std::deque<std::string>&);
        int N() const { return _N; }
        const FreqsContainer& freqs() const { return _freqs; }
        Rcpp::List make_R_list() const;
};

class SboPreds{
        PredsContainer _preds;
        int _N;
public:
        SboPreds(const kgramFreqs&, int, double);
};

// Functions

unsigned short int match(const std::string&, const std::vector<std::string>&);
Rcpp::IntegerVector make_Ngram_prefix(std::string, int,
                                      const std::vector<std::string>&);


// Global variables

extern std::regex invalid_chars;
extern std::regex multiple_EOS;
