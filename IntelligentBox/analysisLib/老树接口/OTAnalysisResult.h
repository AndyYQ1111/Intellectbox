//
//  OTAnalysisResult.h
//  IntelligentBox
//
//  Created by Ezio on 12/03/2018.
//  Copyright © 2018 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTAnalysisResult : NSObject

@property(nonatomic,strong)NSString *talkUrl;
@property(nonatomic,strong)NSString *songUrl;
@property(nonatomic,strong)NSString *talkValue;
@property(nonatomic,strong)NSString *songName;
@property(nonatomic,strong)NSString *songAuthor;
@property(nonatomic,strong)NSString *songSmallPicturl;
@property(nonatomic,strong)NSString *songBigPicturl;
@property(nonatomic,strong)NSString *songId;
@property(nonatomic,strong)NSString *albumId;
@property(nonatomic,assign)int songTimelen;
@property(nonatomic,assign)int field;
@property(nonatomic,assign)int intention;
@property(nonatomic,strong)NSString *intentionParam1;
@property(nonatomic,strong)NSString *intentionParam2;


@end
