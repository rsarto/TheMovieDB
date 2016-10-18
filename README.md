# TheMovieDB 1.1 #

Ricardo Sarto Costa

[@rsarto](https://twitter.com/rsarto)

## Overview ##

A simple Objective C project using Overcoat + Mantle + Realm.
It recovers 50 upcoming movie releases from "The Movie DB" (https://www.themoviedb.org) using Overcoat/Mantle storing the data on Realm, refreshing the database once a day - when it deletes all temp movies data and reloads it. The movies posters are recovered asynchronously the first time it is requested and also stored in Realm.

## Instructions ##
If you have a previously installed version on your simulator or device, please delete it as at this time Realm Migration is not implemented.

It uses The Movie DB API for the RESTful implementation. You can find more details about the services or how to generate an API Key here:
https://www.themoviedb.org/documentation/api

## Third-party ##
Overcoat 4.0.0
Mantle 2.0.7
Realm 2.0.7
