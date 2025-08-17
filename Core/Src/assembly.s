/*
 * assembly.s
 *
 */
 
 @ DO NOT EDIT
	.syntax unified
    .text
    .global ASM_Main
    .thumb_func

@ DO NOT EDIT
vectors:
	.word 0x20002000
	.word ASM_Main + 1

@ DO NOT EDIT label ASM_Main
ASM_Main:

	@ Some code is given below for you to start with
	LDR R0, RCC_BASE  		@ Enable clock for GPIOA and B by setting bit 17 and 18 in RCC_AHBENR
	LDR R1, [R0, #0x14]
	LDR R2, AHBENR_GPIOAB	@ AHBENR_GPIOAB is defined under LITERALS at the end of the code
	ORRS R1, R1, R2
	STR R1, [R0, #0x14]

	LDR R0, GPIOA_BASE		@ Enable pull-up resistors for pushbuttons
	MOVS R1, #0b01010101
	STR R1, [R0, #0x0C]
	LDR R1, GPIOB_BASE  	@ Set pins connected to LEDs to outputs
	LDR R2, MODER_OUTPUT
	STR R2, [R1, #0]
	MOVS R2, #0         	@ NOTE: R2 will be dedicated to holding the value on the LEDs

@ TODO: Add code, labels and logic for button checks and LED patterns

main_loop:
	LDR R0, GPIOA_BASE
	LDR R3, [R0, #0x10]  @ Read button states (GPIOA_IDR) into R3. Pressed button = 0.

	@ Check SW3 (Freeze) on PA3. If pressed, bit 3 is 0.
	@ TST sets the Z flag if the result is zero. BEQ branches if Z=1.
	TST R3, #(1 << 3)
	BEQ main_loop       @ If pressed, loop back to the start. Skips all logic, freezing the LEDs.

	@ Check SW2 (Set to 0xAA) on PA2. If pressed, bit 2 is 0.
	TST R3, #(1 << 2)
	BNE continue_normal @ If not pressed (result is non-zero), continue to normal counting.
	LDR R2, =0xAA       @ If SW2 is pressed, load 0xAA into the LED register R2.
	B write_leds        @ Write the value to the LEDs and loop back.

continue_normal:
	@ --- NORMAL COUNTING LOGIC ---

	@ Step 1: Determine increment value based on SW0 (PA0)
	MOVS R4, #1         @ Default increment value = 1
	TST R3, #(1 << 0)   @ Check if SW0 is pressed
	BNE check_delay     @ If not pressed, keep increment as 1 and check for delay.
	MOVS R4, #2         @ If pressed, set increment value = 2.

check_delay:
	@ Step 2: Determine delay duration based on SW1 (PA1)
	LDR R6, =LONG_DELAY_CNT     @ Load address for the default long delay
	TST R3, #(1 << 1)           @ Check if SW1 is pressed
	BNE perform_increment_and_delay @ If not pressed, use the long delay.
	LDR R6, =SHORT_DELAY_CNT    @ If pressed, load address for the short delay instead.

perform_increment_and_delay:
	@ Step 3: Perform the increment
	ADD R2, R2, R4      @ Increment the LED counter R2 by the value in R4

	@ Step 4: Perform the delay
	LDR R5, [R6]        @ Load the actual delay countdown value into R5
	BL delay_sub        @ Call the delay subroutine
	B write_leds        @ Branch to write the new LED value and loop

delay_sub:
	@ Simple delay loop. R5 holds the countdown value.
delay_loop:
	SUBS R5, R5, #1     @ Decrement counter
	BNE delay_loop      @ Loop until counter is zero
	BX LR               @ Return from subroutine

write_leds:
	STR R2, [R1, #0x14] @ Write value in R2 to GPIOB Output Data Register (ODR). R1 holds GPIOB_BASE.
	B main_loop

@ LITERALS; DO NOT EDIT
	.align
RCC_BASE: 			.word 0x40021000
AHBENR_GPIOAB: 		.word 0b1100000000000000000
GPIOA_BASE:  		.word 0x48000000
GPIOB_BASE:  		.word 0x48000400
MODER_OUTPUT: 		.word 0x5555

@ TODO: Add your own values for these delays
@ These values are estimates for a standard clock speed (e.g., 8MHz).
@ A simple delay loop takes a few clock cycles.
@ For 0.7s: (0.7s * 8,000,000 cycles/s) / ~3 cycles/loop = ~1,866,667
@ For 0.3s: (0.3s * 8,000,000 cycles/s) / ~3 cycles/loop = 800,000
LONG_DELAY_CNT: 	.word 1800000
SHORT_DELAY_CNT: 	.word 800000
