{-@ LIQUID "--no-termination" @-}

module Main where

import qualified Data.Set as S

-- EXAMPLE 1

data GlasVariety = Tumbler | CocktailGlas | Highball

{-@ measure maxOz @-}
maxOz :: GlasVariety -> Int
maxOz Tumbler = 10
maxOz CocktailGlas = 5
maxOz Highball = 15

{-@ type GlasVarietyR N = {v: GlasVariety | N == maxOz v} @-}

{-@ bigDrinkGlas :: GlasVarietyR 15 @-}
bigDrinkGlas :: GlasVariety
bigDrinkGlas = Highball

{-
{-@ bigDrinkGlasWrong :: GlasVarietyR 15 @-}
bigDrinkGlasWrong = CocktailGlas
-}

-- EXERCISE 1 -- This is given

data Drink = Negroni | GinTonic

-- EXERCISE 1 -- This has to be developed


-- EXERCISE 1 -- Thats what we want to achieve 
--{-@ validNegroni :: DrinkR Tumbler @-}
--validNegroni = Negroni :: Drink

{-
{-@ wrongNegroni :: DrinkR Highball @-}
wrongNegroni = Negroni :: Drink
-}
-- EXERCISE 1 -- End


main :: IO ()
main = print "A strongly typed martini. Shaken, not stirred. 🍸"