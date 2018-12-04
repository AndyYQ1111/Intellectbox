//
//  sb_celp_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

#ifndef sb_celp_1_h
#define sb_celp_1_h

#include "modes_1.h"
#include "speex_bits_1.h"
#include "nb_celp_1.h"

#define JL_QMF_ORDER 64

/**Structure representing the full state of the sub-band encoder*/
typedef struct SBEncState_1 {
    
    EncState_1  nb_st;
    const SpeexMode_1 *mode;         /**< Pointer to the mode (containing for vtable info) */
    EncState_1 *st_low;                  /**< State of the low-band (narrowband) encoder */
    int    full_frame_size;        /**< Length of full-band frames*/
    int    frame_size;             /**< Length of high-band frames*/
    int    subframeSize;           /**< Length of high-band sub-frames*/
    int    nbSubframes;            /**< Number of high-band sub-frames*/
    int    windowSize;             /**< Length of high-band LPC window*/
    int    lpcSize;                /**< Order of high-band LPC analysis */
    int    first;                  /**< First frame? */
    jl_spx_word16_t  lpc_floor;       /**< Controls LPC analysis noise floor */
    jl_spx_word16_t  gamma1;          /**< Perceptual weighting coef 1 */
    jl_spx_word16_t  gamma2;          /**< Perceptual weighting coef 2 */
    
    char  stack[JL_tmpbuf_size_MACR];                  /**< Temporary allocation stack */
    jl_spx_word16_t high[40];               /**< High-band signal (buffer) */
    jl_spx_word16_t h0_mem[JL_QMF_ORDER];
    jl_spx_word16_t h1_mem[JL_QMF_ORDER];
    
    const jl_spx_word16_t *window;    /**< LPC analysis window */
    const jl_spx_word16_t *lagWindow;       /**< Auto-correlation window */
    
    
#define  JL_LPC_SIZE_ST   10
    jl_spx_coef_t lpc[JL_LPC_SIZE_ST];
    jl_spx_coef_t interp_lpc[JL_LPC_SIZE_ST];
    jl_spx_coef_t bw_lpc1[JL_LPC_SIZE_ST];
    jl_spx_coef_t bw_lpc2[JL_LPC_SIZE_ST];
    
    jl_spx_lsp_t lsp[JL_LPC_SIZE_ST];
    jl_spx_lsp_t qlsp[JL_LPC_SIZE_ST];
    jl_spx_lsp_t interp_lsp[JL_LPC_SIZE_ST];
    jl_spx_lsp_t interp_qlsp[JL_LPC_SIZE_ST];
    
    jl_spx_word16_t autocorr[JL_LPC_SIZE_ST+1];
    jl_spx_word16_t w_sig[200];
    
    jl_spx_mem_t mem[JL_LPC_SIZE_ST];
    jl_spx_word16_t syn_resp[40];
    jl_spx_sig_t innov[40];
    jl_spx_word16_t target[40];
    
    
    jl_spx_word16_t  exc[40];
    jl_spx_word16_t  res[40];
    jl_spx_word16_t  sw[40];
    
    
    jl_spx_lsp_t old_lsp[JL_LPC_SIZE_ST];            /**< LSPs of previous frame */
    jl_spx_lsp_t old_qlsp[JL_LPC_SIZE_ST];           /**< Quantized LSPs of previous frame */
    jl_spx_coef_t interp_qlpc[JL_LPC_SIZE_ST];       /**< Interpolated quantized LPCs for current sub-frame */
    
    jl_spx_mem_t mem_sp[JL_LPC_SIZE_ST];             /**< Synthesis signal memory */
    jl_spx_mem_t mem_sp2[JL_LPC_SIZE_ST];
    jl_spx_mem_t mem_sw[JL_LPC_SIZE_ST];             /**< Perceptual signal memory */
    jl_spx_word32_t pi_gain[4];
    jl_spx_word16_t exc_rms[4];
    jl_spx_word16_t *innov_rms_save;         /**< If non-NULL, innovation is copied here */
    
    
    int    encode_submode;
    const SpeexSubmode_1 * const *submodes;
    int    submodeID;
    int    submodeSelect;
    int    complexity;
    jl_spx_int32_t sampling_rate;
    
    JL_SPEEX_EN_FILE_IO audio_io;
    SpeexBits_1 bits;
    
    u16 frame_cnt;
    
} SBEncState_1;


/**Structure representing the full state of the sub-band decoder*/
typedef struct SBDecState_1 {
    const SpeexMode_1 *mode;            /**< Pointer to the mode (containing for vtable info) */
    void *st_low;               /**< State of the low-band (narrowband) encoder */
    int    full_frame_size;
    int    frame_size;
    int    subframeSize;
    int    nbSubframes;
    int    lpcSize;
    int    first;
    jl_spx_int32_t sampling_rate;
    int    lpc_enh_enabled;
    
    char  *stack;
    jl_spx_word16_t g0_mem[JL_QMF_ORDER];
    jl_spx_word16_t g1_mem[JL_QMF_ORDER];
    
    jl_spx_word16_t excBuf[40];
    jl_spx_lsp_t old_qlsp[JL_LPC_SIZE_ST];
    jl_spx_coef_t interp_qlpc[JL_LPC_SIZE_ST];
    
    jl_spx_mem_t mem_sp[JL_LPC_SIZE_ST];
    jl_spx_word32_t pi_gain[JL_LPC_SIZE_ST];
    jl_spx_word16_t exc_rms[JL_LPC_SIZE_ST];
    //jl_spx_word16_t *innov_save;      /** If non-NULL, innovation is copied here */
    
    jl_spx_word16_t last_ener;
    jl_spx_int32_t seed;
    
    
    // unsigned char Q[JL_tmpbuf_size_MACR];
    int    encode_submode;
    const SpeexSubmode_1 * const *submodes;
    int    submodeID;
    
    DecState_1 st_dec;
    const struct jl_if_decoder_io jl_decoder_io;
    
    
    
    u16 data_remain;
    u16  data_used;
    u32 fr_cnt;
    
    
    
} SBDecState_1;


/**Initializes encoder state*/
void *sb_encoder_init_1(SBEncState_1 *st,const SpeexMode_1 *m,u8 complexity);

/**De-allocates encoder state resources*/
void sb_encoder_destroy_1(void *state);

/**Encodes one frame*/
unsigned int sb_encode_1(unsigned char *state);


/**Initializes decoder state*/
void *sb_decoder_init_1(SBDecState_1 *st,const SpeexMode_1 *m);

/**De-allocates decoder state resources*/
void sb_decoder_destroy_1(void *state);

/**Decodes one frame*/
int sb_decode_1(void *state);

int sb_encoder_ctl_1(void *state, int request, void *ptr);

int sb_decoder_ctl_1(void *state, int request, void *ptr);


#endif /* sb_celp_1_h */
