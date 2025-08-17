# EEE3096S Practical 2 - STM32 Assembly Programming

## Overview
This practical focuses on ARM assembly language programming for the STM32F051C6 microcontroller. The project demonstrates low-level hardware control using assembly language to interface with GPIO pins, buttons, and LEDs.

## Hardware Setup
- **Microcontroller**: STM32F051C6
- **Development Board**: STM32 Discovery or compatible
- **Inputs**: Push buttons connected to GPIOA pins
- **Outputs**: LEDs connected to GPIOB pins

## Project Structure
```
Practical2/
├── Core/
│   ├── Inc/
│   │   ├── assembly.h          # Assembly function declarations
│   │   ├── main.h              # Main header file
│   │   └── stm32f0xx_hal_conf.h
│   └── Src/
│       ├── assembly.s          # Main assembly implementation
│       ├── main.c              # C main program
│       └── stm32f0xx_hal_msp.c
├── Drivers/                    # STM32 HAL drivers
├── Makefile                    # Build configuration
├── Practical2.ioc            # STM32CubeMX project file
└── STM32F051C6Tx_FLASH.ld    # Linker script
```

## Key Features

### Assembly Implementation (`assembly.s`)
- **GPIO Configuration**: Enables clocks for GPIOA and GPIOB
- **Button Input**: Configures pull-up resistors for pushbuttons on GPIOA
- **LED Output**: Sets up GPIOB pins as outputs for LED control
- **Main Loop**: Implements button polling and LED pattern control

### C Integration (`main.c`)
- **HAL Initialization**: Sets up STM32 HAL library
- **System Clock**: Configures HSI oscillator
- **Assembly Interface**: Calls `ASM_Main()` function from assembly code

## Hardware Configuration

### GPIO Setup
- **GPIOA**: Input pins with pull-up resistors for buttons
- **GPIOB**: Output pins for LED control (configured as 0x5555 for alternating outputs)

### Clock Configuration
- **RCC_AHBENR**: Enables GPIOA and GPIOB clocks (bits 17-18)
- **System Clock**: HSI oscillator at default frequency

## Memory Map
- **RCC Base**: 0x40021000
- **GPIOA Base**: 0x48000000  
- **GPIOB Base**: 0x48000400

## Building and Running

### Prerequisites
- STM32CubeIDE or compatible ARM GCC toolchain
- STM32 programmer (ST-Link)

### Build Process
```bash
make clean
make all
```

### Programming
1. Connect STM32 board via ST-Link
2. Flash the compiled binary to the microcontroller
3. Reset the board to start execution

## Code Structure

### Assembly Entry Point
The `ASM_Main` function serves as the main assembly entry point, called from C code after HAL initialization.

### Button Polling
The main loop continuously polls button states and updates LED patterns accordingly.

### LED Control
LEDs are controlled by writing values to GPIOB output data register (ODR) at offset 0x14.

## Development Notes
- Assembly code uses unified syntax (`.syntax unified`)
- Thumb instruction set (`.thumb_func`)
- Stack pointer initialized to 0x20002000
- Vector table includes reset vector pointing to ASM_Main

## Learning Objectives
- Understanding ARM Cortex-M0 assembly language
- Direct hardware register manipulation
- GPIO configuration and control
- Integration of assembly and C code
- Real-time embedded programming concepts

## Contributors
- **Samson Okuthe** - Assembly implementation, GPIO configuration
- **Nyakallo Peete** - Main program logic, documentation
- **Course Framework** - University of Cape Town EEE3096S

## License
Educational use only - University of Cape Town
