#include "sbo.h"
using namespace Rcpp;

void get_word_freqsC(const std::string& sentence,
                     std::unordered_map<std::string, int>& freqs){
        if(sentence == "") return;
        size_t start = 0;
        size_t end;
        while((end = sentence.find_first_of(" ", start)) != std::string::npos){
                std::string word = sentence.substr(start, end - start);
                freqs[word]++;
                start = sentence.find_first_not_of(" ", end);
        }
        if(start != std::string::npos){
                std::string last_word = sentence.substr(start);
                freqs[last_word]++;
        }
}

// [[Rcpp::export]]
std::unordered_map<std::string, int> 
        get_word_freqsC(const std::vector<std::string>& text)
{
        std::unordered_map<std::string, int> freqs;
        for(const std::string& sentence: text) get_word_freqsC(sentence, freqs);
        return freqs;
}
