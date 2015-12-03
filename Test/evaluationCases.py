# -*- coding: utf-8 -*-

# A set of test cases for evaluation
#
# Each list below has elements of the form (source, references), where 
# references are the correct translation of source
#
# Semi denotes semi-idiomatic expressions

NonSemiEngToIta = [
("the boy sleeps", ["il ragazzo dorme"]),
("we will not sleep", ["non dormiremo", "noi non dormiremo"]),
("you are sleeping", 
  ["stai dormendo", "tu stai dormendo", 
   "state dormendo", "voi state dormendo"]),
("the woman has slept", ["la donna ha dormito"]),
("the dog does not see itself", ["il cane non si vede"]),
("the boy that will see us called them",
  ["il ragazzo che ci vedrà li ha chiamati"]),
("the boys' student's dogs' dog's hunger is fast",
  ["la fame del cane dei cani dello studente dei ragazzi è veloce"]),
("my dog sees itself", ["il mio cane si vede"]),
("the boy that will have a dog would not sleep",
  ["il ragazzo che avrà un cane non dormirebbe"]),
("does a woman have the name", 
  ["ha il nome una donna", "una donna ha il nome"]),
("would the maps not be happy", 
  ["non sarebbero felici le mappe", "le mappe non sarebbero felici"]),
("are the students not happy", 
  ["non sono felici gli studenti", "gli studenti non sono felici"]),
("the maps under me are happy", ["le mappe sotto me sono felici"]),
("the boys with the student with the map will not be having slept",
  ["i ragazzi con lo studente con la mappa non staranno avendo dormito"]),
("we will not have seen ourselves", 
  ["ci non saremo visti", "noi ci non saremo visti", 
   "ci non saremo viste", "noi ci non saremo viste"]),
("does a boy sleep under the map",
  ["dorme sotto la mappa un ragazzo", "un ragazzo dorme sotto la mappa"]),
("the woman with the student whose name is Joe would have been happy",
   ["la donna con lo studente che si chiama Joe sarebbe stata felice"]),
("the students that saw us are not tall",
  ["gli studenti che ci hanno visti non sono alti"]),
] 

SemiEngToIta = [
# take picture / fare foto
("he took the pictures", ["ha fatto le foto", "lui ha fatto le foto"]),
("would the women that will take pictures sleep",
  ["dormirebbero le donne che faranno foto",
   "le donne che faranno foto dormirebbero"]),

# be hungry / avere fame
("the boys with the dog are hungry", ["i ragazzi con il cane hanno fame"]),
("the woman whose student is hungry took a map", 
   ["la donna il cui studente ha fame ha preso una mappa"]),
("the fast students' tall students would not be hungry",
   ["gli studenti alti degli studenti veloci non avrebbero fame"]),

# name is / chiamarsi
("the boy whose dogs that sleep meet us' name is Bob",
   ["il ragazzo i cui cani che dormono ci incontrano si chiama Bob"]),
("her name is Alice", ["si chiama Alice", "lei si chiama Alice"]),
("my name is Joe", ["mi chiamo Joe", "io mi chiamo Joe"]),

# multiple semi-idiomatic expressions
("the boy that will take a picture was hungry",
  ["il ragazzo che farà una foto ha avuto fame",
   "il ragazzo che farà una foto avevo fame"]),
("the woman that would be hungry's name is Eve",
  ["la donna che avrebbe fame si chiama Eve"]),
]



NonSemiItaToEng = [
("il ragazzo dorme", ["the boy sleeps"]),
("non dormiremo", ["we will not sleep"]),
("state dormendo", ["you are sleeping"]),
("la donna ha dormito", ["the woman slept", "the woman has slept"]),
("il cane non si vede", ["the dog does not see itself"]),
("il ragazzo che ci vedrà li ha chiamati",
  ["the boy that will see us called them"]),
("la fame del cane dei cani dello studente dei ragazzi è veloce",
  ["the boys' student's dogs' dog's hunger is fast"]),
("il mio cane si vede", ["my dog sees itself", "my dog sees one"]),
("il ragazzo che avrà un cane non dormirebbe",
  ["the boy that will have a dog would not sleep"]),
("ha il nome una donna", "does a woman have the name"),
("non sarebbero felici le mappe", ["would the maps not be happy"]),
("non sono felici gli studenti", ["are the students not happy"]),
("le mappe sotto me sono felici", ["the maps under me are happy"]),
("i ragazzi con lo studente con la mappa non staranno avendo dormito",
  ["the boys with the student with the map will not be having slept"]),
("ci non saranno visti", ["we will not have seen ourselves"]),
("dorme sotto la mappa un ragazzo", ["does a boy sleep under the map"]),
("la donna con lo studente che si chiama Joe sarebbe stata felice",
  ["the woman with the student whose name is Joe would have been happy"]),
("gli studenti che ci hanno visti non sono alti",
  ["the students that saw us are not tall", 
   "the students that have seen us are not tall",
   "the students that saw there are not tall",
   "the students that have seen there are not tall"]),
("le donne che sono alte dormono", ["the women that are tall sleep"]),
]


SemiItaToEng = [
("ha fatto le foto", ["he took the pictures", "he has taken the pictures"]),
("dormirebbero le donne che faranno foto",
  ["would the women that will take pictures sleep"]),
("i ragazzi con il cane hanno fame", ["the boys with the dog are hungry"]),
("la donna il cui studente ha fame ha preso una mappa",
  ["the woman whose student is hungry took a map"]),
("gli studenti alti degli studenti veloci non avrebbero fame",
  ["the fast students' tall students would not be hungry"]),
("il ragazzo i cui cani che dormono ci incontrano si chiama Bob",
  ["the boy whose dogs that sleep meet us' name is Bob"]),
("si chiama Alice", ["her name is Alice", "his name is Alice"]),
("mi chiamo Joe", ["my name is Joe"]),
("il ragazzo che farà una foto ha avuto fame",
  ["the boy that will take a picture was hungry",
   "the boy that will take a picture has been hungry"]),
("la donna che avrebbe fame si chiama Eve",
  ["the woman that would be hungry's name is Eve"]),
]

