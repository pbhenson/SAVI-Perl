/*
 * savitype.h (04-MAY-2000)
 *
 * This file is a part of the Sophos Anti-Virus Interface (SAVI)(tm).
 *
 * Copyright (C) 1997,2000 Sophos Plc, Oxford, England.
 * All rights reserved.
 *
 * This source code is only intended as a supplement to the
 * SAVI(tm) Reference and related documentation for the library.
 *
 * Cross platform type definitions
 */

#ifndef __SAVITYPE_DOT_H__
#define __SAVITYPE_DOT_H__

#include "compute.h"

/* Ensure consistent packing for the interface */
/* between elements of the service...          */
#ifdef __SOPHOS_MS__
# pragma pack(push, pack_header__SAVITYPE_DOT_H__, 4)
#endif

#include "sophtype.h"
#include "savichar.h"

#ifdef __SOPHOS_WIN32__
#  include <winbase.h>    /* For SYSTEMTIME. */
#  include <objbase.h>    /* For HRESULT. */
#  define SOPHOS_STDCALL   __stdcall
#  define SOPHOS_BOOL      BOOL
#  define SOPHOS_ULONG     ULONG
#else  /* __SOPHOS_WIN32__ */
#  define SOPHOS_STDCALL
   /*
    * Date structure (same format as the Win32 SYSTEMTIME structure).
    */
   typedef struct _SYSTEMTIME
   {
      U16 wYear;              /* Full-four digit representation [eg 1998]      */
      U16 wMonth;             /*   1 ->  11 [January == 1, February == 2, etc] */
      U16 wDayOfWeek;         /*   0 ->   6 [Sunday  == 0, Monday   == 1, etc] */
      U16 wDay;               /*  01 ->  31                                    */
      U16 wHour;              /*  00 ->  23                                    */
      U16 wMinute;            /*  00 ->  59                                    */
      U16 wSecond;            /*  00 ->  59                                    */
      U16 wMilliseconds;      /* 000 -> 999                                    */
   } SYSTEMTIME;

   /* Define some types analogous to Windows COM types: */
   typedef U32   SOPHOS_ULONG;
   typedef S32   HRESULT;
   typedef U32   SOPHOS_BOOL;

#endif /* __SOPHOS_WIN32__ */

#define SOPHOS_STDCALL_PUBLIC     SOPHOS_STDCALL SOPHOS_PUBLIC
#define SOPHOS_STDCALL_PUBLIC_PTR SOPHOS_STDCALL SOPHOS_PUBLIC_PTR

/*
 * ISweepResults codes valid for SOPHOS_IID_SAVI interface only.
 */
#define SOPHOS_NO_VIRUS                 0          /* No virus found   */
#define SOPHOS_VIRUS_IDENTITY           1          /* Strong detection */
#define SOPHOS_VIRUS_PATTERN            2          /* Weaker detection */
#define SOPHOS_VIRUS_MACINTOSH          3          /* Macintosh virus  */
#define SOPHOS_VIRUS                    0xFFFFFFFF /* Generic result   */

/*
 * Engine specific settings.
 */
#define SOPHOS_DOS_FILES                1
#define SOPHOS_MAC_FILES                2
#define SOPHOS_DOS_AND_MAC_FILES        (SOPHOS_DOS_FILES | SOPHOS_MAC_FILES)

/*
 * Loaded IDE codes.
 */
#define SOPHOS_IDE_VDL_SUCCESS          0
#define SOPHOS_IDE_VDL_FAILED           1
#define SOPHOS_IDE_VDL_OLD_WARNING      2
#define SOPHOS_IDE_VDL_INVALID_VERSION  3

/*
 * External virus information source type codes.
 */
#define SOPHOS_TYPE_IDE                 0
#define SOPHOS_TYPE_UPD                 1
#define SOPHOS_TYPE_VDL                 2
#define SOPHOS_TYPE_MAIN_VIRUS_DATA     3
#define SOPHOS_TYPE_UNKNOWN             0xFFFFFFFF

/*
 * Configuration option types.
 */
#define SOPHOS_TYPE_INVALID             0
#define SOPHOS_TYPE_U08                 1
#define SOPHOS_TYPE_U16                 2
#define SOPHOS_TYPE_U32                 3
#define SOPHOS_TYPE_S08                 4
#define SOPHOS_TYPE_S16                 5
#define SOPHOS_TYPE_S32                 6
#define SOPHOS_TYPE_BOOLEAN             7   
#define SOPHOS_TYPE_BYTESTREAM          8 

/*
 * Configuration option names.
 */
#define SOPHOS_NAMESPACE_SUPPORT        _T("NamespaceSupport")
#define SOPHOS_DO_FULL_SWEEP            _T("FullSweep")
#define SOPHOS_DYNAMIC_DECOMPRESSION    _T("DynamicDecompression")
#define SOPHOS_FULL_MACRO_SWEEP         _T("FullMacroSweep")
#define SOPHOS_OLE2_HANDLING            _T("OLE2Handling")
#define SOPHOS_IGNORE_TEMPLATE_BIT      _T("IgnoreTemplateBit")
#define SOPHOS_VBA3_HANDLING            _T("VBA3Handling")
#define SOPHOS_VBA5_HANDLING            _T("VBA5Handling")
#define SOPHOS_OF95_DECRYPT_HANDLING    _T("OF95DecryptHandling")
#define SOPHOS_HELP_HANDLING            _T("HelpHandling")
#define SOPHOS_DECOMPRESS_VBA5          _T("DecompressVBA5")
#define SOPHOS_DO_EMULATION             _T("Emulation")
#define SOPHOS_PE_HANDLING              _T("PEHandling")
#define SOPHOS_XF_HANDLING              _T("ExcelFormulaHandling")
#define SOPHOS_PM97_HANDLING            _T("PowerPointMacroHandling")
#define SOPHOS_PPT_EMBD_HANDLING        _T("PowerPointEmbeddedHandling")
#define SOPHOS_PROJECT_HANDLING         _T("ProjectHandling")
#define SOPHOS_ZIP_DECOMPRESSION        _T("ZipDecompression")
#define SOPHOS_ARJ_DECOMPRESSION        _T("ArjDecompression")
#define SOPHOS_RAR_DECOMPRESSION        _T("RarDecompression")
#define SOPHOS_UUE_DECOMPRESSION        _T("UueDecompression")
#define SOPHOS_GZIP_DECOMPRESSION       _T("GZipDecompression")
#define SOPHOS_TAR_DECOMPRESSION        _T("TarDecompression")
#define SOPHOS_CMZ_DECOMPRESSION        _T("CmzDecompression")
#define SOPHOS_HQX_DECOMPRESSION        _T("HqxDecompression")
#define SOPHOS_MBIN_DECOMPRESSION       _T("MbinDecompression")
#define SOPHOS_LOOPBACK_ENABLED         _T("LoopBackEnabled")
#define SOPHOS_MAX_RECURSION_DEPTH      _T("MaxRecursionDepth")

/* Added by Vanja */
#define SOPHOS_LHA_DECOMPRESSION        _T("Lha")
#define SOPHOS_SFX_HANDLING             _T("SfxArchives")
#define SOPHOS_MSCABINET_HANDLING       _T("MSCabinet")
#define SOPHOS_TNEF_HANDLING            _T("TnefAttachmentHandling")
#define SOPHOS_MSCOMPRESS_HANDLING      _T("MSCompress")
#define SOPHOS_OF95DECRYPT_HANDLING     _T("OF95DecryptHandling")
#define SOPHOS_DELETE_ALL_MACROS        _T("DeleteAllMacros")

/* Engine 2.5 - IDE 3.48 (29-Jul-2001) */
#define SOPHOS_VBE						_T("Vbe")
#define SOPHOS_EXEC_FILE_DISINFECTION	_T("ExecFileDisinfection")
#define SOPHOS_VISIO_FILE_HANDLING		_T("VisioFileHandling")

/* End of custom addition */

/*
 * End explicit packing.
 */
#ifdef __SOPHOS_MS__
# pragma pack(pop, pack_header__SAVITYPE_DOT_H__)
#endif

#endif /* __SAVITYPE_DOT_H__ */
