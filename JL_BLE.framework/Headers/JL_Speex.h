//
//  JL_Speex.h
//  JL_BLE
//
//  Created by DFung on 2017/11/30.
//  Copyright © 2017年 DFung. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "os_support_1.h"
#include "speex_types_1.h"
#include "lpc_1.h"
#include "speex_callbacks_1.h"
#include "modes_1.h"
#include "speex_header_1.h"
#include "sb_celp_1.h"
#include "Speex_1.h"
#include "arch_1.h"
#include "speex_buffer_1.h"
#include "stack_alloc_1.h"
#include "if_decoder_ctrl_1.h"
#include "typedef_1.h"
#include "quant_lsp_1.h"
#include "speex_encode_api_1.h"
#include "vq_1.h"
#include "speex_bits_1.h"
#include "ltp_1.h"
#include "filters_1.h"
#include "math_approx_1.h"
#include "lsp_1.h"
#include "config_1.h"
#include "cb_search_1.h"
#include "nb_celp_1.h"
#include "fixed_generic_1.h"




@interface JL_Speex : NSObject


/**
 * 将【杰理】speex文件解压成pcm文件。
 *  sp: 杰理speex文件路径；
 *  op: pcm文件路径；
 */
+(int)speex:(NSString*)sp OutPcm:(NSString*)op;

/**
 * 将【杰理】speex数据解压成pcm数据。
 *  enData: 杰理speex数据；
 *  return: pcm数据；
 */
+(NSData*)speex:(NSData*)enData;

@end
