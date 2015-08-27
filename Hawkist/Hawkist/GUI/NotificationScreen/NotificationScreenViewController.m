//
//  NotificationScreenViewController.m
//  Hawkist
//
//  Created by Anton on 25.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "NotificationScreenViewController.h"
#import "NotificationCell.h"

@interface NotificationScreenViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *messages;

@end



@implementation NotificationScreenViewController
#define notificationCellIdentifier @"notification"

- (instancetype) init{
    
    self = [super initWithNibName: @"NotificationScreen" bundle: nil];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"NotificationCell" bundle:nil] forCellReuseIdentifier:notificationCellIdentifier];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self refresh];
}


- (void) refresh
{
    [[NetworkManager shared] getNotifications:^(NSArray *notifications) {
        
        self.messages = [NSMutableArray arrayWithArray:notifications];
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:notificationCellIdentifier forIndexPath:indexPath];
    
    HWNotification* notification = ((HWNotification*)[self.messages objectAtIndex:indexPath.row]);
    
    [cell setCellWithNotification: notification andText:[self getAttributedStringFromNotification:notification]];
    
    cell.clipsToBounds = YES;


    [cell layoutIfNeeded];
    
    
    return cell;
}

- (NSMutableAttributedString*) getAttributedStringFromNotification:(HWNotification*)notification
{
    NSString *text = [self getTextFromHWNotification:notification];
    
    NSMutableAttributedString *attrbText = [self attributedStringFromText:text];
    
    attrbText = [self modifyUserName:notification.user.username fromText:text andAttributedString:attrbText];
    
    if (notification.listing.title)
        attrbText = [self modifyUserName:notification.listing.title fromText:text andAttributedString:attrbText];
    
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

    NSDictionary *attrs = @{ NSForegroundColorAttributeName : colorUserName, NSFontAttributeName : fontUserName  };
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

    
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : commentColor, NSFontAttributeName : commentFont  };
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
            text = [NSString stringWithFormat:@"%@ commented on %@ - '%@'",notification.user.username,notification.listing.title,notification.comment.text];
            break;
        }
            
        case 1:
        {
            text = [NSString stringWithFormat:@"Your item %@ has been sold to %@",notification.listing.title,notification.user.username];
            break;
        }
            
        case 2:
        {
            text = [NSString stringWithFormat:@"Has %@ arrived yet? Let us know so we can pay the seller %@",notification.listing.title,notification.user.username];
            
            break;
        }
        case 3:
            
        {
            text = [NSString stringWithFormat:@"%@ has left feedback about %@",notification.user.username,notification.listing.title];
            break;
        }
        case 4:
        {
            text = [NSString stringWithFormat:@"%@ has declined the price you offered for %@. Click this notification to offer a new price.",notification.user.username,notification.listing.title];
            break;
        }
        case 5:
        {
            text = [NSString stringWithFormat:@"%@ has requested feedback on your purchase %@",notification.user.username,notification.listing.title];
            break;
        }
        case 6:
        {
            text = [NSString stringWithFormat:@"%@ has favourited your item %@",notification.user.username,notification.listing.title];
            break;
        }
        case 7:
        {
            
            text = [NSString stringWithFormat:@"%@ on your favourites list has been sold.",notification.listing.title];
            break;
        }
        case 8:
        {
            text = [NSString stringWithFormat:@"%@ is now following you.",notification.user.username];
            break;
        }
            
        case 9:
        {
            text = [NSString stringWithFormat:@"%@ has created a new listing %@",notification.user.username,notification.listing.title];
            break;
        }
            
        case 10:
        {
            text = [NSString stringWithFormat:@"%@ has mentioned your in a comment.",notification.user.username];
            break;
        }
            
            
        case 11:
        {
            text = [NSString stringWithFormat:@"%@ has offered £%@ for %@",notification.user.username,            notification.comment.offered_price,notification.listing.title];
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


@end
