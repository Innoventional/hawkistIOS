//
//  AddTagsView.h
//  Hawkist
//
//  Created by Anton on 23.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagCell.h"

@protocol AddTags <NSObject>

- (void) selectedItem;
- (void) clickToPersonalisation;

@end

@interface AddTagsView : UIView <TagCell>

@property (nonatomic,strong) id<AddTags> delegate;

- (void)addTagsToView:(NSArray *)tags
         successBlock: (void (^)(void)) successBlock
         failureBlock: (void (^)(NSError* error)) failureBlock;
@end
