//
//  ViewItemViewController.m
//  Hawkist
//
//  Created by Evgen Bootcov on 02.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "ViewItemViewController.h"
#import "FeedScreenCollectionViewCell.h"
#import "HWItem.h"
#import "UIImageView+AFNetworking.h"
#import "AppEngine.h"
@interface ViewItemViewController ()

@property (nonatomic, strong) HWItem* item;
@end

@implementation ViewItemViewController

- (instancetype) initWithItem: (HWItem*) item
    {
        self = [super initWithNibName: @"ViewItemViewController" bundle: nil];
        if(self)
        {
            self.item = item;
            [[NetworkManager shared] getItemById: self.item.id
            successBlock:^(HWItem *item) {
                self.item = item;
                [self updateItem];
            } failureBlock:^(NSError *error) {
                
            }];
        }
        
        
        return self;
        
        
    }


- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [self updateItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationView.title.text = @"View Item";
    
    _starRatingControl.delegate = self;
    

    
    
   self.smallImage1.layer.cornerRadius = 5.0f;
   self.smallImage1.layer.masksToBounds = YES;
    
    self.smallImage2.layer.cornerRadius = 5.0f;
    self.smallImage2.layer.masksToBounds = YES;
    
    self.smallImage3.layer.cornerRadius = 5.0f;
    self.smallImage3.layer.masksToBounds = YES;
    
    self.smallImage4.layer.cornerRadius = 5.0f;
    self.smallImage4.layer.masksToBounds = YES;
    
    self.bigImage.layer.cornerRadius = 5.0f;
    self.bigImage.layer.masksToBounds = YES;
    

#pragma mark implementation model user and item
    
    //[self updateItem];
    self.sellerAvatar.layer.cornerRadius = self.sellerAvatar.frame.size.height /2;
    self.sellerAvatar.layer.masksToBounds = YES;
    self.sellerAvatar.layer.borderWidth = 0;
    
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"OpenSans" size:14.0], UITextAttributeFont, nil] forState:UIControlStateNormal];
//    NSArray *itemArray = [NSArray arrayWithObjects: @"Similar Items", @"User Items", nil];
//    
//    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
//    segmentedControl.frame = CGRectMake(10, 10
//                                         , self.itemUser.width , self.itemUser.width);
//    segmentedControl.contentMode = UIViewContentModeCenter;
////    CGFloat width = self.itemUser.width - 30;
////    CGFloat widthForView = (width - 36) / 2;
////    CGSizeMake(widthForView, (widthForView * 488) / 291);
//    //segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
//    segmentedControl.selectedSegmentIndex = 0;
//    segmentedControl.tintColor = [UIColor colorWithRed:0.1f green:0.4f  blue:0.65f  alpha:1.0f];
//    //segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
//    
//    [segmentedControl addTarget:self
//                         action:@selector(segmentChanged:)
//               forControlEvents:UIControlEventValueChanged];
//    [self.itemUser addSubview:segmentedControl];
#pragma mark ending
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeedScreenCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundCollection"]];
    
    self.navigationView.delegate = self;
    
    
}
#pragma mark - update item
- (void) updateItem
{
    self.sellerName.text = self.item.user_username;
    [self.sellerAvatar setImageWithURL: [NSURL URLWithString: self.item.user_avatar] placeholderImage:nil];
    
    self.nameOoStuff.text = self.item.title;

    self.sellerPrice.text = self.item.selling_price;
    self.oldPrice.text = self.item.retail_price;
    self.descriptionOfItem.text = self.item.item_description;
    self.added.text = [self.item stringItemCreationDate];
    self.platform.text = [[AppEngine shared] categoryNameById: self.item.platform];
    self.condition.text = [[AppEngine shared] categoryNameById: self.item.condition];
    self.category.text = [[AppEngine shared] categoryNameById: self.item.category];
    self.colour.text = [[AppEngine shared] categoryNameById: self.item.color];
    self.delivery.text = self.item.shipping_price;
    //self.discount.text = self.item.discount;
    if (self.item.discount == nil || [self.item.discount isEqualToString: @"0"]) {
        self.discount.text = @"1%";
    } else {
        self.discount.text = [NSString stringWithFormat:@"%@%%",self.item.discount];
    }
    //self.counts.text = self.item.
    if(self.item.photos.count >= 1)
    {
        [self.bigImage setImageWithURL: [NSURL URLWithString: [self.item.photos objectAtIndex:0]] placeholderImage:nil];
        [self.smallImage1 setImageWithURL: [NSURL URLWithString: [self.item.photos objectAtIndex:0]] placeholderImage:nil];
        self.smallImage1.layer.borderWidth = 2.0f;
        self.smallImage1.layer.borderColor = [UIColor color256RGBWithRed: 55  green: 184 blue: 164].CGColor;
    }
    if(self.item.photos.count >= 2)
        [self.smallImage2 setImageWithURL: [NSURL URLWithString: [self.item.photos objectAtIndex:1]] placeholderImage:nil];
    if(self.item.photos.count >= 3)
        [self.smallImage3 setImageWithURL: [NSURL URLWithString: [self.item.photos objectAtIndex:2]] placeholderImage:nil];
    
    [self.smallImage4 setImageWithURL: [NSURL URLWithString: self.item.barcode] placeholderImage:nil];
}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    return YES;
//}
#pragma mark ending
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}


- (FeedScreenCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FeedScreenCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    cell.item = [self.items objectAtIndex: indexPath.row];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 12, 0, 12); // top, left, bottom, right
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Make cell same width as application frame and 250 pixels tall.
    CGFloat width = self.view.width;
    CGFloat widthForView = (width - 36) / 2;
    return CGSizeMake(widthForView, (widthForView * 488) / 291);
}



- (IBAction)imageTapped:(id)sender {
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*) sender;
    
    UIImageView* img = (UIImageView*)recognizer.view;
    
    if (img)
        
    {
        self.smallImage1.layer.borderWidth = 0.0f;
        self.smallImage2.layer.borderWidth = 0.0f;
        self.smallImage3.layer.borderWidth = 0.0f;
        self.smallImage4.layer.borderWidth = 0.0f;
        [self.bigImage setImage:img.image];
        img.layer.borderWidth = 2.0f;
        img.layer.borderColor = [UIColor color256RGBWithRed: 55  green: 184 blue: 164].CGColor;
        
    }
   
}

- (IBAction)buyButton:(id)sender {
}


- (IBAction)askButton:(id)sender {
}






@end
