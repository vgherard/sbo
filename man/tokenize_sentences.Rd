% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{tokenize_sentences}
\alias{tokenize_sentences}
\title{Sentence tokenizer}
\usage{
tokenize_sentences(input, EOS = ".?!:;")
}
\arguments{
\item{input}{a character vector.}

\item{EOS}{a length one character vector listing all (single character)
end-of-sentence tokens.}
}
\value{
a character vector, each entry of which corresponds to a single
sentence.
}
\description{
Get sentence tokens from text
}
\examples{
tokenize_sentences("Hi there! I'm using `sbo`.")
}
\author{
Valerio Gherardi
}
