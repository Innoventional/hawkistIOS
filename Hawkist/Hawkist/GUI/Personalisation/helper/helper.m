//
//  helper.m
//  Hawkist
//
//  Created by Anton on 09.09.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "helper.h"
#import "TagCell.h"

@implementation helper

- (NSMutableArray*) setupTagCells:(NSArray*)tags

{
    
    NSMutableArray* tempArrayForTags = [NSMutableArray array];
    
    for (NSInteger i=0;i<tags.count;i++) {
        
        HWTag* currentTag = (HWTag*)[tags objectAtIndex:i];
        
        TagCell* cell = [[TagCell alloc]initWithName:currentTag.name tagId:currentTag.id isEnabled:NO];
        
        [tempArrayForTags addObject:cell];
    }
    return tempArrayForTags;
}

- (NSMutableArray*) convertTags:(NSArray*)tempArrayForTags andMaxWidth:(CGFloat) width withPadding:(CGFloat)paddingX
{
    NSInteger startPositionX  = 0;
    NSMutableArray* matrix = [NSMutableArray array];
    int currentLine = 0;
    
    
    for (NSInteger i=0;i<tempArrayForTags.count;i++) {
        
        
        TagCell* cell = (TagCell*)[tempArrayForTags objectAtIndex:i];
        
        
        if (startPositionX + cell.width + paddingX < width)
        {
            startPositionX+=cell.width+paddingX;
            
            if (matrix.count == currentLine) {
                [matrix addObject:[NSMutableArray array]];
            }
            
            [[matrix objectAtIndex:currentLine] addObject:cell];
            
        }
        
        else
        {
            
            [matrix addObject:[NSMutableArray array]];
            currentLine++;
            [[matrix objectAtIndex:currentLine] addObject:cell];
            startPositionX=cell.width;
        }
        
    }
    return matrix;
}

@end
