//
//  helper.h
//  Hawkist
//
//  Created by Anton on 09.09.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface helper : NSObject

- (NSMutableArray*) setupTagCells:(NSArray*)tags;
- (NSMutableArray*) convertTags:(NSArray*)tempArrayForTags andMaxWidth:(CGFloat) width withPadding:(CGFloat)paddingX;

@end
