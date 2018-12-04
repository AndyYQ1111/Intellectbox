//
//  ltp_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

#ifndef ltp_1_h
#define ltp_1_h

#include "speex_bits_1.h"
#include "arch_1.h"

/** LTP parameters. */
typedef struct {
    const signed char *gain_cdbk;
    int     gain_bits;
    int     pitch_bits;
} jl_ltp_params;

#ifdef JL_FIXED_POINT
#define gain_3tap_to_1tap(g) (ABS(g[1]) + (g[0]>0 ? g[0] : -JL_SHR16(g[0],1)) + (g[2]>0 ? g[2] : -JL_SHR16(g[2],1)))
#else
#define gain_3tap_to_1tap(g) (ABS(g[1]) + (g[0]>0 ? g[0] : -.5*g[0]) + (g[2]>0 ? g[2] : -.5*g[2]))
#endif

jl_spx_word32_t inner_prod_1(const jl_spx_word16_t *x, const jl_spx_word16_t *y, int len);
void pitch_xcorr_1(const jl_spx_word16_t *_x, const jl_spx_word16_t *_y, jl_spx_word32_t *corr, int len, int nb_pitch, char *stack);

void open_loop_nbest_pitch_1(jl_spx_word16_t *sw, int start, int end, int len, int *pitch, jl_spx_word16_t *gain, int N, char *stack,unsigned char *tmpptr);


/** Finds the best quantized 3-tap pitch predictor by analysis by synthesis */
int pitch_search_3tap_1(
                      jl_spx_word16_t target[],                 /* Target vector */
                      jl_spx_word16_t *sw,
                      jl_spx_coef_t ak[],                     /* LPCs for this subframe */
                      jl_spx_coef_t awk1[],                   /* Weighted LPCs #1 for this subframe */
                      jl_spx_coef_t awk2[],                   /* Weighted LPCs #2 for this subframe */
                      jl_spx_sig_t exc[],                    /* Overlapping codebook */
                      const void *par,
                      int   start,                    /* Smallest pitch value allowed */
                      int   end,                      /* Largest pitch value allowed */
                      jl_spx_word16_t pitch_coef,               /* Voicing (pitch) coefficient */
                      int   p,                        /* Number of LPC coeffs */
                      int   nsf,                      /* Number of samples in subframe */
                      SpeexBits_1 *bits,
                      char *stack,
                      jl_spx_word16_t *exc2,
                      jl_spx_word16_t *r,
                      int   complexity,
                      int   cdbk_offset,
                      int plc_tuning,
                      jl_spx_word32_t *cumul_gain,
                      unsigned char *tmpptr
                      );

/*Unquantize adaptive codebook and update pitch contribution*/
void pitch_unquant_3tap_1(
                        jl_spx_word16_t exc[],             /* Input excitation */
                        jl_spx_word32_t exc_out[],         /* Output excitation */
                        int   start,                    /* Smallest pitch value allowed */
                        int   end,                      /* Largest pitch value allowed */
                        jl_spx_word16_t pitch_coef,        /* Voicing (pitch) coefficient */
                        const void *par,
                        int   nsf,                      /* Number of samples in subframe */
                        int *pitch_val,
                        jl_spx_word16_t *gain_val,
                        SpeexBits_1 *bits,
                        char *stack,
                        int lost,
                        int subframe_offset,
                        jl_spx_word16_t last_pitch_gain,
                        int cdbk_offset
                        );

/** Forced pitch delay and gain */
int forced_pitch_quant_1(
                       jl_spx_word16_t target[],                 /* Target vector */
                       jl_spx_word16_t *sw,
                       jl_spx_coef_t ak[],                     /* LPCs for this subframe */
                       jl_spx_coef_t awk1[],                   /* Weighted LPCs #1 for this subframe */
                       jl_spx_coef_t awk2[],                   /* Weighted LPCs #2 for this subframe */
                       jl_spx_sig_t exc[],                    /* Excitation */
                       const void *par,
                       int   start,                    /* Smallest pitch value allowed */
                       int   end,                      /* Largest pitch value allowed */
                       jl_spx_word16_t pitch_coef,               /* Voicing (pitch) coefficient */
                       int   p,                        /* Number of LPC coeffs */
                       int   nsf,                      /* Number of samples in subframe */
                       SpeexBits_1 *bits,
                       char *stack,
                       jl_spx_word16_t *exc2,
                       jl_spx_word16_t *r,
                       int complexity,
                       int cdbk_offset,
                       int plc_tuning,
                       jl_spx_word32_t *cumul_gain,
                       unsigned char *tmpptr
                       );

/** Unquantize forced pitch delay and gain */
void forced_pitch_unquant_1(
                          jl_spx_word16_t exc[],             /* Input excitation */
                          jl_spx_word32_t exc_out[],         /* Output excitation */
                          int   start,                    /* Smallest pitch value allowed */
                          int   end,                      /* Largest pitch value allowed */
                          jl_spx_word16_t pitch_coef,        /* Voicing (pitch) coefficient */
                          const void *par,
                          int   nsf,                      /* Number of samples in subframe */
                          int *pitch_val,
                          jl_spx_word16_t *gain_val,
                          SpeexBits_1 *bits,
                          char *stack,
                          int lost,
                          int subframe_offset,
                          jl_spx_word16_t last_pitch_gain,
                          int cdbk_offset
                          );
#endif /* ltp_1_h */
