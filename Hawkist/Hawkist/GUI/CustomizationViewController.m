

#import "CustomizationViewController.h"
#import "UIColor+Extensions.h"
#import "FeedScreenViewController.h"

#import "WantToSellViewController.h"

#import "HWTapBarViewController.h"

@interface CustomizationViewController ()

@property (strong, nonatomic) NSArray *name;
@property (nonatomic , strong) UILabel *label;
@property (nonatomic, strong) NSMutableArray* arrayWithImageViews;
@property (nonatomic, strong) NSArray* descriptions;

@property (nonatomic,assign)NSInteger currentIndex;


@end

@implementation CustomizationViewController
{
    CGSize slideSize;
}

- (instancetype)init
{
    self = [super initWithNibName: @"CustomizationViewController" bundle: [NSBundle mainBundle]];
    if(self)
    {

    }
    return self;
}

- (void) viewDidAppear: (BOOL) animated
{
    [super viewDidAppear: animated];
    
    self.isInternetConnectionAlertShowed = NO;
    [self.viewScroll layoutIfNeeded];
    
    self.scrollView.frame = self.viewScroll.bounds;
    [self.scrollView layoutIfNeeded];
    
    self.arrayWithImageViews = [NSMutableArray array];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.viewScroll.bounds];
    
    [self.scrollView setDelegate:self];
    
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    
    [self.scrollView setPagingEnabled:NO];
    
    [self.scrollView setBounces:NO];
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    [self setScrollView];
    
    for (NSInteger i = 0; i < [self.avaliableTags count]; i++)
    {
        UIView* slide = [self setCellScrollView:i];
        
        [self.scrollView addSubview:slide];
        [self.arrayWithImageViews addObject: slide];
        
        if(i == self.currentIndex)
        {
            slide.layer.borderWidth = 4.0f;
            slide.layer.borderColor = [UIColor color256RGBWithRed: 55  green: 184 blue: 164].CGColor;
        }

    }

}


- (void)awakeFromNib
{
    
}

- (void) setScrollView
{
    [self.arrayWithImageViews removeAllObjects];
    
    [self.scrollView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    CGSize scrollViewSize = self.viewScroll.frame.size;
    
    CGFloat estimatedWidth = self.scrollView.frame.size.width - 100;
    CGFloat estimatedHeight = self.scrollView.height - 20.0f;
    
    CGFloat calculatedHeightForEstimatedWitdth = estimatedWidth / 0.7f;
    CGFloat calculatedWidthForEstimatedHeight = estimatedHeight * 0.7f;
    
    if(calculatedHeightForEstimatedWitdth > (self.scrollView.height - 20))
    {
        slideSize = CGSizeMake(calculatedWidthForEstimatedHeight, estimatedHeight);
    }
    else
    {
        slideSize = CGSizeMake(estimatedWidth, calculatedHeightForEstimatedWitdth);
    }
    
    [self.scrollView setContentSize:CGSizeMake((slideSize.width + 10) * [self.avaliableTags count] + (self.scrollView.frame.size.width - slideSize.width), scrollViewSize.height)];
    
    
    [self.viewScroll addSubview:self.scrollView];
    
    self.currentIndex = (int)self.avaliableTags.count/2;
    
    [self.scrollView setContentOffset:CGPointMake(self.currentIndex*slideSize.width, 0) animated:NO];

    
    
}

- (UIView*) setCellScrollView:(NSInteger)index
{
    
    HWTag* currentTag = (HWTag*)[self.avaliableTags objectAtIndex:index];
    
    UIView* slide = [self setSlide:index];
    
    [self.scrollView addSubview:slide];
    
    UILabel* slideTitle = [self setSlideTitle:currentTag.name];
    
    
    NSString* descriptionText = currentTag.item_description;
    
   
    CGSize descriptionSize = [descriptionText sizeWithFont: [UIFont fontWithName:@"OpenSans" size:10.0f]
                                         constrainedToSize: CGSizeMake(slideSize.width - 15.0f, CGFLOAT_MAX)
                                             lineBreakMode: NSLineBreakByWordWrapping];
    
    float descriptionHeight = slide.height - slideTitle.maxY;
    
    CGRect descriptionRect= CGRectMake(10.0f, slideTitle.maxY + 2.0f, descriptionSize.width, descriptionHeight);
    
    
    UILabel* description = [self setDescription:descriptionText withRect:descriptionRect];
    
    
    UIImageView* frontImage = [self setFrontImage:currentTag.image_url];
    
    [slide addSubview:slideTitle];
    [slide addSubview: description];
    [slide addSubview:frontImage];
    
    return slide;
}

- (UIView*) setSlide:(NSInteger)index
{
    float slideX = (self.scrollView.bounds.size.width - slideSize.width)/2 + (slideSize.width + 10) * index;
    float slideY = (self.scrollView.height - slideSize.height) / 2;
    
    CGRect slideRect = CGRectMake(slideX, slideY, slideSize.width, slideSize.height);
    
    UIView *slide = [[UIView alloc] initWithFrame:slideRect];
    
    [slide setBackgroundColor:[UIColor whiteColor]];
    
    slide.layer.cornerRadius = 5.0f;
    return slide;
}

- (UIImageView*) setFrontImage:(NSString*)url
{
    UIImageView *imageFront = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, slideSize.width , slideSize.width)];
    imageFront.contentMode = UIViewContentModeScaleAspectFill;
    [imageFront setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    imageFront.clipsToBounds = YES;
    return imageFront;
}

- (UILabel*) setDescription:(NSString*)text withRect:(CGRect)rect
{
    UILabel* descriptionLabel = [[UILabel alloc] init];
    
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.font = [UIFont fontWithName:@"OpenSans" size:10.0f];
    descriptionLabel.textColor = [UIColor color256RGBWithRed: 100 green: 100 blue: 100];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.text = text;
    descriptionLabel.frame = rect;
    
    return descriptionLabel;
}


- (UILabel*) setSlideTitle:(NSString*)text
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, slideSize.width + 5.0f, slideSize.width - 10.0f , 16)];
    
    label.font = [UIFont fontWithName: @"OpenSans-SemiBold" size: 15];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = text;
    
    return label;
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat kMaxIndex = [self.avaliableTags count];
    CGFloat targetX = scrollView.contentOffset.x + velocity.x * 60.0;
    CGFloat targetIndex = round(targetX / slideSize.width);
    if (targetIndex < 0)
        targetIndex = 0;
    if (targetIndex > kMaxIndex)
        targetIndex = kMaxIndex;
    targetContentOffset->x = targetIndex * slideSize.width;
    
    for (NSInteger index = 0; index < [self.avaliableTags count]; index++) {
        UIImageView* border = [self.arrayWithImageViews objectAtIndex: index];
        if(index == targetIndex)
        {
            border.layer.borderWidth = 4.0f;
            border.layer.borderColor = [UIColor color256RGBWithRed: 55  green: 184 blue: 164].CGColor;
        }
        else
        {
            border.layer.borderWidth = 0.0f;
        }
    }
    
    self.currentIndex = (NSInteger)targetIndex;
}



- (IBAction)nextButton:(id)sender {
    
    NSString* itemId = ((HWTag*)[self.avaliableTags objectAtIndex:self.currentIndex]).id;
    
    [[NetworkManager shared]addTagToFeed:itemId successBlock:^{
        
    } failureBlock:^(NSError *error) {
        
        
    }];
    
    [self.navigationController pushViewController:[[HWTapBarViewController alloc]init] animated:(YES)];

}
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end

