

#import "CustomizationViewController.h"
#import "UIColor+Extensions.h"
#import "FeedScreenViewController.h"
@interface CustomizationViewController ()

@property (strong, nonatomic) NSArray *name;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic , strong) UILabel *lable;
@property (nonatomic, strong) NSMutableArray* arrayWithImageViews;
@property (nonatomic, strong) NSArray* descriptions;

@end

@implementation CustomizationViewController
{
    CGSize slideSize;
}

- (instancetype)init
{
    self = [super initWithNibName: @"CustomizationViewController" bundle: nil];
    if(self)
    {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.arrayWithImageViews = [NSMutableArray array];
    
    self.name = @[@"Playstation", @"PC",@"Xbox"];
    self.backImage = @[@"11",@"22",@"33"];
    self.descriptions = @[@"Deals on Playstation games and consoles like PS3 or God of War.",@"Deals on PC games like The Sims, Guild Wars or Crysis, Dota 2",@"Deals on XBox games and consoles like XBox 360 or Halo"];
    
    self.images =@[@"plateside",@"plateside",@"plateside"];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.viewScroll.bounds];
    [self.scrollView setDelegate:self];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setPagingEnabled:NO];
    [self.scrollView setBounces:NO];
    self.scrollView.backgroundColor = [UIColor clearColor];
    

}

- (void) viewDidAppear: (BOOL) animated
{
    [super viewDidAppear: animated];
    [self.arrayWithImageViews removeAllObjects];
    
    [self.scrollView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    self.scrollView.frame =  self.viewScroll.bounds;
    
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
    
    
    
    for (NSInteger i = 0; i < [self.images count]; i++)
    {
        CGRect slideRect = CGRectMake((self.scrollView.bounds.size.width - slideSize.width)/2 + (slideSize.width + 10) * i, (self.scrollView.height - slideSize.height) / 2, slideSize.width, slideSize.height);
        
        
        UIView *slide = [[UIView alloc] initWithFrame:slideRect];
        [slide setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0, slideSize.width, slideSize.height)];
        
        imageView.layer.cornerRadius = 5.0f;
        
        imageView.backgroundColor = [UIColor clearColor];
        imageView.clipsToBounds = YES;
        //imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImage:[UIImage imageNamed:[self.images objectAtIndex:i]]];
        
        UIImageView *imageFront = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, slideSize.width , slideSize.width)];
        imageFront.contentMode = UIViewContentModeScaleAspectFill;
        [imageFront setImage:[UIImage imageNamed:[self.backImage objectAtIndex:i]]];
        imageFront.clipsToBounds = YES;
        
        _lable = [[UILabel alloc] initWithFrame:CGRectMake(10.0, slideSize.width + 5.0f, slideSize.width - 10.0f , 16)];
        _lable.font = [UIFont fontWithName: @"OpenSans-SemiBold" size: 15];
        _lable.textAlignment = NSTextAlignmentLeft;
        
        UILabel* descriptionLabel = [[UILabel alloc] init];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.font = [UIFont fontWithName:@"OpenSans" size:10.0f];
        descriptionLabel.textColor = [UIColor color256RGBWithRed: 100 green: 100 blue: 100];
        descriptionLabel.numberOfLines = 0;
        
        descriptionLabel.text = self.descriptions[i];
        
        CGSize descriptionSize = [descriptionLabel.text sizeWithFont: [UIFont fontWithName:@"OpenSans" size:10.0f]
                                                      constrainedToSize: CGSizeMake(slideSize.width - 15.0f, CGFLOAT_MAX)
                                                          lineBreakMode: NSLineBreakByWordWrapping];
        
//        if(descriptionSize.height <= (imageView.height - imageFront.height - 2))
//        {
//            descriptionLabel.font = [UIFont fontWithName:@"OpenSans" size:7.0f];
//            descriptionLabel.frame = CGRectMake(10.0f, _lable.maxY + 2.0f, descriptionSize.width, descriptionSize.height);
//        }
//        else
//        {
            descriptionLabel.frame = CGRectMake(10.0f, _lable.maxY + 2.0f, descriptionSize.width, descriptionSize.height);
        //}
       
        
        [self.scrollView addSubview:slide];
        
        [imageView addSubview:_lable];
        [imageView addSubview: descriptionLabel];
         
        [slide addSubview:imageView];
        
        [imageView addSubview:imageFront];
        
        [self.arrayWithImageViews addObject: imageView];
        
        _lable.text = [self.name objectAtIndex:i];
    }
    
    UIImageView* imageView = [self.arrayWithImageViews objectAtIndex: 0];
    imageView.layer.borderWidth = 4.0f;
    imageView.layer.borderColor = [UIColor color256RGBWithRed: 55  green: 184 blue: 164].CGColor;
    [self.viewScroll addSubview:self.scrollView];
    
   
    
    [self.scrollView setContentSize:CGSizeMake((slideSize.width + 10) * [self.images count] + (self.scrollView.frame.size.width - slideSize.width), scrollViewSize.height)];
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat kMaxIndex = 3;
    CGFloat targetX = scrollView.contentOffset.x + velocity.x * 60.0;
    CGFloat targetIndex = round(targetX / slideSize.width);
    if (targetIndex < 0)
        targetIndex = 0;
    if (targetIndex > kMaxIndex)
        targetIndex = kMaxIndex;
    targetContentOffset->x = targetIndex * slideSize.width;
    
    for (NSInteger index = 0; index < 3; index++) {
        UIImageView* imageView = [self.arrayWithImageViews objectAtIndex: index];
        if(index == targetIndex)
        {
            imageView.layer.borderWidth = 4.0f;
            imageView.layer.borderColor = [UIColor color256RGBWithRed: 55  green: 184 blue: 164].CGColor;
        }
        else
        {
            imageView.layer.borderWidth = 0.0f;
        }
    }
    
    
}

- (IBAction)nextButton:(id)sender {
    [self.navigationController pushViewController:[[FeedScreenViewController alloc]init] animated:(YES)];
}
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end