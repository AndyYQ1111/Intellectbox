//
//  speex_encode_api_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

#include "typedef_1.h"
#include "if_decoder_ctrl_1.h"

#ifndef speex_encode_api_1_h
#define speex_encode_api_1_h

typedef struct _JL_SPEEX_EN_FILE_IO_
{
    void *priv;
    u16 (*input_data)(void *priv,s16 *buf,u16 len);           //����ĳ����Ƕ��ٸ�short
    void (*output_data)(void *priv,u8 *buf,u16 len);         //����ĳ����Ƕ��ٸ�bytes
}JL_SPEEX_EN_FILE_IO;


typedef struct __SPEEX_ENC_OPS_1 {
    u32 (*need_buf)();
    void (*open)(u8 *ptr,JL_SPEEX_EN_FILE_IO *audioIO,u8 complexity);
    u32 (*run)(u8 *ptr);
}speex_enc_ops_1;


//int  test_andrio_addfun_gcc_1(int a1,int a2);

extern speex_enc_ops_1 *get_speex_enc_obj_1();         //����
extern audio_decoder_ops_1 *get_speex_ops_1();         //����

#endif


#if 0

//�������ʾ��
{
    jl_speex_enc_ops *tst_ops=get_speex_enc_obj_1();
    bufsize=tst_ops->need_buf();
    st=malloc(bufsize);
    tst_ops->open(st,&speex_en_io,0);
    while(!tst_ops->run(st))               //����������ʱ��ͻ᷵��1�ˡ�
    {
    }
    free(st);
}


//��������ʾ������������ʽ����ӿ�ͳһ
{
    audio_decoder_ops_1  *testdec_ops=get_speex_ops_1();
    bufsize=testdec_ops->need_dcbuf_size(&tmp);
    dec=malloc(bufsize);
    testdec_ops->open(dec,&speex_dec_io,NULL);
    
    while(!testdec_ops->run(dec,0))
    {
    }
    free(dec);
    
}



#endif
