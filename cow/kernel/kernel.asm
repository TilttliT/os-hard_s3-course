
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	87013103          	ld	sp,-1936(sp) # 80008870 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	263050ef          	jal	ra,80005a78 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa) {
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	000aa797          	auipc	a5,0xaa
    80000034:	d2078793          	addi	a5,a5,-736 # 800a9d50 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run *)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	87090913          	addi	s2,s2,-1936 # 800088c0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	40a080e7          	jalr	1034(ra) # 80006464 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	4aa080e7          	jalr	1194(ra) # 80006518 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	ea2080e7          	jalr	-350(ra) # 80005f2c <panic>

0000000080000092 <freerange>:
void freerange(void *pa_start, void *pa_end) {
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE) kfree(p);
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    800000b8:	7a7d                	lui	s4,0xfffff
    800000ba:	6985                	lui	s3,0x1
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
void kinit() {
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00008517          	auipc	a0,0x8
    800000f2:	7d250513          	addi	a0,a0,2002 # 800088c0 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	2de080e7          	jalr	734(ra) # 800063d4 <initlock>
  freerange(end, (void *)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	000aa517          	auipc	a0,0xaa
    80000106:	c4e50513          	addi	a0,a0,-946 # 800a9d50 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void) {
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00008497          	auipc	s1,0x8
    80000128:	79c48493          	addi	s1,s1,1948 # 800088c0 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	336080e7          	jalr	822(ra) # 80006464 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if (r) kmem.freelist = r->next;
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00008517          	auipc	a0,0x8
    80000140:	78450513          	addi	a0,a0,1924 # 800088c0 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	3d2080e7          	jalr	978(ra) # 80006518 <release>

  if (r) memset((char *)r, 5, PGSIZE);  // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void *)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00008517          	auipc	a0,0x8
    8000016c:	75850513          	addi	a0,a0,1880 # 800088c0 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	3a8080e7          	jalr	936(ra) # 80006518 <release>
  if (r) memset((char *)r, 5, PGSIZE);  // fill with junk
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void *memset(void *dst, int c, uint n) {
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int memcmp(const void *v1, const void *v2, uint n) {
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if (*s1 != *s2) return *s1 - *s2;
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
    if (*s1 != *s2) return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void *memmove(void *dst, const void *src, uint n) {
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0) return dst;
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while (n-- > 0) *--d = *--s;
  } else
    while (n-- > 0) *d++ = *s++;
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
void *memmove(void *dst, const void *src, uint n) {
    800001ea:	872a                	mv	a4,a0
    while (n-- > 0) *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ff552b1>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if (s < d && s + n > d) {
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while (n-- > 0) *--d = *--s;
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n) {
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int strncmp(const char *p, const char *q, uint n) {
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q) n--, p++, q++;
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if (n == 0) return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret
  if (n == 0) return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char *strncpy(char *s, const char *t, int n) {
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	872a                	mv	a4,a0
    8000028e:	8832                	mv	a6,a2
    80000290:	367d                	addiw	a2,a2,-1
    80000292:	01005963          	blez	a6,800002a4 <strncpy+0x1e>
    80000296:	0705                	addi	a4,a4,1
    80000298:	0005c783          	lbu	a5,0(a1)
    8000029c:	fef70fa3          	sb	a5,-1(a4)
    800002a0:	0585                	addi	a1,a1,1
    800002a2:	f7f5                	bnez	a5,8000028e <strncpy+0x8>
    ;
  while (n-- > 0) *s++ = 0;
    800002a4:	86ba                	mv	a3,a4
    800002a6:	00c05c63          	blez	a2,800002be <strncpy+0x38>
    800002aa:	0685                	addi	a3,a3,1
    800002ac:	fe068fa3          	sb	zero,-1(a3)
    800002b0:	40d707bb          	subw	a5,a4,a3
    800002b4:	37fd                	addiw	a5,a5,-1
    800002b6:	010787bb          	addw	a5,a5,a6
    800002ba:	fef048e3          	bgtz	a5,800002aa <strncpy+0x24>
  return os;
}
    800002be:	6422                	ld	s0,8(sp)
    800002c0:	0141                	addi	sp,sp,16
    800002c2:	8082                	ret

00000000800002c4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n) {
    800002c4:	1141                	addi	sp,sp,-16
    800002c6:	e422                	sd	s0,8(sp)
    800002c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0) return os;
    800002ca:	02c05363          	blez	a2,800002f0 <safestrcpy+0x2c>
    800002ce:	fff6069b          	addiw	a3,a2,-1
    800002d2:	1682                	slli	a3,a3,0x20
    800002d4:	9281                	srli	a3,a3,0x20
    800002d6:	96ae                	add	a3,a3,a1
    800002d8:	87aa                	mv	a5,a0
  while (--n > 0 && (*s++ = *t++) != 0)
    800002da:	00d58963          	beq	a1,a3,800002ec <safestrcpy+0x28>
    800002de:	0585                	addi	a1,a1,1
    800002e0:	0785                	addi	a5,a5,1
    800002e2:	fff5c703          	lbu	a4,-1(a1)
    800002e6:	fee78fa3          	sb	a4,-1(a5)
    800002ea:	fb65                	bnez	a4,800002da <safestrcpy+0x16>
    ;
  *s = 0;
    800002ec:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f0:	6422                	ld	s0,8(sp)
    800002f2:	0141                	addi	sp,sp,16
    800002f4:	8082                	ret

00000000800002f6 <strlen>:

int strlen(const char *s) {
    800002f6:	1141                	addi	sp,sp,-16
    800002f8:	e422                	sd	s0,8(sp)
    800002fa:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    800002fc:	00054783          	lbu	a5,0(a0)
    80000300:	cf91                	beqz	a5,8000031c <strlen+0x26>
    80000302:	0505                	addi	a0,a0,1
    80000304:	87aa                	mv	a5,a0
    80000306:	4685                	li	a3,1
    80000308:	9e89                	subw	a3,a3,a0
    8000030a:	00f6853b          	addw	a0,a3,a5
    8000030e:	0785                	addi	a5,a5,1
    80000310:	fff7c703          	lbu	a4,-1(a5)
    80000314:	fb7d                	bnez	a4,8000030a <strlen+0x14>
    ;
  return n;
}
    80000316:	6422                	ld	s0,8(sp)
    80000318:	0141                	addi	sp,sp,16
    8000031a:	8082                	ret
  for (n = 0; s[n]; n++)
    8000031c:	4501                	li	a0,0
    8000031e:	bfe5                	j	80000316 <strlen+0x20>

0000000080000320 <main>:
#include "defs.h"

volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void main() {
    80000320:	1141                	addi	sp,sp,-16
    80000322:	e406                	sd	ra,8(sp)
    80000324:	e022                	sd	s0,0(sp)
    80000326:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80000328:	00001097          	auipc	ra,0x1
    8000032c:	df4080e7          	jalr	-524(ra) # 8000111c <cpuid>
    virtio_disk_init();  // emulated hard disk
    userinit();          // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while (started == 0)
    80000330:	00008717          	auipc	a4,0x8
    80000334:	56070713          	addi	a4,a4,1376 # 80008890 <started>
  if (cpuid() == 0) {
    80000338:	c139                	beqz	a0,8000037e <main+0x5e>
    while (started == 0)
    8000033a:	431c                	lw	a5,0(a4)
    8000033c:	2781                	sext.w	a5,a5
    8000033e:	dff5                	beqz	a5,8000033a <main+0x1a>
      ;
    __sync_synchronize();
    80000340:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000344:	00001097          	auipc	ra,0x1
    80000348:	dd8080e7          	jalr	-552(ra) # 8000111c <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	c20080e7          	jalr	-992(ra) # 80005f76 <printf>
    kvminithart();   // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();  // install kernel trap vector
    80000366:	00002097          	auipc	ra,0x2
    8000036a:	a86080e7          	jalr	-1402(ra) # 80001dec <trapinithart>
    plicinithart();  // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	0c2080e7          	jalr	194(ra) # 80005430 <plicinithart>
  }

  scheduler();
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	2c8080e7          	jalr	712(ra) # 8000163e <scheduler>
    consoleinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	abe080e7          	jalr	-1346(ra) # 80005e3c <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	dd0080e7          	jalr	-560(ra) # 80006156 <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	be0080e7          	jalr	-1056(ra) # 80005f76 <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	bd0080e7          	jalr	-1072(ra) # 80005f76 <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	bc0080e7          	jalr	-1088(ra) # 80005f76 <printf>
    kinit();             // physical page allocator
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	d20080e7          	jalr	-736(ra) # 800000de <kinit>
    kvminit();           // create kernel page table
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	40a080e7          	jalr	1034(ra) # 800007d0 <kvminit>
    kvminithart();       // turn on paging
    800003ce:	00000097          	auipc	ra,0x0
    800003d2:	068080e7          	jalr	104(ra) # 80000436 <kvminithart>
    procinit();          // process table
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	c92080e7          	jalr	-878(ra) # 80001068 <procinit>
    trapinit();          // trap vectors
    800003de:	00002097          	auipc	ra,0x2
    800003e2:	9e6080e7          	jalr	-1562(ra) # 80001dc4 <trapinit>
    trapinithart();      // install kernel trap vector
    800003e6:	00002097          	auipc	ra,0x2
    800003ea:	a06080e7          	jalr	-1530(ra) # 80001dec <trapinithart>
    plicinit();          // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	02c080e7          	jalr	44(ra) # 8000541a <plicinit>
    plicinithart();      // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	03a080e7          	jalr	58(ra) # 80005430 <plicinithart>
    binit();             // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	1bc080e7          	jalr	444(ra) # 800025ba <binit>
    iinit();             // inode table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	85c080e7          	jalr	-1956(ra) # 80002c62 <iinit>
    fileinit();          // file table
    8000040e:	00004097          	auipc	ra,0x4
    80000412:	802080e7          	jalr	-2046(ra) # 80003c10 <fileinit>
    virtio_disk_init();  // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	122080e7          	jalr	290(ra) # 80005538 <virtio_disk_init>
    userinit();          // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	002080e7          	jalr	2(ra) # 80001420 <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00008717          	auipc	a4,0x8
    80000430:	46f72223          	sw	a5,1124(a4) # 80008890 <started>
    80000434:	b789                	j	80000376 <main+0x56>

0000000080000436 <kvminithart>:
// Initialize the one kernel_pagetable
void kvminit(void) { kernel_pagetable = kvmmake(); }

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart() {
    80000436:	1141                	addi	sp,sp,-16
    80000438:	e406                	sd	ra,8(sp)
    8000043a:	e022                	sd	s0,0(sp)
    8000043c:	0800                	addi	s0,sp,16
  memset(ref_count, 0, PHYSTOP >> PGSHIFT);
    8000043e:	00088637          	lui	a2,0x88
    80000442:	4581                	li	a1,0
    80000444:	00008517          	auipc	a0,0x8
    80000448:	4b450513          	addi	a0,a0,1204 # 800088f8 <ref_count>
    8000044c:	00000097          	auipc	ra,0x0
    80000450:	d2e080e7          	jalr	-722(ra) # 8000017a <memset>
  initlock(&ref_count_lock, "ref_count");
    80000454:	00008597          	auipc	a1,0x8
    80000458:	bfc58593          	addi	a1,a1,-1028 # 80008050 <etext+0x50>
    8000045c:	00008517          	auipc	a0,0x8
    80000460:	48450513          	addi	a0,a0,1156 # 800088e0 <ref_count_lock>
    80000464:	00006097          	auipc	ra,0x6
    80000468:	f70080e7          	jalr	-144(ra) # 800063d4 <initlock>
}

// flush the TLB.
static inline void sfence_vma() {
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000046c:	12000073          	sfence.vma

  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000470:	00008797          	auipc	a5,0x8
    80000474:	4287b783          	ld	a5,1064(a5) # 80008898 <kernel_pagetable>
    80000478:	83b1                	srli	a5,a5,0xc
    8000047a:	577d                	li	a4,-1
    8000047c:	177e                	slli	a4,a4,0x3f
    8000047e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80000480:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000484:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000488:	60a2                	ld	ra,8(sp)
    8000048a:	6402                	ld	s0,0(sp)
    8000048c:	0141                	addi	sp,sp,16
    8000048e:	8082                	ret

0000000080000490 <walk>:
//   39..63 -- must be zero.
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    80000490:	7139                	addi	sp,sp,-64
    80000492:	fc06                	sd	ra,56(sp)
    80000494:	f822                	sd	s0,48(sp)
    80000496:	f426                	sd	s1,40(sp)
    80000498:	f04a                	sd	s2,32(sp)
    8000049a:	ec4e                	sd	s3,24(sp)
    8000049c:	e852                	sd	s4,16(sp)
    8000049e:	e456                	sd	s5,8(sp)
    800004a0:	e05a                	sd	s6,0(sp)
    800004a2:	0080                	addi	s0,sp,64
    800004a4:	84aa                	mv	s1,a0
    800004a6:	89ae                	mv	s3,a1
    800004a8:	8ab2                	mv	s5,a2
  if (va >= MAXVA) panic("walk");
    800004aa:	57fd                	li	a5,-1
    800004ac:	83e9                	srli	a5,a5,0x1a
    800004ae:	4a79                	li	s4,30

  for (int level = 2; level > 0; level--) {
    800004b0:	4b31                	li	s6,12
  if (va >= MAXVA) panic("walk");
    800004b2:	04b7f263          	bgeu	a5,a1,800004f6 <walk+0x66>
    800004b6:	00008517          	auipc	a0,0x8
    800004ba:	baa50513          	addi	a0,a0,-1110 # 80008060 <etext+0x60>
    800004be:	00006097          	auipc	ra,0x6
    800004c2:	a6e080e7          	jalr	-1426(ra) # 80005f2c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0) return 0;
    800004c6:	060a8663          	beqz	s5,80000532 <walk+0xa2>
    800004ca:	00000097          	auipc	ra,0x0
    800004ce:	c50080e7          	jalr	-944(ra) # 8000011a <kalloc>
    800004d2:	84aa                	mv	s1,a0
    800004d4:	c529                	beqz	a0,8000051e <walk+0x8e>
      memset(pagetable, 0, PGSIZE);
    800004d6:	6605                	lui	a2,0x1
    800004d8:	4581                	li	a1,0
    800004da:	00000097          	auipc	ra,0x0
    800004de:	ca0080e7          	jalr	-864(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004e2:	00c4d793          	srli	a5,s1,0xc
    800004e6:	07aa                	slli	a5,a5,0xa
    800004e8:	0017e793          	ori	a5,a5,1
    800004ec:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    800004f0:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ff552a7>
    800004f2:	036a0063          	beq	s4,s6,80000512 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004f6:	0149d933          	srl	s2,s3,s4
    800004fa:	1ff97913          	andi	s2,s2,511
    800004fe:	090e                	slli	s2,s2,0x3
    80000500:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    80000502:	00093483          	ld	s1,0(s2)
    80000506:	0014f793          	andi	a5,s1,1
    8000050a:	dfd5                	beqz	a5,800004c6 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000050c:	80a9                	srli	s1,s1,0xa
    8000050e:	04b2                	slli	s1,s1,0xc
    80000510:	b7c5                	j	800004f0 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000512:	00c9d513          	srli	a0,s3,0xc
    80000516:	1ff57513          	andi	a0,a0,511
    8000051a:	050e                	slli	a0,a0,0x3
    8000051c:	9526                	add	a0,a0,s1
}
    8000051e:	70e2                	ld	ra,56(sp)
    80000520:	7442                	ld	s0,48(sp)
    80000522:	74a2                	ld	s1,40(sp)
    80000524:	7902                	ld	s2,32(sp)
    80000526:	69e2                	ld	s3,24(sp)
    80000528:	6a42                	ld	s4,16(sp)
    8000052a:	6aa2                	ld	s5,8(sp)
    8000052c:	6b02                	ld	s6,0(sp)
    8000052e:	6121                	addi	sp,sp,64
    80000530:	8082                	ret
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0) return 0;
    80000532:	4501                	li	a0,0
    80000534:	b7ed                	j	8000051e <walk+0x8e>

0000000080000536 <walkaddr>:
// Can only be used to look up user pages.
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA) return 0;
    80000536:	57fd                	li	a5,-1
    80000538:	83e9                	srli	a5,a5,0x1a
    8000053a:	00b7f463          	bgeu	a5,a1,80000542 <walkaddr+0xc>
    8000053e:	4501                	li	a0,0
  if (pte == 0) return 0;
  if ((*pte & PTE_V) == 0) return 0;
  if ((*pte & PTE_U) == 0) return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000540:	8082                	ret
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    80000542:	1141                	addi	sp,sp,-16
    80000544:	e406                	sd	ra,8(sp)
    80000546:	e022                	sd	s0,0(sp)
    80000548:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000054a:	4601                	li	a2,0
    8000054c:	00000097          	auipc	ra,0x0
    80000550:	f44080e7          	jalr	-188(ra) # 80000490 <walk>
  if (pte == 0) return 0;
    80000554:	c105                	beqz	a0,80000574 <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0) return 0;
    80000556:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0) return 0;
    80000558:	0117f693          	andi	a3,a5,17
    8000055c:	4745                	li	a4,17
    8000055e:	4501                	li	a0,0
    80000560:	00e68663          	beq	a3,a4,8000056c <walkaddr+0x36>
}
    80000564:	60a2                	ld	ra,8(sp)
    80000566:	6402                	ld	s0,0(sp)
    80000568:	0141                	addi	sp,sp,16
    8000056a:	8082                	ret
  pa = PTE2PA(*pte);
    8000056c:	83a9                	srli	a5,a5,0xa
    8000056e:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000572:	bfcd                	j	80000564 <walkaddr+0x2e>
  if (pte == 0) return 0;
    80000574:	4501                	li	a0,0
    80000576:	b7fd                	j	80000564 <walkaddr+0x2e>

0000000080000578 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa,
             int perm) {
    80000578:	711d                	addi	sp,sp,-96
    8000057a:	ec86                	sd	ra,88(sp)
    8000057c:	e8a2                	sd	s0,80(sp)
    8000057e:	e4a6                	sd	s1,72(sp)
    80000580:	e0ca                	sd	s2,64(sp)
    80000582:	fc4e                	sd	s3,56(sp)
    80000584:	f852                	sd	s4,48(sp)
    80000586:	f456                	sd	s5,40(sp)
    80000588:	f05a                	sd	s6,32(sp)
    8000058a:	ec5e                	sd	s7,24(sp)
    8000058c:	e862                	sd	s8,16(sp)
    8000058e:	e466                	sd	s9,8(sp)
    80000590:	1080                	addi	s0,sp,96
  uint64 a, last;
  pte_t *pte;

  if (size == 0) panic("mappages: size");
    80000592:	c241                	beqz	a2,80000612 <mappages+0x9a>
    80000594:	8b2a                	mv	s6,a0
    80000596:	8bba                	mv	s7,a4

  a = PGROUNDDOWN(va);
    80000598:	777d                	lui	a4,0xfffff
    8000059a:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000059e:	fff58a13          	addi	s4,a1,-1
    800005a2:	9a32                	add	s4,s4,a2
    800005a4:	00ea7a33          	and	s4,s4,a4
  a = PGROUNDDOWN(va);
    800005a8:	893e                	mv	s2,a5
    800005aa:	40f68ab3          	sub	s5,a3,a5
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    if (*pte & PTE_V) panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    acquire(&ref_count_lock);
    800005ae:	00008997          	auipc	s3,0x8
    800005b2:	33298993          	addi	s3,s3,818 # 800088e0 <ref_count_lock>
    ++ref_count[((uint64)pa) >> PGSHIFT];
    800005b6:	00008c17          	auipc	s8,0x8
    800005ba:	342c0c13          	addi	s8,s8,834 # 800088f8 <ref_count>
    release(&ref_count_lock);
    if (a == last) break;
    a += PGSIZE;
    800005be:	6c85                	lui	s9,0x1
    800005c0:	012a84b3          	add	s1,s5,s2
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    800005c4:	4605                	li	a2,1
    800005c6:	85ca                	mv	a1,s2
    800005c8:	855a                	mv	a0,s6
    800005ca:	00000097          	auipc	ra,0x0
    800005ce:	ec6080e7          	jalr	-314(ra) # 80000490 <walk>
    800005d2:	c125                	beqz	a0,80000632 <mappages+0xba>
    if (*pte & PTE_V) panic("mappages: remap");
    800005d4:	611c                	ld	a5,0(a0)
    800005d6:	8b85                	andi	a5,a5,1
    800005d8:	e7a9                	bnez	a5,80000622 <mappages+0xaa>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005da:	80b1                	srli	s1,s1,0xc
    800005dc:	00a49793          	slli	a5,s1,0xa
    800005e0:	0177e7b3          	or	a5,a5,s7
    800005e4:	0017e793          	ori	a5,a5,1
    800005e8:	e11c                	sd	a5,0(a0)
    acquire(&ref_count_lock);
    800005ea:	854e                	mv	a0,s3
    800005ec:	00006097          	auipc	ra,0x6
    800005f0:	e78080e7          	jalr	-392(ra) # 80006464 <acquire>
    ++ref_count[((uint64)pa) >> PGSHIFT];
    800005f4:	94e2                	add	s1,s1,s8
    800005f6:	0004c783          	lbu	a5,0(s1)
    800005fa:	2785                	addiw	a5,a5,1
    800005fc:	00f48023          	sb	a5,0(s1)
    release(&ref_count_lock);
    80000600:	854e                	mv	a0,s3
    80000602:	00006097          	auipc	ra,0x6
    80000606:	f16080e7          	jalr	-234(ra) # 80006518 <release>
    if (a == last) break;
    8000060a:	05490263          	beq	s2,s4,8000064e <mappages+0xd6>
    a += PGSIZE;
    8000060e:	9966                	add	s2,s2,s9
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    80000610:	bf45                	j	800005c0 <mappages+0x48>
  if (size == 0) panic("mappages: size");
    80000612:	00008517          	auipc	a0,0x8
    80000616:	a5650513          	addi	a0,a0,-1450 # 80008068 <etext+0x68>
    8000061a:	00006097          	auipc	ra,0x6
    8000061e:	912080e7          	jalr	-1774(ra) # 80005f2c <panic>
    if (*pte & PTE_V) panic("mappages: remap");
    80000622:	00008517          	auipc	a0,0x8
    80000626:	a5650513          	addi	a0,a0,-1450 # 80008078 <etext+0x78>
    8000062a:	00006097          	auipc	ra,0x6
    8000062e:	902080e7          	jalr	-1790(ra) # 80005f2c <panic>
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    80000632:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000634:	60e6                	ld	ra,88(sp)
    80000636:	6446                	ld	s0,80(sp)
    80000638:	64a6                	ld	s1,72(sp)
    8000063a:	6906                	ld	s2,64(sp)
    8000063c:	79e2                	ld	s3,56(sp)
    8000063e:	7a42                	ld	s4,48(sp)
    80000640:	7aa2                	ld	s5,40(sp)
    80000642:	7b02                	ld	s6,32(sp)
    80000644:	6be2                	ld	s7,24(sp)
    80000646:	6c42                	ld	s8,16(sp)
    80000648:	6ca2                	ld	s9,8(sp)
    8000064a:	6125                	addi	sp,sp,96
    8000064c:	8082                	ret
  return 0;
    8000064e:	4501                	li	a0,0
    80000650:	b7d5                	j	80000634 <mappages+0xbc>

0000000080000652 <lalloc>:
uint64 lalloc(uint64 va, struct proc *p) {
    80000652:	7179                	addi	sp,sp,-48
    80000654:	f406                	sd	ra,40(sp)
    80000656:	f022                	sd	s0,32(sp)
    80000658:	ec26                	sd	s1,24(sp)
    8000065a:	e84a                	sd	s2,16(sp)
    8000065c:	e44e                	sd	s3,8(sp)
    8000065e:	e052                	sd	s4,0(sp)
    80000660:	1800                	addi	s0,sp,48
  if (va >= p->sz || va < PGROUNDDOWN(p->trapframe->sp) ||
    80000662:	65bc                	ld	a5,72(a1)
    return 0;
    80000664:	4981                	li	s3,0
  if (va >= p->sz || va < PGROUNDDOWN(p->trapframe->sp) ||
    80000666:	00f57b63          	bgeu	a0,a5,8000067c <lalloc+0x2a>
    8000066a:	892a                	mv	s2,a0
    8000066c:	84ae                	mv	s1,a1
    8000066e:	6dbc                	ld	a5,88(a1)
    80000670:	7b98                	ld	a4,48(a5)
    80000672:	77fd                	lui	a5,0xfffff
    80000674:	8ff9                	and	a5,a5,a4
    return 0;
    80000676:	4981                	li	s3,0
  if (va >= p->sz || va < PGROUNDDOWN(p->trapframe->sp) ||
    80000678:	00f57b63          	bgeu	a0,a5,8000068e <lalloc+0x3c>
}
    8000067c:	854e                	mv	a0,s3
    8000067e:	70a2                	ld	ra,40(sp)
    80000680:	7402                	ld	s0,32(sp)
    80000682:	64e2                	ld	s1,24(sp)
    80000684:	6942                	ld	s2,16(sp)
    80000686:	69a2                	ld	s3,8(sp)
    80000688:	6a02                	ld	s4,0(sp)
    8000068a:	6145                	addi	sp,sp,48
    8000068c:	8082                	ret
      (mem = kalloc()) == 0) {
    8000068e:	00000097          	auipc	ra,0x0
    80000692:	a8c080e7          	jalr	-1396(ra) # 8000011a <kalloc>
    80000696:	8a2a                	mv	s4,a0
  if (va >= p->sz || va < PGROUNDDOWN(p->trapframe->sp) ||
    80000698:	d175                	beqz	a0,8000067c <lalloc+0x2a>
  memset(mem, 0, PGSIZE);
    8000069a:	6605                	lui	a2,0x1
    8000069c:	4581                	li	a1,0
    8000069e:	00000097          	auipc	ra,0x0
    800006a2:	adc080e7          	jalr	-1316(ra) # 8000017a <memset>
  if (mappages(p->pagetable, va, PGSIZE, (uint64)mem,
    800006a6:	89d2                	mv	s3,s4
    800006a8:	4779                	li	a4,30
    800006aa:	86d2                	mv	a3,s4
    800006ac:	6605                	lui	a2,0x1
    800006ae:	85ca                	mv	a1,s2
    800006b0:	68a8                	ld	a0,80(s1)
    800006b2:	00000097          	auipc	ra,0x0
    800006b6:	ec6080e7          	jalr	-314(ra) # 80000578 <mappages>
    800006ba:	d169                	beqz	a0,8000067c <lalloc+0x2a>
    kfree(mem);
    800006bc:	8552                	mv	a0,s4
    800006be:	00000097          	auipc	ra,0x0
    800006c2:	95e080e7          	jalr	-1698(ra) # 8000001c <kfree>
    return 0;
    800006c6:	4981                	li	s3,0
    800006c8:	bf55                	j	8000067c <lalloc+0x2a>

00000000800006ca <kvmmap>:
void kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm) {
    800006ca:	1141                	addi	sp,sp,-16
    800006cc:	e406                	sd	ra,8(sp)
    800006ce:	e022                	sd	s0,0(sp)
    800006d0:	0800                	addi	s0,sp,16
    800006d2:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0) panic("kvmmap");
    800006d4:	86b2                	mv	a3,a2
    800006d6:	863e                	mv	a2,a5
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	ea0080e7          	jalr	-352(ra) # 80000578 <mappages>
    800006e0:	e509                	bnez	a0,800006ea <kvmmap+0x20>
}
    800006e2:	60a2                	ld	ra,8(sp)
    800006e4:	6402                	ld	s0,0(sp)
    800006e6:	0141                	addi	sp,sp,16
    800006e8:	8082                	ret
  if (mappages(kpgtbl, va, sz, pa, perm) != 0) panic("kvmmap");
    800006ea:	00008517          	auipc	a0,0x8
    800006ee:	99e50513          	addi	a0,a0,-1634 # 80008088 <etext+0x88>
    800006f2:	00006097          	auipc	ra,0x6
    800006f6:	83a080e7          	jalr	-1990(ra) # 80005f2c <panic>

00000000800006fa <kvmmake>:
pagetable_t kvmmake(void) {
    800006fa:	1101                	addi	sp,sp,-32
    800006fc:	ec06                	sd	ra,24(sp)
    800006fe:	e822                	sd	s0,16(sp)
    80000700:	e426                	sd	s1,8(sp)
    80000702:	e04a                	sd	s2,0(sp)
    80000704:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    80000706:	00000097          	auipc	ra,0x0
    8000070a:	a14080e7          	jalr	-1516(ra) # 8000011a <kalloc>
    8000070e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000710:	6605                	lui	a2,0x1
    80000712:	4581                	li	a1,0
    80000714:	00000097          	auipc	ra,0x0
    80000718:	a66080e7          	jalr	-1434(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000071c:	4719                	li	a4,6
    8000071e:	6685                	lui	a3,0x1
    80000720:	10000637          	lui	a2,0x10000
    80000724:	100005b7          	lui	a1,0x10000
    80000728:	8526                	mv	a0,s1
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	fa0080e7          	jalr	-96(ra) # 800006ca <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000732:	4719                	li	a4,6
    80000734:	6685                	lui	a3,0x1
    80000736:	10001637          	lui	a2,0x10001
    8000073a:	100015b7          	lui	a1,0x10001
    8000073e:	8526                	mv	a0,s1
    80000740:	00000097          	auipc	ra,0x0
    80000744:	f8a080e7          	jalr	-118(ra) # 800006ca <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000748:	4719                	li	a4,6
    8000074a:	004006b7          	lui	a3,0x400
    8000074e:	0c000637          	lui	a2,0xc000
    80000752:	0c0005b7          	lui	a1,0xc000
    80000756:	8526                	mv	a0,s1
    80000758:	00000097          	auipc	ra,0x0
    8000075c:	f72080e7          	jalr	-142(ra) # 800006ca <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80000760:	00008917          	auipc	s2,0x8
    80000764:	8a090913          	addi	s2,s2,-1888 # 80008000 <etext>
    80000768:	4729                	li	a4,10
    8000076a:	80008697          	auipc	a3,0x80008
    8000076e:	89668693          	addi	a3,a3,-1898 # 8000 <_entry-0x7fff8000>
    80000772:	4605                	li	a2,1
    80000774:	067e                	slli	a2,a2,0x1f
    80000776:	85b2                	mv	a1,a2
    80000778:	8526                	mv	a0,s1
    8000077a:	00000097          	auipc	ra,0x0
    8000077e:	f50080e7          	jalr	-176(ra) # 800006ca <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    80000782:	4719                	li	a4,6
    80000784:	46c5                	li	a3,17
    80000786:	06ee                	slli	a3,a3,0x1b
    80000788:	412686b3          	sub	a3,a3,s2
    8000078c:	864a                	mv	a2,s2
    8000078e:	85ca                	mv	a1,s2
    80000790:	8526                	mv	a0,s1
    80000792:	00000097          	auipc	ra,0x0
    80000796:	f38080e7          	jalr	-200(ra) # 800006ca <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000079a:	4729                	li	a4,10
    8000079c:	6685                	lui	a3,0x1
    8000079e:	00007617          	auipc	a2,0x7
    800007a2:	86260613          	addi	a2,a2,-1950 # 80007000 <_trampoline>
    800007a6:	040005b7          	lui	a1,0x4000
    800007aa:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800007ac:	05b2                	slli	a1,a1,0xc
    800007ae:	8526                	mv	a0,s1
    800007b0:	00000097          	auipc	ra,0x0
    800007b4:	f1a080e7          	jalr	-230(ra) # 800006ca <kvmmap>
  proc_mapstacks(kpgtbl);
    800007b8:	8526                	mv	a0,s1
    800007ba:	00001097          	auipc	ra,0x1
    800007be:	818080e7          	jalr	-2024(ra) # 80000fd2 <proc_mapstacks>
}
    800007c2:	8526                	mv	a0,s1
    800007c4:	60e2                	ld	ra,24(sp)
    800007c6:	6442                	ld	s0,16(sp)
    800007c8:	64a2                	ld	s1,8(sp)
    800007ca:	6902                	ld	s2,0(sp)
    800007cc:	6105                	addi	sp,sp,32
    800007ce:	8082                	ret

00000000800007d0 <kvminit>:
void kvminit(void) { kernel_pagetable = kvmmake(); }
    800007d0:	1141                	addi	sp,sp,-16
    800007d2:	e406                	sd	ra,8(sp)
    800007d4:	e022                	sd	s0,0(sp)
    800007d6:	0800                	addi	s0,sp,16
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	f22080e7          	jalr	-222(ra) # 800006fa <kvmmake>
    800007e0:	00008797          	auipc	a5,0x8
    800007e4:	0aa7bc23          	sd	a0,184(a5) # 80008898 <kernel_pagetable>
    800007e8:	60a2                	ld	ra,8(sp)
    800007ea:	6402                	ld	s0,0(sp)
    800007ec:	0141                	addi	sp,sp,16
    800007ee:	8082                	ret

00000000800007f0 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free) {
    800007f0:	7159                	addi	sp,sp,-112
    800007f2:	f486                	sd	ra,104(sp)
    800007f4:	f0a2                	sd	s0,96(sp)
    800007f6:	eca6                	sd	s1,88(sp)
    800007f8:	e8ca                	sd	s2,80(sp)
    800007fa:	e4ce                	sd	s3,72(sp)
    800007fc:	e0d2                	sd	s4,64(sp)
    800007fe:	fc56                	sd	s5,56(sp)
    80000800:	f85a                	sd	s6,48(sp)
    80000802:	f45e                	sd	s7,40(sp)
    80000804:	f062                	sd	s8,32(sp)
    80000806:	ec66                	sd	s9,24(sp)
    80000808:	e86a                	sd	s10,16(sp)
    8000080a:	e46e                	sd	s11,8(sp)
    8000080c:	1880                	addi	s0,sp,112
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0) panic("uvmunmap: not aligned");
    8000080e:	03459793          	slli	a5,a1,0x34
    80000812:	e79d                	bnez	a5,80000840 <uvmunmap+0x50>
    80000814:	8aaa                	mv	s5,a0
    80000816:	892e                	mv	s2,a1
    80000818:	8c36                	mv	s8,a3

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000081a:	0632                	slli	a2,a2,0xc
    8000081c:	00b60a33          	add	s4,a2,a1
    80000820:	0b45f763          	bgeu	a1,s4,800008ce <uvmunmap+0xde>
    if ((pte = walk(pagetable, a, 0)) == 0) continue;
    if ((*pte & PTE_V) == 0) continue;
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    80000824:	4d85                	li	s11,1
    uint64 pa = PTE2PA(*pte);
    acquire(&ref_count_lock);
    80000826:	00008b17          	auipc	s6,0x8
    8000082a:	0bab0b13          	addi	s6,s6,186 # 800088e0 <ref_count_lock>
    --ref_count[((uint64)pa) >> PGSHIFT];
    8000082e:	5cfd                	li	s9,-1
    80000830:	00ccdc93          	srli	s9,s9,0xc
    80000834:	00008d17          	auipc	s10,0x8
    80000838:	0c4d0d13          	addi	s10,s10,196 # 800088f8 <ref_count>
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000083c:	6b85                	lui	s7,0x1
    8000083e:	a81d                	j	80000874 <uvmunmap+0x84>
  if ((va % PGSIZE) != 0) panic("uvmunmap: not aligned");
    80000840:	00008517          	auipc	a0,0x8
    80000844:	85050513          	addi	a0,a0,-1968 # 80008090 <etext+0x90>
    80000848:	00005097          	auipc	ra,0x5
    8000084c:	6e4080e7          	jalr	1764(ra) # 80005f2c <panic>
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    80000850:	00008517          	auipc	a0,0x8
    80000854:	85850513          	addi	a0,a0,-1960 # 800080a8 <etext+0xa8>
    80000858:	00005097          	auipc	ra,0x5
    8000085c:	6d4080e7          	jalr	1748(ra) # 80005f2c <panic>
    if (do_free && ref_count[((uint64)pa) >> PGSHIFT] == 0) {
      kfree((void *)pa);
    }
    release(&ref_count_lock);
    80000860:	855a                	mv	a0,s6
    80000862:	00006097          	auipc	ra,0x6
    80000866:	cb6080e7          	jalr	-842(ra) # 80006518 <release>
    *pte = 0;
    8000086a:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000086e:	995e                	add	s2,s2,s7
    80000870:	05497f63          	bgeu	s2,s4,800008ce <uvmunmap+0xde>
    if ((pte = walk(pagetable, a, 0)) == 0) continue;
    80000874:	4601                	li	a2,0
    80000876:	85ca                	mv	a1,s2
    80000878:	8556                	mv	a0,s5
    8000087a:	00000097          	auipc	ra,0x0
    8000087e:	c16080e7          	jalr	-1002(ra) # 80000490 <walk>
    80000882:	84aa                	mv	s1,a0
    80000884:	d56d                	beqz	a0,8000086e <uvmunmap+0x7e>
    if ((*pte & PTE_V) == 0) continue;
    80000886:	00053983          	ld	s3,0(a0)
    8000088a:	0019f793          	andi	a5,s3,1
    8000088e:	d3e5                	beqz	a5,8000086e <uvmunmap+0x7e>
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    80000890:	3ff9f793          	andi	a5,s3,1023
    80000894:	fbb78ee3          	beq	a5,s11,80000850 <uvmunmap+0x60>
    uint64 pa = PTE2PA(*pte);
    80000898:	00a9d993          	srli	s3,s3,0xa
    acquire(&ref_count_lock);
    8000089c:	855a                	mv	a0,s6
    8000089e:	00006097          	auipc	ra,0x6
    800008a2:	bc6080e7          	jalr	-1082(ra) # 80006464 <acquire>
    --ref_count[((uint64)pa) >> PGSHIFT];
    800008a6:	0199f733          	and	a4,s3,s9
    800008aa:	976a                	add	a4,a4,s10
    800008ac:	00074783          	lbu	a5,0(a4) # fffffffffffff000 <end+0xffffffff7ff552b0>
    800008b0:	37fd                	addiw	a5,a5,-1
    800008b2:	0ff7f793          	zext.b	a5,a5
    800008b6:	00f70023          	sb	a5,0(a4)
    if (do_free && ref_count[((uint64)pa) >> PGSHIFT] == 0) {
    800008ba:	fa0c03e3          	beqz	s8,80000860 <uvmunmap+0x70>
    800008be:	f3cd                	bnez	a5,80000860 <uvmunmap+0x70>
      kfree((void *)pa);
    800008c0:	00c99513          	slli	a0,s3,0xc
    800008c4:	fffff097          	auipc	ra,0xfffff
    800008c8:	758080e7          	jalr	1880(ra) # 8000001c <kfree>
    800008cc:	bf51                	j	80000860 <uvmunmap+0x70>
  }
}
    800008ce:	70a6                	ld	ra,104(sp)
    800008d0:	7406                	ld	s0,96(sp)
    800008d2:	64e6                	ld	s1,88(sp)
    800008d4:	6946                	ld	s2,80(sp)
    800008d6:	69a6                	ld	s3,72(sp)
    800008d8:	6a06                	ld	s4,64(sp)
    800008da:	7ae2                	ld	s5,56(sp)
    800008dc:	7b42                	ld	s6,48(sp)
    800008de:	7ba2                	ld	s7,40(sp)
    800008e0:	7c02                	ld	s8,32(sp)
    800008e2:	6ce2                	ld	s9,24(sp)
    800008e4:	6d42                	ld	s10,16(sp)
    800008e6:	6da2                	ld	s11,8(sp)
    800008e8:	6165                	addi	sp,sp,112
    800008ea:	8082                	ret

00000000800008ec <cow>:
int cow(uint64 va, pagetable_t pagetable) {
    800008ec:	7139                	addi	sp,sp,-64
    800008ee:	fc06                	sd	ra,56(sp)
    800008f0:	f822                	sd	s0,48(sp)
    800008f2:	f426                	sd	s1,40(sp)
    800008f4:	f04a                	sd	s2,32(sp)
    800008f6:	ec4e                	sd	s3,24(sp)
    800008f8:	e852                	sd	s4,16(sp)
    800008fa:	e456                	sd	s5,8(sp)
    800008fc:	e05a                	sd	s6,0(sp)
    800008fe:	0080                	addi	s0,sp,64
    80000900:	892a                	mv	s2,a0
    80000902:	84ae                	mv	s1,a1
  uint64 pa = walkaddr(pagetable, va);
    80000904:	85aa                	mv	a1,a0
    80000906:	8526                	mv	a0,s1
    80000908:	00000097          	auipc	ra,0x0
    8000090c:	c2e080e7          	jalr	-978(ra) # 80000536 <walkaddr>
  if (pa == 0) return -1;
    80000910:	c579                	beqz	a0,800009de <cow+0xf2>
    80000912:	89aa                	mv	s3,a0
  pte_t *pte = walk(pagetable, va, 0);
    80000914:	4601                	li	a2,0
    80000916:	85ca                	mv	a1,s2
    80000918:	8526                	mv	a0,s1
    8000091a:	00000097          	auipc	ra,0x0
    8000091e:	b76080e7          	jalr	-1162(ra) # 80000490 <walk>
    80000922:	8a2a                	mv	s4,a0
  if ((*pte) & PTE_RSW) {
    80000924:	611c                	ld	a5,0(a0)
    80000926:	1007f793          	andi	a5,a5,256
    8000092a:	cfc5                	beqz	a5,800009e2 <cow+0xf6>
    acquire(&ref_count_lock);
    8000092c:	00008a97          	auipc	s5,0x8
    80000930:	fb4a8a93          	addi	s5,s5,-76 # 800088e0 <ref_count_lock>
    80000934:	8556                	mv	a0,s5
    80000936:	00006097          	auipc	ra,0x6
    8000093a:	b2e080e7          	jalr	-1234(ra) # 80006464 <acquire>
    char cnt = ref_count[((uint64)pa) >> PGSHIFT];
    8000093e:	00c9d713          	srli	a4,s3,0xc
    80000942:	00008797          	auipc	a5,0x8
    80000946:	fb678793          	addi	a5,a5,-74 # 800088f8 <ref_count>
    8000094a:	97ba                	add	a5,a5,a4
    8000094c:	0007cb03          	lbu	s6,0(a5)
    release(&ref_count_lock);
    80000950:	8556                	mv	a0,s5
    80000952:	00006097          	auipc	ra,0x6
    80000956:	bc6080e7          	jalr	-1082(ra) # 80006518 <release>
    if (cnt == 1) {
    8000095a:	4785                	li	a5,1
    8000095c:	02fb1563          	bne	s6,a5,80000986 <cow+0x9a>
      *pte &= ~PTE_RSW;
    80000960:	000a3783          	ld	a5,0(s4)
    80000964:	eff7f793          	andi	a5,a5,-257
      *pte |= PTE_W;
    80000968:	0047e793          	ori	a5,a5,4
    8000096c:	00fa3023          	sd	a5,0(s4)
  return 0;
    80000970:	4501                	li	a0,0
}
    80000972:	70e2                	ld	ra,56(sp)
    80000974:	7442                	ld	s0,48(sp)
    80000976:	74a2                	ld	s1,40(sp)
    80000978:	7902                	ld	s2,32(sp)
    8000097a:	69e2                	ld	s3,24(sp)
    8000097c:	6a42                	ld	s4,16(sp)
    8000097e:	6aa2                	ld	s5,8(sp)
    80000980:	6b02                	ld	s6,0(sp)
    80000982:	6121                	addi	sp,sp,64
    80000984:	8082                	ret
      if ((mem = kalloc()) == 0) return -1;
    80000986:	fffff097          	auipc	ra,0xfffff
    8000098a:	794080e7          	jalr	1940(ra) # 8000011a <kalloc>
    8000098e:	8aaa                	mv	s5,a0
    80000990:	c939                	beqz	a0,800009e6 <cow+0xfa>
      uint flags = PTE_FLAGS(*pte);
    80000992:	000a3a03          	ld	s4,0(s4)
    80000996:	3ffa7a13          	andi	s4,s4,1023
      memmove(mem, (char *)pa, PGSIZE);
    8000099a:	6605                	lui	a2,0x1
    8000099c:	85ce                	mv	a1,s3
    8000099e:	00000097          	auipc	ra,0x0
    800009a2:	838080e7          	jalr	-1992(ra) # 800001d6 <memmove>
      uvmunmap(pagetable, va, 1, 1);
    800009a6:	4685                	li	a3,1
    800009a8:	4605                	li	a2,1
    800009aa:	85ca                	mv	a1,s2
    800009ac:	8526                	mv	a0,s1
    800009ae:	00000097          	auipc	ra,0x0
    800009b2:	e42080e7          	jalr	-446(ra) # 800007f0 <uvmunmap>
                   (flags & (~PTE_RSW)) | (PTE_W)) != 0) {
    800009b6:	efba7713          	andi	a4,s4,-261
      if (mappages(pagetable, va, PGSIZE, (uint64)mem,
    800009ba:	00476713          	ori	a4,a4,4
    800009be:	86d6                	mv	a3,s5
    800009c0:	6605                	lui	a2,0x1
    800009c2:	85ca                	mv	a1,s2
    800009c4:	8526                	mv	a0,s1
    800009c6:	00000097          	auipc	ra,0x0
    800009ca:	bb2080e7          	jalr	-1102(ra) # 80000578 <mappages>
    800009ce:	d155                	beqz	a0,80000972 <cow+0x86>
        kfree(mem);
    800009d0:	8556                	mv	a0,s5
    800009d2:	fffff097          	auipc	ra,0xfffff
    800009d6:	64a080e7          	jalr	1610(ra) # 8000001c <kfree>
        return -1;
    800009da:	557d                	li	a0,-1
    800009dc:	bf59                	j	80000972 <cow+0x86>
  if (pa == 0) return -1;
    800009de:	557d                	li	a0,-1
    800009e0:	bf49                	j	80000972 <cow+0x86>
    return -2;
    800009e2:	5579                	li	a0,-2
    800009e4:	b779                	j	80000972 <cow+0x86>
      if ((mem = kalloc()) == 0) return -1;
    800009e6:	557d                	li	a0,-1
    800009e8:	b769                	j	80000972 <cow+0x86>

00000000800009ea <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate() {
    800009ea:	1101                	addi	sp,sp,-32
    800009ec:	ec06                	sd	ra,24(sp)
    800009ee:	e822                	sd	s0,16(sp)
    800009f0:	e426                	sd	s1,8(sp)
    800009f2:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800009f4:	fffff097          	auipc	ra,0xfffff
    800009f8:	726080e7          	jalr	1830(ra) # 8000011a <kalloc>
    800009fc:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    800009fe:	c519                	beqz	a0,80000a0c <uvmcreate+0x22>
  memset(pagetable, 0, PGSIZE);
    80000a00:	6605                	lui	a2,0x1
    80000a02:	4581                	li	a1,0
    80000a04:	fffff097          	auipc	ra,0xfffff
    80000a08:	776080e7          	jalr	1910(ra) # 8000017a <memset>
  return pagetable;
}
    80000a0c:	8526                	mv	a0,s1
    80000a0e:	60e2                	ld	ra,24(sp)
    80000a10:	6442                	ld	s0,16(sp)
    80000a12:	64a2                	ld	s1,8(sp)
    80000a14:	6105                	addi	sp,sp,32
    80000a16:	8082                	ret

0000000080000a18 <uvmfirst>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz) {
    80000a18:	7179                	addi	sp,sp,-48
    80000a1a:	f406                	sd	ra,40(sp)
    80000a1c:	f022                	sd	s0,32(sp)
    80000a1e:	ec26                	sd	s1,24(sp)
    80000a20:	e84a                	sd	s2,16(sp)
    80000a22:	e44e                	sd	s3,8(sp)
    80000a24:	e052                	sd	s4,0(sp)
    80000a26:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE) panic("uvmfirst: more than a page");
    80000a28:	6785                	lui	a5,0x1
    80000a2a:	04f67863          	bgeu	a2,a5,80000a7a <uvmfirst+0x62>
    80000a2e:	8a2a                	mv	s4,a0
    80000a30:	89ae                	mv	s3,a1
    80000a32:	84b2                	mv	s1,a2
  mem = kalloc();
    80000a34:	fffff097          	auipc	ra,0xfffff
    80000a38:	6e6080e7          	jalr	1766(ra) # 8000011a <kalloc>
    80000a3c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000a3e:	6605                	lui	a2,0x1
    80000a40:	4581                	li	a1,0
    80000a42:	fffff097          	auipc	ra,0xfffff
    80000a46:	738080e7          	jalr	1848(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    80000a4a:	4779                	li	a4,30
    80000a4c:	86ca                	mv	a3,s2
    80000a4e:	6605                	lui	a2,0x1
    80000a50:	4581                	li	a1,0
    80000a52:	8552                	mv	a0,s4
    80000a54:	00000097          	auipc	ra,0x0
    80000a58:	b24080e7          	jalr	-1244(ra) # 80000578 <mappages>
  memmove(mem, src, sz);
    80000a5c:	8626                	mv	a2,s1
    80000a5e:	85ce                	mv	a1,s3
    80000a60:	854a                	mv	a0,s2
    80000a62:	fffff097          	auipc	ra,0xfffff
    80000a66:	774080e7          	jalr	1908(ra) # 800001d6 <memmove>
}
    80000a6a:	70a2                	ld	ra,40(sp)
    80000a6c:	7402                	ld	s0,32(sp)
    80000a6e:	64e2                	ld	s1,24(sp)
    80000a70:	6942                	ld	s2,16(sp)
    80000a72:	69a2                	ld	s3,8(sp)
    80000a74:	6a02                	ld	s4,0(sp)
    80000a76:	6145                	addi	sp,sp,48
    80000a78:	8082                	ret
  if (sz >= PGSIZE) panic("uvmfirst: more than a page");
    80000a7a:	00007517          	auipc	a0,0x7
    80000a7e:	64650513          	addi	a0,a0,1606 # 800080c0 <etext+0xc0>
    80000a82:	00005097          	auipc	ra,0x5
    80000a86:	4aa080e7          	jalr	1194(ra) # 80005f2c <panic>

0000000080000a8a <uvmdealloc>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64 uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    80000a8a:	1101                	addi	sp,sp,-32
    80000a8c:	ec06                	sd	ra,24(sp)
    80000a8e:	e822                	sd	s0,16(sp)
    80000a90:	e426                	sd	s1,8(sp)
    80000a92:	1000                	addi	s0,sp,32
  if (newsz >= oldsz) return oldsz;
    80000a94:	84ae                	mv	s1,a1
    80000a96:	00b67d63          	bgeu	a2,a1,80000ab0 <uvmdealloc+0x26>
    80000a9a:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    80000a9c:	6785                	lui	a5,0x1
    80000a9e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000aa0:	00f60733          	add	a4,a2,a5
    80000aa4:	76fd                	lui	a3,0xfffff
    80000aa6:	8f75                	and	a4,a4,a3
    80000aa8:	97ae                	add	a5,a5,a1
    80000aaa:	8ff5                	and	a5,a5,a3
    80000aac:	00f76863          	bltu	a4,a5,80000abc <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000ab0:	8526                	mv	a0,s1
    80000ab2:	60e2                	ld	ra,24(sp)
    80000ab4:	6442                	ld	s0,16(sp)
    80000ab6:	64a2                	ld	s1,8(sp)
    80000ab8:	6105                	addi	sp,sp,32
    80000aba:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000abc:	8f99                	sub	a5,a5,a4
    80000abe:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000ac0:	4685                	li	a3,1
    80000ac2:	0007861b          	sext.w	a2,a5
    80000ac6:	85ba                	mv	a1,a4
    80000ac8:	00000097          	auipc	ra,0x0
    80000acc:	d28080e7          	jalr	-728(ra) # 800007f0 <uvmunmap>
    80000ad0:	b7c5                	j	80000ab0 <uvmdealloc+0x26>

0000000080000ad2 <uvmalloc>:
  if (newsz < oldsz) return oldsz;
    80000ad2:	0ab66563          	bltu	a2,a1,80000b7c <uvmalloc+0xaa>
uint64 uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int xperm) {
    80000ad6:	7139                	addi	sp,sp,-64
    80000ad8:	fc06                	sd	ra,56(sp)
    80000ada:	f822                	sd	s0,48(sp)
    80000adc:	f426                	sd	s1,40(sp)
    80000ade:	f04a                	sd	s2,32(sp)
    80000ae0:	ec4e                	sd	s3,24(sp)
    80000ae2:	e852                	sd	s4,16(sp)
    80000ae4:	e456                	sd	s5,8(sp)
    80000ae6:	e05a                	sd	s6,0(sp)
    80000ae8:	0080                	addi	s0,sp,64
    80000aea:	8aaa                	mv	s5,a0
    80000aec:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000aee:	6785                	lui	a5,0x1
    80000af0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000af2:	95be                	add	a1,a1,a5
    80000af4:	77fd                	lui	a5,0xfffff
    80000af6:	00f5f9b3          	and	s3,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80000afa:	08c9f363          	bgeu	s3,a2,80000b80 <uvmalloc+0xae>
    80000afe:	894e                	mv	s2,s3
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    80000b00:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000b04:	fffff097          	auipc	ra,0xfffff
    80000b08:	616080e7          	jalr	1558(ra) # 8000011a <kalloc>
    80000b0c:	84aa                	mv	s1,a0
    if (mem == 0) {
    80000b0e:	c51d                	beqz	a0,80000b3c <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000b10:	6605                	lui	a2,0x1
    80000b12:	4581                	li	a1,0
    80000b14:	fffff097          	auipc	ra,0xfffff
    80000b18:	666080e7          	jalr	1638(ra) # 8000017a <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    80000b1c:	875a                	mv	a4,s6
    80000b1e:	86a6                	mv	a3,s1
    80000b20:	6605                	lui	a2,0x1
    80000b22:	85ca                	mv	a1,s2
    80000b24:	8556                	mv	a0,s5
    80000b26:	00000097          	auipc	ra,0x0
    80000b2a:	a52080e7          	jalr	-1454(ra) # 80000578 <mappages>
    80000b2e:	e90d                	bnez	a0,80000b60 <uvmalloc+0x8e>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80000b30:	6785                	lui	a5,0x1
    80000b32:	993e                	add	s2,s2,a5
    80000b34:	fd4968e3          	bltu	s2,s4,80000b04 <uvmalloc+0x32>
  return newsz;
    80000b38:	8552                	mv	a0,s4
    80000b3a:	a809                	j	80000b4c <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000b3c:	864e                	mv	a2,s3
    80000b3e:	85ca                	mv	a1,s2
    80000b40:	8556                	mv	a0,s5
    80000b42:	00000097          	auipc	ra,0x0
    80000b46:	f48080e7          	jalr	-184(ra) # 80000a8a <uvmdealloc>
      return 0;
    80000b4a:	4501                	li	a0,0
}
    80000b4c:	70e2                	ld	ra,56(sp)
    80000b4e:	7442                	ld	s0,48(sp)
    80000b50:	74a2                	ld	s1,40(sp)
    80000b52:	7902                	ld	s2,32(sp)
    80000b54:	69e2                	ld	s3,24(sp)
    80000b56:	6a42                	ld	s4,16(sp)
    80000b58:	6aa2                	ld	s5,8(sp)
    80000b5a:	6b02                	ld	s6,0(sp)
    80000b5c:	6121                	addi	sp,sp,64
    80000b5e:	8082                	ret
      kfree(mem);
    80000b60:	8526                	mv	a0,s1
    80000b62:	fffff097          	auipc	ra,0xfffff
    80000b66:	4ba080e7          	jalr	1210(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000b6a:	864e                	mv	a2,s3
    80000b6c:	85ca                	mv	a1,s2
    80000b6e:	8556                	mv	a0,s5
    80000b70:	00000097          	auipc	ra,0x0
    80000b74:	f1a080e7          	jalr	-230(ra) # 80000a8a <uvmdealloc>
      return 0;
    80000b78:	4501                	li	a0,0
    80000b7a:	bfc9                	j	80000b4c <uvmalloc+0x7a>
  if (newsz < oldsz) return oldsz;
    80000b7c:	852e                	mv	a0,a1
}
    80000b7e:	8082                	ret
  return newsz;
    80000b80:	8532                	mv	a0,a2
    80000b82:	b7e9                	j	80000b4c <uvmalloc+0x7a>

0000000080000b84 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable) {
    80000b84:	7179                	addi	sp,sp,-48
    80000b86:	f406                	sd	ra,40(sp)
    80000b88:	f022                	sd	s0,32(sp)
    80000b8a:	ec26                	sd	s1,24(sp)
    80000b8c:	e84a                	sd	s2,16(sp)
    80000b8e:	e44e                	sd	s3,8(sp)
    80000b90:	e052                	sd	s4,0(sp)
    80000b92:	1800                	addi	s0,sp,48
    80000b94:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    80000b96:	84aa                	mv	s1,a0
    80000b98:	6905                	lui	s2,0x1
    80000b9a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000b9c:	4985                	li	s3,1
    80000b9e:	a829                	j	80000bb8 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000ba0:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000ba2:	00c79513          	slli	a0,a5,0xc
    80000ba6:	00000097          	auipc	ra,0x0
    80000baa:	fde080e7          	jalr	-34(ra) # 80000b84 <freewalk>
      pagetable[i] = 0;
    80000bae:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++) {
    80000bb2:	04a1                	addi	s1,s1,8
    80000bb4:	03248163          	beq	s1,s2,80000bd6 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000bb8:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000bba:	00f7f713          	andi	a4,a5,15
    80000bbe:	ff3701e3          	beq	a4,s3,80000ba0 <freewalk+0x1c>
    } else if (pte & PTE_V) {
    80000bc2:	8b85                	andi	a5,a5,1
    80000bc4:	d7fd                	beqz	a5,80000bb2 <freewalk+0x2e>
      panic("freewalk: leaf");
    80000bc6:	00007517          	auipc	a0,0x7
    80000bca:	51a50513          	addi	a0,a0,1306 # 800080e0 <etext+0xe0>
    80000bce:	00005097          	auipc	ra,0x5
    80000bd2:	35e080e7          	jalr	862(ra) # 80005f2c <panic>
    }
  }
  kfree((void *)pagetable);
    80000bd6:	8552                	mv	a0,s4
    80000bd8:	fffff097          	auipc	ra,0xfffff
    80000bdc:	444080e7          	jalr	1092(ra) # 8000001c <kfree>
}
    80000be0:	70a2                	ld	ra,40(sp)
    80000be2:	7402                	ld	s0,32(sp)
    80000be4:	64e2                	ld	s1,24(sp)
    80000be6:	6942                	ld	s2,16(sp)
    80000be8:	69a2                	ld	s3,8(sp)
    80000bea:	6a02                	ld	s4,0(sp)
    80000bec:	6145                	addi	sp,sp,48
    80000bee:	8082                	ret

0000000080000bf0 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz) {
    80000bf0:	1101                	addi	sp,sp,-32
    80000bf2:	ec06                	sd	ra,24(sp)
    80000bf4:	e822                	sd	s0,16(sp)
    80000bf6:	e426                	sd	s1,8(sp)
    80000bf8:	1000                	addi	s0,sp,32
    80000bfa:	84aa                	mv	s1,a0
  if (sz > 0) uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000bfc:	e999                	bnez	a1,80000c12 <uvmfree+0x22>
  freewalk(pagetable);
    80000bfe:	8526                	mv	a0,s1
    80000c00:	00000097          	auipc	ra,0x0
    80000c04:	f84080e7          	jalr	-124(ra) # 80000b84 <freewalk>
}
    80000c08:	60e2                	ld	ra,24(sp)
    80000c0a:	6442                	ld	s0,16(sp)
    80000c0c:	64a2                	ld	s1,8(sp)
    80000c0e:	6105                	addi	sp,sp,32
    80000c10:	8082                	ret
  if (sz > 0) uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000c12:	6785                	lui	a5,0x1
    80000c14:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000c16:	95be                	add	a1,a1,a5
    80000c18:	4685                	li	a3,1
    80000c1a:	00c5d613          	srli	a2,a1,0xc
    80000c1e:	4581                	li	a1,0
    80000c20:	00000097          	auipc	ra,0x0
    80000c24:	bd0080e7          	jalr	-1072(ra) # 800007f0 <uvmunmap>
    80000c28:	bfd9                	j	80000bfe <uvmfree+0xe>

0000000080000c2a <uvmcopy>:
// frees any allocated pages on failure.
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
  pte_t *pte;
  uint64 pa, i;

  for (i = 0; i < sz; i += PGSIZE) {
    80000c2a:	ca41                	beqz	a2,80000cba <uvmcopy+0x90>
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    80000c2c:	7179                	addi	sp,sp,-48
    80000c2e:	f406                	sd	ra,40(sp)
    80000c30:	f022                	sd	s0,32(sp)
    80000c32:	ec26                	sd	s1,24(sp)
    80000c34:	e84a                	sd	s2,16(sp)
    80000c36:	e44e                	sd	s3,8(sp)
    80000c38:	e052                	sd	s4,0(sp)
    80000c3a:	1800                	addi	s0,sp,48
    80000c3c:	89aa                	mv	s3,a0
    80000c3e:	8a2e                	mv	s4,a1
    80000c40:	8932                	mv	s2,a2
  for (i = 0; i < sz; i += PGSIZE) {
    80000c42:	4481                	li	s1,0
    80000c44:	a005                	j	80000c64 <uvmcopy+0x3a>
    pa = PTE2PA(*pte);
    if ((*pte) & PTE_W) {
      *pte &= ~PTE_W;
      *pte |= PTE_RSW;
    }
    if (mappages(new, i, PGSIZE, (uint64)pa, PTE_FLAGS(*pte)) != 0) {
    80000c46:	6118                	ld	a4,0(a0)
    80000c48:	3ff77713          	andi	a4,a4,1023
    80000c4c:	6605                	lui	a2,0x1
    80000c4e:	85a6                	mv	a1,s1
    80000c50:	8552                	mv	a0,s4
    80000c52:	00000097          	auipc	ra,0x0
    80000c56:	926080e7          	jalr	-1754(ra) # 80000578 <mappages>
    80000c5a:	ed05                	bnez	a0,80000c92 <uvmcopy+0x68>
  for (i = 0; i < sz; i += PGSIZE) {
    80000c5c:	6785                	lui	a5,0x1
    80000c5e:	94be                	add	s1,s1,a5
    80000c60:	0524f463          	bgeu	s1,s2,80000ca8 <uvmcopy+0x7e>
    if ((pte = walk(old, i, 0)) == 0) continue;
    80000c64:	4601                	li	a2,0
    80000c66:	85a6                	mv	a1,s1
    80000c68:	854e                	mv	a0,s3
    80000c6a:	00000097          	auipc	ra,0x0
    80000c6e:	826080e7          	jalr	-2010(ra) # 80000490 <walk>
    80000c72:	d56d                	beqz	a0,80000c5c <uvmcopy+0x32>
    if ((*pte & PTE_V) == 0) continue;
    80000c74:	611c                	ld	a5,0(a0)
    80000c76:	0017f713          	andi	a4,a5,1
    80000c7a:	d36d                	beqz	a4,80000c5c <uvmcopy+0x32>
    pa = PTE2PA(*pte);
    80000c7c:	00a7d693          	srli	a3,a5,0xa
    80000c80:	06b2                	slli	a3,a3,0xc
    if ((*pte) & PTE_W) {
    80000c82:	0047f713          	andi	a4,a5,4
    80000c86:	d361                	beqz	a4,80000c46 <uvmcopy+0x1c>
      *pte &= ~PTE_W;
    80000c88:	9bed                	andi	a5,a5,-5
      *pte |= PTE_RSW;
    80000c8a:	1007e793          	ori	a5,a5,256
    80000c8e:	e11c                	sd	a5,0(a0)
    80000c90:	bf5d                	j	80000c46 <uvmcopy+0x1c>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000c92:	4685                	li	a3,1
    80000c94:	00c4d613          	srli	a2,s1,0xc
    80000c98:	4581                	li	a1,0
    80000c9a:	8552                	mv	a0,s4
    80000c9c:	00000097          	auipc	ra,0x0
    80000ca0:	b54080e7          	jalr	-1196(ra) # 800007f0 <uvmunmap>
  return -1;
    80000ca4:	557d                	li	a0,-1
    80000ca6:	a011                	j	80000caa <uvmcopy+0x80>
  return 0;
    80000ca8:	4501                	li	a0,0
}
    80000caa:	70a2                	ld	ra,40(sp)
    80000cac:	7402                	ld	s0,32(sp)
    80000cae:	64e2                	ld	s1,24(sp)
    80000cb0:	6942                	ld	s2,16(sp)
    80000cb2:	69a2                	ld	s3,8(sp)
    80000cb4:	6a02                	ld	s4,0(sp)
    80000cb6:	6145                	addi	sp,sp,48
    80000cb8:	8082                	ret
  return 0;
    80000cba:	4501                	li	a0,0
}
    80000cbc:	8082                	ret

0000000080000cbe <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va) {
    80000cbe:	1141                	addi	sp,sp,-16
    80000cc0:	e406                	sd	ra,8(sp)
    80000cc2:	e022                	sd	s0,0(sp)
    80000cc4:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000cc6:	4601                	li	a2,0
    80000cc8:	fffff097          	auipc	ra,0xfffff
    80000ccc:	7c8080e7          	jalr	1992(ra) # 80000490 <walk>
  if (pte == 0) panic("uvmclear");
    80000cd0:	c901                	beqz	a0,80000ce0 <uvmclear+0x22>
  *pte &= ~PTE_U;
    80000cd2:	611c                	ld	a5,0(a0)
    80000cd4:	9bbd                	andi	a5,a5,-17
    80000cd6:	e11c                	sd	a5,0(a0)
}
    80000cd8:	60a2                	ld	ra,8(sp)
    80000cda:	6402                	ld	s0,0(sp)
    80000cdc:	0141                	addi	sp,sp,16
    80000cde:	8082                	ret
  if (pte == 0) panic("uvmclear");
    80000ce0:	00007517          	auipc	a0,0x7
    80000ce4:	41050513          	addi	a0,a0,1040 # 800080f0 <etext+0xf0>
    80000ce8:	00005097          	auipc	ra,0x5
    80000cec:	244080e7          	jalr	580(ra) # 80005f2c <panic>

0000000080000cf0 <copyout>:
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    80000cf0:	c2d5                	beqz	a3,80000d94 <copyout+0xa4>
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    80000cf2:	711d                	addi	sp,sp,-96
    80000cf4:	ec86                	sd	ra,88(sp)
    80000cf6:	e8a2                	sd	s0,80(sp)
    80000cf8:	e4a6                	sd	s1,72(sp)
    80000cfa:	e0ca                	sd	s2,64(sp)
    80000cfc:	fc4e                	sd	s3,56(sp)
    80000cfe:	f852                	sd	s4,48(sp)
    80000d00:	f456                	sd	s5,40(sp)
    80000d02:	f05a                	sd	s6,32(sp)
    80000d04:	ec5e                	sd	s7,24(sp)
    80000d06:	e862                	sd	s8,16(sp)
    80000d08:	e466                	sd	s9,8(sp)
    80000d0a:	1080                	addi	s0,sp,96
    80000d0c:	8aaa                	mv	s5,a0
    80000d0e:	89ae                	mv	s3,a1
    80000d10:	8b32                	mv	s6,a2
    80000d12:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000d14:	7cfd                	lui	s9,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (cow(va0, pagetable) == -1) {
    80000d16:	5c7d                	li	s8,-1
      return -1;
    }
    pa0 = walkaddr(pagetable, va0);

    n = PGSIZE - (dstva - va0);
    80000d18:	6b85                	lui	s7,0x1
    80000d1a:	a015                	j	80000d3e <copyout+0x4e>
    if (n > len) n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000d1c:	412989b3          	sub	s3,s3,s2
    80000d20:	0004861b          	sext.w	a2,s1
    80000d24:	85da                	mv	a1,s6
    80000d26:	954e                	add	a0,a0,s3
    80000d28:	fffff097          	auipc	ra,0xfffff
    80000d2c:	4ae080e7          	jalr	1198(ra) # 800001d6 <memmove>

    len -= n;
    80000d30:	409a0a33          	sub	s4,s4,s1
    src += n;
    80000d34:	9b26                	add	s6,s6,s1
    dstva = va0 + PGSIZE;
    80000d36:	017909b3          	add	s3,s2,s7
  while (len > 0) {
    80000d3a:	020a0f63          	beqz	s4,80000d78 <copyout+0x88>
    va0 = PGROUNDDOWN(dstva);
    80000d3e:	0199f933          	and	s2,s3,s9
    pa0 = walkaddr(pagetable, va0);
    80000d42:	85ca                	mv	a1,s2
    80000d44:	8556                	mv	a0,s5
    80000d46:	fffff097          	auipc	ra,0xfffff
    80000d4a:	7f0080e7          	jalr	2032(ra) # 80000536 <walkaddr>
    if (cow(va0, pagetable) == -1) {
    80000d4e:	85d6                	mv	a1,s5
    80000d50:	854a                	mv	a0,s2
    80000d52:	00000097          	auipc	ra,0x0
    80000d56:	b9a080e7          	jalr	-1126(ra) # 800008ec <cow>
    80000d5a:	03850063          	beq	a0,s8,80000d7a <copyout+0x8a>
    pa0 = walkaddr(pagetable, va0);
    80000d5e:	85ca                	mv	a1,s2
    80000d60:	8556                	mv	a0,s5
    80000d62:	fffff097          	auipc	ra,0xfffff
    80000d66:	7d4080e7          	jalr	2004(ra) # 80000536 <walkaddr>
    n = PGSIZE - (dstva - va0);
    80000d6a:	413904b3          	sub	s1,s2,s3
    80000d6e:	94de                	add	s1,s1,s7
    80000d70:	fa9a76e3          	bgeu	s4,s1,80000d1c <copyout+0x2c>
    80000d74:	84d2                	mv	s1,s4
    80000d76:	b75d                	j	80000d1c <copyout+0x2c>
  }
  return 0;
    80000d78:	4501                	li	a0,0
}
    80000d7a:	60e6                	ld	ra,88(sp)
    80000d7c:	6446                	ld	s0,80(sp)
    80000d7e:	64a6                	ld	s1,72(sp)
    80000d80:	6906                	ld	s2,64(sp)
    80000d82:	79e2                	ld	s3,56(sp)
    80000d84:	7a42                	ld	s4,48(sp)
    80000d86:	7aa2                	ld	s5,40(sp)
    80000d88:	7b02                	ld	s6,32(sp)
    80000d8a:	6be2                	ld	s7,24(sp)
    80000d8c:	6c42                	ld	s8,16(sp)
    80000d8e:	6ca2                	ld	s9,8(sp)
    80000d90:	6125                	addi	sp,sp,96
    80000d92:	8082                	ret
  return 0;
    80000d94:	4501                	li	a0,0
}
    80000d96:	8082                	ret

0000000080000d98 <copyin>:
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    80000d98:	ced1                	beqz	a3,80000e34 <copyin+0x9c>
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
    80000d9a:	715d                	addi	sp,sp,-80
    80000d9c:	e486                	sd	ra,72(sp)
    80000d9e:	e0a2                	sd	s0,64(sp)
    80000da0:	fc26                	sd	s1,56(sp)
    80000da2:	f84a                	sd	s2,48(sp)
    80000da4:	f44e                	sd	s3,40(sp)
    80000da6:	f052                	sd	s4,32(sp)
    80000da8:	ec56                	sd	s5,24(sp)
    80000daa:	e85a                	sd	s6,16(sp)
    80000dac:	e45e                	sd	s7,8(sp)
    80000dae:	e062                	sd	s8,0(sp)
    80000db0:	0880                	addi	s0,sp,80
    80000db2:	8baa                	mv	s7,a0
    80000db4:	8aae                	mv	s5,a1
    80000db6:	8932                	mv	s2,a2
    80000db8:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80000dba:	7c7d                	lui	s8,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0 && (pa0 = lalloc(va0, myproc())) == 0) {
      return -1;
    }
    n = PGSIZE - (srcva - va0);
    80000dbc:	6b05                	lui	s6,0x1
    80000dbe:	a805                	j	80000dee <copyin+0x56>
    80000dc0:	412984b3          	sub	s1,s3,s2
    80000dc4:	94da                	add	s1,s1,s6
    80000dc6:	009a7363          	bgeu	s4,s1,80000dcc <copyin+0x34>
    80000dca:	84d2                	mv	s1,s4
    if (n > len) n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000dcc:	413905b3          	sub	a1,s2,s3
    80000dd0:	0004861b          	sext.w	a2,s1
    80000dd4:	95aa                	add	a1,a1,a0
    80000dd6:	8556                	mv	a0,s5
    80000dd8:	fffff097          	auipc	ra,0xfffff
    80000ddc:	3fe080e7          	jalr	1022(ra) # 800001d6 <memmove>

    len -= n;
    80000de0:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80000de4:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80000de6:	01698933          	add	s2,s3,s6
  while (len > 0) {
    80000dea:	020a0863          	beqz	s4,80000e1a <copyin+0x82>
    va0 = PGROUNDDOWN(srcva);
    80000dee:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80000df2:	85ce                	mv	a1,s3
    80000df4:	855e                	mv	a0,s7
    80000df6:	fffff097          	auipc	ra,0xfffff
    80000dfa:	740080e7          	jalr	1856(ra) # 80000536 <walkaddr>
    if (pa0 == 0 && (pa0 = lalloc(va0, myproc())) == 0) {
    80000dfe:	f169                	bnez	a0,80000dc0 <copyin+0x28>
    80000e00:	00000097          	auipc	ra,0x0
    80000e04:	348080e7          	jalr	840(ra) # 80001148 <myproc>
    80000e08:	85aa                	mv	a1,a0
    80000e0a:	854e                	mv	a0,s3
    80000e0c:	00000097          	auipc	ra,0x0
    80000e10:	846080e7          	jalr	-1978(ra) # 80000652 <lalloc>
    80000e14:	f555                	bnez	a0,80000dc0 <copyin+0x28>
      return -1;
    80000e16:	557d                	li	a0,-1
    80000e18:	a011                	j	80000e1c <copyin+0x84>
  }
  return 0;
    80000e1a:	4501                	li	a0,0
}
    80000e1c:	60a6                	ld	ra,72(sp)
    80000e1e:	6406                	ld	s0,64(sp)
    80000e20:	74e2                	ld	s1,56(sp)
    80000e22:	7942                	ld	s2,48(sp)
    80000e24:	79a2                	ld	s3,40(sp)
    80000e26:	7a02                	ld	s4,32(sp)
    80000e28:	6ae2                	ld	s5,24(sp)
    80000e2a:	6b42                	ld	s6,16(sp)
    80000e2c:	6ba2                	ld	s7,8(sp)
    80000e2e:	6c02                	ld	s8,0(sp)
    80000e30:	6161                	addi	sp,sp,80
    80000e32:	8082                	ret
  return 0;
    80000e34:	4501                	li	a0,0
}
    80000e36:	8082                	ret

0000000080000e38 <copyinstr>:
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0) {
    80000e38:	c2dd                	beqz	a3,80000ede <copyinstr+0xa6>
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
    80000e3a:	715d                	addi	sp,sp,-80
    80000e3c:	e486                	sd	ra,72(sp)
    80000e3e:	e0a2                	sd	s0,64(sp)
    80000e40:	fc26                	sd	s1,56(sp)
    80000e42:	f84a                	sd	s2,48(sp)
    80000e44:	f44e                	sd	s3,40(sp)
    80000e46:	f052                	sd	s4,32(sp)
    80000e48:	ec56                	sd	s5,24(sp)
    80000e4a:	e85a                	sd	s6,16(sp)
    80000e4c:	e45e                	sd	s7,8(sp)
    80000e4e:	0880                	addi	s0,sp,80
    80000e50:	8a2a                	mv	s4,a0
    80000e52:	8b2e                	mv	s6,a1
    80000e54:	8bb2                	mv	s7,a2
    80000e56:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000e58:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (srcva - va0);
    80000e5a:	6985                	lui	s3,0x1
    80000e5c:	a02d                	j	80000e86 <copyinstr+0x4e>
    if (n > max) n = max;

    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0) {
      if (*p == '\0') {
        *dst = '\0';
    80000e5e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000e62:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null) {
    80000e64:	37fd                	addiw	a5,a5,-1
    80000e66:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000e6a:	60a6                	ld	ra,72(sp)
    80000e6c:	6406                	ld	s0,64(sp)
    80000e6e:	74e2                	ld	s1,56(sp)
    80000e70:	7942                	ld	s2,48(sp)
    80000e72:	79a2                	ld	s3,40(sp)
    80000e74:	7a02                	ld	s4,32(sp)
    80000e76:	6ae2                	ld	s5,24(sp)
    80000e78:	6b42                	ld	s6,16(sp)
    80000e7a:	6ba2                	ld	s7,8(sp)
    80000e7c:	6161                	addi	sp,sp,80
    80000e7e:	8082                	ret
    srcva = va0 + PGSIZE;
    80000e80:	01390bb3          	add	s7,s2,s3
  while (got_null == 0 && max > 0) {
    80000e84:	c8a9                	beqz	s1,80000ed6 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000e86:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000e8a:	85ca                	mv	a1,s2
    80000e8c:	8552                	mv	a0,s4
    80000e8e:	fffff097          	auipc	ra,0xfffff
    80000e92:	6a8080e7          	jalr	1704(ra) # 80000536 <walkaddr>
    if (pa0 == 0) return -1;
    80000e96:	c131                	beqz	a0,80000eda <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000e98:	417906b3          	sub	a3,s2,s7
    80000e9c:	96ce                	add	a3,a3,s3
    80000e9e:	00d4f363          	bgeu	s1,a3,80000ea4 <copyinstr+0x6c>
    80000ea2:	86a6                	mv	a3,s1
    char *p = (char *)(pa0 + (srcva - va0));
    80000ea4:	955e                	add	a0,a0,s7
    80000ea6:	41250533          	sub	a0,a0,s2
    while (n > 0) {
    80000eaa:	daf9                	beqz	a3,80000e80 <copyinstr+0x48>
    80000eac:	87da                	mv	a5,s6
      if (*p == '\0') {
    80000eae:	41650633          	sub	a2,a0,s6
    80000eb2:	fff48593          	addi	a1,s1,-1
    80000eb6:	95da                	add	a1,a1,s6
    while (n > 0) {
    80000eb8:	96da                	add	a3,a3,s6
      if (*p == '\0') {
    80000eba:	00f60733          	add	a4,a2,a5
    80000ebe:	00074703          	lbu	a4,0(a4)
    80000ec2:	df51                	beqz	a4,80000e5e <copyinstr+0x26>
        *dst = *p;
    80000ec4:	00e78023          	sb	a4,0(a5)
      --max;
    80000ec8:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000ecc:	0785                	addi	a5,a5,1
    while (n > 0) {
    80000ece:	fed796e3          	bne	a5,a3,80000eba <copyinstr+0x82>
      dst++;
    80000ed2:	8b3e                	mv	s6,a5
    80000ed4:	b775                	j	80000e80 <copyinstr+0x48>
    80000ed6:	4781                	li	a5,0
    80000ed8:	b771                	j	80000e64 <copyinstr+0x2c>
    if (pa0 == 0) return -1;
    80000eda:	557d                	li	a0,-1
    80000edc:	b779                	j	80000e6a <copyinstr+0x32>
  int got_null = 0;
    80000ede:	4781                	li	a5,0
  if (got_null) {
    80000ee0:	37fd                	addiw	a5,a5,-1
    80000ee2:	0007851b          	sext.w	a0,a5
}
    80000ee6:	8082                	ret

0000000080000ee8 <vmprint_recur>:

void vmprint_recur(pagetable_t pagetable, int level) {
    80000ee8:	7119                	addi	sp,sp,-128
    80000eea:	fc86                	sd	ra,120(sp)
    80000eec:	f8a2                	sd	s0,112(sp)
    80000eee:	f4a6                	sd	s1,104(sp)
    80000ef0:	f0ca                	sd	s2,96(sp)
    80000ef2:	ecce                	sd	s3,88(sp)
    80000ef4:	e8d2                	sd	s4,80(sp)
    80000ef6:	e4d6                	sd	s5,72(sp)
    80000ef8:	e0da                	sd	s6,64(sp)
    80000efa:	fc5e                	sd	s7,56(sp)
    80000efc:	f862                	sd	s8,48(sp)
    80000efe:	f466                	sd	s9,40(sp)
    80000f00:	f06a                	sd	s10,32(sp)
    80000f02:	ec6e                	sd	s11,24(sp)
    80000f04:	0100                	addi	s0,sp,128
    80000f06:	8a2e                	mv	s4,a1
  for (int i = 0; i < 512; i++) {
    80000f08:	89aa                	mv	s3,a0
    80000f0a:	4901                	li	s2,0
    if (pte & PTE_V) {
      uint64 child = PTE2PA(pte);
      for (int j = 0; j < level; ++j) {
        printf(" ..");
      }
      printf("%d: pte %p pa %p\n", i, pte, child);
    80000f0c:	00007d17          	auipc	s10,0x7
    80000f10:	1fcd0d13          	addi	s10,s10,508 # 80008108 <etext+0x108>
      if (level < 3) {
    80000f14:	4c89                	li	s9,2
        vmprint_recur((pagetable_t)child, level + 1);
    80000f16:	0015879b          	addiw	a5,a1,1
    80000f1a:	f8f43423          	sd	a5,-120(s0)
      for (int j = 0; j < level; ++j) {
    80000f1e:	4d81                	li	s11,0
        printf(" ..");
    80000f20:	00007b17          	auipc	s6,0x7
    80000f24:	1e0b0b13          	addi	s6,s6,480 # 80008100 <etext+0x100>
  for (int i = 0; i < 512; i++) {
    80000f28:	20000c13          	li	s8,512
    80000f2c:	a029                	j	80000f36 <vmprint_recur+0x4e>
    80000f2e:	2905                	addiw	s2,s2,1 # 1001 <_entry-0x7fffefff>
    80000f30:	09a1                	addi	s3,s3,8 # 1008 <_entry-0x7fffeff8>
    80000f32:	05890763          	beq	s2,s8,80000f80 <vmprint_recur+0x98>
    pte_t pte = pagetable[i];
    80000f36:	0009ba83          	ld	s5,0(s3)
    if (pte & PTE_V) {
    80000f3a:	001af793          	andi	a5,s5,1
    80000f3e:	dbe5                	beqz	a5,80000f2e <vmprint_recur+0x46>
      uint64 child = PTE2PA(pte);
    80000f40:	00aadb93          	srli	s7,s5,0xa
    80000f44:	0bb2                	slli	s7,s7,0xc
      for (int j = 0; j < level; ++j) {
    80000f46:	01405b63          	blez	s4,80000f5c <vmprint_recur+0x74>
    80000f4a:	84ee                	mv	s1,s11
        printf(" ..");
    80000f4c:	855a                	mv	a0,s6
    80000f4e:	00005097          	auipc	ra,0x5
    80000f52:	028080e7          	jalr	40(ra) # 80005f76 <printf>
      for (int j = 0; j < level; ++j) {
    80000f56:	2485                	addiw	s1,s1,1
    80000f58:	fe9a1ae3          	bne	s4,s1,80000f4c <vmprint_recur+0x64>
      printf("%d: pte %p pa %p\n", i, pte, child);
    80000f5c:	86de                	mv	a3,s7
    80000f5e:	8656                	mv	a2,s5
    80000f60:	85ca                	mv	a1,s2
    80000f62:	856a                	mv	a0,s10
    80000f64:	00005097          	auipc	ra,0x5
    80000f68:	012080e7          	jalr	18(ra) # 80005f76 <printf>
      if (level < 3) {
    80000f6c:	fd4cc1e3          	blt	s9,s4,80000f2e <vmprint_recur+0x46>
        vmprint_recur((pagetable_t)child, level + 1);
    80000f70:	f8843583          	ld	a1,-120(s0)
    80000f74:	855e                	mv	a0,s7
    80000f76:	00000097          	auipc	ra,0x0
    80000f7a:	f72080e7          	jalr	-142(ra) # 80000ee8 <vmprint_recur>
    80000f7e:	bf45                	j	80000f2e <vmprint_recur+0x46>
      }
    }
  }
}
    80000f80:	70e6                	ld	ra,120(sp)
    80000f82:	7446                	ld	s0,112(sp)
    80000f84:	74a6                	ld	s1,104(sp)
    80000f86:	7906                	ld	s2,96(sp)
    80000f88:	69e6                	ld	s3,88(sp)
    80000f8a:	6a46                	ld	s4,80(sp)
    80000f8c:	6aa6                	ld	s5,72(sp)
    80000f8e:	6b06                	ld	s6,64(sp)
    80000f90:	7be2                	ld	s7,56(sp)
    80000f92:	7c42                	ld	s8,48(sp)
    80000f94:	7ca2                	ld	s9,40(sp)
    80000f96:	7d02                	ld	s10,32(sp)
    80000f98:	6de2                	ld	s11,24(sp)
    80000f9a:	6109                	addi	sp,sp,128
    80000f9c:	8082                	ret

0000000080000f9e <vmprint>:

void vmprint(pagetable_t pagetable) {
    80000f9e:	1101                	addi	sp,sp,-32
    80000fa0:	ec06                	sd	ra,24(sp)
    80000fa2:	e822                	sd	s0,16(sp)
    80000fa4:	e426                	sd	s1,8(sp)
    80000fa6:	1000                	addi	s0,sp,32
    80000fa8:	84aa                	mv	s1,a0
  printf("page table %p\n", pagetable);
    80000faa:	85aa                	mv	a1,a0
    80000fac:	00007517          	auipc	a0,0x7
    80000fb0:	17450513          	addi	a0,a0,372 # 80008120 <etext+0x120>
    80000fb4:	00005097          	auipc	ra,0x5
    80000fb8:	fc2080e7          	jalr	-62(ra) # 80005f76 <printf>
  vmprint_recur(pagetable, 1);
    80000fbc:	4585                	li	a1,1
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	00000097          	auipc	ra,0x0
    80000fc4:	f28080e7          	jalr	-216(ra) # 80000ee8 <vmprint_recur>
    80000fc8:	60e2                	ld	ra,24(sp)
    80000fca:	6442                	ld	s0,16(sp)
    80000fcc:	64a2                	ld	s1,8(sp)
    80000fce:	6105                	addi	sp,sp,32
    80000fd0:	8082                	ret

0000000080000fd2 <proc_mapstacks>:
struct spinlock wait_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl) {
    80000fd2:	7139                	addi	sp,sp,-64
    80000fd4:	fc06                	sd	ra,56(sp)
    80000fd6:	f822                	sd	s0,48(sp)
    80000fd8:	f426                	sd	s1,40(sp)
    80000fda:	f04a                	sd	s2,32(sp)
    80000fdc:	ec4e                	sd	s3,24(sp)
    80000fde:	e852                	sd	s4,16(sp)
    80000fe0:	e456                	sd	s5,8(sp)
    80000fe2:	e05a                	sd	s6,0(sp)
    80000fe4:	0080                	addi	s0,sp,64
    80000fe6:	89aa                	mv	s3,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80000fe8:	00090497          	auipc	s1,0x90
    80000fec:	d4048493          	addi	s1,s1,-704 # 80090d28 <proc>
    char *pa = kalloc();
    if (pa == 0) panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80000ff0:	8b26                	mv	s6,s1
    80000ff2:	00007a97          	auipc	s5,0x7
    80000ff6:	00ea8a93          	addi	s5,s5,14 # 80008000 <etext>
    80000ffa:	04000937          	lui	s2,0x4000
    80000ffe:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001000:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80001002:	00095a17          	auipc	s4,0x95
    80001006:	726a0a13          	addi	s4,s4,1830 # 80096728 <tickslock>
    char *pa = kalloc();
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	110080e7          	jalr	272(ra) # 8000011a <kalloc>
    80001012:	862a                	mv	a2,a0
    if (pa == 0) panic("kalloc");
    80001014:	c131                	beqz	a0,80001058 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    80001016:	416485b3          	sub	a1,s1,s6
    8000101a:	858d                	srai	a1,a1,0x3
    8000101c:	000ab783          	ld	a5,0(s5)
    80001020:	02f585b3          	mul	a1,a1,a5
    80001024:	2585                	addiw	a1,a1,1
    80001026:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000102a:	4719                	li	a4,6
    8000102c:	6685                	lui	a3,0x1
    8000102e:	40b905b3          	sub	a1,s2,a1
    80001032:	854e                	mv	a0,s3
    80001034:	fffff097          	auipc	ra,0xfffff
    80001038:	696080e7          	jalr	1686(ra) # 800006ca <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000103c:	16848493          	addi	s1,s1,360
    80001040:	fd4495e3          	bne	s1,s4,8000100a <proc_mapstacks+0x38>
  }
}
    80001044:	70e2                	ld	ra,56(sp)
    80001046:	7442                	ld	s0,48(sp)
    80001048:	74a2                	ld	s1,40(sp)
    8000104a:	7902                	ld	s2,32(sp)
    8000104c:	69e2                	ld	s3,24(sp)
    8000104e:	6a42                	ld	s4,16(sp)
    80001050:	6aa2                	ld	s5,8(sp)
    80001052:	6b02                	ld	s6,0(sp)
    80001054:	6121                	addi	sp,sp,64
    80001056:	8082                	ret
    if (pa == 0) panic("kalloc");
    80001058:	00007517          	auipc	a0,0x7
    8000105c:	0d850513          	addi	a0,a0,216 # 80008130 <etext+0x130>
    80001060:	00005097          	auipc	ra,0x5
    80001064:	ecc080e7          	jalr	-308(ra) # 80005f2c <panic>

0000000080001068 <procinit>:

// initialize the proc table.
void procinit(void) {
    80001068:	7139                	addi	sp,sp,-64
    8000106a:	fc06                	sd	ra,56(sp)
    8000106c:	f822                	sd	s0,48(sp)
    8000106e:	f426                	sd	s1,40(sp)
    80001070:	f04a                	sd	s2,32(sp)
    80001072:	ec4e                	sd	s3,24(sp)
    80001074:	e852                	sd	s4,16(sp)
    80001076:	e456                	sd	s5,8(sp)
    80001078:	e05a                	sd	s6,0(sp)
    8000107a:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    8000107c:	00007597          	auipc	a1,0x7
    80001080:	0bc58593          	addi	a1,a1,188 # 80008138 <etext+0x138>
    80001084:	00090517          	auipc	a0,0x90
    80001088:	87450513          	addi	a0,a0,-1932 # 800908f8 <pid_lock>
    8000108c:	00005097          	auipc	ra,0x5
    80001090:	348080e7          	jalr	840(ra) # 800063d4 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001094:	00007597          	auipc	a1,0x7
    80001098:	0ac58593          	addi	a1,a1,172 # 80008140 <etext+0x140>
    8000109c:	00090517          	auipc	a0,0x90
    800010a0:	87450513          	addi	a0,a0,-1932 # 80090910 <wait_lock>
    800010a4:	00005097          	auipc	ra,0x5
    800010a8:	330080e7          	jalr	816(ra) # 800063d4 <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    800010ac:	00090497          	auipc	s1,0x90
    800010b0:	c7c48493          	addi	s1,s1,-900 # 80090d28 <proc>
    initlock(&p->lock, "proc");
    800010b4:	00007b17          	auipc	s6,0x7
    800010b8:	09cb0b13          	addi	s6,s6,156 # 80008150 <etext+0x150>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    800010bc:	8aa6                	mv	s5,s1
    800010be:	00007a17          	auipc	s4,0x7
    800010c2:	f42a0a13          	addi	s4,s4,-190 # 80008000 <etext>
    800010c6:	04000937          	lui	s2,0x4000
    800010ca:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    800010cc:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    800010ce:	00095997          	auipc	s3,0x95
    800010d2:	65a98993          	addi	s3,s3,1626 # 80096728 <tickslock>
    initlock(&p->lock, "proc");
    800010d6:	85da                	mv	a1,s6
    800010d8:	8526                	mv	a0,s1
    800010da:	00005097          	auipc	ra,0x5
    800010de:	2fa080e7          	jalr	762(ra) # 800063d4 <initlock>
    p->state = UNUSED;
    800010e2:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    800010e6:	415487b3          	sub	a5,s1,s5
    800010ea:	878d                	srai	a5,a5,0x3
    800010ec:	000a3703          	ld	a4,0(s4)
    800010f0:	02e787b3          	mul	a5,a5,a4
    800010f4:	2785                	addiw	a5,a5,1
    800010f6:	00d7979b          	slliw	a5,a5,0xd
    800010fa:	40f907b3          	sub	a5,s2,a5
    800010fe:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    80001100:	16848493          	addi	s1,s1,360
    80001104:	fd3499e3          	bne	s1,s3,800010d6 <procinit+0x6e>
  }
}
    80001108:	70e2                	ld	ra,56(sp)
    8000110a:	7442                	ld	s0,48(sp)
    8000110c:	74a2                	ld	s1,40(sp)
    8000110e:	7902                	ld	s2,32(sp)
    80001110:	69e2                	ld	s3,24(sp)
    80001112:	6a42                	ld	s4,16(sp)
    80001114:	6aa2                	ld	s5,8(sp)
    80001116:	6b02                	ld	s6,0(sp)
    80001118:	6121                	addi	sp,sp,64
    8000111a:	8082                	ret

000000008000111c <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid() {
    8000111c:	1141                	addi	sp,sp,-16
    8000111e:	e422                	sd	s0,8(sp)
    80001120:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    80001122:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001124:	2501                	sext.w	a0,a0
    80001126:	6422                	ld	s0,8(sp)
    80001128:	0141                	addi	sp,sp,16
    8000112a:	8082                	ret

000000008000112c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *mycpu(void) {
    8000112c:	1141                	addi	sp,sp,-16
    8000112e:	e422                	sd	s0,8(sp)
    80001130:	0800                	addi	s0,sp,16
    80001132:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001134:	2781                	sext.w	a5,a5
    80001136:	079e                	slli	a5,a5,0x7
  return c;
}
    80001138:	0008f517          	auipc	a0,0x8f
    8000113c:	7f050513          	addi	a0,a0,2032 # 80090928 <cpus>
    80001140:	953e                	add	a0,a0,a5
    80001142:	6422                	ld	s0,8(sp)
    80001144:	0141                	addi	sp,sp,16
    80001146:	8082                	ret

0000000080001148 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *myproc(void) {
    80001148:	1101                	addi	sp,sp,-32
    8000114a:	ec06                	sd	ra,24(sp)
    8000114c:	e822                	sd	s0,16(sp)
    8000114e:	e426                	sd	s1,8(sp)
    80001150:	1000                	addi	s0,sp,32
  push_off();
    80001152:	00005097          	auipc	ra,0x5
    80001156:	2c6080e7          	jalr	710(ra) # 80006418 <push_off>
    8000115a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000115c:	2781                	sext.w	a5,a5
    8000115e:	079e                	slli	a5,a5,0x7
    80001160:	0008f717          	auipc	a4,0x8f
    80001164:	79870713          	addi	a4,a4,1944 # 800908f8 <pid_lock>
    80001168:	97ba                	add	a5,a5,a4
    8000116a:	7b84                	ld	s1,48(a5)
  pop_off();
    8000116c:	00005097          	auipc	ra,0x5
    80001170:	34c080e7          	jalr	844(ra) # 800064b8 <pop_off>
  return p;
}
    80001174:	8526                	mv	a0,s1
    80001176:	60e2                	ld	ra,24(sp)
    80001178:	6442                	ld	s0,16(sp)
    8000117a:	64a2                	ld	s1,8(sp)
    8000117c:	6105                	addi	sp,sp,32
    8000117e:	8082                	ret

0000000080001180 <forkret>:
  release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void) {
    80001180:	1141                	addi	sp,sp,-16
    80001182:	e406                	sd	ra,8(sp)
    80001184:	e022                	sd	s0,0(sp)
    80001186:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001188:	00000097          	auipc	ra,0x0
    8000118c:	fc0080e7          	jalr	-64(ra) # 80001148 <myproc>
    80001190:	00005097          	auipc	ra,0x5
    80001194:	388080e7          	jalr	904(ra) # 80006518 <release>

  if (first) {
    80001198:	00007797          	auipc	a5,0x7
    8000119c:	6887a783          	lw	a5,1672(a5) # 80008820 <first.1>
    800011a0:	eb89                	bnez	a5,800011b2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    800011a2:	00001097          	auipc	ra,0x1
    800011a6:	c62080e7          	jalr	-926(ra) # 80001e04 <usertrapret>
}
    800011aa:	60a2                	ld	ra,8(sp)
    800011ac:	6402                	ld	s0,0(sp)
    800011ae:	0141                	addi	sp,sp,16
    800011b0:	8082                	ret
    first = 0;
    800011b2:	00007797          	auipc	a5,0x7
    800011b6:	6607a723          	sw	zero,1646(a5) # 80008820 <first.1>
    fsinit(ROOTDEV);
    800011ba:	4505                	li	a0,1
    800011bc:	00002097          	auipc	ra,0x2
    800011c0:	a26080e7          	jalr	-1498(ra) # 80002be2 <fsinit>
    800011c4:	bff9                	j	800011a2 <forkret+0x22>

00000000800011c6 <allocpid>:
int allocpid() {
    800011c6:	1101                	addi	sp,sp,-32
    800011c8:	ec06                	sd	ra,24(sp)
    800011ca:	e822                	sd	s0,16(sp)
    800011cc:	e426                	sd	s1,8(sp)
    800011ce:	e04a                	sd	s2,0(sp)
    800011d0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800011d2:	0008f917          	auipc	s2,0x8f
    800011d6:	72690913          	addi	s2,s2,1830 # 800908f8 <pid_lock>
    800011da:	854a                	mv	a0,s2
    800011dc:	00005097          	auipc	ra,0x5
    800011e0:	288080e7          	jalr	648(ra) # 80006464 <acquire>
  pid = nextpid;
    800011e4:	00007797          	auipc	a5,0x7
    800011e8:	64078793          	addi	a5,a5,1600 # 80008824 <nextpid>
    800011ec:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800011ee:	0014871b          	addiw	a4,s1,1
    800011f2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800011f4:	854a                	mv	a0,s2
    800011f6:	00005097          	auipc	ra,0x5
    800011fa:	322080e7          	jalr	802(ra) # 80006518 <release>
}
    800011fe:	8526                	mv	a0,s1
    80001200:	60e2                	ld	ra,24(sp)
    80001202:	6442                	ld	s0,16(sp)
    80001204:	64a2                	ld	s1,8(sp)
    80001206:	6902                	ld	s2,0(sp)
    80001208:	6105                	addi	sp,sp,32
    8000120a:	8082                	ret

000000008000120c <proc_pagetable>:
pagetable_t proc_pagetable(struct proc *p) {
    8000120c:	1101                	addi	sp,sp,-32
    8000120e:	ec06                	sd	ra,24(sp)
    80001210:	e822                	sd	s0,16(sp)
    80001212:	e426                	sd	s1,8(sp)
    80001214:	e04a                	sd	s2,0(sp)
    80001216:	1000                	addi	s0,sp,32
    80001218:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000121a:	fffff097          	auipc	ra,0xfffff
    8000121e:	7d0080e7          	jalr	2000(ra) # 800009ea <uvmcreate>
    80001222:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    80001224:	c121                	beqz	a0,80001264 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80001226:	4729                	li	a4,10
    80001228:	00006697          	auipc	a3,0x6
    8000122c:	dd868693          	addi	a3,a3,-552 # 80007000 <_trampoline>
    80001230:	6605                	lui	a2,0x1
    80001232:	040005b7          	lui	a1,0x4000
    80001236:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001238:	05b2                	slli	a1,a1,0xc
    8000123a:	fffff097          	auipc	ra,0xfffff
    8000123e:	33e080e7          	jalr	830(ra) # 80000578 <mappages>
    80001242:	02054863          	bltz	a0,80001272 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001246:	4719                	li	a4,6
    80001248:	05893683          	ld	a3,88(s2)
    8000124c:	6605                	lui	a2,0x1
    8000124e:	020005b7          	lui	a1,0x2000
    80001252:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001254:	05b6                	slli	a1,a1,0xd
    80001256:	8526                	mv	a0,s1
    80001258:	fffff097          	auipc	ra,0xfffff
    8000125c:	320080e7          	jalr	800(ra) # 80000578 <mappages>
    80001260:	02054163          	bltz	a0,80001282 <proc_pagetable+0x76>
}
    80001264:	8526                	mv	a0,s1
    80001266:	60e2                	ld	ra,24(sp)
    80001268:	6442                	ld	s0,16(sp)
    8000126a:	64a2                	ld	s1,8(sp)
    8000126c:	6902                	ld	s2,0(sp)
    8000126e:	6105                	addi	sp,sp,32
    80001270:	8082                	ret
    uvmfree(pagetable, 0);
    80001272:	4581                	li	a1,0
    80001274:	8526                	mv	a0,s1
    80001276:	00000097          	auipc	ra,0x0
    8000127a:	97a080e7          	jalr	-1670(ra) # 80000bf0 <uvmfree>
    return 0;
    8000127e:	4481                	li	s1,0
    80001280:	b7d5                	j	80001264 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001282:	4681                	li	a3,0
    80001284:	4605                	li	a2,1
    80001286:	040005b7          	lui	a1,0x4000
    8000128a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000128c:	05b2                	slli	a1,a1,0xc
    8000128e:	8526                	mv	a0,s1
    80001290:	fffff097          	auipc	ra,0xfffff
    80001294:	560080e7          	jalr	1376(ra) # 800007f0 <uvmunmap>
    uvmfree(pagetable, 0);
    80001298:	4581                	li	a1,0
    8000129a:	8526                	mv	a0,s1
    8000129c:	00000097          	auipc	ra,0x0
    800012a0:	954080e7          	jalr	-1708(ra) # 80000bf0 <uvmfree>
    return 0;
    800012a4:	4481                	li	s1,0
    800012a6:	bf7d                	j	80001264 <proc_pagetable+0x58>

00000000800012a8 <proc_freepagetable>:
void proc_freepagetable(pagetable_t pagetable, uint64 sz) {
    800012a8:	1101                	addi	sp,sp,-32
    800012aa:	ec06                	sd	ra,24(sp)
    800012ac:	e822                	sd	s0,16(sp)
    800012ae:	e426                	sd	s1,8(sp)
    800012b0:	e04a                	sd	s2,0(sp)
    800012b2:	1000                	addi	s0,sp,32
    800012b4:	84aa                	mv	s1,a0
    800012b6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800012b8:	4681                	li	a3,0
    800012ba:	4605                	li	a2,1
    800012bc:	040005b7          	lui	a1,0x4000
    800012c0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800012c2:	05b2                	slli	a1,a1,0xc
    800012c4:	fffff097          	auipc	ra,0xfffff
    800012c8:	52c080e7          	jalr	1324(ra) # 800007f0 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800012cc:	4681                	li	a3,0
    800012ce:	4605                	li	a2,1
    800012d0:	020005b7          	lui	a1,0x2000
    800012d4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800012d6:	05b6                	slli	a1,a1,0xd
    800012d8:	8526                	mv	a0,s1
    800012da:	fffff097          	auipc	ra,0xfffff
    800012de:	516080e7          	jalr	1302(ra) # 800007f0 <uvmunmap>
  uvmfree(pagetable, sz);
    800012e2:	85ca                	mv	a1,s2
    800012e4:	8526                	mv	a0,s1
    800012e6:	00000097          	auipc	ra,0x0
    800012ea:	90a080e7          	jalr	-1782(ra) # 80000bf0 <uvmfree>
}
    800012ee:	60e2                	ld	ra,24(sp)
    800012f0:	6442                	ld	s0,16(sp)
    800012f2:	64a2                	ld	s1,8(sp)
    800012f4:	6902                	ld	s2,0(sp)
    800012f6:	6105                	addi	sp,sp,32
    800012f8:	8082                	ret

00000000800012fa <freeproc>:
static void freeproc(struct proc *p) {
    800012fa:	1101                	addi	sp,sp,-32
    800012fc:	ec06                	sd	ra,24(sp)
    800012fe:	e822                	sd	s0,16(sp)
    80001300:	e426                	sd	s1,8(sp)
    80001302:	1000                	addi	s0,sp,32
    80001304:	84aa                	mv	s1,a0
  if (p->trapframe) kfree((void *)p->trapframe);
    80001306:	6d28                	ld	a0,88(a0)
    80001308:	c509                	beqz	a0,80001312 <freeproc+0x18>
    8000130a:	fffff097          	auipc	ra,0xfffff
    8000130e:	d12080e7          	jalr	-750(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001312:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable) proc_freepagetable(p->pagetable, p->sz);
    80001316:	68a8                	ld	a0,80(s1)
    80001318:	c511                	beqz	a0,80001324 <freeproc+0x2a>
    8000131a:	64ac                	ld	a1,72(s1)
    8000131c:	00000097          	auipc	ra,0x0
    80001320:	f8c080e7          	jalr	-116(ra) # 800012a8 <proc_freepagetable>
  p->pagetable = 0;
    80001324:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001328:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000132c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001330:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001334:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001338:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000133c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001340:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001344:	0004ac23          	sw	zero,24(s1)
}
    80001348:	60e2                	ld	ra,24(sp)
    8000134a:	6442                	ld	s0,16(sp)
    8000134c:	64a2                	ld	s1,8(sp)
    8000134e:	6105                	addi	sp,sp,32
    80001350:	8082                	ret

0000000080001352 <allocproc>:
static struct proc *allocproc(void) {
    80001352:	1101                	addi	sp,sp,-32
    80001354:	ec06                	sd	ra,24(sp)
    80001356:	e822                	sd	s0,16(sp)
    80001358:	e426                	sd	s1,8(sp)
    8000135a:	e04a                	sd	s2,0(sp)
    8000135c:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    8000135e:	00090497          	auipc	s1,0x90
    80001362:	9ca48493          	addi	s1,s1,-1590 # 80090d28 <proc>
    80001366:	00095917          	auipc	s2,0x95
    8000136a:	3c290913          	addi	s2,s2,962 # 80096728 <tickslock>
    acquire(&p->lock);
    8000136e:	8526                	mv	a0,s1
    80001370:	00005097          	auipc	ra,0x5
    80001374:	0f4080e7          	jalr	244(ra) # 80006464 <acquire>
    if (p->state == UNUSED) {
    80001378:	4c9c                	lw	a5,24(s1)
    8000137a:	cf81                	beqz	a5,80001392 <allocproc+0x40>
      release(&p->lock);
    8000137c:	8526                	mv	a0,s1
    8000137e:	00005097          	auipc	ra,0x5
    80001382:	19a080e7          	jalr	410(ra) # 80006518 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001386:	16848493          	addi	s1,s1,360
    8000138a:	ff2492e3          	bne	s1,s2,8000136e <allocproc+0x1c>
  return 0;
    8000138e:	4481                	li	s1,0
    80001390:	a889                	j	800013e2 <allocproc+0x90>
  p->pid = allocpid();
    80001392:	00000097          	auipc	ra,0x0
    80001396:	e34080e7          	jalr	-460(ra) # 800011c6 <allocpid>
    8000139a:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000139c:	4785                	li	a5,1
    8000139e:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    800013a0:	fffff097          	auipc	ra,0xfffff
    800013a4:	d7a080e7          	jalr	-646(ra) # 8000011a <kalloc>
    800013a8:	892a                	mv	s2,a0
    800013aa:	eca8                	sd	a0,88(s1)
    800013ac:	c131                	beqz	a0,800013f0 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800013ae:	8526                	mv	a0,s1
    800013b0:	00000097          	auipc	ra,0x0
    800013b4:	e5c080e7          	jalr	-420(ra) # 8000120c <proc_pagetable>
    800013b8:	892a                	mv	s2,a0
    800013ba:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    800013bc:	c531                	beqz	a0,80001408 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800013be:	07000613          	li	a2,112
    800013c2:	4581                	li	a1,0
    800013c4:	06048513          	addi	a0,s1,96
    800013c8:	fffff097          	auipc	ra,0xfffff
    800013cc:	db2080e7          	jalr	-590(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800013d0:	00000797          	auipc	a5,0x0
    800013d4:	db078793          	addi	a5,a5,-592 # 80001180 <forkret>
    800013d8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800013da:	60bc                	ld	a5,64(s1)
    800013dc:	6705                	lui	a4,0x1
    800013de:	97ba                	add	a5,a5,a4
    800013e0:	f4bc                	sd	a5,104(s1)
}
    800013e2:	8526                	mv	a0,s1
    800013e4:	60e2                	ld	ra,24(sp)
    800013e6:	6442                	ld	s0,16(sp)
    800013e8:	64a2                	ld	s1,8(sp)
    800013ea:	6902                	ld	s2,0(sp)
    800013ec:	6105                	addi	sp,sp,32
    800013ee:	8082                	ret
    freeproc(p);
    800013f0:	8526                	mv	a0,s1
    800013f2:	00000097          	auipc	ra,0x0
    800013f6:	f08080e7          	jalr	-248(ra) # 800012fa <freeproc>
    release(&p->lock);
    800013fa:	8526                	mv	a0,s1
    800013fc:	00005097          	auipc	ra,0x5
    80001400:	11c080e7          	jalr	284(ra) # 80006518 <release>
    return 0;
    80001404:	84ca                	mv	s1,s2
    80001406:	bff1                	j	800013e2 <allocproc+0x90>
    freeproc(p);
    80001408:	8526                	mv	a0,s1
    8000140a:	00000097          	auipc	ra,0x0
    8000140e:	ef0080e7          	jalr	-272(ra) # 800012fa <freeproc>
    release(&p->lock);
    80001412:	8526                	mv	a0,s1
    80001414:	00005097          	auipc	ra,0x5
    80001418:	104080e7          	jalr	260(ra) # 80006518 <release>
    return 0;
    8000141c:	84ca                	mv	s1,s2
    8000141e:	b7d1                	j	800013e2 <allocproc+0x90>

0000000080001420 <userinit>:
void userinit(void) {
    80001420:	1101                	addi	sp,sp,-32
    80001422:	ec06                	sd	ra,24(sp)
    80001424:	e822                	sd	s0,16(sp)
    80001426:	e426                	sd	s1,8(sp)
    80001428:	1000                	addi	s0,sp,32
  p = allocproc();
    8000142a:	00000097          	auipc	ra,0x0
    8000142e:	f28080e7          	jalr	-216(ra) # 80001352 <allocproc>
    80001432:	84aa                	mv	s1,a0
  initproc = p;
    80001434:	00007797          	auipc	a5,0x7
    80001438:	46a7b623          	sd	a0,1132(a5) # 800088a0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000143c:	03400613          	li	a2,52
    80001440:	00007597          	auipc	a1,0x7
    80001444:	3f058593          	addi	a1,a1,1008 # 80008830 <initcode>
    80001448:	6928                	ld	a0,80(a0)
    8000144a:	fffff097          	auipc	ra,0xfffff
    8000144e:	5ce080e7          	jalr	1486(ra) # 80000a18 <uvmfirst>
  p->sz = PGSIZE;
    80001452:	6785                	lui	a5,0x1
    80001454:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001456:	6cb8                	ld	a4,88(s1)
    80001458:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000145c:	6cb8                	ld	a4,88(s1)
    8000145e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001460:	4641                	li	a2,16
    80001462:	00007597          	auipc	a1,0x7
    80001466:	cf658593          	addi	a1,a1,-778 # 80008158 <etext+0x158>
    8000146a:	15848513          	addi	a0,s1,344
    8000146e:	fffff097          	auipc	ra,0xfffff
    80001472:	e56080e7          	jalr	-426(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    80001476:	00007517          	auipc	a0,0x7
    8000147a:	cf250513          	addi	a0,a0,-782 # 80008168 <etext+0x168>
    8000147e:	00002097          	auipc	ra,0x2
    80001482:	18e080e7          	jalr	398(ra) # 8000360c <namei>
    80001486:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000148a:	478d                	li	a5,3
    8000148c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000148e:	8526                	mv	a0,s1
    80001490:	00005097          	auipc	ra,0x5
    80001494:	088080e7          	jalr	136(ra) # 80006518 <release>
}
    80001498:	60e2                	ld	ra,24(sp)
    8000149a:	6442                	ld	s0,16(sp)
    8000149c:	64a2                	ld	s1,8(sp)
    8000149e:	6105                	addi	sp,sp,32
    800014a0:	8082                	ret

00000000800014a2 <growproc>:
int growproc(int n) {
    800014a2:	1101                	addi	sp,sp,-32
    800014a4:	ec06                	sd	ra,24(sp)
    800014a6:	e822                	sd	s0,16(sp)
    800014a8:	e426                	sd	s1,8(sp)
    800014aa:	e04a                	sd	s2,0(sp)
    800014ac:	1000                	addi	s0,sp,32
    800014ae:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800014b0:	00000097          	auipc	ra,0x0
    800014b4:	c98080e7          	jalr	-872(ra) # 80001148 <myproc>
    800014b8:	84aa                	mv	s1,a0
  sz = p->sz;
    800014ba:	652c                	ld	a1,72(a0)
  if (n > 0) {
    800014bc:	01204c63          	bgtz	s2,800014d4 <growproc+0x32>
  } else if (n < 0) {
    800014c0:	02094663          	bltz	s2,800014ec <growproc+0x4a>
  p->sz = sz;
    800014c4:	e4ac                	sd	a1,72(s1)
  return 0;
    800014c6:	4501                	li	a0,0
}
    800014c8:	60e2                	ld	ra,24(sp)
    800014ca:	6442                	ld	s0,16(sp)
    800014cc:	64a2                	ld	s1,8(sp)
    800014ce:	6902                	ld	s2,0(sp)
    800014d0:	6105                	addi	sp,sp,32
    800014d2:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800014d4:	4691                	li	a3,4
    800014d6:	00b90633          	add	a2,s2,a1
    800014da:	6928                	ld	a0,80(a0)
    800014dc:	fffff097          	auipc	ra,0xfffff
    800014e0:	5f6080e7          	jalr	1526(ra) # 80000ad2 <uvmalloc>
    800014e4:	85aa                	mv	a1,a0
    800014e6:	fd79                	bnez	a0,800014c4 <growproc+0x22>
      return -1;
    800014e8:	557d                	li	a0,-1
    800014ea:	bff9                	j	800014c8 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800014ec:	00b90633          	add	a2,s2,a1
    800014f0:	6928                	ld	a0,80(a0)
    800014f2:	fffff097          	auipc	ra,0xfffff
    800014f6:	598080e7          	jalr	1432(ra) # 80000a8a <uvmdealloc>
    800014fa:	85aa                	mv	a1,a0
    800014fc:	b7e1                	j	800014c4 <growproc+0x22>

00000000800014fe <fork>:
int fork(void) {
    800014fe:	7139                	addi	sp,sp,-64
    80001500:	fc06                	sd	ra,56(sp)
    80001502:	f822                	sd	s0,48(sp)
    80001504:	f426                	sd	s1,40(sp)
    80001506:	f04a                	sd	s2,32(sp)
    80001508:	ec4e                	sd	s3,24(sp)
    8000150a:	e852                	sd	s4,16(sp)
    8000150c:	e456                	sd	s5,8(sp)
    8000150e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001510:	00000097          	auipc	ra,0x0
    80001514:	c38080e7          	jalr	-968(ra) # 80001148 <myproc>
    80001518:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    8000151a:	00000097          	auipc	ra,0x0
    8000151e:	e38080e7          	jalr	-456(ra) # 80001352 <allocproc>
    80001522:	10050c63          	beqz	a0,8000163a <fork+0x13c>
    80001526:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001528:	048ab603          	ld	a2,72(s5)
    8000152c:	692c                	ld	a1,80(a0)
    8000152e:	050ab503          	ld	a0,80(s5)
    80001532:	fffff097          	auipc	ra,0xfffff
    80001536:	6f8080e7          	jalr	1784(ra) # 80000c2a <uvmcopy>
    8000153a:	04054863          	bltz	a0,8000158a <fork+0x8c>
  np->sz = p->sz;
    8000153e:	048ab783          	ld	a5,72(s5)
    80001542:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001546:	058ab683          	ld	a3,88(s5)
    8000154a:	87b6                	mv	a5,a3
    8000154c:	058a3703          	ld	a4,88(s4)
    80001550:	12068693          	addi	a3,a3,288
    80001554:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001558:	6788                	ld	a0,8(a5)
    8000155a:	6b8c                	ld	a1,16(a5)
    8000155c:	6f90                	ld	a2,24(a5)
    8000155e:	01073023          	sd	a6,0(a4)
    80001562:	e708                	sd	a0,8(a4)
    80001564:	eb0c                	sd	a1,16(a4)
    80001566:	ef10                	sd	a2,24(a4)
    80001568:	02078793          	addi	a5,a5,32
    8000156c:	02070713          	addi	a4,a4,32
    80001570:	fed792e3          	bne	a5,a3,80001554 <fork+0x56>
  np->trapframe->a0 = 0;
    80001574:	058a3783          	ld	a5,88(s4)
    80001578:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    8000157c:	0d0a8493          	addi	s1,s5,208
    80001580:	0d0a0913          	addi	s2,s4,208
    80001584:	150a8993          	addi	s3,s5,336
    80001588:	a00d                	j	800015aa <fork+0xac>
    freeproc(np);
    8000158a:	8552                	mv	a0,s4
    8000158c:	00000097          	auipc	ra,0x0
    80001590:	d6e080e7          	jalr	-658(ra) # 800012fa <freeproc>
    release(&np->lock);
    80001594:	8552                	mv	a0,s4
    80001596:	00005097          	auipc	ra,0x5
    8000159a:	f82080e7          	jalr	-126(ra) # 80006518 <release>
    return -1;
    8000159e:	597d                	li	s2,-1
    800015a0:	a059                	j	80001626 <fork+0x128>
  for (i = 0; i < NOFILE; i++)
    800015a2:	04a1                	addi	s1,s1,8
    800015a4:	0921                	addi	s2,s2,8
    800015a6:	01348b63          	beq	s1,s3,800015bc <fork+0xbe>
    if (p->ofile[i]) np->ofile[i] = filedup(p->ofile[i]);
    800015aa:	6088                	ld	a0,0(s1)
    800015ac:	d97d                	beqz	a0,800015a2 <fork+0xa4>
    800015ae:	00002097          	auipc	ra,0x2
    800015b2:	6f4080e7          	jalr	1780(ra) # 80003ca2 <filedup>
    800015b6:	00a93023          	sd	a0,0(s2)
    800015ba:	b7e5                	j	800015a2 <fork+0xa4>
  np->cwd = idup(p->cwd);
    800015bc:	150ab503          	ld	a0,336(s5)
    800015c0:	00002097          	auipc	ra,0x2
    800015c4:	862080e7          	jalr	-1950(ra) # 80002e22 <idup>
    800015c8:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800015cc:	4641                	li	a2,16
    800015ce:	158a8593          	addi	a1,s5,344
    800015d2:	158a0513          	addi	a0,s4,344
    800015d6:	fffff097          	auipc	ra,0xfffff
    800015da:	cee080e7          	jalr	-786(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    800015de:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800015e2:	8552                	mv	a0,s4
    800015e4:	00005097          	auipc	ra,0x5
    800015e8:	f34080e7          	jalr	-204(ra) # 80006518 <release>
  acquire(&wait_lock);
    800015ec:	0008f497          	auipc	s1,0x8f
    800015f0:	32448493          	addi	s1,s1,804 # 80090910 <wait_lock>
    800015f4:	8526                	mv	a0,s1
    800015f6:	00005097          	auipc	ra,0x5
    800015fa:	e6e080e7          	jalr	-402(ra) # 80006464 <acquire>
  np->parent = p;
    800015fe:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001602:	8526                	mv	a0,s1
    80001604:	00005097          	auipc	ra,0x5
    80001608:	f14080e7          	jalr	-236(ra) # 80006518 <release>
  acquire(&np->lock);
    8000160c:	8552                	mv	a0,s4
    8000160e:	00005097          	auipc	ra,0x5
    80001612:	e56080e7          	jalr	-426(ra) # 80006464 <acquire>
  np->state = RUNNABLE;
    80001616:	478d                	li	a5,3
    80001618:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000161c:	8552                	mv	a0,s4
    8000161e:	00005097          	auipc	ra,0x5
    80001622:	efa080e7          	jalr	-262(ra) # 80006518 <release>
}
    80001626:	854a                	mv	a0,s2
    80001628:	70e2                	ld	ra,56(sp)
    8000162a:	7442                	ld	s0,48(sp)
    8000162c:	74a2                	ld	s1,40(sp)
    8000162e:	7902                	ld	s2,32(sp)
    80001630:	69e2                	ld	s3,24(sp)
    80001632:	6a42                	ld	s4,16(sp)
    80001634:	6aa2                	ld	s5,8(sp)
    80001636:	6121                	addi	sp,sp,64
    80001638:	8082                	ret
    return -1;
    8000163a:	597d                	li	s2,-1
    8000163c:	b7ed                	j	80001626 <fork+0x128>

000000008000163e <scheduler>:
void scheduler(void) {
    8000163e:	7139                	addi	sp,sp,-64
    80001640:	fc06                	sd	ra,56(sp)
    80001642:	f822                	sd	s0,48(sp)
    80001644:	f426                	sd	s1,40(sp)
    80001646:	f04a                	sd	s2,32(sp)
    80001648:	ec4e                	sd	s3,24(sp)
    8000164a:	e852                	sd	s4,16(sp)
    8000164c:	e456                	sd	s5,8(sp)
    8000164e:	e05a                	sd	s6,0(sp)
    80001650:	0080                	addi	s0,sp,64
    80001652:	8792                	mv	a5,tp
  int id = r_tp();
    80001654:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001656:	00779a93          	slli	s5,a5,0x7
    8000165a:	0008f717          	auipc	a4,0x8f
    8000165e:	29e70713          	addi	a4,a4,670 # 800908f8 <pid_lock>
    80001662:	9756                	add	a4,a4,s5
    80001664:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001668:	0008f717          	auipc	a4,0x8f
    8000166c:	2c870713          	addi	a4,a4,712 # 80090930 <cpus+0x8>
    80001670:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE) {
    80001672:	498d                	li	s3,3
        p->state = RUNNING;
    80001674:	4b11                	li	s6,4
        c->proc = p;
    80001676:	079e                	slli	a5,a5,0x7
    80001678:	0008fa17          	auipc	s4,0x8f
    8000167c:	280a0a13          	addi	s4,s4,640 # 800908f8 <pid_lock>
    80001680:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++) {
    80001682:	00095917          	auipc	s2,0x95
    80001686:	0a690913          	addi	s2,s2,166 # 80096728 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000168a:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    8000168e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001692:	10079073          	csrw	sstatus,a5
    80001696:	0008f497          	auipc	s1,0x8f
    8000169a:	69248493          	addi	s1,s1,1682 # 80090d28 <proc>
    8000169e:	a811                	j	800016b2 <scheduler+0x74>
      release(&p->lock);
    800016a0:	8526                	mv	a0,s1
    800016a2:	00005097          	auipc	ra,0x5
    800016a6:	e76080e7          	jalr	-394(ra) # 80006518 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    800016aa:	16848493          	addi	s1,s1,360
    800016ae:	fd248ee3          	beq	s1,s2,8000168a <scheduler+0x4c>
      acquire(&p->lock);
    800016b2:	8526                	mv	a0,s1
    800016b4:	00005097          	auipc	ra,0x5
    800016b8:	db0080e7          	jalr	-592(ra) # 80006464 <acquire>
      if (p->state == RUNNABLE) {
    800016bc:	4c9c                	lw	a5,24(s1)
    800016be:	ff3791e3          	bne	a5,s3,800016a0 <scheduler+0x62>
        p->state = RUNNING;
    800016c2:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800016c6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800016ca:	06048593          	addi	a1,s1,96
    800016ce:	8556                	mv	a0,s5
    800016d0:	00000097          	auipc	ra,0x0
    800016d4:	68a080e7          	jalr	1674(ra) # 80001d5a <swtch>
        c->proc = 0;
    800016d8:	020a3823          	sd	zero,48(s4)
    800016dc:	b7d1                	j	800016a0 <scheduler+0x62>

00000000800016de <sched>:
void sched(void) {
    800016de:	7179                	addi	sp,sp,-48
    800016e0:	f406                	sd	ra,40(sp)
    800016e2:	f022                	sd	s0,32(sp)
    800016e4:	ec26                	sd	s1,24(sp)
    800016e6:	e84a                	sd	s2,16(sp)
    800016e8:	e44e                	sd	s3,8(sp)
    800016ea:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800016ec:	00000097          	auipc	ra,0x0
    800016f0:	a5c080e7          	jalr	-1444(ra) # 80001148 <myproc>
    800016f4:	84aa                	mv	s1,a0
  if (!holding(&p->lock)) panic("sched p->lock");
    800016f6:	00005097          	auipc	ra,0x5
    800016fa:	cf4080e7          	jalr	-780(ra) # 800063ea <holding>
    800016fe:	c93d                	beqz	a0,80001774 <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    80001700:	8792                	mv	a5,tp
  if (mycpu()->noff != 1) panic("sched locks");
    80001702:	2781                	sext.w	a5,a5
    80001704:	079e                	slli	a5,a5,0x7
    80001706:	0008f717          	auipc	a4,0x8f
    8000170a:	1f270713          	addi	a4,a4,498 # 800908f8 <pid_lock>
    8000170e:	97ba                	add	a5,a5,a4
    80001710:	0a87a703          	lw	a4,168(a5)
    80001714:	4785                	li	a5,1
    80001716:	06f71763          	bne	a4,a5,80001784 <sched+0xa6>
  if (p->state == RUNNING) panic("sched running");
    8000171a:	4c98                	lw	a4,24(s1)
    8000171c:	4791                	li	a5,4
    8000171e:	06f70b63          	beq	a4,a5,80001794 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001722:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001726:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("sched interruptible");
    80001728:	efb5                	bnez	a5,800017a4 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    8000172a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000172c:	0008f917          	auipc	s2,0x8f
    80001730:	1cc90913          	addi	s2,s2,460 # 800908f8 <pid_lock>
    80001734:	2781                	sext.w	a5,a5
    80001736:	079e                	slli	a5,a5,0x7
    80001738:	97ca                	add	a5,a5,s2
    8000173a:	0ac7a983          	lw	s3,172(a5)
    8000173e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001740:	2781                	sext.w	a5,a5
    80001742:	079e                	slli	a5,a5,0x7
    80001744:	0008f597          	auipc	a1,0x8f
    80001748:	1ec58593          	addi	a1,a1,492 # 80090930 <cpus+0x8>
    8000174c:	95be                	add	a1,a1,a5
    8000174e:	06048513          	addi	a0,s1,96
    80001752:	00000097          	auipc	ra,0x0
    80001756:	608080e7          	jalr	1544(ra) # 80001d5a <swtch>
    8000175a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000175c:	2781                	sext.w	a5,a5
    8000175e:	079e                	slli	a5,a5,0x7
    80001760:	993e                	add	s2,s2,a5
    80001762:	0b392623          	sw	s3,172(s2)
}
    80001766:	70a2                	ld	ra,40(sp)
    80001768:	7402                	ld	s0,32(sp)
    8000176a:	64e2                	ld	s1,24(sp)
    8000176c:	6942                	ld	s2,16(sp)
    8000176e:	69a2                	ld	s3,8(sp)
    80001770:	6145                	addi	sp,sp,48
    80001772:	8082                	ret
  if (!holding(&p->lock)) panic("sched p->lock");
    80001774:	00007517          	auipc	a0,0x7
    80001778:	9fc50513          	addi	a0,a0,-1540 # 80008170 <etext+0x170>
    8000177c:	00004097          	auipc	ra,0x4
    80001780:	7b0080e7          	jalr	1968(ra) # 80005f2c <panic>
  if (mycpu()->noff != 1) panic("sched locks");
    80001784:	00007517          	auipc	a0,0x7
    80001788:	9fc50513          	addi	a0,a0,-1540 # 80008180 <etext+0x180>
    8000178c:	00004097          	auipc	ra,0x4
    80001790:	7a0080e7          	jalr	1952(ra) # 80005f2c <panic>
  if (p->state == RUNNING) panic("sched running");
    80001794:	00007517          	auipc	a0,0x7
    80001798:	9fc50513          	addi	a0,a0,-1540 # 80008190 <etext+0x190>
    8000179c:	00004097          	auipc	ra,0x4
    800017a0:	790080e7          	jalr	1936(ra) # 80005f2c <panic>
  if (intr_get()) panic("sched interruptible");
    800017a4:	00007517          	auipc	a0,0x7
    800017a8:	9fc50513          	addi	a0,a0,-1540 # 800081a0 <etext+0x1a0>
    800017ac:	00004097          	auipc	ra,0x4
    800017b0:	780080e7          	jalr	1920(ra) # 80005f2c <panic>

00000000800017b4 <yield>:
void yield(void) {
    800017b4:	1101                	addi	sp,sp,-32
    800017b6:	ec06                	sd	ra,24(sp)
    800017b8:	e822                	sd	s0,16(sp)
    800017ba:	e426                	sd	s1,8(sp)
    800017bc:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800017be:	00000097          	auipc	ra,0x0
    800017c2:	98a080e7          	jalr	-1654(ra) # 80001148 <myproc>
    800017c6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017c8:	00005097          	auipc	ra,0x5
    800017cc:	c9c080e7          	jalr	-868(ra) # 80006464 <acquire>
  p->state = RUNNABLE;
    800017d0:	478d                	li	a5,3
    800017d2:	cc9c                	sw	a5,24(s1)
  sched();
    800017d4:	00000097          	auipc	ra,0x0
    800017d8:	f0a080e7          	jalr	-246(ra) # 800016de <sched>
  release(&p->lock);
    800017dc:	8526                	mv	a0,s1
    800017de:	00005097          	auipc	ra,0x5
    800017e2:	d3a080e7          	jalr	-710(ra) # 80006518 <release>
}
    800017e6:	60e2                	ld	ra,24(sp)
    800017e8:	6442                	ld	s0,16(sp)
    800017ea:	64a2                	ld	s1,8(sp)
    800017ec:	6105                	addi	sp,sp,32
    800017ee:	8082                	ret

00000000800017f0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk) {
    800017f0:	7179                	addi	sp,sp,-48
    800017f2:	f406                	sd	ra,40(sp)
    800017f4:	f022                	sd	s0,32(sp)
    800017f6:	ec26                	sd	s1,24(sp)
    800017f8:	e84a                	sd	s2,16(sp)
    800017fa:	e44e                	sd	s3,8(sp)
    800017fc:	1800                	addi	s0,sp,48
    800017fe:	89aa                	mv	s3,a0
    80001800:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001802:	00000097          	auipc	ra,0x0
    80001806:	946080e7          	jalr	-1722(ra) # 80001148 <myproc>
    8000180a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  // DOC: sleeplock1
    8000180c:	00005097          	auipc	ra,0x5
    80001810:	c58080e7          	jalr	-936(ra) # 80006464 <acquire>
  release(lk);
    80001814:	854a                	mv	a0,s2
    80001816:	00005097          	auipc	ra,0x5
    8000181a:	d02080e7          	jalr	-766(ra) # 80006518 <release>

  // Go to sleep.
  p->chan = chan;
    8000181e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001822:	4789                	li	a5,2
    80001824:	cc9c                	sw	a5,24(s1)

  sched();
    80001826:	00000097          	auipc	ra,0x0
    8000182a:	eb8080e7          	jalr	-328(ra) # 800016de <sched>

  // Tidy up.
  p->chan = 0;
    8000182e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001832:	8526                	mv	a0,s1
    80001834:	00005097          	auipc	ra,0x5
    80001838:	ce4080e7          	jalr	-796(ra) # 80006518 <release>
  acquire(lk);
    8000183c:	854a                	mv	a0,s2
    8000183e:	00005097          	auipc	ra,0x5
    80001842:	c26080e7          	jalr	-986(ra) # 80006464 <acquire>
}
    80001846:	70a2                	ld	ra,40(sp)
    80001848:	7402                	ld	s0,32(sp)
    8000184a:	64e2                	ld	s1,24(sp)
    8000184c:	6942                	ld	s2,16(sp)
    8000184e:	69a2                	ld	s3,8(sp)
    80001850:	6145                	addi	sp,sp,48
    80001852:	8082                	ret

0000000080001854 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan) {
    80001854:	7139                	addi	sp,sp,-64
    80001856:	fc06                	sd	ra,56(sp)
    80001858:	f822                	sd	s0,48(sp)
    8000185a:	f426                	sd	s1,40(sp)
    8000185c:	f04a                	sd	s2,32(sp)
    8000185e:	ec4e                	sd	s3,24(sp)
    80001860:	e852                	sd	s4,16(sp)
    80001862:	e456                	sd	s5,8(sp)
    80001864:	0080                	addi	s0,sp,64
    80001866:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001868:	0008f497          	auipc	s1,0x8f
    8000186c:	4c048493          	addi	s1,s1,1216 # 80090d28 <proc>
    if (p != myproc()) {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan) {
    80001870:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001872:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    80001874:	00095917          	auipc	s2,0x95
    80001878:	eb490913          	addi	s2,s2,-332 # 80096728 <tickslock>
    8000187c:	a811                	j	80001890 <wakeup+0x3c>
      }
      release(&p->lock);
    8000187e:	8526                	mv	a0,s1
    80001880:	00005097          	auipc	ra,0x5
    80001884:	c98080e7          	jalr	-872(ra) # 80006518 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001888:	16848493          	addi	s1,s1,360
    8000188c:	03248663          	beq	s1,s2,800018b8 <wakeup+0x64>
    if (p != myproc()) {
    80001890:	00000097          	auipc	ra,0x0
    80001894:	8b8080e7          	jalr	-1864(ra) # 80001148 <myproc>
    80001898:	fea488e3          	beq	s1,a0,80001888 <wakeup+0x34>
      acquire(&p->lock);
    8000189c:	8526                	mv	a0,s1
    8000189e:	00005097          	auipc	ra,0x5
    800018a2:	bc6080e7          	jalr	-1082(ra) # 80006464 <acquire>
      if (p->state == SLEEPING && p->chan == chan) {
    800018a6:	4c9c                	lw	a5,24(s1)
    800018a8:	fd379be3          	bne	a5,s3,8000187e <wakeup+0x2a>
    800018ac:	709c                	ld	a5,32(s1)
    800018ae:	fd4798e3          	bne	a5,s4,8000187e <wakeup+0x2a>
        p->state = RUNNABLE;
    800018b2:	0154ac23          	sw	s5,24(s1)
    800018b6:	b7e1                	j	8000187e <wakeup+0x2a>
    }
  }
}
    800018b8:	70e2                	ld	ra,56(sp)
    800018ba:	7442                	ld	s0,48(sp)
    800018bc:	74a2                	ld	s1,40(sp)
    800018be:	7902                	ld	s2,32(sp)
    800018c0:	69e2                	ld	s3,24(sp)
    800018c2:	6a42                	ld	s4,16(sp)
    800018c4:	6aa2                	ld	s5,8(sp)
    800018c6:	6121                	addi	sp,sp,64
    800018c8:	8082                	ret

00000000800018ca <reparent>:
void reparent(struct proc *p) {
    800018ca:	7179                	addi	sp,sp,-48
    800018cc:	f406                	sd	ra,40(sp)
    800018ce:	f022                	sd	s0,32(sp)
    800018d0:	ec26                	sd	s1,24(sp)
    800018d2:	e84a                	sd	s2,16(sp)
    800018d4:	e44e                	sd	s3,8(sp)
    800018d6:	e052                	sd	s4,0(sp)
    800018d8:	1800                	addi	s0,sp,48
    800018da:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    800018dc:	0008f497          	auipc	s1,0x8f
    800018e0:	44c48493          	addi	s1,s1,1100 # 80090d28 <proc>
      pp->parent = initproc;
    800018e4:	00007a17          	auipc	s4,0x7
    800018e8:	fbca0a13          	addi	s4,s4,-68 # 800088a0 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    800018ec:	00095997          	auipc	s3,0x95
    800018f0:	e3c98993          	addi	s3,s3,-452 # 80096728 <tickslock>
    800018f4:	a029                	j	800018fe <reparent+0x34>
    800018f6:	16848493          	addi	s1,s1,360
    800018fa:	01348d63          	beq	s1,s3,80001914 <reparent+0x4a>
    if (pp->parent == p) {
    800018fe:	7c9c                	ld	a5,56(s1)
    80001900:	ff279be3          	bne	a5,s2,800018f6 <reparent+0x2c>
      pp->parent = initproc;
    80001904:	000a3503          	ld	a0,0(s4)
    80001908:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000190a:	00000097          	auipc	ra,0x0
    8000190e:	f4a080e7          	jalr	-182(ra) # 80001854 <wakeup>
    80001912:	b7d5                	j	800018f6 <reparent+0x2c>
}
    80001914:	70a2                	ld	ra,40(sp)
    80001916:	7402                	ld	s0,32(sp)
    80001918:	64e2                	ld	s1,24(sp)
    8000191a:	6942                	ld	s2,16(sp)
    8000191c:	69a2                	ld	s3,8(sp)
    8000191e:	6a02                	ld	s4,0(sp)
    80001920:	6145                	addi	sp,sp,48
    80001922:	8082                	ret

0000000080001924 <exit>:
void exit(int status) {
    80001924:	7179                	addi	sp,sp,-48
    80001926:	f406                	sd	ra,40(sp)
    80001928:	f022                	sd	s0,32(sp)
    8000192a:	ec26                	sd	s1,24(sp)
    8000192c:	e84a                	sd	s2,16(sp)
    8000192e:	e44e                	sd	s3,8(sp)
    80001930:	e052                	sd	s4,0(sp)
    80001932:	1800                	addi	s0,sp,48
    80001934:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001936:	00000097          	auipc	ra,0x0
    8000193a:	812080e7          	jalr	-2030(ra) # 80001148 <myproc>
    8000193e:	89aa                	mv	s3,a0
  if (p == initproc) panic("init exiting");
    80001940:	00007797          	auipc	a5,0x7
    80001944:	f607b783          	ld	a5,-160(a5) # 800088a0 <initproc>
    80001948:	0d050493          	addi	s1,a0,208
    8000194c:	15050913          	addi	s2,a0,336
    80001950:	02a79363          	bne	a5,a0,80001976 <exit+0x52>
    80001954:	00007517          	auipc	a0,0x7
    80001958:	86450513          	addi	a0,a0,-1948 # 800081b8 <etext+0x1b8>
    8000195c:	00004097          	auipc	ra,0x4
    80001960:	5d0080e7          	jalr	1488(ra) # 80005f2c <panic>
      fileclose(f);
    80001964:	00002097          	auipc	ra,0x2
    80001968:	390080e7          	jalr	912(ra) # 80003cf4 <fileclose>
      p->ofile[fd] = 0;
    8000196c:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    80001970:	04a1                	addi	s1,s1,8
    80001972:	01248563          	beq	s1,s2,8000197c <exit+0x58>
    if (p->ofile[fd]) {
    80001976:	6088                	ld	a0,0(s1)
    80001978:	f575                	bnez	a0,80001964 <exit+0x40>
    8000197a:	bfdd                	j	80001970 <exit+0x4c>
  begin_op();
    8000197c:	00002097          	auipc	ra,0x2
    80001980:	eb0080e7          	jalr	-336(ra) # 8000382c <begin_op>
  iput(p->cwd);
    80001984:	1509b503          	ld	a0,336(s3)
    80001988:	00001097          	auipc	ra,0x1
    8000198c:	692080e7          	jalr	1682(ra) # 8000301a <iput>
  end_op();
    80001990:	00002097          	auipc	ra,0x2
    80001994:	f1a080e7          	jalr	-230(ra) # 800038aa <end_op>
  p->cwd = 0;
    80001998:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000199c:	0008f497          	auipc	s1,0x8f
    800019a0:	f7448493          	addi	s1,s1,-140 # 80090910 <wait_lock>
    800019a4:	8526                	mv	a0,s1
    800019a6:	00005097          	auipc	ra,0x5
    800019aa:	abe080e7          	jalr	-1346(ra) # 80006464 <acquire>
  reparent(p);
    800019ae:	854e                	mv	a0,s3
    800019b0:	00000097          	auipc	ra,0x0
    800019b4:	f1a080e7          	jalr	-230(ra) # 800018ca <reparent>
  wakeup(p->parent);
    800019b8:	0389b503          	ld	a0,56(s3)
    800019bc:	00000097          	auipc	ra,0x0
    800019c0:	e98080e7          	jalr	-360(ra) # 80001854 <wakeup>
  acquire(&p->lock);
    800019c4:	854e                	mv	a0,s3
    800019c6:	00005097          	auipc	ra,0x5
    800019ca:	a9e080e7          	jalr	-1378(ra) # 80006464 <acquire>
  p->xstate = status;
    800019ce:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800019d2:	4795                	li	a5,5
    800019d4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800019d8:	8526                	mv	a0,s1
    800019da:	00005097          	auipc	ra,0x5
    800019de:	b3e080e7          	jalr	-1218(ra) # 80006518 <release>
  sched();
    800019e2:	00000097          	auipc	ra,0x0
    800019e6:	cfc080e7          	jalr	-772(ra) # 800016de <sched>
  panic("zombie exit");
    800019ea:	00006517          	auipc	a0,0x6
    800019ee:	7de50513          	addi	a0,a0,2014 # 800081c8 <etext+0x1c8>
    800019f2:	00004097          	auipc	ra,0x4
    800019f6:	53a080e7          	jalr	1338(ra) # 80005f2c <panic>

00000000800019fa <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid) {
    800019fa:	7179                	addi	sp,sp,-48
    800019fc:	f406                	sd	ra,40(sp)
    800019fe:	f022                	sd	s0,32(sp)
    80001a00:	ec26                	sd	s1,24(sp)
    80001a02:	e84a                	sd	s2,16(sp)
    80001a04:	e44e                	sd	s3,8(sp)
    80001a06:	1800                	addi	s0,sp,48
    80001a08:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001a0a:	0008f497          	auipc	s1,0x8f
    80001a0e:	31e48493          	addi	s1,s1,798 # 80090d28 <proc>
    80001a12:	00095997          	auipc	s3,0x95
    80001a16:	d1698993          	addi	s3,s3,-746 # 80096728 <tickslock>
    acquire(&p->lock);
    80001a1a:	8526                	mv	a0,s1
    80001a1c:	00005097          	auipc	ra,0x5
    80001a20:	a48080e7          	jalr	-1464(ra) # 80006464 <acquire>
    if (p->pid == pid) {
    80001a24:	589c                	lw	a5,48(s1)
    80001a26:	01278d63          	beq	a5,s2,80001a40 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a2a:	8526                	mv	a0,s1
    80001a2c:	00005097          	auipc	ra,0x5
    80001a30:	aec080e7          	jalr	-1300(ra) # 80006518 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001a34:	16848493          	addi	s1,s1,360
    80001a38:	ff3491e3          	bne	s1,s3,80001a1a <kill+0x20>
  }
  return -1;
    80001a3c:	557d                	li	a0,-1
    80001a3e:	a829                	j	80001a58 <kill+0x5e>
      p->killed = 1;
    80001a40:	4785                	li	a5,1
    80001a42:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    80001a44:	4c98                	lw	a4,24(s1)
    80001a46:	4789                	li	a5,2
    80001a48:	00f70f63          	beq	a4,a5,80001a66 <kill+0x6c>
      release(&p->lock);
    80001a4c:	8526                	mv	a0,s1
    80001a4e:	00005097          	auipc	ra,0x5
    80001a52:	aca080e7          	jalr	-1334(ra) # 80006518 <release>
      return 0;
    80001a56:	4501                	li	a0,0
}
    80001a58:	70a2                	ld	ra,40(sp)
    80001a5a:	7402                	ld	s0,32(sp)
    80001a5c:	64e2                	ld	s1,24(sp)
    80001a5e:	6942                	ld	s2,16(sp)
    80001a60:	69a2                	ld	s3,8(sp)
    80001a62:	6145                	addi	sp,sp,48
    80001a64:	8082                	ret
        p->state = RUNNABLE;
    80001a66:	478d                	li	a5,3
    80001a68:	cc9c                	sw	a5,24(s1)
    80001a6a:	b7cd                	j	80001a4c <kill+0x52>

0000000080001a6c <setkilled>:

void setkilled(struct proc *p) {
    80001a6c:	1101                	addi	sp,sp,-32
    80001a6e:	ec06                	sd	ra,24(sp)
    80001a70:	e822                	sd	s0,16(sp)
    80001a72:	e426                	sd	s1,8(sp)
    80001a74:	1000                	addi	s0,sp,32
    80001a76:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001a78:	00005097          	auipc	ra,0x5
    80001a7c:	9ec080e7          	jalr	-1556(ra) # 80006464 <acquire>
  p->killed = 1;
    80001a80:	4785                	li	a5,1
    80001a82:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001a84:	8526                	mv	a0,s1
    80001a86:	00005097          	auipc	ra,0x5
    80001a8a:	a92080e7          	jalr	-1390(ra) # 80006518 <release>
}
    80001a8e:	60e2                	ld	ra,24(sp)
    80001a90:	6442                	ld	s0,16(sp)
    80001a92:	64a2                	ld	s1,8(sp)
    80001a94:	6105                	addi	sp,sp,32
    80001a96:	8082                	ret

0000000080001a98 <killed>:

int killed(struct proc *p) {
    80001a98:	1101                	addi	sp,sp,-32
    80001a9a:	ec06                	sd	ra,24(sp)
    80001a9c:	e822                	sd	s0,16(sp)
    80001a9e:	e426                	sd	s1,8(sp)
    80001aa0:	e04a                	sd	s2,0(sp)
    80001aa2:	1000                	addi	s0,sp,32
    80001aa4:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80001aa6:	00005097          	auipc	ra,0x5
    80001aaa:	9be080e7          	jalr	-1602(ra) # 80006464 <acquire>
  k = p->killed;
    80001aae:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001ab2:	8526                	mv	a0,s1
    80001ab4:	00005097          	auipc	ra,0x5
    80001ab8:	a64080e7          	jalr	-1436(ra) # 80006518 <release>
  return k;
}
    80001abc:	854a                	mv	a0,s2
    80001abe:	60e2                	ld	ra,24(sp)
    80001ac0:	6442                	ld	s0,16(sp)
    80001ac2:	64a2                	ld	s1,8(sp)
    80001ac4:	6902                	ld	s2,0(sp)
    80001ac6:	6105                	addi	sp,sp,32
    80001ac8:	8082                	ret

0000000080001aca <wait>:
int wait(uint64 addr) {
    80001aca:	711d                	addi	sp,sp,-96
    80001acc:	ec86                	sd	ra,88(sp)
    80001ace:	e8a2                	sd	s0,80(sp)
    80001ad0:	e4a6                	sd	s1,72(sp)
    80001ad2:	e0ca                	sd	s2,64(sp)
    80001ad4:	fc4e                	sd	s3,56(sp)
    80001ad6:	f852                	sd	s4,48(sp)
    80001ad8:	f456                	sd	s5,40(sp)
    80001ada:	f05a                	sd	s6,32(sp)
    80001adc:	ec5e                	sd	s7,24(sp)
    80001ade:	e862                	sd	s8,16(sp)
    80001ae0:	1080                	addi	s0,sp,96
    80001ae2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001ae4:	fffff097          	auipc	ra,0xfffff
    80001ae8:	664080e7          	jalr	1636(ra) # 80001148 <myproc>
    80001aec:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001aee:	0008f517          	auipc	a0,0x8f
    80001af2:	e2250513          	addi	a0,a0,-478 # 80090910 <wait_lock>
    80001af6:	00005097          	auipc	ra,0x5
    80001afa:	96e080e7          	jalr	-1682(ra) # 80006464 <acquire>
    havekids = 0;
    80001afe:	4b81                	li	s7,0
        if (pp->state == ZOMBIE) {
    80001b00:	4a15                	li	s4,5
        havekids = 1;
    80001b02:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001b04:	00095997          	auipc	s3,0x95
    80001b08:	c2498993          	addi	s3,s3,-988 # 80096728 <tickslock>
    sleep(p, &wait_lock);  // DOC: wait-sleep
    80001b0c:	0008fc17          	auipc	s8,0x8f
    80001b10:	e04c0c13          	addi	s8,s8,-508 # 80090910 <wait_lock>
    havekids = 0;
    80001b14:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001b16:	0008f497          	auipc	s1,0x8f
    80001b1a:	21248493          	addi	s1,s1,530 # 80090d28 <proc>
    80001b1e:	a895                	j	80001b92 <wait+0xc8>
          pid = pp->pid;
    80001b20:	0304a983          	lw	s3,48(s1)
          int xstate = pp->xstate;
    80001b24:	54dc                	lw	a5,44(s1)
    80001b26:	faf42623          	sw	a5,-84(s0)
          freeproc(pp);
    80001b2a:	8526                	mv	a0,s1
    80001b2c:	fffff097          	auipc	ra,0xfffff
    80001b30:	7ce080e7          	jalr	1998(ra) # 800012fa <freeproc>
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&xstate,
    80001b34:	000b0e63          	beqz	s6,80001b50 <wait+0x86>
    80001b38:	4691                	li	a3,4
    80001b3a:	fac40613          	addi	a2,s0,-84
    80001b3e:	85da                	mv	a1,s6
    80001b40:	05093503          	ld	a0,80(s2)
    80001b44:	fffff097          	auipc	ra,0xfffff
    80001b48:	1ac080e7          	jalr	428(ra) # 80000cf0 <copyout>
    80001b4c:	02054063          	bltz	a0,80001b6c <wait+0xa2>
          release(&pp->lock);
    80001b50:	8526                	mv	a0,s1
    80001b52:	00005097          	auipc	ra,0x5
    80001b56:	9c6080e7          	jalr	-1594(ra) # 80006518 <release>
          release(&wait_lock);
    80001b5a:	0008f517          	auipc	a0,0x8f
    80001b5e:	db650513          	addi	a0,a0,-586 # 80090910 <wait_lock>
    80001b62:	00005097          	auipc	ra,0x5
    80001b66:	9b6080e7          	jalr	-1610(ra) # 80006518 <release>
          return pid;
    80001b6a:	a0b5                	j	80001bd6 <wait+0x10c>
            release(&pp->lock);
    80001b6c:	8526                	mv	a0,s1
    80001b6e:	00005097          	auipc	ra,0x5
    80001b72:	9aa080e7          	jalr	-1622(ra) # 80006518 <release>
            release(&wait_lock);
    80001b76:	0008f517          	auipc	a0,0x8f
    80001b7a:	d9a50513          	addi	a0,a0,-614 # 80090910 <wait_lock>
    80001b7e:	00005097          	auipc	ra,0x5
    80001b82:	99a080e7          	jalr	-1638(ra) # 80006518 <release>
            return -1;
    80001b86:	59fd                	li	s3,-1
    80001b88:	a0b9                	j	80001bd6 <wait+0x10c>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001b8a:	16848493          	addi	s1,s1,360
    80001b8e:	03348463          	beq	s1,s3,80001bb6 <wait+0xec>
      if (pp->parent == p) {
    80001b92:	7c9c                	ld	a5,56(s1)
    80001b94:	ff279be3          	bne	a5,s2,80001b8a <wait+0xc0>
        acquire(&pp->lock);
    80001b98:	8526                	mv	a0,s1
    80001b9a:	00005097          	auipc	ra,0x5
    80001b9e:	8ca080e7          	jalr	-1846(ra) # 80006464 <acquire>
        if (pp->state == ZOMBIE) {
    80001ba2:	4c9c                	lw	a5,24(s1)
    80001ba4:	f7478ee3          	beq	a5,s4,80001b20 <wait+0x56>
        release(&pp->lock);
    80001ba8:	8526                	mv	a0,s1
    80001baa:	00005097          	auipc	ra,0x5
    80001bae:	96e080e7          	jalr	-1682(ra) # 80006518 <release>
        havekids = 1;
    80001bb2:	8756                	mv	a4,s5
    80001bb4:	bfd9                	j	80001b8a <wait+0xc0>
    if (!havekids || killed(p)) {
    80001bb6:	c719                	beqz	a4,80001bc4 <wait+0xfa>
    80001bb8:	854a                	mv	a0,s2
    80001bba:	00000097          	auipc	ra,0x0
    80001bbe:	ede080e7          	jalr	-290(ra) # 80001a98 <killed>
    80001bc2:	c51d                	beqz	a0,80001bf0 <wait+0x126>
      release(&wait_lock);
    80001bc4:	0008f517          	auipc	a0,0x8f
    80001bc8:	d4c50513          	addi	a0,a0,-692 # 80090910 <wait_lock>
    80001bcc:	00005097          	auipc	ra,0x5
    80001bd0:	94c080e7          	jalr	-1716(ra) # 80006518 <release>
      return -1;
    80001bd4:	59fd                	li	s3,-1
}
    80001bd6:	854e                	mv	a0,s3
    80001bd8:	60e6                	ld	ra,88(sp)
    80001bda:	6446                	ld	s0,80(sp)
    80001bdc:	64a6                	ld	s1,72(sp)
    80001bde:	6906                	ld	s2,64(sp)
    80001be0:	79e2                	ld	s3,56(sp)
    80001be2:	7a42                	ld	s4,48(sp)
    80001be4:	7aa2                	ld	s5,40(sp)
    80001be6:	7b02                	ld	s6,32(sp)
    80001be8:	6be2                	ld	s7,24(sp)
    80001bea:	6c42                	ld	s8,16(sp)
    80001bec:	6125                	addi	sp,sp,96
    80001bee:	8082                	ret
    sleep(p, &wait_lock);  // DOC: wait-sleep
    80001bf0:	85e2                	mv	a1,s8
    80001bf2:	854a                	mv	a0,s2
    80001bf4:	00000097          	auipc	ra,0x0
    80001bf8:	bfc080e7          	jalr	-1028(ra) # 800017f0 <sleep>
    havekids = 0;
    80001bfc:	bf21                	j	80001b14 <wait+0x4a>

0000000080001bfe <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len) {
    80001bfe:	7179                	addi	sp,sp,-48
    80001c00:	f406                	sd	ra,40(sp)
    80001c02:	f022                	sd	s0,32(sp)
    80001c04:	ec26                	sd	s1,24(sp)
    80001c06:	e84a                	sd	s2,16(sp)
    80001c08:	e44e                	sd	s3,8(sp)
    80001c0a:	e052                	sd	s4,0(sp)
    80001c0c:	1800                	addi	s0,sp,48
    80001c0e:	84aa                	mv	s1,a0
    80001c10:	892e                	mv	s2,a1
    80001c12:	89b2                	mv	s3,a2
    80001c14:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001c16:	fffff097          	auipc	ra,0xfffff
    80001c1a:	532080e7          	jalr	1330(ra) # 80001148 <myproc>
  if (user_dst) {
    80001c1e:	c08d                	beqz	s1,80001c40 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001c20:	86d2                	mv	a3,s4
    80001c22:	864e                	mv	a2,s3
    80001c24:	85ca                	mv	a1,s2
    80001c26:	6928                	ld	a0,80(a0)
    80001c28:	fffff097          	auipc	ra,0xfffff
    80001c2c:	0c8080e7          	jalr	200(ra) # 80000cf0 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001c30:	70a2                	ld	ra,40(sp)
    80001c32:	7402                	ld	s0,32(sp)
    80001c34:	64e2                	ld	s1,24(sp)
    80001c36:	6942                	ld	s2,16(sp)
    80001c38:	69a2                	ld	s3,8(sp)
    80001c3a:	6a02                	ld	s4,0(sp)
    80001c3c:	6145                	addi	sp,sp,48
    80001c3e:	8082                	ret
    memmove((char *)dst, src, len);
    80001c40:	000a061b          	sext.w	a2,s4
    80001c44:	85ce                	mv	a1,s3
    80001c46:	854a                	mv	a0,s2
    80001c48:	ffffe097          	auipc	ra,0xffffe
    80001c4c:	58e080e7          	jalr	1422(ra) # 800001d6 <memmove>
    return 0;
    80001c50:	8526                	mv	a0,s1
    80001c52:	bff9                	j	80001c30 <either_copyout+0x32>

0000000080001c54 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len) {
    80001c54:	7179                	addi	sp,sp,-48
    80001c56:	f406                	sd	ra,40(sp)
    80001c58:	f022                	sd	s0,32(sp)
    80001c5a:	ec26                	sd	s1,24(sp)
    80001c5c:	e84a                	sd	s2,16(sp)
    80001c5e:	e44e                	sd	s3,8(sp)
    80001c60:	e052                	sd	s4,0(sp)
    80001c62:	1800                	addi	s0,sp,48
    80001c64:	892a                	mv	s2,a0
    80001c66:	84ae                	mv	s1,a1
    80001c68:	89b2                	mv	s3,a2
    80001c6a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001c6c:	fffff097          	auipc	ra,0xfffff
    80001c70:	4dc080e7          	jalr	1244(ra) # 80001148 <myproc>
  if (user_src) {
    80001c74:	c08d                	beqz	s1,80001c96 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001c76:	86d2                	mv	a3,s4
    80001c78:	864e                	mv	a2,s3
    80001c7a:	85ca                	mv	a1,s2
    80001c7c:	6928                	ld	a0,80(a0)
    80001c7e:	fffff097          	auipc	ra,0xfffff
    80001c82:	11a080e7          	jalr	282(ra) # 80000d98 <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80001c86:	70a2                	ld	ra,40(sp)
    80001c88:	7402                	ld	s0,32(sp)
    80001c8a:	64e2                	ld	s1,24(sp)
    80001c8c:	6942                	ld	s2,16(sp)
    80001c8e:	69a2                	ld	s3,8(sp)
    80001c90:	6a02                	ld	s4,0(sp)
    80001c92:	6145                	addi	sp,sp,48
    80001c94:	8082                	ret
    memmove(dst, (char *)src, len);
    80001c96:	000a061b          	sext.w	a2,s4
    80001c9a:	85ce                	mv	a1,s3
    80001c9c:	854a                	mv	a0,s2
    80001c9e:	ffffe097          	auipc	ra,0xffffe
    80001ca2:	538080e7          	jalr	1336(ra) # 800001d6 <memmove>
    return 0;
    80001ca6:	8526                	mv	a0,s1
    80001ca8:	bff9                	j	80001c86 <either_copyin+0x32>

0000000080001caa <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
    80001caa:	715d                	addi	sp,sp,-80
    80001cac:	e486                	sd	ra,72(sp)
    80001cae:	e0a2                	sd	s0,64(sp)
    80001cb0:	fc26                	sd	s1,56(sp)
    80001cb2:	f84a                	sd	s2,48(sp)
    80001cb4:	f44e                	sd	s3,40(sp)
    80001cb6:	f052                	sd	s4,32(sp)
    80001cb8:	ec56                	sd	s5,24(sp)
    80001cba:	e85a                	sd	s6,16(sp)
    80001cbc:	e45e                	sd	s7,8(sp)
    80001cbe:	0880                	addi	s0,sp,80
      [UNUSED] "unused",   [USED] "used",      [SLEEPING] "sleep ",
      [RUNNABLE] "runble", [RUNNING] "run   ", [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80001cc0:	00006517          	auipc	a0,0x6
    80001cc4:	38850513          	addi	a0,a0,904 # 80008048 <etext+0x48>
    80001cc8:	00004097          	auipc	ra,0x4
    80001ccc:	2ae080e7          	jalr	686(ra) # 80005f76 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001cd0:	0008f497          	auipc	s1,0x8f
    80001cd4:	1b048493          	addi	s1,s1,432 # 80090e80 <proc+0x158>
    80001cd8:	00095917          	auipc	s2,0x95
    80001cdc:	ba890913          	addi	s2,s2,-1112 # 80096880 <bcache+0x140>
    if (p->state == UNUSED) continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ce0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001ce2:	00006997          	auipc	s3,0x6
    80001ce6:	4f698993          	addi	s3,s3,1270 # 800081d8 <etext+0x1d8>
    printf("%d %s %s", p->pid, state, p->name);
    80001cea:	00006a97          	auipc	s5,0x6
    80001cee:	4f6a8a93          	addi	s5,s5,1270 # 800081e0 <etext+0x1e0>
    printf("\n");
    80001cf2:	00006a17          	auipc	s4,0x6
    80001cf6:	356a0a13          	addi	s4,s4,854 # 80008048 <etext+0x48>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001cfa:	00006b97          	auipc	s7,0x6
    80001cfe:	526b8b93          	addi	s7,s7,1318 # 80008220 <states.0>
    80001d02:	a00d                	j	80001d24 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001d04:	ed86a583          	lw	a1,-296(a3)
    80001d08:	8556                	mv	a0,s5
    80001d0a:	00004097          	auipc	ra,0x4
    80001d0e:	26c080e7          	jalr	620(ra) # 80005f76 <printf>
    printf("\n");
    80001d12:	8552                	mv	a0,s4
    80001d14:	00004097          	auipc	ra,0x4
    80001d18:	262080e7          	jalr	610(ra) # 80005f76 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001d1c:	16848493          	addi	s1,s1,360
    80001d20:	03248263          	beq	s1,s2,80001d44 <procdump+0x9a>
    if (p->state == UNUSED) continue;
    80001d24:	86a6                	mv	a3,s1
    80001d26:	ec04a783          	lw	a5,-320(s1)
    80001d2a:	dbed                	beqz	a5,80001d1c <procdump+0x72>
      state = "???";
    80001d2c:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001d2e:	fcfb6be3          	bltu	s6,a5,80001d04 <procdump+0x5a>
    80001d32:	02079713          	slli	a4,a5,0x20
    80001d36:	01d75793          	srli	a5,a4,0x1d
    80001d3a:	97de                	add	a5,a5,s7
    80001d3c:	6390                	ld	a2,0(a5)
    80001d3e:	f279                	bnez	a2,80001d04 <procdump+0x5a>
      state = "???";
    80001d40:	864e                	mv	a2,s3
    80001d42:	b7c9                	j	80001d04 <procdump+0x5a>
  }
}
    80001d44:	60a6                	ld	ra,72(sp)
    80001d46:	6406                	ld	s0,64(sp)
    80001d48:	74e2                	ld	s1,56(sp)
    80001d4a:	7942                	ld	s2,48(sp)
    80001d4c:	79a2                	ld	s3,40(sp)
    80001d4e:	7a02                	ld	s4,32(sp)
    80001d50:	6ae2                	ld	s5,24(sp)
    80001d52:	6b42                	ld	s6,16(sp)
    80001d54:	6ba2                	ld	s7,8(sp)
    80001d56:	6161                	addi	sp,sp,80
    80001d58:	8082                	ret

0000000080001d5a <swtch>:
    80001d5a:	00153023          	sd	ra,0(a0)
    80001d5e:	00253423          	sd	sp,8(a0)
    80001d62:	e900                	sd	s0,16(a0)
    80001d64:	ed04                	sd	s1,24(a0)
    80001d66:	03253023          	sd	s2,32(a0)
    80001d6a:	03353423          	sd	s3,40(a0)
    80001d6e:	03453823          	sd	s4,48(a0)
    80001d72:	03553c23          	sd	s5,56(a0)
    80001d76:	05653023          	sd	s6,64(a0)
    80001d7a:	05753423          	sd	s7,72(a0)
    80001d7e:	05853823          	sd	s8,80(a0)
    80001d82:	05953c23          	sd	s9,88(a0)
    80001d86:	07a53023          	sd	s10,96(a0)
    80001d8a:	07b53423          	sd	s11,104(a0)
    80001d8e:	0005b083          	ld	ra,0(a1)
    80001d92:	0085b103          	ld	sp,8(a1)
    80001d96:	6980                	ld	s0,16(a1)
    80001d98:	6d84                	ld	s1,24(a1)
    80001d9a:	0205b903          	ld	s2,32(a1)
    80001d9e:	0285b983          	ld	s3,40(a1)
    80001da2:	0305ba03          	ld	s4,48(a1)
    80001da6:	0385ba83          	ld	s5,56(a1)
    80001daa:	0405bb03          	ld	s6,64(a1)
    80001dae:	0485bb83          	ld	s7,72(a1)
    80001db2:	0505bc03          	ld	s8,80(a1)
    80001db6:	0585bc83          	ld	s9,88(a1)
    80001dba:	0605bd03          	ld	s10,96(a1)
    80001dbe:	0685bd83          	ld	s11,104(a1)
    80001dc2:	8082                	ret

0000000080001dc4 <trapinit>:
// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void trapinit(void) { initlock(&tickslock, "time"); }
    80001dc4:	1141                	addi	sp,sp,-16
    80001dc6:	e406                	sd	ra,8(sp)
    80001dc8:	e022                	sd	s0,0(sp)
    80001dca:	0800                	addi	s0,sp,16
    80001dcc:	00006597          	auipc	a1,0x6
    80001dd0:	48458593          	addi	a1,a1,1156 # 80008250 <states.0+0x30>
    80001dd4:	00095517          	auipc	a0,0x95
    80001dd8:	95450513          	addi	a0,a0,-1708 # 80096728 <tickslock>
    80001ddc:	00004097          	auipc	ra,0x4
    80001de0:	5f8080e7          	jalr	1528(ra) # 800063d4 <initlock>
    80001de4:	60a2                	ld	ra,8(sp)
    80001de6:	6402                	ld	s0,0(sp)
    80001de8:	0141                	addi	sp,sp,16
    80001dea:	8082                	ret

0000000080001dec <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) { w_stvec((uint64)kernelvec); }
    80001dec:	1141                	addi	sp,sp,-16
    80001dee:	e422                	sd	s0,8(sp)
    80001df0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001df2:	00003797          	auipc	a5,0x3
    80001df6:	56e78793          	addi	a5,a5,1390 # 80005360 <kernelvec>
    80001dfa:	10579073          	csrw	stvec,a5
    80001dfe:	6422                	ld	s0,8(sp)
    80001e00:	0141                	addi	sp,sp,16
    80001e02:	8082                	ret

0000000080001e04 <usertrapret>:
}

//
// return to user space
//
void usertrapret(void) {
    80001e04:	1141                	addi	sp,sp,-16
    80001e06:	e406                	sd	ra,8(sp)
    80001e08:	e022                	sd	s0,0(sp)
    80001e0a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001e0c:	fffff097          	auipc	ra,0xfffff
    80001e10:	33c080e7          	jalr	828(ra) # 80001148 <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e14:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80001e18:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001e1a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001e1e:	00005697          	auipc	a3,0x5
    80001e22:	1e268693          	addi	a3,a3,482 # 80007000 <_trampoline>
    80001e26:	00005717          	auipc	a4,0x5
    80001e2a:	1da70713          	addi	a4,a4,474 # 80007000 <_trampoline>
    80001e2e:	8f15                	sub	a4,a4,a3
    80001e30:	040007b7          	lui	a5,0x4000
    80001e34:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001e36:	07b2                	slli	a5,a5,0xc
    80001e38:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001e3a:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();          // kernel page table
    80001e3e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80001e40:	18002673          	csrr	a2,satp
    80001e44:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE;  // process's kernel stack
    80001e46:	6d30                	ld	a2,88(a0)
    80001e48:	6138                	ld	a4,64(a0)
    80001e4a:	6585                	lui	a1,0x1
    80001e4c:	972e                	add	a4,a4,a1
    80001e4e:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001e50:	6d38                	ld	a4,88(a0)
    80001e52:	00000617          	auipc	a2,0x0
    80001e56:	13060613          	addi	a2,a2,304 # 80001f82 <usertrap>
    80001e5a:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();  // hartid for cpuid()
    80001e5c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80001e5e:	8612                	mv	a2,tp
    80001e60:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e62:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP;  // clear SPP to 0 for user mode
    80001e66:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE;  // enable interrupts in user mode
    80001e6a:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001e6e:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001e72:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001e74:	6f18                	ld	a4,24(a4)
    80001e76:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001e7a:	6928                	ld	a0,80(a0)
    80001e7c:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001e7e:	00005717          	auipc	a4,0x5
    80001e82:	21e70713          	addi	a4,a4,542 # 8000709c <userret>
    80001e86:	8f15                	sub	a4,a4,a3
    80001e88:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001e8a:	577d                	li	a4,-1
    80001e8c:	177e                	slli	a4,a4,0x3f
    80001e8e:	8d59                	or	a0,a0,a4
    80001e90:	9782                	jalr	a5
}
    80001e92:	60a2                	ld	ra,8(sp)
    80001e94:	6402                	ld	s0,0(sp)
    80001e96:	0141                	addi	sp,sp,16
    80001e98:	8082                	ret

0000000080001e9a <clockintr>:
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr() {
    80001e9a:	1101                	addi	sp,sp,-32
    80001e9c:	ec06                	sd	ra,24(sp)
    80001e9e:	e822                	sd	s0,16(sp)
    80001ea0:	e426                	sd	s1,8(sp)
    80001ea2:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001ea4:	00095497          	auipc	s1,0x95
    80001ea8:	88448493          	addi	s1,s1,-1916 # 80096728 <tickslock>
    80001eac:	8526                	mv	a0,s1
    80001eae:	00004097          	auipc	ra,0x4
    80001eb2:	5b6080e7          	jalr	1462(ra) # 80006464 <acquire>
  ticks++;
    80001eb6:	00007517          	auipc	a0,0x7
    80001eba:	9f250513          	addi	a0,a0,-1550 # 800088a8 <ticks>
    80001ebe:	411c                	lw	a5,0(a0)
    80001ec0:	2785                	addiw	a5,a5,1
    80001ec2:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001ec4:	00000097          	auipc	ra,0x0
    80001ec8:	990080e7          	jalr	-1648(ra) # 80001854 <wakeup>
  release(&tickslock);
    80001ecc:	8526                	mv	a0,s1
    80001ece:	00004097          	auipc	ra,0x4
    80001ed2:	64a080e7          	jalr	1610(ra) # 80006518 <release>
}
    80001ed6:	60e2                	ld	ra,24(sp)
    80001ed8:	6442                	ld	s0,16(sp)
    80001eda:	64a2                	ld	s1,8(sp)
    80001edc:	6105                	addi	sp,sp,32
    80001ede:	8082                	ret

0000000080001ee0 <devintr>:
// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr() {
    80001ee0:	1101                	addi	sp,sp,-32
    80001ee2:	ec06                	sd	ra,24(sp)
    80001ee4:	e822                	sd	s0,16(sp)
    80001ee6:	e426                	sd	s1,8(sp)
    80001ee8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80001eea:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001eee:	00074d63          	bltz	a4,80001f08 <devintr+0x28>
    // interrupt at a time; tell the PLIC the device is
    // now allowed to interrupt again.
    if (irq) plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000001L) {
    80001ef2:	57fd                	li	a5,-1
    80001ef4:	17fe                	slli	a5,a5,0x3f
    80001ef6:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001ef8:	4501                	li	a0,0
  } else if (scause == 0x8000000000000001L) {
    80001efa:	06f70363          	beq	a4,a5,80001f60 <devintr+0x80>
  }
}
    80001efe:	60e2                	ld	ra,24(sp)
    80001f00:	6442                	ld	s0,16(sp)
    80001f02:	64a2                	ld	s1,8(sp)
    80001f04:	6105                	addi	sp,sp,32
    80001f06:	8082                	ret
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001f08:	0ff77793          	zext.b	a5,a4
    80001f0c:	46a5                	li	a3,9
    80001f0e:	fed792e3          	bne	a5,a3,80001ef2 <devintr+0x12>
    int irq = plic_claim();
    80001f12:	00003097          	auipc	ra,0x3
    80001f16:	556080e7          	jalr	1366(ra) # 80005468 <plic_claim>
    80001f1a:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80001f1c:	47a9                	li	a5,10
    80001f1e:	02f50763          	beq	a0,a5,80001f4c <devintr+0x6c>
    } else if (irq == VIRTIO0_IRQ) {
    80001f22:	4785                	li	a5,1
    80001f24:	02f50963          	beq	a0,a5,80001f56 <devintr+0x76>
    return 1;
    80001f28:	4505                	li	a0,1
    } else if (irq) {
    80001f2a:	d8f1                	beqz	s1,80001efe <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001f2c:	85a6                	mv	a1,s1
    80001f2e:	00006517          	auipc	a0,0x6
    80001f32:	32a50513          	addi	a0,a0,810 # 80008258 <states.0+0x38>
    80001f36:	00004097          	auipc	ra,0x4
    80001f3a:	040080e7          	jalr	64(ra) # 80005f76 <printf>
    if (irq) plic_complete(irq);
    80001f3e:	8526                	mv	a0,s1
    80001f40:	00003097          	auipc	ra,0x3
    80001f44:	54c080e7          	jalr	1356(ra) # 8000548c <plic_complete>
    return 1;
    80001f48:	4505                	li	a0,1
    80001f4a:	bf55                	j	80001efe <devintr+0x1e>
      uartintr();
    80001f4c:	00004097          	auipc	ra,0x4
    80001f50:	438080e7          	jalr	1080(ra) # 80006384 <uartintr>
    80001f54:	b7ed                	j	80001f3e <devintr+0x5e>
      virtio_disk_intr();
    80001f56:	00004097          	auipc	ra,0x4
    80001f5a:	9fe080e7          	jalr	-1538(ra) # 80005954 <virtio_disk_intr>
    80001f5e:	b7c5                	j	80001f3e <devintr+0x5e>
    if (cpuid() == 0) {
    80001f60:	fffff097          	auipc	ra,0xfffff
    80001f64:	1bc080e7          	jalr	444(ra) # 8000111c <cpuid>
    80001f68:	c901                	beqz	a0,80001f78 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r"(x));
    80001f6a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001f6e:	9bf5                	andi	a5,a5,-3
static inline void w_sip(uint64 x) { asm volatile("csrw sip, %0" : : "r"(x)); }
    80001f70:	14479073          	csrw	sip,a5
    return 2;
    80001f74:	4509                	li	a0,2
    80001f76:	b761                	j	80001efe <devintr+0x1e>
      clockintr();
    80001f78:	00000097          	auipc	ra,0x0
    80001f7c:	f22080e7          	jalr	-222(ra) # 80001e9a <clockintr>
    80001f80:	b7ed                	j	80001f6a <devintr+0x8a>

0000000080001f82 <usertrap>:
void usertrap(void) {
    80001f82:	1101                	addi	sp,sp,-32
    80001f84:	ec06                	sd	ra,24(sp)
    80001f86:	e822                	sd	s0,16(sp)
    80001f88:	e426                	sd	s1,8(sp)
    80001f8a:	e04a                	sd	s2,0(sp)
    80001f8c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001f8e:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80001f92:	1007f793          	andi	a5,a5,256
    80001f96:	ebc9                	bnez	a5,80002028 <usertrap+0xa6>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001f98:	00003797          	auipc	a5,0x3
    80001f9c:	3c878793          	addi	a5,a5,968 # 80005360 <kernelvec>
    80001fa0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001fa4:	fffff097          	auipc	ra,0xfffff
    80001fa8:	1a4080e7          	jalr	420(ra) # 80001148 <myproc>
    80001fac:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001fae:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001fb0:	14102773          	csrr	a4,sepc
    80001fb4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80001fb6:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80001fba:	47a1                	li	a5,8
    80001fbc:	06f70e63          	beq	a4,a5,80002038 <usertrap+0xb6>
    80001fc0:	14202773          	csrr	a4,scause
  } else if (r_scause() == 13 || r_scause() == 15) {
    80001fc4:	47b5                	li	a5,13
    80001fc6:	00f70763          	beq	a4,a5,80001fd4 <usertrap+0x52>
    80001fca:	14202773          	csrr	a4,scause
    80001fce:	47bd                	li	a5,15
    80001fd0:	0af71463          	bne	a4,a5,80002078 <usertrap+0xf6>
  asm volatile("csrr %0, stval" : "=r"(x));
    80001fd4:	14302973          	csrr	s2,stval
    uint64 va = PGROUNDDOWN(r_stval());
    80001fd8:	77fd                	lui	a5,0xfffff
    80001fda:	00f97933          	and	s2,s2,a5
    if ((walkaddr(p->pagetable, va) != 0 || lalloc(va, p) == 0) &&
    80001fde:	85ca                	mv	a1,s2
    80001fe0:	68a8                	ld	a0,80(s1)
    80001fe2:	ffffe097          	auipc	ra,0xffffe
    80001fe6:	554080e7          	jalr	1364(ra) # 80000536 <walkaddr>
    80001fea:	e901                	bnez	a0,80001ffa <usertrap+0x78>
    80001fec:	85a6                	mv	a1,s1
    80001fee:	854a                	mv	a0,s2
    80001ff0:	ffffe097          	auipc	ra,0xffffe
    80001ff4:	662080e7          	jalr	1634(ra) # 80000652 <lalloc>
    80001ff8:	e901                	bnez	a0,80002008 <usertrap+0x86>
        cow(va, p->pagetable) != 0) {
    80001ffa:	68ac                	ld	a1,80(s1)
    80001ffc:	854a                	mv	a0,s2
    80001ffe:	fffff097          	auipc	ra,0xfffff
    80002002:	8ee080e7          	jalr	-1810(ra) # 800008ec <cow>
    if ((walkaddr(p->pagetable, va) != 0 || lalloc(va, p) == 0) &&
    80002006:	e13d                	bnez	a0,8000206c <usertrap+0xea>
  if (killed(p)) exit(-1);
    80002008:	8526                	mv	a0,s1
    8000200a:	00000097          	auipc	ra,0x0
    8000200e:	a8e080e7          	jalr	-1394(ra) # 80001a98 <killed>
    80002012:	ed4d                	bnez	a0,800020cc <usertrap+0x14a>
  usertrapret();
    80002014:	00000097          	auipc	ra,0x0
    80002018:	df0080e7          	jalr	-528(ra) # 80001e04 <usertrapret>
}
    8000201c:	60e2                	ld	ra,24(sp)
    8000201e:	6442                	ld	s0,16(sp)
    80002020:	64a2                	ld	s1,8(sp)
    80002022:	6902                	ld	s2,0(sp)
    80002024:	6105                	addi	sp,sp,32
    80002026:	8082                	ret
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80002028:	00006517          	auipc	a0,0x6
    8000202c:	25050513          	addi	a0,a0,592 # 80008278 <states.0+0x58>
    80002030:	00004097          	auipc	ra,0x4
    80002034:	efc080e7          	jalr	-260(ra) # 80005f2c <panic>
    if (killed(p)) exit(-1);
    80002038:	00000097          	auipc	ra,0x0
    8000203c:	a60080e7          	jalr	-1440(ra) # 80001a98 <killed>
    80002040:	e105                	bnez	a0,80002060 <usertrap+0xde>
    p->trapframe->epc += 4;
    80002042:	6cb8                	ld	a4,88(s1)
    80002044:	6f1c                	ld	a5,24(a4)
    80002046:	0791                	addi	a5,a5,4 # fffffffffffff004 <end+0xffffffff7ff552b4>
    80002048:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000204a:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    8000204e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002052:	10079073          	csrw	sstatus,a5
    syscall();
    80002056:	00000097          	auipc	ra,0x0
    8000205a:	2dc080e7          	jalr	732(ra) # 80002332 <syscall>
    8000205e:	b76d                	j	80002008 <usertrap+0x86>
    if (killed(p)) exit(-1);
    80002060:	557d                	li	a0,-1
    80002062:	00000097          	auipc	ra,0x0
    80002066:	8c2080e7          	jalr	-1854(ra) # 80001924 <exit>
    8000206a:	bfe1                	j	80002042 <usertrap+0xc0>
      setkilled(p);
    8000206c:	8526                	mv	a0,s1
    8000206e:	00000097          	auipc	ra,0x0
    80002072:	9fe080e7          	jalr	-1538(ra) # 80001a6c <setkilled>
    80002076:	bf49                	j	80002008 <usertrap+0x86>
  } else if ((which_dev = devintr()) != 0) {
    80002078:	00000097          	auipc	ra,0x0
    8000207c:	e68080e7          	jalr	-408(ra) # 80001ee0 <devintr>
    80002080:	892a                	mv	s2,a0
    80002082:	c901                	beqz	a0,80002092 <usertrap+0x110>
  if (killed(p)) exit(-1);
    80002084:	8526                	mv	a0,s1
    80002086:	00000097          	auipc	ra,0x0
    8000208a:	a12080e7          	jalr	-1518(ra) # 80001a98 <killed>
    8000208e:	c529                	beqz	a0,800020d8 <usertrap+0x156>
    80002090:	a83d                	j	800020ce <usertrap+0x14c>
  asm volatile("csrr %0, scause" : "=r"(x));
    80002092:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002096:	5890                	lw	a2,48(s1)
    80002098:	00006517          	auipc	a0,0x6
    8000209c:	20050513          	addi	a0,a0,512 # 80008298 <states.0+0x78>
    800020a0:	00004097          	auipc	ra,0x4
    800020a4:	ed6080e7          	jalr	-298(ra) # 80005f76 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    800020a8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    800020ac:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800020b0:	00006517          	auipc	a0,0x6
    800020b4:	21850513          	addi	a0,a0,536 # 800082c8 <states.0+0xa8>
    800020b8:	00004097          	auipc	ra,0x4
    800020bc:	ebe080e7          	jalr	-322(ra) # 80005f76 <printf>
    setkilled(p);
    800020c0:	8526                	mv	a0,s1
    800020c2:	00000097          	auipc	ra,0x0
    800020c6:	9aa080e7          	jalr	-1622(ra) # 80001a6c <setkilled>
    800020ca:	bf3d                	j	80002008 <usertrap+0x86>
  if (killed(p)) exit(-1);
    800020cc:	4901                	li	s2,0
    800020ce:	557d                	li	a0,-1
    800020d0:	00000097          	auipc	ra,0x0
    800020d4:	854080e7          	jalr	-1964(ra) # 80001924 <exit>
  if (which_dev == 2) yield();
    800020d8:	4789                	li	a5,2
    800020da:	f2f91de3          	bne	s2,a5,80002014 <usertrap+0x92>
    800020de:	fffff097          	auipc	ra,0xfffff
    800020e2:	6d6080e7          	jalr	1750(ra) # 800017b4 <yield>
    800020e6:	b73d                	j	80002014 <usertrap+0x92>

00000000800020e8 <kerneltrap>:
void kerneltrap() {
    800020e8:	7179                	addi	sp,sp,-48
    800020ea:	f406                	sd	ra,40(sp)
    800020ec:	f022                	sd	s0,32(sp)
    800020ee:	ec26                	sd	s1,24(sp)
    800020f0:	e84a                	sd	s2,16(sp)
    800020f2:	e44e                	sd	s3,8(sp)
    800020f4:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    800020f6:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800020fa:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    800020fe:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80002102:	1004f793          	andi	a5,s1,256
    80002106:	cb85                	beqz	a5,80002136 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002108:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000210c:	8b89                	andi	a5,a5,2
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    8000210e:	ef85                	bnez	a5,80002146 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0) {
    80002110:	00000097          	auipc	ra,0x0
    80002114:	dd0080e7          	jalr	-560(ra) # 80001ee0 <devintr>
    80002118:	cd1d                	beqz	a0,80002156 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
    8000211a:	4789                	li	a5,2
    8000211c:	06f50a63          	beq	a0,a5,80002190 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002120:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002124:	10049073          	csrw	sstatus,s1
}
    80002128:	70a2                	ld	ra,40(sp)
    8000212a:	7402                	ld	s0,32(sp)
    8000212c:	64e2                	ld	s1,24(sp)
    8000212e:	6942                	ld	s2,16(sp)
    80002130:	69a2                	ld	s3,8(sp)
    80002132:	6145                	addi	sp,sp,48
    80002134:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002136:	00006517          	auipc	a0,0x6
    8000213a:	1b250513          	addi	a0,a0,434 # 800082e8 <states.0+0xc8>
    8000213e:	00004097          	auipc	ra,0x4
    80002142:	dee080e7          	jalr	-530(ra) # 80005f2c <panic>
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    80002146:	00006517          	auipc	a0,0x6
    8000214a:	1ca50513          	addi	a0,a0,458 # 80008310 <states.0+0xf0>
    8000214e:	00004097          	auipc	ra,0x4
    80002152:	dde080e7          	jalr	-546(ra) # 80005f2c <panic>
    printf("scause %p\n", scause);
    80002156:	85ce                	mv	a1,s3
    80002158:	00006517          	auipc	a0,0x6
    8000215c:	1d850513          	addi	a0,a0,472 # 80008330 <states.0+0x110>
    80002160:	00004097          	auipc	ra,0x4
    80002164:	e16080e7          	jalr	-490(ra) # 80005f76 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002168:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    8000216c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002170:	00006517          	auipc	a0,0x6
    80002174:	1d050513          	addi	a0,a0,464 # 80008340 <states.0+0x120>
    80002178:	00004097          	auipc	ra,0x4
    8000217c:	dfe080e7          	jalr	-514(ra) # 80005f76 <printf>
    panic("kerneltrap");
    80002180:	00006517          	auipc	a0,0x6
    80002184:	1d850513          	addi	a0,a0,472 # 80008358 <states.0+0x138>
    80002188:	00004097          	auipc	ra,0x4
    8000218c:	da4080e7          	jalr	-604(ra) # 80005f2c <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
    80002190:	fffff097          	auipc	ra,0xfffff
    80002194:	fb8080e7          	jalr	-72(ra) # 80001148 <myproc>
    80002198:	d541                	beqz	a0,80002120 <kerneltrap+0x38>
    8000219a:	fffff097          	auipc	ra,0xfffff
    8000219e:	fae080e7          	jalr	-82(ra) # 80001148 <myproc>
    800021a2:	4d18                	lw	a4,24(a0)
    800021a4:	4791                	li	a5,4
    800021a6:	f6f71de3          	bne	a4,a5,80002120 <kerneltrap+0x38>
    800021aa:	fffff097          	auipc	ra,0xfffff
    800021ae:	60a080e7          	jalr	1546(ra) # 800017b4 <yield>
    800021b2:	b7bd                	j	80002120 <kerneltrap+0x38>

00000000800021b4 <argraw>:
  struct proc *p = myproc();
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
  return strlen(buf);
}

static uint64 argraw(int n) {
    800021b4:	1101                	addi	sp,sp,-32
    800021b6:	ec06                	sd	ra,24(sp)
    800021b8:	e822                	sd	s0,16(sp)
    800021ba:	e426                	sd	s1,8(sp)
    800021bc:	1000                	addi	s0,sp,32
    800021be:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800021c0:	fffff097          	auipc	ra,0xfffff
    800021c4:	f88080e7          	jalr	-120(ra) # 80001148 <myproc>
  switch (n) {
    800021c8:	4795                	li	a5,5
    800021ca:	0497e163          	bltu	a5,s1,8000220c <argraw+0x58>
    800021ce:	048a                	slli	s1,s1,0x2
    800021d0:	00006717          	auipc	a4,0x6
    800021d4:	1c070713          	addi	a4,a4,448 # 80008390 <states.0+0x170>
    800021d8:	94ba                	add	s1,s1,a4
    800021da:	409c                	lw	a5,0(s1)
    800021dc:	97ba                	add	a5,a5,a4
    800021de:	8782                	jr	a5
    case 0:
      return p->trapframe->a0;
    800021e0:	6d3c                	ld	a5,88(a0)
    800021e2:	7ba8                	ld	a0,112(a5)
    case 5:
      return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800021e4:	60e2                	ld	ra,24(sp)
    800021e6:	6442                	ld	s0,16(sp)
    800021e8:	64a2                	ld	s1,8(sp)
    800021ea:	6105                	addi	sp,sp,32
    800021ec:	8082                	ret
      return p->trapframe->a1;
    800021ee:	6d3c                	ld	a5,88(a0)
    800021f0:	7fa8                	ld	a0,120(a5)
    800021f2:	bfcd                	j	800021e4 <argraw+0x30>
      return p->trapframe->a2;
    800021f4:	6d3c                	ld	a5,88(a0)
    800021f6:	63c8                	ld	a0,128(a5)
    800021f8:	b7f5                	j	800021e4 <argraw+0x30>
      return p->trapframe->a3;
    800021fa:	6d3c                	ld	a5,88(a0)
    800021fc:	67c8                	ld	a0,136(a5)
    800021fe:	b7dd                	j	800021e4 <argraw+0x30>
      return p->trapframe->a4;
    80002200:	6d3c                	ld	a5,88(a0)
    80002202:	6bc8                	ld	a0,144(a5)
    80002204:	b7c5                	j	800021e4 <argraw+0x30>
      return p->trapframe->a5;
    80002206:	6d3c                	ld	a5,88(a0)
    80002208:	6fc8                	ld	a0,152(a5)
    8000220a:	bfe9                	j	800021e4 <argraw+0x30>
  panic("argraw");
    8000220c:	00006517          	auipc	a0,0x6
    80002210:	15c50513          	addi	a0,a0,348 # 80008368 <states.0+0x148>
    80002214:	00004097          	auipc	ra,0x4
    80002218:	d18080e7          	jalr	-744(ra) # 80005f2c <panic>

000000008000221c <fetchaddr>:
int fetchaddr(uint64 addr, uint64 *ip) {
    8000221c:	1101                	addi	sp,sp,-32
    8000221e:	ec06                	sd	ra,24(sp)
    80002220:	e822                	sd	s0,16(sp)
    80002222:	e426                	sd	s1,8(sp)
    80002224:	e04a                	sd	s2,0(sp)
    80002226:	1000                	addi	s0,sp,32
    80002228:	84aa                	mv	s1,a0
    8000222a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000222c:	fffff097          	auipc	ra,0xfffff
    80002230:	f1c080e7          	jalr	-228(ra) # 80001148 <myproc>
  if (addr >= p->sz ||
    80002234:	653c                	ld	a5,72(a0)
    80002236:	02f4f863          	bgeu	s1,a5,80002266 <fetchaddr+0x4a>
      addr + sizeof(uint64) > p->sz)  // both tests needed, in case of overflow
    8000223a:	00848713          	addi	a4,s1,8
  if (addr >= p->sz ||
    8000223e:	02e7e663          	bltu	a5,a4,8000226a <fetchaddr+0x4e>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0) return -1;
    80002242:	46a1                	li	a3,8
    80002244:	8626                	mv	a2,s1
    80002246:	85ca                	mv	a1,s2
    80002248:	6928                	ld	a0,80(a0)
    8000224a:	fffff097          	auipc	ra,0xfffff
    8000224e:	b4e080e7          	jalr	-1202(ra) # 80000d98 <copyin>
    80002252:	00a03533          	snez	a0,a0
    80002256:	40a00533          	neg	a0,a0
}
    8000225a:	60e2                	ld	ra,24(sp)
    8000225c:	6442                	ld	s0,16(sp)
    8000225e:	64a2                	ld	s1,8(sp)
    80002260:	6902                	ld	s2,0(sp)
    80002262:	6105                	addi	sp,sp,32
    80002264:	8082                	ret
    return -1;
    80002266:	557d                	li	a0,-1
    80002268:	bfcd                	j	8000225a <fetchaddr+0x3e>
    8000226a:	557d                	li	a0,-1
    8000226c:	b7fd                	j	8000225a <fetchaddr+0x3e>

000000008000226e <fetchstr>:
int fetchstr(uint64 addr, char *buf, int max) {
    8000226e:	7179                	addi	sp,sp,-48
    80002270:	f406                	sd	ra,40(sp)
    80002272:	f022                	sd	s0,32(sp)
    80002274:	ec26                	sd	s1,24(sp)
    80002276:	e84a                	sd	s2,16(sp)
    80002278:	e44e                	sd	s3,8(sp)
    8000227a:	1800                	addi	s0,sp,48
    8000227c:	892a                	mv	s2,a0
    8000227e:	84ae                	mv	s1,a1
    80002280:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002282:	fffff097          	auipc	ra,0xfffff
    80002286:	ec6080e7          	jalr	-314(ra) # 80001148 <myproc>
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    8000228a:	86ce                	mv	a3,s3
    8000228c:	864a                	mv	a2,s2
    8000228e:	85a6                	mv	a1,s1
    80002290:	6928                	ld	a0,80(a0)
    80002292:	fffff097          	auipc	ra,0xfffff
    80002296:	ba6080e7          	jalr	-1114(ra) # 80000e38 <copyinstr>
    8000229a:	00054e63          	bltz	a0,800022b6 <fetchstr+0x48>
  return strlen(buf);
    8000229e:	8526                	mv	a0,s1
    800022a0:	ffffe097          	auipc	ra,0xffffe
    800022a4:	056080e7          	jalr	86(ra) # 800002f6 <strlen>
}
    800022a8:	70a2                	ld	ra,40(sp)
    800022aa:	7402                	ld	s0,32(sp)
    800022ac:	64e2                	ld	s1,24(sp)
    800022ae:	6942                	ld	s2,16(sp)
    800022b0:	69a2                	ld	s3,8(sp)
    800022b2:	6145                	addi	sp,sp,48
    800022b4:	8082                	ret
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    800022b6:	557d                	li	a0,-1
    800022b8:	bfc5                	j	800022a8 <fetchstr+0x3a>

00000000800022ba <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip) { *ip = argraw(n); }
    800022ba:	1101                	addi	sp,sp,-32
    800022bc:	ec06                	sd	ra,24(sp)
    800022be:	e822                	sd	s0,16(sp)
    800022c0:	e426                	sd	s1,8(sp)
    800022c2:	1000                	addi	s0,sp,32
    800022c4:	84ae                	mv	s1,a1
    800022c6:	00000097          	auipc	ra,0x0
    800022ca:	eee080e7          	jalr	-274(ra) # 800021b4 <argraw>
    800022ce:	c088                	sw	a0,0(s1)
    800022d0:	60e2                	ld	ra,24(sp)
    800022d2:	6442                	ld	s0,16(sp)
    800022d4:	64a2                	ld	s1,8(sp)
    800022d6:	6105                	addi	sp,sp,32
    800022d8:	8082                	ret

00000000800022da <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip) { *ip = argraw(n); }
    800022da:	1101                	addi	sp,sp,-32
    800022dc:	ec06                	sd	ra,24(sp)
    800022de:	e822                	sd	s0,16(sp)
    800022e0:	e426                	sd	s1,8(sp)
    800022e2:	1000                	addi	s0,sp,32
    800022e4:	84ae                	mv	s1,a1
    800022e6:	00000097          	auipc	ra,0x0
    800022ea:	ece080e7          	jalr	-306(ra) # 800021b4 <argraw>
    800022ee:	e088                	sd	a0,0(s1)
    800022f0:	60e2                	ld	ra,24(sp)
    800022f2:	6442                	ld	s0,16(sp)
    800022f4:	64a2                	ld	s1,8(sp)
    800022f6:	6105                	addi	sp,sp,32
    800022f8:	8082                	ret

00000000800022fa <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max) {
    800022fa:	7179                	addi	sp,sp,-48
    800022fc:	f406                	sd	ra,40(sp)
    800022fe:	f022                	sd	s0,32(sp)
    80002300:	ec26                	sd	s1,24(sp)
    80002302:	e84a                	sd	s2,16(sp)
    80002304:	1800                	addi	s0,sp,48
    80002306:	84ae                	mv	s1,a1
    80002308:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000230a:	fd840593          	addi	a1,s0,-40
    8000230e:	00000097          	auipc	ra,0x0
    80002312:	fcc080e7          	jalr	-52(ra) # 800022da <argaddr>
  return fetchstr(addr, buf, max);
    80002316:	864a                	mv	a2,s2
    80002318:	85a6                	mv	a1,s1
    8000231a:	fd843503          	ld	a0,-40(s0)
    8000231e:	00000097          	auipc	ra,0x0
    80002322:	f50080e7          	jalr	-176(ra) # 8000226e <fetchstr>
}
    80002326:	70a2                	ld	ra,40(sp)
    80002328:	7402                	ld	s0,32(sp)
    8000232a:	64e2                	ld	s1,24(sp)
    8000232c:	6942                	ld	s2,16(sp)
    8000232e:	6145                	addi	sp,sp,48
    80002330:	8082                	ret

0000000080002332 <syscall>:
    [SYS_sleep] sys_sleep, [SYS_uptime] sys_uptime, [SYS_open] sys_open,
    [SYS_write] sys_write, [SYS_mknod] sys_mknod,   [SYS_unlink] sys_unlink,
    [SYS_link] sys_link,   [SYS_mkdir] sys_mkdir,   [SYS_close] sys_close,
};

void syscall(void) {
    80002332:	1101                	addi	sp,sp,-32
    80002334:	ec06                	sd	ra,24(sp)
    80002336:	e822                	sd	s0,16(sp)
    80002338:	e426                	sd	s1,8(sp)
    8000233a:	e04a                	sd	s2,0(sp)
    8000233c:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000233e:	fffff097          	auipc	ra,0xfffff
    80002342:	e0a080e7          	jalr	-502(ra) # 80001148 <myproc>
    80002346:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002348:	05853903          	ld	s2,88(a0)
    8000234c:	0a893783          	ld	a5,168(s2)
    80002350:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002354:	37fd                	addiw	a5,a5,-1
    80002356:	4751                	li	a4,20
    80002358:	00f76f63          	bltu	a4,a5,80002376 <syscall+0x44>
    8000235c:	00369713          	slli	a4,a3,0x3
    80002360:	00006797          	auipc	a5,0x6
    80002364:	04878793          	addi	a5,a5,72 # 800083a8 <syscalls>
    80002368:	97ba                	add	a5,a5,a4
    8000236a:	639c                	ld	a5,0(a5)
    8000236c:	c789                	beqz	a5,80002376 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000236e:	9782                	jalr	a5
    80002370:	06a93823          	sd	a0,112(s2)
    80002374:	a839                	j	80002392 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80002376:	15848613          	addi	a2,s1,344
    8000237a:	588c                	lw	a1,48(s1)
    8000237c:	00006517          	auipc	a0,0x6
    80002380:	ff450513          	addi	a0,a0,-12 # 80008370 <states.0+0x150>
    80002384:	00004097          	auipc	ra,0x4
    80002388:	bf2080e7          	jalr	-1038(ra) # 80005f76 <printf>
    p->trapframe->a0 = -1;
    8000238c:	6cbc                	ld	a5,88(s1)
    8000238e:	577d                	li	a4,-1
    80002390:	fbb8                	sd	a4,112(a5)
  }
}
    80002392:	60e2                	ld	ra,24(sp)
    80002394:	6442                	ld	s0,16(sp)
    80002396:	64a2                	ld	s1,8(sp)
    80002398:	6902                	ld	s2,0(sp)
    8000239a:	6105                	addi	sp,sp,32
    8000239c:	8082                	ret

000000008000239e <sys_exit>:
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64 sys_exit(void) {
    8000239e:	1101                	addi	sp,sp,-32
    800023a0:	ec06                	sd	ra,24(sp)
    800023a2:	e822                	sd	s0,16(sp)
    800023a4:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800023a6:	fec40593          	addi	a1,s0,-20
    800023aa:	4501                	li	a0,0
    800023ac:	00000097          	auipc	ra,0x0
    800023b0:	f0e080e7          	jalr	-242(ra) # 800022ba <argint>
  exit(n);
    800023b4:	fec42503          	lw	a0,-20(s0)
    800023b8:	fffff097          	auipc	ra,0xfffff
    800023bc:	56c080e7          	jalr	1388(ra) # 80001924 <exit>
  return 0;  // not reached
}
    800023c0:	4501                	li	a0,0
    800023c2:	60e2                	ld	ra,24(sp)
    800023c4:	6442                	ld	s0,16(sp)
    800023c6:	6105                	addi	sp,sp,32
    800023c8:	8082                	ret

00000000800023ca <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    800023ca:	1141                	addi	sp,sp,-16
    800023cc:	e406                	sd	ra,8(sp)
    800023ce:	e022                	sd	s0,0(sp)
    800023d0:	0800                	addi	s0,sp,16
    800023d2:	fffff097          	auipc	ra,0xfffff
    800023d6:	d76080e7          	jalr	-650(ra) # 80001148 <myproc>
    800023da:	5908                	lw	a0,48(a0)
    800023dc:	60a2                	ld	ra,8(sp)
    800023de:	6402                	ld	s0,0(sp)
    800023e0:	0141                	addi	sp,sp,16
    800023e2:	8082                	ret

00000000800023e4 <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    800023e4:	1141                	addi	sp,sp,-16
    800023e6:	e406                	sd	ra,8(sp)
    800023e8:	e022                	sd	s0,0(sp)
    800023ea:	0800                	addi	s0,sp,16
    800023ec:	fffff097          	auipc	ra,0xfffff
    800023f0:	112080e7          	jalr	274(ra) # 800014fe <fork>
    800023f4:	60a2                	ld	ra,8(sp)
    800023f6:	6402                	ld	s0,0(sp)
    800023f8:	0141                	addi	sp,sp,16
    800023fa:	8082                	ret

00000000800023fc <sys_wait>:

uint64 sys_wait(void) {
    800023fc:	1101                	addi	sp,sp,-32
    800023fe:	ec06                	sd	ra,24(sp)
    80002400:	e822                	sd	s0,16(sp)
    80002402:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002404:	fe840593          	addi	a1,s0,-24
    80002408:	4501                	li	a0,0
    8000240a:	00000097          	auipc	ra,0x0
    8000240e:	ed0080e7          	jalr	-304(ra) # 800022da <argaddr>
  return wait(p);
    80002412:	fe843503          	ld	a0,-24(s0)
    80002416:	fffff097          	auipc	ra,0xfffff
    8000241a:	6b4080e7          	jalr	1716(ra) # 80001aca <wait>
}
    8000241e:	60e2                	ld	ra,24(sp)
    80002420:	6442                	ld	s0,16(sp)
    80002422:	6105                	addi	sp,sp,32
    80002424:	8082                	ret

0000000080002426 <sys_sbrk>:

uint64 sys_sbrk(void) {
    80002426:	7179                	addi	sp,sp,-48
    80002428:	f406                	sd	ra,40(sp)
    8000242a:	f022                	sd	s0,32(sp)
    8000242c:	ec26                	sd	s1,24(sp)
    8000242e:	e84a                	sd	s2,16(sp)
    80002430:	1800                	addi	s0,sp,48
  uint64 sz;
  int n;

  argint(0, &n);
    80002432:	fdc40593          	addi	a1,s0,-36
    80002436:	4501                	li	a0,0
    80002438:	00000097          	auipc	ra,0x0
    8000243c:	e82080e7          	jalr	-382(ra) # 800022ba <argint>
  sz = myproc()->sz;
    80002440:	fffff097          	auipc	ra,0xfffff
    80002444:	d08080e7          	jalr	-760(ra) # 80001148 <myproc>
    80002448:	6524                	ld	s1,72(a0)
  if (sz + n > MAXVA) return -1;
    8000244a:	fdc42703          	lw	a4,-36(s0)
    8000244e:	9726                	add	a4,a4,s1
    80002450:	4785                	li	a5,1
    80002452:	179a                	slli	a5,a5,0x26
    80002454:	04e7e663          	bltu	a5,a4,800024a0 <sys_sbrk+0x7a>
  myproc()->sz += n;
    80002458:	fffff097          	auipc	ra,0xfffff
    8000245c:	cf0080e7          	jalr	-784(ra) # 80001148 <myproc>
    80002460:	fdc42703          	lw	a4,-36(s0)
    80002464:	653c                	ld	a5,72(a0)
    80002466:	97ba                	add	a5,a5,a4
    80002468:	e53c                	sd	a5,72(a0)
  if (n < 0) {
    8000246a:	00074963          	bltz	a4,8000247c <sys_sbrk+0x56>
    uvmdealloc(myproc()->pagetable, sz, myproc()->sz);
  }
  return sz;
}
    8000246e:	8526                	mv	a0,s1
    80002470:	70a2                	ld	ra,40(sp)
    80002472:	7402                	ld	s0,32(sp)
    80002474:	64e2                	ld	s1,24(sp)
    80002476:	6942                	ld	s2,16(sp)
    80002478:	6145                	addi	sp,sp,48
    8000247a:	8082                	ret
    uvmdealloc(myproc()->pagetable, sz, myproc()->sz);
    8000247c:	fffff097          	auipc	ra,0xfffff
    80002480:	ccc080e7          	jalr	-820(ra) # 80001148 <myproc>
    80002484:	05053903          	ld	s2,80(a0)
    80002488:	fffff097          	auipc	ra,0xfffff
    8000248c:	cc0080e7          	jalr	-832(ra) # 80001148 <myproc>
    80002490:	6530                	ld	a2,72(a0)
    80002492:	85a6                	mv	a1,s1
    80002494:	854a                	mv	a0,s2
    80002496:	ffffe097          	auipc	ra,0xffffe
    8000249a:	5f4080e7          	jalr	1524(ra) # 80000a8a <uvmdealloc>
    8000249e:	bfc1                	j	8000246e <sys_sbrk+0x48>
  if (sz + n > MAXVA) return -1;
    800024a0:	54fd                	li	s1,-1
    800024a2:	b7f1                	j	8000246e <sys_sbrk+0x48>

00000000800024a4 <sys_sleep>:

uint64 sys_sleep(void) {
    800024a4:	7139                	addi	sp,sp,-64
    800024a6:	fc06                	sd	ra,56(sp)
    800024a8:	f822                	sd	s0,48(sp)
    800024aa:	f426                	sd	s1,40(sp)
    800024ac:	f04a                	sd	s2,32(sp)
    800024ae:	ec4e                	sd	s3,24(sp)
    800024b0:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800024b2:	fcc40593          	addi	a1,s0,-52
    800024b6:	4501                	li	a0,0
    800024b8:	00000097          	auipc	ra,0x0
    800024bc:	e02080e7          	jalr	-510(ra) # 800022ba <argint>
  acquire(&tickslock);
    800024c0:	00094517          	auipc	a0,0x94
    800024c4:	26850513          	addi	a0,a0,616 # 80096728 <tickslock>
    800024c8:	00004097          	auipc	ra,0x4
    800024cc:	f9c080e7          	jalr	-100(ra) # 80006464 <acquire>
  ticks0 = ticks;
    800024d0:	00006917          	auipc	s2,0x6
    800024d4:	3d892903          	lw	s2,984(s2) # 800088a8 <ticks>
  while (ticks - ticks0 < n) {
    800024d8:	fcc42783          	lw	a5,-52(s0)
    800024dc:	cf9d                	beqz	a5,8000251a <sys_sleep+0x76>
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800024de:	00094997          	auipc	s3,0x94
    800024e2:	24a98993          	addi	s3,s3,586 # 80096728 <tickslock>
    800024e6:	00006497          	auipc	s1,0x6
    800024ea:	3c248493          	addi	s1,s1,962 # 800088a8 <ticks>
    if (killed(myproc())) {
    800024ee:	fffff097          	auipc	ra,0xfffff
    800024f2:	c5a080e7          	jalr	-934(ra) # 80001148 <myproc>
    800024f6:	fffff097          	auipc	ra,0xfffff
    800024fa:	5a2080e7          	jalr	1442(ra) # 80001a98 <killed>
    800024fe:	ed15                	bnez	a0,8000253a <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002500:	85ce                	mv	a1,s3
    80002502:	8526                	mv	a0,s1
    80002504:	fffff097          	auipc	ra,0xfffff
    80002508:	2ec080e7          	jalr	748(ra) # 800017f0 <sleep>
  while (ticks - ticks0 < n) {
    8000250c:	409c                	lw	a5,0(s1)
    8000250e:	412787bb          	subw	a5,a5,s2
    80002512:	fcc42703          	lw	a4,-52(s0)
    80002516:	fce7ece3          	bltu	a5,a4,800024ee <sys_sleep+0x4a>
  }
  release(&tickslock);
    8000251a:	00094517          	auipc	a0,0x94
    8000251e:	20e50513          	addi	a0,a0,526 # 80096728 <tickslock>
    80002522:	00004097          	auipc	ra,0x4
    80002526:	ff6080e7          	jalr	-10(ra) # 80006518 <release>
  return 0;
    8000252a:	4501                	li	a0,0
}
    8000252c:	70e2                	ld	ra,56(sp)
    8000252e:	7442                	ld	s0,48(sp)
    80002530:	74a2                	ld	s1,40(sp)
    80002532:	7902                	ld	s2,32(sp)
    80002534:	69e2                	ld	s3,24(sp)
    80002536:	6121                	addi	sp,sp,64
    80002538:	8082                	ret
      release(&tickslock);
    8000253a:	00094517          	auipc	a0,0x94
    8000253e:	1ee50513          	addi	a0,a0,494 # 80096728 <tickslock>
    80002542:	00004097          	auipc	ra,0x4
    80002546:	fd6080e7          	jalr	-42(ra) # 80006518 <release>
      return -1;
    8000254a:	557d                	li	a0,-1
    8000254c:	b7c5                	j	8000252c <sys_sleep+0x88>

000000008000254e <sys_kill>:

uint64 sys_kill(void) {
    8000254e:	1101                	addi	sp,sp,-32
    80002550:	ec06                	sd	ra,24(sp)
    80002552:	e822                	sd	s0,16(sp)
    80002554:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002556:	fec40593          	addi	a1,s0,-20
    8000255a:	4501                	li	a0,0
    8000255c:	00000097          	auipc	ra,0x0
    80002560:	d5e080e7          	jalr	-674(ra) # 800022ba <argint>
  return kill(pid);
    80002564:	fec42503          	lw	a0,-20(s0)
    80002568:	fffff097          	auipc	ra,0xfffff
    8000256c:	492080e7          	jalr	1170(ra) # 800019fa <kill>
}
    80002570:	60e2                	ld	ra,24(sp)
    80002572:	6442                	ld	s0,16(sp)
    80002574:	6105                	addi	sp,sp,32
    80002576:	8082                	ret

0000000080002578 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    80002578:	1101                	addi	sp,sp,-32
    8000257a:	ec06                	sd	ra,24(sp)
    8000257c:	e822                	sd	s0,16(sp)
    8000257e:	e426                	sd	s1,8(sp)
    80002580:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002582:	00094517          	auipc	a0,0x94
    80002586:	1a650513          	addi	a0,a0,422 # 80096728 <tickslock>
    8000258a:	00004097          	auipc	ra,0x4
    8000258e:	eda080e7          	jalr	-294(ra) # 80006464 <acquire>
  xticks = ticks;
    80002592:	00006497          	auipc	s1,0x6
    80002596:	3164a483          	lw	s1,790(s1) # 800088a8 <ticks>
  release(&tickslock);
    8000259a:	00094517          	auipc	a0,0x94
    8000259e:	18e50513          	addi	a0,a0,398 # 80096728 <tickslock>
    800025a2:	00004097          	auipc	ra,0x4
    800025a6:	f76080e7          	jalr	-138(ra) # 80006518 <release>
  return xticks;
}
    800025aa:	02049513          	slli	a0,s1,0x20
    800025ae:	9101                	srli	a0,a0,0x20
    800025b0:	60e2                	ld	ra,24(sp)
    800025b2:	6442                	ld	s0,16(sp)
    800025b4:	64a2                	ld	s1,8(sp)
    800025b6:	6105                	addi	sp,sp,32
    800025b8:	8082                	ret

00000000800025ba <binit>:
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  struct buf head;
} bcache;

void binit(void) {
    800025ba:	7179                	addi	sp,sp,-48
    800025bc:	f406                	sd	ra,40(sp)
    800025be:	f022                	sd	s0,32(sp)
    800025c0:	ec26                	sd	s1,24(sp)
    800025c2:	e84a                	sd	s2,16(sp)
    800025c4:	e44e                	sd	s3,8(sp)
    800025c6:	e052                	sd	s4,0(sp)
    800025c8:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800025ca:	00006597          	auipc	a1,0x6
    800025ce:	e8e58593          	addi	a1,a1,-370 # 80008458 <syscalls+0xb0>
    800025d2:	00094517          	auipc	a0,0x94
    800025d6:	16e50513          	addi	a0,a0,366 # 80096740 <bcache>
    800025da:	00004097          	auipc	ra,0x4
    800025de:	dfa080e7          	jalr	-518(ra) # 800063d4 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800025e2:	0009c797          	auipc	a5,0x9c
    800025e6:	15e78793          	addi	a5,a5,350 # 8009e740 <bcache+0x8000>
    800025ea:	0009c717          	auipc	a4,0x9c
    800025ee:	3be70713          	addi	a4,a4,958 # 8009e9a8 <bcache+0x8268>
    800025f2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800025f6:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    800025fa:	00094497          	auipc	s1,0x94
    800025fe:	15e48493          	addi	s1,s1,350 # 80096758 <bcache+0x18>
    b->next = bcache.head.next;
    80002602:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002604:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002606:	00006a17          	auipc	s4,0x6
    8000260a:	e5aa0a13          	addi	s4,s4,-422 # 80008460 <syscalls+0xb8>
    b->next = bcache.head.next;
    8000260e:	2b893783          	ld	a5,696(s2)
    80002612:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002614:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002618:	85d2                	mv	a1,s4
    8000261a:	01048513          	addi	a0,s1,16
    8000261e:	00001097          	auipc	ra,0x1
    80002622:	4c8080e7          	jalr	1224(ra) # 80003ae6 <initsleeplock>
    bcache.head.next->prev = b;
    80002626:	2b893783          	ld	a5,696(s2)
    8000262a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000262c:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002630:	45848493          	addi	s1,s1,1112
    80002634:	fd349de3          	bne	s1,s3,8000260e <binit+0x54>
  }
}
    80002638:	70a2                	ld	ra,40(sp)
    8000263a:	7402                	ld	s0,32(sp)
    8000263c:	64e2                	ld	s1,24(sp)
    8000263e:	6942                	ld	s2,16(sp)
    80002640:	69a2                	ld	s3,8(sp)
    80002642:	6a02                	ld	s4,0(sp)
    80002644:	6145                	addi	sp,sp,48
    80002646:	8082                	ret

0000000080002648 <bread>:
  }
  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf *bread(uint dev, uint blockno) {
    80002648:	7179                	addi	sp,sp,-48
    8000264a:	f406                	sd	ra,40(sp)
    8000264c:	f022                	sd	s0,32(sp)
    8000264e:	ec26                	sd	s1,24(sp)
    80002650:	e84a                	sd	s2,16(sp)
    80002652:	e44e                	sd	s3,8(sp)
    80002654:	1800                	addi	s0,sp,48
    80002656:	892a                	mv	s2,a0
    80002658:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000265a:	00094517          	auipc	a0,0x94
    8000265e:	0e650513          	addi	a0,a0,230 # 80096740 <bcache>
    80002662:	00004097          	auipc	ra,0x4
    80002666:	e02080e7          	jalr	-510(ra) # 80006464 <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    8000266a:	0009c497          	auipc	s1,0x9c
    8000266e:	38e4b483          	ld	s1,910(s1) # 8009e9f8 <bcache+0x82b8>
    80002672:	0009c797          	auipc	a5,0x9c
    80002676:	33678793          	addi	a5,a5,822 # 8009e9a8 <bcache+0x8268>
    8000267a:	02f48f63          	beq	s1,a5,800026b8 <bread+0x70>
    8000267e:	873e                	mv	a4,a5
    80002680:	a021                	j	80002688 <bread+0x40>
    80002682:	68a4                	ld	s1,80(s1)
    80002684:	02e48a63          	beq	s1,a4,800026b8 <bread+0x70>
    if (b->dev == dev && b->blockno == blockno) {
    80002688:	449c                	lw	a5,8(s1)
    8000268a:	ff279ce3          	bne	a5,s2,80002682 <bread+0x3a>
    8000268e:	44dc                	lw	a5,12(s1)
    80002690:	ff3799e3          	bne	a5,s3,80002682 <bread+0x3a>
      b->refcnt++;
    80002694:	40bc                	lw	a5,64(s1)
    80002696:	2785                	addiw	a5,a5,1
    80002698:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000269a:	00094517          	auipc	a0,0x94
    8000269e:	0a650513          	addi	a0,a0,166 # 80096740 <bcache>
    800026a2:	00004097          	auipc	ra,0x4
    800026a6:	e76080e7          	jalr	-394(ra) # 80006518 <release>
      acquiresleep(&b->lock);
    800026aa:	01048513          	addi	a0,s1,16
    800026ae:	00001097          	auipc	ra,0x1
    800026b2:	472080e7          	jalr	1138(ra) # 80003b20 <acquiresleep>
      return b;
    800026b6:	a8b9                	j	80002714 <bread+0xcc>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    800026b8:	0009c497          	auipc	s1,0x9c
    800026bc:	3384b483          	ld	s1,824(s1) # 8009e9f0 <bcache+0x82b0>
    800026c0:	0009c797          	auipc	a5,0x9c
    800026c4:	2e878793          	addi	a5,a5,744 # 8009e9a8 <bcache+0x8268>
    800026c8:	00f48863          	beq	s1,a5,800026d8 <bread+0x90>
    800026cc:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    800026ce:	40bc                	lw	a5,64(s1)
    800026d0:	cf81                	beqz	a5,800026e8 <bread+0xa0>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    800026d2:	64a4                	ld	s1,72(s1)
    800026d4:	fee49de3          	bne	s1,a4,800026ce <bread+0x86>
  panic("bget: no buffers");
    800026d8:	00006517          	auipc	a0,0x6
    800026dc:	d9050513          	addi	a0,a0,-624 # 80008468 <syscalls+0xc0>
    800026e0:	00004097          	auipc	ra,0x4
    800026e4:	84c080e7          	jalr	-1972(ra) # 80005f2c <panic>
      b->dev = dev;
    800026e8:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800026ec:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800026f0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800026f4:	4785                	li	a5,1
    800026f6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800026f8:	00094517          	auipc	a0,0x94
    800026fc:	04850513          	addi	a0,a0,72 # 80096740 <bcache>
    80002700:	00004097          	auipc	ra,0x4
    80002704:	e18080e7          	jalr	-488(ra) # 80006518 <release>
      acquiresleep(&b->lock);
    80002708:	01048513          	addi	a0,s1,16
    8000270c:	00001097          	auipc	ra,0x1
    80002710:	414080e7          	jalr	1044(ra) # 80003b20 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    80002714:	409c                	lw	a5,0(s1)
    80002716:	cb89                	beqz	a5,80002728 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002718:	8526                	mv	a0,s1
    8000271a:	70a2                	ld	ra,40(sp)
    8000271c:	7402                	ld	s0,32(sp)
    8000271e:	64e2                	ld	s1,24(sp)
    80002720:	6942                	ld	s2,16(sp)
    80002722:	69a2                	ld	s3,8(sp)
    80002724:	6145                	addi	sp,sp,48
    80002726:	8082                	ret
    virtio_disk_rw(b, 0);
    80002728:	4581                	li	a1,0
    8000272a:	8526                	mv	a0,s1
    8000272c:	00003097          	auipc	ra,0x3
    80002730:	ff6080e7          	jalr	-10(ra) # 80005722 <virtio_disk_rw>
    b->valid = 1;
    80002734:	4785                	li	a5,1
    80002736:	c09c                	sw	a5,0(s1)
  return b;
    80002738:	b7c5                	j	80002718 <bread+0xd0>

000000008000273a <bwrite>:

// Write b's contents to disk.  Must be locked.
void bwrite(struct buf *b) {
    8000273a:	1101                	addi	sp,sp,-32
    8000273c:	ec06                	sd	ra,24(sp)
    8000273e:	e822                	sd	s0,16(sp)
    80002740:	e426                	sd	s1,8(sp)
    80002742:	1000                	addi	s0,sp,32
    80002744:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock)) panic("bwrite");
    80002746:	0541                	addi	a0,a0,16
    80002748:	00001097          	auipc	ra,0x1
    8000274c:	472080e7          	jalr	1138(ra) # 80003bba <holdingsleep>
    80002750:	cd01                	beqz	a0,80002768 <bwrite+0x2e>
  virtio_disk_rw(b, 1);
    80002752:	4585                	li	a1,1
    80002754:	8526                	mv	a0,s1
    80002756:	00003097          	auipc	ra,0x3
    8000275a:	fcc080e7          	jalr	-52(ra) # 80005722 <virtio_disk_rw>
}
    8000275e:	60e2                	ld	ra,24(sp)
    80002760:	6442                	ld	s0,16(sp)
    80002762:	64a2                	ld	s1,8(sp)
    80002764:	6105                	addi	sp,sp,32
    80002766:	8082                	ret
  if (!holdingsleep(&b->lock)) panic("bwrite");
    80002768:	00006517          	auipc	a0,0x6
    8000276c:	d1850513          	addi	a0,a0,-744 # 80008480 <syscalls+0xd8>
    80002770:	00003097          	auipc	ra,0x3
    80002774:	7bc080e7          	jalr	1980(ra) # 80005f2c <panic>

0000000080002778 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void brelse(struct buf *b) {
    80002778:	1101                	addi	sp,sp,-32
    8000277a:	ec06                	sd	ra,24(sp)
    8000277c:	e822                	sd	s0,16(sp)
    8000277e:	e426                	sd	s1,8(sp)
    80002780:	e04a                	sd	s2,0(sp)
    80002782:	1000                	addi	s0,sp,32
    80002784:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock)) panic("brelse");
    80002786:	01050913          	addi	s2,a0,16
    8000278a:	854a                	mv	a0,s2
    8000278c:	00001097          	auipc	ra,0x1
    80002790:	42e080e7          	jalr	1070(ra) # 80003bba <holdingsleep>
    80002794:	c92d                	beqz	a0,80002806 <brelse+0x8e>

  releasesleep(&b->lock);
    80002796:	854a                	mv	a0,s2
    80002798:	00001097          	auipc	ra,0x1
    8000279c:	3de080e7          	jalr	990(ra) # 80003b76 <releasesleep>

  acquire(&bcache.lock);
    800027a0:	00094517          	auipc	a0,0x94
    800027a4:	fa050513          	addi	a0,a0,-96 # 80096740 <bcache>
    800027a8:	00004097          	auipc	ra,0x4
    800027ac:	cbc080e7          	jalr	-836(ra) # 80006464 <acquire>
  b->refcnt--;
    800027b0:	40bc                	lw	a5,64(s1)
    800027b2:	37fd                	addiw	a5,a5,-1
    800027b4:	0007871b          	sext.w	a4,a5
    800027b8:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800027ba:	eb05                	bnez	a4,800027ea <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800027bc:	68bc                	ld	a5,80(s1)
    800027be:	64b8                	ld	a4,72(s1)
    800027c0:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800027c2:	64bc                	ld	a5,72(s1)
    800027c4:	68b8                	ld	a4,80(s1)
    800027c6:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800027c8:	0009c797          	auipc	a5,0x9c
    800027cc:	f7878793          	addi	a5,a5,-136 # 8009e740 <bcache+0x8000>
    800027d0:	2b87b703          	ld	a4,696(a5)
    800027d4:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800027d6:	0009c717          	auipc	a4,0x9c
    800027da:	1d270713          	addi	a4,a4,466 # 8009e9a8 <bcache+0x8268>
    800027de:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800027e0:	2b87b703          	ld	a4,696(a5)
    800027e4:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800027e6:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    800027ea:	00094517          	auipc	a0,0x94
    800027ee:	f5650513          	addi	a0,a0,-170 # 80096740 <bcache>
    800027f2:	00004097          	auipc	ra,0x4
    800027f6:	d26080e7          	jalr	-730(ra) # 80006518 <release>
}
    800027fa:	60e2                	ld	ra,24(sp)
    800027fc:	6442                	ld	s0,16(sp)
    800027fe:	64a2                	ld	s1,8(sp)
    80002800:	6902                	ld	s2,0(sp)
    80002802:	6105                	addi	sp,sp,32
    80002804:	8082                	ret
  if (!holdingsleep(&b->lock)) panic("brelse");
    80002806:	00006517          	auipc	a0,0x6
    8000280a:	c8250513          	addi	a0,a0,-894 # 80008488 <syscalls+0xe0>
    8000280e:	00003097          	auipc	ra,0x3
    80002812:	71e080e7          	jalr	1822(ra) # 80005f2c <panic>

0000000080002816 <bpin>:

void bpin(struct buf *b) {
    80002816:	1101                	addi	sp,sp,-32
    80002818:	ec06                	sd	ra,24(sp)
    8000281a:	e822                	sd	s0,16(sp)
    8000281c:	e426                	sd	s1,8(sp)
    8000281e:	1000                	addi	s0,sp,32
    80002820:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002822:	00094517          	auipc	a0,0x94
    80002826:	f1e50513          	addi	a0,a0,-226 # 80096740 <bcache>
    8000282a:	00004097          	auipc	ra,0x4
    8000282e:	c3a080e7          	jalr	-966(ra) # 80006464 <acquire>
  b->refcnt++;
    80002832:	40bc                	lw	a5,64(s1)
    80002834:	2785                	addiw	a5,a5,1
    80002836:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002838:	00094517          	auipc	a0,0x94
    8000283c:	f0850513          	addi	a0,a0,-248 # 80096740 <bcache>
    80002840:	00004097          	auipc	ra,0x4
    80002844:	cd8080e7          	jalr	-808(ra) # 80006518 <release>
}
    80002848:	60e2                	ld	ra,24(sp)
    8000284a:	6442                	ld	s0,16(sp)
    8000284c:	64a2                	ld	s1,8(sp)
    8000284e:	6105                	addi	sp,sp,32
    80002850:	8082                	ret

0000000080002852 <bunpin>:

void bunpin(struct buf *b) {
    80002852:	1101                	addi	sp,sp,-32
    80002854:	ec06                	sd	ra,24(sp)
    80002856:	e822                	sd	s0,16(sp)
    80002858:	e426                	sd	s1,8(sp)
    8000285a:	1000                	addi	s0,sp,32
    8000285c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000285e:	00094517          	auipc	a0,0x94
    80002862:	ee250513          	addi	a0,a0,-286 # 80096740 <bcache>
    80002866:	00004097          	auipc	ra,0x4
    8000286a:	bfe080e7          	jalr	-1026(ra) # 80006464 <acquire>
  b->refcnt--;
    8000286e:	40bc                	lw	a5,64(s1)
    80002870:	37fd                	addiw	a5,a5,-1
    80002872:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002874:	00094517          	auipc	a0,0x94
    80002878:	ecc50513          	addi	a0,a0,-308 # 80096740 <bcache>
    8000287c:	00004097          	auipc	ra,0x4
    80002880:	c9c080e7          	jalr	-868(ra) # 80006518 <release>
}
    80002884:	60e2                	ld	ra,24(sp)
    80002886:	6442                	ld	s0,16(sp)
    80002888:	64a2                	ld	s1,8(sp)
    8000288a:	6105                	addi	sp,sp,32
    8000288c:	8082                	ret

000000008000288e <bfree>:
  printf("balloc: out of blocks\n");
  return 0;
}

// Free a disk block.
static void bfree(int dev, uint b) {
    8000288e:	1101                	addi	sp,sp,-32
    80002890:	ec06                	sd	ra,24(sp)
    80002892:	e822                	sd	s0,16(sp)
    80002894:	e426                	sd	s1,8(sp)
    80002896:	e04a                	sd	s2,0(sp)
    80002898:	1000                	addi	s0,sp,32
    8000289a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000289c:	00d5d59b          	srliw	a1,a1,0xd
    800028a0:	0009c797          	auipc	a5,0x9c
    800028a4:	57c7a783          	lw	a5,1404(a5) # 8009ee1c <sb+0x1c>
    800028a8:	9dbd                	addw	a1,a1,a5
    800028aa:	00000097          	auipc	ra,0x0
    800028ae:	d9e080e7          	jalr	-610(ra) # 80002648 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800028b2:	0074f713          	andi	a4,s1,7
    800028b6:	4785                	li	a5,1
    800028b8:	00e797bb          	sllw	a5,a5,a4
  if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
    800028bc:	14ce                	slli	s1,s1,0x33
    800028be:	90d9                	srli	s1,s1,0x36
    800028c0:	00950733          	add	a4,a0,s1
    800028c4:	05874703          	lbu	a4,88(a4)
    800028c8:	00e7f6b3          	and	a3,a5,a4
    800028cc:	c69d                	beqz	a3,800028fa <bfree+0x6c>
    800028ce:	892a                	mv	s2,a0
  bp->data[bi / 8] &= ~m;
    800028d0:	94aa                	add	s1,s1,a0
    800028d2:	fff7c793          	not	a5,a5
    800028d6:	8f7d                	and	a4,a4,a5
    800028d8:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800028dc:	00001097          	auipc	ra,0x1
    800028e0:	126080e7          	jalr	294(ra) # 80003a02 <log_write>
  brelse(bp);
    800028e4:	854a                	mv	a0,s2
    800028e6:	00000097          	auipc	ra,0x0
    800028ea:	e92080e7          	jalr	-366(ra) # 80002778 <brelse>
}
    800028ee:	60e2                	ld	ra,24(sp)
    800028f0:	6442                	ld	s0,16(sp)
    800028f2:	64a2                	ld	s1,8(sp)
    800028f4:	6902                	ld	s2,0(sp)
    800028f6:	6105                	addi	sp,sp,32
    800028f8:	8082                	ret
  if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
    800028fa:	00006517          	auipc	a0,0x6
    800028fe:	b9650513          	addi	a0,a0,-1130 # 80008490 <syscalls+0xe8>
    80002902:	00003097          	auipc	ra,0x3
    80002906:	62a080e7          	jalr	1578(ra) # 80005f2c <panic>

000000008000290a <balloc>:
static uint balloc(uint dev) {
    8000290a:	711d                	addi	sp,sp,-96
    8000290c:	ec86                	sd	ra,88(sp)
    8000290e:	e8a2                	sd	s0,80(sp)
    80002910:	e4a6                	sd	s1,72(sp)
    80002912:	e0ca                	sd	s2,64(sp)
    80002914:	fc4e                	sd	s3,56(sp)
    80002916:	f852                	sd	s4,48(sp)
    80002918:	f456                	sd	s5,40(sp)
    8000291a:	f05a                	sd	s6,32(sp)
    8000291c:	ec5e                	sd	s7,24(sp)
    8000291e:	e862                	sd	s8,16(sp)
    80002920:	e466                	sd	s9,8(sp)
    80002922:	1080                	addi	s0,sp,96
  for (b = 0; b < sb.size; b += BPB) {
    80002924:	0009c797          	auipc	a5,0x9c
    80002928:	4e07a783          	lw	a5,1248(a5) # 8009ee04 <sb+0x4>
    8000292c:	cff5                	beqz	a5,80002a28 <balloc+0x11e>
    8000292e:	8baa                	mv	s7,a0
    80002930:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002932:	0009cb17          	auipc	s6,0x9c
    80002936:	4ceb0b13          	addi	s6,s6,1230 # 8009ee00 <sb>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    8000293a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000293c:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    8000293e:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    80002940:	6c89                	lui	s9,0x2
    80002942:	a061                	j	800029ca <balloc+0xc0>
        bp->data[bi / 8] |= m;            // Mark block in use.
    80002944:	97ca                	add	a5,a5,s2
    80002946:	8e55                	or	a2,a2,a3
    80002948:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000294c:	854a                	mv	a0,s2
    8000294e:	00001097          	auipc	ra,0x1
    80002952:	0b4080e7          	jalr	180(ra) # 80003a02 <log_write>
        brelse(bp);
    80002956:	854a                	mv	a0,s2
    80002958:	00000097          	auipc	ra,0x0
    8000295c:	e20080e7          	jalr	-480(ra) # 80002778 <brelse>
  bp = bread(dev, bno);
    80002960:	85a6                	mv	a1,s1
    80002962:	855e                	mv	a0,s7
    80002964:	00000097          	auipc	ra,0x0
    80002968:	ce4080e7          	jalr	-796(ra) # 80002648 <bread>
    8000296c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000296e:	40000613          	li	a2,1024
    80002972:	4581                	li	a1,0
    80002974:	05850513          	addi	a0,a0,88
    80002978:	ffffe097          	auipc	ra,0xffffe
    8000297c:	802080e7          	jalr	-2046(ra) # 8000017a <memset>
  log_write(bp);
    80002980:	854a                	mv	a0,s2
    80002982:	00001097          	auipc	ra,0x1
    80002986:	080080e7          	jalr	128(ra) # 80003a02 <log_write>
  brelse(bp);
    8000298a:	854a                	mv	a0,s2
    8000298c:	00000097          	auipc	ra,0x0
    80002990:	dec080e7          	jalr	-532(ra) # 80002778 <brelse>
}
    80002994:	8526                	mv	a0,s1
    80002996:	60e6                	ld	ra,88(sp)
    80002998:	6446                	ld	s0,80(sp)
    8000299a:	64a6                	ld	s1,72(sp)
    8000299c:	6906                	ld	s2,64(sp)
    8000299e:	79e2                	ld	s3,56(sp)
    800029a0:	7a42                	ld	s4,48(sp)
    800029a2:	7aa2                	ld	s5,40(sp)
    800029a4:	7b02                	ld	s6,32(sp)
    800029a6:	6be2                	ld	s7,24(sp)
    800029a8:	6c42                	ld	s8,16(sp)
    800029aa:	6ca2                	ld	s9,8(sp)
    800029ac:	6125                	addi	sp,sp,96
    800029ae:	8082                	ret
    brelse(bp);
    800029b0:	854a                	mv	a0,s2
    800029b2:	00000097          	auipc	ra,0x0
    800029b6:	dc6080e7          	jalr	-570(ra) # 80002778 <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    800029ba:	015c87bb          	addw	a5,s9,s5
    800029be:	00078a9b          	sext.w	s5,a5
    800029c2:	004b2703          	lw	a4,4(s6)
    800029c6:	06eaf163          	bgeu	s5,a4,80002a28 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800029ca:	41fad79b          	sraiw	a5,s5,0x1f
    800029ce:	0137d79b          	srliw	a5,a5,0x13
    800029d2:	015787bb          	addw	a5,a5,s5
    800029d6:	40d7d79b          	sraiw	a5,a5,0xd
    800029da:	01cb2583          	lw	a1,28(s6)
    800029de:	9dbd                	addw	a1,a1,a5
    800029e0:	855e                	mv	a0,s7
    800029e2:	00000097          	auipc	ra,0x0
    800029e6:	c66080e7          	jalr	-922(ra) # 80002648 <bread>
    800029ea:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800029ec:	004b2503          	lw	a0,4(s6)
    800029f0:	000a849b          	sext.w	s1,s5
    800029f4:	8762                	mv	a4,s8
    800029f6:	faa4fde3          	bgeu	s1,a0,800029b0 <balloc+0xa6>
      m = 1 << (bi % 8);
    800029fa:	00777693          	andi	a3,a4,7
    800029fe:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) {  // Is block free?
    80002a02:	41f7579b          	sraiw	a5,a4,0x1f
    80002a06:	01d7d79b          	srliw	a5,a5,0x1d
    80002a0a:	9fb9                	addw	a5,a5,a4
    80002a0c:	4037d79b          	sraiw	a5,a5,0x3
    80002a10:	00f90633          	add	a2,s2,a5
    80002a14:	05864603          	lbu	a2,88(a2)
    80002a18:	00c6f5b3          	and	a1,a3,a2
    80002a1c:	d585                	beqz	a1,80002944 <balloc+0x3a>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002a1e:	2705                	addiw	a4,a4,1
    80002a20:	2485                	addiw	s1,s1,1
    80002a22:	fd471ae3          	bne	a4,s4,800029f6 <balloc+0xec>
    80002a26:	b769                	j	800029b0 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80002a28:	00006517          	auipc	a0,0x6
    80002a2c:	a8050513          	addi	a0,a0,-1408 # 800084a8 <syscalls+0x100>
    80002a30:	00003097          	auipc	ra,0x3
    80002a34:	546080e7          	jalr	1350(ra) # 80005f76 <printf>
  return 0;
    80002a38:	4481                	li	s1,0
    80002a3a:	bfa9                	j	80002994 <balloc+0x8a>

0000000080002a3c <bmap>:
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint bmap(struct inode *ip, uint bn) {
    80002a3c:	7179                	addi	sp,sp,-48
    80002a3e:	f406                	sd	ra,40(sp)
    80002a40:	f022                	sd	s0,32(sp)
    80002a42:	ec26                	sd	s1,24(sp)
    80002a44:	e84a                	sd	s2,16(sp)
    80002a46:	e44e                	sd	s3,8(sp)
    80002a48:	e052                	sd	s4,0(sp)
    80002a4a:	1800                	addi	s0,sp,48
    80002a4c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    80002a4e:	47ad                	li	a5,11
    80002a50:	02b7e863          	bltu	a5,a1,80002a80 <bmap+0x44>
    if ((addr = ip->addrs[bn]) == 0) {
    80002a54:	02059793          	slli	a5,a1,0x20
    80002a58:	01e7d593          	srli	a1,a5,0x1e
    80002a5c:	00b504b3          	add	s1,a0,a1
    80002a60:	0504a903          	lw	s2,80(s1)
    80002a64:	06091e63          	bnez	s2,80002ae0 <bmap+0xa4>
      addr = balloc(ip->dev);
    80002a68:	4108                	lw	a0,0(a0)
    80002a6a:	00000097          	auipc	ra,0x0
    80002a6e:	ea0080e7          	jalr	-352(ra) # 8000290a <balloc>
    80002a72:	0005091b          	sext.w	s2,a0
      if (addr == 0) return 0;
    80002a76:	06090563          	beqz	s2,80002ae0 <bmap+0xa4>
      ip->addrs[bn] = addr;
    80002a7a:	0524a823          	sw	s2,80(s1)
    80002a7e:	a08d                	j	80002ae0 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002a80:	ff45849b          	addiw	s1,a1,-12
    80002a84:	0004871b          	sext.w	a4,s1

  if (bn < NINDIRECT) {
    80002a88:	0ff00793          	li	a5,255
    80002a8c:	08e7e563          	bltu	a5,a4,80002b16 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    80002a90:	08052903          	lw	s2,128(a0)
    80002a94:	00091d63          	bnez	s2,80002aae <bmap+0x72>
      addr = balloc(ip->dev);
    80002a98:	4108                	lw	a0,0(a0)
    80002a9a:	00000097          	auipc	ra,0x0
    80002a9e:	e70080e7          	jalr	-400(ra) # 8000290a <balloc>
    80002aa2:	0005091b          	sext.w	s2,a0
      if (addr == 0) return 0;
    80002aa6:	02090d63          	beqz	s2,80002ae0 <bmap+0xa4>
      ip->addrs[NDIRECT] = addr;
    80002aaa:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002aae:	85ca                	mv	a1,s2
    80002ab0:	0009a503          	lw	a0,0(s3)
    80002ab4:	00000097          	auipc	ra,0x0
    80002ab8:	b94080e7          	jalr	-1132(ra) # 80002648 <bread>
    80002abc:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    80002abe:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    80002ac2:	02049713          	slli	a4,s1,0x20
    80002ac6:	01e75593          	srli	a1,a4,0x1e
    80002aca:	00b784b3          	add	s1,a5,a1
    80002ace:	0004a903          	lw	s2,0(s1)
    80002ad2:	02090063          	beqz	s2,80002af2 <bmap+0xb6>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002ad6:	8552                	mv	a0,s4
    80002ad8:	00000097          	auipc	ra,0x0
    80002adc:	ca0080e7          	jalr	-864(ra) # 80002778 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002ae0:	854a                	mv	a0,s2
    80002ae2:	70a2                	ld	ra,40(sp)
    80002ae4:	7402                	ld	s0,32(sp)
    80002ae6:	64e2                	ld	s1,24(sp)
    80002ae8:	6942                	ld	s2,16(sp)
    80002aea:	69a2                	ld	s3,8(sp)
    80002aec:	6a02                	ld	s4,0(sp)
    80002aee:	6145                	addi	sp,sp,48
    80002af0:	8082                	ret
      addr = balloc(ip->dev);
    80002af2:	0009a503          	lw	a0,0(s3)
    80002af6:	00000097          	auipc	ra,0x0
    80002afa:	e14080e7          	jalr	-492(ra) # 8000290a <balloc>
    80002afe:	0005091b          	sext.w	s2,a0
      if (addr) {
    80002b02:	fc090ae3          	beqz	s2,80002ad6 <bmap+0x9a>
        a[bn] = addr;
    80002b06:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002b0a:	8552                	mv	a0,s4
    80002b0c:	00001097          	auipc	ra,0x1
    80002b10:	ef6080e7          	jalr	-266(ra) # 80003a02 <log_write>
    80002b14:	b7c9                	j	80002ad6 <bmap+0x9a>
  panic("bmap: out of range");
    80002b16:	00006517          	auipc	a0,0x6
    80002b1a:	9aa50513          	addi	a0,a0,-1622 # 800084c0 <syscalls+0x118>
    80002b1e:	00003097          	auipc	ra,0x3
    80002b22:	40e080e7          	jalr	1038(ra) # 80005f2c <panic>

0000000080002b26 <iget>:
static struct inode *iget(uint dev, uint inum) {
    80002b26:	7179                	addi	sp,sp,-48
    80002b28:	f406                	sd	ra,40(sp)
    80002b2a:	f022                	sd	s0,32(sp)
    80002b2c:	ec26                	sd	s1,24(sp)
    80002b2e:	e84a                	sd	s2,16(sp)
    80002b30:	e44e                	sd	s3,8(sp)
    80002b32:	e052                	sd	s4,0(sp)
    80002b34:	1800                	addi	s0,sp,48
    80002b36:	89aa                	mv	s3,a0
    80002b38:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002b3a:	0009c517          	auipc	a0,0x9c
    80002b3e:	2e650513          	addi	a0,a0,742 # 8009ee20 <itable>
    80002b42:	00004097          	auipc	ra,0x4
    80002b46:	922080e7          	jalr	-1758(ra) # 80006464 <acquire>
  empty = 0;
    80002b4a:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80002b4c:	0009c497          	auipc	s1,0x9c
    80002b50:	2ec48493          	addi	s1,s1,748 # 8009ee38 <itable+0x18>
    80002b54:	0009e697          	auipc	a3,0x9e
    80002b58:	d7468693          	addi	a3,a3,-652 # 800a08c8 <log>
    80002b5c:	a039                	j	80002b6a <iget+0x44>
    if (empty == 0 && ip->ref == 0)  // Remember empty slot.
    80002b5e:	02090b63          	beqz	s2,80002b94 <iget+0x6e>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80002b62:	08848493          	addi	s1,s1,136
    80002b66:	02d48a63          	beq	s1,a3,80002b9a <iget+0x74>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    80002b6a:	449c                	lw	a5,8(s1)
    80002b6c:	fef059e3          	blez	a5,80002b5e <iget+0x38>
    80002b70:	4098                	lw	a4,0(s1)
    80002b72:	ff3716e3          	bne	a4,s3,80002b5e <iget+0x38>
    80002b76:	40d8                	lw	a4,4(s1)
    80002b78:	ff4713e3          	bne	a4,s4,80002b5e <iget+0x38>
      ip->ref++;
    80002b7c:	2785                	addiw	a5,a5,1
    80002b7e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002b80:	0009c517          	auipc	a0,0x9c
    80002b84:	2a050513          	addi	a0,a0,672 # 8009ee20 <itable>
    80002b88:	00004097          	auipc	ra,0x4
    80002b8c:	990080e7          	jalr	-1648(ra) # 80006518 <release>
      return ip;
    80002b90:	8926                	mv	s2,s1
    80002b92:	a03d                	j	80002bc0 <iget+0x9a>
    if (empty == 0 && ip->ref == 0)  // Remember empty slot.
    80002b94:	f7f9                	bnez	a5,80002b62 <iget+0x3c>
    80002b96:	8926                	mv	s2,s1
    80002b98:	b7e9                	j	80002b62 <iget+0x3c>
  if (empty == 0) panic("iget: no inodes");
    80002b9a:	02090c63          	beqz	s2,80002bd2 <iget+0xac>
  ip->dev = dev;
    80002b9e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002ba2:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002ba6:	4785                	li	a5,1
    80002ba8:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002bac:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002bb0:	0009c517          	auipc	a0,0x9c
    80002bb4:	27050513          	addi	a0,a0,624 # 8009ee20 <itable>
    80002bb8:	00004097          	auipc	ra,0x4
    80002bbc:	960080e7          	jalr	-1696(ra) # 80006518 <release>
}
    80002bc0:	854a                	mv	a0,s2
    80002bc2:	70a2                	ld	ra,40(sp)
    80002bc4:	7402                	ld	s0,32(sp)
    80002bc6:	64e2                	ld	s1,24(sp)
    80002bc8:	6942                	ld	s2,16(sp)
    80002bca:	69a2                	ld	s3,8(sp)
    80002bcc:	6a02                	ld	s4,0(sp)
    80002bce:	6145                	addi	sp,sp,48
    80002bd0:	8082                	ret
  if (empty == 0) panic("iget: no inodes");
    80002bd2:	00006517          	auipc	a0,0x6
    80002bd6:	90650513          	addi	a0,a0,-1786 # 800084d8 <syscalls+0x130>
    80002bda:	00003097          	auipc	ra,0x3
    80002bde:	352080e7          	jalr	850(ra) # 80005f2c <panic>

0000000080002be2 <fsinit>:
void fsinit(int dev) {
    80002be2:	7179                	addi	sp,sp,-48
    80002be4:	f406                	sd	ra,40(sp)
    80002be6:	f022                	sd	s0,32(sp)
    80002be8:	ec26                	sd	s1,24(sp)
    80002bea:	e84a                	sd	s2,16(sp)
    80002bec:	e44e                	sd	s3,8(sp)
    80002bee:	1800                	addi	s0,sp,48
    80002bf0:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002bf2:	4585                	li	a1,1
    80002bf4:	00000097          	auipc	ra,0x0
    80002bf8:	a54080e7          	jalr	-1452(ra) # 80002648 <bread>
    80002bfc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002bfe:	0009c997          	auipc	s3,0x9c
    80002c02:	20298993          	addi	s3,s3,514 # 8009ee00 <sb>
    80002c06:	02000613          	li	a2,32
    80002c0a:	05850593          	addi	a1,a0,88
    80002c0e:	854e                	mv	a0,s3
    80002c10:	ffffd097          	auipc	ra,0xffffd
    80002c14:	5c6080e7          	jalr	1478(ra) # 800001d6 <memmove>
  brelse(bp);
    80002c18:	8526                	mv	a0,s1
    80002c1a:	00000097          	auipc	ra,0x0
    80002c1e:	b5e080e7          	jalr	-1186(ra) # 80002778 <brelse>
  if (sb.magic != FSMAGIC) panic("invalid file system");
    80002c22:	0009a703          	lw	a4,0(s3)
    80002c26:	102037b7          	lui	a5,0x10203
    80002c2a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002c2e:	02f71263          	bne	a4,a5,80002c52 <fsinit+0x70>
  initlog(dev, &sb);
    80002c32:	0009c597          	auipc	a1,0x9c
    80002c36:	1ce58593          	addi	a1,a1,462 # 8009ee00 <sb>
    80002c3a:	854a                	mv	a0,s2
    80002c3c:	00001097          	auipc	ra,0x1
    80002c40:	b4a080e7          	jalr	-1206(ra) # 80003786 <initlog>
}
    80002c44:	70a2                	ld	ra,40(sp)
    80002c46:	7402                	ld	s0,32(sp)
    80002c48:	64e2                	ld	s1,24(sp)
    80002c4a:	6942                	ld	s2,16(sp)
    80002c4c:	69a2                	ld	s3,8(sp)
    80002c4e:	6145                	addi	sp,sp,48
    80002c50:	8082                	ret
  if (sb.magic != FSMAGIC) panic("invalid file system");
    80002c52:	00006517          	auipc	a0,0x6
    80002c56:	89650513          	addi	a0,a0,-1898 # 800084e8 <syscalls+0x140>
    80002c5a:	00003097          	auipc	ra,0x3
    80002c5e:	2d2080e7          	jalr	722(ra) # 80005f2c <panic>

0000000080002c62 <iinit>:
void iinit() {
    80002c62:	7179                	addi	sp,sp,-48
    80002c64:	f406                	sd	ra,40(sp)
    80002c66:	f022                	sd	s0,32(sp)
    80002c68:	ec26                	sd	s1,24(sp)
    80002c6a:	e84a                	sd	s2,16(sp)
    80002c6c:	e44e                	sd	s3,8(sp)
    80002c6e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002c70:	00006597          	auipc	a1,0x6
    80002c74:	89058593          	addi	a1,a1,-1904 # 80008500 <syscalls+0x158>
    80002c78:	0009c517          	auipc	a0,0x9c
    80002c7c:	1a850513          	addi	a0,a0,424 # 8009ee20 <itable>
    80002c80:	00003097          	auipc	ra,0x3
    80002c84:	754080e7          	jalr	1876(ra) # 800063d4 <initlock>
  for (i = 0; i < NINODE; i++) {
    80002c88:	0009c497          	auipc	s1,0x9c
    80002c8c:	1c048493          	addi	s1,s1,448 # 8009ee48 <itable+0x28>
    80002c90:	0009e997          	auipc	s3,0x9e
    80002c94:	c4898993          	addi	s3,s3,-952 # 800a08d8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c98:	00006917          	auipc	s2,0x6
    80002c9c:	87090913          	addi	s2,s2,-1936 # 80008508 <syscalls+0x160>
    80002ca0:	85ca                	mv	a1,s2
    80002ca2:	8526                	mv	a0,s1
    80002ca4:	00001097          	auipc	ra,0x1
    80002ca8:	e42080e7          	jalr	-446(ra) # 80003ae6 <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    80002cac:	08848493          	addi	s1,s1,136
    80002cb0:	ff3498e3          	bne	s1,s3,80002ca0 <iinit+0x3e>
}
    80002cb4:	70a2                	ld	ra,40(sp)
    80002cb6:	7402                	ld	s0,32(sp)
    80002cb8:	64e2                	ld	s1,24(sp)
    80002cba:	6942                	ld	s2,16(sp)
    80002cbc:	69a2                	ld	s3,8(sp)
    80002cbe:	6145                	addi	sp,sp,48
    80002cc0:	8082                	ret

0000000080002cc2 <ialloc>:
struct inode *ialloc(uint dev, short type) {
    80002cc2:	715d                	addi	sp,sp,-80
    80002cc4:	e486                	sd	ra,72(sp)
    80002cc6:	e0a2                	sd	s0,64(sp)
    80002cc8:	fc26                	sd	s1,56(sp)
    80002cca:	f84a                	sd	s2,48(sp)
    80002ccc:	f44e                	sd	s3,40(sp)
    80002cce:	f052                	sd	s4,32(sp)
    80002cd0:	ec56                	sd	s5,24(sp)
    80002cd2:	e85a                	sd	s6,16(sp)
    80002cd4:	e45e                	sd	s7,8(sp)
    80002cd6:	0880                	addi	s0,sp,80
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002cd8:	0009c717          	auipc	a4,0x9c
    80002cdc:	13472703          	lw	a4,308(a4) # 8009ee0c <sb+0xc>
    80002ce0:	4785                	li	a5,1
    80002ce2:	04e7fa63          	bgeu	a5,a4,80002d36 <ialloc+0x74>
    80002ce6:	8aaa                	mv	s5,a0
    80002ce8:	8bae                	mv	s7,a1
    80002cea:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002cec:	0009ca17          	auipc	s4,0x9c
    80002cf0:	114a0a13          	addi	s4,s4,276 # 8009ee00 <sb>
    80002cf4:	00048b1b          	sext.w	s6,s1
    80002cf8:	0044d593          	srli	a1,s1,0x4
    80002cfc:	018a2783          	lw	a5,24(s4)
    80002d00:	9dbd                	addw	a1,a1,a5
    80002d02:	8556                	mv	a0,s5
    80002d04:	00000097          	auipc	ra,0x0
    80002d08:	944080e7          	jalr	-1724(ra) # 80002648 <bread>
    80002d0c:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80002d0e:	05850993          	addi	s3,a0,88
    80002d12:	00f4f793          	andi	a5,s1,15
    80002d16:	079a                	slli	a5,a5,0x6
    80002d18:	99be                	add	s3,s3,a5
    if (dip->type == 0) {  // a free inode
    80002d1a:	00099783          	lh	a5,0(s3)
    80002d1e:	c3a1                	beqz	a5,80002d5e <ialloc+0x9c>
    brelse(bp);
    80002d20:	00000097          	auipc	ra,0x0
    80002d24:	a58080e7          	jalr	-1448(ra) # 80002778 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002d28:	0485                	addi	s1,s1,1
    80002d2a:	00ca2703          	lw	a4,12(s4)
    80002d2e:	0004879b          	sext.w	a5,s1
    80002d32:	fce7e1e3          	bltu	a5,a4,80002cf4 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002d36:	00005517          	auipc	a0,0x5
    80002d3a:	7da50513          	addi	a0,a0,2010 # 80008510 <syscalls+0x168>
    80002d3e:	00003097          	auipc	ra,0x3
    80002d42:	238080e7          	jalr	568(ra) # 80005f76 <printf>
  return 0;
    80002d46:	4501                	li	a0,0
}
    80002d48:	60a6                	ld	ra,72(sp)
    80002d4a:	6406                	ld	s0,64(sp)
    80002d4c:	74e2                	ld	s1,56(sp)
    80002d4e:	7942                	ld	s2,48(sp)
    80002d50:	79a2                	ld	s3,40(sp)
    80002d52:	7a02                	ld	s4,32(sp)
    80002d54:	6ae2                	ld	s5,24(sp)
    80002d56:	6b42                	ld	s6,16(sp)
    80002d58:	6ba2                	ld	s7,8(sp)
    80002d5a:	6161                	addi	sp,sp,80
    80002d5c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002d5e:	04000613          	li	a2,64
    80002d62:	4581                	li	a1,0
    80002d64:	854e                	mv	a0,s3
    80002d66:	ffffd097          	auipc	ra,0xffffd
    80002d6a:	414080e7          	jalr	1044(ra) # 8000017a <memset>
      dip->type = type;
    80002d6e:	01799023          	sh	s7,0(s3)
      log_write(bp);  // mark it allocated on the disk
    80002d72:	854a                	mv	a0,s2
    80002d74:	00001097          	auipc	ra,0x1
    80002d78:	c8e080e7          	jalr	-882(ra) # 80003a02 <log_write>
      brelse(bp);
    80002d7c:	854a                	mv	a0,s2
    80002d7e:	00000097          	auipc	ra,0x0
    80002d82:	9fa080e7          	jalr	-1542(ra) # 80002778 <brelse>
      return iget(dev, inum);
    80002d86:	85da                	mv	a1,s6
    80002d88:	8556                	mv	a0,s5
    80002d8a:	00000097          	auipc	ra,0x0
    80002d8e:	d9c080e7          	jalr	-612(ra) # 80002b26 <iget>
    80002d92:	bf5d                	j	80002d48 <ialloc+0x86>

0000000080002d94 <iupdate>:
void iupdate(struct inode *ip) {
    80002d94:	1101                	addi	sp,sp,-32
    80002d96:	ec06                	sd	ra,24(sp)
    80002d98:	e822                	sd	s0,16(sp)
    80002d9a:	e426                	sd	s1,8(sp)
    80002d9c:	e04a                	sd	s2,0(sp)
    80002d9e:	1000                	addi	s0,sp,32
    80002da0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002da2:	415c                	lw	a5,4(a0)
    80002da4:	0047d79b          	srliw	a5,a5,0x4
    80002da8:	0009c597          	auipc	a1,0x9c
    80002dac:	0705a583          	lw	a1,112(a1) # 8009ee18 <sb+0x18>
    80002db0:	9dbd                	addw	a1,a1,a5
    80002db2:	4108                	lw	a0,0(a0)
    80002db4:	00000097          	auipc	ra,0x0
    80002db8:	894080e7          	jalr	-1900(ra) # 80002648 <bread>
    80002dbc:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002dbe:	05850793          	addi	a5,a0,88
    80002dc2:	40d8                	lw	a4,4(s1)
    80002dc4:	8b3d                	andi	a4,a4,15
    80002dc6:	071a                	slli	a4,a4,0x6
    80002dc8:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002dca:	04449703          	lh	a4,68(s1)
    80002dce:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002dd2:	04649703          	lh	a4,70(s1)
    80002dd6:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002dda:	04849703          	lh	a4,72(s1)
    80002dde:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002de2:	04a49703          	lh	a4,74(s1)
    80002de6:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002dea:	44f8                	lw	a4,76(s1)
    80002dec:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002dee:	03400613          	li	a2,52
    80002df2:	05048593          	addi	a1,s1,80
    80002df6:	00c78513          	addi	a0,a5,12
    80002dfa:	ffffd097          	auipc	ra,0xffffd
    80002dfe:	3dc080e7          	jalr	988(ra) # 800001d6 <memmove>
  log_write(bp);
    80002e02:	854a                	mv	a0,s2
    80002e04:	00001097          	auipc	ra,0x1
    80002e08:	bfe080e7          	jalr	-1026(ra) # 80003a02 <log_write>
  brelse(bp);
    80002e0c:	854a                	mv	a0,s2
    80002e0e:	00000097          	auipc	ra,0x0
    80002e12:	96a080e7          	jalr	-1686(ra) # 80002778 <brelse>
}
    80002e16:	60e2                	ld	ra,24(sp)
    80002e18:	6442                	ld	s0,16(sp)
    80002e1a:	64a2                	ld	s1,8(sp)
    80002e1c:	6902                	ld	s2,0(sp)
    80002e1e:	6105                	addi	sp,sp,32
    80002e20:	8082                	ret

0000000080002e22 <idup>:
struct inode *idup(struct inode *ip) {
    80002e22:	1101                	addi	sp,sp,-32
    80002e24:	ec06                	sd	ra,24(sp)
    80002e26:	e822                	sd	s0,16(sp)
    80002e28:	e426                	sd	s1,8(sp)
    80002e2a:	1000                	addi	s0,sp,32
    80002e2c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e2e:	0009c517          	auipc	a0,0x9c
    80002e32:	ff250513          	addi	a0,a0,-14 # 8009ee20 <itable>
    80002e36:	00003097          	auipc	ra,0x3
    80002e3a:	62e080e7          	jalr	1582(ra) # 80006464 <acquire>
  ip->ref++;
    80002e3e:	449c                	lw	a5,8(s1)
    80002e40:	2785                	addiw	a5,a5,1
    80002e42:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e44:	0009c517          	auipc	a0,0x9c
    80002e48:	fdc50513          	addi	a0,a0,-36 # 8009ee20 <itable>
    80002e4c:	00003097          	auipc	ra,0x3
    80002e50:	6cc080e7          	jalr	1740(ra) # 80006518 <release>
}
    80002e54:	8526                	mv	a0,s1
    80002e56:	60e2                	ld	ra,24(sp)
    80002e58:	6442                	ld	s0,16(sp)
    80002e5a:	64a2                	ld	s1,8(sp)
    80002e5c:	6105                	addi	sp,sp,32
    80002e5e:	8082                	ret

0000000080002e60 <ilock>:
void ilock(struct inode *ip) {
    80002e60:	1101                	addi	sp,sp,-32
    80002e62:	ec06                	sd	ra,24(sp)
    80002e64:	e822                	sd	s0,16(sp)
    80002e66:	e426                	sd	s1,8(sp)
    80002e68:	e04a                	sd	s2,0(sp)
    80002e6a:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1) panic("ilock");
    80002e6c:	c115                	beqz	a0,80002e90 <ilock+0x30>
    80002e6e:	84aa                	mv	s1,a0
    80002e70:	451c                	lw	a5,8(a0)
    80002e72:	00f05f63          	blez	a5,80002e90 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002e76:	0541                	addi	a0,a0,16
    80002e78:	00001097          	auipc	ra,0x1
    80002e7c:	ca8080e7          	jalr	-856(ra) # 80003b20 <acquiresleep>
  if (ip->valid == 0) {
    80002e80:	40bc                	lw	a5,64(s1)
    80002e82:	cf99                	beqz	a5,80002ea0 <ilock+0x40>
}
    80002e84:	60e2                	ld	ra,24(sp)
    80002e86:	6442                	ld	s0,16(sp)
    80002e88:	64a2                	ld	s1,8(sp)
    80002e8a:	6902                	ld	s2,0(sp)
    80002e8c:	6105                	addi	sp,sp,32
    80002e8e:	8082                	ret
  if (ip == 0 || ip->ref < 1) panic("ilock");
    80002e90:	00005517          	auipc	a0,0x5
    80002e94:	69850513          	addi	a0,a0,1688 # 80008528 <syscalls+0x180>
    80002e98:	00003097          	auipc	ra,0x3
    80002e9c:	094080e7          	jalr	148(ra) # 80005f2c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ea0:	40dc                	lw	a5,4(s1)
    80002ea2:	0047d79b          	srliw	a5,a5,0x4
    80002ea6:	0009c597          	auipc	a1,0x9c
    80002eaa:	f725a583          	lw	a1,-142(a1) # 8009ee18 <sb+0x18>
    80002eae:	9dbd                	addw	a1,a1,a5
    80002eb0:	4088                	lw	a0,0(s1)
    80002eb2:	fffff097          	auipc	ra,0xfffff
    80002eb6:	796080e7          	jalr	1942(ra) # 80002648 <bread>
    80002eba:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002ebc:	05850593          	addi	a1,a0,88
    80002ec0:	40dc                	lw	a5,4(s1)
    80002ec2:	8bbd                	andi	a5,a5,15
    80002ec4:	079a                	slli	a5,a5,0x6
    80002ec6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ec8:	00059783          	lh	a5,0(a1)
    80002ecc:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002ed0:	00259783          	lh	a5,2(a1)
    80002ed4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002ed8:	00459783          	lh	a5,4(a1)
    80002edc:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002ee0:	00659783          	lh	a5,6(a1)
    80002ee4:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002ee8:	459c                	lw	a5,8(a1)
    80002eea:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002eec:	03400613          	li	a2,52
    80002ef0:	05b1                	addi	a1,a1,12
    80002ef2:	05048513          	addi	a0,s1,80
    80002ef6:	ffffd097          	auipc	ra,0xffffd
    80002efa:	2e0080e7          	jalr	736(ra) # 800001d6 <memmove>
    brelse(bp);
    80002efe:	854a                	mv	a0,s2
    80002f00:	00000097          	auipc	ra,0x0
    80002f04:	878080e7          	jalr	-1928(ra) # 80002778 <brelse>
    ip->valid = 1;
    80002f08:	4785                	li	a5,1
    80002f0a:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0) panic("ilock: no type");
    80002f0c:	04449783          	lh	a5,68(s1)
    80002f10:	fbb5                	bnez	a5,80002e84 <ilock+0x24>
    80002f12:	00005517          	auipc	a0,0x5
    80002f16:	61e50513          	addi	a0,a0,1566 # 80008530 <syscalls+0x188>
    80002f1a:	00003097          	auipc	ra,0x3
    80002f1e:	012080e7          	jalr	18(ra) # 80005f2c <panic>

0000000080002f22 <iunlock>:
void iunlock(struct inode *ip) {
    80002f22:	1101                	addi	sp,sp,-32
    80002f24:	ec06                	sd	ra,24(sp)
    80002f26:	e822                	sd	s0,16(sp)
    80002f28:	e426                	sd	s1,8(sp)
    80002f2a:	e04a                	sd	s2,0(sp)
    80002f2c:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
    80002f2e:	c905                	beqz	a0,80002f5e <iunlock+0x3c>
    80002f30:	84aa                	mv	s1,a0
    80002f32:	01050913          	addi	s2,a0,16
    80002f36:	854a                	mv	a0,s2
    80002f38:	00001097          	auipc	ra,0x1
    80002f3c:	c82080e7          	jalr	-894(ra) # 80003bba <holdingsleep>
    80002f40:	cd19                	beqz	a0,80002f5e <iunlock+0x3c>
    80002f42:	449c                	lw	a5,8(s1)
    80002f44:	00f05d63          	blez	a5,80002f5e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002f48:	854a                	mv	a0,s2
    80002f4a:	00001097          	auipc	ra,0x1
    80002f4e:	c2c080e7          	jalr	-980(ra) # 80003b76 <releasesleep>
}
    80002f52:	60e2                	ld	ra,24(sp)
    80002f54:	6442                	ld	s0,16(sp)
    80002f56:	64a2                	ld	s1,8(sp)
    80002f58:	6902                	ld	s2,0(sp)
    80002f5a:	6105                	addi	sp,sp,32
    80002f5c:	8082                	ret
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
    80002f5e:	00005517          	auipc	a0,0x5
    80002f62:	5e250513          	addi	a0,a0,1506 # 80008540 <syscalls+0x198>
    80002f66:	00003097          	auipc	ra,0x3
    80002f6a:	fc6080e7          	jalr	-58(ra) # 80005f2c <panic>

0000000080002f6e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip) {
    80002f6e:	7179                	addi	sp,sp,-48
    80002f70:	f406                	sd	ra,40(sp)
    80002f72:	f022                	sd	s0,32(sp)
    80002f74:	ec26                	sd	s1,24(sp)
    80002f76:	e84a                	sd	s2,16(sp)
    80002f78:	e44e                	sd	s3,8(sp)
    80002f7a:	e052                	sd	s4,0(sp)
    80002f7c:	1800                	addi	s0,sp,48
    80002f7e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    80002f80:	05050493          	addi	s1,a0,80
    80002f84:	08050913          	addi	s2,a0,128
    80002f88:	a021                	j	80002f90 <itrunc+0x22>
    80002f8a:	0491                	addi	s1,s1,4
    80002f8c:	01248d63          	beq	s1,s2,80002fa6 <itrunc+0x38>
    if (ip->addrs[i]) {
    80002f90:	408c                	lw	a1,0(s1)
    80002f92:	dde5                	beqz	a1,80002f8a <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002f94:	0009a503          	lw	a0,0(s3)
    80002f98:	00000097          	auipc	ra,0x0
    80002f9c:	8f6080e7          	jalr	-1802(ra) # 8000288e <bfree>
      ip->addrs[i] = 0;
    80002fa0:	0004a023          	sw	zero,0(s1)
    80002fa4:	b7dd                	j	80002f8a <itrunc+0x1c>
    }
  }

  if (ip->addrs[NDIRECT]) {
    80002fa6:	0809a583          	lw	a1,128(s3)
    80002faa:	e185                	bnez	a1,80002fca <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002fac:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002fb0:	854e                	mv	a0,s3
    80002fb2:	00000097          	auipc	ra,0x0
    80002fb6:	de2080e7          	jalr	-542(ra) # 80002d94 <iupdate>
}
    80002fba:	70a2                	ld	ra,40(sp)
    80002fbc:	7402                	ld	s0,32(sp)
    80002fbe:	64e2                	ld	s1,24(sp)
    80002fc0:	6942                	ld	s2,16(sp)
    80002fc2:	69a2                	ld	s3,8(sp)
    80002fc4:	6a02                	ld	s4,0(sp)
    80002fc6:	6145                	addi	sp,sp,48
    80002fc8:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002fca:	0009a503          	lw	a0,0(s3)
    80002fce:	fffff097          	auipc	ra,0xfffff
    80002fd2:	67a080e7          	jalr	1658(ra) # 80002648 <bread>
    80002fd6:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    80002fd8:	05850493          	addi	s1,a0,88
    80002fdc:	45850913          	addi	s2,a0,1112
    80002fe0:	a021                	j	80002fe8 <itrunc+0x7a>
    80002fe2:	0491                	addi	s1,s1,4
    80002fe4:	01248b63          	beq	s1,s2,80002ffa <itrunc+0x8c>
      if (a[j]) bfree(ip->dev, a[j]);
    80002fe8:	408c                	lw	a1,0(s1)
    80002fea:	dde5                	beqz	a1,80002fe2 <itrunc+0x74>
    80002fec:	0009a503          	lw	a0,0(s3)
    80002ff0:	00000097          	auipc	ra,0x0
    80002ff4:	89e080e7          	jalr	-1890(ra) # 8000288e <bfree>
    80002ff8:	b7ed                	j	80002fe2 <itrunc+0x74>
    brelse(bp);
    80002ffa:	8552                	mv	a0,s4
    80002ffc:	fffff097          	auipc	ra,0xfffff
    80003000:	77c080e7          	jalr	1916(ra) # 80002778 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003004:	0809a583          	lw	a1,128(s3)
    80003008:	0009a503          	lw	a0,0(s3)
    8000300c:	00000097          	auipc	ra,0x0
    80003010:	882080e7          	jalr	-1918(ra) # 8000288e <bfree>
    ip->addrs[NDIRECT] = 0;
    80003014:	0809a023          	sw	zero,128(s3)
    80003018:	bf51                	j	80002fac <itrunc+0x3e>

000000008000301a <iput>:
void iput(struct inode *ip) {
    8000301a:	1101                	addi	sp,sp,-32
    8000301c:	ec06                	sd	ra,24(sp)
    8000301e:	e822                	sd	s0,16(sp)
    80003020:	e426                	sd	s1,8(sp)
    80003022:	e04a                	sd	s2,0(sp)
    80003024:	1000                	addi	s0,sp,32
    80003026:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003028:	0009c517          	auipc	a0,0x9c
    8000302c:	df850513          	addi	a0,a0,-520 # 8009ee20 <itable>
    80003030:	00003097          	auipc	ra,0x3
    80003034:	434080e7          	jalr	1076(ra) # 80006464 <acquire>
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80003038:	4498                	lw	a4,8(s1)
    8000303a:	4785                	li	a5,1
    8000303c:	02f70363          	beq	a4,a5,80003062 <iput+0x48>
  ip->ref--;
    80003040:	449c                	lw	a5,8(s1)
    80003042:	37fd                	addiw	a5,a5,-1
    80003044:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003046:	0009c517          	auipc	a0,0x9c
    8000304a:	dda50513          	addi	a0,a0,-550 # 8009ee20 <itable>
    8000304e:	00003097          	auipc	ra,0x3
    80003052:	4ca080e7          	jalr	1226(ra) # 80006518 <release>
}
    80003056:	60e2                	ld	ra,24(sp)
    80003058:	6442                	ld	s0,16(sp)
    8000305a:	64a2                	ld	s1,8(sp)
    8000305c:	6902                	ld	s2,0(sp)
    8000305e:	6105                	addi	sp,sp,32
    80003060:	8082                	ret
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80003062:	40bc                	lw	a5,64(s1)
    80003064:	dff1                	beqz	a5,80003040 <iput+0x26>
    80003066:	04a49783          	lh	a5,74(s1)
    8000306a:	fbf9                	bnez	a5,80003040 <iput+0x26>
    acquiresleep(&ip->lock);
    8000306c:	01048913          	addi	s2,s1,16
    80003070:	854a                	mv	a0,s2
    80003072:	00001097          	auipc	ra,0x1
    80003076:	aae080e7          	jalr	-1362(ra) # 80003b20 <acquiresleep>
    release(&itable.lock);
    8000307a:	0009c517          	auipc	a0,0x9c
    8000307e:	da650513          	addi	a0,a0,-602 # 8009ee20 <itable>
    80003082:	00003097          	auipc	ra,0x3
    80003086:	496080e7          	jalr	1174(ra) # 80006518 <release>
    itrunc(ip);
    8000308a:	8526                	mv	a0,s1
    8000308c:	00000097          	auipc	ra,0x0
    80003090:	ee2080e7          	jalr	-286(ra) # 80002f6e <itrunc>
    ip->type = 0;
    80003094:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003098:	8526                	mv	a0,s1
    8000309a:	00000097          	auipc	ra,0x0
    8000309e:	cfa080e7          	jalr	-774(ra) # 80002d94 <iupdate>
    ip->valid = 0;
    800030a2:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800030a6:	854a                	mv	a0,s2
    800030a8:	00001097          	auipc	ra,0x1
    800030ac:	ace080e7          	jalr	-1330(ra) # 80003b76 <releasesleep>
    acquire(&itable.lock);
    800030b0:	0009c517          	auipc	a0,0x9c
    800030b4:	d7050513          	addi	a0,a0,-656 # 8009ee20 <itable>
    800030b8:	00003097          	auipc	ra,0x3
    800030bc:	3ac080e7          	jalr	940(ra) # 80006464 <acquire>
    800030c0:	b741                	j	80003040 <iput+0x26>

00000000800030c2 <iunlockput>:
void iunlockput(struct inode *ip) {
    800030c2:	1101                	addi	sp,sp,-32
    800030c4:	ec06                	sd	ra,24(sp)
    800030c6:	e822                	sd	s0,16(sp)
    800030c8:	e426                	sd	s1,8(sp)
    800030ca:	1000                	addi	s0,sp,32
    800030cc:	84aa                	mv	s1,a0
  iunlock(ip);
    800030ce:	00000097          	auipc	ra,0x0
    800030d2:	e54080e7          	jalr	-428(ra) # 80002f22 <iunlock>
  iput(ip);
    800030d6:	8526                	mv	a0,s1
    800030d8:	00000097          	auipc	ra,0x0
    800030dc:	f42080e7          	jalr	-190(ra) # 8000301a <iput>
}
    800030e0:	60e2                	ld	ra,24(sp)
    800030e2:	6442                	ld	s0,16(sp)
    800030e4:	64a2                	ld	s1,8(sp)
    800030e6:	6105                	addi	sp,sp,32
    800030e8:	8082                	ret

00000000800030ea <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st) {
    800030ea:	1141                	addi	sp,sp,-16
    800030ec:	e422                	sd	s0,8(sp)
    800030ee:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800030f0:	411c                	lw	a5,0(a0)
    800030f2:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800030f4:	415c                	lw	a5,4(a0)
    800030f6:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800030f8:	04451783          	lh	a5,68(a0)
    800030fc:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003100:	04a51783          	lh	a5,74(a0)
    80003104:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003108:	04c56783          	lwu	a5,76(a0)
    8000310c:	e99c                	sd	a5,16(a1)
}
    8000310e:	6422                	ld	s0,8(sp)
    80003110:	0141                	addi	sp,sp,16
    80003112:	8082                	ret

0000000080003114 <readi>:
// otherwise, dst is a kernel address.
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off) return 0;
    80003114:	457c                	lw	a5,76(a0)
    80003116:	0ed7e963          	bltu	a5,a3,80003208 <readi+0xf4>
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
    8000311a:	7159                	addi	sp,sp,-112
    8000311c:	f486                	sd	ra,104(sp)
    8000311e:	f0a2                	sd	s0,96(sp)
    80003120:	eca6                	sd	s1,88(sp)
    80003122:	e8ca                	sd	s2,80(sp)
    80003124:	e4ce                	sd	s3,72(sp)
    80003126:	e0d2                	sd	s4,64(sp)
    80003128:	fc56                	sd	s5,56(sp)
    8000312a:	f85a                	sd	s6,48(sp)
    8000312c:	f45e                	sd	s7,40(sp)
    8000312e:	f062                	sd	s8,32(sp)
    80003130:	ec66                	sd	s9,24(sp)
    80003132:	e86a                	sd	s10,16(sp)
    80003134:	e46e                	sd	s11,8(sp)
    80003136:	1880                	addi	s0,sp,112
    80003138:	8b2a                	mv	s6,a0
    8000313a:	8bae                	mv	s7,a1
    8000313c:	8a32                	mv	s4,a2
    8000313e:	84b6                	mv	s1,a3
    80003140:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off) return 0;
    80003142:	9f35                	addw	a4,a4,a3
    80003144:	4501                	li	a0,0
    80003146:	0ad76063          	bltu	a4,a3,800031e6 <readi+0xd2>
  if (off + n > ip->size) n = ip->size - off;
    8000314a:	00e7f463          	bgeu	a5,a4,80003152 <readi+0x3e>
    8000314e:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003152:	0a0a8963          	beqz	s5,80003204 <readi+0xf0>
    80003156:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0) break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003158:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000315c:	5c7d                	li	s8,-1
    8000315e:	a82d                	j	80003198 <readi+0x84>
    80003160:	020d1d93          	slli	s11,s10,0x20
    80003164:	020ddd93          	srli	s11,s11,0x20
    80003168:	05890613          	addi	a2,s2,88
    8000316c:	86ee                	mv	a3,s11
    8000316e:	963a                	add	a2,a2,a4
    80003170:	85d2                	mv	a1,s4
    80003172:	855e                	mv	a0,s7
    80003174:	fffff097          	auipc	ra,0xfffff
    80003178:	a8a080e7          	jalr	-1398(ra) # 80001bfe <either_copyout>
    8000317c:	05850d63          	beq	a0,s8,800031d6 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003180:	854a                	mv	a0,s2
    80003182:	fffff097          	auipc	ra,0xfffff
    80003186:	5f6080e7          	jalr	1526(ra) # 80002778 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    8000318a:	013d09bb          	addw	s3,s10,s3
    8000318e:	009d04bb          	addw	s1,s10,s1
    80003192:	9a6e                	add	s4,s4,s11
    80003194:	0559f763          	bgeu	s3,s5,800031e2 <readi+0xce>
    uint addr = bmap(ip, off / BSIZE);
    80003198:	00a4d59b          	srliw	a1,s1,0xa
    8000319c:	855a                	mv	a0,s6
    8000319e:	00000097          	auipc	ra,0x0
    800031a2:	89e080e7          	jalr	-1890(ra) # 80002a3c <bmap>
    800031a6:	0005059b          	sext.w	a1,a0
    if (addr == 0) break;
    800031aa:	cd85                	beqz	a1,800031e2 <readi+0xce>
    bp = bread(ip->dev, addr);
    800031ac:	000b2503          	lw	a0,0(s6)
    800031b0:	fffff097          	auipc	ra,0xfffff
    800031b4:	498080e7          	jalr	1176(ra) # 80002648 <bread>
    800031b8:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    800031ba:	3ff4f713          	andi	a4,s1,1023
    800031be:	40ec87bb          	subw	a5,s9,a4
    800031c2:	413a86bb          	subw	a3,s5,s3
    800031c6:	8d3e                	mv	s10,a5
    800031c8:	2781                	sext.w	a5,a5
    800031ca:	0006861b          	sext.w	a2,a3
    800031ce:	f8f679e3          	bgeu	a2,a5,80003160 <readi+0x4c>
    800031d2:	8d36                	mv	s10,a3
    800031d4:	b771                	j	80003160 <readi+0x4c>
      brelse(bp);
    800031d6:	854a                	mv	a0,s2
    800031d8:	fffff097          	auipc	ra,0xfffff
    800031dc:	5a0080e7          	jalr	1440(ra) # 80002778 <brelse>
      tot = -1;
    800031e0:	59fd                	li	s3,-1
  }
  return tot;
    800031e2:	0009851b          	sext.w	a0,s3
}
    800031e6:	70a6                	ld	ra,104(sp)
    800031e8:	7406                	ld	s0,96(sp)
    800031ea:	64e6                	ld	s1,88(sp)
    800031ec:	6946                	ld	s2,80(sp)
    800031ee:	69a6                	ld	s3,72(sp)
    800031f0:	6a06                	ld	s4,64(sp)
    800031f2:	7ae2                	ld	s5,56(sp)
    800031f4:	7b42                	ld	s6,48(sp)
    800031f6:	7ba2                	ld	s7,40(sp)
    800031f8:	7c02                	ld	s8,32(sp)
    800031fa:	6ce2                	ld	s9,24(sp)
    800031fc:	6d42                	ld	s10,16(sp)
    800031fe:	6da2                	ld	s11,8(sp)
    80003200:	6165                	addi	sp,sp,112
    80003202:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003204:	89d6                	mv	s3,s5
    80003206:	bff1                	j	800031e2 <readi+0xce>
  if (off > ip->size || off + n < off) return 0;
    80003208:	4501                	li	a0,0
}
    8000320a:	8082                	ret

000000008000320c <writei>:
// there was an error of some kind.
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off) return -1;
    8000320c:	457c                	lw	a5,76(a0)
    8000320e:	10d7e863          	bltu	a5,a3,8000331e <writei+0x112>
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
    80003212:	7159                	addi	sp,sp,-112
    80003214:	f486                	sd	ra,104(sp)
    80003216:	f0a2                	sd	s0,96(sp)
    80003218:	eca6                	sd	s1,88(sp)
    8000321a:	e8ca                	sd	s2,80(sp)
    8000321c:	e4ce                	sd	s3,72(sp)
    8000321e:	e0d2                	sd	s4,64(sp)
    80003220:	fc56                	sd	s5,56(sp)
    80003222:	f85a                	sd	s6,48(sp)
    80003224:	f45e                	sd	s7,40(sp)
    80003226:	f062                	sd	s8,32(sp)
    80003228:	ec66                	sd	s9,24(sp)
    8000322a:	e86a                	sd	s10,16(sp)
    8000322c:	e46e                	sd	s11,8(sp)
    8000322e:	1880                	addi	s0,sp,112
    80003230:	8aaa                	mv	s5,a0
    80003232:	8bae                	mv	s7,a1
    80003234:	8a32                	mv	s4,a2
    80003236:	8936                	mv	s2,a3
    80003238:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off) return -1;
    8000323a:	00e687bb          	addw	a5,a3,a4
    8000323e:	0ed7e263          	bltu	a5,a3,80003322 <writei+0x116>
  if (off + n > MAXFILE * BSIZE) return -1;
    80003242:	00043737          	lui	a4,0x43
    80003246:	0ef76063          	bltu	a4,a5,80003326 <writei+0x11a>

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    8000324a:	0c0b0863          	beqz	s6,8000331a <writei+0x10e>
    8000324e:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0) break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003250:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003254:	5c7d                	li	s8,-1
    80003256:	a091                	j	8000329a <writei+0x8e>
    80003258:	020d1d93          	slli	s11,s10,0x20
    8000325c:	020ddd93          	srli	s11,s11,0x20
    80003260:	05848513          	addi	a0,s1,88
    80003264:	86ee                	mv	a3,s11
    80003266:	8652                	mv	a2,s4
    80003268:	85de                	mv	a1,s7
    8000326a:	953a                	add	a0,a0,a4
    8000326c:	fffff097          	auipc	ra,0xfffff
    80003270:	9e8080e7          	jalr	-1560(ra) # 80001c54 <either_copyin>
    80003274:	07850263          	beq	a0,s8,800032d8 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003278:	8526                	mv	a0,s1
    8000327a:	00000097          	auipc	ra,0x0
    8000327e:	788080e7          	jalr	1928(ra) # 80003a02 <log_write>
    brelse(bp);
    80003282:	8526                	mv	a0,s1
    80003284:	fffff097          	auipc	ra,0xfffff
    80003288:	4f4080e7          	jalr	1268(ra) # 80002778 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    8000328c:	013d09bb          	addw	s3,s10,s3
    80003290:	012d093b          	addw	s2,s10,s2
    80003294:	9a6e                	add	s4,s4,s11
    80003296:	0569f663          	bgeu	s3,s6,800032e2 <writei+0xd6>
    uint addr = bmap(ip, off / BSIZE);
    8000329a:	00a9559b          	srliw	a1,s2,0xa
    8000329e:	8556                	mv	a0,s5
    800032a0:	fffff097          	auipc	ra,0xfffff
    800032a4:	79c080e7          	jalr	1948(ra) # 80002a3c <bmap>
    800032a8:	0005059b          	sext.w	a1,a0
    if (addr == 0) break;
    800032ac:	c99d                	beqz	a1,800032e2 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800032ae:	000aa503          	lw	a0,0(s5)
    800032b2:	fffff097          	auipc	ra,0xfffff
    800032b6:	396080e7          	jalr	918(ra) # 80002648 <bread>
    800032ba:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    800032bc:	3ff97713          	andi	a4,s2,1023
    800032c0:	40ec87bb          	subw	a5,s9,a4
    800032c4:	413b06bb          	subw	a3,s6,s3
    800032c8:	8d3e                	mv	s10,a5
    800032ca:	2781                	sext.w	a5,a5
    800032cc:	0006861b          	sext.w	a2,a3
    800032d0:	f8f674e3          	bgeu	a2,a5,80003258 <writei+0x4c>
    800032d4:	8d36                	mv	s10,a3
    800032d6:	b749                	j	80003258 <writei+0x4c>
      brelse(bp);
    800032d8:	8526                	mv	a0,s1
    800032da:	fffff097          	auipc	ra,0xfffff
    800032de:	49e080e7          	jalr	1182(ra) # 80002778 <brelse>
  }

  if (off > ip->size) ip->size = off;
    800032e2:	04caa783          	lw	a5,76(s5)
    800032e6:	0127f463          	bgeu	a5,s2,800032ee <writei+0xe2>
    800032ea:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800032ee:	8556                	mv	a0,s5
    800032f0:	00000097          	auipc	ra,0x0
    800032f4:	aa4080e7          	jalr	-1372(ra) # 80002d94 <iupdate>

  return tot;
    800032f8:	0009851b          	sext.w	a0,s3
}
    800032fc:	70a6                	ld	ra,104(sp)
    800032fe:	7406                	ld	s0,96(sp)
    80003300:	64e6                	ld	s1,88(sp)
    80003302:	6946                	ld	s2,80(sp)
    80003304:	69a6                	ld	s3,72(sp)
    80003306:	6a06                	ld	s4,64(sp)
    80003308:	7ae2                	ld	s5,56(sp)
    8000330a:	7b42                	ld	s6,48(sp)
    8000330c:	7ba2                	ld	s7,40(sp)
    8000330e:	7c02                	ld	s8,32(sp)
    80003310:	6ce2                	ld	s9,24(sp)
    80003312:	6d42                	ld	s10,16(sp)
    80003314:	6da2                	ld	s11,8(sp)
    80003316:	6165                	addi	sp,sp,112
    80003318:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    8000331a:	89da                	mv	s3,s6
    8000331c:	bfc9                	j	800032ee <writei+0xe2>
  if (off > ip->size || off + n < off) return -1;
    8000331e:	557d                	li	a0,-1
}
    80003320:	8082                	ret
  if (off > ip->size || off + n < off) return -1;
    80003322:	557d                	li	a0,-1
    80003324:	bfe1                	j	800032fc <writei+0xf0>
  if (off + n > MAXFILE * BSIZE) return -1;
    80003326:	557d                	li	a0,-1
    80003328:	bfd1                	j	800032fc <writei+0xf0>

000000008000332a <namecmp>:

// Directories

int namecmp(const char *s, const char *t) { return strncmp(s, t, DIRSIZ); }
    8000332a:	1141                	addi	sp,sp,-16
    8000332c:	e406                	sd	ra,8(sp)
    8000332e:	e022                	sd	s0,0(sp)
    80003330:	0800                	addi	s0,sp,16
    80003332:	4639                	li	a2,14
    80003334:	ffffd097          	auipc	ra,0xffffd
    80003338:	f16080e7          	jalr	-234(ra) # 8000024a <strncmp>
    8000333c:	60a2                	ld	ra,8(sp)
    8000333e:	6402                	ld	s0,0(sp)
    80003340:	0141                	addi	sp,sp,16
    80003342:	8082                	ret

0000000080003344 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *dirlookup(struct inode *dp, char *name, uint *poff) {
    80003344:	7139                	addi	sp,sp,-64
    80003346:	fc06                	sd	ra,56(sp)
    80003348:	f822                	sd	s0,48(sp)
    8000334a:	f426                	sd	s1,40(sp)
    8000334c:	f04a                	sd	s2,32(sp)
    8000334e:	ec4e                	sd	s3,24(sp)
    80003350:	e852                	sd	s4,16(sp)
    80003352:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR) panic("dirlookup not DIR");
    80003354:	04451703          	lh	a4,68(a0)
    80003358:	4785                	li	a5,1
    8000335a:	00f71a63          	bne	a4,a5,8000336e <dirlookup+0x2a>
    8000335e:	892a                	mv	s2,a0
    80003360:	89ae                	mv	s3,a1
    80003362:	8a32                	mv	s4,a2

  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003364:	457c                	lw	a5,76(a0)
    80003366:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003368:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000336a:	e79d                	bnez	a5,80003398 <dirlookup+0x54>
    8000336c:	a8a5                	j	800033e4 <dirlookup+0xa0>
  if (dp->type != T_DIR) panic("dirlookup not DIR");
    8000336e:	00005517          	auipc	a0,0x5
    80003372:	1da50513          	addi	a0,a0,474 # 80008548 <syscalls+0x1a0>
    80003376:	00003097          	auipc	ra,0x3
    8000337a:	bb6080e7          	jalr	-1098(ra) # 80005f2c <panic>
      panic("dirlookup read");
    8000337e:	00005517          	auipc	a0,0x5
    80003382:	1e250513          	addi	a0,a0,482 # 80008560 <syscalls+0x1b8>
    80003386:	00003097          	auipc	ra,0x3
    8000338a:	ba6080e7          	jalr	-1114(ra) # 80005f2c <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000338e:	24c1                	addiw	s1,s1,16
    80003390:	04c92783          	lw	a5,76(s2)
    80003394:	04f4f763          	bgeu	s1,a5,800033e2 <dirlookup+0x9e>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003398:	4741                	li	a4,16
    8000339a:	86a6                	mv	a3,s1
    8000339c:	fc040613          	addi	a2,s0,-64
    800033a0:	4581                	li	a1,0
    800033a2:	854a                	mv	a0,s2
    800033a4:	00000097          	auipc	ra,0x0
    800033a8:	d70080e7          	jalr	-656(ra) # 80003114 <readi>
    800033ac:	47c1                	li	a5,16
    800033ae:	fcf518e3          	bne	a0,a5,8000337e <dirlookup+0x3a>
    if (de.inum == 0) continue;
    800033b2:	fc045783          	lhu	a5,-64(s0)
    800033b6:	dfe1                	beqz	a5,8000338e <dirlookup+0x4a>
    if (namecmp(name, de.name) == 0) {
    800033b8:	fc240593          	addi	a1,s0,-62
    800033bc:	854e                	mv	a0,s3
    800033be:	00000097          	auipc	ra,0x0
    800033c2:	f6c080e7          	jalr	-148(ra) # 8000332a <namecmp>
    800033c6:	f561                	bnez	a0,8000338e <dirlookup+0x4a>
      if (poff) *poff = off;
    800033c8:	000a0463          	beqz	s4,800033d0 <dirlookup+0x8c>
    800033cc:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800033d0:	fc045583          	lhu	a1,-64(s0)
    800033d4:	00092503          	lw	a0,0(s2)
    800033d8:	fffff097          	auipc	ra,0xfffff
    800033dc:	74e080e7          	jalr	1870(ra) # 80002b26 <iget>
    800033e0:	a011                	j	800033e4 <dirlookup+0xa0>
  return 0;
    800033e2:	4501                	li	a0,0
}
    800033e4:	70e2                	ld	ra,56(sp)
    800033e6:	7442                	ld	s0,48(sp)
    800033e8:	74a2                	ld	s1,40(sp)
    800033ea:	7902                	ld	s2,32(sp)
    800033ec:	69e2                	ld	s3,24(sp)
    800033ee:	6a42                	ld	s4,16(sp)
    800033f0:	6121                	addi	sp,sp,64
    800033f2:	8082                	ret

00000000800033f4 <namex>:

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *namex(char *path, int nameiparent, char *name) {
    800033f4:	711d                	addi	sp,sp,-96
    800033f6:	ec86                	sd	ra,88(sp)
    800033f8:	e8a2                	sd	s0,80(sp)
    800033fa:	e4a6                	sd	s1,72(sp)
    800033fc:	e0ca                	sd	s2,64(sp)
    800033fe:	fc4e                	sd	s3,56(sp)
    80003400:	f852                	sd	s4,48(sp)
    80003402:	f456                	sd	s5,40(sp)
    80003404:	f05a                	sd	s6,32(sp)
    80003406:	ec5e                	sd	s7,24(sp)
    80003408:	e862                	sd	s8,16(sp)
    8000340a:	e466                	sd	s9,8(sp)
    8000340c:	e06a                	sd	s10,0(sp)
    8000340e:	1080                	addi	s0,sp,96
    80003410:	84aa                	mv	s1,a0
    80003412:	8b2e                	mv	s6,a1
    80003414:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    80003416:	00054703          	lbu	a4,0(a0)
    8000341a:	02f00793          	li	a5,47
    8000341e:	02f70363          	beq	a4,a5,80003444 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003422:	ffffe097          	auipc	ra,0xffffe
    80003426:	d26080e7          	jalr	-730(ra) # 80001148 <myproc>
    8000342a:	15053503          	ld	a0,336(a0)
    8000342e:	00000097          	auipc	ra,0x0
    80003432:	9f4080e7          	jalr	-1548(ra) # 80002e22 <idup>
    80003436:	8a2a                	mv	s4,a0
  while (*path == '/') path++;
    80003438:	02f00913          	li	s2,47
  if (len >= DIRSIZ)
    8000343c:	4cb5                	li	s9,13
  len = path - s;
    8000343e:	4b81                	li	s7,0

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    80003440:	4c05                	li	s8,1
    80003442:	a87d                	j	80003500 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003444:	4585                	li	a1,1
    80003446:	4505                	li	a0,1
    80003448:	fffff097          	auipc	ra,0xfffff
    8000344c:	6de080e7          	jalr	1758(ra) # 80002b26 <iget>
    80003450:	8a2a                	mv	s4,a0
    80003452:	b7dd                	j	80003438 <namex+0x44>
      iunlockput(ip);
    80003454:	8552                	mv	a0,s4
    80003456:	00000097          	auipc	ra,0x0
    8000345a:	c6c080e7          	jalr	-916(ra) # 800030c2 <iunlockput>
      return 0;
    8000345e:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    80003460:	8552                	mv	a0,s4
    80003462:	60e6                	ld	ra,88(sp)
    80003464:	6446                	ld	s0,80(sp)
    80003466:	64a6                	ld	s1,72(sp)
    80003468:	6906                	ld	s2,64(sp)
    8000346a:	79e2                	ld	s3,56(sp)
    8000346c:	7a42                	ld	s4,48(sp)
    8000346e:	7aa2                	ld	s5,40(sp)
    80003470:	7b02                	ld	s6,32(sp)
    80003472:	6be2                	ld	s7,24(sp)
    80003474:	6c42                	ld	s8,16(sp)
    80003476:	6ca2                	ld	s9,8(sp)
    80003478:	6d02                	ld	s10,0(sp)
    8000347a:	6125                	addi	sp,sp,96
    8000347c:	8082                	ret
      iunlock(ip);
    8000347e:	8552                	mv	a0,s4
    80003480:	00000097          	auipc	ra,0x0
    80003484:	aa2080e7          	jalr	-1374(ra) # 80002f22 <iunlock>
      return ip;
    80003488:	bfe1                	j	80003460 <namex+0x6c>
      iunlockput(ip);
    8000348a:	8552                	mv	a0,s4
    8000348c:	00000097          	auipc	ra,0x0
    80003490:	c36080e7          	jalr	-970(ra) # 800030c2 <iunlockput>
      return 0;
    80003494:	8a4e                	mv	s4,s3
    80003496:	b7e9                	j	80003460 <namex+0x6c>
  len = path - s;
    80003498:	40998633          	sub	a2,s3,s1
    8000349c:	00060d1b          	sext.w	s10,a2
  if (len >= DIRSIZ)
    800034a0:	09acd863          	bge	s9,s10,80003530 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800034a4:	4639                	li	a2,14
    800034a6:	85a6                	mv	a1,s1
    800034a8:	8556                	mv	a0,s5
    800034aa:	ffffd097          	auipc	ra,0xffffd
    800034ae:	d2c080e7          	jalr	-724(ra) # 800001d6 <memmove>
    800034b2:	84ce                	mv	s1,s3
  while (*path == '/') path++;
    800034b4:	0004c783          	lbu	a5,0(s1)
    800034b8:	01279763          	bne	a5,s2,800034c6 <namex+0xd2>
    800034bc:	0485                	addi	s1,s1,1
    800034be:	0004c783          	lbu	a5,0(s1)
    800034c2:	ff278de3          	beq	a5,s2,800034bc <namex+0xc8>
    ilock(ip);
    800034c6:	8552                	mv	a0,s4
    800034c8:	00000097          	auipc	ra,0x0
    800034cc:	998080e7          	jalr	-1640(ra) # 80002e60 <ilock>
    if (ip->type != T_DIR) {
    800034d0:	044a1783          	lh	a5,68(s4)
    800034d4:	f98790e3          	bne	a5,s8,80003454 <namex+0x60>
    if (nameiparent && *path == '\0') {
    800034d8:	000b0563          	beqz	s6,800034e2 <namex+0xee>
    800034dc:	0004c783          	lbu	a5,0(s1)
    800034e0:	dfd9                	beqz	a5,8000347e <namex+0x8a>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    800034e2:	865e                	mv	a2,s7
    800034e4:	85d6                	mv	a1,s5
    800034e6:	8552                	mv	a0,s4
    800034e8:	00000097          	auipc	ra,0x0
    800034ec:	e5c080e7          	jalr	-420(ra) # 80003344 <dirlookup>
    800034f0:	89aa                	mv	s3,a0
    800034f2:	dd41                	beqz	a0,8000348a <namex+0x96>
    iunlockput(ip);
    800034f4:	8552                	mv	a0,s4
    800034f6:	00000097          	auipc	ra,0x0
    800034fa:	bcc080e7          	jalr	-1076(ra) # 800030c2 <iunlockput>
    ip = next;
    800034fe:	8a4e                	mv	s4,s3
  while (*path == '/') path++;
    80003500:	0004c783          	lbu	a5,0(s1)
    80003504:	01279763          	bne	a5,s2,80003512 <namex+0x11e>
    80003508:	0485                	addi	s1,s1,1
    8000350a:	0004c783          	lbu	a5,0(s1)
    8000350e:	ff278de3          	beq	a5,s2,80003508 <namex+0x114>
  if (*path == 0) return 0;
    80003512:	cb9d                	beqz	a5,80003548 <namex+0x154>
  while (*path != '/' && *path != 0) path++;
    80003514:	0004c783          	lbu	a5,0(s1)
    80003518:	89a6                	mv	s3,s1
  len = path - s;
    8000351a:	8d5e                	mv	s10,s7
    8000351c:	865e                	mv	a2,s7
  while (*path != '/' && *path != 0) path++;
    8000351e:	01278963          	beq	a5,s2,80003530 <namex+0x13c>
    80003522:	dbbd                	beqz	a5,80003498 <namex+0xa4>
    80003524:	0985                	addi	s3,s3,1
    80003526:	0009c783          	lbu	a5,0(s3)
    8000352a:	ff279ce3          	bne	a5,s2,80003522 <namex+0x12e>
    8000352e:	b7ad                	j	80003498 <namex+0xa4>
    memmove(name, s, len);
    80003530:	2601                	sext.w	a2,a2
    80003532:	85a6                	mv	a1,s1
    80003534:	8556                	mv	a0,s5
    80003536:	ffffd097          	auipc	ra,0xffffd
    8000353a:	ca0080e7          	jalr	-864(ra) # 800001d6 <memmove>
    name[len] = 0;
    8000353e:	9d56                	add	s10,s10,s5
    80003540:	000d0023          	sb	zero,0(s10)
    80003544:	84ce                	mv	s1,s3
    80003546:	b7bd                	j	800034b4 <namex+0xc0>
  if (nameiparent) {
    80003548:	f00b0ce3          	beqz	s6,80003460 <namex+0x6c>
    iput(ip);
    8000354c:	8552                	mv	a0,s4
    8000354e:	00000097          	auipc	ra,0x0
    80003552:	acc080e7          	jalr	-1332(ra) # 8000301a <iput>
    return 0;
    80003556:	4a01                	li	s4,0
    80003558:	b721                	j	80003460 <namex+0x6c>

000000008000355a <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum) {
    8000355a:	7139                	addi	sp,sp,-64
    8000355c:	fc06                	sd	ra,56(sp)
    8000355e:	f822                	sd	s0,48(sp)
    80003560:	f426                	sd	s1,40(sp)
    80003562:	f04a                	sd	s2,32(sp)
    80003564:	ec4e                	sd	s3,24(sp)
    80003566:	e852                	sd	s4,16(sp)
    80003568:	0080                	addi	s0,sp,64
    8000356a:	892a                	mv	s2,a0
    8000356c:	8a2e                	mv	s4,a1
    8000356e:	89b2                	mv	s3,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80003570:	4601                	li	a2,0
    80003572:	00000097          	auipc	ra,0x0
    80003576:	dd2080e7          	jalr	-558(ra) # 80003344 <dirlookup>
    8000357a:	e93d                	bnez	a0,800035f0 <dirlink+0x96>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000357c:	04c92483          	lw	s1,76(s2)
    80003580:	c49d                	beqz	s1,800035ae <dirlink+0x54>
    80003582:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003584:	4741                	li	a4,16
    80003586:	86a6                	mv	a3,s1
    80003588:	fc040613          	addi	a2,s0,-64
    8000358c:	4581                	li	a1,0
    8000358e:	854a                	mv	a0,s2
    80003590:	00000097          	auipc	ra,0x0
    80003594:	b84080e7          	jalr	-1148(ra) # 80003114 <readi>
    80003598:	47c1                	li	a5,16
    8000359a:	06f51163          	bne	a0,a5,800035fc <dirlink+0xa2>
    if (de.inum == 0) break;
    8000359e:	fc045783          	lhu	a5,-64(s0)
    800035a2:	c791                	beqz	a5,800035ae <dirlink+0x54>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800035a4:	24c1                	addiw	s1,s1,16
    800035a6:	04c92783          	lw	a5,76(s2)
    800035aa:	fcf4ede3          	bltu	s1,a5,80003584 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800035ae:	4639                	li	a2,14
    800035b0:	85d2                	mv	a1,s4
    800035b2:	fc240513          	addi	a0,s0,-62
    800035b6:	ffffd097          	auipc	ra,0xffffd
    800035ba:	cd0080e7          	jalr	-816(ra) # 80000286 <strncpy>
  de.inum = inum;
    800035be:	fd341023          	sh	s3,-64(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de)) return -1;
    800035c2:	4741                	li	a4,16
    800035c4:	86a6                	mv	a3,s1
    800035c6:	fc040613          	addi	a2,s0,-64
    800035ca:	4581                	li	a1,0
    800035cc:	854a                	mv	a0,s2
    800035ce:	00000097          	auipc	ra,0x0
    800035d2:	c3e080e7          	jalr	-962(ra) # 8000320c <writei>
    800035d6:	1541                	addi	a0,a0,-16
    800035d8:	00a03533          	snez	a0,a0
    800035dc:	40a00533          	neg	a0,a0
}
    800035e0:	70e2                	ld	ra,56(sp)
    800035e2:	7442                	ld	s0,48(sp)
    800035e4:	74a2                	ld	s1,40(sp)
    800035e6:	7902                	ld	s2,32(sp)
    800035e8:	69e2                	ld	s3,24(sp)
    800035ea:	6a42                	ld	s4,16(sp)
    800035ec:	6121                	addi	sp,sp,64
    800035ee:	8082                	ret
    iput(ip);
    800035f0:	00000097          	auipc	ra,0x0
    800035f4:	a2a080e7          	jalr	-1494(ra) # 8000301a <iput>
    return -1;
    800035f8:	557d                	li	a0,-1
    800035fa:	b7dd                	j	800035e0 <dirlink+0x86>
      panic("dirlink read");
    800035fc:	00005517          	auipc	a0,0x5
    80003600:	f7450513          	addi	a0,a0,-140 # 80008570 <syscalls+0x1c8>
    80003604:	00003097          	auipc	ra,0x3
    80003608:	928080e7          	jalr	-1752(ra) # 80005f2c <panic>

000000008000360c <namei>:

struct inode *namei(char *path) {
    8000360c:	1101                	addi	sp,sp,-32
    8000360e:	ec06                	sd	ra,24(sp)
    80003610:	e822                	sd	s0,16(sp)
    80003612:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003614:	fe040613          	addi	a2,s0,-32
    80003618:	4581                	li	a1,0
    8000361a:	00000097          	auipc	ra,0x0
    8000361e:	dda080e7          	jalr	-550(ra) # 800033f4 <namex>
}
    80003622:	60e2                	ld	ra,24(sp)
    80003624:	6442                	ld	s0,16(sp)
    80003626:	6105                	addi	sp,sp,32
    80003628:	8082                	ret

000000008000362a <nameiparent>:

struct inode *nameiparent(char *path, char *name) {
    8000362a:	1141                	addi	sp,sp,-16
    8000362c:	e406                	sd	ra,8(sp)
    8000362e:	e022                	sd	s0,0(sp)
    80003630:	0800                	addi	s0,sp,16
    80003632:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003634:	4585                	li	a1,1
    80003636:	00000097          	auipc	ra,0x0
    8000363a:	dbe080e7          	jalr	-578(ra) # 800033f4 <namex>
}
    8000363e:	60a2                	ld	ra,8(sp)
    80003640:	6402                	ld	s0,0(sp)
    80003642:	0141                	addi	sp,sp,16
    80003644:	8082                	ret

0000000080003646 <write_head>:
}

// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void write_head(void) {
    80003646:	1101                	addi	sp,sp,-32
    80003648:	ec06                	sd	ra,24(sp)
    8000364a:	e822                	sd	s0,16(sp)
    8000364c:	e426                	sd	s1,8(sp)
    8000364e:	e04a                	sd	s2,0(sp)
    80003650:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003652:	0009d917          	auipc	s2,0x9d
    80003656:	27690913          	addi	s2,s2,630 # 800a08c8 <log>
    8000365a:	01892583          	lw	a1,24(s2)
    8000365e:	02892503          	lw	a0,40(s2)
    80003662:	fffff097          	auipc	ra,0xfffff
    80003666:	fe6080e7          	jalr	-26(ra) # 80002648 <bread>
    8000366a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    8000366c:	02c92683          	lw	a3,44(s2)
    80003670:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003672:	02d05863          	blez	a3,800036a2 <write_head+0x5c>
    80003676:	0009d797          	auipc	a5,0x9d
    8000367a:	28278793          	addi	a5,a5,642 # 800a08f8 <log+0x30>
    8000367e:	05c50713          	addi	a4,a0,92
    80003682:	36fd                	addiw	a3,a3,-1
    80003684:	02069613          	slli	a2,a3,0x20
    80003688:	01e65693          	srli	a3,a2,0x1e
    8000368c:	0009d617          	auipc	a2,0x9d
    80003690:	27060613          	addi	a2,a2,624 # 800a08fc <log+0x34>
    80003694:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003696:	4390                	lw	a2,0(a5)
    80003698:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000369a:	0791                	addi	a5,a5,4
    8000369c:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000369e:	fed79ce3          	bne	a5,a3,80003696 <write_head+0x50>
  }
  bwrite(buf);
    800036a2:	8526                	mv	a0,s1
    800036a4:	fffff097          	auipc	ra,0xfffff
    800036a8:	096080e7          	jalr	150(ra) # 8000273a <bwrite>
  brelse(buf);
    800036ac:	8526                	mv	a0,s1
    800036ae:	fffff097          	auipc	ra,0xfffff
    800036b2:	0ca080e7          	jalr	202(ra) # 80002778 <brelse>
}
    800036b6:	60e2                	ld	ra,24(sp)
    800036b8:	6442                	ld	s0,16(sp)
    800036ba:	64a2                	ld	s1,8(sp)
    800036bc:	6902                	ld	s2,0(sp)
    800036be:	6105                	addi	sp,sp,32
    800036c0:	8082                	ret

00000000800036c2 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800036c2:	0009d797          	auipc	a5,0x9d
    800036c6:	2327a783          	lw	a5,562(a5) # 800a08f4 <log+0x2c>
    800036ca:	0af05d63          	blez	a5,80003784 <install_trans+0xc2>
static void install_trans(int recovering) {
    800036ce:	7139                	addi	sp,sp,-64
    800036d0:	fc06                	sd	ra,56(sp)
    800036d2:	f822                	sd	s0,48(sp)
    800036d4:	f426                	sd	s1,40(sp)
    800036d6:	f04a                	sd	s2,32(sp)
    800036d8:	ec4e                	sd	s3,24(sp)
    800036da:	e852                	sd	s4,16(sp)
    800036dc:	e456                	sd	s5,8(sp)
    800036de:	e05a                	sd	s6,0(sp)
    800036e0:	0080                	addi	s0,sp,64
    800036e2:	8b2a                	mv	s6,a0
    800036e4:	0009da97          	auipc	s5,0x9d
    800036e8:	214a8a93          	addi	s5,s5,532 # 800a08f8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036ec:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start + tail + 1);  // read log block
    800036ee:	0009d997          	auipc	s3,0x9d
    800036f2:	1da98993          	addi	s3,s3,474 # 800a08c8 <log>
    800036f6:	a00d                	j	80003718 <install_trans+0x56>
    brelse(lbuf);
    800036f8:	854a                	mv	a0,s2
    800036fa:	fffff097          	auipc	ra,0xfffff
    800036fe:	07e080e7          	jalr	126(ra) # 80002778 <brelse>
    brelse(dbuf);
    80003702:	8526                	mv	a0,s1
    80003704:	fffff097          	auipc	ra,0xfffff
    80003708:	074080e7          	jalr	116(ra) # 80002778 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000370c:	2a05                	addiw	s4,s4,1
    8000370e:	0a91                	addi	s5,s5,4
    80003710:	02c9a783          	lw	a5,44(s3)
    80003714:	04fa5e63          	bge	s4,a5,80003770 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1);  // read log block
    80003718:	0189a583          	lw	a1,24(s3)
    8000371c:	014585bb          	addw	a1,a1,s4
    80003720:	2585                	addiw	a1,a1,1
    80003722:	0289a503          	lw	a0,40(s3)
    80003726:	fffff097          	auipc	ra,0xfffff
    8000372a:	f22080e7          	jalr	-222(ra) # 80002648 <bread>
    8000372e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);    // read dst
    80003730:	000aa583          	lw	a1,0(s5)
    80003734:	0289a503          	lw	a0,40(s3)
    80003738:	fffff097          	auipc	ra,0xfffff
    8000373c:	f10080e7          	jalr	-240(ra) # 80002648 <bread>
    80003740:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003742:	40000613          	li	a2,1024
    80003746:	05890593          	addi	a1,s2,88
    8000374a:	05850513          	addi	a0,a0,88
    8000374e:	ffffd097          	auipc	ra,0xffffd
    80003752:	a88080e7          	jalr	-1400(ra) # 800001d6 <memmove>
    bwrite(dbuf);                            // write dst to disk
    80003756:	8526                	mv	a0,s1
    80003758:	fffff097          	auipc	ra,0xfffff
    8000375c:	fe2080e7          	jalr	-30(ra) # 8000273a <bwrite>
    if (recovering == 0) bunpin(dbuf);
    80003760:	f80b1ce3          	bnez	s6,800036f8 <install_trans+0x36>
    80003764:	8526                	mv	a0,s1
    80003766:	fffff097          	auipc	ra,0xfffff
    8000376a:	0ec080e7          	jalr	236(ra) # 80002852 <bunpin>
    8000376e:	b769                	j	800036f8 <install_trans+0x36>
}
    80003770:	70e2                	ld	ra,56(sp)
    80003772:	7442                	ld	s0,48(sp)
    80003774:	74a2                	ld	s1,40(sp)
    80003776:	7902                	ld	s2,32(sp)
    80003778:	69e2                	ld	s3,24(sp)
    8000377a:	6a42                	ld	s4,16(sp)
    8000377c:	6aa2                	ld	s5,8(sp)
    8000377e:	6b02                	ld	s6,0(sp)
    80003780:	6121                	addi	sp,sp,64
    80003782:	8082                	ret
    80003784:	8082                	ret

0000000080003786 <initlog>:
void initlog(int dev, struct superblock *sb) {
    80003786:	7179                	addi	sp,sp,-48
    80003788:	f406                	sd	ra,40(sp)
    8000378a:	f022                	sd	s0,32(sp)
    8000378c:	ec26                	sd	s1,24(sp)
    8000378e:	e84a                	sd	s2,16(sp)
    80003790:	e44e                	sd	s3,8(sp)
    80003792:	1800                	addi	s0,sp,48
    80003794:	892a                	mv	s2,a0
    80003796:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003798:	0009d497          	auipc	s1,0x9d
    8000379c:	13048493          	addi	s1,s1,304 # 800a08c8 <log>
    800037a0:	00005597          	auipc	a1,0x5
    800037a4:	de058593          	addi	a1,a1,-544 # 80008580 <syscalls+0x1d8>
    800037a8:	8526                	mv	a0,s1
    800037aa:	00003097          	auipc	ra,0x3
    800037ae:	c2a080e7          	jalr	-982(ra) # 800063d4 <initlock>
  log.start = sb->logstart;
    800037b2:	0149a583          	lw	a1,20(s3)
    800037b6:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800037b8:	0109a783          	lw	a5,16(s3)
    800037bc:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800037be:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800037c2:	854a                	mv	a0,s2
    800037c4:	fffff097          	auipc	ra,0xfffff
    800037c8:	e84080e7          	jalr	-380(ra) # 80002648 <bread>
  log.lh.n = lh->n;
    800037cc:	4d34                	lw	a3,88(a0)
    800037ce:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800037d0:	02d05663          	blez	a3,800037fc <initlog+0x76>
    800037d4:	05c50793          	addi	a5,a0,92
    800037d8:	0009d717          	auipc	a4,0x9d
    800037dc:	12070713          	addi	a4,a4,288 # 800a08f8 <log+0x30>
    800037e0:	36fd                	addiw	a3,a3,-1
    800037e2:	02069613          	slli	a2,a3,0x20
    800037e6:	01e65693          	srli	a3,a2,0x1e
    800037ea:	06050613          	addi	a2,a0,96
    800037ee:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800037f0:	4390                	lw	a2,0(a5)
    800037f2:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800037f4:	0791                	addi	a5,a5,4
    800037f6:	0711                	addi	a4,a4,4
    800037f8:	fed79ce3          	bne	a5,a3,800037f0 <initlog+0x6a>
  brelse(buf);
    800037fc:	fffff097          	auipc	ra,0xfffff
    80003800:	f7c080e7          	jalr	-132(ra) # 80002778 <brelse>

static void recover_from_log(void) {
  read_head();
  install_trans(1);  // if committed, copy from log to disk
    80003804:	4505                	li	a0,1
    80003806:	00000097          	auipc	ra,0x0
    8000380a:	ebc080e7          	jalr	-324(ra) # 800036c2 <install_trans>
  log.lh.n = 0;
    8000380e:	0009d797          	auipc	a5,0x9d
    80003812:	0e07a323          	sw	zero,230(a5) # 800a08f4 <log+0x2c>
  write_head();  // clear the log
    80003816:	00000097          	auipc	ra,0x0
    8000381a:	e30080e7          	jalr	-464(ra) # 80003646 <write_head>
}
    8000381e:	70a2                	ld	ra,40(sp)
    80003820:	7402                	ld	s0,32(sp)
    80003822:	64e2                	ld	s1,24(sp)
    80003824:	6942                	ld	s2,16(sp)
    80003826:	69a2                	ld	s3,8(sp)
    80003828:	6145                	addi	sp,sp,48
    8000382a:	8082                	ret

000000008000382c <begin_op>:
}

// called at the start of each FS system call.
void begin_op(void) {
    8000382c:	1101                	addi	sp,sp,-32
    8000382e:	ec06                	sd	ra,24(sp)
    80003830:	e822                	sd	s0,16(sp)
    80003832:	e426                	sd	s1,8(sp)
    80003834:	e04a                	sd	s2,0(sp)
    80003836:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003838:	0009d517          	auipc	a0,0x9d
    8000383c:	09050513          	addi	a0,a0,144 # 800a08c8 <log>
    80003840:	00003097          	auipc	ra,0x3
    80003844:	c24080e7          	jalr	-988(ra) # 80006464 <acquire>
  while (1) {
    if (log.committing) {
    80003848:	0009d497          	auipc	s1,0x9d
    8000384c:	08048493          	addi	s1,s1,128 # 800a08c8 <log>
      sleep(&log, &log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    80003850:	4979                	li	s2,30
    80003852:	a039                	j	80003860 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003854:	85a6                	mv	a1,s1
    80003856:	8526                	mv	a0,s1
    80003858:	ffffe097          	auipc	ra,0xffffe
    8000385c:	f98080e7          	jalr	-104(ra) # 800017f0 <sleep>
    if (log.committing) {
    80003860:	50dc                	lw	a5,36(s1)
    80003862:	fbed                	bnez	a5,80003854 <begin_op+0x28>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    80003864:	5098                	lw	a4,32(s1)
    80003866:	2705                	addiw	a4,a4,1
    80003868:	0007069b          	sext.w	a3,a4
    8000386c:	0027179b          	slliw	a5,a4,0x2
    80003870:	9fb9                	addw	a5,a5,a4
    80003872:	0017979b          	slliw	a5,a5,0x1
    80003876:	54d8                	lw	a4,44(s1)
    80003878:	9fb9                	addw	a5,a5,a4
    8000387a:	00f95963          	bge	s2,a5,8000388c <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000387e:	85a6                	mv	a1,s1
    80003880:	8526                	mv	a0,s1
    80003882:	ffffe097          	auipc	ra,0xffffe
    80003886:	f6e080e7          	jalr	-146(ra) # 800017f0 <sleep>
    8000388a:	bfd9                	j	80003860 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000388c:	0009d517          	auipc	a0,0x9d
    80003890:	03c50513          	addi	a0,a0,60 # 800a08c8 <log>
    80003894:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003896:	00003097          	auipc	ra,0x3
    8000389a:	c82080e7          	jalr	-894(ra) # 80006518 <release>
      break;
    }
  }
}
    8000389e:	60e2                	ld	ra,24(sp)
    800038a0:	6442                	ld	s0,16(sp)
    800038a2:	64a2                	ld	s1,8(sp)
    800038a4:	6902                	ld	s2,0(sp)
    800038a6:	6105                	addi	sp,sp,32
    800038a8:	8082                	ret

00000000800038aa <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void end_op(void) {
    800038aa:	7139                	addi	sp,sp,-64
    800038ac:	fc06                	sd	ra,56(sp)
    800038ae:	f822                	sd	s0,48(sp)
    800038b0:	f426                	sd	s1,40(sp)
    800038b2:	f04a                	sd	s2,32(sp)
    800038b4:	ec4e                	sd	s3,24(sp)
    800038b6:	e852                	sd	s4,16(sp)
    800038b8:	e456                	sd	s5,8(sp)
    800038ba:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800038bc:	0009d497          	auipc	s1,0x9d
    800038c0:	00c48493          	addi	s1,s1,12 # 800a08c8 <log>
    800038c4:	8526                	mv	a0,s1
    800038c6:	00003097          	auipc	ra,0x3
    800038ca:	b9e080e7          	jalr	-1122(ra) # 80006464 <acquire>
  log.outstanding -= 1;
    800038ce:	509c                	lw	a5,32(s1)
    800038d0:	37fd                	addiw	a5,a5,-1
    800038d2:	0007891b          	sext.w	s2,a5
    800038d6:	d09c                	sw	a5,32(s1)
  if (log.committing) panic("log.committing");
    800038d8:	50dc                	lw	a5,36(s1)
    800038da:	e7b9                	bnez	a5,80003928 <end_op+0x7e>
  if (log.outstanding == 0) {
    800038dc:	04091e63          	bnez	s2,80003938 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800038e0:	0009d497          	auipc	s1,0x9d
    800038e4:	fe848493          	addi	s1,s1,-24 # 800a08c8 <log>
    800038e8:	4785                	li	a5,1
    800038ea:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800038ec:	8526                	mv	a0,s1
    800038ee:	00003097          	auipc	ra,0x3
    800038f2:	c2a080e7          	jalr	-982(ra) # 80006518 <release>
    brelse(to);
  }
}

static void commit() {
  if (log.lh.n > 0) {
    800038f6:	54dc                	lw	a5,44(s1)
    800038f8:	06f04763          	bgtz	a5,80003966 <end_op+0xbc>
    acquire(&log.lock);
    800038fc:	0009d497          	auipc	s1,0x9d
    80003900:	fcc48493          	addi	s1,s1,-52 # 800a08c8 <log>
    80003904:	8526                	mv	a0,s1
    80003906:	00003097          	auipc	ra,0x3
    8000390a:	b5e080e7          	jalr	-1186(ra) # 80006464 <acquire>
    log.committing = 0;
    8000390e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003912:	8526                	mv	a0,s1
    80003914:	ffffe097          	auipc	ra,0xffffe
    80003918:	f40080e7          	jalr	-192(ra) # 80001854 <wakeup>
    release(&log.lock);
    8000391c:	8526                	mv	a0,s1
    8000391e:	00003097          	auipc	ra,0x3
    80003922:	bfa080e7          	jalr	-1030(ra) # 80006518 <release>
}
    80003926:	a03d                	j	80003954 <end_op+0xaa>
  if (log.committing) panic("log.committing");
    80003928:	00005517          	auipc	a0,0x5
    8000392c:	c6050513          	addi	a0,a0,-928 # 80008588 <syscalls+0x1e0>
    80003930:	00002097          	auipc	ra,0x2
    80003934:	5fc080e7          	jalr	1532(ra) # 80005f2c <panic>
    wakeup(&log);
    80003938:	0009d497          	auipc	s1,0x9d
    8000393c:	f9048493          	addi	s1,s1,-112 # 800a08c8 <log>
    80003940:	8526                	mv	a0,s1
    80003942:	ffffe097          	auipc	ra,0xffffe
    80003946:	f12080e7          	jalr	-238(ra) # 80001854 <wakeup>
  release(&log.lock);
    8000394a:	8526                	mv	a0,s1
    8000394c:	00003097          	auipc	ra,0x3
    80003950:	bcc080e7          	jalr	-1076(ra) # 80006518 <release>
}
    80003954:	70e2                	ld	ra,56(sp)
    80003956:	7442                	ld	s0,48(sp)
    80003958:	74a2                	ld	s1,40(sp)
    8000395a:	7902                	ld	s2,32(sp)
    8000395c:	69e2                	ld	s3,24(sp)
    8000395e:	6a42                	ld	s4,16(sp)
    80003960:	6aa2                	ld	s5,8(sp)
    80003962:	6121                	addi	sp,sp,64
    80003964:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003966:	0009da97          	auipc	s5,0x9d
    8000396a:	f92a8a93          	addi	s5,s5,-110 # 800a08f8 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1);  // log block
    8000396e:	0009da17          	auipc	s4,0x9d
    80003972:	f5aa0a13          	addi	s4,s4,-166 # 800a08c8 <log>
    80003976:	018a2583          	lw	a1,24(s4)
    8000397a:	012585bb          	addw	a1,a1,s2
    8000397e:	2585                	addiw	a1,a1,1
    80003980:	028a2503          	lw	a0,40(s4)
    80003984:	fffff097          	auipc	ra,0xfffff
    80003988:	cc4080e7          	jalr	-828(ra) # 80002648 <bread>
    8000398c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]);  // cache block
    8000398e:	000aa583          	lw	a1,0(s5)
    80003992:	028a2503          	lw	a0,40(s4)
    80003996:	fffff097          	auipc	ra,0xfffff
    8000399a:	cb2080e7          	jalr	-846(ra) # 80002648 <bread>
    8000399e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800039a0:	40000613          	li	a2,1024
    800039a4:	05850593          	addi	a1,a0,88
    800039a8:	05848513          	addi	a0,s1,88
    800039ac:	ffffd097          	auipc	ra,0xffffd
    800039b0:	82a080e7          	jalr	-2006(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    800039b4:	8526                	mv	a0,s1
    800039b6:	fffff097          	auipc	ra,0xfffff
    800039ba:	d84080e7          	jalr	-636(ra) # 8000273a <bwrite>
    brelse(from);
    800039be:	854e                	mv	a0,s3
    800039c0:	fffff097          	auipc	ra,0xfffff
    800039c4:	db8080e7          	jalr	-584(ra) # 80002778 <brelse>
    brelse(to);
    800039c8:	8526                	mv	a0,s1
    800039ca:	fffff097          	auipc	ra,0xfffff
    800039ce:	dae080e7          	jalr	-594(ra) # 80002778 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800039d2:	2905                	addiw	s2,s2,1
    800039d4:	0a91                	addi	s5,s5,4
    800039d6:	02ca2783          	lw	a5,44(s4)
    800039da:	f8f94ee3          	blt	s2,a5,80003976 <end_op+0xcc>
    write_log();       // Write modified blocks from cache to log
    write_head();      // Write header to disk -- the real commit
    800039de:	00000097          	auipc	ra,0x0
    800039e2:	c68080e7          	jalr	-920(ra) # 80003646 <write_head>
    install_trans(0);  // Now install writes to home locations
    800039e6:	4501                	li	a0,0
    800039e8:	00000097          	auipc	ra,0x0
    800039ec:	cda080e7          	jalr	-806(ra) # 800036c2 <install_trans>
    log.lh.n = 0;
    800039f0:	0009d797          	auipc	a5,0x9d
    800039f4:	f007a223          	sw	zero,-252(a5) # 800a08f4 <log+0x2c>
    write_head();  // Erase the transaction from the log
    800039f8:	00000097          	auipc	ra,0x0
    800039fc:	c4e080e7          	jalr	-946(ra) # 80003646 <write_head>
    80003a00:	bdf5                	j	800038fc <end_op+0x52>

0000000080003a02 <log_write>:
// log_write() replaces bwrite(); a typical use is:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void log_write(struct buf *b) {
    80003a02:	1101                	addi	sp,sp,-32
    80003a04:	ec06                	sd	ra,24(sp)
    80003a06:	e822                	sd	s0,16(sp)
    80003a08:	e426                	sd	s1,8(sp)
    80003a0a:	e04a                	sd	s2,0(sp)
    80003a0c:	1000                	addi	s0,sp,32
    80003a0e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003a10:	0009d917          	auipc	s2,0x9d
    80003a14:	eb890913          	addi	s2,s2,-328 # 800a08c8 <log>
    80003a18:	854a                	mv	a0,s2
    80003a1a:	00003097          	auipc	ra,0x3
    80003a1e:	a4a080e7          	jalr	-1462(ra) # 80006464 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003a22:	02c92603          	lw	a2,44(s2)
    80003a26:	47f5                	li	a5,29
    80003a28:	06c7c563          	blt	a5,a2,80003a92 <log_write+0x90>
    80003a2c:	0009d797          	auipc	a5,0x9d
    80003a30:	eb87a783          	lw	a5,-328(a5) # 800a08e4 <log+0x1c>
    80003a34:	37fd                	addiw	a5,a5,-1
    80003a36:	04f65e63          	bge	a2,a5,80003a92 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1) panic("log_write outside of trans");
    80003a3a:	0009d797          	auipc	a5,0x9d
    80003a3e:	eae7a783          	lw	a5,-338(a5) # 800a08e8 <log+0x20>
    80003a42:	06f05063          	blez	a5,80003aa2 <log_write+0xa0>

  for (i = 0; i < log.lh.n; i++) {
    80003a46:	4781                	li	a5,0
    80003a48:	06c05563          	blez	a2,80003ab2 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)  // log absorption
    80003a4c:	44cc                	lw	a1,12(s1)
    80003a4e:	0009d717          	auipc	a4,0x9d
    80003a52:	eaa70713          	addi	a4,a4,-342 # 800a08f8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003a56:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)  // log absorption
    80003a58:	4314                	lw	a3,0(a4)
    80003a5a:	04b68c63          	beq	a3,a1,80003ab2 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003a5e:	2785                	addiw	a5,a5,1
    80003a60:	0711                	addi	a4,a4,4
    80003a62:	fef61be3          	bne	a2,a5,80003a58 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003a66:	0621                	addi	a2,a2,8
    80003a68:	060a                	slli	a2,a2,0x2
    80003a6a:	0009d797          	auipc	a5,0x9d
    80003a6e:	e5e78793          	addi	a5,a5,-418 # 800a08c8 <log>
    80003a72:	97b2                	add	a5,a5,a2
    80003a74:	44d8                	lw	a4,12(s1)
    80003a76:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003a78:	8526                	mv	a0,s1
    80003a7a:	fffff097          	auipc	ra,0xfffff
    80003a7e:	d9c080e7          	jalr	-612(ra) # 80002816 <bpin>
    log.lh.n++;
    80003a82:	0009d717          	auipc	a4,0x9d
    80003a86:	e4670713          	addi	a4,a4,-442 # 800a08c8 <log>
    80003a8a:	575c                	lw	a5,44(a4)
    80003a8c:	2785                	addiw	a5,a5,1
    80003a8e:	d75c                	sw	a5,44(a4)
    80003a90:	a82d                	j	80003aca <log_write+0xc8>
    panic("too big a transaction");
    80003a92:	00005517          	auipc	a0,0x5
    80003a96:	b0650513          	addi	a0,a0,-1274 # 80008598 <syscalls+0x1f0>
    80003a9a:	00002097          	auipc	ra,0x2
    80003a9e:	492080e7          	jalr	1170(ra) # 80005f2c <panic>
  if (log.outstanding < 1) panic("log_write outside of trans");
    80003aa2:	00005517          	auipc	a0,0x5
    80003aa6:	b0e50513          	addi	a0,a0,-1266 # 800085b0 <syscalls+0x208>
    80003aaa:	00002097          	auipc	ra,0x2
    80003aae:	482080e7          	jalr	1154(ra) # 80005f2c <panic>
  log.lh.block[i] = b->blockno;
    80003ab2:	00878693          	addi	a3,a5,8
    80003ab6:	068a                	slli	a3,a3,0x2
    80003ab8:	0009d717          	auipc	a4,0x9d
    80003abc:	e1070713          	addi	a4,a4,-496 # 800a08c8 <log>
    80003ac0:	9736                	add	a4,a4,a3
    80003ac2:	44d4                	lw	a3,12(s1)
    80003ac4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003ac6:	faf609e3          	beq	a2,a5,80003a78 <log_write+0x76>
  }
  release(&log.lock);
    80003aca:	0009d517          	auipc	a0,0x9d
    80003ace:	dfe50513          	addi	a0,a0,-514 # 800a08c8 <log>
    80003ad2:	00003097          	auipc	ra,0x3
    80003ad6:	a46080e7          	jalr	-1466(ra) # 80006518 <release>
}
    80003ada:	60e2                	ld	ra,24(sp)
    80003adc:	6442                	ld	s0,16(sp)
    80003ade:	64a2                	ld	s1,8(sp)
    80003ae0:	6902                	ld	s2,0(sp)
    80003ae2:	6105                	addi	sp,sp,32
    80003ae4:	8082                	ret

0000000080003ae6 <initsleeplock>:
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "sleeplock.h"

void initsleeplock(struct sleeplock *lk, char *name) {
    80003ae6:	1101                	addi	sp,sp,-32
    80003ae8:	ec06                	sd	ra,24(sp)
    80003aea:	e822                	sd	s0,16(sp)
    80003aec:	e426                	sd	s1,8(sp)
    80003aee:	e04a                	sd	s2,0(sp)
    80003af0:	1000                	addi	s0,sp,32
    80003af2:	84aa                	mv	s1,a0
    80003af4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003af6:	00005597          	auipc	a1,0x5
    80003afa:	ada58593          	addi	a1,a1,-1318 # 800085d0 <syscalls+0x228>
    80003afe:	0521                	addi	a0,a0,8
    80003b00:	00003097          	auipc	ra,0x3
    80003b04:	8d4080e7          	jalr	-1836(ra) # 800063d4 <initlock>
  lk->name = name;
    80003b08:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003b0c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b10:	0204a423          	sw	zero,40(s1)
}
    80003b14:	60e2                	ld	ra,24(sp)
    80003b16:	6442                	ld	s0,16(sp)
    80003b18:	64a2                	ld	s1,8(sp)
    80003b1a:	6902                	ld	s2,0(sp)
    80003b1c:	6105                	addi	sp,sp,32
    80003b1e:	8082                	ret

0000000080003b20 <acquiresleep>:

void acquiresleep(struct sleeplock *lk) {
    80003b20:	1101                	addi	sp,sp,-32
    80003b22:	ec06                	sd	ra,24(sp)
    80003b24:	e822                	sd	s0,16(sp)
    80003b26:	e426                	sd	s1,8(sp)
    80003b28:	e04a                	sd	s2,0(sp)
    80003b2a:	1000                	addi	s0,sp,32
    80003b2c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b2e:	00850913          	addi	s2,a0,8
    80003b32:	854a                	mv	a0,s2
    80003b34:	00003097          	auipc	ra,0x3
    80003b38:	930080e7          	jalr	-1744(ra) # 80006464 <acquire>
  while (lk->locked) {
    80003b3c:	409c                	lw	a5,0(s1)
    80003b3e:	cb89                	beqz	a5,80003b50 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003b40:	85ca                	mv	a1,s2
    80003b42:	8526                	mv	a0,s1
    80003b44:	ffffe097          	auipc	ra,0xffffe
    80003b48:	cac080e7          	jalr	-852(ra) # 800017f0 <sleep>
  while (lk->locked) {
    80003b4c:	409c                	lw	a5,0(s1)
    80003b4e:	fbed                	bnez	a5,80003b40 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003b50:	4785                	li	a5,1
    80003b52:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003b54:	ffffd097          	auipc	ra,0xffffd
    80003b58:	5f4080e7          	jalr	1524(ra) # 80001148 <myproc>
    80003b5c:	591c                	lw	a5,48(a0)
    80003b5e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003b60:	854a                	mv	a0,s2
    80003b62:	00003097          	auipc	ra,0x3
    80003b66:	9b6080e7          	jalr	-1610(ra) # 80006518 <release>
}
    80003b6a:	60e2                	ld	ra,24(sp)
    80003b6c:	6442                	ld	s0,16(sp)
    80003b6e:	64a2                	ld	s1,8(sp)
    80003b70:	6902                	ld	s2,0(sp)
    80003b72:	6105                	addi	sp,sp,32
    80003b74:	8082                	ret

0000000080003b76 <releasesleep>:

void releasesleep(struct sleeplock *lk) {
    80003b76:	1101                	addi	sp,sp,-32
    80003b78:	ec06                	sd	ra,24(sp)
    80003b7a:	e822                	sd	s0,16(sp)
    80003b7c:	e426                	sd	s1,8(sp)
    80003b7e:	e04a                	sd	s2,0(sp)
    80003b80:	1000                	addi	s0,sp,32
    80003b82:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b84:	00850913          	addi	s2,a0,8
    80003b88:	854a                	mv	a0,s2
    80003b8a:	00003097          	auipc	ra,0x3
    80003b8e:	8da080e7          	jalr	-1830(ra) # 80006464 <acquire>
  lk->locked = 0;
    80003b92:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b96:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003b9a:	8526                	mv	a0,s1
    80003b9c:	ffffe097          	auipc	ra,0xffffe
    80003ba0:	cb8080e7          	jalr	-840(ra) # 80001854 <wakeup>
  release(&lk->lk);
    80003ba4:	854a                	mv	a0,s2
    80003ba6:	00003097          	auipc	ra,0x3
    80003baa:	972080e7          	jalr	-1678(ra) # 80006518 <release>
}
    80003bae:	60e2                	ld	ra,24(sp)
    80003bb0:	6442                	ld	s0,16(sp)
    80003bb2:	64a2                	ld	s1,8(sp)
    80003bb4:	6902                	ld	s2,0(sp)
    80003bb6:	6105                	addi	sp,sp,32
    80003bb8:	8082                	ret

0000000080003bba <holdingsleep>:

int holdingsleep(struct sleeplock *lk) {
    80003bba:	7179                	addi	sp,sp,-48
    80003bbc:	f406                	sd	ra,40(sp)
    80003bbe:	f022                	sd	s0,32(sp)
    80003bc0:	ec26                	sd	s1,24(sp)
    80003bc2:	e84a                	sd	s2,16(sp)
    80003bc4:	e44e                	sd	s3,8(sp)
    80003bc6:	1800                	addi	s0,sp,48
    80003bc8:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    80003bca:	00850913          	addi	s2,a0,8
    80003bce:	854a                	mv	a0,s2
    80003bd0:	00003097          	auipc	ra,0x3
    80003bd4:	894080e7          	jalr	-1900(ra) # 80006464 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003bd8:	409c                	lw	a5,0(s1)
    80003bda:	ef99                	bnez	a5,80003bf8 <holdingsleep+0x3e>
    80003bdc:	4481                	li	s1,0
  release(&lk->lk);
    80003bde:	854a                	mv	a0,s2
    80003be0:	00003097          	auipc	ra,0x3
    80003be4:	938080e7          	jalr	-1736(ra) # 80006518 <release>
  return r;
}
    80003be8:	8526                	mv	a0,s1
    80003bea:	70a2                	ld	ra,40(sp)
    80003bec:	7402                	ld	s0,32(sp)
    80003bee:	64e2                	ld	s1,24(sp)
    80003bf0:	6942                	ld	s2,16(sp)
    80003bf2:	69a2                	ld	s3,8(sp)
    80003bf4:	6145                	addi	sp,sp,48
    80003bf6:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003bf8:	0284a983          	lw	s3,40(s1)
    80003bfc:	ffffd097          	auipc	ra,0xffffd
    80003c00:	54c080e7          	jalr	1356(ra) # 80001148 <myproc>
    80003c04:	5904                	lw	s1,48(a0)
    80003c06:	413484b3          	sub	s1,s1,s3
    80003c0a:	0014b493          	seqz	s1,s1
    80003c0e:	bfc1                	j	80003bde <holdingsleep+0x24>

0000000080003c10 <fileinit>:
struct {
  struct spinlock lock;
  struct file file[NFILE];
} ftable;

void fileinit(void) { initlock(&ftable.lock, "ftable"); }
    80003c10:	1141                	addi	sp,sp,-16
    80003c12:	e406                	sd	ra,8(sp)
    80003c14:	e022                	sd	s0,0(sp)
    80003c16:	0800                	addi	s0,sp,16
    80003c18:	00005597          	auipc	a1,0x5
    80003c1c:	9c858593          	addi	a1,a1,-1592 # 800085e0 <syscalls+0x238>
    80003c20:	0009d517          	auipc	a0,0x9d
    80003c24:	df050513          	addi	a0,a0,-528 # 800a0a10 <ftable>
    80003c28:	00002097          	auipc	ra,0x2
    80003c2c:	7ac080e7          	jalr	1964(ra) # 800063d4 <initlock>
    80003c30:	60a2                	ld	ra,8(sp)
    80003c32:	6402                	ld	s0,0(sp)
    80003c34:	0141                	addi	sp,sp,16
    80003c36:	8082                	ret

0000000080003c38 <filealloc>:

// Allocate a file structure.
struct file *filealloc(void) {
    80003c38:	1101                	addi	sp,sp,-32
    80003c3a:	ec06                	sd	ra,24(sp)
    80003c3c:	e822                	sd	s0,16(sp)
    80003c3e:	e426                	sd	s1,8(sp)
    80003c40:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003c42:	0009d517          	auipc	a0,0x9d
    80003c46:	dce50513          	addi	a0,a0,-562 # 800a0a10 <ftable>
    80003c4a:	00003097          	auipc	ra,0x3
    80003c4e:	81a080e7          	jalr	-2022(ra) # 80006464 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80003c52:	0009d497          	auipc	s1,0x9d
    80003c56:	dd648493          	addi	s1,s1,-554 # 800a0a28 <ftable+0x18>
    80003c5a:	0009e717          	auipc	a4,0x9e
    80003c5e:	d6e70713          	addi	a4,a4,-658 # 800a19c8 <disk>
    if (f->ref == 0) {
    80003c62:	40dc                	lw	a5,4(s1)
    80003c64:	cf99                	beqz	a5,80003c82 <filealloc+0x4a>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80003c66:	02848493          	addi	s1,s1,40
    80003c6a:	fee49ce3          	bne	s1,a4,80003c62 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003c6e:	0009d517          	auipc	a0,0x9d
    80003c72:	da250513          	addi	a0,a0,-606 # 800a0a10 <ftable>
    80003c76:	00003097          	auipc	ra,0x3
    80003c7a:	8a2080e7          	jalr	-1886(ra) # 80006518 <release>
  return 0;
    80003c7e:	4481                	li	s1,0
    80003c80:	a819                	j	80003c96 <filealloc+0x5e>
      f->ref = 1;
    80003c82:	4785                	li	a5,1
    80003c84:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003c86:	0009d517          	auipc	a0,0x9d
    80003c8a:	d8a50513          	addi	a0,a0,-630 # 800a0a10 <ftable>
    80003c8e:	00003097          	auipc	ra,0x3
    80003c92:	88a080e7          	jalr	-1910(ra) # 80006518 <release>
}
    80003c96:	8526                	mv	a0,s1
    80003c98:	60e2                	ld	ra,24(sp)
    80003c9a:	6442                	ld	s0,16(sp)
    80003c9c:	64a2                	ld	s1,8(sp)
    80003c9e:	6105                	addi	sp,sp,32
    80003ca0:	8082                	ret

0000000080003ca2 <filedup>:

// Increment ref count for file f.
struct file *filedup(struct file *f) {
    80003ca2:	1101                	addi	sp,sp,-32
    80003ca4:	ec06                	sd	ra,24(sp)
    80003ca6:	e822                	sd	s0,16(sp)
    80003ca8:	e426                	sd	s1,8(sp)
    80003caa:	1000                	addi	s0,sp,32
    80003cac:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003cae:	0009d517          	auipc	a0,0x9d
    80003cb2:	d6250513          	addi	a0,a0,-670 # 800a0a10 <ftable>
    80003cb6:	00002097          	auipc	ra,0x2
    80003cba:	7ae080e7          	jalr	1966(ra) # 80006464 <acquire>
  if (f->ref < 1) panic("filedup");
    80003cbe:	40dc                	lw	a5,4(s1)
    80003cc0:	02f05263          	blez	a5,80003ce4 <filedup+0x42>
  f->ref++;
    80003cc4:	2785                	addiw	a5,a5,1
    80003cc6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003cc8:	0009d517          	auipc	a0,0x9d
    80003ccc:	d4850513          	addi	a0,a0,-696 # 800a0a10 <ftable>
    80003cd0:	00003097          	auipc	ra,0x3
    80003cd4:	848080e7          	jalr	-1976(ra) # 80006518 <release>
  return f;
}
    80003cd8:	8526                	mv	a0,s1
    80003cda:	60e2                	ld	ra,24(sp)
    80003cdc:	6442                	ld	s0,16(sp)
    80003cde:	64a2                	ld	s1,8(sp)
    80003ce0:	6105                	addi	sp,sp,32
    80003ce2:	8082                	ret
  if (f->ref < 1) panic("filedup");
    80003ce4:	00005517          	auipc	a0,0x5
    80003ce8:	90450513          	addi	a0,a0,-1788 # 800085e8 <syscalls+0x240>
    80003cec:	00002097          	auipc	ra,0x2
    80003cf0:	240080e7          	jalr	576(ra) # 80005f2c <panic>

0000000080003cf4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f) {
    80003cf4:	7139                	addi	sp,sp,-64
    80003cf6:	fc06                	sd	ra,56(sp)
    80003cf8:	f822                	sd	s0,48(sp)
    80003cfa:	f426                	sd	s1,40(sp)
    80003cfc:	f04a                	sd	s2,32(sp)
    80003cfe:	ec4e                	sd	s3,24(sp)
    80003d00:	e852                	sd	s4,16(sp)
    80003d02:	e456                	sd	s5,8(sp)
    80003d04:	0080                	addi	s0,sp,64
    80003d06:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003d08:	0009d517          	auipc	a0,0x9d
    80003d0c:	d0850513          	addi	a0,a0,-760 # 800a0a10 <ftable>
    80003d10:	00002097          	auipc	ra,0x2
    80003d14:	754080e7          	jalr	1876(ra) # 80006464 <acquire>
  if (f->ref < 1) panic("fileclose");
    80003d18:	40dc                	lw	a5,4(s1)
    80003d1a:	06f05163          	blez	a5,80003d7c <fileclose+0x88>
  if (--f->ref > 0) {
    80003d1e:	37fd                	addiw	a5,a5,-1
    80003d20:	0007871b          	sext.w	a4,a5
    80003d24:	c0dc                	sw	a5,4(s1)
    80003d26:	06e04363          	bgtz	a4,80003d8c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003d2a:	0004a903          	lw	s2,0(s1)
    80003d2e:	0094ca83          	lbu	s5,9(s1)
    80003d32:	0104ba03          	ld	s4,16(s1)
    80003d36:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003d3a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003d3e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003d42:	0009d517          	auipc	a0,0x9d
    80003d46:	cce50513          	addi	a0,a0,-818 # 800a0a10 <ftable>
    80003d4a:	00002097          	auipc	ra,0x2
    80003d4e:	7ce080e7          	jalr	1998(ra) # 80006518 <release>

  if (ff.type == FD_PIPE) {
    80003d52:	4785                	li	a5,1
    80003d54:	04f90d63          	beq	s2,a5,80003dae <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    80003d58:	3979                	addiw	s2,s2,-2
    80003d5a:	4785                	li	a5,1
    80003d5c:	0527e063          	bltu	a5,s2,80003d9c <fileclose+0xa8>
    begin_op();
    80003d60:	00000097          	auipc	ra,0x0
    80003d64:	acc080e7          	jalr	-1332(ra) # 8000382c <begin_op>
    iput(ff.ip);
    80003d68:	854e                	mv	a0,s3
    80003d6a:	fffff097          	auipc	ra,0xfffff
    80003d6e:	2b0080e7          	jalr	688(ra) # 8000301a <iput>
    end_op();
    80003d72:	00000097          	auipc	ra,0x0
    80003d76:	b38080e7          	jalr	-1224(ra) # 800038aa <end_op>
    80003d7a:	a00d                	j	80003d9c <fileclose+0xa8>
  if (f->ref < 1) panic("fileclose");
    80003d7c:	00005517          	auipc	a0,0x5
    80003d80:	87450513          	addi	a0,a0,-1932 # 800085f0 <syscalls+0x248>
    80003d84:	00002097          	auipc	ra,0x2
    80003d88:	1a8080e7          	jalr	424(ra) # 80005f2c <panic>
    release(&ftable.lock);
    80003d8c:	0009d517          	auipc	a0,0x9d
    80003d90:	c8450513          	addi	a0,a0,-892 # 800a0a10 <ftable>
    80003d94:	00002097          	auipc	ra,0x2
    80003d98:	784080e7          	jalr	1924(ra) # 80006518 <release>
  }
}
    80003d9c:	70e2                	ld	ra,56(sp)
    80003d9e:	7442                	ld	s0,48(sp)
    80003da0:	74a2                	ld	s1,40(sp)
    80003da2:	7902                	ld	s2,32(sp)
    80003da4:	69e2                	ld	s3,24(sp)
    80003da6:	6a42                	ld	s4,16(sp)
    80003da8:	6aa2                	ld	s5,8(sp)
    80003daa:	6121                	addi	sp,sp,64
    80003dac:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003dae:	85d6                	mv	a1,s5
    80003db0:	8552                	mv	a0,s4
    80003db2:	00000097          	auipc	ra,0x0
    80003db6:	34c080e7          	jalr	844(ra) # 800040fe <pipeclose>
    80003dba:	b7cd                	j	80003d9c <fileclose+0xa8>

0000000080003dbc <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr) {
    80003dbc:	715d                	addi	sp,sp,-80
    80003dbe:	e486                	sd	ra,72(sp)
    80003dc0:	e0a2                	sd	s0,64(sp)
    80003dc2:	fc26                	sd	s1,56(sp)
    80003dc4:	f84a                	sd	s2,48(sp)
    80003dc6:	f44e                	sd	s3,40(sp)
    80003dc8:	0880                	addi	s0,sp,80
    80003dca:	84aa                	mv	s1,a0
    80003dcc:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003dce:	ffffd097          	auipc	ra,0xffffd
    80003dd2:	37a080e7          	jalr	890(ra) # 80001148 <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    80003dd6:	409c                	lw	a5,0(s1)
    80003dd8:	37f9                	addiw	a5,a5,-2
    80003dda:	4705                	li	a4,1
    80003ddc:	04f76763          	bltu	a4,a5,80003e2a <filestat+0x6e>
    80003de0:	892a                	mv	s2,a0
    ilock(f->ip);
    80003de2:	6c88                	ld	a0,24(s1)
    80003de4:	fffff097          	auipc	ra,0xfffff
    80003de8:	07c080e7          	jalr	124(ra) # 80002e60 <ilock>
    stati(f->ip, &st);
    80003dec:	fb840593          	addi	a1,s0,-72
    80003df0:	6c88                	ld	a0,24(s1)
    80003df2:	fffff097          	auipc	ra,0xfffff
    80003df6:	2f8080e7          	jalr	760(ra) # 800030ea <stati>
    iunlock(f->ip);
    80003dfa:	6c88                	ld	a0,24(s1)
    80003dfc:	fffff097          	auipc	ra,0xfffff
    80003e00:	126080e7          	jalr	294(ra) # 80002f22 <iunlock>
    if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0) return -1;
    80003e04:	46e1                	li	a3,24
    80003e06:	fb840613          	addi	a2,s0,-72
    80003e0a:	85ce                	mv	a1,s3
    80003e0c:	05093503          	ld	a0,80(s2)
    80003e10:	ffffd097          	auipc	ra,0xffffd
    80003e14:	ee0080e7          	jalr	-288(ra) # 80000cf0 <copyout>
    80003e18:	41f5551b          	sraiw	a0,a0,0x1f
    return 0;
  }
  return -1;
}
    80003e1c:	60a6                	ld	ra,72(sp)
    80003e1e:	6406                	ld	s0,64(sp)
    80003e20:	74e2                	ld	s1,56(sp)
    80003e22:	7942                	ld	s2,48(sp)
    80003e24:	79a2                	ld	s3,40(sp)
    80003e26:	6161                	addi	sp,sp,80
    80003e28:	8082                	ret
  return -1;
    80003e2a:	557d                	li	a0,-1
    80003e2c:	bfc5                	j	80003e1c <filestat+0x60>

0000000080003e2e <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n) {
    80003e2e:	7179                	addi	sp,sp,-48
    80003e30:	f406                	sd	ra,40(sp)
    80003e32:	f022                	sd	s0,32(sp)
    80003e34:	ec26                	sd	s1,24(sp)
    80003e36:	e84a                	sd	s2,16(sp)
    80003e38:	e44e                	sd	s3,8(sp)
    80003e3a:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0) return -1;
    80003e3c:	00854783          	lbu	a5,8(a0)
    80003e40:	c3d5                	beqz	a5,80003ee4 <fileread+0xb6>
    80003e42:	84aa                	mv	s1,a0
    80003e44:	89ae                	mv	s3,a1
    80003e46:	8932                	mv	s2,a2

  if (f->type == FD_PIPE) {
    80003e48:	411c                	lw	a5,0(a0)
    80003e4a:	4705                	li	a4,1
    80003e4c:	04e78963          	beq	a5,a4,80003e9e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80003e50:	470d                	li	a4,3
    80003e52:	04e78d63          	beq	a5,a4,80003eac <fileread+0x7e>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    80003e56:	4709                	li	a4,2
    80003e58:	06e79e63          	bne	a5,a4,80003ed4 <fileread+0xa6>
    ilock(f->ip);
    80003e5c:	6d08                	ld	a0,24(a0)
    80003e5e:	fffff097          	auipc	ra,0xfffff
    80003e62:	002080e7          	jalr	2(ra) # 80002e60 <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0) f->off += r;
    80003e66:	874a                	mv	a4,s2
    80003e68:	5094                	lw	a3,32(s1)
    80003e6a:	864e                	mv	a2,s3
    80003e6c:	4585                	li	a1,1
    80003e6e:	6c88                	ld	a0,24(s1)
    80003e70:	fffff097          	auipc	ra,0xfffff
    80003e74:	2a4080e7          	jalr	676(ra) # 80003114 <readi>
    80003e78:	892a                	mv	s2,a0
    80003e7a:	00a05563          	blez	a0,80003e84 <fileread+0x56>
    80003e7e:	509c                	lw	a5,32(s1)
    80003e80:	9fa9                	addw	a5,a5,a0
    80003e82:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e84:	6c88                	ld	a0,24(s1)
    80003e86:	fffff097          	auipc	ra,0xfffff
    80003e8a:	09c080e7          	jalr	156(ra) # 80002f22 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003e8e:	854a                	mv	a0,s2
    80003e90:	70a2                	ld	ra,40(sp)
    80003e92:	7402                	ld	s0,32(sp)
    80003e94:	64e2                	ld	s1,24(sp)
    80003e96:	6942                	ld	s2,16(sp)
    80003e98:	69a2                	ld	s3,8(sp)
    80003e9a:	6145                	addi	sp,sp,48
    80003e9c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003e9e:	6908                	ld	a0,16(a0)
    80003ea0:	00000097          	auipc	ra,0x0
    80003ea4:	3c6080e7          	jalr	966(ra) # 80004266 <piperead>
    80003ea8:	892a                	mv	s2,a0
    80003eaa:	b7d5                	j	80003e8e <fileread+0x60>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    80003eac:	02451783          	lh	a5,36(a0)
    80003eb0:	03079693          	slli	a3,a5,0x30
    80003eb4:	92c1                	srli	a3,a3,0x30
    80003eb6:	4725                	li	a4,9
    80003eb8:	02d76863          	bltu	a4,a3,80003ee8 <fileread+0xba>
    80003ebc:	0792                	slli	a5,a5,0x4
    80003ebe:	0009d717          	auipc	a4,0x9d
    80003ec2:	ab270713          	addi	a4,a4,-1358 # 800a0970 <devsw>
    80003ec6:	97ba                	add	a5,a5,a4
    80003ec8:	639c                	ld	a5,0(a5)
    80003eca:	c38d                	beqz	a5,80003eec <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003ecc:	4505                	li	a0,1
    80003ece:	9782                	jalr	a5
    80003ed0:	892a                	mv	s2,a0
    80003ed2:	bf75                	j	80003e8e <fileread+0x60>
    panic("fileread");
    80003ed4:	00004517          	auipc	a0,0x4
    80003ed8:	72c50513          	addi	a0,a0,1836 # 80008600 <syscalls+0x258>
    80003edc:	00002097          	auipc	ra,0x2
    80003ee0:	050080e7          	jalr	80(ra) # 80005f2c <panic>
  if (f->readable == 0) return -1;
    80003ee4:	597d                	li	s2,-1
    80003ee6:	b765                	j	80003e8e <fileread+0x60>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    80003ee8:	597d                	li	s2,-1
    80003eea:	b755                	j	80003e8e <fileread+0x60>
    80003eec:	597d                	li	s2,-1
    80003eee:	b745                	j	80003e8e <fileread+0x60>

0000000080003ef0 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n) {
    80003ef0:	715d                	addi	sp,sp,-80
    80003ef2:	e486                	sd	ra,72(sp)
    80003ef4:	e0a2                	sd	s0,64(sp)
    80003ef6:	fc26                	sd	s1,56(sp)
    80003ef8:	f84a                	sd	s2,48(sp)
    80003efa:	f44e                	sd	s3,40(sp)
    80003efc:	f052                	sd	s4,32(sp)
    80003efe:	ec56                	sd	s5,24(sp)
    80003f00:	e85a                	sd	s6,16(sp)
    80003f02:	e45e                	sd	s7,8(sp)
    80003f04:	e062                	sd	s8,0(sp)
    80003f06:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if (f->writable == 0) return -1;
    80003f08:	00954783          	lbu	a5,9(a0)
    80003f0c:	10078663          	beqz	a5,80004018 <filewrite+0x128>
    80003f10:	892a                	mv	s2,a0
    80003f12:	8b2e                	mv	s6,a1
    80003f14:	8a32                	mv	s4,a2

  if (f->type == FD_PIPE) {
    80003f16:	411c                	lw	a5,0(a0)
    80003f18:	4705                	li	a4,1
    80003f1a:	02e78263          	beq	a5,a4,80003f3e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80003f1e:	470d                	li	a4,3
    80003f20:	02e78663          	beq	a5,a4,80003f4c <filewrite+0x5c>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    80003f24:	4709                	li	a4,2
    80003f26:	0ee79163          	bne	a5,a4,80004008 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    80003f2a:	0ac05d63          	blez	a2,80003fe4 <filewrite+0xf4>
    int i = 0;
    80003f2e:	4981                	li	s3,0
    80003f30:	6b85                	lui	s7,0x1
    80003f32:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003f36:	6c05                	lui	s8,0x1
    80003f38:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003f3c:	a861                	j	80003fd4 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003f3e:	6908                	ld	a0,16(a0)
    80003f40:	00000097          	auipc	ra,0x0
    80003f44:	22e080e7          	jalr	558(ra) # 8000416e <pipewrite>
    80003f48:	8a2a                	mv	s4,a0
    80003f4a:	a045                	j	80003fea <filewrite+0xfa>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    80003f4c:	02451783          	lh	a5,36(a0)
    80003f50:	03079693          	slli	a3,a5,0x30
    80003f54:	92c1                	srli	a3,a3,0x30
    80003f56:	4725                	li	a4,9
    80003f58:	0cd76263          	bltu	a4,a3,8000401c <filewrite+0x12c>
    80003f5c:	0792                	slli	a5,a5,0x4
    80003f5e:	0009d717          	auipc	a4,0x9d
    80003f62:	a1270713          	addi	a4,a4,-1518 # 800a0970 <devsw>
    80003f66:	97ba                	add	a5,a5,a4
    80003f68:	679c                	ld	a5,8(a5)
    80003f6a:	cbdd                	beqz	a5,80004020 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003f6c:	4505                	li	a0,1
    80003f6e:	9782                	jalr	a5
    80003f70:	8a2a                	mv	s4,a0
    80003f72:	a8a5                	j	80003fea <filewrite+0xfa>
    80003f74:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if (n1 > max) n1 = max;

      begin_op();
    80003f78:	00000097          	auipc	ra,0x0
    80003f7c:	8b4080e7          	jalr	-1868(ra) # 8000382c <begin_op>
      ilock(f->ip);
    80003f80:	01893503          	ld	a0,24(s2)
    80003f84:	fffff097          	auipc	ra,0xfffff
    80003f88:	edc080e7          	jalr	-292(ra) # 80002e60 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0) f->off += r;
    80003f8c:	8756                	mv	a4,s5
    80003f8e:	02092683          	lw	a3,32(s2)
    80003f92:	01698633          	add	a2,s3,s6
    80003f96:	4585                	li	a1,1
    80003f98:	01893503          	ld	a0,24(s2)
    80003f9c:	fffff097          	auipc	ra,0xfffff
    80003fa0:	270080e7          	jalr	624(ra) # 8000320c <writei>
    80003fa4:	84aa                	mv	s1,a0
    80003fa6:	00a05763          	blez	a0,80003fb4 <filewrite+0xc4>
    80003faa:	02092783          	lw	a5,32(s2)
    80003fae:	9fa9                	addw	a5,a5,a0
    80003fb0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003fb4:	01893503          	ld	a0,24(s2)
    80003fb8:	fffff097          	auipc	ra,0xfffff
    80003fbc:	f6a080e7          	jalr	-150(ra) # 80002f22 <iunlock>
      end_op();
    80003fc0:	00000097          	auipc	ra,0x0
    80003fc4:	8ea080e7          	jalr	-1814(ra) # 800038aa <end_op>

      if (r != n1) {
    80003fc8:	009a9f63          	bne	s5,s1,80003fe6 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003fcc:	013489bb          	addw	s3,s1,s3
    while (i < n) {
    80003fd0:	0149db63          	bge	s3,s4,80003fe6 <filewrite+0xf6>
      int n1 = n - i;
    80003fd4:	413a04bb          	subw	s1,s4,s3
    80003fd8:	0004879b          	sext.w	a5,s1
    80003fdc:	f8fbdce3          	bge	s7,a5,80003f74 <filewrite+0x84>
    80003fe0:	84e2                	mv	s1,s8
    80003fe2:	bf49                	j	80003f74 <filewrite+0x84>
    int i = 0;
    80003fe4:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003fe6:	013a1f63          	bne	s4,s3,80004004 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003fea:	8552                	mv	a0,s4
    80003fec:	60a6                	ld	ra,72(sp)
    80003fee:	6406                	ld	s0,64(sp)
    80003ff0:	74e2                	ld	s1,56(sp)
    80003ff2:	7942                	ld	s2,48(sp)
    80003ff4:	79a2                	ld	s3,40(sp)
    80003ff6:	7a02                	ld	s4,32(sp)
    80003ff8:	6ae2                	ld	s5,24(sp)
    80003ffa:	6b42                	ld	s6,16(sp)
    80003ffc:	6ba2                	ld	s7,8(sp)
    80003ffe:	6c02                	ld	s8,0(sp)
    80004000:	6161                	addi	sp,sp,80
    80004002:	8082                	ret
    ret = (i == n ? n : -1);
    80004004:	5a7d                	li	s4,-1
    80004006:	b7d5                	j	80003fea <filewrite+0xfa>
    panic("filewrite");
    80004008:	00004517          	auipc	a0,0x4
    8000400c:	60850513          	addi	a0,a0,1544 # 80008610 <syscalls+0x268>
    80004010:	00002097          	auipc	ra,0x2
    80004014:	f1c080e7          	jalr	-228(ra) # 80005f2c <panic>
  if (f->writable == 0) return -1;
    80004018:	5a7d                	li	s4,-1
    8000401a:	bfc1                	j	80003fea <filewrite+0xfa>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    8000401c:	5a7d                	li	s4,-1
    8000401e:	b7f1                	j	80003fea <filewrite+0xfa>
    80004020:	5a7d                	li	s4,-1
    80004022:	b7e1                	j	80003fea <filewrite+0xfa>

0000000080004024 <pipealloc>:
  uint nwrite;    // number of bytes written
  int readopen;   // read fd is still open
  int writeopen;  // write fd is still open
};

int pipealloc(struct file **f0, struct file **f1) {
    80004024:	7179                	addi	sp,sp,-48
    80004026:	f406                	sd	ra,40(sp)
    80004028:	f022                	sd	s0,32(sp)
    8000402a:	ec26                	sd	s1,24(sp)
    8000402c:	e84a                	sd	s2,16(sp)
    8000402e:	e44e                	sd	s3,8(sp)
    80004030:	e052                	sd	s4,0(sp)
    80004032:	1800                	addi	s0,sp,48
    80004034:	84aa                	mv	s1,a0
    80004036:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004038:	0005b023          	sd	zero,0(a1)
    8000403c:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0) goto bad;
    80004040:	00000097          	auipc	ra,0x0
    80004044:	bf8080e7          	jalr	-1032(ra) # 80003c38 <filealloc>
    80004048:	e088                	sd	a0,0(s1)
    8000404a:	c551                	beqz	a0,800040d6 <pipealloc+0xb2>
    8000404c:	00000097          	auipc	ra,0x0
    80004050:	bec080e7          	jalr	-1044(ra) # 80003c38 <filealloc>
    80004054:	00aa3023          	sd	a0,0(s4)
    80004058:	c92d                	beqz	a0,800040ca <pipealloc+0xa6>
  if ((pi = (struct pipe *)kalloc()) == 0) goto bad;
    8000405a:	ffffc097          	auipc	ra,0xffffc
    8000405e:	0c0080e7          	jalr	192(ra) # 8000011a <kalloc>
    80004062:	892a                	mv	s2,a0
    80004064:	c125                	beqz	a0,800040c4 <pipealloc+0xa0>
  pi->readopen = 1;
    80004066:	4985                	li	s3,1
    80004068:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000406c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004070:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004074:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004078:	00004597          	auipc	a1,0x4
    8000407c:	5a858593          	addi	a1,a1,1448 # 80008620 <syscalls+0x278>
    80004080:	00002097          	auipc	ra,0x2
    80004084:	354080e7          	jalr	852(ra) # 800063d4 <initlock>
  (*f0)->type = FD_PIPE;
    80004088:	609c                	ld	a5,0(s1)
    8000408a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000408e:	609c                	ld	a5,0(s1)
    80004090:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004094:	609c                	ld	a5,0(s1)
    80004096:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000409a:	609c                	ld	a5,0(s1)
    8000409c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800040a0:	000a3783          	ld	a5,0(s4)
    800040a4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800040a8:	000a3783          	ld	a5,0(s4)
    800040ac:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800040b0:	000a3783          	ld	a5,0(s4)
    800040b4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800040b8:	000a3783          	ld	a5,0(s4)
    800040bc:	0127b823          	sd	s2,16(a5)
  return 0;
    800040c0:	4501                	li	a0,0
    800040c2:	a025                	j	800040ea <pipealloc+0xc6>

bad:
  if (pi) kfree((char *)pi);
  if (*f0) fileclose(*f0);
    800040c4:	6088                	ld	a0,0(s1)
    800040c6:	e501                	bnez	a0,800040ce <pipealloc+0xaa>
    800040c8:	a039                	j	800040d6 <pipealloc+0xb2>
    800040ca:	6088                	ld	a0,0(s1)
    800040cc:	c51d                	beqz	a0,800040fa <pipealloc+0xd6>
    800040ce:	00000097          	auipc	ra,0x0
    800040d2:	c26080e7          	jalr	-986(ra) # 80003cf4 <fileclose>
  if (*f1) fileclose(*f1);
    800040d6:	000a3783          	ld	a5,0(s4)
  return -1;
    800040da:	557d                	li	a0,-1
  if (*f1) fileclose(*f1);
    800040dc:	c799                	beqz	a5,800040ea <pipealloc+0xc6>
    800040de:	853e                	mv	a0,a5
    800040e0:	00000097          	auipc	ra,0x0
    800040e4:	c14080e7          	jalr	-1004(ra) # 80003cf4 <fileclose>
  return -1;
    800040e8:	557d                	li	a0,-1
}
    800040ea:	70a2                	ld	ra,40(sp)
    800040ec:	7402                	ld	s0,32(sp)
    800040ee:	64e2                	ld	s1,24(sp)
    800040f0:	6942                	ld	s2,16(sp)
    800040f2:	69a2                	ld	s3,8(sp)
    800040f4:	6a02                	ld	s4,0(sp)
    800040f6:	6145                	addi	sp,sp,48
    800040f8:	8082                	ret
  return -1;
    800040fa:	557d                	li	a0,-1
    800040fc:	b7fd                	j	800040ea <pipealloc+0xc6>

00000000800040fe <pipeclose>:

void pipeclose(struct pipe *pi, int writable) {
    800040fe:	1101                	addi	sp,sp,-32
    80004100:	ec06                	sd	ra,24(sp)
    80004102:	e822                	sd	s0,16(sp)
    80004104:	e426                	sd	s1,8(sp)
    80004106:	e04a                	sd	s2,0(sp)
    80004108:	1000                	addi	s0,sp,32
    8000410a:	84aa                	mv	s1,a0
    8000410c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000410e:	00002097          	auipc	ra,0x2
    80004112:	356080e7          	jalr	854(ra) # 80006464 <acquire>
  if (writable) {
    80004116:	02090d63          	beqz	s2,80004150 <pipeclose+0x52>
    pi->writeopen = 0;
    8000411a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000411e:	21848513          	addi	a0,s1,536
    80004122:	ffffd097          	auipc	ra,0xffffd
    80004126:	732080e7          	jalr	1842(ra) # 80001854 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    8000412a:	2204b783          	ld	a5,544(s1)
    8000412e:	eb95                	bnez	a5,80004162 <pipeclose+0x64>
    release(&pi->lock);
    80004130:	8526                	mv	a0,s1
    80004132:	00002097          	auipc	ra,0x2
    80004136:	3e6080e7          	jalr	998(ra) # 80006518 <release>
    kfree((char *)pi);
    8000413a:	8526                	mv	a0,s1
    8000413c:	ffffc097          	auipc	ra,0xffffc
    80004140:	ee0080e7          	jalr	-288(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004144:	60e2                	ld	ra,24(sp)
    80004146:	6442                	ld	s0,16(sp)
    80004148:	64a2                	ld	s1,8(sp)
    8000414a:	6902                	ld	s2,0(sp)
    8000414c:	6105                	addi	sp,sp,32
    8000414e:	8082                	ret
    pi->readopen = 0;
    80004150:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004154:	21c48513          	addi	a0,s1,540
    80004158:	ffffd097          	auipc	ra,0xffffd
    8000415c:	6fc080e7          	jalr	1788(ra) # 80001854 <wakeup>
    80004160:	b7e9                	j	8000412a <pipeclose+0x2c>
    release(&pi->lock);
    80004162:	8526                	mv	a0,s1
    80004164:	00002097          	auipc	ra,0x2
    80004168:	3b4080e7          	jalr	948(ra) # 80006518 <release>
}
    8000416c:	bfe1                	j	80004144 <pipeclose+0x46>

000000008000416e <pipewrite>:

int pipewrite(struct pipe *pi, uint64 addr, int n) {
    8000416e:	711d                	addi	sp,sp,-96
    80004170:	ec86                	sd	ra,88(sp)
    80004172:	e8a2                	sd	s0,80(sp)
    80004174:	e4a6                	sd	s1,72(sp)
    80004176:	e0ca                	sd	s2,64(sp)
    80004178:	fc4e                	sd	s3,56(sp)
    8000417a:	f852                	sd	s4,48(sp)
    8000417c:	f456                	sd	s5,40(sp)
    8000417e:	f05a                	sd	s6,32(sp)
    80004180:	ec5e                	sd	s7,24(sp)
    80004182:	e862                	sd	s8,16(sp)
    80004184:	1080                	addi	s0,sp,96
    80004186:	84aa                	mv	s1,a0
    80004188:	8aae                	mv	s5,a1
    8000418a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000418c:	ffffd097          	auipc	ra,0xffffd
    80004190:	fbc080e7          	jalr	-68(ra) # 80001148 <myproc>
    80004194:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004196:	8526                	mv	a0,s1
    80004198:	00002097          	auipc	ra,0x2
    8000419c:	2cc080e7          	jalr	716(ra) # 80006464 <acquire>
  while (i < n) {
    800041a0:	0b405663          	blez	s4,8000424c <pipewrite+0xde>
  int i = 0;
    800041a4:	4901                	li	s2,0
    if (pi->nwrite == pi->nread + PIPESIZE) {  // DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1) break;
    800041a6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800041a8:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800041ac:	21c48b93          	addi	s7,s1,540
    800041b0:	a089                	j	800041f2 <pipewrite+0x84>
      release(&pi->lock);
    800041b2:	8526                	mv	a0,s1
    800041b4:	00002097          	auipc	ra,0x2
    800041b8:	364080e7          	jalr	868(ra) # 80006518 <release>
      return -1;
    800041bc:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800041be:	854a                	mv	a0,s2
    800041c0:	60e6                	ld	ra,88(sp)
    800041c2:	6446                	ld	s0,80(sp)
    800041c4:	64a6                	ld	s1,72(sp)
    800041c6:	6906                	ld	s2,64(sp)
    800041c8:	79e2                	ld	s3,56(sp)
    800041ca:	7a42                	ld	s4,48(sp)
    800041cc:	7aa2                	ld	s5,40(sp)
    800041ce:	7b02                	ld	s6,32(sp)
    800041d0:	6be2                	ld	s7,24(sp)
    800041d2:	6c42                	ld	s8,16(sp)
    800041d4:	6125                	addi	sp,sp,96
    800041d6:	8082                	ret
      wakeup(&pi->nread);
    800041d8:	8562                	mv	a0,s8
    800041da:	ffffd097          	auipc	ra,0xffffd
    800041de:	67a080e7          	jalr	1658(ra) # 80001854 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800041e2:	85a6                	mv	a1,s1
    800041e4:	855e                	mv	a0,s7
    800041e6:	ffffd097          	auipc	ra,0xffffd
    800041ea:	60a080e7          	jalr	1546(ra) # 800017f0 <sleep>
  while (i < n) {
    800041ee:	07495063          	bge	s2,s4,8000424e <pipewrite+0xe0>
    if (pi->readopen == 0 || killed(pr)) {
    800041f2:	2204a783          	lw	a5,544(s1)
    800041f6:	dfd5                	beqz	a5,800041b2 <pipewrite+0x44>
    800041f8:	854e                	mv	a0,s3
    800041fa:	ffffe097          	auipc	ra,0xffffe
    800041fe:	89e080e7          	jalr	-1890(ra) # 80001a98 <killed>
    80004202:	f945                	bnez	a0,800041b2 <pipewrite+0x44>
    if (pi->nwrite == pi->nread + PIPESIZE) {  // DOC: pipewrite-full
    80004204:	2184a783          	lw	a5,536(s1)
    80004208:	21c4a703          	lw	a4,540(s1)
    8000420c:	2007879b          	addiw	a5,a5,512
    80004210:	fcf704e3          	beq	a4,a5,800041d8 <pipewrite+0x6a>
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1) break;
    80004214:	4685                	li	a3,1
    80004216:	01590633          	add	a2,s2,s5
    8000421a:	faf40593          	addi	a1,s0,-81
    8000421e:	0509b503          	ld	a0,80(s3)
    80004222:	ffffd097          	auipc	ra,0xffffd
    80004226:	b76080e7          	jalr	-1162(ra) # 80000d98 <copyin>
    8000422a:	03650263          	beq	a0,s6,8000424e <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000422e:	21c4a783          	lw	a5,540(s1)
    80004232:	0017871b          	addiw	a4,a5,1
    80004236:	20e4ae23          	sw	a4,540(s1)
    8000423a:	1ff7f793          	andi	a5,a5,511
    8000423e:	97a6                	add	a5,a5,s1
    80004240:	faf44703          	lbu	a4,-81(s0)
    80004244:	00e78c23          	sb	a4,24(a5)
      i++;
    80004248:	2905                	addiw	s2,s2,1
    8000424a:	b755                	j	800041ee <pipewrite+0x80>
  int i = 0;
    8000424c:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000424e:	21848513          	addi	a0,s1,536
    80004252:	ffffd097          	auipc	ra,0xffffd
    80004256:	602080e7          	jalr	1538(ra) # 80001854 <wakeup>
  release(&pi->lock);
    8000425a:	8526                	mv	a0,s1
    8000425c:	00002097          	auipc	ra,0x2
    80004260:	2bc080e7          	jalr	700(ra) # 80006518 <release>
  return i;
    80004264:	bfa9                	j	800041be <pipewrite+0x50>

0000000080004266 <piperead>:

int piperead(struct pipe *pi, uint64 addr, int n) {
    80004266:	715d                	addi	sp,sp,-80
    80004268:	e486                	sd	ra,72(sp)
    8000426a:	e0a2                	sd	s0,64(sp)
    8000426c:	fc26                	sd	s1,56(sp)
    8000426e:	f84a                	sd	s2,48(sp)
    80004270:	f44e                	sd	s3,40(sp)
    80004272:	f052                	sd	s4,32(sp)
    80004274:	ec56                	sd	s5,24(sp)
    80004276:	e85a                	sd	s6,16(sp)
    80004278:	0880                	addi	s0,sp,80
    8000427a:	84aa                	mv	s1,a0
    8000427c:	892e                	mv	s2,a1
    8000427e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004280:	ffffd097          	auipc	ra,0xffffd
    80004284:	ec8080e7          	jalr	-312(ra) # 80001148 <myproc>
    80004288:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000428a:	8526                	mv	a0,s1
    8000428c:	00002097          	auipc	ra,0x2
    80004290:	1d8080e7          	jalr	472(ra) # 80006464 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    80004294:	2184a703          	lw	a4,536(s1)
    80004298:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock);  // DOC: piperead-sleep
    8000429c:	21848993          	addi	s3,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    800042a0:	02f71763          	bne	a4,a5,800042ce <piperead+0x68>
    800042a4:	2244a783          	lw	a5,548(s1)
    800042a8:	c39d                	beqz	a5,800042ce <piperead+0x68>
    if (killed(pr)) {
    800042aa:	8552                	mv	a0,s4
    800042ac:	ffffd097          	auipc	ra,0xffffd
    800042b0:	7ec080e7          	jalr	2028(ra) # 80001a98 <killed>
    800042b4:	e949                	bnez	a0,80004346 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock);  // DOC: piperead-sleep
    800042b6:	85a6                	mv	a1,s1
    800042b8:	854e                	mv	a0,s3
    800042ba:	ffffd097          	auipc	ra,0xffffd
    800042be:	536080e7          	jalr	1334(ra) # 800017f0 <sleep>
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    800042c2:	2184a703          	lw	a4,536(s1)
    800042c6:	21c4a783          	lw	a5,540(s1)
    800042ca:	fcf70de3          	beq	a4,a5,800042a4 <piperead+0x3e>
  }
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    800042ce:	4981                	li	s3,0
    if (pi->nread == pi->nwrite) break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) break;
    800042d0:	5b7d                	li	s6,-1
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    800042d2:	05505463          	blez	s5,8000431a <piperead+0xb4>
    if (pi->nread == pi->nwrite) break;
    800042d6:	2184a783          	lw	a5,536(s1)
    800042da:	21c4a703          	lw	a4,540(s1)
    800042de:	02f70e63          	beq	a4,a5,8000431a <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800042e2:	0017871b          	addiw	a4,a5,1
    800042e6:	20e4ac23          	sw	a4,536(s1)
    800042ea:	1ff7f793          	andi	a5,a5,511
    800042ee:	97a6                	add	a5,a5,s1
    800042f0:	0187c783          	lbu	a5,24(a5)
    800042f4:	faf40fa3          	sb	a5,-65(s0)
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) break;
    800042f8:	4685                	li	a3,1
    800042fa:	fbf40613          	addi	a2,s0,-65
    800042fe:	85ca                	mv	a1,s2
    80004300:	050a3503          	ld	a0,80(s4)
    80004304:	ffffd097          	auipc	ra,0xffffd
    80004308:	9ec080e7          	jalr	-1556(ra) # 80000cf0 <copyout>
    8000430c:	01650763          	beq	a0,s6,8000431a <piperead+0xb4>
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    80004310:	2985                	addiw	s3,s3,1
    80004312:	0905                	addi	s2,s2,1
    80004314:	fd3a91e3          	bne	s5,s3,800042d6 <piperead+0x70>
    80004318:	89d6                	mv	s3,s5
  }
  wakeup(&pi->nwrite);  // DOC: piperead-wakeup
    8000431a:	21c48513          	addi	a0,s1,540
    8000431e:	ffffd097          	auipc	ra,0xffffd
    80004322:	536080e7          	jalr	1334(ra) # 80001854 <wakeup>
  release(&pi->lock);
    80004326:	8526                	mv	a0,s1
    80004328:	00002097          	auipc	ra,0x2
    8000432c:	1f0080e7          	jalr	496(ra) # 80006518 <release>
  return i;
}
    80004330:	854e                	mv	a0,s3
    80004332:	60a6                	ld	ra,72(sp)
    80004334:	6406                	ld	s0,64(sp)
    80004336:	74e2                	ld	s1,56(sp)
    80004338:	7942                	ld	s2,48(sp)
    8000433a:	79a2                	ld	s3,40(sp)
    8000433c:	7a02                	ld	s4,32(sp)
    8000433e:	6ae2                	ld	s5,24(sp)
    80004340:	6b42                	ld	s6,16(sp)
    80004342:	6161                	addi	sp,sp,80
    80004344:	8082                	ret
      release(&pi->lock);
    80004346:	8526                	mv	a0,s1
    80004348:	00002097          	auipc	ra,0x2
    8000434c:	1d0080e7          	jalr	464(ra) # 80006518 <release>
      return -1;
    80004350:	59fd                	li	s3,-1
    80004352:	bff9                	j	80004330 <piperead+0xca>

0000000080004354 <flags2perm>:
#include "defs.h"
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags) {
    80004354:	1141                	addi	sp,sp,-16
    80004356:	e422                	sd	s0,8(sp)
    80004358:	0800                	addi	s0,sp,16
    8000435a:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1) perm = PTE_X;
    8000435c:	8905                	andi	a0,a0,1
    8000435e:	050e                	slli	a0,a0,0x3
  if (flags & 0x2) perm |= PTE_W;
    80004360:	8b89                	andi	a5,a5,2
    80004362:	c399                	beqz	a5,80004368 <flags2perm+0x14>
    80004364:	00456513          	ori	a0,a0,4
  return perm;
}
    80004368:	6422                	ld	s0,8(sp)
    8000436a:	0141                	addi	sp,sp,16
    8000436c:	8082                	ret

000000008000436e <exec>:

int exec(char *path, char **argv) {
    8000436e:	de010113          	addi	sp,sp,-544
    80004372:	20113c23          	sd	ra,536(sp)
    80004376:	20813823          	sd	s0,528(sp)
    8000437a:	20913423          	sd	s1,520(sp)
    8000437e:	21213023          	sd	s2,512(sp)
    80004382:	ffce                	sd	s3,504(sp)
    80004384:	fbd2                	sd	s4,496(sp)
    80004386:	f7d6                	sd	s5,488(sp)
    80004388:	f3da                	sd	s6,480(sp)
    8000438a:	efde                	sd	s7,472(sp)
    8000438c:	ebe2                	sd	s8,464(sp)
    8000438e:	e7e6                	sd	s9,456(sp)
    80004390:	e3ea                	sd	s10,448(sp)
    80004392:	ff6e                	sd	s11,440(sp)
    80004394:	1400                	addi	s0,sp,544
    80004396:	892a                	mv	s2,a0
    80004398:	dea43423          	sd	a0,-536(s0)
    8000439c:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800043a0:	ffffd097          	auipc	ra,0xffffd
    800043a4:	da8080e7          	jalr	-600(ra) # 80001148 <myproc>
    800043a8:	84aa                	mv	s1,a0

  begin_op();
    800043aa:	fffff097          	auipc	ra,0xfffff
    800043ae:	482080e7          	jalr	1154(ra) # 8000382c <begin_op>

  if ((ip = namei(path)) == 0) {
    800043b2:	854a                	mv	a0,s2
    800043b4:	fffff097          	auipc	ra,0xfffff
    800043b8:	258080e7          	jalr	600(ra) # 8000360c <namei>
    800043bc:	c93d                	beqz	a0,80004432 <exec+0xc4>
    800043be:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800043c0:	fffff097          	auipc	ra,0xfffff
    800043c4:	aa0080e7          	jalr	-1376(ra) # 80002e60 <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf)) goto bad;
    800043c8:	04000713          	li	a4,64
    800043cc:	4681                	li	a3,0
    800043ce:	e5040613          	addi	a2,s0,-432
    800043d2:	4581                	li	a1,0
    800043d4:	8556                	mv	a0,s5
    800043d6:	fffff097          	auipc	ra,0xfffff
    800043da:	d3e080e7          	jalr	-706(ra) # 80003114 <readi>
    800043de:	04000793          	li	a5,64
    800043e2:	00f51a63          	bne	a0,a5,800043f6 <exec+0x88>

  if (elf.magic != ELF_MAGIC) goto bad;
    800043e6:	e5042703          	lw	a4,-432(s0)
    800043ea:	464c47b7          	lui	a5,0x464c4
    800043ee:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800043f2:	04f70663          	beq	a4,a5,8000443e <exec+0xd0>
  return argc;  // this ends up in a0, the first argument to main(argc, argv)

bad:
  if (pagetable) proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    800043f6:	8556                	mv	a0,s5
    800043f8:	fffff097          	auipc	ra,0xfffff
    800043fc:	cca080e7          	jalr	-822(ra) # 800030c2 <iunlockput>
    end_op();
    80004400:	fffff097          	auipc	ra,0xfffff
    80004404:	4aa080e7          	jalr	1194(ra) # 800038aa <end_op>
  }
  return -1;
    80004408:	557d                	li	a0,-1
}
    8000440a:	21813083          	ld	ra,536(sp)
    8000440e:	21013403          	ld	s0,528(sp)
    80004412:	20813483          	ld	s1,520(sp)
    80004416:	20013903          	ld	s2,512(sp)
    8000441a:	79fe                	ld	s3,504(sp)
    8000441c:	7a5e                	ld	s4,496(sp)
    8000441e:	7abe                	ld	s5,488(sp)
    80004420:	7b1e                	ld	s6,480(sp)
    80004422:	6bfe                	ld	s7,472(sp)
    80004424:	6c5e                	ld	s8,464(sp)
    80004426:	6cbe                	ld	s9,456(sp)
    80004428:	6d1e                	ld	s10,448(sp)
    8000442a:	7dfa                	ld	s11,440(sp)
    8000442c:	22010113          	addi	sp,sp,544
    80004430:	8082                	ret
    end_op();
    80004432:	fffff097          	auipc	ra,0xfffff
    80004436:	478080e7          	jalr	1144(ra) # 800038aa <end_op>
    return -1;
    8000443a:	557d                	li	a0,-1
    8000443c:	b7f9                	j	8000440a <exec+0x9c>
  if ((pagetable = proc_pagetable(p)) == 0) goto bad;
    8000443e:	8526                	mv	a0,s1
    80004440:	ffffd097          	auipc	ra,0xffffd
    80004444:	dcc080e7          	jalr	-564(ra) # 8000120c <proc_pagetable>
    80004448:	8b2a                	mv	s6,a0
    8000444a:	d555                	beqz	a0,800043f6 <exec+0x88>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000444c:	e7042783          	lw	a5,-400(s0)
    80004450:	e8845703          	lhu	a4,-376(s0)
    80004454:	c735                	beqz	a4,800044c0 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004456:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004458:	e0043423          	sd	zero,-504(s0)
    if (ph.vaddr % PGSIZE != 0) goto bad;
    8000445c:	6a05                	lui	s4,0x1
    8000445e:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004462:	dee43023          	sd	a4,-544(s0)
static int loadseg(pagetable_t pagetable, uint64 va, struct inode *ip,
                   uint offset, uint sz) {
  uint i, n;
  uint64 pa;

  for (i = 0; i < sz; i += PGSIZE) {
    80004466:	6d85                	lui	s11,0x1
    80004468:	7d7d                	lui	s10,0xfffff
    8000446a:	ac99                	j	800046c0 <exec+0x352>
    pa = walkaddr(pagetable, va + i);
    if (pa == 0) panic("loadseg: address should exist");
    8000446c:	00004517          	auipc	a0,0x4
    80004470:	1bc50513          	addi	a0,a0,444 # 80008628 <syscalls+0x280>
    80004474:	00002097          	auipc	ra,0x2
    80004478:	ab8080e7          	jalr	-1352(ra) # 80005f2c <panic>
    if (sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n) return -1;
    8000447c:	874a                	mv	a4,s2
    8000447e:	009c86bb          	addw	a3,s9,s1
    80004482:	4581                	li	a1,0
    80004484:	8556                	mv	a0,s5
    80004486:	fffff097          	auipc	ra,0xfffff
    8000448a:	c8e080e7          	jalr	-882(ra) # 80003114 <readi>
    8000448e:	2501                	sext.w	a0,a0
    80004490:	1ca91563          	bne	s2,a0,8000465a <exec+0x2ec>
  for (i = 0; i < sz; i += PGSIZE) {
    80004494:	009d84bb          	addw	s1,s11,s1
    80004498:	013d09bb          	addw	s3,s10,s3
    8000449c:	2174f263          	bgeu	s1,s7,800046a0 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    800044a0:	02049593          	slli	a1,s1,0x20
    800044a4:	9181                	srli	a1,a1,0x20
    800044a6:	95e2                	add	a1,a1,s8
    800044a8:	855a                	mv	a0,s6
    800044aa:	ffffc097          	auipc	ra,0xffffc
    800044ae:	08c080e7          	jalr	140(ra) # 80000536 <walkaddr>
    800044b2:	862a                	mv	a2,a0
    if (pa == 0) panic("loadseg: address should exist");
    800044b4:	dd45                	beqz	a0,8000446c <exec+0xfe>
      n = PGSIZE;
    800044b6:	8952                	mv	s2,s4
    if (sz - i < PGSIZE)
    800044b8:	fd49f2e3          	bgeu	s3,s4,8000447c <exec+0x10e>
      n = sz - i;
    800044bc:	894e                	mv	s2,s3
    800044be:	bf7d                	j	8000447c <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800044c0:	4901                	li	s2,0
  iunlockput(ip);
    800044c2:	8556                	mv	a0,s5
    800044c4:	fffff097          	auipc	ra,0xfffff
    800044c8:	bfe080e7          	jalr	-1026(ra) # 800030c2 <iunlockput>
  end_op();
    800044cc:	fffff097          	auipc	ra,0xfffff
    800044d0:	3de080e7          	jalr	990(ra) # 800038aa <end_op>
  p = myproc();
    800044d4:	ffffd097          	auipc	ra,0xffffd
    800044d8:	c74080e7          	jalr	-908(ra) # 80001148 <myproc>
    800044dc:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800044de:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800044e2:	6785                	lui	a5,0x1
    800044e4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800044e6:	97ca                	add	a5,a5,s2
    800044e8:	777d                	lui	a4,0xfffff
    800044ea:	8ff9                	and	a5,a5,a4
    800044ec:	def43c23          	sd	a5,-520(s0)
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0) goto bad;
    800044f0:	4691                	li	a3,4
    800044f2:	6609                	lui	a2,0x2
    800044f4:	963e                	add	a2,a2,a5
    800044f6:	85be                	mv	a1,a5
    800044f8:	855a                	mv	a0,s6
    800044fa:	ffffc097          	auipc	ra,0xffffc
    800044fe:	5d8080e7          	jalr	1496(ra) # 80000ad2 <uvmalloc>
    80004502:	8c2a                	mv	s8,a0
  ip = 0;
    80004504:	4a81                	li	s5,0
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0) goto bad;
    80004506:	14050a63          	beqz	a0,8000465a <exec+0x2ec>
  uvmclear(pagetable, sz - 2 * PGSIZE);
    8000450a:	75f9                	lui	a1,0xffffe
    8000450c:	95aa                	add	a1,a1,a0
    8000450e:	855a                	mv	a0,s6
    80004510:	ffffc097          	auipc	ra,0xffffc
    80004514:	7ae080e7          	jalr	1966(ra) # 80000cbe <uvmclear>
  stackbase = sp - PGSIZE;
    80004518:	7afd                	lui	s5,0xfffff
    8000451a:	9ae2                	add	s5,s5,s8
  for (argc = 0; argv[argc]; argc++) {
    8000451c:	df043783          	ld	a5,-528(s0)
    80004520:	6388                	ld	a0,0(a5)
    80004522:	c925                	beqz	a0,80004592 <exec+0x224>
    80004524:	e9040993          	addi	s3,s0,-368
    80004528:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000452c:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    8000452e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004530:	ffffc097          	auipc	ra,0xffffc
    80004534:	dc6080e7          	jalr	-570(ra) # 800002f6 <strlen>
    80004538:	0015079b          	addiw	a5,a0,1
    8000453c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16;  // riscv sp must be 16-byte aligned
    80004540:	ff07f913          	andi	s2,a5,-16
    if (sp < stackbase) goto bad;
    80004544:	15596263          	bltu	s2,s5,80004688 <exec+0x31a>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004548:	df043d83          	ld	s11,-528(s0)
    8000454c:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004550:	8552                	mv	a0,s4
    80004552:	ffffc097          	auipc	ra,0xffffc
    80004556:	da4080e7          	jalr	-604(ra) # 800002f6 <strlen>
    8000455a:	0015069b          	addiw	a3,a0,1
    8000455e:	8652                	mv	a2,s4
    80004560:	85ca                	mv	a1,s2
    80004562:	855a                	mv	a0,s6
    80004564:	ffffc097          	auipc	ra,0xffffc
    80004568:	78c080e7          	jalr	1932(ra) # 80000cf0 <copyout>
    8000456c:	12054263          	bltz	a0,80004690 <exec+0x322>
    ustack[argc] = sp;
    80004570:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++) {
    80004574:	0485                	addi	s1,s1,1
    80004576:	008d8793          	addi	a5,s11,8
    8000457a:	def43823          	sd	a5,-528(s0)
    8000457e:	008db503          	ld	a0,8(s11)
    80004582:	c911                	beqz	a0,80004596 <exec+0x228>
    if (argc >= MAXARG) goto bad;
    80004584:	09a1                	addi	s3,s3,8
    80004586:	fb3c95e3          	bne	s9,s3,80004530 <exec+0x1c2>
  sz = sz1;
    8000458a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000458e:	4a81                	li	s5,0
    80004590:	a0e9                	j	8000465a <exec+0x2ec>
  sp = sz;
    80004592:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    80004594:	4481                	li	s1,0
  ustack[argc] = 0;
    80004596:	00349793          	slli	a5,s1,0x3
    8000459a:	f9078793          	addi	a5,a5,-112
    8000459e:	97a2                	add	a5,a5,s0
    800045a0:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    800045a4:	00148693          	addi	a3,s1,1
    800045a8:	068e                	slli	a3,a3,0x3
    800045aa:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800045ae:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase) goto bad;
    800045b2:	01597663          	bgeu	s2,s5,800045be <exec+0x250>
  sz = sz1;
    800045b6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045ba:	4a81                	li	s5,0
    800045bc:	a879                	j	8000465a <exec+0x2ec>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    800045be:	e9040613          	addi	a2,s0,-368
    800045c2:	85ca                	mv	a1,s2
    800045c4:	855a                	mv	a0,s6
    800045c6:	ffffc097          	auipc	ra,0xffffc
    800045ca:	72a080e7          	jalr	1834(ra) # 80000cf0 <copyout>
    800045ce:	0c054563          	bltz	a0,80004698 <exec+0x32a>
  p->trapframe->a1 = sp;
    800045d2:	058bb783          	ld	a5,88(s7)
    800045d6:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    800045da:	de843783          	ld	a5,-536(s0)
    800045de:	0007c703          	lbu	a4,0(a5)
    800045e2:	cf11                	beqz	a4,800045fe <exec+0x290>
    800045e4:	0785                	addi	a5,a5,1
    if (*s == '/') last = s + 1;
    800045e6:	02f00693          	li	a3,47
    800045ea:	a039                	j	800045f8 <exec+0x28a>
    800045ec:	def43423          	sd	a5,-536(s0)
  for (last = s = path; *s; s++)
    800045f0:	0785                	addi	a5,a5,1
    800045f2:	fff7c703          	lbu	a4,-1(a5)
    800045f6:	c701                	beqz	a4,800045fe <exec+0x290>
    if (*s == '/') last = s + 1;
    800045f8:	fed71ce3          	bne	a4,a3,800045f0 <exec+0x282>
    800045fc:	bfc5                	j	800045ec <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    800045fe:	4641                	li	a2,16
    80004600:	de843583          	ld	a1,-536(s0)
    80004604:	158b8513          	addi	a0,s7,344
    80004608:	ffffc097          	auipc	ra,0xffffc
    8000460c:	cbc080e7          	jalr	-836(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    80004610:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004614:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004618:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000461c:	058bb783          	ld	a5,88(s7)
    80004620:	e6843703          	ld	a4,-408(s0)
    80004624:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;          // initial stack pointer
    80004626:	058bb783          	ld	a5,88(s7)
    8000462a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000462e:	85ea                	mv	a1,s10
    80004630:	ffffd097          	auipc	ra,0xffffd
    80004634:	c78080e7          	jalr	-904(ra) # 800012a8 <proc_freepagetable>
  if (p->pid == 1) {
    80004638:	030ba703          	lw	a4,48(s7)
    8000463c:	4785                	li	a5,1
    8000463e:	00f70563          	beq	a4,a5,80004648 <exec+0x2da>
  return argc;  // this ends up in a0, the first argument to main(argc, argv)
    80004642:	0004851b          	sext.w	a0,s1
    80004646:	b3d1                	j	8000440a <exec+0x9c>
    vmprint(p->pagetable);
    80004648:	050bb503          	ld	a0,80(s7)
    8000464c:	ffffd097          	auipc	ra,0xffffd
    80004650:	952080e7          	jalr	-1710(ra) # 80000f9e <vmprint>
    80004654:	b7fd                	j	80004642 <exec+0x2d4>
    80004656:	df243c23          	sd	s2,-520(s0)
  if (pagetable) proc_freepagetable(pagetable, sz);
    8000465a:	df843583          	ld	a1,-520(s0)
    8000465e:	855a                	mv	a0,s6
    80004660:	ffffd097          	auipc	ra,0xffffd
    80004664:	c48080e7          	jalr	-952(ra) # 800012a8 <proc_freepagetable>
  if (ip) {
    80004668:	d80a97e3          	bnez	s5,800043f6 <exec+0x88>
  return -1;
    8000466c:	557d                	li	a0,-1
    8000466e:	bb71                	j	8000440a <exec+0x9c>
    80004670:	df243c23          	sd	s2,-520(s0)
    80004674:	b7dd                	j	8000465a <exec+0x2ec>
    80004676:	df243c23          	sd	s2,-520(s0)
    8000467a:	b7c5                	j	8000465a <exec+0x2ec>
    8000467c:	df243c23          	sd	s2,-520(s0)
    80004680:	bfe9                	j	8000465a <exec+0x2ec>
    80004682:	df243c23          	sd	s2,-520(s0)
    80004686:	bfd1                	j	8000465a <exec+0x2ec>
  sz = sz1;
    80004688:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000468c:	4a81                	li	s5,0
    8000468e:	b7f1                	j	8000465a <exec+0x2ec>
  sz = sz1;
    80004690:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004694:	4a81                	li	s5,0
    80004696:	b7d1                	j	8000465a <exec+0x2ec>
  sz = sz1;
    80004698:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000469c:	4a81                	li	s5,0
    8000469e:	bf75                	j	8000465a <exec+0x2ec>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    800046a0:	df843903          	ld	s2,-520(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800046a4:	e0843783          	ld	a5,-504(s0)
    800046a8:	0017869b          	addiw	a3,a5,1
    800046ac:	e0d43423          	sd	a3,-504(s0)
    800046b0:	e0043783          	ld	a5,-512(s0)
    800046b4:	0387879b          	addiw	a5,a5,56
    800046b8:	e8845703          	lhu	a4,-376(s0)
    800046bc:	e0e6d3e3          	bge	a3,a4,800044c2 <exec+0x154>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph)) goto bad;
    800046c0:	2781                	sext.w	a5,a5
    800046c2:	e0f43023          	sd	a5,-512(s0)
    800046c6:	03800713          	li	a4,56
    800046ca:	86be                	mv	a3,a5
    800046cc:	e1840613          	addi	a2,s0,-488
    800046d0:	4581                	li	a1,0
    800046d2:	8556                	mv	a0,s5
    800046d4:	fffff097          	auipc	ra,0xfffff
    800046d8:	a40080e7          	jalr	-1472(ra) # 80003114 <readi>
    800046dc:	03800793          	li	a5,56
    800046e0:	f6f51be3          	bne	a0,a5,80004656 <exec+0x2e8>
    if (ph.type != ELF_PROG_LOAD) continue;
    800046e4:	e1842783          	lw	a5,-488(s0)
    800046e8:	4705                	li	a4,1
    800046ea:	fae79de3          	bne	a5,a4,800046a4 <exec+0x336>
    if (ph.memsz < ph.filesz) goto bad;
    800046ee:	e4043483          	ld	s1,-448(s0)
    800046f2:	e3843783          	ld	a5,-456(s0)
    800046f6:	f6f4ede3          	bltu	s1,a5,80004670 <exec+0x302>
    if (ph.vaddr + ph.memsz < ph.vaddr) goto bad;
    800046fa:	e2843783          	ld	a5,-472(s0)
    800046fe:	94be                	add	s1,s1,a5
    80004700:	f6f4ebe3          	bltu	s1,a5,80004676 <exec+0x308>
    if (ph.vaddr % PGSIZE != 0) goto bad;
    80004704:	de043703          	ld	a4,-544(s0)
    80004708:	8ff9                	and	a5,a5,a4
    8000470a:	fbad                	bnez	a5,8000467c <exec+0x30e>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    8000470c:	e1c42503          	lw	a0,-484(s0)
    80004710:	00000097          	auipc	ra,0x0
    80004714:	c44080e7          	jalr	-956(ra) # 80004354 <flags2perm>
    80004718:	86aa                	mv	a3,a0
    8000471a:	8626                	mv	a2,s1
    8000471c:	85ca                	mv	a1,s2
    8000471e:	855a                	mv	a0,s6
    80004720:	ffffc097          	auipc	ra,0xffffc
    80004724:	3b2080e7          	jalr	946(ra) # 80000ad2 <uvmalloc>
    80004728:	dea43c23          	sd	a0,-520(s0)
    8000472c:	d939                	beqz	a0,80004682 <exec+0x314>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0) goto bad;
    8000472e:	e2843c03          	ld	s8,-472(s0)
    80004732:	e2042c83          	lw	s9,-480(s0)
    80004736:	e3842b83          	lw	s7,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    8000473a:	f60b83e3          	beqz	s7,800046a0 <exec+0x332>
    8000473e:	89de                	mv	s3,s7
    80004740:	4481                	li	s1,0
    80004742:	bbb9                	j	800044a0 <exec+0x132>

0000000080004744 <argfd>:
#include "file.h"
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int argfd(int n, int *pfd, struct file **pf) {
    80004744:	7179                	addi	sp,sp,-48
    80004746:	f406                	sd	ra,40(sp)
    80004748:	f022                	sd	s0,32(sp)
    8000474a:	ec26                	sd	s1,24(sp)
    8000474c:	e84a                	sd	s2,16(sp)
    8000474e:	1800                	addi	s0,sp,48
    80004750:	892e                	mv	s2,a1
    80004752:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004754:	fdc40593          	addi	a1,s0,-36
    80004758:	ffffe097          	auipc	ra,0xffffe
    8000475c:	b62080e7          	jalr	-1182(ra) # 800022ba <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
    80004760:	fdc42703          	lw	a4,-36(s0)
    80004764:	47bd                	li	a5,15
    80004766:	02e7eb63          	bltu	a5,a4,8000479c <argfd+0x58>
    8000476a:	ffffd097          	auipc	ra,0xffffd
    8000476e:	9de080e7          	jalr	-1570(ra) # 80001148 <myproc>
    80004772:	fdc42703          	lw	a4,-36(s0)
    80004776:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ff552ca>
    8000477a:	078e                	slli	a5,a5,0x3
    8000477c:	953e                	add	a0,a0,a5
    8000477e:	611c                	ld	a5,0(a0)
    80004780:	c385                	beqz	a5,800047a0 <argfd+0x5c>
  if (pfd) *pfd = fd;
    80004782:	00090463          	beqz	s2,8000478a <argfd+0x46>
    80004786:	00e92023          	sw	a4,0(s2)
  if (pf) *pf = f;
  return 0;
    8000478a:	4501                	li	a0,0
  if (pf) *pf = f;
    8000478c:	c091                	beqz	s1,80004790 <argfd+0x4c>
    8000478e:	e09c                	sd	a5,0(s1)
}
    80004790:	70a2                	ld	ra,40(sp)
    80004792:	7402                	ld	s0,32(sp)
    80004794:	64e2                	ld	s1,24(sp)
    80004796:	6942                	ld	s2,16(sp)
    80004798:	6145                	addi	sp,sp,48
    8000479a:	8082                	ret
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
    8000479c:	557d                	li	a0,-1
    8000479e:	bfcd                	j	80004790 <argfd+0x4c>
    800047a0:	557d                	li	a0,-1
    800047a2:	b7fd                	j	80004790 <argfd+0x4c>

00000000800047a4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int fdalloc(struct file *f) {
    800047a4:	1101                	addi	sp,sp,-32
    800047a6:	ec06                	sd	ra,24(sp)
    800047a8:	e822                	sd	s0,16(sp)
    800047aa:	e426                	sd	s1,8(sp)
    800047ac:	1000                	addi	s0,sp,32
    800047ae:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800047b0:	ffffd097          	auipc	ra,0xffffd
    800047b4:	998080e7          	jalr	-1640(ra) # 80001148 <myproc>
    800047b8:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    800047ba:	0d050793          	addi	a5,a0,208
    800047be:	4501                	li	a0,0
    800047c0:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    800047c2:	6398                	ld	a4,0(a5)
    800047c4:	cb19                	beqz	a4,800047da <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++) {
    800047c6:	2505                	addiw	a0,a0,1
    800047c8:	07a1                	addi	a5,a5,8
    800047ca:	fed51ce3          	bne	a0,a3,800047c2 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800047ce:	557d                	li	a0,-1
}
    800047d0:	60e2                	ld	ra,24(sp)
    800047d2:	6442                	ld	s0,16(sp)
    800047d4:	64a2                	ld	s1,8(sp)
    800047d6:	6105                	addi	sp,sp,32
    800047d8:	8082                	ret
      p->ofile[fd] = f;
    800047da:	01a50793          	addi	a5,a0,26
    800047de:	078e                	slli	a5,a5,0x3
    800047e0:	963e                	add	a2,a2,a5
    800047e2:	e204                	sd	s1,0(a2)
      return fd;
    800047e4:	b7f5                	j	800047d0 <fdalloc+0x2c>

00000000800047e6 <create>:
  iunlockput(dp);
  end_op();
  return -1;
}

static struct inode *create(char *path, short type, short major, short minor) {
    800047e6:	715d                	addi	sp,sp,-80
    800047e8:	e486                	sd	ra,72(sp)
    800047ea:	e0a2                	sd	s0,64(sp)
    800047ec:	fc26                	sd	s1,56(sp)
    800047ee:	f84a                	sd	s2,48(sp)
    800047f0:	f44e                	sd	s3,40(sp)
    800047f2:	f052                	sd	s4,32(sp)
    800047f4:	ec56                	sd	s5,24(sp)
    800047f6:	e85a                	sd	s6,16(sp)
    800047f8:	0880                	addi	s0,sp,80
    800047fa:	8b2e                	mv	s6,a1
    800047fc:	89b2                	mv	s3,a2
    800047fe:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0) return 0;
    80004800:	fb040593          	addi	a1,s0,-80
    80004804:	fffff097          	auipc	ra,0xfffff
    80004808:	e26080e7          	jalr	-474(ra) # 8000362a <nameiparent>
    8000480c:	84aa                	mv	s1,a0
    8000480e:	14050f63          	beqz	a0,8000496c <create+0x186>

  ilock(dp);
    80004812:	ffffe097          	auipc	ra,0xffffe
    80004816:	64e080e7          	jalr	1614(ra) # 80002e60 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    8000481a:	4601                	li	a2,0
    8000481c:	fb040593          	addi	a1,s0,-80
    80004820:	8526                	mv	a0,s1
    80004822:	fffff097          	auipc	ra,0xfffff
    80004826:	b22080e7          	jalr	-1246(ra) # 80003344 <dirlookup>
    8000482a:	8aaa                	mv	s5,a0
    8000482c:	c931                	beqz	a0,80004880 <create+0x9a>
    iunlockput(dp);
    8000482e:	8526                	mv	a0,s1
    80004830:	fffff097          	auipc	ra,0xfffff
    80004834:	892080e7          	jalr	-1902(ra) # 800030c2 <iunlockput>
    ilock(ip);
    80004838:	8556                	mv	a0,s5
    8000483a:	ffffe097          	auipc	ra,0xffffe
    8000483e:	626080e7          	jalr	1574(ra) # 80002e60 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004842:	000b059b          	sext.w	a1,s6
    80004846:	4789                	li	a5,2
    80004848:	02f59563          	bne	a1,a5,80004872 <create+0x8c>
    8000484c:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ff552f4>
    80004850:	37f9                	addiw	a5,a5,-2
    80004852:	17c2                	slli	a5,a5,0x30
    80004854:	93c1                	srli	a5,a5,0x30
    80004856:	4705                	li	a4,1
    80004858:	00f76d63          	bltu	a4,a5,80004872 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000485c:	8556                	mv	a0,s5
    8000485e:	60a6                	ld	ra,72(sp)
    80004860:	6406                	ld	s0,64(sp)
    80004862:	74e2                	ld	s1,56(sp)
    80004864:	7942                	ld	s2,48(sp)
    80004866:	79a2                	ld	s3,40(sp)
    80004868:	7a02                	ld	s4,32(sp)
    8000486a:	6ae2                	ld	s5,24(sp)
    8000486c:	6b42                	ld	s6,16(sp)
    8000486e:	6161                	addi	sp,sp,80
    80004870:	8082                	ret
    iunlockput(ip);
    80004872:	8556                	mv	a0,s5
    80004874:	fffff097          	auipc	ra,0xfffff
    80004878:	84e080e7          	jalr	-1970(ra) # 800030c2 <iunlockput>
    return 0;
    8000487c:	4a81                	li	s5,0
    8000487e:	bff9                	j	8000485c <create+0x76>
  if ((ip = ialloc(dp->dev, type)) == 0) {
    80004880:	85da                	mv	a1,s6
    80004882:	4088                	lw	a0,0(s1)
    80004884:	ffffe097          	auipc	ra,0xffffe
    80004888:	43e080e7          	jalr	1086(ra) # 80002cc2 <ialloc>
    8000488c:	8a2a                	mv	s4,a0
    8000488e:	c539                	beqz	a0,800048dc <create+0xf6>
  ilock(ip);
    80004890:	ffffe097          	auipc	ra,0xffffe
    80004894:	5d0080e7          	jalr	1488(ra) # 80002e60 <ilock>
  ip->major = major;
    80004898:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000489c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800048a0:	4905                	li	s2,1
    800048a2:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800048a6:	8552                	mv	a0,s4
    800048a8:	ffffe097          	auipc	ra,0xffffe
    800048ac:	4ec080e7          	jalr	1260(ra) # 80002d94 <iupdate>
  if (type == T_DIR) {  // Create . and .. entries.
    800048b0:	000b059b          	sext.w	a1,s6
    800048b4:	03258b63          	beq	a1,s2,800048ea <create+0x104>
  if (dirlink(dp, name, ip->inum) < 0) goto fail;
    800048b8:	004a2603          	lw	a2,4(s4)
    800048bc:	fb040593          	addi	a1,s0,-80
    800048c0:	8526                	mv	a0,s1
    800048c2:	fffff097          	auipc	ra,0xfffff
    800048c6:	c98080e7          	jalr	-872(ra) # 8000355a <dirlink>
    800048ca:	06054f63          	bltz	a0,80004948 <create+0x162>
  iunlockput(dp);
    800048ce:	8526                	mv	a0,s1
    800048d0:	ffffe097          	auipc	ra,0xffffe
    800048d4:	7f2080e7          	jalr	2034(ra) # 800030c2 <iunlockput>
  return ip;
    800048d8:	8ad2                	mv	s5,s4
    800048da:	b749                	j	8000485c <create+0x76>
    iunlockput(dp);
    800048dc:	8526                	mv	a0,s1
    800048de:	ffffe097          	auipc	ra,0xffffe
    800048e2:	7e4080e7          	jalr	2020(ra) # 800030c2 <iunlockput>
    return 0;
    800048e6:	8ad2                	mv	s5,s4
    800048e8:	bf95                	j	8000485c <create+0x76>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800048ea:	004a2603          	lw	a2,4(s4)
    800048ee:	00004597          	auipc	a1,0x4
    800048f2:	d5a58593          	addi	a1,a1,-678 # 80008648 <syscalls+0x2a0>
    800048f6:	8552                	mv	a0,s4
    800048f8:	fffff097          	auipc	ra,0xfffff
    800048fc:	c62080e7          	jalr	-926(ra) # 8000355a <dirlink>
    80004900:	04054463          	bltz	a0,80004948 <create+0x162>
    80004904:	40d0                	lw	a2,4(s1)
    80004906:	00004597          	auipc	a1,0x4
    8000490a:	d4a58593          	addi	a1,a1,-694 # 80008650 <syscalls+0x2a8>
    8000490e:	8552                	mv	a0,s4
    80004910:	fffff097          	auipc	ra,0xfffff
    80004914:	c4a080e7          	jalr	-950(ra) # 8000355a <dirlink>
    80004918:	02054863          	bltz	a0,80004948 <create+0x162>
  if (dirlink(dp, name, ip->inum) < 0) goto fail;
    8000491c:	004a2603          	lw	a2,4(s4)
    80004920:	fb040593          	addi	a1,s0,-80
    80004924:	8526                	mv	a0,s1
    80004926:	fffff097          	auipc	ra,0xfffff
    8000492a:	c34080e7          	jalr	-972(ra) # 8000355a <dirlink>
    8000492e:	00054d63          	bltz	a0,80004948 <create+0x162>
    dp->nlink++;  // for ".."
    80004932:	04a4d783          	lhu	a5,74(s1)
    80004936:	2785                	addiw	a5,a5,1
    80004938:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000493c:	8526                	mv	a0,s1
    8000493e:	ffffe097          	auipc	ra,0xffffe
    80004942:	456080e7          	jalr	1110(ra) # 80002d94 <iupdate>
    80004946:	b761                	j	800048ce <create+0xe8>
  ip->nlink = 0;
    80004948:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000494c:	8552                	mv	a0,s4
    8000494e:	ffffe097          	auipc	ra,0xffffe
    80004952:	446080e7          	jalr	1094(ra) # 80002d94 <iupdate>
  iunlockput(ip);
    80004956:	8552                	mv	a0,s4
    80004958:	ffffe097          	auipc	ra,0xffffe
    8000495c:	76a080e7          	jalr	1898(ra) # 800030c2 <iunlockput>
  iunlockput(dp);
    80004960:	8526                	mv	a0,s1
    80004962:	ffffe097          	auipc	ra,0xffffe
    80004966:	760080e7          	jalr	1888(ra) # 800030c2 <iunlockput>
  return 0;
    8000496a:	bdcd                	j	8000485c <create+0x76>
  if ((dp = nameiparent(path, name)) == 0) return 0;
    8000496c:	8aaa                	mv	s5,a0
    8000496e:	b5fd                	j	8000485c <create+0x76>

0000000080004970 <sys_dup>:
uint64 sys_dup(void) {
    80004970:	7179                	addi	sp,sp,-48
    80004972:	f406                	sd	ra,40(sp)
    80004974:	f022                	sd	s0,32(sp)
    80004976:	ec26                	sd	s1,24(sp)
    80004978:	e84a                	sd	s2,16(sp)
    8000497a:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0) return -1;
    8000497c:	fd840613          	addi	a2,s0,-40
    80004980:	4581                	li	a1,0
    80004982:	4501                	li	a0,0
    80004984:	00000097          	auipc	ra,0x0
    80004988:	dc0080e7          	jalr	-576(ra) # 80004744 <argfd>
    8000498c:	57fd                	li	a5,-1
    8000498e:	02054363          	bltz	a0,800049b4 <sys_dup+0x44>
  if ((fd = fdalloc(f)) < 0) return -1;
    80004992:	fd843903          	ld	s2,-40(s0)
    80004996:	854a                	mv	a0,s2
    80004998:	00000097          	auipc	ra,0x0
    8000499c:	e0c080e7          	jalr	-500(ra) # 800047a4 <fdalloc>
    800049a0:	84aa                	mv	s1,a0
    800049a2:	57fd                	li	a5,-1
    800049a4:	00054863          	bltz	a0,800049b4 <sys_dup+0x44>
  filedup(f);
    800049a8:	854a                	mv	a0,s2
    800049aa:	fffff097          	auipc	ra,0xfffff
    800049ae:	2f8080e7          	jalr	760(ra) # 80003ca2 <filedup>
  return fd;
    800049b2:	87a6                	mv	a5,s1
}
    800049b4:	853e                	mv	a0,a5
    800049b6:	70a2                	ld	ra,40(sp)
    800049b8:	7402                	ld	s0,32(sp)
    800049ba:	64e2                	ld	s1,24(sp)
    800049bc:	6942                	ld	s2,16(sp)
    800049be:	6145                	addi	sp,sp,48
    800049c0:	8082                	ret

00000000800049c2 <sys_read>:
uint64 sys_read(void) {
    800049c2:	7179                	addi	sp,sp,-48
    800049c4:	f406                	sd	ra,40(sp)
    800049c6:	f022                	sd	s0,32(sp)
    800049c8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800049ca:	fd840593          	addi	a1,s0,-40
    800049ce:	4505                	li	a0,1
    800049d0:	ffffe097          	auipc	ra,0xffffe
    800049d4:	90a080e7          	jalr	-1782(ra) # 800022da <argaddr>
  argint(2, &n);
    800049d8:	fe440593          	addi	a1,s0,-28
    800049dc:	4509                	li	a0,2
    800049de:	ffffe097          	auipc	ra,0xffffe
    800049e2:	8dc080e7          	jalr	-1828(ra) # 800022ba <argint>
  if (argfd(0, 0, &f) < 0) return -1;
    800049e6:	fe840613          	addi	a2,s0,-24
    800049ea:	4581                	li	a1,0
    800049ec:	4501                	li	a0,0
    800049ee:	00000097          	auipc	ra,0x0
    800049f2:	d56080e7          	jalr	-682(ra) # 80004744 <argfd>
    800049f6:	87aa                	mv	a5,a0
    800049f8:	557d                	li	a0,-1
    800049fa:	0007cc63          	bltz	a5,80004a12 <sys_read+0x50>
  return fileread(f, p, n);
    800049fe:	fe442603          	lw	a2,-28(s0)
    80004a02:	fd843583          	ld	a1,-40(s0)
    80004a06:	fe843503          	ld	a0,-24(s0)
    80004a0a:	fffff097          	auipc	ra,0xfffff
    80004a0e:	424080e7          	jalr	1060(ra) # 80003e2e <fileread>
}
    80004a12:	70a2                	ld	ra,40(sp)
    80004a14:	7402                	ld	s0,32(sp)
    80004a16:	6145                	addi	sp,sp,48
    80004a18:	8082                	ret

0000000080004a1a <sys_write>:
uint64 sys_write(void) {
    80004a1a:	7179                	addi	sp,sp,-48
    80004a1c:	f406                	sd	ra,40(sp)
    80004a1e:	f022                	sd	s0,32(sp)
    80004a20:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004a22:	fd840593          	addi	a1,s0,-40
    80004a26:	4505                	li	a0,1
    80004a28:	ffffe097          	auipc	ra,0xffffe
    80004a2c:	8b2080e7          	jalr	-1870(ra) # 800022da <argaddr>
  argint(2, &n);
    80004a30:	fe440593          	addi	a1,s0,-28
    80004a34:	4509                	li	a0,2
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	884080e7          	jalr	-1916(ra) # 800022ba <argint>
  if (argfd(0, 0, &f) < 0) return -1;
    80004a3e:	fe840613          	addi	a2,s0,-24
    80004a42:	4581                	li	a1,0
    80004a44:	4501                	li	a0,0
    80004a46:	00000097          	auipc	ra,0x0
    80004a4a:	cfe080e7          	jalr	-770(ra) # 80004744 <argfd>
    80004a4e:	87aa                	mv	a5,a0
    80004a50:	557d                	li	a0,-1
    80004a52:	0007cc63          	bltz	a5,80004a6a <sys_write+0x50>
  return filewrite(f, p, n);
    80004a56:	fe442603          	lw	a2,-28(s0)
    80004a5a:	fd843583          	ld	a1,-40(s0)
    80004a5e:	fe843503          	ld	a0,-24(s0)
    80004a62:	fffff097          	auipc	ra,0xfffff
    80004a66:	48e080e7          	jalr	1166(ra) # 80003ef0 <filewrite>
}
    80004a6a:	70a2                	ld	ra,40(sp)
    80004a6c:	7402                	ld	s0,32(sp)
    80004a6e:	6145                	addi	sp,sp,48
    80004a70:	8082                	ret

0000000080004a72 <sys_close>:
uint64 sys_close(void) {
    80004a72:	1101                	addi	sp,sp,-32
    80004a74:	ec06                	sd	ra,24(sp)
    80004a76:	e822                	sd	s0,16(sp)
    80004a78:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0) return -1;
    80004a7a:	fe040613          	addi	a2,s0,-32
    80004a7e:	fec40593          	addi	a1,s0,-20
    80004a82:	4501                	li	a0,0
    80004a84:	00000097          	auipc	ra,0x0
    80004a88:	cc0080e7          	jalr	-832(ra) # 80004744 <argfd>
    80004a8c:	57fd                	li	a5,-1
    80004a8e:	02054463          	bltz	a0,80004ab6 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004a92:	ffffc097          	auipc	ra,0xffffc
    80004a96:	6b6080e7          	jalr	1718(ra) # 80001148 <myproc>
    80004a9a:	fec42783          	lw	a5,-20(s0)
    80004a9e:	07e9                	addi	a5,a5,26
    80004aa0:	078e                	slli	a5,a5,0x3
    80004aa2:	953e                	add	a0,a0,a5
    80004aa4:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004aa8:	fe043503          	ld	a0,-32(s0)
    80004aac:	fffff097          	auipc	ra,0xfffff
    80004ab0:	248080e7          	jalr	584(ra) # 80003cf4 <fileclose>
  return 0;
    80004ab4:	4781                	li	a5,0
}
    80004ab6:	853e                	mv	a0,a5
    80004ab8:	60e2                	ld	ra,24(sp)
    80004aba:	6442                	ld	s0,16(sp)
    80004abc:	6105                	addi	sp,sp,32
    80004abe:	8082                	ret

0000000080004ac0 <sys_fstat>:
uint64 sys_fstat(void) {
    80004ac0:	1101                	addi	sp,sp,-32
    80004ac2:	ec06                	sd	ra,24(sp)
    80004ac4:	e822                	sd	s0,16(sp)
    80004ac6:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004ac8:	fe040593          	addi	a1,s0,-32
    80004acc:	4505                	li	a0,1
    80004ace:	ffffe097          	auipc	ra,0xffffe
    80004ad2:	80c080e7          	jalr	-2036(ra) # 800022da <argaddr>
  if (argfd(0, 0, &f) < 0) return -1;
    80004ad6:	fe840613          	addi	a2,s0,-24
    80004ada:	4581                	li	a1,0
    80004adc:	4501                	li	a0,0
    80004ade:	00000097          	auipc	ra,0x0
    80004ae2:	c66080e7          	jalr	-922(ra) # 80004744 <argfd>
    80004ae6:	87aa                	mv	a5,a0
    80004ae8:	557d                	li	a0,-1
    80004aea:	0007ca63          	bltz	a5,80004afe <sys_fstat+0x3e>
  return filestat(f, st);
    80004aee:	fe043583          	ld	a1,-32(s0)
    80004af2:	fe843503          	ld	a0,-24(s0)
    80004af6:	fffff097          	auipc	ra,0xfffff
    80004afa:	2c6080e7          	jalr	710(ra) # 80003dbc <filestat>
}
    80004afe:	60e2                	ld	ra,24(sp)
    80004b00:	6442                	ld	s0,16(sp)
    80004b02:	6105                	addi	sp,sp,32
    80004b04:	8082                	ret

0000000080004b06 <sys_link>:
uint64 sys_link(void) {
    80004b06:	7169                	addi	sp,sp,-304
    80004b08:	f606                	sd	ra,296(sp)
    80004b0a:	f222                	sd	s0,288(sp)
    80004b0c:	ee26                	sd	s1,280(sp)
    80004b0e:	ea4a                	sd	s2,272(sp)
    80004b10:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0) return -1;
    80004b12:	08000613          	li	a2,128
    80004b16:	ed040593          	addi	a1,s0,-304
    80004b1a:	4501                	li	a0,0
    80004b1c:	ffffd097          	auipc	ra,0xffffd
    80004b20:	7de080e7          	jalr	2014(ra) # 800022fa <argstr>
    80004b24:	57fd                	li	a5,-1
    80004b26:	10054e63          	bltz	a0,80004c42 <sys_link+0x13c>
    80004b2a:	08000613          	li	a2,128
    80004b2e:	f5040593          	addi	a1,s0,-176
    80004b32:	4505                	li	a0,1
    80004b34:	ffffd097          	auipc	ra,0xffffd
    80004b38:	7c6080e7          	jalr	1990(ra) # 800022fa <argstr>
    80004b3c:	57fd                	li	a5,-1
    80004b3e:	10054263          	bltz	a0,80004c42 <sys_link+0x13c>
  begin_op();
    80004b42:	fffff097          	auipc	ra,0xfffff
    80004b46:	cea080e7          	jalr	-790(ra) # 8000382c <begin_op>
  if ((ip = namei(old)) == 0) {
    80004b4a:	ed040513          	addi	a0,s0,-304
    80004b4e:	fffff097          	auipc	ra,0xfffff
    80004b52:	abe080e7          	jalr	-1346(ra) # 8000360c <namei>
    80004b56:	84aa                	mv	s1,a0
    80004b58:	c551                	beqz	a0,80004be4 <sys_link+0xde>
  ilock(ip);
    80004b5a:	ffffe097          	auipc	ra,0xffffe
    80004b5e:	306080e7          	jalr	774(ra) # 80002e60 <ilock>
  if (ip->type == T_DIR) {
    80004b62:	04449703          	lh	a4,68(s1)
    80004b66:	4785                	li	a5,1
    80004b68:	08f70463          	beq	a4,a5,80004bf0 <sys_link+0xea>
  ip->nlink++;
    80004b6c:	04a4d783          	lhu	a5,74(s1)
    80004b70:	2785                	addiw	a5,a5,1
    80004b72:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b76:	8526                	mv	a0,s1
    80004b78:	ffffe097          	auipc	ra,0xffffe
    80004b7c:	21c080e7          	jalr	540(ra) # 80002d94 <iupdate>
  iunlock(ip);
    80004b80:	8526                	mv	a0,s1
    80004b82:	ffffe097          	auipc	ra,0xffffe
    80004b86:	3a0080e7          	jalr	928(ra) # 80002f22 <iunlock>
  if ((dp = nameiparent(new, name)) == 0) goto bad;
    80004b8a:	fd040593          	addi	a1,s0,-48
    80004b8e:	f5040513          	addi	a0,s0,-176
    80004b92:	fffff097          	auipc	ra,0xfffff
    80004b96:	a98080e7          	jalr	-1384(ra) # 8000362a <nameiparent>
    80004b9a:	892a                	mv	s2,a0
    80004b9c:	c935                	beqz	a0,80004c10 <sys_link+0x10a>
  ilock(dp);
    80004b9e:	ffffe097          	auipc	ra,0xffffe
    80004ba2:	2c2080e7          	jalr	706(ra) # 80002e60 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80004ba6:	00092703          	lw	a4,0(s2)
    80004baa:	409c                	lw	a5,0(s1)
    80004bac:	04f71d63          	bne	a4,a5,80004c06 <sys_link+0x100>
    80004bb0:	40d0                	lw	a2,4(s1)
    80004bb2:	fd040593          	addi	a1,s0,-48
    80004bb6:	854a                	mv	a0,s2
    80004bb8:	fffff097          	auipc	ra,0xfffff
    80004bbc:	9a2080e7          	jalr	-1630(ra) # 8000355a <dirlink>
    80004bc0:	04054363          	bltz	a0,80004c06 <sys_link+0x100>
  iunlockput(dp);
    80004bc4:	854a                	mv	a0,s2
    80004bc6:	ffffe097          	auipc	ra,0xffffe
    80004bca:	4fc080e7          	jalr	1276(ra) # 800030c2 <iunlockput>
  iput(ip);
    80004bce:	8526                	mv	a0,s1
    80004bd0:	ffffe097          	auipc	ra,0xffffe
    80004bd4:	44a080e7          	jalr	1098(ra) # 8000301a <iput>
  end_op();
    80004bd8:	fffff097          	auipc	ra,0xfffff
    80004bdc:	cd2080e7          	jalr	-814(ra) # 800038aa <end_op>
  return 0;
    80004be0:	4781                	li	a5,0
    80004be2:	a085                	j	80004c42 <sys_link+0x13c>
    end_op();
    80004be4:	fffff097          	auipc	ra,0xfffff
    80004be8:	cc6080e7          	jalr	-826(ra) # 800038aa <end_op>
    return -1;
    80004bec:	57fd                	li	a5,-1
    80004bee:	a891                	j	80004c42 <sys_link+0x13c>
    iunlockput(ip);
    80004bf0:	8526                	mv	a0,s1
    80004bf2:	ffffe097          	auipc	ra,0xffffe
    80004bf6:	4d0080e7          	jalr	1232(ra) # 800030c2 <iunlockput>
    end_op();
    80004bfa:	fffff097          	auipc	ra,0xfffff
    80004bfe:	cb0080e7          	jalr	-848(ra) # 800038aa <end_op>
    return -1;
    80004c02:	57fd                	li	a5,-1
    80004c04:	a83d                	j	80004c42 <sys_link+0x13c>
    iunlockput(dp);
    80004c06:	854a                	mv	a0,s2
    80004c08:	ffffe097          	auipc	ra,0xffffe
    80004c0c:	4ba080e7          	jalr	1210(ra) # 800030c2 <iunlockput>
  ilock(ip);
    80004c10:	8526                	mv	a0,s1
    80004c12:	ffffe097          	auipc	ra,0xffffe
    80004c16:	24e080e7          	jalr	590(ra) # 80002e60 <ilock>
  ip->nlink--;
    80004c1a:	04a4d783          	lhu	a5,74(s1)
    80004c1e:	37fd                	addiw	a5,a5,-1
    80004c20:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004c24:	8526                	mv	a0,s1
    80004c26:	ffffe097          	auipc	ra,0xffffe
    80004c2a:	16e080e7          	jalr	366(ra) # 80002d94 <iupdate>
  iunlockput(ip);
    80004c2e:	8526                	mv	a0,s1
    80004c30:	ffffe097          	auipc	ra,0xffffe
    80004c34:	492080e7          	jalr	1170(ra) # 800030c2 <iunlockput>
  end_op();
    80004c38:	fffff097          	auipc	ra,0xfffff
    80004c3c:	c72080e7          	jalr	-910(ra) # 800038aa <end_op>
  return -1;
    80004c40:	57fd                	li	a5,-1
}
    80004c42:	853e                	mv	a0,a5
    80004c44:	70b2                	ld	ra,296(sp)
    80004c46:	7412                	ld	s0,288(sp)
    80004c48:	64f2                	ld	s1,280(sp)
    80004c4a:	6952                	ld	s2,272(sp)
    80004c4c:	6155                	addi	sp,sp,304
    80004c4e:	8082                	ret

0000000080004c50 <sys_unlink>:
uint64 sys_unlink(void) {
    80004c50:	7151                	addi	sp,sp,-240
    80004c52:	f586                	sd	ra,232(sp)
    80004c54:	f1a2                	sd	s0,224(sp)
    80004c56:	eda6                	sd	s1,216(sp)
    80004c58:	e9ca                	sd	s2,208(sp)
    80004c5a:	e5ce                	sd	s3,200(sp)
    80004c5c:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0) return -1;
    80004c5e:	08000613          	li	a2,128
    80004c62:	f3040593          	addi	a1,s0,-208
    80004c66:	4501                	li	a0,0
    80004c68:	ffffd097          	auipc	ra,0xffffd
    80004c6c:	692080e7          	jalr	1682(ra) # 800022fa <argstr>
    80004c70:	18054163          	bltz	a0,80004df2 <sys_unlink+0x1a2>
  begin_op();
    80004c74:	fffff097          	auipc	ra,0xfffff
    80004c78:	bb8080e7          	jalr	-1096(ra) # 8000382c <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    80004c7c:	fb040593          	addi	a1,s0,-80
    80004c80:	f3040513          	addi	a0,s0,-208
    80004c84:	fffff097          	auipc	ra,0xfffff
    80004c88:	9a6080e7          	jalr	-1626(ra) # 8000362a <nameiparent>
    80004c8c:	84aa                	mv	s1,a0
    80004c8e:	c979                	beqz	a0,80004d64 <sys_unlink+0x114>
  ilock(dp);
    80004c90:	ffffe097          	auipc	ra,0xffffe
    80004c94:	1d0080e7          	jalr	464(ra) # 80002e60 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0) goto bad;
    80004c98:	00004597          	auipc	a1,0x4
    80004c9c:	9b058593          	addi	a1,a1,-1616 # 80008648 <syscalls+0x2a0>
    80004ca0:	fb040513          	addi	a0,s0,-80
    80004ca4:	ffffe097          	auipc	ra,0xffffe
    80004ca8:	686080e7          	jalr	1670(ra) # 8000332a <namecmp>
    80004cac:	14050a63          	beqz	a0,80004e00 <sys_unlink+0x1b0>
    80004cb0:	00004597          	auipc	a1,0x4
    80004cb4:	9a058593          	addi	a1,a1,-1632 # 80008650 <syscalls+0x2a8>
    80004cb8:	fb040513          	addi	a0,s0,-80
    80004cbc:	ffffe097          	auipc	ra,0xffffe
    80004cc0:	66e080e7          	jalr	1646(ra) # 8000332a <namecmp>
    80004cc4:	12050e63          	beqz	a0,80004e00 <sys_unlink+0x1b0>
  if ((ip = dirlookup(dp, name, &off)) == 0) goto bad;
    80004cc8:	f2c40613          	addi	a2,s0,-212
    80004ccc:	fb040593          	addi	a1,s0,-80
    80004cd0:	8526                	mv	a0,s1
    80004cd2:	ffffe097          	auipc	ra,0xffffe
    80004cd6:	672080e7          	jalr	1650(ra) # 80003344 <dirlookup>
    80004cda:	892a                	mv	s2,a0
    80004cdc:	12050263          	beqz	a0,80004e00 <sys_unlink+0x1b0>
  ilock(ip);
    80004ce0:	ffffe097          	auipc	ra,0xffffe
    80004ce4:	180080e7          	jalr	384(ra) # 80002e60 <ilock>
  if (ip->nlink < 1) panic("unlink: nlink < 1");
    80004ce8:	04a91783          	lh	a5,74(s2)
    80004cec:	08f05263          	blez	a5,80004d70 <sys_unlink+0x120>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80004cf0:	04491703          	lh	a4,68(s2)
    80004cf4:	4785                	li	a5,1
    80004cf6:	08f70563          	beq	a4,a5,80004d80 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004cfa:	4641                	li	a2,16
    80004cfc:	4581                	li	a1,0
    80004cfe:	fc040513          	addi	a0,s0,-64
    80004d02:	ffffb097          	auipc	ra,0xffffb
    80004d06:	478080e7          	jalr	1144(ra) # 8000017a <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d0a:	4741                	li	a4,16
    80004d0c:	f2c42683          	lw	a3,-212(s0)
    80004d10:	fc040613          	addi	a2,s0,-64
    80004d14:	4581                	li	a1,0
    80004d16:	8526                	mv	a0,s1
    80004d18:	ffffe097          	auipc	ra,0xffffe
    80004d1c:	4f4080e7          	jalr	1268(ra) # 8000320c <writei>
    80004d20:	47c1                	li	a5,16
    80004d22:	0af51563          	bne	a0,a5,80004dcc <sys_unlink+0x17c>
  if (ip->type == T_DIR) {
    80004d26:	04491703          	lh	a4,68(s2)
    80004d2a:	4785                	li	a5,1
    80004d2c:	0af70863          	beq	a4,a5,80004ddc <sys_unlink+0x18c>
  iunlockput(dp);
    80004d30:	8526                	mv	a0,s1
    80004d32:	ffffe097          	auipc	ra,0xffffe
    80004d36:	390080e7          	jalr	912(ra) # 800030c2 <iunlockput>
  ip->nlink--;
    80004d3a:	04a95783          	lhu	a5,74(s2)
    80004d3e:	37fd                	addiw	a5,a5,-1
    80004d40:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004d44:	854a                	mv	a0,s2
    80004d46:	ffffe097          	auipc	ra,0xffffe
    80004d4a:	04e080e7          	jalr	78(ra) # 80002d94 <iupdate>
  iunlockput(ip);
    80004d4e:	854a                	mv	a0,s2
    80004d50:	ffffe097          	auipc	ra,0xffffe
    80004d54:	372080e7          	jalr	882(ra) # 800030c2 <iunlockput>
  end_op();
    80004d58:	fffff097          	auipc	ra,0xfffff
    80004d5c:	b52080e7          	jalr	-1198(ra) # 800038aa <end_op>
  return 0;
    80004d60:	4501                	li	a0,0
    80004d62:	a84d                	j	80004e14 <sys_unlink+0x1c4>
    end_op();
    80004d64:	fffff097          	auipc	ra,0xfffff
    80004d68:	b46080e7          	jalr	-1210(ra) # 800038aa <end_op>
    return -1;
    80004d6c:	557d                	li	a0,-1
    80004d6e:	a05d                	j	80004e14 <sys_unlink+0x1c4>
  if (ip->nlink < 1) panic("unlink: nlink < 1");
    80004d70:	00004517          	auipc	a0,0x4
    80004d74:	8e850513          	addi	a0,a0,-1816 # 80008658 <syscalls+0x2b0>
    80004d78:	00001097          	auipc	ra,0x1
    80004d7c:	1b4080e7          	jalr	436(ra) # 80005f2c <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004d80:	04c92703          	lw	a4,76(s2)
    80004d84:	02000793          	li	a5,32
    80004d88:	f6e7f9e3          	bgeu	a5,a4,80004cfa <sys_unlink+0xaa>
    80004d8c:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d90:	4741                	li	a4,16
    80004d92:	86ce                	mv	a3,s3
    80004d94:	f1840613          	addi	a2,s0,-232
    80004d98:	4581                	li	a1,0
    80004d9a:	854a                	mv	a0,s2
    80004d9c:	ffffe097          	auipc	ra,0xffffe
    80004da0:	378080e7          	jalr	888(ra) # 80003114 <readi>
    80004da4:	47c1                	li	a5,16
    80004da6:	00f51b63          	bne	a0,a5,80004dbc <sys_unlink+0x16c>
    if (de.inum != 0) return 0;
    80004daa:	f1845783          	lhu	a5,-232(s0)
    80004dae:	e7a1                	bnez	a5,80004df6 <sys_unlink+0x1a6>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004db0:	29c1                	addiw	s3,s3,16
    80004db2:	04c92783          	lw	a5,76(s2)
    80004db6:	fcf9ede3          	bltu	s3,a5,80004d90 <sys_unlink+0x140>
    80004dba:	b781                	j	80004cfa <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004dbc:	00004517          	auipc	a0,0x4
    80004dc0:	8b450513          	addi	a0,a0,-1868 # 80008670 <syscalls+0x2c8>
    80004dc4:	00001097          	auipc	ra,0x1
    80004dc8:	168080e7          	jalr	360(ra) # 80005f2c <panic>
    panic("unlink: writei");
    80004dcc:	00004517          	auipc	a0,0x4
    80004dd0:	8bc50513          	addi	a0,a0,-1860 # 80008688 <syscalls+0x2e0>
    80004dd4:	00001097          	auipc	ra,0x1
    80004dd8:	158080e7          	jalr	344(ra) # 80005f2c <panic>
    dp->nlink--;
    80004ddc:	04a4d783          	lhu	a5,74(s1)
    80004de0:	37fd                	addiw	a5,a5,-1
    80004de2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004de6:	8526                	mv	a0,s1
    80004de8:	ffffe097          	auipc	ra,0xffffe
    80004dec:	fac080e7          	jalr	-84(ra) # 80002d94 <iupdate>
    80004df0:	b781                	j	80004d30 <sys_unlink+0xe0>
  if (argstr(0, path, MAXPATH) < 0) return -1;
    80004df2:	557d                	li	a0,-1
    80004df4:	a005                	j	80004e14 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004df6:	854a                	mv	a0,s2
    80004df8:	ffffe097          	auipc	ra,0xffffe
    80004dfc:	2ca080e7          	jalr	714(ra) # 800030c2 <iunlockput>
  iunlockput(dp);
    80004e00:	8526                	mv	a0,s1
    80004e02:	ffffe097          	auipc	ra,0xffffe
    80004e06:	2c0080e7          	jalr	704(ra) # 800030c2 <iunlockput>
  end_op();
    80004e0a:	fffff097          	auipc	ra,0xfffff
    80004e0e:	aa0080e7          	jalr	-1376(ra) # 800038aa <end_op>
  return -1;
    80004e12:	557d                	li	a0,-1
}
    80004e14:	70ae                	ld	ra,232(sp)
    80004e16:	740e                	ld	s0,224(sp)
    80004e18:	64ee                	ld	s1,216(sp)
    80004e1a:	694e                	ld	s2,208(sp)
    80004e1c:	69ae                	ld	s3,200(sp)
    80004e1e:	616d                	addi	sp,sp,240
    80004e20:	8082                	ret

0000000080004e22 <sys_open>:

uint64 sys_open(void) {
    80004e22:	7131                	addi	sp,sp,-192
    80004e24:	fd06                	sd	ra,184(sp)
    80004e26:	f922                	sd	s0,176(sp)
    80004e28:	f526                	sd	s1,168(sp)
    80004e2a:	f14a                	sd	s2,160(sp)
    80004e2c:	ed4e                	sd	s3,152(sp)
    80004e2e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004e30:	f4c40593          	addi	a1,s0,-180
    80004e34:	4505                	li	a0,1
    80004e36:	ffffd097          	auipc	ra,0xffffd
    80004e3a:	484080e7          	jalr	1156(ra) # 800022ba <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0) return -1;
    80004e3e:	08000613          	li	a2,128
    80004e42:	f5040593          	addi	a1,s0,-176
    80004e46:	4501                	li	a0,0
    80004e48:	ffffd097          	auipc	ra,0xffffd
    80004e4c:	4b2080e7          	jalr	1202(ra) # 800022fa <argstr>
    80004e50:	87aa                	mv	a5,a0
    80004e52:	557d                	li	a0,-1
    80004e54:	0a07c963          	bltz	a5,80004f06 <sys_open+0xe4>

  begin_op();
    80004e58:	fffff097          	auipc	ra,0xfffff
    80004e5c:	9d4080e7          	jalr	-1580(ra) # 8000382c <begin_op>

  if (omode & O_CREATE) {
    80004e60:	f4c42783          	lw	a5,-180(s0)
    80004e64:	2007f793          	andi	a5,a5,512
    80004e68:	cfc5                	beqz	a5,80004f20 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004e6a:	4681                	li	a3,0
    80004e6c:	4601                	li	a2,0
    80004e6e:	4589                	li	a1,2
    80004e70:	f5040513          	addi	a0,s0,-176
    80004e74:	00000097          	auipc	ra,0x0
    80004e78:	972080e7          	jalr	-1678(ra) # 800047e6 <create>
    80004e7c:	84aa                	mv	s1,a0
    if (ip == 0) {
    80004e7e:	c959                	beqz	a0,80004f14 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80004e80:	04449703          	lh	a4,68(s1)
    80004e84:	478d                	li	a5,3
    80004e86:	00f71763          	bne	a4,a5,80004e94 <sys_open+0x72>
    80004e8a:	0464d703          	lhu	a4,70(s1)
    80004e8e:	47a5                	li	a5,9
    80004e90:	0ce7ed63          	bltu	a5,a4,80004f6a <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80004e94:	fffff097          	auipc	ra,0xfffff
    80004e98:	da4080e7          	jalr	-604(ra) # 80003c38 <filealloc>
    80004e9c:	89aa                	mv	s3,a0
    80004e9e:	10050363          	beqz	a0,80004fa4 <sys_open+0x182>
    80004ea2:	00000097          	auipc	ra,0x0
    80004ea6:	902080e7          	jalr	-1790(ra) # 800047a4 <fdalloc>
    80004eaa:	892a                	mv	s2,a0
    80004eac:	0e054763          	bltz	a0,80004f9a <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    80004eb0:	04449703          	lh	a4,68(s1)
    80004eb4:	478d                	li	a5,3
    80004eb6:	0cf70563          	beq	a4,a5,80004f80 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004eba:	4789                	li	a5,2
    80004ebc:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004ec0:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004ec4:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004ec8:	f4c42783          	lw	a5,-180(s0)
    80004ecc:	0017c713          	xori	a4,a5,1
    80004ed0:	8b05                	andi	a4,a4,1
    80004ed2:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004ed6:	0037f713          	andi	a4,a5,3
    80004eda:	00e03733          	snez	a4,a4
    80004ede:	00e984a3          	sb	a4,9(s3)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    80004ee2:	4007f793          	andi	a5,a5,1024
    80004ee6:	c791                	beqz	a5,80004ef2 <sys_open+0xd0>
    80004ee8:	04449703          	lh	a4,68(s1)
    80004eec:	4789                	li	a5,2
    80004eee:	0af70063          	beq	a4,a5,80004f8e <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004ef2:	8526                	mv	a0,s1
    80004ef4:	ffffe097          	auipc	ra,0xffffe
    80004ef8:	02e080e7          	jalr	46(ra) # 80002f22 <iunlock>
  end_op();
    80004efc:	fffff097          	auipc	ra,0xfffff
    80004f00:	9ae080e7          	jalr	-1618(ra) # 800038aa <end_op>

  return fd;
    80004f04:	854a                	mv	a0,s2
}
    80004f06:	70ea                	ld	ra,184(sp)
    80004f08:	744a                	ld	s0,176(sp)
    80004f0a:	74aa                	ld	s1,168(sp)
    80004f0c:	790a                	ld	s2,160(sp)
    80004f0e:	69ea                	ld	s3,152(sp)
    80004f10:	6129                	addi	sp,sp,192
    80004f12:	8082                	ret
      end_op();
    80004f14:	fffff097          	auipc	ra,0xfffff
    80004f18:	996080e7          	jalr	-1642(ra) # 800038aa <end_op>
      return -1;
    80004f1c:	557d                	li	a0,-1
    80004f1e:	b7e5                	j	80004f06 <sys_open+0xe4>
    if ((ip = namei(path)) == 0) {
    80004f20:	f5040513          	addi	a0,s0,-176
    80004f24:	ffffe097          	auipc	ra,0xffffe
    80004f28:	6e8080e7          	jalr	1768(ra) # 8000360c <namei>
    80004f2c:	84aa                	mv	s1,a0
    80004f2e:	c905                	beqz	a0,80004f5e <sys_open+0x13c>
    ilock(ip);
    80004f30:	ffffe097          	auipc	ra,0xffffe
    80004f34:	f30080e7          	jalr	-208(ra) # 80002e60 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    80004f38:	04449703          	lh	a4,68(s1)
    80004f3c:	4785                	li	a5,1
    80004f3e:	f4f711e3          	bne	a4,a5,80004e80 <sys_open+0x5e>
    80004f42:	f4c42783          	lw	a5,-180(s0)
    80004f46:	d7b9                	beqz	a5,80004e94 <sys_open+0x72>
      iunlockput(ip);
    80004f48:	8526                	mv	a0,s1
    80004f4a:	ffffe097          	auipc	ra,0xffffe
    80004f4e:	178080e7          	jalr	376(ra) # 800030c2 <iunlockput>
      end_op();
    80004f52:	fffff097          	auipc	ra,0xfffff
    80004f56:	958080e7          	jalr	-1704(ra) # 800038aa <end_op>
      return -1;
    80004f5a:	557d                	li	a0,-1
    80004f5c:	b76d                	j	80004f06 <sys_open+0xe4>
      end_op();
    80004f5e:	fffff097          	auipc	ra,0xfffff
    80004f62:	94c080e7          	jalr	-1716(ra) # 800038aa <end_op>
      return -1;
    80004f66:	557d                	li	a0,-1
    80004f68:	bf79                	j	80004f06 <sys_open+0xe4>
    iunlockput(ip);
    80004f6a:	8526                	mv	a0,s1
    80004f6c:	ffffe097          	auipc	ra,0xffffe
    80004f70:	156080e7          	jalr	342(ra) # 800030c2 <iunlockput>
    end_op();
    80004f74:	fffff097          	auipc	ra,0xfffff
    80004f78:	936080e7          	jalr	-1738(ra) # 800038aa <end_op>
    return -1;
    80004f7c:	557d                	li	a0,-1
    80004f7e:	b761                	j	80004f06 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004f80:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004f84:	04649783          	lh	a5,70(s1)
    80004f88:	02f99223          	sh	a5,36(s3)
    80004f8c:	bf25                	j	80004ec4 <sys_open+0xa2>
    itrunc(ip);
    80004f8e:	8526                	mv	a0,s1
    80004f90:	ffffe097          	auipc	ra,0xffffe
    80004f94:	fde080e7          	jalr	-34(ra) # 80002f6e <itrunc>
    80004f98:	bfa9                	j	80004ef2 <sys_open+0xd0>
    if (f) fileclose(f);
    80004f9a:	854e                	mv	a0,s3
    80004f9c:	fffff097          	auipc	ra,0xfffff
    80004fa0:	d58080e7          	jalr	-680(ra) # 80003cf4 <fileclose>
    iunlockput(ip);
    80004fa4:	8526                	mv	a0,s1
    80004fa6:	ffffe097          	auipc	ra,0xffffe
    80004faa:	11c080e7          	jalr	284(ra) # 800030c2 <iunlockput>
    end_op();
    80004fae:	fffff097          	auipc	ra,0xfffff
    80004fb2:	8fc080e7          	jalr	-1796(ra) # 800038aa <end_op>
    return -1;
    80004fb6:	557d                	li	a0,-1
    80004fb8:	b7b9                	j	80004f06 <sys_open+0xe4>

0000000080004fba <sys_mkdir>:

uint64 sys_mkdir(void) {
    80004fba:	7175                	addi	sp,sp,-144
    80004fbc:	e506                	sd	ra,136(sp)
    80004fbe:	e122                	sd	s0,128(sp)
    80004fc0:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004fc2:	fffff097          	auipc	ra,0xfffff
    80004fc6:	86a080e7          	jalr	-1942(ra) # 8000382c <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80004fca:	08000613          	li	a2,128
    80004fce:	f7040593          	addi	a1,s0,-144
    80004fd2:	4501                	li	a0,0
    80004fd4:	ffffd097          	auipc	ra,0xffffd
    80004fd8:	326080e7          	jalr	806(ra) # 800022fa <argstr>
    80004fdc:	02054963          	bltz	a0,8000500e <sys_mkdir+0x54>
    80004fe0:	4681                	li	a3,0
    80004fe2:	4601                	li	a2,0
    80004fe4:	4585                	li	a1,1
    80004fe6:	f7040513          	addi	a0,s0,-144
    80004fea:	fffff097          	auipc	ra,0xfffff
    80004fee:	7fc080e7          	jalr	2044(ra) # 800047e6 <create>
    80004ff2:	cd11                	beqz	a0,8000500e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ff4:	ffffe097          	auipc	ra,0xffffe
    80004ff8:	0ce080e7          	jalr	206(ra) # 800030c2 <iunlockput>
  end_op();
    80004ffc:	fffff097          	auipc	ra,0xfffff
    80005000:	8ae080e7          	jalr	-1874(ra) # 800038aa <end_op>
  return 0;
    80005004:	4501                	li	a0,0
}
    80005006:	60aa                	ld	ra,136(sp)
    80005008:	640a                	ld	s0,128(sp)
    8000500a:	6149                	addi	sp,sp,144
    8000500c:	8082                	ret
    end_op();
    8000500e:	fffff097          	auipc	ra,0xfffff
    80005012:	89c080e7          	jalr	-1892(ra) # 800038aa <end_op>
    return -1;
    80005016:	557d                	li	a0,-1
    80005018:	b7fd                	j	80005006 <sys_mkdir+0x4c>

000000008000501a <sys_mknod>:

uint64 sys_mknod(void) {
    8000501a:	7135                	addi	sp,sp,-160
    8000501c:	ed06                	sd	ra,152(sp)
    8000501e:	e922                	sd	s0,144(sp)
    80005020:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005022:	fffff097          	auipc	ra,0xfffff
    80005026:	80a080e7          	jalr	-2038(ra) # 8000382c <begin_op>
  argint(1, &major);
    8000502a:	f6c40593          	addi	a1,s0,-148
    8000502e:	4505                	li	a0,1
    80005030:	ffffd097          	auipc	ra,0xffffd
    80005034:	28a080e7          	jalr	650(ra) # 800022ba <argint>
  argint(2, &minor);
    80005038:	f6840593          	addi	a1,s0,-152
    8000503c:	4509                	li	a0,2
    8000503e:	ffffd097          	auipc	ra,0xffffd
    80005042:	27c080e7          	jalr	636(ra) # 800022ba <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80005046:	08000613          	li	a2,128
    8000504a:	f7040593          	addi	a1,s0,-144
    8000504e:	4501                	li	a0,0
    80005050:	ffffd097          	auipc	ra,0xffffd
    80005054:	2aa080e7          	jalr	682(ra) # 800022fa <argstr>
    80005058:	02054b63          	bltz	a0,8000508e <sys_mknod+0x74>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    8000505c:	f6841683          	lh	a3,-152(s0)
    80005060:	f6c41603          	lh	a2,-148(s0)
    80005064:	458d                	li	a1,3
    80005066:	f7040513          	addi	a0,s0,-144
    8000506a:	fffff097          	auipc	ra,0xfffff
    8000506e:	77c080e7          	jalr	1916(ra) # 800047e6 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80005072:	cd11                	beqz	a0,8000508e <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005074:	ffffe097          	auipc	ra,0xffffe
    80005078:	04e080e7          	jalr	78(ra) # 800030c2 <iunlockput>
  end_op();
    8000507c:	fffff097          	auipc	ra,0xfffff
    80005080:	82e080e7          	jalr	-2002(ra) # 800038aa <end_op>
  return 0;
    80005084:	4501                	li	a0,0
}
    80005086:	60ea                	ld	ra,152(sp)
    80005088:	644a                	ld	s0,144(sp)
    8000508a:	610d                	addi	sp,sp,160
    8000508c:	8082                	ret
    end_op();
    8000508e:	fffff097          	auipc	ra,0xfffff
    80005092:	81c080e7          	jalr	-2020(ra) # 800038aa <end_op>
    return -1;
    80005096:	557d                	li	a0,-1
    80005098:	b7fd                	j	80005086 <sys_mknod+0x6c>

000000008000509a <sys_chdir>:

uint64 sys_chdir(void) {
    8000509a:	7135                	addi	sp,sp,-160
    8000509c:	ed06                	sd	ra,152(sp)
    8000509e:	e922                	sd	s0,144(sp)
    800050a0:	e526                	sd	s1,136(sp)
    800050a2:	e14a                	sd	s2,128(sp)
    800050a4:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800050a6:	ffffc097          	auipc	ra,0xffffc
    800050aa:	0a2080e7          	jalr	162(ra) # 80001148 <myproc>
    800050ae:	892a                	mv	s2,a0

  begin_op();
    800050b0:	ffffe097          	auipc	ra,0xffffe
    800050b4:	77c080e7          	jalr	1916(ra) # 8000382c <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    800050b8:	08000613          	li	a2,128
    800050bc:	f6040593          	addi	a1,s0,-160
    800050c0:	4501                	li	a0,0
    800050c2:	ffffd097          	auipc	ra,0xffffd
    800050c6:	238080e7          	jalr	568(ra) # 800022fa <argstr>
    800050ca:	04054b63          	bltz	a0,80005120 <sys_chdir+0x86>
    800050ce:	f6040513          	addi	a0,s0,-160
    800050d2:	ffffe097          	auipc	ra,0xffffe
    800050d6:	53a080e7          	jalr	1338(ra) # 8000360c <namei>
    800050da:	84aa                	mv	s1,a0
    800050dc:	c131                	beqz	a0,80005120 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800050de:	ffffe097          	auipc	ra,0xffffe
    800050e2:	d82080e7          	jalr	-638(ra) # 80002e60 <ilock>
  if (ip->type != T_DIR) {
    800050e6:	04449703          	lh	a4,68(s1)
    800050ea:	4785                	li	a5,1
    800050ec:	04f71063          	bne	a4,a5,8000512c <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800050f0:	8526                	mv	a0,s1
    800050f2:	ffffe097          	auipc	ra,0xffffe
    800050f6:	e30080e7          	jalr	-464(ra) # 80002f22 <iunlock>
  iput(p->cwd);
    800050fa:	15093503          	ld	a0,336(s2)
    800050fe:	ffffe097          	auipc	ra,0xffffe
    80005102:	f1c080e7          	jalr	-228(ra) # 8000301a <iput>
  end_op();
    80005106:	ffffe097          	auipc	ra,0xffffe
    8000510a:	7a4080e7          	jalr	1956(ra) # 800038aa <end_op>
  p->cwd = ip;
    8000510e:	14993823          	sd	s1,336(s2)
  return 0;
    80005112:	4501                	li	a0,0
}
    80005114:	60ea                	ld	ra,152(sp)
    80005116:	644a                	ld	s0,144(sp)
    80005118:	64aa                	ld	s1,136(sp)
    8000511a:	690a                	ld	s2,128(sp)
    8000511c:	610d                	addi	sp,sp,160
    8000511e:	8082                	ret
    end_op();
    80005120:	ffffe097          	auipc	ra,0xffffe
    80005124:	78a080e7          	jalr	1930(ra) # 800038aa <end_op>
    return -1;
    80005128:	557d                	li	a0,-1
    8000512a:	b7ed                	j	80005114 <sys_chdir+0x7a>
    iunlockput(ip);
    8000512c:	8526                	mv	a0,s1
    8000512e:	ffffe097          	auipc	ra,0xffffe
    80005132:	f94080e7          	jalr	-108(ra) # 800030c2 <iunlockput>
    end_op();
    80005136:	ffffe097          	auipc	ra,0xffffe
    8000513a:	774080e7          	jalr	1908(ra) # 800038aa <end_op>
    return -1;
    8000513e:	557d                	li	a0,-1
    80005140:	bfd1                	j	80005114 <sys_chdir+0x7a>

0000000080005142 <sys_exec>:

uint64 sys_exec(void) {
    80005142:	7145                	addi	sp,sp,-464
    80005144:	e786                	sd	ra,456(sp)
    80005146:	e3a2                	sd	s0,448(sp)
    80005148:	ff26                	sd	s1,440(sp)
    8000514a:	fb4a                	sd	s2,432(sp)
    8000514c:	f74e                	sd	s3,424(sp)
    8000514e:	f352                	sd	s4,416(sp)
    80005150:	ef56                	sd	s5,408(sp)
    80005152:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005154:	e3840593          	addi	a1,s0,-456
    80005158:	4505                	li	a0,1
    8000515a:	ffffd097          	auipc	ra,0xffffd
    8000515e:	180080e7          	jalr	384(ra) # 800022da <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    80005162:	08000613          	li	a2,128
    80005166:	f4040593          	addi	a1,s0,-192
    8000516a:	4501                	li	a0,0
    8000516c:	ffffd097          	auipc	ra,0xffffd
    80005170:	18e080e7          	jalr	398(ra) # 800022fa <argstr>
    80005174:	87aa                	mv	a5,a0
    return -1;
    80005176:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0) {
    80005178:	0c07c363          	bltz	a5,8000523e <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    8000517c:	10000613          	li	a2,256
    80005180:	4581                	li	a1,0
    80005182:	e4040513          	addi	a0,s0,-448
    80005186:	ffffb097          	auipc	ra,0xffffb
    8000518a:	ff4080e7          	jalr	-12(ra) # 8000017a <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    8000518e:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005192:	89a6                	mv	s3,s1
    80005194:	4901                	li	s2,0
    if (i >= NELEM(argv)) {
    80005196:	02000a13          	li	s4,32
    8000519a:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    8000519e:	00391513          	slli	a0,s2,0x3
    800051a2:	e3040593          	addi	a1,s0,-464
    800051a6:	e3843783          	ld	a5,-456(s0)
    800051aa:	953e                	add	a0,a0,a5
    800051ac:	ffffd097          	auipc	ra,0xffffd
    800051b0:	070080e7          	jalr	112(ra) # 8000221c <fetchaddr>
    800051b4:	02054a63          	bltz	a0,800051e8 <sys_exec+0xa6>
      goto bad;
    }
    if (uarg == 0) {
    800051b8:	e3043783          	ld	a5,-464(s0)
    800051bc:	c3b9                	beqz	a5,80005202 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800051be:	ffffb097          	auipc	ra,0xffffb
    800051c2:	f5c080e7          	jalr	-164(ra) # 8000011a <kalloc>
    800051c6:	85aa                	mv	a1,a0
    800051c8:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0) goto bad;
    800051cc:	cd11                	beqz	a0,800051e8 <sys_exec+0xa6>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0) goto bad;
    800051ce:	6605                	lui	a2,0x1
    800051d0:	e3043503          	ld	a0,-464(s0)
    800051d4:	ffffd097          	auipc	ra,0xffffd
    800051d8:	09a080e7          	jalr	154(ra) # 8000226e <fetchstr>
    800051dc:	00054663          	bltz	a0,800051e8 <sys_exec+0xa6>
    if (i >= NELEM(argv)) {
    800051e0:	0905                	addi	s2,s2,1
    800051e2:	09a1                	addi	s3,s3,8
    800051e4:	fb491be3          	bne	s2,s4,8000519a <sys_exec+0x58>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);
    800051e8:	f4040913          	addi	s2,s0,-192
    800051ec:	6088                	ld	a0,0(s1)
    800051ee:	c539                	beqz	a0,8000523c <sys_exec+0xfa>
    800051f0:	ffffb097          	auipc	ra,0xffffb
    800051f4:	e2c080e7          	jalr	-468(ra) # 8000001c <kfree>
    800051f8:	04a1                	addi	s1,s1,8
    800051fa:	ff2499e3          	bne	s1,s2,800051ec <sys_exec+0xaa>
  return -1;
    800051fe:	557d                	li	a0,-1
    80005200:	a83d                	j	8000523e <sys_exec+0xfc>
      argv[i] = 0;
    80005202:	0a8e                	slli	s5,s5,0x3
    80005204:	fc0a8793          	addi	a5,s5,-64
    80005208:	00878ab3          	add	s5,a5,s0
    8000520c:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005210:	e4040593          	addi	a1,s0,-448
    80005214:	f4040513          	addi	a0,s0,-192
    80005218:	fffff097          	auipc	ra,0xfffff
    8000521c:	156080e7          	jalr	342(ra) # 8000436e <exec>
    80005220:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);
    80005222:	f4040993          	addi	s3,s0,-192
    80005226:	6088                	ld	a0,0(s1)
    80005228:	c901                	beqz	a0,80005238 <sys_exec+0xf6>
    8000522a:	ffffb097          	auipc	ra,0xffffb
    8000522e:	df2080e7          	jalr	-526(ra) # 8000001c <kfree>
    80005232:	04a1                	addi	s1,s1,8
    80005234:	ff3499e3          	bne	s1,s3,80005226 <sys_exec+0xe4>
  return ret;
    80005238:	854a                	mv	a0,s2
    8000523a:	a011                	j	8000523e <sys_exec+0xfc>
  return -1;
    8000523c:	557d                	li	a0,-1
}
    8000523e:	60be                	ld	ra,456(sp)
    80005240:	641e                	ld	s0,448(sp)
    80005242:	74fa                	ld	s1,440(sp)
    80005244:	795a                	ld	s2,432(sp)
    80005246:	79ba                	ld	s3,424(sp)
    80005248:	7a1a                	ld	s4,416(sp)
    8000524a:	6afa                	ld	s5,408(sp)
    8000524c:	6179                	addi	sp,sp,464
    8000524e:	8082                	ret

0000000080005250 <sys_pipe>:

uint64 sys_pipe(void) {
    80005250:	7139                	addi	sp,sp,-64
    80005252:	fc06                	sd	ra,56(sp)
    80005254:	f822                	sd	s0,48(sp)
    80005256:	f426                	sd	s1,40(sp)
    80005258:	0080                	addi	s0,sp,64
  uint64 fdarray;  // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000525a:	ffffc097          	auipc	ra,0xffffc
    8000525e:	eee080e7          	jalr	-274(ra) # 80001148 <myproc>
    80005262:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005264:	fd840593          	addi	a1,s0,-40
    80005268:	4501                	li	a0,0
    8000526a:	ffffd097          	auipc	ra,0xffffd
    8000526e:	070080e7          	jalr	112(ra) # 800022da <argaddr>
  if (pipealloc(&rf, &wf) < 0) return -1;
    80005272:	fc840593          	addi	a1,s0,-56
    80005276:	fd040513          	addi	a0,s0,-48
    8000527a:	fffff097          	auipc	ra,0xfffff
    8000527e:	daa080e7          	jalr	-598(ra) # 80004024 <pipealloc>
    80005282:	57fd                	li	a5,-1
    80005284:	0c054463          	bltz	a0,8000534c <sys_pipe+0xfc>
  fd0 = -1;
    80005288:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    8000528c:	fd043503          	ld	a0,-48(s0)
    80005290:	fffff097          	auipc	ra,0xfffff
    80005294:	514080e7          	jalr	1300(ra) # 800047a4 <fdalloc>
    80005298:	fca42223          	sw	a0,-60(s0)
    8000529c:	08054b63          	bltz	a0,80005332 <sys_pipe+0xe2>
    800052a0:	fc843503          	ld	a0,-56(s0)
    800052a4:	fffff097          	auipc	ra,0xfffff
    800052a8:	500080e7          	jalr	1280(ra) # 800047a4 <fdalloc>
    800052ac:	fca42023          	sw	a0,-64(s0)
    800052b0:	06054863          	bltz	a0,80005320 <sys_pipe+0xd0>
    if (fd0 >= 0) p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800052b4:	4691                	li	a3,4
    800052b6:	fc440613          	addi	a2,s0,-60
    800052ba:	fd843583          	ld	a1,-40(s0)
    800052be:	68a8                	ld	a0,80(s1)
    800052c0:	ffffc097          	auipc	ra,0xffffc
    800052c4:	a30080e7          	jalr	-1488(ra) # 80000cf0 <copyout>
    800052c8:	02054063          	bltz	a0,800052e8 <sys_pipe+0x98>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) <
    800052cc:	4691                	li	a3,4
    800052ce:	fc040613          	addi	a2,s0,-64
    800052d2:	fd843583          	ld	a1,-40(s0)
    800052d6:	0591                	addi	a1,a1,4
    800052d8:	68a8                	ld	a0,80(s1)
    800052da:	ffffc097          	auipc	ra,0xffffc
    800052de:	a16080e7          	jalr	-1514(ra) # 80000cf0 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800052e2:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800052e4:	06055463          	bgez	a0,8000534c <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800052e8:	fc442783          	lw	a5,-60(s0)
    800052ec:	07e9                	addi	a5,a5,26
    800052ee:	078e                	slli	a5,a5,0x3
    800052f0:	97a6                	add	a5,a5,s1
    800052f2:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800052f6:	fc042783          	lw	a5,-64(s0)
    800052fa:	07e9                	addi	a5,a5,26
    800052fc:	078e                	slli	a5,a5,0x3
    800052fe:	94be                	add	s1,s1,a5
    80005300:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005304:	fd043503          	ld	a0,-48(s0)
    80005308:	fffff097          	auipc	ra,0xfffff
    8000530c:	9ec080e7          	jalr	-1556(ra) # 80003cf4 <fileclose>
    fileclose(wf);
    80005310:	fc843503          	ld	a0,-56(s0)
    80005314:	fffff097          	auipc	ra,0xfffff
    80005318:	9e0080e7          	jalr	-1568(ra) # 80003cf4 <fileclose>
    return -1;
    8000531c:	57fd                	li	a5,-1
    8000531e:	a03d                	j	8000534c <sys_pipe+0xfc>
    if (fd0 >= 0) p->ofile[fd0] = 0;
    80005320:	fc442783          	lw	a5,-60(s0)
    80005324:	0007c763          	bltz	a5,80005332 <sys_pipe+0xe2>
    80005328:	07e9                	addi	a5,a5,26
    8000532a:	078e                	slli	a5,a5,0x3
    8000532c:	97a6                	add	a5,a5,s1
    8000532e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005332:	fd043503          	ld	a0,-48(s0)
    80005336:	fffff097          	auipc	ra,0xfffff
    8000533a:	9be080e7          	jalr	-1602(ra) # 80003cf4 <fileclose>
    fileclose(wf);
    8000533e:	fc843503          	ld	a0,-56(s0)
    80005342:	fffff097          	auipc	ra,0xfffff
    80005346:	9b2080e7          	jalr	-1614(ra) # 80003cf4 <fileclose>
    return -1;
    8000534a:	57fd                	li	a5,-1
}
    8000534c:	853e                	mv	a0,a5
    8000534e:	70e2                	ld	ra,56(sp)
    80005350:	7442                	ld	s0,48(sp)
    80005352:	74a2                	ld	s1,40(sp)
    80005354:	6121                	addi	sp,sp,64
    80005356:	8082                	ret
	...

0000000080005360 <kernelvec>:
    80005360:	7111                	addi	sp,sp,-256
    80005362:	e006                	sd	ra,0(sp)
    80005364:	e40a                	sd	sp,8(sp)
    80005366:	e80e                	sd	gp,16(sp)
    80005368:	ec12                	sd	tp,24(sp)
    8000536a:	f016                	sd	t0,32(sp)
    8000536c:	f41a                	sd	t1,40(sp)
    8000536e:	f81e                	sd	t2,48(sp)
    80005370:	fc22                	sd	s0,56(sp)
    80005372:	e0a6                	sd	s1,64(sp)
    80005374:	e4aa                	sd	a0,72(sp)
    80005376:	e8ae                	sd	a1,80(sp)
    80005378:	ecb2                	sd	a2,88(sp)
    8000537a:	f0b6                	sd	a3,96(sp)
    8000537c:	f4ba                	sd	a4,104(sp)
    8000537e:	f8be                	sd	a5,112(sp)
    80005380:	fcc2                	sd	a6,120(sp)
    80005382:	e146                	sd	a7,128(sp)
    80005384:	e54a                	sd	s2,136(sp)
    80005386:	e94e                	sd	s3,144(sp)
    80005388:	ed52                	sd	s4,152(sp)
    8000538a:	f156                	sd	s5,160(sp)
    8000538c:	f55a                	sd	s6,168(sp)
    8000538e:	f95e                	sd	s7,176(sp)
    80005390:	fd62                	sd	s8,184(sp)
    80005392:	e1e6                	sd	s9,192(sp)
    80005394:	e5ea                	sd	s10,200(sp)
    80005396:	e9ee                	sd	s11,208(sp)
    80005398:	edf2                	sd	t3,216(sp)
    8000539a:	f1f6                	sd	t4,224(sp)
    8000539c:	f5fa                	sd	t5,232(sp)
    8000539e:	f9fe                	sd	t6,240(sp)
    800053a0:	d49fc0ef          	jal	ra,800020e8 <kerneltrap>
    800053a4:	6082                	ld	ra,0(sp)
    800053a6:	6122                	ld	sp,8(sp)
    800053a8:	61c2                	ld	gp,16(sp)
    800053aa:	7282                	ld	t0,32(sp)
    800053ac:	7322                	ld	t1,40(sp)
    800053ae:	73c2                	ld	t2,48(sp)
    800053b0:	7462                	ld	s0,56(sp)
    800053b2:	6486                	ld	s1,64(sp)
    800053b4:	6526                	ld	a0,72(sp)
    800053b6:	65c6                	ld	a1,80(sp)
    800053b8:	6666                	ld	a2,88(sp)
    800053ba:	7686                	ld	a3,96(sp)
    800053bc:	7726                	ld	a4,104(sp)
    800053be:	77c6                	ld	a5,112(sp)
    800053c0:	7866                	ld	a6,120(sp)
    800053c2:	688a                	ld	a7,128(sp)
    800053c4:	692a                	ld	s2,136(sp)
    800053c6:	69ca                	ld	s3,144(sp)
    800053c8:	6a6a                	ld	s4,152(sp)
    800053ca:	7a8a                	ld	s5,160(sp)
    800053cc:	7b2a                	ld	s6,168(sp)
    800053ce:	7bca                	ld	s7,176(sp)
    800053d0:	7c6a                	ld	s8,184(sp)
    800053d2:	6c8e                	ld	s9,192(sp)
    800053d4:	6d2e                	ld	s10,200(sp)
    800053d6:	6dce                	ld	s11,208(sp)
    800053d8:	6e6e                	ld	t3,216(sp)
    800053da:	7e8e                	ld	t4,224(sp)
    800053dc:	7f2e                	ld	t5,232(sp)
    800053de:	7fce                	ld	t6,240(sp)
    800053e0:	6111                	addi	sp,sp,256
    800053e2:	10200073          	sret
    800053e6:	00000013          	nop
    800053ea:	00000013          	nop
    800053ee:	0001                	nop

00000000800053f0 <timervec>:
    800053f0:	34051573          	csrrw	a0,mscratch,a0
    800053f4:	e10c                	sd	a1,0(a0)
    800053f6:	e510                	sd	a2,8(a0)
    800053f8:	e914                	sd	a3,16(a0)
    800053fa:	6d0c                	ld	a1,24(a0)
    800053fc:	7110                	ld	a2,32(a0)
    800053fe:	6194                	ld	a3,0(a1)
    80005400:	96b2                	add	a3,a3,a2
    80005402:	e194                	sd	a3,0(a1)
    80005404:	4589                	li	a1,2
    80005406:	14459073          	csrw	sip,a1
    8000540a:	6914                	ld	a3,16(a0)
    8000540c:	6510                	ld	a2,8(a0)
    8000540e:	610c                	ld	a1,0(a0)
    80005410:	34051573          	csrrw	a0,mscratch,a0
    80005414:	30200073          	mret
	...

000000008000541a <plicinit>:

//
// the riscv Platform Level Interrupt Controller (PLIC).
//

void plicinit(void) {
    8000541a:	1141                	addi	sp,sp,-16
    8000541c:	e422                	sd	s0,8(sp)
    8000541e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ * 4) = 1;
    80005420:	0c0007b7          	lui	a5,0xc000
    80005424:	4705                	li	a4,1
    80005426:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ * 4) = 1;
    80005428:	c3d8                	sw	a4,4(a5)
}
    8000542a:	6422                	ld	s0,8(sp)
    8000542c:	0141                	addi	sp,sp,16
    8000542e:	8082                	ret

0000000080005430 <plicinithart>:

void plicinithart(void) {
    80005430:	1141                	addi	sp,sp,-16
    80005432:	e406                	sd	ra,8(sp)
    80005434:	e022                	sd	s0,0(sp)
    80005436:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005438:	ffffc097          	auipc	ra,0xffffc
    8000543c:	ce4080e7          	jalr	-796(ra) # 8000111c <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005440:	0085171b          	slliw	a4,a0,0x8
    80005444:	0c0027b7          	lui	a5,0xc002
    80005448:	97ba                	add	a5,a5,a4
    8000544a:	40200713          	li	a4,1026
    8000544e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005452:	00d5151b          	slliw	a0,a0,0xd
    80005456:	0c2017b7          	lui	a5,0xc201
    8000545a:	97aa                	add	a5,a5,a0
    8000545c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005460:	60a2                	ld	ra,8(sp)
    80005462:	6402                	ld	s0,0(sp)
    80005464:	0141                	addi	sp,sp,16
    80005466:	8082                	ret

0000000080005468 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int plic_claim(void) {
    80005468:	1141                	addi	sp,sp,-16
    8000546a:	e406                	sd	ra,8(sp)
    8000546c:	e022                	sd	s0,0(sp)
    8000546e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005470:	ffffc097          	auipc	ra,0xffffc
    80005474:	cac080e7          	jalr	-852(ra) # 8000111c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005478:	00d5151b          	slliw	a0,a0,0xd
    8000547c:	0c2017b7          	lui	a5,0xc201
    80005480:	97aa                	add	a5,a5,a0
  return irq;
}
    80005482:	43c8                	lw	a0,4(a5)
    80005484:	60a2                	ld	ra,8(sp)
    80005486:	6402                	ld	s0,0(sp)
    80005488:	0141                	addi	sp,sp,16
    8000548a:	8082                	ret

000000008000548c <plic_complete>:

// tell the PLIC we've served this IRQ.
void plic_complete(int irq) {
    8000548c:	1101                	addi	sp,sp,-32
    8000548e:	ec06                	sd	ra,24(sp)
    80005490:	e822                	sd	s0,16(sp)
    80005492:	e426                	sd	s1,8(sp)
    80005494:	1000                	addi	s0,sp,32
    80005496:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005498:	ffffc097          	auipc	ra,0xffffc
    8000549c:	c84080e7          	jalr	-892(ra) # 8000111c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800054a0:	00d5151b          	slliw	a0,a0,0xd
    800054a4:	0c2017b7          	lui	a5,0xc201
    800054a8:	97aa                	add	a5,a5,a0
    800054aa:	c3c4                	sw	s1,4(a5)
}
    800054ac:	60e2                	ld	ra,24(sp)
    800054ae:	6442                	ld	s0,16(sp)
    800054b0:	64a2                	ld	s1,8(sp)
    800054b2:	6105                	addi	sp,sp,32
    800054b4:	8082                	ret

00000000800054b6 <free_desc>:
  }
  return -1;
}

// mark a descriptor as free.
static void free_desc(int i) {
    800054b6:	1141                	addi	sp,sp,-16
    800054b8:	e406                	sd	ra,8(sp)
    800054ba:	e022                	sd	s0,0(sp)
    800054bc:	0800                	addi	s0,sp,16
  if (i >= NUM) panic("free_desc 1");
    800054be:	479d                	li	a5,7
    800054c0:	04a7cc63          	blt	a5,a0,80005518 <free_desc+0x62>
  if (disk.free[i]) panic("free_desc 2");
    800054c4:	0009c797          	auipc	a5,0x9c
    800054c8:	50478793          	addi	a5,a5,1284 # 800a19c8 <disk>
    800054cc:	97aa                	add	a5,a5,a0
    800054ce:	0187c783          	lbu	a5,24(a5)
    800054d2:	ebb9                	bnez	a5,80005528 <free_desc+0x72>
  disk.desc[i].addr = 0;
    800054d4:	00451693          	slli	a3,a0,0x4
    800054d8:	0009c797          	auipc	a5,0x9c
    800054dc:	4f078793          	addi	a5,a5,1264 # 800a19c8 <disk>
    800054e0:	6398                	ld	a4,0(a5)
    800054e2:	9736                	add	a4,a4,a3
    800054e4:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800054e8:	6398                	ld	a4,0(a5)
    800054ea:	9736                	add	a4,a4,a3
    800054ec:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800054f0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800054f4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800054f8:	97aa                	add	a5,a5,a0
    800054fa:	4705                	li	a4,1
    800054fc:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005500:	0009c517          	auipc	a0,0x9c
    80005504:	4e050513          	addi	a0,a0,1248 # 800a19e0 <disk+0x18>
    80005508:	ffffc097          	auipc	ra,0xffffc
    8000550c:	34c080e7          	jalr	844(ra) # 80001854 <wakeup>
}
    80005510:	60a2                	ld	ra,8(sp)
    80005512:	6402                	ld	s0,0(sp)
    80005514:	0141                	addi	sp,sp,16
    80005516:	8082                	ret
  if (i >= NUM) panic("free_desc 1");
    80005518:	00003517          	auipc	a0,0x3
    8000551c:	18050513          	addi	a0,a0,384 # 80008698 <syscalls+0x2f0>
    80005520:	00001097          	auipc	ra,0x1
    80005524:	a0c080e7          	jalr	-1524(ra) # 80005f2c <panic>
  if (disk.free[i]) panic("free_desc 2");
    80005528:	00003517          	auipc	a0,0x3
    8000552c:	18050513          	addi	a0,a0,384 # 800086a8 <syscalls+0x300>
    80005530:	00001097          	auipc	ra,0x1
    80005534:	9fc080e7          	jalr	-1540(ra) # 80005f2c <panic>

0000000080005538 <virtio_disk_init>:
void virtio_disk_init(void) {
    80005538:	1101                	addi	sp,sp,-32
    8000553a:	ec06                	sd	ra,24(sp)
    8000553c:	e822                	sd	s0,16(sp)
    8000553e:	e426                	sd	s1,8(sp)
    80005540:	e04a                	sd	s2,0(sp)
    80005542:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005544:	00003597          	auipc	a1,0x3
    80005548:	17458593          	addi	a1,a1,372 # 800086b8 <syscalls+0x310>
    8000554c:	0009c517          	auipc	a0,0x9c
    80005550:	5a450513          	addi	a0,a0,1444 # 800a1af0 <disk+0x128>
    80005554:	00001097          	auipc	ra,0x1
    80005558:	e80080e7          	jalr	-384(ra) # 800063d4 <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000555c:	100017b7          	lui	a5,0x10001
    80005560:	4398                	lw	a4,0(a5)
    80005562:	2701                	sext.w	a4,a4
    80005564:	747277b7          	lui	a5,0x74727
    80005568:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000556c:	14f71b63          	bne	a4,a5,800056c2 <virtio_disk_init+0x18a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005570:	100017b7          	lui	a5,0x10001
    80005574:	43dc                	lw	a5,4(a5)
    80005576:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005578:	4709                	li	a4,2
    8000557a:	14e79463          	bne	a5,a4,800056c2 <virtio_disk_init+0x18a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000557e:	100017b7          	lui	a5,0x10001
    80005582:	479c                	lw	a5,8(a5)
    80005584:	2781                	sext.w	a5,a5
    80005586:	12e79e63          	bne	a5,a4,800056c2 <virtio_disk_init+0x18a>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    8000558a:	100017b7          	lui	a5,0x10001
    8000558e:	47d8                	lw	a4,12(a5)
    80005590:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005592:	554d47b7          	lui	a5,0x554d4
    80005596:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000559a:	12f71463          	bne	a4,a5,800056c2 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000559e:	100017b7          	lui	a5,0x10001
    800055a2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800055a6:	4705                	li	a4,1
    800055a8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055aa:	470d                	li	a4,3
    800055ac:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800055ae:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800055b0:	c7ffe6b7          	lui	a3,0xc7ffe
    800055b4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47f54a0f>
    800055b8:	8f75                	and	a4,a4,a3
    800055ba:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055bc:	472d                	li	a4,11
    800055be:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800055c0:	5bbc                	lw	a5,112(a5)
    800055c2:	0007891b          	sext.w	s2,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800055c6:	8ba1                	andi	a5,a5,8
    800055c8:	10078563          	beqz	a5,800056d2 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800055cc:	100017b7          	lui	a5,0x10001
    800055d0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY)) panic("virtio disk should not be ready");
    800055d4:	43fc                	lw	a5,68(a5)
    800055d6:	2781                	sext.w	a5,a5
    800055d8:	10079563          	bnez	a5,800056e2 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800055dc:	100017b7          	lui	a5,0x10001
    800055e0:	5bdc                	lw	a5,52(a5)
    800055e2:	2781                	sext.w	a5,a5
  if (max == 0) panic("virtio disk has no queue 0");
    800055e4:	10078763          	beqz	a5,800056f2 <virtio_disk_init+0x1ba>
  if (max < NUM) panic("virtio disk max queue too short");
    800055e8:	471d                	li	a4,7
    800055ea:	10f77c63          	bgeu	a4,a5,80005702 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    800055ee:	ffffb097          	auipc	ra,0xffffb
    800055f2:	b2c080e7          	jalr	-1236(ra) # 8000011a <kalloc>
    800055f6:	0009c497          	auipc	s1,0x9c
    800055fa:	3d248493          	addi	s1,s1,978 # 800a19c8 <disk>
    800055fe:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005600:	ffffb097          	auipc	ra,0xffffb
    80005604:	b1a080e7          	jalr	-1254(ra) # 8000011a <kalloc>
    80005608:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000560a:	ffffb097          	auipc	ra,0xffffb
    8000560e:	b10080e7          	jalr	-1264(ra) # 8000011a <kalloc>
    80005612:	87aa                	mv	a5,a0
    80005614:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used) panic("virtio disk kalloc");
    80005616:	6088                	ld	a0,0(s1)
    80005618:	cd6d                	beqz	a0,80005712 <virtio_disk_init+0x1da>
    8000561a:	0009c717          	auipc	a4,0x9c
    8000561e:	3b673703          	ld	a4,950(a4) # 800a19d0 <disk+0x8>
    80005622:	cb65                	beqz	a4,80005712 <virtio_disk_init+0x1da>
    80005624:	c7fd                	beqz	a5,80005712 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005626:	6605                	lui	a2,0x1
    80005628:	4581                	li	a1,0
    8000562a:	ffffb097          	auipc	ra,0xffffb
    8000562e:	b50080e7          	jalr	-1200(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005632:	0009c497          	auipc	s1,0x9c
    80005636:	39648493          	addi	s1,s1,918 # 800a19c8 <disk>
    8000563a:	6605                	lui	a2,0x1
    8000563c:	4581                	li	a1,0
    8000563e:	6488                	ld	a0,8(s1)
    80005640:	ffffb097          	auipc	ra,0xffffb
    80005644:	b3a080e7          	jalr	-1222(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    80005648:	6605                	lui	a2,0x1
    8000564a:	4581                	li	a1,0
    8000564c:	6888                	ld	a0,16(s1)
    8000564e:	ffffb097          	auipc	ra,0xffffb
    80005652:	b2c080e7          	jalr	-1236(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005656:	100017b7          	lui	a5,0x10001
    8000565a:	4721                	li	a4,8
    8000565c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000565e:	4098                	lw	a4,0(s1)
    80005660:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005664:	40d8                	lw	a4,4(s1)
    80005666:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000566a:	6498                	ld	a4,8(s1)
    8000566c:	0007069b          	sext.w	a3,a4
    80005670:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005674:	9701                	srai	a4,a4,0x20
    80005676:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000567a:	6898                	ld	a4,16(s1)
    8000567c:	0007069b          	sext.w	a3,a4
    80005680:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005684:	9701                	srai	a4,a4,0x20
    80005686:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000568a:	4705                	li	a4,1
    8000568c:	c3f8                	sw	a4,68(a5)
  for (int i = 0; i < NUM; i++) disk.free[i] = 1;
    8000568e:	00e48c23          	sb	a4,24(s1)
    80005692:	00e48ca3          	sb	a4,25(s1)
    80005696:	00e48d23          	sb	a4,26(s1)
    8000569a:	00e48da3          	sb	a4,27(s1)
    8000569e:	00e48e23          	sb	a4,28(s1)
    800056a2:	00e48ea3          	sb	a4,29(s1)
    800056a6:	00e48f23          	sb	a4,30(s1)
    800056aa:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800056ae:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800056b2:	0727a823          	sw	s2,112(a5)
}
    800056b6:	60e2                	ld	ra,24(sp)
    800056b8:	6442                	ld	s0,16(sp)
    800056ba:	64a2                	ld	s1,8(sp)
    800056bc:	6902                	ld	s2,0(sp)
    800056be:	6105                	addi	sp,sp,32
    800056c0:	8082                	ret
    panic("could not find virtio disk");
    800056c2:	00003517          	auipc	a0,0x3
    800056c6:	00650513          	addi	a0,a0,6 # 800086c8 <syscalls+0x320>
    800056ca:	00001097          	auipc	ra,0x1
    800056ce:	862080e7          	jalr	-1950(ra) # 80005f2c <panic>
    panic("virtio disk FEATURES_OK unset");
    800056d2:	00003517          	auipc	a0,0x3
    800056d6:	01650513          	addi	a0,a0,22 # 800086e8 <syscalls+0x340>
    800056da:	00001097          	auipc	ra,0x1
    800056de:	852080e7          	jalr	-1966(ra) # 80005f2c <panic>
  if (*R(VIRTIO_MMIO_QUEUE_READY)) panic("virtio disk should not be ready");
    800056e2:	00003517          	auipc	a0,0x3
    800056e6:	02650513          	addi	a0,a0,38 # 80008708 <syscalls+0x360>
    800056ea:	00001097          	auipc	ra,0x1
    800056ee:	842080e7          	jalr	-1982(ra) # 80005f2c <panic>
  if (max == 0) panic("virtio disk has no queue 0");
    800056f2:	00003517          	auipc	a0,0x3
    800056f6:	03650513          	addi	a0,a0,54 # 80008728 <syscalls+0x380>
    800056fa:	00001097          	auipc	ra,0x1
    800056fe:	832080e7          	jalr	-1998(ra) # 80005f2c <panic>
  if (max < NUM) panic("virtio disk max queue too short");
    80005702:	00003517          	auipc	a0,0x3
    80005706:	04650513          	addi	a0,a0,70 # 80008748 <syscalls+0x3a0>
    8000570a:	00001097          	auipc	ra,0x1
    8000570e:	822080e7          	jalr	-2014(ra) # 80005f2c <panic>
  if (!disk.desc || !disk.avail || !disk.used) panic("virtio disk kalloc");
    80005712:	00003517          	auipc	a0,0x3
    80005716:	05650513          	addi	a0,a0,86 # 80008768 <syscalls+0x3c0>
    8000571a:	00001097          	auipc	ra,0x1
    8000571e:	812080e7          	jalr	-2030(ra) # 80005f2c <panic>

0000000080005722 <virtio_disk_rw>:
    }
  }
  return 0;
}

void virtio_disk_rw(struct buf *b, int write) {
    80005722:	7119                	addi	sp,sp,-128
    80005724:	fc86                	sd	ra,120(sp)
    80005726:	f8a2                	sd	s0,112(sp)
    80005728:	f4a6                	sd	s1,104(sp)
    8000572a:	f0ca                	sd	s2,96(sp)
    8000572c:	ecce                	sd	s3,88(sp)
    8000572e:	e8d2                	sd	s4,80(sp)
    80005730:	e4d6                	sd	s5,72(sp)
    80005732:	e0da                	sd	s6,64(sp)
    80005734:	fc5e                	sd	s7,56(sp)
    80005736:	f862                	sd	s8,48(sp)
    80005738:	f466                	sd	s9,40(sp)
    8000573a:	f06a                	sd	s10,32(sp)
    8000573c:	ec6e                	sd	s11,24(sp)
    8000573e:	0100                	addi	s0,sp,128
    80005740:	8aaa                	mv	s5,a0
    80005742:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005744:	00c52d03          	lw	s10,12(a0)
    80005748:	001d1d1b          	slliw	s10,s10,0x1
    8000574c:	1d02                	slli	s10,s10,0x20
    8000574e:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005752:	0009c517          	auipc	a0,0x9c
    80005756:	39e50513          	addi	a0,a0,926 # 800a1af0 <disk+0x128>
    8000575a:	00001097          	auipc	ra,0x1
    8000575e:	d0a080e7          	jalr	-758(ra) # 80006464 <acquire>
  for (int i = 0; i < 3; i++) {
    80005762:	4981                	li	s3,0
  for (int i = 0; i < NUM; i++) {
    80005764:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005766:	0009cb97          	auipc	s7,0x9c
    8000576a:	262b8b93          	addi	s7,s7,610 # 800a19c8 <disk>
  for (int i = 0; i < 3; i++) {
    8000576e:	4b0d                	li	s6,3
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005770:	0009cc97          	auipc	s9,0x9c
    80005774:	380c8c93          	addi	s9,s9,896 # 800a1af0 <disk+0x128>
    80005778:	a08d                	j	800057da <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000577a:	00fb8733          	add	a4,s7,a5
    8000577e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005782:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    80005784:	0207c563          	bltz	a5,800057ae <virtio_disk_rw+0x8c>
  for (int i = 0; i < 3; i++) {
    80005788:	2905                	addiw	s2,s2,1
    8000578a:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000578c:	05690c63          	beq	s2,s6,800057e4 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005790:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    80005792:	0009c717          	auipc	a4,0x9c
    80005796:	23670713          	addi	a4,a4,566 # 800a19c8 <disk>
    8000579a:	87ce                	mv	a5,s3
    if (disk.free[i]) {
    8000579c:	01874683          	lbu	a3,24(a4)
    800057a0:	fee9                	bnez	a3,8000577a <virtio_disk_rw+0x58>
  for (int i = 0; i < NUM; i++) {
    800057a2:	2785                	addiw	a5,a5,1
    800057a4:	0705                	addi	a4,a4,1
    800057a6:	fe979be3          	bne	a5,s1,8000579c <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800057aa:	57fd                	li	a5,-1
    800057ac:	c19c                	sw	a5,0(a1)
      for (int j = 0; j < i; j++) free_desc(idx[j]);
    800057ae:	01205d63          	blez	s2,800057c8 <virtio_disk_rw+0xa6>
    800057b2:	8dce                	mv	s11,s3
    800057b4:	000a2503          	lw	a0,0(s4)
    800057b8:	00000097          	auipc	ra,0x0
    800057bc:	cfe080e7          	jalr	-770(ra) # 800054b6 <free_desc>
    800057c0:	2d85                	addiw	s11,s11,1
    800057c2:	0a11                	addi	s4,s4,4
    800057c4:	ff2d98e3          	bne	s11,s2,800057b4 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800057c8:	85e6                	mv	a1,s9
    800057ca:	0009c517          	auipc	a0,0x9c
    800057ce:	21650513          	addi	a0,a0,534 # 800a19e0 <disk+0x18>
    800057d2:	ffffc097          	auipc	ra,0xffffc
    800057d6:	01e080e7          	jalr	30(ra) # 800017f0 <sleep>
  for (int i = 0; i < 3; i++) {
    800057da:	f8040a13          	addi	s4,s0,-128
void virtio_disk_rw(struct buf *b, int write) {
    800057de:	8652                	mv	a2,s4
  for (int i = 0; i < 3; i++) {
    800057e0:	894e                	mv	s2,s3
    800057e2:	b77d                	j	80005790 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057e4:	f8042503          	lw	a0,-128(s0)
    800057e8:	00a50713          	addi	a4,a0,10
    800057ec:	0712                	slli	a4,a4,0x4

  if (write)
    800057ee:	0009c797          	auipc	a5,0x9c
    800057f2:	1da78793          	addi	a5,a5,474 # 800a19c8 <disk>
    800057f6:	00e786b3          	add	a3,a5,a4
    800057fa:	01803633          	snez	a2,s8
    800057fe:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT;  // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN;  // read the disk
  buf0->reserved = 0;
    80005800:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005804:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64)buf0;
    80005808:	f6070613          	addi	a2,a4,-160
    8000580c:	6394                	ld	a3,0(a5)
    8000580e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005810:	00870593          	addi	a1,a4,8
    80005814:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    80005816:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005818:	0007b803          	ld	a6,0(a5)
    8000581c:	9642                	add	a2,a2,a6
    8000581e:	46c1                	li	a3,16
    80005820:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005822:	4585                	li	a1,1
    80005824:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005828:	f8442683          	lw	a3,-124(s0)
    8000582c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64)b->data;
    80005830:	0692                	slli	a3,a3,0x4
    80005832:	9836                	add	a6,a6,a3
    80005834:	058a8613          	addi	a2,s5,88
    80005838:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000583c:	0007b803          	ld	a6,0(a5)
    80005840:	96c2                	add	a3,a3,a6
    80005842:	40000613          	li	a2,1024
    80005846:	c690                	sw	a2,8(a3)
  if (write)
    80005848:	001c3613          	seqz	a2,s8
    8000584c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0;  // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE;  // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005850:	00166613          	ori	a2,a2,1
    80005854:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005858:	f8842603          	lw	a2,-120(s0)
    8000585c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff;  // device writes 0 on success
    80005860:	00250693          	addi	a3,a0,2
    80005864:	0692                	slli	a3,a3,0x4
    80005866:	96be                	add	a3,a3,a5
    80005868:	58fd                	li	a7,-1
    8000586a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    8000586e:	0612                	slli	a2,a2,0x4
    80005870:	9832                	add	a6,a6,a2
    80005872:	f9070713          	addi	a4,a4,-112
    80005876:	973e                	add	a4,a4,a5
    80005878:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000587c:	6398                	ld	a4,0(a5)
    8000587e:	9732                	add	a4,a4,a2
    80005880:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE;  // device writes the status
    80005882:	4609                	li	a2,2
    80005884:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005888:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000588c:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80005890:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005894:	6794                	ld	a3,8(a5)
    80005896:	0026d703          	lhu	a4,2(a3)
    8000589a:	8b1d                	andi	a4,a4,7
    8000589c:	0706                	slli	a4,a4,0x1
    8000589e:	96ba                	add	a3,a3,a4
    800058a0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800058a4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1;  // not % NUM ...
    800058a8:	6798                	ld	a4,8(a5)
    800058aa:	00275783          	lhu	a5,2(a4)
    800058ae:	2785                	addiw	a5,a5,1
    800058b0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800058b4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0;  // value is queue number
    800058b8:	100017b7          	lui	a5,0x10001
    800058bc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    800058c0:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    800058c4:	0009c917          	auipc	s2,0x9c
    800058c8:	22c90913          	addi	s2,s2,556 # 800a1af0 <disk+0x128>
  while (b->disk == 1) {
    800058cc:	4485                	li	s1,1
    800058ce:	00b79c63          	bne	a5,a1,800058e6 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800058d2:	85ca                	mv	a1,s2
    800058d4:	8556                	mv	a0,s5
    800058d6:	ffffc097          	auipc	ra,0xffffc
    800058da:	f1a080e7          	jalr	-230(ra) # 800017f0 <sleep>
  while (b->disk == 1) {
    800058de:	004aa783          	lw	a5,4(s5)
    800058e2:	fe9788e3          	beq	a5,s1,800058d2 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800058e6:	f8042903          	lw	s2,-128(s0)
    800058ea:	00290713          	addi	a4,s2,2
    800058ee:	0712                	slli	a4,a4,0x4
    800058f0:	0009c797          	auipc	a5,0x9c
    800058f4:	0d878793          	addi	a5,a5,216 # 800a19c8 <disk>
    800058f8:	97ba                	add	a5,a5,a4
    800058fa:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800058fe:	0009c997          	auipc	s3,0x9c
    80005902:	0ca98993          	addi	s3,s3,202 # 800a19c8 <disk>
    80005906:	00491713          	slli	a4,s2,0x4
    8000590a:	0009b783          	ld	a5,0(s3)
    8000590e:	97ba                	add	a5,a5,a4
    80005910:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005914:	854a                	mv	a0,s2
    80005916:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000591a:	00000097          	auipc	ra,0x0
    8000591e:	b9c080e7          	jalr	-1124(ra) # 800054b6 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    80005922:	8885                	andi	s1,s1,1
    80005924:	f0ed                	bnez	s1,80005906 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005926:	0009c517          	auipc	a0,0x9c
    8000592a:	1ca50513          	addi	a0,a0,458 # 800a1af0 <disk+0x128>
    8000592e:	00001097          	auipc	ra,0x1
    80005932:	bea080e7          	jalr	-1046(ra) # 80006518 <release>
}
    80005936:	70e6                	ld	ra,120(sp)
    80005938:	7446                	ld	s0,112(sp)
    8000593a:	74a6                	ld	s1,104(sp)
    8000593c:	7906                	ld	s2,96(sp)
    8000593e:	69e6                	ld	s3,88(sp)
    80005940:	6a46                	ld	s4,80(sp)
    80005942:	6aa6                	ld	s5,72(sp)
    80005944:	6b06                	ld	s6,64(sp)
    80005946:	7be2                	ld	s7,56(sp)
    80005948:	7c42                	ld	s8,48(sp)
    8000594a:	7ca2                	ld	s9,40(sp)
    8000594c:	7d02                	ld	s10,32(sp)
    8000594e:	6de2                	ld	s11,24(sp)
    80005950:	6109                	addi	sp,sp,128
    80005952:	8082                	ret

0000000080005954 <virtio_disk_intr>:

void virtio_disk_intr() {
    80005954:	1101                	addi	sp,sp,-32
    80005956:	ec06                	sd	ra,24(sp)
    80005958:	e822                	sd	s0,16(sp)
    8000595a:	e426                	sd	s1,8(sp)
    8000595c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000595e:	0009c497          	auipc	s1,0x9c
    80005962:	06a48493          	addi	s1,s1,106 # 800a19c8 <disk>
    80005966:	0009c517          	auipc	a0,0x9c
    8000596a:	18a50513          	addi	a0,a0,394 # 800a1af0 <disk+0x128>
    8000596e:	00001097          	auipc	ra,0x1
    80005972:	af6080e7          	jalr	-1290(ra) # 80006464 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005976:	10001737          	lui	a4,0x10001
    8000597a:	533c                	lw	a5,96(a4)
    8000597c:	8b8d                	andi	a5,a5,3
    8000597e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005980:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    80005984:	689c                	ld	a5,16(s1)
    80005986:	0204d703          	lhu	a4,32(s1)
    8000598a:	0027d783          	lhu	a5,2(a5)
    8000598e:	04f70863          	beq	a4,a5,800059de <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005992:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005996:	6898                	ld	a4,16(s1)
    80005998:	0204d783          	lhu	a5,32(s1)
    8000599c:	8b9d                	andi	a5,a5,7
    8000599e:	078e                	slli	a5,a5,0x3
    800059a0:	97ba                	add	a5,a5,a4
    800059a2:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0) panic("virtio_disk_intr status");
    800059a4:	00278713          	addi	a4,a5,2
    800059a8:	0712                	slli	a4,a4,0x4
    800059aa:	9726                	add	a4,a4,s1
    800059ac:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800059b0:	e721                	bnez	a4,800059f8 <virtio_disk_intr+0xa4>

    struct buf *b = disk.info[id].b;
    800059b2:	0789                	addi	a5,a5,2
    800059b4:	0792                	slli	a5,a5,0x4
    800059b6:	97a6                	add	a5,a5,s1
    800059b8:	6788                	ld	a0,8(a5)
    b->disk = 0;  // disk is done with buf
    800059ba:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800059be:	ffffc097          	auipc	ra,0xffffc
    800059c2:	e96080e7          	jalr	-362(ra) # 80001854 <wakeup>

    disk.used_idx += 1;
    800059c6:	0204d783          	lhu	a5,32(s1)
    800059ca:	2785                	addiw	a5,a5,1
    800059cc:	17c2                	slli	a5,a5,0x30
    800059ce:	93c1                	srli	a5,a5,0x30
    800059d0:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    800059d4:	6898                	ld	a4,16(s1)
    800059d6:	00275703          	lhu	a4,2(a4)
    800059da:	faf71ce3          	bne	a4,a5,80005992 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800059de:	0009c517          	auipc	a0,0x9c
    800059e2:	11250513          	addi	a0,a0,274 # 800a1af0 <disk+0x128>
    800059e6:	00001097          	auipc	ra,0x1
    800059ea:	b32080e7          	jalr	-1230(ra) # 80006518 <release>
}
    800059ee:	60e2                	ld	ra,24(sp)
    800059f0:	6442                	ld	s0,16(sp)
    800059f2:	64a2                	ld	s1,8(sp)
    800059f4:	6105                	addi	sp,sp,32
    800059f6:	8082                	ret
    if (disk.info[id].status != 0) panic("virtio_disk_intr status");
    800059f8:	00003517          	auipc	a0,0x3
    800059fc:	d8850513          	addi	a0,a0,-632 # 80008780 <syscalls+0x3d8>
    80005a00:	00000097          	auipc	ra,0x0
    80005a04:	52c080e7          	jalr	1324(ra) # 80005f2c <panic>

0000000080005a08 <timerinit>:
// arrange to receive timer interrupts.
// they will arrive in machine mode at
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void timerinit() {
    80005a08:	1141                	addi	sp,sp,-16
    80005a0a:	e422                	sd	s0,8(sp)
    80005a0c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r"(x));
    80005a0e:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005a12:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000;  // cycles; about 1/10th second in qemu.
  *(uint64 *)CLINT_MTIMECMP(id) = *(uint64 *)CLINT_MTIME + interval;
    80005a16:	0037979b          	slliw	a5,a5,0x3
    80005a1a:	02004737          	lui	a4,0x2004
    80005a1e:	97ba                	add	a5,a5,a4
    80005a20:	0200c737          	lui	a4,0x200c
    80005a24:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005a28:	000f4637          	lui	a2,0xf4
    80005a2c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005a30:	9732                	add	a4,a4,a2
    80005a32:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005a34:	00259693          	slli	a3,a1,0x2
    80005a38:	96ae                	add	a3,a3,a1
    80005a3a:	068e                	slli	a3,a3,0x3
    80005a3c:	0009c717          	auipc	a4,0x9c
    80005a40:	0d470713          	addi	a4,a4,212 # 800a1b10 <timer_scratch>
    80005a44:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005a46:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005a48:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r"(x));
    80005a4a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r"(x));
    80005a4e:	00000797          	auipc	a5,0x0
    80005a52:	9a278793          	addi	a5,a5,-1630 # 800053f0 <timervec>
    80005a56:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80005a5a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005a5e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80005a62:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r"(x));
    80005a66:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005a6a:	0807e793          	ori	a5,a5,128
static inline void w_mie(uint64 x) { asm volatile("csrw mie, %0" : : "r"(x)); }
    80005a6e:	30479073          	csrw	mie,a5
}
    80005a72:	6422                	ld	s0,8(sp)
    80005a74:	0141                	addi	sp,sp,16
    80005a76:	8082                	ret

0000000080005a78 <start>:
void start() {
    80005a78:	1141                	addi	sp,sp,-16
    80005a7a:	e406                	sd	ra,8(sp)
    80005a7c:	e022                	sd	s0,0(sp)
    80005a7e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80005a80:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005a84:	7779                	lui	a4,0xffffe
    80005a86:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ff54aaf>
    80005a8a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005a8c:	6705                	lui	a4,0x1
    80005a8e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005a92:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80005a94:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80005a98:	ffffb797          	auipc	a5,0xffffb
    80005a9c:	88878793          	addi	a5,a5,-1912 # 80000320 <main>
    80005aa0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80005aa4:	4781                	li	a5,0
    80005aa6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    80005aaa:	67c1                	lui	a5,0x10
    80005aac:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005aae:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    80005ab2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80005ab6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005aba:	2227e793          	ori	a5,a5,546
static inline void w_sie(uint64 x) { asm volatile("csrw sie, %0" : : "r"(x)); }
    80005abe:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    80005ac2:	57fd                	li	a5,-1
    80005ac4:	83a9                	srli	a5,a5,0xa
    80005ac6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    80005aca:	47bd                	li	a5,15
    80005acc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005ad0:	00000097          	auipc	ra,0x0
    80005ad4:	f38080e7          	jalr	-200(ra) # 80005a08 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    80005ad8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005adc:	2781                	sext.w	a5,a5
static inline void w_tp(uint64 x) { asm volatile("mv tp, %0" : : "r"(x)); }
    80005ade:	823e                	mv	tp,a5
  asm volatile("mret");
    80005ae0:	30200073          	mret
}
    80005ae4:	60a2                	ld	ra,8(sp)
    80005ae6:	6402                	ld	s0,0(sp)
    80005ae8:	0141                	addi	sp,sp,16
    80005aea:	8082                	ret

0000000080005aec <consolewrite>:
} cons;

//
// user write()s to the console go here.
//
int consolewrite(int user_src, uint64 src, int n) {
    80005aec:	715d                	addi	sp,sp,-80
    80005aee:	e486                	sd	ra,72(sp)
    80005af0:	e0a2                	sd	s0,64(sp)
    80005af2:	fc26                	sd	s1,56(sp)
    80005af4:	f84a                	sd	s2,48(sp)
    80005af6:	f44e                	sd	s3,40(sp)
    80005af8:	f052                	sd	s4,32(sp)
    80005afa:	ec56                	sd	s5,24(sp)
    80005afc:	0880                	addi	s0,sp,80
  int i;

  for (i = 0; i < n; i++) {
    80005afe:	04c05763          	blez	a2,80005b4c <consolewrite+0x60>
    80005b02:	8a2a                	mv	s4,a0
    80005b04:	84ae                	mv	s1,a1
    80005b06:	89b2                	mv	s3,a2
    80005b08:	4901                	li	s2,0
    char c;
    if (either_copyin(&c, user_src, src + i, 1) == -1) break;
    80005b0a:	5afd                	li	s5,-1
    80005b0c:	4685                	li	a3,1
    80005b0e:	8626                	mv	a2,s1
    80005b10:	85d2                	mv	a1,s4
    80005b12:	fbf40513          	addi	a0,s0,-65
    80005b16:	ffffc097          	auipc	ra,0xffffc
    80005b1a:	13e080e7          	jalr	318(ra) # 80001c54 <either_copyin>
    80005b1e:	01550d63          	beq	a0,s5,80005b38 <consolewrite+0x4c>
    uartputc(c);
    80005b22:	fbf44503          	lbu	a0,-65(s0)
    80005b26:	00000097          	auipc	ra,0x0
    80005b2a:	784080e7          	jalr	1924(ra) # 800062aa <uartputc>
  for (i = 0; i < n; i++) {
    80005b2e:	2905                	addiw	s2,s2,1
    80005b30:	0485                	addi	s1,s1,1
    80005b32:	fd299de3          	bne	s3,s2,80005b0c <consolewrite+0x20>
    80005b36:	894e                	mv	s2,s3
  }

  return i;
}
    80005b38:	854a                	mv	a0,s2
    80005b3a:	60a6                	ld	ra,72(sp)
    80005b3c:	6406                	ld	s0,64(sp)
    80005b3e:	74e2                	ld	s1,56(sp)
    80005b40:	7942                	ld	s2,48(sp)
    80005b42:	79a2                	ld	s3,40(sp)
    80005b44:	7a02                	ld	s4,32(sp)
    80005b46:	6ae2                	ld	s5,24(sp)
    80005b48:	6161                	addi	sp,sp,80
    80005b4a:	8082                	ret
  for (i = 0; i < n; i++) {
    80005b4c:	4901                	li	s2,0
    80005b4e:	b7ed                	j	80005b38 <consolewrite+0x4c>

0000000080005b50 <consoleread>:
// user read()s from the console go here.
// copy (up to) a whole input line to dst.
// user_dist indicates whether dst is a user
// or kernel address.
//
int consoleread(int user_dst, uint64 dst, int n) {
    80005b50:	7159                	addi	sp,sp,-112
    80005b52:	f486                	sd	ra,104(sp)
    80005b54:	f0a2                	sd	s0,96(sp)
    80005b56:	eca6                	sd	s1,88(sp)
    80005b58:	e8ca                	sd	s2,80(sp)
    80005b5a:	e4ce                	sd	s3,72(sp)
    80005b5c:	e0d2                	sd	s4,64(sp)
    80005b5e:	fc56                	sd	s5,56(sp)
    80005b60:	f85a                	sd	s6,48(sp)
    80005b62:	f45e                	sd	s7,40(sp)
    80005b64:	f062                	sd	s8,32(sp)
    80005b66:	ec66                	sd	s9,24(sp)
    80005b68:	e86a                	sd	s10,16(sp)
    80005b6a:	1880                	addi	s0,sp,112
    80005b6c:	8aaa                	mv	s5,a0
    80005b6e:	8a2e                	mv	s4,a1
    80005b70:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005b72:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005b76:	000a4517          	auipc	a0,0xa4
    80005b7a:	0da50513          	addi	a0,a0,218 # 800a9c50 <cons>
    80005b7e:	00001097          	auipc	ra,0x1
    80005b82:	8e6080e7          	jalr	-1818(ra) # 80006464 <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    80005b86:	000a4497          	auipc	s1,0xa4
    80005b8a:	0ca48493          	addi	s1,s1,202 # 800a9c50 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005b8e:	000a4917          	auipc	s2,0xa4
    80005b92:	15a90913          	addi	s2,s2,346 # 800a9ce8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if (c == C('D')) {  // end-of-file
    80005b96:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1) break;
    80005b98:	5c7d                	li	s8,-1

    dst++;
    --n;

    if (c == '\n') {
    80005b9a:	4ca9                	li	s9,10
  while (n > 0) {
    80005b9c:	07305b63          	blez	s3,80005c12 <consoleread+0xc2>
    while (cons.r == cons.w) {
    80005ba0:	0984a783          	lw	a5,152(s1)
    80005ba4:	09c4a703          	lw	a4,156(s1)
    80005ba8:	02f71763          	bne	a4,a5,80005bd6 <consoleread+0x86>
      if (killed(myproc())) {
    80005bac:	ffffb097          	auipc	ra,0xffffb
    80005bb0:	59c080e7          	jalr	1436(ra) # 80001148 <myproc>
    80005bb4:	ffffc097          	auipc	ra,0xffffc
    80005bb8:	ee4080e7          	jalr	-284(ra) # 80001a98 <killed>
    80005bbc:	e535                	bnez	a0,80005c28 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    80005bbe:	85a6                	mv	a1,s1
    80005bc0:	854a                	mv	a0,s2
    80005bc2:	ffffc097          	auipc	ra,0xffffc
    80005bc6:	c2e080e7          	jalr	-978(ra) # 800017f0 <sleep>
    while (cons.r == cons.w) {
    80005bca:	0984a783          	lw	a5,152(s1)
    80005bce:	09c4a703          	lw	a4,156(s1)
    80005bd2:	fcf70de3          	beq	a4,a5,80005bac <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005bd6:	0017871b          	addiw	a4,a5,1
    80005bda:	08e4ac23          	sw	a4,152(s1)
    80005bde:	07f7f713          	andi	a4,a5,127
    80005be2:	9726                	add	a4,a4,s1
    80005be4:	01874703          	lbu	a4,24(a4)
    80005be8:	00070d1b          	sext.w	s10,a4
    if (c == C('D')) {  // end-of-file
    80005bec:	077d0563          	beq	s10,s7,80005c56 <consoleread+0x106>
    cbuf = c;
    80005bf0:	f8e40fa3          	sb	a4,-97(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1) break;
    80005bf4:	4685                	li	a3,1
    80005bf6:	f9f40613          	addi	a2,s0,-97
    80005bfa:	85d2                	mv	a1,s4
    80005bfc:	8556                	mv	a0,s5
    80005bfe:	ffffc097          	auipc	ra,0xffffc
    80005c02:	000080e7          	jalr	ra # 80001bfe <either_copyout>
    80005c06:	01850663          	beq	a0,s8,80005c12 <consoleread+0xc2>
    dst++;
    80005c0a:	0a05                	addi	s4,s4,1
    --n;
    80005c0c:	39fd                	addiw	s3,s3,-1
    if (c == '\n') {
    80005c0e:	f99d17e3          	bne	s10,s9,80005b9c <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005c12:	000a4517          	auipc	a0,0xa4
    80005c16:	03e50513          	addi	a0,a0,62 # 800a9c50 <cons>
    80005c1a:	00001097          	auipc	ra,0x1
    80005c1e:	8fe080e7          	jalr	-1794(ra) # 80006518 <release>

  return target - n;
    80005c22:	413b053b          	subw	a0,s6,s3
    80005c26:	a811                	j	80005c3a <consoleread+0xea>
        release(&cons.lock);
    80005c28:	000a4517          	auipc	a0,0xa4
    80005c2c:	02850513          	addi	a0,a0,40 # 800a9c50 <cons>
    80005c30:	00001097          	auipc	ra,0x1
    80005c34:	8e8080e7          	jalr	-1816(ra) # 80006518 <release>
        return -1;
    80005c38:	557d                	li	a0,-1
}
    80005c3a:	70a6                	ld	ra,104(sp)
    80005c3c:	7406                	ld	s0,96(sp)
    80005c3e:	64e6                	ld	s1,88(sp)
    80005c40:	6946                	ld	s2,80(sp)
    80005c42:	69a6                	ld	s3,72(sp)
    80005c44:	6a06                	ld	s4,64(sp)
    80005c46:	7ae2                	ld	s5,56(sp)
    80005c48:	7b42                	ld	s6,48(sp)
    80005c4a:	7ba2                	ld	s7,40(sp)
    80005c4c:	7c02                	ld	s8,32(sp)
    80005c4e:	6ce2                	ld	s9,24(sp)
    80005c50:	6d42                	ld	s10,16(sp)
    80005c52:	6165                	addi	sp,sp,112
    80005c54:	8082                	ret
      if (n < target) {
    80005c56:	0009871b          	sext.w	a4,s3
    80005c5a:	fb677ce3          	bgeu	a4,s6,80005c12 <consoleread+0xc2>
        cons.r--;
    80005c5e:	000a4717          	auipc	a4,0xa4
    80005c62:	08f72523          	sw	a5,138(a4) # 800a9ce8 <cons+0x98>
    80005c66:	b775                	j	80005c12 <consoleread+0xc2>

0000000080005c68 <consputc>:
void consputc(int c) {
    80005c68:	1141                	addi	sp,sp,-16
    80005c6a:	e406                	sd	ra,8(sp)
    80005c6c:	e022                	sd	s0,0(sp)
    80005c6e:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80005c70:	10000793          	li	a5,256
    80005c74:	00f50a63          	beq	a0,a5,80005c88 <consputc+0x20>
    uartputc_sync(c);
    80005c78:	00000097          	auipc	ra,0x0
    80005c7c:	560080e7          	jalr	1376(ra) # 800061d8 <uartputc_sync>
}
    80005c80:	60a2                	ld	ra,8(sp)
    80005c82:	6402                	ld	s0,0(sp)
    80005c84:	0141                	addi	sp,sp,16
    80005c86:	8082                	ret
    uartputc_sync('\b');
    80005c88:	4521                	li	a0,8
    80005c8a:	00000097          	auipc	ra,0x0
    80005c8e:	54e080e7          	jalr	1358(ra) # 800061d8 <uartputc_sync>
    uartputc_sync(' ');
    80005c92:	02000513          	li	a0,32
    80005c96:	00000097          	auipc	ra,0x0
    80005c9a:	542080e7          	jalr	1346(ra) # 800061d8 <uartputc_sync>
    uartputc_sync('\b');
    80005c9e:	4521                	li	a0,8
    80005ca0:	00000097          	auipc	ra,0x0
    80005ca4:	538080e7          	jalr	1336(ra) # 800061d8 <uartputc_sync>
    80005ca8:	bfe1                	j	80005c80 <consputc+0x18>

0000000080005caa <consoleintr>:
// the console input interrupt handler.
// uartintr() calls this for input character.
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void consoleintr(int c) {
    80005caa:	1101                	addi	sp,sp,-32
    80005cac:	ec06                	sd	ra,24(sp)
    80005cae:	e822                	sd	s0,16(sp)
    80005cb0:	e426                	sd	s1,8(sp)
    80005cb2:	e04a                	sd	s2,0(sp)
    80005cb4:	1000                	addi	s0,sp,32
    80005cb6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005cb8:	000a4517          	auipc	a0,0xa4
    80005cbc:	f9850513          	addi	a0,a0,-104 # 800a9c50 <cons>
    80005cc0:	00000097          	auipc	ra,0x0
    80005cc4:	7a4080e7          	jalr	1956(ra) # 80006464 <acquire>

  switch (c) {
    80005cc8:	47d5                	li	a5,21
    80005cca:	0af48663          	beq	s1,a5,80005d76 <consoleintr+0xcc>
    80005cce:	0297ca63          	blt	a5,s1,80005d02 <consoleintr+0x58>
    80005cd2:	47a1                	li	a5,8
    80005cd4:	0ef48763          	beq	s1,a5,80005dc2 <consoleintr+0x118>
    80005cd8:	47c1                	li	a5,16
    80005cda:	10f49a63          	bne	s1,a5,80005dee <consoleintr+0x144>
    case C('P'):  // Print process list.
      procdump();
    80005cde:	ffffc097          	auipc	ra,0xffffc
    80005ce2:	fcc080e7          	jalr	-52(ra) # 80001caa <procdump>
        }
      }
      break;
  }

  release(&cons.lock);
    80005ce6:	000a4517          	auipc	a0,0xa4
    80005cea:	f6a50513          	addi	a0,a0,-150 # 800a9c50 <cons>
    80005cee:	00001097          	auipc	ra,0x1
    80005cf2:	82a080e7          	jalr	-2006(ra) # 80006518 <release>
}
    80005cf6:	60e2                	ld	ra,24(sp)
    80005cf8:	6442                	ld	s0,16(sp)
    80005cfa:	64a2                	ld	s1,8(sp)
    80005cfc:	6902                	ld	s2,0(sp)
    80005cfe:	6105                	addi	sp,sp,32
    80005d00:	8082                	ret
  switch (c) {
    80005d02:	07f00793          	li	a5,127
    80005d06:	0af48e63          	beq	s1,a5,80005dc2 <consoleintr+0x118>
      if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    80005d0a:	000a4717          	auipc	a4,0xa4
    80005d0e:	f4670713          	addi	a4,a4,-186 # 800a9c50 <cons>
    80005d12:	0a072783          	lw	a5,160(a4)
    80005d16:	09872703          	lw	a4,152(a4)
    80005d1a:	9f99                	subw	a5,a5,a4
    80005d1c:	07f00713          	li	a4,127
    80005d20:	fcf763e3          	bltu	a4,a5,80005ce6 <consoleintr+0x3c>
        c = (c == '\r') ? '\n' : c;
    80005d24:	47b5                	li	a5,13
    80005d26:	0cf48763          	beq	s1,a5,80005df4 <consoleintr+0x14a>
        consputc(c);
    80005d2a:	8526                	mv	a0,s1
    80005d2c:	00000097          	auipc	ra,0x0
    80005d30:	f3c080e7          	jalr	-196(ra) # 80005c68 <consputc>
        cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005d34:	000a4797          	auipc	a5,0xa4
    80005d38:	f1c78793          	addi	a5,a5,-228 # 800a9c50 <cons>
    80005d3c:	0a07a683          	lw	a3,160(a5)
    80005d40:	0016871b          	addiw	a4,a3,1
    80005d44:	0007061b          	sext.w	a2,a4
    80005d48:	0ae7a023          	sw	a4,160(a5)
    80005d4c:	07f6f693          	andi	a3,a3,127
    80005d50:	97b6                	add	a5,a5,a3
    80005d52:	00978c23          	sb	s1,24(a5)
        if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80005d56:	47a9                	li	a5,10
    80005d58:	0cf48563          	beq	s1,a5,80005e22 <consoleintr+0x178>
    80005d5c:	4791                	li	a5,4
    80005d5e:	0cf48263          	beq	s1,a5,80005e22 <consoleintr+0x178>
    80005d62:	000a4797          	auipc	a5,0xa4
    80005d66:	f867a783          	lw	a5,-122(a5) # 800a9ce8 <cons+0x98>
    80005d6a:	9f1d                	subw	a4,a4,a5
    80005d6c:	08000793          	li	a5,128
    80005d70:	f6f71be3          	bne	a4,a5,80005ce6 <consoleintr+0x3c>
    80005d74:	a07d                	j	80005e22 <consoleintr+0x178>
      while (cons.e != cons.w &&
    80005d76:	000a4717          	auipc	a4,0xa4
    80005d7a:	eda70713          	addi	a4,a4,-294 # 800a9c50 <cons>
    80005d7e:	0a072783          	lw	a5,160(a4)
    80005d82:	09c72703          	lw	a4,156(a4)
             cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80005d86:	000a4497          	auipc	s1,0xa4
    80005d8a:	eca48493          	addi	s1,s1,-310 # 800a9c50 <cons>
      while (cons.e != cons.w &&
    80005d8e:	4929                	li	s2,10
    80005d90:	f4f70be3          	beq	a4,a5,80005ce6 <consoleintr+0x3c>
             cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80005d94:	37fd                	addiw	a5,a5,-1
    80005d96:	07f7f713          	andi	a4,a5,127
    80005d9a:	9726                	add	a4,a4,s1
      while (cons.e != cons.w &&
    80005d9c:	01874703          	lbu	a4,24(a4)
    80005da0:	f52703e3          	beq	a4,s2,80005ce6 <consoleintr+0x3c>
        cons.e--;
    80005da4:	0af4a023          	sw	a5,160(s1)
        consputc(BACKSPACE);
    80005da8:	10000513          	li	a0,256
    80005dac:	00000097          	auipc	ra,0x0
    80005db0:	ebc080e7          	jalr	-324(ra) # 80005c68 <consputc>
      while (cons.e != cons.w &&
    80005db4:	0a04a783          	lw	a5,160(s1)
    80005db8:	09c4a703          	lw	a4,156(s1)
    80005dbc:	fcf71ce3          	bne	a4,a5,80005d94 <consoleintr+0xea>
    80005dc0:	b71d                	j	80005ce6 <consoleintr+0x3c>
      if (cons.e != cons.w) {
    80005dc2:	000a4717          	auipc	a4,0xa4
    80005dc6:	e8e70713          	addi	a4,a4,-370 # 800a9c50 <cons>
    80005dca:	0a072783          	lw	a5,160(a4)
    80005dce:	09c72703          	lw	a4,156(a4)
    80005dd2:	f0f70ae3          	beq	a4,a5,80005ce6 <consoleintr+0x3c>
        cons.e--;
    80005dd6:	37fd                	addiw	a5,a5,-1
    80005dd8:	000a4717          	auipc	a4,0xa4
    80005ddc:	f0f72c23          	sw	a5,-232(a4) # 800a9cf0 <cons+0xa0>
        consputc(BACKSPACE);
    80005de0:	10000513          	li	a0,256
    80005de4:	00000097          	auipc	ra,0x0
    80005de8:	e84080e7          	jalr	-380(ra) # 80005c68 <consputc>
    80005dec:	bded                	j	80005ce6 <consoleintr+0x3c>
      if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    80005dee:	ee048ce3          	beqz	s1,80005ce6 <consoleintr+0x3c>
    80005df2:	bf21                	j	80005d0a <consoleintr+0x60>
        consputc(c);
    80005df4:	4529                	li	a0,10
    80005df6:	00000097          	auipc	ra,0x0
    80005dfa:	e72080e7          	jalr	-398(ra) # 80005c68 <consputc>
        cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005dfe:	000a4797          	auipc	a5,0xa4
    80005e02:	e5278793          	addi	a5,a5,-430 # 800a9c50 <cons>
    80005e06:	0a07a703          	lw	a4,160(a5)
    80005e0a:	0017069b          	addiw	a3,a4,1
    80005e0e:	0006861b          	sext.w	a2,a3
    80005e12:	0ad7a023          	sw	a3,160(a5)
    80005e16:	07f77713          	andi	a4,a4,127
    80005e1a:	97ba                	add	a5,a5,a4
    80005e1c:	4729                	li	a4,10
    80005e1e:	00e78c23          	sb	a4,24(a5)
          cons.w = cons.e;
    80005e22:	000a4797          	auipc	a5,0xa4
    80005e26:	ecc7a523          	sw	a2,-310(a5) # 800a9cec <cons+0x9c>
          wakeup(&cons.r);
    80005e2a:	000a4517          	auipc	a0,0xa4
    80005e2e:	ebe50513          	addi	a0,a0,-322 # 800a9ce8 <cons+0x98>
    80005e32:	ffffc097          	auipc	ra,0xffffc
    80005e36:	a22080e7          	jalr	-1502(ra) # 80001854 <wakeup>
    80005e3a:	b575                	j	80005ce6 <consoleintr+0x3c>

0000000080005e3c <consoleinit>:

void consoleinit(void) {
    80005e3c:	1141                	addi	sp,sp,-16
    80005e3e:	e406                	sd	ra,8(sp)
    80005e40:	e022                	sd	s0,0(sp)
    80005e42:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005e44:	00003597          	auipc	a1,0x3
    80005e48:	95458593          	addi	a1,a1,-1708 # 80008798 <syscalls+0x3f0>
    80005e4c:	000a4517          	auipc	a0,0xa4
    80005e50:	e0450513          	addi	a0,a0,-508 # 800a9c50 <cons>
    80005e54:	00000097          	auipc	ra,0x0
    80005e58:	580080e7          	jalr	1408(ra) # 800063d4 <initlock>

  uartinit();
    80005e5c:	00000097          	auipc	ra,0x0
    80005e60:	32c080e7          	jalr	812(ra) # 80006188 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005e64:	0009b797          	auipc	a5,0x9b
    80005e68:	b0c78793          	addi	a5,a5,-1268 # 800a0970 <devsw>
    80005e6c:	00000717          	auipc	a4,0x0
    80005e70:	ce470713          	addi	a4,a4,-796 # 80005b50 <consoleread>
    80005e74:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005e76:	00000717          	auipc	a4,0x0
    80005e7a:	c7670713          	addi	a4,a4,-906 # 80005aec <consolewrite>
    80005e7e:	ef98                	sd	a4,24(a5)
}
    80005e80:	60a2                	ld	ra,8(sp)
    80005e82:	6402                	ld	s0,0(sp)
    80005e84:	0141                	addi	sp,sp,16
    80005e86:	8082                	ret

0000000080005e88 <printint>:
  int locking;
} pr;

static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign) {
    80005e88:	7179                	addi	sp,sp,-48
    80005e8a:	f406                	sd	ra,40(sp)
    80005e8c:	f022                	sd	s0,32(sp)
    80005e8e:	ec26                	sd	s1,24(sp)
    80005e90:	e84a                	sd	s2,16(sp)
    80005e92:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if (sign && (sign = xx < 0))
    80005e94:	c219                	beqz	a2,80005e9a <printint+0x12>
    80005e96:	08054763          	bltz	a0,80005f24 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005e9a:	2501                	sext.w	a0,a0
    80005e9c:	4881                	li	a7,0
    80005e9e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005ea2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005ea4:	2581                	sext.w	a1,a1
    80005ea6:	00003617          	auipc	a2,0x3
    80005eaa:	92260613          	addi	a2,a2,-1758 # 800087c8 <digits>
    80005eae:	883a                	mv	a6,a4
    80005eb0:	2705                	addiw	a4,a4,1
    80005eb2:	02b577bb          	remuw	a5,a0,a1
    80005eb6:	1782                	slli	a5,a5,0x20
    80005eb8:	9381                	srli	a5,a5,0x20
    80005eba:	97b2                	add	a5,a5,a2
    80005ebc:	0007c783          	lbu	a5,0(a5)
    80005ec0:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    80005ec4:	0005079b          	sext.w	a5,a0
    80005ec8:	02b5553b          	divuw	a0,a0,a1
    80005ecc:	0685                	addi	a3,a3,1
    80005ece:	feb7f0e3          	bgeu	a5,a1,80005eae <printint+0x26>

  if (sign) buf[i++] = '-';
    80005ed2:	00088c63          	beqz	a7,80005eea <printint+0x62>
    80005ed6:	fe070793          	addi	a5,a4,-32
    80005eda:	00878733          	add	a4,a5,s0
    80005ede:	02d00793          	li	a5,45
    80005ee2:	fef70823          	sb	a5,-16(a4)
    80005ee6:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) consputc(buf[i]);
    80005eea:	02e05763          	blez	a4,80005f18 <printint+0x90>
    80005eee:	fd040793          	addi	a5,s0,-48
    80005ef2:	00e784b3          	add	s1,a5,a4
    80005ef6:	fff78913          	addi	s2,a5,-1
    80005efa:	993a                	add	s2,s2,a4
    80005efc:	377d                	addiw	a4,a4,-1
    80005efe:	1702                	slli	a4,a4,0x20
    80005f00:	9301                	srli	a4,a4,0x20
    80005f02:	40e90933          	sub	s2,s2,a4
    80005f06:	fff4c503          	lbu	a0,-1(s1)
    80005f0a:	00000097          	auipc	ra,0x0
    80005f0e:	d5e080e7          	jalr	-674(ra) # 80005c68 <consputc>
    80005f12:	14fd                	addi	s1,s1,-1
    80005f14:	ff2499e3          	bne	s1,s2,80005f06 <printint+0x7e>
}
    80005f18:	70a2                	ld	ra,40(sp)
    80005f1a:	7402                	ld	s0,32(sp)
    80005f1c:	64e2                	ld	s1,24(sp)
    80005f1e:	6942                	ld	s2,16(sp)
    80005f20:	6145                	addi	sp,sp,48
    80005f22:	8082                	ret
    x = -xx;
    80005f24:	40a0053b          	negw	a0,a0
  if (sign && (sign = xx < 0))
    80005f28:	4885                	li	a7,1
    x = -xx;
    80005f2a:	bf95                	j	80005e9e <printint+0x16>

0000000080005f2c <panic>:
  va_end(ap);

  if (locking) release(&pr.lock);
}

void panic(char *s) {
    80005f2c:	1101                	addi	sp,sp,-32
    80005f2e:	ec06                	sd	ra,24(sp)
    80005f30:	e822                	sd	s0,16(sp)
    80005f32:	e426                	sd	s1,8(sp)
    80005f34:	1000                	addi	s0,sp,32
    80005f36:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005f38:	000a4797          	auipc	a5,0xa4
    80005f3c:	dc07ac23          	sw	zero,-552(a5) # 800a9d10 <pr+0x18>
  printf("panic: ");
    80005f40:	00003517          	auipc	a0,0x3
    80005f44:	86050513          	addi	a0,a0,-1952 # 800087a0 <syscalls+0x3f8>
    80005f48:	00000097          	auipc	ra,0x0
    80005f4c:	02e080e7          	jalr	46(ra) # 80005f76 <printf>
  printf(s);
    80005f50:	8526                	mv	a0,s1
    80005f52:	00000097          	auipc	ra,0x0
    80005f56:	024080e7          	jalr	36(ra) # 80005f76 <printf>
  printf("\n");
    80005f5a:	00002517          	auipc	a0,0x2
    80005f5e:	0ee50513          	addi	a0,a0,238 # 80008048 <etext+0x48>
    80005f62:	00000097          	auipc	ra,0x0
    80005f66:	014080e7          	jalr	20(ra) # 80005f76 <printf>
  panicked = 1;  // freeze uart output from other CPUs
    80005f6a:	4785                	li	a5,1
    80005f6c:	00003717          	auipc	a4,0x3
    80005f70:	94f72023          	sw	a5,-1728(a4) # 800088ac <panicked>
  for (;;)
    80005f74:	a001                	j	80005f74 <panic+0x48>

0000000080005f76 <printf>:
void printf(char *fmt, ...) {
    80005f76:	7131                	addi	sp,sp,-192
    80005f78:	fc86                	sd	ra,120(sp)
    80005f7a:	f8a2                	sd	s0,112(sp)
    80005f7c:	f4a6                	sd	s1,104(sp)
    80005f7e:	f0ca                	sd	s2,96(sp)
    80005f80:	ecce                	sd	s3,88(sp)
    80005f82:	e8d2                	sd	s4,80(sp)
    80005f84:	e4d6                	sd	s5,72(sp)
    80005f86:	e0da                	sd	s6,64(sp)
    80005f88:	fc5e                	sd	s7,56(sp)
    80005f8a:	f862                	sd	s8,48(sp)
    80005f8c:	f466                	sd	s9,40(sp)
    80005f8e:	f06a                	sd	s10,32(sp)
    80005f90:	ec6e                	sd	s11,24(sp)
    80005f92:	0100                	addi	s0,sp,128
    80005f94:	8a2a                	mv	s4,a0
    80005f96:	e40c                	sd	a1,8(s0)
    80005f98:	e810                	sd	a2,16(s0)
    80005f9a:	ec14                	sd	a3,24(s0)
    80005f9c:	f018                	sd	a4,32(s0)
    80005f9e:	f41c                	sd	a5,40(s0)
    80005fa0:	03043823          	sd	a6,48(s0)
    80005fa4:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005fa8:	000a4d97          	auipc	s11,0xa4
    80005fac:	d68dad83          	lw	s11,-664(s11) # 800a9d10 <pr+0x18>
  if (locking) acquire(&pr.lock);
    80005fb0:	020d9b63          	bnez	s11,80005fe6 <printf+0x70>
  if (fmt == 0) panic("null fmt");
    80005fb4:	040a0263          	beqz	s4,80005ff8 <printf+0x82>
  va_start(ap, fmt);
    80005fb8:	00840793          	addi	a5,s0,8
    80005fbc:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80005fc0:	000a4503          	lbu	a0,0(s4)
    80005fc4:	14050f63          	beqz	a0,80006122 <printf+0x1ac>
    80005fc8:	4981                	li	s3,0
    if (c != '%') {
    80005fca:	02500a93          	li	s5,37
    switch (c) {
    80005fce:	07000b93          	li	s7,112
  consputc('x');
    80005fd2:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005fd4:	00002b17          	auipc	s6,0x2
    80005fd8:	7f4b0b13          	addi	s6,s6,2036 # 800087c8 <digits>
    switch (c) {
    80005fdc:	07300c93          	li	s9,115
    80005fe0:	06400c13          	li	s8,100
    80005fe4:	a82d                	j	8000601e <printf+0xa8>
  if (locking) acquire(&pr.lock);
    80005fe6:	000a4517          	auipc	a0,0xa4
    80005fea:	d1250513          	addi	a0,a0,-750 # 800a9cf8 <pr>
    80005fee:	00000097          	auipc	ra,0x0
    80005ff2:	476080e7          	jalr	1142(ra) # 80006464 <acquire>
    80005ff6:	bf7d                	j	80005fb4 <printf+0x3e>
  if (fmt == 0) panic("null fmt");
    80005ff8:	00002517          	auipc	a0,0x2
    80005ffc:	7b850513          	addi	a0,a0,1976 # 800087b0 <syscalls+0x408>
    80006000:	00000097          	auipc	ra,0x0
    80006004:	f2c080e7          	jalr	-212(ra) # 80005f2c <panic>
      consputc(c);
    80006008:	00000097          	auipc	ra,0x0
    8000600c:	c60080e7          	jalr	-928(ra) # 80005c68 <consputc>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80006010:	2985                	addiw	s3,s3,1
    80006012:	013a07b3          	add	a5,s4,s3
    80006016:	0007c503          	lbu	a0,0(a5)
    8000601a:	10050463          	beqz	a0,80006122 <printf+0x1ac>
    if (c != '%') {
    8000601e:	ff5515e3          	bne	a0,s5,80006008 <printf+0x92>
    c = fmt[++i] & 0xff;
    80006022:	2985                	addiw	s3,s3,1
    80006024:	013a07b3          	add	a5,s4,s3
    80006028:	0007c783          	lbu	a5,0(a5)
    8000602c:	0007849b          	sext.w	s1,a5
    if (c == 0) break;
    80006030:	cbed                	beqz	a5,80006122 <printf+0x1ac>
    switch (c) {
    80006032:	05778a63          	beq	a5,s7,80006086 <printf+0x110>
    80006036:	02fbf663          	bgeu	s7,a5,80006062 <printf+0xec>
    8000603a:	09978863          	beq	a5,s9,800060ca <printf+0x154>
    8000603e:	07800713          	li	a4,120
    80006042:	0ce79563          	bne	a5,a4,8000610c <printf+0x196>
        printint(va_arg(ap, int), 16, 1);
    80006046:	f8843783          	ld	a5,-120(s0)
    8000604a:	00878713          	addi	a4,a5,8
    8000604e:	f8e43423          	sd	a4,-120(s0)
    80006052:	4605                	li	a2,1
    80006054:	85ea                	mv	a1,s10
    80006056:	4388                	lw	a0,0(a5)
    80006058:	00000097          	auipc	ra,0x0
    8000605c:	e30080e7          	jalr	-464(ra) # 80005e88 <printint>
        break;
    80006060:	bf45                	j	80006010 <printf+0x9a>
    switch (c) {
    80006062:	09578f63          	beq	a5,s5,80006100 <printf+0x18a>
    80006066:	0b879363          	bne	a5,s8,8000610c <printf+0x196>
        printint(va_arg(ap, int), 10, 1);
    8000606a:	f8843783          	ld	a5,-120(s0)
    8000606e:	00878713          	addi	a4,a5,8
    80006072:	f8e43423          	sd	a4,-120(s0)
    80006076:	4605                	li	a2,1
    80006078:	45a9                	li	a1,10
    8000607a:	4388                	lw	a0,0(a5)
    8000607c:	00000097          	auipc	ra,0x0
    80006080:	e0c080e7          	jalr	-500(ra) # 80005e88 <printint>
        break;
    80006084:	b771                	j	80006010 <printf+0x9a>
        printptr(va_arg(ap, uint64));
    80006086:	f8843783          	ld	a5,-120(s0)
    8000608a:	00878713          	addi	a4,a5,8
    8000608e:	f8e43423          	sd	a4,-120(s0)
    80006092:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006096:	03000513          	li	a0,48
    8000609a:	00000097          	auipc	ra,0x0
    8000609e:	bce080e7          	jalr	-1074(ra) # 80005c68 <consputc>
  consputc('x');
    800060a2:	07800513          	li	a0,120
    800060a6:	00000097          	auipc	ra,0x0
    800060aa:	bc2080e7          	jalr	-1086(ra) # 80005c68 <consputc>
    800060ae:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800060b0:	03c95793          	srli	a5,s2,0x3c
    800060b4:	97da                	add	a5,a5,s6
    800060b6:	0007c503          	lbu	a0,0(a5)
    800060ba:	00000097          	auipc	ra,0x0
    800060be:	bae080e7          	jalr	-1106(ra) # 80005c68 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800060c2:	0912                	slli	s2,s2,0x4
    800060c4:	34fd                	addiw	s1,s1,-1
    800060c6:	f4ed                	bnez	s1,800060b0 <printf+0x13a>
    800060c8:	b7a1                	j	80006010 <printf+0x9a>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    800060ca:	f8843783          	ld	a5,-120(s0)
    800060ce:	00878713          	addi	a4,a5,8
    800060d2:	f8e43423          	sd	a4,-120(s0)
    800060d6:	6384                	ld	s1,0(a5)
    800060d8:	cc89                	beqz	s1,800060f2 <printf+0x17c>
        for (; *s; s++) consputc(*s);
    800060da:	0004c503          	lbu	a0,0(s1)
    800060de:	d90d                	beqz	a0,80006010 <printf+0x9a>
    800060e0:	00000097          	auipc	ra,0x0
    800060e4:	b88080e7          	jalr	-1144(ra) # 80005c68 <consputc>
    800060e8:	0485                	addi	s1,s1,1
    800060ea:	0004c503          	lbu	a0,0(s1)
    800060ee:	f96d                	bnez	a0,800060e0 <printf+0x16a>
    800060f0:	b705                	j	80006010 <printf+0x9a>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    800060f2:	00002497          	auipc	s1,0x2
    800060f6:	6b648493          	addi	s1,s1,1718 # 800087a8 <syscalls+0x400>
        for (; *s; s++) consputc(*s);
    800060fa:	02800513          	li	a0,40
    800060fe:	b7cd                	j	800060e0 <printf+0x16a>
        consputc('%');
    80006100:	8556                	mv	a0,s5
    80006102:	00000097          	auipc	ra,0x0
    80006106:	b66080e7          	jalr	-1178(ra) # 80005c68 <consputc>
        break;
    8000610a:	b719                	j	80006010 <printf+0x9a>
        consputc('%');
    8000610c:	8556                	mv	a0,s5
    8000610e:	00000097          	auipc	ra,0x0
    80006112:	b5a080e7          	jalr	-1190(ra) # 80005c68 <consputc>
        consputc(c);
    80006116:	8526                	mv	a0,s1
    80006118:	00000097          	auipc	ra,0x0
    8000611c:	b50080e7          	jalr	-1200(ra) # 80005c68 <consputc>
        break;
    80006120:	bdc5                	j	80006010 <printf+0x9a>
  if (locking) release(&pr.lock);
    80006122:	020d9163          	bnez	s11,80006144 <printf+0x1ce>
}
    80006126:	70e6                	ld	ra,120(sp)
    80006128:	7446                	ld	s0,112(sp)
    8000612a:	74a6                	ld	s1,104(sp)
    8000612c:	7906                	ld	s2,96(sp)
    8000612e:	69e6                	ld	s3,88(sp)
    80006130:	6a46                	ld	s4,80(sp)
    80006132:	6aa6                	ld	s5,72(sp)
    80006134:	6b06                	ld	s6,64(sp)
    80006136:	7be2                	ld	s7,56(sp)
    80006138:	7c42                	ld	s8,48(sp)
    8000613a:	7ca2                	ld	s9,40(sp)
    8000613c:	7d02                	ld	s10,32(sp)
    8000613e:	6de2                	ld	s11,24(sp)
    80006140:	6129                	addi	sp,sp,192
    80006142:	8082                	ret
  if (locking) release(&pr.lock);
    80006144:	000a4517          	auipc	a0,0xa4
    80006148:	bb450513          	addi	a0,a0,-1100 # 800a9cf8 <pr>
    8000614c:	00000097          	auipc	ra,0x0
    80006150:	3cc080e7          	jalr	972(ra) # 80006518 <release>
}
    80006154:	bfc9                	j	80006126 <printf+0x1b0>

0000000080006156 <printfinit>:
    ;
}

void printfinit(void) {
    80006156:	1101                	addi	sp,sp,-32
    80006158:	ec06                	sd	ra,24(sp)
    8000615a:	e822                	sd	s0,16(sp)
    8000615c:	e426                	sd	s1,8(sp)
    8000615e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006160:	000a4497          	auipc	s1,0xa4
    80006164:	b9848493          	addi	s1,s1,-1128 # 800a9cf8 <pr>
    80006168:	00002597          	auipc	a1,0x2
    8000616c:	65858593          	addi	a1,a1,1624 # 800087c0 <syscalls+0x418>
    80006170:	8526                	mv	a0,s1
    80006172:	00000097          	auipc	ra,0x0
    80006176:	262080e7          	jalr	610(ra) # 800063d4 <initlock>
  pr.locking = 1;
    8000617a:	4785                	li	a5,1
    8000617c:	cc9c                	sw	a5,24(s1)
}
    8000617e:	60e2                	ld	ra,24(sp)
    80006180:	6442                	ld	s0,16(sp)
    80006182:	64a2                	ld	s1,8(sp)
    80006184:	6105                	addi	sp,sp,32
    80006186:	8082                	ret

0000000080006188 <uartinit>:

extern volatile int panicked;  // from printf.c

void uartstart();

void uartinit(void) {
    80006188:	1141                	addi	sp,sp,-16
    8000618a:	e406                	sd	ra,8(sp)
    8000618c:	e022                	sd	s0,0(sp)
    8000618e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006190:	100007b7          	lui	a5,0x10000
    80006194:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006198:	f8000713          	li	a4,-128
    8000619c:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800061a0:	470d                	li	a4,3
    800061a2:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800061a6:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800061aa:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800061ae:	469d                	li	a3,7
    800061b0:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800061b4:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800061b8:	00002597          	auipc	a1,0x2
    800061bc:	62858593          	addi	a1,a1,1576 # 800087e0 <digits+0x18>
    800061c0:	000a4517          	auipc	a0,0xa4
    800061c4:	b5850513          	addi	a0,a0,-1192 # 800a9d18 <uart_tx_lock>
    800061c8:	00000097          	auipc	ra,0x0
    800061cc:	20c080e7          	jalr	524(ra) # 800063d4 <initlock>
}
    800061d0:	60a2                	ld	ra,8(sp)
    800061d2:	6402                	ld	s0,0(sp)
    800061d4:	0141                	addi	sp,sp,16
    800061d6:	8082                	ret

00000000800061d8 <uartputc_sync>:

// alternate version of uartputc() that doesn't
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void uartputc_sync(int c) {
    800061d8:	1101                	addi	sp,sp,-32
    800061da:	ec06                	sd	ra,24(sp)
    800061dc:	e822                	sd	s0,16(sp)
    800061de:	e426                	sd	s1,8(sp)
    800061e0:	1000                	addi	s0,sp,32
    800061e2:	84aa                	mv	s1,a0
  push_off();
    800061e4:	00000097          	auipc	ra,0x0
    800061e8:	234080e7          	jalr	564(ra) # 80006418 <push_off>

  if (panicked) {
    800061ec:	00002797          	auipc	a5,0x2
    800061f0:	6c07a783          	lw	a5,1728(a5) # 800088ac <panicked>
    for (;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800061f4:	10000737          	lui	a4,0x10000
  if (panicked) {
    800061f8:	c391                	beqz	a5,800061fc <uartputc_sync+0x24>
    for (;;)
    800061fa:	a001                	j	800061fa <uartputc_sync+0x22>
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800061fc:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006200:	0207f793          	andi	a5,a5,32
    80006204:	dfe5                	beqz	a5,800061fc <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006206:	0ff4f513          	zext.b	a0,s1
    8000620a:	100007b7          	lui	a5,0x10000
    8000620e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006212:	00000097          	auipc	ra,0x0
    80006216:	2a6080e7          	jalr	678(ra) # 800064b8 <pop_off>
}
    8000621a:	60e2                	ld	ra,24(sp)
    8000621c:	6442                	ld	s0,16(sp)
    8000621e:	64a2                	ld	s1,8(sp)
    80006220:	6105                	addi	sp,sp,32
    80006222:	8082                	ret

0000000080006224 <uartstart>:
// in the transmit buffer, send it.
// caller must hold uart_tx_lock.
// called from both the top- and bottom-half.
void uartstart() {
  while (1) {
    if (uart_tx_w == uart_tx_r) {
    80006224:	00002797          	auipc	a5,0x2
    80006228:	68c7b783          	ld	a5,1676(a5) # 800088b0 <uart_tx_r>
    8000622c:	00002717          	auipc	a4,0x2
    80006230:	68c73703          	ld	a4,1676(a4) # 800088b8 <uart_tx_w>
    80006234:	06f70a63          	beq	a4,a5,800062a8 <uartstart+0x84>
void uartstart() {
    80006238:	7139                	addi	sp,sp,-64
    8000623a:	fc06                	sd	ra,56(sp)
    8000623c:	f822                	sd	s0,48(sp)
    8000623e:	f426                	sd	s1,40(sp)
    80006240:	f04a                	sd	s2,32(sp)
    80006242:	ec4e                	sd	s3,24(sp)
    80006244:	e852                	sd	s4,16(sp)
    80006246:	e456                	sd	s5,8(sp)
    80006248:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }

    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0) {
    8000624a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }

    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000624e:	000a4a17          	auipc	s4,0xa4
    80006252:	acaa0a13          	addi	s4,s4,-1334 # 800a9d18 <uart_tx_lock>
    uart_tx_r += 1;
    80006256:	00002497          	auipc	s1,0x2
    8000625a:	65a48493          	addi	s1,s1,1626 # 800088b0 <uart_tx_r>
    if (uart_tx_w == uart_tx_r) {
    8000625e:	00002997          	auipc	s3,0x2
    80006262:	65a98993          	addi	s3,s3,1626 # 800088b8 <uart_tx_w>
    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0) {
    80006266:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000626a:	02077713          	andi	a4,a4,32
    8000626e:	c705                	beqz	a4,80006296 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006270:	01f7f713          	andi	a4,a5,31
    80006274:	9752                	add	a4,a4,s4
    80006276:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000627a:	0785                	addi	a5,a5,1
    8000627c:	e09c                	sd	a5,0(s1)

    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000627e:	8526                	mv	a0,s1
    80006280:	ffffb097          	auipc	ra,0xffffb
    80006284:	5d4080e7          	jalr	1492(ra) # 80001854 <wakeup>

    WriteReg(THR, c);
    80006288:	01590023          	sb	s5,0(s2)
    if (uart_tx_w == uart_tx_r) {
    8000628c:	609c                	ld	a5,0(s1)
    8000628e:	0009b703          	ld	a4,0(s3)
    80006292:	fcf71ae3          	bne	a4,a5,80006266 <uartstart+0x42>
  }
}
    80006296:	70e2                	ld	ra,56(sp)
    80006298:	7442                	ld	s0,48(sp)
    8000629a:	74a2                	ld	s1,40(sp)
    8000629c:	7902                	ld	s2,32(sp)
    8000629e:	69e2                	ld	s3,24(sp)
    800062a0:	6a42                	ld	s4,16(sp)
    800062a2:	6aa2                	ld	s5,8(sp)
    800062a4:	6121                	addi	sp,sp,64
    800062a6:	8082                	ret
    800062a8:	8082                	ret

00000000800062aa <uartputc>:
void uartputc(int c) {
    800062aa:	7179                	addi	sp,sp,-48
    800062ac:	f406                	sd	ra,40(sp)
    800062ae:	f022                	sd	s0,32(sp)
    800062b0:	ec26                	sd	s1,24(sp)
    800062b2:	e84a                	sd	s2,16(sp)
    800062b4:	e44e                	sd	s3,8(sp)
    800062b6:	e052                	sd	s4,0(sp)
    800062b8:	1800                	addi	s0,sp,48
    800062ba:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800062bc:	000a4517          	auipc	a0,0xa4
    800062c0:	a5c50513          	addi	a0,a0,-1444 # 800a9d18 <uart_tx_lock>
    800062c4:	00000097          	auipc	ra,0x0
    800062c8:	1a0080e7          	jalr	416(ra) # 80006464 <acquire>
  if (panicked) {
    800062cc:	00002797          	auipc	a5,0x2
    800062d0:	5e07a783          	lw	a5,1504(a5) # 800088ac <panicked>
    800062d4:	e7c9                	bnez	a5,8000635e <uartputc+0xb4>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    800062d6:	00002717          	auipc	a4,0x2
    800062da:	5e273703          	ld	a4,1506(a4) # 800088b8 <uart_tx_w>
    800062de:	00002797          	auipc	a5,0x2
    800062e2:	5d27b783          	ld	a5,1490(a5) # 800088b0 <uart_tx_r>
    800062e6:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800062ea:	000a4997          	auipc	s3,0xa4
    800062ee:	a2e98993          	addi	s3,s3,-1490 # 800a9d18 <uart_tx_lock>
    800062f2:	00002497          	auipc	s1,0x2
    800062f6:	5be48493          	addi	s1,s1,1470 # 800088b0 <uart_tx_r>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    800062fa:	00002917          	auipc	s2,0x2
    800062fe:	5be90913          	addi	s2,s2,1470 # 800088b8 <uart_tx_w>
    80006302:	00e79f63          	bne	a5,a4,80006320 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006306:	85ce                	mv	a1,s3
    80006308:	8526                	mv	a0,s1
    8000630a:	ffffb097          	auipc	ra,0xffffb
    8000630e:	4e6080e7          	jalr	1254(ra) # 800017f0 <sleep>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    80006312:	00093703          	ld	a4,0(s2)
    80006316:	609c                	ld	a5,0(s1)
    80006318:	02078793          	addi	a5,a5,32
    8000631c:	fee785e3          	beq	a5,a4,80006306 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006320:	000a4497          	auipc	s1,0xa4
    80006324:	9f848493          	addi	s1,s1,-1544 # 800a9d18 <uart_tx_lock>
    80006328:	01f77793          	andi	a5,a4,31
    8000632c:	97a6                	add	a5,a5,s1
    8000632e:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006332:	0705                	addi	a4,a4,1
    80006334:	00002797          	auipc	a5,0x2
    80006338:	58e7b223          	sd	a4,1412(a5) # 800088b8 <uart_tx_w>
  uartstart();
    8000633c:	00000097          	auipc	ra,0x0
    80006340:	ee8080e7          	jalr	-280(ra) # 80006224 <uartstart>
  release(&uart_tx_lock);
    80006344:	8526                	mv	a0,s1
    80006346:	00000097          	auipc	ra,0x0
    8000634a:	1d2080e7          	jalr	466(ra) # 80006518 <release>
}
    8000634e:	70a2                	ld	ra,40(sp)
    80006350:	7402                	ld	s0,32(sp)
    80006352:	64e2                	ld	s1,24(sp)
    80006354:	6942                	ld	s2,16(sp)
    80006356:	69a2                	ld	s3,8(sp)
    80006358:	6a02                	ld	s4,0(sp)
    8000635a:	6145                	addi	sp,sp,48
    8000635c:	8082                	ret
    for (;;)
    8000635e:	a001                	j	8000635e <uartputc+0xb4>

0000000080006360 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int uartgetc(void) {
    80006360:	1141                	addi	sp,sp,-16
    80006362:	e422                	sd	s0,8(sp)
    80006364:	0800                	addi	s0,sp,16
  if (ReadReg(LSR) & 0x01) {
    80006366:	100007b7          	lui	a5,0x10000
    8000636a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000636e:	8b85                	andi	a5,a5,1
    80006370:	cb81                	beqz	a5,80006380 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006372:	100007b7          	lui	a5,0x10000
    80006376:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000637a:	6422                	ld	s0,8(sp)
    8000637c:	0141                	addi	sp,sp,16
    8000637e:	8082                	ret
    return -1;
    80006380:	557d                	li	a0,-1
    80006382:	bfe5                	j	8000637a <uartgetc+0x1a>

0000000080006384 <uartintr>:

// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void uartintr(void) {
    80006384:	1101                	addi	sp,sp,-32
    80006386:	ec06                	sd	ra,24(sp)
    80006388:	e822                	sd	s0,16(sp)
    8000638a:	e426                	sd	s1,8(sp)
    8000638c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while (1) {
    int c = uartgetc();
    if (c == -1) break;
    8000638e:	54fd                	li	s1,-1
    80006390:	a029                	j	8000639a <uartintr+0x16>
    consoleintr(c);
    80006392:	00000097          	auipc	ra,0x0
    80006396:	918080e7          	jalr	-1768(ra) # 80005caa <consoleintr>
    int c = uartgetc();
    8000639a:	00000097          	auipc	ra,0x0
    8000639e:	fc6080e7          	jalr	-58(ra) # 80006360 <uartgetc>
    if (c == -1) break;
    800063a2:	fe9518e3          	bne	a0,s1,80006392 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800063a6:	000a4497          	auipc	s1,0xa4
    800063aa:	97248493          	addi	s1,s1,-1678 # 800a9d18 <uart_tx_lock>
    800063ae:	8526                	mv	a0,s1
    800063b0:	00000097          	auipc	ra,0x0
    800063b4:	0b4080e7          	jalr	180(ra) # 80006464 <acquire>
  uartstart();
    800063b8:	00000097          	auipc	ra,0x0
    800063bc:	e6c080e7          	jalr	-404(ra) # 80006224 <uartstart>
  release(&uart_tx_lock);
    800063c0:	8526                	mv	a0,s1
    800063c2:	00000097          	auipc	ra,0x0
    800063c6:	156080e7          	jalr	342(ra) # 80006518 <release>
}
    800063ca:	60e2                	ld	ra,24(sp)
    800063cc:	6442                	ld	s0,16(sp)
    800063ce:	64a2                	ld	s1,8(sp)
    800063d0:	6105                	addi	sp,sp,32
    800063d2:	8082                	ret

00000000800063d4 <initlock>:
#include "spinlock.h"
#include "riscv.h"
#include "proc.h"
#include "defs.h"

void initlock(struct spinlock *lk, char *name) {
    800063d4:	1141                	addi	sp,sp,-16
    800063d6:	e422                	sd	s0,8(sp)
    800063d8:	0800                	addi	s0,sp,16
  lk->name = name;
    800063da:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800063dc:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800063e0:	00053823          	sd	zero,16(a0)
}
    800063e4:	6422                	ld	s0,8(sp)
    800063e6:	0141                	addi	sp,sp,16
    800063e8:	8082                	ret

00000000800063ea <holding>:

// Check whether this cpu is holding the lock.
// Interrupts must be off.
int holding(struct spinlock *lk) {
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800063ea:	411c                	lw	a5,0(a0)
    800063ec:	e399                	bnez	a5,800063f2 <holding+0x8>
    800063ee:	4501                	li	a0,0
  return r;
}
    800063f0:	8082                	ret
int holding(struct spinlock *lk) {
    800063f2:	1101                	addi	sp,sp,-32
    800063f4:	ec06                	sd	ra,24(sp)
    800063f6:	e822                	sd	s0,16(sp)
    800063f8:	e426                	sd	s1,8(sp)
    800063fa:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800063fc:	6904                	ld	s1,16(a0)
    800063fe:	ffffb097          	auipc	ra,0xffffb
    80006402:	d2e080e7          	jalr	-722(ra) # 8000112c <mycpu>
    80006406:	40a48533          	sub	a0,s1,a0
    8000640a:	00153513          	seqz	a0,a0
}
    8000640e:	60e2                	ld	ra,24(sp)
    80006410:	6442                	ld	s0,16(sp)
    80006412:	64a2                	ld	s1,8(sp)
    80006414:	6105                	addi	sp,sp,32
    80006416:	8082                	ret

0000000080006418 <push_off>:

// push_off/pop_off are like intr_off()/intr_on() except that they are matched:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void push_off(void) {
    80006418:	1101                	addi	sp,sp,-32
    8000641a:	ec06                	sd	ra,24(sp)
    8000641c:	e822                	sd	s0,16(sp)
    8000641e:	e426                	sd	s1,8(sp)
    80006420:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80006422:	100024f3          	csrr	s1,sstatus
    80006426:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    8000642a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000642c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if (mycpu()->noff == 0) mycpu()->intena = old;
    80006430:	ffffb097          	auipc	ra,0xffffb
    80006434:	cfc080e7          	jalr	-772(ra) # 8000112c <mycpu>
    80006438:	5d3c                	lw	a5,120(a0)
    8000643a:	cf89                	beqz	a5,80006454 <push_off+0x3c>
  mycpu()->noff += 1;
    8000643c:	ffffb097          	auipc	ra,0xffffb
    80006440:	cf0080e7          	jalr	-784(ra) # 8000112c <mycpu>
    80006444:	5d3c                	lw	a5,120(a0)
    80006446:	2785                	addiw	a5,a5,1
    80006448:	dd3c                	sw	a5,120(a0)
}
    8000644a:	60e2                	ld	ra,24(sp)
    8000644c:	6442                	ld	s0,16(sp)
    8000644e:	64a2                	ld	s1,8(sp)
    80006450:	6105                	addi	sp,sp,32
    80006452:	8082                	ret
  if (mycpu()->noff == 0) mycpu()->intena = old;
    80006454:	ffffb097          	auipc	ra,0xffffb
    80006458:	cd8080e7          	jalr	-808(ra) # 8000112c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000645c:	8085                	srli	s1,s1,0x1
    8000645e:	8885                	andi	s1,s1,1
    80006460:	dd64                	sw	s1,124(a0)
    80006462:	bfe9                	j	8000643c <push_off+0x24>

0000000080006464 <acquire>:
void acquire(struct spinlock *lk) {
    80006464:	1101                	addi	sp,sp,-32
    80006466:	ec06                	sd	ra,24(sp)
    80006468:	e822                	sd	s0,16(sp)
    8000646a:	e426                	sd	s1,8(sp)
    8000646c:	1000                	addi	s0,sp,32
    8000646e:	84aa                	mv	s1,a0
  push_off();  // disable interrupts to avoid deadlock.
    80006470:	00000097          	auipc	ra,0x0
    80006474:	fa8080e7          	jalr	-88(ra) # 80006418 <push_off>
  if (holding(lk)) panic("acquire");
    80006478:	8526                	mv	a0,s1
    8000647a:	00000097          	auipc	ra,0x0
    8000647e:	f70080e7          	jalr	-144(ra) # 800063ea <holding>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006482:	4705                	li	a4,1
  if (holding(lk)) panic("acquire");
    80006484:	e115                	bnez	a0,800064a8 <acquire+0x44>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006486:	87ba                	mv	a5,a4
    80006488:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000648c:	2781                	sext.w	a5,a5
    8000648e:	ffe5                	bnez	a5,80006486 <acquire+0x22>
  __sync_synchronize();
    80006490:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006494:	ffffb097          	auipc	ra,0xffffb
    80006498:	c98080e7          	jalr	-872(ra) # 8000112c <mycpu>
    8000649c:	e888                	sd	a0,16(s1)
}
    8000649e:	60e2                	ld	ra,24(sp)
    800064a0:	6442                	ld	s0,16(sp)
    800064a2:	64a2                	ld	s1,8(sp)
    800064a4:	6105                	addi	sp,sp,32
    800064a6:	8082                	ret
  if (holding(lk)) panic("acquire");
    800064a8:	00002517          	auipc	a0,0x2
    800064ac:	34050513          	addi	a0,a0,832 # 800087e8 <digits+0x20>
    800064b0:	00000097          	auipc	ra,0x0
    800064b4:	a7c080e7          	jalr	-1412(ra) # 80005f2c <panic>

00000000800064b8 <pop_off>:

void pop_off(void) {
    800064b8:	1141                	addi	sp,sp,-16
    800064ba:	e406                	sd	ra,8(sp)
    800064bc:	e022                	sd	s0,0(sp)
    800064be:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800064c0:	ffffb097          	auipc	ra,0xffffb
    800064c4:	c6c080e7          	jalr	-916(ra) # 8000112c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800064c8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800064cc:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("pop_off - interruptible");
    800064ce:	e78d                	bnez	a5,800064f8 <pop_off+0x40>
  if (c->noff < 1) panic("pop_off");
    800064d0:	5d3c                	lw	a5,120(a0)
    800064d2:	02f05b63          	blez	a5,80006508 <pop_off+0x50>
  c->noff -= 1;
    800064d6:	37fd                	addiw	a5,a5,-1
    800064d8:	0007871b          	sext.w	a4,a5
    800064dc:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena) intr_on();
    800064de:	eb09                	bnez	a4,800064f0 <pop_off+0x38>
    800064e0:	5d7c                	lw	a5,124(a0)
    800064e2:	c799                	beqz	a5,800064f0 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800064e4:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    800064e8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800064ec:	10079073          	csrw	sstatus,a5
}
    800064f0:	60a2                	ld	ra,8(sp)
    800064f2:	6402                	ld	s0,0(sp)
    800064f4:	0141                	addi	sp,sp,16
    800064f6:	8082                	ret
  if (intr_get()) panic("pop_off - interruptible");
    800064f8:	00002517          	auipc	a0,0x2
    800064fc:	2f850513          	addi	a0,a0,760 # 800087f0 <digits+0x28>
    80006500:	00000097          	auipc	ra,0x0
    80006504:	a2c080e7          	jalr	-1492(ra) # 80005f2c <panic>
  if (c->noff < 1) panic("pop_off");
    80006508:	00002517          	auipc	a0,0x2
    8000650c:	30050513          	addi	a0,a0,768 # 80008808 <digits+0x40>
    80006510:	00000097          	auipc	ra,0x0
    80006514:	a1c080e7          	jalr	-1508(ra) # 80005f2c <panic>

0000000080006518 <release>:
void release(struct spinlock *lk) {
    80006518:	1101                	addi	sp,sp,-32
    8000651a:	ec06                	sd	ra,24(sp)
    8000651c:	e822                	sd	s0,16(sp)
    8000651e:	e426                	sd	s1,8(sp)
    80006520:	1000                	addi	s0,sp,32
    80006522:	84aa                	mv	s1,a0
  if (!holding(lk)) panic("release");
    80006524:	00000097          	auipc	ra,0x0
    80006528:	ec6080e7          	jalr	-314(ra) # 800063ea <holding>
    8000652c:	c115                	beqz	a0,80006550 <release+0x38>
  lk->cpu = 0;
    8000652e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006532:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006536:	0f50000f          	fence	iorw,ow
    8000653a:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000653e:	00000097          	auipc	ra,0x0
    80006542:	f7a080e7          	jalr	-134(ra) # 800064b8 <pop_off>
}
    80006546:	60e2                	ld	ra,24(sp)
    80006548:	6442                	ld	s0,16(sp)
    8000654a:	64a2                	ld	s1,8(sp)
    8000654c:	6105                	addi	sp,sp,32
    8000654e:	8082                	ret
  if (!holding(lk)) panic("release");
    80006550:	00002517          	auipc	a0,0x2
    80006554:	2c050513          	addi	a0,a0,704 # 80008810 <digits+0x48>
    80006558:	00000097          	auipc	ra,0x0
    8000655c:	9d4080e7          	jalr	-1580(ra) # 80005f2c <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
