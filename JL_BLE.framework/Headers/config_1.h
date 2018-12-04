//
//  config_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

// Microsoft version of 'inline'
#define inline __inline

// Visual Studio support alloca(), but it always align variables to 16-bit
// boundary, while SSE need 128-bit alignment. So we disable alloca() when
// SSE is enabled.
#ifndef _JL_USE_SSE
#  define JL_USE_ALLOCA
#endif

#define  JL_FIXED_POINT
#define  JL_DISABLE_VBR


/* Default to floating point */
#ifndef JL_FIXED_POINT
#  define JL_FLOATING_POINT
#  define JL_USE_SMALLFT
#else
#  define JL_USE_KISS_FFT
#endif

/* We don't support visibility on Win32 */
#define JL_EXPORT
