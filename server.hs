#!/usr/bin/env stack
-- stack --resolver lts-13.0 script

import           Control.Concurrent      (threadDelay)
import           Control.Concurrent.MVar (MVar, newMVar, withMVar)
import           Control.Monad           (forever, replicateM_)
import           Data.ByteString.Char8   (unpack)
import           System.ZMQ4.Monadic

serverWorker :: MVar () -> ZMQ z ()
serverWorker lock = do
    worker <- socket Dealer
    connect worker "inproc://backend"
    liftIO $ withMVar lock $ \_ -> putStrLn "Worker Started"
    forever $ do -- receive both ident and msg and send back the reply to the ident client
        liftIO $ withMVar lock $ \_ -> putStrLn "Ready to receive..."
        ident <- receive worker
        msg <- receive worker
        workload worker ident msg
    where
        workload worker ident msg = do
            liftIO $ withMVar lock $ \_ -> putStrLn (unpack ident)
            liftIO $ withMVar lock $ \_ -> putStrLn (unpack msg)
            -- Do something
            liftIO $ threadDelay $ 1 * 1000 * 1000
            let reply = msg
            -- send back the reply to the ident client
            send worker [SendMore] ident
            send worker [] reply

main :: IO ()
main =
    runZMQ $ do
        -- We use MVar ONLY for IO, quick and dirty method to avoid interleaved output
        lock <- liftIO $ newMVar ()
        frontend <- socket Router
        bind frontend "tcp://*:53939"
        backend <- socket Dealer
        bind backend "inproc://backend"

        -- "5 ought to be enough for anybody" (Bill Gates)
        replicateM_ 5 $ async (serverWorker lock)

        proxy frontend backend Nothing