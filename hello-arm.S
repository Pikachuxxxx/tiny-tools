.section __DATA,__data
	msg:
		.asciz "Hello, ARM64 macOS!\n"
	test_str:
		.string "another string\n\0"

.section __TEXT,__text
    .global _hello
    .global _main
    .p2align 3 // 8-byte alignment 2 ^ 3

    .macro FUNC_PROLOGUE
        stp x29, x30, [sp, #-16]!
        mov x29, sp
    .endm

    .macro FUNC_EPILOGUE
        ldp x29, x30, [sp], #16
        ret
    .endm

_hello:
    FUNC_PROLOGUE
    // sys_write: write(1, msg, len)
    mov x0, 1            // file descriptor (stdout)
    adrp x1, msg@PAGE    // load page address of msg
    add x1, x1, msg@PAGEOFF // load offset of msg
    mov x2, 20           // length of string
    mov x16, 0x4         // syscall number for write
    svc 0                // trigger syscall
    FUNC_EPILOGUE

_main:
    FUNC_PROLOGUE            

    bl _hello     

    ldp x29, x30, [sp], #16

    mov x16, 1 // exit syscall
    svc 0
