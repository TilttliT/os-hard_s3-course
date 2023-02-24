
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <readWithLogInf>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int readWithLogInf(int fd, char *buf, int msg_size) {
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  12:	8a2a                	mv	s4,a0
  14:	89ae                	mv	s3,a1
  16:	8932                	mv	s2,a2
  int n;
  int cnt = 0;
  18:	4481                	li	s1,0
  while (cnt + (n = read(fd, buf + cnt, sizeof(buf) - cnt)) < msg_size) {
  1a:	4aa1                	li	s5,8
  1c:	409a863b          	subw	a2,s5,s1
  20:	009985b3          	add	a1,s3,s1
  24:	8552                	mv	a0,s4
  26:	00000097          	auipc	ra,0x0
  2a:	3de080e7          	jalr	990(ra) # 404 <read>
  2e:	9ca9                	addw	s1,s1,a0
  30:	0124de63          	bge	s1,s2,4c <readWithLogInf+0x4c>
    if (n < 0) {
  34:	fe0554e3          	bgez	a0,1c <readWithLogInf+0x1c>
      return 2;
  38:	4509                	li	a0,2
  }

  printf("%d: got %s\n", getpid(), buf);

  return 0;
}
  3a:	70e2                	ld	ra,56(sp)
  3c:	7442                	ld	s0,48(sp)
  3e:	74a2                	ld	s1,40(sp)
  40:	7902                	ld	s2,32(sp)
  42:	69e2                	ld	s3,24(sp)
  44:	6a42                	ld	s4,16(sp)
  46:	6aa2                	ld	s5,8(sp)
  48:	6121                	addi	sp,sp,64
  4a:	8082                	ret
    return 2;
  4c:	4509                	li	a0,2
  if (cnt + n > msg_size || buf[msg_size - 1] != '\0') {
  4e:	fe9946e3          	blt	s2,s1,3a <readWithLogInf+0x3a>
  52:	994e                	add	s2,s2,s3
  54:	fff94783          	lbu	a5,-1(s2)
  58:	f3ed                	bnez	a5,3a <readWithLogInf+0x3a>
  printf("%d: got %s\n", getpid(), buf);
  5a:	00000097          	auipc	ra,0x0
  5e:	412080e7          	jalr	1042(ra) # 46c <getpid>
  62:	85aa                	mv	a1,a0
  64:	864e                	mv	a2,s3
  66:	00001517          	auipc	a0,0x1
  6a:	9aa50513          	addi	a0,a0,-1622 # a10 <loop+0xe>
  6e:	00000097          	auipc	ra,0x0
  72:	708080e7          	jalr	1800(ra) # 776 <printf>
  return 0;
  76:	4501                	li	a0,0
  78:	b7c9                	j	3a <readWithLogInf+0x3a>

000000000000007a <main>:

int main(int argc, char *argv[]) {
  7a:	7139                	addi	sp,sp,-64
  7c:	fc06                	sd	ra,56(sp)
  7e:	f822                	sd	s0,48(sp)
  80:	0080                	addi	s0,sp,64
  int id;
  int fd1[2], fd2[2];
  int MSG_SIZE1 = 5, MSG_SIZE2 = 5;
  char msg1[] = "ping";
  82:	676e77b7          	lui	a5,0x676e7
  86:	97078713          	addi	a4,a5,-1680 # 676e6970 <base+0x676e5960>
  8a:	fce42c23          	sw	a4,-40(s0)
  8e:	fc040e23          	sb	zero,-36(s0)
  char msg2[] = "pong";
  92:	f7078793          	addi	a5,a5,-144
  96:	fcf42823          	sw	a5,-48(s0)
  9a:	fc040a23          	sb	zero,-44(s0)
  char buf[8];

  if (pipe(fd1) || pipe(fd2)) {
  9e:	fe840513          	addi	a0,s0,-24
  a2:	00000097          	auipc	ra,0x0
  a6:	35a080e7          	jalr	858(ra) # 3fc <pipe>
  aa:	e901                	bnez	a0,ba <main+0x40>
  ac:	fe040513          	addi	a0,s0,-32
  b0:	00000097          	auipc	ra,0x0
  b4:	34c080e7          	jalr	844(ra) # 3fc <pipe>
  b8:	c511                	beqz	a0,c4 <main+0x4a>
    exit(3);
  ba:	450d                	li	a0,3
  bc:	00000097          	auipc	ra,0x0
  c0:	330080e7          	jalr	816(ra) # 3ec <exit>
  }
  if ((id = fork()) > 0) {
  c4:	00000097          	auipc	ra,0x0
  c8:	320080e7          	jalr	800(ra) # 3e4 <fork>
  cc:	02a04263          	bgtz	a0,f0 <main+0x76>
      exit(1);
    }
    if (readWithLogInf(fd2[0], buf, MSG_SIZE2)) {
      exit(2);
    }
  } else if (id == 0) {
  d0:	e551                	bnez	a0,15c <main+0xe2>
    // child
    if (readWithLogInf(fd1[0], buf, MSG_SIZE1)) {
  d2:	4615                	li	a2,5
  d4:	fc840593          	addi	a1,s0,-56
  d8:	fe842503          	lw	a0,-24(s0)
  dc:	00000097          	auipc	ra,0x0
  e0:	f24080e7          	jalr	-220(ra) # 0 <readWithLogInf>
  e4:	c939                	beqz	a0,13a <main+0xc0>
      exit(2);
  e6:	4509                	li	a0,2
  e8:	00000097          	auipc	ra,0x0
  ec:	304080e7          	jalr	772(ra) # 3ec <exit>
    if (write(fd1[1], msg1, sizeof(msg1)) != sizeof(msg1)) {
  f0:	4615                	li	a2,5
  f2:	fd840593          	addi	a1,s0,-40
  f6:	fec42503          	lw	a0,-20(s0)
  fa:	00000097          	auipc	ra,0x0
  fe:	312080e7          	jalr	786(ra) # 40c <write>
 102:	4795                	li	a5,5
 104:	00f50763          	beq	a0,a5,112 <main+0x98>
      exit(1);
 108:	4505                	li	a0,1
 10a:	00000097          	auipc	ra,0x0
 10e:	2e2080e7          	jalr	738(ra) # 3ec <exit>
    if (readWithLogInf(fd2[0], buf, MSG_SIZE2)) {
 112:	4615                	li	a2,5
 114:	fc840593          	addi	a1,s0,-56
 118:	fe042503          	lw	a0,-32(s0)
 11c:	00000097          	auipc	ra,0x0
 120:	ee4080e7          	jalr	-284(ra) # 0 <readWithLogInf>
 124:	e511                	bnez	a0,130 <main+0xb6>
    }
  } else {
    exit(4);
  }

  exit(0);
 126:	4501                	li	a0,0
 128:	00000097          	auipc	ra,0x0
 12c:	2c4080e7          	jalr	708(ra) # 3ec <exit>
      exit(2);
 130:	4509                	li	a0,2
 132:	00000097          	auipc	ra,0x0
 136:	2ba080e7          	jalr	698(ra) # 3ec <exit>
    if (write(fd2[1], msg2, sizeof(msg2)) != sizeof(msg2)) {
 13a:	4615                	li	a2,5
 13c:	fd040593          	addi	a1,s0,-48
 140:	fe442503          	lw	a0,-28(s0)
 144:	00000097          	auipc	ra,0x0
 148:	2c8080e7          	jalr	712(ra) # 40c <write>
 14c:	4795                	li	a5,5
 14e:	fcf50ce3          	beq	a0,a5,126 <main+0xac>
      exit(1);
 152:	4505                	li	a0,1
 154:	00000097          	auipc	ra,0x0
 158:	298080e7          	jalr	664(ra) # 3ec <exit>
    exit(4);
 15c:	4511                	li	a0,4
 15e:	00000097          	auipc	ra,0x0
 162:	28e080e7          	jalr	654(ra) # 3ec <exit>

0000000000000166 <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
 166:	1141                	addi	sp,sp,-16
 168:	e406                	sd	ra,8(sp)
 16a:	e022                	sd	s0,0(sp)
 16c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 16e:	00000097          	auipc	ra,0x0
 172:	f0c080e7          	jalr	-244(ra) # 7a <main>
  exit(0);
 176:	4501                	li	a0,0
 178:	00000097          	auipc	ra,0x0
 17c:	274080e7          	jalr	628(ra) # 3ec <exit>

0000000000000180 <strcpy>:
}

char *strcpy(char *s, const char *t) {
 180:	1141                	addi	sp,sp,-16
 182:	e422                	sd	s0,8(sp)
 184:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 186:	87aa                	mv	a5,a0
 188:	0585                	addi	a1,a1,1
 18a:	0785                	addi	a5,a5,1
 18c:	fff5c703          	lbu	a4,-1(a1)
 190:	fee78fa3          	sb	a4,-1(a5)
 194:	fb75                	bnez	a4,188 <strcpy+0x8>
    ;
  return os;
}
 196:	6422                	ld	s0,8(sp)
 198:	0141                	addi	sp,sp,16
 19a:	8082                	ret

000000000000019c <strcmp>:

int strcmp(const char *p, const char *q) {
 19c:	1141                	addi	sp,sp,-16
 19e:	e422                	sd	s0,8(sp)
 1a0:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	cb91                	beqz	a5,1ba <strcmp+0x1e>
 1a8:	0005c703          	lbu	a4,0(a1)
 1ac:	00f71763          	bne	a4,a5,1ba <strcmp+0x1e>
 1b0:	0505                	addi	a0,a0,1
 1b2:	0585                	addi	a1,a1,1
 1b4:	00054783          	lbu	a5,0(a0)
 1b8:	fbe5                	bnez	a5,1a8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1ba:	0005c503          	lbu	a0,0(a1)
}
 1be:	40a7853b          	subw	a0,a5,a0
 1c2:	6422                	ld	s0,8(sp)
 1c4:	0141                	addi	sp,sp,16
 1c6:	8082                	ret

00000000000001c8 <strlen>:

uint strlen(const char *s) {
 1c8:	1141                	addi	sp,sp,-16
 1ca:	e422                	sd	s0,8(sp)
 1cc:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 1ce:	00054783          	lbu	a5,0(a0)
 1d2:	cf91                	beqz	a5,1ee <strlen+0x26>
 1d4:	0505                	addi	a0,a0,1
 1d6:	87aa                	mv	a5,a0
 1d8:	4685                	li	a3,1
 1da:	9e89                	subw	a3,a3,a0
 1dc:	00f6853b          	addw	a0,a3,a5
 1e0:	0785                	addi	a5,a5,1
 1e2:	fff7c703          	lbu	a4,-1(a5)
 1e6:	fb7d                	bnez	a4,1dc <strlen+0x14>
    ;
  return n;
}
 1e8:	6422                	ld	s0,8(sp)
 1ea:	0141                	addi	sp,sp,16
 1ec:	8082                	ret
  for (n = 0; s[n]; n++)
 1ee:	4501                	li	a0,0
 1f0:	bfe5                	j	1e8 <strlen+0x20>

00000000000001f2 <memset>:

void *memset(void *dst, int c, uint n) {
 1f2:	1141                	addi	sp,sp,-16
 1f4:	e422                	sd	s0,8(sp)
 1f6:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 1f8:	ca19                	beqz	a2,20e <memset+0x1c>
 1fa:	87aa                	mv	a5,a0
 1fc:	1602                	slli	a2,a2,0x20
 1fe:	9201                	srli	a2,a2,0x20
 200:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 204:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 208:	0785                	addi	a5,a5,1
 20a:	fee79de3          	bne	a5,a4,204 <memset+0x12>
  }
  return dst;
}
 20e:	6422                	ld	s0,8(sp)
 210:	0141                	addi	sp,sp,16
 212:	8082                	ret

0000000000000214 <strchr>:

char *strchr(const char *s, char c) {
 214:	1141                	addi	sp,sp,-16
 216:	e422                	sd	s0,8(sp)
 218:	0800                	addi	s0,sp,16
  for (; *s; s++)
 21a:	00054783          	lbu	a5,0(a0)
 21e:	cb99                	beqz	a5,234 <strchr+0x20>
    if (*s == c) return (char *)s;
 220:	00f58763          	beq	a1,a5,22e <strchr+0x1a>
  for (; *s; s++)
 224:	0505                	addi	a0,a0,1
 226:	00054783          	lbu	a5,0(a0)
 22a:	fbfd                	bnez	a5,220 <strchr+0xc>
  return 0;
 22c:	4501                	li	a0,0
}
 22e:	6422                	ld	s0,8(sp)
 230:	0141                	addi	sp,sp,16
 232:	8082                	ret
  return 0;
 234:	4501                	li	a0,0
 236:	bfe5                	j	22e <strchr+0x1a>

0000000000000238 <gets>:

char *gets(char *buf, int max) {
 238:	711d                	addi	sp,sp,-96
 23a:	ec86                	sd	ra,88(sp)
 23c:	e8a2                	sd	s0,80(sp)
 23e:	e4a6                	sd	s1,72(sp)
 240:	e0ca                	sd	s2,64(sp)
 242:	fc4e                	sd	s3,56(sp)
 244:	f852                	sd	s4,48(sp)
 246:	f456                	sd	s5,40(sp)
 248:	f05a                	sd	s6,32(sp)
 24a:	ec5e                	sd	s7,24(sp)
 24c:	1080                	addi	s0,sp,96
 24e:	8baa                	mv	s7,a0
 250:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 252:	892a                	mv	s2,a0
 254:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
 256:	4aa9                	li	s5,10
 258:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 25a:	89a6                	mv	s3,s1
 25c:	2485                	addiw	s1,s1,1
 25e:	0344d863          	bge	s1,s4,28e <gets+0x56>
    cc = read(0, &c, 1);
 262:	4605                	li	a2,1
 264:	faf40593          	addi	a1,s0,-81
 268:	4501                	li	a0,0
 26a:	00000097          	auipc	ra,0x0
 26e:	19a080e7          	jalr	410(ra) # 404 <read>
    if (cc < 1) break;
 272:	00a05e63          	blez	a0,28e <gets+0x56>
    buf[i++] = c;
 276:	faf44783          	lbu	a5,-81(s0)
 27a:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
 27e:	01578763          	beq	a5,s5,28c <gets+0x54>
 282:	0905                	addi	s2,s2,1
 284:	fd679be3          	bne	a5,s6,25a <gets+0x22>
  for (i = 0; i + 1 < max;) {
 288:	89a6                	mv	s3,s1
 28a:	a011                	j	28e <gets+0x56>
 28c:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
 28e:	99de                	add	s3,s3,s7
 290:	00098023          	sb	zero,0(s3)
  return buf;
}
 294:	855e                	mv	a0,s7
 296:	60e6                	ld	ra,88(sp)
 298:	6446                	ld	s0,80(sp)
 29a:	64a6                	ld	s1,72(sp)
 29c:	6906                	ld	s2,64(sp)
 29e:	79e2                	ld	s3,56(sp)
 2a0:	7a42                	ld	s4,48(sp)
 2a2:	7aa2                	ld	s5,40(sp)
 2a4:	7b02                	ld	s6,32(sp)
 2a6:	6be2                	ld	s7,24(sp)
 2a8:	6125                	addi	sp,sp,96
 2aa:	8082                	ret

00000000000002ac <stat>:

int stat(const char *n, struct stat *st) {
 2ac:	1101                	addi	sp,sp,-32
 2ae:	ec06                	sd	ra,24(sp)
 2b0:	e822                	sd	s0,16(sp)
 2b2:	e426                	sd	s1,8(sp)
 2b4:	e04a                	sd	s2,0(sp)
 2b6:	1000                	addi	s0,sp,32
 2b8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ba:	4581                	li	a1,0
 2bc:	00000097          	auipc	ra,0x0
 2c0:	170080e7          	jalr	368(ra) # 42c <open>
  if (fd < 0) return -1;
 2c4:	02054563          	bltz	a0,2ee <stat+0x42>
 2c8:	84aa                	mv	s1,a0
  r = fstat(fd, st);
 2ca:	85ca                	mv	a1,s2
 2cc:	00000097          	auipc	ra,0x0
 2d0:	178080e7          	jalr	376(ra) # 444 <fstat>
 2d4:	892a                	mv	s2,a0
  close(fd);
 2d6:	8526                	mv	a0,s1
 2d8:	00000097          	auipc	ra,0x0
 2dc:	13c080e7          	jalr	316(ra) # 414 <close>
  return r;
}
 2e0:	854a                	mv	a0,s2
 2e2:	60e2                	ld	ra,24(sp)
 2e4:	6442                	ld	s0,16(sp)
 2e6:	64a2                	ld	s1,8(sp)
 2e8:	6902                	ld	s2,0(sp)
 2ea:	6105                	addi	sp,sp,32
 2ec:	8082                	ret
  if (fd < 0) return -1;
 2ee:	597d                	li	s2,-1
 2f0:	bfc5                	j	2e0 <stat+0x34>

00000000000002f2 <atoi>:

int atoi(const char *s) {
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e422                	sd	s0,8(sp)
 2f6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 2f8:	00054683          	lbu	a3,0(a0)
 2fc:	fd06879b          	addiw	a5,a3,-48
 300:	0ff7f793          	zext.b	a5,a5
 304:	4625                	li	a2,9
 306:	02f66863          	bltu	a2,a5,336 <atoi+0x44>
 30a:	872a                	mv	a4,a0
  n = 0;
 30c:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
 30e:	0705                	addi	a4,a4,1
 310:	0025179b          	slliw	a5,a0,0x2
 314:	9fa9                	addw	a5,a5,a0
 316:	0017979b          	slliw	a5,a5,0x1
 31a:	9fb5                	addw	a5,a5,a3
 31c:	fd07851b          	addiw	a0,a5,-48
 320:	00074683          	lbu	a3,0(a4)
 324:	fd06879b          	addiw	a5,a3,-48
 328:	0ff7f793          	zext.b	a5,a5
 32c:	fef671e3          	bgeu	a2,a5,30e <atoi+0x1c>
  return n;
}
 330:	6422                	ld	s0,8(sp)
 332:	0141                	addi	sp,sp,16
 334:	8082                	ret
  n = 0;
 336:	4501                	li	a0,0
 338:	bfe5                	j	330 <atoi+0x3e>

000000000000033a <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
 33a:	1141                	addi	sp,sp,-16
 33c:	e422                	sd	s0,8(sp)
 33e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 340:	02b57463          	bgeu	a0,a1,368 <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
 344:	00c05f63          	blez	a2,362 <memmove+0x28>
 348:	1602                	slli	a2,a2,0x20
 34a:	9201                	srli	a2,a2,0x20
 34c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 350:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
 352:	0585                	addi	a1,a1,1
 354:	0705                	addi	a4,a4,1
 356:	fff5c683          	lbu	a3,-1(a1)
 35a:	fed70fa3          	sb	a3,-1(a4)
 35e:	fee79ae3          	bne	a5,a4,352 <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
 362:	6422                	ld	s0,8(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret
    dst += n;
 368:	00c50733          	add	a4,a0,a2
    src += n;
 36c:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
 36e:	fec05ae3          	blez	a2,362 <memmove+0x28>
 372:	fff6079b          	addiw	a5,a2,-1
 376:	1782                	slli	a5,a5,0x20
 378:	9381                	srli	a5,a5,0x20
 37a:	fff7c793          	not	a5,a5
 37e:	97ba                	add	a5,a5,a4
 380:	15fd                	addi	a1,a1,-1
 382:	177d                	addi	a4,a4,-1
 384:	0005c683          	lbu	a3,0(a1)
 388:	00d70023          	sb	a3,0(a4)
 38c:	fee79ae3          	bne	a5,a4,380 <memmove+0x46>
 390:	bfc9                	j	362 <memmove+0x28>

0000000000000392 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
 392:	1141                	addi	sp,sp,-16
 394:	e422                	sd	s0,8(sp)
 396:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 398:	ca05                	beqz	a2,3c8 <memcmp+0x36>
 39a:	fff6069b          	addiw	a3,a2,-1
 39e:	1682                	slli	a3,a3,0x20
 3a0:	9281                	srli	a3,a3,0x20
 3a2:	0685                	addi	a3,a3,1
 3a4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3a6:	00054783          	lbu	a5,0(a0)
 3aa:	0005c703          	lbu	a4,0(a1)
 3ae:	00e79863          	bne	a5,a4,3be <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3b2:	0505                	addi	a0,a0,1
    p2++;
 3b4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3b6:	fed518e3          	bne	a0,a3,3a6 <memcmp+0x14>
  }
  return 0;
 3ba:	4501                	li	a0,0
 3bc:	a019                	j	3c2 <memcmp+0x30>
      return *p1 - *p2;
 3be:	40e7853b          	subw	a0,a5,a4
}
 3c2:	6422                	ld	s0,8(sp)
 3c4:	0141                	addi	sp,sp,16
 3c6:	8082                	ret
  return 0;
 3c8:	4501                	li	a0,0
 3ca:	bfe5                	j	3c2 <memcmp+0x30>

00000000000003cc <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
 3cc:	1141                	addi	sp,sp,-16
 3ce:	e406                	sd	ra,8(sp)
 3d0:	e022                	sd	s0,0(sp)
 3d2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3d4:	00000097          	auipc	ra,0x0
 3d8:	f66080e7          	jalr	-154(ra) # 33a <memmove>
}
 3dc:	60a2                	ld	ra,8(sp)
 3de:	6402                	ld	s0,0(sp)
 3e0:	0141                	addi	sp,sp,16
 3e2:	8082                	ret

00000000000003e4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3e4:	4885                	li	a7,1
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ec:	4889                	li	a7,2
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3f4:	488d                	li	a7,3
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3fc:	4891                	li	a7,4
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <read>:
.global read
read:
 li a7, SYS_read
 404:	4895                	li	a7,5
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <write>:
.global write
write:
 li a7, SYS_write
 40c:	48c1                	li	a7,16
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <close>:
.global close
close:
 li a7, SYS_close
 414:	48d5                	li	a7,21
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <kill>:
.global kill
kill:
 li a7, SYS_kill
 41c:	4899                	li	a7,6
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <exec>:
.global exec
exec:
 li a7, SYS_exec
 424:	489d                	li	a7,7
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <open>:
.global open
open:
 li a7, SYS_open
 42c:	48bd                	li	a7,15
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 434:	48c5                	li	a7,17
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 43c:	48c9                	li	a7,18
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 444:	48a1                	li	a7,8
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <link>:
.global link
link:
 li a7, SYS_link
 44c:	48cd                	li	a7,19
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 454:	48d1                	li	a7,20
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 45c:	48a5                	li	a7,9
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <dup>:
.global dup
dup:
 li a7, SYS_dup
 464:	48a9                	li	a7,10
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 46c:	48ad                	li	a7,11
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 474:	48b1                	li	a7,12
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 47c:	48b5                	li	a7,13
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 484:	48b9                	li	a7,14
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <dump>:
.global dump
dump:
 li a7, SYS_dump
 48c:	48d9                	li	a7,22
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <dump2>:
.global dump2
dump2:
 li a7, SYS_dump2
 494:	48dd                	li	a7,23
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <putc>:

#include <stdarg.h>

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
 49c:	1101                	addi	sp,sp,-32
 49e:	ec06                	sd	ra,24(sp)
 4a0:	e822                	sd	s0,16(sp)
 4a2:	1000                	addi	s0,sp,32
 4a4:	feb407a3          	sb	a1,-17(s0)
 4a8:	4605                	li	a2,1
 4aa:	fef40593          	addi	a1,s0,-17
 4ae:	00000097          	auipc	ra,0x0
 4b2:	f5e080e7          	jalr	-162(ra) # 40c <write>
 4b6:	60e2                	ld	ra,24(sp)
 4b8:	6442                	ld	s0,16(sp)
 4ba:	6105                	addi	sp,sp,32
 4bc:	8082                	ret

00000000000004be <printint>:

static void printint(int fd, int xx, int base, int sgn) {
 4be:	7139                	addi	sp,sp,-64
 4c0:	fc06                	sd	ra,56(sp)
 4c2:	f822                	sd	s0,48(sp)
 4c4:	f426                	sd	s1,40(sp)
 4c6:	f04a                	sd	s2,32(sp)
 4c8:	ec4e                	sd	s3,24(sp)
 4ca:	0080                	addi	s0,sp,64
 4cc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
 4ce:	c299                	beqz	a3,4d4 <printint+0x16>
 4d0:	0805c963          	bltz	a1,562 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4d4:	2581                	sext.w	a1,a1
  neg = 0;
 4d6:	4881                	li	a7,0
 4d8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4dc:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 4de:	2601                	sext.w	a2,a2
 4e0:	00000517          	auipc	a0,0x0
 4e4:	5a050513          	addi	a0,a0,1440 # a80 <digits>
 4e8:	883a                	mv	a6,a4
 4ea:	2705                	addiw	a4,a4,1
 4ec:	02c5f7bb          	remuw	a5,a1,a2
 4f0:	1782                	slli	a5,a5,0x20
 4f2:	9381                	srli	a5,a5,0x20
 4f4:	97aa                	add	a5,a5,a0
 4f6:	0007c783          	lbu	a5,0(a5)
 4fa:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 4fe:	0005879b          	sext.w	a5,a1
 502:	02c5d5bb          	divuw	a1,a1,a2
 506:	0685                	addi	a3,a3,1
 508:	fec7f0e3          	bgeu	a5,a2,4e8 <printint+0x2a>
  if (neg) buf[i++] = '-';
 50c:	00088c63          	beqz	a7,524 <printint+0x66>
 510:	fd070793          	addi	a5,a4,-48
 514:	00878733          	add	a4,a5,s0
 518:	02d00793          	li	a5,45
 51c:	fef70823          	sb	a5,-16(a4)
 520:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
 524:	02e05863          	blez	a4,554 <printint+0x96>
 528:	fc040793          	addi	a5,s0,-64
 52c:	00e78933          	add	s2,a5,a4
 530:	fff78993          	addi	s3,a5,-1
 534:	99ba                	add	s3,s3,a4
 536:	377d                	addiw	a4,a4,-1
 538:	1702                	slli	a4,a4,0x20
 53a:	9301                	srli	a4,a4,0x20
 53c:	40e989b3          	sub	s3,s3,a4
 540:	fff94583          	lbu	a1,-1(s2)
 544:	8526                	mv	a0,s1
 546:	00000097          	auipc	ra,0x0
 54a:	f56080e7          	jalr	-170(ra) # 49c <putc>
 54e:	197d                	addi	s2,s2,-1
 550:	ff3918e3          	bne	s2,s3,540 <printint+0x82>
}
 554:	70e2                	ld	ra,56(sp)
 556:	7442                	ld	s0,48(sp)
 558:	74a2                	ld	s1,40(sp)
 55a:	7902                	ld	s2,32(sp)
 55c:	69e2                	ld	s3,24(sp)
 55e:	6121                	addi	sp,sp,64
 560:	8082                	ret
    x = -xx;
 562:	40b005bb          	negw	a1,a1
    neg = 1;
 566:	4885                	li	a7,1
    x = -xx;
 568:	bf85                	j	4d8 <printint+0x1a>

000000000000056a <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
 56a:	7119                	addi	sp,sp,-128
 56c:	fc86                	sd	ra,120(sp)
 56e:	f8a2                	sd	s0,112(sp)
 570:	f4a6                	sd	s1,104(sp)
 572:	f0ca                	sd	s2,96(sp)
 574:	ecce                	sd	s3,88(sp)
 576:	e8d2                	sd	s4,80(sp)
 578:	e4d6                	sd	s5,72(sp)
 57a:	e0da                	sd	s6,64(sp)
 57c:	fc5e                	sd	s7,56(sp)
 57e:	f862                	sd	s8,48(sp)
 580:	f466                	sd	s9,40(sp)
 582:	f06a                	sd	s10,32(sp)
 584:	ec6e                	sd	s11,24(sp)
 586:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 588:	0005c903          	lbu	s2,0(a1)
 58c:	18090f63          	beqz	s2,72a <vprintf+0x1c0>
 590:	8aaa                	mv	s5,a0
 592:	8b32                	mv	s6,a2
 594:	00158493          	addi	s1,a1,1
  state = 0;
 598:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
 59a:	02500a13          	li	s4,37
 59e:	4c55                	li	s8,21
 5a0:	00000c97          	auipc	s9,0x0
 5a4:	488c8c93          	addi	s9,s9,1160 # a28 <loop+0x26>
      } else if (c == 'p') {
        printptr(fd, va_arg(ap, uint64));
      } else if (c == 's') {
        s = va_arg(ap, char *);
        if (s == 0) s = "(null)";
        while (*s != 0) {
 5a8:	02800d93          	li	s11,40
  putc(fd, 'x');
 5ac:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ae:	00000b97          	auipc	s7,0x0
 5b2:	4d2b8b93          	addi	s7,s7,1234 # a80 <digits>
 5b6:	a839                	j	5d4 <vprintf+0x6a>
        putc(fd, c);
 5b8:	85ca                	mv	a1,s2
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	ee0080e7          	jalr	-288(ra) # 49c <putc>
 5c4:	a019                	j	5ca <vprintf+0x60>
    } else if (state == '%') {
 5c6:	01498d63          	beq	s3,s4,5e0 <vprintf+0x76>
  for (i = 0; fmt[i]; i++) {
 5ca:	0485                	addi	s1,s1,1
 5cc:	fff4c903          	lbu	s2,-1(s1)
 5d0:	14090d63          	beqz	s2,72a <vprintf+0x1c0>
    if (state == 0) {
 5d4:	fe0999e3          	bnez	s3,5c6 <vprintf+0x5c>
      if (c == '%') {
 5d8:	ff4910e3          	bne	s2,s4,5b8 <vprintf+0x4e>
        state = '%';
 5dc:	89d2                	mv	s3,s4
 5de:	b7f5                	j	5ca <vprintf+0x60>
      if (c == 'd') {
 5e0:	11490c63          	beq	s2,s4,6f8 <vprintf+0x18e>
 5e4:	f9d9079b          	addiw	a5,s2,-99
 5e8:	0ff7f793          	zext.b	a5,a5
 5ec:	10fc6e63          	bltu	s8,a5,708 <vprintf+0x19e>
 5f0:	f9d9079b          	addiw	a5,s2,-99
 5f4:	0ff7f713          	zext.b	a4,a5
 5f8:	10ec6863          	bltu	s8,a4,708 <vprintf+0x19e>
 5fc:	00271793          	slli	a5,a4,0x2
 600:	97e6                	add	a5,a5,s9
 602:	439c                	lw	a5,0(a5)
 604:	97e6                	add	a5,a5,s9
 606:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 608:	008b0913          	addi	s2,s6,8
 60c:	4685                	li	a3,1
 60e:	4629                	li	a2,10
 610:	000b2583          	lw	a1,0(s6)
 614:	8556                	mv	a0,s5
 616:	00000097          	auipc	ra,0x0
 61a:	ea8080e7          	jalr	-344(ra) # 4be <printint>
 61e:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 620:	4981                	li	s3,0
 622:	b765                	j	5ca <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 624:	008b0913          	addi	s2,s6,8
 628:	4681                	li	a3,0
 62a:	4629                	li	a2,10
 62c:	000b2583          	lw	a1,0(s6)
 630:	8556                	mv	a0,s5
 632:	00000097          	auipc	ra,0x0
 636:	e8c080e7          	jalr	-372(ra) # 4be <printint>
 63a:	8b4a                	mv	s6,s2
      state = 0;
 63c:	4981                	li	s3,0
 63e:	b771                	j	5ca <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 640:	008b0913          	addi	s2,s6,8
 644:	4681                	li	a3,0
 646:	866a                	mv	a2,s10
 648:	000b2583          	lw	a1,0(s6)
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	e70080e7          	jalr	-400(ra) # 4be <printint>
 656:	8b4a                	mv	s6,s2
      state = 0;
 658:	4981                	li	s3,0
 65a:	bf85                	j	5ca <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 65c:	008b0793          	addi	a5,s6,8
 660:	f8f43423          	sd	a5,-120(s0)
 664:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 668:	03000593          	li	a1,48
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	e2e080e7          	jalr	-466(ra) # 49c <putc>
  putc(fd, 'x');
 676:	07800593          	li	a1,120
 67a:	8556                	mv	a0,s5
 67c:	00000097          	auipc	ra,0x0
 680:	e20080e7          	jalr	-480(ra) # 49c <putc>
 684:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 686:	03c9d793          	srli	a5,s3,0x3c
 68a:	97de                	add	a5,a5,s7
 68c:	0007c583          	lbu	a1,0(a5)
 690:	8556                	mv	a0,s5
 692:	00000097          	auipc	ra,0x0
 696:	e0a080e7          	jalr	-502(ra) # 49c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 69a:	0992                	slli	s3,s3,0x4
 69c:	397d                	addiw	s2,s2,-1
 69e:	fe0914e3          	bnez	s2,686 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 6a2:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	b70d                	j	5ca <vprintf+0x60>
        s = va_arg(ap, char *);
 6aa:	008b0913          	addi	s2,s6,8
 6ae:	000b3983          	ld	s3,0(s6)
        if (s == 0) s = "(null)";
 6b2:	02098163          	beqz	s3,6d4 <vprintf+0x16a>
        while (*s != 0) {
 6b6:	0009c583          	lbu	a1,0(s3)
 6ba:	c5ad                	beqz	a1,724 <vprintf+0x1ba>
          putc(fd, *s);
 6bc:	8556                	mv	a0,s5
 6be:	00000097          	auipc	ra,0x0
 6c2:	dde080e7          	jalr	-546(ra) # 49c <putc>
          s++;
 6c6:	0985                	addi	s3,s3,1
        while (*s != 0) {
 6c8:	0009c583          	lbu	a1,0(s3)
 6cc:	f9e5                	bnez	a1,6bc <vprintf+0x152>
        s = va_arg(ap, char *);
 6ce:	8b4a                	mv	s6,s2
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	bde5                	j	5ca <vprintf+0x60>
        if (s == 0) s = "(null)";
 6d4:	00000997          	auipc	s3,0x0
 6d8:	34c98993          	addi	s3,s3,844 # a20 <loop+0x1e>
        while (*s != 0) {
 6dc:	85ee                	mv	a1,s11
 6de:	bff9                	j	6bc <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 6e0:	008b0913          	addi	s2,s6,8
 6e4:	000b4583          	lbu	a1,0(s6)
 6e8:	8556                	mv	a0,s5
 6ea:	00000097          	auipc	ra,0x0
 6ee:	db2080e7          	jalr	-590(ra) # 49c <putc>
 6f2:	8b4a                	mv	s6,s2
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	bdd1                	j	5ca <vprintf+0x60>
        putc(fd, c);
 6f8:	85d2                	mv	a1,s4
 6fa:	8556                	mv	a0,s5
 6fc:	00000097          	auipc	ra,0x0
 700:	da0080e7          	jalr	-608(ra) # 49c <putc>
      state = 0;
 704:	4981                	li	s3,0
 706:	b5d1                	j	5ca <vprintf+0x60>
        putc(fd, '%');
 708:	85d2                	mv	a1,s4
 70a:	8556                	mv	a0,s5
 70c:	00000097          	auipc	ra,0x0
 710:	d90080e7          	jalr	-624(ra) # 49c <putc>
        putc(fd, c);
 714:	85ca                	mv	a1,s2
 716:	8556                	mv	a0,s5
 718:	00000097          	auipc	ra,0x0
 71c:	d84080e7          	jalr	-636(ra) # 49c <putc>
      state = 0;
 720:	4981                	li	s3,0
 722:	b565                	j	5ca <vprintf+0x60>
        s = va_arg(ap, char *);
 724:	8b4a                	mv	s6,s2
      state = 0;
 726:	4981                	li	s3,0
 728:	b54d                	j	5ca <vprintf+0x60>
    }
  }
}
 72a:	70e6                	ld	ra,120(sp)
 72c:	7446                	ld	s0,112(sp)
 72e:	74a6                	ld	s1,104(sp)
 730:	7906                	ld	s2,96(sp)
 732:	69e6                	ld	s3,88(sp)
 734:	6a46                	ld	s4,80(sp)
 736:	6aa6                	ld	s5,72(sp)
 738:	6b06                	ld	s6,64(sp)
 73a:	7be2                	ld	s7,56(sp)
 73c:	7c42                	ld	s8,48(sp)
 73e:	7ca2                	ld	s9,40(sp)
 740:	7d02                	ld	s10,32(sp)
 742:	6de2                	ld	s11,24(sp)
 744:	6109                	addi	sp,sp,128
 746:	8082                	ret

0000000000000748 <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
 748:	715d                	addi	sp,sp,-80
 74a:	ec06                	sd	ra,24(sp)
 74c:	e822                	sd	s0,16(sp)
 74e:	1000                	addi	s0,sp,32
 750:	e010                	sd	a2,0(s0)
 752:	e414                	sd	a3,8(s0)
 754:	e818                	sd	a4,16(s0)
 756:	ec1c                	sd	a5,24(s0)
 758:	03043023          	sd	a6,32(s0)
 75c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 760:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 764:	8622                	mv	a2,s0
 766:	00000097          	auipc	ra,0x0
 76a:	e04080e7          	jalr	-508(ra) # 56a <vprintf>
}
 76e:	60e2                	ld	ra,24(sp)
 770:	6442                	ld	s0,16(sp)
 772:	6161                	addi	sp,sp,80
 774:	8082                	ret

0000000000000776 <printf>:

void printf(const char *fmt, ...) {
 776:	711d                	addi	sp,sp,-96
 778:	ec06                	sd	ra,24(sp)
 77a:	e822                	sd	s0,16(sp)
 77c:	1000                	addi	s0,sp,32
 77e:	e40c                	sd	a1,8(s0)
 780:	e810                	sd	a2,16(s0)
 782:	ec14                	sd	a3,24(s0)
 784:	f018                	sd	a4,32(s0)
 786:	f41c                	sd	a5,40(s0)
 788:	03043823          	sd	a6,48(s0)
 78c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 790:	00840613          	addi	a2,s0,8
 794:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 798:	85aa                	mv	a1,a0
 79a:	4505                	li	a0,1
 79c:	00000097          	auipc	ra,0x0
 7a0:	dce080e7          	jalr	-562(ra) # 56a <vprintf>
}
 7a4:	60e2                	ld	ra,24(sp)
 7a6:	6442                	ld	s0,16(sp)
 7a8:	6125                	addi	sp,sp,96
 7aa:	8082                	ret

00000000000007ac <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
 7ac:	1141                	addi	sp,sp,-16
 7ae:	e422                	sd	s0,8(sp)
 7b0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7b2:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b6:	00001797          	auipc	a5,0x1
 7ba:	84a7b783          	ld	a5,-1974(a5) # 1000 <freep>
 7be:	a02d                	j	7e8 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 7c0:	4618                	lw	a4,8(a2)
 7c2:	9f2d                	addw	a4,a4,a1
 7c4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c8:	6398                	ld	a4,0(a5)
 7ca:	6310                	ld	a2,0(a4)
 7cc:	a83d                	j	80a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 7ce:	ff852703          	lw	a4,-8(a0)
 7d2:	9f31                	addw	a4,a4,a2
 7d4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7d6:	ff053683          	ld	a3,-16(a0)
 7da:	a091                	j	81e <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 7dc:	6398                	ld	a4,0(a5)
 7de:	00e7e463          	bltu	a5,a4,7e6 <free+0x3a>
 7e2:	00e6ea63          	bltu	a3,a4,7f6 <free+0x4a>
void free(void *ap) {
 7e6:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e8:	fed7fae3          	bgeu	a5,a3,7dc <free+0x30>
 7ec:	6398                	ld	a4,0(a5)
 7ee:	00e6e463          	bltu	a3,a4,7f6 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 7f2:	fee7eae3          	bltu	a5,a4,7e6 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 7f6:	ff852583          	lw	a1,-8(a0)
 7fa:	6390                	ld	a2,0(a5)
 7fc:	02059813          	slli	a6,a1,0x20
 800:	01c85713          	srli	a4,a6,0x1c
 804:	9736                	add	a4,a4,a3
 806:	fae60de3          	beq	a2,a4,7c0 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 80a:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 80e:	4790                	lw	a2,8(a5)
 810:	02061593          	slli	a1,a2,0x20
 814:	01c5d713          	srli	a4,a1,0x1c
 818:	973e                	add	a4,a4,a5
 81a:	fae68ae3          	beq	a3,a4,7ce <free+0x22>
    p->s.ptr = bp->s.ptr;
 81e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 820:	00000717          	auipc	a4,0x0
 824:	7ef73023          	sd	a5,2016(a4) # 1000 <freep>
}
 828:	6422                	ld	s0,8(sp)
 82a:	0141                	addi	sp,sp,16
 82c:	8082                	ret

000000000000082e <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
 82e:	7139                	addi	sp,sp,-64
 830:	fc06                	sd	ra,56(sp)
 832:	f822                	sd	s0,48(sp)
 834:	f426                	sd	s1,40(sp)
 836:	f04a                	sd	s2,32(sp)
 838:	ec4e                	sd	s3,24(sp)
 83a:	e852                	sd	s4,16(sp)
 83c:	e456                	sd	s5,8(sp)
 83e:	e05a                	sd	s6,0(sp)
 840:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 842:	02051493          	slli	s1,a0,0x20
 846:	9081                	srli	s1,s1,0x20
 848:	04bd                	addi	s1,s1,15
 84a:	8091                	srli	s1,s1,0x4
 84c:	0014899b          	addiw	s3,s1,1
 850:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 852:	00000517          	auipc	a0,0x0
 856:	7ae53503          	ld	a0,1966(a0) # 1000 <freep>
 85a:	c515                	beqz	a0,886 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 85c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 85e:	4798                	lw	a4,8(a5)
 860:	02977f63          	bgeu	a4,s1,89e <malloc+0x70>
 864:	8a4e                	mv	s4,s3
 866:	0009871b          	sext.w	a4,s3
 86a:	6685                	lui	a3,0x1
 86c:	00d77363          	bgeu	a4,a3,872 <malloc+0x44>
 870:	6a05                	lui	s4,0x1
 872:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 876:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 87a:	00000917          	auipc	s2,0x0
 87e:	78690913          	addi	s2,s2,1926 # 1000 <freep>
  if (p == (char *)-1) return 0;
 882:	5afd                	li	s5,-1
 884:	a895                	j	8f8 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 886:	00000797          	auipc	a5,0x0
 88a:	78a78793          	addi	a5,a5,1930 # 1010 <base>
 88e:	00000717          	auipc	a4,0x0
 892:	76f73923          	sd	a5,1906(a4) # 1000 <freep>
 896:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 898:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 89c:	b7e1                	j	864 <malloc+0x36>
      if (p->s.size == nunits)
 89e:	02e48c63          	beq	s1,a4,8d6 <malloc+0xa8>
        p->s.size -= nunits;
 8a2:	4137073b          	subw	a4,a4,s3
 8a6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8a8:	02071693          	slli	a3,a4,0x20
 8ac:	01c6d713          	srli	a4,a3,0x1c
 8b0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8b6:	00000717          	auipc	a4,0x0
 8ba:	74a73523          	sd	a0,1866(a4) # 1000 <freep>
      return (void *)(p + 1);
 8be:	01078513          	addi	a0,a5,16
      if ((p = morecore(nunits)) == 0) return 0;
  }
}
 8c2:	70e2                	ld	ra,56(sp)
 8c4:	7442                	ld	s0,48(sp)
 8c6:	74a2                	ld	s1,40(sp)
 8c8:	7902                	ld	s2,32(sp)
 8ca:	69e2                	ld	s3,24(sp)
 8cc:	6a42                	ld	s4,16(sp)
 8ce:	6aa2                	ld	s5,8(sp)
 8d0:	6b02                	ld	s6,0(sp)
 8d2:	6121                	addi	sp,sp,64
 8d4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8d6:	6398                	ld	a4,0(a5)
 8d8:	e118                	sd	a4,0(a0)
 8da:	bff1                	j	8b6 <malloc+0x88>
  hp->s.size = nu;
 8dc:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8e0:	0541                	addi	a0,a0,16
 8e2:	00000097          	auipc	ra,0x0
 8e6:	eca080e7          	jalr	-310(ra) # 7ac <free>
  return freep;
 8ea:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
 8ee:	d971                	beqz	a0,8c2 <malloc+0x94>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8f0:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8f2:	4798                	lw	a4,8(a5)
 8f4:	fa9775e3          	bgeu	a4,s1,89e <malloc+0x70>
    if (p == freep)
 8f8:	00093703          	ld	a4,0(s2)
 8fc:	853e                	mv	a0,a5
 8fe:	fef719e3          	bne	a4,a5,8f0 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 902:	8552                	mv	a0,s4
 904:	00000097          	auipc	ra,0x0
 908:	b70080e7          	jalr	-1168(ra) # 474 <sbrk>
  if (p == (char *)-1) return 0;
 90c:	fd5518e3          	bne	a0,s5,8dc <malloc+0xae>
      if ((p = morecore(nunits)) == 0) return 0;
 910:	4501                	li	a0,0
 912:	bf45                	j	8c2 <malloc+0x94>

0000000000000914 <dump_test2_asm>:
#include "kernel/syscall.h"
.globl dump_test2_asm
dump_test2_asm:
  li s2, 2
 914:	4909                	li	s2,2
  li s3, 3
 916:	498d                	li	s3,3
  li s4, 4
 918:	4a11                	li	s4,4
  li s5, 5
 91a:	4a95                	li	s5,5
  li s6, 6
 91c:	4b19                	li	s6,6
  li s7, 7
 91e:	4b9d                	li	s7,7
  li s8, 8
 920:	4c21                	li	s8,8
  li s9, 9
 922:	4ca5                	li	s9,9
  li s10, 10
 924:	4d29                	li	s10,10
  li s11, 11
 926:	4dad                	li	s11,11
#ifdef SYS_dump
  li a7, SYS_dump
 928:	48d9                	li	a7,22
  ecall
 92a:	00000073          	ecall
#endif
  ret
 92e:	8082                	ret

0000000000000930 <dump_test3_asm>:
.globl dump_test3_asm
dump_test3_asm:
  li s2, 1
 930:	4905                	li	s2,1
  li s3, -12
 932:	59d1                	li	s3,-12
  li s4, 123
 934:	07b00a13          	li	s4,123
  li s5, -1234
 938:	b2e00a93          	li	s5,-1234
  li s6, 12345
 93c:	6b0d                	lui	s6,0x3
 93e:	039b0b1b          	addiw	s6,s6,57 # 3039 <base+0x2029>
  li s7, -123456
 942:	7b89                	lui	s7,0xfffe2
 944:	dc0b8b9b          	addiw	s7,s7,-576 # fffffffffffe1dc0 <base+0xfffffffffffe0db0>
  li s8, 1234567
 948:	0012dc37          	lui	s8,0x12d
 94c:	687c0c1b          	addiw	s8,s8,1671 # 12d687 <base+0x12c677>
  li s9, -12345678
 950:	ff43acb7          	lui	s9,0xff43a
 954:	eb2c8c9b          	addiw	s9,s9,-334 # ffffffffff439eb2 <base+0xffffffffff438ea2>
  li s10, 123456789
 958:	075bdd37          	lui	s10,0x75bd
 95c:	d15d0d1b          	addiw	s10,s10,-747 # 75bcd15 <base+0x75bbd05>
  li s11, -1234567890
 960:	b66a0db7          	lui	s11,0xb66a0
 964:	d2ed8d9b          	addiw	s11,s11,-722 # ffffffffb669fd2e <base+0xffffffffb669ed1e>
#ifdef SYS_dump
  li a7, SYS_dump
 968:	48d9                	li	a7,22
  ecall
 96a:	00000073          	ecall
#endif
  ret
 96e:	8082                	ret

0000000000000970 <dump_test4_asm>:
.globl dump_test4_asm
dump_test4_asm:
  li s2, 2147483647
 970:	80000937          	lui	s2,0x80000
 974:	397d                	addiw	s2,s2,-1 # 7fffffff <base+0x7fffefef>
  li s3, -2147483648
 976:	800009b7          	lui	s3,0x80000
  li s4, 1337
 97a:	53900a13          	li	s4,1337
  li s5, 2020
 97e:	7e400a93          	li	s5,2020
  li s6, 3234
 982:	6b05                	lui	s6,0x1
 984:	ca2b0b1b          	addiw	s6,s6,-862 # ca2 <digits+0x222>
  li s7, 3235
 988:	6b85                	lui	s7,0x1
 98a:	ca3b8b9b          	addiw	s7,s7,-861 # ca3 <digits+0x223>
  li s8, 3236
 98e:	6c05                	lui	s8,0x1
 990:	ca4c0c1b          	addiw	s8,s8,-860 # ca4 <digits+0x224>
  li s9, 3237
 994:	6c85                	lui	s9,0x1
 996:	ca5c8c9b          	addiw	s9,s9,-859 # ca5 <digits+0x225>
  li s10, 3238
 99a:	6d05                	lui	s10,0x1
 99c:	ca6d0d1b          	addiw	s10,s10,-858 # ca6 <digits+0x226>
  li s11, 3239
 9a0:	6d85                	lui	s11,0x1
 9a2:	ca7d8d9b          	addiw	s11,s11,-857 # ca7 <digits+0x227>
#ifdef SYS_dump
  li a7, SYS_dump
 9a6:	48d9                	li	a7,22
  ecall
 9a8:	00000073          	ecall
#endif
  ret
 9ac:	8082                	ret

00000000000009ae <dump2_test1_asm>:
#include "kernel/syscall.h"
.globl dump2_test1_asm
dump2_test1_asm:
  li s2, 2
 9ae:	4909                	li	s2,2
  li s3, 3
 9b0:	498d                	li	s3,3
  li s4, 4
 9b2:	4a11                	li	s4,4
  li s5, 5
 9b4:	4a95                	li	s5,5
  li s6, 6
 9b6:	4b19                	li	s6,6
  li s7, 7
 9b8:	4b9d                	li	s7,7
  li s8, 8
 9ba:	4c21                	li	s8,8
  li s9, 9
 9bc:	4ca5                	li	s9,9
  li s10, 10
 9be:	4d29                	li	s10,10
  li s11, 11
 9c0:	4dad                	li	s11,11
  li a7, SYS_write
 9c2:	48c1                	li	a7,16
  ecall
 9c4:	00000073          	ecall
  j loop
 9c8:	a82d                	j	a02 <loop>

00000000000009ca <dump2_test2_asm>:

.globl dump2_test2_asm
dump2_test2_asm:
  li s2, 4
 9ca:	4911                	li	s2,4
  li s3, 9
 9cc:	49a5                	li	s3,9
  li s4, 16
 9ce:	4a41                	li	s4,16
  li s5, 25
 9d0:	4ae5                	li	s5,25
  li s6, 36
 9d2:	02400b13          	li	s6,36
  li s7, 49
 9d6:	03100b93          	li	s7,49
  li s8, 64
 9da:	04000c13          	li	s8,64
  li s9, 81
 9de:	05100c93          	li	s9,81
  li s10, 100
 9e2:	06400d13          	li	s10,100
  li s11, 121
 9e6:	07900d93          	li	s11,121
  li a7, SYS_write
 9ea:	48c1                	li	a7,16
  ecall
 9ec:	00000073          	ecall
  j loop
 9f0:	a809                	j	a02 <loop>

00000000000009f2 <dump2_test3_asm>:

.globl dump2_test3_asm
dump2_test3_asm:
  li s2, 1337
 9f2:	53900913          	li	s2,1337
  mv a2, a1
 9f6:	862e                	mv	a2,a1
  li a1, 2
 9f8:	4589                	li	a1,2
#ifdef SYS_dump2
  li a7, SYS_dump2
 9fa:	48dd                	li	a7,23
  ecall
 9fc:	00000073          	ecall
#endif
  ret
 a00:	8082                	ret

0000000000000a02 <loop>:

loop:
  j loop
 a02:	a001                	j	a02 <loop>
  ret
 a04:	8082                	ret
