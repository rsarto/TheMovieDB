//
//  MovieCell.h
//  The Movie DB
//
//  Created by Ricardo Sarto on 10/3/16.
//  Copyright © 2016 Ricardo Sarto Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagePoster;
@property (weak, nonatomic) IBOutlet UILabel *labelMovieName;
@property (weak, nonatomic) IBOutlet UILabel *labelGenres;
@property (weak, nonatomic) IBOutlet UILabel *labelReleaseDate;

@end
