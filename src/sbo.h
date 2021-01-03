#if !defined(SBO_H)
#define SBO_H

// [[Rcpp::plugins(cpp11)]]

#include <Rcpp.h>
#include "utils.h"
#include "kgramFreqs.h"
#include <string>
#include <vector>
#include <array>
#include <queue>
#include <utility>
#include <unordered_map>
#include <unordered_set>
#include <regex>
#include <algorithm>

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

// unsigned short int match(const std::string&, const std::vector<std::string>&);

#endif