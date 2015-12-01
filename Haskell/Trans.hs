module Trans where

import PGF hiding (Tree)
import qualified PGF
----------------------------------------------------
-- automatic translation from GF to Haskell
----------------------------------------------------

class Gf a where
  gf :: a -> PGF.Tree
  fg :: PGF.Tree -> a

newtype GString = GString String  deriving Show

instance Gf GString where
  gf (GString x) = mkStr x
  fg t =
    case unStr t of
      Just x  ->  GString x
      Nothing -> error ("no GString " ++ show t)

newtype GInt = GInt Int  deriving Show

instance Gf GInt where
  gf (GInt x) = mkInt x
  fg t =
    case unInt t of
      Just x  ->  GInt x
      Nothing -> error ("no GInt " ++ show t)

newtype GFloat = GFloat Double  deriving Show

instance Gf GFloat where
  gf (GFloat x) = mkDouble x
  fg t =
    case unDouble t of
      Just x  ->  GFloat x
      Nothing -> error ("no GFloat " ++ show t)

----------------------------------------------------
-- below this line machine-generated
----------------------------------------------------

data GAbsAdj =
   GFast 
 | GHappy 
 | GHungry 
 | GTall 
  deriving Show

data GAbsArgStructure =
   GMakeArgAdj GAbsNP GAbsAdj 
 | GMakeArgNP GAbsNP GAbsNP 
 | GMakeArgNPNP GAbsNP GAbsNP GAbsNP 
 | GMakeArgVoid GAbsNP 
  deriving Show

data GAbsArgType =
   GArgAdj 
 | GArgNP 
 | GArgNPNP 
 | GArgVoid 
  deriving Show

data GAbsCP = GMakeCP GAbsVP 
  deriving Show

data GAbsD =
   GA 
 | GThe 
 | GVoidD 
  deriving Show

data GAbsN =
   GPlural GAbsN_ 
 | GSingular GAbsN_ 
  deriving Show

data GAbsN' =
   GAdjoinN'Adj GAbsN' GAbsAdj 
 | GAdjoinN'CP GAbsN' GAbsCP 
 | GMakeN' GAbsN 
  deriving Show

data GAbsNP =
   GMakeNP GAbsD GAbsN' 
 | GNPofProNP GAbsProNP 
 | GNPofProperN GAbsProperN 
 | GNPofReflexive GAbsReflexive 
 | GNullNP 
 | GPossessive GAbsNP GAbsN' 
  deriving Show

data GAbsN_ =
   GBoy 
 | GDog 
 | GHunger 
 | GMap 
 | GName 
 | GPicture 
 | GPromise 
 | GStudent 
 | GWoman 
  deriving Show

data GAbsProNP =
   GHe 
 | GI 
 | GShe 
 | GThey 
 | GWe 
 | GYall 
 | GYou 
  deriving Show

data GAbsProperN =
   GAlice 
 | GBob 
 | GEve 
 | GJoe 
  deriving Show

data GAbsReflexive = GSelf 
  deriving Show

data GAbsS =
   GDeclarative GAbsS_ 
 | GInterrogative GAbsS_ 
  deriving Show

data GAbsS_ = GMakeS_ GAbsVP 
  deriving Show

data GAbsV =
   GBeAdj 
 | GBeNP 
 | GCallSomeone 
 | GCallSomeoneSomething 
 | GDo 
 | GHave 
 | GMake 
 | GMeet 
 | GSee 
 | GSleep 
 | GTake 
  deriving Show

data GAbsV' =
   GAuxBe GAbsVP__ 
 | GAuxHave GAbsVP__ 
 | GMakeV' GAbsArgType GAbsV GAbsArgStructure 
  deriving Show

data GAbsVP =
   GNegative GAbsVP_ 
 | GPositive GAbsVP_ 
  deriving Show

data GAbsVP_ =
   GCond GAbsVP__ 
 | GFuture GAbsVP__ 
 | GPast GAbsVP__ 
 | GPresent GAbsVP__ 
  deriving Show

data GAbsVP__ = GMakeVP__ GAbsV' 
  deriving Show


instance Gf GAbsAdj where
  gf GFast = mkApp (mkCId "Fast") []
  gf GHappy = mkApp (mkCId "Happy") []
  gf GHungry = mkApp (mkCId "Hungry") []
  gf GTall = mkApp (mkCId "Tall") []

  fg t =
    case unApp t of
      Just (i,[]) | i == mkCId "Fast" -> GFast 
      Just (i,[]) | i == mkCId "Happy" -> GHappy 
      Just (i,[]) | i == mkCId "Hungry" -> GHungry 
      Just (i,[]) | i == mkCId "Tall" -> GTall 


      _ -> error ("no AbsAdj " ++ show t)

instance Gf GAbsArgStructure where
  gf (GMakeArgAdj x1 x2) = mkApp (mkCId "MakeArgAdj") [gf x1, gf x2]
  gf (GMakeArgNP x1 x2) = mkApp (mkCId "MakeArgNP") [gf x1, gf x2]
  gf (GMakeArgNPNP x1 x2 x3) = mkApp (mkCId "MakeArgNPNP") [gf x1, gf x2, gf x3]
  gf (GMakeArgVoid x1) = mkApp (mkCId "MakeArgVoid") [gf x1]

  fg t =
    case unApp t of
      Just (i,[x1,x2]) | i == mkCId "MakeArgAdj" -> GMakeArgAdj (fg x1) (fg x2)
      Just (i,[x1,x2]) | i == mkCId "MakeArgNP" -> GMakeArgNP (fg x1) (fg x2)
      Just (i,[x1,x2,x3]) | i == mkCId "MakeArgNPNP" -> GMakeArgNPNP (fg x1) (fg x2) (fg x3)
      Just (i,[x1]) | i == mkCId "MakeArgVoid" -> GMakeArgVoid (fg x1)


      _ -> error ("no AbsArgStructure " ++ show t)

instance Gf GAbsArgType where
  gf GArgAdj = mkApp (mkCId "ArgAdj") []
  gf GArgNP = mkApp (mkCId "ArgNP") []
  gf GArgNPNP = mkApp (mkCId "ArgNPNP") []
  gf GArgVoid = mkApp (mkCId "ArgVoid") []

  fg t =
    case unApp t of
      Just (i,[]) | i == mkCId "ArgAdj" -> GArgAdj 
      Just (i,[]) | i == mkCId "ArgNP" -> GArgNP 
      Just (i,[]) | i == mkCId "ArgNPNP" -> GArgNPNP 
      Just (i,[]) | i == mkCId "ArgVoid" -> GArgVoid 


      _ -> error ("no AbsArgType " ++ show t)

instance Gf GAbsCP where
  gf (GMakeCP x1) = mkApp (mkCId "MakeCP") [gf x1]

  fg t =
    case unApp t of
      Just (i,[x1]) | i == mkCId "MakeCP" -> GMakeCP (fg x1)


      _ -> error ("no AbsCP " ++ show t)

instance Gf GAbsD where
  gf GA = mkApp (mkCId "A") []
  gf GThe = mkApp (mkCId "The") []
  gf GVoidD = mkApp (mkCId "VoidD") []

  fg t =
    case unApp t of
      Just (i,[]) | i == mkCId "A" -> GA 
      Just (i,[]) | i == mkCId "The" -> GThe 
      Just (i,[]) | i == mkCId "VoidD" -> GVoidD 


      _ -> error ("no AbsD " ++ show t)

instance Gf GAbsN where
  gf (GPlural x1) = mkApp (mkCId "Plural") [gf x1]
  gf (GSingular x1) = mkApp (mkCId "Singular") [gf x1]

  fg t =
    case unApp t of
      Just (i,[x1]) | i == mkCId "Plural" -> GPlural (fg x1)
      Just (i,[x1]) | i == mkCId "Singular" -> GSingular (fg x1)


      _ -> error ("no AbsN " ++ show t)

instance Gf GAbsN' where
  gf (GAdjoinN'Adj x1 x2) = mkApp (mkCId "AdjoinN'Adj") [gf x1, gf x2]
  gf (GAdjoinN'CP x1 x2) = mkApp (mkCId "AdjoinN'CP") [gf x1, gf x2]
  gf (GMakeN' x1) = mkApp (mkCId "MakeN'") [gf x1]

  fg t =
    case unApp t of
      Just (i,[x1,x2]) | i == mkCId "AdjoinN'Adj" -> GAdjoinN'Adj (fg x1) (fg x2)
      Just (i,[x1,x2]) | i == mkCId "AdjoinN'CP" -> GAdjoinN'CP (fg x1) (fg x2)
      Just (i,[x1]) | i == mkCId "MakeN'" -> GMakeN' (fg x1)


      _ -> error ("no AbsN' " ++ show t)

instance Gf GAbsNP where
  gf (GMakeNP x1 x2) = mkApp (mkCId "MakeNP") [gf x1, gf x2]
  gf (GNPofProNP x1) = mkApp (mkCId "NPofProNP") [gf x1]
  gf (GNPofProperN x1) = mkApp (mkCId "NPofProperN") [gf x1]
  gf (GNPofReflexive x1) = mkApp (mkCId "NPofReflexive") [gf x1]
  gf GNullNP = mkApp (mkCId "NullNP") []
  gf (GPossessive x1 x2) = mkApp (mkCId "Possessive") [gf x1, gf x2]

  fg t =
    case unApp t of
      Just (i,[x1,x2]) | i == mkCId "MakeNP" -> GMakeNP (fg x1) (fg x2)
      Just (i,[x1]) | i == mkCId "NPofProNP" -> GNPofProNP (fg x1)
      Just (i,[x1]) | i == mkCId "NPofProperN" -> GNPofProperN (fg x1)
      Just (i,[x1]) | i == mkCId "NPofReflexive" -> GNPofReflexive (fg x1)
      Just (i,[]) | i == mkCId "NullNP" -> GNullNP 
      Just (i,[x1,x2]) | i == mkCId "Possessive" -> GPossessive (fg x1) (fg x2)


      _ -> error ("no AbsNP " ++ show t)

instance Gf GAbsN_ where
  gf GBoy = mkApp (mkCId "Boy") []
  gf GDog = mkApp (mkCId "Dog") []
  gf GHunger = mkApp (mkCId "Hunger") []
  gf GMap = mkApp (mkCId "Map") []
  gf GName = mkApp (mkCId "Name") []
  gf GPicture = mkApp (mkCId "Picture") []
  gf GPromise = mkApp (mkCId "Promise") []
  gf GStudent = mkApp (mkCId "Student") []
  gf GWoman = mkApp (mkCId "Woman") []

  fg t =
    case unApp t of
      Just (i,[]) | i == mkCId "Boy" -> GBoy 
      Just (i,[]) | i == mkCId "Dog" -> GDog 
      Just (i,[]) | i == mkCId "Hunger" -> GHunger 
      Just (i,[]) | i == mkCId "Map" -> GMap 
      Just (i,[]) | i == mkCId "Name" -> GName 
      Just (i,[]) | i == mkCId "Picture" -> GPicture 
      Just (i,[]) | i == mkCId "Promise" -> GPromise 
      Just (i,[]) | i == mkCId "Student" -> GStudent 
      Just (i,[]) | i == mkCId "Woman" -> GWoman 


      _ -> error ("no AbsN_ " ++ show t)

instance Gf GAbsProNP where
  gf GHe = mkApp (mkCId "He") []
  gf GI = mkApp (mkCId "I") []
  gf GShe = mkApp (mkCId "She") []
  gf GThey = mkApp (mkCId "They") []
  gf GWe = mkApp (mkCId "We") []
  gf GYall = mkApp (mkCId "Yall") []
  gf GYou = mkApp (mkCId "You") []

  fg t =
    case unApp t of
      Just (i,[]) | i == mkCId "He" -> GHe 
      Just (i,[]) | i == mkCId "I" -> GI 
      Just (i,[]) | i == mkCId "She" -> GShe 
      Just (i,[]) | i == mkCId "They" -> GThey 
      Just (i,[]) | i == mkCId "We" -> GWe 
      Just (i,[]) | i == mkCId "Yall" -> GYall 
      Just (i,[]) | i == mkCId "You" -> GYou 


      _ -> error ("no AbsProNP " ++ show t)

instance Gf GAbsProperN where
  gf GAlice = mkApp (mkCId "Alice") []
  gf GBob = mkApp (mkCId "Bob") []
  gf GEve = mkApp (mkCId "Eve") []
  gf GJoe = mkApp (mkCId "Joe") []

  fg t =
    case unApp t of
      Just (i,[]) | i == mkCId "Alice" -> GAlice 
      Just (i,[]) | i == mkCId "Bob" -> GBob 
      Just (i,[]) | i == mkCId "Eve" -> GEve 
      Just (i,[]) | i == mkCId "Joe" -> GJoe 


      _ -> error ("no AbsProperN " ++ show t)

instance Gf GAbsReflexive where
  gf GSelf = mkApp (mkCId "Self") []

  fg t =
    case unApp t of
      Just (i,[]) | i == mkCId "Self" -> GSelf 


      _ -> error ("no AbsReflexive " ++ show t)

instance Gf GAbsS where
  gf (GDeclarative x1) = mkApp (mkCId "Declarative") [gf x1]
  gf (GInterrogative x1) = mkApp (mkCId "Interrogative") [gf x1]

  fg t =
    case unApp t of
      Just (i,[x1]) | i == mkCId "Declarative" -> GDeclarative (fg x1)
      Just (i,[x1]) | i == mkCId "Interrogative" -> GInterrogative (fg x1)


      _ -> error ("no AbsS " ++ show t)

instance Gf GAbsS_ where
  gf (GMakeS_ x1) = mkApp (mkCId "MakeS_") [gf x1]

  fg t =
    case unApp t of
      Just (i,[x1]) | i == mkCId "MakeS_" -> GMakeS_ (fg x1)


      _ -> error ("no AbsS_ " ++ show t)

instance Gf GAbsV where
  gf GBeAdj = mkApp (mkCId "BeAdj") []
  gf GBeNP = mkApp (mkCId "BeNP") []
  gf GCallSomeone = mkApp (mkCId "CallSomeone") []
  gf GCallSomeoneSomething = mkApp (mkCId "CallSomeoneSomething") []
  gf GDo = mkApp (mkCId "Do") []
  gf GHave = mkApp (mkCId "Have") []
  gf GMake = mkApp (mkCId "Make") []
  gf GMeet = mkApp (mkCId "Meet") []
  gf GSee = mkApp (mkCId "See") []
  gf GSleep = mkApp (mkCId "Sleep") []
  gf GTake = mkApp (mkCId "Take") []

  fg t =
    case unApp t of
      Just (i,[]) | i == mkCId "BeAdj" -> GBeAdj 
      Just (i,[]) | i == mkCId "BeNP" -> GBeNP 
      Just (i,[]) | i == mkCId "CallSomeone" -> GCallSomeone 
      Just (i,[]) | i == mkCId "CallSomeoneSomething" -> GCallSomeoneSomething 
      Just (i,[]) | i == mkCId "Do" -> GDo 
      Just (i,[]) | i == mkCId "Have" -> GHave 
      Just (i,[]) | i == mkCId "Make" -> GMake 
      Just (i,[]) | i == mkCId "Meet" -> GMeet 
      Just (i,[]) | i == mkCId "See" -> GSee 
      Just (i,[]) | i == mkCId "Sleep" -> GSleep 
      Just (i,[]) | i == mkCId "Take" -> GTake 


      _ -> error ("no AbsV " ++ show t)

instance Gf GAbsV' where
  gf (GAuxBe x1) = mkApp (mkCId "AuxBe") [gf x1]
  gf (GAuxHave x1) = mkApp (mkCId "AuxHave") [gf x1]
  gf (GMakeV' x1 x2 x3) = mkApp (mkCId "MakeV'") [gf x1, gf x2, gf x3]

  fg t =
    case unApp t of
      Just (i,[x1]) | i == mkCId "AuxBe" -> GAuxBe (fg x1)
      Just (i,[x1]) | i == mkCId "AuxHave" -> GAuxHave (fg x1)
      Just (i,[x1,x2,x3]) | i == mkCId "MakeV'" -> GMakeV' (fg x1) (fg x2) (fg x3)


      _ -> error ("no AbsV' " ++ show t)

instance Gf GAbsVP where
  gf (GNegative x1) = mkApp (mkCId "Negative") [gf x1]
  gf (GPositive x1) = mkApp (mkCId "Positive") [gf x1]

  fg t =
    case unApp t of
      Just (i,[x1]) | i == mkCId "Negative" -> GNegative (fg x1)
      Just (i,[x1]) | i == mkCId "Positive" -> GPositive (fg x1)


      _ -> error ("no AbsVP " ++ show t)

instance Gf GAbsVP_ where
  gf (GCond x1) = mkApp (mkCId "Cond") [gf x1]
  gf (GFuture x1) = mkApp (mkCId "Future") [gf x1]
  gf (GPast x1) = mkApp (mkCId "Past") [gf x1]
  gf (GPresent x1) = mkApp (mkCId "Present") [gf x1]

  fg t =
    case unApp t of
      Just (i,[x1]) | i == mkCId "Cond" -> GCond (fg x1)
      Just (i,[x1]) | i == mkCId "Future" -> GFuture (fg x1)
      Just (i,[x1]) | i == mkCId "Past" -> GPast (fg x1)
      Just (i,[x1]) | i == mkCId "Present" -> GPresent (fg x1)


      _ -> error ("no AbsVP_ " ++ show t)

instance Gf GAbsVP__ where
  gf (GMakeVP__ x1) = mkApp (mkCId "MakeVP__") [gf x1]

  fg t =
    case unApp t of
      Just (i,[x1]) | i == mkCId "MakeVP__" -> GMakeVP__ (fg x1)


      _ -> error ("no AbsVP__ " ++ show t)


