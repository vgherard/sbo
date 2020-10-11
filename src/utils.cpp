#include "sbo.h"
using std::string;
using std::vector;

unsigned short int match(const string& word, const vector<string>& dict){
        auto it = find(dict.begin(), dict.end(), word);
        if (it == dict.end()) return dict.size() + 2;
        return 1 + distance(dict.begin(), it);
}
