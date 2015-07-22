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

@interface HWCommentViewController () <NavigationViewDelegate, HWCommentInputViewDelegate, HWCommentCellDelegate>

@property (weak, nonatomic) IBOutlet NavigationVIew *navigationView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet HWCommentInputView *inputCommentView;


@property (nonatomic, strong) NetworkManager *networkManager;
@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSArray *commentsArray;

@property CGFloat heightKey;
@property CGFloat height;

@end



@implementation HWCommentViewController

#pragma mark -
#pragma mark UIViewController



- (instancetype) initWithItemId:(NSString*)itemId
{
    self.itemId = itemId;
    
    [self setCommentsArrayWithItemId:itemId];
    
    self = [super init];
    if(self)
    {
        self.networkManager = [NetworkManager shared];
    }
    return self;
}

-  (void)viewDidLoad {
    [super viewDidLoad];
    [self setCommentsArrayWithItemId:self.itemId];
    
    
    self.navigationView.title.text = @"Comments";
    [self.navigationView.title setFont:[UIFont systemFontOfSize:20]];
    self.navigationView.delegate = self;
    self.inputCommentView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HWCommentCell" bundle:nil] forCellReuseIdentifier:@"tableViewCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 74.0;
     self.height = [[UIScreen mainScreen] bounds].size.height ;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    // unregister for keyboard notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
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
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    NSLog(@"%@",NSStringFromCGSize(tableView.contentSize));
    
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
    if([@"" isEqualToString:text] || [@" " isEqualToString:text]){
        return;
    }
    
    [self.networkManager createNewCommentWithItemId:self.itemId
                                        textComment:text
                                       successBlock:^{
                                           
                                           [self setCommentsArrayWithItemId:self.itemId];
                                           
                                       } failureBlock:^(NSError *error) {
                                           
                                           [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                                           
                                       }];
    
}

#pragma mark -
#pragma mark set/get

- (void) setCommentsArrayWithItemId:(NSString*)itemId
{
    [self.networkManager getAllCommentsWithItemId:itemId
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





@end
