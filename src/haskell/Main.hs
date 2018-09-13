{-@ LIQUID "--no-termination" @-}

module Main where

import Data.Set as Set hiding (size)

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
ingredients :: Drink -> Set Ingredient
ingredients Negroni = fromList [Gin, Vermouth, Campari]
ingredients GinTonic = fromList [Gin]

data Recipe = Recipe (Set Ingredient)

{-@ measure ingredients2 @-}
ingredients2 :: Recipe -> Set Ingredient
ingredients2 (Recipe is) = is

{-@ measure isRecipeForDrink @-}
isRecipeForDrink :: Recipe -> Drink -> Bool
isRecipeForDrink recipe drink = Set.intersection (ingredients2 recipe) (ingredients drink) == (ingredients drink)

{-@ type RecipeN D = { r: Recipe | (isRecipeForDrink r D)} @-}

{-@ goodNegroni :: RecipeN Negroni @-}
goodNegroni :: Recipe
goodNegroni = Recipe $ fromList [Vermouth, Campari, Gin]

-- {-@ badNegroni :: RecipeN Negroni @-}
badNegroni :: Recipe
badNegroni = Recipe $ fromList [Vermouth, Gin]

main :: IO ()
main = putStrLn $ show $ Set.intersection (ingredients2 r) (ingredients d) == (ingredients d)
    where 
        r = goodNegroni
        d = Negroni
        