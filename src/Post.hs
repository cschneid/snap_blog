{-# LANGUAGE OverloadedStrings #-}

module Post where

import           Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import           Snap.Snaplet.Heist
import           Snap.Snaplet
import qualified Heist.Interpreted as I
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
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
routes = [ ("/posts", method GET Post.postsHandler)
         , ("/posts", method POST Post.createPostHandler)]

postsHandler :: AppHandler ()
postsHandler = render "posts/index"

createPostHandler :: AppHandler ()
createPostHandler = do
  (Just content) <- getPostParam "content"
  with db $ runPersist $ P.insert (Post $ convertedContent content)
  render "posts/index"
  where
    convertedContent = TE.decodeUtf8

postSplice :: P.Entity Post -> I.Splice (AppHandler)
postSplice (P.Entity postID post) = I.runChildrenWithText [("postContent", postContent post)]

allPosts :: I.Splice (AppHandler)
allPosts = do
  posts <- lift results
  I.mapSplices postSplice posts
  where
    results :: Handler App App [P.Entity Post]
    results = with db $ runPersist $ P.selectList [] []

