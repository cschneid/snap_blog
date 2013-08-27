{-# LANGUAGE OverloadedStrings #-}

module Post where

import           Data.ByteString (ByteString)
import           Snap.Snaplet.Heist
import           Snap.Snaplet
import qualified Heist.Interpreted as I
import qualified Data.Text as T
import qualified Database.Persist as P
import           Snap.Snaplet.Persistent
import Control.Monad
import Control.Monad.Trans
import Heist
import Snap.Core
import qualified  Text.XmlHtml as X
import Control.Lens

import Text.Blaze.Html5 (Html, (!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import Text.Blaze.Renderer.XmlHtml
------------------------------------------------------------------------------
import Application
import Database

routes :: [(ByteString, Handler App App ())]
routes = [ ("/posts", Post.postsHandler)
         ]

postsHandler :: Handler App App ()
postsHandler = render "posts/index"

postSplice :: P.Entity Post -> I.Splice (Handler App App)
postSplice (P.Entity postID post) = I.runChildrenWithText [("postContent", postContent post)]

allPosts :: I.Splice (Handler App App)
allPosts = do
  posts <- lift results
  I.mapSplices postSplice posts
  where
    results :: Handler App App [P.Entity Post]
    results = with db $ runPersist $ P.selectList [] []

newPostForm ::  I.Splice AppHandler
newPostForm = return . renderHtmlNodes $
    H.form $ do
      H.label "Post Content:"
      H.input ! A.name "content"


