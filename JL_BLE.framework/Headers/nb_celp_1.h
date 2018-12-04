//
//  nb_celp_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

#ifndef nb_celp_1_h
#define nb_celp_1_h

#include "modes_1.h"
#include "speex_bits_1.h"
#include "speex_callbacks_1.h"
//#include "vbr.h"
#include "filters_1.h"

#ifdef JL_VORBIS_PSYCHO
#include "vorbis_psy.h"
#endif

#define  JL_tmpbuf_size_MACR              4096

//#define   JL_TEST_SPEEX_SELF_ED_MODE

#define  JL_SP_GAINBIT3               1
#define  JL_SP_FRAME_WORD0            0xa0
#define  JL_SP_FRAME_WORD1            0xb1
#define  JL_SP_FRAME_WORD2            0xc2
#define  JL_SP_FRAME_WORD3            0xd3
#define  JL_SP_FRAME_NUM              5


/**Structure representing the full state of the narrowband encoder*/
/**Structure representing the full state of the narrowband encoder*/
typedef struct EncState_1 {
    const SpeexMode_1 *mode;        /**< Mode corresponding to the state */
    int    first;                 /**< Is this the first frame? */
    int    frameSize;             /**< Size of frames */
    int    subframeSize;          /**< Size of sub-frames */
    int    nbSubframes;           /**< Number of sub-frames */
    int    windowSize;            /**< Analysis (LPC) window length */
    int    lpcSize;               /**< LPC order */
    int    min_pitch;             /**< Minimum pitch value allowed */
    int    max_pitch;             /**< Maximum pitch value allowed */
    
    jl_spx_word32_t cumul_gain;      /**< Product of previously used pitch gains (Q10) */
    int    bounded_pitch;         /**< Next frame should not rely on previous frames for pitch */
    int    ol_pitch;              /**< Open-loop pitch */
    int    ol_voiced;             /**< Open-loop voiced/non-voiced decision */
    int   pitch[4];
    
    jl_spx_word16_t  gamma1;         /**< Perceptual filter: A(z/gamma1) */
    jl_spx_word16_t  gamma2;         /**< Perceptual filter: A(z/gamma2) */
    jl_spx_word16_t  lpc_floor;      /**< Noise floor multiplier for A[0] in LPC analysis*/
    char  *stack;                 /**< Pseudo-stack allocation for temporary memory */
    jl_spx_word16_t winBuf[40];         /**< Input buffer (original signal) */
    jl_spx_word16_t excBuf[306];         /**< Excitation buffer */
    jl_spx_word16_t *exc;            /**< Start of excitation frame */
    jl_spx_word16_t swBuf[306];          /**< Weighted signal buffer */
    jl_spx_word16_t *sw;             /**< Start of weighted signal frame */
    const jl_spx_word16_t *window;   /**< Temporary (Hanning) window */
    const jl_spx_word16_t *lagWindow;      /**< Window applied to auto-correlation */
    jl_spx_lsp_t old_lsp[10];           /**< LSPs for previous frame */
    jl_spx_lsp_t old_qlsp[10];          /**< Quantized LSPs for previous frame */
    jl_spx_mem_t mem_sp[10];            /**< Filter memory for signal synthesis */
    jl_spx_mem_t mem_sw[10];            /**< Filter memory for perceptually-weighted signal */
    jl_spx_mem_t mem_sw_whole[10];      /**< Filter memory for perceptually-weighted signal (whole frame)*/
    jl_spx_mem_t mem_exc[10];           /**< Filter memory for excitation (whole frame) */
    jl_spx_mem_t mem_exc2[10];          /**< Filter memory for excitation (whole frame) */
    jl_spx_mem_t mem_hp[2];          /**< High-pass filter memory */
    jl_spx_word32_t pi_gain[4];        /**< Gain of LPC filter at theta=pi (fe/2) */
    jl_spx_word16_t innov_rms_save[4]; /**< If non-NULL, innovation RMS is copied here */
    
    int    complexity;            /**< Complexity setting (0-10 from least complex to most complex) */
    jl_spx_int32_t sampling_rate;
    int    plc_tuning;
    int    encode_submode;
    const SpeexSubmode_1 * const *submodes; /**< Sub-mode data */
    int    submodeID;             /**< Activated sub-mode */
    int    submodeSelect;         /**< Mode chosen by the user (may differ from submodeID if VAD is on) */
    int    isWideband;            /**< Is this used as part of the embedded wideband codec */
    int    highpass_enabled;        /**< Is the input filter enabled */
    
    jl_spx_coef_t lpc[10];
    jl_spx_coef_t bw_lpc1[10];
    jl_spx_coef_t bw_lpc2[10];
    jl_spx_lsp_t  lsp[10];
    jl_spx_lsp_t  qlsp[10];
    jl_spx_lsp_t  interp_lsp[10];
    jl_spx_lsp_t  interp_qlsp[10];
    jl_spx_coef_t interp_lpc[10];
    jl_spx_coef_t interp_qlpc[10];
    
    /*
     jl_spx_word16_t  target[40];
     jl_spx_sig_t  innov[40];
     jl_spx_word32_t  exc32[40];
     jl_spx_word16_t  ringing[40];
     jl_spx_word16_t  syn_resp[40];
     jl_spx_word16_t  real_exc[40];
     jl_spx_mem_t mem[10];
     */
    
    //lpc_to_lsp_1
    
    unsigned char Q[JL_tmpbuf_size_MACR];
    
    short in[320];
    JL_SPEEX_EN_FILE_IO audio_io;
    SpeexBits_1 bits;
    
} EncState_1;

#define  JL_RDDATA_BLOCK_SIZE      80

/**Structure representing the full state of the narrowband decoder*/
typedef struct DecState_1 {
    unsigned char rd_buf[JL_RDDATA_BLOCK_SIZE];
    unsigned char inbuf[JL_RDDATA_BLOCK_SIZE+JL_SP_FREAME_SIZE];
    const SpeexMode_1 *mode;       /**< Mode corresponding to the state */
    int    first;                /**< Is this the first frame? */
    int    count_lost;           /**< Was the last frame lost? */
    int    frameSize;            /**< Size of frames */
    int    subframeSize;         /**< Size of sub-frames */
    int    nbSubframes;          /**< Number of sub-frames */
    int    lpcSize;              /**< LPC order */
    int    min_pitch;            /**< Minimum pitch value allowed */
    int    max_pitch;            /**< Maximum pitch value allowed */
    jl_spx_int32_t sampling_rate;
    
    jl_spx_word16_t  last_ol_gain;  /**< Open-loop gain for previous frame */
    
    char  *stack;                /**< Pseudo-stack allocation for temporary memory */
    jl_spx_word16_t excBuf[500];        /**< Excitation buffer */
    jl_spx_word16_t *exc;           /**< Start of excitation frame */
    jl_spx_lsp_t old_qlsp[10];         /**< Quantized LSPs for previous frame */
    jl_spx_coef_t interp_qlpc[10];     /**< Interpolated quantized LPCs */
    jl_spx_mem_t mem_sp[10];           /**< Filter memory for synthesis signal */
    jl_spx_mem_t mem_hp[2];         /**< High-pass filter memory */
    jl_spx_word32_t pi_gain[4];       /**< Gain of LPC filter at theta=pi (fe/2) */
    jl_spx_word16_t *innov_save;    /** If non-NULL, innovation is copied here */
    
    jl_spx_word16_t level;
    jl_spx_word16_t max_level;
    jl_spx_word16_t min_level;
    
    /* This is used in packet loss concealment */
    int    last_pitch;           /**< Pitch of last correctly decoded frame */
    jl_spx_word16_t  last_pitch_gain; /**< Pitch gain of last correctly decoded frame */
    jl_spx_word16_t  pitch_gain_buf[3]; /**< Pitch gain of last decoded frames */
    int    pitch_gain_buf_idx;   /**< Tail of the buffer */
    jl_spx_int32_t seed;            /** Seed used for random number generation */
    
    int    encode_submode;
    const SpeexSubmode_1 * const *submodes; /**< Sub-mode data */
    int    submodeID;            /**< Activated sub-mode */
    int    lpc_enh_enabled;      /**< 1 when LPC enhancer is on, 0 otherwise */
    SpeexCallback_1 speex_callbacks[JL_SPEEX_MAX_CALLBACKS];
    
    SpeexCallback_1 user_callback;
    
    /*Vocoder data*/
    jl_spx_word16_t  voc_m1;
    jl_spx_word32_t  voc_m2;
    jl_spx_word16_t  voc_mean;
    int    voc_offset;
    
    int    dtx_enabled;
    int    isWideband;            /**< Is this used as part of the embedded wideband codec */
    int    highpass_enabled;        /**< Is the input filter enabled */
    
    jl_spx_sig_t innov[40];
    jl_spx_word32_t   exc32[40];
    jl_spx_coef_t   ak[10];
    jl_spx_lsp_t qlsp[10];
    jl_spx_lsp_t interp_qlsp[10];
    
    unsigned char Q[JL_tmpbuf_size_MACR];
    
    short outbuf[640];
    
    SpeexBits_1 bits;
    jl_dec_inf_t  dec_info_obj;
    
    const struct jl_if_decoder_io jl_decoder_io;
    
    u16 data_remain;
    u16  data_used;
    u32 fr_cnt;
    
    u16 frame_cnt;
    
} DecState_1;


#ifdef JL_TEST_SPEEX_SELF_ED_MODE

typedef struct TEST_ENC_SPEED_1
{
    EncState_1 st;
    DecState_1 dec;
    jl_dec_inf_t  dec_info_obj;
    const struct jl_if_decoder_io *jl_decoder_io;
}TEST_ENC_SPEED_1;

#endif



/** Initializes encoder state*/
void *nb_encoder_init_1(EncState_1 *st,const SpeexMode_1 *m,u8 complexity);

/** De-allocates encoder state resources*/
void nb_encoder_destroy_1(void *state);

/** Encodes one frame*/
u32 nb_encode_1(u8 *state);


/** Initializes decoder state*/
void *nb_decoder_init_1(DecState_1 *st,const SpeexMode_1 *m);

/** De-allocates decoder state resources*/
void nb_decoder_destroy_1(void *state);

/** Decodes one frame*/
int nb_decode_1(void *state);

/** ioctl-like function for controlling a narrowband encoder */
int nb_encoder_ctl_1(void *state, int request, void *ptr);

/** ioctl-like function for controlling a narrowband decoder */
int nb_decoder_ctl_1(void *state, int request, void *ptr);



#endif /* nb_celp_1_h */
