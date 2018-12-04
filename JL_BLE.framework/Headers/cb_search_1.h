//
//  cb_search_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

#ifndef cb_search_1_h
#define cb_search_1_h

#include "speex_bits_1.h"
#include "arch_1.h"

/** Split codebook parameters. */
typedef struct split_cb_params_1 {
    int     subvect_size;
    int     nb_subvect;
    const signed char  *shape_cb;
    int     shape_bits;
    int     have_sign;
} split_cb_params_1;


void split_cb_search_shape_sign_1(
                                jl_spx_word16_t target[],             /* target vector */
                                jl_spx_coef_t ak[],                /* LPCs for this subframe */
                                jl_spx_coef_t awk1[],              /* Weighted LPCs for this subframe */
                                jl_spx_coef_t awk2[],              /* Weighted LPCs for this subframe */
                                const void *par,                /* Codebook/search parameters */
                                int   p,                        /* number of LPC coeffs */
                                int   nsf,                      /* number of samples in subframe */
                                jl_spx_sig_t *exc,
                                jl_spx_word16_t *r,
                                SpeexBits_1 *bits,
                                char *stack,
                                int   complexity,
                                int   update_target,
                                unsigned char *tmpptr
                                );

void split_cb_shape_sign_unquant_1(
                                 jl_spx_sig_t *exc,
                                 const void *par,                /* non-overlapping codebook */
                                 int   nsf,                      /* number of samples in subframe */
                                 SpeexBits_1 *bits,
                                 char *stack,
                                 jl_spx_int32_t *seed,
                                 unsigned char *tmpptr
                                 );


void noise_codebook_quant_1(
                          jl_spx_word16_t target[],             /* target vector */
                          jl_spx_coef_t ak[],                /* LPCs for this subframe */
                          jl_spx_coef_t awk1[],              /* Weighted LPCs for this subframe */
                          jl_spx_coef_t awk2[],              /* Weighted LPCs for this subframe */
                          const void *par,                /* Codebook/search parameters */
                          int   p,                        /* number of LPC coeffs */
                          int   nsf,                      /* number of samples in subframe */
                          jl_spx_sig_t *exc,
                          jl_spx_word16_t *r,
                          SpeexBits_1 *bits,
                          char *stack,
                          int   complexity,
                          int   update_target
                          );


void noise_codebook_unquant_1(
                            jl_spx_sig_t *exc,
                            const void *par,                /* non-overlapping codebook */
                            int   nsf,                      /* number of samples in subframe */
                            SpeexBits_1 *bits,
                            char *stack,
                            jl_spx_int32_t *seed
                            );

#endif
