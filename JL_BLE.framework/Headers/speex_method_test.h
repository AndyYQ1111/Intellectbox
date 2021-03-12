//
//  speex_method_test.h
//  IntelligentBox
//
//  Created by DFung on 2017/11/21.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

#import <Foundation/Foundation.h>


/*--- speex文件 转成 pcm文件 --*/
int  decode_speex_run_test(void);                        //开始解码器
void decode_speex_stop_test(void);                      //关闭解码器
void decode_speex_input_test(char*inBuf, int inSize);   //传入解码数据
void decode_speex_input_data(NSData* data);
