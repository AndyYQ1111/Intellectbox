//
//  JL_BLE_Cmd.h
//  AiRuiSheng
//
//  Created by DFung on 2017/3/2.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JL_BLE_SDK.h"
#import "JL_BLE_Handle.h"
#import "JL_Cbw.h"


@interface JL_BLE_Cmd : NSObject

/**
 *  用户自定义数据。
 *  cmd: 0xB0 ~ 0xDF(建议)
 *  buf: 自定义数据
 */
+(uint32_t)cmdUser:(uint8_t)cmd Buffer:(NSData*)buf;

/**
 *  用户自定义命令。
 *  cmd: 0xB0 ~ 0xBF(建议)
 *  buf: 数据，最多15个Byte
 */
+(uint32_t)cmdUser_1:(uint8_t)cmd Buffer:(NSData*)buf;


/**
 *  自定义USER数据。
 *  op: 0xB0 ~ 0xBF(建议)
 *  buf_Op: 数据，最多15个Bytes
 *  buf_User: 用户的数据
 */
+(uint32_t)cmdUser_2:(uint8_t)op
              dataOp:(NSData*)buf_Op
            dataUser:(NSData*)buf_User;


/**
 * 获取版本。(注意：当固件功能代码被破坏，在获取版本号时，
 *               固件会直接回复命令只能进入升级模式。)
 */
+(uint32_t)cmdVersion;

/**
 * 音量调节
 * OP:  0x81：音量加;
 *      0x82：音量减
 *      0x83：音量值设定
 *
 * Value:Op=0x81\0x82:音量变化数值
 *       Op=0x83:设定值
 */
+(uint32_t)cmdVolumeOP:(uint8_t)op Value:(uint8_t)value;

/**
 * 模式切换。
 * Value:切换模式的数字
 */
+(uint32_t)cmdModeChange:(uint8_t)value;

/**
 * 获取模式。
 */
+(uint32_t)cmdModeInfo;


/**
 * EQ状态。
 */
+(uint32_t)cmdEQStatus;

/**
 * EQ控制。
 * EQ: 0x00(EQ选择)
 *     num:0x20（自定义）
 *         0x10（古典）
 *         0x08（爵士）
 *         0x04（乡村）
 *         0x02（摇滚）
 *         0x01（流行）
 *     value:NULL
 *
 * EQ: 0x01(EQ设置)
 *     num:0x20（自定义）
 *         0x10（古典）
 *         0x08（爵士）
 *         0x04（乡村）
 *         0x02（摇滚）
 *         0x01（流行）
 *     value：{-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,0,0,0} //13个数字，最后3个必须0，每个取值[-12,12]
 *
 * EQ: 0x02(EQ保存)
 *     num:0x00
 *     value:NULL
 *
 * EQ: 0x03(EQ重置)
 *     num:(0x01+0x02)（流行+摇滚）//可以多选
 *     value:NULL
 *
 * 【国威APP试用】
 * EQ: 0x04(下一个EQ)
 *     num:0x00
 *     value:NULL
 */
+(uint32_t)cmdEQ:(uint8_t)eq Num:(uint8_t)num Values:(const void *)values;

/**
 * 麦克风控制。
 * cmd: 0x93(开) 0x94(关闭)
 */
+(uint32_t)cmdMicrophoneOn_Off:(uint8_t)cmd;

#define mark 【设备音乐】部分 -------------
/**
 * 获取设备播放状态。
 */
+(uint32_t)cmdDeviceMusicPlayStatus;

/**
 * 获取设备音乐状态。
 */
+(uint32_t)cmdDeviceMusicProgressStatus;

/**
 * 设备音乐，文件选择。
 *  cmd: 0x00(上一个文件)
 *       0x01(下一个文件)
 *       0x02(指定文件序号)
 *       0x03(删除当前文件)
 *
 *  num: 0x0000(你要播放的文件序号，只适用于cmd=0x02。)
 */
+(uint32_t)cmdDeviceMusicFileCmd:(uint8_t)cmd Select:(uint16_t)num;

/**
 * 设备音乐，播放控制。
 *  cmd: 0x00(播放)
 *       0x01(暂停)
 *       0x02(快进)
 *       0x03(快退)
 */
+(uint32_t)cmdDeviceMusicPlayCmd:(uint8_t)cmd;

/**
 * 设备音乐，音乐信息。
 */
+(uint32_t)cmdDeviceMusicInfo;

/**
 * 设备音乐，设备控制。
 *  cmd: 0x00(上一个设备)
 *       0x01(下一个设备)
 *       0x02(指定设备)
 *
 *  num: 0x00(你指定的设备，只适用于cmd=0x02。)
 */
+(uint32_t)cmdDeviceMusicDEVcontrolCmd:(uint8_t)cmd Select:(uint8_t)num;

/**
 * 设备音乐，播放模式。
 *  0x01：全设备循环
 *  0x02：单设备循环
 *  0x04：单曲循环
 *  0x08：单设备随机
 *  0x10：文件夹循环
 *  0xff：切换下一个播放模式【国威APP适用】
 */
+(uint32_t)cmdDeviceMusicPlayMode:(uint8_t)cmd;

/**
 * 设备音乐，获取歌曲ID3信息。
 *  0x00：ID3V1信息
 *  0x01：ID3V2信息
 */
+(uint32_t)cmdDeviceMusicID3:(uint8_t)cmd;

/**
 * 设备音乐，文件夹浏览。
 *  f_tp：0(文件夹) 1(文件)
 *  f_cd：填1
 *  f_sn：从当前文件路径的第几个文件开始 (必须>=1)
 *
 *  f_pd：1.路径数据(使用簇号来组织路径，每级目
 *                录固定为4字节簇号（不需要
 *                斜杠分割），ROOT的簇号默认
 *                为0；如访问根目录ROOT,则
 *                PATH_DATA 为00 00 00 00
 *                ROOT/A (假如A 文件夹簇号为
 *                04) 则PATH_DATA 为00 00
 *                00 00 00 00 00 04)
 *        2.播放文件直接给一个歌曲簇号即可。
 *
 *  items：需要刷新多少文件
 *  isCache：0:APP 无缓存数据，固件重新发送
 *           1:APP 有缓存路径数据，询问固件是否可以使用。
 */
+(uint32_t)cmdDeviceMusicBrowseType:(uint8_t)f_tp
                             Format:(uint8_t)f_cd
                           StartNum:(uint32_t)f_sn
                           PathData:(NSData*)f_pd
                            ItemNum:(uint32_t)items
                            IsCahce:(uint8_t)isCache;
/**
 * 设备音乐，播放。
 *  f_tp：0(文件夹) 1(文件)
 *  f_cd：填1
 *  f_sn：从当前文件路径的第几个文件开始 (必须>=1)
 *  f_pd：路径数据(使用簇号来组织路径，每级目
 *               录固定为4字节簇号（不需要
 *               斜杠分割），ROOT的簇号默认
 *               为0；如访问根目录ROOT,则
 *               PATH_DATA 为00 00 00 00
 *               ROOT/A (假如A 文件夹簇号为
 *               04) 则PATH_DATA 为00 00
 *               00 00 00 00 00 04)
 */
//+(uint32_t)cmdDeviceMusicPlayType:(uint8_t)f_tp
//                           Format:(uint8_t)f_cd
//                         StartNum:(uint32_t)f_sn
//                         PathData:(NSData*)f_pd;


#pragma mark --------------------------------

/**
 * FM功能，获取状态。
 */
+(uint32_t)cmdFMStatus;

/**
 * FM功能，频道搜索。
 *  cmd: 0x00(全频搜索)
 *       0x01(向上搜索)
 *       0x02(向下搜索)
 *       0x05(停止搜索) (只适用于 国威APP)
 */
+(uint32_t)cmdFMSearch:(uint8_t)cmd;


/**
 * FM功能，频道控制。
 *  cmd: 0x00(上一个频道)
 *       0x01(下一个频道)
 *       0x02(上一个频点)
 *       0x03(下一个频点)
 *       0x04(保存频点为频道)
 *       0x05(删除频道)
 *       0x06(选择频道)
 *       0x07(选择频点)
 *       0x08(播放)
 *       0x09(暂停)
 *  cn: 频道序号/频点数(若频点为87.5，则填入875，只适用于cmd=0x04，0x05，0x06，0x07)
 */
+(uint32_t)cmdFMControl:(uint8_t)cmd Channel:(uint16_t)cn;


#pragma mark --------------------------------


/**
 * LineIn，状态获取。
 */
+(uint32_t)cmdLineInStatus;

/**
 * LineIn，控制。
 *  cmd: 0x00(播放)
 *       0x01(暂停)
 */
+(uint32_t)cmdLineInControl:(uint8_t)cmd;




#pragma mark --------------------------------


/**
 * uDisk声卡，状态获取。
 */
+(uint32_t)cmdUDiskStatus;

/**
 * uDisk声卡，控制。
 *  cmd: 0x00(播放)
 *       0x01(暂停)
 *       0x02(上一曲)
 *       0x03(下一曲)
 */
+(uint32_t)cmdUDiskControl:(uint8_t)cmd;


#pragma mark --------------------------------


/**
 * 悬浮灯光。
 * Value: 0(关闭)  1(打开)
 */
+(uint32_t)cmdLightOn_Off:(uint8_t)value;

/**
 * 悬浮灯 选择。
 */
+(uint8_t)cmdLightSelect;

/**
 * 灯光，【总开关】。
 */
+(uint32_t)cmdLightMain_On_Off:(uint8_t)op;

/**
 * 灯光，【白炽灯】 开关。
 */
+(uint32_t)cmdLightLamp_On_Off:(uint8_t)op;

/**
 * 灯光，【彩灯闪烁】开关。
 */
+(uint32_t)cmdLightFlash_On_Off:(uint8_t)op;

/**
 * 灯光状态获取。
 */
+(uint8_t)cmdLightStatus;

/**
 * 灯光，控制。
 *  md: 0：灯光效果关闭
 *      1：白光
 *      2：彩灯
 *      3：彩灯闪烁
 *  br: 亮度
 *  ef: (适用于md=3时。)
 *          0：彩灯关闭
 *          1：七彩闪烁
 *          2：红色闪烁
 *          3：橙色闪烁
 *          4：黄色闪烁
 *          5：绿色闪烁
 *          6：青色闪烁
 *          7：蓝色闪烁
 *          8：紫色闪烁
 *  sp: (适用于md=3时。)
 *          3：快闪
 *          2：慢闪
 *          1：缓闪
 *          0：音乐闪烁
 *  c_w:白值
 *  c_r:红值
 *  c_g:绿值
 *  c_b:蓝值
 */
+(uint32_t)cmdLightMode:(uint16_t)md
             Brightness:(uint8_t)br
                 Effect:(uint8_t)ef
                  Speed:(uint8_t)sp
                  White:(uint8_t)c_w
                    Red:(uint8_t)c_r
                  Green:(uint8_t)c_g
                   Blue:(uint8_t)c_b;



/**
 * 灯光情景模式。
 *     0：彩虹心情
 *     1：怦然心动
 *     2：激光闪烁
 *     3：灯红酒绿
 *     4：激情十分
 *     5：清新自然
 */
+(uint8_t)cmdLightSence:(uint8_t)sence;

#pragma mark --------------------------------
#pragma mark 音乐律动
+(uint32_t)cmdRhythmA:(uint8_t)cmd_A
                    B:(uint8_t)cmd_B
                    C:(uint8_t)cmd_C
                    D:(uint8_t)cmd_D;

#pragma mark --------------------------------
#pragma mark 【只适用于SH6 APP】
/**
 *  【只适用于SH6 APP】！！！
 *  切换音乐模式，可选择TF或U盘。
 *  Value:切换模式的数字
 *  dev_num: 0x01(TF卡) 0x02(U盘) 【只适用于切换"设备音乐"】
 */
+(uint32_t)cmd_SH6_ModeChange:(uint8_t)value DeviceNum:(uint8_t)dev_num;

/**
 *  【只适用于SH6 APP】！！！
 *   获取LED灯状态。
 *   "LED_PP"       0x00:关  0x01:开
 *   "LED_LIGHT"    亮度
 *   "LED_R"        R值
 *   "LED_G"        G值
 *   "LED_B"        B值
 *   "LED_SENCE"    情景
 *   "LED_MODE"     灯模式
 *   "LED_SPEED"    闪灯速度
 */
+(uint32_t)cmd_SH6_LedStatus;

/**
 *  【只适用于SH6 APP】！！！
 *   改变LED灯状态。  
 *   mode: 0x71 开关控制
 *         0x72 亮度
 *         0x73 RGB
 *         0x74 情景模式
 *         0x75 灯闪烁模式
 *         0x76 灯闪速度
 *
 *   (注意：只有在mode=0x73 RGB值方可设置。)
 */
+(uint32_t)cmd_SH6_LedMode:(uint8_t)mode
                       Num:(uint8_t)num
                         R:(uint8_t)r
                         G:(uint8_t)g
                         B:(uint8_t)b;

/**
 *  【只适用于SH6 APP】！！！
 *   设置LineIn静音。
 *   cmd: 0x78(开启静音)
 *        0x77(解除静音)
 */
+(uint32_t)cmd_SH6_LineVoice:(uint8_t)cmd;

#pragma mark --------------------------------

#pragma mark 【只适用于 国威APP】
/**
 *  【只适用于 国威APP】！！！
 *   音乐模式，切换 SD卡 或 U盘。
 *   value  : 切换模式的数字
 *   dev_num: 0x01(SD卡音乐)
 *            0x02(U盘音乐)
 */
+(uint32_t)cmd_GW_ModeChange:(uint8_t)value DeviceNum:(uint8_t)dev_num;

///**
// *  【只适用于 国威APP】！！！
// *   音乐模式，切换 SD卡 或 U盘。
// *   dev_num: 0x01(SD卡音乐)
// *            0x02(U盘音乐)
// */
//+(uint32_t)cmd_GW_ModeChange_1:(uint8_t)dev_num;

/**
 *  【只适用于 国威APP】！！！
 *   num:   
 *          0x02:LED状态查询
 *          0x01:LED开启
 *          0x00:LED关闭
 */
+(uint32_t)cmd_GW_Led:(uint8_t)num;

/**
 *  【只适用于 国威APP】！！！
 *   num:
 *          0x02:机器状态查询
 *          0x01:开机
 *          0x00:关机
 */
+(uint32_t)cmd_GW_Power:(uint8_t)num;

/**
 *  【只适用于 国威APP】！！！
 *   num:
 *          0x00:开始录音
 *          0x01:结束录音
 */
+(uint32_t)cmd_GW_FMRec:(uint8_t)num;

/**
 *  【只适用于 国威APP】！！！
 *   num:
 *          0x00: 获取SD_0卡uuid
 *          0x01: 获取SD_1卡uuid
 *          0x02: 获取USB的uuid
 */
+(uint32_t)cmd_GW_UUID:(uint8_t)num;
#pragma mark --------------------------------

#pragma mark【只适用于 点阵APP】
/**
 *  【只适用于 点阵字体】！！！
 *   对ASCII适用，7x7或者11x11
 *   mode: 0x00 7x7点阵
 *         0x01 11x11点阵
 */
+(NSData*)cmdMatrixMode:(uint8_t)mode
              Character:(char)ch;

/**
 *  【只适用于 点阵字体】！！！
 *   发送点阵数据。
 */
+(void)cmdMatrixData:(NSData*)buf;

/**
 *  【只适用于 点阵字体】！！！
 *   询问分辨率。
 */
+(uint32_t)cmdMatrixResolution;

/**
 *  【只适用于 点阵字体】！！！
 *   基础显示。
 *   num:   0x01 速度
 *          0x02 电量
 *          0x03 版本
 */
+(uint32_t)cmdMatrixBasic:(uint8_t)num;

/**
 *  【只适用于 点阵字体】！！！
 *   变化方式
 *   mode: 0x01 固定
 *         0x02 从左到右
 *         0x03 从右到左
 *         0x04 从外到内
 *         0x05 从内到外
 *         0x06 两边到中间
 *         0x07 中间到两边
 *         0x08 旋转（顺时针）
 *         0x09 旋转（逆时针）
 */
+(uint32_t)cmdMatrixMode:(uint8_t)mode;

/**
 *  【只适用于 点阵字体】！！！
 *   变化速度
 *   speed： (取值范围0~100，0 表示停止)
 */
+(uint32_t)cmdMatrixSpeed:(uint8_t)speed;
#pragma mark --------------------------------

#pragma mark【只适用于 AIMate APP】
/**
 *  【只适用于 AIMate APP】！！！A1_00
 *   告诉设备：APP已录完语音。
 */
+(uint32_t)cmdAppVoiceEnd;

/**
 *  【只适用于 AIMate APP】！！！A2_00
 *   告诉设备：APP已完成语音识别。
 */
+(uint32_t)cmdSpeexEnd;

/**
 *  【只适用于 AIMate APP】！！！A4_01
 *   告诉设备：APP正在播报。
 */
+(uint32_t)cmdNoteStart;


/**
 *  【只适用于 AIMate APP】！！！A4_00
 *   告诉设备：APP结束播报。
 */
+(uint32_t)cmdNoteEnd;

/**
 *  【只适用于 AIMate APP】！！！A6_00
 *   让设备继续语音输入。
 */
+(uint32_t)cmdSpeexInput;

/**
 *  【只适用于 AIMate APP】！！！A8_01
 *   告诉设备。
 */
+(uint32_t)cmdPhoneiOS;

/**
 *  【只适用于 AIMate APP】！！！
 *   获取样机全部设备状态。
 */
+(uint32_t)cmdExternalCard;

/**
 *  【只适用于 AIMate APP】！！！
 *   选择要获取文件目录的设备。
 *   0:SD0
 *   1:SD1
 *   2:USB
 */
+(uint32_t)cmdSelectCard:(uint8_t)num;

/**
 *  【只适用于 AIMate APP】！！！
 *   点播文件。
 *   0:SD0
 *   1:SD1
 *   2:USB
 */
+(uint32_t)cmdPlayClus:(uint32_t)clus
                Folder:(uint16_t)fd
                  Card:(uint8_t)num;

/**
 *  【只适用于 AIMate APP】！！！
 *   获取设备lisence。
 */
+(uint32_t)cmdDeviceLisence;

/**
 *  【只适用于 AIMate APP】！！！
 *   保存lisence。
 */
+(uint32_t)cmdSaveLisence:(NSString*)lisence;

#pragma mark --------------------------------


#pragma mark【只适用于 CMD APP】
/**
 *  【只适用于 CMD APP】！！！
 *   点播对应的资源音频文件。
 *   cmd:   命令号，暂定0x0000
 *   clus:  文件簇号
 *   num:   0x00 儿歌
 *          0x01 故事
 *          0x02 英语
 *          0x03 国学
 *          0x04 音乐
 *          0x05 乐器
 *          0x06 催眠曲
 */
+(uint32_t)cmdPlayCmd:(uint16_t)cmd Clus:(uint32_t)clus FileNum:(uint16_t)num;

/**
 Alarm同步时间
 
 @param nowDate Date
 @return random_tag
 */
+(uint32_t)cmdSyncAlarmClock:(NSDate *)nowDate;
/**
 获取闹钟信息
 
 @return random_tag
 */
+(uint32_t)cmdGetAlarmClock;

/**
 设置闹钟信息
 
 @param index 闹钟序号
 @param hour 时
 @param min 分
 @param mode BIT0：单次
             BIT1：星期一
             BIT2：星期二
             BIT3：星期三
             BIT4：星期四
             BIT5：星期五
             BIT6：星期六
             BIT7：星期天
 @param name 名字（最长不超过8个中文字）//闹钟名字使用GBK编码
 @param state 开关状态
 @return random_number
 */
+(uint32_t)cmdAddAlarmClockWithIndex:(uint8_t)index
                                Hour:(uint8_t)hour
                                 Min:(uint8_t)min
                          repeatMode:(uint8_t)mode
                               CName:(NSString *)name
                               State:(uint8_t)state;
/**
 删除闹钟
 
 @param index 闹钟的序号
 */
+(uint32_t)cmdAlarmClockDeleteWithIndex:(uint8_t)index;




/**
 *  【只适用于 CMD APP】！！！95_00
 *   开始固件升级。
 */
+(uint32_t)cmdFirmwareUpdate;

/**
 *  【只适用于 CMD APP】！！！96_
 *   获取网络资源信息。
 *   返回 ==> 通知“kCMD_NET_INFO”
 */
+(uint32_t)cmdResourceInfo:(uint32_t)type;

/**
 *  【只适用于 CMD APP】！！！97_
 *   获取设备适配使能信息。
 *   返回 ==> 通知“kCMD_CNF_INFO”
 */
+(uint32_t)cmdConfigInfo;

#pragma mark --------------------------------


@end
