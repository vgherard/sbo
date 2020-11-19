#include <Rcpp.h>
#include "sbo.h"
using namespace Rcpp;
using std::string;
using std::vector;
using std::deque;
using word = unsigned short int;

// Class constructor

kgramFreqs::kgramFreqs(const vector<string>& sentences,
                       const vector<string>& dict,
                       int N)
                :N_(N), freqs_(N)
        { for(const string& sentence: sentences) insert(sentence, dict); }

void kgramFreqs::insert(const string& sentence, const vector<string>& dict){
        if(sentence == "") return;
        deque<string> words_queue(N_ - 1, "0");
        size_t end;
        size_t start = sentence.find_first_not_of(" ");
        while((end = sentence.find_first_of(" ", start)) != string::npos){
                word w{ match(sentence.substr(start, end - start), dict) };
                words_queue.push_back(std::to_string(w));
                insert(words_queue);
                words_queue.pop_front();
                start = sentence.find_first_not_of(" ", end);
        }
        if(start != string::npos){
                word last_w = match(sentence.substr(start), dict);
                words_queue.push_back(std::to_string(last_w));
                insert(words_queue);
                words_queue.pop_front();
        }
        words_queue.push_back(std::to_string(dict.size() + 1));
        insert(words_queue);
}

void kgramFreqs::insert(const deque<string>& words_queue){
        string kgram;
        int k = 0;
        auto rend = words_queue.rend();
        for(auto rit = words_queue.rbegin(); rit != rend; rit++){
                kgram += " " + *rit;
                freqs_[k][kgram]++;
                k++;
        }
}

void kgramFreqs::save_to_R_list(List& l) const {
        size_t start;
        for(int k = 0; k < N(); k++){
                l.push_back(IntegerMatrix(freqs_[k].size(), k + 2));
                int i = 0;
                for(const auto& f: freqs_[k]){
                        // kgram strings start with a space by construction
                        size_t end = 0;
                        for(int j = k; j >= 0; j--){
                                start = end + 1;
                                end = f.first.find_first_of(" ", start);
                                as<IntegerMatrix>(l[k])(i, j) = std::stoi(
                                        f.first.substr(start, end - start)
                                );
                        }
                        as<IntegerMatrix>(l[k])(i, k + 1) = f.second;
                        i++;
                }
        }
}
