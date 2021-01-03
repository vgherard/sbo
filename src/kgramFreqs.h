// Store k-gram frequencies using two nested hash-tables as follows:
//
//    {key = (k - 1)-gram prefix, value = {key = completion, value = count}}
//
// E.g.: the typical key-value pair for 2-gram prefixes looks as follows:
// {"i love", {{"cats", 840}, {"me", 420}, {"you", 7}, ...}}

#if !defined(KGRAM_FREQS_H)
#define KGRAM_FREQS_H

// [[Rcpp::plugins(cpp11)]]

#include <string>
#include <vector>
#include <unordered_set>
#include <unordered_map>
#include "utils.h" //CircularBuffer

using Dictionary = std::unordered_set<std::string>;
using kgramStream = CircularBuffer<std::pair<size_t, size_t> >;
using kgramTable = 
        std::unordered_map<std::string, std::unordered_map<std::string, double>>;

class kgramFreqs {
        int N_;
        Dictionary dict_;
        // freqs_[k] stores (k + 1)-gram frequencies 
        std::vector<kgramTable> freqs_;
public:
        // Constructors
        kgramFreqs(int N) : N_(N), freqs_(N) {}
        kgramFreqs(const std::vector<std::string>& sentences,
                   const Dictionary& dict,
                   int N)
                : N_(N), dict_(dict), freqs_(N) {insert(sentences);}
        
        // Store k-gram counts from sentences
        void insert(const std::vector<std::string>& sentences) 
        {
                kgramStream stream(N_, {0, 0});
                for(const std::string& s: sentences) insert(s, stream);
        }
        // Store k-gram counts from sentence
        void insert(std::string, kgramStream&);
        
        // Access members        
        int N() const { return N_; }
        Dictionary dict() const { return dict_; }
        kgramTable& operator [](int k) {
                return freqs_[k];
        }
        const kgramTable& operator [](int k) const {
                return freqs_[k];
        }
}; // kgramFreqs

#endif