# sbo 0.5.0

#### API and UI changes 
* Former `kgram_freqs` class is now called `sbo_kgram_freqs`. The constructor
`kgram_freqs()` is still available as an alias to `sbo_kgram_freqs()`.
* Former `sbo_preds` class is now substituted by two classes:
        
        - `sbo_predictor`: for interactive use
        - `sbo_predtable`: for storing text predictors out of memory (e.g. 
        `save()` to file)
        
* `sbo_predictor` and `sbo_predtable` objects are obtained by the homonym 
constructors, which are now S3 generics accepting `character` input, as well as
`sbo_kgram_freqs` and `sbo_predtable` (for the `sbo_predictor()` constructor) 
class objects. In particular, these allow to directly train a text predictor
without storing the intermediate `sbo_dictionary`, and `kgram_freqs` objects.
* The behaviour of the `dict` argument in `kgram_freqs()` and `kgram_freqs_fast()`  has changed, now accepting either a `sbo_dictionary`, a `character` or a `formula` (see also 'New features').
* The `sbo_predictor` implementation dramatically improves the speed of 
`predict()` (by a factor of x10). A single call to `predict()` now allocates a 
few kBs of RAM (whereas it previously allocated few MBs, c.f. issue #10).
* Metadata of `sbo_kgram_freqs` and `sbo_pred*` objects is now stored via 
attributes (#11).

#### New features
* New S3 class `sbo_dictionary`.
* New S3 class `word_coverage` with generic constructors and a preconfigured
`plot()` method. 
* Dictionaries in `kgram_freqs()` and `sbo_pred*()` can now
be built also with a fixed target coverage fraction of training corpus.
* Added `prune()` generic function for reducing -gram order of 
`kgram_freqs` and `sbo_predtable`'s.
* Added `summary()` methods for `sbo_kgram_freqs` and `sbo_pred*` objects; 
correspondingly, the output of `print()` has been simplified considerably (#5).
* The object of class `sbo_kgram_freqs`, `sbo_dictionary`, `sbo_predictor` and
`sbo_predtable` can be constructed either through the homonymous constructors,
or through the aliases `kgram_freqs()`, `dictionary()`, `predictor()`,
`predtable()`.

#### Other improvements and patches
* `sbo` now has `SystemRequirements: C++11`, for correct integration with C++11 code (in particular `std::unordered_map`).
* Model training (with `sbo_predictor()`) is now considerably faster, due to
optimizations in the algorithm for building Stupid Back-Off prediction tables.
* The Stupid Back-Off algorithm is now thoroughly tested, and small 
inconsistencies between the `predict.kgram_freqs()` and 
`predict.sbo_predictor()` methods have been fixed, including:

        - Proper handling of unknown words
        - Consistent handling of ties in prediction probabilities.
* Model evaluation in `eval_sbo_predictor()` is now carried out by sampling
a single sentence from each document in test corpus.
* Removed unnecessary dependencies from `Depends` and `Imports` package fields.

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
