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
{-@ measure glas @-}
glas :: Drink -> GlasVariety
glas Negroni = Tumbler
glas GinTonic = Highball

{-@ type DrinkR T = {v: Drink | T == glas v} @-}

-- EXERCISE 1 -- Thats what we want to achieve 
{-@ validNegroni :: DrinkR Tumbler @-}
validNegroni = Negroni :: Drink

{-
{-@ wrongNegroni :: DrinkR Highball @-}
wrongNegroni = Negroni :: Drink
-}
-- EXERCISE 1 -- End


-- EXERCISE 2 -- This is given
data ShakerVariety = Boston | French | Cobbler

-- EXERCISE 2 -- This has to be developed


-- EXERCISE 2 -- Thats what we want to achieve 
--{-@ validBoston :: ShakerVarietyR 28 @-}
--validBoston = Boston

--{-@ nonValidBoston :: ShakerVarietyR 28 @-}  -- will fail
--nonValidBoston = Cobbler -- will fail
-- EXERCISE 2 -- End


main :: IO ()
main = print "A strongly typed martini. Shaken, not stirred. 🍸"