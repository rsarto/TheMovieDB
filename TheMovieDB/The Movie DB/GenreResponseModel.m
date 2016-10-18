//
//  GenreResponseModel.m
//  The Movie DB
//
//  Created by Ricardo Sarto on 10/4/16.
//  Copyright © 2016 Ricardo Sarto Costa. All rights reserved.
//

#import "GenreResponseModel.h"

@implementation GenreResponseModel

+(NSDictionary*) JSONKeyPathsByPropertyKey {
    return @{
             @"id":    @"id",
             @"name":  @"name"
             };
}

@end
