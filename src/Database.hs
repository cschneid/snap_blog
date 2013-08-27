{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE EmptyDataDecls    #-}
{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE GADTs             #-}
{-# LANGUAGE OverloadedStrings #-}


module Database where

import           Database.Persist.TH
import           Data.Text
import           Data.Time.Clock

------------------------------------------------------------------------------

------------------------------------------------------------------------------

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
SnapAuthUser
  login Text 
  email Text default=''
  password Text
  activatedAt UTCTime Maybe default=now()
  suspendedAt UTCTime Maybe default=now()
  rememberToken Text Maybe
  loginCount Int
  failedLoginCount Int
  lockedOutUntil UTCTime Maybe default=now()
  currentLoginAt UTCTime Maybe default=now()
  lastLoginAt UTCTime Maybe default=now()
  currentIp Text Maybe
  lastIp Text Maybe 
  createdAt UTCTime default=now()
  updatedAt UTCTime default=now()
  resetToken Text Maybe
  resetRequestedAt UTCTime Maybe
  roles String
  meta String
  deriving Show

Post
  content Text
|]


