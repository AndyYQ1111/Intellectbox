//
//  filters_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

#ifndef filters_1_h
#define filters_1_h

#include "arch_1.h"

jl_spx_word16_t compute_rms_1(const jl_spx_sig_t *x, int len);
jl_spx_word16_t compute_rms16_1(const jl_spx_word16_t *x, int len);
void signal_mul_1(const jl_spx_sig_t *x, jl_spx_sig_t *y, jl_spx_word32_t scale, int len);
void signal_div_1(const jl_spx_word16_t *x, jl_spx_word16_t *y, jl_spx_word32_t scale, int len);

#ifdef JL_FIXED_POINT

int normalize16_1(const jl_spx_sig_t *x, jl_spx_word16_t *y, jl_spx_sig_t max_scale, int len);

#endif


#define JL_HIGHPASS_NARROWBAND 0
#define JL_HIGHPASS_WIDEBAND 2
#define JL_HIGHPASS_INPUT 0
#define JL_HIGHPASS_OUTPUT 1
#define JL_HIGHPASS_IRS 4

void highpass_1(const jl_spx_word16_t *x, jl_spx_word16_t *y, int len, int filtID, jl_spx_mem_t *mem);


void qmf_decomp_1(const jl_spx_word16_t *xx, const jl_spx_word16_t *aa, jl_spx_word16_t *, jl_spx_word16_t *y2, int N, int M, jl_spx_word16_t *mem, unsigned char *stack);
void qmf_synth_1(const jl_spx_word16_t *x1, const jl_spx_word16_t *x2, const jl_spx_word16_t *a, jl_spx_word16_t *y, int N, int M, jl_spx_word16_t *mem1, jl_spx_word16_t *mem2, char *stack);

void filter_mem16_1(const jl_spx_word16_t *x, const jl_spx_coef_t *num, const jl_spx_coef_t *den, jl_spx_word16_t *y, int N, int ord, jl_spx_mem_t *mem, char *stack);
void iir_mem16_1(const jl_spx_word16_t *x, const jl_spx_coef_t *den, jl_spx_word16_t *y, int N, int ord, jl_spx_mem_t *mem, char *stack);
void fir_mem16_1(const jl_spx_word16_t *x, const jl_spx_coef_t *num, jl_spx_word16_t *y, int N, int ord, jl_spx_mem_t *mem, char *stack);

/* Apply bandwidth expansion on LPC coef */
void bw_lpc_1(jl_spx_word16_t , const jl_spx_coef_t *lpc_in, jl_spx_coef_t *lpc_out, int order);
void sanitize_values32_1(jl_spx_word32_t *vec, jl_spx_word32_t min_val, jl_spx_word32_t max_val, int len);


void syn_percep_zero16_1(const jl_spx_word16_t *xx, const jl_spx_coef_t *ak, const jl_spx_coef_t *awk1, const jl_spx_coef_t *awk2, jl_spx_word16_t *y, int N, int ord, char *stack,unsigned char *tmpptr);
void residue_percep_zero16_1(const jl_spx_word16_t *xx, const jl_spx_coef_t *ak, const jl_spx_coef_t *awk1, const jl_spx_coef_t *awk2, jl_spx_word16_t *y, int N, int ord, char *stack);

void compute_impulse_response_1(const jl_spx_coef_t *ak, const jl_spx_coef_t *awk1, const jl_spx_coef_t *awk2, jl_spx_word16_t *y, int N, int ord, char *stack,unsigned char *tmpptr);

void multicomb_1(
               jl_spx_word16_t *exc,          /*decoded excitation*/
               jl_spx_word16_t *new_exc,      /*enhanced excitation*/
               jl_spx_coef_t *ak,           /*LPC filter coefs*/
               int p,               /*LPC order*/
               int nsf,             /*sub-frame size*/
               int pitch,           /*pitch period*/
               int max_pitch,   /*pitch gain (3-tap)*/
               jl_spx_word16_t  comb_gain,    /*gain of comb filter*/
               char *stack,
               unsigned char *tmpptr
               );

#endif
