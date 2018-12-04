//
//  JL_BLE_Cache.h
//  AiRuiSheng
//
//  Created by DFung on 2017/3/9.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JL_BLE_Cache : UIView

@property(nonatomic,strong) NSMutableDictionary     *p_ModeInfo;
@property(nonatomic,assign) NSInteger               P_NowMode;
@property(nonatomic,assign) NSInteger               p_Power;    //设备电量（0，1，2，3）等级


@property(nonatomic,assign) NSInteger               p_Mvol;
@property(nonatomic,assign) NSInteger               P_Cvol;

@property(nonatomic,assign) NSInteger               P_Eqsl;
@property(nonatomic,assign) NSInteger               p_Eqcu;
@property(nonatomic,strong) NSArray                 *p_Eqvl;

@property(nonatomic,assign) NSInteger               p_Fmcf;
@property(nonatomic,assign) NSInteger               P_Fmcp;
@property(nonatomic,strong) NSMutableArray          *p_Fmtf;

@property(nonatomic,assign) NSInteger               p_cdev;
@property(nonatomic,assign) NSInteger               p_Plcu;     //设备播放模式
@property(nonatomic,assign) NSInteger               p_DMPlay;   //设备播放状态
@property(nonatomic,strong) NSMutableDictionary     *p_DMInfo;  //设备音乐状态信息

@property(nonatomic,assign) BOOL                    p_NIA;      //诺亚达耳机识别

+(id)sharedMe;



@end
