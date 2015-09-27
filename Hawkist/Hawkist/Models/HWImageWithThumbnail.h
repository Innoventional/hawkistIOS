//
//  HWImageWithThumbnail.h
//  Hawkist
//
//  Created by Anton on 25.09.15.
//  Copyright © 2015 TecSynt Solutions. All rights reserved.
//

#import "JSONModel.h"

@protocol HWImageWithThumbnail
@end


@interface HWImageWithThumbnail : JSONModel
@property (nonatomic, strong) NSString<Optional>* image;
@property (nonatomic, strong) NSString<Optional>* thumbnail;
@end



