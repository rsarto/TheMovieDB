//
//  GenreResponseModel.h
//  The Movie DB
//
//  Created by Ricardo Sarto on 10/4/16.
//  Copyright © 2016 Ricardo Sarto Costa. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GenreResponseModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber* id;
@property (nonatomic, copy, readonly) NSString* name;

@end
