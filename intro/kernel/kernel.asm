
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8b013103          	ld	sp,-1872(sp) # 800088b0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	003050ef          	jal	ra,80005818 <start>

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
    80000030:	00022797          	auipc	a5,0x22
    80000034:	d4078793          	addi	a5,a5,-704 # 80021d70 <end>
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
    80000054:	8b090913          	addi	s2,s2,-1872 # 80008900 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	1aa080e7          	jalr	426(ra) # 80006204 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	24a080e7          	jalr	586(ra) # 800062b8 <release>
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
    8000008e:	c42080e7          	jalr	-958(ra) # 80005ccc <panic>

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
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	81250513          	addi	a0,a0,-2030 # 80008900 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	07e080e7          	jalr	126(ra) # 80006174 <initlock>
  freerange(end, (void *)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	c6e50513          	addi	a0,a0,-914 # 80021d70 <end>
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
    80000128:	7dc48493          	addi	s1,s1,2012 # 80008900 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	0d6080e7          	jalr	214(ra) # 80006204 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if (r) kmem.freelist = r->next;
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00008517          	auipc	a0,0x8
    80000140:	7c450513          	addi	a0,a0,1988 # 80008900 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	172080e7          	jalr	370(ra) # 800062b8 <release>

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
    8000016c:	79850513          	addi	a0,a0,1944 # 80008900 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	148080e7          	jalr	328(ra) # 800062b8 <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd291>
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
    8000032c:	b00080e7          	jalr	-1280(ra) # 80000e28 <cpuid>
    virtio_disk_init();  // emulated hard disk
    userinit();          // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while (started == 0)
    80000330:	00008717          	auipc	a4,0x8
    80000334:	5a070713          	addi	a4,a4,1440 # 800088d0 <started>
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
    80000348:	ae4080e7          	jalr	-1308(ra) # 80000e28 <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	9c0080e7          	jalr	-1600(ra) # 80005d16 <printf>
    kvminithart();   // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();  // install kernel trap vector
    80000366:	00002097          	auipc	ra,0x2
    8000036a:	86c080e7          	jalr	-1940(ra) # 80001bd2 <trapinithart>
    plicinithart();  // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	e62080e7          	jalr	-414(ra) # 800051d0 <plicinithart>
  }

  scheduler();
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	fd4080e7          	jalr	-44(ra) # 8000134a <scheduler>
    consoleinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	85e080e7          	jalr	-1954(ra) # 80005bdc <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	b70080e7          	jalr	-1168(ra) # 80005ef6 <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	e9250513          	addi	a0,a0,-366 # 80008220 <etext+0x220>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	980080e7          	jalr	-1664(ra) # 80005d16 <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	970080e7          	jalr	-1680(ra) # 80005d16 <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	e7250513          	addi	a0,a0,-398 # 80008220 <etext+0x220>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	960080e7          	jalr	-1696(ra) # 80005d16 <printf>
    kinit();             // physical page allocator
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	d20080e7          	jalr	-736(ra) # 800000de <kinit>
    kvminit();           // create kernel page table
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	326080e7          	jalr	806(ra) # 800006ec <kvminit>
    kvminithart();       // turn on paging
    800003ce:	00000097          	auipc	ra,0x0
    800003d2:	068080e7          	jalr	104(ra) # 80000436 <kvminithart>
    procinit();          // process table
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	99e080e7          	jalr	-1634(ra) # 80000d74 <procinit>
    trapinit();          // trap vectors
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	7cc080e7          	jalr	1996(ra) # 80001baa <trapinit>
    trapinithart();      // install kernel trap vector
    800003e6:	00001097          	auipc	ra,0x1
    800003ea:	7ec080e7          	jalr	2028(ra) # 80001bd2 <trapinithart>
    plicinit();          // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	dcc080e7          	jalr	-564(ra) # 800051ba <plicinit>
    plicinithart();      // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	dda080e7          	jalr	-550(ra) # 800051d0 <plicinithart>
    binit();             // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	f78080e7          	jalr	-136(ra) # 80002376 <binit>
    iinit();             // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	618080e7          	jalr	1560(ra) # 80002a1e <iinit>
    fileinit();          // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	5be080e7          	jalr	1470(ra) # 800039cc <fileinit>
    virtio_disk_init();  // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	ec2080e7          	jalr	-318(ra) # 800052d8 <virtio_disk_init>
    userinit();          // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	d0e080e7          	jalr	-754(ra) # 8000112c <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00008717          	auipc	a4,0x8
    80000430:	4af72223          	sw	a5,1188(a4) # 800088d0 <started>
    80000434:	b789                	j	80000376 <main+0x56>

0000000080000436 <kvminithart>:
// Initialize the one kernel_pagetable
void kvminit(void) { kernel_pagetable = kvmmake(); }

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart() {
    80000436:	1141                	addi	sp,sp,-16
    80000438:	e422                	sd	s0,8(sp)
    8000043a:	0800                	addi	s0,sp,16
}

// flush the TLB.
static inline void sfence_vma() {
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000043c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000440:	00008797          	auipc	a5,0x8
    80000444:	4987b783          	ld	a5,1176(a5) # 800088d8 <kernel_pagetable>
    80000448:	83b1                	srli	a5,a5,0xc
    8000044a:	577d                	li	a4,-1
    8000044c:	177e                	slli	a4,a4,0x3f
    8000044e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80000450:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000454:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000458:	6422                	ld	s0,8(sp)
    8000045a:	0141                	addi	sp,sp,16
    8000045c:	8082                	ret

000000008000045e <walk>:
//   39..63 -- must be zero.
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    8000045e:	7139                	addi	sp,sp,-64
    80000460:	fc06                	sd	ra,56(sp)
    80000462:	f822                	sd	s0,48(sp)
    80000464:	f426                	sd	s1,40(sp)
    80000466:	f04a                	sd	s2,32(sp)
    80000468:	ec4e                	sd	s3,24(sp)
    8000046a:	e852                	sd	s4,16(sp)
    8000046c:	e456                	sd	s5,8(sp)
    8000046e:	e05a                	sd	s6,0(sp)
    80000470:	0080                	addi	s0,sp,64
    80000472:	84aa                	mv	s1,a0
    80000474:	89ae                	mv	s3,a1
    80000476:	8ab2                	mv	s5,a2
  if (va >= MAXVA) panic("walk");
    80000478:	57fd                	li	a5,-1
    8000047a:	83e9                	srli	a5,a5,0x1a
    8000047c:	4a79                	li	s4,30

  for (int level = 2; level > 0; level--) {
    8000047e:	4b31                	li	s6,12
  if (va >= MAXVA) panic("walk");
    80000480:	04b7f263          	bgeu	a5,a1,800004c4 <walk+0x66>
    80000484:	00008517          	auipc	a0,0x8
    80000488:	bcc50513          	addi	a0,a0,-1076 # 80008050 <etext+0x50>
    8000048c:	00006097          	auipc	ra,0x6
    80000490:	840080e7          	jalr	-1984(ra) # 80005ccc <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0) return 0;
    80000494:	060a8663          	beqz	s5,80000500 <walk+0xa2>
    80000498:	00000097          	auipc	ra,0x0
    8000049c:	c82080e7          	jalr	-894(ra) # 8000011a <kalloc>
    800004a0:	84aa                	mv	s1,a0
    800004a2:	c529                	beqz	a0,800004ec <walk+0x8e>
      memset(pagetable, 0, PGSIZE);
    800004a4:	6605                	lui	a2,0x1
    800004a6:	4581                	li	a1,0
    800004a8:	00000097          	auipc	ra,0x0
    800004ac:	cd2080e7          	jalr	-814(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b0:	00c4d793          	srli	a5,s1,0xc
    800004b4:	07aa                	slli	a5,a5,0xa
    800004b6:	0017e793          	ori	a5,a5,1
    800004ba:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    800004be:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd287>
    800004c0:	036a0063          	beq	s4,s6,800004e0 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c4:	0149d933          	srl	s2,s3,s4
    800004c8:	1ff97913          	andi	s2,s2,511
    800004cc:	090e                	slli	s2,s2,0x3
    800004ce:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    800004d0:	00093483          	ld	s1,0(s2)
    800004d4:	0014f793          	andi	a5,s1,1
    800004d8:	dfd5                	beqz	a5,80000494 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004da:	80a9                	srli	s1,s1,0xa
    800004dc:	04b2                	slli	s1,s1,0xc
    800004de:	b7c5                	j	800004be <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e0:	00c9d513          	srli	a0,s3,0xc
    800004e4:	1ff57513          	andi	a0,a0,511
    800004e8:	050e                	slli	a0,a0,0x3
    800004ea:	9526                	add	a0,a0,s1
}
    800004ec:	70e2                	ld	ra,56(sp)
    800004ee:	7442                	ld	s0,48(sp)
    800004f0:	74a2                	ld	s1,40(sp)
    800004f2:	7902                	ld	s2,32(sp)
    800004f4:	69e2                	ld	s3,24(sp)
    800004f6:	6a42                	ld	s4,16(sp)
    800004f8:	6aa2                	ld	s5,8(sp)
    800004fa:	6b02                	ld	s6,0(sp)
    800004fc:	6121                	addi	sp,sp,64
    800004fe:	8082                	ret
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0) return 0;
    80000500:	4501                	li	a0,0
    80000502:	b7ed                	j	800004ec <walk+0x8e>

0000000080000504 <walkaddr>:
// Can only be used to look up user pages.
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA) return 0;
    80000504:	57fd                	li	a5,-1
    80000506:	83e9                	srli	a5,a5,0x1a
    80000508:	00b7f463          	bgeu	a5,a1,80000510 <walkaddr+0xc>
    8000050c:	4501                	li	a0,0
  if (pte == 0) return 0;
  if ((*pte & PTE_V) == 0) return 0;
  if ((*pte & PTE_U) == 0) return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050e:	8082                	ret
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    80000510:	1141                	addi	sp,sp,-16
    80000512:	e406                	sd	ra,8(sp)
    80000514:	e022                	sd	s0,0(sp)
    80000516:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000518:	4601                	li	a2,0
    8000051a:	00000097          	auipc	ra,0x0
    8000051e:	f44080e7          	jalr	-188(ra) # 8000045e <walk>
  if (pte == 0) return 0;
    80000522:	c105                	beqz	a0,80000542 <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0) return 0;
    80000524:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0) return 0;
    80000526:	0117f693          	andi	a3,a5,17
    8000052a:	4745                	li	a4,17
    8000052c:	4501                	li	a0,0
    8000052e:	00e68663          	beq	a3,a4,8000053a <walkaddr+0x36>
}
    80000532:	60a2                	ld	ra,8(sp)
    80000534:	6402                	ld	s0,0(sp)
    80000536:	0141                	addi	sp,sp,16
    80000538:	8082                	ret
  pa = PTE2PA(*pte);
    8000053a:	83a9                	srli	a5,a5,0xa
    8000053c:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000540:	bfcd                	j	80000532 <walkaddr+0x2e>
  if (pte == 0) return 0;
    80000542:	4501                	li	a0,0
    80000544:	b7fd                	j	80000532 <walkaddr+0x2e>

0000000080000546 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa,
             int perm) {
    80000546:	715d                	addi	sp,sp,-80
    80000548:	e486                	sd	ra,72(sp)
    8000054a:	e0a2                	sd	s0,64(sp)
    8000054c:	fc26                	sd	s1,56(sp)
    8000054e:	f84a                	sd	s2,48(sp)
    80000550:	f44e                	sd	s3,40(sp)
    80000552:	f052                	sd	s4,32(sp)
    80000554:	ec56                	sd	s5,24(sp)
    80000556:	e85a                	sd	s6,16(sp)
    80000558:	e45e                	sd	s7,8(sp)
    8000055a:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if (size == 0) panic("mappages: size");
    8000055c:	c639                	beqz	a2,800005aa <mappages+0x64>
    8000055e:	8aaa                	mv	s5,a0
    80000560:	8b3a                	mv	s6,a4

  a = PGROUNDDOWN(va);
    80000562:	777d                	lui	a4,0xfffff
    80000564:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000568:	fff58993          	addi	s3,a1,-1
    8000056c:	99b2                	add	s3,s3,a2
    8000056e:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000572:	893e                	mv	s2,a5
    80000574:	40f68a33          	sub	s4,a3,a5
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    if (*pte & PTE_V) panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last) break;
    a += PGSIZE;
    80000578:	6b85                	lui	s7,0x1
    8000057a:	012a04b3          	add	s1,s4,s2
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    8000057e:	4605                	li	a2,1
    80000580:	85ca                	mv	a1,s2
    80000582:	8556                	mv	a0,s5
    80000584:	00000097          	auipc	ra,0x0
    80000588:	eda080e7          	jalr	-294(ra) # 8000045e <walk>
    8000058c:	cd1d                	beqz	a0,800005ca <mappages+0x84>
    if (*pte & PTE_V) panic("mappages: remap");
    8000058e:	611c                	ld	a5,0(a0)
    80000590:	8b85                	andi	a5,a5,1
    80000592:	e785                	bnez	a5,800005ba <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000594:	80b1                	srli	s1,s1,0xc
    80000596:	04aa                	slli	s1,s1,0xa
    80000598:	0164e4b3          	or	s1,s1,s6
    8000059c:	0014e493          	ori	s1,s1,1
    800005a0:	e104                	sd	s1,0(a0)
    if (a == last) break;
    800005a2:	05390063          	beq	s2,s3,800005e2 <mappages+0x9c>
    a += PGSIZE;
    800005a6:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    800005a8:	bfc9                	j	8000057a <mappages+0x34>
  if (size == 0) panic("mappages: size");
    800005aa:	00008517          	auipc	a0,0x8
    800005ae:	aae50513          	addi	a0,a0,-1362 # 80008058 <etext+0x58>
    800005b2:	00005097          	auipc	ra,0x5
    800005b6:	71a080e7          	jalr	1818(ra) # 80005ccc <panic>
    if (*pte & PTE_V) panic("mappages: remap");
    800005ba:	00008517          	auipc	a0,0x8
    800005be:	aae50513          	addi	a0,a0,-1362 # 80008068 <etext+0x68>
    800005c2:	00005097          	auipc	ra,0x5
    800005c6:	70a080e7          	jalr	1802(ra) # 80005ccc <panic>
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    800005ca:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005cc:	60a6                	ld	ra,72(sp)
    800005ce:	6406                	ld	s0,64(sp)
    800005d0:	74e2                	ld	s1,56(sp)
    800005d2:	7942                	ld	s2,48(sp)
    800005d4:	79a2                	ld	s3,40(sp)
    800005d6:	7a02                	ld	s4,32(sp)
    800005d8:	6ae2                	ld	s5,24(sp)
    800005da:	6b42                	ld	s6,16(sp)
    800005dc:	6ba2                	ld	s7,8(sp)
    800005de:	6161                	addi	sp,sp,80
    800005e0:	8082                	ret
  return 0;
    800005e2:	4501                	li	a0,0
    800005e4:	b7e5                	j	800005cc <mappages+0x86>

00000000800005e6 <kvmmap>:
void kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm) {
    800005e6:	1141                	addi	sp,sp,-16
    800005e8:	e406                	sd	ra,8(sp)
    800005ea:	e022                	sd	s0,0(sp)
    800005ec:	0800                	addi	s0,sp,16
    800005ee:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0) panic("kvmmap");
    800005f0:	86b2                	mv	a3,a2
    800005f2:	863e                	mv	a2,a5
    800005f4:	00000097          	auipc	ra,0x0
    800005f8:	f52080e7          	jalr	-174(ra) # 80000546 <mappages>
    800005fc:	e509                	bnez	a0,80000606 <kvmmap+0x20>
}
    800005fe:	60a2                	ld	ra,8(sp)
    80000600:	6402                	ld	s0,0(sp)
    80000602:	0141                	addi	sp,sp,16
    80000604:	8082                	ret
  if (mappages(kpgtbl, va, sz, pa, perm) != 0) panic("kvmmap");
    80000606:	00008517          	auipc	a0,0x8
    8000060a:	a7250513          	addi	a0,a0,-1422 # 80008078 <etext+0x78>
    8000060e:	00005097          	auipc	ra,0x5
    80000612:	6be080e7          	jalr	1726(ra) # 80005ccc <panic>

0000000080000616 <kvmmake>:
pagetable_t kvmmake(void) {
    80000616:	1101                	addi	sp,sp,-32
    80000618:	ec06                	sd	ra,24(sp)
    8000061a:	e822                	sd	s0,16(sp)
    8000061c:	e426                	sd	s1,8(sp)
    8000061e:	e04a                	sd	s2,0(sp)
    80000620:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    80000622:	00000097          	auipc	ra,0x0
    80000626:	af8080e7          	jalr	-1288(ra) # 8000011a <kalloc>
    8000062a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062c:	6605                	lui	a2,0x1
    8000062e:	4581                	li	a1,0
    80000630:	00000097          	auipc	ra,0x0
    80000634:	b4a080e7          	jalr	-1206(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000638:	4719                	li	a4,6
    8000063a:	6685                	lui	a3,0x1
    8000063c:	10000637          	lui	a2,0x10000
    80000640:	100005b7          	lui	a1,0x10000
    80000644:	8526                	mv	a0,s1
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	fa0080e7          	jalr	-96(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064e:	4719                	li	a4,6
    80000650:	6685                	lui	a3,0x1
    80000652:	10001637          	lui	a2,0x10001
    80000656:	100015b7          	lui	a1,0x10001
    8000065a:	8526                	mv	a0,s1
    8000065c:	00000097          	auipc	ra,0x0
    80000660:	f8a080e7          	jalr	-118(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000664:	4719                	li	a4,6
    80000666:	004006b7          	lui	a3,0x400
    8000066a:	0c000637          	lui	a2,0xc000
    8000066e:	0c0005b7          	lui	a1,0xc000
    80000672:	8526                	mv	a0,s1
    80000674:	00000097          	auipc	ra,0x0
    80000678:	f72080e7          	jalr	-142(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    8000067c:	00008917          	auipc	s2,0x8
    80000680:	98490913          	addi	s2,s2,-1660 # 80008000 <etext>
    80000684:	4729                	li	a4,10
    80000686:	80008697          	auipc	a3,0x80008
    8000068a:	97a68693          	addi	a3,a3,-1670 # 8000 <_entry-0x7fff8000>
    8000068e:	4605                	li	a2,1
    80000690:	067e                	slli	a2,a2,0x1f
    80000692:	85b2                	mv	a1,a2
    80000694:	8526                	mv	a0,s1
    80000696:	00000097          	auipc	ra,0x0
    8000069a:	f50080e7          	jalr	-176(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    8000069e:	4719                	li	a4,6
    800006a0:	46c5                	li	a3,17
    800006a2:	06ee                	slli	a3,a3,0x1b
    800006a4:	412686b3          	sub	a3,a3,s2
    800006a8:	864a                	mv	a2,s2
    800006aa:	85ca                	mv	a1,s2
    800006ac:	8526                	mv	a0,s1
    800006ae:	00000097          	auipc	ra,0x0
    800006b2:	f38080e7          	jalr	-200(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b6:	4729                	li	a4,10
    800006b8:	6685                	lui	a3,0x1
    800006ba:	00007617          	auipc	a2,0x7
    800006be:	94660613          	addi	a2,a2,-1722 # 80007000 <_trampoline>
    800006c2:	040005b7          	lui	a1,0x4000
    800006c6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c8:	05b2                	slli	a1,a1,0xc
    800006ca:	8526                	mv	a0,s1
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	f1a080e7          	jalr	-230(ra) # 800005e6 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d4:	8526                	mv	a0,s1
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	608080e7          	jalr	1544(ra) # 80000cde <proc_mapstacks>
}
    800006de:	8526                	mv	a0,s1
    800006e0:	60e2                	ld	ra,24(sp)
    800006e2:	6442                	ld	s0,16(sp)
    800006e4:	64a2                	ld	s1,8(sp)
    800006e6:	6902                	ld	s2,0(sp)
    800006e8:	6105                	addi	sp,sp,32
    800006ea:	8082                	ret

00000000800006ec <kvminit>:
void kvminit(void) { kernel_pagetable = kvmmake(); }
    800006ec:	1141                	addi	sp,sp,-16
    800006ee:	e406                	sd	ra,8(sp)
    800006f0:	e022                	sd	s0,0(sp)
    800006f2:	0800                	addi	s0,sp,16
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	f22080e7          	jalr	-222(ra) # 80000616 <kvmmake>
    800006fc:	00008797          	auipc	a5,0x8
    80000700:	1ca7be23          	sd	a0,476(a5) # 800088d8 <kernel_pagetable>
    80000704:	60a2                	ld	ra,8(sp)
    80000706:	6402                	ld	s0,0(sp)
    80000708:	0141                	addi	sp,sp,16
    8000070a:	8082                	ret

000000008000070c <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free) {
    8000070c:	715d                	addi	sp,sp,-80
    8000070e:	e486                	sd	ra,72(sp)
    80000710:	e0a2                	sd	s0,64(sp)
    80000712:	fc26                	sd	s1,56(sp)
    80000714:	f84a                	sd	s2,48(sp)
    80000716:	f44e                	sd	s3,40(sp)
    80000718:	f052                	sd	s4,32(sp)
    8000071a:	ec56                	sd	s5,24(sp)
    8000071c:	e85a                	sd	s6,16(sp)
    8000071e:	e45e                	sd	s7,8(sp)
    80000720:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0) panic("uvmunmap: not aligned");
    80000722:	03459793          	slli	a5,a1,0x34
    80000726:	e795                	bnez	a5,80000752 <uvmunmap+0x46>
    80000728:	8a2a                	mv	s4,a0
    8000072a:	892e                	mv	s2,a1
    8000072c:	8ab6                	mv	s5,a3

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000072e:	0632                	slli	a2,a2,0xc
    80000730:	00b609b3          	add	s3,a2,a1
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    80000734:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80000736:	6b05                	lui	s6,0x1
    80000738:	0735e263          	bltu	a1,s3,8000079c <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
  }
}
    8000073c:	60a6                	ld	ra,72(sp)
    8000073e:	6406                	ld	s0,64(sp)
    80000740:	74e2                	ld	s1,56(sp)
    80000742:	7942                	ld	s2,48(sp)
    80000744:	79a2                	ld	s3,40(sp)
    80000746:	7a02                	ld	s4,32(sp)
    80000748:	6ae2                	ld	s5,24(sp)
    8000074a:	6b42                	ld	s6,16(sp)
    8000074c:	6ba2                	ld	s7,8(sp)
    8000074e:	6161                	addi	sp,sp,80
    80000750:	8082                	ret
  if ((va % PGSIZE) != 0) panic("uvmunmap: not aligned");
    80000752:	00008517          	auipc	a0,0x8
    80000756:	92e50513          	addi	a0,a0,-1746 # 80008080 <etext+0x80>
    8000075a:	00005097          	auipc	ra,0x5
    8000075e:	572080e7          	jalr	1394(ra) # 80005ccc <panic>
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    80000762:	00008517          	auipc	a0,0x8
    80000766:	93650513          	addi	a0,a0,-1738 # 80008098 <etext+0x98>
    8000076a:	00005097          	auipc	ra,0x5
    8000076e:	562080e7          	jalr	1378(ra) # 80005ccc <panic>
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    80000772:	00008517          	auipc	a0,0x8
    80000776:	93650513          	addi	a0,a0,-1738 # 800080a8 <etext+0xa8>
    8000077a:	00005097          	auipc	ra,0x5
    8000077e:	552080e7          	jalr	1362(ra) # 80005ccc <panic>
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    80000782:	00008517          	auipc	a0,0x8
    80000786:	93e50513          	addi	a0,a0,-1730 # 800080c0 <etext+0xc0>
    8000078a:	00005097          	auipc	ra,0x5
    8000078e:	542080e7          	jalr	1346(ra) # 80005ccc <panic>
    *pte = 0;
    80000792:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80000796:	995a                	add	s2,s2,s6
    80000798:	fb3972e3          	bgeu	s2,s3,8000073c <uvmunmap+0x30>
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    8000079c:	4601                	li	a2,0
    8000079e:	85ca                	mv	a1,s2
    800007a0:	8552                	mv	a0,s4
    800007a2:	00000097          	auipc	ra,0x0
    800007a6:	cbc080e7          	jalr	-836(ra) # 8000045e <walk>
    800007aa:	84aa                	mv	s1,a0
    800007ac:	d95d                	beqz	a0,80000762 <uvmunmap+0x56>
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    800007ae:	6108                	ld	a0,0(a0)
    800007b0:	00157793          	andi	a5,a0,1
    800007b4:	dfdd                	beqz	a5,80000772 <uvmunmap+0x66>
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    800007b6:	3ff57793          	andi	a5,a0,1023
    800007ba:	fd7784e3          	beq	a5,s7,80000782 <uvmunmap+0x76>
    if (do_free) {
    800007be:	fc0a8ae3          	beqz	s5,80000792 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007c2:	8129                	srli	a0,a0,0xa
      kfree((void *)pa);
    800007c4:	0532                	slli	a0,a0,0xc
    800007c6:	00000097          	auipc	ra,0x0
    800007ca:	856080e7          	jalr	-1962(ra) # 8000001c <kfree>
    800007ce:	b7d1                	j	80000792 <uvmunmap+0x86>

00000000800007d0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate() {
    800007d0:	1101                	addi	sp,sp,-32
    800007d2:	ec06                	sd	ra,24(sp)
    800007d4:	e822                	sd	s0,16(sp)
    800007d6:	e426                	sd	s1,8(sp)
    800007d8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800007da:	00000097          	auipc	ra,0x0
    800007de:	940080e7          	jalr	-1728(ra) # 8000011a <kalloc>
    800007e2:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    800007e4:	c519                	beqz	a0,800007f2 <uvmcreate+0x22>
  memset(pagetable, 0, PGSIZE);
    800007e6:	6605                	lui	a2,0x1
    800007e8:	4581                	li	a1,0
    800007ea:	00000097          	auipc	ra,0x0
    800007ee:	990080e7          	jalr	-1648(ra) # 8000017a <memset>
  return pagetable;
}
    800007f2:	8526                	mv	a0,s1
    800007f4:	60e2                	ld	ra,24(sp)
    800007f6:	6442                	ld	s0,16(sp)
    800007f8:	64a2                	ld	s1,8(sp)
    800007fa:	6105                	addi	sp,sp,32
    800007fc:	8082                	ret

00000000800007fe <uvmfirst>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz) {
    800007fe:	7179                	addi	sp,sp,-48
    80000800:	f406                	sd	ra,40(sp)
    80000802:	f022                	sd	s0,32(sp)
    80000804:	ec26                	sd	s1,24(sp)
    80000806:	e84a                	sd	s2,16(sp)
    80000808:	e44e                	sd	s3,8(sp)
    8000080a:	e052                	sd	s4,0(sp)
    8000080c:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE) panic("uvmfirst: more than a page");
    8000080e:	6785                	lui	a5,0x1
    80000810:	04f67863          	bgeu	a2,a5,80000860 <uvmfirst+0x62>
    80000814:	8a2a                	mv	s4,a0
    80000816:	89ae                	mv	s3,a1
    80000818:	84b2                	mv	s1,a2
  mem = kalloc();
    8000081a:	00000097          	auipc	ra,0x0
    8000081e:	900080e7          	jalr	-1792(ra) # 8000011a <kalloc>
    80000822:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000824:	6605                	lui	a2,0x1
    80000826:	4581                	li	a1,0
    80000828:	00000097          	auipc	ra,0x0
    8000082c:	952080e7          	jalr	-1710(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    80000830:	4779                	li	a4,30
    80000832:	86ca                	mv	a3,s2
    80000834:	6605                	lui	a2,0x1
    80000836:	4581                	li	a1,0
    80000838:	8552                	mv	a0,s4
    8000083a:	00000097          	auipc	ra,0x0
    8000083e:	d0c080e7          	jalr	-756(ra) # 80000546 <mappages>
  memmove(mem, src, sz);
    80000842:	8626                	mv	a2,s1
    80000844:	85ce                	mv	a1,s3
    80000846:	854a                	mv	a0,s2
    80000848:	00000097          	auipc	ra,0x0
    8000084c:	98e080e7          	jalr	-1650(ra) # 800001d6 <memmove>
}
    80000850:	70a2                	ld	ra,40(sp)
    80000852:	7402                	ld	s0,32(sp)
    80000854:	64e2                	ld	s1,24(sp)
    80000856:	6942                	ld	s2,16(sp)
    80000858:	69a2                	ld	s3,8(sp)
    8000085a:	6a02                	ld	s4,0(sp)
    8000085c:	6145                	addi	sp,sp,48
    8000085e:	8082                	ret
  if (sz >= PGSIZE) panic("uvmfirst: more than a page");
    80000860:	00008517          	auipc	a0,0x8
    80000864:	87850513          	addi	a0,a0,-1928 # 800080d8 <etext+0xd8>
    80000868:	00005097          	auipc	ra,0x5
    8000086c:	464080e7          	jalr	1124(ra) # 80005ccc <panic>

0000000080000870 <uvmdealloc>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64 uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    80000870:	1101                	addi	sp,sp,-32
    80000872:	ec06                	sd	ra,24(sp)
    80000874:	e822                	sd	s0,16(sp)
    80000876:	e426                	sd	s1,8(sp)
    80000878:	1000                	addi	s0,sp,32
  if (newsz >= oldsz) return oldsz;
    8000087a:	84ae                	mv	s1,a1
    8000087c:	00b67d63          	bgeu	a2,a1,80000896 <uvmdealloc+0x26>
    80000880:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    80000882:	6785                	lui	a5,0x1
    80000884:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000886:	00f60733          	add	a4,a2,a5
    8000088a:	76fd                	lui	a3,0xfffff
    8000088c:	8f75                	and	a4,a4,a3
    8000088e:	97ae                	add	a5,a5,a1
    80000890:	8ff5                	and	a5,a5,a3
    80000892:	00f76863          	bltu	a4,a5,800008a2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000896:	8526                	mv	a0,s1
    80000898:	60e2                	ld	ra,24(sp)
    8000089a:	6442                	ld	s0,16(sp)
    8000089c:	64a2                	ld	s1,8(sp)
    8000089e:	6105                	addi	sp,sp,32
    800008a0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a2:	8f99                	sub	a5,a5,a4
    800008a4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a6:	4685                	li	a3,1
    800008a8:	0007861b          	sext.w	a2,a5
    800008ac:	85ba                	mv	a1,a4
    800008ae:	00000097          	auipc	ra,0x0
    800008b2:	e5e080e7          	jalr	-418(ra) # 8000070c <uvmunmap>
    800008b6:	b7c5                	j	80000896 <uvmdealloc+0x26>

00000000800008b8 <uvmalloc>:
  if (newsz < oldsz) return oldsz;
    800008b8:	0ab66563          	bltu	a2,a1,80000962 <uvmalloc+0xaa>
uint64 uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int xperm) {
    800008bc:	7139                	addi	sp,sp,-64
    800008be:	fc06                	sd	ra,56(sp)
    800008c0:	f822                	sd	s0,48(sp)
    800008c2:	f426                	sd	s1,40(sp)
    800008c4:	f04a                	sd	s2,32(sp)
    800008c6:	ec4e                	sd	s3,24(sp)
    800008c8:	e852                	sd	s4,16(sp)
    800008ca:	e456                	sd	s5,8(sp)
    800008cc:	e05a                	sd	s6,0(sp)
    800008ce:	0080                	addi	s0,sp,64
    800008d0:	8aaa                	mv	s5,a0
    800008d2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d4:	6785                	lui	a5,0x1
    800008d6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d8:	95be                	add	a1,a1,a5
    800008da:	77fd                	lui	a5,0xfffff
    800008dc:	00f5f9b3          	and	s3,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800008e0:	08c9f363          	bgeu	s3,a2,80000966 <uvmalloc+0xae>
    800008e4:	894e                	mv	s2,s3
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800008e6:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008ea:	00000097          	auipc	ra,0x0
    800008ee:	830080e7          	jalr	-2000(ra) # 8000011a <kalloc>
    800008f2:	84aa                	mv	s1,a0
    if (mem == 0) {
    800008f4:	c51d                	beqz	a0,80000922 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008f6:	6605                	lui	a2,0x1
    800008f8:	4581                	li	a1,0
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	880080e7          	jalr	-1920(ra) # 8000017a <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    80000902:	875a                	mv	a4,s6
    80000904:	86a6                	mv	a3,s1
    80000906:	6605                	lui	a2,0x1
    80000908:	85ca                	mv	a1,s2
    8000090a:	8556                	mv	a0,s5
    8000090c:	00000097          	auipc	ra,0x0
    80000910:	c3a080e7          	jalr	-966(ra) # 80000546 <mappages>
    80000914:	e90d                	bnez	a0,80000946 <uvmalloc+0x8e>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80000916:	6785                	lui	a5,0x1
    80000918:	993e                	add	s2,s2,a5
    8000091a:	fd4968e3          	bltu	s2,s4,800008ea <uvmalloc+0x32>
  return newsz;
    8000091e:	8552                	mv	a0,s4
    80000920:	a809                	j	80000932 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000922:	864e                	mv	a2,s3
    80000924:	85ca                	mv	a1,s2
    80000926:	8556                	mv	a0,s5
    80000928:	00000097          	auipc	ra,0x0
    8000092c:	f48080e7          	jalr	-184(ra) # 80000870 <uvmdealloc>
      return 0;
    80000930:	4501                	li	a0,0
}
    80000932:	70e2                	ld	ra,56(sp)
    80000934:	7442                	ld	s0,48(sp)
    80000936:	74a2                	ld	s1,40(sp)
    80000938:	7902                	ld	s2,32(sp)
    8000093a:	69e2                	ld	s3,24(sp)
    8000093c:	6a42                	ld	s4,16(sp)
    8000093e:	6aa2                	ld	s5,8(sp)
    80000940:	6b02                	ld	s6,0(sp)
    80000942:	6121                	addi	sp,sp,64
    80000944:	8082                	ret
      kfree(mem);
    80000946:	8526                	mv	a0,s1
    80000948:	fffff097          	auipc	ra,0xfffff
    8000094c:	6d4080e7          	jalr	1748(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000950:	864e                	mv	a2,s3
    80000952:	85ca                	mv	a1,s2
    80000954:	8556                	mv	a0,s5
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	f1a080e7          	jalr	-230(ra) # 80000870 <uvmdealloc>
      return 0;
    8000095e:	4501                	li	a0,0
    80000960:	bfc9                	j	80000932 <uvmalloc+0x7a>
  if (newsz < oldsz) return oldsz;
    80000962:	852e                	mv	a0,a1
}
    80000964:	8082                	ret
  return newsz;
    80000966:	8532                	mv	a0,a2
    80000968:	b7e9                	j	80000932 <uvmalloc+0x7a>

000000008000096a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable) {
    8000096a:	7179                	addi	sp,sp,-48
    8000096c:	f406                	sd	ra,40(sp)
    8000096e:	f022                	sd	s0,32(sp)
    80000970:	ec26                	sd	s1,24(sp)
    80000972:	e84a                	sd	s2,16(sp)
    80000974:	e44e                	sd	s3,8(sp)
    80000976:	e052                	sd	s4,0(sp)
    80000978:	1800                	addi	s0,sp,48
    8000097a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    8000097c:	84aa                	mv	s1,a0
    8000097e:	6905                	lui	s2,0x1
    80000980:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000982:	4985                	li	s3,1
    80000984:	a829                	j	8000099e <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000986:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000988:	00c79513          	slli	a0,a5,0xc
    8000098c:	00000097          	auipc	ra,0x0
    80000990:	fde080e7          	jalr	-34(ra) # 8000096a <freewalk>
      pagetable[i] = 0;
    80000994:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++) {
    80000998:	04a1                	addi	s1,s1,8
    8000099a:	03248163          	beq	s1,s2,800009bc <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000099e:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    800009a0:	00f7f713          	andi	a4,a5,15
    800009a4:	ff3701e3          	beq	a4,s3,80000986 <freewalk+0x1c>
    } else if (pte & PTE_V) {
    800009a8:	8b85                	andi	a5,a5,1
    800009aa:	d7fd                	beqz	a5,80000998 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009ac:	00007517          	auipc	a0,0x7
    800009b0:	74c50513          	addi	a0,a0,1868 # 800080f8 <etext+0xf8>
    800009b4:	00005097          	auipc	ra,0x5
    800009b8:	318080e7          	jalr	792(ra) # 80005ccc <panic>
    }
  }
  kfree((void *)pagetable);
    800009bc:	8552                	mv	a0,s4
    800009be:	fffff097          	auipc	ra,0xfffff
    800009c2:	65e080e7          	jalr	1630(ra) # 8000001c <kfree>
}
    800009c6:	70a2                	ld	ra,40(sp)
    800009c8:	7402                	ld	s0,32(sp)
    800009ca:	64e2                	ld	s1,24(sp)
    800009cc:	6942                	ld	s2,16(sp)
    800009ce:	69a2                	ld	s3,8(sp)
    800009d0:	6a02                	ld	s4,0(sp)
    800009d2:	6145                	addi	sp,sp,48
    800009d4:	8082                	ret

00000000800009d6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz) {
    800009d6:	1101                	addi	sp,sp,-32
    800009d8:	ec06                	sd	ra,24(sp)
    800009da:	e822                	sd	s0,16(sp)
    800009dc:	e426                	sd	s1,8(sp)
    800009de:	1000                	addi	s0,sp,32
    800009e0:	84aa                	mv	s1,a0
  if (sz > 0) uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800009e2:	e999                	bnez	a1,800009f8 <uvmfree+0x22>
  freewalk(pagetable);
    800009e4:	8526                	mv	a0,s1
    800009e6:	00000097          	auipc	ra,0x0
    800009ea:	f84080e7          	jalr	-124(ra) # 8000096a <freewalk>
}
    800009ee:	60e2                	ld	ra,24(sp)
    800009f0:	6442                	ld	s0,16(sp)
    800009f2:	64a2                	ld	s1,8(sp)
    800009f4:	6105                	addi	sp,sp,32
    800009f6:	8082                	ret
  if (sz > 0) uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800009f8:	6785                	lui	a5,0x1
    800009fa:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009fc:	95be                	add	a1,a1,a5
    800009fe:	4685                	li	a3,1
    80000a00:	00c5d613          	srli	a2,a1,0xc
    80000a04:	4581                	li	a1,0
    80000a06:	00000097          	auipc	ra,0x0
    80000a0a:	d06080e7          	jalr	-762(ra) # 8000070c <uvmunmap>
    80000a0e:	bfd9                	j	800009e4 <uvmfree+0xe>

0000000080000a10 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE) {
    80000a10:	c679                	beqz	a2,80000ade <uvmcopy+0xce>
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    80000a12:	715d                	addi	sp,sp,-80
    80000a14:	e486                	sd	ra,72(sp)
    80000a16:	e0a2                	sd	s0,64(sp)
    80000a18:	fc26                	sd	s1,56(sp)
    80000a1a:	f84a                	sd	s2,48(sp)
    80000a1c:	f44e                	sd	s3,40(sp)
    80000a1e:	f052                	sd	s4,32(sp)
    80000a20:	ec56                	sd	s5,24(sp)
    80000a22:	e85a                	sd	s6,16(sp)
    80000a24:	e45e                	sd	s7,8(sp)
    80000a26:	0880                	addi	s0,sp,80
    80000a28:	8b2a                	mv	s6,a0
    80000a2a:	8aae                	mv	s5,a1
    80000a2c:	8a32                	mv	s4,a2
  for (i = 0; i < sz; i += PGSIZE) {
    80000a2e:	4981                	li	s3,0
    if ((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist");
    80000a30:	4601                	li	a2,0
    80000a32:	85ce                	mv	a1,s3
    80000a34:	855a                	mv	a0,s6
    80000a36:	00000097          	auipc	ra,0x0
    80000a3a:	a28080e7          	jalr	-1496(ra) # 8000045e <walk>
    80000a3e:	c531                	beqz	a0,80000a8a <uvmcopy+0x7a>
    if ((*pte & PTE_V) == 0) panic("uvmcopy: page not present");
    80000a40:	6118                	ld	a4,0(a0)
    80000a42:	00177793          	andi	a5,a4,1
    80000a46:	cbb1                	beqz	a5,80000a9a <uvmcopy+0x8a>
    pa = PTE2PA(*pte);
    80000a48:	00a75593          	srli	a1,a4,0xa
    80000a4c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a50:	3ff77493          	andi	s1,a4,1023
    if ((mem = kalloc()) == 0) goto err;
    80000a54:	fffff097          	auipc	ra,0xfffff
    80000a58:	6c6080e7          	jalr	1734(ra) # 8000011a <kalloc>
    80000a5c:	892a                	mv	s2,a0
    80000a5e:	c939                	beqz	a0,80000ab4 <uvmcopy+0xa4>
    memmove(mem, (char *)pa, PGSIZE);
    80000a60:	6605                	lui	a2,0x1
    80000a62:	85de                	mv	a1,s7
    80000a64:	fffff097          	auipc	ra,0xfffff
    80000a68:	772080e7          	jalr	1906(ra) # 800001d6 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    80000a6c:	8726                	mv	a4,s1
    80000a6e:	86ca                	mv	a3,s2
    80000a70:	6605                	lui	a2,0x1
    80000a72:	85ce                	mv	a1,s3
    80000a74:	8556                	mv	a0,s5
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	ad0080e7          	jalr	-1328(ra) # 80000546 <mappages>
    80000a7e:	e515                	bnez	a0,80000aaa <uvmcopy+0x9a>
  for (i = 0; i < sz; i += PGSIZE) {
    80000a80:	6785                	lui	a5,0x1
    80000a82:	99be                	add	s3,s3,a5
    80000a84:	fb49e6e3          	bltu	s3,s4,80000a30 <uvmcopy+0x20>
    80000a88:	a081                	j	80000ac8 <uvmcopy+0xb8>
    if ((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist");
    80000a8a:	00007517          	auipc	a0,0x7
    80000a8e:	67e50513          	addi	a0,a0,1662 # 80008108 <etext+0x108>
    80000a92:	00005097          	auipc	ra,0x5
    80000a96:	23a080e7          	jalr	570(ra) # 80005ccc <panic>
    if ((*pte & PTE_V) == 0) panic("uvmcopy: page not present");
    80000a9a:	00007517          	auipc	a0,0x7
    80000a9e:	68e50513          	addi	a0,a0,1678 # 80008128 <etext+0x128>
    80000aa2:	00005097          	auipc	ra,0x5
    80000aa6:	22a080e7          	jalr	554(ra) # 80005ccc <panic>
      kfree(mem);
    80000aaa:	854a                	mv	a0,s2
    80000aac:	fffff097          	auipc	ra,0xfffff
    80000ab0:	570080e7          	jalr	1392(ra) # 8000001c <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab4:	4685                	li	a3,1
    80000ab6:	00c9d613          	srli	a2,s3,0xc
    80000aba:	4581                	li	a1,0
    80000abc:	8556                	mv	a0,s5
    80000abe:	00000097          	auipc	ra,0x0
    80000ac2:	c4e080e7          	jalr	-946(ra) # 8000070c <uvmunmap>
  return -1;
    80000ac6:	557d                	li	a0,-1
}
    80000ac8:	60a6                	ld	ra,72(sp)
    80000aca:	6406                	ld	s0,64(sp)
    80000acc:	74e2                	ld	s1,56(sp)
    80000ace:	7942                	ld	s2,48(sp)
    80000ad0:	79a2                	ld	s3,40(sp)
    80000ad2:	7a02                	ld	s4,32(sp)
    80000ad4:	6ae2                	ld	s5,24(sp)
    80000ad6:	6b42                	ld	s6,16(sp)
    80000ad8:	6ba2                	ld	s7,8(sp)
    80000ada:	6161                	addi	sp,sp,80
    80000adc:	8082                	ret
  return 0;
    80000ade:	4501                	li	a0,0
}
    80000ae0:	8082                	ret

0000000080000ae2 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va) {
    80000ae2:	1141                	addi	sp,sp,-16
    80000ae4:	e406                	sd	ra,8(sp)
    80000ae6:	e022                	sd	s0,0(sp)
    80000ae8:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000aea:	4601                	li	a2,0
    80000aec:	00000097          	auipc	ra,0x0
    80000af0:	972080e7          	jalr	-1678(ra) # 8000045e <walk>
  if (pte == 0) panic("uvmclear");
    80000af4:	c901                	beqz	a0,80000b04 <uvmclear+0x22>
  *pte &= ~PTE_U;
    80000af6:	611c                	ld	a5,0(a0)
    80000af8:	9bbd                	andi	a5,a5,-17
    80000afa:	e11c                	sd	a5,0(a0)
}
    80000afc:	60a2                	ld	ra,8(sp)
    80000afe:	6402                	ld	s0,0(sp)
    80000b00:	0141                	addi	sp,sp,16
    80000b02:	8082                	ret
  if (pte == 0) panic("uvmclear");
    80000b04:	00007517          	auipc	a0,0x7
    80000b08:	64450513          	addi	a0,a0,1604 # 80008148 <etext+0x148>
    80000b0c:	00005097          	auipc	ra,0x5
    80000b10:	1c0080e7          	jalr	448(ra) # 80005ccc <panic>

0000000080000b14 <copyout>:
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    80000b14:	c6bd                	beqz	a3,80000b82 <copyout+0x6e>
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    80000b16:	715d                	addi	sp,sp,-80
    80000b18:	e486                	sd	ra,72(sp)
    80000b1a:	e0a2                	sd	s0,64(sp)
    80000b1c:	fc26                	sd	s1,56(sp)
    80000b1e:	f84a                	sd	s2,48(sp)
    80000b20:	f44e                	sd	s3,40(sp)
    80000b22:	f052                	sd	s4,32(sp)
    80000b24:	ec56                	sd	s5,24(sp)
    80000b26:	e85a                	sd	s6,16(sp)
    80000b28:	e45e                	sd	s7,8(sp)
    80000b2a:	e062                	sd	s8,0(sp)
    80000b2c:	0880                	addi	s0,sp,80
    80000b2e:	8b2a                	mv	s6,a0
    80000b30:	8c2e                	mv	s8,a1
    80000b32:	8a32                	mv	s4,a2
    80000b34:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b36:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (dstva - va0);
    80000b38:	6a85                	lui	s5,0x1
    80000b3a:	a015                	j	80000b5e <copyout+0x4a>
    if (n > len) n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b3c:	9562                	add	a0,a0,s8
    80000b3e:	0004861b          	sext.w	a2,s1
    80000b42:	85d2                	mv	a1,s4
    80000b44:	41250533          	sub	a0,a0,s2
    80000b48:	fffff097          	auipc	ra,0xfffff
    80000b4c:	68e080e7          	jalr	1678(ra) # 800001d6 <memmove>

    len -= n;
    80000b50:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b54:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b56:	01590c33          	add	s8,s2,s5
  while (len > 0) {
    80000b5a:	02098263          	beqz	s3,80000b7e <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b5e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b62:	85ca                	mv	a1,s2
    80000b64:	855a                	mv	a0,s6
    80000b66:	00000097          	auipc	ra,0x0
    80000b6a:	99e080e7          	jalr	-1634(ra) # 80000504 <walkaddr>
    if (pa0 == 0) return -1;
    80000b6e:	cd01                	beqz	a0,80000b86 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b70:	418904b3          	sub	s1,s2,s8
    80000b74:	94d6                	add	s1,s1,s5
    80000b76:	fc99f3e3          	bgeu	s3,s1,80000b3c <copyout+0x28>
    80000b7a:	84ce                	mv	s1,s3
    80000b7c:	b7c1                	j	80000b3c <copyout+0x28>
  }
  return 0;
    80000b7e:	4501                	li	a0,0
    80000b80:	a021                	j	80000b88 <copyout+0x74>
    80000b82:	4501                	li	a0,0
}
    80000b84:	8082                	ret
    if (pa0 == 0) return -1;
    80000b86:	557d                	li	a0,-1
}
    80000b88:	60a6                	ld	ra,72(sp)
    80000b8a:	6406                	ld	s0,64(sp)
    80000b8c:	74e2                	ld	s1,56(sp)
    80000b8e:	7942                	ld	s2,48(sp)
    80000b90:	79a2                	ld	s3,40(sp)
    80000b92:	7a02                	ld	s4,32(sp)
    80000b94:	6ae2                	ld	s5,24(sp)
    80000b96:	6b42                	ld	s6,16(sp)
    80000b98:	6ba2                	ld	s7,8(sp)
    80000b9a:	6c02                	ld	s8,0(sp)
    80000b9c:	6161                	addi	sp,sp,80
    80000b9e:	8082                	ret

0000000080000ba0 <copyin>:
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    80000ba0:	caa5                	beqz	a3,80000c10 <copyin+0x70>
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
    80000ba2:	715d                	addi	sp,sp,-80
    80000ba4:	e486                	sd	ra,72(sp)
    80000ba6:	e0a2                	sd	s0,64(sp)
    80000ba8:	fc26                	sd	s1,56(sp)
    80000baa:	f84a                	sd	s2,48(sp)
    80000bac:	f44e                	sd	s3,40(sp)
    80000bae:	f052                	sd	s4,32(sp)
    80000bb0:	ec56                	sd	s5,24(sp)
    80000bb2:	e85a                	sd	s6,16(sp)
    80000bb4:	e45e                	sd	s7,8(sp)
    80000bb6:	e062                	sd	s8,0(sp)
    80000bb8:	0880                	addi	s0,sp,80
    80000bba:	8b2a                	mv	s6,a0
    80000bbc:	8a2e                	mv	s4,a1
    80000bbe:	8c32                	mv	s8,a2
    80000bc0:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc2:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (srcva - va0);
    80000bc4:	6a85                	lui	s5,0x1
    80000bc6:	a01d                	j	80000bec <copyin+0x4c>
    if (n > len) n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bc8:	018505b3          	add	a1,a0,s8
    80000bcc:	0004861b          	sext.w	a2,s1
    80000bd0:	412585b3          	sub	a1,a1,s2
    80000bd4:	8552                	mv	a0,s4
    80000bd6:	fffff097          	auipc	ra,0xfffff
    80000bda:	600080e7          	jalr	1536(ra) # 800001d6 <memmove>

    len -= n;
    80000bde:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000be2:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000be4:	01590c33          	add	s8,s2,s5
  while (len > 0) {
    80000be8:	02098263          	beqz	s3,80000c0c <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bec:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bf0:	85ca                	mv	a1,s2
    80000bf2:	855a                	mv	a0,s6
    80000bf4:	00000097          	auipc	ra,0x0
    80000bf8:	910080e7          	jalr	-1776(ra) # 80000504 <walkaddr>
    if (pa0 == 0) return -1;
    80000bfc:	cd01                	beqz	a0,80000c14 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bfe:	418904b3          	sub	s1,s2,s8
    80000c02:	94d6                	add	s1,s1,s5
    80000c04:	fc99f2e3          	bgeu	s3,s1,80000bc8 <copyin+0x28>
    80000c08:	84ce                	mv	s1,s3
    80000c0a:	bf7d                	j	80000bc8 <copyin+0x28>
  }
  return 0;
    80000c0c:	4501                	li	a0,0
    80000c0e:	a021                	j	80000c16 <copyin+0x76>
    80000c10:	4501                	li	a0,0
}
    80000c12:	8082                	ret
    if (pa0 == 0) return -1;
    80000c14:	557d                	li	a0,-1
}
    80000c16:	60a6                	ld	ra,72(sp)
    80000c18:	6406                	ld	s0,64(sp)
    80000c1a:	74e2                	ld	s1,56(sp)
    80000c1c:	7942                	ld	s2,48(sp)
    80000c1e:	79a2                	ld	s3,40(sp)
    80000c20:	7a02                	ld	s4,32(sp)
    80000c22:	6ae2                	ld	s5,24(sp)
    80000c24:	6b42                	ld	s6,16(sp)
    80000c26:	6ba2                	ld	s7,8(sp)
    80000c28:	6c02                	ld	s8,0(sp)
    80000c2a:	6161                	addi	sp,sp,80
    80000c2c:	8082                	ret

0000000080000c2e <copyinstr>:
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0) {
    80000c2e:	c2dd                	beqz	a3,80000cd4 <copyinstr+0xa6>
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
    80000c30:	715d                	addi	sp,sp,-80
    80000c32:	e486                	sd	ra,72(sp)
    80000c34:	e0a2                	sd	s0,64(sp)
    80000c36:	fc26                	sd	s1,56(sp)
    80000c38:	f84a                	sd	s2,48(sp)
    80000c3a:	f44e                	sd	s3,40(sp)
    80000c3c:	f052                	sd	s4,32(sp)
    80000c3e:	ec56                	sd	s5,24(sp)
    80000c40:	e85a                	sd	s6,16(sp)
    80000c42:	e45e                	sd	s7,8(sp)
    80000c44:	0880                	addi	s0,sp,80
    80000c46:	8a2a                	mv	s4,a0
    80000c48:	8b2e                	mv	s6,a1
    80000c4a:	8bb2                	mv	s7,a2
    80000c4c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c4e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (srcva - va0);
    80000c50:	6985                	lui	s3,0x1
    80000c52:	a02d                	j	80000c7c <copyinstr+0x4e>
    if (n > max) n = max;

    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0) {
      if (*p == '\0') {
        *dst = '\0';
    80000c54:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c58:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null) {
    80000c5a:	37fd                	addiw	a5,a5,-1
    80000c5c:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c60:	60a6                	ld	ra,72(sp)
    80000c62:	6406                	ld	s0,64(sp)
    80000c64:	74e2                	ld	s1,56(sp)
    80000c66:	7942                	ld	s2,48(sp)
    80000c68:	79a2                	ld	s3,40(sp)
    80000c6a:	7a02                	ld	s4,32(sp)
    80000c6c:	6ae2                	ld	s5,24(sp)
    80000c6e:	6b42                	ld	s6,16(sp)
    80000c70:	6ba2                	ld	s7,8(sp)
    80000c72:	6161                	addi	sp,sp,80
    80000c74:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c76:	01390bb3          	add	s7,s2,s3
  while (got_null == 0 && max > 0) {
    80000c7a:	c8a9                	beqz	s1,80000ccc <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c7c:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c80:	85ca                	mv	a1,s2
    80000c82:	8552                	mv	a0,s4
    80000c84:	00000097          	auipc	ra,0x0
    80000c88:	880080e7          	jalr	-1920(ra) # 80000504 <walkaddr>
    if (pa0 == 0) return -1;
    80000c8c:	c131                	beqz	a0,80000cd0 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c8e:	417906b3          	sub	a3,s2,s7
    80000c92:	96ce                	add	a3,a3,s3
    80000c94:	00d4f363          	bgeu	s1,a3,80000c9a <copyinstr+0x6c>
    80000c98:	86a6                	mv	a3,s1
    char *p = (char *)(pa0 + (srcva - va0));
    80000c9a:	955e                	add	a0,a0,s7
    80000c9c:	41250533          	sub	a0,a0,s2
    while (n > 0) {
    80000ca0:	daf9                	beqz	a3,80000c76 <copyinstr+0x48>
    80000ca2:	87da                	mv	a5,s6
      if (*p == '\0') {
    80000ca4:	41650633          	sub	a2,a0,s6
    80000ca8:	fff48593          	addi	a1,s1,-1
    80000cac:	95da                	add	a1,a1,s6
    while (n > 0) {
    80000cae:	96da                	add	a3,a3,s6
      if (*p == '\0') {
    80000cb0:	00f60733          	add	a4,a2,a5
    80000cb4:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd290>
    80000cb8:	df51                	beqz	a4,80000c54 <copyinstr+0x26>
        *dst = *p;
    80000cba:	00e78023          	sb	a4,0(a5)
      --max;
    80000cbe:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000cc2:	0785                	addi	a5,a5,1
    while (n > 0) {
    80000cc4:	fed796e3          	bne	a5,a3,80000cb0 <copyinstr+0x82>
      dst++;
    80000cc8:	8b3e                	mv	s6,a5
    80000cca:	b775                	j	80000c76 <copyinstr+0x48>
    80000ccc:	4781                	li	a5,0
    80000cce:	b771                	j	80000c5a <copyinstr+0x2c>
    if (pa0 == 0) return -1;
    80000cd0:	557d                	li	a0,-1
    80000cd2:	b779                	j	80000c60 <copyinstr+0x32>
  int got_null = 0;
    80000cd4:	4781                	li	a5,0
  if (got_null) {
    80000cd6:	37fd                	addiw	a5,a5,-1
    80000cd8:	0007851b          	sext.w	a0,a5
}
    80000cdc:	8082                	ret

0000000080000cde <proc_mapstacks>:
struct spinlock wait_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl) {
    80000cde:	7139                	addi	sp,sp,-64
    80000ce0:	fc06                	sd	ra,56(sp)
    80000ce2:	f822                	sd	s0,48(sp)
    80000ce4:	f426                	sd	s1,40(sp)
    80000ce6:	f04a                	sd	s2,32(sp)
    80000ce8:	ec4e                	sd	s3,24(sp)
    80000cea:	e852                	sd	s4,16(sp)
    80000cec:	e456                	sd	s5,8(sp)
    80000cee:	e05a                	sd	s6,0(sp)
    80000cf0:	0080                	addi	s0,sp,64
    80000cf2:	89aa                	mv	s3,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80000cf4:	00008497          	auipc	s1,0x8
    80000cf8:	05c48493          	addi	s1,s1,92 # 80008d50 <proc>
    char *pa = kalloc();
    if (pa == 0) panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80000cfc:	8b26                	mv	s6,s1
    80000cfe:	00007a97          	auipc	s5,0x7
    80000d02:	302a8a93          	addi	s5,s5,770 # 80008000 <etext>
    80000d06:	04000937          	lui	s2,0x4000
    80000d0a:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d0c:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80000d0e:	0000ea17          	auipc	s4,0xe
    80000d12:	a42a0a13          	addi	s4,s4,-1470 # 8000e750 <tickslock>
    char *pa = kalloc();
    80000d16:	fffff097          	auipc	ra,0xfffff
    80000d1a:	404080e7          	jalr	1028(ra) # 8000011a <kalloc>
    80000d1e:	862a                	mv	a2,a0
    if (pa == 0) panic("kalloc");
    80000d20:	c131                	beqz	a0,80000d64 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    80000d22:	416485b3          	sub	a1,s1,s6
    80000d26:	858d                	srai	a1,a1,0x3
    80000d28:	000ab783          	ld	a5,0(s5)
    80000d2c:	02f585b3          	mul	a1,a1,a5
    80000d30:	2585                	addiw	a1,a1,1
    80000d32:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d36:	4719                	li	a4,6
    80000d38:	6685                	lui	a3,0x1
    80000d3a:	40b905b3          	sub	a1,s2,a1
    80000d3e:	854e                	mv	a0,s3
    80000d40:	00000097          	auipc	ra,0x0
    80000d44:	8a6080e7          	jalr	-1882(ra) # 800005e6 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    80000d48:	16848493          	addi	s1,s1,360
    80000d4c:	fd4495e3          	bne	s1,s4,80000d16 <proc_mapstacks+0x38>
  }
}
    80000d50:	70e2                	ld	ra,56(sp)
    80000d52:	7442                	ld	s0,48(sp)
    80000d54:	74a2                	ld	s1,40(sp)
    80000d56:	7902                	ld	s2,32(sp)
    80000d58:	69e2                	ld	s3,24(sp)
    80000d5a:	6a42                	ld	s4,16(sp)
    80000d5c:	6aa2                	ld	s5,8(sp)
    80000d5e:	6b02                	ld	s6,0(sp)
    80000d60:	6121                	addi	sp,sp,64
    80000d62:	8082                	ret
    if (pa == 0) panic("kalloc");
    80000d64:	00007517          	auipc	a0,0x7
    80000d68:	3f450513          	addi	a0,a0,1012 # 80008158 <etext+0x158>
    80000d6c:	00005097          	auipc	ra,0x5
    80000d70:	f60080e7          	jalr	-160(ra) # 80005ccc <panic>

0000000080000d74 <procinit>:

// initialize the proc table.
void procinit(void) {
    80000d74:	7139                	addi	sp,sp,-64
    80000d76:	fc06                	sd	ra,56(sp)
    80000d78:	f822                	sd	s0,48(sp)
    80000d7a:	f426                	sd	s1,40(sp)
    80000d7c:	f04a                	sd	s2,32(sp)
    80000d7e:	ec4e                	sd	s3,24(sp)
    80000d80:	e852                	sd	s4,16(sp)
    80000d82:	e456                	sd	s5,8(sp)
    80000d84:	e05a                	sd	s6,0(sp)
    80000d86:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80000d88:	00007597          	auipc	a1,0x7
    80000d8c:	3d858593          	addi	a1,a1,984 # 80008160 <etext+0x160>
    80000d90:	00008517          	auipc	a0,0x8
    80000d94:	b9050513          	addi	a0,a0,-1136 # 80008920 <pid_lock>
    80000d98:	00005097          	auipc	ra,0x5
    80000d9c:	3dc080e7          	jalr	988(ra) # 80006174 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000da0:	00007597          	auipc	a1,0x7
    80000da4:	3c858593          	addi	a1,a1,968 # 80008168 <etext+0x168>
    80000da8:	00008517          	auipc	a0,0x8
    80000dac:	b9050513          	addi	a0,a0,-1136 # 80008938 <wait_lock>
    80000db0:	00005097          	auipc	ra,0x5
    80000db4:	3c4080e7          	jalr	964(ra) # 80006174 <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    80000db8:	00008497          	auipc	s1,0x8
    80000dbc:	f9848493          	addi	s1,s1,-104 # 80008d50 <proc>
    initlock(&p->lock, "proc");
    80000dc0:	00007b17          	auipc	s6,0x7
    80000dc4:	3b8b0b13          	addi	s6,s6,952 # 80008178 <etext+0x178>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80000dc8:	8aa6                	mv	s5,s1
    80000dca:	00007a17          	auipc	s4,0x7
    80000dce:	236a0a13          	addi	s4,s4,566 # 80008000 <etext>
    80000dd2:	04000937          	lui	s2,0x4000
    80000dd6:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000dd8:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80000dda:	0000e997          	auipc	s3,0xe
    80000dde:	97698993          	addi	s3,s3,-1674 # 8000e750 <tickslock>
    initlock(&p->lock, "proc");
    80000de2:	85da                	mv	a1,s6
    80000de4:	8526                	mv	a0,s1
    80000de6:	00005097          	auipc	ra,0x5
    80000dea:	38e080e7          	jalr	910(ra) # 80006174 <initlock>
    p->state = UNUSED;
    80000dee:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80000df2:	415487b3          	sub	a5,s1,s5
    80000df6:	878d                	srai	a5,a5,0x3
    80000df8:	000a3703          	ld	a4,0(s4)
    80000dfc:	02e787b3          	mul	a5,a5,a4
    80000e00:	2785                	addiw	a5,a5,1
    80000e02:	00d7979b          	slliw	a5,a5,0xd
    80000e06:	40f907b3          	sub	a5,s2,a5
    80000e0a:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    80000e0c:	16848493          	addi	s1,s1,360
    80000e10:	fd3499e3          	bne	s1,s3,80000de2 <procinit+0x6e>
  }
}
    80000e14:	70e2                	ld	ra,56(sp)
    80000e16:	7442                	ld	s0,48(sp)
    80000e18:	74a2                	ld	s1,40(sp)
    80000e1a:	7902                	ld	s2,32(sp)
    80000e1c:	69e2                	ld	s3,24(sp)
    80000e1e:	6a42                	ld	s4,16(sp)
    80000e20:	6aa2                	ld	s5,8(sp)
    80000e22:	6b02                	ld	s6,0(sp)
    80000e24:	6121                	addi	sp,sp,64
    80000e26:	8082                	ret

0000000080000e28 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid() {
    80000e28:	1141                	addi	sp,sp,-16
    80000e2a:	e422                	sd	s0,8(sp)
    80000e2c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    80000e2e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e30:	2501                	sext.w	a0,a0
    80000e32:	6422                	ld	s0,8(sp)
    80000e34:	0141                	addi	sp,sp,16
    80000e36:	8082                	ret

0000000080000e38 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *mycpu(void) {
    80000e38:	1141                	addi	sp,sp,-16
    80000e3a:	e422                	sd	s0,8(sp)
    80000e3c:	0800                	addi	s0,sp,16
    80000e3e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e40:	2781                	sext.w	a5,a5
    80000e42:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e44:	00008517          	auipc	a0,0x8
    80000e48:	b0c50513          	addi	a0,a0,-1268 # 80008950 <cpus>
    80000e4c:	953e                	add	a0,a0,a5
    80000e4e:	6422                	ld	s0,8(sp)
    80000e50:	0141                	addi	sp,sp,16
    80000e52:	8082                	ret

0000000080000e54 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *myproc(void) {
    80000e54:	1101                	addi	sp,sp,-32
    80000e56:	ec06                	sd	ra,24(sp)
    80000e58:	e822                	sd	s0,16(sp)
    80000e5a:	e426                	sd	s1,8(sp)
    80000e5c:	1000                	addi	s0,sp,32
  push_off();
    80000e5e:	00005097          	auipc	ra,0x5
    80000e62:	35a080e7          	jalr	858(ra) # 800061b8 <push_off>
    80000e66:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e68:	2781                	sext.w	a5,a5
    80000e6a:	079e                	slli	a5,a5,0x7
    80000e6c:	00008717          	auipc	a4,0x8
    80000e70:	ab470713          	addi	a4,a4,-1356 # 80008920 <pid_lock>
    80000e74:	97ba                	add	a5,a5,a4
    80000e76:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e78:	00005097          	auipc	ra,0x5
    80000e7c:	3e0080e7          	jalr	992(ra) # 80006258 <pop_off>
  return p;
}
    80000e80:	8526                	mv	a0,s1
    80000e82:	60e2                	ld	ra,24(sp)
    80000e84:	6442                	ld	s0,16(sp)
    80000e86:	64a2                	ld	s1,8(sp)
    80000e88:	6105                	addi	sp,sp,32
    80000e8a:	8082                	ret

0000000080000e8c <forkret>:
  release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void) {
    80000e8c:	1141                	addi	sp,sp,-16
    80000e8e:	e406                	sd	ra,8(sp)
    80000e90:	e022                	sd	s0,0(sp)
    80000e92:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e94:	00000097          	auipc	ra,0x0
    80000e98:	fc0080e7          	jalr	-64(ra) # 80000e54 <myproc>
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	41c080e7          	jalr	1052(ra) # 800062b8 <release>

  if (first) {
    80000ea4:	00008797          	auipc	a5,0x8
    80000ea8:	9bc7a783          	lw	a5,-1604(a5) # 80008860 <first.1>
    80000eac:	eb89                	bnez	a5,80000ebe <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eae:	00001097          	auipc	ra,0x1
    80000eb2:	d3c080e7          	jalr	-708(ra) # 80001bea <usertrapret>
}
    80000eb6:	60a2                	ld	ra,8(sp)
    80000eb8:	6402                	ld	s0,0(sp)
    80000eba:	0141                	addi	sp,sp,16
    80000ebc:	8082                	ret
    first = 0;
    80000ebe:	00008797          	auipc	a5,0x8
    80000ec2:	9a07a123          	sw	zero,-1630(a5) # 80008860 <first.1>
    fsinit(ROOTDEV);
    80000ec6:	4505                	li	a0,1
    80000ec8:	00002097          	auipc	ra,0x2
    80000ecc:	ad6080e7          	jalr	-1322(ra) # 8000299e <fsinit>
    80000ed0:	bff9                	j	80000eae <forkret+0x22>

0000000080000ed2 <allocpid>:
int allocpid() {
    80000ed2:	1101                	addi	sp,sp,-32
    80000ed4:	ec06                	sd	ra,24(sp)
    80000ed6:	e822                	sd	s0,16(sp)
    80000ed8:	e426                	sd	s1,8(sp)
    80000eda:	e04a                	sd	s2,0(sp)
    80000edc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ede:	00008917          	auipc	s2,0x8
    80000ee2:	a4290913          	addi	s2,s2,-1470 # 80008920 <pid_lock>
    80000ee6:	854a                	mv	a0,s2
    80000ee8:	00005097          	auipc	ra,0x5
    80000eec:	31c080e7          	jalr	796(ra) # 80006204 <acquire>
  pid = nextpid;
    80000ef0:	00008797          	auipc	a5,0x8
    80000ef4:	97478793          	addi	a5,a5,-1676 # 80008864 <nextpid>
    80000ef8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000efa:	0014871b          	addiw	a4,s1,1
    80000efe:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f00:	854a                	mv	a0,s2
    80000f02:	00005097          	auipc	ra,0x5
    80000f06:	3b6080e7          	jalr	950(ra) # 800062b8 <release>
}
    80000f0a:	8526                	mv	a0,s1
    80000f0c:	60e2                	ld	ra,24(sp)
    80000f0e:	6442                	ld	s0,16(sp)
    80000f10:	64a2                	ld	s1,8(sp)
    80000f12:	6902                	ld	s2,0(sp)
    80000f14:	6105                	addi	sp,sp,32
    80000f16:	8082                	ret

0000000080000f18 <proc_pagetable>:
pagetable_t proc_pagetable(struct proc *p) {
    80000f18:	1101                	addi	sp,sp,-32
    80000f1a:	ec06                	sd	ra,24(sp)
    80000f1c:	e822                	sd	s0,16(sp)
    80000f1e:	e426                	sd	s1,8(sp)
    80000f20:	e04a                	sd	s2,0(sp)
    80000f22:	1000                	addi	s0,sp,32
    80000f24:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f26:	00000097          	auipc	ra,0x0
    80000f2a:	8aa080e7          	jalr	-1878(ra) # 800007d0 <uvmcreate>
    80000f2e:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    80000f30:	c121                	beqz	a0,80000f70 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80000f32:	4729                	li	a4,10
    80000f34:	00006697          	auipc	a3,0x6
    80000f38:	0cc68693          	addi	a3,a3,204 # 80007000 <_trampoline>
    80000f3c:	6605                	lui	a2,0x1
    80000f3e:	040005b7          	lui	a1,0x4000
    80000f42:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f44:	05b2                	slli	a1,a1,0xc
    80000f46:	fffff097          	auipc	ra,0xfffff
    80000f4a:	600080e7          	jalr	1536(ra) # 80000546 <mappages>
    80000f4e:	02054863          	bltz	a0,80000f7e <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80000f52:	4719                	li	a4,6
    80000f54:	05893683          	ld	a3,88(s2)
    80000f58:	6605                	lui	a2,0x1
    80000f5a:	020005b7          	lui	a1,0x2000
    80000f5e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f60:	05b6                	slli	a1,a1,0xd
    80000f62:	8526                	mv	a0,s1
    80000f64:	fffff097          	auipc	ra,0xfffff
    80000f68:	5e2080e7          	jalr	1506(ra) # 80000546 <mappages>
    80000f6c:	02054163          	bltz	a0,80000f8e <proc_pagetable+0x76>
}
    80000f70:	8526                	mv	a0,s1
    80000f72:	60e2                	ld	ra,24(sp)
    80000f74:	6442                	ld	s0,16(sp)
    80000f76:	64a2                	ld	s1,8(sp)
    80000f78:	6902                	ld	s2,0(sp)
    80000f7a:	6105                	addi	sp,sp,32
    80000f7c:	8082                	ret
    uvmfree(pagetable, 0);
    80000f7e:	4581                	li	a1,0
    80000f80:	8526                	mv	a0,s1
    80000f82:	00000097          	auipc	ra,0x0
    80000f86:	a54080e7          	jalr	-1452(ra) # 800009d6 <uvmfree>
    return 0;
    80000f8a:	4481                	li	s1,0
    80000f8c:	b7d5                	j	80000f70 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f8e:	4681                	li	a3,0
    80000f90:	4605                	li	a2,1
    80000f92:	040005b7          	lui	a1,0x4000
    80000f96:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f98:	05b2                	slli	a1,a1,0xc
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	fffff097          	auipc	ra,0xfffff
    80000fa0:	770080e7          	jalr	1904(ra) # 8000070c <uvmunmap>
    uvmfree(pagetable, 0);
    80000fa4:	4581                	li	a1,0
    80000fa6:	8526                	mv	a0,s1
    80000fa8:	00000097          	auipc	ra,0x0
    80000fac:	a2e080e7          	jalr	-1490(ra) # 800009d6 <uvmfree>
    return 0;
    80000fb0:	4481                	li	s1,0
    80000fb2:	bf7d                	j	80000f70 <proc_pagetable+0x58>

0000000080000fb4 <proc_freepagetable>:
void proc_freepagetable(pagetable_t pagetable, uint64 sz) {
    80000fb4:	1101                	addi	sp,sp,-32
    80000fb6:	ec06                	sd	ra,24(sp)
    80000fb8:	e822                	sd	s0,16(sp)
    80000fba:	e426                	sd	s1,8(sp)
    80000fbc:	e04a                	sd	s2,0(sp)
    80000fbe:	1000                	addi	s0,sp,32
    80000fc0:	84aa                	mv	s1,a0
    80000fc2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc4:	4681                	li	a3,0
    80000fc6:	4605                	li	a2,1
    80000fc8:	040005b7          	lui	a1,0x4000
    80000fcc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fce:	05b2                	slli	a1,a1,0xc
    80000fd0:	fffff097          	auipc	ra,0xfffff
    80000fd4:	73c080e7          	jalr	1852(ra) # 8000070c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fd8:	4681                	li	a3,0
    80000fda:	4605                	li	a2,1
    80000fdc:	020005b7          	lui	a1,0x2000
    80000fe0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fe2:	05b6                	slli	a1,a1,0xd
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	fffff097          	auipc	ra,0xfffff
    80000fea:	726080e7          	jalr	1830(ra) # 8000070c <uvmunmap>
  uvmfree(pagetable, sz);
    80000fee:	85ca                	mv	a1,s2
    80000ff0:	8526                	mv	a0,s1
    80000ff2:	00000097          	auipc	ra,0x0
    80000ff6:	9e4080e7          	jalr	-1564(ra) # 800009d6 <uvmfree>
}
    80000ffa:	60e2                	ld	ra,24(sp)
    80000ffc:	6442                	ld	s0,16(sp)
    80000ffe:	64a2                	ld	s1,8(sp)
    80001000:	6902                	ld	s2,0(sp)
    80001002:	6105                	addi	sp,sp,32
    80001004:	8082                	ret

0000000080001006 <freeproc>:
static void freeproc(struct proc *p) {
    80001006:	1101                	addi	sp,sp,-32
    80001008:	ec06                	sd	ra,24(sp)
    8000100a:	e822                	sd	s0,16(sp)
    8000100c:	e426                	sd	s1,8(sp)
    8000100e:	1000                	addi	s0,sp,32
    80001010:	84aa                	mv	s1,a0
  if (p->trapframe) kfree((void *)p->trapframe);
    80001012:	6d28                	ld	a0,88(a0)
    80001014:	c509                	beqz	a0,8000101e <freeproc+0x18>
    80001016:	fffff097          	auipc	ra,0xfffff
    8000101a:	006080e7          	jalr	6(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000101e:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable) proc_freepagetable(p->pagetable, p->sz);
    80001022:	68a8                	ld	a0,80(s1)
    80001024:	c511                	beqz	a0,80001030 <freeproc+0x2a>
    80001026:	64ac                	ld	a1,72(s1)
    80001028:	00000097          	auipc	ra,0x0
    8000102c:	f8c080e7          	jalr	-116(ra) # 80000fb4 <proc_freepagetable>
  p->pagetable = 0;
    80001030:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001034:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001038:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000103c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001040:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001044:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001048:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000104c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001050:	0004ac23          	sw	zero,24(s1)
}
    80001054:	60e2                	ld	ra,24(sp)
    80001056:	6442                	ld	s0,16(sp)
    80001058:	64a2                	ld	s1,8(sp)
    8000105a:	6105                	addi	sp,sp,32
    8000105c:	8082                	ret

000000008000105e <allocproc>:
static struct proc *allocproc(void) {
    8000105e:	1101                	addi	sp,sp,-32
    80001060:	ec06                	sd	ra,24(sp)
    80001062:	e822                	sd	s0,16(sp)
    80001064:	e426                	sd	s1,8(sp)
    80001066:	e04a                	sd	s2,0(sp)
    80001068:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    8000106a:	00008497          	auipc	s1,0x8
    8000106e:	ce648493          	addi	s1,s1,-794 # 80008d50 <proc>
    80001072:	0000d917          	auipc	s2,0xd
    80001076:	6de90913          	addi	s2,s2,1758 # 8000e750 <tickslock>
    acquire(&p->lock);
    8000107a:	8526                	mv	a0,s1
    8000107c:	00005097          	auipc	ra,0x5
    80001080:	188080e7          	jalr	392(ra) # 80006204 <acquire>
    if (p->state == UNUSED) {
    80001084:	4c9c                	lw	a5,24(s1)
    80001086:	cf81                	beqz	a5,8000109e <allocproc+0x40>
      release(&p->lock);
    80001088:	8526                	mv	a0,s1
    8000108a:	00005097          	auipc	ra,0x5
    8000108e:	22e080e7          	jalr	558(ra) # 800062b8 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001092:	16848493          	addi	s1,s1,360
    80001096:	ff2492e3          	bne	s1,s2,8000107a <allocproc+0x1c>
  return 0;
    8000109a:	4481                	li	s1,0
    8000109c:	a889                	j	800010ee <allocproc+0x90>
  p->pid = allocpid();
    8000109e:	00000097          	auipc	ra,0x0
    800010a2:	e34080e7          	jalr	-460(ra) # 80000ed2 <allocpid>
    800010a6:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010a8:	4785                	li	a5,1
    800010aa:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    800010ac:	fffff097          	auipc	ra,0xfffff
    800010b0:	06e080e7          	jalr	110(ra) # 8000011a <kalloc>
    800010b4:	892a                	mv	s2,a0
    800010b6:	eca8                	sd	a0,88(s1)
    800010b8:	c131                	beqz	a0,800010fc <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010ba:	8526                	mv	a0,s1
    800010bc:	00000097          	auipc	ra,0x0
    800010c0:	e5c080e7          	jalr	-420(ra) # 80000f18 <proc_pagetable>
    800010c4:	892a                	mv	s2,a0
    800010c6:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    800010c8:	c531                	beqz	a0,80001114 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010ca:	07000613          	li	a2,112
    800010ce:	4581                	li	a1,0
    800010d0:	06048513          	addi	a0,s1,96
    800010d4:	fffff097          	auipc	ra,0xfffff
    800010d8:	0a6080e7          	jalr	166(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010dc:	00000797          	auipc	a5,0x0
    800010e0:	db078793          	addi	a5,a5,-592 # 80000e8c <forkret>
    800010e4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010e6:	60bc                	ld	a5,64(s1)
    800010e8:	6705                	lui	a4,0x1
    800010ea:	97ba                	add	a5,a5,a4
    800010ec:	f4bc                	sd	a5,104(s1)
}
    800010ee:	8526                	mv	a0,s1
    800010f0:	60e2                	ld	ra,24(sp)
    800010f2:	6442                	ld	s0,16(sp)
    800010f4:	64a2                	ld	s1,8(sp)
    800010f6:	6902                	ld	s2,0(sp)
    800010f8:	6105                	addi	sp,sp,32
    800010fa:	8082                	ret
    freeproc(p);
    800010fc:	8526                	mv	a0,s1
    800010fe:	00000097          	auipc	ra,0x0
    80001102:	f08080e7          	jalr	-248(ra) # 80001006 <freeproc>
    release(&p->lock);
    80001106:	8526                	mv	a0,s1
    80001108:	00005097          	auipc	ra,0x5
    8000110c:	1b0080e7          	jalr	432(ra) # 800062b8 <release>
    return 0;
    80001110:	84ca                	mv	s1,s2
    80001112:	bff1                	j	800010ee <allocproc+0x90>
    freeproc(p);
    80001114:	8526                	mv	a0,s1
    80001116:	00000097          	auipc	ra,0x0
    8000111a:	ef0080e7          	jalr	-272(ra) # 80001006 <freeproc>
    release(&p->lock);
    8000111e:	8526                	mv	a0,s1
    80001120:	00005097          	auipc	ra,0x5
    80001124:	198080e7          	jalr	408(ra) # 800062b8 <release>
    return 0;
    80001128:	84ca                	mv	s1,s2
    8000112a:	b7d1                	j	800010ee <allocproc+0x90>

000000008000112c <userinit>:
void userinit(void) {
    8000112c:	1101                	addi	sp,sp,-32
    8000112e:	ec06                	sd	ra,24(sp)
    80001130:	e822                	sd	s0,16(sp)
    80001132:	e426                	sd	s1,8(sp)
    80001134:	1000                	addi	s0,sp,32
  p = allocproc();
    80001136:	00000097          	auipc	ra,0x0
    8000113a:	f28080e7          	jalr	-216(ra) # 8000105e <allocproc>
    8000113e:	84aa                	mv	s1,a0
  initproc = p;
    80001140:	00007797          	auipc	a5,0x7
    80001144:	7aa7b023          	sd	a0,1952(a5) # 800088e0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001148:	03400613          	li	a2,52
    8000114c:	00007597          	auipc	a1,0x7
    80001150:	72458593          	addi	a1,a1,1828 # 80008870 <initcode>
    80001154:	6928                	ld	a0,80(a0)
    80001156:	fffff097          	auipc	ra,0xfffff
    8000115a:	6a8080e7          	jalr	1704(ra) # 800007fe <uvmfirst>
  p->sz = PGSIZE;
    8000115e:	6785                	lui	a5,0x1
    80001160:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001162:	6cb8                	ld	a4,88(s1)
    80001164:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001168:	6cb8                	ld	a4,88(s1)
    8000116a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000116c:	4641                	li	a2,16
    8000116e:	00007597          	auipc	a1,0x7
    80001172:	01258593          	addi	a1,a1,18 # 80008180 <etext+0x180>
    80001176:	15848513          	addi	a0,s1,344
    8000117a:	fffff097          	auipc	ra,0xfffff
    8000117e:	14a080e7          	jalr	330(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    80001182:	00007517          	auipc	a0,0x7
    80001186:	00e50513          	addi	a0,a0,14 # 80008190 <etext+0x190>
    8000118a:	00002097          	auipc	ra,0x2
    8000118e:	23e080e7          	jalr	574(ra) # 800033c8 <namei>
    80001192:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001196:	478d                	li	a5,3
    80001198:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000119a:	8526                	mv	a0,s1
    8000119c:	00005097          	auipc	ra,0x5
    800011a0:	11c080e7          	jalr	284(ra) # 800062b8 <release>
}
    800011a4:	60e2                	ld	ra,24(sp)
    800011a6:	6442                	ld	s0,16(sp)
    800011a8:	64a2                	ld	s1,8(sp)
    800011aa:	6105                	addi	sp,sp,32
    800011ac:	8082                	ret

00000000800011ae <growproc>:
int growproc(int n) {
    800011ae:	1101                	addi	sp,sp,-32
    800011b0:	ec06                	sd	ra,24(sp)
    800011b2:	e822                	sd	s0,16(sp)
    800011b4:	e426                	sd	s1,8(sp)
    800011b6:	e04a                	sd	s2,0(sp)
    800011b8:	1000                	addi	s0,sp,32
    800011ba:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011bc:	00000097          	auipc	ra,0x0
    800011c0:	c98080e7          	jalr	-872(ra) # 80000e54 <myproc>
    800011c4:	84aa                	mv	s1,a0
  sz = p->sz;
    800011c6:	652c                	ld	a1,72(a0)
  if (n > 0) {
    800011c8:	01204c63          	bgtz	s2,800011e0 <growproc+0x32>
  } else if (n < 0) {
    800011cc:	02094663          	bltz	s2,800011f8 <growproc+0x4a>
  p->sz = sz;
    800011d0:	e4ac                	sd	a1,72(s1)
  return 0;
    800011d2:	4501                	li	a0,0
}
    800011d4:	60e2                	ld	ra,24(sp)
    800011d6:	6442                	ld	s0,16(sp)
    800011d8:	64a2                	ld	s1,8(sp)
    800011da:	6902                	ld	s2,0(sp)
    800011dc:	6105                	addi	sp,sp,32
    800011de:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800011e0:	4691                	li	a3,4
    800011e2:	00b90633          	add	a2,s2,a1
    800011e6:	6928                	ld	a0,80(a0)
    800011e8:	fffff097          	auipc	ra,0xfffff
    800011ec:	6d0080e7          	jalr	1744(ra) # 800008b8 <uvmalloc>
    800011f0:	85aa                	mv	a1,a0
    800011f2:	fd79                	bnez	a0,800011d0 <growproc+0x22>
      return -1;
    800011f4:	557d                	li	a0,-1
    800011f6:	bff9                	j	800011d4 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011f8:	00b90633          	add	a2,s2,a1
    800011fc:	6928                	ld	a0,80(a0)
    800011fe:	fffff097          	auipc	ra,0xfffff
    80001202:	672080e7          	jalr	1650(ra) # 80000870 <uvmdealloc>
    80001206:	85aa                	mv	a1,a0
    80001208:	b7e1                	j	800011d0 <growproc+0x22>

000000008000120a <fork>:
int fork(void) {
    8000120a:	7139                	addi	sp,sp,-64
    8000120c:	fc06                	sd	ra,56(sp)
    8000120e:	f822                	sd	s0,48(sp)
    80001210:	f426                	sd	s1,40(sp)
    80001212:	f04a                	sd	s2,32(sp)
    80001214:	ec4e                	sd	s3,24(sp)
    80001216:	e852                	sd	s4,16(sp)
    80001218:	e456                	sd	s5,8(sp)
    8000121a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000121c:	00000097          	auipc	ra,0x0
    80001220:	c38080e7          	jalr	-968(ra) # 80000e54 <myproc>
    80001224:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    80001226:	00000097          	auipc	ra,0x0
    8000122a:	e38080e7          	jalr	-456(ra) # 8000105e <allocproc>
    8000122e:	10050c63          	beqz	a0,80001346 <fork+0x13c>
    80001232:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001234:	048ab603          	ld	a2,72(s5)
    80001238:	692c                	ld	a1,80(a0)
    8000123a:	050ab503          	ld	a0,80(s5)
    8000123e:	fffff097          	auipc	ra,0xfffff
    80001242:	7d2080e7          	jalr	2002(ra) # 80000a10 <uvmcopy>
    80001246:	04054863          	bltz	a0,80001296 <fork+0x8c>
  np->sz = p->sz;
    8000124a:	048ab783          	ld	a5,72(s5)
    8000124e:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001252:	058ab683          	ld	a3,88(s5)
    80001256:	87b6                	mv	a5,a3
    80001258:	058a3703          	ld	a4,88(s4)
    8000125c:	12068693          	addi	a3,a3,288
    80001260:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001264:	6788                	ld	a0,8(a5)
    80001266:	6b8c                	ld	a1,16(a5)
    80001268:	6f90                	ld	a2,24(a5)
    8000126a:	01073023          	sd	a6,0(a4)
    8000126e:	e708                	sd	a0,8(a4)
    80001270:	eb0c                	sd	a1,16(a4)
    80001272:	ef10                	sd	a2,24(a4)
    80001274:	02078793          	addi	a5,a5,32
    80001278:	02070713          	addi	a4,a4,32
    8000127c:	fed792e3          	bne	a5,a3,80001260 <fork+0x56>
  np->trapframe->a0 = 0;
    80001280:	058a3783          	ld	a5,88(s4)
    80001284:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80001288:	0d0a8493          	addi	s1,s5,208
    8000128c:	0d0a0913          	addi	s2,s4,208
    80001290:	150a8993          	addi	s3,s5,336
    80001294:	a00d                	j	800012b6 <fork+0xac>
    freeproc(np);
    80001296:	8552                	mv	a0,s4
    80001298:	00000097          	auipc	ra,0x0
    8000129c:	d6e080e7          	jalr	-658(ra) # 80001006 <freeproc>
    release(&np->lock);
    800012a0:	8552                	mv	a0,s4
    800012a2:	00005097          	auipc	ra,0x5
    800012a6:	016080e7          	jalr	22(ra) # 800062b8 <release>
    return -1;
    800012aa:	597d                	li	s2,-1
    800012ac:	a059                	j	80001332 <fork+0x128>
  for (i = 0; i < NOFILE; i++)
    800012ae:	04a1                	addi	s1,s1,8
    800012b0:	0921                	addi	s2,s2,8
    800012b2:	01348b63          	beq	s1,s3,800012c8 <fork+0xbe>
    if (p->ofile[i]) np->ofile[i] = filedup(p->ofile[i]);
    800012b6:	6088                	ld	a0,0(s1)
    800012b8:	d97d                	beqz	a0,800012ae <fork+0xa4>
    800012ba:	00002097          	auipc	ra,0x2
    800012be:	7a4080e7          	jalr	1956(ra) # 80003a5e <filedup>
    800012c2:	00a93023          	sd	a0,0(s2)
    800012c6:	b7e5                	j	800012ae <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012c8:	150ab503          	ld	a0,336(s5)
    800012cc:	00002097          	auipc	ra,0x2
    800012d0:	912080e7          	jalr	-1774(ra) # 80002bde <idup>
    800012d4:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012d8:	4641                	li	a2,16
    800012da:	158a8593          	addi	a1,s5,344
    800012de:	158a0513          	addi	a0,s4,344
    800012e2:	fffff097          	auipc	ra,0xfffff
    800012e6:	fe2080e7          	jalr	-30(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    800012ea:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800012ee:	8552                	mv	a0,s4
    800012f0:	00005097          	auipc	ra,0x5
    800012f4:	fc8080e7          	jalr	-56(ra) # 800062b8 <release>
  acquire(&wait_lock);
    800012f8:	00007497          	auipc	s1,0x7
    800012fc:	64048493          	addi	s1,s1,1600 # 80008938 <wait_lock>
    80001300:	8526                	mv	a0,s1
    80001302:	00005097          	auipc	ra,0x5
    80001306:	f02080e7          	jalr	-254(ra) # 80006204 <acquire>
  np->parent = p;
    8000130a:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000130e:	8526                	mv	a0,s1
    80001310:	00005097          	auipc	ra,0x5
    80001314:	fa8080e7          	jalr	-88(ra) # 800062b8 <release>
  acquire(&np->lock);
    80001318:	8552                	mv	a0,s4
    8000131a:	00005097          	auipc	ra,0x5
    8000131e:	eea080e7          	jalr	-278(ra) # 80006204 <acquire>
  np->state = RUNNABLE;
    80001322:	478d                	li	a5,3
    80001324:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001328:	8552                	mv	a0,s4
    8000132a:	00005097          	auipc	ra,0x5
    8000132e:	f8e080e7          	jalr	-114(ra) # 800062b8 <release>
}
    80001332:	854a                	mv	a0,s2
    80001334:	70e2                	ld	ra,56(sp)
    80001336:	7442                	ld	s0,48(sp)
    80001338:	74a2                	ld	s1,40(sp)
    8000133a:	7902                	ld	s2,32(sp)
    8000133c:	69e2                	ld	s3,24(sp)
    8000133e:	6a42                	ld	s4,16(sp)
    80001340:	6aa2                	ld	s5,8(sp)
    80001342:	6121                	addi	sp,sp,64
    80001344:	8082                	ret
    return -1;
    80001346:	597d                	li	s2,-1
    80001348:	b7ed                	j	80001332 <fork+0x128>

000000008000134a <scheduler>:
void scheduler(void) {
    8000134a:	7139                	addi	sp,sp,-64
    8000134c:	fc06                	sd	ra,56(sp)
    8000134e:	f822                	sd	s0,48(sp)
    80001350:	f426                	sd	s1,40(sp)
    80001352:	f04a                	sd	s2,32(sp)
    80001354:	ec4e                	sd	s3,24(sp)
    80001356:	e852                	sd	s4,16(sp)
    80001358:	e456                	sd	s5,8(sp)
    8000135a:	e05a                	sd	s6,0(sp)
    8000135c:	0080                	addi	s0,sp,64
    8000135e:	8792                	mv	a5,tp
  int id = r_tp();
    80001360:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001362:	00779a93          	slli	s5,a5,0x7
    80001366:	00007717          	auipc	a4,0x7
    8000136a:	5ba70713          	addi	a4,a4,1466 # 80008920 <pid_lock>
    8000136e:	9756                	add	a4,a4,s5
    80001370:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001374:	00007717          	auipc	a4,0x7
    80001378:	5e470713          	addi	a4,a4,1508 # 80008958 <cpus+0x8>
    8000137c:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE) {
    8000137e:	498d                	li	s3,3
        p->state = RUNNING;
    80001380:	4b11                	li	s6,4
        c->proc = p;
    80001382:	079e                	slli	a5,a5,0x7
    80001384:	00007a17          	auipc	s4,0x7
    80001388:	59ca0a13          	addi	s4,s4,1436 # 80008920 <pid_lock>
    8000138c:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++) {
    8000138e:	0000d917          	auipc	s2,0xd
    80001392:	3c290913          	addi	s2,s2,962 # 8000e750 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001396:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    8000139a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000139e:	10079073          	csrw	sstatus,a5
    800013a2:	00008497          	auipc	s1,0x8
    800013a6:	9ae48493          	addi	s1,s1,-1618 # 80008d50 <proc>
    800013aa:	a811                	j	800013be <scheduler+0x74>
      release(&p->lock);
    800013ac:	8526                	mv	a0,s1
    800013ae:	00005097          	auipc	ra,0x5
    800013b2:	f0a080e7          	jalr	-246(ra) # 800062b8 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    800013b6:	16848493          	addi	s1,s1,360
    800013ba:	fd248ee3          	beq	s1,s2,80001396 <scheduler+0x4c>
      acquire(&p->lock);
    800013be:	8526                	mv	a0,s1
    800013c0:	00005097          	auipc	ra,0x5
    800013c4:	e44080e7          	jalr	-444(ra) # 80006204 <acquire>
      if (p->state == RUNNABLE) {
    800013c8:	4c9c                	lw	a5,24(s1)
    800013ca:	ff3791e3          	bne	a5,s3,800013ac <scheduler+0x62>
        p->state = RUNNING;
    800013ce:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013d2:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013d6:	06048593          	addi	a1,s1,96
    800013da:	8556                	mv	a0,s5
    800013dc:	00000097          	auipc	ra,0x0
    800013e0:	764080e7          	jalr	1892(ra) # 80001b40 <swtch>
        c->proc = 0;
    800013e4:	020a3823          	sd	zero,48(s4)
    800013e8:	b7d1                	j	800013ac <scheduler+0x62>

00000000800013ea <sched>:
void sched(void) {
    800013ea:	7179                	addi	sp,sp,-48
    800013ec:	f406                	sd	ra,40(sp)
    800013ee:	f022                	sd	s0,32(sp)
    800013f0:	ec26                	sd	s1,24(sp)
    800013f2:	e84a                	sd	s2,16(sp)
    800013f4:	e44e                	sd	s3,8(sp)
    800013f6:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013f8:	00000097          	auipc	ra,0x0
    800013fc:	a5c080e7          	jalr	-1444(ra) # 80000e54 <myproc>
    80001400:	84aa                	mv	s1,a0
  if (!holding(&p->lock)) panic("sched p->lock");
    80001402:	00005097          	auipc	ra,0x5
    80001406:	d88080e7          	jalr	-632(ra) # 8000618a <holding>
    8000140a:	c93d                	beqz	a0,80001480 <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    8000140c:	8792                	mv	a5,tp
  if (mycpu()->noff != 1) panic("sched locks");
    8000140e:	2781                	sext.w	a5,a5
    80001410:	079e                	slli	a5,a5,0x7
    80001412:	00007717          	auipc	a4,0x7
    80001416:	50e70713          	addi	a4,a4,1294 # 80008920 <pid_lock>
    8000141a:	97ba                	add	a5,a5,a4
    8000141c:	0a87a703          	lw	a4,168(a5)
    80001420:	4785                	li	a5,1
    80001422:	06f71763          	bne	a4,a5,80001490 <sched+0xa6>
  if (p->state == RUNNING) panic("sched running");
    80001426:	4c98                	lw	a4,24(s1)
    80001428:	4791                	li	a5,4
    8000142a:	06f70b63          	beq	a4,a5,800014a0 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000142e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001432:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("sched interruptible");
    80001434:	efb5                	bnez	a5,800014b0 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    80001436:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001438:	00007917          	auipc	s2,0x7
    8000143c:	4e890913          	addi	s2,s2,1256 # 80008920 <pid_lock>
    80001440:	2781                	sext.w	a5,a5
    80001442:	079e                	slli	a5,a5,0x7
    80001444:	97ca                	add	a5,a5,s2
    80001446:	0ac7a983          	lw	s3,172(a5)
    8000144a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000144c:	2781                	sext.w	a5,a5
    8000144e:	079e                	slli	a5,a5,0x7
    80001450:	00007597          	auipc	a1,0x7
    80001454:	50858593          	addi	a1,a1,1288 # 80008958 <cpus+0x8>
    80001458:	95be                	add	a1,a1,a5
    8000145a:	06048513          	addi	a0,s1,96
    8000145e:	00000097          	auipc	ra,0x0
    80001462:	6e2080e7          	jalr	1762(ra) # 80001b40 <swtch>
    80001466:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001468:	2781                	sext.w	a5,a5
    8000146a:	079e                	slli	a5,a5,0x7
    8000146c:	993e                	add	s2,s2,a5
    8000146e:	0b392623          	sw	s3,172(s2)
}
    80001472:	70a2                	ld	ra,40(sp)
    80001474:	7402                	ld	s0,32(sp)
    80001476:	64e2                	ld	s1,24(sp)
    80001478:	6942                	ld	s2,16(sp)
    8000147a:	69a2                	ld	s3,8(sp)
    8000147c:	6145                	addi	sp,sp,48
    8000147e:	8082                	ret
  if (!holding(&p->lock)) panic("sched p->lock");
    80001480:	00007517          	auipc	a0,0x7
    80001484:	d1850513          	addi	a0,a0,-744 # 80008198 <etext+0x198>
    80001488:	00005097          	auipc	ra,0x5
    8000148c:	844080e7          	jalr	-1980(ra) # 80005ccc <panic>
  if (mycpu()->noff != 1) panic("sched locks");
    80001490:	00007517          	auipc	a0,0x7
    80001494:	d1850513          	addi	a0,a0,-744 # 800081a8 <etext+0x1a8>
    80001498:	00005097          	auipc	ra,0x5
    8000149c:	834080e7          	jalr	-1996(ra) # 80005ccc <panic>
  if (p->state == RUNNING) panic("sched running");
    800014a0:	00007517          	auipc	a0,0x7
    800014a4:	d1850513          	addi	a0,a0,-744 # 800081b8 <etext+0x1b8>
    800014a8:	00005097          	auipc	ra,0x5
    800014ac:	824080e7          	jalr	-2012(ra) # 80005ccc <panic>
  if (intr_get()) panic("sched interruptible");
    800014b0:	00007517          	auipc	a0,0x7
    800014b4:	d1850513          	addi	a0,a0,-744 # 800081c8 <etext+0x1c8>
    800014b8:	00005097          	auipc	ra,0x5
    800014bc:	814080e7          	jalr	-2028(ra) # 80005ccc <panic>

00000000800014c0 <yield>:
void yield(void) {
    800014c0:	1101                	addi	sp,sp,-32
    800014c2:	ec06                	sd	ra,24(sp)
    800014c4:	e822                	sd	s0,16(sp)
    800014c6:	e426                	sd	s1,8(sp)
    800014c8:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014ca:	00000097          	auipc	ra,0x0
    800014ce:	98a080e7          	jalr	-1654(ra) # 80000e54 <myproc>
    800014d2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014d4:	00005097          	auipc	ra,0x5
    800014d8:	d30080e7          	jalr	-720(ra) # 80006204 <acquire>
  p->state = RUNNABLE;
    800014dc:	478d                	li	a5,3
    800014de:	cc9c                	sw	a5,24(s1)
  sched();
    800014e0:	00000097          	auipc	ra,0x0
    800014e4:	f0a080e7          	jalr	-246(ra) # 800013ea <sched>
  release(&p->lock);
    800014e8:	8526                	mv	a0,s1
    800014ea:	00005097          	auipc	ra,0x5
    800014ee:	dce080e7          	jalr	-562(ra) # 800062b8 <release>
}
    800014f2:	60e2                	ld	ra,24(sp)
    800014f4:	6442                	ld	s0,16(sp)
    800014f6:	64a2                	ld	s1,8(sp)
    800014f8:	6105                	addi	sp,sp,32
    800014fa:	8082                	ret

00000000800014fc <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk) {
    800014fc:	7179                	addi	sp,sp,-48
    800014fe:	f406                	sd	ra,40(sp)
    80001500:	f022                	sd	s0,32(sp)
    80001502:	ec26                	sd	s1,24(sp)
    80001504:	e84a                	sd	s2,16(sp)
    80001506:	e44e                	sd	s3,8(sp)
    80001508:	1800                	addi	s0,sp,48
    8000150a:	89aa                	mv	s3,a0
    8000150c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000150e:	00000097          	auipc	ra,0x0
    80001512:	946080e7          	jalr	-1722(ra) # 80000e54 <myproc>
    80001516:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  // DOC: sleeplock1
    80001518:	00005097          	auipc	ra,0x5
    8000151c:	cec080e7          	jalr	-788(ra) # 80006204 <acquire>
  release(lk);
    80001520:	854a                	mv	a0,s2
    80001522:	00005097          	auipc	ra,0x5
    80001526:	d96080e7          	jalr	-618(ra) # 800062b8 <release>

  // Go to sleep.
  p->chan = chan;
    8000152a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000152e:	4789                	li	a5,2
    80001530:	cc9c                	sw	a5,24(s1)

  sched();
    80001532:	00000097          	auipc	ra,0x0
    80001536:	eb8080e7          	jalr	-328(ra) # 800013ea <sched>

  // Tidy up.
  p->chan = 0;
    8000153a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000153e:	8526                	mv	a0,s1
    80001540:	00005097          	auipc	ra,0x5
    80001544:	d78080e7          	jalr	-648(ra) # 800062b8 <release>
  acquire(lk);
    80001548:	854a                	mv	a0,s2
    8000154a:	00005097          	auipc	ra,0x5
    8000154e:	cba080e7          	jalr	-838(ra) # 80006204 <acquire>
}
    80001552:	70a2                	ld	ra,40(sp)
    80001554:	7402                	ld	s0,32(sp)
    80001556:	64e2                	ld	s1,24(sp)
    80001558:	6942                	ld	s2,16(sp)
    8000155a:	69a2                	ld	s3,8(sp)
    8000155c:	6145                	addi	sp,sp,48
    8000155e:	8082                	ret

0000000080001560 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan) {
    80001560:	7139                	addi	sp,sp,-64
    80001562:	fc06                	sd	ra,56(sp)
    80001564:	f822                	sd	s0,48(sp)
    80001566:	f426                	sd	s1,40(sp)
    80001568:	f04a                	sd	s2,32(sp)
    8000156a:	ec4e                	sd	s3,24(sp)
    8000156c:	e852                	sd	s4,16(sp)
    8000156e:	e456                	sd	s5,8(sp)
    80001570:	0080                	addi	s0,sp,64
    80001572:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001574:	00007497          	auipc	s1,0x7
    80001578:	7dc48493          	addi	s1,s1,2012 # 80008d50 <proc>
    if (p != myproc()) {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan) {
    8000157c:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000157e:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    80001580:	0000d917          	auipc	s2,0xd
    80001584:	1d090913          	addi	s2,s2,464 # 8000e750 <tickslock>
    80001588:	a811                	j	8000159c <wakeup+0x3c>
      }
      release(&p->lock);
    8000158a:	8526                	mv	a0,s1
    8000158c:	00005097          	auipc	ra,0x5
    80001590:	d2c080e7          	jalr	-724(ra) # 800062b8 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001594:	16848493          	addi	s1,s1,360
    80001598:	03248663          	beq	s1,s2,800015c4 <wakeup+0x64>
    if (p != myproc()) {
    8000159c:	00000097          	auipc	ra,0x0
    800015a0:	8b8080e7          	jalr	-1864(ra) # 80000e54 <myproc>
    800015a4:	fea488e3          	beq	s1,a0,80001594 <wakeup+0x34>
      acquire(&p->lock);
    800015a8:	8526                	mv	a0,s1
    800015aa:	00005097          	auipc	ra,0x5
    800015ae:	c5a080e7          	jalr	-934(ra) # 80006204 <acquire>
      if (p->state == SLEEPING && p->chan == chan) {
    800015b2:	4c9c                	lw	a5,24(s1)
    800015b4:	fd379be3          	bne	a5,s3,8000158a <wakeup+0x2a>
    800015b8:	709c                	ld	a5,32(s1)
    800015ba:	fd4798e3          	bne	a5,s4,8000158a <wakeup+0x2a>
        p->state = RUNNABLE;
    800015be:	0154ac23          	sw	s5,24(s1)
    800015c2:	b7e1                	j	8000158a <wakeup+0x2a>
    }
  }
}
    800015c4:	70e2                	ld	ra,56(sp)
    800015c6:	7442                	ld	s0,48(sp)
    800015c8:	74a2                	ld	s1,40(sp)
    800015ca:	7902                	ld	s2,32(sp)
    800015cc:	69e2                	ld	s3,24(sp)
    800015ce:	6a42                	ld	s4,16(sp)
    800015d0:	6aa2                	ld	s5,8(sp)
    800015d2:	6121                	addi	sp,sp,64
    800015d4:	8082                	ret

00000000800015d6 <reparent>:
void reparent(struct proc *p) {
    800015d6:	7179                	addi	sp,sp,-48
    800015d8:	f406                	sd	ra,40(sp)
    800015da:	f022                	sd	s0,32(sp)
    800015dc:	ec26                	sd	s1,24(sp)
    800015de:	e84a                	sd	s2,16(sp)
    800015e0:	e44e                	sd	s3,8(sp)
    800015e2:	e052                	sd	s4,0(sp)
    800015e4:	1800                	addi	s0,sp,48
    800015e6:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    800015e8:	00007497          	auipc	s1,0x7
    800015ec:	76848493          	addi	s1,s1,1896 # 80008d50 <proc>
      pp->parent = initproc;
    800015f0:	00007a17          	auipc	s4,0x7
    800015f4:	2f0a0a13          	addi	s4,s4,752 # 800088e0 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    800015f8:	0000d997          	auipc	s3,0xd
    800015fc:	15898993          	addi	s3,s3,344 # 8000e750 <tickslock>
    80001600:	a029                	j	8000160a <reparent+0x34>
    80001602:	16848493          	addi	s1,s1,360
    80001606:	01348d63          	beq	s1,s3,80001620 <reparent+0x4a>
    if (pp->parent == p) {
    8000160a:	7c9c                	ld	a5,56(s1)
    8000160c:	ff279be3          	bne	a5,s2,80001602 <reparent+0x2c>
      pp->parent = initproc;
    80001610:	000a3503          	ld	a0,0(s4)
    80001614:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001616:	00000097          	auipc	ra,0x0
    8000161a:	f4a080e7          	jalr	-182(ra) # 80001560 <wakeup>
    8000161e:	b7d5                	j	80001602 <reparent+0x2c>
}
    80001620:	70a2                	ld	ra,40(sp)
    80001622:	7402                	ld	s0,32(sp)
    80001624:	64e2                	ld	s1,24(sp)
    80001626:	6942                	ld	s2,16(sp)
    80001628:	69a2                	ld	s3,8(sp)
    8000162a:	6a02                	ld	s4,0(sp)
    8000162c:	6145                	addi	sp,sp,48
    8000162e:	8082                	ret

0000000080001630 <exit>:
void exit(int status) {
    80001630:	7179                	addi	sp,sp,-48
    80001632:	f406                	sd	ra,40(sp)
    80001634:	f022                	sd	s0,32(sp)
    80001636:	ec26                	sd	s1,24(sp)
    80001638:	e84a                	sd	s2,16(sp)
    8000163a:	e44e                	sd	s3,8(sp)
    8000163c:	e052                	sd	s4,0(sp)
    8000163e:	1800                	addi	s0,sp,48
    80001640:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001642:	00000097          	auipc	ra,0x0
    80001646:	812080e7          	jalr	-2030(ra) # 80000e54 <myproc>
    8000164a:	89aa                	mv	s3,a0
  if (p == initproc) panic("init exiting");
    8000164c:	00007797          	auipc	a5,0x7
    80001650:	2947b783          	ld	a5,660(a5) # 800088e0 <initproc>
    80001654:	0d050493          	addi	s1,a0,208
    80001658:	15050913          	addi	s2,a0,336
    8000165c:	02a79363          	bne	a5,a0,80001682 <exit+0x52>
    80001660:	00007517          	auipc	a0,0x7
    80001664:	b8050513          	addi	a0,a0,-1152 # 800081e0 <etext+0x1e0>
    80001668:	00004097          	auipc	ra,0x4
    8000166c:	664080e7          	jalr	1636(ra) # 80005ccc <panic>
      fileclose(f);
    80001670:	00002097          	auipc	ra,0x2
    80001674:	440080e7          	jalr	1088(ra) # 80003ab0 <fileclose>
      p->ofile[fd] = 0;
    80001678:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    8000167c:	04a1                	addi	s1,s1,8
    8000167e:	01248563          	beq	s1,s2,80001688 <exit+0x58>
    if (p->ofile[fd]) {
    80001682:	6088                	ld	a0,0(s1)
    80001684:	f575                	bnez	a0,80001670 <exit+0x40>
    80001686:	bfdd                	j	8000167c <exit+0x4c>
  begin_op();
    80001688:	00002097          	auipc	ra,0x2
    8000168c:	f60080e7          	jalr	-160(ra) # 800035e8 <begin_op>
  iput(p->cwd);
    80001690:	1509b503          	ld	a0,336(s3)
    80001694:	00001097          	auipc	ra,0x1
    80001698:	742080e7          	jalr	1858(ra) # 80002dd6 <iput>
  end_op();
    8000169c:	00002097          	auipc	ra,0x2
    800016a0:	fca080e7          	jalr	-54(ra) # 80003666 <end_op>
  p->cwd = 0;
    800016a4:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016a8:	00007497          	auipc	s1,0x7
    800016ac:	29048493          	addi	s1,s1,656 # 80008938 <wait_lock>
    800016b0:	8526                	mv	a0,s1
    800016b2:	00005097          	auipc	ra,0x5
    800016b6:	b52080e7          	jalr	-1198(ra) # 80006204 <acquire>
  reparent(p);
    800016ba:	854e                	mv	a0,s3
    800016bc:	00000097          	auipc	ra,0x0
    800016c0:	f1a080e7          	jalr	-230(ra) # 800015d6 <reparent>
  wakeup(p->parent);
    800016c4:	0389b503          	ld	a0,56(s3)
    800016c8:	00000097          	auipc	ra,0x0
    800016cc:	e98080e7          	jalr	-360(ra) # 80001560 <wakeup>
  acquire(&p->lock);
    800016d0:	854e                	mv	a0,s3
    800016d2:	00005097          	auipc	ra,0x5
    800016d6:	b32080e7          	jalr	-1230(ra) # 80006204 <acquire>
  p->xstate = status;
    800016da:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016de:	4795                	li	a5,5
    800016e0:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016e4:	8526                	mv	a0,s1
    800016e6:	00005097          	auipc	ra,0x5
    800016ea:	bd2080e7          	jalr	-1070(ra) # 800062b8 <release>
  sched();
    800016ee:	00000097          	auipc	ra,0x0
    800016f2:	cfc080e7          	jalr	-772(ra) # 800013ea <sched>
  panic("zombie exit");
    800016f6:	00007517          	auipc	a0,0x7
    800016fa:	afa50513          	addi	a0,a0,-1286 # 800081f0 <etext+0x1f0>
    800016fe:	00004097          	auipc	ra,0x4
    80001702:	5ce080e7          	jalr	1486(ra) # 80005ccc <panic>

0000000080001706 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid) {
    80001706:	7179                	addi	sp,sp,-48
    80001708:	f406                	sd	ra,40(sp)
    8000170a:	f022                	sd	s0,32(sp)
    8000170c:	ec26                	sd	s1,24(sp)
    8000170e:	e84a                	sd	s2,16(sp)
    80001710:	e44e                	sd	s3,8(sp)
    80001712:	1800                	addi	s0,sp,48
    80001714:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001716:	00007497          	auipc	s1,0x7
    8000171a:	63a48493          	addi	s1,s1,1594 # 80008d50 <proc>
    8000171e:	0000d997          	auipc	s3,0xd
    80001722:	03298993          	addi	s3,s3,50 # 8000e750 <tickslock>
    acquire(&p->lock);
    80001726:	8526                	mv	a0,s1
    80001728:	00005097          	auipc	ra,0x5
    8000172c:	adc080e7          	jalr	-1316(ra) # 80006204 <acquire>
    if (p->pid == pid) {
    80001730:	589c                	lw	a5,48(s1)
    80001732:	01278d63          	beq	a5,s2,8000174c <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001736:	8526                	mv	a0,s1
    80001738:	00005097          	auipc	ra,0x5
    8000173c:	b80080e7          	jalr	-1152(ra) # 800062b8 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001740:	16848493          	addi	s1,s1,360
    80001744:	ff3491e3          	bne	s1,s3,80001726 <kill+0x20>
  }
  return -1;
    80001748:	557d                	li	a0,-1
    8000174a:	a829                	j	80001764 <kill+0x5e>
      p->killed = 1;
    8000174c:	4785                	li	a5,1
    8000174e:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    80001750:	4c98                	lw	a4,24(s1)
    80001752:	4789                	li	a5,2
    80001754:	00f70f63          	beq	a4,a5,80001772 <kill+0x6c>
      release(&p->lock);
    80001758:	8526                	mv	a0,s1
    8000175a:	00005097          	auipc	ra,0x5
    8000175e:	b5e080e7          	jalr	-1186(ra) # 800062b8 <release>
      return 0;
    80001762:	4501                	li	a0,0
}
    80001764:	70a2                	ld	ra,40(sp)
    80001766:	7402                	ld	s0,32(sp)
    80001768:	64e2                	ld	s1,24(sp)
    8000176a:	6942                	ld	s2,16(sp)
    8000176c:	69a2                	ld	s3,8(sp)
    8000176e:	6145                	addi	sp,sp,48
    80001770:	8082                	ret
        p->state = RUNNABLE;
    80001772:	478d                	li	a5,3
    80001774:	cc9c                	sw	a5,24(s1)
    80001776:	b7cd                	j	80001758 <kill+0x52>

0000000080001778 <setkilled>:

void setkilled(struct proc *p) {
    80001778:	1101                	addi	sp,sp,-32
    8000177a:	ec06                	sd	ra,24(sp)
    8000177c:	e822                	sd	s0,16(sp)
    8000177e:	e426                	sd	s1,8(sp)
    80001780:	1000                	addi	s0,sp,32
    80001782:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001784:	00005097          	auipc	ra,0x5
    80001788:	a80080e7          	jalr	-1408(ra) # 80006204 <acquire>
  p->killed = 1;
    8000178c:	4785                	li	a5,1
    8000178e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001790:	8526                	mv	a0,s1
    80001792:	00005097          	auipc	ra,0x5
    80001796:	b26080e7          	jalr	-1242(ra) # 800062b8 <release>
}
    8000179a:	60e2                	ld	ra,24(sp)
    8000179c:	6442                	ld	s0,16(sp)
    8000179e:	64a2                	ld	s1,8(sp)
    800017a0:	6105                	addi	sp,sp,32
    800017a2:	8082                	ret

00000000800017a4 <killed>:

int killed(struct proc *p) {
    800017a4:	1101                	addi	sp,sp,-32
    800017a6:	ec06                	sd	ra,24(sp)
    800017a8:	e822                	sd	s0,16(sp)
    800017aa:	e426                	sd	s1,8(sp)
    800017ac:	e04a                	sd	s2,0(sp)
    800017ae:	1000                	addi	s0,sp,32
    800017b0:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    800017b2:	00005097          	auipc	ra,0x5
    800017b6:	a52080e7          	jalr	-1454(ra) # 80006204 <acquire>
  k = p->killed;
    800017ba:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017be:	8526                	mv	a0,s1
    800017c0:	00005097          	auipc	ra,0x5
    800017c4:	af8080e7          	jalr	-1288(ra) # 800062b8 <release>
  return k;
}
    800017c8:	854a                	mv	a0,s2
    800017ca:	60e2                	ld	ra,24(sp)
    800017cc:	6442                	ld	s0,16(sp)
    800017ce:	64a2                	ld	s1,8(sp)
    800017d0:	6902                	ld	s2,0(sp)
    800017d2:	6105                	addi	sp,sp,32
    800017d4:	8082                	ret

00000000800017d6 <wait>:
int wait(uint64 addr) {
    800017d6:	715d                	addi	sp,sp,-80
    800017d8:	e486                	sd	ra,72(sp)
    800017da:	e0a2                	sd	s0,64(sp)
    800017dc:	fc26                	sd	s1,56(sp)
    800017de:	f84a                	sd	s2,48(sp)
    800017e0:	f44e                	sd	s3,40(sp)
    800017e2:	f052                	sd	s4,32(sp)
    800017e4:	ec56                	sd	s5,24(sp)
    800017e6:	e85a                	sd	s6,16(sp)
    800017e8:	e45e                	sd	s7,8(sp)
    800017ea:	e062                	sd	s8,0(sp)
    800017ec:	0880                	addi	s0,sp,80
    800017ee:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017f0:	fffff097          	auipc	ra,0xfffff
    800017f4:	664080e7          	jalr	1636(ra) # 80000e54 <myproc>
    800017f8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017fa:	00007517          	auipc	a0,0x7
    800017fe:	13e50513          	addi	a0,a0,318 # 80008938 <wait_lock>
    80001802:	00005097          	auipc	ra,0x5
    80001806:	a02080e7          	jalr	-1534(ra) # 80006204 <acquire>
    havekids = 0;
    8000180a:	4b81                	li	s7,0
        if (pp->state == ZOMBIE) {
    8000180c:	4a15                	li	s4,5
        havekids = 1;
    8000180e:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001810:	0000d997          	auipc	s3,0xd
    80001814:	f4098993          	addi	s3,s3,-192 # 8000e750 <tickslock>
    sleep(p, &wait_lock);  // DOC: wait-sleep
    80001818:	00007c17          	auipc	s8,0x7
    8000181c:	120c0c13          	addi	s8,s8,288 # 80008938 <wait_lock>
    havekids = 0;
    80001820:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001822:	00007497          	auipc	s1,0x7
    80001826:	52e48493          	addi	s1,s1,1326 # 80008d50 <proc>
    8000182a:	a0bd                	j	80001898 <wait+0xc2>
          pid = pp->pid;
    8000182c:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001830:	000b0e63          	beqz	s6,8000184c <wait+0x76>
    80001834:	4691                	li	a3,4
    80001836:	02c48613          	addi	a2,s1,44
    8000183a:	85da                	mv	a1,s6
    8000183c:	05093503          	ld	a0,80(s2)
    80001840:	fffff097          	auipc	ra,0xfffff
    80001844:	2d4080e7          	jalr	724(ra) # 80000b14 <copyout>
    80001848:	02054563          	bltz	a0,80001872 <wait+0x9c>
          freeproc(pp);
    8000184c:	8526                	mv	a0,s1
    8000184e:	fffff097          	auipc	ra,0xfffff
    80001852:	7b8080e7          	jalr	1976(ra) # 80001006 <freeproc>
          release(&pp->lock);
    80001856:	8526                	mv	a0,s1
    80001858:	00005097          	auipc	ra,0x5
    8000185c:	a60080e7          	jalr	-1440(ra) # 800062b8 <release>
          release(&wait_lock);
    80001860:	00007517          	auipc	a0,0x7
    80001864:	0d850513          	addi	a0,a0,216 # 80008938 <wait_lock>
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	a50080e7          	jalr	-1456(ra) # 800062b8 <release>
          return pid;
    80001870:	a0b5                	j	800018dc <wait+0x106>
            release(&pp->lock);
    80001872:	8526                	mv	a0,s1
    80001874:	00005097          	auipc	ra,0x5
    80001878:	a44080e7          	jalr	-1468(ra) # 800062b8 <release>
            release(&wait_lock);
    8000187c:	00007517          	auipc	a0,0x7
    80001880:	0bc50513          	addi	a0,a0,188 # 80008938 <wait_lock>
    80001884:	00005097          	auipc	ra,0x5
    80001888:	a34080e7          	jalr	-1484(ra) # 800062b8 <release>
            return -1;
    8000188c:	59fd                	li	s3,-1
    8000188e:	a0b9                	j	800018dc <wait+0x106>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001890:	16848493          	addi	s1,s1,360
    80001894:	03348463          	beq	s1,s3,800018bc <wait+0xe6>
      if (pp->parent == p) {
    80001898:	7c9c                	ld	a5,56(s1)
    8000189a:	ff279be3          	bne	a5,s2,80001890 <wait+0xba>
        acquire(&pp->lock);
    8000189e:	8526                	mv	a0,s1
    800018a0:	00005097          	auipc	ra,0x5
    800018a4:	964080e7          	jalr	-1692(ra) # 80006204 <acquire>
        if (pp->state == ZOMBIE) {
    800018a8:	4c9c                	lw	a5,24(s1)
    800018aa:	f94781e3          	beq	a5,s4,8000182c <wait+0x56>
        release(&pp->lock);
    800018ae:	8526                	mv	a0,s1
    800018b0:	00005097          	auipc	ra,0x5
    800018b4:	a08080e7          	jalr	-1528(ra) # 800062b8 <release>
        havekids = 1;
    800018b8:	8756                	mv	a4,s5
    800018ba:	bfd9                	j	80001890 <wait+0xba>
    if (!havekids || killed(p)) {
    800018bc:	c719                	beqz	a4,800018ca <wait+0xf4>
    800018be:	854a                	mv	a0,s2
    800018c0:	00000097          	auipc	ra,0x0
    800018c4:	ee4080e7          	jalr	-284(ra) # 800017a4 <killed>
    800018c8:	c51d                	beqz	a0,800018f6 <wait+0x120>
      release(&wait_lock);
    800018ca:	00007517          	auipc	a0,0x7
    800018ce:	06e50513          	addi	a0,a0,110 # 80008938 <wait_lock>
    800018d2:	00005097          	auipc	ra,0x5
    800018d6:	9e6080e7          	jalr	-1562(ra) # 800062b8 <release>
      return -1;
    800018da:	59fd                	li	s3,-1
}
    800018dc:	854e                	mv	a0,s3
    800018de:	60a6                	ld	ra,72(sp)
    800018e0:	6406                	ld	s0,64(sp)
    800018e2:	74e2                	ld	s1,56(sp)
    800018e4:	7942                	ld	s2,48(sp)
    800018e6:	79a2                	ld	s3,40(sp)
    800018e8:	7a02                	ld	s4,32(sp)
    800018ea:	6ae2                	ld	s5,24(sp)
    800018ec:	6b42                	ld	s6,16(sp)
    800018ee:	6ba2                	ld	s7,8(sp)
    800018f0:	6c02                	ld	s8,0(sp)
    800018f2:	6161                	addi	sp,sp,80
    800018f4:	8082                	ret
    sleep(p, &wait_lock);  // DOC: wait-sleep
    800018f6:	85e2                	mv	a1,s8
    800018f8:	854a                	mv	a0,s2
    800018fa:	00000097          	auipc	ra,0x0
    800018fe:	c02080e7          	jalr	-1022(ra) # 800014fc <sleep>
    havekids = 0;
    80001902:	bf39                	j	80001820 <wait+0x4a>

0000000080001904 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len) {
    80001904:	7179                	addi	sp,sp,-48
    80001906:	f406                	sd	ra,40(sp)
    80001908:	f022                	sd	s0,32(sp)
    8000190a:	ec26                	sd	s1,24(sp)
    8000190c:	e84a                	sd	s2,16(sp)
    8000190e:	e44e                	sd	s3,8(sp)
    80001910:	e052                	sd	s4,0(sp)
    80001912:	1800                	addi	s0,sp,48
    80001914:	84aa                	mv	s1,a0
    80001916:	892e                	mv	s2,a1
    80001918:	89b2                	mv	s3,a2
    8000191a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000191c:	fffff097          	auipc	ra,0xfffff
    80001920:	538080e7          	jalr	1336(ra) # 80000e54 <myproc>
  if (user_dst) {
    80001924:	c08d                	beqz	s1,80001946 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001926:	86d2                	mv	a3,s4
    80001928:	864e                	mv	a2,s3
    8000192a:	85ca                	mv	a1,s2
    8000192c:	6928                	ld	a0,80(a0)
    8000192e:	fffff097          	auipc	ra,0xfffff
    80001932:	1e6080e7          	jalr	486(ra) # 80000b14 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001936:	70a2                	ld	ra,40(sp)
    80001938:	7402                	ld	s0,32(sp)
    8000193a:	64e2                	ld	s1,24(sp)
    8000193c:	6942                	ld	s2,16(sp)
    8000193e:	69a2                	ld	s3,8(sp)
    80001940:	6a02                	ld	s4,0(sp)
    80001942:	6145                	addi	sp,sp,48
    80001944:	8082                	ret
    memmove((char *)dst, src, len);
    80001946:	000a061b          	sext.w	a2,s4
    8000194a:	85ce                	mv	a1,s3
    8000194c:	854a                	mv	a0,s2
    8000194e:	fffff097          	auipc	ra,0xfffff
    80001952:	888080e7          	jalr	-1912(ra) # 800001d6 <memmove>
    return 0;
    80001956:	8526                	mv	a0,s1
    80001958:	bff9                	j	80001936 <either_copyout+0x32>

000000008000195a <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len) {
    8000195a:	7179                	addi	sp,sp,-48
    8000195c:	f406                	sd	ra,40(sp)
    8000195e:	f022                	sd	s0,32(sp)
    80001960:	ec26                	sd	s1,24(sp)
    80001962:	e84a                	sd	s2,16(sp)
    80001964:	e44e                	sd	s3,8(sp)
    80001966:	e052                	sd	s4,0(sp)
    80001968:	1800                	addi	s0,sp,48
    8000196a:	892a                	mv	s2,a0
    8000196c:	84ae                	mv	s1,a1
    8000196e:	89b2                	mv	s3,a2
    80001970:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001972:	fffff097          	auipc	ra,0xfffff
    80001976:	4e2080e7          	jalr	1250(ra) # 80000e54 <myproc>
  if (user_src) {
    8000197a:	c08d                	beqz	s1,8000199c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000197c:	86d2                	mv	a3,s4
    8000197e:	864e                	mv	a2,s3
    80001980:	85ca                	mv	a1,s2
    80001982:	6928                	ld	a0,80(a0)
    80001984:	fffff097          	auipc	ra,0xfffff
    80001988:	21c080e7          	jalr	540(ra) # 80000ba0 <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    8000198c:	70a2                	ld	ra,40(sp)
    8000198e:	7402                	ld	s0,32(sp)
    80001990:	64e2                	ld	s1,24(sp)
    80001992:	6942                	ld	s2,16(sp)
    80001994:	69a2                	ld	s3,8(sp)
    80001996:	6a02                	ld	s4,0(sp)
    80001998:	6145                	addi	sp,sp,48
    8000199a:	8082                	ret
    memmove(dst, (char *)src, len);
    8000199c:	000a061b          	sext.w	a2,s4
    800019a0:	85ce                	mv	a1,s3
    800019a2:	854a                	mv	a0,s2
    800019a4:	fffff097          	auipc	ra,0xfffff
    800019a8:	832080e7          	jalr	-1998(ra) # 800001d6 <memmove>
    return 0;
    800019ac:	8526                	mv	a0,s1
    800019ae:	bff9                	j	8000198c <either_copyin+0x32>

00000000800019b0 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
    800019b0:	715d                	addi	sp,sp,-80
    800019b2:	e486                	sd	ra,72(sp)
    800019b4:	e0a2                	sd	s0,64(sp)
    800019b6:	fc26                	sd	s1,56(sp)
    800019b8:	f84a                	sd	s2,48(sp)
    800019ba:	f44e                	sd	s3,40(sp)
    800019bc:	f052                	sd	s4,32(sp)
    800019be:	ec56                	sd	s5,24(sp)
    800019c0:	e85a                	sd	s6,16(sp)
    800019c2:	e45e                	sd	s7,8(sp)
    800019c4:	0880                	addi	s0,sp,80
      [UNUSED] "unused",   [USED] "used",      [SLEEPING] "sleep ",
      [RUNNABLE] "runble", [RUNNING] "run   ", [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    800019c6:	00007517          	auipc	a0,0x7
    800019ca:	85a50513          	addi	a0,a0,-1958 # 80008220 <etext+0x220>
    800019ce:	00004097          	auipc	ra,0x4
    800019d2:	348080e7          	jalr	840(ra) # 80005d16 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    800019d6:	00007497          	auipc	s1,0x7
    800019da:	4d248493          	addi	s1,s1,1234 # 80008ea8 <proc+0x158>
    800019de:	0000d917          	auipc	s2,0xd
    800019e2:	eca90913          	addi	s2,s2,-310 # 8000e8a8 <bcache+0x140>
    if (p->state == UNUSED) continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e6:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019e8:	00007997          	auipc	s3,0x7
    800019ec:	81898993          	addi	s3,s3,-2024 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019f0:	00007a97          	auipc	s5,0x7
    800019f4:	818a8a93          	addi	s5,s5,-2024 # 80008208 <etext+0x208>
    printf("\n");
    800019f8:	00007a17          	auipc	s4,0x7
    800019fc:	828a0a13          	addi	s4,s4,-2008 # 80008220 <etext+0x220>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a00:	00007b97          	auipc	s7,0x7
    80001a04:	858b8b93          	addi	s7,s7,-1960 # 80008258 <states.0>
    80001a08:	a00d                	j	80001a2a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a0a:	ed86a583          	lw	a1,-296(a3)
    80001a0e:	8556                	mv	a0,s5
    80001a10:	00004097          	auipc	ra,0x4
    80001a14:	306080e7          	jalr	774(ra) # 80005d16 <printf>
    printf("\n");
    80001a18:	8552                	mv	a0,s4
    80001a1a:	00004097          	auipc	ra,0x4
    80001a1e:	2fc080e7          	jalr	764(ra) # 80005d16 <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001a22:	16848493          	addi	s1,s1,360
    80001a26:	03248263          	beq	s1,s2,80001a4a <procdump+0x9a>
    if (p->state == UNUSED) continue;
    80001a2a:	86a6                	mv	a3,s1
    80001a2c:	ec04a783          	lw	a5,-320(s1)
    80001a30:	dbed                	beqz	a5,80001a22 <procdump+0x72>
      state = "???";
    80001a32:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a34:	fcfb6be3          	bltu	s6,a5,80001a0a <procdump+0x5a>
    80001a38:	02079713          	slli	a4,a5,0x20
    80001a3c:	01d75793          	srli	a5,a4,0x1d
    80001a40:	97de                	add	a5,a5,s7
    80001a42:	6390                	ld	a2,0(a5)
    80001a44:	f279                	bnez	a2,80001a0a <procdump+0x5a>
      state = "???";
    80001a46:	864e                	mv	a2,s3
    80001a48:	b7c9                	j	80001a0a <procdump+0x5a>
  }
}
    80001a4a:	60a6                	ld	ra,72(sp)
    80001a4c:	6406                	ld	s0,64(sp)
    80001a4e:	74e2                	ld	s1,56(sp)
    80001a50:	7942                	ld	s2,48(sp)
    80001a52:	79a2                	ld	s3,40(sp)
    80001a54:	7a02                	ld	s4,32(sp)
    80001a56:	6ae2                	ld	s5,24(sp)
    80001a58:	6b42                	ld	s6,16(sp)
    80001a5a:	6ba2                	ld	s7,8(sp)
    80001a5c:	6161                	addi	sp,sp,80
    80001a5e:	8082                	ret

0000000080001a60 <dump>:

void dump(void) {
    80001a60:	7139                	addi	sp,sp,-64
    80001a62:	fc06                	sd	ra,56(sp)
    80001a64:	f822                	sd	s0,48(sp)
    80001a66:	f426                	sd	s1,40(sp)
    80001a68:	f04a                	sd	s2,32(sp)
    80001a6a:	ec4e                	sd	s3,24(sp)
    80001a6c:	e852                	sd	s4,16(sp)
    80001a6e:	e456                	sd	s5,8(sp)
    80001a70:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001a72:	fffff097          	auipc	ra,0xfffff
    80001a76:	3e2080e7          	jalr	994(ra) # 80000e54 <myproc>
    80001a7a:	89aa                	mv	s3,a0
    80001a7c:	4901                	li	s2,0
  int i;

  for (i = 2; i <= 11; i++) {
    80001a7e:	4489                	li	s1,2
    printf("s%d = %d\n", i, (int)(*(&p->trapframe->s2 + i - 2)));
    80001a80:	00006a97          	auipc	s5,0x6
    80001a84:	798a8a93          	addi	s5,s5,1944 # 80008218 <etext+0x218>
  for (i = 2; i <= 11; i++) {
    80001a88:	4a31                	li	s4,12
    printf("s%d = %d\n", i, (int)(*(&p->trapframe->s2 + i - 2)));
    80001a8a:	0589b783          	ld	a5,88(s3)
    80001a8e:	97ca                	add	a5,a5,s2
    80001a90:	0b07a603          	lw	a2,176(a5)
    80001a94:	85a6                	mv	a1,s1
    80001a96:	8556                	mv	a0,s5
    80001a98:	00004097          	auipc	ra,0x4
    80001a9c:	27e080e7          	jalr	638(ra) # 80005d16 <printf>
  for (i = 2; i <= 11; i++) {
    80001aa0:	2485                	addiw	s1,s1,1
    80001aa2:	0921                	addi	s2,s2,8
    80001aa4:	ff4493e3          	bne	s1,s4,80001a8a <dump+0x2a>
  }
}
    80001aa8:	70e2                	ld	ra,56(sp)
    80001aaa:	7442                	ld	s0,48(sp)
    80001aac:	74a2                	ld	s1,40(sp)
    80001aae:	7902                	ld	s2,32(sp)
    80001ab0:	69e2                	ld	s3,24(sp)
    80001ab2:	6a42                	ld	s4,16(sp)
    80001ab4:	6aa2                	ld	s5,8(sp)
    80001ab6:	6121                	addi	sp,sp,64
    80001ab8:	8082                	ret

0000000080001aba <dump2>:

int dump2(int pid, int register_num, uint64 return_value) {
    80001aba:	7179                	addi	sp,sp,-48
    80001abc:	f406                	sd	ra,40(sp)
    80001abe:	f022                	sd	s0,32(sp)
    80001ac0:	ec26                	sd	s1,24(sp)
    80001ac2:	e84a                	sd	s2,16(sp)
    80001ac4:	e44e                	sd	s3,8(sp)
    80001ac6:	1800                	addi	s0,sp,48
    80001ac8:	84aa                	mv	s1,a0
    80001aca:	892e                	mv	s2,a1
    80001acc:	89b2                	mv	s3,a2
  struct proc *myp = myproc();
    80001ace:	fffff097          	auipc	ra,0xfffff
    80001ad2:	386080e7          	jalr	902(ra) # 80000e54 <myproc>
  struct proc *p;

  if (register_num < 2 || register_num > 11) {
    80001ad6:	ffe9071b          	addiw	a4,s2,-2
    80001ada:	47a5                	li	a5,9
    80001adc:	04e7ee63          	bltu	a5,a4,80001b38 <dump2+0x7e>
    return -3;
  }

  for (p = proc; p < &proc[NPROC]; p++) {
    80001ae0:	00007797          	auipc	a5,0x7
    80001ae4:	27078793          	addi	a5,a5,624 # 80008d50 <proc>
    80001ae8:	0000d697          	auipc	a3,0xd
    80001aec:	c6868693          	addi	a3,a3,-920 # 8000e750 <tickslock>
    if (p->pid == pid) {
    80001af0:	5b98                	lw	a4,48(a5)
    80001af2:	00970863          	beq	a4,s1,80001b02 <dump2+0x48>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001af6:	16878793          	addi	a5,a5,360
    80001afa:	fed79be3          	bne	a5,a3,80001af0 <dump2+0x36>
        return -4;
      }
    }
  }

  return -2;
    80001afe:	5579                	li	a0,-2
    80001b00:	a01d                	j	80001b26 <dump2+0x6c>
      if (p != myp && myp != p->parent) {
    80001b02:	00f50563          	beq	a0,a5,80001b0c <dump2+0x52>
    80001b06:	7f98                	ld	a4,56(a5)
    80001b08:	02a71a63          	bne	a4,a0,80001b3c <dump2+0x82>
                   (char *)(&p->trapframe->s2 + register_num - 2), 4)) {
    80001b0c:	6fb0                	ld	a2,88(a5)
    80001b0e:	090e                	slli	s2,s2,0x3
    80001b10:	964a                	add	a2,a2,s2
      if (!copyout(myp->pagetable, return_value,
    80001b12:	4691                	li	a3,4
    80001b14:	0a060613          	addi	a2,a2,160 # 10a0 <_entry-0x7fffef60>
    80001b18:	85ce                	mv	a1,s3
    80001b1a:	6928                	ld	a0,80(a0)
    80001b1c:	fffff097          	auipc	ra,0xfffff
    80001b20:	ff8080e7          	jalr	-8(ra) # 80000b14 <copyout>
    80001b24:	e901                	bnez	a0,80001b34 <dump2+0x7a>
}
    80001b26:	70a2                	ld	ra,40(sp)
    80001b28:	7402                	ld	s0,32(sp)
    80001b2a:	64e2                	ld	s1,24(sp)
    80001b2c:	6942                	ld	s2,16(sp)
    80001b2e:	69a2                	ld	s3,8(sp)
    80001b30:	6145                	addi	sp,sp,48
    80001b32:	8082                	ret
        return -4;
    80001b34:	5571                	li	a0,-4
    80001b36:	bfc5                	j	80001b26 <dump2+0x6c>
    return -3;
    80001b38:	5575                	li	a0,-3
    80001b3a:	b7f5                	j	80001b26 <dump2+0x6c>
        return -1;
    80001b3c:	557d                	li	a0,-1
    80001b3e:	b7e5                	j	80001b26 <dump2+0x6c>

0000000080001b40 <swtch>:
    80001b40:	00153023          	sd	ra,0(a0)
    80001b44:	00253423          	sd	sp,8(a0)
    80001b48:	e900                	sd	s0,16(a0)
    80001b4a:	ed04                	sd	s1,24(a0)
    80001b4c:	03253023          	sd	s2,32(a0)
    80001b50:	03353423          	sd	s3,40(a0)
    80001b54:	03453823          	sd	s4,48(a0)
    80001b58:	03553c23          	sd	s5,56(a0)
    80001b5c:	05653023          	sd	s6,64(a0)
    80001b60:	05753423          	sd	s7,72(a0)
    80001b64:	05853823          	sd	s8,80(a0)
    80001b68:	05953c23          	sd	s9,88(a0)
    80001b6c:	07a53023          	sd	s10,96(a0)
    80001b70:	07b53423          	sd	s11,104(a0)
    80001b74:	0005b083          	ld	ra,0(a1)
    80001b78:	0085b103          	ld	sp,8(a1)
    80001b7c:	6980                	ld	s0,16(a1)
    80001b7e:	6d84                	ld	s1,24(a1)
    80001b80:	0205b903          	ld	s2,32(a1)
    80001b84:	0285b983          	ld	s3,40(a1)
    80001b88:	0305ba03          	ld	s4,48(a1)
    80001b8c:	0385ba83          	ld	s5,56(a1)
    80001b90:	0405bb03          	ld	s6,64(a1)
    80001b94:	0485bb83          	ld	s7,72(a1)
    80001b98:	0505bc03          	ld	s8,80(a1)
    80001b9c:	0585bc83          	ld	s9,88(a1)
    80001ba0:	0605bd03          	ld	s10,96(a1)
    80001ba4:	0685bd83          	ld	s11,104(a1)
    80001ba8:	8082                	ret

0000000080001baa <trapinit>:
// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void trapinit(void) { initlock(&tickslock, "time"); }
    80001baa:	1141                	addi	sp,sp,-16
    80001bac:	e406                	sd	ra,8(sp)
    80001bae:	e022                	sd	s0,0(sp)
    80001bb0:	0800                	addi	s0,sp,16
    80001bb2:	00006597          	auipc	a1,0x6
    80001bb6:	6d658593          	addi	a1,a1,1750 # 80008288 <states.0+0x30>
    80001bba:	0000d517          	auipc	a0,0xd
    80001bbe:	b9650513          	addi	a0,a0,-1130 # 8000e750 <tickslock>
    80001bc2:	00004097          	auipc	ra,0x4
    80001bc6:	5b2080e7          	jalr	1458(ra) # 80006174 <initlock>
    80001bca:	60a2                	ld	ra,8(sp)
    80001bcc:	6402                	ld	s0,0(sp)
    80001bce:	0141                	addi	sp,sp,16
    80001bd0:	8082                	ret

0000000080001bd2 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) { w_stvec((uint64)kernelvec); }
    80001bd2:	1141                	addi	sp,sp,-16
    80001bd4:	e422                	sd	s0,8(sp)
    80001bd6:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001bd8:	00003797          	auipc	a5,0x3
    80001bdc:	52878793          	addi	a5,a5,1320 # 80005100 <kernelvec>
    80001be0:	10579073          	csrw	stvec,a5
    80001be4:	6422                	ld	s0,8(sp)
    80001be6:	0141                	addi	sp,sp,16
    80001be8:	8082                	ret

0000000080001bea <usertrapret>:
}

//
// return to user space
//
void usertrapret(void) {
    80001bea:	1141                	addi	sp,sp,-16
    80001bec:	e406                	sd	ra,8(sp)
    80001bee:	e022                	sd	s0,0(sp)
    80001bf0:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bf2:	fffff097          	auipc	ra,0xfffff
    80001bf6:	262080e7          	jalr	610(ra) # 80000e54 <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001bfa:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80001bfe:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001c00:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001c04:	00005697          	auipc	a3,0x5
    80001c08:	3fc68693          	addi	a3,a3,1020 # 80007000 <_trampoline>
    80001c0c:	00005717          	auipc	a4,0x5
    80001c10:	3f470713          	addi	a4,a4,1012 # 80007000 <_trampoline>
    80001c14:	8f15                	sub	a4,a4,a3
    80001c16:	040007b7          	lui	a5,0x4000
    80001c1a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c1c:	07b2                	slli	a5,a5,0xc
    80001c1e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001c20:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();          // kernel page table
    80001c24:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80001c26:	18002673          	csrr	a2,satp
    80001c2a:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE;  // process's kernel stack
    80001c2c:	6d30                	ld	a2,88(a0)
    80001c2e:	6138                	ld	a4,64(a0)
    80001c30:	6585                	lui	a1,0x1
    80001c32:	972e                	add	a4,a4,a1
    80001c34:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c36:	6d38                	ld	a4,88(a0)
    80001c38:	00000617          	auipc	a2,0x0
    80001c3c:	13060613          	addi	a2,a2,304 # 80001d68 <usertrap>
    80001c40:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();  // hartid for cpuid()
    80001c42:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80001c44:	8612                	mv	a2,tp
    80001c46:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001c48:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP;  // clear SPP to 0 for user mode
    80001c4c:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE;  // enable interrupts in user mode
    80001c50:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001c54:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c58:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001c5a:	6f18                	ld	a4,24(a4)
    80001c5c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c60:	6928                	ld	a0,80(a0)
    80001c62:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c64:	00005717          	auipc	a4,0x5
    80001c68:	43870713          	addi	a4,a4,1080 # 8000709c <userret>
    80001c6c:	8f15                	sub	a4,a4,a3
    80001c6e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c70:	577d                	li	a4,-1
    80001c72:	177e                	slli	a4,a4,0x3f
    80001c74:	8d59                	or	a0,a0,a4
    80001c76:	9782                	jalr	a5
}
    80001c78:	60a2                	ld	ra,8(sp)
    80001c7a:	6402                	ld	s0,0(sp)
    80001c7c:	0141                	addi	sp,sp,16
    80001c7e:	8082                	ret

0000000080001c80 <clockintr>:
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr() {
    80001c80:	1101                	addi	sp,sp,-32
    80001c82:	ec06                	sd	ra,24(sp)
    80001c84:	e822                	sd	s0,16(sp)
    80001c86:	e426                	sd	s1,8(sp)
    80001c88:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c8a:	0000d497          	auipc	s1,0xd
    80001c8e:	ac648493          	addi	s1,s1,-1338 # 8000e750 <tickslock>
    80001c92:	8526                	mv	a0,s1
    80001c94:	00004097          	auipc	ra,0x4
    80001c98:	570080e7          	jalr	1392(ra) # 80006204 <acquire>
  ticks++;
    80001c9c:	00007517          	auipc	a0,0x7
    80001ca0:	c4c50513          	addi	a0,a0,-948 # 800088e8 <ticks>
    80001ca4:	411c                	lw	a5,0(a0)
    80001ca6:	2785                	addiw	a5,a5,1
    80001ca8:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001caa:	00000097          	auipc	ra,0x0
    80001cae:	8b6080e7          	jalr	-1866(ra) # 80001560 <wakeup>
  release(&tickslock);
    80001cb2:	8526                	mv	a0,s1
    80001cb4:	00004097          	auipc	ra,0x4
    80001cb8:	604080e7          	jalr	1540(ra) # 800062b8 <release>
}
    80001cbc:	60e2                	ld	ra,24(sp)
    80001cbe:	6442                	ld	s0,16(sp)
    80001cc0:	64a2                	ld	s1,8(sp)
    80001cc2:	6105                	addi	sp,sp,32
    80001cc4:	8082                	ret

0000000080001cc6 <devintr>:
// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr() {
    80001cc6:	1101                	addi	sp,sp,-32
    80001cc8:	ec06                	sd	ra,24(sp)
    80001cca:	e822                	sd	s0,16(sp)
    80001ccc:	e426                	sd	s1,8(sp)
    80001cce:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80001cd0:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001cd4:	00074d63          	bltz	a4,80001cee <devintr+0x28>
    // interrupt at a time; tell the PLIC the device is
    // now allowed to interrupt again.
    if (irq) plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000001L) {
    80001cd8:	57fd                	li	a5,-1
    80001cda:	17fe                	slli	a5,a5,0x3f
    80001cdc:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001cde:	4501                	li	a0,0
  } else if (scause == 0x8000000000000001L) {
    80001ce0:	06f70363          	beq	a4,a5,80001d46 <devintr+0x80>
  }
}
    80001ce4:	60e2                	ld	ra,24(sp)
    80001ce6:	6442                	ld	s0,16(sp)
    80001ce8:	64a2                	ld	s1,8(sp)
    80001cea:	6105                	addi	sp,sp,32
    80001cec:	8082                	ret
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001cee:	0ff77793          	zext.b	a5,a4
    80001cf2:	46a5                	li	a3,9
    80001cf4:	fed792e3          	bne	a5,a3,80001cd8 <devintr+0x12>
    int irq = plic_claim();
    80001cf8:	00003097          	auipc	ra,0x3
    80001cfc:	510080e7          	jalr	1296(ra) # 80005208 <plic_claim>
    80001d00:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80001d02:	47a9                	li	a5,10
    80001d04:	02f50763          	beq	a0,a5,80001d32 <devintr+0x6c>
    } else if (irq == VIRTIO0_IRQ) {
    80001d08:	4785                	li	a5,1
    80001d0a:	02f50963          	beq	a0,a5,80001d3c <devintr+0x76>
    return 1;
    80001d0e:	4505                	li	a0,1
    } else if (irq) {
    80001d10:	d8f1                	beqz	s1,80001ce4 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d12:	85a6                	mv	a1,s1
    80001d14:	00006517          	auipc	a0,0x6
    80001d18:	57c50513          	addi	a0,a0,1404 # 80008290 <states.0+0x38>
    80001d1c:	00004097          	auipc	ra,0x4
    80001d20:	ffa080e7          	jalr	-6(ra) # 80005d16 <printf>
    if (irq) plic_complete(irq);
    80001d24:	8526                	mv	a0,s1
    80001d26:	00003097          	auipc	ra,0x3
    80001d2a:	506080e7          	jalr	1286(ra) # 8000522c <plic_complete>
    return 1;
    80001d2e:	4505                	li	a0,1
    80001d30:	bf55                	j	80001ce4 <devintr+0x1e>
      uartintr();
    80001d32:	00004097          	auipc	ra,0x4
    80001d36:	3f2080e7          	jalr	1010(ra) # 80006124 <uartintr>
    80001d3a:	b7ed                	j	80001d24 <devintr+0x5e>
      virtio_disk_intr();
    80001d3c:	00004097          	auipc	ra,0x4
    80001d40:	9b8080e7          	jalr	-1608(ra) # 800056f4 <virtio_disk_intr>
    80001d44:	b7c5                	j	80001d24 <devintr+0x5e>
    if (cpuid() == 0) {
    80001d46:	fffff097          	auipc	ra,0xfffff
    80001d4a:	0e2080e7          	jalr	226(ra) # 80000e28 <cpuid>
    80001d4e:	c901                	beqz	a0,80001d5e <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r"(x));
    80001d50:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d54:	9bf5                	andi	a5,a5,-3
static inline void w_sip(uint64 x) { asm volatile("csrw sip, %0" : : "r"(x)); }
    80001d56:	14479073          	csrw	sip,a5
    return 2;
    80001d5a:	4509                	li	a0,2
    80001d5c:	b761                	j	80001ce4 <devintr+0x1e>
      clockintr();
    80001d5e:	00000097          	auipc	ra,0x0
    80001d62:	f22080e7          	jalr	-222(ra) # 80001c80 <clockintr>
    80001d66:	b7ed                	j	80001d50 <devintr+0x8a>

0000000080001d68 <usertrap>:
void usertrap(void) {
    80001d68:	1101                	addi	sp,sp,-32
    80001d6a:	ec06                	sd	ra,24(sp)
    80001d6c:	e822                	sd	s0,16(sp)
    80001d6e:	e426                	sd	s1,8(sp)
    80001d70:	e04a                	sd	s2,0(sp)
    80001d72:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001d74:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80001d78:	1007f793          	andi	a5,a5,256
    80001d7c:	e3b1                	bnez	a5,80001dc0 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001d7e:	00003797          	auipc	a5,0x3
    80001d82:	38278793          	addi	a5,a5,898 # 80005100 <kernelvec>
    80001d86:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d8a:	fffff097          	auipc	ra,0xfffff
    80001d8e:	0ca080e7          	jalr	202(ra) # 80000e54 <myproc>
    80001d92:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d94:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001d96:	14102773          	csrr	a4,sepc
    80001d9a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80001d9c:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80001da0:	47a1                	li	a5,8
    80001da2:	02f70763          	beq	a4,a5,80001dd0 <usertrap+0x68>
  } else if ((which_dev = devintr()) != 0) {
    80001da6:	00000097          	auipc	ra,0x0
    80001daa:	f20080e7          	jalr	-224(ra) # 80001cc6 <devintr>
    80001dae:	892a                	mv	s2,a0
    80001db0:	c151                	beqz	a0,80001e34 <usertrap+0xcc>
  if (killed(p)) exit(-1);
    80001db2:	8526                	mv	a0,s1
    80001db4:	00000097          	auipc	ra,0x0
    80001db8:	9f0080e7          	jalr	-1552(ra) # 800017a4 <killed>
    80001dbc:	c929                	beqz	a0,80001e0e <usertrap+0xa6>
    80001dbe:	a099                	j	80001e04 <usertrap+0x9c>
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80001dc0:	00006517          	auipc	a0,0x6
    80001dc4:	4f050513          	addi	a0,a0,1264 # 800082b0 <states.0+0x58>
    80001dc8:	00004097          	auipc	ra,0x4
    80001dcc:	f04080e7          	jalr	-252(ra) # 80005ccc <panic>
    if (killed(p)) exit(-1);
    80001dd0:	00000097          	auipc	ra,0x0
    80001dd4:	9d4080e7          	jalr	-1580(ra) # 800017a4 <killed>
    80001dd8:	e921                	bnez	a0,80001e28 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001dda:	6cb8                	ld	a4,88(s1)
    80001ddc:	6f1c                	ld	a5,24(a4)
    80001dde:	0791                	addi	a5,a5,4
    80001de0:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001de2:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80001de6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001dea:	10079073          	csrw	sstatus,a5
    syscall();
    80001dee:	00000097          	auipc	ra,0x0
    80001df2:	2d4080e7          	jalr	724(ra) # 800020c2 <syscall>
  if (killed(p)) exit(-1);
    80001df6:	8526                	mv	a0,s1
    80001df8:	00000097          	auipc	ra,0x0
    80001dfc:	9ac080e7          	jalr	-1620(ra) # 800017a4 <killed>
    80001e00:	c911                	beqz	a0,80001e14 <usertrap+0xac>
    80001e02:	4901                	li	s2,0
    80001e04:	557d                	li	a0,-1
    80001e06:	00000097          	auipc	ra,0x0
    80001e0a:	82a080e7          	jalr	-2006(ra) # 80001630 <exit>
  if (which_dev == 2) yield();
    80001e0e:	4789                	li	a5,2
    80001e10:	04f90f63          	beq	s2,a5,80001e6e <usertrap+0x106>
  usertrapret();
    80001e14:	00000097          	auipc	ra,0x0
    80001e18:	dd6080e7          	jalr	-554(ra) # 80001bea <usertrapret>
}
    80001e1c:	60e2                	ld	ra,24(sp)
    80001e1e:	6442                	ld	s0,16(sp)
    80001e20:	64a2                	ld	s1,8(sp)
    80001e22:	6902                	ld	s2,0(sp)
    80001e24:	6105                	addi	sp,sp,32
    80001e26:	8082                	ret
    if (killed(p)) exit(-1);
    80001e28:	557d                	li	a0,-1
    80001e2a:	00000097          	auipc	ra,0x0
    80001e2e:	806080e7          	jalr	-2042(ra) # 80001630 <exit>
    80001e32:	b765                	j	80001dda <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r"(x));
    80001e34:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e38:	5890                	lw	a2,48(s1)
    80001e3a:	00006517          	auipc	a0,0x6
    80001e3e:	49650513          	addi	a0,a0,1174 # 800082d0 <states.0+0x78>
    80001e42:	00004097          	auipc	ra,0x4
    80001e46:	ed4080e7          	jalr	-300(ra) # 80005d16 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001e4a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80001e4e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e52:	00006517          	auipc	a0,0x6
    80001e56:	4ae50513          	addi	a0,a0,1198 # 80008300 <states.0+0xa8>
    80001e5a:	00004097          	auipc	ra,0x4
    80001e5e:	ebc080e7          	jalr	-324(ra) # 80005d16 <printf>
    setkilled(p);
    80001e62:	8526                	mv	a0,s1
    80001e64:	00000097          	auipc	ra,0x0
    80001e68:	914080e7          	jalr	-1772(ra) # 80001778 <setkilled>
    80001e6c:	b769                	j	80001df6 <usertrap+0x8e>
  if (which_dev == 2) yield();
    80001e6e:	fffff097          	auipc	ra,0xfffff
    80001e72:	652080e7          	jalr	1618(ra) # 800014c0 <yield>
    80001e76:	bf79                	j	80001e14 <usertrap+0xac>

0000000080001e78 <kerneltrap>:
void kerneltrap() {
    80001e78:	7179                	addi	sp,sp,-48
    80001e7a:	f406                	sd	ra,40(sp)
    80001e7c:	f022                	sd	s0,32(sp)
    80001e7e:	ec26                	sd	s1,24(sp)
    80001e80:	e84a                	sd	s2,16(sp)
    80001e82:	e44e                	sd	s3,8(sp)
    80001e84:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001e86:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e8a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    80001e8e:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80001e92:	1004f793          	andi	a5,s1,256
    80001e96:	cb85                	beqz	a5,80001ec6 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e98:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e9c:	8b89                	andi	a5,a5,2
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    80001e9e:	ef85                	bnez	a5,80001ed6 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0) {
    80001ea0:	00000097          	auipc	ra,0x0
    80001ea4:	e26080e7          	jalr	-474(ra) # 80001cc6 <devintr>
    80001ea8:	cd1d                	beqz	a0,80001ee6 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
    80001eaa:	4789                	li	a5,2
    80001eac:	06f50a63          	beq	a0,a5,80001f20 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001eb0:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001eb4:	10049073          	csrw	sstatus,s1
}
    80001eb8:	70a2                	ld	ra,40(sp)
    80001eba:	7402                	ld	s0,32(sp)
    80001ebc:	64e2                	ld	s1,24(sp)
    80001ebe:	6942                	ld	s2,16(sp)
    80001ec0:	69a2                	ld	s3,8(sp)
    80001ec2:	6145                	addi	sp,sp,48
    80001ec4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ec6:	00006517          	auipc	a0,0x6
    80001eca:	45a50513          	addi	a0,a0,1114 # 80008320 <states.0+0xc8>
    80001ece:	00004097          	auipc	ra,0x4
    80001ed2:	dfe080e7          	jalr	-514(ra) # 80005ccc <panic>
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    80001ed6:	00006517          	auipc	a0,0x6
    80001eda:	47250513          	addi	a0,a0,1138 # 80008348 <states.0+0xf0>
    80001ede:	00004097          	auipc	ra,0x4
    80001ee2:	dee080e7          	jalr	-530(ra) # 80005ccc <panic>
    printf("scause %p\n", scause);
    80001ee6:	85ce                	mv	a1,s3
    80001ee8:	00006517          	auipc	a0,0x6
    80001eec:	48050513          	addi	a0,a0,1152 # 80008368 <states.0+0x110>
    80001ef0:	00004097          	auipc	ra,0x4
    80001ef4:	e26080e7          	jalr	-474(ra) # 80005d16 <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001ef8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80001efc:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f00:	00006517          	auipc	a0,0x6
    80001f04:	47850513          	addi	a0,a0,1144 # 80008378 <states.0+0x120>
    80001f08:	00004097          	auipc	ra,0x4
    80001f0c:	e0e080e7          	jalr	-498(ra) # 80005d16 <printf>
    panic("kerneltrap");
    80001f10:	00006517          	auipc	a0,0x6
    80001f14:	48050513          	addi	a0,a0,1152 # 80008390 <states.0+0x138>
    80001f18:	00004097          	auipc	ra,0x4
    80001f1c:	db4080e7          	jalr	-588(ra) # 80005ccc <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
    80001f20:	fffff097          	auipc	ra,0xfffff
    80001f24:	f34080e7          	jalr	-204(ra) # 80000e54 <myproc>
    80001f28:	d541                	beqz	a0,80001eb0 <kerneltrap+0x38>
    80001f2a:	fffff097          	auipc	ra,0xfffff
    80001f2e:	f2a080e7          	jalr	-214(ra) # 80000e54 <myproc>
    80001f32:	4d18                	lw	a4,24(a0)
    80001f34:	4791                	li	a5,4
    80001f36:	f6f71de3          	bne	a4,a5,80001eb0 <kerneltrap+0x38>
    80001f3a:	fffff097          	auipc	ra,0xfffff
    80001f3e:	586080e7          	jalr	1414(ra) # 800014c0 <yield>
    80001f42:	b7bd                	j	80001eb0 <kerneltrap+0x38>

0000000080001f44 <argraw>:
  struct proc *p = myproc();
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
  return strlen(buf);
}

static uint64 argraw(int n) {
    80001f44:	1101                	addi	sp,sp,-32
    80001f46:	ec06                	sd	ra,24(sp)
    80001f48:	e822                	sd	s0,16(sp)
    80001f4a:	e426                	sd	s1,8(sp)
    80001f4c:	1000                	addi	s0,sp,32
    80001f4e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f50:	fffff097          	auipc	ra,0xfffff
    80001f54:	f04080e7          	jalr	-252(ra) # 80000e54 <myproc>
  switch (n) {
    80001f58:	4795                	li	a5,5
    80001f5a:	0497e163          	bltu	a5,s1,80001f9c <argraw+0x58>
    80001f5e:	048a                	slli	s1,s1,0x2
    80001f60:	00006717          	auipc	a4,0x6
    80001f64:	46870713          	addi	a4,a4,1128 # 800083c8 <states.0+0x170>
    80001f68:	94ba                	add	s1,s1,a4
    80001f6a:	409c                	lw	a5,0(s1)
    80001f6c:	97ba                	add	a5,a5,a4
    80001f6e:	8782                	jr	a5
    case 0:
      return p->trapframe->a0;
    80001f70:	6d3c                	ld	a5,88(a0)
    80001f72:	7ba8                	ld	a0,112(a5)
    case 5:
      return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f74:	60e2                	ld	ra,24(sp)
    80001f76:	6442                	ld	s0,16(sp)
    80001f78:	64a2                	ld	s1,8(sp)
    80001f7a:	6105                	addi	sp,sp,32
    80001f7c:	8082                	ret
      return p->trapframe->a1;
    80001f7e:	6d3c                	ld	a5,88(a0)
    80001f80:	7fa8                	ld	a0,120(a5)
    80001f82:	bfcd                	j	80001f74 <argraw+0x30>
      return p->trapframe->a2;
    80001f84:	6d3c                	ld	a5,88(a0)
    80001f86:	63c8                	ld	a0,128(a5)
    80001f88:	b7f5                	j	80001f74 <argraw+0x30>
      return p->trapframe->a3;
    80001f8a:	6d3c                	ld	a5,88(a0)
    80001f8c:	67c8                	ld	a0,136(a5)
    80001f8e:	b7dd                	j	80001f74 <argraw+0x30>
      return p->trapframe->a4;
    80001f90:	6d3c                	ld	a5,88(a0)
    80001f92:	6bc8                	ld	a0,144(a5)
    80001f94:	b7c5                	j	80001f74 <argraw+0x30>
      return p->trapframe->a5;
    80001f96:	6d3c                	ld	a5,88(a0)
    80001f98:	6fc8                	ld	a0,152(a5)
    80001f9a:	bfe9                	j	80001f74 <argraw+0x30>
  panic("argraw");
    80001f9c:	00006517          	auipc	a0,0x6
    80001fa0:	40450513          	addi	a0,a0,1028 # 800083a0 <states.0+0x148>
    80001fa4:	00004097          	auipc	ra,0x4
    80001fa8:	d28080e7          	jalr	-728(ra) # 80005ccc <panic>

0000000080001fac <fetchaddr>:
int fetchaddr(uint64 addr, uint64 *ip) {
    80001fac:	1101                	addi	sp,sp,-32
    80001fae:	ec06                	sd	ra,24(sp)
    80001fb0:	e822                	sd	s0,16(sp)
    80001fb2:	e426                	sd	s1,8(sp)
    80001fb4:	e04a                	sd	s2,0(sp)
    80001fb6:	1000                	addi	s0,sp,32
    80001fb8:	84aa                	mv	s1,a0
    80001fba:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001fbc:	fffff097          	auipc	ra,0xfffff
    80001fc0:	e98080e7          	jalr	-360(ra) # 80000e54 <myproc>
  if (addr >= p->sz ||
    80001fc4:	653c                	ld	a5,72(a0)
    80001fc6:	02f4f863          	bgeu	s1,a5,80001ff6 <fetchaddr+0x4a>
      addr + sizeof(uint64) > p->sz)  // both tests needed, in case of overflow
    80001fca:	00848713          	addi	a4,s1,8
  if (addr >= p->sz ||
    80001fce:	02e7e663          	bltu	a5,a4,80001ffa <fetchaddr+0x4e>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0) return -1;
    80001fd2:	46a1                	li	a3,8
    80001fd4:	8626                	mv	a2,s1
    80001fd6:	85ca                	mv	a1,s2
    80001fd8:	6928                	ld	a0,80(a0)
    80001fda:	fffff097          	auipc	ra,0xfffff
    80001fde:	bc6080e7          	jalr	-1082(ra) # 80000ba0 <copyin>
    80001fe2:	00a03533          	snez	a0,a0
    80001fe6:	40a00533          	neg	a0,a0
}
    80001fea:	60e2                	ld	ra,24(sp)
    80001fec:	6442                	ld	s0,16(sp)
    80001fee:	64a2                	ld	s1,8(sp)
    80001ff0:	6902                	ld	s2,0(sp)
    80001ff2:	6105                	addi	sp,sp,32
    80001ff4:	8082                	ret
    return -1;
    80001ff6:	557d                	li	a0,-1
    80001ff8:	bfcd                	j	80001fea <fetchaddr+0x3e>
    80001ffa:	557d                	li	a0,-1
    80001ffc:	b7fd                	j	80001fea <fetchaddr+0x3e>

0000000080001ffe <fetchstr>:
int fetchstr(uint64 addr, char *buf, int max) {
    80001ffe:	7179                	addi	sp,sp,-48
    80002000:	f406                	sd	ra,40(sp)
    80002002:	f022                	sd	s0,32(sp)
    80002004:	ec26                	sd	s1,24(sp)
    80002006:	e84a                	sd	s2,16(sp)
    80002008:	e44e                	sd	s3,8(sp)
    8000200a:	1800                	addi	s0,sp,48
    8000200c:	892a                	mv	s2,a0
    8000200e:	84ae                	mv	s1,a1
    80002010:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002012:	fffff097          	auipc	ra,0xfffff
    80002016:	e42080e7          	jalr	-446(ra) # 80000e54 <myproc>
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    8000201a:	86ce                	mv	a3,s3
    8000201c:	864a                	mv	a2,s2
    8000201e:	85a6                	mv	a1,s1
    80002020:	6928                	ld	a0,80(a0)
    80002022:	fffff097          	auipc	ra,0xfffff
    80002026:	c0c080e7          	jalr	-1012(ra) # 80000c2e <copyinstr>
    8000202a:	00054e63          	bltz	a0,80002046 <fetchstr+0x48>
  return strlen(buf);
    8000202e:	8526                	mv	a0,s1
    80002030:	ffffe097          	auipc	ra,0xffffe
    80002034:	2c6080e7          	jalr	710(ra) # 800002f6 <strlen>
}
    80002038:	70a2                	ld	ra,40(sp)
    8000203a:	7402                	ld	s0,32(sp)
    8000203c:	64e2                	ld	s1,24(sp)
    8000203e:	6942                	ld	s2,16(sp)
    80002040:	69a2                	ld	s3,8(sp)
    80002042:	6145                	addi	sp,sp,48
    80002044:	8082                	ret
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    80002046:	557d                	li	a0,-1
    80002048:	bfc5                	j	80002038 <fetchstr+0x3a>

000000008000204a <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip) { *ip = argraw(n); }
    8000204a:	1101                	addi	sp,sp,-32
    8000204c:	ec06                	sd	ra,24(sp)
    8000204e:	e822                	sd	s0,16(sp)
    80002050:	e426                	sd	s1,8(sp)
    80002052:	1000                	addi	s0,sp,32
    80002054:	84ae                	mv	s1,a1
    80002056:	00000097          	auipc	ra,0x0
    8000205a:	eee080e7          	jalr	-274(ra) # 80001f44 <argraw>
    8000205e:	c088                	sw	a0,0(s1)
    80002060:	60e2                	ld	ra,24(sp)
    80002062:	6442                	ld	s0,16(sp)
    80002064:	64a2                	ld	s1,8(sp)
    80002066:	6105                	addi	sp,sp,32
    80002068:	8082                	ret

000000008000206a <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip) { *ip = argraw(n); }
    8000206a:	1101                	addi	sp,sp,-32
    8000206c:	ec06                	sd	ra,24(sp)
    8000206e:	e822                	sd	s0,16(sp)
    80002070:	e426                	sd	s1,8(sp)
    80002072:	1000                	addi	s0,sp,32
    80002074:	84ae                	mv	s1,a1
    80002076:	00000097          	auipc	ra,0x0
    8000207a:	ece080e7          	jalr	-306(ra) # 80001f44 <argraw>
    8000207e:	e088                	sd	a0,0(s1)
    80002080:	60e2                	ld	ra,24(sp)
    80002082:	6442                	ld	s0,16(sp)
    80002084:	64a2                	ld	s1,8(sp)
    80002086:	6105                	addi	sp,sp,32
    80002088:	8082                	ret

000000008000208a <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max) {
    8000208a:	7179                	addi	sp,sp,-48
    8000208c:	f406                	sd	ra,40(sp)
    8000208e:	f022                	sd	s0,32(sp)
    80002090:	ec26                	sd	s1,24(sp)
    80002092:	e84a                	sd	s2,16(sp)
    80002094:	1800                	addi	s0,sp,48
    80002096:	84ae                	mv	s1,a1
    80002098:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000209a:	fd840593          	addi	a1,s0,-40
    8000209e:	00000097          	auipc	ra,0x0
    800020a2:	fcc080e7          	jalr	-52(ra) # 8000206a <argaddr>
  return fetchstr(addr, buf, max);
    800020a6:	864a                	mv	a2,s2
    800020a8:	85a6                	mv	a1,s1
    800020aa:	fd843503          	ld	a0,-40(s0)
    800020ae:	00000097          	auipc	ra,0x0
    800020b2:	f50080e7          	jalr	-176(ra) # 80001ffe <fetchstr>
}
    800020b6:	70a2                	ld	ra,40(sp)
    800020b8:	7402                	ld	s0,32(sp)
    800020ba:	64e2                	ld	s1,24(sp)
    800020bc:	6942                	ld	s2,16(sp)
    800020be:	6145                	addi	sp,sp,48
    800020c0:	8082                	ret

00000000800020c2 <syscall>:
    [SYS_write] sys_write, [SYS_mknod] sys_mknod,   [SYS_unlink] sys_unlink,
    [SYS_link] sys_link,   [SYS_mkdir] sys_mkdir,   [SYS_close] sys_close,
    [SYS_dump] sys_dump,   [SYS_dump2] sys_dump2,
};

void syscall(void) {
    800020c2:	1101                	addi	sp,sp,-32
    800020c4:	ec06                	sd	ra,24(sp)
    800020c6:	e822                	sd	s0,16(sp)
    800020c8:	e426                	sd	s1,8(sp)
    800020ca:	e04a                	sd	s2,0(sp)
    800020cc:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800020ce:	fffff097          	auipc	ra,0xfffff
    800020d2:	d86080e7          	jalr	-634(ra) # 80000e54 <myproc>
    800020d6:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020d8:	05853903          	ld	s2,88(a0)
    800020dc:	0a893783          	ld	a5,168(s2)
    800020e0:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020e4:	37fd                	addiw	a5,a5,-1
    800020e6:	4759                	li	a4,22
    800020e8:	00f76f63          	bltu	a4,a5,80002106 <syscall+0x44>
    800020ec:	00369713          	slli	a4,a3,0x3
    800020f0:	00006797          	auipc	a5,0x6
    800020f4:	2f078793          	addi	a5,a5,752 # 800083e0 <syscalls>
    800020f8:	97ba                	add	a5,a5,a4
    800020fa:	639c                	ld	a5,0(a5)
    800020fc:	c789                	beqz	a5,80002106 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800020fe:	9782                	jalr	a5
    80002100:	06a93823          	sd	a0,112(s2)
    80002104:	a839                	j	80002122 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80002106:	15848613          	addi	a2,s1,344
    8000210a:	588c                	lw	a1,48(s1)
    8000210c:	00006517          	auipc	a0,0x6
    80002110:	29c50513          	addi	a0,a0,668 # 800083a8 <states.0+0x150>
    80002114:	00004097          	auipc	ra,0x4
    80002118:	c02080e7          	jalr	-1022(ra) # 80005d16 <printf>
    p->trapframe->a0 = -1;
    8000211c:	6cbc                	ld	a5,88(s1)
    8000211e:	577d                	li	a4,-1
    80002120:	fbb8                	sd	a4,112(a5)
  }
}
    80002122:	60e2                	ld	ra,24(sp)
    80002124:	6442                	ld	s0,16(sp)
    80002126:	64a2                	ld	s1,8(sp)
    80002128:	6902                	ld	s2,0(sp)
    8000212a:	6105                	addi	sp,sp,32
    8000212c:	8082                	ret

000000008000212e <sys_exit>:
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64 sys_exit(void) {
    8000212e:	1101                	addi	sp,sp,-32
    80002130:	ec06                	sd	ra,24(sp)
    80002132:	e822                	sd	s0,16(sp)
    80002134:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002136:	fec40593          	addi	a1,s0,-20
    8000213a:	4501                	li	a0,0
    8000213c:	00000097          	auipc	ra,0x0
    80002140:	f0e080e7          	jalr	-242(ra) # 8000204a <argint>
  exit(n);
    80002144:	fec42503          	lw	a0,-20(s0)
    80002148:	fffff097          	auipc	ra,0xfffff
    8000214c:	4e8080e7          	jalr	1256(ra) # 80001630 <exit>
  return 0;  // not reached
}
    80002150:	4501                	li	a0,0
    80002152:	60e2                	ld	ra,24(sp)
    80002154:	6442                	ld	s0,16(sp)
    80002156:	6105                	addi	sp,sp,32
    80002158:	8082                	ret

000000008000215a <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    8000215a:	1141                	addi	sp,sp,-16
    8000215c:	e406                	sd	ra,8(sp)
    8000215e:	e022                	sd	s0,0(sp)
    80002160:	0800                	addi	s0,sp,16
    80002162:	fffff097          	auipc	ra,0xfffff
    80002166:	cf2080e7          	jalr	-782(ra) # 80000e54 <myproc>
    8000216a:	5908                	lw	a0,48(a0)
    8000216c:	60a2                	ld	ra,8(sp)
    8000216e:	6402                	ld	s0,0(sp)
    80002170:	0141                	addi	sp,sp,16
    80002172:	8082                	ret

0000000080002174 <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    80002174:	1141                	addi	sp,sp,-16
    80002176:	e406                	sd	ra,8(sp)
    80002178:	e022                	sd	s0,0(sp)
    8000217a:	0800                	addi	s0,sp,16
    8000217c:	fffff097          	auipc	ra,0xfffff
    80002180:	08e080e7          	jalr	142(ra) # 8000120a <fork>
    80002184:	60a2                	ld	ra,8(sp)
    80002186:	6402                	ld	s0,0(sp)
    80002188:	0141                	addi	sp,sp,16
    8000218a:	8082                	ret

000000008000218c <sys_wait>:

uint64 sys_wait(void) {
    8000218c:	1101                	addi	sp,sp,-32
    8000218e:	ec06                	sd	ra,24(sp)
    80002190:	e822                	sd	s0,16(sp)
    80002192:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002194:	fe840593          	addi	a1,s0,-24
    80002198:	4501                	li	a0,0
    8000219a:	00000097          	auipc	ra,0x0
    8000219e:	ed0080e7          	jalr	-304(ra) # 8000206a <argaddr>
  return wait(p);
    800021a2:	fe843503          	ld	a0,-24(s0)
    800021a6:	fffff097          	auipc	ra,0xfffff
    800021aa:	630080e7          	jalr	1584(ra) # 800017d6 <wait>
}
    800021ae:	60e2                	ld	ra,24(sp)
    800021b0:	6442                	ld	s0,16(sp)
    800021b2:	6105                	addi	sp,sp,32
    800021b4:	8082                	ret

00000000800021b6 <sys_sbrk>:

uint64 sys_sbrk(void) {
    800021b6:	7179                	addi	sp,sp,-48
    800021b8:	f406                	sd	ra,40(sp)
    800021ba:	f022                	sd	s0,32(sp)
    800021bc:	ec26                	sd	s1,24(sp)
    800021be:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800021c0:	fdc40593          	addi	a1,s0,-36
    800021c4:	4501                	li	a0,0
    800021c6:	00000097          	auipc	ra,0x0
    800021ca:	e84080e7          	jalr	-380(ra) # 8000204a <argint>
  addr = myproc()->sz;
    800021ce:	fffff097          	auipc	ra,0xfffff
    800021d2:	c86080e7          	jalr	-890(ra) # 80000e54 <myproc>
    800021d6:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0) return -1;
    800021d8:	fdc42503          	lw	a0,-36(s0)
    800021dc:	fffff097          	auipc	ra,0xfffff
    800021e0:	fd2080e7          	jalr	-46(ra) # 800011ae <growproc>
    800021e4:	00054863          	bltz	a0,800021f4 <sys_sbrk+0x3e>
  return addr;
}
    800021e8:	8526                	mv	a0,s1
    800021ea:	70a2                	ld	ra,40(sp)
    800021ec:	7402                	ld	s0,32(sp)
    800021ee:	64e2                	ld	s1,24(sp)
    800021f0:	6145                	addi	sp,sp,48
    800021f2:	8082                	ret
  if (growproc(n) < 0) return -1;
    800021f4:	54fd                	li	s1,-1
    800021f6:	bfcd                	j	800021e8 <sys_sbrk+0x32>

00000000800021f8 <sys_sleep>:

uint64 sys_sleep(void) {
    800021f8:	7139                	addi	sp,sp,-64
    800021fa:	fc06                	sd	ra,56(sp)
    800021fc:	f822                	sd	s0,48(sp)
    800021fe:	f426                	sd	s1,40(sp)
    80002200:	f04a                	sd	s2,32(sp)
    80002202:	ec4e                	sd	s3,24(sp)
    80002204:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002206:	fcc40593          	addi	a1,s0,-52
    8000220a:	4501                	li	a0,0
    8000220c:	00000097          	auipc	ra,0x0
    80002210:	e3e080e7          	jalr	-450(ra) # 8000204a <argint>
  acquire(&tickslock);
    80002214:	0000c517          	auipc	a0,0xc
    80002218:	53c50513          	addi	a0,a0,1340 # 8000e750 <tickslock>
    8000221c:	00004097          	auipc	ra,0x4
    80002220:	fe8080e7          	jalr	-24(ra) # 80006204 <acquire>
  ticks0 = ticks;
    80002224:	00006917          	auipc	s2,0x6
    80002228:	6c492903          	lw	s2,1732(s2) # 800088e8 <ticks>
  while (ticks - ticks0 < n) {
    8000222c:	fcc42783          	lw	a5,-52(s0)
    80002230:	cf9d                	beqz	a5,8000226e <sys_sleep+0x76>
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002232:	0000c997          	auipc	s3,0xc
    80002236:	51e98993          	addi	s3,s3,1310 # 8000e750 <tickslock>
    8000223a:	00006497          	auipc	s1,0x6
    8000223e:	6ae48493          	addi	s1,s1,1710 # 800088e8 <ticks>
    if (killed(myproc())) {
    80002242:	fffff097          	auipc	ra,0xfffff
    80002246:	c12080e7          	jalr	-1006(ra) # 80000e54 <myproc>
    8000224a:	fffff097          	auipc	ra,0xfffff
    8000224e:	55a080e7          	jalr	1370(ra) # 800017a4 <killed>
    80002252:	ed15                	bnez	a0,8000228e <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002254:	85ce                	mv	a1,s3
    80002256:	8526                	mv	a0,s1
    80002258:	fffff097          	auipc	ra,0xfffff
    8000225c:	2a4080e7          	jalr	676(ra) # 800014fc <sleep>
  while (ticks - ticks0 < n) {
    80002260:	409c                	lw	a5,0(s1)
    80002262:	412787bb          	subw	a5,a5,s2
    80002266:	fcc42703          	lw	a4,-52(s0)
    8000226a:	fce7ece3          	bltu	a5,a4,80002242 <sys_sleep+0x4a>
  }
  release(&tickslock);
    8000226e:	0000c517          	auipc	a0,0xc
    80002272:	4e250513          	addi	a0,a0,1250 # 8000e750 <tickslock>
    80002276:	00004097          	auipc	ra,0x4
    8000227a:	042080e7          	jalr	66(ra) # 800062b8 <release>
  return 0;
    8000227e:	4501                	li	a0,0
}
    80002280:	70e2                	ld	ra,56(sp)
    80002282:	7442                	ld	s0,48(sp)
    80002284:	74a2                	ld	s1,40(sp)
    80002286:	7902                	ld	s2,32(sp)
    80002288:	69e2                	ld	s3,24(sp)
    8000228a:	6121                	addi	sp,sp,64
    8000228c:	8082                	ret
      release(&tickslock);
    8000228e:	0000c517          	auipc	a0,0xc
    80002292:	4c250513          	addi	a0,a0,1218 # 8000e750 <tickslock>
    80002296:	00004097          	auipc	ra,0x4
    8000229a:	022080e7          	jalr	34(ra) # 800062b8 <release>
      return -1;
    8000229e:	557d                	li	a0,-1
    800022a0:	b7c5                	j	80002280 <sys_sleep+0x88>

00000000800022a2 <sys_kill>:

uint64 sys_kill(void) {
    800022a2:	1101                	addi	sp,sp,-32
    800022a4:	ec06                	sd	ra,24(sp)
    800022a6:	e822                	sd	s0,16(sp)
    800022a8:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800022aa:	fec40593          	addi	a1,s0,-20
    800022ae:	4501                	li	a0,0
    800022b0:	00000097          	auipc	ra,0x0
    800022b4:	d9a080e7          	jalr	-614(ra) # 8000204a <argint>
  return kill(pid);
    800022b8:	fec42503          	lw	a0,-20(s0)
    800022bc:	fffff097          	auipc	ra,0xfffff
    800022c0:	44a080e7          	jalr	1098(ra) # 80001706 <kill>
}
    800022c4:	60e2                	ld	ra,24(sp)
    800022c6:	6442                	ld	s0,16(sp)
    800022c8:	6105                	addi	sp,sp,32
    800022ca:	8082                	ret

00000000800022cc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    800022cc:	1101                	addi	sp,sp,-32
    800022ce:	ec06                	sd	ra,24(sp)
    800022d0:	e822                	sd	s0,16(sp)
    800022d2:	e426                	sd	s1,8(sp)
    800022d4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022d6:	0000c517          	auipc	a0,0xc
    800022da:	47a50513          	addi	a0,a0,1146 # 8000e750 <tickslock>
    800022de:	00004097          	auipc	ra,0x4
    800022e2:	f26080e7          	jalr	-218(ra) # 80006204 <acquire>
  xticks = ticks;
    800022e6:	00006497          	auipc	s1,0x6
    800022ea:	6024a483          	lw	s1,1538(s1) # 800088e8 <ticks>
  release(&tickslock);
    800022ee:	0000c517          	auipc	a0,0xc
    800022f2:	46250513          	addi	a0,a0,1122 # 8000e750 <tickslock>
    800022f6:	00004097          	auipc	ra,0x4
    800022fa:	fc2080e7          	jalr	-62(ra) # 800062b8 <release>
  return xticks;
}
    800022fe:	02049513          	slli	a0,s1,0x20
    80002302:	9101                	srli	a0,a0,0x20
    80002304:	60e2                	ld	ra,24(sp)
    80002306:	6442                	ld	s0,16(sp)
    80002308:	64a2                	ld	s1,8(sp)
    8000230a:	6105                	addi	sp,sp,32
    8000230c:	8082                	ret

000000008000230e <sys_dump>:

uint64 sys_dump(void) {
    8000230e:	1141                	addi	sp,sp,-16
    80002310:	e406                	sd	ra,8(sp)
    80002312:	e022                	sd	s0,0(sp)
    80002314:	0800                	addi	s0,sp,16
  dump();
    80002316:	fffff097          	auipc	ra,0xfffff
    8000231a:	74a080e7          	jalr	1866(ra) # 80001a60 <dump>
  return 0;
}
    8000231e:	4501                	li	a0,0
    80002320:	60a2                	ld	ra,8(sp)
    80002322:	6402                	ld	s0,0(sp)
    80002324:	0141                	addi	sp,sp,16
    80002326:	8082                	ret

0000000080002328 <sys_dump2>:

uint64 sys_dump2(void) {
    80002328:	1101                	addi	sp,sp,-32
    8000232a:	ec06                	sd	ra,24(sp)
    8000232c:	e822                	sd	s0,16(sp)
    8000232e:	1000                	addi	s0,sp,32
  int pid, register_num;
  uint64 addr;

  argint(0, &pid);
    80002330:	fec40593          	addi	a1,s0,-20
    80002334:	4501                	li	a0,0
    80002336:	00000097          	auipc	ra,0x0
    8000233a:	d14080e7          	jalr	-748(ra) # 8000204a <argint>
  argint(1, &register_num);
    8000233e:	fe840593          	addi	a1,s0,-24
    80002342:	4505                	li	a0,1
    80002344:	00000097          	auipc	ra,0x0
    80002348:	d06080e7          	jalr	-762(ra) # 8000204a <argint>
  argaddr(2, &addr);
    8000234c:	fe040593          	addi	a1,s0,-32
    80002350:	4509                	li	a0,2
    80002352:	00000097          	auipc	ra,0x0
    80002356:	d18080e7          	jalr	-744(ra) # 8000206a <argaddr>
  return dump2(pid, register_num, (uint64)addr);
    8000235a:	fe043603          	ld	a2,-32(s0)
    8000235e:	fe842583          	lw	a1,-24(s0)
    80002362:	fec42503          	lw	a0,-20(s0)
    80002366:	fffff097          	auipc	ra,0xfffff
    8000236a:	754080e7          	jalr	1876(ra) # 80001aba <dump2>
}
    8000236e:	60e2                	ld	ra,24(sp)
    80002370:	6442                	ld	s0,16(sp)
    80002372:	6105                	addi	sp,sp,32
    80002374:	8082                	ret

0000000080002376 <binit>:
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  struct buf head;
} bcache;

void binit(void) {
    80002376:	7179                	addi	sp,sp,-48
    80002378:	f406                	sd	ra,40(sp)
    8000237a:	f022                	sd	s0,32(sp)
    8000237c:	ec26                	sd	s1,24(sp)
    8000237e:	e84a                	sd	s2,16(sp)
    80002380:	e44e                	sd	s3,8(sp)
    80002382:	e052                	sd	s4,0(sp)
    80002384:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002386:	00006597          	auipc	a1,0x6
    8000238a:	11a58593          	addi	a1,a1,282 # 800084a0 <syscalls+0xc0>
    8000238e:	0000c517          	auipc	a0,0xc
    80002392:	3da50513          	addi	a0,a0,986 # 8000e768 <bcache>
    80002396:	00004097          	auipc	ra,0x4
    8000239a:	dde080e7          	jalr	-546(ra) # 80006174 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000239e:	00014797          	auipc	a5,0x14
    800023a2:	3ca78793          	addi	a5,a5,970 # 80016768 <bcache+0x8000>
    800023a6:	00014717          	auipc	a4,0x14
    800023aa:	62a70713          	addi	a4,a4,1578 # 800169d0 <bcache+0x8268>
    800023ae:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023b2:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    800023b6:	0000c497          	auipc	s1,0xc
    800023ba:	3ca48493          	addi	s1,s1,970 # 8000e780 <bcache+0x18>
    b->next = bcache.head.next;
    800023be:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023c0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023c2:	00006a17          	auipc	s4,0x6
    800023c6:	0e6a0a13          	addi	s4,s4,230 # 800084a8 <syscalls+0xc8>
    b->next = bcache.head.next;
    800023ca:	2b893783          	ld	a5,696(s2)
    800023ce:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023d0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023d4:	85d2                	mv	a1,s4
    800023d6:	01048513          	addi	a0,s1,16
    800023da:	00001097          	auipc	ra,0x1
    800023de:	4c8080e7          	jalr	1224(ra) # 800038a2 <initsleeplock>
    bcache.head.next->prev = b;
    800023e2:	2b893783          	ld	a5,696(s2)
    800023e6:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023e8:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    800023ec:	45848493          	addi	s1,s1,1112
    800023f0:	fd349de3          	bne	s1,s3,800023ca <binit+0x54>
  }
}
    800023f4:	70a2                	ld	ra,40(sp)
    800023f6:	7402                	ld	s0,32(sp)
    800023f8:	64e2                	ld	s1,24(sp)
    800023fa:	6942                	ld	s2,16(sp)
    800023fc:	69a2                	ld	s3,8(sp)
    800023fe:	6a02                	ld	s4,0(sp)
    80002400:	6145                	addi	sp,sp,48
    80002402:	8082                	ret

0000000080002404 <bread>:
  }
  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf *bread(uint dev, uint blockno) {
    80002404:	7179                	addi	sp,sp,-48
    80002406:	f406                	sd	ra,40(sp)
    80002408:	f022                	sd	s0,32(sp)
    8000240a:	ec26                	sd	s1,24(sp)
    8000240c:	e84a                	sd	s2,16(sp)
    8000240e:	e44e                	sd	s3,8(sp)
    80002410:	1800                	addi	s0,sp,48
    80002412:	892a                	mv	s2,a0
    80002414:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002416:	0000c517          	auipc	a0,0xc
    8000241a:	35250513          	addi	a0,a0,850 # 8000e768 <bcache>
    8000241e:	00004097          	auipc	ra,0x4
    80002422:	de6080e7          	jalr	-538(ra) # 80006204 <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    80002426:	00014497          	auipc	s1,0x14
    8000242a:	5fa4b483          	ld	s1,1530(s1) # 80016a20 <bcache+0x82b8>
    8000242e:	00014797          	auipc	a5,0x14
    80002432:	5a278793          	addi	a5,a5,1442 # 800169d0 <bcache+0x8268>
    80002436:	02f48f63          	beq	s1,a5,80002474 <bread+0x70>
    8000243a:	873e                	mv	a4,a5
    8000243c:	a021                	j	80002444 <bread+0x40>
    8000243e:	68a4                	ld	s1,80(s1)
    80002440:	02e48a63          	beq	s1,a4,80002474 <bread+0x70>
    if (b->dev == dev && b->blockno == blockno) {
    80002444:	449c                	lw	a5,8(s1)
    80002446:	ff279ce3          	bne	a5,s2,8000243e <bread+0x3a>
    8000244a:	44dc                	lw	a5,12(s1)
    8000244c:	ff3799e3          	bne	a5,s3,8000243e <bread+0x3a>
      b->refcnt++;
    80002450:	40bc                	lw	a5,64(s1)
    80002452:	2785                	addiw	a5,a5,1
    80002454:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002456:	0000c517          	auipc	a0,0xc
    8000245a:	31250513          	addi	a0,a0,786 # 8000e768 <bcache>
    8000245e:	00004097          	auipc	ra,0x4
    80002462:	e5a080e7          	jalr	-422(ra) # 800062b8 <release>
      acquiresleep(&b->lock);
    80002466:	01048513          	addi	a0,s1,16
    8000246a:	00001097          	auipc	ra,0x1
    8000246e:	472080e7          	jalr	1138(ra) # 800038dc <acquiresleep>
      return b;
    80002472:	a8b9                	j	800024d0 <bread+0xcc>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002474:	00014497          	auipc	s1,0x14
    80002478:	5a44b483          	ld	s1,1444(s1) # 80016a18 <bcache+0x82b0>
    8000247c:	00014797          	auipc	a5,0x14
    80002480:	55478793          	addi	a5,a5,1364 # 800169d0 <bcache+0x8268>
    80002484:	00f48863          	beq	s1,a5,80002494 <bread+0x90>
    80002488:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    8000248a:	40bc                	lw	a5,64(s1)
    8000248c:	cf81                	beqz	a5,800024a4 <bread+0xa0>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    8000248e:	64a4                	ld	s1,72(s1)
    80002490:	fee49de3          	bne	s1,a4,8000248a <bread+0x86>
  panic("bget: no buffers");
    80002494:	00006517          	auipc	a0,0x6
    80002498:	01c50513          	addi	a0,a0,28 # 800084b0 <syscalls+0xd0>
    8000249c:	00004097          	auipc	ra,0x4
    800024a0:	830080e7          	jalr	-2000(ra) # 80005ccc <panic>
      b->dev = dev;
    800024a4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800024a8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800024ac:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024b0:	4785                	li	a5,1
    800024b2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024b4:	0000c517          	auipc	a0,0xc
    800024b8:	2b450513          	addi	a0,a0,692 # 8000e768 <bcache>
    800024bc:	00004097          	auipc	ra,0x4
    800024c0:	dfc080e7          	jalr	-516(ra) # 800062b8 <release>
      acquiresleep(&b->lock);
    800024c4:	01048513          	addi	a0,s1,16
    800024c8:	00001097          	auipc	ra,0x1
    800024cc:	414080e7          	jalr	1044(ra) # 800038dc <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    800024d0:	409c                	lw	a5,0(s1)
    800024d2:	cb89                	beqz	a5,800024e4 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024d4:	8526                	mv	a0,s1
    800024d6:	70a2                	ld	ra,40(sp)
    800024d8:	7402                	ld	s0,32(sp)
    800024da:	64e2                	ld	s1,24(sp)
    800024dc:	6942                	ld	s2,16(sp)
    800024de:	69a2                	ld	s3,8(sp)
    800024e0:	6145                	addi	sp,sp,48
    800024e2:	8082                	ret
    virtio_disk_rw(b, 0);
    800024e4:	4581                	li	a1,0
    800024e6:	8526                	mv	a0,s1
    800024e8:	00003097          	auipc	ra,0x3
    800024ec:	fda080e7          	jalr	-38(ra) # 800054c2 <virtio_disk_rw>
    b->valid = 1;
    800024f0:	4785                	li	a5,1
    800024f2:	c09c                	sw	a5,0(s1)
  return b;
    800024f4:	b7c5                	j	800024d4 <bread+0xd0>

00000000800024f6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void bwrite(struct buf *b) {
    800024f6:	1101                	addi	sp,sp,-32
    800024f8:	ec06                	sd	ra,24(sp)
    800024fa:	e822                	sd	s0,16(sp)
    800024fc:	e426                	sd	s1,8(sp)
    800024fe:	1000                	addi	s0,sp,32
    80002500:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock)) panic("bwrite");
    80002502:	0541                	addi	a0,a0,16
    80002504:	00001097          	auipc	ra,0x1
    80002508:	472080e7          	jalr	1138(ra) # 80003976 <holdingsleep>
    8000250c:	cd01                	beqz	a0,80002524 <bwrite+0x2e>
  virtio_disk_rw(b, 1);
    8000250e:	4585                	li	a1,1
    80002510:	8526                	mv	a0,s1
    80002512:	00003097          	auipc	ra,0x3
    80002516:	fb0080e7          	jalr	-80(ra) # 800054c2 <virtio_disk_rw>
}
    8000251a:	60e2                	ld	ra,24(sp)
    8000251c:	6442                	ld	s0,16(sp)
    8000251e:	64a2                	ld	s1,8(sp)
    80002520:	6105                	addi	sp,sp,32
    80002522:	8082                	ret
  if (!holdingsleep(&b->lock)) panic("bwrite");
    80002524:	00006517          	auipc	a0,0x6
    80002528:	fa450513          	addi	a0,a0,-92 # 800084c8 <syscalls+0xe8>
    8000252c:	00003097          	auipc	ra,0x3
    80002530:	7a0080e7          	jalr	1952(ra) # 80005ccc <panic>

0000000080002534 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void brelse(struct buf *b) {
    80002534:	1101                	addi	sp,sp,-32
    80002536:	ec06                	sd	ra,24(sp)
    80002538:	e822                	sd	s0,16(sp)
    8000253a:	e426                	sd	s1,8(sp)
    8000253c:	e04a                	sd	s2,0(sp)
    8000253e:	1000                	addi	s0,sp,32
    80002540:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock)) panic("brelse");
    80002542:	01050913          	addi	s2,a0,16
    80002546:	854a                	mv	a0,s2
    80002548:	00001097          	auipc	ra,0x1
    8000254c:	42e080e7          	jalr	1070(ra) # 80003976 <holdingsleep>
    80002550:	c92d                	beqz	a0,800025c2 <brelse+0x8e>

  releasesleep(&b->lock);
    80002552:	854a                	mv	a0,s2
    80002554:	00001097          	auipc	ra,0x1
    80002558:	3de080e7          	jalr	990(ra) # 80003932 <releasesleep>

  acquire(&bcache.lock);
    8000255c:	0000c517          	auipc	a0,0xc
    80002560:	20c50513          	addi	a0,a0,524 # 8000e768 <bcache>
    80002564:	00004097          	auipc	ra,0x4
    80002568:	ca0080e7          	jalr	-864(ra) # 80006204 <acquire>
  b->refcnt--;
    8000256c:	40bc                	lw	a5,64(s1)
    8000256e:	37fd                	addiw	a5,a5,-1
    80002570:	0007871b          	sext.w	a4,a5
    80002574:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002576:	eb05                	bnez	a4,800025a6 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002578:	68bc                	ld	a5,80(s1)
    8000257a:	64b8                	ld	a4,72(s1)
    8000257c:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000257e:	64bc                	ld	a5,72(s1)
    80002580:	68b8                	ld	a4,80(s1)
    80002582:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002584:	00014797          	auipc	a5,0x14
    80002588:	1e478793          	addi	a5,a5,484 # 80016768 <bcache+0x8000>
    8000258c:	2b87b703          	ld	a4,696(a5)
    80002590:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002592:	00014717          	auipc	a4,0x14
    80002596:	43e70713          	addi	a4,a4,1086 # 800169d0 <bcache+0x8268>
    8000259a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000259c:	2b87b703          	ld	a4,696(a5)
    800025a0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025a2:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    800025a6:	0000c517          	auipc	a0,0xc
    800025aa:	1c250513          	addi	a0,a0,450 # 8000e768 <bcache>
    800025ae:	00004097          	auipc	ra,0x4
    800025b2:	d0a080e7          	jalr	-758(ra) # 800062b8 <release>
}
    800025b6:	60e2                	ld	ra,24(sp)
    800025b8:	6442                	ld	s0,16(sp)
    800025ba:	64a2                	ld	s1,8(sp)
    800025bc:	6902                	ld	s2,0(sp)
    800025be:	6105                	addi	sp,sp,32
    800025c0:	8082                	ret
  if (!holdingsleep(&b->lock)) panic("brelse");
    800025c2:	00006517          	auipc	a0,0x6
    800025c6:	f0e50513          	addi	a0,a0,-242 # 800084d0 <syscalls+0xf0>
    800025ca:	00003097          	auipc	ra,0x3
    800025ce:	702080e7          	jalr	1794(ra) # 80005ccc <panic>

00000000800025d2 <bpin>:

void bpin(struct buf *b) {
    800025d2:	1101                	addi	sp,sp,-32
    800025d4:	ec06                	sd	ra,24(sp)
    800025d6:	e822                	sd	s0,16(sp)
    800025d8:	e426                	sd	s1,8(sp)
    800025da:	1000                	addi	s0,sp,32
    800025dc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025de:	0000c517          	auipc	a0,0xc
    800025e2:	18a50513          	addi	a0,a0,394 # 8000e768 <bcache>
    800025e6:	00004097          	auipc	ra,0x4
    800025ea:	c1e080e7          	jalr	-994(ra) # 80006204 <acquire>
  b->refcnt++;
    800025ee:	40bc                	lw	a5,64(s1)
    800025f0:	2785                	addiw	a5,a5,1
    800025f2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025f4:	0000c517          	auipc	a0,0xc
    800025f8:	17450513          	addi	a0,a0,372 # 8000e768 <bcache>
    800025fc:	00004097          	auipc	ra,0x4
    80002600:	cbc080e7          	jalr	-836(ra) # 800062b8 <release>
}
    80002604:	60e2                	ld	ra,24(sp)
    80002606:	6442                	ld	s0,16(sp)
    80002608:	64a2                	ld	s1,8(sp)
    8000260a:	6105                	addi	sp,sp,32
    8000260c:	8082                	ret

000000008000260e <bunpin>:

void bunpin(struct buf *b) {
    8000260e:	1101                	addi	sp,sp,-32
    80002610:	ec06                	sd	ra,24(sp)
    80002612:	e822                	sd	s0,16(sp)
    80002614:	e426                	sd	s1,8(sp)
    80002616:	1000                	addi	s0,sp,32
    80002618:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000261a:	0000c517          	auipc	a0,0xc
    8000261e:	14e50513          	addi	a0,a0,334 # 8000e768 <bcache>
    80002622:	00004097          	auipc	ra,0x4
    80002626:	be2080e7          	jalr	-1054(ra) # 80006204 <acquire>
  b->refcnt--;
    8000262a:	40bc                	lw	a5,64(s1)
    8000262c:	37fd                	addiw	a5,a5,-1
    8000262e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002630:	0000c517          	auipc	a0,0xc
    80002634:	13850513          	addi	a0,a0,312 # 8000e768 <bcache>
    80002638:	00004097          	auipc	ra,0x4
    8000263c:	c80080e7          	jalr	-896(ra) # 800062b8 <release>
}
    80002640:	60e2                	ld	ra,24(sp)
    80002642:	6442                	ld	s0,16(sp)
    80002644:	64a2                	ld	s1,8(sp)
    80002646:	6105                	addi	sp,sp,32
    80002648:	8082                	ret

000000008000264a <bfree>:
  printf("balloc: out of blocks\n");
  return 0;
}

// Free a disk block.
static void bfree(int dev, uint b) {
    8000264a:	1101                	addi	sp,sp,-32
    8000264c:	ec06                	sd	ra,24(sp)
    8000264e:	e822                	sd	s0,16(sp)
    80002650:	e426                	sd	s1,8(sp)
    80002652:	e04a                	sd	s2,0(sp)
    80002654:	1000                	addi	s0,sp,32
    80002656:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002658:	00d5d59b          	srliw	a1,a1,0xd
    8000265c:	00014797          	auipc	a5,0x14
    80002660:	7e87a783          	lw	a5,2024(a5) # 80016e44 <sb+0x1c>
    80002664:	9dbd                	addw	a1,a1,a5
    80002666:	00000097          	auipc	ra,0x0
    8000266a:	d9e080e7          	jalr	-610(ra) # 80002404 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000266e:	0074f713          	andi	a4,s1,7
    80002672:	4785                	li	a5,1
    80002674:	00e797bb          	sllw	a5,a5,a4
  if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
    80002678:	14ce                	slli	s1,s1,0x33
    8000267a:	90d9                	srli	s1,s1,0x36
    8000267c:	00950733          	add	a4,a0,s1
    80002680:	05874703          	lbu	a4,88(a4)
    80002684:	00e7f6b3          	and	a3,a5,a4
    80002688:	c69d                	beqz	a3,800026b6 <bfree+0x6c>
    8000268a:	892a                	mv	s2,a0
  bp->data[bi / 8] &= ~m;
    8000268c:	94aa                	add	s1,s1,a0
    8000268e:	fff7c793          	not	a5,a5
    80002692:	8f7d                	and	a4,a4,a5
    80002694:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002698:	00001097          	auipc	ra,0x1
    8000269c:	126080e7          	jalr	294(ra) # 800037be <log_write>
  brelse(bp);
    800026a0:	854a                	mv	a0,s2
    800026a2:	00000097          	auipc	ra,0x0
    800026a6:	e92080e7          	jalr	-366(ra) # 80002534 <brelse>
}
    800026aa:	60e2                	ld	ra,24(sp)
    800026ac:	6442                	ld	s0,16(sp)
    800026ae:	64a2                	ld	s1,8(sp)
    800026b0:	6902                	ld	s2,0(sp)
    800026b2:	6105                	addi	sp,sp,32
    800026b4:	8082                	ret
  if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
    800026b6:	00006517          	auipc	a0,0x6
    800026ba:	e2250513          	addi	a0,a0,-478 # 800084d8 <syscalls+0xf8>
    800026be:	00003097          	auipc	ra,0x3
    800026c2:	60e080e7          	jalr	1550(ra) # 80005ccc <panic>

00000000800026c6 <balloc>:
static uint balloc(uint dev) {
    800026c6:	711d                	addi	sp,sp,-96
    800026c8:	ec86                	sd	ra,88(sp)
    800026ca:	e8a2                	sd	s0,80(sp)
    800026cc:	e4a6                	sd	s1,72(sp)
    800026ce:	e0ca                	sd	s2,64(sp)
    800026d0:	fc4e                	sd	s3,56(sp)
    800026d2:	f852                	sd	s4,48(sp)
    800026d4:	f456                	sd	s5,40(sp)
    800026d6:	f05a                	sd	s6,32(sp)
    800026d8:	ec5e                	sd	s7,24(sp)
    800026da:	e862                	sd	s8,16(sp)
    800026dc:	e466                	sd	s9,8(sp)
    800026de:	1080                	addi	s0,sp,96
  for (b = 0; b < sb.size; b += BPB) {
    800026e0:	00014797          	auipc	a5,0x14
    800026e4:	74c7a783          	lw	a5,1868(a5) # 80016e2c <sb+0x4>
    800026e8:	cff5                	beqz	a5,800027e4 <balloc+0x11e>
    800026ea:	8baa                	mv	s7,a0
    800026ec:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026ee:	00014b17          	auipc	s6,0x14
    800026f2:	73ab0b13          	addi	s6,s6,1850 # 80016e28 <sb>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800026f6:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026f8:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800026fa:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    800026fc:	6c89                	lui	s9,0x2
    800026fe:	a061                	j	80002786 <balloc+0xc0>
        bp->data[bi / 8] |= m;            // Mark block in use.
    80002700:	97ca                	add	a5,a5,s2
    80002702:	8e55                	or	a2,a2,a3
    80002704:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002708:	854a                	mv	a0,s2
    8000270a:	00001097          	auipc	ra,0x1
    8000270e:	0b4080e7          	jalr	180(ra) # 800037be <log_write>
        brelse(bp);
    80002712:	854a                	mv	a0,s2
    80002714:	00000097          	auipc	ra,0x0
    80002718:	e20080e7          	jalr	-480(ra) # 80002534 <brelse>
  bp = bread(dev, bno);
    8000271c:	85a6                	mv	a1,s1
    8000271e:	855e                	mv	a0,s7
    80002720:	00000097          	auipc	ra,0x0
    80002724:	ce4080e7          	jalr	-796(ra) # 80002404 <bread>
    80002728:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000272a:	40000613          	li	a2,1024
    8000272e:	4581                	li	a1,0
    80002730:	05850513          	addi	a0,a0,88
    80002734:	ffffe097          	auipc	ra,0xffffe
    80002738:	a46080e7          	jalr	-1466(ra) # 8000017a <memset>
  log_write(bp);
    8000273c:	854a                	mv	a0,s2
    8000273e:	00001097          	auipc	ra,0x1
    80002742:	080080e7          	jalr	128(ra) # 800037be <log_write>
  brelse(bp);
    80002746:	854a                	mv	a0,s2
    80002748:	00000097          	auipc	ra,0x0
    8000274c:	dec080e7          	jalr	-532(ra) # 80002534 <brelse>
}
    80002750:	8526                	mv	a0,s1
    80002752:	60e6                	ld	ra,88(sp)
    80002754:	6446                	ld	s0,80(sp)
    80002756:	64a6                	ld	s1,72(sp)
    80002758:	6906                	ld	s2,64(sp)
    8000275a:	79e2                	ld	s3,56(sp)
    8000275c:	7a42                	ld	s4,48(sp)
    8000275e:	7aa2                	ld	s5,40(sp)
    80002760:	7b02                	ld	s6,32(sp)
    80002762:	6be2                	ld	s7,24(sp)
    80002764:	6c42                	ld	s8,16(sp)
    80002766:	6ca2                	ld	s9,8(sp)
    80002768:	6125                	addi	sp,sp,96
    8000276a:	8082                	ret
    brelse(bp);
    8000276c:	854a                	mv	a0,s2
    8000276e:	00000097          	auipc	ra,0x0
    80002772:	dc6080e7          	jalr	-570(ra) # 80002534 <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    80002776:	015c87bb          	addw	a5,s9,s5
    8000277a:	00078a9b          	sext.w	s5,a5
    8000277e:	004b2703          	lw	a4,4(s6)
    80002782:	06eaf163          	bgeu	s5,a4,800027e4 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80002786:	41fad79b          	sraiw	a5,s5,0x1f
    8000278a:	0137d79b          	srliw	a5,a5,0x13
    8000278e:	015787bb          	addw	a5,a5,s5
    80002792:	40d7d79b          	sraiw	a5,a5,0xd
    80002796:	01cb2583          	lw	a1,28(s6)
    8000279a:	9dbd                	addw	a1,a1,a5
    8000279c:	855e                	mv	a0,s7
    8000279e:	00000097          	auipc	ra,0x0
    800027a2:	c66080e7          	jalr	-922(ra) # 80002404 <bread>
    800027a6:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800027a8:	004b2503          	lw	a0,4(s6)
    800027ac:	000a849b          	sext.w	s1,s5
    800027b0:	8762                	mv	a4,s8
    800027b2:	faa4fde3          	bgeu	s1,a0,8000276c <balloc+0xa6>
      m = 1 << (bi % 8);
    800027b6:	00777693          	andi	a3,a4,7
    800027ba:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) {  // Is block free?
    800027be:	41f7579b          	sraiw	a5,a4,0x1f
    800027c2:	01d7d79b          	srliw	a5,a5,0x1d
    800027c6:	9fb9                	addw	a5,a5,a4
    800027c8:	4037d79b          	sraiw	a5,a5,0x3
    800027cc:	00f90633          	add	a2,s2,a5
    800027d0:	05864603          	lbu	a2,88(a2)
    800027d4:	00c6f5b3          	and	a1,a3,a2
    800027d8:	d585                	beqz	a1,80002700 <balloc+0x3a>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800027da:	2705                	addiw	a4,a4,1
    800027dc:	2485                	addiw	s1,s1,1
    800027de:	fd471ae3          	bne	a4,s4,800027b2 <balloc+0xec>
    800027e2:	b769                	j	8000276c <balloc+0xa6>
  printf("balloc: out of blocks\n");
    800027e4:	00006517          	auipc	a0,0x6
    800027e8:	d0c50513          	addi	a0,a0,-756 # 800084f0 <syscalls+0x110>
    800027ec:	00003097          	auipc	ra,0x3
    800027f0:	52a080e7          	jalr	1322(ra) # 80005d16 <printf>
  return 0;
    800027f4:	4481                	li	s1,0
    800027f6:	bfa9                	j	80002750 <balloc+0x8a>

00000000800027f8 <bmap>:
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint bmap(struct inode *ip, uint bn) {
    800027f8:	7179                	addi	sp,sp,-48
    800027fa:	f406                	sd	ra,40(sp)
    800027fc:	f022                	sd	s0,32(sp)
    800027fe:	ec26                	sd	s1,24(sp)
    80002800:	e84a                	sd	s2,16(sp)
    80002802:	e44e                	sd	s3,8(sp)
    80002804:	e052                	sd	s4,0(sp)
    80002806:	1800                	addi	s0,sp,48
    80002808:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    8000280a:	47ad                	li	a5,11
    8000280c:	02b7e863          	bltu	a5,a1,8000283c <bmap+0x44>
    if ((addr = ip->addrs[bn]) == 0) {
    80002810:	02059793          	slli	a5,a1,0x20
    80002814:	01e7d593          	srli	a1,a5,0x1e
    80002818:	00b504b3          	add	s1,a0,a1
    8000281c:	0504a903          	lw	s2,80(s1)
    80002820:	06091e63          	bnez	s2,8000289c <bmap+0xa4>
      addr = balloc(ip->dev);
    80002824:	4108                	lw	a0,0(a0)
    80002826:	00000097          	auipc	ra,0x0
    8000282a:	ea0080e7          	jalr	-352(ra) # 800026c6 <balloc>
    8000282e:	0005091b          	sext.w	s2,a0
      if (addr == 0) return 0;
    80002832:	06090563          	beqz	s2,8000289c <bmap+0xa4>
      ip->addrs[bn] = addr;
    80002836:	0524a823          	sw	s2,80(s1)
    8000283a:	a08d                	j	8000289c <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000283c:	ff45849b          	addiw	s1,a1,-12
    80002840:	0004871b          	sext.w	a4,s1

  if (bn < NINDIRECT) {
    80002844:	0ff00793          	li	a5,255
    80002848:	08e7e563          	bltu	a5,a4,800028d2 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    8000284c:	08052903          	lw	s2,128(a0)
    80002850:	00091d63          	bnez	s2,8000286a <bmap+0x72>
      addr = balloc(ip->dev);
    80002854:	4108                	lw	a0,0(a0)
    80002856:	00000097          	auipc	ra,0x0
    8000285a:	e70080e7          	jalr	-400(ra) # 800026c6 <balloc>
    8000285e:	0005091b          	sext.w	s2,a0
      if (addr == 0) return 0;
    80002862:	02090d63          	beqz	s2,8000289c <bmap+0xa4>
      ip->addrs[NDIRECT] = addr;
    80002866:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000286a:	85ca                	mv	a1,s2
    8000286c:	0009a503          	lw	a0,0(s3)
    80002870:	00000097          	auipc	ra,0x0
    80002874:	b94080e7          	jalr	-1132(ra) # 80002404 <bread>
    80002878:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    8000287a:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    8000287e:	02049713          	slli	a4,s1,0x20
    80002882:	01e75593          	srli	a1,a4,0x1e
    80002886:	00b784b3          	add	s1,a5,a1
    8000288a:	0004a903          	lw	s2,0(s1)
    8000288e:	02090063          	beqz	s2,800028ae <bmap+0xb6>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002892:	8552                	mv	a0,s4
    80002894:	00000097          	auipc	ra,0x0
    80002898:	ca0080e7          	jalr	-864(ra) # 80002534 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000289c:	854a                	mv	a0,s2
    8000289e:	70a2                	ld	ra,40(sp)
    800028a0:	7402                	ld	s0,32(sp)
    800028a2:	64e2                	ld	s1,24(sp)
    800028a4:	6942                	ld	s2,16(sp)
    800028a6:	69a2                	ld	s3,8(sp)
    800028a8:	6a02                	ld	s4,0(sp)
    800028aa:	6145                	addi	sp,sp,48
    800028ac:	8082                	ret
      addr = balloc(ip->dev);
    800028ae:	0009a503          	lw	a0,0(s3)
    800028b2:	00000097          	auipc	ra,0x0
    800028b6:	e14080e7          	jalr	-492(ra) # 800026c6 <balloc>
    800028ba:	0005091b          	sext.w	s2,a0
      if (addr) {
    800028be:	fc090ae3          	beqz	s2,80002892 <bmap+0x9a>
        a[bn] = addr;
    800028c2:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800028c6:	8552                	mv	a0,s4
    800028c8:	00001097          	auipc	ra,0x1
    800028cc:	ef6080e7          	jalr	-266(ra) # 800037be <log_write>
    800028d0:	b7c9                	j	80002892 <bmap+0x9a>
  panic("bmap: out of range");
    800028d2:	00006517          	auipc	a0,0x6
    800028d6:	c3650513          	addi	a0,a0,-970 # 80008508 <syscalls+0x128>
    800028da:	00003097          	auipc	ra,0x3
    800028de:	3f2080e7          	jalr	1010(ra) # 80005ccc <panic>

00000000800028e2 <iget>:
static struct inode *iget(uint dev, uint inum) {
    800028e2:	7179                	addi	sp,sp,-48
    800028e4:	f406                	sd	ra,40(sp)
    800028e6:	f022                	sd	s0,32(sp)
    800028e8:	ec26                	sd	s1,24(sp)
    800028ea:	e84a                	sd	s2,16(sp)
    800028ec:	e44e                	sd	s3,8(sp)
    800028ee:	e052                	sd	s4,0(sp)
    800028f0:	1800                	addi	s0,sp,48
    800028f2:	89aa                	mv	s3,a0
    800028f4:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028f6:	00014517          	auipc	a0,0x14
    800028fa:	55250513          	addi	a0,a0,1362 # 80016e48 <itable>
    800028fe:	00004097          	auipc	ra,0x4
    80002902:	906080e7          	jalr	-1786(ra) # 80006204 <acquire>
  empty = 0;
    80002906:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80002908:	00014497          	auipc	s1,0x14
    8000290c:	55848493          	addi	s1,s1,1368 # 80016e60 <itable+0x18>
    80002910:	00016697          	auipc	a3,0x16
    80002914:	fe068693          	addi	a3,a3,-32 # 800188f0 <log>
    80002918:	a039                	j	80002926 <iget+0x44>
    if (empty == 0 && ip->ref == 0)  // Remember empty slot.
    8000291a:	02090b63          	beqz	s2,80002950 <iget+0x6e>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    8000291e:	08848493          	addi	s1,s1,136
    80002922:	02d48a63          	beq	s1,a3,80002956 <iget+0x74>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    80002926:	449c                	lw	a5,8(s1)
    80002928:	fef059e3          	blez	a5,8000291a <iget+0x38>
    8000292c:	4098                	lw	a4,0(s1)
    8000292e:	ff3716e3          	bne	a4,s3,8000291a <iget+0x38>
    80002932:	40d8                	lw	a4,4(s1)
    80002934:	ff4713e3          	bne	a4,s4,8000291a <iget+0x38>
      ip->ref++;
    80002938:	2785                	addiw	a5,a5,1
    8000293a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000293c:	00014517          	auipc	a0,0x14
    80002940:	50c50513          	addi	a0,a0,1292 # 80016e48 <itable>
    80002944:	00004097          	auipc	ra,0x4
    80002948:	974080e7          	jalr	-1676(ra) # 800062b8 <release>
      return ip;
    8000294c:	8926                	mv	s2,s1
    8000294e:	a03d                	j	8000297c <iget+0x9a>
    if (empty == 0 && ip->ref == 0)  // Remember empty slot.
    80002950:	f7f9                	bnez	a5,8000291e <iget+0x3c>
    80002952:	8926                	mv	s2,s1
    80002954:	b7e9                	j	8000291e <iget+0x3c>
  if (empty == 0) panic("iget: no inodes");
    80002956:	02090c63          	beqz	s2,8000298e <iget+0xac>
  ip->dev = dev;
    8000295a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000295e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002962:	4785                	li	a5,1
    80002964:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002968:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000296c:	00014517          	auipc	a0,0x14
    80002970:	4dc50513          	addi	a0,a0,1244 # 80016e48 <itable>
    80002974:	00004097          	auipc	ra,0x4
    80002978:	944080e7          	jalr	-1724(ra) # 800062b8 <release>
}
    8000297c:	854a                	mv	a0,s2
    8000297e:	70a2                	ld	ra,40(sp)
    80002980:	7402                	ld	s0,32(sp)
    80002982:	64e2                	ld	s1,24(sp)
    80002984:	6942                	ld	s2,16(sp)
    80002986:	69a2                	ld	s3,8(sp)
    80002988:	6a02                	ld	s4,0(sp)
    8000298a:	6145                	addi	sp,sp,48
    8000298c:	8082                	ret
  if (empty == 0) panic("iget: no inodes");
    8000298e:	00006517          	auipc	a0,0x6
    80002992:	b9250513          	addi	a0,a0,-1134 # 80008520 <syscalls+0x140>
    80002996:	00003097          	auipc	ra,0x3
    8000299a:	336080e7          	jalr	822(ra) # 80005ccc <panic>

000000008000299e <fsinit>:
void fsinit(int dev) {
    8000299e:	7179                	addi	sp,sp,-48
    800029a0:	f406                	sd	ra,40(sp)
    800029a2:	f022                	sd	s0,32(sp)
    800029a4:	ec26                	sd	s1,24(sp)
    800029a6:	e84a                	sd	s2,16(sp)
    800029a8:	e44e                	sd	s3,8(sp)
    800029aa:	1800                	addi	s0,sp,48
    800029ac:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029ae:	4585                	li	a1,1
    800029b0:	00000097          	auipc	ra,0x0
    800029b4:	a54080e7          	jalr	-1452(ra) # 80002404 <bread>
    800029b8:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029ba:	00014997          	auipc	s3,0x14
    800029be:	46e98993          	addi	s3,s3,1134 # 80016e28 <sb>
    800029c2:	02000613          	li	a2,32
    800029c6:	05850593          	addi	a1,a0,88
    800029ca:	854e                	mv	a0,s3
    800029cc:	ffffe097          	auipc	ra,0xffffe
    800029d0:	80a080e7          	jalr	-2038(ra) # 800001d6 <memmove>
  brelse(bp);
    800029d4:	8526                	mv	a0,s1
    800029d6:	00000097          	auipc	ra,0x0
    800029da:	b5e080e7          	jalr	-1186(ra) # 80002534 <brelse>
  if (sb.magic != FSMAGIC) panic("invalid file system");
    800029de:	0009a703          	lw	a4,0(s3)
    800029e2:	102037b7          	lui	a5,0x10203
    800029e6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029ea:	02f71263          	bne	a4,a5,80002a0e <fsinit+0x70>
  initlog(dev, &sb);
    800029ee:	00014597          	auipc	a1,0x14
    800029f2:	43a58593          	addi	a1,a1,1082 # 80016e28 <sb>
    800029f6:	854a                	mv	a0,s2
    800029f8:	00001097          	auipc	ra,0x1
    800029fc:	b4a080e7          	jalr	-1206(ra) # 80003542 <initlog>
}
    80002a00:	70a2                	ld	ra,40(sp)
    80002a02:	7402                	ld	s0,32(sp)
    80002a04:	64e2                	ld	s1,24(sp)
    80002a06:	6942                	ld	s2,16(sp)
    80002a08:	69a2                	ld	s3,8(sp)
    80002a0a:	6145                	addi	sp,sp,48
    80002a0c:	8082                	ret
  if (sb.magic != FSMAGIC) panic("invalid file system");
    80002a0e:	00006517          	auipc	a0,0x6
    80002a12:	b2250513          	addi	a0,a0,-1246 # 80008530 <syscalls+0x150>
    80002a16:	00003097          	auipc	ra,0x3
    80002a1a:	2b6080e7          	jalr	694(ra) # 80005ccc <panic>

0000000080002a1e <iinit>:
void iinit() {
    80002a1e:	7179                	addi	sp,sp,-48
    80002a20:	f406                	sd	ra,40(sp)
    80002a22:	f022                	sd	s0,32(sp)
    80002a24:	ec26                	sd	s1,24(sp)
    80002a26:	e84a                	sd	s2,16(sp)
    80002a28:	e44e                	sd	s3,8(sp)
    80002a2a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a2c:	00006597          	auipc	a1,0x6
    80002a30:	b1c58593          	addi	a1,a1,-1252 # 80008548 <syscalls+0x168>
    80002a34:	00014517          	auipc	a0,0x14
    80002a38:	41450513          	addi	a0,a0,1044 # 80016e48 <itable>
    80002a3c:	00003097          	auipc	ra,0x3
    80002a40:	738080e7          	jalr	1848(ra) # 80006174 <initlock>
  for (i = 0; i < NINODE; i++) {
    80002a44:	00014497          	auipc	s1,0x14
    80002a48:	42c48493          	addi	s1,s1,1068 # 80016e70 <itable+0x28>
    80002a4c:	00016997          	auipc	s3,0x16
    80002a50:	eb498993          	addi	s3,s3,-332 # 80018900 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a54:	00006917          	auipc	s2,0x6
    80002a58:	afc90913          	addi	s2,s2,-1284 # 80008550 <syscalls+0x170>
    80002a5c:	85ca                	mv	a1,s2
    80002a5e:	8526                	mv	a0,s1
    80002a60:	00001097          	auipc	ra,0x1
    80002a64:	e42080e7          	jalr	-446(ra) # 800038a2 <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    80002a68:	08848493          	addi	s1,s1,136
    80002a6c:	ff3498e3          	bne	s1,s3,80002a5c <iinit+0x3e>
}
    80002a70:	70a2                	ld	ra,40(sp)
    80002a72:	7402                	ld	s0,32(sp)
    80002a74:	64e2                	ld	s1,24(sp)
    80002a76:	6942                	ld	s2,16(sp)
    80002a78:	69a2                	ld	s3,8(sp)
    80002a7a:	6145                	addi	sp,sp,48
    80002a7c:	8082                	ret

0000000080002a7e <ialloc>:
struct inode *ialloc(uint dev, short type) {
    80002a7e:	715d                	addi	sp,sp,-80
    80002a80:	e486                	sd	ra,72(sp)
    80002a82:	e0a2                	sd	s0,64(sp)
    80002a84:	fc26                	sd	s1,56(sp)
    80002a86:	f84a                	sd	s2,48(sp)
    80002a88:	f44e                	sd	s3,40(sp)
    80002a8a:	f052                	sd	s4,32(sp)
    80002a8c:	ec56                	sd	s5,24(sp)
    80002a8e:	e85a                	sd	s6,16(sp)
    80002a90:	e45e                	sd	s7,8(sp)
    80002a92:	0880                	addi	s0,sp,80
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002a94:	00014717          	auipc	a4,0x14
    80002a98:	3a072703          	lw	a4,928(a4) # 80016e34 <sb+0xc>
    80002a9c:	4785                	li	a5,1
    80002a9e:	04e7fa63          	bgeu	a5,a4,80002af2 <ialloc+0x74>
    80002aa2:	8aaa                	mv	s5,a0
    80002aa4:	8bae                	mv	s7,a1
    80002aa6:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002aa8:	00014a17          	auipc	s4,0x14
    80002aac:	380a0a13          	addi	s4,s4,896 # 80016e28 <sb>
    80002ab0:	00048b1b          	sext.w	s6,s1
    80002ab4:	0044d593          	srli	a1,s1,0x4
    80002ab8:	018a2783          	lw	a5,24(s4)
    80002abc:	9dbd                	addw	a1,a1,a5
    80002abe:	8556                	mv	a0,s5
    80002ac0:	00000097          	auipc	ra,0x0
    80002ac4:	944080e7          	jalr	-1724(ra) # 80002404 <bread>
    80002ac8:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80002aca:	05850993          	addi	s3,a0,88
    80002ace:	00f4f793          	andi	a5,s1,15
    80002ad2:	079a                	slli	a5,a5,0x6
    80002ad4:	99be                	add	s3,s3,a5
    if (dip->type == 0) {  // a free inode
    80002ad6:	00099783          	lh	a5,0(s3)
    80002ada:	c3a1                	beqz	a5,80002b1a <ialloc+0x9c>
    brelse(bp);
    80002adc:	00000097          	auipc	ra,0x0
    80002ae0:	a58080e7          	jalr	-1448(ra) # 80002534 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002ae4:	0485                	addi	s1,s1,1
    80002ae6:	00ca2703          	lw	a4,12(s4)
    80002aea:	0004879b          	sext.w	a5,s1
    80002aee:	fce7e1e3          	bltu	a5,a4,80002ab0 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002af2:	00006517          	auipc	a0,0x6
    80002af6:	a6650513          	addi	a0,a0,-1434 # 80008558 <syscalls+0x178>
    80002afa:	00003097          	auipc	ra,0x3
    80002afe:	21c080e7          	jalr	540(ra) # 80005d16 <printf>
  return 0;
    80002b02:	4501                	li	a0,0
}
    80002b04:	60a6                	ld	ra,72(sp)
    80002b06:	6406                	ld	s0,64(sp)
    80002b08:	74e2                	ld	s1,56(sp)
    80002b0a:	7942                	ld	s2,48(sp)
    80002b0c:	79a2                	ld	s3,40(sp)
    80002b0e:	7a02                	ld	s4,32(sp)
    80002b10:	6ae2                	ld	s5,24(sp)
    80002b12:	6b42                	ld	s6,16(sp)
    80002b14:	6ba2                	ld	s7,8(sp)
    80002b16:	6161                	addi	sp,sp,80
    80002b18:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b1a:	04000613          	li	a2,64
    80002b1e:	4581                	li	a1,0
    80002b20:	854e                	mv	a0,s3
    80002b22:	ffffd097          	auipc	ra,0xffffd
    80002b26:	658080e7          	jalr	1624(ra) # 8000017a <memset>
      dip->type = type;
    80002b2a:	01799023          	sh	s7,0(s3)
      log_write(bp);  // mark it allocated on the disk
    80002b2e:	854a                	mv	a0,s2
    80002b30:	00001097          	auipc	ra,0x1
    80002b34:	c8e080e7          	jalr	-882(ra) # 800037be <log_write>
      brelse(bp);
    80002b38:	854a                	mv	a0,s2
    80002b3a:	00000097          	auipc	ra,0x0
    80002b3e:	9fa080e7          	jalr	-1542(ra) # 80002534 <brelse>
      return iget(dev, inum);
    80002b42:	85da                	mv	a1,s6
    80002b44:	8556                	mv	a0,s5
    80002b46:	00000097          	auipc	ra,0x0
    80002b4a:	d9c080e7          	jalr	-612(ra) # 800028e2 <iget>
    80002b4e:	bf5d                	j	80002b04 <ialloc+0x86>

0000000080002b50 <iupdate>:
void iupdate(struct inode *ip) {
    80002b50:	1101                	addi	sp,sp,-32
    80002b52:	ec06                	sd	ra,24(sp)
    80002b54:	e822                	sd	s0,16(sp)
    80002b56:	e426                	sd	s1,8(sp)
    80002b58:	e04a                	sd	s2,0(sp)
    80002b5a:	1000                	addi	s0,sp,32
    80002b5c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b5e:	415c                	lw	a5,4(a0)
    80002b60:	0047d79b          	srliw	a5,a5,0x4
    80002b64:	00014597          	auipc	a1,0x14
    80002b68:	2dc5a583          	lw	a1,732(a1) # 80016e40 <sb+0x18>
    80002b6c:	9dbd                	addw	a1,a1,a5
    80002b6e:	4108                	lw	a0,0(a0)
    80002b70:	00000097          	auipc	ra,0x0
    80002b74:	894080e7          	jalr	-1900(ra) # 80002404 <bread>
    80002b78:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002b7a:	05850793          	addi	a5,a0,88
    80002b7e:	40d8                	lw	a4,4(s1)
    80002b80:	8b3d                	andi	a4,a4,15
    80002b82:	071a                	slli	a4,a4,0x6
    80002b84:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b86:	04449703          	lh	a4,68(s1)
    80002b8a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b8e:	04649703          	lh	a4,70(s1)
    80002b92:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b96:	04849703          	lh	a4,72(s1)
    80002b9a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b9e:	04a49703          	lh	a4,74(s1)
    80002ba2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002ba6:	44f8                	lw	a4,76(s1)
    80002ba8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002baa:	03400613          	li	a2,52
    80002bae:	05048593          	addi	a1,s1,80
    80002bb2:	00c78513          	addi	a0,a5,12
    80002bb6:	ffffd097          	auipc	ra,0xffffd
    80002bba:	620080e7          	jalr	1568(ra) # 800001d6 <memmove>
  log_write(bp);
    80002bbe:	854a                	mv	a0,s2
    80002bc0:	00001097          	auipc	ra,0x1
    80002bc4:	bfe080e7          	jalr	-1026(ra) # 800037be <log_write>
  brelse(bp);
    80002bc8:	854a                	mv	a0,s2
    80002bca:	00000097          	auipc	ra,0x0
    80002bce:	96a080e7          	jalr	-1686(ra) # 80002534 <brelse>
}
    80002bd2:	60e2                	ld	ra,24(sp)
    80002bd4:	6442                	ld	s0,16(sp)
    80002bd6:	64a2                	ld	s1,8(sp)
    80002bd8:	6902                	ld	s2,0(sp)
    80002bda:	6105                	addi	sp,sp,32
    80002bdc:	8082                	ret

0000000080002bde <idup>:
struct inode *idup(struct inode *ip) {
    80002bde:	1101                	addi	sp,sp,-32
    80002be0:	ec06                	sd	ra,24(sp)
    80002be2:	e822                	sd	s0,16(sp)
    80002be4:	e426                	sd	s1,8(sp)
    80002be6:	1000                	addi	s0,sp,32
    80002be8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bea:	00014517          	auipc	a0,0x14
    80002bee:	25e50513          	addi	a0,a0,606 # 80016e48 <itable>
    80002bf2:	00003097          	auipc	ra,0x3
    80002bf6:	612080e7          	jalr	1554(ra) # 80006204 <acquire>
  ip->ref++;
    80002bfa:	449c                	lw	a5,8(s1)
    80002bfc:	2785                	addiw	a5,a5,1
    80002bfe:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c00:	00014517          	auipc	a0,0x14
    80002c04:	24850513          	addi	a0,a0,584 # 80016e48 <itable>
    80002c08:	00003097          	auipc	ra,0x3
    80002c0c:	6b0080e7          	jalr	1712(ra) # 800062b8 <release>
}
    80002c10:	8526                	mv	a0,s1
    80002c12:	60e2                	ld	ra,24(sp)
    80002c14:	6442                	ld	s0,16(sp)
    80002c16:	64a2                	ld	s1,8(sp)
    80002c18:	6105                	addi	sp,sp,32
    80002c1a:	8082                	ret

0000000080002c1c <ilock>:
void ilock(struct inode *ip) {
    80002c1c:	1101                	addi	sp,sp,-32
    80002c1e:	ec06                	sd	ra,24(sp)
    80002c20:	e822                	sd	s0,16(sp)
    80002c22:	e426                	sd	s1,8(sp)
    80002c24:	e04a                	sd	s2,0(sp)
    80002c26:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1) panic("ilock");
    80002c28:	c115                	beqz	a0,80002c4c <ilock+0x30>
    80002c2a:	84aa                	mv	s1,a0
    80002c2c:	451c                	lw	a5,8(a0)
    80002c2e:	00f05f63          	blez	a5,80002c4c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c32:	0541                	addi	a0,a0,16
    80002c34:	00001097          	auipc	ra,0x1
    80002c38:	ca8080e7          	jalr	-856(ra) # 800038dc <acquiresleep>
  if (ip->valid == 0) {
    80002c3c:	40bc                	lw	a5,64(s1)
    80002c3e:	cf99                	beqz	a5,80002c5c <ilock+0x40>
}
    80002c40:	60e2                	ld	ra,24(sp)
    80002c42:	6442                	ld	s0,16(sp)
    80002c44:	64a2                	ld	s1,8(sp)
    80002c46:	6902                	ld	s2,0(sp)
    80002c48:	6105                	addi	sp,sp,32
    80002c4a:	8082                	ret
  if (ip == 0 || ip->ref < 1) panic("ilock");
    80002c4c:	00006517          	auipc	a0,0x6
    80002c50:	92450513          	addi	a0,a0,-1756 # 80008570 <syscalls+0x190>
    80002c54:	00003097          	auipc	ra,0x3
    80002c58:	078080e7          	jalr	120(ra) # 80005ccc <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c5c:	40dc                	lw	a5,4(s1)
    80002c5e:	0047d79b          	srliw	a5,a5,0x4
    80002c62:	00014597          	auipc	a1,0x14
    80002c66:	1de5a583          	lw	a1,478(a1) # 80016e40 <sb+0x18>
    80002c6a:	9dbd                	addw	a1,a1,a5
    80002c6c:	4088                	lw	a0,0(s1)
    80002c6e:	fffff097          	auipc	ra,0xfffff
    80002c72:	796080e7          	jalr	1942(ra) # 80002404 <bread>
    80002c76:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002c78:	05850593          	addi	a1,a0,88
    80002c7c:	40dc                	lw	a5,4(s1)
    80002c7e:	8bbd                	andi	a5,a5,15
    80002c80:	079a                	slli	a5,a5,0x6
    80002c82:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c84:	00059783          	lh	a5,0(a1)
    80002c88:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c8c:	00259783          	lh	a5,2(a1)
    80002c90:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c94:	00459783          	lh	a5,4(a1)
    80002c98:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c9c:	00659783          	lh	a5,6(a1)
    80002ca0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002ca4:	459c                	lw	a5,8(a1)
    80002ca6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002ca8:	03400613          	li	a2,52
    80002cac:	05b1                	addi	a1,a1,12
    80002cae:	05048513          	addi	a0,s1,80
    80002cb2:	ffffd097          	auipc	ra,0xffffd
    80002cb6:	524080e7          	jalr	1316(ra) # 800001d6 <memmove>
    brelse(bp);
    80002cba:	854a                	mv	a0,s2
    80002cbc:	00000097          	auipc	ra,0x0
    80002cc0:	878080e7          	jalr	-1928(ra) # 80002534 <brelse>
    ip->valid = 1;
    80002cc4:	4785                	li	a5,1
    80002cc6:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0) panic("ilock: no type");
    80002cc8:	04449783          	lh	a5,68(s1)
    80002ccc:	fbb5                	bnez	a5,80002c40 <ilock+0x24>
    80002cce:	00006517          	auipc	a0,0x6
    80002cd2:	8aa50513          	addi	a0,a0,-1878 # 80008578 <syscalls+0x198>
    80002cd6:	00003097          	auipc	ra,0x3
    80002cda:	ff6080e7          	jalr	-10(ra) # 80005ccc <panic>

0000000080002cde <iunlock>:
void iunlock(struct inode *ip) {
    80002cde:	1101                	addi	sp,sp,-32
    80002ce0:	ec06                	sd	ra,24(sp)
    80002ce2:	e822                	sd	s0,16(sp)
    80002ce4:	e426                	sd	s1,8(sp)
    80002ce6:	e04a                	sd	s2,0(sp)
    80002ce8:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
    80002cea:	c905                	beqz	a0,80002d1a <iunlock+0x3c>
    80002cec:	84aa                	mv	s1,a0
    80002cee:	01050913          	addi	s2,a0,16
    80002cf2:	854a                	mv	a0,s2
    80002cf4:	00001097          	auipc	ra,0x1
    80002cf8:	c82080e7          	jalr	-894(ra) # 80003976 <holdingsleep>
    80002cfc:	cd19                	beqz	a0,80002d1a <iunlock+0x3c>
    80002cfe:	449c                	lw	a5,8(s1)
    80002d00:	00f05d63          	blez	a5,80002d1a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d04:	854a                	mv	a0,s2
    80002d06:	00001097          	auipc	ra,0x1
    80002d0a:	c2c080e7          	jalr	-980(ra) # 80003932 <releasesleep>
}
    80002d0e:	60e2                	ld	ra,24(sp)
    80002d10:	6442                	ld	s0,16(sp)
    80002d12:	64a2                	ld	s1,8(sp)
    80002d14:	6902                	ld	s2,0(sp)
    80002d16:	6105                	addi	sp,sp,32
    80002d18:	8082                	ret
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
    80002d1a:	00006517          	auipc	a0,0x6
    80002d1e:	86e50513          	addi	a0,a0,-1938 # 80008588 <syscalls+0x1a8>
    80002d22:	00003097          	auipc	ra,0x3
    80002d26:	faa080e7          	jalr	-86(ra) # 80005ccc <panic>

0000000080002d2a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip) {
    80002d2a:	7179                	addi	sp,sp,-48
    80002d2c:	f406                	sd	ra,40(sp)
    80002d2e:	f022                	sd	s0,32(sp)
    80002d30:	ec26                	sd	s1,24(sp)
    80002d32:	e84a                	sd	s2,16(sp)
    80002d34:	e44e                	sd	s3,8(sp)
    80002d36:	e052                	sd	s4,0(sp)
    80002d38:	1800                	addi	s0,sp,48
    80002d3a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    80002d3c:	05050493          	addi	s1,a0,80
    80002d40:	08050913          	addi	s2,a0,128
    80002d44:	a021                	j	80002d4c <itrunc+0x22>
    80002d46:	0491                	addi	s1,s1,4
    80002d48:	01248d63          	beq	s1,s2,80002d62 <itrunc+0x38>
    if (ip->addrs[i]) {
    80002d4c:	408c                	lw	a1,0(s1)
    80002d4e:	dde5                	beqz	a1,80002d46 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d50:	0009a503          	lw	a0,0(s3)
    80002d54:	00000097          	auipc	ra,0x0
    80002d58:	8f6080e7          	jalr	-1802(ra) # 8000264a <bfree>
      ip->addrs[i] = 0;
    80002d5c:	0004a023          	sw	zero,0(s1)
    80002d60:	b7dd                	j	80002d46 <itrunc+0x1c>
    }
  }

  if (ip->addrs[NDIRECT]) {
    80002d62:	0809a583          	lw	a1,128(s3)
    80002d66:	e185                	bnez	a1,80002d86 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d68:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d6c:	854e                	mv	a0,s3
    80002d6e:	00000097          	auipc	ra,0x0
    80002d72:	de2080e7          	jalr	-542(ra) # 80002b50 <iupdate>
}
    80002d76:	70a2                	ld	ra,40(sp)
    80002d78:	7402                	ld	s0,32(sp)
    80002d7a:	64e2                	ld	s1,24(sp)
    80002d7c:	6942                	ld	s2,16(sp)
    80002d7e:	69a2                	ld	s3,8(sp)
    80002d80:	6a02                	ld	s4,0(sp)
    80002d82:	6145                	addi	sp,sp,48
    80002d84:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d86:	0009a503          	lw	a0,0(s3)
    80002d8a:	fffff097          	auipc	ra,0xfffff
    80002d8e:	67a080e7          	jalr	1658(ra) # 80002404 <bread>
    80002d92:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    80002d94:	05850493          	addi	s1,a0,88
    80002d98:	45850913          	addi	s2,a0,1112
    80002d9c:	a021                	j	80002da4 <itrunc+0x7a>
    80002d9e:	0491                	addi	s1,s1,4
    80002da0:	01248b63          	beq	s1,s2,80002db6 <itrunc+0x8c>
      if (a[j]) bfree(ip->dev, a[j]);
    80002da4:	408c                	lw	a1,0(s1)
    80002da6:	dde5                	beqz	a1,80002d9e <itrunc+0x74>
    80002da8:	0009a503          	lw	a0,0(s3)
    80002dac:	00000097          	auipc	ra,0x0
    80002db0:	89e080e7          	jalr	-1890(ra) # 8000264a <bfree>
    80002db4:	b7ed                	j	80002d9e <itrunc+0x74>
    brelse(bp);
    80002db6:	8552                	mv	a0,s4
    80002db8:	fffff097          	auipc	ra,0xfffff
    80002dbc:	77c080e7          	jalr	1916(ra) # 80002534 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002dc0:	0809a583          	lw	a1,128(s3)
    80002dc4:	0009a503          	lw	a0,0(s3)
    80002dc8:	00000097          	auipc	ra,0x0
    80002dcc:	882080e7          	jalr	-1918(ra) # 8000264a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002dd0:	0809a023          	sw	zero,128(s3)
    80002dd4:	bf51                	j	80002d68 <itrunc+0x3e>

0000000080002dd6 <iput>:
void iput(struct inode *ip) {
    80002dd6:	1101                	addi	sp,sp,-32
    80002dd8:	ec06                	sd	ra,24(sp)
    80002dda:	e822                	sd	s0,16(sp)
    80002ddc:	e426                	sd	s1,8(sp)
    80002dde:	e04a                	sd	s2,0(sp)
    80002de0:	1000                	addi	s0,sp,32
    80002de2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002de4:	00014517          	auipc	a0,0x14
    80002de8:	06450513          	addi	a0,a0,100 # 80016e48 <itable>
    80002dec:	00003097          	auipc	ra,0x3
    80002df0:	418080e7          	jalr	1048(ra) # 80006204 <acquire>
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002df4:	4498                	lw	a4,8(s1)
    80002df6:	4785                	li	a5,1
    80002df8:	02f70363          	beq	a4,a5,80002e1e <iput+0x48>
  ip->ref--;
    80002dfc:	449c                	lw	a5,8(s1)
    80002dfe:	37fd                	addiw	a5,a5,-1
    80002e00:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e02:	00014517          	auipc	a0,0x14
    80002e06:	04650513          	addi	a0,a0,70 # 80016e48 <itable>
    80002e0a:	00003097          	auipc	ra,0x3
    80002e0e:	4ae080e7          	jalr	1198(ra) # 800062b8 <release>
}
    80002e12:	60e2                	ld	ra,24(sp)
    80002e14:	6442                	ld	s0,16(sp)
    80002e16:	64a2                	ld	s1,8(sp)
    80002e18:	6902                	ld	s2,0(sp)
    80002e1a:	6105                	addi	sp,sp,32
    80002e1c:	8082                	ret
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002e1e:	40bc                	lw	a5,64(s1)
    80002e20:	dff1                	beqz	a5,80002dfc <iput+0x26>
    80002e22:	04a49783          	lh	a5,74(s1)
    80002e26:	fbf9                	bnez	a5,80002dfc <iput+0x26>
    acquiresleep(&ip->lock);
    80002e28:	01048913          	addi	s2,s1,16
    80002e2c:	854a                	mv	a0,s2
    80002e2e:	00001097          	auipc	ra,0x1
    80002e32:	aae080e7          	jalr	-1362(ra) # 800038dc <acquiresleep>
    release(&itable.lock);
    80002e36:	00014517          	auipc	a0,0x14
    80002e3a:	01250513          	addi	a0,a0,18 # 80016e48 <itable>
    80002e3e:	00003097          	auipc	ra,0x3
    80002e42:	47a080e7          	jalr	1146(ra) # 800062b8 <release>
    itrunc(ip);
    80002e46:	8526                	mv	a0,s1
    80002e48:	00000097          	auipc	ra,0x0
    80002e4c:	ee2080e7          	jalr	-286(ra) # 80002d2a <itrunc>
    ip->type = 0;
    80002e50:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e54:	8526                	mv	a0,s1
    80002e56:	00000097          	auipc	ra,0x0
    80002e5a:	cfa080e7          	jalr	-774(ra) # 80002b50 <iupdate>
    ip->valid = 0;
    80002e5e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e62:	854a                	mv	a0,s2
    80002e64:	00001097          	auipc	ra,0x1
    80002e68:	ace080e7          	jalr	-1330(ra) # 80003932 <releasesleep>
    acquire(&itable.lock);
    80002e6c:	00014517          	auipc	a0,0x14
    80002e70:	fdc50513          	addi	a0,a0,-36 # 80016e48 <itable>
    80002e74:	00003097          	auipc	ra,0x3
    80002e78:	390080e7          	jalr	912(ra) # 80006204 <acquire>
    80002e7c:	b741                	j	80002dfc <iput+0x26>

0000000080002e7e <iunlockput>:
void iunlockput(struct inode *ip) {
    80002e7e:	1101                	addi	sp,sp,-32
    80002e80:	ec06                	sd	ra,24(sp)
    80002e82:	e822                	sd	s0,16(sp)
    80002e84:	e426                	sd	s1,8(sp)
    80002e86:	1000                	addi	s0,sp,32
    80002e88:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e8a:	00000097          	auipc	ra,0x0
    80002e8e:	e54080e7          	jalr	-428(ra) # 80002cde <iunlock>
  iput(ip);
    80002e92:	8526                	mv	a0,s1
    80002e94:	00000097          	auipc	ra,0x0
    80002e98:	f42080e7          	jalr	-190(ra) # 80002dd6 <iput>
}
    80002e9c:	60e2                	ld	ra,24(sp)
    80002e9e:	6442                	ld	s0,16(sp)
    80002ea0:	64a2                	ld	s1,8(sp)
    80002ea2:	6105                	addi	sp,sp,32
    80002ea4:	8082                	ret

0000000080002ea6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st) {
    80002ea6:	1141                	addi	sp,sp,-16
    80002ea8:	e422                	sd	s0,8(sp)
    80002eaa:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002eac:	411c                	lw	a5,0(a0)
    80002eae:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002eb0:	415c                	lw	a5,4(a0)
    80002eb2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002eb4:	04451783          	lh	a5,68(a0)
    80002eb8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ebc:	04a51783          	lh	a5,74(a0)
    80002ec0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ec4:	04c56783          	lwu	a5,76(a0)
    80002ec8:	e99c                	sd	a5,16(a1)
}
    80002eca:	6422                	ld	s0,8(sp)
    80002ecc:	0141                	addi	sp,sp,16
    80002ece:	8082                	ret

0000000080002ed0 <readi>:
// otherwise, dst is a kernel address.
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off) return 0;
    80002ed0:	457c                	lw	a5,76(a0)
    80002ed2:	0ed7e963          	bltu	a5,a3,80002fc4 <readi+0xf4>
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
    80002ed6:	7159                	addi	sp,sp,-112
    80002ed8:	f486                	sd	ra,104(sp)
    80002eda:	f0a2                	sd	s0,96(sp)
    80002edc:	eca6                	sd	s1,88(sp)
    80002ede:	e8ca                	sd	s2,80(sp)
    80002ee0:	e4ce                	sd	s3,72(sp)
    80002ee2:	e0d2                	sd	s4,64(sp)
    80002ee4:	fc56                	sd	s5,56(sp)
    80002ee6:	f85a                	sd	s6,48(sp)
    80002ee8:	f45e                	sd	s7,40(sp)
    80002eea:	f062                	sd	s8,32(sp)
    80002eec:	ec66                	sd	s9,24(sp)
    80002eee:	e86a                	sd	s10,16(sp)
    80002ef0:	e46e                	sd	s11,8(sp)
    80002ef2:	1880                	addi	s0,sp,112
    80002ef4:	8b2a                	mv	s6,a0
    80002ef6:	8bae                	mv	s7,a1
    80002ef8:	8a32                	mv	s4,a2
    80002efa:	84b6                	mv	s1,a3
    80002efc:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off) return 0;
    80002efe:	9f35                	addw	a4,a4,a3
    80002f00:	4501                	li	a0,0
    80002f02:	0ad76063          	bltu	a4,a3,80002fa2 <readi+0xd2>
  if (off + n > ip->size) n = ip->size - off;
    80002f06:	00e7f463          	bgeu	a5,a4,80002f0e <readi+0x3e>
    80002f0a:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80002f0e:	0a0a8963          	beqz	s5,80002fc0 <readi+0xf0>
    80002f12:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0) break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80002f14:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f18:	5c7d                	li	s8,-1
    80002f1a:	a82d                	j	80002f54 <readi+0x84>
    80002f1c:	020d1d93          	slli	s11,s10,0x20
    80002f20:	020ddd93          	srli	s11,s11,0x20
    80002f24:	05890613          	addi	a2,s2,88
    80002f28:	86ee                	mv	a3,s11
    80002f2a:	963a                	add	a2,a2,a4
    80002f2c:	85d2                	mv	a1,s4
    80002f2e:	855e                	mv	a0,s7
    80002f30:	fffff097          	auipc	ra,0xfffff
    80002f34:	9d4080e7          	jalr	-1580(ra) # 80001904 <either_copyout>
    80002f38:	05850d63          	beq	a0,s8,80002f92 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f3c:	854a                	mv	a0,s2
    80002f3e:	fffff097          	auipc	ra,0xfffff
    80002f42:	5f6080e7          	jalr	1526(ra) # 80002534 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80002f46:	013d09bb          	addw	s3,s10,s3
    80002f4a:	009d04bb          	addw	s1,s10,s1
    80002f4e:	9a6e                	add	s4,s4,s11
    80002f50:	0559f763          	bgeu	s3,s5,80002f9e <readi+0xce>
    uint addr = bmap(ip, off / BSIZE);
    80002f54:	00a4d59b          	srliw	a1,s1,0xa
    80002f58:	855a                	mv	a0,s6
    80002f5a:	00000097          	auipc	ra,0x0
    80002f5e:	89e080e7          	jalr	-1890(ra) # 800027f8 <bmap>
    80002f62:	0005059b          	sext.w	a1,a0
    if (addr == 0) break;
    80002f66:	cd85                	beqz	a1,80002f9e <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f68:	000b2503          	lw	a0,0(s6)
    80002f6c:	fffff097          	auipc	ra,0xfffff
    80002f70:	498080e7          	jalr	1176(ra) # 80002404 <bread>
    80002f74:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80002f76:	3ff4f713          	andi	a4,s1,1023
    80002f7a:	40ec87bb          	subw	a5,s9,a4
    80002f7e:	413a86bb          	subw	a3,s5,s3
    80002f82:	8d3e                	mv	s10,a5
    80002f84:	2781                	sext.w	a5,a5
    80002f86:	0006861b          	sext.w	a2,a3
    80002f8a:	f8f679e3          	bgeu	a2,a5,80002f1c <readi+0x4c>
    80002f8e:	8d36                	mv	s10,a3
    80002f90:	b771                	j	80002f1c <readi+0x4c>
      brelse(bp);
    80002f92:	854a                	mv	a0,s2
    80002f94:	fffff097          	auipc	ra,0xfffff
    80002f98:	5a0080e7          	jalr	1440(ra) # 80002534 <brelse>
      tot = -1;
    80002f9c:	59fd                	li	s3,-1
  }
  return tot;
    80002f9e:	0009851b          	sext.w	a0,s3
}
    80002fa2:	70a6                	ld	ra,104(sp)
    80002fa4:	7406                	ld	s0,96(sp)
    80002fa6:	64e6                	ld	s1,88(sp)
    80002fa8:	6946                	ld	s2,80(sp)
    80002faa:	69a6                	ld	s3,72(sp)
    80002fac:	6a06                	ld	s4,64(sp)
    80002fae:	7ae2                	ld	s5,56(sp)
    80002fb0:	7b42                	ld	s6,48(sp)
    80002fb2:	7ba2                	ld	s7,40(sp)
    80002fb4:	7c02                	ld	s8,32(sp)
    80002fb6:	6ce2                	ld	s9,24(sp)
    80002fb8:	6d42                	ld	s10,16(sp)
    80002fba:	6da2                	ld	s11,8(sp)
    80002fbc:	6165                	addi	sp,sp,112
    80002fbe:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80002fc0:	89d6                	mv	s3,s5
    80002fc2:	bff1                	j	80002f9e <readi+0xce>
  if (off > ip->size || off + n < off) return 0;
    80002fc4:	4501                	li	a0,0
}
    80002fc6:	8082                	ret

0000000080002fc8 <writei>:
// there was an error of some kind.
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off) return -1;
    80002fc8:	457c                	lw	a5,76(a0)
    80002fca:	10d7e863          	bltu	a5,a3,800030da <writei+0x112>
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
    80002fce:	7159                	addi	sp,sp,-112
    80002fd0:	f486                	sd	ra,104(sp)
    80002fd2:	f0a2                	sd	s0,96(sp)
    80002fd4:	eca6                	sd	s1,88(sp)
    80002fd6:	e8ca                	sd	s2,80(sp)
    80002fd8:	e4ce                	sd	s3,72(sp)
    80002fda:	e0d2                	sd	s4,64(sp)
    80002fdc:	fc56                	sd	s5,56(sp)
    80002fde:	f85a                	sd	s6,48(sp)
    80002fe0:	f45e                	sd	s7,40(sp)
    80002fe2:	f062                	sd	s8,32(sp)
    80002fe4:	ec66                	sd	s9,24(sp)
    80002fe6:	e86a                	sd	s10,16(sp)
    80002fe8:	e46e                	sd	s11,8(sp)
    80002fea:	1880                	addi	s0,sp,112
    80002fec:	8aaa                	mv	s5,a0
    80002fee:	8bae                	mv	s7,a1
    80002ff0:	8a32                	mv	s4,a2
    80002ff2:	8936                	mv	s2,a3
    80002ff4:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off) return -1;
    80002ff6:	00e687bb          	addw	a5,a3,a4
    80002ffa:	0ed7e263          	bltu	a5,a3,800030de <writei+0x116>
  if (off + n > MAXFILE * BSIZE) return -1;
    80002ffe:	00043737          	lui	a4,0x43
    80003002:	0ef76063          	bltu	a4,a5,800030e2 <writei+0x11a>

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003006:	0c0b0863          	beqz	s6,800030d6 <writei+0x10e>
    8000300a:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0) break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    8000300c:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003010:	5c7d                	li	s8,-1
    80003012:	a091                	j	80003056 <writei+0x8e>
    80003014:	020d1d93          	slli	s11,s10,0x20
    80003018:	020ddd93          	srli	s11,s11,0x20
    8000301c:	05848513          	addi	a0,s1,88
    80003020:	86ee                	mv	a3,s11
    80003022:	8652                	mv	a2,s4
    80003024:	85de                	mv	a1,s7
    80003026:	953a                	add	a0,a0,a4
    80003028:	fffff097          	auipc	ra,0xfffff
    8000302c:	932080e7          	jalr	-1742(ra) # 8000195a <either_copyin>
    80003030:	07850263          	beq	a0,s8,80003094 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003034:	8526                	mv	a0,s1
    80003036:	00000097          	auipc	ra,0x0
    8000303a:	788080e7          	jalr	1928(ra) # 800037be <log_write>
    brelse(bp);
    8000303e:	8526                	mv	a0,s1
    80003040:	fffff097          	auipc	ra,0xfffff
    80003044:	4f4080e7          	jalr	1268(ra) # 80002534 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003048:	013d09bb          	addw	s3,s10,s3
    8000304c:	012d093b          	addw	s2,s10,s2
    80003050:	9a6e                	add	s4,s4,s11
    80003052:	0569f663          	bgeu	s3,s6,8000309e <writei+0xd6>
    uint addr = bmap(ip, off / BSIZE);
    80003056:	00a9559b          	srliw	a1,s2,0xa
    8000305a:	8556                	mv	a0,s5
    8000305c:	fffff097          	auipc	ra,0xfffff
    80003060:	79c080e7          	jalr	1948(ra) # 800027f8 <bmap>
    80003064:	0005059b          	sext.w	a1,a0
    if (addr == 0) break;
    80003068:	c99d                	beqz	a1,8000309e <writei+0xd6>
    bp = bread(ip->dev, addr);
    8000306a:	000aa503          	lw	a0,0(s5)
    8000306e:	fffff097          	auipc	ra,0xfffff
    80003072:	396080e7          	jalr	918(ra) # 80002404 <bread>
    80003076:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80003078:	3ff97713          	andi	a4,s2,1023
    8000307c:	40ec87bb          	subw	a5,s9,a4
    80003080:	413b06bb          	subw	a3,s6,s3
    80003084:	8d3e                	mv	s10,a5
    80003086:	2781                	sext.w	a5,a5
    80003088:	0006861b          	sext.w	a2,a3
    8000308c:	f8f674e3          	bgeu	a2,a5,80003014 <writei+0x4c>
    80003090:	8d36                	mv	s10,a3
    80003092:	b749                	j	80003014 <writei+0x4c>
      brelse(bp);
    80003094:	8526                	mv	a0,s1
    80003096:	fffff097          	auipc	ra,0xfffff
    8000309a:	49e080e7          	jalr	1182(ra) # 80002534 <brelse>
  }

  if (off > ip->size) ip->size = off;
    8000309e:	04caa783          	lw	a5,76(s5)
    800030a2:	0127f463          	bgeu	a5,s2,800030aa <writei+0xe2>
    800030a6:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030aa:	8556                	mv	a0,s5
    800030ac:	00000097          	auipc	ra,0x0
    800030b0:	aa4080e7          	jalr	-1372(ra) # 80002b50 <iupdate>

  return tot;
    800030b4:	0009851b          	sext.w	a0,s3
}
    800030b8:	70a6                	ld	ra,104(sp)
    800030ba:	7406                	ld	s0,96(sp)
    800030bc:	64e6                	ld	s1,88(sp)
    800030be:	6946                	ld	s2,80(sp)
    800030c0:	69a6                	ld	s3,72(sp)
    800030c2:	6a06                	ld	s4,64(sp)
    800030c4:	7ae2                	ld	s5,56(sp)
    800030c6:	7b42                	ld	s6,48(sp)
    800030c8:	7ba2                	ld	s7,40(sp)
    800030ca:	7c02                	ld	s8,32(sp)
    800030cc:	6ce2                	ld	s9,24(sp)
    800030ce:	6d42                	ld	s10,16(sp)
    800030d0:	6da2                	ld	s11,8(sp)
    800030d2:	6165                	addi	sp,sp,112
    800030d4:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800030d6:	89da                	mv	s3,s6
    800030d8:	bfc9                	j	800030aa <writei+0xe2>
  if (off > ip->size || off + n < off) return -1;
    800030da:	557d                	li	a0,-1
}
    800030dc:	8082                	ret
  if (off > ip->size || off + n < off) return -1;
    800030de:	557d                	li	a0,-1
    800030e0:	bfe1                	j	800030b8 <writei+0xf0>
  if (off + n > MAXFILE * BSIZE) return -1;
    800030e2:	557d                	li	a0,-1
    800030e4:	bfd1                	j	800030b8 <writei+0xf0>

00000000800030e6 <namecmp>:

// Directories

int namecmp(const char *s, const char *t) { return strncmp(s, t, DIRSIZ); }
    800030e6:	1141                	addi	sp,sp,-16
    800030e8:	e406                	sd	ra,8(sp)
    800030ea:	e022                	sd	s0,0(sp)
    800030ec:	0800                	addi	s0,sp,16
    800030ee:	4639                	li	a2,14
    800030f0:	ffffd097          	auipc	ra,0xffffd
    800030f4:	15a080e7          	jalr	346(ra) # 8000024a <strncmp>
    800030f8:	60a2                	ld	ra,8(sp)
    800030fa:	6402                	ld	s0,0(sp)
    800030fc:	0141                	addi	sp,sp,16
    800030fe:	8082                	ret

0000000080003100 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *dirlookup(struct inode *dp, char *name, uint *poff) {
    80003100:	7139                	addi	sp,sp,-64
    80003102:	fc06                	sd	ra,56(sp)
    80003104:	f822                	sd	s0,48(sp)
    80003106:	f426                	sd	s1,40(sp)
    80003108:	f04a                	sd	s2,32(sp)
    8000310a:	ec4e                	sd	s3,24(sp)
    8000310c:	e852                	sd	s4,16(sp)
    8000310e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR) panic("dirlookup not DIR");
    80003110:	04451703          	lh	a4,68(a0)
    80003114:	4785                	li	a5,1
    80003116:	00f71a63          	bne	a4,a5,8000312a <dirlookup+0x2a>
    8000311a:	892a                	mv	s2,a0
    8000311c:	89ae                	mv	s3,a1
    8000311e:	8a32                	mv	s4,a2

  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003120:	457c                	lw	a5,76(a0)
    80003122:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003124:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003126:	e79d                	bnez	a5,80003154 <dirlookup+0x54>
    80003128:	a8a5                	j	800031a0 <dirlookup+0xa0>
  if (dp->type != T_DIR) panic("dirlookup not DIR");
    8000312a:	00005517          	auipc	a0,0x5
    8000312e:	46650513          	addi	a0,a0,1126 # 80008590 <syscalls+0x1b0>
    80003132:	00003097          	auipc	ra,0x3
    80003136:	b9a080e7          	jalr	-1126(ra) # 80005ccc <panic>
      panic("dirlookup read");
    8000313a:	00005517          	auipc	a0,0x5
    8000313e:	46e50513          	addi	a0,a0,1134 # 800085a8 <syscalls+0x1c8>
    80003142:	00003097          	auipc	ra,0x3
    80003146:	b8a080e7          	jalr	-1142(ra) # 80005ccc <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000314a:	24c1                	addiw	s1,s1,16
    8000314c:	04c92783          	lw	a5,76(s2)
    80003150:	04f4f763          	bgeu	s1,a5,8000319e <dirlookup+0x9e>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003154:	4741                	li	a4,16
    80003156:	86a6                	mv	a3,s1
    80003158:	fc040613          	addi	a2,s0,-64
    8000315c:	4581                	li	a1,0
    8000315e:	854a                	mv	a0,s2
    80003160:	00000097          	auipc	ra,0x0
    80003164:	d70080e7          	jalr	-656(ra) # 80002ed0 <readi>
    80003168:	47c1                	li	a5,16
    8000316a:	fcf518e3          	bne	a0,a5,8000313a <dirlookup+0x3a>
    if (de.inum == 0) continue;
    8000316e:	fc045783          	lhu	a5,-64(s0)
    80003172:	dfe1                	beqz	a5,8000314a <dirlookup+0x4a>
    if (namecmp(name, de.name) == 0) {
    80003174:	fc240593          	addi	a1,s0,-62
    80003178:	854e                	mv	a0,s3
    8000317a:	00000097          	auipc	ra,0x0
    8000317e:	f6c080e7          	jalr	-148(ra) # 800030e6 <namecmp>
    80003182:	f561                	bnez	a0,8000314a <dirlookup+0x4a>
      if (poff) *poff = off;
    80003184:	000a0463          	beqz	s4,8000318c <dirlookup+0x8c>
    80003188:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000318c:	fc045583          	lhu	a1,-64(s0)
    80003190:	00092503          	lw	a0,0(s2)
    80003194:	fffff097          	auipc	ra,0xfffff
    80003198:	74e080e7          	jalr	1870(ra) # 800028e2 <iget>
    8000319c:	a011                	j	800031a0 <dirlookup+0xa0>
  return 0;
    8000319e:	4501                	li	a0,0
}
    800031a0:	70e2                	ld	ra,56(sp)
    800031a2:	7442                	ld	s0,48(sp)
    800031a4:	74a2                	ld	s1,40(sp)
    800031a6:	7902                	ld	s2,32(sp)
    800031a8:	69e2                	ld	s3,24(sp)
    800031aa:	6a42                	ld	s4,16(sp)
    800031ac:	6121                	addi	sp,sp,64
    800031ae:	8082                	ret

00000000800031b0 <namex>:

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *namex(char *path, int nameiparent, char *name) {
    800031b0:	711d                	addi	sp,sp,-96
    800031b2:	ec86                	sd	ra,88(sp)
    800031b4:	e8a2                	sd	s0,80(sp)
    800031b6:	e4a6                	sd	s1,72(sp)
    800031b8:	e0ca                	sd	s2,64(sp)
    800031ba:	fc4e                	sd	s3,56(sp)
    800031bc:	f852                	sd	s4,48(sp)
    800031be:	f456                	sd	s5,40(sp)
    800031c0:	f05a                	sd	s6,32(sp)
    800031c2:	ec5e                	sd	s7,24(sp)
    800031c4:	e862                	sd	s8,16(sp)
    800031c6:	e466                	sd	s9,8(sp)
    800031c8:	e06a                	sd	s10,0(sp)
    800031ca:	1080                	addi	s0,sp,96
    800031cc:	84aa                	mv	s1,a0
    800031ce:	8b2e                	mv	s6,a1
    800031d0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    800031d2:	00054703          	lbu	a4,0(a0)
    800031d6:	02f00793          	li	a5,47
    800031da:	02f70363          	beq	a4,a5,80003200 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031de:	ffffe097          	auipc	ra,0xffffe
    800031e2:	c76080e7          	jalr	-906(ra) # 80000e54 <myproc>
    800031e6:	15053503          	ld	a0,336(a0)
    800031ea:	00000097          	auipc	ra,0x0
    800031ee:	9f4080e7          	jalr	-1548(ra) # 80002bde <idup>
    800031f2:	8a2a                	mv	s4,a0
  while (*path == '/') path++;
    800031f4:	02f00913          	li	s2,47
  if (len >= DIRSIZ)
    800031f8:	4cb5                	li	s9,13
  len = path - s;
    800031fa:	4b81                	li	s7,0

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    800031fc:	4c05                	li	s8,1
    800031fe:	a87d                	j	800032bc <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003200:	4585                	li	a1,1
    80003202:	4505                	li	a0,1
    80003204:	fffff097          	auipc	ra,0xfffff
    80003208:	6de080e7          	jalr	1758(ra) # 800028e2 <iget>
    8000320c:	8a2a                	mv	s4,a0
    8000320e:	b7dd                	j	800031f4 <namex+0x44>
      iunlockput(ip);
    80003210:	8552                	mv	a0,s4
    80003212:	00000097          	auipc	ra,0x0
    80003216:	c6c080e7          	jalr	-916(ra) # 80002e7e <iunlockput>
      return 0;
    8000321a:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    8000321c:	8552                	mv	a0,s4
    8000321e:	60e6                	ld	ra,88(sp)
    80003220:	6446                	ld	s0,80(sp)
    80003222:	64a6                	ld	s1,72(sp)
    80003224:	6906                	ld	s2,64(sp)
    80003226:	79e2                	ld	s3,56(sp)
    80003228:	7a42                	ld	s4,48(sp)
    8000322a:	7aa2                	ld	s5,40(sp)
    8000322c:	7b02                	ld	s6,32(sp)
    8000322e:	6be2                	ld	s7,24(sp)
    80003230:	6c42                	ld	s8,16(sp)
    80003232:	6ca2                	ld	s9,8(sp)
    80003234:	6d02                	ld	s10,0(sp)
    80003236:	6125                	addi	sp,sp,96
    80003238:	8082                	ret
      iunlock(ip);
    8000323a:	8552                	mv	a0,s4
    8000323c:	00000097          	auipc	ra,0x0
    80003240:	aa2080e7          	jalr	-1374(ra) # 80002cde <iunlock>
      return ip;
    80003244:	bfe1                	j	8000321c <namex+0x6c>
      iunlockput(ip);
    80003246:	8552                	mv	a0,s4
    80003248:	00000097          	auipc	ra,0x0
    8000324c:	c36080e7          	jalr	-970(ra) # 80002e7e <iunlockput>
      return 0;
    80003250:	8a4e                	mv	s4,s3
    80003252:	b7e9                	j	8000321c <namex+0x6c>
  len = path - s;
    80003254:	40998633          	sub	a2,s3,s1
    80003258:	00060d1b          	sext.w	s10,a2
  if (len >= DIRSIZ)
    8000325c:	09acd863          	bge	s9,s10,800032ec <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003260:	4639                	li	a2,14
    80003262:	85a6                	mv	a1,s1
    80003264:	8556                	mv	a0,s5
    80003266:	ffffd097          	auipc	ra,0xffffd
    8000326a:	f70080e7          	jalr	-144(ra) # 800001d6 <memmove>
    8000326e:	84ce                	mv	s1,s3
  while (*path == '/') path++;
    80003270:	0004c783          	lbu	a5,0(s1)
    80003274:	01279763          	bne	a5,s2,80003282 <namex+0xd2>
    80003278:	0485                	addi	s1,s1,1
    8000327a:	0004c783          	lbu	a5,0(s1)
    8000327e:	ff278de3          	beq	a5,s2,80003278 <namex+0xc8>
    ilock(ip);
    80003282:	8552                	mv	a0,s4
    80003284:	00000097          	auipc	ra,0x0
    80003288:	998080e7          	jalr	-1640(ra) # 80002c1c <ilock>
    if (ip->type != T_DIR) {
    8000328c:	044a1783          	lh	a5,68(s4)
    80003290:	f98790e3          	bne	a5,s8,80003210 <namex+0x60>
    if (nameiparent && *path == '\0') {
    80003294:	000b0563          	beqz	s6,8000329e <namex+0xee>
    80003298:	0004c783          	lbu	a5,0(s1)
    8000329c:	dfd9                	beqz	a5,8000323a <namex+0x8a>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    8000329e:	865e                	mv	a2,s7
    800032a0:	85d6                	mv	a1,s5
    800032a2:	8552                	mv	a0,s4
    800032a4:	00000097          	auipc	ra,0x0
    800032a8:	e5c080e7          	jalr	-420(ra) # 80003100 <dirlookup>
    800032ac:	89aa                	mv	s3,a0
    800032ae:	dd41                	beqz	a0,80003246 <namex+0x96>
    iunlockput(ip);
    800032b0:	8552                	mv	a0,s4
    800032b2:	00000097          	auipc	ra,0x0
    800032b6:	bcc080e7          	jalr	-1076(ra) # 80002e7e <iunlockput>
    ip = next;
    800032ba:	8a4e                	mv	s4,s3
  while (*path == '/') path++;
    800032bc:	0004c783          	lbu	a5,0(s1)
    800032c0:	01279763          	bne	a5,s2,800032ce <namex+0x11e>
    800032c4:	0485                	addi	s1,s1,1
    800032c6:	0004c783          	lbu	a5,0(s1)
    800032ca:	ff278de3          	beq	a5,s2,800032c4 <namex+0x114>
  if (*path == 0) return 0;
    800032ce:	cb9d                	beqz	a5,80003304 <namex+0x154>
  while (*path != '/' && *path != 0) path++;
    800032d0:	0004c783          	lbu	a5,0(s1)
    800032d4:	89a6                	mv	s3,s1
  len = path - s;
    800032d6:	8d5e                	mv	s10,s7
    800032d8:	865e                	mv	a2,s7
  while (*path != '/' && *path != 0) path++;
    800032da:	01278963          	beq	a5,s2,800032ec <namex+0x13c>
    800032de:	dbbd                	beqz	a5,80003254 <namex+0xa4>
    800032e0:	0985                	addi	s3,s3,1
    800032e2:	0009c783          	lbu	a5,0(s3)
    800032e6:	ff279ce3          	bne	a5,s2,800032de <namex+0x12e>
    800032ea:	b7ad                	j	80003254 <namex+0xa4>
    memmove(name, s, len);
    800032ec:	2601                	sext.w	a2,a2
    800032ee:	85a6                	mv	a1,s1
    800032f0:	8556                	mv	a0,s5
    800032f2:	ffffd097          	auipc	ra,0xffffd
    800032f6:	ee4080e7          	jalr	-284(ra) # 800001d6 <memmove>
    name[len] = 0;
    800032fa:	9d56                	add	s10,s10,s5
    800032fc:	000d0023          	sb	zero,0(s10)
    80003300:	84ce                	mv	s1,s3
    80003302:	b7bd                	j	80003270 <namex+0xc0>
  if (nameiparent) {
    80003304:	f00b0ce3          	beqz	s6,8000321c <namex+0x6c>
    iput(ip);
    80003308:	8552                	mv	a0,s4
    8000330a:	00000097          	auipc	ra,0x0
    8000330e:	acc080e7          	jalr	-1332(ra) # 80002dd6 <iput>
    return 0;
    80003312:	4a01                	li	s4,0
    80003314:	b721                	j	8000321c <namex+0x6c>

0000000080003316 <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum) {
    80003316:	7139                	addi	sp,sp,-64
    80003318:	fc06                	sd	ra,56(sp)
    8000331a:	f822                	sd	s0,48(sp)
    8000331c:	f426                	sd	s1,40(sp)
    8000331e:	f04a                	sd	s2,32(sp)
    80003320:	ec4e                	sd	s3,24(sp)
    80003322:	e852                	sd	s4,16(sp)
    80003324:	0080                	addi	s0,sp,64
    80003326:	892a                	mv	s2,a0
    80003328:	8a2e                	mv	s4,a1
    8000332a:	89b2                	mv	s3,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    8000332c:	4601                	li	a2,0
    8000332e:	00000097          	auipc	ra,0x0
    80003332:	dd2080e7          	jalr	-558(ra) # 80003100 <dirlookup>
    80003336:	e93d                	bnez	a0,800033ac <dirlink+0x96>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003338:	04c92483          	lw	s1,76(s2)
    8000333c:	c49d                	beqz	s1,8000336a <dirlink+0x54>
    8000333e:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003340:	4741                	li	a4,16
    80003342:	86a6                	mv	a3,s1
    80003344:	fc040613          	addi	a2,s0,-64
    80003348:	4581                	li	a1,0
    8000334a:	854a                	mv	a0,s2
    8000334c:	00000097          	auipc	ra,0x0
    80003350:	b84080e7          	jalr	-1148(ra) # 80002ed0 <readi>
    80003354:	47c1                	li	a5,16
    80003356:	06f51163          	bne	a0,a5,800033b8 <dirlink+0xa2>
    if (de.inum == 0) break;
    8000335a:	fc045783          	lhu	a5,-64(s0)
    8000335e:	c791                	beqz	a5,8000336a <dirlink+0x54>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003360:	24c1                	addiw	s1,s1,16
    80003362:	04c92783          	lw	a5,76(s2)
    80003366:	fcf4ede3          	bltu	s1,a5,80003340 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000336a:	4639                	li	a2,14
    8000336c:	85d2                	mv	a1,s4
    8000336e:	fc240513          	addi	a0,s0,-62
    80003372:	ffffd097          	auipc	ra,0xffffd
    80003376:	f14080e7          	jalr	-236(ra) # 80000286 <strncpy>
  de.inum = inum;
    8000337a:	fd341023          	sh	s3,-64(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de)) return -1;
    8000337e:	4741                	li	a4,16
    80003380:	86a6                	mv	a3,s1
    80003382:	fc040613          	addi	a2,s0,-64
    80003386:	4581                	li	a1,0
    80003388:	854a                	mv	a0,s2
    8000338a:	00000097          	auipc	ra,0x0
    8000338e:	c3e080e7          	jalr	-962(ra) # 80002fc8 <writei>
    80003392:	1541                	addi	a0,a0,-16
    80003394:	00a03533          	snez	a0,a0
    80003398:	40a00533          	neg	a0,a0
}
    8000339c:	70e2                	ld	ra,56(sp)
    8000339e:	7442                	ld	s0,48(sp)
    800033a0:	74a2                	ld	s1,40(sp)
    800033a2:	7902                	ld	s2,32(sp)
    800033a4:	69e2                	ld	s3,24(sp)
    800033a6:	6a42                	ld	s4,16(sp)
    800033a8:	6121                	addi	sp,sp,64
    800033aa:	8082                	ret
    iput(ip);
    800033ac:	00000097          	auipc	ra,0x0
    800033b0:	a2a080e7          	jalr	-1494(ra) # 80002dd6 <iput>
    return -1;
    800033b4:	557d                	li	a0,-1
    800033b6:	b7dd                	j	8000339c <dirlink+0x86>
      panic("dirlink read");
    800033b8:	00005517          	auipc	a0,0x5
    800033bc:	20050513          	addi	a0,a0,512 # 800085b8 <syscalls+0x1d8>
    800033c0:	00003097          	auipc	ra,0x3
    800033c4:	90c080e7          	jalr	-1780(ra) # 80005ccc <panic>

00000000800033c8 <namei>:

struct inode *namei(char *path) {
    800033c8:	1101                	addi	sp,sp,-32
    800033ca:	ec06                	sd	ra,24(sp)
    800033cc:	e822                	sd	s0,16(sp)
    800033ce:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033d0:	fe040613          	addi	a2,s0,-32
    800033d4:	4581                	li	a1,0
    800033d6:	00000097          	auipc	ra,0x0
    800033da:	dda080e7          	jalr	-550(ra) # 800031b0 <namex>
}
    800033de:	60e2                	ld	ra,24(sp)
    800033e0:	6442                	ld	s0,16(sp)
    800033e2:	6105                	addi	sp,sp,32
    800033e4:	8082                	ret

00000000800033e6 <nameiparent>:

struct inode *nameiparent(char *path, char *name) {
    800033e6:	1141                	addi	sp,sp,-16
    800033e8:	e406                	sd	ra,8(sp)
    800033ea:	e022                	sd	s0,0(sp)
    800033ec:	0800                	addi	s0,sp,16
    800033ee:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033f0:	4585                	li	a1,1
    800033f2:	00000097          	auipc	ra,0x0
    800033f6:	dbe080e7          	jalr	-578(ra) # 800031b0 <namex>
}
    800033fa:	60a2                	ld	ra,8(sp)
    800033fc:	6402                	ld	s0,0(sp)
    800033fe:	0141                	addi	sp,sp,16
    80003400:	8082                	ret

0000000080003402 <write_head>:
}

// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void write_head(void) {
    80003402:	1101                	addi	sp,sp,-32
    80003404:	ec06                	sd	ra,24(sp)
    80003406:	e822                	sd	s0,16(sp)
    80003408:	e426                	sd	s1,8(sp)
    8000340a:	e04a                	sd	s2,0(sp)
    8000340c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000340e:	00015917          	auipc	s2,0x15
    80003412:	4e290913          	addi	s2,s2,1250 # 800188f0 <log>
    80003416:	01892583          	lw	a1,24(s2)
    8000341a:	02892503          	lw	a0,40(s2)
    8000341e:	fffff097          	auipc	ra,0xfffff
    80003422:	fe6080e7          	jalr	-26(ra) # 80002404 <bread>
    80003426:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    80003428:	02c92683          	lw	a3,44(s2)
    8000342c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000342e:	02d05863          	blez	a3,8000345e <write_head+0x5c>
    80003432:	00015797          	auipc	a5,0x15
    80003436:	4ee78793          	addi	a5,a5,1262 # 80018920 <log+0x30>
    8000343a:	05c50713          	addi	a4,a0,92
    8000343e:	36fd                	addiw	a3,a3,-1
    80003440:	02069613          	slli	a2,a3,0x20
    80003444:	01e65693          	srli	a3,a2,0x1e
    80003448:	00015617          	auipc	a2,0x15
    8000344c:	4dc60613          	addi	a2,a2,1244 # 80018924 <log+0x34>
    80003450:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003452:	4390                	lw	a2,0(a5)
    80003454:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003456:	0791                	addi	a5,a5,4
    80003458:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000345a:	fed79ce3          	bne	a5,a3,80003452 <write_head+0x50>
  }
  bwrite(buf);
    8000345e:	8526                	mv	a0,s1
    80003460:	fffff097          	auipc	ra,0xfffff
    80003464:	096080e7          	jalr	150(ra) # 800024f6 <bwrite>
  brelse(buf);
    80003468:	8526                	mv	a0,s1
    8000346a:	fffff097          	auipc	ra,0xfffff
    8000346e:	0ca080e7          	jalr	202(ra) # 80002534 <brelse>
}
    80003472:	60e2                	ld	ra,24(sp)
    80003474:	6442                	ld	s0,16(sp)
    80003476:	64a2                	ld	s1,8(sp)
    80003478:	6902                	ld	s2,0(sp)
    8000347a:	6105                	addi	sp,sp,32
    8000347c:	8082                	ret

000000008000347e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000347e:	00015797          	auipc	a5,0x15
    80003482:	49e7a783          	lw	a5,1182(a5) # 8001891c <log+0x2c>
    80003486:	0af05d63          	blez	a5,80003540 <install_trans+0xc2>
static void install_trans(int recovering) {
    8000348a:	7139                	addi	sp,sp,-64
    8000348c:	fc06                	sd	ra,56(sp)
    8000348e:	f822                	sd	s0,48(sp)
    80003490:	f426                	sd	s1,40(sp)
    80003492:	f04a                	sd	s2,32(sp)
    80003494:	ec4e                	sd	s3,24(sp)
    80003496:	e852                	sd	s4,16(sp)
    80003498:	e456                	sd	s5,8(sp)
    8000349a:	e05a                	sd	s6,0(sp)
    8000349c:	0080                	addi	s0,sp,64
    8000349e:	8b2a                	mv	s6,a0
    800034a0:	00015a97          	auipc	s5,0x15
    800034a4:	480a8a93          	addi	s5,s5,1152 # 80018920 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034a8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start + tail + 1);  // read log block
    800034aa:	00015997          	auipc	s3,0x15
    800034ae:	44698993          	addi	s3,s3,1094 # 800188f0 <log>
    800034b2:	a00d                	j	800034d4 <install_trans+0x56>
    brelse(lbuf);
    800034b4:	854a                	mv	a0,s2
    800034b6:	fffff097          	auipc	ra,0xfffff
    800034ba:	07e080e7          	jalr	126(ra) # 80002534 <brelse>
    brelse(dbuf);
    800034be:	8526                	mv	a0,s1
    800034c0:	fffff097          	auipc	ra,0xfffff
    800034c4:	074080e7          	jalr	116(ra) # 80002534 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034c8:	2a05                	addiw	s4,s4,1
    800034ca:	0a91                	addi	s5,s5,4
    800034cc:	02c9a783          	lw	a5,44(s3)
    800034d0:	04fa5e63          	bge	s4,a5,8000352c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1);  // read log block
    800034d4:	0189a583          	lw	a1,24(s3)
    800034d8:	014585bb          	addw	a1,a1,s4
    800034dc:	2585                	addiw	a1,a1,1
    800034de:	0289a503          	lw	a0,40(s3)
    800034e2:	fffff097          	auipc	ra,0xfffff
    800034e6:	f22080e7          	jalr	-222(ra) # 80002404 <bread>
    800034ea:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);    // read dst
    800034ec:	000aa583          	lw	a1,0(s5)
    800034f0:	0289a503          	lw	a0,40(s3)
    800034f4:	fffff097          	auipc	ra,0xfffff
    800034f8:	f10080e7          	jalr	-240(ra) # 80002404 <bread>
    800034fc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034fe:	40000613          	li	a2,1024
    80003502:	05890593          	addi	a1,s2,88
    80003506:	05850513          	addi	a0,a0,88
    8000350a:	ffffd097          	auipc	ra,0xffffd
    8000350e:	ccc080e7          	jalr	-820(ra) # 800001d6 <memmove>
    bwrite(dbuf);                            // write dst to disk
    80003512:	8526                	mv	a0,s1
    80003514:	fffff097          	auipc	ra,0xfffff
    80003518:	fe2080e7          	jalr	-30(ra) # 800024f6 <bwrite>
    if (recovering == 0) bunpin(dbuf);
    8000351c:	f80b1ce3          	bnez	s6,800034b4 <install_trans+0x36>
    80003520:	8526                	mv	a0,s1
    80003522:	fffff097          	auipc	ra,0xfffff
    80003526:	0ec080e7          	jalr	236(ra) # 8000260e <bunpin>
    8000352a:	b769                	j	800034b4 <install_trans+0x36>
}
    8000352c:	70e2                	ld	ra,56(sp)
    8000352e:	7442                	ld	s0,48(sp)
    80003530:	74a2                	ld	s1,40(sp)
    80003532:	7902                	ld	s2,32(sp)
    80003534:	69e2                	ld	s3,24(sp)
    80003536:	6a42                	ld	s4,16(sp)
    80003538:	6aa2                	ld	s5,8(sp)
    8000353a:	6b02                	ld	s6,0(sp)
    8000353c:	6121                	addi	sp,sp,64
    8000353e:	8082                	ret
    80003540:	8082                	ret

0000000080003542 <initlog>:
void initlog(int dev, struct superblock *sb) {
    80003542:	7179                	addi	sp,sp,-48
    80003544:	f406                	sd	ra,40(sp)
    80003546:	f022                	sd	s0,32(sp)
    80003548:	ec26                	sd	s1,24(sp)
    8000354a:	e84a                	sd	s2,16(sp)
    8000354c:	e44e                	sd	s3,8(sp)
    8000354e:	1800                	addi	s0,sp,48
    80003550:	892a                	mv	s2,a0
    80003552:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003554:	00015497          	auipc	s1,0x15
    80003558:	39c48493          	addi	s1,s1,924 # 800188f0 <log>
    8000355c:	00005597          	auipc	a1,0x5
    80003560:	06c58593          	addi	a1,a1,108 # 800085c8 <syscalls+0x1e8>
    80003564:	8526                	mv	a0,s1
    80003566:	00003097          	auipc	ra,0x3
    8000356a:	c0e080e7          	jalr	-1010(ra) # 80006174 <initlock>
  log.start = sb->logstart;
    8000356e:	0149a583          	lw	a1,20(s3)
    80003572:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003574:	0109a783          	lw	a5,16(s3)
    80003578:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000357a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000357e:	854a                	mv	a0,s2
    80003580:	fffff097          	auipc	ra,0xfffff
    80003584:	e84080e7          	jalr	-380(ra) # 80002404 <bread>
  log.lh.n = lh->n;
    80003588:	4d34                	lw	a3,88(a0)
    8000358a:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000358c:	02d05663          	blez	a3,800035b8 <initlog+0x76>
    80003590:	05c50793          	addi	a5,a0,92
    80003594:	00015717          	auipc	a4,0x15
    80003598:	38c70713          	addi	a4,a4,908 # 80018920 <log+0x30>
    8000359c:	36fd                	addiw	a3,a3,-1
    8000359e:	02069613          	slli	a2,a3,0x20
    800035a2:	01e65693          	srli	a3,a2,0x1e
    800035a6:	06050613          	addi	a2,a0,96
    800035aa:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800035ac:	4390                	lw	a2,0(a5)
    800035ae:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035b0:	0791                	addi	a5,a5,4
    800035b2:	0711                	addi	a4,a4,4
    800035b4:	fed79ce3          	bne	a5,a3,800035ac <initlog+0x6a>
  brelse(buf);
    800035b8:	fffff097          	auipc	ra,0xfffff
    800035bc:	f7c080e7          	jalr	-132(ra) # 80002534 <brelse>

static void recover_from_log(void) {
  read_head();
  install_trans(1);  // if committed, copy from log to disk
    800035c0:	4505                	li	a0,1
    800035c2:	00000097          	auipc	ra,0x0
    800035c6:	ebc080e7          	jalr	-324(ra) # 8000347e <install_trans>
  log.lh.n = 0;
    800035ca:	00015797          	auipc	a5,0x15
    800035ce:	3407a923          	sw	zero,850(a5) # 8001891c <log+0x2c>
  write_head();  // clear the log
    800035d2:	00000097          	auipc	ra,0x0
    800035d6:	e30080e7          	jalr	-464(ra) # 80003402 <write_head>
}
    800035da:	70a2                	ld	ra,40(sp)
    800035dc:	7402                	ld	s0,32(sp)
    800035de:	64e2                	ld	s1,24(sp)
    800035e0:	6942                	ld	s2,16(sp)
    800035e2:	69a2                	ld	s3,8(sp)
    800035e4:	6145                	addi	sp,sp,48
    800035e6:	8082                	ret

00000000800035e8 <begin_op>:
}

// called at the start of each FS system call.
void begin_op(void) {
    800035e8:	1101                	addi	sp,sp,-32
    800035ea:	ec06                	sd	ra,24(sp)
    800035ec:	e822                	sd	s0,16(sp)
    800035ee:	e426                	sd	s1,8(sp)
    800035f0:	e04a                	sd	s2,0(sp)
    800035f2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035f4:	00015517          	auipc	a0,0x15
    800035f8:	2fc50513          	addi	a0,a0,764 # 800188f0 <log>
    800035fc:	00003097          	auipc	ra,0x3
    80003600:	c08080e7          	jalr	-1016(ra) # 80006204 <acquire>
  while (1) {
    if (log.committing) {
    80003604:	00015497          	auipc	s1,0x15
    80003608:	2ec48493          	addi	s1,s1,748 # 800188f0 <log>
      sleep(&log, &log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    8000360c:	4979                	li	s2,30
    8000360e:	a039                	j	8000361c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003610:	85a6                	mv	a1,s1
    80003612:	8526                	mv	a0,s1
    80003614:	ffffe097          	auipc	ra,0xffffe
    80003618:	ee8080e7          	jalr	-280(ra) # 800014fc <sleep>
    if (log.committing) {
    8000361c:	50dc                	lw	a5,36(s1)
    8000361e:	fbed                	bnez	a5,80003610 <begin_op+0x28>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    80003620:	5098                	lw	a4,32(s1)
    80003622:	2705                	addiw	a4,a4,1
    80003624:	0007069b          	sext.w	a3,a4
    80003628:	0027179b          	slliw	a5,a4,0x2
    8000362c:	9fb9                	addw	a5,a5,a4
    8000362e:	0017979b          	slliw	a5,a5,0x1
    80003632:	54d8                	lw	a4,44(s1)
    80003634:	9fb9                	addw	a5,a5,a4
    80003636:	00f95963          	bge	s2,a5,80003648 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000363a:	85a6                	mv	a1,s1
    8000363c:	8526                	mv	a0,s1
    8000363e:	ffffe097          	auipc	ra,0xffffe
    80003642:	ebe080e7          	jalr	-322(ra) # 800014fc <sleep>
    80003646:	bfd9                	j	8000361c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003648:	00015517          	auipc	a0,0x15
    8000364c:	2a850513          	addi	a0,a0,680 # 800188f0 <log>
    80003650:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003652:	00003097          	auipc	ra,0x3
    80003656:	c66080e7          	jalr	-922(ra) # 800062b8 <release>
      break;
    }
  }
}
    8000365a:	60e2                	ld	ra,24(sp)
    8000365c:	6442                	ld	s0,16(sp)
    8000365e:	64a2                	ld	s1,8(sp)
    80003660:	6902                	ld	s2,0(sp)
    80003662:	6105                	addi	sp,sp,32
    80003664:	8082                	ret

0000000080003666 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void end_op(void) {
    80003666:	7139                	addi	sp,sp,-64
    80003668:	fc06                	sd	ra,56(sp)
    8000366a:	f822                	sd	s0,48(sp)
    8000366c:	f426                	sd	s1,40(sp)
    8000366e:	f04a                	sd	s2,32(sp)
    80003670:	ec4e                	sd	s3,24(sp)
    80003672:	e852                	sd	s4,16(sp)
    80003674:	e456                	sd	s5,8(sp)
    80003676:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003678:	00015497          	auipc	s1,0x15
    8000367c:	27848493          	addi	s1,s1,632 # 800188f0 <log>
    80003680:	8526                	mv	a0,s1
    80003682:	00003097          	auipc	ra,0x3
    80003686:	b82080e7          	jalr	-1150(ra) # 80006204 <acquire>
  log.outstanding -= 1;
    8000368a:	509c                	lw	a5,32(s1)
    8000368c:	37fd                	addiw	a5,a5,-1
    8000368e:	0007891b          	sext.w	s2,a5
    80003692:	d09c                	sw	a5,32(s1)
  if (log.committing) panic("log.committing");
    80003694:	50dc                	lw	a5,36(s1)
    80003696:	e7b9                	bnez	a5,800036e4 <end_op+0x7e>
  if (log.outstanding == 0) {
    80003698:	04091e63          	bnez	s2,800036f4 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000369c:	00015497          	auipc	s1,0x15
    800036a0:	25448493          	addi	s1,s1,596 # 800188f0 <log>
    800036a4:	4785                	li	a5,1
    800036a6:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036a8:	8526                	mv	a0,s1
    800036aa:	00003097          	auipc	ra,0x3
    800036ae:	c0e080e7          	jalr	-1010(ra) # 800062b8 <release>
    brelse(to);
  }
}

static void commit() {
  if (log.lh.n > 0) {
    800036b2:	54dc                	lw	a5,44(s1)
    800036b4:	06f04763          	bgtz	a5,80003722 <end_op+0xbc>
    acquire(&log.lock);
    800036b8:	00015497          	auipc	s1,0x15
    800036bc:	23848493          	addi	s1,s1,568 # 800188f0 <log>
    800036c0:	8526                	mv	a0,s1
    800036c2:	00003097          	auipc	ra,0x3
    800036c6:	b42080e7          	jalr	-1214(ra) # 80006204 <acquire>
    log.committing = 0;
    800036ca:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036ce:	8526                	mv	a0,s1
    800036d0:	ffffe097          	auipc	ra,0xffffe
    800036d4:	e90080e7          	jalr	-368(ra) # 80001560 <wakeup>
    release(&log.lock);
    800036d8:	8526                	mv	a0,s1
    800036da:	00003097          	auipc	ra,0x3
    800036de:	bde080e7          	jalr	-1058(ra) # 800062b8 <release>
}
    800036e2:	a03d                	j	80003710 <end_op+0xaa>
  if (log.committing) panic("log.committing");
    800036e4:	00005517          	auipc	a0,0x5
    800036e8:	eec50513          	addi	a0,a0,-276 # 800085d0 <syscalls+0x1f0>
    800036ec:	00002097          	auipc	ra,0x2
    800036f0:	5e0080e7          	jalr	1504(ra) # 80005ccc <panic>
    wakeup(&log);
    800036f4:	00015497          	auipc	s1,0x15
    800036f8:	1fc48493          	addi	s1,s1,508 # 800188f0 <log>
    800036fc:	8526                	mv	a0,s1
    800036fe:	ffffe097          	auipc	ra,0xffffe
    80003702:	e62080e7          	jalr	-414(ra) # 80001560 <wakeup>
  release(&log.lock);
    80003706:	8526                	mv	a0,s1
    80003708:	00003097          	auipc	ra,0x3
    8000370c:	bb0080e7          	jalr	-1104(ra) # 800062b8 <release>
}
    80003710:	70e2                	ld	ra,56(sp)
    80003712:	7442                	ld	s0,48(sp)
    80003714:	74a2                	ld	s1,40(sp)
    80003716:	7902                	ld	s2,32(sp)
    80003718:	69e2                	ld	s3,24(sp)
    8000371a:	6a42                	ld	s4,16(sp)
    8000371c:	6aa2                	ld	s5,8(sp)
    8000371e:	6121                	addi	sp,sp,64
    80003720:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003722:	00015a97          	auipc	s5,0x15
    80003726:	1fea8a93          	addi	s5,s5,510 # 80018920 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1);  // log block
    8000372a:	00015a17          	auipc	s4,0x15
    8000372e:	1c6a0a13          	addi	s4,s4,454 # 800188f0 <log>
    80003732:	018a2583          	lw	a1,24(s4)
    80003736:	012585bb          	addw	a1,a1,s2
    8000373a:	2585                	addiw	a1,a1,1
    8000373c:	028a2503          	lw	a0,40(s4)
    80003740:	fffff097          	auipc	ra,0xfffff
    80003744:	cc4080e7          	jalr	-828(ra) # 80002404 <bread>
    80003748:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]);  // cache block
    8000374a:	000aa583          	lw	a1,0(s5)
    8000374e:	028a2503          	lw	a0,40(s4)
    80003752:	fffff097          	auipc	ra,0xfffff
    80003756:	cb2080e7          	jalr	-846(ra) # 80002404 <bread>
    8000375a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000375c:	40000613          	li	a2,1024
    80003760:	05850593          	addi	a1,a0,88
    80003764:	05848513          	addi	a0,s1,88
    80003768:	ffffd097          	auipc	ra,0xffffd
    8000376c:	a6e080e7          	jalr	-1426(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003770:	8526                	mv	a0,s1
    80003772:	fffff097          	auipc	ra,0xfffff
    80003776:	d84080e7          	jalr	-636(ra) # 800024f6 <bwrite>
    brelse(from);
    8000377a:	854e                	mv	a0,s3
    8000377c:	fffff097          	auipc	ra,0xfffff
    80003780:	db8080e7          	jalr	-584(ra) # 80002534 <brelse>
    brelse(to);
    80003784:	8526                	mv	a0,s1
    80003786:	fffff097          	auipc	ra,0xfffff
    8000378a:	dae080e7          	jalr	-594(ra) # 80002534 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000378e:	2905                	addiw	s2,s2,1
    80003790:	0a91                	addi	s5,s5,4
    80003792:	02ca2783          	lw	a5,44(s4)
    80003796:	f8f94ee3          	blt	s2,a5,80003732 <end_op+0xcc>
    write_log();       // Write modified blocks from cache to log
    write_head();      // Write header to disk -- the real commit
    8000379a:	00000097          	auipc	ra,0x0
    8000379e:	c68080e7          	jalr	-920(ra) # 80003402 <write_head>
    install_trans(0);  // Now install writes to home locations
    800037a2:	4501                	li	a0,0
    800037a4:	00000097          	auipc	ra,0x0
    800037a8:	cda080e7          	jalr	-806(ra) # 8000347e <install_trans>
    log.lh.n = 0;
    800037ac:	00015797          	auipc	a5,0x15
    800037b0:	1607a823          	sw	zero,368(a5) # 8001891c <log+0x2c>
    write_head();  // Erase the transaction from the log
    800037b4:	00000097          	auipc	ra,0x0
    800037b8:	c4e080e7          	jalr	-946(ra) # 80003402 <write_head>
    800037bc:	bdf5                	j	800036b8 <end_op+0x52>

00000000800037be <log_write>:
// log_write() replaces bwrite(); a typical use is:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void log_write(struct buf *b) {
    800037be:	1101                	addi	sp,sp,-32
    800037c0:	ec06                	sd	ra,24(sp)
    800037c2:	e822                	sd	s0,16(sp)
    800037c4:	e426                	sd	s1,8(sp)
    800037c6:	e04a                	sd	s2,0(sp)
    800037c8:	1000                	addi	s0,sp,32
    800037ca:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037cc:	00015917          	auipc	s2,0x15
    800037d0:	12490913          	addi	s2,s2,292 # 800188f0 <log>
    800037d4:	854a                	mv	a0,s2
    800037d6:	00003097          	auipc	ra,0x3
    800037da:	a2e080e7          	jalr	-1490(ra) # 80006204 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037de:	02c92603          	lw	a2,44(s2)
    800037e2:	47f5                	li	a5,29
    800037e4:	06c7c563          	blt	a5,a2,8000384e <log_write+0x90>
    800037e8:	00015797          	auipc	a5,0x15
    800037ec:	1247a783          	lw	a5,292(a5) # 8001890c <log+0x1c>
    800037f0:	37fd                	addiw	a5,a5,-1
    800037f2:	04f65e63          	bge	a2,a5,8000384e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1) panic("log_write outside of trans");
    800037f6:	00015797          	auipc	a5,0x15
    800037fa:	11a7a783          	lw	a5,282(a5) # 80018910 <log+0x20>
    800037fe:	06f05063          	blez	a5,8000385e <log_write+0xa0>

  for (i = 0; i < log.lh.n; i++) {
    80003802:	4781                	li	a5,0
    80003804:	06c05563          	blez	a2,8000386e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)  // log absorption
    80003808:	44cc                	lw	a1,12(s1)
    8000380a:	00015717          	auipc	a4,0x15
    8000380e:	11670713          	addi	a4,a4,278 # 80018920 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003812:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)  // log absorption
    80003814:	4314                	lw	a3,0(a4)
    80003816:	04b68c63          	beq	a3,a1,8000386e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000381a:	2785                	addiw	a5,a5,1
    8000381c:	0711                	addi	a4,a4,4
    8000381e:	fef61be3          	bne	a2,a5,80003814 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003822:	0621                	addi	a2,a2,8
    80003824:	060a                	slli	a2,a2,0x2
    80003826:	00015797          	auipc	a5,0x15
    8000382a:	0ca78793          	addi	a5,a5,202 # 800188f0 <log>
    8000382e:	97b2                	add	a5,a5,a2
    80003830:	44d8                	lw	a4,12(s1)
    80003832:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003834:	8526                	mv	a0,s1
    80003836:	fffff097          	auipc	ra,0xfffff
    8000383a:	d9c080e7          	jalr	-612(ra) # 800025d2 <bpin>
    log.lh.n++;
    8000383e:	00015717          	auipc	a4,0x15
    80003842:	0b270713          	addi	a4,a4,178 # 800188f0 <log>
    80003846:	575c                	lw	a5,44(a4)
    80003848:	2785                	addiw	a5,a5,1
    8000384a:	d75c                	sw	a5,44(a4)
    8000384c:	a82d                	j	80003886 <log_write+0xc8>
    panic("too big a transaction");
    8000384e:	00005517          	auipc	a0,0x5
    80003852:	d9250513          	addi	a0,a0,-622 # 800085e0 <syscalls+0x200>
    80003856:	00002097          	auipc	ra,0x2
    8000385a:	476080e7          	jalr	1142(ra) # 80005ccc <panic>
  if (log.outstanding < 1) panic("log_write outside of trans");
    8000385e:	00005517          	auipc	a0,0x5
    80003862:	d9a50513          	addi	a0,a0,-614 # 800085f8 <syscalls+0x218>
    80003866:	00002097          	auipc	ra,0x2
    8000386a:	466080e7          	jalr	1126(ra) # 80005ccc <panic>
  log.lh.block[i] = b->blockno;
    8000386e:	00878693          	addi	a3,a5,8
    80003872:	068a                	slli	a3,a3,0x2
    80003874:	00015717          	auipc	a4,0x15
    80003878:	07c70713          	addi	a4,a4,124 # 800188f0 <log>
    8000387c:	9736                	add	a4,a4,a3
    8000387e:	44d4                	lw	a3,12(s1)
    80003880:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003882:	faf609e3          	beq	a2,a5,80003834 <log_write+0x76>
  }
  release(&log.lock);
    80003886:	00015517          	auipc	a0,0x15
    8000388a:	06a50513          	addi	a0,a0,106 # 800188f0 <log>
    8000388e:	00003097          	auipc	ra,0x3
    80003892:	a2a080e7          	jalr	-1494(ra) # 800062b8 <release>
}
    80003896:	60e2                	ld	ra,24(sp)
    80003898:	6442                	ld	s0,16(sp)
    8000389a:	64a2                	ld	s1,8(sp)
    8000389c:	6902                	ld	s2,0(sp)
    8000389e:	6105                	addi	sp,sp,32
    800038a0:	8082                	ret

00000000800038a2 <initsleeplock>:
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "sleeplock.h"

void initsleeplock(struct sleeplock *lk, char *name) {
    800038a2:	1101                	addi	sp,sp,-32
    800038a4:	ec06                	sd	ra,24(sp)
    800038a6:	e822                	sd	s0,16(sp)
    800038a8:	e426                	sd	s1,8(sp)
    800038aa:	e04a                	sd	s2,0(sp)
    800038ac:	1000                	addi	s0,sp,32
    800038ae:	84aa                	mv	s1,a0
    800038b0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038b2:	00005597          	auipc	a1,0x5
    800038b6:	d6658593          	addi	a1,a1,-666 # 80008618 <syscalls+0x238>
    800038ba:	0521                	addi	a0,a0,8
    800038bc:	00003097          	auipc	ra,0x3
    800038c0:	8b8080e7          	jalr	-1864(ra) # 80006174 <initlock>
  lk->name = name;
    800038c4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038c8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038cc:	0204a423          	sw	zero,40(s1)
}
    800038d0:	60e2                	ld	ra,24(sp)
    800038d2:	6442                	ld	s0,16(sp)
    800038d4:	64a2                	ld	s1,8(sp)
    800038d6:	6902                	ld	s2,0(sp)
    800038d8:	6105                	addi	sp,sp,32
    800038da:	8082                	ret

00000000800038dc <acquiresleep>:

void acquiresleep(struct sleeplock *lk) {
    800038dc:	1101                	addi	sp,sp,-32
    800038de:	ec06                	sd	ra,24(sp)
    800038e0:	e822                	sd	s0,16(sp)
    800038e2:	e426                	sd	s1,8(sp)
    800038e4:	e04a                	sd	s2,0(sp)
    800038e6:	1000                	addi	s0,sp,32
    800038e8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038ea:	00850913          	addi	s2,a0,8
    800038ee:	854a                	mv	a0,s2
    800038f0:	00003097          	auipc	ra,0x3
    800038f4:	914080e7          	jalr	-1772(ra) # 80006204 <acquire>
  while (lk->locked) {
    800038f8:	409c                	lw	a5,0(s1)
    800038fa:	cb89                	beqz	a5,8000390c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038fc:	85ca                	mv	a1,s2
    800038fe:	8526                	mv	a0,s1
    80003900:	ffffe097          	auipc	ra,0xffffe
    80003904:	bfc080e7          	jalr	-1028(ra) # 800014fc <sleep>
  while (lk->locked) {
    80003908:	409c                	lw	a5,0(s1)
    8000390a:	fbed                	bnez	a5,800038fc <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000390c:	4785                	li	a5,1
    8000390e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003910:	ffffd097          	auipc	ra,0xffffd
    80003914:	544080e7          	jalr	1348(ra) # 80000e54 <myproc>
    80003918:	591c                	lw	a5,48(a0)
    8000391a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000391c:	854a                	mv	a0,s2
    8000391e:	00003097          	auipc	ra,0x3
    80003922:	99a080e7          	jalr	-1638(ra) # 800062b8 <release>
}
    80003926:	60e2                	ld	ra,24(sp)
    80003928:	6442                	ld	s0,16(sp)
    8000392a:	64a2                	ld	s1,8(sp)
    8000392c:	6902                	ld	s2,0(sp)
    8000392e:	6105                	addi	sp,sp,32
    80003930:	8082                	ret

0000000080003932 <releasesleep>:

void releasesleep(struct sleeplock *lk) {
    80003932:	1101                	addi	sp,sp,-32
    80003934:	ec06                	sd	ra,24(sp)
    80003936:	e822                	sd	s0,16(sp)
    80003938:	e426                	sd	s1,8(sp)
    8000393a:	e04a                	sd	s2,0(sp)
    8000393c:	1000                	addi	s0,sp,32
    8000393e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003940:	00850913          	addi	s2,a0,8
    80003944:	854a                	mv	a0,s2
    80003946:	00003097          	auipc	ra,0x3
    8000394a:	8be080e7          	jalr	-1858(ra) # 80006204 <acquire>
  lk->locked = 0;
    8000394e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003952:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003956:	8526                	mv	a0,s1
    80003958:	ffffe097          	auipc	ra,0xffffe
    8000395c:	c08080e7          	jalr	-1016(ra) # 80001560 <wakeup>
  release(&lk->lk);
    80003960:	854a                	mv	a0,s2
    80003962:	00003097          	auipc	ra,0x3
    80003966:	956080e7          	jalr	-1706(ra) # 800062b8 <release>
}
    8000396a:	60e2                	ld	ra,24(sp)
    8000396c:	6442                	ld	s0,16(sp)
    8000396e:	64a2                	ld	s1,8(sp)
    80003970:	6902                	ld	s2,0(sp)
    80003972:	6105                	addi	sp,sp,32
    80003974:	8082                	ret

0000000080003976 <holdingsleep>:

int holdingsleep(struct sleeplock *lk) {
    80003976:	7179                	addi	sp,sp,-48
    80003978:	f406                	sd	ra,40(sp)
    8000397a:	f022                	sd	s0,32(sp)
    8000397c:	ec26                	sd	s1,24(sp)
    8000397e:	e84a                	sd	s2,16(sp)
    80003980:	e44e                	sd	s3,8(sp)
    80003982:	1800                	addi	s0,sp,48
    80003984:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    80003986:	00850913          	addi	s2,a0,8
    8000398a:	854a                	mv	a0,s2
    8000398c:	00003097          	auipc	ra,0x3
    80003990:	878080e7          	jalr	-1928(ra) # 80006204 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003994:	409c                	lw	a5,0(s1)
    80003996:	ef99                	bnez	a5,800039b4 <holdingsleep+0x3e>
    80003998:	4481                	li	s1,0
  release(&lk->lk);
    8000399a:	854a                	mv	a0,s2
    8000399c:	00003097          	auipc	ra,0x3
    800039a0:	91c080e7          	jalr	-1764(ra) # 800062b8 <release>
  return r;
}
    800039a4:	8526                	mv	a0,s1
    800039a6:	70a2                	ld	ra,40(sp)
    800039a8:	7402                	ld	s0,32(sp)
    800039aa:	64e2                	ld	s1,24(sp)
    800039ac:	6942                	ld	s2,16(sp)
    800039ae:	69a2                	ld	s3,8(sp)
    800039b0:	6145                	addi	sp,sp,48
    800039b2:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800039b4:	0284a983          	lw	s3,40(s1)
    800039b8:	ffffd097          	auipc	ra,0xffffd
    800039bc:	49c080e7          	jalr	1180(ra) # 80000e54 <myproc>
    800039c0:	5904                	lw	s1,48(a0)
    800039c2:	413484b3          	sub	s1,s1,s3
    800039c6:	0014b493          	seqz	s1,s1
    800039ca:	bfc1                	j	8000399a <holdingsleep+0x24>

00000000800039cc <fileinit>:
struct {
  struct spinlock lock;
  struct file file[NFILE];
} ftable;

void fileinit(void) { initlock(&ftable.lock, "ftable"); }
    800039cc:	1141                	addi	sp,sp,-16
    800039ce:	e406                	sd	ra,8(sp)
    800039d0:	e022                	sd	s0,0(sp)
    800039d2:	0800                	addi	s0,sp,16
    800039d4:	00005597          	auipc	a1,0x5
    800039d8:	c5458593          	addi	a1,a1,-940 # 80008628 <syscalls+0x248>
    800039dc:	00015517          	auipc	a0,0x15
    800039e0:	05c50513          	addi	a0,a0,92 # 80018a38 <ftable>
    800039e4:	00002097          	auipc	ra,0x2
    800039e8:	790080e7          	jalr	1936(ra) # 80006174 <initlock>
    800039ec:	60a2                	ld	ra,8(sp)
    800039ee:	6402                	ld	s0,0(sp)
    800039f0:	0141                	addi	sp,sp,16
    800039f2:	8082                	ret

00000000800039f4 <filealloc>:

// Allocate a file structure.
struct file *filealloc(void) {
    800039f4:	1101                	addi	sp,sp,-32
    800039f6:	ec06                	sd	ra,24(sp)
    800039f8:	e822                	sd	s0,16(sp)
    800039fa:	e426                	sd	s1,8(sp)
    800039fc:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039fe:	00015517          	auipc	a0,0x15
    80003a02:	03a50513          	addi	a0,a0,58 # 80018a38 <ftable>
    80003a06:	00002097          	auipc	ra,0x2
    80003a0a:	7fe080e7          	jalr	2046(ra) # 80006204 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80003a0e:	00015497          	auipc	s1,0x15
    80003a12:	04248493          	addi	s1,s1,66 # 80018a50 <ftable+0x18>
    80003a16:	00016717          	auipc	a4,0x16
    80003a1a:	fda70713          	addi	a4,a4,-38 # 800199f0 <disk>
    if (f->ref == 0) {
    80003a1e:	40dc                	lw	a5,4(s1)
    80003a20:	cf99                	beqz	a5,80003a3e <filealloc+0x4a>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80003a22:	02848493          	addi	s1,s1,40
    80003a26:	fee49ce3          	bne	s1,a4,80003a1e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a2a:	00015517          	auipc	a0,0x15
    80003a2e:	00e50513          	addi	a0,a0,14 # 80018a38 <ftable>
    80003a32:	00003097          	auipc	ra,0x3
    80003a36:	886080e7          	jalr	-1914(ra) # 800062b8 <release>
  return 0;
    80003a3a:	4481                	li	s1,0
    80003a3c:	a819                	j	80003a52 <filealloc+0x5e>
      f->ref = 1;
    80003a3e:	4785                	li	a5,1
    80003a40:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a42:	00015517          	auipc	a0,0x15
    80003a46:	ff650513          	addi	a0,a0,-10 # 80018a38 <ftable>
    80003a4a:	00003097          	auipc	ra,0x3
    80003a4e:	86e080e7          	jalr	-1938(ra) # 800062b8 <release>
}
    80003a52:	8526                	mv	a0,s1
    80003a54:	60e2                	ld	ra,24(sp)
    80003a56:	6442                	ld	s0,16(sp)
    80003a58:	64a2                	ld	s1,8(sp)
    80003a5a:	6105                	addi	sp,sp,32
    80003a5c:	8082                	ret

0000000080003a5e <filedup>:

// Increment ref count for file f.
struct file *filedup(struct file *f) {
    80003a5e:	1101                	addi	sp,sp,-32
    80003a60:	ec06                	sd	ra,24(sp)
    80003a62:	e822                	sd	s0,16(sp)
    80003a64:	e426                	sd	s1,8(sp)
    80003a66:	1000                	addi	s0,sp,32
    80003a68:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a6a:	00015517          	auipc	a0,0x15
    80003a6e:	fce50513          	addi	a0,a0,-50 # 80018a38 <ftable>
    80003a72:	00002097          	auipc	ra,0x2
    80003a76:	792080e7          	jalr	1938(ra) # 80006204 <acquire>
  if (f->ref < 1) panic("filedup");
    80003a7a:	40dc                	lw	a5,4(s1)
    80003a7c:	02f05263          	blez	a5,80003aa0 <filedup+0x42>
  f->ref++;
    80003a80:	2785                	addiw	a5,a5,1
    80003a82:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a84:	00015517          	auipc	a0,0x15
    80003a88:	fb450513          	addi	a0,a0,-76 # 80018a38 <ftable>
    80003a8c:	00003097          	auipc	ra,0x3
    80003a90:	82c080e7          	jalr	-2004(ra) # 800062b8 <release>
  return f;
}
    80003a94:	8526                	mv	a0,s1
    80003a96:	60e2                	ld	ra,24(sp)
    80003a98:	6442                	ld	s0,16(sp)
    80003a9a:	64a2                	ld	s1,8(sp)
    80003a9c:	6105                	addi	sp,sp,32
    80003a9e:	8082                	ret
  if (f->ref < 1) panic("filedup");
    80003aa0:	00005517          	auipc	a0,0x5
    80003aa4:	b9050513          	addi	a0,a0,-1136 # 80008630 <syscalls+0x250>
    80003aa8:	00002097          	auipc	ra,0x2
    80003aac:	224080e7          	jalr	548(ra) # 80005ccc <panic>

0000000080003ab0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f) {
    80003ab0:	7139                	addi	sp,sp,-64
    80003ab2:	fc06                	sd	ra,56(sp)
    80003ab4:	f822                	sd	s0,48(sp)
    80003ab6:	f426                	sd	s1,40(sp)
    80003ab8:	f04a                	sd	s2,32(sp)
    80003aba:	ec4e                	sd	s3,24(sp)
    80003abc:	e852                	sd	s4,16(sp)
    80003abe:	e456                	sd	s5,8(sp)
    80003ac0:	0080                	addi	s0,sp,64
    80003ac2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003ac4:	00015517          	auipc	a0,0x15
    80003ac8:	f7450513          	addi	a0,a0,-140 # 80018a38 <ftable>
    80003acc:	00002097          	auipc	ra,0x2
    80003ad0:	738080e7          	jalr	1848(ra) # 80006204 <acquire>
  if (f->ref < 1) panic("fileclose");
    80003ad4:	40dc                	lw	a5,4(s1)
    80003ad6:	06f05163          	blez	a5,80003b38 <fileclose+0x88>
  if (--f->ref > 0) {
    80003ada:	37fd                	addiw	a5,a5,-1
    80003adc:	0007871b          	sext.w	a4,a5
    80003ae0:	c0dc                	sw	a5,4(s1)
    80003ae2:	06e04363          	bgtz	a4,80003b48 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ae6:	0004a903          	lw	s2,0(s1)
    80003aea:	0094ca83          	lbu	s5,9(s1)
    80003aee:	0104ba03          	ld	s4,16(s1)
    80003af2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003af6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003afa:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003afe:	00015517          	auipc	a0,0x15
    80003b02:	f3a50513          	addi	a0,a0,-198 # 80018a38 <ftable>
    80003b06:	00002097          	auipc	ra,0x2
    80003b0a:	7b2080e7          	jalr	1970(ra) # 800062b8 <release>

  if (ff.type == FD_PIPE) {
    80003b0e:	4785                	li	a5,1
    80003b10:	04f90d63          	beq	s2,a5,80003b6a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    80003b14:	3979                	addiw	s2,s2,-2
    80003b16:	4785                	li	a5,1
    80003b18:	0527e063          	bltu	a5,s2,80003b58 <fileclose+0xa8>
    begin_op();
    80003b1c:	00000097          	auipc	ra,0x0
    80003b20:	acc080e7          	jalr	-1332(ra) # 800035e8 <begin_op>
    iput(ff.ip);
    80003b24:	854e                	mv	a0,s3
    80003b26:	fffff097          	auipc	ra,0xfffff
    80003b2a:	2b0080e7          	jalr	688(ra) # 80002dd6 <iput>
    end_op();
    80003b2e:	00000097          	auipc	ra,0x0
    80003b32:	b38080e7          	jalr	-1224(ra) # 80003666 <end_op>
    80003b36:	a00d                	j	80003b58 <fileclose+0xa8>
  if (f->ref < 1) panic("fileclose");
    80003b38:	00005517          	auipc	a0,0x5
    80003b3c:	b0050513          	addi	a0,a0,-1280 # 80008638 <syscalls+0x258>
    80003b40:	00002097          	auipc	ra,0x2
    80003b44:	18c080e7          	jalr	396(ra) # 80005ccc <panic>
    release(&ftable.lock);
    80003b48:	00015517          	auipc	a0,0x15
    80003b4c:	ef050513          	addi	a0,a0,-272 # 80018a38 <ftable>
    80003b50:	00002097          	auipc	ra,0x2
    80003b54:	768080e7          	jalr	1896(ra) # 800062b8 <release>
  }
}
    80003b58:	70e2                	ld	ra,56(sp)
    80003b5a:	7442                	ld	s0,48(sp)
    80003b5c:	74a2                	ld	s1,40(sp)
    80003b5e:	7902                	ld	s2,32(sp)
    80003b60:	69e2                	ld	s3,24(sp)
    80003b62:	6a42                	ld	s4,16(sp)
    80003b64:	6aa2                	ld	s5,8(sp)
    80003b66:	6121                	addi	sp,sp,64
    80003b68:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b6a:	85d6                	mv	a1,s5
    80003b6c:	8552                	mv	a0,s4
    80003b6e:	00000097          	auipc	ra,0x0
    80003b72:	34c080e7          	jalr	844(ra) # 80003eba <pipeclose>
    80003b76:	b7cd                	j	80003b58 <fileclose+0xa8>

0000000080003b78 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr) {
    80003b78:	715d                	addi	sp,sp,-80
    80003b7a:	e486                	sd	ra,72(sp)
    80003b7c:	e0a2                	sd	s0,64(sp)
    80003b7e:	fc26                	sd	s1,56(sp)
    80003b80:	f84a                	sd	s2,48(sp)
    80003b82:	f44e                	sd	s3,40(sp)
    80003b84:	0880                	addi	s0,sp,80
    80003b86:	84aa                	mv	s1,a0
    80003b88:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b8a:	ffffd097          	auipc	ra,0xffffd
    80003b8e:	2ca080e7          	jalr	714(ra) # 80000e54 <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    80003b92:	409c                	lw	a5,0(s1)
    80003b94:	37f9                	addiw	a5,a5,-2
    80003b96:	4705                	li	a4,1
    80003b98:	04f76763          	bltu	a4,a5,80003be6 <filestat+0x6e>
    80003b9c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b9e:	6c88                	ld	a0,24(s1)
    80003ba0:	fffff097          	auipc	ra,0xfffff
    80003ba4:	07c080e7          	jalr	124(ra) # 80002c1c <ilock>
    stati(f->ip, &st);
    80003ba8:	fb840593          	addi	a1,s0,-72
    80003bac:	6c88                	ld	a0,24(s1)
    80003bae:	fffff097          	auipc	ra,0xfffff
    80003bb2:	2f8080e7          	jalr	760(ra) # 80002ea6 <stati>
    iunlock(f->ip);
    80003bb6:	6c88                	ld	a0,24(s1)
    80003bb8:	fffff097          	auipc	ra,0xfffff
    80003bbc:	126080e7          	jalr	294(ra) # 80002cde <iunlock>
    if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0) return -1;
    80003bc0:	46e1                	li	a3,24
    80003bc2:	fb840613          	addi	a2,s0,-72
    80003bc6:	85ce                	mv	a1,s3
    80003bc8:	05093503          	ld	a0,80(s2)
    80003bcc:	ffffd097          	auipc	ra,0xffffd
    80003bd0:	f48080e7          	jalr	-184(ra) # 80000b14 <copyout>
    80003bd4:	41f5551b          	sraiw	a0,a0,0x1f
    return 0;
  }
  return -1;
}
    80003bd8:	60a6                	ld	ra,72(sp)
    80003bda:	6406                	ld	s0,64(sp)
    80003bdc:	74e2                	ld	s1,56(sp)
    80003bde:	7942                	ld	s2,48(sp)
    80003be0:	79a2                	ld	s3,40(sp)
    80003be2:	6161                	addi	sp,sp,80
    80003be4:	8082                	ret
  return -1;
    80003be6:	557d                	li	a0,-1
    80003be8:	bfc5                	j	80003bd8 <filestat+0x60>

0000000080003bea <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n) {
    80003bea:	7179                	addi	sp,sp,-48
    80003bec:	f406                	sd	ra,40(sp)
    80003bee:	f022                	sd	s0,32(sp)
    80003bf0:	ec26                	sd	s1,24(sp)
    80003bf2:	e84a                	sd	s2,16(sp)
    80003bf4:	e44e                	sd	s3,8(sp)
    80003bf6:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0) return -1;
    80003bf8:	00854783          	lbu	a5,8(a0)
    80003bfc:	c3d5                	beqz	a5,80003ca0 <fileread+0xb6>
    80003bfe:	84aa                	mv	s1,a0
    80003c00:	89ae                	mv	s3,a1
    80003c02:	8932                	mv	s2,a2

  if (f->type == FD_PIPE) {
    80003c04:	411c                	lw	a5,0(a0)
    80003c06:	4705                	li	a4,1
    80003c08:	04e78963          	beq	a5,a4,80003c5a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80003c0c:	470d                	li	a4,3
    80003c0e:	04e78d63          	beq	a5,a4,80003c68 <fileread+0x7e>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    80003c12:	4709                	li	a4,2
    80003c14:	06e79e63          	bne	a5,a4,80003c90 <fileread+0xa6>
    ilock(f->ip);
    80003c18:	6d08                	ld	a0,24(a0)
    80003c1a:	fffff097          	auipc	ra,0xfffff
    80003c1e:	002080e7          	jalr	2(ra) # 80002c1c <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0) f->off += r;
    80003c22:	874a                	mv	a4,s2
    80003c24:	5094                	lw	a3,32(s1)
    80003c26:	864e                	mv	a2,s3
    80003c28:	4585                	li	a1,1
    80003c2a:	6c88                	ld	a0,24(s1)
    80003c2c:	fffff097          	auipc	ra,0xfffff
    80003c30:	2a4080e7          	jalr	676(ra) # 80002ed0 <readi>
    80003c34:	892a                	mv	s2,a0
    80003c36:	00a05563          	blez	a0,80003c40 <fileread+0x56>
    80003c3a:	509c                	lw	a5,32(s1)
    80003c3c:	9fa9                	addw	a5,a5,a0
    80003c3e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c40:	6c88                	ld	a0,24(s1)
    80003c42:	fffff097          	auipc	ra,0xfffff
    80003c46:	09c080e7          	jalr	156(ra) # 80002cde <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c4a:	854a                	mv	a0,s2
    80003c4c:	70a2                	ld	ra,40(sp)
    80003c4e:	7402                	ld	s0,32(sp)
    80003c50:	64e2                	ld	s1,24(sp)
    80003c52:	6942                	ld	s2,16(sp)
    80003c54:	69a2                	ld	s3,8(sp)
    80003c56:	6145                	addi	sp,sp,48
    80003c58:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c5a:	6908                	ld	a0,16(a0)
    80003c5c:	00000097          	auipc	ra,0x0
    80003c60:	3c6080e7          	jalr	966(ra) # 80004022 <piperead>
    80003c64:	892a                	mv	s2,a0
    80003c66:	b7d5                	j	80003c4a <fileread+0x60>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    80003c68:	02451783          	lh	a5,36(a0)
    80003c6c:	03079693          	slli	a3,a5,0x30
    80003c70:	92c1                	srli	a3,a3,0x30
    80003c72:	4725                	li	a4,9
    80003c74:	02d76863          	bltu	a4,a3,80003ca4 <fileread+0xba>
    80003c78:	0792                	slli	a5,a5,0x4
    80003c7a:	00015717          	auipc	a4,0x15
    80003c7e:	d1e70713          	addi	a4,a4,-738 # 80018998 <devsw>
    80003c82:	97ba                	add	a5,a5,a4
    80003c84:	639c                	ld	a5,0(a5)
    80003c86:	c38d                	beqz	a5,80003ca8 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c88:	4505                	li	a0,1
    80003c8a:	9782                	jalr	a5
    80003c8c:	892a                	mv	s2,a0
    80003c8e:	bf75                	j	80003c4a <fileread+0x60>
    panic("fileread");
    80003c90:	00005517          	auipc	a0,0x5
    80003c94:	9b850513          	addi	a0,a0,-1608 # 80008648 <syscalls+0x268>
    80003c98:	00002097          	auipc	ra,0x2
    80003c9c:	034080e7          	jalr	52(ra) # 80005ccc <panic>
  if (f->readable == 0) return -1;
    80003ca0:	597d                	li	s2,-1
    80003ca2:	b765                	j	80003c4a <fileread+0x60>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    80003ca4:	597d                	li	s2,-1
    80003ca6:	b755                	j	80003c4a <fileread+0x60>
    80003ca8:	597d                	li	s2,-1
    80003caa:	b745                	j	80003c4a <fileread+0x60>

0000000080003cac <filewrite>:

// Write to file f.
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n) {
    80003cac:	715d                	addi	sp,sp,-80
    80003cae:	e486                	sd	ra,72(sp)
    80003cb0:	e0a2                	sd	s0,64(sp)
    80003cb2:	fc26                	sd	s1,56(sp)
    80003cb4:	f84a                	sd	s2,48(sp)
    80003cb6:	f44e                	sd	s3,40(sp)
    80003cb8:	f052                	sd	s4,32(sp)
    80003cba:	ec56                	sd	s5,24(sp)
    80003cbc:	e85a                	sd	s6,16(sp)
    80003cbe:	e45e                	sd	s7,8(sp)
    80003cc0:	e062                	sd	s8,0(sp)
    80003cc2:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if (f->writable == 0) return -1;
    80003cc4:	00954783          	lbu	a5,9(a0)
    80003cc8:	10078663          	beqz	a5,80003dd4 <filewrite+0x128>
    80003ccc:	892a                	mv	s2,a0
    80003cce:	8b2e                	mv	s6,a1
    80003cd0:	8a32                	mv	s4,a2

  if (f->type == FD_PIPE) {
    80003cd2:	411c                	lw	a5,0(a0)
    80003cd4:	4705                	li	a4,1
    80003cd6:	02e78263          	beq	a5,a4,80003cfa <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80003cda:	470d                	li	a4,3
    80003cdc:	02e78663          	beq	a5,a4,80003d08 <filewrite+0x5c>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    80003ce0:	4709                	li	a4,2
    80003ce2:	0ee79163          	bne	a5,a4,80003dc4 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    80003ce6:	0ac05d63          	blez	a2,80003da0 <filewrite+0xf4>
    int i = 0;
    80003cea:	4981                	li	s3,0
    80003cec:	6b85                	lui	s7,0x1
    80003cee:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003cf2:	6c05                	lui	s8,0x1
    80003cf4:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003cf8:	a861                	j	80003d90 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003cfa:	6908                	ld	a0,16(a0)
    80003cfc:	00000097          	auipc	ra,0x0
    80003d00:	22e080e7          	jalr	558(ra) # 80003f2a <pipewrite>
    80003d04:	8a2a                	mv	s4,a0
    80003d06:	a045                	j	80003da6 <filewrite+0xfa>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    80003d08:	02451783          	lh	a5,36(a0)
    80003d0c:	03079693          	slli	a3,a5,0x30
    80003d10:	92c1                	srli	a3,a3,0x30
    80003d12:	4725                	li	a4,9
    80003d14:	0cd76263          	bltu	a4,a3,80003dd8 <filewrite+0x12c>
    80003d18:	0792                	slli	a5,a5,0x4
    80003d1a:	00015717          	auipc	a4,0x15
    80003d1e:	c7e70713          	addi	a4,a4,-898 # 80018998 <devsw>
    80003d22:	97ba                	add	a5,a5,a4
    80003d24:	679c                	ld	a5,8(a5)
    80003d26:	cbdd                	beqz	a5,80003ddc <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d28:	4505                	li	a0,1
    80003d2a:	9782                	jalr	a5
    80003d2c:	8a2a                	mv	s4,a0
    80003d2e:	a8a5                	j	80003da6 <filewrite+0xfa>
    80003d30:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if (n1 > max) n1 = max;

      begin_op();
    80003d34:	00000097          	auipc	ra,0x0
    80003d38:	8b4080e7          	jalr	-1868(ra) # 800035e8 <begin_op>
      ilock(f->ip);
    80003d3c:	01893503          	ld	a0,24(s2)
    80003d40:	fffff097          	auipc	ra,0xfffff
    80003d44:	edc080e7          	jalr	-292(ra) # 80002c1c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0) f->off += r;
    80003d48:	8756                	mv	a4,s5
    80003d4a:	02092683          	lw	a3,32(s2)
    80003d4e:	01698633          	add	a2,s3,s6
    80003d52:	4585                	li	a1,1
    80003d54:	01893503          	ld	a0,24(s2)
    80003d58:	fffff097          	auipc	ra,0xfffff
    80003d5c:	270080e7          	jalr	624(ra) # 80002fc8 <writei>
    80003d60:	84aa                	mv	s1,a0
    80003d62:	00a05763          	blez	a0,80003d70 <filewrite+0xc4>
    80003d66:	02092783          	lw	a5,32(s2)
    80003d6a:	9fa9                	addw	a5,a5,a0
    80003d6c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d70:	01893503          	ld	a0,24(s2)
    80003d74:	fffff097          	auipc	ra,0xfffff
    80003d78:	f6a080e7          	jalr	-150(ra) # 80002cde <iunlock>
      end_op();
    80003d7c:	00000097          	auipc	ra,0x0
    80003d80:	8ea080e7          	jalr	-1814(ra) # 80003666 <end_op>

      if (r != n1) {
    80003d84:	009a9f63          	bne	s5,s1,80003da2 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d88:	013489bb          	addw	s3,s1,s3
    while (i < n) {
    80003d8c:	0149db63          	bge	s3,s4,80003da2 <filewrite+0xf6>
      int n1 = n - i;
    80003d90:	413a04bb          	subw	s1,s4,s3
    80003d94:	0004879b          	sext.w	a5,s1
    80003d98:	f8fbdce3          	bge	s7,a5,80003d30 <filewrite+0x84>
    80003d9c:	84e2                	mv	s1,s8
    80003d9e:	bf49                	j	80003d30 <filewrite+0x84>
    int i = 0;
    80003da0:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003da2:	013a1f63          	bne	s4,s3,80003dc0 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003da6:	8552                	mv	a0,s4
    80003da8:	60a6                	ld	ra,72(sp)
    80003daa:	6406                	ld	s0,64(sp)
    80003dac:	74e2                	ld	s1,56(sp)
    80003dae:	7942                	ld	s2,48(sp)
    80003db0:	79a2                	ld	s3,40(sp)
    80003db2:	7a02                	ld	s4,32(sp)
    80003db4:	6ae2                	ld	s5,24(sp)
    80003db6:	6b42                	ld	s6,16(sp)
    80003db8:	6ba2                	ld	s7,8(sp)
    80003dba:	6c02                	ld	s8,0(sp)
    80003dbc:	6161                	addi	sp,sp,80
    80003dbe:	8082                	ret
    ret = (i == n ? n : -1);
    80003dc0:	5a7d                	li	s4,-1
    80003dc2:	b7d5                	j	80003da6 <filewrite+0xfa>
    panic("filewrite");
    80003dc4:	00005517          	auipc	a0,0x5
    80003dc8:	89450513          	addi	a0,a0,-1900 # 80008658 <syscalls+0x278>
    80003dcc:	00002097          	auipc	ra,0x2
    80003dd0:	f00080e7          	jalr	-256(ra) # 80005ccc <panic>
  if (f->writable == 0) return -1;
    80003dd4:	5a7d                	li	s4,-1
    80003dd6:	bfc1                	j	80003da6 <filewrite+0xfa>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    80003dd8:	5a7d                	li	s4,-1
    80003dda:	b7f1                	j	80003da6 <filewrite+0xfa>
    80003ddc:	5a7d                	li	s4,-1
    80003dde:	b7e1                	j	80003da6 <filewrite+0xfa>

0000000080003de0 <pipealloc>:
  uint nwrite;    // number of bytes written
  int readopen;   // read fd is still open
  int writeopen;  // write fd is still open
};

int pipealloc(struct file **f0, struct file **f1) {
    80003de0:	7179                	addi	sp,sp,-48
    80003de2:	f406                	sd	ra,40(sp)
    80003de4:	f022                	sd	s0,32(sp)
    80003de6:	ec26                	sd	s1,24(sp)
    80003de8:	e84a                	sd	s2,16(sp)
    80003dea:	e44e                	sd	s3,8(sp)
    80003dec:	e052                	sd	s4,0(sp)
    80003dee:	1800                	addi	s0,sp,48
    80003df0:	84aa                	mv	s1,a0
    80003df2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003df4:	0005b023          	sd	zero,0(a1)
    80003df8:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0) goto bad;
    80003dfc:	00000097          	auipc	ra,0x0
    80003e00:	bf8080e7          	jalr	-1032(ra) # 800039f4 <filealloc>
    80003e04:	e088                	sd	a0,0(s1)
    80003e06:	c551                	beqz	a0,80003e92 <pipealloc+0xb2>
    80003e08:	00000097          	auipc	ra,0x0
    80003e0c:	bec080e7          	jalr	-1044(ra) # 800039f4 <filealloc>
    80003e10:	00aa3023          	sd	a0,0(s4)
    80003e14:	c92d                	beqz	a0,80003e86 <pipealloc+0xa6>
  if ((pi = (struct pipe *)kalloc()) == 0) goto bad;
    80003e16:	ffffc097          	auipc	ra,0xffffc
    80003e1a:	304080e7          	jalr	772(ra) # 8000011a <kalloc>
    80003e1e:	892a                	mv	s2,a0
    80003e20:	c125                	beqz	a0,80003e80 <pipealloc+0xa0>
  pi->readopen = 1;
    80003e22:	4985                	li	s3,1
    80003e24:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e28:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e2c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e30:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e34:	00005597          	auipc	a1,0x5
    80003e38:	83458593          	addi	a1,a1,-1996 # 80008668 <syscalls+0x288>
    80003e3c:	00002097          	auipc	ra,0x2
    80003e40:	338080e7          	jalr	824(ra) # 80006174 <initlock>
  (*f0)->type = FD_PIPE;
    80003e44:	609c                	ld	a5,0(s1)
    80003e46:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e4a:	609c                	ld	a5,0(s1)
    80003e4c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e50:	609c                	ld	a5,0(s1)
    80003e52:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e56:	609c                	ld	a5,0(s1)
    80003e58:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e5c:	000a3783          	ld	a5,0(s4)
    80003e60:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e64:	000a3783          	ld	a5,0(s4)
    80003e68:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e6c:	000a3783          	ld	a5,0(s4)
    80003e70:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e74:	000a3783          	ld	a5,0(s4)
    80003e78:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e7c:	4501                	li	a0,0
    80003e7e:	a025                	j	80003ea6 <pipealloc+0xc6>

bad:
  if (pi) kfree((char *)pi);
  if (*f0) fileclose(*f0);
    80003e80:	6088                	ld	a0,0(s1)
    80003e82:	e501                	bnez	a0,80003e8a <pipealloc+0xaa>
    80003e84:	a039                	j	80003e92 <pipealloc+0xb2>
    80003e86:	6088                	ld	a0,0(s1)
    80003e88:	c51d                	beqz	a0,80003eb6 <pipealloc+0xd6>
    80003e8a:	00000097          	auipc	ra,0x0
    80003e8e:	c26080e7          	jalr	-986(ra) # 80003ab0 <fileclose>
  if (*f1) fileclose(*f1);
    80003e92:	000a3783          	ld	a5,0(s4)
  return -1;
    80003e96:	557d                	li	a0,-1
  if (*f1) fileclose(*f1);
    80003e98:	c799                	beqz	a5,80003ea6 <pipealloc+0xc6>
    80003e9a:	853e                	mv	a0,a5
    80003e9c:	00000097          	auipc	ra,0x0
    80003ea0:	c14080e7          	jalr	-1004(ra) # 80003ab0 <fileclose>
  return -1;
    80003ea4:	557d                	li	a0,-1
}
    80003ea6:	70a2                	ld	ra,40(sp)
    80003ea8:	7402                	ld	s0,32(sp)
    80003eaa:	64e2                	ld	s1,24(sp)
    80003eac:	6942                	ld	s2,16(sp)
    80003eae:	69a2                	ld	s3,8(sp)
    80003eb0:	6a02                	ld	s4,0(sp)
    80003eb2:	6145                	addi	sp,sp,48
    80003eb4:	8082                	ret
  return -1;
    80003eb6:	557d                	li	a0,-1
    80003eb8:	b7fd                	j	80003ea6 <pipealloc+0xc6>

0000000080003eba <pipeclose>:

void pipeclose(struct pipe *pi, int writable) {
    80003eba:	1101                	addi	sp,sp,-32
    80003ebc:	ec06                	sd	ra,24(sp)
    80003ebe:	e822                	sd	s0,16(sp)
    80003ec0:	e426                	sd	s1,8(sp)
    80003ec2:	e04a                	sd	s2,0(sp)
    80003ec4:	1000                	addi	s0,sp,32
    80003ec6:	84aa                	mv	s1,a0
    80003ec8:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003eca:	00002097          	auipc	ra,0x2
    80003ece:	33a080e7          	jalr	826(ra) # 80006204 <acquire>
  if (writable) {
    80003ed2:	02090d63          	beqz	s2,80003f0c <pipeclose+0x52>
    pi->writeopen = 0;
    80003ed6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003eda:	21848513          	addi	a0,s1,536
    80003ede:	ffffd097          	auipc	ra,0xffffd
    80003ee2:	682080e7          	jalr	1666(ra) # 80001560 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    80003ee6:	2204b783          	ld	a5,544(s1)
    80003eea:	eb95                	bnez	a5,80003f1e <pipeclose+0x64>
    release(&pi->lock);
    80003eec:	8526                	mv	a0,s1
    80003eee:	00002097          	auipc	ra,0x2
    80003ef2:	3ca080e7          	jalr	970(ra) # 800062b8 <release>
    kfree((char *)pi);
    80003ef6:	8526                	mv	a0,s1
    80003ef8:	ffffc097          	auipc	ra,0xffffc
    80003efc:	124080e7          	jalr	292(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f00:	60e2                	ld	ra,24(sp)
    80003f02:	6442                	ld	s0,16(sp)
    80003f04:	64a2                	ld	s1,8(sp)
    80003f06:	6902                	ld	s2,0(sp)
    80003f08:	6105                	addi	sp,sp,32
    80003f0a:	8082                	ret
    pi->readopen = 0;
    80003f0c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f10:	21c48513          	addi	a0,s1,540
    80003f14:	ffffd097          	auipc	ra,0xffffd
    80003f18:	64c080e7          	jalr	1612(ra) # 80001560 <wakeup>
    80003f1c:	b7e9                	j	80003ee6 <pipeclose+0x2c>
    release(&pi->lock);
    80003f1e:	8526                	mv	a0,s1
    80003f20:	00002097          	auipc	ra,0x2
    80003f24:	398080e7          	jalr	920(ra) # 800062b8 <release>
}
    80003f28:	bfe1                	j	80003f00 <pipeclose+0x46>

0000000080003f2a <pipewrite>:

int pipewrite(struct pipe *pi, uint64 addr, int n) {
    80003f2a:	711d                	addi	sp,sp,-96
    80003f2c:	ec86                	sd	ra,88(sp)
    80003f2e:	e8a2                	sd	s0,80(sp)
    80003f30:	e4a6                	sd	s1,72(sp)
    80003f32:	e0ca                	sd	s2,64(sp)
    80003f34:	fc4e                	sd	s3,56(sp)
    80003f36:	f852                	sd	s4,48(sp)
    80003f38:	f456                	sd	s5,40(sp)
    80003f3a:	f05a                	sd	s6,32(sp)
    80003f3c:	ec5e                	sd	s7,24(sp)
    80003f3e:	e862                	sd	s8,16(sp)
    80003f40:	1080                	addi	s0,sp,96
    80003f42:	84aa                	mv	s1,a0
    80003f44:	8aae                	mv	s5,a1
    80003f46:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f48:	ffffd097          	auipc	ra,0xffffd
    80003f4c:	f0c080e7          	jalr	-244(ra) # 80000e54 <myproc>
    80003f50:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f52:	8526                	mv	a0,s1
    80003f54:	00002097          	auipc	ra,0x2
    80003f58:	2b0080e7          	jalr	688(ra) # 80006204 <acquire>
  while (i < n) {
    80003f5c:	0b405663          	blez	s4,80004008 <pipewrite+0xde>
  int i = 0;
    80003f60:	4901                	li	s2,0
    if (pi->nwrite == pi->nread + PIPESIZE) {  // DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1) break;
    80003f62:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f64:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f68:	21c48b93          	addi	s7,s1,540
    80003f6c:	a089                	j	80003fae <pipewrite+0x84>
      release(&pi->lock);
    80003f6e:	8526                	mv	a0,s1
    80003f70:	00002097          	auipc	ra,0x2
    80003f74:	348080e7          	jalr	840(ra) # 800062b8 <release>
      return -1;
    80003f78:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f7a:	854a                	mv	a0,s2
    80003f7c:	60e6                	ld	ra,88(sp)
    80003f7e:	6446                	ld	s0,80(sp)
    80003f80:	64a6                	ld	s1,72(sp)
    80003f82:	6906                	ld	s2,64(sp)
    80003f84:	79e2                	ld	s3,56(sp)
    80003f86:	7a42                	ld	s4,48(sp)
    80003f88:	7aa2                	ld	s5,40(sp)
    80003f8a:	7b02                	ld	s6,32(sp)
    80003f8c:	6be2                	ld	s7,24(sp)
    80003f8e:	6c42                	ld	s8,16(sp)
    80003f90:	6125                	addi	sp,sp,96
    80003f92:	8082                	ret
      wakeup(&pi->nread);
    80003f94:	8562                	mv	a0,s8
    80003f96:	ffffd097          	auipc	ra,0xffffd
    80003f9a:	5ca080e7          	jalr	1482(ra) # 80001560 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f9e:	85a6                	mv	a1,s1
    80003fa0:	855e                	mv	a0,s7
    80003fa2:	ffffd097          	auipc	ra,0xffffd
    80003fa6:	55a080e7          	jalr	1370(ra) # 800014fc <sleep>
  while (i < n) {
    80003faa:	07495063          	bge	s2,s4,8000400a <pipewrite+0xe0>
    if (pi->readopen == 0 || killed(pr)) {
    80003fae:	2204a783          	lw	a5,544(s1)
    80003fb2:	dfd5                	beqz	a5,80003f6e <pipewrite+0x44>
    80003fb4:	854e                	mv	a0,s3
    80003fb6:	ffffd097          	auipc	ra,0xffffd
    80003fba:	7ee080e7          	jalr	2030(ra) # 800017a4 <killed>
    80003fbe:	f945                	bnez	a0,80003f6e <pipewrite+0x44>
    if (pi->nwrite == pi->nread + PIPESIZE) {  // DOC: pipewrite-full
    80003fc0:	2184a783          	lw	a5,536(s1)
    80003fc4:	21c4a703          	lw	a4,540(s1)
    80003fc8:	2007879b          	addiw	a5,a5,512
    80003fcc:	fcf704e3          	beq	a4,a5,80003f94 <pipewrite+0x6a>
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1) break;
    80003fd0:	4685                	li	a3,1
    80003fd2:	01590633          	add	a2,s2,s5
    80003fd6:	faf40593          	addi	a1,s0,-81
    80003fda:	0509b503          	ld	a0,80(s3)
    80003fde:	ffffd097          	auipc	ra,0xffffd
    80003fe2:	bc2080e7          	jalr	-1086(ra) # 80000ba0 <copyin>
    80003fe6:	03650263          	beq	a0,s6,8000400a <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fea:	21c4a783          	lw	a5,540(s1)
    80003fee:	0017871b          	addiw	a4,a5,1
    80003ff2:	20e4ae23          	sw	a4,540(s1)
    80003ff6:	1ff7f793          	andi	a5,a5,511
    80003ffa:	97a6                	add	a5,a5,s1
    80003ffc:	faf44703          	lbu	a4,-81(s0)
    80004000:	00e78c23          	sb	a4,24(a5)
      i++;
    80004004:	2905                	addiw	s2,s2,1
    80004006:	b755                	j	80003faa <pipewrite+0x80>
  int i = 0;
    80004008:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000400a:	21848513          	addi	a0,s1,536
    8000400e:	ffffd097          	auipc	ra,0xffffd
    80004012:	552080e7          	jalr	1362(ra) # 80001560 <wakeup>
  release(&pi->lock);
    80004016:	8526                	mv	a0,s1
    80004018:	00002097          	auipc	ra,0x2
    8000401c:	2a0080e7          	jalr	672(ra) # 800062b8 <release>
  return i;
    80004020:	bfa9                	j	80003f7a <pipewrite+0x50>

0000000080004022 <piperead>:

int piperead(struct pipe *pi, uint64 addr, int n) {
    80004022:	715d                	addi	sp,sp,-80
    80004024:	e486                	sd	ra,72(sp)
    80004026:	e0a2                	sd	s0,64(sp)
    80004028:	fc26                	sd	s1,56(sp)
    8000402a:	f84a                	sd	s2,48(sp)
    8000402c:	f44e                	sd	s3,40(sp)
    8000402e:	f052                	sd	s4,32(sp)
    80004030:	ec56                	sd	s5,24(sp)
    80004032:	e85a                	sd	s6,16(sp)
    80004034:	0880                	addi	s0,sp,80
    80004036:	84aa                	mv	s1,a0
    80004038:	892e                	mv	s2,a1
    8000403a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000403c:	ffffd097          	auipc	ra,0xffffd
    80004040:	e18080e7          	jalr	-488(ra) # 80000e54 <myproc>
    80004044:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004046:	8526                	mv	a0,s1
    80004048:	00002097          	auipc	ra,0x2
    8000404c:	1bc080e7          	jalr	444(ra) # 80006204 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    80004050:	2184a703          	lw	a4,536(s1)
    80004054:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock);  // DOC: piperead-sleep
    80004058:	21848993          	addi	s3,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    8000405c:	02f71763          	bne	a4,a5,8000408a <piperead+0x68>
    80004060:	2244a783          	lw	a5,548(s1)
    80004064:	c39d                	beqz	a5,8000408a <piperead+0x68>
    if (killed(pr)) {
    80004066:	8552                	mv	a0,s4
    80004068:	ffffd097          	auipc	ra,0xffffd
    8000406c:	73c080e7          	jalr	1852(ra) # 800017a4 <killed>
    80004070:	e949                	bnez	a0,80004102 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock);  // DOC: piperead-sleep
    80004072:	85a6                	mv	a1,s1
    80004074:	854e                	mv	a0,s3
    80004076:	ffffd097          	auipc	ra,0xffffd
    8000407a:	486080e7          	jalr	1158(ra) # 800014fc <sleep>
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    8000407e:	2184a703          	lw	a4,536(s1)
    80004082:	21c4a783          	lw	a5,540(s1)
    80004086:	fcf70de3          	beq	a4,a5,80004060 <piperead+0x3e>
  }
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    8000408a:	4981                	li	s3,0
    if (pi->nread == pi->nwrite) break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) break;
    8000408c:	5b7d                	li	s6,-1
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    8000408e:	05505463          	blez	s5,800040d6 <piperead+0xb4>
    if (pi->nread == pi->nwrite) break;
    80004092:	2184a783          	lw	a5,536(s1)
    80004096:	21c4a703          	lw	a4,540(s1)
    8000409a:	02f70e63          	beq	a4,a5,800040d6 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000409e:	0017871b          	addiw	a4,a5,1
    800040a2:	20e4ac23          	sw	a4,536(s1)
    800040a6:	1ff7f793          	andi	a5,a5,511
    800040aa:	97a6                	add	a5,a5,s1
    800040ac:	0187c783          	lbu	a5,24(a5)
    800040b0:	faf40fa3          	sb	a5,-65(s0)
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) break;
    800040b4:	4685                	li	a3,1
    800040b6:	fbf40613          	addi	a2,s0,-65
    800040ba:	85ca                	mv	a1,s2
    800040bc:	050a3503          	ld	a0,80(s4)
    800040c0:	ffffd097          	auipc	ra,0xffffd
    800040c4:	a54080e7          	jalr	-1452(ra) # 80000b14 <copyout>
    800040c8:	01650763          	beq	a0,s6,800040d6 <piperead+0xb4>
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    800040cc:	2985                	addiw	s3,s3,1
    800040ce:	0905                	addi	s2,s2,1
    800040d0:	fd3a91e3          	bne	s5,s3,80004092 <piperead+0x70>
    800040d4:	89d6                	mv	s3,s5
  }
  wakeup(&pi->nwrite);  // DOC: piperead-wakeup
    800040d6:	21c48513          	addi	a0,s1,540
    800040da:	ffffd097          	auipc	ra,0xffffd
    800040de:	486080e7          	jalr	1158(ra) # 80001560 <wakeup>
  release(&pi->lock);
    800040e2:	8526                	mv	a0,s1
    800040e4:	00002097          	auipc	ra,0x2
    800040e8:	1d4080e7          	jalr	468(ra) # 800062b8 <release>
  return i;
}
    800040ec:	854e                	mv	a0,s3
    800040ee:	60a6                	ld	ra,72(sp)
    800040f0:	6406                	ld	s0,64(sp)
    800040f2:	74e2                	ld	s1,56(sp)
    800040f4:	7942                	ld	s2,48(sp)
    800040f6:	79a2                	ld	s3,40(sp)
    800040f8:	7a02                	ld	s4,32(sp)
    800040fa:	6ae2                	ld	s5,24(sp)
    800040fc:	6b42                	ld	s6,16(sp)
    800040fe:	6161                	addi	sp,sp,80
    80004100:	8082                	ret
      release(&pi->lock);
    80004102:	8526                	mv	a0,s1
    80004104:	00002097          	auipc	ra,0x2
    80004108:	1b4080e7          	jalr	436(ra) # 800062b8 <release>
      return -1;
    8000410c:	59fd                	li	s3,-1
    8000410e:	bff9                	j	800040ec <piperead+0xca>

0000000080004110 <flags2perm>:
#include "defs.h"
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags) {
    80004110:	1141                	addi	sp,sp,-16
    80004112:	e422                	sd	s0,8(sp)
    80004114:	0800                	addi	s0,sp,16
    80004116:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1) perm = PTE_X;
    80004118:	8905                	andi	a0,a0,1
    8000411a:	050e                	slli	a0,a0,0x3
  if (flags & 0x2) perm |= PTE_W;
    8000411c:	8b89                	andi	a5,a5,2
    8000411e:	c399                	beqz	a5,80004124 <flags2perm+0x14>
    80004120:	00456513          	ori	a0,a0,4
  return perm;
}
    80004124:	6422                	ld	s0,8(sp)
    80004126:	0141                	addi	sp,sp,16
    80004128:	8082                	ret

000000008000412a <exec>:

int exec(char *path, char **argv) {
    8000412a:	de010113          	addi	sp,sp,-544
    8000412e:	20113c23          	sd	ra,536(sp)
    80004132:	20813823          	sd	s0,528(sp)
    80004136:	20913423          	sd	s1,520(sp)
    8000413a:	21213023          	sd	s2,512(sp)
    8000413e:	ffce                	sd	s3,504(sp)
    80004140:	fbd2                	sd	s4,496(sp)
    80004142:	f7d6                	sd	s5,488(sp)
    80004144:	f3da                	sd	s6,480(sp)
    80004146:	efde                	sd	s7,472(sp)
    80004148:	ebe2                	sd	s8,464(sp)
    8000414a:	e7e6                	sd	s9,456(sp)
    8000414c:	e3ea                	sd	s10,448(sp)
    8000414e:	ff6e                	sd	s11,440(sp)
    80004150:	1400                	addi	s0,sp,544
    80004152:	892a                	mv	s2,a0
    80004154:	dea43423          	sd	a0,-536(s0)
    80004158:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000415c:	ffffd097          	auipc	ra,0xffffd
    80004160:	cf8080e7          	jalr	-776(ra) # 80000e54 <myproc>
    80004164:	84aa                	mv	s1,a0

  begin_op();
    80004166:	fffff097          	auipc	ra,0xfffff
    8000416a:	482080e7          	jalr	1154(ra) # 800035e8 <begin_op>

  if ((ip = namei(path)) == 0) {
    8000416e:	854a                	mv	a0,s2
    80004170:	fffff097          	auipc	ra,0xfffff
    80004174:	258080e7          	jalr	600(ra) # 800033c8 <namei>
    80004178:	c93d                	beqz	a0,800041ee <exec+0xc4>
    8000417a:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000417c:	fffff097          	auipc	ra,0xfffff
    80004180:	aa0080e7          	jalr	-1376(ra) # 80002c1c <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf)) goto bad;
    80004184:	04000713          	li	a4,64
    80004188:	4681                	li	a3,0
    8000418a:	e5040613          	addi	a2,s0,-432
    8000418e:	4581                	li	a1,0
    80004190:	8556                	mv	a0,s5
    80004192:	fffff097          	auipc	ra,0xfffff
    80004196:	d3e080e7          	jalr	-706(ra) # 80002ed0 <readi>
    8000419a:	04000793          	li	a5,64
    8000419e:	00f51a63          	bne	a0,a5,800041b2 <exec+0x88>

  if (elf.magic != ELF_MAGIC) goto bad;
    800041a2:	e5042703          	lw	a4,-432(s0)
    800041a6:	464c47b7          	lui	a5,0x464c4
    800041aa:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041ae:	04f70663          	beq	a4,a5,800041fa <exec+0xd0>
  return argc;  // this ends up in a0, the first argument to main(argc, argv)

bad:
  if (pagetable) proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    800041b2:	8556                	mv	a0,s5
    800041b4:	fffff097          	auipc	ra,0xfffff
    800041b8:	cca080e7          	jalr	-822(ra) # 80002e7e <iunlockput>
    end_op();
    800041bc:	fffff097          	auipc	ra,0xfffff
    800041c0:	4aa080e7          	jalr	1194(ra) # 80003666 <end_op>
  }
  return -1;
    800041c4:	557d                	li	a0,-1
}
    800041c6:	21813083          	ld	ra,536(sp)
    800041ca:	21013403          	ld	s0,528(sp)
    800041ce:	20813483          	ld	s1,520(sp)
    800041d2:	20013903          	ld	s2,512(sp)
    800041d6:	79fe                	ld	s3,504(sp)
    800041d8:	7a5e                	ld	s4,496(sp)
    800041da:	7abe                	ld	s5,488(sp)
    800041dc:	7b1e                	ld	s6,480(sp)
    800041de:	6bfe                	ld	s7,472(sp)
    800041e0:	6c5e                	ld	s8,464(sp)
    800041e2:	6cbe                	ld	s9,456(sp)
    800041e4:	6d1e                	ld	s10,448(sp)
    800041e6:	7dfa                	ld	s11,440(sp)
    800041e8:	22010113          	addi	sp,sp,544
    800041ec:	8082                	ret
    end_op();
    800041ee:	fffff097          	auipc	ra,0xfffff
    800041f2:	478080e7          	jalr	1144(ra) # 80003666 <end_op>
    return -1;
    800041f6:	557d                	li	a0,-1
    800041f8:	b7f9                	j	800041c6 <exec+0x9c>
  if ((pagetable = proc_pagetable(p)) == 0) goto bad;
    800041fa:	8526                	mv	a0,s1
    800041fc:	ffffd097          	auipc	ra,0xffffd
    80004200:	d1c080e7          	jalr	-740(ra) # 80000f18 <proc_pagetable>
    80004204:	8b2a                	mv	s6,a0
    80004206:	d555                	beqz	a0,800041b2 <exec+0x88>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004208:	e7042783          	lw	a5,-400(s0)
    8000420c:	e8845703          	lhu	a4,-376(s0)
    80004210:	c735                	beqz	a4,8000427c <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004212:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004214:	e0043423          	sd	zero,-504(s0)
    if (ph.vaddr % PGSIZE != 0) goto bad;
    80004218:	6a05                	lui	s4,0x1
    8000421a:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000421e:	dee43023          	sd	a4,-544(s0)
static int loadseg(pagetable_t pagetable, uint64 va, struct inode *ip,
                   uint offset, uint sz) {
  uint i, n;
  uint64 pa;

  for (i = 0; i < sz; i += PGSIZE) {
    80004222:	6d85                	lui	s11,0x1
    80004224:	7d7d                	lui	s10,0xfffff
    80004226:	ac3d                	j	80004464 <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if (pa == 0) panic("loadseg: address should exist");
    80004228:	00004517          	auipc	a0,0x4
    8000422c:	44850513          	addi	a0,a0,1096 # 80008670 <syscalls+0x290>
    80004230:	00002097          	auipc	ra,0x2
    80004234:	a9c080e7          	jalr	-1380(ra) # 80005ccc <panic>
    if (sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n) return -1;
    80004238:	874a                	mv	a4,s2
    8000423a:	009c86bb          	addw	a3,s9,s1
    8000423e:	4581                	li	a1,0
    80004240:	8556                	mv	a0,s5
    80004242:	fffff097          	auipc	ra,0xfffff
    80004246:	c8e080e7          	jalr	-882(ra) # 80002ed0 <readi>
    8000424a:	2501                	sext.w	a0,a0
    8000424c:	1aa91963          	bne	s2,a0,800043fe <exec+0x2d4>
  for (i = 0; i < sz; i += PGSIZE) {
    80004250:	009d84bb          	addw	s1,s11,s1
    80004254:	013d09bb          	addw	s3,s10,s3
    80004258:	1f74f663          	bgeu	s1,s7,80004444 <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    8000425c:	02049593          	slli	a1,s1,0x20
    80004260:	9181                	srli	a1,a1,0x20
    80004262:	95e2                	add	a1,a1,s8
    80004264:	855a                	mv	a0,s6
    80004266:	ffffc097          	auipc	ra,0xffffc
    8000426a:	29e080e7          	jalr	670(ra) # 80000504 <walkaddr>
    8000426e:	862a                	mv	a2,a0
    if (pa == 0) panic("loadseg: address should exist");
    80004270:	dd45                	beqz	a0,80004228 <exec+0xfe>
      n = PGSIZE;
    80004272:	8952                	mv	s2,s4
    if (sz - i < PGSIZE)
    80004274:	fd49f2e3          	bgeu	s3,s4,80004238 <exec+0x10e>
      n = sz - i;
    80004278:	894e                	mv	s2,s3
    8000427a:	bf7d                	j	80004238 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000427c:	4901                	li	s2,0
  iunlockput(ip);
    8000427e:	8556                	mv	a0,s5
    80004280:	fffff097          	auipc	ra,0xfffff
    80004284:	bfe080e7          	jalr	-1026(ra) # 80002e7e <iunlockput>
  end_op();
    80004288:	fffff097          	auipc	ra,0xfffff
    8000428c:	3de080e7          	jalr	990(ra) # 80003666 <end_op>
  p = myproc();
    80004290:	ffffd097          	auipc	ra,0xffffd
    80004294:	bc4080e7          	jalr	-1084(ra) # 80000e54 <myproc>
    80004298:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    8000429a:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000429e:	6785                	lui	a5,0x1
    800042a0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800042a2:	97ca                	add	a5,a5,s2
    800042a4:	777d                	lui	a4,0xfffff
    800042a6:	8ff9                	and	a5,a5,a4
    800042a8:	def43c23          	sd	a5,-520(s0)
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0) goto bad;
    800042ac:	4691                	li	a3,4
    800042ae:	6609                	lui	a2,0x2
    800042b0:	963e                	add	a2,a2,a5
    800042b2:	85be                	mv	a1,a5
    800042b4:	855a                	mv	a0,s6
    800042b6:	ffffc097          	auipc	ra,0xffffc
    800042ba:	602080e7          	jalr	1538(ra) # 800008b8 <uvmalloc>
    800042be:	8c2a                	mv	s8,a0
  ip = 0;
    800042c0:	4a81                	li	s5,0
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0) goto bad;
    800042c2:	12050e63          	beqz	a0,800043fe <exec+0x2d4>
  uvmclear(pagetable, sz - 2 * PGSIZE);
    800042c6:	75f9                	lui	a1,0xffffe
    800042c8:	95aa                	add	a1,a1,a0
    800042ca:	855a                	mv	a0,s6
    800042cc:	ffffd097          	auipc	ra,0xffffd
    800042d0:	816080e7          	jalr	-2026(ra) # 80000ae2 <uvmclear>
  stackbase = sp - PGSIZE;
    800042d4:	7afd                	lui	s5,0xfffff
    800042d6:	9ae2                	add	s5,s5,s8
  for (argc = 0; argv[argc]; argc++) {
    800042d8:	df043783          	ld	a5,-528(s0)
    800042dc:	6388                	ld	a0,0(a5)
    800042de:	c925                	beqz	a0,8000434e <exec+0x224>
    800042e0:	e9040993          	addi	s3,s0,-368
    800042e4:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800042e8:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    800042ea:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800042ec:	ffffc097          	auipc	ra,0xffffc
    800042f0:	00a080e7          	jalr	10(ra) # 800002f6 <strlen>
    800042f4:	0015079b          	addiw	a5,a0,1
    800042f8:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16;  // riscv sp must be 16-byte aligned
    800042fc:	ff07f913          	andi	s2,a5,-16
    if (sp < stackbase) goto bad;
    80004300:	13596663          	bltu	s2,s5,8000442c <exec+0x302>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004304:	df043d83          	ld	s11,-528(s0)
    80004308:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000430c:	8552                	mv	a0,s4
    8000430e:	ffffc097          	auipc	ra,0xffffc
    80004312:	fe8080e7          	jalr	-24(ra) # 800002f6 <strlen>
    80004316:	0015069b          	addiw	a3,a0,1
    8000431a:	8652                	mv	a2,s4
    8000431c:	85ca                	mv	a1,s2
    8000431e:	855a                	mv	a0,s6
    80004320:	ffffc097          	auipc	ra,0xffffc
    80004324:	7f4080e7          	jalr	2036(ra) # 80000b14 <copyout>
    80004328:	10054663          	bltz	a0,80004434 <exec+0x30a>
    ustack[argc] = sp;
    8000432c:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++) {
    80004330:	0485                	addi	s1,s1,1
    80004332:	008d8793          	addi	a5,s11,8
    80004336:	def43823          	sd	a5,-528(s0)
    8000433a:	008db503          	ld	a0,8(s11)
    8000433e:	c911                	beqz	a0,80004352 <exec+0x228>
    if (argc >= MAXARG) goto bad;
    80004340:	09a1                	addi	s3,s3,8
    80004342:	fb3c95e3          	bne	s9,s3,800042ec <exec+0x1c2>
  sz = sz1;
    80004346:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000434a:	4a81                	li	s5,0
    8000434c:	a84d                	j	800043fe <exec+0x2d4>
  sp = sz;
    8000434e:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    80004350:	4481                	li	s1,0
  ustack[argc] = 0;
    80004352:	00349793          	slli	a5,s1,0x3
    80004356:	f9078793          	addi	a5,a5,-112
    8000435a:	97a2                	add	a5,a5,s0
    8000435c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    80004360:	00148693          	addi	a3,s1,1
    80004364:	068e                	slli	a3,a3,0x3
    80004366:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000436a:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase) goto bad;
    8000436e:	01597663          	bgeu	s2,s5,8000437a <exec+0x250>
  sz = sz1;
    80004372:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004376:	4a81                	li	s5,0
    80004378:	a059                	j	800043fe <exec+0x2d4>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    8000437a:	e9040613          	addi	a2,s0,-368
    8000437e:	85ca                	mv	a1,s2
    80004380:	855a                	mv	a0,s6
    80004382:	ffffc097          	auipc	ra,0xffffc
    80004386:	792080e7          	jalr	1938(ra) # 80000b14 <copyout>
    8000438a:	0a054963          	bltz	a0,8000443c <exec+0x312>
  p->trapframe->a1 = sp;
    8000438e:	058bb783          	ld	a5,88(s7)
    80004392:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    80004396:	de843783          	ld	a5,-536(s0)
    8000439a:	0007c703          	lbu	a4,0(a5)
    8000439e:	cf11                	beqz	a4,800043ba <exec+0x290>
    800043a0:	0785                	addi	a5,a5,1
    if (*s == '/') last = s + 1;
    800043a2:	02f00693          	li	a3,47
    800043a6:	a039                	j	800043b4 <exec+0x28a>
    800043a8:	def43423          	sd	a5,-536(s0)
  for (last = s = path; *s; s++)
    800043ac:	0785                	addi	a5,a5,1
    800043ae:	fff7c703          	lbu	a4,-1(a5)
    800043b2:	c701                	beqz	a4,800043ba <exec+0x290>
    if (*s == '/') last = s + 1;
    800043b4:	fed71ce3          	bne	a4,a3,800043ac <exec+0x282>
    800043b8:	bfc5                	j	800043a8 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    800043ba:	4641                	li	a2,16
    800043bc:	de843583          	ld	a1,-536(s0)
    800043c0:	158b8513          	addi	a0,s7,344
    800043c4:	ffffc097          	auipc	ra,0xffffc
    800043c8:	f00080e7          	jalr	-256(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    800043cc:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800043d0:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800043d4:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800043d8:	058bb783          	ld	a5,88(s7)
    800043dc:	e6843703          	ld	a4,-408(s0)
    800043e0:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;          // initial stack pointer
    800043e2:	058bb783          	ld	a5,88(s7)
    800043e6:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043ea:	85ea                	mv	a1,s10
    800043ec:	ffffd097          	auipc	ra,0xffffd
    800043f0:	bc8080e7          	jalr	-1080(ra) # 80000fb4 <proc_freepagetable>
  return argc;  // this ends up in a0, the first argument to main(argc, argv)
    800043f4:	0004851b          	sext.w	a0,s1
    800043f8:	b3f9                	j	800041c6 <exec+0x9c>
    800043fa:	df243c23          	sd	s2,-520(s0)
  if (pagetable) proc_freepagetable(pagetable, sz);
    800043fe:	df843583          	ld	a1,-520(s0)
    80004402:	855a                	mv	a0,s6
    80004404:	ffffd097          	auipc	ra,0xffffd
    80004408:	bb0080e7          	jalr	-1104(ra) # 80000fb4 <proc_freepagetable>
  if (ip) {
    8000440c:	da0a93e3          	bnez	s5,800041b2 <exec+0x88>
  return -1;
    80004410:	557d                	li	a0,-1
    80004412:	bb55                	j	800041c6 <exec+0x9c>
    80004414:	df243c23          	sd	s2,-520(s0)
    80004418:	b7dd                	j	800043fe <exec+0x2d4>
    8000441a:	df243c23          	sd	s2,-520(s0)
    8000441e:	b7c5                	j	800043fe <exec+0x2d4>
    80004420:	df243c23          	sd	s2,-520(s0)
    80004424:	bfe9                	j	800043fe <exec+0x2d4>
    80004426:	df243c23          	sd	s2,-520(s0)
    8000442a:	bfd1                	j	800043fe <exec+0x2d4>
  sz = sz1;
    8000442c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004430:	4a81                	li	s5,0
    80004432:	b7f1                	j	800043fe <exec+0x2d4>
  sz = sz1;
    80004434:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004438:	4a81                	li	s5,0
    8000443a:	b7d1                	j	800043fe <exec+0x2d4>
  sz = sz1;
    8000443c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004440:	4a81                	li	s5,0
    80004442:	bf75                	j	800043fe <exec+0x2d4>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    80004444:	df843903          	ld	s2,-520(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004448:	e0843783          	ld	a5,-504(s0)
    8000444c:	0017869b          	addiw	a3,a5,1
    80004450:	e0d43423          	sd	a3,-504(s0)
    80004454:	e0043783          	ld	a5,-512(s0)
    80004458:	0387879b          	addiw	a5,a5,56
    8000445c:	e8845703          	lhu	a4,-376(s0)
    80004460:	e0e6dfe3          	bge	a3,a4,8000427e <exec+0x154>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph)) goto bad;
    80004464:	2781                	sext.w	a5,a5
    80004466:	e0f43023          	sd	a5,-512(s0)
    8000446a:	03800713          	li	a4,56
    8000446e:	86be                	mv	a3,a5
    80004470:	e1840613          	addi	a2,s0,-488
    80004474:	4581                	li	a1,0
    80004476:	8556                	mv	a0,s5
    80004478:	fffff097          	auipc	ra,0xfffff
    8000447c:	a58080e7          	jalr	-1448(ra) # 80002ed0 <readi>
    80004480:	03800793          	li	a5,56
    80004484:	f6f51be3          	bne	a0,a5,800043fa <exec+0x2d0>
    if (ph.type != ELF_PROG_LOAD) continue;
    80004488:	e1842783          	lw	a5,-488(s0)
    8000448c:	4705                	li	a4,1
    8000448e:	fae79de3          	bne	a5,a4,80004448 <exec+0x31e>
    if (ph.memsz < ph.filesz) goto bad;
    80004492:	e4043483          	ld	s1,-448(s0)
    80004496:	e3843783          	ld	a5,-456(s0)
    8000449a:	f6f4ede3          	bltu	s1,a5,80004414 <exec+0x2ea>
    if (ph.vaddr + ph.memsz < ph.vaddr) goto bad;
    8000449e:	e2843783          	ld	a5,-472(s0)
    800044a2:	94be                	add	s1,s1,a5
    800044a4:	f6f4ebe3          	bltu	s1,a5,8000441a <exec+0x2f0>
    if (ph.vaddr % PGSIZE != 0) goto bad;
    800044a8:	de043703          	ld	a4,-544(s0)
    800044ac:	8ff9                	and	a5,a5,a4
    800044ae:	fbad                	bnez	a5,80004420 <exec+0x2f6>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    800044b0:	e1c42503          	lw	a0,-484(s0)
    800044b4:	00000097          	auipc	ra,0x0
    800044b8:	c5c080e7          	jalr	-932(ra) # 80004110 <flags2perm>
    800044bc:	86aa                	mv	a3,a0
    800044be:	8626                	mv	a2,s1
    800044c0:	85ca                	mv	a1,s2
    800044c2:	855a                	mv	a0,s6
    800044c4:	ffffc097          	auipc	ra,0xffffc
    800044c8:	3f4080e7          	jalr	1012(ra) # 800008b8 <uvmalloc>
    800044cc:	dea43c23          	sd	a0,-520(s0)
    800044d0:	d939                	beqz	a0,80004426 <exec+0x2fc>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0) goto bad;
    800044d2:	e2843c03          	ld	s8,-472(s0)
    800044d6:	e2042c83          	lw	s9,-480(s0)
    800044da:	e3842b83          	lw	s7,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    800044de:	f60b83e3          	beqz	s7,80004444 <exec+0x31a>
    800044e2:	89de                	mv	s3,s7
    800044e4:	4481                	li	s1,0
    800044e6:	bb9d                	j	8000425c <exec+0x132>

00000000800044e8 <argfd>:
#include "file.h"
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int argfd(int n, int *pfd, struct file **pf) {
    800044e8:	7179                	addi	sp,sp,-48
    800044ea:	f406                	sd	ra,40(sp)
    800044ec:	f022                	sd	s0,32(sp)
    800044ee:	ec26                	sd	s1,24(sp)
    800044f0:	e84a                	sd	s2,16(sp)
    800044f2:	1800                	addi	s0,sp,48
    800044f4:	892e                	mv	s2,a1
    800044f6:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800044f8:	fdc40593          	addi	a1,s0,-36
    800044fc:	ffffe097          	auipc	ra,0xffffe
    80004500:	b4e080e7          	jalr	-1202(ra) # 8000204a <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
    80004504:	fdc42703          	lw	a4,-36(s0)
    80004508:	47bd                	li	a5,15
    8000450a:	02e7eb63          	bltu	a5,a4,80004540 <argfd+0x58>
    8000450e:	ffffd097          	auipc	ra,0xffffd
    80004512:	946080e7          	jalr	-1722(ra) # 80000e54 <myproc>
    80004516:	fdc42703          	lw	a4,-36(s0)
    8000451a:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdd2aa>
    8000451e:	078e                	slli	a5,a5,0x3
    80004520:	953e                	add	a0,a0,a5
    80004522:	611c                	ld	a5,0(a0)
    80004524:	c385                	beqz	a5,80004544 <argfd+0x5c>
  if (pfd) *pfd = fd;
    80004526:	00090463          	beqz	s2,8000452e <argfd+0x46>
    8000452a:	00e92023          	sw	a4,0(s2)
  if (pf) *pf = f;
  return 0;
    8000452e:	4501                	li	a0,0
  if (pf) *pf = f;
    80004530:	c091                	beqz	s1,80004534 <argfd+0x4c>
    80004532:	e09c                	sd	a5,0(s1)
}
    80004534:	70a2                	ld	ra,40(sp)
    80004536:	7402                	ld	s0,32(sp)
    80004538:	64e2                	ld	s1,24(sp)
    8000453a:	6942                	ld	s2,16(sp)
    8000453c:	6145                	addi	sp,sp,48
    8000453e:	8082                	ret
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
    80004540:	557d                	li	a0,-1
    80004542:	bfcd                	j	80004534 <argfd+0x4c>
    80004544:	557d                	li	a0,-1
    80004546:	b7fd                	j	80004534 <argfd+0x4c>

0000000080004548 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int fdalloc(struct file *f) {
    80004548:	1101                	addi	sp,sp,-32
    8000454a:	ec06                	sd	ra,24(sp)
    8000454c:	e822                	sd	s0,16(sp)
    8000454e:	e426                	sd	s1,8(sp)
    80004550:	1000                	addi	s0,sp,32
    80004552:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004554:	ffffd097          	auipc	ra,0xffffd
    80004558:	900080e7          	jalr	-1792(ra) # 80000e54 <myproc>
    8000455c:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    8000455e:	0d050793          	addi	a5,a0,208
    80004562:	4501                	li	a0,0
    80004564:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    80004566:	6398                	ld	a4,0(a5)
    80004568:	cb19                	beqz	a4,8000457e <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++) {
    8000456a:	2505                	addiw	a0,a0,1
    8000456c:	07a1                	addi	a5,a5,8
    8000456e:	fed51ce3          	bne	a0,a3,80004566 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004572:	557d                	li	a0,-1
}
    80004574:	60e2                	ld	ra,24(sp)
    80004576:	6442                	ld	s0,16(sp)
    80004578:	64a2                	ld	s1,8(sp)
    8000457a:	6105                	addi	sp,sp,32
    8000457c:	8082                	ret
      p->ofile[fd] = f;
    8000457e:	01a50793          	addi	a5,a0,26
    80004582:	078e                	slli	a5,a5,0x3
    80004584:	963e                	add	a2,a2,a5
    80004586:	e204                	sd	s1,0(a2)
      return fd;
    80004588:	b7f5                	j	80004574 <fdalloc+0x2c>

000000008000458a <create>:
  iunlockput(dp);
  end_op();
  return -1;
}

static struct inode *create(char *path, short type, short major, short minor) {
    8000458a:	715d                	addi	sp,sp,-80
    8000458c:	e486                	sd	ra,72(sp)
    8000458e:	e0a2                	sd	s0,64(sp)
    80004590:	fc26                	sd	s1,56(sp)
    80004592:	f84a                	sd	s2,48(sp)
    80004594:	f44e                	sd	s3,40(sp)
    80004596:	f052                	sd	s4,32(sp)
    80004598:	ec56                	sd	s5,24(sp)
    8000459a:	e85a                	sd	s6,16(sp)
    8000459c:	0880                	addi	s0,sp,80
    8000459e:	8b2e                	mv	s6,a1
    800045a0:	89b2                	mv	s3,a2
    800045a2:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0) return 0;
    800045a4:	fb040593          	addi	a1,s0,-80
    800045a8:	fffff097          	auipc	ra,0xfffff
    800045ac:	e3e080e7          	jalr	-450(ra) # 800033e6 <nameiparent>
    800045b0:	84aa                	mv	s1,a0
    800045b2:	14050f63          	beqz	a0,80004710 <create+0x186>

  ilock(dp);
    800045b6:	ffffe097          	auipc	ra,0xffffe
    800045ba:	666080e7          	jalr	1638(ra) # 80002c1c <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    800045be:	4601                	li	a2,0
    800045c0:	fb040593          	addi	a1,s0,-80
    800045c4:	8526                	mv	a0,s1
    800045c6:	fffff097          	auipc	ra,0xfffff
    800045ca:	b3a080e7          	jalr	-1222(ra) # 80003100 <dirlookup>
    800045ce:	8aaa                	mv	s5,a0
    800045d0:	c931                	beqz	a0,80004624 <create+0x9a>
    iunlockput(dp);
    800045d2:	8526                	mv	a0,s1
    800045d4:	fffff097          	auipc	ra,0xfffff
    800045d8:	8aa080e7          	jalr	-1878(ra) # 80002e7e <iunlockput>
    ilock(ip);
    800045dc:	8556                	mv	a0,s5
    800045de:	ffffe097          	auipc	ra,0xffffe
    800045e2:	63e080e7          	jalr	1598(ra) # 80002c1c <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800045e6:	000b059b          	sext.w	a1,s6
    800045ea:	4789                	li	a5,2
    800045ec:	02f59563          	bne	a1,a5,80004616 <create+0x8c>
    800045f0:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdd2d4>
    800045f4:	37f9                	addiw	a5,a5,-2
    800045f6:	17c2                	slli	a5,a5,0x30
    800045f8:	93c1                	srli	a5,a5,0x30
    800045fa:	4705                	li	a4,1
    800045fc:	00f76d63          	bltu	a4,a5,80004616 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004600:	8556                	mv	a0,s5
    80004602:	60a6                	ld	ra,72(sp)
    80004604:	6406                	ld	s0,64(sp)
    80004606:	74e2                	ld	s1,56(sp)
    80004608:	7942                	ld	s2,48(sp)
    8000460a:	79a2                	ld	s3,40(sp)
    8000460c:	7a02                	ld	s4,32(sp)
    8000460e:	6ae2                	ld	s5,24(sp)
    80004610:	6b42                	ld	s6,16(sp)
    80004612:	6161                	addi	sp,sp,80
    80004614:	8082                	ret
    iunlockput(ip);
    80004616:	8556                	mv	a0,s5
    80004618:	fffff097          	auipc	ra,0xfffff
    8000461c:	866080e7          	jalr	-1946(ra) # 80002e7e <iunlockput>
    return 0;
    80004620:	4a81                	li	s5,0
    80004622:	bff9                	j	80004600 <create+0x76>
  if ((ip = ialloc(dp->dev, type)) == 0) {
    80004624:	85da                	mv	a1,s6
    80004626:	4088                	lw	a0,0(s1)
    80004628:	ffffe097          	auipc	ra,0xffffe
    8000462c:	456080e7          	jalr	1110(ra) # 80002a7e <ialloc>
    80004630:	8a2a                	mv	s4,a0
    80004632:	c539                	beqz	a0,80004680 <create+0xf6>
  ilock(ip);
    80004634:	ffffe097          	auipc	ra,0xffffe
    80004638:	5e8080e7          	jalr	1512(ra) # 80002c1c <ilock>
  ip->major = major;
    8000463c:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004640:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004644:	4905                	li	s2,1
    80004646:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000464a:	8552                	mv	a0,s4
    8000464c:	ffffe097          	auipc	ra,0xffffe
    80004650:	504080e7          	jalr	1284(ra) # 80002b50 <iupdate>
  if (type == T_DIR) {  // Create . and .. entries.
    80004654:	000b059b          	sext.w	a1,s6
    80004658:	03258b63          	beq	a1,s2,8000468e <create+0x104>
  if (dirlink(dp, name, ip->inum) < 0) goto fail;
    8000465c:	004a2603          	lw	a2,4(s4)
    80004660:	fb040593          	addi	a1,s0,-80
    80004664:	8526                	mv	a0,s1
    80004666:	fffff097          	auipc	ra,0xfffff
    8000466a:	cb0080e7          	jalr	-848(ra) # 80003316 <dirlink>
    8000466e:	06054f63          	bltz	a0,800046ec <create+0x162>
  iunlockput(dp);
    80004672:	8526                	mv	a0,s1
    80004674:	fffff097          	auipc	ra,0xfffff
    80004678:	80a080e7          	jalr	-2038(ra) # 80002e7e <iunlockput>
  return ip;
    8000467c:	8ad2                	mv	s5,s4
    8000467e:	b749                	j	80004600 <create+0x76>
    iunlockput(dp);
    80004680:	8526                	mv	a0,s1
    80004682:	ffffe097          	auipc	ra,0xffffe
    80004686:	7fc080e7          	jalr	2044(ra) # 80002e7e <iunlockput>
    return 0;
    8000468a:	8ad2                	mv	s5,s4
    8000468c:	bf95                	j	80004600 <create+0x76>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000468e:	004a2603          	lw	a2,4(s4)
    80004692:	00004597          	auipc	a1,0x4
    80004696:	ffe58593          	addi	a1,a1,-2 # 80008690 <syscalls+0x2b0>
    8000469a:	8552                	mv	a0,s4
    8000469c:	fffff097          	auipc	ra,0xfffff
    800046a0:	c7a080e7          	jalr	-902(ra) # 80003316 <dirlink>
    800046a4:	04054463          	bltz	a0,800046ec <create+0x162>
    800046a8:	40d0                	lw	a2,4(s1)
    800046aa:	00004597          	auipc	a1,0x4
    800046ae:	fee58593          	addi	a1,a1,-18 # 80008698 <syscalls+0x2b8>
    800046b2:	8552                	mv	a0,s4
    800046b4:	fffff097          	auipc	ra,0xfffff
    800046b8:	c62080e7          	jalr	-926(ra) # 80003316 <dirlink>
    800046bc:	02054863          	bltz	a0,800046ec <create+0x162>
  if (dirlink(dp, name, ip->inum) < 0) goto fail;
    800046c0:	004a2603          	lw	a2,4(s4)
    800046c4:	fb040593          	addi	a1,s0,-80
    800046c8:	8526                	mv	a0,s1
    800046ca:	fffff097          	auipc	ra,0xfffff
    800046ce:	c4c080e7          	jalr	-948(ra) # 80003316 <dirlink>
    800046d2:	00054d63          	bltz	a0,800046ec <create+0x162>
    dp->nlink++;  // for ".."
    800046d6:	04a4d783          	lhu	a5,74(s1)
    800046da:	2785                	addiw	a5,a5,1
    800046dc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800046e0:	8526                	mv	a0,s1
    800046e2:	ffffe097          	auipc	ra,0xffffe
    800046e6:	46e080e7          	jalr	1134(ra) # 80002b50 <iupdate>
    800046ea:	b761                	j	80004672 <create+0xe8>
  ip->nlink = 0;
    800046ec:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800046f0:	8552                	mv	a0,s4
    800046f2:	ffffe097          	auipc	ra,0xffffe
    800046f6:	45e080e7          	jalr	1118(ra) # 80002b50 <iupdate>
  iunlockput(ip);
    800046fa:	8552                	mv	a0,s4
    800046fc:	ffffe097          	auipc	ra,0xffffe
    80004700:	782080e7          	jalr	1922(ra) # 80002e7e <iunlockput>
  iunlockput(dp);
    80004704:	8526                	mv	a0,s1
    80004706:	ffffe097          	auipc	ra,0xffffe
    8000470a:	778080e7          	jalr	1912(ra) # 80002e7e <iunlockput>
  return 0;
    8000470e:	bdcd                	j	80004600 <create+0x76>
  if ((dp = nameiparent(path, name)) == 0) return 0;
    80004710:	8aaa                	mv	s5,a0
    80004712:	b5fd                	j	80004600 <create+0x76>

0000000080004714 <sys_dup>:
uint64 sys_dup(void) {
    80004714:	7179                	addi	sp,sp,-48
    80004716:	f406                	sd	ra,40(sp)
    80004718:	f022                	sd	s0,32(sp)
    8000471a:	ec26                	sd	s1,24(sp)
    8000471c:	e84a                	sd	s2,16(sp)
    8000471e:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0) return -1;
    80004720:	fd840613          	addi	a2,s0,-40
    80004724:	4581                	li	a1,0
    80004726:	4501                	li	a0,0
    80004728:	00000097          	auipc	ra,0x0
    8000472c:	dc0080e7          	jalr	-576(ra) # 800044e8 <argfd>
    80004730:	57fd                	li	a5,-1
    80004732:	02054363          	bltz	a0,80004758 <sys_dup+0x44>
  if ((fd = fdalloc(f)) < 0) return -1;
    80004736:	fd843903          	ld	s2,-40(s0)
    8000473a:	854a                	mv	a0,s2
    8000473c:	00000097          	auipc	ra,0x0
    80004740:	e0c080e7          	jalr	-500(ra) # 80004548 <fdalloc>
    80004744:	84aa                	mv	s1,a0
    80004746:	57fd                	li	a5,-1
    80004748:	00054863          	bltz	a0,80004758 <sys_dup+0x44>
  filedup(f);
    8000474c:	854a                	mv	a0,s2
    8000474e:	fffff097          	auipc	ra,0xfffff
    80004752:	310080e7          	jalr	784(ra) # 80003a5e <filedup>
  return fd;
    80004756:	87a6                	mv	a5,s1
}
    80004758:	853e                	mv	a0,a5
    8000475a:	70a2                	ld	ra,40(sp)
    8000475c:	7402                	ld	s0,32(sp)
    8000475e:	64e2                	ld	s1,24(sp)
    80004760:	6942                	ld	s2,16(sp)
    80004762:	6145                	addi	sp,sp,48
    80004764:	8082                	ret

0000000080004766 <sys_read>:
uint64 sys_read(void) {
    80004766:	7179                	addi	sp,sp,-48
    80004768:	f406                	sd	ra,40(sp)
    8000476a:	f022                	sd	s0,32(sp)
    8000476c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000476e:	fd840593          	addi	a1,s0,-40
    80004772:	4505                	li	a0,1
    80004774:	ffffe097          	auipc	ra,0xffffe
    80004778:	8f6080e7          	jalr	-1802(ra) # 8000206a <argaddr>
  argint(2, &n);
    8000477c:	fe440593          	addi	a1,s0,-28
    80004780:	4509                	li	a0,2
    80004782:	ffffe097          	auipc	ra,0xffffe
    80004786:	8c8080e7          	jalr	-1848(ra) # 8000204a <argint>
  if (argfd(0, 0, &f) < 0) return -1;
    8000478a:	fe840613          	addi	a2,s0,-24
    8000478e:	4581                	li	a1,0
    80004790:	4501                	li	a0,0
    80004792:	00000097          	auipc	ra,0x0
    80004796:	d56080e7          	jalr	-682(ra) # 800044e8 <argfd>
    8000479a:	87aa                	mv	a5,a0
    8000479c:	557d                	li	a0,-1
    8000479e:	0007cc63          	bltz	a5,800047b6 <sys_read+0x50>
  return fileread(f, p, n);
    800047a2:	fe442603          	lw	a2,-28(s0)
    800047a6:	fd843583          	ld	a1,-40(s0)
    800047aa:	fe843503          	ld	a0,-24(s0)
    800047ae:	fffff097          	auipc	ra,0xfffff
    800047b2:	43c080e7          	jalr	1084(ra) # 80003bea <fileread>
}
    800047b6:	70a2                	ld	ra,40(sp)
    800047b8:	7402                	ld	s0,32(sp)
    800047ba:	6145                	addi	sp,sp,48
    800047bc:	8082                	ret

00000000800047be <sys_write>:
uint64 sys_write(void) {
    800047be:	7179                	addi	sp,sp,-48
    800047c0:	f406                	sd	ra,40(sp)
    800047c2:	f022                	sd	s0,32(sp)
    800047c4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800047c6:	fd840593          	addi	a1,s0,-40
    800047ca:	4505                	li	a0,1
    800047cc:	ffffe097          	auipc	ra,0xffffe
    800047d0:	89e080e7          	jalr	-1890(ra) # 8000206a <argaddr>
  argint(2, &n);
    800047d4:	fe440593          	addi	a1,s0,-28
    800047d8:	4509                	li	a0,2
    800047da:	ffffe097          	auipc	ra,0xffffe
    800047de:	870080e7          	jalr	-1936(ra) # 8000204a <argint>
  if (argfd(0, 0, &f) < 0) return -1;
    800047e2:	fe840613          	addi	a2,s0,-24
    800047e6:	4581                	li	a1,0
    800047e8:	4501                	li	a0,0
    800047ea:	00000097          	auipc	ra,0x0
    800047ee:	cfe080e7          	jalr	-770(ra) # 800044e8 <argfd>
    800047f2:	87aa                	mv	a5,a0
    800047f4:	557d                	li	a0,-1
    800047f6:	0007cc63          	bltz	a5,8000480e <sys_write+0x50>
  return filewrite(f, p, n);
    800047fa:	fe442603          	lw	a2,-28(s0)
    800047fe:	fd843583          	ld	a1,-40(s0)
    80004802:	fe843503          	ld	a0,-24(s0)
    80004806:	fffff097          	auipc	ra,0xfffff
    8000480a:	4a6080e7          	jalr	1190(ra) # 80003cac <filewrite>
}
    8000480e:	70a2                	ld	ra,40(sp)
    80004810:	7402                	ld	s0,32(sp)
    80004812:	6145                	addi	sp,sp,48
    80004814:	8082                	ret

0000000080004816 <sys_close>:
uint64 sys_close(void) {
    80004816:	1101                	addi	sp,sp,-32
    80004818:	ec06                	sd	ra,24(sp)
    8000481a:	e822                	sd	s0,16(sp)
    8000481c:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0) return -1;
    8000481e:	fe040613          	addi	a2,s0,-32
    80004822:	fec40593          	addi	a1,s0,-20
    80004826:	4501                	li	a0,0
    80004828:	00000097          	auipc	ra,0x0
    8000482c:	cc0080e7          	jalr	-832(ra) # 800044e8 <argfd>
    80004830:	57fd                	li	a5,-1
    80004832:	02054463          	bltz	a0,8000485a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004836:	ffffc097          	auipc	ra,0xffffc
    8000483a:	61e080e7          	jalr	1566(ra) # 80000e54 <myproc>
    8000483e:	fec42783          	lw	a5,-20(s0)
    80004842:	07e9                	addi	a5,a5,26
    80004844:	078e                	slli	a5,a5,0x3
    80004846:	953e                	add	a0,a0,a5
    80004848:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000484c:	fe043503          	ld	a0,-32(s0)
    80004850:	fffff097          	auipc	ra,0xfffff
    80004854:	260080e7          	jalr	608(ra) # 80003ab0 <fileclose>
  return 0;
    80004858:	4781                	li	a5,0
}
    8000485a:	853e                	mv	a0,a5
    8000485c:	60e2                	ld	ra,24(sp)
    8000485e:	6442                	ld	s0,16(sp)
    80004860:	6105                	addi	sp,sp,32
    80004862:	8082                	ret

0000000080004864 <sys_fstat>:
uint64 sys_fstat(void) {
    80004864:	1101                	addi	sp,sp,-32
    80004866:	ec06                	sd	ra,24(sp)
    80004868:	e822                	sd	s0,16(sp)
    8000486a:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000486c:	fe040593          	addi	a1,s0,-32
    80004870:	4505                	li	a0,1
    80004872:	ffffd097          	auipc	ra,0xffffd
    80004876:	7f8080e7          	jalr	2040(ra) # 8000206a <argaddr>
  if (argfd(0, 0, &f) < 0) return -1;
    8000487a:	fe840613          	addi	a2,s0,-24
    8000487e:	4581                	li	a1,0
    80004880:	4501                	li	a0,0
    80004882:	00000097          	auipc	ra,0x0
    80004886:	c66080e7          	jalr	-922(ra) # 800044e8 <argfd>
    8000488a:	87aa                	mv	a5,a0
    8000488c:	557d                	li	a0,-1
    8000488e:	0007ca63          	bltz	a5,800048a2 <sys_fstat+0x3e>
  return filestat(f, st);
    80004892:	fe043583          	ld	a1,-32(s0)
    80004896:	fe843503          	ld	a0,-24(s0)
    8000489a:	fffff097          	auipc	ra,0xfffff
    8000489e:	2de080e7          	jalr	734(ra) # 80003b78 <filestat>
}
    800048a2:	60e2                	ld	ra,24(sp)
    800048a4:	6442                	ld	s0,16(sp)
    800048a6:	6105                	addi	sp,sp,32
    800048a8:	8082                	ret

00000000800048aa <sys_link>:
uint64 sys_link(void) {
    800048aa:	7169                	addi	sp,sp,-304
    800048ac:	f606                	sd	ra,296(sp)
    800048ae:	f222                	sd	s0,288(sp)
    800048b0:	ee26                	sd	s1,280(sp)
    800048b2:	ea4a                	sd	s2,272(sp)
    800048b4:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0) return -1;
    800048b6:	08000613          	li	a2,128
    800048ba:	ed040593          	addi	a1,s0,-304
    800048be:	4501                	li	a0,0
    800048c0:	ffffd097          	auipc	ra,0xffffd
    800048c4:	7ca080e7          	jalr	1994(ra) # 8000208a <argstr>
    800048c8:	57fd                	li	a5,-1
    800048ca:	10054e63          	bltz	a0,800049e6 <sys_link+0x13c>
    800048ce:	08000613          	li	a2,128
    800048d2:	f5040593          	addi	a1,s0,-176
    800048d6:	4505                	li	a0,1
    800048d8:	ffffd097          	auipc	ra,0xffffd
    800048dc:	7b2080e7          	jalr	1970(ra) # 8000208a <argstr>
    800048e0:	57fd                	li	a5,-1
    800048e2:	10054263          	bltz	a0,800049e6 <sys_link+0x13c>
  begin_op();
    800048e6:	fffff097          	auipc	ra,0xfffff
    800048ea:	d02080e7          	jalr	-766(ra) # 800035e8 <begin_op>
  if ((ip = namei(old)) == 0) {
    800048ee:	ed040513          	addi	a0,s0,-304
    800048f2:	fffff097          	auipc	ra,0xfffff
    800048f6:	ad6080e7          	jalr	-1322(ra) # 800033c8 <namei>
    800048fa:	84aa                	mv	s1,a0
    800048fc:	c551                	beqz	a0,80004988 <sys_link+0xde>
  ilock(ip);
    800048fe:	ffffe097          	auipc	ra,0xffffe
    80004902:	31e080e7          	jalr	798(ra) # 80002c1c <ilock>
  if (ip->type == T_DIR) {
    80004906:	04449703          	lh	a4,68(s1)
    8000490a:	4785                	li	a5,1
    8000490c:	08f70463          	beq	a4,a5,80004994 <sys_link+0xea>
  ip->nlink++;
    80004910:	04a4d783          	lhu	a5,74(s1)
    80004914:	2785                	addiw	a5,a5,1
    80004916:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000491a:	8526                	mv	a0,s1
    8000491c:	ffffe097          	auipc	ra,0xffffe
    80004920:	234080e7          	jalr	564(ra) # 80002b50 <iupdate>
  iunlock(ip);
    80004924:	8526                	mv	a0,s1
    80004926:	ffffe097          	auipc	ra,0xffffe
    8000492a:	3b8080e7          	jalr	952(ra) # 80002cde <iunlock>
  if ((dp = nameiparent(new, name)) == 0) goto bad;
    8000492e:	fd040593          	addi	a1,s0,-48
    80004932:	f5040513          	addi	a0,s0,-176
    80004936:	fffff097          	auipc	ra,0xfffff
    8000493a:	ab0080e7          	jalr	-1360(ra) # 800033e6 <nameiparent>
    8000493e:	892a                	mv	s2,a0
    80004940:	c935                	beqz	a0,800049b4 <sys_link+0x10a>
  ilock(dp);
    80004942:	ffffe097          	auipc	ra,0xffffe
    80004946:	2da080e7          	jalr	730(ra) # 80002c1c <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    8000494a:	00092703          	lw	a4,0(s2)
    8000494e:	409c                	lw	a5,0(s1)
    80004950:	04f71d63          	bne	a4,a5,800049aa <sys_link+0x100>
    80004954:	40d0                	lw	a2,4(s1)
    80004956:	fd040593          	addi	a1,s0,-48
    8000495a:	854a                	mv	a0,s2
    8000495c:	fffff097          	auipc	ra,0xfffff
    80004960:	9ba080e7          	jalr	-1606(ra) # 80003316 <dirlink>
    80004964:	04054363          	bltz	a0,800049aa <sys_link+0x100>
  iunlockput(dp);
    80004968:	854a                	mv	a0,s2
    8000496a:	ffffe097          	auipc	ra,0xffffe
    8000496e:	514080e7          	jalr	1300(ra) # 80002e7e <iunlockput>
  iput(ip);
    80004972:	8526                	mv	a0,s1
    80004974:	ffffe097          	auipc	ra,0xffffe
    80004978:	462080e7          	jalr	1122(ra) # 80002dd6 <iput>
  end_op();
    8000497c:	fffff097          	auipc	ra,0xfffff
    80004980:	cea080e7          	jalr	-790(ra) # 80003666 <end_op>
  return 0;
    80004984:	4781                	li	a5,0
    80004986:	a085                	j	800049e6 <sys_link+0x13c>
    end_op();
    80004988:	fffff097          	auipc	ra,0xfffff
    8000498c:	cde080e7          	jalr	-802(ra) # 80003666 <end_op>
    return -1;
    80004990:	57fd                	li	a5,-1
    80004992:	a891                	j	800049e6 <sys_link+0x13c>
    iunlockput(ip);
    80004994:	8526                	mv	a0,s1
    80004996:	ffffe097          	auipc	ra,0xffffe
    8000499a:	4e8080e7          	jalr	1256(ra) # 80002e7e <iunlockput>
    end_op();
    8000499e:	fffff097          	auipc	ra,0xfffff
    800049a2:	cc8080e7          	jalr	-824(ra) # 80003666 <end_op>
    return -1;
    800049a6:	57fd                	li	a5,-1
    800049a8:	a83d                	j	800049e6 <sys_link+0x13c>
    iunlockput(dp);
    800049aa:	854a                	mv	a0,s2
    800049ac:	ffffe097          	auipc	ra,0xffffe
    800049b0:	4d2080e7          	jalr	1234(ra) # 80002e7e <iunlockput>
  ilock(ip);
    800049b4:	8526                	mv	a0,s1
    800049b6:	ffffe097          	auipc	ra,0xffffe
    800049ba:	266080e7          	jalr	614(ra) # 80002c1c <ilock>
  ip->nlink--;
    800049be:	04a4d783          	lhu	a5,74(s1)
    800049c2:	37fd                	addiw	a5,a5,-1
    800049c4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049c8:	8526                	mv	a0,s1
    800049ca:	ffffe097          	auipc	ra,0xffffe
    800049ce:	186080e7          	jalr	390(ra) # 80002b50 <iupdate>
  iunlockput(ip);
    800049d2:	8526                	mv	a0,s1
    800049d4:	ffffe097          	auipc	ra,0xffffe
    800049d8:	4aa080e7          	jalr	1194(ra) # 80002e7e <iunlockput>
  end_op();
    800049dc:	fffff097          	auipc	ra,0xfffff
    800049e0:	c8a080e7          	jalr	-886(ra) # 80003666 <end_op>
  return -1;
    800049e4:	57fd                	li	a5,-1
}
    800049e6:	853e                	mv	a0,a5
    800049e8:	70b2                	ld	ra,296(sp)
    800049ea:	7412                	ld	s0,288(sp)
    800049ec:	64f2                	ld	s1,280(sp)
    800049ee:	6952                	ld	s2,272(sp)
    800049f0:	6155                	addi	sp,sp,304
    800049f2:	8082                	ret

00000000800049f4 <sys_unlink>:
uint64 sys_unlink(void) {
    800049f4:	7151                	addi	sp,sp,-240
    800049f6:	f586                	sd	ra,232(sp)
    800049f8:	f1a2                	sd	s0,224(sp)
    800049fa:	eda6                	sd	s1,216(sp)
    800049fc:	e9ca                	sd	s2,208(sp)
    800049fe:	e5ce                	sd	s3,200(sp)
    80004a00:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0) return -1;
    80004a02:	08000613          	li	a2,128
    80004a06:	f3040593          	addi	a1,s0,-208
    80004a0a:	4501                	li	a0,0
    80004a0c:	ffffd097          	auipc	ra,0xffffd
    80004a10:	67e080e7          	jalr	1662(ra) # 8000208a <argstr>
    80004a14:	18054163          	bltz	a0,80004b96 <sys_unlink+0x1a2>
  begin_op();
    80004a18:	fffff097          	auipc	ra,0xfffff
    80004a1c:	bd0080e7          	jalr	-1072(ra) # 800035e8 <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    80004a20:	fb040593          	addi	a1,s0,-80
    80004a24:	f3040513          	addi	a0,s0,-208
    80004a28:	fffff097          	auipc	ra,0xfffff
    80004a2c:	9be080e7          	jalr	-1602(ra) # 800033e6 <nameiparent>
    80004a30:	84aa                	mv	s1,a0
    80004a32:	c979                	beqz	a0,80004b08 <sys_unlink+0x114>
  ilock(dp);
    80004a34:	ffffe097          	auipc	ra,0xffffe
    80004a38:	1e8080e7          	jalr	488(ra) # 80002c1c <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0) goto bad;
    80004a3c:	00004597          	auipc	a1,0x4
    80004a40:	c5458593          	addi	a1,a1,-940 # 80008690 <syscalls+0x2b0>
    80004a44:	fb040513          	addi	a0,s0,-80
    80004a48:	ffffe097          	auipc	ra,0xffffe
    80004a4c:	69e080e7          	jalr	1694(ra) # 800030e6 <namecmp>
    80004a50:	14050a63          	beqz	a0,80004ba4 <sys_unlink+0x1b0>
    80004a54:	00004597          	auipc	a1,0x4
    80004a58:	c4458593          	addi	a1,a1,-956 # 80008698 <syscalls+0x2b8>
    80004a5c:	fb040513          	addi	a0,s0,-80
    80004a60:	ffffe097          	auipc	ra,0xffffe
    80004a64:	686080e7          	jalr	1670(ra) # 800030e6 <namecmp>
    80004a68:	12050e63          	beqz	a0,80004ba4 <sys_unlink+0x1b0>
  if ((ip = dirlookup(dp, name, &off)) == 0) goto bad;
    80004a6c:	f2c40613          	addi	a2,s0,-212
    80004a70:	fb040593          	addi	a1,s0,-80
    80004a74:	8526                	mv	a0,s1
    80004a76:	ffffe097          	auipc	ra,0xffffe
    80004a7a:	68a080e7          	jalr	1674(ra) # 80003100 <dirlookup>
    80004a7e:	892a                	mv	s2,a0
    80004a80:	12050263          	beqz	a0,80004ba4 <sys_unlink+0x1b0>
  ilock(ip);
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	198080e7          	jalr	408(ra) # 80002c1c <ilock>
  if (ip->nlink < 1) panic("unlink: nlink < 1");
    80004a8c:	04a91783          	lh	a5,74(s2)
    80004a90:	08f05263          	blez	a5,80004b14 <sys_unlink+0x120>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80004a94:	04491703          	lh	a4,68(s2)
    80004a98:	4785                	li	a5,1
    80004a9a:	08f70563          	beq	a4,a5,80004b24 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a9e:	4641                	li	a2,16
    80004aa0:	4581                	li	a1,0
    80004aa2:	fc040513          	addi	a0,s0,-64
    80004aa6:	ffffb097          	auipc	ra,0xffffb
    80004aaa:	6d4080e7          	jalr	1748(ra) # 8000017a <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004aae:	4741                	li	a4,16
    80004ab0:	f2c42683          	lw	a3,-212(s0)
    80004ab4:	fc040613          	addi	a2,s0,-64
    80004ab8:	4581                	li	a1,0
    80004aba:	8526                	mv	a0,s1
    80004abc:	ffffe097          	auipc	ra,0xffffe
    80004ac0:	50c080e7          	jalr	1292(ra) # 80002fc8 <writei>
    80004ac4:	47c1                	li	a5,16
    80004ac6:	0af51563          	bne	a0,a5,80004b70 <sys_unlink+0x17c>
  if (ip->type == T_DIR) {
    80004aca:	04491703          	lh	a4,68(s2)
    80004ace:	4785                	li	a5,1
    80004ad0:	0af70863          	beq	a4,a5,80004b80 <sys_unlink+0x18c>
  iunlockput(dp);
    80004ad4:	8526                	mv	a0,s1
    80004ad6:	ffffe097          	auipc	ra,0xffffe
    80004ada:	3a8080e7          	jalr	936(ra) # 80002e7e <iunlockput>
  ip->nlink--;
    80004ade:	04a95783          	lhu	a5,74(s2)
    80004ae2:	37fd                	addiw	a5,a5,-1
    80004ae4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004ae8:	854a                	mv	a0,s2
    80004aea:	ffffe097          	auipc	ra,0xffffe
    80004aee:	066080e7          	jalr	102(ra) # 80002b50 <iupdate>
  iunlockput(ip);
    80004af2:	854a                	mv	a0,s2
    80004af4:	ffffe097          	auipc	ra,0xffffe
    80004af8:	38a080e7          	jalr	906(ra) # 80002e7e <iunlockput>
  end_op();
    80004afc:	fffff097          	auipc	ra,0xfffff
    80004b00:	b6a080e7          	jalr	-1174(ra) # 80003666 <end_op>
  return 0;
    80004b04:	4501                	li	a0,0
    80004b06:	a84d                	j	80004bb8 <sys_unlink+0x1c4>
    end_op();
    80004b08:	fffff097          	auipc	ra,0xfffff
    80004b0c:	b5e080e7          	jalr	-1186(ra) # 80003666 <end_op>
    return -1;
    80004b10:	557d                	li	a0,-1
    80004b12:	a05d                	j	80004bb8 <sys_unlink+0x1c4>
  if (ip->nlink < 1) panic("unlink: nlink < 1");
    80004b14:	00004517          	auipc	a0,0x4
    80004b18:	b8c50513          	addi	a0,a0,-1140 # 800086a0 <syscalls+0x2c0>
    80004b1c:	00001097          	auipc	ra,0x1
    80004b20:	1b0080e7          	jalr	432(ra) # 80005ccc <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004b24:	04c92703          	lw	a4,76(s2)
    80004b28:	02000793          	li	a5,32
    80004b2c:	f6e7f9e3          	bgeu	a5,a4,80004a9e <sys_unlink+0xaa>
    80004b30:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b34:	4741                	li	a4,16
    80004b36:	86ce                	mv	a3,s3
    80004b38:	f1840613          	addi	a2,s0,-232
    80004b3c:	4581                	li	a1,0
    80004b3e:	854a                	mv	a0,s2
    80004b40:	ffffe097          	auipc	ra,0xffffe
    80004b44:	390080e7          	jalr	912(ra) # 80002ed0 <readi>
    80004b48:	47c1                	li	a5,16
    80004b4a:	00f51b63          	bne	a0,a5,80004b60 <sys_unlink+0x16c>
    if (de.inum != 0) return 0;
    80004b4e:	f1845783          	lhu	a5,-232(s0)
    80004b52:	e7a1                	bnez	a5,80004b9a <sys_unlink+0x1a6>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004b54:	29c1                	addiw	s3,s3,16
    80004b56:	04c92783          	lw	a5,76(s2)
    80004b5a:	fcf9ede3          	bltu	s3,a5,80004b34 <sys_unlink+0x140>
    80004b5e:	b781                	j	80004a9e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b60:	00004517          	auipc	a0,0x4
    80004b64:	b5850513          	addi	a0,a0,-1192 # 800086b8 <syscalls+0x2d8>
    80004b68:	00001097          	auipc	ra,0x1
    80004b6c:	164080e7          	jalr	356(ra) # 80005ccc <panic>
    panic("unlink: writei");
    80004b70:	00004517          	auipc	a0,0x4
    80004b74:	b6050513          	addi	a0,a0,-1184 # 800086d0 <syscalls+0x2f0>
    80004b78:	00001097          	auipc	ra,0x1
    80004b7c:	154080e7          	jalr	340(ra) # 80005ccc <panic>
    dp->nlink--;
    80004b80:	04a4d783          	lhu	a5,74(s1)
    80004b84:	37fd                	addiw	a5,a5,-1
    80004b86:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b8a:	8526                	mv	a0,s1
    80004b8c:	ffffe097          	auipc	ra,0xffffe
    80004b90:	fc4080e7          	jalr	-60(ra) # 80002b50 <iupdate>
    80004b94:	b781                	j	80004ad4 <sys_unlink+0xe0>
  if (argstr(0, path, MAXPATH) < 0) return -1;
    80004b96:	557d                	li	a0,-1
    80004b98:	a005                	j	80004bb8 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b9a:	854a                	mv	a0,s2
    80004b9c:	ffffe097          	auipc	ra,0xffffe
    80004ba0:	2e2080e7          	jalr	738(ra) # 80002e7e <iunlockput>
  iunlockput(dp);
    80004ba4:	8526                	mv	a0,s1
    80004ba6:	ffffe097          	auipc	ra,0xffffe
    80004baa:	2d8080e7          	jalr	728(ra) # 80002e7e <iunlockput>
  end_op();
    80004bae:	fffff097          	auipc	ra,0xfffff
    80004bb2:	ab8080e7          	jalr	-1352(ra) # 80003666 <end_op>
  return -1;
    80004bb6:	557d                	li	a0,-1
}
    80004bb8:	70ae                	ld	ra,232(sp)
    80004bba:	740e                	ld	s0,224(sp)
    80004bbc:	64ee                	ld	s1,216(sp)
    80004bbe:	694e                	ld	s2,208(sp)
    80004bc0:	69ae                	ld	s3,200(sp)
    80004bc2:	616d                	addi	sp,sp,240
    80004bc4:	8082                	ret

0000000080004bc6 <sys_open>:

uint64 sys_open(void) {
    80004bc6:	7131                	addi	sp,sp,-192
    80004bc8:	fd06                	sd	ra,184(sp)
    80004bca:	f922                	sd	s0,176(sp)
    80004bcc:	f526                	sd	s1,168(sp)
    80004bce:	f14a                	sd	s2,160(sp)
    80004bd0:	ed4e                	sd	s3,152(sp)
    80004bd2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004bd4:	f4c40593          	addi	a1,s0,-180
    80004bd8:	4505                	li	a0,1
    80004bda:	ffffd097          	auipc	ra,0xffffd
    80004bde:	470080e7          	jalr	1136(ra) # 8000204a <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0) return -1;
    80004be2:	08000613          	li	a2,128
    80004be6:	f5040593          	addi	a1,s0,-176
    80004bea:	4501                	li	a0,0
    80004bec:	ffffd097          	auipc	ra,0xffffd
    80004bf0:	49e080e7          	jalr	1182(ra) # 8000208a <argstr>
    80004bf4:	87aa                	mv	a5,a0
    80004bf6:	557d                	li	a0,-1
    80004bf8:	0a07c963          	bltz	a5,80004caa <sys_open+0xe4>

  begin_op();
    80004bfc:	fffff097          	auipc	ra,0xfffff
    80004c00:	9ec080e7          	jalr	-1556(ra) # 800035e8 <begin_op>

  if (omode & O_CREATE) {
    80004c04:	f4c42783          	lw	a5,-180(s0)
    80004c08:	2007f793          	andi	a5,a5,512
    80004c0c:	cfc5                	beqz	a5,80004cc4 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c0e:	4681                	li	a3,0
    80004c10:	4601                	li	a2,0
    80004c12:	4589                	li	a1,2
    80004c14:	f5040513          	addi	a0,s0,-176
    80004c18:	00000097          	auipc	ra,0x0
    80004c1c:	972080e7          	jalr	-1678(ra) # 8000458a <create>
    80004c20:	84aa                	mv	s1,a0
    if (ip == 0) {
    80004c22:	c959                	beqz	a0,80004cb8 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80004c24:	04449703          	lh	a4,68(s1)
    80004c28:	478d                	li	a5,3
    80004c2a:	00f71763          	bne	a4,a5,80004c38 <sys_open+0x72>
    80004c2e:	0464d703          	lhu	a4,70(s1)
    80004c32:	47a5                	li	a5,9
    80004c34:	0ce7ed63          	bltu	a5,a4,80004d0e <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80004c38:	fffff097          	auipc	ra,0xfffff
    80004c3c:	dbc080e7          	jalr	-580(ra) # 800039f4 <filealloc>
    80004c40:	89aa                	mv	s3,a0
    80004c42:	10050363          	beqz	a0,80004d48 <sys_open+0x182>
    80004c46:	00000097          	auipc	ra,0x0
    80004c4a:	902080e7          	jalr	-1790(ra) # 80004548 <fdalloc>
    80004c4e:	892a                	mv	s2,a0
    80004c50:	0e054763          	bltz	a0,80004d3e <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    80004c54:	04449703          	lh	a4,68(s1)
    80004c58:	478d                	li	a5,3
    80004c5a:	0cf70563          	beq	a4,a5,80004d24 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c5e:	4789                	li	a5,2
    80004c60:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c64:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c68:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c6c:	f4c42783          	lw	a5,-180(s0)
    80004c70:	0017c713          	xori	a4,a5,1
    80004c74:	8b05                	andi	a4,a4,1
    80004c76:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c7a:	0037f713          	andi	a4,a5,3
    80004c7e:	00e03733          	snez	a4,a4
    80004c82:	00e984a3          	sb	a4,9(s3)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    80004c86:	4007f793          	andi	a5,a5,1024
    80004c8a:	c791                	beqz	a5,80004c96 <sys_open+0xd0>
    80004c8c:	04449703          	lh	a4,68(s1)
    80004c90:	4789                	li	a5,2
    80004c92:	0af70063          	beq	a4,a5,80004d32 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c96:	8526                	mv	a0,s1
    80004c98:	ffffe097          	auipc	ra,0xffffe
    80004c9c:	046080e7          	jalr	70(ra) # 80002cde <iunlock>
  end_op();
    80004ca0:	fffff097          	auipc	ra,0xfffff
    80004ca4:	9c6080e7          	jalr	-1594(ra) # 80003666 <end_op>

  return fd;
    80004ca8:	854a                	mv	a0,s2
}
    80004caa:	70ea                	ld	ra,184(sp)
    80004cac:	744a                	ld	s0,176(sp)
    80004cae:	74aa                	ld	s1,168(sp)
    80004cb0:	790a                	ld	s2,160(sp)
    80004cb2:	69ea                	ld	s3,152(sp)
    80004cb4:	6129                	addi	sp,sp,192
    80004cb6:	8082                	ret
      end_op();
    80004cb8:	fffff097          	auipc	ra,0xfffff
    80004cbc:	9ae080e7          	jalr	-1618(ra) # 80003666 <end_op>
      return -1;
    80004cc0:	557d                	li	a0,-1
    80004cc2:	b7e5                	j	80004caa <sys_open+0xe4>
    if ((ip = namei(path)) == 0) {
    80004cc4:	f5040513          	addi	a0,s0,-176
    80004cc8:	ffffe097          	auipc	ra,0xffffe
    80004ccc:	700080e7          	jalr	1792(ra) # 800033c8 <namei>
    80004cd0:	84aa                	mv	s1,a0
    80004cd2:	c905                	beqz	a0,80004d02 <sys_open+0x13c>
    ilock(ip);
    80004cd4:	ffffe097          	auipc	ra,0xffffe
    80004cd8:	f48080e7          	jalr	-184(ra) # 80002c1c <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    80004cdc:	04449703          	lh	a4,68(s1)
    80004ce0:	4785                	li	a5,1
    80004ce2:	f4f711e3          	bne	a4,a5,80004c24 <sys_open+0x5e>
    80004ce6:	f4c42783          	lw	a5,-180(s0)
    80004cea:	d7b9                	beqz	a5,80004c38 <sys_open+0x72>
      iunlockput(ip);
    80004cec:	8526                	mv	a0,s1
    80004cee:	ffffe097          	auipc	ra,0xffffe
    80004cf2:	190080e7          	jalr	400(ra) # 80002e7e <iunlockput>
      end_op();
    80004cf6:	fffff097          	auipc	ra,0xfffff
    80004cfa:	970080e7          	jalr	-1680(ra) # 80003666 <end_op>
      return -1;
    80004cfe:	557d                	li	a0,-1
    80004d00:	b76d                	j	80004caa <sys_open+0xe4>
      end_op();
    80004d02:	fffff097          	auipc	ra,0xfffff
    80004d06:	964080e7          	jalr	-1692(ra) # 80003666 <end_op>
      return -1;
    80004d0a:	557d                	li	a0,-1
    80004d0c:	bf79                	j	80004caa <sys_open+0xe4>
    iunlockput(ip);
    80004d0e:	8526                	mv	a0,s1
    80004d10:	ffffe097          	auipc	ra,0xffffe
    80004d14:	16e080e7          	jalr	366(ra) # 80002e7e <iunlockput>
    end_op();
    80004d18:	fffff097          	auipc	ra,0xfffff
    80004d1c:	94e080e7          	jalr	-1714(ra) # 80003666 <end_op>
    return -1;
    80004d20:	557d                	li	a0,-1
    80004d22:	b761                	j	80004caa <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004d24:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d28:	04649783          	lh	a5,70(s1)
    80004d2c:	02f99223          	sh	a5,36(s3)
    80004d30:	bf25                	j	80004c68 <sys_open+0xa2>
    itrunc(ip);
    80004d32:	8526                	mv	a0,s1
    80004d34:	ffffe097          	auipc	ra,0xffffe
    80004d38:	ff6080e7          	jalr	-10(ra) # 80002d2a <itrunc>
    80004d3c:	bfa9                	j	80004c96 <sys_open+0xd0>
    if (f) fileclose(f);
    80004d3e:	854e                	mv	a0,s3
    80004d40:	fffff097          	auipc	ra,0xfffff
    80004d44:	d70080e7          	jalr	-656(ra) # 80003ab0 <fileclose>
    iunlockput(ip);
    80004d48:	8526                	mv	a0,s1
    80004d4a:	ffffe097          	auipc	ra,0xffffe
    80004d4e:	134080e7          	jalr	308(ra) # 80002e7e <iunlockput>
    end_op();
    80004d52:	fffff097          	auipc	ra,0xfffff
    80004d56:	914080e7          	jalr	-1772(ra) # 80003666 <end_op>
    return -1;
    80004d5a:	557d                	li	a0,-1
    80004d5c:	b7b9                	j	80004caa <sys_open+0xe4>

0000000080004d5e <sys_mkdir>:

uint64 sys_mkdir(void) {
    80004d5e:	7175                	addi	sp,sp,-144
    80004d60:	e506                	sd	ra,136(sp)
    80004d62:	e122                	sd	s0,128(sp)
    80004d64:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d66:	fffff097          	auipc	ra,0xfffff
    80004d6a:	882080e7          	jalr	-1918(ra) # 800035e8 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80004d6e:	08000613          	li	a2,128
    80004d72:	f7040593          	addi	a1,s0,-144
    80004d76:	4501                	li	a0,0
    80004d78:	ffffd097          	auipc	ra,0xffffd
    80004d7c:	312080e7          	jalr	786(ra) # 8000208a <argstr>
    80004d80:	02054963          	bltz	a0,80004db2 <sys_mkdir+0x54>
    80004d84:	4681                	li	a3,0
    80004d86:	4601                	li	a2,0
    80004d88:	4585                	li	a1,1
    80004d8a:	f7040513          	addi	a0,s0,-144
    80004d8e:	fffff097          	auipc	ra,0xfffff
    80004d92:	7fc080e7          	jalr	2044(ra) # 8000458a <create>
    80004d96:	cd11                	beqz	a0,80004db2 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d98:	ffffe097          	auipc	ra,0xffffe
    80004d9c:	0e6080e7          	jalr	230(ra) # 80002e7e <iunlockput>
  end_op();
    80004da0:	fffff097          	auipc	ra,0xfffff
    80004da4:	8c6080e7          	jalr	-1850(ra) # 80003666 <end_op>
  return 0;
    80004da8:	4501                	li	a0,0
}
    80004daa:	60aa                	ld	ra,136(sp)
    80004dac:	640a                	ld	s0,128(sp)
    80004dae:	6149                	addi	sp,sp,144
    80004db0:	8082                	ret
    end_op();
    80004db2:	fffff097          	auipc	ra,0xfffff
    80004db6:	8b4080e7          	jalr	-1868(ra) # 80003666 <end_op>
    return -1;
    80004dba:	557d                	li	a0,-1
    80004dbc:	b7fd                	j	80004daa <sys_mkdir+0x4c>

0000000080004dbe <sys_mknod>:

uint64 sys_mknod(void) {
    80004dbe:	7135                	addi	sp,sp,-160
    80004dc0:	ed06                	sd	ra,152(sp)
    80004dc2:	e922                	sd	s0,144(sp)
    80004dc4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004dc6:	fffff097          	auipc	ra,0xfffff
    80004dca:	822080e7          	jalr	-2014(ra) # 800035e8 <begin_op>
  argint(1, &major);
    80004dce:	f6c40593          	addi	a1,s0,-148
    80004dd2:	4505                	li	a0,1
    80004dd4:	ffffd097          	auipc	ra,0xffffd
    80004dd8:	276080e7          	jalr	630(ra) # 8000204a <argint>
  argint(2, &minor);
    80004ddc:	f6840593          	addi	a1,s0,-152
    80004de0:	4509                	li	a0,2
    80004de2:	ffffd097          	auipc	ra,0xffffd
    80004de6:	268080e7          	jalr	616(ra) # 8000204a <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004dea:	08000613          	li	a2,128
    80004dee:	f7040593          	addi	a1,s0,-144
    80004df2:	4501                	li	a0,0
    80004df4:	ffffd097          	auipc	ra,0xffffd
    80004df8:	296080e7          	jalr	662(ra) # 8000208a <argstr>
    80004dfc:	02054b63          	bltz	a0,80004e32 <sys_mknod+0x74>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80004e00:	f6841683          	lh	a3,-152(s0)
    80004e04:	f6c41603          	lh	a2,-148(s0)
    80004e08:	458d                	li	a1,3
    80004e0a:	f7040513          	addi	a0,s0,-144
    80004e0e:	fffff097          	auipc	ra,0xfffff
    80004e12:	77c080e7          	jalr	1916(ra) # 8000458a <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004e16:	cd11                	beqz	a0,80004e32 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e18:	ffffe097          	auipc	ra,0xffffe
    80004e1c:	066080e7          	jalr	102(ra) # 80002e7e <iunlockput>
  end_op();
    80004e20:	fffff097          	auipc	ra,0xfffff
    80004e24:	846080e7          	jalr	-1978(ra) # 80003666 <end_op>
  return 0;
    80004e28:	4501                	li	a0,0
}
    80004e2a:	60ea                	ld	ra,152(sp)
    80004e2c:	644a                	ld	s0,144(sp)
    80004e2e:	610d                	addi	sp,sp,160
    80004e30:	8082                	ret
    end_op();
    80004e32:	fffff097          	auipc	ra,0xfffff
    80004e36:	834080e7          	jalr	-1996(ra) # 80003666 <end_op>
    return -1;
    80004e3a:	557d                	li	a0,-1
    80004e3c:	b7fd                	j	80004e2a <sys_mknod+0x6c>

0000000080004e3e <sys_chdir>:

uint64 sys_chdir(void) {
    80004e3e:	7135                	addi	sp,sp,-160
    80004e40:	ed06                	sd	ra,152(sp)
    80004e42:	e922                	sd	s0,144(sp)
    80004e44:	e526                	sd	s1,136(sp)
    80004e46:	e14a                	sd	s2,128(sp)
    80004e48:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e4a:	ffffc097          	auipc	ra,0xffffc
    80004e4e:	00a080e7          	jalr	10(ra) # 80000e54 <myproc>
    80004e52:	892a                	mv	s2,a0

  begin_op();
    80004e54:	ffffe097          	auipc	ra,0xffffe
    80004e58:	794080e7          	jalr	1940(ra) # 800035e8 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80004e5c:	08000613          	li	a2,128
    80004e60:	f6040593          	addi	a1,s0,-160
    80004e64:	4501                	li	a0,0
    80004e66:	ffffd097          	auipc	ra,0xffffd
    80004e6a:	224080e7          	jalr	548(ra) # 8000208a <argstr>
    80004e6e:	04054b63          	bltz	a0,80004ec4 <sys_chdir+0x86>
    80004e72:	f6040513          	addi	a0,s0,-160
    80004e76:	ffffe097          	auipc	ra,0xffffe
    80004e7a:	552080e7          	jalr	1362(ra) # 800033c8 <namei>
    80004e7e:	84aa                	mv	s1,a0
    80004e80:	c131                	beqz	a0,80004ec4 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e82:	ffffe097          	auipc	ra,0xffffe
    80004e86:	d9a080e7          	jalr	-614(ra) # 80002c1c <ilock>
  if (ip->type != T_DIR) {
    80004e8a:	04449703          	lh	a4,68(s1)
    80004e8e:	4785                	li	a5,1
    80004e90:	04f71063          	bne	a4,a5,80004ed0 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e94:	8526                	mv	a0,s1
    80004e96:	ffffe097          	auipc	ra,0xffffe
    80004e9a:	e48080e7          	jalr	-440(ra) # 80002cde <iunlock>
  iput(p->cwd);
    80004e9e:	15093503          	ld	a0,336(s2)
    80004ea2:	ffffe097          	auipc	ra,0xffffe
    80004ea6:	f34080e7          	jalr	-204(ra) # 80002dd6 <iput>
  end_op();
    80004eaa:	ffffe097          	auipc	ra,0xffffe
    80004eae:	7bc080e7          	jalr	1980(ra) # 80003666 <end_op>
  p->cwd = ip;
    80004eb2:	14993823          	sd	s1,336(s2)
  return 0;
    80004eb6:	4501                	li	a0,0
}
    80004eb8:	60ea                	ld	ra,152(sp)
    80004eba:	644a                	ld	s0,144(sp)
    80004ebc:	64aa                	ld	s1,136(sp)
    80004ebe:	690a                	ld	s2,128(sp)
    80004ec0:	610d                	addi	sp,sp,160
    80004ec2:	8082                	ret
    end_op();
    80004ec4:	ffffe097          	auipc	ra,0xffffe
    80004ec8:	7a2080e7          	jalr	1954(ra) # 80003666 <end_op>
    return -1;
    80004ecc:	557d                	li	a0,-1
    80004ece:	b7ed                	j	80004eb8 <sys_chdir+0x7a>
    iunlockput(ip);
    80004ed0:	8526                	mv	a0,s1
    80004ed2:	ffffe097          	auipc	ra,0xffffe
    80004ed6:	fac080e7          	jalr	-84(ra) # 80002e7e <iunlockput>
    end_op();
    80004eda:	ffffe097          	auipc	ra,0xffffe
    80004ede:	78c080e7          	jalr	1932(ra) # 80003666 <end_op>
    return -1;
    80004ee2:	557d                	li	a0,-1
    80004ee4:	bfd1                	j	80004eb8 <sys_chdir+0x7a>

0000000080004ee6 <sys_exec>:

uint64 sys_exec(void) {
    80004ee6:	7145                	addi	sp,sp,-464
    80004ee8:	e786                	sd	ra,456(sp)
    80004eea:	e3a2                	sd	s0,448(sp)
    80004eec:	ff26                	sd	s1,440(sp)
    80004eee:	fb4a                	sd	s2,432(sp)
    80004ef0:	f74e                	sd	s3,424(sp)
    80004ef2:	f352                	sd	s4,416(sp)
    80004ef4:	ef56                	sd	s5,408(sp)
    80004ef6:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004ef8:	e3840593          	addi	a1,s0,-456
    80004efc:	4505                	li	a0,1
    80004efe:	ffffd097          	auipc	ra,0xffffd
    80004f02:	16c080e7          	jalr	364(ra) # 8000206a <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    80004f06:	08000613          	li	a2,128
    80004f0a:	f4040593          	addi	a1,s0,-192
    80004f0e:	4501                	li	a0,0
    80004f10:	ffffd097          	auipc	ra,0xffffd
    80004f14:	17a080e7          	jalr	378(ra) # 8000208a <argstr>
    80004f18:	87aa                	mv	a5,a0
    return -1;
    80004f1a:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0) {
    80004f1c:	0c07c363          	bltz	a5,80004fe2 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004f20:	10000613          	li	a2,256
    80004f24:	4581                	li	a1,0
    80004f26:	e4040513          	addi	a0,s0,-448
    80004f2a:	ffffb097          	auipc	ra,0xffffb
    80004f2e:	250080e7          	jalr	592(ra) # 8000017a <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    80004f32:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f36:	89a6                	mv	s3,s1
    80004f38:	4901                	li	s2,0
    if (i >= NELEM(argv)) {
    80004f3a:	02000a13          	li	s4,32
    80004f3e:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80004f42:	00391513          	slli	a0,s2,0x3
    80004f46:	e3040593          	addi	a1,s0,-464
    80004f4a:	e3843783          	ld	a5,-456(s0)
    80004f4e:	953e                	add	a0,a0,a5
    80004f50:	ffffd097          	auipc	ra,0xffffd
    80004f54:	05c080e7          	jalr	92(ra) # 80001fac <fetchaddr>
    80004f58:	02054a63          	bltz	a0,80004f8c <sys_exec+0xa6>
      goto bad;
    }
    if (uarg == 0) {
    80004f5c:	e3043783          	ld	a5,-464(s0)
    80004f60:	c3b9                	beqz	a5,80004fa6 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f62:	ffffb097          	auipc	ra,0xffffb
    80004f66:	1b8080e7          	jalr	440(ra) # 8000011a <kalloc>
    80004f6a:	85aa                	mv	a1,a0
    80004f6c:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0) goto bad;
    80004f70:	cd11                	beqz	a0,80004f8c <sys_exec+0xa6>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0) goto bad;
    80004f72:	6605                	lui	a2,0x1
    80004f74:	e3043503          	ld	a0,-464(s0)
    80004f78:	ffffd097          	auipc	ra,0xffffd
    80004f7c:	086080e7          	jalr	134(ra) # 80001ffe <fetchstr>
    80004f80:	00054663          	bltz	a0,80004f8c <sys_exec+0xa6>
    if (i >= NELEM(argv)) {
    80004f84:	0905                	addi	s2,s2,1
    80004f86:	09a1                	addi	s3,s3,8
    80004f88:	fb491be3          	bne	s2,s4,80004f3e <sys_exec+0x58>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);
    80004f8c:	f4040913          	addi	s2,s0,-192
    80004f90:	6088                	ld	a0,0(s1)
    80004f92:	c539                	beqz	a0,80004fe0 <sys_exec+0xfa>
    80004f94:	ffffb097          	auipc	ra,0xffffb
    80004f98:	088080e7          	jalr	136(ra) # 8000001c <kfree>
    80004f9c:	04a1                	addi	s1,s1,8
    80004f9e:	ff2499e3          	bne	s1,s2,80004f90 <sys_exec+0xaa>
  return -1;
    80004fa2:	557d                	li	a0,-1
    80004fa4:	a83d                	j	80004fe2 <sys_exec+0xfc>
      argv[i] = 0;
    80004fa6:	0a8e                	slli	s5,s5,0x3
    80004fa8:	fc0a8793          	addi	a5,s5,-64
    80004fac:	00878ab3          	add	s5,a5,s0
    80004fb0:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004fb4:	e4040593          	addi	a1,s0,-448
    80004fb8:	f4040513          	addi	a0,s0,-192
    80004fbc:	fffff097          	auipc	ra,0xfffff
    80004fc0:	16e080e7          	jalr	366(ra) # 8000412a <exec>
    80004fc4:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);
    80004fc6:	f4040993          	addi	s3,s0,-192
    80004fca:	6088                	ld	a0,0(s1)
    80004fcc:	c901                	beqz	a0,80004fdc <sys_exec+0xf6>
    80004fce:	ffffb097          	auipc	ra,0xffffb
    80004fd2:	04e080e7          	jalr	78(ra) # 8000001c <kfree>
    80004fd6:	04a1                	addi	s1,s1,8
    80004fd8:	ff3499e3          	bne	s1,s3,80004fca <sys_exec+0xe4>
  return ret;
    80004fdc:	854a                	mv	a0,s2
    80004fde:	a011                	j	80004fe2 <sys_exec+0xfc>
  return -1;
    80004fe0:	557d                	li	a0,-1
}
    80004fe2:	60be                	ld	ra,456(sp)
    80004fe4:	641e                	ld	s0,448(sp)
    80004fe6:	74fa                	ld	s1,440(sp)
    80004fe8:	795a                	ld	s2,432(sp)
    80004fea:	79ba                	ld	s3,424(sp)
    80004fec:	7a1a                	ld	s4,416(sp)
    80004fee:	6afa                	ld	s5,408(sp)
    80004ff0:	6179                	addi	sp,sp,464
    80004ff2:	8082                	ret

0000000080004ff4 <sys_pipe>:

uint64 sys_pipe(void) {
    80004ff4:	7139                	addi	sp,sp,-64
    80004ff6:	fc06                	sd	ra,56(sp)
    80004ff8:	f822                	sd	s0,48(sp)
    80004ffa:	f426                	sd	s1,40(sp)
    80004ffc:	0080                	addi	s0,sp,64
  uint64 fdarray;  // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004ffe:	ffffc097          	auipc	ra,0xffffc
    80005002:	e56080e7          	jalr	-426(ra) # 80000e54 <myproc>
    80005006:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005008:	fd840593          	addi	a1,s0,-40
    8000500c:	4501                	li	a0,0
    8000500e:	ffffd097          	auipc	ra,0xffffd
    80005012:	05c080e7          	jalr	92(ra) # 8000206a <argaddr>
  if (pipealloc(&rf, &wf) < 0) return -1;
    80005016:	fc840593          	addi	a1,s0,-56
    8000501a:	fd040513          	addi	a0,s0,-48
    8000501e:	fffff097          	auipc	ra,0xfffff
    80005022:	dc2080e7          	jalr	-574(ra) # 80003de0 <pipealloc>
    80005026:	57fd                	li	a5,-1
    80005028:	0c054463          	bltz	a0,800050f0 <sys_pipe+0xfc>
  fd0 = -1;
    8000502c:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    80005030:	fd043503          	ld	a0,-48(s0)
    80005034:	fffff097          	auipc	ra,0xfffff
    80005038:	514080e7          	jalr	1300(ra) # 80004548 <fdalloc>
    8000503c:	fca42223          	sw	a0,-60(s0)
    80005040:	08054b63          	bltz	a0,800050d6 <sys_pipe+0xe2>
    80005044:	fc843503          	ld	a0,-56(s0)
    80005048:	fffff097          	auipc	ra,0xfffff
    8000504c:	500080e7          	jalr	1280(ra) # 80004548 <fdalloc>
    80005050:	fca42023          	sw	a0,-64(s0)
    80005054:	06054863          	bltz	a0,800050c4 <sys_pipe+0xd0>
    if (fd0 >= 0) p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005058:	4691                	li	a3,4
    8000505a:	fc440613          	addi	a2,s0,-60
    8000505e:	fd843583          	ld	a1,-40(s0)
    80005062:	68a8                	ld	a0,80(s1)
    80005064:	ffffc097          	auipc	ra,0xffffc
    80005068:	ab0080e7          	jalr	-1360(ra) # 80000b14 <copyout>
    8000506c:	02054063          	bltz	a0,8000508c <sys_pipe+0x98>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) <
    80005070:	4691                	li	a3,4
    80005072:	fc040613          	addi	a2,s0,-64
    80005076:	fd843583          	ld	a1,-40(s0)
    8000507a:	0591                	addi	a1,a1,4
    8000507c:	68a8                	ld	a0,80(s1)
    8000507e:	ffffc097          	auipc	ra,0xffffc
    80005082:	a96080e7          	jalr	-1386(ra) # 80000b14 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005086:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005088:	06055463          	bgez	a0,800050f0 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    8000508c:	fc442783          	lw	a5,-60(s0)
    80005090:	07e9                	addi	a5,a5,26
    80005092:	078e                	slli	a5,a5,0x3
    80005094:	97a6                	add	a5,a5,s1
    80005096:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000509a:	fc042783          	lw	a5,-64(s0)
    8000509e:	07e9                	addi	a5,a5,26
    800050a0:	078e                	slli	a5,a5,0x3
    800050a2:	94be                	add	s1,s1,a5
    800050a4:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800050a8:	fd043503          	ld	a0,-48(s0)
    800050ac:	fffff097          	auipc	ra,0xfffff
    800050b0:	a04080e7          	jalr	-1532(ra) # 80003ab0 <fileclose>
    fileclose(wf);
    800050b4:	fc843503          	ld	a0,-56(s0)
    800050b8:	fffff097          	auipc	ra,0xfffff
    800050bc:	9f8080e7          	jalr	-1544(ra) # 80003ab0 <fileclose>
    return -1;
    800050c0:	57fd                	li	a5,-1
    800050c2:	a03d                	j	800050f0 <sys_pipe+0xfc>
    if (fd0 >= 0) p->ofile[fd0] = 0;
    800050c4:	fc442783          	lw	a5,-60(s0)
    800050c8:	0007c763          	bltz	a5,800050d6 <sys_pipe+0xe2>
    800050cc:	07e9                	addi	a5,a5,26
    800050ce:	078e                	slli	a5,a5,0x3
    800050d0:	97a6                	add	a5,a5,s1
    800050d2:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800050d6:	fd043503          	ld	a0,-48(s0)
    800050da:	fffff097          	auipc	ra,0xfffff
    800050de:	9d6080e7          	jalr	-1578(ra) # 80003ab0 <fileclose>
    fileclose(wf);
    800050e2:	fc843503          	ld	a0,-56(s0)
    800050e6:	fffff097          	auipc	ra,0xfffff
    800050ea:	9ca080e7          	jalr	-1590(ra) # 80003ab0 <fileclose>
    return -1;
    800050ee:	57fd                	li	a5,-1
}
    800050f0:	853e                	mv	a0,a5
    800050f2:	70e2                	ld	ra,56(sp)
    800050f4:	7442                	ld	s0,48(sp)
    800050f6:	74a2                	ld	s1,40(sp)
    800050f8:	6121                	addi	sp,sp,64
    800050fa:	8082                	ret
    800050fc:	0000                	unimp
	...

0000000080005100 <kernelvec>:
    80005100:	7111                	addi	sp,sp,-256
    80005102:	e006                	sd	ra,0(sp)
    80005104:	e40a                	sd	sp,8(sp)
    80005106:	e80e                	sd	gp,16(sp)
    80005108:	ec12                	sd	tp,24(sp)
    8000510a:	f016                	sd	t0,32(sp)
    8000510c:	f41a                	sd	t1,40(sp)
    8000510e:	f81e                	sd	t2,48(sp)
    80005110:	fc22                	sd	s0,56(sp)
    80005112:	e0a6                	sd	s1,64(sp)
    80005114:	e4aa                	sd	a0,72(sp)
    80005116:	e8ae                	sd	a1,80(sp)
    80005118:	ecb2                	sd	a2,88(sp)
    8000511a:	f0b6                	sd	a3,96(sp)
    8000511c:	f4ba                	sd	a4,104(sp)
    8000511e:	f8be                	sd	a5,112(sp)
    80005120:	fcc2                	sd	a6,120(sp)
    80005122:	e146                	sd	a7,128(sp)
    80005124:	e54a                	sd	s2,136(sp)
    80005126:	e94e                	sd	s3,144(sp)
    80005128:	ed52                	sd	s4,152(sp)
    8000512a:	f156                	sd	s5,160(sp)
    8000512c:	f55a                	sd	s6,168(sp)
    8000512e:	f95e                	sd	s7,176(sp)
    80005130:	fd62                	sd	s8,184(sp)
    80005132:	e1e6                	sd	s9,192(sp)
    80005134:	e5ea                	sd	s10,200(sp)
    80005136:	e9ee                	sd	s11,208(sp)
    80005138:	edf2                	sd	t3,216(sp)
    8000513a:	f1f6                	sd	t4,224(sp)
    8000513c:	f5fa                	sd	t5,232(sp)
    8000513e:	f9fe                	sd	t6,240(sp)
    80005140:	d39fc0ef          	jal	ra,80001e78 <kerneltrap>
    80005144:	6082                	ld	ra,0(sp)
    80005146:	6122                	ld	sp,8(sp)
    80005148:	61c2                	ld	gp,16(sp)
    8000514a:	7282                	ld	t0,32(sp)
    8000514c:	7322                	ld	t1,40(sp)
    8000514e:	73c2                	ld	t2,48(sp)
    80005150:	7462                	ld	s0,56(sp)
    80005152:	6486                	ld	s1,64(sp)
    80005154:	6526                	ld	a0,72(sp)
    80005156:	65c6                	ld	a1,80(sp)
    80005158:	6666                	ld	a2,88(sp)
    8000515a:	7686                	ld	a3,96(sp)
    8000515c:	7726                	ld	a4,104(sp)
    8000515e:	77c6                	ld	a5,112(sp)
    80005160:	7866                	ld	a6,120(sp)
    80005162:	688a                	ld	a7,128(sp)
    80005164:	692a                	ld	s2,136(sp)
    80005166:	69ca                	ld	s3,144(sp)
    80005168:	6a6a                	ld	s4,152(sp)
    8000516a:	7a8a                	ld	s5,160(sp)
    8000516c:	7b2a                	ld	s6,168(sp)
    8000516e:	7bca                	ld	s7,176(sp)
    80005170:	7c6a                	ld	s8,184(sp)
    80005172:	6c8e                	ld	s9,192(sp)
    80005174:	6d2e                	ld	s10,200(sp)
    80005176:	6dce                	ld	s11,208(sp)
    80005178:	6e6e                	ld	t3,216(sp)
    8000517a:	7e8e                	ld	t4,224(sp)
    8000517c:	7f2e                	ld	t5,232(sp)
    8000517e:	7fce                	ld	t6,240(sp)
    80005180:	6111                	addi	sp,sp,256
    80005182:	10200073          	sret
    80005186:	00000013          	nop
    8000518a:	00000013          	nop
    8000518e:	0001                	nop

0000000080005190 <timervec>:
    80005190:	34051573          	csrrw	a0,mscratch,a0
    80005194:	e10c                	sd	a1,0(a0)
    80005196:	e510                	sd	a2,8(a0)
    80005198:	e914                	sd	a3,16(a0)
    8000519a:	6d0c                	ld	a1,24(a0)
    8000519c:	7110                	ld	a2,32(a0)
    8000519e:	6194                	ld	a3,0(a1)
    800051a0:	96b2                	add	a3,a3,a2
    800051a2:	e194                	sd	a3,0(a1)
    800051a4:	4589                	li	a1,2
    800051a6:	14459073          	csrw	sip,a1
    800051aa:	6914                	ld	a3,16(a0)
    800051ac:	6510                	ld	a2,8(a0)
    800051ae:	610c                	ld	a1,0(a0)
    800051b0:	34051573          	csrrw	a0,mscratch,a0
    800051b4:	30200073          	mret
	...

00000000800051ba <plicinit>:

//
// the riscv Platform Level Interrupt Controller (PLIC).
//

void plicinit(void) {
    800051ba:	1141                	addi	sp,sp,-16
    800051bc:	e422                	sd	s0,8(sp)
    800051be:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ * 4) = 1;
    800051c0:	0c0007b7          	lui	a5,0xc000
    800051c4:	4705                	li	a4,1
    800051c6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ * 4) = 1;
    800051c8:	c3d8                	sw	a4,4(a5)
}
    800051ca:	6422                	ld	s0,8(sp)
    800051cc:	0141                	addi	sp,sp,16
    800051ce:	8082                	ret

00000000800051d0 <plicinithart>:

void plicinithart(void) {
    800051d0:	1141                	addi	sp,sp,-16
    800051d2:	e406                	sd	ra,8(sp)
    800051d4:	e022                	sd	s0,0(sp)
    800051d6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051d8:	ffffc097          	auipc	ra,0xffffc
    800051dc:	c50080e7          	jalr	-944(ra) # 80000e28 <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800051e0:	0085171b          	slliw	a4,a0,0x8
    800051e4:	0c0027b7          	lui	a5,0xc002
    800051e8:	97ba                	add	a5,a5,a4
    800051ea:	40200713          	li	a4,1026
    800051ee:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800051f2:	00d5151b          	slliw	a0,a0,0xd
    800051f6:	0c2017b7          	lui	a5,0xc201
    800051fa:	97aa                	add	a5,a5,a0
    800051fc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005200:	60a2                	ld	ra,8(sp)
    80005202:	6402                	ld	s0,0(sp)
    80005204:	0141                	addi	sp,sp,16
    80005206:	8082                	ret

0000000080005208 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int plic_claim(void) {
    80005208:	1141                	addi	sp,sp,-16
    8000520a:	e406                	sd	ra,8(sp)
    8000520c:	e022                	sd	s0,0(sp)
    8000520e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005210:	ffffc097          	auipc	ra,0xffffc
    80005214:	c18080e7          	jalr	-1000(ra) # 80000e28 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005218:	00d5151b          	slliw	a0,a0,0xd
    8000521c:	0c2017b7          	lui	a5,0xc201
    80005220:	97aa                	add	a5,a5,a0
  return irq;
}
    80005222:	43c8                	lw	a0,4(a5)
    80005224:	60a2                	ld	ra,8(sp)
    80005226:	6402                	ld	s0,0(sp)
    80005228:	0141                	addi	sp,sp,16
    8000522a:	8082                	ret

000000008000522c <plic_complete>:

// tell the PLIC we've served this IRQ.
void plic_complete(int irq) {
    8000522c:	1101                	addi	sp,sp,-32
    8000522e:	ec06                	sd	ra,24(sp)
    80005230:	e822                	sd	s0,16(sp)
    80005232:	e426                	sd	s1,8(sp)
    80005234:	1000                	addi	s0,sp,32
    80005236:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005238:	ffffc097          	auipc	ra,0xffffc
    8000523c:	bf0080e7          	jalr	-1040(ra) # 80000e28 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005240:	00d5151b          	slliw	a0,a0,0xd
    80005244:	0c2017b7          	lui	a5,0xc201
    80005248:	97aa                	add	a5,a5,a0
    8000524a:	c3c4                	sw	s1,4(a5)
}
    8000524c:	60e2                	ld	ra,24(sp)
    8000524e:	6442                	ld	s0,16(sp)
    80005250:	64a2                	ld	s1,8(sp)
    80005252:	6105                	addi	sp,sp,32
    80005254:	8082                	ret

0000000080005256 <free_desc>:
  }
  return -1;
}

// mark a descriptor as free.
static void free_desc(int i) {
    80005256:	1141                	addi	sp,sp,-16
    80005258:	e406                	sd	ra,8(sp)
    8000525a:	e022                	sd	s0,0(sp)
    8000525c:	0800                	addi	s0,sp,16
  if (i >= NUM) panic("free_desc 1");
    8000525e:	479d                	li	a5,7
    80005260:	04a7cc63          	blt	a5,a0,800052b8 <free_desc+0x62>
  if (disk.free[i]) panic("free_desc 2");
    80005264:	00014797          	auipc	a5,0x14
    80005268:	78c78793          	addi	a5,a5,1932 # 800199f0 <disk>
    8000526c:	97aa                	add	a5,a5,a0
    8000526e:	0187c783          	lbu	a5,24(a5)
    80005272:	ebb9                	bnez	a5,800052c8 <free_desc+0x72>
  disk.desc[i].addr = 0;
    80005274:	00451693          	slli	a3,a0,0x4
    80005278:	00014797          	auipc	a5,0x14
    8000527c:	77878793          	addi	a5,a5,1912 # 800199f0 <disk>
    80005280:	6398                	ld	a4,0(a5)
    80005282:	9736                	add	a4,a4,a3
    80005284:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005288:	6398                	ld	a4,0(a5)
    8000528a:	9736                	add	a4,a4,a3
    8000528c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005290:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005294:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005298:	97aa                	add	a5,a5,a0
    8000529a:	4705                	li	a4,1
    8000529c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800052a0:	00014517          	auipc	a0,0x14
    800052a4:	76850513          	addi	a0,a0,1896 # 80019a08 <disk+0x18>
    800052a8:	ffffc097          	auipc	ra,0xffffc
    800052ac:	2b8080e7          	jalr	696(ra) # 80001560 <wakeup>
}
    800052b0:	60a2                	ld	ra,8(sp)
    800052b2:	6402                	ld	s0,0(sp)
    800052b4:	0141                	addi	sp,sp,16
    800052b6:	8082                	ret
  if (i >= NUM) panic("free_desc 1");
    800052b8:	00003517          	auipc	a0,0x3
    800052bc:	42850513          	addi	a0,a0,1064 # 800086e0 <syscalls+0x300>
    800052c0:	00001097          	auipc	ra,0x1
    800052c4:	a0c080e7          	jalr	-1524(ra) # 80005ccc <panic>
  if (disk.free[i]) panic("free_desc 2");
    800052c8:	00003517          	auipc	a0,0x3
    800052cc:	42850513          	addi	a0,a0,1064 # 800086f0 <syscalls+0x310>
    800052d0:	00001097          	auipc	ra,0x1
    800052d4:	9fc080e7          	jalr	-1540(ra) # 80005ccc <panic>

00000000800052d8 <virtio_disk_init>:
void virtio_disk_init(void) {
    800052d8:	1101                	addi	sp,sp,-32
    800052da:	ec06                	sd	ra,24(sp)
    800052dc:	e822                	sd	s0,16(sp)
    800052de:	e426                	sd	s1,8(sp)
    800052e0:	e04a                	sd	s2,0(sp)
    800052e2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052e4:	00003597          	auipc	a1,0x3
    800052e8:	41c58593          	addi	a1,a1,1052 # 80008700 <syscalls+0x320>
    800052ec:	00015517          	auipc	a0,0x15
    800052f0:	82c50513          	addi	a0,a0,-2004 # 80019b18 <disk+0x128>
    800052f4:	00001097          	auipc	ra,0x1
    800052f8:	e80080e7          	jalr	-384(ra) # 80006174 <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052fc:	100017b7          	lui	a5,0x10001
    80005300:	4398                	lw	a4,0(a5)
    80005302:	2701                	sext.w	a4,a4
    80005304:	747277b7          	lui	a5,0x74727
    80005308:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000530c:	14f71b63          	bne	a4,a5,80005462 <virtio_disk_init+0x18a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005310:	100017b7          	lui	a5,0x10001
    80005314:	43dc                	lw	a5,4(a5)
    80005316:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005318:	4709                	li	a4,2
    8000531a:	14e79463          	bne	a5,a4,80005462 <virtio_disk_init+0x18a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000531e:	100017b7          	lui	a5,0x10001
    80005322:	479c                	lw	a5,8(a5)
    80005324:	2781                	sext.w	a5,a5
    80005326:	12e79e63          	bne	a5,a4,80005462 <virtio_disk_init+0x18a>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    8000532a:	100017b7          	lui	a5,0x10001
    8000532e:	47d8                	lw	a4,12(a5)
    80005330:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005332:	554d47b7          	lui	a5,0x554d4
    80005336:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000533a:	12f71463          	bne	a4,a5,80005462 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000533e:	100017b7          	lui	a5,0x10001
    80005342:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005346:	4705                	li	a4,1
    80005348:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000534a:	470d                	li	a4,3
    8000534c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000534e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005350:	c7ffe6b7          	lui	a3,0xc7ffe
    80005354:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc9ef>
    80005358:	8f75                	and	a4,a4,a3
    8000535a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000535c:	472d                	li	a4,11
    8000535e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005360:	5bbc                	lw	a5,112(a5)
    80005362:	0007891b          	sext.w	s2,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005366:	8ba1                	andi	a5,a5,8
    80005368:	10078563          	beqz	a5,80005472 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000536c:	100017b7          	lui	a5,0x10001
    80005370:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY)) panic("virtio disk should not be ready");
    80005374:	43fc                	lw	a5,68(a5)
    80005376:	2781                	sext.w	a5,a5
    80005378:	10079563          	bnez	a5,80005482 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000537c:	100017b7          	lui	a5,0x10001
    80005380:	5bdc                	lw	a5,52(a5)
    80005382:	2781                	sext.w	a5,a5
  if (max == 0) panic("virtio disk has no queue 0");
    80005384:	10078763          	beqz	a5,80005492 <virtio_disk_init+0x1ba>
  if (max < NUM) panic("virtio disk max queue too short");
    80005388:	471d                	li	a4,7
    8000538a:	10f77c63          	bgeu	a4,a5,800054a2 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000538e:	ffffb097          	auipc	ra,0xffffb
    80005392:	d8c080e7          	jalr	-628(ra) # 8000011a <kalloc>
    80005396:	00014497          	auipc	s1,0x14
    8000539a:	65a48493          	addi	s1,s1,1626 # 800199f0 <disk>
    8000539e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800053a0:	ffffb097          	auipc	ra,0xffffb
    800053a4:	d7a080e7          	jalr	-646(ra) # 8000011a <kalloc>
    800053a8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800053aa:	ffffb097          	auipc	ra,0xffffb
    800053ae:	d70080e7          	jalr	-656(ra) # 8000011a <kalloc>
    800053b2:	87aa                	mv	a5,a0
    800053b4:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used) panic("virtio disk kalloc");
    800053b6:	6088                	ld	a0,0(s1)
    800053b8:	cd6d                	beqz	a0,800054b2 <virtio_disk_init+0x1da>
    800053ba:	00014717          	auipc	a4,0x14
    800053be:	63e73703          	ld	a4,1598(a4) # 800199f8 <disk+0x8>
    800053c2:	cb65                	beqz	a4,800054b2 <virtio_disk_init+0x1da>
    800053c4:	c7fd                	beqz	a5,800054b2 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    800053c6:	6605                	lui	a2,0x1
    800053c8:	4581                	li	a1,0
    800053ca:	ffffb097          	auipc	ra,0xffffb
    800053ce:	db0080e7          	jalr	-592(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    800053d2:	00014497          	auipc	s1,0x14
    800053d6:	61e48493          	addi	s1,s1,1566 # 800199f0 <disk>
    800053da:	6605                	lui	a2,0x1
    800053dc:	4581                	li	a1,0
    800053de:	6488                	ld	a0,8(s1)
    800053e0:	ffffb097          	auipc	ra,0xffffb
    800053e4:	d9a080e7          	jalr	-614(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    800053e8:	6605                	lui	a2,0x1
    800053ea:	4581                	li	a1,0
    800053ec:	6888                	ld	a0,16(s1)
    800053ee:	ffffb097          	auipc	ra,0xffffb
    800053f2:	d8c080e7          	jalr	-628(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053f6:	100017b7          	lui	a5,0x10001
    800053fa:	4721                	li	a4,8
    800053fc:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800053fe:	4098                	lw	a4,0(s1)
    80005400:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005404:	40d8                	lw	a4,4(s1)
    80005406:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000540a:	6498                	ld	a4,8(s1)
    8000540c:	0007069b          	sext.w	a3,a4
    80005410:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005414:	9701                	srai	a4,a4,0x20
    80005416:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000541a:	6898                	ld	a4,16(s1)
    8000541c:	0007069b          	sext.w	a3,a4
    80005420:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005424:	9701                	srai	a4,a4,0x20
    80005426:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000542a:	4705                	li	a4,1
    8000542c:	c3f8                	sw	a4,68(a5)
  for (int i = 0; i < NUM; i++) disk.free[i] = 1;
    8000542e:	00e48c23          	sb	a4,24(s1)
    80005432:	00e48ca3          	sb	a4,25(s1)
    80005436:	00e48d23          	sb	a4,26(s1)
    8000543a:	00e48da3          	sb	a4,27(s1)
    8000543e:	00e48e23          	sb	a4,28(s1)
    80005442:	00e48ea3          	sb	a4,29(s1)
    80005446:	00e48f23          	sb	a4,30(s1)
    8000544a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000544e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005452:	0727a823          	sw	s2,112(a5)
}
    80005456:	60e2                	ld	ra,24(sp)
    80005458:	6442                	ld	s0,16(sp)
    8000545a:	64a2                	ld	s1,8(sp)
    8000545c:	6902                	ld	s2,0(sp)
    8000545e:	6105                	addi	sp,sp,32
    80005460:	8082                	ret
    panic("could not find virtio disk");
    80005462:	00003517          	auipc	a0,0x3
    80005466:	2ae50513          	addi	a0,a0,686 # 80008710 <syscalls+0x330>
    8000546a:	00001097          	auipc	ra,0x1
    8000546e:	862080e7          	jalr	-1950(ra) # 80005ccc <panic>
    panic("virtio disk FEATURES_OK unset");
    80005472:	00003517          	auipc	a0,0x3
    80005476:	2be50513          	addi	a0,a0,702 # 80008730 <syscalls+0x350>
    8000547a:	00001097          	auipc	ra,0x1
    8000547e:	852080e7          	jalr	-1966(ra) # 80005ccc <panic>
  if (*R(VIRTIO_MMIO_QUEUE_READY)) panic("virtio disk should not be ready");
    80005482:	00003517          	auipc	a0,0x3
    80005486:	2ce50513          	addi	a0,a0,718 # 80008750 <syscalls+0x370>
    8000548a:	00001097          	auipc	ra,0x1
    8000548e:	842080e7          	jalr	-1982(ra) # 80005ccc <panic>
  if (max == 0) panic("virtio disk has no queue 0");
    80005492:	00003517          	auipc	a0,0x3
    80005496:	2de50513          	addi	a0,a0,734 # 80008770 <syscalls+0x390>
    8000549a:	00001097          	auipc	ra,0x1
    8000549e:	832080e7          	jalr	-1998(ra) # 80005ccc <panic>
  if (max < NUM) panic("virtio disk max queue too short");
    800054a2:	00003517          	auipc	a0,0x3
    800054a6:	2ee50513          	addi	a0,a0,750 # 80008790 <syscalls+0x3b0>
    800054aa:	00001097          	auipc	ra,0x1
    800054ae:	822080e7          	jalr	-2014(ra) # 80005ccc <panic>
  if (!disk.desc || !disk.avail || !disk.used) panic("virtio disk kalloc");
    800054b2:	00003517          	auipc	a0,0x3
    800054b6:	2fe50513          	addi	a0,a0,766 # 800087b0 <syscalls+0x3d0>
    800054ba:	00001097          	auipc	ra,0x1
    800054be:	812080e7          	jalr	-2030(ra) # 80005ccc <panic>

00000000800054c2 <virtio_disk_rw>:
    }
  }
  return 0;
}

void virtio_disk_rw(struct buf *b, int write) {
    800054c2:	7119                	addi	sp,sp,-128
    800054c4:	fc86                	sd	ra,120(sp)
    800054c6:	f8a2                	sd	s0,112(sp)
    800054c8:	f4a6                	sd	s1,104(sp)
    800054ca:	f0ca                	sd	s2,96(sp)
    800054cc:	ecce                	sd	s3,88(sp)
    800054ce:	e8d2                	sd	s4,80(sp)
    800054d0:	e4d6                	sd	s5,72(sp)
    800054d2:	e0da                	sd	s6,64(sp)
    800054d4:	fc5e                	sd	s7,56(sp)
    800054d6:	f862                	sd	s8,48(sp)
    800054d8:	f466                	sd	s9,40(sp)
    800054da:	f06a                	sd	s10,32(sp)
    800054dc:	ec6e                	sd	s11,24(sp)
    800054de:	0100                	addi	s0,sp,128
    800054e0:	8aaa                	mv	s5,a0
    800054e2:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054e4:	00c52d03          	lw	s10,12(a0)
    800054e8:	001d1d1b          	slliw	s10,s10,0x1
    800054ec:	1d02                	slli	s10,s10,0x20
    800054ee:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    800054f2:	00014517          	auipc	a0,0x14
    800054f6:	62650513          	addi	a0,a0,1574 # 80019b18 <disk+0x128>
    800054fa:	00001097          	auipc	ra,0x1
    800054fe:	d0a080e7          	jalr	-758(ra) # 80006204 <acquire>
  for (int i = 0; i < 3; i++) {
    80005502:	4981                	li	s3,0
  for (int i = 0; i < NUM; i++) {
    80005504:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005506:	00014b97          	auipc	s7,0x14
    8000550a:	4eab8b93          	addi	s7,s7,1258 # 800199f0 <disk>
  for (int i = 0; i < 3; i++) {
    8000550e:	4b0d                	li	s6,3
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005510:	00014c97          	auipc	s9,0x14
    80005514:	608c8c93          	addi	s9,s9,1544 # 80019b18 <disk+0x128>
    80005518:	a08d                	j	8000557a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000551a:	00fb8733          	add	a4,s7,a5
    8000551e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005522:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    80005524:	0207c563          	bltz	a5,8000554e <virtio_disk_rw+0x8c>
  for (int i = 0; i < 3; i++) {
    80005528:	2905                	addiw	s2,s2,1
    8000552a:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000552c:	05690c63          	beq	s2,s6,80005584 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005530:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    80005532:	00014717          	auipc	a4,0x14
    80005536:	4be70713          	addi	a4,a4,1214 # 800199f0 <disk>
    8000553a:	87ce                	mv	a5,s3
    if (disk.free[i]) {
    8000553c:	01874683          	lbu	a3,24(a4)
    80005540:	fee9                	bnez	a3,8000551a <virtio_disk_rw+0x58>
  for (int i = 0; i < NUM; i++) {
    80005542:	2785                	addiw	a5,a5,1
    80005544:	0705                	addi	a4,a4,1
    80005546:	fe979be3          	bne	a5,s1,8000553c <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000554a:	57fd                	li	a5,-1
    8000554c:	c19c                	sw	a5,0(a1)
      for (int j = 0; j < i; j++) free_desc(idx[j]);
    8000554e:	01205d63          	blez	s2,80005568 <virtio_disk_rw+0xa6>
    80005552:	8dce                	mv	s11,s3
    80005554:	000a2503          	lw	a0,0(s4)
    80005558:	00000097          	auipc	ra,0x0
    8000555c:	cfe080e7          	jalr	-770(ra) # 80005256 <free_desc>
    80005560:	2d85                	addiw	s11,s11,1
    80005562:	0a11                	addi	s4,s4,4
    80005564:	ff2d98e3          	bne	s11,s2,80005554 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005568:	85e6                	mv	a1,s9
    8000556a:	00014517          	auipc	a0,0x14
    8000556e:	49e50513          	addi	a0,a0,1182 # 80019a08 <disk+0x18>
    80005572:	ffffc097          	auipc	ra,0xffffc
    80005576:	f8a080e7          	jalr	-118(ra) # 800014fc <sleep>
  for (int i = 0; i < 3; i++) {
    8000557a:	f8040a13          	addi	s4,s0,-128
void virtio_disk_rw(struct buf *b, int write) {
    8000557e:	8652                	mv	a2,s4
  for (int i = 0; i < 3; i++) {
    80005580:	894e                	mv	s2,s3
    80005582:	b77d                	j	80005530 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005584:	f8042503          	lw	a0,-128(s0)
    80005588:	00a50713          	addi	a4,a0,10
    8000558c:	0712                	slli	a4,a4,0x4

  if (write)
    8000558e:	00014797          	auipc	a5,0x14
    80005592:	46278793          	addi	a5,a5,1122 # 800199f0 <disk>
    80005596:	00e786b3          	add	a3,a5,a4
    8000559a:	01803633          	snez	a2,s8
    8000559e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT;  // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN;  // read the disk
  buf0->reserved = 0;
    800055a0:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    800055a4:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64)buf0;
    800055a8:	f6070613          	addi	a2,a4,-160
    800055ac:	6394                	ld	a3,0(a5)
    800055ae:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055b0:	00870593          	addi	a1,a4,8
    800055b4:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    800055b6:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055b8:	0007b803          	ld	a6,0(a5)
    800055bc:	9642                	add	a2,a2,a6
    800055be:	46c1                	li	a3,16
    800055c0:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055c2:	4585                	li	a1,1
    800055c4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    800055c8:	f8442683          	lw	a3,-124(s0)
    800055cc:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64)b->data;
    800055d0:	0692                	slli	a3,a3,0x4
    800055d2:	9836                	add	a6,a6,a3
    800055d4:	058a8613          	addi	a2,s5,88
    800055d8:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    800055dc:	0007b803          	ld	a6,0(a5)
    800055e0:	96c2                	add	a3,a3,a6
    800055e2:	40000613          	li	a2,1024
    800055e6:	c690                	sw	a2,8(a3)
  if (write)
    800055e8:	001c3613          	seqz	a2,s8
    800055ec:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0;  // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE;  // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055f0:	00166613          	ori	a2,a2,1
    800055f4:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800055f8:	f8842603          	lw	a2,-120(s0)
    800055fc:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff;  // device writes 0 on success
    80005600:	00250693          	addi	a3,a0,2
    80005604:	0692                	slli	a3,a3,0x4
    80005606:	96be                	add	a3,a3,a5
    80005608:	58fd                	li	a7,-1
    8000560a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    8000560e:	0612                	slli	a2,a2,0x4
    80005610:	9832                	add	a6,a6,a2
    80005612:	f9070713          	addi	a4,a4,-112
    80005616:	973e                	add	a4,a4,a5
    80005618:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000561c:	6398                	ld	a4,0(a5)
    8000561e:	9732                	add	a4,a4,a2
    80005620:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE;  // device writes the status
    80005622:	4609                	li	a2,2
    80005624:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005628:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000562c:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80005630:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005634:	6794                	ld	a3,8(a5)
    80005636:	0026d703          	lhu	a4,2(a3)
    8000563a:	8b1d                	andi	a4,a4,7
    8000563c:	0706                	slli	a4,a4,0x1
    8000563e:	96ba                	add	a3,a3,a4
    80005640:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005644:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1;  // not % NUM ...
    80005648:	6798                	ld	a4,8(a5)
    8000564a:	00275783          	lhu	a5,2(a4)
    8000564e:	2785                	addiw	a5,a5,1
    80005650:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005654:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0;  // value is queue number
    80005658:	100017b7          	lui	a5,0x10001
    8000565c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    80005660:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    80005664:	00014917          	auipc	s2,0x14
    80005668:	4b490913          	addi	s2,s2,1204 # 80019b18 <disk+0x128>
  while (b->disk == 1) {
    8000566c:	4485                	li	s1,1
    8000566e:	00b79c63          	bne	a5,a1,80005686 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005672:	85ca                	mv	a1,s2
    80005674:	8556                	mv	a0,s5
    80005676:	ffffc097          	auipc	ra,0xffffc
    8000567a:	e86080e7          	jalr	-378(ra) # 800014fc <sleep>
  while (b->disk == 1) {
    8000567e:	004aa783          	lw	a5,4(s5)
    80005682:	fe9788e3          	beq	a5,s1,80005672 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005686:	f8042903          	lw	s2,-128(s0)
    8000568a:	00290713          	addi	a4,s2,2
    8000568e:	0712                	slli	a4,a4,0x4
    80005690:	00014797          	auipc	a5,0x14
    80005694:	36078793          	addi	a5,a5,864 # 800199f0 <disk>
    80005698:	97ba                	add	a5,a5,a4
    8000569a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000569e:	00014997          	auipc	s3,0x14
    800056a2:	35298993          	addi	s3,s3,850 # 800199f0 <disk>
    800056a6:	00491713          	slli	a4,s2,0x4
    800056aa:	0009b783          	ld	a5,0(s3)
    800056ae:	97ba                	add	a5,a5,a4
    800056b0:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056b4:	854a                	mv	a0,s2
    800056b6:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056ba:	00000097          	auipc	ra,0x0
    800056be:	b9c080e7          	jalr	-1124(ra) # 80005256 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    800056c2:	8885                	andi	s1,s1,1
    800056c4:	f0ed                	bnez	s1,800056a6 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056c6:	00014517          	auipc	a0,0x14
    800056ca:	45250513          	addi	a0,a0,1106 # 80019b18 <disk+0x128>
    800056ce:	00001097          	auipc	ra,0x1
    800056d2:	bea080e7          	jalr	-1046(ra) # 800062b8 <release>
}
    800056d6:	70e6                	ld	ra,120(sp)
    800056d8:	7446                	ld	s0,112(sp)
    800056da:	74a6                	ld	s1,104(sp)
    800056dc:	7906                	ld	s2,96(sp)
    800056de:	69e6                	ld	s3,88(sp)
    800056e0:	6a46                	ld	s4,80(sp)
    800056e2:	6aa6                	ld	s5,72(sp)
    800056e4:	6b06                	ld	s6,64(sp)
    800056e6:	7be2                	ld	s7,56(sp)
    800056e8:	7c42                	ld	s8,48(sp)
    800056ea:	7ca2                	ld	s9,40(sp)
    800056ec:	7d02                	ld	s10,32(sp)
    800056ee:	6de2                	ld	s11,24(sp)
    800056f0:	6109                	addi	sp,sp,128
    800056f2:	8082                	ret

00000000800056f4 <virtio_disk_intr>:

void virtio_disk_intr() {
    800056f4:	1101                	addi	sp,sp,-32
    800056f6:	ec06                	sd	ra,24(sp)
    800056f8:	e822                	sd	s0,16(sp)
    800056fa:	e426                	sd	s1,8(sp)
    800056fc:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800056fe:	00014497          	auipc	s1,0x14
    80005702:	2f248493          	addi	s1,s1,754 # 800199f0 <disk>
    80005706:	00014517          	auipc	a0,0x14
    8000570a:	41250513          	addi	a0,a0,1042 # 80019b18 <disk+0x128>
    8000570e:	00001097          	auipc	ra,0x1
    80005712:	af6080e7          	jalr	-1290(ra) # 80006204 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005716:	10001737          	lui	a4,0x10001
    8000571a:	533c                	lw	a5,96(a4)
    8000571c:	8b8d                	andi	a5,a5,3
    8000571e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005720:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    80005724:	689c                	ld	a5,16(s1)
    80005726:	0204d703          	lhu	a4,32(s1)
    8000572a:	0027d783          	lhu	a5,2(a5)
    8000572e:	04f70863          	beq	a4,a5,8000577e <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005732:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005736:	6898                	ld	a4,16(s1)
    80005738:	0204d783          	lhu	a5,32(s1)
    8000573c:	8b9d                	andi	a5,a5,7
    8000573e:	078e                	slli	a5,a5,0x3
    80005740:	97ba                	add	a5,a5,a4
    80005742:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0) panic("virtio_disk_intr status");
    80005744:	00278713          	addi	a4,a5,2
    80005748:	0712                	slli	a4,a4,0x4
    8000574a:	9726                	add	a4,a4,s1
    8000574c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005750:	e721                	bnez	a4,80005798 <virtio_disk_intr+0xa4>

    struct buf *b = disk.info[id].b;
    80005752:	0789                	addi	a5,a5,2
    80005754:	0792                	slli	a5,a5,0x4
    80005756:	97a6                	add	a5,a5,s1
    80005758:	6788                	ld	a0,8(a5)
    b->disk = 0;  // disk is done with buf
    8000575a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000575e:	ffffc097          	auipc	ra,0xffffc
    80005762:	e02080e7          	jalr	-510(ra) # 80001560 <wakeup>

    disk.used_idx += 1;
    80005766:	0204d783          	lhu	a5,32(s1)
    8000576a:	2785                	addiw	a5,a5,1
    8000576c:	17c2                	slli	a5,a5,0x30
    8000576e:	93c1                	srli	a5,a5,0x30
    80005770:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    80005774:	6898                	ld	a4,16(s1)
    80005776:	00275703          	lhu	a4,2(a4)
    8000577a:	faf71ce3          	bne	a4,a5,80005732 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000577e:	00014517          	auipc	a0,0x14
    80005782:	39a50513          	addi	a0,a0,922 # 80019b18 <disk+0x128>
    80005786:	00001097          	auipc	ra,0x1
    8000578a:	b32080e7          	jalr	-1230(ra) # 800062b8 <release>
}
    8000578e:	60e2                	ld	ra,24(sp)
    80005790:	6442                	ld	s0,16(sp)
    80005792:	64a2                	ld	s1,8(sp)
    80005794:	6105                	addi	sp,sp,32
    80005796:	8082                	ret
    if (disk.info[id].status != 0) panic("virtio_disk_intr status");
    80005798:	00003517          	auipc	a0,0x3
    8000579c:	03050513          	addi	a0,a0,48 # 800087c8 <syscalls+0x3e8>
    800057a0:	00000097          	auipc	ra,0x0
    800057a4:	52c080e7          	jalr	1324(ra) # 80005ccc <panic>

00000000800057a8 <timerinit>:
// arrange to receive timer interrupts.
// they will arrive in machine mode at
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void timerinit() {
    800057a8:	1141                	addi	sp,sp,-16
    800057aa:	e422                	sd	s0,8(sp)
    800057ac:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800057ae:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800057b2:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000;  // cycles; about 1/10th second in qemu.
  *(uint64 *)CLINT_MTIMECMP(id) = *(uint64 *)CLINT_MTIME + interval;
    800057b6:	0037979b          	slliw	a5,a5,0x3
    800057ba:	02004737          	lui	a4,0x2004
    800057be:	97ba                	add	a5,a5,a4
    800057c0:	0200c737          	lui	a4,0x200c
    800057c4:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800057c8:	000f4637          	lui	a2,0xf4
    800057cc:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800057d0:	9732                	add	a4,a4,a2
    800057d2:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800057d4:	00259693          	slli	a3,a1,0x2
    800057d8:	96ae                	add	a3,a3,a1
    800057da:	068e                	slli	a3,a3,0x3
    800057dc:	00014717          	auipc	a4,0x14
    800057e0:	35470713          	addi	a4,a4,852 # 80019b30 <timer_scratch>
    800057e4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800057e6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800057e8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r"(x));
    800057ea:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r"(x));
    800057ee:	00000797          	auipc	a5,0x0
    800057f2:	9a278793          	addi	a5,a5,-1630 # 80005190 <timervec>
    800057f6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r"(x));
    800057fa:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800057fe:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80005802:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r"(x));
    80005806:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000580a:	0807e793          	ori	a5,a5,128
static inline void w_mie(uint64 x) { asm volatile("csrw mie, %0" : : "r"(x)); }
    8000580e:	30479073          	csrw	mie,a5
}
    80005812:	6422                	ld	s0,8(sp)
    80005814:	0141                	addi	sp,sp,16
    80005816:	8082                	ret

0000000080005818 <start>:
void start() {
    80005818:	1141                	addi	sp,sp,-16
    8000581a:	e406                	sd	ra,8(sp)
    8000581c:	e022                	sd	s0,0(sp)
    8000581e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80005820:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005824:	7779                	lui	a4,0xffffe
    80005826:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdca8f>
    8000582a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000582c:	6705                	lui	a4,0x1
    8000582e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005832:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80005834:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80005838:	ffffb797          	auipc	a5,0xffffb
    8000583c:	ae878793          	addi	a5,a5,-1304 # 80000320 <main>
    80005840:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80005844:	4781                	li	a5,0
    80005846:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    8000584a:	67c1                	lui	a5,0x10
    8000584c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000584e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    80005852:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80005856:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000585a:	2227e793          	ori	a5,a5,546
static inline void w_sie(uint64 x) { asm volatile("csrw sie, %0" : : "r"(x)); }
    8000585e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    80005862:	57fd                	li	a5,-1
    80005864:	83a9                	srli	a5,a5,0xa
    80005866:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    8000586a:	47bd                	li	a5,15
    8000586c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005870:	00000097          	auipc	ra,0x0
    80005874:	f38080e7          	jalr	-200(ra) # 800057a8 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    80005878:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000587c:	2781                	sext.w	a5,a5
static inline void w_tp(uint64 x) { asm volatile("mv tp, %0" : : "r"(x)); }
    8000587e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005880:	30200073          	mret
}
    80005884:	60a2                	ld	ra,8(sp)
    80005886:	6402                	ld	s0,0(sp)
    80005888:	0141                	addi	sp,sp,16
    8000588a:	8082                	ret

000000008000588c <consolewrite>:
} cons;

//
// user write()s to the console go here.
//
int consolewrite(int user_src, uint64 src, int n) {
    8000588c:	715d                	addi	sp,sp,-80
    8000588e:	e486                	sd	ra,72(sp)
    80005890:	e0a2                	sd	s0,64(sp)
    80005892:	fc26                	sd	s1,56(sp)
    80005894:	f84a                	sd	s2,48(sp)
    80005896:	f44e                	sd	s3,40(sp)
    80005898:	f052                	sd	s4,32(sp)
    8000589a:	ec56                	sd	s5,24(sp)
    8000589c:	0880                	addi	s0,sp,80
  int i;

  for (i = 0; i < n; i++) {
    8000589e:	04c05763          	blez	a2,800058ec <consolewrite+0x60>
    800058a2:	8a2a                	mv	s4,a0
    800058a4:	84ae                	mv	s1,a1
    800058a6:	89b2                	mv	s3,a2
    800058a8:	4901                	li	s2,0
    char c;
    if (either_copyin(&c, user_src, src + i, 1) == -1) break;
    800058aa:	5afd                	li	s5,-1
    800058ac:	4685                	li	a3,1
    800058ae:	8626                	mv	a2,s1
    800058b0:	85d2                	mv	a1,s4
    800058b2:	fbf40513          	addi	a0,s0,-65
    800058b6:	ffffc097          	auipc	ra,0xffffc
    800058ba:	0a4080e7          	jalr	164(ra) # 8000195a <either_copyin>
    800058be:	01550d63          	beq	a0,s5,800058d8 <consolewrite+0x4c>
    uartputc(c);
    800058c2:	fbf44503          	lbu	a0,-65(s0)
    800058c6:	00000097          	auipc	ra,0x0
    800058ca:	784080e7          	jalr	1924(ra) # 8000604a <uartputc>
  for (i = 0; i < n; i++) {
    800058ce:	2905                	addiw	s2,s2,1
    800058d0:	0485                	addi	s1,s1,1
    800058d2:	fd299de3          	bne	s3,s2,800058ac <consolewrite+0x20>
    800058d6:	894e                	mv	s2,s3
  }

  return i;
}
    800058d8:	854a                	mv	a0,s2
    800058da:	60a6                	ld	ra,72(sp)
    800058dc:	6406                	ld	s0,64(sp)
    800058de:	74e2                	ld	s1,56(sp)
    800058e0:	7942                	ld	s2,48(sp)
    800058e2:	79a2                	ld	s3,40(sp)
    800058e4:	7a02                	ld	s4,32(sp)
    800058e6:	6ae2                	ld	s5,24(sp)
    800058e8:	6161                	addi	sp,sp,80
    800058ea:	8082                	ret
  for (i = 0; i < n; i++) {
    800058ec:	4901                	li	s2,0
    800058ee:	b7ed                	j	800058d8 <consolewrite+0x4c>

00000000800058f0 <consoleread>:
// user read()s from the console go here.
// copy (up to) a whole input line to dst.
// user_dist indicates whether dst is a user
// or kernel address.
//
int consoleread(int user_dst, uint64 dst, int n) {
    800058f0:	7159                	addi	sp,sp,-112
    800058f2:	f486                	sd	ra,104(sp)
    800058f4:	f0a2                	sd	s0,96(sp)
    800058f6:	eca6                	sd	s1,88(sp)
    800058f8:	e8ca                	sd	s2,80(sp)
    800058fa:	e4ce                	sd	s3,72(sp)
    800058fc:	e0d2                	sd	s4,64(sp)
    800058fe:	fc56                	sd	s5,56(sp)
    80005900:	f85a                	sd	s6,48(sp)
    80005902:	f45e                	sd	s7,40(sp)
    80005904:	f062                	sd	s8,32(sp)
    80005906:	ec66                	sd	s9,24(sp)
    80005908:	e86a                	sd	s10,16(sp)
    8000590a:	1880                	addi	s0,sp,112
    8000590c:	8aaa                	mv	s5,a0
    8000590e:	8a2e                	mv	s4,a1
    80005910:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005912:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005916:	0001c517          	auipc	a0,0x1c
    8000591a:	35a50513          	addi	a0,a0,858 # 80021c70 <cons>
    8000591e:	00001097          	auipc	ra,0x1
    80005922:	8e6080e7          	jalr	-1818(ra) # 80006204 <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    80005926:	0001c497          	auipc	s1,0x1c
    8000592a:	34a48493          	addi	s1,s1,842 # 80021c70 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000592e:	0001c917          	auipc	s2,0x1c
    80005932:	3da90913          	addi	s2,s2,986 # 80021d08 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if (c == C('D')) {  // end-of-file
    80005936:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1) break;
    80005938:	5c7d                	li	s8,-1

    dst++;
    --n;

    if (c == '\n') {
    8000593a:	4ca9                	li	s9,10
  while (n > 0) {
    8000593c:	07305b63          	blez	s3,800059b2 <consoleread+0xc2>
    while (cons.r == cons.w) {
    80005940:	0984a783          	lw	a5,152(s1)
    80005944:	09c4a703          	lw	a4,156(s1)
    80005948:	02f71763          	bne	a4,a5,80005976 <consoleread+0x86>
      if (killed(myproc())) {
    8000594c:	ffffb097          	auipc	ra,0xffffb
    80005950:	508080e7          	jalr	1288(ra) # 80000e54 <myproc>
    80005954:	ffffc097          	auipc	ra,0xffffc
    80005958:	e50080e7          	jalr	-432(ra) # 800017a4 <killed>
    8000595c:	e535                	bnez	a0,800059c8 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    8000595e:	85a6                	mv	a1,s1
    80005960:	854a                	mv	a0,s2
    80005962:	ffffc097          	auipc	ra,0xffffc
    80005966:	b9a080e7          	jalr	-1126(ra) # 800014fc <sleep>
    while (cons.r == cons.w) {
    8000596a:	0984a783          	lw	a5,152(s1)
    8000596e:	09c4a703          	lw	a4,156(s1)
    80005972:	fcf70de3          	beq	a4,a5,8000594c <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005976:	0017871b          	addiw	a4,a5,1
    8000597a:	08e4ac23          	sw	a4,152(s1)
    8000597e:	07f7f713          	andi	a4,a5,127
    80005982:	9726                	add	a4,a4,s1
    80005984:	01874703          	lbu	a4,24(a4)
    80005988:	00070d1b          	sext.w	s10,a4
    if (c == C('D')) {  // end-of-file
    8000598c:	077d0563          	beq	s10,s7,800059f6 <consoleread+0x106>
    cbuf = c;
    80005990:	f8e40fa3          	sb	a4,-97(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1) break;
    80005994:	4685                	li	a3,1
    80005996:	f9f40613          	addi	a2,s0,-97
    8000599a:	85d2                	mv	a1,s4
    8000599c:	8556                	mv	a0,s5
    8000599e:	ffffc097          	auipc	ra,0xffffc
    800059a2:	f66080e7          	jalr	-154(ra) # 80001904 <either_copyout>
    800059a6:	01850663          	beq	a0,s8,800059b2 <consoleread+0xc2>
    dst++;
    800059aa:	0a05                	addi	s4,s4,1
    --n;
    800059ac:	39fd                	addiw	s3,s3,-1
    if (c == '\n') {
    800059ae:	f99d17e3          	bne	s10,s9,8000593c <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800059b2:	0001c517          	auipc	a0,0x1c
    800059b6:	2be50513          	addi	a0,a0,702 # 80021c70 <cons>
    800059ba:	00001097          	auipc	ra,0x1
    800059be:	8fe080e7          	jalr	-1794(ra) # 800062b8 <release>

  return target - n;
    800059c2:	413b053b          	subw	a0,s6,s3
    800059c6:	a811                	j	800059da <consoleread+0xea>
        release(&cons.lock);
    800059c8:	0001c517          	auipc	a0,0x1c
    800059cc:	2a850513          	addi	a0,a0,680 # 80021c70 <cons>
    800059d0:	00001097          	auipc	ra,0x1
    800059d4:	8e8080e7          	jalr	-1816(ra) # 800062b8 <release>
        return -1;
    800059d8:	557d                	li	a0,-1
}
    800059da:	70a6                	ld	ra,104(sp)
    800059dc:	7406                	ld	s0,96(sp)
    800059de:	64e6                	ld	s1,88(sp)
    800059e0:	6946                	ld	s2,80(sp)
    800059e2:	69a6                	ld	s3,72(sp)
    800059e4:	6a06                	ld	s4,64(sp)
    800059e6:	7ae2                	ld	s5,56(sp)
    800059e8:	7b42                	ld	s6,48(sp)
    800059ea:	7ba2                	ld	s7,40(sp)
    800059ec:	7c02                	ld	s8,32(sp)
    800059ee:	6ce2                	ld	s9,24(sp)
    800059f0:	6d42                	ld	s10,16(sp)
    800059f2:	6165                	addi	sp,sp,112
    800059f4:	8082                	ret
      if (n < target) {
    800059f6:	0009871b          	sext.w	a4,s3
    800059fa:	fb677ce3          	bgeu	a4,s6,800059b2 <consoleread+0xc2>
        cons.r--;
    800059fe:	0001c717          	auipc	a4,0x1c
    80005a02:	30f72523          	sw	a5,778(a4) # 80021d08 <cons+0x98>
    80005a06:	b775                	j	800059b2 <consoleread+0xc2>

0000000080005a08 <consputc>:
void consputc(int c) {
    80005a08:	1141                	addi	sp,sp,-16
    80005a0a:	e406                	sd	ra,8(sp)
    80005a0c:	e022                	sd	s0,0(sp)
    80005a0e:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80005a10:	10000793          	li	a5,256
    80005a14:	00f50a63          	beq	a0,a5,80005a28 <consputc+0x20>
    uartputc_sync(c);
    80005a18:	00000097          	auipc	ra,0x0
    80005a1c:	560080e7          	jalr	1376(ra) # 80005f78 <uartputc_sync>
}
    80005a20:	60a2                	ld	ra,8(sp)
    80005a22:	6402                	ld	s0,0(sp)
    80005a24:	0141                	addi	sp,sp,16
    80005a26:	8082                	ret
    uartputc_sync('\b');
    80005a28:	4521                	li	a0,8
    80005a2a:	00000097          	auipc	ra,0x0
    80005a2e:	54e080e7          	jalr	1358(ra) # 80005f78 <uartputc_sync>
    uartputc_sync(' ');
    80005a32:	02000513          	li	a0,32
    80005a36:	00000097          	auipc	ra,0x0
    80005a3a:	542080e7          	jalr	1346(ra) # 80005f78 <uartputc_sync>
    uartputc_sync('\b');
    80005a3e:	4521                	li	a0,8
    80005a40:	00000097          	auipc	ra,0x0
    80005a44:	538080e7          	jalr	1336(ra) # 80005f78 <uartputc_sync>
    80005a48:	bfe1                	j	80005a20 <consputc+0x18>

0000000080005a4a <consoleintr>:
// the console input interrupt handler.
// uartintr() calls this for input character.
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void consoleintr(int c) {
    80005a4a:	1101                	addi	sp,sp,-32
    80005a4c:	ec06                	sd	ra,24(sp)
    80005a4e:	e822                	sd	s0,16(sp)
    80005a50:	e426                	sd	s1,8(sp)
    80005a52:	e04a                	sd	s2,0(sp)
    80005a54:	1000                	addi	s0,sp,32
    80005a56:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a58:	0001c517          	auipc	a0,0x1c
    80005a5c:	21850513          	addi	a0,a0,536 # 80021c70 <cons>
    80005a60:	00000097          	auipc	ra,0x0
    80005a64:	7a4080e7          	jalr	1956(ra) # 80006204 <acquire>

  switch (c) {
    80005a68:	47d5                	li	a5,21
    80005a6a:	0af48663          	beq	s1,a5,80005b16 <consoleintr+0xcc>
    80005a6e:	0297ca63          	blt	a5,s1,80005aa2 <consoleintr+0x58>
    80005a72:	47a1                	li	a5,8
    80005a74:	0ef48763          	beq	s1,a5,80005b62 <consoleintr+0x118>
    80005a78:	47c1                	li	a5,16
    80005a7a:	10f49a63          	bne	s1,a5,80005b8e <consoleintr+0x144>
    case C('P'):  // Print process list.
      procdump();
    80005a7e:	ffffc097          	auipc	ra,0xffffc
    80005a82:	f32080e7          	jalr	-206(ra) # 800019b0 <procdump>
        }
      }
      break;
  }

  release(&cons.lock);
    80005a86:	0001c517          	auipc	a0,0x1c
    80005a8a:	1ea50513          	addi	a0,a0,490 # 80021c70 <cons>
    80005a8e:	00001097          	auipc	ra,0x1
    80005a92:	82a080e7          	jalr	-2006(ra) # 800062b8 <release>
}
    80005a96:	60e2                	ld	ra,24(sp)
    80005a98:	6442                	ld	s0,16(sp)
    80005a9a:	64a2                	ld	s1,8(sp)
    80005a9c:	6902                	ld	s2,0(sp)
    80005a9e:	6105                	addi	sp,sp,32
    80005aa0:	8082                	ret
  switch (c) {
    80005aa2:	07f00793          	li	a5,127
    80005aa6:	0af48e63          	beq	s1,a5,80005b62 <consoleintr+0x118>
      if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    80005aaa:	0001c717          	auipc	a4,0x1c
    80005aae:	1c670713          	addi	a4,a4,454 # 80021c70 <cons>
    80005ab2:	0a072783          	lw	a5,160(a4)
    80005ab6:	09872703          	lw	a4,152(a4)
    80005aba:	9f99                	subw	a5,a5,a4
    80005abc:	07f00713          	li	a4,127
    80005ac0:	fcf763e3          	bltu	a4,a5,80005a86 <consoleintr+0x3c>
        c = (c == '\r') ? '\n' : c;
    80005ac4:	47b5                	li	a5,13
    80005ac6:	0cf48763          	beq	s1,a5,80005b94 <consoleintr+0x14a>
        consputc(c);
    80005aca:	8526                	mv	a0,s1
    80005acc:	00000097          	auipc	ra,0x0
    80005ad0:	f3c080e7          	jalr	-196(ra) # 80005a08 <consputc>
        cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005ad4:	0001c797          	auipc	a5,0x1c
    80005ad8:	19c78793          	addi	a5,a5,412 # 80021c70 <cons>
    80005adc:	0a07a683          	lw	a3,160(a5)
    80005ae0:	0016871b          	addiw	a4,a3,1
    80005ae4:	0007061b          	sext.w	a2,a4
    80005ae8:	0ae7a023          	sw	a4,160(a5)
    80005aec:	07f6f693          	andi	a3,a3,127
    80005af0:	97b6                	add	a5,a5,a3
    80005af2:	00978c23          	sb	s1,24(a5)
        if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80005af6:	47a9                	li	a5,10
    80005af8:	0cf48563          	beq	s1,a5,80005bc2 <consoleintr+0x178>
    80005afc:	4791                	li	a5,4
    80005afe:	0cf48263          	beq	s1,a5,80005bc2 <consoleintr+0x178>
    80005b02:	0001c797          	auipc	a5,0x1c
    80005b06:	2067a783          	lw	a5,518(a5) # 80021d08 <cons+0x98>
    80005b0a:	9f1d                	subw	a4,a4,a5
    80005b0c:	08000793          	li	a5,128
    80005b10:	f6f71be3          	bne	a4,a5,80005a86 <consoleintr+0x3c>
    80005b14:	a07d                	j	80005bc2 <consoleintr+0x178>
      while (cons.e != cons.w &&
    80005b16:	0001c717          	auipc	a4,0x1c
    80005b1a:	15a70713          	addi	a4,a4,346 # 80021c70 <cons>
    80005b1e:	0a072783          	lw	a5,160(a4)
    80005b22:	09c72703          	lw	a4,156(a4)
             cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80005b26:	0001c497          	auipc	s1,0x1c
    80005b2a:	14a48493          	addi	s1,s1,330 # 80021c70 <cons>
      while (cons.e != cons.w &&
    80005b2e:	4929                	li	s2,10
    80005b30:	f4f70be3          	beq	a4,a5,80005a86 <consoleintr+0x3c>
             cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80005b34:	37fd                	addiw	a5,a5,-1
    80005b36:	07f7f713          	andi	a4,a5,127
    80005b3a:	9726                	add	a4,a4,s1
      while (cons.e != cons.w &&
    80005b3c:	01874703          	lbu	a4,24(a4)
    80005b40:	f52703e3          	beq	a4,s2,80005a86 <consoleintr+0x3c>
        cons.e--;
    80005b44:	0af4a023          	sw	a5,160(s1)
        consputc(BACKSPACE);
    80005b48:	10000513          	li	a0,256
    80005b4c:	00000097          	auipc	ra,0x0
    80005b50:	ebc080e7          	jalr	-324(ra) # 80005a08 <consputc>
      while (cons.e != cons.w &&
    80005b54:	0a04a783          	lw	a5,160(s1)
    80005b58:	09c4a703          	lw	a4,156(s1)
    80005b5c:	fcf71ce3          	bne	a4,a5,80005b34 <consoleintr+0xea>
    80005b60:	b71d                	j	80005a86 <consoleintr+0x3c>
      if (cons.e != cons.w) {
    80005b62:	0001c717          	auipc	a4,0x1c
    80005b66:	10e70713          	addi	a4,a4,270 # 80021c70 <cons>
    80005b6a:	0a072783          	lw	a5,160(a4)
    80005b6e:	09c72703          	lw	a4,156(a4)
    80005b72:	f0f70ae3          	beq	a4,a5,80005a86 <consoleintr+0x3c>
        cons.e--;
    80005b76:	37fd                	addiw	a5,a5,-1
    80005b78:	0001c717          	auipc	a4,0x1c
    80005b7c:	18f72c23          	sw	a5,408(a4) # 80021d10 <cons+0xa0>
        consputc(BACKSPACE);
    80005b80:	10000513          	li	a0,256
    80005b84:	00000097          	auipc	ra,0x0
    80005b88:	e84080e7          	jalr	-380(ra) # 80005a08 <consputc>
    80005b8c:	bded                	j	80005a86 <consoleintr+0x3c>
      if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    80005b8e:	ee048ce3          	beqz	s1,80005a86 <consoleintr+0x3c>
    80005b92:	bf21                	j	80005aaa <consoleintr+0x60>
        consputc(c);
    80005b94:	4529                	li	a0,10
    80005b96:	00000097          	auipc	ra,0x0
    80005b9a:	e72080e7          	jalr	-398(ra) # 80005a08 <consputc>
        cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b9e:	0001c797          	auipc	a5,0x1c
    80005ba2:	0d278793          	addi	a5,a5,210 # 80021c70 <cons>
    80005ba6:	0a07a703          	lw	a4,160(a5)
    80005baa:	0017069b          	addiw	a3,a4,1
    80005bae:	0006861b          	sext.w	a2,a3
    80005bb2:	0ad7a023          	sw	a3,160(a5)
    80005bb6:	07f77713          	andi	a4,a4,127
    80005bba:	97ba                	add	a5,a5,a4
    80005bbc:	4729                	li	a4,10
    80005bbe:	00e78c23          	sb	a4,24(a5)
          cons.w = cons.e;
    80005bc2:	0001c797          	auipc	a5,0x1c
    80005bc6:	14c7a523          	sw	a2,330(a5) # 80021d0c <cons+0x9c>
          wakeup(&cons.r);
    80005bca:	0001c517          	auipc	a0,0x1c
    80005bce:	13e50513          	addi	a0,a0,318 # 80021d08 <cons+0x98>
    80005bd2:	ffffc097          	auipc	ra,0xffffc
    80005bd6:	98e080e7          	jalr	-1650(ra) # 80001560 <wakeup>
    80005bda:	b575                	j	80005a86 <consoleintr+0x3c>

0000000080005bdc <consoleinit>:

void consoleinit(void) {
    80005bdc:	1141                	addi	sp,sp,-16
    80005bde:	e406                	sd	ra,8(sp)
    80005be0:	e022                	sd	s0,0(sp)
    80005be2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005be4:	00003597          	auipc	a1,0x3
    80005be8:	bfc58593          	addi	a1,a1,-1028 # 800087e0 <syscalls+0x400>
    80005bec:	0001c517          	auipc	a0,0x1c
    80005bf0:	08450513          	addi	a0,a0,132 # 80021c70 <cons>
    80005bf4:	00000097          	auipc	ra,0x0
    80005bf8:	580080e7          	jalr	1408(ra) # 80006174 <initlock>

  uartinit();
    80005bfc:	00000097          	auipc	ra,0x0
    80005c00:	32c080e7          	jalr	812(ra) # 80005f28 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c04:	00013797          	auipc	a5,0x13
    80005c08:	d9478793          	addi	a5,a5,-620 # 80018998 <devsw>
    80005c0c:	00000717          	auipc	a4,0x0
    80005c10:	ce470713          	addi	a4,a4,-796 # 800058f0 <consoleread>
    80005c14:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c16:	00000717          	auipc	a4,0x0
    80005c1a:	c7670713          	addi	a4,a4,-906 # 8000588c <consolewrite>
    80005c1e:	ef98                	sd	a4,24(a5)
}
    80005c20:	60a2                	ld	ra,8(sp)
    80005c22:	6402                	ld	s0,0(sp)
    80005c24:	0141                	addi	sp,sp,16
    80005c26:	8082                	ret

0000000080005c28 <printint>:
  int locking;
} pr;

static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign) {
    80005c28:	7179                	addi	sp,sp,-48
    80005c2a:	f406                	sd	ra,40(sp)
    80005c2c:	f022                	sd	s0,32(sp)
    80005c2e:	ec26                	sd	s1,24(sp)
    80005c30:	e84a                	sd	s2,16(sp)
    80005c32:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if (sign && (sign = xx < 0))
    80005c34:	c219                	beqz	a2,80005c3a <printint+0x12>
    80005c36:	08054763          	bltz	a0,80005cc4 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005c3a:	2501                	sext.w	a0,a0
    80005c3c:	4881                	li	a7,0
    80005c3e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c42:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c44:	2581                	sext.w	a1,a1
    80005c46:	00003617          	auipc	a2,0x3
    80005c4a:	bca60613          	addi	a2,a2,-1078 # 80008810 <digits>
    80005c4e:	883a                	mv	a6,a4
    80005c50:	2705                	addiw	a4,a4,1
    80005c52:	02b577bb          	remuw	a5,a0,a1
    80005c56:	1782                	slli	a5,a5,0x20
    80005c58:	9381                	srli	a5,a5,0x20
    80005c5a:	97b2                	add	a5,a5,a2
    80005c5c:	0007c783          	lbu	a5,0(a5)
    80005c60:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    80005c64:	0005079b          	sext.w	a5,a0
    80005c68:	02b5553b          	divuw	a0,a0,a1
    80005c6c:	0685                	addi	a3,a3,1
    80005c6e:	feb7f0e3          	bgeu	a5,a1,80005c4e <printint+0x26>

  if (sign) buf[i++] = '-';
    80005c72:	00088c63          	beqz	a7,80005c8a <printint+0x62>
    80005c76:	fe070793          	addi	a5,a4,-32
    80005c7a:	00878733          	add	a4,a5,s0
    80005c7e:	02d00793          	li	a5,45
    80005c82:	fef70823          	sb	a5,-16(a4)
    80005c86:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) consputc(buf[i]);
    80005c8a:	02e05763          	blez	a4,80005cb8 <printint+0x90>
    80005c8e:	fd040793          	addi	a5,s0,-48
    80005c92:	00e784b3          	add	s1,a5,a4
    80005c96:	fff78913          	addi	s2,a5,-1
    80005c9a:	993a                	add	s2,s2,a4
    80005c9c:	377d                	addiw	a4,a4,-1
    80005c9e:	1702                	slli	a4,a4,0x20
    80005ca0:	9301                	srli	a4,a4,0x20
    80005ca2:	40e90933          	sub	s2,s2,a4
    80005ca6:	fff4c503          	lbu	a0,-1(s1)
    80005caa:	00000097          	auipc	ra,0x0
    80005cae:	d5e080e7          	jalr	-674(ra) # 80005a08 <consputc>
    80005cb2:	14fd                	addi	s1,s1,-1
    80005cb4:	ff2499e3          	bne	s1,s2,80005ca6 <printint+0x7e>
}
    80005cb8:	70a2                	ld	ra,40(sp)
    80005cba:	7402                	ld	s0,32(sp)
    80005cbc:	64e2                	ld	s1,24(sp)
    80005cbe:	6942                	ld	s2,16(sp)
    80005cc0:	6145                	addi	sp,sp,48
    80005cc2:	8082                	ret
    x = -xx;
    80005cc4:	40a0053b          	negw	a0,a0
  if (sign && (sign = xx < 0))
    80005cc8:	4885                	li	a7,1
    x = -xx;
    80005cca:	bf95                	j	80005c3e <printint+0x16>

0000000080005ccc <panic>:
  va_end(ap);

  if (locking) release(&pr.lock);
}

void panic(char *s) {
    80005ccc:	1101                	addi	sp,sp,-32
    80005cce:	ec06                	sd	ra,24(sp)
    80005cd0:	e822                	sd	s0,16(sp)
    80005cd2:	e426                	sd	s1,8(sp)
    80005cd4:	1000                	addi	s0,sp,32
    80005cd6:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005cd8:	0001c797          	auipc	a5,0x1c
    80005cdc:	0407ac23          	sw	zero,88(a5) # 80021d30 <pr+0x18>
  printf("panic: ");
    80005ce0:	00003517          	auipc	a0,0x3
    80005ce4:	b0850513          	addi	a0,a0,-1272 # 800087e8 <syscalls+0x408>
    80005ce8:	00000097          	auipc	ra,0x0
    80005cec:	02e080e7          	jalr	46(ra) # 80005d16 <printf>
  printf(s);
    80005cf0:	8526                	mv	a0,s1
    80005cf2:	00000097          	auipc	ra,0x0
    80005cf6:	024080e7          	jalr	36(ra) # 80005d16 <printf>
  printf("\n");
    80005cfa:	00002517          	auipc	a0,0x2
    80005cfe:	52650513          	addi	a0,a0,1318 # 80008220 <etext+0x220>
    80005d02:	00000097          	auipc	ra,0x0
    80005d06:	014080e7          	jalr	20(ra) # 80005d16 <printf>
  panicked = 1;  // freeze uart output from other CPUs
    80005d0a:	4785                	li	a5,1
    80005d0c:	00003717          	auipc	a4,0x3
    80005d10:	bef72023          	sw	a5,-1056(a4) # 800088ec <panicked>
  for (;;)
    80005d14:	a001                	j	80005d14 <panic+0x48>

0000000080005d16 <printf>:
void printf(char *fmt, ...) {
    80005d16:	7131                	addi	sp,sp,-192
    80005d18:	fc86                	sd	ra,120(sp)
    80005d1a:	f8a2                	sd	s0,112(sp)
    80005d1c:	f4a6                	sd	s1,104(sp)
    80005d1e:	f0ca                	sd	s2,96(sp)
    80005d20:	ecce                	sd	s3,88(sp)
    80005d22:	e8d2                	sd	s4,80(sp)
    80005d24:	e4d6                	sd	s5,72(sp)
    80005d26:	e0da                	sd	s6,64(sp)
    80005d28:	fc5e                	sd	s7,56(sp)
    80005d2a:	f862                	sd	s8,48(sp)
    80005d2c:	f466                	sd	s9,40(sp)
    80005d2e:	f06a                	sd	s10,32(sp)
    80005d30:	ec6e                	sd	s11,24(sp)
    80005d32:	0100                	addi	s0,sp,128
    80005d34:	8a2a                	mv	s4,a0
    80005d36:	e40c                	sd	a1,8(s0)
    80005d38:	e810                	sd	a2,16(s0)
    80005d3a:	ec14                	sd	a3,24(s0)
    80005d3c:	f018                	sd	a4,32(s0)
    80005d3e:	f41c                	sd	a5,40(s0)
    80005d40:	03043823          	sd	a6,48(s0)
    80005d44:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d48:	0001cd97          	auipc	s11,0x1c
    80005d4c:	fe8dad83          	lw	s11,-24(s11) # 80021d30 <pr+0x18>
  if (locking) acquire(&pr.lock);
    80005d50:	020d9b63          	bnez	s11,80005d86 <printf+0x70>
  if (fmt == 0) panic("null fmt");
    80005d54:	040a0263          	beqz	s4,80005d98 <printf+0x82>
  va_start(ap, fmt);
    80005d58:	00840793          	addi	a5,s0,8
    80005d5c:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80005d60:	000a4503          	lbu	a0,0(s4)
    80005d64:	14050f63          	beqz	a0,80005ec2 <printf+0x1ac>
    80005d68:	4981                	li	s3,0
    if (c != '%') {
    80005d6a:	02500a93          	li	s5,37
    switch (c) {
    80005d6e:	07000b93          	li	s7,112
  consputc('x');
    80005d72:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d74:	00003b17          	auipc	s6,0x3
    80005d78:	a9cb0b13          	addi	s6,s6,-1380 # 80008810 <digits>
    switch (c) {
    80005d7c:	07300c93          	li	s9,115
    80005d80:	06400c13          	li	s8,100
    80005d84:	a82d                	j	80005dbe <printf+0xa8>
  if (locking) acquire(&pr.lock);
    80005d86:	0001c517          	auipc	a0,0x1c
    80005d8a:	f9250513          	addi	a0,a0,-110 # 80021d18 <pr>
    80005d8e:	00000097          	auipc	ra,0x0
    80005d92:	476080e7          	jalr	1142(ra) # 80006204 <acquire>
    80005d96:	bf7d                	j	80005d54 <printf+0x3e>
  if (fmt == 0) panic("null fmt");
    80005d98:	00003517          	auipc	a0,0x3
    80005d9c:	a6050513          	addi	a0,a0,-1440 # 800087f8 <syscalls+0x418>
    80005da0:	00000097          	auipc	ra,0x0
    80005da4:	f2c080e7          	jalr	-212(ra) # 80005ccc <panic>
      consputc(c);
    80005da8:	00000097          	auipc	ra,0x0
    80005dac:	c60080e7          	jalr	-928(ra) # 80005a08 <consputc>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80005db0:	2985                	addiw	s3,s3,1
    80005db2:	013a07b3          	add	a5,s4,s3
    80005db6:	0007c503          	lbu	a0,0(a5)
    80005dba:	10050463          	beqz	a0,80005ec2 <printf+0x1ac>
    if (c != '%') {
    80005dbe:	ff5515e3          	bne	a0,s5,80005da8 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005dc2:	2985                	addiw	s3,s3,1
    80005dc4:	013a07b3          	add	a5,s4,s3
    80005dc8:	0007c783          	lbu	a5,0(a5)
    80005dcc:	0007849b          	sext.w	s1,a5
    if (c == 0) break;
    80005dd0:	cbed                	beqz	a5,80005ec2 <printf+0x1ac>
    switch (c) {
    80005dd2:	05778a63          	beq	a5,s7,80005e26 <printf+0x110>
    80005dd6:	02fbf663          	bgeu	s7,a5,80005e02 <printf+0xec>
    80005dda:	09978863          	beq	a5,s9,80005e6a <printf+0x154>
    80005dde:	07800713          	li	a4,120
    80005de2:	0ce79563          	bne	a5,a4,80005eac <printf+0x196>
        printint(va_arg(ap, int), 16, 1);
    80005de6:	f8843783          	ld	a5,-120(s0)
    80005dea:	00878713          	addi	a4,a5,8
    80005dee:	f8e43423          	sd	a4,-120(s0)
    80005df2:	4605                	li	a2,1
    80005df4:	85ea                	mv	a1,s10
    80005df6:	4388                	lw	a0,0(a5)
    80005df8:	00000097          	auipc	ra,0x0
    80005dfc:	e30080e7          	jalr	-464(ra) # 80005c28 <printint>
        break;
    80005e00:	bf45                	j	80005db0 <printf+0x9a>
    switch (c) {
    80005e02:	09578f63          	beq	a5,s5,80005ea0 <printf+0x18a>
    80005e06:	0b879363          	bne	a5,s8,80005eac <printf+0x196>
        printint(va_arg(ap, int), 10, 1);
    80005e0a:	f8843783          	ld	a5,-120(s0)
    80005e0e:	00878713          	addi	a4,a5,8
    80005e12:	f8e43423          	sd	a4,-120(s0)
    80005e16:	4605                	li	a2,1
    80005e18:	45a9                	li	a1,10
    80005e1a:	4388                	lw	a0,0(a5)
    80005e1c:	00000097          	auipc	ra,0x0
    80005e20:	e0c080e7          	jalr	-500(ra) # 80005c28 <printint>
        break;
    80005e24:	b771                	j	80005db0 <printf+0x9a>
        printptr(va_arg(ap, uint64));
    80005e26:	f8843783          	ld	a5,-120(s0)
    80005e2a:	00878713          	addi	a4,a5,8
    80005e2e:	f8e43423          	sd	a4,-120(s0)
    80005e32:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005e36:	03000513          	li	a0,48
    80005e3a:	00000097          	auipc	ra,0x0
    80005e3e:	bce080e7          	jalr	-1074(ra) # 80005a08 <consputc>
  consputc('x');
    80005e42:	07800513          	li	a0,120
    80005e46:	00000097          	auipc	ra,0x0
    80005e4a:	bc2080e7          	jalr	-1086(ra) # 80005a08 <consputc>
    80005e4e:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e50:	03c95793          	srli	a5,s2,0x3c
    80005e54:	97da                	add	a5,a5,s6
    80005e56:	0007c503          	lbu	a0,0(a5)
    80005e5a:	00000097          	auipc	ra,0x0
    80005e5e:	bae080e7          	jalr	-1106(ra) # 80005a08 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e62:	0912                	slli	s2,s2,0x4
    80005e64:	34fd                	addiw	s1,s1,-1
    80005e66:	f4ed                	bnez	s1,80005e50 <printf+0x13a>
    80005e68:	b7a1                	j	80005db0 <printf+0x9a>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    80005e6a:	f8843783          	ld	a5,-120(s0)
    80005e6e:	00878713          	addi	a4,a5,8
    80005e72:	f8e43423          	sd	a4,-120(s0)
    80005e76:	6384                	ld	s1,0(a5)
    80005e78:	cc89                	beqz	s1,80005e92 <printf+0x17c>
        for (; *s; s++) consputc(*s);
    80005e7a:	0004c503          	lbu	a0,0(s1)
    80005e7e:	d90d                	beqz	a0,80005db0 <printf+0x9a>
    80005e80:	00000097          	auipc	ra,0x0
    80005e84:	b88080e7          	jalr	-1144(ra) # 80005a08 <consputc>
    80005e88:	0485                	addi	s1,s1,1
    80005e8a:	0004c503          	lbu	a0,0(s1)
    80005e8e:	f96d                	bnez	a0,80005e80 <printf+0x16a>
    80005e90:	b705                	j	80005db0 <printf+0x9a>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    80005e92:	00003497          	auipc	s1,0x3
    80005e96:	95e48493          	addi	s1,s1,-1698 # 800087f0 <syscalls+0x410>
        for (; *s; s++) consputc(*s);
    80005e9a:	02800513          	li	a0,40
    80005e9e:	b7cd                	j	80005e80 <printf+0x16a>
        consputc('%');
    80005ea0:	8556                	mv	a0,s5
    80005ea2:	00000097          	auipc	ra,0x0
    80005ea6:	b66080e7          	jalr	-1178(ra) # 80005a08 <consputc>
        break;
    80005eaa:	b719                	j	80005db0 <printf+0x9a>
        consputc('%');
    80005eac:	8556                	mv	a0,s5
    80005eae:	00000097          	auipc	ra,0x0
    80005eb2:	b5a080e7          	jalr	-1190(ra) # 80005a08 <consputc>
        consputc(c);
    80005eb6:	8526                	mv	a0,s1
    80005eb8:	00000097          	auipc	ra,0x0
    80005ebc:	b50080e7          	jalr	-1200(ra) # 80005a08 <consputc>
        break;
    80005ec0:	bdc5                	j	80005db0 <printf+0x9a>
  if (locking) release(&pr.lock);
    80005ec2:	020d9163          	bnez	s11,80005ee4 <printf+0x1ce>
}
    80005ec6:	70e6                	ld	ra,120(sp)
    80005ec8:	7446                	ld	s0,112(sp)
    80005eca:	74a6                	ld	s1,104(sp)
    80005ecc:	7906                	ld	s2,96(sp)
    80005ece:	69e6                	ld	s3,88(sp)
    80005ed0:	6a46                	ld	s4,80(sp)
    80005ed2:	6aa6                	ld	s5,72(sp)
    80005ed4:	6b06                	ld	s6,64(sp)
    80005ed6:	7be2                	ld	s7,56(sp)
    80005ed8:	7c42                	ld	s8,48(sp)
    80005eda:	7ca2                	ld	s9,40(sp)
    80005edc:	7d02                	ld	s10,32(sp)
    80005ede:	6de2                	ld	s11,24(sp)
    80005ee0:	6129                	addi	sp,sp,192
    80005ee2:	8082                	ret
  if (locking) release(&pr.lock);
    80005ee4:	0001c517          	auipc	a0,0x1c
    80005ee8:	e3450513          	addi	a0,a0,-460 # 80021d18 <pr>
    80005eec:	00000097          	auipc	ra,0x0
    80005ef0:	3cc080e7          	jalr	972(ra) # 800062b8 <release>
}
    80005ef4:	bfc9                	j	80005ec6 <printf+0x1b0>

0000000080005ef6 <printfinit>:
    ;
}

void printfinit(void) {
    80005ef6:	1101                	addi	sp,sp,-32
    80005ef8:	ec06                	sd	ra,24(sp)
    80005efa:	e822                	sd	s0,16(sp)
    80005efc:	e426                	sd	s1,8(sp)
    80005efe:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f00:	0001c497          	auipc	s1,0x1c
    80005f04:	e1848493          	addi	s1,s1,-488 # 80021d18 <pr>
    80005f08:	00003597          	auipc	a1,0x3
    80005f0c:	90058593          	addi	a1,a1,-1792 # 80008808 <syscalls+0x428>
    80005f10:	8526                	mv	a0,s1
    80005f12:	00000097          	auipc	ra,0x0
    80005f16:	262080e7          	jalr	610(ra) # 80006174 <initlock>
  pr.locking = 1;
    80005f1a:	4785                	li	a5,1
    80005f1c:	cc9c                	sw	a5,24(s1)
}
    80005f1e:	60e2                	ld	ra,24(sp)
    80005f20:	6442                	ld	s0,16(sp)
    80005f22:	64a2                	ld	s1,8(sp)
    80005f24:	6105                	addi	sp,sp,32
    80005f26:	8082                	ret

0000000080005f28 <uartinit>:

extern volatile int panicked;  // from printf.c

void uartstart();

void uartinit(void) {
    80005f28:	1141                	addi	sp,sp,-16
    80005f2a:	e406                	sd	ra,8(sp)
    80005f2c:	e022                	sd	s0,0(sp)
    80005f2e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f30:	100007b7          	lui	a5,0x10000
    80005f34:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f38:	f8000713          	li	a4,-128
    80005f3c:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f40:	470d                	li	a4,3
    80005f42:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f46:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f4a:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f4e:	469d                	li	a3,7
    80005f50:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f54:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f58:	00003597          	auipc	a1,0x3
    80005f5c:	8d058593          	addi	a1,a1,-1840 # 80008828 <digits+0x18>
    80005f60:	0001c517          	auipc	a0,0x1c
    80005f64:	dd850513          	addi	a0,a0,-552 # 80021d38 <uart_tx_lock>
    80005f68:	00000097          	auipc	ra,0x0
    80005f6c:	20c080e7          	jalr	524(ra) # 80006174 <initlock>
}
    80005f70:	60a2                	ld	ra,8(sp)
    80005f72:	6402                	ld	s0,0(sp)
    80005f74:	0141                	addi	sp,sp,16
    80005f76:	8082                	ret

0000000080005f78 <uartputc_sync>:

// alternate version of uartputc() that doesn't
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void uartputc_sync(int c) {
    80005f78:	1101                	addi	sp,sp,-32
    80005f7a:	ec06                	sd	ra,24(sp)
    80005f7c:	e822                	sd	s0,16(sp)
    80005f7e:	e426                	sd	s1,8(sp)
    80005f80:	1000                	addi	s0,sp,32
    80005f82:	84aa                	mv	s1,a0
  push_off();
    80005f84:	00000097          	auipc	ra,0x0
    80005f88:	234080e7          	jalr	564(ra) # 800061b8 <push_off>

  if (panicked) {
    80005f8c:	00003797          	auipc	a5,0x3
    80005f90:	9607a783          	lw	a5,-1696(a5) # 800088ec <panicked>
    for (;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f94:	10000737          	lui	a4,0x10000
  if (panicked) {
    80005f98:	c391                	beqz	a5,80005f9c <uartputc_sync+0x24>
    for (;;)
    80005f9a:	a001                	j	80005f9a <uartputc_sync+0x22>
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f9c:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005fa0:	0207f793          	andi	a5,a5,32
    80005fa4:	dfe5                	beqz	a5,80005f9c <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005fa6:	0ff4f513          	zext.b	a0,s1
    80005faa:	100007b7          	lui	a5,0x10000
    80005fae:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005fb2:	00000097          	auipc	ra,0x0
    80005fb6:	2a6080e7          	jalr	678(ra) # 80006258 <pop_off>
}
    80005fba:	60e2                	ld	ra,24(sp)
    80005fbc:	6442                	ld	s0,16(sp)
    80005fbe:	64a2                	ld	s1,8(sp)
    80005fc0:	6105                	addi	sp,sp,32
    80005fc2:	8082                	ret

0000000080005fc4 <uartstart>:
// in the transmit buffer, send it.
// caller must hold uart_tx_lock.
// called from both the top- and bottom-half.
void uartstart() {
  while (1) {
    if (uart_tx_w == uart_tx_r) {
    80005fc4:	00003797          	auipc	a5,0x3
    80005fc8:	92c7b783          	ld	a5,-1748(a5) # 800088f0 <uart_tx_r>
    80005fcc:	00003717          	auipc	a4,0x3
    80005fd0:	92c73703          	ld	a4,-1748(a4) # 800088f8 <uart_tx_w>
    80005fd4:	06f70a63          	beq	a4,a5,80006048 <uartstart+0x84>
void uartstart() {
    80005fd8:	7139                	addi	sp,sp,-64
    80005fda:	fc06                	sd	ra,56(sp)
    80005fdc:	f822                	sd	s0,48(sp)
    80005fde:	f426                	sd	s1,40(sp)
    80005fe0:	f04a                	sd	s2,32(sp)
    80005fe2:	ec4e                	sd	s3,24(sp)
    80005fe4:	e852                	sd	s4,16(sp)
    80005fe6:	e456                	sd	s5,8(sp)
    80005fe8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }

    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0) {
    80005fea:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }

    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fee:	0001ca17          	auipc	s4,0x1c
    80005ff2:	d4aa0a13          	addi	s4,s4,-694 # 80021d38 <uart_tx_lock>
    uart_tx_r += 1;
    80005ff6:	00003497          	auipc	s1,0x3
    80005ffa:	8fa48493          	addi	s1,s1,-1798 # 800088f0 <uart_tx_r>
    if (uart_tx_w == uart_tx_r) {
    80005ffe:	00003997          	auipc	s3,0x3
    80006002:	8fa98993          	addi	s3,s3,-1798 # 800088f8 <uart_tx_w>
    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0) {
    80006006:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000600a:	02077713          	andi	a4,a4,32
    8000600e:	c705                	beqz	a4,80006036 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006010:	01f7f713          	andi	a4,a5,31
    80006014:	9752                	add	a4,a4,s4
    80006016:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000601a:	0785                	addi	a5,a5,1
    8000601c:	e09c                	sd	a5,0(s1)

    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000601e:	8526                	mv	a0,s1
    80006020:	ffffb097          	auipc	ra,0xffffb
    80006024:	540080e7          	jalr	1344(ra) # 80001560 <wakeup>

    WriteReg(THR, c);
    80006028:	01590023          	sb	s5,0(s2)
    if (uart_tx_w == uart_tx_r) {
    8000602c:	609c                	ld	a5,0(s1)
    8000602e:	0009b703          	ld	a4,0(s3)
    80006032:	fcf71ae3          	bne	a4,a5,80006006 <uartstart+0x42>
  }
}
    80006036:	70e2                	ld	ra,56(sp)
    80006038:	7442                	ld	s0,48(sp)
    8000603a:	74a2                	ld	s1,40(sp)
    8000603c:	7902                	ld	s2,32(sp)
    8000603e:	69e2                	ld	s3,24(sp)
    80006040:	6a42                	ld	s4,16(sp)
    80006042:	6aa2                	ld	s5,8(sp)
    80006044:	6121                	addi	sp,sp,64
    80006046:	8082                	ret
    80006048:	8082                	ret

000000008000604a <uartputc>:
void uartputc(int c) {
    8000604a:	7179                	addi	sp,sp,-48
    8000604c:	f406                	sd	ra,40(sp)
    8000604e:	f022                	sd	s0,32(sp)
    80006050:	ec26                	sd	s1,24(sp)
    80006052:	e84a                	sd	s2,16(sp)
    80006054:	e44e                	sd	s3,8(sp)
    80006056:	e052                	sd	s4,0(sp)
    80006058:	1800                	addi	s0,sp,48
    8000605a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000605c:	0001c517          	auipc	a0,0x1c
    80006060:	cdc50513          	addi	a0,a0,-804 # 80021d38 <uart_tx_lock>
    80006064:	00000097          	auipc	ra,0x0
    80006068:	1a0080e7          	jalr	416(ra) # 80006204 <acquire>
  if (panicked) {
    8000606c:	00003797          	auipc	a5,0x3
    80006070:	8807a783          	lw	a5,-1920(a5) # 800088ec <panicked>
    80006074:	e7c9                	bnez	a5,800060fe <uartputc+0xb4>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    80006076:	00003717          	auipc	a4,0x3
    8000607a:	88273703          	ld	a4,-1918(a4) # 800088f8 <uart_tx_w>
    8000607e:	00003797          	auipc	a5,0x3
    80006082:	8727b783          	ld	a5,-1934(a5) # 800088f0 <uart_tx_r>
    80006086:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000608a:	0001c997          	auipc	s3,0x1c
    8000608e:	cae98993          	addi	s3,s3,-850 # 80021d38 <uart_tx_lock>
    80006092:	00003497          	auipc	s1,0x3
    80006096:	85e48493          	addi	s1,s1,-1954 # 800088f0 <uart_tx_r>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    8000609a:	00003917          	auipc	s2,0x3
    8000609e:	85e90913          	addi	s2,s2,-1954 # 800088f8 <uart_tx_w>
    800060a2:	00e79f63          	bne	a5,a4,800060c0 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800060a6:	85ce                	mv	a1,s3
    800060a8:	8526                	mv	a0,s1
    800060aa:	ffffb097          	auipc	ra,0xffffb
    800060ae:	452080e7          	jalr	1106(ra) # 800014fc <sleep>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    800060b2:	00093703          	ld	a4,0(s2)
    800060b6:	609c                	ld	a5,0(s1)
    800060b8:	02078793          	addi	a5,a5,32
    800060bc:	fee785e3          	beq	a5,a4,800060a6 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800060c0:	0001c497          	auipc	s1,0x1c
    800060c4:	c7848493          	addi	s1,s1,-904 # 80021d38 <uart_tx_lock>
    800060c8:	01f77793          	andi	a5,a4,31
    800060cc:	97a6                	add	a5,a5,s1
    800060ce:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800060d2:	0705                	addi	a4,a4,1
    800060d4:	00003797          	auipc	a5,0x3
    800060d8:	82e7b223          	sd	a4,-2012(a5) # 800088f8 <uart_tx_w>
  uartstart();
    800060dc:	00000097          	auipc	ra,0x0
    800060e0:	ee8080e7          	jalr	-280(ra) # 80005fc4 <uartstart>
  release(&uart_tx_lock);
    800060e4:	8526                	mv	a0,s1
    800060e6:	00000097          	auipc	ra,0x0
    800060ea:	1d2080e7          	jalr	466(ra) # 800062b8 <release>
}
    800060ee:	70a2                	ld	ra,40(sp)
    800060f0:	7402                	ld	s0,32(sp)
    800060f2:	64e2                	ld	s1,24(sp)
    800060f4:	6942                	ld	s2,16(sp)
    800060f6:	69a2                	ld	s3,8(sp)
    800060f8:	6a02                	ld	s4,0(sp)
    800060fa:	6145                	addi	sp,sp,48
    800060fc:	8082                	ret
    for (;;)
    800060fe:	a001                	j	800060fe <uartputc+0xb4>

0000000080006100 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int uartgetc(void) {
    80006100:	1141                	addi	sp,sp,-16
    80006102:	e422                	sd	s0,8(sp)
    80006104:	0800                	addi	s0,sp,16
  if (ReadReg(LSR) & 0x01) {
    80006106:	100007b7          	lui	a5,0x10000
    8000610a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000610e:	8b85                	andi	a5,a5,1
    80006110:	cb81                	beqz	a5,80006120 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006112:	100007b7          	lui	a5,0x10000
    80006116:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000611a:	6422                	ld	s0,8(sp)
    8000611c:	0141                	addi	sp,sp,16
    8000611e:	8082                	ret
    return -1;
    80006120:	557d                	li	a0,-1
    80006122:	bfe5                	j	8000611a <uartgetc+0x1a>

0000000080006124 <uartintr>:

// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void uartintr(void) {
    80006124:	1101                	addi	sp,sp,-32
    80006126:	ec06                	sd	ra,24(sp)
    80006128:	e822                	sd	s0,16(sp)
    8000612a:	e426                	sd	s1,8(sp)
    8000612c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while (1) {
    int c = uartgetc();
    if (c == -1) break;
    8000612e:	54fd                	li	s1,-1
    80006130:	a029                	j	8000613a <uartintr+0x16>
    consoleintr(c);
    80006132:	00000097          	auipc	ra,0x0
    80006136:	918080e7          	jalr	-1768(ra) # 80005a4a <consoleintr>
    int c = uartgetc();
    8000613a:	00000097          	auipc	ra,0x0
    8000613e:	fc6080e7          	jalr	-58(ra) # 80006100 <uartgetc>
    if (c == -1) break;
    80006142:	fe9518e3          	bne	a0,s1,80006132 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006146:	0001c497          	auipc	s1,0x1c
    8000614a:	bf248493          	addi	s1,s1,-1038 # 80021d38 <uart_tx_lock>
    8000614e:	8526                	mv	a0,s1
    80006150:	00000097          	auipc	ra,0x0
    80006154:	0b4080e7          	jalr	180(ra) # 80006204 <acquire>
  uartstart();
    80006158:	00000097          	auipc	ra,0x0
    8000615c:	e6c080e7          	jalr	-404(ra) # 80005fc4 <uartstart>
  release(&uart_tx_lock);
    80006160:	8526                	mv	a0,s1
    80006162:	00000097          	auipc	ra,0x0
    80006166:	156080e7          	jalr	342(ra) # 800062b8 <release>
}
    8000616a:	60e2                	ld	ra,24(sp)
    8000616c:	6442                	ld	s0,16(sp)
    8000616e:	64a2                	ld	s1,8(sp)
    80006170:	6105                	addi	sp,sp,32
    80006172:	8082                	ret

0000000080006174 <initlock>:
#include "spinlock.h"
#include "riscv.h"
#include "proc.h"
#include "defs.h"

void initlock(struct spinlock *lk, char *name) {
    80006174:	1141                	addi	sp,sp,-16
    80006176:	e422                	sd	s0,8(sp)
    80006178:	0800                	addi	s0,sp,16
  lk->name = name;
    8000617a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000617c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006180:	00053823          	sd	zero,16(a0)
}
    80006184:	6422                	ld	s0,8(sp)
    80006186:	0141                	addi	sp,sp,16
    80006188:	8082                	ret

000000008000618a <holding>:

// Check whether this cpu is holding the lock.
// Interrupts must be off.
int holding(struct spinlock *lk) {
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000618a:	411c                	lw	a5,0(a0)
    8000618c:	e399                	bnez	a5,80006192 <holding+0x8>
    8000618e:	4501                	li	a0,0
  return r;
}
    80006190:	8082                	ret
int holding(struct spinlock *lk) {
    80006192:	1101                	addi	sp,sp,-32
    80006194:	ec06                	sd	ra,24(sp)
    80006196:	e822                	sd	s0,16(sp)
    80006198:	e426                	sd	s1,8(sp)
    8000619a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000619c:	6904                	ld	s1,16(a0)
    8000619e:	ffffb097          	auipc	ra,0xffffb
    800061a2:	c9a080e7          	jalr	-870(ra) # 80000e38 <mycpu>
    800061a6:	40a48533          	sub	a0,s1,a0
    800061aa:	00153513          	seqz	a0,a0
}
    800061ae:	60e2                	ld	ra,24(sp)
    800061b0:	6442                	ld	s0,16(sp)
    800061b2:	64a2                	ld	s1,8(sp)
    800061b4:	6105                	addi	sp,sp,32
    800061b6:	8082                	ret

00000000800061b8 <push_off>:

// push_off/pop_off are like intr_off()/intr_on() except that they are matched:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void push_off(void) {
    800061b8:	1101                	addi	sp,sp,-32
    800061ba:	ec06                	sd	ra,24(sp)
    800061bc:	e822                	sd	s0,16(sp)
    800061be:	e426                	sd	s1,8(sp)
    800061c0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800061c2:	100024f3          	csrr	s1,sstatus
    800061c6:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    800061ca:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800061cc:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if (mycpu()->noff == 0) mycpu()->intena = old;
    800061d0:	ffffb097          	auipc	ra,0xffffb
    800061d4:	c68080e7          	jalr	-920(ra) # 80000e38 <mycpu>
    800061d8:	5d3c                	lw	a5,120(a0)
    800061da:	cf89                	beqz	a5,800061f4 <push_off+0x3c>
  mycpu()->noff += 1;
    800061dc:	ffffb097          	auipc	ra,0xffffb
    800061e0:	c5c080e7          	jalr	-932(ra) # 80000e38 <mycpu>
    800061e4:	5d3c                	lw	a5,120(a0)
    800061e6:	2785                	addiw	a5,a5,1
    800061e8:	dd3c                	sw	a5,120(a0)
}
    800061ea:	60e2                	ld	ra,24(sp)
    800061ec:	6442                	ld	s0,16(sp)
    800061ee:	64a2                	ld	s1,8(sp)
    800061f0:	6105                	addi	sp,sp,32
    800061f2:	8082                	ret
  if (mycpu()->noff == 0) mycpu()->intena = old;
    800061f4:	ffffb097          	auipc	ra,0xffffb
    800061f8:	c44080e7          	jalr	-956(ra) # 80000e38 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061fc:	8085                	srli	s1,s1,0x1
    800061fe:	8885                	andi	s1,s1,1
    80006200:	dd64                	sw	s1,124(a0)
    80006202:	bfe9                	j	800061dc <push_off+0x24>

0000000080006204 <acquire>:
void acquire(struct spinlock *lk) {
    80006204:	1101                	addi	sp,sp,-32
    80006206:	ec06                	sd	ra,24(sp)
    80006208:	e822                	sd	s0,16(sp)
    8000620a:	e426                	sd	s1,8(sp)
    8000620c:	1000                	addi	s0,sp,32
    8000620e:	84aa                	mv	s1,a0
  push_off();  // disable interrupts to avoid deadlock.
    80006210:	00000097          	auipc	ra,0x0
    80006214:	fa8080e7          	jalr	-88(ra) # 800061b8 <push_off>
  if (holding(lk)) panic("acquire");
    80006218:	8526                	mv	a0,s1
    8000621a:	00000097          	auipc	ra,0x0
    8000621e:	f70080e7          	jalr	-144(ra) # 8000618a <holding>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006222:	4705                	li	a4,1
  if (holding(lk)) panic("acquire");
    80006224:	e115                	bnez	a0,80006248 <acquire+0x44>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006226:	87ba                	mv	a5,a4
    80006228:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000622c:	2781                	sext.w	a5,a5
    8000622e:	ffe5                	bnez	a5,80006226 <acquire+0x22>
  __sync_synchronize();
    80006230:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006234:	ffffb097          	auipc	ra,0xffffb
    80006238:	c04080e7          	jalr	-1020(ra) # 80000e38 <mycpu>
    8000623c:	e888                	sd	a0,16(s1)
}
    8000623e:	60e2                	ld	ra,24(sp)
    80006240:	6442                	ld	s0,16(sp)
    80006242:	64a2                	ld	s1,8(sp)
    80006244:	6105                	addi	sp,sp,32
    80006246:	8082                	ret
  if (holding(lk)) panic("acquire");
    80006248:	00002517          	auipc	a0,0x2
    8000624c:	5e850513          	addi	a0,a0,1512 # 80008830 <digits+0x20>
    80006250:	00000097          	auipc	ra,0x0
    80006254:	a7c080e7          	jalr	-1412(ra) # 80005ccc <panic>

0000000080006258 <pop_off>:

void pop_off(void) {
    80006258:	1141                	addi	sp,sp,-16
    8000625a:	e406                	sd	ra,8(sp)
    8000625c:	e022                	sd	s0,0(sp)
    8000625e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006260:	ffffb097          	auipc	ra,0xffffb
    80006264:	bd8080e7          	jalr	-1064(ra) # 80000e38 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80006268:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000626c:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("pop_off - interruptible");
    8000626e:	e78d                	bnez	a5,80006298 <pop_off+0x40>
  if (c->noff < 1) panic("pop_off");
    80006270:	5d3c                	lw	a5,120(a0)
    80006272:	02f05b63          	blez	a5,800062a8 <pop_off+0x50>
  c->noff -= 1;
    80006276:	37fd                	addiw	a5,a5,-1
    80006278:	0007871b          	sext.w	a4,a5
    8000627c:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena) intr_on();
    8000627e:	eb09                	bnez	a4,80006290 <pop_off+0x38>
    80006280:	5d7c                	lw	a5,124(a0)
    80006282:	c799                	beqz	a5,80006290 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80006284:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80006288:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000628c:	10079073          	csrw	sstatus,a5
}
    80006290:	60a2                	ld	ra,8(sp)
    80006292:	6402                	ld	s0,0(sp)
    80006294:	0141                	addi	sp,sp,16
    80006296:	8082                	ret
  if (intr_get()) panic("pop_off - interruptible");
    80006298:	00002517          	auipc	a0,0x2
    8000629c:	5a050513          	addi	a0,a0,1440 # 80008838 <digits+0x28>
    800062a0:	00000097          	auipc	ra,0x0
    800062a4:	a2c080e7          	jalr	-1492(ra) # 80005ccc <panic>
  if (c->noff < 1) panic("pop_off");
    800062a8:	00002517          	auipc	a0,0x2
    800062ac:	5a850513          	addi	a0,a0,1448 # 80008850 <digits+0x40>
    800062b0:	00000097          	auipc	ra,0x0
    800062b4:	a1c080e7          	jalr	-1508(ra) # 80005ccc <panic>

00000000800062b8 <release>:
void release(struct spinlock *lk) {
    800062b8:	1101                	addi	sp,sp,-32
    800062ba:	ec06                	sd	ra,24(sp)
    800062bc:	e822                	sd	s0,16(sp)
    800062be:	e426                	sd	s1,8(sp)
    800062c0:	1000                	addi	s0,sp,32
    800062c2:	84aa                	mv	s1,a0
  if (!holding(lk)) panic("release");
    800062c4:	00000097          	auipc	ra,0x0
    800062c8:	ec6080e7          	jalr	-314(ra) # 8000618a <holding>
    800062cc:	c115                	beqz	a0,800062f0 <release+0x38>
  lk->cpu = 0;
    800062ce:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062d2:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062d6:	0f50000f          	fence	iorw,ow
    800062da:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800062de:	00000097          	auipc	ra,0x0
    800062e2:	f7a080e7          	jalr	-134(ra) # 80006258 <pop_off>
}
    800062e6:	60e2                	ld	ra,24(sp)
    800062e8:	6442                	ld	s0,16(sp)
    800062ea:	64a2                	ld	s1,8(sp)
    800062ec:	6105                	addi	sp,sp,32
    800062ee:	8082                	ret
  if (!holding(lk)) panic("release");
    800062f0:	00002517          	auipc	a0,0x2
    800062f4:	56850513          	addi	a0,a0,1384 # 80008858 <digits+0x48>
    800062f8:	00000097          	auipc	ra,0x0
    800062fc:	9d4080e7          	jalr	-1580(ra) # 80005ccc <panic>
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
