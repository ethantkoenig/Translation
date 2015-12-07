from verificationCases import StrongVerificationCases, WeakVerificationCases
from translate import translate

# Returns : bool - whether l1 and l2 have the same contents, ignoring
#                  multiplicity and order
# Arguments:
#   l1, l2 : list
def list_equals(l1, l2):
  return set(l1) == set(l2)

# Returns : bool - whether l1 is a subset of l2, ignoring multiplicity and order
# Arguments:
#   l1, l2 : list
def list_subset(l1, l2):
  return set(l1) <= set(l2)


def testStrong():
  for (eng, ita) in StrongTestCases:
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


def testWeak():
  for (eng, ita) in StrongTestCases:
    for e in eng:
      translation = translate("Eng", "Ita", e)
      if (not list_subset(translation, ita)):
        print "Source: %s" % e
        print "Expected: %s" % ita
        print "Actual: %s" % translation 
        raise AssertionError  ("Failed test case") 

    for i in ita:
      translation = translate("Ita", "Eng", i)
      if (not list_subset(translation, eng)):
        print "Source: %s" % i
        print "Expected: %s" % eng
        print "Actual: %s" % translation 
        raise AssertionError  ("Failed test case")

def test():
  testStrong()
  testWeak()


if (__name__ == "__main__"):
  test()


