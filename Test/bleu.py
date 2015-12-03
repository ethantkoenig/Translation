from collections import defaultdict
from math import exp, log
from random import choice as randomChoice


# Do not want precision to be 0, so that log(precision) is defined
MinModifiedPrecision = 1e-3

# Returns : dict<str tuple, int> - dict d such that d[gram] = max count of gram
#                                - in a single utterance
#
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
  return max(float(numOccuringGrams) / numCandidateGrams, MinModifiedPrecision)


# Returns : (float, int, int) - (modifiedPrecision, candidateLength, 
#                                minReferenceLength) for a single test case
# Arguments:
#   candidates : str tuple list
#   references : str tuple list
#   n : int - arity of grams
#   best : bool - whether best candidate should be chosen. If False, selects
#                 random element of candidates
def bleuSingle(candidates, references, n, best = True):
  minReferenceLength = min(len(ref) for ref in references)
  if (len(candidates) == 0):
    return (MinModifiedPrecision, 0, minReferenceLength)
  if (best):
    # TODO call getGrams(references, n) many times
    (candidate, modPrecision) = \
      max(((cand, modifiedPrecision(cand, references, n)) 
           for cand in candidates),
          key = lambda (cand, prec) : 
                  prec * exp(min(0, 1 - minReferenceLength / len(cand))))
  else:
    candidate = randomChoice(candidates)
    modPrecision = modifiedPrecision(candidate, references, n)
  if(modPrecision < 1.0):
    print candidates, references
  return (modPrecision, len(candidate), minReferenceLength)


# Arguments:
#   corpus : (str list * str list) list - list of (sources, translations) pairs
#   n : int - arity of grams
#   best : bool - whether best candidate should be chosen. If False, selects
#                 random element of candidates
def bleu(corpus, n, best = True):
  cumulativeCandLength = 0
  cumulativeRefLength = 0
  cumulativeLogModPrecision = 0.0
  for (references, candidates) in corpus:
    candTuples = [tuple(cand.split()) for cand in candidates]
    refTuples = [tuple(ref.split()) for ref in references]
    (modPrecision, candLen, refLen) = bleuSingle(candTuples, refTuples, n, best)    
    cumulativeLogModPrecision += log(modPrecision)
    cumulativeCandLength += candLen
    cumulativeRefLength += refLen
  if(cumulativeCandLength == 0):
    return 0.0
  modPrecision = exp(cumulativeLogModPrecision / len(corpus))
  lengthRatio = float(cumulativeRefLength) / float(cumulativeCandLength)
  brevityPenalty = exp(min(1 - lengthRatio, 0))
  return brevityPenalty * modPrecision  


