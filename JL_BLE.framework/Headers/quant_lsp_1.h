//
//  quant_lsp_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

#ifndef quant_lsp_1_h
#define quant_lsp_1_h

#include "speex_bits_1.h"
#include "arch_1.h"

#define JL_MAX_LSP_SIZE 20

#define JL_NB_CDBK_SIZE 64
#define JL_NB_CDBK_SIZE_LOW1 64
#define JL_NB_CDBK_SIZE_LOW2 64
#define JL_NB_CDBK_SIZE_HIGH1 64
#define JL_NB_CDBK_SIZE_HIGH2 64

/*Narrowband codebooks*/
extern const signed char cdbk_nb_1[];
extern const signed char cdbk_nb_low1_1[];
extern const signed char cdbk_nb_low2_1[];
extern const signed char cdbk_nb_high1_1[];
extern const signed char cdbk_nb_high2_1[];

/* Quantizes narrowband LSPs with 30 bits */
void lsp_quant_nb_1(jl_spx_lsp_t *lsp, jl_spx_lsp_t *qlsp, int order, SpeexBits_1 *bits);

/* Decodes quantized narrowband LSPs */
void lsp_unquant_nb_1(jl_spx_lsp_t *lsp, int order, SpeexBits_1 *bits);

/* Quantizes low bit-rate narrowband LSPs with 18 bits */
void lsp_quant_lbr_1(jl_spx_lsp_t *lsp, jl_spx_lsp_t *qlsp, int order, SpeexBits_1 *bits);

/* Decodes quantized low bit-rate narrowband LSPs */
void lsp_unquant_lbr_1(jl_spx_lsp_t *lsp, int order, SpeexBits_1 *bits);

/* Quantizes high-band LSPs with 12 bits */
void lsp_quant_high_1(jl_spx_lsp_t *lsp, jl_spx_lsp_t *qlsp, int order, SpeexBits_1 *bits);

/* Decodes high-band LSPs */
void lsp_unquant_high_1(jl_spx_lsp_t *lsp, int order, SpeexBits_1 *bits);

#endif
