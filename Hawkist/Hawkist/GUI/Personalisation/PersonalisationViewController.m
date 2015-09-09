//
//  PersonalisationViewController.m
//  Hawkist
//
//  Created by Anton on 06.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "PersonalisationViewController.h"
#import "TagCell.h"
#import "helper.h"
#import "emptyTableViewCell.h"

@interface PersonalisationViewController () <UITableViewDataSource,UITableViewDelegate,emptyTableViewCell>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray* matrix;
@end

@implementation PersonalisationViewController
#define CellIdentifier @"CELL"

- (instancetype)initWithTags:(NSMutableArray*)tags
{
    self = [super initWithNibName: @"PersonalisationView" bundle: [NSBundle mainBundle]];
    if(self)
    {
        helper *h = [[helper alloc]init];
        
        NSMutableArray* cells = [h setupTagCells:[NSArray arrayWithArray:tags]];
        
        self.matrix = [h convertTags:cells andMaxWidth:self.view.width withPadding:17];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigation.delegate = self;
    self.navigation.title.text = @"Personalisation Settings";
    self.tableView.estimatedRowHeight = 47;
    self.tableView.allowsSelection = NO;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"emptyCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



    
    
    
- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.matrix count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{


    emptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSMutableArray* tagCells = [self.matrix objectAtIndex:indexPath.row];
    
    [cell setup:tagCells];
    
    cell.delegate = self;
    

    
    return cell;
}

- (void)setDisable:(NSString *)tagId
{

    [[NetworkManager shared]removeTagFromFeed:tagId successBlock:^{
        
        
    } failureBlock:^(NSError *error) {
        
        [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        
    }];
    
}

- (void) setEnable:(NSString *)tagId
{
        [[NetworkManager shared]addTagToFeed:tagId successBlock:^{
            
            
        } failureBlock:^(NSError *error) {
            
            [self showAlertWithTitle:error.domain Message:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
            
        }];
}

@end
