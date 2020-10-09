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
                :_N(N), _freqs(N)
        {
        deque<string> empty_queue(N - 1, "0");
        for(auto sentence: sentences){
                if(sentence == "") continue;
                deque<string> words_queue = empty_queue;
                size_t start = sentence.find_first_not_of(" "); size_t end;
                while((end = sentence.find_first_of(" ", start)) != string::npos
                              ){
                        word w{match(sentence.substr(start, end - start), dict)};
                        words_queue.push_back(std::to_string(w));
                        push(words_queue);
                        words_queue.pop_front();
                        start = sentence.find_first_not_of(" ", end);
                }
                word last_w = match(sentence.substr(start), dict);
                words_queue.push_back(std::to_string(last_w));
                push(words_queue);
                words_queue.pop_front();
                words_queue.push_back(std::to_string(dict.size() + 1));
                push(words_queue);
        }
}

void kgramFreqs::push(const deque<string>& words_queue){
        auto rit = words_queue.rbegin();
        string kgram = *rit;
        _freqs[0][kgram]++;
        rit++;
        for(int k = 1; k < N(); k++){
                kgram += " " + *rit;
                _freqs[k][kgram]++;
                rit++;
        }
}

List kgramFreqs::make_R_list() const {
        List l;
        for(int k = 0; k < N(); k++){
                IntegerMatrix m(_freqs[k].size(), k + 2); int i = 0;
                for(const auto& freq: _freqs[k]){
                        size_t end = -1; size_t start;
                        for(int j = k; j >= 0; j--){
                                start = end + 1;
                                end = freq.first.find_first_of(" ", start);
                                m(i, j) = std::stoi(
                                        freq.first.substr(start, end - start)
                                );
                        }
                        m(i, k + 1) = freq.second;
                        i++;
                }
                l.push_back(m);
        }
        return l;
}
