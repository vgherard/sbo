## New release summary
This is a major release, introducing important API changes and new functionalities in the package, as well as fixing some bugs and over-specified dependencies in the previous version (v0.3.2). Some highlights:

- *Classes*: the (S3) class structure of the package has been thoroughly reorganized and extended.
- *Functionalities*: the new version has an extended set of tools, in particular
related to the creation of word dictionaries.
- *Tests*: the test-suite has been greatly extended, with special attention to
probing the correctness of the Stupid Back-Off algorithm implementation.
- *Dependencies*: many unnecessary dependencies in the previous version have been removed, in favor of `base` R tools.

## Test environments
* local Ubuntu 20.04.1 install, R 4.0.2
* win-builder (devel, release and oldrealese)

## R CMD check results
There were no ERRORs, WARNINGs.

There was 1 NOTE from both local and win-builder checks:
* Days since last update: 2
    - This submission is a quick fix for problems undetected prior CRAN acceptance.

There was 1 additional NOTE from local check:
* installed size is 16.2Mb
    sub-directories of 1Mb or more:
      data   5.1Mb
      libs  10.9Mb
    - The extra size is due to an important example dataset, and to C++ libraries. This has not changed since previous submission.