
bubble_sort.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_reset>:
   0:	80000117          	auipc	sp,0x80000
   4:	40010113          	addi	sp,sp,1024 # 80000400 <_stack_top>
   8:	00000293          	li	t0,0
   c:	00000313          	li	t1,0
  10:	00000393          	li	t2,0
  14:	00000e13          	li	t3,0
  18:	00000e93          	li	t4,0
  1c:	00000f13          	li	t5,0
  20:	00000f93          	li	t6,0
  24:	00000513          	li	a0,0
  28:	00000593          	li	a1,0
  2c:	00000613          	li	a2,0
  30:	00000693          	li	a3,0
  34:	00000713          	li	a4,0
  38:	00000793          	li	a5,0
  3c:	00000813          	li	a6,0
  40:	00000893          	li	a7,0
  44:	00000413          	li	s0,0
  48:	00000493          	li	s1,0
  4c:	00000913          	li	s2,0
  50:	00000993          	li	s3,0
  54:	00000a13          	li	s4,0
  58:	00000a93          	li	s5,0
  5c:	00000b13          	li	s6,0
  60:	00000b93          	li	s7,0
  64:	00000c13          	li	s8,0
  68:	00000c93          	li	s9,0
  6c:	00000d13          	li	s10,0
  70:	00000d93          	li	s11,0
  74:	00000193          	li	gp,0
  78:	00000213          	li	tp,0
  7c:	00000093          	li	ra,0
  80:	008000ef          	jal	88 <_start>
  84:	0000006f          	j	84 <_reset+0x84>

00000088 <_start>:
  88:	ff010113          	addi	sp,sp,-16
  8c:	00112623          	sw	ra,12(sp)
  90:	008000ef          	jal	98 <main>
  94:	0000006f          	j	94 <_start+0xc>

00000098 <main>:
  98:	800006b7          	lui	a3,0x80000
  9c:	00068693          	mv	a3,a3
  a0:	00000793          	li	a5,0
  a4:	06300513          	li	a0,99
  a8:	06400593          	li	a1,100
  ac:	00279713          	slli	a4,a5,0x2
  b0:	40f50633          	sub	a2,a0,a5
  b4:	00e68733          	add	a4,a3,a4
  b8:	00c72023          	sw	a2,0(a4)
  bc:	00178793          	addi	a5,a5,1
  c0:	feb796e3          	bne	a5,a1,ac <main+0x14>
  c4:	06300893          	li	a7,99
  c8:	00000713          	li	a4,0
  cc:	00000613          	li	a2,0
  d0:	00271793          	slli	a5,a4,0x2
  d4:	00170713          	addi	a4,a4,1
  d8:	00c68533          	add	a0,a3,a2
  dc:	00271613          	slli	a2,a4,0x2
  e0:	00c685b3          	add	a1,a3,a2
  e4:	00052803          	lw	a6,0(a0)
  e8:	0005a503          	lw	a0,0(a1)
  ec:	00f687b3          	add	a5,a3,a5
  f0:	01055a63          	bge	a0,a6,104 <main+0x6c>
  f4:	0007a503          	lw	a0,0(a5)
  f8:	0005a803          	lw	a6,0(a1)
  fc:	0107a023          	sw	a6,0(a5)
 100:	00a5a023          	sw	a0,0(a1)
 104:	fd1716e3          	bne	a4,a7,d0 <main+0x38>
 108:	fff70893          	addi	a7,a4,-1
 10c:	fa089ee3          	bnez	a7,c8 <main+0x30>
 110:	00008067          	ret
