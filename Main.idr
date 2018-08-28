import Data.Fin
import Data.Vect

data GlasType : (maxOz:Nat) -> Type where
  Tumbler : GlasType 10
  Cocktail : GlasType 5
  Highball : GlasType 15

bigDrinkGlas : GlasType 15
bigDrinkGlas = Highball

bigDrinkGlasWrong : GlasType 15
--bigDrinkGlasWrong = Cocktail 

data Drink : (glas : GlasType n ) -> Type where
  Negroni : Drink Tumbler
  GinTonic : Drink Highball

data Glas : {n:Nat } -> (glasType : GlasType n ) -> Type where
  MkGlas : (drink : Drink glasType) -> Glas glasType 

pour : (drink : Drink glasType) -> Glas glasType
pour Negroni = MkGlas Negroni
pour GinTonic = MkGlas GinTonic

glas : Glas Tumbler
glas = pour Negroni 

glasWrong : Glas Tumbler
--glasWrong = pour GinTonic -- will fail

data Ingredient : Type where
  Rum : Ingredient

data Ounce : Ingredient -> Type where
  Oz : (ingredient:Ingredient) -> Ounce ingredient 

data ShakerType : (n : Nat) -> Type where
  Boston : ShakerType 2 -- Should be 28

data Shaker : (content:Nat) -> (typ : ShakerType maxOz) -> Type where
  Empty : Shaker 0 shakerType
  Mix : { shakerType : ShakerType maxOz } -> 
        (ounce : Ounce ingredient) -> 
        (shaker : Shaker content shakerType) -> 
        { auto prf : LTE (content+1) maxOz } -> 
        Shaker (content+1) shakerType 


shaker0 : Shaker 0 Boston
shaker0 = Empty

shaker1 : Shaker 1 Boston
shaker1 = Mix (Oz Rum) Empty

shaker2a : Shaker 2 Boston
shaker2a = Mix (Oz Rum) (Mix (Oz Rum) Empty)

shaker2b : Shaker 1 Boston
--shaker2b = Mix (Oz Rum) (Mix (Oz Rum) Empty) -- will fail

