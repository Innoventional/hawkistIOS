//
//  AddTagsView.m
//  Hawkist
//
//  Created by Anton on 23.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "AddTagsView.h"
#import "TagCell.h"

@interface AddTagsView()

@property (nonatomic,weak) NSArray* tags;
@property (nonatomic,assign)NSInteger startPositionX;
@property (nonatomic,assign)NSInteger startPositionY;

@end

@implementation AddTagsView

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
    }
    return self;
}



- (void) addTagsToView:(NSArray *)tags
{
    self.startPositionX = 20;
    self.startPositionY = 0;
    
    self.tags = tags;
    for (NSInteger i=0;i<self.tags.count;i++) {
        
        TagCell* cell = [[TagCell alloc]init];
        
        CGSize myStringSize = [self getSize:[tags objectAtIndex:i]];
        
        
        if ( (self.startPositionX+myStringSize.width+80) < self.width - 20)
        {
        
            cell.frame = CGRectMake(self.startPositionX, self.startPositionY, myStringSize.width + 80, 30);
            
            cell.label.text = [tags objectAtIndex:i];
            
            self.startPositionX += cell.frame.size.width +20;
            [self addSubview:cell];
        
        }
        else
        {
            self.startPositionY += 50;
            self.startPositionX = 20;
            cell.frame = CGRectMake(self.startPositionX, self.startPositionY, myStringSize.width + 80, 30);
            
            cell.label.text = [tags objectAtIndex:i];
            
            self.startPositionX += cell.frame.size.width+20;
            [self addSubview:cell];

        }
    }
}


- (CGSize) getSize:(NSString*) string
{
    
    CGSize maximumSize = CGSizeMake(300, 9999);
    NSString *myString = string;
    UIFont *myFont = [UIFont fontWithName:@"OpenSans" size:12];
    CGSize myStringSize = [myString sizeWithFont:myFont
                               constrainedToSize:maximumSize
                                   lineBreakMode:NSLineBreakByWordWrapping];
    
    
    return myStringSize;
}

@end
