#include "sbo.h"
using namespace Rcpp;
using word = unsigned short int;

void fill_Ngram_prefix(const std::string& line, IntegerVector& prefix,
                      int N, const std::vector<std::string>& dict,
                      std::string EOS){
        size_t start = line.find_last_of(EOS) + 1;
        size_t end;
        while((end = line.find_first_of(" ", start)) != std::string::npos){
                prefix.push_back(match(line.substr(start, end - start), dict));
                prefix.erase(0);
                start = line.find_first_not_of(" ", end);
        }
        prefix.push_back(match(line.substr(start), dict));
        prefix.erase(0);
}

int get_row(const IntegerMatrix& m, const IntegerVector& x) {
        for(int i = 0; i < m.nrow(); i++)
                if(is_true(all(IntegerVector(m(i, _)) == x))) return i;
        return -1;
}

void fill_output_matrix(const int& N, const List& preds, IntegerVector& prefix,
                        const int& L, CharacterMatrix& output,
                        const std::vector<std::string>& dict_ext,
                        int& i
                        ){
        for(int k = N - 1; k >= 0; k--){
                int r = get_row(as<IntegerMatrix>(preds[k])(_, Range(0, k - 1)),
                                prefix);
                if(r != -1){
                        for(int j = 0; j < L; j++){
                                int w = as<IntegerMatrix>(preds[k])(r, k + j);
                                output(i, j) = dict_ext[w - 1];
                        }
                        break;
                }
                prefix.erase(0);
        }
        i++;
}

// [[Rcpp::export]]
CharacterMatrix predict_sbo_preds(List object, std::vector<std::string> input) {
        std::vector<std::string> dict = object["dict"];
        std::vector<std::string> dict_ext = dict;
        dict_ext.push_back("<EOS>");
        dict_ext.push_back("<UNK>");
        std::string EOS = object["EOS"];
        int N = object["N"];
        int L = object["L"];
        const List & preds(object["preds"]);
        CharacterMatrix output(input.size(), L);
        int i = 0;
        for(const std::string& line : input)
                {
                IntegerVector prefix(N - 1, 0);
                fill_Ngram_prefix(line, prefix, N, dict, EOS);
                fill_output_matrix(N, preds, prefix, L, output, dict_ext, i);
                }
        return output;
}
