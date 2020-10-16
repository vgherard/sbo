#include "sbo.h"
using namespace Rcpp;
using word = unsigned short int;

void fill_Ngram_prefix(const std::string& line, IntegerVector& prefix,
                      int N, const std::vector<std::string>& dict,
                      std::string EOS){
        size_t start = line.find_first_not_of(" ", line.find_last_of(EOS) + 1);
        size_t end;
        while((end = line.find_first_of(" ", start)) != std::string::npos){
                prefix.push_back(match(line.substr(start, end - start), dict));
                prefix.erase(0);
                start = line.find_first_not_of(" ", end);
        }
        if(start != std::string::npos){
                prefix.push_back(match(line.substr(start), dict));
                prefix.erase(0);
        }
}

// [[Rcpp::export]]
IntegerVector get_Ngram_prefix(const std::string& line,
                               int N, const std::vector<std::string>& dict,
                               std::string EOS){
        IntegerVector prefix(N - 1, 0);
        fill_Ngram_prefix(line, prefix, N, dict, EOS);
        return prefix;
}

int get_row(const IntegerMatrix& m, const IntegerVector& ref) {
        int nrows = m.nrow(); int ncols = m.ncol(); unsigned short int j;
        for(int i = 0; i < nrows; i++){
                for(j = 0; j < ncols; j++) {
                        if (m(i, j) != ref[j]) goto next;
                }
                return i;
                next: continue;
        }
        return -1;
}

void fill_output_matrix(const int& N,
                        const std::vector<IntegerMatrix>& prefixes,
                        const std::vector<IntegerMatrix>& completions,
                        IntegerVector& prefix,
                        const int& L, CharacterMatrix& output,
                        const std::vector<std::string>& dict_ext,
                        int& i
                        ){
        for(int k = N - 1; k >= 0; k--){
                int r = get_row(prefixes[k], prefix);
                if(r != -1){
                        for(int j = 0; j < L; j++){
                                int w = completions[k](r, j);
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
        std::vector<IntegerMatrix> prefixes;
        std::vector<IntegerMatrix> completions;
        for(int k = 0; k < N; k++){
                if(k == 0) prefixes.push_back(IntegerMatrix(1,0));
                else prefixes.push_back(
                                as<IntegerMatrix>(preds[k])(_, Range(0, k - 1))
                        );
                completions.push_back(
                        as<IntegerMatrix>(preds[k])(_, Range(k, k + L - 1))
                );
        }
        CharacterMatrix output(input.size(), L);
        int i = 0;
        for(const std::string& line : input)
                {
                IntegerVector prefix(N - 1, 0);
                fill_Ngram_prefix(line, prefix, N, dict, EOS);
                fill_output_matrix(N, prefixes, completions, prefix, L, output,
                                   dict_ext, i);
                }
        return output;
}
