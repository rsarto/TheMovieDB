//
//  MovieDBClient.h
//  The Movie DB
//
//  Created by Ricardo Sarto on 10/4/16.
//  Copyright © 2016 Ricardo Sarto Costa. All rights reserved.
//

#import <Overcoat/Overcoat.h>
#import "Constants.h"

@protocol DBClientDelegate <NSObject>

@optional
-(void) didFinish:(NSError*) error;

@end;

@interface MovieDBClient : OVCHTTPSessionManager

-(void) loadGenres;
-(void) loadMovies:(NSInteger) page;
//-(void) searchMovies;

@property (nonatomic, weak) id <DBClientDelegate> delegate;

@end
