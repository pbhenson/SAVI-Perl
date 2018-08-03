/*
 * SAVI-Perl version 0.05
 *
 * Paul Henson <henson@acm.org>
 *
 * Copyright (c) 2002 Paul Henson -- see COPYRIGHT file for details
 *
 */

#ifdef __cplusplus
extern "C" {
#endif

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "sav_if/csavi2c.h"

#ifdef __cplusplus
}
#endif

typedef CISavi2 *SAVI;
typedef CIEnumSweepResults *SAVI__results;

typedef struct savi_version {
  U32 version;
  char string[128];
  U32 count;
  CIEnumIDEDetails *ide_list;
} savi_version_obj;

typedef savi_version_obj *SAVI__version;
typedef CIIDEDetails *SAVI__version__ide;

static int
not_here(s)
char *s;
{
  croak("%s not implemented on this architecture", s);
  return -1;
}

static double
constant(name, arg)
char *name;
int arg;
{
  errno = 0;
  switch (*name) {
  }
  errno = EINVAL;
  return 0;
  
 not_there:
  errno = ENOENT;
  return 0;
}

MODULE = SAVI			PACKAGE = SAVI

void
DESTROY(savi)
  SAVI savi
  CODE:
  {
    if (savi) {
      savi->pVtbl->Terminate(savi);
      savi->pVtbl->Release(savi);
    }
  }

void
new(class)
  char *class
  PPCODE:
  {
    SAVI savi;
    CISweepClassFactory2 *factory;
    HRESULT status;
    SV *sv;

    status = DllGetClassObject((REFIID)&SOPHOS_CLSID_SAVI2, (REFIID)&SOPHOS_IID_CLASSFACTORY2, (void **)&factory);
    
    if (SOPHOS_SUCCEEDED(status)) {
      status = factory->pVtbl->CreateInstance(factory, NULL, &SOPHOS_IID_SAVI2, (void **)&savi);
      
      if (SOPHOS_SUCCEEDED(status)) {
	status = savi->pVtbl->InitialiseWithMoniker(savi, "SAVI-Perl");
	
	if (SOPHOS_SUCCEEDED(status)) {
	  sv = sv_newmortal();
	  sv_setref_pv(sv, "SAVI", savi);
	}
	else
	  savi->pVtbl->Release(savi);
      }
      
      factory->pVtbl->Release(factory);
    }
    
    if (SOPHOS_FAILED(status)) {
      sv = sv_2mortal(newSViv(SOPHOS_CODE(status)));
    }
    
    XPUSHs(sv);
  }

void
version(savi)
  SAVI savi
  PPCODE:
  {
    SV *sv = &PL_sv_undef;
    SAVI__version savi_version;
    HRESULT status;
    
    if (savi_version = (SAVI__version)malloc(sizeof(savi_version_obj))) {
      status = savi->pVtbl->GetVirusEngineVersion(savi, &(savi_version->version), savi_version->string, 128,
						  NULL, &(savi_version->count), NULL,
						  (REFIID)&SOPHOS_IID_ENUM_IDEDETAILS,
						  (void **)&(savi_version->ide_list));
      if (SOPHOS_SUCCEEDED(status)) {
	sv = sv_newmortal();
	sv_setref_pv(sv, "SAVI::version", savi_version);
      }
      else
	sv = sv_2mortal(newSViv(SOPHOS_CODE(status)));
    }

    XPUSHs(sv);
  }

void
set(savi, param, value, type = 0)
  SAVI savi
  char *param
  char *value
  int type
  PPCODE:
  {
    HRESULT status;
    
    status = savi->pVtbl->SetConfigValue(savi, param, (type == 0 ? SOPHOS_TYPE_U32 : SOPHOS_TYPE_U16), value);

    if (SOPHOS_FAILED(status))
      XPUSHs(sv_2mortal(newSViv(SOPHOS_CODE(status))));
  }

void
scan(savi, path)
  SAVI savi
  char *path
  PPCODE:
  {
    SAVI__results results;
    HRESULT status;
    SV *sv;
    
    status = savi->pVtbl->SweepFile(savi, path, (REFIID)&SOPHOS_IID_ENUM_SWEEPRESULTS, (void **)&results);

    if (status == SOPHOS_S_OK) {
      results->pVtbl->Release(results);
      sv = sv_newmortal();
      sv_setref_iv(sv, "SAVI::results", 0);
    }
    else if (status == SOPHOS_SAVI2_ERROR_VIRUSPRESENT) {
      sv = sv_newmortal();
      sv_setref_pv(sv, "SAVI::results", results);
    }
    else
      sv = sv_2mortal(newSViv(SOPHOS_CODE(status)));
      
    XPUSHs(sv);
  }

MODULE = SAVI			PACKAGE = SAVI::version

void
DESTROY(version)
  SAVI::version version
  CODE:
  {
    if (version) {
      version->ide_list->pVtbl->Release(version->ide_list);
      free(version);
    }
  }

int
major(version)
  SAVI::version version
  CODE:
  {
    RETVAL = version->version >> 16;
  }
  OUTPUT:
    RETVAL

int
minor(version)
  SAVI::version version
  CODE:
  {
    RETVAL = version->version & 0x0000ffff;
  }
  OUTPUT:
    RETVAL

char *
string(version)
  SAVI::version version
  CODE:
  {
    RETVAL = version->string;
  }
  OUTPUT:
    RETVAL

int
count(version)
  SAVI::version version
  CODE:
  {
    RETVAL = version->count;
  }
  OUTPUT:
    RETVAL

void
ide_list(version)
  SAVI::version version
  PPCODE:
  {
    SAVI__version__ide ide;
    SV *sv;
    
    version->ide_list->pVtbl->Reset(version->ide_list);
    
    while (version->ide_list->pVtbl->Next(version->ide_list, 1, (void **)&ide, NULL) == SOPHOS_S_OK) {
      sv = sv_newmortal();
      sv_setref_pv(sv, "SAVI::version::ide", ide);
      XPUSHs(sv);
    }
  }

MODULE = SAVI			PACKAGE = SAVI::version::ide

void
DESTROY(ide)
  SAVI::version::ide ide
  CODE:
  {
    if (ide)
      ide->pVtbl->Release(ide);
  }

void
name(ide)
  SAVI::version::ide ide
  PPCODE:
  {
    char ide_name[128];
  
    if (ide->pVtbl->GetName(ide, 128, ide_name, NULL) == SOPHOS_S_OK)
      XPUSHs(sv_2mortal(newSVpv(ide_name, strlen(ide_name))));
  }

void
date(ide)
  SAVI::version::ide ide
  PPCODE:
  {
    SYSTEMTIME release_date;
    char buf[128];

    if (ide->pVtbl->GetDate(ide, &release_date) == SOPHOS_S_OK) {
      snprintf(buf, 128, "%d/%d/%d", release_date.wMonth, release_date.wDay, release_date.wYear);
      buf[127] = '\0';
      XPUSHs(sv_2mortal(newSVpv(buf, strlen(buf))));
    }
  }

MODULE = SAVI			PACKAGE = SAVI::results

void
DESTROY(results)
  SAVI::results results
  CODE:
  {
    if (results)
      results->pVtbl->Release(results);
  }

int
infected(results)
  SAVI::results results
  CODE:
  {
    RETVAL = (results != 0);
  }
  OUTPUT:
    RETVAL

void
viruses(results)
  SAVI::results results
  PPCODE:
  {
    CISweepResults *virus_info;
    
    results->pVtbl->Reset(results);
    
    while (results->pVtbl->Next(results, 1, (void **)&virus_info, NULL) == SOPHOS_S_OK) {
      char virus_name[128];
      
      if (virus_info->pVtbl->GetVirusName(virus_info, 128, virus_name, NULL) == SOPHOS_S_OK) {
	XPUSHs(sv_2mortal(newSVpv(virus_name, strlen(virus_name))));
      }
      
      virus_info->pVtbl->Release(virus_info);
    }
  }
