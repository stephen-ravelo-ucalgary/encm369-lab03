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

	.data
	.globl	aaa
aaa:	.word	11, 11, 3, -11, 11
	.globl	bbb
bbb:	.word	200, -300, 400, 500
	.globl	ccc
ccc:	.word	-3, -4, 3, 2, 3, 4

# Below is the stub for main. Edit it to give main the desired behaviour.

# int main(void)
#
# local variable register
# int alpha	s0
# int beta	s1
# int gamma	s2
	.text
	.globl	main
main:
	# prologue
	addi	sp, sp, -32
	sw	ra, 12(sp)
	sw	s2, 8(sp)
	sw	s1, 4(sp)
	sw	s0, 0(sp)
	
	# body
	addi	s2, zero, 2000
	
	la	a0, aaa		# a0 = &aaa[0]
	addi	a1, zero, 5	# a1 = 5
	addi	a2, zero, 10	# a2 = 10
	jal	sum_of_sats	
	add	s0, zero, a0	# alpha = r.v. of sum_of_sats
	
	la	a0, bbb		# a0 = &bbb[0]
	addi	a1, zero, 4	# a1 = 4
	addi	a2, zero, 300	# a2 = 300
	jal	sum_of_sats
	add	s1, zero, a0	# beta = r.v. of sum_of_sats
	
	la	a0, ccc		# a0 = &ccc[0]
	addi	a1, zero, 6	# a1 = 6
	addi	a2, zero, 3	# a2 = 3
	jal	sum_of_sats
	add	t0, s0, s1	# t0 = alpha + beta
	add	t1, t0, a0	# t1 = t0 + r.v. of sum_of_sats
	add	s2, s2, t1	# gamma += t1
	
	# epilogue
	lw	s0, 0(sp)
	lw	s1, 4(sp)
	lw	s2, 8(sp)
	lw	ra, 12(sp)
	addi	sp, sp, 32
	li      a0, 0   # return value from main = 0
	jr	ra
	
# int sat(int b, int x)
	.text
	.globl	sat
sat:
	sub	t0, zero, a0	# t0 = -b
	bge	a1, t0, L3	# if (x >= -b) goto L3
	add	a0, t0, zero	# a0 = -b
	j	L4
L3:
	ble	a1, a0, L4	# if (x > b) goto L4
	add	a0, a1, zero	# a0 = x
L4:
	jr	ra

# int sum_of_sats(const int *a, int n, int max_mag)
#
# local variable register
# int result	s3
	.text
	.globl	sum_of_sats
sum_of_sats:
	# prologue
	addi	sp, sp, -32
	sw	ra, 16(sp)
	sw	s3, 12(sp)
	sw	s2, 8(sp)
	sw	s1, 4(sp)
	sw	s0, 0(sp)
	mv	s0, a0		# s0 = &a[0]
	mv	s1, a1		# s1 = n
	mv	s2, a2		# s2 = max_mag
	
	# body
	add	s3, zero, zero	# result = 0
	ble	s1, zero, L1	# if (n <= 0) goto L1
	addi	s1, s1, -1	# n--
L2:	
	add	a0, zero, s2	# a0 = max_mag
	slli	t0, s1, 2	# t0 = n << 2
	add	t1, s0, t0	# t1 = &a[n]
	lw	a1, (t1)	# a1 = a[n]
	jal	sat
	add	s3, s3, a0	# result += r.v. of sat
	addi	s1, s1, -1	# n--
	bge	s1, zero, L2	# if (n >= 0) goto L2
	mv	a0, s3		# a0 = result
	
L1:	
	# epilogue
	lw	s0, 0(sp)
	lw	s1, 4(sp)
	lw	s2, 8(sp)
	lw	s3, 12(sp)
	lw	ra, 16(sp)
	addi	sp, sp, 32
	jr	ra
