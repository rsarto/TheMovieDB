//
//  MovieDBClient.m
//  The Movie DB
//
//  Created by Ricardo Sarto on 10/4/16.
//  Copyright © 2016 Ricardo Sarto Costa. All rights reserved.
//


#import "Realm/Realm.h"

#import "Constants.h"
#import "GenreResponseModel.h"
#import "GenreRealm.h"

#import "DiscoverResponseModel.h"
#import "MovieRealm.h"

#import "MovieDBClient.h"

@implementation MovieDBClient

+ (NSDictionary *)modelClassesByResourcePath {
    return @{
             @"Genres":     [GenreResponseModel class],
             @"Discover":   [DiscoverResponseModel class]
            };
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    
    return self;
}

#pragma mark Public Methods

//
// loadGenres
//
-(void) loadGenres {
    
    NSDictionary *parameters = @{
                                 @"api_key":    kApiKey,
                                 @"language":   @"en-US"
                                 };

    [self GET:kGenresService parameters:parameters completion:^(OVCResponse *response, NSError *error) {
        if (error) {
            if (self.delegate) {
                [self.delegate didFinish:error];
            }
        } else {
            NSError* error = nil;

            NSArray* genres = [MTLJSONAdapter modelsOfClass:[GenreResponseModel class]
                                              fromJSONArray:response.rawResult[@"genres"]
                                                      error:&error];
            if (!error) {
                if ([genres count] > 0)
                {
                    RLMRealm* realm = [RLMRealm defaultRealm];
                    
                    [realm beginWriteTransaction];
                    
                    for (GenreResponseModel* genre in genres) {
                        GenreRealm* genreRealm = [[GenreRealm alloc] initWithMantleModel:genre];
                        
                        [realm addObject:genreRealm];
                    }
                    
                    [realm commitWriteTransaction];

                    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinish:)]) {
                        [self.delegate didFinish:nil];
                    }
                }
            } else {
                if (self.delegate && [self.delegate respondsToSelector:@selector(didFinish:)]) {
                    [self.delegate didFinish:error];
                }
            }
        }
    }];
}

//
// loadMovies
//
-(void) loadMovies:(NSInteger) page {

    //
    // delete all movies
    //
    RLMRealm* realm = [RLMRealm defaultRealm];

    if (page == 1) {
        [realm beginWriteTransaction];
        [realm deleteObjects:[MovieRealm allObjects]];
        [realm commitWriteTransaction];
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];

    NSDate* date = [[NSDate date] dateByAddingTimeInterval:60*60*24];
    NSString *tomorrow = [format stringFromDate:date];

    NSDictionary *parameters = @{
                                 @"api_key":                    kApiKey,
                                 @"language":                   @"en-US",
                                 @"sort_by":                    @"primary_release_date.asc",
                                 @"include_adult":              @"FALSE",
                                 @"primary_release_date.gte":   tomorrow,
                                 @"page":                       [NSString stringWithFormat:@"%ld", (long)page]
                                };
    
    [self GET:kDiscoverService parameters:parameters completion:^(OVCResponse *response, NSError *error) {
        if (error) {
            if ([self.delegate respondsToSelector:@selector(didFinish:)]) {
                [self.delegate didFinish:error];
            }
        } else {
            NSError* error = nil;
            
            NSArray* allDiscovered = [MTLJSONAdapter modelsOfClass:[DiscoverResponseModel class]
                                              fromJSONArray:response.rawResult[@"results"]
                                                      error:&error];
            
            if (!error) {
                if ([allDiscovered count] > 0)
                {
                    RLMRealm* realm = [RLMRealm defaultRealm];
                    NSInteger count = 0;
                    
                    [realm beginWriteTransaction];

                    for (DiscoverResponseModel* discovered in allDiscovered) {
                        
                        MovieRealm* movieRealm = [[MovieRealm objectsWhere:[NSString stringWithFormat:@"id == %ld", (long)[discovered.id integerValue]]] firstObject];

                        if (!movieRealm) {
                            movieRealm = [[MovieRealm alloc] initWithMantleModel:discovered];

                            [realm addObject:movieRealm];
                        }
                        
                        count = [[MovieRealm allObjects] count];
                        if (count == kMaxMovies) {
                            break;
                        }
                    }
                    
                    [realm commitWriteTransaction];
                    
                    // use many pages as needed for 50
                    if (count < kMaxMovies) {
                        [self loadMovies:page+1];
                    } else {
                        if (self.delegate && [self.delegate respondsToSelector:@selector(didFinish:)]) {
                            [self.delegate didFinish:nil];
                        }
                    }
                }
            } else {
                if (self.delegate && [self.delegate respondsToSelector:@selector(didFinish:)]) {
                    [self.delegate didFinish:error];
                }
            }
        }
    }];
}

@end
