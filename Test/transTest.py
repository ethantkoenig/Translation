from subprocess import check_output, Popen, PIPE

from testCases import TestCases

NO_PARSE_STRING = "NO PARSE"

# Returns : bool - whether l1 and l2 have the same contents, ignoring
#                  multiplicity and order
# Arguments:
#   l1, l2 : list
def list_equals(l1, l2):
  return set(l1) == set(l2)

# Returns : str list - list of translations
# Arguments:
#   fro : str
#   to : str
#   utterance : str
def translate(fro, to, utterance):
  utt = Popen(["echo", utterance], stdout = PIPE)
  translations = check_output(["../Haskell/translate", "../Haskell/Trans.pgf",
                               fro, to], stdin = utt.stdout)
  translations = translations.strip()
  translations = translations.split("\n")
  if (NO_PARSE_STRING in translations):
    return []
  return translations


def test():
  for (eng, ita) in TestCases:
    for e in eng:
      translation = translate("Eng", "Ita", e)
      if (not list_equals(translation, ita)):
        print "Source: %s" % e
        print "Expected: %s" % ita
        print "Actual: %s" % translation 
        raise AssertionError  ("Failed test case") 

    for i in ita:
      translation = translate("Ita", "Eng", i)
      if (not list_equals(translation, eng)):
        print "Source: %s" % i
        print "Expected: %s" % eng
        print "Actual: %s" % translation 
        raise AssertionError  ("Failed test case")


if (__name__ == "__main__"):
  test()


