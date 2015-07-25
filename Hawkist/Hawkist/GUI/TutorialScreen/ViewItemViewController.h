//
//  ViewItemViewController.h
//  Hawkist
//
//  Created by Evgen Bootcov on 02.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extensions.h"
#import "HWBaseViewController.h"
#import "NavigationVIew.h"
#import "HWItem.h"
#import "StarRatingControl.h"

@interface ViewItemViewController : HWBaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate,StarRatingDelegate,NavigationViewDelegate>

// custom init
- (instancetype) initWithItem: (HWItem*) item;




@property (weak, nonatomic) IBOutlet NavigationVIew *navigationView;


@property (nonatomic,strong) NSMutableArray *items;

@property (weak) IBOutlet StarRatingControl *starRatingControl;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *itemUser;
@property (weak, nonatomic) IBOutlet UISegmentedControl *userItemsSegmentControl;
@property (weak, nonatomic) IBOutlet UIImageView *bigImage;
- (IBAction)imageTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *smallImage1;
@property (weak, nonatomic) IBOutlet UIImageView *smallImage2;
@property (weak, nonatomic) IBOutlet UIImageView *smallImage3;
@property (weak, nonatomic) IBOutlet UIImageView *smallImage4;

@property (weak, nonatomic) IBOutlet UILabel *nameOoStuff;

@property (weak, nonatomic) IBOutlet UILabel *sellerPrice;

@property (weak, nonatomic) IBOutlet UILabel *oldPrice;
- (IBAction)buyButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *sellerName;
@property (weak, nonatomic) IBOutlet UIImageView *sellerAvatar;
@property (weak, nonatomic) IBOutlet UILabel *reviews;
- (IBAction)askButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *descriptionOfItem;
@property (weak, nonatomic) IBOutlet UILabel *hashTag3;
@property (weak, nonatomic) IBOutlet UILabel *hashTag2;
@property (weak, nonatomic) IBOutlet UILabel *hashTag1;
@property (weak, nonatomic) IBOutlet UILabel *added;
@property (weak, nonatomic) IBOutlet UILabel *platform;
@property (weak, nonatomic) IBOutlet UILabel *condition;

@property (weak, nonatomic) IBOutlet UILabel *colour;
@property (weak, nonatomic) IBOutlet UILabel *delivery;
@property (weak, nonatomic) IBOutlet UILabel *counts;
@property (weak, nonatomic) IBOutlet UILabel *comments;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *discount;
@property (weak, nonatomic) IBOutlet UIButton *buyThisItem;

@end
