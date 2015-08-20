//
//  TagCell.h
//  Hawkist
//
//  Created by Anton on 23.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagCell <NSObject>


- (void) clicked:(NSString*)tagId;

@end

@interface TagCell : UIView
@property (strong, nonatomic) IBOutlet UILabel *label;

@property (strong,nonatomic)id <TagCell> delegate;

- (instancetype) initWithName:(NSString*)text
                           tagId:(NSString*)tagId;


- (IBAction)click:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *buttomLine;

@property (strong, nonatomic) IBOutlet UIImageView *start;
@property (strong, nonatomic) IBOutlet UIImageView *end;
@property (strong, nonatomic) IBOutlet UIView *centerView;

@property (strong,nonatomic) NSString* tagId;
- (void) setPostion:(CGPoint)position;
@end

