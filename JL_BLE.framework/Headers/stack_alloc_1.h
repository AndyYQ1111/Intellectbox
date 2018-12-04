//
//  stack_alloc_1.h
//  JLSpeexKit
//
//  Created by DFung on 2018/1/30.
//  Copyright © 2018年 DFung. All rights reserved.
//

#ifndef stack_alloc_1_h
#define stack_alloc_1_h

#ifdef JL_USE_ALLOCA
# ifdef WIN32
#  include <malloc.h>
# else
#  ifdef HAVE_ALLOCA_H
#   include <alloca.h>
#  else
#   include <stdlib.h>
#  endif
# endif
#endif

/**
 * @def JL_ALIGN(stack, size)
 *
 * Aligns the stack to a 'size' boundary
 *
 * @param stack Stack
 * @param size  New size boundary
 */

/**
 * @def JL_PUSH(stack, size, type)
 *
 * Allocates 'size' elements of type 'type' on the stack
 *
 * @param stack Stack
 * @param size  Number of elements
 * @param type  Type of element
 */

/**
 * @def JL_VARDECL(var)
 *
 * Declare variable on stack
 *
 * @param var Variable to declare
 */

/**
 * @def JL_ALLOC(var, size, type)
 *
 * Allocate 'size' elements of 'type' on stack
 *
 * @param var  Name of variable to allocate
 * @param size Number of elements
 * @param type Type of element
 */

#ifdef JL_ENABLE_VALGRIND

#include <valgrind/memcheck.h>

#define JL_ALIGN(stack, size) ((stack) += ((size) - (long)(stack)) & ((size) - 1))

#define JL_PUSH(stack, size, type) (VALGRIND_MAKE_NOACCESS(stack, 1000),JL_ALIGN((stack),sizeof(type)),VALGRIND_MAKE_WRITABLE(stack, ((size)*sizeof(type))),(stack)+=((size)*sizeof(type)),(type*)((stack)-((size)*sizeof(type))))

#else

#define JL_ALIGN(stack, size) ((stack) += ((size) - (long)(stack)) & ((size) - 1))

#define JL_PUSH(stack, size, type) (JL_ALIGN((stack),sizeof(type)),(stack)+=((size)*sizeof(type)),(type*)((stack)-((size)*sizeof(type))))

#endif

#if defined(JL_VAR_ARRAYS)
#define JL_VARDECL(var)
#define JL_ALLOC(var, size, type) type var[size]
#elif defined(JL_USE_ALLOCA)
#define JL_VARDECL(var) var
#define JL_ALLOC(var, size, type) var = alloca(sizeof(type)*(size))
#else
#define JL_VARDECL(var) var
#define JL_ALLOC(var, size, type) var = JL_PUSH(stack, size, type)
#endif


#endif
