from collections import defaultdict
from math import exp, log

from testCases import TestCases
from translate import translate


# Returns : dict<str tuple, int> - dict d such that d[gram] = max of utterance
#                                - in utterances (count of gram in utterance)
# Arguments:
#   utterance : str tuple list
#   n : int - arity of grams
def getGrams(utterances, n):
  result = defaultdict(int)
  for utterance in utterances:
    uttDict = defaultdict(int)
    for i in xrange(len(utterance) - n + 1):
      uttDict[utterance[i:i+n]] += 1
    for gram in uttDict:
      result[gram] = max(result[gram], uttDict[gram])
  return result


# Returns : float - modified precision of candidate with respect to references
#
# Arguments:
#   candidate : str tuple - candidate translation
#   references : str tuple list - list of reference translations
#   n : int - arity for grams
def modifiedPrecision(candidate, references, n):
  candidateGrams = getGrams([candidate], n)
  referenceGrams = getGrams(references, n)
  numCandidateGrams = len(candidate) - n + 1
  numOccuringGrams = sum(min(referenceGrams[gram], candidateGrams[gram])
                         for gram in candidateGrams)
  if (numCandidateGrams <= 0):
    return 1.0
  return float(numOccuringGrams) / numCandidateGrams


# Arguments:
#   corpus : (str * (str list)) list
def bleu(corpus, n):
  cumulativeCandLength = 0
  cumulativeRefLength = 0
  cumulativeLogModPrecision = 0.0
  for (candidate, references) in corpus:
    candTuple = tuple(candidate.split())
    refTuples = [tuple(ref.split()) for ref in references]
    cumulativeLogModPrecision += log(max(modifiedPrecision(candTuple, refTuples, n), 1e-3))
    cumulativeCandLength += len(candTuple)
    cumulativeRefLength += min(len(ref) for ref in refTuples)
  modPrecision = exp(cumulativeLogModPrecision / len(corpus))
  lengthRatio = float(cumulativeRefLength) / float(cumulativeCandLength)
  brevityPenalty = exp(min(1 - lengthRatio, 0))
  return brevityPenalty * modPrecision  


# Returns : float - BLEU metric of 
# Arguments:
#   fromEnglish : bool
#   n : int - arity of grams
def main(fromEnglish, n):
  corpus = TestCases
  if (not fromEnglish):
    corpus = [(itas, engs) for (engs, itas) in corpus]
  fromLang = "Eng" if fromEnglish else "Ita"
  toLang = "Ita" if fromEnglish else "Eng"
  flattenedCorpus = [(src, tgts) for (srcs, tgts) in corpus for src in srcs]
  # this "weeds out" any ungrammatical instances in the corpus
  translatedCorpus = [(translation, itas) for (eng, itas) in flattenedCorpus
                      for translation in translate(fromLang, toLang, eng)]
  return bleu(translatedCorpus, n)

