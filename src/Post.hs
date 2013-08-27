{-# LANGUAGE OverloadedStrings #-}

module Post where

import           Data.ByteString (ByteString)
import           Snap.Snaplet.Heist
import           Snap.Snaplet
------------------------------------------------------------------------------
import Application


routes :: [(ByteString, Handler App App ())]
routes = [ ("/posts", Post.postsHandler)
         ]

postsHandler :: Handler App App ()
postsHandler = render "posts/index"

