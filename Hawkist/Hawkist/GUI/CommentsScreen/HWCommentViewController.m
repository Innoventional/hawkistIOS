//
//  HWCommentViewController.m
//  Hawkist
//
//  Created by User on 21.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWCommentViewController.h"
#import "NavigationVIew.h"
#import "HWCommentInputView.h"
#import "HWCommentCell.h"
#import "HWProfileViewController.h"
#import "NetworkManager.h"

#import "SZTextView.h"
#import "HWComment.h"

@interface HWCommentViewController () <NavigationViewDelegate, HWCommentInputViewDelegate, HWCommentCellDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet NavigationVIew *navigationView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet HWCommentInputView *inputCommentView;


@property (nonatomic, strong) NetworkManager *networkManager;
@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSArray *commentsArray;
@property (nonatomic, strong) HWItem *currentItem;

@property CGFloat heightKey;
@property CGFloat height;

@end



@implementation HWCommentViewController

#pragma mark -
#pragma mark UIViewController



- (instancetype) initWithItem:(HWItem* )item
{
    self.itemId = item.id;
    self.currentItem = item;
    
    [self setCommentsArrayWithItem:item];
    
    self = [super init];
    if(self)
    {
        self.networkManager = [NetworkManager shared];
    }
    return self;
}

-  (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCommentsArrayWithItem:self.currentItem];
    
    [self commonInit];
  
}


- (void) commonInit
{
    self.navigationView.title.text = @"Comments";
    [self.navigationView.title setFont:[UIFont systemFontOfSize:20]];
    self.navigationView.delegate = self;
    self.inputCommentView.delegate = self;
    self.inputCommentView.textView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HWCommentCell" bundle:nil] forCellReuseIdentifier:@"tableViewCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 56.0;
    self.height = [[UIScreen mainScreen] bounds].size.height ;
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentSizeCategoryChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];

    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    // unregister for keyboard notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
    
}


- (void)keyboardWasShown:(NSNotification *)aNotification
{
    NSValue *value = [aNotification.userInfo objectForKey: UIKeyboardFrameEndUserInfoKey];
    CGRect keyEndFrame = [value CGRectValue];
    CGRect keyFrame = [self.view convertRect:keyEndFrame toView:nil];
    CGFloat keyHeight = keyFrame.size.height ;
    self.heightKey = keyHeight;
    
    CGRect frame = self.view.frame;
    frame.size.height = self.height;
    self.view.frame = frame;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyHeight);
                     }];
    

}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
   
                        
                        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, _height);

   
}

- (void)contentSizeCategoryChanged:(NSNotification *)notification
{
    [self.tableView reloadData];
}

#pragma nark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return [self.commentsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HWCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    HWComment *comment = [self.commentsArray objectAtIndex:indexPath.row];
    
    [cell setCellWithComment:comment];
    [cell layoutIfNeeded];
    
    if (comment.isAcceptDeclineComment)
    {
        cell.rightUtilityButtons = [self rightButtons];
        cell.backgroundColor = [UIColor colorWithRed:1 green:231./255. blue:231./255 alpha:1];
    } else {
        
        cell.rightUtilityButtons = nil;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     [self.inputCommentView.textView resignFirstResponder];
  
}

 #pragma nark -
#pragma mark NavigationViewDelegate


-(void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void) rightButtonClick
{
    
}

#pragma mark - 
#pragma mark HWCommentInputViewDelegate


- (void) pressPostButton:(UIButton*)sender withCommentText:(NSString*)text
{
    [self.inputCommentView.textView resignFirstResponder];

    if([@"" isEqualToString:text] || [@" " isEqualToString:text]){
        return;
    }
    
    [self.networkManager createNewCommentWithItemId:self.itemId
                                        textComment:text
                                       successBlock:^{
                                           
                                           [self setCommentsArrayWithItem:self.currentItem];
                                           
                                       } failureBlock:^(NSError *error) {
                                           
                                           [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                                           
                                       }];
    
}

#pragma mark -
#pragma mark set/get

- (void) setCommentsArrayWithItem:(HWItem*)item
{
    [self.networkManager getAllCommentsWithItem:item
                                     successBlock:^(NSArray *commentsArray) {
                                         
                                         self.commentsArray = commentsArray;
                                         [self.tableView reloadData];
                                         [self.tableView layoutIfNeeded];
                                         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.commentsArray.count -1) inSection:0];
                                        
                                         if(self.commentsArray.count)
                                         {
                                          [self.tableView scrollToRowAtIndexPath: indexPath atScrollPosition: UITableViewScrollPositionNone animated: NO];
                                         }
                                         
                                     } failureBlock:^(NSError *error) {
                                         
                                         [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                                         
                                     }];
    
}


#pragma nark -
#pragma mark HWCommentCellDelegate


- (void) transitionToProfileWithUserId:(NSString*)userId
{
    HWProfileViewController *profileVC = [[HWProfileViewController alloc] initWithUserID:userId];
    [self.navigationController pushViewController:profileVC animated:YES];
}



#pragma mark -
#pragma mark HelpsMethod

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:55./255. green:185./255. blue:165./255. alpha:1]
                                                 icon:[UIImage imageNamed:@"accept"]];
    
 
    
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:97./255. green:97./255. blue:97./255. alpha:1]
                                                 icon:[UIImage imageNamed:@"decline"]];
    
    return rightUtilityButtons;
}


#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            NSLog(@"left button 0 was pressed");
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(HWCommentCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
         
            
            [self.networkManager acceptOfferWithItemId:cell.offerId
                                          successBlock:^{
                                               
                                              [self setCommentsArrayWithItem:self.currentItem];
                                          } failureBlock:^(NSError *error) {
                                              
                                              [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                                              
                                          }];
            
                       break;
        }
        case 1:
        {
            [self.networkManager declineOfferWithItemId:cell.offerId
                                           successBlock:^{
                                               
                                               [self setCommentsArrayWithItem:self.currentItem];
                                               
                                           } failureBlock:^(NSError *error) {
                                               NSLog(@"success");
                                                [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                                           }];
         
            
                        break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}


#pragma mark - 
#pragma mark UITextViewDelegate


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([textView.text isEqualToString:@""] ){
        self.inputCommentView.pressButton.enabled = NO;
    } else {
    self.inputCommentView.pressButton.enabled = YES;
    }
    
   if(textView.text.length>160)
   {
       return NO;
   }
    return YES;
}

@end
