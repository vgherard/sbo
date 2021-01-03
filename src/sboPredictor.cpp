#include "sboPredictor.h"
#include <utility>
#include <algorithm>
#include <iostream> // For debugging purposes

using std::string;
using std::vector;
using std::pair;
using std::unordered_map;

struct WordScore {
        string word;
        double score;
        WordScore() : word(""), score(0.) {}
        WordScore(const pair<const std::__cxx11::basic_string<char>, double> wc) 
                : word(wc.first), score(wc.second) {}
        WordScore(const string& w, const double & s) : word(w), score(s) {}
        friend bool operator<(const WordScore & l, const WordScore & r) {
                if (l.score == r.score) {
                        if (r.word == "___TOTAL___") return true;
                        if (l.word == "___TOTAL___") return false;
                        return l.word > r.word;
                } else {
                        return l.score < r.score;
                }
        }
};

struct PrefixScoreTable {
        vector<WordScore> word_scores;
        Dictionary words;
        size_t min_index();
        PrefixScoreTable() : word_scores(0), words({}) {}
        PrefixScoreTable(const unordered_map<string, double>&, 
                         int, 
                         const Dictionary&);
        bool seen(string word) { return words.find(word) != words.end(); }
        void backoff(const PrefixScoreTable&, double);
};

size_t PrefixScoreTable::min_index() {
        size_t min_index = 0; 
        WordScore min = word_scores[0];
        for (size_t i = 1; i < word_scores.size(); i++) {
                if (word_scores[i] < min) {
                        min_index = i;
                        min = word_scores[i];
                }
        }
        return min_index;
}

PrefixScoreTable::PrefixScoreTable(
        const unordered_map<string, double>& word_counts, 
        int L,
        const Dictionary & banned
) : word_scores(L+1)
{
        size_t min_index_ = 0;
        auto itend = word_counts.end();
        for (auto it = word_counts.begin(); it != itend; ++it) {
                if (banned.find((*it).first) != banned.end()) 
                        continue;
                words.insert((*it).first);
                if (word_scores[min_index_] < *it) {
                        word_scores[min_index_] = *it;
                        min_index_ = min_index();
                }
        }
        sort(word_scores.begin(), word_scores.end());
        for (size_t i = 0; i < L; i++) {
                word_scores[i].score /= word_scores[L].score; 
        }
        word_scores.pop_back();
        // word_scores.resize(L);
}

void PrefixScoreTable::backoff(const PrefixScoreTable& ps_backoff, double lam) 
{
        auto itend = ps_backoff.word_scores.end();
        for (auto it = ps_backoff.word_scores.begin(); it != itend; ++it) {
                if (not seen((*it).word)) {
                        word_scores.push_back({(*it).word, lam * (*it).score});
                }
        }
}

sboPredictor::sboPredictor(const kgramFreqs& freqs, 
                           double lambda,
                           int L,
                           Dictionary banned
                           )
        : N_(freqs.N()), dict_(freqs.dict()), 
          lambda_(lambda), L_(L), banned_(banned),
          preds_(N_)
{
        // Prefix-Prediction-Score tables
        vector<unordered_map<string, PrefixScoreTable> > pps(N_);
        for (int k = 0; k < N_; k++) {
                pps[k].reserve(freqs[k].size());
                preds_[k].reserve(freqs[k].size());
        }
        size_t i = 0;
        size_t pos;
        string backoff_prefix;
        for (int k = 0; k < N_; ++k) {
                auto itend = freqs[k].end();
                for (auto it = freqs[k].begin(); it != itend; ++it) {
                        pps[k][(*it).first] = 
                                PrefixScoreTable((*it).second, L, banned);
                        PrefixScoreTable &ps = pps[k][(*it).first];
                        if (k == 0) goto build_pps;
                        if (k == 1) backoff_prefix = "";
                        else {
                                pos = (*it).first.find_first_of(" ");
                                pos = (*it).first.find_first_not_of(" ", pos);
                                backoff_prefix = (*it).first.substr(pos);
                        }
                        ps.backoff(pps[k - 1][backoff_prefix], lambda);
                build_pps:
                        sort(ps.word_scores.rbegin(), ps.word_scores.rend());
                        ps.word_scores.resize(L);
                        for(i = 0; i < L; ++i)
                                preds_[k][(*it).first].push_back(
                                                ps.word_scores[i].word
                                );
                }
        }
        for (int k = 0; k < N_; k++) pps[k].clear();
} 