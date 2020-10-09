// [[Rcpp::plugins(cpp11)]]
#include <Rcpp.h>
#include "sbo.h"
using namespace Rcpp;
using word = unsigned short int;

int find_row(IntegerMatrix m, IntegerVector x) {
        for(int i = 0; i < m.nrow(); i++){
                if(is_true(all(IntegerVector(m(i, _)) == x))) return i;
        }
        return -1;
}

// [[Rcpp::export]]
CharacterMatrix predict_sbo_preds(List object, std::vector<std::string> input) {
        std::vector<std::string> dict = object["dict"];
        std::vector<std::string> dict_ext = dict;
        dict_ext.push_back("<EOS>"); dict_ext.push_back("<UNK>");
        int N = object["N"]; int L = object["L"];
        const List & preds(object["preds"]);
        CharacterMatrix output(input.size(), L); int i = 0;
        for(std::string line : input){
                IntegerVector prefix = make_Ngram_prefix(line, N, dict);
                for(int k = N - 1; k >= 0; k--){
                        int row = find_row(
                                as<IntegerMatrix>(preds[k])(_, Range(0, k - 1)),
                                prefix);
                        if(row != -1){
                                for(int j = 0; j < L; j++)
                                        output(i, j) = dict_ext[as<IntegerMatrix>(preds[k])(row, k + j) - 1];
                                break;
                                }
                        prefix.erase(0);
                }
                i++;
        }
        return output;
}

