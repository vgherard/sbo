#include "sbo.h"
using namespace Rcpp;

// [[Rcpp::export]]
List kgram_freqs_fast_cpp(std::vector<std::string>& input,
                          int N,
                          const std::vector<std::string>& dict,
                          std::string erase = "[^.?!:;'\\w\\s]",
                          bool lower_case = true,
                          std::string EOS = ".?!:;"){
        kgramFreqs freqs(N);
        std::regex erase_(erase);
        for(std::string str : input){
                if (erase != "") str = std::regex_replace(str, erase_, "");
                if (lower_case) for (char& c : str) c = tolower(c);
                size_t begin = std::string::npos;
                while(begin != 0){
                        begin = str.find_last_of(EOS) + 1;
                        std::deque<std::string> words_queue(N - 1, "0");
                        size_t start = str.find_first_not_of(" ", begin);
                        bool empty_sent = (start == std::string::npos);
                        size_t end;
                        while((end = str.find_first_of(" ", start)) != std::string::npos){
                                unsigned short int w{
                                        match(str.substr(start, end - start), dict)
                                        };
                                words_queue.push_back(std::to_string(w));
                                freqs.insert(words_queue);
                                words_queue.pop_front();
                                start = str.find_first_not_of(" ", end);
                        }
                        if(start != std::string::npos){
                                unsigned short int last_w =
                                        match(str.substr(start), dict);
                                words_queue.push_back(std::to_string(last_w));
                                freqs.insert(words_queue);
                                words_queue.pop_front();
                        }
                        if(not empty_sent){
                                words_queue.push_back(std::to_string(dict.size() + 1));
                                freqs.insert(words_queue);
                        }
                        if(begin != 0) str.erase(begin - 1);
                }
        }
        List l;
        freqs.save_to_R_list(l);
        return l;
}
