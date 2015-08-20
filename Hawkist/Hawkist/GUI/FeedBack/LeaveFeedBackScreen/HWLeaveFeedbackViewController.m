 //
//  HWLeaveFeedbackViewController.m
//  Hawkist
//
//  Created by User on 18.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWLeaveFeedbackViewController.h"
#import "HWFedbackSegmentButton.h"
#import "SZTextView.h"
#import "NavigationVIew.h"
#import "NetworkManager.h"
#import "HWFeedBackViewController.h"


@interface HWLeaveFeedbackViewController () <NavigationViewDelegate>

@property (nonatomic, assign) CGFloat positionY;
@property (weak, nonatomic) IBOutlet NavigationVIew *navigationView;
@property (strong, nonatomic) IBOutletCollection(HWFedbackSegmentButton) NSArray *feedbackButtonCollection;

@property (weak, nonatomic) IBOutlet HWFedbackSegmentButton *positiveButton;
@property (weak, nonatomic) IBOutlet HWFedbackSegmentButton *neutralButton;
@property (weak, nonatomic) IBOutlet HWFedbackSegmentButton *negativeButton;

@property (weak, nonatomic) IBOutlet UIView *inputMessageView;
@property (weak, nonatomic) IBOutlet SZTextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorFeedback;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightKey;

@property (nonatomic, assign) HWFeedbackType typeFeedback;


@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *orderId;


@end

@implementation HWLeaveFeedbackViewController

- (instancetype) initWithUserID:(NSString *)userID withOrderId:(NSString*) orderId
{
    self = [super initWithNibName: @"HWLeaveFeedbackView" bundle: nil];
    if(self)
    {
        self.userId = userID;
        self.orderId = orderId;
    }
    
    return self;
}

- (instancetype) init {
    
    self = [self initWithUserID:nil withOrderId:nil];
    if (self) {
        
        
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
//     register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
}


#pragma mark -
#pragma mark Notification

- (void)keyboardWillShown:(NSNotification *)aNotification
{
    NSValue *value = [aNotification.userInfo objectForKey: UIKeyboardFrameEndUserInfoKey];
    CGRect keyEndFrame = [value CGRectValue];
    CGRect keyFrame = [self.view convertRect:keyEndFrame toView:nil];
 
    self.heightKey.constant = keyFrame.size.height;
   
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    self.heightKey.constant = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationView.title.text = @"Leave Feedback";
    
    [self setupSegmentConfig];
    [self selectedButton:self.positiveButton];
    self.navigationView.delegate = self;
    self.positiveButton.selectedImage.backgroundColor = [UIColor colorWithRed:52./255. green:185./255. blue:165./255. alpha:1];
    self.textView.placeholder = @"Positive!";
     self.typeFeedback = HWFeedbackPositive;
    
    [self.textView becomeFirstResponder];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - segment action

- (IBAction)positiveButAction:(HWFedbackSegmentButton *)sender {
    
    [self selectedButton:sender];
    sender.selectedImage.backgroundColor = [UIColor colorWithRed:52./255. green:185./255. blue:165./255. alpha:1];
    self.indicatorFeedback.backgroundColor = sender.selectedImage.backgroundColor;
    self.textView.placeholder = @"Positive!";
    self.typeFeedback = HWFeedbackPositive;
}

- (IBAction)neutralButAction:(HWFedbackSegmentButton *)sender {
    
    [self selectedButton:sender];
    sender.selectedImage.backgroundColor = [UIColor yellowColor];
    self.indicatorFeedback.backgroundColor = sender.selectedImage.backgroundColor;
    self.textView.placeholder = @"Neutral!";
    self.typeFeedback = HWFeedbackNeutral;
}

- (IBAction)negativeButAction:(HWFedbackSegmentButton *)sender {
    
    [self selectedButton:sender];
    sender.selectedImage.backgroundColor = [UIColor redColor];
    self.indicatorFeedback.backgroundColor = sender.selectedImage.backgroundColor;
    self.textView.placeholder = @"Negative!";
    
    self.typeFeedback = HWFeedbackNegative;
}

#pragma mark - input message action

- (IBAction)pressSendAction:(UIButton *)sender {
    
    sender.enabled = NO;
    [[NetworkManager shared] addNewFeedbackWithUserId:self.userId
                                          withOrderId:self.orderId
                                             withText:self.textView.text
                                     withFeedbackType:self.typeFeedback
                                         successBlock:^{
    
                                             HWFeedBackViewController *vc = [[HWFeedBackViewController alloc] initWithUserID:self.userId];
                                             [self.navigationController pushViewController:vc animated:YES];
                                             
                                         } failureBlock:^(NSError *error) {
                                            
                                             sender.enabled = YES;
                                             [self showAlertWithTitle:error.domain Message:error.localizedDescription];
                                         }];
    
     self.textView.text = @"";
    
    
}


#pragma mark - Segment Button Configuration


- (void) setupSegmentConfig {
    
    for (HWFedbackSegmentButton *but in self.feedbackButtonCollection) {
    
        but.count.text = @"";
        but.titleButton.text = @"";
        if ([but isEqual:self.positiveButton]){
            
            [but setTitle:@"Positive" forState:UIControlStateNormal];
        }
        else  if ([but isEqual:self.neutralButton]){
            
            [but setTitle:@"Neutral" forState:UIControlStateNormal];
        
        } else if ([but isEqual:self.negativeButton]){
            
            [but setTitle:@"Negative" forState:UIControlStateNormal];
        }
    }

}

- (void) selectedButton:(HWFedbackSegmentButton*) sender {
    
    for (HWFedbackSegmentButton *but in self.feedbackButtonCollection) {
        
        [self resetConfigButton:but
                  withColorBack:[UIColor colorWithRed:38./255. green:41./255. blue:48./255. alpha:1]
                  withColorText:[UIColor colorWithRed:141./255. green:143./255. blue:148./255. alpha:1]
         ];
    }
    sender.backgroundColor = [UIColor colorWithRed:244./255. green:242./255. blue:248./255. alpha:1];
    [sender setTitleColor:[UIColor colorWithRed:99./255. green:99./255. blue:95./255. alpha:1]
                 forState:UIControlStateNormal];
    
 
   
    
}


- (void) resetConfigButton:(HWFedbackSegmentButton*) but
             withColorBack:(UIColor*) backgraund
             withColorText:(UIColor*) textColor {
    
    but.backgroundColor = backgraund;
    [but setTitleColor:textColor forState: UIControlStateNormal];
 
    but.selectedImage.backgroundColor = [UIColor clearColor];
    but.selectedImage.image = nil;
    
    //[self.textView becomeFirstResponder];
    
    
}

#pragma  mark - NavigationViewDelegate

-(void) leftButtonClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) rightButtonClick {
    
    
}

 

@end
