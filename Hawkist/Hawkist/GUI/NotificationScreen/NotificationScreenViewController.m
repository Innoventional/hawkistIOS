//
//  NotificationScreenViewController.m
//  Hawkist
//
//  Created by Anton on 25.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "NotificationScreenViewController.h"
#import "NotificationCell.h"
#import "ViewItemViewController.h"
#import "NetworkManager.h"
#import "HWProfileViewController.h"
#import "HWMyOrdersViewController.h"
#import "HWCommentViewController.h"
#import "HWFeedBackViewController.h"
#import "HWMyBalanceViewController.h"
#import "HWLeaveFeedbackViewController.h"
#import "BuyThisItemViewController.h"
#import "HWTapBarViewController.h"


@interface NotificationScreenViewController () <UITableViewDelegate,UITableViewDataSource,NotificationCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic,assign) BOOL isAdding;
@property (nonatomic,assign) BOOL continued;
@end



@implementation NotificationScreenViewController
#define notificationCellIdentifier @"notification"

- (instancetype) init{
    
    self = [super initWithNibName: @"NotificationScreen" bundle: nil];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"NotificationCell" bundle:nil] forCellReuseIdentifier:notificationCellIdentifier];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setTintColor:[UIColor color256RGBWithRed: 55  green: 184 blue: 164]];
    [self.tableView addSubview:self.refreshControl];

}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self refresh];
}


- (void) addElements
{
    self.currentPage++;
    [self showHud];
    if (self.isAdding) {
        
    
    [[NetworkManager shared] getNotifications:self.currentPage succesBlock:^(NSArray *notifications) {
        
        if (notifications.count != 0)
        {[self.messages addObjectsFromArray:notifications];
        [self.tableView reloadData];
        [self hideHud];
        }
        else
        {
            self.isAdding = NO;
        }
        
        self.continued = NO;
    } failureBlock:^(NSError *error) {
        [self hideHud];
        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
    }];
    }
}

- (void) refresh
{
    [self showHud];
    self.currentPage = 1;
    self.isAdding = YES;
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Fetching notifications..."];
    
    [self.refreshControl beginRefreshing];
    [[NetworkManager shared] getNotifications:self.currentPage succesBlock:^(NSArray *notifications) {
        
        self.messages = [NSMutableArray arrayWithArray:notifications];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        [self hideHud];
    } failureBlock:^(NSError *error) {
        [self hideHud];
        [self.refreshControl endRefreshing];
        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count of Items == %d",self.messages.count);
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:notificationCellIdentifier forIndexPath:indexPath];
    
    HWNotification* notification = ((HWNotification*)[self.messages objectAtIndex:indexPath.row]);
    
    [cell setCellWithNotification: notification andText:[self getAttributedStringFromNotification:notification]];
    
    cell.clipsToBounds = YES;

    cell.notificationCellDelegate = self;
    [cell layoutIfNeeded];
    
    int index = indexPath.row;
    
    if (index % 20 == 0 )
        self.continued = YES;
    
    if (index % 49 == 0 && index != 0 && self.continued)
        [self addElements];
    
    
    
    return cell;
}

- (NSMutableAttributedString*) getAttributedStringFromNotification:(HWNotification*)notification
{
    NSString *text = [self getTextFromHWNotification:notification];
    
    NSMutableAttributedString *attrbText = [self attributedStringFromText:text];
    
    if (notification.user.username)
    attrbText = [self modifyUserName:notification.user.username fromText:text andAttributedString:attrbText];
    
    if (notification.listing.title)
        attrbText = [self modifyListingName:notification.listing.title fromText:text andAttributedString:attrbText];
    
    if ([notification.type integerValue] == 0)
        attrbText = [self modifyCommet:notification.comment.text fromText:text andAttributedString:attrbText];
    
    return attrbText;
}


- (NSMutableAttributedString*) modifyUserName:(NSString*)userName fromText:(NSString*)text andAttributedString:(NSMutableAttributedString*) attrStr
{
    NSMutableAttributedString* attrbStr = [[NSMutableAttributedString alloc]initWithAttributedString:attrStr];
    UIColor *colorUserName = [UIColor colorWithRed:97./255. green:97./255. blue:97./255. alpha:1];
    UIFont *fontUserName = [UIFont fontWithName:@"OpenSans-Semibold" size:15];

    NSRange rangeName = [text rangeOfString:userName];

    NSDictionary *attrs = @{ NSForegroundColorAttributeName : colorUserName, NSFontAttributeName : fontUserName ,  @"Tag" : @(1) };
    [attrbStr addAttributes:attrs
                        range:rangeName];
    return attrbStr;
}

- (NSMutableAttributedString*) modifyListingName:(NSString*)listingName fromText:(NSString*)text andAttributedString:(NSMutableAttributedString*) attrStr
{
    NSMutableAttributedString* attrbStr = [[NSMutableAttributedString alloc]initWithAttributedString:attrStr];
    UIColor *colorUserName = [UIColor colorWithRed:97./255. green:97./255. blue:97./255. alpha:1];
    UIFont *fontUserName = [UIFont fontWithName:@"OpenSans-Semibold" size:15];
    
    NSRange rangeName = [text rangeOfString:listingName];
    
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : colorUserName, NSFontAttributeName : fontUserName,  @"Tag" : @(2)   };
    [attrbStr addAttributes:attrs
                      range:rangeName];
    return attrbStr;
}

- (NSMutableAttributedString*) attributedStringFromText:(NSString*)text
{
    NSMutableAttributedString* attrbStr = [[NSMutableAttributedString alloc]initWithString:text];
    UIFont *allFont= [UIFont fontWithName:@"OpenSans" size:15];
    UIColor *allColor = [UIColor colorWithRed:97./255. green:97./255. blue:97./255. alpha:1];
    NSDictionary *allAttrib = @{ NSForegroundColorAttributeName : allColor, NSFontAttributeName : allFont  };
    NSRange range = [text rangeOfString:text];
    [attrbStr addAttributes:allAttrib
                        range:range];
    return attrbStr;
}

- (NSMutableAttributedString*) modifyCommet:(NSString*)comment fromText:(NSString*)text andAttributedString:(NSMutableAttributedString*) attrStr
{
    NSMutableAttributedString* attrbStr = [[NSMutableAttributedString alloc]initWithAttributedString:attrStr];
    UIFont *commentFont= [UIFont fontWithName:@"OpenSans" size:15];
    UIColor *commentColor = [UIColor colorWithRed:189./255. green:189./255. blue:189./255. alpha:1];
    
    NSRange range = [text rangeOfString:comment];
    
    NSRange rangeComment = (NSRange){range.location -1,range.length+2};

    
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : commentColor, NSFontAttributeName : commentFont , @"Tag" : @(3)  };
    [attrbStr addAttributes:attrs
                      range:rangeComment];
    return attrbStr;
}


- (NSString*) getTextFromHWNotification:(HWNotification*)notification
{
        NSString *text = @"";
        switch ([notification.type integerValue]) {
        case 0:
        {
            text = [NSString stringWithFormat:@"%@ commented on %@ - '%@'.",notification.user.username,notification.listing.title,notification.comment.text];
            break;
        }
            
        case 1:
        {
            text = [NSString stringWithFormat:@"Your item %@ has been sold to %@.",notification.listing.title,notification.user.username];
            break;
        }
            
        case 2:
        {
            text = [NSString stringWithFormat:@"Has %@ arrived yet? Let us know so we can pay the seller %@.",notification.listing.title,notification.user.username];
            
            break;
        }
        case 3:
            
        {
            text = [NSString stringWithFormat:@"%@ has left feedback about %@.",notification.user.username,notification.listing.title];
            break;
        }
        case 4:
        {//We have released (selling price - seller price) into your Hawkist account for (listing Title).
            
            float price = ([notification.listing.selling_price floatValue]*0.875) + [notification.listing.shipping_price floatValue];
            
            NSString* result = [NSString stringWithFormat:@"£%0.2f",price];
            
            
            text = [NSString stringWithFormat:@"We have released %@ into your Hawkist account for %@.",result,notification.listing.title];
            break;
        }
        case 5:
        {
            text = [NSString stringWithFormat:@"%@ has requested feedback on your purchase %@.",notification.user.username,notification.listing.title];
            break;
        }
        case 6:
        {
            text = [NSString stringWithFormat:@"%@ has favourited your item %@.",notification.user.username,notification.listing.title];
            break;
        }
        case 7:
        {
            
            text = [NSString stringWithFormat:@"The item %@ on your favourites list has been sold.",notification.listing.title];
            break;
        }
        case 8:
        {
            text = [NSString stringWithFormat:@"%@ is now following you.",notification.user.username];
            break;
        }
            
        case 9:
        {
            text = [NSString stringWithFormat:@"%@ has created a new listing %@.",notification.user.username,notification.listing.title];
            break;
        }
            
        case 10:
        {
            text = [NSString stringWithFormat:@"%@ has mentioned your in a comment.",notification.user.username];
            break;
        }
            
            
        case 11:
        {
            text = [NSString stringWithFormat:@"%@ has offered £%@ for %@.",notification.user.username,            notification.comment.offered_price,notification.listing.title];
            break;
        }
        case 12:
        {
            text = [NSString stringWithFormat:@"%@ has accepted the price you offered for %@. Click this notification to buy the item.",notification.user.username,notification.listing.title];
            break;
        }
        case 13:
        {
            text = [NSString stringWithFormat:@"%@ has declined the price you offered for %@. Click this notification to offer a new price.",notification.user.username,notification.listing.title];
            break;
        }
        default:
            break;
    }
    return text;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.messages)
    {
        HWNotification *notification = [self.messages objectAtIndex:indexPath.row];
        
        return [NotificationCell heightWithAttributedString:[self getAttributedStringFromNotification:notification]]+30;
    }
    else
    {
        return 70;
    }
    
}


- (void) selectedUser:(NSString*)userId
{
    HWProfileViewController *vc = [[HWProfileViewController alloc]initWithUserID:userId];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void) selectedItem:(NSString*)itemId
{
    [[NetworkManager shared] getItemById:itemId
                            successBlock:^(HWItem *item) {
                                ViewItemViewController *vc = [[ViewItemViewController alloc]initWithItem:item];
                                
                                [self.navigationController pushViewController:vc animated:YES];
                                
                            } failureBlock:^(NSError *error) {
                                [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                            }];
    
}
- (void) selectedComment:(NSString*)itemId
{
    
    [[NetworkManager shared] getItemById:itemId
                            successBlock:^(HWItem *item) {
                                HWCommentViewController* vc = [[HWCommentViewController alloc]initWithItem:item];
                                
                                [self.navigationController pushViewController:vc animated:YES];
                                
                            } failureBlock:^(NSError *error) {
                                [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                            }];
    }


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectedText:((HWNotification*)[self.messages objectAtIndex:indexPath.row])];
}

- (void) selectedText:(HWNotification *)notification
{
    switch ([notification.type integerValue]) {
        case 11: case 10: case 0:
            {
                [[NetworkManager shared] getItemById:notification.listing.id
                                        successBlock:^(HWItem *item) {
                                            HWCommentViewController* vc = [[HWCommentViewController alloc]initWithItem:item];
                                            
                                            [self.navigationController pushViewController:vc animated:YES];
                                            
                                        } failureBlock:^(NSError *error) {
                                            [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                                        }];
                break;
            }
        case 7: case 9:
        {
            [[NetworkManager shared] getItemById:notification.listing.id
                                    successBlock:^(HWItem *item) {
                                        ViewItemViewController *vc = [[ViewItemViewController alloc]initWithItem:item];
                                        
                                        [self.navigationController pushViewController:vc animated:YES];
                                        
                                    } failureBlock:^(NSError *error) {
                                        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                                    }];
                        break;
        }
        case 1:
        {
            HWTapBarViewController* vc = (HWTapBarViewController*)[self.navigationController visibleViewController];
            [vc setSold];

            break;
        }
        case 2:
        {
            HWMyOrdersViewController *vc = [[HWMyOrdersViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
                    break;
        }
            
        case 3:
        {
            HWFeedBackViewController *vc = [[HWFeedBackViewController alloc]initWithUserID:[AppEngine shared].user.id withStatus:[notification.feedback_type integerValue]];
            
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        
        case 4:
        {
            HWMyBalanceViewController  *vc = [[HWMyBalanceViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5:
        {
            
            if ([notification.order.available_feedback boolValue])
            {
            HWLeaveFeedbackViewController *vc = [[HWLeaveFeedbackViewController alloc]initWithUserID:notification.user.id withOrderId:notification.order.id];
            
            [self.navigationController pushViewController:vc animated:YES];
            }
            
            else
            {
                [self showAlertWithTitle:@"Cannot Complete Action" Message:@"You have already left feedback on this order."];
            }
            break;
        }
        case 6: case 8:
        {
            HWProfileViewController *vc = [[HWProfileViewController alloc]initWithUserID:notification.user.id];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 12:case 13:
        {
            [[NetworkManager shared] getItemById:notification.listing.id
                                    successBlock:^(HWItem *item) {
                                        BuyThisItemViewController *vc = [[BuyThisItemViewController alloc]initWithItem:item];
                                        
                                        [self.navigationController pushViewController:vc animated:YES];
                                        
                                    } failureBlock:^(NSError *error) {
                                        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
                                    }];
            break;

        }
        default:
            break;
    }
}



@end
