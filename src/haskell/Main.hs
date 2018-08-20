module Main where

main :: IO ()
main = putStrLn "Refinement types"

data GlasType = Tumbler
              | Cocktail
              | Highball

{-@ measure maxOz @-}
maxOz :: GlasType -> Int
maxOz Tumbler = 10
maxOz Cocktail = 5
maxOz Highball = 15

{-@ type GlasTypeN N = {v: GlasType | N == maxOz v} @-}

{-@ bigDrinkGlas :: GlasTypeN 15 @-}
bigDrinkGlas = Highball

--{-@ bigDrinkGlasWrong :: GlasTypeN 15 @-}
--bigDrinkGlasWrong = Cocktail
