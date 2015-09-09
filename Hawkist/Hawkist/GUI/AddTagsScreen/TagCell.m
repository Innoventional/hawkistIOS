//
//  TagCell.m
//  Hawkist
//
//  Created by Anton on 23.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "TagCell.h"
#import "UIColor+Extensions.h"
@interface TagCell()

@property (nonatomic,assign)BOOL on;
@end

@implementation TagCell


- (instancetype) initWithName:(NSString*)text
                        tagId:(NSString*)tagId
                    isEnabled:(BOOL) enabled
{
    if (self = [super init])
    {
        UIView* sub = [[[NSBundle mainBundle]loadNibNamed:@"TagCell" owner:self options:nil]firstObject];
        
        
        CGSize myStringSize = [self getSize:text];
        
        sub.frame = CGRectMake(0, 0, myStringSize.width+30, 30);
        
        self.label.text = text;
        
//        UIImage* tmp =  self.image.image;
//        
//        [tmp resizableImageWithCapInsets: UIEdgeInsetsMake(0, self.width*0.3, 0, 0)];
//        
//        self.image.image = tmp;
//
        
        self.tagId = tagId;
        
        [self setupWithStatus:self.on];
        
        
        self.frame = sub.bounds;
        
        [self addSubview:sub];
        
        
    }
    return self;
}

- (void) setupWithStatus:(BOOL)enabled
{
    if (enabled)
    {
        self.start.image = [UIImage imageNamed:@"start_clicked"];
        self.end.image = [UIImage imageNamed:@"end_clicked"];
        self.buttomLine.hidden = YES;
        
        [self.centerView setBackgroundColor:[UIColor color256RGBWithRed:55 green:185 blue:165]];
        
        self.label.textColor = [UIColor whiteColor];
        
    }
    
    else
    {
        self.start.image = [UIImage imageNamed:@"start"];
        self.end.image = [UIImage imageNamed:@"end"];
        self.buttomLine.hidden = NO;
        
        [self.centerView setBackgroundColor:[UIColor color256RGBWithRed:255 green:255 blue:255]];
        
        self.label.textColor = [UIColor color256RGBWithRed:138 green:138 blue:138];
        
    }
}

- (IBAction)click:(id)sender {
    
    self.on = !self.on;
    
    [self setupWithStatus:self.on];
    
    if (self.delegate && [self.delegate respondsToSelector: @selector(clicked:)])
        [self.delegate clicked:self.tagId];
    
    NSLog(@"%@",self.tagId);
}


- (void) setPostion:(CGPoint)position
{
    CGRect newPosition =  self.frame;
    
    newPosition.origin.x = position.x;
    newPosition.origin.y = position.y;
    
    self.frame = newPosition;

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
