{-@ LIQUID "--no-termination" @-}

module Main where

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

data Ingredient = Rum

data Ounce = Oz Ingredient

data ShakerType = Boston | French

{-@ measure shakerTypeOz @-}
shakerTypeOz :: ShakerType -> Int
shakerTypeOz Boston = 28
shakerTypeOz French = 20

{-@ type ShakerTypeN N = {v: ShakerType | N == shakerTypeOz v} @-}

{-@ validBoston :: ShakerTypeN 28 @-}
validBoston = Boston

{-
{-@ nonValidBoston :: ShakerTypeN 29 @-}
nonValidBoston = Boston
-}

data Shaker = Empty
            | Mix Int Ounce Shaker

{-@ measure volume @-}
volume :: Shaker -> Int
volume Empty = 0
volume (Mix amount oz s) = volume s + amount

{-@ type ShakerN ST = {v: Shaker | volume v <= shakerTypeOz ST } @-}

{-@ shaker0 :: ShakerN Boston @-}
shaker0 = Empty

{-@ shaker1 :: ShakerN Boston @-}
shaker1 = Mix 10 (Oz Rum) Empty

{-@ shaker2 :: ShakerN Boston @-}
shaker2 = Mix 20 (Oz Rum) (Mix 7 (Oz Rum) Empty)

{-
{-@ shaker3 :: ShakerN Boston @-}
shaker3 = Mix (Oz Rum) (Mix (Oz Rum) (Mix (Oz Rum) Empty)) -- will fail
-}

data Glas = Glas GlasType

{-@ pour ::  s: Shaker -> x : { gt:GlasType | volume s <= maxOz gt } -> Glas @-}
pour :: Shaker -> GlasType -> Glas
pour shaker = Glas


validGlas :: Glas 
validGlas = pour shaker1 Highball 

main :: IO ()
main = do 
    _ <- print "Volume shaker1 " *> print (volume shaker1)
    _ <- print "maxOz Highball " *> print (maxOz Highball)
    _ <- print "volume s <= maxOz gt " *> print (volume shaker1 <= maxOz Highball )
    pure ()