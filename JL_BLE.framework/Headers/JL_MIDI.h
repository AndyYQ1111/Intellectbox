//
//  JL_MIDI.h
//  JL_BLE
//
//  Created by DFung on 2017/6/30.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DFUnits/DFUnits.h>

typedef void(^MIDI_Block)(int ret);

@interface JL_MIDI : NSObject
/**
 * 杰理MIDI文件解码成wav。
 *  m_path: midi文件路径
 *  w_path: wav文件路径
 *  s_path: spi文件路径
 *
 *  result:
 *     返回0： 解码完毕
 *     返回1： m_path打开读失败，或者 w_path打开写失败
 *     返回2： midi文件格式检查不通过
 *     返回3： s_path打开失败，可能是路径错误
 */
+(void)midi:(NSString*)m_path
      toWav:(NSString*)w_path
        Spi:(NSString*)s_path
     result:(MIDI_Block)result;

/**
 * 杰理MIDI文件解码成wav。
 *  m_paths: 所有midi文件路径
 *  w_path : 生成在wav文件夹的路径
 *  s_path : spi文件路径
 *
 *  result:
 *     返回0： 解码完毕
 *     返回1： m_path打开读失败，或者 w_path打开写失败
 *     返回2： midi文件格式检查不通过
 *     返回3： s_path打开失败，可能是路径错误
 */
+(void)allMidi:(NSArray*)m_paths
         toWav:(NSString*)w_path
           Spi:(NSString*)s_path
        result:(MIDI_Block)result;


/**
 * 杰理将MIDI文件合成syd格式文件(后缀.res)。
 *  m_paths: MIDI文件数组
 *  s_path : syd文件路径
 *
 *  result:
 *     返回0：打包完成
 */
+(void)midis:(NSArray*)m_paths
         syd:(NSString*)s_path
      result:(MIDI_Block)result;









@end
