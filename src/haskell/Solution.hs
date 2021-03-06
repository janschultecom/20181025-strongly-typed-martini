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
data Ingredient = AppleJuice | WhiteGrapeJuice | SanBitter | RedGrapeJuice | Tonic deriving (Eq, Ord)

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
shaker1 = Mix 28 AppleJuice Empty

{-@ shaker2 :: ShakerN Boston @-}
shaker2 = Mix 20 AppleJuice (Mix 7 AppleJuice Empty)

--{-@ shaker3 :: ShakerN Boston @-}
--shaker3 = Mix 20 AppleJuice (Mix 9 AppleJuice Empty) -- will fail

-- EXERCISE 3 -- End

-- EXAMPLE 2 -- This is given
type Recipe = S.Set Ingredient

{-@ measure ingredients @-}
ingredients :: Drink -> Recipe
ingredients Negroni = S.union (S.union (S.singleton WhiteGrapeJuice) (S.singleton RedGrapeJuice)) (S.singleton SanBitter)
ingredients GinTonic = S.union (S.singleton WhiteGrapeJuice) (S.singleton Tonic)

{-@ type RecipeN R = { x:Recipe | S.isSubsetOf (ingredients R) x } @-}
{-@ goodNegroni :: RecipeN Negroni @-}
goodNegroni :: Recipe
--goodNegroni = S.union (S.union (S.union (S.singleton WhiteGrapeJuice) (S.singleton RedGrapeJuice)) (S.singleton SanBitter)) (S.singleton AppleJuice)
goodNegroni = S.fromList [RedGrapeJuice, AppleJuice, WhiteGrapeJuice, SanBitter]

--{-@ badNegroni :: RecipeN Negroni @-}
--badNegroni :: Recipe
--badNegroni = S.fromList [RedGrapeJuice, WhiteGrapeJuice]


-- EXERCISE 4 -- This has to be developed

{-@ measure contents @-}
contents :: Shaker -> S.Set Ingredient
contents Empty = S.empty
contents (Mix amount ingredient rest) = S.union (S.singleton ingredient) (contents rest)

{-@ type ShakerR R = {v: Shaker | contents v == ingredients R } @-}


-- EXERCISE 4 -- Thats what we want to achieve 
{-@ shaker4 :: ShakerR GinTonic @-}
shaker4 :: Shaker
shaker4 = Mix 2 WhiteGrapeJuice (Mix 10 Tonic Empty)
--shaker4 = Mix 2 WhiteGrapeJuice Empty -- will fail

-- EXERCISE 4 -- End

-- EXAMPLE 3 -- This is given
type Content = S.Set Ingredient
data Glas = Glas Drink GlasVariety Content

{-@ pour :: r:Drink ~> ShakerR r -> { d:Drink | r == d } -> gv:GlasVariety -> g : Glas @-}
pour :: Shaker -> Drink -> GlasVariety -> Glas 
pour shaker drink glasVariety = Glas drink glasVariety (contents shaker)

glasOfNegroni :: Glas 
--glasOfNegroni = pour shaker4 Negroni Tumbler -- will fail
glasOfNegroni = pour shaker4 GinTonic Highball


-- EXERCISE 5 -- This has to be developed

{-@ pour2 :: r:Drink ~> ShakerR r -> dd : { d:Drink | r == d } -> { gv:GlasVariety | gv == glas dd } -> g : Glas @-}
pour2 :: Shaker -> Drink -> GlasVariety -> Glas 
pour2 shaker drink glasVariety = Glas drink glasVariety (contents shaker)


-- EXERCISE 5 -- Thats what we want to achieve 
glasOfNegroni2 :: Glas 
--glasOfNegroni2 = pour2 shaker4 GinTonic Tumbler -- will fail
glasOfNegroni2 = pour2 shaker4 GinTonic Highball

-- EXERCISE 5 -- End

-- EXERCISE 6 -- This is given

{-@ shaker5a :: {s:ShakerR GinTonic | volume s == 15 } @-}
shaker5a :: Shaker
shaker5a = Mix 5 WhiteGrapeJuice (Mix 10 Tonic Empty)

{-@ shaker5b :: {s:ShakerR GinTonic | volume s == 16 } @-}
shaker5b :: Shaker
shaker5b = Mix 6 WhiteGrapeJuice (Mix 10 Tonic Empty)


-- EXERCISE 6 -- This has to be developed

{-@ pour3 :: r:Drink ~> s:ShakerR r -> dd : { d:Drink | r == d } -> { gv:GlasVariety | gv == glas dd && volume s <= maxOz gv } -> g : Glas @-}
pour3 :: Shaker -> Drink -> GlasVariety -> Glas 
pour3 shaker drink glasVariety = Glas drink glasVariety (contents shaker)

-- EXERCISE 6 -- Thats what we want to achieve 

glasOfNegroni3 :: Glas 
--glasOfNegroni3 = pour3 shaker5b GinTonic Highball -- will fail
glasOfNegroni3 = pour3 shaker5a GinTonic Highball

-- EXERCISE 6 -- End

main :: IO ()
main = print "A strongly typed martini. Shaken, not stirred. 🍸"