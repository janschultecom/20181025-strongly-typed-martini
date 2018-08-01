
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

data Glas : (glasType : GlasType n ) -> Type where
  MkGlas : (drink : Drink glasType) -> Glas glasType 

pour : (drink : Drink glasType) -> Glas glasType
pour Negroni = MkGlas Negroni
pour GinTonic = MkGlas GinTonic

glas : Glas Tumbler
glas = pour Negroni 

glasWrong : Glas Tumbler
--glasWrong = pour GinTonic


data Ingredient : Type where
  Rum : Ingredient

data Ounce : Ingredient -> Type where
  Oz : (ingredient:Ingredient) -> Ounce ingredient 

