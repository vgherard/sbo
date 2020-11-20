# sbo (development version)

#### API and UI changes 
* Former `sbo_preds` S3 class is now substituted by two classes.
        - `sbo_predictor`: for interactive use
        - `sbo_predtable`: for storing text predictors out of memory (e.g. `save()` to file)
* `sbo_predictor` and `sbo_predtable` objects are obtained by `train_predictor()` and `sbo_predtable()` respectively.
* `sbo_predictor()` allows to rapidly recover a `sbo_predictor` from a `sbo_predtable`.
* The `sbo_predictor` implementation dramatically improves the speed of `predict()` (by a factor of x10). A single call to `predict()` now allocates a few kBs of RAM (whereas it previously allocated few MBs, c.f. issue #10)
* metadata of `sbo_kgram_freqs` and `sbo_pred*` objects are now attributes (#11).

#### New features
* Added `summary()` methods for `sbo_kgram_freqs` and `sbo_pred*` objects; correspondingly, the output of `print()` has been simplified considerably (#5).

#### Patches
* Removed unnecessary `Depends` from DESCRIPTION.

#### Documentation
* Added package entry.

# sbo 0.3.2
* Patch addressing unexpected behaviour of `erase` argument in 
`preprocess()` and `kgram_freqs_fast()`, c.f. issue #17.

# sbo 0.3.1
* Changed leading to trailing underscore in private variables definition of C++ `kgramFreqs` class, as per §1.6.4 of the "Writing R extensions" guide.
* Removed Catch tests infrastructure for C++ code.

# sbo 0.3.0
* Added `kgram_freqs_fast()` for fast and memory efficient kgram 
tokenization using the default text preprocessing utility.

# sbo 0.2.0
* The infrastructure of `kgram_freqs()`, `get_word_freqs()`, `preprocess()`,  and `predict.sbo_preds()` has been entirely rewritten in C++.
* Added `tokenize_sentences()` function for sentence level tokenization.
* `kgram_freqs()` now accepts any user defined single character EOS token, through the `EOS` argument.

# sbo 0.1.2

* Added `preproc` argument to `kgram_freqs()` and `get_word_freqs()`, for 
custom training corpus preprocessing.
* The `dict` argument of `kgram_freqs()` now also accepts numeric values,
allowing to build a dictionary directly from the training corpus.

# sbo 0.1.1

* Added `predict` method for `sbo_kgram_freqs` class.
