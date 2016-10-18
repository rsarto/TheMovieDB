//
//  MoviesVC.m
//  The Movie DB
//
//  Created by Ricardo Sarto on 10/3/16.
//  Copyright © 2016 Ricardo Sarto Costa. All rights reserved.
//

#import "MoviesVC.h"
#import "MovieCell.h"
#import "GenreRealm.h"
#import "MovieDetailVC.h"
#import "ConfigRealm.h"
#import "Helper.h"

@interface MoviesVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property BOOL requestError;
@end

@implementation MoviesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // delegates
    self.tableView.delegate     = self;
    self.tableView.dataSource   = self;
    self.searchBar.delegate     = self;
    
    self.requestError = NO;

    RLMRealm *realm = [RLMRealm defaultRealm];
    ConfigRealm *config = [ConfigRealm allObjects].firstObject;
    
    if (config && [Helper isDateGreaterNoHour:[NSDate date] than:config.lastLoadMovies]) {
        
        [realm beginWriteTransaction];
        config.lastLoadMovies = [NSDate date];
        [realm addOrUpdateObject:config];
        [realm commitWriteTransaction];

        // Load initial 50 movies
        self.movieDBClient          = [[MovieDBClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];

        self.movieDBClient.delegate = self;
        [self.movieDBClient loadMovies:1];
        
    } else {
        // already loaded today...
        [self loadMovies];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // dont using self.title because used topItem on Detail to do not have a title on < (back) button
    self.navigationController.navigationBar.topItem.title = @"The Movie DB";

    //self.title = @"The Movie DB";
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Table Delegates
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.arrayMovies.count == 0) {
        
        //create a lable size to fit the Table View
        UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                        self.tableView.bounds.size.width,
                                                                        self.tableView.bounds.size.height)];
        
        //
        // Empty table message
        //
        if (self.requestError) {
            messageLbl.text          = @"Server not available...";
        } else if (self.searchBar.text.length == 0) {
            messageLbl.text          = @"Loading Movies...";
        } else {
            messageLbl.text          = @"No Movies found...";
        }
        messageLbl.textAlignment = NSTextAlignmentCenter;
        [messageLbl sizeToFit];
        
        messageLbl.textColor = [UIColor colorWithRed:129.0f/255.0f
                                               green:125.0f/255.0f
                                                blue:116.0f/255.0f
                                               alpha:1.0f];
        
        messageLbl.lineBreakMode = NSLineBreakByWordWrapping;
        messageLbl.numberOfLines = 1;
        
        messageLbl.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:14];
        
        // set back to label view
        self.tableView.backgroundView = messageLbl;
        // none 
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        return 0;

    }
    
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arrayMovies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    if (cell == nil) {
        cell = [[MovieCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"MovieCell"];
    }
    
    MovieRealm* movieRealm = self.arrayMovies[indexPath.row];
    
    // Load cell values
    cell.labelMovieName.text    = movieRealm.title;
    cell.labelReleaseDate.text  = [NSString stringWithFormat:@"Release Date: %@", movieRealm.releaseDate];

    // genres
    NSString* genres = @"";
    if ([movieRealm.genres count] > 0) {
        
        for (GenreRealm* genreRealm in movieRealm.genres) {
      
            if (genres.length > 0)
                genres = [NSString stringWithFormat:@"%@, %@", genres, genreRealm.name];
            else
                genres = [NSString stringWithFormat:@"%@", genreRealm.name];
        }
    }
    cell.labelGenres.text = genres;
    	
    if (movieRealm.poster.length > 0) {
        
        // Small poster already recovered and stored on Realm ?
        if (movieRealm.smallPoster.length > 0) {
            
            UIImage *image = [UIImage imageWithData:movieRealm.smallPoster];

            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Loading small image from DB (%@)", movieRealm.title);

                    MovieCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    
                    // cell still visible?
                    if (updateCell)
                        updateCell.imagePoster.image = image;
                });
            }
            
        } else {
            
            // Small Poster still not recovered. Lest recover it asynchronously and store it on Realm for future access

            cell.imagePoster.image = [UIImage imageNamed:@"LoadingPoster"];

            NSString* urlSmallPoster = [NSString stringWithFormat:@"%@%@", kBaseURLSmallPoster, movieRealm.poster];

            NSURL *url = [NSURL URLWithString:urlSmallPoster];
            
            NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (data) {
                    UIImage *image = [UIImage imageWithData:data];
                    if (image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"Loading small image from URL (%@)", movieRealm.title);

                            MovieCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];

                            // cell still visible?
                            if (updateCell)
                                updateCell.imagePoster.image = image;
                            
                            // Store it on Realm
                            RLMRealm* realm = [RLMRealm defaultRealm];
                            [realm beginWriteTransaction];

                            // JPG Image
                            NSData* data = UIImageJPEGRepresentation(image, 1.0);

                            movieRealm.smallPoster = data;
                            [realm addOrUpdateObject:movieRealm];
                            [realm commitWriteTransaction];
                        });
                    }
                }
            }];
            [task resume];
        }
    } else {
        cell.imagePoster.image = [UIImage imageNamed:@"NoPoster"];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
# pragma mark - Searchbar delegates
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

//
// textDidChange
//
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self query];
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = @"";

    [self.view endEditing:YES];
    
    [self query];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];

    [self query];
}

- (void) query {
    if (self.searchBar.text.length == 0) {
        self.arrayMovies = [[MovieRealm allObjects]
                            sortedResultsUsingDescriptors:@[
                                                            [RLMSortDescriptor sortDescriptorWithProperty:@"releaseDate"
                                                                                                ascending:YES],
                                                            [RLMSortDescriptor sortDescriptorWithProperty:@"title"
                                                                                                ascending:YES]
                                                            ]];
    } else {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"title CONTAINS[ca] %@", self.searchBar.text];

        self.arrayMovies = [[MovieRealm objectsWithPredicate:pred]
                            sortedResultsUsingDescriptors:@[
                                                            [RLMSortDescriptor sortDescriptorWithProperty:@"releaseDate"
                                                                                                ascending:YES],
                                                            [RLMSortDescriptor sortDescriptorWithProperty:@"title"
                                                                                                ascending:YES]
                                                            ]];
    }

    [self.tableView reloadData];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark DBClientDeleage
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) didFinish:(NSError *)error {

    if (!error) {
        [self loadMovies];

        [self.tableView reloadData];
    } else {
        self.requestError = YES;
        [self.tableView reloadData];

        NSLog(@"%@", error);
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark privates
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) loadMovies {
    self.arrayMovies = [[MovieRealm allObjects]
                        sortedResultsUsingDescriptors:@[
                                                        [RLMSortDescriptor sortDescriptorWithProperty:@"releaseDate"
                                                                                            ascending:YES],
                                                        [RLMSortDescriptor sortDescriptorWithProperty:@"title"
                                                                                            ascending:YES]
                                                        ]];
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma IBAction
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)refreshTapped:(id)sender {
    [self.movieDBClient loadMovies:1];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma Segue
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"segueMovieDetail"])
    {
        // Get reference to the destination view controller
        MovieDetailVC *movieDetailVC = [segue destinationViewController];
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        
        movieDetailVC.movieRealm = self.arrayMovies[path.row];
    }
}

@end
