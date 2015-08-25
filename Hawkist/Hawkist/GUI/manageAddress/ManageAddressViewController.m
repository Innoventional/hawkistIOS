//
//  ManageAddressViewController.m
//  Hawkist
//
//  Created by Anton on 19.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "ManageAddressViewController.h"
#import "AddAddressViewController.h"
#import "AddressView.h"

@interface ManageAddressViewController () <NavigationViewDelegate,AddressViewDelegate>
@property (strong, nonatomic) IBOutlet NavigationVIew *navigation;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (strong, nonatomic) NSString* removeAddressId;
@property (nonatomic, strong) NSArray* addresses;

@property (nonatomic,strong) UIView* placeHolder;

@end

@implementation ManageAddressViewController

- (instancetype)init
{
    self = [super initWithNibName: @"ManageAddress" bundle: [NSBundle mainBundle]];
    if(self)
    {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigation.delegate = self;
    self.navigation.title.text = @"My Addresses";
    self.contentHeight.constant = self.view.height - 95;
    self.placeHolder =  [[[NSBundle mainBundle]loadNibNamed:@"defaultAddress" owner:self options:nil]firstObject];
    
    self.placeHolder.frame = CGRectMake(0, self.navigation.height, self.view.width, self.view.height - 130);
    
    
    [self.view addSubview:self.placeHolder];
    self.placeHolder.hidden = YES;
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)addNewAddress:(id)sender {
    [self.navigationController pushViewController:[[AddAddressViewController alloc]init] animated:NO];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self reload];
}


- (void) reload
{
    
    
    for(UIView* subview in [self.contentView subviews]) {
        if ([subview isKindOfClass:[AddressView class]])
            [subview removeFromSuperview];
    }
    
    [self showHud];
    
    
    
    [[NetworkManager shared]getAddresses:^(NSArray *addresses) {
        
        self.addresses = [NSArray arrayWithArray:addresses];
        float cardWidth = self.view.width - 30;
        float cardHeight = cardWidth * 127 / 293;
        
        if (addresses.count == 0){
            
            
                self.placeHolder.hidden = NO;
            

        }
        else
        {
            
                self.placeHolder.hidden = YES;
            
        
        }
        
        for (int i = 0; i<self.addresses.count; i++) {
            AddressView* address = [[AddressView alloc]initWithFrame:CGRectMake(15, i*(cardHeight+20)+15, cardWidth, cardHeight)];
            
            
            [address setAddress:(HWAddress*)[self.addresses objectAtIndex:i]];
            [self.contentView addSubview:address];
            
            address.delegate = self;
        }
        
        if (((cardHeight+20)*self.addresses.count +85)< self.view.height-95)
        {
            self.contentHeight.constant = self.view.height - 95;
            
        }
        else
        {
            self.contentHeight.constant = ((cardHeight+20)*self.addresses.count)+85;
            
        }
        
        [self hideHud];
        [self.view layoutIfNeeded];
        
    } failureBlock:^(NSError *error) {
        [self hideHud];
        
        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        
    }];
    
}

- (void)removeAction:(NSString *)addressId
{
    self.removeAddressId = addressId;
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Are you sure?" message:@"Please confirm that you wish to delete this address." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=0)
    { [self showHud];
        [[NetworkManager shared]removeAddress:self.removeAddressId successBlock:^{
            [self hideHud];
            [self reload];
            
        } failureBlock:^(NSError *error) {
            
            [self hideHud];
            [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        }];
    }
    
}


- (void)editAction:(HWAddress *)address
{
    AddAddressViewController* vc = [[AddAddressViewController alloc]initWithAddress:address];
    
    [self.navigationController pushViewController:vc animated:NO];
    
}

@end
