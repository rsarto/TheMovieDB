//
//  AboutVC.m
//  The Movie DB
//
//  Created by Ricardo Sarto on 10/5/16.
//  Copyright © 2016 Ricardo Sarto Costa. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()

@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // white back button
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    // use TopItem to not have a title on < (back) button
    self.navigationController.navigationBar.topItem.title = @" ";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
