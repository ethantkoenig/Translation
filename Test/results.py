
# Functionality for writing/reading translation results to/from files.
#
# I choose to persist the results of translation (both those of my system and 
# those of the Google Translate baseline) for two reasons:
# 1. The Google Translate API costs money, so I do not want to make more calls to
#    it than I have to
# 2. My system is not instantaneous



# Persists the result of running translate on sources in the following format:
# <source sentence> | <ref1> , ... , <refN> | <cand1> , ... , <candN> 
# Arguments:
#   translate : str -> str list - translate function
#   instances : (str * str list) list - list of (source, references) pairs
#   outputFilename : str
def persistResults(translate, instances, outputFilename):
  output = ""
  for (source, references) in instances:
    candidates = translate(source)
    output += "%s | %s | %s\n" % (source, " , ".join(references),
                                   " , ".join(candidates))
  fl = open(outputFilename, "w")
  fl.write(output)
  fl.close()


# Returns : (str, str list, str list) - (source, references, candidates) for a
#                                       persisted results line
# Arguments:
#   line : str
def parseLine(line):
  try:
    line = line.replace("\n", "")
    [src, refsStr, candsStr] = line.split(" | ")
    refs = [ref for ref in refsStr.split(" , ") if ref != ""]
    cands = [cand for cand in candsStr.split(" , ") if cand != ""]
    return (src, refs, cands)
  except:
    raise ValueError ("mal-formatted line:%s" % line)    


# Return : (str, str list, str list) list - (source, references, candidates)
#                                           stored in a persisted results file
#
# Arguments:
#   filename : str
def loadResults(filename):
  fl = open(filename, "r")
  lines = fl.readlines()
  fl.close()
  return [parseLine(line) for line in lines]
