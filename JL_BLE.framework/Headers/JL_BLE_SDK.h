//
//  JL_BLE_SDK.h
//  AiRuiSheng
//
//  Created by DFung on 2017/3/3.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DFUnits/DFUnits.h>

#define kBT_DEVICE_FAIL_CONNECT     @"BT_DEVICE_FAIL_CONNECT"
#define kBT_DEVICES_DISCOVERED      @"BT_DEVICES_DISCOVERED"
#define kBT_DEVICE_CONNECTED        @"BT_DEVICE_CONNECTED"
#define kBT_DISCONNECTED            @"BT_DISCONNECTED"
#define kBT_CONNECTED               @"BT_CONNECTED"

#define kBT_RECIVE_DATA             @"BT_RECIVE_DATA"
#define kBT_SEND_DATA               @"BT_SEND_DATA"

#define kBT_REC_PAIR_DATA           @"BT_REC_PAIR_DATA"             //蓝牙配对数据(接收)
#define kBT_SEND_PAIR_DATA          @"BT_SEND_PAIR_DATA"            //蓝牙配对数据(发送)

#define kBT_REC_SPEEX_DATA          @"BT_REC_SPEEX_DATA"            //SPEEX配对数据(接收)

#define kBT_REC_UPDATE_DATA         @"BT_REC_UPDATE_DATA"           //固件升级数据（接收）
#define kBT_SEND_UPDATE_DATA        @"BT_SEND_UPDATE_DATA"          //固件升级数据（发送）
#define kBT_UPDATE_START            @"BT_UPDATE_START"              //开始固件升级
#define kBT_UPDATE_INFO             @"BT_UPDATE_INFO"               //固件升级信息
#define kBT_UPDATE_LOG              @"BT_UPDATE_LOG"                //固件打印信息


#define kBT_DEVICE_DISCONNECT       @"BT_DEVICE_DISCONNECT"
#define kBT_DEVICE_NOTIFY_SUCCEED   @"BT_DEVICE_NOTIFY_SUCCEED"


#define kBT_CBW_PKG                     @"BT_CBW_PKG"
#define KBT_CSW_PKG                     @"BT_CSW_PKG"
#define kBT_DATA_PKG                    @"BT_DATA_PKG"

/*--- 通用模式名字 ---*/
#define kMd_Bt_case                     @"bt_case.app"
#define kMd_Light                       @"light.app"
#define kMd_Linein                      @"linein.app"
#define kMd_Music                       @"music.app"
#define kMd_Radio                       @"radio.app"
#define kMd_Udisk                       @"udisk.app"

/*--- 错误代号 ---/
 *  字典：
 *  "status":   0x01：执行失败
 *              0x03：CRC校验失败
 *              0x04：模式错误
 *              0x05：忙状态
 *              0x06：版本不匹配，不能升级
 *              0x07：版本匹配，进入升级
 *              0x08：固件只能进入升级模式
 *              0x09：固件忙于处理多条指令
 *
 *  "reason"    0x20：设备不存在
 *              0x21：歌曲图片不存在
 *              0x22：设备错误
 *              0x23：目录操作失败
 *              0x30：非法操作
 *  "csw_tag"
 */
#define kCMD_ERR                @"CMD_ERR"

/*--- 成功代号 ---/
 *  tag:执行成功
 */
#define kCMD_SUC                @"CMD_SUC"


/*--- 自定义数据回馈 ---/
 * 用户数据
 */
#define kCMD_USER               @"CMD_USER"

/*--- 自定义命令回馈 ---/
 * 命令数据
 * 共有16Bytes，第一Byte描述op值，其余15个位命令扩展。
 */
#define kCMD_USER_1             @"CMD_USER_1"

/*--- 模式信息 ---/
 *  "bt_case.app"   = 0;
 *  "light.app"     = 2;
 *  "linein.app"    = 4;
 *  "music.app"     = 1;
 *  "radio.app"     = 3;
 *  "udisk.app"     = 5;
 */
#define kCMD_MODE               @"CMD_MODE"

/*--- 模式切换 ---/
 *  "bt_case.app"   = 0;
 *  "light.app"     = 2;
 *  "linein.app"    = 4;
 *  "music.app"     = 1;
 *  "radio.app"     = 3;
 *  "udisk.app"     = 5;
 */
#define kCMD_MODE_CHANGE        @"CMD_MODE_CHANGE"

/*--- 悬浮灯光状态 ---/
 */
#define kCMD_LIGHT              @"CMD_LIGHT"

/*--- 设备电量 ---/
 *  电量等级：0，1，2，3
 */
#define kCMD_POWER              @"CMD_POWER"

/*--- 音量返回 ---/
 *  字典:"最大音量"和"当前音量"
 */
#define kCMD_VOL_ST             @"CMD_VOL_ST"

/*--- EQ返回 ---/
 *  kFRAME_EQSL: "EQ序列"
 *  kFRAME_EQVL: "EQ值" //EQ值是60个元素的数组，每10个描述一个EQ模式。
 *  kFRAME_EQCU: "当前EQ"
 */
#define kCMD_EQ_ST              @"CMD_EQ_ST"

/*--- 当前设备切换 ---/
 *  0:SD_0
 *  1:SD_1
 *
 */
#define kCMD_CDEV_CHANGE        @"CMD_CDEV_CHANGE"

/*--- 蓝牙(手机音乐)模式下设备切歌 ---/
 *  0x00：上一曲
 *  0x01：下一曲
 *  0x02：播放
 *  0x03：暂停
 */
#define kCMD_BT_PP              @"CMD_BT_PP"

/*--- 设备音乐，播放的模式---/
 *  0x01：全设备循环
 *  0x02：单设备循环
 *  0x04：单曲循环
 *  0x08：单设备随机
 *  0x10：文件夹循环
 */
#define kCMD_PLCU               @"CMD_PLCU"

/*--- 设备音乐，状态信息---/
*  字典
*/
#define kCMD_DM_ST              @"CMD_DM_ST"

/*--- 设备音乐，音乐进度---/
 *  字典
 */
#define kCMD_DM_PROGRESS        @"CMD_DM_PROGRESS"

/*--- 设备音乐，ID3信息---/
 *  NSDATA
 */
#define kCMD_DM_ID3             @"CMD_DM_ID3"

/*--- 设备音乐，切换信息---/
 *  “action”    0x00：上一个文件
 *              0x01：下一个文件
 *              0x02：指定文件序号
 *              0x03：删除的当前文件
 */
#define kCMD_DM_FILE            @"CMD_DM_FILE"

/*--- 设备音乐，播放控制---/
 *  “action”    0x00：播放
 *              0x01：暂停
 *              0x02：快进
 *              0x03：快退
 */
#define kCMD_DM_PLAY            @"CMD_DM_PLAY"

/*--- 设备音乐，设备控制---/
 *  “action”    0x00：上一个设备
 *              0x01：下一个设备
 *              0x02：指定设备
 *              0xff：无设备（适用于【国威APP】）
 *  “number”    0x00  (返回的当前设备，只适用于cmd=0x02。)
 */
#define kCMD_DM_CTRL            @"CMD_DM_CTRL"

/*--- 设备音乐，目录数据 ---/
 *  JL_FF_Name 类数组，数组第一个为父文件夹。
 */
#define kCMD_DM_LIST            @"CMD_DM_LIST"

/*--- FM收音机，状态信息---/
 *  字典
 */
#define kCMD_FM_ST              @"CMD_FM_ST"

/*--- FM收音机，在搜索---/
 *   0x00：全频搜索
 *   0x01：向上搜索
 *   0x02：向下搜索
 *   0x03：开始搜索 (只适用于 国威APP)
 *   0x04：结束搜索 (只适用于 国威APP)
 */
#define kCMD_FM_SC              @"CMD_FM_SC"

/*--- FM收音机，控制响应---/
 *  “action”:   0x00(上一个频道)
 *              0x01(下一个频道)
 *              0x02(上一个频点)
 *              0x03(下一个频点)
 *              0x04(保存频点为频道)
 *              0x05(删除频道)
 *              0x06(选择频道)
 *              0x07(选择频点)
 *              0x08(播放)
 *              0x09(暂停)
 *  “number”: 频道序号/频点数(若频点为87.5，则填入875，只适用于cmd=0x04，0x05，0x06，0x07)
 */
#define kCMD_FM_CRTL            @"CMD_FM_CRTL"


/*--- LineIn,播放控制 ---/
 *  0x00：播放
 *  0x01：暂停
 */
#define kCMD_LINEIN_PP          @"CMD_LINEIN_PP"


/*--- uDisk,播放控制 ---/
 *  0x00：播放
 *  0x01：暂停
 *  0x02：上一曲
 *  0x03：下一曲
 */
#define kCMD_UDISK_PP           @"CMD_UDISK_PP"


/*--- Light返回 ---/
 *  字典: "EFFECT":  0：彩灯关闭
 *                  1：七彩闪烁
 *                  2：红色闪烁
 *                  3：橙色闪烁
 *                  4：黄色闪烁
 *                  5：绿色闪烁
 *                  6：青色闪烁
 *                  7：蓝色闪烁
 *                  8：紫色闪烁
 *
 *       "SPEED" :  3：快闪
 *                  2：慢闪
 *                  1：缓闪
 *                  0：音乐闪烁
 *
 *       "LMOD" :   0：灯光效果关闭
 *                  1：白光
 *                  2：彩灯
 *                  3：彩灯闪烁
 *       "LBRI"
 *       "LWHI"
 *       "LRED"
 *       "LGRR"
 *       "LBLU"
 */
#define kCMD_LIGHT_ST           @"CMD_LIGHT_ST"

/*--- 麦克风状态 ---/
 *  0x93：开
 *  0x94：关
 */
#define kCMD_MC_ST              @"CMD_MC_ST"


#pragma mark【只适用于SH6 APP】
/*--- Light返回 ---/
 *  【只适用于SH6 APP】！！！
 *   "LED_PP"       0x00:关  0x01:开
 *   "LED_LIGHT"    亮度
 *   "LED_R"        R值
 *   "LED_G"        G值
 *   "LED_B"        B值
 *   "LED_SENCE"    情景
 *   "LED_MODE"     灯模式
 *   "LED_SPEED"    闪灯速度
 */
#define kCMD_LED_ST             @"CMD_LED_ST"
#pragma mark ---------------------


#pragma mark【只适用于 诺亚达耳机 APP】
/*--- FM收音机，扫描结束---/
 *  扫描频道结束的回调
 *  “action”    0x01
 */
#define kCMD_FM_STOP            @"CMD_FM_STOP"



#pragma mark【只适用于 国威APP】

/*--- LED开关状态---/
 *  【只适用于 国威APP】！！！
 *   0x01   LED开
 *   0x00   LED关
 */
#define kCMD_GW_LED             @"CMD_GW_LED"

/*--- 机器开关状态---/
 *  【只适用于 国威APP】！！！
 *   0x01   开机
 *   0x00   关机
 */
#define kCMD_GW_PP              @"CMD_GW_PP"

/*--- 设备插入会推送 ---/
 *  【只适用于 国威APP】！！！
 *   0x00   设备为SD_0 
 *   0x01   设备为SD_1
 *   0x02   设备为UDISK_0(U盘)
 */
#define kCMD_GW_DEV             @"CMD_GW_DEV"

///*--- USB和SD卡切换 ---/
// *  【只适用于 国威APP】！！！
// *   0x00   设备不存在
// *   0x01   SD卡
// *   0x02   U盘
// */
//#define kCMD_GW_SD_USB          @"CMD_GW_SD_USB"

/*--- SD卡、USB的uuid ---/
 *  【只适用于 国威APP】！！！
 *   "DEV":
 *          0x00   设备为SD_0
 *          0x01   设备为SD_1
 *          0x02   设备为UDISK_0(U盘)
 *   "UUID":@"卡的UUID"
 */
#define kCMD_GW_UUID            @"CMD_GW_UUID"

/*--- 录音回调 ---/
 *  【只适用于 国威APP】！！！
 *   0x00   录音开始
 *   0x01   录音结束
 *   0x02   录音异常
 */
#define kCMD_GW_REC             @"CMD_GW_REC"


#pragma mark【只适用于 智能音箱App】
/*--- 开始传输SpeeX ---/
 *  【智能音箱APP】开始传输语音数据
 *  返回数组：
 *   int num_0 = [arr[0] intValue];
 *   int num_1 = [arr[1] intValue];
 *
 *   num_0：
 *      0x00 -> Sco数据
 *      0x01 -> speex数据
 *   num_1：
 *      0x00   普通语音
 *      0x01   微信互聊
 *      0x02   中 译 英
 *      0x03   英 译 中
 */
#define kCMD_SPEEX_START        @"CMD_SPEEX_START"

/*--- 结束传输SpeeX ---/
 *  【智能音箱APP】结束传输SpeeX
 */
#define kCMD_SPEEX_STOP         @"CMD_SPEEX_STOP"

/*--- 中断传输SpeeX ---/
 *  【智能音箱APP】中断传输SpeeX
 */
#define kCMD_SPEEX_BREAK        @"CMD_SPEEX_BREAK"

/*--- 中断传输SpeeX ---/
 *  【智能音箱APP】超时未说话
 */
#define kCMD_SPEEX_OUT          @"CMD_SPEEX_OUT"

/*--- 样机全部设备状态 ---/
 *  【智能音箱APP】全部设备的状态
 */
#define kCMD_ADEV_ST            @"CMD_ADEV_ST"

#pragma mark【只适用于 CMD App】
/*--- 闹钟信息 ---/
 *  【CMD APP】闹钟信息
 *   返回数组，
 */
#define kCMD_CLOCK              @"CMD_CLOCK"

#pragma mark【只适用于 CMD App】
/*--- 闹钟信息 ---/
 *  【CMD APP】闹钟最大数量
 *   int 数量
 */
#define kCMD_CLOCK_NUM          @"CMD_CLOCK_NUM"

#pragma mark【只适用于 CMD App】
/*--- 获取设备Lisence ---/
 *  【CMD APP】获取设备Lisence
 *   返回Lisence字符串
 */
#define kCMD_LISENCE            @"CMD_LISENCE"

#pragma mark【只适用于 CMD App】
/*--- 获取设备Version ---/
 *  【CMD APP】获取设备Version
 *   返回Version字符串
 */
#define kCMD_VERSION            @"CMD_VERSION"

#pragma mark【只适用于 CMD App】
/*--- 获取设备网络资源 ---/
 *  【CMD APP】获取网络资源信息。
 *   返回 1 byte。
 */
#define kCMD_NET_INFO           @"CMD_NET_INFO"

#pragma mark【只适用于 CMD App】
/*--- 获取设备网络资源 ---/
 *  【CMD APP】获取设备适配使能信息。
 *   返回 4 bytes。
 */
#define kCMD_CNF_INFO           @"CMD_CNF_INFO"

#pragma mark ---------------------





/*--- 帧数据头 ---*/
#define kFRAME_USER             @"USER" //用户自定义数据帧

#define kFRAME_MODN             @"MODN" //模式总数
#define kFRAME_MODI             @"MODI" //模式名字

#define kFRAME_TOTF             @"TOTF" //文件总数
#define kFRAME_CURF             @"CURF" //当前文件序号
#define kFRAME_FILN             @"FILN" //文件名
#define kFRAME_TOTT             @"TOTT" //总时间
#define kFRAME_SATT             @"SATT" //开始时间
#define kFRAME_CURT             @"CURT" //当前时间
#define kFRAME_SART             @"SART" //采样率
#define kFRAME_BTRT             @"BTRT" //码率
#define kFRAME_CHAL             @"CHAL" //声道

#define kFRAME_MVOL             @"MVOL" //最大音量
#define kFRAME_CVOL             @"CVOL" //当前音量

#define kFRAME_MDEV             @"MDEV" //设备总数
#define kFRAME_CDEV             @"CDEV" //当前设备
#define kFRAME_DEVN             @"DEVN" //设备名

#define kFRAME_EQSL             @"EQSL" //EQ 序列
#define kFRAME_EQVL             @"EQVL" //EQ 值
#define kFRAME_EQCU             @"EQCU" //当前EQ

#define kFRAME_FMTF             @"FMTF" //FM 频道总数
#define kFRAME_FMCF             @"FMCF" //FM 当前频道
#define kFRAME_FMCP             @"FMCP" //FM 当前频点
#define kFRAME_FSTO             @"FSTO" //FM 搜索完毕

#define kFRAME_PATH             @"PATH" //路径信息
#define kFRAME_FITP             @"FITP" //文件类型
#define kFRAME_JLID             @"JLID" //请求的ID 序列

#define kFRAME_LMOD             @"LMOD" //灯光模式
#define kFRAME_LBRI             @"LBRI" //亮度
#define kFRAME_LEFF             @"LEFF" //灯光效果
#define kFRAME_LWHI             @"LWHI" //白色
#define kFRAME_LRED             @"LRED" //红色
#define kFRAME_LGRR             @"LGRR" //绿色
#define kFRAME_LBLU             @"LBLU" //蓝色

#define kFRAME_LSCE             @"LSCE" //灯光情景模式
#define KFRAME_LBLK             @"LBLK" //闪烁序列

#define kFRAME_PLST             @"PLST" //播放状态
#define kFRAME_PLMD             @"PLMD" //播放模式序列
#define kFRAME_PLCU             @"PLCU" //当前播放模式
#define kFRAME_CLUS             @"CLUS" //文件簇号
#define kFRAME_APIC             @"APIC" //当前id3v2

#define kFRAME_LICE             @"LICE" //设备Lisence
#define kFRAME_VERN             @"VERN" //设备Version
#define kFRAME_ALMN             @"ALMN" //闹钟总数
#define kFRAME_ALMM             @"ALMM" //闹钟最大数目
#define kFRAME_ALMI             @"ALMI" //闹钟信息
#define kFRAME_NTSW             @"NTSW" //网络资源信息
#define kFRAME_ALCF             @"ALCF" //设备适配使能
#define kFRAME_ADEV             @"ADEV" //全部设备的状态


#define kLOG                    [JL_BLE_SDK logStatus]
#define kCHECK                  [JL_BLE_SDK isCheck]

@interface JL_BLE_SDK : NSObject
@property(nonatomic,assign)BOOL mlog;
@property(nonatomic,assign)BOOL mCheck;

+(BOOL)logStatus;
+(void)openLog:(BOOL)is;                        //是否打开Log（默认打开）

+(BOOL)isCheck;
+(void)openCheck:(BOOL)is;                      //是否校验设备（默认关闭）




@end






