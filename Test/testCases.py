
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
]

