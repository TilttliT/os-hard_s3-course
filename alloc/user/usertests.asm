
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
    close(fds[1]);
  }
}

// what if you pass ridiculous string pointers to system calls?
void copyinstr1(char *s) {
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = {0x80000000LL, 0xffffffffffffffff};

  for (int ai = 0; ai < 2; ai++) {
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE | O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	b10080e7          	jalr	-1264(ra) # 5b20 <open>
    if (fd >= 0) {
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE | O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	afe080e7          	jalr	-1282(ra) # 5b20 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if (fd >= 0) {
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	fc250513          	addi	a0,a0,-62 # 6000 <malloc+0xee>
      46:	00006097          	auipc	ra,0x6
      4a:	e14080e7          	jalr	-492(ra) # 5e5a <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	a90080e7          	jalr	-1392(ra) # 5ae0 <exit>

0000000000000058 <bsstest>:
// does uninitialized data start out zero?
char uninit[10000];
void bsstest(char *s) {
  int i;

  for (i = 0; i < sizeof(uninit); i++) {
      58:	0000a797          	auipc	a5,0xa
      5c:	50078793          	addi	a5,a5,1280 # a558 <uninit>
      60:	0000d697          	auipc	a3,0xd
      64:	c0868693          	addi	a3,a3,-1016 # cc68 <buf>
    if (uninit[i] != '\0') {
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for (i = 0; i < sizeof(uninit); i++) {
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
void bsstest(char *s) {
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	fa050513          	addi	a0,a0,-96 # 6020 <malloc+0x10e>
      88:	00006097          	auipc	ra,0x6
      8c:	dd2080e7          	jalr	-558(ra) # 5e5a <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	a4e080e7          	jalr	-1458(ra) # 5ae0 <exit>

000000000000009a <opentest>:
void opentest(char *s) {
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	f9050513          	addi	a0,a0,-112 # 6038 <malloc+0x126>
      b0:	00006097          	auipc	ra,0x6
      b4:	a70080e7          	jalr	-1424(ra) # 5b20 <open>
  if (fd < 0) {
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	a4c080e7          	jalr	-1460(ra) # 5b08 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	f9250513          	addi	a0,a0,-110 # 6058 <malloc+0x146>
      ce:	00006097          	auipc	ra,0x6
      d2:	a52080e7          	jalr	-1454(ra) # 5b20 <open>
  if (fd >= 0) {
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	f5a50513          	addi	a0,a0,-166 # 6040 <malloc+0x12e>
      ee:	00006097          	auipc	ra,0x6
      f2:	d6c080e7          	jalr	-660(ra) # 5e5a <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	9e8080e7          	jalr	-1560(ra) # 5ae0 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	f6650513          	addi	a0,a0,-154 # 6068 <malloc+0x156>
     10a:	00006097          	auipc	ra,0x6
     10e:	d50080e7          	jalr	-688(ra) # 5e5a <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	9cc080e7          	jalr	-1588(ra) # 5ae0 <exit>

000000000000011c <truncate2>:
void truncate2(char *s) {
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	f6450513          	addi	a0,a0,-156 # 6090 <malloc+0x17e>
     134:	00006097          	auipc	ra,0x6
     138:	9fc080e7          	jalr	-1540(ra) # 5b30 <unlink>
  int fd1 = open("truncfile", O_CREATE | O_TRUNC | O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	f5050513          	addi	a0,a0,-176 # 6090 <malloc+0x17e>
     148:	00006097          	auipc	ra,0x6
     14c:	9d8080e7          	jalr	-1576(ra) # 5b20 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	f4c58593          	addi	a1,a1,-180 # 60a0 <malloc+0x18e>
     15c:	00006097          	auipc	ra,0x6
     160:	9a4080e7          	jalr	-1628(ra) # 5b00 <write>
  int fd2 = open("truncfile", O_TRUNC | O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	f2850513          	addi	a0,a0,-216 # 6090 <malloc+0x17e>
     170:	00006097          	auipc	ra,0x6
     174:	9b0080e7          	jalr	-1616(ra) # 5b20 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	f2c58593          	addi	a1,a1,-212 # 60a8 <malloc+0x196>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	97a080e7          	jalr	-1670(ra) # 5b00 <write>
  if (n != -1) {
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	efc50513          	addi	a0,a0,-260 # 6090 <malloc+0x17e>
     19c:	00006097          	auipc	ra,0x6
     1a0:	994080e7          	jalr	-1644(ra) # 5b30 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	962080e7          	jalr	-1694(ra) # 5b08 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	958080e7          	jalr	-1704(ra) # 5b08 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	ee650513          	addi	a0,a0,-282 # 60b0 <malloc+0x19e>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	c88080e7          	jalr	-888(ra) # 5e5a <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	904080e7          	jalr	-1788(ra) # 5ae0 <exit>

00000000000001e4 <createtest>:
void createtest(char *s) {
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for (i = 0; i < N; i++) {
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE | O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	910080e7          	jalr	-1776(ra) # 5b20 <open>
    close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	8f0080e7          	jalr	-1808(ra) # 5b08 <close>
  for (i = 0; i < N; i++) {
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for (i = 0; i < N; i++) {
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	8ea080e7          	jalr	-1814(ra) # 5b30 <unlink>
  for (i = 0; i < N; i++) {
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
void bigwrite(char *s) {
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	e5c50513          	addi	a0,a0,-420 # 60d8 <malloc+0x1c6>
     284:	00006097          	auipc	ra,0x6
     288:	8ac080e7          	jalr	-1876(ra) # 5b30 <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	e48a8a93          	addi	s5,s5,-440 # 60d8 <malloc+0x1c6>
      int cc = write(fd, buf, sz);
     298:	0000da17          	auipc	s4,0xd
     29c:	9d0a0a13          	addi	s4,s4,-1584 # cc68 <buf>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <diskfull+0xe7>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	874080e7          	jalr	-1932(ra) # 5b20 <open>
     2b4:	892a                	mv	s2,a0
    if (fd < 0) {
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	842080e7          	jalr	-1982(ra) # 5b00 <write>
     2c6:	89aa                	mv	s3,a0
      if (cc != sz) {
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	82e080e7          	jalr	-2002(ra) # 5b00 <write>
      if (cc != sz) {
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	828080e7          	jalr	-2008(ra) # 5b08 <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	846080e7          	jalr	-1978(ra) # 5b30 <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	dd650513          	addi	a0,a0,-554 # 60e8 <malloc+0x1d6>
     31a:	00006097          	auipc	ra,0x6
     31e:	b40080e7          	jalr	-1216(ra) # 5e5a <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00005097          	auipc	ra,0x5
     328:	7bc080e7          	jalr	1980(ra) # 5ae0 <exit>
      if (cc != sz) {
     32c:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	dd450513          	addi	a0,a0,-556 # 6108 <malloc+0x1f6>
     33c:	00006097          	auipc	ra,0x6
     340:	b1e080e7          	jalr	-1250(ra) # 5e5a <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00005097          	auipc	ra,0x5
     34a:	79a080e7          	jalr	1946(ra) # 5ae0 <exit>

000000000000034e <badwrite>:
// regression test. does write() with an invalid buffer pointer cause
// a block to be allocated for a file that is then not freed when the
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void badwrite(char *s) {
     34e:	7179                	addi	sp,sp,-48
     350:	f406                	sd	ra,40(sp)
     352:	f022                	sd	s0,32(sp)
     354:	ec26                	sd	s1,24(sp)
     356:	e84a                	sd	s2,16(sp)
     358:	e44e                	sd	s3,8(sp)
     35a:	e052                	sd	s4,0(sp)
     35c:	1800                	addi	s0,sp,48
  int assumed_free = 600;

  unlink("junk");
     35e:	00006517          	auipc	a0,0x6
     362:	dc250513          	addi	a0,a0,-574 # 6120 <malloc+0x20e>
     366:	00005097          	auipc	ra,0x5
     36a:	7ca080e7          	jalr	1994(ra) # 5b30 <unlink>
     36e:	25800913          	li	s2,600
  for (int i = 0; i < assumed_free; i++) {
    int fd = open("junk", O_CREATE | O_WRONLY);
     372:	00006997          	auipc	s3,0x6
     376:	dae98993          	addi	s3,s3,-594 # 6120 <malloc+0x20e>
    if (fd < 0) {
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char *)0xffffffffffL, 1);
     37a:	5a7d                	li	s4,-1
     37c:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE | O_WRONLY);
     380:	20100593          	li	a1,513
     384:	854e                	mv	a0,s3
     386:	00005097          	auipc	ra,0x5
     38a:	79a080e7          	jalr	1946(ra) # 5b20 <open>
     38e:	84aa                	mv	s1,a0
    if (fd < 0) {
     390:	06054b63          	bltz	a0,406 <badwrite+0xb8>
    write(fd, (char *)0xffffffffffL, 1);
     394:	4605                	li	a2,1
     396:	85d2                	mv	a1,s4
     398:	00005097          	auipc	ra,0x5
     39c:	768080e7          	jalr	1896(ra) # 5b00 <write>
    close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00005097          	auipc	ra,0x5
     3a6:	766080e7          	jalr	1894(ra) # 5b08 <close>
    unlink("junk");
     3aa:	854e                	mv	a0,s3
     3ac:	00005097          	auipc	ra,0x5
     3b0:	784080e7          	jalr	1924(ra) # 5b30 <unlink>
  for (int i = 0; i < assumed_free; i++) {
     3b4:	397d                	addiw	s2,s2,-1
     3b6:	fc0915e3          	bnez	s2,380 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE | O_WRONLY);
     3ba:	20100593          	li	a1,513
     3be:	00006517          	auipc	a0,0x6
     3c2:	d6250513          	addi	a0,a0,-670 # 6120 <malloc+0x20e>
     3c6:	00005097          	auipc	ra,0x5
     3ca:	75a080e7          	jalr	1882(ra) # 5b20 <open>
     3ce:	84aa                	mv	s1,a0
  if (fd < 0) {
     3d0:	04054863          	bltz	a0,420 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if (write(fd, "x", 1) != 1) {
     3d4:	4605                	li	a2,1
     3d6:	00006597          	auipc	a1,0x6
     3da:	cd258593          	addi	a1,a1,-814 # 60a8 <malloc+0x196>
     3de:	00005097          	auipc	ra,0x5
     3e2:	722080e7          	jalr	1826(ra) # 5b00 <write>
     3e6:	4785                	li	a5,1
     3e8:	04f50963          	beq	a0,a5,43a <badwrite+0xec>
    printf("write failed\n");
     3ec:	00006517          	auipc	a0,0x6
     3f0:	d5450513          	addi	a0,a0,-684 # 6140 <malloc+0x22e>
     3f4:	00006097          	auipc	ra,0x6
     3f8:	a66080e7          	jalr	-1434(ra) # 5e5a <printf>
    exit(1);
     3fc:	4505                	li	a0,1
     3fe:	00005097          	auipc	ra,0x5
     402:	6e2080e7          	jalr	1762(ra) # 5ae0 <exit>
      printf("open junk failed\n");
     406:	00006517          	auipc	a0,0x6
     40a:	d2250513          	addi	a0,a0,-734 # 6128 <malloc+0x216>
     40e:	00006097          	auipc	ra,0x6
     412:	a4c080e7          	jalr	-1460(ra) # 5e5a <printf>
      exit(1);
     416:	4505                	li	a0,1
     418:	00005097          	auipc	ra,0x5
     41c:	6c8080e7          	jalr	1736(ra) # 5ae0 <exit>
    printf("open junk failed\n");
     420:	00006517          	auipc	a0,0x6
     424:	d0850513          	addi	a0,a0,-760 # 6128 <malloc+0x216>
     428:	00006097          	auipc	ra,0x6
     42c:	a32080e7          	jalr	-1486(ra) # 5e5a <printf>
    exit(1);
     430:	4505                	li	a0,1
     432:	00005097          	auipc	ra,0x5
     436:	6ae080e7          	jalr	1710(ra) # 5ae0 <exit>
  }
  close(fd);
     43a:	8526                	mv	a0,s1
     43c:	00005097          	auipc	ra,0x5
     440:	6cc080e7          	jalr	1740(ra) # 5b08 <close>
  unlink("junk");
     444:	00006517          	auipc	a0,0x6
     448:	cdc50513          	addi	a0,a0,-804 # 6120 <malloc+0x20e>
     44c:	00005097          	auipc	ra,0x5
     450:	6e4080e7          	jalr	1764(ra) # 5b30 <unlink>

  exit(0);
     454:	4501                	li	a0,0
     456:	00005097          	auipc	ra,0x5
     45a:	68a080e7          	jalr	1674(ra) # 5ae0 <exit>

000000000000045e <outofinodes>:
    name[4] = '\0';
    unlink(name);
  }
}

void outofinodes(char *s) {
     45e:	715d                	addi	sp,sp,-80
     460:	e486                	sd	ra,72(sp)
     462:	e0a2                	sd	s0,64(sp)
     464:	fc26                	sd	s1,56(sp)
     466:	f84a                	sd	s2,48(sp)
     468:	f44e                	sd	s3,40(sp)
     46a:	0880                	addi	s0,sp,80
  int nzz = 32 * 32;
  for (int i = 0; i < nzz; i++) {
     46c:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     46e:	07a00913          	li	s2,122
  for (int i = 0; i < nzz; i++) {
     472:	40000993          	li	s3,1024
    name[0] = 'z';
     476:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     47a:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     47e:	41f4d71b          	sraiw	a4,s1,0x1f
     482:	01b7571b          	srliw	a4,a4,0x1b
     486:	009707bb          	addw	a5,a4,s1
     48a:	4057d69b          	sraiw	a3,a5,0x5
     48e:	0306869b          	addiw	a3,a3,48
     492:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     496:	8bfd                	andi	a5,a5,31
     498:	9f99                	subw	a5,a5,a4
     49a:	0307879b          	addiw	a5,a5,48
     49e:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4a2:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4a6:	fb040513          	addi	a0,s0,-80
     4aa:	00005097          	auipc	ra,0x5
     4ae:	686080e7          	jalr	1670(ra) # 5b30 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
     4b2:	60200593          	li	a1,1538
     4b6:	fb040513          	addi	a0,s0,-80
     4ba:	00005097          	auipc	ra,0x5
     4be:	666080e7          	jalr	1638(ra) # 5b20 <open>
    if (fd < 0) {
     4c2:	00054963          	bltz	a0,4d4 <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4c6:	00005097          	auipc	ra,0x5
     4ca:	642080e7          	jalr	1602(ra) # 5b08 <close>
  for (int i = 0; i < nzz; i++) {
     4ce:	2485                	addiw	s1,s1,1
     4d0:	fb3493e3          	bne	s1,s3,476 <outofinodes+0x18>
     4d4:	4481                	li	s1,0
  }

  for (int i = 0; i < nzz; i++) {
    char name[32];
    name[0] = 'z';
     4d6:	07a00913          	li	s2,122
  for (int i = 0; i < nzz; i++) {
     4da:	40000993          	li	s3,1024
    name[0] = 'z';
     4de:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4e2:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4e6:	41f4d71b          	sraiw	a4,s1,0x1f
     4ea:	01b7571b          	srliw	a4,a4,0x1b
     4ee:	009707bb          	addw	a5,a4,s1
     4f2:	4057d69b          	sraiw	a3,a5,0x5
     4f6:	0306869b          	addiw	a3,a3,48
     4fa:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     4fe:	8bfd                	andi	a5,a5,31
     500:	9f99                	subw	a5,a5,a4
     502:	0307879b          	addiw	a5,a5,48
     506:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     50a:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     50e:	fb040513          	addi	a0,s0,-80
     512:	00005097          	auipc	ra,0x5
     516:	61e080e7          	jalr	1566(ra) # 5b30 <unlink>
  for (int i = 0; i < nzz; i++) {
     51a:	2485                	addiw	s1,s1,1
     51c:	fd3491e3          	bne	s1,s3,4de <outofinodes+0x80>
  }
}
     520:	60a6                	ld	ra,72(sp)
     522:	6406                	ld	s0,64(sp)
     524:	74e2                	ld	s1,56(sp)
     526:	7942                	ld	s2,48(sp)
     528:	79a2                	ld	s3,40(sp)
     52a:	6161                	addi	sp,sp,80
     52c:	8082                	ret

000000000000052e <copyin>:
void copyin(char *s) {
     52e:	715d                	addi	sp,sp,-80
     530:	e486                	sd	ra,72(sp)
     532:	e0a2                	sd	s0,64(sp)
     534:	fc26                	sd	s1,56(sp)
     536:	f84a                	sd	s2,48(sp)
     538:	f44e                	sd	s3,40(sp)
     53a:	f052                	sd	s4,32(sp)
     53c:	0880                	addi	s0,sp,80
  uint64 addrs[] = {0x80000000LL, 0xffffffffffffffff};
     53e:	4785                	li	a5,1
     540:	07fe                	slli	a5,a5,0x1f
     542:	fcf43023          	sd	a5,-64(s0)
     546:	57fd                	li	a5,-1
     548:	fcf43423          	sd	a5,-56(s0)
  for (int ai = 0; ai < 2; ai++) {
     54c:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     550:	00006a17          	auipc	s4,0x6
     554:	c00a0a13          	addi	s4,s4,-1024 # 6150 <malloc+0x23e>
    uint64 addr = addrs[ai];
     558:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     55c:	20100593          	li	a1,513
     560:	8552                	mv	a0,s4
     562:	00005097          	auipc	ra,0x5
     566:	5be080e7          	jalr	1470(ra) # 5b20 <open>
     56a:	84aa                	mv	s1,a0
    if (fd < 0) {
     56c:	08054863          	bltz	a0,5fc <copyin+0xce>
    int n = write(fd, (void *)addr, 8192);
     570:	6609                	lui	a2,0x2
     572:	85ce                	mv	a1,s3
     574:	00005097          	auipc	ra,0x5
     578:	58c080e7          	jalr	1420(ra) # 5b00 <write>
    if (n >= 0) {
     57c:	08055d63          	bgez	a0,616 <copyin+0xe8>
    close(fd);
     580:	8526                	mv	a0,s1
     582:	00005097          	auipc	ra,0x5
     586:	586080e7          	jalr	1414(ra) # 5b08 <close>
    unlink("copyin1");
     58a:	8552                	mv	a0,s4
     58c:	00005097          	auipc	ra,0x5
     590:	5a4080e7          	jalr	1444(ra) # 5b30 <unlink>
    n = write(1, (char *)addr, 8192);
     594:	6609                	lui	a2,0x2
     596:	85ce                	mv	a1,s3
     598:	4505                	li	a0,1
     59a:	00005097          	auipc	ra,0x5
     59e:	566080e7          	jalr	1382(ra) # 5b00 <write>
    if (n > 0) {
     5a2:	08a04963          	bgtz	a0,634 <copyin+0x106>
    if (pipe(fds) < 0) {
     5a6:	fb840513          	addi	a0,s0,-72
     5aa:	00005097          	auipc	ra,0x5
     5ae:	546080e7          	jalr	1350(ra) # 5af0 <pipe>
     5b2:	0a054063          	bltz	a0,652 <copyin+0x124>
    n = write(fds[1], (char *)addr, 8192);
     5b6:	6609                	lui	a2,0x2
     5b8:	85ce                	mv	a1,s3
     5ba:	fbc42503          	lw	a0,-68(s0)
     5be:	00005097          	auipc	ra,0x5
     5c2:	542080e7          	jalr	1346(ra) # 5b00 <write>
    if (n > 0) {
     5c6:	0aa04363          	bgtz	a0,66c <copyin+0x13e>
    close(fds[0]);
     5ca:	fb842503          	lw	a0,-72(s0)
     5ce:	00005097          	auipc	ra,0x5
     5d2:	53a080e7          	jalr	1338(ra) # 5b08 <close>
    close(fds[1]);
     5d6:	fbc42503          	lw	a0,-68(s0)
     5da:	00005097          	auipc	ra,0x5
     5de:	52e080e7          	jalr	1326(ra) # 5b08 <close>
  for (int ai = 0; ai < 2; ai++) {
     5e2:	0921                	addi	s2,s2,8
     5e4:	fd040793          	addi	a5,s0,-48
     5e8:	f6f918e3          	bne	s2,a5,558 <copyin+0x2a>
}
     5ec:	60a6                	ld	ra,72(sp)
     5ee:	6406                	ld	s0,64(sp)
     5f0:	74e2                	ld	s1,56(sp)
     5f2:	7942                	ld	s2,48(sp)
     5f4:	79a2                	ld	s3,40(sp)
     5f6:	7a02                	ld	s4,32(sp)
     5f8:	6161                	addi	sp,sp,80
     5fa:	8082                	ret
      printf("open(copyin1) failed\n");
     5fc:	00006517          	auipc	a0,0x6
     600:	b5c50513          	addi	a0,a0,-1188 # 6158 <malloc+0x246>
     604:	00006097          	auipc	ra,0x6
     608:	856080e7          	jalr	-1962(ra) # 5e5a <printf>
      exit(1);
     60c:	4505                	li	a0,1
     60e:	00005097          	auipc	ra,0x5
     612:	4d2080e7          	jalr	1234(ra) # 5ae0 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     616:	862a                	mv	a2,a0
     618:	85ce                	mv	a1,s3
     61a:	00006517          	auipc	a0,0x6
     61e:	b5650513          	addi	a0,a0,-1194 # 6170 <malloc+0x25e>
     622:	00006097          	auipc	ra,0x6
     626:	838080e7          	jalr	-1992(ra) # 5e5a <printf>
      exit(1);
     62a:	4505                	li	a0,1
     62c:	00005097          	auipc	ra,0x5
     630:	4b4080e7          	jalr	1204(ra) # 5ae0 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     634:	862a                	mv	a2,a0
     636:	85ce                	mv	a1,s3
     638:	00006517          	auipc	a0,0x6
     63c:	b6850513          	addi	a0,a0,-1176 # 61a0 <malloc+0x28e>
     640:	00006097          	auipc	ra,0x6
     644:	81a080e7          	jalr	-2022(ra) # 5e5a <printf>
      exit(1);
     648:	4505                	li	a0,1
     64a:	00005097          	auipc	ra,0x5
     64e:	496080e7          	jalr	1174(ra) # 5ae0 <exit>
      printf("pipe() failed\n");
     652:	00006517          	auipc	a0,0x6
     656:	b7e50513          	addi	a0,a0,-1154 # 61d0 <malloc+0x2be>
     65a:	00006097          	auipc	ra,0x6
     65e:	800080e7          	jalr	-2048(ra) # 5e5a <printf>
      exit(1);
     662:	4505                	li	a0,1
     664:	00005097          	auipc	ra,0x5
     668:	47c080e7          	jalr	1148(ra) # 5ae0 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     66c:	862a                	mv	a2,a0
     66e:	85ce                	mv	a1,s3
     670:	00006517          	auipc	a0,0x6
     674:	b7050513          	addi	a0,a0,-1168 # 61e0 <malloc+0x2ce>
     678:	00005097          	auipc	ra,0x5
     67c:	7e2080e7          	jalr	2018(ra) # 5e5a <printf>
      exit(1);
     680:	4505                	li	a0,1
     682:	00005097          	auipc	ra,0x5
     686:	45e080e7          	jalr	1118(ra) # 5ae0 <exit>

000000000000068a <copyout>:
void copyout(char *s) {
     68a:	711d                	addi	sp,sp,-96
     68c:	ec86                	sd	ra,88(sp)
     68e:	e8a2                	sd	s0,80(sp)
     690:	e4a6                	sd	s1,72(sp)
     692:	e0ca                	sd	s2,64(sp)
     694:	fc4e                	sd	s3,56(sp)
     696:	f852                	sd	s4,48(sp)
     698:	f456                	sd	s5,40(sp)
     69a:	1080                	addi	s0,sp,96
  uint64 addrs[] = {0x80000000LL, 0xffffffffffffffff};
     69c:	4785                	li	a5,1
     69e:	07fe                	slli	a5,a5,0x1f
     6a0:	faf43823          	sd	a5,-80(s0)
     6a4:	57fd                	li	a5,-1
     6a6:	faf43c23          	sd	a5,-72(s0)
  for (int ai = 0; ai < 2; ai++) {
     6aa:	fb040913          	addi	s2,s0,-80
    int fd = open("xv6-readme", 0);
     6ae:	00006a17          	auipc	s4,0x6
     6b2:	b62a0a13          	addi	s4,s4,-1182 # 6210 <malloc+0x2fe>
    n = write(fds[1], "x", 1);
     6b6:	00006a97          	auipc	s5,0x6
     6ba:	9f2a8a93          	addi	s5,s5,-1550 # 60a8 <malloc+0x196>
    uint64 addr = addrs[ai];
     6be:	00093983          	ld	s3,0(s2)
    int fd = open("xv6-readme", 0);
     6c2:	4581                	li	a1,0
     6c4:	8552                	mv	a0,s4
     6c6:	00005097          	auipc	ra,0x5
     6ca:	45a080e7          	jalr	1114(ra) # 5b20 <open>
     6ce:	84aa                	mv	s1,a0
    if (fd < 0) {
     6d0:	08054663          	bltz	a0,75c <copyout+0xd2>
    int n = read(fd, (void *)addr, 8192);
     6d4:	6609                	lui	a2,0x2
     6d6:	85ce                	mv	a1,s3
     6d8:	00005097          	auipc	ra,0x5
     6dc:	420080e7          	jalr	1056(ra) # 5af8 <read>
    if (n > 0) {
     6e0:	08a04b63          	bgtz	a0,776 <copyout+0xec>
    close(fd);
     6e4:	8526                	mv	a0,s1
     6e6:	00005097          	auipc	ra,0x5
     6ea:	422080e7          	jalr	1058(ra) # 5b08 <close>
    if (pipe(fds) < 0) {
     6ee:	fa840513          	addi	a0,s0,-88
     6f2:	00005097          	auipc	ra,0x5
     6f6:	3fe080e7          	jalr	1022(ra) # 5af0 <pipe>
     6fa:	08054d63          	bltz	a0,794 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     6fe:	4605                	li	a2,1
     700:	85d6                	mv	a1,s5
     702:	fac42503          	lw	a0,-84(s0)
     706:	00005097          	auipc	ra,0x5
     70a:	3fa080e7          	jalr	1018(ra) # 5b00 <write>
    if (n != 1) {
     70e:	4785                	li	a5,1
     710:	08f51f63          	bne	a0,a5,7ae <copyout+0x124>
    n = read(fds[0], (void *)addr, 8192);
     714:	6609                	lui	a2,0x2
     716:	85ce                	mv	a1,s3
     718:	fa842503          	lw	a0,-88(s0)
     71c:	00005097          	auipc	ra,0x5
     720:	3dc080e7          	jalr	988(ra) # 5af8 <read>
    if (n > 0) {
     724:	0aa04263          	bgtz	a0,7c8 <copyout+0x13e>
    close(fds[0]);
     728:	fa842503          	lw	a0,-88(s0)
     72c:	00005097          	auipc	ra,0x5
     730:	3dc080e7          	jalr	988(ra) # 5b08 <close>
    close(fds[1]);
     734:	fac42503          	lw	a0,-84(s0)
     738:	00005097          	auipc	ra,0x5
     73c:	3d0080e7          	jalr	976(ra) # 5b08 <close>
  for (int ai = 0; ai < 2; ai++) {
     740:	0921                	addi	s2,s2,8
     742:	fc040793          	addi	a5,s0,-64
     746:	f6f91ce3          	bne	s2,a5,6be <copyout+0x34>
}
     74a:	60e6                	ld	ra,88(sp)
     74c:	6446                	ld	s0,80(sp)
     74e:	64a6                	ld	s1,72(sp)
     750:	6906                	ld	s2,64(sp)
     752:	79e2                	ld	s3,56(sp)
     754:	7a42                	ld	s4,48(sp)
     756:	7aa2                	ld	s5,40(sp)
     758:	6125                	addi	sp,sp,96
     75a:	8082                	ret
      printf("open(xv6-readme) failed\n");
     75c:	00006517          	auipc	a0,0x6
     760:	ac450513          	addi	a0,a0,-1340 # 6220 <malloc+0x30e>
     764:	00005097          	auipc	ra,0x5
     768:	6f6080e7          	jalr	1782(ra) # 5e5a <printf>
      exit(1);
     76c:	4505                	li	a0,1
     76e:	00005097          	auipc	ra,0x5
     772:	372080e7          	jalr	882(ra) # 5ae0 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     776:	862a                	mv	a2,a0
     778:	85ce                	mv	a1,s3
     77a:	00006517          	auipc	a0,0x6
     77e:	ac650513          	addi	a0,a0,-1338 # 6240 <malloc+0x32e>
     782:	00005097          	auipc	ra,0x5
     786:	6d8080e7          	jalr	1752(ra) # 5e5a <printf>
      exit(1);
     78a:	4505                	li	a0,1
     78c:	00005097          	auipc	ra,0x5
     790:	354080e7          	jalr	852(ra) # 5ae0 <exit>
      printf("pipe() failed\n");
     794:	00006517          	auipc	a0,0x6
     798:	a3c50513          	addi	a0,a0,-1476 # 61d0 <malloc+0x2be>
     79c:	00005097          	auipc	ra,0x5
     7a0:	6be080e7          	jalr	1726(ra) # 5e5a <printf>
      exit(1);
     7a4:	4505                	li	a0,1
     7a6:	00005097          	auipc	ra,0x5
     7aa:	33a080e7          	jalr	826(ra) # 5ae0 <exit>
      printf("pipe write failed\n");
     7ae:	00006517          	auipc	a0,0x6
     7b2:	ac250513          	addi	a0,a0,-1342 # 6270 <malloc+0x35e>
     7b6:	00005097          	auipc	ra,0x5
     7ba:	6a4080e7          	jalr	1700(ra) # 5e5a <printf>
      exit(1);
     7be:	4505                	li	a0,1
     7c0:	00005097          	auipc	ra,0x5
     7c4:	320080e7          	jalr	800(ra) # 5ae0 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7c8:	862a                	mv	a2,a0
     7ca:	85ce                	mv	a1,s3
     7cc:	00006517          	auipc	a0,0x6
     7d0:	abc50513          	addi	a0,a0,-1348 # 6288 <malloc+0x376>
     7d4:	00005097          	auipc	ra,0x5
     7d8:	686080e7          	jalr	1670(ra) # 5e5a <printf>
      exit(1);
     7dc:	4505                	li	a0,1
     7de:	00005097          	auipc	ra,0x5
     7e2:	302080e7          	jalr	770(ra) # 5ae0 <exit>

00000000000007e6 <truncate1>:
void truncate1(char *s) {
     7e6:	711d                	addi	sp,sp,-96
     7e8:	ec86                	sd	ra,88(sp)
     7ea:	e8a2                	sd	s0,80(sp)
     7ec:	e4a6                	sd	s1,72(sp)
     7ee:	e0ca                	sd	s2,64(sp)
     7f0:	fc4e                	sd	s3,56(sp)
     7f2:	f852                	sd	s4,48(sp)
     7f4:	f456                	sd	s5,40(sp)
     7f6:	1080                	addi	s0,sp,96
     7f8:	8aaa                	mv	s5,a0
  unlink("truncfile");
     7fa:	00006517          	auipc	a0,0x6
     7fe:	89650513          	addi	a0,a0,-1898 # 6090 <malloc+0x17e>
     802:	00005097          	auipc	ra,0x5
     806:	32e080e7          	jalr	814(ra) # 5b30 <unlink>
  int fd1 = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
     80a:	60100593          	li	a1,1537
     80e:	00006517          	auipc	a0,0x6
     812:	88250513          	addi	a0,a0,-1918 # 6090 <malloc+0x17e>
     816:	00005097          	auipc	ra,0x5
     81a:	30a080e7          	jalr	778(ra) # 5b20 <open>
     81e:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     820:	4611                	li	a2,4
     822:	00006597          	auipc	a1,0x6
     826:	87e58593          	addi	a1,a1,-1922 # 60a0 <malloc+0x18e>
     82a:	00005097          	auipc	ra,0x5
     82e:	2d6080e7          	jalr	726(ra) # 5b00 <write>
  close(fd1);
     832:	8526                	mv	a0,s1
     834:	00005097          	auipc	ra,0x5
     838:	2d4080e7          	jalr	724(ra) # 5b08 <close>
  int fd2 = open("truncfile", O_RDONLY);
     83c:	4581                	li	a1,0
     83e:	00006517          	auipc	a0,0x6
     842:	85250513          	addi	a0,a0,-1966 # 6090 <malloc+0x17e>
     846:	00005097          	auipc	ra,0x5
     84a:	2da080e7          	jalr	730(ra) # 5b20 <open>
     84e:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     850:	02000613          	li	a2,32
     854:	fa040593          	addi	a1,s0,-96
     858:	00005097          	auipc	ra,0x5
     85c:	2a0080e7          	jalr	672(ra) # 5af8 <read>
  if (n != 4) {
     860:	4791                	li	a5,4
     862:	0cf51e63          	bne	a0,a5,93e <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY | O_TRUNC);
     866:	40100593          	li	a1,1025
     86a:	00006517          	auipc	a0,0x6
     86e:	82650513          	addi	a0,a0,-2010 # 6090 <malloc+0x17e>
     872:	00005097          	auipc	ra,0x5
     876:	2ae080e7          	jalr	686(ra) # 5b20 <open>
     87a:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     87c:	4581                	li	a1,0
     87e:	00006517          	auipc	a0,0x6
     882:	81250513          	addi	a0,a0,-2030 # 6090 <malloc+0x17e>
     886:	00005097          	auipc	ra,0x5
     88a:	29a080e7          	jalr	666(ra) # 5b20 <open>
     88e:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     890:	02000613          	li	a2,32
     894:	fa040593          	addi	a1,s0,-96
     898:	00005097          	auipc	ra,0x5
     89c:	260080e7          	jalr	608(ra) # 5af8 <read>
     8a0:	8a2a                	mv	s4,a0
  if (n != 0) {
     8a2:	ed4d                	bnez	a0,95c <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8a4:	02000613          	li	a2,32
     8a8:	fa040593          	addi	a1,s0,-96
     8ac:	8526                	mv	a0,s1
     8ae:	00005097          	auipc	ra,0x5
     8b2:	24a080e7          	jalr	586(ra) # 5af8 <read>
     8b6:	8a2a                	mv	s4,a0
  if (n != 0) {
     8b8:	e971                	bnez	a0,98c <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8ba:	4619                	li	a2,6
     8bc:	00006597          	auipc	a1,0x6
     8c0:	a5c58593          	addi	a1,a1,-1444 # 6318 <malloc+0x406>
     8c4:	854e                	mv	a0,s3
     8c6:	00005097          	auipc	ra,0x5
     8ca:	23a080e7          	jalr	570(ra) # 5b00 <write>
  n = read(fd3, buf, sizeof(buf));
     8ce:	02000613          	li	a2,32
     8d2:	fa040593          	addi	a1,s0,-96
     8d6:	854a                	mv	a0,s2
     8d8:	00005097          	auipc	ra,0x5
     8dc:	220080e7          	jalr	544(ra) # 5af8 <read>
  if (n != 6) {
     8e0:	4799                	li	a5,6
     8e2:	0cf51d63          	bne	a0,a5,9bc <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8e6:	02000613          	li	a2,32
     8ea:	fa040593          	addi	a1,s0,-96
     8ee:	8526                	mv	a0,s1
     8f0:	00005097          	auipc	ra,0x5
     8f4:	208080e7          	jalr	520(ra) # 5af8 <read>
  if (n != 2) {
     8f8:	4789                	li	a5,2
     8fa:	0ef51063          	bne	a0,a5,9da <truncate1+0x1f4>
  unlink("truncfile");
     8fe:	00005517          	auipc	a0,0x5
     902:	79250513          	addi	a0,a0,1938 # 6090 <malloc+0x17e>
     906:	00005097          	auipc	ra,0x5
     90a:	22a080e7          	jalr	554(ra) # 5b30 <unlink>
  close(fd1);
     90e:	854e                	mv	a0,s3
     910:	00005097          	auipc	ra,0x5
     914:	1f8080e7          	jalr	504(ra) # 5b08 <close>
  close(fd2);
     918:	8526                	mv	a0,s1
     91a:	00005097          	auipc	ra,0x5
     91e:	1ee080e7          	jalr	494(ra) # 5b08 <close>
  close(fd3);
     922:	854a                	mv	a0,s2
     924:	00005097          	auipc	ra,0x5
     928:	1e4080e7          	jalr	484(ra) # 5b08 <close>
}
     92c:	60e6                	ld	ra,88(sp)
     92e:	6446                	ld	s0,80(sp)
     930:	64a6                	ld	s1,72(sp)
     932:	6906                	ld	s2,64(sp)
     934:	79e2                	ld	s3,56(sp)
     936:	7a42                	ld	s4,48(sp)
     938:	7aa2                	ld	s5,40(sp)
     93a:	6125                	addi	sp,sp,96
     93c:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     93e:	862a                	mv	a2,a0
     940:	85d6                	mv	a1,s5
     942:	00006517          	auipc	a0,0x6
     946:	97650513          	addi	a0,a0,-1674 # 62b8 <malloc+0x3a6>
     94a:	00005097          	auipc	ra,0x5
     94e:	510080e7          	jalr	1296(ra) # 5e5a <printf>
    exit(1);
     952:	4505                	li	a0,1
     954:	00005097          	auipc	ra,0x5
     958:	18c080e7          	jalr	396(ra) # 5ae0 <exit>
    printf("aaa fd3=%d\n", fd3);
     95c:	85ca                	mv	a1,s2
     95e:	00006517          	auipc	a0,0x6
     962:	97a50513          	addi	a0,a0,-1670 # 62d8 <malloc+0x3c6>
     966:	00005097          	auipc	ra,0x5
     96a:	4f4080e7          	jalr	1268(ra) # 5e5a <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     96e:	8652                	mv	a2,s4
     970:	85d6                	mv	a1,s5
     972:	00006517          	auipc	a0,0x6
     976:	97650513          	addi	a0,a0,-1674 # 62e8 <malloc+0x3d6>
     97a:	00005097          	auipc	ra,0x5
     97e:	4e0080e7          	jalr	1248(ra) # 5e5a <printf>
    exit(1);
     982:	4505                	li	a0,1
     984:	00005097          	auipc	ra,0x5
     988:	15c080e7          	jalr	348(ra) # 5ae0 <exit>
    printf("bbb fd2=%d\n", fd2);
     98c:	85a6                	mv	a1,s1
     98e:	00006517          	auipc	a0,0x6
     992:	97a50513          	addi	a0,a0,-1670 # 6308 <malloc+0x3f6>
     996:	00005097          	auipc	ra,0x5
     99a:	4c4080e7          	jalr	1220(ra) # 5e5a <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     99e:	8652                	mv	a2,s4
     9a0:	85d6                	mv	a1,s5
     9a2:	00006517          	auipc	a0,0x6
     9a6:	94650513          	addi	a0,a0,-1722 # 62e8 <malloc+0x3d6>
     9aa:	00005097          	auipc	ra,0x5
     9ae:	4b0080e7          	jalr	1200(ra) # 5e5a <printf>
    exit(1);
     9b2:	4505                	li	a0,1
     9b4:	00005097          	auipc	ra,0x5
     9b8:	12c080e7          	jalr	300(ra) # 5ae0 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9bc:	862a                	mv	a2,a0
     9be:	85d6                	mv	a1,s5
     9c0:	00006517          	auipc	a0,0x6
     9c4:	96050513          	addi	a0,a0,-1696 # 6320 <malloc+0x40e>
     9c8:	00005097          	auipc	ra,0x5
     9cc:	492080e7          	jalr	1170(ra) # 5e5a <printf>
    exit(1);
     9d0:	4505                	li	a0,1
     9d2:	00005097          	auipc	ra,0x5
     9d6:	10e080e7          	jalr	270(ra) # 5ae0 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9da:	862a                	mv	a2,a0
     9dc:	85d6                	mv	a1,s5
     9de:	00006517          	auipc	a0,0x6
     9e2:	96250513          	addi	a0,a0,-1694 # 6340 <malloc+0x42e>
     9e6:	00005097          	auipc	ra,0x5
     9ea:	474080e7          	jalr	1140(ra) # 5e5a <printf>
    exit(1);
     9ee:	4505                	li	a0,1
     9f0:	00005097          	auipc	ra,0x5
     9f4:	0f0080e7          	jalr	240(ra) # 5ae0 <exit>

00000000000009f8 <writetest>:
void writetest(char *s) {
     9f8:	7139                	addi	sp,sp,-64
     9fa:	fc06                	sd	ra,56(sp)
     9fc:	f822                	sd	s0,48(sp)
     9fe:	f426                	sd	s1,40(sp)
     a00:	f04a                	sd	s2,32(sp)
     a02:	ec4e                	sd	s3,24(sp)
     a04:	e852                	sd	s4,16(sp)
     a06:	e456                	sd	s5,8(sp)
     a08:	e05a                	sd	s6,0(sp)
     a0a:	0080                	addi	s0,sp,64
     a0c:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE | O_RDWR);
     a0e:	20200593          	li	a1,514
     a12:	00006517          	auipc	a0,0x6
     a16:	94e50513          	addi	a0,a0,-1714 # 6360 <malloc+0x44e>
     a1a:	00005097          	auipc	ra,0x5
     a1e:	106080e7          	jalr	262(ra) # 5b20 <open>
  if (fd < 0) {
     a22:	0a054d63          	bltz	a0,adc <writetest+0xe4>
     a26:	892a                	mv	s2,a0
     a28:	4481                	li	s1,0
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     a2a:	00006997          	auipc	s3,0x6
     a2e:	95e98993          	addi	s3,s3,-1698 # 6388 <malloc+0x476>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     a32:	00006a97          	auipc	s5,0x6
     a36:	98ea8a93          	addi	s5,s5,-1650 # 63c0 <malloc+0x4ae>
  for (i = 0; i < N; i++) {
     a3a:	06400a13          	li	s4,100
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     a3e:	4629                	li	a2,10
     a40:	85ce                	mv	a1,s3
     a42:	854a                	mv	a0,s2
     a44:	00005097          	auipc	ra,0x5
     a48:	0bc080e7          	jalr	188(ra) # 5b00 <write>
     a4c:	47a9                	li	a5,10
     a4e:	0af51563          	bne	a0,a5,af8 <writetest+0x100>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     a52:	4629                	li	a2,10
     a54:	85d6                	mv	a1,s5
     a56:	854a                	mv	a0,s2
     a58:	00005097          	auipc	ra,0x5
     a5c:	0a8080e7          	jalr	168(ra) # 5b00 <write>
     a60:	47a9                	li	a5,10
     a62:	0af51a63          	bne	a0,a5,b16 <writetest+0x11e>
  for (i = 0; i < N; i++) {
     a66:	2485                	addiw	s1,s1,1
     a68:	fd449be3          	bne	s1,s4,a3e <writetest+0x46>
  close(fd);
     a6c:	854a                	mv	a0,s2
     a6e:	00005097          	auipc	ra,0x5
     a72:	09a080e7          	jalr	154(ra) # 5b08 <close>
  fd = open("small", O_RDONLY);
     a76:	4581                	li	a1,0
     a78:	00006517          	auipc	a0,0x6
     a7c:	8e850513          	addi	a0,a0,-1816 # 6360 <malloc+0x44e>
     a80:	00005097          	auipc	ra,0x5
     a84:	0a0080e7          	jalr	160(ra) # 5b20 <open>
     a88:	84aa                	mv	s1,a0
  if (fd < 0) {
     a8a:	0a054563          	bltz	a0,b34 <writetest+0x13c>
  i = read(fd, buf, N * SZ * 2);
     a8e:	7d000613          	li	a2,2000
     a92:	0000c597          	auipc	a1,0xc
     a96:	1d658593          	addi	a1,a1,470 # cc68 <buf>
     a9a:	00005097          	auipc	ra,0x5
     a9e:	05e080e7          	jalr	94(ra) # 5af8 <read>
  if (i != N * SZ * 2) {
     aa2:	7d000793          	li	a5,2000
     aa6:	0af51563          	bne	a0,a5,b50 <writetest+0x158>
  close(fd);
     aaa:	8526                	mv	a0,s1
     aac:	00005097          	auipc	ra,0x5
     ab0:	05c080e7          	jalr	92(ra) # 5b08 <close>
  if (unlink("small") < 0) {
     ab4:	00006517          	auipc	a0,0x6
     ab8:	8ac50513          	addi	a0,a0,-1876 # 6360 <malloc+0x44e>
     abc:	00005097          	auipc	ra,0x5
     ac0:	074080e7          	jalr	116(ra) # 5b30 <unlink>
     ac4:	0a054463          	bltz	a0,b6c <writetest+0x174>
}
     ac8:	70e2                	ld	ra,56(sp)
     aca:	7442                	ld	s0,48(sp)
     acc:	74a2                	ld	s1,40(sp)
     ace:	7902                	ld	s2,32(sp)
     ad0:	69e2                	ld	s3,24(sp)
     ad2:	6a42                	ld	s4,16(sp)
     ad4:	6aa2                	ld	s5,8(sp)
     ad6:	6b02                	ld	s6,0(sp)
     ad8:	6121                	addi	sp,sp,64
     ada:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     adc:	85da                	mv	a1,s6
     ade:	00006517          	auipc	a0,0x6
     ae2:	88a50513          	addi	a0,a0,-1910 # 6368 <malloc+0x456>
     ae6:	00005097          	auipc	ra,0x5
     aea:	374080e7          	jalr	884(ra) # 5e5a <printf>
    exit(1);
     aee:	4505                	li	a0,1
     af0:	00005097          	auipc	ra,0x5
     af4:	ff0080e7          	jalr	-16(ra) # 5ae0 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     af8:	8626                	mv	a2,s1
     afa:	85da                	mv	a1,s6
     afc:	00006517          	auipc	a0,0x6
     b00:	89c50513          	addi	a0,a0,-1892 # 6398 <malloc+0x486>
     b04:	00005097          	auipc	ra,0x5
     b08:	356080e7          	jalr	854(ra) # 5e5a <printf>
      exit(1);
     b0c:	4505                	li	a0,1
     b0e:	00005097          	auipc	ra,0x5
     b12:	fd2080e7          	jalr	-46(ra) # 5ae0 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b16:	8626                	mv	a2,s1
     b18:	85da                	mv	a1,s6
     b1a:	00006517          	auipc	a0,0x6
     b1e:	8b650513          	addi	a0,a0,-1866 # 63d0 <malloc+0x4be>
     b22:	00005097          	auipc	ra,0x5
     b26:	338080e7          	jalr	824(ra) # 5e5a <printf>
      exit(1);
     b2a:	4505                	li	a0,1
     b2c:	00005097          	auipc	ra,0x5
     b30:	fb4080e7          	jalr	-76(ra) # 5ae0 <exit>
    printf("%s: error: open small failed!\n", s);
     b34:	85da                	mv	a1,s6
     b36:	00006517          	auipc	a0,0x6
     b3a:	8c250513          	addi	a0,a0,-1854 # 63f8 <malloc+0x4e6>
     b3e:	00005097          	auipc	ra,0x5
     b42:	31c080e7          	jalr	796(ra) # 5e5a <printf>
    exit(1);
     b46:	4505                	li	a0,1
     b48:	00005097          	auipc	ra,0x5
     b4c:	f98080e7          	jalr	-104(ra) # 5ae0 <exit>
    printf("%s: read failed\n", s);
     b50:	85da                	mv	a1,s6
     b52:	00006517          	auipc	a0,0x6
     b56:	8c650513          	addi	a0,a0,-1850 # 6418 <malloc+0x506>
     b5a:	00005097          	auipc	ra,0x5
     b5e:	300080e7          	jalr	768(ra) # 5e5a <printf>
    exit(1);
     b62:	4505                	li	a0,1
     b64:	00005097          	auipc	ra,0x5
     b68:	f7c080e7          	jalr	-132(ra) # 5ae0 <exit>
    printf("%s: unlink small failed\n", s);
     b6c:	85da                	mv	a1,s6
     b6e:	00006517          	auipc	a0,0x6
     b72:	8c250513          	addi	a0,a0,-1854 # 6430 <malloc+0x51e>
     b76:	00005097          	auipc	ra,0x5
     b7a:	2e4080e7          	jalr	740(ra) # 5e5a <printf>
    exit(1);
     b7e:	4505                	li	a0,1
     b80:	00005097          	auipc	ra,0x5
     b84:	f60080e7          	jalr	-160(ra) # 5ae0 <exit>

0000000000000b88 <writebig>:
void writebig(char *s) {
     b88:	7139                	addi	sp,sp,-64
     b8a:	fc06                	sd	ra,56(sp)
     b8c:	f822                	sd	s0,48(sp)
     b8e:	f426                	sd	s1,40(sp)
     b90:	f04a                	sd	s2,32(sp)
     b92:	ec4e                	sd	s3,24(sp)
     b94:	e852                	sd	s4,16(sp)
     b96:	e456                	sd	s5,8(sp)
     b98:	0080                	addi	s0,sp,64
     b9a:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE | O_RDWR);
     b9c:	20200593          	li	a1,514
     ba0:	00006517          	auipc	a0,0x6
     ba4:	8b050513          	addi	a0,a0,-1872 # 6450 <malloc+0x53e>
     ba8:	00005097          	auipc	ra,0x5
     bac:	f78080e7          	jalr	-136(ra) # 5b20 <open>
     bb0:	89aa                	mv	s3,a0
  for (i = 0; i < MAXFILE; i++) {
     bb2:	4481                	li	s1,0
    ((int *)buf)[0] = i;
     bb4:	0000c917          	auipc	s2,0xc
     bb8:	0b490913          	addi	s2,s2,180 # cc68 <buf>
  for (i = 0; i < MAXFILE; i++) {
     bbc:	10c00a13          	li	s4,268
  if (fd < 0) {
     bc0:	06054c63          	bltz	a0,c38 <writebig+0xb0>
    ((int *)buf)[0] = i;
     bc4:	00992023          	sw	s1,0(s2)
    if (write(fd, buf, BSIZE) != BSIZE) {
     bc8:	40000613          	li	a2,1024
     bcc:	85ca                	mv	a1,s2
     bce:	854e                	mv	a0,s3
     bd0:	00005097          	auipc	ra,0x5
     bd4:	f30080e7          	jalr	-208(ra) # 5b00 <write>
     bd8:	40000793          	li	a5,1024
     bdc:	06f51c63          	bne	a0,a5,c54 <writebig+0xcc>
  for (i = 0; i < MAXFILE; i++) {
     be0:	2485                	addiw	s1,s1,1
     be2:	ff4491e3          	bne	s1,s4,bc4 <writebig+0x3c>
  close(fd);
     be6:	854e                	mv	a0,s3
     be8:	00005097          	auipc	ra,0x5
     bec:	f20080e7          	jalr	-224(ra) # 5b08 <close>
  fd = open("big", O_RDONLY);
     bf0:	4581                	li	a1,0
     bf2:	00006517          	auipc	a0,0x6
     bf6:	85e50513          	addi	a0,a0,-1954 # 6450 <malloc+0x53e>
     bfa:	00005097          	auipc	ra,0x5
     bfe:	f26080e7          	jalr	-218(ra) # 5b20 <open>
     c02:	89aa                	mv	s3,a0
  n = 0;
     c04:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c06:	0000c917          	auipc	s2,0xc
     c0a:	06290913          	addi	s2,s2,98 # cc68 <buf>
  if (fd < 0) {
     c0e:	06054263          	bltz	a0,c72 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     c12:	40000613          	li	a2,1024
     c16:	85ca                	mv	a1,s2
     c18:	854e                	mv	a0,s3
     c1a:	00005097          	auipc	ra,0x5
     c1e:	ede080e7          	jalr	-290(ra) # 5af8 <read>
    if (i == 0) {
     c22:	c535                	beqz	a0,c8e <writebig+0x106>
    } else if (i != BSIZE) {
     c24:	40000793          	li	a5,1024
     c28:	0af51f63          	bne	a0,a5,ce6 <writebig+0x15e>
    if (((int *)buf)[0] != n) {
     c2c:	00092683          	lw	a3,0(s2)
     c30:	0c969a63          	bne	a3,s1,d04 <writebig+0x17c>
    n++;
     c34:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c36:	bff1                	j	c12 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     c38:	85d6                	mv	a1,s5
     c3a:	00006517          	auipc	a0,0x6
     c3e:	81e50513          	addi	a0,a0,-2018 # 6458 <malloc+0x546>
     c42:	00005097          	auipc	ra,0x5
     c46:	218080e7          	jalr	536(ra) # 5e5a <printf>
    exit(1);
     c4a:	4505                	li	a0,1
     c4c:	00005097          	auipc	ra,0x5
     c50:	e94080e7          	jalr	-364(ra) # 5ae0 <exit>
      printf("%s: error: write big file failed\n", s, i);
     c54:	8626                	mv	a2,s1
     c56:	85d6                	mv	a1,s5
     c58:	00006517          	auipc	a0,0x6
     c5c:	82050513          	addi	a0,a0,-2016 # 6478 <malloc+0x566>
     c60:	00005097          	auipc	ra,0x5
     c64:	1fa080e7          	jalr	506(ra) # 5e5a <printf>
      exit(1);
     c68:	4505                	li	a0,1
     c6a:	00005097          	auipc	ra,0x5
     c6e:	e76080e7          	jalr	-394(ra) # 5ae0 <exit>
    printf("%s: error: open big failed!\n", s);
     c72:	85d6                	mv	a1,s5
     c74:	00006517          	auipc	a0,0x6
     c78:	82c50513          	addi	a0,a0,-2004 # 64a0 <malloc+0x58e>
     c7c:	00005097          	auipc	ra,0x5
     c80:	1de080e7          	jalr	478(ra) # 5e5a <printf>
    exit(1);
     c84:	4505                	li	a0,1
     c86:	00005097          	auipc	ra,0x5
     c8a:	e5a080e7          	jalr	-422(ra) # 5ae0 <exit>
      if (n == MAXFILE - 1) {
     c8e:	10b00793          	li	a5,267
     c92:	02f48a63          	beq	s1,a5,cc6 <writebig+0x13e>
  close(fd);
     c96:	854e                	mv	a0,s3
     c98:	00005097          	auipc	ra,0x5
     c9c:	e70080e7          	jalr	-400(ra) # 5b08 <close>
  if (unlink("big") < 0) {
     ca0:	00005517          	auipc	a0,0x5
     ca4:	7b050513          	addi	a0,a0,1968 # 6450 <malloc+0x53e>
     ca8:	00005097          	auipc	ra,0x5
     cac:	e88080e7          	jalr	-376(ra) # 5b30 <unlink>
     cb0:	06054963          	bltz	a0,d22 <writebig+0x19a>
}
     cb4:	70e2                	ld	ra,56(sp)
     cb6:	7442                	ld	s0,48(sp)
     cb8:	74a2                	ld	s1,40(sp)
     cba:	7902                	ld	s2,32(sp)
     cbc:	69e2                	ld	s3,24(sp)
     cbe:	6a42                	ld	s4,16(sp)
     cc0:	6aa2                	ld	s5,8(sp)
     cc2:	6121                	addi	sp,sp,64
     cc4:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     cc6:	10b00613          	li	a2,267
     cca:	85d6                	mv	a1,s5
     ccc:	00005517          	auipc	a0,0x5
     cd0:	7f450513          	addi	a0,a0,2036 # 64c0 <malloc+0x5ae>
     cd4:	00005097          	auipc	ra,0x5
     cd8:	186080e7          	jalr	390(ra) # 5e5a <printf>
        exit(1);
     cdc:	4505                	li	a0,1
     cde:	00005097          	auipc	ra,0x5
     ce2:	e02080e7          	jalr	-510(ra) # 5ae0 <exit>
      printf("%s: read failed %d\n", s, i);
     ce6:	862a                	mv	a2,a0
     ce8:	85d6                	mv	a1,s5
     cea:	00005517          	auipc	a0,0x5
     cee:	7fe50513          	addi	a0,a0,2046 # 64e8 <malloc+0x5d6>
     cf2:	00005097          	auipc	ra,0x5
     cf6:	168080e7          	jalr	360(ra) # 5e5a <printf>
      exit(1);
     cfa:	4505                	li	a0,1
     cfc:	00005097          	auipc	ra,0x5
     d00:	de4080e7          	jalr	-540(ra) # 5ae0 <exit>
      printf("%s: read content of block %d is %d\n", s, n, ((int *)buf)[0]);
     d04:	8626                	mv	a2,s1
     d06:	85d6                	mv	a1,s5
     d08:	00005517          	auipc	a0,0x5
     d0c:	7f850513          	addi	a0,a0,2040 # 6500 <malloc+0x5ee>
     d10:	00005097          	auipc	ra,0x5
     d14:	14a080e7          	jalr	330(ra) # 5e5a <printf>
      exit(1);
     d18:	4505                	li	a0,1
     d1a:	00005097          	auipc	ra,0x5
     d1e:	dc6080e7          	jalr	-570(ra) # 5ae0 <exit>
    printf("%s: unlink big failed\n", s);
     d22:	85d6                	mv	a1,s5
     d24:	00006517          	auipc	a0,0x6
     d28:	80450513          	addi	a0,a0,-2044 # 6528 <malloc+0x616>
     d2c:	00005097          	auipc	ra,0x5
     d30:	12e080e7          	jalr	302(ra) # 5e5a <printf>
    exit(1);
     d34:	4505                	li	a0,1
     d36:	00005097          	auipc	ra,0x5
     d3a:	daa080e7          	jalr	-598(ra) # 5ae0 <exit>

0000000000000d3e <unlinkread>:
void unlinkread(char *s) {
     d3e:	7179                	addi	sp,sp,-48
     d40:	f406                	sd	ra,40(sp)
     d42:	f022                	sd	s0,32(sp)
     d44:	ec26                	sd	s1,24(sp)
     d46:	e84a                	sd	s2,16(sp)
     d48:	e44e                	sd	s3,8(sp)
     d4a:	1800                	addi	s0,sp,48
     d4c:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d4e:	20200593          	li	a1,514
     d52:	00005517          	auipc	a0,0x5
     d56:	7ee50513          	addi	a0,a0,2030 # 6540 <malloc+0x62e>
     d5a:	00005097          	auipc	ra,0x5
     d5e:	dc6080e7          	jalr	-570(ra) # 5b20 <open>
  if (fd < 0) {
     d62:	0e054563          	bltz	a0,e4c <unlinkread+0x10e>
     d66:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d68:	4615                	li	a2,5
     d6a:	00006597          	auipc	a1,0x6
     d6e:	80658593          	addi	a1,a1,-2042 # 6570 <malloc+0x65e>
     d72:	00005097          	auipc	ra,0x5
     d76:	d8e080e7          	jalr	-626(ra) # 5b00 <write>
  close(fd);
     d7a:	8526                	mv	a0,s1
     d7c:	00005097          	auipc	ra,0x5
     d80:	d8c080e7          	jalr	-628(ra) # 5b08 <close>
  fd = open("unlinkread", O_RDWR);
     d84:	4589                	li	a1,2
     d86:	00005517          	auipc	a0,0x5
     d8a:	7ba50513          	addi	a0,a0,1978 # 6540 <malloc+0x62e>
     d8e:	00005097          	auipc	ra,0x5
     d92:	d92080e7          	jalr	-622(ra) # 5b20 <open>
     d96:	84aa                	mv	s1,a0
  if (fd < 0) {
     d98:	0c054863          	bltz	a0,e68 <unlinkread+0x12a>
  if (unlink("unlinkread") != 0) {
     d9c:	00005517          	auipc	a0,0x5
     da0:	7a450513          	addi	a0,a0,1956 # 6540 <malloc+0x62e>
     da4:	00005097          	auipc	ra,0x5
     da8:	d8c080e7          	jalr	-628(ra) # 5b30 <unlink>
     dac:	ed61                	bnez	a0,e84 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     dae:	20200593          	li	a1,514
     db2:	00005517          	auipc	a0,0x5
     db6:	78e50513          	addi	a0,a0,1934 # 6540 <malloc+0x62e>
     dba:	00005097          	auipc	ra,0x5
     dbe:	d66080e7          	jalr	-666(ra) # 5b20 <open>
     dc2:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     dc4:	460d                	li	a2,3
     dc6:	00005597          	auipc	a1,0x5
     dca:	7f258593          	addi	a1,a1,2034 # 65b8 <malloc+0x6a6>
     dce:	00005097          	auipc	ra,0x5
     dd2:	d32080e7          	jalr	-718(ra) # 5b00 <write>
  close(fd1);
     dd6:	854a                	mv	a0,s2
     dd8:	00005097          	auipc	ra,0x5
     ddc:	d30080e7          	jalr	-720(ra) # 5b08 <close>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     de0:	660d                	lui	a2,0x3
     de2:	0000c597          	auipc	a1,0xc
     de6:	e8658593          	addi	a1,a1,-378 # cc68 <buf>
     dea:	8526                	mv	a0,s1
     dec:	00005097          	auipc	ra,0x5
     df0:	d0c080e7          	jalr	-756(ra) # 5af8 <read>
     df4:	4795                	li	a5,5
     df6:	0af51563          	bne	a0,a5,ea0 <unlinkread+0x162>
  if (buf[0] != 'h') {
     dfa:	0000c717          	auipc	a4,0xc
     dfe:	e6e74703          	lbu	a4,-402(a4) # cc68 <buf>
     e02:	06800793          	li	a5,104
     e06:	0af71b63          	bne	a4,a5,ebc <unlinkread+0x17e>
  if (write(fd, buf, 10) != 10) {
     e0a:	4629                	li	a2,10
     e0c:	0000c597          	auipc	a1,0xc
     e10:	e5c58593          	addi	a1,a1,-420 # cc68 <buf>
     e14:	8526                	mv	a0,s1
     e16:	00005097          	auipc	ra,0x5
     e1a:	cea080e7          	jalr	-790(ra) # 5b00 <write>
     e1e:	47a9                	li	a5,10
     e20:	0af51c63          	bne	a0,a5,ed8 <unlinkread+0x19a>
  close(fd);
     e24:	8526                	mv	a0,s1
     e26:	00005097          	auipc	ra,0x5
     e2a:	ce2080e7          	jalr	-798(ra) # 5b08 <close>
  unlink("unlinkread");
     e2e:	00005517          	auipc	a0,0x5
     e32:	71250513          	addi	a0,a0,1810 # 6540 <malloc+0x62e>
     e36:	00005097          	auipc	ra,0x5
     e3a:	cfa080e7          	jalr	-774(ra) # 5b30 <unlink>
}
     e3e:	70a2                	ld	ra,40(sp)
     e40:	7402                	ld	s0,32(sp)
     e42:	64e2                	ld	s1,24(sp)
     e44:	6942                	ld	s2,16(sp)
     e46:	69a2                	ld	s3,8(sp)
     e48:	6145                	addi	sp,sp,48
     e4a:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e4c:	85ce                	mv	a1,s3
     e4e:	00005517          	auipc	a0,0x5
     e52:	70250513          	addi	a0,a0,1794 # 6550 <malloc+0x63e>
     e56:	00005097          	auipc	ra,0x5
     e5a:	004080e7          	jalr	4(ra) # 5e5a <printf>
    exit(1);
     e5e:	4505                	li	a0,1
     e60:	00005097          	auipc	ra,0x5
     e64:	c80080e7          	jalr	-896(ra) # 5ae0 <exit>
    printf("%s: open unlinkread failed\n", s);
     e68:	85ce                	mv	a1,s3
     e6a:	00005517          	auipc	a0,0x5
     e6e:	70e50513          	addi	a0,a0,1806 # 6578 <malloc+0x666>
     e72:	00005097          	auipc	ra,0x5
     e76:	fe8080e7          	jalr	-24(ra) # 5e5a <printf>
    exit(1);
     e7a:	4505                	li	a0,1
     e7c:	00005097          	auipc	ra,0x5
     e80:	c64080e7          	jalr	-924(ra) # 5ae0 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e84:	85ce                	mv	a1,s3
     e86:	00005517          	auipc	a0,0x5
     e8a:	71250513          	addi	a0,a0,1810 # 6598 <malloc+0x686>
     e8e:	00005097          	auipc	ra,0x5
     e92:	fcc080e7          	jalr	-52(ra) # 5e5a <printf>
    exit(1);
     e96:	4505                	li	a0,1
     e98:	00005097          	auipc	ra,0x5
     e9c:	c48080e7          	jalr	-952(ra) # 5ae0 <exit>
    printf("%s: unlinkread read failed", s);
     ea0:	85ce                	mv	a1,s3
     ea2:	00005517          	auipc	a0,0x5
     ea6:	71e50513          	addi	a0,a0,1822 # 65c0 <malloc+0x6ae>
     eaa:	00005097          	auipc	ra,0x5
     eae:	fb0080e7          	jalr	-80(ra) # 5e5a <printf>
    exit(1);
     eb2:	4505                	li	a0,1
     eb4:	00005097          	auipc	ra,0x5
     eb8:	c2c080e7          	jalr	-980(ra) # 5ae0 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ebc:	85ce                	mv	a1,s3
     ebe:	00005517          	auipc	a0,0x5
     ec2:	72250513          	addi	a0,a0,1826 # 65e0 <malloc+0x6ce>
     ec6:	00005097          	auipc	ra,0x5
     eca:	f94080e7          	jalr	-108(ra) # 5e5a <printf>
    exit(1);
     ece:	4505                	li	a0,1
     ed0:	00005097          	auipc	ra,0x5
     ed4:	c10080e7          	jalr	-1008(ra) # 5ae0 <exit>
    printf("%s: unlinkread write failed\n", s);
     ed8:	85ce                	mv	a1,s3
     eda:	00005517          	auipc	a0,0x5
     ede:	72650513          	addi	a0,a0,1830 # 6600 <malloc+0x6ee>
     ee2:	00005097          	auipc	ra,0x5
     ee6:	f78080e7          	jalr	-136(ra) # 5e5a <printf>
    exit(1);
     eea:	4505                	li	a0,1
     eec:	00005097          	auipc	ra,0x5
     ef0:	bf4080e7          	jalr	-1036(ra) # 5ae0 <exit>

0000000000000ef4 <linktest>:
void linktest(char *s) {
     ef4:	1101                	addi	sp,sp,-32
     ef6:	ec06                	sd	ra,24(sp)
     ef8:	e822                	sd	s0,16(sp)
     efa:	e426                	sd	s1,8(sp)
     efc:	e04a                	sd	s2,0(sp)
     efe:	1000                	addi	s0,sp,32
     f00:	892a                	mv	s2,a0
  unlink("lf1");
     f02:	00005517          	auipc	a0,0x5
     f06:	71e50513          	addi	a0,a0,1822 # 6620 <malloc+0x70e>
     f0a:	00005097          	auipc	ra,0x5
     f0e:	c26080e7          	jalr	-986(ra) # 5b30 <unlink>
  unlink("lf2");
     f12:	00005517          	auipc	a0,0x5
     f16:	71650513          	addi	a0,a0,1814 # 6628 <malloc+0x716>
     f1a:	00005097          	auipc	ra,0x5
     f1e:	c16080e7          	jalr	-1002(ra) # 5b30 <unlink>
  fd = open("lf1", O_CREATE | O_RDWR);
     f22:	20200593          	li	a1,514
     f26:	00005517          	auipc	a0,0x5
     f2a:	6fa50513          	addi	a0,a0,1786 # 6620 <malloc+0x70e>
     f2e:	00005097          	auipc	ra,0x5
     f32:	bf2080e7          	jalr	-1038(ra) # 5b20 <open>
  if (fd < 0) {
     f36:	10054763          	bltz	a0,1044 <linktest+0x150>
     f3a:	84aa                	mv	s1,a0
  if (write(fd, "hello", SZ) != SZ) {
     f3c:	4615                	li	a2,5
     f3e:	00005597          	auipc	a1,0x5
     f42:	63258593          	addi	a1,a1,1586 # 6570 <malloc+0x65e>
     f46:	00005097          	auipc	ra,0x5
     f4a:	bba080e7          	jalr	-1094(ra) # 5b00 <write>
     f4e:	4795                	li	a5,5
     f50:	10f51863          	bne	a0,a5,1060 <linktest+0x16c>
  close(fd);
     f54:	8526                	mv	a0,s1
     f56:	00005097          	auipc	ra,0x5
     f5a:	bb2080e7          	jalr	-1102(ra) # 5b08 <close>
  if (link("lf1", "lf2") < 0) {
     f5e:	00005597          	auipc	a1,0x5
     f62:	6ca58593          	addi	a1,a1,1738 # 6628 <malloc+0x716>
     f66:	00005517          	auipc	a0,0x5
     f6a:	6ba50513          	addi	a0,a0,1722 # 6620 <malloc+0x70e>
     f6e:	00005097          	auipc	ra,0x5
     f72:	bd2080e7          	jalr	-1070(ra) # 5b40 <link>
     f76:	10054363          	bltz	a0,107c <linktest+0x188>
  unlink("lf1");
     f7a:	00005517          	auipc	a0,0x5
     f7e:	6a650513          	addi	a0,a0,1702 # 6620 <malloc+0x70e>
     f82:	00005097          	auipc	ra,0x5
     f86:	bae080e7          	jalr	-1106(ra) # 5b30 <unlink>
  if (open("lf1", 0) >= 0) {
     f8a:	4581                	li	a1,0
     f8c:	00005517          	auipc	a0,0x5
     f90:	69450513          	addi	a0,a0,1684 # 6620 <malloc+0x70e>
     f94:	00005097          	auipc	ra,0x5
     f98:	b8c080e7          	jalr	-1140(ra) # 5b20 <open>
     f9c:	0e055e63          	bgez	a0,1098 <linktest+0x1a4>
  fd = open("lf2", 0);
     fa0:	4581                	li	a1,0
     fa2:	00005517          	auipc	a0,0x5
     fa6:	68650513          	addi	a0,a0,1670 # 6628 <malloc+0x716>
     faa:	00005097          	auipc	ra,0x5
     fae:	b76080e7          	jalr	-1162(ra) # 5b20 <open>
     fb2:	84aa                	mv	s1,a0
  if (fd < 0) {
     fb4:	10054063          	bltz	a0,10b4 <linktest+0x1c0>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     fb8:	660d                	lui	a2,0x3
     fba:	0000c597          	auipc	a1,0xc
     fbe:	cae58593          	addi	a1,a1,-850 # cc68 <buf>
     fc2:	00005097          	auipc	ra,0x5
     fc6:	b36080e7          	jalr	-1226(ra) # 5af8 <read>
     fca:	4795                	li	a5,5
     fcc:	10f51263          	bne	a0,a5,10d0 <linktest+0x1dc>
  close(fd);
     fd0:	8526                	mv	a0,s1
     fd2:	00005097          	auipc	ra,0x5
     fd6:	b36080e7          	jalr	-1226(ra) # 5b08 <close>
  if (link("lf2", "lf2") >= 0) {
     fda:	00005597          	auipc	a1,0x5
     fde:	64e58593          	addi	a1,a1,1614 # 6628 <malloc+0x716>
     fe2:	852e                	mv	a0,a1
     fe4:	00005097          	auipc	ra,0x5
     fe8:	b5c080e7          	jalr	-1188(ra) # 5b40 <link>
     fec:	10055063          	bgez	a0,10ec <linktest+0x1f8>
  unlink("lf2");
     ff0:	00005517          	auipc	a0,0x5
     ff4:	63850513          	addi	a0,a0,1592 # 6628 <malloc+0x716>
     ff8:	00005097          	auipc	ra,0x5
     ffc:	b38080e7          	jalr	-1224(ra) # 5b30 <unlink>
  if (link("lf2", "lf1") >= 0) {
    1000:	00005597          	auipc	a1,0x5
    1004:	62058593          	addi	a1,a1,1568 # 6620 <malloc+0x70e>
    1008:	00005517          	auipc	a0,0x5
    100c:	62050513          	addi	a0,a0,1568 # 6628 <malloc+0x716>
    1010:	00005097          	auipc	ra,0x5
    1014:	b30080e7          	jalr	-1232(ra) # 5b40 <link>
    1018:	0e055863          	bgez	a0,1108 <linktest+0x214>
  if (link(".", "lf1") >= 0) {
    101c:	00005597          	auipc	a1,0x5
    1020:	60458593          	addi	a1,a1,1540 # 6620 <malloc+0x70e>
    1024:	00005517          	auipc	a0,0x5
    1028:	70c50513          	addi	a0,a0,1804 # 6730 <malloc+0x81e>
    102c:	00005097          	auipc	ra,0x5
    1030:	b14080e7          	jalr	-1260(ra) # 5b40 <link>
    1034:	0e055863          	bgez	a0,1124 <linktest+0x230>
}
    1038:	60e2                	ld	ra,24(sp)
    103a:	6442                	ld	s0,16(sp)
    103c:	64a2                	ld	s1,8(sp)
    103e:	6902                	ld	s2,0(sp)
    1040:	6105                	addi	sp,sp,32
    1042:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    1044:	85ca                	mv	a1,s2
    1046:	00005517          	auipc	a0,0x5
    104a:	5ea50513          	addi	a0,a0,1514 # 6630 <malloc+0x71e>
    104e:	00005097          	auipc	ra,0x5
    1052:	e0c080e7          	jalr	-500(ra) # 5e5a <printf>
    exit(1);
    1056:	4505                	li	a0,1
    1058:	00005097          	auipc	ra,0x5
    105c:	a88080e7          	jalr	-1400(ra) # 5ae0 <exit>
    printf("%s: write lf1 failed\n", s);
    1060:	85ca                	mv	a1,s2
    1062:	00005517          	auipc	a0,0x5
    1066:	5e650513          	addi	a0,a0,1510 # 6648 <malloc+0x736>
    106a:	00005097          	auipc	ra,0x5
    106e:	df0080e7          	jalr	-528(ra) # 5e5a <printf>
    exit(1);
    1072:	4505                	li	a0,1
    1074:	00005097          	auipc	ra,0x5
    1078:	a6c080e7          	jalr	-1428(ra) # 5ae0 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    107c:	85ca                	mv	a1,s2
    107e:	00005517          	auipc	a0,0x5
    1082:	5e250513          	addi	a0,a0,1506 # 6660 <malloc+0x74e>
    1086:	00005097          	auipc	ra,0x5
    108a:	dd4080e7          	jalr	-556(ra) # 5e5a <printf>
    exit(1);
    108e:	4505                	li	a0,1
    1090:	00005097          	auipc	ra,0x5
    1094:	a50080e7          	jalr	-1456(ra) # 5ae0 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    1098:	85ca                	mv	a1,s2
    109a:	00005517          	auipc	a0,0x5
    109e:	5e650513          	addi	a0,a0,1510 # 6680 <malloc+0x76e>
    10a2:	00005097          	auipc	ra,0x5
    10a6:	db8080e7          	jalr	-584(ra) # 5e5a <printf>
    exit(1);
    10aa:	4505                	li	a0,1
    10ac:	00005097          	auipc	ra,0x5
    10b0:	a34080e7          	jalr	-1484(ra) # 5ae0 <exit>
    printf("%s: open lf2 failed\n", s);
    10b4:	85ca                	mv	a1,s2
    10b6:	00005517          	auipc	a0,0x5
    10ba:	5fa50513          	addi	a0,a0,1530 # 66b0 <malloc+0x79e>
    10be:	00005097          	auipc	ra,0x5
    10c2:	d9c080e7          	jalr	-612(ra) # 5e5a <printf>
    exit(1);
    10c6:	4505                	li	a0,1
    10c8:	00005097          	auipc	ra,0x5
    10cc:	a18080e7          	jalr	-1512(ra) # 5ae0 <exit>
    printf("%s: read lf2 failed\n", s);
    10d0:	85ca                	mv	a1,s2
    10d2:	00005517          	auipc	a0,0x5
    10d6:	5f650513          	addi	a0,a0,1526 # 66c8 <malloc+0x7b6>
    10da:	00005097          	auipc	ra,0x5
    10de:	d80080e7          	jalr	-640(ra) # 5e5a <printf>
    exit(1);
    10e2:	4505                	li	a0,1
    10e4:	00005097          	auipc	ra,0x5
    10e8:	9fc080e7          	jalr	-1540(ra) # 5ae0 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    10ec:	85ca                	mv	a1,s2
    10ee:	00005517          	auipc	a0,0x5
    10f2:	5f250513          	addi	a0,a0,1522 # 66e0 <malloc+0x7ce>
    10f6:	00005097          	auipc	ra,0x5
    10fa:	d64080e7          	jalr	-668(ra) # 5e5a <printf>
    exit(1);
    10fe:	4505                	li	a0,1
    1100:	00005097          	auipc	ra,0x5
    1104:	9e0080e7          	jalr	-1568(ra) # 5ae0 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    1108:	85ca                	mv	a1,s2
    110a:	00005517          	auipc	a0,0x5
    110e:	5fe50513          	addi	a0,a0,1534 # 6708 <malloc+0x7f6>
    1112:	00005097          	auipc	ra,0x5
    1116:	d48080e7          	jalr	-696(ra) # 5e5a <printf>
    exit(1);
    111a:	4505                	li	a0,1
    111c:	00005097          	auipc	ra,0x5
    1120:	9c4080e7          	jalr	-1596(ra) # 5ae0 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1124:	85ca                	mv	a1,s2
    1126:	00005517          	auipc	a0,0x5
    112a:	61250513          	addi	a0,a0,1554 # 6738 <malloc+0x826>
    112e:	00005097          	auipc	ra,0x5
    1132:	d2c080e7          	jalr	-724(ra) # 5e5a <printf>
    exit(1);
    1136:	4505                	li	a0,1
    1138:	00005097          	auipc	ra,0x5
    113c:	9a8080e7          	jalr	-1624(ra) # 5ae0 <exit>

0000000000001140 <validatetest>:
void validatetest(char *s) {
    1140:	7139                	addi	sp,sp,-64
    1142:	fc06                	sd	ra,56(sp)
    1144:	f822                	sd	s0,48(sp)
    1146:	f426                	sd	s1,40(sp)
    1148:	f04a                	sd	s2,32(sp)
    114a:	ec4e                	sd	s3,24(sp)
    114c:	e852                	sd	s4,16(sp)
    114e:	e456                	sd	s5,8(sp)
    1150:	e05a                	sd	s6,0(sp)
    1152:	0080                	addi	s0,sp,64
    1154:	8b2a                	mv	s6,a0
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
    1156:	4481                	li	s1,0
    if (link("nosuchfile", (char *)p) != -1) {
    1158:	00005997          	auipc	s3,0x5
    115c:	60098993          	addi	s3,s3,1536 # 6758 <malloc+0x846>
    1160:	597d                	li	s2,-1
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
    1162:	6a85                	lui	s5,0x1
    1164:	00114a37          	lui	s4,0x114
    if (link("nosuchfile", (char *)p) != -1) {
    1168:	85a6                	mv	a1,s1
    116a:	854e                	mv	a0,s3
    116c:	00005097          	auipc	ra,0x5
    1170:	9d4080e7          	jalr	-1580(ra) # 5b40 <link>
    1174:	01251f63          	bne	a0,s2,1192 <validatetest+0x52>
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
    1178:	94d6                	add	s1,s1,s5
    117a:	ff4497e3          	bne	s1,s4,1168 <validatetest+0x28>
}
    117e:	70e2                	ld	ra,56(sp)
    1180:	7442                	ld	s0,48(sp)
    1182:	74a2                	ld	s1,40(sp)
    1184:	7902                	ld	s2,32(sp)
    1186:	69e2                	ld	s3,24(sp)
    1188:	6a42                	ld	s4,16(sp)
    118a:	6aa2                	ld	s5,8(sp)
    118c:	6b02                	ld	s6,0(sp)
    118e:	6121                	addi	sp,sp,64
    1190:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1192:	85da                	mv	a1,s6
    1194:	00005517          	auipc	a0,0x5
    1198:	5d450513          	addi	a0,a0,1492 # 6768 <malloc+0x856>
    119c:	00005097          	auipc	ra,0x5
    11a0:	cbe080e7          	jalr	-834(ra) # 5e5a <printf>
      exit(1);
    11a4:	4505                	li	a0,1
    11a6:	00005097          	auipc	ra,0x5
    11aa:	93a080e7          	jalr	-1734(ra) # 5ae0 <exit>

00000000000011ae <bigdir>:
void bigdir(char *s) {
    11ae:	715d                	addi	sp,sp,-80
    11b0:	e486                	sd	ra,72(sp)
    11b2:	e0a2                	sd	s0,64(sp)
    11b4:	fc26                	sd	s1,56(sp)
    11b6:	f84a                	sd	s2,48(sp)
    11b8:	f44e                	sd	s3,40(sp)
    11ba:	f052                	sd	s4,32(sp)
    11bc:	ec56                	sd	s5,24(sp)
    11be:	e85a                	sd	s6,16(sp)
    11c0:	0880                	addi	s0,sp,80
    11c2:	89aa                	mv	s3,a0
  unlink("bd");
    11c4:	00005517          	auipc	a0,0x5
    11c8:	5c450513          	addi	a0,a0,1476 # 6788 <malloc+0x876>
    11cc:	00005097          	auipc	ra,0x5
    11d0:	964080e7          	jalr	-1692(ra) # 5b30 <unlink>
  fd = open("bd", O_CREATE);
    11d4:	20000593          	li	a1,512
    11d8:	00005517          	auipc	a0,0x5
    11dc:	5b050513          	addi	a0,a0,1456 # 6788 <malloc+0x876>
    11e0:	00005097          	auipc	ra,0x5
    11e4:	940080e7          	jalr	-1728(ra) # 5b20 <open>
  if (fd < 0) {
    11e8:	0c054963          	bltz	a0,12ba <bigdir+0x10c>
  close(fd);
    11ec:	00005097          	auipc	ra,0x5
    11f0:	91c080e7          	jalr	-1764(ra) # 5b08 <close>
  for (i = 0; i < N; i++) {
    11f4:	4901                	li	s2,0
    name[0] = 'x';
    11f6:	07800a93          	li	s5,120
    if (link("bd", name) != 0) {
    11fa:	00005a17          	auipc	s4,0x5
    11fe:	58ea0a13          	addi	s4,s4,1422 # 6788 <malloc+0x876>
  for (i = 0; i < N; i++) {
    1202:	1f400b13          	li	s6,500
    name[0] = 'x';
    1206:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    120a:	41f9571b          	sraiw	a4,s2,0x1f
    120e:	01a7571b          	srliw	a4,a4,0x1a
    1212:	012707bb          	addw	a5,a4,s2
    1216:	4067d69b          	sraiw	a3,a5,0x6
    121a:	0306869b          	addiw	a3,a3,48
    121e:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1222:	03f7f793          	andi	a5,a5,63
    1226:	9f99                	subw	a5,a5,a4
    1228:	0307879b          	addiw	a5,a5,48
    122c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1230:	fa0409a3          	sb	zero,-77(s0)
    if (link("bd", name) != 0) {
    1234:	fb040593          	addi	a1,s0,-80
    1238:	8552                	mv	a0,s4
    123a:	00005097          	auipc	ra,0x5
    123e:	906080e7          	jalr	-1786(ra) # 5b40 <link>
    1242:	84aa                	mv	s1,a0
    1244:	e949                	bnez	a0,12d6 <bigdir+0x128>
  for (i = 0; i < N; i++) {
    1246:	2905                	addiw	s2,s2,1
    1248:	fb691fe3          	bne	s2,s6,1206 <bigdir+0x58>
  unlink("bd");
    124c:	00005517          	auipc	a0,0x5
    1250:	53c50513          	addi	a0,a0,1340 # 6788 <malloc+0x876>
    1254:	00005097          	auipc	ra,0x5
    1258:	8dc080e7          	jalr	-1828(ra) # 5b30 <unlink>
    name[0] = 'x';
    125c:	07800913          	li	s2,120
  for (i = 0; i < N; i++) {
    1260:	1f400a13          	li	s4,500
    name[0] = 'x';
    1264:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1268:	41f4d71b          	sraiw	a4,s1,0x1f
    126c:	01a7571b          	srliw	a4,a4,0x1a
    1270:	009707bb          	addw	a5,a4,s1
    1274:	4067d69b          	sraiw	a3,a5,0x6
    1278:	0306869b          	addiw	a3,a3,48
    127c:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1280:	03f7f793          	andi	a5,a5,63
    1284:	9f99                	subw	a5,a5,a4
    1286:	0307879b          	addiw	a5,a5,48
    128a:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    128e:	fa0409a3          	sb	zero,-77(s0)
    if (unlink(name) != 0) {
    1292:	fb040513          	addi	a0,s0,-80
    1296:	00005097          	auipc	ra,0x5
    129a:	89a080e7          	jalr	-1894(ra) # 5b30 <unlink>
    129e:	ed21                	bnez	a0,12f6 <bigdir+0x148>
  for (i = 0; i < N; i++) {
    12a0:	2485                	addiw	s1,s1,1
    12a2:	fd4491e3          	bne	s1,s4,1264 <bigdir+0xb6>
}
    12a6:	60a6                	ld	ra,72(sp)
    12a8:	6406                	ld	s0,64(sp)
    12aa:	74e2                	ld	s1,56(sp)
    12ac:	7942                	ld	s2,48(sp)
    12ae:	79a2                	ld	s3,40(sp)
    12b0:	7a02                	ld	s4,32(sp)
    12b2:	6ae2                	ld	s5,24(sp)
    12b4:	6b42                	ld	s6,16(sp)
    12b6:	6161                	addi	sp,sp,80
    12b8:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12ba:	85ce                	mv	a1,s3
    12bc:	00005517          	auipc	a0,0x5
    12c0:	4d450513          	addi	a0,a0,1236 # 6790 <malloc+0x87e>
    12c4:	00005097          	auipc	ra,0x5
    12c8:	b96080e7          	jalr	-1130(ra) # 5e5a <printf>
    exit(1);
    12cc:	4505                	li	a0,1
    12ce:	00005097          	auipc	ra,0x5
    12d2:	812080e7          	jalr	-2030(ra) # 5ae0 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12d6:	fb040613          	addi	a2,s0,-80
    12da:	85ce                	mv	a1,s3
    12dc:	00005517          	auipc	a0,0x5
    12e0:	4d450513          	addi	a0,a0,1236 # 67b0 <malloc+0x89e>
    12e4:	00005097          	auipc	ra,0x5
    12e8:	b76080e7          	jalr	-1162(ra) # 5e5a <printf>
      exit(1);
    12ec:	4505                	li	a0,1
    12ee:	00004097          	auipc	ra,0x4
    12f2:	7f2080e7          	jalr	2034(ra) # 5ae0 <exit>
      printf("%s: bigdir unlink failed", s);
    12f6:	85ce                	mv	a1,s3
    12f8:	00005517          	auipc	a0,0x5
    12fc:	4d850513          	addi	a0,a0,1240 # 67d0 <malloc+0x8be>
    1300:	00005097          	auipc	ra,0x5
    1304:	b5a080e7          	jalr	-1190(ra) # 5e5a <printf>
      exit(1);
    1308:	4505                	li	a0,1
    130a:	00004097          	auipc	ra,0x4
    130e:	7d6080e7          	jalr	2006(ra) # 5ae0 <exit>

0000000000001312 <pgbug>:
void pgbug(char *s) {
    1312:	7179                	addi	sp,sp,-48
    1314:	f406                	sd	ra,40(sp)
    1316:	f022                	sd	s0,32(sp)
    1318:	ec26                	sd	s1,24(sp)
    131a:	1800                	addi	s0,sp,48
  argv[0] = 0;
    131c:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1320:	00008497          	auipc	s1,0x8
    1324:	ce048493          	addi	s1,s1,-800 # 9000 <big>
    1328:	fd840593          	addi	a1,s0,-40
    132c:	6088                	ld	a0,0(s1)
    132e:	00004097          	auipc	ra,0x4
    1332:	7ea080e7          	jalr	2026(ra) # 5b18 <exec>
  pipe(big);
    1336:	6088                	ld	a0,0(s1)
    1338:	00004097          	auipc	ra,0x4
    133c:	7b8080e7          	jalr	1976(ra) # 5af0 <pipe>
  exit(0);
    1340:	4501                	li	a0,0
    1342:	00004097          	auipc	ra,0x4
    1346:	79e080e7          	jalr	1950(ra) # 5ae0 <exit>

000000000000134a <badarg>:
void badarg(char *s) {
    134a:	7139                	addi	sp,sp,-64
    134c:	fc06                	sd	ra,56(sp)
    134e:	f822                	sd	s0,48(sp)
    1350:	f426                	sd	s1,40(sp)
    1352:	f04a                	sd	s2,32(sp)
    1354:	ec4e                	sd	s3,24(sp)
    1356:	0080                	addi	s0,sp,64
    1358:	64b1                	lui	s1,0xc
    135a:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1df8>
    argv[0] = (char *)0xffffffff;
    135e:	597d                	li	s2,-1
    1360:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    1364:	00005997          	auipc	s3,0x5
    1368:	cd498993          	addi	s3,s3,-812 # 6038 <malloc+0x126>
    argv[0] = (char *)0xffffffff;
    136c:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1370:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1374:	fc040593          	addi	a1,s0,-64
    1378:	854e                	mv	a0,s3
    137a:	00004097          	auipc	ra,0x4
    137e:	79e080e7          	jalr	1950(ra) # 5b18 <exec>
  for (int i = 0; i < 50000; i++) {
    1382:	34fd                	addiw	s1,s1,-1
    1384:	f4e5                	bnez	s1,136c <badarg+0x22>
  exit(0);
    1386:	4501                	li	a0,0
    1388:	00004097          	auipc	ra,0x4
    138c:	758080e7          	jalr	1880(ra) # 5ae0 <exit>

0000000000001390 <copyinstr2>:
void copyinstr2(char *s) {
    1390:	7155                	addi	sp,sp,-208
    1392:	e586                	sd	ra,200(sp)
    1394:	e1a2                	sd	s0,192(sp)
    1396:	0980                	addi	s0,sp,208
  for (int i = 0; i < MAXPATH; i++) b[i] = 'x';
    1398:	f6840793          	addi	a5,s0,-152
    139c:	fe840693          	addi	a3,s0,-24
    13a0:	07800713          	li	a4,120
    13a4:	00e78023          	sb	a4,0(a5)
    13a8:	0785                	addi	a5,a5,1
    13aa:	fed79de3          	bne	a5,a3,13a4 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13ae:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13b2:	f6840513          	addi	a0,s0,-152
    13b6:	00004097          	auipc	ra,0x4
    13ba:	77a080e7          	jalr	1914(ra) # 5b30 <unlink>
  if (ret != -1) {
    13be:	57fd                	li	a5,-1
    13c0:	0ef51063          	bne	a0,a5,14a0 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13c4:	20100593          	li	a1,513
    13c8:	f6840513          	addi	a0,s0,-152
    13cc:	00004097          	auipc	ra,0x4
    13d0:	754080e7          	jalr	1876(ra) # 5b20 <open>
  if (fd != -1) {
    13d4:	57fd                	li	a5,-1
    13d6:	0ef51563          	bne	a0,a5,14c0 <copyinstr2+0x130>
  ret = link(b, b);
    13da:	f6840593          	addi	a1,s0,-152
    13de:	852e                	mv	a0,a1
    13e0:	00004097          	auipc	ra,0x4
    13e4:	760080e7          	jalr	1888(ra) # 5b40 <link>
  if (ret != -1) {
    13e8:	57fd                	li	a5,-1
    13ea:	0ef51b63          	bne	a0,a5,14e0 <copyinstr2+0x150>
  char *args[] = {"xx", 0};
    13ee:	00006797          	auipc	a5,0x6
    13f2:	5ca78793          	addi	a5,a5,1482 # 79b8 <malloc+0x1aa6>
    13f6:	f4f43c23          	sd	a5,-168(s0)
    13fa:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    13fe:	f5840593          	addi	a1,s0,-168
    1402:	f6840513          	addi	a0,s0,-152
    1406:	00004097          	auipc	ra,0x4
    140a:	712080e7          	jalr	1810(ra) # 5b18 <exec>
  if (ret != -1) {
    140e:	57fd                	li	a5,-1
    1410:	0ef51963          	bne	a0,a5,1502 <copyinstr2+0x172>
  int pid = fork();
    1414:	00004097          	auipc	ra,0x4
    1418:	6c4080e7          	jalr	1732(ra) # 5ad8 <fork>
  if (pid < 0) {
    141c:	10054363          	bltz	a0,1522 <copyinstr2+0x192>
  if (pid == 0) {
    1420:	12051463          	bnez	a0,1548 <copyinstr2+0x1b8>
    1424:	00008797          	auipc	a5,0x8
    1428:	12c78793          	addi	a5,a5,300 # 9550 <big.0>
    142c:	00009697          	auipc	a3,0x9
    1430:	12468693          	addi	a3,a3,292 # a550 <big.0+0x1000>
    for (int i = 0; i < PGSIZE; i++) big[i] = 'x';
    1434:	07800713          	li	a4,120
    1438:	00e78023          	sb	a4,0(a5)
    143c:	0785                	addi	a5,a5,1
    143e:	fed79de3          	bne	a5,a3,1438 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1442:	00009797          	auipc	a5,0x9
    1446:	10078723          	sb	zero,270(a5) # a550 <big.0+0x1000>
    char *args2[] = {big, big, big, 0};
    144a:	00007797          	auipc	a5,0x7
    144e:	f9e78793          	addi	a5,a5,-98 # 83e8 <malloc+0x24d6>
    1452:	6390                	ld	a2,0(a5)
    1454:	6794                	ld	a3,8(a5)
    1456:	6b98                	ld	a4,16(a5)
    1458:	6f9c                	ld	a5,24(a5)
    145a:	f2c43823          	sd	a2,-208(s0)
    145e:	f2d43c23          	sd	a3,-200(s0)
    1462:	f4e43023          	sd	a4,-192(s0)
    1466:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    146a:	f3040593          	addi	a1,s0,-208
    146e:	00005517          	auipc	a0,0x5
    1472:	bca50513          	addi	a0,a0,-1078 # 6038 <malloc+0x126>
    1476:	00004097          	auipc	ra,0x4
    147a:	6a2080e7          	jalr	1698(ra) # 5b18 <exec>
    if (ret != -1) {
    147e:	57fd                	li	a5,-1
    1480:	0af50e63          	beq	a0,a5,153c <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1484:	55fd                	li	a1,-1
    1486:	00005517          	auipc	a0,0x5
    148a:	3f250513          	addi	a0,a0,1010 # 6878 <malloc+0x966>
    148e:	00005097          	auipc	ra,0x5
    1492:	9cc080e7          	jalr	-1588(ra) # 5e5a <printf>
      exit(1);
    1496:	4505                	li	a0,1
    1498:	00004097          	auipc	ra,0x4
    149c:	648080e7          	jalr	1608(ra) # 5ae0 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14a0:	862a                	mv	a2,a0
    14a2:	f6840593          	addi	a1,s0,-152
    14a6:	00005517          	auipc	a0,0x5
    14aa:	34a50513          	addi	a0,a0,842 # 67f0 <malloc+0x8de>
    14ae:	00005097          	auipc	ra,0x5
    14b2:	9ac080e7          	jalr	-1620(ra) # 5e5a <printf>
    exit(1);
    14b6:	4505                	li	a0,1
    14b8:	00004097          	auipc	ra,0x4
    14bc:	628080e7          	jalr	1576(ra) # 5ae0 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14c0:	862a                	mv	a2,a0
    14c2:	f6840593          	addi	a1,s0,-152
    14c6:	00005517          	auipc	a0,0x5
    14ca:	34a50513          	addi	a0,a0,842 # 6810 <malloc+0x8fe>
    14ce:	00005097          	auipc	ra,0x5
    14d2:	98c080e7          	jalr	-1652(ra) # 5e5a <printf>
    exit(1);
    14d6:	4505                	li	a0,1
    14d8:	00004097          	auipc	ra,0x4
    14dc:	608080e7          	jalr	1544(ra) # 5ae0 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14e0:	86aa                	mv	a3,a0
    14e2:	f6840613          	addi	a2,s0,-152
    14e6:	85b2                	mv	a1,a2
    14e8:	00005517          	auipc	a0,0x5
    14ec:	34850513          	addi	a0,a0,840 # 6830 <malloc+0x91e>
    14f0:	00005097          	auipc	ra,0x5
    14f4:	96a080e7          	jalr	-1686(ra) # 5e5a <printf>
    exit(1);
    14f8:	4505                	li	a0,1
    14fa:	00004097          	auipc	ra,0x4
    14fe:	5e6080e7          	jalr	1510(ra) # 5ae0 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1502:	567d                	li	a2,-1
    1504:	f6840593          	addi	a1,s0,-152
    1508:	00005517          	auipc	a0,0x5
    150c:	35050513          	addi	a0,a0,848 # 6858 <malloc+0x946>
    1510:	00005097          	auipc	ra,0x5
    1514:	94a080e7          	jalr	-1718(ra) # 5e5a <printf>
    exit(1);
    1518:	4505                	li	a0,1
    151a:	00004097          	auipc	ra,0x4
    151e:	5c6080e7          	jalr	1478(ra) # 5ae0 <exit>
    printf("fork failed\n");
    1522:	00005517          	auipc	a0,0x5
    1526:	74650513          	addi	a0,a0,1862 # 6c68 <malloc+0xd56>
    152a:	00005097          	auipc	ra,0x5
    152e:	930080e7          	jalr	-1744(ra) # 5e5a <printf>
    exit(1);
    1532:	4505                	li	a0,1
    1534:	00004097          	auipc	ra,0x4
    1538:	5ac080e7          	jalr	1452(ra) # 5ae0 <exit>
    exit(747);  // OK
    153c:	2eb00513          	li	a0,747
    1540:	00004097          	auipc	ra,0x4
    1544:	5a0080e7          	jalr	1440(ra) # 5ae0 <exit>
  int st = 0;
    1548:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    154c:	f5440513          	addi	a0,s0,-172
    1550:	00004097          	auipc	ra,0x4
    1554:	598080e7          	jalr	1432(ra) # 5ae8 <wait>
  if (st != 747) {
    1558:	f5442703          	lw	a4,-172(s0)
    155c:	2eb00793          	li	a5,747
    1560:	00f71663          	bne	a4,a5,156c <copyinstr2+0x1dc>
}
    1564:	60ae                	ld	ra,200(sp)
    1566:	640e                	ld	s0,192(sp)
    1568:	6169                	addi	sp,sp,208
    156a:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    156c:	00005517          	auipc	a0,0x5
    1570:	33450513          	addi	a0,a0,820 # 68a0 <malloc+0x98e>
    1574:	00005097          	auipc	ra,0x5
    1578:	8e6080e7          	jalr	-1818(ra) # 5e5a <printf>
    exit(1);
    157c:	4505                	li	a0,1
    157e:	00004097          	auipc	ra,0x4
    1582:	562080e7          	jalr	1378(ra) # 5ae0 <exit>

0000000000001586 <truncate3>:
void truncate3(char *s) {
    1586:	7159                	addi	sp,sp,-112
    1588:	f486                	sd	ra,104(sp)
    158a:	f0a2                	sd	s0,96(sp)
    158c:	eca6                	sd	s1,88(sp)
    158e:	e8ca                	sd	s2,80(sp)
    1590:	e4ce                	sd	s3,72(sp)
    1592:	e0d2                	sd	s4,64(sp)
    1594:	fc56                	sd	s5,56(sp)
    1596:	1880                	addi	s0,sp,112
    1598:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE | O_TRUNC | O_WRONLY));
    159a:	60100593          	li	a1,1537
    159e:	00005517          	auipc	a0,0x5
    15a2:	af250513          	addi	a0,a0,-1294 # 6090 <malloc+0x17e>
    15a6:	00004097          	auipc	ra,0x4
    15aa:	57a080e7          	jalr	1402(ra) # 5b20 <open>
    15ae:	00004097          	auipc	ra,0x4
    15b2:	55a080e7          	jalr	1370(ra) # 5b08 <close>
  pid = fork();
    15b6:	00004097          	auipc	ra,0x4
    15ba:	522080e7          	jalr	1314(ra) # 5ad8 <fork>
  if (pid < 0) {
    15be:	08054063          	bltz	a0,163e <truncate3+0xb8>
  if (pid == 0) {
    15c2:	e969                	bnez	a0,1694 <truncate3+0x10e>
    15c4:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    15c8:	00005a17          	auipc	s4,0x5
    15cc:	ac8a0a13          	addi	s4,s4,-1336 # 6090 <malloc+0x17e>
      int n = write(fd, "1234567890", 10);
    15d0:	00005a97          	auipc	s5,0x5
    15d4:	330a8a93          	addi	s5,s5,816 # 6900 <malloc+0x9ee>
      int fd = open("truncfile", O_WRONLY);
    15d8:	4585                	li	a1,1
    15da:	8552                	mv	a0,s4
    15dc:	00004097          	auipc	ra,0x4
    15e0:	544080e7          	jalr	1348(ra) # 5b20 <open>
    15e4:	84aa                	mv	s1,a0
      if (fd < 0) {
    15e6:	06054a63          	bltz	a0,165a <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    15ea:	4629                	li	a2,10
    15ec:	85d6                	mv	a1,s5
    15ee:	00004097          	auipc	ra,0x4
    15f2:	512080e7          	jalr	1298(ra) # 5b00 <write>
      if (n != 10) {
    15f6:	47a9                	li	a5,10
    15f8:	06f51f63          	bne	a0,a5,1676 <truncate3+0xf0>
      close(fd);
    15fc:	8526                	mv	a0,s1
    15fe:	00004097          	auipc	ra,0x4
    1602:	50a080e7          	jalr	1290(ra) # 5b08 <close>
      fd = open("truncfile", O_RDONLY);
    1606:	4581                	li	a1,0
    1608:	8552                	mv	a0,s4
    160a:	00004097          	auipc	ra,0x4
    160e:	516080e7          	jalr	1302(ra) # 5b20 <open>
    1612:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1614:	02000613          	li	a2,32
    1618:	f9840593          	addi	a1,s0,-104
    161c:	00004097          	auipc	ra,0x4
    1620:	4dc080e7          	jalr	1244(ra) # 5af8 <read>
      close(fd);
    1624:	8526                	mv	a0,s1
    1626:	00004097          	auipc	ra,0x4
    162a:	4e2080e7          	jalr	1250(ra) # 5b08 <close>
    for (int i = 0; i < 100; i++) {
    162e:	39fd                	addiw	s3,s3,-1
    1630:	fa0994e3          	bnez	s3,15d8 <truncate3+0x52>
    exit(0);
    1634:	4501                	li	a0,0
    1636:	00004097          	auipc	ra,0x4
    163a:	4aa080e7          	jalr	1194(ra) # 5ae0 <exit>
    printf("%s: fork failed\n", s);
    163e:	85ca                	mv	a1,s2
    1640:	00005517          	auipc	a0,0x5
    1644:	29050513          	addi	a0,a0,656 # 68d0 <malloc+0x9be>
    1648:	00005097          	auipc	ra,0x5
    164c:	812080e7          	jalr	-2030(ra) # 5e5a <printf>
    exit(1);
    1650:	4505                	li	a0,1
    1652:	00004097          	auipc	ra,0x4
    1656:	48e080e7          	jalr	1166(ra) # 5ae0 <exit>
        printf("%s: open failed\n", s);
    165a:	85ca                	mv	a1,s2
    165c:	00005517          	auipc	a0,0x5
    1660:	28c50513          	addi	a0,a0,652 # 68e8 <malloc+0x9d6>
    1664:	00004097          	auipc	ra,0x4
    1668:	7f6080e7          	jalr	2038(ra) # 5e5a <printf>
        exit(1);
    166c:	4505                	li	a0,1
    166e:	00004097          	auipc	ra,0x4
    1672:	472080e7          	jalr	1138(ra) # 5ae0 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1676:	862a                	mv	a2,a0
    1678:	85ca                	mv	a1,s2
    167a:	00005517          	auipc	a0,0x5
    167e:	29650513          	addi	a0,a0,662 # 6910 <malloc+0x9fe>
    1682:	00004097          	auipc	ra,0x4
    1686:	7d8080e7          	jalr	2008(ra) # 5e5a <printf>
        exit(1);
    168a:	4505                	li	a0,1
    168c:	00004097          	auipc	ra,0x4
    1690:	454080e7          	jalr	1108(ra) # 5ae0 <exit>
    1694:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    1698:	00005a17          	auipc	s4,0x5
    169c:	9f8a0a13          	addi	s4,s4,-1544 # 6090 <malloc+0x17e>
    int n = write(fd, "xxx", 3);
    16a0:	00005a97          	auipc	s5,0x5
    16a4:	290a8a93          	addi	s5,s5,656 # 6930 <malloc+0xa1e>
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    16a8:	60100593          	li	a1,1537
    16ac:	8552                	mv	a0,s4
    16ae:	00004097          	auipc	ra,0x4
    16b2:	472080e7          	jalr	1138(ra) # 5b20 <open>
    16b6:	84aa                	mv	s1,a0
    if (fd < 0) {
    16b8:	04054763          	bltz	a0,1706 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    16bc:	460d                	li	a2,3
    16be:	85d6                	mv	a1,s5
    16c0:	00004097          	auipc	ra,0x4
    16c4:	440080e7          	jalr	1088(ra) # 5b00 <write>
    if (n != 3) {
    16c8:	478d                	li	a5,3
    16ca:	04f51c63          	bne	a0,a5,1722 <truncate3+0x19c>
    close(fd);
    16ce:	8526                	mv	a0,s1
    16d0:	00004097          	auipc	ra,0x4
    16d4:	438080e7          	jalr	1080(ra) # 5b08 <close>
  for (int i = 0; i < 150; i++) {
    16d8:	39fd                	addiw	s3,s3,-1
    16da:	fc0997e3          	bnez	s3,16a8 <truncate3+0x122>
  wait(&xstatus);
    16de:	fbc40513          	addi	a0,s0,-68
    16e2:	00004097          	auipc	ra,0x4
    16e6:	406080e7          	jalr	1030(ra) # 5ae8 <wait>
  unlink("truncfile");
    16ea:	00005517          	auipc	a0,0x5
    16ee:	9a650513          	addi	a0,a0,-1626 # 6090 <malloc+0x17e>
    16f2:	00004097          	auipc	ra,0x4
    16f6:	43e080e7          	jalr	1086(ra) # 5b30 <unlink>
  exit(xstatus);
    16fa:	fbc42503          	lw	a0,-68(s0)
    16fe:	00004097          	auipc	ra,0x4
    1702:	3e2080e7          	jalr	994(ra) # 5ae0 <exit>
      printf("%s: open failed\n", s);
    1706:	85ca                	mv	a1,s2
    1708:	00005517          	auipc	a0,0x5
    170c:	1e050513          	addi	a0,a0,480 # 68e8 <malloc+0x9d6>
    1710:	00004097          	auipc	ra,0x4
    1714:	74a080e7          	jalr	1866(ra) # 5e5a <printf>
      exit(1);
    1718:	4505                	li	a0,1
    171a:	00004097          	auipc	ra,0x4
    171e:	3c6080e7          	jalr	966(ra) # 5ae0 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1722:	862a                	mv	a2,a0
    1724:	85ca                	mv	a1,s2
    1726:	00005517          	auipc	a0,0x5
    172a:	21250513          	addi	a0,a0,530 # 6938 <malloc+0xa26>
    172e:	00004097          	auipc	ra,0x4
    1732:	72c080e7          	jalr	1836(ra) # 5e5a <printf>
      exit(1);
    1736:	4505                	li	a0,1
    1738:	00004097          	auipc	ra,0x4
    173c:	3a8080e7          	jalr	936(ra) # 5ae0 <exit>

0000000000001740 <exectest>:
void exectest(char *s) {
    1740:	715d                	addi	sp,sp,-80
    1742:	e486                	sd	ra,72(sp)
    1744:	e0a2                	sd	s0,64(sp)
    1746:	fc26                	sd	s1,56(sp)
    1748:	f84a                	sd	s2,48(sp)
    174a:	0880                	addi	s0,sp,80
    174c:	892a                	mv	s2,a0
  char *echoargv[] = {"echo", "OK", 0};
    174e:	00005797          	auipc	a5,0x5
    1752:	8ea78793          	addi	a5,a5,-1814 # 6038 <malloc+0x126>
    1756:	fcf43023          	sd	a5,-64(s0)
    175a:	00005797          	auipc	a5,0x5
    175e:	1fe78793          	addi	a5,a5,510 # 6958 <malloc+0xa46>
    1762:	fcf43423          	sd	a5,-56(s0)
    1766:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    176a:	00005517          	auipc	a0,0x5
    176e:	1f650513          	addi	a0,a0,502 # 6960 <malloc+0xa4e>
    1772:	00004097          	auipc	ra,0x4
    1776:	3be080e7          	jalr	958(ra) # 5b30 <unlink>
  pid = fork();
    177a:	00004097          	auipc	ra,0x4
    177e:	35e080e7          	jalr	862(ra) # 5ad8 <fork>
  if (pid < 0) {
    1782:	04054663          	bltz	a0,17ce <exectest+0x8e>
    1786:	84aa                	mv	s1,a0
  if (pid == 0) {
    1788:	e959                	bnez	a0,181e <exectest+0xde>
    close(1);
    178a:	4505                	li	a0,1
    178c:	00004097          	auipc	ra,0x4
    1790:	37c080e7          	jalr	892(ra) # 5b08 <close>
    fd = open("echo-ok", O_CREATE | O_WRONLY);
    1794:	20100593          	li	a1,513
    1798:	00005517          	auipc	a0,0x5
    179c:	1c850513          	addi	a0,a0,456 # 6960 <malloc+0xa4e>
    17a0:	00004097          	auipc	ra,0x4
    17a4:	380080e7          	jalr	896(ra) # 5b20 <open>
    if (fd < 0) {
    17a8:	04054163          	bltz	a0,17ea <exectest+0xaa>
    if (fd != 1) {
    17ac:	4785                	li	a5,1
    17ae:	04f50c63          	beq	a0,a5,1806 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    17b2:	85ca                	mv	a1,s2
    17b4:	00005517          	auipc	a0,0x5
    17b8:	1cc50513          	addi	a0,a0,460 # 6980 <malloc+0xa6e>
    17bc:	00004097          	auipc	ra,0x4
    17c0:	69e080e7          	jalr	1694(ra) # 5e5a <printf>
      exit(1);
    17c4:	4505                	li	a0,1
    17c6:	00004097          	auipc	ra,0x4
    17ca:	31a080e7          	jalr	794(ra) # 5ae0 <exit>
    printf("%s: fork failed\n", s);
    17ce:	85ca                	mv	a1,s2
    17d0:	00005517          	auipc	a0,0x5
    17d4:	10050513          	addi	a0,a0,256 # 68d0 <malloc+0x9be>
    17d8:	00004097          	auipc	ra,0x4
    17dc:	682080e7          	jalr	1666(ra) # 5e5a <printf>
    exit(1);
    17e0:	4505                	li	a0,1
    17e2:	00004097          	auipc	ra,0x4
    17e6:	2fe080e7          	jalr	766(ra) # 5ae0 <exit>
      printf("%s: create failed\n", s);
    17ea:	85ca                	mv	a1,s2
    17ec:	00005517          	auipc	a0,0x5
    17f0:	17c50513          	addi	a0,a0,380 # 6968 <malloc+0xa56>
    17f4:	00004097          	auipc	ra,0x4
    17f8:	666080e7          	jalr	1638(ra) # 5e5a <printf>
      exit(1);
    17fc:	4505                	li	a0,1
    17fe:	00004097          	auipc	ra,0x4
    1802:	2e2080e7          	jalr	738(ra) # 5ae0 <exit>
    if (exec("echo", echoargv) < 0) {
    1806:	fc040593          	addi	a1,s0,-64
    180a:	00005517          	auipc	a0,0x5
    180e:	82e50513          	addi	a0,a0,-2002 # 6038 <malloc+0x126>
    1812:	00004097          	auipc	ra,0x4
    1816:	306080e7          	jalr	774(ra) # 5b18 <exec>
    181a:	02054163          	bltz	a0,183c <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    181e:	fdc40513          	addi	a0,s0,-36
    1822:	00004097          	auipc	ra,0x4
    1826:	2c6080e7          	jalr	710(ra) # 5ae8 <wait>
    182a:	02951763          	bne	a0,s1,1858 <exectest+0x118>
  if (xstatus != 0) exit(xstatus);
    182e:	fdc42503          	lw	a0,-36(s0)
    1832:	cd0d                	beqz	a0,186c <exectest+0x12c>
    1834:	00004097          	auipc	ra,0x4
    1838:	2ac080e7          	jalr	684(ra) # 5ae0 <exit>
      printf("%s: exec echo failed\n", s);
    183c:	85ca                	mv	a1,s2
    183e:	00005517          	auipc	a0,0x5
    1842:	15250513          	addi	a0,a0,338 # 6990 <malloc+0xa7e>
    1846:	00004097          	auipc	ra,0x4
    184a:	614080e7          	jalr	1556(ra) # 5e5a <printf>
      exit(1);
    184e:	4505                	li	a0,1
    1850:	00004097          	auipc	ra,0x4
    1854:	290080e7          	jalr	656(ra) # 5ae0 <exit>
    printf("%s: wait failed!\n", s);
    1858:	85ca                	mv	a1,s2
    185a:	00005517          	auipc	a0,0x5
    185e:	14e50513          	addi	a0,a0,334 # 69a8 <malloc+0xa96>
    1862:	00004097          	auipc	ra,0x4
    1866:	5f8080e7          	jalr	1528(ra) # 5e5a <printf>
    186a:	b7d1                	j	182e <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    186c:	4581                	li	a1,0
    186e:	00005517          	auipc	a0,0x5
    1872:	0f250513          	addi	a0,a0,242 # 6960 <malloc+0xa4e>
    1876:	00004097          	auipc	ra,0x4
    187a:	2aa080e7          	jalr	682(ra) # 5b20 <open>
  if (fd < 0) {
    187e:	02054a63          	bltz	a0,18b2 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    1882:	4609                	li	a2,2
    1884:	fb840593          	addi	a1,s0,-72
    1888:	00004097          	auipc	ra,0x4
    188c:	270080e7          	jalr	624(ra) # 5af8 <read>
    1890:	4789                	li	a5,2
    1892:	02f50e63          	beq	a0,a5,18ce <exectest+0x18e>
    printf("%s: read failed\n", s);
    1896:	85ca                	mv	a1,s2
    1898:	00005517          	auipc	a0,0x5
    189c:	b8050513          	addi	a0,a0,-1152 # 6418 <malloc+0x506>
    18a0:	00004097          	auipc	ra,0x4
    18a4:	5ba080e7          	jalr	1466(ra) # 5e5a <printf>
    exit(1);
    18a8:	4505                	li	a0,1
    18aa:	00004097          	auipc	ra,0x4
    18ae:	236080e7          	jalr	566(ra) # 5ae0 <exit>
    printf("%s: open failed\n", s);
    18b2:	85ca                	mv	a1,s2
    18b4:	00005517          	auipc	a0,0x5
    18b8:	03450513          	addi	a0,a0,52 # 68e8 <malloc+0x9d6>
    18bc:	00004097          	auipc	ra,0x4
    18c0:	59e080e7          	jalr	1438(ra) # 5e5a <printf>
    exit(1);
    18c4:	4505                	li	a0,1
    18c6:	00004097          	auipc	ra,0x4
    18ca:	21a080e7          	jalr	538(ra) # 5ae0 <exit>
  unlink("echo-ok");
    18ce:	00005517          	auipc	a0,0x5
    18d2:	09250513          	addi	a0,a0,146 # 6960 <malloc+0xa4e>
    18d6:	00004097          	auipc	ra,0x4
    18da:	25a080e7          	jalr	602(ra) # 5b30 <unlink>
  if (buf[0] == 'O' && buf[1] == 'K')
    18de:	fb844703          	lbu	a4,-72(s0)
    18e2:	04f00793          	li	a5,79
    18e6:	00f71863          	bne	a4,a5,18f6 <exectest+0x1b6>
    18ea:	fb944703          	lbu	a4,-71(s0)
    18ee:	04b00793          	li	a5,75
    18f2:	02f70063          	beq	a4,a5,1912 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    18f6:	85ca                	mv	a1,s2
    18f8:	00005517          	auipc	a0,0x5
    18fc:	0c850513          	addi	a0,a0,200 # 69c0 <malloc+0xaae>
    1900:	00004097          	auipc	ra,0x4
    1904:	55a080e7          	jalr	1370(ra) # 5e5a <printf>
    exit(1);
    1908:	4505                	li	a0,1
    190a:	00004097          	auipc	ra,0x4
    190e:	1d6080e7          	jalr	470(ra) # 5ae0 <exit>
    exit(0);
    1912:	4501                	li	a0,0
    1914:	00004097          	auipc	ra,0x4
    1918:	1cc080e7          	jalr	460(ra) # 5ae0 <exit>

000000000000191c <pipe1>:
void pipe1(char *s) {
    191c:	711d                	addi	sp,sp,-96
    191e:	ec86                	sd	ra,88(sp)
    1920:	e8a2                	sd	s0,80(sp)
    1922:	e4a6                	sd	s1,72(sp)
    1924:	e0ca                	sd	s2,64(sp)
    1926:	fc4e                	sd	s3,56(sp)
    1928:	f852                	sd	s4,48(sp)
    192a:	f456                	sd	s5,40(sp)
    192c:	f05a                	sd	s6,32(sp)
    192e:	ec5e                	sd	s7,24(sp)
    1930:	1080                	addi	s0,sp,96
    1932:	892a                	mv	s2,a0
  if (pipe(fds) != 0) {
    1934:	fa840513          	addi	a0,s0,-88
    1938:	00004097          	auipc	ra,0x4
    193c:	1b8080e7          	jalr	440(ra) # 5af0 <pipe>
    1940:	e93d                	bnez	a0,19b6 <pipe1+0x9a>
    1942:	84aa                	mv	s1,a0
  pid = fork();
    1944:	00004097          	auipc	ra,0x4
    1948:	194080e7          	jalr	404(ra) # 5ad8 <fork>
    194c:	8a2a                	mv	s4,a0
  if (pid == 0) {
    194e:	c151                	beqz	a0,19d2 <pipe1+0xb6>
  } else if (pid > 0) {
    1950:	16a05d63          	blez	a0,1aca <pipe1+0x1ae>
    close(fds[1]);
    1954:	fac42503          	lw	a0,-84(s0)
    1958:	00004097          	auipc	ra,0x4
    195c:	1b0080e7          	jalr	432(ra) # 5b08 <close>
    total = 0;
    1960:	8a26                	mv	s4,s1
    cc = 1;
    1962:	4985                	li	s3,1
    while ((n = read(fds[0], buf, cc)) > 0) {
    1964:	0000ba97          	auipc	s5,0xb
    1968:	304a8a93          	addi	s5,s5,772 # cc68 <buf>
      if (cc > sizeof(buf)) cc = sizeof(buf);
    196c:	6b0d                	lui	s6,0x3
    while ((n = read(fds[0], buf, cc)) > 0) {
    196e:	864e                	mv	a2,s3
    1970:	85d6                	mv	a1,s5
    1972:	fa842503          	lw	a0,-88(s0)
    1976:	00004097          	auipc	ra,0x4
    197a:	182080e7          	jalr	386(ra) # 5af8 <read>
    197e:	10a05163          	blez	a0,1a80 <pipe1+0x164>
      for (i = 0; i < n; i++) {
    1982:	0000b717          	auipc	a4,0xb
    1986:	2e670713          	addi	a4,a4,742 # cc68 <buf>
    198a:	00a4863b          	addw	a2,s1,a0
        if ((buf[i] & 0xff) != (seq++ & 0xff)) {
    198e:	00074683          	lbu	a3,0(a4)
    1992:	0ff4f793          	zext.b	a5,s1
    1996:	2485                	addiw	s1,s1,1
    1998:	0cf69063          	bne	a3,a5,1a58 <pipe1+0x13c>
      for (i = 0; i < n; i++) {
    199c:	0705                	addi	a4,a4,1
    199e:	fec498e3          	bne	s1,a2,198e <pipe1+0x72>
      total += n;
    19a2:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    19a6:	0019979b          	slliw	a5,s3,0x1
    19aa:	0007899b          	sext.w	s3,a5
      if (cc > sizeof(buf)) cc = sizeof(buf);
    19ae:	fd3b70e3          	bgeu	s6,s3,196e <pipe1+0x52>
    19b2:	89da                	mv	s3,s6
    19b4:	bf6d                	j	196e <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    19b6:	85ca                	mv	a1,s2
    19b8:	00005517          	auipc	a0,0x5
    19bc:	02050513          	addi	a0,a0,32 # 69d8 <malloc+0xac6>
    19c0:	00004097          	auipc	ra,0x4
    19c4:	49a080e7          	jalr	1178(ra) # 5e5a <printf>
    exit(1);
    19c8:	4505                	li	a0,1
    19ca:	00004097          	auipc	ra,0x4
    19ce:	116080e7          	jalr	278(ra) # 5ae0 <exit>
    close(fds[0]);
    19d2:	fa842503          	lw	a0,-88(s0)
    19d6:	00004097          	auipc	ra,0x4
    19da:	132080e7          	jalr	306(ra) # 5b08 <close>
    for (n = 0; n < N; n++) {
    19de:	0000bb17          	auipc	s6,0xb
    19e2:	28ab0b13          	addi	s6,s6,650 # cc68 <buf>
    19e6:	416004bb          	negw	s1,s6
    19ea:	0ff4f493          	zext.b	s1,s1
    19ee:	409b0993          	addi	s3,s6,1033
      if (write(fds[1], buf, SZ) != SZ) {
    19f2:	8bda                	mv	s7,s6
    for (n = 0; n < N; n++) {
    19f4:	6a85                	lui	s5,0x1
    19f6:	42da8a93          	addi	s5,s5,1069 # 142d <copyinstr2+0x9d>
void pipe1(char *s) {
    19fa:	87da                	mv	a5,s6
      for (i = 0; i < SZ; i++) buf[i] = seq++;
    19fc:	0097873b          	addw	a4,a5,s1
    1a00:	00e78023          	sb	a4,0(a5)
    1a04:	0785                	addi	a5,a5,1
    1a06:	fef99be3          	bne	s3,a5,19fc <pipe1+0xe0>
    1a0a:	409a0a1b          	addiw	s4,s4,1033
      if (write(fds[1], buf, SZ) != SZ) {
    1a0e:	40900613          	li	a2,1033
    1a12:	85de                	mv	a1,s7
    1a14:	fac42503          	lw	a0,-84(s0)
    1a18:	00004097          	auipc	ra,0x4
    1a1c:	0e8080e7          	jalr	232(ra) # 5b00 <write>
    1a20:	40900793          	li	a5,1033
    1a24:	00f51c63          	bne	a0,a5,1a3c <pipe1+0x120>
    for (n = 0; n < N; n++) {
    1a28:	24a5                	addiw	s1,s1,9
    1a2a:	0ff4f493          	zext.b	s1,s1
    1a2e:	fd5a16e3          	bne	s4,s5,19fa <pipe1+0xde>
    exit(0);
    1a32:	4501                	li	a0,0
    1a34:	00004097          	auipc	ra,0x4
    1a38:	0ac080e7          	jalr	172(ra) # 5ae0 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a3c:	85ca                	mv	a1,s2
    1a3e:	00005517          	auipc	a0,0x5
    1a42:	fb250513          	addi	a0,a0,-78 # 69f0 <malloc+0xade>
    1a46:	00004097          	auipc	ra,0x4
    1a4a:	414080e7          	jalr	1044(ra) # 5e5a <printf>
        exit(1);
    1a4e:	4505                	li	a0,1
    1a50:	00004097          	auipc	ra,0x4
    1a54:	090080e7          	jalr	144(ra) # 5ae0 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a58:	85ca                	mv	a1,s2
    1a5a:	00005517          	auipc	a0,0x5
    1a5e:	fae50513          	addi	a0,a0,-82 # 6a08 <malloc+0xaf6>
    1a62:	00004097          	auipc	ra,0x4
    1a66:	3f8080e7          	jalr	1016(ra) # 5e5a <printf>
}
    1a6a:	60e6                	ld	ra,88(sp)
    1a6c:	6446                	ld	s0,80(sp)
    1a6e:	64a6                	ld	s1,72(sp)
    1a70:	6906                	ld	s2,64(sp)
    1a72:	79e2                	ld	s3,56(sp)
    1a74:	7a42                	ld	s4,48(sp)
    1a76:	7aa2                	ld	s5,40(sp)
    1a78:	7b02                	ld	s6,32(sp)
    1a7a:	6be2                	ld	s7,24(sp)
    1a7c:	6125                	addi	sp,sp,96
    1a7e:	8082                	ret
    if (total != N * SZ) {
    1a80:	6785                	lui	a5,0x1
    1a82:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x9d>
    1a86:	02fa0063          	beq	s4,a5,1aa6 <pipe1+0x18a>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1a8a:	85d2                	mv	a1,s4
    1a8c:	00005517          	auipc	a0,0x5
    1a90:	f9450513          	addi	a0,a0,-108 # 6a20 <malloc+0xb0e>
    1a94:	00004097          	auipc	ra,0x4
    1a98:	3c6080e7          	jalr	966(ra) # 5e5a <printf>
      exit(1);
    1a9c:	4505                	li	a0,1
    1a9e:	00004097          	auipc	ra,0x4
    1aa2:	042080e7          	jalr	66(ra) # 5ae0 <exit>
    close(fds[0]);
    1aa6:	fa842503          	lw	a0,-88(s0)
    1aaa:	00004097          	auipc	ra,0x4
    1aae:	05e080e7          	jalr	94(ra) # 5b08 <close>
    wait(&xstatus);
    1ab2:	fa440513          	addi	a0,s0,-92
    1ab6:	00004097          	auipc	ra,0x4
    1aba:	032080e7          	jalr	50(ra) # 5ae8 <wait>
    exit(xstatus);
    1abe:	fa442503          	lw	a0,-92(s0)
    1ac2:	00004097          	auipc	ra,0x4
    1ac6:	01e080e7          	jalr	30(ra) # 5ae0 <exit>
    printf("%s: fork() failed\n", s);
    1aca:	85ca                	mv	a1,s2
    1acc:	00005517          	auipc	a0,0x5
    1ad0:	f7450513          	addi	a0,a0,-140 # 6a40 <malloc+0xb2e>
    1ad4:	00004097          	auipc	ra,0x4
    1ad8:	386080e7          	jalr	902(ra) # 5e5a <printf>
    exit(1);
    1adc:	4505                	li	a0,1
    1ade:	00004097          	auipc	ra,0x4
    1ae2:	002080e7          	jalr	2(ra) # 5ae0 <exit>

0000000000001ae6 <exitwait>:
void exitwait(char *s) {
    1ae6:	7139                	addi	sp,sp,-64
    1ae8:	fc06                	sd	ra,56(sp)
    1aea:	f822                	sd	s0,48(sp)
    1aec:	f426                	sd	s1,40(sp)
    1aee:	f04a                	sd	s2,32(sp)
    1af0:	ec4e                	sd	s3,24(sp)
    1af2:	e852                	sd	s4,16(sp)
    1af4:	0080                	addi	s0,sp,64
    1af6:	8a2a                	mv	s4,a0
  for (i = 0; i < 100; i++) {
    1af8:	4901                	li	s2,0
    1afa:	06400993          	li	s3,100
    pid = fork();
    1afe:	00004097          	auipc	ra,0x4
    1b02:	fda080e7          	jalr	-38(ra) # 5ad8 <fork>
    1b06:	84aa                	mv	s1,a0
    if (pid < 0) {
    1b08:	02054a63          	bltz	a0,1b3c <exitwait+0x56>
    if (pid) {
    1b0c:	c151                	beqz	a0,1b90 <exitwait+0xaa>
      if (wait(&xstate) != pid) {
    1b0e:	fcc40513          	addi	a0,s0,-52
    1b12:	00004097          	auipc	ra,0x4
    1b16:	fd6080e7          	jalr	-42(ra) # 5ae8 <wait>
    1b1a:	02951f63          	bne	a0,s1,1b58 <exitwait+0x72>
      if (i != xstate) {
    1b1e:	fcc42783          	lw	a5,-52(s0)
    1b22:	05279963          	bne	a5,s2,1b74 <exitwait+0x8e>
  for (i = 0; i < 100; i++) {
    1b26:	2905                	addiw	s2,s2,1
    1b28:	fd391be3          	bne	s2,s3,1afe <exitwait+0x18>
}
    1b2c:	70e2                	ld	ra,56(sp)
    1b2e:	7442                	ld	s0,48(sp)
    1b30:	74a2                	ld	s1,40(sp)
    1b32:	7902                	ld	s2,32(sp)
    1b34:	69e2                	ld	s3,24(sp)
    1b36:	6a42                	ld	s4,16(sp)
    1b38:	6121                	addi	sp,sp,64
    1b3a:	8082                	ret
      printf("%s: fork failed\n", s);
    1b3c:	85d2                	mv	a1,s4
    1b3e:	00005517          	auipc	a0,0x5
    1b42:	d9250513          	addi	a0,a0,-622 # 68d0 <malloc+0x9be>
    1b46:	00004097          	auipc	ra,0x4
    1b4a:	314080e7          	jalr	788(ra) # 5e5a <printf>
      exit(1);
    1b4e:	4505                	li	a0,1
    1b50:	00004097          	auipc	ra,0x4
    1b54:	f90080e7          	jalr	-112(ra) # 5ae0 <exit>
        printf("%s: wait wrong pid\n", s);
    1b58:	85d2                	mv	a1,s4
    1b5a:	00005517          	auipc	a0,0x5
    1b5e:	efe50513          	addi	a0,a0,-258 # 6a58 <malloc+0xb46>
    1b62:	00004097          	auipc	ra,0x4
    1b66:	2f8080e7          	jalr	760(ra) # 5e5a <printf>
        exit(1);
    1b6a:	4505                	li	a0,1
    1b6c:	00004097          	auipc	ra,0x4
    1b70:	f74080e7          	jalr	-140(ra) # 5ae0 <exit>
        printf("%s: wait wrong exit status\n", s);
    1b74:	85d2                	mv	a1,s4
    1b76:	00005517          	auipc	a0,0x5
    1b7a:	efa50513          	addi	a0,a0,-262 # 6a70 <malloc+0xb5e>
    1b7e:	00004097          	auipc	ra,0x4
    1b82:	2dc080e7          	jalr	732(ra) # 5e5a <printf>
        exit(1);
    1b86:	4505                	li	a0,1
    1b88:	00004097          	auipc	ra,0x4
    1b8c:	f58080e7          	jalr	-168(ra) # 5ae0 <exit>
      exit(i);
    1b90:	854a                	mv	a0,s2
    1b92:	00004097          	auipc	ra,0x4
    1b96:	f4e080e7          	jalr	-178(ra) # 5ae0 <exit>

0000000000001b9a <twochildren>:
void twochildren(char *s) {
    1b9a:	1101                	addi	sp,sp,-32
    1b9c:	ec06                	sd	ra,24(sp)
    1b9e:	e822                	sd	s0,16(sp)
    1ba0:	e426                	sd	s1,8(sp)
    1ba2:	e04a                	sd	s2,0(sp)
    1ba4:	1000                	addi	s0,sp,32
    1ba6:	892a                	mv	s2,a0
    1ba8:	3e800493          	li	s1,1000
    int pid1 = fork();
    1bac:	00004097          	auipc	ra,0x4
    1bb0:	f2c080e7          	jalr	-212(ra) # 5ad8 <fork>
    if (pid1 < 0) {
    1bb4:	02054c63          	bltz	a0,1bec <twochildren+0x52>
    if (pid1 == 0) {
    1bb8:	c921                	beqz	a0,1c08 <twochildren+0x6e>
      int pid2 = fork();
    1bba:	00004097          	auipc	ra,0x4
    1bbe:	f1e080e7          	jalr	-226(ra) # 5ad8 <fork>
      if (pid2 < 0) {
    1bc2:	04054763          	bltz	a0,1c10 <twochildren+0x76>
      if (pid2 == 0) {
    1bc6:	c13d                	beqz	a0,1c2c <twochildren+0x92>
        wait(0);
    1bc8:	4501                	li	a0,0
    1bca:	00004097          	auipc	ra,0x4
    1bce:	f1e080e7          	jalr	-226(ra) # 5ae8 <wait>
        wait(0);
    1bd2:	4501                	li	a0,0
    1bd4:	00004097          	auipc	ra,0x4
    1bd8:	f14080e7          	jalr	-236(ra) # 5ae8 <wait>
  for (int i = 0; i < 1000; i++) {
    1bdc:	34fd                	addiw	s1,s1,-1
    1bde:	f4f9                	bnez	s1,1bac <twochildren+0x12>
}
    1be0:	60e2                	ld	ra,24(sp)
    1be2:	6442                	ld	s0,16(sp)
    1be4:	64a2                	ld	s1,8(sp)
    1be6:	6902                	ld	s2,0(sp)
    1be8:	6105                	addi	sp,sp,32
    1bea:	8082                	ret
      printf("%s: fork failed\n", s);
    1bec:	85ca                	mv	a1,s2
    1bee:	00005517          	auipc	a0,0x5
    1bf2:	ce250513          	addi	a0,a0,-798 # 68d0 <malloc+0x9be>
    1bf6:	00004097          	auipc	ra,0x4
    1bfa:	264080e7          	jalr	612(ra) # 5e5a <printf>
      exit(1);
    1bfe:	4505                	li	a0,1
    1c00:	00004097          	auipc	ra,0x4
    1c04:	ee0080e7          	jalr	-288(ra) # 5ae0 <exit>
      exit(0);
    1c08:	00004097          	auipc	ra,0x4
    1c0c:	ed8080e7          	jalr	-296(ra) # 5ae0 <exit>
        printf("%s: fork failed\n", s);
    1c10:	85ca                	mv	a1,s2
    1c12:	00005517          	auipc	a0,0x5
    1c16:	cbe50513          	addi	a0,a0,-834 # 68d0 <malloc+0x9be>
    1c1a:	00004097          	auipc	ra,0x4
    1c1e:	240080e7          	jalr	576(ra) # 5e5a <printf>
        exit(1);
    1c22:	4505                	li	a0,1
    1c24:	00004097          	auipc	ra,0x4
    1c28:	ebc080e7          	jalr	-324(ra) # 5ae0 <exit>
        exit(0);
    1c2c:	00004097          	auipc	ra,0x4
    1c30:	eb4080e7          	jalr	-332(ra) # 5ae0 <exit>

0000000000001c34 <forkfork>:
void forkfork(char *s) {
    1c34:	7179                	addi	sp,sp,-48
    1c36:	f406                	sd	ra,40(sp)
    1c38:	f022                	sd	s0,32(sp)
    1c3a:	ec26                	sd	s1,24(sp)
    1c3c:	1800                	addi	s0,sp,48
    1c3e:	84aa                	mv	s1,a0
    int pid = fork();
    1c40:	00004097          	auipc	ra,0x4
    1c44:	e98080e7          	jalr	-360(ra) # 5ad8 <fork>
    if (pid < 0) {
    1c48:	04054163          	bltz	a0,1c8a <forkfork+0x56>
    if (pid == 0) {
    1c4c:	cd29                	beqz	a0,1ca6 <forkfork+0x72>
    int pid = fork();
    1c4e:	00004097          	auipc	ra,0x4
    1c52:	e8a080e7          	jalr	-374(ra) # 5ad8 <fork>
    if (pid < 0) {
    1c56:	02054a63          	bltz	a0,1c8a <forkfork+0x56>
    if (pid == 0) {
    1c5a:	c531                	beqz	a0,1ca6 <forkfork+0x72>
    wait(&xstatus);
    1c5c:	fdc40513          	addi	a0,s0,-36
    1c60:	00004097          	auipc	ra,0x4
    1c64:	e88080e7          	jalr	-376(ra) # 5ae8 <wait>
    if (xstatus != 0) {
    1c68:	fdc42783          	lw	a5,-36(s0)
    1c6c:	ebbd                	bnez	a5,1ce2 <forkfork+0xae>
    wait(&xstatus);
    1c6e:	fdc40513          	addi	a0,s0,-36
    1c72:	00004097          	auipc	ra,0x4
    1c76:	e76080e7          	jalr	-394(ra) # 5ae8 <wait>
    if (xstatus != 0) {
    1c7a:	fdc42783          	lw	a5,-36(s0)
    1c7e:	e3b5                	bnez	a5,1ce2 <forkfork+0xae>
}
    1c80:	70a2                	ld	ra,40(sp)
    1c82:	7402                	ld	s0,32(sp)
    1c84:	64e2                	ld	s1,24(sp)
    1c86:	6145                	addi	sp,sp,48
    1c88:	8082                	ret
      printf("%s: fork failed", s);
    1c8a:	85a6                	mv	a1,s1
    1c8c:	00005517          	auipc	a0,0x5
    1c90:	e0450513          	addi	a0,a0,-508 # 6a90 <malloc+0xb7e>
    1c94:	00004097          	auipc	ra,0x4
    1c98:	1c6080e7          	jalr	454(ra) # 5e5a <printf>
      exit(1);
    1c9c:	4505                	li	a0,1
    1c9e:	00004097          	auipc	ra,0x4
    1ca2:	e42080e7          	jalr	-446(ra) # 5ae0 <exit>
void forkfork(char *s) {
    1ca6:	0c800493          	li	s1,200
        int pid1 = fork();
    1caa:	00004097          	auipc	ra,0x4
    1cae:	e2e080e7          	jalr	-466(ra) # 5ad8 <fork>
        if (pid1 < 0) {
    1cb2:	00054f63          	bltz	a0,1cd0 <forkfork+0x9c>
        if (pid1 == 0) {
    1cb6:	c115                	beqz	a0,1cda <forkfork+0xa6>
        wait(0);
    1cb8:	4501                	li	a0,0
    1cba:	00004097          	auipc	ra,0x4
    1cbe:	e2e080e7          	jalr	-466(ra) # 5ae8 <wait>
      for (int j = 0; j < 200; j++) {
    1cc2:	34fd                	addiw	s1,s1,-1
    1cc4:	f0fd                	bnez	s1,1caa <forkfork+0x76>
      exit(0);
    1cc6:	4501                	li	a0,0
    1cc8:	00004097          	auipc	ra,0x4
    1ccc:	e18080e7          	jalr	-488(ra) # 5ae0 <exit>
          exit(1);
    1cd0:	4505                	li	a0,1
    1cd2:	00004097          	auipc	ra,0x4
    1cd6:	e0e080e7          	jalr	-498(ra) # 5ae0 <exit>
          exit(0);
    1cda:	00004097          	auipc	ra,0x4
    1cde:	e06080e7          	jalr	-506(ra) # 5ae0 <exit>
      printf("%s: fork in child failed", s);
    1ce2:	85a6                	mv	a1,s1
    1ce4:	00005517          	auipc	a0,0x5
    1ce8:	dbc50513          	addi	a0,a0,-580 # 6aa0 <malloc+0xb8e>
    1cec:	00004097          	auipc	ra,0x4
    1cf0:	16e080e7          	jalr	366(ra) # 5e5a <printf>
      exit(1);
    1cf4:	4505                	li	a0,1
    1cf6:	00004097          	auipc	ra,0x4
    1cfa:	dea080e7          	jalr	-534(ra) # 5ae0 <exit>

0000000000001cfe <reparent2>:
void reparent2(char *s) {
    1cfe:	1101                	addi	sp,sp,-32
    1d00:	ec06                	sd	ra,24(sp)
    1d02:	e822                	sd	s0,16(sp)
    1d04:	e426                	sd	s1,8(sp)
    1d06:	1000                	addi	s0,sp,32
    1d08:	32000493          	li	s1,800
    int pid1 = fork();
    1d0c:	00004097          	auipc	ra,0x4
    1d10:	dcc080e7          	jalr	-564(ra) # 5ad8 <fork>
    if (pid1 < 0) {
    1d14:	00054f63          	bltz	a0,1d32 <reparent2+0x34>
    if (pid1 == 0) {
    1d18:	c915                	beqz	a0,1d4c <reparent2+0x4e>
    wait(0);
    1d1a:	4501                	li	a0,0
    1d1c:	00004097          	auipc	ra,0x4
    1d20:	dcc080e7          	jalr	-564(ra) # 5ae8 <wait>
  for (int i = 0; i < 800; i++) {
    1d24:	34fd                	addiw	s1,s1,-1
    1d26:	f0fd                	bnez	s1,1d0c <reparent2+0xe>
  exit(0);
    1d28:	4501                	li	a0,0
    1d2a:	00004097          	auipc	ra,0x4
    1d2e:	db6080e7          	jalr	-586(ra) # 5ae0 <exit>
      printf("fork failed\n");
    1d32:	00005517          	auipc	a0,0x5
    1d36:	f3650513          	addi	a0,a0,-202 # 6c68 <malloc+0xd56>
    1d3a:	00004097          	auipc	ra,0x4
    1d3e:	120080e7          	jalr	288(ra) # 5e5a <printf>
      exit(1);
    1d42:	4505                	li	a0,1
    1d44:	00004097          	auipc	ra,0x4
    1d48:	d9c080e7          	jalr	-612(ra) # 5ae0 <exit>
      fork();
    1d4c:	00004097          	auipc	ra,0x4
    1d50:	d8c080e7          	jalr	-628(ra) # 5ad8 <fork>
      fork();
    1d54:	00004097          	auipc	ra,0x4
    1d58:	d84080e7          	jalr	-636(ra) # 5ad8 <fork>
      exit(0);
    1d5c:	4501                	li	a0,0
    1d5e:	00004097          	auipc	ra,0x4
    1d62:	d82080e7          	jalr	-638(ra) # 5ae0 <exit>

0000000000001d66 <createdelete>:
void createdelete(char *s) {
    1d66:	7175                	addi	sp,sp,-144
    1d68:	e506                	sd	ra,136(sp)
    1d6a:	e122                	sd	s0,128(sp)
    1d6c:	fca6                	sd	s1,120(sp)
    1d6e:	f8ca                	sd	s2,112(sp)
    1d70:	f4ce                	sd	s3,104(sp)
    1d72:	f0d2                	sd	s4,96(sp)
    1d74:	ecd6                	sd	s5,88(sp)
    1d76:	e8da                	sd	s6,80(sp)
    1d78:	e4de                	sd	s7,72(sp)
    1d7a:	e0e2                	sd	s8,64(sp)
    1d7c:	fc66                	sd	s9,56(sp)
    1d7e:	0900                	addi	s0,sp,144
    1d80:	8caa                	mv	s9,a0
  for (pi = 0; pi < NCHILD; pi++) {
    1d82:	4901                	li	s2,0
    1d84:	4991                	li	s3,4
    pid = fork();
    1d86:	00004097          	auipc	ra,0x4
    1d8a:	d52080e7          	jalr	-686(ra) # 5ad8 <fork>
    1d8e:	84aa                	mv	s1,a0
    if (pid < 0) {
    1d90:	02054f63          	bltz	a0,1dce <createdelete+0x68>
    if (pid == 0) {
    1d94:	c939                	beqz	a0,1dea <createdelete+0x84>
  for (pi = 0; pi < NCHILD; pi++) {
    1d96:	2905                	addiw	s2,s2,1
    1d98:	ff3917e3          	bne	s2,s3,1d86 <createdelete+0x20>
    1d9c:	4491                	li	s1,4
    wait(&xstatus);
    1d9e:	f7c40513          	addi	a0,s0,-132
    1da2:	00004097          	auipc	ra,0x4
    1da6:	d46080e7          	jalr	-698(ra) # 5ae8 <wait>
    if (xstatus != 0) exit(1);
    1daa:	f7c42903          	lw	s2,-132(s0)
    1dae:	0e091263          	bnez	s2,1e92 <createdelete+0x12c>
  for (pi = 0; pi < NCHILD; pi++) {
    1db2:	34fd                	addiw	s1,s1,-1
    1db4:	f4ed                	bnez	s1,1d9e <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1db6:	f8040123          	sb	zero,-126(s0)
    1dba:	03000993          	li	s3,48
    1dbe:	5a7d                	li	s4,-1
    1dc0:	07000c13          	li	s8,112
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1dc4:	4b21                	li	s6,8
      if ((i == 0 || i >= N / 2) && fd < 0) {
    1dc6:	4ba5                	li	s7,9
    for (pi = 0; pi < NCHILD; pi++) {
    1dc8:	07400a93          	li	s5,116
    1dcc:	a29d                	j	1f32 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1dce:	85e6                	mv	a1,s9
    1dd0:	00005517          	auipc	a0,0x5
    1dd4:	e9850513          	addi	a0,a0,-360 # 6c68 <malloc+0xd56>
    1dd8:	00004097          	auipc	ra,0x4
    1ddc:	082080e7          	jalr	130(ra) # 5e5a <printf>
      exit(1);
    1de0:	4505                	li	a0,1
    1de2:	00004097          	auipc	ra,0x4
    1de6:	cfe080e7          	jalr	-770(ra) # 5ae0 <exit>
      name[0] = 'p' + pi;
    1dea:	0709091b          	addiw	s2,s2,112
    1dee:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1df2:	f8040123          	sb	zero,-126(s0)
      for (i = 0; i < N; i++) {
    1df6:	4951                	li	s2,20
    1df8:	a015                	j	1e1c <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1dfa:	85e6                	mv	a1,s9
    1dfc:	00005517          	auipc	a0,0x5
    1e00:	b6c50513          	addi	a0,a0,-1172 # 6968 <malloc+0xa56>
    1e04:	00004097          	auipc	ra,0x4
    1e08:	056080e7          	jalr	86(ra) # 5e5a <printf>
          exit(1);
    1e0c:	4505                	li	a0,1
    1e0e:	00004097          	auipc	ra,0x4
    1e12:	cd2080e7          	jalr	-814(ra) # 5ae0 <exit>
      for (i = 0; i < N; i++) {
    1e16:	2485                	addiw	s1,s1,1
    1e18:	07248863          	beq	s1,s2,1e88 <createdelete+0x122>
        name[1] = '0' + i;
    1e1c:	0304879b          	addiw	a5,s1,48
    1e20:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e24:	20200593          	li	a1,514
    1e28:	f8040513          	addi	a0,s0,-128
    1e2c:	00004097          	auipc	ra,0x4
    1e30:	cf4080e7          	jalr	-780(ra) # 5b20 <open>
        if (fd < 0) {
    1e34:	fc0543e3          	bltz	a0,1dfa <createdelete+0x94>
        close(fd);
    1e38:	00004097          	auipc	ra,0x4
    1e3c:	cd0080e7          	jalr	-816(ra) # 5b08 <close>
        if (i > 0 && (i % 2) == 0) {
    1e40:	fc905be3          	blez	s1,1e16 <createdelete+0xb0>
    1e44:	0014f793          	andi	a5,s1,1
    1e48:	f7f9                	bnez	a5,1e16 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1e4a:	01f4d79b          	srliw	a5,s1,0x1f
    1e4e:	9fa5                	addw	a5,a5,s1
    1e50:	4017d79b          	sraiw	a5,a5,0x1
    1e54:	0307879b          	addiw	a5,a5,48
    1e58:	f8f400a3          	sb	a5,-127(s0)
          if (unlink(name) < 0) {
    1e5c:	f8040513          	addi	a0,s0,-128
    1e60:	00004097          	auipc	ra,0x4
    1e64:	cd0080e7          	jalr	-816(ra) # 5b30 <unlink>
    1e68:	fa0557e3          	bgez	a0,1e16 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1e6c:	85e6                	mv	a1,s9
    1e6e:	00005517          	auipc	a0,0x5
    1e72:	c5250513          	addi	a0,a0,-942 # 6ac0 <malloc+0xbae>
    1e76:	00004097          	auipc	ra,0x4
    1e7a:	fe4080e7          	jalr	-28(ra) # 5e5a <printf>
            exit(1);
    1e7e:	4505                	li	a0,1
    1e80:	00004097          	auipc	ra,0x4
    1e84:	c60080e7          	jalr	-928(ra) # 5ae0 <exit>
      exit(0);
    1e88:	4501                	li	a0,0
    1e8a:	00004097          	auipc	ra,0x4
    1e8e:	c56080e7          	jalr	-938(ra) # 5ae0 <exit>
    if (xstatus != 0) exit(1);
    1e92:	4505                	li	a0,1
    1e94:	00004097          	auipc	ra,0x4
    1e98:	c4c080e7          	jalr	-948(ra) # 5ae0 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1e9c:	f8040613          	addi	a2,s0,-128
    1ea0:	85e6                	mv	a1,s9
    1ea2:	00005517          	auipc	a0,0x5
    1ea6:	c3650513          	addi	a0,a0,-970 # 6ad8 <malloc+0xbc6>
    1eaa:	00004097          	auipc	ra,0x4
    1eae:	fb0080e7          	jalr	-80(ra) # 5e5a <printf>
        exit(1);
    1eb2:	4505                	li	a0,1
    1eb4:	00004097          	auipc	ra,0x4
    1eb8:	c2c080e7          	jalr	-980(ra) # 5ae0 <exit>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1ebc:	054b7163          	bgeu	s6,s4,1efe <createdelete+0x198>
      if (fd >= 0) close(fd);
    1ec0:	02055a63          	bgez	a0,1ef4 <createdelete+0x18e>
    for (pi = 0; pi < NCHILD; pi++) {
    1ec4:	2485                	addiw	s1,s1,1
    1ec6:	0ff4f493          	zext.b	s1,s1
    1eca:	05548c63          	beq	s1,s5,1f22 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1ece:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1ed2:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1ed6:	4581                	li	a1,0
    1ed8:	f8040513          	addi	a0,s0,-128
    1edc:	00004097          	auipc	ra,0x4
    1ee0:	c44080e7          	jalr	-956(ra) # 5b20 <open>
      if ((i == 0 || i >= N / 2) && fd < 0) {
    1ee4:	00090463          	beqz	s2,1eec <createdelete+0x186>
    1ee8:	fd2bdae3          	bge	s7,s2,1ebc <createdelete+0x156>
    1eec:	fa0548e3          	bltz	a0,1e9c <createdelete+0x136>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1ef0:	014b7963          	bgeu	s6,s4,1f02 <createdelete+0x19c>
      if (fd >= 0) close(fd);
    1ef4:	00004097          	auipc	ra,0x4
    1ef8:	c14080e7          	jalr	-1004(ra) # 5b08 <close>
    1efc:	b7e1                	j	1ec4 <createdelete+0x15e>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1efe:	fc0543e3          	bltz	a0,1ec4 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f02:	f8040613          	addi	a2,s0,-128
    1f06:	85e6                	mv	a1,s9
    1f08:	00005517          	auipc	a0,0x5
    1f0c:	bf850513          	addi	a0,a0,-1032 # 6b00 <malloc+0xbee>
    1f10:	00004097          	auipc	ra,0x4
    1f14:	f4a080e7          	jalr	-182(ra) # 5e5a <printf>
        exit(1);
    1f18:	4505                	li	a0,1
    1f1a:	00004097          	auipc	ra,0x4
    1f1e:	bc6080e7          	jalr	-1082(ra) # 5ae0 <exit>
  for (i = 0; i < N; i++) {
    1f22:	2905                	addiw	s2,s2,1
    1f24:	2a05                	addiw	s4,s4,1
    1f26:	2985                	addiw	s3,s3,1
    1f28:	0ff9f993          	zext.b	s3,s3
    1f2c:	47d1                	li	a5,20
    1f2e:	02f90a63          	beq	s2,a5,1f62 <createdelete+0x1fc>
    for (pi = 0; pi < NCHILD; pi++) {
    1f32:	84e2                	mv	s1,s8
    1f34:	bf69                	j	1ece <createdelete+0x168>
  for (i = 0; i < N; i++) {
    1f36:	2905                	addiw	s2,s2,1
    1f38:	0ff97913          	zext.b	s2,s2
    1f3c:	2985                	addiw	s3,s3,1
    1f3e:	0ff9f993          	zext.b	s3,s3
    1f42:	03490863          	beq	s2,s4,1f72 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1f46:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1f48:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1f4c:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1f50:	f8040513          	addi	a0,s0,-128
    1f54:	00004097          	auipc	ra,0x4
    1f58:	bdc080e7          	jalr	-1060(ra) # 5b30 <unlink>
    for (pi = 0; pi < NCHILD; pi++) {
    1f5c:	34fd                	addiw	s1,s1,-1
    1f5e:	f4ed                	bnez	s1,1f48 <createdelete+0x1e2>
    1f60:	bfd9                	j	1f36 <createdelete+0x1d0>
    1f62:	03000993          	li	s3,48
    1f66:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1f6a:	4a91                	li	s5,4
  for (i = 0; i < N; i++) {
    1f6c:	08400a13          	li	s4,132
    1f70:	bfd9                	j	1f46 <createdelete+0x1e0>
}
    1f72:	60aa                	ld	ra,136(sp)
    1f74:	640a                	ld	s0,128(sp)
    1f76:	74e6                	ld	s1,120(sp)
    1f78:	7946                	ld	s2,112(sp)
    1f7a:	79a6                	ld	s3,104(sp)
    1f7c:	7a06                	ld	s4,96(sp)
    1f7e:	6ae6                	ld	s5,88(sp)
    1f80:	6b46                	ld	s6,80(sp)
    1f82:	6ba6                	ld	s7,72(sp)
    1f84:	6c06                	ld	s8,64(sp)
    1f86:	7ce2                	ld	s9,56(sp)
    1f88:	6149                	addi	sp,sp,144
    1f8a:	8082                	ret

0000000000001f8c <linkunlink>:
void linkunlink(char *s) {
    1f8c:	711d                	addi	sp,sp,-96
    1f8e:	ec86                	sd	ra,88(sp)
    1f90:	e8a2                	sd	s0,80(sp)
    1f92:	e4a6                	sd	s1,72(sp)
    1f94:	e0ca                	sd	s2,64(sp)
    1f96:	fc4e                	sd	s3,56(sp)
    1f98:	f852                	sd	s4,48(sp)
    1f9a:	f456                	sd	s5,40(sp)
    1f9c:	f05a                	sd	s6,32(sp)
    1f9e:	ec5e                	sd	s7,24(sp)
    1fa0:	e862                	sd	s8,16(sp)
    1fa2:	e466                	sd	s9,8(sp)
    1fa4:	1080                	addi	s0,sp,96
    1fa6:	84aa                	mv	s1,a0
  unlink("x");
    1fa8:	00004517          	auipc	a0,0x4
    1fac:	10050513          	addi	a0,a0,256 # 60a8 <malloc+0x196>
    1fb0:	00004097          	auipc	ra,0x4
    1fb4:	b80080e7          	jalr	-1152(ra) # 5b30 <unlink>
  pid = fork();
    1fb8:	00004097          	auipc	ra,0x4
    1fbc:	b20080e7          	jalr	-1248(ra) # 5ad8 <fork>
  if (pid < 0) {
    1fc0:	02054b63          	bltz	a0,1ff6 <linkunlink+0x6a>
    1fc4:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1fc6:	4c85                	li	s9,1
    1fc8:	e119                	bnez	a0,1fce <linkunlink+0x42>
    1fca:	06100c93          	li	s9,97
    1fce:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1fd2:	41c659b7          	lui	s3,0x41c65
    1fd6:	e6d9899b          	addiw	s3,s3,-403 # 41c64e6d <base+0x41c55205>
    1fda:	690d                	lui	s2,0x3
    1fdc:	0399091b          	addiw	s2,s2,57 # 3039 <fourteen+0xfb>
    if ((x % 3) == 0) {
    1fe0:	4a0d                	li	s4,3
    } else if ((x % 3) == 1) {
    1fe2:	4b05                	li	s6,1
      unlink("x");
    1fe4:	00004a97          	auipc	s5,0x4
    1fe8:	0c4a8a93          	addi	s5,s5,196 # 60a8 <malloc+0x196>
      link("cat", "x");
    1fec:	00005b97          	auipc	s7,0x5
    1ff0:	b3cb8b93          	addi	s7,s7,-1220 # 6b28 <malloc+0xc16>
    1ff4:	a825                	j	202c <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1ff6:	85a6                	mv	a1,s1
    1ff8:	00005517          	auipc	a0,0x5
    1ffc:	8d850513          	addi	a0,a0,-1832 # 68d0 <malloc+0x9be>
    2000:	00004097          	auipc	ra,0x4
    2004:	e5a080e7          	jalr	-422(ra) # 5e5a <printf>
    exit(1);
    2008:	4505                	li	a0,1
    200a:	00004097          	auipc	ra,0x4
    200e:	ad6080e7          	jalr	-1322(ra) # 5ae0 <exit>
      close(open("x", O_RDWR | O_CREATE));
    2012:	20200593          	li	a1,514
    2016:	8556                	mv	a0,s5
    2018:	00004097          	auipc	ra,0x4
    201c:	b08080e7          	jalr	-1272(ra) # 5b20 <open>
    2020:	00004097          	auipc	ra,0x4
    2024:	ae8080e7          	jalr	-1304(ra) # 5b08 <close>
  for (i = 0; i < 100; i++) {
    2028:	34fd                	addiw	s1,s1,-1
    202a:	c88d                	beqz	s1,205c <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    202c:	033c87bb          	mulw	a5,s9,s3
    2030:	012787bb          	addw	a5,a5,s2
    2034:	00078c9b          	sext.w	s9,a5
    if ((x % 3) == 0) {
    2038:	0347f7bb          	remuw	a5,a5,s4
    203c:	dbf9                	beqz	a5,2012 <linkunlink+0x86>
    } else if ((x % 3) == 1) {
    203e:	01678863          	beq	a5,s6,204e <linkunlink+0xc2>
      unlink("x");
    2042:	8556                	mv	a0,s5
    2044:	00004097          	auipc	ra,0x4
    2048:	aec080e7          	jalr	-1300(ra) # 5b30 <unlink>
    204c:	bff1                	j	2028 <linkunlink+0x9c>
      link("cat", "x");
    204e:	85d6                	mv	a1,s5
    2050:	855e                	mv	a0,s7
    2052:	00004097          	auipc	ra,0x4
    2056:	aee080e7          	jalr	-1298(ra) # 5b40 <link>
    205a:	b7f9                	j	2028 <linkunlink+0x9c>
  if (pid)
    205c:	020c0463          	beqz	s8,2084 <linkunlink+0xf8>
    wait(0);
    2060:	4501                	li	a0,0
    2062:	00004097          	auipc	ra,0x4
    2066:	a86080e7          	jalr	-1402(ra) # 5ae8 <wait>
}
    206a:	60e6                	ld	ra,88(sp)
    206c:	6446                	ld	s0,80(sp)
    206e:	64a6                	ld	s1,72(sp)
    2070:	6906                	ld	s2,64(sp)
    2072:	79e2                	ld	s3,56(sp)
    2074:	7a42                	ld	s4,48(sp)
    2076:	7aa2                	ld	s5,40(sp)
    2078:	7b02                	ld	s6,32(sp)
    207a:	6be2                	ld	s7,24(sp)
    207c:	6c42                	ld	s8,16(sp)
    207e:	6ca2                	ld	s9,8(sp)
    2080:	6125                	addi	sp,sp,96
    2082:	8082                	ret
    exit(0);
    2084:	4501                	li	a0,0
    2086:	00004097          	auipc	ra,0x4
    208a:	a5a080e7          	jalr	-1446(ra) # 5ae0 <exit>

000000000000208e <kernmem>:
void kernmem(char *s) {
    208e:	715d                	addi	sp,sp,-80
    2090:	e486                	sd	ra,72(sp)
    2092:	e0a2                	sd	s0,64(sp)
    2094:	fc26                	sd	s1,56(sp)
    2096:	f84a                	sd	s2,48(sp)
    2098:	f44e                	sd	s3,40(sp)
    209a:	f052                	sd	s4,32(sp)
    209c:	ec56                	sd	s5,24(sp)
    209e:	0880                	addi	s0,sp,80
    20a0:	8a2a                	mv	s4,a0
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    20a2:	4485                	li	s1,1
    20a4:	04fe                	slli	s1,s1,0x1f
    if (xstatus != -1)  // did kernel kill child?
    20a6:	5afd                	li	s5,-1
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    20a8:	69b1                	lui	s3,0xc
    20aa:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1df8>
    20ae:	1003d937          	lui	s2,0x1003d
    20b2:	090e                	slli	s2,s2,0x3
    20b4:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d818>
    pid = fork();
    20b8:	00004097          	auipc	ra,0x4
    20bc:	a20080e7          	jalr	-1504(ra) # 5ad8 <fork>
    if (pid < 0) {
    20c0:	02054963          	bltz	a0,20f2 <kernmem+0x64>
    if (pid == 0) {
    20c4:	c529                	beqz	a0,210e <kernmem+0x80>
    wait(&xstatus);
    20c6:	fbc40513          	addi	a0,s0,-68
    20ca:	00004097          	auipc	ra,0x4
    20ce:	a1e080e7          	jalr	-1506(ra) # 5ae8 <wait>
    if (xstatus != -1)  // did kernel kill child?
    20d2:	fbc42783          	lw	a5,-68(s0)
    20d6:	05579d63          	bne	a5,s5,2130 <kernmem+0xa2>
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    20da:	94ce                	add	s1,s1,s3
    20dc:	fd249ee3          	bne	s1,s2,20b8 <kernmem+0x2a>
}
    20e0:	60a6                	ld	ra,72(sp)
    20e2:	6406                	ld	s0,64(sp)
    20e4:	74e2                	ld	s1,56(sp)
    20e6:	7942                	ld	s2,48(sp)
    20e8:	79a2                	ld	s3,40(sp)
    20ea:	7a02                	ld	s4,32(sp)
    20ec:	6ae2                	ld	s5,24(sp)
    20ee:	6161                	addi	sp,sp,80
    20f0:	8082                	ret
      printf("%s: fork failed\n", s);
    20f2:	85d2                	mv	a1,s4
    20f4:	00004517          	auipc	a0,0x4
    20f8:	7dc50513          	addi	a0,a0,2012 # 68d0 <malloc+0x9be>
    20fc:	00004097          	auipc	ra,0x4
    2100:	d5e080e7          	jalr	-674(ra) # 5e5a <printf>
      exit(1);
    2104:	4505                	li	a0,1
    2106:	00004097          	auipc	ra,0x4
    210a:	9da080e7          	jalr	-1574(ra) # 5ae0 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    210e:	0004c683          	lbu	a3,0(s1)
    2112:	8626                	mv	a2,s1
    2114:	85d2                	mv	a1,s4
    2116:	00005517          	auipc	a0,0x5
    211a:	a1a50513          	addi	a0,a0,-1510 # 6b30 <malloc+0xc1e>
    211e:	00004097          	auipc	ra,0x4
    2122:	d3c080e7          	jalr	-708(ra) # 5e5a <printf>
      exit(1);
    2126:	4505                	li	a0,1
    2128:	00004097          	auipc	ra,0x4
    212c:	9b8080e7          	jalr	-1608(ra) # 5ae0 <exit>
      exit(1);
    2130:	4505                	li	a0,1
    2132:	00004097          	auipc	ra,0x4
    2136:	9ae080e7          	jalr	-1618(ra) # 5ae0 <exit>

000000000000213a <MAXVAplus>:
void MAXVAplus(char *s) {
    213a:	7179                	addi	sp,sp,-48
    213c:	f406                	sd	ra,40(sp)
    213e:	f022                	sd	s0,32(sp)
    2140:	ec26                	sd	s1,24(sp)
    2142:	e84a                	sd	s2,16(sp)
    2144:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    2146:	4785                	li	a5,1
    2148:	179a                	slli	a5,a5,0x26
    214a:	fcf43c23          	sd	a5,-40(s0)
  for (; a != 0; a <<= 1) {
    214e:	fd843783          	ld	a5,-40(s0)
    2152:	cf85                	beqz	a5,218a <MAXVAplus+0x50>
    2154:	892a                	mv	s2,a0
    if (xstatus != -1)  // did kernel kill child?
    2156:	54fd                	li	s1,-1
    pid = fork();
    2158:	00004097          	auipc	ra,0x4
    215c:	980080e7          	jalr	-1664(ra) # 5ad8 <fork>
    if (pid < 0) {
    2160:	02054b63          	bltz	a0,2196 <MAXVAplus+0x5c>
    if (pid == 0) {
    2164:	c539                	beqz	a0,21b2 <MAXVAplus+0x78>
    wait(&xstatus);
    2166:	fd440513          	addi	a0,s0,-44
    216a:	00004097          	auipc	ra,0x4
    216e:	97e080e7          	jalr	-1666(ra) # 5ae8 <wait>
    if (xstatus != -1)  // did kernel kill child?
    2172:	fd442783          	lw	a5,-44(s0)
    2176:	06979463          	bne	a5,s1,21de <MAXVAplus+0xa4>
  for (; a != 0; a <<= 1) {
    217a:	fd843783          	ld	a5,-40(s0)
    217e:	0786                	slli	a5,a5,0x1
    2180:	fcf43c23          	sd	a5,-40(s0)
    2184:	fd843783          	ld	a5,-40(s0)
    2188:	fbe1                	bnez	a5,2158 <MAXVAplus+0x1e>
}
    218a:	70a2                	ld	ra,40(sp)
    218c:	7402                	ld	s0,32(sp)
    218e:	64e2                	ld	s1,24(sp)
    2190:	6942                	ld	s2,16(sp)
    2192:	6145                	addi	sp,sp,48
    2194:	8082                	ret
      printf("%s: fork failed\n", s);
    2196:	85ca                	mv	a1,s2
    2198:	00004517          	auipc	a0,0x4
    219c:	73850513          	addi	a0,a0,1848 # 68d0 <malloc+0x9be>
    21a0:	00004097          	auipc	ra,0x4
    21a4:	cba080e7          	jalr	-838(ra) # 5e5a <printf>
      exit(1);
    21a8:	4505                	li	a0,1
    21aa:	00004097          	auipc	ra,0x4
    21ae:	936080e7          	jalr	-1738(ra) # 5ae0 <exit>
      *(char *)a = 99;
    21b2:	fd843783          	ld	a5,-40(s0)
    21b6:	06300713          	li	a4,99
    21ba:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    21be:	fd843603          	ld	a2,-40(s0)
    21c2:	85ca                	mv	a1,s2
    21c4:	00005517          	auipc	a0,0x5
    21c8:	98c50513          	addi	a0,a0,-1652 # 6b50 <malloc+0xc3e>
    21cc:	00004097          	auipc	ra,0x4
    21d0:	c8e080e7          	jalr	-882(ra) # 5e5a <printf>
      exit(1);
    21d4:	4505                	li	a0,1
    21d6:	00004097          	auipc	ra,0x4
    21da:	90a080e7          	jalr	-1782(ra) # 5ae0 <exit>
      exit(1);
    21de:	4505                	li	a0,1
    21e0:	00004097          	auipc	ra,0x4
    21e4:	900080e7          	jalr	-1792(ra) # 5ae0 <exit>

00000000000021e8 <bigargtest>:
void bigargtest(char *s) {
    21e8:	7179                	addi	sp,sp,-48
    21ea:	f406                	sd	ra,40(sp)
    21ec:	f022                	sd	s0,32(sp)
    21ee:	ec26                	sd	s1,24(sp)
    21f0:	1800                	addi	s0,sp,48
    21f2:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    21f4:	00005517          	auipc	a0,0x5
    21f8:	97450513          	addi	a0,a0,-1676 # 6b68 <malloc+0xc56>
    21fc:	00004097          	auipc	ra,0x4
    2200:	934080e7          	jalr	-1740(ra) # 5b30 <unlink>
  pid = fork();
    2204:	00004097          	auipc	ra,0x4
    2208:	8d4080e7          	jalr	-1836(ra) # 5ad8 <fork>
  if (pid == 0) {
    220c:	c121                	beqz	a0,224c <bigargtest+0x64>
  } else if (pid < 0) {
    220e:	0a054063          	bltz	a0,22ae <bigargtest+0xc6>
  wait(&xstatus);
    2212:	fdc40513          	addi	a0,s0,-36
    2216:	00004097          	auipc	ra,0x4
    221a:	8d2080e7          	jalr	-1838(ra) # 5ae8 <wait>
  if (xstatus != 0) exit(xstatus);
    221e:	fdc42503          	lw	a0,-36(s0)
    2222:	e545                	bnez	a0,22ca <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    2224:	4581                	li	a1,0
    2226:	00005517          	auipc	a0,0x5
    222a:	94250513          	addi	a0,a0,-1726 # 6b68 <malloc+0xc56>
    222e:	00004097          	auipc	ra,0x4
    2232:	8f2080e7          	jalr	-1806(ra) # 5b20 <open>
  if (fd < 0) {
    2236:	08054e63          	bltz	a0,22d2 <bigargtest+0xea>
  close(fd);
    223a:	00004097          	auipc	ra,0x4
    223e:	8ce080e7          	jalr	-1842(ra) # 5b08 <close>
}
    2242:	70a2                	ld	ra,40(sp)
    2244:	7402                	ld	s0,32(sp)
    2246:	64e2                	ld	s1,24(sp)
    2248:	6145                	addi	sp,sp,48
    224a:	8082                	ret
    224c:	00007797          	auipc	a5,0x7
    2250:	20478793          	addi	a5,a5,516 # 9450 <args.1>
    2254:	00007697          	auipc	a3,0x7
    2258:	2f468693          	addi	a3,a3,756 # 9548 <args.1+0xf8>
      args[i] =
    225c:	00005717          	auipc	a4,0x5
    2260:	91c70713          	addi	a4,a4,-1764 # 6b78 <malloc+0xc66>
    2264:	e398                	sd	a4,0(a5)
    for (i = 0; i < MAXARG - 1; i++)
    2266:	07a1                	addi	a5,a5,8
    2268:	fed79ee3          	bne	a5,a3,2264 <bigargtest+0x7c>
    args[MAXARG - 1] = 0;
    226c:	00007597          	auipc	a1,0x7
    2270:	1e458593          	addi	a1,a1,484 # 9450 <args.1>
    2274:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2278:	00004517          	auipc	a0,0x4
    227c:	dc050513          	addi	a0,a0,-576 # 6038 <malloc+0x126>
    2280:	00004097          	auipc	ra,0x4
    2284:	898080e7          	jalr	-1896(ra) # 5b18 <exec>
    fd = open("bigarg-ok", O_CREATE);
    2288:	20000593          	li	a1,512
    228c:	00005517          	auipc	a0,0x5
    2290:	8dc50513          	addi	a0,a0,-1828 # 6b68 <malloc+0xc56>
    2294:	00004097          	auipc	ra,0x4
    2298:	88c080e7          	jalr	-1908(ra) # 5b20 <open>
    close(fd);
    229c:	00004097          	auipc	ra,0x4
    22a0:	86c080e7          	jalr	-1940(ra) # 5b08 <close>
    exit(0);
    22a4:	4501                	li	a0,0
    22a6:	00004097          	auipc	ra,0x4
    22aa:	83a080e7          	jalr	-1990(ra) # 5ae0 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    22ae:	85a6                	mv	a1,s1
    22b0:	00005517          	auipc	a0,0x5
    22b4:	9a850513          	addi	a0,a0,-1624 # 6c58 <malloc+0xd46>
    22b8:	00004097          	auipc	ra,0x4
    22bc:	ba2080e7          	jalr	-1118(ra) # 5e5a <printf>
    exit(1);
    22c0:	4505                	li	a0,1
    22c2:	00004097          	auipc	ra,0x4
    22c6:	81e080e7          	jalr	-2018(ra) # 5ae0 <exit>
  if (xstatus != 0) exit(xstatus);
    22ca:	00004097          	auipc	ra,0x4
    22ce:	816080e7          	jalr	-2026(ra) # 5ae0 <exit>
    printf("%s: bigarg test failed!\n", s);
    22d2:	85a6                	mv	a1,s1
    22d4:	00005517          	auipc	a0,0x5
    22d8:	9a450513          	addi	a0,a0,-1628 # 6c78 <malloc+0xd66>
    22dc:	00004097          	auipc	ra,0x4
    22e0:	b7e080e7          	jalr	-1154(ra) # 5e5a <printf>
    exit(1);
    22e4:	4505                	li	a0,1
    22e6:	00003097          	auipc	ra,0x3
    22ea:	7fa080e7          	jalr	2042(ra) # 5ae0 <exit>

00000000000022ee <stacktest>:
void stacktest(char *s) {
    22ee:	7179                	addi	sp,sp,-48
    22f0:	f406                	sd	ra,40(sp)
    22f2:	f022                	sd	s0,32(sp)
    22f4:	ec26                	sd	s1,24(sp)
    22f6:	1800                	addi	s0,sp,48
    22f8:	84aa                	mv	s1,a0
  pid = fork();
    22fa:	00003097          	auipc	ra,0x3
    22fe:	7de080e7          	jalr	2014(ra) # 5ad8 <fork>
  if (pid == 0) {
    2302:	c115                	beqz	a0,2326 <stacktest+0x38>
  } else if (pid < 0) {
    2304:	04054463          	bltz	a0,234c <stacktest+0x5e>
  wait(&xstatus);
    2308:	fdc40513          	addi	a0,s0,-36
    230c:	00003097          	auipc	ra,0x3
    2310:	7dc080e7          	jalr	2012(ra) # 5ae8 <wait>
  if (xstatus == -1)  // kernel killed child?
    2314:	fdc42503          	lw	a0,-36(s0)
    2318:	57fd                	li	a5,-1
    231a:	04f50763          	beq	a0,a5,2368 <stacktest+0x7a>
    exit(xstatus);
    231e:	00003097          	auipc	ra,0x3
    2322:	7c2080e7          	jalr	1986(ra) # 5ae0 <exit>
  return (x & SSTATUS_SIE) != 0;
}

static inline uint64 r_sp() {
  uint64 x;
  asm volatile("mv %0, sp" : "=r"(x));
    2326:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2328:	77fd                	lui	a5,0xfffff
    232a:	97ba                	add	a5,a5,a4
    232c:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef398>
    2330:	85a6                	mv	a1,s1
    2332:	00005517          	auipc	a0,0x5
    2336:	96650513          	addi	a0,a0,-1690 # 6c98 <malloc+0xd86>
    233a:	00004097          	auipc	ra,0x4
    233e:	b20080e7          	jalr	-1248(ra) # 5e5a <printf>
    exit(1);
    2342:	4505                	li	a0,1
    2344:	00003097          	auipc	ra,0x3
    2348:	79c080e7          	jalr	1948(ra) # 5ae0 <exit>
    printf("%s: fork failed\n", s);
    234c:	85a6                	mv	a1,s1
    234e:	00004517          	auipc	a0,0x4
    2352:	58250513          	addi	a0,a0,1410 # 68d0 <malloc+0x9be>
    2356:	00004097          	auipc	ra,0x4
    235a:	b04080e7          	jalr	-1276(ra) # 5e5a <printf>
    exit(1);
    235e:	4505                	li	a0,1
    2360:	00003097          	auipc	ra,0x3
    2364:	780080e7          	jalr	1920(ra) # 5ae0 <exit>
    exit(0);
    2368:	4501                	li	a0,0
    236a:	00003097          	auipc	ra,0x3
    236e:	776080e7          	jalr	1910(ra) # 5ae0 <exit>

0000000000002372 <textwrite>:
void textwrite(char *s) {
    2372:	7179                	addi	sp,sp,-48
    2374:	f406                	sd	ra,40(sp)
    2376:	f022                	sd	s0,32(sp)
    2378:	ec26                	sd	s1,24(sp)
    237a:	1800                	addi	s0,sp,48
    237c:	84aa                	mv	s1,a0
  pid = fork();
    237e:	00003097          	auipc	ra,0x3
    2382:	75a080e7          	jalr	1882(ra) # 5ad8 <fork>
  if (pid == 0) {
    2386:	c115                	beqz	a0,23aa <textwrite+0x38>
  } else if (pid < 0) {
    2388:	02054963          	bltz	a0,23ba <textwrite+0x48>
  wait(&xstatus);
    238c:	fdc40513          	addi	a0,s0,-36
    2390:	00003097          	auipc	ra,0x3
    2394:	758080e7          	jalr	1880(ra) # 5ae8 <wait>
  if (xstatus == -1)  // kernel killed child?
    2398:	fdc42503          	lw	a0,-36(s0)
    239c:	57fd                	li	a5,-1
    239e:	02f50c63          	beq	a0,a5,23d6 <textwrite+0x64>
    exit(xstatus);
    23a2:	00003097          	auipc	ra,0x3
    23a6:	73e080e7          	jalr	1854(ra) # 5ae0 <exit>
    *addr = 10;
    23aa:	47a9                	li	a5,10
    23ac:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    23b0:	4505                	li	a0,1
    23b2:	00003097          	auipc	ra,0x3
    23b6:	72e080e7          	jalr	1838(ra) # 5ae0 <exit>
    printf("%s: fork failed\n", s);
    23ba:	85a6                	mv	a1,s1
    23bc:	00004517          	auipc	a0,0x4
    23c0:	51450513          	addi	a0,a0,1300 # 68d0 <malloc+0x9be>
    23c4:	00004097          	auipc	ra,0x4
    23c8:	a96080e7          	jalr	-1386(ra) # 5e5a <printf>
    exit(1);
    23cc:	4505                	li	a0,1
    23ce:	00003097          	auipc	ra,0x3
    23d2:	712080e7          	jalr	1810(ra) # 5ae0 <exit>
    exit(0);
    23d6:	4501                	li	a0,0
    23d8:	00003097          	auipc	ra,0x3
    23dc:	708080e7          	jalr	1800(ra) # 5ae0 <exit>

00000000000023e0 <manywrites>:
void manywrites(char *s) {
    23e0:	711d                	addi	sp,sp,-96
    23e2:	ec86                	sd	ra,88(sp)
    23e4:	e8a2                	sd	s0,80(sp)
    23e6:	e4a6                	sd	s1,72(sp)
    23e8:	e0ca                	sd	s2,64(sp)
    23ea:	fc4e                	sd	s3,56(sp)
    23ec:	f852                	sd	s4,48(sp)
    23ee:	f456                	sd	s5,40(sp)
    23f0:	f05a                	sd	s6,32(sp)
    23f2:	ec5e                	sd	s7,24(sp)
    23f4:	1080                	addi	s0,sp,96
    23f6:	8aaa                	mv	s5,a0
  for (int ci = 0; ci < nchildren; ci++) {
    23f8:	4981                	li	s3,0
    23fa:	4911                	li	s2,4
    int pid = fork();
    23fc:	00003097          	auipc	ra,0x3
    2400:	6dc080e7          	jalr	1756(ra) # 5ad8 <fork>
    2404:	84aa                	mv	s1,a0
    if (pid < 0) {
    2406:	02054963          	bltz	a0,2438 <manywrites+0x58>
    if (pid == 0) {
    240a:	c521                	beqz	a0,2452 <manywrites+0x72>
  for (int ci = 0; ci < nchildren; ci++) {
    240c:	2985                	addiw	s3,s3,1
    240e:	ff2997e3          	bne	s3,s2,23fc <manywrites+0x1c>
    2412:	4491                	li	s1,4
    int st = 0;
    2414:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    2418:	fa840513          	addi	a0,s0,-88
    241c:	00003097          	auipc	ra,0x3
    2420:	6cc080e7          	jalr	1740(ra) # 5ae8 <wait>
    if (st != 0) exit(st);
    2424:	fa842503          	lw	a0,-88(s0)
    2428:	ed6d                	bnez	a0,2522 <manywrites+0x142>
  for (int ci = 0; ci < nchildren; ci++) {
    242a:	34fd                	addiw	s1,s1,-1
    242c:	f4e5                	bnez	s1,2414 <manywrites+0x34>
  exit(0);
    242e:	4501                	li	a0,0
    2430:	00003097          	auipc	ra,0x3
    2434:	6b0080e7          	jalr	1712(ra) # 5ae0 <exit>
      printf("fork failed\n");
    2438:	00005517          	auipc	a0,0x5
    243c:	83050513          	addi	a0,a0,-2000 # 6c68 <malloc+0xd56>
    2440:	00004097          	auipc	ra,0x4
    2444:	a1a080e7          	jalr	-1510(ra) # 5e5a <printf>
      exit(1);
    2448:	4505                	li	a0,1
    244a:	00003097          	auipc	ra,0x3
    244e:	696080e7          	jalr	1686(ra) # 5ae0 <exit>
      name[0] = 'b';
    2452:	06200793          	li	a5,98
    2456:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    245a:	0619879b          	addiw	a5,s3,97
    245e:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    2462:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    2466:	fa840513          	addi	a0,s0,-88
    246a:	00003097          	auipc	ra,0x3
    246e:	6c6080e7          	jalr	1734(ra) # 5b30 <unlink>
    2472:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    2474:	0000ab17          	auipc	s6,0xa
    2478:	7f4b0b13          	addi	s6,s6,2036 # cc68 <buf>
        for (int i = 0; i < ci + 1; i++) {
    247c:	8a26                	mv	s4,s1
    247e:	0209ce63          	bltz	s3,24ba <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    2482:	20200593          	li	a1,514
    2486:	fa840513          	addi	a0,s0,-88
    248a:	00003097          	auipc	ra,0x3
    248e:	696080e7          	jalr	1686(ra) # 5b20 <open>
    2492:	892a                	mv	s2,a0
          if (fd < 0) {
    2494:	04054763          	bltz	a0,24e2 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    2498:	660d                	lui	a2,0x3
    249a:	85da                	mv	a1,s6
    249c:	00003097          	auipc	ra,0x3
    24a0:	664080e7          	jalr	1636(ra) # 5b00 <write>
          if (cc != sz) {
    24a4:	678d                	lui	a5,0x3
    24a6:	04f51e63          	bne	a0,a5,2502 <manywrites+0x122>
          close(fd);
    24aa:	854a                	mv	a0,s2
    24ac:	00003097          	auipc	ra,0x3
    24b0:	65c080e7          	jalr	1628(ra) # 5b08 <close>
        for (int i = 0; i < ci + 1; i++) {
    24b4:	2a05                	addiw	s4,s4,1
    24b6:	fd49d6e3          	bge	s3,s4,2482 <manywrites+0xa2>
        unlink(name);
    24ba:	fa840513          	addi	a0,s0,-88
    24be:	00003097          	auipc	ra,0x3
    24c2:	672080e7          	jalr	1650(ra) # 5b30 <unlink>
      for (int iters = 0; iters < howmany; iters++) {
    24c6:	3bfd                	addiw	s7,s7,-1
    24c8:	fa0b9ae3          	bnez	s7,247c <manywrites+0x9c>
      unlink(name);
    24cc:	fa840513          	addi	a0,s0,-88
    24d0:	00003097          	auipc	ra,0x3
    24d4:	660080e7          	jalr	1632(ra) # 5b30 <unlink>
      exit(0);
    24d8:	4501                	li	a0,0
    24da:	00003097          	auipc	ra,0x3
    24de:	606080e7          	jalr	1542(ra) # 5ae0 <exit>
            printf("%s: cannot create %s\n", s, name);
    24e2:	fa840613          	addi	a2,s0,-88
    24e6:	85d6                	mv	a1,s5
    24e8:	00004517          	auipc	a0,0x4
    24ec:	7d850513          	addi	a0,a0,2008 # 6cc0 <malloc+0xdae>
    24f0:	00004097          	auipc	ra,0x4
    24f4:	96a080e7          	jalr	-1686(ra) # 5e5a <printf>
            exit(1);
    24f8:	4505                	li	a0,1
    24fa:	00003097          	auipc	ra,0x3
    24fe:	5e6080e7          	jalr	1510(ra) # 5ae0 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    2502:	86aa                	mv	a3,a0
    2504:	660d                	lui	a2,0x3
    2506:	85d6                	mv	a1,s5
    2508:	00004517          	auipc	a0,0x4
    250c:	c0050513          	addi	a0,a0,-1024 # 6108 <malloc+0x1f6>
    2510:	00004097          	auipc	ra,0x4
    2514:	94a080e7          	jalr	-1718(ra) # 5e5a <printf>
            exit(1);
    2518:	4505                	li	a0,1
    251a:	00003097          	auipc	ra,0x3
    251e:	5c6080e7          	jalr	1478(ra) # 5ae0 <exit>
    if (st != 0) exit(st);
    2522:	00003097          	auipc	ra,0x3
    2526:	5be080e7          	jalr	1470(ra) # 5ae0 <exit>

000000000000252a <copyinstr3>:
void copyinstr3(char *s) {
    252a:	7179                	addi	sp,sp,-48
    252c:	f406                	sd	ra,40(sp)
    252e:	f022                	sd	s0,32(sp)
    2530:	ec26                	sd	s1,24(sp)
    2532:	1800                	addi	s0,sp,48
  sbrk(8192);
    2534:	6509                	lui	a0,0x2
    2536:	00003097          	auipc	ra,0x3
    253a:	632080e7          	jalr	1586(ra) # 5b68 <sbrk>
  uint64 top = (uint64)sbrk(0);
    253e:	4501                	li	a0,0
    2540:	00003097          	auipc	ra,0x3
    2544:	628080e7          	jalr	1576(ra) # 5b68 <sbrk>
  if ((top % PGSIZE) != 0) {
    2548:	03451793          	slli	a5,a0,0x34
    254c:	e3c9                	bnez	a5,25ce <copyinstr3+0xa4>
  top = (uint64)sbrk(0);
    254e:	4501                	li	a0,0
    2550:	00003097          	auipc	ra,0x3
    2554:	618080e7          	jalr	1560(ra) # 5b68 <sbrk>
  if (top % PGSIZE) {
    2558:	03451793          	slli	a5,a0,0x34
    255c:	e3d9                	bnez	a5,25e2 <copyinstr3+0xb8>
  char *b = (char *)(top - 1);
    255e:	fff50493          	addi	s1,a0,-1 # 1fff <linkunlink+0x73>
  *b = 'x';
    2562:	07800793          	li	a5,120
    2566:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    256a:	8526                	mv	a0,s1
    256c:	00003097          	auipc	ra,0x3
    2570:	5c4080e7          	jalr	1476(ra) # 5b30 <unlink>
  if (ret != -1) {
    2574:	57fd                	li	a5,-1
    2576:	08f51363          	bne	a0,a5,25fc <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    257a:	20100593          	li	a1,513
    257e:	8526                	mv	a0,s1
    2580:	00003097          	auipc	ra,0x3
    2584:	5a0080e7          	jalr	1440(ra) # 5b20 <open>
  if (fd != -1) {
    2588:	57fd                	li	a5,-1
    258a:	08f51863          	bne	a0,a5,261a <copyinstr3+0xf0>
  ret = link(b, b);
    258e:	85a6                	mv	a1,s1
    2590:	8526                	mv	a0,s1
    2592:	00003097          	auipc	ra,0x3
    2596:	5ae080e7          	jalr	1454(ra) # 5b40 <link>
  if (ret != -1) {
    259a:	57fd                	li	a5,-1
    259c:	08f51e63          	bne	a0,a5,2638 <copyinstr3+0x10e>
  char *args[] = {"xx", 0};
    25a0:	00005797          	auipc	a5,0x5
    25a4:	41878793          	addi	a5,a5,1048 # 79b8 <malloc+0x1aa6>
    25a8:	fcf43823          	sd	a5,-48(s0)
    25ac:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    25b0:	fd040593          	addi	a1,s0,-48
    25b4:	8526                	mv	a0,s1
    25b6:	00003097          	auipc	ra,0x3
    25ba:	562080e7          	jalr	1378(ra) # 5b18 <exec>
  if (ret != -1) {
    25be:	57fd                	li	a5,-1
    25c0:	08f51c63          	bne	a0,a5,2658 <copyinstr3+0x12e>
}
    25c4:	70a2                	ld	ra,40(sp)
    25c6:	7402                	ld	s0,32(sp)
    25c8:	64e2                	ld	s1,24(sp)
    25ca:	6145                	addi	sp,sp,48
    25cc:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    25ce:	0347d513          	srli	a0,a5,0x34
    25d2:	6785                	lui	a5,0x1
    25d4:	40a7853b          	subw	a0,a5,a0
    25d8:	00003097          	auipc	ra,0x3
    25dc:	590080e7          	jalr	1424(ra) # 5b68 <sbrk>
    25e0:	b7bd                	j	254e <copyinstr3+0x24>
    printf("oops\n");
    25e2:	00004517          	auipc	a0,0x4
    25e6:	6f650513          	addi	a0,a0,1782 # 6cd8 <malloc+0xdc6>
    25ea:	00004097          	auipc	ra,0x4
    25ee:	870080e7          	jalr	-1936(ra) # 5e5a <printf>
    exit(1);
    25f2:	4505                	li	a0,1
    25f4:	00003097          	auipc	ra,0x3
    25f8:	4ec080e7          	jalr	1260(ra) # 5ae0 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    25fc:	862a                	mv	a2,a0
    25fe:	85a6                	mv	a1,s1
    2600:	00004517          	auipc	a0,0x4
    2604:	1f050513          	addi	a0,a0,496 # 67f0 <malloc+0x8de>
    2608:	00004097          	auipc	ra,0x4
    260c:	852080e7          	jalr	-1966(ra) # 5e5a <printf>
    exit(1);
    2610:	4505                	li	a0,1
    2612:	00003097          	auipc	ra,0x3
    2616:	4ce080e7          	jalr	1230(ra) # 5ae0 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    261a:	862a                	mv	a2,a0
    261c:	85a6                	mv	a1,s1
    261e:	00004517          	auipc	a0,0x4
    2622:	1f250513          	addi	a0,a0,498 # 6810 <malloc+0x8fe>
    2626:	00004097          	auipc	ra,0x4
    262a:	834080e7          	jalr	-1996(ra) # 5e5a <printf>
    exit(1);
    262e:	4505                	li	a0,1
    2630:	00003097          	auipc	ra,0x3
    2634:	4b0080e7          	jalr	1200(ra) # 5ae0 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2638:	86aa                	mv	a3,a0
    263a:	8626                	mv	a2,s1
    263c:	85a6                	mv	a1,s1
    263e:	00004517          	auipc	a0,0x4
    2642:	1f250513          	addi	a0,a0,498 # 6830 <malloc+0x91e>
    2646:	00004097          	auipc	ra,0x4
    264a:	814080e7          	jalr	-2028(ra) # 5e5a <printf>
    exit(1);
    264e:	4505                	li	a0,1
    2650:	00003097          	auipc	ra,0x3
    2654:	490080e7          	jalr	1168(ra) # 5ae0 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2658:	567d                	li	a2,-1
    265a:	85a6                	mv	a1,s1
    265c:	00004517          	auipc	a0,0x4
    2660:	1fc50513          	addi	a0,a0,508 # 6858 <malloc+0x946>
    2664:	00003097          	auipc	ra,0x3
    2668:	7f6080e7          	jalr	2038(ra) # 5e5a <printf>
    exit(1);
    266c:	4505                	li	a0,1
    266e:	00003097          	auipc	ra,0x3
    2672:	472080e7          	jalr	1138(ra) # 5ae0 <exit>

0000000000002676 <rwsbrk>:
void rwsbrk() {
    2676:	1101                	addi	sp,sp,-32
    2678:	ec06                	sd	ra,24(sp)
    267a:	e822                	sd	s0,16(sp)
    267c:	e426                	sd	s1,8(sp)
    267e:	e04a                	sd	s2,0(sp)
    2680:	1000                	addi	s0,sp,32
  uint64 a = (uint64)sbrk(8192);
    2682:	6509                	lui	a0,0x2
    2684:	00003097          	auipc	ra,0x3
    2688:	4e4080e7          	jalr	1252(ra) # 5b68 <sbrk>
  if (a == 0xffffffffffffffffLL) {
    268c:	57fd                	li	a5,-1
    268e:	06f50263          	beq	a0,a5,26f2 <rwsbrk+0x7c>
    2692:	84aa                	mv	s1,a0
  if ((uint64)sbrk(-8192) == 0xffffffffffffffffLL) {
    2694:	7579                	lui	a0,0xffffe
    2696:	00003097          	auipc	ra,0x3
    269a:	4d2080e7          	jalr	1234(ra) # 5b68 <sbrk>
    269e:	57fd                	li	a5,-1
    26a0:	06f50663          	beq	a0,a5,270c <rwsbrk+0x96>
  fd = open("rwsbrk", O_CREATE | O_WRONLY);
    26a4:	20100593          	li	a1,513
    26a8:	00004517          	auipc	a0,0x4
    26ac:	67050513          	addi	a0,a0,1648 # 6d18 <malloc+0xe06>
    26b0:	00003097          	auipc	ra,0x3
    26b4:	470080e7          	jalr	1136(ra) # 5b20 <open>
    26b8:	892a                	mv	s2,a0
  if (fd < 0) {
    26ba:	06054663          	bltz	a0,2726 <rwsbrk+0xb0>
  n = write(fd, (void *)(a + 4096), 1024);
    26be:	6785                	lui	a5,0x1
    26c0:	94be                	add	s1,s1,a5
    26c2:	40000613          	li	a2,1024
    26c6:	85a6                	mv	a1,s1
    26c8:	00003097          	auipc	ra,0x3
    26cc:	438080e7          	jalr	1080(ra) # 5b00 <write>
    26d0:	862a                	mv	a2,a0
  if (n >= 0) {
    26d2:	06054763          	bltz	a0,2740 <rwsbrk+0xca>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a + 4096, n);
    26d6:	85a6                	mv	a1,s1
    26d8:	00004517          	auipc	a0,0x4
    26dc:	66050513          	addi	a0,a0,1632 # 6d38 <malloc+0xe26>
    26e0:	00003097          	auipc	ra,0x3
    26e4:	77a080e7          	jalr	1914(ra) # 5e5a <printf>
    exit(1);
    26e8:	4505                	li	a0,1
    26ea:	00003097          	auipc	ra,0x3
    26ee:	3f6080e7          	jalr	1014(ra) # 5ae0 <exit>
    printf("sbrk(rwsbrk) failed\n");
    26f2:	00004517          	auipc	a0,0x4
    26f6:	5ee50513          	addi	a0,a0,1518 # 6ce0 <malloc+0xdce>
    26fa:	00003097          	auipc	ra,0x3
    26fe:	760080e7          	jalr	1888(ra) # 5e5a <printf>
    exit(1);
    2702:	4505                	li	a0,1
    2704:	00003097          	auipc	ra,0x3
    2708:	3dc080e7          	jalr	988(ra) # 5ae0 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    270c:	00004517          	auipc	a0,0x4
    2710:	5ec50513          	addi	a0,a0,1516 # 6cf8 <malloc+0xde6>
    2714:	00003097          	auipc	ra,0x3
    2718:	746080e7          	jalr	1862(ra) # 5e5a <printf>
    exit(1);
    271c:	4505                	li	a0,1
    271e:	00003097          	auipc	ra,0x3
    2722:	3c2080e7          	jalr	962(ra) # 5ae0 <exit>
    printf("open(rwsbrk) failed\n");
    2726:	00004517          	auipc	a0,0x4
    272a:	5fa50513          	addi	a0,a0,1530 # 6d20 <malloc+0xe0e>
    272e:	00003097          	auipc	ra,0x3
    2732:	72c080e7          	jalr	1836(ra) # 5e5a <printf>
    exit(1);
    2736:	4505                	li	a0,1
    2738:	00003097          	auipc	ra,0x3
    273c:	3a8080e7          	jalr	936(ra) # 5ae0 <exit>
  close(fd);
    2740:	854a                	mv	a0,s2
    2742:	00003097          	auipc	ra,0x3
    2746:	3c6080e7          	jalr	966(ra) # 5b08 <close>
  unlink("rwsbrk");
    274a:	00004517          	auipc	a0,0x4
    274e:	5ce50513          	addi	a0,a0,1486 # 6d18 <malloc+0xe06>
    2752:	00003097          	auipc	ra,0x3
    2756:	3de080e7          	jalr	990(ra) # 5b30 <unlink>
  fd = open("xv6-readme", O_RDONLY);
    275a:	4581                	li	a1,0
    275c:	00004517          	auipc	a0,0x4
    2760:	ab450513          	addi	a0,a0,-1356 # 6210 <malloc+0x2fe>
    2764:	00003097          	auipc	ra,0x3
    2768:	3bc080e7          	jalr	956(ra) # 5b20 <open>
    276c:	892a                	mv	s2,a0
  if (fd < 0) {
    276e:	02054963          	bltz	a0,27a0 <rwsbrk+0x12a>
  n = read(fd, (void *)(a + 4096), 10);
    2772:	4629                	li	a2,10
    2774:	85a6                	mv	a1,s1
    2776:	00003097          	auipc	ra,0x3
    277a:	382080e7          	jalr	898(ra) # 5af8 <read>
    277e:	862a                	mv	a2,a0
  if (n >= 0) {
    2780:	02054d63          	bltz	a0,27ba <rwsbrk+0x144>
    printf("read(fd, %p, 10) returned %d, not -1\n", a + 4096, n);
    2784:	85a6                	mv	a1,s1
    2786:	00004517          	auipc	a0,0x4
    278a:	5e250513          	addi	a0,a0,1506 # 6d68 <malloc+0xe56>
    278e:	00003097          	auipc	ra,0x3
    2792:	6cc080e7          	jalr	1740(ra) # 5e5a <printf>
    exit(1);
    2796:	4505                	li	a0,1
    2798:	00003097          	auipc	ra,0x3
    279c:	348080e7          	jalr	840(ra) # 5ae0 <exit>
    printf("open(rwsbrk) failed\n");
    27a0:	00004517          	auipc	a0,0x4
    27a4:	58050513          	addi	a0,a0,1408 # 6d20 <malloc+0xe0e>
    27a8:	00003097          	auipc	ra,0x3
    27ac:	6b2080e7          	jalr	1714(ra) # 5e5a <printf>
    exit(1);
    27b0:	4505                	li	a0,1
    27b2:	00003097          	auipc	ra,0x3
    27b6:	32e080e7          	jalr	814(ra) # 5ae0 <exit>
  close(fd);
    27ba:	854a                	mv	a0,s2
    27bc:	00003097          	auipc	ra,0x3
    27c0:	34c080e7          	jalr	844(ra) # 5b08 <close>
  exit(0);
    27c4:	4501                	li	a0,0
    27c6:	00003097          	auipc	ra,0x3
    27ca:	31a080e7          	jalr	794(ra) # 5ae0 <exit>

00000000000027ce <sbrkbasic>:
void sbrkbasic(char *s) {
    27ce:	7139                	addi	sp,sp,-64
    27d0:	fc06                	sd	ra,56(sp)
    27d2:	f822                	sd	s0,48(sp)
    27d4:	f426                	sd	s1,40(sp)
    27d6:	f04a                	sd	s2,32(sp)
    27d8:	ec4e                	sd	s3,24(sp)
    27da:	e852                	sd	s4,16(sp)
    27dc:	0080                	addi	s0,sp,64
    27de:	8a2a                	mv	s4,a0
  pid = fork();
    27e0:	00003097          	auipc	ra,0x3
    27e4:	2f8080e7          	jalr	760(ra) # 5ad8 <fork>
  if (pid < 0) {
    27e8:	02054c63          	bltz	a0,2820 <sbrkbasic+0x52>
  if (pid == 0) {
    27ec:	ed21                	bnez	a0,2844 <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    27ee:	40000537          	lui	a0,0x40000
    27f2:	00003097          	auipc	ra,0x3
    27f6:	376080e7          	jalr	886(ra) # 5b68 <sbrk>
    if (a == (char *)0xffffffffffffffffL) {
    27fa:	57fd                	li	a5,-1
    27fc:	02f50f63          	beq	a0,a5,283a <sbrkbasic+0x6c>
    for (b = a; b < a + TOOMUCH; b += 4096) {
    2800:	400007b7          	lui	a5,0x40000
    2804:	97aa                	add	a5,a5,a0
      *b = 99;
    2806:	06300693          	li	a3,99
    for (b = a; b < a + TOOMUCH; b += 4096) {
    280a:	6705                	lui	a4,0x1
      *b = 99;
    280c:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0398>
    for (b = a; b < a + TOOMUCH; b += 4096) {
    2810:	953a                	add	a0,a0,a4
    2812:	fef51de3          	bne	a0,a5,280c <sbrkbasic+0x3e>
    exit(1);
    2816:	4505                	li	a0,1
    2818:	00003097          	auipc	ra,0x3
    281c:	2c8080e7          	jalr	712(ra) # 5ae0 <exit>
    printf("fork failed in sbrkbasic\n");
    2820:	00004517          	auipc	a0,0x4
    2824:	57050513          	addi	a0,a0,1392 # 6d90 <malloc+0xe7e>
    2828:	00003097          	auipc	ra,0x3
    282c:	632080e7          	jalr	1586(ra) # 5e5a <printf>
    exit(1);
    2830:	4505                	li	a0,1
    2832:	00003097          	auipc	ra,0x3
    2836:	2ae080e7          	jalr	686(ra) # 5ae0 <exit>
      exit(0);
    283a:	4501                	li	a0,0
    283c:	00003097          	auipc	ra,0x3
    2840:	2a4080e7          	jalr	676(ra) # 5ae0 <exit>
  wait(&xstatus);
    2844:	fcc40513          	addi	a0,s0,-52
    2848:	00003097          	auipc	ra,0x3
    284c:	2a0080e7          	jalr	672(ra) # 5ae8 <wait>
  if (xstatus == 1) {
    2850:	fcc42703          	lw	a4,-52(s0)
    2854:	4785                	li	a5,1
    2856:	00f70d63          	beq	a4,a5,2870 <sbrkbasic+0xa2>
  a = sbrk(0);
    285a:	4501                	li	a0,0
    285c:	00003097          	auipc	ra,0x3
    2860:	30c080e7          	jalr	780(ra) # 5b68 <sbrk>
    2864:	84aa                	mv	s1,a0
  for (i = 0; i < 5000; i++) {
    2866:	4901                	li	s2,0
    2868:	6985                	lui	s3,0x1
    286a:	38898993          	addi	s3,s3,904 # 1388 <badarg+0x3e>
    286e:	a005                	j	288e <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    2870:	85d2                	mv	a1,s4
    2872:	00004517          	auipc	a0,0x4
    2876:	53e50513          	addi	a0,a0,1342 # 6db0 <malloc+0xe9e>
    287a:	00003097          	auipc	ra,0x3
    287e:	5e0080e7          	jalr	1504(ra) # 5e5a <printf>
    exit(1);
    2882:	4505                	li	a0,1
    2884:	00003097          	auipc	ra,0x3
    2888:	25c080e7          	jalr	604(ra) # 5ae0 <exit>
    a = b + 1;
    288c:	84be                	mv	s1,a5
    b = sbrk(1);
    288e:	4505                	li	a0,1
    2890:	00003097          	auipc	ra,0x3
    2894:	2d8080e7          	jalr	728(ra) # 5b68 <sbrk>
    if (b != a) {
    2898:	04951c63          	bne	a0,s1,28f0 <sbrkbasic+0x122>
    *b = 1;
    289c:	4785                	li	a5,1
    289e:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    28a2:	00148793          	addi	a5,s1,1
  for (i = 0; i < 5000; i++) {
    28a6:	2905                	addiw	s2,s2,1
    28a8:	ff3912e3          	bne	s2,s3,288c <sbrkbasic+0xbe>
  pid = fork();
    28ac:	00003097          	auipc	ra,0x3
    28b0:	22c080e7          	jalr	556(ra) # 5ad8 <fork>
    28b4:	892a                	mv	s2,a0
  if (pid < 0) {
    28b6:	04054e63          	bltz	a0,2912 <sbrkbasic+0x144>
  c = sbrk(1);
    28ba:	4505                	li	a0,1
    28bc:	00003097          	auipc	ra,0x3
    28c0:	2ac080e7          	jalr	684(ra) # 5b68 <sbrk>
  c = sbrk(1);
    28c4:	4505                	li	a0,1
    28c6:	00003097          	auipc	ra,0x3
    28ca:	2a2080e7          	jalr	674(ra) # 5b68 <sbrk>
  if (c != a + 1) {
    28ce:	0489                	addi	s1,s1,2
    28d0:	04a48f63          	beq	s1,a0,292e <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    28d4:	85d2                	mv	a1,s4
    28d6:	00004517          	auipc	a0,0x4
    28da:	53a50513          	addi	a0,a0,1338 # 6e10 <malloc+0xefe>
    28de:	00003097          	auipc	ra,0x3
    28e2:	57c080e7          	jalr	1404(ra) # 5e5a <printf>
    exit(1);
    28e6:	4505                	li	a0,1
    28e8:	00003097          	auipc	ra,0x3
    28ec:	1f8080e7          	jalr	504(ra) # 5ae0 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    28f0:	872a                	mv	a4,a0
    28f2:	86a6                	mv	a3,s1
    28f4:	864a                	mv	a2,s2
    28f6:	85d2                	mv	a1,s4
    28f8:	00004517          	auipc	a0,0x4
    28fc:	4d850513          	addi	a0,a0,1240 # 6dd0 <malloc+0xebe>
    2900:	00003097          	auipc	ra,0x3
    2904:	55a080e7          	jalr	1370(ra) # 5e5a <printf>
      exit(1);
    2908:	4505                	li	a0,1
    290a:	00003097          	auipc	ra,0x3
    290e:	1d6080e7          	jalr	470(ra) # 5ae0 <exit>
    printf("%s: sbrk test fork failed\n", s);
    2912:	85d2                	mv	a1,s4
    2914:	00004517          	auipc	a0,0x4
    2918:	4dc50513          	addi	a0,a0,1244 # 6df0 <malloc+0xede>
    291c:	00003097          	auipc	ra,0x3
    2920:	53e080e7          	jalr	1342(ra) # 5e5a <printf>
    exit(1);
    2924:	4505                	li	a0,1
    2926:	00003097          	auipc	ra,0x3
    292a:	1ba080e7          	jalr	442(ra) # 5ae0 <exit>
  if (pid == 0) exit(0);
    292e:	00091763          	bnez	s2,293c <sbrkbasic+0x16e>
    2932:	4501                	li	a0,0
    2934:	00003097          	auipc	ra,0x3
    2938:	1ac080e7          	jalr	428(ra) # 5ae0 <exit>
  wait(&xstatus);
    293c:	fcc40513          	addi	a0,s0,-52
    2940:	00003097          	auipc	ra,0x3
    2944:	1a8080e7          	jalr	424(ra) # 5ae8 <wait>
  exit(xstatus);
    2948:	fcc42503          	lw	a0,-52(s0)
    294c:	00003097          	auipc	ra,0x3
    2950:	194080e7          	jalr	404(ra) # 5ae0 <exit>

0000000000002954 <sbrkmuch>:
void sbrkmuch(char *s) {
    2954:	7179                	addi	sp,sp,-48
    2956:	f406                	sd	ra,40(sp)
    2958:	f022                	sd	s0,32(sp)
    295a:	ec26                	sd	s1,24(sp)
    295c:	e84a                	sd	s2,16(sp)
    295e:	e44e                	sd	s3,8(sp)
    2960:	e052                	sd	s4,0(sp)
    2962:	1800                	addi	s0,sp,48
    2964:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2966:	4501                	li	a0,0
    2968:	00003097          	auipc	ra,0x3
    296c:	200080e7          	jalr	512(ra) # 5b68 <sbrk>
    2970:	892a                	mv	s2,a0
  a = sbrk(0);
    2972:	4501                	li	a0,0
    2974:	00003097          	auipc	ra,0x3
    2978:	1f4080e7          	jalr	500(ra) # 5b68 <sbrk>
    297c:	84aa                	mv	s1,a0
  p = sbrk(amt);
    297e:	06400537          	lui	a0,0x6400
    2982:	9d05                	subw	a0,a0,s1
    2984:	00003097          	auipc	ra,0x3
    2988:	1e4080e7          	jalr	484(ra) # 5b68 <sbrk>
  if (p != a) {
    298c:	0ca49863          	bne	s1,a0,2a5c <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2990:	4501                	li	a0,0
    2992:	00003097          	auipc	ra,0x3
    2996:	1d6080e7          	jalr	470(ra) # 5b68 <sbrk>
    299a:	87aa                	mv	a5,a0
  for (char *pp = a; pp < eee; pp += 4096) *pp = 1;
    299c:	00a4f963          	bgeu	s1,a0,29ae <sbrkmuch+0x5a>
    29a0:	4685                	li	a3,1
    29a2:	6705                	lui	a4,0x1
    29a4:	00d48023          	sb	a3,0(s1)
    29a8:	94ba                	add	s1,s1,a4
    29aa:	fef4ede3          	bltu	s1,a5,29a4 <sbrkmuch+0x50>
  *lastaddr = 99;
    29ae:	064007b7          	lui	a5,0x6400
    29b2:	06300713          	li	a4,99
    29b6:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0397>
  a = sbrk(0);
    29ba:	4501                	li	a0,0
    29bc:	00003097          	auipc	ra,0x3
    29c0:	1ac080e7          	jalr	428(ra) # 5b68 <sbrk>
    29c4:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    29c6:	757d                	lui	a0,0xfffff
    29c8:	00003097          	auipc	ra,0x3
    29cc:	1a0080e7          	jalr	416(ra) # 5b68 <sbrk>
  if (c == (char *)0xffffffffffffffffL) {
    29d0:	57fd                	li	a5,-1
    29d2:	0af50363          	beq	a0,a5,2a78 <sbrkmuch+0x124>
  c = sbrk(0);
    29d6:	4501                	li	a0,0
    29d8:	00003097          	auipc	ra,0x3
    29dc:	190080e7          	jalr	400(ra) # 5b68 <sbrk>
  if (c != a - PGSIZE) {
    29e0:	77fd                	lui	a5,0xfffff
    29e2:	97a6                	add	a5,a5,s1
    29e4:	0af51863          	bne	a0,a5,2a94 <sbrkmuch+0x140>
  a = sbrk(0);
    29e8:	4501                	li	a0,0
    29ea:	00003097          	auipc	ra,0x3
    29ee:	17e080e7          	jalr	382(ra) # 5b68 <sbrk>
    29f2:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    29f4:	6505                	lui	a0,0x1
    29f6:	00003097          	auipc	ra,0x3
    29fa:	172080e7          	jalr	370(ra) # 5b68 <sbrk>
    29fe:	8a2a                	mv	s4,a0
  if (c != a || sbrk(0) != a + PGSIZE) {
    2a00:	0aa49a63          	bne	s1,a0,2ab4 <sbrkmuch+0x160>
    2a04:	4501                	li	a0,0
    2a06:	00003097          	auipc	ra,0x3
    2a0a:	162080e7          	jalr	354(ra) # 5b68 <sbrk>
    2a0e:	6785                	lui	a5,0x1
    2a10:	97a6                	add	a5,a5,s1
    2a12:	0af51163          	bne	a0,a5,2ab4 <sbrkmuch+0x160>
  if (*lastaddr == 99) {
    2a16:	064007b7          	lui	a5,0x6400
    2a1a:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0397>
    2a1e:	06300793          	li	a5,99
    2a22:	0af70963          	beq	a4,a5,2ad4 <sbrkmuch+0x180>
  a = sbrk(0);
    2a26:	4501                	li	a0,0
    2a28:	00003097          	auipc	ra,0x3
    2a2c:	140080e7          	jalr	320(ra) # 5b68 <sbrk>
    2a30:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2a32:	4501                	li	a0,0
    2a34:	00003097          	auipc	ra,0x3
    2a38:	134080e7          	jalr	308(ra) # 5b68 <sbrk>
    2a3c:	40a9053b          	subw	a0,s2,a0
    2a40:	00003097          	auipc	ra,0x3
    2a44:	128080e7          	jalr	296(ra) # 5b68 <sbrk>
  if (c != a) {
    2a48:	0aa49463          	bne	s1,a0,2af0 <sbrkmuch+0x19c>
}
    2a4c:	70a2                	ld	ra,40(sp)
    2a4e:	7402                	ld	s0,32(sp)
    2a50:	64e2                	ld	s1,24(sp)
    2a52:	6942                	ld	s2,16(sp)
    2a54:	69a2                	ld	s3,8(sp)
    2a56:	6a02                	ld	s4,0(sp)
    2a58:	6145                	addi	sp,sp,48
    2a5a:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n",
    2a5c:	85ce                	mv	a1,s3
    2a5e:	00004517          	auipc	a0,0x4
    2a62:	3d250513          	addi	a0,a0,978 # 6e30 <malloc+0xf1e>
    2a66:	00003097          	auipc	ra,0x3
    2a6a:	3f4080e7          	jalr	1012(ra) # 5e5a <printf>
    exit(1);
    2a6e:	4505                	li	a0,1
    2a70:	00003097          	auipc	ra,0x3
    2a74:	070080e7          	jalr	112(ra) # 5ae0 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2a78:	85ce                	mv	a1,s3
    2a7a:	00004517          	auipc	a0,0x4
    2a7e:	3fe50513          	addi	a0,a0,1022 # 6e78 <malloc+0xf66>
    2a82:	00003097          	auipc	ra,0x3
    2a86:	3d8080e7          	jalr	984(ra) # 5e5a <printf>
    exit(1);
    2a8a:	4505                	li	a0,1
    2a8c:	00003097          	auipc	ra,0x3
    2a90:	054080e7          	jalr	84(ra) # 5ae0 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a,
    2a94:	86aa                	mv	a3,a0
    2a96:	8626                	mv	a2,s1
    2a98:	85ce                	mv	a1,s3
    2a9a:	00004517          	auipc	a0,0x4
    2a9e:	3fe50513          	addi	a0,a0,1022 # 6e98 <malloc+0xf86>
    2aa2:	00003097          	auipc	ra,0x3
    2aa6:	3b8080e7          	jalr	952(ra) # 5e5a <printf>
    exit(1);
    2aaa:	4505                	li	a0,1
    2aac:	00003097          	auipc	ra,0x3
    2ab0:	034080e7          	jalr	52(ra) # 5ae0 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2ab4:	86d2                	mv	a3,s4
    2ab6:	8626                	mv	a2,s1
    2ab8:	85ce                	mv	a1,s3
    2aba:	00004517          	auipc	a0,0x4
    2abe:	41e50513          	addi	a0,a0,1054 # 6ed8 <malloc+0xfc6>
    2ac2:	00003097          	auipc	ra,0x3
    2ac6:	398080e7          	jalr	920(ra) # 5e5a <printf>
    exit(1);
    2aca:	4505                	li	a0,1
    2acc:	00003097          	auipc	ra,0x3
    2ad0:	014080e7          	jalr	20(ra) # 5ae0 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2ad4:	85ce                	mv	a1,s3
    2ad6:	00004517          	auipc	a0,0x4
    2ada:	43250513          	addi	a0,a0,1074 # 6f08 <malloc+0xff6>
    2ade:	00003097          	auipc	ra,0x3
    2ae2:	37c080e7          	jalr	892(ra) # 5e5a <printf>
    exit(1);
    2ae6:	4505                	li	a0,1
    2ae8:	00003097          	auipc	ra,0x3
    2aec:	ff8080e7          	jalr	-8(ra) # 5ae0 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2af0:	86aa                	mv	a3,a0
    2af2:	8626                	mv	a2,s1
    2af4:	85ce                	mv	a1,s3
    2af6:	00004517          	auipc	a0,0x4
    2afa:	44a50513          	addi	a0,a0,1098 # 6f40 <malloc+0x102e>
    2afe:	00003097          	auipc	ra,0x3
    2b02:	35c080e7          	jalr	860(ra) # 5e5a <printf>
    exit(1);
    2b06:	4505                	li	a0,1
    2b08:	00003097          	auipc	ra,0x3
    2b0c:	fd8080e7          	jalr	-40(ra) # 5ae0 <exit>

0000000000002b10 <sbrkarg>:
void sbrkarg(char *s) {
    2b10:	7179                	addi	sp,sp,-48
    2b12:	f406                	sd	ra,40(sp)
    2b14:	f022                	sd	s0,32(sp)
    2b16:	ec26                	sd	s1,24(sp)
    2b18:	e84a                	sd	s2,16(sp)
    2b1a:	e44e                	sd	s3,8(sp)
    2b1c:	1800                	addi	s0,sp,48
    2b1e:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2b20:	6505                	lui	a0,0x1
    2b22:	00003097          	auipc	ra,0x3
    2b26:	046080e7          	jalr	70(ra) # 5b68 <sbrk>
    2b2a:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE | O_WRONLY);
    2b2c:	20100593          	li	a1,513
    2b30:	00004517          	auipc	a0,0x4
    2b34:	43850513          	addi	a0,a0,1080 # 6f68 <malloc+0x1056>
    2b38:	00003097          	auipc	ra,0x3
    2b3c:	fe8080e7          	jalr	-24(ra) # 5b20 <open>
    2b40:	84aa                	mv	s1,a0
  unlink("sbrk");
    2b42:	00004517          	auipc	a0,0x4
    2b46:	42650513          	addi	a0,a0,1062 # 6f68 <malloc+0x1056>
    2b4a:	00003097          	auipc	ra,0x3
    2b4e:	fe6080e7          	jalr	-26(ra) # 5b30 <unlink>
  if (fd < 0) {
    2b52:	0404c163          	bltz	s1,2b94 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2b56:	6605                	lui	a2,0x1
    2b58:	85ca                	mv	a1,s2
    2b5a:	8526                	mv	a0,s1
    2b5c:	00003097          	auipc	ra,0x3
    2b60:	fa4080e7          	jalr	-92(ra) # 5b00 <write>
    2b64:	04054663          	bltz	a0,2bb0 <sbrkarg+0xa0>
  close(fd);
    2b68:	8526                	mv	a0,s1
    2b6a:	00003097          	auipc	ra,0x3
    2b6e:	f9e080e7          	jalr	-98(ra) # 5b08 <close>
  a = sbrk(PGSIZE);
    2b72:	6505                	lui	a0,0x1
    2b74:	00003097          	auipc	ra,0x3
    2b78:	ff4080e7          	jalr	-12(ra) # 5b68 <sbrk>
  if (pipe((int *)a) != 0) {
    2b7c:	00003097          	auipc	ra,0x3
    2b80:	f74080e7          	jalr	-140(ra) # 5af0 <pipe>
    2b84:	e521                	bnez	a0,2bcc <sbrkarg+0xbc>
}
    2b86:	70a2                	ld	ra,40(sp)
    2b88:	7402                	ld	s0,32(sp)
    2b8a:	64e2                	ld	s1,24(sp)
    2b8c:	6942                	ld	s2,16(sp)
    2b8e:	69a2                	ld	s3,8(sp)
    2b90:	6145                	addi	sp,sp,48
    2b92:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2b94:	85ce                	mv	a1,s3
    2b96:	00004517          	auipc	a0,0x4
    2b9a:	3da50513          	addi	a0,a0,986 # 6f70 <malloc+0x105e>
    2b9e:	00003097          	auipc	ra,0x3
    2ba2:	2bc080e7          	jalr	700(ra) # 5e5a <printf>
    exit(1);
    2ba6:	4505                	li	a0,1
    2ba8:	00003097          	auipc	ra,0x3
    2bac:	f38080e7          	jalr	-200(ra) # 5ae0 <exit>
    printf("%s: write sbrk failed\n", s);
    2bb0:	85ce                	mv	a1,s3
    2bb2:	00004517          	auipc	a0,0x4
    2bb6:	3d650513          	addi	a0,a0,982 # 6f88 <malloc+0x1076>
    2bba:	00003097          	auipc	ra,0x3
    2bbe:	2a0080e7          	jalr	672(ra) # 5e5a <printf>
    exit(1);
    2bc2:	4505                	li	a0,1
    2bc4:	00003097          	auipc	ra,0x3
    2bc8:	f1c080e7          	jalr	-228(ra) # 5ae0 <exit>
    printf("%s: pipe() failed\n", s);
    2bcc:	85ce                	mv	a1,s3
    2bce:	00004517          	auipc	a0,0x4
    2bd2:	e0a50513          	addi	a0,a0,-502 # 69d8 <malloc+0xac6>
    2bd6:	00003097          	auipc	ra,0x3
    2bda:	284080e7          	jalr	644(ra) # 5e5a <printf>
    exit(1);
    2bde:	4505                	li	a0,1
    2be0:	00003097          	auipc	ra,0x3
    2be4:	f00080e7          	jalr	-256(ra) # 5ae0 <exit>

0000000000002be8 <argptest>:
void argptest(char *s) {
    2be8:	1101                	addi	sp,sp,-32
    2bea:	ec06                	sd	ra,24(sp)
    2bec:	e822                	sd	s0,16(sp)
    2bee:	e426                	sd	s1,8(sp)
    2bf0:	e04a                	sd	s2,0(sp)
    2bf2:	1000                	addi	s0,sp,32
    2bf4:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2bf6:	4581                	li	a1,0
    2bf8:	00004517          	auipc	a0,0x4
    2bfc:	3a850513          	addi	a0,a0,936 # 6fa0 <malloc+0x108e>
    2c00:	00003097          	auipc	ra,0x3
    2c04:	f20080e7          	jalr	-224(ra) # 5b20 <open>
  if (fd < 0) {
    2c08:	02054b63          	bltz	a0,2c3e <argptest+0x56>
    2c0c:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2c0e:	4501                	li	a0,0
    2c10:	00003097          	auipc	ra,0x3
    2c14:	f58080e7          	jalr	-168(ra) # 5b68 <sbrk>
    2c18:	567d                	li	a2,-1
    2c1a:	fff50593          	addi	a1,a0,-1
    2c1e:	8526                	mv	a0,s1
    2c20:	00003097          	auipc	ra,0x3
    2c24:	ed8080e7          	jalr	-296(ra) # 5af8 <read>
  close(fd);
    2c28:	8526                	mv	a0,s1
    2c2a:	00003097          	auipc	ra,0x3
    2c2e:	ede080e7          	jalr	-290(ra) # 5b08 <close>
}
    2c32:	60e2                	ld	ra,24(sp)
    2c34:	6442                	ld	s0,16(sp)
    2c36:	64a2                	ld	s1,8(sp)
    2c38:	6902                	ld	s2,0(sp)
    2c3a:	6105                	addi	sp,sp,32
    2c3c:	8082                	ret
    printf("%s: open failed\n", s);
    2c3e:	85ca                	mv	a1,s2
    2c40:	00004517          	auipc	a0,0x4
    2c44:	ca850513          	addi	a0,a0,-856 # 68e8 <malloc+0x9d6>
    2c48:	00003097          	auipc	ra,0x3
    2c4c:	212080e7          	jalr	530(ra) # 5e5a <printf>
    exit(1);
    2c50:	4505                	li	a0,1
    2c52:	00003097          	auipc	ra,0x3
    2c56:	e8e080e7          	jalr	-370(ra) # 5ae0 <exit>

0000000000002c5a <sbrkbugs>:
void sbrkbugs(char *s) {
    2c5a:	1141                	addi	sp,sp,-16
    2c5c:	e406                	sd	ra,8(sp)
    2c5e:	e022                	sd	s0,0(sp)
    2c60:	0800                	addi	s0,sp,16
  int pid = fork();
    2c62:	00003097          	auipc	ra,0x3
    2c66:	e76080e7          	jalr	-394(ra) # 5ad8 <fork>
  if (pid < 0) {
    2c6a:	02054263          	bltz	a0,2c8e <sbrkbugs+0x34>
  if (pid == 0) {
    2c6e:	ed0d                	bnez	a0,2ca8 <sbrkbugs+0x4e>
    int sz = (uint64)sbrk(0);
    2c70:	00003097          	auipc	ra,0x3
    2c74:	ef8080e7          	jalr	-264(ra) # 5b68 <sbrk>
    sbrk(-sz);
    2c78:	40a0053b          	negw	a0,a0
    2c7c:	00003097          	auipc	ra,0x3
    2c80:	eec080e7          	jalr	-276(ra) # 5b68 <sbrk>
    exit(0);
    2c84:	4501                	li	a0,0
    2c86:	00003097          	auipc	ra,0x3
    2c8a:	e5a080e7          	jalr	-422(ra) # 5ae0 <exit>
    printf("fork failed\n");
    2c8e:	00004517          	auipc	a0,0x4
    2c92:	fda50513          	addi	a0,a0,-38 # 6c68 <malloc+0xd56>
    2c96:	00003097          	auipc	ra,0x3
    2c9a:	1c4080e7          	jalr	452(ra) # 5e5a <printf>
    exit(1);
    2c9e:	4505                	li	a0,1
    2ca0:	00003097          	auipc	ra,0x3
    2ca4:	e40080e7          	jalr	-448(ra) # 5ae0 <exit>
  wait(0);
    2ca8:	4501                	li	a0,0
    2caa:	00003097          	auipc	ra,0x3
    2cae:	e3e080e7          	jalr	-450(ra) # 5ae8 <wait>
  pid = fork();
    2cb2:	00003097          	auipc	ra,0x3
    2cb6:	e26080e7          	jalr	-474(ra) # 5ad8 <fork>
  if (pid < 0) {
    2cba:	02054563          	bltz	a0,2ce4 <sbrkbugs+0x8a>
  if (pid == 0) {
    2cbe:	e121                	bnez	a0,2cfe <sbrkbugs+0xa4>
    int sz = (uint64)sbrk(0);
    2cc0:	00003097          	auipc	ra,0x3
    2cc4:	ea8080e7          	jalr	-344(ra) # 5b68 <sbrk>
    sbrk(-(sz - 3500));
    2cc8:	6785                	lui	a5,0x1
    2cca:	dac7879b          	addiw	a5,a5,-596 # dac <unlinkread+0x6e>
    2cce:	40a7853b          	subw	a0,a5,a0
    2cd2:	00003097          	auipc	ra,0x3
    2cd6:	e96080e7          	jalr	-362(ra) # 5b68 <sbrk>
    exit(0);
    2cda:	4501                	li	a0,0
    2cdc:	00003097          	auipc	ra,0x3
    2ce0:	e04080e7          	jalr	-508(ra) # 5ae0 <exit>
    printf("fork failed\n");
    2ce4:	00004517          	auipc	a0,0x4
    2ce8:	f8450513          	addi	a0,a0,-124 # 6c68 <malloc+0xd56>
    2cec:	00003097          	auipc	ra,0x3
    2cf0:	16e080e7          	jalr	366(ra) # 5e5a <printf>
    exit(1);
    2cf4:	4505                	li	a0,1
    2cf6:	00003097          	auipc	ra,0x3
    2cfa:	dea080e7          	jalr	-534(ra) # 5ae0 <exit>
  wait(0);
    2cfe:	4501                	li	a0,0
    2d00:	00003097          	auipc	ra,0x3
    2d04:	de8080e7          	jalr	-536(ra) # 5ae8 <wait>
  pid = fork();
    2d08:	00003097          	auipc	ra,0x3
    2d0c:	dd0080e7          	jalr	-560(ra) # 5ad8 <fork>
  if (pid < 0) {
    2d10:	02054a63          	bltz	a0,2d44 <sbrkbugs+0xea>
  if (pid == 0) {
    2d14:	e529                	bnez	a0,2d5e <sbrkbugs+0x104>
    sbrk((10 * 4096 + 2048) - (uint64)sbrk(0));
    2d16:	00003097          	auipc	ra,0x3
    2d1a:	e52080e7          	jalr	-430(ra) # 5b68 <sbrk>
    2d1e:	67ad                	lui	a5,0xb
    2d20:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x2a8>
    2d24:	40a7853b          	subw	a0,a5,a0
    2d28:	00003097          	auipc	ra,0x3
    2d2c:	e40080e7          	jalr	-448(ra) # 5b68 <sbrk>
    sbrk(-10);
    2d30:	5559                	li	a0,-10
    2d32:	00003097          	auipc	ra,0x3
    2d36:	e36080e7          	jalr	-458(ra) # 5b68 <sbrk>
    exit(0);
    2d3a:	4501                	li	a0,0
    2d3c:	00003097          	auipc	ra,0x3
    2d40:	da4080e7          	jalr	-604(ra) # 5ae0 <exit>
    printf("fork failed\n");
    2d44:	00004517          	auipc	a0,0x4
    2d48:	f2450513          	addi	a0,a0,-220 # 6c68 <malloc+0xd56>
    2d4c:	00003097          	auipc	ra,0x3
    2d50:	10e080e7          	jalr	270(ra) # 5e5a <printf>
    exit(1);
    2d54:	4505                	li	a0,1
    2d56:	00003097          	auipc	ra,0x3
    2d5a:	d8a080e7          	jalr	-630(ra) # 5ae0 <exit>
  wait(0);
    2d5e:	4501                	li	a0,0
    2d60:	00003097          	auipc	ra,0x3
    2d64:	d88080e7          	jalr	-632(ra) # 5ae8 <wait>
  exit(0);
    2d68:	4501                	li	a0,0
    2d6a:	00003097          	auipc	ra,0x3
    2d6e:	d76080e7          	jalr	-650(ra) # 5ae0 <exit>

0000000000002d72 <sbrklast>:
void sbrklast(char *s) {
    2d72:	7179                	addi	sp,sp,-48
    2d74:	f406                	sd	ra,40(sp)
    2d76:	f022                	sd	s0,32(sp)
    2d78:	ec26                	sd	s1,24(sp)
    2d7a:	e84a                	sd	s2,16(sp)
    2d7c:	e44e                	sd	s3,8(sp)
    2d7e:	e052                	sd	s4,0(sp)
    2d80:	1800                	addi	s0,sp,48
  uint64 top = (uint64)sbrk(0);
    2d82:	4501                	li	a0,0
    2d84:	00003097          	auipc	ra,0x3
    2d88:	de4080e7          	jalr	-540(ra) # 5b68 <sbrk>
  if ((top % 4096) != 0) sbrk(4096 - (top % 4096));
    2d8c:	03451793          	slli	a5,a0,0x34
    2d90:	ebd9                	bnez	a5,2e26 <sbrklast+0xb4>
  sbrk(4096);
    2d92:	6505                	lui	a0,0x1
    2d94:	00003097          	auipc	ra,0x3
    2d98:	dd4080e7          	jalr	-556(ra) # 5b68 <sbrk>
  sbrk(10);
    2d9c:	4529                	li	a0,10
    2d9e:	00003097          	auipc	ra,0x3
    2da2:	dca080e7          	jalr	-566(ra) # 5b68 <sbrk>
  sbrk(-20);
    2da6:	5531                	li	a0,-20
    2da8:	00003097          	auipc	ra,0x3
    2dac:	dc0080e7          	jalr	-576(ra) # 5b68 <sbrk>
  top = (uint64)sbrk(0);
    2db0:	4501                	li	a0,0
    2db2:	00003097          	auipc	ra,0x3
    2db6:	db6080e7          	jalr	-586(ra) # 5b68 <sbrk>
    2dba:	84aa                	mv	s1,a0
  char *p = (char *)(top - 64);
    2dbc:	fc050913          	addi	s2,a0,-64 # fc0 <linktest+0xcc>
  p[0] = 'x';
    2dc0:	07800a13          	li	s4,120
    2dc4:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2dc8:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR | O_CREATE);
    2dcc:	20200593          	li	a1,514
    2dd0:	854a                	mv	a0,s2
    2dd2:	00003097          	auipc	ra,0x3
    2dd6:	d4e080e7          	jalr	-690(ra) # 5b20 <open>
    2dda:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2ddc:	4605                	li	a2,1
    2dde:	85ca                	mv	a1,s2
    2de0:	00003097          	auipc	ra,0x3
    2de4:	d20080e7          	jalr	-736(ra) # 5b00 <write>
  close(fd);
    2de8:	854e                	mv	a0,s3
    2dea:	00003097          	auipc	ra,0x3
    2dee:	d1e080e7          	jalr	-738(ra) # 5b08 <close>
  fd = open(p, O_RDWR);
    2df2:	4589                	li	a1,2
    2df4:	854a                	mv	a0,s2
    2df6:	00003097          	auipc	ra,0x3
    2dfa:	d2a080e7          	jalr	-726(ra) # 5b20 <open>
  p[0] = '\0';
    2dfe:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2e02:	4605                	li	a2,1
    2e04:	85ca                	mv	a1,s2
    2e06:	00003097          	auipc	ra,0x3
    2e0a:	cf2080e7          	jalr	-782(ra) # 5af8 <read>
  if (p[0] != 'x') exit(1);
    2e0e:	fc04c783          	lbu	a5,-64(s1)
    2e12:	03479463          	bne	a5,s4,2e3a <sbrklast+0xc8>
}
    2e16:	70a2                	ld	ra,40(sp)
    2e18:	7402                	ld	s0,32(sp)
    2e1a:	64e2                	ld	s1,24(sp)
    2e1c:	6942                	ld	s2,16(sp)
    2e1e:	69a2                	ld	s3,8(sp)
    2e20:	6a02                	ld	s4,0(sp)
    2e22:	6145                	addi	sp,sp,48
    2e24:	8082                	ret
  if ((top % 4096) != 0) sbrk(4096 - (top % 4096));
    2e26:	0347d513          	srli	a0,a5,0x34
    2e2a:	6785                	lui	a5,0x1
    2e2c:	40a7853b          	subw	a0,a5,a0
    2e30:	00003097          	auipc	ra,0x3
    2e34:	d38080e7          	jalr	-712(ra) # 5b68 <sbrk>
    2e38:	bfa9                	j	2d92 <sbrklast+0x20>
  if (p[0] != 'x') exit(1);
    2e3a:	4505                	li	a0,1
    2e3c:	00003097          	auipc	ra,0x3
    2e40:	ca4080e7          	jalr	-860(ra) # 5ae0 <exit>

0000000000002e44 <sbrk8000>:
void sbrk8000(char *s) {
    2e44:	1141                	addi	sp,sp,-16
    2e46:	e406                	sd	ra,8(sp)
    2e48:	e022                	sd	s0,0(sp)
    2e4a:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2e4c:	80000537          	lui	a0,0x80000
    2e50:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff039c>
    2e52:	00003097          	auipc	ra,0x3
    2e56:	d16080e7          	jalr	-746(ra) # 5b68 <sbrk>
  volatile char *top = sbrk(0);
    2e5a:	4501                	li	a0,0
    2e5c:	00003097          	auipc	ra,0x3
    2e60:	d0c080e7          	jalr	-756(ra) # 5b68 <sbrk>
  *(top - 1) = *(top - 1) + 1;
    2e64:	fff54783          	lbu	a5,-1(a0)
    2e68:	2785                	addiw	a5,a5,1 # 1001 <linktest+0x10d>
    2e6a:	0ff7f793          	zext.b	a5,a5
    2e6e:	fef50fa3          	sb	a5,-1(a0)
}
    2e72:	60a2                	ld	ra,8(sp)
    2e74:	6402                	ld	s0,0(sp)
    2e76:	0141                	addi	sp,sp,16
    2e78:	8082                	ret

0000000000002e7a <execout>:
void execout(char *s) {
    2e7a:	715d                	addi	sp,sp,-80
    2e7c:	e486                	sd	ra,72(sp)
    2e7e:	e0a2                	sd	s0,64(sp)
    2e80:	fc26                	sd	s1,56(sp)
    2e82:	f84a                	sd	s2,48(sp)
    2e84:	f44e                	sd	s3,40(sp)
    2e86:	f052                	sd	s4,32(sp)
    2e88:	0880                	addi	s0,sp,80
  for (int avail = 0; avail < 15; avail++) {
    2e8a:	4901                	li	s2,0
    2e8c:	49bd                	li	s3,15
    int pid = fork();
    2e8e:	00003097          	auipc	ra,0x3
    2e92:	c4a080e7          	jalr	-950(ra) # 5ad8 <fork>
    2e96:	84aa                	mv	s1,a0
    if (pid < 0) {
    2e98:	02054063          	bltz	a0,2eb8 <execout+0x3e>
    } else if (pid == 0) {
    2e9c:	c91d                	beqz	a0,2ed2 <execout+0x58>
      wait((int *)0);
    2e9e:	4501                	li	a0,0
    2ea0:	00003097          	auipc	ra,0x3
    2ea4:	c48080e7          	jalr	-952(ra) # 5ae8 <wait>
  for (int avail = 0; avail < 15; avail++) {
    2ea8:	2905                	addiw	s2,s2,1
    2eaa:	ff3912e3          	bne	s2,s3,2e8e <execout+0x14>
  exit(0);
    2eae:	4501                	li	a0,0
    2eb0:	00003097          	auipc	ra,0x3
    2eb4:	c30080e7          	jalr	-976(ra) # 5ae0 <exit>
      printf("fork failed\n");
    2eb8:	00004517          	auipc	a0,0x4
    2ebc:	db050513          	addi	a0,a0,-592 # 6c68 <malloc+0xd56>
    2ec0:	00003097          	auipc	ra,0x3
    2ec4:	f9a080e7          	jalr	-102(ra) # 5e5a <printf>
      exit(1);
    2ec8:	4505                	li	a0,1
    2eca:	00003097          	auipc	ra,0x3
    2ece:	c16080e7          	jalr	-1002(ra) # 5ae0 <exit>
        if (a == 0xffffffffffffffffLL) break;
    2ed2:	59fd                	li	s3,-1
        *(char *)(a + 4096 - 1) = 1;
    2ed4:	4a05                	li	s4,1
        uint64 a = (uint64)sbrk(4096);
    2ed6:	6505                	lui	a0,0x1
    2ed8:	00003097          	auipc	ra,0x3
    2edc:	c90080e7          	jalr	-880(ra) # 5b68 <sbrk>
        if (a == 0xffffffffffffffffLL) break;
    2ee0:	01350763          	beq	a0,s3,2eee <execout+0x74>
        *(char *)(a + 4096 - 1) = 1;
    2ee4:	6785                	lui	a5,0x1
    2ee6:	97aa                	add	a5,a5,a0
    2ee8:	ff478fa3          	sb	s4,-1(a5) # fff <linktest+0x10b>
      while (1) {
    2eec:	b7ed                	j	2ed6 <execout+0x5c>
      for (int i = 0; i < avail; i++) sbrk(-4096);
    2eee:	01205a63          	blez	s2,2f02 <execout+0x88>
    2ef2:	757d                	lui	a0,0xfffff
    2ef4:	00003097          	auipc	ra,0x3
    2ef8:	c74080e7          	jalr	-908(ra) # 5b68 <sbrk>
    2efc:	2485                	addiw	s1,s1,1
    2efe:	ff249ae3          	bne	s1,s2,2ef2 <execout+0x78>
      close(1);
    2f02:	4505                	li	a0,1
    2f04:	00003097          	auipc	ra,0x3
    2f08:	c04080e7          	jalr	-1020(ra) # 5b08 <close>
      char *args[] = {"echo", "x", 0};
    2f0c:	00003517          	auipc	a0,0x3
    2f10:	12c50513          	addi	a0,a0,300 # 6038 <malloc+0x126>
    2f14:	faa43c23          	sd	a0,-72(s0)
    2f18:	00003797          	auipc	a5,0x3
    2f1c:	19078793          	addi	a5,a5,400 # 60a8 <malloc+0x196>
    2f20:	fcf43023          	sd	a5,-64(s0)
    2f24:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2f28:	fb840593          	addi	a1,s0,-72
    2f2c:	00003097          	auipc	ra,0x3
    2f30:	bec080e7          	jalr	-1044(ra) # 5b18 <exec>
      exit(0);
    2f34:	4501                	li	a0,0
    2f36:	00003097          	auipc	ra,0x3
    2f3a:	baa080e7          	jalr	-1110(ra) # 5ae0 <exit>

0000000000002f3e <fourteen>:
void fourteen(char *s) {
    2f3e:	1101                	addi	sp,sp,-32
    2f40:	ec06                	sd	ra,24(sp)
    2f42:	e822                	sd	s0,16(sp)
    2f44:	e426                	sd	s1,8(sp)
    2f46:	1000                	addi	s0,sp,32
    2f48:	84aa                	mv	s1,a0
  if (mkdir("12345678901234") != 0) {
    2f4a:	00004517          	auipc	a0,0x4
    2f4e:	22e50513          	addi	a0,a0,558 # 7178 <malloc+0x1266>
    2f52:	00003097          	auipc	ra,0x3
    2f56:	bf6080e7          	jalr	-1034(ra) # 5b48 <mkdir>
    2f5a:	e165                	bnez	a0,303a <fourteen+0xfc>
  if (mkdir("12345678901234/123456789012345") != 0) {
    2f5c:	00004517          	auipc	a0,0x4
    2f60:	07450513          	addi	a0,a0,116 # 6fd0 <malloc+0x10be>
    2f64:	00003097          	auipc	ra,0x3
    2f68:	be4080e7          	jalr	-1052(ra) # 5b48 <mkdir>
    2f6c:	e56d                	bnez	a0,3056 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2f6e:	20000593          	li	a1,512
    2f72:	00004517          	auipc	a0,0x4
    2f76:	0b650513          	addi	a0,a0,182 # 7028 <malloc+0x1116>
    2f7a:	00003097          	auipc	ra,0x3
    2f7e:	ba6080e7          	jalr	-1114(ra) # 5b20 <open>
  if (fd < 0) {
    2f82:	0e054863          	bltz	a0,3072 <fourteen+0x134>
  close(fd);
    2f86:	00003097          	auipc	ra,0x3
    2f8a:	b82080e7          	jalr	-1150(ra) # 5b08 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2f8e:	4581                	li	a1,0
    2f90:	00004517          	auipc	a0,0x4
    2f94:	11050513          	addi	a0,a0,272 # 70a0 <malloc+0x118e>
    2f98:	00003097          	auipc	ra,0x3
    2f9c:	b88080e7          	jalr	-1144(ra) # 5b20 <open>
  if (fd < 0) {
    2fa0:	0e054763          	bltz	a0,308e <fourteen+0x150>
  close(fd);
    2fa4:	00003097          	auipc	ra,0x3
    2fa8:	b64080e7          	jalr	-1180(ra) # 5b08 <close>
  if (mkdir("12345678901234/12345678901234") == 0) {
    2fac:	00004517          	auipc	a0,0x4
    2fb0:	16450513          	addi	a0,a0,356 # 7110 <malloc+0x11fe>
    2fb4:	00003097          	auipc	ra,0x3
    2fb8:	b94080e7          	jalr	-1132(ra) # 5b48 <mkdir>
    2fbc:	c57d                	beqz	a0,30aa <fourteen+0x16c>
  if (mkdir("123456789012345/12345678901234") == 0) {
    2fbe:	00004517          	auipc	a0,0x4
    2fc2:	1aa50513          	addi	a0,a0,426 # 7168 <malloc+0x1256>
    2fc6:	00003097          	auipc	ra,0x3
    2fca:	b82080e7          	jalr	-1150(ra) # 5b48 <mkdir>
    2fce:	cd65                	beqz	a0,30c6 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2fd0:	00004517          	auipc	a0,0x4
    2fd4:	19850513          	addi	a0,a0,408 # 7168 <malloc+0x1256>
    2fd8:	00003097          	auipc	ra,0x3
    2fdc:	b58080e7          	jalr	-1192(ra) # 5b30 <unlink>
  unlink("12345678901234/12345678901234");
    2fe0:	00004517          	auipc	a0,0x4
    2fe4:	13050513          	addi	a0,a0,304 # 7110 <malloc+0x11fe>
    2fe8:	00003097          	auipc	ra,0x3
    2fec:	b48080e7          	jalr	-1208(ra) # 5b30 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2ff0:	00004517          	auipc	a0,0x4
    2ff4:	0b050513          	addi	a0,a0,176 # 70a0 <malloc+0x118e>
    2ff8:	00003097          	auipc	ra,0x3
    2ffc:	b38080e7          	jalr	-1224(ra) # 5b30 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    3000:	00004517          	auipc	a0,0x4
    3004:	02850513          	addi	a0,a0,40 # 7028 <malloc+0x1116>
    3008:	00003097          	auipc	ra,0x3
    300c:	b28080e7          	jalr	-1240(ra) # 5b30 <unlink>
  unlink("12345678901234/123456789012345");
    3010:	00004517          	auipc	a0,0x4
    3014:	fc050513          	addi	a0,a0,-64 # 6fd0 <malloc+0x10be>
    3018:	00003097          	auipc	ra,0x3
    301c:	b18080e7          	jalr	-1256(ra) # 5b30 <unlink>
  unlink("12345678901234");
    3020:	00004517          	auipc	a0,0x4
    3024:	15850513          	addi	a0,a0,344 # 7178 <malloc+0x1266>
    3028:	00003097          	auipc	ra,0x3
    302c:	b08080e7          	jalr	-1272(ra) # 5b30 <unlink>
}
    3030:	60e2                	ld	ra,24(sp)
    3032:	6442                	ld	s0,16(sp)
    3034:	64a2                	ld	s1,8(sp)
    3036:	6105                	addi	sp,sp,32
    3038:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    303a:	85a6                	mv	a1,s1
    303c:	00004517          	auipc	a0,0x4
    3040:	f6c50513          	addi	a0,a0,-148 # 6fa8 <malloc+0x1096>
    3044:	00003097          	auipc	ra,0x3
    3048:	e16080e7          	jalr	-490(ra) # 5e5a <printf>
    exit(1);
    304c:	4505                	li	a0,1
    304e:	00003097          	auipc	ra,0x3
    3052:	a92080e7          	jalr	-1390(ra) # 5ae0 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    3056:	85a6                	mv	a1,s1
    3058:	00004517          	auipc	a0,0x4
    305c:	f9850513          	addi	a0,a0,-104 # 6ff0 <malloc+0x10de>
    3060:	00003097          	auipc	ra,0x3
    3064:	dfa080e7          	jalr	-518(ra) # 5e5a <printf>
    exit(1);
    3068:	4505                	li	a0,1
    306a:	00003097          	auipc	ra,0x3
    306e:	a76080e7          	jalr	-1418(ra) # 5ae0 <exit>
    printf(
    3072:	85a6                	mv	a1,s1
    3074:	00004517          	auipc	a0,0x4
    3078:	fe450513          	addi	a0,a0,-28 # 7058 <malloc+0x1146>
    307c:	00003097          	auipc	ra,0x3
    3080:	dde080e7          	jalr	-546(ra) # 5e5a <printf>
    exit(1);
    3084:	4505                	li	a0,1
    3086:	00003097          	auipc	ra,0x3
    308a:	a5a080e7          	jalr	-1446(ra) # 5ae0 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    308e:	85a6                	mv	a1,s1
    3090:	00004517          	auipc	a0,0x4
    3094:	04050513          	addi	a0,a0,64 # 70d0 <malloc+0x11be>
    3098:	00003097          	auipc	ra,0x3
    309c:	dc2080e7          	jalr	-574(ra) # 5e5a <printf>
    exit(1);
    30a0:	4505                	li	a0,1
    30a2:	00003097          	auipc	ra,0x3
    30a6:	a3e080e7          	jalr	-1474(ra) # 5ae0 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    30aa:	85a6                	mv	a1,s1
    30ac:	00004517          	auipc	a0,0x4
    30b0:	08450513          	addi	a0,a0,132 # 7130 <malloc+0x121e>
    30b4:	00003097          	auipc	ra,0x3
    30b8:	da6080e7          	jalr	-602(ra) # 5e5a <printf>
    exit(1);
    30bc:	4505                	li	a0,1
    30be:	00003097          	auipc	ra,0x3
    30c2:	a22080e7          	jalr	-1502(ra) # 5ae0 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    30c6:	85a6                	mv	a1,s1
    30c8:	00004517          	auipc	a0,0x4
    30cc:	0c050513          	addi	a0,a0,192 # 7188 <malloc+0x1276>
    30d0:	00003097          	auipc	ra,0x3
    30d4:	d8a080e7          	jalr	-630(ra) # 5e5a <printf>
    exit(1);
    30d8:	4505                	li	a0,1
    30da:	00003097          	auipc	ra,0x3
    30de:	a06080e7          	jalr	-1530(ra) # 5ae0 <exit>

00000000000030e2 <diskfull>:
void diskfull(char *s) {
    30e2:	b9010113          	addi	sp,sp,-1136
    30e6:	46113423          	sd	ra,1128(sp)
    30ea:	46813023          	sd	s0,1120(sp)
    30ee:	44913c23          	sd	s1,1112(sp)
    30f2:	45213823          	sd	s2,1104(sp)
    30f6:	45313423          	sd	s3,1096(sp)
    30fa:	45413023          	sd	s4,1088(sp)
    30fe:	43513c23          	sd	s5,1080(sp)
    3102:	43613823          	sd	s6,1072(sp)
    3106:	43713423          	sd	s7,1064(sp)
    310a:	43813023          	sd	s8,1056(sp)
    310e:	47010413          	addi	s0,sp,1136
    3112:	8c2a                	mv	s8,a0
  unlink("diskfulldir");
    3114:	00004517          	auipc	a0,0x4
    3118:	0ac50513          	addi	a0,a0,172 # 71c0 <malloc+0x12ae>
    311c:	00003097          	auipc	ra,0x3
    3120:	a14080e7          	jalr	-1516(ra) # 5b30 <unlink>
  for (fi = 0; done == 0; fi++) {
    3124:	4a01                	li	s4,0
    name[0] = 'b';
    3126:	06200b13          	li	s6,98
    name[1] = 'i';
    312a:	06900a93          	li	s5,105
    name[2] = 'g';
    312e:	06700993          	li	s3,103
    3132:	10c00b93          	li	s7,268
    3136:	aabd                	j	32b4 <diskfull+0x1d2>
      printf("%s: could not create file %s\n", s, name);
    3138:	b9040613          	addi	a2,s0,-1136
    313c:	85e2                	mv	a1,s8
    313e:	00004517          	auipc	a0,0x4
    3142:	09250513          	addi	a0,a0,146 # 71d0 <malloc+0x12be>
    3146:	00003097          	auipc	ra,0x3
    314a:	d14080e7          	jalr	-748(ra) # 5e5a <printf>
      break;
    314e:	a821                	j	3166 <diskfull+0x84>
        close(fd);
    3150:	854a                	mv	a0,s2
    3152:	00003097          	auipc	ra,0x3
    3156:	9b6080e7          	jalr	-1610(ra) # 5b08 <close>
    close(fd);
    315a:	854a                	mv	a0,s2
    315c:	00003097          	auipc	ra,0x3
    3160:	9ac080e7          	jalr	-1620(ra) # 5b08 <close>
  for (fi = 0; done == 0; fi++) {
    3164:	2a05                	addiw	s4,s4,1
  for (int i = 0; i < nzz; i++) {
    3166:	4481                	li	s1,0
    name[0] = 'z';
    3168:	07a00913          	li	s2,122
  for (int i = 0; i < nzz; i++) {
    316c:	08000993          	li	s3,128
    name[0] = 'z';
    3170:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    3174:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    3178:	41f4d71b          	sraiw	a4,s1,0x1f
    317c:	01b7571b          	srliw	a4,a4,0x1b
    3180:	009707bb          	addw	a5,a4,s1
    3184:	4057d69b          	sraiw	a3,a5,0x5
    3188:	0306869b          	addiw	a3,a3,48
    318c:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3190:	8bfd                	andi	a5,a5,31
    3192:	9f99                	subw	a5,a5,a4
    3194:	0307879b          	addiw	a5,a5,48
    3198:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    319c:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    31a0:	bb040513          	addi	a0,s0,-1104
    31a4:	00003097          	auipc	ra,0x3
    31a8:	98c080e7          	jalr	-1652(ra) # 5b30 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    31ac:	60200593          	li	a1,1538
    31b0:	bb040513          	addi	a0,s0,-1104
    31b4:	00003097          	auipc	ra,0x3
    31b8:	96c080e7          	jalr	-1684(ra) # 5b20 <open>
    if (fd < 0) break;
    31bc:	00054963          	bltz	a0,31ce <diskfull+0xec>
    close(fd);
    31c0:	00003097          	auipc	ra,0x3
    31c4:	948080e7          	jalr	-1720(ra) # 5b08 <close>
  for (int i = 0; i < nzz; i++) {
    31c8:	2485                	addiw	s1,s1,1
    31ca:	fb3493e3          	bne	s1,s3,3170 <diskfull+0x8e>
  if (mkdir("diskfulldir") == 0)
    31ce:	00004517          	auipc	a0,0x4
    31d2:	ff250513          	addi	a0,a0,-14 # 71c0 <malloc+0x12ae>
    31d6:	00003097          	auipc	ra,0x3
    31da:	972080e7          	jalr	-1678(ra) # 5b48 <mkdir>
    31de:	12050963          	beqz	a0,3310 <diskfull+0x22e>
  unlink("diskfulldir");
    31e2:	00004517          	auipc	a0,0x4
    31e6:	fde50513          	addi	a0,a0,-34 # 71c0 <malloc+0x12ae>
    31ea:	00003097          	auipc	ra,0x3
    31ee:	946080e7          	jalr	-1722(ra) # 5b30 <unlink>
  for (int i = 0; i < nzz; i++) {
    31f2:	4481                	li	s1,0
    name[0] = 'z';
    31f4:	07a00913          	li	s2,122
  for (int i = 0; i < nzz; i++) {
    31f8:	08000993          	li	s3,128
    name[0] = 'z';
    31fc:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    3200:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    3204:	41f4d71b          	sraiw	a4,s1,0x1f
    3208:	01b7571b          	srliw	a4,a4,0x1b
    320c:	009707bb          	addw	a5,a4,s1
    3210:	4057d69b          	sraiw	a3,a5,0x5
    3214:	0306869b          	addiw	a3,a3,48
    3218:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    321c:	8bfd                	andi	a5,a5,31
    321e:	9f99                	subw	a5,a5,a4
    3220:	0307879b          	addiw	a5,a5,48
    3224:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3228:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    322c:	bb040513          	addi	a0,s0,-1104
    3230:	00003097          	auipc	ra,0x3
    3234:	900080e7          	jalr	-1792(ra) # 5b30 <unlink>
  for (int i = 0; i < nzz; i++) {
    3238:	2485                	addiw	s1,s1,1
    323a:	fd3491e3          	bne	s1,s3,31fc <diskfull+0x11a>
  for (int i = 0; i < fi; i++) {
    323e:	03405e63          	blez	s4,327a <diskfull+0x198>
    3242:	4481                	li	s1,0
    name[0] = 'b';
    3244:	06200a93          	li	s5,98
    name[1] = 'i';
    3248:	06900993          	li	s3,105
    name[2] = 'g';
    324c:	06700913          	li	s2,103
    name[0] = 'b';
    3250:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    3254:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    3258:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    325c:	0304879b          	addiw	a5,s1,48
    3260:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3264:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3268:	bb040513          	addi	a0,s0,-1104
    326c:	00003097          	auipc	ra,0x3
    3270:	8c4080e7          	jalr	-1852(ra) # 5b30 <unlink>
  for (int i = 0; i < fi; i++) {
    3274:	2485                	addiw	s1,s1,1
    3276:	fd449de3          	bne	s1,s4,3250 <diskfull+0x16e>
}
    327a:	46813083          	ld	ra,1128(sp)
    327e:	46013403          	ld	s0,1120(sp)
    3282:	45813483          	ld	s1,1112(sp)
    3286:	45013903          	ld	s2,1104(sp)
    328a:	44813983          	ld	s3,1096(sp)
    328e:	44013a03          	ld	s4,1088(sp)
    3292:	43813a83          	ld	s5,1080(sp)
    3296:	43013b03          	ld	s6,1072(sp)
    329a:	42813b83          	ld	s7,1064(sp)
    329e:	42013c03          	ld	s8,1056(sp)
    32a2:	47010113          	addi	sp,sp,1136
    32a6:	8082                	ret
    close(fd);
    32a8:	854a                	mv	a0,s2
    32aa:	00003097          	auipc	ra,0x3
    32ae:	85e080e7          	jalr	-1954(ra) # 5b08 <close>
  for (fi = 0; done == 0; fi++) {
    32b2:	2a05                	addiw	s4,s4,1
    name[0] = 'b';
    32b4:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    32b8:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    32bc:	b9340923          	sb	s3,-1134(s0)
    name[3] = '0' + fi;
    32c0:	030a079b          	addiw	a5,s4,48
    32c4:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    32c8:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    32cc:	b9040513          	addi	a0,s0,-1136
    32d0:	00003097          	auipc	ra,0x3
    32d4:	860080e7          	jalr	-1952(ra) # 5b30 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    32d8:	60200593          	li	a1,1538
    32dc:	b9040513          	addi	a0,s0,-1136
    32e0:	00003097          	auipc	ra,0x3
    32e4:	840080e7          	jalr	-1984(ra) # 5b20 <open>
    32e8:	892a                	mv	s2,a0
    if (fd < 0) {
    32ea:	e40547e3          	bltz	a0,3138 <diskfull+0x56>
    32ee:	84de                	mv	s1,s7
      if (write(fd, buf, BSIZE) != BSIZE) {
    32f0:	40000613          	li	a2,1024
    32f4:	bb040593          	addi	a1,s0,-1104
    32f8:	854a                	mv	a0,s2
    32fa:	00003097          	auipc	ra,0x3
    32fe:	806080e7          	jalr	-2042(ra) # 5b00 <write>
    3302:	40000793          	li	a5,1024
    3306:	e4f515e3          	bne	a0,a5,3150 <diskfull+0x6e>
    for (int i = 0; i < MAXFILE; i++) {
    330a:	34fd                	addiw	s1,s1,-1
    330c:	f0f5                	bnez	s1,32f0 <diskfull+0x20e>
    330e:	bf69                	j	32a8 <diskfull+0x1c6>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    3310:	00004517          	auipc	a0,0x4
    3314:	ee050513          	addi	a0,a0,-288 # 71f0 <malloc+0x12de>
    3318:	00003097          	auipc	ra,0x3
    331c:	b42080e7          	jalr	-1214(ra) # 5e5a <printf>
    3320:	b5c9                	j	31e2 <diskfull+0x100>

0000000000003322 <iputtest>:
void iputtest(char *s) {
    3322:	1101                	addi	sp,sp,-32
    3324:	ec06                	sd	ra,24(sp)
    3326:	e822                	sd	s0,16(sp)
    3328:	e426                	sd	s1,8(sp)
    332a:	1000                	addi	s0,sp,32
    332c:	84aa                	mv	s1,a0
  if (mkdir("iputdir") < 0) {
    332e:	00004517          	auipc	a0,0x4
    3332:	ef250513          	addi	a0,a0,-270 # 7220 <malloc+0x130e>
    3336:	00003097          	auipc	ra,0x3
    333a:	812080e7          	jalr	-2030(ra) # 5b48 <mkdir>
    333e:	04054563          	bltz	a0,3388 <iputtest+0x66>
  if (chdir("iputdir") < 0) {
    3342:	00004517          	auipc	a0,0x4
    3346:	ede50513          	addi	a0,a0,-290 # 7220 <malloc+0x130e>
    334a:	00003097          	auipc	ra,0x3
    334e:	806080e7          	jalr	-2042(ra) # 5b50 <chdir>
    3352:	04054963          	bltz	a0,33a4 <iputtest+0x82>
  if (unlink("../iputdir") < 0) {
    3356:	00004517          	auipc	a0,0x4
    335a:	f0a50513          	addi	a0,a0,-246 # 7260 <malloc+0x134e>
    335e:	00002097          	auipc	ra,0x2
    3362:	7d2080e7          	jalr	2002(ra) # 5b30 <unlink>
    3366:	04054d63          	bltz	a0,33c0 <iputtest+0x9e>
  if (chdir("/") < 0) {
    336a:	00004517          	auipc	a0,0x4
    336e:	f2650513          	addi	a0,a0,-218 # 7290 <malloc+0x137e>
    3372:	00002097          	auipc	ra,0x2
    3376:	7de080e7          	jalr	2014(ra) # 5b50 <chdir>
    337a:	06054163          	bltz	a0,33dc <iputtest+0xba>
}
    337e:	60e2                	ld	ra,24(sp)
    3380:	6442                	ld	s0,16(sp)
    3382:	64a2                	ld	s1,8(sp)
    3384:	6105                	addi	sp,sp,32
    3386:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3388:	85a6                	mv	a1,s1
    338a:	00004517          	auipc	a0,0x4
    338e:	e9e50513          	addi	a0,a0,-354 # 7228 <malloc+0x1316>
    3392:	00003097          	auipc	ra,0x3
    3396:	ac8080e7          	jalr	-1336(ra) # 5e5a <printf>
    exit(1);
    339a:	4505                	li	a0,1
    339c:	00002097          	auipc	ra,0x2
    33a0:	744080e7          	jalr	1860(ra) # 5ae0 <exit>
    printf("%s: chdir iputdir failed\n", s);
    33a4:	85a6                	mv	a1,s1
    33a6:	00004517          	auipc	a0,0x4
    33aa:	e9a50513          	addi	a0,a0,-358 # 7240 <malloc+0x132e>
    33ae:	00003097          	auipc	ra,0x3
    33b2:	aac080e7          	jalr	-1364(ra) # 5e5a <printf>
    exit(1);
    33b6:	4505                	li	a0,1
    33b8:	00002097          	auipc	ra,0x2
    33bc:	728080e7          	jalr	1832(ra) # 5ae0 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    33c0:	85a6                	mv	a1,s1
    33c2:	00004517          	auipc	a0,0x4
    33c6:	eae50513          	addi	a0,a0,-338 # 7270 <malloc+0x135e>
    33ca:	00003097          	auipc	ra,0x3
    33ce:	a90080e7          	jalr	-1392(ra) # 5e5a <printf>
    exit(1);
    33d2:	4505                	li	a0,1
    33d4:	00002097          	auipc	ra,0x2
    33d8:	70c080e7          	jalr	1804(ra) # 5ae0 <exit>
    printf("%s: chdir / failed\n", s);
    33dc:	85a6                	mv	a1,s1
    33de:	00004517          	auipc	a0,0x4
    33e2:	eba50513          	addi	a0,a0,-326 # 7298 <malloc+0x1386>
    33e6:	00003097          	auipc	ra,0x3
    33ea:	a74080e7          	jalr	-1420(ra) # 5e5a <printf>
    exit(1);
    33ee:	4505                	li	a0,1
    33f0:	00002097          	auipc	ra,0x2
    33f4:	6f0080e7          	jalr	1776(ra) # 5ae0 <exit>

00000000000033f8 <exitiputtest>:
void exitiputtest(char *s) {
    33f8:	7179                	addi	sp,sp,-48
    33fa:	f406                	sd	ra,40(sp)
    33fc:	f022                	sd	s0,32(sp)
    33fe:	ec26                	sd	s1,24(sp)
    3400:	1800                	addi	s0,sp,48
    3402:	84aa                	mv	s1,a0
  pid = fork();
    3404:	00002097          	auipc	ra,0x2
    3408:	6d4080e7          	jalr	1748(ra) # 5ad8 <fork>
  if (pid < 0) {
    340c:	04054663          	bltz	a0,3458 <exitiputtest+0x60>
  if (pid == 0) {
    3410:	ed45                	bnez	a0,34c8 <exitiputtest+0xd0>
    if (mkdir("iputdir") < 0) {
    3412:	00004517          	auipc	a0,0x4
    3416:	e0e50513          	addi	a0,a0,-498 # 7220 <malloc+0x130e>
    341a:	00002097          	auipc	ra,0x2
    341e:	72e080e7          	jalr	1838(ra) # 5b48 <mkdir>
    3422:	04054963          	bltz	a0,3474 <exitiputtest+0x7c>
    if (chdir("iputdir") < 0) {
    3426:	00004517          	auipc	a0,0x4
    342a:	dfa50513          	addi	a0,a0,-518 # 7220 <malloc+0x130e>
    342e:	00002097          	auipc	ra,0x2
    3432:	722080e7          	jalr	1826(ra) # 5b50 <chdir>
    3436:	04054d63          	bltz	a0,3490 <exitiputtest+0x98>
    if (unlink("../iputdir") < 0) {
    343a:	00004517          	auipc	a0,0x4
    343e:	e2650513          	addi	a0,a0,-474 # 7260 <malloc+0x134e>
    3442:	00002097          	auipc	ra,0x2
    3446:	6ee080e7          	jalr	1774(ra) # 5b30 <unlink>
    344a:	06054163          	bltz	a0,34ac <exitiputtest+0xb4>
    exit(0);
    344e:	4501                	li	a0,0
    3450:	00002097          	auipc	ra,0x2
    3454:	690080e7          	jalr	1680(ra) # 5ae0 <exit>
    printf("%s: fork failed\n", s);
    3458:	85a6                	mv	a1,s1
    345a:	00003517          	auipc	a0,0x3
    345e:	47650513          	addi	a0,a0,1142 # 68d0 <malloc+0x9be>
    3462:	00003097          	auipc	ra,0x3
    3466:	9f8080e7          	jalr	-1544(ra) # 5e5a <printf>
    exit(1);
    346a:	4505                	li	a0,1
    346c:	00002097          	auipc	ra,0x2
    3470:	674080e7          	jalr	1652(ra) # 5ae0 <exit>
      printf("%s: mkdir failed\n", s);
    3474:	85a6                	mv	a1,s1
    3476:	00004517          	auipc	a0,0x4
    347a:	db250513          	addi	a0,a0,-590 # 7228 <malloc+0x1316>
    347e:	00003097          	auipc	ra,0x3
    3482:	9dc080e7          	jalr	-1572(ra) # 5e5a <printf>
      exit(1);
    3486:	4505                	li	a0,1
    3488:	00002097          	auipc	ra,0x2
    348c:	658080e7          	jalr	1624(ra) # 5ae0 <exit>
      printf("%s: child chdir failed\n", s);
    3490:	85a6                	mv	a1,s1
    3492:	00004517          	auipc	a0,0x4
    3496:	e1e50513          	addi	a0,a0,-482 # 72b0 <malloc+0x139e>
    349a:	00003097          	auipc	ra,0x3
    349e:	9c0080e7          	jalr	-1600(ra) # 5e5a <printf>
      exit(1);
    34a2:	4505                	li	a0,1
    34a4:	00002097          	auipc	ra,0x2
    34a8:	63c080e7          	jalr	1596(ra) # 5ae0 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    34ac:	85a6                	mv	a1,s1
    34ae:	00004517          	auipc	a0,0x4
    34b2:	dc250513          	addi	a0,a0,-574 # 7270 <malloc+0x135e>
    34b6:	00003097          	auipc	ra,0x3
    34ba:	9a4080e7          	jalr	-1628(ra) # 5e5a <printf>
      exit(1);
    34be:	4505                	li	a0,1
    34c0:	00002097          	auipc	ra,0x2
    34c4:	620080e7          	jalr	1568(ra) # 5ae0 <exit>
  wait(&xstatus);
    34c8:	fdc40513          	addi	a0,s0,-36
    34cc:	00002097          	auipc	ra,0x2
    34d0:	61c080e7          	jalr	1564(ra) # 5ae8 <wait>
  exit(xstatus);
    34d4:	fdc42503          	lw	a0,-36(s0)
    34d8:	00002097          	auipc	ra,0x2
    34dc:	608080e7          	jalr	1544(ra) # 5ae0 <exit>

00000000000034e0 <dirtest>:
void dirtest(char *s) {
    34e0:	1101                	addi	sp,sp,-32
    34e2:	ec06                	sd	ra,24(sp)
    34e4:	e822                	sd	s0,16(sp)
    34e6:	e426                	sd	s1,8(sp)
    34e8:	1000                	addi	s0,sp,32
    34ea:	84aa                	mv	s1,a0
  if (mkdir("dir0") < 0) {
    34ec:	00004517          	auipc	a0,0x4
    34f0:	ddc50513          	addi	a0,a0,-548 # 72c8 <malloc+0x13b6>
    34f4:	00002097          	auipc	ra,0x2
    34f8:	654080e7          	jalr	1620(ra) # 5b48 <mkdir>
    34fc:	04054563          	bltz	a0,3546 <dirtest+0x66>
  if (chdir("dir0") < 0) {
    3500:	00004517          	auipc	a0,0x4
    3504:	dc850513          	addi	a0,a0,-568 # 72c8 <malloc+0x13b6>
    3508:	00002097          	auipc	ra,0x2
    350c:	648080e7          	jalr	1608(ra) # 5b50 <chdir>
    3510:	04054963          	bltz	a0,3562 <dirtest+0x82>
  if (chdir("..") < 0) {
    3514:	00004517          	auipc	a0,0x4
    3518:	dd450513          	addi	a0,a0,-556 # 72e8 <malloc+0x13d6>
    351c:	00002097          	auipc	ra,0x2
    3520:	634080e7          	jalr	1588(ra) # 5b50 <chdir>
    3524:	04054d63          	bltz	a0,357e <dirtest+0x9e>
  if (unlink("dir0") < 0) {
    3528:	00004517          	auipc	a0,0x4
    352c:	da050513          	addi	a0,a0,-608 # 72c8 <malloc+0x13b6>
    3530:	00002097          	auipc	ra,0x2
    3534:	600080e7          	jalr	1536(ra) # 5b30 <unlink>
    3538:	06054163          	bltz	a0,359a <dirtest+0xba>
}
    353c:	60e2                	ld	ra,24(sp)
    353e:	6442                	ld	s0,16(sp)
    3540:	64a2                	ld	s1,8(sp)
    3542:	6105                	addi	sp,sp,32
    3544:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3546:	85a6                	mv	a1,s1
    3548:	00004517          	auipc	a0,0x4
    354c:	ce050513          	addi	a0,a0,-800 # 7228 <malloc+0x1316>
    3550:	00003097          	auipc	ra,0x3
    3554:	90a080e7          	jalr	-1782(ra) # 5e5a <printf>
    exit(1);
    3558:	4505                	li	a0,1
    355a:	00002097          	auipc	ra,0x2
    355e:	586080e7          	jalr	1414(ra) # 5ae0 <exit>
    printf("%s: chdir dir0 failed\n", s);
    3562:	85a6                	mv	a1,s1
    3564:	00004517          	auipc	a0,0x4
    3568:	d6c50513          	addi	a0,a0,-660 # 72d0 <malloc+0x13be>
    356c:	00003097          	auipc	ra,0x3
    3570:	8ee080e7          	jalr	-1810(ra) # 5e5a <printf>
    exit(1);
    3574:	4505                	li	a0,1
    3576:	00002097          	auipc	ra,0x2
    357a:	56a080e7          	jalr	1386(ra) # 5ae0 <exit>
    printf("%s: chdir .. failed\n", s);
    357e:	85a6                	mv	a1,s1
    3580:	00004517          	auipc	a0,0x4
    3584:	d7050513          	addi	a0,a0,-656 # 72f0 <malloc+0x13de>
    3588:	00003097          	auipc	ra,0x3
    358c:	8d2080e7          	jalr	-1838(ra) # 5e5a <printf>
    exit(1);
    3590:	4505                	li	a0,1
    3592:	00002097          	auipc	ra,0x2
    3596:	54e080e7          	jalr	1358(ra) # 5ae0 <exit>
    printf("%s: unlink dir0 failed\n", s);
    359a:	85a6                	mv	a1,s1
    359c:	00004517          	auipc	a0,0x4
    35a0:	d6c50513          	addi	a0,a0,-660 # 7308 <malloc+0x13f6>
    35a4:	00003097          	auipc	ra,0x3
    35a8:	8b6080e7          	jalr	-1866(ra) # 5e5a <printf>
    exit(1);
    35ac:	4505                	li	a0,1
    35ae:	00002097          	auipc	ra,0x2
    35b2:	532080e7          	jalr	1330(ra) # 5ae0 <exit>

00000000000035b6 <subdir>:
void subdir(char *s) {
    35b6:	1101                	addi	sp,sp,-32
    35b8:	ec06                	sd	ra,24(sp)
    35ba:	e822                	sd	s0,16(sp)
    35bc:	e426                	sd	s1,8(sp)
    35be:	e04a                	sd	s2,0(sp)
    35c0:	1000                	addi	s0,sp,32
    35c2:	892a                	mv	s2,a0
  unlink("ff");
    35c4:	00004517          	auipc	a0,0x4
    35c8:	e8c50513          	addi	a0,a0,-372 # 7450 <malloc+0x153e>
    35cc:	00002097          	auipc	ra,0x2
    35d0:	564080e7          	jalr	1380(ra) # 5b30 <unlink>
  if (mkdir("dd") != 0) {
    35d4:	00004517          	auipc	a0,0x4
    35d8:	d4c50513          	addi	a0,a0,-692 # 7320 <malloc+0x140e>
    35dc:	00002097          	auipc	ra,0x2
    35e0:	56c080e7          	jalr	1388(ra) # 5b48 <mkdir>
    35e4:	38051663          	bnez	a0,3970 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    35e8:	20200593          	li	a1,514
    35ec:	00004517          	auipc	a0,0x4
    35f0:	d5450513          	addi	a0,a0,-684 # 7340 <malloc+0x142e>
    35f4:	00002097          	auipc	ra,0x2
    35f8:	52c080e7          	jalr	1324(ra) # 5b20 <open>
    35fc:	84aa                	mv	s1,a0
  if (fd < 0) {
    35fe:	38054763          	bltz	a0,398c <subdir+0x3d6>
  write(fd, "ff", 2);
    3602:	4609                	li	a2,2
    3604:	00004597          	auipc	a1,0x4
    3608:	e4c58593          	addi	a1,a1,-436 # 7450 <malloc+0x153e>
    360c:	00002097          	auipc	ra,0x2
    3610:	4f4080e7          	jalr	1268(ra) # 5b00 <write>
  close(fd);
    3614:	8526                	mv	a0,s1
    3616:	00002097          	auipc	ra,0x2
    361a:	4f2080e7          	jalr	1266(ra) # 5b08 <close>
  if (unlink("dd") >= 0) {
    361e:	00004517          	auipc	a0,0x4
    3622:	d0250513          	addi	a0,a0,-766 # 7320 <malloc+0x140e>
    3626:	00002097          	auipc	ra,0x2
    362a:	50a080e7          	jalr	1290(ra) # 5b30 <unlink>
    362e:	36055d63          	bgez	a0,39a8 <subdir+0x3f2>
  if (mkdir("/dd/dd") != 0) {
    3632:	00004517          	auipc	a0,0x4
    3636:	d6650513          	addi	a0,a0,-666 # 7398 <malloc+0x1486>
    363a:	00002097          	auipc	ra,0x2
    363e:	50e080e7          	jalr	1294(ra) # 5b48 <mkdir>
    3642:	38051163          	bnez	a0,39c4 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3646:	20200593          	li	a1,514
    364a:	00004517          	auipc	a0,0x4
    364e:	d7650513          	addi	a0,a0,-650 # 73c0 <malloc+0x14ae>
    3652:	00002097          	auipc	ra,0x2
    3656:	4ce080e7          	jalr	1230(ra) # 5b20 <open>
    365a:	84aa                	mv	s1,a0
  if (fd < 0) {
    365c:	38054263          	bltz	a0,39e0 <subdir+0x42a>
  write(fd, "FF", 2);
    3660:	4609                	li	a2,2
    3662:	00004597          	auipc	a1,0x4
    3666:	d8e58593          	addi	a1,a1,-626 # 73f0 <malloc+0x14de>
    366a:	00002097          	auipc	ra,0x2
    366e:	496080e7          	jalr	1174(ra) # 5b00 <write>
  close(fd);
    3672:	8526                	mv	a0,s1
    3674:	00002097          	auipc	ra,0x2
    3678:	494080e7          	jalr	1172(ra) # 5b08 <close>
  fd = open("dd/dd/../ff", 0);
    367c:	4581                	li	a1,0
    367e:	00004517          	auipc	a0,0x4
    3682:	d7a50513          	addi	a0,a0,-646 # 73f8 <malloc+0x14e6>
    3686:	00002097          	auipc	ra,0x2
    368a:	49a080e7          	jalr	1178(ra) # 5b20 <open>
    368e:	84aa                	mv	s1,a0
  if (fd < 0) {
    3690:	36054663          	bltz	a0,39fc <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3694:	660d                	lui	a2,0x3
    3696:	00009597          	auipc	a1,0x9
    369a:	5d258593          	addi	a1,a1,1490 # cc68 <buf>
    369e:	00002097          	auipc	ra,0x2
    36a2:	45a080e7          	jalr	1114(ra) # 5af8 <read>
  if (cc != 2 || buf[0] != 'f') {
    36a6:	4789                	li	a5,2
    36a8:	36f51863          	bne	a0,a5,3a18 <subdir+0x462>
    36ac:	00009717          	auipc	a4,0x9
    36b0:	5bc74703          	lbu	a4,1468(a4) # cc68 <buf>
    36b4:	06600793          	li	a5,102
    36b8:	36f71063          	bne	a4,a5,3a18 <subdir+0x462>
  close(fd);
    36bc:	8526                	mv	a0,s1
    36be:	00002097          	auipc	ra,0x2
    36c2:	44a080e7          	jalr	1098(ra) # 5b08 <close>
  if (link("dd/dd/ff", "dd/dd/ffff") != 0) {
    36c6:	00004597          	auipc	a1,0x4
    36ca:	d8258593          	addi	a1,a1,-638 # 7448 <malloc+0x1536>
    36ce:	00004517          	auipc	a0,0x4
    36d2:	cf250513          	addi	a0,a0,-782 # 73c0 <malloc+0x14ae>
    36d6:	00002097          	auipc	ra,0x2
    36da:	46a080e7          	jalr	1130(ra) # 5b40 <link>
    36de:	34051b63          	bnez	a0,3a34 <subdir+0x47e>
  if (unlink("dd/dd/ff") != 0) {
    36e2:	00004517          	auipc	a0,0x4
    36e6:	cde50513          	addi	a0,a0,-802 # 73c0 <malloc+0x14ae>
    36ea:	00002097          	auipc	ra,0x2
    36ee:	446080e7          	jalr	1094(ra) # 5b30 <unlink>
    36f2:	34051f63          	bnez	a0,3a50 <subdir+0x49a>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    36f6:	4581                	li	a1,0
    36f8:	00004517          	auipc	a0,0x4
    36fc:	cc850513          	addi	a0,a0,-824 # 73c0 <malloc+0x14ae>
    3700:	00002097          	auipc	ra,0x2
    3704:	420080e7          	jalr	1056(ra) # 5b20 <open>
    3708:	36055263          	bgez	a0,3a6c <subdir+0x4b6>
  if (chdir("dd") != 0) {
    370c:	00004517          	auipc	a0,0x4
    3710:	c1450513          	addi	a0,a0,-1004 # 7320 <malloc+0x140e>
    3714:	00002097          	auipc	ra,0x2
    3718:	43c080e7          	jalr	1084(ra) # 5b50 <chdir>
    371c:	36051663          	bnez	a0,3a88 <subdir+0x4d2>
  if (chdir("dd/../../dd") != 0) {
    3720:	00004517          	auipc	a0,0x4
    3724:	dc050513          	addi	a0,a0,-576 # 74e0 <malloc+0x15ce>
    3728:	00002097          	auipc	ra,0x2
    372c:	428080e7          	jalr	1064(ra) # 5b50 <chdir>
    3730:	36051a63          	bnez	a0,3aa4 <subdir+0x4ee>
  if (chdir("dd/../../../dd") != 0) {
    3734:	00004517          	auipc	a0,0x4
    3738:	ddc50513          	addi	a0,a0,-548 # 7510 <malloc+0x15fe>
    373c:	00002097          	auipc	ra,0x2
    3740:	414080e7          	jalr	1044(ra) # 5b50 <chdir>
    3744:	36051e63          	bnez	a0,3ac0 <subdir+0x50a>
  if (chdir("./..") != 0) {
    3748:	00004517          	auipc	a0,0x4
    374c:	df850513          	addi	a0,a0,-520 # 7540 <malloc+0x162e>
    3750:	00002097          	auipc	ra,0x2
    3754:	400080e7          	jalr	1024(ra) # 5b50 <chdir>
    3758:	38051263          	bnez	a0,3adc <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    375c:	4581                	li	a1,0
    375e:	00004517          	auipc	a0,0x4
    3762:	cea50513          	addi	a0,a0,-790 # 7448 <malloc+0x1536>
    3766:	00002097          	auipc	ra,0x2
    376a:	3ba080e7          	jalr	954(ra) # 5b20 <open>
    376e:	84aa                	mv	s1,a0
  if (fd < 0) {
    3770:	38054463          	bltz	a0,3af8 <subdir+0x542>
  if (read(fd, buf, sizeof(buf)) != 2) {
    3774:	660d                	lui	a2,0x3
    3776:	00009597          	auipc	a1,0x9
    377a:	4f258593          	addi	a1,a1,1266 # cc68 <buf>
    377e:	00002097          	auipc	ra,0x2
    3782:	37a080e7          	jalr	890(ra) # 5af8 <read>
    3786:	4789                	li	a5,2
    3788:	38f51663          	bne	a0,a5,3b14 <subdir+0x55e>
  close(fd);
    378c:	8526                	mv	a0,s1
    378e:	00002097          	auipc	ra,0x2
    3792:	37a080e7          	jalr	890(ra) # 5b08 <close>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    3796:	4581                	li	a1,0
    3798:	00004517          	auipc	a0,0x4
    379c:	c2850513          	addi	a0,a0,-984 # 73c0 <malloc+0x14ae>
    37a0:	00002097          	auipc	ra,0x2
    37a4:	380080e7          	jalr	896(ra) # 5b20 <open>
    37a8:	38055463          	bgez	a0,3b30 <subdir+0x57a>
  if (open("dd/ff/ff", O_CREATE | O_RDWR) >= 0) {
    37ac:	20200593          	li	a1,514
    37b0:	00004517          	auipc	a0,0x4
    37b4:	e2050513          	addi	a0,a0,-480 # 75d0 <malloc+0x16be>
    37b8:	00002097          	auipc	ra,0x2
    37bc:	368080e7          	jalr	872(ra) # 5b20 <open>
    37c0:	38055663          	bgez	a0,3b4c <subdir+0x596>
  if (open("dd/xx/ff", O_CREATE | O_RDWR) >= 0) {
    37c4:	20200593          	li	a1,514
    37c8:	00004517          	auipc	a0,0x4
    37cc:	e3850513          	addi	a0,a0,-456 # 7600 <malloc+0x16ee>
    37d0:	00002097          	auipc	ra,0x2
    37d4:	350080e7          	jalr	848(ra) # 5b20 <open>
    37d8:	38055863          	bgez	a0,3b68 <subdir+0x5b2>
  if (open("dd", O_CREATE) >= 0) {
    37dc:	20000593          	li	a1,512
    37e0:	00004517          	auipc	a0,0x4
    37e4:	b4050513          	addi	a0,a0,-1216 # 7320 <malloc+0x140e>
    37e8:	00002097          	auipc	ra,0x2
    37ec:	338080e7          	jalr	824(ra) # 5b20 <open>
    37f0:	38055a63          	bgez	a0,3b84 <subdir+0x5ce>
  if (open("dd", O_RDWR) >= 0) {
    37f4:	4589                	li	a1,2
    37f6:	00004517          	auipc	a0,0x4
    37fa:	b2a50513          	addi	a0,a0,-1238 # 7320 <malloc+0x140e>
    37fe:	00002097          	auipc	ra,0x2
    3802:	322080e7          	jalr	802(ra) # 5b20 <open>
    3806:	38055d63          	bgez	a0,3ba0 <subdir+0x5ea>
  if (open("dd", O_WRONLY) >= 0) {
    380a:	4585                	li	a1,1
    380c:	00004517          	auipc	a0,0x4
    3810:	b1450513          	addi	a0,a0,-1260 # 7320 <malloc+0x140e>
    3814:	00002097          	auipc	ra,0x2
    3818:	30c080e7          	jalr	780(ra) # 5b20 <open>
    381c:	3a055063          	bgez	a0,3bbc <subdir+0x606>
  if (link("dd/ff/ff", "dd/dd/xx") == 0) {
    3820:	00004597          	auipc	a1,0x4
    3824:	e7058593          	addi	a1,a1,-400 # 7690 <malloc+0x177e>
    3828:	00004517          	auipc	a0,0x4
    382c:	da850513          	addi	a0,a0,-600 # 75d0 <malloc+0x16be>
    3830:	00002097          	auipc	ra,0x2
    3834:	310080e7          	jalr	784(ra) # 5b40 <link>
    3838:	3a050063          	beqz	a0,3bd8 <subdir+0x622>
  if (link("dd/xx/ff", "dd/dd/xx") == 0) {
    383c:	00004597          	auipc	a1,0x4
    3840:	e5458593          	addi	a1,a1,-428 # 7690 <malloc+0x177e>
    3844:	00004517          	auipc	a0,0x4
    3848:	dbc50513          	addi	a0,a0,-580 # 7600 <malloc+0x16ee>
    384c:	00002097          	auipc	ra,0x2
    3850:	2f4080e7          	jalr	756(ra) # 5b40 <link>
    3854:	3a050063          	beqz	a0,3bf4 <subdir+0x63e>
  if (link("dd/ff", "dd/dd/ffff") == 0) {
    3858:	00004597          	auipc	a1,0x4
    385c:	bf058593          	addi	a1,a1,-1040 # 7448 <malloc+0x1536>
    3860:	00004517          	auipc	a0,0x4
    3864:	ae050513          	addi	a0,a0,-1312 # 7340 <malloc+0x142e>
    3868:	00002097          	auipc	ra,0x2
    386c:	2d8080e7          	jalr	728(ra) # 5b40 <link>
    3870:	3a050063          	beqz	a0,3c10 <subdir+0x65a>
  if (mkdir("dd/ff/ff") == 0) {
    3874:	00004517          	auipc	a0,0x4
    3878:	d5c50513          	addi	a0,a0,-676 # 75d0 <malloc+0x16be>
    387c:	00002097          	auipc	ra,0x2
    3880:	2cc080e7          	jalr	716(ra) # 5b48 <mkdir>
    3884:	3a050463          	beqz	a0,3c2c <subdir+0x676>
  if (mkdir("dd/xx/ff") == 0) {
    3888:	00004517          	auipc	a0,0x4
    388c:	d7850513          	addi	a0,a0,-648 # 7600 <malloc+0x16ee>
    3890:	00002097          	auipc	ra,0x2
    3894:	2b8080e7          	jalr	696(ra) # 5b48 <mkdir>
    3898:	3a050863          	beqz	a0,3c48 <subdir+0x692>
  if (mkdir("dd/dd/ffff") == 0) {
    389c:	00004517          	auipc	a0,0x4
    38a0:	bac50513          	addi	a0,a0,-1108 # 7448 <malloc+0x1536>
    38a4:	00002097          	auipc	ra,0x2
    38a8:	2a4080e7          	jalr	676(ra) # 5b48 <mkdir>
    38ac:	3a050c63          	beqz	a0,3c64 <subdir+0x6ae>
  if (unlink("dd/xx/ff") == 0) {
    38b0:	00004517          	auipc	a0,0x4
    38b4:	d5050513          	addi	a0,a0,-688 # 7600 <malloc+0x16ee>
    38b8:	00002097          	auipc	ra,0x2
    38bc:	278080e7          	jalr	632(ra) # 5b30 <unlink>
    38c0:	3c050063          	beqz	a0,3c80 <subdir+0x6ca>
  if (unlink("dd/ff/ff") == 0) {
    38c4:	00004517          	auipc	a0,0x4
    38c8:	d0c50513          	addi	a0,a0,-756 # 75d0 <malloc+0x16be>
    38cc:	00002097          	auipc	ra,0x2
    38d0:	264080e7          	jalr	612(ra) # 5b30 <unlink>
    38d4:	3c050463          	beqz	a0,3c9c <subdir+0x6e6>
  if (chdir("dd/ff") == 0) {
    38d8:	00004517          	auipc	a0,0x4
    38dc:	a6850513          	addi	a0,a0,-1432 # 7340 <malloc+0x142e>
    38e0:	00002097          	auipc	ra,0x2
    38e4:	270080e7          	jalr	624(ra) # 5b50 <chdir>
    38e8:	3c050863          	beqz	a0,3cb8 <subdir+0x702>
  if (chdir("dd/xx") == 0) {
    38ec:	00004517          	auipc	a0,0x4
    38f0:	ef450513          	addi	a0,a0,-268 # 77e0 <malloc+0x18ce>
    38f4:	00002097          	auipc	ra,0x2
    38f8:	25c080e7          	jalr	604(ra) # 5b50 <chdir>
    38fc:	3c050c63          	beqz	a0,3cd4 <subdir+0x71e>
  if (unlink("dd/dd/ffff") != 0) {
    3900:	00004517          	auipc	a0,0x4
    3904:	b4850513          	addi	a0,a0,-1208 # 7448 <malloc+0x1536>
    3908:	00002097          	auipc	ra,0x2
    390c:	228080e7          	jalr	552(ra) # 5b30 <unlink>
    3910:	3e051063          	bnez	a0,3cf0 <subdir+0x73a>
  if (unlink("dd/ff") != 0) {
    3914:	00004517          	auipc	a0,0x4
    3918:	a2c50513          	addi	a0,a0,-1492 # 7340 <malloc+0x142e>
    391c:	00002097          	auipc	ra,0x2
    3920:	214080e7          	jalr	532(ra) # 5b30 <unlink>
    3924:	3e051463          	bnez	a0,3d0c <subdir+0x756>
  if (unlink("dd") == 0) {
    3928:	00004517          	auipc	a0,0x4
    392c:	9f850513          	addi	a0,a0,-1544 # 7320 <malloc+0x140e>
    3930:	00002097          	auipc	ra,0x2
    3934:	200080e7          	jalr	512(ra) # 5b30 <unlink>
    3938:	3e050863          	beqz	a0,3d28 <subdir+0x772>
  if (unlink("dd/dd") < 0) {
    393c:	00004517          	auipc	a0,0x4
    3940:	f1450513          	addi	a0,a0,-236 # 7850 <malloc+0x193e>
    3944:	00002097          	auipc	ra,0x2
    3948:	1ec080e7          	jalr	492(ra) # 5b30 <unlink>
    394c:	3e054c63          	bltz	a0,3d44 <subdir+0x78e>
  if (unlink("dd") < 0) {
    3950:	00004517          	auipc	a0,0x4
    3954:	9d050513          	addi	a0,a0,-1584 # 7320 <malloc+0x140e>
    3958:	00002097          	auipc	ra,0x2
    395c:	1d8080e7          	jalr	472(ra) # 5b30 <unlink>
    3960:	40054063          	bltz	a0,3d60 <subdir+0x7aa>
}
    3964:	60e2                	ld	ra,24(sp)
    3966:	6442                	ld	s0,16(sp)
    3968:	64a2                	ld	s1,8(sp)
    396a:	6902                	ld	s2,0(sp)
    396c:	6105                	addi	sp,sp,32
    396e:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3970:	85ca                	mv	a1,s2
    3972:	00004517          	auipc	a0,0x4
    3976:	9b650513          	addi	a0,a0,-1610 # 7328 <malloc+0x1416>
    397a:	00002097          	auipc	ra,0x2
    397e:	4e0080e7          	jalr	1248(ra) # 5e5a <printf>
    exit(1);
    3982:	4505                	li	a0,1
    3984:	00002097          	auipc	ra,0x2
    3988:	15c080e7          	jalr	348(ra) # 5ae0 <exit>
    printf("%s: create dd/ff failed\n", s);
    398c:	85ca                	mv	a1,s2
    398e:	00004517          	auipc	a0,0x4
    3992:	9ba50513          	addi	a0,a0,-1606 # 7348 <malloc+0x1436>
    3996:	00002097          	auipc	ra,0x2
    399a:	4c4080e7          	jalr	1220(ra) # 5e5a <printf>
    exit(1);
    399e:	4505                	li	a0,1
    39a0:	00002097          	auipc	ra,0x2
    39a4:	140080e7          	jalr	320(ra) # 5ae0 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    39a8:	85ca                	mv	a1,s2
    39aa:	00004517          	auipc	a0,0x4
    39ae:	9be50513          	addi	a0,a0,-1602 # 7368 <malloc+0x1456>
    39b2:	00002097          	auipc	ra,0x2
    39b6:	4a8080e7          	jalr	1192(ra) # 5e5a <printf>
    exit(1);
    39ba:	4505                	li	a0,1
    39bc:	00002097          	auipc	ra,0x2
    39c0:	124080e7          	jalr	292(ra) # 5ae0 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    39c4:	85ca                	mv	a1,s2
    39c6:	00004517          	auipc	a0,0x4
    39ca:	9da50513          	addi	a0,a0,-1574 # 73a0 <malloc+0x148e>
    39ce:	00002097          	auipc	ra,0x2
    39d2:	48c080e7          	jalr	1164(ra) # 5e5a <printf>
    exit(1);
    39d6:	4505                	li	a0,1
    39d8:	00002097          	auipc	ra,0x2
    39dc:	108080e7          	jalr	264(ra) # 5ae0 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    39e0:	85ca                	mv	a1,s2
    39e2:	00004517          	auipc	a0,0x4
    39e6:	9ee50513          	addi	a0,a0,-1554 # 73d0 <malloc+0x14be>
    39ea:	00002097          	auipc	ra,0x2
    39ee:	470080e7          	jalr	1136(ra) # 5e5a <printf>
    exit(1);
    39f2:	4505                	li	a0,1
    39f4:	00002097          	auipc	ra,0x2
    39f8:	0ec080e7          	jalr	236(ra) # 5ae0 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    39fc:	85ca                	mv	a1,s2
    39fe:	00004517          	auipc	a0,0x4
    3a02:	a0a50513          	addi	a0,a0,-1526 # 7408 <malloc+0x14f6>
    3a06:	00002097          	auipc	ra,0x2
    3a0a:	454080e7          	jalr	1108(ra) # 5e5a <printf>
    exit(1);
    3a0e:	4505                	li	a0,1
    3a10:	00002097          	auipc	ra,0x2
    3a14:	0d0080e7          	jalr	208(ra) # 5ae0 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3a18:	85ca                	mv	a1,s2
    3a1a:	00004517          	auipc	a0,0x4
    3a1e:	a0e50513          	addi	a0,a0,-1522 # 7428 <malloc+0x1516>
    3a22:	00002097          	auipc	ra,0x2
    3a26:	438080e7          	jalr	1080(ra) # 5e5a <printf>
    exit(1);
    3a2a:	4505                	li	a0,1
    3a2c:	00002097          	auipc	ra,0x2
    3a30:	0b4080e7          	jalr	180(ra) # 5ae0 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3a34:	85ca                	mv	a1,s2
    3a36:	00004517          	auipc	a0,0x4
    3a3a:	a2250513          	addi	a0,a0,-1502 # 7458 <malloc+0x1546>
    3a3e:	00002097          	auipc	ra,0x2
    3a42:	41c080e7          	jalr	1052(ra) # 5e5a <printf>
    exit(1);
    3a46:	4505                	li	a0,1
    3a48:	00002097          	auipc	ra,0x2
    3a4c:	098080e7          	jalr	152(ra) # 5ae0 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3a50:	85ca                	mv	a1,s2
    3a52:	00004517          	auipc	a0,0x4
    3a56:	a2e50513          	addi	a0,a0,-1490 # 7480 <malloc+0x156e>
    3a5a:	00002097          	auipc	ra,0x2
    3a5e:	400080e7          	jalr	1024(ra) # 5e5a <printf>
    exit(1);
    3a62:	4505                	li	a0,1
    3a64:	00002097          	auipc	ra,0x2
    3a68:	07c080e7          	jalr	124(ra) # 5ae0 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3a6c:	85ca                	mv	a1,s2
    3a6e:	00004517          	auipc	a0,0x4
    3a72:	a3250513          	addi	a0,a0,-1486 # 74a0 <malloc+0x158e>
    3a76:	00002097          	auipc	ra,0x2
    3a7a:	3e4080e7          	jalr	996(ra) # 5e5a <printf>
    exit(1);
    3a7e:	4505                	li	a0,1
    3a80:	00002097          	auipc	ra,0x2
    3a84:	060080e7          	jalr	96(ra) # 5ae0 <exit>
    printf("%s: chdir dd failed\n", s);
    3a88:	85ca                	mv	a1,s2
    3a8a:	00004517          	auipc	a0,0x4
    3a8e:	a3e50513          	addi	a0,a0,-1474 # 74c8 <malloc+0x15b6>
    3a92:	00002097          	auipc	ra,0x2
    3a96:	3c8080e7          	jalr	968(ra) # 5e5a <printf>
    exit(1);
    3a9a:	4505                	li	a0,1
    3a9c:	00002097          	auipc	ra,0x2
    3aa0:	044080e7          	jalr	68(ra) # 5ae0 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3aa4:	85ca                	mv	a1,s2
    3aa6:	00004517          	auipc	a0,0x4
    3aaa:	a4a50513          	addi	a0,a0,-1462 # 74f0 <malloc+0x15de>
    3aae:	00002097          	auipc	ra,0x2
    3ab2:	3ac080e7          	jalr	940(ra) # 5e5a <printf>
    exit(1);
    3ab6:	4505                	li	a0,1
    3ab8:	00002097          	auipc	ra,0x2
    3abc:	028080e7          	jalr	40(ra) # 5ae0 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3ac0:	85ca                	mv	a1,s2
    3ac2:	00004517          	auipc	a0,0x4
    3ac6:	a5e50513          	addi	a0,a0,-1442 # 7520 <malloc+0x160e>
    3aca:	00002097          	auipc	ra,0x2
    3ace:	390080e7          	jalr	912(ra) # 5e5a <printf>
    exit(1);
    3ad2:	4505                	li	a0,1
    3ad4:	00002097          	auipc	ra,0x2
    3ad8:	00c080e7          	jalr	12(ra) # 5ae0 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3adc:	85ca                	mv	a1,s2
    3ade:	00004517          	auipc	a0,0x4
    3ae2:	a6a50513          	addi	a0,a0,-1430 # 7548 <malloc+0x1636>
    3ae6:	00002097          	auipc	ra,0x2
    3aea:	374080e7          	jalr	884(ra) # 5e5a <printf>
    exit(1);
    3aee:	4505                	li	a0,1
    3af0:	00002097          	auipc	ra,0x2
    3af4:	ff0080e7          	jalr	-16(ra) # 5ae0 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3af8:	85ca                	mv	a1,s2
    3afa:	00004517          	auipc	a0,0x4
    3afe:	a6650513          	addi	a0,a0,-1434 # 7560 <malloc+0x164e>
    3b02:	00002097          	auipc	ra,0x2
    3b06:	358080e7          	jalr	856(ra) # 5e5a <printf>
    exit(1);
    3b0a:	4505                	li	a0,1
    3b0c:	00002097          	auipc	ra,0x2
    3b10:	fd4080e7          	jalr	-44(ra) # 5ae0 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3b14:	85ca                	mv	a1,s2
    3b16:	00004517          	auipc	a0,0x4
    3b1a:	a6a50513          	addi	a0,a0,-1430 # 7580 <malloc+0x166e>
    3b1e:	00002097          	auipc	ra,0x2
    3b22:	33c080e7          	jalr	828(ra) # 5e5a <printf>
    exit(1);
    3b26:	4505                	li	a0,1
    3b28:	00002097          	auipc	ra,0x2
    3b2c:	fb8080e7          	jalr	-72(ra) # 5ae0 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3b30:	85ca                	mv	a1,s2
    3b32:	00004517          	auipc	a0,0x4
    3b36:	a6e50513          	addi	a0,a0,-1426 # 75a0 <malloc+0x168e>
    3b3a:	00002097          	auipc	ra,0x2
    3b3e:	320080e7          	jalr	800(ra) # 5e5a <printf>
    exit(1);
    3b42:	4505                	li	a0,1
    3b44:	00002097          	auipc	ra,0x2
    3b48:	f9c080e7          	jalr	-100(ra) # 5ae0 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3b4c:	85ca                	mv	a1,s2
    3b4e:	00004517          	auipc	a0,0x4
    3b52:	a9250513          	addi	a0,a0,-1390 # 75e0 <malloc+0x16ce>
    3b56:	00002097          	auipc	ra,0x2
    3b5a:	304080e7          	jalr	772(ra) # 5e5a <printf>
    exit(1);
    3b5e:	4505                	li	a0,1
    3b60:	00002097          	auipc	ra,0x2
    3b64:	f80080e7          	jalr	-128(ra) # 5ae0 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3b68:	85ca                	mv	a1,s2
    3b6a:	00004517          	auipc	a0,0x4
    3b6e:	aa650513          	addi	a0,a0,-1370 # 7610 <malloc+0x16fe>
    3b72:	00002097          	auipc	ra,0x2
    3b76:	2e8080e7          	jalr	744(ra) # 5e5a <printf>
    exit(1);
    3b7a:	4505                	li	a0,1
    3b7c:	00002097          	auipc	ra,0x2
    3b80:	f64080e7          	jalr	-156(ra) # 5ae0 <exit>
    printf("%s: create dd succeeded!\n", s);
    3b84:	85ca                	mv	a1,s2
    3b86:	00004517          	auipc	a0,0x4
    3b8a:	aaa50513          	addi	a0,a0,-1366 # 7630 <malloc+0x171e>
    3b8e:	00002097          	auipc	ra,0x2
    3b92:	2cc080e7          	jalr	716(ra) # 5e5a <printf>
    exit(1);
    3b96:	4505                	li	a0,1
    3b98:	00002097          	auipc	ra,0x2
    3b9c:	f48080e7          	jalr	-184(ra) # 5ae0 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3ba0:	85ca                	mv	a1,s2
    3ba2:	00004517          	auipc	a0,0x4
    3ba6:	aae50513          	addi	a0,a0,-1362 # 7650 <malloc+0x173e>
    3baa:	00002097          	auipc	ra,0x2
    3bae:	2b0080e7          	jalr	688(ra) # 5e5a <printf>
    exit(1);
    3bb2:	4505                	li	a0,1
    3bb4:	00002097          	auipc	ra,0x2
    3bb8:	f2c080e7          	jalr	-212(ra) # 5ae0 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3bbc:	85ca                	mv	a1,s2
    3bbe:	00004517          	auipc	a0,0x4
    3bc2:	ab250513          	addi	a0,a0,-1358 # 7670 <malloc+0x175e>
    3bc6:	00002097          	auipc	ra,0x2
    3bca:	294080e7          	jalr	660(ra) # 5e5a <printf>
    exit(1);
    3bce:	4505                	li	a0,1
    3bd0:	00002097          	auipc	ra,0x2
    3bd4:	f10080e7          	jalr	-240(ra) # 5ae0 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3bd8:	85ca                	mv	a1,s2
    3bda:	00004517          	auipc	a0,0x4
    3bde:	ac650513          	addi	a0,a0,-1338 # 76a0 <malloc+0x178e>
    3be2:	00002097          	auipc	ra,0x2
    3be6:	278080e7          	jalr	632(ra) # 5e5a <printf>
    exit(1);
    3bea:	4505                	li	a0,1
    3bec:	00002097          	auipc	ra,0x2
    3bf0:	ef4080e7          	jalr	-268(ra) # 5ae0 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3bf4:	85ca                	mv	a1,s2
    3bf6:	00004517          	auipc	a0,0x4
    3bfa:	ad250513          	addi	a0,a0,-1326 # 76c8 <malloc+0x17b6>
    3bfe:	00002097          	auipc	ra,0x2
    3c02:	25c080e7          	jalr	604(ra) # 5e5a <printf>
    exit(1);
    3c06:	4505                	li	a0,1
    3c08:	00002097          	auipc	ra,0x2
    3c0c:	ed8080e7          	jalr	-296(ra) # 5ae0 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3c10:	85ca                	mv	a1,s2
    3c12:	00004517          	auipc	a0,0x4
    3c16:	ade50513          	addi	a0,a0,-1314 # 76f0 <malloc+0x17de>
    3c1a:	00002097          	auipc	ra,0x2
    3c1e:	240080e7          	jalr	576(ra) # 5e5a <printf>
    exit(1);
    3c22:	4505                	li	a0,1
    3c24:	00002097          	auipc	ra,0x2
    3c28:	ebc080e7          	jalr	-324(ra) # 5ae0 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3c2c:	85ca                	mv	a1,s2
    3c2e:	00004517          	auipc	a0,0x4
    3c32:	aea50513          	addi	a0,a0,-1302 # 7718 <malloc+0x1806>
    3c36:	00002097          	auipc	ra,0x2
    3c3a:	224080e7          	jalr	548(ra) # 5e5a <printf>
    exit(1);
    3c3e:	4505                	li	a0,1
    3c40:	00002097          	auipc	ra,0x2
    3c44:	ea0080e7          	jalr	-352(ra) # 5ae0 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3c48:	85ca                	mv	a1,s2
    3c4a:	00004517          	auipc	a0,0x4
    3c4e:	aee50513          	addi	a0,a0,-1298 # 7738 <malloc+0x1826>
    3c52:	00002097          	auipc	ra,0x2
    3c56:	208080e7          	jalr	520(ra) # 5e5a <printf>
    exit(1);
    3c5a:	4505                	li	a0,1
    3c5c:	00002097          	auipc	ra,0x2
    3c60:	e84080e7          	jalr	-380(ra) # 5ae0 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3c64:	85ca                	mv	a1,s2
    3c66:	00004517          	auipc	a0,0x4
    3c6a:	af250513          	addi	a0,a0,-1294 # 7758 <malloc+0x1846>
    3c6e:	00002097          	auipc	ra,0x2
    3c72:	1ec080e7          	jalr	492(ra) # 5e5a <printf>
    exit(1);
    3c76:	4505                	li	a0,1
    3c78:	00002097          	auipc	ra,0x2
    3c7c:	e68080e7          	jalr	-408(ra) # 5ae0 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3c80:	85ca                	mv	a1,s2
    3c82:	00004517          	auipc	a0,0x4
    3c86:	afe50513          	addi	a0,a0,-1282 # 7780 <malloc+0x186e>
    3c8a:	00002097          	auipc	ra,0x2
    3c8e:	1d0080e7          	jalr	464(ra) # 5e5a <printf>
    exit(1);
    3c92:	4505                	li	a0,1
    3c94:	00002097          	auipc	ra,0x2
    3c98:	e4c080e7          	jalr	-436(ra) # 5ae0 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3c9c:	85ca                	mv	a1,s2
    3c9e:	00004517          	auipc	a0,0x4
    3ca2:	b0250513          	addi	a0,a0,-1278 # 77a0 <malloc+0x188e>
    3ca6:	00002097          	auipc	ra,0x2
    3caa:	1b4080e7          	jalr	436(ra) # 5e5a <printf>
    exit(1);
    3cae:	4505                	li	a0,1
    3cb0:	00002097          	auipc	ra,0x2
    3cb4:	e30080e7          	jalr	-464(ra) # 5ae0 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3cb8:	85ca                	mv	a1,s2
    3cba:	00004517          	auipc	a0,0x4
    3cbe:	b0650513          	addi	a0,a0,-1274 # 77c0 <malloc+0x18ae>
    3cc2:	00002097          	auipc	ra,0x2
    3cc6:	198080e7          	jalr	408(ra) # 5e5a <printf>
    exit(1);
    3cca:	4505                	li	a0,1
    3ccc:	00002097          	auipc	ra,0x2
    3cd0:	e14080e7          	jalr	-492(ra) # 5ae0 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3cd4:	85ca                	mv	a1,s2
    3cd6:	00004517          	auipc	a0,0x4
    3cda:	b1250513          	addi	a0,a0,-1262 # 77e8 <malloc+0x18d6>
    3cde:	00002097          	auipc	ra,0x2
    3ce2:	17c080e7          	jalr	380(ra) # 5e5a <printf>
    exit(1);
    3ce6:	4505                	li	a0,1
    3ce8:	00002097          	auipc	ra,0x2
    3cec:	df8080e7          	jalr	-520(ra) # 5ae0 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3cf0:	85ca                	mv	a1,s2
    3cf2:	00003517          	auipc	a0,0x3
    3cf6:	78e50513          	addi	a0,a0,1934 # 7480 <malloc+0x156e>
    3cfa:	00002097          	auipc	ra,0x2
    3cfe:	160080e7          	jalr	352(ra) # 5e5a <printf>
    exit(1);
    3d02:	4505                	li	a0,1
    3d04:	00002097          	auipc	ra,0x2
    3d08:	ddc080e7          	jalr	-548(ra) # 5ae0 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3d0c:	85ca                	mv	a1,s2
    3d0e:	00004517          	auipc	a0,0x4
    3d12:	afa50513          	addi	a0,a0,-1286 # 7808 <malloc+0x18f6>
    3d16:	00002097          	auipc	ra,0x2
    3d1a:	144080e7          	jalr	324(ra) # 5e5a <printf>
    exit(1);
    3d1e:	4505                	li	a0,1
    3d20:	00002097          	auipc	ra,0x2
    3d24:	dc0080e7          	jalr	-576(ra) # 5ae0 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3d28:	85ca                	mv	a1,s2
    3d2a:	00004517          	auipc	a0,0x4
    3d2e:	afe50513          	addi	a0,a0,-1282 # 7828 <malloc+0x1916>
    3d32:	00002097          	auipc	ra,0x2
    3d36:	128080e7          	jalr	296(ra) # 5e5a <printf>
    exit(1);
    3d3a:	4505                	li	a0,1
    3d3c:	00002097          	auipc	ra,0x2
    3d40:	da4080e7          	jalr	-604(ra) # 5ae0 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3d44:	85ca                	mv	a1,s2
    3d46:	00004517          	auipc	a0,0x4
    3d4a:	b1250513          	addi	a0,a0,-1262 # 7858 <malloc+0x1946>
    3d4e:	00002097          	auipc	ra,0x2
    3d52:	10c080e7          	jalr	268(ra) # 5e5a <printf>
    exit(1);
    3d56:	4505                	li	a0,1
    3d58:	00002097          	auipc	ra,0x2
    3d5c:	d88080e7          	jalr	-632(ra) # 5ae0 <exit>
    printf("%s: unlink dd failed\n", s);
    3d60:	85ca                	mv	a1,s2
    3d62:	00004517          	auipc	a0,0x4
    3d66:	b1650513          	addi	a0,a0,-1258 # 7878 <malloc+0x1966>
    3d6a:	00002097          	auipc	ra,0x2
    3d6e:	0f0080e7          	jalr	240(ra) # 5e5a <printf>
    exit(1);
    3d72:	4505                	li	a0,1
    3d74:	00002097          	auipc	ra,0x2
    3d78:	d6c080e7          	jalr	-660(ra) # 5ae0 <exit>

0000000000003d7c <rmdot>:
void rmdot(char *s) {
    3d7c:	1101                	addi	sp,sp,-32
    3d7e:	ec06                	sd	ra,24(sp)
    3d80:	e822                	sd	s0,16(sp)
    3d82:	e426                	sd	s1,8(sp)
    3d84:	1000                	addi	s0,sp,32
    3d86:	84aa                	mv	s1,a0
  if (mkdir("dots") != 0) {
    3d88:	00004517          	auipc	a0,0x4
    3d8c:	b0850513          	addi	a0,a0,-1272 # 7890 <malloc+0x197e>
    3d90:	00002097          	auipc	ra,0x2
    3d94:	db8080e7          	jalr	-584(ra) # 5b48 <mkdir>
    3d98:	e549                	bnez	a0,3e22 <rmdot+0xa6>
  if (chdir("dots") != 0) {
    3d9a:	00004517          	auipc	a0,0x4
    3d9e:	af650513          	addi	a0,a0,-1290 # 7890 <malloc+0x197e>
    3da2:	00002097          	auipc	ra,0x2
    3da6:	dae080e7          	jalr	-594(ra) # 5b50 <chdir>
    3daa:	e951                	bnez	a0,3e3e <rmdot+0xc2>
  if (unlink(".") == 0) {
    3dac:	00003517          	auipc	a0,0x3
    3db0:	98450513          	addi	a0,a0,-1660 # 6730 <malloc+0x81e>
    3db4:	00002097          	auipc	ra,0x2
    3db8:	d7c080e7          	jalr	-644(ra) # 5b30 <unlink>
    3dbc:	cd59                	beqz	a0,3e5a <rmdot+0xde>
  if (unlink("..") == 0) {
    3dbe:	00003517          	auipc	a0,0x3
    3dc2:	52a50513          	addi	a0,a0,1322 # 72e8 <malloc+0x13d6>
    3dc6:	00002097          	auipc	ra,0x2
    3dca:	d6a080e7          	jalr	-662(ra) # 5b30 <unlink>
    3dce:	c545                	beqz	a0,3e76 <rmdot+0xfa>
  if (chdir("/") != 0) {
    3dd0:	00003517          	auipc	a0,0x3
    3dd4:	4c050513          	addi	a0,a0,1216 # 7290 <malloc+0x137e>
    3dd8:	00002097          	auipc	ra,0x2
    3ddc:	d78080e7          	jalr	-648(ra) # 5b50 <chdir>
    3de0:	e94d                	bnez	a0,3e92 <rmdot+0x116>
  if (unlink("dots/.") == 0) {
    3de2:	00004517          	auipc	a0,0x4
    3de6:	b1650513          	addi	a0,a0,-1258 # 78f8 <malloc+0x19e6>
    3dea:	00002097          	auipc	ra,0x2
    3dee:	d46080e7          	jalr	-698(ra) # 5b30 <unlink>
    3df2:	cd55                	beqz	a0,3eae <rmdot+0x132>
  if (unlink("dots/..") == 0) {
    3df4:	00004517          	auipc	a0,0x4
    3df8:	b2c50513          	addi	a0,a0,-1236 # 7920 <malloc+0x1a0e>
    3dfc:	00002097          	auipc	ra,0x2
    3e00:	d34080e7          	jalr	-716(ra) # 5b30 <unlink>
    3e04:	c179                	beqz	a0,3eca <rmdot+0x14e>
  if (unlink("dots") != 0) {
    3e06:	00004517          	auipc	a0,0x4
    3e0a:	a8a50513          	addi	a0,a0,-1398 # 7890 <malloc+0x197e>
    3e0e:	00002097          	auipc	ra,0x2
    3e12:	d22080e7          	jalr	-734(ra) # 5b30 <unlink>
    3e16:	e961                	bnez	a0,3ee6 <rmdot+0x16a>
}
    3e18:	60e2                	ld	ra,24(sp)
    3e1a:	6442                	ld	s0,16(sp)
    3e1c:	64a2                	ld	s1,8(sp)
    3e1e:	6105                	addi	sp,sp,32
    3e20:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3e22:	85a6                	mv	a1,s1
    3e24:	00004517          	auipc	a0,0x4
    3e28:	a7450513          	addi	a0,a0,-1420 # 7898 <malloc+0x1986>
    3e2c:	00002097          	auipc	ra,0x2
    3e30:	02e080e7          	jalr	46(ra) # 5e5a <printf>
    exit(1);
    3e34:	4505                	li	a0,1
    3e36:	00002097          	auipc	ra,0x2
    3e3a:	caa080e7          	jalr	-854(ra) # 5ae0 <exit>
    printf("%s: chdir dots failed\n", s);
    3e3e:	85a6                	mv	a1,s1
    3e40:	00004517          	auipc	a0,0x4
    3e44:	a7050513          	addi	a0,a0,-1424 # 78b0 <malloc+0x199e>
    3e48:	00002097          	auipc	ra,0x2
    3e4c:	012080e7          	jalr	18(ra) # 5e5a <printf>
    exit(1);
    3e50:	4505                	li	a0,1
    3e52:	00002097          	auipc	ra,0x2
    3e56:	c8e080e7          	jalr	-882(ra) # 5ae0 <exit>
    printf("%s: rm . worked!\n", s);
    3e5a:	85a6                	mv	a1,s1
    3e5c:	00004517          	auipc	a0,0x4
    3e60:	a6c50513          	addi	a0,a0,-1428 # 78c8 <malloc+0x19b6>
    3e64:	00002097          	auipc	ra,0x2
    3e68:	ff6080e7          	jalr	-10(ra) # 5e5a <printf>
    exit(1);
    3e6c:	4505                	li	a0,1
    3e6e:	00002097          	auipc	ra,0x2
    3e72:	c72080e7          	jalr	-910(ra) # 5ae0 <exit>
    printf("%s: rm .. worked!\n", s);
    3e76:	85a6                	mv	a1,s1
    3e78:	00004517          	auipc	a0,0x4
    3e7c:	a6850513          	addi	a0,a0,-1432 # 78e0 <malloc+0x19ce>
    3e80:	00002097          	auipc	ra,0x2
    3e84:	fda080e7          	jalr	-38(ra) # 5e5a <printf>
    exit(1);
    3e88:	4505                	li	a0,1
    3e8a:	00002097          	auipc	ra,0x2
    3e8e:	c56080e7          	jalr	-938(ra) # 5ae0 <exit>
    printf("%s: chdir / failed\n", s);
    3e92:	85a6                	mv	a1,s1
    3e94:	00003517          	auipc	a0,0x3
    3e98:	40450513          	addi	a0,a0,1028 # 7298 <malloc+0x1386>
    3e9c:	00002097          	auipc	ra,0x2
    3ea0:	fbe080e7          	jalr	-66(ra) # 5e5a <printf>
    exit(1);
    3ea4:	4505                	li	a0,1
    3ea6:	00002097          	auipc	ra,0x2
    3eaa:	c3a080e7          	jalr	-966(ra) # 5ae0 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3eae:	85a6                	mv	a1,s1
    3eb0:	00004517          	auipc	a0,0x4
    3eb4:	a5050513          	addi	a0,a0,-1456 # 7900 <malloc+0x19ee>
    3eb8:	00002097          	auipc	ra,0x2
    3ebc:	fa2080e7          	jalr	-94(ra) # 5e5a <printf>
    exit(1);
    3ec0:	4505                	li	a0,1
    3ec2:	00002097          	auipc	ra,0x2
    3ec6:	c1e080e7          	jalr	-994(ra) # 5ae0 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3eca:	85a6                	mv	a1,s1
    3ecc:	00004517          	auipc	a0,0x4
    3ed0:	a5c50513          	addi	a0,a0,-1444 # 7928 <malloc+0x1a16>
    3ed4:	00002097          	auipc	ra,0x2
    3ed8:	f86080e7          	jalr	-122(ra) # 5e5a <printf>
    exit(1);
    3edc:	4505                	li	a0,1
    3ede:	00002097          	auipc	ra,0x2
    3ee2:	c02080e7          	jalr	-1022(ra) # 5ae0 <exit>
    printf("%s: unlink dots failed!\n", s);
    3ee6:	85a6                	mv	a1,s1
    3ee8:	00004517          	auipc	a0,0x4
    3eec:	a6050513          	addi	a0,a0,-1440 # 7948 <malloc+0x1a36>
    3ef0:	00002097          	auipc	ra,0x2
    3ef4:	f6a080e7          	jalr	-150(ra) # 5e5a <printf>
    exit(1);
    3ef8:	4505                	li	a0,1
    3efa:	00002097          	auipc	ra,0x2
    3efe:	be6080e7          	jalr	-1050(ra) # 5ae0 <exit>

0000000000003f02 <dirfile>:
void dirfile(char *s) {
    3f02:	1101                	addi	sp,sp,-32
    3f04:	ec06                	sd	ra,24(sp)
    3f06:	e822                	sd	s0,16(sp)
    3f08:	e426                	sd	s1,8(sp)
    3f0a:	e04a                	sd	s2,0(sp)
    3f0c:	1000                	addi	s0,sp,32
    3f0e:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3f10:	20000593          	li	a1,512
    3f14:	00004517          	auipc	a0,0x4
    3f18:	a5450513          	addi	a0,a0,-1452 # 7968 <malloc+0x1a56>
    3f1c:	00002097          	auipc	ra,0x2
    3f20:	c04080e7          	jalr	-1020(ra) # 5b20 <open>
  if (fd < 0) {
    3f24:	0e054d63          	bltz	a0,401e <dirfile+0x11c>
  close(fd);
    3f28:	00002097          	auipc	ra,0x2
    3f2c:	be0080e7          	jalr	-1056(ra) # 5b08 <close>
  if (chdir("dirfile") == 0) {
    3f30:	00004517          	auipc	a0,0x4
    3f34:	a3850513          	addi	a0,a0,-1480 # 7968 <malloc+0x1a56>
    3f38:	00002097          	auipc	ra,0x2
    3f3c:	c18080e7          	jalr	-1000(ra) # 5b50 <chdir>
    3f40:	cd6d                	beqz	a0,403a <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3f42:	4581                	li	a1,0
    3f44:	00004517          	auipc	a0,0x4
    3f48:	a6c50513          	addi	a0,a0,-1428 # 79b0 <malloc+0x1a9e>
    3f4c:	00002097          	auipc	ra,0x2
    3f50:	bd4080e7          	jalr	-1068(ra) # 5b20 <open>
  if (fd >= 0) {
    3f54:	10055163          	bgez	a0,4056 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3f58:	20000593          	li	a1,512
    3f5c:	00004517          	auipc	a0,0x4
    3f60:	a5450513          	addi	a0,a0,-1452 # 79b0 <malloc+0x1a9e>
    3f64:	00002097          	auipc	ra,0x2
    3f68:	bbc080e7          	jalr	-1092(ra) # 5b20 <open>
  if (fd >= 0) {
    3f6c:	10055363          	bgez	a0,4072 <dirfile+0x170>
  if (mkdir("dirfile/xx") == 0) {
    3f70:	00004517          	auipc	a0,0x4
    3f74:	a4050513          	addi	a0,a0,-1472 # 79b0 <malloc+0x1a9e>
    3f78:	00002097          	auipc	ra,0x2
    3f7c:	bd0080e7          	jalr	-1072(ra) # 5b48 <mkdir>
    3f80:	10050763          	beqz	a0,408e <dirfile+0x18c>
  if (unlink("dirfile/xx") == 0) {
    3f84:	00004517          	auipc	a0,0x4
    3f88:	a2c50513          	addi	a0,a0,-1492 # 79b0 <malloc+0x1a9e>
    3f8c:	00002097          	auipc	ra,0x2
    3f90:	ba4080e7          	jalr	-1116(ra) # 5b30 <unlink>
    3f94:	10050b63          	beqz	a0,40aa <dirfile+0x1a8>
  if (link("xv6-readme", "dirfile/xx") == 0) {
    3f98:	00004597          	auipc	a1,0x4
    3f9c:	a1858593          	addi	a1,a1,-1512 # 79b0 <malloc+0x1a9e>
    3fa0:	00002517          	auipc	a0,0x2
    3fa4:	27050513          	addi	a0,a0,624 # 6210 <malloc+0x2fe>
    3fa8:	00002097          	auipc	ra,0x2
    3fac:	b98080e7          	jalr	-1128(ra) # 5b40 <link>
    3fb0:	10050b63          	beqz	a0,40c6 <dirfile+0x1c4>
  if (unlink("dirfile") != 0) {
    3fb4:	00004517          	auipc	a0,0x4
    3fb8:	9b450513          	addi	a0,a0,-1612 # 7968 <malloc+0x1a56>
    3fbc:	00002097          	auipc	ra,0x2
    3fc0:	b74080e7          	jalr	-1164(ra) # 5b30 <unlink>
    3fc4:	10051f63          	bnez	a0,40e2 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3fc8:	4589                	li	a1,2
    3fca:	00002517          	auipc	a0,0x2
    3fce:	76650513          	addi	a0,a0,1894 # 6730 <malloc+0x81e>
    3fd2:	00002097          	auipc	ra,0x2
    3fd6:	b4e080e7          	jalr	-1202(ra) # 5b20 <open>
  if (fd >= 0) {
    3fda:	12055263          	bgez	a0,40fe <dirfile+0x1fc>
  fd = open(".", 0);
    3fde:	4581                	li	a1,0
    3fe0:	00002517          	auipc	a0,0x2
    3fe4:	75050513          	addi	a0,a0,1872 # 6730 <malloc+0x81e>
    3fe8:	00002097          	auipc	ra,0x2
    3fec:	b38080e7          	jalr	-1224(ra) # 5b20 <open>
    3ff0:	84aa                	mv	s1,a0
  if (write(fd, "x", 1) > 0) {
    3ff2:	4605                	li	a2,1
    3ff4:	00002597          	auipc	a1,0x2
    3ff8:	0b458593          	addi	a1,a1,180 # 60a8 <malloc+0x196>
    3ffc:	00002097          	auipc	ra,0x2
    4000:	b04080e7          	jalr	-1276(ra) # 5b00 <write>
    4004:	10a04b63          	bgtz	a0,411a <dirfile+0x218>
  close(fd);
    4008:	8526                	mv	a0,s1
    400a:	00002097          	auipc	ra,0x2
    400e:	afe080e7          	jalr	-1282(ra) # 5b08 <close>
}
    4012:	60e2                	ld	ra,24(sp)
    4014:	6442                	ld	s0,16(sp)
    4016:	64a2                	ld	s1,8(sp)
    4018:	6902                	ld	s2,0(sp)
    401a:	6105                	addi	sp,sp,32
    401c:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    401e:	85ca                	mv	a1,s2
    4020:	00004517          	auipc	a0,0x4
    4024:	95050513          	addi	a0,a0,-1712 # 7970 <malloc+0x1a5e>
    4028:	00002097          	auipc	ra,0x2
    402c:	e32080e7          	jalr	-462(ra) # 5e5a <printf>
    exit(1);
    4030:	4505                	li	a0,1
    4032:	00002097          	auipc	ra,0x2
    4036:	aae080e7          	jalr	-1362(ra) # 5ae0 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    403a:	85ca                	mv	a1,s2
    403c:	00004517          	auipc	a0,0x4
    4040:	95450513          	addi	a0,a0,-1708 # 7990 <malloc+0x1a7e>
    4044:	00002097          	auipc	ra,0x2
    4048:	e16080e7          	jalr	-490(ra) # 5e5a <printf>
    exit(1);
    404c:	4505                	li	a0,1
    404e:	00002097          	auipc	ra,0x2
    4052:	a92080e7          	jalr	-1390(ra) # 5ae0 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4056:	85ca                	mv	a1,s2
    4058:	00004517          	auipc	a0,0x4
    405c:	96850513          	addi	a0,a0,-1688 # 79c0 <malloc+0x1aae>
    4060:	00002097          	auipc	ra,0x2
    4064:	dfa080e7          	jalr	-518(ra) # 5e5a <printf>
    exit(1);
    4068:	4505                	li	a0,1
    406a:	00002097          	auipc	ra,0x2
    406e:	a76080e7          	jalr	-1418(ra) # 5ae0 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4072:	85ca                	mv	a1,s2
    4074:	00004517          	auipc	a0,0x4
    4078:	94c50513          	addi	a0,a0,-1716 # 79c0 <malloc+0x1aae>
    407c:	00002097          	auipc	ra,0x2
    4080:	dde080e7          	jalr	-546(ra) # 5e5a <printf>
    exit(1);
    4084:	4505                	li	a0,1
    4086:	00002097          	auipc	ra,0x2
    408a:	a5a080e7          	jalr	-1446(ra) # 5ae0 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    408e:	85ca                	mv	a1,s2
    4090:	00004517          	auipc	a0,0x4
    4094:	95850513          	addi	a0,a0,-1704 # 79e8 <malloc+0x1ad6>
    4098:	00002097          	auipc	ra,0x2
    409c:	dc2080e7          	jalr	-574(ra) # 5e5a <printf>
    exit(1);
    40a0:	4505                	li	a0,1
    40a2:	00002097          	auipc	ra,0x2
    40a6:	a3e080e7          	jalr	-1474(ra) # 5ae0 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    40aa:	85ca                	mv	a1,s2
    40ac:	00004517          	auipc	a0,0x4
    40b0:	96450513          	addi	a0,a0,-1692 # 7a10 <malloc+0x1afe>
    40b4:	00002097          	auipc	ra,0x2
    40b8:	da6080e7          	jalr	-602(ra) # 5e5a <printf>
    exit(1);
    40bc:	4505                	li	a0,1
    40be:	00002097          	auipc	ra,0x2
    40c2:	a22080e7          	jalr	-1502(ra) # 5ae0 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    40c6:	85ca                	mv	a1,s2
    40c8:	00004517          	auipc	a0,0x4
    40cc:	97050513          	addi	a0,a0,-1680 # 7a38 <malloc+0x1b26>
    40d0:	00002097          	auipc	ra,0x2
    40d4:	d8a080e7          	jalr	-630(ra) # 5e5a <printf>
    exit(1);
    40d8:	4505                	li	a0,1
    40da:	00002097          	auipc	ra,0x2
    40de:	a06080e7          	jalr	-1530(ra) # 5ae0 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    40e2:	85ca                	mv	a1,s2
    40e4:	00004517          	auipc	a0,0x4
    40e8:	97c50513          	addi	a0,a0,-1668 # 7a60 <malloc+0x1b4e>
    40ec:	00002097          	auipc	ra,0x2
    40f0:	d6e080e7          	jalr	-658(ra) # 5e5a <printf>
    exit(1);
    40f4:	4505                	li	a0,1
    40f6:	00002097          	auipc	ra,0x2
    40fa:	9ea080e7          	jalr	-1558(ra) # 5ae0 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    40fe:	85ca                	mv	a1,s2
    4100:	00004517          	auipc	a0,0x4
    4104:	98050513          	addi	a0,a0,-1664 # 7a80 <malloc+0x1b6e>
    4108:	00002097          	auipc	ra,0x2
    410c:	d52080e7          	jalr	-686(ra) # 5e5a <printf>
    exit(1);
    4110:	4505                	li	a0,1
    4112:	00002097          	auipc	ra,0x2
    4116:	9ce080e7          	jalr	-1586(ra) # 5ae0 <exit>
    printf("%s: write . succeeded!\n", s);
    411a:	85ca                	mv	a1,s2
    411c:	00004517          	auipc	a0,0x4
    4120:	98c50513          	addi	a0,a0,-1652 # 7aa8 <malloc+0x1b96>
    4124:	00002097          	auipc	ra,0x2
    4128:	d36080e7          	jalr	-714(ra) # 5e5a <printf>
    exit(1);
    412c:	4505                	li	a0,1
    412e:	00002097          	auipc	ra,0x2
    4132:	9b2080e7          	jalr	-1614(ra) # 5ae0 <exit>

0000000000004136 <iref>:
void iref(char *s) {
    4136:	7139                	addi	sp,sp,-64
    4138:	fc06                	sd	ra,56(sp)
    413a:	f822                	sd	s0,48(sp)
    413c:	f426                	sd	s1,40(sp)
    413e:	f04a                	sd	s2,32(sp)
    4140:	ec4e                	sd	s3,24(sp)
    4142:	e852                	sd	s4,16(sp)
    4144:	e456                	sd	s5,8(sp)
    4146:	e05a                	sd	s6,0(sp)
    4148:	0080                	addi	s0,sp,64
    414a:	8b2a                	mv	s6,a0
    414c:	03300913          	li	s2,51
    if (mkdir("irefd") != 0) {
    4150:	00004a17          	auipc	s4,0x4
    4154:	970a0a13          	addi	s4,s4,-1680 # 7ac0 <malloc+0x1bae>
    mkdir("");
    4158:	00003497          	auipc	s1,0x3
    415c:	47048493          	addi	s1,s1,1136 # 75c8 <malloc+0x16b6>
    link("xv6-readme", "");
    4160:	00002a97          	auipc	s5,0x2
    4164:	0b0a8a93          	addi	s5,s5,176 # 6210 <malloc+0x2fe>
    fd = open("xx", O_CREATE);
    4168:	00004997          	auipc	s3,0x4
    416c:	85098993          	addi	s3,s3,-1968 # 79b8 <malloc+0x1aa6>
    4170:	a891                	j	41c4 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    4172:	85da                	mv	a1,s6
    4174:	00004517          	auipc	a0,0x4
    4178:	95450513          	addi	a0,a0,-1708 # 7ac8 <malloc+0x1bb6>
    417c:	00002097          	auipc	ra,0x2
    4180:	cde080e7          	jalr	-802(ra) # 5e5a <printf>
      exit(1);
    4184:	4505                	li	a0,1
    4186:	00002097          	auipc	ra,0x2
    418a:	95a080e7          	jalr	-1702(ra) # 5ae0 <exit>
      printf("%s: chdir irefd failed\n", s);
    418e:	85da                	mv	a1,s6
    4190:	00004517          	auipc	a0,0x4
    4194:	95050513          	addi	a0,a0,-1712 # 7ae0 <malloc+0x1bce>
    4198:	00002097          	auipc	ra,0x2
    419c:	cc2080e7          	jalr	-830(ra) # 5e5a <printf>
      exit(1);
    41a0:	4505                	li	a0,1
    41a2:	00002097          	auipc	ra,0x2
    41a6:	93e080e7          	jalr	-1730(ra) # 5ae0 <exit>
    if (fd >= 0) close(fd);
    41aa:	00002097          	auipc	ra,0x2
    41ae:	95e080e7          	jalr	-1698(ra) # 5b08 <close>
    41b2:	a889                	j	4204 <iref+0xce>
    unlink("xx");
    41b4:	854e                	mv	a0,s3
    41b6:	00002097          	auipc	ra,0x2
    41ba:	97a080e7          	jalr	-1670(ra) # 5b30 <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    41be:	397d                	addiw	s2,s2,-1
    41c0:	06090063          	beqz	s2,4220 <iref+0xea>
    if (mkdir("irefd") != 0) {
    41c4:	8552                	mv	a0,s4
    41c6:	00002097          	auipc	ra,0x2
    41ca:	982080e7          	jalr	-1662(ra) # 5b48 <mkdir>
    41ce:	f155                	bnez	a0,4172 <iref+0x3c>
    if (chdir("irefd") != 0) {
    41d0:	8552                	mv	a0,s4
    41d2:	00002097          	auipc	ra,0x2
    41d6:	97e080e7          	jalr	-1666(ra) # 5b50 <chdir>
    41da:	f955                	bnez	a0,418e <iref+0x58>
    mkdir("");
    41dc:	8526                	mv	a0,s1
    41de:	00002097          	auipc	ra,0x2
    41e2:	96a080e7          	jalr	-1686(ra) # 5b48 <mkdir>
    link("xv6-readme", "");
    41e6:	85a6                	mv	a1,s1
    41e8:	8556                	mv	a0,s5
    41ea:	00002097          	auipc	ra,0x2
    41ee:	956080e7          	jalr	-1706(ra) # 5b40 <link>
    fd = open("", O_CREATE);
    41f2:	20000593          	li	a1,512
    41f6:	8526                	mv	a0,s1
    41f8:	00002097          	auipc	ra,0x2
    41fc:	928080e7          	jalr	-1752(ra) # 5b20 <open>
    if (fd >= 0) close(fd);
    4200:	fa0555e3          	bgez	a0,41aa <iref+0x74>
    fd = open("xx", O_CREATE);
    4204:	20000593          	li	a1,512
    4208:	854e                	mv	a0,s3
    420a:	00002097          	auipc	ra,0x2
    420e:	916080e7          	jalr	-1770(ra) # 5b20 <open>
    if (fd >= 0) close(fd);
    4212:	fa0541e3          	bltz	a0,41b4 <iref+0x7e>
    4216:	00002097          	auipc	ra,0x2
    421a:	8f2080e7          	jalr	-1806(ra) # 5b08 <close>
    421e:	bf59                	j	41b4 <iref+0x7e>
    4220:	03300493          	li	s1,51
    chdir("..");
    4224:	00003997          	auipc	s3,0x3
    4228:	0c498993          	addi	s3,s3,196 # 72e8 <malloc+0x13d6>
    unlink("irefd");
    422c:	00004917          	auipc	s2,0x4
    4230:	89490913          	addi	s2,s2,-1900 # 7ac0 <malloc+0x1bae>
    chdir("..");
    4234:	854e                	mv	a0,s3
    4236:	00002097          	auipc	ra,0x2
    423a:	91a080e7          	jalr	-1766(ra) # 5b50 <chdir>
    unlink("irefd");
    423e:	854a                	mv	a0,s2
    4240:	00002097          	auipc	ra,0x2
    4244:	8f0080e7          	jalr	-1808(ra) # 5b30 <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    4248:	34fd                	addiw	s1,s1,-1
    424a:	f4ed                	bnez	s1,4234 <iref+0xfe>
  chdir("/");
    424c:	00003517          	auipc	a0,0x3
    4250:	04450513          	addi	a0,a0,68 # 7290 <malloc+0x137e>
    4254:	00002097          	auipc	ra,0x2
    4258:	8fc080e7          	jalr	-1796(ra) # 5b50 <chdir>
}
    425c:	70e2                	ld	ra,56(sp)
    425e:	7442                	ld	s0,48(sp)
    4260:	74a2                	ld	s1,40(sp)
    4262:	7902                	ld	s2,32(sp)
    4264:	69e2                	ld	s3,24(sp)
    4266:	6a42                	ld	s4,16(sp)
    4268:	6aa2                	ld	s5,8(sp)
    426a:	6b02                	ld	s6,0(sp)
    426c:	6121                	addi	sp,sp,64
    426e:	8082                	ret

0000000000004270 <openiputtest>:
void openiputtest(char *s) {
    4270:	7179                	addi	sp,sp,-48
    4272:	f406                	sd	ra,40(sp)
    4274:	f022                	sd	s0,32(sp)
    4276:	ec26                	sd	s1,24(sp)
    4278:	1800                	addi	s0,sp,48
    427a:	84aa                	mv	s1,a0
  if (mkdir("oidir") < 0) {
    427c:	00004517          	auipc	a0,0x4
    4280:	87c50513          	addi	a0,a0,-1924 # 7af8 <malloc+0x1be6>
    4284:	00002097          	auipc	ra,0x2
    4288:	8c4080e7          	jalr	-1852(ra) # 5b48 <mkdir>
    428c:	04054263          	bltz	a0,42d0 <openiputtest+0x60>
  pid = fork();
    4290:	00002097          	auipc	ra,0x2
    4294:	848080e7          	jalr	-1976(ra) # 5ad8 <fork>
  if (pid < 0) {
    4298:	04054a63          	bltz	a0,42ec <openiputtest+0x7c>
  if (pid == 0) {
    429c:	e93d                	bnez	a0,4312 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    429e:	4589                	li	a1,2
    42a0:	00004517          	auipc	a0,0x4
    42a4:	85850513          	addi	a0,a0,-1960 # 7af8 <malloc+0x1be6>
    42a8:	00002097          	auipc	ra,0x2
    42ac:	878080e7          	jalr	-1928(ra) # 5b20 <open>
    if (fd >= 0) {
    42b0:	04054c63          	bltz	a0,4308 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    42b4:	85a6                	mv	a1,s1
    42b6:	00004517          	auipc	a0,0x4
    42ba:	86250513          	addi	a0,a0,-1950 # 7b18 <malloc+0x1c06>
    42be:	00002097          	auipc	ra,0x2
    42c2:	b9c080e7          	jalr	-1124(ra) # 5e5a <printf>
      exit(1);
    42c6:	4505                	li	a0,1
    42c8:	00002097          	auipc	ra,0x2
    42cc:	818080e7          	jalr	-2024(ra) # 5ae0 <exit>
    printf("%s: mkdir oidir failed\n", s);
    42d0:	85a6                	mv	a1,s1
    42d2:	00004517          	auipc	a0,0x4
    42d6:	82e50513          	addi	a0,a0,-2002 # 7b00 <malloc+0x1bee>
    42da:	00002097          	auipc	ra,0x2
    42de:	b80080e7          	jalr	-1152(ra) # 5e5a <printf>
    exit(1);
    42e2:	4505                	li	a0,1
    42e4:	00001097          	auipc	ra,0x1
    42e8:	7fc080e7          	jalr	2044(ra) # 5ae0 <exit>
    printf("%s: fork failed\n", s);
    42ec:	85a6                	mv	a1,s1
    42ee:	00002517          	auipc	a0,0x2
    42f2:	5e250513          	addi	a0,a0,1506 # 68d0 <malloc+0x9be>
    42f6:	00002097          	auipc	ra,0x2
    42fa:	b64080e7          	jalr	-1180(ra) # 5e5a <printf>
    exit(1);
    42fe:	4505                	li	a0,1
    4300:	00001097          	auipc	ra,0x1
    4304:	7e0080e7          	jalr	2016(ra) # 5ae0 <exit>
    exit(0);
    4308:	4501                	li	a0,0
    430a:	00001097          	auipc	ra,0x1
    430e:	7d6080e7          	jalr	2006(ra) # 5ae0 <exit>
  sleep(1);
    4312:	4505                	li	a0,1
    4314:	00002097          	auipc	ra,0x2
    4318:	85c080e7          	jalr	-1956(ra) # 5b70 <sleep>
  if (unlink("oidir") != 0) {
    431c:	00003517          	auipc	a0,0x3
    4320:	7dc50513          	addi	a0,a0,2012 # 7af8 <malloc+0x1be6>
    4324:	00002097          	auipc	ra,0x2
    4328:	80c080e7          	jalr	-2036(ra) # 5b30 <unlink>
    432c:	cd19                	beqz	a0,434a <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    432e:	85a6                	mv	a1,s1
    4330:	00002517          	auipc	a0,0x2
    4334:	79050513          	addi	a0,a0,1936 # 6ac0 <malloc+0xbae>
    4338:	00002097          	auipc	ra,0x2
    433c:	b22080e7          	jalr	-1246(ra) # 5e5a <printf>
    exit(1);
    4340:	4505                	li	a0,1
    4342:	00001097          	auipc	ra,0x1
    4346:	79e080e7          	jalr	1950(ra) # 5ae0 <exit>
  wait(&xstatus);
    434a:	fdc40513          	addi	a0,s0,-36
    434e:	00001097          	auipc	ra,0x1
    4352:	79a080e7          	jalr	1946(ra) # 5ae8 <wait>
  exit(xstatus);
    4356:	fdc42503          	lw	a0,-36(s0)
    435a:	00001097          	auipc	ra,0x1
    435e:	786080e7          	jalr	1926(ra) # 5ae0 <exit>

0000000000004362 <forkforkfork>:
void forkforkfork(char *s) {
    4362:	1101                	addi	sp,sp,-32
    4364:	ec06                	sd	ra,24(sp)
    4366:	e822                	sd	s0,16(sp)
    4368:	e426                	sd	s1,8(sp)
    436a:	1000                	addi	s0,sp,32
    436c:	84aa                	mv	s1,a0
  unlink("stopforking");
    436e:	00003517          	auipc	a0,0x3
    4372:	7d250513          	addi	a0,a0,2002 # 7b40 <malloc+0x1c2e>
    4376:	00001097          	auipc	ra,0x1
    437a:	7ba080e7          	jalr	1978(ra) # 5b30 <unlink>
  int pid = fork();
    437e:	00001097          	auipc	ra,0x1
    4382:	75a080e7          	jalr	1882(ra) # 5ad8 <fork>
  if (pid < 0) {
    4386:	04054563          	bltz	a0,43d0 <forkforkfork+0x6e>
  if (pid == 0) {
    438a:	c12d                	beqz	a0,43ec <forkforkfork+0x8a>
  sleep(20);  // two seconds
    438c:	4551                	li	a0,20
    438e:	00001097          	auipc	ra,0x1
    4392:	7e2080e7          	jalr	2018(ra) # 5b70 <sleep>
  close(open("stopforking", O_CREATE | O_RDWR));
    4396:	20200593          	li	a1,514
    439a:	00003517          	auipc	a0,0x3
    439e:	7a650513          	addi	a0,a0,1958 # 7b40 <malloc+0x1c2e>
    43a2:	00001097          	auipc	ra,0x1
    43a6:	77e080e7          	jalr	1918(ra) # 5b20 <open>
    43aa:	00001097          	auipc	ra,0x1
    43ae:	75e080e7          	jalr	1886(ra) # 5b08 <close>
  wait(0);
    43b2:	4501                	li	a0,0
    43b4:	00001097          	auipc	ra,0x1
    43b8:	734080e7          	jalr	1844(ra) # 5ae8 <wait>
  sleep(10);  // one second
    43bc:	4529                	li	a0,10
    43be:	00001097          	auipc	ra,0x1
    43c2:	7b2080e7          	jalr	1970(ra) # 5b70 <sleep>
}
    43c6:	60e2                	ld	ra,24(sp)
    43c8:	6442                	ld	s0,16(sp)
    43ca:	64a2                	ld	s1,8(sp)
    43cc:	6105                	addi	sp,sp,32
    43ce:	8082                	ret
    printf("%s: fork failed", s);
    43d0:	85a6                	mv	a1,s1
    43d2:	00002517          	auipc	a0,0x2
    43d6:	6be50513          	addi	a0,a0,1726 # 6a90 <malloc+0xb7e>
    43da:	00002097          	auipc	ra,0x2
    43de:	a80080e7          	jalr	-1408(ra) # 5e5a <printf>
    exit(1);
    43e2:	4505                	li	a0,1
    43e4:	00001097          	auipc	ra,0x1
    43e8:	6fc080e7          	jalr	1788(ra) # 5ae0 <exit>
      int fd = open("stopforking", 0);
    43ec:	00003497          	auipc	s1,0x3
    43f0:	75448493          	addi	s1,s1,1876 # 7b40 <malloc+0x1c2e>
    43f4:	4581                	li	a1,0
    43f6:	8526                	mv	a0,s1
    43f8:	00001097          	auipc	ra,0x1
    43fc:	728080e7          	jalr	1832(ra) # 5b20 <open>
      if (fd >= 0) {
    4400:	02055463          	bgez	a0,4428 <forkforkfork+0xc6>
      if (fork() < 0) {
    4404:	00001097          	auipc	ra,0x1
    4408:	6d4080e7          	jalr	1748(ra) # 5ad8 <fork>
    440c:	fe0554e3          	bgez	a0,43f4 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE | O_RDWR));
    4410:	20200593          	li	a1,514
    4414:	8526                	mv	a0,s1
    4416:	00001097          	auipc	ra,0x1
    441a:	70a080e7          	jalr	1802(ra) # 5b20 <open>
    441e:	00001097          	auipc	ra,0x1
    4422:	6ea080e7          	jalr	1770(ra) # 5b08 <close>
    4426:	b7f9                	j	43f4 <forkforkfork+0x92>
        exit(0);
    4428:	4501                	li	a0,0
    442a:	00001097          	auipc	ra,0x1
    442e:	6b6080e7          	jalr	1718(ra) # 5ae0 <exit>

0000000000004432 <killstatus>:
void killstatus(char *s) {
    4432:	7139                	addi	sp,sp,-64
    4434:	fc06                	sd	ra,56(sp)
    4436:	f822                	sd	s0,48(sp)
    4438:	f426                	sd	s1,40(sp)
    443a:	f04a                	sd	s2,32(sp)
    443c:	ec4e                	sd	s3,24(sp)
    443e:	e852                	sd	s4,16(sp)
    4440:	0080                	addi	s0,sp,64
    4442:	8a2a                	mv	s4,a0
    4444:	06400913          	li	s2,100
    if (xst != -1) {
    4448:	59fd                	li	s3,-1
    int pid1 = fork();
    444a:	00001097          	auipc	ra,0x1
    444e:	68e080e7          	jalr	1678(ra) # 5ad8 <fork>
    4452:	84aa                	mv	s1,a0
    if (pid1 < 0) {
    4454:	02054f63          	bltz	a0,4492 <killstatus+0x60>
    if (pid1 == 0) {
    4458:	c939                	beqz	a0,44ae <killstatus+0x7c>
    sleep(1);
    445a:	4505                	li	a0,1
    445c:	00001097          	auipc	ra,0x1
    4460:	714080e7          	jalr	1812(ra) # 5b70 <sleep>
    kill(pid1);
    4464:	8526                	mv	a0,s1
    4466:	00001097          	auipc	ra,0x1
    446a:	6aa080e7          	jalr	1706(ra) # 5b10 <kill>
    wait(&xst);
    446e:	fcc40513          	addi	a0,s0,-52
    4472:	00001097          	auipc	ra,0x1
    4476:	676080e7          	jalr	1654(ra) # 5ae8 <wait>
    if (xst != -1) {
    447a:	fcc42783          	lw	a5,-52(s0)
    447e:	03379d63          	bne	a5,s3,44b8 <killstatus+0x86>
  for (int i = 0; i < 100; i++) {
    4482:	397d                	addiw	s2,s2,-1
    4484:	fc0913e3          	bnez	s2,444a <killstatus+0x18>
  exit(0);
    4488:	4501                	li	a0,0
    448a:	00001097          	auipc	ra,0x1
    448e:	656080e7          	jalr	1622(ra) # 5ae0 <exit>
      printf("%s: fork failed\n", s);
    4492:	85d2                	mv	a1,s4
    4494:	00002517          	auipc	a0,0x2
    4498:	43c50513          	addi	a0,a0,1084 # 68d0 <malloc+0x9be>
    449c:	00002097          	auipc	ra,0x2
    44a0:	9be080e7          	jalr	-1602(ra) # 5e5a <printf>
      exit(1);
    44a4:	4505                	li	a0,1
    44a6:	00001097          	auipc	ra,0x1
    44aa:	63a080e7          	jalr	1594(ra) # 5ae0 <exit>
        getpid();
    44ae:	00001097          	auipc	ra,0x1
    44b2:	6b2080e7          	jalr	1714(ra) # 5b60 <getpid>
      while (1) {
    44b6:	bfe5                	j	44ae <killstatus+0x7c>
      printf("%s: status should be -1\n", s);
    44b8:	85d2                	mv	a1,s4
    44ba:	00003517          	auipc	a0,0x3
    44be:	69650513          	addi	a0,a0,1686 # 7b50 <malloc+0x1c3e>
    44c2:	00002097          	auipc	ra,0x2
    44c6:	998080e7          	jalr	-1640(ra) # 5e5a <printf>
      exit(1);
    44ca:	4505                	li	a0,1
    44cc:	00001097          	auipc	ra,0x1
    44d0:	614080e7          	jalr	1556(ra) # 5ae0 <exit>

00000000000044d4 <preempt>:
void preempt(char *s) {
    44d4:	7139                	addi	sp,sp,-64
    44d6:	fc06                	sd	ra,56(sp)
    44d8:	f822                	sd	s0,48(sp)
    44da:	f426                	sd	s1,40(sp)
    44dc:	f04a                	sd	s2,32(sp)
    44de:	ec4e                	sd	s3,24(sp)
    44e0:	e852                	sd	s4,16(sp)
    44e2:	0080                	addi	s0,sp,64
    44e4:	892a                	mv	s2,a0
  pid1 = fork();
    44e6:	00001097          	auipc	ra,0x1
    44ea:	5f2080e7          	jalr	1522(ra) # 5ad8 <fork>
  if (pid1 < 0) {
    44ee:	00054563          	bltz	a0,44f8 <preempt+0x24>
    44f2:	84aa                	mv	s1,a0
  if (pid1 == 0)
    44f4:	e105                	bnez	a0,4514 <preempt+0x40>
    for (;;)
    44f6:	a001                	j	44f6 <preempt+0x22>
    printf("%s: fork failed", s);
    44f8:	85ca                	mv	a1,s2
    44fa:	00002517          	auipc	a0,0x2
    44fe:	59650513          	addi	a0,a0,1430 # 6a90 <malloc+0xb7e>
    4502:	00002097          	auipc	ra,0x2
    4506:	958080e7          	jalr	-1704(ra) # 5e5a <printf>
    exit(1);
    450a:	4505                	li	a0,1
    450c:	00001097          	auipc	ra,0x1
    4510:	5d4080e7          	jalr	1492(ra) # 5ae0 <exit>
  pid2 = fork();
    4514:	00001097          	auipc	ra,0x1
    4518:	5c4080e7          	jalr	1476(ra) # 5ad8 <fork>
    451c:	89aa                	mv	s3,a0
  if (pid2 < 0) {
    451e:	00054463          	bltz	a0,4526 <preempt+0x52>
  if (pid2 == 0)
    4522:	e105                	bnez	a0,4542 <preempt+0x6e>
    for (;;)
    4524:	a001                	j	4524 <preempt+0x50>
    printf("%s: fork failed\n", s);
    4526:	85ca                	mv	a1,s2
    4528:	00002517          	auipc	a0,0x2
    452c:	3a850513          	addi	a0,a0,936 # 68d0 <malloc+0x9be>
    4530:	00002097          	auipc	ra,0x2
    4534:	92a080e7          	jalr	-1750(ra) # 5e5a <printf>
    exit(1);
    4538:	4505                	li	a0,1
    453a:	00001097          	auipc	ra,0x1
    453e:	5a6080e7          	jalr	1446(ra) # 5ae0 <exit>
  pipe(pfds);
    4542:	fc840513          	addi	a0,s0,-56
    4546:	00001097          	auipc	ra,0x1
    454a:	5aa080e7          	jalr	1450(ra) # 5af0 <pipe>
  pid3 = fork();
    454e:	00001097          	auipc	ra,0x1
    4552:	58a080e7          	jalr	1418(ra) # 5ad8 <fork>
    4556:	8a2a                	mv	s4,a0
  if (pid3 < 0) {
    4558:	02054e63          	bltz	a0,4594 <preempt+0xc0>
  if (pid3 == 0) {
    455c:	e525                	bnez	a0,45c4 <preempt+0xf0>
    close(pfds[0]);
    455e:	fc842503          	lw	a0,-56(s0)
    4562:	00001097          	auipc	ra,0x1
    4566:	5a6080e7          	jalr	1446(ra) # 5b08 <close>
    if (write(pfds[1], "x", 1) != 1) printf("%s: preempt write error", s);
    456a:	4605                	li	a2,1
    456c:	00002597          	auipc	a1,0x2
    4570:	b3c58593          	addi	a1,a1,-1220 # 60a8 <malloc+0x196>
    4574:	fcc42503          	lw	a0,-52(s0)
    4578:	00001097          	auipc	ra,0x1
    457c:	588080e7          	jalr	1416(ra) # 5b00 <write>
    4580:	4785                	li	a5,1
    4582:	02f51763          	bne	a0,a5,45b0 <preempt+0xdc>
    close(pfds[1]);
    4586:	fcc42503          	lw	a0,-52(s0)
    458a:	00001097          	auipc	ra,0x1
    458e:	57e080e7          	jalr	1406(ra) # 5b08 <close>
    for (;;)
    4592:	a001                	j	4592 <preempt+0xbe>
    printf("%s: fork failed\n", s);
    4594:	85ca                	mv	a1,s2
    4596:	00002517          	auipc	a0,0x2
    459a:	33a50513          	addi	a0,a0,826 # 68d0 <malloc+0x9be>
    459e:	00002097          	auipc	ra,0x2
    45a2:	8bc080e7          	jalr	-1860(ra) # 5e5a <printf>
    exit(1);
    45a6:	4505                	li	a0,1
    45a8:	00001097          	auipc	ra,0x1
    45ac:	538080e7          	jalr	1336(ra) # 5ae0 <exit>
    if (write(pfds[1], "x", 1) != 1) printf("%s: preempt write error", s);
    45b0:	85ca                	mv	a1,s2
    45b2:	00003517          	auipc	a0,0x3
    45b6:	5be50513          	addi	a0,a0,1470 # 7b70 <malloc+0x1c5e>
    45ba:	00002097          	auipc	ra,0x2
    45be:	8a0080e7          	jalr	-1888(ra) # 5e5a <printf>
    45c2:	b7d1                	j	4586 <preempt+0xb2>
  close(pfds[1]);
    45c4:	fcc42503          	lw	a0,-52(s0)
    45c8:	00001097          	auipc	ra,0x1
    45cc:	540080e7          	jalr	1344(ra) # 5b08 <close>
  if (read(pfds[0], buf, sizeof(buf)) != 1) {
    45d0:	660d                	lui	a2,0x3
    45d2:	00008597          	auipc	a1,0x8
    45d6:	69658593          	addi	a1,a1,1686 # cc68 <buf>
    45da:	fc842503          	lw	a0,-56(s0)
    45de:	00001097          	auipc	ra,0x1
    45e2:	51a080e7          	jalr	1306(ra) # 5af8 <read>
    45e6:	4785                	li	a5,1
    45e8:	02f50363          	beq	a0,a5,460e <preempt+0x13a>
    printf("%s: preempt read error", s);
    45ec:	85ca                	mv	a1,s2
    45ee:	00003517          	auipc	a0,0x3
    45f2:	59a50513          	addi	a0,a0,1434 # 7b88 <malloc+0x1c76>
    45f6:	00002097          	auipc	ra,0x2
    45fa:	864080e7          	jalr	-1948(ra) # 5e5a <printf>
}
    45fe:	70e2                	ld	ra,56(sp)
    4600:	7442                	ld	s0,48(sp)
    4602:	74a2                	ld	s1,40(sp)
    4604:	7902                	ld	s2,32(sp)
    4606:	69e2                	ld	s3,24(sp)
    4608:	6a42                	ld	s4,16(sp)
    460a:	6121                	addi	sp,sp,64
    460c:	8082                	ret
  close(pfds[0]);
    460e:	fc842503          	lw	a0,-56(s0)
    4612:	00001097          	auipc	ra,0x1
    4616:	4f6080e7          	jalr	1270(ra) # 5b08 <close>
  printf("kill... ");
    461a:	00003517          	auipc	a0,0x3
    461e:	58650513          	addi	a0,a0,1414 # 7ba0 <malloc+0x1c8e>
    4622:	00002097          	auipc	ra,0x2
    4626:	838080e7          	jalr	-1992(ra) # 5e5a <printf>
  kill(pid1);
    462a:	8526                	mv	a0,s1
    462c:	00001097          	auipc	ra,0x1
    4630:	4e4080e7          	jalr	1252(ra) # 5b10 <kill>
  kill(pid2);
    4634:	854e                	mv	a0,s3
    4636:	00001097          	auipc	ra,0x1
    463a:	4da080e7          	jalr	1242(ra) # 5b10 <kill>
  kill(pid3);
    463e:	8552                	mv	a0,s4
    4640:	00001097          	auipc	ra,0x1
    4644:	4d0080e7          	jalr	1232(ra) # 5b10 <kill>
  printf("wait... ");
    4648:	00003517          	auipc	a0,0x3
    464c:	56850513          	addi	a0,a0,1384 # 7bb0 <malloc+0x1c9e>
    4650:	00002097          	auipc	ra,0x2
    4654:	80a080e7          	jalr	-2038(ra) # 5e5a <printf>
  wait(0);
    4658:	4501                	li	a0,0
    465a:	00001097          	auipc	ra,0x1
    465e:	48e080e7          	jalr	1166(ra) # 5ae8 <wait>
  wait(0);
    4662:	4501                	li	a0,0
    4664:	00001097          	auipc	ra,0x1
    4668:	484080e7          	jalr	1156(ra) # 5ae8 <wait>
  wait(0);
    466c:	4501                	li	a0,0
    466e:	00001097          	auipc	ra,0x1
    4672:	47a080e7          	jalr	1146(ra) # 5ae8 <wait>
    4676:	b761                	j	45fe <preempt+0x12a>

0000000000004678 <reparent>:
void reparent(char *s) {
    4678:	7179                	addi	sp,sp,-48
    467a:	f406                	sd	ra,40(sp)
    467c:	f022                	sd	s0,32(sp)
    467e:	ec26                	sd	s1,24(sp)
    4680:	e84a                	sd	s2,16(sp)
    4682:	e44e                	sd	s3,8(sp)
    4684:	e052                	sd	s4,0(sp)
    4686:	1800                	addi	s0,sp,48
    4688:	89aa                	mv	s3,a0
  int master_pid = getpid();
    468a:	00001097          	auipc	ra,0x1
    468e:	4d6080e7          	jalr	1238(ra) # 5b60 <getpid>
    4692:	8a2a                	mv	s4,a0
    4694:	0c800913          	li	s2,200
    int pid = fork();
    4698:	00001097          	auipc	ra,0x1
    469c:	440080e7          	jalr	1088(ra) # 5ad8 <fork>
    46a0:	84aa                	mv	s1,a0
    if (pid < 0) {
    46a2:	02054263          	bltz	a0,46c6 <reparent+0x4e>
    if (pid) {
    46a6:	cd21                	beqz	a0,46fe <reparent+0x86>
      if (wait(0) != pid) {
    46a8:	4501                	li	a0,0
    46aa:	00001097          	auipc	ra,0x1
    46ae:	43e080e7          	jalr	1086(ra) # 5ae8 <wait>
    46b2:	02951863          	bne	a0,s1,46e2 <reparent+0x6a>
  for (int i = 0; i < 200; i++) {
    46b6:	397d                	addiw	s2,s2,-1
    46b8:	fe0910e3          	bnez	s2,4698 <reparent+0x20>
  exit(0);
    46bc:	4501                	li	a0,0
    46be:	00001097          	auipc	ra,0x1
    46c2:	422080e7          	jalr	1058(ra) # 5ae0 <exit>
      printf("%s: fork failed\n", s);
    46c6:	85ce                	mv	a1,s3
    46c8:	00002517          	auipc	a0,0x2
    46cc:	20850513          	addi	a0,a0,520 # 68d0 <malloc+0x9be>
    46d0:	00001097          	auipc	ra,0x1
    46d4:	78a080e7          	jalr	1930(ra) # 5e5a <printf>
      exit(1);
    46d8:	4505                	li	a0,1
    46da:	00001097          	auipc	ra,0x1
    46de:	406080e7          	jalr	1030(ra) # 5ae0 <exit>
        printf("%s: wait wrong pid\n", s);
    46e2:	85ce                	mv	a1,s3
    46e4:	00002517          	auipc	a0,0x2
    46e8:	37450513          	addi	a0,a0,884 # 6a58 <malloc+0xb46>
    46ec:	00001097          	auipc	ra,0x1
    46f0:	76e080e7          	jalr	1902(ra) # 5e5a <printf>
        exit(1);
    46f4:	4505                	li	a0,1
    46f6:	00001097          	auipc	ra,0x1
    46fa:	3ea080e7          	jalr	1002(ra) # 5ae0 <exit>
      int pid2 = fork();
    46fe:	00001097          	auipc	ra,0x1
    4702:	3da080e7          	jalr	986(ra) # 5ad8 <fork>
      if (pid2 < 0) {
    4706:	00054763          	bltz	a0,4714 <reparent+0x9c>
      exit(0);
    470a:	4501                	li	a0,0
    470c:	00001097          	auipc	ra,0x1
    4710:	3d4080e7          	jalr	980(ra) # 5ae0 <exit>
        kill(master_pid);
    4714:	8552                	mv	a0,s4
    4716:	00001097          	auipc	ra,0x1
    471a:	3fa080e7          	jalr	1018(ra) # 5b10 <kill>
        exit(1);
    471e:	4505                	li	a0,1
    4720:	00001097          	auipc	ra,0x1
    4724:	3c0080e7          	jalr	960(ra) # 5ae0 <exit>

0000000000004728 <sbrkfail>:
void sbrkfail(char *s) {
    4728:	7119                	addi	sp,sp,-128
    472a:	fc86                	sd	ra,120(sp)
    472c:	f8a2                	sd	s0,112(sp)
    472e:	f4a6                	sd	s1,104(sp)
    4730:	f0ca                	sd	s2,96(sp)
    4732:	ecce                	sd	s3,88(sp)
    4734:	e8d2                	sd	s4,80(sp)
    4736:	e4d6                	sd	s5,72(sp)
    4738:	0100                	addi	s0,sp,128
    473a:	8aaa                	mv	s5,a0
  if (pipe(fds) != 0) {
    473c:	fb040513          	addi	a0,s0,-80
    4740:	00001097          	auipc	ra,0x1
    4744:	3b0080e7          	jalr	944(ra) # 5af0 <pipe>
    4748:	e901                	bnez	a0,4758 <sbrkfail+0x30>
    474a:	f8040493          	addi	s1,s0,-128
    474e:	fa840993          	addi	s3,s0,-88
    4752:	8926                	mv	s2,s1
    if (pids[i] != -1) read(fds[0], &scratch, 1);
    4754:	5a7d                	li	s4,-1
    4756:	a085                	j	47b6 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    4758:	85d6                	mv	a1,s5
    475a:	00002517          	auipc	a0,0x2
    475e:	27e50513          	addi	a0,a0,638 # 69d8 <malloc+0xac6>
    4762:	00001097          	auipc	ra,0x1
    4766:	6f8080e7          	jalr	1784(ra) # 5e5a <printf>
    exit(1);
    476a:	4505                	li	a0,1
    476c:	00001097          	auipc	ra,0x1
    4770:	374080e7          	jalr	884(ra) # 5ae0 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4774:	00001097          	auipc	ra,0x1
    4778:	3f4080e7          	jalr	1012(ra) # 5b68 <sbrk>
    477c:	064007b7          	lui	a5,0x6400
    4780:	40a7853b          	subw	a0,a5,a0
    4784:	00001097          	auipc	ra,0x1
    4788:	3e4080e7          	jalr	996(ra) # 5b68 <sbrk>
      write(fds[1], "x", 1);
    478c:	4605                	li	a2,1
    478e:	00002597          	auipc	a1,0x2
    4792:	91a58593          	addi	a1,a1,-1766 # 60a8 <malloc+0x196>
    4796:	fb442503          	lw	a0,-76(s0)
    479a:	00001097          	auipc	ra,0x1
    479e:	366080e7          	jalr	870(ra) # 5b00 <write>
      for (;;) sleep(1000);
    47a2:	3e800513          	li	a0,1000
    47a6:	00001097          	auipc	ra,0x1
    47aa:	3ca080e7          	jalr	970(ra) # 5b70 <sleep>
    47ae:	bfd5                	j	47a2 <sbrkfail+0x7a>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    47b0:	0911                	addi	s2,s2,4
    47b2:	03390563          	beq	s2,s3,47dc <sbrkfail+0xb4>
    if ((pids[i] = fork()) == 0) {
    47b6:	00001097          	auipc	ra,0x1
    47ba:	322080e7          	jalr	802(ra) # 5ad8 <fork>
    47be:	00a92023          	sw	a0,0(s2)
    47c2:	d94d                	beqz	a0,4774 <sbrkfail+0x4c>
    if (pids[i] != -1) read(fds[0], &scratch, 1);
    47c4:	ff4506e3          	beq	a0,s4,47b0 <sbrkfail+0x88>
    47c8:	4605                	li	a2,1
    47ca:	faf40593          	addi	a1,s0,-81
    47ce:	fb042503          	lw	a0,-80(s0)
    47d2:	00001097          	auipc	ra,0x1
    47d6:	326080e7          	jalr	806(ra) # 5af8 <read>
    47da:	bfd9                	j	47b0 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    47dc:	6505                	lui	a0,0x1
    47de:	00001097          	auipc	ra,0x1
    47e2:	38a080e7          	jalr	906(ra) # 5b68 <sbrk>
    47e6:	8a2a                	mv	s4,a0
    if (pids[i] == -1) continue;
    47e8:	597d                	li	s2,-1
    47ea:	a021                	j	47f2 <sbrkfail+0xca>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    47ec:	0491                	addi	s1,s1,4
    47ee:	01348f63          	beq	s1,s3,480c <sbrkfail+0xe4>
    if (pids[i] == -1) continue;
    47f2:	4088                	lw	a0,0(s1)
    47f4:	ff250ce3          	beq	a0,s2,47ec <sbrkfail+0xc4>
    kill(pids[i]);
    47f8:	00001097          	auipc	ra,0x1
    47fc:	318080e7          	jalr	792(ra) # 5b10 <kill>
    wait(0);
    4800:	4501                	li	a0,0
    4802:	00001097          	auipc	ra,0x1
    4806:	2e6080e7          	jalr	742(ra) # 5ae8 <wait>
    480a:	b7cd                	j	47ec <sbrkfail+0xc4>
  if (c == (char *)0xffffffffffffffffL) {
    480c:	57fd                	li	a5,-1
    480e:	04fa0163          	beq	s4,a5,4850 <sbrkfail+0x128>
  pid = fork();
    4812:	00001097          	auipc	ra,0x1
    4816:	2c6080e7          	jalr	710(ra) # 5ad8 <fork>
    481a:	84aa                	mv	s1,a0
  if (pid < 0) {
    481c:	04054863          	bltz	a0,486c <sbrkfail+0x144>
  if (pid == 0) {
    4820:	c525                	beqz	a0,4888 <sbrkfail+0x160>
  wait(&xstatus);
    4822:	fbc40513          	addi	a0,s0,-68
    4826:	00001097          	auipc	ra,0x1
    482a:	2c2080e7          	jalr	706(ra) # 5ae8 <wait>
  if (xstatus != -1 && xstatus != 2) exit(1);
    482e:	fbc42783          	lw	a5,-68(s0)
    4832:	577d                	li	a4,-1
    4834:	00e78563          	beq	a5,a4,483e <sbrkfail+0x116>
    4838:	4709                	li	a4,2
    483a:	08e79d63          	bne	a5,a4,48d4 <sbrkfail+0x1ac>
}
    483e:	70e6                	ld	ra,120(sp)
    4840:	7446                	ld	s0,112(sp)
    4842:	74a6                	ld	s1,104(sp)
    4844:	7906                	ld	s2,96(sp)
    4846:	69e6                	ld	s3,88(sp)
    4848:	6a46                	ld	s4,80(sp)
    484a:	6aa6                	ld	s5,72(sp)
    484c:	6109                	addi	sp,sp,128
    484e:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4850:	85d6                	mv	a1,s5
    4852:	00003517          	auipc	a0,0x3
    4856:	36e50513          	addi	a0,a0,878 # 7bc0 <malloc+0x1cae>
    485a:	00001097          	auipc	ra,0x1
    485e:	600080e7          	jalr	1536(ra) # 5e5a <printf>
    exit(1);
    4862:	4505                	li	a0,1
    4864:	00001097          	auipc	ra,0x1
    4868:	27c080e7          	jalr	636(ra) # 5ae0 <exit>
    printf("%s: fork failed\n", s);
    486c:	85d6                	mv	a1,s5
    486e:	00002517          	auipc	a0,0x2
    4872:	06250513          	addi	a0,a0,98 # 68d0 <malloc+0x9be>
    4876:	00001097          	auipc	ra,0x1
    487a:	5e4080e7          	jalr	1508(ra) # 5e5a <printf>
    exit(1);
    487e:	4505                	li	a0,1
    4880:	00001097          	auipc	ra,0x1
    4884:	260080e7          	jalr	608(ra) # 5ae0 <exit>
    a = sbrk(0);
    4888:	4501                	li	a0,0
    488a:	00001097          	auipc	ra,0x1
    488e:	2de080e7          	jalr	734(ra) # 5b68 <sbrk>
    4892:	892a                	mv	s2,a0
    sbrk(10 * BIG);
    4894:	3e800537          	lui	a0,0x3e800
    4898:	00001097          	auipc	ra,0x1
    489c:	2d0080e7          	jalr	720(ra) # 5b68 <sbrk>
    for (i = 0; i < 10 * BIG; i += PGSIZE) {
    48a0:	87ca                	mv	a5,s2
    48a2:	3e800737          	lui	a4,0x3e800
    48a6:	993a                	add	s2,s2,a4
    48a8:	6705                	lui	a4,0x1
      n += *(a + i);
    48aa:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f0398>
    48ae:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10 * BIG; i += PGSIZE) {
    48b0:	97ba                	add	a5,a5,a4
    48b2:	ff279ce3          	bne	a5,s2,48aa <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    48b6:	8626                	mv	a2,s1
    48b8:	85d6                	mv	a1,s5
    48ba:	00003517          	auipc	a0,0x3
    48be:	32650513          	addi	a0,a0,806 # 7be0 <malloc+0x1cce>
    48c2:	00001097          	auipc	ra,0x1
    48c6:	598080e7          	jalr	1432(ra) # 5e5a <printf>
    exit(1);
    48ca:	4505                	li	a0,1
    48cc:	00001097          	auipc	ra,0x1
    48d0:	214080e7          	jalr	532(ra) # 5ae0 <exit>
  if (xstatus != -1 && xstatus != 2) exit(1);
    48d4:	4505                	li	a0,1
    48d6:	00001097          	auipc	ra,0x1
    48da:	20a080e7          	jalr	522(ra) # 5ae0 <exit>

00000000000048de <mem>:
void mem(char *s) {
    48de:	7139                	addi	sp,sp,-64
    48e0:	fc06                	sd	ra,56(sp)
    48e2:	f822                	sd	s0,48(sp)
    48e4:	f426                	sd	s1,40(sp)
    48e6:	f04a                	sd	s2,32(sp)
    48e8:	ec4e                	sd	s3,24(sp)
    48ea:	0080                	addi	s0,sp,64
    48ec:	89aa                	mv	s3,a0
  if ((pid = fork()) == 0) {
    48ee:	00001097          	auipc	ra,0x1
    48f2:	1ea080e7          	jalr	490(ra) # 5ad8 <fork>
    m1 = 0;
    48f6:	4481                	li	s1,0
    while ((m2 = malloc(10001)) != 0) {
    48f8:	6909                	lui	s2,0x2
    48fa:	71190913          	addi	s2,s2,1809 # 2711 <rwsbrk+0x9b>
  if ((pid = fork()) == 0) {
    48fe:	c115                	beqz	a0,4922 <mem+0x44>
    wait(&xstatus);
    4900:	fcc40513          	addi	a0,s0,-52
    4904:	00001097          	auipc	ra,0x1
    4908:	1e4080e7          	jalr	484(ra) # 5ae8 <wait>
    if (xstatus == -1) {
    490c:	fcc42503          	lw	a0,-52(s0)
    4910:	57fd                	li	a5,-1
    4912:	06f50363          	beq	a0,a5,4978 <mem+0x9a>
    exit(xstatus);
    4916:	00001097          	auipc	ra,0x1
    491a:	1ca080e7          	jalr	458(ra) # 5ae0 <exit>
      *(char **)m2 = m1;
    491e:	e104                	sd	s1,0(a0)
      m1 = m2;
    4920:	84aa                	mv	s1,a0
    while ((m2 = malloc(10001)) != 0) {
    4922:	854a                	mv	a0,s2
    4924:	00001097          	auipc	ra,0x1
    4928:	5ee080e7          	jalr	1518(ra) # 5f12 <malloc>
    492c:	f96d                	bnez	a0,491e <mem+0x40>
    while (m1) {
    492e:	c881                	beqz	s1,493e <mem+0x60>
      m2 = *(char **)m1;
    4930:	8526                	mv	a0,s1
    4932:	6084                	ld	s1,0(s1)
      free(m1);
    4934:	00001097          	auipc	ra,0x1
    4938:	55c080e7          	jalr	1372(ra) # 5e90 <free>
    while (m1) {
    493c:	f8f5                	bnez	s1,4930 <mem+0x52>
    m1 = malloc(1024 * 20);
    493e:	6515                	lui	a0,0x5
    4940:	00001097          	auipc	ra,0x1
    4944:	5d2080e7          	jalr	1490(ra) # 5f12 <malloc>
    if (m1 == 0) {
    4948:	c911                	beqz	a0,495c <mem+0x7e>
    free(m1);
    494a:	00001097          	auipc	ra,0x1
    494e:	546080e7          	jalr	1350(ra) # 5e90 <free>
    exit(0);
    4952:	4501                	li	a0,0
    4954:	00001097          	auipc	ra,0x1
    4958:	18c080e7          	jalr	396(ra) # 5ae0 <exit>
      printf("couldn't allocate mem?!!\n", s);
    495c:	85ce                	mv	a1,s3
    495e:	00003517          	auipc	a0,0x3
    4962:	2b250513          	addi	a0,a0,690 # 7c10 <malloc+0x1cfe>
    4966:	00001097          	auipc	ra,0x1
    496a:	4f4080e7          	jalr	1268(ra) # 5e5a <printf>
      exit(1);
    496e:	4505                	li	a0,1
    4970:	00001097          	auipc	ra,0x1
    4974:	170080e7          	jalr	368(ra) # 5ae0 <exit>
      exit(0);
    4978:	4501                	li	a0,0
    497a:	00001097          	auipc	ra,0x1
    497e:	166080e7          	jalr	358(ra) # 5ae0 <exit>

0000000000004982 <sharedfd>:
void sharedfd(char *s) {
    4982:	7159                	addi	sp,sp,-112
    4984:	f486                	sd	ra,104(sp)
    4986:	f0a2                	sd	s0,96(sp)
    4988:	eca6                	sd	s1,88(sp)
    498a:	e8ca                	sd	s2,80(sp)
    498c:	e4ce                	sd	s3,72(sp)
    498e:	e0d2                	sd	s4,64(sp)
    4990:	fc56                	sd	s5,56(sp)
    4992:	f85a                	sd	s6,48(sp)
    4994:	f45e                	sd	s7,40(sp)
    4996:	1880                	addi	s0,sp,112
    4998:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    499a:	00003517          	auipc	a0,0x3
    499e:	29650513          	addi	a0,a0,662 # 7c30 <malloc+0x1d1e>
    49a2:	00001097          	auipc	ra,0x1
    49a6:	18e080e7          	jalr	398(ra) # 5b30 <unlink>
  fd = open("sharedfd", O_CREATE | O_RDWR);
    49aa:	20200593          	li	a1,514
    49ae:	00003517          	auipc	a0,0x3
    49b2:	28250513          	addi	a0,a0,642 # 7c30 <malloc+0x1d1e>
    49b6:	00001097          	auipc	ra,0x1
    49ba:	16a080e7          	jalr	362(ra) # 5b20 <open>
  if (fd < 0) {
    49be:	04054a63          	bltz	a0,4a12 <sharedfd+0x90>
    49c2:	892a                	mv	s2,a0
  pid = fork();
    49c4:	00001097          	auipc	ra,0x1
    49c8:	114080e7          	jalr	276(ra) # 5ad8 <fork>
    49cc:	89aa                	mv	s3,a0
  memset(buf, pid == 0 ? 'c' : 'p', sizeof(buf));
    49ce:	06300593          	li	a1,99
    49d2:	c119                	beqz	a0,49d8 <sharedfd+0x56>
    49d4:	07000593          	li	a1,112
    49d8:	4629                	li	a2,10
    49da:	fa040513          	addi	a0,s0,-96
    49de:	00001097          	auipc	ra,0x1
    49e2:	f08080e7          	jalr	-248(ra) # 58e6 <memset>
    49e6:	3e800493          	li	s1,1000
    if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
    49ea:	4629                	li	a2,10
    49ec:	fa040593          	addi	a1,s0,-96
    49f0:	854a                	mv	a0,s2
    49f2:	00001097          	auipc	ra,0x1
    49f6:	10e080e7          	jalr	270(ra) # 5b00 <write>
    49fa:	47a9                	li	a5,10
    49fc:	02f51963          	bne	a0,a5,4a2e <sharedfd+0xac>
  for (i = 0; i < N; i++) {
    4a00:	34fd                	addiw	s1,s1,-1
    4a02:	f4e5                	bnez	s1,49ea <sharedfd+0x68>
  if (pid == 0) {
    4a04:	04099363          	bnez	s3,4a4a <sharedfd+0xc8>
    exit(0);
    4a08:	4501                	li	a0,0
    4a0a:	00001097          	auipc	ra,0x1
    4a0e:	0d6080e7          	jalr	214(ra) # 5ae0 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4a12:	85d2                	mv	a1,s4
    4a14:	00003517          	auipc	a0,0x3
    4a18:	22c50513          	addi	a0,a0,556 # 7c40 <malloc+0x1d2e>
    4a1c:	00001097          	auipc	ra,0x1
    4a20:	43e080e7          	jalr	1086(ra) # 5e5a <printf>
    exit(1);
    4a24:	4505                	li	a0,1
    4a26:	00001097          	auipc	ra,0x1
    4a2a:	0ba080e7          	jalr	186(ra) # 5ae0 <exit>
      printf("%s: write sharedfd failed\n", s);
    4a2e:	85d2                	mv	a1,s4
    4a30:	00003517          	auipc	a0,0x3
    4a34:	23850513          	addi	a0,a0,568 # 7c68 <malloc+0x1d56>
    4a38:	00001097          	auipc	ra,0x1
    4a3c:	422080e7          	jalr	1058(ra) # 5e5a <printf>
      exit(1);
    4a40:	4505                	li	a0,1
    4a42:	00001097          	auipc	ra,0x1
    4a46:	09e080e7          	jalr	158(ra) # 5ae0 <exit>
    wait(&xstatus);
    4a4a:	f9c40513          	addi	a0,s0,-100
    4a4e:	00001097          	auipc	ra,0x1
    4a52:	09a080e7          	jalr	154(ra) # 5ae8 <wait>
    if (xstatus != 0) exit(xstatus);
    4a56:	f9c42983          	lw	s3,-100(s0)
    4a5a:	00098763          	beqz	s3,4a68 <sharedfd+0xe6>
    4a5e:	854e                	mv	a0,s3
    4a60:	00001097          	auipc	ra,0x1
    4a64:	080080e7          	jalr	128(ra) # 5ae0 <exit>
  close(fd);
    4a68:	854a                	mv	a0,s2
    4a6a:	00001097          	auipc	ra,0x1
    4a6e:	09e080e7          	jalr	158(ra) # 5b08 <close>
  fd = open("sharedfd", 0);
    4a72:	4581                	li	a1,0
    4a74:	00003517          	auipc	a0,0x3
    4a78:	1bc50513          	addi	a0,a0,444 # 7c30 <malloc+0x1d1e>
    4a7c:	00001097          	auipc	ra,0x1
    4a80:	0a4080e7          	jalr	164(ra) # 5b20 <open>
    4a84:	8baa                	mv	s7,a0
  nc = np = 0;
    4a86:	8ace                	mv	s5,s3
  if (fd < 0) {
    4a88:	02054563          	bltz	a0,4ab2 <sharedfd+0x130>
    4a8c:	faa40913          	addi	s2,s0,-86
      if (buf[i] == 'c') nc++;
    4a90:	06300493          	li	s1,99
      if (buf[i] == 'p') np++;
    4a94:	07000b13          	li	s6,112
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
    4a98:	4629                	li	a2,10
    4a9a:	fa040593          	addi	a1,s0,-96
    4a9e:	855e                	mv	a0,s7
    4aa0:	00001097          	auipc	ra,0x1
    4aa4:	058080e7          	jalr	88(ra) # 5af8 <read>
    4aa8:	02a05f63          	blez	a0,4ae6 <sharedfd+0x164>
    4aac:	fa040793          	addi	a5,s0,-96
    4ab0:	a01d                	j	4ad6 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4ab2:	85d2                	mv	a1,s4
    4ab4:	00003517          	auipc	a0,0x3
    4ab8:	1d450513          	addi	a0,a0,468 # 7c88 <malloc+0x1d76>
    4abc:	00001097          	auipc	ra,0x1
    4ac0:	39e080e7          	jalr	926(ra) # 5e5a <printf>
    exit(1);
    4ac4:	4505                	li	a0,1
    4ac6:	00001097          	auipc	ra,0x1
    4aca:	01a080e7          	jalr	26(ra) # 5ae0 <exit>
      if (buf[i] == 'c') nc++;
    4ace:	2985                	addiw	s3,s3,1
    for (i = 0; i < sizeof(buf); i++) {
    4ad0:	0785                	addi	a5,a5,1
    4ad2:	fd2783e3          	beq	a5,s2,4a98 <sharedfd+0x116>
      if (buf[i] == 'c') nc++;
    4ad6:	0007c703          	lbu	a4,0(a5)
    4ada:	fe970ae3          	beq	a4,s1,4ace <sharedfd+0x14c>
      if (buf[i] == 'p') np++;
    4ade:	ff6719e3          	bne	a4,s6,4ad0 <sharedfd+0x14e>
    4ae2:	2a85                	addiw	s5,s5,1
    4ae4:	b7f5                	j	4ad0 <sharedfd+0x14e>
  close(fd);
    4ae6:	855e                	mv	a0,s7
    4ae8:	00001097          	auipc	ra,0x1
    4aec:	020080e7          	jalr	32(ra) # 5b08 <close>
  unlink("sharedfd");
    4af0:	00003517          	auipc	a0,0x3
    4af4:	14050513          	addi	a0,a0,320 # 7c30 <malloc+0x1d1e>
    4af8:	00001097          	auipc	ra,0x1
    4afc:	038080e7          	jalr	56(ra) # 5b30 <unlink>
  if (nc == N * SZ && np == N * SZ) {
    4b00:	6789                	lui	a5,0x2
    4b02:	71078793          	addi	a5,a5,1808 # 2710 <rwsbrk+0x9a>
    4b06:	00f99763          	bne	s3,a5,4b14 <sharedfd+0x192>
    4b0a:	6789                	lui	a5,0x2
    4b0c:	71078793          	addi	a5,a5,1808 # 2710 <rwsbrk+0x9a>
    4b10:	02fa8063          	beq	s5,a5,4b30 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4b14:	85d2                	mv	a1,s4
    4b16:	00003517          	auipc	a0,0x3
    4b1a:	19a50513          	addi	a0,a0,410 # 7cb0 <malloc+0x1d9e>
    4b1e:	00001097          	auipc	ra,0x1
    4b22:	33c080e7          	jalr	828(ra) # 5e5a <printf>
    exit(1);
    4b26:	4505                	li	a0,1
    4b28:	00001097          	auipc	ra,0x1
    4b2c:	fb8080e7          	jalr	-72(ra) # 5ae0 <exit>
    exit(0);
    4b30:	4501                	li	a0,0
    4b32:	00001097          	auipc	ra,0x1
    4b36:	fae080e7          	jalr	-82(ra) # 5ae0 <exit>

0000000000004b3a <fourfiles>:
void fourfiles(char *s) {
    4b3a:	7171                	addi	sp,sp,-176
    4b3c:	f506                	sd	ra,168(sp)
    4b3e:	f122                	sd	s0,160(sp)
    4b40:	ed26                	sd	s1,152(sp)
    4b42:	e94a                	sd	s2,144(sp)
    4b44:	e54e                	sd	s3,136(sp)
    4b46:	e152                	sd	s4,128(sp)
    4b48:	fcd6                	sd	s5,120(sp)
    4b4a:	f8da                	sd	s6,112(sp)
    4b4c:	f4de                	sd	s7,104(sp)
    4b4e:	f0e2                	sd	s8,96(sp)
    4b50:	ece6                	sd	s9,88(sp)
    4b52:	e8ea                	sd	s10,80(sp)
    4b54:	e4ee                	sd	s11,72(sp)
    4b56:	1900                	addi	s0,sp,176
    4b58:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = {"f0", "f1", "f2", "f3"};
    4b5c:	00003797          	auipc	a5,0x3
    4b60:	16c78793          	addi	a5,a5,364 # 7cc8 <malloc+0x1db6>
    4b64:	f6f43823          	sd	a5,-144(s0)
    4b68:	00003797          	auipc	a5,0x3
    4b6c:	16878793          	addi	a5,a5,360 # 7cd0 <malloc+0x1dbe>
    4b70:	f6f43c23          	sd	a5,-136(s0)
    4b74:	00003797          	auipc	a5,0x3
    4b78:	16478793          	addi	a5,a5,356 # 7cd8 <malloc+0x1dc6>
    4b7c:	f8f43023          	sd	a5,-128(s0)
    4b80:	00003797          	auipc	a5,0x3
    4b84:	16078793          	addi	a5,a5,352 # 7ce0 <malloc+0x1dce>
    4b88:	f8f43423          	sd	a5,-120(s0)
  for (pi = 0; pi < NCHILD; pi++) {
    4b8c:	f7040c13          	addi	s8,s0,-144
  char *names[] = {"f0", "f1", "f2", "f3"};
    4b90:	8962                	mv	s2,s8
  for (pi = 0; pi < NCHILD; pi++) {
    4b92:	4481                	li	s1,0
    4b94:	4a11                	li	s4,4
    fname = names[pi];
    4b96:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4b9a:	854e                	mv	a0,s3
    4b9c:	00001097          	auipc	ra,0x1
    4ba0:	f94080e7          	jalr	-108(ra) # 5b30 <unlink>
    pid = fork();
    4ba4:	00001097          	auipc	ra,0x1
    4ba8:	f34080e7          	jalr	-204(ra) # 5ad8 <fork>
    if (pid < 0) {
    4bac:	04054463          	bltz	a0,4bf4 <fourfiles+0xba>
    if (pid == 0) {
    4bb0:	c12d                	beqz	a0,4c12 <fourfiles+0xd8>
  for (pi = 0; pi < NCHILD; pi++) {
    4bb2:	2485                	addiw	s1,s1,1
    4bb4:	0921                	addi	s2,s2,8
    4bb6:	ff4490e3          	bne	s1,s4,4b96 <fourfiles+0x5c>
    4bba:	4491                	li	s1,4
    wait(&xstatus);
    4bbc:	f6c40513          	addi	a0,s0,-148
    4bc0:	00001097          	auipc	ra,0x1
    4bc4:	f28080e7          	jalr	-216(ra) # 5ae8 <wait>
    if (xstatus != 0) exit(xstatus);
    4bc8:	f6c42b03          	lw	s6,-148(s0)
    4bcc:	0c0b1e63          	bnez	s6,4ca8 <fourfiles+0x16e>
  for (pi = 0; pi < NCHILD; pi++) {
    4bd0:	34fd                	addiw	s1,s1,-1
    4bd2:	f4ed                	bnez	s1,4bbc <fourfiles+0x82>
    4bd4:	03000b93          	li	s7,48
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    4bd8:	00008a17          	auipc	s4,0x8
    4bdc:	090a0a13          	addi	s4,s4,144 # cc68 <buf>
    4be0:	00008a97          	auipc	s5,0x8
    4be4:	089a8a93          	addi	s5,s5,137 # cc69 <buf+0x1>
    if (total != N * SZ) {
    4be8:	6d85                	lui	s11,0x1
    4bea:	770d8d93          	addi	s11,s11,1904 # 1770 <exectest+0x30>
  for (i = 0; i < NCHILD; i++) {
    4bee:	03400d13          	li	s10,52
    4bf2:	aa1d                	j	4d28 <fourfiles+0x1ee>
      printf("fork failed\n", s);
    4bf4:	f5843583          	ld	a1,-168(s0)
    4bf8:	00002517          	auipc	a0,0x2
    4bfc:	07050513          	addi	a0,a0,112 # 6c68 <malloc+0xd56>
    4c00:	00001097          	auipc	ra,0x1
    4c04:	25a080e7          	jalr	602(ra) # 5e5a <printf>
      exit(1);
    4c08:	4505                	li	a0,1
    4c0a:	00001097          	auipc	ra,0x1
    4c0e:	ed6080e7          	jalr	-298(ra) # 5ae0 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4c12:	20200593          	li	a1,514
    4c16:	854e                	mv	a0,s3
    4c18:	00001097          	auipc	ra,0x1
    4c1c:	f08080e7          	jalr	-248(ra) # 5b20 <open>
    4c20:	892a                	mv	s2,a0
      if (fd < 0) {
    4c22:	04054763          	bltz	a0,4c70 <fourfiles+0x136>
      memset(buf, '0' + pi, SZ);
    4c26:	1f400613          	li	a2,500
    4c2a:	0304859b          	addiw	a1,s1,48
    4c2e:	00008517          	auipc	a0,0x8
    4c32:	03a50513          	addi	a0,a0,58 # cc68 <buf>
    4c36:	00001097          	auipc	ra,0x1
    4c3a:	cb0080e7          	jalr	-848(ra) # 58e6 <memset>
    4c3e:	44b1                	li	s1,12
        if ((n = write(fd, buf, SZ)) != SZ) {
    4c40:	00008997          	auipc	s3,0x8
    4c44:	02898993          	addi	s3,s3,40 # cc68 <buf>
    4c48:	1f400613          	li	a2,500
    4c4c:	85ce                	mv	a1,s3
    4c4e:	854a                	mv	a0,s2
    4c50:	00001097          	auipc	ra,0x1
    4c54:	eb0080e7          	jalr	-336(ra) # 5b00 <write>
    4c58:	85aa                	mv	a1,a0
    4c5a:	1f400793          	li	a5,500
    4c5e:	02f51863          	bne	a0,a5,4c8e <fourfiles+0x154>
      for (i = 0; i < N; i++) {
    4c62:	34fd                	addiw	s1,s1,-1
    4c64:	f0f5                	bnez	s1,4c48 <fourfiles+0x10e>
      exit(0);
    4c66:	4501                	li	a0,0
    4c68:	00001097          	auipc	ra,0x1
    4c6c:	e78080e7          	jalr	-392(ra) # 5ae0 <exit>
        printf("create failed\n", s);
    4c70:	f5843583          	ld	a1,-168(s0)
    4c74:	00003517          	auipc	a0,0x3
    4c78:	07450513          	addi	a0,a0,116 # 7ce8 <malloc+0x1dd6>
    4c7c:	00001097          	auipc	ra,0x1
    4c80:	1de080e7          	jalr	478(ra) # 5e5a <printf>
        exit(1);
    4c84:	4505                	li	a0,1
    4c86:	00001097          	auipc	ra,0x1
    4c8a:	e5a080e7          	jalr	-422(ra) # 5ae0 <exit>
          printf("write failed %d\n", n);
    4c8e:	00003517          	auipc	a0,0x3
    4c92:	06a50513          	addi	a0,a0,106 # 7cf8 <malloc+0x1de6>
    4c96:	00001097          	auipc	ra,0x1
    4c9a:	1c4080e7          	jalr	452(ra) # 5e5a <printf>
          exit(1);
    4c9e:	4505                	li	a0,1
    4ca0:	00001097          	auipc	ra,0x1
    4ca4:	e40080e7          	jalr	-448(ra) # 5ae0 <exit>
    if (xstatus != 0) exit(xstatus);
    4ca8:	855a                	mv	a0,s6
    4caa:	00001097          	auipc	ra,0x1
    4cae:	e36080e7          	jalr	-458(ra) # 5ae0 <exit>
          printf("wrong char\n", s);
    4cb2:	f5843583          	ld	a1,-168(s0)
    4cb6:	00003517          	auipc	a0,0x3
    4cba:	05a50513          	addi	a0,a0,90 # 7d10 <malloc+0x1dfe>
    4cbe:	00001097          	auipc	ra,0x1
    4cc2:	19c080e7          	jalr	412(ra) # 5e5a <printf>
          exit(1);
    4cc6:	4505                	li	a0,1
    4cc8:	00001097          	auipc	ra,0x1
    4ccc:	e18080e7          	jalr	-488(ra) # 5ae0 <exit>
      total += n;
    4cd0:	00a9093b          	addw	s2,s2,a0
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    4cd4:	660d                	lui	a2,0x3
    4cd6:	85d2                	mv	a1,s4
    4cd8:	854e                	mv	a0,s3
    4cda:	00001097          	auipc	ra,0x1
    4cde:	e1e080e7          	jalr	-482(ra) # 5af8 <read>
    4ce2:	02a05363          	blez	a0,4d08 <fourfiles+0x1ce>
    4ce6:	00008797          	auipc	a5,0x8
    4cea:	f8278793          	addi	a5,a5,-126 # cc68 <buf>
    4cee:	fff5069b          	addiw	a3,a0,-1
    4cf2:	1682                	slli	a3,a3,0x20
    4cf4:	9281                	srli	a3,a3,0x20
    4cf6:	96d6                	add	a3,a3,s5
        if (buf[j] != '0' + i) {
    4cf8:	0007c703          	lbu	a4,0(a5)
    4cfc:	fa971be3          	bne	a4,s1,4cb2 <fourfiles+0x178>
      for (j = 0; j < n; j++) {
    4d00:	0785                	addi	a5,a5,1
    4d02:	fed79be3          	bne	a5,a3,4cf8 <fourfiles+0x1be>
    4d06:	b7e9                	j	4cd0 <fourfiles+0x196>
    close(fd);
    4d08:	854e                	mv	a0,s3
    4d0a:	00001097          	auipc	ra,0x1
    4d0e:	dfe080e7          	jalr	-514(ra) # 5b08 <close>
    if (total != N * SZ) {
    4d12:	03b91863          	bne	s2,s11,4d42 <fourfiles+0x208>
    unlink(fname);
    4d16:	8566                	mv	a0,s9
    4d18:	00001097          	auipc	ra,0x1
    4d1c:	e18080e7          	jalr	-488(ra) # 5b30 <unlink>
  for (i = 0; i < NCHILD; i++) {
    4d20:	0c21                	addi	s8,s8,8
    4d22:	2b85                	addiw	s7,s7,1
    4d24:	03ab8d63          	beq	s7,s10,4d5e <fourfiles+0x224>
    fname = names[i];
    4d28:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    4d2c:	4581                	li	a1,0
    4d2e:	8566                	mv	a0,s9
    4d30:	00001097          	auipc	ra,0x1
    4d34:	df0080e7          	jalr	-528(ra) # 5b20 <open>
    4d38:	89aa                	mv	s3,a0
    total = 0;
    4d3a:	895a                	mv	s2,s6
        if (buf[j] != '0' + i) {
    4d3c:	000b849b          	sext.w	s1,s7
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    4d40:	bf51                	j	4cd4 <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    4d42:	85ca                	mv	a1,s2
    4d44:	00003517          	auipc	a0,0x3
    4d48:	fdc50513          	addi	a0,a0,-36 # 7d20 <malloc+0x1e0e>
    4d4c:	00001097          	auipc	ra,0x1
    4d50:	10e080e7          	jalr	270(ra) # 5e5a <printf>
      exit(1);
    4d54:	4505                	li	a0,1
    4d56:	00001097          	auipc	ra,0x1
    4d5a:	d8a080e7          	jalr	-630(ra) # 5ae0 <exit>
}
    4d5e:	70aa                	ld	ra,168(sp)
    4d60:	740a                	ld	s0,160(sp)
    4d62:	64ea                	ld	s1,152(sp)
    4d64:	694a                	ld	s2,144(sp)
    4d66:	69aa                	ld	s3,136(sp)
    4d68:	6a0a                	ld	s4,128(sp)
    4d6a:	7ae6                	ld	s5,120(sp)
    4d6c:	7b46                	ld	s6,112(sp)
    4d6e:	7ba6                	ld	s7,104(sp)
    4d70:	7c06                	ld	s8,96(sp)
    4d72:	6ce6                	ld	s9,88(sp)
    4d74:	6d46                	ld	s10,80(sp)
    4d76:	6da6                	ld	s11,72(sp)
    4d78:	614d                	addi	sp,sp,176
    4d7a:	8082                	ret

0000000000004d7c <concreate>:
void concreate(char *s) {
    4d7c:	7135                	addi	sp,sp,-160
    4d7e:	ed06                	sd	ra,152(sp)
    4d80:	e922                	sd	s0,144(sp)
    4d82:	e526                	sd	s1,136(sp)
    4d84:	e14a                	sd	s2,128(sp)
    4d86:	fcce                	sd	s3,120(sp)
    4d88:	f8d2                	sd	s4,112(sp)
    4d8a:	f4d6                	sd	s5,104(sp)
    4d8c:	f0da                	sd	s6,96(sp)
    4d8e:	ecde                	sd	s7,88(sp)
    4d90:	1100                	addi	s0,sp,160
    4d92:	89aa                	mv	s3,a0
  file[0] = 'C';
    4d94:	04300793          	li	a5,67
    4d98:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4d9c:	fa040523          	sb	zero,-86(s0)
  for (i = 0; i < N; i++) {
    4da0:	4901                	li	s2,0
    if (pid && (i % 3) == 1) {
    4da2:	4b0d                	li	s6,3
    4da4:	4a85                	li	s5,1
      link("C0", file);
    4da6:	00003b97          	auipc	s7,0x3
    4daa:	f92b8b93          	addi	s7,s7,-110 # 7d38 <malloc+0x1e26>
  for (i = 0; i < N; i++) {
    4dae:	02800a13          	li	s4,40
    4db2:	acc9                	j	5084 <concreate+0x308>
      link("C0", file);
    4db4:	fa840593          	addi	a1,s0,-88
    4db8:	855e                	mv	a0,s7
    4dba:	00001097          	auipc	ra,0x1
    4dbe:	d86080e7          	jalr	-634(ra) # 5b40 <link>
    if (pid == 0) {
    4dc2:	a465                	j	506a <concreate+0x2ee>
    } else if (pid == 0 && (i % 5) == 1) {
    4dc4:	4795                	li	a5,5
    4dc6:	02f9693b          	remw	s2,s2,a5
    4dca:	4785                	li	a5,1
    4dcc:	02f90b63          	beq	s2,a5,4e02 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4dd0:	20200593          	li	a1,514
    4dd4:	fa840513          	addi	a0,s0,-88
    4dd8:	00001097          	auipc	ra,0x1
    4ddc:	d48080e7          	jalr	-696(ra) # 5b20 <open>
      if (fd < 0) {
    4de0:	26055c63          	bgez	a0,5058 <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    4de4:	fa840593          	addi	a1,s0,-88
    4de8:	00003517          	auipc	a0,0x3
    4dec:	f5850513          	addi	a0,a0,-168 # 7d40 <malloc+0x1e2e>
    4df0:	00001097          	auipc	ra,0x1
    4df4:	06a080e7          	jalr	106(ra) # 5e5a <printf>
        exit(1);
    4df8:	4505                	li	a0,1
    4dfa:	00001097          	auipc	ra,0x1
    4dfe:	ce6080e7          	jalr	-794(ra) # 5ae0 <exit>
      link("C0", file);
    4e02:	fa840593          	addi	a1,s0,-88
    4e06:	00003517          	auipc	a0,0x3
    4e0a:	f3250513          	addi	a0,a0,-206 # 7d38 <malloc+0x1e26>
    4e0e:	00001097          	auipc	ra,0x1
    4e12:	d32080e7          	jalr	-718(ra) # 5b40 <link>
      exit(0);
    4e16:	4501                	li	a0,0
    4e18:	00001097          	auipc	ra,0x1
    4e1c:	cc8080e7          	jalr	-824(ra) # 5ae0 <exit>
      if (xstatus != 0) exit(1);
    4e20:	4505                	li	a0,1
    4e22:	00001097          	auipc	ra,0x1
    4e26:	cbe080e7          	jalr	-834(ra) # 5ae0 <exit>
  memset(fa, 0, sizeof(fa));
    4e2a:	02800613          	li	a2,40
    4e2e:	4581                	li	a1,0
    4e30:	f8040513          	addi	a0,s0,-128
    4e34:	00001097          	auipc	ra,0x1
    4e38:	ab2080e7          	jalr	-1358(ra) # 58e6 <memset>
  fd = open(".", 0);
    4e3c:	4581                	li	a1,0
    4e3e:	00002517          	auipc	a0,0x2
    4e42:	8f250513          	addi	a0,a0,-1806 # 6730 <malloc+0x81e>
    4e46:	00001097          	auipc	ra,0x1
    4e4a:	cda080e7          	jalr	-806(ra) # 5b20 <open>
    4e4e:	892a                	mv	s2,a0
  n = 0;
    4e50:	8aa6                	mv	s5,s1
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    4e52:	04300a13          	li	s4,67
      if (i < 0 || i >= sizeof(fa)) {
    4e56:	02700b13          	li	s6,39
      fa[i] = 1;
    4e5a:	4b85                	li	s7,1
  while (read(fd, &de, sizeof(de)) > 0) {
    4e5c:	4641                	li	a2,16
    4e5e:	f7040593          	addi	a1,s0,-144
    4e62:	854a                	mv	a0,s2
    4e64:	00001097          	auipc	ra,0x1
    4e68:	c94080e7          	jalr	-876(ra) # 5af8 <read>
    4e6c:	08a05263          	blez	a0,4ef0 <concreate+0x174>
    if (de.inum == 0) continue;
    4e70:	f7045783          	lhu	a5,-144(s0)
    4e74:	d7e5                	beqz	a5,4e5c <concreate+0xe0>
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    4e76:	f7244783          	lbu	a5,-142(s0)
    4e7a:	ff4791e3          	bne	a5,s4,4e5c <concreate+0xe0>
    4e7e:	f7444783          	lbu	a5,-140(s0)
    4e82:	ffe9                	bnez	a5,4e5c <concreate+0xe0>
      i = de.name[1] - '0';
    4e84:	f7344783          	lbu	a5,-141(s0)
    4e88:	fd07879b          	addiw	a5,a5,-48
    4e8c:	0007871b          	sext.w	a4,a5
      if (i < 0 || i >= sizeof(fa)) {
    4e90:	02eb6063          	bltu	s6,a4,4eb0 <concreate+0x134>
      if (fa[i]) {
    4e94:	fb070793          	addi	a5,a4,-80 # fb0 <linktest+0xbc>
    4e98:	97a2                	add	a5,a5,s0
    4e9a:	fd07c783          	lbu	a5,-48(a5)
    4e9e:	eb8d                	bnez	a5,4ed0 <concreate+0x154>
      fa[i] = 1;
    4ea0:	fb070793          	addi	a5,a4,-80
    4ea4:	00878733          	add	a4,a5,s0
    4ea8:	fd770823          	sb	s7,-48(a4)
      n++;
    4eac:	2a85                	addiw	s5,s5,1
    4eae:	b77d                	j	4e5c <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4eb0:	f7240613          	addi	a2,s0,-142
    4eb4:	85ce                	mv	a1,s3
    4eb6:	00003517          	auipc	a0,0x3
    4eba:	eaa50513          	addi	a0,a0,-342 # 7d60 <malloc+0x1e4e>
    4ebe:	00001097          	auipc	ra,0x1
    4ec2:	f9c080e7          	jalr	-100(ra) # 5e5a <printf>
        exit(1);
    4ec6:	4505                	li	a0,1
    4ec8:	00001097          	auipc	ra,0x1
    4ecc:	c18080e7          	jalr	-1000(ra) # 5ae0 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4ed0:	f7240613          	addi	a2,s0,-142
    4ed4:	85ce                	mv	a1,s3
    4ed6:	00003517          	auipc	a0,0x3
    4eda:	eaa50513          	addi	a0,a0,-342 # 7d80 <malloc+0x1e6e>
    4ede:	00001097          	auipc	ra,0x1
    4ee2:	f7c080e7          	jalr	-132(ra) # 5e5a <printf>
        exit(1);
    4ee6:	4505                	li	a0,1
    4ee8:	00001097          	auipc	ra,0x1
    4eec:	bf8080e7          	jalr	-1032(ra) # 5ae0 <exit>
  close(fd);
    4ef0:	854a                	mv	a0,s2
    4ef2:	00001097          	auipc	ra,0x1
    4ef6:	c16080e7          	jalr	-1002(ra) # 5b08 <close>
  if (n != N) {
    4efa:	02800793          	li	a5,40
    4efe:	00fa9763          	bne	s5,a5,4f0c <concreate+0x190>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    4f02:	4a8d                	li	s5,3
    4f04:	4b05                	li	s6,1
  for (i = 0; i < N; i++) {
    4f06:	02800a13          	li	s4,40
    4f0a:	a8c9                	j	4fdc <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    4f0c:	85ce                	mv	a1,s3
    4f0e:	00003517          	auipc	a0,0x3
    4f12:	e9a50513          	addi	a0,a0,-358 # 7da8 <malloc+0x1e96>
    4f16:	00001097          	auipc	ra,0x1
    4f1a:	f44080e7          	jalr	-188(ra) # 5e5a <printf>
    exit(1);
    4f1e:	4505                	li	a0,1
    4f20:	00001097          	auipc	ra,0x1
    4f24:	bc0080e7          	jalr	-1088(ra) # 5ae0 <exit>
      printf("%s: fork failed\n", s);
    4f28:	85ce                	mv	a1,s3
    4f2a:	00002517          	auipc	a0,0x2
    4f2e:	9a650513          	addi	a0,a0,-1626 # 68d0 <malloc+0x9be>
    4f32:	00001097          	auipc	ra,0x1
    4f36:	f28080e7          	jalr	-216(ra) # 5e5a <printf>
      exit(1);
    4f3a:	4505                	li	a0,1
    4f3c:	00001097          	auipc	ra,0x1
    4f40:	ba4080e7          	jalr	-1116(ra) # 5ae0 <exit>
      close(open(file, 0));
    4f44:	4581                	li	a1,0
    4f46:	fa840513          	addi	a0,s0,-88
    4f4a:	00001097          	auipc	ra,0x1
    4f4e:	bd6080e7          	jalr	-1066(ra) # 5b20 <open>
    4f52:	00001097          	auipc	ra,0x1
    4f56:	bb6080e7          	jalr	-1098(ra) # 5b08 <close>
      close(open(file, 0));
    4f5a:	4581                	li	a1,0
    4f5c:	fa840513          	addi	a0,s0,-88
    4f60:	00001097          	auipc	ra,0x1
    4f64:	bc0080e7          	jalr	-1088(ra) # 5b20 <open>
    4f68:	00001097          	auipc	ra,0x1
    4f6c:	ba0080e7          	jalr	-1120(ra) # 5b08 <close>
      close(open(file, 0));
    4f70:	4581                	li	a1,0
    4f72:	fa840513          	addi	a0,s0,-88
    4f76:	00001097          	auipc	ra,0x1
    4f7a:	baa080e7          	jalr	-1110(ra) # 5b20 <open>
    4f7e:	00001097          	auipc	ra,0x1
    4f82:	b8a080e7          	jalr	-1142(ra) # 5b08 <close>
      close(open(file, 0));
    4f86:	4581                	li	a1,0
    4f88:	fa840513          	addi	a0,s0,-88
    4f8c:	00001097          	auipc	ra,0x1
    4f90:	b94080e7          	jalr	-1132(ra) # 5b20 <open>
    4f94:	00001097          	auipc	ra,0x1
    4f98:	b74080e7          	jalr	-1164(ra) # 5b08 <close>
      close(open(file, 0));
    4f9c:	4581                	li	a1,0
    4f9e:	fa840513          	addi	a0,s0,-88
    4fa2:	00001097          	auipc	ra,0x1
    4fa6:	b7e080e7          	jalr	-1154(ra) # 5b20 <open>
    4faa:	00001097          	auipc	ra,0x1
    4fae:	b5e080e7          	jalr	-1186(ra) # 5b08 <close>
      close(open(file, 0));
    4fb2:	4581                	li	a1,0
    4fb4:	fa840513          	addi	a0,s0,-88
    4fb8:	00001097          	auipc	ra,0x1
    4fbc:	b68080e7          	jalr	-1176(ra) # 5b20 <open>
    4fc0:	00001097          	auipc	ra,0x1
    4fc4:	b48080e7          	jalr	-1208(ra) # 5b08 <close>
    if (pid == 0)
    4fc8:	08090363          	beqz	s2,504e <concreate+0x2d2>
      wait(0);
    4fcc:	4501                	li	a0,0
    4fce:	00001097          	auipc	ra,0x1
    4fd2:	b1a080e7          	jalr	-1254(ra) # 5ae8 <wait>
  for (i = 0; i < N; i++) {
    4fd6:	2485                	addiw	s1,s1,1
    4fd8:	0f448563          	beq	s1,s4,50c2 <concreate+0x346>
    file[1] = '0' + i;
    4fdc:	0304879b          	addiw	a5,s1,48
    4fe0:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4fe4:	00001097          	auipc	ra,0x1
    4fe8:	af4080e7          	jalr	-1292(ra) # 5ad8 <fork>
    4fec:	892a                	mv	s2,a0
    if (pid < 0) {
    4fee:	f2054de3          	bltz	a0,4f28 <concreate+0x1ac>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    4ff2:	0354e73b          	remw	a4,s1,s5
    4ff6:	00a767b3          	or	a5,a4,a0
    4ffa:	2781                	sext.w	a5,a5
    4ffc:	d7a1                	beqz	a5,4f44 <concreate+0x1c8>
    4ffe:	01671363          	bne	a4,s6,5004 <concreate+0x288>
    5002:	f129                	bnez	a0,4f44 <concreate+0x1c8>
      unlink(file);
    5004:	fa840513          	addi	a0,s0,-88
    5008:	00001097          	auipc	ra,0x1
    500c:	b28080e7          	jalr	-1240(ra) # 5b30 <unlink>
      unlink(file);
    5010:	fa840513          	addi	a0,s0,-88
    5014:	00001097          	auipc	ra,0x1
    5018:	b1c080e7          	jalr	-1252(ra) # 5b30 <unlink>
      unlink(file);
    501c:	fa840513          	addi	a0,s0,-88
    5020:	00001097          	auipc	ra,0x1
    5024:	b10080e7          	jalr	-1264(ra) # 5b30 <unlink>
      unlink(file);
    5028:	fa840513          	addi	a0,s0,-88
    502c:	00001097          	auipc	ra,0x1
    5030:	b04080e7          	jalr	-1276(ra) # 5b30 <unlink>
      unlink(file);
    5034:	fa840513          	addi	a0,s0,-88
    5038:	00001097          	auipc	ra,0x1
    503c:	af8080e7          	jalr	-1288(ra) # 5b30 <unlink>
      unlink(file);
    5040:	fa840513          	addi	a0,s0,-88
    5044:	00001097          	auipc	ra,0x1
    5048:	aec080e7          	jalr	-1300(ra) # 5b30 <unlink>
    504c:	bfb5                	j	4fc8 <concreate+0x24c>
      exit(0);
    504e:	4501                	li	a0,0
    5050:	00001097          	auipc	ra,0x1
    5054:	a90080e7          	jalr	-1392(ra) # 5ae0 <exit>
      close(fd);
    5058:	00001097          	auipc	ra,0x1
    505c:	ab0080e7          	jalr	-1360(ra) # 5b08 <close>
    if (pid == 0) {
    5060:	bb5d                	j	4e16 <concreate+0x9a>
      close(fd);
    5062:	00001097          	auipc	ra,0x1
    5066:	aa6080e7          	jalr	-1370(ra) # 5b08 <close>
      wait(&xstatus);
    506a:	f6c40513          	addi	a0,s0,-148
    506e:	00001097          	auipc	ra,0x1
    5072:	a7a080e7          	jalr	-1414(ra) # 5ae8 <wait>
      if (xstatus != 0) exit(1);
    5076:	f6c42483          	lw	s1,-148(s0)
    507a:	da0493e3          	bnez	s1,4e20 <concreate+0xa4>
  for (i = 0; i < N; i++) {
    507e:	2905                	addiw	s2,s2,1
    5080:	db4905e3          	beq	s2,s4,4e2a <concreate+0xae>
    file[1] = '0' + i;
    5084:	0309079b          	addiw	a5,s2,48
    5088:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    508c:	fa840513          	addi	a0,s0,-88
    5090:	00001097          	auipc	ra,0x1
    5094:	aa0080e7          	jalr	-1376(ra) # 5b30 <unlink>
    pid = fork();
    5098:	00001097          	auipc	ra,0x1
    509c:	a40080e7          	jalr	-1472(ra) # 5ad8 <fork>
    if (pid && (i % 3) == 1) {
    50a0:	d20502e3          	beqz	a0,4dc4 <concreate+0x48>
    50a4:	036967bb          	remw	a5,s2,s6
    50a8:	d15786e3          	beq	a5,s5,4db4 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    50ac:	20200593          	li	a1,514
    50b0:	fa840513          	addi	a0,s0,-88
    50b4:	00001097          	auipc	ra,0x1
    50b8:	a6c080e7          	jalr	-1428(ra) # 5b20 <open>
      if (fd < 0) {
    50bc:	fa0553e3          	bgez	a0,5062 <concreate+0x2e6>
    50c0:	b315                	j	4de4 <concreate+0x68>
}
    50c2:	60ea                	ld	ra,152(sp)
    50c4:	644a                	ld	s0,144(sp)
    50c6:	64aa                	ld	s1,136(sp)
    50c8:	690a                	ld	s2,128(sp)
    50ca:	79e6                	ld	s3,120(sp)
    50cc:	7a46                	ld	s4,112(sp)
    50ce:	7aa6                	ld	s5,104(sp)
    50d0:	7b06                	ld	s6,96(sp)
    50d2:	6be6                	ld	s7,88(sp)
    50d4:	610d                	addi	sp,sp,160
    50d6:	8082                	ret

00000000000050d8 <bigfile>:
void bigfile(char *s) {
    50d8:	7139                	addi	sp,sp,-64
    50da:	fc06                	sd	ra,56(sp)
    50dc:	f822                	sd	s0,48(sp)
    50de:	f426                	sd	s1,40(sp)
    50e0:	f04a                	sd	s2,32(sp)
    50e2:	ec4e                	sd	s3,24(sp)
    50e4:	e852                	sd	s4,16(sp)
    50e6:	e456                	sd	s5,8(sp)
    50e8:	0080                	addi	s0,sp,64
    50ea:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    50ec:	00003517          	auipc	a0,0x3
    50f0:	cf450513          	addi	a0,a0,-780 # 7de0 <malloc+0x1ece>
    50f4:	00001097          	auipc	ra,0x1
    50f8:	a3c080e7          	jalr	-1476(ra) # 5b30 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    50fc:	20200593          	li	a1,514
    5100:	00003517          	auipc	a0,0x3
    5104:	ce050513          	addi	a0,a0,-800 # 7de0 <malloc+0x1ece>
    5108:	00001097          	auipc	ra,0x1
    510c:	a18080e7          	jalr	-1512(ra) # 5b20 <open>
    5110:	89aa                	mv	s3,a0
  for (i = 0; i < N; i++) {
    5112:	4481                	li	s1,0
    memset(buf, i, SZ);
    5114:	00008917          	auipc	s2,0x8
    5118:	b5490913          	addi	s2,s2,-1196 # cc68 <buf>
  for (i = 0; i < N; i++) {
    511c:	4a51                	li	s4,20
  if (fd < 0) {
    511e:	0a054063          	bltz	a0,51be <bigfile+0xe6>
    memset(buf, i, SZ);
    5122:	25800613          	li	a2,600
    5126:	85a6                	mv	a1,s1
    5128:	854a                	mv	a0,s2
    512a:	00000097          	auipc	ra,0x0
    512e:	7bc080e7          	jalr	1980(ra) # 58e6 <memset>
    if (write(fd, buf, SZ) != SZ) {
    5132:	25800613          	li	a2,600
    5136:	85ca                	mv	a1,s2
    5138:	854e                	mv	a0,s3
    513a:	00001097          	auipc	ra,0x1
    513e:	9c6080e7          	jalr	-1594(ra) # 5b00 <write>
    5142:	25800793          	li	a5,600
    5146:	08f51a63          	bne	a0,a5,51da <bigfile+0x102>
  for (i = 0; i < N; i++) {
    514a:	2485                	addiw	s1,s1,1
    514c:	fd449be3          	bne	s1,s4,5122 <bigfile+0x4a>
  close(fd);
    5150:	854e                	mv	a0,s3
    5152:	00001097          	auipc	ra,0x1
    5156:	9b6080e7          	jalr	-1610(ra) # 5b08 <close>
  fd = open("bigfile.dat", 0);
    515a:	4581                	li	a1,0
    515c:	00003517          	auipc	a0,0x3
    5160:	c8450513          	addi	a0,a0,-892 # 7de0 <malloc+0x1ece>
    5164:	00001097          	auipc	ra,0x1
    5168:	9bc080e7          	jalr	-1604(ra) # 5b20 <open>
    516c:	8a2a                	mv	s4,a0
  total = 0;
    516e:	4981                	li	s3,0
  for (i = 0;; i++) {
    5170:	4481                	li	s1,0
    cc = read(fd, buf, SZ / 2);
    5172:	00008917          	auipc	s2,0x8
    5176:	af690913          	addi	s2,s2,-1290 # cc68 <buf>
  if (fd < 0) {
    517a:	06054e63          	bltz	a0,51f6 <bigfile+0x11e>
    cc = read(fd, buf, SZ / 2);
    517e:	12c00613          	li	a2,300
    5182:	85ca                	mv	a1,s2
    5184:	8552                	mv	a0,s4
    5186:	00001097          	auipc	ra,0x1
    518a:	972080e7          	jalr	-1678(ra) # 5af8 <read>
    if (cc < 0) {
    518e:	08054263          	bltz	a0,5212 <bigfile+0x13a>
    if (cc == 0) break;
    5192:	c971                	beqz	a0,5266 <bigfile+0x18e>
    if (cc != SZ / 2) {
    5194:	12c00793          	li	a5,300
    5198:	08f51b63          	bne	a0,a5,522e <bigfile+0x156>
    if (buf[0] != i / 2 || buf[SZ / 2 - 1] != i / 2) {
    519c:	01f4d79b          	srliw	a5,s1,0x1f
    51a0:	9fa5                	addw	a5,a5,s1
    51a2:	4017d79b          	sraiw	a5,a5,0x1
    51a6:	00094703          	lbu	a4,0(s2)
    51aa:	0af71063          	bne	a4,a5,524a <bigfile+0x172>
    51ae:	12b94703          	lbu	a4,299(s2)
    51b2:	08f71c63          	bne	a4,a5,524a <bigfile+0x172>
    total += cc;
    51b6:	12c9899b          	addiw	s3,s3,300
  for (i = 0;; i++) {
    51ba:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ / 2);
    51bc:	b7c9                	j	517e <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    51be:	85d6                	mv	a1,s5
    51c0:	00003517          	auipc	a0,0x3
    51c4:	c3050513          	addi	a0,a0,-976 # 7df0 <malloc+0x1ede>
    51c8:	00001097          	auipc	ra,0x1
    51cc:	c92080e7          	jalr	-878(ra) # 5e5a <printf>
    exit(1);
    51d0:	4505                	li	a0,1
    51d2:	00001097          	auipc	ra,0x1
    51d6:	90e080e7          	jalr	-1778(ra) # 5ae0 <exit>
      printf("%s: write bigfile failed\n", s);
    51da:	85d6                	mv	a1,s5
    51dc:	00003517          	auipc	a0,0x3
    51e0:	c3450513          	addi	a0,a0,-972 # 7e10 <malloc+0x1efe>
    51e4:	00001097          	auipc	ra,0x1
    51e8:	c76080e7          	jalr	-906(ra) # 5e5a <printf>
      exit(1);
    51ec:	4505                	li	a0,1
    51ee:	00001097          	auipc	ra,0x1
    51f2:	8f2080e7          	jalr	-1806(ra) # 5ae0 <exit>
    printf("%s: cannot open bigfile\n", s);
    51f6:	85d6                	mv	a1,s5
    51f8:	00003517          	auipc	a0,0x3
    51fc:	c3850513          	addi	a0,a0,-968 # 7e30 <malloc+0x1f1e>
    5200:	00001097          	auipc	ra,0x1
    5204:	c5a080e7          	jalr	-934(ra) # 5e5a <printf>
    exit(1);
    5208:	4505                	li	a0,1
    520a:	00001097          	auipc	ra,0x1
    520e:	8d6080e7          	jalr	-1834(ra) # 5ae0 <exit>
      printf("%s: read bigfile failed\n", s);
    5212:	85d6                	mv	a1,s5
    5214:	00003517          	auipc	a0,0x3
    5218:	c3c50513          	addi	a0,a0,-964 # 7e50 <malloc+0x1f3e>
    521c:	00001097          	auipc	ra,0x1
    5220:	c3e080e7          	jalr	-962(ra) # 5e5a <printf>
      exit(1);
    5224:	4505                	li	a0,1
    5226:	00001097          	auipc	ra,0x1
    522a:	8ba080e7          	jalr	-1862(ra) # 5ae0 <exit>
      printf("%s: short read bigfile\n", s);
    522e:	85d6                	mv	a1,s5
    5230:	00003517          	auipc	a0,0x3
    5234:	c4050513          	addi	a0,a0,-960 # 7e70 <malloc+0x1f5e>
    5238:	00001097          	auipc	ra,0x1
    523c:	c22080e7          	jalr	-990(ra) # 5e5a <printf>
      exit(1);
    5240:	4505                	li	a0,1
    5242:	00001097          	auipc	ra,0x1
    5246:	89e080e7          	jalr	-1890(ra) # 5ae0 <exit>
      printf("%s: read bigfile wrong data\n", s);
    524a:	85d6                	mv	a1,s5
    524c:	00003517          	auipc	a0,0x3
    5250:	c3c50513          	addi	a0,a0,-964 # 7e88 <malloc+0x1f76>
    5254:	00001097          	auipc	ra,0x1
    5258:	c06080e7          	jalr	-1018(ra) # 5e5a <printf>
      exit(1);
    525c:	4505                	li	a0,1
    525e:	00001097          	auipc	ra,0x1
    5262:	882080e7          	jalr	-1918(ra) # 5ae0 <exit>
  close(fd);
    5266:	8552                	mv	a0,s4
    5268:	00001097          	auipc	ra,0x1
    526c:	8a0080e7          	jalr	-1888(ra) # 5b08 <close>
  if (total != N * SZ) {
    5270:	678d                	lui	a5,0x3
    5272:	ee078793          	addi	a5,a5,-288 # 2ee0 <execout+0x66>
    5276:	02f99363          	bne	s3,a5,529c <bigfile+0x1c4>
  unlink("bigfile.dat");
    527a:	00003517          	auipc	a0,0x3
    527e:	b6650513          	addi	a0,a0,-1178 # 7de0 <malloc+0x1ece>
    5282:	00001097          	auipc	ra,0x1
    5286:	8ae080e7          	jalr	-1874(ra) # 5b30 <unlink>
}
    528a:	70e2                	ld	ra,56(sp)
    528c:	7442                	ld	s0,48(sp)
    528e:	74a2                	ld	s1,40(sp)
    5290:	7902                	ld	s2,32(sp)
    5292:	69e2                	ld	s3,24(sp)
    5294:	6a42                	ld	s4,16(sp)
    5296:	6aa2                	ld	s5,8(sp)
    5298:	6121                	addi	sp,sp,64
    529a:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    529c:	85d6                	mv	a1,s5
    529e:	00003517          	auipc	a0,0x3
    52a2:	c0a50513          	addi	a0,a0,-1014 # 7ea8 <malloc+0x1f96>
    52a6:	00001097          	auipc	ra,0x1
    52aa:	bb4080e7          	jalr	-1100(ra) # 5e5a <printf>
    exit(1);
    52ae:	4505                	li	a0,1
    52b0:	00001097          	auipc	ra,0x1
    52b4:	830080e7          	jalr	-2000(ra) # 5ae0 <exit>

00000000000052b8 <fsfull>:
void fsfull() {
    52b8:	7171                	addi	sp,sp,-176
    52ba:	f506                	sd	ra,168(sp)
    52bc:	f122                	sd	s0,160(sp)
    52be:	ed26                	sd	s1,152(sp)
    52c0:	e94a                	sd	s2,144(sp)
    52c2:	e54e                	sd	s3,136(sp)
    52c4:	e152                	sd	s4,128(sp)
    52c6:	fcd6                	sd	s5,120(sp)
    52c8:	f8da                	sd	s6,112(sp)
    52ca:	f4de                	sd	s7,104(sp)
    52cc:	f0e2                	sd	s8,96(sp)
    52ce:	ece6                	sd	s9,88(sp)
    52d0:	e8ea                	sd	s10,80(sp)
    52d2:	e4ee                	sd	s11,72(sp)
    52d4:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    52d6:	00003517          	auipc	a0,0x3
    52da:	bf250513          	addi	a0,a0,-1038 # 7ec8 <malloc+0x1fb6>
    52de:	00001097          	auipc	ra,0x1
    52e2:	b7c080e7          	jalr	-1156(ra) # 5e5a <printf>
  for (nfiles = 0;; nfiles++) {
    52e6:	4481                	li	s1,0
    name[0] = 'f';
    52e8:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    52ec:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    52f0:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    52f4:	4b29                	li	s6,10
    printf("writing %s\n", name);
    52f6:	00003c97          	auipc	s9,0x3
    52fa:	be2c8c93          	addi	s9,s9,-1054 # 7ed8 <malloc+0x1fc6>
    int total = 0;
    52fe:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    5300:	00008a17          	auipc	s4,0x8
    5304:	968a0a13          	addi	s4,s4,-1688 # cc68 <buf>
    name[0] = 'f';
    5308:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    530c:	0384c7bb          	divw	a5,s1,s8
    5310:	0307879b          	addiw	a5,a5,48
    5314:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5318:	0384e7bb          	remw	a5,s1,s8
    531c:	0377c7bb          	divw	a5,a5,s7
    5320:	0307879b          	addiw	a5,a5,48
    5324:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5328:	0374e7bb          	remw	a5,s1,s7
    532c:	0367c7bb          	divw	a5,a5,s6
    5330:	0307879b          	addiw	a5,a5,48
    5334:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    5338:	0364e7bb          	remw	a5,s1,s6
    533c:	0307879b          	addiw	a5,a5,48
    5340:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5344:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    5348:	f5040593          	addi	a1,s0,-176
    534c:	8566                	mv	a0,s9
    534e:	00001097          	auipc	ra,0x1
    5352:	b0c080e7          	jalr	-1268(ra) # 5e5a <printf>
    int fd = open(name, O_CREATE | O_RDWR);
    5356:	20200593          	li	a1,514
    535a:	f5040513          	addi	a0,s0,-176
    535e:	00000097          	auipc	ra,0x0
    5362:	7c2080e7          	jalr	1986(ra) # 5b20 <open>
    5366:	892a                	mv	s2,a0
    if (fd < 0) {
    5368:	0a055663          	bgez	a0,5414 <fsfull+0x15c>
      printf("open %s failed\n", name);
    536c:	f5040593          	addi	a1,s0,-176
    5370:	00003517          	auipc	a0,0x3
    5374:	b7850513          	addi	a0,a0,-1160 # 7ee8 <malloc+0x1fd6>
    5378:	00001097          	auipc	ra,0x1
    537c:	ae2080e7          	jalr	-1310(ra) # 5e5a <printf>
  while (nfiles >= 0) {
    5380:	0604c363          	bltz	s1,53e6 <fsfull+0x12e>
    name[0] = 'f';
    5384:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    5388:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    538c:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5390:	4929                	li	s2,10
  while (nfiles >= 0) {
    5392:	5afd                	li	s5,-1
    name[0] = 'f';
    5394:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    5398:	0344c7bb          	divw	a5,s1,s4
    539c:	0307879b          	addiw	a5,a5,48
    53a0:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    53a4:	0344e7bb          	remw	a5,s1,s4
    53a8:	0337c7bb          	divw	a5,a5,s3
    53ac:	0307879b          	addiw	a5,a5,48
    53b0:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    53b4:	0334e7bb          	remw	a5,s1,s3
    53b8:	0327c7bb          	divw	a5,a5,s2
    53bc:	0307879b          	addiw	a5,a5,48
    53c0:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    53c4:	0324e7bb          	remw	a5,s1,s2
    53c8:	0307879b          	addiw	a5,a5,48
    53cc:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    53d0:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    53d4:	f5040513          	addi	a0,s0,-176
    53d8:	00000097          	auipc	ra,0x0
    53dc:	758080e7          	jalr	1880(ra) # 5b30 <unlink>
    nfiles--;
    53e0:	34fd                	addiw	s1,s1,-1
  while (nfiles >= 0) {
    53e2:	fb5499e3          	bne	s1,s5,5394 <fsfull+0xdc>
  printf("fsfull test finished\n");
    53e6:	00003517          	auipc	a0,0x3
    53ea:	b2250513          	addi	a0,a0,-1246 # 7f08 <malloc+0x1ff6>
    53ee:	00001097          	auipc	ra,0x1
    53f2:	a6c080e7          	jalr	-1428(ra) # 5e5a <printf>
}
    53f6:	70aa                	ld	ra,168(sp)
    53f8:	740a                	ld	s0,160(sp)
    53fa:	64ea                	ld	s1,152(sp)
    53fc:	694a                	ld	s2,144(sp)
    53fe:	69aa                	ld	s3,136(sp)
    5400:	6a0a                	ld	s4,128(sp)
    5402:	7ae6                	ld	s5,120(sp)
    5404:	7b46                	ld	s6,112(sp)
    5406:	7ba6                	ld	s7,104(sp)
    5408:	7c06                	ld	s8,96(sp)
    540a:	6ce6                	ld	s9,88(sp)
    540c:	6d46                	ld	s10,80(sp)
    540e:	6da6                	ld	s11,72(sp)
    5410:	614d                	addi	sp,sp,176
    5412:	8082                	ret
    int total = 0;
    5414:	89ee                	mv	s3,s11
      if (cc < BSIZE) break;
    5416:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    541a:	40000613          	li	a2,1024
    541e:	85d2                	mv	a1,s4
    5420:	854a                	mv	a0,s2
    5422:	00000097          	auipc	ra,0x0
    5426:	6de080e7          	jalr	1758(ra) # 5b00 <write>
      if (cc < BSIZE) break;
    542a:	00aad563          	bge	s5,a0,5434 <fsfull+0x17c>
      total += cc;
    542e:	00a989bb          	addw	s3,s3,a0
    while (1) {
    5432:	b7e5                	j	541a <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    5434:	85ce                	mv	a1,s3
    5436:	00003517          	auipc	a0,0x3
    543a:	ac250513          	addi	a0,a0,-1342 # 7ef8 <malloc+0x1fe6>
    543e:	00001097          	auipc	ra,0x1
    5442:	a1c080e7          	jalr	-1508(ra) # 5e5a <printf>
    close(fd);
    5446:	854a                	mv	a0,s2
    5448:	00000097          	auipc	ra,0x0
    544c:	6c0080e7          	jalr	1728(ra) # 5b08 <close>
    if (total == 0) break;
    5450:	f20988e3          	beqz	s3,5380 <fsfull+0xc8>
  for (nfiles = 0;; nfiles++) {
    5454:	2485                	addiw	s1,s1,1
    5456:	bd4d                	j	5308 <fsfull+0x50>

0000000000005458 <run>:
// drive tests
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int run(void f(char *), char *s) {
    5458:	7179                	addi	sp,sp,-48
    545a:	f406                	sd	ra,40(sp)
    545c:	f022                	sd	s0,32(sp)
    545e:	ec26                	sd	s1,24(sp)
    5460:	e84a                	sd	s2,16(sp)
    5462:	1800                	addi	s0,sp,48
    5464:	84aa                	mv	s1,a0
    5466:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5468:	00003517          	auipc	a0,0x3
    546c:	ab850513          	addi	a0,a0,-1352 # 7f20 <malloc+0x200e>
    5470:	00001097          	auipc	ra,0x1
    5474:	9ea080e7          	jalr	-1558(ra) # 5e5a <printf>
  if ((pid = fork()) < 0) {
    5478:	00000097          	auipc	ra,0x0
    547c:	660080e7          	jalr	1632(ra) # 5ad8 <fork>
    5480:	02054e63          	bltz	a0,54bc <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if (pid == 0) {
    5484:	c929                	beqz	a0,54d6 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5486:	fdc40513          	addi	a0,s0,-36
    548a:	00000097          	auipc	ra,0x0
    548e:	65e080e7          	jalr	1630(ra) # 5ae8 <wait>
    if (xstatus != 0)
    5492:	fdc42783          	lw	a5,-36(s0)
    5496:	c7b9                	beqz	a5,54e4 <run+0x8c>
      printf("FAILED\n");
    5498:	00003517          	auipc	a0,0x3
    549c:	ab050513          	addi	a0,a0,-1360 # 7f48 <malloc+0x2036>
    54a0:	00001097          	auipc	ra,0x1
    54a4:	9ba080e7          	jalr	-1606(ra) # 5e5a <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    54a8:	fdc42503          	lw	a0,-36(s0)
  }
}
    54ac:	00153513          	seqz	a0,a0
    54b0:	70a2                	ld	ra,40(sp)
    54b2:	7402                	ld	s0,32(sp)
    54b4:	64e2                	ld	s1,24(sp)
    54b6:	6942                	ld	s2,16(sp)
    54b8:	6145                	addi	sp,sp,48
    54ba:	8082                	ret
    printf("runtest: fork error\n");
    54bc:	00003517          	auipc	a0,0x3
    54c0:	a7450513          	addi	a0,a0,-1420 # 7f30 <malloc+0x201e>
    54c4:	00001097          	auipc	ra,0x1
    54c8:	996080e7          	jalr	-1642(ra) # 5e5a <printf>
    exit(1);
    54cc:	4505                	li	a0,1
    54ce:	00000097          	auipc	ra,0x0
    54d2:	612080e7          	jalr	1554(ra) # 5ae0 <exit>
    f(s);
    54d6:	854a                	mv	a0,s2
    54d8:	9482                	jalr	s1
    exit(0);
    54da:	4501                	li	a0,0
    54dc:	00000097          	auipc	ra,0x0
    54e0:	604080e7          	jalr	1540(ra) # 5ae0 <exit>
      printf("OK\n");
    54e4:	00003517          	auipc	a0,0x3
    54e8:	a6c50513          	addi	a0,a0,-1428 # 7f50 <malloc+0x203e>
    54ec:	00001097          	auipc	ra,0x1
    54f0:	96e080e7          	jalr	-1682(ra) # 5e5a <printf>
    54f4:	bf55                	j	54a8 <run+0x50>

00000000000054f6 <runtests>:

int runtests(struct test *tests, char *justone) {
    54f6:	1101                	addi	sp,sp,-32
    54f8:	ec06                	sd	ra,24(sp)
    54fa:	e822                	sd	s0,16(sp)
    54fc:	e426                	sd	s1,8(sp)
    54fe:	e04a                	sd	s2,0(sp)
    5500:	1000                	addi	s0,sp,32
    5502:	84aa                	mv	s1,a0
    5504:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    5506:	6508                	ld	a0,8(a0)
    5508:	ed09                	bnez	a0,5522 <runtests+0x2c>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    550a:	4501                	li	a0,0
    550c:	a82d                	j	5546 <runtests+0x50>
      if (!run(t->f, t->s)) {
    550e:	648c                	ld	a1,8(s1)
    5510:	6088                	ld	a0,0(s1)
    5512:	00000097          	auipc	ra,0x0
    5516:	f46080e7          	jalr	-186(ra) # 5458 <run>
    551a:	cd09                	beqz	a0,5534 <runtests+0x3e>
  for (struct test *t = tests; t->s != 0; t++) {
    551c:	04c1                	addi	s1,s1,16
    551e:	6488                	ld	a0,8(s1)
    5520:	c11d                	beqz	a0,5546 <runtests+0x50>
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
    5522:	fe0906e3          	beqz	s2,550e <runtests+0x18>
    5526:	85ca                	mv	a1,s2
    5528:	00000097          	auipc	ra,0x0
    552c:	368080e7          	jalr	872(ra) # 5890 <strcmp>
    5530:	f575                	bnez	a0,551c <runtests+0x26>
    5532:	bff1                	j	550e <runtests+0x18>
        printf("SOME TESTS FAILED\n");
    5534:	00003517          	auipc	a0,0x3
    5538:	a2450513          	addi	a0,a0,-1500 # 7f58 <malloc+0x2046>
    553c:	00001097          	auipc	ra,0x1
    5540:	91e080e7          	jalr	-1762(ra) # 5e5a <printf>
        return 1;
    5544:	4505                	li	a0,1
}
    5546:	60e2                	ld	ra,24(sp)
    5548:	6442                	ld	s0,16(sp)
    554a:	64a2                	ld	s1,8(sp)
    554c:	6902                	ld	s2,0(sp)
    554e:	6105                	addi	sp,sp,32
    5550:	8082                	ret

0000000000005552 <countfree>:
// use sbrk() to count how many free physical memory pages there are.
// touches the pages to force allocation.
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int countfree() {
    5552:	7139                	addi	sp,sp,-64
    5554:	fc06                	sd	ra,56(sp)
    5556:	f822                	sd	s0,48(sp)
    5558:	f426                	sd	s1,40(sp)
    555a:	f04a                	sd	s2,32(sp)
    555c:	ec4e                	sd	s3,24(sp)
    555e:	0080                	addi	s0,sp,64
  int fds[2];

  if (pipe(fds) < 0) {
    5560:	fc840513          	addi	a0,s0,-56
    5564:	00000097          	auipc	ra,0x0
    5568:	58c080e7          	jalr	1420(ra) # 5af0 <pipe>
    556c:	06054763          	bltz	a0,55da <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }

  int pid = fork();
    5570:	00000097          	auipc	ra,0x0
    5574:	568080e7          	jalr	1384(ra) # 5ad8 <fork>

  if (pid < 0) {
    5578:	06054e63          	bltz	a0,55f4 <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if (pid == 0) {
    557c:	ed51                	bnez	a0,5618 <countfree+0xc6>
    close(fds[0]);
    557e:	fc842503          	lw	a0,-56(s0)
    5582:	00000097          	auipc	ra,0x0
    5586:	586080e7          	jalr	1414(ra) # 5b08 <close>

    while (1) {
      uint64 a = (uint64)sbrk(4096);
      if (a == 0xffffffffffffffff) {
    558a:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    558c:	4485                	li	s1,1

      // report back one more page.
      if (write(fds[1], "x", 1) != 1) {
    558e:	00001997          	auipc	s3,0x1
    5592:	b1a98993          	addi	s3,s3,-1254 # 60a8 <malloc+0x196>
      uint64 a = (uint64)sbrk(4096);
    5596:	6505                	lui	a0,0x1
    5598:	00000097          	auipc	ra,0x0
    559c:	5d0080e7          	jalr	1488(ra) # 5b68 <sbrk>
      if (a == 0xffffffffffffffff) {
    55a0:	07250763          	beq	a0,s2,560e <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    55a4:	6785                	lui	a5,0x1
    55a6:	97aa                	add	a5,a5,a0
    55a8:	fe978fa3          	sb	s1,-1(a5) # fff <linktest+0x10b>
      if (write(fds[1], "x", 1) != 1) {
    55ac:	8626                	mv	a2,s1
    55ae:	85ce                	mv	a1,s3
    55b0:	fcc42503          	lw	a0,-52(s0)
    55b4:	00000097          	auipc	ra,0x0
    55b8:	54c080e7          	jalr	1356(ra) # 5b00 <write>
    55bc:	fc950de3          	beq	a0,s1,5596 <countfree+0x44>
        printf("write() failed in countfree()\n");
    55c0:	00003517          	auipc	a0,0x3
    55c4:	9f050513          	addi	a0,a0,-1552 # 7fb0 <malloc+0x209e>
    55c8:	00001097          	auipc	ra,0x1
    55cc:	892080e7          	jalr	-1902(ra) # 5e5a <printf>
        exit(1);
    55d0:	4505                	li	a0,1
    55d2:	00000097          	auipc	ra,0x0
    55d6:	50e080e7          	jalr	1294(ra) # 5ae0 <exit>
    printf("pipe() failed in countfree()\n");
    55da:	00003517          	auipc	a0,0x3
    55de:	99650513          	addi	a0,a0,-1642 # 7f70 <malloc+0x205e>
    55e2:	00001097          	auipc	ra,0x1
    55e6:	878080e7          	jalr	-1928(ra) # 5e5a <printf>
    exit(1);
    55ea:	4505                	li	a0,1
    55ec:	00000097          	auipc	ra,0x0
    55f0:	4f4080e7          	jalr	1268(ra) # 5ae0 <exit>
    printf("fork failed in countfree()\n");
    55f4:	00003517          	auipc	a0,0x3
    55f8:	99c50513          	addi	a0,a0,-1636 # 7f90 <malloc+0x207e>
    55fc:	00001097          	auipc	ra,0x1
    5600:	85e080e7          	jalr	-1954(ra) # 5e5a <printf>
    exit(1);
    5604:	4505                	li	a0,1
    5606:	00000097          	auipc	ra,0x0
    560a:	4da080e7          	jalr	1242(ra) # 5ae0 <exit>
      }
    }

    exit(0);
    560e:	4501                	li	a0,0
    5610:	00000097          	auipc	ra,0x0
    5614:	4d0080e7          	jalr	1232(ra) # 5ae0 <exit>
  }

  close(fds[1]);
    5618:	fcc42503          	lw	a0,-52(s0)
    561c:	00000097          	auipc	ra,0x0
    5620:	4ec080e7          	jalr	1260(ra) # 5b08 <close>
  int n = 0;
    5624:	4481                	li	s1,0
  while (1) {
    char c;
    int cc = read(fds[0], &c, 1);
    5626:	4605                	li	a2,1
    5628:	fc740593          	addi	a1,s0,-57
    562c:	fc842503          	lw	a0,-56(s0)
    5630:	00000097          	auipc	ra,0x0
    5634:	4c8080e7          	jalr	1224(ra) # 5af8 <read>
    if (cc < 0) {
    5638:	00054563          	bltz	a0,5642 <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if (cc == 0) break;
    563c:	c105                	beqz	a0,565c <countfree+0x10a>
    n += 1;
    563e:	2485                	addiw	s1,s1,1
  while (1) {
    5640:	b7dd                	j	5626 <countfree+0xd4>
      printf("read() failed in countfree()\n");
    5642:	00003517          	auipc	a0,0x3
    5646:	98e50513          	addi	a0,a0,-1650 # 7fd0 <malloc+0x20be>
    564a:	00001097          	auipc	ra,0x1
    564e:	810080e7          	jalr	-2032(ra) # 5e5a <printf>
      exit(1);
    5652:	4505                	li	a0,1
    5654:	00000097          	auipc	ra,0x0
    5658:	48c080e7          	jalr	1164(ra) # 5ae0 <exit>
  }

  close(fds[0]);
    565c:	fc842503          	lw	a0,-56(s0)
    5660:	00000097          	auipc	ra,0x0
    5664:	4a8080e7          	jalr	1192(ra) # 5b08 <close>
  wait((int *)0);
    5668:	4501                	li	a0,0
    566a:	00000097          	auipc	ra,0x0
    566e:	47e080e7          	jalr	1150(ra) # 5ae8 <wait>

  return n;
}
    5672:	8526                	mv	a0,s1
    5674:	70e2                	ld	ra,56(sp)
    5676:	7442                	ld	s0,48(sp)
    5678:	74a2                	ld	s1,40(sp)
    567a:	7902                	ld	s2,32(sp)
    567c:	69e2                	ld	s3,24(sp)
    567e:	6121                	addi	sp,sp,64
    5680:	8082                	ret

0000000000005682 <drivetests>:

int drivetests(int quick, int continuous, char *justone) {
    5682:	711d                	addi	sp,sp,-96
    5684:	ec86                	sd	ra,88(sp)
    5686:	e8a2                	sd	s0,80(sp)
    5688:	e4a6                	sd	s1,72(sp)
    568a:	e0ca                	sd	s2,64(sp)
    568c:	fc4e                	sd	s3,56(sp)
    568e:	f852                	sd	s4,48(sp)
    5690:	f456                	sd	s5,40(sp)
    5692:	f05a                	sd	s6,32(sp)
    5694:	ec5e                	sd	s7,24(sp)
    5696:	e862                	sd	s8,16(sp)
    5698:	e466                	sd	s9,8(sp)
    569a:	e06a                	sd	s10,0(sp)
    569c:	1080                	addi	s0,sp,96
    569e:	8a2a                	mv	s4,a0
    56a0:	89ae                	mv	s3,a1
    56a2:	8932                	mv	s2,a2
  do {
    printf("usertests starting\n");
    56a4:	00003b97          	auipc	s7,0x3
    56a8:	94cb8b93          	addi	s7,s7,-1716 # 7ff0 <malloc+0x20de>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone)) {
    56ac:	00004b17          	auipc	s6,0x4
    56b0:	964b0b13          	addi	s6,s6,-1692 # 9010 <quicktests>
      if (continuous != 2) {
    56b4:	4a89                	li	s5,2
          return 1;
        }
      }
    }
    if ((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    56b6:	00003c97          	auipc	s9,0x3
    56ba:	972c8c93          	addi	s9,s9,-1678 # 8028 <malloc+0x2116>
      if (runtests(slowtests, justone)) {
    56be:	00004c17          	auipc	s8,0x4
    56c2:	d12c0c13          	addi	s8,s8,-750 # 93d0 <slowtests>
      if (justone == 0) printf("usertests slow tests starting\n");
    56c6:	00003d17          	auipc	s10,0x3
    56ca:	942d0d13          	addi	s10,s10,-1726 # 8008 <malloc+0x20f6>
    56ce:	a839                	j	56ec <drivetests+0x6a>
    56d0:	856a                	mv	a0,s10
    56d2:	00000097          	auipc	ra,0x0
    56d6:	788080e7          	jalr	1928(ra) # 5e5a <printf>
    56da:	a081                	j	571a <drivetests+0x98>
    if ((free1 = countfree()) < free0) {
    56dc:	00000097          	auipc	ra,0x0
    56e0:	e76080e7          	jalr	-394(ra) # 5552 <countfree>
    56e4:	06954263          	blt	a0,s1,5748 <drivetests+0xc6>
      if (continuous != 2) {
        return 1;
      }
    }
  } while (continuous);
    56e8:	06098f63          	beqz	s3,5766 <drivetests+0xe4>
    printf("usertests starting\n");
    56ec:	855e                	mv	a0,s7
    56ee:	00000097          	auipc	ra,0x0
    56f2:	76c080e7          	jalr	1900(ra) # 5e5a <printf>
    int free0 = countfree();
    56f6:	00000097          	auipc	ra,0x0
    56fa:	e5c080e7          	jalr	-420(ra) # 5552 <countfree>
    56fe:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone)) {
    5700:	85ca                	mv	a1,s2
    5702:	855a                	mv	a0,s6
    5704:	00000097          	auipc	ra,0x0
    5708:	df2080e7          	jalr	-526(ra) # 54f6 <runtests>
    570c:	c119                	beqz	a0,5712 <drivetests+0x90>
      if (continuous != 2) {
    570e:	05599863          	bne	s3,s5,575e <drivetests+0xdc>
    if (!quick) {
    5712:	fc0a15e3          	bnez	s4,56dc <drivetests+0x5a>
      if (justone == 0) printf("usertests slow tests starting\n");
    5716:	fa090de3          	beqz	s2,56d0 <drivetests+0x4e>
      if (runtests(slowtests, justone)) {
    571a:	85ca                	mv	a1,s2
    571c:	8562                	mv	a0,s8
    571e:	00000097          	auipc	ra,0x0
    5722:	dd8080e7          	jalr	-552(ra) # 54f6 <runtests>
    5726:	d95d                	beqz	a0,56dc <drivetests+0x5a>
        if (continuous != 2) {
    5728:	03599d63          	bne	s3,s5,5762 <drivetests+0xe0>
    if ((free1 = countfree()) < free0) {
    572c:	00000097          	auipc	ra,0x0
    5730:	e26080e7          	jalr	-474(ra) # 5552 <countfree>
    5734:	fa955ae3          	bge	a0,s1,56e8 <drivetests+0x66>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5738:	8626                	mv	a2,s1
    573a:	85aa                	mv	a1,a0
    573c:	8566                	mv	a0,s9
    573e:	00000097          	auipc	ra,0x0
    5742:	71c080e7          	jalr	1820(ra) # 5e5a <printf>
      if (continuous != 2) {
    5746:	b75d                	j	56ec <drivetests+0x6a>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5748:	8626                	mv	a2,s1
    574a:	85aa                	mv	a1,a0
    574c:	8566                	mv	a0,s9
    574e:	00000097          	auipc	ra,0x0
    5752:	70c080e7          	jalr	1804(ra) # 5e5a <printf>
      if (continuous != 2) {
    5756:	f9598be3          	beq	s3,s5,56ec <drivetests+0x6a>
        return 1;
    575a:	4505                	li	a0,1
    575c:	a031                	j	5768 <drivetests+0xe6>
        return 1;
    575e:	4505                	li	a0,1
    5760:	a021                	j	5768 <drivetests+0xe6>
          return 1;
    5762:	4505                	li	a0,1
    5764:	a011                	j	5768 <drivetests+0xe6>
  return 0;
    5766:	854e                	mv	a0,s3
}
    5768:	60e6                	ld	ra,88(sp)
    576a:	6446                	ld	s0,80(sp)
    576c:	64a6                	ld	s1,72(sp)
    576e:	6906                	ld	s2,64(sp)
    5770:	79e2                	ld	s3,56(sp)
    5772:	7a42                	ld	s4,48(sp)
    5774:	7aa2                	ld	s5,40(sp)
    5776:	7b02                	ld	s6,32(sp)
    5778:	6be2                	ld	s7,24(sp)
    577a:	6c42                	ld	s8,16(sp)
    577c:	6ca2                	ld	s9,8(sp)
    577e:	6d02                	ld	s10,0(sp)
    5780:	6125                	addi	sp,sp,96
    5782:	8082                	ret

0000000000005784 <main>:

int main(int argc, char *argv[]) {
    5784:	1101                	addi	sp,sp,-32
    5786:	ec06                	sd	ra,24(sp)
    5788:	e822                	sd	s0,16(sp)
    578a:	e426                	sd	s1,8(sp)
    578c:	e04a                	sd	s2,0(sp)
    578e:	1000                	addi	s0,sp,32
    5790:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    5792:	4789                	li	a5,2
    5794:	02f50263          	beq	a0,a5,57b8 <main+0x34>
    continuous = 1;
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    continuous = 2;
  } else if (argc == 2 && argv[1][0] != '-') {
    justone = argv[1];
  } else if (argc > 1) {
    5798:	4785                	li	a5,1
    579a:	06a7cd63          	blt	a5,a0,5814 <main+0x90>
  char *justone = 0;
    579e:	4601                	li	a2,0
  int quick = 0;
    57a0:	4501                	li	a0,0
  int continuous = 0;
    57a2:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    57a4:	00000097          	auipc	ra,0x0
    57a8:	ede080e7          	jalr	-290(ra) # 5682 <drivetests>
    57ac:	c951                	beqz	a0,5840 <main+0xbc>
    exit(1);
    57ae:	4505                	li	a0,1
    57b0:	00000097          	auipc	ra,0x0
    57b4:	330080e7          	jalr	816(ra) # 5ae0 <exit>
    57b8:	892e                	mv	s2,a1
  if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    57ba:	00003597          	auipc	a1,0x3
    57be:	89e58593          	addi	a1,a1,-1890 # 8058 <malloc+0x2146>
    57c2:	00893503          	ld	a0,8(s2)
    57c6:	00000097          	auipc	ra,0x0
    57ca:	0ca080e7          	jalr	202(ra) # 5890 <strcmp>
    57ce:	85aa                	mv	a1,a0
    57d0:	cd39                	beqz	a0,582e <main+0xaa>
  } else if (argc == 2 && strcmp(argv[1], "-c") == 0) {
    57d2:	00003597          	auipc	a1,0x3
    57d6:	8de58593          	addi	a1,a1,-1826 # 80b0 <malloc+0x219e>
    57da:	00893503          	ld	a0,8(s2)
    57de:	00000097          	auipc	ra,0x0
    57e2:	0b2080e7          	jalr	178(ra) # 5890 <strcmp>
    57e6:	c931                	beqz	a0,583a <main+0xb6>
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    57e8:	00003597          	auipc	a1,0x3
    57ec:	8c058593          	addi	a1,a1,-1856 # 80a8 <malloc+0x2196>
    57f0:	00893503          	ld	a0,8(s2)
    57f4:	00000097          	auipc	ra,0x0
    57f8:	09c080e7          	jalr	156(ra) # 5890 <strcmp>
    57fc:	cd05                	beqz	a0,5834 <main+0xb0>
  } else if (argc == 2 && argv[1][0] != '-') {
    57fe:	00893603          	ld	a2,8(s2)
    5802:	00064703          	lbu	a4,0(a2) # 3000 <fourteen+0xc2>
    5806:	02d00793          	li	a5,45
    580a:	00f70563          	beq	a4,a5,5814 <main+0x90>
  int quick = 0;
    580e:	4501                	li	a0,0
  int continuous = 0;
    5810:	4581                	li	a1,0
    5812:	bf49                	j	57a4 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    5814:	00003517          	auipc	a0,0x3
    5818:	84c50513          	addi	a0,a0,-1972 # 8060 <malloc+0x214e>
    581c:	00000097          	auipc	ra,0x0
    5820:	63e080e7          	jalr	1598(ra) # 5e5a <printf>
    exit(1);
    5824:	4505                	li	a0,1
    5826:	00000097          	auipc	ra,0x0
    582a:	2ba080e7          	jalr	698(ra) # 5ae0 <exit>
  char *justone = 0;
    582e:	4601                	li	a2,0
    quick = 1;
    5830:	4505                	li	a0,1
    5832:	bf8d                	j	57a4 <main+0x20>
    continuous = 2;
    5834:	85a6                	mv	a1,s1
  char *justone = 0;
    5836:	4601                	li	a2,0
    5838:	b7b5                	j	57a4 <main+0x20>
    583a:	4601                	li	a2,0
    continuous = 1;
    583c:	4585                	li	a1,1
    583e:	b79d                	j	57a4 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    5840:	00003517          	auipc	a0,0x3
    5844:	85050513          	addi	a0,a0,-1968 # 8090 <malloc+0x217e>
    5848:	00000097          	auipc	ra,0x0
    584c:	612080e7          	jalr	1554(ra) # 5e5a <printf>
  exit(0);
    5850:	4501                	li	a0,0
    5852:	00000097          	auipc	ra,0x0
    5856:	28e080e7          	jalr	654(ra) # 5ae0 <exit>

000000000000585a <_main>:
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void _main() {
    585a:	1141                	addi	sp,sp,-16
    585c:	e406                	sd	ra,8(sp)
    585e:	e022                	sd	s0,0(sp)
    5860:	0800                	addi	s0,sp,16
  extern int main();
  main();
    5862:	00000097          	auipc	ra,0x0
    5866:	f22080e7          	jalr	-222(ra) # 5784 <main>
  exit(0);
    586a:	4501                	li	a0,0
    586c:	00000097          	auipc	ra,0x0
    5870:	274080e7          	jalr	628(ra) # 5ae0 <exit>

0000000000005874 <strcpy>:
}

char *strcpy(char *s, const char *t) {
    5874:	1141                	addi	sp,sp,-16
    5876:	e422                	sd	s0,8(sp)
    5878:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
    587a:	87aa                	mv	a5,a0
    587c:	0585                	addi	a1,a1,1
    587e:	0785                	addi	a5,a5,1
    5880:	fff5c703          	lbu	a4,-1(a1)
    5884:	fee78fa3          	sb	a4,-1(a5)
    5888:	fb75                	bnez	a4,587c <strcpy+0x8>
    ;
  return os;
}
    588a:	6422                	ld	s0,8(sp)
    588c:	0141                	addi	sp,sp,16
    588e:	8082                	ret

0000000000005890 <strcmp>:

int strcmp(const char *p, const char *q) {
    5890:	1141                	addi	sp,sp,-16
    5892:	e422                	sd	s0,8(sp)
    5894:	0800                	addi	s0,sp,16
  while (*p && *p == *q) p++, q++;
    5896:	00054783          	lbu	a5,0(a0)
    589a:	cb91                	beqz	a5,58ae <strcmp+0x1e>
    589c:	0005c703          	lbu	a4,0(a1)
    58a0:	00f71763          	bne	a4,a5,58ae <strcmp+0x1e>
    58a4:	0505                	addi	a0,a0,1
    58a6:	0585                	addi	a1,a1,1
    58a8:	00054783          	lbu	a5,0(a0)
    58ac:	fbe5                	bnez	a5,589c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    58ae:	0005c503          	lbu	a0,0(a1)
}
    58b2:	40a7853b          	subw	a0,a5,a0
    58b6:	6422                	ld	s0,8(sp)
    58b8:	0141                	addi	sp,sp,16
    58ba:	8082                	ret

00000000000058bc <strlen>:

uint strlen(const char *s) {
    58bc:	1141                	addi	sp,sp,-16
    58be:	e422                	sd	s0,8(sp)
    58c0:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    58c2:	00054783          	lbu	a5,0(a0)
    58c6:	cf91                	beqz	a5,58e2 <strlen+0x26>
    58c8:	0505                	addi	a0,a0,1
    58ca:	87aa                	mv	a5,a0
    58cc:	4685                	li	a3,1
    58ce:	9e89                	subw	a3,a3,a0
    58d0:	00f6853b          	addw	a0,a3,a5
    58d4:	0785                	addi	a5,a5,1
    58d6:	fff7c703          	lbu	a4,-1(a5)
    58da:	fb7d                	bnez	a4,58d0 <strlen+0x14>
    ;
  return n;
}
    58dc:	6422                	ld	s0,8(sp)
    58de:	0141                	addi	sp,sp,16
    58e0:	8082                	ret
  for (n = 0; s[n]; n++)
    58e2:	4501                	li	a0,0
    58e4:	bfe5                	j	58dc <strlen+0x20>

00000000000058e6 <memset>:

void *memset(void *dst, int c, uint n) {
    58e6:	1141                	addi	sp,sp,-16
    58e8:	e422                	sd	s0,8(sp)
    58ea:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    58ec:	ca19                	beqz	a2,5902 <memset+0x1c>
    58ee:	87aa                	mv	a5,a0
    58f0:	1602                	slli	a2,a2,0x20
    58f2:	9201                	srli	a2,a2,0x20
    58f4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    58f8:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    58fc:	0785                	addi	a5,a5,1
    58fe:	fee79de3          	bne	a5,a4,58f8 <memset+0x12>
  }
  return dst;
}
    5902:	6422                	ld	s0,8(sp)
    5904:	0141                	addi	sp,sp,16
    5906:	8082                	ret

0000000000005908 <strchr>:

char *strchr(const char *s, char c) {
    5908:	1141                	addi	sp,sp,-16
    590a:	e422                	sd	s0,8(sp)
    590c:	0800                	addi	s0,sp,16
  for (; *s; s++)
    590e:	00054783          	lbu	a5,0(a0)
    5912:	cb99                	beqz	a5,5928 <strchr+0x20>
    if (*s == c) return (char *)s;
    5914:	00f58763          	beq	a1,a5,5922 <strchr+0x1a>
  for (; *s; s++)
    5918:	0505                	addi	a0,a0,1
    591a:	00054783          	lbu	a5,0(a0)
    591e:	fbfd                	bnez	a5,5914 <strchr+0xc>
  return 0;
    5920:	4501                	li	a0,0
}
    5922:	6422                	ld	s0,8(sp)
    5924:	0141                	addi	sp,sp,16
    5926:	8082                	ret
  return 0;
    5928:	4501                	li	a0,0
    592a:	bfe5                	j	5922 <strchr+0x1a>

000000000000592c <gets>:

char *gets(char *buf, int max) {
    592c:	711d                	addi	sp,sp,-96
    592e:	ec86                	sd	ra,88(sp)
    5930:	e8a2                	sd	s0,80(sp)
    5932:	e4a6                	sd	s1,72(sp)
    5934:	e0ca                	sd	s2,64(sp)
    5936:	fc4e                	sd	s3,56(sp)
    5938:	f852                	sd	s4,48(sp)
    593a:	f456                	sd	s5,40(sp)
    593c:	f05a                	sd	s6,32(sp)
    593e:	ec5e                	sd	s7,24(sp)
    5940:	1080                	addi	s0,sp,96
    5942:	8baa                	mv	s7,a0
    5944:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
    5946:	892a                	mv	s2,a0
    5948:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1) break;
    buf[i++] = c;
    if (c == '\n' || c == '\r') break;
    594a:	4aa9                	li	s5,10
    594c:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
    594e:	89a6                	mv	s3,s1
    5950:	2485                	addiw	s1,s1,1
    5952:	0344d863          	bge	s1,s4,5982 <gets+0x56>
    cc = read(0, &c, 1);
    5956:	4605                	li	a2,1
    5958:	faf40593          	addi	a1,s0,-81
    595c:	4501                	li	a0,0
    595e:	00000097          	auipc	ra,0x0
    5962:	19a080e7          	jalr	410(ra) # 5af8 <read>
    if (cc < 1) break;
    5966:	00a05e63          	blez	a0,5982 <gets+0x56>
    buf[i++] = c;
    596a:	faf44783          	lbu	a5,-81(s0)
    596e:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r') break;
    5972:	01578763          	beq	a5,s5,5980 <gets+0x54>
    5976:	0905                	addi	s2,s2,1
    5978:	fd679be3          	bne	a5,s6,594e <gets+0x22>
  for (i = 0; i + 1 < max;) {
    597c:	89a6                	mv	s3,s1
    597e:	a011                	j	5982 <gets+0x56>
    5980:	89a6                	mv	s3,s1
  }
  buf[i] = '\0';
    5982:	99de                	add	s3,s3,s7
    5984:	00098023          	sb	zero,0(s3)
  return buf;
}
    5988:	855e                	mv	a0,s7
    598a:	60e6                	ld	ra,88(sp)
    598c:	6446                	ld	s0,80(sp)
    598e:	64a6                	ld	s1,72(sp)
    5990:	6906                	ld	s2,64(sp)
    5992:	79e2                	ld	s3,56(sp)
    5994:	7a42                	ld	s4,48(sp)
    5996:	7aa2                	ld	s5,40(sp)
    5998:	7b02                	ld	s6,32(sp)
    599a:	6be2                	ld	s7,24(sp)
    599c:	6125                	addi	sp,sp,96
    599e:	8082                	ret

00000000000059a0 <stat>:

int stat(const char *n, struct stat *st) {
    59a0:	1101                	addi	sp,sp,-32
    59a2:	ec06                	sd	ra,24(sp)
    59a4:	e822                	sd	s0,16(sp)
    59a6:	e426                	sd	s1,8(sp)
    59a8:	e04a                	sd	s2,0(sp)
    59aa:	1000                	addi	s0,sp,32
    59ac:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    59ae:	4581                	li	a1,0
    59b0:	00000097          	auipc	ra,0x0
    59b4:	170080e7          	jalr	368(ra) # 5b20 <open>
  if (fd < 0) return -1;
    59b8:	02054563          	bltz	a0,59e2 <stat+0x42>
    59bc:	84aa                	mv	s1,a0
  r = fstat(fd, st);
    59be:	85ca                	mv	a1,s2
    59c0:	00000097          	auipc	ra,0x0
    59c4:	178080e7          	jalr	376(ra) # 5b38 <fstat>
    59c8:	892a                	mv	s2,a0
  close(fd);
    59ca:	8526                	mv	a0,s1
    59cc:	00000097          	auipc	ra,0x0
    59d0:	13c080e7          	jalr	316(ra) # 5b08 <close>
  return r;
}
    59d4:	854a                	mv	a0,s2
    59d6:	60e2                	ld	ra,24(sp)
    59d8:	6442                	ld	s0,16(sp)
    59da:	64a2                	ld	s1,8(sp)
    59dc:	6902                	ld	s2,0(sp)
    59de:	6105                	addi	sp,sp,32
    59e0:	8082                	ret
  if (fd < 0) return -1;
    59e2:	597d                	li	s2,-1
    59e4:	bfc5                	j	59d4 <stat+0x34>

00000000000059e6 <atoi>:

int atoi(const char *s) {
    59e6:	1141                	addi	sp,sp,-16
    59e8:	e422                	sd	s0,8(sp)
    59ea:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
    59ec:	00054683          	lbu	a3,0(a0)
    59f0:	fd06879b          	addiw	a5,a3,-48
    59f4:	0ff7f793          	zext.b	a5,a5
    59f8:	4625                	li	a2,9
    59fa:	02f66863          	bltu	a2,a5,5a2a <atoi+0x44>
    59fe:	872a                	mv	a4,a0
  n = 0;
    5a00:	4501                	li	a0,0
  while ('0' <= *s && *s <= '9') n = n * 10 + *s++ - '0';
    5a02:	0705                	addi	a4,a4,1
    5a04:	0025179b          	slliw	a5,a0,0x2
    5a08:	9fa9                	addw	a5,a5,a0
    5a0a:	0017979b          	slliw	a5,a5,0x1
    5a0e:	9fb5                	addw	a5,a5,a3
    5a10:	fd07851b          	addiw	a0,a5,-48
    5a14:	00074683          	lbu	a3,0(a4)
    5a18:	fd06879b          	addiw	a5,a3,-48
    5a1c:	0ff7f793          	zext.b	a5,a5
    5a20:	fef671e3          	bgeu	a2,a5,5a02 <atoi+0x1c>
  return n;
}
    5a24:	6422                	ld	s0,8(sp)
    5a26:	0141                	addi	sp,sp,16
    5a28:	8082                	ret
  n = 0;
    5a2a:	4501                	li	a0,0
    5a2c:	bfe5                	j	5a24 <atoi+0x3e>

0000000000005a2e <memmove>:

void *memmove(void *vdst, const void *vsrc, int n) {
    5a2e:	1141                	addi	sp,sp,-16
    5a30:	e422                	sd	s0,8(sp)
    5a32:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5a34:	02b57463          	bgeu	a0,a1,5a5c <memmove+0x2e>
    while (n-- > 0) *dst++ = *src++;
    5a38:	00c05f63          	blez	a2,5a56 <memmove+0x28>
    5a3c:	1602                	slli	a2,a2,0x20
    5a3e:	9201                	srli	a2,a2,0x20
    5a40:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5a44:	872a                	mv	a4,a0
    while (n-- > 0) *dst++ = *src++;
    5a46:	0585                	addi	a1,a1,1
    5a48:	0705                	addi	a4,a4,1
    5a4a:	fff5c683          	lbu	a3,-1(a1)
    5a4e:	fed70fa3          	sb	a3,-1(a4)
    5a52:	fee79ae3          	bne	a5,a4,5a46 <memmove+0x18>
    dst += n;
    src += n;
    while (n-- > 0) *--dst = *--src;
  }
  return vdst;
}
    5a56:	6422                	ld	s0,8(sp)
    5a58:	0141                	addi	sp,sp,16
    5a5a:	8082                	ret
    dst += n;
    5a5c:	00c50733          	add	a4,a0,a2
    src += n;
    5a60:	95b2                	add	a1,a1,a2
    while (n-- > 0) *--dst = *--src;
    5a62:	fec05ae3          	blez	a2,5a56 <memmove+0x28>
    5a66:	fff6079b          	addiw	a5,a2,-1
    5a6a:	1782                	slli	a5,a5,0x20
    5a6c:	9381                	srli	a5,a5,0x20
    5a6e:	fff7c793          	not	a5,a5
    5a72:	97ba                	add	a5,a5,a4
    5a74:	15fd                	addi	a1,a1,-1
    5a76:	177d                	addi	a4,a4,-1
    5a78:	0005c683          	lbu	a3,0(a1)
    5a7c:	00d70023          	sb	a3,0(a4)
    5a80:	fee79ae3          	bne	a5,a4,5a74 <memmove+0x46>
    5a84:	bfc9                	j	5a56 <memmove+0x28>

0000000000005a86 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n) {
    5a86:	1141                	addi	sp,sp,-16
    5a88:	e422                	sd	s0,8(sp)
    5a8a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5a8c:	ca05                	beqz	a2,5abc <memcmp+0x36>
    5a8e:	fff6069b          	addiw	a3,a2,-1
    5a92:	1682                	slli	a3,a3,0x20
    5a94:	9281                	srli	a3,a3,0x20
    5a96:	0685                	addi	a3,a3,1
    5a98:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5a9a:	00054783          	lbu	a5,0(a0)
    5a9e:	0005c703          	lbu	a4,0(a1)
    5aa2:	00e79863          	bne	a5,a4,5ab2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5aa6:	0505                	addi	a0,a0,1
    p2++;
    5aa8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5aaa:	fed518e3          	bne	a0,a3,5a9a <memcmp+0x14>
  }
  return 0;
    5aae:	4501                	li	a0,0
    5ab0:	a019                	j	5ab6 <memcmp+0x30>
      return *p1 - *p2;
    5ab2:	40e7853b          	subw	a0,a5,a4
}
    5ab6:	6422                	ld	s0,8(sp)
    5ab8:	0141                	addi	sp,sp,16
    5aba:	8082                	ret
  return 0;
    5abc:	4501                	li	a0,0
    5abe:	bfe5                	j	5ab6 <memcmp+0x30>

0000000000005ac0 <memcpy>:

void *memcpy(void *dst, const void *src, uint n) {
    5ac0:	1141                	addi	sp,sp,-16
    5ac2:	e406                	sd	ra,8(sp)
    5ac4:	e022                	sd	s0,0(sp)
    5ac6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5ac8:	00000097          	auipc	ra,0x0
    5acc:	f66080e7          	jalr	-154(ra) # 5a2e <memmove>
}
    5ad0:	60a2                	ld	ra,8(sp)
    5ad2:	6402                	ld	s0,0(sp)
    5ad4:	0141                	addi	sp,sp,16
    5ad6:	8082                	ret

0000000000005ad8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5ad8:	4885                	li	a7,1
 ecall
    5ada:	00000073          	ecall
 ret
    5ade:	8082                	ret

0000000000005ae0 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5ae0:	4889                	li	a7,2
 ecall
    5ae2:	00000073          	ecall
 ret
    5ae6:	8082                	ret

0000000000005ae8 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5ae8:	488d                	li	a7,3
 ecall
    5aea:	00000073          	ecall
 ret
    5aee:	8082                	ret

0000000000005af0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5af0:	4891                	li	a7,4
 ecall
    5af2:	00000073          	ecall
 ret
    5af6:	8082                	ret

0000000000005af8 <read>:
.global read
read:
 li a7, SYS_read
    5af8:	4895                	li	a7,5
 ecall
    5afa:	00000073          	ecall
 ret
    5afe:	8082                	ret

0000000000005b00 <write>:
.global write
write:
 li a7, SYS_write
    5b00:	48c1                	li	a7,16
 ecall
    5b02:	00000073          	ecall
 ret
    5b06:	8082                	ret

0000000000005b08 <close>:
.global close
close:
 li a7, SYS_close
    5b08:	48d5                	li	a7,21
 ecall
    5b0a:	00000073          	ecall
 ret
    5b0e:	8082                	ret

0000000000005b10 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5b10:	4899                	li	a7,6
 ecall
    5b12:	00000073          	ecall
 ret
    5b16:	8082                	ret

0000000000005b18 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5b18:	489d                	li	a7,7
 ecall
    5b1a:	00000073          	ecall
 ret
    5b1e:	8082                	ret

0000000000005b20 <open>:
.global open
open:
 li a7, SYS_open
    5b20:	48bd                	li	a7,15
 ecall
    5b22:	00000073          	ecall
 ret
    5b26:	8082                	ret

0000000000005b28 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5b28:	48c5                	li	a7,17
 ecall
    5b2a:	00000073          	ecall
 ret
    5b2e:	8082                	ret

0000000000005b30 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5b30:	48c9                	li	a7,18
 ecall
    5b32:	00000073          	ecall
 ret
    5b36:	8082                	ret

0000000000005b38 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5b38:	48a1                	li	a7,8
 ecall
    5b3a:	00000073          	ecall
 ret
    5b3e:	8082                	ret

0000000000005b40 <link>:
.global link
link:
 li a7, SYS_link
    5b40:	48cd                	li	a7,19
 ecall
    5b42:	00000073          	ecall
 ret
    5b46:	8082                	ret

0000000000005b48 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5b48:	48d1                	li	a7,20
 ecall
    5b4a:	00000073          	ecall
 ret
    5b4e:	8082                	ret

0000000000005b50 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5b50:	48a5                	li	a7,9
 ecall
    5b52:	00000073          	ecall
 ret
    5b56:	8082                	ret

0000000000005b58 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5b58:	48a9                	li	a7,10
 ecall
    5b5a:	00000073          	ecall
 ret
    5b5e:	8082                	ret

0000000000005b60 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5b60:	48ad                	li	a7,11
 ecall
    5b62:	00000073          	ecall
 ret
    5b66:	8082                	ret

0000000000005b68 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5b68:	48b1                	li	a7,12
 ecall
    5b6a:	00000073          	ecall
 ret
    5b6e:	8082                	ret

0000000000005b70 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5b70:	48b5                	li	a7,13
 ecall
    5b72:	00000073          	ecall
 ret
    5b76:	8082                	ret

0000000000005b78 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5b78:	48b9                	li	a7,14
 ecall
    5b7a:	00000073          	ecall
 ret
    5b7e:	8082                	ret

0000000000005b80 <putc>:

#include <stdarg.h>

static char digits[] = "0123456789ABCDEF";

static void putc(int fd, char c) { write(fd, &c, 1); }
    5b80:	1101                	addi	sp,sp,-32
    5b82:	ec06                	sd	ra,24(sp)
    5b84:	e822                	sd	s0,16(sp)
    5b86:	1000                	addi	s0,sp,32
    5b88:	feb407a3          	sb	a1,-17(s0)
    5b8c:	4605                	li	a2,1
    5b8e:	fef40593          	addi	a1,s0,-17
    5b92:	00000097          	auipc	ra,0x0
    5b96:	f6e080e7          	jalr	-146(ra) # 5b00 <write>
    5b9a:	60e2                	ld	ra,24(sp)
    5b9c:	6442                	ld	s0,16(sp)
    5b9e:	6105                	addi	sp,sp,32
    5ba0:	8082                	ret

0000000000005ba2 <printint>:

static void printint(int fd, int xx, int base, int sgn) {
    5ba2:	7139                	addi	sp,sp,-64
    5ba4:	fc06                	sd	ra,56(sp)
    5ba6:	f822                	sd	s0,48(sp)
    5ba8:	f426                	sd	s1,40(sp)
    5baa:	f04a                	sd	s2,32(sp)
    5bac:	ec4e                	sd	s3,24(sp)
    5bae:	0080                	addi	s0,sp,64
    5bb0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if (sgn && xx < 0) {
    5bb2:	c299                	beqz	a3,5bb8 <printint+0x16>
    5bb4:	0805c963          	bltz	a1,5c46 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5bb8:	2581                	sext.w	a1,a1
  neg = 0;
    5bba:	4881                	li	a7,0
    5bbc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5bc0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    5bc2:	2601                	sext.w	a2,a2
    5bc4:	00003517          	auipc	a0,0x3
    5bc8:	8a450513          	addi	a0,a0,-1884 # 8468 <digits>
    5bcc:	883a                	mv	a6,a4
    5bce:	2705                	addiw	a4,a4,1
    5bd0:	02c5f7bb          	remuw	a5,a1,a2
    5bd4:	1782                	slli	a5,a5,0x20
    5bd6:	9381                	srli	a5,a5,0x20
    5bd8:	97aa                	add	a5,a5,a0
    5bda:	0007c783          	lbu	a5,0(a5)
    5bde:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    5be2:	0005879b          	sext.w	a5,a1
    5be6:	02c5d5bb          	divuw	a1,a1,a2
    5bea:	0685                	addi	a3,a3,1
    5bec:	fec7f0e3          	bgeu	a5,a2,5bcc <printint+0x2a>
  if (neg) buf[i++] = '-';
    5bf0:	00088c63          	beqz	a7,5c08 <printint+0x66>
    5bf4:	fd070793          	addi	a5,a4,-48
    5bf8:	00878733          	add	a4,a5,s0
    5bfc:	02d00793          	li	a5,45
    5c00:	fef70823          	sb	a5,-16(a4)
    5c04:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) putc(fd, buf[i]);
    5c08:	02e05863          	blez	a4,5c38 <printint+0x96>
    5c0c:	fc040793          	addi	a5,s0,-64
    5c10:	00e78933          	add	s2,a5,a4
    5c14:	fff78993          	addi	s3,a5,-1
    5c18:	99ba                	add	s3,s3,a4
    5c1a:	377d                	addiw	a4,a4,-1
    5c1c:	1702                	slli	a4,a4,0x20
    5c1e:	9301                	srli	a4,a4,0x20
    5c20:	40e989b3          	sub	s3,s3,a4
    5c24:	fff94583          	lbu	a1,-1(s2)
    5c28:	8526                	mv	a0,s1
    5c2a:	00000097          	auipc	ra,0x0
    5c2e:	f56080e7          	jalr	-170(ra) # 5b80 <putc>
    5c32:	197d                	addi	s2,s2,-1
    5c34:	ff3918e3          	bne	s2,s3,5c24 <printint+0x82>
}
    5c38:	70e2                	ld	ra,56(sp)
    5c3a:	7442                	ld	s0,48(sp)
    5c3c:	74a2                	ld	s1,40(sp)
    5c3e:	7902                	ld	s2,32(sp)
    5c40:	69e2                	ld	s3,24(sp)
    5c42:	6121                	addi	sp,sp,64
    5c44:	8082                	ret
    x = -xx;
    5c46:	40b005bb          	negw	a1,a1
    neg = 1;
    5c4a:	4885                	li	a7,1
    x = -xx;
    5c4c:	bf85                	j	5bbc <printint+0x1a>

0000000000005c4e <vprintf>:
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void vprintf(int fd, const char *fmt, va_list ap) {
    5c4e:	7119                	addi	sp,sp,-128
    5c50:	fc86                	sd	ra,120(sp)
    5c52:	f8a2                	sd	s0,112(sp)
    5c54:	f4a6                	sd	s1,104(sp)
    5c56:	f0ca                	sd	s2,96(sp)
    5c58:	ecce                	sd	s3,88(sp)
    5c5a:	e8d2                	sd	s4,80(sp)
    5c5c:	e4d6                	sd	s5,72(sp)
    5c5e:	e0da                	sd	s6,64(sp)
    5c60:	fc5e                	sd	s7,56(sp)
    5c62:	f862                	sd	s8,48(sp)
    5c64:	f466                	sd	s9,40(sp)
    5c66:	f06a                	sd	s10,32(sp)
    5c68:	ec6e                	sd	s11,24(sp)
    5c6a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
    5c6c:	0005c903          	lbu	s2,0(a1)
    5c70:	18090f63          	beqz	s2,5e0e <vprintf+0x1c0>
    5c74:	8aaa                	mv	s5,a0
    5c76:	8b32                	mv	s6,a2
    5c78:	00158493          	addi	s1,a1,1
  state = 0;
    5c7c:	4981                	li	s3,0
      if (c == '%') {
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if (state == '%') {
    5c7e:	02500a13          	li	s4,37
    5c82:	4c55                	li	s8,21
    5c84:	00002c97          	auipc	s9,0x2
    5c88:	78cc8c93          	addi	s9,s9,1932 # 8410 <malloc+0x24fe>
      } else if (c == 'p') {
        printptr(fd, va_arg(ap, uint64));
      } else if (c == 's') {
        s = va_arg(ap, char *);
        if (s == 0) s = "(null)";
        while (*s != 0) {
    5c8c:	02800d93          	li	s11,40
  putc(fd, 'x');
    5c90:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5c92:	00002b97          	auipc	s7,0x2
    5c96:	7d6b8b93          	addi	s7,s7,2006 # 8468 <digits>
    5c9a:	a839                	j	5cb8 <vprintf+0x6a>
        putc(fd, c);
    5c9c:	85ca                	mv	a1,s2
    5c9e:	8556                	mv	a0,s5
    5ca0:	00000097          	auipc	ra,0x0
    5ca4:	ee0080e7          	jalr	-288(ra) # 5b80 <putc>
    5ca8:	a019                	j	5cae <vprintf+0x60>
    } else if (state == '%') {
    5caa:	01498d63          	beq	s3,s4,5cc4 <vprintf+0x76>
  for (i = 0; fmt[i]; i++) {
    5cae:	0485                	addi	s1,s1,1
    5cb0:	fff4c903          	lbu	s2,-1(s1)
    5cb4:	14090d63          	beqz	s2,5e0e <vprintf+0x1c0>
    if (state == 0) {
    5cb8:	fe0999e3          	bnez	s3,5caa <vprintf+0x5c>
      if (c == '%') {
    5cbc:	ff4910e3          	bne	s2,s4,5c9c <vprintf+0x4e>
        state = '%';
    5cc0:	89d2                	mv	s3,s4
    5cc2:	b7f5                	j	5cae <vprintf+0x60>
      if (c == 'd') {
    5cc4:	11490c63          	beq	s2,s4,5ddc <vprintf+0x18e>
    5cc8:	f9d9079b          	addiw	a5,s2,-99
    5ccc:	0ff7f793          	zext.b	a5,a5
    5cd0:	10fc6e63          	bltu	s8,a5,5dec <vprintf+0x19e>
    5cd4:	f9d9079b          	addiw	a5,s2,-99
    5cd8:	0ff7f713          	zext.b	a4,a5
    5cdc:	10ec6863          	bltu	s8,a4,5dec <vprintf+0x19e>
    5ce0:	00271793          	slli	a5,a4,0x2
    5ce4:	97e6                	add	a5,a5,s9
    5ce6:	439c                	lw	a5,0(a5)
    5ce8:	97e6                	add	a5,a5,s9
    5cea:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5cec:	008b0913          	addi	s2,s6,8
    5cf0:	4685                	li	a3,1
    5cf2:	4629                	li	a2,10
    5cf4:	000b2583          	lw	a1,0(s6)
    5cf8:	8556                	mv	a0,s5
    5cfa:	00000097          	auipc	ra,0x0
    5cfe:	ea8080e7          	jalr	-344(ra) # 5ba2 <printint>
    5d02:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5d04:	4981                	li	s3,0
    5d06:	b765                	j	5cae <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5d08:	008b0913          	addi	s2,s6,8
    5d0c:	4681                	li	a3,0
    5d0e:	4629                	li	a2,10
    5d10:	000b2583          	lw	a1,0(s6)
    5d14:	8556                	mv	a0,s5
    5d16:	00000097          	auipc	ra,0x0
    5d1a:	e8c080e7          	jalr	-372(ra) # 5ba2 <printint>
    5d1e:	8b4a                	mv	s6,s2
      state = 0;
    5d20:	4981                	li	s3,0
    5d22:	b771                	j	5cae <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5d24:	008b0913          	addi	s2,s6,8
    5d28:	4681                	li	a3,0
    5d2a:	866a                	mv	a2,s10
    5d2c:	000b2583          	lw	a1,0(s6)
    5d30:	8556                	mv	a0,s5
    5d32:	00000097          	auipc	ra,0x0
    5d36:	e70080e7          	jalr	-400(ra) # 5ba2 <printint>
    5d3a:	8b4a                	mv	s6,s2
      state = 0;
    5d3c:	4981                	li	s3,0
    5d3e:	bf85                	j	5cae <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5d40:	008b0793          	addi	a5,s6,8
    5d44:	f8f43423          	sd	a5,-120(s0)
    5d48:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5d4c:	03000593          	li	a1,48
    5d50:	8556                	mv	a0,s5
    5d52:	00000097          	auipc	ra,0x0
    5d56:	e2e080e7          	jalr	-466(ra) # 5b80 <putc>
  putc(fd, 'x');
    5d5a:	07800593          	li	a1,120
    5d5e:	8556                	mv	a0,s5
    5d60:	00000097          	auipc	ra,0x0
    5d64:	e20080e7          	jalr	-480(ra) # 5b80 <putc>
    5d68:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5d6a:	03c9d793          	srli	a5,s3,0x3c
    5d6e:	97de                	add	a5,a5,s7
    5d70:	0007c583          	lbu	a1,0(a5)
    5d74:	8556                	mv	a0,s5
    5d76:	00000097          	auipc	ra,0x0
    5d7a:	e0a080e7          	jalr	-502(ra) # 5b80 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5d7e:	0992                	slli	s3,s3,0x4
    5d80:	397d                	addiw	s2,s2,-1
    5d82:	fe0914e3          	bnez	s2,5d6a <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
    5d86:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5d8a:	4981                	li	s3,0
    5d8c:	b70d                	j	5cae <vprintf+0x60>
        s = va_arg(ap, char *);
    5d8e:	008b0913          	addi	s2,s6,8
    5d92:	000b3983          	ld	s3,0(s6)
        if (s == 0) s = "(null)";
    5d96:	02098163          	beqz	s3,5db8 <vprintf+0x16a>
        while (*s != 0) {
    5d9a:	0009c583          	lbu	a1,0(s3)
    5d9e:	c5ad                	beqz	a1,5e08 <vprintf+0x1ba>
          putc(fd, *s);
    5da0:	8556                	mv	a0,s5
    5da2:	00000097          	auipc	ra,0x0
    5da6:	dde080e7          	jalr	-546(ra) # 5b80 <putc>
          s++;
    5daa:	0985                	addi	s3,s3,1
        while (*s != 0) {
    5dac:	0009c583          	lbu	a1,0(s3)
    5db0:	f9e5                	bnez	a1,5da0 <vprintf+0x152>
        s = va_arg(ap, char *);
    5db2:	8b4a                	mv	s6,s2
      state = 0;
    5db4:	4981                	li	s3,0
    5db6:	bde5                	j	5cae <vprintf+0x60>
        if (s == 0) s = "(null)";
    5db8:	00002997          	auipc	s3,0x2
    5dbc:	65098993          	addi	s3,s3,1616 # 8408 <malloc+0x24f6>
        while (*s != 0) {
    5dc0:	85ee                	mv	a1,s11
    5dc2:	bff9                	j	5da0 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
    5dc4:	008b0913          	addi	s2,s6,8
    5dc8:	000b4583          	lbu	a1,0(s6)
    5dcc:	8556                	mv	a0,s5
    5dce:	00000097          	auipc	ra,0x0
    5dd2:	db2080e7          	jalr	-590(ra) # 5b80 <putc>
    5dd6:	8b4a                	mv	s6,s2
      state = 0;
    5dd8:	4981                	li	s3,0
    5dda:	bdd1                	j	5cae <vprintf+0x60>
        putc(fd, c);
    5ddc:	85d2                	mv	a1,s4
    5dde:	8556                	mv	a0,s5
    5de0:	00000097          	auipc	ra,0x0
    5de4:	da0080e7          	jalr	-608(ra) # 5b80 <putc>
      state = 0;
    5de8:	4981                	li	s3,0
    5dea:	b5d1                	j	5cae <vprintf+0x60>
        putc(fd, '%');
    5dec:	85d2                	mv	a1,s4
    5dee:	8556                	mv	a0,s5
    5df0:	00000097          	auipc	ra,0x0
    5df4:	d90080e7          	jalr	-624(ra) # 5b80 <putc>
        putc(fd, c);
    5df8:	85ca                	mv	a1,s2
    5dfa:	8556                	mv	a0,s5
    5dfc:	00000097          	auipc	ra,0x0
    5e00:	d84080e7          	jalr	-636(ra) # 5b80 <putc>
      state = 0;
    5e04:	4981                	li	s3,0
    5e06:	b565                	j	5cae <vprintf+0x60>
        s = va_arg(ap, char *);
    5e08:	8b4a                	mv	s6,s2
      state = 0;
    5e0a:	4981                	li	s3,0
    5e0c:	b54d                	j	5cae <vprintf+0x60>
    }
  }
}
    5e0e:	70e6                	ld	ra,120(sp)
    5e10:	7446                	ld	s0,112(sp)
    5e12:	74a6                	ld	s1,104(sp)
    5e14:	7906                	ld	s2,96(sp)
    5e16:	69e6                	ld	s3,88(sp)
    5e18:	6a46                	ld	s4,80(sp)
    5e1a:	6aa6                	ld	s5,72(sp)
    5e1c:	6b06                	ld	s6,64(sp)
    5e1e:	7be2                	ld	s7,56(sp)
    5e20:	7c42                	ld	s8,48(sp)
    5e22:	7ca2                	ld	s9,40(sp)
    5e24:	7d02                	ld	s10,32(sp)
    5e26:	6de2                	ld	s11,24(sp)
    5e28:	6109                	addi	sp,sp,128
    5e2a:	8082                	ret

0000000000005e2c <fprintf>:

void fprintf(int fd, const char *fmt, ...) {
    5e2c:	715d                	addi	sp,sp,-80
    5e2e:	ec06                	sd	ra,24(sp)
    5e30:	e822                	sd	s0,16(sp)
    5e32:	1000                	addi	s0,sp,32
    5e34:	e010                	sd	a2,0(s0)
    5e36:	e414                	sd	a3,8(s0)
    5e38:	e818                	sd	a4,16(s0)
    5e3a:	ec1c                	sd	a5,24(s0)
    5e3c:	03043023          	sd	a6,32(s0)
    5e40:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5e44:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5e48:	8622                	mv	a2,s0
    5e4a:	00000097          	auipc	ra,0x0
    5e4e:	e04080e7          	jalr	-508(ra) # 5c4e <vprintf>
}
    5e52:	60e2                	ld	ra,24(sp)
    5e54:	6442                	ld	s0,16(sp)
    5e56:	6161                	addi	sp,sp,80
    5e58:	8082                	ret

0000000000005e5a <printf>:

void printf(const char *fmt, ...) {
    5e5a:	711d                	addi	sp,sp,-96
    5e5c:	ec06                	sd	ra,24(sp)
    5e5e:	e822                	sd	s0,16(sp)
    5e60:	1000                	addi	s0,sp,32
    5e62:	e40c                	sd	a1,8(s0)
    5e64:	e810                	sd	a2,16(s0)
    5e66:	ec14                	sd	a3,24(s0)
    5e68:	f018                	sd	a4,32(s0)
    5e6a:	f41c                	sd	a5,40(s0)
    5e6c:	03043823          	sd	a6,48(s0)
    5e70:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5e74:	00840613          	addi	a2,s0,8
    5e78:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5e7c:	85aa                	mv	a1,a0
    5e7e:	4505                	li	a0,1
    5e80:	00000097          	auipc	ra,0x0
    5e84:	dce080e7          	jalr	-562(ra) # 5c4e <vprintf>
}
    5e88:	60e2                	ld	ra,24(sp)
    5e8a:	6442                	ld	s0,16(sp)
    5e8c:	6125                	addi	sp,sp,96
    5e8e:	8082                	ret

0000000000005e90 <free>:
typedef union header Header;

static Header base;
static Header *freep;

void free(void *ap) {
    5e90:	1141                	addi	sp,sp,-16
    5e92:	e422                	sd	s0,8(sp)
    5e94:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
    5e96:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5e9a:	00003797          	auipc	a5,0x3
    5e9e:	5a67b783          	ld	a5,1446(a5) # 9440 <freep>
    5ea2:	a02d                	j	5ecc <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
    5ea4:	4618                	lw	a4,8(a2)
    5ea6:	9f2d                	addw	a4,a4,a1
    5ea8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5eac:	6398                	ld	a4,0(a5)
    5eae:	6310                	ld	a2,0(a4)
    5eb0:	a83d                	j	5eee <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
    5eb2:	ff852703          	lw	a4,-8(a0)
    5eb6:	9f31                	addw	a4,a4,a2
    5eb8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5eba:	ff053683          	ld	a3,-16(a0)
    5ebe:	a091                	j	5f02 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
    5ec0:	6398                	ld	a4,0(a5)
    5ec2:	00e7e463          	bltu	a5,a4,5eca <free+0x3a>
    5ec6:	00e6ea63          	bltu	a3,a4,5eda <free+0x4a>
void free(void *ap) {
    5eca:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5ecc:	fed7fae3          	bgeu	a5,a3,5ec0 <free+0x30>
    5ed0:	6398                	ld	a4,0(a5)
    5ed2:	00e6e463          	bltu	a3,a4,5eda <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
    5ed6:	fee7eae3          	bltu	a5,a4,5eca <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
    5eda:	ff852583          	lw	a1,-8(a0)
    5ede:	6390                	ld	a2,0(a5)
    5ee0:	02059813          	slli	a6,a1,0x20
    5ee4:	01c85713          	srli	a4,a6,0x1c
    5ee8:	9736                	add	a4,a4,a3
    5eea:	fae60de3          	beq	a2,a4,5ea4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    5eee:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
    5ef2:	4790                	lw	a2,8(a5)
    5ef4:	02061593          	slli	a1,a2,0x20
    5ef8:	01c5d713          	srli	a4,a1,0x1c
    5efc:	973e                	add	a4,a4,a5
    5efe:	fae68ae3          	beq	a3,a4,5eb2 <free+0x22>
    p->s.ptr = bp->s.ptr;
    5f02:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5f04:	00003717          	auipc	a4,0x3
    5f08:	52f73e23          	sd	a5,1340(a4) # 9440 <freep>
}
    5f0c:	6422                	ld	s0,8(sp)
    5f0e:	0141                	addi	sp,sp,16
    5f10:	8082                	ret

0000000000005f12 <malloc>:
  hp->s.size = nu;
  free((void *)(hp + 1));
  return freep;
}

void *malloc(uint nbytes) {
    5f12:	7139                	addi	sp,sp,-64
    5f14:	fc06                	sd	ra,56(sp)
    5f16:	f822                	sd	s0,48(sp)
    5f18:	f426                	sd	s1,40(sp)
    5f1a:	f04a                	sd	s2,32(sp)
    5f1c:	ec4e                	sd	s3,24(sp)
    5f1e:	e852                	sd	s4,16(sp)
    5f20:	e456                	sd	s5,8(sp)
    5f22:	e05a                	sd	s6,0(sp)
    5f24:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    5f26:	02051493          	slli	s1,a0,0x20
    5f2a:	9081                	srli	s1,s1,0x20
    5f2c:	04bd                	addi	s1,s1,15
    5f2e:	8091                	srli	s1,s1,0x4
    5f30:	0014899b          	addiw	s3,s1,1
    5f34:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
    5f36:	00003517          	auipc	a0,0x3
    5f3a:	50a53503          	ld	a0,1290(a0) # 9440 <freep>
    5f3e:	c515                	beqz	a0,5f6a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    5f40:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    5f42:	4798                	lw	a4,8(a5)
    5f44:	02977f63          	bgeu	a4,s1,5f82 <malloc+0x70>
    5f48:	8a4e                	mv	s4,s3
    5f4a:	0009871b          	sext.w	a4,s3
    5f4e:	6685                	lui	a3,0x1
    5f50:	00d77363          	bgeu	a4,a3,5f56 <malloc+0x44>
    5f54:	6a05                	lui	s4,0x1
    5f56:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5f5a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
    5f5e:	00003917          	auipc	s2,0x3
    5f62:	4e290913          	addi	s2,s2,1250 # 9440 <freep>
  if (p == (char *)-1) return 0;
    5f66:	5afd                	li	s5,-1
    5f68:	a895                	j	5fdc <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    5f6a:	0000a797          	auipc	a5,0xa
    5f6e:	cfe78793          	addi	a5,a5,-770 # fc68 <base>
    5f72:	00003717          	auipc	a4,0x3
    5f76:	4cf73723          	sd	a5,1230(a4) # 9440 <freep>
    5f7a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5f7c:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
    5f80:	b7e1                	j	5f48 <malloc+0x36>
      if (p->s.size == nunits)
    5f82:	02e48c63          	beq	s1,a4,5fba <malloc+0xa8>
        p->s.size -= nunits;
    5f86:	4137073b          	subw	a4,a4,s3
    5f8a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5f8c:	02071693          	slli	a3,a4,0x20
    5f90:	01c6d713          	srli	a4,a3,0x1c
    5f94:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5f96:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5f9a:	00003717          	auipc	a4,0x3
    5f9e:	4aa73323          	sd	a0,1190(a4) # 9440 <freep>
      return (void *)(p + 1);
    5fa2:	01078513          	addi	a0,a5,16
      if ((p = morecore(nunits)) == 0) return 0;
  }
}
    5fa6:	70e2                	ld	ra,56(sp)
    5fa8:	7442                	ld	s0,48(sp)
    5faa:	74a2                	ld	s1,40(sp)
    5fac:	7902                	ld	s2,32(sp)
    5fae:	69e2                	ld	s3,24(sp)
    5fb0:	6a42                	ld	s4,16(sp)
    5fb2:	6aa2                	ld	s5,8(sp)
    5fb4:	6b02                	ld	s6,0(sp)
    5fb6:	6121                	addi	sp,sp,64
    5fb8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5fba:	6398                	ld	a4,0(a5)
    5fbc:	e118                	sd	a4,0(a0)
    5fbe:	bff1                	j	5f9a <malloc+0x88>
  hp->s.size = nu;
    5fc0:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
    5fc4:	0541                	addi	a0,a0,16
    5fc6:	00000097          	auipc	ra,0x0
    5fca:	eca080e7          	jalr	-310(ra) # 5e90 <free>
  return freep;
    5fce:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0) return 0;
    5fd2:	d971                	beqz	a0,5fa6 <malloc+0x94>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    5fd4:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    5fd6:	4798                	lw	a4,8(a5)
    5fd8:	fa9775e3          	bgeu	a4,s1,5f82 <malloc+0x70>
    if (p == freep)
    5fdc:	00093703          	ld	a4,0(s2)
    5fe0:	853e                	mv	a0,a5
    5fe2:	fef719e3          	bne	a4,a5,5fd4 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    5fe6:	8552                	mv	a0,s4
    5fe8:	00000097          	auipc	ra,0x0
    5fec:	b80080e7          	jalr	-1152(ra) # 5b68 <sbrk>
  if (p == (char *)-1) return 0;
    5ff0:	fd5518e3          	bne	a0,s5,5fc0 <malloc+0xae>
      if ((p = morecore(nunits)) == 0) return 0;
    5ff4:	4501                	li	a0,0
    5ff6:	bf45                	j	5fa6 <malloc+0x94>
