## Test environments
* local Ubuntu 20.04.1 install, R 4.0.2
* win-builder (devel, release and oldrealese)

## R CMD check results
There were no ERRORs or WARNINGs. 

There was 1 NOTE from win-builder check:

* New submission

and 1 NOTE from check on local Ubuntu:

* installed size is 25.2Mb
     sub-directories of 1Mb or more:
       data   6.7Mb
       libs  18.3Mb

The size is due to example datasets (~5 MB) and C++ libraries.
