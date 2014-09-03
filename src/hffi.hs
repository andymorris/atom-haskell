{-# LANGUAGE OverloadedStrings #-}

module HFFI where

import Foreign.C

adder :: Int -> Int
adder x = x + 3

--foreign export ccall adder_export :: CString -> IO CString
--adder_export = export . returnId2 $ adder


concatter :: String -> String
concatter x = x ++ "?"

foreign export ccall concatter_export :: CString -> IO CString
concatter_export x = do
  hstr <- peekCString x
  newCString $ concatter hstr
