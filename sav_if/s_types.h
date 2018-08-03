/*=====================================
 *  S_TYPES.H
 *=====================================
 *  Virus Engine Project
 *  Copyright (c) 1998,2000 Sophos Plc
 *=====================================
 *
 *  This file will set the standard Sophos types.
 *  On most platforms, the bottom set are the ones
 *  that you will need.  The top set is the 64-bit
 *  Alpha-based Unixen. The middle set is for VMS
 *  which believe it or not doesn't understand the
 *  'signed' keyword!
 *
 * You MUST MUST MUST MUST make absolutely sure that these are
 * defined correctly.  Very little will work if they are not.
 *
 *===================================*/

#ifndef __S_TYPES_H__
#define __S_TYPES_H__

/*
 * First setup all the platform defines so that we can
 * determine which platform we are compiling for!
 */
#include "s_comput.h"

/*
 * Standard Sophos types. 
 */
#ifndef __SOPHOS_TYPES_DEFINED__

#if defined(__SOPHOS_VMS__)
  typedef unsigned char      U08;
/*  typedef unsigned short int U16;
  typedef unsigned long  int U32; */
  typedef char      S08;
  typedef short int S16;
  typedef long  int S32;
#elif (((defined(__SOPHOS_DEC_UNIX__)) && (defined(__SOPHOS_ALPHA__))) || \
      ((defined(__SOPHOS_LINUX__))    && (defined(__SOPHOS_ALPHA__))))
   typedef unsigned char      U08;
/*   typedef unsigned short int U16;
   typedef unsigned       int U32; */
   typedef signed   char      S08;
   typedef signed   short int S16;
   typedef signed         int S32;
#else
   typedef unsigned char      U08;
/*   typedef unsigned short int U16;
   typedef unsigned long  int U32; */
   typedef signed   char      S08;
   typedef signed   short int S16;
   typedef signed   long  int S32;
# endif
# define __SOPHOS_TYPES_DEFINED__
#endif /* __SOPHOS_TYPES_DEFINED__ */

#endif  /* __S_TYPES_H__ */
