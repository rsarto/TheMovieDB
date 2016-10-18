//
//  MovieRealm.m
//  The Movie DB
//
//  Created by Ricardo Sarto on 10/4/16.
//  Copyright © 2016 Ricardo Sarto Costa. All rights reserved.
//

#import "MovieRealm.h"
#import "Constants.h"

@implementation MovieRealm

- (id)initWithMantleModel:(DiscoverResponseModel*) discoverResponseModel;
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    // Mantle -> Realm
    self.id             = discoverResponseModel.id;
    self.title          = discoverResponseModel.title;
    self.poster         = discoverResponseModel.poster;
    self.releaseDate    = discoverResponseModel.releaseDate;
    self.overview       = discoverResponseModel.overview;

    for (NSNumber* genreID in discoverResponseModel.genres) {
        
        GenreRealm *genreRealm = [[GenreRealm objectsWhere:[NSString stringWithFormat:@"id == %ld", (long)[genreID integerValue]]] firstObject];
        
        if (genreRealm) {
            [self.genres addObject:genreRealm];
        }
    }

    return self;
}

+ (NSString *)primaryKey
{
    return @"id";
}

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
