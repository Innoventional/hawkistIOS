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
#import "ViewItemViewController.h"


#import "SZTextView.h"
#import "HWComment.h"
#import "HWMention.h"
#import "HWMentionUserCell.h"
#import <pop/POP.h>
 

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

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorLoad;

@property (nonatomic, strong) NSArray *mentionsArray;
@property (nonatomic, assign) BOOL isCommentsArray;
@property (weak, nonatomic) IBOutlet UIView *v;

@end



@implementation HWCommentViewController



#define commentCellIdentifier @"commentCellIdentifier"
#define mentionCellIdentifier @"mentionCellIdentifier"



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
    self.isCommentsArray = YES;
    [self setCommentsArrayWithItem:self.currentItem];
    self.inputCommentView.pressButton.enabled = NO;
    
    [self commonInit];

}


- (void) commonInit
{
    self.navigationView.title.text = @"Comments";
    self.navigationView.delegate = self;
    self.inputCommentView.delegate = self;
    self.inputCommentView.textView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HWCommentCell" bundle:nil] forCellReuseIdentifier:commentCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"HWMentionUserCell" bundle:nil] forCellReuseIdentifier:mentionCellIdentifier];
    
    self.height =  [[UIScreen mainScreen] bounds].size.height ;
}


- (void) viewDidAppear:(BOOL)animated
{
         self.isInternetConnectionAlertShowed = NO;
    
   
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    // register for keyboard notifications
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
    
    // unregister for keyboard notifications
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
    CGFloat keyHeight = keyFrame.size.height ;
     self.heightKey = keyHeight;
    
    CGRect frame = self.view.frame;
    frame.size.height = self.height;
    self.view.frame = frame;
    
     self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyHeight);
  
    [self scrollToBotton];
    

}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
     self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, _height);
    
     
}


#pragma mark -
#pragma mark set/get

- (void) setCommentsArrayWithItem:(HWItem*)item
{
    [self.networkManager getAllCommentsWithItem:item
                                   successBlock:^(NSArray *commentsArray) {
                                       
                                       self.commentsArray = commentsArray;
                                       
                                       if(!self.commentsArray.count)
                                       {
                                           [self.indicatorLoad stopAnimating];
                                       }
                                       
                                       [self scrollToBotton];
                                       
                                       
                                   } failureBlock:^(NSError *error) {
                                       
                                       [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"] withDelegate:self];
                                       
                                       //  [self.navigationController popViewControllerAnimated:YES];
                                       
                                   }];
    
}

#pragma mark -
#pragma mark NavigationViewDelegate


-(void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void) rightButtonClick
{
    
}



#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.isCommentsArray){
    
    return [self.commentsArray count];
    
    } else {
        
        return [self.mentionsArray count];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isCommentsArray)
    {
        HWComment *comment = [self.commentsArray objectAtIndex:indexPath.row];
        NSString *text = [NSString stringWithFormat:@"%@ %@", comment.user_username, comment.text];
        
        
        return [HWCommentCell heightWith:text];
    }
   else
   {
       return 66;
   }

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isCommentsArray){
    
    HWCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier forIndexPath:indexPath];
    cell = [self setupCommentCell:cell withIndexPath:indexPath];
    return cell;
    
    } else {
        
        HWMentionUserCell * cell = [tableView dequeueReusableCellWithIdentifier:mentionCellIdentifier forIndexPath:indexPath];
        cell = [self setupMentionCellWithCell:cell withIndexPath:indexPath];
        return cell;
    }
    
}


- (HWCommentCell*) setupCommentCell:(HWCommentCell*) cell withIndexPath:(NSIndexPath*) indexPath
{
    cell.clipsToBounds = YES;
    cell.delegate = self;
    HWComment *comment = [self.commentsArray objectAtIndex:indexPath.row];
    
    [cell setCellWithComment:comment];
    [cell layoutIfNeeded];
    
    if (comment.isAcceptDeclineComment && [comment.offerModel.visibility integerValue])
    {
        cell.rightUtilityButtons = [self rightButtons];
        cell.backgroundColor = [UIColor colorWithRed:1 green:231./255. blue:231./255 alpha:1];
        cell.swipeImage.hidden = NO;
    } else {
        
        cell.rightUtilityButtons = nil;
        cell.backgroundColor = [UIColor whiteColor];
        cell.swipeImage.hidden = YES;
    }
    if(indexPath.row == self.commentsArray.count -1)
    {
        [self.indicatorLoad stopAnimating];
    }
    
    return cell;
    
}

-(HWMentionUserCell *) setupMentionCellWithCell:(HWMentionUserCell*)cell withIndexPath:(NSIndexPath*)indexPath
{
    HWMention *mention = [self.mentionsArray objectAtIndex:indexPath.row];
    
    [cell.avatarImageView  setImageWithURL:[NSURL URLWithString:mention.avatar] placeholderImage:[UIImage imageNamed:@"noPhoto"]];
    
    cell.userNameLabel.text =  mention.username ;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    HWMention *mention = [self.mentionsArray objectAtIndex:indexPath.row];
    NSString *nameWithSpace = [NSString stringWithFormat:@"%@ ",mention.username];
    
    if((self.inputCommentView.textView.text.length + nameWithSpace.length) > 160)
    {
        // max comment 160 character  
        self.isCommentsArray = YES;
        [self scrollToBotton ];
        return;
    }
    
    [self insertString:nameWithSpace intoTextView:self.inputCommentView.textView ];
    
     
    
    if(!self.isCommentsArray)
    {
        
    }
    
  
}

- (void) insertString: (NSString *) insertingString intoTextView: (UITextView *) textView
{
    
     NSRange range = textView.selectedRange;
     NSString *string = [textView.text substringToIndex:range.location];
    
    
     NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"@"];
    
     NSArray *array = [string componentsSeparatedByCharactersInSet:charSet];
     NSString *lastWord = array.lastObject;
    
   
    NSRange replaceRange = NSMakeRange(range.location - lastWord.length, lastWord.length);
    
    if (replaceRange.location != NSNotFound){
        NSString* result = [textView.text stringByReplacingCharactersInRange:replaceRange withString:insertingString];
        
        textView.text = result;
        
        range.location += [insertingString length];
        textView.selectedRange = range;
        textView.scrollEnabled = YES;
        
        
    }

    self.isCommentsArray = YES;
    [self scrollToBotton ];
    
    
}



- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return !self.isCommentsArray;
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
#pragma mark HWCommentCellDelegate


- (void) transitionToProfileWithUserId:(NSString*)userId
{
    HWProfileViewController *profileVC = [[HWProfileViewController alloc] initWithUserID:userId];
    [self.navigationController pushViewController:profileVC animated:YES];
}



- (void) transitionToViewItemWithItem:(HWItem*)item
{
    if (!item) return;
    
    ViewItemViewController *vc = [[ViewItemViewController alloc]initWithItem:item];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void) stringWithTapWord:(NSString*)text
{
    [self.inputCommentView.textView resignFirstResponder];
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


- (void) scrollToBotton
{
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    if (self.commentsArray.count) {
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow: ([self.tableView numberOfRowsInSection:([self.tableView numberOfSections]-1)]-1) inSection: ([self.tableView numberOfSections]-1)];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
        
    }
    
}



#pragma mark -
#pragma mark HWCommentInputViewDelegate


- (void) pressPostButton:(UIButton*)sender withCommentText:(NSString*)text
{
    self.inputCommentView.pressButton.enabled = NO;
    [self.inputCommentView.textView resignFirstResponder];
    self.isCommentsArray = YES;
    
    NSString *textToSend = text;
    
    NSString *trimmedString = [textToSend stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if([@"" isEqualToString:trimmedString]){
        return;
    }
    
    [self.networkManager createNewCommentWithItemId:self.itemId
                                        textComment:trimmedString
                                       successBlock:^{
                                           
                                           [self setCommentsArrayWithItem:self.currentItem];
                                           self.inputCommentView.limitCharacter.text = [NSString stringWithFormat:@"160" ];
                                           
                                       } failureBlock:^(NSError *error) {
                                           
                                           [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                                           
                                       }];
    
}


#pragma mark - 
#pragma mark UITextViewDelegate


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{     
    NSInteger newLength = [textView.text length] + [text length] - range.length;
    NSInteger limit =  160;
 
   // if (newLength <= permissibleLenght) {
    self.inputCommentView.limitCharacter.text = [NSString stringWithFormat:@"%d", (limit - newLength) ];
        if ((limit - newLength)<= 10) {
            
            self.inputCommentView.limitCharacter.textColor = [UIColor redColor];
        } else {
            
            self.inputCommentView.limitCharacter.textColor = [UIColor color256RGBAWithRed:167 green:167 blue:167 alpha:1];
        }
        
        self.inputCommentView.pressButton.enabled = ((160 - newLength) >= 0);
        
        
        
  //  }
    
    return YES;//(newLength > permissibleLenght) ? NO : YES;
  
 }

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        self.inputCommentView.pressButton.enabled = NO;
        
    }
    
    if([textView.text isEqualToString:@""]) return;
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@" "];
    
    NSString *tempString = [textView.text substringToIndex:textView.selectedRange.location];
    NSLog(@"%@",tempString);
    
    NSArray *arraySubstring = [tempString componentsSeparatedByCharactersInSet:charSet];
    
    NSString *str = arraySubstring.lastObject;
    NSLog(@"%@",str);
    if ([str isEqualToString:@""]) return;
    
    if ([[str substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"@"])
    {
        
            [self getMantionUsersArrayWithText:[str substringFromIndex:1]];
   
    } else  if(!self.isCommentsArray){
        
       
        self.isCommentsArray = YES;
        [self.tableView reloadData];
    }
 
    
}


-(void) getMantionUsersArrayWithText:(NSString*)text
{
    NSLog(@"%@",text);
     
    [self.networkManager getMentionInCommentsWithString:text
                                           successBlock:^(NSArray *mentionsArray) {
                                               
                                               self.mentionsArray = mentionsArray;
                                               self.isCommentsArray = !(mentionsArray.count);
                                               [self.tableView reloadData];
                                               
                                           } failureBlock:^(NSError *error) {
                                              
                                                [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                                               
                                           }];
    
    
    
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
