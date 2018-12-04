//
//  os_support_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

#ifndef os_support_1_h
#define os_support_1_h

#include <string.h>
//#include <stdio.h>
//#include <stdlib.h>

#ifdef JL_HAVE_CONFIG_H
#include "config_1.h"
#endif
#ifdef JL_OS_SUPPORT_CUSTOM
#include "os_support_custom.h"
#endif

#ifdef WIN32
#define INLINE  __inline
#else
#define INLINE
#endif



//#define  JL_DISABLE_WIDEBAND

/** Speex wrapper for calloc. To do your own dynamic allocation, all you need to do is replace this function, speex_realloc_1 and speex_free_1
 NOTE: speex_alloc_1 needs to CLEAR THE MEMORY */
#ifndef JL_OVERRIDE_SPEEX_ALLOC
#ifdef WIN32
static INLINE void *speex_alloc_1 (int size)
#else
static inline void *speex_alloc_1 (int size)
#endif
{
    return NULL;
    /* WARNING: this is not equivalent to malloc(). If you want to use malloc()
     or your own allocator, YOU NEED TO CLEAR THE MEMORY ALLOCATED. Otherwise
     you will experience strange bugs */
}
#endif

/** Same as speex_alloc_1, except that the area is only needed inside a Speex call (might cause problem with wideband though) */
#ifndef JL_OVERRIDE_SPEEX_ALLOC_SCRATCH
#ifdef WIN32
static INLINE void *speex_alloc_scratch_1 (int size)
#else
static inline void *speex_alloc_scratch_1 (int size)
#endif
{
    return NULL;
    /* Scratch space doesn't need to be cleared */
}
#endif

/** Speex wrapper for realloc. To do your own dynamic allocation, all you need to do is replace this function, speex_alloc_1 and speex_free_1 */
#ifndef JL_OVERRIDE_SPEEX_REALLOC
#ifdef WIN32
static INLINE void *speex_realloc_1 (void *ptr, int size)
#else
static inline void *speex_realloc_1 (void *ptr, int size)
#endif
{
    return NULL;
}
#endif

/** Speex wrapper for calloc. To do your own dynamic allocation, all you need to do is replace this function, speex_realloc_1 and speex_alloc_1 */
#ifndef JL_OVERRIDE_SPEEX_FREE
#ifdef WIN32
static INLINE void speex_free_1 (void *ptr)
#else
static inline void speex_free_1 (void *ptr)
#endif
{
}
#endif

/** Same as speex_free_1, except that the area is only needed inside a Speex call (might cause problem with wideband though) */
#ifndef JL_OVERRIDE_SPEEX_FREE_SCRATCH
#ifdef WIN32
static INLINE void speex_free_scratch_1 (void *ptr)
#else
static inline void speex_free_scratch_1 (void *ptr)
#endif
{
}
#endif

/** Copy n bytes of memory from src to dst. The 0* term provides compile-time type checking  */
#ifndef JL_OVERRIDE_SPEEX_COPY
#define JL_SPEEX_COPY(dst, src, n) (memcpy((dst), (src), (n)*sizeof(*(dst)) + 0*((dst)-(src)) ))
#endif

/** Copy n bytes of memory from src to dst, allowing overlapping regions. The 0* term
 provides compile-time type checking */
#ifndef JL_OVERRIDE_SPEEX_MOVE
#define JL_SPEEX_MOVE(dst, src, n) (memmove((dst), (src), (n)*sizeof(*(dst)) + 0*((dst)-(src)) ))
#endif

/** Set n bytes of memory to value of c, starting at address s */
#ifndef JL_OVERRIDE_SPEEX_MEMSET
#define JL_SPEEX_MEMSET(dst, c, n) (memset((dst), (c), (n)*sizeof(*(dst))))
#endif


#ifndef JL_OVERRIDE_SPEEX_FATAL
#ifdef WIN32
static INLINE void _speex_fatal_1(const char *str, const char *file, int line)
#else
static inline void _speex_fatal_1(const char *str, const char *file, int line)
#endif

{
}
#endif

#ifndef JL_OVERRIDE_SPEEX_WARNING
#ifdef WIN32
static INLINE void speex_warning_1(const char *str)
#else
static inline void speex_warning_1(const char *str)
#endif
{
#ifndef JL_DISABLE_WARNINGS
#endif
}
#endif

#ifndef JL_OVERRIDE_SPEEX_WARNING_INT
#ifdef WIN32
static INLINE void speex_warning_int_1(const char *str, int val)
#else
static inline void speex_warning_int_1(const char *str, int val)
#endif

{
#ifndef JL_DISABLE_WARNINGS
#endif
}
#endif

#ifndef JL_OVERRIDE_SPEEX_NOTIFY

#ifdef WIN32
static INLINE void speex_notify_1(const char *str)
#else
static inline void speex_notify_1(const char *str)
#endif


{
#ifndef JL_DISABLE_NOTIFICATIONS
#endif
}
#endif

#ifndef JL_OVERRIDE_SPEEX_PUTC
/** Speex wrapper for putc */
#ifdef WIN32
static INLINE void _speex_putc_1(int ch, void *file)
#else
static inline void _speex_putc_1(int ch, void *file)
#endif
{
}
#endif

#define speex_fatal(str) _speex_fatal_1(str, __FILE__, __LINE__);
#define speex_assert(cond) {if (!(cond)) {speex_fatal("assertion failed: " #cond);}}

#ifndef JL_RELEASE
#ifdef WIN32
static INLINE void print_vec_1(float *vec, int len, char *name)
#else
static inline void print_vec_1(float *vec, int len, char *name)
#endif
{
}
#endif

#endif
