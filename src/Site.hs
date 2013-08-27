{-# LANGUAGE OverloadedStrings #-}

------------------------------------------------------------------------------
-- | This module is where all the routes and handlers are defined for your
-- site. The 'app' function is the initializer that combines everything
-- together and is exported by this module.
module Site
  ( app
  ) where

------------------------------------------------------------------------------
import           Control.Lens (view)
import           Data.ByteString (ByteString)
import           Database.Persist.Sql
import           Snap.Snaplet
import           Snap.Snaplet.Auth
import           Snap.Snaplet.Auth.Backends.Persistent
import           Snap.Snaplet.Heist
import           Snap.Snaplet.Persistent
import           Snap.Snaplet.Session.Backends.CookieSession
import           Snap.Util.FileServe
------------------------------------------------------------------------------
import           Application
import qualified Auth
import qualified Post
import qualified Database

------------------------------------------------------------------------------
-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes = Auth.routes ++
         Post.routes ++
         [("",          serveDirectory "static")]


------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet ""     heist $ heistInit "templates"
    s <- nestSnaplet "sess" sess  $ initCookieSessionManager "site_key.txt" "sess" (Just 3600)
    d <- nestSnaplet "db"   db    $ initPersist (runMigrationUnsafe Database.migrateAll)
    a <- nestSnaplet "auth" auth  $ initPersistAuthManager sess (persistPool $ view snapletValue d)

    addRoutes routes
    addAuthSplices h auth

    return $ App h s a d

