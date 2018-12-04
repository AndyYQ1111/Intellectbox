//
//  fixed_generic_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

#ifndef fixed_generic_1_h
#define fixed_generic_1_h

#define JL_QCONST16(x,bits) ((jl_spx_word16_t)(.5+(x)*(((jl_spx_word32_t)1)<<(bits))))
#define JL_QCONST32(x,bits) ((jl_spx_word32_t)(.5+(x)*(((jl_spx_word32_t)1)<<(bits))))

#define JL_NEG16(x) (-(x))
#define JL_NEG32(x) (-(x))
#define JL_EXTRACT16(x) ((jl_spx_word16_t)(x))
#define JL_EXTEND32(x) ((jl_spx_word32_t)(x))
#define JL_SHR16(a,shift) ((a) >> (shift))
#define JL_SHL16(a,shift) ((a) << (shift))
#define JL_SHR32(a,shift) ((a) >> (shift))
#define JL_SHL32(a,shift) ((a) << (shift))
#define JL_PSHR16(a,shift) (JL_SHR16((a)+((1<<((shift))>>1)),shift))
#define JL_PSHR32(a,shift) (JL_SHR32((a)+((JL_EXTEND32(1)<<((shift))>>1)),shift))
#define JL_VSHR32(a, shift) (((shift)>0) ? JL_SHR32(a, shift) : JL_SHL32(a, -(shift)))
#define JL_SATURATE16(x,a) (((x)>(a) ? (a) : (x)<-(a) ? -(a) : (x)))
#define JL_SATURATE32(x,a) (((x)>(a) ? (a) : (x)<-(a) ? -(a) : (x)))

#define JL_SHR(a,shift) ((a) >> (shift))
#define JL_SHL(a,shift) ((jl_spx_word32_t)(a) << (shift))
#define JL_PSHR(a,shift) (JL_SHR((a)+((JL_EXTEND32(1)<<((shift))>>1)),shift))
#define JL_SATURATE(x,a) (((x)>(a) ? (a) : (x)<-(a) ? -(a) : (x)))


#define JL_ADD16(a,b) ((jl_spx_word16_t)((jl_spx_word16_t)(a)+(jl_spx_word16_t)(b)))
#define JL_SUB16(a,b) ((jl_spx_word16_t)(a)-(jl_spx_word16_t)(b))
#define JL_ADD32(a,b) ((jl_spx_word32_t)(a)+(jl_spx_word32_t)(b))
#define JL_SUB32(a,b) ((jl_spx_word32_t)(a)-(jl_spx_word32_t)(b))


/* result fits in 16 bits */
#define JL_MULT16_16_16(a,b)     ((((jl_spx_word16_t)(a))*((jl_spx_word16_t)(b))))

/* (jl_spx_word32_t)(jl_spx_word16_t) gives TI compiler a hint that it's 16x16->32 multiply */
#define JL_MULT16_16(a,b)     (((jl_spx_word32_t)(jl_spx_word16_t)(a))*((jl_spx_word32_t)(jl_spx_word16_t)(b)))

#define JL_MAC16_16(c,a,b) (JL_ADD32((c),JL_MULT16_16((a),(b))))
#define JL_MULT16_32_Q12(a,b) JL_ADD32(JL_MULT16_16((a),JL_SHR((b),12)), JL_SHR(JL_MULT16_16((a),((b)&0x00000fff)),12))
#define JL_MULT16_32_Q13(a,b) JL_ADD32(JL_MULT16_16((a),JL_SHR((b),13)), JL_SHR(JL_MULT16_16((a),((b)&0x00001fff)),13))
#define JL_MULT16_32_Q14(a,b) JL_ADD32(JL_MULT16_16((a),JL_SHR((b),14)), JL_SHR(JL_MULT16_16((a),((b)&0x00003fff)),14))

#define JL_MULT16_32_Q11(a,b) JL_ADD32(JL_MULT16_16((a),JL_SHR((b),11)), JL_SHR(JL_MULT16_16((a),((b)&0x000007ff)),11))
#define JL_MAC16_32_Q11(c,a,b) JL_ADD32(c,JL_ADD32(JL_MULT16_16((a),JL_SHR((b),11)), JL_SHR(JL_MULT16_16((a),((b)&0x000007ff)),11)))

#define JL_MULT16_32_P15(a,b) JL_ADD32(JL_MULT16_16((a),JL_SHR((b),15)), JL_PSHR(JL_MULT16_16((a),((b)&0x00007fff)),15))
#define JL_MULT16_32_Q15(a,b) JL_ADD32(JL_MULT16_16((a),JL_SHR((b),15)), JL_SHR(JL_MULT16_16((a),((b)&0x00007fff)),15))
#define JL_MAC16_32_Q15(c,a,b) JL_ADD32(c,JL_ADD32(JL_MULT16_16((a),JL_SHR((b),15)), JL_SHR(JL_MULT16_16((a),((b)&0x00007fff)),15)))


#define JL_MAC16_16_Q11(c,a,b)     (JL_ADD32((c),JL_SHR(JL_MULT16_16((a),(b)),11)))
#define JL_MAC16_16_Q13(c,a,b)     (JL_ADD32((c),JL_SHR(JL_MULT16_16((a),(b)),13)))
#define JL_MAC16_16_P13(c,a,b)     (JL_ADD32((c),JL_SHR(JL_ADD32(4096,JL_MULT16_16((a),(b))),13)))

#define JL_MULT16_16_Q11_32(a,b) (JL_SHR(JL_MULT16_16((a),(b)),11))
#define JL_MULT16_16_Q13(a,b) (JL_SHR(JL_MULT16_16((a),(b)),13))
#define JL_MULT16_16_Q14(a,b) (JL_SHR(JL_MULT16_16((a),(b)),14))
#define JL_MULT16_16_Q15(a,b) (JL_SHR(JL_MULT16_16((a),(b)),15))

#define JL_MULT16_16_P13(a,b) (JL_SHR(JL_ADD32(4096,JL_MULT16_16((a),(b))),13))
#define JL_MULT16_16_P14(a,b) (JL_SHR(JL_ADD32(8192,JL_MULT16_16((a),(b))),14))
#define JL_MULT16_16_P15(a,b) (JL_SHR(JL_ADD32(16384,JL_MULT16_16((a),(b))),15))

#define JL_MUL_16_32_R15(a,bh,bl) JL_ADD32(JL_MULT16_16((a),(bh)), JL_SHR(JL_MULT16_16((a),(bl)),15))

#define JL_DIV32_16(a,b) ((jl_spx_word16_t)(((jl_spx_word32_t)(a))/((jl_spx_word16_t)(b))))
#define JL_PDIV32_16(a,b) ((jl_spx_word16_t)(((jl_spx_word32_t)(a)+((jl_spx_word16_t)(b)>>1))/((jl_spx_word16_t)(b))))
#define JL_DIV32(a,b) (((jl_spx_word32_t)(a))/((jl_spx_word32_t)(b)))
#define JL_PDIV32(a,b) (((jl_spx_word32_t)(a)+((jl_spx_word16_t)(b)>>1))/((jl_spx_word32_t)(b)))

#endif
