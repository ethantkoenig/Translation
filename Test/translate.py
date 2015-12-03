# Interface for system translation

from subprocess import check_output, Popen, PIPE

NO_PARSE_STRING = "NO PARSE"

# Returns : str list - list of translations
# Arguments:
#   fro : str
#   to : str
#   utterance : str
def translate(fro, to, utterance):
  if(type(utterance) != str):
    print utterance
    raise Exception # TODO
  utt = Popen(["echo", utterance], stdout = PIPE)
  translations = check_output(["../Haskell/translate", "../Haskell/Trans.pgf",
                               fro, to], stdin = utt.stdout)
  translations = translations.strip()
  translations = translations.split("\n")
  if (NO_PARSE_STRING in translations):
    return []
  return translations
