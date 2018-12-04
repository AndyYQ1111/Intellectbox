//
//  modes_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

#ifndef modes_1_h
#define modes_1_h

#include "Speex_1.h"
#include "speex_bits_1.h"
#include "arch_1.h"

#define JL_NB_SUBMODES 16
#define JL_NB_SUBMODE_BITS 4

#define JL_SB_SUBMODES 8
#define JL_SB_SUBMODE_BITS 3

/* Used internally, NOT TO BE USED in applications */
/** Used internally*/
#define JL_SPEEX_GET_PI_GAIN 100
/** Used internally*/
#define JL_SPEEX_GET_EXC     101
/** Used internally*/
#define JL_SPEEX_GET_INNOV   102
/** Used internally*/
#define JL_SPEEX_GET_DTX_STATUS   103
/** Used internally*/
#define JL_SPEEX_SET_INNOVATION_SAVE   104
/** Used internally*/
#define JL_SPEEX_SET_WIDEBAND   105

/** Used internally*/
#define JL_SPEEX_GET_STACK   106


/** Quantizes LSPs */
typedef void (*lsp_quant_func_1)(jl_spx_lsp_t *, jl_spx_lsp_t *, int, SpeexBits_1 *);

/** Decodes quantized LSPs */
typedef void (*lsp_unquant_func_1)(jl_spx_lsp_t *, int, SpeexBits_1 *);


/** Long-term predictor quantization */
typedef int (*ltp_quant_func_1)(jl_spx_word16_t *, jl_spx_word16_t *, jl_spx_coef_t *, jl_spx_coef_t *,
                              jl_spx_coef_t *, jl_spx_sig_t *, const void *, int, int, jl_spx_word16_t,
                              int, int, SpeexBits_1*, char *, jl_spx_word16_t *, jl_spx_word16_t *, int, int, int, jl_spx_word32_t *);

/** Long-term un-quantize */
typedef void (*ltp_unquant_func_1)(jl_spx_word16_t *, jl_spx_word32_t *, int, int, jl_spx_word16_t, const void *, int, int *,
                                 jl_spx_word16_t *, SpeexBits_1*, char*, int, int, jl_spx_word16_t, int);


/** Innovation quantization function */
typedef void (*innovation_quant_func_1)(jl_spx_word16_t *, jl_spx_coef_t *, jl_spx_coef_t *, jl_spx_coef_t *, const void *, int, int,
                                      jl_spx_sig_t *, jl_spx_word16_t *, SpeexBits_1 *, char *, int, int);

/** Innovation unquantization function */
typedef void (*innovation_unquant_func_1)(jl_spx_sig_t *, const void *, int, SpeexBits_1*, char *, jl_spx_int32_t *);

/** Description of a Speex sub-mode (wither narrowband or wideband */
typedef struct SpeexSubmode_1 {
    int     lbr_pitch;          /**< Set to -1 for "normal" modes, otherwise encode pitch using a global pitch and allowing a +- lbr_pitch variation (for low not-rates)*/
    int     forced_pitch_gain;  /**< Use the same (forced) pitch gain for all sub-frames */
    int     have_subframe_gain; /**< Number of bits to use as sub-frame innovation gain */
    int     double_codebook;    /**< Apply innovation quantization twice for higher quality (and higher bit-rate)*/
    /*LSP functions*/
    lsp_quant_func_1    lsp_quant; /**< LSP quantization function */
    lsp_unquant_func_1  lsp_unquant; /**< LSP unquantization function */
    
    /*Long-term predictor functions*/
    ltp_quant_func_1    ltp_quant; /**< Long-term predictor (pitch) quantizer */
    ltp_unquant_func_1  ltp_unquant; /**< Long-term predictor (pitch) un-quantizer */
    const void       *ltp_params; /**< Pitch parameters (options) */
    
    /*Quantization of innovation*/
    innovation_quant_func_1 innovation_quant; /**< Innovation quantization */
    innovation_unquant_func_1 innovation_unquant; /**< Innovation un-quantization */
    const void             *innovation_params; /**< Innovation quantization parameters*/
    
    jl_spx_word16_t      comb_gain;  /**< Gain of enhancer comb filter */
    
    int               bits_per_frame; /**< Number of bits per frame after encoding*/
} SpeexSubmode_1;

/** Struct defining the encoding/decoding mode*/
typedef struct SpeexNBMode_1 {
    int     frameSize;      /**< Size of frames used for encoding */
    int     subframeSize;   /**< Size of sub-frames used for encoding */
    int     lpcSize;        /**< Order of LPC filter */
    int     pitchStart;     /**< Smallest pitch value allowed */
    int     pitchEnd;       /**< Largest pitch value allowed */
    
    jl_spx_word16_t gamma1;    /**< Perceptual filter parameter #1 */
    jl_spx_word16_t gamma2;    /**< Perceptual filter parameter #2 */
    jl_spx_word16_t   lpc_floor;      /**< Noise floor for LPC analysis */
    
    const SpeexSubmode_1 *submodes[JL_NB_SUBMODES]; /**< Sub-mode data for the mode */
    int     defaultSubmode; /**< Default sub-mode to use when encoding */
    int     quality_map[11]; /**< Mode corresponding to each quality setting */
} SpeexNBMode_1;


/** Struct defining the encoding/decoding mode for SB-CELP (wideband) */
typedef struct SpeexSBMode_1 {
    const SpeexMode_1 *nb_mode;    /**< Embedded narrowband mode */
    int     frameSize;     /**< Size of frames used for encoding */
    int     subframeSize;  /**< Size of sub-frames used for encoding */
    int     lpcSize;       /**< Order of LPC filter */
    jl_spx_word16_t gamma1;   /**< Perceptual filter parameter #1 */
    jl_spx_word16_t gamma2;   /**< Perceptual filter parameter #1 */
    jl_spx_word16_t   lpc_floor;     /**< Noise floor for LPC analysis */
    jl_spx_word16_t   folding_gain;
    
    const SpeexSubmode_1 *submodes[JL_SB_SUBMODES]; /**< Sub-mode data for the mode */
    int     defaultSubmode; /**< Default sub-mode to use when encoding */
    int     low_quality_map[11]; /**< Mode corresponding to each quality setting */
    int     quality_map[11]; /**< Mode corresponding to each quality setting */
#ifndef JL_DISABLE_VBR
    const float (*vbr_thresh)[11];
#endif
    int     nb_modes;
} SpeexSBMode_1;

int speex_encode_native_1(void *state, jl_spx_word16_t *in, SpeexBits_1 *bits);
int speex_decode_native_1(void *state, SpeexBits_1 *bits, jl_spx_word16_t *out);

int nb_mode_query_1(const void *mode, int request, void *ptr);
int wb_mode_query_1(const void *mode, int request, void *ptr);

#endif
