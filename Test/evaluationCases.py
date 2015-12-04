# -*- coding: utf-8 -*-

from regex import union

# A set of test cases for evaluation
#
# Each list below has elements of the form (source, references), where 
# references are the correct translation of source
#
# Semi denotes semi-idiomatic expressions

NonSemiEngToIta = [
  ("the boy sleeps",
    ["il ragazzo dorme"]),
  ("we will not sleep",
    union("[noi ]non dormiremo", "noi non dormiremo")),
  ("you are sleeping", 
    union("[tu ]stai dormendo", "[voi ]state dormendo")),
  ("the woman has slept",
    ["la donna ha dormito"]),
  ("the dog does not see itself",
    ["il cane non si vede"]),
  ("the boy that will see us called them",
    ["il ragazzo che ci vedrà li ha chiamati"]),
  ("the boys' student's dogs' dog's hunger is fast",
    ["la fame del cane dei cani dello studente dei ragazzi è veloce"]),
  ("my dog sees itself",
    ["il mio cane si vede"]),
  ("the boy that will have a dog would not sleep",
    ["il ragazzo che avrà un cane non dormirebbe"]),
  ("does a woman have the name", 
    ["ha il nome una donna", "una donna ha il nome"]),
  ("would the maps not be happy", 
    union("non sarebbero felici le (carte|mappe)",
          "le (carte|mappe) non sarebbero felici")),
  ("are the students not happy", 
    ["non sono felici gli studenti", "gli studenti non sono felici"]),
  ("the maps under me are happy",
    union("le (carte|mappe) sotto me sono felici")),
  ("the boys with the student with the map will not be having slept",
    union("i ragazzi con lo studente con la (carta|mappa) non staranno avendo dormito")),
  ("we will not have seen ourselves", 
    union("[noi ]non ci saremo (visti|viste)")),
  ("does a boy sleep under the map",
    union("dorme sotto la (carta|mappa) un ragazzo",
          "un ragazzo dorme sotto la (carta|mappa)")),
  ("the students that saw us are not tall",
    ["gli studenti che ci hanno visti non sono alti"]),
  ("an elephant that an elephant sees sees an elephant",
    ["un elefante che un elefante vede vede un elefante"]),
  ("the elephants that I called are not happy",
    ["gli elefanti che ho chiamato non sono felici"]),
  ("the boy that has made a promise is a student",
    ["il ragazzo che ha fatto una promessa è uno studente"]),
  ("our boys with the student with the map will not be having slept",
    union("i nostri ragazzi con lo studente con la (carta|mappa) non staranno avendo dormito")),
  ("your women that are tall sleep",
    union("le (tue|vostre) donne che sono alte dormono")),
  ("your students' dog sees his pictures",
    union("il cane dei (tuoi|vostri) studenti vede le sue foto")),
] 


SemiEngToIta = [
  # take picture / fare foto
  ("he took the pictures",
    union("[lui ]ha (fatto|scattato) le (foto|immagini)")),
  ("would the women that will take pictures sleep",
    union("dormirebbero le donne che (faranno|scattaranno) (foto|fotographie|immagini)",
          "le donne che (faranno|scattaranno) (foto|fotographie|immagini) dormirebbero")),
  ("did we take a picture", 
    union("[noi ]abbiamo (fatto|scattato) una (foto|fotographia|immagine)",
          "abbiamo (fatto|scattato) una (foto|fotographia|immagine)[ noi]")),

  # be hungry / avere fame
  ("his boys with the dog are hungry",
    ["i suoi ragazzi con il cane hanno fame"]),
  ("the woman whose student is hungry took a map", 
    union("la donna il cui studente ha fame ha preso una (carta|mappa)")),
  ("the fast students' tall students would not be hungry",
    ["gli studenti alti degli studenti veloci non avrebbero fame"]),

  # name is / chiamarsi
  ("the boy whose dogs that sleep meet us' name is Bob",
    ["il ragazzo i cui cani che dormono ci incontrano si chiama Bob"]),
  ("her name is Alice",
    union("[lei ]si chiama Alice")),
  ("is my name Joe",
    union("[io ]mi chiamo Joe", "mi chiamo Joe[ io]")),
  ("the woman with the student whose name is Joe would have been happy",
    ["la donna con lo studente che si chiama Joe sarebbe stata felice"]),

  # multiple semi-idiomatic expressions
  ("the boy that will take a picture was hungry",
    union("il ragazzo che farà una (foto|fotographia|immagine) (aveva|ha avuto) fame")),
  ("the woman that would be hungry's name is Emma",
    ["la donna che avrebbe fame si chiama Emma"]),
  ("did the map whose name is Emma take the picture",
    union("ha (fatto|scattato) la (foto|fotographia|immagine) la (carta|mappa) che si chiama Emma",
          "la (carta|mappa) che si chiama Emma ha (fatto|scattato) la foto")),
]



NonSemiItaToEng = [
  ("il ragazzo dorme", 
    ["the boy sleeps"]),
  ("non dormiremo", 
    ["we will not sleep"]),
  ("state dormendo", 
    ["you are sleeping"]),
  ("la donna ha dormito",
    union("the woman [has ]slept")),
  ("il cane non si vede",
    union("the dog does not see (herself|himself|itself)")),
  ("il ragazzo che ci vedrà li ha chiamati",
    union("the boy (that|who) will see us [has ]called them")),
  ("la fame del cane dei cani dello studente dei ragazzi è veloce",
    ["the boys' student's dogs' dog's hunger is fast"]),
  ("il mio cane si vede",
    union("my dog sees (herself|himself|itself|one)")),
  ("il ragazzo che avrà un cane non dormirebbe",
    union("the boy (that|who) will have a dog would not sleep")),
  ("ha il nome una donna", 
    ["does a woman have the name"]),
  ("non sarebbero felici le loro mappe",
    ["would their maps not be happy"]),
  ("non sono felici gli studenti",
    ["are the students not happy"]),
  ("le mappe sotto me sono felici",
    union("the maps (beneath|below|under) me are happy")),
  ("i nostri ragazzi con lo studente con la mappa non staranno avendo dormito",
    ["our boys with the student with the map will not be having slept"]),
  ("non ci saremo visti",
    ["we will not have seen ourselves"]),
  ("dorme sotto la mappa un ragazzo",
    union("does a boy sleep (beneath|below|under) the map")),
  ("gli studenti che ci hanno visti non sono alti",
    union("the students that (have seen|saw) (there|us) are not tall")), 
  ("le vostre donne che sono alte dormono",
    ["your women that are tall sleep"]),
  ("uno studente che è veloce non sta dormendo sotto la mappa",
    union("a student that is fast is not sleeping (beneath|below|under) the map")),
  ("un elefante che un elefante vede vede un elefante",
    ["an elephant that an elephant sees sees an elephant"]),
  ("gli elefanti che ho chiamato non sono felici",
    ["the elephants that I called are not happy",
     "the elephants that I have called are not happy"]),
  ("il ragazzo che ha fatto una promessa è uno studente",
    ["the boy (that|who) made a promise is a student",
     "the boy (that|who) has made a promise is a student"]),
  ("il cane dei vostri studenti vede le sue foto",
    union("your students' dog sees (her|his|its) (photos|photographs|pictures)")),
]


SemiItaToEng = [
  # take picture / fare foto
  ("ha fatto le foto", 
    union("he (has taken|took) the (photos|photographs|pictures)", 
          "(did he take|has he taken) the (photos|photographs|pictures)")),
  ("dormirebbero le donne che faranno foto",
    union("would the women (that|who) will take (photos|photographs|pictures) sleep")),
  ("abbiamo fatto una foto",
    union("we (have taken|took) a (photo|photograph|picture)")), 

  # be hungry / avere fame
  ("i suoi ragazzi con il cane hanno fame",
    union("(his|her) boys with the dog are hungry")),
  ("la donna il cui studente ha fame ha preso una mappa",
    union("the woman whose student is hungry (took|has taken) a map")),
  ("gli studenti alti degli studenti veloci non avrebbero fame",
    ["the fast students' tall students would not be hungry"]),

  # name is / chiamarsi
  ("il ragazzo i cui cani che dormono ci incontrano si chiama Bob",
    ["the boy whose dogs that sleep meet us' name is Bob"]),
  ("si chiama Alice",
    union("(her|his) name is Alice")),
  ("mi chiamo Joe",
    ["my name is Joe"]),
  ("la donna con lo studente che si chiama Joe sarebbe stata felice",
    ["the woman with the student (named|whose name is) Joe would have been happy"]),

  # multiple semi-idiomatic expressions
  ("il ragazzo che farà una foto ha avuto fame",
    union("the boy (that|who) will take a (photo|photograph|picture) (has been|was) hungry")),
  ("la donna che avrebbe fame si chiama Emma",
    ["the woman (that|who) would be hungry's name is Emma"]),
  ("ha fatto la foto la mappa che si chiama Emma",
    union("did the map (named|whose name is) Emma take the (photo|photograph|picture)",
          "has the map (named|whose name is) Emma taken the (photo|photograph|picture)")),
]

