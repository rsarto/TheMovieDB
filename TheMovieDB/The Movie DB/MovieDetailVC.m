//
//  MovieDetailVC.m
//  The Movie DB
//
//  Created by Ricardo Sarto on 10/4/16.
//  Copyright © 2016 Ricardo Sarto Costa. All rights reserved.
//

#import "MovieDetailVC.h"
#import "Constants.h"

@interface MovieDetailVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imagePoster;

@property (weak, nonatomic) IBOutlet UILabel *labelMovieName;
@property (weak, nonatomic) IBOutlet UILabel *labelGenres;
@property (weak, nonatomic) IBOutlet UILabel *labelReleaseDate;
@property (weak, nonatomic) IBOutlet UITextView *textOverview;

@end

@implementation MovieDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.movieRealm) {
        self.labelMovieName.text    = self.movieRealm.title;
        self.labelReleaseDate.text  = [NSString stringWithFormat:@"Release Date %@", self.movieRealm.releaseDate];

        // genres
        NSString* genres = @"";
        if ([self.movieRealm.genres count] > 0) {
            
            for (GenreRealm* genreRealm in self.movieRealm.genres) {
                
                if (genres.length > 0)
                    genres = [NSString stringWithFormat:@"%@, %@", genres, genreRealm.name];
                else
                    genres = [NSString stringWithFormat:@"%@", genreRealm.name];
            }
        }

        self.labelGenres.text   = genres;
        
        if (self.movieRealm.overview.length > 0) {
            self.textOverview.text  = self.movieRealm.overview;
        } else {
            self.textOverview.text  = @"No overview available...";
        }

        if (self.movieRealm.poster.length > 0) {
            
            if (self.movieRealm.bigPoster.length > 0) {
                
                UIImage *image = [UIImage imageWithData:self.movieRealm.bigPoster];
                
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"Loading big image from DB (%@)", self.movieRealm.title);
                        self.imagePoster.image = image;
                    });
                }
                
                
            } else {
                
                self.imagePoster.image = [UIImage imageNamed:@"LoadingPoster"];

                NSString* urlBigPoster = [NSString stringWithFormat:@"%@%@", kBaseURLBigPoster, self.movieRealm.poster];
                
                NSURL *url = [NSURL URLWithString:urlBigPoster];
                
                NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (data) {
                        UIImage *image = [UIImage imageWithData:data];
                        if (image) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"Loading big image from URL (%@)", self.movieRealm.title);

                                if (self.imagePoster) {
                                    self.imagePoster.image = image;
                                }
                                
                                RLMRealm* realm = [RLMRealm defaultRealm];
                                [realm beginWriteTransaction];
                                
                                // JPG Image - save for next time
                                NSData* data = UIImageJPEGRepresentation(image, 1.0);
                                
                                self.movieRealm.bigPoster = data;

                                [realm addOrUpdateObject:self.movieRealm];
                                [realm commitWriteTransaction];
                            });
                        }
                    }
                }];
                [task resume];
            }
        } else {
            self.imagePoster.image = [UIImage imageNamed:@"NoPoster"];
        }
    }

    // white back button
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.topItem.title = @" ";

//    self.title = @" ";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewDidLayoutSubviews {
    [self.textOverview scrollRangeToVisible:NSMakeRange(0, 1)];
}

@end
