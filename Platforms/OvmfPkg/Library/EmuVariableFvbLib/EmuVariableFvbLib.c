/** @file
  OVMF platform customization for EMU Variable FVB driver

  Copyright (c) 2009 - 2011, Intel Corporation. All rights reserved.<BR>
  This program and the accompanying materials
  are licensed and made available under the terms and conditions of the BSD License
  which accompanies this distribution.  The full text of the license may be found at
  http://opensource.org/licenses/bsd-license.php

  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.

**/

#include "PiDxe.h"
#include <Library/DebugLib.h>
#include <Library/PcdLib.h>
#include <Library/PlatformFvbLib.h>
#include <Library/UefiBootServicesTableLib.h>
#include <Library/UefiRuntimeLib.h>


/**
  This function will be called following a call to the
  EFI_FIRMWARE_VOLUME_BLOCK_PROTOCOL Write function.

  @param[in] This     EFI_FIRMWARE_VOLUME_BLOCK_PROTOCOL instance.
  @param[in] Lba      The starting logical block index to written to.
  @param[in] Offset   Offset into the block at which to begin writing.
  @param[in] NumBytes The number of bytes written.
  @param[in] Buffer   Pointer to the buffer that was written.

**/
VOID
EFIAPI
PlatformFvbDataWritten (
  IN CONST  EFI_FIRMWARE_VOLUME_BLOCK2_PROTOCOL *This,
  IN        EFI_LBA                             Lba,
  IN        UINTN                               Offset,
  IN        UINTN                               NumBytes,
  IN        UINT8                               *Buffer
  )
{
  STATIC EFI_EVENT EventToSignal = NULL;

  if (!EfiAtRuntime ()) {
    if (EventToSignal == NULL) {
      EventToSignal = (EFI_EVENT)(UINTN) PcdGet64 (PcdEmuVariableEvent);
    }
    if (EventToSignal != NULL) {
      gBS->SignalEvent (EventToSignal);
    }
  }
}


