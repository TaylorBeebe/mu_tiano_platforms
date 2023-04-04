;  Copyright (c) 2019, Linaro Limited. All rights reserved.
;
;  SPDX-License-Identifier: BSD-2-Clause-Patent
;

#include <AsmMacroIoLibV8.h>
#include <Library/ArmLib.h>

  EXPORT ArmPlatformIsPrimaryCore
  AREA |.text|, CODE, READONLY

ArmPlatformPeiBootAction PROC
  ret
ArmPlatformPeiBootAction ENDP

// UINTN
// ArmPlatformGetCorePosition (
//  IN UINTN MpId
//  );
// With this function: CorePos = (ClusterId * 4) + CoreId
// ARM_FUNC(ArmPlatformGetCorePosition)
ArmPlatformGetCorePosition PROC
  and   x1, x0, #ARM_CORE_MASK
  and   x0, x0, #ARM_CLUSTER_MASK
  add   x0, x1, x0, LSR #6
  ret
ArmPlatformGetCorePosition ENDP

// UINTN
// ArmPlatformGetPrimaryCoreMpId (
//  VOID
//  );
// ARM_FUNC(ArmPlatformGetPrimaryCoreMpId)
ArmPlatformGetPrimaryCoreMpId PROC
  movz      w1, (FixedPcdGet32 (PcdArmPrimaryCore)) >> 16, lsl #16
  movk      w1, (FixedPcdGet32 (PcdArmPrimaryCore)) & 0xffff
  ret
ArmPlatformGetPrimaryCoreMpId ENDP

// UINTN
// ArmPlatformIsPrimaryCore (
//  IN UINTN MpId
//  );
ArmPlatformIsPrimaryCore PROC
  movz      w1, (FixedPcdGet32 (PcdArmPrimaryCoreMask)) >> 16, lsl #16
  movk      w1, (FixedPcdGet32 (PcdArmPrimaryCoreMask)) & 0xffff
  and   x0, x0, x1
  movz      w1, (FixedPcdGet32 (PcdArmPrimaryCore)) >> 16, lsl #16
  movk      w1, (FixedPcdGet32 (PcdArmPrimaryCore)) & 0xffff
  cmp   w0, w1
  mov   x0, #1
  mov   x1, #0
  csel  x0, x0, x1, eq
  ret
ArmPlatformIsPrimaryCore ENDP

;
; Bits 0..2 of the AA64MFR0_EL1 system register encode the size of the
; physical address space support on this CPU:
; 0 == 32 bits, 1 == 36 bits, etc etc
; 6 and 7 are reserved
;
LPARanges
  DCB 32, 36, 40, 42, 44, 48, -1, -1

  END