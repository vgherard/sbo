#include "kgramFreqs.h"
using std::string;

// Insert k-grams from a sentence into frequency tables

void kgramFreqs::insert(string sentence, 
                        CircularBuffer<std::pair<size_t, size_t> >& stream) {
        // Skip empty sentences
        if(sentence == "") 
                return;
        
        // Pad sentence with <BOS> and <EOS> tokens
        string pre_pad = "";
        for(size_t i = 0; i <= N_ - 1; ++i) {
                pre_pad += "<BOS> ";
                stream.push({6 * i, 6 * i + 5});
        };
        sentence = pre_pad + sentence + " <EOS> .";
        
        // Iterate over words - substrings separated by spaces
        size_t e, s, s1, e1; // Positions along a string
        string prefix, prev_word, completion;
        s = sentence.find_first_not_of(" ", stream.last().second);
        while ((e = sentence.find_first_of(" ", s)) != string::npos) {
                // Read current word
                completion = sentence.substr(s, e - s);
                // Substitute with <UNK> if not in dictionary
                if (dict_.find(completion) == dict_.end()) completion = "<UNK>";
                prefix = "";
                // Increase k-gram counts for k-grams ending at current word
                for(int k = 0; k < N_; ++k) {
                        if (k > 0) {
                                s1 = stream.at(N_ - k).first;
                                e1 = stream.at(N_ - k).second;
                                prev_word = sentence.substr(s1, e1 - s1);
                                if (k == 1) prefix = prev_word;
                                else prefix = prev_word + " " + prefix;
                        }
                        freqs_[k][prefix][completion]++;
                        freqs_[k][prefix]["___TOTAL___"]++;
                }
                // Push start and end of current word into stream;
                stream.push({s, e});
                // Get position of next word
                s = sentence.find_first_not_of(" ", e);
        }
}

// void kgramFreqs::save_to_R_list(List& l) const {
//         size_t start;
//         for(int k = 0; k < N(); k++){
//                 l.push_back(IntegerMatrix(freqs_[k].size(), k + 2));
//                 int i = 0;
//                 for(const auto& f: freqs_[k]){
//                         // kgram strings start with a space by construction
//                         size_t end = 0;
//                         for(int j = k; j >= 0; j--){
//                                 start = end + 1;
//                                 end = f.first.find_first_of(" ", start);
//                                 as<IntegerMatrix>(l[k])(i, j) = std::stoi(
//                                         f.first.substr(start, end - start)
//                                 );
//                         }
//                         as<IntegerMatrix>(l[k])(i, k + 1) = f.second;
//                         i++;
//                 }
//         }
// }
