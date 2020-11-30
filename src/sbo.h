// [[Rcpp::plugins(cpp11)]]

#include <Rcpp.h>
#include <string>
#include <vector>
#include <deque>
#include <unordered_map>
#include <regex>
#include <algorithm>

// Classes

class kgramFreqs{
        int N_;
        std::vector<std::unordered_map<std::string, int> > freqs_;
public:
        kgramFreqs(int N) :N_(N), freqs_(N) {}
        kgramFreqs(const std::vector<std::string>&,
                   const std::vector<std::string>&,
                   int);
        void insert(const std::string&, const std::vector<std::string>&);
        void insert(const std::deque<std::string>&);
        int N() const { return N_; }
        const std::vector<std::unordered_map<std::string, int> >& freqs() const
                { return freqs_; }
        void save_to_R_list(Rcpp::List&) const;
};

struct PrefixCompletion{
        int N;
        int L;
        std::string EOS;
        std::vector<std::string> dict;
        std::vector<std::string> dict_ext;
        std::pair<std::vector<Rcpp::IntegerMatrix>, 
                  std::vector<Rcpp::IntegerMatrix> > pc;
        PrefixCompletion(const Rcpp::List &);
};

// Functions

unsigned short int match(const std::string&, const std::vector<std::string>&);
