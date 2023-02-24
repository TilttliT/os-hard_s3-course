
user/_alloctest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test0>:
#include "kernel/riscv.h"
#include "kernel/fcntl.h"
#include "kernel/memlayout.h"
#include "user/user.h"

void test0() {
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	ec56                	sd	s5,24(sp)
  10:	0880                	addi	s0,sp,80
  enum { NCHILD = 50, NFD = 10 };
  int i, j;
  int fd;

  printf("filetest: start\n");
  12:	00001517          	auipc	a0,0x1
  16:	9fe50513          	addi	a0,a0,-1538 # a10 <malloc+0xec>
  1a:	00001097          	auipc	ra,0x1
  1e:	852080e7          	jalr	-1966(ra) # 86c <printf>
  22:	03200493          	li	s1,50
    printf("test setup is wrong\n");
    exit(1);
  }

  for (i = 0; i < NCHILD; i++) {
    int pid = fork();
  26:	00000097          	auipc	ra,0x0
  2a:	4c4080e7          	jalr	1220(ra) # 4ea <fork>
    if (pid < 0) {
  2e:	00054f63          	bltz	a0,4c <test0+0x4c>
      printf("fork failed");
      exit(1);
    }
    if (pid == 0) {
  32:	c915                	beqz	a0,66 <test0+0x66>
  for (i = 0; i < NCHILD; i++) {
  34:	34fd                	addiw	s1,s1,-1
  36:	f8e5                	bnez	s1,26 <test0+0x26>
  38:	03200493          	li	s1,50
      sleep(10);
      exit(0);  // no errors; exit with 0.
    }
  }

  int all_ok = 1;
  3c:	4905                	li	s2,1
  for (int i = 0; i < NCHILD; i++) {
    int xstatus;
    wait(&xstatus);
    if (xstatus != 0) {
      if (all_ok == 1) printf("filetest: FAILED\n");
  3e:	4985                	li	s3,1
  40:	00001a97          	auipc	s5,0x1
  44:	a08a8a93          	addi	s5,s5,-1528 # a48 <malloc+0x124>
      all_ok = 0;
  48:	4a01                	li	s4,0
  4a:	a8b1                	j	a6 <test0+0xa6>
      printf("fork failed");
  4c:	00001517          	auipc	a0,0x1
  50:	9dc50513          	addi	a0,a0,-1572 # a28 <malloc+0x104>
  54:	00001097          	auipc	ra,0x1
  58:	818080e7          	jalr	-2024(ra) # 86c <printf>
      exit(1);
  5c:	4505                	li	a0,1
  5e:	00000097          	auipc	ra,0x0
  62:	494080e7          	jalr	1172(ra) # 4f2 <exit>
  66:	44a9                	li	s1,10
        if ((fd = open("xv6-readme", O_RDONLY)) < 0) {
  68:	00001917          	auipc	s2,0x1
  6c:	9d090913          	addi	s2,s2,-1584 # a38 <malloc+0x114>
  70:	4581                	li	a1,0
  72:	854a                	mv	a0,s2
  74:	00000097          	auipc	ra,0x0
  78:	4be080e7          	jalr	1214(ra) # 532 <open>
  7c:	00054e63          	bltz	a0,98 <test0+0x98>
      for (j = 0; j < NFD; j++) {
  80:	34fd                	addiw	s1,s1,-1
  82:	f4fd                	bnez	s1,70 <test0+0x70>
      sleep(10);
  84:	4529                	li	a0,10
  86:	00000097          	auipc	ra,0x0
  8a:	4fc080e7          	jalr	1276(ra) # 582 <sleep>
      exit(0);  // no errors; exit with 0.
  8e:	4501                	li	a0,0
  90:	00000097          	auipc	ra,0x0
  94:	462080e7          	jalr	1122(ra) # 4f2 <exit>
          exit(1);
  98:	4505                	li	a0,1
  9a:	00000097          	auipc	ra,0x0
  9e:	458080e7          	jalr	1112(ra) # 4f2 <exit>
  for (int i = 0; i < NCHILD; i++) {
  a2:	34fd                	addiw	s1,s1,-1
  a4:	c09d                	beqz	s1,ca <test0+0xca>
    wait(&xstatus);
  a6:	fbc40513          	addi	a0,s0,-68
  aa:	00000097          	auipc	ra,0x0
  ae:	450080e7          	jalr	1104(ra) # 4fa <wait>
    if (xstatus != 0) {
  b2:	fbc42783          	lw	a5,-68(s0)
  b6:	d7f5                	beqz	a5,a2 <test0+0xa2>
      if (all_ok == 1) printf("filetest: FAILED\n");
  b8:	ff3915e3          	bne	s2,s3,a2 <test0+0xa2>
  bc:	8556                	mv	a0,s5
  be:	00000097          	auipc	ra,0x0
  c2:	7ae080e7          	jalr	1966(ra) # 86c <printf>
      all_ok = 0;
  c6:	8952                	mv	s2,s4
  c8:	bfe9                	j	a2 <test0+0xa2>
    }
  }

  if (all_ok) printf("filetest: OK\n");
  ca:	00091b63          	bnez	s2,e0 <test0+0xe0>
}
  ce:	60a6                	ld	ra,72(sp)
  d0:	6406                	ld	s0,64(sp)
  d2:	74e2                	ld	s1,56(sp)
  d4:	7942                	ld	s2,48(sp)
  d6:	79a2                	ld	s3,40(sp)
  d8:	7a02                	ld	s4,32(sp)
  da:	6ae2                	ld	s5,24(sp)
  dc:	6161                	addi	sp,sp,80
  de:	8082                	ret
  if (all_ok) printf("filetest: OK\n");
  e0:	00001517          	auipc	a0,0x1
  e4:	98050513          	addi	a0,a0,-1664 # a60 <malloc+0x13c>
  e8:	00000097          	auipc	ra,0x0
  ec:	784080e7          	jalr	1924(ra) # 86c <printf>
}
  f0:	bff9                	j	ce <test0+0xce>

00000000000000f2 <test1>:

// Allocate all free memory and count how it is
void test1() {
  f2:	7139                	addi	sp,sp,-64
  f4:	fc06                	sd	ra,56(sp)
  f6:	f822                	sd	s0,48(sp)
  f8:	f426                	sd	s1,40(sp)
  fa:	f04a                	sd	s2,32(sp)
  fc:	ec4e                	sd	s3,24(sp)
  fe:	0080                	addi	s0,sp,64
  void *a;
  int tot = 0;
  char buf[1];
  int fds[2];

  printf("memtest: start\n");
 100:	00001517          	auipc	a0,0x1
 104:	97050513          	addi	a0,a0,-1680 # a70 <malloc+0x14c>
 108:	00000097          	auipc	ra,0x0
 10c:	764080e7          	jalr	1892(ra) # 86c <printf>
  if (pipe(fds) != 0) {
 110:	fc040513          	addi	a0,s0,-64
 114:	00000097          	auipc	ra,0x0
 118:	3ee080e7          	jalr	1006(ra) # 502 <pipe>
 11c:	e525                	bnez	a0,184 <test1+0x92>
 11e:	84aa                	mv	s1,a0
    printf("pipe() failed\n");
    exit(1);
  }
  int pid = fork();
 120:	00000097          	auipc	ra,0x0
 124:	3ca080e7          	jalr	970(ra) # 4ea <fork>
  if (pid < 0) {
 128:	06054b63          	bltz	a0,19e <test1+0xac>
    printf("fork failed");
    exit(1);
  }
  if (pid == 0) {
 12c:	e959                	bnez	a0,1c2 <test1+0xd0>
    close(fds[0]);
 12e:	fc042503          	lw	a0,-64(s0)
 132:	00000097          	auipc	ra,0x0
 136:	3e8080e7          	jalr	1000(ra) # 51a <close>
    while (1) {
      a = sbrk(PGSIZE);
      if (a == (char *)0xffffffffffffffffL) exit(0);
 13a:	597d                	li	s2,-1
      *(int *)(a + 4) = 1;
 13c:	4485                	li	s1,1
      if (write(fds[1], "x", 1) != 1) {
 13e:	00001997          	auipc	s3,0x1
 142:	95298993          	addi	s3,s3,-1710 # a90 <malloc+0x16c>
      a = sbrk(PGSIZE);
 146:	6505                	lui	a0,0x1
 148:	00000097          	auipc	ra,0x0
 14c:	432080e7          	jalr	1074(ra) # 57a <sbrk>
      if (a == (char *)0xffffffffffffffffL) exit(0);
 150:	07250463          	beq	a0,s2,1b8 <test1+0xc6>
      *(int *)(a + 4) = 1;
 154:	c144                	sw	s1,4(a0)
      if (write(fds[1], "x", 1) != 1) {
 156:	8626                	mv	a2,s1
 158:	85ce                	mv	a1,s3
 15a:	fc442503          	lw	a0,-60(s0)
 15e:	00000097          	auipc	ra,0x0
 162:	3b4080e7          	jalr	948(ra) # 512 <write>
 166:	fe9500e3          	beq	a0,s1,146 <test1+0x54>
        printf("write failed");
 16a:	00001517          	auipc	a0,0x1
 16e:	92e50513          	addi	a0,a0,-1746 # a98 <malloc+0x174>
 172:	00000097          	auipc	ra,0x0
 176:	6fa080e7          	jalr	1786(ra) # 86c <printf>
        exit(1);
 17a:	4505                	li	a0,1
 17c:	00000097          	auipc	ra,0x0
 180:	376080e7          	jalr	886(ra) # 4f2 <exit>
    printf("pipe() failed\n");
 184:	00001517          	auipc	a0,0x1
 188:	8fc50513          	addi	a0,a0,-1796 # a80 <malloc+0x15c>
 18c:	00000097          	auipc	ra,0x0
 190:	6e0080e7          	jalr	1760(ra) # 86c <printf>
    exit(1);
 194:	4505                	li	a0,1
 196:	00000097          	auipc	ra,0x0
 19a:	35c080e7          	jalr	860(ra) # 4f2 <exit>
    printf("fork failed");
 19e:	00001517          	auipc	a0,0x1
 1a2:	88a50513          	addi	a0,a0,-1910 # a28 <malloc+0x104>
 1a6:	00000097          	auipc	ra,0x0
 1aa:	6c6080e7          	jalr	1734(ra) # 86c <printf>
    exit(1);
 1ae:	4505                	li	a0,1
 1b0:	00000097          	auipc	ra,0x0
 1b4:	342080e7          	jalr	834(ra) # 4f2 <exit>
      if (a == (char *)0xffffffffffffffffL) exit(0);
 1b8:	4501                	li	a0,0
 1ba:	00000097          	auipc	ra,0x0
 1be:	338080e7          	jalr	824(ra) # 4f2 <exit>
      }
    }
    exit(0);
  }
  close(fds[1]);
 1c2:	fc442503          	lw	a0,-60(s0)
 1c6:	00000097          	auipc	ra,0x0
 1ca:	354080e7          	jalr	852(ra) # 51a <close>
  while (1) {
    if (read(fds[0], buf, 1) != 1) {
 1ce:	4605                	li	a2,1
 1d0:	fc840593          	addi	a1,s0,-56
 1d4:	fc042503          	lw	a0,-64(s0)
 1d8:	00000097          	auipc	ra,0x0
 1dc:	332080e7          	jalr	818(ra) # 50a <read>
 1e0:	4785                	li	a5,1
 1e2:	00f51463          	bne	a0,a5,1ea <test1+0xf8>
      break;
    } else {
      tot += 1;
 1e6:	2485                	addiw	s1,s1,1
    if (read(fds[0], buf, 1) != 1) {
 1e8:	b7dd                	j	1ce <test1+0xdc>
    }
  }
  int n = (PHYSTOP - KERNBASE) / PGSIZE;
  printf("allocated %d out of %d pages\n", tot, n);
 1ea:	6621                	lui	a2,0x8
 1ec:	85a6                	mv	a1,s1
 1ee:	00001517          	auipc	a0,0x1
 1f2:	8ba50513          	addi	a0,a0,-1862 # aa8 <malloc+0x184>
 1f6:	00000097          	auipc	ra,0x0
 1fa:	676080e7          	jalr	1654(ra) # 86c <printf>
  if (tot < 31950) {
 1fe:	67a1                	lui	a5,0x8
 200:	ccd78793          	addi	a5,a5,-819 # 7ccd <base+0x6cbd>
 204:	0297ca63          	blt	a5,s1,238 <test1+0x146>
    printf("expected to allocate at least 31950, only got %d\n", tot);
 208:	85a6                	mv	a1,s1
 20a:	00001517          	auipc	a0,0x1
 20e:	8be50513          	addi	a0,a0,-1858 # ac8 <malloc+0x1a4>
 212:	00000097          	auipc	ra,0x0
 216:	65a080e7          	jalr	1626(ra) # 86c <printf>
    printf("memtest: FAILED\n");
 21a:	00001517          	auipc	a0,0x1
 21e:	8e650513          	addi	a0,a0,-1818 # b00 <malloc+0x1dc>
 222:	00000097          	auipc	ra,0x0
 226:	64a080e7          	jalr	1610(ra) # 86c <printf>
  } else {
    printf("memtest: OK\n");
  }
}
 22a:	70e2                	ld	ra,56(sp)
 22c:	7442                	ld	s0,48(sp)
 22e:	74a2                	ld	s1,40(sp)
 230:	7902                	ld	s2,32(sp)
 232:	69e2                	ld	s3,24(sp)
 234:	6121                	addi	sp,sp,64
 236:	8082                	ret
    printf("memtest: OK\n");
 238:	00001517          	auipc	a0,0x1
 23c:	8e050513          	addi	a0,a0,-1824 # b18 <malloc+0x1f4>
 240:	00000097          	auipc	ra,0x0
 244:	62c080e7          	jalr	1580(ra) # 86c <printf>
}
 248:	b7cd                	j	22a <test1+0x138>

000000000000024a <main>:

int main(int argc, char *argv[]) {
 24a:	1141                	addi	sp,sp,-16
 24c:	e406                	sd	ra,8(sp)
 24e:	e022                	sd	s0,0(sp)
 250:	0800                	addi	s0,sp,16
  test0();
 252:	00000097          	auipc	ra,0x0
 256:	dae080e7          	jalr	-594(ra) # 0 <test0>
  test1();
 25a:	00000097          	auipc	ra,0x0
 25e:	e98080e7          	jalr	-360(ra) # f2 <test1>
  exit(0);
 262:	4501                	li	a0,0
 264:	00000097          	auipc	ra,0x0
 268:	28e080e7          	jalr	654(ra) # 4f2 <exit>

000000000000026c <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
 26c:	1141                	addi	sp,sp,-16
 26e:	e406                	sd	ra,8(sp)
 270:	e022                	sd	s0,0(sp)
 272:	0800                	addi	s0,sp,16
  extern int main();
  main();
 274:	00000097          	auipc	ra,0x0
 278:	fd6080e7          	jalr	-42(ra) # 24a <main>
  exit(0);
 27c:	4501                	li	a0,0
 27e:	00000097          	auipc	ra,0x0
 282:	274080e7          	jalr	628(ra) # 4f2 <exit>

0000000000000286 <strcpy>:
}

char *strcpy(char *s, const char *t) {
 286:	1141                	addi	sp,sp,-16
 288:	e422                	sd	s0,8(sp)
 28a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 28c:	87aa                	mv	a5,a0
 28e:	0585                	addi	a1,a1,1
 290:	0785                	addi	a5,a5,1
 292:	fff5c703          	lbu	a4,-1(a1)
 296:	fee78fa3          	sb	a4,-1(a5)
 29a:	fb75                	bnez	a4,28e <strcpy+0x8>
    ;
  return os;
}
 29c:	6422                	ld	s0,8(sp)
 29e:	0141                	addi	sp,sp,16
 2a0:	8082                	ret

00000000000002a2 <strcmp>:

int strcmp(const char *p, const char *q) {
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e422                	sd	s0,8(sp)
 2a6:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
 2a8:	00054783          	lbu	a5,0(a0)
 2ac:	cb91                	beqz	a5,2c0 <strcmp+0x1e>
 2ae:	0005c703          	lbu	a4,0(a1)
 2b2:	00f71763          	bne	a4,a5,2c0 <strcmp+0x1e>
 2b6:	0505                	addi	a0,a0,1
 2b8:	0585                	addi	a1,a1,1
 2ba:	00054783          	lbu	a5,0(a0)
 2be:	fbe5                	bnez	a5,2ae <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2c0:	0005c503          	lbu	a0,0(a1)
}
 2c4:	40a7853b          	subw	a0,a5,a0
 2c8:	6422                	ld	s0,8(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret

00000000000002ce <strlen>:

uint strlen(const char *s) {
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e422                	sd	s0,8(sp)
 2d2:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 2d4:	00054783          	lbu	a5,0(a0)
 2d8:	cf91                	beqz	a5,2f4 <strlen+0x26>
 2da:	0505                	addi	a0,a0,1
 2dc:	87aa                	mv	a5,a0
 2de:	4685                	li	a3,1
 2e0:	9e89                	subw	a3,a3,a0
 2e2:	00f6853b          	addw	a0,a3,a5
 2e6:	0785                	addi	a5,a5,1
 2e8:	fff7c703          	lbu	a4,-1(a5)
 2ec:	fb7d                	bnez	a4,2e2 <strlen+0x14>
    ;
  return n;
}
 2ee:	6422                	ld	s0,8(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret
  for (n = 0; s[n]; n++)
 2f4:	4501                	li	a0,0
 2f6:	bfe5                	j	2ee <strlen+0x20>

00000000000002f8 <memset>:

void *memset(void *dst, int c, uint n) {
 2f8:	1141                	addi	sp,sp,-16
 2fa:	e422                	sd	s0,8(sp)
 2fc:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 2fe:	ca19                	beqz	a2,314 <memset+0x1c>
 300:	87aa                	mv	a5,a0
 302:	1602                	slli	a2,a2,0x20
 304:	9201                	srli	a2,a2,0x20
 306:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 30a:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 30e:	0785                	addi	a5,a5,1
 310:	fee79de3          	bne	a5,a4,30a <memset+0x12>
  }
  return dst;
}
 314:	6422                	ld	s0,8(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret

000000000000031a <strchr>:

char *strchr(const char *s, char c) {
 31a:	1141                	addi	sp,sp,-16
 31c:	e422                	sd	s0,8(sp)
 31e:	0800                	addi	s0,sp,16
  for (; *s; s++)
 320:	00054783          	lbu	a5,0(a0)
 324:	cb99                	beqz	a5,33a <strchr+0x20>
    if (*s == c) return (char *)s;
 326:	00f58763          	beq	a1,a5,334 <strchr+0x1a>
  for (; *s; s++)
 32a:	0505                	addi	a0,a0,1
 32c:	00054783          	lbu	a5,0(a0)
 330:	fbfd                	bnez	a5,326 <strchr+0xc>
  return 0;
 332:	4501                	li	a0,0
}
 334:	6422                	ld	s0,8(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret
  return 0;
 33a:	4501                	li	a0,0
 33c:	bfe5                	j	334 <strchr+0x1a>

000000000000033e <gets>:

char *gets(char *buf, int max) {
 33e:	711d                	addi	sp,sp,-96
 340:	ec86                	sd	ra,88(sp)
 342:	e8a2                	sd	s0,80(sp)
 344:	e4a6                	sd	s1,72(sp)
 346:	e0ca                	sd	s2,64(sp)
 348:	fc4e                	sd	s3,56(sp)
 34a:	f852                	sd	s4,48(sp)
 34c:	f456                	sd	s5,40(sp)
 34e:	f05a                	sd	s6,32(sp)
 350:	ec5e                	sd	s7,24(sp)
 352:	1080                	addi	s0,sp,96
 354:	8baa                	mv	s7,a0
 356:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 358:	892a                	mv	s2,a0
 35a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 35c:	4aa9                	li	s5,10
 35e:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 360:	89a6                	mv	s3,s1
 362:	2485                	addiw	s1,s1,1
 364:	0344d863          	bge	s1,s4,394 <gets+0x56>
    cc = read(0, &c, 1);
 368:	4605                	li	a2,1
 36a:	faf40593          	addi	a1,s0,-81
 36e:	4501                	li	a0,0
 370:	00000097          	auipc	ra,0x0
 374:	19a080e7          	jalr	410(ra) # 50a <read>
    if (cc < 1) break;
 378:	00a05e63          	blez	a0,394 <gets+0x56>
    buf[i++] = c;
 37c:	faf44783          	lbu	a5,-81(s0)
 380:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 384:	01578763          	beq	a5,s5,392 <gets+0x54>
 388:	0905                	addi	s2,s2,1
 38a:	fd679be3          	bne	a5,s6,360 <gets+0x22>
  for (i = 0; i + 1 < max;) {
 38e:	89a6                	mv	s3,s1
 390:	a011                	j	394 <gets+0x56>
 392:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 394:	99de                	add	s3,s3,s7
 396:	00098023          	sb	zero,0(s3)
  return buf;
}
 39a:	855e                	mv	a0,s7
 39c:	60e6                	ld	ra,88(sp)
 39e:	6446                	ld	s0,80(sp)
 3a0:	64a6                	ld	s1,72(sp)
 3a2:	6906                	ld	s2,64(sp)
 3a4:	79e2                	ld	s3,56(sp)
 3a6:	7a42                	ld	s4,48(sp)
 3a8:	7aa2                	ld	s5,40(sp)
 3aa:	7b02                	ld	s6,32(sp)
 3ac:	6be2                	ld	s7,24(sp)
 3ae:	6125                	addi	sp,sp,96
 3b0:	8082                	ret

00000000000003b2 <stat>:

int stat(const char *n, struct stat *st) {
 3b2:	1101                	addi	sp,sp,-32
 3b4:	ec06                	sd	ra,24(sp)
 3b6:	e822                	sd	s0,16(sp)
 3b8:	e426                	sd	s1,8(sp)
 3ba:	e04a                	sd	s2,0(sp)
 3bc:	1000                	addi	s0,sp,32
 3be:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3c0:	4581                	li	a1,0
 3c2:	00000097          	auipc	ra,0x0
 3c6:	170080e7          	jalr	368(ra) # 532 <open>
  if (fd < 0) return -1;
 3ca:	02054563          	bltz	a0,3f4 <stat+0x42>
 3ce:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 3d0:	85ca                	mv	a1,s2
 3d2:	00000097          	auipc	ra,0x0
 3d6:	178080e7          	jalr	376(ra) # 54a <fstat>
 3da:	892a                	mv	s2,a0
  close(fd);
 3dc:	8526                	mv	a0,s1
 3de:	00000097          	auipc	ra,0x0
 3e2:	13c080e7          	jalr	316(ra) # 51a <close>
  return r;
}
 3e6:	854a                	mv	a0,s2
 3e8:	60e2                	ld	ra,24(sp)
 3ea:	6442                	ld	s0,16(sp)
 3ec:	64a2                	ld	s1,8(sp)
 3ee:	6902                	ld	s2,0(sp)
 3f0:	6105                	addi	sp,sp,32
 3f2:	8082                	ret
  if (fd < 0) return -1;
 3f4:	597d                	li	s2,-1
 3f6:	bfc5                	j	3e6 <stat+0x34>

00000000000003f8 <atoi>:

int atoi(const char *s) {
 3f8:	1141                	addi	sp,sp,-16
 3fa:	e422                	sd	s0,8(sp)
 3fc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 3fe:	00054683          	lbu	a3,0(a0)
 402:	fd06879b          	addiw	a5,a3,-48
 406:	0ff7f793          	zext.b	a5,a5
 40a:	4625                	li	a2,9
 40c:	02f66863          	bltu	a2,a5,43c <atoi+0x44>
 410:	872a                	mv	a4,a0
  n = 0;
 412:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 414:	0705                	addi	a4,a4,1
 416:	0025179b          	slliw	a5,a0,0x2
 41a:	9fa9                	addw	a5,a5,a0
 41c:	0017979b          	slliw	a5,a5,0x1
 420:	9fb5                	addw	a5,a5,a3
 422:	fd07851b          	addiw	a0,a5,-48
 426:	00074683          	lbu	a3,0(a4)
 42a:	fd06879b          	addiw	a5,a3,-48
 42e:	0ff7f793          	zext.b	a5,a5
 432:	fef671e3          	bgeu	a2,a5,414 <atoi+0x1c>
  return n;
}
 436:	6422                	ld	s0,8(sp)
 438:	0141                	addi	sp,sp,16
 43a:	8082                	ret
  n = 0;
 43c:	4501                	li	a0,0
 43e:	bfe5                	j	436 <atoi+0x3e>

0000000000000440 <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 440:	1141                	addi	sp,sp,-16
 442:	e422                	sd	s0,8(sp)
 444:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 446:	02b57463          	bgeu	a0,a1,46e <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 44a:	00c05f63          	blez	a2,468 <memmove+0x28>
 44e:	1602                	slli	a2,a2,0x20
 450:	9201                	srli	a2,a2,0x20
 452:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 456:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 458:	0585                	addi	a1,a1,1
 45a:	0705                	addi	a4,a4,1
 45c:	fff5c683          	lbu	a3,-1(a1)
 460:	fed70fa3          	sb	a3,-1(a4)
 464:	fee79ae3          	bne	a5,a4,458 <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 468:	6422                	ld	s0,8(sp)
 46a:	0141                	addi	sp,sp,16
 46c:	8082                	ret
    dst += n;
 46e:	00c50733          	add	a4,a0,a2
    src += n;
 472:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 474:	fec05ae3          	blez	a2,468 <memmove+0x28>
 478:	fff6079b          	addiw	a5,a2,-1 # 7fff <base+0x6fef>
 47c:	1782                	slli	a5,a5,0x20
 47e:	9381                	srli	a5,a5,0x20
 480:	fff7c793          	not	a5,a5
 484:	97ba                	add	a5,a5,a4
 486:	15fd                	addi	a1,a1,-1
 488:	177d                	addi	a4,a4,-1
 48a:	0005c683          	lbu	a3,0(a1)
 48e:	00d70023          	sb	a3,0(a4)
 492:	fee79ae3          	bne	a5,a4,486 <memmove+0x46>
 496:	bfc9                	j	468 <memmove+0x28>

0000000000000498 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 498:	1141                	addi	sp,sp,-16
 49a:	e422                	sd	s0,8(sp)
 49c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 49e:	ca05                	beqz	a2,4ce <memcmp+0x36>
 4a0:	fff6069b          	addiw	a3,a2,-1
 4a4:	1682                	slli	a3,a3,0x20
 4a6:	9281                	srli	a3,a3,0x20
 4a8:	0685                	addi	a3,a3,1
 4aa:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4ac:	00054783          	lbu	a5,0(a0)
 4b0:	0005c703          	lbu	a4,0(a1)
 4b4:	00e79863          	bne	a5,a4,4c4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4b8:	0505                	addi	a0,a0,1
    p2++;
 4ba:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4bc:	fed518e3          	bne	a0,a3,4ac <memcmp+0x14>
  }
  return 0;
 4c0:	4501                	li	a0,0
 4c2:	a019                	j	4c8 <memcmp+0x30>
      return *p1 - *p2;
 4c4:	40e7853b          	subw	a0,a5,a4
}
 4c8:	6422                	ld	s0,8(sp)
 4ca:	0141                	addi	sp,sp,16
 4cc:	8082                	ret
  return 0;
 4ce:	4501                	li	a0,0
 4d0:	bfe5                	j	4c8 <memcmp+0x30>

00000000000004d2 <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 4d2:	1141                	addi	sp,sp,-16
 4d4:	e406                	sd	ra,8(sp)
 4d6:	e022                	sd	s0,0(sp)
 4d8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4da:	00000097          	auipc	ra,0x0
 4de:	f66080e7          	jalr	-154(ra) # 440 <memmove>
}
 4e2:	60a2                	ld	ra,8(sp)
 4e4:	6402                	ld	s0,0(sp)
 4e6:	0141                	addi	sp,sp,16
 4e8:	8082                	ret

00000000000004ea <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ea:	4885                	li	a7,1
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4f2:	4889                	li	a7,2
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <wait>:
.global wait
wait:
 li a7, SYS_wait
 4fa:	488d                	li	a7,3
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 502:	4891                	li	a7,4
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <read>:
.global read
read:
 li a7, SYS_read
 50a:	4895                	li	a7,5
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <write>:
.global write
write:
 li a7, SYS_write
 512:	48c1                	li	a7,16
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <close>:
.global close
close:
 li a7, SYS_close
 51a:	48d5                	li	a7,21
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <kill>:
.global kill
kill:
 li a7, SYS_kill
 522:	4899                	li	a7,6
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <exec>:
.global exec
exec:
 li a7, SYS_exec
 52a:	489d                	li	a7,7
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <open>:
.global open
open:
 li a7, SYS_open
 532:	48bd                	li	a7,15
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 53a:	48c5                	li	a7,17
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 542:	48c9                	li	a7,18
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 54a:	48a1                	li	a7,8
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <link>:
.global link
link:
 li a7, SYS_link
 552:	48cd                	li	a7,19
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 55a:	48d1                	li	a7,20
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 562:	48a5                	li	a7,9
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <dup>:
.global dup
dup:
 li a7, SYS_dup
 56a:	48a9                	li	a7,10
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 572:	48ad                	li	a7,11
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 57a:	48b1                	li	a7,12
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 582:	48b5                	li	a7,13
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 58a:	48b9                	li	a7,14
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <putc>:

#include <stdarg.h>

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 592:	1101                	addi	sp,sp,-32
 594:	ec06                	sd	ra,24(sp)
 596:	e822                	sd	s0,16(sp)
 598:	1000                	addi	s0,sp,32
 59a:	feb407a3          	sb	a1,-17(s0)
 59e:	4605                	li	a2,1
 5a0:	fef40593          	addi	a1,s0,-17
 5a4:	00000097          	auipc	ra,0x0
 5a8:	f6e080e7          	jalr	-146(ra) # 512 <write>
 5ac:	60e2                	ld	ra,24(sp)
 5ae:	6442                	ld	s0,16(sp)
 5b0:	6105                	addi	sp,sp,32
 5b2:	8082                	ret

00000000000005b4 <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 5b4:	7139                	addi	sp,sp,-64
 5b6:	fc06                	sd	ra,56(sp)
 5b8:	f822                	sd	s0,48(sp)
 5ba:	f426                	sd	s1,40(sp)
 5bc:	f04a                	sd	s2,32(sp)
 5be:	ec4e                	sd	s3,24(sp)
 5c0:	0080                	addi	s0,sp,64
 5c2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 5c4:	c299                	beqz	a3,5ca <printint+0x16>
 5c6:	0805c963          	bltz	a1,658 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5ca:	2581                	sext.w	a1,a1
  neg = 0;
 5cc:	4881                	li	a7,0
 5ce:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5d2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 5d4:	2601                	sext.w	a2,a2
 5d6:	00000517          	auipc	a0,0x0
 5da:	5b250513          	addi	a0,a0,1458 # b88 <digits>
 5de:	883a                	mv	a6,a4
 5e0:	2705                	addiw	a4,a4,1
 5e2:	02c5f7bb          	remuw	a5,a1,a2
 5e6:	1782                	slli	a5,a5,0x20
 5e8:	9381                	srli	a5,a5,0x20
 5ea:	97aa                	add	a5,a5,a0
 5ec:	0007c783          	lbu	a5,0(a5)
 5f0:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 5f4:	0005879b          	sext.w	a5,a1
 5f8:	02c5d5bb          	divuw	a1,a1,a2
 5fc:	0685                	addi	a3,a3,1
 5fe:	fec7f0e3          	bgeu	a5,a2,5de <printint+0x2a>
  if (neg) buf[i++] = '-';
 602:	00088c63          	beqz	a7,61a <printint+0x66>
 606:	fd070793          	addi	a5,a4,-48
 60a:	00878733          	add	a4,a5,s0
 60e:	02d00793          	li	a5,45
 612:	fef70823          	sb	a5,-16(a4)
 616:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 61a:	02e05863          	blez	a4,64a <printint+0x96>
 61e:	fc040793          	addi	a5,s0,-64
 622:	00e78933          	add	s2,a5,a4
 626:	fff78993          	addi	s3,a5,-1
 62a:	99ba                	add	s3,s3,a4
 62c:	377d                	addiw	a4,a4,-1
 62e:	1702                	slli	a4,a4,0x20
 630:	9301                	srli	a4,a4,0x20
 632:	40e989b3          	sub	s3,s3,a4
 636:	fff94583          	lbu	a1,-1(s2)
 63a:	8526                	mv	a0,s1
 63c:	00000097          	auipc	ra,0x0
 640:	f56080e7          	jalr	-170(ra) # 592 <putc>
 644:	197d                	addi	s2,s2,-1
 646:	ff3918e3          	bne	s2,s3,636 <printint+0x82>
}
 64a:	70e2                	ld	ra,56(sp)
 64c:	7442                	ld	s0,48(sp)
 64e:	74a2                	ld	s1,40(sp)
 650:	7902                	ld	s2,32(sp)
 652:	69e2                	ld	s3,24(sp)
 654:	6121                	addi	sp,sp,64
 656:	8082                	ret
    x = -xx;
 658:	40b005bb          	negw	a1,a1
    neg = 1;
 65c:	4885                	li	a7,1
    x = -xx;
 65e:	bf85                	j	5ce <printint+0x1a>

0000000000000660 <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 660:	7119                	addi	sp,sp,-128
 662:	fc86                	sd	ra,120(sp)
 664:	f8a2                	sd	s0,112(sp)
 666:	f4a6                	sd	s1,104(sp)
 668:	f0ca                	sd	s2,96(sp)
 66a:	ecce                	sd	s3,88(sp)
 66c:	e8d2                	sd	s4,80(sp)
 66e:	e4d6                	sd	s5,72(sp)
 670:	e0da                	sd	s6,64(sp)
 672:	fc5e                	sd	s7,56(sp)
 674:	f862                	sd	s8,48(sp)
 676:	f466                	sd	s9,40(sp)
 678:	f06a                	sd	s10,32(sp)
 67a:	ec6e                	sd	s11,24(sp)
 67c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 67e:	0005c903          	lbu	s2,0(a1)
 682:	18090f63          	beqz	s2,820 <vprintf+0x1c0>
 686:	8aaa                	mv	s5,a0
 688:	8b32                	mv	s6,a2
 68a:	00158493          	addi	s1,a1,1
  state = 0;
 68e:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 690:	02500a13          	li	s4,37
 694:	4c55                	li	s8,21
 696:	00000c97          	auipc	s9,0x0
 69a:	49ac8c93          	addi	s9,s9,1178 # b30 <malloc+0x20c>
      } else if (c == 'p') {
        printptr(fd, va_arg(ap, uint64));
      } else if (c == 's') {
        s = va_arg(ap, char *);
        if (s == 0) s = "(null)";
        while (*s != 0) {
 69e:	02800d93          	li	s11,40
  putc(fd, 'x');
 6a2:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a4:	00000b97          	auipc	s7,0x0
 6a8:	4e4b8b93          	addi	s7,s7,1252 # b88 <digits>
 6ac:	a839                	j	6ca <vprintf+0x6a>
        putc(fd, c);
 6ae:	85ca                	mv	a1,s2
 6b0:	8556                	mv	a0,s5
 6b2:	00000097          	auipc	ra,0x0
 6b6:	ee0080e7          	jalr	-288(ra) # 592 <putc>
 6ba:	a019                	j	6c0 <vprintf+0x60>
    } else if (state == '%') {
 6bc:	01498d63          	beq	s3,s4,6d6 <vprintf+0x76>
  for (i = 0; fmt[i]; i++) {
 6c0:	0485                	addi	s1,s1,1
 6c2:	fff4c903          	lbu	s2,-1(s1)
 6c6:	14090d63          	beqz	s2,820 <vprintf+0x1c0>
    if (state == 0) {
 6ca:	fe0999e3          	bnez	s3,6bc <vprintf+0x5c>
      if (c == '%') {
 6ce:	ff4910e3          	bne	s2,s4,6ae <vprintf+0x4e>
        state = '%';
 6d2:	89d2                	mv	s3,s4
 6d4:	b7f5                	j	6c0 <vprintf+0x60>
      if (c == 'd') {
 6d6:	11490c63          	beq	s2,s4,7ee <vprintf+0x18e>
 6da:	f9d9079b          	addiw	a5,s2,-99
 6de:	0ff7f793          	zext.b	a5,a5
 6e2:	10fc6e63          	bltu	s8,a5,7fe <vprintf+0x19e>
 6e6:	f9d9079b          	addiw	a5,s2,-99
 6ea:	0ff7f713          	zext.b	a4,a5
 6ee:	10ec6863          	bltu	s8,a4,7fe <vprintf+0x19e>
 6f2:	00271793          	slli	a5,a4,0x2
 6f6:	97e6                	add	a5,a5,s9
 6f8:	439c                	lw	a5,0(a5)
 6fa:	97e6                	add	a5,a5,s9
 6fc:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6fe:	008b0913          	addi	s2,s6,8
 702:	4685                	li	a3,1
 704:	4629                	li	a2,10
 706:	000b2583          	lw	a1,0(s6)
 70a:	8556                	mv	a0,s5
 70c:	00000097          	auipc	ra,0x0
 710:	ea8080e7          	jalr	-344(ra) # 5b4 <printint>
 714:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 716:	4981                	li	s3,0
 718:	b765                	j	6c0 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 71a:	008b0913          	addi	s2,s6,8
 71e:	4681                	li	a3,0
 720:	4629                	li	a2,10
 722:	000b2583          	lw	a1,0(s6)
 726:	8556                	mv	a0,s5
 728:	00000097          	auipc	ra,0x0
 72c:	e8c080e7          	jalr	-372(ra) # 5b4 <printint>
 730:	8b4a                	mv	s6,s2
      state = 0;
 732:	4981                	li	s3,0
 734:	b771                	j	6c0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 736:	008b0913          	addi	s2,s6,8
 73a:	4681                	li	a3,0
 73c:	866a                	mv	a2,s10
 73e:	000b2583          	lw	a1,0(s6)
 742:	8556                	mv	a0,s5
 744:	00000097          	auipc	ra,0x0
 748:	e70080e7          	jalr	-400(ra) # 5b4 <printint>
 74c:	8b4a                	mv	s6,s2
      state = 0;
 74e:	4981                	li	s3,0
 750:	bf85                	j	6c0 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 752:	008b0793          	addi	a5,s6,8
 756:	f8f43423          	sd	a5,-120(s0)
 75a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 75e:	03000593          	li	a1,48
 762:	8556                	mv	a0,s5
 764:	00000097          	auipc	ra,0x0
 768:	e2e080e7          	jalr	-466(ra) # 592 <putc>
  putc(fd, 'x');
 76c:	07800593          	li	a1,120
 770:	8556                	mv	a0,s5
 772:	00000097          	auipc	ra,0x0
 776:	e20080e7          	jalr	-480(ra) # 592 <putc>
 77a:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 77c:	03c9d793          	srli	a5,s3,0x3c
 780:	97de                	add	a5,a5,s7
 782:	0007c583          	lbu	a1,0(a5)
 786:	8556                	mv	a0,s5
 788:	00000097          	auipc	ra,0x0
 78c:	e0a080e7          	jalr	-502(ra) # 592 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 790:	0992                	slli	s3,s3,0x4
 792:	397d                	addiw	s2,s2,-1
 794:	fe0914e3          	bnez	s2,77c <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 798:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 79c:	4981                	li	s3,0
 79e:	b70d                	j	6c0 <vprintf+0x60>
        s = va_arg(ap, char *);
 7a0:	008b0913          	addi	s2,s6,8
 7a4:	000b3983          	ld	s3,0(s6)
        if (s == 0) s = "(null)";
 7a8:	02098163          	beqz	s3,7ca <vprintf+0x16a>
        while (*s != 0) {
 7ac:	0009c583          	lbu	a1,0(s3)
 7b0:	c5ad                	beqz	a1,81a <vprintf+0x1ba>
          putc(fd, *s);
 7b2:	8556                	mv	a0,s5
 7b4:	00000097          	auipc	ra,0x0
 7b8:	dde080e7          	jalr	-546(ra) # 592 <putc>
          s++;
 7bc:	0985                	addi	s3,s3,1
        while (*s != 0) {
 7be:	0009c583          	lbu	a1,0(s3)
 7c2:	f9e5                	bnez	a1,7b2 <vprintf+0x152>
        s = va_arg(ap, char *);
 7c4:	8b4a                	mv	s6,s2
      state = 0;
 7c6:	4981                	li	s3,0
 7c8:	bde5                	j	6c0 <vprintf+0x60>
        if (s == 0) s = "(null)";
 7ca:	00000997          	auipc	s3,0x0
 7ce:	35e98993          	addi	s3,s3,862 # b28 <malloc+0x204>
        while (*s != 0) {
 7d2:	85ee                	mv	a1,s11
 7d4:	bff9                	j	7b2 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 7d6:	008b0913          	addi	s2,s6,8
 7da:	000b4583          	lbu	a1,0(s6)
 7de:	8556                	mv	a0,s5
 7e0:	00000097          	auipc	ra,0x0
 7e4:	db2080e7          	jalr	-590(ra) # 592 <putc>
 7e8:	8b4a                	mv	s6,s2
      state = 0;
 7ea:	4981                	li	s3,0
 7ec:	bdd1                	j	6c0 <vprintf+0x60>
        putc(fd, c);
 7ee:	85d2                	mv	a1,s4
 7f0:	8556                	mv	a0,s5
 7f2:	00000097          	auipc	ra,0x0
 7f6:	da0080e7          	jalr	-608(ra) # 592 <putc>
      state = 0;
 7fa:	4981                	li	s3,0
 7fc:	b5d1                	j	6c0 <vprintf+0x60>
        putc(fd, '%');
 7fe:	85d2                	mv	a1,s4
 800:	8556                	mv	a0,s5
 802:	00000097          	auipc	ra,0x0
 806:	d90080e7          	jalr	-624(ra) # 592 <putc>
        putc(fd, c);
 80a:	85ca                	mv	a1,s2
 80c:	8556                	mv	a0,s5
 80e:	00000097          	auipc	ra,0x0
 812:	d84080e7          	jalr	-636(ra) # 592 <putc>
      state = 0;
 816:	4981                	li	s3,0
 818:	b565                	j	6c0 <vprintf+0x60>
        s = va_arg(ap, char *);
 81a:	8b4a                	mv	s6,s2
      state = 0;
 81c:	4981                	li	s3,0
 81e:	b54d                	j	6c0 <vprintf+0x60>
    }
  }
}
 820:	70e6                	ld	ra,120(sp)
 822:	7446                	ld	s0,112(sp)
 824:	74a6                	ld	s1,104(sp)
 826:	7906                	ld	s2,96(sp)
 828:	69e6                	ld	s3,88(sp)
 82a:	6a46                	ld	s4,80(sp)
 82c:	6aa6                	ld	s5,72(sp)
 82e:	6b06                	ld	s6,64(sp)
 830:	7be2                	ld	s7,56(sp)
 832:	7c42                	ld	s8,48(sp)
 834:	7ca2                	ld	s9,40(sp)
 836:	7d02                	ld	s10,32(sp)
 838:	6de2                	ld	s11,24(sp)
 83a:	6109                	addi	sp,sp,128
 83c:	8082                	ret

000000000000083e <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 83e:	715d                	addi	sp,sp,-80
 840:	ec06                	sd	ra,24(sp)
 842:	e822                	sd	s0,16(sp)
 844:	1000                	addi	s0,sp,32
 846:	e010                	sd	a2,0(s0)
 848:	e414                	sd	a3,8(s0)
 84a:	e818                	sd	a4,16(s0)
 84c:	ec1c                	sd	a5,24(s0)
 84e:	03043023          	sd	a6,32(s0)
 852:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 856:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 85a:	8622                	mv	a2,s0
 85c:	00000097          	auipc	ra,0x0
 860:	e04080e7          	jalr	-508(ra) # 660 <vprintf>
}
 864:	60e2                	ld	ra,24(sp)
 866:	6442                	ld	s0,16(sp)
 868:	6161                	addi	sp,sp,80
 86a:	8082                	ret

000000000000086c <printf>:

void printf(const char *fmt, ...) {
 86c:	711d                	addi	sp,sp,-96
 86e:	ec06                	sd	ra,24(sp)
 870:	e822                	sd	s0,16(sp)
 872:	1000                	addi	s0,sp,32
 874:	e40c                	sd	a1,8(s0)
 876:	e810                	sd	a2,16(s0)
 878:	ec14                	sd	a3,24(s0)
 87a:	f018                	sd	a4,32(s0)
 87c:	f41c                	sd	a5,40(s0)
 87e:	03043823          	sd	a6,48(s0)
 882:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 886:	00840613          	addi	a2,s0,8
 88a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 88e:	85aa                	mv	a1,a0
 890:	4505                	li	a0,1
 892:	00000097          	auipc	ra,0x0
 896:	dce080e7          	jalr	-562(ra) # 660 <vprintf>
}
 89a:	60e2                	ld	ra,24(sp)
 89c:	6442                	ld	s0,16(sp)
 89e:	6125                	addi	sp,sp,96
 8a0:	8082                	ret

00000000000008a2 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 8a2:	1141                	addi	sp,sp,-16
 8a4:	e422                	sd	s0,8(sp)
 8a6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 8a8:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ac:	00000797          	auipc	a5,0x0
 8b0:	7547b783          	ld	a5,1876(a5) # 1000 <freep>
 8b4:	a02d                	j	8de <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 8b6:	4618                	lw	a4,8(a2)
 8b8:	9f2d                	addw	a4,a4,a1
 8ba:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8be:	6398                	ld	a4,0(a5)
 8c0:	6310                	ld	a2,0(a4)
 8c2:	a83d                	j	900 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 8c4:	ff852703          	lw	a4,-8(a0)
 8c8:	9f31                	addw	a4,a4,a2
 8ca:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8cc:	ff053683          	ld	a3,-16(a0)
 8d0:	a091                	j	914 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 8d2:	6398                	ld	a4,0(a5)
 8d4:	00e7e463          	bltu	a5,a4,8dc <free+0x3a>
 8d8:	00e6ea63          	bltu	a3,a4,8ec <free+0x4a>
void free(void *ap) {
 8dc:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8de:	fed7fae3          	bgeu	a5,a3,8d2 <free+0x30>
 8e2:	6398                	ld	a4,0(a5)
 8e4:	00e6e463          	bltu	a3,a4,8ec <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 8e8:	fee7eae3          	bltu	a5,a4,8dc <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 8ec:	ff852583          	lw	a1,-8(a0)
 8f0:	6390                	ld	a2,0(a5)
 8f2:	02059813          	slli	a6,a1,0x20
 8f6:	01c85713          	srli	a4,a6,0x1c
 8fa:	9736                	add	a4,a4,a3
 8fc:	fae60de3          	beq	a2,a4,8b6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 900:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 904:	4790                	lw	a2,8(a5)
 906:	02061593          	slli	a1,a2,0x20
 90a:	01c5d713          	srli	a4,a1,0x1c
 90e:	973e                	add	a4,a4,a5
 910:	fae68ae3          	beq	a3,a4,8c4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 914:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 916:	00000717          	auipc	a4,0x0
 91a:	6ef73523          	sd	a5,1770(a4) # 1000 <freep>
}
 91e:	6422                	ld	s0,8(sp)
 920:	0141                	addi	sp,sp,16
 922:	8082                	ret

0000000000000924 <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 924:	7139                	addi	sp,sp,-64
 926:	fc06                	sd	ra,56(sp)
 928:	f822                	sd	s0,48(sp)
 92a:	f426                	sd	s1,40(sp)
 92c:	f04a                	sd	s2,32(sp)
 92e:	ec4e                	sd	s3,24(sp)
 930:	e852                	sd	s4,16(sp)
 932:	e456                	sd	s5,8(sp)
 934:	e05a                	sd	s6,0(sp)
 936:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 938:	02051493          	slli	s1,a0,0x20
 93c:	9081                	srli	s1,s1,0x20
 93e:	04bd                	addi	s1,s1,15
 940:	8091                	srli	s1,s1,0x4
 942:	0014899b          	addiw	s3,s1,1
 946:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 948:	00000517          	auipc	a0,0x0
 94c:	6b853503          	ld	a0,1720(a0) # 1000 <freep>
 950:	c515                	beqz	a0,97c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 952:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 954:	4798                	lw	a4,8(a5)
 956:	02977f63          	bgeu	a4,s1,994 <malloc+0x70>
 95a:	8a4e                	mv	s4,s3
 95c:	0009871b          	sext.w	a4,s3
 960:	6685                	lui	a3,0x1
 962:	00d77363          	bgeu	a4,a3,968 <malloc+0x44>
 966:	6a05                	lui	s4,0x1
 968:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 96c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 970:	00000917          	auipc	s2,0x0
 974:	69090913          	addi	s2,s2,1680 # 1000 <freep>
  if (p == (char *)-1) return 0;
 978:	5afd                	li	s5,-1
 97a:	a895                	j	9ee <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 97c:	00000797          	auipc	a5,0x0
 980:	69478793          	addi	a5,a5,1684 # 1010 <base>
 984:	00000717          	auipc	a4,0x0
 988:	66f73e23          	sd	a5,1660(a4) # 1000 <freep>
 98c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 98e:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 992:	b7e1                	j	95a <malloc+0x36>
      if (p->s.size == nunits)
 994:	02e48c63          	beq	s1,a4,9cc <malloc+0xa8>
        p->s.size -= nunits;
 998:	4137073b          	subw	a4,a4,s3
 99c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 99e:	02071693          	slli	a3,a4,0x20
 9a2:	01c6d713          	srli	a4,a3,0x1c
 9a6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9a8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ac:	00000717          	auipc	a4,0x0
 9b0:	64a73a23          	sd	a0,1620(a4) # 1000 <freep>
      return (void *)(p + 1);
 9b4:	01078513          	addi	a0,a5,16
      if ((p = morecore(nunits)) == 0) return 0;
  }
}
 9b8:	70e2                	ld	ra,56(sp)
 9ba:	7442                	ld	s0,48(sp)
 9bc:	74a2                	ld	s1,40(sp)
 9be:	7902                	ld	s2,32(sp)
 9c0:	69e2                	ld	s3,24(sp)
 9c2:	6a42                	ld	s4,16(sp)
 9c4:	6aa2                	ld	s5,8(sp)
 9c6:	6b02                	ld	s6,0(sp)
 9c8:	6121                	addi	sp,sp,64
 9ca:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9cc:	6398                	ld	a4,0(a5)
 9ce:	e118                	sd	a4,0(a0)
 9d0:	bff1                	j	9ac <malloc+0x88>
  hp->s.size = nu;
 9d2:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 9d6:	0541                	addi	a0,a0,16
 9d8:	00000097          	auipc	ra,0x0
 9dc:	eca080e7          	jalr	-310(ra) # 8a2 <free>
  return freep;
 9e0:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 9e4:	d971                	beqz	a0,9b8 <malloc+0x94>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 9e6:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 9e8:	4798                	lw	a4,8(a5)
 9ea:	fa9775e3          	bgeu	a4,s1,994 <malloc+0x70>
    if (p == freep)
 9ee:	00093703          	ld	a4,0(s2)
 9f2:	853e                	mv	a0,a5
 9f4:	fef719e3          	bne	a4,a5,9e6 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 9f8:	8552                	mv	a0,s4
 9fa:	00000097          	auipc	ra,0x0
 9fe:	b80080e7          	jalr	-1152(ra) # 57a <sbrk>
  if (p == (char *)-1) return 0;
 a02:	fd5518e3          	bne	a0,s5,9d2 <malloc+0xae>
      if ((p = morecore(nunits)) == 0) return 0;
 a06:	4501                	li	a0,0
 a08:	bf45                	j	9b8 <malloc+0x94>
