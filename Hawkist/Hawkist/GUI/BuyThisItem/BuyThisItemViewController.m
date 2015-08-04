//
//  BuyThisItemViewController.m
//  Hawkist
//
//  Created by Anton on 17.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "BuyThisItemViewController.h"
#import "NetworkManager.h"
#import "HWPaymentViewController.h"


@interface BuyThisItemViewController ()
@property (nonatomic,strong) HWItem* item;
@end

@implementation BuyThisItemViewController
@synthesize navigationView;

- (instancetype) initWithItem: (HWItem*) item
{
    
    {
        UIView* v = [[[NSBundle mainBundle]loadNibNamed:@"BuyThisItem" owner:self options:nil]firstObject];
        
        v.frame = self.view.frame;
        
        [self.view addSubview:v];
        
        self.item = item;
        
        [self updateItem];
        
        navigationView.delegate = self;
        
        [navigationView.leftButtonOutlet setImage:[UIImage imageNamed:@"acdet_back"] forState:UIControlStateNormal];
        [navigationView.leftButtonOutlet setTitle:@"" forState:UIControlStateNormal];
        [navigationView.rightButtonOutlet setTitle:@"" forState:UIControlStateNormal];
        navigationView.title.text = @"Buy This Item";
        [navigationView.title setTextColor:[UIColor whiteColor]];
        navigationView.rightButtonOutlet.enabled = NO;
        
        self.bigImage.layer.cornerRadius = 5.0f;
        self.bigImage.layer.masksToBounds = YES;
        self.buyButton.layer.cornerRadius = 5.0f;
        self.buyButton.layer.masksToBounds = YES;
        self.sendButton.layer.cornerRadius = 5.0f;
        self.sendButton.layer.masksToBounds = YES;
        self.moneyField.delegate = self;
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    self.isInternetConnectionAlertShowed = NO;
}

- (void) updateItem
{
    
    self.itemTitle.text = self.item.title;
    
    self.price.text = self.item.selling_price;
    self.oldPrice.text = self.item.retail_price;
    
    self.discount.text = self.item.discount;
    if (self.item.discount == nil || [self.item.discount isEqualToString: @"0"]) {
        self.discount.text = @"1%";
    } else {
        self.discount.text = [NSString stringWithFormat:@"%@%%",self.item.discount];
    }

    [self.bigImage setImageWithURL: [NSURL URLWithString: [self.item.photos firstObject]] placeholderImage: nil];
    
    NSString* buttonTitle =  [@"BUY £" stringByAppendingString: self.price.text];
    
    [self.buyButton setTitle:buttonTitle forState:UIControlStateNormal];
  
    self.sendButton.enabled = false;
    
}

- (void) moneyField:(id)sender modifyTo:(NSString*)value
{
    if ([value doubleValue]> 0.00f)
    {
        [self.sendButton setBackgroundImage:[UIImage imageNamed:@"acdet_but"] forState:UIControlStateNormal];
        self.sendButton.enabled = TRUE;
    }
    else
    {
        [self.sendButton setBackgroundImage:nil forState:UIControlStateNormal];
        self.sendButton.enabled = false;
    }
}

- (void)moneyField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (newString.length>0)
    {
        [self.sendButton setBackgroundImage:[UIImage imageNamed:@"acdet_but"] forState:UIControlStateNormal];
        self.sendButton.enabled = TRUE;
    }
    else
    {
        [self.sendButton setBackgroundImage:nil forState:UIControlStateNormal];
        self.sendButton.enabled = false;
    }
        
}


- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated: YES];
}


- (IBAction)sendOffer:(id)sender {
    [[NetworkManager shared]OfferPrice:self.moneyField.textField.text
                                itemId:self.item.id

    successBlock:^{
        NSLog(@"added");
        [self showAlertWithTitle:@"New Price Offered" Message:@"We have notified the listing owner of your new offered price."];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    failureBlock:^(NSError *error) {
       [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        
    }];
}


#pragma mark - 
#pragma mark Action 
- (IBAction)pressBuyButton:(UIButton *)sender
{
    HWPaymentViewController *vc = [[HWPaymentViewController alloc] initWithItem:self.item];
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
