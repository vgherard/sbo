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
        std::vector<std::unordered_map<std::string, int>> _freqs;
        int _N;
public:
        kgramFreqs(int N) :_N(N), _freqs(N) {}
        kgramFreqs(const std::vector<std::string>&,
                   const std::vector<std::string>&,
                   int);
        void insert(const std::string&, const std::vector<std::string>&);
        void insert(const std::deque<std::string>&);
        int N() const { return _N; }
        const std::vector<std::unordered_map<std::string, int>>& freqs() const
                { return _freqs; }
        void save_to_R_list(Rcpp::List&) const;
};

// Functions

unsigned short int match(const std::string&, const std::vector<std::string>&);
