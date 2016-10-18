//
//  ConfigRealm.m
//  The Movie DB
//
//  Created by Ricardo Sarto on 10/17/16.
//  Copyright © 2016 Ricardo Sarto Costa. All rights reserved.
//

#import "ConfigRealm.h"

@implementation ConfigRealm

+ (NSString *)primaryKey
{
    return @"uuid";
}

+ (NSDictionary *)defaultPropertyValues
{
    // default value for pk to be able to update objects
    return @{@"uuid": [[NSUUID UUID] UUIDString]};
}

@end
