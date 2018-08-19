module Main where

main :: IO ()
main = putStrLn "Refinements types"

data GlasType = Tumbler
              | Cocktail
              | Highball

{-@ measure glasSize @-}
glasSize :: GlasType -> Int
glasSize Tumbler = 10
glasSize Cocktail = 5
glasSize Highball = 15

{-@ type GlasTypeN N = {v: GlasType | N == glasSize v} @-}

{-@ bigDrinkGlas :: GlasTypeN 15 @-}
bigDrinkGlas = Highball

--{-@ bigDrinkGlasWrong :: GlasTypeN 15 @-}
--bigDrinkGlasWrong = Cocktail
