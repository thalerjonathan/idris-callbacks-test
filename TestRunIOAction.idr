module TestRunIOAction

import Data.IORef

%include C "idris_clbks_test.h"
%link C "idris_clbks_test.o"

TestCallback : Type
TestCallback = Int -> IO ()

testCallback : TestCallback
testCallback x 
  = putStrLn $ "testCallback x = " ++ show x -- is never called, should be called by testCallbackPure (see below)

setTestCallback : TestCallback -> IO ()
setTestCallback clbk = do
    clbkPtr <- foreign FFI_C "%wrapper" (CFnPtr (Int -> ()) -> IO Ptr) (MkCFnPtr testCallbackPure)
    foreign FFI_C "registerCallback" (Ptr -> IO ()) clbkPtr
  where
    testCallbackPure : Int -> ()
    testCallbackPure x = unsafePerformIO $ do
      putStrLn "before calling action..."
      clbk x -- should call testCallback, but is never called (see above)
      putStrLn "after calling action"

runCallback : IO ()
runCallback = foreign FFI_C "runCallback" (IO ())

export
run : IO ()
run = do
  setTestCallback testCallback
  runCallback