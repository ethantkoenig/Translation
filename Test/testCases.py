
# type: [([str], [str])]
# List of (English, Italian) translation pairs
TestCases = [
# UNGRAMMATICAL
(["the women not sleep"], []),
(["a boy sleep"], []),
(["boy sleeps"], []),
([], ["i studenti dormono"]),
([], ["prendo"]),
([], ["cane lo chiama"]),
([], ["il ragazzo che il cane dorme e' alto"]),
# GRAMMATICAL
(["the boy sleeps"], ["il ragazzo dorme"]),
(["I do not sleep"], ["non dormo"]),
(["the woman has slept", "the woman slept"], ["la donna ha dormito"]),
(["the pictures will be tall"], ["le foto saranno alte"]),
(["the fast students' tall students would not be hungry"],
   ["gli studenti alti degli studenti veloci non avrebbero fame"]),
(["the dog does not see itself"], ["il cane non si vede"]),
(["we will take you"], ["ti prenderemo", "vi prenderemo"]),
(["they would meet themselves"], ["si incontrerebbero"]),
(["the boy that will see us called them",
  "the boy that will see us has called them"],
   ["il ragazzo che ci vedra' li ha chiamato"]),
(["the boys' student's dogs' dog's hunger is fast"],
   ["la fame del cane dei cani dello studente dei ragazzi e' veloce"]),
(["my dog sees itself"], ["il mio cane si vede"]),
(["the boy that will have a dog would not sleep"],
   ["il ragazzo che avra' un cane non dormirebbe"]),
(["the students take pictures"], ["gli studenti fanno foto"]), # TODO should it be "le foto"?
(["the boy whose dogs that sleep meet us' name is Bob"],
   ["il ragazzo i cui cani che dormono ci incontrano si chiama Bob"]),
(["does a woman have the name"], ["ha il nome una donna"]),
]

