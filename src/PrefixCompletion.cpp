#include "sbo.h"
using namespace Rcpp;

PrefixCompletion::PrefixCompletion(const Rcpp::List & object) : 
        N{object.attr("N")}, L{object.attr("L")}, EOS{object.attr("EOS")}
{
        dict = as<std::vector<std::string>>(object.attr("dict"));
        dict_ext = dict;
        dict_ext.push_back("<EOS>");
        dict_ext.push_back("<UNK>");
        for(int k = 0; k < N; k++){
                if(k == 0) pc.first.push_back(IntegerMatrix(1,0));
                else pc.first.push_back(
                                as<IntegerMatrix>(object[k])(_, Range(0, k - 1))
                        );
                pc.second.push_back(
                        as<IntegerMatrix>(object[k])(_, Range(k, k + L - 1))
                        );
        }
}