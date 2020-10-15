# sbo 0.3.0
* Added `get_kgram_freqs_fast()` for fast and memory efficient kgram 
tokenization using the default text preprocessing utility.

# sbo 0.2.0
* The infrastructure of `get_kgram_freqs()`, `get_word_freqs()`, `preprocess()`,  and `predict.sbo_preds()` has been entirely rewritten in C++.
* Added `tokenize_sentences()` function for sentence level tokenization.
* `get_kgram_freqs()` now accepts any user defined single character EOS token, through the `EOS` argument.

# sbo 0.1.2

* Added `preproc` argument to `get_kgram_freqs()` and `get_word_freqs()`, for 
custom training corpus preprocessing.
* The `dict` argument of `get_kgram_freqs()` now also accepts numeric values,
allowing to build a dictionary directly from the training corpus.

# sbo 0.1.1

* Added `predict` method for `kgram_freqs` class.
