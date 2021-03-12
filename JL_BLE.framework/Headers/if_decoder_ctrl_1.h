//
//  if_decoder_ctrl_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

#ifndef if_decoder_ctrl_1_h
#define if_decoder_ctrl_1_h


#include "string.h"

#include "typedef_1.h"

//#define DECODE_NORMAL  0x00
//#define DECODE_FF      0x01
//#define DECODE_FR      0x02
//#define DECODE_STOP    0x03

#define JL_PLAY_MOD_NORMAL   0x00
#define JL_PLAY_MOD_FF   0x01
#define JL_PLAY_MOD_FB   0x02


//play control
#define JL_PLAY_FILE       0x80000000
#define JL_PLAY_CONTINUE   0x80000001
#define JL_PLAY_NEXT       0x80000002

#define JL_AUDIO_BK_EN

struct jl_if_decoder_io{
    void *priv ;
    int (*input)(void *priv ,u32 addr , void *buf, int len,u8 type);
    /*
     priv -- ˽�нṹ�壬�ɳ�ʼ�������ṩ��
     addr -- �ļ�λ��
     buf  -- �����ַ
     len  -- ���볤�� 512 ��������
     type -- 0 --ͬ�������ȵ����ݶ������������ŷ��أ� ��1 -- �첽�����������ݶ������������ͷŻأ�
     
     */
    int (*check_buf)(void *priv ,u32 addr , void *buf);
    void (*output)(void *priv  ,void *data, int len);
    u32 (*get_lslen)(void *priv);
    u32 (*store_rev_data)(void *priv,u32 addr ,int len);
};

typedef struct jl_if_decoder_io JL_IF_DECODER_IO;
typedef struct jl_decoder_inf
{
    u16 sr ;            ///< sample rate
    u16 br ;            ///< bit rate
    u32 nch ;           ///<����
    u32 total_time;     ///<��ʱ��
}jl_dec_inf_t ;


typedef struct __audio_decoder_ops_1 {
    char *name ;                                                            ///< ����������
    u32 (*open)(void *work_buf, const struct jl_if_decoder_io *jl_decoder_io, u8 *bk_point_ptr);  ///<�򿪽�����
    
    u32 (*format_check)(void *work_buf);                    ///<��ʽ���
    
    u32 (*run)(void *work_buf, u32 type);                    ///<��ѭ��
    
    jl_dec_inf_t* (*get_dec_inf)(void *work_buf) ;                ///<��ȡ������Ϣ
    u32 (*get_playtime)(void *work_buf) ;                    ///<��ȡ����ʱ��
    u32 (*get_bp_inf)(void *work_buf);                        ///<��ȡ�ϵ���Ϣ
    
    //u32 (*need_workbuf_size)() ;                            ///<��ȡ�������������buffer
    u32 (*need_dcbuf_size)() ;                               ///<��ȡ������Ҫ��buffer
    u32 (*need_rdbuf_size)();                              ///<��ȡ�������buf�Ķ��ļ�����buf�Ĵ�С
    u32 (*need_bpbuf_size)() ;                                ///<��ȡ����ϵ���Ϣ��Ҫ��buffer
    
    //void (*set_dcbuf)(void* ptr);                            ///<���ý���buffer
    //void (*set_bpbuf)(void *work_buf,void* ptr);            ///<���öϵ㱣��buffer
    
    void (*set_step)(void *work_buf,u32 step);                ///<���ÿ�����������
    void (*set_err_info)(void *work_buf,u32 cmd,u8 *ptr,u32 size);        ///<���ý���Ĵ�������
    u32 (*dec_confing)(void *work_buf,u32 cmd,void*parm);
}audio_decoder_ops_1,decoder_ops_t_1;


#endif /* if_decoder_ctrl_1_h */
