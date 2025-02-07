# stub1.asm
# ENCM 369 Winter 2025
# This program has complete start-up and clean-up code, and a "stub"
# main function.

# BEGINNING of start-up & clean-up code.  Do NOT edit this code.
	.data
exit_msg_1:
	.asciz	"***About to exit. main returned "
exit_msg_2:
	.asciz	".***\n"
main_rv:
	.word	0
	
	.text
	# adjust sp, then call main
	andi	sp, sp, -32		# round sp down to multiple of 32
	jal	main
	
	# when main is done, print its return value, then halt the program
	sw	a0, main_rv, t0	
	la	a0, exit_msg_1
	li      a7, 4
	ecall
	lw	a0, main_rv
	li	a7, 1
	ecall
	la	a0, exit_msg_2
	li	a7, 4
	ecall
        lw      a0, main_rv
	addi	a7, zero, 93	# call for program exit with exit status that is in a0
	ecall
# END of start-up & clean-up code.

# Below is the stub for main. Edit it to give main the desired behaviour.

    .data
    .globl    banana
banana:
    .word     0x20000    
    
# int main(void)
#
# local variable register
# int apple	s0
# int orange	s1
	.text
	.globl	main
main:
	# prologue
	addi	sp, sp, -32
	sw	ra, 8(sp)
	sw	s1, 4(sp)
	sw	s0, 0(sp)
	
	# body
	addi	s0, zero, 0x600	# apple = 0x600
	addi	s1, zero, 0x700	# orange = 0x700
	
	addi	a0, zero, 5	# a0 = 5
	addi	a1, zero, 4	# a1 = 4
	addi	a2, zero, 3	# a2 = 3
	addi	a3, zero, 2	# a3 = 2
	jal	funcA
	add	s1, s1, a0	# orange += r.v. of funcA
	
	la	t0, banana	# t0 = &banana[0]
	lw	t1, (t0)	# t1 = *t0
	sub	t2, s0, s1	# t2 = apple - orange
	add	t1, t1, t2	# t1 += t2
	sw	t1, (t0)
	
	# epilogue
	lw	s0, 0(sp)
	lw	s1, 4(sp)
	lw	ra, 8(sp)
	addi	sp, sp, 32
	li      a0, 0   # return value from main = 0
	jr	ra

# int funcA(int first, int second, int third, int fourth)
#
# local variable register
# int car	s4
# int truck	s5
# int bus	s6
	.text
	.globl	funcA
funcA:
	# prologue
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s6, 24(sp)
	sw	s5, 20(sp)
	sw	s4, 16(sp)
	sw	s3, 12(sp)
	sw	s2, 8(sp)
	sw	s1, 4(sp)
	sw	s0, 0(sp)
	
	# body
	mv	s0, a0		# s0 = first
	mv	s1, a1		# s1 = second
	mv	s3, a3		# s3 = fourth
	mv	s2, a2		# s2 = third
	
	add	a0, zero, s3	# a0 = s3
	add	a1, zero, s2	# a1 = s2
	jal 	funcB
	add	s4, zero, a0	# car = r.v. of funcB(fourth, third)
	
	add	a0, zero, s1	# a0 = s1
	add	a1, zero, s0	# a1 = s0
	jal 	funcB
	add	s6, zero, a0	# bus = r.v. of funcB(second, first)
	
	add	a0, zero, s2	# a0 = s2
	add	a1, zero, s3	# a1 = s3
	jal 	funcB
	add	s5, zero, a0	# truck = r.v. of funcB(third, fourth)
	
	add	t0, s4, s5	# t0 = car + truck
	add	a0, t0, s6	# a0 = t0 + bus
	
	# epilogue
	lw	s0, 0(sp)
	lw	s1, 4(sp)
	lw	s2, 8(sp)
	lw	s3, 12(sp)
	lw	s4, 16(sp)
	lw	s5, 20(sp)
	lw	s6, 24(sp)
	lw	ra, 28(sp)
	addi	sp, sp, 32
	jr	ra
	
# int funcB(int y, int z)
	.text
	.globl	funcB
funcB:
	slli	t0, a1, 6	# t0 = z * 64
	add	a0, a0, t0	# t1 = y + t0
	jr 	ra
