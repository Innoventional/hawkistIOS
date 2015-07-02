//
//  FeedScreenViewController.h
//  FeedScreen
//
//  Created by Evgen Bootcov on 25.06.15.
//  Copyright (c) 2015 Evgen Bootcov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedScreenCollectionViewCell.h"

@interface FeedScreenViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>


@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;



@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UITextField *searchField;

@end
