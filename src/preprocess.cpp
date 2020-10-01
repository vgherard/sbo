#include <Rcpp.h>
#include <cctype>
#include <regex>
using namespace std;

// [[Rcpp::export]]
string preprocess(const vector<string>& lines, const string sep = " . ") {
        string text;
        for(string const& line : lines) text += line + sep;
        text = regex_replace(text, regex(R"([.?!:;])"), sep);
        text = regex_replace(text, regex(R"([^'.\w\s])"), "");
        text = regex_replace(text, regex(R"(\s+)"), " ");
        text = regex_replace(text, regex(R"((\s*\.+\s*)+)"), sep);
        for(char& c: text) c = tolower(c);
        return text;
}
