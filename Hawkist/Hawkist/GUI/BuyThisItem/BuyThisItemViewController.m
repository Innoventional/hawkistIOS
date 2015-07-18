//
//  BuyThisItemViewController.m
//  Hawkist
//
//  Created by Anton on 17.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "BuyThisItemViewController.h"

@interface BuyThisItemViewController ()
@property (nonatomic,strong) HWItem* item;
@end

@implementation BuyThisItemViewController
@synthesize navigationView;

- (instancetype) initWithItem: (HWItem*) item
{
    
    {
        UIView* v = [[[NSBundle mainBundle]loadNibNamed:@"BuyThisItem" owner:self options:nil]firstObject];
        
        v.frame = self.view.frame;
        
        [self.view addSubview:v];
        
        self.item = item;
        
        [self updateItem];
        
        navigationView.delegate = self;
        
        [navigationView.leftButtonOutlet setImage:[UIImage imageNamed:@"acdet_back"] forState:UIControlStateNormal];
        [navigationView.leftButtonOutlet setTitle:@"" forState:UIControlStateNormal];
        [navigationView.rightButtonOutlet setTitle:@"" forState:UIControlStateNormal];
        navigationView.title.text = @"Buy This Item";
        [navigationView.title setTextColor:[UIColor whiteColor]];
        navigationView.rightButtonOutlet.enabled = NO;
        
        self.bigImage.layer.cornerRadius = 5.0f;
        self.bigImage.layer.masksToBounds = YES;
        self.buyButton.layer.cornerRadius = 5.0f;
        self.buyButton.layer.masksToBounds = YES;
        self.sendButton.layer.cornerRadius = 5.0f;
        self.sendButton.layer.masksToBounds = YES;
        
    }
    return self;
}

- (void) updateItem
{
    
    self.itemTitle.text = self.item.title;
    
//    self..text = self.item.selling_price;
//    self.oldPrice.text = self.item.retail_price;
//    self.descriptionOfItem.text = self.item.item_description;
//    self.added.text = [self.item stringItemCreationDate];
//    
//    
//    HWTag* itemPlatform = [HWTag getPlatformById:self.item.platform from:[AppEngine shared].tags];
//    
//    self.platform.text =  itemPlatform.name;
//    
//    HWCategory* itemCategory = [HWTag getCategoryById:self.item.category from:itemPlatform.categories];
//    
//    self.category.text = itemCategory.name;
//    
//    
//    
//    HWSubCategories* itemSubCategory = [HWTag getSubCategoryById:self.item.subcategory from: itemCategory.subcategories];
//    
//    HWCondition* itemCondition = [HWTag getConditionById:self.item.condition from: itemSubCategory.condition];
//    
//    self.condition.text = itemCondition.name;
//    
//    HWColor* itemColor = [HWTag getColorById:self.item.color from:itemSubCategory.color];
//    
//    self.colour.text = itemColor.name;
//    
//    self.delivery.text = self.item.shipping_price;
//    //self.discount.text = self.item.discount;
//    if (self.item.discount == nil || [self.item.discount isEqualToString: @"0"]) {
//        self.discount.text = @"1%";
//    } else {
//        self.discount.text = [NSString stringWithFormat:@"%@%%",self.item.discount];
//    }
//    [self.imagesArray removeAllObjects];
//    
//    if(self.item.photos)
//        [self.imagesArray addObjectsFromArray: self.item.photos];
//    if(self.item.barcode)
//        [self.imagesArray addObject: self.item.barcode];
//    
//    [self setImages];
//    
//    
//    
//    self.selectedItemsArray = self.item.similar_items;
//    
//    [self.collectionView reloadData];
//    [self reloadScrollViewSize];
    
}


- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated: YES];
}
@end
