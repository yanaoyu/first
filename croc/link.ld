OUTPUT_ARCH("riscv")
ENTRY(_start)
MEMORY
{
    SRAM (rwxail) : ORIGIN = 0x10000000, LENGTH = 64K
}
PHDRS
{
    text PT_LOAD FLAGS(5);
    data PT_LOAD FLAGS(6);
}
SECTIONS
{
    /DISCARD/ : { *(.riscv.attributes) *(.comment) }
    . = ORIGIN(SRAM);
    .vectors : ALIGN(4) { *(.vectors) KEEP(*(.vectors)) } > SRAM :text
    .text._start : ALIGN(4) { *(.text._start) } > SRAM :text
    .text : ALIGN(4) { *(.text) *(.text.*) *(.rodata) *(.rodata.*) } > SRAM :text
    
    _bss_start = .;
    .misc : ALIGN(4)
    {
        *(.sdata) *(.sdata.*)
        *(.data) *(.data.*)
        *(.sbss) *(.sbss.*)
        *(.bss) *(.bss.*)
        *(COMMON)
    } > SRAM :data
    _end = .;
    
    PROVIDE(__global_pointer$ = ADDR(.misc) + SIZEOF(.misc) / 2);
    PROVIDE(__stack_pointer$ = ORIGIN(SRAM) + LENGTH(SRAM));
    PROVIDE(_eoc = 0x02000100);
    PROVIDE(_trap_handler_wrapper = 0x02000200);
    PROVIDE(_trap_exit = 0x02000300);
    PROVIDE(corestatus = 0x03000008);
}
