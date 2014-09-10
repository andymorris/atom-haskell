{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module HFFI where

import Foreign.C
import Data.Aeson (FromJSON, ToJSON, decode, encode)
import qualified Data.ByteString.Lazy.Char8 as BL
import GHC.Generics (Generic)
import Data.Maybe (isJust, fromJust)


concatter :: String -> String
concatter x = x ++ "?"


data HffiObj = HffiObj { a :: Double, b :: Double, c :: Double }
               deriving (Show, Generic)

adder :: HffiObj -> HffiObj
adder x = x {c = (a x) + (b x)}

data HffiComplex = HffiComplex { os :: [HffiObj] }
                   deriving (Show, Generic)

many_adder :: HffiComplex -> HffiComplex
many_adder x = HffiComplex (map adder (os x))








foreign export ccall concatter_export :: CString -> IO CString
concatter_export x = do
  hstr <- peekCString x
  newCString (concatter hstr)

instance FromJSON HffiObj
instance ToJSON HffiObj

foreign export ccall adder_export :: CString -> IO CString
adder_export x = do
  json <- peekCString x
  let obj = decode (BL.pack json) :: Maybe HffiObj
  case obj of
    Nothing -> newCString ""
    Just o ->  newCString $ show $ encode $ adder o

instance FromJSON HffiComplex
instance ToJSON HffiComplex

foreign export ccall many_adder_export :: CString -> IO CString
many_adder_export x = do
  json <- peekCString x
  let obj = decode (BL.pack json) :: Maybe HffiComplex
  case obj of
    Nothing -> newCString ""
    Just o ->  newCString $ show $ encode $ many_adder o
