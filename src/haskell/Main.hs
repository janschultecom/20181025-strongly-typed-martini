{-@ LIQUID "--no-termination" @-}

module Main where

import qualified Data.Set as S

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

{-
{-@ bigDrinkGlasWrong :: GlasTypeN 15 @-}
bigDrinkGlasWrong = Cocktail
-}

data Drink = Negroni
           | GinTonic

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

data Ingredient = Rum | Gin | Campari | Vermouth deriving (Eq, Ord)

data Ounce = Oz Ingredient

data ShakerType = Boston

{-@ measure shakerTypeOz @-}
shakerTypeOz :: ShakerType -> Int
shakerTypeOz Boston = 2

{-@ type ShakerTypeN N = {v: ShakerType | N == shakerTypeOz v} @-}

{-@ validBoston :: ShakerTypeN 2 @-}
validBoston = Boston

{-
{-@ nonValidBoston :: ShakerTypeN 5 @-}
nonValidBoston = Boston
-}

data Shaker = Empty
            | Mix Int Ounce Shaker

{-@ measure size @-}
size :: Shaker -> Int
size Empty = 0
size (Mix amount oz s) = size s + amount

{-@ type ShakerN ST = {v: Shaker | size v <= shakerTypeOz ST } @-}

{-@ shaker0 :: ShakerN Boston @-}
shaker0 = Empty

{-@ shaker1 :: ShakerN Boston @-}
shaker1 = Mix 1 (Oz Rum) Empty

{-@ shaker2 :: ShakerN Boston @-}
shaker2 = Mix 1 (Oz Rum) (Mix 1 (Oz Rum) Empty)

{-
{-@ shaker3 :: ShakerN Boston @-}
shaker3 = Mix (Oz Rum) (Mix (Oz Rum) (Mix (Oz Rum) Empty)) -- will fail
-}

{-@ measure ingredients @-}
ingredients :: Drink -> [Ingredient]
ingredients Negroni = [Gin, Vermouth, Campari]
ingredients GinTonic = [Gin]

--data Recipe = Recipe (Set Ingredient)
type Recipe = [Ingredient]

{- {-@ measure ingredients2 @-}
ingredients2 :: Recipe -> Set Ingredient
ingredients2 (Recipe is) = is

{-@ measure isRecipeForDrink @-}
isRecipeForDrink :: Recipe -> Drink -> Bool
isRecipeForDrink recipe drink = Set.intersection (ingredients2 recipe) (ingredients drink) == (ingredients drink)
-}

{-@ measure elts @-}
elts        :: (Ord a) => [a] -> S.Set a
elts []     = S.empty
elts (x:xs) = S.singleton x `S.union` elts xs

{-@ type RecipeN D = { r: Recipe | S.isSubsetOf (elts D) (elts r) } @-}

{-@ goodNegroni :: RecipeN Negroni @-}
goodNegroni :: Recipe
--goodNegroni = Recipe ( fromList [Vermouth, Campari, Gin] )
--goodNegroni = [Vermouth, Campari, Gin] 
goodNegroni = [Gin, Vermouth, Campari] 

-- {-@ badNegroni :: RecipeN Negroni @-}
badNegroni :: Recipe
--badNegroni = Recipe $ fromList [Vermouth, Gin]
badNegroni = [Vermouth, Gin]

main :: IO ()
main = putStrLn ""