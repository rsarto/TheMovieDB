//
//  GenreRealm.h
//  The Movie DB
//
//  Created by Ricardo Sarto on 10/4/16.
//  Copyright © 2016 Ricardo Sarto Costa. All rights reserved.
//

#import <Realm/Realm.h>
#import "GenreResponseModel.h"

@interface GenreRealm : RLMObject

@property NSNumber<RLMInt>* id;
@property NSString* name;

- (id) initWithMantleModel:(GenreResponseModel*) genreResponseModel;

@end

// This protocol enables typed collections
RLM_ARRAY_TYPE(GenreRealm)
