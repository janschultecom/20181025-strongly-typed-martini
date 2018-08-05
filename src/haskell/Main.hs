module Main where

main :: IO ()
main = putStrLn "Hello World"

{-@ type Nat = {v: Int | v >= 0} @-}

data GlasType = Tumbler Int 
                | Cocktail Int
                | Highball Int
{-@ 
data GlasType = Tumbler ({v: Nat | v == 10})
                | Cocktail ({v: Nat | v == 5}) 
                | Highball ({v: Nat | v == 15}) 
@-}

{-@ bigDrinkGlas :: GlasType @-}
bigDrinkGlas = Highball 15

--{-@ bigDrinkGlasWrong :: GlasType @-}
--bigDrinkGlasWrong = Cocktail 6
