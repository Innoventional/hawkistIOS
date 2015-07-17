//
//  MyItemsViewController.h
//  Hawkist
//
//  Created by Anton on 14.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWBaseViewController.h"
#import "MyItemCellView.h"

@interface MyItemsViewController : HWBaseViewController <UICollectionViewDataSource,UICollectionViewDelegate,MyItemCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
