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
#import "NetworkManager.h"
#import "HWProfileViewController.h"

@interface HWFeedBackViewController () <NavigationViewDelegate, HWFeedBackSegmentViewDelegate, HWFeadbackCellDelegate>
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
       [[NetworkManager shared] getAllFeedbackWithUserId:userID
                                            successBlock:^(NSArray *positive, NSArray *neutrall, NSArray *negative) {
                                                
                                                self.positiveArray = positive;
                                                self.neutralArray = neutrall;
                                                self.negativeArray = negative;
                                                self.selectedArray = self.positiveArray;
                                                
                                                
                                                self.segmentView.positiveButton.count.text = [NSString stringWithFormat:@"%lu", (unsigned long)positive.count];
                                                self.segmentView.negativeButton.count.text = [NSString stringWithFormat:@"%lu", (unsigned long)negative.count];
                                                self.segmentView.neutralButton.count.text = [NSString stringWithFormat:@"%lu", (unsigned long)neutrall.count];
                                                
                                                [self.tableView reloadData];
        
                                                
                                          } failureBlock:^(NSError *error) {
        
                                              
                                          }];
        
        
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
    
    NSArray *ar = self.navigationController.viewControllers;
    
    id vc = [ar objectAtIndex:ar.count-2];
    
     NSLog(@"%@",vc);
    
    if( [ vc isKindOfClass:[HWProfileViewController class]]) {
   
    [self.navigationController popViewControllerAnimated:YES];
    
    } else {
        
        [self.navigationController popToViewController:[ar objectAtIndex:1] animated:YES];
    }
    
    
}

-(void) rightButtonClick {
    
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.selectedArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HWFeadbackCell * cell = [tableView dequeueReusableCellWithIdentifier:feedbackCell forIndexPath:indexPath];
    
    HWFeedback *fb = [self.selectedArray objectAtIndex:indexPath.row];
    
    [cell setCellWithFeedback:fb];
    cell.delegate = self;
    return cell;
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

#pragma mark - HWFeadbackCellDelegate

- (void) transitionToProfileWithUserId:(NSString*)userId {
    
    HWProfileViewController *vc = [[HWProfileViewController alloc] initWithUserID:userId];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
