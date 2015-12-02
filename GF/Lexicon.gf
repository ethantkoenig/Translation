interface Lexicon = open Syntax in {
  oper
    fast, happy, hungry, tall : Adj;

    boy, dog, hunger, name, map, picture, promise, student, woman : N_;
    
    alice, bob, eve, joe : ProperN;

    under, withh : P; {- with is a keyword in GF, so use withh instead -}
  
    beAdj, beNP, callSomeone, callSomeoneSomething, do, have,
    meet, take, see, sleep : V;

}
