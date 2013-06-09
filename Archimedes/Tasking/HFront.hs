--Frontend to Helix.hs
module Archimedes.Tasking.HFront(
    control
  , getStrands) where
import Archimedes.Tasking.Helix

control :: String -> String
control x = getControl x [('@',['a'..'z']), ('!',['A'..'Z']), ('#',['0'..'9']), ('%',"`~!@#$%^&*()_+=-[{]}\\\":;,<.>/?")]

getStrands :: String -> String -> [String]
getStrands x y = strands x y [('@',['a'..'z']), ('!',['A'..'Z']), ('#',['0'..'9']), ('%',"`~!@#$%^&*()_+=-[{]}\\\":;,<.>/?")]

fooFun x = x
