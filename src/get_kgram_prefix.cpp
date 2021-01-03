// #include "sbo.h"
// using namespace Rcpp;
// using word = unsigned short int;
// 
// // [[Rcpp::export]]
// IntegerVector get_kgram_prefix(const std::string& line,
//                                int N, const std::vector<std::string>& dict,
//                                std::string EOS){
//         IntegerVector prefix(N - 1, 0);
//         size_t start = line.find_first_not_of(" ", line.find_last_of(EOS) + 1);
//         size_t end;
//         while((end = line.find_first_of(" ", start)) != std::string::npos){
//                 prefix.push_back(match(line.substr(start, end - start), dict));
//                 prefix.erase(0);
//                 start = line.find_first_not_of(" ", end);
//         }
//         if(start != std::string::npos){
//                 prefix.push_back(match(line.substr(start), dict));
//                 prefix.erase(0);
//         }
//         return prefix;
// }