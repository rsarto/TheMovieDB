//
//  ConfigRealm.h
//  The Movie DB
//
//  Created by Ricardo Sarto on 10/17/16.
//  Copyright © 2016 Ricardo Sarto Costa. All rights reserved.
//

#import <Realm/Realm.h>

@interface ConfigRealm : RLMObject

@property NSString* uuid;
@property NSDate* lastLoadGenres;
@property NSDate* lastLoadMovies;

// space for future configuration

@end
