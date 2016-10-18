//
//  MovieRealm.h
//  The Movie DB
//
//  Created by Ricardo Sarto on 10/4/16.
//  Copyright © 2016 Ricardo Sarto Costa. All rights reserved.
//

#import <Realm/Realm.h>
#import <Realm/RLMObject.h>
#import "DiscoverResponseModel.h"
#import "GenreRealm.h"

@interface MovieRealm : RLMObject

@property NSNumber<RLMInt>* id;
@property NSString* title;
@property NSString* poster;
@property NSString* releaseDate;
@property NSString* overview;
@property NSData* smallPoster;
@property NSData* bigPoster;
@property RLMArray<GenreRealm *><GenreRealm> *genres;

- (id) initWithMantleModel:(DiscoverResponseModel*) discoverResponseModel;

@end

// This protocol enables typed collections
RLM_ARRAY_TYPE(MovieRealm)
