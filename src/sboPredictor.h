/* 
Store Stupid-Back-Off model predictions in hash-tables of the form:
        {key = (k - 1)-gram input, value = {a fixed # of top scoring next words}}
 E.g.: the typical key-value pair for a 2-gram input looks as follows:
        {"i love", {"cats", "me", "you"}}
*/ 
#if !defined(SBO_PREDICTOR_H)
#define SBO_PREDICTOR_H

// [[Rcpp::plugins(cpp11)]]

#include <string>
#include <vector>
#include <unordered_set>
#include <unordered_map>
#include "kgramFreqs.h"

using Dictionary = std::unordered_set<std::string>;
using PredictionTable = 
        std::unordered_map<std::string, std::vector<std::string> >; 

class sboPredictor {
        int N_;
        Dictionary dict_;
        double lambda_;
        int L_;
        Dictionary banned_;
        /* 
         preds_[k][input] stores the top scoring next words for inputs of 
         k - 1 words.
         If the input was not observed in the training corpus, delete the
         first word and back-off to preds_[k - 1]
         */
        std::vector<PredictionTable> preds_;
public:
        sboPredictor(const kgramFreqs&, double, int, Dictionary);
        PredictionTable& operator [](int k) {
                return preds_[k];
        }
        const PredictionTable& operator [](int k) const {
                return preds_[k];
        }
        size_t memory_size() const {
                size_t size = 0;
                for(int k = 0; k < N_; ++k) size += sizeof preds_[k];
                return size;
        }
};

#endif