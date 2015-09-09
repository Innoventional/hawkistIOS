//
//  HWTags.h
//  Hawkist
//
//  Created by Anton on 07.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol HWTag
@end

@protocol HWCategory
@end


@protocol HWSubCategories
@end

@protocol HWCondition
@end

@interface HWTag : JSONModel

@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* item_description;
@property (nonatomic, strong) NSString* image_url;
@property (nonatomic, strong) NSArray<HWCategory,Optional>* categories;
@property (nonatomic, strong) NSString<Optional>* available;
@end

@interface HWCategory : JSONModel
@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSString* name;
@property (nonatomic,assign) NSInteger parent_id;
@property (nonatomic, strong) NSArray<HWSubCategories,Optional>* subcategories;
@end

@interface HWSubCategories : JSONModel
@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSString* name;
@property (nonatomic,assign) NSInteger parent_id;
//@property (nonatomic, strong) NSArray<HWColor,Optional>* color;
@property (nonatomic, strong) NSArray<HWCondition,Optional>* condition;
@end

//@interface HWColor : JSONModel
//@property (nonatomic, strong) NSString<Optional>* id;
//@property (nonatomic, strong) NSString<Optional>* name;
//@property (nonatomic,assign) NSInteger parent_id;
//@property (nonatomic, strong) NSString<Optional>* code;
//@end


@interface HWCondition : JSONModel
@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSString* name;
@property (nonatomic,assign) NSInteger parent_id;
@end



