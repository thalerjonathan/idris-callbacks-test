module TestModifyIORef

import Data.IORef

%include C "idris_clbks_test.h"
%link C "idris_clbks_test.o"
%flag C "-g"

TestCallback : Type
TestCallback = Int -> ()

testCallbackPure : IORef Integer -> Int -> ()
testCallbackPure ref x = unsafePerformIO $ do 
  putStrLn "before modifyIORef"
  modifyIORef ref (+1) -- segmentation fault occurs here
  --writeIORef ref 42
  --ret <- readIORef ref
  --putStrLn $ "readIORef: " ++ show ret
  putStrLn "after modifyIORef"

testCallbackPurePtr : IORef Integer -> IO Ptr
testCallbackPurePtr ref
  = foreign FFI_C "%wrapper" (CFnPtr TestCallback -> IO Ptr) (MkCFnPtr $ testCallbackPure ref)

setTestCallbackWithPtr : IORef Integer -> IO ()
setTestCallbackWithPtr ref = do
  ptr <- testCallbackPurePtr ref
  foreign FFI_C "registerCallback" (Ptr -> IO ()) ptr

runCallback : IO ()
runCallback = foreign FFI_C "runCallback" (IO ())

export
run : IO ()
run = do
  ref <- newIORef 42
  setTestCallbackWithPtr ref
  runCallback
  ret <- readIORef ref
  putStrLn $ "IORef = " ++ show ret