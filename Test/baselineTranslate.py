# Interface for baseline (Google Translate) translation

from urllib2 import urlopen
from json import loads

# I hide my API key in a local file. The rates for the Google Translate API are
# volume dependent, and I store my code in a public repository, so I need to
# protect against someone spamming my key. Unfornuately, this means that you 
# cannot run this file :(
API_KEY_FILENAME = "../../TranslateAPI/apiKey.txt"

# A formatted URL for the Google Translate API
URL = "https://www.googleapis.com/language/translate/v2?key=%s&q=%s&source=%s&target=%s"


# Returns : str - API key
def get_key():
  fl = open(API_KEY_FILENAME)
  key = fl.read().strip()
  fl.close()
  return key

# Removes &..; sequences from translation. These sometimes appear when Google
# Translate doesn't know how to handle quotes.
#
# translation : str
def sanitize(translation):
  ampersandIndex = translation.find("&")
  if(ampersandIndex == -1):
    return translation
  semicolonIndex = translation.find(";")
  if(semicolonIndex <= ampersandIndex):
    raise ValueError ("malformatted translation: %s" % translation)
  return translation[:ampersandIndex] \
         + sanitize(translation[semicolonIndex + 1 :])


# Returns : str list - list of translations
# Arguments:
#   fro : str
#   to : str
#   utterance : str
def translate(fro, to, utterance):
  # format inputs
  utterance = utterance.replace(" ", "%20")
  fro = fro[:2].lower()
  to = to[:2].lower()

  key = get_key()
  url = URL % (key, utterance, fro, to)
  request = urlopen(url)
  jsonTranslation = request.read()
  request.close()
  translationStruct = loads(jsonTranslation)
  return [sanitize(translation["translatedText"].encode("utf-8"))
          for translation in translationStruct["data"]["translations"]]
