
from numpy import mean

from bleu import bleu
from results import loadResults
from sys import argv


SysSemiFile = "Results/System/SemiEngToIta.txt"
SysNonSemiFile = "Results/System/NonSemiEngToIta.txt"
BaseSemiFile = "Results/Baseline/SemiEngToIta.txt"
BaseNonSemiFile = "Results/Baseline/NonSemiEngToIta.txt"

#SysSemiFile = "Results/System/SemiItaToEng.txt"
#SysNonSemiFile = "Results/System/NonSemiItaToEng.txt"
#BaseSemiFile = "Results/Baseline/SemiItaToEng.txt"
#BaseNonSemiFile = "Results/Baseline/NonSemiItaToEng.txt"

# Outputs semi, nonsemi, overall scores for the system and baseline in LaTeX 
# syntax
#
# outputFilename : str
def main(outputFilename):
  sysSemis = loadResults(SysSemiFile)
  sysNonSemis = loadResults(SysNonSemiFile)
  sysAll = sysSemis + sysNonSemis
  baseSemis = loadResults(BaseSemiFile)
  baseNonSemis = loadResults(BaseNonSemiFile)
  baseAll = baseSemis + baseNonSemis
  output = ""
  for (sys, base) in [(sysSemis, baseSemis),
                      (sysNonSemis, baseNonSemis),
                      (sysAll, baseAll)]:
    sys = [(y, z) for (_, y, z) in sys]
    base = [(y, z) for (_, y, z) in base]
    output += "$n$ & System Best & Baseline Best & System Random & Baseline Random\n"
    for n in [1, 2, 3]:
      floatLen = 6
      sysBest = bleu(sys, n, True)
      print sysBest
      baseBest = bleu(base, n, True)
      sysRand = mean([bleu(sys, n, False) for _ in xrange(100)])
      baseRand = mean([bleu(base, n, False) for _ in xrange(100)])
      output += "%d & %s & %s & %s & %s\n" \
                % (n, str(sysBest)[:floatLen], str(baseBest)[:floatLen], \
                      str(sysRand)[:floatLen], str(baseRand)[:floatLen])
    output += "\n" 
  output = output[:-1] # exclude extra newline
  fl = open(outputFilename, "w")
  fl.write(output)
  fl.close()


if (__name__ == "__main__"):
  if(len(argv) <= 1):
    print "Need to pass an output file"
  else:
    main(argv[1])
  

