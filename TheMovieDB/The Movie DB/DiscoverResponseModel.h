//
//  DiscoverResponseModel.h
//  The Movie DB
//
//  Created by Ricardo Sarto on 10/4/16.
//  Copyright © 2016 Ricardo Sarto Costa. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface DiscoverResponseModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber* id;
@property (nonatomic, copy, readonly) NSString* title;
@property (nonatomic, copy, readonly) NSString* poster;
@property (nonatomic, strong, readonly) NSString* releaseDate;
@property (nonatomic, strong, readonly) NSString* overview;
@property (nonatomic, strong, readonly) NSArray* genres;

@end
