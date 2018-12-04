//
//  OTAlbumInfo.h
//  IntelligentBox
//
//  Created by Ezio on 12/03/2018.
//  Copyright © 2018 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTAlbumInfo : NSObject


@property(nonatomic,strong)NSString *coverUrl;
@property(nonatomic,strong)NSString *getId;
@property(nonatomic,strong)NSString *info;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *author;

#pragma mark<- 基于获取专辑接口才会有的 ->
@property(nonatomic,strong)NSString *author_1;
@property(nonatomic,strong)NSString *bigPicUrl;
@property(nonatomic,strong)NSString *smallPicUrl;
@property(nonatomic,assign)int      songCount;
@property(nonatomic,strong)NSString *songName;
@property(nonatomic,strong)NSString *songAuthor;
@property(nonatomic,strong)NSString *songPicUrl;
@property(nonatomic,strong)NSString *sName;
@property(nonatomic,strong)NSString *sInfo;
@property(nonatomic,strong)NSArray *songArray;
@property(nonatomic,strong)NSArray *songNameArray;
@property(nonatomic,strong)NSArray *authorArray;
@property(nonatomic,strong)NSArray *songPicArray;

@end
