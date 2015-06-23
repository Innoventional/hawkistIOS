

#import "CustomizationViewController.h"
#import "UIColor+Extensions.h"
@interface CustomizationViewController ()

@property (nonatomic, strong) NSMutableArray* arrayWithImageViews;
@end

@implementation CustomizationViewController

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
    self.title1.text = @"What are you looking for:";
    self.textup.text = @"Choose what you want to see first";
    self.textdown.text = @"Whant more options? You'll be able tomake changes in your profile";
    self.name = @[@"Playstation", @"Pc",@"Xbox"];
    self.backImage = @[@"11",@"22",@"33"];
    
    self.images =@[@"plateside",@"plateside",@"plateside"];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.viewScroll.bounds];
    [self.scrollView setDelegate:self];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setPagingEnabled:NO];
    [self.scrollView setBounces:NO];
    self.scrollView.backgroundColor = [UIColor clearColor];
    
//    [self.pageControl setNumberOfPages:[self.images count]];
//    [self.viewScroll addSubview:self.scrollView];
//    
//    [self.viewScroll addSubview:self.pageControl];
//    
    
    
    //self.scrollView.frame =  self.viewScroll.bounds;
    
    
//    CGSize scrollViewSize = self.viewScroll.frame.size;
//    
//    CGSize slideSize = CGSizeMake(self.scrollView.frame.size.width - 90, self.scrollView.frame.size.height);
//    
//    for (NSInteger i = 0; i < [self.images count]; i++)
//    {
//        CGRect slideRect = CGRectMake((self.scrollView.bounds.size.width - slideSize.width)/2 + slideSize.width * i, 0, slideSize.width, slideSize.height);
//    
//        
//        UIView *slide = [[UIView alloc] initWithFrame:slideRect];
//        [slide setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
//        slide.backgroundColor = [UIColor redColor];
//        
//    
//       UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, slideRect.size.width , slide.frame.size.height)];
//        
//        imageView.backgroundColor = [UIColor clearColor];
//        imageView.contentMode = UIViewContentModeCenter;
//        [imageView setImage:[UIImage imageNamed:[self.images objectAtIndex:i]]];
//        
//        UIImageView *imageFront = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, slideRect.size.width  , slide.frame.size.height - 100)];
//        imageFront.backgroundColor = [UIColor clearColor];
//        imageFront.contentMode = UIViewContentModeCenter;
//        [imageFront setImage:[UIImage imageNamed:[self.backImage objectAtIndex:i]]];
//        
//
//        [self.scrollView addSubview:slide];
//        
//        [slide addSubview:imageView];
//        [imageView addSubview:imageFront];
//    }
//  
//    
//    [self.scrollView setContentSize:CGSizeMake(slideSize.width * [self.images count] + (self.scrollView.frame.size.width - slideSize.width), scrollViewSize.height)];
//   
//    
//    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.viewScroll);
//    }];
//    
}

- (void) viewDidAppear: (BOOL) animated
{
    [super viewDidAppear: animated];
    [self.arrayWithImageViews removeAllObjects];
    
    [self.scrollView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    self.scrollView.frame =  self.viewScroll.bounds;
    
    CGSize scrollViewSize = self.viewScroll.frame.size;
    
    CGSize slideSize = CGSizeMake(self.scrollView.frame.size.width - 100, self.scrollView.frame.size.height);
    
    for (NSInteger i = 0; i < [self.images count]; i++)
    {
        CGRect slideRect = CGRectMake((self.scrollView.bounds.size.width - slideSize.width)/2 + slideSize.width * i, 0, slideSize.width, slideSize.height);
        
        
        UIView *slide = [[UIView alloc] initWithFrame:slideRect];
        [slide setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];

        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 0, slideRect.size.width - 10.0f  , self.scrollView.frame.size.height )];
        
        imageView.layer.cornerRadius = 5.0f;
        
        imageView.backgroundColor = [UIColor clearColor];
        imageView.clipsToBounds = YES;
        //imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImage:[UIImage imageNamed:[self.images objectAtIndex:i]]];
        
        UIImageView *imageFront = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, slideRect.size.width  , slide.frame.size.height - 100)];
        imageFront.contentMode = UIViewContentModeScaleAspectFill;
        [imageFront setImage:[UIImage imageNamed:[self.backImage objectAtIndex:i]]];
        imageFront.clipsToBounds = YES;
        
        _lable = [[UILabel alloc] initWithFrame:CGRectMake(10, slide.frame.size.height - 90, slideRect.size.width  , 20 )];
        _lable.textAlignment = NSTextAlignmentLeft;
        
        
        [self.scrollView addSubview:slide];
        
        [imageView addSubview:_lable];
         
        [slide addSubview:imageView];
        
        [imageView addSubview:imageFront];
        
        [self.arrayWithImageViews addObject: imageView];
        
        _lable.text = [self.name objectAtIndex:i];
    }
    
    UIImageView* imageView = [self.arrayWithImageViews objectAtIndex: 0];
    imageView.layer.borderWidth = 4.0f;
    imageView.layer.borderColor = [UIColor color256RGBWithRed: 55  green: 184 blue: 164].CGColor;
    [self.viewScroll addSubview:self.scrollView];
    
   
    
    [self.scrollView setContentSize:CGSizeMake(slideSize.width * [self.images count] + (self.scrollView.frame.size.width - slideSize.width), scrollViewSize.height)];
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat kMaxIndex = 3;
    CGFloat targetX = scrollView.contentOffset.x + velocity.x * 60.0;
    CGFloat targetIndex = round(targetX / (self.scrollView.frame.size.width - 100));
    if (targetIndex < 0)
        targetIndex = 0;
    if (targetIndex > kMaxIndex)
        targetIndex = kMaxIndex;
    targetContentOffset->x = targetIndex * (self.scrollView.frame.size.width - 100);
    
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
    
}
@end