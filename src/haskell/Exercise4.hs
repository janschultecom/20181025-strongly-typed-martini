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
{-@ measure shakerVarietyOz @-}
shakerVarietyOz :: ShakerVariety -> Int
shakerVarietyOz Boston = 28
shakerVarietyOz French = 20
shakerVarietyOz Cobbler = 24

{-@ type ShakerVarietyR N = {v: ShakerVariety | N == shakerVarietyOz v} @-}

-- EXERCISE 2 -- Thats what we want to achieve 
{-@ validBoston :: ShakerVarietyR 28 @-}
validBoston = Boston

--{-@ nonValidBoston :: ShakerVarietyR 28 @-}  -- will fail
--nonValidBoston = Cobbler -- will fail
-- EXERCISE 2 -- End


-- EXERCISE 3 -- This is given
data Ingredient = Rum | Gin | Campari | Vermouth | Tonic deriving (Eq, Ord)

data Shaker = Empty | Mix Int Ingredient Shaker
            
-- EXERCISE 3 -- This has to be developed

{-@ measure volume @-}
volume :: Shaker -> Int
volume Empty = 0
volume (Mix amount ingredient s) = amount + volume s

{-@ type ShakerN ST = {v: Shaker | volume v <= shakerVarietyOz ST } @-}

-- EXERCISE 3 -- Thats what we want to achieve 

{-@ shaker0 :: ShakerN Boston @-}
shaker0 = Empty

{-@ shaker1 :: ShakerN Boston @-}
shaker1 = Mix 28 Rum Empty

{-@ shaker2 :: ShakerN Boston @-}
shaker2 = Mix 20 Rum (Mix 7 Rum Empty)

--{-@ shaker3 :: ShakerN Boston @-}
--shaker3 = Mix 20 Rum (Mix 9 Rum Empty) -- will fail

-- EXERCISE 3 -- End

-- EXAMPLE 2 -- This is given
type Recipe = S.Set Ingredient

{-@ measure ingredients @-}
ingredients :: Drink -> Recipe
ingredients Negroni = S.union (S.union (S.singleton Gin) (S.singleton Vermouth)) (S.singleton Campari)
ingredients GinTonic = S.union (S.singleton Gin) (S.singleton Tonic)

{-@ type RecipeN R = { x:Recipe | S.isSubsetOf (ingredients R) x } @-}
{-@ goodNegroni :: RecipeN Negroni @-}
goodNegroni :: Recipe
--goodNegroni = S.union (S.union (S.union (S.singleton Gin) (S.singleton Vermouth)) (S.singleton Campari)) (S.singleton Rum)
goodNegroni = S.fromList [Vermouth, Rum, Gin, Campari]

--{-@ badNegroni :: Negroni @-}
--badNegroni :: Recipe
--badNegroni = [Vermouth, Gin]


-- EXERCISE 4 -- This has to be developed



-- EXERCISE 4 -- Thats what we want to achieve 
--{-@ shaker4 :: ShakerR GinTonic @-}
--shaker4 :: Shaker
--shaker4 = Mix 2 Gin (Mix 10 Tonic Empty)
--shaker4 = Mix 2 Gin Empty -- will fail

-- EXERCISE 4 -- End


main :: IO ()
main = print "A strongly typed martini. Shaken, not stirred. 🍸"