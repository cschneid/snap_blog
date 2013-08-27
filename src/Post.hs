{-# LANGUAGE OverloadedStrings #-}

module Post where

import           Data.ByteString (ByteString)
import           Snap.Snaplet.Heist
import           Snap.Snaplet
import qualified Heist.Interpreted as I
import qualified Data.Text as T
import qualified Database.Persist as P
import           Snap.Snaplet.Persistent
------------------------------------------------------------------------------
import Application
import Database

routes :: [(ByteString, Handler App App ())]
routes = [ ("/posts", Post.postsHandler)
         ]

postsHandler :: Handler App App ()
postsHandler = do
  results <- runPersist $ P.selectList [] []
  let posts = map convert results
  heistLocal (I.bindSplice "posts" (postsSplice posts)) $ render "posts/index"
  where 
    convert (P.Entity _ post) = post


postSplice :: Post -> I.Splice (Handler App App)
postSplice post = I.runChildrenWithText [("postContent", postContent post)]

postsSplice :: [Post] -> I.Splice (Handler App App)
postsSplice = I.mapSplices postSplice
