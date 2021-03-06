#include "hphp/runtime/base/string-data-macros.h"
#include "hphp/util/etch-helpers.h"
#include "hphp/util/hphp-config.h"

#if defined(ENABLE_AARCH64_CRC) && !defined(NO_HWCRC) && defined(NO_M_DATA) && \
    !defined(_MSC_VER)

        .file     "hphp/runtime/base/string-data-arm.S"

/*
 * HPHP::StringData::hashHelper() is defined here only when ENABLE_AARCH64_CRC
 * is explicitly specified, and NO_M_DATA is used in StringData.
 */

ETCH_SECTION(_ZNK4HPHP10StringData10hashHelperEv)
.globl    _ZNK4HPHP10StringData10hashHelperEv
ETCH_TYPE(_ZNK4HPHP10StringData10hashHelperEv, @function)
ETCH_ALIGN16
_ZNK4HPHP10StringData10hashHelperEv:
        CFI(startproc)
        ldr     w3, [x0, #SD_LEN]
        add     x13, x0, #SD_HASH
        mov     w9, #-1
        ldr     w10, [x13]
        cbz     x3, ETCH_LABEL(hend)
        neg     x3, x3
        add     x2, x0, #SD_DATA
        mov     x11, #0xdfdfdfdfdfdfdfdf
        b       ETCH_LABEL(hheader)

ETCH_LABEL(hloop):
        crc32cx w9, w9, x1
ETCH_LABEL(hheader):
        ldr     x12, [x2], #8
        and     x1, x11, x12
        adds    x3, x3, #8
        bcc     ETCH_LABEL(hloop)

        lsl     w3, w3, #3
        lsl     x1, x1, x3
        crc32cx w9, w9, x1

ETCH_LABEL(hend):
        lsr     w9, w9, #1
        orr     w10, w10, w9
        str     w10, [x13]
        mov     w0, w9
        ret
        CFI(endproc)
ETCH_SIZE(_ZNK4HPHP10StringData10hashHelperEv)

#endif
