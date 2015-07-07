//
//  ViewItemViewController.h
//  Hawkist
//
//  Created by Evgen Bootcov on 02.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extensions.h"

@interface ViewItemViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *itemUser;
@property (strong, nonatomic) IBOutlet UISegmentedControl *userItemsSegmentControl;
@property (strong, nonatomic) IBOutlet UIImageView *bigImage;
- (IBAction)imageTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *smallImage1;
@property (strong, nonatomic) IBOutlet UIImageView *smallImage2;
@property (strong, nonatomic) IBOutlet UIImageView *smallImage3;
@property (strong, nonatomic) IBOutlet UIImageView *smallImage4;

@property (nonatomic,strong) NSArray *picArray;

@property (strong, nonatomic) IBOutlet UILabel *nameOoStuff;

@property (strong, nonatomic) IBOutlet UILabel *sellerPrice;

@property (strong, nonatomic) IBOutlet UILabel *oldPrice;
- (IBAction)buyButton:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *sellerName;
@property (strong, nonatomic) IBOutlet UIImageView *sellerAvatar;
@property (strong, nonatomic) IBOutlet UILabel *reviews;
- (IBAction)askButton:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *descriptionOfItem;
@property (strong, nonatomic) IBOutlet UILabel *hashTag3;
@property (strong, nonatomic) IBOutlet UILabel *hashTag2;
@property (strong, nonatomic) IBOutlet UILabel *hashTag1;
@property (strong, nonatomic) IBOutlet UILabel *added;
@property (strong, nonatomic) IBOutlet UILabel *platform;
@property (strong, nonatomic) IBOutlet UILabel *condition;

@property (strong, nonatomic) IBOutlet UILabel *colour;
@property (strong, nonatomic) IBOutlet UILabel *delivery;
@property (strong, nonatomic) IBOutlet UILabel *counts;
@property (strong, nonatomic) IBOutlet UILabel *comments;

@end
