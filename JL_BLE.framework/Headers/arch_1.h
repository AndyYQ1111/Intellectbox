//
//  arch_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

#ifndef arch_1_h
#define arch_1_h

#include "config_1.h"

#ifndef JL_SPEEX_VERSION
#define JL_SPEEX_MAJOR_VERSION 1         /**< Major Speex version. */
#define JL_SPEEX_MINOR_VERSION 1         /**< Minor Speex version. */
#define JL_SPEEX_MICRO_VERSION 15        /**< Micro Speex version. */
#define JL_SPEEX_EXTRA_VERSION ""        /**< Extra Speex version. */
#define JL_SPEEX_VERSION "speex-1.2beta3"  /**< Speex version string. */
#endif

/* A couple test to catch stupid option combinations */
#ifdef JL_FIXED_POINT

#ifdef JL_FLOATING_POINT
#error You cannot compile as floating point and fixed point at the same time
#endif
#ifdef _JL_USE_SSE
#error SSE is only for floating-point
#endif
#if ((defined (JL_ARM4_ASM)||defined (JL_ARM4_ASM)) && defined(JL_BFIN_ASM)) || (defined (JL_ARM4_ASM)&&defined(JL_ARM5E_ASM))
#error Make up your mind. What CPU do you have?
#endif
#ifdef JL_VORBIS_PSYCHO
#error Vorbis-psy model currently not implemented in fixed-point
#endif

#else

#ifndef JL_FLOATING_POINT
#error You now need to define either JL_FIXED_POINT or JL_FLOATING_POINT
#endif
#if defined (JL_ARM4_ASM) || defined(JL_ARM5E_ASM) || defined(JL_BFIN_ASM)
#error I suppose you can have a [ARM4/ARM5E/Blackfin] that has float instructions?
#endif
#ifdef JL_FIXED_POINT_DEBUG
#error "Don't you think enabling fixed-point is a good thing to do if you want to debug that?"
#endif


#endif

#ifndef JL_OUTSIDE_SPEEX
#include "speex_types_1.h"
#endif

#define ABS(x) ((x) < 0 ? (-(x)) : (x))      /**< Absolute integer value. */
#define ABS16(x) ((x) < 0 ? (-(x)) : (x))    /**< Absolute 16-bit value.  */
#define MIN16(a,b) ((a) < (b) ? (a) : (b))   /**< Maximum 16-bit value.   */
#define MAX16(a,b) ((a) > (b) ? (a) : (b))   /**< Maximum 16-bit value.   */
#define ABS32(x) ((x) < 0 ? (-(x)) : (x))    /**< Absolute 32-bit value.  */
#define MIN32(a,b) ((a) < (b) ? (a) : (b))   /**< Maximum 32-bit value.   */
#define MAX32(a,b) ((a) > (b) ? (a) : (b))   /**< Maximum 32-bit value.   */

#ifdef JL_FIXED_POINT

typedef jl_spx_int16_t jl_spx_word16_t;
typedef jl_spx_int32_t jl_spx_word32_t;
typedef jl_spx_word32_t jl_spx_mem_t;
typedef jl_spx_word16_t jl_spx_coef_t;
typedef jl_spx_word16_t jl_spx_lsp_t;
typedef jl_spx_word32_t jl_spx_sig_t;

#define JL_Q15ONE 32767

#define JL_LPC_SCALING  8192
#define JL_SIG_SCALING  16384
#define JL_LSP_SCALING  8192.
#define JL_GAMMA_SCALING 32768.
#define JL_GAIN_SCALING 64
#define JL_GAIN_SCALING_1 0.015625

#define JL_LPC_SHIFT    13
#define JL_LSP_SHIFT    13
#define JL_SIG_SHIFT    14
#define JL_GAIN_SHIFT   6

#define JL_VERY_SMALL 0
#define JL_VERY_LARGE32 ((jl_spx_word32_t)2147483647)
#define JL_VERY_LARGE16 ((jl_spx_word16_t)32767)
#define JL_Q15_ONE ((jl_spx_word16_t)32767)


#ifdef JL_FIXED_DEBUG
#include "fixed_debug.h"
#else

#include "fixed_generic_1.h"

#ifdef JL_ARM5E_ASM
#include "fixed_arm5e.h"
#elif defined (JL_ARM4_ASM)
#include "fixed_arm4.h"
#elif defined (JL_BFIN_ASM)
#include "fixed_bfin.h"
#endif

#endif


#else

typedef float jl_spx_mem_t;
typedef float jl_spx_coef_t;
typedef float jl_spx_lsp_t;
typedef float jl_spx_sig_t;
typedef float jl_spx_word16_t;
typedef float jl_spx_word32_t;

#define JL_Q15ONE 1.0f
#define JL_LPC_SCALING  1.f
#define JL_SIG_SCALING  1.f
#define JL_LSP_SCALING  1.f
#define JL_GAMMA_SCALING 1.f
#define JL_GAIN_SCALING 1.f
#define JL_GAIN_SCALING_1 1.f


#define JL_VERY_SMALL 1e-15f
#define JL_VERY_LARGE32 1e15f
#define JL_VERY_LARGE16 1e15f
#define JL_Q15_ONE ((jl_spx_word16_t)1.f)

#define JL_QCONST16(x,bits) (x)
#define JL_QCONST32(x,bits) (x)

#define JL_NEG16(x) (-(x))
#define JL_NEG32(x) (-(x))
#define JL_EXTRACT16(x) (x)
#define JL_EXTEND32(x) (x)
#define JL_SHR16(a,shift) (a)
#define JL_SHL16(a,shift) (a)
#define JL_SHR32(a,shift) (a)
#define JL_SHL32(a,shift) (a)
#define JL_PSHR16(a,shift) (a)
#define JL_PSHR32(a,shift) (a)
#define JL_VSHR32(a,shift) (a)
#define JL_SATURATE16(x,a) (x)
#define JL_SATURATE32(x,a) (x)

#define JL_PSHR(a,shift)       (a)
#define JL_SHR(a,shift)       (a)
#define JL_SHL(a,shift)       (a)
#define JL_SATURATE(x,a) (x)

#define JL_ADD16(a,b) ((a)+(b))
#define JL_SUB16(a,b) ((a)-(b))
#define JL_ADD32(a,b) ((a)+(b))
#define JL_SUB32(a,b) ((a)-(b))
#define JL_MULT16_16_16(a,b)     ((a)*(b))
#define JL_MULT16_16(a,b)     ((jl_spx_word32_t)(a)*(jl_spx_word32_t)(b))
#define JL_MAC16_16(c,a,b)     ((c)+(jl_spx_word32_t)(a)*(jl_spx_word32_t)(b))

#define JL_MULT16_32_Q11(a,b)     ((a)*(b))
#define JL_MULT16_32_Q13(a,b)     ((a)*(b))
#define JL_MULT16_32_Q14(a,b)     ((a)*(b))
#define JL_MULT16_32_Q15(a,b)     ((a)*(b))
#define JL_MULT16_32_P15(a,b)     ((a)*(b))

#define JL_MAC16_32_Q11(c,a,b)     ((c)+(a)*(b))
#define JL_MAC16_32_Q15(c,a,b)     ((c)+(a)*(b))

#define JL_MAC16_16_Q11(c,a,b)     ((c)+(a)*(b))
#define JL_MAC16_16_Q13(c,a,b)     ((c)+(a)*(b))
#define JL_MAC16_16_P13(c,a,b)     ((c)+(a)*(b))
#define JL_MULT16_16_Q11_32(a,b)     ((a)*(b))
#define JL_MULT16_16_Q13(a,b)     ((a)*(b))
#define JL_MULT16_16_Q14(a,b)     ((a)*(b))
#define JL_MULT16_16_Q15(a,b)     ((a)*(b))
#define JL_MULT16_16_P15(a,b)     ((a)*(b))
#define JL_MULT16_16_P13(a,b)     ((a)*(b))
#define JL_MULT16_16_P14(a,b)     ((a)*(b))

#define JL_DIV32_16(a,b)     (((jl_spx_word32_t)(a))/(jl_spx_word16_t)(b))
#define JL_PDIV32_16(a,b)     (((jl_spx_word32_t)(a))/(jl_spx_word16_t)(b))
#define JL_DIV32(a,b)     (((jl_spx_word32_t)(a))/(jl_spx_word32_t)(b))
#define JL_PDIV32(a,b)     (((jl_spx_word32_t)(a))/(jl_spx_word32_t)(b))


#endif


#if defined (JL_CONFIG_TI_C54X) || defined (JL_CONFIG_TI_C55X)

/* 2 on TI C5x DSP */
#define JL_BYTES_PER_CHAR 2
#define JL_BITS_PER_CHAR 16
#define JL_LOG2_BITS_PER_CHAR 4

#else

#define JL_BYTES_PER_CHAR 1
#define JL_BITS_PER_CHAR 8
#define JL_LOG2_BITS_PER_CHAR 3

#endif



#ifdef JL_FIXED_DEBUG
extern long long spx_mips;
#endif


#endif
