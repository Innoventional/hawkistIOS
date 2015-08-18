//
//  HWFeedBackViewController.m
//  Hawkist
//
//  Created by User on 17.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWFeedBackViewController.h"
#import "NavigationVIew.h"
#import "HWFeedBackSegmentView.h"
#import "HWFeadbackCell.h"


@interface HWFeedBackViewController () <NavigationViewDelegate, HWFeedBackSegmentViewDelegate>
@property (weak, nonatomic) IBOutlet NavigationVIew *navigationView;

@property (weak, nonatomic) IBOutlet HWFeedBackSegmentView *segmentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *selectedArray;

@property (nonatomic, strong) NSArray *positiveArray;
@property (nonatomic, strong) NSArray *neutralArray;
@property (nonatomic, strong) NSArray *negativeArray;

@end

@implementation HWFeedBackViewController

#define feedbackCell @"feedbackCell"

#pragma mark - UIViewController

- (instancetype) initWithUserID:(NSString *)userID
{
    self = [super initWithNibName: @"HWFeedBackView" bundle: nil];
    if(self)
    {
               
    }
    
    return self;
}


- (instancetype) init {
    
    self = [self initWithUserID:nil];
    if (self) {
        
        
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationView.delegate = self;
    self.navigationView.title.text = @"Feedback";
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    [self.tableView registerNib:[UINib nibWithNibName:@"HWFeadbackCell" bundle:nil] forCellReuseIdentifier:feedbackCell];
    
    [self.segmentView pressFirstButton];
    self.segmentView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   }


#pragma mark - NavigationViewDelegate 

-(void) leftButtonClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) rightButtonClick {
    
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 16;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HWFeadbackCell * cell = [tableView dequeueReusableCellWithIdentifier:feedbackCell forIndexPath:indexPath];
    
    cell.messageText.text = @" asdasdasdasdasd ыфва фыв афы ";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HWFeadbackCell *cel = (id) cell;
    CGFloat f = [UIScreen mainScreen].bounds.size.width;
    
    NSLog(@"%f", f - cel.messageText.bounds.size.width );
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

#pragma mark - HWFeedBackSegmentViewDelegate

- (void) pressPositiveButton:(HWFedbackSegmentButton*) sender {
    
    [self pressFeedbackButtonWithArray: self.positiveArray];
}

- (void) pressNeutralButton:(HWFedbackSegmentButton*) sender {
    
    [self pressFeedbackButtonWithArray: self.neutralArray];
}

- (void) pressNegativeButton:(HWFedbackSegmentButton*) sender {
    
    [self pressFeedbackButtonWithArray: self.negativeArray];
}


- (void) pressFeedbackButtonWithArray:(NSArray*)array {
    
    self.selectedArray = array;
    [self.tableView reloadData];
}



@end
