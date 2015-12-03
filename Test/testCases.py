# -*- coding: utf-8 -*-

# A set of test cases for testing the system. These tests are not used for
# evaluating the system.


# for each (englishs, italians) in StrongTestCases, each eng in englishs
# should translate to exactly the elements of italians, and vice versa
StrongTestCases = [
# UNGRAMMATICAL
(["the women not sleep"], []),
(["a boy sleep"], []),
(["boy sleeps"], []),
([], ["i studenti dormono"]),
([], ["prendo"]),
([], ["cane lo chiama"]),
([], ["il ragazzo che il cane dorme è alto"]),
# GRAMMATICAL
(["the boy sleeps"], ["il ragazzo dorme"]),
(["the woman has slept", "the woman slept"], ["la donna ha dormito"]),
(["the pictures will be tall"], ["le foto saranno alte"]),
(["the fast students' tall students would not be hungry"],
   ["gli studenti alti degli studenti veloci non avrebbero fame"]),
(["the dog does not see itself"], ["il cane non si vede"]),
(["the boy that will see us called them",
  "the boy that will see us has called them"],
   ["il ragazzo che ci vedrà li ha chiamati"]),
(["the boys' student's dogs' dog's hunger is fast"],
   ["la fame del cane dei cani dello studente dei ragazzi è veloce"]),
(["my dog sees itself"], ["il mio cane si vede"]),
(["the boy that will have a dog would not sleep"],
   ["il ragazzo che avrà un cane non dormirebbe"]),
(["the boy whose dogs that sleep meet us' name is Bob"],
   ["il ragazzo i cui cani che dormono ci incontrano si chiama Bob"]),
(["does a woman have the name"], ["ha il nome una donna"]),
(["would the maps not be happy"], ["non sarebbero felici le mappe"]),
(["are the students not happy"], ["non sono felici gli studenti"]),
(["the maps under me are happy"], ["le mappe sotto me sono felici"]),
(["the boys with the student with the map will not be having slept"],
   ["i ragazzi con lo studente con la mappa non staranno avendo dormito"]),
]

# for each (engs, itas) in WeakTestCases, each eng in engs should translate to
# the elements of itas, plus possibly some others, and vice versa
WeakTestCases = [
(["I do not sleep"], ["non dormo"]),
(["we will take yo"], ["ti prenderemo", "vi prenderemo"]),
(["they would meet themselves"], ["si incontrerebbero"]),
(["the boy's dog that sees a student that is tall sleeps"],
   ["il cane che vede studenti che sono felici del ragazzo dorme"]),
(["the students take pictures"], ["gli studenti fanno foto"]),
(["a promise does not make itself"], ["una promessa non si fa"]),
(["will you be tall"], ["sarai alto"]),
(["does she have a name"], ["ha un nome"]),
(["are you sleeping"], ["state dormando"]),
(["our name is Alice"], ["ci chiamiamo Alice"]),
(["would the boy with promises not be sleeping"],
   ["non starebbe dormendo il ragazzo con promesse"]),
(["the woman with the student whose name is Joe would have been happy"],
   ["la donna con lo studente che si chiama Joe sarebbe stata felice"]),
(["we will not have seen ourselves"], ["ci non saranno visti"]),
]

