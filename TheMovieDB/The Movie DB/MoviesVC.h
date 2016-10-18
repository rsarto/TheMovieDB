//
//  MoviesVC.h
//  The Movie DB
//
//  Created by Ricardo Sarto on 10/3/16.
//  Copyright © 2016 Ricardo Sarto Costa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieDBClient.h"
#import "MovieRealm.h"

@interface MoviesVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, DBClientDelegate>

@property (nonatomic, strong) MovieDBClient* movieDBClient;
@property (nonatomic, strong) RLMResults<MovieRealm*> *arrayMovies;
@property (nonatomic, strong) RLMNotificationToken *notification;

@end
