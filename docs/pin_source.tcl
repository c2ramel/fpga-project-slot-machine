# CLOCK
set_location_assignment PIN_P11 -to MAX10_CLK1_50

# BUTTONS (Onboard)
set_location_assignment PIN_B8 -to KEY0
set_location_assignment PIN_A7 -to KEY1

# SWITCHES
set_location_assignment PIN_C10 -to SW0
set_location_assignment PIN_C11 -to SW1
set_location_assignment PIN_D12 -to SW2
set_location_assignment PIN_C12 -to SW3
set_location_assignment PIN_A12 -to SW4
set_location_assignment PIN_B12 -to SW5
set_location_assignment PIN_A13 -to SW6
set_location_assignment PIN_A14 -to SW7
set_location_assignment PIN_B14 -to SW8
set_location_assignment PIN_F15 -to SW9

# LEDS
set_location_assignment PIN_A8 -to LEDR0
set_location_assignment PIN_A9 -to LEDR1
set_location_assignment PIN_A10 -to LEDR2
set_location_assignment PIN_B10 -to LEDR3
set_location_assignment PIN_D13 -to LEDR4
set_location_assignment PIN_C13 -to LEDR5
set_location_assignment PIN_E14 -to LEDR6
set_location_assignment PIN_D14 -to LEDR7
set_location_assignment PIN_A11 -to LEDR8
set_location_assignment PIN_B11 -to LEDR9

# 7-SEGMENT DISPLAYS
# Note: User file used scalar names (e.g., HEX00) instead of vectors (HEX0[0])
set_location_assignment PIN_C14 -to HEX00
set_location_assignment PIN_E15 -to HEX01
set_location_assignment PIN_C15 -to HEX02
set_location_assignment PIN_C16 -to HEX03
set_location_assignment PIN_E16 -to HEX04
set_location_assignment PIN_D17 -to HEX05
set_location_assignment PIN_C17 -to HEX06

set_location_assignment PIN_C18 -to HEX10
set_location_assignment PIN_D18 -to HEX11
set_location_assignment PIN_E18 -to HEX12
set_location_assignment PIN_B16 -to HEX13
set_location_assignment PIN_A17 -to HEX14
set_location_assignment PIN_A18 -to HEX15
set_location_assignment PIN_B17 -to HEX16

set_location_assignment PIN_B20 -to HEX20
set_location_assignment PIN_A20 -to HEX21
set_location_assignment PIN_B19 -to HEX22
set_location_assignment PIN_A21 -to HEX23
set_location_assignment PIN_B21 -to HEX24
set_location_assignment PIN_C22 -to HEX25
set_location_assignment PIN_B22 -to HEX26

set_location_assignment PIN_F21 -to HEX30
set_location_assignment PIN_E22 -to HEX31
set_location_assignment PIN_E21 -to HEX32
set_location_assignment PIN_C19 -to HEX33
set_location_assignment PIN_C20 -to HEX34
set_location_assignment PIN_D19 -to HEX35
set_location_assignment PIN_E17 -to HEX36

set_location_assignment PIN_F18 -to HEX40
set_location_assignment PIN_E20 -to HEX41
set_location_assignment PIN_E19 -to HEX42
set_location_assignment PIN_J18 -to HEX43
set_location_assignment PIN_H19 -to HEX44
set_location_assignment PIN_F19 -to HEX45
set_location_assignment PIN_F20 -to HEX46

set_location_assignment PIN_J20 -to HEX50
set_location_assignment PIN_K20 -to HEX51
set_location_assignment PIN_L18 -to HEX52
set_location_assignment PIN_N18 -to HEX53
set_location_assignment PIN_M20 -to HEX54
set_location_assignment PIN_N19 -to HEX55
set_location_assignment PIN_N20 -to HEX56

# CUSTOM EXTERNAL HARDWARE (Mapped to GPIO pins)
# Keypad Rows/Cols
set_location_assignment PIN_AB2 -to KEYR0
set_location_assignment PIN_AB3 -to KEYR1
set_location_assignment PIN_AA5 -to KEYR2
set_location_assignment PIN_AA6 -to KEYR3
set_location_assignment PIN_Y5 -to KEYC0
set_location_assignment PIN_Y4 -to KEYC1
set_location_assignment PIN_Y3 -to KEYC2
set_location_assignment PIN_AA2 -to KEYC3

# Dot Matrix Rows
set_location_assignment PIN_AA8 -to DMR0
set_location_assignment PIN_AA10 -to DMR1
set_location_assignment PIN_W10 -to DMR2
set_location_assignment PIN_Y8 -to DMR3
set_location_assignment PIN_V7 -to DMR4
set_location_assignment PIN_W9 -to DMR5
set_location_assignment PIN_V8 -to DMR6
set_location_assignment PIN_W7 -to DMR7

# Dot Matrix Columns (0 and 1)
set_location_assignment PIN_AB13 -to DMC00
set_location_assignment PIN_AA14 -to DMC01
set_location_assignment PIN_W5 -to DMC02
set_location_assignment PIN_Y11 -to DMC03
set_location_assignment PIN_W6 -to DMC04
set_location_assignment PIN_AB12 -to DMC05
set_location_assignment PIN_W12 -to DMC06
set_location_assignment PIN_W13 -to DMC07

set_location_assignment PIN_AB10 -to DMC10
set_location_assignment PIN_AA15 -to DMC11
set_location_assignment PIN_V5 -to DMC12
set_location_assignment PIN_Y7 -to DMC13
set_location_assignment PIN_W8 -to DMC14
set_location_assignment PIN_AA9 -to DMC15
set_location_assignment PIN_AB11 -to DMC16
set_location_assignment PIN_W11 -to DMC17

# VGA
set_location_assignment PIN_AA1 -to VGA_R0
set_location_assignment PIN_V1 -to VGA_R1
set_location_assignment PIN_Y2 -to VGA_R2
set_location_assignment PIN_Y1 -to VGA_R3
set_location_assignment PIN_W1 -to VGA_G0
set_location_assignment PIN_T2 -to VGA_G1
set_location_assignment PIN_R2 -to VGA_G2
set_location_assignment PIN_R1 -to VGA_G3
set_location_assignment PIN_P1 -to VGA_B0
set_location_assignment PIN_T1 -to VGA_B1
set_location_assignment PIN_P4 -to VGA_B2
set_location_assignment PIN_N2 -to VGA_B3
set_location_assignment PIN_N3 -to VGA_HS
set_location_assignment PIN_N1 -to VGA_VS 
# Note: Fixed typo from 'VHA_VS' to 'VGA_VS'