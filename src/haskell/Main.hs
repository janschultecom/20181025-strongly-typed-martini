{-@ LIQUID "--no-termination" @-}

module Main where

import qualified Data.Set as S

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

{-@ measure glas @-}
glas :: Drink -> GlasType
glas Negroni = Tumbler
glas GinTonic = Highball

{-@ type DrinkR T = {v: Drink | T == glas v} @-}

{-@ validNegroni :: DrinkR Tumbler @-}
validNegroni = Negroni :: Drink

{-
{-@ wrongNegroni :: DrinkR Highball @-}
wrongNegroni = Negroni :: Drink
-}

data Ingredient = Rum | Gin | Campari | Vermouth | Tonic deriving (Eq, Ord)

--data Ounce = Oz Ingredient



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


data ShakerVariety = Boston | French | Cobbler

{-@ measure shakerVarietyOz @-}
shakerVarietyOz :: ShakerVariety -> Int
shakerVarietyOz Boston = 28
shakerVarietyOz French = 20
shakerVarietyOz Cobbler = 24

-- {-@ type ShakerTypeN N = {v: ShakerType | N == shakerVarietyOz v} @-}

-- {-@ validBoston :: ShakerTypeN 28 @-}
-- validBoston = Boston

{-
{-@ nonValidBoston :: ShakerTypeN 29 @-}
nonValidBoston = Boston
-}

data Shaker = Empty
            | Mix Int Ingredient Shaker

{-@ measure volume @-}
volume :: Shaker -> Int
volume Empty = 0
volume (Mix amount ingredient s) = amount + volume s

{-@ type ShakerN ST = {v: Shaker | volume v <= shakerVarietyOz ST } @-}

{-@ shaker0 :: ShakerN Boston @-}
shaker0 = Empty

--{-@ shaker1 :: {s:ShakerN Boston | volume s == 10 } @-}
{-@ shaker1 :: ShakerN Boston @-}
shaker1 = Mix 28 Rum Empty

{-@ shaker2 :: ShakerN Boston @-}
shaker2 = Mix 20 Rum (Mix 7 Rum Empty)


--{-@ shaker3 :: ShakerN Boston @-}
--shaker3 = Mix 20 Rum (Mix 9 Rum Empty) -- will fail

{-@ measure contents @-}
contents :: Shaker -> S.Set Ingredient
contents Empty = S.empty
contents (Mix amount ingredient rest) = S.union (S.singleton ingredient) (contents rest)

{-@ type ShakerR R = {v: Shaker | contents v == ingredients R } @-}
{-@ shaker4 :: ShakerR GinTonic @-}
shaker4 :: Shaker
shaker4 = Mix 2 Gin (Mix 10 Tonic Empty)
--shaker4 = Mix 2 Gin Empty -- will fail


type Content = S.Set Ingredient
data Glas = Glas Drink GlasType Content

{-@ pour :: r:Drink ~> ShakerR r -> { d:Drink | r == d } -> gt:GlasType -> g : Glas @-}
pour :: Shaker -> Drink -> GlasType -> Glas 
pour shaker drink glasType = Glas drink glasType (contents shaker)

glasOfNegroni :: Glas 
--glasOfNegroni = pour shaker4 Negroni Tumbler -- will fail
glasOfNegroni = pour shaker4 GinTonic Highball


{-@ pour2 :: r:Drink ~> ShakerR r -> dd : { d:Drink | r == d } -> { gt:GlasType | gt == glas dd } -> g : Glas @-}
pour2 :: Shaker -> Drink -> GlasType -> Glas 
pour2 shaker drink glasType = Glas drink glasType (contents shaker)

glasOfNegroni2 :: Glas 
--glasOfNegroni2 = pour2 shaker4 GinTonic Tumbler -- will fail
glasOfNegroni2 = pour2 shaker4 GinTonic Highball

{-@ shaker5a :: {s:ShakerR GinTonic | volume s == 15 } @-}
shaker5a :: Shaker
shaker5a = Mix 5 Gin (Mix 10 Tonic Empty)

{-@ shaker5b :: {s:ShakerR GinTonic | volume s == 16 } @-}
shaker5b :: Shaker
shaker5b = Mix 6 Gin (Mix 10 Tonic Empty)

{-@ pour3 :: r:Drink ~> s:ShakerR r -> dd : { d:Drink | r == d } -> { gt:GlasType | gt == glas dd && volume s <= maxOz gt } -> g : Glas @-}
pour3 :: Shaker -> Drink -> GlasType -> Glas 
pour3 shaker drink glasType = Glas drink glasType (contents shaker)

glasOfNegroni3 :: Glas 
--glasOfNegroni3 = pour3 shaker5b GinTonic Highball -- will fail
glasOfNegroni3 = pour3 shaker5a GinTonic Highball


main :: IO ()
main = do
    _ <- print "Volume shaker1 " *> print (volume shaker1)
    _ <- print "maxOz Highball " *> print (maxOz Highball)
    _ <- print "volume s <= maxOz gt " *> print (volume shaker1 <= maxOz Highball )
    pure ()
