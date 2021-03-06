/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'nios2_qsys_0' in SOPC Builder design 'nios_system'
 * SOPC Builder design path: ../../nios_system.sopcinfo
 *
 * Generated: Fri Dec 02 02:28:46 CST 2016
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_gen2"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x00001020
#define ALT_CPU_CPU_ARCH_NIOS2_R1
#define ALT_CPU_CPU_FREQ 50000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "tiny"
#define ALT_CPU_DATA_ADDR_WIDTH 0x1d
#define ALT_CPU_DCACHE_LINE_SIZE 0
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_DCACHE_SIZE 0
#define ALT_CPU_EXCEPTION_ADDR 0x10000020
#define ALT_CPU_FLASH_ACCELERATOR_LINES 0
#define ALT_CPU_FLASH_ACCELERATOR_LINE_SIZE 0
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 50000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 0
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 0
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_ICACHE_SIZE 0
#define ALT_CPU_INST_ADDR_WIDTH 0x1d
#define ALT_CPU_NAME "nios2_qsys_0"
#define ALT_CPU_OCI_VERSION 1
#define ALT_CPU_RESET_ADDR 0x10000000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x00001020
#define NIOS2_CPU_ARCH_NIOS2_R1
#define NIOS2_CPU_FREQ 50000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "tiny"
#define NIOS2_DATA_ADDR_WIDTH 0x1d
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_EXCEPTION_ADDR 0x10000020
#define NIOS2_FLASH_ACCELERATOR_LINES 0
#define NIOS2_FLASH_ACCELERATOR_LINE_SIZE 0
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 0
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 0
#define NIOS2_ICACHE_LINE_SIZE_LOG2 0
#define NIOS2_ICACHE_SIZE 0
#define NIOS2_INST_ADDR_WIDTH 0x1d
#define NIOS2_OCI_VERSION 1
#define NIOS2_RESET_ADDR 0x10000000


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_NEW_SDRAM_CONTROLLER
#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SYSID_QSYS
#define __ALTERA_NIOS2_GEN2
#define __ALTPLL


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "Cyclone IV E"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/jtag_uart_0"
#define ALT_STDERR_BASE 0x1b0
#define ALT_STDERR_DEV jtag_uart_0
#define ALT_STDERR_IS_JTAG_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/jtag_uart_0"
#define ALT_STDIN_BASE 0x1b0
#define ALT_STDIN_DEV jtag_uart_0
#define ALT_STDIN_IS_JTAG_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/jtag_uart_0"
#define ALT_STDOUT_BASE 0x1b0
#define ALT_STDOUT_DEV jtag_uart_0
#define ALT_STDOUT_IS_JTAG_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "nios_system"


/*
 * hal configuration
 *
 */

#define ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API
#define ALT_MAX_FD 32
#define ALT_SYS_CLK none
#define ALT_TIMESTAMP_CLK none


/*
 * jtag_uart_0 configuration
 *
 */

#define ALT_MODULE_CLASS_jtag_uart_0 altera_avalon_jtag_uart
#define JTAG_UART_0_BASE 0x1b0
#define JTAG_UART_0_IRQ 5
#define JTAG_UART_0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_UART_0_NAME "/dev/jtag_uart_0"
#define JTAG_UART_0_READ_DEPTH 64
#define JTAG_UART_0_READ_THRESHOLD 8
#define JTAG_UART_0_SPAN 8
#define JTAG_UART_0_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_0_WRITE_DEPTH 64
#define JTAG_UART_0_WRITE_THRESHOLD 8


/*
 * onchip_memory2_0 configuration
 *
 */

#define ALT_MODULE_CLASS_onchip_memory2_0 altera_avalon_onchip_memory2
#define ONCHIP_MEMORY2_0_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define ONCHIP_MEMORY2_0_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define ONCHIP_MEMORY2_0_BASE 0x0
#define ONCHIP_MEMORY2_0_CONTENTS_INFO ""
#define ONCHIP_MEMORY2_0_DUAL_PORT 0
#define ONCHIP_MEMORY2_0_GUI_RAM_BLOCK_TYPE "AUTO"
#define ONCHIP_MEMORY2_0_INIT_CONTENTS_FILE "nios_system_onchip_memory2_0"
#define ONCHIP_MEMORY2_0_INIT_MEM_CONTENT 1
#define ONCHIP_MEMORY2_0_INSTANCE_ID "NONE"
#define ONCHIP_MEMORY2_0_IRQ -1
#define ONCHIP_MEMORY2_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ONCHIP_MEMORY2_0_NAME "/dev/onchip_memory2_0"
#define ONCHIP_MEMORY2_0_NON_DEFAULT_INIT_FILE_ENABLED 0
#define ONCHIP_MEMORY2_0_RAM_BLOCK_TYPE "AUTO"
#define ONCHIP_MEMORY2_0_READ_DURING_WRITE_MODE "DONT_CARE"
#define ONCHIP_MEMORY2_0_SINGLE_CLOCK_OP 0
#define ONCHIP_MEMORY2_0_SIZE_MULTIPLE 1
#define ONCHIP_MEMORY2_0_SIZE_VALUE 16
#define ONCHIP_MEMORY2_0_SPAN 16
#define ONCHIP_MEMORY2_0_TYPE "altera_avalon_onchip_memory2"
#define ONCHIP_MEMORY2_0_WRITABLE 1


/*
 * sdram configuration
 *
 */

#define ALT_MODULE_CLASS_sdram altera_avalon_new_sdram_controller
#define SDRAM_BASE 0x10000000
#define SDRAM_CAS_LATENCY 3
#define SDRAM_CONTENTS_INFO
#define SDRAM_INIT_NOP_DELAY 0.0
#define SDRAM_INIT_REFRESH_COMMANDS 2
#define SDRAM_IRQ -1
#define SDRAM_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SDRAM_IS_INITIALIZED 1
#define SDRAM_NAME "/dev/sdram"
#define SDRAM_POWERUP_DELAY 200.0
#define SDRAM_REFRESH_PERIOD 7.8125
#define SDRAM_REGISTER_DATA_IN 1
#define SDRAM_SDRAM_ADDR_WIDTH 0x19
#define SDRAM_SDRAM_BANK_WIDTH 2
#define SDRAM_SDRAM_COL_WIDTH 10
#define SDRAM_SDRAM_DATA_WIDTH 32
#define SDRAM_SDRAM_NUM_BANKS 4
#define SDRAM_SDRAM_NUM_CHIPSELECTS 1
#define SDRAM_SDRAM_ROW_WIDTH 13
#define SDRAM_SHARED_DATA 0
#define SDRAM_SIM_MODEL_BASE 0
#define SDRAM_SPAN 134217728
#define SDRAM_STARVATION_INDICATOR 0
#define SDRAM_TRISTATE_BRIDGE_SLAVE ""
#define SDRAM_TYPE "altera_avalon_new_sdram_controller"
#define SDRAM_T_AC 5.5
#define SDRAM_T_MRD 3
#define SDRAM_T_RCD 20.0
#define SDRAM_T_RFC 70.0
#define SDRAM_T_RP 20.0
#define SDRAM_T_WR 14.0


/*
 * sdram_pll configuration
 *
 */

#define ALT_MODULE_CLASS_sdram_pll altpll
#define SDRAM_PLL_BASE 0x190
#define SDRAM_PLL_IRQ -1
#define SDRAM_PLL_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SDRAM_PLL_NAME "/dev/sdram_pll"
#define SDRAM_PLL_SPAN 16
#define SDRAM_PLL_TYPE "altpll"


/*
 * sysid_qsys_0 configuration
 *
 */

#define ALT_MODULE_CLASS_sysid_qsys_0 altera_avalon_sysid_qsys
#define SYSID_QSYS_0_BASE 0x1a8
#define SYSID_QSYS_0_ID 0
#define SYSID_QSYS_0_IRQ -1
#define SYSID_QSYS_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SYSID_QSYS_0_NAME "/dev/sysid_qsys_0"
#define SYSID_QSYS_0_SPAN 8
#define SYSID_QSYS_0_TIMESTAMP 1480657077
#define SYSID_QSYS_0_TYPE "altera_avalon_sysid_qsys"


/*
 * to_hw_port0 configuration
 *
 */

#define ALT_MODULE_CLASS_to_hw_port0 altera_avalon_pio
#define TO_HW_PORT0_BASE 0x100
#define TO_HW_PORT0_BIT_CLEARING_EDGE_REGISTER 0
#define TO_HW_PORT0_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_HW_PORT0_CAPTURE 0
#define TO_HW_PORT0_DATA_WIDTH 32
#define TO_HW_PORT0_DO_TEST_BENCH_WIRING 0
#define TO_HW_PORT0_DRIVEN_SIM_VALUE 0
#define TO_HW_PORT0_EDGE_TYPE "NONE"
#define TO_HW_PORT0_FREQ 50000000
#define TO_HW_PORT0_HAS_IN 0
#define TO_HW_PORT0_HAS_OUT 1
#define TO_HW_PORT0_HAS_TRI 0
#define TO_HW_PORT0_IRQ -1
#define TO_HW_PORT0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_HW_PORT0_IRQ_TYPE "NONE"
#define TO_HW_PORT0_NAME "/dev/to_hw_port0"
#define TO_HW_PORT0_RESET_VALUE 0
#define TO_HW_PORT0_SPAN 16
#define TO_HW_PORT0_TYPE "altera_avalon_pio"


/*
 * to_hw_port1 configuration
 *
 */

#define ALT_MODULE_CLASS_to_hw_port1 altera_avalon_pio
#define TO_HW_PORT1_BASE 0xf0
#define TO_HW_PORT1_BIT_CLEARING_EDGE_REGISTER 0
#define TO_HW_PORT1_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_HW_PORT1_CAPTURE 0
#define TO_HW_PORT1_DATA_WIDTH 32
#define TO_HW_PORT1_DO_TEST_BENCH_WIRING 0
#define TO_HW_PORT1_DRIVEN_SIM_VALUE 0
#define TO_HW_PORT1_EDGE_TYPE "NONE"
#define TO_HW_PORT1_FREQ 50000000
#define TO_HW_PORT1_HAS_IN 0
#define TO_HW_PORT1_HAS_OUT 1
#define TO_HW_PORT1_HAS_TRI 0
#define TO_HW_PORT1_IRQ -1
#define TO_HW_PORT1_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_HW_PORT1_IRQ_TYPE "NONE"
#define TO_HW_PORT1_NAME "/dev/to_hw_port1"
#define TO_HW_PORT1_RESET_VALUE 0
#define TO_HW_PORT1_SPAN 16
#define TO_HW_PORT1_TYPE "altera_avalon_pio"


/*
 * to_hw_port10 configuration
 *
 */

#define ALT_MODULE_CLASS_to_hw_port10 altera_avalon_pio
#define TO_HW_PORT10_BASE 0x40
#define TO_HW_PORT10_BIT_CLEARING_EDGE_REGISTER 0
#define TO_HW_PORT10_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_HW_PORT10_CAPTURE 0
#define TO_HW_PORT10_DATA_WIDTH 32
#define TO_HW_PORT10_DO_TEST_BENCH_WIRING 0
#define TO_HW_PORT10_DRIVEN_SIM_VALUE 0
#define TO_HW_PORT10_EDGE_TYPE "NONE"
#define TO_HW_PORT10_FREQ 50000000
#define TO_HW_PORT10_HAS_IN 0
#define TO_HW_PORT10_HAS_OUT 1
#define TO_HW_PORT10_HAS_TRI 0
#define TO_HW_PORT10_IRQ -1
#define TO_HW_PORT10_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_HW_PORT10_IRQ_TYPE "NONE"
#define TO_HW_PORT10_NAME "/dev/to_hw_port10"
#define TO_HW_PORT10_RESET_VALUE 0
#define TO_HW_PORT10_SPAN 16
#define TO_HW_PORT10_TYPE "altera_avalon_pio"


/*
 * to_hw_port11 configuration
 *
 */

#define ALT_MODULE_CLASS_to_hw_port11 altera_avalon_pio
#define TO_HW_PORT11_BASE 0x30
#define TO_HW_PORT11_BIT_CLEARING_EDGE_REGISTER 0
#define TO_HW_PORT11_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_HW_PORT11_CAPTURE 0
#define TO_HW_PORT11_DATA_WIDTH 32
#define TO_HW_PORT11_DO_TEST_BENCH_WIRING 0
#define TO_HW_PORT11_DRIVEN_SIM_VALUE 0
#define TO_HW_PORT11_EDGE_TYPE "NONE"
#define TO_HW_PORT11_FREQ 50000000
#define TO_HW_PORT11_HAS_IN 0
#define TO_HW_PORT11_HAS_OUT 1
#define TO_HW_PORT11_HAS_TRI 0
#define TO_HW_PORT11_IRQ -1
#define TO_HW_PORT11_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_HW_PORT11_IRQ_TYPE "NONE"
#define TO_HW_PORT11_NAME "/dev/to_hw_port11"
#define TO_HW_PORT11_RESET_VALUE 0
#define TO_HW_PORT11_SPAN 16
#define TO_HW_PORT11_TYPE "altera_avalon_pio"


/*
 * to_hw_port12 configuration
 *
 */

#define ALT_MODULE_CLASS_to_hw_port12 altera_avalon_pio
#define TO_HW_PORT12_BASE 0x20
#define TO_HW_PORT12_BIT_CLEARING_EDGE_REGISTER 0
#define TO_HW_PORT12_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_HW_PORT12_CAPTURE 0
#define TO_HW_PORT12_DATA_WIDTH 32
#define TO_HW_PORT12_DO_TEST_BENCH_WIRING 0
#define TO_HW_PORT12_DRIVEN_SIM_VALUE 0
#define TO_HW_PORT12_EDGE_TYPE "NONE"
#define TO_HW_PORT12_FREQ 50000000
#define TO_HW_PORT12_HAS_IN 0
#define TO_HW_PORT12_HAS_OUT 1
#define TO_HW_PORT12_HAS_TRI 0
#define TO_HW_PORT12_IRQ -1
#define TO_HW_PORT12_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_HW_PORT12_IRQ_TYPE "NONE"
#define TO_HW_PORT12_NAME "/dev/to_hw_port12"
#define TO_HW_PORT12_RESET_VALUE 0
#define TO_HW_PORT12_SPAN 16
#define TO_HW_PORT12_TYPE "altera_avalon_pio"


/*
 * to_hw_port13 configuration
 *
 */

#define ALT_MODULE_CLASS_to_hw_port13 altera_avalon_pio
#define TO_HW_PORT13_BASE 0x160
#define TO_HW_PORT13_BIT_CLEARING_EDGE_REGISTER 0
#define TO_HW_PORT13_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_HW_PORT13_CAPTURE 0
#define TO_HW_PORT13_DATA_WIDTH 32
#define TO_HW_PORT13_DO_TEST_BENCH_WIRING 0
#define TO_HW_PORT13_DRIVEN_SIM_VALUE 0
#define TO_HW_PORT13_EDGE_TYPE "NONE"
#define TO_HW_PORT13_FREQ 50000000
#define TO_HW_PORT13_HAS_IN 0
#define TO_HW_PORT13_HAS_OUT 1
#define TO_HW_PORT13_HAS_TRI 0
#define TO_HW_PORT13_IRQ -1
#define TO_HW_PORT13_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_HW_PORT13_IRQ_TYPE "NONE"
#define TO_HW_PORT13_NAME "/dev/to_hw_port13"
#define TO_HW_PORT13_RESET_VALUE 0
#define TO_HW_PORT13_SPAN 16
#define TO_HW_PORT13_TYPE "altera_avalon_pio"


/*
 * to_hw_port14 configuration
 *
 */

#define ALT_MODULE_CLASS_to_hw_port14 altera_avalon_pio
#define TO_HW_PORT14_BASE 0x150
#define TO_HW_PORT14_BIT_CLEARING_EDGE_REGISTER 0
#define TO_HW_PORT14_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_HW_PORT14_CAPTURE 0
#define TO_HW_PORT14_DATA_WIDTH 32
#define TO_HW_PORT14_DO_TEST_BENCH_WIRING 0
#define TO_HW_PORT14_DRIVEN_SIM_VALUE 0
#define TO_HW_PORT14_EDGE_TYPE "NONE"
#define TO_HW_PORT14_FREQ 50000000
#define TO_HW_PORT14_HAS_IN 0
#define TO_HW_PORT14_HAS_OUT 1
#define TO_HW_PORT14_HAS_TRI 0
#define TO_HW_PORT14_IRQ -1
#define TO_HW_PORT14_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_HW_PORT14_IRQ_TYPE "NONE"
#define TO_HW_PORT14_NAME "/dev/to_hw_port14"
#define TO_HW_PORT14_RESET_VALUE 0
#define TO_HW_PORT14_SPAN 16
#define TO_HW_PORT14_TYPE "altera_avalon_pio"


/*
 * to_hw_port15 configuration
 *
 */

#define ALT_MODULE_CLASS_to_hw_port15 altera_avalon_pio
#define TO_HW_PORT15_BASE 0x140
#define TO_HW_PORT15_BIT_CLEARING_EDGE_REGISTER 0
#define TO_HW_PORT15_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_HW_PORT15_CAPTURE 0
#define TO_HW_PORT15_DATA_WIDTH 32
#define TO_HW_PORT15_DO_TEST_BENCH_WIRING 0
#define TO_HW_PORT15_DRIVEN_SIM_VALUE 0
#define TO_HW_PORT15_EDGE_TYPE "NONE"
#define TO_HW_PORT15_FREQ 50000000
#define TO_HW_PORT15_HAS_IN 0
#define TO_HW_PORT15_HAS_OUT 1
#define TO_HW_PORT15_HAS_TRI 0
#define TO_HW_PORT15_IRQ -1
#define TO_HW_PORT15_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_HW_PORT15_IRQ_TYPE "NONE"
#define TO_HW_PORT15_NAME "/dev/to_hw_port15"
#define TO_HW_PORT15_RESET_VALUE 0
#define TO_HW_PORT15_SPAN 16
#define TO_HW_PORT15_TYPE "altera_avalon_pio"


/*
 * to_hw_port2 configuration
 *
 */

#define ALT_MODULE_CLASS_to_hw_port2 altera_avalon_pio
#define TO_HW_PORT2_BASE 0xe0
#define TO_HW_PORT2_BIT_CLEARING_EDGE_REGISTER 0
#define TO_HW_PORT2_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_HW_PORT2_CAPTURE 0
#define TO_HW_PORT2_DATA_WIDTH 32
#define TO_HW_PORT2_DO_TEST_BENCH_WIRING 0
#define TO_HW_PORT2_DRIVEN_SIM_VALUE 0
#define TO_HW_PORT2_EDGE_TYPE "NONE"
#define TO_HW_PORT2_FREQ 50000000
#define TO_HW_PORT2_HAS_IN 0
#define TO_HW_PORT2_HAS_OUT 1
#define TO_HW_PORT2_HAS_TRI 0
#define TO_HW_PORT2_IRQ -1
#define TO_HW_PORT2_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_HW_PORT2_IRQ_TYPE "NONE"
#define TO_HW_PORT2_NAME "/dev/to_hw_port2"
#define TO_HW_PORT2_RESET_VALUE 0
#define TO_HW_PORT2_SPAN 16
#define TO_HW_PORT2_TYPE "altera_avalon_pio"


/*
 * to_hw_port3 configuration
 *
 */

#define ALT_MODULE_CLASS_to_hw_port3 altera_avalon_pio
#define TO_HW_PORT3_BASE 0xd0
#define TO_HW_PORT3_BIT_CLEARING_EDGE_REGISTER 0
#define TO_HW_PORT3_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_HW_PORT3_CAPTURE 0
#define TO_HW_PORT3_DATA_WIDTH 32
#define TO_HW_PORT3_DO_TEST_BENCH_WIRING 0
#define TO_HW_PORT3_DRIVEN_SIM_VALUE 0
#define TO_HW_PORT3_EDGE_TYPE "NONE"
#define TO_HW_PORT3_FREQ 50000000
#define TO_HW_PORT3_HAS_IN 0
#define TO_HW_PORT3_HAS_OUT 1
#define TO_HW_PORT3_HAS_TRI 0
#define TO_HW_PORT3_IRQ -1
#define TO_HW_PORT3_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_HW_PORT3_IRQ_TYPE "NONE"
#define TO_HW_PORT3_NAME "/dev/to_hw_port3"
#define TO_HW_PORT3_RESET_VALUE 0
#define TO_HW_PORT3_SPAN 16
#define TO_HW_PORT3_TYPE "altera_avalon_pio"


/*
 * to_hw_port4 configuration
 *
 */

#define ALT_MODULE_CLASS_to_hw_port4 altera_avalon_pio
#define TO_HW_PORT4_BASE 0xc0
#define TO_HW_PORT4_BIT_CLEARING_EDGE_REGISTER 0
#define TO_HW_PORT4_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_HW_PORT4_CAPTURE 0
#define TO_HW_PORT4_DATA_WIDTH 32
#define TO_HW_PORT4_DO_TEST_BENCH_WIRING 0
#define TO_HW_PORT4_DRIVEN_SIM_VALUE 0
#define TO_HW_PORT4_EDGE_TYPE "NONE"
#define TO_HW_PORT4_FREQ 50000000
#define TO_HW_PORT4_HAS_IN 0
#define TO_HW_PORT4_HAS_OUT 1
#define TO_HW_PORT4_HAS_TRI 0
#define TO_HW_PORT4_IRQ -1
#define TO_HW_PORT4_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_HW_PORT4_IRQ_TYPE "NONE"
#define TO_HW_PORT4_NAME "/dev/to_hw_port4"
#define TO_HW_PORT4_RESET_VALUE 0
#define TO_HW_PORT4_SPAN 16
#define TO_HW_PORT4_TYPE "altera_avalon_pio"


/*
 * to_hw_port5 configuration
 *
 */

#define ALT_MODULE_CLASS_to_hw_port5 altera_avalon_pio
#define TO_HW_PORT5_BASE 0xb0
#define TO_HW_PORT5_BIT_CLEARING_EDGE_REGISTER 0
#define TO_HW_PORT5_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_HW_PORT5_CAPTURE 0
#define TO_HW_PORT5_DATA_WIDTH 32
#define TO_HW_PORT5_DO_TEST_BENCH_WIRING 0
#define TO_HW_PORT5_DRIVEN_SIM_VALUE 0
#define TO_HW_PORT5_EDGE_TYPE "NONE"
#define TO_HW_PORT5_FREQ 50000000
#define TO_HW_PORT5_HAS_IN 0
#define TO_HW_PORT5_HAS_OUT 1
#define TO_HW_PORT5_HAS_TRI 0
#define TO_HW_PORT5_IRQ -1
#define TO_HW_PORT5_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_HW_PORT5_IRQ_TYPE "NONE"
#define TO_HW_PORT5_NAME "/dev/to_hw_port5"
#define TO_HW_PORT5_RESET_VALUE 0
#define TO_HW_PORT5_SPAN 16
#define TO_HW_PORT5_TYPE "altera_avalon_pio"


/*
 * to_hw_port6 configuration
 *
 */

#define ALT_MODULE_CLASS_to_hw_port6 altera_avalon_pio
#define TO_HW_PORT6_BASE 0xa0
#define TO_HW_PORT6_BIT_CLEARING_EDGE_REGISTER 0
#define TO_HW_PORT6_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_HW_PORT6_CAPTURE 0
#define TO_HW_PORT6_DATA_WIDTH 32
#define TO_HW_PORT6_DO_TEST_BENCH_WIRING 0
#define TO_HW_PORT6_DRIVEN_SIM_VALUE 0
#define TO_HW_PORT6_EDGE_TYPE "NONE"
#define TO_HW_PORT6_FREQ 50000000
#define TO_HW_PORT6_HAS_IN 0
#define TO_HW_PORT6_HAS_OUT 1
#define TO_HW_PORT6_HAS_TRI 0
#define TO_HW_PORT6_IRQ -1
#define TO_HW_PORT6_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_HW_PORT6_IRQ_TYPE "NONE"
#define TO_HW_PORT6_NAME "/dev/to_hw_port6"
#define TO_HW_PORT6_RESET_VALUE 0
#define TO_HW_PORT6_SPAN 16
#define TO_HW_PORT6_TYPE "altera_avalon_pio"


/*
 * to_hw_port7 configuration
 *
 */

#define ALT_MODULE_CLASS_to_hw_port7 altera_avalon_pio
#define TO_HW_PORT7_BASE 0x60
#define TO_HW_PORT7_BIT_CLEARING_EDGE_REGISTER 0
#define TO_HW_PORT7_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_HW_PORT7_CAPTURE 0
#define TO_HW_PORT7_DATA_WIDTH 32
#define TO_HW_PORT7_DO_TEST_BENCH_WIRING 0
#define TO_HW_PORT7_DRIVEN_SIM_VALUE 0
#define TO_HW_PORT7_EDGE_TYPE "NONE"
#define TO_HW_PORT7_FREQ 50000000
#define TO_HW_PORT7_HAS_IN 0
#define TO_HW_PORT7_HAS_OUT 1
#define TO_HW_PORT7_HAS_TRI 0
#define TO_HW_PORT7_IRQ -1
#define TO_HW_PORT7_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_HW_PORT7_IRQ_TYPE "NONE"
#define TO_HW_PORT7_NAME "/dev/to_hw_port7"
#define TO_HW_PORT7_RESET_VALUE 0
#define TO_HW_PORT7_SPAN 16
#define TO_HW_PORT7_TYPE "altera_avalon_pio"


/*
 * to_hw_port8 configuration
 *
 */

#define ALT_MODULE_CLASS_to_hw_port8 altera_avalon_pio
#define TO_HW_PORT8_BASE 0x90
#define TO_HW_PORT8_BIT_CLEARING_EDGE_REGISTER 0
#define TO_HW_PORT8_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_HW_PORT8_CAPTURE 0
#define TO_HW_PORT8_DATA_WIDTH 32
#define TO_HW_PORT8_DO_TEST_BENCH_WIRING 0
#define TO_HW_PORT8_DRIVEN_SIM_VALUE 0
#define TO_HW_PORT8_EDGE_TYPE "NONE"
#define TO_HW_PORT8_FREQ 50000000
#define TO_HW_PORT8_HAS_IN 0
#define TO_HW_PORT8_HAS_OUT 1
#define TO_HW_PORT8_HAS_TRI 0
#define TO_HW_PORT8_IRQ -1
#define TO_HW_PORT8_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_HW_PORT8_IRQ_TYPE "NONE"
#define TO_HW_PORT8_NAME "/dev/to_hw_port8"
#define TO_HW_PORT8_RESET_VALUE 0
#define TO_HW_PORT8_SPAN 16
#define TO_HW_PORT8_TYPE "altera_avalon_pio"


/*
 * to_hw_port9 configuration
 *
 */

#define ALT_MODULE_CLASS_to_hw_port9 altera_avalon_pio
#define TO_HW_PORT9_BASE 0x80
#define TO_HW_PORT9_BIT_CLEARING_EDGE_REGISTER 0
#define TO_HW_PORT9_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_HW_PORT9_CAPTURE 0
#define TO_HW_PORT9_DATA_WIDTH 32
#define TO_HW_PORT9_DO_TEST_BENCH_WIRING 0
#define TO_HW_PORT9_DRIVEN_SIM_VALUE 0
#define TO_HW_PORT9_EDGE_TYPE "NONE"
#define TO_HW_PORT9_FREQ 50000000
#define TO_HW_PORT9_HAS_IN 0
#define TO_HW_PORT9_HAS_OUT 1
#define TO_HW_PORT9_HAS_TRI 0
#define TO_HW_PORT9_IRQ -1
#define TO_HW_PORT9_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_HW_PORT9_IRQ_TYPE "NONE"
#define TO_HW_PORT9_NAME "/dev/to_hw_port9"
#define TO_HW_PORT9_RESET_VALUE 0
#define TO_HW_PORT9_SPAN 16
#define TO_HW_PORT9_TYPE "altera_avalon_pio"


/*
 * to_hw_sig configuration
 *
 */

#define ALT_MODULE_CLASS_to_hw_sig altera_avalon_pio
#define TO_HW_SIG_BASE 0x70
#define TO_HW_SIG_BIT_CLEARING_EDGE_REGISTER 0
#define TO_HW_SIG_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_HW_SIG_CAPTURE 0
#define TO_HW_SIG_DATA_WIDTH 2
#define TO_HW_SIG_DO_TEST_BENCH_WIRING 0
#define TO_HW_SIG_DRIVEN_SIM_VALUE 0
#define TO_HW_SIG_EDGE_TYPE "NONE"
#define TO_HW_SIG_FREQ 50000000
#define TO_HW_SIG_HAS_IN 0
#define TO_HW_SIG_HAS_OUT 1
#define TO_HW_SIG_HAS_TRI 0
#define TO_HW_SIG_IRQ -1
#define TO_HW_SIG_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_HW_SIG_IRQ_TYPE "NONE"
#define TO_HW_SIG_NAME "/dev/to_hw_sig"
#define TO_HW_SIG_RESET_VALUE 0
#define TO_HW_SIG_SPAN 16
#define TO_HW_SIG_TYPE "altera_avalon_pio"


/*
 * to_sw_port0 configuration
 *
 */

#define ALT_MODULE_CLASS_to_sw_port0 altera_avalon_pio
#define TO_SW_PORT0_BASE 0x130
#define TO_SW_PORT0_BIT_CLEARING_EDGE_REGISTER 0
#define TO_SW_PORT0_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_SW_PORT0_CAPTURE 0
#define TO_SW_PORT0_DATA_WIDTH 32
#define TO_SW_PORT0_DO_TEST_BENCH_WIRING 0
#define TO_SW_PORT0_DRIVEN_SIM_VALUE 0
#define TO_SW_PORT0_EDGE_TYPE "NONE"
#define TO_SW_PORT0_FREQ 50000000
#define TO_SW_PORT0_HAS_IN 1
#define TO_SW_PORT0_HAS_OUT 0
#define TO_SW_PORT0_HAS_TRI 0
#define TO_SW_PORT0_IRQ -1
#define TO_SW_PORT0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_SW_PORT0_IRQ_TYPE "NONE"
#define TO_SW_PORT0_NAME "/dev/to_sw_port0"
#define TO_SW_PORT0_RESET_VALUE 0
#define TO_SW_PORT0_SPAN 16
#define TO_SW_PORT0_TYPE "altera_avalon_pio"


/*
 * to_sw_port1 configuration
 *
 */

#define ALT_MODULE_CLASS_to_sw_port1 altera_avalon_pio
#define TO_SW_PORT1_BASE 0x120
#define TO_SW_PORT1_BIT_CLEARING_EDGE_REGISTER 0
#define TO_SW_PORT1_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_SW_PORT1_CAPTURE 0
#define TO_SW_PORT1_DATA_WIDTH 32
#define TO_SW_PORT1_DO_TEST_BENCH_WIRING 0
#define TO_SW_PORT1_DRIVEN_SIM_VALUE 0
#define TO_SW_PORT1_EDGE_TYPE "NONE"
#define TO_SW_PORT1_FREQ 50000000
#define TO_SW_PORT1_HAS_IN 1
#define TO_SW_PORT1_HAS_OUT 0
#define TO_SW_PORT1_HAS_TRI 0
#define TO_SW_PORT1_IRQ -1
#define TO_SW_PORT1_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_SW_PORT1_IRQ_TYPE "NONE"
#define TO_SW_PORT1_NAME "/dev/to_sw_port1"
#define TO_SW_PORT1_RESET_VALUE 0
#define TO_SW_PORT1_SPAN 16
#define TO_SW_PORT1_TYPE "altera_avalon_pio"


/*
 * to_sw_port2 configuration
 *
 */

#define ALT_MODULE_CLASS_to_sw_port2 altera_avalon_pio
#define TO_SW_PORT2_BASE 0x110
#define TO_SW_PORT2_BIT_CLEARING_EDGE_REGISTER 0
#define TO_SW_PORT2_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_SW_PORT2_CAPTURE 0
#define TO_SW_PORT2_DATA_WIDTH 8
#define TO_SW_PORT2_DO_TEST_BENCH_WIRING 0
#define TO_SW_PORT2_DRIVEN_SIM_VALUE 0
#define TO_SW_PORT2_EDGE_TYPE "NONE"
#define TO_SW_PORT2_FREQ 50000000
#define TO_SW_PORT2_HAS_IN 1
#define TO_SW_PORT2_HAS_OUT 0
#define TO_SW_PORT2_HAS_TRI 0
#define TO_SW_PORT2_IRQ -1
#define TO_SW_PORT2_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_SW_PORT2_IRQ_TYPE "NONE"
#define TO_SW_PORT2_NAME "/dev/to_sw_port2"
#define TO_SW_PORT2_RESET_VALUE 0
#define TO_SW_PORT2_SPAN 16
#define TO_SW_PORT2_TYPE "altera_avalon_pio"


/*
 * to_sw_port3 configuration
 *
 */

#define ALT_MODULE_CLASS_to_sw_port3 altera_avalon_pio
#define TO_SW_PORT3_BASE 0x180
#define TO_SW_PORT3_BIT_CLEARING_EDGE_REGISTER 0
#define TO_SW_PORT3_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_SW_PORT3_CAPTURE 0
#define TO_SW_PORT3_DATA_WIDTH 16
#define TO_SW_PORT3_DO_TEST_BENCH_WIRING 0
#define TO_SW_PORT3_DRIVEN_SIM_VALUE 0
#define TO_SW_PORT3_EDGE_TYPE "NONE"
#define TO_SW_PORT3_FREQ 50000000
#define TO_SW_PORT3_HAS_IN 1
#define TO_SW_PORT3_HAS_OUT 0
#define TO_SW_PORT3_HAS_TRI 0
#define TO_SW_PORT3_IRQ -1
#define TO_SW_PORT3_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_SW_PORT3_IRQ_TYPE "NONE"
#define TO_SW_PORT3_NAME "/dev/to_sw_port3"
#define TO_SW_PORT3_RESET_VALUE 0
#define TO_SW_PORT3_SPAN 16
#define TO_SW_PORT3_TYPE "altera_avalon_pio"


/*
 * to_sw_port4 configuration
 *
 */

#define ALT_MODULE_CLASS_to_sw_port4 altera_avalon_pio
#define TO_SW_PORT4_BASE 0x170
#define TO_SW_PORT4_BIT_CLEARING_EDGE_REGISTER 0
#define TO_SW_PORT4_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_SW_PORT4_CAPTURE 0
#define TO_SW_PORT4_DATA_WIDTH 16
#define TO_SW_PORT4_DO_TEST_BENCH_WIRING 0
#define TO_SW_PORT4_DRIVEN_SIM_VALUE 0
#define TO_SW_PORT4_EDGE_TYPE "NONE"
#define TO_SW_PORT4_FREQ 50000000
#define TO_SW_PORT4_HAS_IN 1
#define TO_SW_PORT4_HAS_OUT 0
#define TO_SW_PORT4_HAS_TRI 0
#define TO_SW_PORT4_IRQ -1
#define TO_SW_PORT4_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_SW_PORT4_IRQ_TYPE "NONE"
#define TO_SW_PORT4_NAME "/dev/to_sw_port4"
#define TO_SW_PORT4_RESET_VALUE 0
#define TO_SW_PORT4_SPAN 16
#define TO_SW_PORT4_TYPE "altera_avalon_pio"


/*
 * to_sw_sig configuration
 *
 */

#define ALT_MODULE_CLASS_to_sw_sig altera_avalon_pio
#define TO_SW_SIG_BASE 0x50
#define TO_SW_SIG_BIT_CLEARING_EDGE_REGISTER 0
#define TO_SW_SIG_BIT_MODIFYING_OUTPUT_REGISTER 0
#define TO_SW_SIG_CAPTURE 0
#define TO_SW_SIG_DATA_WIDTH 2
#define TO_SW_SIG_DO_TEST_BENCH_WIRING 0
#define TO_SW_SIG_DRIVEN_SIM_VALUE 0
#define TO_SW_SIG_EDGE_TYPE "NONE"
#define TO_SW_SIG_FREQ 50000000
#define TO_SW_SIG_HAS_IN 1
#define TO_SW_SIG_HAS_OUT 0
#define TO_SW_SIG_HAS_TRI 0
#define TO_SW_SIG_IRQ -1
#define TO_SW_SIG_IRQ_INTERRUPT_CONTROLLER_ID -1
#define TO_SW_SIG_IRQ_TYPE "NONE"
#define TO_SW_SIG_NAME "/dev/to_sw_sig"
#define TO_SW_SIG_RESET_VALUE 0
#define TO_SW_SIG_SPAN 16
#define TO_SW_SIG_TYPE "altera_avalon_pio"

#endif /* __SYSTEM_H_ */
