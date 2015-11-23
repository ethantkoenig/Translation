module TransUtils where

import Prelude
import Trans


transformVP :: (GAbsVP_ -> GAbsVP_) -> GAbsVP -> GAbsVP
transformVP f (GPositive vp_) = GPositive (f vp_)
transformVP f (GNegative vp_) = GNegative (f vp_)

transformVP_ :: (GAbsVP__ -> GAbsVP__) -> GAbsVP_ -> GAbsVP_
transformVP_ f (GPresent vp__) = GPresent (f vp__)
transformVP_ f (GPast vp__) = GPast (f vp__)
transformVP_ f (GCond vp__) = GCond (f vp__)
transformVP_ f (GFuture vp__) = GFuture (f vp__)


transformVP__ :: (GAbsV' -> GAbsV') -> GAbsVP__ -> GAbsVP__
transformVP__ f (GMakeVP__ v') = GMakeVP__ (f v')


n_OfDirObj :: GAbsArgStructure -> Maybe GAbsN_
n_OfDirObj (GMakeArgNP _ obj) = n_OfNP obj
n_OfDirObj (GMakeArgVoid _) = Nothing
n_OfDirObj (GMakeArgAdj _ _) = Nothing

n_OfNP :: GAbsNP -> Maybe GAbsN_
n_OfNP (GMakeNP _ n') = Just $ n_OfN' n'
n_OfNP (GPossessive _ n') = Just $ n_OfN' n'
n_OfNP (GNPofProNP _) = Nothing

n_OfN' :: GAbsN' -> GAbsN_
n_OfN' (GMakeN' n) = n_OfN n
n_OfN' (GAdjoinN' n' _) = n_OfN' n'

n_OfN :: GAbsN -> GAbsN_
n_OfN (GSingular n_ ) = n_
n_OfN (GPlural n_) = n_
