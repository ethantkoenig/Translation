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
  sysEI = lambda x : tr.translate("Eng", "Ita", x)
  persistResults(sysEI, nonSemiEI, "Results/System/NonSemiEngToIta.txt")
  persistResults(sysEI, semiEI, "Results/System/SemiEngToIta.txt")
  sysIE = lambda x : tr.translate("Ita", "Eng", x)
  persistResults(sysIE, nonSemiIE, "Results/System/NonSemiItaToEng.txt")
  persistResults(sysIE, semiIE, "Results/System/SemiItaToEng.txt")

  ## Baseline ##  
  baseEI = lambda x : bT.translate("Eng", "Ita", x)
  persistResults(baseEI, nonSemiEI, "Results/Baseline/NonSemiEngToIta.txt")
  persistResults(baseEI, semiEI, "Results/Baseline/SemiEngToIta.txt")
  baseIE = lambda x : bT.translate("Ita", "Eng", x)
  persistResults(baseIE, nonSemiIE, "Results/Baseline/NonSemiItaToEng.txt")
  persistResults(baseIE, semiIE, "Results/Baseline/SemiItaToEng.txt")


if(__name__ == "__main__"):
  main()

