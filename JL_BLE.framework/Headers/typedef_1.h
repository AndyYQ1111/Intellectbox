//
//  typedef_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

#ifndef typedef_1_h
#define typedef_1_h

#ifndef NULL
#define NULL ((void *)0)
#endif
#ifdef __GNUC__
#define jl_sec(x) __attribute__((section(#x)))
#define jl_AT(x) __attribute__((section(#x)))
#define jl_SET(x) __attribute__((x))
#define _JL_GNU_PACKED_    __attribute__((packed))
#else
#define jl_sec(x)
#define jl_AT(x)
#define jl_SET(x)
#define _JL_GNU_PACKED_
#endif

#define FALSE    0
#define TRUE    !FALSE
#define false    0
#define true    !false

#ifdef WIN32
typedef unsigned char    __u8,u8;
typedef char            __s8,s8,BYTE;
typedef unsigned short    __le16,__u16,u16;
typedef signed short    __s16,__be16,be16,le16,s16;
typedef unsigned int    __be32,__le32,be32,le32,__u32,u32,tu8,tu16,tbool, xbool;   //, size_t
typedef signed int        __s32,s32,DWORD,BOOL;
typedef signed long long u64,__le64,le64;

#define _xdata
#define _data
#define _idata
#define _pdata
#define _bdata
#define _code
#define _bit        xbool
#define _sbit        xbool
#define pu16        u16
#define pu32        u32

#define    JL_LD_WORD(ptr)        (u16)(*(u16*)(u8*)(ptr))
#define    JL_LD_DWORD(ptr)        (u32)(*(u32*)(u8*)(ptr))
#define    JL_ST_WORD(ptr,val)    *(u16*)(u8*)(ptr)=(u16)(val)
#define    JL_ST_DWORD(ptr,val)    *(u32*)(u8*)(ptr)=(u32)(val)
#else
typedef  signed short s16;
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;
#endif


#define     BIT(n)                (1 << (n))
#define     BitSET(REG,POS)     (REG |= (1 << POS))
#define     BitCLR(REG,POS)     (REG &= (~(1 << POS)))
#define     BitXOR(REG,POS)     (REG ^= (~(1 << POS)))
#define     BitCHK_1(REG,POS)   ((REG & (1 << POS)) == (1 << POS))
#define     BitCHK_0(REG,POS)   ((REG & (1 << POS)) == 0x00)
#define     testBit(REG,POS)    (REG & (1 << POS))

#define     clrBit(x,y)         x &= ~(1L << y)
#define     setBit(x,y)         x |= (1L << y)


#define my_memcpy memcpy
#define my_memset memset

#ifndef min
#define min(a,b)    ((a)<(b)?(a):(b))
#endif

#ifndef ARRAY_SIZE
#define ARRAY_SIZE(a) (sizeof(a)/sizeof(a[0]))
#endif

#ifndef MIN
#define MIN(a,b) (((a) < (b)) ? (a) : (b))
#endif

#ifndef MAX
#define MAX(a,b) (((a) > (b)) ? (a) : (b))
#endif

#endif
