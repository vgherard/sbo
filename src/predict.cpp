#include "sbo.h"
using namespace Rcpp;
using word = unsigned short int;

void fill_kgram_prefix(IntegerVector & kgram_prefix, 
                       const std::string& line,
                       XPtr<PrefixCompletion> ptr){
        size_t start = line.find_last_of(ptr->EOS);
        start = line.find_first_not_of(" ", start + 1);
        size_t end;
        while((end = line.find_first_of(" ", start)) != std::string::npos){
                word w = match(line.substr(start, end - start), ptr->dict);
                kgram_prefix.push_back(w);
                kgram_prefix.erase(0);
                start = line.find_first_not_of(" ", end);
        }
        if(start != std::string::npos){
                word w = match(line.substr(start), ptr->dict);
                kgram_prefix.push_back(w);
                kgram_prefix.erase(0);
        }
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

void fill_output_matrix(CharacterMatrix& out_mat,
                        int cur_row,
                        IntegerVector & prefix,
                        XPtr<PrefixCompletion> ptr
                        ){
        for(int k = ptr->N - 1; k >= 0; k--){
                int r = get_row(ptr->pc.first[k], prefix);
                if(r != -1){
                        for(int j = 0; j < ptr->L; j++){
                                int w = ptr->pc.second[k](r, j);
                                out_mat(cur_row, j) = ptr->dict_ext[w - 1];
                        }
                        break;
                }
                prefix.erase(0);
        }
}

// [[Rcpp::export]]
CharacterMatrix predict_sbo_preds(SEXP ptr_sexp,
                                  std::vector<std::string> input) {
        XPtr<PrefixCompletion> ptr(ptr_sexp);
        CharacterMatrix output_matrix(input.size(), ptr->L);
        int current_row = 0;
        for(const std::string & line : input){
                IntegerVector prefix(ptr->N - 1, 0);
                fill_kgram_prefix(prefix, line, ptr);
                fill_output_matrix(output_matrix, current_row, prefix, ptr);
                current_row++;
        }
        return output_matrix;
}