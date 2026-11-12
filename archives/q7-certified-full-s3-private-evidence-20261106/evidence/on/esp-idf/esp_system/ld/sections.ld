/* Automatically generated file; DO NOT EDIT */
/* Espressif IoT Development Framework Linker Script */
/* Generated from: /workspace/private-q7-certified-full-s3-20261106/build-on/esp-idf/esp_system/ld/sections.ld.in */

/*
 * SPDX-FileCopyrightText: 2021 Espressif Systems (Shanghai) CO LTD
 *
 * SPDX-License-Identifier: Apache-2.0
 */
/*
 * SPDX-FileCopyrightText: 2021-2024 Espressif Systems (Shanghai) CO LTD
 *
 * SPDX-License-Identifier: Apache-2.0
 */
/*
 * Automatically generated file. DO NOT EDIT.
 * Espressif IoT Development Framework (ESP-IDF) 6.0.1 Configuration Header
 */
       
/* List of deprecated options */
/* CPU instruction prefetch padding size for flash mmap scenario */
/* Copy from esp_secure_boot.h */
/*
 * PMP region granularity size
 * Software may determine the PMP granularity by writing zero to pmp0cfg, then writing all ones
 * to pmpaddr0, then reading back pmpaddr0. If G is the index of the least-significant bit set,
 * the PMP granularity is 2^G+2 bytes.
 */
/* CPU instruction prefetch padding size for memory protection scenario */
/* Memory alignment size for PMS */
    /* rtc timer data (s_rtc_timer_retain_mem, see esp_clk.c files). For rtc_timer_data_in_rtc_mem section. */
/* Default entry point */
ENTRY(call_start_cpu0);
SECTIONS
{
  /**
   * RTC fast memory holds RTC wake stub code,
   * including from any source file named rtc_wake_stub*.c
   */
  .rtc.text :
  {
    
 . = ALIGN(4); 
 _rtc_fast_start = ABSOLUTE(.);
    
 . = ALIGN(4); 
 _rtc_text_start = ABSOLUTE(.);
    HIDDEN(_rtc_code_start = .);
    *(.rtc.entry.literal .rtc.entry.text)
    
 *(.rtc.literal .rtc.text .rtc.text.*)
 mutable[rtc_text]
    *rtc_wake_stub*.*(.literal .text .literal.* .text.*)
    *(.rtc_text_end_test)
    HIDDEN(_rtc_code_end = .);
    /* Padding for possible CPU prefetch + 4B alignment for PMS split lines. */
    . = ((_rtc_code_end - _rtc_code_start) == 0) ?
        ALIGN(0) : 16 + ALIGN(4);
    _rtc_text_end = ABSOLUTE(.);
  } > rtc_iram_seg
  /**
   * This section located in RTC FAST Memory area.
   * It holds data marked with RTC_FAST_ATTR attribute.
   * See the file "esp_attr.h" for more information.
   */
  .rtc.force_fast :
  {
    
 . = ALIGN(4); 
 _rtc_force_fast_start = ABSOLUTE(.);
    
 mutable[rtc_force_fast]
    *(.rtc.force_fast .rtc.force_fast.*)
    
 . = ALIGN(4); 
 _rtc_force_fast_end = ABSOLUTE(.);
  } > rtc_data_seg
  /**
   * RTC data section holds RTC wake stub
   * data/rodata, including from any source file
   * named rtc_wake_stub*.c and the data marked with
   * RTC_DATA_ATTR, RTC_RODATA_ATTR attributes.
   * The memory location of the data is dependent on
   * CONFIG_ESP32S3_RTCDATA_IN_FAST_MEM option.
   */
  .rtc.data :
  {
    _rtc_data_start = ABSOLUTE(.);
    
 *(.rtc.data .rtc.data.*)
 *(.rtc.rodata .rtc.rodata.*)
 mutable[rtc_data]
    *rtc_wake_stub*.*(.data .rodata .data.* .rodata.*)
    _rtc_data_end = ABSOLUTE(.);
  } > rtc_data_location
  /* RTC bss, from any source file named rtc_wake_stub*.c */
  .rtc.bss (NOLOAD) :
  {
    _rtc_bss_start = ABSOLUTE(.);
    *rtc_wake_stub*.*(.bss .bss.*)
    *rtc_wake_stub*.*(COMMON)
    
 *(.rtc.bss)
 mutable[rtc_bss]
    _rtc_bss_end = ABSOLUTE(.);
  } > rtc_data_location
  /**
   * This section holds data that should not be initialized at power up
   * and will be retained during deep sleep.
   * User data marked with RTC_NOINIT_ATTR will be placed
   * into this section. See the file "esp_attr.h" for more information.
   * The memory location of the data is dependent on
   * CONFIG_ESP32S3_RTCDATA_IN_FAST_MEM option.
   */
  .rtc_noinit (NOLOAD):
  {
    
 . = ALIGN(4); 
 _rtc_noinit_start = ABSOLUTE(.);
    
 mutable[rtc_noinit]
    *(.rtc_noinit .rtc_noinit.*)
    
 . = ALIGN(4); 
 _rtc_noinit_end = ABSOLUTE(.);
  } > rtc_data_location
  /**
   * This section located in RTC SLOW Memory area.
   * It holds data marked with RTC_SLOW_ATTR attribute.
   * See the file "esp_attr.h" for more information.
   */
  .rtc.force_slow :
  {
    
 . = ALIGN(4); 
 _rtc_force_slow_start = ABSOLUTE(.);
    *(.rtc.force_slow .rtc.force_slow.*)
    
 . = ALIGN(4); 
 _rtc_force_slow_end = ABSOLUTE(.);
  } > rtc_slow_seg
  /**
   * This section holds RTC data that should have fixed addresses.
   * The data are not initialized at power-up and are retained during deep
   * sleep.
   */
  .rtc_reserved (NOLOAD):
  {
    
 . = ALIGN(4); 
 _rtc_reserved_start = ABSOLUTE(.);
    /**
     * New data can only be added here to ensure existing data are not moved.
     * Because data have adhered to the end of the segment and code is relied
     * on it.
     * >> put new data here <<
     */
    *(.rtc_timer_data_in_rtc_mem .rtc_timer_data_in_rtc_mem.*)
    KEEP(*(.bootloader_data_rtc_mem .bootloader_data_rtc_mem.*))
    _rtc_reserved_end = ABSOLUTE(.);
  } > rtc_reserved_seg
  _rtc_reserved_length = _rtc_reserved_end - _rtc_reserved_start;
  ASSERT((_rtc_reserved_length <= LENGTH(rtc_reserved_seg)),
          "RTC reserved segment data does not fit.")
  /* Get size of rtc slow data based on rtc_data_location alias */
  _rtc_slow_length = (ORIGIN(rtc_slow_seg) == ORIGIN(rtc_data_location))
                        ? (_rtc_force_slow_end - _rtc_data_start)
                        : (_rtc_force_slow_end - _rtc_force_slow_start);
  _rtc_fast_length = (ORIGIN(rtc_slow_seg) == ORIGIN(rtc_data_location))
                        ? (_rtc_force_fast_end - _rtc_fast_start)
                        : (_rtc_noinit_end - _rtc_fast_start);
  ASSERT((_rtc_slow_length <= LENGTH(rtc_slow_seg)),
          "RTC_SLOW segment data does not fit.")
  ASSERT((_rtc_fast_length <= LENGTH(rtc_data_seg)),
          "RTC_FAST segment data does not fit.")
  /* Send .iram0 code to iram */
  .iram0.vectors :
  {
    _iram_start = ABSOLUTE(.);
    /* Vectors go to IRAM */
    _vector_table = ABSOLUTE(.);
    . = 0x0;
    KEEP(*(.WindowVectors.text));
    . = 0x180;
    KEEP(*(.Level2InterruptVector.text));
    . = 0x1c0;
    KEEP(*(.Level3InterruptVector.text));
    . = 0x200;
    KEEP(*(.Level4InterruptVector.text));
    . = 0x240;
    KEEP(*(.Level5InterruptVector.text));
    . = 0x280;
    KEEP(*(.DebugExceptionVector.text));
    . = 0x2c0;
    KEEP(*(.NMIExceptionVector.text));
    . = 0x300;
    KEEP(*(.KernelExceptionVector.text));
    . = 0x340;
    KEEP(*(.UserExceptionVector.text));
    . = 0x3C0;
    KEEP(*(.DoubleExceptionVector.text));
    . = 0x400;
    KEEP(*(._invalid_pc_placeholder.text));
    *(.*Vector.literal)
  } > iram0_0_seg
  .iram0.text :
  {
    /* Code marked as running out of IRAM */
    _iram_text_start = ABSOLUTE(.);
    
 *(.iram1 .iram1.*)
 *libclang_rt.builtins.a:_divsf3.*(.literal .literal.* .text .text.*)
 *libesp_driver_dma.a:gdma.*(.literal.gdma_append .text.gdma_append)
 *libesp_driver_dma.a:gdma.*(.literal.gdma_default_rx_isr .text.gdma_default_rx_isr)
 *libesp_driver_dma.a:gdma.*(.literal.gdma_default_tx_isr .text.gdma_default_tx_isr)
 *libesp_driver_dma.a:gdma.*(.literal.gdma_reset .text.gdma_reset)
 *libesp_driver_dma.a:gdma.*(.literal.gdma_start .text.gdma_start)
 *libesp_driver_dma.a:gdma.*(.literal.gdma_stop .text.gdma_stop)
 *libesp_driver_dma.a:gdma_link.*(.literal.gdma_link_check_end .text.gdma_link_check_end)
 *libesp_driver_dma.a:gdma_link.*(.literal.gdma_link_concat .text.gdma_link_concat)
 *libesp_driver_dma.a:gdma_link.*(.literal.gdma_link_count_buffer_size_till_eof .text.gdma_link_count_buffer_size_till_eof)
 *libesp_driver_dma.a:gdma_link.*(.literal.gdma_link_get_buffer .text.gdma_link_get_buffer)
 *libesp_driver_dma.a:gdma_link.*(.literal.gdma_link_get_head_addr .text.gdma_link_get_head_addr)
 *libesp_driver_dma.a:gdma_link.*(.literal.gdma_link_get_length .text.gdma_link_get_length)
 *libesp_driver_dma.a:gdma_link.*(.literal.gdma_link_mount_buffers .text.gdma_link_mount_buffers)
 *libesp_driver_dma.a:gdma_link.*(.literal.gdma_link_set_length .text.gdma_link_set_length)
 *libesp_driver_dma.a:gdma_link.*(.literal.gdma_link_set_owner .text.gdma_link_set_owner)
 *libesp_driver_i2c.a:i2c_master.*(.literal.i2c_master_isr_handler_default .text.i2c_master_isr_handler_default)
 *libesp_driver_rmt.a:rmt_encoder.*(.literal.rmt_encoder_reset .text.rmt_encoder_reset)
 *libesp_driver_rmt.a:rmt_rx.*(.literal.rmt_dma_rx_one_block_cb .text.rmt_dma_rx_one_block_cb)
 *libesp_driver_rmt.a:rmt_rx.*(.literal.rmt_isr_handle_rx_done .text.rmt_isr_handle_rx_done)
 *libesp_driver_rmt.a:rmt_rx.*(.literal.rmt_isr_handle_rx_threshold .text.rmt_isr_handle_rx_threshold)
 *libesp_driver_rmt.a:rmt_rx.*(.literal.rmt_rx_default_isr .text.rmt_rx_default_isr)
 *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_dma_tx_eof_cb .text.rmt_dma_tx_eof_cb)
 *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_encode_check_result .text.rmt_encode_check_result)
 *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_isr_handle_tx_done .text.rmt_isr_handle_tx_done)
 *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_isr_handle_tx_loop_end .text.rmt_isr_handle_tx_loop_end)
 *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_isr_handle_tx_threshold .text.rmt_isr_handle_tx_threshold)
 *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_tx_default_isr .text.rmt_tx_default_isr)
 *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_tx_do_transaction .text.rmt_tx_do_transaction)
 *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_tx_mark_eof .text.rmt_tx_mark_eof)
 *libesp_event.a:default_event_loop.*(.literal.esp_event_isr_post .text.esp_event_isr_post)
 *libesp_event.a:esp_event.*(.literal.esp_event_isr_post_to .text.esp_event_isr_post_to)
 *libesp_hal_dma.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_append .text.gdma_ahb_hal_append)
 *libesp_hal_dma.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_clear_intr .text.gdma_ahb_hal_clear_intr)
 *libesp_hal_dma.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_get_eof_desc_addr .text.gdma_ahb_hal_get_eof_desc_addr)
 *libesp_hal_dma.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_read_intr_status .text.gdma_ahb_hal_read_intr_status)
 *libesp_hal_dma.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_reset .text.gdma_ahb_hal_reset)
 *libesp_hal_dma.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_start_with_desc .text.gdma_ahb_hal_start_with_desc)
 *libesp_hal_dma.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_stop .text.gdma_ahb_hal_stop)
 *libesp_hal_dma.a:gdma_hal_top.*(.literal.gdma_hal_append .text.gdma_hal_append)
 *libesp_hal_dma.a:gdma_hal_top.*(.literal.gdma_hal_clear_intr .text.gdma_hal_clear_intr)
 *libesp_hal_dma.a:gdma_hal_top.*(.literal.gdma_hal_get_eof_desc_addr .text.gdma_hal_get_eof_desc_addr)
 *libesp_hal_dma.a:gdma_hal_top.*(.literal.gdma_hal_read_intr_status .text.gdma_hal_read_intr_status)
 *libesp_hal_dma.a:gdma_hal_top.*(.literal.gdma_hal_reset .text.gdma_hal_reset)
 *libesp_hal_dma.a:gdma_hal_top.*(.literal.gdma_hal_start_with_desc .text.gdma_hal_start_with_desc)
 *libesp_hal_dma.a:gdma_hal_top.*(.literal.gdma_hal_stop .text.gdma_hal_stop)
 *libesp_hal_gpio.a:gpio_hal.*(.literal.gpio_hal_isolate_in_sleep .text.gpio_hal_isolate_in_sleep)
 *libesp_hal_gpspi.a:spi_hal_iram.*(.literal .literal.* .text .text.*)
 *libesp_hal_gpspi.a:spi_slave_hal_iram.*(.literal .literal.* .text .text.*)
 *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.*(.literal .literal.* .text .text.*)
 *libesp_hal_mspi.a:spi_flash_hal_gpspi.*(.literal .literal.* .text .text.*)
 *libesp_hal_mspi.a:spi_flash_hal_iram.*(.literal .literal.* .text .text.*)
 *libesp_hal_wdt.a:rom_patch.*(.literal .literal.* .text .text.*)
 *libesp_hw_support.a:clk_utils.*(.literal .literal.* .text .text.*)
 *libesp_hw_support.a:cpu.*(.literal.esp_cpu_compare_and_set .text.esp_cpu_compare_and_set)
 *libesp_hw_support.a:cpu.*(.literal.esp_cpu_reset .text.esp_cpu_reset)
 *libesp_hw_support.a:cpu.*(.literal.esp_cpu_stall .text.esp_cpu_stall)
 *libesp_hw_support.a:cpu.*(.literal.esp_cpu_unstall .text.esp_cpu_unstall)
 *libesp_hw_support.a:cpu.*(.literal.esp_cpu_wait_for_intr .text.esp_cpu_wait_for_intr)
 *libesp_hw_support.a:esp_clk_tree.*(.literal.esp_clk_tree_enable_power .text.esp_clk_tree_enable_power)
 *libesp_hw_support.a:esp_clk_tree.*(.literal.esp_clk_tree_enable_src .text.esp_clk_tree_enable_src)
 *libesp_hw_support.a:esp_clk_tree.*(.literal.esp_clk_tree_is_power_on .text.esp_clk_tree_is_power_on)
 *libesp_hw_support.a:esp_memory_utils.*(.literal .literal.* .text .text.*)
 *libesp_hw_support.a:mspi_timing_by_mspi_delay.*(.literal .literal.* .text .text.*)
 *libesp_hw_support.a:mspi_timing_config.*(.literal .literal.* .text .text.*)
 *libesp_hw_support.a:mspi_timing_tuning.*(.literal .literal.* .text .text.*)
 *libesp_hw_support.a:periph_ctrl.*(.literal.periph_module_reset .text.periph_module_reset)
 *libesp_hw_support.a:periph_ctrl.*(.literal.periph_rcc_acquire_enter .text.periph_rcc_acquire_enter)
 *libesp_hw_support.a:periph_ctrl.*(.literal.periph_rcc_acquire_exit .text.periph_rcc_acquire_exit)
 *libesp_hw_support.a:periph_ctrl.*(.literal.periph_rcc_enter .text.periph_rcc_enter)
 *libesp_hw_support.a:periph_ctrl.*(.literal.periph_rcc_exit .text.periph_rcc_exit)
 *libesp_hw_support.a:periph_ctrl.*(.literal.periph_rcc_release_enter .text.periph_rcc_release_enter)
 *libesp_hw_support.a:periph_ctrl.*(.literal.periph_rcc_release_exit .text.periph_rcc_release_exit)
 *libesp_hw_support.a:periph_ctrl.*(.literal.wifi_module_disable .text.wifi_module_disable)
 *libesp_hw_support.a:periph_ctrl.*(.literal.wifi_module_enable .text.wifi_module_enable)
 *libesp_hw_support.a:regi2c_ctrl.*(.literal.regi2c_ctrl_read_reg .text.regi2c_ctrl_read_reg)
 *libesp_hw_support.a:regi2c_ctrl.*(.literal.regi2c_ctrl_read_reg_mask .text.regi2c_ctrl_read_reg_mask)
 *libesp_hw_support.a:regi2c_ctrl.*(.literal.regi2c_ctrl_write_reg .text.regi2c_ctrl_write_reg)
 *libesp_hw_support.a:regi2c_ctrl.*(.literal.regi2c_ctrl_write_reg_mask .text.regi2c_ctrl_write_reg_mask)
 *libesp_hw_support.a:regi2c_ctrl.*(.literal.regi2c_enter_critical .text.regi2c_enter_critical)
 *libesp_hw_support.a:regi2c_ctrl.*(.literal.regi2c_exit_critical .text.regi2c_exit_critical)
 *libesp_hw_support.a:rtc_clk.*(.literal .literal.* .text .text.*)
 *libesp_hw_support.a:rtc_init.*(.literal.rtc_vddsdio_get_config .text.rtc_vddsdio_get_config)
 *libesp_hw_support.a:rtc_init.*(.literal.rtc_vddsdio_set_config .text.rtc_vddsdio_set_config)
 *libesp_hw_support.a:rtc_sleep.*(.literal.rtc_sleep_pu .text.rtc_sleep_pu)
 *libesp_hw_support.a:rtc_sleep.*(.literal.rtc_sleep_start .text.rtc_sleep_start)
 *libesp_hw_support.a:rtc_time.*(.literal .literal.* .text .text.*)
 *libesp_hw_support.a:systimer.*(.literal .literal.* .text .text.*)
 *libesp_libc.a:abort.*(.literal .literal.* .text .text.*)
 *libesp_libc.a:assert.*(.literal .literal.* .text .text.*)
 *libesp_libc.a:heap.*(.literal .literal.* .text .text.*)
 *libesp_libc.a:stdatomic.*(.literal .literal.* .text .text.*)
 *libesp_mm.a:esp_cache_msync.*(.literal .literal.* .text .text.*)
 *libesp_mm.a:esp_cache_utils.*(.literal .literal.* .text .text.*)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvAcquireItemNoSplit .text.prvAcquireItemNoSplit)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvCheckItemAvail .text.prvCheckItemAvail)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvCheckItemFitsByteBuffer .text.prvCheckItemFitsByteBuffer)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvCheckItemFitsDefault .text.prvCheckItemFitsDefault)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvCopyItemAllowSplit .text.prvCopyItemAllowSplit)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvCopyItemByteBuf .text.prvCopyItemByteBuf)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvCopyItemNoSplit .text.prvCopyItemNoSplit)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvGetItemByteBuf .text.prvGetItemByteBuf)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvGetItemDefault .text.prvGetItemDefault)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvReceiveGenericFromISR .text.prvReceiveGenericFromISR)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvReturnItemByteBuf .text.prvReturnItemByteBuf)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvReturnItemDefault .text.prvReturnItemDefault)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvSendItemDoneNoSplit .text.prvSendItemDoneNoSplit)
 *libesp_ringbuf.a:ringbuf.*(.literal.vRingbufferReturnItemFromISR .text.vRingbufferReturnItemFromISR)
 *libesp_ringbuf.a:ringbuf.*(.literal.xRingbufferReceiveFromISR .text.xRingbufferReceiveFromISR)
 *libesp_ringbuf.a:ringbuf.*(.literal.xRingbufferReceiveSplitFromISR .text.xRingbufferReceiveSplitFromISR)
 *libesp_ringbuf.a:ringbuf.*(.literal.xRingbufferReceiveUpToFromISR .text.xRingbufferReceiveUpToFromISR)
 *libesp_ringbuf.a:ringbuf.*(.literal.xRingbufferSendFromISR .text.xRingbufferSendFromISR)
 *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.*(.literal .literal.* .text .text.*)
 *libesp_rom.a:esp_rom_cache_writeback_esp32s3.*(.literal .literal.* .text .text.*)
 *libesp_rom.a:esp_rom_print.*(.literal .literal.* .text .text.*)
 *libesp_rom.a:esp_rom_spiflash.*(.literal .literal.* .text .text.*)
 *libesp_rom.a:esp_rom_sys.*(.literal .literal.* .text .text.*)
 *libesp_rom.a:esp_rom_systimer.*(.literal .literal.* .text .text.*)
 *libesp_system.a:esp_err.*(.literal .literal.* .text .text.*)
 *libesp_system.a:esp_system_chip.*(.literal.esp_system_abort .text.esp_system_abort)
 *libesp_system.a:freertos_hooks.*(.literal.esp_vApplicationIdleHook .text.esp_vApplicationIdleHook)
 *libesp_system.a:freertos_hooks.*(.literal.esp_vApplicationTickHook .text.esp_vApplicationTickHook)
 *libesp_system.a:image_process.*(.literal .literal.* .text .text.*)
 *libesp_system.a:panic.*(.literal.panic_abort .text.panic_abort)
 *libesp_system.a:reset_reason.*(.literal.esp_reset_reason_set_hint .text.esp_reset_reason_set_hint)
 *libesp_system.a:system_internal.*(.literal.esp_restart_noos .text.esp_restart_noos)
 *libesp_system.a:system_internal.*(.literal.esp_system_reset_modules_on_exit .text.esp_system_reset_modules_on_exit)
 *libesp_system.a:system_time.*(.literal.esp_system_get_time .text.esp_system_get_time)
 *libesp_system.a:system_time.*(.literal.esp_system_get_time_resolution .text.esp_system_get_time_resolution)
 *libesp_system.a:ubsan.*(.literal .literal.* .text .text.*)
 *libfreertos.a:event_groups.*(.literal.xEventGroupGetBitsFromISR .text.xEventGroupGetBitsFromISR)
 *libfreertos.a:list.*(.literal.uxListRemove .text.uxListRemove)
 *libfreertos.a:list.*(.literal.vListInsertEnd .text.vListInsertEnd)
 *libfreertos.a:port.*(.literal.vPortAssertIfInISR .text.vPortAssertIfInISR)
 *libfreertos.a:port.*(.literal.vPortExitCritical .text.vPortExitCritical)
 *libfreertos.a:port.*(.literal.vPortSetStackWatchpoint .text.vPortSetStackWatchpoint)
 *libfreertos.a:port.*(.literal.vPortYieldOtherCore .text.vPortYieldOtherCore)
 *libfreertos.a:port.*(.literal.xPortEnterCriticalTimeout .text.xPortEnterCriticalTimeout)
 *libfreertos.a:port.*(.literal.xPortInIsrContext .text.xPortInIsrContext)
 *libfreertos.a:port.*(.literal.xPortInterruptedFromISRContext .text.xPortInterruptedFromISRContext)
 *libfreertos.a:port.*(.literal.xPortStartScheduler .text.xPortStartScheduler)
 *libfreertos.a:port_systick.*(.literal .literal.* .text .text.*)
 *libfreertos.a:portasm.*(.literal .literal.* .text .text.*)
 *libfreertos.a:queue.*(.literal.prvCopyDataFromQueue .text.prvCopyDataFromQueue)
 *libfreertos.a:queue.*(.literal.prvCopyDataToQueue .text.prvCopyDataToQueue)
 *libfreertos.a:queue.*(.literal.prvNotifyQueueSetContainer .text.prvNotifyQueueSetContainer)
 *libfreertos.a:queue.*(.literal.uxQueueMessagesWaitingFromISR .text.uxQueueMessagesWaitingFromISR)
 *libfreertos.a:queue.*(.literal.xQueueGenericSendFromISR .text.xQueueGenericSendFromISR)
 *libfreertos.a:queue.*(.literal.xQueueGetMutexHolderFromISR .text.xQueueGetMutexHolderFromISR)
 *libfreertos.a:queue.*(.literal.xQueueGiveFromISR .text.xQueueGiveFromISR)
 *libfreertos.a:queue.*(.literal.xQueueIsQueueEmptyFromISR .text.xQueueIsQueueEmptyFromISR)
 *libfreertos.a:queue.*(.literal.xQueueIsQueueFullFromISR .text.xQueueIsQueueFullFromISR)
 *libfreertos.a:queue.*(.literal.xQueuePeekFromISR .text.xQueuePeekFromISR)
 *libfreertos.a:queue.*(.literal.xQueueReceiveFromISR .text.xQueueReceiveFromISR)
 *libfreertos.a:queue.*(.literal.xQueueSelectFromSetFromISR .text.xQueueSelectFromSetFromISR)
 *libfreertos.a:stream_buffer.*(.literal.prvBytesInBuffer .text.prvBytesInBuffer)
 *libfreertos.a:stream_buffer.*(.literal.prvReadMessageFromBuffer .text.prvReadMessageFromBuffer)
 *libfreertos.a:stream_buffer.*(.literal.prvWriteMessageToBuffer .text.prvWriteMessageToBuffer)
 *libfreertos.a:stream_buffer.*(.literal.xStreamBufferReceiveCompletedFromISR .text.xStreamBufferReceiveCompletedFromISR)
 *libfreertos.a:stream_buffer.*(.literal.xStreamBufferReceiveFromISR .text.xStreamBufferReceiveFromISR)
 *libfreertos.a:stream_buffer.*(.literal.xStreamBufferSendCompletedFromISR .text.xStreamBufferSendCompletedFromISR)
 *libfreertos.a:stream_buffer.*(.literal.xStreamBufferSendFromISR .text.xStreamBufferSendFromISR)
 *libfreertos.a:tasks.*(.literal.prvCheckTaskCanBeScheduledSMP .text.prvCheckTaskCanBeScheduledSMP)
 *libfreertos.a:tasks.*(.literal.prvIdleTask .text.prvIdleTask)
 *libfreertos.a:tasks.*(.literal.prvIsYieldRequiredSMP .text.prvIsYieldRequiredSMP)
 *libfreertos.a:tasks.*(.literal.prvResetNextTaskUnblockTime .text.prvResetNextTaskUnblockTime)
 *libfreertos.a:tasks.*(.literal.uxTaskPriorityGetFromISR .text.uxTaskPriorityGetFromISR)
 *libfreertos.a:tasks.*(.literal.vTaskGenericNotifyGiveFromISR .text.vTaskGenericNotifyGiveFromISR)
 *libfreertos.a:tasks.*(.literal.vTaskGetSnapshot .text.vTaskGetSnapshot)
 *libfreertos.a:tasks.*(.literal.vTaskSwitchContext .text.vTaskSwitchContext)
 *libfreertos.a:tasks.*(.literal.xTaskGenericNotifyFromISR .text.xTaskGenericNotifyFromISR)
 *libfreertos.a:tasks.*(.literal.xTaskGetSchedulerState .text.xTaskGetSchedulerState)
 *libfreertos.a:tasks.*(.literal.xTaskGetTickCount .text.xTaskGetTickCount)
 *libfreertos.a:tasks.*(.literal.xTaskGetTickCountFromISR .text.xTaskGetTickCountFromISR)
 *libfreertos.a:tasks.*(.literal.xTaskIncrementTick .text.xTaskIncrementTick)
 *libfreertos.a:tasks.*(.literal.xTaskIncrementTickOtherCores .text.xTaskIncrementTickOtherCores)
 *libfreertos.a:tasks.*(.literal.xTaskRemoveFromEventList .text.xTaskRemoveFromEventList)
 *libfreertos.a:tasks.*(.literal.xTaskResumeFromISR .text.xTaskResumeFromISR)
 *libfreertos.a:timers.*(.literal.xTimerGenericCommand .text.xTimerGenericCommand)
 *libfreertos.a:timers.*(.literal.xTimerPendFunctionCallFromISR .text.xTimerPendFunctionCallFromISR)
 *libgcc.a:_divsf3.*(.literal .literal.* .text .text.*)
 *libgcc.a:lib2funcs.*(.literal .literal.* .text .text.*)
 *libgcov.a:(.literal .literal.* .text .text.*)
 *libhal.a:cache_hal.*(.literal .literal.* .text .text.*)
 *libhal.a:mmu_hal.*(.literal .literal.* .text .text.*)
 *libhal.a:systimer_hal.*(.literal .literal.* .text .text.*)
 *libheap.a:multi_heap.*(.literal.assert_valid_block .text.assert_valid_block)
 *libheap.a:multi_heap.*(.literal.multi_heap_aligned_alloc_impl .text.multi_heap_aligned_alloc_impl)
 *libheap.a:multi_heap.*(.literal.multi_heap_aligned_alloc_impl_offs .text.multi_heap_aligned_alloc_impl_offs)
 *libheap.a:multi_heap.*(.literal.multi_heap_aligned_alloc_offs .text.multi_heap_aligned_alloc_offs)
 *libheap.a:multi_heap.*(.literal.multi_heap_free_impl .text.multi_heap_free_impl)
 *libheap.a:multi_heap.*(.literal.multi_heap_get_allocated_size_impl .text.multi_heap_get_allocated_size_impl)
 *libheap.a:multi_heap.*(.literal.multi_heap_get_block_address_impl .text.multi_heap_get_block_address_impl)
 *libheap.a:multi_heap.*(.literal.multi_heap_get_first_block .text.multi_heap_get_first_block)
 *libheap.a:multi_heap.*(.literal.multi_heap_get_full_block_size .text.multi_heap_get_full_block_size)
 *libheap.a:multi_heap.*(.literal.multi_heap_get_next_block .text.multi_heap_get_next_block)
 *libheap.a:multi_heap.*(.literal.multi_heap_internal_lock .text.multi_heap_internal_lock)
 *libheap.a:multi_heap.*(.literal.multi_heap_internal_unlock .text.multi_heap_internal_unlock)
 *libheap.a:multi_heap.*(.literal.multi_heap_is_free .text.multi_heap_is_free)
 *libheap.a:multi_heap.*(.literal.multi_heap_malloc_impl .text.multi_heap_malloc_impl)
 *libheap.a:multi_heap.*(.literal.multi_heap_realloc_impl .text.multi_heap_realloc_impl)
 *libheap.a:multi_heap.*(.literal.multi_heap_set_lock .text.multi_heap_set_lock)
 *libheap.a:tlsf.*(.literal.tlsf_alloc_overhead .text.tlsf_alloc_overhead)
 *libheap.a:tlsf.*(.literal.tlsf_block_size .text.tlsf_block_size)
 *libheap.a:tlsf.*(.literal.tlsf_free .text.tlsf_free)
 *libheap.a:tlsf.*(.literal.tlsf_get_pool .text.tlsf_get_pool)
 *libheap.a:tlsf.*(.literal.tlsf_malloc .text.tlsf_malloc)
 *libheap.a:tlsf.*(.literal.tlsf_memalign .text.tlsf_memalign)
 *libheap.a:tlsf.*(.literal.tlsf_memalign_offs .text.tlsf_memalign_offs)
 *libheap.a:tlsf.*(.literal.tlsf_realloc .text.tlsf_realloc)
 *libheap.a:tlsf.*(.literal.tlsf_size .text.tlsf_size)
 *liblog.a:log.*(.literal .literal.* .text .text.*)
 *liblog.a:log_format_text.*(.literal .literal.* .text .text.*)
 *liblog.a:log_lock.*(.literal .literal.* .text .text.*)
 *liblog.a:log_print.*(.literal .literal.* .text .text.*)
 *liblog.a:log_timestamp.*(.literal.esp_log_early_timestamp .text.esp_log_early_timestamp)
 *liblog.a:log_timestamp.*(.literal.esp_log_timestamp .text.esp_log_timestamp)
 *liblog.a:log_timestamp_common.*(.literal .literal.* .text .text.*)
 *liblog.a:log_write.*(.literal.esp_log_write .text.esp_log_write)
 *liblog.a:log_write.*(.literal.esp_log_writev .text.esp_log_writev)
 *liblog.a:tag_log_level.*(.literal.esp_log_level_get_timeout .text.esp_log_level_get_timeout)
 *liblog.a:util.*(.literal .literal.* .text .text.*)
 *libmain.a:ksn_core.*(.literal.ksn_core_client .text.ksn_core_client)
 *libmain.a:ksn_core.*(.literal.private_command .text.private_command)
 *libmain.a:ksn_core.*(.literal.referenced_command .text.referenced_command)
 *libmain.a:ksn_core.*(.literal.utf8_count .text.utf8_count)
 *libmain.a:ksn_runtime.*(.literal.ksn_runtime_app_view .text.ksn_runtime_app_view)
 *libmain.a:ksn_view.*(.literal.client .text.client)
 *libmain.a:ksn_view.*(.literal.ksn_view_change .text.ksn_view_change)
 *libmain.a:ksn_view.*(.literal.ksn_view_host_endpoint .text.ksn_view_host_endpoint)
 *libmain.a:ksn_view.*(.literal.owns .text.owns)
 *libmain.a:ksn_view.*(.literal.valid .text.valid)
 *libmain.a:pocket_kasane.*(.literal.mutate .text.mutate)
 *libmain.a:pocket_kasane.*(.literal.parse_i16 .text.parse_i16)
 *libmain.a:pocket_kasane.*(.literal.parse_rect_mode .text.parse_rect_mode)
 *libmain.a:solar_sail.*(.literal.view .text.view)
 *libquickjs-ng.a:dtoa.*(.literal.u32toa .text.u32toa)
 *libquickjs-ng.a:quickjs.*(.literal.JS_AtomToValue .text.JS_AtomToValue)
 *libquickjs-ng.a:quickjs.*(.literal.JS_ConcatString2 .text.JS_ConcatString2)
 *libquickjs-ng.a:quickjs.*(.literal.JS_DefinePropertyValue .text.JS_DefinePropertyValue)
 *libquickjs-ng.a:quickjs.*(.literal.JS_DefinePropertyValueConst .text.JS_DefinePropertyValueConst)
 *libquickjs-ng.a:quickjs.*(.literal.JS_DupAtom .text.JS_DupAtom)
 *libquickjs-ng.a:quickjs.*(.literal.JS_FreeAtom .text.JS_FreeAtom)
 *libquickjs-ng.a:quickjs.*(.literal.JS_FreeAtomRT .text.JS_FreeAtomRT)
 *libquickjs-ng.a:quickjs.*(.literal.JS_FreeValue .text.JS_FreeValue)
 *libquickjs-ng.a:quickjs.*(.literal.JS_FreeValueRT .text.JS_FreeValueRT)
 *libquickjs-ng.a:quickjs.*(.literal.JS_GetLength .text.JS_GetLength)
 *libquickjs-ng.a:quickjs.*(.literal.JS_GetOpaque .text.JS_GetOpaque)
 *libquickjs-ng.a:quickjs.*(.literal.JS_GetProperty .text.JS_GetProperty)
 *libquickjs-ng.a:quickjs.*(.literal.JS_GetPropertyInt64 .text.JS_GetPropertyInt64)
 *libquickjs-ng.a:quickjs.*(.literal.JS_GetPropertyStr .text.JS_GetPropertyStr)
 *libquickjs-ng.a:quickjs.*(.literal.JS_GetPropertyUint32 .text.JS_GetPropertyUint32)
 *libquickjs-ng.a:quickjs.*(.literal.JS_IsArray .text.JS_IsArray)
 *libquickjs-ng.a:quickjs.*(.literal.JS_IsEmptyString .text.JS_IsEmptyString)
 *libquickjs-ng.a:quickjs.*(.literal.JS_NewArray .text.JS_NewArray)
 *libquickjs-ng.a:quickjs.*(.literal.JS_NewArrayFrom .text.JS_NewArrayFrom)
 *libquickjs-ng.a:quickjs.*(.literal.JS_NewAtom .text.JS_NewAtom)
 *libquickjs-ng.a:quickjs.*(.literal.JS_NewObject .text.JS_NewObject)
 *libquickjs-ng.a:quickjs.*(.literal.JS_NewObjectFromShape .text.JS_NewObjectFromShape)
 *libquickjs-ng.a:quickjs.*(.literal.JS_NewObjectProtoClass .text.JS_NewObjectProtoClass)
 *libquickjs-ng.a:quickjs.*(.literal.JS_ToFloat64 .text.JS_ToFloat64)
 *libquickjs-ng.a:quickjs.*(.literal.JS_ToFloat64Free .text.JS_ToFloat64Free)
 *libquickjs-ng.a:quickjs.*(.literal.JS_ToInt32Free .text.JS_ToInt32Free)
 *libquickjs-ng.a:quickjs.*(.literal.JS_ToInt64Clamp .text.JS_ToInt64Clamp)
 *libquickjs-ng.a:quickjs.*(.literal.JS_ToLengthFree .text.JS_ToLengthFree)
 *libquickjs-ng.a:quickjs.*(.literal.JS_ToNumericFree .text.JS_ToNumericFree)
 *libquickjs-ng.a:quickjs.*(.literal.JS_ToString .text.JS_ToString)
 *libquickjs-ng.a:quickjs.*(.literal.JS_ToStringFree .text.JS_ToStringFree)
 *libquickjs-ng.a:quickjs.*(.literal.__JS_FreeAtom .text.__JS_FreeAtom)
 *libquickjs-ng.a:quickjs.*(.literal.add_property .text.add_property)
 *libquickjs-ng.a:quickjs.*(.literal.add_shape_property .text.add_shape_property)
 *libquickjs-ng.a:quickjs.*(.literal.expand_fast_array .text.expand_fast_array)
 *libquickjs-ng.a:quickjs.*(.literal.find_own_property .text.find_own_property)
 *libquickjs-ng.a:quickjs.*(.literal.free_gc_object .text.free_gc_object)
 *libquickjs-ng.a:quickjs.*(.literal.free_property .text.free_property)
 *libquickjs-ng.a:quickjs.*(.literal.get_u16 .text.get_u16)
 *libquickjs-ng.a:quickjs.*(.literal.get_u32 .text.get_u32)
 *libquickjs-ng.a:quickjs.*(.literal.js_alloc_string .text.js_alloc_string)
 *libquickjs-ng.a:quickjs.*(.literal.js_alloc_string_rt .text.js_alloc_string_rt)
 *libquickjs-ng.a:quickjs.*(.literal.js_array_finalizer .text.js_array_finalizer)
 *libquickjs-ng.a:quickjs.*(.literal.js_dup .text.js_dup)
 *libquickjs-ng.a:quickjs.*(.literal.js_free_rt .text.js_free_rt)
 *libquickjs-ng.a:quickjs.*(.literal.js_free_shape .text.js_free_shape)
 *libquickjs-ng.a:quickjs.*(.literal.js_free_string0 .text.js_free_string0)
 *libquickjs-ng.a:quickjs.*(.literal.js_function_proto .text.js_function_proto)
 *libquickjs-ng.a:quickjs.*(.literal.js_get_fast_array_element .text.js_get_fast_array_element)
 *libquickjs-ng.a:quickjs.*(.literal.js_get_length64 .text.js_get_length64)
 *libquickjs-ng.a:quickjs.*(.literal.js_malloc .text.js_malloc)
 *libquickjs-ng.a:quickjs.*(.literal.js_malloc_rt .text.js_malloc_rt)
 *libquickjs-ng.a:quickjs.*(.literal.js_malloc_usable_size .text.js_malloc_usable_size)
 *libquickjs-ng.a:quickjs.*(.literal.js_malloc_usable_size_rt .text.js_malloc_usable_size_rt)
 *libquickjs-ng.a:quickjs.*(.literal.js_math_sin .text.js_math_sin)
 *libquickjs-ng.a:quickjs.*(.literal.js_new_string8_len .text.js_new_string8_len)
 *libquickjs-ng.a:quickjs.*(.literal.js_number .text.js_number)
 *libquickjs-ng.a:quickjs.*(.literal.js_poll_interrupts .text.js_poll_interrupts)
 *libquickjs-ng.a:quickjs.*(.literal.js_poll_safepoint .text.js_poll_safepoint)
 *libquickjs-ng.a:quickjs.*(.literal.js_realloc .text.js_realloc)
 *libquickjs-ng.a:quickjs.*(.literal.js_realloc2 .text.js_realloc2)
 *libquickjs-ng.a:quickjs.*(.literal.js_realloc_rt .text.js_realloc_rt)
 *libquickjs-ng.a:quickjs.*(.literal.js_rom_atom .text.js_rom_atom)
 *libquickjs-ng.a:quickjs.*(.literal.js_shape_hash_link .text.js_shape_hash_link)
 *libquickjs-ng.a:quickjs.*(.literal.js_shape_hash_unlink .text.js_shape_hash_unlink)
 *libquickjs-ng.a:quickjs.*(.literal.js_vm_leave_frameless .text.js_vm_leave_frameless)
 *libquickjs-ng.a:quickjs.*(.literal.js_vm_pop_frame .text.js_vm_pop_frame)
 *libquickjs-ng.a:quickjs.*(.literal.lazy_first .text.lazy_first)
 *libquickjs-ng.a:quickjs.*(.literal.lazy_key_is .text.lazy_key_is)
 *libquickjs-ng.a:quickjs.*(.literal.list_del .text.list_del)
 *libquickjs-ng.a:quickjs.*(.literal.set_value .text.set_value)
 *libquickjs-ng.a:quickjs.*(.literal.string_buffer_fill .text.string_buffer_fill)
 *libquickjs-ng.a:quickjs.*(.literal.string_buffer_putc16 .text.string_buffer_putc16)
 *libquickjs-ng.a:quickjs.*(.literal.strv .text.strv)
 *librtc.a:(.literal .literal.* .text .text.*)
 *libsoc.a:lldesc.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:esp_flash_api.*(.literal.check_chip_pointer_default .text.check_chip_pointer_default)
 *libspi_flash.a:esp_flash_api.*(.literal.detect_spi_flash_chip .text.detect_spi_flash_chip)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_chip_driver_initialized .text.esp_flash_chip_driver_initialized)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_erase_chip .text.esp_flash_erase_chip)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_erase_region .text.esp_flash_erase_region)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_get_chip_write_protect .text.esp_flash_get_chip_write_protect)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_get_io_mode .text.esp_flash_get_io_mode)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_get_physical_size .text.esp_flash_get_physical_size)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_get_protected_region .text.esp_flash_get_protected_region)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_get_size .text.esp_flash_get_size)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_init .text.esp_flash_init)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_init_main .text.esp_flash_init_main)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_is_quad_mode .text.esp_flash_is_quad_mode)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_read .text.esp_flash_read)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_read_encrypted .text.esp_flash_read_encrypted)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_set_chip_write_protect .text.esp_flash_set_chip_write_protect)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_set_io_mode .text.esp_flash_set_io_mode)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_set_protected_region .text.esp_flash_set_protected_region)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_write .text.esp_flash_write)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_write_encrypted .text.esp_flash_write_encrypted)
 *libspi_flash.a:esp_flash_api.*(.literal.flash_end_flush_cache .text.flash_end_flush_cache)
 *libspi_flash.a:esp_flash_api.*(.literal.read_unique_id .text.read_unique_id)
 *libspi_flash.a:esp_flash_api.*(.literal.spiflash_end_default .text.spiflash_end_default)
 *libspi_flash.a:esp_flash_api.*(.literal.spiflash_start_core .text.spiflash_start_core)
 *libspi_flash.a:esp_flash_api.*(.literal.spiflash_start_default .text.spiflash_start_default)
 *libspi_flash.a:flash_brownout_hook.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:memspi_host_driver.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:spi_flash_chip_boya.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:spi_flash_chip_gd.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:spi_flash_chip_generic.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:spi_flash_chip_issi.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:spi_flash_chip_mxic.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:spi_flash_chip_mxic_opi.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:spi_flash_chip_th.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:spi_flash_chip_winbond.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:spi_flash_hpm_enable.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:spi_flash_oct_flash_init.*(.literal .literal.* .text .text.*)
 *libspi_flash.a:spi_flash_os_func_app.*(.literal.delay_us .text.delay_us)
 *libspi_flash.a:spi_flash_os_func_app.*(.literal.get_buffer_malloc .text.get_buffer_malloc)
 *libspi_flash.a:spi_flash_os_func_app.*(.literal.main_flash_op_status .text.main_flash_op_status)
 *libspi_flash.a:spi_flash_os_func_app.*(.literal.main_flash_region_protected .text.main_flash_region_protected)
 *libspi_flash.a:spi_flash_os_func_app.*(.literal.release_buffer_malloc .text.release_buffer_malloc)
 *libspi_flash.a:spi_flash_os_func_app.*(.literal.spi23_end .text.spi23_end)
 *libspi_flash.a:spi_flash_os_func_app.*(.literal.spi23_start .text.spi23_start)
 *libspi_flash.a:spi_flash_os_func_app.*(.literal.spi_flash_os_check_yield .text.spi_flash_os_check_yield)
 *libspi_flash.a:spi_flash_os_func_app.*(.literal.spi_flash_os_yield .text.spi_flash_os_yield)
 *libspi_flash.a:spi_flash_os_func_noos.*(.literal.delay_us .text.delay_us)
 *libspi_flash.a:spi_flash_os_func_noos.*(.literal.esp_flash_app_disable_os_functions .text.esp_flash_app_disable_os_functions)
 *libspi_flash.a:spi_flash_os_func_noos.*(.literal.get_temp_buffer_not_supported .text.get_temp_buffer_not_supported)
 *libspi_flash.a:spi_flash_wrap.*(.literal .literal.* .text .text.*)
 *libxt_hal.a:(.literal .literal.* .text .text.*)
 *libxtensa.a:(EXCLUDE_FILE(*libxtensa.a:xt_trax.* *libxtensa.a:xtensa_intr.*) .literal EXCLUDE_FILE(*libxtensa.a:xt_trax.* *libxtensa.a:xtensa_intr.*) .literal.* EXCLUDE_FILE(*libxtensa.a:xt_trax.* *libxtensa.a:xtensa_intr.*) .text EXCLUDE_FILE(*libxtensa.a:xt_trax.* *libxtensa.a:xtensa_intr.*) .text.*)
 mutable[iram0_text]
  } > iram0_0_seg
  /**
   * This section is required to skip .iram0.text area because iram0_0_seg and
   * dram0_0_seg reflect the same address space on different buses.
   */
  .dram0.dummy (NOLOAD):
  {
    . = ORIGIN(dram0_0_seg) + ((_iram_end > _diram_i_start) ? (_iram_end - _diram_i_start) : 0);
  } > dram0_0_seg
  .dram0.data :
  {
    _data_start = ABSOLUTE(.);
    *(.gnu.linkonce.d.*)
    *(.data1)
    *(.sdata)
    *(.sdata.*)
    *(.gnu.linkonce.s.*)
    *(.gnu.linkonce.s2.*)
    *(.jcr)
    
 *(.data .data.*)
 *(.dram1 .dram1.*)
 *libclang_rt.builtins.a:_divsf3.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_driver_dma.a:gdma_link.*(.rodata.gdma_link_mount_buffers .rodata.gdma_link_mount_buffers.str1.1 .sdata2.gdma_link_mount_buffers .srodata.gdma_link_mount_buffers)
 *libesp_driver_rmt.a:rmt_tx.*(.rodata.rmt_isr_handle_tx_done .rodata.rmt_isr_handle_tx_done.str1.1 .sdata2.rmt_isr_handle_tx_done .srodata.rmt_isr_handle_tx_done)
 *libesp_driver_rmt.a:rmt_tx.*(.rodata.rmt_isr_handle_tx_loop_end .rodata.rmt_isr_handle_tx_loop_end.str1.1 .sdata2.rmt_isr_handle_tx_loop_end .srodata.rmt_isr_handle_tx_loop_end)
 *libesp_hal_gpspi.a:spi_hal_iram.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hal_gpspi.a:spi_slave_hal_iram.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hal_mspi.a:spi_flash_hal_gpspi.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hal_mspi.a:spi_flash_hal_iram.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hal_wdt.a:rom_patch.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hw_support.a:clk_utils.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hw_support.a:cpu.*(.rodata.esp_cpu_stall .rodata.esp_cpu_stall.str1.1 .sdata2.esp_cpu_stall .srodata.esp_cpu_stall)
 *libesp_hw_support.a:esp_memory_utils.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hw_support.a:mspi_timing_by_mspi_delay.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hw_support.a:mspi_timing_config.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hw_support.a:mspi_timing_tuning.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hw_support.a:rtc_clk.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_hw_support.a:systimer.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_libc.a:abort.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_libc.a:assert.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_libc.a:heap.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_libc.a:stdatomic.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_mm.a:esp_cache_msync.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_mm.a:esp_cache_utils.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_rom.a:esp_rom_cache_writeback_esp32s3.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_rom.a:esp_rom_print.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_rom.a:esp_rom_spiflash.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_rom.a:esp_rom_sys.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_rom.a:esp_rom_systimer.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_system.a:esp_err.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_system.a:image_process.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libesp_system.a:reset_reason.*(.rodata.esp_reset_reason_set_hint .rodata.esp_reset_reason_set_hint.str1.1 .sdata2.esp_reset_reason_set_hint .srodata.esp_reset_reason_set_hint)
 *libesp_system.a:ubsan.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libgcc.a:_divsf3.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libgcov.a:(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libhal.a:cache_hal.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libhal.a:mmu_hal.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libhal.a:systimer_hal.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libheap.a:multi_heap.*(.rodata.assert_valid_block .rodata.assert_valid_block.str1.1 .sdata2.assert_valid_block .srodata.assert_valid_block)
 *libheap.a:multi_heap.*(.rodata.multi_heap_get_first_block .rodata.multi_heap_get_first_block.str1.1 .sdata2.multi_heap_get_first_block .srodata.multi_heap_get_first_block)
 *libheap.a:multi_heap.*(.rodata.multi_heap_get_next_block .rodata.multi_heap_get_next_block.str1.1 .sdata2.multi_heap_get_next_block .srodata.multi_heap_get_next_block)
 *libheap.a:tlsf.*(.rodata.tlsf_free .rodata.tlsf_free.str1.1 .sdata2.tlsf_free .srodata.tlsf_free)
 *libheap.a:tlsf.*(.rodata.tlsf_malloc .rodata.tlsf_malloc.str1.1 .sdata2.tlsf_malloc .srodata.tlsf_malloc)
 *libheap.a:tlsf.*(.rodata.tlsf_memalign_offs .rodata.tlsf_memalign_offs.str1.1 .sdata2.tlsf_memalign_offs .srodata.tlsf_memalign_offs)
 *liblog.a:log.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *liblog.a:log_format_text.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *liblog.a:log_lock.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *liblog.a:log_print.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *liblog.a:log_timestamp_common.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *liblog.a:util.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libphy.a:(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libsoc.a:lldesc.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:flash_brownout_hook.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:memspi_host_driver.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:spi_flash_chip_boya.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:spi_flash_chip_gd.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:spi_flash_chip_generic.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:spi_flash_chip_issi.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:spi_flash_chip_mxic.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:spi_flash_chip_mxic_opi.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:spi_flash_chip_th.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:spi_flash_chip_winbond.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:spi_flash_hpm_enable.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:spi_flash_oct_flash_init.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 *libspi_flash.a:spi_flash_os_func_app.*(.rodata.spi_flash_os_check_yield .rodata.spi_flash_os_check_yield.str1.1 .sdata2.spi_flash_os_check_yield .srodata.spi_flash_os_check_yield)
 *libspi_flash.a:spi_flash_wrap.*(.rodata .rodata.* .sdata2 .sdata2.* .srodata .srodata.*)
 mutable[dram0_data]
    _data_end = ABSOLUTE(.);
  } > dram0_0_seg
  /**
   * This section holds data that should not be initialized at power up.
   * The section located in Internal SRAM memory region. The macro _NOINIT
   * can be used as attribute to place data into this section.
   * See the "esp_attr.h" file for more information.
   */
  .noinit (NOLOAD):
  {
    
 . = ALIGN(4); 
 _noinit_start = ABSOLUTE(.);
    *(.noinit .noinit.*)
    
 . = ALIGN(4); 
 _noinit_end = ABSOLUTE(.);
  } > dram0_0_seg
  /* Shared RAM */
  .dram0.bss (NOLOAD) :
  {
    
 . = ALIGN(8); 
 _bss_start = ABSOLUTE(.);
    
 *(.bss .bss.*)
 *(.dynbss .dynsbss .gnu.linkonce.b .gnu.linkonce.b.* .gnu.linkonce.sb .gnu.linkonce.sb.* .gnu.linkonce.sb2 .gnu.linkonce.sb2.* .sbss .sbss.* .sbss2 .sbss2.* .scommon .share.mem)
 *(.ext_ram.bss .ext_ram.bss.*)
 *(COMMON)
 mutable[dram0_bss]
    
 . = ALIGN(16); 
 _bss_end = ABSOLUTE(.);
  } > dram0_0_seg
  ASSERT(((_bss_end - ORIGIN(dram0_0_seg)) <= LENGTH(dram0_0_seg)),
         "DRAM segment data does not fit.")
  .flash.text :
  {
    _stext = .;
    /**
     * Mark the start of flash.text.
     * This can be used by the MMU driver to maintain the virtual address.
     */
    _instruction_reserved_start = ABSOLUTE(.);
    _text_start = ABSOLUTE(.);
    
 *(EXCLUDE_FILE(*libgcov.a *librtc.a *libxt_hal.a *libxtensa.a *libclang_rt.builtins.a:_divsf3.* *libesp_driver_dma.a:gdma.* *libesp_driver_dma.a:gdma_link.* *libesp_driver_i2c.a:i2c_master.* *libesp_driver_rmt.a:rmt_encoder.* *libesp_driver_rmt.a:rmt_rx.* *libesp_driver_rmt.a:rmt_tx.* *libesp_event.a:default_event_loop.* *libesp_event.a:esp_event.* *libesp_hal_dma.a:gdma_hal_ahb_v1.* *libesp_hal_dma.a:gdma_hal_top.* *libesp_hal_gpio.a:gpio_hal.* *libesp_hal_gpspi.a:spi_hal_iram.* *libesp_hal_gpspi.a:spi_slave_hal_iram.* *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.* *libesp_hal_mspi.a:spi_flash_hal_gpspi.* *libesp_hal_mspi.a:spi_flash_hal_iram.* *libesp_hal_wdt.a:rom_patch.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_clk_tree.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:periph_ctrl.* *libesp_hw_support.a:regi2c_ctrl.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:rtc_init.* *libesp_hw_support.a:rtc_sleep.* *libesp_hw_support.a:rtc_time.* *libesp_hw_support.a:systimer.* *libesp_libc.a:abort.* *libesp_libc.a:assert.* *libesp_libc.a:heap.* *libesp_libc.a:stdatomic.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_ringbuf.a:ringbuf.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_rom.a:esp_rom_systimer.* *libesp_system.a:esp_err.* *libesp_system.a:esp_system_chip.* *libesp_system.a:freertos_hooks.* *libesp_system.a:image_process.* *libesp_system.a:panic.* *libesp_system.a:reset_reason.* *libesp_system.a:system_internal.* *libesp_system.a:system_time.* *libesp_system.a:ubsan.* *libfreertos.a:event_groups.* *libfreertos.a:list.* *libfreertos.a:port.* *libfreertos.a:port_systick.* *libfreertos.a:portasm.* *libfreertos.a:queue.* *libfreertos.a:stream_buffer.* *libfreertos.a:tasks.* *libfreertos.a:timers.* *libgcc.a:_divsf3.* *libgcc.a:lib2funcs.* *libhal.a:cache_hal.* *libhal.a:mmu_hal.* *libhal.a:systimer_hal.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp.* *liblog.a:log_timestamp_common.* *liblog.a:log_write.* *liblog.a:tag_log_level.* *liblog.a:util.* *libmain.a:ksn_core.* *libmain.a:ksn_runtime.* *libmain.a:ksn_view.* *libmain.a:pocket_kasane.* *libmain.a:solar_sail.* *libquickjs-ng.a:dtoa.* *libquickjs-ng.a:quickjs.* *libsoc.a:lldesc.* *libspi_flash.a:esp_flash_api.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_os_func_noos.* *libspi_flash.a:spi_flash_wrap.*) .literal EXCLUDE_FILE(*libgcov.a *librtc.a *libxt_hal.a *libxtensa.a *libclang_rt.builtins.a:_divsf3.* *libesp_driver_dma.a:gdma.* *libesp_driver_dma.a:gdma_link.* *libesp_driver_i2c.a:i2c_master.* *libesp_driver_rmt.a:rmt_encoder.* *libesp_driver_rmt.a:rmt_rx.* *libesp_driver_rmt.a:rmt_tx.* *libesp_event.a:default_event_loop.* *libesp_event.a:esp_event.* *libesp_hal_dma.a:gdma_hal_ahb_v1.* *libesp_hal_dma.a:gdma_hal_top.* *libesp_hal_gpio.a:gpio_hal.* *libesp_hal_gpspi.a:spi_hal_iram.* *libesp_hal_gpspi.a:spi_slave_hal_iram.* *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.* *libesp_hal_mspi.a:spi_flash_hal_gpspi.* *libesp_hal_mspi.a:spi_flash_hal_iram.* *libesp_hal_wdt.a:rom_patch.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_clk_tree.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:periph_ctrl.* *libesp_hw_support.a:regi2c_ctrl.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:rtc_init.* *libesp_hw_support.a:rtc_sleep.* *libesp_hw_support.a:rtc_time.* *libesp_hw_support.a:systimer.* *libesp_libc.a:abort.* *libesp_libc.a:assert.* *libesp_libc.a:heap.* *libesp_libc.a:stdatomic.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_ringbuf.a:ringbuf.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_rom.a:esp_rom_systimer.* *libesp_system.a:esp_err.* *libesp_system.a:esp_system_chip.* *libesp_system.a:freertos_hooks.* *libesp_system.a:image_process.* *libesp_system.a:panic.* *libesp_system.a:reset_reason.* *libesp_system.a:system_internal.* *libesp_system.a:system_time.* *libesp_system.a:ubsan.* *libfreertos.a:event_groups.* *libfreertos.a:list.* *libfreertos.a:port.* *libfreertos.a:port_systick.* *libfreertos.a:portasm.* *libfreertos.a:queue.* *libfreertos.a:stream_buffer.* *libfreertos.a:tasks.* *libfreertos.a:timers.* *libgcc.a:_divsf3.* *libgcc.a:lib2funcs.* *libhal.a:cache_hal.* *libhal.a:mmu_hal.* *libhal.a:systimer_hal.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp.* *liblog.a:log_timestamp_common.* *liblog.a:log_write.* *liblog.a:tag_log_level.* *liblog.a:util.* *libmain.a:ksn_core.* *libmain.a:ksn_runtime.* *libmain.a:ksn_view.* *libmain.a:pocket_kasane.* *libmain.a:solar_sail.* *libquickjs-ng.a:dtoa.* *libquickjs-ng.a:quickjs.* *libsoc.a:lldesc.* *libspi_flash.a:esp_flash_api.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_os_func_noos.* *libspi_flash.a:spi_flash_wrap.*) .literal.* EXCLUDE_FILE(*libgcov.a *librtc.a *libxt_hal.a *libxtensa.a *libclang_rt.builtins.a:_divsf3.* *libesp_driver_dma.a:gdma.* *libesp_driver_dma.a:gdma_link.* *libesp_driver_i2c.a:i2c_master.* *libesp_driver_rmt.a:rmt_encoder.* *libesp_driver_rmt.a:rmt_rx.* *libesp_driver_rmt.a:rmt_tx.* *libesp_event.a:default_event_loop.* *libesp_event.a:esp_event.* *libesp_hal_dma.a:gdma_hal_ahb_v1.* *libesp_hal_dma.a:gdma_hal_top.* *libesp_hal_gpio.a:gpio_hal.* *libesp_hal_gpspi.a:spi_hal_iram.* *libesp_hal_gpspi.a:spi_slave_hal_iram.* *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.* *libesp_hal_mspi.a:spi_flash_hal_gpspi.* *libesp_hal_mspi.a:spi_flash_hal_iram.* *libesp_hal_wdt.a:rom_patch.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_clk_tree.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:periph_ctrl.* *libesp_hw_support.a:regi2c_ctrl.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:rtc_init.* *libesp_hw_support.a:rtc_sleep.* *libesp_hw_support.a:rtc_time.* *libesp_hw_support.a:systimer.* *libesp_libc.a:abort.* *libesp_libc.a:assert.* *libesp_libc.a:heap.* *libesp_libc.a:stdatomic.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_ringbuf.a:ringbuf.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_rom.a:esp_rom_systimer.* *libesp_system.a:esp_err.* *libesp_system.a:esp_system_chip.* *libesp_system.a:freertos_hooks.* *libesp_system.a:image_process.* *libesp_system.a:panic.* *libesp_system.a:reset_reason.* *libesp_system.a:system_internal.* *libesp_system.a:system_time.* *libesp_system.a:ubsan.* *libfreertos.a:event_groups.* *libfreertos.a:list.* *libfreertos.a:port.* *libfreertos.a:port_systick.* *libfreertos.a:portasm.* *libfreertos.a:queue.* *libfreertos.a:stream_buffer.* *libfreertos.a:tasks.* *libfreertos.a:timers.* *libgcc.a:_divsf3.* *libgcc.a:lib2funcs.* *libhal.a:cache_hal.* *libhal.a:mmu_hal.* *libhal.a:systimer_hal.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp.* *liblog.a:log_timestamp_common.* *liblog.a:log_write.* *liblog.a:tag_log_level.* *liblog.a:util.* *libmain.a:ksn_core.* *libmain.a:ksn_runtime.* *libmain.a:ksn_view.* *libmain.a:pocket_kasane.* *libmain.a:solar_sail.* *libquickjs-ng.a:dtoa.* *libquickjs-ng.a:quickjs.* *libsoc.a:lldesc.* *libspi_flash.a:esp_flash_api.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_os_func_noos.* *libspi_flash.a:spi_flash_wrap.*) .text EXCLUDE_FILE(*libgcov.a *librtc.a *libxt_hal.a *libxtensa.a *libclang_rt.builtins.a:_divsf3.* *libesp_driver_dma.a:gdma.* *libesp_driver_dma.a:gdma_link.* *libesp_driver_i2c.a:i2c_master.* *libesp_driver_rmt.a:rmt_encoder.* *libesp_driver_rmt.a:rmt_rx.* *libesp_driver_rmt.a:rmt_tx.* *libesp_event.a:default_event_loop.* *libesp_event.a:esp_event.* *libesp_hal_dma.a:gdma_hal_ahb_v1.* *libesp_hal_dma.a:gdma_hal_top.* *libesp_hal_gpio.a:gpio_hal.* *libesp_hal_gpspi.a:spi_hal_iram.* *libesp_hal_gpspi.a:spi_slave_hal_iram.* *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.* *libesp_hal_mspi.a:spi_flash_hal_gpspi.* *libesp_hal_mspi.a:spi_flash_hal_iram.* *libesp_hal_wdt.a:rom_patch.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_clk_tree.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:periph_ctrl.* *libesp_hw_support.a:regi2c_ctrl.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:rtc_init.* *libesp_hw_support.a:rtc_sleep.* *libesp_hw_support.a:rtc_time.* *libesp_hw_support.a:systimer.* *libesp_libc.a:abort.* *libesp_libc.a:assert.* *libesp_libc.a:heap.* *libesp_libc.a:stdatomic.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_ringbuf.a:ringbuf.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_rom.a:esp_rom_systimer.* *libesp_system.a:esp_err.* *libesp_system.a:esp_system_chip.* *libesp_system.a:freertos_hooks.* *libesp_system.a:image_process.* *libesp_system.a:panic.* *libesp_system.a:reset_reason.* *libesp_system.a:system_internal.* *libesp_system.a:system_time.* *libesp_system.a:ubsan.* *libfreertos.a:event_groups.* *libfreertos.a:list.* *libfreertos.a:port.* *libfreertos.a:port_systick.* *libfreertos.a:portasm.* *libfreertos.a:queue.* *libfreertos.a:stream_buffer.* *libfreertos.a:tasks.* *libfreertos.a:timers.* *libgcc.a:_divsf3.* *libgcc.a:lib2funcs.* *libhal.a:cache_hal.* *libhal.a:mmu_hal.* *libhal.a:systimer_hal.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp.* *liblog.a:log_timestamp_common.* *liblog.a:log_write.* *liblog.a:tag_log_level.* *liblog.a:util.* *libmain.a:ksn_core.* *libmain.a:ksn_runtime.* *libmain.a:ksn_view.* *libmain.a:pocket_kasane.* *libmain.a:solar_sail.* *libquickjs-ng.a:dtoa.* *libquickjs-ng.a:quickjs.* *libsoc.a:lldesc.* *libspi_flash.a:esp_flash_api.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_os_func_noos.* *libspi_flash.a:spi_flash_wrap.*) .text.*)
 *(.wifi0iram .wifi0iram.*)
 *(.wifiextrairam .wifiextrairam.*)
 *(.wifiorslpiram .wifiorslpiram.*)
 *(.wifirxiram .wifirxiram.*)
 *(.wifislpiram .wifislpiram.*)
 *(.wifislprxiram .wifislprxiram.*)
 *libesp_driver_dma.a:gdma.*(.literal.gdma_apply_strategy .literal.gdma_config_transfer .literal.gdma_connect .literal.gdma_del_channel .literal.gdma_del_rx_channel .literal.gdma_del_tx_channel .literal.gdma_disconnect .literal.gdma_get_free_m2m_trig_id_mask .literal.gdma_new_ahb_channel .literal.gdma_register_rx_event_callbacks .literal.gdma_register_tx_event_callbacks .literal.gdma_set_priority .literal.gdma_try_free_group_handle .literal.gdma_try_free_pair_handle .text .text.gdma_apply_strategy .text.gdma_config_transfer .text.gdma_connect .text.gdma_del_channel .text.gdma_del_rx_channel .text.gdma_del_tx_channel .text.gdma_disconnect .text.gdma_get_alignment_constraints .text.gdma_get_free_m2m_trig_id_mask .text.gdma_get_group_channel_id .text.gdma_new_ahb_channel .text.gdma_register_rx_event_callbacks .text.gdma_register_tx_event_callbacks .text.gdma_set_priority .text.gdma_try_free_group_handle .text.gdma_try_free_pair_handle)
 *libesp_driver_dma.a:gdma_link.*(.literal.gdma_del_link_list .literal.gdma_new_link_list .text .text.gdma_del_link_list .text.gdma_link_get_owner .text.gdma_new_link_list)
 *libesp_driver_i2c.a:i2c_master.*(.literal.i2c_del_master_bus .literal.i2c_master_bus_add_device .literal.i2c_master_bus_destroy .literal.i2c_master_bus_reset .literal.i2c_master_bus_rm_device .literal.i2c_master_bus_wait_all_done .literal.i2c_master_device_change_address .literal.i2c_master_execute_defined_operations .literal.i2c_master_get_bus_handle .literal.i2c_master_multi_buffer_transmit .literal.i2c_master_probe .literal.i2c_master_receive .literal.i2c_master_register_event_callbacks .literal.i2c_master_transmit .literal.i2c_master_transmit_receive .literal.i2c_new_master_bus .literal.s_i2c_asynchronous_transaction .literal.s_i2c_hw_fsm_reset$isra$0 .literal.s_i2c_read_command .literal.s_i2c_send_command_async .literal.s_i2c_send_commands .literal.s_i2c_start_end_command .literal.s_i2c_synchronous_transaction .literal.s_i2c_transaction_start .literal.s_i2c_write_command .text .text.i2c_del_master_bus .text.i2c_master_bus_add_device .text.i2c_master_bus_destroy .text.i2c_master_bus_reset .text.i2c_master_bus_rm_device .text.i2c_master_bus_wait_all_done .text.i2c_master_device_change_address .text.i2c_master_execute_defined_operations .text.i2c_master_get_bus_handle .text.i2c_master_multi_buffer_transmit .text.i2c_master_probe .text.i2c_master_receive .text.i2c_master_register_event_callbacks .text.i2c_master_transmit .text.i2c_master_transmit_receive .text.i2c_new_master_bus .text.s_i2c_asynchronous_transaction .text.s_i2c_hw_fsm_reset$isra$0 .text.s_i2c_read_command .text.s_i2c_send_command_async .text.s_i2c_send_commands .text.s_i2c_start_end_command .text.s_i2c_synchronous_transaction .text.s_i2c_transaction_start .text.s_i2c_write_command)
 *libesp_driver_rmt.a:rmt_encoder.*(.literal.rmt_alloc_encoder_mem .literal.rmt_del_encoder .text .text.rmt_alloc_encoder_mem .text.rmt_del_encoder)
 *libesp_driver_rmt.a:rmt_rx.*(.literal.rmt_del_rx_channel .literal.rmt_ll_rx_enable_dma$part$0 .literal.rmt_new_rx_channel .literal.rmt_receive .literal.rmt_rx_demodulate_carrier .literal.rmt_rx_destroy .literal.rmt_rx_disable .literal.rmt_rx_enable .literal.rmt_rx_register_event_callbacks .text .text.rmt_del_rx_channel .text.rmt_ll_rx_enable_dma$part$0 .text.rmt_new_rx_channel .text.rmt_receive .text.rmt_rx_demodulate_carrier .text.rmt_rx_destroy .text.rmt_rx_disable .text.rmt_rx_enable .text.rmt_rx_register_event_callbacks)
 *libesp_driver_rmt.a:rmt_tx.*(.literal.rmt_del_sync_manager .literal.rmt_del_tx_channel .literal.rmt_ll_tx_enable_dma$part$0 .literal.rmt_new_sync_manager .literal.rmt_new_tx_channel .literal.rmt_sync_reset .literal.rmt_transmit .literal.rmt_tx_destroy .literal.rmt_tx_disable .literal.rmt_tx_enable .literal.rmt_tx_modulate_carrier .literal.rmt_tx_register_event_callbacks .literal.rmt_tx_switch_gpio .literal.rmt_tx_wait_all_done .text .text.rmt_del_sync_manager .text.rmt_del_tx_channel .text.rmt_ll_tx_enable_dma$part$0 .text.rmt_new_sync_manager .text.rmt_new_tx_channel .text.rmt_sync_reset .text.rmt_transmit .text.rmt_tx_destroy .text.rmt_tx_disable .text.rmt_tx_enable .text.rmt_tx_modulate_carrier .text.rmt_tx_register_event_callbacks .text.rmt_tx_switch_gpio .text.rmt_tx_wait_all_done)
 *libesp_event.a:default_event_loop.*(.literal.esp_event_handler_instance_register .literal.esp_event_handler_instance_unregister .literal.esp_event_handler_register .literal.esp_event_handler_unregister .literal.esp_event_loop_create_default .literal.esp_event_loop_delete_default .literal.esp_event_post .text .text.esp_event_handler_instance_register .text.esp_event_handler_instance_unregister .text.esp_event_handler_register .text.esp_event_handler_unregister .text.esp_event_loop_create_default .text.esp_event_loop_delete_default .text.esp_event_post)
 *libesp_event.a:esp_event.*(.literal.base_node_add_handler .literal.esp_event_handler_instance_register_with .literal.esp_event_handler_instance_unregister_with .literal.esp_event_handler_register_with .literal.esp_event_handler_register_with_internal .literal.esp_event_handler_unregister_with .literal.esp_event_handler_unregister_with_internal .literal.esp_event_loop_create .literal.esp_event_loop_delete .literal.esp_event_loop_run .literal.esp_event_loop_run_task .literal.esp_event_post_to .literal.handler_instances_add .literal.handler_instances_remove .literal.handler_instances_remove_all .literal.loop_node_add_handler .literal.loop_remove_handler .text .text.base_node_add_handler .text.esp_event_dump .text.esp_event_handler_instance_register_with .text.esp_event_handler_instance_unregister_with .text.esp_event_handler_register_with .text.esp_event_handler_register_with_internal .text.esp_event_handler_unregister_with .text.esp_event_handler_unregister_with_internal .text.esp_event_loop_create .text.esp_event_loop_delete .text.esp_event_loop_run .text.esp_event_loop_run_task .text.esp_event_post_to .text.handler_instances_add .text.handler_instances_remove .text.handler_instances_remove_all .text.loop_node_add_handler .text.loop_remove_handler)
 *libesp_hal_dma.a:gdma_hal_ahb_v1.*(.literal.gdma_ahb_hal_init .literal.gdma_ahb_hal_set_burst_size .text .text.gdma_ahb_hal_connect_mem .text.gdma_ahb_hal_connect_peri .text.gdma_ahb_hal_disconnect_all .text.gdma_ahb_hal_enable_burst .text.gdma_ahb_hal_enable_intr .text.gdma_ahb_hal_get_intr_status_reg .text.gdma_ahb_hal_init .text.gdma_ahb_hal_set_burst_size .text.gdma_ahb_hal_set_priority .text.gdma_ahb_hal_set_strategy)
 *libesp_hal_dma.a:gdma_hal_top.*(.text .text.gdma_hal_connect_mem .text.gdma_hal_connect_peri .text.gdma_hal_deinit .text.gdma_hal_disconnect_all .text.gdma_hal_enable_burst .text.gdma_hal_enable_intr .text.gdma_hal_get_intr_status_reg .text.gdma_hal_set_burst_size .text.gdma_hal_set_priority .text.gdma_hal_set_strategy)
 *libesp_hal_gpio.a:gpio_hal.*(.literal.gpio_hal_intr_disable .literal.gpio_hal_intr_enable_on_core .literal.gpio_hal_iomux_in .literal.gpio_hal_iomux_out .literal.gpio_hal_matrix_in .literal.gpio_hal_matrix_out .text .text.gpio_hal_intr_disable .text.gpio_hal_intr_enable_on_core .text.gpio_hal_iomux_in .text.gpio_hal_iomux_out .text.gpio_hal_matrix_in .text.gpio_hal_matrix_out)
 *libesp_hw_support.a:cpu.*(.text .text.esp_cpu_clear_breakpoint .text.esp_cpu_clear_watchpoint .text.esp_cpu_set_breakpoint .text.esp_cpu_set_watchpoint)
 *libesp_hw_support.a:esp_clk_tree.*(.literal.esp_clk_tree_src_get_freq_hz .text .text.esp_clk_tree_initialize .text.esp_clk_tree_src_get_freq_hz)
 *libesp_hw_support.a:periph_ctrl.*(.literal.periph_ll_disable_clk_set_rst .literal.periph_ll_enable_clk_clear_rst .literal.periph_ll_get_clk_en_mask .literal.periph_ll_wifi_module_enable_clk_clear_rst .literal.periph_module_disable .literal.periph_module_enable .text .text.periph_ll_disable_clk_set_rst .text.periph_ll_enable_clk_clear_rst .text.periph_ll_get_clk_en_mask .text.periph_ll_get_rst_en_mask$isra$0 .text.periph_ll_wifi_module_enable_clk_clear_rst .text.periph_module_disable .text.periph_module_enable)
 *libesp_hw_support.a:regi2c_ctrl.*(.literal.regi2c_saradc_disable .literal.regi2c_saradc_enable .text .text.regi2c_saradc_disable .text.regi2c_saradc_enable)
 *libesp_hw_support.a:rtc_init.*(.literal.get_rtc_dbias_by_efuse$constprop$0 .literal.rtc_init .text .text.get_rtc_dbias_by_efuse$constprop$0 .text.rtc_init)
 *libesp_hw_support.a:rtc_sleep.*(.literal.rtc_sleep_get_default_config .literal.rtc_sleep_init .literal.rtc_sleep_low_init .text .text.rtc_sleep_get_default_config .text.rtc_sleep_init .text.rtc_sleep_low_init)
 *libesp_ringbuf.a:ringbuf.*(.literal.prvInitializeNewRingbuffer .literal.prvReceiveGeneric .literal.prvSendAcquireGeneric .literal.vRingbufferDelete .literal.vRingbufferDeleteWithCaps .literal.vRingbufferGetInfo .literal.vRingbufferReset .literal.vRingbufferReturnItem .literal.xRingbufferAddToQueueSetRead .literal.xRingbufferCreate .literal.xRingbufferCreateNoSplit .literal.xRingbufferCreateStatic .literal.xRingbufferCreateWithCaps .literal.xRingbufferGetCurFreeSize .literal.xRingbufferGetMaxItemSize .literal.xRingbufferGetStaticBuffer .literal.xRingbufferPrintInfo .literal.xRingbufferReceive .literal.xRingbufferReceiveSplit .literal.xRingbufferReceiveUpTo .literal.xRingbufferRemoveFromQueueSetRead .literal.xRingbufferSend .literal.xRingbufferSendAcquire .literal.xRingbufferSendComplete .text .text.prvGetCurMaxSizeAllowSplit .text.prvGetCurMaxSizeByteBuf .text.prvGetCurMaxSizeNoSplit .text.prvInitializeNewRingbuffer .text.prvReceiveGeneric .text.prvSendAcquireGeneric .text.vRingbufferDelete .text.vRingbufferDeleteWithCaps .text.vRingbufferGetInfo .text.vRingbufferReset .text.vRingbufferReturnItem .text.xRingbufferAddToQueueSetRead .text.xRingbufferCreate .text.xRingbufferCreateNoSplit .text.xRingbufferCreateStatic .text.xRingbufferCreateWithCaps .text.xRingbufferGetCurFreeSize .text.xRingbufferGetMaxItemSize .text.xRingbufferGetStaticBuffer .text.xRingbufferPrintInfo .text.xRingbufferReceive .text.xRingbufferReceiveSplit .text.xRingbufferReceiveUpTo .text.xRingbufferRemoveFromQueueSetRead .text.xRingbufferSend .text.xRingbufferSendAcquire .text.xRingbufferSendComplete)
 *libesp_system.a:esp_system_chip.*(.literal.esp_get_free_heap_size .literal.esp_get_free_internal_heap_size .literal.esp_get_idf_version .literal.esp_get_minimum_free_heap_size .text .text.esp_get_free_heap_size .text.esp_get_free_internal_heap_size .text.esp_get_idf_version .text.esp_get_minimum_free_heap_size)
 *libesp_system.a:freertos_hooks.*(.literal.esp_deregister_freertos_idle_hook .literal.esp_deregister_freertos_idle_hook_for_cpu .literal.esp_deregister_freertos_tick_hook .literal.esp_deregister_freertos_tick_hook_for_cpu .literal.esp_register_freertos_idle_hook .literal.esp_register_freertos_idle_hook_for_cpu .literal.esp_register_freertos_tick_hook .literal.esp_register_freertos_tick_hook_for_cpu .text .text.esp_deregister_freertos_idle_hook .text.esp_deregister_freertos_idle_hook_for_cpu .text.esp_deregister_freertos_tick_hook .text.esp_deregister_freertos_tick_hook_for_cpu .text.esp_register_freertos_idle_hook .text.esp_register_freertos_idle_hook_for_cpu .text.esp_register_freertos_tick_hook .text.esp_register_freertos_tick_hook_for_cpu)
 *libesp_system.a:panic.*(.literal.esp_panic_handler .literal.esp_panic_handler_disable_timg_wdts .literal.esp_panic_handler_enable_rtc_wdt .literal.esp_panic_handler_feed_wdts .literal.esp_panic_handler_increment_entry_count .literal.panic_print_char .literal.panic_print_char_usb_serial_jtag .literal.panic_print_dec .literal.panic_print_hex .literal.panic_print_str .literal.print_abort_details .text .text.esp_panic_handler .text.esp_panic_handler_disable_timg_wdts .text.esp_panic_handler_enable_rtc_wdt .text.esp_panic_handler_feed_wdts .text.esp_panic_handler_increment_entry_count .text.esp_reset_reason_get_hint .text.esp_reset_reason_set_hint .text.panic_print_char .text.panic_print_char_usb_serial_jtag .text.panic_print_dec .text.panic_print_hex .text.panic_print_str .text.print_abort_details)
 *libesp_system.a:reset_reason.*(.literal.esp_reset_reason .literal.esp_reset_reason_get_hint .literal.startup.esp_reset_reason_init .text .text.esp_reset_reason .text.esp_reset_reason_get_hint .text.startup.esp_reset_reason_init)
 *libesp_system.a:system_internal.*(.text)
 *libesp_system.a:system_time.*(.text)
 *libfreertos.a:event_groups.*(.literal.vEventGroupClearBitsCallback .literal.vEventGroupDelete .literal.vEventGroupSetBitsCallback .literal.xEventGroupClearBits .literal.xEventGroupCreate .literal.xEventGroupCreateStatic .literal.xEventGroupGetStaticBuffer .literal.xEventGroupSetBits .literal.xEventGroupSync .literal.xEventGroupWaitBits .text .text.vEventGroupClearBitsCallback .text.vEventGroupDelete .text.vEventGroupSetBitsCallback .text.xEventGroupClearBits .text.xEventGroupCreate .text.xEventGroupCreateStatic .text.xEventGroupGetStaticBuffer .text.xEventGroupSetBits .text.xEventGroupSync .text.xEventGroupWaitBits)
 *libfreertos.a:list.*(.text .text.vListInitialise .text.vListInitialiseItem .text.vListInsert)
 *libfreertos.a:port.*(.literal.pxPortInitialiseStack .literal.unlikely.vPortEndScheduler .literal.vApplicationStackOverflowHook .literal.vPortExitCriticalCompliance .literal.vPortTCBPreDeleteHook .literal.xPortEnterCriticalTimeoutCompliance .text .text.pxPortInitialiseStack .text.unlikely.vPortEndScheduler .text.vApplicationStackOverflowHook .text.vPortExitCriticalCompliance .text.vPortTCBPreDeleteHook .text.xPortEnterCriticalTimeoutCompliance .text.xPortGetTickRateHz)
 *libfreertos.a:queue.*(.literal.uxQueueMessagesWaiting .literal.uxQueueSpacesAvailable .literal.vQueueDelete .literal.vQueueWaitForMessageRestricted .literal.xQueueAddToSet .literal.xQueueCreateCountingSemaphore .literal.xQueueCreateCountingSemaphoreStatic .literal.xQueueCreateMutex .literal.xQueueCreateMutexStatic .literal.xQueueCreateSet .literal.xQueueGenericCreate .literal.xQueueGenericCreateStatic .literal.xQueueGenericGetStaticBuffers .literal.xQueueGenericReset .literal.xQueueGenericSend .literal.xQueueGetMutexHolder .literal.xQueueGiveMutexRecursive .literal.xQueuePeek .literal.xQueueReceive .literal.xQueueRemoveFromSet .literal.xQueueSelectFromSet .literal.xQueueSemaphoreTake .literal.xQueueTakeMutexRecursive .text .text.uxQueueMessagesWaiting .text.uxQueueSpacesAvailable .text.vQueueDelete .text.vQueueWaitForMessageRestricted .text.xQueueAddToSet .text.xQueueCreateCountingSemaphore .text.xQueueCreateCountingSemaphoreStatic .text.xQueueCreateMutex .text.xQueueCreateMutexStatic .text.xQueueCreateSet .text.xQueueGenericCreate .text.xQueueGenericCreateStatic .text.xQueueGenericGetStaticBuffers .text.xQueueGenericReset .text.xQueueGenericSend .text.xQueueGetMutexHolder .text.xQueueGiveMutexRecursive .text.xQueuePeek .text.xQueueReceive .text.xQueueRemoveFromSet .text.xQueueSelectFromSet .text.xQueueSemaphoreTake .text.xQueueTakeMutexRecursive)
 *libfreertos.a:stream_buffer.*(.literal.prvInitialiseNewStreamBuffer$isra$0 .literal.prvReadBytesFromBuffer .literal.prvWriteBytesToBuffer .literal.vStreamBufferDelete .literal.xStreamBufferBytesAvailable .literal.xStreamBufferGenericCreate .literal.xStreamBufferGenericCreateStatic .literal.xStreamBufferGetStaticBuffers .literal.xStreamBufferIsEmpty .literal.xStreamBufferIsFull .literal.xStreamBufferNextMessageLengthBytes .literal.xStreamBufferReceive .literal.xStreamBufferReset .literal.xStreamBufferSend .literal.xStreamBufferSetTriggerLevel .literal.xStreamBufferSpacesAvailable .text .text.prvInitialiseNewStreamBuffer$isra$0 .text.prvReadBytesFromBuffer .text.prvWriteBytesToBuffer .text.vStreamBufferDelete .text.xStreamBufferBytesAvailable .text.xStreamBufferGenericCreate .text.xStreamBufferGenericCreateStatic .text.xStreamBufferGetStaticBuffers .text.xStreamBufferIsEmpty .text.xStreamBufferIsFull .text.xStreamBufferNextMessageLengthBytes .text.xStreamBufferReceive .text.xStreamBufferReset .text.xStreamBufferSend .text.xStreamBufferSetTriggerLevel .text.xStreamBufferSpacesAvailable)
 *libfreertos.a:tasks.*(.literal.eTaskGetState .literal.pcTaskGetName .literal.prvAddCurrentTaskToDelayedList .literal.prvAddNewTaskToReadyList .literal.prvDeleteTCB .literal.prvInitialiseNewTask$constprop$0 .literal.prvReleaseKernelLock .literal.prvSearchForNameWithinSingleList .literal.prvTakeKernelLock .literal.prvTaskPriorityRaise .literal.prvTaskPriorityRestore .literal.pvTaskGetCurrentTCBForCore .literal.pvTaskGetThreadLocalStoragePointer .literal.pvTaskIncrementMutexHeldCount .literal.pxTaskGetStackStart .literal.ulTaskGenericNotifyTake .literal.ulTaskGenericNotifyValueClear .literal.uxTaskGetNumberOfTasks .literal.uxTaskGetSnapshotAll .literal.uxTaskGetStackHighWaterMark .literal.uxTaskGetStackHighWaterMark2 .literal.uxTaskPriorityGet .literal.uxTaskResetEventItemValue .literal.vTaskDelay .literal.vTaskDelete .literal.vTaskEndScheduler .literal.vTaskInternalSetTimeOutState .literal.vTaskMissedYield .literal.vTaskPlaceOnEventList .literal.vTaskPlaceOnEventListRestricted .literal.vTaskPlaceOnUnorderedEventList .literal.vTaskPriorityDisinheritAfterTimeout .literal.vTaskPrioritySet .literal.vTaskRemoveFromUnorderedEventList .literal.vTaskResume .literal.vTaskSetThreadLocalStoragePointer .literal.vTaskSetThreadLocalStoragePointerAndDelCallback .literal.vTaskSetTimeOutState .literal.vTaskStartScheduler .literal.vTaskSuspend .literal.vTaskSuspendAll .literal.xTaskAbortDelay .literal.xTaskCatchUpTicks .literal.xTaskCheckForTimeOut .literal.xTaskCreatePinnedToCore .literal.xTaskCreateStaticPinnedToCore .literal.xTaskDelayUntil .literal.xTaskGenericNotify .literal.xTaskGenericNotifyStateClear .literal.xTaskGenericNotifyWait .literal.xTaskGetCoreID .literal.xTaskGetCurrentTaskHandle .literal.xTaskGetCurrentTaskHandleForCore .literal.xTaskGetHandle .literal.xTaskGetIdleTaskHandle .literal.xTaskGetIdleTaskHandleForCore .literal.xTaskGetNext .literal.xTaskGetStackStart .literal.xTaskGetStaticBuffers .literal.xTaskPriorityDisinherit .literal.xTaskPriorityInherit .literal.xTaskResumeAll .text .text.eTaskGetState .text.pcTaskGetName .text.prvAddCurrentTaskToDelayedList .text.prvAddNewTaskToReadyList .text.prvDeleteTCB .text.prvInitialiseNewTask$constprop$0 .text.prvReleaseKernelLock .text.prvSearchForNameWithinSingleList .text.prvTakeKernelLock .text.prvTaskPriorityRaise .text.prvTaskPriorityRestore .text.pvTaskGetCurrentTCBForCore .text.pvTaskGetThreadLocalStoragePointer .text.pvTaskIncrementMutexHeldCount .text.pxTaskGetStackStart .text.ulTaskGenericNotifyTake .text.ulTaskGenericNotifyValueClear .text.uxTaskGetNumberOfTasks .text.uxTaskGetSnapshotAll .text.uxTaskGetStackHighWaterMark .text.uxTaskGetStackHighWaterMark2 .text.uxTaskPriorityGet .text.uxTaskResetEventItemValue .text.vTaskDelay .text.vTaskDelete .text.vTaskEndScheduler .text.vTaskInternalSetTimeOutState .text.vTaskMissedYield .text.vTaskPlaceOnEventList .text.vTaskPlaceOnEventListRestricted .text.vTaskPlaceOnUnorderedEventList .text.vTaskPriorityDisinheritAfterTimeout .text.vTaskPrioritySet .text.vTaskRemoveFromUnorderedEventList .text.vTaskResume .text.vTaskSetThreadLocalStoragePointer .text.vTaskSetThreadLocalStoragePointerAndDelCallback .text.vTaskSetTimeOutState .text.vTaskStartScheduler .text.vTaskSuspend .text.vTaskSuspendAll .text.xTaskAbortDelay .text.xTaskCatchUpTicks .text.xTaskCheckForTimeOut .text.xTaskCreatePinnedToCore .text.xTaskCreateStaticPinnedToCore .text.xTaskDelayUntil .text.xTaskGenericNotify .text.xTaskGenericNotifyStateClear .text.xTaskGenericNotifyWait .text.xTaskGetCoreID .text.xTaskGetCurrentTaskHandle .text.xTaskGetCurrentTaskHandleForCore .text.xTaskGetHandle .text.xTaskGetIdleTaskHandle .text.xTaskGetIdleTaskHandleForCore .text.xTaskGetNext .text.xTaskGetStackStart .text.xTaskGetStaticBuffers .text.xTaskPriorityDisinherit .text.xTaskPriorityInherit .text.xTaskResumeAll .text.xTimerCreateTimerTask)
 *libfreertos.a:timers.*(.literal.pcTimerGetName .literal.prvCheckForValidListAndQueue .literal.prvInitialiseNewTimer$part$0 .literal.prvInsertTimerInActiveList .literal.prvProcessExpiredTimer .literal.prvReloadTimer .literal.prvSwitchTimerLists .literal.prvTimerTask .literal.pvTimerGetTimerID .literal.uxTimerGetReloadMode .literal.vTimerSetReloadMode .literal.vTimerSetTimerID .literal.xTimerCreate .literal.xTimerCreateStatic .literal.xTimerCreateTimerTask .literal.xTimerGetExpiryTime .literal.xTimerGetPeriod .literal.xTimerGetReloadMode .literal.xTimerGetStaticBuffer .literal.xTimerGetTimerDaemonTaskHandle .literal.xTimerIsTimerActive .literal.xTimerPendFunctionCall .text .text.pcTimerGetName .text.prvCheckForValidListAndQueue .text.prvInitialiseNewTimer$part$0 .text.prvInsertTimerInActiveList .text.prvProcessExpiredTimer .text.prvReloadTimer .text.prvSwitchTimerLists .text.prvTimerTask .text.pvTimerGetTimerID .text.uxTimerGetReloadMode .text.vTimerSetReloadMode .text.vTimerSetTimerID .text.xTimerCreate .text.xTimerCreateStatic .text.xTimerCreateTimerTask .text.xTimerGetExpiryTime .text.xTimerGetPeriod .text.xTimerGetReloadMode .text.xTimerGetStaticBuffer .text.xTimerGetTimerDaemonTaskHandle .text.xTimerIsTimerActive .text.xTimerPendFunctionCall)
 *libheap.a:multi_heap.*(.literal.multi_heap_check .literal.multi_heap_dump .literal.multi_heap_dump_tlsf .literal.multi_heap_find_containing_block_impl .literal.multi_heap_get_info_impl .literal.multi_heap_register_impl .literal.multi_heap_reset_minimum_free_bytes .literal.multi_heap_restore_minimum_free_bytes .literal.multi_heap_walk .text .text.multi_heap_check .text.multi_heap_dump .text.multi_heap_dump_tlsf .text.multi_heap_find_containing_block_impl .text.multi_heap_free_size_impl .text.multi_heap_get_info_impl .text.multi_heap_get_info_tlsf .text.multi_heap_minimum_free_size_impl .text.multi_heap_register_impl .text.multi_heap_reset_minimum_free_bytes .text.multi_heap_restore_minimum_free_bytes .text.multi_heap_walk)
 *libheap.a:tlsf.*(.literal.default_walker .literal.integrity_walker .literal.tlsf_add_pool .literal.tlsf_check .literal.tlsf_check_pool .literal.tlsf_create .literal.tlsf_create_with_pool .literal.tlsf_malloc_addr .literal.tlsf_remove_pool .literal.tlsf_walk_pool .text .text.default_walker .text.integrity_walker .text.tlsf_add_pool .text.tlsf_check .text.tlsf_check_pool .text.tlsf_create .text.tlsf_create_with_pool .text.tlsf_destroy .text.tlsf_find_containing_block .text.tlsf_fit_size .text.tlsf_malloc_addr .text.tlsf_pool_overhead .text.tlsf_remove_pool .text.tlsf_walk_pool)
 *liblog.a:log_timestamp.*(.text)
 *liblog.a:log_write.*(.literal.esp_log_set_vprintf .text .text.esp_log_set_vprintf)
 *liblog.a:tag_log_level.*(.literal.esp_log_level_get .literal.esp_log_level_set .literal.log_level_get .text .text.esp_log_level_get .text.esp_log_level_set .text.log_level_get)
 *libmain.a:ksn_core.*(.literal.command_box .literal.copy_patch_text_layer .literal.core_add .literal.core_animate .literal.core_begin .literal.core_change .literal.core_end .literal.core_limits .literal.core_stats .literal.core_stop .literal.damage_add .literal.damage_widen .literal.find_track_index .literal.invalidate_rect_damage .literal.ksn_core_active_usage .literal.ksn_core_advance_animations .literal.ksn_core_animation_deadline .literal.ksn_core_bind .literal.ksn_core_check_draw .literal.ksn_core_damage .literal.ksn_core_enable_animation .literal.ksn_core_finish_animation .literal.ksn_core_frame .literal.ksn_core_group .literal.ksn_core_image_opaque .literal.ksn_core_image_port .literal.ksn_core_image_reader .literal.ksn_core_image_span .literal.ksn_core_init .literal.ksn_core_invalidate .literal.ksn_core_invalidate_image .literal.ksn_core_invalidate_image_source_damage .literal.ksn_core_invalidate_image_source_rect .literal.ksn_core_invalidate_rect .literal.ksn_core_opaque_system_bands .literal.ksn_core_poll_animation .literal.ksn_core_prepare_frame .literal.ksn_core_read .literal.ksn_core_read_active_ref .literal.ksn_core_read_borrowed .literal.ksn_core_register_image .literal.ksn_core_reset_layer .literal.ksn_core_submission_usage .literal.private_track .literal.read_command .literal.sample_tracks .literal.track_usage .literal.validate_draw .literal.validate_image_window .text .text.command_box .text.copy_patch_text_layer .text.core_abort .text.core_add .text.core_animate .text.core_background .text.core_begin .text.core_change .text.core_end .text.core_limits .text.core_stats .text.core_stop .text.damage_add .text.damage_widen .text.find_track_index .text.invalidate_rect_damage .text.ksn_core_active_usage .text.ksn_core_advance_animations .text.ksn_core_animation_bytes .text.ksn_core_animation_deadline .text.ksn_core_bind .text.ksn_core_builder_usage .text.ksn_core_check_builder .text.ksn_core_check_draw .text.ksn_core_check_transaction .text.ksn_core_damage .text.ksn_core_defer_repair .text.ksn_core_discard .text.ksn_core_discard_reason .text.ksn_core_enable_animation .text.ksn_core_failed .text.ksn_core_finish_animation .text.ksn_core_frame .text.ksn_core_group .text.ksn_core_has_submission .text.ksn_core_image_opaque .text.ksn_core_image_port .text.ksn_core_image_reader .text.ksn_core_image_span .text.ksn_core_init .text.ksn_core_invalidate .text.ksn_core_invalidate_bands .text.ksn_core_invalidate_image .text.ksn_core_invalidate_image_source_damage .text.ksn_core_invalidate_image_source_rect .text.ksn_core_invalidate_rect .text.ksn_core_needs_repair .text.ksn_core_opaque_system_bands .text.ksn_core_poll .text.ksn_core_poll_animation .text.ksn_core_prepare_frame .text.ksn_core_presented .text.ksn_core_read .text.ksn_core_read_active_ref .text.ksn_core_read_borrowed .text.ksn_core_refs_active .text.ksn_core_register_image .text.ksn_core_reset_layer .text.ksn_core_set_animation_time .text.ksn_core_start_animations .text.ksn_core_submission_usage .text.private_track .text.privatize_text_layer .text.read_command .text.run_width .text.sample_tracks .text.track_usage .text.utf8_next .text.validate_draw .text.validate_image_window)
 *libmain.a:ksn_runtime.*(.literal.destroy .literal.ensure .literal.ksn_runtime_advance_animations .literal.ksn_runtime_animate .literal.ksn_runtime_animation_deadline .literal.ksn_runtime_animation_pending .literal.ksn_runtime_animations_presented .literal.ksn_runtime_app_activate .literal.ksn_runtime_app_attach .literal.ksn_runtime_app_attach_tail .literal.ksn_runtime_app_detach .literal.ksn_runtime_app_end_turn .literal.ksn_runtime_app_system_view .literal.ksn_runtime_cache_bytes .literal.ksn_runtime_cache_create .literal.ksn_runtime_has_submission .literal.ksn_runtime_input_scope .literal.ksn_runtime_invalidate .literal.ksn_runtime_invalidate_bands .literal.ksn_runtime_invalidate_image .literal.ksn_runtime_invalidate_image_source_damage .literal.ksn_runtime_invalidate_image_source_rect .literal.ksn_runtime_needs_present .literal.ksn_runtime_opaque_system_bands .literal.ksn_runtime_present .literal.ksn_runtime_present_backdrop .literal.ksn_runtime_present_complete .literal.ksn_runtime_reserved_bytes .literal.ksn_runtime_set_animation_time .literal.ksn_runtime_set_hidden .literal.ksn_runtime_set_reduce_motion .literal.ksn_runtime_shutdown .literal.ksn_runtime_stats .literal.ksn_runtime_system_acquire .literal.release_tail .text .text.destroy .text.ensure .text.ksn_runtime_advance_animations .text.ksn_runtime_animate .text.ksn_runtime_animation_deadline .text.ksn_runtime_animation_pending .text.ksn_runtime_animations_presented .text.ksn_runtime_app_activate .text.ksn_runtime_app_attach .text.ksn_runtime_app_attach_tail .text.ksn_runtime_app_detach .text.ksn_runtime_app_end_turn .text.ksn_runtime_app_system_view .text.ksn_runtime_cache_bytes .text.ksn_runtime_cache_create .text.ksn_runtime_has_submission .text.ksn_runtime_input_scope .text.ksn_runtime_invalidate .text.ksn_runtime_invalidate_bands .text.ksn_runtime_invalidate_image .text.ksn_runtime_invalidate_image_source_damage .text.ksn_runtime_invalidate_image_source_rect .text.ksn_runtime_needs_present .text.ksn_runtime_opaque_system_bands .text.ksn_runtime_present .text.ksn_runtime_present_backdrop .text.ksn_runtime_present_complete .text.ksn_runtime_reserved_bytes .text.ksn_runtime_set_animation_time .text.ksn_runtime_set_hidden .text.ksn_runtime_set_reduce_motion .text.ksn_runtime_shutdown .text.ksn_runtime_stats .text.ksn_runtime_system_acquire .text.release_tail)
 *libmain.a:ksn_view.*(.literal.abort_builder .literal.idle$isra$0 .literal.ksn_view_add .literal.ksn_view_animate .literal.ksn_view_background .literal.ksn_view_begin .literal.ksn_view_cache_create .literal.ksn_view_cache_release .literal.ksn_view_cancel .literal.ksn_view_check_draw .literal.ksn_view_features .literal.ksn_view_get_stats .literal.ksn_view_group .literal.ksn_view_host_advance_animations .literal.ksn_view_host_attach_cache .literal.ksn_view_host_end_turn .literal.ksn_view_host_focus .literal.ksn_view_host_image_port .literal.ksn_view_host_init .literal.ksn_view_host_invalidate .literal.ksn_view_host_invalidate_bands .literal.ksn_view_host_invalidate_image .literal.ksn_view_host_invalidate_image_source_damage .literal.ksn_view_host_invalidate_image_source_rect .literal.ksn_view_host_needs_present .literal.ksn_view_host_present .literal.ksn_view_host_present_backdrop .literal.ksn_view_host_present_complete .literal.ksn_view_host_register_image .literal.ksn_view_host_reset_app .literal.ksn_view_host_route .literal.ksn_view_instantiate .literal.ksn_view_modal_close .literal.ksn_view_modal_open .literal.ksn_view_place .literal.ksn_view_poll .literal.ksn_view_poll_animation .literal.ksn_view_read_ref .literal.ksn_view_stop_animation .literal.ksn_view_submit .literal.ksn_view_visible .literal.mutation .literal.resolve .text .text.abort_builder .text.idle$isra$0 .text.instance_owned .text.ksn_view_add .text.ksn_view_animate .text.ksn_view_background .text.ksn_view_begin .text.ksn_view_cache_create .text.ksn_view_cache_release .text.ksn_view_cancel .text.ksn_view_check_draw .text.ksn_view_features .text.ksn_view_get_stats .text.ksn_view_group .text.ksn_view_host_advance_animations .text.ksn_view_host_attach_cache .text.ksn_view_host_end_turn .text.ksn_view_host_focus .text.ksn_view_host_image_port .text.ksn_view_host_init .text.ksn_view_host_invalidate .text.ksn_view_host_invalidate_bands .text.ksn_view_host_invalidate_image .text.ksn_view_host_invalidate_image_source_damage .text.ksn_view_host_invalidate_image_source_rect .text.ksn_view_host_needs_present .text.ksn_view_host_present .text.ksn_view_host_present_backdrop .text.ksn_view_host_present_complete .text.ksn_view_host_register_image .text.ksn_view_host_reset_app .text.ksn_view_host_route .text.ksn_view_instantiate .text.ksn_view_modal_close .text.ksn_view_modal_open .text.ksn_view_place .text.ksn_view_poll .text.ksn_view_poll_animation .text.ksn_view_read_ref .text.ksn_view_stop_animation .text.ksn_view_submit .text.ksn_view_visible .text.mutation .text.resolve .text.template_owned)
 *libmain.a:pocket_kasane.*(.literal.animation_stop .literal.apply_outcome .literal.bounded_cstring .literal.build_kasane .literal.change_ref .literal.discard_candidates .literal.ensure_state .literal.expose_ref .literal.js_animation_finish .literal.js_animation_finish_checked .literal.js_animation_poll .literal.js_animation_stop .literal.js_animation_stop_checked .literal.js_cache_create .literal.js_cache_release .literal.js_cancel .literal.js_create_scene .literal.js_features .literal.js_input_scope .literal.js_instance_place .literal.js_instance_place_checked .literal.js_instance_visible .literal.js_instance_visible_checked .literal.js_modal_close .literal.js_modal_close_checked .literal.js_modal_open .literal.js_modal_open_checked .literal.js_patch .literal.js_poll .literal.js_presenter_mount .literal.js_ref_animate .literal.js_ref_animate_checked .literal.js_ref_clip .literal.js_ref_clip_checked .literal.js_ref_color .literal.js_ref_color_checked .literal.js_ref_image .literal.js_ref_image_checked .literal.js_ref_rect .literal.js_ref_rect_checked .literal.js_ref_reveal .literal.js_ref_reveal_checked .literal.js_ref_rotation .literal.js_ref_rotation_checked .literal.js_ref_text .literal.js_ref_text_checked .literal.js_ref_visible .literal.js_ref_visible_checked .literal.js_replace .literal.js_resource .literal.js_schema_bind_method .literal.js_schema_mount .literal.js_schema_set .literal.js_schema_set_method .literal.js_schema_unbind_method .literal.js_stats .literal.js_tx_background .literal.js_tx_background_checked .literal.js_tx_gradient .literal.js_tx_gradient_checked .literal.js_tx_group .literal.js_tx_group_checked .literal.js_tx_image .literal.js_tx_image_checked .literal.js_tx_instantiate .literal.js_tx_instantiate_checked .literal.js_tx_primitive .literal.js_tx_rect .literal.js_tx_rect_checked .literal.js_tx_round_rect .literal.js_tx_round_rect_checked .literal.js_tx_stroke_rect .literal.js_tx_stroke_rect_checked .literal.js_tx_text .literal.js_tx_text_checked .literal.lazy_proto .literal.number_in .literal.parse_angle .literal.parse_choice$constprop$0 .literal.parse_draw_base .literal.parse_placement .literal.parse_pose$constprop$0 .literal.parse_u32 .literal.pocket_kasane_active .literal.pocket_kasane_advance .literal.pocket_kasane_animation_pending .literal.pocket_kasane_animations_presented .literal.pocket_kasane_end_turn .literal.pocket_kasane_grid_invalidate .literal.pocket_kasane_grid_resource .literal.pocket_kasane_grid_source_port .literal.pocket_kasane_has_submission .literal.pocket_kasane_input_scope .literal.pocket_kasane_install .literal.pocket_kasane_invalidate .literal.pocket_kasane_invalidate_bands .literal.pocket_kasane_needs_present .literal.pocket_kasane_notice_composited .literal.pocket_kasane_opaque_system_bands .literal.pocket_kasane_park_turn .literal.pocket_kasane_pixel_can_stage .literal.pocket_kasane_pixel_invalidate .literal.pocket_kasane_pixel_resource .literal.pocket_kasane_prepare .literal.pocket_kasane_present .literal.pocket_kasane_present_backdrop .literal.pocket_kasane_present_complete .literal.pocket_kasane_present_complete$part$0 .literal.pocket_kasane_presenter_host_status .literal.pocket_kasane_presenter_settle .literal.pocket_kasane_presenter_step .literal.pocket_kasane_proc_publish .literal.pocket_kasane_proc_publish_at .literal.pocket_kasane_proc_resource .literal.pocket_kasane_proc_resource_at .literal.pocket_kasane_proc_resource_at$part$0 .literal.pocket_kasane_reset .literal.pocket_kasane_set_animation_time .literal.pocket_kasane_set_dormant .literal.pocket_kasane_set_viewport .literal.pocket_kasane_source_capability .literal.pocket_kasane_source_wait_ticks .literal.pocket_kasane_system_pending .literal.pocket_kasane_update_notice .literal.pocket_kasane_video_can_select .literal.pocket_kasane_video_invalidate .literal.pocket_kasane_video_resource .literal.property_color .literal.property_rect$constprop$0 .literal.property_u16$constprop$0 .literal.property_u8 .literal.provider_submitted .literal.ref_finalizer .literal.ref_from .literal.run_build .literal.runtime_binding .literal.runtime_optional_binding .literal.runtime_u16 .literal.runtime_u32 .literal.scene_finalizer .literal.scene_flush .literal.scene_invalidate .literal.scene_mark .literal.schema_external_remove .literal.schema_prune_stale .literal.schema_refresh .literal.schema_refresh_native .literal.schema_refresh_native_many .literal.text_string .literal.throw_result .literal.viewport_clip .text .text.animation_stop .text.apply_outcome .text.bounded_cstring .text.build_kasane .text.change_ref .text.discard_candidates .text.ensure_state .text.expose_ref .text.js_animation_finish .text.js_animation_finish_checked .text.js_animation_poll .text.js_animation_stop .text.js_animation_stop_checked .text.js_cache_create .text.js_cache_release .text.js_cancel .text.js_create_scene .text.js_features .text.js_input_scope .text.js_instance_place .text.js_instance_place_checked .text.js_instance_visible .text.js_instance_visible_checked .text.js_modal_close .text.js_modal_close_checked .text.js_modal_open .text.js_modal_open_checked .text.js_patch .text.js_poll .text.js_presenter_mount .text.js_ref_animate .text.js_ref_animate_checked .text.js_ref_clip .text.js_ref_clip_checked .text.js_ref_color .text.js_ref_color_checked .text.js_ref_image .text.js_ref_image_checked .text.js_ref_rect .text.js_ref_rect_checked .text.js_ref_reveal .text.js_ref_reveal_checked .text.js_ref_rotation .text.js_ref_rotation_checked .text.js_ref_text .text.js_ref_text_checked .text.js_ref_visible .text.js_ref_visible_checked .text.js_replace .text.js_resource .text.js_schema_bind_method .text.js_schema_mount .text.js_schema_set .text.js_schema_set_method .text.js_schema_unbind_method .text.js_stats .text.js_tx_background .text.js_tx_background_checked .text.js_tx_gradient .text.js_tx_gradient_checked .text.js_tx_group .text.js_tx_group_checked .text.js_tx_image .text.js_tx_image_checked .text.js_tx_instantiate .text.js_tx_instantiate_checked .text.js_tx_primitive .text.js_tx_rect .text.js_tx_rect_checked .text.js_tx_round_rect .text.js_tx_round_rect_checked .text.js_tx_stroke_rect .text.js_tx_stroke_rect_checked .text.js_tx_text .text.js_tx_text_checked .text.lazy_proto .text.number_in .text.parse_angle .text.parse_choice$constprop$0 .text.parse_draw_base .text.parse_placement .text.parse_pose$constprop$0 .text.parse_u32 .text.pocket_kasane_active .text.pocket_kasane_advance .text.pocket_kasane_animation_pending .text.pocket_kasane_animations_presented .text.pocket_kasane_end_turn .text.pocket_kasane_grid_invalidate .text.pocket_kasane_grid_resource .text.pocket_kasane_grid_source_port .text.pocket_kasane_has_submission .text.pocket_kasane_input_scope .text.pocket_kasane_install .text.pocket_kasane_invalidate .text.pocket_kasane_invalidate_bands .text.pocket_kasane_needs_present .text.pocket_kasane_notice_composited .text.pocket_kasane_opaque_system_bands .text.pocket_kasane_park_turn .text.pocket_kasane_pixel_can_stage .text.pocket_kasane_pixel_invalidate .text.pocket_kasane_pixel_resource .text.pocket_kasane_prepare .text.pocket_kasane_present .text.pocket_kasane_present_backdrop .text.pocket_kasane_present_complete .text.pocket_kasane_present_complete$part$0 .text.pocket_kasane_presenter_host_status .text.pocket_kasane_presenter_settle .text.pocket_kasane_presenter_step .text.pocket_kasane_proc_publish .text.pocket_kasane_proc_publish_at .text.pocket_kasane_proc_resource .text.pocket_kasane_proc_resource_at .text.pocket_kasane_proc_resource_at$part$0 .text.pocket_kasane_reset .text.pocket_kasane_set_animation_time .text.pocket_kasane_set_dormant .text.pocket_kasane_set_viewport .text.pocket_kasane_source_capability .text.pocket_kasane_source_wait_ticks .text.pocket_kasane_system_pending .text.pocket_kasane_update_notice .text.pocket_kasane_video_can_select .text.pocket_kasane_video_invalidate .text.pocket_kasane_video_resource .text.property_color .text.property_rect$constprop$0 .text.property_u16$constprop$0 .text.property_u8 .text.provider_busy .text.provider_submitted .text.ref_finalizer .text.ref_from .text.run_build .text.runtime_binding .text.runtime_optional_binding .text.runtime_u16 .text.runtime_u32 .text.scene_finalizer .text.scene_flush .text.scene_invalidate .text.scene_mark .text.schema_external_remove .text.schema_prune_stale .text.schema_refresh .text.schema_refresh_native .text.schema_refresh_native_many .text.text_string .text.throw_result .text.viewport_clip)
 *libmain.a:solar_sail.*(.literal.disk$isra$0 .literal.eccentric .literal.fill_row .literal.index_lines .literal.line .literal.ring$isra$0 .literal.satellite_disks$isra$0 .literal.solar_sail_draw .literal.solar_sail_prepare .literal.solar_sail_target .literal.solar_sail_time_label .text .text.disk$isra$0 .text.eccentric .text.fill_row .text.index_lines .text.line .text.ring$isra$0 .text.satellite_disks$isra$0 .text.solar_sail_draw .text.solar_sail_prepare .text.solar_sail_target .text.solar_sail_time_label)
 *libquickjs-ng.a:dtoa.*(.literal.i32toa .literal.i64toa .literal.i64toa_radix .literal.js_atod .literal.js_dtoa .literal.js_dtoa_max_len .literal.mp_div1norm$constprop$0 .literal.mpb_mul1_base .literal.mpb_shr_round .literal.mul_log2_radix .literal.mul_pow .literal.mul_pow_round .literal.output_digits .literal.pow_ui .literal.round_to_d$constprop$0 .literal.u32toa_len .literal.u64toa .literal.u64toa_radix .text .text.i32toa .text.i64toa .text.i64toa_radix .text.js_atod .text.js_dtoa .text.js_dtoa_max_len .text.mp_div1norm$constprop$0 .text.mpb_mul1_base .text.mpb_renorm .text.mpb_shr_round .text.mul_log2_radix .text.mul_pow .text.mul_pow_round .text.output_digits .text.pow_ui .text.round_to_d$constprop$0 .text.to_digit .text.u32toa_len .text.u64toa .text.u64toa_radix)
 *libquickjs-ng.a:quickjs.*(.literal.BC_add_object_ref1 .literal.JS_AddBrand .literal.JS_AddIntrinsicBaseObjects .literal.JS_AddIntrinsicBigInt .literal.JS_AddIntrinsicDOMException .literal.JS_AddIntrinsicDate .literal.JS_AddIntrinsicEval .literal.JS_AddIntrinsicJSON .literal.JS_AddIntrinsicMapSet .literal.JS_AddIntrinsicPromise .literal.JS_AddIntrinsicProxy .literal.JS_AddIntrinsicRegExp .literal.JS_AddIntrinsicRegExpCompiler .literal.JS_AddIntrinsicTypedArrays .literal.JS_AddIntrinsicWeakRef .literal.JS_AddModuleExport .literal.JS_AddModuleExportList .literal.JS_AddPerformance .literal.JS_AddRuntimeFinalizer .literal.JS_ArraySpeciesCreate .literal.JS_AtomGetKind$isra$0 .literal.JS_AtomGetStr$constprop$0$isra$0 .literal.JS_AtomGetStrRT$constprop$0 .literal.JS_AtomIsArrayIndex .literal.JS_AtomIsNumericIndex .literal.JS_AtomIsNumericIndex1 .literal.JS_AtomToCStringLen .literal.JS_AtomToString .literal.JS_AutoInitProperty .literal.JS_Call .literal.JS_CallConstructor .literal.JS_CallConstructor2 .literal.JS_CallConstructorInternal .literal.JS_CallFree .literal.JS_CallInternal .literal.JS_CheckBrand .literal.JS_CompactBigInt .literal.JS_ComputeMemoryUsage .literal.JS_ConcatString .literal.JS_ConcatString3 .literal.JS_CopyDataProperties .literal.JS_CopySubArray .literal.JS_CreateDataPropertyUint32 .literal.JS_CreateProperty .literal.JS_DefineAutoInitProperty .literal.JS_DefineObjectName$constprop$0 .literal.JS_DefineObjectNameComputed$constprop$0 .literal.JS_DefineProperty .literal.JS_DefinePropertyDesc .literal.JS_DefinePropertyGetSet .literal.JS_DefinePropertyValueInt64 .literal.JS_DefinePropertyValueInt64Const$constprop$0 .literal.JS_DefinePropertyValueStr .literal.JS_DefinePropertyValueUint32 .literal.JS_DefinePropertyValueValue .literal.JS_DeleteProperty .literal.JS_DeletePropertyInt64 .literal.JS_DetachArrayBuffer .literal.JS_DetectModule .literal.JS_DumpMemoryUsage .literal.JS_DupValue .literal.JS_DupValueRT .literal.JS_EnqueueJob .literal.JS_Eval .literal.JS_Eval2 .literal.JS_EvalFunction .literal.JS_EvalFunctionInternal .literal.JS_EvalInternal .literal.JS_EvalObject .literal.JS_EvalThis .literal.JS_EvalThis2 .literal.JS_ExecutePendingJob .literal.JS_FlattenIntoArray .literal.JS_FreeAtomStruct .literal.JS_FreeCString .literal.JS_FreeCStringRT .literal.JS_FreeCStringRT_UTF16 .literal.JS_FreeCStringUTF16 .literal.JS_FreeContext .literal.JS_FreePropertyEnum .literal.JS_FreeRuntime .literal.JS_FreezeObject .literal.JS_GetArrayBuffer .literal.JS_GetClassName .literal.JS_GetClassProto .literal.JS_GetFunctionBytecode .literal.JS_GetFunctionProto .literal.JS_GetFunctionRealm .literal.JS_GetGlobalObject .literal.JS_GetImportMeta .literal.JS_GetIterator .literal.JS_GetIterator2 .literal.JS_GetModuleName .literal.JS_GetModuleNamespace .literal.JS_GetModulePrivateValue .literal.JS_GetOpaque2 .literal.JS_GetOwnProperty .literal.JS_GetOwnPropertyFlagsInternal .literal.JS_GetOwnPropertyInternal .literal.JS_GetOwnPropertyInternal2 .literal.JS_GetOwnPropertyNames .literal.JS_GetOwnPropertyNames2 .literal.JS_GetOwnPropertyNamesInternal .literal.JS_GetPropertyInternal .literal.JS_GetPropertyValue .literal.JS_GetPrototype .literal.JS_GetPrototypeFree .literal.JS_GetProxyHandler .literal.JS_GetProxyTarget .literal.JS_GetScriptOrModuleName .literal.JS_GetTypedArrayBuffer .literal.JS_GetUint8Array .literal.JS_GetVersion .literal.JS_HasProperty .literal.JS_InstantiateFunctionListItem$isra$0 .literal.JS_InstantiateFunctionListItem2 .literal.JS_Invoke .literal.JS_InvokeFree .literal.JS_IsEqual .literal.JS_IsExtensible .literal.JS_IsImmutableArrayBuffer .literal.JS_IsInstanceOf .literal.JS_IsSameValue .literal.JS_IsSameValueZero .literal.JS_IsStrictEqual .literal.JS_IteratorClose .literal.JS_IteratorGetCompleteValue .literal.JS_IteratorNext .literal.JS_IteratorNext2 .literal.JS_JSONStringify .literal.JS_LoadModule .literal.JS_LoadModuleInternal .literal.JS_MakeError .literal.JS_MakeError2 .literal.JS_NewArrayBuffer .literal.JS_NewArrayBufferCopy .literal.JS_NewAtomInt64 .literal.JS_NewAtomLen .literal.JS_NewAtomStr$isra$0 .literal.JS_NewAtomString .literal.JS_NewAtomUInt32 .literal.JS_NewBigInt64 .literal.JS_NewBigUint64 .literal.JS_NewCClosure .literal.JS_NewCConstructor .literal.JS_NewCFunction2 .literal.JS_NewCFunction3 .literal.JS_NewCFunctionData .literal.JS_NewCFunctionData2 .literal.JS_NewCModule .literal.JS_NewClass .literal.JS_NewClass1 .literal.JS_NewContext .literal.JS_NewContextRaw .literal.JS_NewDate .literal.JS_NewError .literal.JS_NewGlobalCConstructor2 .literal.JS_NewInternalError .literal.JS_NewNumber .literal.JS_NewObjectClass .literal.JS_NewObjectFrom .literal.JS_NewObjectFromStr .literal.JS_NewObjectProto .literal.JS_NewObjectProtoClassAlloc .literal.JS_NewObjectProtoList .literal.JS_NewPlainError .literal.JS_NewPromiseCapability .literal.JS_NewProxy .literal.JS_NewRangeError .literal.JS_NewReferenceError .literal.JS_NewRuntime .literal.JS_NewRuntime2 .literal.JS_NewSettledPromise .literal.JS_NewString .literal.JS_NewStringLen .literal.JS_NewStringUTF16 .literal.JS_NewSymbol .literal.JS_NewSymbolFromAtom .literal.JS_NewSymbolInternal .literal.JS_NewSyntaxError .literal.JS_NewTypeError .literal.JS_NewTypedArray .literal.JS_NewUint8Array .literal.JS_NewUint8ArrayCopy .literal.JS_NumberIsInteger .literal.JS_ObjectDefineProperties .literal.JS_OrdinaryIsInstanceOf .literal.JS_ParseJSON .literal.JS_ParseJSON_internal .literal.JS_PocketHarden .literal.JS_PreventExtensions .literal.JS_PromiseResult .literal.JS_PromiseState .literal.JS_ReadObject .literal.JS_ReadObject2 .literal.JS_ReadObjectRec .literal.JS_ReadString .literal.JS_RegExpExec .literal.JS_ResizeAtomHash .literal.JS_ResolveModule .literal.JS_RunGC .literal.JS_SealObject .literal.JS_SetClassProto .literal.JS_SetConstructor .literal.JS_SetConstructor2 .literal.JS_SetGlobalVar .literal.JS_SetImmutableArrayBuffer .literal.JS_SetLength .literal.JS_SetModuleExport .literal.JS_SetModuleExportList .literal.JS_SetModulePrivateValue .literal.JS_SetObjectData .literal.JS_SetOpaqueInternal .literal.JS_SetProperty .literal.JS_SetPropertyFunctionList .literal.JS_SetPropertyInt64 .literal.JS_SetPropertyInternal .literal.JS_SetPropertyInternal2 .literal.JS_SetPropertyStr .literal.JS_SetPropertyUint32 .literal.JS_SetPropertyValue .literal.JS_SetPrototype .literal.JS_SetPrototypeInternal .literal.JS_SetThisTimeValue .literal.JS_SpeciesConstructor .literal.JS_StringToBigInt .literal.JS_TakeOOMCanary .literal.JS_ThisTimeValue .literal.JS_Throw .literal.JS_ThrowDOMException .literal.JS_ThrowError .literal.JS_ThrowError2 .literal.JS_ThrowInternalError .literal.JS_ThrowInterrupted .literal.JS_ThrowOutOfMemory .literal.JS_ThrowPlainError .literal.JS_ThrowRangeError .literal.JS_ThrowReferenceError .literal.JS_ThrowReferenceErrorNotDefined .literal.JS_ThrowReferenceErrorUninitialized .literal.JS_ThrowReferenceErrorUninitialized2$isra$0 .literal.JS_ThrowStackOverflow .literal.JS_ThrowSyntaxError .literal.JS_ThrowSyntaxErrorAtom$isra$0 .literal.JS_ThrowTypeError .literal.JS_ThrowTypeErrorArrayBufferOOB .literal.JS_ThrowTypeErrorAtom .literal.JS_ThrowTypeErrorDetachedArrayBuffer .literal.JS_ThrowTypeErrorImmutableArrayBuffer .literal.JS_ThrowTypeErrorInvalidClass .literal.JS_ThrowTypeErrorNotAConstructor .literal.JS_ThrowTypeErrorNotAFunction .literal.JS_ThrowTypeErrorNotASymbol .literal.JS_ThrowTypeErrorNotAnObject .literal.JS_ThrowTypeErrorOrFalse .literal.JS_ThrowTypeErrorReadOnly .literal.JS_ThrowTypeErrorRevokedProxy .literal.JS_ToArrayLengthFree .literal.JS_ToBigInt64 .literal.JS_ToBigInt64Free .literal.JS_ToBigIntFree .literal.JS_ToBigUint64 .literal.JS_ToBool .literal.JS_ToBoolFree .literal.JS_ToCString .literal.JS_ToCStringLen2 .literal.JS_ToCStringLenUTF16 .literal.JS_ToIndex .literal.JS_ToInt32 .literal.JS_ToInt32Clamp$constprop$0 .literal.JS_ToInt32Sat .literal.JS_ToInt32SatFree .literal.JS_ToInt64 .literal.JS_ToInt64Ext .literal.JS_ToInt64Free .literal.JS_ToInt64Sat .literal.JS_ToInt64SatFree .literal.JS_ToIntegerFree .literal.JS_ToNumber .literal.JS_ToNumberFree .literal.JS_ToNumberHintFree .literal.JS_ToObject .literal.JS_ToObjectString .literal.JS_ToPrimitive .literal.JS_ToPrimitiveFree .literal.JS_ToPropertyKey .literal.JS_ToQuotedString .literal.JS_ToStringCheckObject .literal.JS_ToStringInternal .literal.JS_ToUint8ClampFree .literal.JS_TryGetPropertyInt64 .literal.JS_VMCall .literal.JS_VMCallJob .literal.JS_VMDiscard .literal.JS_VMEval .literal.JS_VMResume .literal.JS_VMStackCompact .literal.JS_VMStackRelocate .literal.JS_VMStackTrim .literal.JS_ValueToAtom .literal.JS_ValueToAtomInternal .literal.JS_WriteObject .literal.JS_WriteObject2 .literal.JS_WriteObjectRec .literal.JS_WriteString .literal.__JS_AtomToValue .literal.__JS_EvalInternal .literal.__JS_FindAtom$constprop$0 .literal.__JS_NewAtom .literal.__js_poll_interrupts .literal.add_arg .literal.add_arguments_var .literal.add_closure_var .literal.add_eval_variables .literal.add_export_entry .literal.add_export_entry2 .literal.add_fast_array_element .literal.add_func_var .literal.add_global_var .literal.add_import .literal.add_private_class_field$isra$0 .literal.add_reloc .literal.add_req_module_entry .literal.add_scope_var .literal.add_var .literal.add_var_this .literal.async_func_free .literal.async_func_init .literal.async_func_mark .literal.async_func_resume .literal.bc_atom_to_idx .literal.bc_csum .literal.bc_get_atom .literal.bc_get_buf .literal.bc_get_leb128 .literal.bc_get_leb128_u16 .literal.bc_get_u8 .literal.bc_idx_to_atom .literal.bc_put_atom$isra$0 .literal.bc_read_error_end$isra$0 .literal.bswap32 .literal.bswap64 .literal.build_arg_list .literal.build_backtrace .literal.build_for_in_iterator .literal.call_setter .literal.check_function .literal.check_regexp_g_flag .literal.close_scopes .literal.close_var_ref .literal.close_var_refs .literal.code_has_label .literal.code_match .literal.compact_properties$isra$0 .literal.compute_jsstring_size .literal.compute_value_size .literal.convert_fast_array_to_array .literal.copy_str16$constprop$0 .literal.cpool_add .literal.dataview_is_oob .literal.days_from_year .literal.dbuf_default_realloc .literal.dbuf_free .literal.dbuf_printf .literal.dbuf_put .literal.dbuf_put_leb128 .literal.dbuf_put_u16$isra$0 .literal.dbuf_put_u32$isra$0 .literal.dbuf_putc$isra$0 .literal.define_var .literal.delete_finrec_weakref .literal.delete_map_weak_ref .literal.delete_property .literal.delete_property0 .literal.emit_atom .literal.emit_class_field_init .literal.emit_class_init_end .literal.emit_class_init_start .literal.emit_goto .literal.emit_label$isra$0 .literal.emit_op$isra$0 .literal.emit_push_const .literal.emit_return .literal.emit_source_loc .literal.emit_u16$isra$0 .literal.emit_u32$isra$0 .literal.emit_u8$isra$0 .literal.encodeURI_hex$isra$0 .literal.exchange_func .literal.exported_names_cmp .literal.fa_var_ref_slot .literal.find_atom .literal.find_jump_target .literal.find_lexical_decl$isra$0 .literal.find_line_num$isra$0 .literal.find_var$isra$0 .literal.free_arg_list .literal.free_bytecode_atoms .literal.free_generator_stack_rt .literal.free_token .literal.free_var_ref .literal.fromfp16 .literal.fulfill_or_reject_promise .literal.gather_available_ancestors .literal.gc_decref_child .literal.gc_scan_incref_child .literal.getTimezoneOffset .literal.get_closure_var .literal.get_date_field .literal.get_date_fields .literal.get_date_string .literal.get_exported_names .literal.get_first_weak_ref .literal.get_func_name .literal.get_loc_or_ref .literal.get_lvalue .literal.get_proxy_method .literal.get_sleb128 .literal.get_typed_array .literal.get_u64 .literal.get_var_ref .literal.hash_string .literal.hash_string_rope .literal.hex_decode .literal.ident_realloc .literal.init_class_range .literal.internalize_json_property .literal.is_let .literal.is_num_string .literal.is_valid_raw_json_char .literal.js_Date_UTC .literal.js_Date_now .literal.js_Date_parse .literal.js_TA_cmp_float16 .literal.js_TA_cmp_float32 .literal.js_TA_cmp_float64 .literal.js_TA_cmp_generic .literal.js_TA_get_float16 .literal.js_TA_get_float32 .literal.js_TA_get_float64 .literal.js_TA_get_int64 .literal.js_TA_get_uint32 .literal.js_TA_get_uint64 .literal.js__atomics_init .literal.js__gettimeofday_us .literal.js__hrtime_ns .literal.js__pstrcat$isra$0 .literal.js_add_slow .literal.js_aggregate_error_constructor .literal.js_alloc_function_bytecode .literal.js_append_enumerate .literal.js_arguments_define_own_property .literal.js_array_at .literal.js_array_buffer_constructor .literal.js_array_buffer_constructor0 .literal.js_array_buffer_constructor2 .literal.js_array_buffer_constructor3 .literal.js_array_buffer_finalizer .literal.js_array_buffer_free .literal.js_array_buffer_get_byteLength .literal.js_array_buffer_get_detached .literal.js_array_buffer_get_immutable .literal.js_array_buffer_get_maxByteLength .literal.js_array_buffer_get_resizable .literal.js_array_buffer_resize .literal.js_array_buffer_slice .literal.js_array_buffer_transfer .literal.js_array_buffer_update_typed_arrays .literal.js_array_cmp_generic .literal.js_array_concat .literal.js_array_constructor .literal.js_array_copyWithin .literal.js_array_every .literal.js_array_fill .literal.js_array_find .literal.js_array_flatten .literal.js_array_from .literal.js_array_fromAsync .literal.js_array_includes .literal.js_array_indexOf .literal.js_array_isArray .literal.js_array_iterator_finalizer .literal.js_array_iterator_mark .literal.js_array_iterator_next .literal.js_array_join .literal.js_array_lastIndexOf .literal.js_array_mark .literal.js_array_of .literal.js_array_pop .literal.js_array_push .literal.js_array_reduce .literal.js_array_reverse .literal.js_array_slice .literal.js_array_sort .literal.js_array_toReversed .literal.js_array_toSorted .literal.js_array_toSpliced .literal.js_array_toString .literal.js_array_with .literal.js_async_from_sync_iterator_close .literal.js_async_from_sync_iterator_finalizer .literal.js_async_from_sync_iterator_mark .literal.js_async_from_sync_iterator_next .literal.js_async_from_sync_iterator_unwrap .literal.js_async_function_call .literal.js_async_function_free .literal.js_async_function_resolve_call .literal.js_async_function_resolve_finalizer .literal.js_async_function_resume .literal.js_async_function_settle_core .literal.js_async_generator_complete .literal.js_async_generator_finalizer .literal.js_async_generator_free .literal.js_async_generator_function_call .literal.js_async_generator_mark .literal.js_async_generator_next .literal.js_async_generator_resolve .literal.js_async_generator_resolve_function .literal.js_async_generator_resolve_function_create .literal.js_async_generator_resolve_or_reject$isra$0 .literal.js_async_generator_resume_next .literal.js_async_module_execution_fulfilled .literal.js_async_module_execution_rejected .literal.js_atof .literal.js_atom_concat_str .literal.js_atomics_get_buf .literal.js_atomics_isLockFree .literal.js_atomics_notify .literal.js_atomics_op .literal.js_atomics_pause .literal.js_atomics_store .literal.js_atomics_wait .literal.js_bigint_add .literal.js_bigint_asUintN .literal.js_bigint_cmp$isra$0 .literal.js_bigint_constructor .literal.js_bigint_divrem .literal.js_bigint_extend .literal.js_bigint_float64_cmp$isra$0 .literal.js_bigint_get_mant_exp$isra$0 .literal.js_bigint_mul .literal.js_bigint_neg .literal.js_bigint_new .literal.js_bigint_new_di .literal.js_bigint_new_si .literal.js_bigint_normalize .literal.js_bigint_normalize1 .literal.js_bigint_not .literal.js_bigint_shl .literal.js_bigint_toString .literal.js_bigint_to_string1 .literal.js_bigint_valueOf .literal.js_binary_arith_slow .literal.js_binary_logic_slow .literal.js_boolean_constructor .literal.js_boolean_toString .literal.js_boolean_valueOf .literal.js_bound_function_finalizer .literal.js_bound_function_mark .literal.js_build_mapped_arguments .literal.js_bytecode_function_finalizer .literal.js_bytecode_function_mark .literal.js_c_closure_finalizer .literal.js_c_function_data_finalizer .literal.js_c_function_data_mark .literal.js_c_function_finalizer .literal.js_call_bound_function .literal.js_call_c_closure .literal.js_call_c_function .literal.js_call_c_function_data .literal.js_call_generator_function .literal.js_call_math_fast .literal.js_calloc .literal.js_calloc_rt .literal.js_callsite_finalizer .literal.js_callsite_getfield .literal.js_callsite_getnumber .literal.js_callsite_isnative .literal.js_callsite_mark .literal.js_clone_shape .literal.js_closure .literal.js_closure2 .literal.js_cmp_doubles .literal.js_compare_bigint .literal.js_compile_regexp .literal.js_coro_owner .literal.js_coro_release .literal.js_create_array .literal.js_create_array_iterator .literal.js_create_async_from_sync_iterator .literal.js_create_from_ctor .literal.js_create_function .literal.js_create_iterator_helper .literal.js_create_iterator_result .literal.js_create_map_iterator .literal.js_create_module_function .literal.js_create_module_var .literal.js_create_resolving_functions .literal.js_create_typed_array_iterator .literal.js_dataview_constructor .literal.js_dataview_getValue .literal.js_dataview_get_buffer .literal.js_dataview_get_byteLength .literal.js_dataview_get_byteOffset .literal.js_dataview_setValue .literal.js_date_Symbol_toPrimitive .literal.js_date_constructor .literal.js_date_getTime .literal.js_date_getTimezoneOffset .literal.js_date_setTime .literal.js_date_setYear .literal.js_date_toJSON .literal.js_dbuf_init .literal.js_dbuf_realloc .literal.js_def_calloc .literal.js_def_free .literal.js_def_malloc .literal.js_def_realloc .literal.js_define_var .literal.js_domexception_constructor .literal.js_domexception_constructor0$isra$0 .literal.js_domexception_finalizer .literal.js_domexception_get_code .literal.js_domexception_getfield .literal.js_domexception_mark .literal.js_dtoa2 .literal.js_dynamic_import .literal.js_dynamic_import_job .literal.js_emit_spread_code .literal.js_empty_string$isra$0 .literal.js_eq_slow .literal.js_error_capture_stack_trace .literal.js_error_constructor .literal.js_error_get_prepareStackTrace .literal.js_error_get_stackTraceLimit .literal.js_error_isError .literal.js_error_set_prepareStackTrace .literal.js_error_set_stackTraceLimit .literal.js_error_toString .literal.js_execute_async_module$isra$0 .literal.js_execute_sync_module .literal.js_fa_await .literal.js_fa_continue .literal.js_fa_finish .literal.js_fa_get_method .literal.js_fa_run .literal.js_fa_set .literal.js_finrec_constructor .literal.js_finrec_finalizer .literal.js_finrec_free .literal.js_finrec_job .literal.js_finrec_mark .literal.js_finrec_register .literal.js_finrec_unregister .literal.js_for_in_iterator_finalizer .literal.js_for_in_iterator_mark .literal.js_for_of_start .literal.js_force_tostring .literal.js_free .literal.js_free_cstring .literal.js_free_desc .literal.js_free_function_bytecode_allocation .literal.js_free_function_def .literal.js_free_module_def .literal.js_free_modules .literal.js_free_prop_enum .literal.js_free_shape_null .literal.js_free_string .literal.js_function_apply .literal.js_function_bind .literal.js_function_call .literal.js_function_constructor .literal.js_function_hasInstance .literal.js_function_proto_fileName .literal.js_function_proto_int32 .literal.js_function_set_properties .literal.js_function_toString .literal.js_generator_finalizer .literal.js_generator_mark .literal.js_generator_next .literal.js_get_array_buffer .literal.js_get_atom_index .literal.js_get_function_name .literal.js_get_length32 .literal.js_get_proxy_field .literal.js_get_radix .literal.js_get_regexp .literal.js_get_this .literal.js_global_decodeURI .literal.js_global_encodeURI .literal.js_global_escape .literal.js_global_eval .literal.js_global_isFinite .literal.js_global_isNaN .literal.js_global_queueMicrotask .literal.js_global_unescape .literal.js_harden_lock .literal.js_harden_lock_value .literal.js_harden_proto_change .literal.js_host_resolve_imported_module .literal.js_host_resolve_imported_module_atom .literal.js_inner_module_evaluation .literal.js_inner_module_linking .literal.js_instantiate_prototype .literal.js_int64 .literal.js_is_array .literal.js_is_live_code$isra$0 .literal.js_is_regexp .literal.js_iterator_concat .literal.js_iterator_concat_finalizer .literal.js_iterator_concat_mark .literal.js_iterator_concat_next .literal.js_iterator_concat_return .literal.js_iterator_constructor .literal.js_iterator_constructor_getset .literal.js_iterator_from .literal.js_iterator_helper_finalizer .literal.js_iterator_helper_mark .literal.js_iterator_helper_next .literal.js_iterator_proto_func .literal.js_iterator_proto_get_toStringTag .literal.js_iterator_proto_iterator .literal.js_iterator_proto_reduce .literal.js_iterator_proto_set_toStringTag .literal.js_iterator_proto_toArray .literal.js_iterator_wrap_finalizer .literal.js_iterator_wrap_mark .literal.js_iterator_wrap_next .literal.js_iterator_zip .literal.js_iterator_zip_free .literal.js_json_check .literal.js_json_parse .literal.js_json_rawJSON .literal.js_json_stringify .literal.js_json_to_str$isra$0 .literal.js_lazy_all .literal.js_lazy_bind .literal.js_lazy_class_ensure .literal.js_lazy_make .literal.js_lazy_touch$isra$0 .literal.js_load_module_fulfilled .literal.js_load_module_rejected .literal.js_mallocz .literal.js_mallocz_rt .literal.js_map_clear .literal.js_map_constructor .literal.js_map_delete .literal.js_map_finalizer .literal.js_map_forEach .literal.js_map_get .literal.js_map_getOrInsert .literal.js_map_get_size .literal.js_map_groupBy .literal.js_map_has .literal.js_map_iterator_finalizer .literal.js_map_iterator_mark .literal.js_map_iterator_next .literal.js_map_mark .literal.js_map_read .literal.js_map_set .literal.js_map_write .literal.js_mapped_arguments_finalizer .literal.js_math_acos .literal.js_math_acosh .literal.js_math_asin .literal.js_math_asinh .literal.js_math_atan .literal.js_math_atan2 .literal.js_math_atanh .literal.js_math_cbrt .literal.js_math_ceil .literal.js_math_clz32 .literal.js_math_cos .literal.js_math_cosh .literal.js_math_exp .literal.js_math_expm1 .literal.js_math_f16round .literal.js_math_floor .literal.js_math_fround .literal.js_math_hypot .literal.js_math_imul .literal.js_math_log .literal.js_math_log10 .literal.js_math_log1p .literal.js_math_log2 .literal.js_math_min_max .literal.js_math_pow .literal.js_math_random .literal.js_math_round .literal.js_math_sign .literal.js_math_sinh .literal.js_math_sqrt .literal.js_math_sumPrecise .literal.js_math_tan .literal.js_math_tanh .literal.js_math_trunc .literal.js_method_set_home_object .literal.js_microtask_job .literal.js_module_ns_autoinit .literal.js_module_ns_has .literal.js_mutex_unlock$constprop$0 .literal.js_new_function_def .literal.js_new_module_def .literal.js_new_promise_capability .literal.js_new_shape2$constprop$0 .literal.js_new_shape_nohash .literal.js_new_shape_with .literal.js_new_string16_len .literal.js_new_string8 .literal.js_new_string_char .literal.js_new_string_rope .literal.js_new_uint8array .literal.js_not_slow .literal.js_number_constructor .literal.js_number_isFinite .literal.js_number_isInteger .literal.js_number_isNaN .literal.js_number_isSafeInteger .literal.js_number_toExponential .literal.js_number_toFixed .literal.js_number_toPrecision .literal.js_number_toString .literal.js_number_valueOf .literal.js_obj_to_desc .literal.js_object___defineGetter__ .literal.js_object___lookupGetter__ .literal.js_object_assign .literal.js_object_constructor .literal.js_object_create .literal.js_object_data_finalizer .literal.js_object_data_mark .literal.js_object_defineProperties .literal.js_object_defineProperty .literal.js_object_fromEntries .literal.js_object_getOwnPropertyDescriptor .literal.js_object_getOwnPropertyDescriptors .literal.js_object_getOwnPropertyNames .literal.js_object_getOwnPropertySymbols .literal.js_object_getPrototypeOf .literal.js_object_get___proto__ .literal.js_object_groupBy .literal.js_object_hasOwn .literal.js_object_hasOwnProperty .literal.js_object_has_name$isra$0 .literal.js_object_is .literal.js_object_isExtensible .literal.js_object_isPrototypeOf .literal.js_object_isSealed .literal.js_object_keys .literal.js_object_preventExtensions .literal.js_object_propertyIsEnumerable .literal.js_object_seal .literal.js_object_setPrototypeOf .literal.js_object_set___proto__ .literal.js_object_toLocaleString .literal.js_object_toString .literal.js_object_valueOf .literal.js_oom_canary_record .literal.js_op_define_class .literal.js_operator_typeof .literal.js_parseFloat .literal.js_parseInt .literal.js_parse_assign_expr .literal.js_parse_assign_expr2 .literal.js_parse_block .literal.js_parse_check_duplicate_parameter .literal.js_parse_class .literal.js_parse_destructuring_element .literal.js_parse_destructuring_var$isra$0 .literal.js_parse_directives$part$0 .literal.js_parse_error .literal.js_parse_error_reserved_identifier$isra$0 .literal.js_parse_expect .literal.js_parse_expect_semi .literal.js_parse_expr .literal.js_parse_expr2 .literal.js_parse_expr_binary .literal.js_parse_expr_paren .literal.js_parse_from_clause .literal.js_parse_function_check_names .literal.js_parse_function_decl$constprop$0$isra$0 .literal.js_parse_function_decl2$constprop$0 .literal.js_parse_logical_and_or .literal.js_parse_postfix_expr .literal.js_parse_property_name .literal.js_parse_regexp .literal.js_parse_skip_parens_token .literal.js_parse_source_element .literal.js_parse_statement_or_decl .literal.js_parse_string .literal.js_parse_template .literal.js_parse_template_part .literal.js_parse_unary .literal.js_parse_var .literal.js_parse_with_clause .literal.js_perf_now .literal.js_post_inc_slow .literal.js_promise_all .literal.js_promise_all_resolve_element .literal.js_promise_catch .literal.js_promise_constructor .literal.js_promise_executor .literal.js_promise_finalizer .literal.js_promise_finally .literal.js_promise_finally_thrower .literal.js_promise_finally_value_thunk .literal.js_promise_mark .literal.js_promise_new .literal.js_promise_race .literal.js_promise_resolve .literal.js_promise_resolve_function_call .literal.js_promise_resolve_function_finalizer .literal.js_promise_resolve_function_mark .literal.js_promise_resolve_thenable_job .literal.js_promise_then .literal.js_promise_then_finally_func .literal.js_promise_thenable_tail .literal.js_promise_try .literal.js_promise_withResolvers .literal.js_proxy_call .literal.js_proxy_constructor .literal.js_proxy_define_own_property .literal.js_proxy_delete_property .literal.js_proxy_finalizer .literal.js_proxy_get .literal.js_proxy_get_own_property .literal.js_proxy_get_own_property_names .literal.js_proxy_has .literal.js_proxy_mark .literal.js_proxy_revocable .literal.js_proxy_revoke .literal.js_proxy_set .literal.js_realloc_array .literal.js_rebalance_string_rope .literal.js_rebalance_string_rope_rec .literal.js_reflect_apply .literal.js_reflect_construct .literal.js_reflect_deleteProperty .literal.js_reflect_get .literal.js_reflect_has .literal.js_reflect_ownKeys .literal.js_reflect_set .literal.js_reflect_setPrototypeOf .literal.js_regexp_Symbol_match .literal.js_regexp_Symbol_matchAll .literal.js_regexp_Symbol_replace .literal.js_regexp_Symbol_search .literal.js_regexp_Symbol_split .literal.js_regexp_compile .literal.js_regexp_constructor .literal.js_regexp_constructor_internal .literal.js_regexp_escape .literal.js_regexp_exec .literal.js_regexp_finalizer .literal.js_regexp_get_flag .literal.js_regexp_get_flags .literal.js_regexp_get_source .literal.js_regexp_string_iterator_finalizer .literal.js_regexp_string_iterator_mark .literal.js_regexp_string_iterator_next .literal.js_regexp_test .literal.js_regexp_toString .literal.js_relational_slow .literal.js_resize_array .literal.js_resolve_export .literal.js_resolve_export1 .literal.js_resolve_export_throw_error .literal.js_resolve_module .literal.js_rom_find .literal.js_rom_new_string .literal.js_same_value$isra$0 .literal.js_set_difference .literal.js_set_intersection .literal.js_set_isDisjointFrom .literal.js_set_isSubsetOf .literal.js_set_isSupersetOf .literal.js_set_module_evaluated .literal.js_set_symmetricDifference .literal.js_set_union .literal.js_setlike_get_props .literal.js_shape_prepare_update .literal.js_shared_array_buffer_constructor .literal.js_shr_slow .literal.js_strdup .literal.js_strict_eq2$isra$0 .literal.js_strict_eq_slow .literal.js_string_CreateHTML .literal.js_string___GetSubstitution$constprop$0 .literal.js_string_at .literal.js_string_charAt .literal.js_string_charCodeAt .literal.js_string_codePointAt .literal.js_string_codePointRange .literal.js_string_compare .literal.js_string_concat .literal.js_string_constructor .literal.js_string_define_own_property .literal.js_string_eq .literal.js_string_fromCharCode .literal.js_string_fromCodePoint .literal.js_string_get_own_property .literal.js_string_includes .literal.js_string_indexOf .literal.js_string_isWellFormed .literal.js_string_iterator_next .literal.js_string_localeCompare .literal.js_string_match .literal.js_string_memcmp .literal.js_string_normalize .literal.js_string_pad .literal.js_string_raw .literal.js_string_repeat .literal.js_string_replace .literal.js_string_rope_compare .literal.js_string_slice .literal.js_string_split .literal.js_string_substr .literal.js_string_substring .literal.js_string_toLowerCase .literal.js_string_toString .literal.js_string_toWellFormed .literal.js_string_trim .literal.js_strndup .literal.js_sub_string .literal.js_symbol_constructor .literal.js_symbol_for .literal.js_symbol_get_description .literal.js_symbol_keyFor .literal.js_symbol_toString .literal.js_symbol_valueOf .literal.js_thisBigIntValue .literal.js_thisBooleanValue .literal.js_thisNumberValue .literal.js_thisSymbolValue .literal.js_throw_URIError .literal.js_throw_harden .literal.js_throw_type_error .literal.js_typed_array___speciesCreate$constprop$0 .literal.js_typed_array_at .literal.js_typed_array_base_constructor .literal.js_typed_array_constructor .literal.js_typed_array_constructor_ta .literal.js_typed_array_copyWithin .literal.js_typed_array_create .literal.js_typed_array_fill .literal.js_typed_array_finalizer .literal.js_typed_array_find .literal.js_typed_array_from .literal.js_typed_array_get_buffer .literal.js_typed_array_get_byteLength .literal.js_typed_array_get_byteOffset .literal.js_typed_array_get_length .literal.js_typed_array_get_length_unsafe .literal.js_typed_array_get_toStringTag .literal.js_typed_array_indexOf .literal.js_typed_array_join .literal.js_typed_array_mark .literal.js_typed_array_of .literal.js_typed_array_reverse .literal.js_typed_array_set .literal.js_typed_array_slice .literal.js_typed_array_sort .literal.js_typed_array_subarray .literal.js_typed_array_toReversed .literal.js_typed_array_toSorted .literal.js_typed_array_with .literal.js_uint32 .literal.js_unary_arith_slow .literal.js_update_property_flags .literal.js_vm_arm .literal.js_vm_push_yield .literal.js_vm_release_job .literal.js_vm_seg_new$isra$0 .literal.js_vm_stack_pop .literal.js_vm_stack_push .literal.js_vm_state .literal.js_weakref_constructor .literal.js_weakref_deref .literal.js_weakref_finalizer .literal.js_write_fail_throws .literal.js_zip_close_all .literal.js_zip_flatten .literal.js_zip_iter_step .literal.json_free_parse_record .literal.json_next_token .literal.json_parse_error$isra$0 .literal.json_parse_record_add .literal.json_parse_value .literal.lazy_define .literal.lazy_key .literal.lazy_list_of .literal.lazy_owner .literal.lazy_remove .literal.lazy_undo_done .literal.lre_js_is_ident_first .literal.lre_js_is_ident_next .literal.lre_realloc .literal.map_add_record .literal.map_decref_record .literal.map_delete_record .literal.map_find_record$isra$0 .literal.map_hash_key$isra$0 .literal.map_normalize_key$isra$0 .literal.mark_children .literal.new_label .literal.new_label_fd .literal.next_token .literal.num_keys_cmp .literal.optimize_scope_make_ref$isra$0 .literal.optional_chain_test .literal.parse_ident .literal.peek_token$isra$0 .literal.perform_promise_then .literal.pop_scope .literal.promise_reaction_data_free .literal.promise_reaction_job .literal.promise_reaction_tail .literal.push_scope .literal.push_short_int .literal.put_lvalue .literal.put_short_code .literal.put_u32 .literal.remainingElementsCount_add .literal.reset_weak_ref .literal.resize_properties .literal.resolve_pseudo_var .literal.resolve_scope_private_field1 .literal.resolve_scope_var .literal.resolve_variables .literal.rqsort .literal.seal_template_obj$isra$0 .literal.set_array_length .literal.set_date_field .literal.set_date_fields .literal.set_eval_ret_undefined .literal.set_object_name .literal.set_object_name_computed .literal.skip_dead_code .literal.skip_spaces .literal.ss_check .literal.string_advance_index .literal.string_buffer_concat .literal.string_buffer_concat_value .literal.string_buffer_concat_value_free .literal.string_buffer_end .literal.string_buffer_free .literal.string_buffer_init .literal.string_buffer_putc .literal.string_buffer_putc16_slow .literal.string_buffer_putc8 .literal.string_buffer_putc_slow .literal.string_buffer_puts8$isra$0 .literal.string_buffer_realloc .literal.string_buffer_set_error$isra$0 .literal.string_buffer_widen .literal.string_buffer_write8 .literal.string_cmp .literal.string_get .literal.string_get_digits .literal.string_get_hex .literal.string_get_milliseconds$isra$0 .literal.string_get_tzoffset .literal.string_getc .literal.string_indexof .literal.string_indexof_char .literal.string_rope_iter_next .literal.tdz_walk .literal.time_clip .literal.to_utf32_buf .literal.tofp16 .literal.typed_array_init .literal.typed_array_is_immutable .literal.typed_array_is_oob .literal.update_label .literal.utf8_decode .literal.utf8_decode_len .literal.utf8_encode .literal.validate_typed_array .literal.value_buffer_free .literal.var_object_test .text .text.BC_add_object_ref1 .text.JS_AddBrand .text.JS_AddIntrinsicBaseObjects .text.JS_AddIntrinsicBigInt .text.JS_AddIntrinsicDOMException .text.JS_AddIntrinsicDate .text.JS_AddIntrinsicEval .text.JS_AddIntrinsicJSON .text.JS_AddIntrinsicMapSet .text.JS_AddIntrinsicPromise .text.JS_AddIntrinsicProxy .text.JS_AddIntrinsicRegExp .text.JS_AddIntrinsicRegExpCompiler .text.JS_AddIntrinsicTypedArrays .text.JS_AddIntrinsicWeakRef .text.JS_AddModuleExport .text.JS_AddModuleExportList .text.JS_AddPerformance .text.JS_AddRuntimeFinalizer .text.JS_ArraySpeciesCreate .text.JS_AtomGetKind$isra$0 .text.JS_AtomGetStr$constprop$0$isra$0 .text.JS_AtomGetStrRT$constprop$0 .text.JS_AtomIsArrayIndex .text.JS_AtomIsNumericIndex .text.JS_AtomIsNumericIndex1 .text.JS_AtomToCStringLen .text.JS_AtomToString .text.JS_AutoInitProperty .text.JS_Call .text.JS_CallConstructor .text.JS_CallConstructor2 .text.JS_CallConstructorInternal .text.JS_CallFree .text.JS_CallInternal .text.JS_CheckBrand .text.JS_ClearUncatchableError .text.JS_CompactBigInt .text.JS_ComputeMemoryUsage .text.JS_ConcatString .text.JS_ConcatString3 .text.JS_CopyDataProperties .text.JS_CopySubArray .text.JS_CreateDataPropertyUint32 .text.JS_CreateProperty .text.JS_DefineAutoInitProperty .text.JS_DefineObjectName$constprop$0 .text.JS_DefineObjectNameComputed$constprop$0 .text.JS_DefineProperty .text.JS_DefinePropertyDesc .text.JS_DefinePropertyGetSet .text.JS_DefinePropertyValueInt64 .text.JS_DefinePropertyValueInt64Const$constprop$0 .text.JS_DefinePropertyValueStr .text.JS_DefinePropertyValueUint32 .text.JS_DefinePropertyValueValue .text.JS_DeleteProperty .text.JS_DeletePropertyInt64 .text.JS_DetachArrayBuffer .text.JS_DetectModule .text.JS_DumpMemoryUsage .text.JS_DupAtomRT .text.JS_DupContext .text.JS_DupValue .text.JS_DupValueRT .text.JS_EnqueueJob .text.JS_Eval .text.JS_Eval2 .text.JS_EvalFunction .text.JS_EvalFunctionInternal .text.JS_EvalInternal .text.JS_EvalObject .text.JS_EvalThis .text.JS_EvalThis2 .text.JS_ExecutePendingJob .text.JS_FlattenIntoArray .text.JS_FreeAtomStruct .text.JS_FreeCString .text.JS_FreeCStringRT .text.JS_FreeCStringRT_UTF16 .text.JS_FreeCStringUTF16 .text.JS_FreeContext .text.JS_FreePropertyEnum .text.JS_FreeRuntime .text.JS_FreezeObject .text.JS_GetAnyOpaque .text.JS_GetArrayBuffer .text.JS_GetClassID .text.JS_GetClassName .text.JS_GetClassProto .text.JS_GetContextOpaque .text.JS_GetDumpFlags .text.JS_GetException .text.JS_GetFunctionBytecode .text.JS_GetFunctionProto .text.JS_GetFunctionRealm .text.JS_GetGCThreshold .text.JS_GetGlobalObject .text.JS_GetImportMeta .text.JS_GetIterator .text.JS_GetIterator2 .text.JS_GetMemoryCounters .text.JS_GetModuleName .text.JS_GetModuleNamespace .text.JS_GetModulePrivateValue .text.JS_GetOpaque2 .text.JS_GetOwnProperty .text.JS_GetOwnPropertyFlagsInternal .text.JS_GetOwnPropertyInternal .text.JS_GetOwnPropertyInternal2 .text.JS_GetOwnPropertyNames .text.JS_GetOwnPropertyNames2 .text.JS_GetOwnPropertyNamesInternal .text.JS_GetPendingJobContext .text.JS_GetPropertyInternal .text.JS_GetPropertyValue .text.JS_GetPrototype .text.JS_GetPrototypeFree .text.JS_GetPrototypePrimitive .text.JS_GetProxyHandler .text.JS_GetProxyTarget .text.JS_GetRuntime .text.JS_GetRuntimeOpaque .text.JS_GetScriptOrModuleName .text.JS_GetTypedArrayBuffer .text.JS_GetTypedArrayType .text.JS_GetUint8Array .text.JS_GetVersion .text.JS_HasException .text.JS_HasProperty .text.JS_InstantiateFunctionListItem$isra$0 .text.JS_InstantiateFunctionListItem2 .text.JS_Invoke .text.JS_InvokeFree .text.JS_IsArrayBuffer .text.JS_IsAsyncFunction .text.JS_IsConstructor .text.JS_IsDataView .text.JS_IsDate .text.JS_IsEqual .text.JS_IsError .text.JS_IsExtensible .text.JS_IsFunction .text.JS_IsImmutableArrayBuffer .text.JS_IsInstanceOf .text.JS_IsJobPending .text.JS_IsLiveObject .text.JS_IsMap .text.JS_IsNumber .text.JS_IsPromise .text.JS_IsProxy .text.JS_IsRegExp .text.JS_IsRegisteredClass .text.JS_IsSameValue .text.JS_IsSameValueZero .text.JS_IsSet .text.JS_IsStrictEqual .text.JS_IsUncatchableError .text.JS_IsWeakMap .text.JS_IsWeakRef .text.JS_IsWeakSet .text.JS_IteratorClose .text.JS_IteratorGetCompleteValue .text.JS_IteratorNext .text.JS_IteratorNext2 .text.JS_JSONStringify .text.JS_LoadModule .text.JS_LoadModuleInternal .text.JS_MakeError .text.JS_MakeError2 .text.JS_MarkValue .text.JS_NewArrayBuffer .text.JS_NewArrayBufferCopy .text.JS_NewAtomInt64 .text.JS_NewAtomLen .text.JS_NewAtomStr$isra$0 .text.JS_NewAtomString .text.JS_NewAtomUInt32 .text.JS_NewBigInt64 .text.JS_NewBigUint64 .text.JS_NewCClosure .text.JS_NewCConstructor .text.JS_NewCFunction2 .text.JS_NewCFunction3 .text.JS_NewCFunctionData .text.JS_NewCFunctionData2 .text.JS_NewCModule .text.JS_NewClass .text.JS_NewClass1 .text.JS_NewClassID .text.JS_NewContext .text.JS_NewContextRaw .text.JS_NewDate .text.JS_NewError .text.JS_NewGlobalCConstructor2 .text.JS_NewInternalError .text.JS_NewNumber .text.JS_NewObjectClass .text.JS_NewObjectFrom .text.JS_NewObjectFromStr .text.JS_NewObjectProto .text.JS_NewObjectProtoClassAlloc .text.JS_NewObjectProtoList .text.JS_NewPlainError .text.JS_NewPromiseCapability .text.JS_NewProxy .text.JS_NewRangeError .text.JS_NewReferenceError .text.JS_NewRuntime .text.JS_NewRuntime2 .text.JS_NewSettledPromise .text.JS_NewString .text.JS_NewStringLen .text.JS_NewStringUTF16 .text.JS_NewSymbol .text.JS_NewSymbolFromAtom .text.JS_NewSymbolInternal .text.JS_NewSyntaxError .text.JS_NewTypeError .text.JS_NewTypedArray .text.JS_NewUint8Array .text.JS_NewUint8ArrayCopy .text.JS_NumberIsInteger .text.JS_ObjectDefineProperties .text.JS_OrdinaryIsInstanceOf .text.JS_ParseJSON .text.JS_ParseJSON_internal .text.JS_PocketHarden .text.JS_PocketSetStripDebug .text.JS_PreventExtensions .text.JS_PromiseResult .text.JS_PromiseState .text.JS_ReadObject .text.JS_ReadObject2 .text.JS_ReadObjectRec .text.JS_ReadString .text.JS_RegExpExec .text.JS_ResetUncatchableError .text.JS_ResizeAtomHash .text.JS_ResolveModule .text.JS_RunGC .text.JS_SealObject .text.JS_SetCanBlock .text.JS_SetClassProto .text.JS_SetConstructor .text.JS_SetConstructor2 .text.JS_SetConstructorBit .text.JS_SetContextOpaque .text.JS_SetDumpFlags .text.JS_SetGCThreshold .text.JS_SetGlobalVar .text.JS_SetHostPromiseRejectionTracker .text.JS_SetImmutableArrayBuffer .text.JS_SetInterruptHandler .text.JS_SetIsHTMLDDA .text.JS_SetLength .text.JS_SetMaxStackSize .text.JS_SetMemoryLimit .text.JS_SetModuleExport .text.JS_SetModuleExportList .text.JS_SetModuleLoaderFunc .text.JS_SetModuleLoaderFunc2 .text.JS_SetModuleNormalizeFunc2 .text.JS_SetModulePrivateValue .text.JS_SetObjectData .text.JS_SetOpaque .text.JS_SetOpaqueInternal .text.JS_SetPromiseHook .text.JS_SetProperty .text.JS_SetPropertyFunctionList .text.JS_SetPropertyInt64 .text.JS_SetPropertyInternal .text.JS_SetPropertyInternal2 .text.JS_SetPropertyStr .text.JS_SetPropertyUint32 .text.JS_SetPropertyValue .text.JS_SetPrototype .text.JS_SetPrototypeInternal .text.JS_SetRuntimeInfo .text.JS_SetRuntimeOpaque .text.JS_SetSharedArrayBufferFunctions .text.JS_SetThisTimeValue .text.JS_SetUncatchableError .text.JS_SpeciesConstructor .text.JS_StringToBigInt .text.JS_TakeOOMCanary .text.JS_ThisTimeValue .text.JS_Throw .text.JS_ThrowDOMException .text.JS_ThrowError .text.JS_ThrowError2 .text.JS_ThrowInternalError .text.JS_ThrowInterrupted .text.JS_ThrowOutOfMemory .text.JS_ThrowPlainError .text.JS_ThrowRangeError .text.JS_ThrowReferenceError .text.JS_ThrowReferenceErrorNotDefined .text.JS_ThrowReferenceErrorUninitialized .text.JS_ThrowReferenceErrorUninitialized2$isra$0 .text.JS_ThrowStackOverflow .text.JS_ThrowSyntaxError .text.JS_ThrowSyntaxErrorAtom$isra$0 .text.JS_ThrowTypeError .text.JS_ThrowTypeErrorArrayBufferOOB .text.JS_ThrowTypeErrorAtom .text.JS_ThrowTypeErrorDetachedArrayBuffer .text.JS_ThrowTypeErrorImmutableArrayBuffer .text.JS_ThrowTypeErrorInvalidClass .text.JS_ThrowTypeErrorNotAConstructor .text.JS_ThrowTypeErrorNotAFunction .text.JS_ThrowTypeErrorNotASymbol .text.JS_ThrowTypeErrorNotAnObject .text.JS_ThrowTypeErrorOrFalse .text.JS_ThrowTypeErrorReadOnly .text.JS_ThrowTypeErrorRevokedProxy .text.JS_ToArrayLengthFree .text.JS_ToBigInt64 .text.JS_ToBigInt64Free .text.JS_ToBigIntFree .text.JS_ToBigUint64 .text.JS_ToBool .text.JS_ToBoolFree .text.JS_ToCString .text.JS_ToCStringLen2 .text.JS_ToCStringLenUTF16 .text.JS_ToIndex .text.JS_ToInt32 .text.JS_ToInt32Clamp$constprop$0 .text.JS_ToInt32Sat .text.JS_ToInt32SatFree .text.JS_ToInt64 .text.JS_ToInt64Ext .text.JS_ToInt64Free .text.JS_ToInt64Sat .text.JS_ToInt64SatFree .text.JS_ToIntegerFree .text.JS_ToNumber .text.JS_ToNumberFree .text.JS_ToNumberHintFree .text.JS_ToObject .text.JS_ToObjectString .text.JS_ToPrimitive .text.JS_ToPrimitiveFree .text.JS_ToPropertyKey .text.JS_ToQuotedString .text.JS_ToStringCheckObject .text.JS_ToStringInternal .text.JS_ToUint8ClampFree .text.JS_TryGetPropertyInt64 .text.JS_UpdateStackTop .text.JS_VMCall .text.JS_VMCallJob .text.JS_VMClearYield .text.JS_VMDiscard .text.JS_VMEval .text.JS_VMRequestYield .text.JS_VMResume .text.JS_VMStackCompact .text.JS_VMStackPin .text.JS_VMStackRelocFault .text.JS_VMStackRelocKeepOld .text.JS_VMStackRelocate .text.JS_VMStackSegments .text.JS_VMStackTrim .text.JS_VMSuspended .text.JS_VMSuspendedOrigin .text.JS_VMTerminate .text.JS_ValueToAtom .text.JS_ValueToAtomInternal .text.JS_WriteObject .text.JS_WriteObject2 .text.JS_WriteObjectRec .text.JS_WriteString .text.__JS_AtomToValue .text.__JS_EvalInternal .text.__JS_FindAtom$constprop$0 .text.__JS_NewAtom .text.__js_poll_interrupts .text.add_arg .text.add_arguments_var .text.add_closure_var .text.add_eval_variables .text.add_export_entry .text.add_export_entry2 .text.add_fast_array_element .text.add_func_var .text.add_global_var .text.add_import .text.add_pc2line_info .text.add_private_class_field$isra$0 .text.add_reloc .text.add_req_module_entry .text.add_scope_var .text.add_var .text.add_var_this .text.async_func_free .text.async_func_init .text.async_func_mark .text.async_func_resume .text.bc_atom_to_idx .text.bc_csum .text.bc_get_atom .text.bc_get_buf .text.bc_get_leb128 .text.bc_get_leb128_u16 .text.bc_get_u8 .text.bc_idx_to_atom .text.bc_put_atom$isra$0 .text.bc_read_error_end$isra$0 .text.bswap32 .text.bswap64 .text.build_arg_list .text.build_backtrace .text.build_for_in_iterator .text.call_setter .text.can_opt_put_ref_value .text.capture_var .text.check_define_prop_flags .text.check_function .text.check_regexp_g_flag .text.close_scopes .text.close_var_ref .text.close_var_refs .text.code_has_label .text.code_match .text.compact_properties$isra$0 .text.compute_jsstring_size .text.compute_value_size .text.convert_fast_array_to_array .text.copy_str16$constprop$0 .text.cpool_add .text.dataview_is_oob .text.days_from_year .text.dbuf_claim .text.dbuf_default_realloc .text.dbuf_free .text.dbuf_printf .text.dbuf_put .text.dbuf_put_leb128 .text.dbuf_put_u16$isra$0 .text.dbuf_put_u32$isra$0 .text.dbuf_putc$isra$0 .text.define_var .text.delete_finrec_weakref .text.delete_map_weak_ref .text.delete_property .text.delete_property0 .text.emit_atom .text.emit_class_field_init .text.emit_class_init_end .text.emit_class_init_start .text.emit_goto .text.emit_label$isra$0 .text.emit_op$isra$0 .text.emit_push_const .text.emit_return .text.emit_source_loc .text.emit_u16$isra$0 .text.emit_u32$isra$0 .text.emit_u8$isra$0 .text.encodeURI_hex$isra$0 .text.exchange_bytes .text.exchange_func .text.exchange_int128s .text.exchange_int16s .text.exchange_int32s .text.exchange_int64s .text.exchange_one_byte .text.exchange_one_int128 .text.exchange_one_int16 .text.exchange_one_int32 .text.exchange_one_int64 .text.exec_module_list_cmp .text.exported_names_cmp .text.fa_compact_vars .text.fa_cpool .text.fa_var_ref_slot .text.fa_vardefs .text.find_atom .text.find_global_var .text.find_jump_target .text.find_lexical_decl$isra$0 .text.find_line_num$isra$0 .text.find_own_property1$isra$0 .text.find_private_class_field$isra$0 .text.find_var$isra$0 .text.free_arg_list .text.free_bytecode_atoms .text.free_generator_stack_rt .text.free_token .text.free_var_ref .text.from_hex .text.fromfp16 .text.fulfill_or_reject_promise .text.gather_available_ancestors .text.gc_decref_child .text.gc_scan_incref_child .text.gc_scan_incref_child2 .text.getTimezoneOffset .text.get_closure_var .text.get_date_field .text.get_date_fields .text.get_date_string .text.get_exported_names .text.get_first_weak_ref .text.get_func_name .text.get_leb128 .text.get_loc_or_ref .text.get_lvalue .text.get_prev_opcode .text.get_proxy_method .text.get_sleb128 .text.get_typed_array .text.get_u64 .text.get_var_ref .text.has_with_scope .text.hash_string .text.hash_string_rope .text.hex_decode .text.ident_realloc .text.init_class_range .text.internalize_json_property .text.is_let .text.is_num_string .text.is_strict_mode$isra$0 .text.is_valid_raw_json_char .text.is_valid_weakref_target .text.is_var_in_arg_scope .text.js_Date_UTC .text.js_Date_now .text.js_Date_parse .text.js_TA_cmp_float16 .text.js_TA_cmp_float32 .text.js_TA_cmp_float64 .text.js_TA_cmp_generic .text.js_TA_cmp_int16 .text.js_TA_cmp_int32 .text.js_TA_cmp_int64 .text.js_TA_cmp_int8 .text.js_TA_cmp_uint16 .text.js_TA_cmp_uint32 .text.js_TA_cmp_uint64 .text.js_TA_cmp_uint8 .text.js_TA_get_float16 .text.js_TA_get_float32 .text.js_TA_get_float64 .text.js_TA_get_int16 .text.js_TA_get_int32 .text.js_TA_get_int64 .text.js_TA_get_int8 .text.js_TA_get_uint16 .text.js_TA_get_uint32 .text.js_TA_get_uint64 .text.js_TA_get_uint8 .text.js__atomics_init .text.js__gettimeofday_us .text.js__hrtime_ns .text.js__malloc_usable_size .text.js__pstrcat$isra$0 .text.js_add_slow .text.js_aggregate_error_constructor .text.js_alloc_function_bytecode .text.js_append_enumerate .text.js_arguments_define_own_property .text.js_array_at .text.js_array_buffer_constructor .text.js_array_buffer_constructor0 .text.js_array_buffer_constructor2 .text.js_array_buffer_constructor3 .text.js_array_buffer_finalizer .text.js_array_buffer_free .text.js_array_buffer_get_byteLength .text.js_array_buffer_get_detached .text.js_array_buffer_get_immutable .text.js_array_buffer_get_maxByteLength .text.js_array_buffer_get_resizable .text.js_array_buffer_isView .text.js_array_buffer_resize .text.js_array_buffer_slice .text.js_array_buffer_transfer .text.js_array_buffer_update_typed_arrays .text.js_array_cmp_generic .text.js_array_concat .text.js_array_constructor .text.js_array_copyWithin .text.js_array_every .text.js_array_fill .text.js_array_find .text.js_array_flatten .text.js_array_from .text.js_array_fromAsync .text.js_array_includes .text.js_array_indexOf .text.js_array_isArray .text.js_array_iterator_finalizer .text.js_array_iterator_mark .text.js_array_iterator_next .text.js_array_join .text.js_array_lastIndexOf .text.js_array_mark .text.js_array_of .text.js_array_pop .text.js_array_push .text.js_array_reduce .text.js_array_reverse .text.js_array_slice .text.js_array_sort .text.js_array_toReversed .text.js_array_toSorted .text.js_array_toSpliced .text.js_array_toString .text.js_array_with .text.js_async_from_sync_iterator_close .text.js_async_from_sync_iterator_finalizer .text.js_async_from_sync_iterator_mark .text.js_async_from_sync_iterator_next .text.js_async_from_sync_iterator_unwrap .text.js_async_function_call .text.js_async_function_free .text.js_async_function_resolve_call .text.js_async_function_resolve_finalizer .text.js_async_function_resolve_mark .text.js_async_function_resume .text.js_async_function_settle_core .text.js_async_generator_complete .text.js_async_generator_finalizer .text.js_async_generator_free .text.js_async_generator_function_call .text.js_async_generator_mark .text.js_async_generator_next .text.js_async_generator_resolve .text.js_async_generator_resolve_function .text.js_async_generator_resolve_function_create .text.js_async_generator_resolve_or_reject$isra$0 .text.js_async_generator_resume_next .text.js_async_module_execution_fulfilled .text.js_async_module_execution_rejected .text.js_atof .text.js_atom_concat_str .text.js_atomics_get_buf .text.js_atomics_isLockFree .text.js_atomics_notify .text.js_atomics_op .text.js_atomics_pause .text.js_atomics_store .text.js_atomics_wait .text.js_bigint_add .text.js_bigint_asUintN .text.js_bigint_cmp$isra$0 .text.js_bigint_constructor .text.js_bigint_divrem .text.js_bigint_extend .text.js_bigint_float64_cmp$isra$0 .text.js_bigint_get_mant_exp$isra$0 .text.js_bigint_mul .text.js_bigint_neg .text.js_bigint_new .text.js_bigint_new_di .text.js_bigint_new_si .text.js_bigint_normalize .text.js_bigint_normalize1 .text.js_bigint_not .text.js_bigint_shl .text.js_bigint_sign .text.js_bigint_toString .text.js_bigint_to_string1 .text.js_bigint_valueOf .text.js_binary_arith_slow .text.js_binary_logic_slow .text.js_boolean_constructor .text.js_boolean_toString .text.js_boolean_valueOf .text.js_bound_function_finalizer .text.js_bound_function_mark .text.js_build_mapped_arguments .text.js_bytecode_function_finalizer .text.js_bytecode_function_mark .text.js_c_closure_finalizer .text.js_c_function_data_finalizer .text.js_c_function_data_mark .text.js_c_function_finalizer .text.js_c_function_mark .text.js_call_bound_function .text.js_call_c_closure .text.js_call_c_function .text.js_call_c_function_data .text.js_call_generator_function .text.js_call_math_fast .text.js_calloc .text.js_calloc_rt .text.js_callsite_finalizer .text.js_callsite_getfield .text.js_callsite_getnumber .text.js_callsite_isnative .text.js_callsite_mark .text.js_class_has_bytecode .text.js_clone_shape .text.js_closure .text.js_closure2 .text.js_cmp_doubles .text.js_compare_bigint .text.js_compile_regexp .text.js_coro_owner .text.js_coro_release .text.js_create_array .text.js_create_array_iterator .text.js_create_async_from_sync_iterator .text.js_create_from_ctor .text.js_create_function .text.js_create_iterator_helper .text.js_create_iterator_result .text.js_create_map_iterator .text.js_create_module_function .text.js_create_module_var .text.js_create_resolving_functions .text.js_create_typed_array_iterator .text.js_dataview_constructor .text.js_dataview_getValue .text.js_dataview_get_buffer .text.js_dataview_get_byteLength .text.js_dataview_get_byteOffset .text.js_dataview_setValue .text.js_date_Symbol_toPrimitive .text.js_date_constructor .text.js_date_getTime .text.js_date_getTimezoneOffset .text.js_date_setTime .text.js_date_setYear .text.js_date_toJSON .text.js_dbuf_init .text.js_dbuf_realloc .text.js_def_calloc .text.js_def_free .text.js_def_malloc .text.js_def_realloc .text.js_define_var .text.js_domexception_constructor .text.js_domexception_constructor0$isra$0 .text.js_domexception_finalizer .text.js_domexception_get_code .text.js_domexception_getfield .text.js_domexception_mark .text.js_dtoa2 .text.js_dynamic_import .text.js_dynamic_import_job .text.js_emit_spread_code .text.js_empty_string$isra$0 .text.js_eq_slow .text.js_error_capture_stack_trace .text.js_error_constructor .text.js_error_get_prepareStackTrace .text.js_error_get_stackTraceLimit .text.js_error_isError .text.js_error_set_prepareStackTrace .text.js_error_set_stackTraceLimit .text.js_error_toString .text.js_execute_async_module$isra$0 .text.js_execute_sync_module .text.js_fa_await .text.js_fa_continue .text.js_fa_finish .text.js_fa_get_method .text.js_fa_run .text.js_fa_set .text.js_find_loaded_module .text.js_finrec_constructor .text.js_finrec_finalizer .text.js_finrec_free .text.js_finrec_job .text.js_finrec_mark .text.js_finrec_register .text.js_finrec_unregister .text.js_for_in_iterator_finalizer .text.js_for_in_iterator_mark .text.js_for_of_start .text.js_force_tostring .text.js_free .text.js_free_cstring .text.js_free_desc .text.js_free_function_bytecode_allocation .text.js_free_function_def .text.js_free_module_def .text.js_free_modules .text.js_free_prop_enum .text.js_free_shape_null .text.js_free_string .text.js_function_apply .text.js_function_bind .text.js_function_call .text.js_function_constructor .text.js_function_hasInstance .text.js_function_proto_fileName .text.js_function_proto_int32 .text.js_function_set_properties .text.js_function_toString .text.js_generator_finalizer .text.js_generator_mark .text.js_generator_next .text.js_get_array_buffer .text.js_get_atom_index .text.js_get_fast_array$isra$0 .text.js_get_function_name .text.js_get_length32 .text.js_get_proxy_field .text.js_get_radix .text.js_get_regexp .text.js_get_this .text.js_global_decodeURI .text.js_global_encodeURI .text.js_global_escape .text.js_global_eval .text.js_global_isFinite .text.js_global_isNaN .text.js_global_queueMicrotask .text.js_global_unescape .text.js_harden_lock .text.js_harden_lock_value .text.js_harden_proto_change .text.js_harden_strip .text.js_host_resolve_imported_module .text.js_host_resolve_imported_module_atom .text.js_inner_module_evaluation .text.js_inner_module_linking .text.js_instantiate_prototype .text.js_int64 .text.js_is_array .text.js_is_live_code$isra$0 .text.js_is_regexp .text.js_iterator_concat .text.js_iterator_concat_finalizer .text.js_iterator_concat_mark .text.js_iterator_concat_next .text.js_iterator_concat_return .text.js_iterator_constructor .text.js_iterator_constructor_getset .text.js_iterator_from .text.js_iterator_helper_finalizer .text.js_iterator_helper_mark .text.js_iterator_helper_next .text.js_iterator_proto_func .text.js_iterator_proto_get_toStringTag .text.js_iterator_proto_iterator .text.js_iterator_proto_reduce .text.js_iterator_proto_set_toStringTag .text.js_iterator_proto_toArray .text.js_iterator_wrap_finalizer .text.js_iterator_wrap_mark .text.js_iterator_wrap_next .text.js_iterator_zip .text.js_iterator_zip_free .text.js_json_check .text.js_json_isRawJSON .text.js_json_parse .text.js_json_rawJSON .text.js_json_stringify .text.js_json_to_str$isra$0 .text.js_lazy_all .text.js_lazy_atom .text.js_lazy_bind .text.js_lazy_class_ensure .text.js_lazy_group .text.js_lazy_make .text.js_lazy_touch$isra$0 .text.js_load_module_fulfilled .text.js_load_module_rejected .text.js_malloc_usable_size_unknown .text.js_mallocz .text.js_mallocz_rt .text.js_map_clear .text.js_map_constructor .text.js_map_delete .text.js_map_finalizer .text.js_map_forEach .text.js_map_get .text.js_map_getOrInsert .text.js_map_get_size .text.js_map_groupBy .text.js_map_has .text.js_map_iterator_finalizer .text.js_map_iterator_mark .text.js_map_iterator_next .text.js_map_mark .text.js_map_read .text.js_map_set .text.js_map_write .text.js_mapped_arguments_finalizer .text.js_mapped_arguments_mark .text.js_math_acos .text.js_math_acosh .text.js_math_asin .text.js_math_asinh .text.js_math_atan .text.js_math_atan2 .text.js_math_atanh .text.js_math_cbrt .text.js_math_ceil .text.js_math_clz32 .text.js_math_cos .text.js_math_cosh .text.js_math_exp .text.js_math_expm1 .text.js_math_f16round .text.js_math_fabs .text.js_math_floor .text.js_math_fround .text.js_math_hypot .text.js_math_imul .text.js_math_log .text.js_math_log10 .text.js_math_log1p .text.js_math_log2 .text.js_math_min_max .text.js_math_pow .text.js_math_random .text.js_math_round .text.js_math_sign .text.js_math_sinh .text.js_math_sqrt .text.js_math_sumPrecise .text.js_math_tan .text.js_math_tanh .text.js_math_trunc .text.js_method_set_home_object .text.js_microtask_job .text.js_module_ns_autoinit .text.js_module_ns_has .text.js_mp_neg$isra$0 .text.js_mp_shl .text.js_mp_shr$isra$0 .text.js_mp_sub$constprop$0$isra$0 .text.js_mutex_unlock$constprop$0 .text.js_new_function_def .text.js_new_module_def .text.js_new_promise_capability .text.js_new_shape2$constprop$0 .text.js_new_shape_nohash .text.js_new_shape_with .text.js_new_string16_len .text.js_new_string8 .text.js_new_string_char .text.js_new_string_rope .text.js_new_uint8array .text.js_not_slow .text.js_number_constructor .text.js_number_isFinite .text.js_number_isInteger .text.js_number_isNaN .text.js_number_isSafeInteger .text.js_number_toExponential .text.js_number_toFixed .text.js_number_toPrecision .text.js_number_toString .text.js_number_valueOf .text.js_obj_to_desc .text.js_object___defineGetter__ .text.js_object___lookupGetter__ .text.js_object_assign .text.js_object_constructor .text.js_object_create .text.js_object_data_finalizer .text.js_object_data_mark .text.js_object_defineProperties .text.js_object_defineProperty .text.js_object_fromEntries .text.js_object_getOwnPropertyDescriptor .text.js_object_getOwnPropertyDescriptors .text.js_object_getOwnPropertyNames .text.js_object_getOwnPropertySymbols .text.js_object_getPrototypeOf .text.js_object_get___proto__ .text.js_object_groupBy .text.js_object_hasOwn .text.js_object_hasOwnProperty .text.js_object_has_name$isra$0 .text.js_object_is .text.js_object_isExtensible .text.js_object_isPrototypeOf .text.js_object_isSealed .text.js_object_keys .text.js_object_preventExtensions .text.js_object_propertyIsEnumerable .text.js_object_seal .text.js_object_setPrototypeOf .text.js_object_set___proto__ .text.js_object_toLocaleString .text.js_object_toString .text.js_object_valueOf .text.js_oom_canary_record .text.js_op_define_class .text.js_operator_typeof .text.js_parseFloat .text.js_parseInt .text.js_parse_assign_expr .text.js_parse_assign_expr2 .text.js_parse_block .text.js_parse_check_duplicate_parameter .text.js_parse_class .text.js_parse_destructuring_element .text.js_parse_destructuring_var$isra$0 .text.js_parse_directives$part$0 .text.js_parse_error .text.js_parse_error_reserved_identifier$isra$0 .text.js_parse_expect .text.js_parse_expect_semi .text.js_parse_expr .text.js_parse_expr2 .text.js_parse_expr_binary .text.js_parse_expr_paren .text.js_parse_from_clause .text.js_parse_function_check_names .text.js_parse_function_decl$constprop$0$isra$0 .text.js_parse_function_decl2$constprop$0 .text.js_parse_logical_and_or .text.js_parse_postfix_expr .text.js_parse_property_name .text.js_parse_regexp .text.js_parse_skip_parens_token .text.js_parse_source_element .text.js_parse_statement_or_decl .text.js_parse_string .text.js_parse_template .text.js_parse_template_part .text.js_parse_unary .text.js_parse_var .text.js_parse_with_clause .text.js_perf_now .text.js_post_inc_slow .text.js_promise_all .text.js_promise_all_resolve_element .text.js_promise_catch .text.js_promise_constructor .text.js_promise_executor .text.js_promise_finalizer .text.js_promise_finally .text.js_promise_finally_thrower .text.js_promise_finally_value_thunk .text.js_promise_mark .text.js_promise_new .text.js_promise_race .text.js_promise_resolve .text.js_promise_resolve_function_call .text.js_promise_resolve_function_finalizer .text.js_promise_resolve_function_mark .text.js_promise_resolve_thenable_job .text.js_promise_then .text.js_promise_then_finally_func .text.js_promise_thenable_tail .text.js_promise_try .text.js_promise_withResolvers .text.js_proxy_call .text.js_proxy_constructor .text.js_proxy_define_own_property .text.js_proxy_delete_property .text.js_proxy_finalizer .text.js_proxy_get .text.js_proxy_get_own_property .text.js_proxy_get_own_property_names .text.js_proxy_has .text.js_proxy_mark .text.js_proxy_revocable .text.js_proxy_revoke .text.js_proxy_set .text.js_realloc_array .text.js_rebalance_string_rope .text.js_rebalance_string_rope_rec .text.js_reflect_apply .text.js_reflect_construct .text.js_reflect_deleteProperty .text.js_reflect_get .text.js_reflect_has .text.js_reflect_ownKeys .text.js_reflect_set .text.js_reflect_setPrototypeOf .text.js_regexp_Symbol_match .text.js_regexp_Symbol_matchAll .text.js_regexp_Symbol_replace .text.js_regexp_Symbol_search .text.js_regexp_Symbol_split .text.js_regexp_compile .text.js_regexp_constructor .text.js_regexp_constructor_internal .text.js_regexp_escape .text.js_regexp_exec .text.js_regexp_finalizer .text.js_regexp_get_flag .text.js_regexp_get_flags .text.js_regexp_get_source .text.js_regexp_string_iterator_finalizer .text.js_regexp_string_iterator_mark .text.js_regexp_string_iterator_next .text.js_regexp_test .text.js_regexp_toString .text.js_relational_slow .text.js_resize_array .text.js_resolve_export .text.js_resolve_export1 .text.js_resolve_export_throw_error .text.js_resolve_module .text.js_rom_find .text.js_rom_new_string .text.js_same_value$isra$0 .text.js_set_difference .text.js_set_intersection .text.js_set_isDisjointFrom .text.js_set_isSubsetOf .text.js_set_isSupersetOf .text.js_set_module_evaluated .text.js_set_symmetricDifference .text.js_set_union .text.js_setlike_get_props .text.js_shape_prepare_update .text.js_shared_array_buffer_constructor .text.js_shr_slow .text.js_std_cmd .text.js_strdup .text.js_strict_eq2$isra$0 .text.js_strict_eq_slow .text.js_string_CreateHTML .text.js_string___GetSubstitution$constprop$0 .text.js_string_at .text.js_string_charAt .text.js_string_charCodeAt .text.js_string_codePointAt .text.js_string_codePointRange .text.js_string_compare .text.js_string_concat .text.js_string_constructor .text.js_string_define_own_property .text.js_string_delete_property .text.js_string_eq .text.js_string_fromCharCode .text.js_string_fromCodePoint .text.js_string_get_own_property .text.js_string_includes .text.js_string_indexOf .text.js_string_isWellFormed .text.js_string_iterator_next .text.js_string_localeCompare .text.js_string_match .text.js_string_memcmp .text.js_string_normalize .text.js_string_pad .text.js_string_raw .text.js_string_repeat .text.js_string_replace .text.js_string_rope_compare .text.js_string_slice .text.js_string_split .text.js_string_substr .text.js_string_substring .text.js_string_toLowerCase .text.js_string_toString .text.js_string_toWellFormed .text.js_string_trim .text.js_strndup .text.js_sub_string .text.js_symbol_constructor .text.js_symbol_for .text.js_symbol_get_description .text.js_symbol_keyFor .text.js_symbol_toString .text.js_symbol_valueOf .text.js_thisBigIntValue .text.js_thisBooleanValue .text.js_thisNumberValue .text.js_thisSymbolValue .text.js_throw_URIError .text.js_throw_harden .text.js_throw_type_error .text.js_to_digit .text.js_typed_array___speciesCreate$constprop$0 .text.js_typed_array_at .text.js_typed_array_base_constructor .text.js_typed_array_constructor .text.js_typed_array_constructor_ta .text.js_typed_array_copyWithin .text.js_typed_array_create .text.js_typed_array_fill .text.js_typed_array_finalizer .text.js_typed_array_find .text.js_typed_array_from .text.js_typed_array_get_buffer .text.js_typed_array_get_byteLength .text.js_typed_array_get_byteOffset .text.js_typed_array_get_length .text.js_typed_array_get_length_unsafe .text.js_typed_array_get_toStringTag .text.js_typed_array_indexOf .text.js_typed_array_join .text.js_typed_array_mark .text.js_typed_array_of .text.js_typed_array_reverse .text.js_typed_array_set .text.js_typed_array_slice .text.js_typed_array_sort .text.js_typed_array_subarray .text.js_typed_array_toReversed .text.js_typed_array_toSorted .text.js_typed_array_with .text.js_uint32 .text.js_unary_arith_slow .text.js_update_property_flags .text.js_vm_arm .text.js_vm_flat_callable$isra$0 .text.js_vm_flat_caller_sp .text.js_vm_frame_func .text.js_vm_push_yield .text.js_vm_release_job .text.js_vm_seg_new$isra$0 .text.js_vm_stack_get .text.js_vm_stack_pop .text.js_vm_stack_push .text.js_vm_state .text.js_weakref_constructor .text.js_weakref_deref .text.js_weakref_finalizer .text.js_write_fail_throws .text.js_zip_close_all .text.js_zip_flatten .text.js_zip_iter_step .text.json_free_parse_record .text.json_next_token .text.json_parse_error$isra$0 .text.json_parse_record_add .text.json_parse_value .text.lazy_define .text.lazy_key .text.lazy_list_of .text.lazy_owner .text.lazy_remove .text.lazy_set_done .text.lazy_undo_done .text.lre_check_stack_overflow .text.lre_check_timeout .text.lre_js_is_ident_first .text.lre_js_is_ident_next .text.lre_realloc .text.map_add_record .text.map_decref_record .text.map_delete_record .text.map_find_record$isra$0 .text.map_hash_key$isra$0 .text.map_normalize_key$isra$0 .text.mark_children .text.memcmp16_8 .text.new_label .text.new_label_fd .text.next_token .text.num_keys_cmp .text.optimize_scope_make_ref$isra$0 .text.optional_chain_test .text.parse_ident .text.peek_token$isra$0 .text.perform_promise_then .text.pop_scope .text.promise_reaction_data_free .text.promise_reaction_job .text.promise_reaction_tail .text.push_scope .text.push_short_int .text.put_lvalue .text.put_short_code .text.put_u32 .text.remainingElementsCount_add .text.reset_weak_ref .text.resize_properties .text.resolve_pseudo_var .text.resolve_scope_private_field1 .text.resolve_scope_var .text.resolve_variables .text.rqsort .text.seal_template_obj$isra$0 .text.set_array_length .text.set_date_field .text.set_date_fields .text.set_eval_ret_undefined .text.set_object_name .text.set_object_name_computed .text.skip_dead_code .text.skip_spaces .text.ss_check .text.string_advance_index .text.string_buffer_concat .text.string_buffer_concat_value .text.string_buffer_concat_value_free .text.string_buffer_end .text.string_buffer_free .text.string_buffer_init .text.string_buffer_putc .text.string_buffer_putc16_slow .text.string_buffer_putc8 .text.string_buffer_putc_slow .text.string_buffer_puts8$isra$0 .text.string_buffer_realloc .text.string_buffer_set_error$isra$0 .text.string_buffer_widen .text.string_buffer_write8 .text.string_cmp .text.string_get .text.string_get_digits .text.string_get_hex .text.string_get_milliseconds$isra$0 .text.string_get_tzoffset .text.string_getc .text.string_indexof .text.string_indexof_char .text.string_match .text.string_rope_iter_next .text.tag_is_number .text.tdz_walk .text.time_clip .text.to_utf32_buf .text.tofp16 .text.token_is_ident .text.token_is_pseudo_keyword .text.typed_array_init .text.typed_array_is_immutable .text.typed_array_is_oob .text.update_label .text.update_token_ident$constprop$0 .text.utf8_decode .text.utf8_decode_len .text.utf8_encode .text.utf8_encode_buf8$constprop$0$isra$0 .text.validate_typed_array .text.value_buffer_free .text.var_object_test)
 *libspi_flash.a:esp_flash_api.*(.literal.esp_flash_app_disable_protect .literal.esp_flash_get_protectable_regions .literal.esp_flash_read_chip_id .literal.esp_flash_read_id .literal.esp_flash_read_unique_chip_id .literal.esp_flash_suspend_cmd_init .literal.find_region .text .text.esp_flash_app_disable_protect .text.esp_flash_get_protectable_regions .text.esp_flash_read_chip_id .text.esp_flash_read_id .text.esp_flash_read_unique_chip_id .text.esp_flash_suspend_cmd_init .text.find_region)
 *libspi_flash.a:spi_flash_os_func_app.*(.literal.esp_flash_app_enable_os_functions .literal.esp_flash_deinit_os_functions .literal.esp_flash_init_os_functions .text .text.esp_flash_app_enable_os_functions .text.esp_flash_deinit_os_functions .text.esp_flash_init_main_bus_lock .text.esp_flash_init_os_functions .text.esp_flash_set_dangerous_write_protection .text.use_bus_lock)
 *libspi_flash.a:spi_flash_os_func_noos.*(.text)
 *libxtensa.a:xt_trax.*(.literal .literal.* .text .text.*)
 *libxtensa.a:xtensa_intr.*(.literal .literal.* .text .text.*)
 mutable[flash_text]
    *(.stub)
    *(.gnu.warning)
    *(.gnu.linkonce.literal.* .gnu.linkonce.t.*.literal .gnu.linkonce.t.*)
    *(.irom0.text) /* catch stray ICACHE_RODATA_ATTR */
    /**
     * CPU will try to prefetch up to 16 bytes of of instructions.
     * This means that any configuration (e.g. MMU, PMS) must allow
     * safe access to up to 16 bytes after the last real instruction, add
     * dummy bytes to ensure this
     */
    . += 16;
    _text_end = ABSOLUTE(.);
    /**
     * Mark the flash.text end.
     * This can be used for MMU driver to maintain virtual address.
     */
    _instruction_reserved_end = ABSOLUTE(.);
    _etext = .;
    /**
     * Similar to _iram_start, this symbol goes here so it is
     * resolved by addr2line in preference to the first symbol in
     * the flash.text segment.
     */
    _flash_cache_start = ABSOLUTE(0);
  } > default_code_seg
  /**
   * Dummy section represents the .flash.text section but in default_rodata_seg.
   * Thus, it must have its alignment and (at least) its size.
   */
  .flash_rodata_dummy (NOLOAD):
  {
    _flash_rodata_dummy_start = ABSOLUTE(.);
    . = ALIGN(ALIGNOF(.flash.text)) + SIZEOF(.flash.text);
    /* Add alignment of MMU page size + 0x20 bytes for the mapping header. */
    . = ALIGN(0x10000) + 0x20;
  } > default_rodata_seg
  .flash.appdesc : ALIGN(0x10)
  {
    /**
     * Mark flash.rodata start.
     * This can be used for mmu driver to maintain virtual address
     */
    _rodata_reserved_start = ABSOLUTE(.);
    _rodata_start = ABSOLUTE(.);
    /* !DO NOT PUT ANYTHING BEFORE THIS! */
    /* Should be the first.  App version info. */
    *(.rodata_desc .rodata_desc.*)
    /* Should be the second. Custom app version info. */
    *(.rodata_custom_desc .rodata_custom_desc.*)
    /**
     * Create an empty gap within this section. Thanks to this, the end of this
     * section will match .flah.rodata's begin address. Thus, both sections
     * will be merged when creating the final bin image.
     */
    . = ALIGN(ALIGNOF(.flash.rodata));
  } > default_rodata_seg
  ASSERT((ADDR(.flash.rodata) == ADDR(.flash.appdesc) + SIZEOF(.flash.appdesc)), "The gap between .flash.appdesc and .flash.rodata must not exist to produce the final bin image.")
  .flash.rodata : ALIGN(0x10)
  {
    _flash_rodata_start = ABSOLUTE(.);
    
 *(EXCLUDE_FILE(*libgcov.a *libphy.a *libclang_rt.builtins.a:_divsf3.* *libesp_driver_dma.a:gdma_link.* *libesp_driver_rmt.a:rmt_tx.* *libesp_hal_gpspi.a:spi_hal_iram.* *libesp_hal_gpspi.a:spi_slave_hal_iram.* *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.* *libesp_hal_mspi.a:spi_flash_hal_gpspi.* *libesp_hal_mspi.a:spi_flash_hal_iram.* *libesp_hal_wdt.a:rom_patch.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:systimer.* *libesp_libc.a:abort.* *libesp_libc.a:assert.* *libesp_libc.a:heap.* *libesp_libc.a:stdatomic.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_rom.a:esp_rom_systimer.* *libesp_system.a:esp_err.* *libesp_system.a:image_process.* *libesp_system.a:reset_reason.* *libesp_system.a:ubsan.* *libgcc.a:_divsf3.* *libhal.a:cache_hal.* *libhal.a:mmu_hal.* *libhal.a:systimer_hal.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp_common.* *liblog.a:util.* *libsoc.a:lldesc.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_wrap.*) .rodata EXCLUDE_FILE(*libgcov.a *libphy.a *libclang_rt.builtins.a:_divsf3.* *libesp_driver_dma.a:gdma_link.* *libesp_driver_rmt.a:rmt_tx.* *libesp_hal_gpspi.a:spi_hal_iram.* *libesp_hal_gpspi.a:spi_slave_hal_iram.* *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.* *libesp_hal_mspi.a:spi_flash_hal_gpspi.* *libesp_hal_mspi.a:spi_flash_hal_iram.* *libesp_hal_wdt.a:rom_patch.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:systimer.* *libesp_libc.a:abort.* *libesp_libc.a:assert.* *libesp_libc.a:heap.* *libesp_libc.a:stdatomic.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_rom.a:esp_rom_systimer.* *libesp_system.a:esp_err.* *libesp_system.a:image_process.* *libesp_system.a:reset_reason.* *libesp_system.a:ubsan.* *libgcc.a:_divsf3.* *libhal.a:cache_hal.* *libhal.a:mmu_hal.* *libhal.a:systimer_hal.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp_common.* *liblog.a:util.* *libsoc.a:lldesc.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_wrap.*) .rodata.* EXCLUDE_FILE(*libgcov.a *libphy.a *libclang_rt.builtins.a:_divsf3.* *libesp_driver_dma.a:gdma_link.* *libesp_driver_rmt.a:rmt_tx.* *libesp_hal_gpspi.a:spi_hal_iram.* *libesp_hal_gpspi.a:spi_slave_hal_iram.* *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.* *libesp_hal_mspi.a:spi_flash_hal_gpspi.* *libesp_hal_mspi.a:spi_flash_hal_iram.* *libesp_hal_wdt.a:rom_patch.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:systimer.* *libesp_libc.a:abort.* *libesp_libc.a:assert.* *libesp_libc.a:heap.* *libesp_libc.a:stdatomic.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_rom.a:esp_rom_systimer.* *libesp_system.a:esp_err.* *libesp_system.a:image_process.* *libesp_system.a:reset_reason.* *libesp_system.a:ubsan.* *libgcc.a:_divsf3.* *libhal.a:cache_hal.* *libhal.a:mmu_hal.* *libhal.a:systimer_hal.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp_common.* *liblog.a:util.* *libsoc.a:lldesc.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_wrap.*) .sdata2 EXCLUDE_FILE(*libgcov.a *libphy.a *libclang_rt.builtins.a:_divsf3.* *libesp_driver_dma.a:gdma_link.* *libesp_driver_rmt.a:rmt_tx.* *libesp_hal_gpspi.a:spi_hal_iram.* *libesp_hal_gpspi.a:spi_slave_hal_iram.* *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.* *libesp_hal_mspi.a:spi_flash_hal_gpspi.* *libesp_hal_mspi.a:spi_flash_hal_iram.* *libesp_hal_wdt.a:rom_patch.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:systimer.* *libesp_libc.a:abort.* *libesp_libc.a:assert.* *libesp_libc.a:heap.* *libesp_libc.a:stdatomic.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_rom.a:esp_rom_systimer.* *libesp_system.a:esp_err.* *libesp_system.a:image_process.* *libesp_system.a:reset_reason.* *libesp_system.a:ubsan.* *libgcc.a:_divsf3.* *libhal.a:cache_hal.* *libhal.a:mmu_hal.* *libhal.a:systimer_hal.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp_common.* *liblog.a:util.* *libsoc.a:lldesc.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_wrap.*) .sdata2.* EXCLUDE_FILE(*libgcov.a *libphy.a *libclang_rt.builtins.a:_divsf3.* *libesp_driver_dma.a:gdma_link.* *libesp_driver_rmt.a:rmt_tx.* *libesp_hal_gpspi.a:spi_hal_iram.* *libesp_hal_gpspi.a:spi_slave_hal_iram.* *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.* *libesp_hal_mspi.a:spi_flash_hal_gpspi.* *libesp_hal_mspi.a:spi_flash_hal_iram.* *libesp_hal_wdt.a:rom_patch.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:systimer.* *libesp_libc.a:abort.* *libesp_libc.a:assert.* *libesp_libc.a:heap.* *libesp_libc.a:stdatomic.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_rom.a:esp_rom_systimer.* *libesp_system.a:esp_err.* *libesp_system.a:image_process.* *libesp_system.a:reset_reason.* *libesp_system.a:ubsan.* *libgcc.a:_divsf3.* *libhal.a:cache_hal.* *libhal.a:mmu_hal.* *libhal.a:systimer_hal.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp_common.* *liblog.a:util.* *libsoc.a:lldesc.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_wrap.*) .srodata EXCLUDE_FILE(*libgcov.a *libphy.a *libclang_rt.builtins.a:_divsf3.* *libesp_driver_dma.a:gdma_link.* *libesp_driver_rmt.a:rmt_tx.* *libesp_hal_gpspi.a:spi_hal_iram.* *libesp_hal_gpspi.a:spi_slave_hal_iram.* *libesp_hal_mspi.a:spi_flash_encrypt_hal_iram.* *libesp_hal_mspi.a:spi_flash_hal_gpspi.* *libesp_hal_mspi.a:spi_flash_hal_iram.* *libesp_hal_wdt.a:rom_patch.* *libesp_hw_support.a:clk_utils.* *libesp_hw_support.a:cpu.* *libesp_hw_support.a:esp_memory_utils.* *libesp_hw_support.a:mspi_timing_by_mspi_delay.* *libesp_hw_support.a:mspi_timing_config.* *libesp_hw_support.a:mspi_timing_tuning.* *libesp_hw_support.a:rtc_clk.* *libesp_hw_support.a:systimer.* *libesp_libc.a:abort.* *libesp_libc.a:assert.* *libesp_libc.a:heap.* *libesp_libc.a:stdatomic.* *libesp_mm.a:esp_cache_msync.* *libesp_mm.a:esp_cache_utils.* *libesp_rom.a:esp_rom_cache_esp32s2_esp32s3.* *libesp_rom.a:esp_rom_cache_writeback_esp32s3.* *libesp_rom.a:esp_rom_print.* *libesp_rom.a:esp_rom_spiflash.* *libesp_rom.a:esp_rom_sys.* *libesp_rom.a:esp_rom_systimer.* *libesp_system.a:esp_err.* *libesp_system.a:image_process.* *libesp_system.a:reset_reason.* *libesp_system.a:ubsan.* *libgcc.a:_divsf3.* *libhal.a:cache_hal.* *libhal.a:mmu_hal.* *libhal.a:systimer_hal.* *libheap.a:multi_heap.* *libheap.a:tlsf.* *liblog.a:log.* *liblog.a:log_format_text.* *liblog.a:log_lock.* *liblog.a:log_print.* *liblog.a:log_timestamp_common.* *liblog.a:util.* *libsoc.a:lldesc.* *libspi_flash.a:flash_brownout_hook.* *libspi_flash.a:memspi_host_driver.* *libspi_flash.a:spi_flash_chip_boya.* *libspi_flash.a:spi_flash_chip_gd.* *libspi_flash.a:spi_flash_chip_generic.* *libspi_flash.a:spi_flash_chip_issi.* *libspi_flash.a:spi_flash_chip_mxic.* *libspi_flash.a:spi_flash_chip_mxic_opi.* *libspi_flash.a:spi_flash_chip_th.* *libspi_flash.a:spi_flash_chip_winbond.* *libspi_flash.a:spi_flash_hpm_enable.* *libspi_flash.a:spi_flash_oct_flash_init.* *libspi_flash.a:spi_flash_os_func_app.* *libspi_flash.a:spi_flash_wrap.*) .srodata.*)
 *(.rodata_wlog_error .rodata_wlog_error.*)
 *(.rodata_wlog_info .rodata_wlog_info.*)
 *(.rodata_wlog_warning .rodata_wlog_warning.*)
 *libesp_driver_dma.a:gdma_link.*(.rodata.__FUNCTION__$0 .rodata.__FUNCTION__$1 .rodata.__FUNCTION__$2 .rodata.gdma_new_link_list.str1.1)
 *libesp_driver_rmt.a:rmt_tx.*(.rodata.__FUNCTION__$0 .rodata.__FUNCTION__$10 .rodata.__FUNCTION__$12 .rodata.__FUNCTION__$13 .rodata.__FUNCTION__$14 .rodata.__FUNCTION__$15 .rodata.__FUNCTION__$19 .rodata.__FUNCTION__$21 .rodata.__FUNCTION__$22 .rodata.__FUNCTION__$3 .rodata.__FUNCTION__$4 .rodata.__FUNCTION__$5 .rodata.__FUNCTION__$6 .rodata.__FUNCTION__$7 .rodata.__FUNCTION__$9 .rodata.__func__$1 .rodata.__func__$16 .rodata.__func__$17 .rodata.__func__$18 .rodata.__func__$2 .rodata.__func__$20 .rodata.__func__$8 .rodata.rmt_del_tx_channel.str1.1 .rodata.rmt_ll_tx_enable_dma$part$0.str1.1 .rodata.rmt_new_sync_manager.str1.1 .rodata.rmt_new_tx_channel.str1.1 .rodata.rmt_transmit.str1.1 .rodata.rmt_tx_destroy.str1.1 .rodata.rmt_tx_disable.str1.1 .rodata.rmt_tx_enable.str1.1 .rodata.rmt_tx_modulate_carrier.str1.1 .rodata.rmt_tx_register_event_callbacks.str1.1 .rodata.rmt_tx_switch_gpio.str1.1 .rodata.rmt_tx_wait_all_done.str1.1)
 *libesp_hw_support.a:cpu.*(.rodata.__func__$0 .rodata.__func__$1 .rodata.__func__$2)
 *libesp_system.a:reset_reason.*(.rodata.__func__$0)
 *libheap.a:multi_heap.*(.rodata.__func__$0 .rodata.__func__$1 .rodata.__func__$2 .rodata.__func__$3 .rodata.__func__$4 .rodata.__func__$5 .rodata.__func__$6 .rodata.__func__$7 .rodata.__func__$8 .rodata.multi_heap_dump.str1.1 .rodata.multi_heap_dump_tlsf.str1.1 .rodata.multi_heap_find_containing_block_impl.str1.1 .rodata.multi_heap_register_impl.str1.1)
 *libheap.a:tlsf.*(.rodata.__func__$1 .rodata.__func__$10 .rodata.__func__$11 .rodata.__func__$12 .rodata.__func__$13 .rodata.__func__$14 .rodata.__func__$15 .rodata.__func__$16 .rodata.__func__$17 .rodata.__func__$19 .rodata.__func__$2 .rodata.__func__$20 .rodata.__func__$3 .rodata.__func__$5 .rodata.__func__$6 .rodata.__func__$7 .rodata.__func__$8 .rodata.__func__$9 .rodata.default_walker.str1.1 .rodata.tlsf_add_pool.str1.1 .rodata.tlsf_check.str1.1 .rodata.tlsf_create.str1.1 .rodata.tlsf_remove_pool.str1.1)
 *libspi_flash.a:spi_flash_os_func_app.*(.rodata.__func__$0 .rodata.esp_flash_spi23_default_os_functions)
 mutable[flash_rodata]
    *(.irom1.text) /* catch stray ICACHE_RODATA_ATTR */
    *(.gnu.linkonce.r.*)
    *(.rodata1)
    /* C++ exception handlers table. */
    
 . = ALIGN(4); 
 __XT_EXCEPTION_TABLE_ = ABSOLUTE(.);
    *(.xt_except_table)
    *(.gcc_except_table .gcc_except_table.*)
    *(.gnu.linkonce.e.*)
    
 . = ALIGN(4); 
 __XT_EXCEPTION_DESCS_ = ABSOLUTE(.);
    *(.xt_except_desc)
    *(.gnu.linkonce.h.*)
    __XT_EXCEPTION_DESCS_END__ = ABSOLUTE(.);
    *(.xt_except_desc_end)
    /**
     * C++ constructor tables.
     *
     * Excluding crtbegin.o/crtend.o since IDF doesn't use the toolchain crt.
     */
    
 . = ALIGN(4); 
 __preinit_array_start = ABSOLUTE(.);
    
 . = ALIGN(4); 
 __bothinit_array_start = ABSOLUTE(.);
    KEEP (*(.preinit_array))
    __preinit_array_end = ABSOLUTE(.);
    
 . = ALIGN(4); 
 __init_array_start = ABSOLUTE(.);
    KEEP (*(SORT_BY_INIT_PRIORITY(EXCLUDE_FILE (*crtend.* *crtbegin.*) .ctors.*)))
    KEEP (*(EXCLUDE_FILE (*crtend.* *crtbegin.*) .ctors))
    __init_array_end = ABSOLUTE(.);
    __bothinit_array_end = ABSOLUTE(.);
    /* Addresses of memory regions reserved via SOC_RESERVE_MEMORY_REGION() */
    
 . = ALIGN(4); 
 soc_reserved_memory_region_start = ABSOLUTE(.);
    KEEP (*(.reserved_memory_address))
    soc_reserved_memory_region_end = ABSOLUTE(.);
    /* System init functions registered via ESP_SYSTEM_INIT_FN */
    
 . = ALIGN(4); 
 _esp_system_init_fn_array_start = ABSOLUTE(.);
    KEEP (*(SORT_BY_INIT_PRIORITY(.esp_system_init_fn.*)))
    _esp_system_init_fn_array_end = ABSOLUTE(.);
    _rodata_end = ABSOLUTE(.);
    /* Literals are also RO data. */
    _lit4_start = ABSOLUTE(.);
    *(*.lit4)
    *(.lit4.*)
    *(.gnu.linkonce.lit4.*)
    _lit4_end = ABSOLUTE(.);
    . = ALIGN(ALIGNOF(.flash.tdata));
  } > default_rodata_seg
  ASSERT((ADDR(.flash.tdata) == ADDR(.flash.rodata) + SIZEOF(.flash.rodata)), "The gap between .flash.rodata and .flash.tdata must not exist to produce the final bin image.")
  .flash.tdata :
  {
    /* Keep tdata and tbss sections contiguous (no gaps between them).
     * The TLS runtime code calculates offsets assuming these sections are
     * adjacent. Gaps would cause incorrect address calculations, leading
     * to accessing wrong memory.
     */
    /* tdata sections */
    _thread_local_data_start = ABSOLUTE(.);
    _picolibc_reent_stub_start = ABSOLUTE(.);
    KEEP(*(.tdata.errno))
    /* Reproduce the public fields from struct _reent. */
    KEEP(*(.tdata.tls_stdin))
    KEEP(*(.tdata.tls_stdout))
    KEEP(*(.tdata.tls_stderr))
    _picolibc_reent_stub_end = ABSOLUTE(.);
    *(.tdata .tdata.* .gnu.linkonce.td.*)
    _thread_local_data_end = ABSOLUTE(.);
    /* tbss sections */
    _thread_local_bss_start = ABSOLUTE(.);
    *(.tbss .tbss.* .gnu.linkonce.tb.*)
    *(.tcommon .tcommon.*)
    _thread_local_bss_end = ABSOLUTE(.);
  } > default_rodata_seg
  _tls_section_alignment = ALIGNOF(.flash.tdata);
  ASSERT((_picolibc_reent_stub_end - _picolibc_reent_stub_start) == 16, "Newlib _reent stub have wrong size")
  ASSERT(_thread_local_data_end == _thread_local_bss_start,
         "tdata and tbss must be contiguous.")
  /**
   * This section contains all the rodata that is not used
   * at runtime, helping to avoid an increase in binary size.
   */
  .flash.rodata_noload (NOLOAD) :
  {
    /**
     * This symbol marks the end of flash.rodata. It can be utilized by the MMU
     * driver to maintain the virtual address.
     * NOLOAD rodata may not be included in this section.
     */
    _rodata_reserved_end = ABSOLUTE(.);
    
 *(.rodata_wlog_debug .rodata_wlog_debug.*)
 *(.rodata_wlog_verbose .rodata_wlog_verbose.*)
 mutable[rodata_noload]
  } > default_rodata_seg
  /**
   * Dummy section to skip flash rodata sections.
   * Because to `extern_ram_seg` and `drom0_0_seg` are on the same bus
   */
  .ext_ram.dummy (NOLOAD):
  {
    . = ORIGIN(extern_ram_seg);
    . = . + (_rodata_reserved_end - _flash_rodata_dummy_start);
    . = ALIGN (0x10000);
  } > extern_ram_seg
  /* Marks the end of IRAM code segment */
  .iram0.text_end (NOLOAD) :
  {
    /* Padding for possible CPU prefetch + alignment for PMS split lines */
    . += 16;
    . = ALIGN(256);
    /* iram_end_test section exists for use by memprot unit tests only */
    *(.iram_end_test)
    _iram_text_end = ABSOLUTE(.);
  } > iram0_0_seg
  .iram0.data :
  {
    
 . = ALIGN(4); 
 _iram_data_start = ABSOLUTE(.);
    
 *(.iram.data .iram.data.*)
 mutable[iram0_data]
    
 . = ALIGN(4); 
 _iram_data_end = ABSOLUTE(.);
  } > iram0_0_seg
  .iram0.bss (NOLOAD) :
  {
    
 . = ALIGN(4); 
 _iram_bss_start = ABSOLUTE(.);
    
 *(.iram.bss .iram.bss.*)
 mutable[iram0_bss]
    _iram_bss_end = ABSOLUTE(.);
    
 . = ALIGN(4); 
 _iram_end = ABSOLUTE(.);
  } > iram0_0_seg
  /* Marks the end of data, bss and possibly rodata  */
  .dram0.heap_start (NOLOAD) :
  {
    /* Lowest possible start address for the heap */
    
 . = ALIGN(8); 
 _heap_low_start = ABSOLUTE(.);
  } > dram0_0_seg
/*
 * SPDX-FileCopyrightText: 2021-2024 Espressif Systems (Shanghai) CO LTD
 *
 * SPDX-License-Identifier: Apache-2.0
 */
/* CPU instruction prefetch padding size for flash mmap scenario */
/* Copy from esp_secure_boot.h */
/*
 * PMP region granularity size
 * Software may determine the PMP granularity by writing zero to pmp0cfg, then writing all ones
 * to pmpaddr0, then reading back pmpaddr0. If G is the index of the least-significant bit set,
 * the PMP granularity is 2^G+2 bytes.
 */
/* CPU instruction prefetch padding size for memory protection scenario */
/* Memory alignment size for PMS */
    /* rtc timer data (s_rtc_timer_retain_mem, see esp_clk.c files). For rtc_timer_data_in_rtc_mem section. */
  /**
   * This section is not included in the binary image; it is only present in the ELF file.
   * It is used to keep certain symbols in the ELF file.
   */
  .noload 0 (INFO) :
  {
    /* Reserve first 4 bytes as zero for vars pointed to NULL */
    . = 0;
    LONG(0);
    _noload_keep_in_elf_start = ABSOLUTE(.);
    
 mutable[noload_keep_in_elf]
    KEEP(*(.noload_keep_in_elf .noload_keep_in_elf.*))
    _noload_keep_in_elf_end = ABSOLUTE(.);
  }
  /* DWARF 1 */
  .debug 0 : { *(.debug) }
  .line 0 : { *(.line) }
  /* GNU DWARF 1 extensions */
  .debug_srcinfo 0 : { *(.debug_srcinfo) }
  .debug_sfnames 0 : { *(.debug_sfnames) }
  /* DWARF 1.1 and DWARF 2 */
  .debug_aranges 0 : { *(.debug_aranges) }
  .debug_pubnames 0 : { *(.debug_pubnames) }
  /* DWARF 2 */
  .debug_info 0 : { *(.debug_info .gnu.linkonce.wi.*) }
  .debug_abbrev 0 : { *(.debug_abbrev) }
  .debug_line 0 : { *(.debug_line) }
  .debug_frame 0 : { *(.debug_frame) }
  .debug_str 0 : { *(.debug_str) }
  .debug_loc 0 : { *(.debug_loc) }
  .debug_macinfo 0 : { *(.debug_macinfo) }
  .debug_pubtypes 0 : { *(.debug_pubtypes) }
  /* DWARF 3 */
  .debug_ranges 0 : { *(.debug_ranges) }
  /* SGI/MIPS DWARF 2 extensions */
  .debug_weaknames 0 : { *(.debug_weaknames) }
  .debug_funcnames 0 : { *(.debug_funcnames) }
  .debug_typenames 0 : { *(.debug_typenames) }
  .debug_varnames 0 : { *(.debug_varnames) }
  /* GNU DWARF 2 extensions */
  .debug_gnu_pubnames 0 : { *(.debug_gnu_pubnames) }
  .debug_gnu_pubtypes 0 : { *(.debug_gnu_pubtypes) }
  /* DWARF 4 */
  .debug_types 0 : { *(.debug_types) }
  /* DWARF 5 */
  .debug_addr 0 : { *(.debug_addr) }
  .debug_line_str 0 : { *(.debug_line_str) }
  .debug_loclists 0 : { *(.debug_loclists) }
  .debug_macro 0 : { *(.debug_macro) }
  .debug_names 0 : { *(.debug_names) }
  .debug_rnglists 0 : { *(.debug_rnglists) }
  .debug_str_offsets 0 : { *(.debug_str_offsets) }
  /**
   * Miscellaneous sections
   */
  .comment 0 : { *(.comment) }
  .note.GNU-stack 0 : { *(.note.GNU-stack) }
  .riscv.attributes 0 : { *(.riscv.attributes) }
/**
 * .xt.prop and .xt.lit sections will be used by the debugger and disassembler
 * to get more information about raw data present in the code.
 * Indeed, it may be required to add some padding at some points in the code
 * in order to align a branch/jump destination on a particular bound.
 * Padding these instructions will generate null bytes that shall be
 * interpreted as data, and not code by the debugger or disassembler.
 * This section will only be present in the ELF file, not in the final binary
 * For more details, check GCC-212
 */
  .xtensa.info 0 : { *(.xtensa.info) }
  .xt.prop 0 : { *(.xt.prop .xt.prop.* .gnu.linkonce.prop.*) }
  .xt.lit 0 : { *(.xt.lit .xt.lit.* .gnu.linkonce.p.*) }
/*
 * SPDX-FileCopyrightText: 2021-2024 Espressif Systems (Shanghai) CO LTD
 *
 * SPDX-License-Identifier: Apache-2.0
 */
/* CPU instruction prefetch padding size for flash mmap scenario */
/* Copy from esp_secure_boot.h */
/*
 * PMP region granularity size
 * Software may determine the PMP granularity by writing zero to pmp0cfg, then writing all ones
 * to pmpaddr0, then reading back pmpaddr0. If G is the index of the least-significant bit set,
 * the PMP granularity is 2^G+2 bytes.
 */
/* CPU instruction prefetch padding size for memory protection scenario */
/* Memory alignment size for PMS */
    /* rtc timer data (s_rtc_timer_retain_mem, see esp_clk.c files). For rtc_timer_data_in_rtc_mem section. */
  /DISCARD/ :
  {
   /**
    * Discarding .rela.* sections results in the following mapping:
    * .rela.text.* -> .text.*
    * .rela.data.* -> .data.*
    * And so forth...
    */
   *(.rela.*)
   *(.fini)
   *(.eh_frame_hdr)
   *(.eh_frame_hdr)
   *(.eh_frame)
  }
}
ASSERT(((_iram_end - ORIGIN(iram0_0_seg)) <= LENGTH(iram0_0_seg)),
          "IRAM0 segment data does not fit.")
ASSERT(((_heap_low_start - ORIGIN(dram0_0_seg)) <= LENGTH(dram0_0_seg)),
          "DRAM segment data does not fit.")
