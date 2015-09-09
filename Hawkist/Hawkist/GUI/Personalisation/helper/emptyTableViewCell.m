//
//  emptyTableViewCell.m
//  Hawkist
//
//  Created by Anton on 09.09.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "emptyTableViewCell.h"
#import "TagCell.h"

@interface emptyTableViewCell() <TagCell>
@property (strong, nonatomic) IBOutlet UIView *content;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@end

@implementation emptyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setup:(NSMutableArray*) tagCells
{
    int startPosition = 0;
    for (int i=0;i<[tagCells count];i++) {
        TagCell* c = [tagCells objectAtIndex:i];
        
        [c setPostion:CGPointMake(startPosition, 9)];
        startPosition+=c.width+17;
        [self.content addSubview:c];
        c.delegate = self;
    }
    
    float width = startPosition-17;
    self.widthConstraint.constant = width;
    [self layoutIfNeeded];
    
}

- (void)clicked:(NSString *)tagId withStatus:(BOOL)status
{
    if (status)
    {
    if (self.delegate && [self.delegate respondsToSelector: @selector(setEnable:)])
        [self.delegate setEnable:tagId];
        NSLog(@"Send On");
        
        
    }
    else
        
    {
        if (self.delegate && [self.delegate respondsToSelector: @selector(setDisable:)])
            [self.delegate setDisable:tagId];
        NSLog(@"SendOff");
    }

}

@end
