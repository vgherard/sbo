// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// fast_kgram_freqs_cpp
List fast_kgram_freqs_cpp(std::vector<std::string>& input, int N, const std::vector<std::string>& dict, std::string erase, bool lower_case, std::string EOS);
RcppExport SEXP _sbo_fast_kgram_freqs_cpp(SEXP inputSEXP, SEXP NSEXP, SEXP dictSEXP, SEXP eraseSEXP, SEXP lower_caseSEXP, SEXP EOSSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< std::vector<std::string>& >::type input(inputSEXP);
    Rcpp::traits::input_parameter< int >::type N(NSEXP);
    Rcpp::traits::input_parameter< const std::vector<std::string>& >::type dict(dictSEXP);
    Rcpp::traits::input_parameter< std::string >::type erase(eraseSEXP);
    Rcpp::traits::input_parameter< bool >::type lower_case(lower_caseSEXP);
    Rcpp::traits::input_parameter< std::string >::type EOS(EOSSEXP);
    rcpp_result_gen = Rcpp::wrap(fast_kgram_freqs_cpp(input, N, dict, erase, lower_case, EOS));
    return rcpp_result_gen;
END_RCPP
}
// get_kgram_prefix
IntegerVector get_kgram_prefix(const std::string& line, int N, const std::vector<std::string>& dict, std::string EOS);
RcppExport SEXP _sbo_get_kgram_prefix(SEXP lineSEXP, SEXP NSEXP, SEXP dictSEXP, SEXP EOSSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const std::string& >::type line(lineSEXP);
    Rcpp::traits::input_parameter< int >::type N(NSEXP);
    Rcpp::traits::input_parameter< const std::vector<std::string>& >::type dict(dictSEXP);
    Rcpp::traits::input_parameter< std::string >::type EOS(EOSSEXP);
    rcpp_result_gen = Rcpp::wrap(get_kgram_prefix(line, N, dict, EOS));
    return rcpp_result_gen;
END_RCPP
}
// get_pc_ptr
SEXP get_pc_ptr(const List& object);
RcppExport SEXP _sbo_get_pc_ptr(SEXP objectSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const List& >::type object(objectSEXP);
    rcpp_result_gen = Rcpp::wrap(get_pc_ptr(object));
    return rcpp_result_gen;
END_RCPP
}
// get_word_freqsC
std::unordered_map<std::string, int> get_word_freqsC(const std::vector<std::string>& text);
RcppExport SEXP _sbo_get_word_freqsC(SEXP textSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const std::vector<std::string>& >::type text(textSEXP);
    rcpp_result_gen = Rcpp::wrap(get_word_freqsC(text));
    return rcpp_result_gen;
END_RCPP
}
// kgram_freqs_cpp
List kgram_freqs_cpp(const std::vector<std::string>& sentences, int N, const std::vector<std::string>& dict);
RcppExport SEXP _sbo_kgram_freqs_cpp(SEXP sentencesSEXP, SEXP NSEXP, SEXP dictSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const std::vector<std::string>& >::type sentences(sentencesSEXP);
    Rcpp::traits::input_parameter< int >::type N(NSEXP);
    Rcpp::traits::input_parameter< const std::vector<std::string>& >::type dict(dictSEXP);
    rcpp_result_gen = Rcpp::wrap(kgram_freqs_cpp(sentences, N, dict));
    return rcpp_result_gen;
END_RCPP
}
// predict_sbo_predictor
CharacterMatrix predict_sbo_predictor(SEXP ptr_sexp, std::vector<std::string> input);
RcppExport SEXP _sbo_predict_sbo_predictor(SEXP ptr_sexpSEXP, SEXP inputSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< SEXP >::type ptr_sexp(ptr_sexpSEXP);
    Rcpp::traits::input_parameter< std::vector<std::string> >::type input(inputSEXP);
    rcpp_result_gen = Rcpp::wrap(predict_sbo_predictor(ptr_sexp, input));
    return rcpp_result_gen;
END_RCPP
}
// preprocess
std::vector<std::string> preprocess(std::vector<std::string> input, std::string erase, bool lower_case);
RcppExport SEXP _sbo_preprocess(SEXP inputSEXP, SEXP eraseSEXP, SEXP lower_caseSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< std::vector<std::string> >::type input(inputSEXP);
    Rcpp::traits::input_parameter< std::string >::type erase(eraseSEXP);
    Rcpp::traits::input_parameter< bool >::type lower_case(lower_caseSEXP);
    rcpp_result_gen = Rcpp::wrap(preprocess(input, erase, lower_case));
    return rcpp_result_gen;
END_RCPP
}
// tokenize_sentences
std::vector<std::string> tokenize_sentences(const std::vector<std::string>& input, std::string EOS);
RcppExport SEXP _sbo_tokenize_sentences(SEXP inputSEXP, SEXP EOSSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const std::vector<std::string>& >::type input(inputSEXP);
    Rcpp::traits::input_parameter< std::string >::type EOS(EOSSEXP);
    rcpp_result_gen = Rcpp::wrap(tokenize_sentences(input, EOS));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_sbo_fast_kgram_freqs_cpp", (DL_FUNC) &_sbo_fast_kgram_freqs_cpp, 6},
    {"_sbo_get_kgram_prefix", (DL_FUNC) &_sbo_get_kgram_prefix, 4},
    {"_sbo_get_pc_ptr", (DL_FUNC) &_sbo_get_pc_ptr, 1},
    {"_sbo_get_word_freqsC", (DL_FUNC) &_sbo_get_word_freqsC, 1},
    {"_sbo_kgram_freqs_cpp", (DL_FUNC) &_sbo_kgram_freqs_cpp, 3},
    {"_sbo_predict_sbo_predictor", (DL_FUNC) &_sbo_predict_sbo_predictor, 2},
    {"_sbo_preprocess", (DL_FUNC) &_sbo_preprocess, 3},
    {"_sbo_tokenize_sentences", (DL_FUNC) &_sbo_tokenize_sentences, 2},
    {NULL, NULL, 0}
};

RcppExport void R_init_sbo(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
