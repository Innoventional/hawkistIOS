//
//  FeedScreenCollectionViewCell.h
//  FeedScreen
//
//  Created by Evgen Bootcov on 25.06.15.
//  Copyright (c) 2015 Evgen Bootcov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedScreenCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatarImage;

@property (strong, nonatomic) IBOutlet UILabel *userNameLable;

@property (strong, nonatomic) IBOutlet UILabel *timeLable;

@property (strong, nonatomic) IBOutlet UIImageView *itemImage;
@property (strong, nonatomic) IBOutlet UITextField *skidkaTextfield;

@property (strong, nonatomic) IBOutlet UILabel *sellItemLabel;

@property (strong, nonatomic) IBOutlet UILabel *starsLable;

@property (strong, nonatomic) IBOutlet UILabel *opinionLable;

@property (strong, nonatomic) IBOutlet UIImageView *starImage;

@property (strong, nonatomic) IBOutlet UIImageView *speechImage;

@property (strong, nonatomic) IBOutlet UILabel *consoleNameLable;

@property (strong, nonatomic) IBOutlet UILabel *oldPriceLable;
@property (strong, nonatomic) IBOutlet UILabel *currentPriceLable;







@end
