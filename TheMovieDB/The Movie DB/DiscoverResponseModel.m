//
//  DiscoverResponseModel.m
//  The Movie DB
//
//  Created by Ricardo Sarto on 10/4/16.
//  Copyright © 2016 Ricardo Sarto Costa. All rights reserved.
//

#import "DiscoverResponseModel.h"
#import "GenreRealm.h"

@implementation DiscoverResponseModel

+(NSDictionary*) JSONKeyPathsByPropertyKey {
    return @{
             @"id":             @"id",
             @"title":          @"title",
             @"poster":         @"poster_path",
             @"releaseDate":    @"release_date",
             @"genres":         @"genre_ids",
             @"overview":       @"overview"
             };
}

@end
