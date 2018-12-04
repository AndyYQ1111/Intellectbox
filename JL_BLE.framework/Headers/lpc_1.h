//
//  lpc_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

#ifndef lpc_1_h
#define lpc_1_h

#include "arch_1.h"

void _spx_autocorr_1(
                   const jl_spx_word16_t * x,   /*  in: [0...n-1] samples x   */
                   jl_spx_word16_t *ac,   /* out: [0...lag-1] ac values */
                   int lag, int   n);

jl_spx_word32_t                      /* returns minimum mean square error    */
_spx_lpc_1(
         jl_spx_coef_t       * lpc, /*      [0...p-1] LPC coefficients      */
         const jl_spx_word16_t * ac,  /*  in: [0...p] autocorrelation values  */
         int p
         );


#endif /* lpc_1_h */
