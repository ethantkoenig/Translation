# Persists the result of running evaluation on the system and baseline

import baselineTranslate as bT
import evaluationCases as eC
from results import persistResults
import translate as tr


def main():
  nonSemiEI = eC.NonSemiEngToIta
  semiEI = eC.SemiEngToIta
  nonSemiIE = eC.NonSemiItaToEng
  semiIE = eC.SemiItaToEng

  ## System ##
  transEI = lambda x : tr.translate("Eng", "Ita", x)
  persistResults(transEI, nonSemiEI, "Results/System/NonSemiEngToItaResults.txt")
  persistResults(transEI, semiEI, "Results/System/SemiEngToItaResults.txt")
  transIE = lambda x : tr.translate("Ita", "Eng", x)
  persistResults(transIE, nonSemiIE, "Results/System/NonSemiItaToEngResults.txt")
  persistResults(transIE, semiIE, "Results/System/SemiItaToEngResults.txt")

  ## Baseline ##  
  baseEI = lambda x : [x] # bT.translate("Eng", "Ita", x)
  persistResults(baseEI, nonSemiEI, "Results/Baseline/NonSemiEngToItaResults.txt")
  persistResults(baseEI, semiEI, "Results/Baseline/SemiEngToItaResults.txt")
  baseIE = lambda x : [x] # bT.translate("Ita", "Eng", x)
  persistResults(baseIE, nonSemiIE, "Results/Baseline/NonSemiItaToEngResults.txt")
  persistResults(baseIE, semiIE, "Results/Baseline/SemiItaToEngResults.txt")

if(__name__ == "__main__"):
  main()
  
  

  
