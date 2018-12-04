//
//  lsp_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

//#ifndef lsp_1_h
//#define lsp_1_h

#ifndef __AK2LSPD__
#define __AK2LSPD__

#include "arch_1.h"

int lpc_to_lsp_1 (jl_spx_coef_t *a, int lpcrdr, jl_spx_lsp_t *freq, int nb, jl_spx_word16_t delta, char *stack,unsigned char *tmpptr);
void lsp_to_lpc_1(jl_spx_lsp_t *freq, jl_spx_coef_t *ak, int lpcrdr, char *stack,unsigned char *tmpptr);

/*Added by JMV*/
void lsp_enforce_margin_1(jl_spx_lsp_t *lsp, int len, jl_spx_word16_t margin);

void lsp_interpolate_1(jl_spx_lsp_t *old_lsp, jl_spx_lsp_t *new_lsp, jl_spx_lsp_t *interp_lsp, int len, int subframe, int nb_subframes);

#endif    /* __AK2LSPD__ */
