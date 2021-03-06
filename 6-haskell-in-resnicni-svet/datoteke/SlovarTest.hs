import Slovar
import Test.QuickCheck

dodajCrke :: Slovar Char Int -> String -> Slovar Char Int
dodajCrke d "" = d
dodajCrke d (crka:niz) = dodajCrke (dodajCrka d crka) niz
  where
    dodajCrka d crka =
        case poisci d crka of
            Nothing -> dodaj d crka 1
            Just n -> dodaj d crka (1 + n)

prop_poisciDodaj :: Slovar Char Int -> Char -> Int -> Bool
prop_poisciDodaj d k v = poisci (dodaj d k v) k == Just v

-- ta lastnost ne bo v redu, ker ne preveri možnosti, da sta k in k' enaka
prop_poisciDodaj2 :: Slovar Char Int -> Char -> Char -> Int -> Int -> Bool
prop_poisciDodaj2 d k k' v v' =
    poisci (dodaj (dodaj d k v) k' v') k == Just v

-- ta lastnost pa bo v redu, ker ne preveri možnosti, da sta k in k' enaka
prop_poisciDodaj2' :: Slovar Char Int -> Char -> Char -> Int -> Int -> Property
prop_poisciDodaj2' d k k' v v' =
    k /= k' ==> poisci (dodaj (dodaj d k v) k' v') k == Just v

dodajaj frekvence =
    do
        vrstica <- getLine
        if null vrstica then
            return frekvence
        else
            dodajaj $ dodajCrke frekvence vrstica

main = do
    putStrLn "Preverjam, ali vse deluje:"
    quickCheck prop_poisciDodaj
    quickCheck prop_poisciDodaj2'
    putStrLn "Da, deluje. Zdaj lahko začnemo z izvajanjem."
    putStrLn "Vnašaj besedilo. Po prazni vrstici bom izpisal drevo frekvenc."
    frekvence <- dodajaj prazen
    print frekvence
