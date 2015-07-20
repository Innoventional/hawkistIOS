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
#import "HWTag+Extensions.h"
#import "BuyThisItemViewController.h"
#import "HWProfileViewController.h"

@interface ViewItemViewController ()

@property (nonatomic, strong) HWItem* item;
@property (nonatomic, strong) NSMutableArray* imagesArray;

@property (nonatomic, strong) NSArray *selectedItemsArray;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat lastHeightCollectionView;

@end


@interface ViewItemViewController () <FeedScreenCollectionViewCellDelegate>



@end

@implementation ViewItemViewController

- (instancetype) initWithItem: (HWItem*) item
    {
        self = [super initWithNibName: @"ViewItemViewController" bundle: nil];
        if(self)
        {
            self.imagesArray = [NSMutableArray array];
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
    self.smallImage1.image = nil;
    
    self.smallImage2.layer.cornerRadius = 5.0f;
    self.smallImage2.layer.masksToBounds = YES;
    self.smallImage2.image = nil;
    
    self.smallImage3.layer.cornerRadius = 5.0f;
    self.smallImage3.layer.masksToBounds = YES;
    self.smallImage3.image = nil;
    
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
    

    HWTag* itemPlatform = [HWTag getPlatformById:self.item.platform from:[AppEngine shared].tags];
    
    self.platform.text =  itemPlatform.name;
    
    HWCategory* itemCategory = [HWTag getCategoryById:self.item.category from:itemPlatform.categories];
    
    self.category.text = itemCategory.name;
 
    
    
    HWSubCategories* itemSubCategory = [HWTag getSubCategoryById:self.item.subcategory from: itemCategory.subcategories];
    
    HWCondition* itemCondition = [HWTag getConditionById:self.item.condition from: itemSubCategory.condition];
    
    self.condition.text = itemCondition.name;
   
    HWColor* itemColor = [HWTag getColorById:self.item.color from:itemSubCategory.color];
    
    self.colour.text = itemColor.name;
    
    self.delivery.text = self.item.shipping_price;
    //self.discount.text = self.item.discount;
    if (self.item.discount == nil || [self.item.discount isEqualToString: @"0"]) {
        self.discount.text = @"1%";
    } else {
        self.discount.text = [NSString stringWithFormat:@"%@%%",self.item.discount];
    }
    [self.imagesArray removeAllObjects];
    
    if(self.item.photos)
        [self.imagesArray addObjectsFromArray: self.item.photos];
    if(self.item.barcode)
        [self.imagesArray addObject: self.item.barcode];
    
    [self setImages];
    
    
    
    self.selectedItemsArray = self.item.similar_items;
    
    [self.collectionView reloadData];
    [self reloadScrollViewSize];
    
}


- (void) reloadScrollViewSize
{
    
    //reload scroll view size
    
    
    [self.collectionView layoutIfNeeded];
    CGSize size = self.scrollView.contentSize;
    size.height += self.collectionView.contentSize.height - self.lastHeightCollectionView;
    self.scrollView.contentSize = size;
    
    self.lastHeightCollectionView = self.collectionView.contentSize.height ;
    
}

- (void) setImages
{
    for(NSInteger index = 0; index < self.imagesArray.count; index++)
    {
        switch (index) {
            case 0:
            {
                [self.bigImage setImageWithURL: [NSURL URLWithString: [self.imagesArray objectAtIndex: index]] placeholderImage: nil];
                break;
            }
            case 1:
            {
                [self.smallImage1 setImageWithURL: [NSURL URLWithString: [self.imagesArray objectAtIndex: index]] placeholderImage: nil];
                break;
            }
            case 2:
            {
                [self.smallImage2 setImageWithURL: [NSURL URLWithString: [self.imagesArray objectAtIndex: index]] placeholderImage: nil];
                break;
            }
            case 3:
            {
                [self.smallImage3 setImageWithURL: [NSURL URLWithString: [self.imagesArray objectAtIndex: index]] placeholderImage: nil];
                break;
            }
            default:
                break;
        }
        
    }
}
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    return YES;
//}
#pragma mark -
#pragma mark UISegmentedControl
 

- (IBAction)segmentSwith:(UISegmentedControl *)sender {
    
    //select similar or user's items
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.selectedItemsArray = self.item.similar_items;
            break;
            
        case 1:
            self.selectedItemsArray = self.item.user_items;
            break;
            
        default:
            break;
    }
    
    [self.collectionView reloadData];
    [self reloadScrollViewSize];
    
}


#pragma mark ending
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.selectedItemsArray count];
}


- (FeedScreenCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FeedScreenCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
   
    HWItem *item = [[HWItem alloc] initWithDictionary:  [self.selectedItemsArray objectAtIndex: indexPath.row]  error: nil];
    
    cell.item = item;
    cell.delegate = self;
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     HWItem *item = [[HWItem alloc] initWithDictionary:  [self.selectedItemsArray objectAtIndex: indexPath.row]  error: nil];
    ViewItemViewController* vc = [[ViewItemViewController alloc] initWithItem:item];
    [self.navigationController pushViewController: vc animated: YES];
}





- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 12, 0, 12); // top, left, bottom, right
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Calculate cell frame
    CGFloat width = self.view.width;
    CGFloat widthForView = (width - 36) / 2;
    return CGSizeMake(widthForView, (widthForView * 488) / 291);
}



- (IBAction)imageTapped:(id)sender {
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*) sender;
    
    NSInteger tag = recognizer.view.tag;
    
    if(tag == 4)
    {
        //TODO: Implement favourites action
        return;
    }
    if(tag >= self.imagesArray.count)
        return;
    // shift array
    NSArray* buff = [self.imagesArray subarrayWithRange: NSMakeRange(0, tag)];
    [self.imagesArray removeObjectsInRange: NSMakeRange(0, tag)];
    [self.imagesArray addObjectsFromArray: buff];
    [self setImages];
}

- (IBAction)buyButton:(id)sender {

    [self.navigationController pushViewController: [[BuyThisItemViewController alloc] initWithItem:self.item]  animated: YES];
}


- (IBAction)askButton:(id)sender {
}



#pragma mark - 
#pragma mark FeedScreenCollectionViewCellDelegate

- (BOOL) willTransitionToUserProfileButton
{
    return YES;
}

- (void) transitionToProfileScreenWithUserId:(NSString*)userId
{
    HWProfileViewController *profileVC = [[HWProfileViewController alloc] initWithUserID:userId];
    
    [self.navigationController pushViewController:profileVC animated:YES];
}


@end

