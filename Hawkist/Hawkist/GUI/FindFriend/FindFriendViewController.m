//
//  FindFriendViewController.m
//  Hawkist
//
//  Created by Anton on 03.09.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "FindFriendViewController.h"
#import "SocialManager.h"
#import "NetworkManager.h"


@interface FindFriendViewController ()

@end

@implementation FindFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[SocialManager shared]loginFacebookSuccess:^(NSDictionary *response) {
        
        [[NetworkManager shared]getFriends:[response objectForKey:SocialToken]                                     successBlock:^(NSArray *users) {
            
            
        } failureBlock:^(NSError *error) {
            
            
        }];
        
        
        
    } failure:^(NSError *error) {
        
        
    }];

    
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
