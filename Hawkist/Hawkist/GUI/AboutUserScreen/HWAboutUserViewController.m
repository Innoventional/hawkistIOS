//
//  HWAboutUserViewController.m
//  Hawkist
//
//  Created by User on 08.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWAboutUserViewController.h"
#import "NetworkManager.h"
#import "HWUser.h"



@interface HWAboutUserViewController () <NavigationViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) HWUser *user;
@property (weak, nonatomic) IBOutlet NavigationVIew *navigationView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation HWAboutUserViewController


- (instancetype) init
{
    self = [super initWithNibName:@"HWAboutUserView" bundle:nil];
    if(self)
    {
        
    }
    return  self;
}

-(instancetype)initWithUserId:(NSString*)userId
{
    self = [self init];
    [[NetworkManager shared] getUserProfileWithUserID:userId
                                         successBlock:^(HWUser *user) {
                                             
                                             self.user = user;
                                             [self updateUser];
    
                                         } failureBlock:^(NSError *error) {
    
                                             [self showAlertWithTitle:error.domain Message:error.localizedDescription];
                                         }];
    if(self)
    {
        
    }
    
    return self;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationView.delegate = self;
    self.navigationView.title.text = [NSString stringWithFormat:@"About user"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateUser
{
    NSURL *urlAvatar = [NSURL URLWithString:self.user.avatar];
    [self.backgroundImage setImageWithURL:urlAvatar placeholderImage:[UIImage imageNamed:@"noPhoto"]];
    self.userAvatar.image = self.backgroundImage.image;
    
    self.username.text = self.user.username;
    
    self.userAvatar.layer.cornerRadius = 35;
    self.userAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userAvatar.layer.borderWidth = 2;
    self.userAvatar.clipsToBounds = YES;
    self.navigationView.title.text = [NSString stringWithFormat:@"About %@",self.user.username];
    
    if(![self.user.about_me isEqualToString:@""])
    {
        self.textView.text = self.user.about_me;
    }
    else
    {
        self.textView.text = @"Information about me is not filled!";
    }
    
    if(self.user.city && ![self.user.city isEqualToString:@""])
    {
        self.locationLabel.text =  [NSString stringWithFormat:@"Location: %@, United Kingdom  ", self.user.city];
    }
    else
    {
        self.locationLabel.text = @"Location:";
    }
    
}

#pragma mark -NavigationViewDelegate

-(void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:NO];
}


-(void) rightButtonClick
{

}

@end
