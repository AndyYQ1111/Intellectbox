//
//  vq_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

#ifndef vq_1_h
#define vq_1_h

#include "arch_1.h"

int scal_quant_1(jl_spx_word16_t in, const jl_spx_word16_t *boundary, int entries);
int scal_quant32_1(jl_spx_word32_t in, const jl_spx_word32_t *boundary, int entries);

#ifdef _JL_USE_SSE
#include <xmmintrin.h>
void vq_nbest_1(jl_spx_word16_t *in, const __m128 *codebook, int len, int entries, __m128 *E, int N, int *nbest, jl_spx_word32_t *best_dist, char *stack);

void vq_nbest_sign_1(jl_spx_word16_t *in, const __m128 *codebook, int len, int entries, __m128 *E, int N, int *nbest, jl_spx_word32_t *best_dist, char *stack);
#else
void vq_nbest_1(jl_spx_word16_t *in, const jl_spx_word16_t *codebook, int len, int entries, jl_spx_word32_t *E, int N, int *nbest, jl_spx_word32_t *best_dist, char *stack);

void vq_nbest_sign_1(jl_spx_word16_t *in, const jl_spx_word16_t *codebook, int len, int entries, jl_spx_word32_t *E, int N, int *nbest, jl_spx_word32_t *best_dist, char *stack);
#endif

#endif
