/*
 * Custom linker script for Keychron Q6 HE
 * Reserves sector 5 (128KB) for wear-leveling EEPROM instead of sector 1.
 * Firmware uses sectors 0-4 (128KB total).
 *
 * STM32F401xC sector layout:
 *   Sector 0: 16KB  (0x08000000) - Vectors/init
 *   Sector 1: 16KB  (0x08004000) - Firmware
 *   Sector 2: 16KB  (0x08008000) - Firmware
 *   Sector 3: 16KB  (0x0800C000) - Firmware
 *   Sector 4: 64KB  (0x08010000) - Firmware
 *   Sector 5: 128KB (0x08020000) - EEPROM (wear leveling)
 */

f4xx_flash_size = 256k;
f4xx_ram1_size = 64k;
f4xx_ram2_size = 0;
f4xx_ram4_size = 0;
f4xx_ram5_size = 0;

/* Override flash layout: use sectors 0-4 for code, reserve sector 5 for EEPROM */
MEMORY
{
    flash0 (rx) : org = 0x08000000, len = 16k       /* Sector 0 - Init code */
    flash1 (rx) : org = 0x08004000, len = 0          /* Unused - EEPROM moved to sector 5 */
    flash2 (rx) : org = 0x08004000, len = 112k       /* Sectors 1-4 - Firmware (16+16+16+64=112KB) */
    flash3 (rx) : org = 0x00000000, len = 0
    flash4 (rx) : org = 0x00000000, len = 0
    flash5 (rx) : org = 0x00000000, len = 0
    flash6 (rx) : org = 0x00000000, len = 0
    flash7 (rx) : org = 0x00000000, len = 0
    ram0   (wx) : org = 0x20000000, len = f4xx_ram1_size + f4xx_ram2_size /* SRAM1 + SRAM2 */
    ram1   (wx) : org = 0x20000000, len = f4xx_ram1_size                  /* SRAM1 */
    ram2   (wx) : org = 0x20000000 + f4xx_ram1_size, len = f4xx_ram2_size /* SRAM2 */
    ram3   (wx) : org = 0x00000000, len = 0
    ram4   (wx) : org = 0x10000000, len = f4xx_ram4_size                  /* CCM SRAM */
    ram5   (wx) : org = 0x40024000, len = f4xx_ram5_size                  /* BCKP SRAM */
    ram6   (wx) : org = 0x00000000, len = 0
    ram7   (wx) : org = 0x00000000, len = 0
}

/* For each data/text section two region are defined, a virtual region
   and a load region (_LMA suffix).*/

/* Flash region to be used for exception vectors.*/
REGION_ALIAS("VECTORS_FLASH", flash0);
REGION_ALIAS("VECTORS_FLASH_LMA", flash0);

/* Flash region to be used for constructors and destructors.*/
REGION_ALIAS("XTORS_FLASH", flash2);
REGION_ALIAS("XTORS_FLASH_LMA", flash2);

/* Flash region to be used for code text.*/
REGION_ALIAS("TEXT_FLASH", flash2);
REGION_ALIAS("TEXT_FLASH_LMA", flash2);

/* Flash region to be used for read only data.*/
REGION_ALIAS("RODATA_FLASH", flash2);
REGION_ALIAS("RODATA_FLASH_LMA", flash2);

/* Flash region to be used for various.*/
REGION_ALIAS("VARIOUS_FLASH", flash2);
REGION_ALIAS("VARIOUS_FLASH_LMA", flash2);

/* Flash region to be used for RAM(n) initialization data.*/
REGION_ALIAS("RAM_INIT_FLASH_LMA", flash2);

/* RAM region to be used for Main stack. This stack accommodates the processing
   of all exceptions and interrupts.*/
REGION_ALIAS("MAIN_STACK_RAM", ram0);

/* RAM region to be used for the process stack. This is the stack used by
   the main() function.*/
REGION_ALIAS("PROCESS_STACK_RAM", ram0);

/* RAM region to be used for data segment.*/
REGION_ALIAS("DATA_RAM", ram0);
REGION_ALIAS("DATA_RAM_LMA", flash2);

/* RAM region to be used for BSS segment.*/
REGION_ALIAS("BSS_RAM", ram0);

/* RAM region to be used for the default heap.*/
REGION_ALIAS("HEAP_RAM", ram0);

/* Generic rules inclusion.*/
INCLUDE rules.ld
