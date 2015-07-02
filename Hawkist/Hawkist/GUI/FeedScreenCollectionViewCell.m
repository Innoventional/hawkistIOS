//
//  FeedScreenCollectionViewCell.m
//  FeedScreen
//
//  Created by Evgen Bootcov on 25.06.15.
//  Copyright (c) 2015 Evgen Bootcov. All rights reserved.
//

#import "FeedScreenCollectionViewCell.h"

@implementation FeedScreenCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    
    
    
    //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundCell"]];
 
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
}

@end
