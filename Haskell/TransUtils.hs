module TransUtils where

import Prelude
import Trans

{- This module contains functionality for traversing, transforming, and 
 - extracting abstract syntax trees -}

{- transforms, convenience functions for abstract syntax tree traversal -}

transformS :: (GAbsS_ -> GAbsS_) -> GAbsS -> GAbsS
transformS f (GDeclarative s_) = GDeclarative (f s_)
transformS f (GInterrogative s_) = GInterrogative (f s_)

transformS_ :: (GAbsVP -> GAbsVP) -> GAbsS_ -> GAbsS_
transformS_ f (GMakeS_ vp) = GMakeS_ (f vp)

transformCP :: (GAbsVP -> GAbsVP) -> GAbsCP -> GAbsCP
transformCP f (GMakeCP vp) = GMakeCP (f vp)


transformVP :: (GAbsVP_ -> GAbsVP_) -> GAbsVP -> GAbsVP
transformVP f (GPositive vp_) = GPositive (f vp_)
transformVP f (GNegative vp_) = GNegative (f vp_)

transformVP_ :: (GAbsVP__ -> GAbsVP__) -> GAbsVP_ -> GAbsVP_
transformVP_ f (GPresent vp__) = GPresent (f vp__)
transformVP_ f (GPast vp__) = GPast (f vp__)
transformVP_ f (GCond vp__) = GCond (f vp__)
transformVP_ f (GFuture vp__) = GFuture (f vp__)


transformVP__ :: (GAbsV' -> GAbsV') -> GAbsVP__ -> GAbsVP__
transformVP__ f (GAuxBe vp__) = GAuxBe (transformVP__ f vp__)
transformVP__ f (GAuxHave vp__) = GAuxHave (transformVP__ f vp__)
transformVP__ f (GMakeVP__ v') = GMakeVP__ (f v')

transformArgs :: (GAbsNP -> GAbsNP)
                   -> GAbsArgStructure -> GAbsArgStructure
transformArgs f (GMakeArgVoid np) = GMakeArgVoid (f np)
transformArgs f (GMakeArgNP np1 np2) = GMakeArgNP (f np1) (f np2)
transformArgs f (GMakeArgAdj np adj) = GMakeArgAdj (f np) adj
transformArgs f (GMakeArgNPNP np1 np2 np3) = GMakeArgNPNP (f np1) (f np2) (f np3)

transformNP :: (GAbsN' -> GAbsN') -> GAbsNP -> GAbsNP
transformNP f (GMakeNP det n') = GMakeNP det (f n')
transformNP _ np = np -- base case

transformN' :: (GAbsCP -> GAbsCP) -> (GAbsPP -> GAbsPP) -> GAbsN' -> GAbsN'
transformN' f _ (GAdjoinN'CP n' cp) = GAdjoinN'CP n' (f cp)
transformN' _ f (GAdjoinN'PP n' pp) = GAdjoinN'PP n' (f pp)
transformN' _ _ n' = n' -- base case

transformPP :: (GAbsNP -> GAbsNP) -> GAbsPP -> GAbsPP
transformPP f (GMakePP p np) = GMakePP p (f np)


{- extractions -}

n_OfDirObj :: GAbsArgStructure -> Maybe GAbsN_
n_OfDirObj (GMakeArgNP _ obj) = n_OfNP obj
n_OfDirObj (GMakeArgVoid _) = Nothing
n_OfDirObj (GMakeArgAdj _ _) = Nothing

n_OfNP :: GAbsNP -> Maybe GAbsN_
n_OfNP (GMakeNP _ n') = Just $ n_OfN' n'
n_OfNP (GPossessive _ n') = Just $ n_OfN' n'
n_OfNP (GNPofProNP _) = Nothing
n_OfNP (GNPofReflexive _) = Nothing
n_OfNP (GNullNP) = Nothing

n_OfN' :: GAbsN' -> GAbsN_
n_OfN' (GMakeN' n) = n_OfN n
n_OfN' (GAdjoinN'CP n' _) = n_OfN' n'

n_OfN :: GAbsN -> GAbsN_
n_OfN (GSingular n_ ) = n_
n_OfN (GPlural n_) = n_
