//
//  MusicMainModel.m
//  IntelligentBox
//
//  Created by KW on 2018/8/9.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "MusicMainModel.h"

@implementation MusicMainModel
+ (NSValueTransformer *)rollingColumnsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MainColumnsModel class]];
}
+ (NSValueTransformer *)classicColumnsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MainColumnsModel class]];
}
+ (NSValueTransformer *)regionColumnsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[RegionColumnsModel class]];
}
@end

@implementation MainColumnsModel

@end

@implementation RegionColumnsModel
+ (NSValueTransformer *)sonColumnsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MainColumnsModel class]];
}
@end

//
@implementation AlbumsListModel
+ (NSValueTransformer *)dataJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MainColumnsModel class]];
}
@end

//
@implementation SearchResultModel
+ (NSValueTransformer *)dataJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SearchDataModel class]];
}
@end

@implementation SearchDataModel

@end

//
@implementation AnswerModel
+ (NSValueTransformer *)audioListJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[AudioListModel class]];
}
@end

@implementation AudioListModel

@end


