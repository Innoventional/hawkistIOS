//
//  TagCell.m
//  Hawkist
//
//  Created by Anton on 23.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "TagCell.h"

@implementation TagCell

- (instancetype) initWithName:(NSString*)text
                        tagId:(NSString*)tagId;
{
    if (self = [super init])
    {
        UIView* sub = [[[NSBundle mainBundle]loadNibNamed:@"TagCell" owner:self options:nil]firstObject];
        
        
        CGSize myStringSize = [self getSize:text];
        
        sub.frame = CGRectMake(0, 0, myStringSize.width*1.5, myStringSize.height*2.5);
        
        self.label.text = text;
        
//        UIImage* tmp =  self.image.image;
//        
//        [tmp resizableImageWithCapInsets: UIEdgeInsetsMake(0, self.width*0.3, 0, 0)];
//        
//        self.image.image = tmp;
//
        
        self.tagId = tagId;
        
        
        
        self.frame = sub.bounds;
        
        [self addSubview:sub];
        
        
    }
    return self;
}

- (IBAction)click:(id)sender {
    
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
