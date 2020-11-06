## Patch release summary
This is a patch release to address minor issues arisen from CRAN binary builds of
v0.3.0.

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