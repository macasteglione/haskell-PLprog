main :: IO ()
main = do 
  putStrLn "como te llamas?"
  nombre <- getLine
  putStrLn ("Hola, " ++ nombre)

-- main = putStrLn "Como te llamas? " >> getLine >>= \nombre -> putStrLn ("Hola, " ++ nombre)
