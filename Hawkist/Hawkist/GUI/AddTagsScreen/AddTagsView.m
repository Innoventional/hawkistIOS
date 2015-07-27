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


- (void) clicked:(NSString *)tagId
{
    
    [[NetworkManager shared]addTagToFeed:tagId successBlock:^{
        
        if (self.delegate && [self.delegate respondsToSelector: @selector(selectedItem)])
            [self.delegate selectedItem];
        
    } failureBlock:^(NSError *error) {
        NSLog(error.domain);
        
    }];
    
   
    
    
}

- (void)addTagsToView:(NSArray *)tags
         successBlock: (void (^)(void)) successBlock
         failureBlock: (void (^)(NSError* error)) failureBlock;
{
    self.startPositionX = 0;
    self.startPositionY = 0;
    
    [[self subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.tags = tags;
    
    NSMutableArray* tempArrayForTags = [NSMutableArray array];
    
    for (NSInteger i=0;i<self.tags.count;i++) {
        
        HWTag* currentTag = (HWTag*)[self.tags objectAtIndex:i];
        
        TagCell* cell = [[TagCell alloc]initWithName:currentTag.name tagId:currentTag.id];
        
        //[cell setPostion:CGPointMake(0, i*30)];
        
        cell.delegate = self;
        
        [tempArrayForTags addObject:cell];
//        [self addSubview:cell];
        
    }
    
    
    
    for (NSInteger i=0;i<tempArrayForTags.count;i++) {
        
        
        TagCell* cell = (TagCell*)[tempArrayForTags objectAtIndex:i];
        
        if (![self.subviews containsObject:cell])
            [self addSubview:cell];
       
        if (self.startPositionX + cell.width + 17 < self.width)
        {
            [cell setPostion:CGPointMake(self.startPositionX, self.startPositionY)];
            
            self.startPositionX+=cell.width+17;
            
        }
        
        else
        {
            
            [self reorganizationLine:tempArrayForTags
                        currentIndex:(NSInteger) i
                          horizontal:(NSInteger) self.startPositionY];
            
            
            self.startPositionX = 0;
            self.startPositionY += 55;
            
            [cell setPostion:CGPointMake(self.startPositionX, self.startPositionY)];
             self.startPositionX+=cell.width+17;

        }
        
       
        
        
    }
    
    if (tempArrayForTags.count == 1)
    {
    
    [self reorganizationLine:tempArrayForTags
                currentIndex:(NSInteger) tempArrayForTags.count
                  horizontal:(NSInteger) self.startPositionY];

    }
    
    successBlock();
    
}


- (void) reorganizationLine:(NSMutableArray*)allTags
               currentIndex:(NSInteger) index
                 horizontal:(NSInteger) position
{
    
    NSMutableArray* previousLineTags = [NSMutableArray array];
    
    for (NSInteger j=0;j<index;j++)
    {
        TagCell* c = (TagCell*)[allTags objectAtIndex:j];
        
        if (c.frame.origin.y == position)
        {
            [previousLineTags addObject:c];
        }
        
    }
    
    if (previousLineTags.count == 1)
        
    {
        TagCell* c = (TagCell*)[previousLineTags lastObject];
        [c setPostion: CGPointMake((self.frame.size.width - c.width)/2, c.y)];
        return;
        
    }
    
    TagCell* lastTag = (TagCell*)[previousLineTags lastObject];
    
    float freeSpace = self.width - (lastTag.width+lastTag.x);
    
    float differ = freeSpace / previousLineTags.count;
    
    
    for (NSInteger j=0; j<previousLineTags.count; j++) {
        
        TagCell* c = (TagCell*)[previousLineTags objectAtIndex:j];
        
        //[c setPostion: CGPointMake(c.+differ*j, c.y)];
        
        CGRect rect = c.frame;
        
        rect.size.width+=differ;
        
        if (j!=0)
            rect.origin.x += differ*j;
        
        c.frame = rect;
        
    }
}




@end
