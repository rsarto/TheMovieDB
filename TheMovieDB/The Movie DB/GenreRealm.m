//
//  GenreRealm.m
//  The Movie DB
//
//  Created by Ricardo Sarto on 10/4/16.
//  Copyright © 2016 Ricardo Sarto Costa. All rights reserved.
//

#import "GenreRealm.h"

@implementation GenreRealm

- (id)initWithMantleModel:(GenreResponseModel*) genreResponseModel;
{
    self = [super init];
    
    if (!self) {
        return nil;
    }

    // Mantle -> Realm
    self.id     = genreResponseModel.id;
    self.name   = genreResponseModel.name;

    return self;
}

// Specify default values for properties

+ (NSDictionary *)defaultPropertyValues
{
    return @{};
}

// Specify properties to ignore (Realm won't persist these)

+ (NSArray *)ignoredProperties
{
    return @[];
}

@end
