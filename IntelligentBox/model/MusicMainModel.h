//
//  MusicMainModel.h
//  IntelligentBox
//
//  Created by KW on 2018/8/9.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

#import "DYBaseModel.h"

@interface MusicMainModel : DYBaseModel
@property (nonatomic, copy) NSString *result;
@property (nonatomic, strong) NSArray *rollingColumns;
@property (nonatomic, strong) NSArray *classicColumns;
@property (nonatomic, strong) NSArray *regionColumns;
@end

@interface MainColumnsModel : DYBaseModel
@property (nonatomic, copy) NSString *catId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *catType;
@property (nonatomic, copy) NSString *jpgUrl;
@end

@interface RegionColumnsModel : DYBaseModel
@property (nonatomic, copy) NSString *catId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *sonColumns;
@end

//专辑列表
@interface AlbumsListModel : DYBaseModel
@property (nonatomic, copy) NSString *result;
@property (nonatomic, strong) NSArray *data;
@end

//首页搜索结果
@interface SearchResultModel : DYBaseModel
@property (nonatomic, copy) NSString *result;
@property (nonatomic, strong) NSArray *data;
@end


@interface SearchDataModel : DYBaseModel
@property (nonatomic, copy) NSString *trackId; //音频资源的id
@property (nonatomic, copy) NSString *playUrl; //url地址
@property (nonatomic, copy) NSString *title; //标题
@property (nonatomic, copy) NSString *duration; //时长
@property (nonatomic, copy) NSString *jpgUrl; //封面地址
@property (nonatomic, copy) NSString *isCherish; //是否收藏
@property (nonatomic, assign) BOOL isPlaying;
@end

//交互结果
@interface AnswerModel : DYBaseModel
@property (nonatomic, copy) NSString *result;
//交互服务器回复的字符串，APP在交互的界面上直接进行显示
@property (nonatomic, copy) NSString *answerText;
@property (nonatomic, copy) NSString *answerAudioUrl;
@property (nonatomic, strong) NSArray *audioList;
@property (nonatomic, strong) NSString *tag;

//和闹钟相关
@property (nonatomic, copy) NSString *repeat;//1 重复 0不重复
@property (nonatomic, copy) NSString *dateTime;//闹钟时间
@property (nonatomic, copy) NSString *content;//应该是设置闹钟 干嘛？如 喝水
@property (nonatomic, copy) NSString *servcie;


@end

@interface AudioListModel : DYBaseModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *playUrl;
@end
