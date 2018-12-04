//
//  speex_buffer_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

#ifndef speex_buffer_1_h
#define speex_buffer_1_h

#include "speex_types_1.h"

#ifdef __cplusplus
extern "C" {
#endif
    
    struct JL_SpeexBuffer_;
    typedef struct JL_SpeexBuffer_ JL_SpeexBuffer;
    
    JL_SpeexBuffer *speex_buffer_init_1(int size);
    
    void speex_buffer_destroy_1(JL_SpeexBuffer *st);
    
    int speex_buffer_write_1(JL_SpeexBuffer *st, void *data, int len);
    
    int speex_buffer_writezeros_1(JL_SpeexBuffer *st, int len);
    
    int speex_buffer_read_1(JL_SpeexBuffer *st, void *data, int len);
    
    int speex_buffer_get_available_1(JL_SpeexBuffer *st);
    
    int speex_buffer_resize_1(JL_SpeexBuffer *st, int len);
    
#ifdef __cplusplus
}
#endif

#endif
