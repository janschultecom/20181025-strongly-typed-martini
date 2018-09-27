{-@ LIQUID "--no-termination" @-}

module Main where

import qualified Data.Set as S

-- EXERCISE 1 -- This is given

data GlasType = Tumbler | CocktailGlas | Highball

{-@ measure maxOz @-}
maxOz :: GlasType -> Int
maxOz Tumbler = 10
maxOz CocktailGlas = 5
maxOz Highball = 15

{-@ type GlasTypeN N = {v: GlasType | N == maxOz v} @-}

{-@ bigDrinkGlas :: GlasTypeN 15 @-}
bigDrinkGlas :: GlasType
bigDrinkGlas = Highball

{-
{-@ bigDrinkGlasWrong :: GlasTypeN 15 @-}
bigDrinkGlasWrong = CocktailGlas
-}

data Drink = Negroni | GinTonic

-- EXERCISE 1 -- This has to be developed
{-@ measure glas @-}
glas :: Drink -> GlasType
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

--{-@ nonValidBoston :: ShakerVarietyR 29 @-}  -- will fail
--nonValidBoston = Boston -- will fail
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

-- EXERCISE 4 -- This is given
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

{-@ measure contents @-}
contents :: Shaker -> S.Set Ingredient
contents Empty = S.empty
contents (Mix amount ingredient rest) = S.union (S.singleton ingredient) (contents rest)

{-@ type ShakerR R = {v: Shaker | contents v == ingredients R } @-}


-- EXERCISE 4 -- Thats what we want to achieve 
{-@ shaker4 :: ShakerR GinTonic @-}
shaker4 :: Shaker
shaker4 = Mix 2 Gin (Mix 10 Tonic Empty)
--shaker4 = Mix 2 Gin Empty -- will fail

-- EXERCISE 4 -- End

-- EXERCISE 5 -- This is given
type Content = S.Set Ingredient
data Glas = Glas Drink GlasType Content

{-@ pour :: r:Drink ~> ShakerR r -> { d:Drink | r == d } -> gt:GlasType -> g : Glas @-}
pour :: Shaker -> Drink -> GlasType -> Glas 
pour shaker drink glasType = Glas drink glasType (contents shaker)

glasOfNegroni :: Glas 
--glasOfNegroni = pour shaker4 Negroni Tumbler -- will fail
glasOfNegroni = pour shaker4 GinTonic Highball


-- EXERCISE 5 -- This has to be developed

{-@ pour2 :: r:Drink ~> ShakerR r -> dd : { d:Drink | r == d } -> { gt:GlasType | gt == glas dd } -> g : Glas @-}
pour2 :: Shaker -> Drink -> GlasType -> Glas 
pour2 shaker drink glasType = Glas drink glasType (contents shaker)


-- EXERCISE 5 -- Thats what we want to achieve 
glasOfNegroni2 :: Glas 
--glasOfNegroni2 = pour2 shaker4 GinTonic Tumbler -- will fail
glasOfNegroni2 = pour2 shaker4 GinTonic Highball

-- EXERCISE 5 -- End

-- EXERCISE 6 -- This is given

{-@ shaker5a :: {s:ShakerR GinTonic | volume s == 15 } @-}
shaker5a :: Shaker
shaker5a = Mix 5 Gin (Mix 10 Tonic Empty)

{-@ shaker5b :: {s:ShakerR GinTonic | volume s == 16 } @-}
shaker5b :: Shaker
shaker5b = Mix 6 Gin (Mix 10 Tonic Empty)


-- EXERCISE 6 -- This has to be developed

{-@ pour3 :: r:Drink ~> s:ShakerR r -> dd : { d:Drink | r == d } -> { gt:GlasType | gt == glas dd && volume s <= maxOz gt } -> g : Glas @-}
pour3 :: Shaker -> Drink -> GlasType -> Glas 
pour3 shaker drink glasType = Glas drink glasType (contents shaker)

-- EXERCISE 6 -- Thats what we want to achieve 

glasOfNegroni3 :: Glas 
--glasOfNegroni3 = pour3 shaker5b GinTonic Highball -- will fail
glasOfNegroni3 = pour3 shaker5a GinTonic Highball

-- EXERCISE 6 -- End

main :: IO ()
main = print "A strongly typed martini. Shaken, not stirred. 🍸"