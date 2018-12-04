//
//  math_approx_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

#ifndef math_approx_1_h
#define math_approx_1_h

#include "arch_1.h"

#ifndef JL_FIXED_POINT

#define jl_spx_sqrt sqrt
#define jl_spx_acos acos
#define jl_spx_exp exp
#define jl_spx_cos_norm(x) (cos((.5f*M_PI)*(x)))
#define jl_spx_atan atan

/** Generate a pseudo-random number */
static inline jl_spx_word16_t speex_rand_1(jl_spx_word16_t std, jl_spx_int32_t *seed)
{
    const unsigned int jflone = 0x3f800000;
    const unsigned int jflmsk = 0x007fffff;
    union {int i; float f;} ran;
    *seed = 1664525 * *seed + 1013904223;
    ran.i = jflone | (jflmsk & *seed);
    ran.f -= 1.5;
    return 3.4642*std*ran.f;
}


#endif


static inline jl_spx_int16_t spx_ilog2_1(jl_spx_uint32_t x)
{
    int r=0;
    if (x>=(jl_spx_int32_t)65536)
    {
        x >>= 16;
        r += 16;
    }
    if (x>=256)
    {
        x >>= 8;
        r += 8;
    }
    if (x>=16)
    {
        x >>= 4;
        r += 4;
    }
    if (x>=4)
    {
        x >>= 2;
        r += 2;
    }
    if (x>=2)
    {
        r += 1;
    }
    return r;
}

static inline jl_spx_int16_t spx_ilog4_1(jl_spx_uint32_t x)
{
    int r=0;
    if (x>=(jl_spx_int32_t)65536)
    {
        x >>= 16;
        r += 8;
    }
    if (x>=256)
    {
        x >>= 8;
        r += 4;
    }
    if (x>=16)
    {
        x >>= 4;
        r += 2;
    }
    if (x>=4)
    {
        r += 1;
    }
    return r;
}

#ifdef JL_FIXED_POINT

/** Generate a pseudo-random number */
static inline jl_spx_word16_t speex_rand_1(jl_spx_word16_t std, jl_spx_int32_t *seed)
{
    jl_spx_word32_t res;
    *seed = 1664525 * *seed + 1013904223;
    res = JL_MULT16_16(JL_EXTRACT16(JL_SHR32(*seed,16)),std);
    return JL_EXTRACT16(JL_PSHR32(JL_SUB32(res, JL_SHR32(res, 3)),14));
}

/* sqrt(x) ~= 0.22178 + 1.29227*x - 0.77070*x^2 + 0.25723*x^3 (for .25 < x < 1) */
/*#define JL_C0 3634
 #define JL_C1 21173
 #define JL_C2 -12627
 #define JL_C3 4215*/

/* sqrt(x) ~= 0.22178 + 1.29227*x - 0.77070*x^2 + 0.25659*x^3 (for .25 < x < 1) */
#define JL_C0 3634
#define JL_C1 21173
#define JL_C2 -12627
#define JL_C3 4204

static inline jl_spx_word16_t jl_spx_sqrt(jl_spx_word32_t x)
{
    int k;
    jl_spx_word32_t rt;
    /*
     k = spx_ilog4_1(x)-6;
     x = JL_VSHR32(x, (k<<1));
     rt = JL_ADD16(JL_C0, JL_MULT16_16_Q14(x, JL_ADD16(JL_C1, JL_MULT16_16_Q14(x, JL_ADD16(JL_C2, JL_MULT16_16_Q14(x, (JL_C3)))))));
     rt = JL_VSHR32(rt,7-k);
     */
    k = spx_ilog4_1(x)-6;
    x = JL_VSHR32(x, (k<<1));
    rt = JL_C0 + (x * (JL_C1 + (x * (JL_C2 + (JL_C3*x>>14))>>14))>>14);
    rt = JL_VSHR32(rt,7-k);
    
    
    
    return rt;
    
    
    
}

/* log(x) ~= -2.18151 + 4.20592*x - 2.88938*x^2 + 0.86535*x^3 (for .5 < x < 1) */


#define JL_A1 16469
#define JL_A2 2242
#define JL_A3 1486

static inline jl_spx_word16_t jl_spx_acos(jl_spx_word16_t x)
{
    int s=0;
    jl_spx_word16_t ret;
    jl_spx_word16_t sq;
    if (x<0)
    {
        s=1;
        x = JL_NEG16(x);
    }
    x = JL_SUB16(16384,x);
    
    x = x >> 1;
    sq = JL_MULT16_16_Q13(x, JL_ADD16(JL_A1, JL_MULT16_16_Q13(x, JL_ADD16(JL_A2, JL_MULT16_16_Q13(x, (JL_A3))))));
    ret = jl_spx_sqrt(JL_SHL32(JL_EXTEND32(sq),13));
    
    /*ret = jl_spx_sqrt(67108864*(-1.6129e-04 + 2.0104e+00*f + 2.7373e-01*f*f + 1.8136e-01*f*f*f));*/
    if (s)
        ret = JL_SUB16(25736,ret);
    return ret;
}


#define JL_K1 8192
#define JL_K2 -4096
#define JL_K3 340
#define JL_K4 -10

static inline jl_spx_word16_t jl_spx_cos(jl_spx_word16_t x)
{
    jl_spx_word16_t x2;
    
    if (x<12868)
    {
        x2 = JL_MULT16_16_P13(x,x);
        return JL_ADD32(JL_K1, JL_MULT16_16_P13(x2, JL_ADD32(JL_K2, JL_MULT16_16_P13(x2, JL_ADD32(JL_K3, JL_MULT16_16_P13(JL_K4, x2))))));
    } else {
        x = JL_SUB16(25736,x);
        x2 = JL_MULT16_16_P13(x,x);
        return JL_SUB32(-JL_K1, JL_MULT16_16_P13(x2, JL_ADD32(JL_K2, JL_MULT16_16_P13(x2, JL_ADD32(JL_K3, JL_MULT16_16_P13(JL_K4, x2))))));
    }
}

#define JL_L1 32767
#define JL_L2 -7651
#define JL_L3 8277
#define JL_L4 -626

static inline jl_spx_word16_t _jl_spx_cos_pi_2(jl_spx_word16_t x)
{
    jl_spx_word16_t x2;
    
    x2 = JL_MULT16_16_P15(x,x);
    return JL_ADD16(1,MIN16(32766,JL_ADD32(JL_SUB16(JL_L1,x2), JL_MULT16_16_P15(x2, JL_ADD32(JL_L2, JL_MULT16_16_P15(x2, JL_ADD32(JL_L3, JL_MULT16_16_P15(JL_L4, x2))))))));
}

static inline jl_spx_word16_t jl_spx_cos_norm(jl_spx_word32_t x)
{
    x = x&0x0001ffff;
    if (x>JL_SHL32(JL_EXTEND32(1), 16))
        x = JL_SUB32(JL_SHL32(JL_EXTEND32(1), 17),x);
    if (x&0x00007fff)
    {
        if (x<JL_SHL32(JL_EXTEND32(1), 15))
        {
            return _jl_spx_cos_pi_2(JL_EXTRACT16(x));
        } else {
            return JL_NEG32(_jl_spx_cos_pi_2(JL_EXTRACT16(65536-x)));
        }
    } else {
        if (x&0x0000ffff)
            return 0;
        else if (x&0x0001ffff)
            return -32767;
        else
            return 32767;
    }
}

/*
 K0 = 1
 K1 = log(2)
 K2 = 3-4*log(2)
 K3 = 3*log(2) - 2
 */
#define JL_D0 16384
#define JL_D1 11356
#define JL_D2 3726
#define JL_D3 1301
/* Input in Q11 format, output in Q16 */
static inline jl_spx_word32_t jl_spx_exp2(jl_spx_word16_t x)
{
    int integer;
    jl_spx_word16_t frac;
    integer = JL_SHR16(x,11);
    if (integer>14)
        return 0x7fffffff;
    else if (integer < -15)
        return 0;
    frac = JL_SHL16(x-JL_SHL16(integer,11),3);
    frac = JL_ADD16(JL_D0, JL_MULT16_16_Q14(frac, JL_ADD16(JL_D1, JL_MULT16_16_Q14(frac, JL_ADD16(JL_D2 , JL_MULT16_16_Q14(JL_D3,frac))))));
    return JL_VSHR32(JL_EXTEND32(frac), -integer-2);
}

/* Input in Q11 format, output in Q16 */
static inline jl_spx_word32_t jl_spx_exp(jl_spx_word16_t x)
{
    if (x>21290)
        return 0x7fffffff;
    else if (x<-21290)
        return 0;
    else
        return jl_spx_exp2(JL_MULT16_16_P14(23637,x));
}
#define JL_M1 32767
#define JL_M2 -21
#define JL_M3 -11943
#define JL_M4 4936

static inline jl_spx_word16_t jl_spx_atan01(jl_spx_word16_t x)
{
    return JL_MULT16_16_P15(x, JL_ADD32(JL_M1, JL_MULT16_16_P15(x, JL_ADD32(JL_M2, JL_MULT16_16_P15(x, JL_ADD32(JL_M3, JL_MULT16_16_P15(JL_M4, x)))))));
}

#undef JL_M1
#undef JL_M2
#undef JL_M3
#undef JL_M4

/* Input in Q15, output in Q14 */
static inline jl_spx_word16_t jl_spx_atan(jl_spx_word32_t x)
{
    if (x <= 32767)
    {
        return JL_SHR16(jl_spx_atan01(x),1);
    } else {
        int e = spx_ilog2_1(x);
        if (e>=29)
            return 25736;
        x = JL_DIV32_16(JL_SHL32(JL_EXTEND32(32767),29-e), JL_EXTRACT16(JL_SHR32(x, e-14)));
        return JL_SUB16(25736, JL_SHR16(jl_spx_atan01(x),1));
    }
}
#else

#ifndef M_PI
#define M_PI           3.14159265358979323846  /* pi */
#endif

#define JL_C1 0.9999932946f
#define JL_C2 -0.4999124376f
#define JL_C3 0.0414877472f
#define JL_C4 -0.0012712095f


#define JL_SPX_PI_2 1.5707963268
static inline jl_spx_word16_t jl_spx_cos(jl_spx_word16_t x)
{
    if (x<JL_SPX_PI_2)
    {
        x *= x;
        return JL_C1 + x*(JL_C2+x*(JL_C3+JL_C4*x));
    } else {
        x = M_PI-x;
        x *= x;
        return JL_NEG16(JL_C1 + x*(JL_C2+x*(JL_C3+JL_C4*x)));
    }
}

#endif


#endif
