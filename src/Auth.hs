{-# LANGUAGE OverloadedStrings #-}

module Auth where

import           Control.Applicative
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.Auth
import           Snap.Snaplet.Heist
import qualified Heist.Interpreted as I
import qualified Data.Text as T
import           Data.Maybe
import           Data.ByteString (ByteString)
------------------------------------------------------------------------------
import Application

------------------------------------------------------------------------------

routes :: [(ByteString, Handler App App ())]
routes = [ ("/login",    with auth Auth.handleLoginSubmit)
         , ("/logout",   with auth Auth.handleLogout)
         , ("/new_user", with auth Auth.handleNewUser)
         ]

-- | Render login form
handleLogin :: Maybe T.Text -> Handler App (AuthManager App) ()
handleLogin authError = heistLocal (I.bindSplices errs) $ render "login"
  where
    errs = [("loginError", I.textSplice c) | c <- maybeToList authError]


------------------------------------------------------------------------------
-- | Handle login submit
handleLoginSubmit :: Handler App (AuthManager App) ()
handleLoginSubmit =
    loginUser "login" "password" Nothing
              (\_ -> handleLogin err) (redirect "/")
  where
    err = Just "Unknown user or password"


------------------------------------------------------------------------------
-- | Logs out and redirects the user to the site index.
handleLogout :: Handler App (AuthManager App) ()
handleLogout = logout >> redirect "/"


------------------------------------------------------------------------------
-- | Handle new user form submit
handleNewUser :: Handler App (AuthManager App) ()
handleNewUser = method GET handleForm <|> method POST handleFormSubmit
  where
    handleForm = render "new_user"
    handleFormSubmit = registerUser "login" "password" >> redirect "/"


