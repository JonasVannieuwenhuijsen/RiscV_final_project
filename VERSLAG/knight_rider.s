#------------------------------------------------------------------------------
# Jeroen En Jonas 
# 
# Knight Rider
#------------------------------------------------------------------------------

# GPIO Base Addresses 
.equ GPIO_BASE_ADDRESS 0x40000000

# Offsets for GPIO peripherals
.equ LEDR      0x000
.equ SW        0x100
.equ KEY       0x200
.equ HEX0      0x300
.equ HEX1      0x304
.equ HEX2      0x308
.equ HEX3      0x30C
.equ HEX4      0x310
.equ HEX5      0x314
.equ HEX_VALUE 0x318
.equ HEX_MODE  0x31C

.text

    li t0, 0x40000000       # memory mapped peripherals base address
    li s1, 0x00A00000       # 10 485 760 (max counter)
    li s2, 0x00000001       # initialize rechter led
    li s3, 0x00000000       # boolean links of rechts (naar links = 0)
    li s4, 0x00000200       # Waarde meest linkse led
    li s5, 0x00000001       # Waarde meest rechtse led
    li s6, 0                # aantal keer knight rider (1 periode)
    sw s2, LEDR(t0)         # initialize leds
    sw s5, HEX_MODE(t0)     # initialize hexmode
    sw s6, HEX_VALUE(t0)    # initialize hex_value


    startcounter:
    li a0, 0                # counter op 0
    counter_loop:
    lw s7, SW(t0)           #lezen van de switch value

    # for (i = 0; i < max counter; i++) {
	bge a0, s1, exit_loop1	# i < max counter
    add a0, a0, s7          # i = i + switch value  
    j counter_loop

    exit_loop1:
    beq s3, zero, shiftleft   # kijk of je naar links of recht gaat
    beq s2, s5, changeToLeft  # wanneer op meest linkse led => verander van richting
    srli s2, s2, 1            # 1 led opschuiven naar rechts
    sw s2, LEDR(t0)           # store in LEDR
    j startcounter            # terug naar counter

    shiftleft:
    beq s2, s4, changeToRight # wanneer op meest rechtse led => verander van richting
    slli s2, s2, 1            # 1 led opschuiven
    sw s2, LEDR(t0)           # store in LEDR  
    j startcounter            # terug naar counter

    changeToRight:
    addi s3, s3, 1            # Boolean op 1
    j startcounter            # terug naar counter

    changeToLeft:
    addi s6, s6, 1            # periode++
    addi s3, s3, -1           # Boolean op 0
    sw s6, HEX_VALUE(t0)      # waarde schrijven naar hex_value
    j startcounter            # terug naar counter

