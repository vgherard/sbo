#include "sboPredictor.h"
#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>
#include <unordered_set>
#include <gperftools/heap-profiler.h>

std::vector<std::string> read_lines(std::string path) {
        std::ifstream file;
        file.open(path);
        std::vector<std::string> lines;
        std::string line;
        if (file.is_open()) {
                for( std::string line; getline(file, line); )
                {
                        lines.push_back(line);
                }
        } else {
                std::cout << "Unable to open file at: " << path << ".\n";
                throw;
        }
        file.close();
        return lines;
}

int main() {
        std::vector<std::string> text = 
                read_lines("/home/vale/R/sbo/processed.txt");
        std::vector<std::string> dict_vec = 
                read_lines("/home/vale/R/sbo/dict.txt");
        std::unordered_set<std::string> dict;
        for (auto & x : dict_vec) dict.insert(x);
        dict.insert("<BOS>"); dict.insert("<EOS>");
        
        int N = 3;
        int L = 3;
        double lambda = 0.4;
        
        kgramFreqs freqs(text, dict, N);
        sboPredictor p(freqs, lambda, L, {"<UNK>"});
        
        std::cout << "text length = " << text.size() << "\n";
        std::cout << "dict length = " << dict.size() << "\n";
        
        PredictionTable & pt = p[2];
        std::vector<std::string> preds = pt["i love"];
        std::cout << "Predictions for input 'i love':" << "\n";
        std::cout << preds[0] << " " << preds[1] << " " << preds[2] << "\n\n";
        return 0;
}