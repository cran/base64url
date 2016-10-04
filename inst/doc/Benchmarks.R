## ------------------------------------------------------------------------
library(base64url)
library(base64enc)
library(openssl)
library(microbenchmark)

x = "plain text"
microbenchmark(
  base64url = base64_urlencode(x),
  base64enc = base64encode(charToRaw(x)),
  openssl = base64_encode(x)
)

## ------------------------------------------------------------------------
x = "N0JBLlRaUTp1bi5KOW4xWStNWEJoLHRQaDZ3"
microbenchmark(
  base64url = base64_urldecode(x),
  base64enc = rawToChar(base64decode(x)),
  openssl = rawToChar(base64_decode(x))
)

## ------------------------------------------------------------------------
rand = function(n, min = 1, max = 32) {
  chars = c(letters, LETTERS, as.character(0:9), c(".", ":", ",", "+", "-", "*", "/"))
  replicate(n, paste0(sample(chars, sample(min:max, 1), replace = TRUE), collapse = ""))
}
set.seed(1)
rand(10)

## ------------------------------------------------------------------------
base64enc_encode = function(x) {
  vapply(x, function(x) base64encode(charToRaw(x)), NA_character_, USE.NAMES = FALSE)
}

openssl_encode = function(x) {
  vapply(x, function(x) base64_encode(x), NA_character_, USE.NAMES = FALSE)
}

base64enc_decode = function(x) {
  vapply(x, function(x) rawToChar(base64decode(x)), NA_character_, USE.NAMES = FALSE)
}

openssl_decode = function(x) {
  vapply(x, function(x) rawToChar(base64_decode(x)), NA_character_, USE.NAMES = FALSE)
}

## ------------------------------------------------------------------------
set.seed(1)
x = rand(1000)
microbenchmark(
  base64url = base64_urldecode(base64_urlencode(x)),
  base64enc = base64enc_decode(base64enc_encode(x)),
  openssl = openssl_decode(openssl_encode(x))
)
