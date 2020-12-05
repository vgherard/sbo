# CRAN submission: sbo v0.5.0

## New release summary
This is a major release, introducing important API changes and new functionalities in the package, as well as fixing some bugs and over-specified dependencies in the previous version (v0.3.2). Some highlights:

- *Classes*: the (S3) class structure of the package has been thoroughly reorganized and extended.
- *Functionalities*: the new version has an extended set of tools, in particular
related to the creation of word dictionaries.
- *Tests*: the test-suite has been greatly extended, with special attention to
probing the correctness of the Stupid Back-Off algorithm implementation.
- *Dependencies*: many unnecessary dependencies in the previous version have been removed, in favor of `base` R tools.

## Test environments
I have checked `sbo` on the following platforms (see next Section for details
on the NOTEs):

* local: 
        
        - Ubuntu 20.04.1 install, R 4.0.2 (1 NOTE)
* win-builder: 

        - devel (OK)
        - release (OK)
        - oldrealese (1 NOTE)

* rhub, using `env_vars=c(R_COMPILE_AND_INSTALL_PACKAGES = "always")`:

        - Windows Server 2008 R2 SP1, R-devel, 32/64 bit (1 NOTE)
        - Ubuntu Linux 16.04 LTS, R-release, GCC (3 NOTEs)
        - Fedora Linux, R-devel, clang, gfortran (1 NOTE)
        - Debian Linux, R-devel, GCC ASAN/UBSAN (OK)

## R CMD check results
There were no ERRORs, WARNINGs.

There were the following NOTEs:

```
* checking CRAN incoming feasibility ... NOTE
Maintainer: ‘Valerio Gherardi <vgherard@sissa.it>’

Found the following (possibly) invalid URLs:
  URL: https://www.kaggle.com/crmercado/tweets-blogs-news-swiftkey-dataset-4million
    From: man/twitter_test.Rd
          man/twitter_train.Rd
    Status: 404
    Message: Not Found
    
Platforms: rhub (Ubuntu R-release, Fedora R-devel)
```

The URL is correct and working.

```
> checking installed package size ... NOTE
    installed size is **.*Mb
    sub-directories of 1Mb or more:
      data   3.9Mb
      libs  **.*Mb
Platforms: local, rhub (Windows R-devel, Ubuntu R-release, Fedora R-devel), 
```

The extra size is due to an example dataset, and to C++ compiled libraries (variable size on different platforms). These are both required for the correct package working, and have not changed since my previous submission.

```
* checking R code for possible problems ... [9s] NOTE
plot.word_coverage: no visible global function definition for 'plot'
Undefined global functions or variables:
  plot
Consider adding
  importFrom("graphics", "plot")
to your NAMESPACE file.
Platforms: win-builder (old-release), rhub (Ubuntu R-release) 
```

According to the documentation of `?plot`:

«The plot generic was moved from the graphics package to the base package in R 4.0.0. It is currently re-exported from the graphics namespace to allow packages importing it from there to continue working, but this may change in future versions of R.»

I am not importing `plot` from the `graphics` library to avoid breaking of the package with future versions of `R`. On the other hand, the `graphics` is almost always attached in a normal `R` session, so this does not seem to cause any issue even with `R < 4.0.0`.

## Reverse dependencies

There were no reverse dependencies to be checked.