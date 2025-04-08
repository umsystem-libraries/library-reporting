import re
from unidecode import unidecode


def fingerprint(string):
    # change all characters to their lowercase representation
    string = string.lower()
    # remove all punctuation and control characters
    string = re.sub("[^A-Za-z0-9 ]+", "", string)
    # normalize extended western characters to their ASCII representation
    string = unidecode(string)
    # split the string into whitespace-separated tokens
    words = string.split()
    # sort the tokens and remove duplicates
    words = sorted(list(set(words)))
    # join the tokens back together
    return " ".join(words)


def ngram_fingerprint(string, n=1):
    # remove leading and trailing whitespace
    string = string.strip()
    # change all characters to their lowercase representation
    string = string.lower()
    # remove all punctuation, whitespace, and control characters
    string = re.sub("[^A-Za-z0-9]+", "", string)
    # obtain all the string n-grams
    ngrams = [string[i : i + n] for i in range(len(string) - n + 1)]
    # sort the n-grams and remove duplicates
    ngrams = sorted(list(set(ngrams)))
    # join the sorted n-grams back together
    string = "".join(ngrams)
    # normalize extended western characters to their ASCII representation
    return unidecode(string)


def mod_ngram_fingerprint(string, n=1):
    # change all characters to their lowercase representation
    string = string.lower()
    # remove all punctuation and control characters
    string = re.sub("[^A-Za-z0-9 ]+", "", string)
    # normalize extended western characters to their ASCII representation
    string = unidecode(string)
    # split the string into whitespace-separated tokens
    words = string.split()
    # sort the tokens and remove duplicates
    words = sorted(list(set(words)))
    # join the tokens back together
    string = "".join(words)
    # obtain all the string n-grams
    ngrams = [string[i : i + n] for i in range(len(string) - n + 1)]
    # sort the n-grams and remove duplicates
    ngrams = sorted(list(set(ngrams)))
    # join the sorted n-grams back together
    return "".join(ngrams)


if __name__ == "__main__":
    print(fingerprint("Tom Cruise"))
    print(ngram_fingerprint("Tom Cruise", 1))
    print(ngram_fingerprint("Tom Cruise", 2))
    print(mod_ngram_fingerprint("Tom Cruise", 1))
    print(mod_ngram_fingerprint("Tom Cruise", 2))
    print("---")

    print(fingerprint("Cruise, Tom"))
    print(ngram_fingerprint("Cruise, Tom", 1))
    print(ngram_fingerprint("Cruise, Tom", 2))
    print(mod_ngram_fingerprint("Cruise, Tom", 1))
    print(mod_ngram_fingerprint("Cruise, Tom", 2))
    print("---")

    print(fingerprint("Paris"))
    print(ngram_fingerprint("Paris", 1))
    print(ngram_fingerprint("Paris", 2))
    print(mod_ngram_fingerprint("Paris", 1))
    print(mod_ngram_fingerprint("Paris", 2))