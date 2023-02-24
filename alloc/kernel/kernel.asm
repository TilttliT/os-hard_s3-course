
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	9a013103          	ld	sp,-1632(sp) # 800089a0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	1ba060ef          	jal	ra,800061d0 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kinit>:
#include "riscv.h"
#include "defs.h"

extern char end[];  // first address after kernel.
                    // defined by kernel.ld.
void kinit() {
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
  char *p = (char *)PGROUNDUP((uint64)end);
  bd_init(p, (void *)PHYSTOP);
    80000024:	45c5                	li	a1,17
    80000026:	05ee                	slli	a1,a1,0x1b
    80000028:	0001c517          	auipc	a0,0x1c
    8000002c:	4d750513          	addi	a0,a0,1239 # 8001c4ff <end+0xfff>
    80000030:	77fd                	lui	a5,0xfffff
    80000032:	8d7d                	and	a0,a0,a5
    80000034:	00006097          	auipc	ra,0x6
    80000038:	e28080e7          	jalr	-472(ra) # 80005e5c <bd_init>
}
    8000003c:	60a2                	ld	ra,8(sp)
    8000003e:	6402                	ld	s0,0(sp)
    80000040:	0141                	addi	sp,sp,16
    80000042:	8082                	ret

0000000080000044 <kfree>:

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa) { bd_free(pa); }
    80000044:	1141                	addi	sp,sp,-16
    80000046:	e406                	sd	ra,8(sp)
    80000048:	e022                	sd	s0,0(sp)
    8000004a:	0800                	addi	s0,sp,16
    8000004c:	00006097          	auipc	ra,0x6
    80000050:	930080e7          	jalr	-1744(ra) # 8000597c <bd_free>
    80000054:	60a2                	ld	ra,8(sp)
    80000056:	6402                	ld	s0,0(sp)
    80000058:	0141                	addi	sp,sp,16
    8000005a:	8082                	ret

000000008000005c <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void) { return bd_malloc(PGSIZE); }
    8000005c:	1141                	addi	sp,sp,-16
    8000005e:	e406                	sd	ra,8(sp)
    80000060:	e022                	sd	s0,0(sp)
    80000062:	0800                	addi	s0,sp,16
    80000064:	6505                	lui	a0,0x1
    80000066:	00005097          	auipc	ra,0x5
    8000006a:	718080e7          	jalr	1816(ra) # 8000577e <bd_malloc>
    8000006e:	60a2                	ld	ra,8(sp)
    80000070:	6402                	ld	s0,0(sp)
    80000072:	0141                	addi	sp,sp,16
    80000074:	8082                	ret

0000000080000076 <memset>:
#include "types.h"

void *memset(void *dst, int c, uint n) {
    80000076:	1141                	addi	sp,sp,-16
    80000078:	e422                	sd	s0,8(sp)
    8000007a:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    8000007c:	ca19                	beqz	a2,80000092 <memset+0x1c>
    8000007e:	87aa                	mv	a5,a0
    80000080:	1602                	slli	a2,a2,0x20
    80000082:	9201                	srli	a2,a2,0x20
    80000084:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000088:	00b78023          	sb	a1,0(a5) # fffffffffffff000 <end+0xffffffff7ffe3b00>
  for (i = 0; i < n; i++) {
    8000008c:	0785                	addi	a5,a5,1
    8000008e:	fee79de3          	bne	a5,a4,80000088 <memset+0x12>
  }
  return dst;
}
    80000092:	6422                	ld	s0,8(sp)
    80000094:	0141                	addi	sp,sp,16
    80000096:	8082                	ret

0000000080000098 <memcmp>:

int memcmp(const void *v1, const void *v2, uint n) {
    80000098:	1141                	addi	sp,sp,-16
    8000009a:	e422                	sd	s0,8(sp)
    8000009c:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    8000009e:	ca05                	beqz	a2,800000ce <memcmp+0x36>
    800000a0:	fff6069b          	addiw	a3,a2,-1
    800000a4:	1682                	slli	a3,a3,0x20
    800000a6:	9281                	srli	a3,a3,0x20
    800000a8:	0685                	addi	a3,a3,1
    800000aa:	96aa                	add	a3,a3,a0
    if (*s1 != *s2) return *s1 - *s2;
    800000ac:	00054783          	lbu	a5,0(a0) # 1000 <_entry-0x7ffff000>
    800000b0:	0005c703          	lbu	a4,0(a1)
    800000b4:	00e79863          	bne	a5,a4,800000c4 <memcmp+0x2c>
    s1++, s2++;
    800000b8:	0505                	addi	a0,a0,1
    800000ba:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    800000bc:	fed518e3          	bne	a0,a3,800000ac <memcmp+0x14>
  }

  return 0;
    800000c0:	4501                	li	a0,0
    800000c2:	a019                	j	800000c8 <memcmp+0x30>
    if (*s1 != *s2) return *s1 - *s2;
    800000c4:	40e7853b          	subw	a0,a5,a4
}
    800000c8:	6422                	ld	s0,8(sp)
    800000ca:	0141                	addi	sp,sp,16
    800000cc:	8082                	ret
  return 0;
    800000ce:	4501                	li	a0,0
    800000d0:	bfe5                	j	800000c8 <memcmp+0x30>

00000000800000d2 <memmove>:

void *memmove(void *dst, const void *src, uint n) {
    800000d2:	1141                	addi	sp,sp,-16
    800000d4:	e422                	sd	s0,8(sp)
    800000d6:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0) return dst;
    800000d8:	c205                	beqz	a2,800000f8 <memmove+0x26>

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    800000da:	02a5e263          	bltu	a1,a0,800000fe <memmove+0x2c>
    s += n;
    d += n;
    while (n-- > 0) *--d = *--s;
  } else
    while (n-- > 0) *d++ = *s++;
    800000de:	1602                	slli	a2,a2,0x20
    800000e0:	9201                	srli	a2,a2,0x20
    800000e2:	00c587b3          	add	a5,a1,a2
void *memmove(void *dst, const void *src, uint n) {
    800000e6:	872a                	mv	a4,a0
    while (n-- > 0) *d++ = *s++;
    800000e8:	0585                	addi	a1,a1,1
    800000ea:	0705                	addi	a4,a4,1
    800000ec:	fff5c683          	lbu	a3,-1(a1)
    800000f0:	fed70fa3          	sb	a3,-1(a4)
    800000f4:	fef59ae3          	bne	a1,a5,800000e8 <memmove+0x16>

  return dst;
}
    800000f8:	6422                	ld	s0,8(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret
  if (s < d && s + n > d) {
    800000fe:	02061693          	slli	a3,a2,0x20
    80000102:	9281                	srli	a3,a3,0x20
    80000104:	00d58733          	add	a4,a1,a3
    80000108:	fce57be3          	bgeu	a0,a4,800000de <memmove+0xc>
    d += n;
    8000010c:	96aa                	add	a3,a3,a0
    while (n-- > 0) *--d = *--s;
    8000010e:	fff6079b          	addiw	a5,a2,-1
    80000112:	1782                	slli	a5,a5,0x20
    80000114:	9381                	srli	a5,a5,0x20
    80000116:	fff7c793          	not	a5,a5
    8000011a:	97ba                	add	a5,a5,a4
    8000011c:	177d                	addi	a4,a4,-1
    8000011e:	16fd                	addi	a3,a3,-1
    80000120:	00074603          	lbu	a2,0(a4)
    80000124:	00c68023          	sb	a2,0(a3)
    80000128:	fee79ae3          	bne	a5,a4,8000011c <memmove+0x4a>
    8000012c:	b7f1                	j	800000f8 <memmove+0x26>

000000008000012e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n) {
    8000012e:	1141                	addi	sp,sp,-16
    80000130:	e406                	sd	ra,8(sp)
    80000132:	e022                	sd	s0,0(sp)
    80000134:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000136:	00000097          	auipc	ra,0x0
    8000013a:	f9c080e7          	jalr	-100(ra) # 800000d2 <memmove>
}
    8000013e:	60a2                	ld	ra,8(sp)
    80000140:	6402                	ld	s0,0(sp)
    80000142:	0141                	addi	sp,sp,16
    80000144:	8082                	ret

0000000080000146 <strncmp>:

int strncmp(const char *p, const char *q, uint n) {
    80000146:	1141                	addi	sp,sp,-16
    80000148:	e422                	sd	s0,8(sp)
    8000014a:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q) n--, p++, q++;
    8000014c:	ce11                	beqz	a2,80000168 <strncmp+0x22>
    8000014e:	00054783          	lbu	a5,0(a0)
    80000152:	cf89                	beqz	a5,8000016c <strncmp+0x26>
    80000154:	0005c703          	lbu	a4,0(a1)
    80000158:	00f71a63          	bne	a4,a5,8000016c <strncmp+0x26>
    8000015c:	367d                	addiw	a2,a2,-1
    8000015e:	0505                	addi	a0,a0,1
    80000160:	0585                	addi	a1,a1,1
    80000162:	f675                	bnez	a2,8000014e <strncmp+0x8>
  if (n == 0) return 0;
    80000164:	4501                	li	a0,0
    80000166:	a809                	j	80000178 <strncmp+0x32>
    80000168:	4501                	li	a0,0
    8000016a:	a039                	j	80000178 <strncmp+0x32>
    8000016c:	ca09                	beqz	a2,8000017e <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    8000016e:	00054503          	lbu	a0,0(a0)
    80000172:	0005c783          	lbu	a5,0(a1)
    80000176:	9d1d                	subw	a0,a0,a5
}
    80000178:	6422                	ld	s0,8(sp)
    8000017a:	0141                	addi	sp,sp,16
    8000017c:	8082                	ret
  if (n == 0) return 0;
    8000017e:	4501                	li	a0,0
    80000180:	bfe5                	j	80000178 <strncmp+0x32>

0000000080000182 <strncpy>:

char *strncpy(char *s, const char *t, int n) {
    80000182:	1141                	addi	sp,sp,-16
    80000184:	e422                	sd	s0,8(sp)
    80000186:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    80000188:	872a                	mv	a4,a0
    8000018a:	8832                	mv	a6,a2
    8000018c:	367d                	addiw	a2,a2,-1
    8000018e:	01005963          	blez	a6,800001a0 <strncpy+0x1e>
    80000192:	0705                	addi	a4,a4,1
    80000194:	0005c783          	lbu	a5,0(a1)
    80000198:	fef70fa3          	sb	a5,-1(a4)
    8000019c:	0585                	addi	a1,a1,1
    8000019e:	f7f5                	bnez	a5,8000018a <strncpy+0x8>
    ;
  while (n-- > 0) *s++ = 0;
    800001a0:	86ba                	mv	a3,a4
    800001a2:	00c05c63          	blez	a2,800001ba <strncpy+0x38>
    800001a6:	0685                	addi	a3,a3,1
    800001a8:	fe068fa3          	sb	zero,-1(a3)
    800001ac:	40d707bb          	subw	a5,a4,a3
    800001b0:	37fd                	addiw	a5,a5,-1
    800001b2:	010787bb          	addw	a5,a5,a6
    800001b6:	fef048e3          	bgtz	a5,800001a6 <strncpy+0x24>
  return os;
}
    800001ba:	6422                	ld	s0,8(sp)
    800001bc:	0141                	addi	sp,sp,16
    800001be:	8082                	ret

00000000800001c0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n) {
    800001c0:	1141                	addi	sp,sp,-16
    800001c2:	e422                	sd	s0,8(sp)
    800001c4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0) return os;
    800001c6:	02c05363          	blez	a2,800001ec <safestrcpy+0x2c>
    800001ca:	fff6069b          	addiw	a3,a2,-1
    800001ce:	1682                	slli	a3,a3,0x20
    800001d0:	9281                	srli	a3,a3,0x20
    800001d2:	96ae                	add	a3,a3,a1
    800001d4:	87aa                	mv	a5,a0
  while (--n > 0 && (*s++ = *t++) != 0)
    800001d6:	00d58963          	beq	a1,a3,800001e8 <safestrcpy+0x28>
    800001da:	0585                	addi	a1,a1,1
    800001dc:	0785                	addi	a5,a5,1
    800001de:	fff5c703          	lbu	a4,-1(a1)
    800001e2:	fee78fa3          	sb	a4,-1(a5)
    800001e6:	fb65                	bnez	a4,800001d6 <safestrcpy+0x16>
    ;
  *s = 0;
    800001e8:	00078023          	sb	zero,0(a5)
  return os;
}
    800001ec:	6422                	ld	s0,8(sp)
    800001ee:	0141                	addi	sp,sp,16
    800001f0:	8082                	ret

00000000800001f2 <strlen>:

int strlen(const char *s) {
    800001f2:	1141                	addi	sp,sp,-16
    800001f4:	e422                	sd	s0,8(sp)
    800001f6:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    800001f8:	00054783          	lbu	a5,0(a0)
    800001fc:	cf91                	beqz	a5,80000218 <strlen+0x26>
    800001fe:	0505                	addi	a0,a0,1
    80000200:	87aa                	mv	a5,a0
    80000202:	4685                	li	a3,1
    80000204:	9e89                	subw	a3,a3,a0
    80000206:	00f6853b          	addw	a0,a3,a5
    8000020a:	0785                	addi	a5,a5,1
    8000020c:	fff7c703          	lbu	a4,-1(a5)
    80000210:	fb7d                	bnez	a4,80000206 <strlen+0x14>
    ;
  return n;
}
    80000212:	6422                	ld	s0,8(sp)
    80000214:	0141                	addi	sp,sp,16
    80000216:	8082                	ret
  for (n = 0; s[n]; n++)
    80000218:	4501                	li	a0,0
    8000021a:	bfe5                	j	80000212 <strlen+0x20>

000000008000021c <main>:
#include "defs.h"

volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void main() {
    8000021c:	1141                	addi	sp,sp,-16
    8000021e:	e406                	sd	ra,8(sp)
    80000220:	e022                	sd	s0,0(sp)
    80000222:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80000224:	00001097          	auipc	ra,0x1
    80000228:	a1a080e7          	jalr	-1510(ra) # 80000c3e <cpuid>
    virtio_disk_init();  // emulated hard disk
    userinit();          // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while (started == 0)
    8000022c:	00008717          	auipc	a4,0x8
    80000230:	79470713          	addi	a4,a4,1940 # 800089c0 <started>
  if (cpuid() == 0) {
    80000234:	c139                	beqz	a0,8000027a <main+0x5e>
    while (started == 0)
    80000236:	431c                	lw	a5,0(a4)
    80000238:	2781                	sext.w	a5,a5
    8000023a:	dff5                	beqz	a5,80000236 <main+0x1a>
      ;
    __sync_synchronize();
    8000023c:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000240:	00001097          	auipc	ra,0x1
    80000244:	9fe080e7          	jalr	-1538(ra) # 80000c3e <cpuid>
    80000248:	85aa                	mv	a1,a0
    8000024a:	00008517          	auipc	a0,0x8
    8000024e:	dce50513          	addi	a0,a0,-562 # 80008018 <etext+0x18>
    80000252:	00006097          	auipc	ra,0x6
    80000256:	47c080e7          	jalr	1148(ra) # 800066ce <printf>
    kvminithart();   // turn on paging
    8000025a:	00000097          	auipc	ra,0x0
    8000025e:	0d8080e7          	jalr	216(ra) # 80000332 <kvminithart>
    trapinithart();  // install kernel trap vector
    80000262:	00001097          	auipc	ra,0x1
    80000266:	726080e7          	jalr	1830(ra) # 80001988 <trapinithart>
    plicinithart();  // ask PLIC for device interrupts
    8000026a:	00005097          	auipc	ra,0x5
    8000026e:	c36080e7          	jalr	-970(ra) # 80004ea0 <plicinithart>
  }

  scheduler();
    80000272:	00001097          	auipc	ra,0x1
    80000276:	f22080e7          	jalr	-222(ra) # 80001194 <scheduler>
    consoleinit();
    8000027a:	00006097          	auipc	ra,0x6
    8000027e:	31a080e7          	jalr	794(ra) # 80006594 <consoleinit>
    printfinit();
    80000282:	00006097          	auipc	ra,0x6
    80000286:	62c080e7          	jalr	1580(ra) # 800068ae <printfinit>
    printf("\n");
    8000028a:	00008517          	auipc	a0,0x8
    8000028e:	d9e50513          	addi	a0,a0,-610 # 80008028 <etext+0x28>
    80000292:	00006097          	auipc	ra,0x6
    80000296:	43c080e7          	jalr	1084(ra) # 800066ce <printf>
    printf("xv6 kernel is booting\n");
    8000029a:	00008517          	auipc	a0,0x8
    8000029e:	d6650513          	addi	a0,a0,-666 # 80008000 <etext>
    800002a2:	00006097          	auipc	ra,0x6
    800002a6:	42c080e7          	jalr	1068(ra) # 800066ce <printf>
    printf("\n");
    800002aa:	00008517          	auipc	a0,0x8
    800002ae:	d7e50513          	addi	a0,a0,-642 # 80008028 <etext+0x28>
    800002b2:	00006097          	auipc	ra,0x6
    800002b6:	41c080e7          	jalr	1052(ra) # 800066ce <printf>
    kinit();             // physical page allocator
    800002ba:	00000097          	auipc	ra,0x0
    800002be:	d62080e7          	jalr	-670(ra) # 8000001c <kinit>
    kvminit();           // create kernel page table
    800002c2:	00000097          	auipc	ra,0x0
    800002c6:	326080e7          	jalr	806(ra) # 800005e8 <kvminit>
    kvminithart();       // turn on paging
    800002ca:	00000097          	auipc	ra,0x0
    800002ce:	068080e7          	jalr	104(ra) # 80000332 <kvminithart>
    procinit();          // process table
    800002d2:	00001097          	auipc	ra,0x1
    800002d6:	91c080e7          	jalr	-1764(ra) # 80000bee <procinit>
    trapinit();          // trap vectors
    800002da:	00001097          	auipc	ra,0x1
    800002de:	686080e7          	jalr	1670(ra) # 80001960 <trapinit>
    trapinithart();      // install kernel trap vector
    800002e2:	00001097          	auipc	ra,0x1
    800002e6:	6a6080e7          	jalr	1702(ra) # 80001988 <trapinithart>
    plicinit();          // set up interrupt controller
    800002ea:	00005097          	auipc	ra,0x5
    800002ee:	ba0080e7          	jalr	-1120(ra) # 80004e8a <plicinit>
    plicinithart();      // ask PLIC for device interrupts
    800002f2:	00005097          	auipc	ra,0x5
    800002f6:	bae080e7          	jalr	-1106(ra) # 80004ea0 <plicinithart>
    binit();             // buffer cache
    800002fa:	00002097          	auipc	ra,0x2
    800002fe:	dca080e7          	jalr	-566(ra) # 800020c4 <binit>
    iinit();             // inode table
    80000302:	00002097          	auipc	ra,0x2
    80000306:	46a080e7          	jalr	1130(ra) # 8000276c <iinit>
    fileinit();          // file table
    8000030a:	00003097          	auipc	ra,0x3
    8000030e:	410080e7          	jalr	1040(ra) # 8000371a <fileinit>
    virtio_disk_init();  // emulated hard disk
    80000312:	00005097          	auipc	ra,0x5
    80000316:	c96080e7          	jalr	-874(ra) # 80004fa8 <virtio_disk_init>
    userinit();          // first user process
    8000031a:	00001097          	auipc	ra,0x1
    8000031e:	c90080e7          	jalr	-880(ra) # 80000faa <userinit>
    __sync_synchronize();
    80000322:	0ff0000f          	fence
    started = 1;
    80000326:	4785                	li	a5,1
    80000328:	00008717          	auipc	a4,0x8
    8000032c:	68f72c23          	sw	a5,1688(a4) # 800089c0 <started>
    80000330:	b789                	j	80000272 <main+0x56>

0000000080000332 <kvminithart>:
// Initialize the one kernel_pagetable
void kvminit(void) { kernel_pagetable = kvmmake(); }

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart() {
    80000332:	1141                	addi	sp,sp,-16
    80000334:	e422                	sd	s0,8(sp)
    80000336:	0800                	addi	s0,sp,16
}

// flush the TLB.
static inline void sfence_vma() {
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000338:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000033c:	00008797          	auipc	a5,0x8
    80000340:	68c7b783          	ld	a5,1676(a5) # 800089c8 <kernel_pagetable>
    80000344:	83b1                	srli	a5,a5,0xc
    80000346:	577d                	li	a4,-1
    80000348:	177e                	slli	a4,a4,0x3f
    8000034a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    8000034c:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000350:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000354:	6422                	ld	s0,8(sp)
    80000356:	0141                	addi	sp,sp,16
    80000358:	8082                	ret

000000008000035a <walk>:
//   39..63 -- must be zero.
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    8000035a:	7139                	addi	sp,sp,-64
    8000035c:	fc06                	sd	ra,56(sp)
    8000035e:	f822                	sd	s0,48(sp)
    80000360:	f426                	sd	s1,40(sp)
    80000362:	f04a                	sd	s2,32(sp)
    80000364:	ec4e                	sd	s3,24(sp)
    80000366:	e852                	sd	s4,16(sp)
    80000368:	e456                	sd	s5,8(sp)
    8000036a:	e05a                	sd	s6,0(sp)
    8000036c:	0080                	addi	s0,sp,64
    8000036e:	84aa                	mv	s1,a0
    80000370:	89ae                	mv	s3,a1
    80000372:	8ab2                	mv	s5,a2
  if (va >= MAXVA) panic("walk");
    80000374:	57fd                	li	a5,-1
    80000376:	83e9                	srli	a5,a5,0x1a
    80000378:	4a79                	li	s4,30

  for (int level = 2; level > 0; level--) {
    8000037a:	4b31                	li	s6,12
  if (va >= MAXVA) panic("walk");
    8000037c:	04b7f263          	bgeu	a5,a1,800003c0 <walk+0x66>
    80000380:	00008517          	auipc	a0,0x8
    80000384:	cb050513          	addi	a0,a0,-848 # 80008030 <etext+0x30>
    80000388:	00006097          	auipc	ra,0x6
    8000038c:	2fc080e7          	jalr	764(ra) # 80006684 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0) return 0;
    80000390:	060a8663          	beqz	s5,800003fc <walk+0xa2>
    80000394:	00000097          	auipc	ra,0x0
    80000398:	cc8080e7          	jalr	-824(ra) # 8000005c <kalloc>
    8000039c:	84aa                	mv	s1,a0
    8000039e:	c529                	beqz	a0,800003e8 <walk+0x8e>
      memset(pagetable, 0, PGSIZE);
    800003a0:	6605                	lui	a2,0x1
    800003a2:	4581                	li	a1,0
    800003a4:	00000097          	auipc	ra,0x0
    800003a8:	cd2080e7          	jalr	-814(ra) # 80000076 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800003ac:	00c4d793          	srli	a5,s1,0xc
    800003b0:	07aa                	slli	a5,a5,0xa
    800003b2:	0017e793          	ori	a5,a5,1
    800003b6:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    800003ba:	3a5d                	addiw	s4,s4,-9
    800003bc:	036a0063          	beq	s4,s6,800003dc <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800003c0:	0149d933          	srl	s2,s3,s4
    800003c4:	1ff97913          	andi	s2,s2,511
    800003c8:	090e                	slli	s2,s2,0x3
    800003ca:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    800003cc:	00093483          	ld	s1,0(s2)
    800003d0:	0014f793          	andi	a5,s1,1
    800003d4:	dfd5                	beqz	a5,80000390 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800003d6:	80a9                	srli	s1,s1,0xa
    800003d8:	04b2                	slli	s1,s1,0xc
    800003da:	b7c5                	j	800003ba <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800003dc:	00c9d513          	srli	a0,s3,0xc
    800003e0:	1ff57513          	andi	a0,a0,511
    800003e4:	050e                	slli	a0,a0,0x3
    800003e6:	9526                	add	a0,a0,s1
}
    800003e8:	70e2                	ld	ra,56(sp)
    800003ea:	7442                	ld	s0,48(sp)
    800003ec:	74a2                	ld	s1,40(sp)
    800003ee:	7902                	ld	s2,32(sp)
    800003f0:	69e2                	ld	s3,24(sp)
    800003f2:	6a42                	ld	s4,16(sp)
    800003f4:	6aa2                	ld	s5,8(sp)
    800003f6:	6b02                	ld	s6,0(sp)
    800003f8:	6121                	addi	sp,sp,64
    800003fa:	8082                	ret
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0) return 0;
    800003fc:	4501                	li	a0,0
    800003fe:	b7ed                	j	800003e8 <walk+0x8e>

0000000080000400 <walkaddr>:
// Can only be used to look up user pages.
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA) return 0;
    80000400:	57fd                	li	a5,-1
    80000402:	83e9                	srli	a5,a5,0x1a
    80000404:	00b7f463          	bgeu	a5,a1,8000040c <walkaddr+0xc>
    80000408:	4501                	li	a0,0
  if (pte == 0) return 0;
  if ((*pte & PTE_V) == 0) return 0;
  if ((*pte & PTE_U) == 0) return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000040a:	8082                	ret
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    8000040c:	1141                	addi	sp,sp,-16
    8000040e:	e406                	sd	ra,8(sp)
    80000410:	e022                	sd	s0,0(sp)
    80000412:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000414:	4601                	li	a2,0
    80000416:	00000097          	auipc	ra,0x0
    8000041a:	f44080e7          	jalr	-188(ra) # 8000035a <walk>
  if (pte == 0) return 0;
    8000041e:	c105                	beqz	a0,8000043e <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0) return 0;
    80000420:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0) return 0;
    80000422:	0117f693          	andi	a3,a5,17
    80000426:	4745                	li	a4,17
    80000428:	4501                	li	a0,0
    8000042a:	00e68663          	beq	a3,a4,80000436 <walkaddr+0x36>
}
    8000042e:	60a2                	ld	ra,8(sp)
    80000430:	6402                	ld	s0,0(sp)
    80000432:	0141                	addi	sp,sp,16
    80000434:	8082                	ret
  pa = PTE2PA(*pte);
    80000436:	83a9                	srli	a5,a5,0xa
    80000438:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000043c:	bfcd                	j	8000042e <walkaddr+0x2e>
  if (pte == 0) return 0;
    8000043e:	4501                	li	a0,0
    80000440:	b7fd                	j	8000042e <walkaddr+0x2e>

0000000080000442 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa,
             int perm) {
    80000442:	715d                	addi	sp,sp,-80
    80000444:	e486                	sd	ra,72(sp)
    80000446:	e0a2                	sd	s0,64(sp)
    80000448:	fc26                	sd	s1,56(sp)
    8000044a:	f84a                	sd	s2,48(sp)
    8000044c:	f44e                	sd	s3,40(sp)
    8000044e:	f052                	sd	s4,32(sp)
    80000450:	ec56                	sd	s5,24(sp)
    80000452:	e85a                	sd	s6,16(sp)
    80000454:	e45e                	sd	s7,8(sp)
    80000456:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if (size == 0) panic("mappages: size");
    80000458:	c639                	beqz	a2,800004a6 <mappages+0x64>
    8000045a:	8aaa                	mv	s5,a0
    8000045c:	8b3a                	mv	s6,a4

  a = PGROUNDDOWN(va);
    8000045e:	777d                	lui	a4,0xfffff
    80000460:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000464:	fff58993          	addi	s3,a1,-1
    80000468:	99b2                	add	s3,s3,a2
    8000046a:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000046e:	893e                	mv	s2,a5
    80000470:	40f68a33          	sub	s4,a3,a5
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    if (*pte & PTE_V) panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last) break;
    a += PGSIZE;
    80000474:	6b85                	lui	s7,0x1
    80000476:	012a04b3          	add	s1,s4,s2
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    8000047a:	4605                	li	a2,1
    8000047c:	85ca                	mv	a1,s2
    8000047e:	8556                	mv	a0,s5
    80000480:	00000097          	auipc	ra,0x0
    80000484:	eda080e7          	jalr	-294(ra) # 8000035a <walk>
    80000488:	cd1d                	beqz	a0,800004c6 <mappages+0x84>
    if (*pte & PTE_V) panic("mappages: remap");
    8000048a:	611c                	ld	a5,0(a0)
    8000048c:	8b85                	andi	a5,a5,1
    8000048e:	e785                	bnez	a5,800004b6 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000490:	80b1                	srli	s1,s1,0xc
    80000492:	04aa                	slli	s1,s1,0xa
    80000494:	0164e4b3          	or	s1,s1,s6
    80000498:	0014e493          	ori	s1,s1,1
    8000049c:	e104                	sd	s1,0(a0)
    if (a == last) break;
    8000049e:	05390063          	beq	s2,s3,800004de <mappages+0x9c>
    a += PGSIZE;
    800004a2:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    800004a4:	bfc9                	j	80000476 <mappages+0x34>
  if (size == 0) panic("mappages: size");
    800004a6:	00008517          	auipc	a0,0x8
    800004aa:	b9250513          	addi	a0,a0,-1134 # 80008038 <etext+0x38>
    800004ae:	00006097          	auipc	ra,0x6
    800004b2:	1d6080e7          	jalr	470(ra) # 80006684 <panic>
    if (*pte & PTE_V) panic("mappages: remap");
    800004b6:	00008517          	auipc	a0,0x8
    800004ba:	b9250513          	addi	a0,a0,-1134 # 80008048 <etext+0x48>
    800004be:	00006097          	auipc	ra,0x6
    800004c2:	1c6080e7          	jalr	454(ra) # 80006684 <panic>
    if ((pte = walk(pagetable, a, 1)) == 0) return -1;
    800004c6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800004c8:	60a6                	ld	ra,72(sp)
    800004ca:	6406                	ld	s0,64(sp)
    800004cc:	74e2                	ld	s1,56(sp)
    800004ce:	7942                	ld	s2,48(sp)
    800004d0:	79a2                	ld	s3,40(sp)
    800004d2:	7a02                	ld	s4,32(sp)
    800004d4:	6ae2                	ld	s5,24(sp)
    800004d6:	6b42                	ld	s6,16(sp)
    800004d8:	6ba2                	ld	s7,8(sp)
    800004da:	6161                	addi	sp,sp,80
    800004dc:	8082                	ret
  return 0;
    800004de:	4501                	li	a0,0
    800004e0:	b7e5                	j	800004c8 <mappages+0x86>

00000000800004e2 <kvmmap>:
void kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm) {
    800004e2:	1141                	addi	sp,sp,-16
    800004e4:	e406                	sd	ra,8(sp)
    800004e6:	e022                	sd	s0,0(sp)
    800004e8:	0800                	addi	s0,sp,16
    800004ea:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0) panic("kvmmap");
    800004ec:	86b2                	mv	a3,a2
    800004ee:	863e                	mv	a2,a5
    800004f0:	00000097          	auipc	ra,0x0
    800004f4:	f52080e7          	jalr	-174(ra) # 80000442 <mappages>
    800004f8:	e509                	bnez	a0,80000502 <kvmmap+0x20>
}
    800004fa:	60a2                	ld	ra,8(sp)
    800004fc:	6402                	ld	s0,0(sp)
    800004fe:	0141                	addi	sp,sp,16
    80000500:	8082                	ret
  if (mappages(kpgtbl, va, sz, pa, perm) != 0) panic("kvmmap");
    80000502:	00008517          	auipc	a0,0x8
    80000506:	b5650513          	addi	a0,a0,-1194 # 80008058 <etext+0x58>
    8000050a:	00006097          	auipc	ra,0x6
    8000050e:	17a080e7          	jalr	378(ra) # 80006684 <panic>

0000000080000512 <kvmmake>:
pagetable_t kvmmake(void) {
    80000512:	1101                	addi	sp,sp,-32
    80000514:	ec06                	sd	ra,24(sp)
    80000516:	e822                	sd	s0,16(sp)
    80000518:	e426                	sd	s1,8(sp)
    8000051a:	e04a                	sd	s2,0(sp)
    8000051c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    8000051e:	00000097          	auipc	ra,0x0
    80000522:	b3e080e7          	jalr	-1218(ra) # 8000005c <kalloc>
    80000526:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000528:	6605                	lui	a2,0x1
    8000052a:	4581                	li	a1,0
    8000052c:	00000097          	auipc	ra,0x0
    80000530:	b4a080e7          	jalr	-1206(ra) # 80000076 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000534:	4719                	li	a4,6
    80000536:	6685                	lui	a3,0x1
    80000538:	10000637          	lui	a2,0x10000
    8000053c:	100005b7          	lui	a1,0x10000
    80000540:	8526                	mv	a0,s1
    80000542:	00000097          	auipc	ra,0x0
    80000546:	fa0080e7          	jalr	-96(ra) # 800004e2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000054a:	4719                	li	a4,6
    8000054c:	6685                	lui	a3,0x1
    8000054e:	10001637          	lui	a2,0x10001
    80000552:	100015b7          	lui	a1,0x10001
    80000556:	8526                	mv	a0,s1
    80000558:	00000097          	auipc	ra,0x0
    8000055c:	f8a080e7          	jalr	-118(ra) # 800004e2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000560:	4719                	li	a4,6
    80000562:	004006b7          	lui	a3,0x400
    80000566:	0c000637          	lui	a2,0xc000
    8000056a:	0c0005b7          	lui	a1,0xc000
    8000056e:	8526                	mv	a0,s1
    80000570:	00000097          	auipc	ra,0x0
    80000574:	f72080e7          	jalr	-142(ra) # 800004e2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80000578:	00008917          	auipc	s2,0x8
    8000057c:	a8890913          	addi	s2,s2,-1400 # 80008000 <etext>
    80000580:	4729                	li	a4,10
    80000582:	80008697          	auipc	a3,0x80008
    80000586:	a7e68693          	addi	a3,a3,-1410 # 8000 <_entry-0x7fff8000>
    8000058a:	4605                	li	a2,1
    8000058c:	067e                	slli	a2,a2,0x1f
    8000058e:	85b2                	mv	a1,a2
    80000590:	8526                	mv	a0,s1
    80000592:	00000097          	auipc	ra,0x0
    80000596:	f50080e7          	jalr	-176(ra) # 800004e2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    8000059a:	4719                	li	a4,6
    8000059c:	46c5                	li	a3,17
    8000059e:	06ee                	slli	a3,a3,0x1b
    800005a0:	412686b3          	sub	a3,a3,s2
    800005a4:	864a                	mv	a2,s2
    800005a6:	85ca                	mv	a1,s2
    800005a8:	8526                	mv	a0,s1
    800005aa:	00000097          	auipc	ra,0x0
    800005ae:	f38080e7          	jalr	-200(ra) # 800004e2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800005b2:	4729                	li	a4,10
    800005b4:	6685                	lui	a3,0x1
    800005b6:	00007617          	auipc	a2,0x7
    800005ba:	a4a60613          	addi	a2,a2,-1462 # 80007000 <_trampoline>
    800005be:	040005b7          	lui	a1,0x4000
    800005c2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800005c4:	05b2                	slli	a1,a1,0xc
    800005c6:	8526                	mv	a0,s1
    800005c8:	00000097          	auipc	ra,0x0
    800005cc:	f1a080e7          	jalr	-230(ra) # 800004e2 <kvmmap>
  proc_mapstacks(kpgtbl);
    800005d0:	8526                	mv	a0,s1
    800005d2:	00000097          	auipc	ra,0x0
    800005d6:	608080e7          	jalr	1544(ra) # 80000bda <proc_mapstacks>
}
    800005da:	8526                	mv	a0,s1
    800005dc:	60e2                	ld	ra,24(sp)
    800005de:	6442                	ld	s0,16(sp)
    800005e0:	64a2                	ld	s1,8(sp)
    800005e2:	6902                	ld	s2,0(sp)
    800005e4:	6105                	addi	sp,sp,32
    800005e6:	8082                	ret

00000000800005e8 <kvminit>:
void kvminit(void) { kernel_pagetable = kvmmake(); }
    800005e8:	1141                	addi	sp,sp,-16
    800005ea:	e406                	sd	ra,8(sp)
    800005ec:	e022                	sd	s0,0(sp)
    800005ee:	0800                	addi	s0,sp,16
    800005f0:	00000097          	auipc	ra,0x0
    800005f4:	f22080e7          	jalr	-222(ra) # 80000512 <kvmmake>
    800005f8:	00008797          	auipc	a5,0x8
    800005fc:	3ca7b823          	sd	a0,976(a5) # 800089c8 <kernel_pagetable>
    80000600:	60a2                	ld	ra,8(sp)
    80000602:	6402                	ld	s0,0(sp)
    80000604:	0141                	addi	sp,sp,16
    80000606:	8082                	ret

0000000080000608 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free) {
    80000608:	715d                	addi	sp,sp,-80
    8000060a:	e486                	sd	ra,72(sp)
    8000060c:	e0a2                	sd	s0,64(sp)
    8000060e:	fc26                	sd	s1,56(sp)
    80000610:	f84a                	sd	s2,48(sp)
    80000612:	f44e                	sd	s3,40(sp)
    80000614:	f052                	sd	s4,32(sp)
    80000616:	ec56                	sd	s5,24(sp)
    80000618:	e85a                	sd	s6,16(sp)
    8000061a:	e45e                	sd	s7,8(sp)
    8000061c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0) panic("uvmunmap: not aligned");
    8000061e:	03459793          	slli	a5,a1,0x34
    80000622:	e795                	bnez	a5,8000064e <uvmunmap+0x46>
    80000624:	8a2a                	mv	s4,a0
    80000626:	892e                	mv	s2,a1
    80000628:	8ab6                	mv	s5,a3

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000062a:	0632                	slli	a2,a2,0xc
    8000062c:	00b609b3          	add	s3,a2,a1
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    80000630:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80000632:	6b05                	lui	s6,0x1
    80000634:	0735e263          	bltu	a1,s3,80000698 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
  }
}
    80000638:	60a6                	ld	ra,72(sp)
    8000063a:	6406                	ld	s0,64(sp)
    8000063c:	74e2                	ld	s1,56(sp)
    8000063e:	7942                	ld	s2,48(sp)
    80000640:	79a2                	ld	s3,40(sp)
    80000642:	7a02                	ld	s4,32(sp)
    80000644:	6ae2                	ld	s5,24(sp)
    80000646:	6b42                	ld	s6,16(sp)
    80000648:	6ba2                	ld	s7,8(sp)
    8000064a:	6161                	addi	sp,sp,80
    8000064c:	8082                	ret
  if ((va % PGSIZE) != 0) panic("uvmunmap: not aligned");
    8000064e:	00008517          	auipc	a0,0x8
    80000652:	a1250513          	addi	a0,a0,-1518 # 80008060 <etext+0x60>
    80000656:	00006097          	auipc	ra,0x6
    8000065a:	02e080e7          	jalr	46(ra) # 80006684 <panic>
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    8000065e:	00008517          	auipc	a0,0x8
    80000662:	a1a50513          	addi	a0,a0,-1510 # 80008078 <etext+0x78>
    80000666:	00006097          	auipc	ra,0x6
    8000066a:	01e080e7          	jalr	30(ra) # 80006684 <panic>
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    8000066e:	00008517          	auipc	a0,0x8
    80000672:	a1a50513          	addi	a0,a0,-1510 # 80008088 <etext+0x88>
    80000676:	00006097          	auipc	ra,0x6
    8000067a:	00e080e7          	jalr	14(ra) # 80006684 <panic>
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    8000067e:	00008517          	auipc	a0,0x8
    80000682:	a2250513          	addi	a0,a0,-1502 # 800080a0 <etext+0xa0>
    80000686:	00006097          	auipc	ra,0x6
    8000068a:	ffe080e7          	jalr	-2(ra) # 80006684 <panic>
    *pte = 0;
    8000068e:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80000692:	995a                	add	s2,s2,s6
    80000694:	fb3972e3          	bgeu	s2,s3,80000638 <uvmunmap+0x30>
    if ((pte = walk(pagetable, a, 0)) == 0) panic("uvmunmap: walk");
    80000698:	4601                	li	a2,0
    8000069a:	85ca                	mv	a1,s2
    8000069c:	8552                	mv	a0,s4
    8000069e:	00000097          	auipc	ra,0x0
    800006a2:	cbc080e7          	jalr	-836(ra) # 8000035a <walk>
    800006a6:	84aa                	mv	s1,a0
    800006a8:	d95d                	beqz	a0,8000065e <uvmunmap+0x56>
    if ((*pte & PTE_V) == 0) panic("uvmunmap: not mapped");
    800006aa:	6108                	ld	a0,0(a0)
    800006ac:	00157793          	andi	a5,a0,1
    800006b0:	dfdd                	beqz	a5,8000066e <uvmunmap+0x66>
    if (PTE_FLAGS(*pte) == PTE_V) panic("uvmunmap: not a leaf");
    800006b2:	3ff57793          	andi	a5,a0,1023
    800006b6:	fd7784e3          	beq	a5,s7,8000067e <uvmunmap+0x76>
    if (do_free) {
    800006ba:	fc0a8ae3          	beqz	s5,8000068e <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800006be:	8129                	srli	a0,a0,0xa
      kfree((void *)pa);
    800006c0:	0532                	slli	a0,a0,0xc
    800006c2:	00000097          	auipc	ra,0x0
    800006c6:	982080e7          	jalr	-1662(ra) # 80000044 <kfree>
    800006ca:	b7d1                	j	8000068e <uvmunmap+0x86>

00000000800006cc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate() {
    800006cc:	1101                	addi	sp,sp,-32
    800006ce:	ec06                	sd	ra,24(sp)
    800006d0:	e822                	sd	s0,16(sp)
    800006d2:	e426                	sd	s1,8(sp)
    800006d4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	986080e7          	jalr	-1658(ra) # 8000005c <kalloc>
    800006de:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    800006e0:	c519                	beqz	a0,800006ee <uvmcreate+0x22>
  memset(pagetable, 0, PGSIZE);
    800006e2:	6605                	lui	a2,0x1
    800006e4:	4581                	li	a1,0
    800006e6:	00000097          	auipc	ra,0x0
    800006ea:	990080e7          	jalr	-1648(ra) # 80000076 <memset>
  return pagetable;
}
    800006ee:	8526                	mv	a0,s1
    800006f0:	60e2                	ld	ra,24(sp)
    800006f2:	6442                	ld	s0,16(sp)
    800006f4:	64a2                	ld	s1,8(sp)
    800006f6:	6105                	addi	sp,sp,32
    800006f8:	8082                	ret

00000000800006fa <uvmfirst>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz) {
    800006fa:	7179                	addi	sp,sp,-48
    800006fc:	f406                	sd	ra,40(sp)
    800006fe:	f022                	sd	s0,32(sp)
    80000700:	ec26                	sd	s1,24(sp)
    80000702:	e84a                	sd	s2,16(sp)
    80000704:	e44e                	sd	s3,8(sp)
    80000706:	e052                	sd	s4,0(sp)
    80000708:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE) panic("uvmfirst: more than a page");
    8000070a:	6785                	lui	a5,0x1
    8000070c:	04f67863          	bgeu	a2,a5,8000075c <uvmfirst+0x62>
    80000710:	8a2a                	mv	s4,a0
    80000712:	89ae                	mv	s3,a1
    80000714:	84b2                	mv	s1,a2
  mem = kalloc();
    80000716:	00000097          	auipc	ra,0x0
    8000071a:	946080e7          	jalr	-1722(ra) # 8000005c <kalloc>
    8000071e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000720:	6605                	lui	a2,0x1
    80000722:	4581                	li	a1,0
    80000724:	00000097          	auipc	ra,0x0
    80000728:	952080e7          	jalr	-1710(ra) # 80000076 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    8000072c:	4779                	li	a4,30
    8000072e:	86ca                	mv	a3,s2
    80000730:	6605                	lui	a2,0x1
    80000732:	4581                	li	a1,0
    80000734:	8552                	mv	a0,s4
    80000736:	00000097          	auipc	ra,0x0
    8000073a:	d0c080e7          	jalr	-756(ra) # 80000442 <mappages>
  memmove(mem, src, sz);
    8000073e:	8626                	mv	a2,s1
    80000740:	85ce                	mv	a1,s3
    80000742:	854a                	mv	a0,s2
    80000744:	00000097          	auipc	ra,0x0
    80000748:	98e080e7          	jalr	-1650(ra) # 800000d2 <memmove>
}
    8000074c:	70a2                	ld	ra,40(sp)
    8000074e:	7402                	ld	s0,32(sp)
    80000750:	64e2                	ld	s1,24(sp)
    80000752:	6942                	ld	s2,16(sp)
    80000754:	69a2                	ld	s3,8(sp)
    80000756:	6a02                	ld	s4,0(sp)
    80000758:	6145                	addi	sp,sp,48
    8000075a:	8082                	ret
  if (sz >= PGSIZE) panic("uvmfirst: more than a page");
    8000075c:	00008517          	auipc	a0,0x8
    80000760:	95c50513          	addi	a0,a0,-1700 # 800080b8 <etext+0xb8>
    80000764:	00006097          	auipc	ra,0x6
    80000768:	f20080e7          	jalr	-224(ra) # 80006684 <panic>

000000008000076c <uvmdealloc>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64 uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    8000076c:	1101                	addi	sp,sp,-32
    8000076e:	ec06                	sd	ra,24(sp)
    80000770:	e822                	sd	s0,16(sp)
    80000772:	e426                	sd	s1,8(sp)
    80000774:	1000                	addi	s0,sp,32
  if (newsz >= oldsz) return oldsz;
    80000776:	84ae                	mv	s1,a1
    80000778:	00b67d63          	bgeu	a2,a1,80000792 <uvmdealloc+0x26>
    8000077c:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    8000077e:	6785                	lui	a5,0x1
    80000780:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000782:	00f60733          	add	a4,a2,a5
    80000786:	76fd                	lui	a3,0xfffff
    80000788:	8f75                	and	a4,a4,a3
    8000078a:	97ae                	add	a5,a5,a1
    8000078c:	8ff5                	and	a5,a5,a3
    8000078e:	00f76863          	bltu	a4,a5,8000079e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000792:	8526                	mv	a0,s1
    80000794:	60e2                	ld	ra,24(sp)
    80000796:	6442                	ld	s0,16(sp)
    80000798:	64a2                	ld	s1,8(sp)
    8000079a:	6105                	addi	sp,sp,32
    8000079c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000079e:	8f99                	sub	a5,a5,a4
    800007a0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007a2:	4685                	li	a3,1
    800007a4:	0007861b          	sext.w	a2,a5
    800007a8:	85ba                	mv	a1,a4
    800007aa:	00000097          	auipc	ra,0x0
    800007ae:	e5e080e7          	jalr	-418(ra) # 80000608 <uvmunmap>
    800007b2:	b7c5                	j	80000792 <uvmdealloc+0x26>

00000000800007b4 <uvmalloc>:
  if (newsz < oldsz) return oldsz;
    800007b4:	0ab66563          	bltu	a2,a1,8000085e <uvmalloc+0xaa>
uint64 uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int xperm) {
    800007b8:	7139                	addi	sp,sp,-64
    800007ba:	fc06                	sd	ra,56(sp)
    800007bc:	f822                	sd	s0,48(sp)
    800007be:	f426                	sd	s1,40(sp)
    800007c0:	f04a                	sd	s2,32(sp)
    800007c2:	ec4e                	sd	s3,24(sp)
    800007c4:	e852                	sd	s4,16(sp)
    800007c6:	e456                	sd	s5,8(sp)
    800007c8:	e05a                	sd	s6,0(sp)
    800007ca:	0080                	addi	s0,sp,64
    800007cc:	8aaa                	mv	s5,a0
    800007ce:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800007d0:	6785                	lui	a5,0x1
    800007d2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007d4:	95be                	add	a1,a1,a5
    800007d6:	77fd                	lui	a5,0xfffff
    800007d8:	00f5f9b3          	and	s3,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800007dc:	08c9f363          	bgeu	s3,a2,80000862 <uvmalloc+0xae>
    800007e0:	894e                	mv	s2,s3
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800007e2:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800007e6:	00000097          	auipc	ra,0x0
    800007ea:	876080e7          	jalr	-1930(ra) # 8000005c <kalloc>
    800007ee:	84aa                	mv	s1,a0
    if (mem == 0) {
    800007f0:	c51d                	beqz	a0,8000081e <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800007f2:	6605                	lui	a2,0x1
    800007f4:	4581                	li	a1,0
    800007f6:	00000097          	auipc	ra,0x0
    800007fa:	880080e7          	jalr	-1920(ra) # 80000076 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800007fe:	875a                	mv	a4,s6
    80000800:	86a6                	mv	a3,s1
    80000802:	6605                	lui	a2,0x1
    80000804:	85ca                	mv	a1,s2
    80000806:	8556                	mv	a0,s5
    80000808:	00000097          	auipc	ra,0x0
    8000080c:	c3a080e7          	jalr	-966(ra) # 80000442 <mappages>
    80000810:	e90d                	bnez	a0,80000842 <uvmalloc+0x8e>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80000812:	6785                	lui	a5,0x1
    80000814:	993e                	add	s2,s2,a5
    80000816:	fd4968e3          	bltu	s2,s4,800007e6 <uvmalloc+0x32>
  return newsz;
    8000081a:	8552                	mv	a0,s4
    8000081c:	a809                	j	8000082e <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    8000081e:	864e                	mv	a2,s3
    80000820:	85ca                	mv	a1,s2
    80000822:	8556                	mv	a0,s5
    80000824:	00000097          	auipc	ra,0x0
    80000828:	f48080e7          	jalr	-184(ra) # 8000076c <uvmdealloc>
      return 0;
    8000082c:	4501                	li	a0,0
}
    8000082e:	70e2                	ld	ra,56(sp)
    80000830:	7442                	ld	s0,48(sp)
    80000832:	74a2                	ld	s1,40(sp)
    80000834:	7902                	ld	s2,32(sp)
    80000836:	69e2                	ld	s3,24(sp)
    80000838:	6a42                	ld	s4,16(sp)
    8000083a:	6aa2                	ld	s5,8(sp)
    8000083c:	6b02                	ld	s6,0(sp)
    8000083e:	6121                	addi	sp,sp,64
    80000840:	8082                	ret
      kfree(mem);
    80000842:	8526                	mv	a0,s1
    80000844:	00000097          	auipc	ra,0x0
    80000848:	800080e7          	jalr	-2048(ra) # 80000044 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000084c:	864e                	mv	a2,s3
    8000084e:	85ca                	mv	a1,s2
    80000850:	8556                	mv	a0,s5
    80000852:	00000097          	auipc	ra,0x0
    80000856:	f1a080e7          	jalr	-230(ra) # 8000076c <uvmdealloc>
      return 0;
    8000085a:	4501                	li	a0,0
    8000085c:	bfc9                	j	8000082e <uvmalloc+0x7a>
  if (newsz < oldsz) return oldsz;
    8000085e:	852e                	mv	a0,a1
}
    80000860:	8082                	ret
  return newsz;
    80000862:	8532                	mv	a0,a2
    80000864:	b7e9                	j	8000082e <uvmalloc+0x7a>

0000000080000866 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable) {
    80000866:	7179                	addi	sp,sp,-48
    80000868:	f406                	sd	ra,40(sp)
    8000086a:	f022                	sd	s0,32(sp)
    8000086c:	ec26                	sd	s1,24(sp)
    8000086e:	e84a                	sd	s2,16(sp)
    80000870:	e44e                	sd	s3,8(sp)
    80000872:	e052                	sd	s4,0(sp)
    80000874:	1800                	addi	s0,sp,48
    80000876:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    80000878:	84aa                	mv	s1,a0
    8000087a:	6905                	lui	s2,0x1
    8000087c:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    8000087e:	4985                	li	s3,1
    80000880:	a829                	j	8000089a <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000882:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000884:	00c79513          	slli	a0,a5,0xc
    80000888:	00000097          	auipc	ra,0x0
    8000088c:	fde080e7          	jalr	-34(ra) # 80000866 <freewalk>
      pagetable[i] = 0;
    80000890:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++) {
    80000894:	04a1                	addi	s1,s1,8
    80000896:	03248163          	beq	s1,s2,800008b8 <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000089a:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    8000089c:	00f7f713          	andi	a4,a5,15
    800008a0:	ff3701e3          	beq	a4,s3,80000882 <freewalk+0x1c>
    } else if (pte & PTE_V) {
    800008a4:	8b85                	andi	a5,a5,1
    800008a6:	d7fd                	beqz	a5,80000894 <freewalk+0x2e>
      panic("freewalk: leaf");
    800008a8:	00008517          	auipc	a0,0x8
    800008ac:	83050513          	addi	a0,a0,-2000 # 800080d8 <etext+0xd8>
    800008b0:	00006097          	auipc	ra,0x6
    800008b4:	dd4080e7          	jalr	-556(ra) # 80006684 <panic>
    }
  }
  kfree((void *)pagetable);
    800008b8:	8552                	mv	a0,s4
    800008ba:	fffff097          	auipc	ra,0xfffff
    800008be:	78a080e7          	jalr	1930(ra) # 80000044 <kfree>
}
    800008c2:	70a2                	ld	ra,40(sp)
    800008c4:	7402                	ld	s0,32(sp)
    800008c6:	64e2                	ld	s1,24(sp)
    800008c8:	6942                	ld	s2,16(sp)
    800008ca:	69a2                	ld	s3,8(sp)
    800008cc:	6a02                	ld	s4,0(sp)
    800008ce:	6145                	addi	sp,sp,48
    800008d0:	8082                	ret

00000000800008d2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz) {
    800008d2:	1101                	addi	sp,sp,-32
    800008d4:	ec06                	sd	ra,24(sp)
    800008d6:	e822                	sd	s0,16(sp)
    800008d8:	e426                	sd	s1,8(sp)
    800008da:	1000                	addi	s0,sp,32
    800008dc:	84aa                	mv	s1,a0
  if (sz > 0) uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800008de:	e999                	bnez	a1,800008f4 <uvmfree+0x22>
  freewalk(pagetable);
    800008e0:	8526                	mv	a0,s1
    800008e2:	00000097          	auipc	ra,0x0
    800008e6:	f84080e7          	jalr	-124(ra) # 80000866 <freewalk>
}
    800008ea:	60e2                	ld	ra,24(sp)
    800008ec:	6442                	ld	s0,16(sp)
    800008ee:	64a2                	ld	s1,8(sp)
    800008f0:	6105                	addi	sp,sp,32
    800008f2:	8082                	ret
  if (sz > 0) uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800008f4:	6785                	lui	a5,0x1
    800008f6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008f8:	95be                	add	a1,a1,a5
    800008fa:	4685                	li	a3,1
    800008fc:	00c5d613          	srli	a2,a1,0xc
    80000900:	4581                	li	a1,0
    80000902:	00000097          	auipc	ra,0x0
    80000906:	d06080e7          	jalr	-762(ra) # 80000608 <uvmunmap>
    8000090a:	bfd9                	j	800008e0 <uvmfree+0xe>

000000008000090c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE) {
    8000090c:	c679                	beqz	a2,800009da <uvmcopy+0xce>
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    8000090e:	715d                	addi	sp,sp,-80
    80000910:	e486                	sd	ra,72(sp)
    80000912:	e0a2                	sd	s0,64(sp)
    80000914:	fc26                	sd	s1,56(sp)
    80000916:	f84a                	sd	s2,48(sp)
    80000918:	f44e                	sd	s3,40(sp)
    8000091a:	f052                	sd	s4,32(sp)
    8000091c:	ec56                	sd	s5,24(sp)
    8000091e:	e85a                	sd	s6,16(sp)
    80000920:	e45e                	sd	s7,8(sp)
    80000922:	0880                	addi	s0,sp,80
    80000924:	8b2a                	mv	s6,a0
    80000926:	8aae                	mv	s5,a1
    80000928:	8a32                	mv	s4,a2
  for (i = 0; i < sz; i += PGSIZE) {
    8000092a:	4981                	li	s3,0
    if ((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist");
    8000092c:	4601                	li	a2,0
    8000092e:	85ce                	mv	a1,s3
    80000930:	855a                	mv	a0,s6
    80000932:	00000097          	auipc	ra,0x0
    80000936:	a28080e7          	jalr	-1496(ra) # 8000035a <walk>
    8000093a:	c531                	beqz	a0,80000986 <uvmcopy+0x7a>
    if ((*pte & PTE_V) == 0) panic("uvmcopy: page not present");
    8000093c:	6118                	ld	a4,0(a0)
    8000093e:	00177793          	andi	a5,a4,1
    80000942:	cbb1                	beqz	a5,80000996 <uvmcopy+0x8a>
    pa = PTE2PA(*pte);
    80000944:	00a75593          	srli	a1,a4,0xa
    80000948:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000094c:	3ff77493          	andi	s1,a4,1023
    if ((mem = kalloc()) == 0) goto err;
    80000950:	fffff097          	auipc	ra,0xfffff
    80000954:	70c080e7          	jalr	1804(ra) # 8000005c <kalloc>
    80000958:	892a                	mv	s2,a0
    8000095a:	c939                	beqz	a0,800009b0 <uvmcopy+0xa4>
    memmove(mem, (char *)pa, PGSIZE);
    8000095c:	6605                	lui	a2,0x1
    8000095e:	85de                	mv	a1,s7
    80000960:	fffff097          	auipc	ra,0xfffff
    80000964:	772080e7          	jalr	1906(ra) # 800000d2 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    80000968:	8726                	mv	a4,s1
    8000096a:	86ca                	mv	a3,s2
    8000096c:	6605                	lui	a2,0x1
    8000096e:	85ce                	mv	a1,s3
    80000970:	8556                	mv	a0,s5
    80000972:	00000097          	auipc	ra,0x0
    80000976:	ad0080e7          	jalr	-1328(ra) # 80000442 <mappages>
    8000097a:	e515                	bnez	a0,800009a6 <uvmcopy+0x9a>
  for (i = 0; i < sz; i += PGSIZE) {
    8000097c:	6785                	lui	a5,0x1
    8000097e:	99be                	add	s3,s3,a5
    80000980:	fb49e6e3          	bltu	s3,s4,8000092c <uvmcopy+0x20>
    80000984:	a081                	j	800009c4 <uvmcopy+0xb8>
    if ((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist");
    80000986:	00007517          	auipc	a0,0x7
    8000098a:	76250513          	addi	a0,a0,1890 # 800080e8 <etext+0xe8>
    8000098e:	00006097          	auipc	ra,0x6
    80000992:	cf6080e7          	jalr	-778(ra) # 80006684 <panic>
    if ((*pte & PTE_V) == 0) panic("uvmcopy: page not present");
    80000996:	00007517          	auipc	a0,0x7
    8000099a:	77250513          	addi	a0,a0,1906 # 80008108 <etext+0x108>
    8000099e:	00006097          	auipc	ra,0x6
    800009a2:	ce6080e7          	jalr	-794(ra) # 80006684 <panic>
      kfree(mem);
    800009a6:	854a                	mv	a0,s2
    800009a8:	fffff097          	auipc	ra,0xfffff
    800009ac:	69c080e7          	jalr	1692(ra) # 80000044 <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800009b0:	4685                	li	a3,1
    800009b2:	00c9d613          	srli	a2,s3,0xc
    800009b6:	4581                	li	a1,0
    800009b8:	8556                	mv	a0,s5
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	c4e080e7          	jalr	-946(ra) # 80000608 <uvmunmap>
  return -1;
    800009c2:	557d                	li	a0,-1
}
    800009c4:	60a6                	ld	ra,72(sp)
    800009c6:	6406                	ld	s0,64(sp)
    800009c8:	74e2                	ld	s1,56(sp)
    800009ca:	7942                	ld	s2,48(sp)
    800009cc:	79a2                	ld	s3,40(sp)
    800009ce:	7a02                	ld	s4,32(sp)
    800009d0:	6ae2                	ld	s5,24(sp)
    800009d2:	6b42                	ld	s6,16(sp)
    800009d4:	6ba2                	ld	s7,8(sp)
    800009d6:	6161                	addi	sp,sp,80
    800009d8:	8082                	ret
  return 0;
    800009da:	4501                	li	a0,0
}
    800009dc:	8082                	ret

00000000800009de <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va) {
    800009de:	1141                	addi	sp,sp,-16
    800009e0:	e406                	sd	ra,8(sp)
    800009e2:	e022                	sd	s0,0(sp)
    800009e4:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    800009e6:	4601                	li	a2,0
    800009e8:	00000097          	auipc	ra,0x0
    800009ec:	972080e7          	jalr	-1678(ra) # 8000035a <walk>
  if (pte == 0) panic("uvmclear");
    800009f0:	c901                	beqz	a0,80000a00 <uvmclear+0x22>
  *pte &= ~PTE_U;
    800009f2:	611c                	ld	a5,0(a0)
    800009f4:	9bbd                	andi	a5,a5,-17
    800009f6:	e11c                	sd	a5,0(a0)
}
    800009f8:	60a2                	ld	ra,8(sp)
    800009fa:	6402                	ld	s0,0(sp)
    800009fc:	0141                	addi	sp,sp,16
    800009fe:	8082                	ret
  if (pte == 0) panic("uvmclear");
    80000a00:	00007517          	auipc	a0,0x7
    80000a04:	72850513          	addi	a0,a0,1832 # 80008128 <etext+0x128>
    80000a08:	00006097          	auipc	ra,0x6
    80000a0c:	c7c080e7          	jalr	-900(ra) # 80006684 <panic>

0000000080000a10 <copyout>:
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    80000a10:	c6bd                	beqz	a3,80000a7e <copyout+0x6e>
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
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
    80000a26:	e062                	sd	s8,0(sp)
    80000a28:	0880                	addi	s0,sp,80
    80000a2a:	8b2a                	mv	s6,a0
    80000a2c:	8c2e                	mv	s8,a1
    80000a2e:	8a32                	mv	s4,a2
    80000a30:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000a32:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (dstva - va0);
    80000a34:	6a85                	lui	s5,0x1
    80000a36:	a015                	j	80000a5a <copyout+0x4a>
    if (n > len) n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a38:	9562                	add	a0,a0,s8
    80000a3a:	0004861b          	sext.w	a2,s1
    80000a3e:	85d2                	mv	a1,s4
    80000a40:	41250533          	sub	a0,a0,s2
    80000a44:	fffff097          	auipc	ra,0xfffff
    80000a48:	68e080e7          	jalr	1678(ra) # 800000d2 <memmove>

    len -= n;
    80000a4c:	409989b3          	sub	s3,s3,s1
    src += n;
    80000a50:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000a52:	01590c33          	add	s8,s2,s5
  while (len > 0) {
    80000a56:	02098263          	beqz	s3,80000a7a <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000a5a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000a5e:	85ca                	mv	a1,s2
    80000a60:	855a                	mv	a0,s6
    80000a62:	00000097          	auipc	ra,0x0
    80000a66:	99e080e7          	jalr	-1634(ra) # 80000400 <walkaddr>
    if (pa0 == 0) return -1;
    80000a6a:	cd01                	beqz	a0,80000a82 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000a6c:	418904b3          	sub	s1,s2,s8
    80000a70:	94d6                	add	s1,s1,s5
    80000a72:	fc99f3e3          	bgeu	s3,s1,80000a38 <copyout+0x28>
    80000a76:	84ce                	mv	s1,s3
    80000a78:	b7c1                	j	80000a38 <copyout+0x28>
  }
  return 0;
    80000a7a:	4501                	li	a0,0
    80000a7c:	a021                	j	80000a84 <copyout+0x74>
    80000a7e:	4501                	li	a0,0
}
    80000a80:	8082                	ret
    if (pa0 == 0) return -1;
    80000a82:	557d                	li	a0,-1
}
    80000a84:	60a6                	ld	ra,72(sp)
    80000a86:	6406                	ld	s0,64(sp)
    80000a88:	74e2                	ld	s1,56(sp)
    80000a8a:	7942                	ld	s2,48(sp)
    80000a8c:	79a2                	ld	s3,40(sp)
    80000a8e:	7a02                	ld	s4,32(sp)
    80000a90:	6ae2                	ld	s5,24(sp)
    80000a92:	6b42                	ld	s6,16(sp)
    80000a94:	6ba2                	ld	s7,8(sp)
    80000a96:	6c02                	ld	s8,0(sp)
    80000a98:	6161                	addi	sp,sp,80
    80000a9a:	8082                	ret

0000000080000a9c <copyin>:
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    80000a9c:	caa5                	beqz	a3,80000b0c <copyin+0x70>
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
    80000a9e:	715d                	addi	sp,sp,-80
    80000aa0:	e486                	sd	ra,72(sp)
    80000aa2:	e0a2                	sd	s0,64(sp)
    80000aa4:	fc26                	sd	s1,56(sp)
    80000aa6:	f84a                	sd	s2,48(sp)
    80000aa8:	f44e                	sd	s3,40(sp)
    80000aaa:	f052                	sd	s4,32(sp)
    80000aac:	ec56                	sd	s5,24(sp)
    80000aae:	e85a                	sd	s6,16(sp)
    80000ab0:	e45e                	sd	s7,8(sp)
    80000ab2:	e062                	sd	s8,0(sp)
    80000ab4:	0880                	addi	s0,sp,80
    80000ab6:	8b2a                	mv	s6,a0
    80000ab8:	8a2e                	mv	s4,a1
    80000aba:	8c32                	mv	s8,a2
    80000abc:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000abe:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (srcva - va0);
    80000ac0:	6a85                	lui	s5,0x1
    80000ac2:	a01d                	j	80000ae8 <copyin+0x4c>
    if (n > len) n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ac4:	018505b3          	add	a1,a0,s8
    80000ac8:	0004861b          	sext.w	a2,s1
    80000acc:	412585b3          	sub	a1,a1,s2
    80000ad0:	8552                	mv	a0,s4
    80000ad2:	fffff097          	auipc	ra,0xfffff
    80000ad6:	600080e7          	jalr	1536(ra) # 800000d2 <memmove>

    len -= n;
    80000ada:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000ade:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000ae0:	01590c33          	add	s8,s2,s5
  while (len > 0) {
    80000ae4:	02098263          	beqz	s3,80000b08 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000ae8:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000aec:	85ca                	mv	a1,s2
    80000aee:	855a                	mv	a0,s6
    80000af0:	00000097          	auipc	ra,0x0
    80000af4:	910080e7          	jalr	-1776(ra) # 80000400 <walkaddr>
    if (pa0 == 0) return -1;
    80000af8:	cd01                	beqz	a0,80000b10 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000afa:	418904b3          	sub	s1,s2,s8
    80000afe:	94d6                	add	s1,s1,s5
    80000b00:	fc99f2e3          	bgeu	s3,s1,80000ac4 <copyin+0x28>
    80000b04:	84ce                	mv	s1,s3
    80000b06:	bf7d                	j	80000ac4 <copyin+0x28>
  }
  return 0;
    80000b08:	4501                	li	a0,0
    80000b0a:	a021                	j	80000b12 <copyin+0x76>
    80000b0c:	4501                	li	a0,0
}
    80000b0e:	8082                	ret
    if (pa0 == 0) return -1;
    80000b10:	557d                	li	a0,-1
}
    80000b12:	60a6                	ld	ra,72(sp)
    80000b14:	6406                	ld	s0,64(sp)
    80000b16:	74e2                	ld	s1,56(sp)
    80000b18:	7942                	ld	s2,48(sp)
    80000b1a:	79a2                	ld	s3,40(sp)
    80000b1c:	7a02                	ld	s4,32(sp)
    80000b1e:	6ae2                	ld	s5,24(sp)
    80000b20:	6b42                	ld	s6,16(sp)
    80000b22:	6ba2                	ld	s7,8(sp)
    80000b24:	6c02                	ld	s8,0(sp)
    80000b26:	6161                	addi	sp,sp,80
    80000b28:	8082                	ret

0000000080000b2a <copyinstr>:
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0) {
    80000b2a:	c2dd                	beqz	a3,80000bd0 <copyinstr+0xa6>
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
    80000b2c:	715d                	addi	sp,sp,-80
    80000b2e:	e486                	sd	ra,72(sp)
    80000b30:	e0a2                	sd	s0,64(sp)
    80000b32:	fc26                	sd	s1,56(sp)
    80000b34:	f84a                	sd	s2,48(sp)
    80000b36:	f44e                	sd	s3,40(sp)
    80000b38:	f052                	sd	s4,32(sp)
    80000b3a:	ec56                	sd	s5,24(sp)
    80000b3c:	e85a                	sd	s6,16(sp)
    80000b3e:	e45e                	sd	s7,8(sp)
    80000b40:	0880                	addi	s0,sp,80
    80000b42:	8a2a                	mv	s4,a0
    80000b44:	8b2e                	mv	s6,a1
    80000b46:	8bb2                	mv	s7,a2
    80000b48:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000b4a:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0) return -1;
    n = PGSIZE - (srcva - va0);
    80000b4c:	6985                	lui	s3,0x1
    80000b4e:	a02d                	j	80000b78 <copyinstr+0x4e>
    if (n > max) n = max;

    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0) {
      if (*p == '\0') {
        *dst = '\0';
    80000b50:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000b54:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null) {
    80000b56:	37fd                	addiw	a5,a5,-1
    80000b58:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b5c:	60a6                	ld	ra,72(sp)
    80000b5e:	6406                	ld	s0,64(sp)
    80000b60:	74e2                	ld	s1,56(sp)
    80000b62:	7942                	ld	s2,48(sp)
    80000b64:	79a2                	ld	s3,40(sp)
    80000b66:	7a02                	ld	s4,32(sp)
    80000b68:	6ae2                	ld	s5,24(sp)
    80000b6a:	6b42                	ld	s6,16(sp)
    80000b6c:	6ba2                	ld	s7,8(sp)
    80000b6e:	6161                	addi	sp,sp,80
    80000b70:	8082                	ret
    srcva = va0 + PGSIZE;
    80000b72:	01390bb3          	add	s7,s2,s3
  while (got_null == 0 && max > 0) {
    80000b76:	c8a9                	beqz	s1,80000bc8 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000b78:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000b7c:	85ca                	mv	a1,s2
    80000b7e:	8552                	mv	a0,s4
    80000b80:	00000097          	auipc	ra,0x0
    80000b84:	880080e7          	jalr	-1920(ra) # 80000400 <walkaddr>
    if (pa0 == 0) return -1;
    80000b88:	c131                	beqz	a0,80000bcc <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000b8a:	417906b3          	sub	a3,s2,s7
    80000b8e:	96ce                	add	a3,a3,s3
    80000b90:	00d4f363          	bgeu	s1,a3,80000b96 <copyinstr+0x6c>
    80000b94:	86a6                	mv	a3,s1
    char *p = (char *)(pa0 + (srcva - va0));
    80000b96:	955e                	add	a0,a0,s7
    80000b98:	41250533          	sub	a0,a0,s2
    while (n > 0) {
    80000b9c:	daf9                	beqz	a3,80000b72 <copyinstr+0x48>
    80000b9e:	87da                	mv	a5,s6
      if (*p == '\0') {
    80000ba0:	41650633          	sub	a2,a0,s6
    80000ba4:	fff48593          	addi	a1,s1,-1
    80000ba8:	95da                	add	a1,a1,s6
    while (n > 0) {
    80000baa:	96da                	add	a3,a3,s6
      if (*p == '\0') {
    80000bac:	00f60733          	add	a4,a2,a5
    80000bb0:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffe3b00>
    80000bb4:	df51                	beqz	a4,80000b50 <copyinstr+0x26>
        *dst = *p;
    80000bb6:	00e78023          	sb	a4,0(a5)
      --max;
    80000bba:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000bbe:	0785                	addi	a5,a5,1
    while (n > 0) {
    80000bc0:	fed796e3          	bne	a5,a3,80000bac <copyinstr+0x82>
      dst++;
    80000bc4:	8b3e                	mv	s6,a5
    80000bc6:	b775                	j	80000b72 <copyinstr+0x48>
    80000bc8:	4781                	li	a5,0
    80000bca:	b771                	j	80000b56 <copyinstr+0x2c>
    if (pa0 == 0) return -1;
    80000bcc:	557d                	li	a0,-1
    80000bce:	b779                	j	80000b5c <copyinstr+0x32>
  int got_null = 0;
    80000bd0:	4781                	li	a5,0
  if (got_null) {
    80000bd2:	37fd                	addiw	a5,a5,-1
    80000bd4:	0007851b          	sext.w	a0,a5
}
    80000bd8:	8082                	ret

0000000080000bda <proc_mapstacks>:
//struct spinlock proc_list_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl) {
    80000bda:	1141                	addi	sp,sp,-16
    80000bdc:	e422                	sd	s0,8(sp)
    80000bde:	0800                	addi	s0,sp,16
  kpagetable = kpgtbl;
    80000be0:	00008797          	auipc	a5,0x8
    80000be4:	dea7bc23          	sd	a0,-520(a5) # 800089d8 <kpagetable>
}
    80000be8:	6422                	ld	s0,8(sp)
    80000bea:	0141                	addi	sp,sp,16
    80000bec:	8082                	ret

0000000080000bee <procinit>:

// initialize the proc table.
void procinit(void) {
    80000bee:	1141                	addi	sp,sp,-16
    80000bf0:	e406                	sd	ra,8(sp)
    80000bf2:	e022                	sd	s0,0(sp)
    80000bf4:	0800                	addi	s0,sp,16
  initlock(&pid_lock, "nextpid");
    80000bf6:	00007597          	auipc	a1,0x7
    80000bfa:	54258593          	addi	a1,a1,1346 # 80008138 <etext+0x138>
    80000bfe:	00008517          	auipc	a0,0x8
    80000c02:	e2250513          	addi	a0,a0,-478 # 80008a20 <pid_lock>
    80000c06:	00006097          	auipc	ra,0x6
    80000c0a:	f26080e7          	jalr	-218(ra) # 80006b2c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000c0e:	00007597          	auipc	a1,0x7
    80000c12:	53258593          	addi	a1,a1,1330 # 80008140 <etext+0x140>
    80000c16:	00008517          	auipc	a0,0x8
    80000c1a:	e2250513          	addi	a0,a0,-478 # 80008a38 <wait_lock>
    80000c1e:	00006097          	auipc	ra,0x6
    80000c22:	f0e080e7          	jalr	-242(ra) # 80006b2c <initlock>
  lst_init(&proc_list);
    80000c26:	00008517          	auipc	a0,0x8
    80000c2a:	e2a50513          	addi	a0,a0,-470 # 80008a50 <proc_list>
    80000c2e:	00005097          	auipc	ra,0x5
    80000c32:	45a080e7          	jalr	1114(ra) # 80006088 <lst_init>
  //  initlock(&proc_list_lock, "proc_list");
}
    80000c36:	60a2                	ld	ra,8(sp)
    80000c38:	6402                	ld	s0,0(sp)
    80000c3a:	0141                	addi	sp,sp,16
    80000c3c:	8082                	ret

0000000080000c3e <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid() {
    80000c3e:	1141                	addi	sp,sp,-16
    80000c40:	e422                	sd	s0,8(sp)
    80000c42:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    80000c44:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000c46:	2501                	sext.w	a0,a0
    80000c48:	6422                	ld	s0,8(sp)
    80000c4a:	0141                	addi	sp,sp,16
    80000c4c:	8082                	ret

0000000080000c4e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *mycpu(void) {
    80000c4e:	1141                	addi	sp,sp,-16
    80000c50:	e422                	sd	s0,8(sp)
    80000c52:	0800                	addi	s0,sp,16
    80000c54:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000c56:	2781                	sext.w	a5,a5
    80000c58:	079e                	slli	a5,a5,0x7
  return c;
}
    80000c5a:	00008517          	auipc	a0,0x8
    80000c5e:	e0650513          	addi	a0,a0,-506 # 80008a60 <cpus>
    80000c62:	953e                	add	a0,a0,a5
    80000c64:	6422                	ld	s0,8(sp)
    80000c66:	0141                	addi	sp,sp,16
    80000c68:	8082                	ret

0000000080000c6a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *myproc(void) {
    80000c6a:	1101                	addi	sp,sp,-32
    80000c6c:	ec06                	sd	ra,24(sp)
    80000c6e:	e822                	sd	s0,16(sp)
    80000c70:	e426                	sd	s1,8(sp)
    80000c72:	1000                	addi	s0,sp,32
  push_off();
    80000c74:	00006097          	auipc	ra,0x6
    80000c78:	efc080e7          	jalr	-260(ra) # 80006b70 <push_off>
    80000c7c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000c7e:	2781                	sext.w	a5,a5
    80000c80:	079e                	slli	a5,a5,0x7
    80000c82:	00008717          	auipc	a4,0x8
    80000c86:	d9e70713          	addi	a4,a4,-610 # 80008a20 <pid_lock>
    80000c8a:	97ba                	add	a5,a5,a4
    80000c8c:	63a4                	ld	s1,64(a5)
  pop_off();
    80000c8e:	00006097          	auipc	ra,0x6
    80000c92:	f7c080e7          	jalr	-132(ra) # 80006c0a <pop_off>
  return p;
}
    80000c96:	8526                	mv	a0,s1
    80000c98:	60e2                	ld	ra,24(sp)
    80000c9a:	6442                	ld	s0,16(sp)
    80000c9c:	64a2                	ld	s1,8(sp)
    80000c9e:	6105                	addi	sp,sp,32
    80000ca0:	8082                	ret

0000000080000ca2 <forkret>:
  release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void) {
    80000ca2:	1141                	addi	sp,sp,-16
    80000ca4:	e406                	sd	ra,8(sp)
    80000ca6:	e022                	sd	s0,0(sp)
    80000ca8:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000caa:	00000097          	auipc	ra,0x0
    80000cae:	fc0080e7          	jalr	-64(ra) # 80000c6a <myproc>
    80000cb2:	00006097          	auipc	ra,0x6
    80000cb6:	fb8080e7          	jalr	-72(ra) # 80006c6a <release>

  if (first) {
    80000cba:	00008797          	auipc	a5,0x8
    80000cbe:	c967a783          	lw	a5,-874(a5) # 80008950 <first.1>
    80000cc2:	eb89                	bnez	a5,80000cd4 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000cc4:	00001097          	auipc	ra,0x1
    80000cc8:	cdc080e7          	jalr	-804(ra) # 800019a0 <usertrapret>
}
    80000ccc:	60a2                	ld	ra,8(sp)
    80000cce:	6402                	ld	s0,0(sp)
    80000cd0:	0141                	addi	sp,sp,16
    80000cd2:	8082                	ret
    first = 0;
    80000cd4:	00008797          	auipc	a5,0x8
    80000cd8:	c607ae23          	sw	zero,-900(a5) # 80008950 <first.1>
    fsinit(ROOTDEV);
    80000cdc:	4505                	li	a0,1
    80000cde:	00002097          	auipc	ra,0x2
    80000ce2:	a0e080e7          	jalr	-1522(ra) # 800026ec <fsinit>
    80000ce6:	bff9                	j	80000cc4 <forkret+0x22>

0000000080000ce8 <allocpid>:
int allocpid() {
    80000ce8:	1101                	addi	sp,sp,-32
    80000cea:	ec06                	sd	ra,24(sp)
    80000cec:	e822                	sd	s0,16(sp)
    80000cee:	e426                	sd	s1,8(sp)
    80000cf0:	e04a                	sd	s2,0(sp)
    80000cf2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000cf4:	00008917          	auipc	s2,0x8
    80000cf8:	d2c90913          	addi	s2,s2,-724 # 80008a20 <pid_lock>
    80000cfc:	854a                	mv	a0,s2
    80000cfe:	00006097          	auipc	ra,0x6
    80000d02:	ebe080e7          	jalr	-322(ra) # 80006bbc <acquire>
  pid = nextpid;
    80000d06:	00008797          	auipc	a5,0x8
    80000d0a:	c4e78793          	addi	a5,a5,-946 # 80008954 <nextpid>
    80000d0e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000d10:	0014871b          	addiw	a4,s1,1
    80000d14:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000d16:	854a                	mv	a0,s2
    80000d18:	00006097          	auipc	ra,0x6
    80000d1c:	f52080e7          	jalr	-174(ra) # 80006c6a <release>
}
    80000d20:	8526                	mv	a0,s1
    80000d22:	60e2                	ld	ra,24(sp)
    80000d24:	6442                	ld	s0,16(sp)
    80000d26:	64a2                	ld	s1,8(sp)
    80000d28:	6902                	ld	s2,0(sp)
    80000d2a:	6105                	addi	sp,sp,32
    80000d2c:	8082                	ret

0000000080000d2e <allockstack>:
int allockstack() {
    80000d2e:	1101                	addi	sp,sp,-32
    80000d30:	ec06                	sd	ra,24(sp)
    80000d32:	e822                	sd	s0,16(sp)
    80000d34:	e426                	sd	s1,8(sp)
    80000d36:	e04a                	sd	s2,0(sp)
    80000d38:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000d3a:	00008917          	auipc	s2,0x8
    80000d3e:	ce690913          	addi	s2,s2,-794 # 80008a20 <pid_lock>
    80000d42:	854a                	mv	a0,s2
    80000d44:	00006097          	auipc	ra,0x6
    80000d48:	e78080e7          	jalr	-392(ra) # 80006bbc <acquire>
  kstack = nextkstack;
    80000d4c:	00008797          	auipc	a5,0x8
    80000d50:	c8478793          	addi	a5,a5,-892 # 800089d0 <nextkstack>
    80000d54:	4384                	lw	s1,0(a5)
  ++nextkstack;
    80000d56:	0014871b          	addiw	a4,s1,1
    80000d5a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000d5c:	854a                	mv	a0,s2
    80000d5e:	00006097          	auipc	ra,0x6
    80000d62:	f0c080e7          	jalr	-244(ra) # 80006c6a <release>
}
    80000d66:	8526                	mv	a0,s1
    80000d68:	60e2                	ld	ra,24(sp)
    80000d6a:	6442                	ld	s0,16(sp)
    80000d6c:	64a2                	ld	s1,8(sp)
    80000d6e:	6902                	ld	s2,0(sp)
    80000d70:	6105                	addi	sp,sp,32
    80000d72:	8082                	ret

0000000080000d74 <proc_pagetable>:
pagetable_t proc_pagetable(struct proc *p) {
    80000d74:	1101                	addi	sp,sp,-32
    80000d76:	ec06                	sd	ra,24(sp)
    80000d78:	e822                	sd	s0,16(sp)
    80000d7a:	e426                	sd	s1,8(sp)
    80000d7c:	e04a                	sd	s2,0(sp)
    80000d7e:	1000                	addi	s0,sp,32
    80000d80:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000d82:	00000097          	auipc	ra,0x0
    80000d86:	94a080e7          	jalr	-1718(ra) # 800006cc <uvmcreate>
    80000d8a:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    80000d8c:	c121                	beqz	a0,80000dcc <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80000d8e:	4729                	li	a4,10
    80000d90:	00006697          	auipc	a3,0x6
    80000d94:	27068693          	addi	a3,a3,624 # 80007000 <_trampoline>
    80000d98:	6605                	lui	a2,0x1
    80000d9a:	040005b7          	lui	a1,0x4000
    80000d9e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000da0:	05b2                	slli	a1,a1,0xc
    80000da2:	fffff097          	auipc	ra,0xfffff
    80000da6:	6a0080e7          	jalr	1696(ra) # 80000442 <mappages>
    80000daa:	02054863          	bltz	a0,80000dda <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80000dae:	4719                	li	a4,6
    80000db0:	05893683          	ld	a3,88(s2)
    80000db4:	6605                	lui	a2,0x1
    80000db6:	020005b7          	lui	a1,0x2000
    80000dba:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000dbc:	05b6                	slli	a1,a1,0xd
    80000dbe:	8526                	mv	a0,s1
    80000dc0:	fffff097          	auipc	ra,0xfffff
    80000dc4:	682080e7          	jalr	1666(ra) # 80000442 <mappages>
    80000dc8:	02054163          	bltz	a0,80000dea <proc_pagetable+0x76>
}
    80000dcc:	8526                	mv	a0,s1
    80000dce:	60e2                	ld	ra,24(sp)
    80000dd0:	6442                	ld	s0,16(sp)
    80000dd2:	64a2                	ld	s1,8(sp)
    80000dd4:	6902                	ld	s2,0(sp)
    80000dd6:	6105                	addi	sp,sp,32
    80000dd8:	8082                	ret
    uvmfree(pagetable, 0);
    80000dda:	4581                	li	a1,0
    80000ddc:	8526                	mv	a0,s1
    80000dde:	00000097          	auipc	ra,0x0
    80000de2:	af4080e7          	jalr	-1292(ra) # 800008d2 <uvmfree>
    return 0;
    80000de6:	4481                	li	s1,0
    80000de8:	b7d5                	j	80000dcc <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000dea:	4681                	li	a3,0
    80000dec:	4605                	li	a2,1
    80000dee:	040005b7          	lui	a1,0x4000
    80000df2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000df4:	05b2                	slli	a1,a1,0xc
    80000df6:	8526                	mv	a0,s1
    80000df8:	00000097          	auipc	ra,0x0
    80000dfc:	810080e7          	jalr	-2032(ra) # 80000608 <uvmunmap>
    uvmfree(pagetable, 0);
    80000e00:	4581                	li	a1,0
    80000e02:	8526                	mv	a0,s1
    80000e04:	00000097          	auipc	ra,0x0
    80000e08:	ace080e7          	jalr	-1330(ra) # 800008d2 <uvmfree>
    return 0;
    80000e0c:	4481                	li	s1,0
    80000e0e:	bf7d                	j	80000dcc <proc_pagetable+0x58>

0000000080000e10 <proc_freepagetable>:
void proc_freepagetable(pagetable_t pagetable, uint64 sz) {
    80000e10:	1101                	addi	sp,sp,-32
    80000e12:	ec06                	sd	ra,24(sp)
    80000e14:	e822                	sd	s0,16(sp)
    80000e16:	e426                	sd	s1,8(sp)
    80000e18:	e04a                	sd	s2,0(sp)
    80000e1a:	1000                	addi	s0,sp,32
    80000e1c:	84aa                	mv	s1,a0
    80000e1e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e20:	4681                	li	a3,0
    80000e22:	4605                	li	a2,1
    80000e24:	040005b7          	lui	a1,0x4000
    80000e28:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e2a:	05b2                	slli	a1,a1,0xc
    80000e2c:	fffff097          	auipc	ra,0xfffff
    80000e30:	7dc080e7          	jalr	2012(ra) # 80000608 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000e34:	4681                	li	a3,0
    80000e36:	4605                	li	a2,1
    80000e38:	020005b7          	lui	a1,0x2000
    80000e3c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000e3e:	05b6                	slli	a1,a1,0xd
    80000e40:	8526                	mv	a0,s1
    80000e42:	fffff097          	auipc	ra,0xfffff
    80000e46:	7c6080e7          	jalr	1990(ra) # 80000608 <uvmunmap>
  uvmfree(pagetable, sz);
    80000e4a:	85ca                	mv	a1,s2
    80000e4c:	8526                	mv	a0,s1
    80000e4e:	00000097          	auipc	ra,0x0
    80000e52:	a84080e7          	jalr	-1404(ra) # 800008d2 <uvmfree>
}
    80000e56:	60e2                	ld	ra,24(sp)
    80000e58:	6442                	ld	s0,16(sp)
    80000e5a:	64a2                	ld	s1,8(sp)
    80000e5c:	6902                	ld	s2,0(sp)
    80000e5e:	6105                	addi	sp,sp,32
    80000e60:	8082                	ret

0000000080000e62 <freeproc>:
static void freeproc(struct proc *p) {
    80000e62:	1101                	addi	sp,sp,-32
    80000e64:	ec06                	sd	ra,24(sp)
    80000e66:	e822                	sd	s0,16(sp)
    80000e68:	e426                	sd	s1,8(sp)
    80000e6a:	1000                	addi	s0,sp,32
    80000e6c:	84aa                	mv	s1,a0
  if (p->trapframe) kfree((void *)p->trapframe);
    80000e6e:	6d28                	ld	a0,88(a0)
    80000e70:	c509                	beqz	a0,80000e7a <freeproc+0x18>
    80000e72:	fffff097          	auipc	ra,0xfffff
    80000e76:	1d2080e7          	jalr	466(ra) # 80000044 <kfree>
  if (p->pagetable) proc_freepagetable(p->pagetable, p->sz);
    80000e7a:	68a8                	ld	a0,80(s1)
    80000e7c:	c511                	beqz	a0,80000e88 <freeproc+0x26>
    80000e7e:	64ac                	ld	a1,72(s1)
    80000e80:	00000097          	auipc	ra,0x0
    80000e84:	f90080e7          	jalr	-112(ra) # 80000e10 <proc_freepagetable>
  kfree((void *)p->kstack_pa);
    80000e88:	1784b503          	ld	a0,376(s1)
    80000e8c:	fffff097          	auipc	ra,0xfffff
    80000e90:	1b8080e7          	jalr	440(ra) # 80000044 <kfree>
  lst_pop(&p->list);
    80000e94:	16848513          	addi	a0,s1,360
    80000e98:	00005097          	auipc	ra,0x5
    80000e9c:	22c080e7          	jalr	556(ra) # 800060c4 <lst_pop>
  bd_free(p);
    80000ea0:	8526                	mv	a0,s1
    80000ea2:	00005097          	auipc	ra,0x5
    80000ea6:	ada080e7          	jalr	-1318(ra) # 8000597c <bd_free>
}
    80000eaa:	60e2                	ld	ra,24(sp)
    80000eac:	6442                	ld	s0,16(sp)
    80000eae:	64a2                	ld	s1,8(sp)
    80000eb0:	6105                	addi	sp,sp,32
    80000eb2:	8082                	ret

0000000080000eb4 <allocproc>:
static struct proc *allocproc(void) {
    80000eb4:	1101                	addi	sp,sp,-32
    80000eb6:	ec06                	sd	ra,24(sp)
    80000eb8:	e822                	sd	s0,16(sp)
    80000eba:	e426                	sd	s1,8(sp)
    80000ebc:	e04a                	sd	s2,0(sp)
    80000ebe:	1000                	addi	s0,sp,32
  struct proc *p = bd_malloc(sizeof(struct proc));
    80000ec0:	18000513          	li	a0,384
    80000ec4:	00005097          	auipc	ra,0x5
    80000ec8:	8ba080e7          	jalr	-1862(ra) # 8000577e <bd_malloc>
    80000ecc:	84aa                	mv	s1,a0
  if (p == 0) {
    80000ece:	c155                	beqz	a0,80000f72 <allocproc+0xbe>
  memset(p, 0, sizeof(struct proc));
    80000ed0:	18000613          	li	a2,384
    80000ed4:	4581                	li	a1,0
    80000ed6:	fffff097          	auipc	ra,0xfffff
    80000eda:	1a0080e7          	jalr	416(ra) # 80000076 <memset>
  p->pid = allocpid();
    80000ede:	00000097          	auipc	ra,0x0
    80000ee2:	e0a080e7          	jalr	-502(ra) # 80000ce8 <allocpid>
    80000ee6:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000ee8:	4785                	li	a5,1
    80000eea:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80000eec:	fffff097          	auipc	ra,0xfffff
    80000ef0:	170080e7          	jalr	368(ra) # 8000005c <kalloc>
    80000ef4:	892a                	mv	s2,a0
    80000ef6:	eca8                	sd	a0,88(s1)
    80000ef8:	c541                	beqz	a0,80000f80 <allocproc+0xcc>
  if ((p->kstack_pa = kalloc()) == 0) {
    80000efa:	fffff097          	auipc	ra,0xfffff
    80000efe:	162080e7          	jalr	354(ra) # 8000005c <kalloc>
    80000f02:	892a                	mv	s2,a0
    80000f04:	16a4bc23          	sd	a0,376(s1)
    80000f08:	c159                	beqz	a0,80000f8e <allocproc+0xda>
  p->kstack = KSTACK(allockstack());
    80000f0a:	00000097          	auipc	ra,0x0
    80000f0e:	e24080e7          	jalr	-476(ra) # 80000d2e <allockstack>
    80000f12:	2505                	addiw	a0,a0,1
    80000f14:	00d5151b          	slliw	a0,a0,0xd
    80000f18:	040005b7          	lui	a1,0x4000
    80000f1c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f1e:	05b2                	slli	a1,a1,0xc
    80000f20:	8d89                	sub	a1,a1,a0
    80000f22:	e0ac                	sd	a1,64(s1)
  kvmmap(kpagetable, p->kstack, (uint64)p->kstack_pa, PGSIZE, PTE_R | PTE_W);
    80000f24:	4719                	li	a4,6
    80000f26:	6685                	lui	a3,0x1
    80000f28:	1784b603          	ld	a2,376(s1)
    80000f2c:	00008517          	auipc	a0,0x8
    80000f30:	aac53503          	ld	a0,-1364(a0) # 800089d8 <kpagetable>
    80000f34:	fffff097          	auipc	ra,0xfffff
    80000f38:	5ae080e7          	jalr	1454(ra) # 800004e2 <kvmmap>
  p->pagetable = proc_pagetable(p);
    80000f3c:	8526                	mv	a0,s1
    80000f3e:	00000097          	auipc	ra,0x0
    80000f42:	e36080e7          	jalr	-458(ra) # 80000d74 <proc_pagetable>
    80000f46:	892a                	mv	s2,a0
    80000f48:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    80000f4a:	c929                	beqz	a0,80000f9c <allocproc+0xe8>
  p->context.ra = (uint64)forkret;
    80000f4c:	00000797          	auipc	a5,0x0
    80000f50:	d5678793          	addi	a5,a5,-682 # 80000ca2 <forkret>
    80000f54:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000f56:	60bc                	ld	a5,64(s1)
    80000f58:	6705                	lui	a4,0x1
    80000f5a:	97ba                	add	a5,a5,a4
    80000f5c:	f4bc                	sd	a5,104(s1)
  lst_push(&proc_list, &p->list);
    80000f5e:	16848593          	addi	a1,s1,360
    80000f62:	00008517          	auipc	a0,0x8
    80000f66:	aee50513          	addi	a0,a0,-1298 # 80008a50 <proc_list>
    80000f6a:	00005097          	auipc	ra,0x5
    80000f6e:	190080e7          	jalr	400(ra) # 800060fa <lst_push>
}
    80000f72:	8526                	mv	a0,s1
    80000f74:	60e2                	ld	ra,24(sp)
    80000f76:	6442                	ld	s0,16(sp)
    80000f78:	64a2                	ld	s1,8(sp)
    80000f7a:	6902                	ld	s2,0(sp)
    80000f7c:	6105                	addi	sp,sp,32
    80000f7e:	8082                	ret
    freeproc(p);
    80000f80:	8526                	mv	a0,s1
    80000f82:	00000097          	auipc	ra,0x0
    80000f86:	ee0080e7          	jalr	-288(ra) # 80000e62 <freeproc>
    return 0;
    80000f8a:	84ca                	mv	s1,s2
    80000f8c:	b7dd                	j	80000f72 <allocproc+0xbe>
    freeproc(p);
    80000f8e:	8526                	mv	a0,s1
    80000f90:	00000097          	auipc	ra,0x0
    80000f94:	ed2080e7          	jalr	-302(ra) # 80000e62 <freeproc>
    return 0;
    80000f98:	84ca                	mv	s1,s2
    80000f9a:	bfe1                	j	80000f72 <allocproc+0xbe>
    freeproc(p);
    80000f9c:	8526                	mv	a0,s1
    80000f9e:	00000097          	auipc	ra,0x0
    80000fa2:	ec4080e7          	jalr	-316(ra) # 80000e62 <freeproc>
    return 0;
    80000fa6:	84ca                	mv	s1,s2
    80000fa8:	b7e9                	j	80000f72 <allocproc+0xbe>

0000000080000faa <userinit>:
void userinit(void) {
    80000faa:	1101                	addi	sp,sp,-32
    80000fac:	ec06                	sd	ra,24(sp)
    80000fae:	e822                	sd	s0,16(sp)
    80000fb0:	e426                	sd	s1,8(sp)
    80000fb2:	1000                	addi	s0,sp,32
  p = allocproc();
    80000fb4:	00000097          	auipc	ra,0x0
    80000fb8:	f00080e7          	jalr	-256(ra) # 80000eb4 <allocproc>
    80000fbc:	84aa                	mv	s1,a0
  initproc = p;
    80000fbe:	00008797          	auipc	a5,0x8
    80000fc2:	a2a7b123          	sd	a0,-1502(a5) # 800089e0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80000fc6:	03400613          	li	a2,52
    80000fca:	00008597          	auipc	a1,0x8
    80000fce:	99658593          	addi	a1,a1,-1642 # 80008960 <initcode>
    80000fd2:	6928                	ld	a0,80(a0)
    80000fd4:	fffff097          	auipc	ra,0xfffff
    80000fd8:	726080e7          	jalr	1830(ra) # 800006fa <uvmfirst>
  p->sz = PGSIZE;
    80000fdc:	6785                	lui	a5,0x1
    80000fde:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80000fe0:	6cb8                	ld	a4,88(s1)
    80000fe2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80000fe6:	6cb8                	ld	a4,88(s1)
    80000fe8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80000fea:	4641                	li	a2,16
    80000fec:	00007597          	auipc	a1,0x7
    80000ff0:	16458593          	addi	a1,a1,356 # 80008150 <etext+0x150>
    80000ff4:	15848513          	addi	a0,s1,344
    80000ff8:	fffff097          	auipc	ra,0xfffff
    80000ffc:	1c8080e7          	jalr	456(ra) # 800001c0 <safestrcpy>
  p->cwd = namei("/");
    80001000:	00007517          	auipc	a0,0x7
    80001004:	16050513          	addi	a0,a0,352 # 80008160 <etext+0x160>
    80001008:	00002097          	auipc	ra,0x2
    8000100c:	10e080e7          	jalr	270(ra) # 80003116 <namei>
    80001010:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001014:	478d                	li	a5,3
    80001016:	cc9c                	sw	a5,24(s1)
}
    80001018:	60e2                	ld	ra,24(sp)
    8000101a:	6442                	ld	s0,16(sp)
    8000101c:	64a2                	ld	s1,8(sp)
    8000101e:	6105                	addi	sp,sp,32
    80001020:	8082                	ret

0000000080001022 <growproc>:
int growproc(int n) {
    80001022:	1101                	addi	sp,sp,-32
    80001024:	ec06                	sd	ra,24(sp)
    80001026:	e822                	sd	s0,16(sp)
    80001028:	e426                	sd	s1,8(sp)
    8000102a:	e04a                	sd	s2,0(sp)
    8000102c:	1000                	addi	s0,sp,32
    8000102e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001030:	00000097          	auipc	ra,0x0
    80001034:	c3a080e7          	jalr	-966(ra) # 80000c6a <myproc>
    80001038:	84aa                	mv	s1,a0
  sz = p->sz;
    8000103a:	652c                	ld	a1,72(a0)
  if (n > 0) {
    8000103c:	01204c63          	bgtz	s2,80001054 <growproc+0x32>
  } else if (n < 0) {
    80001040:	02094663          	bltz	s2,8000106c <growproc+0x4a>
  p->sz = sz;
    80001044:	e4ac                	sd	a1,72(s1)
  return 0;
    80001046:	4501                	li	a0,0
}
    80001048:	60e2                	ld	ra,24(sp)
    8000104a:	6442                	ld	s0,16(sp)
    8000104c:	64a2                	ld	s1,8(sp)
    8000104e:	6902                	ld	s2,0(sp)
    80001050:	6105                	addi	sp,sp,32
    80001052:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001054:	4691                	li	a3,4
    80001056:	00b90633          	add	a2,s2,a1
    8000105a:	6928                	ld	a0,80(a0)
    8000105c:	fffff097          	auipc	ra,0xfffff
    80001060:	758080e7          	jalr	1880(ra) # 800007b4 <uvmalloc>
    80001064:	85aa                	mv	a1,a0
    80001066:	fd79                	bnez	a0,80001044 <growproc+0x22>
      return -1;
    80001068:	557d                	li	a0,-1
    8000106a:	bff9                	j	80001048 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000106c:	00b90633          	add	a2,s2,a1
    80001070:	6928                	ld	a0,80(a0)
    80001072:	fffff097          	auipc	ra,0xfffff
    80001076:	6fa080e7          	jalr	1786(ra) # 8000076c <uvmdealloc>
    8000107a:	85aa                	mv	a1,a0
    8000107c:	b7e1                	j	80001044 <growproc+0x22>

000000008000107e <fork>:
int fork(void) {
    8000107e:	7139                	addi	sp,sp,-64
    80001080:	fc06                	sd	ra,56(sp)
    80001082:	f822                	sd	s0,48(sp)
    80001084:	f426                	sd	s1,40(sp)
    80001086:	f04a                	sd	s2,32(sp)
    80001088:	ec4e                	sd	s3,24(sp)
    8000108a:	e852                	sd	s4,16(sp)
    8000108c:	e456                	sd	s5,8(sp)
    8000108e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001090:	00000097          	auipc	ra,0x0
    80001094:	bda080e7          	jalr	-1062(ra) # 80000c6a <myproc>
    80001098:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    8000109a:	00000097          	auipc	ra,0x0
    8000109e:	e1a080e7          	jalr	-486(ra) # 80000eb4 <allocproc>
    800010a2:	c57d                	beqz	a0,80001190 <fork+0x112>
    800010a4:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    800010a6:	048ab603          	ld	a2,72(s5) # fffffffffffff048 <end+0xffffffff7ffe3b48>
    800010aa:	692c                	ld	a1,80(a0)
    800010ac:	050ab503          	ld	a0,80(s5)
    800010b0:	00000097          	auipc	ra,0x0
    800010b4:	85c080e7          	jalr	-1956(ra) # 8000090c <uvmcopy>
    800010b8:	04054863          	bltz	a0,80001108 <fork+0x8a>
  np->sz = p->sz;
    800010bc:	048ab783          	ld	a5,72(s5)
    800010c0:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800010c4:	058ab683          	ld	a3,88(s5)
    800010c8:	87b6                	mv	a5,a3
    800010ca:	058a3703          	ld	a4,88(s4)
    800010ce:	12068693          	addi	a3,a3,288 # 1120 <_entry-0x7fffeee0>
    800010d2:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800010d6:	6788                	ld	a0,8(a5)
    800010d8:	6b8c                	ld	a1,16(a5)
    800010da:	6f90                	ld	a2,24(a5)
    800010dc:	01073023          	sd	a6,0(a4)
    800010e0:	e708                	sd	a0,8(a4)
    800010e2:	eb0c                	sd	a1,16(a4)
    800010e4:	ef10                	sd	a2,24(a4)
    800010e6:	02078793          	addi	a5,a5,32
    800010ea:	02070713          	addi	a4,a4,32
    800010ee:	fed792e3          	bne	a5,a3,800010d2 <fork+0x54>
  np->trapframe->a0 = 0;
    800010f2:	058a3783          	ld	a5,88(s4)
    800010f6:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    800010fa:	0d0a8493          	addi	s1,s5,208
    800010fe:	0d0a0913          	addi	s2,s4,208
    80001102:	150a8993          	addi	s3,s5,336
    80001106:	a821                	j	8000111e <fork+0xa0>
    freeproc(np);
    80001108:	8552                	mv	a0,s4
    8000110a:	00000097          	auipc	ra,0x0
    8000110e:	d58080e7          	jalr	-680(ra) # 80000e62 <freeproc>
    return -1;
    80001112:	597d                	li	s2,-1
    80001114:	a0a5                	j	8000117c <fork+0xfe>
  for (i = 0; i < NOFILE; i++)
    80001116:	04a1                	addi	s1,s1,8
    80001118:	0921                	addi	s2,s2,8
    8000111a:	01348b63          	beq	s1,s3,80001130 <fork+0xb2>
    if (p->ofile[i]) np->ofile[i] = filedup(p->ofile[i]);
    8000111e:	6088                	ld	a0,0(s1)
    80001120:	d97d                	beqz	a0,80001116 <fork+0x98>
    80001122:	00002097          	auipc	ra,0x2
    80001126:	63e080e7          	jalr	1598(ra) # 80003760 <filedup>
    8000112a:	00a93023          	sd	a0,0(s2)
    8000112e:	b7e5                	j	80001116 <fork+0x98>
  np->cwd = idup(p->cwd);
    80001130:	150ab503          	ld	a0,336(s5)
    80001134:	00001097          	auipc	ra,0x1
    80001138:	7f8080e7          	jalr	2040(ra) # 8000292c <idup>
    8000113c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001140:	4641                	li	a2,16
    80001142:	158a8593          	addi	a1,s5,344
    80001146:	158a0513          	addi	a0,s4,344
    8000114a:	fffff097          	auipc	ra,0xfffff
    8000114e:	076080e7          	jalr	118(ra) # 800001c0 <safestrcpy>
  pid = np->pid;
    80001152:	030a2903          	lw	s2,48(s4)
  acquire(&wait_lock);
    80001156:	00008497          	auipc	s1,0x8
    8000115a:	8e248493          	addi	s1,s1,-1822 # 80008a38 <wait_lock>
    8000115e:	8526                	mv	a0,s1
    80001160:	00006097          	auipc	ra,0x6
    80001164:	a5c080e7          	jalr	-1444(ra) # 80006bbc <acquire>
  np->parent = p;
    80001168:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000116c:	8526                	mv	a0,s1
    8000116e:	00006097          	auipc	ra,0x6
    80001172:	afc080e7          	jalr	-1284(ra) # 80006c6a <release>
  np->state = RUNNABLE;
    80001176:	478d                	li	a5,3
    80001178:	00fa2c23          	sw	a5,24(s4)
}
    8000117c:	854a                	mv	a0,s2
    8000117e:	70e2                	ld	ra,56(sp)
    80001180:	7442                	ld	s0,48(sp)
    80001182:	74a2                	ld	s1,40(sp)
    80001184:	7902                	ld	s2,32(sp)
    80001186:	69e2                	ld	s3,24(sp)
    80001188:	6a42                	ld	s4,16(sp)
    8000118a:	6aa2                	ld	s5,8(sp)
    8000118c:	6121                	addi	sp,sp,64
    8000118e:	8082                	ret
    return -1;
    80001190:	597d                	li	s2,-1
    80001192:	b7ed                	j	8000117c <fork+0xfe>

0000000080001194 <scheduler>:
void scheduler(void) {
    80001194:	715d                	addi	sp,sp,-80
    80001196:	e486                	sd	ra,72(sp)
    80001198:	e0a2                	sd	s0,64(sp)
    8000119a:	fc26                	sd	s1,56(sp)
    8000119c:	f84a                	sd	s2,48(sp)
    8000119e:	f44e                	sd	s3,40(sp)
    800011a0:	f052                	sd	s4,32(sp)
    800011a2:	ec56                	sd	s5,24(sp)
    800011a4:	e85a                	sd	s6,16(sp)
    800011a6:	e45e                	sd	s7,8(sp)
    800011a8:	0880                	addi	s0,sp,80
    800011aa:	8792                	mv	a5,tp
  int id = r_tp();
    800011ac:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011ae:	00779b93          	slli	s7,a5,0x7
    800011b2:	00008717          	auipc	a4,0x8
    800011b6:	86e70713          	addi	a4,a4,-1938 # 80008a20 <pid_lock>
    800011ba:	975e                	add	a4,a4,s7
    800011bc:	04073023          	sd	zero,64(a4)
        swtch(&c->context, &p->context);
    800011c0:	00008717          	auipc	a4,0x8
    800011c4:	8a870713          	addi	a4,a4,-1880 # 80008a68 <cpus+0x8>
    800011c8:	9bba                	add	s7,s7,a4
    for (struct list *el = proc_list.next; el != &proc_list; el = el->next) {
    800011ca:	00008a97          	auipc	s5,0x8
    800011ce:	856a8a93          	addi	s5,s5,-1962 # 80008a20 <pid_lock>
    800011d2:	00008997          	auipc	s3,0x8
    800011d6:	87e98993          	addi	s3,s3,-1922 # 80008a50 <proc_list>
      if (p->state == RUNNING) {
    800011da:	4a11                	li	s4,4
        c->proc = p;
    800011dc:	079e                	slli	a5,a5,0x7
    800011de:	00fa8b33          	add	s6,s5,a5
    800011e2:	a025                	j	8000120a <scheduler+0x76>
      acquire(&p->lock);
    800011e4:	e9848913          	addi	s2,s1,-360
    800011e8:	854a                	mv	a0,s2
    800011ea:	00006097          	auipc	ra,0x6
    800011ee:	9d2080e7          	jalr	-1582(ra) # 80006bbc <acquire>
      if (p->state == RUNNING) {
    800011f2:	eb04a783          	lw	a5,-336(s1)
    800011f6:	03478563          	beq	a5,s4,80001220 <scheduler+0x8c>
      release(&p->lock);
    800011fa:	854a                	mv	a0,s2
    800011fc:	00006097          	auipc	ra,0x6
    80001200:	a6e080e7          	jalr	-1426(ra) # 80006c6a <release>
    for (struct list *el = proc_list.next; el != &proc_list; el = el->next) {
    80001204:	6084                	ld	s1,0(s1)
    80001206:	fd349fe3          	bne	s1,s3,800011e4 <scheduler+0x50>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000120a:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    8000120e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001212:	10079073          	csrw	sstatus,a5
    80001216:	030ab483          	ld	s1,48(s5)
    8000121a:	fd3495e3          	bne	s1,s3,800011e4 <scheduler+0x50>
    8000121e:	b7f5                	j	8000120a <scheduler+0x76>
        c->proc = p;
    80001220:	052b3023          	sd	s2,64(s6) # 1040 <_entry-0x7fffefc0>
        swtch(&c->context, &p->context);
    80001224:	ef848593          	addi	a1,s1,-264
    80001228:	855e                	mv	a0,s7
    8000122a:	00000097          	auipc	ra,0x0
    8000122e:	6cc080e7          	jalr	1740(ra) # 800018f6 <swtch>
        c->proc = 0;
    80001232:	040b3023          	sd	zero,64(s6)
    80001236:	b7d1                	j	800011fa <scheduler+0x66>

0000000080001238 <sched>:
void sched(void) {
    80001238:	7179                	addi	sp,sp,-48
    8000123a:	f406                	sd	ra,40(sp)
    8000123c:	f022                	sd	s0,32(sp)
    8000123e:	ec26                	sd	s1,24(sp)
    80001240:	e84a                	sd	s2,16(sp)
    80001242:	e44e                	sd	s3,8(sp)
    80001244:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001246:	00000097          	auipc	ra,0x0
    8000124a:	a24080e7          	jalr	-1500(ra) # 80000c6a <myproc>
    8000124e:	84aa                	mv	s1,a0
  if (!holding(&p->lock)) panic("sched p->lock");
    80001250:	00006097          	auipc	ra,0x6
    80001254:	8f2080e7          	jalr	-1806(ra) # 80006b42 <holding>
    80001258:	c93d                	beqz	a0,800012ce <sched+0x96>
  asm volatile("mv %0, tp" : "=r"(x));
    8000125a:	8792                	mv	a5,tp
  if (mycpu()->noff != 1) panic("sched locks");
    8000125c:	2781                	sext.w	a5,a5
    8000125e:	079e                	slli	a5,a5,0x7
    80001260:	00007717          	auipc	a4,0x7
    80001264:	7c070713          	addi	a4,a4,1984 # 80008a20 <pid_lock>
    80001268:	97ba                	add	a5,a5,a4
    8000126a:	0b87a703          	lw	a4,184(a5)
    8000126e:	4785                	li	a5,1
    80001270:	06f71763          	bne	a4,a5,800012de <sched+0xa6>
  if (p->state == RUNNING) panic("sched running");
    80001274:	4c98                	lw	a4,24(s1)
    80001276:	4791                	li	a5,4
    80001278:	06f70b63          	beq	a4,a5,800012ee <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000127c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001280:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("sched interruptible");
    80001282:	efb5                	bnez	a5,800012fe <sched+0xc6>
  asm volatile("mv %0, tp" : "=r"(x));
    80001284:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001286:	00007917          	auipc	s2,0x7
    8000128a:	79a90913          	addi	s2,s2,1946 # 80008a20 <pid_lock>
    8000128e:	2781                	sext.w	a5,a5
    80001290:	079e                	slli	a5,a5,0x7
    80001292:	97ca                	add	a5,a5,s2
    80001294:	0bc7a983          	lw	s3,188(a5)
    80001298:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000129a:	2781                	sext.w	a5,a5
    8000129c:	079e                	slli	a5,a5,0x7
    8000129e:	00007597          	auipc	a1,0x7
    800012a2:	7ca58593          	addi	a1,a1,1994 # 80008a68 <cpus+0x8>
    800012a6:	95be                	add	a1,a1,a5
    800012a8:	06048513          	addi	a0,s1,96
    800012ac:	00000097          	auipc	ra,0x0
    800012b0:	64a080e7          	jalr	1610(ra) # 800018f6 <swtch>
    800012b4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800012b6:	2781                	sext.w	a5,a5
    800012b8:	079e                	slli	a5,a5,0x7
    800012ba:	993e                	add	s2,s2,a5
    800012bc:	0b392e23          	sw	s3,188(s2)
}
    800012c0:	70a2                	ld	ra,40(sp)
    800012c2:	7402                	ld	s0,32(sp)
    800012c4:	64e2                	ld	s1,24(sp)
    800012c6:	6942                	ld	s2,16(sp)
    800012c8:	69a2                	ld	s3,8(sp)
    800012ca:	6145                	addi	sp,sp,48
    800012cc:	8082                	ret
  if (!holding(&p->lock)) panic("sched p->lock");
    800012ce:	00007517          	auipc	a0,0x7
    800012d2:	e9a50513          	addi	a0,a0,-358 # 80008168 <etext+0x168>
    800012d6:	00005097          	auipc	ra,0x5
    800012da:	3ae080e7          	jalr	942(ra) # 80006684 <panic>
  if (mycpu()->noff != 1) panic("sched locks");
    800012de:	00007517          	auipc	a0,0x7
    800012e2:	e9a50513          	addi	a0,a0,-358 # 80008178 <etext+0x178>
    800012e6:	00005097          	auipc	ra,0x5
    800012ea:	39e080e7          	jalr	926(ra) # 80006684 <panic>
  if (p->state == RUNNING) panic("sched running");
    800012ee:	00007517          	auipc	a0,0x7
    800012f2:	e9a50513          	addi	a0,a0,-358 # 80008188 <etext+0x188>
    800012f6:	00005097          	auipc	ra,0x5
    800012fa:	38e080e7          	jalr	910(ra) # 80006684 <panic>
  if (intr_get()) panic("sched interruptible");
    800012fe:	00007517          	auipc	a0,0x7
    80001302:	e9a50513          	addi	a0,a0,-358 # 80008198 <etext+0x198>
    80001306:	00005097          	auipc	ra,0x5
    8000130a:	37e080e7          	jalr	894(ra) # 80006684 <panic>

000000008000130e <yield>:
void yield(void) {
    8000130e:	1101                	addi	sp,sp,-32
    80001310:	ec06                	sd	ra,24(sp)
    80001312:	e822                	sd	s0,16(sp)
    80001314:	e426                	sd	s1,8(sp)
    80001316:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001318:	00000097          	auipc	ra,0x0
    8000131c:	952080e7          	jalr	-1710(ra) # 80000c6a <myproc>
    80001320:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001322:	00006097          	auipc	ra,0x6
    80001326:	89a080e7          	jalr	-1894(ra) # 80006bbc <acquire>
  p->state = RUNNABLE;
    8000132a:	478d                	li	a5,3
    8000132c:	cc9c                	sw	a5,24(s1)
  sched();
    8000132e:	00000097          	auipc	ra,0x0
    80001332:	f0a080e7          	jalr	-246(ra) # 80001238 <sched>
  release(&p->lock);
    80001336:	8526                	mv	a0,s1
    80001338:	00006097          	auipc	ra,0x6
    8000133c:	932080e7          	jalr	-1742(ra) # 80006c6a <release>
}
    80001340:	60e2                	ld	ra,24(sp)
    80001342:	6442                	ld	s0,16(sp)
    80001344:	64a2                	ld	s1,8(sp)
    80001346:	6105                	addi	sp,sp,32
    80001348:	8082                	ret

000000008000134a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk) {
    8000134a:	7179                	addi	sp,sp,-48
    8000134c:	f406                	sd	ra,40(sp)
    8000134e:	f022                	sd	s0,32(sp)
    80001350:	ec26                	sd	s1,24(sp)
    80001352:	e84a                	sd	s2,16(sp)
    80001354:	e44e                	sd	s3,8(sp)
    80001356:	1800                	addi	s0,sp,48
    80001358:	89aa                	mv	s3,a0
    8000135a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000135c:	00000097          	auipc	ra,0x0
    80001360:	90e080e7          	jalr	-1778(ra) # 80000c6a <myproc>
    80001364:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  // DOC: sleeplock1
    80001366:	00006097          	auipc	ra,0x6
    8000136a:	856080e7          	jalr	-1962(ra) # 80006bbc <acquire>
  release(lk);
    8000136e:	854a                	mv	a0,s2
    80001370:	00006097          	auipc	ra,0x6
    80001374:	8fa080e7          	jalr	-1798(ra) # 80006c6a <release>

  // Go to sleep.
  p->chan = chan;
    80001378:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000137c:	4789                	li	a5,2
    8000137e:	cc9c                	sw	a5,24(s1)

  sched();
    80001380:	00000097          	auipc	ra,0x0
    80001384:	eb8080e7          	jalr	-328(ra) # 80001238 <sched>

  // Tidy up.
  p->chan = 0;
    80001388:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000138c:	8526                	mv	a0,s1
    8000138e:	00006097          	auipc	ra,0x6
    80001392:	8dc080e7          	jalr	-1828(ra) # 80006c6a <release>
  acquire(lk);
    80001396:	854a                	mv	a0,s2
    80001398:	00006097          	auipc	ra,0x6
    8000139c:	824080e7          	jalr	-2012(ra) # 80006bbc <acquire>
}
    800013a0:	70a2                	ld	ra,40(sp)
    800013a2:	7402                	ld	s0,32(sp)
    800013a4:	64e2                	ld	s1,24(sp)
    800013a6:	6942                	ld	s2,16(sp)
    800013a8:	69a2                	ld	s3,8(sp)
    800013aa:	6145                	addi	sp,sp,48
    800013ac:	8082                	ret

00000000800013ae <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan) {
    800013ae:	7139                	addi	sp,sp,-64
    800013b0:	fc06                	sd	ra,56(sp)
    800013b2:	f822                	sd	s0,48(sp)
    800013b4:	f426                	sd	s1,40(sp)
    800013b6:	f04a                	sd	s2,32(sp)
    800013b8:	ec4e                	sd	s3,24(sp)
    800013ba:	e852                	sd	s4,16(sp)
    800013bc:	e456                	sd	s5,8(sp)
    800013be:	e05a                	sd	s6,0(sp)
    800013c0:	0080                	addi	s0,sp,64
  //  acquire(&proc_list_lock);
  for (struct list *el = proc_list.next; el != &proc_list; el = el->next) {
    800013c2:	00007497          	auipc	s1,0x7
    800013c6:	68e4b483          	ld	s1,1678(s1) # 80008a50 <proc_list>
    800013ca:	00007797          	auipc	a5,0x7
    800013ce:	68678793          	addi	a5,a5,1670 # 80008a50 <proc_list>
    800013d2:	04f48863          	beq	s1,a5,80001422 <wakeup+0x74>
    800013d6:	8aaa                	mv	s5,a0
    struct proc *p = (struct proc *)((char*)el - offsetof(struct proc, list));
    if (p != myproc()) {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan) {
    800013d8:	4a09                	li	s4,2
        p->state = RUNNABLE;
    800013da:	4b0d                	li	s6,3
  for (struct list *el = proc_list.next; el != &proc_list; el = el->next) {
    800013dc:	89be                	mv	s3,a5
    800013de:	a809                	j	800013f0 <wakeup+0x42>
      }
      release(&p->lock);
    800013e0:	854a                	mv	a0,s2
    800013e2:	00006097          	auipc	ra,0x6
    800013e6:	888080e7          	jalr	-1912(ra) # 80006c6a <release>
  for (struct list *el = proc_list.next; el != &proc_list; el = el->next) {
    800013ea:	6084                	ld	s1,0(s1)
    800013ec:	03348b63          	beq	s1,s3,80001422 <wakeup+0x74>
    if (p != myproc()) {
    800013f0:	00000097          	auipc	ra,0x0
    800013f4:	87a080e7          	jalr	-1926(ra) # 80000c6a <myproc>
    struct proc *p = (struct proc *)((char*)el - offsetof(struct proc, list));
    800013f8:	e9848793          	addi	a5,s1,-360
    if (p != myproc()) {
    800013fc:	fea787e3          	beq	a5,a0,800013ea <wakeup+0x3c>
      acquire(&p->lock);
    80001400:	893e                	mv	s2,a5
    80001402:	853e                	mv	a0,a5
    80001404:	00005097          	auipc	ra,0x5
    80001408:	7b8080e7          	jalr	1976(ra) # 80006bbc <acquire>
      if (p->state == SLEEPING && p->chan == chan) {
    8000140c:	eb04a783          	lw	a5,-336(s1)
    80001410:	fd4798e3          	bne	a5,s4,800013e0 <wakeup+0x32>
    80001414:	eb84b783          	ld	a5,-328(s1)
    80001418:	fd5794e3          	bne	a5,s5,800013e0 <wakeup+0x32>
        p->state = RUNNABLE;
    8000141c:	eb64a823          	sw	s6,-336(s1)
    80001420:	b7c1                	j	800013e0 <wakeup+0x32>
    }
  }
  //  release(&proc_list_lock);
}
    80001422:	70e2                	ld	ra,56(sp)
    80001424:	7442                	ld	s0,48(sp)
    80001426:	74a2                	ld	s1,40(sp)
    80001428:	7902                	ld	s2,32(sp)
    8000142a:	69e2                	ld	s3,24(sp)
    8000142c:	6a42                	ld	s4,16(sp)
    8000142e:	6aa2                	ld	s5,8(sp)
    80001430:	6b02                	ld	s6,0(sp)
    80001432:	6121                	addi	sp,sp,64
    80001434:	8082                	ret

0000000080001436 <reparent>:
void reparent(struct proc *p) {
    80001436:	7179                	addi	sp,sp,-48
    80001438:	f406                	sd	ra,40(sp)
    8000143a:	f022                	sd	s0,32(sp)
    8000143c:	ec26                	sd	s1,24(sp)
    8000143e:	e84a                	sd	s2,16(sp)
    80001440:	e44e                	sd	s3,8(sp)
    80001442:	e052                	sd	s4,0(sp)
    80001444:	1800                	addi	s0,sp,48
  for (struct list *el = proc_list.next; el != &proc_list; el = el->next) {
    80001446:	00007497          	auipc	s1,0x7
    8000144a:	60a4b483          	ld	s1,1546(s1) # 80008a50 <proc_list>
    8000144e:	00007797          	auipc	a5,0x7
    80001452:	60278793          	addi	a5,a5,1538 # 80008a50 <proc_list>
    80001456:	02f48963          	beq	s1,a5,80001488 <reparent+0x52>
    8000145a:	892a                	mv	s2,a0
      pp->parent = initproc;
    8000145c:	00007a17          	auipc	s4,0x7
    80001460:	584a0a13          	addi	s4,s4,1412 # 800089e0 <initproc>
  for (struct list *el = proc_list.next; el != &proc_list; el = el->next) {
    80001464:	89be                	mv	s3,a5
    80001466:	a021                	j	8000146e <reparent+0x38>
    80001468:	6084                	ld	s1,0(s1)
    8000146a:	01348f63          	beq	s1,s3,80001488 <reparent+0x52>
    if (pp->parent == p) {
    8000146e:	ed04b783          	ld	a5,-304(s1)
    80001472:	ff279be3          	bne	a5,s2,80001468 <reparent+0x32>
      pp->parent = initproc;
    80001476:	000a3503          	ld	a0,0(s4)
    8000147a:	eca4b823          	sd	a0,-304(s1)
      wakeup(initproc);
    8000147e:	00000097          	auipc	ra,0x0
    80001482:	f30080e7          	jalr	-208(ra) # 800013ae <wakeup>
    80001486:	b7cd                	j	80001468 <reparent+0x32>
}
    80001488:	70a2                	ld	ra,40(sp)
    8000148a:	7402                	ld	s0,32(sp)
    8000148c:	64e2                	ld	s1,24(sp)
    8000148e:	6942                	ld	s2,16(sp)
    80001490:	69a2                	ld	s3,8(sp)
    80001492:	6a02                	ld	s4,0(sp)
    80001494:	6145                	addi	sp,sp,48
    80001496:	8082                	ret

0000000080001498 <exit>:
void exit(int status) {
    80001498:	7179                	addi	sp,sp,-48
    8000149a:	f406                	sd	ra,40(sp)
    8000149c:	f022                	sd	s0,32(sp)
    8000149e:	ec26                	sd	s1,24(sp)
    800014a0:	e84a                	sd	s2,16(sp)
    800014a2:	e44e                	sd	s3,8(sp)
    800014a4:	e052                	sd	s4,0(sp)
    800014a6:	1800                	addi	s0,sp,48
    800014a8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800014aa:	fffff097          	auipc	ra,0xfffff
    800014ae:	7c0080e7          	jalr	1984(ra) # 80000c6a <myproc>
    800014b2:	89aa                	mv	s3,a0
  if (p == initproc) panic("init exiting");
    800014b4:	00007797          	auipc	a5,0x7
    800014b8:	52c7b783          	ld	a5,1324(a5) # 800089e0 <initproc>
    800014bc:	0d050493          	addi	s1,a0,208
    800014c0:	15050913          	addi	s2,a0,336
    800014c4:	02a79363          	bne	a5,a0,800014ea <exit+0x52>
    800014c8:	00007517          	auipc	a0,0x7
    800014cc:	ce850513          	addi	a0,a0,-792 # 800081b0 <etext+0x1b0>
    800014d0:	00005097          	auipc	ra,0x5
    800014d4:	1b4080e7          	jalr	436(ra) # 80006684 <panic>
      fileclose(f);
    800014d8:	00002097          	auipc	ra,0x2
    800014dc:	2cc080e7          	jalr	716(ra) # 800037a4 <fileclose>
      p->ofile[fd] = 0;
    800014e0:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    800014e4:	04a1                	addi	s1,s1,8
    800014e6:	01248563          	beq	s1,s2,800014f0 <exit+0x58>
    if (p->ofile[fd]) {
    800014ea:	6088                	ld	a0,0(s1)
    800014ec:	f575                	bnez	a0,800014d8 <exit+0x40>
    800014ee:	bfdd                	j	800014e4 <exit+0x4c>
  begin_op();
    800014f0:	00002097          	auipc	ra,0x2
    800014f4:	e46080e7          	jalr	-442(ra) # 80003336 <begin_op>
  iput(p->cwd);
    800014f8:	1509b503          	ld	a0,336(s3)
    800014fc:	00001097          	auipc	ra,0x1
    80001500:	628080e7          	jalr	1576(ra) # 80002b24 <iput>
  end_op();
    80001504:	00002097          	auipc	ra,0x2
    80001508:	eb0080e7          	jalr	-336(ra) # 800033b4 <end_op>
  p->cwd = 0;
    8000150c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001510:	00007497          	auipc	s1,0x7
    80001514:	52848493          	addi	s1,s1,1320 # 80008a38 <wait_lock>
    80001518:	8526                	mv	a0,s1
    8000151a:	00005097          	auipc	ra,0x5
    8000151e:	6a2080e7          	jalr	1698(ra) # 80006bbc <acquire>
  reparent(p);
    80001522:	854e                	mv	a0,s3
    80001524:	00000097          	auipc	ra,0x0
    80001528:	f12080e7          	jalr	-238(ra) # 80001436 <reparent>
  wakeup(p->parent);
    8000152c:	0389b503          	ld	a0,56(s3)
    80001530:	00000097          	auipc	ra,0x0
    80001534:	e7e080e7          	jalr	-386(ra) # 800013ae <wakeup>
  acquire(&p->lock);
    80001538:	854e                	mv	a0,s3
    8000153a:	00005097          	auipc	ra,0x5
    8000153e:	682080e7          	jalr	1666(ra) # 80006bbc <acquire>
  p->xstate = status;
    80001542:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001546:	4795                	li	a5,5
    80001548:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000154c:	8526                	mv	a0,s1
    8000154e:	00005097          	auipc	ra,0x5
    80001552:	71c080e7          	jalr	1820(ra) # 80006c6a <release>
  sched();
    80001556:	00000097          	auipc	ra,0x0
    8000155a:	ce2080e7          	jalr	-798(ra) # 80001238 <sched>
  panic("zombie exit");
    8000155e:	00007517          	auipc	a0,0x7
    80001562:	c6250513          	addi	a0,a0,-926 # 800081c0 <etext+0x1c0>
    80001566:	00005097          	auipc	ra,0x5
    8000156a:	11e080e7          	jalr	286(ra) # 80006684 <panic>

000000008000156e <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid) {
    8000156e:	7179                	addi	sp,sp,-48
    80001570:	f406                	sd	ra,40(sp)
    80001572:	f022                	sd	s0,32(sp)
    80001574:	ec26                	sd	s1,24(sp)
    80001576:	e84a                	sd	s2,16(sp)
    80001578:	e44e                	sd	s3,8(sp)
    8000157a:	e052                	sd	s4,0(sp)
    8000157c:	1800                	addi	s0,sp,48
  //  acquire(&proc_list_lock);
  for (struct list *el = proc_list.next; el != &proc_list; el = el->next) {
    8000157e:	00007497          	auipc	s1,0x7
    80001582:	4d24b483          	ld	s1,1234(s1) # 80008a50 <proc_list>
    80001586:	00007797          	auipc	a5,0x7
    8000158a:	4ca78793          	addi	a5,a5,1226 # 80008a50 <proc_list>
    8000158e:	06f48363          	beq	s1,a5,800015f4 <kill+0x86>
    80001592:	89aa                	mv	s3,a0
    80001594:	8a3e                	mv	s4,a5
    struct proc *p = (struct proc *)((char*)el - offsetof(struct proc, list));
    acquire(&p->lock);
    80001596:	e9848913          	addi	s2,s1,-360
    8000159a:	854a                	mv	a0,s2
    8000159c:	00005097          	auipc	ra,0x5
    800015a0:	620080e7          	jalr	1568(ra) # 80006bbc <acquire>
    if (p->pid == pid) {
    800015a4:	ec84a783          	lw	a5,-312(s1)
    800015a8:	01378c63          	beq	a5,s3,800015c0 <kill+0x52>
      }
      release(&p->lock);
      //      release(&proc_list_lock);
      return 0;
    }
    release(&p->lock);
    800015ac:	854a                	mv	a0,s2
    800015ae:	00005097          	auipc	ra,0x5
    800015b2:	6bc080e7          	jalr	1724(ra) # 80006c6a <release>
  for (struct list *el = proc_list.next; el != &proc_list; el = el->next) {
    800015b6:	6084                	ld	s1,0(s1)
    800015b8:	fd449fe3          	bne	s1,s4,80001596 <kill+0x28>
  }
  //  release(&proc_list_lock);
  return -1;
    800015bc:	557d                	li	a0,-1
    800015be:	a839                	j	800015dc <kill+0x6e>
      p->killed = 1;
    800015c0:	4785                	li	a5,1
    800015c2:	ecf4a023          	sw	a5,-320(s1)
      if (p->state == SLEEPING) {
    800015c6:	eb04a703          	lw	a4,-336(s1)
    800015ca:	4789                	li	a5,2
    800015cc:	02f70063          	beq	a4,a5,800015ec <kill+0x7e>
      release(&p->lock);
    800015d0:	854a                	mv	a0,s2
    800015d2:	00005097          	auipc	ra,0x5
    800015d6:	698080e7          	jalr	1688(ra) # 80006c6a <release>
      return 0;
    800015da:	4501                	li	a0,0
}
    800015dc:	70a2                	ld	ra,40(sp)
    800015de:	7402                	ld	s0,32(sp)
    800015e0:	64e2                	ld	s1,24(sp)
    800015e2:	6942                	ld	s2,16(sp)
    800015e4:	69a2                	ld	s3,8(sp)
    800015e6:	6a02                	ld	s4,0(sp)
    800015e8:	6145                	addi	sp,sp,48
    800015ea:	8082                	ret
        p->state = RUNNABLE;
    800015ec:	478d                	li	a5,3
    800015ee:	eaf4a823          	sw	a5,-336(s1)
    800015f2:	bff9                	j	800015d0 <kill+0x62>
  return -1;
    800015f4:	557d                	li	a0,-1
    800015f6:	b7dd                	j	800015dc <kill+0x6e>

00000000800015f8 <setkilled>:

void setkilled(struct proc *p) {
    800015f8:	1101                	addi	sp,sp,-32
    800015fa:	ec06                	sd	ra,24(sp)
    800015fc:	e822                	sd	s0,16(sp)
    800015fe:	e426                	sd	s1,8(sp)
    80001600:	1000                	addi	s0,sp,32
    80001602:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001604:	00005097          	auipc	ra,0x5
    80001608:	5b8080e7          	jalr	1464(ra) # 80006bbc <acquire>
  p->killed = 1;
    8000160c:	4785                	li	a5,1
    8000160e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001610:	8526                	mv	a0,s1
    80001612:	00005097          	auipc	ra,0x5
    80001616:	658080e7          	jalr	1624(ra) # 80006c6a <release>
}
    8000161a:	60e2                	ld	ra,24(sp)
    8000161c:	6442                	ld	s0,16(sp)
    8000161e:	64a2                	ld	s1,8(sp)
    80001620:	6105                	addi	sp,sp,32
    80001622:	8082                	ret

0000000080001624 <killed>:

int killed(struct proc *p) {
    80001624:	1101                	addi	sp,sp,-32
    80001626:	ec06                	sd	ra,24(sp)
    80001628:	e822                	sd	s0,16(sp)
    8000162a:	e426                	sd	s1,8(sp)
    8000162c:	e04a                	sd	s2,0(sp)
    8000162e:	1000                	addi	s0,sp,32
    80001630:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80001632:	00005097          	auipc	ra,0x5
    80001636:	58a080e7          	jalr	1418(ra) # 80006bbc <acquire>
  k = p->killed;
    8000163a:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000163e:	8526                	mv	a0,s1
    80001640:	00005097          	auipc	ra,0x5
    80001644:	62a080e7          	jalr	1578(ra) # 80006c6a <release>
  return k;
}
    80001648:	854a                	mv	a0,s2
    8000164a:	60e2                	ld	ra,24(sp)
    8000164c:	6442                	ld	s0,16(sp)
    8000164e:	64a2                	ld	s1,8(sp)
    80001650:	6902                	ld	s2,0(sp)
    80001652:	6105                	addi	sp,sp,32
    80001654:	8082                	ret

0000000080001656 <wait>:
int wait(uint64 addr) {
    80001656:	711d                	addi	sp,sp,-96
    80001658:	ec86                	sd	ra,88(sp)
    8000165a:	e8a2                	sd	s0,80(sp)
    8000165c:	e4a6                	sd	s1,72(sp)
    8000165e:	e0ca                	sd	s2,64(sp)
    80001660:	fc4e                	sd	s3,56(sp)
    80001662:	f852                	sd	s4,48(sp)
    80001664:	f456                	sd	s5,40(sp)
    80001666:	f05a                	sd	s6,32(sp)
    80001668:	ec5e                	sd	s7,24(sp)
    8000166a:	e862                	sd	s8,16(sp)
    8000166c:	e466                	sd	s9,8(sp)
    8000166e:	1080                	addi	s0,sp,96
    80001670:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80001672:	fffff097          	auipc	ra,0xfffff
    80001676:	5f8080e7          	jalr	1528(ra) # 80000c6a <myproc>
    8000167a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000167c:	00007517          	auipc	a0,0x7
    80001680:	3bc50513          	addi	a0,a0,956 # 80008a38 <wait_lock>
    80001684:	00005097          	auipc	ra,0x5
    80001688:	538080e7          	jalr	1336(ra) # 80006bbc <acquire>
    for (struct list *el = proc_list.next; el != &proc_list; el = el->next) {
    8000168c:	00007c17          	auipc	s8,0x7
    80001690:	394c0c13          	addi	s8,s8,916 # 80008a20 <pid_lock>
    80001694:	00007997          	auipc	s3,0x7
    80001698:	3bc98993          	addi	s3,s3,956 # 80008a50 <proc_list>
        if (pp->state == ZOMBIE) {
    8000169c:	4a95                	li	s5,5
        havekids = 1;
    8000169e:	4b05                	li	s6,1
    sleep(p, &wait_lock);  // DOC: wait-sleep
    800016a0:	00007c97          	auipc	s9,0x7
    800016a4:	398c8c93          	addi	s9,s9,920 # 80008a38 <wait_lock>
    for (struct list *el = proc_list.next; el != &proc_list; el = el->next) {
    800016a8:	030c3483          	ld	s1,48(s8)
    800016ac:	0b348663          	beq	s1,s3,80001758 <wait+0x102>
    havekids = 0;
    800016b0:	4701                	li	a4,0
    800016b2:	a80d                	j	800016e4 <wait+0x8e>
            release(&pp->lock);
    800016b4:	8552                	mv	a0,s4
    800016b6:	00005097          	auipc	ra,0x5
    800016ba:	5b4080e7          	jalr	1460(ra) # 80006c6a <release>
            release(&wait_lock);
    800016be:	00007517          	auipc	a0,0x7
    800016c2:	37a50513          	addi	a0,a0,890 # 80008a38 <wait_lock>
    800016c6:	00005097          	auipc	ra,0x5
    800016ca:	5a4080e7          	jalr	1444(ra) # 80006c6a <release>
            return -1;
    800016ce:	59fd                	li	s3,-1
    800016d0:	a869                	j	8000176a <wait+0x114>
        release(&pp->lock);
    800016d2:	8552                	mv	a0,s4
    800016d4:	00005097          	auipc	ra,0x5
    800016d8:	596080e7          	jalr	1430(ra) # 80006c6a <release>
        havekids = 1;
    800016dc:	875a                	mv	a4,s6
    for (struct list *el = proc_list.next; el != &proc_list; el = el->next) {
    800016de:	6084                	ld	s1,0(s1)
    800016e0:	07348563          	beq	s1,s3,8000174a <wait+0xf4>
      if (pp->parent == p) {
    800016e4:	ed04b783          	ld	a5,-304(s1)
    800016e8:	ff279be3          	bne	a5,s2,800016de <wait+0x88>
        acquire(&pp->lock);
    800016ec:	e9848a13          	addi	s4,s1,-360
    800016f0:	8552                	mv	a0,s4
    800016f2:	00005097          	auipc	ra,0x5
    800016f6:	4ca080e7          	jalr	1226(ra) # 80006bbc <acquire>
        if (pp->state == ZOMBIE) {
    800016fa:	eb04a783          	lw	a5,-336(s1)
    800016fe:	fd579ae3          	bne	a5,s5,800016d2 <wait+0x7c>
          pid = pp->pid;
    80001702:	ec84a983          	lw	s3,-312(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001706:	000b8e63          	beqz	s7,80001722 <wait+0xcc>
    8000170a:	4691                	li	a3,4
    8000170c:	ec448613          	addi	a2,s1,-316
    80001710:	85de                	mv	a1,s7
    80001712:	05093503          	ld	a0,80(s2)
    80001716:	fffff097          	auipc	ra,0xfffff
    8000171a:	2fa080e7          	jalr	762(ra) # 80000a10 <copyout>
    8000171e:	f8054be3          	bltz	a0,800016b4 <wait+0x5e>
          freeproc(pp);
    80001722:	e9848513          	addi	a0,s1,-360
    80001726:	fffff097          	auipc	ra,0xfffff
    8000172a:	73c080e7          	jalr	1852(ra) # 80000e62 <freeproc>
          release(&pp->lock);
    8000172e:	8552                	mv	a0,s4
    80001730:	00005097          	auipc	ra,0x5
    80001734:	53a080e7          	jalr	1338(ra) # 80006c6a <release>
          release(&wait_lock);
    80001738:	00007517          	auipc	a0,0x7
    8000173c:	30050513          	addi	a0,a0,768 # 80008a38 <wait_lock>
    80001740:	00005097          	auipc	ra,0x5
    80001744:	52a080e7          	jalr	1322(ra) # 80006c6a <release>
          return pid;
    80001748:	a00d                	j	8000176a <wait+0x114>
    if (!havekids || killed(p)) {
    8000174a:	c719                	beqz	a4,80001758 <wait+0x102>
    8000174c:	854a                	mv	a0,s2
    8000174e:	00000097          	auipc	ra,0x0
    80001752:	ed6080e7          	jalr	-298(ra) # 80001624 <killed>
    80001756:	c905                	beqz	a0,80001786 <wait+0x130>
      release(&wait_lock);
    80001758:	00007517          	auipc	a0,0x7
    8000175c:	2e050513          	addi	a0,a0,736 # 80008a38 <wait_lock>
    80001760:	00005097          	auipc	ra,0x5
    80001764:	50a080e7          	jalr	1290(ra) # 80006c6a <release>
      return -1;
    80001768:	59fd                	li	s3,-1
}
    8000176a:	854e                	mv	a0,s3
    8000176c:	60e6                	ld	ra,88(sp)
    8000176e:	6446                	ld	s0,80(sp)
    80001770:	64a6                	ld	s1,72(sp)
    80001772:	6906                	ld	s2,64(sp)
    80001774:	79e2                	ld	s3,56(sp)
    80001776:	7a42                	ld	s4,48(sp)
    80001778:	7aa2                	ld	s5,40(sp)
    8000177a:	7b02                	ld	s6,32(sp)
    8000177c:	6be2                	ld	s7,24(sp)
    8000177e:	6c42                	ld	s8,16(sp)
    80001780:	6ca2                	ld	s9,8(sp)
    80001782:	6125                	addi	sp,sp,96
    80001784:	8082                	ret
    sleep(p, &wait_lock);  // DOC: wait-sleep
    80001786:	85e6                	mv	a1,s9
    80001788:	854a                	mv	a0,s2
    8000178a:	00000097          	auipc	ra,0x0
    8000178e:	bc0080e7          	jalr	-1088(ra) # 8000134a <sleep>
    havekids = 0;
    80001792:	bf19                	j	800016a8 <wait+0x52>

0000000080001794 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len) {
    80001794:	7179                	addi	sp,sp,-48
    80001796:	f406                	sd	ra,40(sp)
    80001798:	f022                	sd	s0,32(sp)
    8000179a:	ec26                	sd	s1,24(sp)
    8000179c:	e84a                	sd	s2,16(sp)
    8000179e:	e44e                	sd	s3,8(sp)
    800017a0:	e052                	sd	s4,0(sp)
    800017a2:	1800                	addi	s0,sp,48
    800017a4:	84aa                	mv	s1,a0
    800017a6:	892e                	mv	s2,a1
    800017a8:	89b2                	mv	s3,a2
    800017aa:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800017ac:	fffff097          	auipc	ra,0xfffff
    800017b0:	4be080e7          	jalr	1214(ra) # 80000c6a <myproc>
  if (user_dst) {
    800017b4:	c08d                	beqz	s1,800017d6 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800017b6:	86d2                	mv	a3,s4
    800017b8:	864e                	mv	a2,s3
    800017ba:	85ca                	mv	a1,s2
    800017bc:	6928                	ld	a0,80(a0)
    800017be:	fffff097          	auipc	ra,0xfffff
    800017c2:	252080e7          	jalr	594(ra) # 80000a10 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800017c6:	70a2                	ld	ra,40(sp)
    800017c8:	7402                	ld	s0,32(sp)
    800017ca:	64e2                	ld	s1,24(sp)
    800017cc:	6942                	ld	s2,16(sp)
    800017ce:	69a2                	ld	s3,8(sp)
    800017d0:	6a02                	ld	s4,0(sp)
    800017d2:	6145                	addi	sp,sp,48
    800017d4:	8082                	ret
    memmove((char *)dst, src, len);
    800017d6:	000a061b          	sext.w	a2,s4
    800017da:	85ce                	mv	a1,s3
    800017dc:	854a                	mv	a0,s2
    800017de:	fffff097          	auipc	ra,0xfffff
    800017e2:	8f4080e7          	jalr	-1804(ra) # 800000d2 <memmove>
    return 0;
    800017e6:	8526                	mv	a0,s1
    800017e8:	bff9                	j	800017c6 <either_copyout+0x32>

00000000800017ea <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len) {
    800017ea:	7179                	addi	sp,sp,-48
    800017ec:	f406                	sd	ra,40(sp)
    800017ee:	f022                	sd	s0,32(sp)
    800017f0:	ec26                	sd	s1,24(sp)
    800017f2:	e84a                	sd	s2,16(sp)
    800017f4:	e44e                	sd	s3,8(sp)
    800017f6:	e052                	sd	s4,0(sp)
    800017f8:	1800                	addi	s0,sp,48
    800017fa:	892a                	mv	s2,a0
    800017fc:	84ae                	mv	s1,a1
    800017fe:	89b2                	mv	s3,a2
    80001800:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001802:	fffff097          	auipc	ra,0xfffff
    80001806:	468080e7          	jalr	1128(ra) # 80000c6a <myproc>
  if (user_src) {
    8000180a:	c08d                	beqz	s1,8000182c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000180c:	86d2                	mv	a3,s4
    8000180e:	864e                	mv	a2,s3
    80001810:	85ca                	mv	a1,s2
    80001812:	6928                	ld	a0,80(a0)
    80001814:	fffff097          	auipc	ra,0xfffff
    80001818:	288080e7          	jalr	648(ra) # 80000a9c <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    8000181c:	70a2                	ld	ra,40(sp)
    8000181e:	7402                	ld	s0,32(sp)
    80001820:	64e2                	ld	s1,24(sp)
    80001822:	6942                	ld	s2,16(sp)
    80001824:	69a2                	ld	s3,8(sp)
    80001826:	6a02                	ld	s4,0(sp)
    80001828:	6145                	addi	sp,sp,48
    8000182a:	8082                	ret
    memmove(dst, (char *)src, len);
    8000182c:	000a061b          	sext.w	a2,s4
    80001830:	85ce                	mv	a1,s3
    80001832:	854a                	mv	a0,s2
    80001834:	fffff097          	auipc	ra,0xfffff
    80001838:	89e080e7          	jalr	-1890(ra) # 800000d2 <memmove>
    return 0;
    8000183c:	8526                	mv	a0,s1
    8000183e:	bff9                	j	8000181c <either_copyin+0x32>

0000000080001840 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
    80001840:	715d                	addi	sp,sp,-80
    80001842:	e486                	sd	ra,72(sp)
    80001844:	e0a2                	sd	s0,64(sp)
    80001846:	fc26                	sd	s1,56(sp)
    80001848:	f84a                	sd	s2,48(sp)
    8000184a:	f44e                	sd	s3,40(sp)
    8000184c:	f052                	sd	s4,32(sp)
    8000184e:	ec56                	sd	s5,24(sp)
    80001850:	e85a                	sd	s6,16(sp)
    80001852:	e45e                	sd	s7,8(sp)
    80001854:	0880                	addi	s0,sp,80
  static char *states[] = {
      [UNUSED] "unused",   [USED] "used",      [SLEEPING] "sleep ",
      [RUNNABLE] "runble", [RUNNING] "run   ", [ZOMBIE] "zombie"};
  char *state;

  printf("\n");
    80001856:	00006517          	auipc	a0,0x6
    8000185a:	7d250513          	addi	a0,a0,2002 # 80008028 <etext+0x28>
    8000185e:	00005097          	auipc	ra,0x5
    80001862:	e70080e7          	jalr	-400(ra) # 800066ce <printf>
  //  acquire(&proc_list_lock);
  for (struct list *el = proc_list.next; el != &proc_list; el = el->next) {
    80001866:	00007497          	auipc	s1,0x7
    8000186a:	1ea4b483          	ld	s1,490(s1) # 80008a50 <proc_list>
    8000186e:	00007797          	auipc	a5,0x7
    80001872:	1e278793          	addi	a5,a5,482 # 80008a50 <proc_list>
    80001876:	06f48563          	beq	s1,a5,800018e0 <procdump+0xa0>
    struct proc *p = (struct proc *)((char*)el - offsetof(struct proc, list));
    if (p->state == UNUSED) continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000187a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000187c:	00007997          	auipc	s3,0x7
    80001880:	95498993          	addi	s3,s3,-1708 # 800081d0 <etext+0x1d0>
    printf("%d %s %s", p->pid, state, p->name);
    80001884:	00007a97          	auipc	s5,0x7
    80001888:	954a8a93          	addi	s5,s5,-1708 # 800081d8 <etext+0x1d8>
    printf("\n");
    8000188c:	00006a17          	auipc	s4,0x6
    80001890:	79ca0a13          	addi	s4,s4,1948 # 80008028 <etext+0x28>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001894:	00007b97          	auipc	s7,0x7
    80001898:	984b8b93          	addi	s7,s7,-1660 # 80008218 <states.0>
  for (struct list *el = proc_list.next; el != &proc_list; el = el->next) {
    8000189c:	893e                	mv	s2,a5
    8000189e:	a015                	j	800018c2 <procdump+0x82>
    printf("%d %s %s", p->pid, state, p->name);
    800018a0:	ff048693          	addi	a3,s1,-16
    800018a4:	ec84a583          	lw	a1,-312(s1)
    800018a8:	8556                	mv	a0,s5
    800018aa:	00005097          	auipc	ra,0x5
    800018ae:	e24080e7          	jalr	-476(ra) # 800066ce <printf>
    printf("\n");
    800018b2:	8552                	mv	a0,s4
    800018b4:	00005097          	auipc	ra,0x5
    800018b8:	e1a080e7          	jalr	-486(ra) # 800066ce <printf>
  for (struct list *el = proc_list.next; el != &proc_list; el = el->next) {
    800018bc:	6084                	ld	s1,0(s1)
    800018be:	03248163          	beq	s1,s2,800018e0 <procdump+0xa0>
    if (p->state == UNUSED) continue;
    800018c2:	eb04a783          	lw	a5,-336(s1)
    800018c6:	dbfd                	beqz	a5,800018bc <procdump+0x7c>
      state = "???";
    800018c8:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800018ca:	fcfb6be3          	bltu	s6,a5,800018a0 <procdump+0x60>
    800018ce:	02079713          	slli	a4,a5,0x20
    800018d2:	01d75793          	srli	a5,a4,0x1d
    800018d6:	97de                	add	a5,a5,s7
    800018d8:	6390                	ld	a2,0(a5)
    800018da:	f279                	bnez	a2,800018a0 <procdump+0x60>
      state = "???";
    800018dc:	864e                	mv	a2,s3
    800018de:	b7c9                	j	800018a0 <procdump+0x60>
  }
  //  release(&proc_list_lock);
    800018e0:	60a6                	ld	ra,72(sp)
    800018e2:	6406                	ld	s0,64(sp)
    800018e4:	74e2                	ld	s1,56(sp)
    800018e6:	7942                	ld	s2,48(sp)
    800018e8:	79a2                	ld	s3,40(sp)
    800018ea:	7a02                	ld	s4,32(sp)
    800018ec:	6ae2                	ld	s5,24(sp)
    800018ee:	6b42                	ld	s6,16(sp)
    800018f0:	6ba2                	ld	s7,8(sp)
    800018f2:	6161                	addi	sp,sp,80
    800018f4:	8082                	ret

00000000800018f6 <swtch>:
    800018f6:	00153023          	sd	ra,0(a0)
    800018fa:	00253423          	sd	sp,8(a0)
    800018fe:	e900                	sd	s0,16(a0)
    80001900:	ed04                	sd	s1,24(a0)
    80001902:	03253023          	sd	s2,32(a0)
    80001906:	03353423          	sd	s3,40(a0)
    8000190a:	03453823          	sd	s4,48(a0)
    8000190e:	03553c23          	sd	s5,56(a0)
    80001912:	05653023          	sd	s6,64(a0)
    80001916:	05753423          	sd	s7,72(a0)
    8000191a:	05853823          	sd	s8,80(a0)
    8000191e:	05953c23          	sd	s9,88(a0)
    80001922:	07a53023          	sd	s10,96(a0)
    80001926:	07b53423          	sd	s11,104(a0)
    8000192a:	0005b083          	ld	ra,0(a1)
    8000192e:	0085b103          	ld	sp,8(a1)
    80001932:	6980                	ld	s0,16(a1)
    80001934:	6d84                	ld	s1,24(a1)
    80001936:	0205b903          	ld	s2,32(a1)
    8000193a:	0285b983          	ld	s3,40(a1)
    8000193e:	0305ba03          	ld	s4,48(a1)
    80001942:	0385ba83          	ld	s5,56(a1)
    80001946:	0405bb03          	ld	s6,64(a1)
    8000194a:	0485bb83          	ld	s7,72(a1)
    8000194e:	0505bc03          	ld	s8,80(a1)
    80001952:	0585bc83          	ld	s9,88(a1)
    80001956:	0605bd03          	ld	s10,96(a1)
    8000195a:	0685bd83          	ld	s11,104(a1)
    8000195e:	8082                	ret

0000000080001960 <trapinit>:
// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void trapinit(void) { initlock(&tickslock, "time"); }
    80001960:	1141                	addi	sp,sp,-16
    80001962:	e406                	sd	ra,8(sp)
    80001964:	e022                	sd	s0,0(sp)
    80001966:	0800                	addi	s0,sp,16
    80001968:	00007597          	auipc	a1,0x7
    8000196c:	8e058593          	addi	a1,a1,-1824 # 80008248 <states.0+0x30>
    80001970:	00007517          	auipc	a0,0x7
    80001974:	50850513          	addi	a0,a0,1288 # 80008e78 <tickslock>
    80001978:	00005097          	auipc	ra,0x5
    8000197c:	1b4080e7          	jalr	436(ra) # 80006b2c <initlock>
    80001980:	60a2                	ld	ra,8(sp)
    80001982:	6402                	ld	s0,0(sp)
    80001984:	0141                	addi	sp,sp,16
    80001986:	8082                	ret

0000000080001988 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) { w_stvec((uint64)kernelvec); }
    80001988:	1141                	addi	sp,sp,-16
    8000198a:	e422                	sd	s0,8(sp)
    8000198c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    8000198e:	00003797          	auipc	a5,0x3
    80001992:	44278793          	addi	a5,a5,1090 # 80004dd0 <kernelvec>
    80001996:	10579073          	csrw	stvec,a5
    8000199a:	6422                	ld	s0,8(sp)
    8000199c:	0141                	addi	sp,sp,16
    8000199e:	8082                	ret

00000000800019a0 <usertrapret>:
}

//
// return to user space
//
void usertrapret(void) {
    800019a0:	1141                	addi	sp,sp,-16
    800019a2:	e406                	sd	ra,8(sp)
    800019a4:	e022                	sd	s0,0(sp)
    800019a6:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800019a8:	fffff097          	auipc	ra,0xfffff
    800019ac:	2c2080e7          	jalr	706(ra) # 80000c6a <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800019b0:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    800019b4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800019b6:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800019ba:	00005697          	auipc	a3,0x5
    800019be:	64668693          	addi	a3,a3,1606 # 80007000 <_trampoline>
    800019c2:	00005717          	auipc	a4,0x5
    800019c6:	63e70713          	addi	a4,a4,1598 # 80007000 <_trampoline>
    800019ca:	8f15                	sub	a4,a4,a3
    800019cc:	040007b7          	lui	a5,0x4000
    800019d0:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800019d2:	07b2                	slli	a5,a5,0xc
    800019d4:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r"(x));
    800019d6:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();          // kernel page table
    800019da:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    800019dc:	18002673          	csrr	a2,satp
    800019e0:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE;  // process's kernel stack
    800019e2:	6d30                	ld	a2,88(a0)
    800019e4:	6138                	ld	a4,64(a0)
    800019e6:	6585                	lui	a1,0x1
    800019e8:	972e                	add	a4,a4,a1
    800019ea:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800019ec:	6d38                	ld	a4,88(a0)
    800019ee:	00000617          	auipc	a2,0x0
    800019f2:	13060613          	addi	a2,a2,304 # 80001b1e <usertrap>
    800019f6:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();  // hartid for cpuid()
    800019f8:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    800019fa:	8612                	mv	a2,tp
    800019fc:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800019fe:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP;  // clear SPP to 0 for user mode
    80001a02:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE;  // enable interrupts in user mode
    80001a06:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001a0a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001a0e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001a10:	6f18                	ld	a4,24(a4)
    80001a12:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001a16:	6928                	ld	a0,80(a0)
    80001a18:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001a1a:	00005717          	auipc	a4,0x5
    80001a1e:	68270713          	addi	a4,a4,1666 # 8000709c <userret>
    80001a22:	8f15                	sub	a4,a4,a3
    80001a24:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001a26:	577d                	li	a4,-1
    80001a28:	177e                	slli	a4,a4,0x3f
    80001a2a:	8d59                	or	a0,a0,a4
    80001a2c:	9782                	jalr	a5
}
    80001a2e:	60a2                	ld	ra,8(sp)
    80001a30:	6402                	ld	s0,0(sp)
    80001a32:	0141                	addi	sp,sp,16
    80001a34:	8082                	ret

0000000080001a36 <clockintr>:
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr() {
    80001a36:	1101                	addi	sp,sp,-32
    80001a38:	ec06                	sd	ra,24(sp)
    80001a3a:	e822                	sd	s0,16(sp)
    80001a3c:	e426                	sd	s1,8(sp)
    80001a3e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001a40:	00007497          	auipc	s1,0x7
    80001a44:	43848493          	addi	s1,s1,1080 # 80008e78 <tickslock>
    80001a48:	8526                	mv	a0,s1
    80001a4a:	00005097          	auipc	ra,0x5
    80001a4e:	172080e7          	jalr	370(ra) # 80006bbc <acquire>
  ticks++;
    80001a52:	00007517          	auipc	a0,0x7
    80001a56:	f9650513          	addi	a0,a0,-106 # 800089e8 <ticks>
    80001a5a:	411c                	lw	a5,0(a0)
    80001a5c:	2785                	addiw	a5,a5,1
    80001a5e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001a60:	00000097          	auipc	ra,0x0
    80001a64:	94e080e7          	jalr	-1714(ra) # 800013ae <wakeup>
  release(&tickslock);
    80001a68:	8526                	mv	a0,s1
    80001a6a:	00005097          	auipc	ra,0x5
    80001a6e:	200080e7          	jalr	512(ra) # 80006c6a <release>
}
    80001a72:	60e2                	ld	ra,24(sp)
    80001a74:	6442                	ld	s0,16(sp)
    80001a76:	64a2                	ld	s1,8(sp)
    80001a78:	6105                	addi	sp,sp,32
    80001a7a:	8082                	ret

0000000080001a7c <devintr>:
// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr() {
    80001a7c:	1101                	addi	sp,sp,-32
    80001a7e:	ec06                	sd	ra,24(sp)
    80001a80:	e822                	sd	s0,16(sp)
    80001a82:	e426                	sd	s1,8(sp)
    80001a84:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80001a86:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001a8a:	00074d63          	bltz	a4,80001aa4 <devintr+0x28>
    // interrupt at a time; tell the PLIC the device is
    // now allowed to interrupt again.
    if (irq) plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000001L) {
    80001a8e:	57fd                	li	a5,-1
    80001a90:	17fe                	slli	a5,a5,0x3f
    80001a92:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001a94:	4501                	li	a0,0
  } else if (scause == 0x8000000000000001L) {
    80001a96:	06f70363          	beq	a4,a5,80001afc <devintr+0x80>
  }
}
    80001a9a:	60e2                	ld	ra,24(sp)
    80001a9c:	6442                	ld	s0,16(sp)
    80001a9e:	64a2                	ld	s1,8(sp)
    80001aa0:	6105                	addi	sp,sp,32
    80001aa2:	8082                	ret
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    80001aa4:	0ff77793          	zext.b	a5,a4
    80001aa8:	46a5                	li	a3,9
    80001aaa:	fed792e3          	bne	a5,a3,80001a8e <devintr+0x12>
    int irq = plic_claim();
    80001aae:	00003097          	auipc	ra,0x3
    80001ab2:	42a080e7          	jalr	1066(ra) # 80004ed8 <plic_claim>
    80001ab6:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80001ab8:	47a9                	li	a5,10
    80001aba:	02f50763          	beq	a0,a5,80001ae8 <devintr+0x6c>
    } else if (irq == VIRTIO0_IRQ) {
    80001abe:	4785                	li	a5,1
    80001ac0:	02f50963          	beq	a0,a5,80001af2 <devintr+0x76>
    return 1;
    80001ac4:	4505                	li	a0,1
    } else if (irq) {
    80001ac6:	d8f1                	beqz	s1,80001a9a <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001ac8:	85a6                	mv	a1,s1
    80001aca:	00006517          	auipc	a0,0x6
    80001ace:	78650513          	addi	a0,a0,1926 # 80008250 <states.0+0x38>
    80001ad2:	00005097          	auipc	ra,0x5
    80001ad6:	bfc080e7          	jalr	-1028(ra) # 800066ce <printf>
    if (irq) plic_complete(irq);
    80001ada:	8526                	mv	a0,s1
    80001adc:	00003097          	auipc	ra,0x3
    80001ae0:	420080e7          	jalr	1056(ra) # 80004efc <plic_complete>
    return 1;
    80001ae4:	4505                	li	a0,1
    80001ae6:	bf55                	j	80001a9a <devintr+0x1e>
      uartintr();
    80001ae8:	00005097          	auipc	ra,0x5
    80001aec:	ff4080e7          	jalr	-12(ra) # 80006adc <uartintr>
    80001af0:	b7ed                	j	80001ada <devintr+0x5e>
      virtio_disk_intr();
    80001af2:	00004097          	auipc	ra,0x4
    80001af6:	8d2080e7          	jalr	-1838(ra) # 800053c4 <virtio_disk_intr>
    80001afa:	b7c5                	j	80001ada <devintr+0x5e>
    if (cpuid() == 0) {
    80001afc:	fffff097          	auipc	ra,0xfffff
    80001b00:	142080e7          	jalr	322(ra) # 80000c3e <cpuid>
    80001b04:	c901                	beqz	a0,80001b14 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r"(x));
    80001b06:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001b0a:	9bf5                	andi	a5,a5,-3
static inline void w_sip(uint64 x) { asm volatile("csrw sip, %0" : : "r"(x)); }
    80001b0c:	14479073          	csrw	sip,a5
    return 2;
    80001b10:	4509                	li	a0,2
    80001b12:	b761                	j	80001a9a <devintr+0x1e>
      clockintr();
    80001b14:	00000097          	auipc	ra,0x0
    80001b18:	f22080e7          	jalr	-222(ra) # 80001a36 <clockintr>
    80001b1c:	b7ed                	j	80001b06 <devintr+0x8a>

0000000080001b1e <usertrap>:
void usertrap(void) {
    80001b1e:	1101                	addi	sp,sp,-32
    80001b20:	ec06                	sd	ra,24(sp)
    80001b22:	e822                	sd	s0,16(sp)
    80001b24:	e426                	sd	s1,8(sp)
    80001b26:	e04a                	sd	s2,0(sp)
    80001b28:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001b2a:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80001b2e:	1007f793          	andi	a5,a5,256
    80001b32:	e3b1                	bnez	a5,80001b76 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80001b34:	00003797          	auipc	a5,0x3
    80001b38:	29c78793          	addi	a5,a5,668 # 80004dd0 <kernelvec>
    80001b3c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001b40:	fffff097          	auipc	ra,0xfffff
    80001b44:	12a080e7          	jalr	298(ra) # 80000c6a <myproc>
    80001b48:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001b4a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001b4c:	14102773          	csrr	a4,sepc
    80001b50:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80001b52:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80001b56:	47a1                	li	a5,8
    80001b58:	02f70763          	beq	a4,a5,80001b86 <usertrap+0x68>
  } else if ((which_dev = devintr()) != 0) {
    80001b5c:	00000097          	auipc	ra,0x0
    80001b60:	f20080e7          	jalr	-224(ra) # 80001a7c <devintr>
    80001b64:	892a                	mv	s2,a0
    80001b66:	c151                	beqz	a0,80001bea <usertrap+0xcc>
  if (killed(p)) exit(-1);
    80001b68:	8526                	mv	a0,s1
    80001b6a:	00000097          	auipc	ra,0x0
    80001b6e:	aba080e7          	jalr	-1350(ra) # 80001624 <killed>
    80001b72:	c929                	beqz	a0,80001bc4 <usertrap+0xa6>
    80001b74:	a099                	j	80001bba <usertrap+0x9c>
  if ((r_sstatus() & SSTATUS_SPP) != 0) panic("usertrap: not from user mode");
    80001b76:	00006517          	auipc	a0,0x6
    80001b7a:	6fa50513          	addi	a0,a0,1786 # 80008270 <states.0+0x58>
    80001b7e:	00005097          	auipc	ra,0x5
    80001b82:	b06080e7          	jalr	-1274(ra) # 80006684 <panic>
    if (killed(p)) exit(-1);
    80001b86:	00000097          	auipc	ra,0x0
    80001b8a:	a9e080e7          	jalr	-1378(ra) # 80001624 <killed>
    80001b8e:	e921                	bnez	a0,80001bde <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001b90:	6cb8                	ld	a4,88(s1)
    80001b92:	6f1c                	ld	a5,24(a4)
    80001b94:	0791                	addi	a5,a5,4
    80001b96:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001b98:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80001b9c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001ba0:	10079073          	csrw	sstatus,a5
    syscall();
    80001ba4:	00000097          	auipc	ra,0x0
    80001ba8:	2d4080e7          	jalr	724(ra) # 80001e78 <syscall>
  if (killed(p)) exit(-1);
    80001bac:	8526                	mv	a0,s1
    80001bae:	00000097          	auipc	ra,0x0
    80001bb2:	a76080e7          	jalr	-1418(ra) # 80001624 <killed>
    80001bb6:	c911                	beqz	a0,80001bca <usertrap+0xac>
    80001bb8:	4901                	li	s2,0
    80001bba:	557d                	li	a0,-1
    80001bbc:	00000097          	auipc	ra,0x0
    80001bc0:	8dc080e7          	jalr	-1828(ra) # 80001498 <exit>
  if (which_dev == 2) yield();
    80001bc4:	4789                	li	a5,2
    80001bc6:	04f90f63          	beq	s2,a5,80001c24 <usertrap+0x106>
  usertrapret();
    80001bca:	00000097          	auipc	ra,0x0
    80001bce:	dd6080e7          	jalr	-554(ra) # 800019a0 <usertrapret>
}
    80001bd2:	60e2                	ld	ra,24(sp)
    80001bd4:	6442                	ld	s0,16(sp)
    80001bd6:	64a2                	ld	s1,8(sp)
    80001bd8:	6902                	ld	s2,0(sp)
    80001bda:	6105                	addi	sp,sp,32
    80001bdc:	8082                	ret
    if (killed(p)) exit(-1);
    80001bde:	557d                	li	a0,-1
    80001be0:	00000097          	auipc	ra,0x0
    80001be4:	8b8080e7          	jalr	-1864(ra) # 80001498 <exit>
    80001be8:	b765                	j	80001b90 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r"(x));
    80001bea:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001bee:	5890                	lw	a2,48(s1)
    80001bf0:	00006517          	auipc	a0,0x6
    80001bf4:	6a050513          	addi	a0,a0,1696 # 80008290 <states.0+0x78>
    80001bf8:	00005097          	auipc	ra,0x5
    80001bfc:	ad6080e7          	jalr	-1322(ra) # 800066ce <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001c00:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80001c04:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001c08:	00006517          	auipc	a0,0x6
    80001c0c:	6b850513          	addi	a0,a0,1720 # 800082c0 <states.0+0xa8>
    80001c10:	00005097          	auipc	ra,0x5
    80001c14:	abe080e7          	jalr	-1346(ra) # 800066ce <printf>
    setkilled(p);
    80001c18:	8526                	mv	a0,s1
    80001c1a:	00000097          	auipc	ra,0x0
    80001c1e:	9de080e7          	jalr	-1570(ra) # 800015f8 <setkilled>
    80001c22:	b769                	j	80001bac <usertrap+0x8e>
  if (which_dev == 2) yield();
    80001c24:	fffff097          	auipc	ra,0xfffff
    80001c28:	6ea080e7          	jalr	1770(ra) # 8000130e <yield>
    80001c2c:	bf79                	j	80001bca <usertrap+0xac>

0000000080001c2e <kerneltrap>:
void kerneltrap() {
    80001c2e:	7179                	addi	sp,sp,-48
    80001c30:	f406                	sd	ra,40(sp)
    80001c32:	f022                	sd	s0,32(sp)
    80001c34:	ec26                	sd	s1,24(sp)
    80001c36:	e84a                	sd	s2,16(sp)
    80001c38:	e44e                	sd	s3,8(sp)
    80001c3a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001c3c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001c40:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    80001c44:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80001c48:	1004f793          	andi	a5,s1,256
    80001c4c:	cb85                	beqz	a5,80001c7c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001c4e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001c52:	8b89                	andi	a5,a5,2
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    80001c54:	ef85                	bnez	a5,80001c8c <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0) {
    80001c56:	00000097          	auipc	ra,0x0
    80001c5a:	e26080e7          	jalr	-474(ra) # 80001a7c <devintr>
    80001c5e:	cd1d                	beqz	a0,80001c9c <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
    80001c60:	4789                	li	a5,2
    80001c62:	06f50a63          	beq	a0,a5,80001cd6 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80001c66:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001c6a:	10049073          	csrw	sstatus,s1
}
    80001c6e:	70a2                	ld	ra,40(sp)
    80001c70:	7402                	ld	s0,32(sp)
    80001c72:	64e2                	ld	s1,24(sp)
    80001c74:	6942                	ld	s2,16(sp)
    80001c76:	69a2                	ld	s3,8(sp)
    80001c78:	6145                	addi	sp,sp,48
    80001c7a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001c7c:	00006517          	auipc	a0,0x6
    80001c80:	66450513          	addi	a0,a0,1636 # 800082e0 <states.0+0xc8>
    80001c84:	00005097          	auipc	ra,0x5
    80001c88:	a00080e7          	jalr	-1536(ra) # 80006684 <panic>
  if (intr_get() != 0) panic("kerneltrap: interrupts enabled");
    80001c8c:	00006517          	auipc	a0,0x6
    80001c90:	67c50513          	addi	a0,a0,1660 # 80008308 <states.0+0xf0>
    80001c94:	00005097          	auipc	ra,0x5
    80001c98:	9f0080e7          	jalr	-1552(ra) # 80006684 <panic>
    printf("scause %p\n", scause);
    80001c9c:	85ce                	mv	a1,s3
    80001c9e:	00006517          	auipc	a0,0x6
    80001ca2:	68a50513          	addi	a0,a0,1674 # 80008328 <states.0+0x110>
    80001ca6:	00005097          	auipc	ra,0x5
    80001caa:	a28080e7          	jalr	-1496(ra) # 800066ce <printf>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80001cae:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80001cb2:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001cb6:	00006517          	auipc	a0,0x6
    80001cba:	68250513          	addi	a0,a0,1666 # 80008338 <states.0+0x120>
    80001cbe:	00005097          	auipc	ra,0x5
    80001cc2:	a10080e7          	jalr	-1520(ra) # 800066ce <printf>
    panic("kerneltrap");
    80001cc6:	00006517          	auipc	a0,0x6
    80001cca:	68a50513          	addi	a0,a0,1674 # 80008350 <states.0+0x138>
    80001cce:	00005097          	auipc	ra,0x5
    80001cd2:	9b6080e7          	jalr	-1610(ra) # 80006684 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING) yield();
    80001cd6:	fffff097          	auipc	ra,0xfffff
    80001cda:	f94080e7          	jalr	-108(ra) # 80000c6a <myproc>
    80001cde:	d541                	beqz	a0,80001c66 <kerneltrap+0x38>
    80001ce0:	fffff097          	auipc	ra,0xfffff
    80001ce4:	f8a080e7          	jalr	-118(ra) # 80000c6a <myproc>
    80001ce8:	4d18                	lw	a4,24(a0)
    80001cea:	4791                	li	a5,4
    80001cec:	f6f71de3          	bne	a4,a5,80001c66 <kerneltrap+0x38>
    80001cf0:	fffff097          	auipc	ra,0xfffff
    80001cf4:	61e080e7          	jalr	1566(ra) # 8000130e <yield>
    80001cf8:	b7bd                	j	80001c66 <kerneltrap+0x38>

0000000080001cfa <argraw>:
  struct proc *p = myproc();
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
  return strlen(buf);
}

static uint64 argraw(int n) {
    80001cfa:	1101                	addi	sp,sp,-32
    80001cfc:	ec06                	sd	ra,24(sp)
    80001cfe:	e822                	sd	s0,16(sp)
    80001d00:	e426                	sd	s1,8(sp)
    80001d02:	1000                	addi	s0,sp,32
    80001d04:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d06:	fffff097          	auipc	ra,0xfffff
    80001d0a:	f64080e7          	jalr	-156(ra) # 80000c6a <myproc>
  switch (n) {
    80001d0e:	4795                	li	a5,5
    80001d10:	0497e163          	bltu	a5,s1,80001d52 <argraw+0x58>
    80001d14:	048a                	slli	s1,s1,0x2
    80001d16:	00006717          	auipc	a4,0x6
    80001d1a:	67270713          	addi	a4,a4,1650 # 80008388 <states.0+0x170>
    80001d1e:	94ba                	add	s1,s1,a4
    80001d20:	409c                	lw	a5,0(s1)
    80001d22:	97ba                	add	a5,a5,a4
    80001d24:	8782                	jr	a5
    case 0:
      return p->trapframe->a0;
    80001d26:	6d3c                	ld	a5,88(a0)
    80001d28:	7ba8                	ld	a0,112(a5)
    case 5:
      return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001d2a:	60e2                	ld	ra,24(sp)
    80001d2c:	6442                	ld	s0,16(sp)
    80001d2e:	64a2                	ld	s1,8(sp)
    80001d30:	6105                	addi	sp,sp,32
    80001d32:	8082                	ret
      return p->trapframe->a1;
    80001d34:	6d3c                	ld	a5,88(a0)
    80001d36:	7fa8                	ld	a0,120(a5)
    80001d38:	bfcd                	j	80001d2a <argraw+0x30>
      return p->trapframe->a2;
    80001d3a:	6d3c                	ld	a5,88(a0)
    80001d3c:	63c8                	ld	a0,128(a5)
    80001d3e:	b7f5                	j	80001d2a <argraw+0x30>
      return p->trapframe->a3;
    80001d40:	6d3c                	ld	a5,88(a0)
    80001d42:	67c8                	ld	a0,136(a5)
    80001d44:	b7dd                	j	80001d2a <argraw+0x30>
      return p->trapframe->a4;
    80001d46:	6d3c                	ld	a5,88(a0)
    80001d48:	6bc8                	ld	a0,144(a5)
    80001d4a:	b7c5                	j	80001d2a <argraw+0x30>
      return p->trapframe->a5;
    80001d4c:	6d3c                	ld	a5,88(a0)
    80001d4e:	6fc8                	ld	a0,152(a5)
    80001d50:	bfe9                	j	80001d2a <argraw+0x30>
  panic("argraw");
    80001d52:	00006517          	auipc	a0,0x6
    80001d56:	60e50513          	addi	a0,a0,1550 # 80008360 <states.0+0x148>
    80001d5a:	00005097          	auipc	ra,0x5
    80001d5e:	92a080e7          	jalr	-1750(ra) # 80006684 <panic>

0000000080001d62 <fetchaddr>:
int fetchaddr(uint64 addr, uint64 *ip) {
    80001d62:	1101                	addi	sp,sp,-32
    80001d64:	ec06                	sd	ra,24(sp)
    80001d66:	e822                	sd	s0,16(sp)
    80001d68:	e426                	sd	s1,8(sp)
    80001d6a:	e04a                	sd	s2,0(sp)
    80001d6c:	1000                	addi	s0,sp,32
    80001d6e:	84aa                	mv	s1,a0
    80001d70:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001d72:	fffff097          	auipc	ra,0xfffff
    80001d76:	ef8080e7          	jalr	-264(ra) # 80000c6a <myproc>
  if (addr >= p->sz ||
    80001d7a:	653c                	ld	a5,72(a0)
    80001d7c:	02f4f863          	bgeu	s1,a5,80001dac <fetchaddr+0x4a>
      addr + sizeof(uint64) > p->sz)  // both tests needed, in case of overflow
    80001d80:	00848713          	addi	a4,s1,8
  if (addr >= p->sz ||
    80001d84:	02e7e663          	bltu	a5,a4,80001db0 <fetchaddr+0x4e>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0) return -1;
    80001d88:	46a1                	li	a3,8
    80001d8a:	8626                	mv	a2,s1
    80001d8c:	85ca                	mv	a1,s2
    80001d8e:	6928                	ld	a0,80(a0)
    80001d90:	fffff097          	auipc	ra,0xfffff
    80001d94:	d0c080e7          	jalr	-756(ra) # 80000a9c <copyin>
    80001d98:	00a03533          	snez	a0,a0
    80001d9c:	40a00533          	neg	a0,a0
}
    80001da0:	60e2                	ld	ra,24(sp)
    80001da2:	6442                	ld	s0,16(sp)
    80001da4:	64a2                	ld	s1,8(sp)
    80001da6:	6902                	ld	s2,0(sp)
    80001da8:	6105                	addi	sp,sp,32
    80001daa:	8082                	ret
    return -1;
    80001dac:	557d                	li	a0,-1
    80001dae:	bfcd                	j	80001da0 <fetchaddr+0x3e>
    80001db0:	557d                	li	a0,-1
    80001db2:	b7fd                	j	80001da0 <fetchaddr+0x3e>

0000000080001db4 <fetchstr>:
int fetchstr(uint64 addr, char *buf, int max) {
    80001db4:	7179                	addi	sp,sp,-48
    80001db6:	f406                	sd	ra,40(sp)
    80001db8:	f022                	sd	s0,32(sp)
    80001dba:	ec26                	sd	s1,24(sp)
    80001dbc:	e84a                	sd	s2,16(sp)
    80001dbe:	e44e                	sd	s3,8(sp)
    80001dc0:	1800                	addi	s0,sp,48
    80001dc2:	892a                	mv	s2,a0
    80001dc4:	84ae                	mv	s1,a1
    80001dc6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001dc8:	fffff097          	auipc	ra,0xfffff
    80001dcc:	ea2080e7          	jalr	-350(ra) # 80000c6a <myproc>
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    80001dd0:	86ce                	mv	a3,s3
    80001dd2:	864a                	mv	a2,s2
    80001dd4:	85a6                	mv	a1,s1
    80001dd6:	6928                	ld	a0,80(a0)
    80001dd8:	fffff097          	auipc	ra,0xfffff
    80001ddc:	d52080e7          	jalr	-686(ra) # 80000b2a <copyinstr>
    80001de0:	00054e63          	bltz	a0,80001dfc <fetchstr+0x48>
  return strlen(buf);
    80001de4:	8526                	mv	a0,s1
    80001de6:	ffffe097          	auipc	ra,0xffffe
    80001dea:	40c080e7          	jalr	1036(ra) # 800001f2 <strlen>
}
    80001dee:	70a2                	ld	ra,40(sp)
    80001df0:	7402                	ld	s0,32(sp)
    80001df2:	64e2                	ld	s1,24(sp)
    80001df4:	6942                	ld	s2,16(sp)
    80001df6:	69a2                	ld	s3,8(sp)
    80001df8:	6145                	addi	sp,sp,48
    80001dfa:	8082                	ret
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    80001dfc:	557d                	li	a0,-1
    80001dfe:	bfc5                	j	80001dee <fetchstr+0x3a>

0000000080001e00 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip) { *ip = argraw(n); }
    80001e00:	1101                	addi	sp,sp,-32
    80001e02:	ec06                	sd	ra,24(sp)
    80001e04:	e822                	sd	s0,16(sp)
    80001e06:	e426                	sd	s1,8(sp)
    80001e08:	1000                	addi	s0,sp,32
    80001e0a:	84ae                	mv	s1,a1
    80001e0c:	00000097          	auipc	ra,0x0
    80001e10:	eee080e7          	jalr	-274(ra) # 80001cfa <argraw>
    80001e14:	c088                	sw	a0,0(s1)
    80001e16:	60e2                	ld	ra,24(sp)
    80001e18:	6442                	ld	s0,16(sp)
    80001e1a:	64a2                	ld	s1,8(sp)
    80001e1c:	6105                	addi	sp,sp,32
    80001e1e:	8082                	ret

0000000080001e20 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip) { *ip = argraw(n); }
    80001e20:	1101                	addi	sp,sp,-32
    80001e22:	ec06                	sd	ra,24(sp)
    80001e24:	e822                	sd	s0,16(sp)
    80001e26:	e426                	sd	s1,8(sp)
    80001e28:	1000                	addi	s0,sp,32
    80001e2a:	84ae                	mv	s1,a1
    80001e2c:	00000097          	auipc	ra,0x0
    80001e30:	ece080e7          	jalr	-306(ra) # 80001cfa <argraw>
    80001e34:	e088                	sd	a0,0(s1)
    80001e36:	60e2                	ld	ra,24(sp)
    80001e38:	6442                	ld	s0,16(sp)
    80001e3a:	64a2                	ld	s1,8(sp)
    80001e3c:	6105                	addi	sp,sp,32
    80001e3e:	8082                	ret

0000000080001e40 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max) {
    80001e40:	7179                	addi	sp,sp,-48
    80001e42:	f406                	sd	ra,40(sp)
    80001e44:	f022                	sd	s0,32(sp)
    80001e46:	ec26                	sd	s1,24(sp)
    80001e48:	e84a                	sd	s2,16(sp)
    80001e4a:	1800                	addi	s0,sp,48
    80001e4c:	84ae                	mv	s1,a1
    80001e4e:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001e50:	fd840593          	addi	a1,s0,-40
    80001e54:	00000097          	auipc	ra,0x0
    80001e58:	fcc080e7          	jalr	-52(ra) # 80001e20 <argaddr>
  return fetchstr(addr, buf, max);
    80001e5c:	864a                	mv	a2,s2
    80001e5e:	85a6                	mv	a1,s1
    80001e60:	fd843503          	ld	a0,-40(s0)
    80001e64:	00000097          	auipc	ra,0x0
    80001e68:	f50080e7          	jalr	-176(ra) # 80001db4 <fetchstr>
}
    80001e6c:	70a2                	ld	ra,40(sp)
    80001e6e:	7402                	ld	s0,32(sp)
    80001e70:	64e2                	ld	s1,24(sp)
    80001e72:	6942                	ld	s2,16(sp)
    80001e74:	6145                	addi	sp,sp,48
    80001e76:	8082                	ret

0000000080001e78 <syscall>:
    [SYS_sleep] sys_sleep, [SYS_uptime] sys_uptime, [SYS_open] sys_open,
    [SYS_write] sys_write, [SYS_mknod] sys_mknod,   [SYS_unlink] sys_unlink,
    [SYS_link] sys_link,   [SYS_mkdir] sys_mkdir,   [SYS_close] sys_close,
};

void syscall(void) {
    80001e78:	1101                	addi	sp,sp,-32
    80001e7a:	ec06                	sd	ra,24(sp)
    80001e7c:	e822                	sd	s0,16(sp)
    80001e7e:	e426                	sd	s1,8(sp)
    80001e80:	e04a                	sd	s2,0(sp)
    80001e82:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001e84:	fffff097          	auipc	ra,0xfffff
    80001e88:	de6080e7          	jalr	-538(ra) # 80000c6a <myproc>
    80001e8c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001e8e:	05853903          	ld	s2,88(a0)
    80001e92:	0a893783          	ld	a5,168(s2)
    80001e96:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001e9a:	37fd                	addiw	a5,a5,-1
    80001e9c:	4751                	li	a4,20
    80001e9e:	00f76f63          	bltu	a4,a5,80001ebc <syscall+0x44>
    80001ea2:	00369713          	slli	a4,a3,0x3
    80001ea6:	00006797          	auipc	a5,0x6
    80001eaa:	4fa78793          	addi	a5,a5,1274 # 800083a0 <syscalls>
    80001eae:	97ba                	add	a5,a5,a4
    80001eb0:	639c                	ld	a5,0(a5)
    80001eb2:	c789                	beqz	a5,80001ebc <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001eb4:	9782                	jalr	a5
    80001eb6:	06a93823          	sd	a0,112(s2)
    80001eba:	a839                	j	80001ed8 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80001ebc:	15848613          	addi	a2,s1,344
    80001ec0:	588c                	lw	a1,48(s1)
    80001ec2:	00006517          	auipc	a0,0x6
    80001ec6:	4a650513          	addi	a0,a0,1190 # 80008368 <states.0+0x150>
    80001eca:	00005097          	auipc	ra,0x5
    80001ece:	804080e7          	jalr	-2044(ra) # 800066ce <printf>
    p->trapframe->a0 = -1;
    80001ed2:	6cbc                	ld	a5,88(s1)
    80001ed4:	577d                	li	a4,-1
    80001ed6:	fbb8                	sd	a4,112(a5)
  }
}
    80001ed8:	60e2                	ld	ra,24(sp)
    80001eda:	6442                	ld	s0,16(sp)
    80001edc:	64a2                	ld	s1,8(sp)
    80001ede:	6902                	ld	s2,0(sp)
    80001ee0:	6105                	addi	sp,sp,32
    80001ee2:	8082                	ret

0000000080001ee4 <sys_exit>:
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64 sys_exit(void) {
    80001ee4:	1101                	addi	sp,sp,-32
    80001ee6:	ec06                	sd	ra,24(sp)
    80001ee8:	e822                	sd	s0,16(sp)
    80001eea:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001eec:	fec40593          	addi	a1,s0,-20
    80001ef0:	4501                	li	a0,0
    80001ef2:	00000097          	auipc	ra,0x0
    80001ef6:	f0e080e7          	jalr	-242(ra) # 80001e00 <argint>
  exit(n);
    80001efa:	fec42503          	lw	a0,-20(s0)
    80001efe:	fffff097          	auipc	ra,0xfffff
    80001f02:	59a080e7          	jalr	1434(ra) # 80001498 <exit>
  return 0;  // not reached
}
    80001f06:	4501                	li	a0,0
    80001f08:	60e2                	ld	ra,24(sp)
    80001f0a:	6442                	ld	s0,16(sp)
    80001f0c:	6105                	addi	sp,sp,32
    80001f0e:	8082                	ret

0000000080001f10 <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    80001f10:	1141                	addi	sp,sp,-16
    80001f12:	e406                	sd	ra,8(sp)
    80001f14:	e022                	sd	s0,0(sp)
    80001f16:	0800                	addi	s0,sp,16
    80001f18:	fffff097          	auipc	ra,0xfffff
    80001f1c:	d52080e7          	jalr	-686(ra) # 80000c6a <myproc>
    80001f20:	5908                	lw	a0,48(a0)
    80001f22:	60a2                	ld	ra,8(sp)
    80001f24:	6402                	ld	s0,0(sp)
    80001f26:	0141                	addi	sp,sp,16
    80001f28:	8082                	ret

0000000080001f2a <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    80001f2a:	1141                	addi	sp,sp,-16
    80001f2c:	e406                	sd	ra,8(sp)
    80001f2e:	e022                	sd	s0,0(sp)
    80001f30:	0800                	addi	s0,sp,16
    80001f32:	fffff097          	auipc	ra,0xfffff
    80001f36:	14c080e7          	jalr	332(ra) # 8000107e <fork>
    80001f3a:	60a2                	ld	ra,8(sp)
    80001f3c:	6402                	ld	s0,0(sp)
    80001f3e:	0141                	addi	sp,sp,16
    80001f40:	8082                	ret

0000000080001f42 <sys_wait>:

uint64 sys_wait(void) {
    80001f42:	1101                	addi	sp,sp,-32
    80001f44:	ec06                	sd	ra,24(sp)
    80001f46:	e822                	sd	s0,16(sp)
    80001f48:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001f4a:	fe840593          	addi	a1,s0,-24
    80001f4e:	4501                	li	a0,0
    80001f50:	00000097          	auipc	ra,0x0
    80001f54:	ed0080e7          	jalr	-304(ra) # 80001e20 <argaddr>
  return wait(p);
    80001f58:	fe843503          	ld	a0,-24(s0)
    80001f5c:	fffff097          	auipc	ra,0xfffff
    80001f60:	6fa080e7          	jalr	1786(ra) # 80001656 <wait>
}
    80001f64:	60e2                	ld	ra,24(sp)
    80001f66:	6442                	ld	s0,16(sp)
    80001f68:	6105                	addi	sp,sp,32
    80001f6a:	8082                	ret

0000000080001f6c <sys_sbrk>:

uint64 sys_sbrk(void) {
    80001f6c:	7179                	addi	sp,sp,-48
    80001f6e:	f406                	sd	ra,40(sp)
    80001f70:	f022                	sd	s0,32(sp)
    80001f72:	ec26                	sd	s1,24(sp)
    80001f74:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001f76:	fdc40593          	addi	a1,s0,-36
    80001f7a:	4501                	li	a0,0
    80001f7c:	00000097          	auipc	ra,0x0
    80001f80:	e84080e7          	jalr	-380(ra) # 80001e00 <argint>
  addr = myproc()->sz;
    80001f84:	fffff097          	auipc	ra,0xfffff
    80001f88:	ce6080e7          	jalr	-794(ra) # 80000c6a <myproc>
    80001f8c:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0) return -1;
    80001f8e:	fdc42503          	lw	a0,-36(s0)
    80001f92:	fffff097          	auipc	ra,0xfffff
    80001f96:	090080e7          	jalr	144(ra) # 80001022 <growproc>
    80001f9a:	00054863          	bltz	a0,80001faa <sys_sbrk+0x3e>
  return addr;
}
    80001f9e:	8526                	mv	a0,s1
    80001fa0:	70a2                	ld	ra,40(sp)
    80001fa2:	7402                	ld	s0,32(sp)
    80001fa4:	64e2                	ld	s1,24(sp)
    80001fa6:	6145                	addi	sp,sp,48
    80001fa8:	8082                	ret
  if (growproc(n) < 0) return -1;
    80001faa:	54fd                	li	s1,-1
    80001fac:	bfcd                	j	80001f9e <sys_sbrk+0x32>

0000000080001fae <sys_sleep>:

uint64 sys_sleep(void) {
    80001fae:	7139                	addi	sp,sp,-64
    80001fb0:	fc06                	sd	ra,56(sp)
    80001fb2:	f822                	sd	s0,48(sp)
    80001fb4:	f426                	sd	s1,40(sp)
    80001fb6:	f04a                	sd	s2,32(sp)
    80001fb8:	ec4e                	sd	s3,24(sp)
    80001fba:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001fbc:	fcc40593          	addi	a1,s0,-52
    80001fc0:	4501                	li	a0,0
    80001fc2:	00000097          	auipc	ra,0x0
    80001fc6:	e3e080e7          	jalr	-450(ra) # 80001e00 <argint>
  acquire(&tickslock);
    80001fca:	00007517          	auipc	a0,0x7
    80001fce:	eae50513          	addi	a0,a0,-338 # 80008e78 <tickslock>
    80001fd2:	00005097          	auipc	ra,0x5
    80001fd6:	bea080e7          	jalr	-1046(ra) # 80006bbc <acquire>
  ticks0 = ticks;
    80001fda:	00007917          	auipc	s2,0x7
    80001fde:	a0e92903          	lw	s2,-1522(s2) # 800089e8 <ticks>
  while (ticks - ticks0 < n) {
    80001fe2:	fcc42783          	lw	a5,-52(s0)
    80001fe6:	cf9d                	beqz	a5,80002024 <sys_sleep+0x76>
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001fe8:	00007997          	auipc	s3,0x7
    80001fec:	e9098993          	addi	s3,s3,-368 # 80008e78 <tickslock>
    80001ff0:	00007497          	auipc	s1,0x7
    80001ff4:	9f848493          	addi	s1,s1,-1544 # 800089e8 <ticks>
    if (killed(myproc())) {
    80001ff8:	fffff097          	auipc	ra,0xfffff
    80001ffc:	c72080e7          	jalr	-910(ra) # 80000c6a <myproc>
    80002000:	fffff097          	auipc	ra,0xfffff
    80002004:	624080e7          	jalr	1572(ra) # 80001624 <killed>
    80002008:	ed15                	bnez	a0,80002044 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    8000200a:	85ce                	mv	a1,s3
    8000200c:	8526                	mv	a0,s1
    8000200e:	fffff097          	auipc	ra,0xfffff
    80002012:	33c080e7          	jalr	828(ra) # 8000134a <sleep>
  while (ticks - ticks0 < n) {
    80002016:	409c                	lw	a5,0(s1)
    80002018:	412787bb          	subw	a5,a5,s2
    8000201c:	fcc42703          	lw	a4,-52(s0)
    80002020:	fce7ece3          	bltu	a5,a4,80001ff8 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002024:	00007517          	auipc	a0,0x7
    80002028:	e5450513          	addi	a0,a0,-428 # 80008e78 <tickslock>
    8000202c:	00005097          	auipc	ra,0x5
    80002030:	c3e080e7          	jalr	-962(ra) # 80006c6a <release>
  return 0;
    80002034:	4501                	li	a0,0
}
    80002036:	70e2                	ld	ra,56(sp)
    80002038:	7442                	ld	s0,48(sp)
    8000203a:	74a2                	ld	s1,40(sp)
    8000203c:	7902                	ld	s2,32(sp)
    8000203e:	69e2                	ld	s3,24(sp)
    80002040:	6121                	addi	sp,sp,64
    80002042:	8082                	ret
      release(&tickslock);
    80002044:	00007517          	auipc	a0,0x7
    80002048:	e3450513          	addi	a0,a0,-460 # 80008e78 <tickslock>
    8000204c:	00005097          	auipc	ra,0x5
    80002050:	c1e080e7          	jalr	-994(ra) # 80006c6a <release>
      return -1;
    80002054:	557d                	li	a0,-1
    80002056:	b7c5                	j	80002036 <sys_sleep+0x88>

0000000080002058 <sys_kill>:

uint64 sys_kill(void) {
    80002058:	1101                	addi	sp,sp,-32
    8000205a:	ec06                	sd	ra,24(sp)
    8000205c:	e822                	sd	s0,16(sp)
    8000205e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002060:	fec40593          	addi	a1,s0,-20
    80002064:	4501                	li	a0,0
    80002066:	00000097          	auipc	ra,0x0
    8000206a:	d9a080e7          	jalr	-614(ra) # 80001e00 <argint>
  return kill(pid);
    8000206e:	fec42503          	lw	a0,-20(s0)
    80002072:	fffff097          	auipc	ra,0xfffff
    80002076:	4fc080e7          	jalr	1276(ra) # 8000156e <kill>
}
    8000207a:	60e2                	ld	ra,24(sp)
    8000207c:	6442                	ld	s0,16(sp)
    8000207e:	6105                	addi	sp,sp,32
    80002080:	8082                	ret

0000000080002082 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    80002082:	1101                	addi	sp,sp,-32
    80002084:	ec06                	sd	ra,24(sp)
    80002086:	e822                	sd	s0,16(sp)
    80002088:	e426                	sd	s1,8(sp)
    8000208a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000208c:	00007517          	auipc	a0,0x7
    80002090:	dec50513          	addi	a0,a0,-532 # 80008e78 <tickslock>
    80002094:	00005097          	auipc	ra,0x5
    80002098:	b28080e7          	jalr	-1240(ra) # 80006bbc <acquire>
  xticks = ticks;
    8000209c:	00007497          	auipc	s1,0x7
    800020a0:	94c4a483          	lw	s1,-1716(s1) # 800089e8 <ticks>
  release(&tickslock);
    800020a4:	00007517          	auipc	a0,0x7
    800020a8:	dd450513          	addi	a0,a0,-556 # 80008e78 <tickslock>
    800020ac:	00005097          	auipc	ra,0x5
    800020b0:	bbe080e7          	jalr	-1090(ra) # 80006c6a <release>
  return xticks;
}
    800020b4:	02049513          	slli	a0,s1,0x20
    800020b8:	9101                	srli	a0,a0,0x20
    800020ba:	60e2                	ld	ra,24(sp)
    800020bc:	6442                	ld	s0,16(sp)
    800020be:	64a2                	ld	s1,8(sp)
    800020c0:	6105                	addi	sp,sp,32
    800020c2:	8082                	ret

00000000800020c4 <binit>:
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  struct buf head;
} bcache;

void binit(void) {
    800020c4:	7179                	addi	sp,sp,-48
    800020c6:	f406                	sd	ra,40(sp)
    800020c8:	f022                	sd	s0,32(sp)
    800020ca:	ec26                	sd	s1,24(sp)
    800020cc:	e84a                	sd	s2,16(sp)
    800020ce:	e44e                	sd	s3,8(sp)
    800020d0:	e052                	sd	s4,0(sp)
    800020d2:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800020d4:	00006597          	auipc	a1,0x6
    800020d8:	37c58593          	addi	a1,a1,892 # 80008450 <syscalls+0xb0>
    800020dc:	00007517          	auipc	a0,0x7
    800020e0:	db450513          	addi	a0,a0,-588 # 80008e90 <bcache>
    800020e4:	00005097          	auipc	ra,0x5
    800020e8:	a48080e7          	jalr	-1464(ra) # 80006b2c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800020ec:	0000f797          	auipc	a5,0xf
    800020f0:	da478793          	addi	a5,a5,-604 # 80010e90 <bcache+0x8000>
    800020f4:	0000f717          	auipc	a4,0xf
    800020f8:	00470713          	addi	a4,a4,4 # 800110f8 <bcache+0x8268>
    800020fc:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002100:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002104:	00007497          	auipc	s1,0x7
    80002108:	da448493          	addi	s1,s1,-604 # 80008ea8 <bcache+0x18>
    b->next = bcache.head.next;
    8000210c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000210e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002110:	00006a17          	auipc	s4,0x6
    80002114:	348a0a13          	addi	s4,s4,840 # 80008458 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002118:	2b893783          	ld	a5,696(s2)
    8000211c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000211e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002122:	85d2                	mv	a1,s4
    80002124:	01048513          	addi	a0,s1,16
    80002128:	00001097          	auipc	ra,0x1
    8000212c:	4c8080e7          	jalr	1224(ra) # 800035f0 <initsleeplock>
    bcache.head.next->prev = b;
    80002130:	2b893783          	ld	a5,696(s2)
    80002134:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002136:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    8000213a:	45848493          	addi	s1,s1,1112
    8000213e:	fd349de3          	bne	s1,s3,80002118 <binit+0x54>
  }
}
    80002142:	70a2                	ld	ra,40(sp)
    80002144:	7402                	ld	s0,32(sp)
    80002146:	64e2                	ld	s1,24(sp)
    80002148:	6942                	ld	s2,16(sp)
    8000214a:	69a2                	ld	s3,8(sp)
    8000214c:	6a02                	ld	s4,0(sp)
    8000214e:	6145                	addi	sp,sp,48
    80002150:	8082                	ret

0000000080002152 <bread>:
  }
  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf *bread(uint dev, uint blockno) {
    80002152:	7179                	addi	sp,sp,-48
    80002154:	f406                	sd	ra,40(sp)
    80002156:	f022                	sd	s0,32(sp)
    80002158:	ec26                	sd	s1,24(sp)
    8000215a:	e84a                	sd	s2,16(sp)
    8000215c:	e44e                	sd	s3,8(sp)
    8000215e:	1800                	addi	s0,sp,48
    80002160:	892a                	mv	s2,a0
    80002162:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002164:	00007517          	auipc	a0,0x7
    80002168:	d2c50513          	addi	a0,a0,-724 # 80008e90 <bcache>
    8000216c:	00005097          	auipc	ra,0x5
    80002170:	a50080e7          	jalr	-1456(ra) # 80006bbc <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    80002174:	0000f497          	auipc	s1,0xf
    80002178:	fd44b483          	ld	s1,-44(s1) # 80011148 <bcache+0x82b8>
    8000217c:	0000f797          	auipc	a5,0xf
    80002180:	f7c78793          	addi	a5,a5,-132 # 800110f8 <bcache+0x8268>
    80002184:	02f48f63          	beq	s1,a5,800021c2 <bread+0x70>
    80002188:	873e                	mv	a4,a5
    8000218a:	a021                	j	80002192 <bread+0x40>
    8000218c:	68a4                	ld	s1,80(s1)
    8000218e:	02e48a63          	beq	s1,a4,800021c2 <bread+0x70>
    if (b->dev == dev && b->blockno == blockno) {
    80002192:	449c                	lw	a5,8(s1)
    80002194:	ff279ce3          	bne	a5,s2,8000218c <bread+0x3a>
    80002198:	44dc                	lw	a5,12(s1)
    8000219a:	ff3799e3          	bne	a5,s3,8000218c <bread+0x3a>
      b->refcnt++;
    8000219e:	40bc                	lw	a5,64(s1)
    800021a0:	2785                	addiw	a5,a5,1
    800021a2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800021a4:	00007517          	auipc	a0,0x7
    800021a8:	cec50513          	addi	a0,a0,-788 # 80008e90 <bcache>
    800021ac:	00005097          	auipc	ra,0x5
    800021b0:	abe080e7          	jalr	-1346(ra) # 80006c6a <release>
      acquiresleep(&b->lock);
    800021b4:	01048513          	addi	a0,s1,16
    800021b8:	00001097          	auipc	ra,0x1
    800021bc:	472080e7          	jalr	1138(ra) # 8000362a <acquiresleep>
      return b;
    800021c0:	a8b9                	j	8000221e <bread+0xcc>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    800021c2:	0000f497          	auipc	s1,0xf
    800021c6:	f7e4b483          	ld	s1,-130(s1) # 80011140 <bcache+0x82b0>
    800021ca:	0000f797          	auipc	a5,0xf
    800021ce:	f2e78793          	addi	a5,a5,-210 # 800110f8 <bcache+0x8268>
    800021d2:	00f48863          	beq	s1,a5,800021e2 <bread+0x90>
    800021d6:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    800021d8:	40bc                	lw	a5,64(s1)
    800021da:	cf81                	beqz	a5,800021f2 <bread+0xa0>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    800021dc:	64a4                	ld	s1,72(s1)
    800021de:	fee49de3          	bne	s1,a4,800021d8 <bread+0x86>
  panic("bget: no buffers");
    800021e2:	00006517          	auipc	a0,0x6
    800021e6:	27e50513          	addi	a0,a0,638 # 80008460 <syscalls+0xc0>
    800021ea:	00004097          	auipc	ra,0x4
    800021ee:	49a080e7          	jalr	1178(ra) # 80006684 <panic>
      b->dev = dev;
    800021f2:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800021f6:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800021fa:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800021fe:	4785                	li	a5,1
    80002200:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002202:	00007517          	auipc	a0,0x7
    80002206:	c8e50513          	addi	a0,a0,-882 # 80008e90 <bcache>
    8000220a:	00005097          	auipc	ra,0x5
    8000220e:	a60080e7          	jalr	-1440(ra) # 80006c6a <release>
      acquiresleep(&b->lock);
    80002212:	01048513          	addi	a0,s1,16
    80002216:	00001097          	auipc	ra,0x1
    8000221a:	414080e7          	jalr	1044(ra) # 8000362a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    8000221e:	409c                	lw	a5,0(s1)
    80002220:	cb89                	beqz	a5,80002232 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002222:	8526                	mv	a0,s1
    80002224:	70a2                	ld	ra,40(sp)
    80002226:	7402                	ld	s0,32(sp)
    80002228:	64e2                	ld	s1,24(sp)
    8000222a:	6942                	ld	s2,16(sp)
    8000222c:	69a2                	ld	s3,8(sp)
    8000222e:	6145                	addi	sp,sp,48
    80002230:	8082                	ret
    virtio_disk_rw(b, 0);
    80002232:	4581                	li	a1,0
    80002234:	8526                	mv	a0,s1
    80002236:	00003097          	auipc	ra,0x3
    8000223a:	f5c080e7          	jalr	-164(ra) # 80005192 <virtio_disk_rw>
    b->valid = 1;
    8000223e:	4785                	li	a5,1
    80002240:	c09c                	sw	a5,0(s1)
  return b;
    80002242:	b7c5                	j	80002222 <bread+0xd0>

0000000080002244 <bwrite>:

// Write b's contents to disk.  Must be locked.
void bwrite(struct buf *b) {
    80002244:	1101                	addi	sp,sp,-32
    80002246:	ec06                	sd	ra,24(sp)
    80002248:	e822                	sd	s0,16(sp)
    8000224a:	e426                	sd	s1,8(sp)
    8000224c:	1000                	addi	s0,sp,32
    8000224e:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock)) panic("bwrite");
    80002250:	0541                	addi	a0,a0,16
    80002252:	00001097          	auipc	ra,0x1
    80002256:	472080e7          	jalr	1138(ra) # 800036c4 <holdingsleep>
    8000225a:	cd01                	beqz	a0,80002272 <bwrite+0x2e>
  virtio_disk_rw(b, 1);
    8000225c:	4585                	li	a1,1
    8000225e:	8526                	mv	a0,s1
    80002260:	00003097          	auipc	ra,0x3
    80002264:	f32080e7          	jalr	-206(ra) # 80005192 <virtio_disk_rw>
}
    80002268:	60e2                	ld	ra,24(sp)
    8000226a:	6442                	ld	s0,16(sp)
    8000226c:	64a2                	ld	s1,8(sp)
    8000226e:	6105                	addi	sp,sp,32
    80002270:	8082                	ret
  if (!holdingsleep(&b->lock)) panic("bwrite");
    80002272:	00006517          	auipc	a0,0x6
    80002276:	20650513          	addi	a0,a0,518 # 80008478 <syscalls+0xd8>
    8000227a:	00004097          	auipc	ra,0x4
    8000227e:	40a080e7          	jalr	1034(ra) # 80006684 <panic>

0000000080002282 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void brelse(struct buf *b) {
    80002282:	1101                	addi	sp,sp,-32
    80002284:	ec06                	sd	ra,24(sp)
    80002286:	e822                	sd	s0,16(sp)
    80002288:	e426                	sd	s1,8(sp)
    8000228a:	e04a                	sd	s2,0(sp)
    8000228c:	1000                	addi	s0,sp,32
    8000228e:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock)) panic("brelse");
    80002290:	01050913          	addi	s2,a0,16
    80002294:	854a                	mv	a0,s2
    80002296:	00001097          	auipc	ra,0x1
    8000229a:	42e080e7          	jalr	1070(ra) # 800036c4 <holdingsleep>
    8000229e:	c92d                	beqz	a0,80002310 <brelse+0x8e>

  releasesleep(&b->lock);
    800022a0:	854a                	mv	a0,s2
    800022a2:	00001097          	auipc	ra,0x1
    800022a6:	3de080e7          	jalr	990(ra) # 80003680 <releasesleep>

  acquire(&bcache.lock);
    800022aa:	00007517          	auipc	a0,0x7
    800022ae:	be650513          	addi	a0,a0,-1050 # 80008e90 <bcache>
    800022b2:	00005097          	auipc	ra,0x5
    800022b6:	90a080e7          	jalr	-1782(ra) # 80006bbc <acquire>
  b->refcnt--;
    800022ba:	40bc                	lw	a5,64(s1)
    800022bc:	37fd                	addiw	a5,a5,-1
    800022be:	0007871b          	sext.w	a4,a5
    800022c2:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800022c4:	eb05                	bnez	a4,800022f4 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800022c6:	68bc                	ld	a5,80(s1)
    800022c8:	64b8                	ld	a4,72(s1)
    800022ca:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800022cc:	64bc                	ld	a5,72(s1)
    800022ce:	68b8                	ld	a4,80(s1)
    800022d0:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800022d2:	0000f797          	auipc	a5,0xf
    800022d6:	bbe78793          	addi	a5,a5,-1090 # 80010e90 <bcache+0x8000>
    800022da:	2b87b703          	ld	a4,696(a5)
    800022de:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800022e0:	0000f717          	auipc	a4,0xf
    800022e4:	e1870713          	addi	a4,a4,-488 # 800110f8 <bcache+0x8268>
    800022e8:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800022ea:	2b87b703          	ld	a4,696(a5)
    800022ee:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800022f0:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    800022f4:	00007517          	auipc	a0,0x7
    800022f8:	b9c50513          	addi	a0,a0,-1124 # 80008e90 <bcache>
    800022fc:	00005097          	auipc	ra,0x5
    80002300:	96e080e7          	jalr	-1682(ra) # 80006c6a <release>
}
    80002304:	60e2                	ld	ra,24(sp)
    80002306:	6442                	ld	s0,16(sp)
    80002308:	64a2                	ld	s1,8(sp)
    8000230a:	6902                	ld	s2,0(sp)
    8000230c:	6105                	addi	sp,sp,32
    8000230e:	8082                	ret
  if (!holdingsleep(&b->lock)) panic("brelse");
    80002310:	00006517          	auipc	a0,0x6
    80002314:	17050513          	addi	a0,a0,368 # 80008480 <syscalls+0xe0>
    80002318:	00004097          	auipc	ra,0x4
    8000231c:	36c080e7          	jalr	876(ra) # 80006684 <panic>

0000000080002320 <bpin>:

void bpin(struct buf *b) {
    80002320:	1101                	addi	sp,sp,-32
    80002322:	ec06                	sd	ra,24(sp)
    80002324:	e822                	sd	s0,16(sp)
    80002326:	e426                	sd	s1,8(sp)
    80002328:	1000                	addi	s0,sp,32
    8000232a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000232c:	00007517          	auipc	a0,0x7
    80002330:	b6450513          	addi	a0,a0,-1180 # 80008e90 <bcache>
    80002334:	00005097          	auipc	ra,0x5
    80002338:	888080e7          	jalr	-1912(ra) # 80006bbc <acquire>
  b->refcnt++;
    8000233c:	40bc                	lw	a5,64(s1)
    8000233e:	2785                	addiw	a5,a5,1
    80002340:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002342:	00007517          	auipc	a0,0x7
    80002346:	b4e50513          	addi	a0,a0,-1202 # 80008e90 <bcache>
    8000234a:	00005097          	auipc	ra,0x5
    8000234e:	920080e7          	jalr	-1760(ra) # 80006c6a <release>
}
    80002352:	60e2                	ld	ra,24(sp)
    80002354:	6442                	ld	s0,16(sp)
    80002356:	64a2                	ld	s1,8(sp)
    80002358:	6105                	addi	sp,sp,32
    8000235a:	8082                	ret

000000008000235c <bunpin>:

void bunpin(struct buf *b) {
    8000235c:	1101                	addi	sp,sp,-32
    8000235e:	ec06                	sd	ra,24(sp)
    80002360:	e822                	sd	s0,16(sp)
    80002362:	e426                	sd	s1,8(sp)
    80002364:	1000                	addi	s0,sp,32
    80002366:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002368:	00007517          	auipc	a0,0x7
    8000236c:	b2850513          	addi	a0,a0,-1240 # 80008e90 <bcache>
    80002370:	00005097          	auipc	ra,0x5
    80002374:	84c080e7          	jalr	-1972(ra) # 80006bbc <acquire>
  b->refcnt--;
    80002378:	40bc                	lw	a5,64(s1)
    8000237a:	37fd                	addiw	a5,a5,-1
    8000237c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000237e:	00007517          	auipc	a0,0x7
    80002382:	b1250513          	addi	a0,a0,-1262 # 80008e90 <bcache>
    80002386:	00005097          	auipc	ra,0x5
    8000238a:	8e4080e7          	jalr	-1820(ra) # 80006c6a <release>
}
    8000238e:	60e2                	ld	ra,24(sp)
    80002390:	6442                	ld	s0,16(sp)
    80002392:	64a2                	ld	s1,8(sp)
    80002394:	6105                	addi	sp,sp,32
    80002396:	8082                	ret

0000000080002398 <bfree>:
  printf("balloc: out of blocks\n");
  return 0;
}

// Free a disk block.
static void bfree(int dev, uint b) {
    80002398:	1101                	addi	sp,sp,-32
    8000239a:	ec06                	sd	ra,24(sp)
    8000239c:	e822                	sd	s0,16(sp)
    8000239e:	e426                	sd	s1,8(sp)
    800023a0:	e04a                	sd	s2,0(sp)
    800023a2:	1000                	addi	s0,sp,32
    800023a4:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800023a6:	00d5d59b          	srliw	a1,a1,0xd
    800023aa:	0000f797          	auipc	a5,0xf
    800023ae:	1c27a783          	lw	a5,450(a5) # 8001156c <sb+0x1c>
    800023b2:	9dbd                	addw	a1,a1,a5
    800023b4:	00000097          	auipc	ra,0x0
    800023b8:	d9e080e7          	jalr	-610(ra) # 80002152 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800023bc:	0074f713          	andi	a4,s1,7
    800023c0:	4785                	li	a5,1
    800023c2:	00e797bb          	sllw	a5,a5,a4
  if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
    800023c6:	14ce                	slli	s1,s1,0x33
    800023c8:	90d9                	srli	s1,s1,0x36
    800023ca:	00950733          	add	a4,a0,s1
    800023ce:	05874703          	lbu	a4,88(a4)
    800023d2:	00e7f6b3          	and	a3,a5,a4
    800023d6:	c69d                	beqz	a3,80002404 <bfree+0x6c>
    800023d8:	892a                	mv	s2,a0
  bp->data[bi / 8] &= ~m;
    800023da:	94aa                	add	s1,s1,a0
    800023dc:	fff7c793          	not	a5,a5
    800023e0:	8f7d                	and	a4,a4,a5
    800023e2:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800023e6:	00001097          	auipc	ra,0x1
    800023ea:	126080e7          	jalr	294(ra) # 8000350c <log_write>
  brelse(bp);
    800023ee:	854a                	mv	a0,s2
    800023f0:	00000097          	auipc	ra,0x0
    800023f4:	e92080e7          	jalr	-366(ra) # 80002282 <brelse>
}
    800023f8:	60e2                	ld	ra,24(sp)
    800023fa:	6442                	ld	s0,16(sp)
    800023fc:	64a2                	ld	s1,8(sp)
    800023fe:	6902                	ld	s2,0(sp)
    80002400:	6105                	addi	sp,sp,32
    80002402:	8082                	ret
  if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
    80002404:	00006517          	auipc	a0,0x6
    80002408:	08450513          	addi	a0,a0,132 # 80008488 <syscalls+0xe8>
    8000240c:	00004097          	auipc	ra,0x4
    80002410:	278080e7          	jalr	632(ra) # 80006684 <panic>

0000000080002414 <balloc>:
static uint balloc(uint dev) {
    80002414:	711d                	addi	sp,sp,-96
    80002416:	ec86                	sd	ra,88(sp)
    80002418:	e8a2                	sd	s0,80(sp)
    8000241a:	e4a6                	sd	s1,72(sp)
    8000241c:	e0ca                	sd	s2,64(sp)
    8000241e:	fc4e                	sd	s3,56(sp)
    80002420:	f852                	sd	s4,48(sp)
    80002422:	f456                	sd	s5,40(sp)
    80002424:	f05a                	sd	s6,32(sp)
    80002426:	ec5e                	sd	s7,24(sp)
    80002428:	e862                	sd	s8,16(sp)
    8000242a:	e466                	sd	s9,8(sp)
    8000242c:	1080                	addi	s0,sp,96
  for (b = 0; b < sb.size; b += BPB) {
    8000242e:	0000f797          	auipc	a5,0xf
    80002432:	1267a783          	lw	a5,294(a5) # 80011554 <sb+0x4>
    80002436:	cff5                	beqz	a5,80002532 <balloc+0x11e>
    80002438:	8baa                	mv	s7,a0
    8000243a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000243c:	0000fb17          	auipc	s6,0xf
    80002440:	114b0b13          	addi	s6,s6,276 # 80011550 <sb>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002444:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002446:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002448:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    8000244a:	6c89                	lui	s9,0x2
    8000244c:	a061                	j	800024d4 <balloc+0xc0>
        bp->data[bi / 8] |= m;            // Mark block in use.
    8000244e:	97ca                	add	a5,a5,s2
    80002450:	8e55                	or	a2,a2,a3
    80002452:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002456:	854a                	mv	a0,s2
    80002458:	00001097          	auipc	ra,0x1
    8000245c:	0b4080e7          	jalr	180(ra) # 8000350c <log_write>
        brelse(bp);
    80002460:	854a                	mv	a0,s2
    80002462:	00000097          	auipc	ra,0x0
    80002466:	e20080e7          	jalr	-480(ra) # 80002282 <brelse>
  bp = bread(dev, bno);
    8000246a:	85a6                	mv	a1,s1
    8000246c:	855e                	mv	a0,s7
    8000246e:	00000097          	auipc	ra,0x0
    80002472:	ce4080e7          	jalr	-796(ra) # 80002152 <bread>
    80002476:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002478:	40000613          	li	a2,1024
    8000247c:	4581                	li	a1,0
    8000247e:	05850513          	addi	a0,a0,88
    80002482:	ffffe097          	auipc	ra,0xffffe
    80002486:	bf4080e7          	jalr	-1036(ra) # 80000076 <memset>
  log_write(bp);
    8000248a:	854a                	mv	a0,s2
    8000248c:	00001097          	auipc	ra,0x1
    80002490:	080080e7          	jalr	128(ra) # 8000350c <log_write>
  brelse(bp);
    80002494:	854a                	mv	a0,s2
    80002496:	00000097          	auipc	ra,0x0
    8000249a:	dec080e7          	jalr	-532(ra) # 80002282 <brelse>
}
    8000249e:	8526                	mv	a0,s1
    800024a0:	60e6                	ld	ra,88(sp)
    800024a2:	6446                	ld	s0,80(sp)
    800024a4:	64a6                	ld	s1,72(sp)
    800024a6:	6906                	ld	s2,64(sp)
    800024a8:	79e2                	ld	s3,56(sp)
    800024aa:	7a42                	ld	s4,48(sp)
    800024ac:	7aa2                	ld	s5,40(sp)
    800024ae:	7b02                	ld	s6,32(sp)
    800024b0:	6be2                	ld	s7,24(sp)
    800024b2:	6c42                	ld	s8,16(sp)
    800024b4:	6ca2                	ld	s9,8(sp)
    800024b6:	6125                	addi	sp,sp,96
    800024b8:	8082                	ret
    brelse(bp);
    800024ba:	854a                	mv	a0,s2
    800024bc:	00000097          	auipc	ra,0x0
    800024c0:	dc6080e7          	jalr	-570(ra) # 80002282 <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    800024c4:	015c87bb          	addw	a5,s9,s5
    800024c8:	00078a9b          	sext.w	s5,a5
    800024cc:	004b2703          	lw	a4,4(s6)
    800024d0:	06eaf163          	bgeu	s5,a4,80002532 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800024d4:	41fad79b          	sraiw	a5,s5,0x1f
    800024d8:	0137d79b          	srliw	a5,a5,0x13
    800024dc:	015787bb          	addw	a5,a5,s5
    800024e0:	40d7d79b          	sraiw	a5,a5,0xd
    800024e4:	01cb2583          	lw	a1,28(s6)
    800024e8:	9dbd                	addw	a1,a1,a5
    800024ea:	855e                	mv	a0,s7
    800024ec:	00000097          	auipc	ra,0x0
    800024f0:	c66080e7          	jalr	-922(ra) # 80002152 <bread>
    800024f4:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800024f6:	004b2503          	lw	a0,4(s6)
    800024fa:	000a849b          	sext.w	s1,s5
    800024fe:	8762                	mv	a4,s8
    80002500:	faa4fde3          	bgeu	s1,a0,800024ba <balloc+0xa6>
      m = 1 << (bi % 8);
    80002504:	00777693          	andi	a3,a4,7
    80002508:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) {  // Is block free?
    8000250c:	41f7579b          	sraiw	a5,a4,0x1f
    80002510:	01d7d79b          	srliw	a5,a5,0x1d
    80002514:	9fb9                	addw	a5,a5,a4
    80002516:	4037d79b          	sraiw	a5,a5,0x3
    8000251a:	00f90633          	add	a2,s2,a5
    8000251e:	05864603          	lbu	a2,88(a2)
    80002522:	00c6f5b3          	and	a1,a3,a2
    80002526:	d585                	beqz	a1,8000244e <balloc+0x3a>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002528:	2705                	addiw	a4,a4,1
    8000252a:	2485                	addiw	s1,s1,1
    8000252c:	fd471ae3          	bne	a4,s4,80002500 <balloc+0xec>
    80002530:	b769                	j	800024ba <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80002532:	00006517          	auipc	a0,0x6
    80002536:	f6e50513          	addi	a0,a0,-146 # 800084a0 <syscalls+0x100>
    8000253a:	00004097          	auipc	ra,0x4
    8000253e:	194080e7          	jalr	404(ra) # 800066ce <printf>
  return 0;
    80002542:	4481                	li	s1,0
    80002544:	bfa9                	j	8000249e <balloc+0x8a>

0000000080002546 <bmap>:
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint bmap(struct inode *ip, uint bn) {
    80002546:	7179                	addi	sp,sp,-48
    80002548:	f406                	sd	ra,40(sp)
    8000254a:	f022                	sd	s0,32(sp)
    8000254c:	ec26                	sd	s1,24(sp)
    8000254e:	e84a                	sd	s2,16(sp)
    80002550:	e44e                	sd	s3,8(sp)
    80002552:	e052                	sd	s4,0(sp)
    80002554:	1800                	addi	s0,sp,48
    80002556:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    80002558:	47ad                	li	a5,11
    8000255a:	02b7e863          	bltu	a5,a1,8000258a <bmap+0x44>
    if ((addr = ip->addrs[bn]) == 0) {
    8000255e:	02059793          	slli	a5,a1,0x20
    80002562:	01e7d593          	srli	a1,a5,0x1e
    80002566:	00b504b3          	add	s1,a0,a1
    8000256a:	0504a903          	lw	s2,80(s1)
    8000256e:	06091e63          	bnez	s2,800025ea <bmap+0xa4>
      addr = balloc(ip->dev);
    80002572:	4108                	lw	a0,0(a0)
    80002574:	00000097          	auipc	ra,0x0
    80002578:	ea0080e7          	jalr	-352(ra) # 80002414 <balloc>
    8000257c:	0005091b          	sext.w	s2,a0
      if (addr == 0) return 0;
    80002580:	06090563          	beqz	s2,800025ea <bmap+0xa4>
      ip->addrs[bn] = addr;
    80002584:	0524a823          	sw	s2,80(s1)
    80002588:	a08d                	j	800025ea <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000258a:	ff45849b          	addiw	s1,a1,-12
    8000258e:	0004871b          	sext.w	a4,s1

  if (bn < NINDIRECT) {
    80002592:	0ff00793          	li	a5,255
    80002596:	08e7e563          	bltu	a5,a4,80002620 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    8000259a:	08052903          	lw	s2,128(a0)
    8000259e:	00091d63          	bnez	s2,800025b8 <bmap+0x72>
      addr = balloc(ip->dev);
    800025a2:	4108                	lw	a0,0(a0)
    800025a4:	00000097          	auipc	ra,0x0
    800025a8:	e70080e7          	jalr	-400(ra) # 80002414 <balloc>
    800025ac:	0005091b          	sext.w	s2,a0
      if (addr == 0) return 0;
    800025b0:	02090d63          	beqz	s2,800025ea <bmap+0xa4>
      ip->addrs[NDIRECT] = addr;
    800025b4:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800025b8:	85ca                	mv	a1,s2
    800025ba:	0009a503          	lw	a0,0(s3)
    800025be:	00000097          	auipc	ra,0x0
    800025c2:	b94080e7          	jalr	-1132(ra) # 80002152 <bread>
    800025c6:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    800025c8:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    800025cc:	02049713          	slli	a4,s1,0x20
    800025d0:	01e75593          	srli	a1,a4,0x1e
    800025d4:	00b784b3          	add	s1,a5,a1
    800025d8:	0004a903          	lw	s2,0(s1)
    800025dc:	02090063          	beqz	s2,800025fc <bmap+0xb6>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800025e0:	8552                	mv	a0,s4
    800025e2:	00000097          	auipc	ra,0x0
    800025e6:	ca0080e7          	jalr	-864(ra) # 80002282 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800025ea:	854a                	mv	a0,s2
    800025ec:	70a2                	ld	ra,40(sp)
    800025ee:	7402                	ld	s0,32(sp)
    800025f0:	64e2                	ld	s1,24(sp)
    800025f2:	6942                	ld	s2,16(sp)
    800025f4:	69a2                	ld	s3,8(sp)
    800025f6:	6a02                	ld	s4,0(sp)
    800025f8:	6145                	addi	sp,sp,48
    800025fa:	8082                	ret
      addr = balloc(ip->dev);
    800025fc:	0009a503          	lw	a0,0(s3)
    80002600:	00000097          	auipc	ra,0x0
    80002604:	e14080e7          	jalr	-492(ra) # 80002414 <balloc>
    80002608:	0005091b          	sext.w	s2,a0
      if (addr) {
    8000260c:	fc090ae3          	beqz	s2,800025e0 <bmap+0x9a>
        a[bn] = addr;
    80002610:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002614:	8552                	mv	a0,s4
    80002616:	00001097          	auipc	ra,0x1
    8000261a:	ef6080e7          	jalr	-266(ra) # 8000350c <log_write>
    8000261e:	b7c9                	j	800025e0 <bmap+0x9a>
  panic("bmap: out of range");
    80002620:	00006517          	auipc	a0,0x6
    80002624:	e9850513          	addi	a0,a0,-360 # 800084b8 <syscalls+0x118>
    80002628:	00004097          	auipc	ra,0x4
    8000262c:	05c080e7          	jalr	92(ra) # 80006684 <panic>

0000000080002630 <iget>:
static struct inode *iget(uint dev, uint inum) {
    80002630:	7179                	addi	sp,sp,-48
    80002632:	f406                	sd	ra,40(sp)
    80002634:	f022                	sd	s0,32(sp)
    80002636:	ec26                	sd	s1,24(sp)
    80002638:	e84a                	sd	s2,16(sp)
    8000263a:	e44e                	sd	s3,8(sp)
    8000263c:	e052                	sd	s4,0(sp)
    8000263e:	1800                	addi	s0,sp,48
    80002640:	89aa                	mv	s3,a0
    80002642:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002644:	0000f517          	auipc	a0,0xf
    80002648:	f2c50513          	addi	a0,a0,-212 # 80011570 <itable>
    8000264c:	00004097          	auipc	ra,0x4
    80002650:	570080e7          	jalr	1392(ra) # 80006bbc <acquire>
  empty = 0;
    80002654:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80002656:	0000f497          	auipc	s1,0xf
    8000265a:	f3248493          	addi	s1,s1,-206 # 80011588 <itable+0x18>
    8000265e:	00011697          	auipc	a3,0x11
    80002662:	9ba68693          	addi	a3,a3,-1606 # 80013018 <log>
    80002666:	a039                	j	80002674 <iget+0x44>
    if (empty == 0 && ip->ref == 0)  // Remember empty slot.
    80002668:	02090b63          	beqz	s2,8000269e <iget+0x6e>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    8000266c:	08848493          	addi	s1,s1,136
    80002670:	02d48a63          	beq	s1,a3,800026a4 <iget+0x74>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    80002674:	449c                	lw	a5,8(s1)
    80002676:	fef059e3          	blez	a5,80002668 <iget+0x38>
    8000267a:	4098                	lw	a4,0(s1)
    8000267c:	ff3716e3          	bne	a4,s3,80002668 <iget+0x38>
    80002680:	40d8                	lw	a4,4(s1)
    80002682:	ff4713e3          	bne	a4,s4,80002668 <iget+0x38>
      ip->ref++;
    80002686:	2785                	addiw	a5,a5,1
    80002688:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000268a:	0000f517          	auipc	a0,0xf
    8000268e:	ee650513          	addi	a0,a0,-282 # 80011570 <itable>
    80002692:	00004097          	auipc	ra,0x4
    80002696:	5d8080e7          	jalr	1496(ra) # 80006c6a <release>
      return ip;
    8000269a:	8926                	mv	s2,s1
    8000269c:	a03d                	j	800026ca <iget+0x9a>
    if (empty == 0 && ip->ref == 0)  // Remember empty slot.
    8000269e:	f7f9                	bnez	a5,8000266c <iget+0x3c>
    800026a0:	8926                	mv	s2,s1
    800026a2:	b7e9                	j	8000266c <iget+0x3c>
  if (empty == 0) panic("iget: no inodes");
    800026a4:	02090c63          	beqz	s2,800026dc <iget+0xac>
  ip->dev = dev;
    800026a8:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800026ac:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800026b0:	4785                	li	a5,1
    800026b2:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800026b6:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800026ba:	0000f517          	auipc	a0,0xf
    800026be:	eb650513          	addi	a0,a0,-330 # 80011570 <itable>
    800026c2:	00004097          	auipc	ra,0x4
    800026c6:	5a8080e7          	jalr	1448(ra) # 80006c6a <release>
}
    800026ca:	854a                	mv	a0,s2
    800026cc:	70a2                	ld	ra,40(sp)
    800026ce:	7402                	ld	s0,32(sp)
    800026d0:	64e2                	ld	s1,24(sp)
    800026d2:	6942                	ld	s2,16(sp)
    800026d4:	69a2                	ld	s3,8(sp)
    800026d6:	6a02                	ld	s4,0(sp)
    800026d8:	6145                	addi	sp,sp,48
    800026da:	8082                	ret
  if (empty == 0) panic("iget: no inodes");
    800026dc:	00006517          	auipc	a0,0x6
    800026e0:	df450513          	addi	a0,a0,-524 # 800084d0 <syscalls+0x130>
    800026e4:	00004097          	auipc	ra,0x4
    800026e8:	fa0080e7          	jalr	-96(ra) # 80006684 <panic>

00000000800026ec <fsinit>:
void fsinit(int dev) {
    800026ec:	7179                	addi	sp,sp,-48
    800026ee:	f406                	sd	ra,40(sp)
    800026f0:	f022                	sd	s0,32(sp)
    800026f2:	ec26                	sd	s1,24(sp)
    800026f4:	e84a                	sd	s2,16(sp)
    800026f6:	e44e                	sd	s3,8(sp)
    800026f8:	1800                	addi	s0,sp,48
    800026fa:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800026fc:	4585                	li	a1,1
    800026fe:	00000097          	auipc	ra,0x0
    80002702:	a54080e7          	jalr	-1452(ra) # 80002152 <bread>
    80002706:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002708:	0000f997          	auipc	s3,0xf
    8000270c:	e4898993          	addi	s3,s3,-440 # 80011550 <sb>
    80002710:	02000613          	li	a2,32
    80002714:	05850593          	addi	a1,a0,88
    80002718:	854e                	mv	a0,s3
    8000271a:	ffffe097          	auipc	ra,0xffffe
    8000271e:	9b8080e7          	jalr	-1608(ra) # 800000d2 <memmove>
  brelse(bp);
    80002722:	8526                	mv	a0,s1
    80002724:	00000097          	auipc	ra,0x0
    80002728:	b5e080e7          	jalr	-1186(ra) # 80002282 <brelse>
  if (sb.magic != FSMAGIC) panic("invalid file system");
    8000272c:	0009a703          	lw	a4,0(s3)
    80002730:	102037b7          	lui	a5,0x10203
    80002734:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002738:	02f71263          	bne	a4,a5,8000275c <fsinit+0x70>
  initlog(dev, &sb);
    8000273c:	0000f597          	auipc	a1,0xf
    80002740:	e1458593          	addi	a1,a1,-492 # 80011550 <sb>
    80002744:	854a                	mv	a0,s2
    80002746:	00001097          	auipc	ra,0x1
    8000274a:	b4a080e7          	jalr	-1206(ra) # 80003290 <initlog>
}
    8000274e:	70a2                	ld	ra,40(sp)
    80002750:	7402                	ld	s0,32(sp)
    80002752:	64e2                	ld	s1,24(sp)
    80002754:	6942                	ld	s2,16(sp)
    80002756:	69a2                	ld	s3,8(sp)
    80002758:	6145                	addi	sp,sp,48
    8000275a:	8082                	ret
  if (sb.magic != FSMAGIC) panic("invalid file system");
    8000275c:	00006517          	auipc	a0,0x6
    80002760:	d8450513          	addi	a0,a0,-636 # 800084e0 <syscalls+0x140>
    80002764:	00004097          	auipc	ra,0x4
    80002768:	f20080e7          	jalr	-224(ra) # 80006684 <panic>

000000008000276c <iinit>:
void iinit() {
    8000276c:	7179                	addi	sp,sp,-48
    8000276e:	f406                	sd	ra,40(sp)
    80002770:	f022                	sd	s0,32(sp)
    80002772:	ec26                	sd	s1,24(sp)
    80002774:	e84a                	sd	s2,16(sp)
    80002776:	e44e                	sd	s3,8(sp)
    80002778:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000277a:	00006597          	auipc	a1,0x6
    8000277e:	d7e58593          	addi	a1,a1,-642 # 800084f8 <syscalls+0x158>
    80002782:	0000f517          	auipc	a0,0xf
    80002786:	dee50513          	addi	a0,a0,-530 # 80011570 <itable>
    8000278a:	00004097          	auipc	ra,0x4
    8000278e:	3a2080e7          	jalr	930(ra) # 80006b2c <initlock>
  for (i = 0; i < NINODE; i++) {
    80002792:	0000f497          	auipc	s1,0xf
    80002796:	e0648493          	addi	s1,s1,-506 # 80011598 <itable+0x28>
    8000279a:	00011997          	auipc	s3,0x11
    8000279e:	88e98993          	addi	s3,s3,-1906 # 80013028 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800027a2:	00006917          	auipc	s2,0x6
    800027a6:	d5e90913          	addi	s2,s2,-674 # 80008500 <syscalls+0x160>
    800027aa:	85ca                	mv	a1,s2
    800027ac:	8526                	mv	a0,s1
    800027ae:	00001097          	auipc	ra,0x1
    800027b2:	e42080e7          	jalr	-446(ra) # 800035f0 <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    800027b6:	08848493          	addi	s1,s1,136
    800027ba:	ff3498e3          	bne	s1,s3,800027aa <iinit+0x3e>
}
    800027be:	70a2                	ld	ra,40(sp)
    800027c0:	7402                	ld	s0,32(sp)
    800027c2:	64e2                	ld	s1,24(sp)
    800027c4:	6942                	ld	s2,16(sp)
    800027c6:	69a2                	ld	s3,8(sp)
    800027c8:	6145                	addi	sp,sp,48
    800027ca:	8082                	ret

00000000800027cc <ialloc>:
struct inode *ialloc(uint dev, short type) {
    800027cc:	715d                	addi	sp,sp,-80
    800027ce:	e486                	sd	ra,72(sp)
    800027d0:	e0a2                	sd	s0,64(sp)
    800027d2:	fc26                	sd	s1,56(sp)
    800027d4:	f84a                	sd	s2,48(sp)
    800027d6:	f44e                	sd	s3,40(sp)
    800027d8:	f052                	sd	s4,32(sp)
    800027da:	ec56                	sd	s5,24(sp)
    800027dc:	e85a                	sd	s6,16(sp)
    800027de:	e45e                	sd	s7,8(sp)
    800027e0:	0880                	addi	s0,sp,80
  for (inum = 1; inum < sb.ninodes; inum++) {
    800027e2:	0000f717          	auipc	a4,0xf
    800027e6:	d7a72703          	lw	a4,-646(a4) # 8001155c <sb+0xc>
    800027ea:	4785                	li	a5,1
    800027ec:	04e7fa63          	bgeu	a5,a4,80002840 <ialloc+0x74>
    800027f0:	8aaa                	mv	s5,a0
    800027f2:	8bae                	mv	s7,a1
    800027f4:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800027f6:	0000fa17          	auipc	s4,0xf
    800027fa:	d5aa0a13          	addi	s4,s4,-678 # 80011550 <sb>
    800027fe:	00048b1b          	sext.w	s6,s1
    80002802:	0044d593          	srli	a1,s1,0x4
    80002806:	018a2783          	lw	a5,24(s4)
    8000280a:	9dbd                	addw	a1,a1,a5
    8000280c:	8556                	mv	a0,s5
    8000280e:	00000097          	auipc	ra,0x0
    80002812:	944080e7          	jalr	-1724(ra) # 80002152 <bread>
    80002816:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80002818:	05850993          	addi	s3,a0,88
    8000281c:	00f4f793          	andi	a5,s1,15
    80002820:	079a                	slli	a5,a5,0x6
    80002822:	99be                	add	s3,s3,a5
    if (dip->type == 0) {  // a free inode
    80002824:	00099783          	lh	a5,0(s3)
    80002828:	c3a1                	beqz	a5,80002868 <ialloc+0x9c>
    brelse(bp);
    8000282a:	00000097          	auipc	ra,0x0
    8000282e:	a58080e7          	jalr	-1448(ra) # 80002282 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80002832:	0485                	addi	s1,s1,1
    80002834:	00ca2703          	lw	a4,12(s4)
    80002838:	0004879b          	sext.w	a5,s1
    8000283c:	fce7e1e3          	bltu	a5,a4,800027fe <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002840:	00006517          	auipc	a0,0x6
    80002844:	cc850513          	addi	a0,a0,-824 # 80008508 <syscalls+0x168>
    80002848:	00004097          	auipc	ra,0x4
    8000284c:	e86080e7          	jalr	-378(ra) # 800066ce <printf>
  return 0;
    80002850:	4501                	li	a0,0
}
    80002852:	60a6                	ld	ra,72(sp)
    80002854:	6406                	ld	s0,64(sp)
    80002856:	74e2                	ld	s1,56(sp)
    80002858:	7942                	ld	s2,48(sp)
    8000285a:	79a2                	ld	s3,40(sp)
    8000285c:	7a02                	ld	s4,32(sp)
    8000285e:	6ae2                	ld	s5,24(sp)
    80002860:	6b42                	ld	s6,16(sp)
    80002862:	6ba2                	ld	s7,8(sp)
    80002864:	6161                	addi	sp,sp,80
    80002866:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002868:	04000613          	li	a2,64
    8000286c:	4581                	li	a1,0
    8000286e:	854e                	mv	a0,s3
    80002870:	ffffe097          	auipc	ra,0xffffe
    80002874:	806080e7          	jalr	-2042(ra) # 80000076 <memset>
      dip->type = type;
    80002878:	01799023          	sh	s7,0(s3)
      log_write(bp);  // mark it allocated on the disk
    8000287c:	854a                	mv	a0,s2
    8000287e:	00001097          	auipc	ra,0x1
    80002882:	c8e080e7          	jalr	-882(ra) # 8000350c <log_write>
      brelse(bp);
    80002886:	854a                	mv	a0,s2
    80002888:	00000097          	auipc	ra,0x0
    8000288c:	9fa080e7          	jalr	-1542(ra) # 80002282 <brelse>
      return iget(dev, inum);
    80002890:	85da                	mv	a1,s6
    80002892:	8556                	mv	a0,s5
    80002894:	00000097          	auipc	ra,0x0
    80002898:	d9c080e7          	jalr	-612(ra) # 80002630 <iget>
    8000289c:	bf5d                	j	80002852 <ialloc+0x86>

000000008000289e <iupdate>:
void iupdate(struct inode *ip) {
    8000289e:	1101                	addi	sp,sp,-32
    800028a0:	ec06                	sd	ra,24(sp)
    800028a2:	e822                	sd	s0,16(sp)
    800028a4:	e426                	sd	s1,8(sp)
    800028a6:	e04a                	sd	s2,0(sp)
    800028a8:	1000                	addi	s0,sp,32
    800028aa:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800028ac:	415c                	lw	a5,4(a0)
    800028ae:	0047d79b          	srliw	a5,a5,0x4
    800028b2:	0000f597          	auipc	a1,0xf
    800028b6:	cb65a583          	lw	a1,-842(a1) # 80011568 <sb+0x18>
    800028ba:	9dbd                	addw	a1,a1,a5
    800028bc:	4108                	lw	a0,0(a0)
    800028be:	00000097          	auipc	ra,0x0
    800028c2:	894080e7          	jalr	-1900(ra) # 80002152 <bread>
    800028c6:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    800028c8:	05850793          	addi	a5,a0,88
    800028cc:	40d8                	lw	a4,4(s1)
    800028ce:	8b3d                	andi	a4,a4,15
    800028d0:	071a                	slli	a4,a4,0x6
    800028d2:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800028d4:	04449703          	lh	a4,68(s1)
    800028d8:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800028dc:	04649703          	lh	a4,70(s1)
    800028e0:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800028e4:	04849703          	lh	a4,72(s1)
    800028e8:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800028ec:	04a49703          	lh	a4,74(s1)
    800028f0:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800028f4:	44f8                	lw	a4,76(s1)
    800028f6:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800028f8:	03400613          	li	a2,52
    800028fc:	05048593          	addi	a1,s1,80
    80002900:	00c78513          	addi	a0,a5,12
    80002904:	ffffd097          	auipc	ra,0xffffd
    80002908:	7ce080e7          	jalr	1998(ra) # 800000d2 <memmove>
  log_write(bp);
    8000290c:	854a                	mv	a0,s2
    8000290e:	00001097          	auipc	ra,0x1
    80002912:	bfe080e7          	jalr	-1026(ra) # 8000350c <log_write>
  brelse(bp);
    80002916:	854a                	mv	a0,s2
    80002918:	00000097          	auipc	ra,0x0
    8000291c:	96a080e7          	jalr	-1686(ra) # 80002282 <brelse>
}
    80002920:	60e2                	ld	ra,24(sp)
    80002922:	6442                	ld	s0,16(sp)
    80002924:	64a2                	ld	s1,8(sp)
    80002926:	6902                	ld	s2,0(sp)
    80002928:	6105                	addi	sp,sp,32
    8000292a:	8082                	ret

000000008000292c <idup>:
struct inode *idup(struct inode *ip) {
    8000292c:	1101                	addi	sp,sp,-32
    8000292e:	ec06                	sd	ra,24(sp)
    80002930:	e822                	sd	s0,16(sp)
    80002932:	e426                	sd	s1,8(sp)
    80002934:	1000                	addi	s0,sp,32
    80002936:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002938:	0000f517          	auipc	a0,0xf
    8000293c:	c3850513          	addi	a0,a0,-968 # 80011570 <itable>
    80002940:	00004097          	auipc	ra,0x4
    80002944:	27c080e7          	jalr	636(ra) # 80006bbc <acquire>
  ip->ref++;
    80002948:	449c                	lw	a5,8(s1)
    8000294a:	2785                	addiw	a5,a5,1
    8000294c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000294e:	0000f517          	auipc	a0,0xf
    80002952:	c2250513          	addi	a0,a0,-990 # 80011570 <itable>
    80002956:	00004097          	auipc	ra,0x4
    8000295a:	314080e7          	jalr	788(ra) # 80006c6a <release>
}
    8000295e:	8526                	mv	a0,s1
    80002960:	60e2                	ld	ra,24(sp)
    80002962:	6442                	ld	s0,16(sp)
    80002964:	64a2                	ld	s1,8(sp)
    80002966:	6105                	addi	sp,sp,32
    80002968:	8082                	ret

000000008000296a <ilock>:
void ilock(struct inode *ip) {
    8000296a:	1101                	addi	sp,sp,-32
    8000296c:	ec06                	sd	ra,24(sp)
    8000296e:	e822                	sd	s0,16(sp)
    80002970:	e426                	sd	s1,8(sp)
    80002972:	e04a                	sd	s2,0(sp)
    80002974:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1) panic("ilock");
    80002976:	c115                	beqz	a0,8000299a <ilock+0x30>
    80002978:	84aa                	mv	s1,a0
    8000297a:	451c                	lw	a5,8(a0)
    8000297c:	00f05f63          	blez	a5,8000299a <ilock+0x30>
  acquiresleep(&ip->lock);
    80002980:	0541                	addi	a0,a0,16
    80002982:	00001097          	auipc	ra,0x1
    80002986:	ca8080e7          	jalr	-856(ra) # 8000362a <acquiresleep>
  if (ip->valid == 0) {
    8000298a:	40bc                	lw	a5,64(s1)
    8000298c:	cf99                	beqz	a5,800029aa <ilock+0x40>
}
    8000298e:	60e2                	ld	ra,24(sp)
    80002990:	6442                	ld	s0,16(sp)
    80002992:	64a2                	ld	s1,8(sp)
    80002994:	6902                	ld	s2,0(sp)
    80002996:	6105                	addi	sp,sp,32
    80002998:	8082                	ret
  if (ip == 0 || ip->ref < 1) panic("ilock");
    8000299a:	00006517          	auipc	a0,0x6
    8000299e:	b8650513          	addi	a0,a0,-1146 # 80008520 <syscalls+0x180>
    800029a2:	00004097          	auipc	ra,0x4
    800029a6:	ce2080e7          	jalr	-798(ra) # 80006684 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800029aa:	40dc                	lw	a5,4(s1)
    800029ac:	0047d79b          	srliw	a5,a5,0x4
    800029b0:	0000f597          	auipc	a1,0xf
    800029b4:	bb85a583          	lw	a1,-1096(a1) # 80011568 <sb+0x18>
    800029b8:	9dbd                	addw	a1,a1,a5
    800029ba:	4088                	lw	a0,0(s1)
    800029bc:	fffff097          	auipc	ra,0xfffff
    800029c0:	796080e7          	jalr	1942(ra) # 80002152 <bread>
    800029c4:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    800029c6:	05850593          	addi	a1,a0,88
    800029ca:	40dc                	lw	a5,4(s1)
    800029cc:	8bbd                	andi	a5,a5,15
    800029ce:	079a                	slli	a5,a5,0x6
    800029d0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800029d2:	00059783          	lh	a5,0(a1)
    800029d6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800029da:	00259783          	lh	a5,2(a1)
    800029de:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800029e2:	00459783          	lh	a5,4(a1)
    800029e6:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800029ea:	00659783          	lh	a5,6(a1)
    800029ee:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800029f2:	459c                	lw	a5,8(a1)
    800029f4:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800029f6:	03400613          	li	a2,52
    800029fa:	05b1                	addi	a1,a1,12
    800029fc:	05048513          	addi	a0,s1,80
    80002a00:	ffffd097          	auipc	ra,0xffffd
    80002a04:	6d2080e7          	jalr	1746(ra) # 800000d2 <memmove>
    brelse(bp);
    80002a08:	854a                	mv	a0,s2
    80002a0a:	00000097          	auipc	ra,0x0
    80002a0e:	878080e7          	jalr	-1928(ra) # 80002282 <brelse>
    ip->valid = 1;
    80002a12:	4785                	li	a5,1
    80002a14:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0) panic("ilock: no type");
    80002a16:	04449783          	lh	a5,68(s1)
    80002a1a:	fbb5                	bnez	a5,8000298e <ilock+0x24>
    80002a1c:	00006517          	auipc	a0,0x6
    80002a20:	b0c50513          	addi	a0,a0,-1268 # 80008528 <syscalls+0x188>
    80002a24:	00004097          	auipc	ra,0x4
    80002a28:	c60080e7          	jalr	-928(ra) # 80006684 <panic>

0000000080002a2c <iunlock>:
void iunlock(struct inode *ip) {
    80002a2c:	1101                	addi	sp,sp,-32
    80002a2e:	ec06                	sd	ra,24(sp)
    80002a30:	e822                	sd	s0,16(sp)
    80002a32:	e426                	sd	s1,8(sp)
    80002a34:	e04a                	sd	s2,0(sp)
    80002a36:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
    80002a38:	c905                	beqz	a0,80002a68 <iunlock+0x3c>
    80002a3a:	84aa                	mv	s1,a0
    80002a3c:	01050913          	addi	s2,a0,16
    80002a40:	854a                	mv	a0,s2
    80002a42:	00001097          	auipc	ra,0x1
    80002a46:	c82080e7          	jalr	-894(ra) # 800036c4 <holdingsleep>
    80002a4a:	cd19                	beqz	a0,80002a68 <iunlock+0x3c>
    80002a4c:	449c                	lw	a5,8(s1)
    80002a4e:	00f05d63          	blez	a5,80002a68 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002a52:	854a                	mv	a0,s2
    80002a54:	00001097          	auipc	ra,0x1
    80002a58:	c2c080e7          	jalr	-980(ra) # 80003680 <releasesleep>
}
    80002a5c:	60e2                	ld	ra,24(sp)
    80002a5e:	6442                	ld	s0,16(sp)
    80002a60:	64a2                	ld	s1,8(sp)
    80002a62:	6902                	ld	s2,0(sp)
    80002a64:	6105                	addi	sp,sp,32
    80002a66:	8082                	ret
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
    80002a68:	00006517          	auipc	a0,0x6
    80002a6c:	ad050513          	addi	a0,a0,-1328 # 80008538 <syscalls+0x198>
    80002a70:	00004097          	auipc	ra,0x4
    80002a74:	c14080e7          	jalr	-1004(ra) # 80006684 <panic>

0000000080002a78 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip) {
    80002a78:	7179                	addi	sp,sp,-48
    80002a7a:	f406                	sd	ra,40(sp)
    80002a7c:	f022                	sd	s0,32(sp)
    80002a7e:	ec26                	sd	s1,24(sp)
    80002a80:	e84a                	sd	s2,16(sp)
    80002a82:	e44e                	sd	s3,8(sp)
    80002a84:	e052                	sd	s4,0(sp)
    80002a86:	1800                	addi	s0,sp,48
    80002a88:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    80002a8a:	05050493          	addi	s1,a0,80
    80002a8e:	08050913          	addi	s2,a0,128
    80002a92:	a021                	j	80002a9a <itrunc+0x22>
    80002a94:	0491                	addi	s1,s1,4
    80002a96:	01248d63          	beq	s1,s2,80002ab0 <itrunc+0x38>
    if (ip->addrs[i]) {
    80002a9a:	408c                	lw	a1,0(s1)
    80002a9c:	dde5                	beqz	a1,80002a94 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002a9e:	0009a503          	lw	a0,0(s3)
    80002aa2:	00000097          	auipc	ra,0x0
    80002aa6:	8f6080e7          	jalr	-1802(ra) # 80002398 <bfree>
      ip->addrs[i] = 0;
    80002aaa:	0004a023          	sw	zero,0(s1)
    80002aae:	b7dd                	j	80002a94 <itrunc+0x1c>
    }
  }

  if (ip->addrs[NDIRECT]) {
    80002ab0:	0809a583          	lw	a1,128(s3)
    80002ab4:	e185                	bnez	a1,80002ad4 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002ab6:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002aba:	854e                	mv	a0,s3
    80002abc:	00000097          	auipc	ra,0x0
    80002ac0:	de2080e7          	jalr	-542(ra) # 8000289e <iupdate>
}
    80002ac4:	70a2                	ld	ra,40(sp)
    80002ac6:	7402                	ld	s0,32(sp)
    80002ac8:	64e2                	ld	s1,24(sp)
    80002aca:	6942                	ld	s2,16(sp)
    80002acc:	69a2                	ld	s3,8(sp)
    80002ace:	6a02                	ld	s4,0(sp)
    80002ad0:	6145                	addi	sp,sp,48
    80002ad2:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ad4:	0009a503          	lw	a0,0(s3)
    80002ad8:	fffff097          	auipc	ra,0xfffff
    80002adc:	67a080e7          	jalr	1658(ra) # 80002152 <bread>
    80002ae0:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    80002ae2:	05850493          	addi	s1,a0,88
    80002ae6:	45850913          	addi	s2,a0,1112
    80002aea:	a021                	j	80002af2 <itrunc+0x7a>
    80002aec:	0491                	addi	s1,s1,4
    80002aee:	01248b63          	beq	s1,s2,80002b04 <itrunc+0x8c>
      if (a[j]) bfree(ip->dev, a[j]);
    80002af2:	408c                	lw	a1,0(s1)
    80002af4:	dde5                	beqz	a1,80002aec <itrunc+0x74>
    80002af6:	0009a503          	lw	a0,0(s3)
    80002afa:	00000097          	auipc	ra,0x0
    80002afe:	89e080e7          	jalr	-1890(ra) # 80002398 <bfree>
    80002b02:	b7ed                	j	80002aec <itrunc+0x74>
    brelse(bp);
    80002b04:	8552                	mv	a0,s4
    80002b06:	fffff097          	auipc	ra,0xfffff
    80002b0a:	77c080e7          	jalr	1916(ra) # 80002282 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002b0e:	0809a583          	lw	a1,128(s3)
    80002b12:	0009a503          	lw	a0,0(s3)
    80002b16:	00000097          	auipc	ra,0x0
    80002b1a:	882080e7          	jalr	-1918(ra) # 80002398 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002b1e:	0809a023          	sw	zero,128(s3)
    80002b22:	bf51                	j	80002ab6 <itrunc+0x3e>

0000000080002b24 <iput>:
void iput(struct inode *ip) {
    80002b24:	1101                	addi	sp,sp,-32
    80002b26:	ec06                	sd	ra,24(sp)
    80002b28:	e822                	sd	s0,16(sp)
    80002b2a:	e426                	sd	s1,8(sp)
    80002b2c:	e04a                	sd	s2,0(sp)
    80002b2e:	1000                	addi	s0,sp,32
    80002b30:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b32:	0000f517          	auipc	a0,0xf
    80002b36:	a3e50513          	addi	a0,a0,-1474 # 80011570 <itable>
    80002b3a:	00004097          	auipc	ra,0x4
    80002b3e:	082080e7          	jalr	130(ra) # 80006bbc <acquire>
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002b42:	4498                	lw	a4,8(s1)
    80002b44:	4785                	li	a5,1
    80002b46:	02f70363          	beq	a4,a5,80002b6c <iput+0x48>
  ip->ref--;
    80002b4a:	449c                	lw	a5,8(s1)
    80002b4c:	37fd                	addiw	a5,a5,-1
    80002b4e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b50:	0000f517          	auipc	a0,0xf
    80002b54:	a2050513          	addi	a0,a0,-1504 # 80011570 <itable>
    80002b58:	00004097          	auipc	ra,0x4
    80002b5c:	112080e7          	jalr	274(ra) # 80006c6a <release>
}
    80002b60:	60e2                	ld	ra,24(sp)
    80002b62:	6442                	ld	s0,16(sp)
    80002b64:	64a2                	ld	s1,8(sp)
    80002b66:	6902                	ld	s2,0(sp)
    80002b68:	6105                	addi	sp,sp,32
    80002b6a:	8082                	ret
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80002b6c:	40bc                	lw	a5,64(s1)
    80002b6e:	dff1                	beqz	a5,80002b4a <iput+0x26>
    80002b70:	04a49783          	lh	a5,74(s1)
    80002b74:	fbf9                	bnez	a5,80002b4a <iput+0x26>
    acquiresleep(&ip->lock);
    80002b76:	01048913          	addi	s2,s1,16
    80002b7a:	854a                	mv	a0,s2
    80002b7c:	00001097          	auipc	ra,0x1
    80002b80:	aae080e7          	jalr	-1362(ra) # 8000362a <acquiresleep>
    release(&itable.lock);
    80002b84:	0000f517          	auipc	a0,0xf
    80002b88:	9ec50513          	addi	a0,a0,-1556 # 80011570 <itable>
    80002b8c:	00004097          	auipc	ra,0x4
    80002b90:	0de080e7          	jalr	222(ra) # 80006c6a <release>
    itrunc(ip);
    80002b94:	8526                	mv	a0,s1
    80002b96:	00000097          	auipc	ra,0x0
    80002b9a:	ee2080e7          	jalr	-286(ra) # 80002a78 <itrunc>
    ip->type = 0;
    80002b9e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002ba2:	8526                	mv	a0,s1
    80002ba4:	00000097          	auipc	ra,0x0
    80002ba8:	cfa080e7          	jalr	-774(ra) # 8000289e <iupdate>
    ip->valid = 0;
    80002bac:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002bb0:	854a                	mv	a0,s2
    80002bb2:	00001097          	auipc	ra,0x1
    80002bb6:	ace080e7          	jalr	-1330(ra) # 80003680 <releasesleep>
    acquire(&itable.lock);
    80002bba:	0000f517          	auipc	a0,0xf
    80002bbe:	9b650513          	addi	a0,a0,-1610 # 80011570 <itable>
    80002bc2:	00004097          	auipc	ra,0x4
    80002bc6:	ffa080e7          	jalr	-6(ra) # 80006bbc <acquire>
    80002bca:	b741                	j	80002b4a <iput+0x26>

0000000080002bcc <iunlockput>:
void iunlockput(struct inode *ip) {
    80002bcc:	1101                	addi	sp,sp,-32
    80002bce:	ec06                	sd	ra,24(sp)
    80002bd0:	e822                	sd	s0,16(sp)
    80002bd2:	e426                	sd	s1,8(sp)
    80002bd4:	1000                	addi	s0,sp,32
    80002bd6:	84aa                	mv	s1,a0
  iunlock(ip);
    80002bd8:	00000097          	auipc	ra,0x0
    80002bdc:	e54080e7          	jalr	-428(ra) # 80002a2c <iunlock>
  iput(ip);
    80002be0:	8526                	mv	a0,s1
    80002be2:	00000097          	auipc	ra,0x0
    80002be6:	f42080e7          	jalr	-190(ra) # 80002b24 <iput>
}
    80002bea:	60e2                	ld	ra,24(sp)
    80002bec:	6442                	ld	s0,16(sp)
    80002bee:	64a2                	ld	s1,8(sp)
    80002bf0:	6105                	addi	sp,sp,32
    80002bf2:	8082                	ret

0000000080002bf4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st) {
    80002bf4:	1141                	addi	sp,sp,-16
    80002bf6:	e422                	sd	s0,8(sp)
    80002bf8:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002bfa:	411c                	lw	a5,0(a0)
    80002bfc:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002bfe:	415c                	lw	a5,4(a0)
    80002c00:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002c02:	04451783          	lh	a5,68(a0)
    80002c06:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002c0a:	04a51783          	lh	a5,74(a0)
    80002c0e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002c12:	04c56783          	lwu	a5,76(a0)
    80002c16:	e99c                	sd	a5,16(a1)
}
    80002c18:	6422                	ld	s0,8(sp)
    80002c1a:	0141                	addi	sp,sp,16
    80002c1c:	8082                	ret

0000000080002c1e <readi>:
// otherwise, dst is a kernel address.
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off) return 0;
    80002c1e:	457c                	lw	a5,76(a0)
    80002c20:	0ed7e963          	bltu	a5,a3,80002d12 <readi+0xf4>
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n) {
    80002c24:	7159                	addi	sp,sp,-112
    80002c26:	f486                	sd	ra,104(sp)
    80002c28:	f0a2                	sd	s0,96(sp)
    80002c2a:	eca6                	sd	s1,88(sp)
    80002c2c:	e8ca                	sd	s2,80(sp)
    80002c2e:	e4ce                	sd	s3,72(sp)
    80002c30:	e0d2                	sd	s4,64(sp)
    80002c32:	fc56                	sd	s5,56(sp)
    80002c34:	f85a                	sd	s6,48(sp)
    80002c36:	f45e                	sd	s7,40(sp)
    80002c38:	f062                	sd	s8,32(sp)
    80002c3a:	ec66                	sd	s9,24(sp)
    80002c3c:	e86a                	sd	s10,16(sp)
    80002c3e:	e46e                	sd	s11,8(sp)
    80002c40:	1880                	addi	s0,sp,112
    80002c42:	8b2a                	mv	s6,a0
    80002c44:	8bae                	mv	s7,a1
    80002c46:	8a32                	mv	s4,a2
    80002c48:	84b6                	mv	s1,a3
    80002c4a:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off) return 0;
    80002c4c:	9f35                	addw	a4,a4,a3
    80002c4e:	4501                	li	a0,0
    80002c50:	0ad76063          	bltu	a4,a3,80002cf0 <readi+0xd2>
  if (off + n > ip->size) n = ip->size - off;
    80002c54:	00e7f463          	bgeu	a5,a4,80002c5c <readi+0x3e>
    80002c58:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80002c5c:	0a0a8963          	beqz	s5,80002d0e <readi+0xf0>
    80002c60:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0) break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80002c62:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002c66:	5c7d                	li	s8,-1
    80002c68:	a82d                	j	80002ca2 <readi+0x84>
    80002c6a:	020d1d93          	slli	s11,s10,0x20
    80002c6e:	020ddd93          	srli	s11,s11,0x20
    80002c72:	05890613          	addi	a2,s2,88
    80002c76:	86ee                	mv	a3,s11
    80002c78:	963a                	add	a2,a2,a4
    80002c7a:	85d2                	mv	a1,s4
    80002c7c:	855e                	mv	a0,s7
    80002c7e:	fffff097          	auipc	ra,0xfffff
    80002c82:	b16080e7          	jalr	-1258(ra) # 80001794 <either_copyout>
    80002c86:	05850d63          	beq	a0,s8,80002ce0 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002c8a:	854a                	mv	a0,s2
    80002c8c:	fffff097          	auipc	ra,0xfffff
    80002c90:	5f6080e7          	jalr	1526(ra) # 80002282 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80002c94:	013d09bb          	addw	s3,s10,s3
    80002c98:	009d04bb          	addw	s1,s10,s1
    80002c9c:	9a6e                	add	s4,s4,s11
    80002c9e:	0559f763          	bgeu	s3,s5,80002cec <readi+0xce>
    uint addr = bmap(ip, off / BSIZE);
    80002ca2:	00a4d59b          	srliw	a1,s1,0xa
    80002ca6:	855a                	mv	a0,s6
    80002ca8:	00000097          	auipc	ra,0x0
    80002cac:	89e080e7          	jalr	-1890(ra) # 80002546 <bmap>
    80002cb0:	0005059b          	sext.w	a1,a0
    if (addr == 0) break;
    80002cb4:	cd85                	beqz	a1,80002cec <readi+0xce>
    bp = bread(ip->dev, addr);
    80002cb6:	000b2503          	lw	a0,0(s6)
    80002cba:	fffff097          	auipc	ra,0xfffff
    80002cbe:	498080e7          	jalr	1176(ra) # 80002152 <bread>
    80002cc2:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80002cc4:	3ff4f713          	andi	a4,s1,1023
    80002cc8:	40ec87bb          	subw	a5,s9,a4
    80002ccc:	413a86bb          	subw	a3,s5,s3
    80002cd0:	8d3e                	mv	s10,a5
    80002cd2:	2781                	sext.w	a5,a5
    80002cd4:	0006861b          	sext.w	a2,a3
    80002cd8:	f8f679e3          	bgeu	a2,a5,80002c6a <readi+0x4c>
    80002cdc:	8d36                	mv	s10,a3
    80002cde:	b771                	j	80002c6a <readi+0x4c>
      brelse(bp);
    80002ce0:	854a                	mv	a0,s2
    80002ce2:	fffff097          	auipc	ra,0xfffff
    80002ce6:	5a0080e7          	jalr	1440(ra) # 80002282 <brelse>
      tot = -1;
    80002cea:	59fd                	li	s3,-1
  }
  return tot;
    80002cec:	0009851b          	sext.w	a0,s3
}
    80002cf0:	70a6                	ld	ra,104(sp)
    80002cf2:	7406                	ld	s0,96(sp)
    80002cf4:	64e6                	ld	s1,88(sp)
    80002cf6:	6946                	ld	s2,80(sp)
    80002cf8:	69a6                	ld	s3,72(sp)
    80002cfa:	6a06                	ld	s4,64(sp)
    80002cfc:	7ae2                	ld	s5,56(sp)
    80002cfe:	7b42                	ld	s6,48(sp)
    80002d00:	7ba2                	ld	s7,40(sp)
    80002d02:	7c02                	ld	s8,32(sp)
    80002d04:	6ce2                	ld	s9,24(sp)
    80002d06:	6d42                	ld	s10,16(sp)
    80002d08:	6da2                	ld	s11,8(sp)
    80002d0a:	6165                	addi	sp,sp,112
    80002d0c:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80002d0e:	89d6                	mv	s3,s5
    80002d10:	bff1                	j	80002cec <readi+0xce>
  if (off > ip->size || off + n < off) return 0;
    80002d12:	4501                	li	a0,0
}
    80002d14:	8082                	ret

0000000080002d16 <writei>:
// there was an error of some kind.
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off) return -1;
    80002d16:	457c                	lw	a5,76(a0)
    80002d18:	10d7e863          	bltu	a5,a3,80002e28 <writei+0x112>
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n) {
    80002d1c:	7159                	addi	sp,sp,-112
    80002d1e:	f486                	sd	ra,104(sp)
    80002d20:	f0a2                	sd	s0,96(sp)
    80002d22:	eca6                	sd	s1,88(sp)
    80002d24:	e8ca                	sd	s2,80(sp)
    80002d26:	e4ce                	sd	s3,72(sp)
    80002d28:	e0d2                	sd	s4,64(sp)
    80002d2a:	fc56                	sd	s5,56(sp)
    80002d2c:	f85a                	sd	s6,48(sp)
    80002d2e:	f45e                	sd	s7,40(sp)
    80002d30:	f062                	sd	s8,32(sp)
    80002d32:	ec66                	sd	s9,24(sp)
    80002d34:	e86a                	sd	s10,16(sp)
    80002d36:	e46e                	sd	s11,8(sp)
    80002d38:	1880                	addi	s0,sp,112
    80002d3a:	8aaa                	mv	s5,a0
    80002d3c:	8bae                	mv	s7,a1
    80002d3e:	8a32                	mv	s4,a2
    80002d40:	8936                	mv	s2,a3
    80002d42:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off) return -1;
    80002d44:	00e687bb          	addw	a5,a3,a4
    80002d48:	0ed7e263          	bltu	a5,a3,80002e2c <writei+0x116>
  if (off + n > MAXFILE * BSIZE) return -1;
    80002d4c:	00043737          	lui	a4,0x43
    80002d50:	0ef76063          	bltu	a4,a5,80002e30 <writei+0x11a>

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80002d54:	0c0b0863          	beqz	s6,80002e24 <writei+0x10e>
    80002d58:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0) break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80002d5a:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002d5e:	5c7d                	li	s8,-1
    80002d60:	a091                	j	80002da4 <writei+0x8e>
    80002d62:	020d1d93          	slli	s11,s10,0x20
    80002d66:	020ddd93          	srli	s11,s11,0x20
    80002d6a:	05848513          	addi	a0,s1,88
    80002d6e:	86ee                	mv	a3,s11
    80002d70:	8652                	mv	a2,s4
    80002d72:	85de                	mv	a1,s7
    80002d74:	953a                	add	a0,a0,a4
    80002d76:	fffff097          	auipc	ra,0xfffff
    80002d7a:	a74080e7          	jalr	-1420(ra) # 800017ea <either_copyin>
    80002d7e:	07850263          	beq	a0,s8,80002de2 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002d82:	8526                	mv	a0,s1
    80002d84:	00000097          	auipc	ra,0x0
    80002d88:	788080e7          	jalr	1928(ra) # 8000350c <log_write>
    brelse(bp);
    80002d8c:	8526                	mv	a0,s1
    80002d8e:	fffff097          	auipc	ra,0xfffff
    80002d92:	4f4080e7          	jalr	1268(ra) # 80002282 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80002d96:	013d09bb          	addw	s3,s10,s3
    80002d9a:	012d093b          	addw	s2,s10,s2
    80002d9e:	9a6e                	add	s4,s4,s11
    80002da0:	0569f663          	bgeu	s3,s6,80002dec <writei+0xd6>
    uint addr = bmap(ip, off / BSIZE);
    80002da4:	00a9559b          	srliw	a1,s2,0xa
    80002da8:	8556                	mv	a0,s5
    80002daa:	fffff097          	auipc	ra,0xfffff
    80002dae:	79c080e7          	jalr	1948(ra) # 80002546 <bmap>
    80002db2:	0005059b          	sext.w	a1,a0
    if (addr == 0) break;
    80002db6:	c99d                	beqz	a1,80002dec <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002db8:	000aa503          	lw	a0,0(s5)
    80002dbc:	fffff097          	auipc	ra,0xfffff
    80002dc0:	396080e7          	jalr	918(ra) # 80002152 <bread>
    80002dc4:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80002dc6:	3ff97713          	andi	a4,s2,1023
    80002dca:	40ec87bb          	subw	a5,s9,a4
    80002dce:	413b06bb          	subw	a3,s6,s3
    80002dd2:	8d3e                	mv	s10,a5
    80002dd4:	2781                	sext.w	a5,a5
    80002dd6:	0006861b          	sext.w	a2,a3
    80002dda:	f8f674e3          	bgeu	a2,a5,80002d62 <writei+0x4c>
    80002dde:	8d36                	mv	s10,a3
    80002de0:	b749                	j	80002d62 <writei+0x4c>
      brelse(bp);
    80002de2:	8526                	mv	a0,s1
    80002de4:	fffff097          	auipc	ra,0xfffff
    80002de8:	49e080e7          	jalr	1182(ra) # 80002282 <brelse>
  }

  if (off > ip->size) ip->size = off;
    80002dec:	04caa783          	lw	a5,76(s5)
    80002df0:	0127f463          	bgeu	a5,s2,80002df8 <writei+0xe2>
    80002df4:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002df8:	8556                	mv	a0,s5
    80002dfa:	00000097          	auipc	ra,0x0
    80002dfe:	aa4080e7          	jalr	-1372(ra) # 8000289e <iupdate>

  return tot;
    80002e02:	0009851b          	sext.w	a0,s3
}
    80002e06:	70a6                	ld	ra,104(sp)
    80002e08:	7406                	ld	s0,96(sp)
    80002e0a:	64e6                	ld	s1,88(sp)
    80002e0c:	6946                	ld	s2,80(sp)
    80002e0e:	69a6                	ld	s3,72(sp)
    80002e10:	6a06                	ld	s4,64(sp)
    80002e12:	7ae2                	ld	s5,56(sp)
    80002e14:	7b42                	ld	s6,48(sp)
    80002e16:	7ba2                	ld	s7,40(sp)
    80002e18:	7c02                	ld	s8,32(sp)
    80002e1a:	6ce2                	ld	s9,24(sp)
    80002e1c:	6d42                	ld	s10,16(sp)
    80002e1e:	6da2                	ld	s11,8(sp)
    80002e20:	6165                	addi	sp,sp,112
    80002e22:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80002e24:	89da                	mv	s3,s6
    80002e26:	bfc9                	j	80002df8 <writei+0xe2>
  if (off > ip->size || off + n < off) return -1;
    80002e28:	557d                	li	a0,-1
}
    80002e2a:	8082                	ret
  if (off > ip->size || off + n < off) return -1;
    80002e2c:	557d                	li	a0,-1
    80002e2e:	bfe1                	j	80002e06 <writei+0xf0>
  if (off + n > MAXFILE * BSIZE) return -1;
    80002e30:	557d                	li	a0,-1
    80002e32:	bfd1                	j	80002e06 <writei+0xf0>

0000000080002e34 <namecmp>:

// Directories

int namecmp(const char *s, const char *t) { return strncmp(s, t, DIRSIZ); }
    80002e34:	1141                	addi	sp,sp,-16
    80002e36:	e406                	sd	ra,8(sp)
    80002e38:	e022                	sd	s0,0(sp)
    80002e3a:	0800                	addi	s0,sp,16
    80002e3c:	4639                	li	a2,14
    80002e3e:	ffffd097          	auipc	ra,0xffffd
    80002e42:	308080e7          	jalr	776(ra) # 80000146 <strncmp>
    80002e46:	60a2                	ld	ra,8(sp)
    80002e48:	6402                	ld	s0,0(sp)
    80002e4a:	0141                	addi	sp,sp,16
    80002e4c:	8082                	ret

0000000080002e4e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *dirlookup(struct inode *dp, char *name, uint *poff) {
    80002e4e:	7139                	addi	sp,sp,-64
    80002e50:	fc06                	sd	ra,56(sp)
    80002e52:	f822                	sd	s0,48(sp)
    80002e54:	f426                	sd	s1,40(sp)
    80002e56:	f04a                	sd	s2,32(sp)
    80002e58:	ec4e                	sd	s3,24(sp)
    80002e5a:	e852                	sd	s4,16(sp)
    80002e5c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR) panic("dirlookup not DIR");
    80002e5e:	04451703          	lh	a4,68(a0)
    80002e62:	4785                	li	a5,1
    80002e64:	00f71a63          	bne	a4,a5,80002e78 <dirlookup+0x2a>
    80002e68:	892a                	mv	s2,a0
    80002e6a:	89ae                	mv	s3,a1
    80002e6c:	8a32                	mv	s4,a2

  for (off = 0; off < dp->size; off += sizeof(de)) {
    80002e6e:	457c                	lw	a5,76(a0)
    80002e70:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002e72:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80002e74:	e79d                	bnez	a5,80002ea2 <dirlookup+0x54>
    80002e76:	a8a5                	j	80002eee <dirlookup+0xa0>
  if (dp->type != T_DIR) panic("dirlookup not DIR");
    80002e78:	00005517          	auipc	a0,0x5
    80002e7c:	6c850513          	addi	a0,a0,1736 # 80008540 <syscalls+0x1a0>
    80002e80:	00004097          	auipc	ra,0x4
    80002e84:	804080e7          	jalr	-2044(ra) # 80006684 <panic>
      panic("dirlookup read");
    80002e88:	00005517          	auipc	a0,0x5
    80002e8c:	6d050513          	addi	a0,a0,1744 # 80008558 <syscalls+0x1b8>
    80002e90:	00003097          	auipc	ra,0x3
    80002e94:	7f4080e7          	jalr	2036(ra) # 80006684 <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80002e98:	24c1                	addiw	s1,s1,16
    80002e9a:	04c92783          	lw	a5,76(s2)
    80002e9e:	04f4f763          	bgeu	s1,a5,80002eec <dirlookup+0x9e>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002ea2:	4741                	li	a4,16
    80002ea4:	86a6                	mv	a3,s1
    80002ea6:	fc040613          	addi	a2,s0,-64
    80002eaa:	4581                	li	a1,0
    80002eac:	854a                	mv	a0,s2
    80002eae:	00000097          	auipc	ra,0x0
    80002eb2:	d70080e7          	jalr	-656(ra) # 80002c1e <readi>
    80002eb6:	47c1                	li	a5,16
    80002eb8:	fcf518e3          	bne	a0,a5,80002e88 <dirlookup+0x3a>
    if (de.inum == 0) continue;
    80002ebc:	fc045783          	lhu	a5,-64(s0)
    80002ec0:	dfe1                	beqz	a5,80002e98 <dirlookup+0x4a>
    if (namecmp(name, de.name) == 0) {
    80002ec2:	fc240593          	addi	a1,s0,-62
    80002ec6:	854e                	mv	a0,s3
    80002ec8:	00000097          	auipc	ra,0x0
    80002ecc:	f6c080e7          	jalr	-148(ra) # 80002e34 <namecmp>
    80002ed0:	f561                	bnez	a0,80002e98 <dirlookup+0x4a>
      if (poff) *poff = off;
    80002ed2:	000a0463          	beqz	s4,80002eda <dirlookup+0x8c>
    80002ed6:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002eda:	fc045583          	lhu	a1,-64(s0)
    80002ede:	00092503          	lw	a0,0(s2)
    80002ee2:	fffff097          	auipc	ra,0xfffff
    80002ee6:	74e080e7          	jalr	1870(ra) # 80002630 <iget>
    80002eea:	a011                	j	80002eee <dirlookup+0xa0>
  return 0;
    80002eec:	4501                	li	a0,0
}
    80002eee:	70e2                	ld	ra,56(sp)
    80002ef0:	7442                	ld	s0,48(sp)
    80002ef2:	74a2                	ld	s1,40(sp)
    80002ef4:	7902                	ld	s2,32(sp)
    80002ef6:	69e2                	ld	s3,24(sp)
    80002ef8:	6a42                	ld	s4,16(sp)
    80002efa:	6121                	addi	sp,sp,64
    80002efc:	8082                	ret

0000000080002efe <namex>:

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *namex(char *path, int nameiparent, char *name) {
    80002efe:	711d                	addi	sp,sp,-96
    80002f00:	ec86                	sd	ra,88(sp)
    80002f02:	e8a2                	sd	s0,80(sp)
    80002f04:	e4a6                	sd	s1,72(sp)
    80002f06:	e0ca                	sd	s2,64(sp)
    80002f08:	fc4e                	sd	s3,56(sp)
    80002f0a:	f852                	sd	s4,48(sp)
    80002f0c:	f456                	sd	s5,40(sp)
    80002f0e:	f05a                	sd	s6,32(sp)
    80002f10:	ec5e                	sd	s7,24(sp)
    80002f12:	e862                	sd	s8,16(sp)
    80002f14:	e466                	sd	s9,8(sp)
    80002f16:	e06a                	sd	s10,0(sp)
    80002f18:	1080                	addi	s0,sp,96
    80002f1a:	84aa                	mv	s1,a0
    80002f1c:	8b2e                	mv	s6,a1
    80002f1e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    80002f20:	00054703          	lbu	a4,0(a0)
    80002f24:	02f00793          	li	a5,47
    80002f28:	02f70363          	beq	a4,a5,80002f4e <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002f2c:	ffffe097          	auipc	ra,0xffffe
    80002f30:	d3e080e7          	jalr	-706(ra) # 80000c6a <myproc>
    80002f34:	15053503          	ld	a0,336(a0)
    80002f38:	00000097          	auipc	ra,0x0
    80002f3c:	9f4080e7          	jalr	-1548(ra) # 8000292c <idup>
    80002f40:	8a2a                	mv	s4,a0
  while (*path == '/') path++;
    80002f42:	02f00913          	li	s2,47
  if (len >= DIRSIZ)
    80002f46:	4cb5                	li	s9,13
  len = path - s;
    80002f48:	4b81                	li	s7,0

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    80002f4a:	4c05                	li	s8,1
    80002f4c:	a87d                	j	8000300a <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80002f4e:	4585                	li	a1,1
    80002f50:	4505                	li	a0,1
    80002f52:	fffff097          	auipc	ra,0xfffff
    80002f56:	6de080e7          	jalr	1758(ra) # 80002630 <iget>
    80002f5a:	8a2a                	mv	s4,a0
    80002f5c:	b7dd                	j	80002f42 <namex+0x44>
      iunlockput(ip);
    80002f5e:	8552                	mv	a0,s4
    80002f60:	00000097          	auipc	ra,0x0
    80002f64:	c6c080e7          	jalr	-916(ra) # 80002bcc <iunlockput>
      return 0;
    80002f68:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    80002f6a:	8552                	mv	a0,s4
    80002f6c:	60e6                	ld	ra,88(sp)
    80002f6e:	6446                	ld	s0,80(sp)
    80002f70:	64a6                	ld	s1,72(sp)
    80002f72:	6906                	ld	s2,64(sp)
    80002f74:	79e2                	ld	s3,56(sp)
    80002f76:	7a42                	ld	s4,48(sp)
    80002f78:	7aa2                	ld	s5,40(sp)
    80002f7a:	7b02                	ld	s6,32(sp)
    80002f7c:	6be2                	ld	s7,24(sp)
    80002f7e:	6c42                	ld	s8,16(sp)
    80002f80:	6ca2                	ld	s9,8(sp)
    80002f82:	6d02                	ld	s10,0(sp)
    80002f84:	6125                	addi	sp,sp,96
    80002f86:	8082                	ret
      iunlock(ip);
    80002f88:	8552                	mv	a0,s4
    80002f8a:	00000097          	auipc	ra,0x0
    80002f8e:	aa2080e7          	jalr	-1374(ra) # 80002a2c <iunlock>
      return ip;
    80002f92:	bfe1                	j	80002f6a <namex+0x6c>
      iunlockput(ip);
    80002f94:	8552                	mv	a0,s4
    80002f96:	00000097          	auipc	ra,0x0
    80002f9a:	c36080e7          	jalr	-970(ra) # 80002bcc <iunlockput>
      return 0;
    80002f9e:	8a4e                	mv	s4,s3
    80002fa0:	b7e9                	j	80002f6a <namex+0x6c>
  len = path - s;
    80002fa2:	40998633          	sub	a2,s3,s1
    80002fa6:	00060d1b          	sext.w	s10,a2
  if (len >= DIRSIZ)
    80002faa:	09acd863          	bge	s9,s10,8000303a <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80002fae:	4639                	li	a2,14
    80002fb0:	85a6                	mv	a1,s1
    80002fb2:	8556                	mv	a0,s5
    80002fb4:	ffffd097          	auipc	ra,0xffffd
    80002fb8:	11e080e7          	jalr	286(ra) # 800000d2 <memmove>
    80002fbc:	84ce                	mv	s1,s3
  while (*path == '/') path++;
    80002fbe:	0004c783          	lbu	a5,0(s1)
    80002fc2:	01279763          	bne	a5,s2,80002fd0 <namex+0xd2>
    80002fc6:	0485                	addi	s1,s1,1
    80002fc8:	0004c783          	lbu	a5,0(s1)
    80002fcc:	ff278de3          	beq	a5,s2,80002fc6 <namex+0xc8>
    ilock(ip);
    80002fd0:	8552                	mv	a0,s4
    80002fd2:	00000097          	auipc	ra,0x0
    80002fd6:	998080e7          	jalr	-1640(ra) # 8000296a <ilock>
    if (ip->type != T_DIR) {
    80002fda:	044a1783          	lh	a5,68(s4)
    80002fde:	f98790e3          	bne	a5,s8,80002f5e <namex+0x60>
    if (nameiparent && *path == '\0') {
    80002fe2:	000b0563          	beqz	s6,80002fec <namex+0xee>
    80002fe6:	0004c783          	lbu	a5,0(s1)
    80002fea:	dfd9                	beqz	a5,80002f88 <namex+0x8a>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    80002fec:	865e                	mv	a2,s7
    80002fee:	85d6                	mv	a1,s5
    80002ff0:	8552                	mv	a0,s4
    80002ff2:	00000097          	auipc	ra,0x0
    80002ff6:	e5c080e7          	jalr	-420(ra) # 80002e4e <dirlookup>
    80002ffa:	89aa                	mv	s3,a0
    80002ffc:	dd41                	beqz	a0,80002f94 <namex+0x96>
    iunlockput(ip);
    80002ffe:	8552                	mv	a0,s4
    80003000:	00000097          	auipc	ra,0x0
    80003004:	bcc080e7          	jalr	-1076(ra) # 80002bcc <iunlockput>
    ip = next;
    80003008:	8a4e                	mv	s4,s3
  while (*path == '/') path++;
    8000300a:	0004c783          	lbu	a5,0(s1)
    8000300e:	01279763          	bne	a5,s2,8000301c <namex+0x11e>
    80003012:	0485                	addi	s1,s1,1
    80003014:	0004c783          	lbu	a5,0(s1)
    80003018:	ff278de3          	beq	a5,s2,80003012 <namex+0x114>
  if (*path == 0) return 0;
    8000301c:	cb9d                	beqz	a5,80003052 <namex+0x154>
  while (*path != '/' && *path != 0) path++;
    8000301e:	0004c783          	lbu	a5,0(s1)
    80003022:	89a6                	mv	s3,s1
  len = path - s;
    80003024:	8d5e                	mv	s10,s7
    80003026:	865e                	mv	a2,s7
  while (*path != '/' && *path != 0) path++;
    80003028:	01278963          	beq	a5,s2,8000303a <namex+0x13c>
    8000302c:	dbbd                	beqz	a5,80002fa2 <namex+0xa4>
    8000302e:	0985                	addi	s3,s3,1
    80003030:	0009c783          	lbu	a5,0(s3)
    80003034:	ff279ce3          	bne	a5,s2,8000302c <namex+0x12e>
    80003038:	b7ad                	j	80002fa2 <namex+0xa4>
    memmove(name, s, len);
    8000303a:	2601                	sext.w	a2,a2
    8000303c:	85a6                	mv	a1,s1
    8000303e:	8556                	mv	a0,s5
    80003040:	ffffd097          	auipc	ra,0xffffd
    80003044:	092080e7          	jalr	146(ra) # 800000d2 <memmove>
    name[len] = 0;
    80003048:	9d56                	add	s10,s10,s5
    8000304a:	000d0023          	sb	zero,0(s10)
    8000304e:	84ce                	mv	s1,s3
    80003050:	b7bd                	j	80002fbe <namex+0xc0>
  if (nameiparent) {
    80003052:	f00b0ce3          	beqz	s6,80002f6a <namex+0x6c>
    iput(ip);
    80003056:	8552                	mv	a0,s4
    80003058:	00000097          	auipc	ra,0x0
    8000305c:	acc080e7          	jalr	-1332(ra) # 80002b24 <iput>
    return 0;
    80003060:	4a01                	li	s4,0
    80003062:	b721                	j	80002f6a <namex+0x6c>

0000000080003064 <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum) {
    80003064:	7139                	addi	sp,sp,-64
    80003066:	fc06                	sd	ra,56(sp)
    80003068:	f822                	sd	s0,48(sp)
    8000306a:	f426                	sd	s1,40(sp)
    8000306c:	f04a                	sd	s2,32(sp)
    8000306e:	ec4e                	sd	s3,24(sp)
    80003070:	e852                	sd	s4,16(sp)
    80003072:	0080                	addi	s0,sp,64
    80003074:	892a                	mv	s2,a0
    80003076:	8a2e                	mv	s4,a1
    80003078:	89b2                	mv	s3,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    8000307a:	4601                	li	a2,0
    8000307c:	00000097          	auipc	ra,0x0
    80003080:	dd2080e7          	jalr	-558(ra) # 80002e4e <dirlookup>
    80003084:	e93d                	bnez	a0,800030fa <dirlink+0x96>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003086:	04c92483          	lw	s1,76(s2)
    8000308a:	c49d                	beqz	s1,800030b8 <dirlink+0x54>
    8000308c:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000308e:	4741                	li	a4,16
    80003090:	86a6                	mv	a3,s1
    80003092:	fc040613          	addi	a2,s0,-64
    80003096:	4581                	li	a1,0
    80003098:	854a                	mv	a0,s2
    8000309a:	00000097          	auipc	ra,0x0
    8000309e:	b84080e7          	jalr	-1148(ra) # 80002c1e <readi>
    800030a2:	47c1                	li	a5,16
    800030a4:	06f51163          	bne	a0,a5,80003106 <dirlink+0xa2>
    if (de.inum == 0) break;
    800030a8:	fc045783          	lhu	a5,-64(s0)
    800030ac:	c791                	beqz	a5,800030b8 <dirlink+0x54>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800030ae:	24c1                	addiw	s1,s1,16
    800030b0:	04c92783          	lw	a5,76(s2)
    800030b4:	fcf4ede3          	bltu	s1,a5,8000308e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800030b8:	4639                	li	a2,14
    800030ba:	85d2                	mv	a1,s4
    800030bc:	fc240513          	addi	a0,s0,-62
    800030c0:	ffffd097          	auipc	ra,0xffffd
    800030c4:	0c2080e7          	jalr	194(ra) # 80000182 <strncpy>
  de.inum = inum;
    800030c8:	fd341023          	sh	s3,-64(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de)) return -1;
    800030cc:	4741                	li	a4,16
    800030ce:	86a6                	mv	a3,s1
    800030d0:	fc040613          	addi	a2,s0,-64
    800030d4:	4581                	li	a1,0
    800030d6:	854a                	mv	a0,s2
    800030d8:	00000097          	auipc	ra,0x0
    800030dc:	c3e080e7          	jalr	-962(ra) # 80002d16 <writei>
    800030e0:	1541                	addi	a0,a0,-16
    800030e2:	00a03533          	snez	a0,a0
    800030e6:	40a00533          	neg	a0,a0
}
    800030ea:	70e2                	ld	ra,56(sp)
    800030ec:	7442                	ld	s0,48(sp)
    800030ee:	74a2                	ld	s1,40(sp)
    800030f0:	7902                	ld	s2,32(sp)
    800030f2:	69e2                	ld	s3,24(sp)
    800030f4:	6a42                	ld	s4,16(sp)
    800030f6:	6121                	addi	sp,sp,64
    800030f8:	8082                	ret
    iput(ip);
    800030fa:	00000097          	auipc	ra,0x0
    800030fe:	a2a080e7          	jalr	-1494(ra) # 80002b24 <iput>
    return -1;
    80003102:	557d                	li	a0,-1
    80003104:	b7dd                	j	800030ea <dirlink+0x86>
      panic("dirlink read");
    80003106:	00005517          	auipc	a0,0x5
    8000310a:	46250513          	addi	a0,a0,1122 # 80008568 <syscalls+0x1c8>
    8000310e:	00003097          	auipc	ra,0x3
    80003112:	576080e7          	jalr	1398(ra) # 80006684 <panic>

0000000080003116 <namei>:

struct inode *namei(char *path) {
    80003116:	1101                	addi	sp,sp,-32
    80003118:	ec06                	sd	ra,24(sp)
    8000311a:	e822                	sd	s0,16(sp)
    8000311c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000311e:	fe040613          	addi	a2,s0,-32
    80003122:	4581                	li	a1,0
    80003124:	00000097          	auipc	ra,0x0
    80003128:	dda080e7          	jalr	-550(ra) # 80002efe <namex>
}
    8000312c:	60e2                	ld	ra,24(sp)
    8000312e:	6442                	ld	s0,16(sp)
    80003130:	6105                	addi	sp,sp,32
    80003132:	8082                	ret

0000000080003134 <nameiparent>:

struct inode *nameiparent(char *path, char *name) {
    80003134:	1141                	addi	sp,sp,-16
    80003136:	e406                	sd	ra,8(sp)
    80003138:	e022                	sd	s0,0(sp)
    8000313a:	0800                	addi	s0,sp,16
    8000313c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000313e:	4585                	li	a1,1
    80003140:	00000097          	auipc	ra,0x0
    80003144:	dbe080e7          	jalr	-578(ra) # 80002efe <namex>
}
    80003148:	60a2                	ld	ra,8(sp)
    8000314a:	6402                	ld	s0,0(sp)
    8000314c:	0141                	addi	sp,sp,16
    8000314e:	8082                	ret

0000000080003150 <write_head>:
}

// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void write_head(void) {
    80003150:	1101                	addi	sp,sp,-32
    80003152:	ec06                	sd	ra,24(sp)
    80003154:	e822                	sd	s0,16(sp)
    80003156:	e426                	sd	s1,8(sp)
    80003158:	e04a                	sd	s2,0(sp)
    8000315a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000315c:	00010917          	auipc	s2,0x10
    80003160:	ebc90913          	addi	s2,s2,-324 # 80013018 <log>
    80003164:	01892583          	lw	a1,24(s2)
    80003168:	02892503          	lw	a0,40(s2)
    8000316c:	fffff097          	auipc	ra,0xfffff
    80003170:	fe6080e7          	jalr	-26(ra) # 80002152 <bread>
    80003174:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    80003176:	02c92683          	lw	a3,44(s2)
    8000317a:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000317c:	02d05863          	blez	a3,800031ac <write_head+0x5c>
    80003180:	00010797          	auipc	a5,0x10
    80003184:	ec878793          	addi	a5,a5,-312 # 80013048 <log+0x30>
    80003188:	05c50713          	addi	a4,a0,92
    8000318c:	36fd                	addiw	a3,a3,-1
    8000318e:	02069613          	slli	a2,a3,0x20
    80003192:	01e65693          	srli	a3,a2,0x1e
    80003196:	00010617          	auipc	a2,0x10
    8000319a:	eb660613          	addi	a2,a2,-330 # 8001304c <log+0x34>
    8000319e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800031a0:	4390                	lw	a2,0(a5)
    800031a2:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800031a4:	0791                	addi	a5,a5,4
    800031a6:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    800031a8:	fed79ce3          	bne	a5,a3,800031a0 <write_head+0x50>
  }
  bwrite(buf);
    800031ac:	8526                	mv	a0,s1
    800031ae:	fffff097          	auipc	ra,0xfffff
    800031b2:	096080e7          	jalr	150(ra) # 80002244 <bwrite>
  brelse(buf);
    800031b6:	8526                	mv	a0,s1
    800031b8:	fffff097          	auipc	ra,0xfffff
    800031bc:	0ca080e7          	jalr	202(ra) # 80002282 <brelse>
}
    800031c0:	60e2                	ld	ra,24(sp)
    800031c2:	6442                	ld	s0,16(sp)
    800031c4:	64a2                	ld	s1,8(sp)
    800031c6:	6902                	ld	s2,0(sp)
    800031c8:	6105                	addi	sp,sp,32
    800031ca:	8082                	ret

00000000800031cc <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800031cc:	00010797          	auipc	a5,0x10
    800031d0:	e787a783          	lw	a5,-392(a5) # 80013044 <log+0x2c>
    800031d4:	0af05d63          	blez	a5,8000328e <install_trans+0xc2>
static void install_trans(int recovering) {
    800031d8:	7139                	addi	sp,sp,-64
    800031da:	fc06                	sd	ra,56(sp)
    800031dc:	f822                	sd	s0,48(sp)
    800031de:	f426                	sd	s1,40(sp)
    800031e0:	f04a                	sd	s2,32(sp)
    800031e2:	ec4e                	sd	s3,24(sp)
    800031e4:	e852                	sd	s4,16(sp)
    800031e6:	e456                	sd	s5,8(sp)
    800031e8:	e05a                	sd	s6,0(sp)
    800031ea:	0080                	addi	s0,sp,64
    800031ec:	8b2a                	mv	s6,a0
    800031ee:	00010a97          	auipc	s5,0x10
    800031f2:	e5aa8a93          	addi	s5,s5,-422 # 80013048 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800031f6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start + tail + 1);  // read log block
    800031f8:	00010997          	auipc	s3,0x10
    800031fc:	e2098993          	addi	s3,s3,-480 # 80013018 <log>
    80003200:	a00d                	j	80003222 <install_trans+0x56>
    brelse(lbuf);
    80003202:	854a                	mv	a0,s2
    80003204:	fffff097          	auipc	ra,0xfffff
    80003208:	07e080e7          	jalr	126(ra) # 80002282 <brelse>
    brelse(dbuf);
    8000320c:	8526                	mv	a0,s1
    8000320e:	fffff097          	auipc	ra,0xfffff
    80003212:	074080e7          	jalr	116(ra) # 80002282 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003216:	2a05                	addiw	s4,s4,1
    80003218:	0a91                	addi	s5,s5,4
    8000321a:	02c9a783          	lw	a5,44(s3)
    8000321e:	04fa5e63          	bge	s4,a5,8000327a <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1);  // read log block
    80003222:	0189a583          	lw	a1,24(s3)
    80003226:	014585bb          	addw	a1,a1,s4
    8000322a:	2585                	addiw	a1,a1,1
    8000322c:	0289a503          	lw	a0,40(s3)
    80003230:	fffff097          	auipc	ra,0xfffff
    80003234:	f22080e7          	jalr	-222(ra) # 80002152 <bread>
    80003238:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);    // read dst
    8000323a:	000aa583          	lw	a1,0(s5)
    8000323e:	0289a503          	lw	a0,40(s3)
    80003242:	fffff097          	auipc	ra,0xfffff
    80003246:	f10080e7          	jalr	-240(ra) # 80002152 <bread>
    8000324a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000324c:	40000613          	li	a2,1024
    80003250:	05890593          	addi	a1,s2,88
    80003254:	05850513          	addi	a0,a0,88
    80003258:	ffffd097          	auipc	ra,0xffffd
    8000325c:	e7a080e7          	jalr	-390(ra) # 800000d2 <memmove>
    bwrite(dbuf);                            // write dst to disk
    80003260:	8526                	mv	a0,s1
    80003262:	fffff097          	auipc	ra,0xfffff
    80003266:	fe2080e7          	jalr	-30(ra) # 80002244 <bwrite>
    if (recovering == 0) bunpin(dbuf);
    8000326a:	f80b1ce3          	bnez	s6,80003202 <install_trans+0x36>
    8000326e:	8526                	mv	a0,s1
    80003270:	fffff097          	auipc	ra,0xfffff
    80003274:	0ec080e7          	jalr	236(ra) # 8000235c <bunpin>
    80003278:	b769                	j	80003202 <install_trans+0x36>
}
    8000327a:	70e2                	ld	ra,56(sp)
    8000327c:	7442                	ld	s0,48(sp)
    8000327e:	74a2                	ld	s1,40(sp)
    80003280:	7902                	ld	s2,32(sp)
    80003282:	69e2                	ld	s3,24(sp)
    80003284:	6a42                	ld	s4,16(sp)
    80003286:	6aa2                	ld	s5,8(sp)
    80003288:	6b02                	ld	s6,0(sp)
    8000328a:	6121                	addi	sp,sp,64
    8000328c:	8082                	ret
    8000328e:	8082                	ret

0000000080003290 <initlog>:
void initlog(int dev, struct superblock *sb) {
    80003290:	7179                	addi	sp,sp,-48
    80003292:	f406                	sd	ra,40(sp)
    80003294:	f022                	sd	s0,32(sp)
    80003296:	ec26                	sd	s1,24(sp)
    80003298:	e84a                	sd	s2,16(sp)
    8000329a:	e44e                	sd	s3,8(sp)
    8000329c:	1800                	addi	s0,sp,48
    8000329e:	892a                	mv	s2,a0
    800032a0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800032a2:	00010497          	auipc	s1,0x10
    800032a6:	d7648493          	addi	s1,s1,-650 # 80013018 <log>
    800032aa:	00005597          	auipc	a1,0x5
    800032ae:	2ce58593          	addi	a1,a1,718 # 80008578 <syscalls+0x1d8>
    800032b2:	8526                	mv	a0,s1
    800032b4:	00004097          	auipc	ra,0x4
    800032b8:	878080e7          	jalr	-1928(ra) # 80006b2c <initlock>
  log.start = sb->logstart;
    800032bc:	0149a583          	lw	a1,20(s3)
    800032c0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800032c2:	0109a783          	lw	a5,16(s3)
    800032c6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800032c8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800032cc:	854a                	mv	a0,s2
    800032ce:	fffff097          	auipc	ra,0xfffff
    800032d2:	e84080e7          	jalr	-380(ra) # 80002152 <bread>
  log.lh.n = lh->n;
    800032d6:	4d34                	lw	a3,88(a0)
    800032d8:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800032da:	02d05663          	blez	a3,80003306 <initlog+0x76>
    800032de:	05c50793          	addi	a5,a0,92
    800032e2:	00010717          	auipc	a4,0x10
    800032e6:	d6670713          	addi	a4,a4,-666 # 80013048 <log+0x30>
    800032ea:	36fd                	addiw	a3,a3,-1
    800032ec:	02069613          	slli	a2,a3,0x20
    800032f0:	01e65693          	srli	a3,a2,0x1e
    800032f4:	06050613          	addi	a2,a0,96
    800032f8:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800032fa:	4390                	lw	a2,0(a5)
    800032fc:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800032fe:	0791                	addi	a5,a5,4
    80003300:	0711                	addi	a4,a4,4
    80003302:	fed79ce3          	bne	a5,a3,800032fa <initlog+0x6a>
  brelse(buf);
    80003306:	fffff097          	auipc	ra,0xfffff
    8000330a:	f7c080e7          	jalr	-132(ra) # 80002282 <brelse>

static void recover_from_log(void) {
  read_head();
  install_trans(1);  // if committed, copy from log to disk
    8000330e:	4505                	li	a0,1
    80003310:	00000097          	auipc	ra,0x0
    80003314:	ebc080e7          	jalr	-324(ra) # 800031cc <install_trans>
  log.lh.n = 0;
    80003318:	00010797          	auipc	a5,0x10
    8000331c:	d207a623          	sw	zero,-724(a5) # 80013044 <log+0x2c>
  write_head();  // clear the log
    80003320:	00000097          	auipc	ra,0x0
    80003324:	e30080e7          	jalr	-464(ra) # 80003150 <write_head>
}
    80003328:	70a2                	ld	ra,40(sp)
    8000332a:	7402                	ld	s0,32(sp)
    8000332c:	64e2                	ld	s1,24(sp)
    8000332e:	6942                	ld	s2,16(sp)
    80003330:	69a2                	ld	s3,8(sp)
    80003332:	6145                	addi	sp,sp,48
    80003334:	8082                	ret

0000000080003336 <begin_op>:
}

// called at the start of each FS system call.
void begin_op(void) {
    80003336:	1101                	addi	sp,sp,-32
    80003338:	ec06                	sd	ra,24(sp)
    8000333a:	e822                	sd	s0,16(sp)
    8000333c:	e426                	sd	s1,8(sp)
    8000333e:	e04a                	sd	s2,0(sp)
    80003340:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003342:	00010517          	auipc	a0,0x10
    80003346:	cd650513          	addi	a0,a0,-810 # 80013018 <log>
    8000334a:	00004097          	auipc	ra,0x4
    8000334e:	872080e7          	jalr	-1934(ra) # 80006bbc <acquire>
  while (1) {
    if (log.committing) {
    80003352:	00010497          	auipc	s1,0x10
    80003356:	cc648493          	addi	s1,s1,-826 # 80013018 <log>
      sleep(&log, &log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    8000335a:	4979                	li	s2,30
    8000335c:	a039                	j	8000336a <begin_op+0x34>
      sleep(&log, &log.lock);
    8000335e:	85a6                	mv	a1,s1
    80003360:	8526                	mv	a0,s1
    80003362:	ffffe097          	auipc	ra,0xffffe
    80003366:	fe8080e7          	jalr	-24(ra) # 8000134a <sleep>
    if (log.committing) {
    8000336a:	50dc                	lw	a5,36(s1)
    8000336c:	fbed                	bnez	a5,8000335e <begin_op+0x28>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
    8000336e:	5098                	lw	a4,32(s1)
    80003370:	2705                	addiw	a4,a4,1
    80003372:	0007069b          	sext.w	a3,a4
    80003376:	0027179b          	slliw	a5,a4,0x2
    8000337a:	9fb9                	addw	a5,a5,a4
    8000337c:	0017979b          	slliw	a5,a5,0x1
    80003380:	54d8                	lw	a4,44(s1)
    80003382:	9fb9                	addw	a5,a5,a4
    80003384:	00f95963          	bge	s2,a5,80003396 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003388:	85a6                	mv	a1,s1
    8000338a:	8526                	mv	a0,s1
    8000338c:	ffffe097          	auipc	ra,0xffffe
    80003390:	fbe080e7          	jalr	-66(ra) # 8000134a <sleep>
    80003394:	bfd9                	j	8000336a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003396:	00010517          	auipc	a0,0x10
    8000339a:	c8250513          	addi	a0,a0,-894 # 80013018 <log>
    8000339e:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800033a0:	00004097          	auipc	ra,0x4
    800033a4:	8ca080e7          	jalr	-1846(ra) # 80006c6a <release>
      break;
    }
  }
}
    800033a8:	60e2                	ld	ra,24(sp)
    800033aa:	6442                	ld	s0,16(sp)
    800033ac:	64a2                	ld	s1,8(sp)
    800033ae:	6902                	ld	s2,0(sp)
    800033b0:	6105                	addi	sp,sp,32
    800033b2:	8082                	ret

00000000800033b4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void end_op(void) {
    800033b4:	7139                	addi	sp,sp,-64
    800033b6:	fc06                	sd	ra,56(sp)
    800033b8:	f822                	sd	s0,48(sp)
    800033ba:	f426                	sd	s1,40(sp)
    800033bc:	f04a                	sd	s2,32(sp)
    800033be:	ec4e                	sd	s3,24(sp)
    800033c0:	e852                	sd	s4,16(sp)
    800033c2:	e456                	sd	s5,8(sp)
    800033c4:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800033c6:	00010497          	auipc	s1,0x10
    800033ca:	c5248493          	addi	s1,s1,-942 # 80013018 <log>
    800033ce:	8526                	mv	a0,s1
    800033d0:	00003097          	auipc	ra,0x3
    800033d4:	7ec080e7          	jalr	2028(ra) # 80006bbc <acquire>
  log.outstanding -= 1;
    800033d8:	509c                	lw	a5,32(s1)
    800033da:	37fd                	addiw	a5,a5,-1
    800033dc:	0007891b          	sext.w	s2,a5
    800033e0:	d09c                	sw	a5,32(s1)
  if (log.committing) panic("log.committing");
    800033e2:	50dc                	lw	a5,36(s1)
    800033e4:	e7b9                	bnez	a5,80003432 <end_op+0x7e>
  if (log.outstanding == 0) {
    800033e6:	04091e63          	bnez	s2,80003442 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800033ea:	00010497          	auipc	s1,0x10
    800033ee:	c2e48493          	addi	s1,s1,-978 # 80013018 <log>
    800033f2:	4785                	li	a5,1
    800033f4:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800033f6:	8526                	mv	a0,s1
    800033f8:	00004097          	auipc	ra,0x4
    800033fc:	872080e7          	jalr	-1934(ra) # 80006c6a <release>
    brelse(to);
  }
}

static void commit() {
  if (log.lh.n > 0) {
    80003400:	54dc                	lw	a5,44(s1)
    80003402:	06f04763          	bgtz	a5,80003470 <end_op+0xbc>
    acquire(&log.lock);
    80003406:	00010497          	auipc	s1,0x10
    8000340a:	c1248493          	addi	s1,s1,-1006 # 80013018 <log>
    8000340e:	8526                	mv	a0,s1
    80003410:	00003097          	auipc	ra,0x3
    80003414:	7ac080e7          	jalr	1964(ra) # 80006bbc <acquire>
    log.committing = 0;
    80003418:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000341c:	8526                	mv	a0,s1
    8000341e:	ffffe097          	auipc	ra,0xffffe
    80003422:	f90080e7          	jalr	-112(ra) # 800013ae <wakeup>
    release(&log.lock);
    80003426:	8526                	mv	a0,s1
    80003428:	00004097          	auipc	ra,0x4
    8000342c:	842080e7          	jalr	-1982(ra) # 80006c6a <release>
}
    80003430:	a03d                	j	8000345e <end_op+0xaa>
  if (log.committing) panic("log.committing");
    80003432:	00005517          	auipc	a0,0x5
    80003436:	14e50513          	addi	a0,a0,334 # 80008580 <syscalls+0x1e0>
    8000343a:	00003097          	auipc	ra,0x3
    8000343e:	24a080e7          	jalr	586(ra) # 80006684 <panic>
    wakeup(&log);
    80003442:	00010497          	auipc	s1,0x10
    80003446:	bd648493          	addi	s1,s1,-1066 # 80013018 <log>
    8000344a:	8526                	mv	a0,s1
    8000344c:	ffffe097          	auipc	ra,0xffffe
    80003450:	f62080e7          	jalr	-158(ra) # 800013ae <wakeup>
  release(&log.lock);
    80003454:	8526                	mv	a0,s1
    80003456:	00004097          	auipc	ra,0x4
    8000345a:	814080e7          	jalr	-2028(ra) # 80006c6a <release>
}
    8000345e:	70e2                	ld	ra,56(sp)
    80003460:	7442                	ld	s0,48(sp)
    80003462:	74a2                	ld	s1,40(sp)
    80003464:	7902                	ld	s2,32(sp)
    80003466:	69e2                	ld	s3,24(sp)
    80003468:	6a42                	ld	s4,16(sp)
    8000346a:	6aa2                	ld	s5,8(sp)
    8000346c:	6121                	addi	sp,sp,64
    8000346e:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003470:	00010a97          	auipc	s5,0x10
    80003474:	bd8a8a93          	addi	s5,s5,-1064 # 80013048 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1);  // log block
    80003478:	00010a17          	auipc	s4,0x10
    8000347c:	ba0a0a13          	addi	s4,s4,-1120 # 80013018 <log>
    80003480:	018a2583          	lw	a1,24(s4)
    80003484:	012585bb          	addw	a1,a1,s2
    80003488:	2585                	addiw	a1,a1,1
    8000348a:	028a2503          	lw	a0,40(s4)
    8000348e:	fffff097          	auipc	ra,0xfffff
    80003492:	cc4080e7          	jalr	-828(ra) # 80002152 <bread>
    80003496:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]);  // cache block
    80003498:	000aa583          	lw	a1,0(s5)
    8000349c:	028a2503          	lw	a0,40(s4)
    800034a0:	fffff097          	auipc	ra,0xfffff
    800034a4:	cb2080e7          	jalr	-846(ra) # 80002152 <bread>
    800034a8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800034aa:	40000613          	li	a2,1024
    800034ae:	05850593          	addi	a1,a0,88
    800034b2:	05848513          	addi	a0,s1,88
    800034b6:	ffffd097          	auipc	ra,0xffffd
    800034ba:	c1c080e7          	jalr	-996(ra) # 800000d2 <memmove>
    bwrite(to);  // write the log
    800034be:	8526                	mv	a0,s1
    800034c0:	fffff097          	auipc	ra,0xfffff
    800034c4:	d84080e7          	jalr	-636(ra) # 80002244 <bwrite>
    brelse(from);
    800034c8:	854e                	mv	a0,s3
    800034ca:	fffff097          	auipc	ra,0xfffff
    800034ce:	db8080e7          	jalr	-584(ra) # 80002282 <brelse>
    brelse(to);
    800034d2:	8526                	mv	a0,s1
    800034d4:	fffff097          	auipc	ra,0xfffff
    800034d8:	dae080e7          	jalr	-594(ra) # 80002282 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034dc:	2905                	addiw	s2,s2,1
    800034de:	0a91                	addi	s5,s5,4
    800034e0:	02ca2783          	lw	a5,44(s4)
    800034e4:	f8f94ee3          	blt	s2,a5,80003480 <end_op+0xcc>
    write_log();       // Write modified blocks from cache to log
    write_head();      // Write header to disk -- the real commit
    800034e8:	00000097          	auipc	ra,0x0
    800034ec:	c68080e7          	jalr	-920(ra) # 80003150 <write_head>
    install_trans(0);  // Now install writes to home locations
    800034f0:	4501                	li	a0,0
    800034f2:	00000097          	auipc	ra,0x0
    800034f6:	cda080e7          	jalr	-806(ra) # 800031cc <install_trans>
    log.lh.n = 0;
    800034fa:	00010797          	auipc	a5,0x10
    800034fe:	b407a523          	sw	zero,-1206(a5) # 80013044 <log+0x2c>
    write_head();  // Erase the transaction from the log
    80003502:	00000097          	auipc	ra,0x0
    80003506:	c4e080e7          	jalr	-946(ra) # 80003150 <write_head>
    8000350a:	bdf5                	j	80003406 <end_op+0x52>

000000008000350c <log_write>:
// log_write() replaces bwrite(); a typical use is:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void log_write(struct buf *b) {
    8000350c:	1101                	addi	sp,sp,-32
    8000350e:	ec06                	sd	ra,24(sp)
    80003510:	e822                	sd	s0,16(sp)
    80003512:	e426                	sd	s1,8(sp)
    80003514:	e04a                	sd	s2,0(sp)
    80003516:	1000                	addi	s0,sp,32
    80003518:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000351a:	00010917          	auipc	s2,0x10
    8000351e:	afe90913          	addi	s2,s2,-1282 # 80013018 <log>
    80003522:	854a                	mv	a0,s2
    80003524:	00003097          	auipc	ra,0x3
    80003528:	698080e7          	jalr	1688(ra) # 80006bbc <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000352c:	02c92603          	lw	a2,44(s2)
    80003530:	47f5                	li	a5,29
    80003532:	06c7c563          	blt	a5,a2,8000359c <log_write+0x90>
    80003536:	00010797          	auipc	a5,0x10
    8000353a:	afe7a783          	lw	a5,-1282(a5) # 80013034 <log+0x1c>
    8000353e:	37fd                	addiw	a5,a5,-1
    80003540:	04f65e63          	bge	a2,a5,8000359c <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1) panic("log_write outside of trans");
    80003544:	00010797          	auipc	a5,0x10
    80003548:	af47a783          	lw	a5,-1292(a5) # 80013038 <log+0x20>
    8000354c:	06f05063          	blez	a5,800035ac <log_write+0xa0>

  for (i = 0; i < log.lh.n; i++) {
    80003550:	4781                	li	a5,0
    80003552:	06c05563          	blez	a2,800035bc <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)  // log absorption
    80003556:	44cc                	lw	a1,12(s1)
    80003558:	00010717          	auipc	a4,0x10
    8000355c:	af070713          	addi	a4,a4,-1296 # 80013048 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003560:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)  // log absorption
    80003562:	4314                	lw	a3,0(a4)
    80003564:	04b68c63          	beq	a3,a1,800035bc <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003568:	2785                	addiw	a5,a5,1
    8000356a:	0711                	addi	a4,a4,4
    8000356c:	fef61be3          	bne	a2,a5,80003562 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003570:	0621                	addi	a2,a2,8
    80003572:	060a                	slli	a2,a2,0x2
    80003574:	00010797          	auipc	a5,0x10
    80003578:	aa478793          	addi	a5,a5,-1372 # 80013018 <log>
    8000357c:	97b2                	add	a5,a5,a2
    8000357e:	44d8                	lw	a4,12(s1)
    80003580:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003582:	8526                	mv	a0,s1
    80003584:	fffff097          	auipc	ra,0xfffff
    80003588:	d9c080e7          	jalr	-612(ra) # 80002320 <bpin>
    log.lh.n++;
    8000358c:	00010717          	auipc	a4,0x10
    80003590:	a8c70713          	addi	a4,a4,-1396 # 80013018 <log>
    80003594:	575c                	lw	a5,44(a4)
    80003596:	2785                	addiw	a5,a5,1
    80003598:	d75c                	sw	a5,44(a4)
    8000359a:	a82d                	j	800035d4 <log_write+0xc8>
    panic("too big a transaction");
    8000359c:	00005517          	auipc	a0,0x5
    800035a0:	ff450513          	addi	a0,a0,-12 # 80008590 <syscalls+0x1f0>
    800035a4:	00003097          	auipc	ra,0x3
    800035a8:	0e0080e7          	jalr	224(ra) # 80006684 <panic>
  if (log.outstanding < 1) panic("log_write outside of trans");
    800035ac:	00005517          	auipc	a0,0x5
    800035b0:	ffc50513          	addi	a0,a0,-4 # 800085a8 <syscalls+0x208>
    800035b4:	00003097          	auipc	ra,0x3
    800035b8:	0d0080e7          	jalr	208(ra) # 80006684 <panic>
  log.lh.block[i] = b->blockno;
    800035bc:	00878693          	addi	a3,a5,8
    800035c0:	068a                	slli	a3,a3,0x2
    800035c2:	00010717          	auipc	a4,0x10
    800035c6:	a5670713          	addi	a4,a4,-1450 # 80013018 <log>
    800035ca:	9736                	add	a4,a4,a3
    800035cc:	44d4                	lw	a3,12(s1)
    800035ce:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800035d0:	faf609e3          	beq	a2,a5,80003582 <log_write+0x76>
  }
  release(&log.lock);
    800035d4:	00010517          	auipc	a0,0x10
    800035d8:	a4450513          	addi	a0,a0,-1468 # 80013018 <log>
    800035dc:	00003097          	auipc	ra,0x3
    800035e0:	68e080e7          	jalr	1678(ra) # 80006c6a <release>
}
    800035e4:	60e2                	ld	ra,24(sp)
    800035e6:	6442                	ld	s0,16(sp)
    800035e8:	64a2                	ld	s1,8(sp)
    800035ea:	6902                	ld	s2,0(sp)
    800035ec:	6105                	addi	sp,sp,32
    800035ee:	8082                	ret

00000000800035f0 <initsleeplock>:
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "sleeplock.h"

void initsleeplock(struct sleeplock *lk, char *name) {
    800035f0:	1101                	addi	sp,sp,-32
    800035f2:	ec06                	sd	ra,24(sp)
    800035f4:	e822                	sd	s0,16(sp)
    800035f6:	e426                	sd	s1,8(sp)
    800035f8:	e04a                	sd	s2,0(sp)
    800035fa:	1000                	addi	s0,sp,32
    800035fc:	84aa                	mv	s1,a0
    800035fe:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003600:	00005597          	auipc	a1,0x5
    80003604:	fc858593          	addi	a1,a1,-56 # 800085c8 <syscalls+0x228>
    80003608:	0521                	addi	a0,a0,8
    8000360a:	00003097          	auipc	ra,0x3
    8000360e:	522080e7          	jalr	1314(ra) # 80006b2c <initlock>
  lk->name = name;
    80003612:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003616:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000361a:	0204a423          	sw	zero,40(s1)
}
    8000361e:	60e2                	ld	ra,24(sp)
    80003620:	6442                	ld	s0,16(sp)
    80003622:	64a2                	ld	s1,8(sp)
    80003624:	6902                	ld	s2,0(sp)
    80003626:	6105                	addi	sp,sp,32
    80003628:	8082                	ret

000000008000362a <acquiresleep>:

void acquiresleep(struct sleeplock *lk) {
    8000362a:	1101                	addi	sp,sp,-32
    8000362c:	ec06                	sd	ra,24(sp)
    8000362e:	e822                	sd	s0,16(sp)
    80003630:	e426                	sd	s1,8(sp)
    80003632:	e04a                	sd	s2,0(sp)
    80003634:	1000                	addi	s0,sp,32
    80003636:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003638:	00850913          	addi	s2,a0,8
    8000363c:	854a                	mv	a0,s2
    8000363e:	00003097          	auipc	ra,0x3
    80003642:	57e080e7          	jalr	1406(ra) # 80006bbc <acquire>
  while (lk->locked) {
    80003646:	409c                	lw	a5,0(s1)
    80003648:	cb89                	beqz	a5,8000365a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000364a:	85ca                	mv	a1,s2
    8000364c:	8526                	mv	a0,s1
    8000364e:	ffffe097          	auipc	ra,0xffffe
    80003652:	cfc080e7          	jalr	-772(ra) # 8000134a <sleep>
  while (lk->locked) {
    80003656:	409c                	lw	a5,0(s1)
    80003658:	fbed                	bnez	a5,8000364a <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000365a:	4785                	li	a5,1
    8000365c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000365e:	ffffd097          	auipc	ra,0xffffd
    80003662:	60c080e7          	jalr	1548(ra) # 80000c6a <myproc>
    80003666:	591c                	lw	a5,48(a0)
    80003668:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000366a:	854a                	mv	a0,s2
    8000366c:	00003097          	auipc	ra,0x3
    80003670:	5fe080e7          	jalr	1534(ra) # 80006c6a <release>
}
    80003674:	60e2                	ld	ra,24(sp)
    80003676:	6442                	ld	s0,16(sp)
    80003678:	64a2                	ld	s1,8(sp)
    8000367a:	6902                	ld	s2,0(sp)
    8000367c:	6105                	addi	sp,sp,32
    8000367e:	8082                	ret

0000000080003680 <releasesleep>:

void releasesleep(struct sleeplock *lk) {
    80003680:	1101                	addi	sp,sp,-32
    80003682:	ec06                	sd	ra,24(sp)
    80003684:	e822                	sd	s0,16(sp)
    80003686:	e426                	sd	s1,8(sp)
    80003688:	e04a                	sd	s2,0(sp)
    8000368a:	1000                	addi	s0,sp,32
    8000368c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000368e:	00850913          	addi	s2,a0,8
    80003692:	854a                	mv	a0,s2
    80003694:	00003097          	auipc	ra,0x3
    80003698:	528080e7          	jalr	1320(ra) # 80006bbc <acquire>
  lk->locked = 0;
    8000369c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800036a0:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800036a4:	8526                	mv	a0,s1
    800036a6:	ffffe097          	auipc	ra,0xffffe
    800036aa:	d08080e7          	jalr	-760(ra) # 800013ae <wakeup>
  release(&lk->lk);
    800036ae:	854a                	mv	a0,s2
    800036b0:	00003097          	auipc	ra,0x3
    800036b4:	5ba080e7          	jalr	1466(ra) # 80006c6a <release>
}
    800036b8:	60e2                	ld	ra,24(sp)
    800036ba:	6442                	ld	s0,16(sp)
    800036bc:	64a2                	ld	s1,8(sp)
    800036be:	6902                	ld	s2,0(sp)
    800036c0:	6105                	addi	sp,sp,32
    800036c2:	8082                	ret

00000000800036c4 <holdingsleep>:

int holdingsleep(struct sleeplock *lk) {
    800036c4:	7179                	addi	sp,sp,-48
    800036c6:	f406                	sd	ra,40(sp)
    800036c8:	f022                	sd	s0,32(sp)
    800036ca:	ec26                	sd	s1,24(sp)
    800036cc:	e84a                	sd	s2,16(sp)
    800036ce:	e44e                	sd	s3,8(sp)
    800036d0:	1800                	addi	s0,sp,48
    800036d2:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    800036d4:	00850913          	addi	s2,a0,8
    800036d8:	854a                	mv	a0,s2
    800036da:	00003097          	auipc	ra,0x3
    800036de:	4e2080e7          	jalr	1250(ra) # 80006bbc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800036e2:	409c                	lw	a5,0(s1)
    800036e4:	ef99                	bnez	a5,80003702 <holdingsleep+0x3e>
    800036e6:	4481                	li	s1,0
  release(&lk->lk);
    800036e8:	854a                	mv	a0,s2
    800036ea:	00003097          	auipc	ra,0x3
    800036ee:	580080e7          	jalr	1408(ra) # 80006c6a <release>
  return r;
}
    800036f2:	8526                	mv	a0,s1
    800036f4:	70a2                	ld	ra,40(sp)
    800036f6:	7402                	ld	s0,32(sp)
    800036f8:	64e2                	ld	s1,24(sp)
    800036fa:	6942                	ld	s2,16(sp)
    800036fc:	69a2                	ld	s3,8(sp)
    800036fe:	6145                	addi	sp,sp,48
    80003700:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003702:	0284a983          	lw	s3,40(s1)
    80003706:	ffffd097          	auipc	ra,0xffffd
    8000370a:	564080e7          	jalr	1380(ra) # 80000c6a <myproc>
    8000370e:	5904                	lw	s1,48(a0)
    80003710:	413484b3          	sub	s1,s1,s3
    80003714:	0014b493          	seqz	s1,s1
    80003718:	bfc1                	j	800036e8 <holdingsleep+0x24>

000000008000371a <fileinit>:
#include "stat.h"
#include "proc.h"

struct devsw devsw[NDEV];

void fileinit(void) {}
    8000371a:	1141                	addi	sp,sp,-16
    8000371c:	e422                	sd	s0,8(sp)
    8000371e:	0800                	addi	s0,sp,16
    80003720:	6422                	ld	s0,8(sp)
    80003722:	0141                	addi	sp,sp,16
    80003724:	8082                	ret

0000000080003726 <filealloc>:

// Allocate a file structure.
struct file *filealloc(void) {
    80003726:	1101                	addi	sp,sp,-32
    80003728:	ec06                	sd	ra,24(sp)
    8000372a:	e822                	sd	s0,16(sp)
    8000372c:	e426                	sd	s1,8(sp)
    8000372e:	1000                	addi	s0,sp,32
  struct file *f;

  f = bd_malloc(sizeof(struct file));
    80003730:	04000513          	li	a0,64
    80003734:	00002097          	auipc	ra,0x2
    80003738:	04a080e7          	jalr	74(ra) # 8000577e <bd_malloc>
    8000373c:	84aa                	mv	s1,a0
  if (f) {
    8000373e:	c919                	beqz	a0,80003754 <filealloc+0x2e>
    f->ref = 1;
    80003740:	4785                	li	a5,1
    80003742:	cd5c                	sw	a5,28(a0)
    initlock(&f->lock, "file");
    80003744:	00005597          	auipc	a1,0x5
    80003748:	e9458593          	addi	a1,a1,-364 # 800085d8 <syscalls+0x238>
    8000374c:	00003097          	auipc	ra,0x3
    80003750:	3e0080e7          	jalr	992(ra) # 80006b2c <initlock>
  }

  return f;
}
    80003754:	8526                	mv	a0,s1
    80003756:	60e2                	ld	ra,24(sp)
    80003758:	6442                	ld	s0,16(sp)
    8000375a:	64a2                	ld	s1,8(sp)
    8000375c:	6105                	addi	sp,sp,32
    8000375e:	8082                	ret

0000000080003760 <filedup>:

// Increment ref count for file f.
struct file *filedup(struct file *f) {
    80003760:	1101                	addi	sp,sp,-32
    80003762:	ec06                	sd	ra,24(sp)
    80003764:	e822                	sd	s0,16(sp)
    80003766:	e426                	sd	s1,8(sp)
    80003768:	1000                	addi	s0,sp,32
    8000376a:	84aa                	mv	s1,a0
  acquire(&f->lock);
    8000376c:	00003097          	auipc	ra,0x3
    80003770:	450080e7          	jalr	1104(ra) # 80006bbc <acquire>
  if (f->ref < 1) {
    80003774:	4cdc                	lw	a5,28(s1)
    80003776:	00f05f63          	blez	a5,80003794 <filedup+0x34>
    panic("filedup");
  }
  f->ref++;
    8000377a:	2785                	addiw	a5,a5,1
    8000377c:	ccdc                	sw	a5,28(s1)
  release(&f->lock);
    8000377e:	8526                	mv	a0,s1
    80003780:	00003097          	auipc	ra,0x3
    80003784:	4ea080e7          	jalr	1258(ra) # 80006c6a <release>

  return f;
}
    80003788:	8526                	mv	a0,s1
    8000378a:	60e2                	ld	ra,24(sp)
    8000378c:	6442                	ld	s0,16(sp)
    8000378e:	64a2                	ld	s1,8(sp)
    80003790:	6105                	addi	sp,sp,32
    80003792:	8082                	ret
    panic("filedup");
    80003794:	00005517          	auipc	a0,0x5
    80003798:	e4c50513          	addi	a0,a0,-436 # 800085e0 <syscalls+0x240>
    8000379c:	00003097          	auipc	ra,0x3
    800037a0:	ee8080e7          	jalr	-280(ra) # 80006684 <panic>

00000000800037a4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f) {
    800037a4:	1101                	addi	sp,sp,-32
    800037a6:	ec06                	sd	ra,24(sp)
    800037a8:	e822                	sd	s0,16(sp)
    800037aa:	e426                	sd	s1,8(sp)
    800037ac:	1000                	addi	s0,sp,32
    800037ae:	84aa                	mv	s1,a0
  acquire(&f->lock);
    800037b0:	00003097          	auipc	ra,0x3
    800037b4:	40c080e7          	jalr	1036(ra) # 80006bbc <acquire>
  if (f->ref < 1) panic("fileclose");
    800037b8:	4cdc                	lw	a5,28(s1)
    800037ba:	02f05f63          	blez	a5,800037f8 <fileclose+0x54>
  if (--f->ref > 0) {
    800037be:	37fd                	addiw	a5,a5,-1
    800037c0:	0007871b          	sext.w	a4,a5
    800037c4:	ccdc                	sw	a5,28(s1)
    800037c6:	04e04163          	bgtz	a4,80003808 <fileclose+0x64>
    release(&f->lock);
    return;
  }
  release(&f->lock);
    800037ca:	8526                	mv	a0,s1
    800037cc:	00003097          	auipc	ra,0x3
    800037d0:	49e080e7          	jalr	1182(ra) # 80006c6a <release>

  if (f->type == FD_PIPE) {
    800037d4:	4c9c                	lw	a5,24(s1)
    800037d6:	4705                	li	a4,1
    800037d8:	02e78e63          	beq	a5,a4,80003814 <fileclose+0x70>
    pipeclose(f->pipe, f->writable);
  } else if (f->type == FD_INODE || f->type == FD_DEVICE) {
    800037dc:	37f9                	addiw	a5,a5,-2
    800037de:	4705                	li	a4,1
    800037e0:	04f77263          	bgeu	a4,a5,80003824 <fileclose+0x80>
    begin_op();
    iput(f->ip);
    end_op();
  }

  bd_free(f);
    800037e4:	8526                	mv	a0,s1
    800037e6:	00002097          	auipc	ra,0x2
    800037ea:	196080e7          	jalr	406(ra) # 8000597c <bd_free>
}
    800037ee:	60e2                	ld	ra,24(sp)
    800037f0:	6442                	ld	s0,16(sp)
    800037f2:	64a2                	ld	s1,8(sp)
    800037f4:	6105                	addi	sp,sp,32
    800037f6:	8082                	ret
  if (f->ref < 1) panic("fileclose");
    800037f8:	00005517          	auipc	a0,0x5
    800037fc:	df050513          	addi	a0,a0,-528 # 800085e8 <syscalls+0x248>
    80003800:	00003097          	auipc	ra,0x3
    80003804:	e84080e7          	jalr	-380(ra) # 80006684 <panic>
    release(&f->lock);
    80003808:	8526                	mv	a0,s1
    8000380a:	00003097          	auipc	ra,0x3
    8000380e:	460080e7          	jalr	1120(ra) # 80006c6a <release>
    return;
    80003812:	bff1                	j	800037ee <fileclose+0x4a>
    pipeclose(f->pipe, f->writable);
    80003814:	0214c583          	lbu	a1,33(s1)
    80003818:	7488                	ld	a0,40(s1)
    8000381a:	00000097          	auipc	ra,0x0
    8000381e:	368080e7          	jalr	872(ra) # 80003b82 <pipeclose>
    80003822:	b7c9                	j	800037e4 <fileclose+0x40>
    begin_op();
    80003824:	00000097          	auipc	ra,0x0
    80003828:	b12080e7          	jalr	-1262(ra) # 80003336 <begin_op>
    iput(f->ip);
    8000382c:	7888                	ld	a0,48(s1)
    8000382e:	fffff097          	auipc	ra,0xfffff
    80003832:	2f6080e7          	jalr	758(ra) # 80002b24 <iput>
    end_op();
    80003836:	00000097          	auipc	ra,0x0
    8000383a:	b7e080e7          	jalr	-1154(ra) # 800033b4 <end_op>
    8000383e:	b75d                	j	800037e4 <fileclose+0x40>

0000000080003840 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr) {
    80003840:	715d                	addi	sp,sp,-80
    80003842:	e486                	sd	ra,72(sp)
    80003844:	e0a2                	sd	s0,64(sp)
    80003846:	fc26                	sd	s1,56(sp)
    80003848:	f84a                	sd	s2,48(sp)
    8000384a:	f44e                	sd	s3,40(sp)
    8000384c:	0880                	addi	s0,sp,80
    8000384e:	84aa                	mv	s1,a0
    80003850:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003852:	ffffd097          	auipc	ra,0xffffd
    80003856:	418080e7          	jalr	1048(ra) # 80000c6a <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    8000385a:	4c9c                	lw	a5,24(s1)
    8000385c:	37f9                	addiw	a5,a5,-2
    8000385e:	4705                	li	a4,1
    80003860:	04f76763          	bltu	a4,a5,800038ae <filestat+0x6e>
    80003864:	892a                	mv	s2,a0
    ilock(f->ip);
    80003866:	7888                	ld	a0,48(s1)
    80003868:	fffff097          	auipc	ra,0xfffff
    8000386c:	102080e7          	jalr	258(ra) # 8000296a <ilock>
    stati(f->ip, &st);
    80003870:	fb840593          	addi	a1,s0,-72
    80003874:	7888                	ld	a0,48(s1)
    80003876:	fffff097          	auipc	ra,0xfffff
    8000387a:	37e080e7          	jalr	894(ra) # 80002bf4 <stati>
    iunlock(f->ip);
    8000387e:	7888                	ld	a0,48(s1)
    80003880:	fffff097          	auipc	ra,0xfffff
    80003884:	1ac080e7          	jalr	428(ra) # 80002a2c <iunlock>
    if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0) return -1;
    80003888:	46e1                	li	a3,24
    8000388a:	fb840613          	addi	a2,s0,-72
    8000388e:	85ce                	mv	a1,s3
    80003890:	05093503          	ld	a0,80(s2)
    80003894:	ffffd097          	auipc	ra,0xffffd
    80003898:	17c080e7          	jalr	380(ra) # 80000a10 <copyout>
    8000389c:	41f5551b          	sraiw	a0,a0,0x1f
    return 0;
  }
  return -1;
}
    800038a0:	60a6                	ld	ra,72(sp)
    800038a2:	6406                	ld	s0,64(sp)
    800038a4:	74e2                	ld	s1,56(sp)
    800038a6:	7942                	ld	s2,48(sp)
    800038a8:	79a2                	ld	s3,40(sp)
    800038aa:	6161                	addi	sp,sp,80
    800038ac:	8082                	ret
  return -1;
    800038ae:	557d                	li	a0,-1
    800038b0:	bfc5                	j	800038a0 <filestat+0x60>

00000000800038b2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n) {
    800038b2:	7179                	addi	sp,sp,-48
    800038b4:	f406                	sd	ra,40(sp)
    800038b6:	f022                	sd	s0,32(sp)
    800038b8:	ec26                	sd	s1,24(sp)
    800038ba:	e84a                	sd	s2,16(sp)
    800038bc:	e44e                	sd	s3,8(sp)
    800038be:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0) return -1;
    800038c0:	02054783          	lbu	a5,32(a0)
    800038c4:	c3d5                	beqz	a5,80003968 <fileread+0xb6>
    800038c6:	84aa                	mv	s1,a0
    800038c8:	89ae                	mv	s3,a1
    800038ca:	8932                	mv	s2,a2

  if (f->type == FD_PIPE) {
    800038cc:	4d1c                	lw	a5,24(a0)
    800038ce:	4705                	li	a4,1
    800038d0:	04e78963          	beq	a5,a4,80003922 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    800038d4:	470d                	li	a4,3
    800038d6:	04e78d63          	beq	a5,a4,80003930 <fileread+0x7e>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    800038da:	4709                	li	a4,2
    800038dc:	06e79e63          	bne	a5,a4,80003958 <fileread+0xa6>
    ilock(f->ip);
    800038e0:	7908                	ld	a0,48(a0)
    800038e2:	fffff097          	auipc	ra,0xfffff
    800038e6:	088080e7          	jalr	136(ra) # 8000296a <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0) f->off += r;
    800038ea:	874a                	mv	a4,s2
    800038ec:	5c94                	lw	a3,56(s1)
    800038ee:	864e                	mv	a2,s3
    800038f0:	4585                	li	a1,1
    800038f2:	7888                	ld	a0,48(s1)
    800038f4:	fffff097          	auipc	ra,0xfffff
    800038f8:	32a080e7          	jalr	810(ra) # 80002c1e <readi>
    800038fc:	892a                	mv	s2,a0
    800038fe:	00a05563          	blez	a0,80003908 <fileread+0x56>
    80003902:	5c9c                	lw	a5,56(s1)
    80003904:	9fa9                	addw	a5,a5,a0
    80003906:	dc9c                	sw	a5,56(s1)
    iunlock(f->ip);
    80003908:	7888                	ld	a0,48(s1)
    8000390a:	fffff097          	auipc	ra,0xfffff
    8000390e:	122080e7          	jalr	290(ra) # 80002a2c <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003912:	854a                	mv	a0,s2
    80003914:	70a2                	ld	ra,40(sp)
    80003916:	7402                	ld	s0,32(sp)
    80003918:	64e2                	ld	s1,24(sp)
    8000391a:	6942                	ld	s2,16(sp)
    8000391c:	69a2                	ld	s3,8(sp)
    8000391e:	6145                	addi	sp,sp,48
    80003920:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003922:	7508                	ld	a0,40(a0)
    80003924:	00000097          	auipc	ra,0x0
    80003928:	3c6080e7          	jalr	966(ra) # 80003cea <piperead>
    8000392c:	892a                	mv	s2,a0
    8000392e:	b7d5                	j	80003912 <fileread+0x60>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    80003930:	03c51783          	lh	a5,60(a0)
    80003934:	03079693          	slli	a3,a5,0x30
    80003938:	92c1                	srli	a3,a3,0x30
    8000393a:	4725                	li	a4,9
    8000393c:	02d76863          	bltu	a4,a3,8000396c <fileread+0xba>
    80003940:	0792                	slli	a5,a5,0x4
    80003942:	0000f717          	auipc	a4,0xf
    80003946:	77e70713          	addi	a4,a4,1918 # 800130c0 <devsw>
    8000394a:	97ba                	add	a5,a5,a4
    8000394c:	639c                	ld	a5,0(a5)
    8000394e:	c38d                	beqz	a5,80003970 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003950:	4505                	li	a0,1
    80003952:	9782                	jalr	a5
    80003954:	892a                	mv	s2,a0
    80003956:	bf75                	j	80003912 <fileread+0x60>
    panic("fileread");
    80003958:	00005517          	auipc	a0,0x5
    8000395c:	ca050513          	addi	a0,a0,-864 # 800085f8 <syscalls+0x258>
    80003960:	00003097          	auipc	ra,0x3
    80003964:	d24080e7          	jalr	-732(ra) # 80006684 <panic>
  if (f->readable == 0) return -1;
    80003968:	597d                	li	s2,-1
    8000396a:	b765                	j	80003912 <fileread+0x60>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read) return -1;
    8000396c:	597d                	li	s2,-1
    8000396e:	b755                	j	80003912 <fileread+0x60>
    80003970:	597d                	li	s2,-1
    80003972:	b745                	j	80003912 <fileread+0x60>

0000000080003974 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n) {
    80003974:	715d                	addi	sp,sp,-80
    80003976:	e486                	sd	ra,72(sp)
    80003978:	e0a2                	sd	s0,64(sp)
    8000397a:	fc26                	sd	s1,56(sp)
    8000397c:	f84a                	sd	s2,48(sp)
    8000397e:	f44e                	sd	s3,40(sp)
    80003980:	f052                	sd	s4,32(sp)
    80003982:	ec56                	sd	s5,24(sp)
    80003984:	e85a                	sd	s6,16(sp)
    80003986:	e45e                	sd	s7,8(sp)
    80003988:	e062                	sd	s8,0(sp)
    8000398a:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if (f->writable == 0) return -1;
    8000398c:	02154783          	lbu	a5,33(a0)
    80003990:	10078663          	beqz	a5,80003a9c <filewrite+0x128>
    80003994:	892a                	mv	s2,a0
    80003996:	8b2e                	mv	s6,a1
    80003998:	8a32                	mv	s4,a2

  if (f->type == FD_PIPE) {
    8000399a:	4d1c                	lw	a5,24(a0)
    8000399c:	4705                	li	a4,1
    8000399e:	02e78263          	beq	a5,a4,800039c2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    800039a2:	470d                	li	a4,3
    800039a4:	02e78663          	beq	a5,a4,800039d0 <filewrite+0x5c>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    800039a8:	4709                	li	a4,2
    800039aa:	0ee79163          	bne	a5,a4,80003a8c <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    800039ae:	0ac05d63          	blez	a2,80003a68 <filewrite+0xf4>
    int i = 0;
    800039b2:	4981                	li	s3,0
    800039b4:	6b85                	lui	s7,0x1
    800039b6:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800039ba:	6c05                	lui	s8,0x1
    800039bc:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800039c0:	a861                	j	80003a58 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    800039c2:	7508                	ld	a0,40(a0)
    800039c4:	00000097          	auipc	ra,0x0
    800039c8:	22e080e7          	jalr	558(ra) # 80003bf2 <pipewrite>
    800039cc:	8a2a                	mv	s4,a0
    800039ce:	a045                	j	80003a6e <filewrite+0xfa>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    800039d0:	03c51783          	lh	a5,60(a0)
    800039d4:	03079693          	slli	a3,a5,0x30
    800039d8:	92c1                	srli	a3,a3,0x30
    800039da:	4725                	li	a4,9
    800039dc:	0cd76263          	bltu	a4,a3,80003aa0 <filewrite+0x12c>
    800039e0:	0792                	slli	a5,a5,0x4
    800039e2:	0000f717          	auipc	a4,0xf
    800039e6:	6de70713          	addi	a4,a4,1758 # 800130c0 <devsw>
    800039ea:	97ba                	add	a5,a5,a4
    800039ec:	679c                	ld	a5,8(a5)
    800039ee:	cbdd                	beqz	a5,80003aa4 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    800039f0:	4505                	li	a0,1
    800039f2:	9782                	jalr	a5
    800039f4:	8a2a                	mv	s4,a0
    800039f6:	a8a5                	j	80003a6e <filewrite+0xfa>
    800039f8:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if (n1 > max) n1 = max;

      begin_op();
    800039fc:	00000097          	auipc	ra,0x0
    80003a00:	93a080e7          	jalr	-1734(ra) # 80003336 <begin_op>
      ilock(f->ip);
    80003a04:	03093503          	ld	a0,48(s2)
    80003a08:	fffff097          	auipc	ra,0xfffff
    80003a0c:	f62080e7          	jalr	-158(ra) # 8000296a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0) f->off += r;
    80003a10:	8756                	mv	a4,s5
    80003a12:	03892683          	lw	a3,56(s2)
    80003a16:	01698633          	add	a2,s3,s6
    80003a1a:	4585                	li	a1,1
    80003a1c:	03093503          	ld	a0,48(s2)
    80003a20:	fffff097          	auipc	ra,0xfffff
    80003a24:	2f6080e7          	jalr	758(ra) # 80002d16 <writei>
    80003a28:	84aa                	mv	s1,a0
    80003a2a:	00a05763          	blez	a0,80003a38 <filewrite+0xc4>
    80003a2e:	03892783          	lw	a5,56(s2)
    80003a32:	9fa9                	addw	a5,a5,a0
    80003a34:	02f92c23          	sw	a5,56(s2)
      iunlock(f->ip);
    80003a38:	03093503          	ld	a0,48(s2)
    80003a3c:	fffff097          	auipc	ra,0xfffff
    80003a40:	ff0080e7          	jalr	-16(ra) # 80002a2c <iunlock>
      end_op();
    80003a44:	00000097          	auipc	ra,0x0
    80003a48:	970080e7          	jalr	-1680(ra) # 800033b4 <end_op>

      if (r != n1) {
    80003a4c:	009a9f63          	bne	s5,s1,80003a6a <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003a50:	013489bb          	addw	s3,s1,s3
    while (i < n) {
    80003a54:	0149db63          	bge	s3,s4,80003a6a <filewrite+0xf6>
      int n1 = n - i;
    80003a58:	413a04bb          	subw	s1,s4,s3
    80003a5c:	0004879b          	sext.w	a5,s1
    80003a60:	f8fbdce3          	bge	s7,a5,800039f8 <filewrite+0x84>
    80003a64:	84e2                	mv	s1,s8
    80003a66:	bf49                	j	800039f8 <filewrite+0x84>
    int i = 0;
    80003a68:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003a6a:	013a1f63          	bne	s4,s3,80003a88 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
    80003a6e:	8552                	mv	a0,s4
    80003a70:	60a6                	ld	ra,72(sp)
    80003a72:	6406                	ld	s0,64(sp)
    80003a74:	74e2                	ld	s1,56(sp)
    80003a76:	7942                	ld	s2,48(sp)
    80003a78:	79a2                	ld	s3,40(sp)
    80003a7a:	7a02                	ld	s4,32(sp)
    80003a7c:	6ae2                	ld	s5,24(sp)
    80003a7e:	6b42                	ld	s6,16(sp)
    80003a80:	6ba2                	ld	s7,8(sp)
    80003a82:	6c02                	ld	s8,0(sp)
    80003a84:	6161                	addi	sp,sp,80
    80003a86:	8082                	ret
    ret = (i == n ? n : -1);
    80003a88:	5a7d                	li	s4,-1
    80003a8a:	b7d5                	j	80003a6e <filewrite+0xfa>
    panic("filewrite");
    80003a8c:	00005517          	auipc	a0,0x5
    80003a90:	b7c50513          	addi	a0,a0,-1156 # 80008608 <syscalls+0x268>
    80003a94:	00003097          	auipc	ra,0x3
    80003a98:	bf0080e7          	jalr	-1040(ra) # 80006684 <panic>
  if (f->writable == 0) return -1;
    80003a9c:	5a7d                	li	s4,-1
    80003a9e:	bfc1                	j	80003a6e <filewrite+0xfa>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write) return -1;
    80003aa0:	5a7d                	li	s4,-1
    80003aa2:	b7f1                	j	80003a6e <filewrite+0xfa>
    80003aa4:	5a7d                	li	s4,-1
    80003aa6:	b7e1                	j	80003a6e <filewrite+0xfa>

0000000080003aa8 <pipealloc>:
  uint nwrite;    // number of bytes written
  int readopen;   // read fd is still open
  int writeopen;  // write fd is still open
};

int pipealloc(struct file **f0, struct file **f1) {
    80003aa8:	7179                	addi	sp,sp,-48
    80003aaa:	f406                	sd	ra,40(sp)
    80003aac:	f022                	sd	s0,32(sp)
    80003aae:	ec26                	sd	s1,24(sp)
    80003ab0:	e84a                	sd	s2,16(sp)
    80003ab2:	e44e                	sd	s3,8(sp)
    80003ab4:	e052                	sd	s4,0(sp)
    80003ab6:	1800                	addi	s0,sp,48
    80003ab8:	84aa                	mv	s1,a0
    80003aba:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003abc:	0005b023          	sd	zero,0(a1)
    80003ac0:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0) goto bad;
    80003ac4:	00000097          	auipc	ra,0x0
    80003ac8:	c62080e7          	jalr	-926(ra) # 80003726 <filealloc>
    80003acc:	e088                	sd	a0,0(s1)
    80003ace:	c551                	beqz	a0,80003b5a <pipealloc+0xb2>
    80003ad0:	00000097          	auipc	ra,0x0
    80003ad4:	c56080e7          	jalr	-938(ra) # 80003726 <filealloc>
    80003ad8:	00aa3023          	sd	a0,0(s4)
    80003adc:	c92d                	beqz	a0,80003b4e <pipealloc+0xa6>
  if ((pi = (struct pipe *)kalloc()) == 0) goto bad;
    80003ade:	ffffc097          	auipc	ra,0xffffc
    80003ae2:	57e080e7          	jalr	1406(ra) # 8000005c <kalloc>
    80003ae6:	892a                	mv	s2,a0
    80003ae8:	c125                	beqz	a0,80003b48 <pipealloc+0xa0>
  pi->readopen = 1;
    80003aea:	4985                	li	s3,1
    80003aec:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003af0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003af4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003af8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003afc:	00005597          	auipc	a1,0x5
    80003b00:	b1c58593          	addi	a1,a1,-1252 # 80008618 <syscalls+0x278>
    80003b04:	00003097          	auipc	ra,0x3
    80003b08:	028080e7          	jalr	40(ra) # 80006b2c <initlock>
  (*f0)->type = FD_PIPE;
    80003b0c:	609c                	ld	a5,0(s1)
    80003b0e:	0137ac23          	sw	s3,24(a5)
  (*f0)->readable = 1;
    80003b12:	609c                	ld	a5,0(s1)
    80003b14:	03378023          	sb	s3,32(a5)
  (*f0)->writable = 0;
    80003b18:	609c                	ld	a5,0(s1)
    80003b1a:	020780a3          	sb	zero,33(a5)
  (*f0)->pipe = pi;
    80003b1e:	609c                	ld	a5,0(s1)
    80003b20:	0327b423          	sd	s2,40(a5)
  (*f1)->type = FD_PIPE;
    80003b24:	000a3783          	ld	a5,0(s4)
    80003b28:	0137ac23          	sw	s3,24(a5)
  (*f1)->readable = 0;
    80003b2c:	000a3783          	ld	a5,0(s4)
    80003b30:	02078023          	sb	zero,32(a5)
  (*f1)->writable = 1;
    80003b34:	000a3783          	ld	a5,0(s4)
    80003b38:	033780a3          	sb	s3,33(a5)
  (*f1)->pipe = pi;
    80003b3c:	000a3783          	ld	a5,0(s4)
    80003b40:	0327b423          	sd	s2,40(a5)
  return 0;
    80003b44:	4501                	li	a0,0
    80003b46:	a025                	j	80003b6e <pipealloc+0xc6>

bad:
  if (pi) kfree((char *)pi);
  if (*f0) fileclose(*f0);
    80003b48:	6088                	ld	a0,0(s1)
    80003b4a:	e501                	bnez	a0,80003b52 <pipealloc+0xaa>
    80003b4c:	a039                	j	80003b5a <pipealloc+0xb2>
    80003b4e:	6088                	ld	a0,0(s1)
    80003b50:	c51d                	beqz	a0,80003b7e <pipealloc+0xd6>
    80003b52:	00000097          	auipc	ra,0x0
    80003b56:	c52080e7          	jalr	-942(ra) # 800037a4 <fileclose>
  if (*f1) fileclose(*f1);
    80003b5a:	000a3783          	ld	a5,0(s4)
  return -1;
    80003b5e:	557d                	li	a0,-1
  if (*f1) fileclose(*f1);
    80003b60:	c799                	beqz	a5,80003b6e <pipealloc+0xc6>
    80003b62:	853e                	mv	a0,a5
    80003b64:	00000097          	auipc	ra,0x0
    80003b68:	c40080e7          	jalr	-960(ra) # 800037a4 <fileclose>
  return -1;
    80003b6c:	557d                	li	a0,-1
}
    80003b6e:	70a2                	ld	ra,40(sp)
    80003b70:	7402                	ld	s0,32(sp)
    80003b72:	64e2                	ld	s1,24(sp)
    80003b74:	6942                	ld	s2,16(sp)
    80003b76:	69a2                	ld	s3,8(sp)
    80003b78:	6a02                	ld	s4,0(sp)
    80003b7a:	6145                	addi	sp,sp,48
    80003b7c:	8082                	ret
  return -1;
    80003b7e:	557d                	li	a0,-1
    80003b80:	b7fd                	j	80003b6e <pipealloc+0xc6>

0000000080003b82 <pipeclose>:

void pipeclose(struct pipe *pi, int writable) {
    80003b82:	1101                	addi	sp,sp,-32
    80003b84:	ec06                	sd	ra,24(sp)
    80003b86:	e822                	sd	s0,16(sp)
    80003b88:	e426                	sd	s1,8(sp)
    80003b8a:	e04a                	sd	s2,0(sp)
    80003b8c:	1000                	addi	s0,sp,32
    80003b8e:	84aa                	mv	s1,a0
    80003b90:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003b92:	00003097          	auipc	ra,0x3
    80003b96:	02a080e7          	jalr	42(ra) # 80006bbc <acquire>
  if (writable) {
    80003b9a:	02090d63          	beqz	s2,80003bd4 <pipeclose+0x52>
    pi->writeopen = 0;
    80003b9e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ba2:	21848513          	addi	a0,s1,536
    80003ba6:	ffffe097          	auipc	ra,0xffffe
    80003baa:	808080e7          	jalr	-2040(ra) # 800013ae <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    80003bae:	2204b783          	ld	a5,544(s1)
    80003bb2:	eb95                	bnez	a5,80003be6 <pipeclose+0x64>
    release(&pi->lock);
    80003bb4:	8526                	mv	a0,s1
    80003bb6:	00003097          	auipc	ra,0x3
    80003bba:	0b4080e7          	jalr	180(ra) # 80006c6a <release>
    kfree((char *)pi);
    80003bbe:	8526                	mv	a0,s1
    80003bc0:	ffffc097          	auipc	ra,0xffffc
    80003bc4:	484080e7          	jalr	1156(ra) # 80000044 <kfree>
  } else
    release(&pi->lock);
}
    80003bc8:	60e2                	ld	ra,24(sp)
    80003bca:	6442                	ld	s0,16(sp)
    80003bcc:	64a2                	ld	s1,8(sp)
    80003bce:	6902                	ld	s2,0(sp)
    80003bd0:	6105                	addi	sp,sp,32
    80003bd2:	8082                	ret
    pi->readopen = 0;
    80003bd4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003bd8:	21c48513          	addi	a0,s1,540
    80003bdc:	ffffd097          	auipc	ra,0xffffd
    80003be0:	7d2080e7          	jalr	2002(ra) # 800013ae <wakeup>
    80003be4:	b7e9                	j	80003bae <pipeclose+0x2c>
    release(&pi->lock);
    80003be6:	8526                	mv	a0,s1
    80003be8:	00003097          	auipc	ra,0x3
    80003bec:	082080e7          	jalr	130(ra) # 80006c6a <release>
}
    80003bf0:	bfe1                	j	80003bc8 <pipeclose+0x46>

0000000080003bf2 <pipewrite>:

int pipewrite(struct pipe *pi, uint64 addr, int n) {
    80003bf2:	711d                	addi	sp,sp,-96
    80003bf4:	ec86                	sd	ra,88(sp)
    80003bf6:	e8a2                	sd	s0,80(sp)
    80003bf8:	e4a6                	sd	s1,72(sp)
    80003bfa:	e0ca                	sd	s2,64(sp)
    80003bfc:	fc4e                	sd	s3,56(sp)
    80003bfe:	f852                	sd	s4,48(sp)
    80003c00:	f456                	sd	s5,40(sp)
    80003c02:	f05a                	sd	s6,32(sp)
    80003c04:	ec5e                	sd	s7,24(sp)
    80003c06:	e862                	sd	s8,16(sp)
    80003c08:	1080                	addi	s0,sp,96
    80003c0a:	84aa                	mv	s1,a0
    80003c0c:	8aae                	mv	s5,a1
    80003c0e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003c10:	ffffd097          	auipc	ra,0xffffd
    80003c14:	05a080e7          	jalr	90(ra) # 80000c6a <myproc>
    80003c18:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003c1a:	8526                	mv	a0,s1
    80003c1c:	00003097          	auipc	ra,0x3
    80003c20:	fa0080e7          	jalr	-96(ra) # 80006bbc <acquire>
  while (i < n) {
    80003c24:	0b405663          	blez	s4,80003cd0 <pipewrite+0xde>
  int i = 0;
    80003c28:	4901                	li	s2,0
    if (pi->nwrite == pi->nread + PIPESIZE) {  // DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1) break;
    80003c2a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003c2c:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003c30:	21c48b93          	addi	s7,s1,540
    80003c34:	a089                	j	80003c76 <pipewrite+0x84>
      release(&pi->lock);
    80003c36:	8526                	mv	a0,s1
    80003c38:	00003097          	auipc	ra,0x3
    80003c3c:	032080e7          	jalr	50(ra) # 80006c6a <release>
      return -1;
    80003c40:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003c42:	854a                	mv	a0,s2
    80003c44:	60e6                	ld	ra,88(sp)
    80003c46:	6446                	ld	s0,80(sp)
    80003c48:	64a6                	ld	s1,72(sp)
    80003c4a:	6906                	ld	s2,64(sp)
    80003c4c:	79e2                	ld	s3,56(sp)
    80003c4e:	7a42                	ld	s4,48(sp)
    80003c50:	7aa2                	ld	s5,40(sp)
    80003c52:	7b02                	ld	s6,32(sp)
    80003c54:	6be2                	ld	s7,24(sp)
    80003c56:	6c42                	ld	s8,16(sp)
    80003c58:	6125                	addi	sp,sp,96
    80003c5a:	8082                	ret
      wakeup(&pi->nread);
    80003c5c:	8562                	mv	a0,s8
    80003c5e:	ffffd097          	auipc	ra,0xffffd
    80003c62:	750080e7          	jalr	1872(ra) # 800013ae <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003c66:	85a6                	mv	a1,s1
    80003c68:	855e                	mv	a0,s7
    80003c6a:	ffffd097          	auipc	ra,0xffffd
    80003c6e:	6e0080e7          	jalr	1760(ra) # 8000134a <sleep>
  while (i < n) {
    80003c72:	07495063          	bge	s2,s4,80003cd2 <pipewrite+0xe0>
    if (pi->readopen == 0 || killed(pr)) {
    80003c76:	2204a783          	lw	a5,544(s1)
    80003c7a:	dfd5                	beqz	a5,80003c36 <pipewrite+0x44>
    80003c7c:	854e                	mv	a0,s3
    80003c7e:	ffffe097          	auipc	ra,0xffffe
    80003c82:	9a6080e7          	jalr	-1626(ra) # 80001624 <killed>
    80003c86:	f945                	bnez	a0,80003c36 <pipewrite+0x44>
    if (pi->nwrite == pi->nread + PIPESIZE) {  // DOC: pipewrite-full
    80003c88:	2184a783          	lw	a5,536(s1)
    80003c8c:	21c4a703          	lw	a4,540(s1)
    80003c90:	2007879b          	addiw	a5,a5,512
    80003c94:	fcf704e3          	beq	a4,a5,80003c5c <pipewrite+0x6a>
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1) break;
    80003c98:	4685                	li	a3,1
    80003c9a:	01590633          	add	a2,s2,s5
    80003c9e:	faf40593          	addi	a1,s0,-81
    80003ca2:	0509b503          	ld	a0,80(s3)
    80003ca6:	ffffd097          	auipc	ra,0xffffd
    80003caa:	df6080e7          	jalr	-522(ra) # 80000a9c <copyin>
    80003cae:	03650263          	beq	a0,s6,80003cd2 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003cb2:	21c4a783          	lw	a5,540(s1)
    80003cb6:	0017871b          	addiw	a4,a5,1
    80003cba:	20e4ae23          	sw	a4,540(s1)
    80003cbe:	1ff7f793          	andi	a5,a5,511
    80003cc2:	97a6                	add	a5,a5,s1
    80003cc4:	faf44703          	lbu	a4,-81(s0)
    80003cc8:	00e78c23          	sb	a4,24(a5)
      i++;
    80003ccc:	2905                	addiw	s2,s2,1
    80003cce:	b755                	j	80003c72 <pipewrite+0x80>
  int i = 0;
    80003cd0:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003cd2:	21848513          	addi	a0,s1,536
    80003cd6:	ffffd097          	auipc	ra,0xffffd
    80003cda:	6d8080e7          	jalr	1752(ra) # 800013ae <wakeup>
  release(&pi->lock);
    80003cde:	8526                	mv	a0,s1
    80003ce0:	00003097          	auipc	ra,0x3
    80003ce4:	f8a080e7          	jalr	-118(ra) # 80006c6a <release>
  return i;
    80003ce8:	bfa9                	j	80003c42 <pipewrite+0x50>

0000000080003cea <piperead>:

int piperead(struct pipe *pi, uint64 addr, int n) {
    80003cea:	715d                	addi	sp,sp,-80
    80003cec:	e486                	sd	ra,72(sp)
    80003cee:	e0a2                	sd	s0,64(sp)
    80003cf0:	fc26                	sd	s1,56(sp)
    80003cf2:	f84a                	sd	s2,48(sp)
    80003cf4:	f44e                	sd	s3,40(sp)
    80003cf6:	f052                	sd	s4,32(sp)
    80003cf8:	ec56                	sd	s5,24(sp)
    80003cfa:	e85a                	sd	s6,16(sp)
    80003cfc:	0880                	addi	s0,sp,80
    80003cfe:	84aa                	mv	s1,a0
    80003d00:	892e                	mv	s2,a1
    80003d02:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003d04:	ffffd097          	auipc	ra,0xffffd
    80003d08:	f66080e7          	jalr	-154(ra) # 80000c6a <myproc>
    80003d0c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003d0e:	8526                	mv	a0,s1
    80003d10:	00003097          	auipc	ra,0x3
    80003d14:	eac080e7          	jalr	-340(ra) # 80006bbc <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    80003d18:	2184a703          	lw	a4,536(s1)
    80003d1c:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock);  // DOC: piperead-sleep
    80003d20:	21848993          	addi	s3,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    80003d24:	02f71763          	bne	a4,a5,80003d52 <piperead+0x68>
    80003d28:	2244a783          	lw	a5,548(s1)
    80003d2c:	c39d                	beqz	a5,80003d52 <piperead+0x68>
    if (killed(pr)) {
    80003d2e:	8552                	mv	a0,s4
    80003d30:	ffffe097          	auipc	ra,0xffffe
    80003d34:	8f4080e7          	jalr	-1804(ra) # 80001624 <killed>
    80003d38:	e949                	bnez	a0,80003dca <piperead+0xe0>
    sleep(&pi->nread, &pi->lock);  // DOC: piperead-sleep
    80003d3a:	85a6                	mv	a1,s1
    80003d3c:	854e                	mv	a0,s3
    80003d3e:	ffffd097          	auipc	ra,0xffffd
    80003d42:	60c080e7          	jalr	1548(ra) # 8000134a <sleep>
  while (pi->nread == pi->nwrite && pi->writeopen) {  // DOC: pipe-empty
    80003d46:	2184a703          	lw	a4,536(s1)
    80003d4a:	21c4a783          	lw	a5,540(s1)
    80003d4e:	fcf70de3          	beq	a4,a5,80003d28 <piperead+0x3e>
  }
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    80003d52:	4981                	li	s3,0
    if (pi->nread == pi->nwrite) break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) break;
    80003d54:	5b7d                	li	s6,-1
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    80003d56:	05505463          	blez	s5,80003d9e <piperead+0xb4>
    if (pi->nread == pi->nwrite) break;
    80003d5a:	2184a783          	lw	a5,536(s1)
    80003d5e:	21c4a703          	lw	a4,540(s1)
    80003d62:	02f70e63          	beq	a4,a5,80003d9e <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003d66:	0017871b          	addiw	a4,a5,1
    80003d6a:	20e4ac23          	sw	a4,536(s1)
    80003d6e:	1ff7f793          	andi	a5,a5,511
    80003d72:	97a6                	add	a5,a5,s1
    80003d74:	0187c783          	lbu	a5,24(a5)
    80003d78:	faf40fa3          	sb	a5,-65(s0)
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) break;
    80003d7c:	4685                	li	a3,1
    80003d7e:	fbf40613          	addi	a2,s0,-65
    80003d82:	85ca                	mv	a1,s2
    80003d84:	050a3503          	ld	a0,80(s4)
    80003d88:	ffffd097          	auipc	ra,0xffffd
    80003d8c:	c88080e7          	jalr	-888(ra) # 80000a10 <copyout>
    80003d90:	01650763          	beq	a0,s6,80003d9e <piperead+0xb4>
  for (i = 0; i < n; i++) {  // DOC: piperead-copy
    80003d94:	2985                	addiw	s3,s3,1
    80003d96:	0905                	addi	s2,s2,1
    80003d98:	fd3a91e3          	bne	s5,s3,80003d5a <piperead+0x70>
    80003d9c:	89d6                	mv	s3,s5
  }
  wakeup(&pi->nwrite);  // DOC: piperead-wakeup
    80003d9e:	21c48513          	addi	a0,s1,540
    80003da2:	ffffd097          	auipc	ra,0xffffd
    80003da6:	60c080e7          	jalr	1548(ra) # 800013ae <wakeup>
  release(&pi->lock);
    80003daa:	8526                	mv	a0,s1
    80003dac:	00003097          	auipc	ra,0x3
    80003db0:	ebe080e7          	jalr	-322(ra) # 80006c6a <release>
  return i;
}
    80003db4:	854e                	mv	a0,s3
    80003db6:	60a6                	ld	ra,72(sp)
    80003db8:	6406                	ld	s0,64(sp)
    80003dba:	74e2                	ld	s1,56(sp)
    80003dbc:	7942                	ld	s2,48(sp)
    80003dbe:	79a2                	ld	s3,40(sp)
    80003dc0:	7a02                	ld	s4,32(sp)
    80003dc2:	6ae2                	ld	s5,24(sp)
    80003dc4:	6b42                	ld	s6,16(sp)
    80003dc6:	6161                	addi	sp,sp,80
    80003dc8:	8082                	ret
      release(&pi->lock);
    80003dca:	8526                	mv	a0,s1
    80003dcc:	00003097          	auipc	ra,0x3
    80003dd0:	e9e080e7          	jalr	-354(ra) # 80006c6a <release>
      return -1;
    80003dd4:	59fd                	li	s3,-1
    80003dd6:	bff9                	j	80003db4 <piperead+0xca>

0000000080003dd8 <flags2perm>:
#include "defs.h"
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags) {
    80003dd8:	1141                	addi	sp,sp,-16
    80003dda:	e422                	sd	s0,8(sp)
    80003ddc:	0800                	addi	s0,sp,16
    80003dde:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1) perm = PTE_X;
    80003de0:	8905                	andi	a0,a0,1
    80003de2:	050e                	slli	a0,a0,0x3
  if (flags & 0x2) perm |= PTE_W;
    80003de4:	8b89                	andi	a5,a5,2
    80003de6:	c399                	beqz	a5,80003dec <flags2perm+0x14>
    80003de8:	00456513          	ori	a0,a0,4
  return perm;
}
    80003dec:	6422                	ld	s0,8(sp)
    80003dee:	0141                	addi	sp,sp,16
    80003df0:	8082                	ret

0000000080003df2 <exec>:

int exec(char *path, char **argv) {
    80003df2:	de010113          	addi	sp,sp,-544
    80003df6:	20113c23          	sd	ra,536(sp)
    80003dfa:	20813823          	sd	s0,528(sp)
    80003dfe:	20913423          	sd	s1,520(sp)
    80003e02:	21213023          	sd	s2,512(sp)
    80003e06:	ffce                	sd	s3,504(sp)
    80003e08:	fbd2                	sd	s4,496(sp)
    80003e0a:	f7d6                	sd	s5,488(sp)
    80003e0c:	f3da                	sd	s6,480(sp)
    80003e0e:	efde                	sd	s7,472(sp)
    80003e10:	ebe2                	sd	s8,464(sp)
    80003e12:	e7e6                	sd	s9,456(sp)
    80003e14:	e3ea                	sd	s10,448(sp)
    80003e16:	ff6e                	sd	s11,440(sp)
    80003e18:	1400                	addi	s0,sp,544
    80003e1a:	892a                	mv	s2,a0
    80003e1c:	dea43423          	sd	a0,-536(s0)
    80003e20:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003e24:	ffffd097          	auipc	ra,0xffffd
    80003e28:	e46080e7          	jalr	-442(ra) # 80000c6a <myproc>
    80003e2c:	84aa                	mv	s1,a0

  begin_op();
    80003e2e:	fffff097          	auipc	ra,0xfffff
    80003e32:	508080e7          	jalr	1288(ra) # 80003336 <begin_op>

  if ((ip = namei(path)) == 0) {
    80003e36:	854a                	mv	a0,s2
    80003e38:	fffff097          	auipc	ra,0xfffff
    80003e3c:	2de080e7          	jalr	734(ra) # 80003116 <namei>
    80003e40:	c93d                	beqz	a0,80003eb6 <exec+0xc4>
    80003e42:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003e44:	fffff097          	auipc	ra,0xfffff
    80003e48:	b26080e7          	jalr	-1242(ra) # 8000296a <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf)) goto bad;
    80003e4c:	04000713          	li	a4,64
    80003e50:	4681                	li	a3,0
    80003e52:	e5040613          	addi	a2,s0,-432
    80003e56:	4581                	li	a1,0
    80003e58:	8556                	mv	a0,s5
    80003e5a:	fffff097          	auipc	ra,0xfffff
    80003e5e:	dc4080e7          	jalr	-572(ra) # 80002c1e <readi>
    80003e62:	04000793          	li	a5,64
    80003e66:	00f51a63          	bne	a0,a5,80003e7a <exec+0x88>

  if (elf.magic != ELF_MAGIC) goto bad;
    80003e6a:	e5042703          	lw	a4,-432(s0)
    80003e6e:	464c47b7          	lui	a5,0x464c4
    80003e72:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003e76:	04f70663          	beq	a4,a5,80003ec2 <exec+0xd0>
  return argc;  // this ends up in a0, the first argument to main(argc, argv)

bad:
  if (pagetable) proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    80003e7a:	8556                	mv	a0,s5
    80003e7c:	fffff097          	auipc	ra,0xfffff
    80003e80:	d50080e7          	jalr	-688(ra) # 80002bcc <iunlockput>
    end_op();
    80003e84:	fffff097          	auipc	ra,0xfffff
    80003e88:	530080e7          	jalr	1328(ra) # 800033b4 <end_op>
  }
  return -1;
    80003e8c:	557d                	li	a0,-1
}
    80003e8e:	21813083          	ld	ra,536(sp)
    80003e92:	21013403          	ld	s0,528(sp)
    80003e96:	20813483          	ld	s1,520(sp)
    80003e9a:	20013903          	ld	s2,512(sp)
    80003e9e:	79fe                	ld	s3,504(sp)
    80003ea0:	7a5e                	ld	s4,496(sp)
    80003ea2:	7abe                	ld	s5,488(sp)
    80003ea4:	7b1e                	ld	s6,480(sp)
    80003ea6:	6bfe                	ld	s7,472(sp)
    80003ea8:	6c5e                	ld	s8,464(sp)
    80003eaa:	6cbe                	ld	s9,456(sp)
    80003eac:	6d1e                	ld	s10,448(sp)
    80003eae:	7dfa                	ld	s11,440(sp)
    80003eb0:	22010113          	addi	sp,sp,544
    80003eb4:	8082                	ret
    end_op();
    80003eb6:	fffff097          	auipc	ra,0xfffff
    80003eba:	4fe080e7          	jalr	1278(ra) # 800033b4 <end_op>
    return -1;
    80003ebe:	557d                	li	a0,-1
    80003ec0:	b7f9                	j	80003e8e <exec+0x9c>
  if ((pagetable = proc_pagetable(p)) == 0) goto bad;
    80003ec2:	8526                	mv	a0,s1
    80003ec4:	ffffd097          	auipc	ra,0xffffd
    80003ec8:	eb0080e7          	jalr	-336(ra) # 80000d74 <proc_pagetable>
    80003ecc:	8b2a                	mv	s6,a0
    80003ece:	d555                	beqz	a0,80003e7a <exec+0x88>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80003ed0:	e7042783          	lw	a5,-400(s0)
    80003ed4:	e8845703          	lhu	a4,-376(s0)
    80003ed8:	c735                	beqz	a4,80003f44 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003eda:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80003edc:	e0043423          	sd	zero,-504(s0)
    if (ph.vaddr % PGSIZE != 0) goto bad;
    80003ee0:	6a05                	lui	s4,0x1
    80003ee2:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80003ee6:	dee43023          	sd	a4,-544(s0)
static int loadseg(pagetable_t pagetable, uint64 va, struct inode *ip,
                   uint offset, uint sz) {
  uint i, n;
  uint64 pa;

  for (i = 0; i < sz; i += PGSIZE) {
    80003eea:	6d85                	lui	s11,0x1
    80003eec:	7d7d                	lui	s10,0xfffff
    80003eee:	ac3d                	j	8000412c <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if (pa == 0) panic("loadseg: address should exist");
    80003ef0:	00004517          	auipc	a0,0x4
    80003ef4:	73050513          	addi	a0,a0,1840 # 80008620 <syscalls+0x280>
    80003ef8:	00002097          	auipc	ra,0x2
    80003efc:	78c080e7          	jalr	1932(ra) # 80006684 <panic>
    if (sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n) return -1;
    80003f00:	874a                	mv	a4,s2
    80003f02:	009c86bb          	addw	a3,s9,s1
    80003f06:	4581                	li	a1,0
    80003f08:	8556                	mv	a0,s5
    80003f0a:	fffff097          	auipc	ra,0xfffff
    80003f0e:	d14080e7          	jalr	-748(ra) # 80002c1e <readi>
    80003f12:	2501                	sext.w	a0,a0
    80003f14:	1aa91963          	bne	s2,a0,800040c6 <exec+0x2d4>
  for (i = 0; i < sz; i += PGSIZE) {
    80003f18:	009d84bb          	addw	s1,s11,s1
    80003f1c:	013d09bb          	addw	s3,s10,s3
    80003f20:	1f74f663          	bgeu	s1,s7,8000410c <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    80003f24:	02049593          	slli	a1,s1,0x20
    80003f28:	9181                	srli	a1,a1,0x20
    80003f2a:	95e2                	add	a1,a1,s8
    80003f2c:	855a                	mv	a0,s6
    80003f2e:	ffffc097          	auipc	ra,0xffffc
    80003f32:	4d2080e7          	jalr	1234(ra) # 80000400 <walkaddr>
    80003f36:	862a                	mv	a2,a0
    if (pa == 0) panic("loadseg: address should exist");
    80003f38:	dd45                	beqz	a0,80003ef0 <exec+0xfe>
      n = PGSIZE;
    80003f3a:	8952                	mv	s2,s4
    if (sz - i < PGSIZE)
    80003f3c:	fd49f2e3          	bgeu	s3,s4,80003f00 <exec+0x10e>
      n = sz - i;
    80003f40:	894e                	mv	s2,s3
    80003f42:	bf7d                	j	80003f00 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003f44:	4901                	li	s2,0
  iunlockput(ip);
    80003f46:	8556                	mv	a0,s5
    80003f48:	fffff097          	auipc	ra,0xfffff
    80003f4c:	c84080e7          	jalr	-892(ra) # 80002bcc <iunlockput>
  end_op();
    80003f50:	fffff097          	auipc	ra,0xfffff
    80003f54:	464080e7          	jalr	1124(ra) # 800033b4 <end_op>
  p = myproc();
    80003f58:	ffffd097          	auipc	ra,0xffffd
    80003f5c:	d12080e7          	jalr	-750(ra) # 80000c6a <myproc>
    80003f60:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80003f62:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003f66:	6785                	lui	a5,0x1
    80003f68:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80003f6a:	97ca                	add	a5,a5,s2
    80003f6c:	777d                	lui	a4,0xfffff
    80003f6e:	8ff9                	and	a5,a5,a4
    80003f70:	def43c23          	sd	a5,-520(s0)
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0) goto bad;
    80003f74:	4691                	li	a3,4
    80003f76:	6609                	lui	a2,0x2
    80003f78:	963e                	add	a2,a2,a5
    80003f7a:	85be                	mv	a1,a5
    80003f7c:	855a                	mv	a0,s6
    80003f7e:	ffffd097          	auipc	ra,0xffffd
    80003f82:	836080e7          	jalr	-1994(ra) # 800007b4 <uvmalloc>
    80003f86:	8c2a                	mv	s8,a0
  ip = 0;
    80003f88:	4a81                	li	s5,0
  if ((sz1 = uvmalloc(pagetable, sz, sz + 2 * PGSIZE, PTE_W)) == 0) goto bad;
    80003f8a:	12050e63          	beqz	a0,800040c6 <exec+0x2d4>
  uvmclear(pagetable, sz - 2 * PGSIZE);
    80003f8e:	75f9                	lui	a1,0xffffe
    80003f90:	95aa                	add	a1,a1,a0
    80003f92:	855a                	mv	a0,s6
    80003f94:	ffffd097          	auipc	ra,0xffffd
    80003f98:	a4a080e7          	jalr	-1462(ra) # 800009de <uvmclear>
  stackbase = sp - PGSIZE;
    80003f9c:	7afd                	lui	s5,0xfffff
    80003f9e:	9ae2                	add	s5,s5,s8
  for (argc = 0; argv[argc]; argc++) {
    80003fa0:	df043783          	ld	a5,-528(s0)
    80003fa4:	6388                	ld	a0,0(a5)
    80003fa6:	c925                	beqz	a0,80004016 <exec+0x224>
    80003fa8:	e9040993          	addi	s3,s0,-368
    80003fac:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80003fb0:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    80003fb2:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003fb4:	ffffc097          	auipc	ra,0xffffc
    80003fb8:	23e080e7          	jalr	574(ra) # 800001f2 <strlen>
    80003fbc:	0015079b          	addiw	a5,a0,1
    80003fc0:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16;  // riscv sp must be 16-byte aligned
    80003fc4:	ff07f913          	andi	s2,a5,-16
    if (sp < stackbase) goto bad;
    80003fc8:	13596663          	bltu	s2,s5,800040f4 <exec+0x302>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003fcc:	df043d83          	ld	s11,-528(s0)
    80003fd0:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80003fd4:	8552                	mv	a0,s4
    80003fd6:	ffffc097          	auipc	ra,0xffffc
    80003fda:	21c080e7          	jalr	540(ra) # 800001f2 <strlen>
    80003fde:	0015069b          	addiw	a3,a0,1
    80003fe2:	8652                	mv	a2,s4
    80003fe4:	85ca                	mv	a1,s2
    80003fe6:	855a                	mv	a0,s6
    80003fe8:	ffffd097          	auipc	ra,0xffffd
    80003fec:	a28080e7          	jalr	-1496(ra) # 80000a10 <copyout>
    80003ff0:	10054663          	bltz	a0,800040fc <exec+0x30a>
    ustack[argc] = sp;
    80003ff4:	0129b023          	sd	s2,0(s3)
  for (argc = 0; argv[argc]; argc++) {
    80003ff8:	0485                	addi	s1,s1,1
    80003ffa:	008d8793          	addi	a5,s11,8
    80003ffe:	def43823          	sd	a5,-528(s0)
    80004002:	008db503          	ld	a0,8(s11)
    80004006:	c911                	beqz	a0,8000401a <exec+0x228>
    if (argc >= MAXARG) goto bad;
    80004008:	09a1                	addi	s3,s3,8
    8000400a:	fb3c95e3          	bne	s9,s3,80003fb4 <exec+0x1c2>
  sz = sz1;
    8000400e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004012:	4a81                	li	s5,0
    80004014:	a84d                	j	800040c6 <exec+0x2d4>
  sp = sz;
    80004016:	8962                	mv	s2,s8
  for (argc = 0; argv[argc]; argc++) {
    80004018:	4481                	li	s1,0
  ustack[argc] = 0;
    8000401a:	00349793          	slli	a5,s1,0x3
    8000401e:	f9078793          	addi	a5,a5,-112
    80004022:	97a2                	add	a5,a5,s0
    80004024:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    80004028:	00148693          	addi	a3,s1,1
    8000402c:	068e                	slli	a3,a3,0x3
    8000402e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004032:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase) goto bad;
    80004036:	01597663          	bgeu	s2,s5,80004042 <exec+0x250>
  sz = sz1;
    8000403a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000403e:	4a81                	li	s5,0
    80004040:	a059                	j	800040c6 <exec+0x2d4>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    80004042:	e9040613          	addi	a2,s0,-368
    80004046:	85ca                	mv	a1,s2
    80004048:	855a                	mv	a0,s6
    8000404a:	ffffd097          	auipc	ra,0xffffd
    8000404e:	9c6080e7          	jalr	-1594(ra) # 80000a10 <copyout>
    80004052:	0a054963          	bltz	a0,80004104 <exec+0x312>
  p->trapframe->a1 = sp;
    80004056:	058bb783          	ld	a5,88(s7)
    8000405a:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    8000405e:	de843783          	ld	a5,-536(s0)
    80004062:	0007c703          	lbu	a4,0(a5)
    80004066:	cf11                	beqz	a4,80004082 <exec+0x290>
    80004068:	0785                	addi	a5,a5,1
    if (*s == '/') last = s + 1;
    8000406a:	02f00693          	li	a3,47
    8000406e:	a039                	j	8000407c <exec+0x28a>
    80004070:	def43423          	sd	a5,-536(s0)
  for (last = s = path; *s; s++)
    80004074:	0785                	addi	a5,a5,1
    80004076:	fff7c703          	lbu	a4,-1(a5)
    8000407a:	c701                	beqz	a4,80004082 <exec+0x290>
    if (*s == '/') last = s + 1;
    8000407c:	fed71ce3          	bne	a4,a3,80004074 <exec+0x282>
    80004080:	bfc5                	j	80004070 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    80004082:	4641                	li	a2,16
    80004084:	de843583          	ld	a1,-536(s0)
    80004088:	158b8513          	addi	a0,s7,344
    8000408c:	ffffc097          	auipc	ra,0xffffc
    80004090:	134080e7          	jalr	308(ra) # 800001c0 <safestrcpy>
  oldpagetable = p->pagetable;
    80004094:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004098:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000409c:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800040a0:	058bb783          	ld	a5,88(s7)
    800040a4:	e6843703          	ld	a4,-408(s0)
    800040a8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;          // initial stack pointer
    800040aa:	058bb783          	ld	a5,88(s7)
    800040ae:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800040b2:	85ea                	mv	a1,s10
    800040b4:	ffffd097          	auipc	ra,0xffffd
    800040b8:	d5c080e7          	jalr	-676(ra) # 80000e10 <proc_freepagetable>
  return argc;  // this ends up in a0, the first argument to main(argc, argv)
    800040bc:	0004851b          	sext.w	a0,s1
    800040c0:	b3f9                	j	80003e8e <exec+0x9c>
    800040c2:	df243c23          	sd	s2,-520(s0)
  if (pagetable) proc_freepagetable(pagetable, sz);
    800040c6:	df843583          	ld	a1,-520(s0)
    800040ca:	855a                	mv	a0,s6
    800040cc:	ffffd097          	auipc	ra,0xffffd
    800040d0:	d44080e7          	jalr	-700(ra) # 80000e10 <proc_freepagetable>
  if (ip) {
    800040d4:	da0a93e3          	bnez	s5,80003e7a <exec+0x88>
  return -1;
    800040d8:	557d                	li	a0,-1
    800040da:	bb55                	j	80003e8e <exec+0x9c>
    800040dc:	df243c23          	sd	s2,-520(s0)
    800040e0:	b7dd                	j	800040c6 <exec+0x2d4>
    800040e2:	df243c23          	sd	s2,-520(s0)
    800040e6:	b7c5                	j	800040c6 <exec+0x2d4>
    800040e8:	df243c23          	sd	s2,-520(s0)
    800040ec:	bfe9                	j	800040c6 <exec+0x2d4>
    800040ee:	df243c23          	sd	s2,-520(s0)
    800040f2:	bfd1                	j	800040c6 <exec+0x2d4>
  sz = sz1;
    800040f4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800040f8:	4a81                	li	s5,0
    800040fa:	b7f1                	j	800040c6 <exec+0x2d4>
  sz = sz1;
    800040fc:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004100:	4a81                	li	s5,0
    80004102:	b7d1                	j	800040c6 <exec+0x2d4>
  sz = sz1;
    80004104:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004108:	4a81                	li	s5,0
    8000410a:	bf75                	j	800040c6 <exec+0x2d4>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    8000410c:	df843903          	ld	s2,-520(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004110:	e0843783          	ld	a5,-504(s0)
    80004114:	0017869b          	addiw	a3,a5,1
    80004118:	e0d43423          	sd	a3,-504(s0)
    8000411c:	e0043783          	ld	a5,-512(s0)
    80004120:	0387879b          	addiw	a5,a5,56
    80004124:	e8845703          	lhu	a4,-376(s0)
    80004128:	e0e6dfe3          	bge	a3,a4,80003f46 <exec+0x154>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph)) goto bad;
    8000412c:	2781                	sext.w	a5,a5
    8000412e:	e0f43023          	sd	a5,-512(s0)
    80004132:	03800713          	li	a4,56
    80004136:	86be                	mv	a3,a5
    80004138:	e1840613          	addi	a2,s0,-488
    8000413c:	4581                	li	a1,0
    8000413e:	8556                	mv	a0,s5
    80004140:	fffff097          	auipc	ra,0xfffff
    80004144:	ade080e7          	jalr	-1314(ra) # 80002c1e <readi>
    80004148:	03800793          	li	a5,56
    8000414c:	f6f51be3          	bne	a0,a5,800040c2 <exec+0x2d0>
    if (ph.type != ELF_PROG_LOAD) continue;
    80004150:	e1842783          	lw	a5,-488(s0)
    80004154:	4705                	li	a4,1
    80004156:	fae79de3          	bne	a5,a4,80004110 <exec+0x31e>
    if (ph.memsz < ph.filesz) goto bad;
    8000415a:	e4043483          	ld	s1,-448(s0)
    8000415e:	e3843783          	ld	a5,-456(s0)
    80004162:	f6f4ede3          	bltu	s1,a5,800040dc <exec+0x2ea>
    if (ph.vaddr + ph.memsz < ph.vaddr) goto bad;
    80004166:	e2843783          	ld	a5,-472(s0)
    8000416a:	94be                	add	s1,s1,a5
    8000416c:	f6f4ebe3          	bltu	s1,a5,800040e2 <exec+0x2f0>
    if (ph.vaddr % PGSIZE != 0) goto bad;
    80004170:	de043703          	ld	a4,-544(s0)
    80004174:	8ff9                	and	a5,a5,a4
    80004176:	fbad                	bnez	a5,800040e8 <exec+0x2f6>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    80004178:	e1c42503          	lw	a0,-484(s0)
    8000417c:	00000097          	auipc	ra,0x0
    80004180:	c5c080e7          	jalr	-932(ra) # 80003dd8 <flags2perm>
    80004184:	86aa                	mv	a3,a0
    80004186:	8626                	mv	a2,s1
    80004188:	85ca                	mv	a1,s2
    8000418a:	855a                	mv	a0,s6
    8000418c:	ffffc097          	auipc	ra,0xffffc
    80004190:	628080e7          	jalr	1576(ra) # 800007b4 <uvmalloc>
    80004194:	dea43c23          	sd	a0,-520(s0)
    80004198:	d939                	beqz	a0,800040ee <exec+0x2fc>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0) goto bad;
    8000419a:	e2843c03          	ld	s8,-472(s0)
    8000419e:	e2042c83          	lw	s9,-480(s0)
    800041a2:	e3842b83          	lw	s7,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    800041a6:	f60b83e3          	beqz	s7,8000410c <exec+0x31a>
    800041aa:	89de                	mv	s3,s7
    800041ac:	4481                	li	s1,0
    800041ae:	bb9d                	j	80003f24 <exec+0x132>

00000000800041b0 <argfd>:
#include "file.h"
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int argfd(int n, int *pfd, struct file **pf) {
    800041b0:	7179                	addi	sp,sp,-48
    800041b2:	f406                	sd	ra,40(sp)
    800041b4:	f022                	sd	s0,32(sp)
    800041b6:	ec26                	sd	s1,24(sp)
    800041b8:	e84a                	sd	s2,16(sp)
    800041ba:	1800                	addi	s0,sp,48
    800041bc:	892e                	mv	s2,a1
    800041be:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800041c0:	fdc40593          	addi	a1,s0,-36
    800041c4:	ffffe097          	auipc	ra,0xffffe
    800041c8:	c3c080e7          	jalr	-964(ra) # 80001e00 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
    800041cc:	fdc42703          	lw	a4,-36(s0)
    800041d0:	47bd                	li	a5,15
    800041d2:	02e7eb63          	bltu	a5,a4,80004208 <argfd+0x58>
    800041d6:	ffffd097          	auipc	ra,0xffffd
    800041da:	a94080e7          	jalr	-1388(ra) # 80000c6a <myproc>
    800041de:	fdc42703          	lw	a4,-36(s0)
    800041e2:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffe3b1a>
    800041e6:	078e                	slli	a5,a5,0x3
    800041e8:	953e                	add	a0,a0,a5
    800041ea:	611c                	ld	a5,0(a0)
    800041ec:	c385                	beqz	a5,8000420c <argfd+0x5c>
  if (pfd) *pfd = fd;
    800041ee:	00090463          	beqz	s2,800041f6 <argfd+0x46>
    800041f2:	00e92023          	sw	a4,0(s2)
  if (pf) *pf = f;
  return 0;
    800041f6:	4501                	li	a0,0
  if (pf) *pf = f;
    800041f8:	c091                	beqz	s1,800041fc <argfd+0x4c>
    800041fa:	e09c                	sd	a5,0(s1)
}
    800041fc:	70a2                	ld	ra,40(sp)
    800041fe:	7402                	ld	s0,32(sp)
    80004200:	64e2                	ld	s1,24(sp)
    80004202:	6942                	ld	s2,16(sp)
    80004204:	6145                	addi	sp,sp,48
    80004206:	8082                	ret
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
    80004208:	557d                	li	a0,-1
    8000420a:	bfcd                	j	800041fc <argfd+0x4c>
    8000420c:	557d                	li	a0,-1
    8000420e:	b7fd                	j	800041fc <argfd+0x4c>

0000000080004210 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int fdalloc(struct file *f) {
    80004210:	1101                	addi	sp,sp,-32
    80004212:	ec06                	sd	ra,24(sp)
    80004214:	e822                	sd	s0,16(sp)
    80004216:	e426                	sd	s1,8(sp)
    80004218:	1000                	addi	s0,sp,32
    8000421a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000421c:	ffffd097          	auipc	ra,0xffffd
    80004220:	a4e080e7          	jalr	-1458(ra) # 80000c6a <myproc>
    80004224:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    80004226:	0d050793          	addi	a5,a0,208
    8000422a:	4501                	li	a0,0
    8000422c:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    8000422e:	6398                	ld	a4,0(a5)
    80004230:	cb19                	beqz	a4,80004246 <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++) {
    80004232:	2505                	addiw	a0,a0,1
    80004234:	07a1                	addi	a5,a5,8
    80004236:	fed51ce3          	bne	a0,a3,8000422e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000423a:	557d                	li	a0,-1
}
    8000423c:	60e2                	ld	ra,24(sp)
    8000423e:	6442                	ld	s0,16(sp)
    80004240:	64a2                	ld	s1,8(sp)
    80004242:	6105                	addi	sp,sp,32
    80004244:	8082                	ret
      p->ofile[fd] = f;
    80004246:	01a50793          	addi	a5,a0,26
    8000424a:	078e                	slli	a5,a5,0x3
    8000424c:	963e                	add	a2,a2,a5
    8000424e:	e204                	sd	s1,0(a2)
      return fd;
    80004250:	b7f5                	j	8000423c <fdalloc+0x2c>

0000000080004252 <create>:
  iunlockput(dp);
  end_op();
  return -1;
}

static struct inode *create(char *path, short type, short major, short minor) {
    80004252:	715d                	addi	sp,sp,-80
    80004254:	e486                	sd	ra,72(sp)
    80004256:	e0a2                	sd	s0,64(sp)
    80004258:	fc26                	sd	s1,56(sp)
    8000425a:	f84a                	sd	s2,48(sp)
    8000425c:	f44e                	sd	s3,40(sp)
    8000425e:	f052                	sd	s4,32(sp)
    80004260:	ec56                	sd	s5,24(sp)
    80004262:	e85a                	sd	s6,16(sp)
    80004264:	0880                	addi	s0,sp,80
    80004266:	8b2e                	mv	s6,a1
    80004268:	89b2                	mv	s3,a2
    8000426a:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0) return 0;
    8000426c:	fb040593          	addi	a1,s0,-80
    80004270:	fffff097          	auipc	ra,0xfffff
    80004274:	ec4080e7          	jalr	-316(ra) # 80003134 <nameiparent>
    80004278:	84aa                	mv	s1,a0
    8000427a:	14050f63          	beqz	a0,800043d8 <create+0x186>

  ilock(dp);
    8000427e:	ffffe097          	auipc	ra,0xffffe
    80004282:	6ec080e7          	jalr	1772(ra) # 8000296a <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80004286:	4601                	li	a2,0
    80004288:	fb040593          	addi	a1,s0,-80
    8000428c:	8526                	mv	a0,s1
    8000428e:	fffff097          	auipc	ra,0xfffff
    80004292:	bc0080e7          	jalr	-1088(ra) # 80002e4e <dirlookup>
    80004296:	8aaa                	mv	s5,a0
    80004298:	c931                	beqz	a0,800042ec <create+0x9a>
    iunlockput(dp);
    8000429a:	8526                	mv	a0,s1
    8000429c:	fffff097          	auipc	ra,0xfffff
    800042a0:	930080e7          	jalr	-1744(ra) # 80002bcc <iunlockput>
    ilock(ip);
    800042a4:	8556                	mv	a0,s5
    800042a6:	ffffe097          	auipc	ra,0xffffe
    800042aa:	6c4080e7          	jalr	1732(ra) # 8000296a <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800042ae:	000b059b          	sext.w	a1,s6
    800042b2:	4789                	li	a5,2
    800042b4:	02f59563          	bne	a1,a5,800042de <create+0x8c>
    800042b8:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffe3b44>
    800042bc:	37f9                	addiw	a5,a5,-2
    800042be:	17c2                	slli	a5,a5,0x30
    800042c0:	93c1                	srli	a5,a5,0x30
    800042c2:	4705                	li	a4,1
    800042c4:	00f76d63          	bltu	a4,a5,800042de <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800042c8:	8556                	mv	a0,s5
    800042ca:	60a6                	ld	ra,72(sp)
    800042cc:	6406                	ld	s0,64(sp)
    800042ce:	74e2                	ld	s1,56(sp)
    800042d0:	7942                	ld	s2,48(sp)
    800042d2:	79a2                	ld	s3,40(sp)
    800042d4:	7a02                	ld	s4,32(sp)
    800042d6:	6ae2                	ld	s5,24(sp)
    800042d8:	6b42                	ld	s6,16(sp)
    800042da:	6161                	addi	sp,sp,80
    800042dc:	8082                	ret
    iunlockput(ip);
    800042de:	8556                	mv	a0,s5
    800042e0:	fffff097          	auipc	ra,0xfffff
    800042e4:	8ec080e7          	jalr	-1812(ra) # 80002bcc <iunlockput>
    return 0;
    800042e8:	4a81                	li	s5,0
    800042ea:	bff9                	j	800042c8 <create+0x76>
  if ((ip = ialloc(dp->dev, type)) == 0) {
    800042ec:	85da                	mv	a1,s6
    800042ee:	4088                	lw	a0,0(s1)
    800042f0:	ffffe097          	auipc	ra,0xffffe
    800042f4:	4dc080e7          	jalr	1244(ra) # 800027cc <ialloc>
    800042f8:	8a2a                	mv	s4,a0
    800042fa:	c539                	beqz	a0,80004348 <create+0xf6>
  ilock(ip);
    800042fc:	ffffe097          	auipc	ra,0xffffe
    80004300:	66e080e7          	jalr	1646(ra) # 8000296a <ilock>
  ip->major = major;
    80004304:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004308:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000430c:	4905                	li	s2,1
    8000430e:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004312:	8552                	mv	a0,s4
    80004314:	ffffe097          	auipc	ra,0xffffe
    80004318:	58a080e7          	jalr	1418(ra) # 8000289e <iupdate>
  if (type == T_DIR) {  // Create . and .. entries.
    8000431c:	000b059b          	sext.w	a1,s6
    80004320:	03258b63          	beq	a1,s2,80004356 <create+0x104>
  if (dirlink(dp, name, ip->inum) < 0) goto fail;
    80004324:	004a2603          	lw	a2,4(s4)
    80004328:	fb040593          	addi	a1,s0,-80
    8000432c:	8526                	mv	a0,s1
    8000432e:	fffff097          	auipc	ra,0xfffff
    80004332:	d36080e7          	jalr	-714(ra) # 80003064 <dirlink>
    80004336:	06054f63          	bltz	a0,800043b4 <create+0x162>
  iunlockput(dp);
    8000433a:	8526                	mv	a0,s1
    8000433c:	fffff097          	auipc	ra,0xfffff
    80004340:	890080e7          	jalr	-1904(ra) # 80002bcc <iunlockput>
  return ip;
    80004344:	8ad2                	mv	s5,s4
    80004346:	b749                	j	800042c8 <create+0x76>
    iunlockput(dp);
    80004348:	8526                	mv	a0,s1
    8000434a:	fffff097          	auipc	ra,0xfffff
    8000434e:	882080e7          	jalr	-1918(ra) # 80002bcc <iunlockput>
    return 0;
    80004352:	8ad2                	mv	s5,s4
    80004354:	bf95                	j	800042c8 <create+0x76>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004356:	004a2603          	lw	a2,4(s4)
    8000435a:	00004597          	auipc	a1,0x4
    8000435e:	2e658593          	addi	a1,a1,742 # 80008640 <syscalls+0x2a0>
    80004362:	8552                	mv	a0,s4
    80004364:	fffff097          	auipc	ra,0xfffff
    80004368:	d00080e7          	jalr	-768(ra) # 80003064 <dirlink>
    8000436c:	04054463          	bltz	a0,800043b4 <create+0x162>
    80004370:	40d0                	lw	a2,4(s1)
    80004372:	00004597          	auipc	a1,0x4
    80004376:	2d658593          	addi	a1,a1,726 # 80008648 <syscalls+0x2a8>
    8000437a:	8552                	mv	a0,s4
    8000437c:	fffff097          	auipc	ra,0xfffff
    80004380:	ce8080e7          	jalr	-792(ra) # 80003064 <dirlink>
    80004384:	02054863          	bltz	a0,800043b4 <create+0x162>
  if (dirlink(dp, name, ip->inum) < 0) goto fail;
    80004388:	004a2603          	lw	a2,4(s4)
    8000438c:	fb040593          	addi	a1,s0,-80
    80004390:	8526                	mv	a0,s1
    80004392:	fffff097          	auipc	ra,0xfffff
    80004396:	cd2080e7          	jalr	-814(ra) # 80003064 <dirlink>
    8000439a:	00054d63          	bltz	a0,800043b4 <create+0x162>
    dp->nlink++;  // for ".."
    8000439e:	04a4d783          	lhu	a5,74(s1)
    800043a2:	2785                	addiw	a5,a5,1
    800043a4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800043a8:	8526                	mv	a0,s1
    800043aa:	ffffe097          	auipc	ra,0xffffe
    800043ae:	4f4080e7          	jalr	1268(ra) # 8000289e <iupdate>
    800043b2:	b761                	j	8000433a <create+0xe8>
  ip->nlink = 0;
    800043b4:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800043b8:	8552                	mv	a0,s4
    800043ba:	ffffe097          	auipc	ra,0xffffe
    800043be:	4e4080e7          	jalr	1252(ra) # 8000289e <iupdate>
  iunlockput(ip);
    800043c2:	8552                	mv	a0,s4
    800043c4:	fffff097          	auipc	ra,0xfffff
    800043c8:	808080e7          	jalr	-2040(ra) # 80002bcc <iunlockput>
  iunlockput(dp);
    800043cc:	8526                	mv	a0,s1
    800043ce:	ffffe097          	auipc	ra,0xffffe
    800043d2:	7fe080e7          	jalr	2046(ra) # 80002bcc <iunlockput>
  return 0;
    800043d6:	bdcd                	j	800042c8 <create+0x76>
  if ((dp = nameiparent(path, name)) == 0) return 0;
    800043d8:	8aaa                	mv	s5,a0
    800043da:	b5fd                	j	800042c8 <create+0x76>

00000000800043dc <sys_dup>:
uint64 sys_dup(void) {
    800043dc:	7179                	addi	sp,sp,-48
    800043de:	f406                	sd	ra,40(sp)
    800043e0:	f022                	sd	s0,32(sp)
    800043e2:	ec26                	sd	s1,24(sp)
    800043e4:	e84a                	sd	s2,16(sp)
    800043e6:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0) return -1;
    800043e8:	fd840613          	addi	a2,s0,-40
    800043ec:	4581                	li	a1,0
    800043ee:	4501                	li	a0,0
    800043f0:	00000097          	auipc	ra,0x0
    800043f4:	dc0080e7          	jalr	-576(ra) # 800041b0 <argfd>
    800043f8:	57fd                	li	a5,-1
    800043fa:	02054363          	bltz	a0,80004420 <sys_dup+0x44>
  if ((fd = fdalloc(f)) < 0) return -1;
    800043fe:	fd843903          	ld	s2,-40(s0)
    80004402:	854a                	mv	a0,s2
    80004404:	00000097          	auipc	ra,0x0
    80004408:	e0c080e7          	jalr	-500(ra) # 80004210 <fdalloc>
    8000440c:	84aa                	mv	s1,a0
    8000440e:	57fd                	li	a5,-1
    80004410:	00054863          	bltz	a0,80004420 <sys_dup+0x44>
  filedup(f);
    80004414:	854a                	mv	a0,s2
    80004416:	fffff097          	auipc	ra,0xfffff
    8000441a:	34a080e7          	jalr	842(ra) # 80003760 <filedup>
  return fd;
    8000441e:	87a6                	mv	a5,s1
}
    80004420:	853e                	mv	a0,a5
    80004422:	70a2                	ld	ra,40(sp)
    80004424:	7402                	ld	s0,32(sp)
    80004426:	64e2                	ld	s1,24(sp)
    80004428:	6942                	ld	s2,16(sp)
    8000442a:	6145                	addi	sp,sp,48
    8000442c:	8082                	ret

000000008000442e <sys_read>:
uint64 sys_read(void) {
    8000442e:	7179                	addi	sp,sp,-48
    80004430:	f406                	sd	ra,40(sp)
    80004432:	f022                	sd	s0,32(sp)
    80004434:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004436:	fd840593          	addi	a1,s0,-40
    8000443a:	4505                	li	a0,1
    8000443c:	ffffe097          	auipc	ra,0xffffe
    80004440:	9e4080e7          	jalr	-1564(ra) # 80001e20 <argaddr>
  argint(2, &n);
    80004444:	fe440593          	addi	a1,s0,-28
    80004448:	4509                	li	a0,2
    8000444a:	ffffe097          	auipc	ra,0xffffe
    8000444e:	9b6080e7          	jalr	-1610(ra) # 80001e00 <argint>
  if (argfd(0, 0, &f) < 0) return -1;
    80004452:	fe840613          	addi	a2,s0,-24
    80004456:	4581                	li	a1,0
    80004458:	4501                	li	a0,0
    8000445a:	00000097          	auipc	ra,0x0
    8000445e:	d56080e7          	jalr	-682(ra) # 800041b0 <argfd>
    80004462:	87aa                	mv	a5,a0
    80004464:	557d                	li	a0,-1
    80004466:	0007cc63          	bltz	a5,8000447e <sys_read+0x50>
  return fileread(f, p, n);
    8000446a:	fe442603          	lw	a2,-28(s0)
    8000446e:	fd843583          	ld	a1,-40(s0)
    80004472:	fe843503          	ld	a0,-24(s0)
    80004476:	fffff097          	auipc	ra,0xfffff
    8000447a:	43c080e7          	jalr	1084(ra) # 800038b2 <fileread>
}
    8000447e:	70a2                	ld	ra,40(sp)
    80004480:	7402                	ld	s0,32(sp)
    80004482:	6145                	addi	sp,sp,48
    80004484:	8082                	ret

0000000080004486 <sys_write>:
uint64 sys_write(void) {
    80004486:	7179                	addi	sp,sp,-48
    80004488:	f406                	sd	ra,40(sp)
    8000448a:	f022                	sd	s0,32(sp)
    8000448c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000448e:	fd840593          	addi	a1,s0,-40
    80004492:	4505                	li	a0,1
    80004494:	ffffe097          	auipc	ra,0xffffe
    80004498:	98c080e7          	jalr	-1652(ra) # 80001e20 <argaddr>
  argint(2, &n);
    8000449c:	fe440593          	addi	a1,s0,-28
    800044a0:	4509                	li	a0,2
    800044a2:	ffffe097          	auipc	ra,0xffffe
    800044a6:	95e080e7          	jalr	-1698(ra) # 80001e00 <argint>
  if (argfd(0, 0, &f) < 0) return -1;
    800044aa:	fe840613          	addi	a2,s0,-24
    800044ae:	4581                	li	a1,0
    800044b0:	4501                	li	a0,0
    800044b2:	00000097          	auipc	ra,0x0
    800044b6:	cfe080e7          	jalr	-770(ra) # 800041b0 <argfd>
    800044ba:	87aa                	mv	a5,a0
    800044bc:	557d                	li	a0,-1
    800044be:	0007cc63          	bltz	a5,800044d6 <sys_write+0x50>
  return filewrite(f, p, n);
    800044c2:	fe442603          	lw	a2,-28(s0)
    800044c6:	fd843583          	ld	a1,-40(s0)
    800044ca:	fe843503          	ld	a0,-24(s0)
    800044ce:	fffff097          	auipc	ra,0xfffff
    800044d2:	4a6080e7          	jalr	1190(ra) # 80003974 <filewrite>
}
    800044d6:	70a2                	ld	ra,40(sp)
    800044d8:	7402                	ld	s0,32(sp)
    800044da:	6145                	addi	sp,sp,48
    800044dc:	8082                	ret

00000000800044de <sys_close>:
uint64 sys_close(void) {
    800044de:	1101                	addi	sp,sp,-32
    800044e0:	ec06                	sd	ra,24(sp)
    800044e2:	e822                	sd	s0,16(sp)
    800044e4:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0) return -1;
    800044e6:	fe040613          	addi	a2,s0,-32
    800044ea:	fec40593          	addi	a1,s0,-20
    800044ee:	4501                	li	a0,0
    800044f0:	00000097          	auipc	ra,0x0
    800044f4:	cc0080e7          	jalr	-832(ra) # 800041b0 <argfd>
    800044f8:	57fd                	li	a5,-1
    800044fa:	02054463          	bltz	a0,80004522 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800044fe:	ffffc097          	auipc	ra,0xffffc
    80004502:	76c080e7          	jalr	1900(ra) # 80000c6a <myproc>
    80004506:	fec42783          	lw	a5,-20(s0)
    8000450a:	07e9                	addi	a5,a5,26
    8000450c:	078e                	slli	a5,a5,0x3
    8000450e:	953e                	add	a0,a0,a5
    80004510:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004514:	fe043503          	ld	a0,-32(s0)
    80004518:	fffff097          	auipc	ra,0xfffff
    8000451c:	28c080e7          	jalr	652(ra) # 800037a4 <fileclose>
  return 0;
    80004520:	4781                	li	a5,0
}
    80004522:	853e                	mv	a0,a5
    80004524:	60e2                	ld	ra,24(sp)
    80004526:	6442                	ld	s0,16(sp)
    80004528:	6105                	addi	sp,sp,32
    8000452a:	8082                	ret

000000008000452c <sys_fstat>:
uint64 sys_fstat(void) {
    8000452c:	1101                	addi	sp,sp,-32
    8000452e:	ec06                	sd	ra,24(sp)
    80004530:	e822                	sd	s0,16(sp)
    80004532:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004534:	fe040593          	addi	a1,s0,-32
    80004538:	4505                	li	a0,1
    8000453a:	ffffe097          	auipc	ra,0xffffe
    8000453e:	8e6080e7          	jalr	-1818(ra) # 80001e20 <argaddr>
  if (argfd(0, 0, &f) < 0) return -1;
    80004542:	fe840613          	addi	a2,s0,-24
    80004546:	4581                	li	a1,0
    80004548:	4501                	li	a0,0
    8000454a:	00000097          	auipc	ra,0x0
    8000454e:	c66080e7          	jalr	-922(ra) # 800041b0 <argfd>
    80004552:	87aa                	mv	a5,a0
    80004554:	557d                	li	a0,-1
    80004556:	0007ca63          	bltz	a5,8000456a <sys_fstat+0x3e>
  return filestat(f, st);
    8000455a:	fe043583          	ld	a1,-32(s0)
    8000455e:	fe843503          	ld	a0,-24(s0)
    80004562:	fffff097          	auipc	ra,0xfffff
    80004566:	2de080e7          	jalr	734(ra) # 80003840 <filestat>
}
    8000456a:	60e2                	ld	ra,24(sp)
    8000456c:	6442                	ld	s0,16(sp)
    8000456e:	6105                	addi	sp,sp,32
    80004570:	8082                	ret

0000000080004572 <sys_link>:
uint64 sys_link(void) {
    80004572:	7169                	addi	sp,sp,-304
    80004574:	f606                	sd	ra,296(sp)
    80004576:	f222                	sd	s0,288(sp)
    80004578:	ee26                	sd	s1,280(sp)
    8000457a:	ea4a                	sd	s2,272(sp)
    8000457c:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0) return -1;
    8000457e:	08000613          	li	a2,128
    80004582:	ed040593          	addi	a1,s0,-304
    80004586:	4501                	li	a0,0
    80004588:	ffffe097          	auipc	ra,0xffffe
    8000458c:	8b8080e7          	jalr	-1864(ra) # 80001e40 <argstr>
    80004590:	57fd                	li	a5,-1
    80004592:	10054e63          	bltz	a0,800046ae <sys_link+0x13c>
    80004596:	08000613          	li	a2,128
    8000459a:	f5040593          	addi	a1,s0,-176
    8000459e:	4505                	li	a0,1
    800045a0:	ffffe097          	auipc	ra,0xffffe
    800045a4:	8a0080e7          	jalr	-1888(ra) # 80001e40 <argstr>
    800045a8:	57fd                	li	a5,-1
    800045aa:	10054263          	bltz	a0,800046ae <sys_link+0x13c>
  begin_op();
    800045ae:	fffff097          	auipc	ra,0xfffff
    800045b2:	d88080e7          	jalr	-632(ra) # 80003336 <begin_op>
  if ((ip = namei(old)) == 0) {
    800045b6:	ed040513          	addi	a0,s0,-304
    800045ba:	fffff097          	auipc	ra,0xfffff
    800045be:	b5c080e7          	jalr	-1188(ra) # 80003116 <namei>
    800045c2:	84aa                	mv	s1,a0
    800045c4:	c551                	beqz	a0,80004650 <sys_link+0xde>
  ilock(ip);
    800045c6:	ffffe097          	auipc	ra,0xffffe
    800045ca:	3a4080e7          	jalr	932(ra) # 8000296a <ilock>
  if (ip->type == T_DIR) {
    800045ce:	04449703          	lh	a4,68(s1)
    800045d2:	4785                	li	a5,1
    800045d4:	08f70463          	beq	a4,a5,8000465c <sys_link+0xea>
  ip->nlink++;
    800045d8:	04a4d783          	lhu	a5,74(s1)
    800045dc:	2785                	addiw	a5,a5,1
    800045de:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800045e2:	8526                	mv	a0,s1
    800045e4:	ffffe097          	auipc	ra,0xffffe
    800045e8:	2ba080e7          	jalr	698(ra) # 8000289e <iupdate>
  iunlock(ip);
    800045ec:	8526                	mv	a0,s1
    800045ee:	ffffe097          	auipc	ra,0xffffe
    800045f2:	43e080e7          	jalr	1086(ra) # 80002a2c <iunlock>
  if ((dp = nameiparent(new, name)) == 0) goto bad;
    800045f6:	fd040593          	addi	a1,s0,-48
    800045fa:	f5040513          	addi	a0,s0,-176
    800045fe:	fffff097          	auipc	ra,0xfffff
    80004602:	b36080e7          	jalr	-1226(ra) # 80003134 <nameiparent>
    80004606:	892a                	mv	s2,a0
    80004608:	c935                	beqz	a0,8000467c <sys_link+0x10a>
  ilock(dp);
    8000460a:	ffffe097          	auipc	ra,0xffffe
    8000460e:	360080e7          	jalr	864(ra) # 8000296a <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80004612:	00092703          	lw	a4,0(s2)
    80004616:	409c                	lw	a5,0(s1)
    80004618:	04f71d63          	bne	a4,a5,80004672 <sys_link+0x100>
    8000461c:	40d0                	lw	a2,4(s1)
    8000461e:	fd040593          	addi	a1,s0,-48
    80004622:	854a                	mv	a0,s2
    80004624:	fffff097          	auipc	ra,0xfffff
    80004628:	a40080e7          	jalr	-1472(ra) # 80003064 <dirlink>
    8000462c:	04054363          	bltz	a0,80004672 <sys_link+0x100>
  iunlockput(dp);
    80004630:	854a                	mv	a0,s2
    80004632:	ffffe097          	auipc	ra,0xffffe
    80004636:	59a080e7          	jalr	1434(ra) # 80002bcc <iunlockput>
  iput(ip);
    8000463a:	8526                	mv	a0,s1
    8000463c:	ffffe097          	auipc	ra,0xffffe
    80004640:	4e8080e7          	jalr	1256(ra) # 80002b24 <iput>
  end_op();
    80004644:	fffff097          	auipc	ra,0xfffff
    80004648:	d70080e7          	jalr	-656(ra) # 800033b4 <end_op>
  return 0;
    8000464c:	4781                	li	a5,0
    8000464e:	a085                	j	800046ae <sys_link+0x13c>
    end_op();
    80004650:	fffff097          	auipc	ra,0xfffff
    80004654:	d64080e7          	jalr	-668(ra) # 800033b4 <end_op>
    return -1;
    80004658:	57fd                	li	a5,-1
    8000465a:	a891                	j	800046ae <sys_link+0x13c>
    iunlockput(ip);
    8000465c:	8526                	mv	a0,s1
    8000465e:	ffffe097          	auipc	ra,0xffffe
    80004662:	56e080e7          	jalr	1390(ra) # 80002bcc <iunlockput>
    end_op();
    80004666:	fffff097          	auipc	ra,0xfffff
    8000466a:	d4e080e7          	jalr	-690(ra) # 800033b4 <end_op>
    return -1;
    8000466e:	57fd                	li	a5,-1
    80004670:	a83d                	j	800046ae <sys_link+0x13c>
    iunlockput(dp);
    80004672:	854a                	mv	a0,s2
    80004674:	ffffe097          	auipc	ra,0xffffe
    80004678:	558080e7          	jalr	1368(ra) # 80002bcc <iunlockput>
  ilock(ip);
    8000467c:	8526                	mv	a0,s1
    8000467e:	ffffe097          	auipc	ra,0xffffe
    80004682:	2ec080e7          	jalr	748(ra) # 8000296a <ilock>
  ip->nlink--;
    80004686:	04a4d783          	lhu	a5,74(s1)
    8000468a:	37fd                	addiw	a5,a5,-1
    8000468c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004690:	8526                	mv	a0,s1
    80004692:	ffffe097          	auipc	ra,0xffffe
    80004696:	20c080e7          	jalr	524(ra) # 8000289e <iupdate>
  iunlockput(ip);
    8000469a:	8526                	mv	a0,s1
    8000469c:	ffffe097          	auipc	ra,0xffffe
    800046a0:	530080e7          	jalr	1328(ra) # 80002bcc <iunlockput>
  end_op();
    800046a4:	fffff097          	auipc	ra,0xfffff
    800046a8:	d10080e7          	jalr	-752(ra) # 800033b4 <end_op>
  return -1;
    800046ac:	57fd                	li	a5,-1
}
    800046ae:	853e                	mv	a0,a5
    800046b0:	70b2                	ld	ra,296(sp)
    800046b2:	7412                	ld	s0,288(sp)
    800046b4:	64f2                	ld	s1,280(sp)
    800046b6:	6952                	ld	s2,272(sp)
    800046b8:	6155                	addi	sp,sp,304
    800046ba:	8082                	ret

00000000800046bc <sys_unlink>:
uint64 sys_unlink(void) {
    800046bc:	7151                	addi	sp,sp,-240
    800046be:	f586                	sd	ra,232(sp)
    800046c0:	f1a2                	sd	s0,224(sp)
    800046c2:	eda6                	sd	s1,216(sp)
    800046c4:	e9ca                	sd	s2,208(sp)
    800046c6:	e5ce                	sd	s3,200(sp)
    800046c8:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0) return -1;
    800046ca:	08000613          	li	a2,128
    800046ce:	f3040593          	addi	a1,s0,-208
    800046d2:	4501                	li	a0,0
    800046d4:	ffffd097          	auipc	ra,0xffffd
    800046d8:	76c080e7          	jalr	1900(ra) # 80001e40 <argstr>
    800046dc:	18054163          	bltz	a0,8000485e <sys_unlink+0x1a2>
  begin_op();
    800046e0:	fffff097          	auipc	ra,0xfffff
    800046e4:	c56080e7          	jalr	-938(ra) # 80003336 <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    800046e8:	fb040593          	addi	a1,s0,-80
    800046ec:	f3040513          	addi	a0,s0,-208
    800046f0:	fffff097          	auipc	ra,0xfffff
    800046f4:	a44080e7          	jalr	-1468(ra) # 80003134 <nameiparent>
    800046f8:	84aa                	mv	s1,a0
    800046fa:	c979                	beqz	a0,800047d0 <sys_unlink+0x114>
  ilock(dp);
    800046fc:	ffffe097          	auipc	ra,0xffffe
    80004700:	26e080e7          	jalr	622(ra) # 8000296a <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0) goto bad;
    80004704:	00004597          	auipc	a1,0x4
    80004708:	f3c58593          	addi	a1,a1,-196 # 80008640 <syscalls+0x2a0>
    8000470c:	fb040513          	addi	a0,s0,-80
    80004710:	ffffe097          	auipc	ra,0xffffe
    80004714:	724080e7          	jalr	1828(ra) # 80002e34 <namecmp>
    80004718:	14050a63          	beqz	a0,8000486c <sys_unlink+0x1b0>
    8000471c:	00004597          	auipc	a1,0x4
    80004720:	f2c58593          	addi	a1,a1,-212 # 80008648 <syscalls+0x2a8>
    80004724:	fb040513          	addi	a0,s0,-80
    80004728:	ffffe097          	auipc	ra,0xffffe
    8000472c:	70c080e7          	jalr	1804(ra) # 80002e34 <namecmp>
    80004730:	12050e63          	beqz	a0,8000486c <sys_unlink+0x1b0>
  if ((ip = dirlookup(dp, name, &off)) == 0) goto bad;
    80004734:	f2c40613          	addi	a2,s0,-212
    80004738:	fb040593          	addi	a1,s0,-80
    8000473c:	8526                	mv	a0,s1
    8000473e:	ffffe097          	auipc	ra,0xffffe
    80004742:	710080e7          	jalr	1808(ra) # 80002e4e <dirlookup>
    80004746:	892a                	mv	s2,a0
    80004748:	12050263          	beqz	a0,8000486c <sys_unlink+0x1b0>
  ilock(ip);
    8000474c:	ffffe097          	auipc	ra,0xffffe
    80004750:	21e080e7          	jalr	542(ra) # 8000296a <ilock>
  if (ip->nlink < 1) panic("unlink: nlink < 1");
    80004754:	04a91783          	lh	a5,74(s2)
    80004758:	08f05263          	blez	a5,800047dc <sys_unlink+0x120>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    8000475c:	04491703          	lh	a4,68(s2)
    80004760:	4785                	li	a5,1
    80004762:	08f70563          	beq	a4,a5,800047ec <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004766:	4641                	li	a2,16
    80004768:	4581                	li	a1,0
    8000476a:	fc040513          	addi	a0,s0,-64
    8000476e:	ffffc097          	auipc	ra,0xffffc
    80004772:	908080e7          	jalr	-1784(ra) # 80000076 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004776:	4741                	li	a4,16
    80004778:	f2c42683          	lw	a3,-212(s0)
    8000477c:	fc040613          	addi	a2,s0,-64
    80004780:	4581                	li	a1,0
    80004782:	8526                	mv	a0,s1
    80004784:	ffffe097          	auipc	ra,0xffffe
    80004788:	592080e7          	jalr	1426(ra) # 80002d16 <writei>
    8000478c:	47c1                	li	a5,16
    8000478e:	0af51563          	bne	a0,a5,80004838 <sys_unlink+0x17c>
  if (ip->type == T_DIR) {
    80004792:	04491703          	lh	a4,68(s2)
    80004796:	4785                	li	a5,1
    80004798:	0af70863          	beq	a4,a5,80004848 <sys_unlink+0x18c>
  iunlockput(dp);
    8000479c:	8526                	mv	a0,s1
    8000479e:	ffffe097          	auipc	ra,0xffffe
    800047a2:	42e080e7          	jalr	1070(ra) # 80002bcc <iunlockput>
  ip->nlink--;
    800047a6:	04a95783          	lhu	a5,74(s2)
    800047aa:	37fd                	addiw	a5,a5,-1
    800047ac:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800047b0:	854a                	mv	a0,s2
    800047b2:	ffffe097          	auipc	ra,0xffffe
    800047b6:	0ec080e7          	jalr	236(ra) # 8000289e <iupdate>
  iunlockput(ip);
    800047ba:	854a                	mv	a0,s2
    800047bc:	ffffe097          	auipc	ra,0xffffe
    800047c0:	410080e7          	jalr	1040(ra) # 80002bcc <iunlockput>
  end_op();
    800047c4:	fffff097          	auipc	ra,0xfffff
    800047c8:	bf0080e7          	jalr	-1040(ra) # 800033b4 <end_op>
  return 0;
    800047cc:	4501                	li	a0,0
    800047ce:	a84d                	j	80004880 <sys_unlink+0x1c4>
    end_op();
    800047d0:	fffff097          	auipc	ra,0xfffff
    800047d4:	be4080e7          	jalr	-1052(ra) # 800033b4 <end_op>
    return -1;
    800047d8:	557d                	li	a0,-1
    800047da:	a05d                	j	80004880 <sys_unlink+0x1c4>
  if (ip->nlink < 1) panic("unlink: nlink < 1");
    800047dc:	00004517          	auipc	a0,0x4
    800047e0:	e7450513          	addi	a0,a0,-396 # 80008650 <syscalls+0x2b0>
    800047e4:	00002097          	auipc	ra,0x2
    800047e8:	ea0080e7          	jalr	-352(ra) # 80006684 <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    800047ec:	04c92703          	lw	a4,76(s2)
    800047f0:	02000793          	li	a5,32
    800047f4:	f6e7f9e3          	bgeu	a5,a4,80004766 <sys_unlink+0xaa>
    800047f8:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800047fc:	4741                	li	a4,16
    800047fe:	86ce                	mv	a3,s3
    80004800:	f1840613          	addi	a2,s0,-232
    80004804:	4581                	li	a1,0
    80004806:	854a                	mv	a0,s2
    80004808:	ffffe097          	auipc	ra,0xffffe
    8000480c:	416080e7          	jalr	1046(ra) # 80002c1e <readi>
    80004810:	47c1                	li	a5,16
    80004812:	00f51b63          	bne	a0,a5,80004828 <sys_unlink+0x16c>
    if (de.inum != 0) return 0;
    80004816:	f1845783          	lhu	a5,-232(s0)
    8000481a:	e7a1                	bnez	a5,80004862 <sys_unlink+0x1a6>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    8000481c:	29c1                	addiw	s3,s3,16
    8000481e:	04c92783          	lw	a5,76(s2)
    80004822:	fcf9ede3          	bltu	s3,a5,800047fc <sys_unlink+0x140>
    80004826:	b781                	j	80004766 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004828:	00004517          	auipc	a0,0x4
    8000482c:	e4050513          	addi	a0,a0,-448 # 80008668 <syscalls+0x2c8>
    80004830:	00002097          	auipc	ra,0x2
    80004834:	e54080e7          	jalr	-428(ra) # 80006684 <panic>
    panic("unlink: writei");
    80004838:	00004517          	auipc	a0,0x4
    8000483c:	e4850513          	addi	a0,a0,-440 # 80008680 <syscalls+0x2e0>
    80004840:	00002097          	auipc	ra,0x2
    80004844:	e44080e7          	jalr	-444(ra) # 80006684 <panic>
    dp->nlink--;
    80004848:	04a4d783          	lhu	a5,74(s1)
    8000484c:	37fd                	addiw	a5,a5,-1
    8000484e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004852:	8526                	mv	a0,s1
    80004854:	ffffe097          	auipc	ra,0xffffe
    80004858:	04a080e7          	jalr	74(ra) # 8000289e <iupdate>
    8000485c:	b781                	j	8000479c <sys_unlink+0xe0>
  if (argstr(0, path, MAXPATH) < 0) return -1;
    8000485e:	557d                	li	a0,-1
    80004860:	a005                	j	80004880 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004862:	854a                	mv	a0,s2
    80004864:	ffffe097          	auipc	ra,0xffffe
    80004868:	368080e7          	jalr	872(ra) # 80002bcc <iunlockput>
  iunlockput(dp);
    8000486c:	8526                	mv	a0,s1
    8000486e:	ffffe097          	auipc	ra,0xffffe
    80004872:	35e080e7          	jalr	862(ra) # 80002bcc <iunlockput>
  end_op();
    80004876:	fffff097          	auipc	ra,0xfffff
    8000487a:	b3e080e7          	jalr	-1218(ra) # 800033b4 <end_op>
  return -1;
    8000487e:	557d                	li	a0,-1
}
    80004880:	70ae                	ld	ra,232(sp)
    80004882:	740e                	ld	s0,224(sp)
    80004884:	64ee                	ld	s1,216(sp)
    80004886:	694e                	ld	s2,208(sp)
    80004888:	69ae                	ld	s3,200(sp)
    8000488a:	616d                	addi	sp,sp,240
    8000488c:	8082                	ret

000000008000488e <sys_open>:

uint64 sys_open(void) {
    8000488e:	7131                	addi	sp,sp,-192
    80004890:	fd06                	sd	ra,184(sp)
    80004892:	f922                	sd	s0,176(sp)
    80004894:	f526                	sd	s1,168(sp)
    80004896:	f14a                	sd	s2,160(sp)
    80004898:	ed4e                	sd	s3,152(sp)
    8000489a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000489c:	f4c40593          	addi	a1,s0,-180
    800048a0:	4505                	li	a0,1
    800048a2:	ffffd097          	auipc	ra,0xffffd
    800048a6:	55e080e7          	jalr	1374(ra) # 80001e00 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0) return -1;
    800048aa:	08000613          	li	a2,128
    800048ae:	f5040593          	addi	a1,s0,-176
    800048b2:	4501                	li	a0,0
    800048b4:	ffffd097          	auipc	ra,0xffffd
    800048b8:	58c080e7          	jalr	1420(ra) # 80001e40 <argstr>
    800048bc:	87aa                	mv	a5,a0
    800048be:	557d                	li	a0,-1
    800048c0:	0a07c963          	bltz	a5,80004972 <sys_open+0xe4>

  begin_op();
    800048c4:	fffff097          	auipc	ra,0xfffff
    800048c8:	a72080e7          	jalr	-1422(ra) # 80003336 <begin_op>

  if (omode & O_CREATE) {
    800048cc:	f4c42783          	lw	a5,-180(s0)
    800048d0:	2007f793          	andi	a5,a5,512
    800048d4:	cfc5                	beqz	a5,8000498c <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    800048d6:	4681                	li	a3,0
    800048d8:	4601                	li	a2,0
    800048da:	4589                	li	a1,2
    800048dc:	f5040513          	addi	a0,s0,-176
    800048e0:	00000097          	auipc	ra,0x0
    800048e4:	972080e7          	jalr	-1678(ra) # 80004252 <create>
    800048e8:	84aa                	mv	s1,a0
    if (ip == 0) {
    800048ea:	c959                	beqz	a0,80004980 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    800048ec:	04449703          	lh	a4,68(s1)
    800048f0:	478d                	li	a5,3
    800048f2:	00f71763          	bne	a4,a5,80004900 <sys_open+0x72>
    800048f6:	0464d703          	lhu	a4,70(s1)
    800048fa:	47a5                	li	a5,9
    800048fc:	0ce7ed63          	bltu	a5,a4,800049d6 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80004900:	fffff097          	auipc	ra,0xfffff
    80004904:	e26080e7          	jalr	-474(ra) # 80003726 <filealloc>
    80004908:	89aa                	mv	s3,a0
    8000490a:	10050363          	beqz	a0,80004a10 <sys_open+0x182>
    8000490e:	00000097          	auipc	ra,0x0
    80004912:	902080e7          	jalr	-1790(ra) # 80004210 <fdalloc>
    80004916:	892a                	mv	s2,a0
    80004918:	0e054763          	bltz	a0,80004a06 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    8000491c:	04449703          	lh	a4,68(s1)
    80004920:	478d                	li	a5,3
    80004922:	0cf70563          	beq	a4,a5,800049ec <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004926:	4789                	li	a5,2
    80004928:	00f9ac23          	sw	a5,24(s3)
    f->off = 0;
    8000492c:	0209ac23          	sw	zero,56(s3)
  }
  f->ip = ip;
    80004930:	0299b823          	sd	s1,48(s3)
  f->readable = !(omode & O_WRONLY);
    80004934:	f4c42783          	lw	a5,-180(s0)
    80004938:	0017c713          	xori	a4,a5,1
    8000493c:	8b05                	andi	a4,a4,1
    8000493e:	02e98023          	sb	a4,32(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004942:	0037f713          	andi	a4,a5,3
    80004946:	00e03733          	snez	a4,a4
    8000494a:	02e980a3          	sb	a4,33(s3)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    8000494e:	4007f793          	andi	a5,a5,1024
    80004952:	c791                	beqz	a5,8000495e <sys_open+0xd0>
    80004954:	04449703          	lh	a4,68(s1)
    80004958:	4789                	li	a5,2
    8000495a:	0af70063          	beq	a4,a5,800049fa <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    8000495e:	8526                	mv	a0,s1
    80004960:	ffffe097          	auipc	ra,0xffffe
    80004964:	0cc080e7          	jalr	204(ra) # 80002a2c <iunlock>
  end_op();
    80004968:	fffff097          	auipc	ra,0xfffff
    8000496c:	a4c080e7          	jalr	-1460(ra) # 800033b4 <end_op>

  return fd;
    80004970:	854a                	mv	a0,s2
}
    80004972:	70ea                	ld	ra,184(sp)
    80004974:	744a                	ld	s0,176(sp)
    80004976:	74aa                	ld	s1,168(sp)
    80004978:	790a                	ld	s2,160(sp)
    8000497a:	69ea                	ld	s3,152(sp)
    8000497c:	6129                	addi	sp,sp,192
    8000497e:	8082                	ret
      end_op();
    80004980:	fffff097          	auipc	ra,0xfffff
    80004984:	a34080e7          	jalr	-1484(ra) # 800033b4 <end_op>
      return -1;
    80004988:	557d                	li	a0,-1
    8000498a:	b7e5                	j	80004972 <sys_open+0xe4>
    if ((ip = namei(path)) == 0) {
    8000498c:	f5040513          	addi	a0,s0,-176
    80004990:	ffffe097          	auipc	ra,0xffffe
    80004994:	786080e7          	jalr	1926(ra) # 80003116 <namei>
    80004998:	84aa                	mv	s1,a0
    8000499a:	c905                	beqz	a0,800049ca <sys_open+0x13c>
    ilock(ip);
    8000499c:	ffffe097          	auipc	ra,0xffffe
    800049a0:	fce080e7          	jalr	-50(ra) # 8000296a <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    800049a4:	04449703          	lh	a4,68(s1)
    800049a8:	4785                	li	a5,1
    800049aa:	f4f711e3          	bne	a4,a5,800048ec <sys_open+0x5e>
    800049ae:	f4c42783          	lw	a5,-180(s0)
    800049b2:	d7b9                	beqz	a5,80004900 <sys_open+0x72>
      iunlockput(ip);
    800049b4:	8526                	mv	a0,s1
    800049b6:	ffffe097          	auipc	ra,0xffffe
    800049ba:	216080e7          	jalr	534(ra) # 80002bcc <iunlockput>
      end_op();
    800049be:	fffff097          	auipc	ra,0xfffff
    800049c2:	9f6080e7          	jalr	-1546(ra) # 800033b4 <end_op>
      return -1;
    800049c6:	557d                	li	a0,-1
    800049c8:	b76d                	j	80004972 <sys_open+0xe4>
      end_op();
    800049ca:	fffff097          	auipc	ra,0xfffff
    800049ce:	9ea080e7          	jalr	-1558(ra) # 800033b4 <end_op>
      return -1;
    800049d2:	557d                	li	a0,-1
    800049d4:	bf79                	j	80004972 <sys_open+0xe4>
    iunlockput(ip);
    800049d6:	8526                	mv	a0,s1
    800049d8:	ffffe097          	auipc	ra,0xffffe
    800049dc:	1f4080e7          	jalr	500(ra) # 80002bcc <iunlockput>
    end_op();
    800049e0:	fffff097          	auipc	ra,0xfffff
    800049e4:	9d4080e7          	jalr	-1580(ra) # 800033b4 <end_op>
    return -1;
    800049e8:	557d                	li	a0,-1
    800049ea:	b761                	j	80004972 <sys_open+0xe4>
    f->type = FD_DEVICE;
    800049ec:	00f9ac23          	sw	a5,24(s3)
    f->major = ip->major;
    800049f0:	04649783          	lh	a5,70(s1)
    800049f4:	02f99e23          	sh	a5,60(s3)
    800049f8:	bf25                	j	80004930 <sys_open+0xa2>
    itrunc(ip);
    800049fa:	8526                	mv	a0,s1
    800049fc:	ffffe097          	auipc	ra,0xffffe
    80004a00:	07c080e7          	jalr	124(ra) # 80002a78 <itrunc>
    80004a04:	bfa9                	j	8000495e <sys_open+0xd0>
    if (f) fileclose(f);
    80004a06:	854e                	mv	a0,s3
    80004a08:	fffff097          	auipc	ra,0xfffff
    80004a0c:	d9c080e7          	jalr	-612(ra) # 800037a4 <fileclose>
    iunlockput(ip);
    80004a10:	8526                	mv	a0,s1
    80004a12:	ffffe097          	auipc	ra,0xffffe
    80004a16:	1ba080e7          	jalr	442(ra) # 80002bcc <iunlockput>
    end_op();
    80004a1a:	fffff097          	auipc	ra,0xfffff
    80004a1e:	99a080e7          	jalr	-1638(ra) # 800033b4 <end_op>
    return -1;
    80004a22:	557d                	li	a0,-1
    80004a24:	b7b9                	j	80004972 <sys_open+0xe4>

0000000080004a26 <sys_mkdir>:

uint64 sys_mkdir(void) {
    80004a26:	7175                	addi	sp,sp,-144
    80004a28:	e506                	sd	ra,136(sp)
    80004a2a:	e122                	sd	s0,128(sp)
    80004a2c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004a2e:	fffff097          	auipc	ra,0xfffff
    80004a32:	908080e7          	jalr	-1784(ra) # 80003336 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80004a36:	08000613          	li	a2,128
    80004a3a:	f7040593          	addi	a1,s0,-144
    80004a3e:	4501                	li	a0,0
    80004a40:	ffffd097          	auipc	ra,0xffffd
    80004a44:	400080e7          	jalr	1024(ra) # 80001e40 <argstr>
    80004a48:	02054963          	bltz	a0,80004a7a <sys_mkdir+0x54>
    80004a4c:	4681                	li	a3,0
    80004a4e:	4601                	li	a2,0
    80004a50:	4585                	li	a1,1
    80004a52:	f7040513          	addi	a0,s0,-144
    80004a56:	fffff097          	auipc	ra,0xfffff
    80004a5a:	7fc080e7          	jalr	2044(ra) # 80004252 <create>
    80004a5e:	cd11                	beqz	a0,80004a7a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004a60:	ffffe097          	auipc	ra,0xffffe
    80004a64:	16c080e7          	jalr	364(ra) # 80002bcc <iunlockput>
  end_op();
    80004a68:	fffff097          	auipc	ra,0xfffff
    80004a6c:	94c080e7          	jalr	-1716(ra) # 800033b4 <end_op>
  return 0;
    80004a70:	4501                	li	a0,0
}
    80004a72:	60aa                	ld	ra,136(sp)
    80004a74:	640a                	ld	s0,128(sp)
    80004a76:	6149                	addi	sp,sp,144
    80004a78:	8082                	ret
    end_op();
    80004a7a:	fffff097          	auipc	ra,0xfffff
    80004a7e:	93a080e7          	jalr	-1734(ra) # 800033b4 <end_op>
    return -1;
    80004a82:	557d                	li	a0,-1
    80004a84:	b7fd                	j	80004a72 <sys_mkdir+0x4c>

0000000080004a86 <sys_mknod>:

uint64 sys_mknod(void) {
    80004a86:	7135                	addi	sp,sp,-160
    80004a88:	ed06                	sd	ra,152(sp)
    80004a8a:	e922                	sd	s0,144(sp)
    80004a8c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004a8e:	fffff097          	auipc	ra,0xfffff
    80004a92:	8a8080e7          	jalr	-1880(ra) # 80003336 <begin_op>
  argint(1, &major);
    80004a96:	f6c40593          	addi	a1,s0,-148
    80004a9a:	4505                	li	a0,1
    80004a9c:	ffffd097          	auipc	ra,0xffffd
    80004aa0:	364080e7          	jalr	868(ra) # 80001e00 <argint>
  argint(2, &minor);
    80004aa4:	f6840593          	addi	a1,s0,-152
    80004aa8:	4509                	li	a0,2
    80004aaa:	ffffd097          	auipc	ra,0xffffd
    80004aae:	356080e7          	jalr	854(ra) # 80001e00 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004ab2:	08000613          	li	a2,128
    80004ab6:	f7040593          	addi	a1,s0,-144
    80004aba:	4501                	li	a0,0
    80004abc:	ffffd097          	auipc	ra,0xffffd
    80004ac0:	384080e7          	jalr	900(ra) # 80001e40 <argstr>
    80004ac4:	02054b63          	bltz	a0,80004afa <sys_mknod+0x74>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80004ac8:	f6841683          	lh	a3,-152(s0)
    80004acc:	f6c41603          	lh	a2,-148(s0)
    80004ad0:	458d                	li	a1,3
    80004ad2:	f7040513          	addi	a0,s0,-144
    80004ad6:	fffff097          	auipc	ra,0xfffff
    80004ada:	77c080e7          	jalr	1916(ra) # 80004252 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004ade:	cd11                	beqz	a0,80004afa <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ae0:	ffffe097          	auipc	ra,0xffffe
    80004ae4:	0ec080e7          	jalr	236(ra) # 80002bcc <iunlockput>
  end_op();
    80004ae8:	fffff097          	auipc	ra,0xfffff
    80004aec:	8cc080e7          	jalr	-1844(ra) # 800033b4 <end_op>
  return 0;
    80004af0:	4501                	li	a0,0
}
    80004af2:	60ea                	ld	ra,152(sp)
    80004af4:	644a                	ld	s0,144(sp)
    80004af6:	610d                	addi	sp,sp,160
    80004af8:	8082                	ret
    end_op();
    80004afa:	fffff097          	auipc	ra,0xfffff
    80004afe:	8ba080e7          	jalr	-1862(ra) # 800033b4 <end_op>
    return -1;
    80004b02:	557d                	li	a0,-1
    80004b04:	b7fd                	j	80004af2 <sys_mknod+0x6c>

0000000080004b06 <sys_chdir>:

uint64 sys_chdir(void) {
    80004b06:	7135                	addi	sp,sp,-160
    80004b08:	ed06                	sd	ra,152(sp)
    80004b0a:	e922                	sd	s0,144(sp)
    80004b0c:	e526                	sd	s1,136(sp)
    80004b0e:	e14a                	sd	s2,128(sp)
    80004b10:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004b12:	ffffc097          	auipc	ra,0xffffc
    80004b16:	158080e7          	jalr	344(ra) # 80000c6a <myproc>
    80004b1a:	892a                	mv	s2,a0

  begin_op();
    80004b1c:	fffff097          	auipc	ra,0xfffff
    80004b20:	81a080e7          	jalr	-2022(ra) # 80003336 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80004b24:	08000613          	li	a2,128
    80004b28:	f6040593          	addi	a1,s0,-160
    80004b2c:	4501                	li	a0,0
    80004b2e:	ffffd097          	auipc	ra,0xffffd
    80004b32:	312080e7          	jalr	786(ra) # 80001e40 <argstr>
    80004b36:	04054b63          	bltz	a0,80004b8c <sys_chdir+0x86>
    80004b3a:	f6040513          	addi	a0,s0,-160
    80004b3e:	ffffe097          	auipc	ra,0xffffe
    80004b42:	5d8080e7          	jalr	1496(ra) # 80003116 <namei>
    80004b46:	84aa                	mv	s1,a0
    80004b48:	c131                	beqz	a0,80004b8c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004b4a:	ffffe097          	auipc	ra,0xffffe
    80004b4e:	e20080e7          	jalr	-480(ra) # 8000296a <ilock>
  if (ip->type != T_DIR) {
    80004b52:	04449703          	lh	a4,68(s1)
    80004b56:	4785                	li	a5,1
    80004b58:	04f71063          	bne	a4,a5,80004b98 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004b5c:	8526                	mv	a0,s1
    80004b5e:	ffffe097          	auipc	ra,0xffffe
    80004b62:	ece080e7          	jalr	-306(ra) # 80002a2c <iunlock>
  iput(p->cwd);
    80004b66:	15093503          	ld	a0,336(s2)
    80004b6a:	ffffe097          	auipc	ra,0xffffe
    80004b6e:	fba080e7          	jalr	-70(ra) # 80002b24 <iput>
  end_op();
    80004b72:	fffff097          	auipc	ra,0xfffff
    80004b76:	842080e7          	jalr	-1982(ra) # 800033b4 <end_op>
  p->cwd = ip;
    80004b7a:	14993823          	sd	s1,336(s2)
  return 0;
    80004b7e:	4501                	li	a0,0
}
    80004b80:	60ea                	ld	ra,152(sp)
    80004b82:	644a                	ld	s0,144(sp)
    80004b84:	64aa                	ld	s1,136(sp)
    80004b86:	690a                	ld	s2,128(sp)
    80004b88:	610d                	addi	sp,sp,160
    80004b8a:	8082                	ret
    end_op();
    80004b8c:	fffff097          	auipc	ra,0xfffff
    80004b90:	828080e7          	jalr	-2008(ra) # 800033b4 <end_op>
    return -1;
    80004b94:	557d                	li	a0,-1
    80004b96:	b7ed                	j	80004b80 <sys_chdir+0x7a>
    iunlockput(ip);
    80004b98:	8526                	mv	a0,s1
    80004b9a:	ffffe097          	auipc	ra,0xffffe
    80004b9e:	032080e7          	jalr	50(ra) # 80002bcc <iunlockput>
    end_op();
    80004ba2:	fffff097          	auipc	ra,0xfffff
    80004ba6:	812080e7          	jalr	-2030(ra) # 800033b4 <end_op>
    return -1;
    80004baa:	557d                	li	a0,-1
    80004bac:	bfd1                	j	80004b80 <sys_chdir+0x7a>

0000000080004bae <sys_exec>:

uint64 sys_exec(void) {
    80004bae:	7145                	addi	sp,sp,-464
    80004bb0:	e786                	sd	ra,456(sp)
    80004bb2:	e3a2                	sd	s0,448(sp)
    80004bb4:	ff26                	sd	s1,440(sp)
    80004bb6:	fb4a                	sd	s2,432(sp)
    80004bb8:	f74e                	sd	s3,424(sp)
    80004bba:	f352                	sd	s4,416(sp)
    80004bbc:	ef56                	sd	s5,408(sp)
    80004bbe:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004bc0:	e3840593          	addi	a1,s0,-456
    80004bc4:	4505                	li	a0,1
    80004bc6:	ffffd097          	auipc	ra,0xffffd
    80004bca:	25a080e7          	jalr	602(ra) # 80001e20 <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    80004bce:	08000613          	li	a2,128
    80004bd2:	f4040593          	addi	a1,s0,-192
    80004bd6:	4501                	li	a0,0
    80004bd8:	ffffd097          	auipc	ra,0xffffd
    80004bdc:	268080e7          	jalr	616(ra) # 80001e40 <argstr>
    80004be0:	87aa                	mv	a5,a0
    return -1;
    80004be2:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0) {
    80004be4:	0c07c363          	bltz	a5,80004caa <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004be8:	10000613          	li	a2,256
    80004bec:	4581                	li	a1,0
    80004bee:	e4040513          	addi	a0,s0,-448
    80004bf2:	ffffb097          	auipc	ra,0xffffb
    80004bf6:	484080e7          	jalr	1156(ra) # 80000076 <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    80004bfa:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004bfe:	89a6                	mv	s3,s1
    80004c00:	4901                	li	s2,0
    if (i >= NELEM(argv)) {
    80004c02:	02000a13          	li	s4,32
    80004c06:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80004c0a:	00391513          	slli	a0,s2,0x3
    80004c0e:	e3040593          	addi	a1,s0,-464
    80004c12:	e3843783          	ld	a5,-456(s0)
    80004c16:	953e                	add	a0,a0,a5
    80004c18:	ffffd097          	auipc	ra,0xffffd
    80004c1c:	14a080e7          	jalr	330(ra) # 80001d62 <fetchaddr>
    80004c20:	02054a63          	bltz	a0,80004c54 <sys_exec+0xa6>
      goto bad;
    }
    if (uarg == 0) {
    80004c24:	e3043783          	ld	a5,-464(s0)
    80004c28:	c3b9                	beqz	a5,80004c6e <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004c2a:	ffffb097          	auipc	ra,0xffffb
    80004c2e:	432080e7          	jalr	1074(ra) # 8000005c <kalloc>
    80004c32:	85aa                	mv	a1,a0
    80004c34:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0) goto bad;
    80004c38:	cd11                	beqz	a0,80004c54 <sys_exec+0xa6>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0) goto bad;
    80004c3a:	6605                	lui	a2,0x1
    80004c3c:	e3043503          	ld	a0,-464(s0)
    80004c40:	ffffd097          	auipc	ra,0xffffd
    80004c44:	174080e7          	jalr	372(ra) # 80001db4 <fetchstr>
    80004c48:	00054663          	bltz	a0,80004c54 <sys_exec+0xa6>
    if (i >= NELEM(argv)) {
    80004c4c:	0905                	addi	s2,s2,1
    80004c4e:	09a1                	addi	s3,s3,8
    80004c50:	fb491be3          	bne	s2,s4,80004c06 <sys_exec+0x58>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);
    80004c54:	f4040913          	addi	s2,s0,-192
    80004c58:	6088                	ld	a0,0(s1)
    80004c5a:	c539                	beqz	a0,80004ca8 <sys_exec+0xfa>
    80004c5c:	ffffb097          	auipc	ra,0xffffb
    80004c60:	3e8080e7          	jalr	1000(ra) # 80000044 <kfree>
    80004c64:	04a1                	addi	s1,s1,8
    80004c66:	ff2499e3          	bne	s1,s2,80004c58 <sys_exec+0xaa>
  return -1;
    80004c6a:	557d                	li	a0,-1
    80004c6c:	a83d                	j	80004caa <sys_exec+0xfc>
      argv[i] = 0;
    80004c6e:	0a8e                	slli	s5,s5,0x3
    80004c70:	fc0a8793          	addi	a5,s5,-64
    80004c74:	00878ab3          	add	s5,a5,s0
    80004c78:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004c7c:	e4040593          	addi	a1,s0,-448
    80004c80:	f4040513          	addi	a0,s0,-192
    80004c84:	fffff097          	auipc	ra,0xfffff
    80004c88:	16e080e7          	jalr	366(ra) # 80003df2 <exec>
    80004c8c:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++) kfree(argv[i]);
    80004c8e:	f4040993          	addi	s3,s0,-192
    80004c92:	6088                	ld	a0,0(s1)
    80004c94:	c901                	beqz	a0,80004ca4 <sys_exec+0xf6>
    80004c96:	ffffb097          	auipc	ra,0xffffb
    80004c9a:	3ae080e7          	jalr	942(ra) # 80000044 <kfree>
    80004c9e:	04a1                	addi	s1,s1,8
    80004ca0:	ff3499e3          	bne	s1,s3,80004c92 <sys_exec+0xe4>
  return ret;
    80004ca4:	854a                	mv	a0,s2
    80004ca6:	a011                	j	80004caa <sys_exec+0xfc>
  return -1;
    80004ca8:	557d                	li	a0,-1
}
    80004caa:	60be                	ld	ra,456(sp)
    80004cac:	641e                	ld	s0,448(sp)
    80004cae:	74fa                	ld	s1,440(sp)
    80004cb0:	795a                	ld	s2,432(sp)
    80004cb2:	79ba                	ld	s3,424(sp)
    80004cb4:	7a1a                	ld	s4,416(sp)
    80004cb6:	6afa                	ld	s5,408(sp)
    80004cb8:	6179                	addi	sp,sp,464
    80004cba:	8082                	ret

0000000080004cbc <sys_pipe>:

uint64 sys_pipe(void) {
    80004cbc:	7139                	addi	sp,sp,-64
    80004cbe:	fc06                	sd	ra,56(sp)
    80004cc0:	f822                	sd	s0,48(sp)
    80004cc2:	f426                	sd	s1,40(sp)
    80004cc4:	0080                	addi	s0,sp,64
  uint64 fdarray;  // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004cc6:	ffffc097          	auipc	ra,0xffffc
    80004cca:	fa4080e7          	jalr	-92(ra) # 80000c6a <myproc>
    80004cce:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004cd0:	fd840593          	addi	a1,s0,-40
    80004cd4:	4501                	li	a0,0
    80004cd6:	ffffd097          	auipc	ra,0xffffd
    80004cda:	14a080e7          	jalr	330(ra) # 80001e20 <argaddr>
  if (pipealloc(&rf, &wf) < 0) return -1;
    80004cde:	fc840593          	addi	a1,s0,-56
    80004ce2:	fd040513          	addi	a0,s0,-48
    80004ce6:	fffff097          	auipc	ra,0xfffff
    80004cea:	dc2080e7          	jalr	-574(ra) # 80003aa8 <pipealloc>
    80004cee:	57fd                	li	a5,-1
    80004cf0:	0c054463          	bltz	a0,80004db8 <sys_pipe+0xfc>
  fd0 = -1;
    80004cf4:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    80004cf8:	fd043503          	ld	a0,-48(s0)
    80004cfc:	fffff097          	auipc	ra,0xfffff
    80004d00:	514080e7          	jalr	1300(ra) # 80004210 <fdalloc>
    80004d04:	fca42223          	sw	a0,-60(s0)
    80004d08:	08054b63          	bltz	a0,80004d9e <sys_pipe+0xe2>
    80004d0c:	fc843503          	ld	a0,-56(s0)
    80004d10:	fffff097          	auipc	ra,0xfffff
    80004d14:	500080e7          	jalr	1280(ra) # 80004210 <fdalloc>
    80004d18:	fca42023          	sw	a0,-64(s0)
    80004d1c:	06054863          	bltz	a0,80004d8c <sys_pipe+0xd0>
    if (fd0 >= 0) p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80004d20:	4691                	li	a3,4
    80004d22:	fc440613          	addi	a2,s0,-60
    80004d26:	fd843583          	ld	a1,-40(s0)
    80004d2a:	68a8                	ld	a0,80(s1)
    80004d2c:	ffffc097          	auipc	ra,0xffffc
    80004d30:	ce4080e7          	jalr	-796(ra) # 80000a10 <copyout>
    80004d34:	02054063          	bltz	a0,80004d54 <sys_pipe+0x98>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) <
    80004d38:	4691                	li	a3,4
    80004d3a:	fc040613          	addi	a2,s0,-64
    80004d3e:	fd843583          	ld	a1,-40(s0)
    80004d42:	0591                	addi	a1,a1,4
    80004d44:	68a8                	ld	a0,80(s1)
    80004d46:	ffffc097          	auipc	ra,0xffffc
    80004d4a:	cca080e7          	jalr	-822(ra) # 80000a10 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004d4e:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80004d50:	06055463          	bgez	a0,80004db8 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80004d54:	fc442783          	lw	a5,-60(s0)
    80004d58:	07e9                	addi	a5,a5,26
    80004d5a:	078e                	slli	a5,a5,0x3
    80004d5c:	97a6                	add	a5,a5,s1
    80004d5e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004d62:	fc042783          	lw	a5,-64(s0)
    80004d66:	07e9                	addi	a5,a5,26
    80004d68:	078e                	slli	a5,a5,0x3
    80004d6a:	94be                	add	s1,s1,a5
    80004d6c:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004d70:	fd043503          	ld	a0,-48(s0)
    80004d74:	fffff097          	auipc	ra,0xfffff
    80004d78:	a30080e7          	jalr	-1488(ra) # 800037a4 <fileclose>
    fileclose(wf);
    80004d7c:	fc843503          	ld	a0,-56(s0)
    80004d80:	fffff097          	auipc	ra,0xfffff
    80004d84:	a24080e7          	jalr	-1500(ra) # 800037a4 <fileclose>
    return -1;
    80004d88:	57fd                	li	a5,-1
    80004d8a:	a03d                	j	80004db8 <sys_pipe+0xfc>
    if (fd0 >= 0) p->ofile[fd0] = 0;
    80004d8c:	fc442783          	lw	a5,-60(s0)
    80004d90:	0007c763          	bltz	a5,80004d9e <sys_pipe+0xe2>
    80004d94:	07e9                	addi	a5,a5,26
    80004d96:	078e                	slli	a5,a5,0x3
    80004d98:	97a6                	add	a5,a5,s1
    80004d9a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004d9e:	fd043503          	ld	a0,-48(s0)
    80004da2:	fffff097          	auipc	ra,0xfffff
    80004da6:	a02080e7          	jalr	-1534(ra) # 800037a4 <fileclose>
    fileclose(wf);
    80004daa:	fc843503          	ld	a0,-56(s0)
    80004dae:	fffff097          	auipc	ra,0xfffff
    80004db2:	9f6080e7          	jalr	-1546(ra) # 800037a4 <fileclose>
    return -1;
    80004db6:	57fd                	li	a5,-1
}
    80004db8:	853e                	mv	a0,a5
    80004dba:	70e2                	ld	ra,56(sp)
    80004dbc:	7442                	ld	s0,48(sp)
    80004dbe:	74a2                	ld	s1,40(sp)
    80004dc0:	6121                	addi	sp,sp,64
    80004dc2:	8082                	ret
	...

0000000080004dd0 <kernelvec>:
    80004dd0:	7111                	addi	sp,sp,-256
    80004dd2:	e006                	sd	ra,0(sp)
    80004dd4:	e40a                	sd	sp,8(sp)
    80004dd6:	e80e                	sd	gp,16(sp)
    80004dd8:	ec12                	sd	tp,24(sp)
    80004dda:	f016                	sd	t0,32(sp)
    80004ddc:	f41a                	sd	t1,40(sp)
    80004dde:	f81e                	sd	t2,48(sp)
    80004de0:	fc22                	sd	s0,56(sp)
    80004de2:	e0a6                	sd	s1,64(sp)
    80004de4:	e4aa                	sd	a0,72(sp)
    80004de6:	e8ae                	sd	a1,80(sp)
    80004de8:	ecb2                	sd	a2,88(sp)
    80004dea:	f0b6                	sd	a3,96(sp)
    80004dec:	f4ba                	sd	a4,104(sp)
    80004dee:	f8be                	sd	a5,112(sp)
    80004df0:	fcc2                	sd	a6,120(sp)
    80004df2:	e146                	sd	a7,128(sp)
    80004df4:	e54a                	sd	s2,136(sp)
    80004df6:	e94e                	sd	s3,144(sp)
    80004df8:	ed52                	sd	s4,152(sp)
    80004dfa:	f156                	sd	s5,160(sp)
    80004dfc:	f55a                	sd	s6,168(sp)
    80004dfe:	f95e                	sd	s7,176(sp)
    80004e00:	fd62                	sd	s8,184(sp)
    80004e02:	e1e6                	sd	s9,192(sp)
    80004e04:	e5ea                	sd	s10,200(sp)
    80004e06:	e9ee                	sd	s11,208(sp)
    80004e08:	edf2                	sd	t3,216(sp)
    80004e0a:	f1f6                	sd	t4,224(sp)
    80004e0c:	f5fa                	sd	t5,232(sp)
    80004e0e:	f9fe                	sd	t6,240(sp)
    80004e10:	e1ffc0ef          	jal	ra,80001c2e <kerneltrap>
    80004e14:	6082                	ld	ra,0(sp)
    80004e16:	6122                	ld	sp,8(sp)
    80004e18:	61c2                	ld	gp,16(sp)
    80004e1a:	7282                	ld	t0,32(sp)
    80004e1c:	7322                	ld	t1,40(sp)
    80004e1e:	73c2                	ld	t2,48(sp)
    80004e20:	7462                	ld	s0,56(sp)
    80004e22:	6486                	ld	s1,64(sp)
    80004e24:	6526                	ld	a0,72(sp)
    80004e26:	65c6                	ld	a1,80(sp)
    80004e28:	6666                	ld	a2,88(sp)
    80004e2a:	7686                	ld	a3,96(sp)
    80004e2c:	7726                	ld	a4,104(sp)
    80004e2e:	77c6                	ld	a5,112(sp)
    80004e30:	7866                	ld	a6,120(sp)
    80004e32:	688a                	ld	a7,128(sp)
    80004e34:	692a                	ld	s2,136(sp)
    80004e36:	69ca                	ld	s3,144(sp)
    80004e38:	6a6a                	ld	s4,152(sp)
    80004e3a:	7a8a                	ld	s5,160(sp)
    80004e3c:	7b2a                	ld	s6,168(sp)
    80004e3e:	7bca                	ld	s7,176(sp)
    80004e40:	7c6a                	ld	s8,184(sp)
    80004e42:	6c8e                	ld	s9,192(sp)
    80004e44:	6d2e                	ld	s10,200(sp)
    80004e46:	6dce                	ld	s11,208(sp)
    80004e48:	6e6e                	ld	t3,216(sp)
    80004e4a:	7e8e                	ld	t4,224(sp)
    80004e4c:	7f2e                	ld	t5,232(sp)
    80004e4e:	7fce                	ld	t6,240(sp)
    80004e50:	6111                	addi	sp,sp,256
    80004e52:	10200073          	sret
    80004e56:	00000013          	nop
    80004e5a:	00000013          	nop
    80004e5e:	0001                	nop

0000000080004e60 <timervec>:
    80004e60:	34051573          	csrrw	a0,mscratch,a0
    80004e64:	e10c                	sd	a1,0(a0)
    80004e66:	e510                	sd	a2,8(a0)
    80004e68:	e914                	sd	a3,16(a0)
    80004e6a:	6d0c                	ld	a1,24(a0)
    80004e6c:	7110                	ld	a2,32(a0)
    80004e6e:	6194                	ld	a3,0(a1)
    80004e70:	96b2                	add	a3,a3,a2
    80004e72:	e194                	sd	a3,0(a1)
    80004e74:	4589                	li	a1,2
    80004e76:	14459073          	csrw	sip,a1
    80004e7a:	6914                	ld	a3,16(a0)
    80004e7c:	6510                	ld	a2,8(a0)
    80004e7e:	610c                	ld	a1,0(a0)
    80004e80:	34051573          	csrrw	a0,mscratch,a0
    80004e84:	30200073          	mret
	...

0000000080004e8a <plicinit>:

//
// the riscv Platform Level Interrupt Controller (PLIC).
//

void plicinit(void) {
    80004e8a:	1141                	addi	sp,sp,-16
    80004e8c:	e422                	sd	s0,8(sp)
    80004e8e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ * 4) = 1;
    80004e90:	0c0007b7          	lui	a5,0xc000
    80004e94:	4705                	li	a4,1
    80004e96:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ * 4) = 1;
    80004e98:	c3d8                	sw	a4,4(a5)
}
    80004e9a:	6422                	ld	s0,8(sp)
    80004e9c:	0141                	addi	sp,sp,16
    80004e9e:	8082                	ret

0000000080004ea0 <plicinithart>:

void plicinithart(void) {
    80004ea0:	1141                	addi	sp,sp,-16
    80004ea2:	e406                	sd	ra,8(sp)
    80004ea4:	e022                	sd	s0,0(sp)
    80004ea6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004ea8:	ffffc097          	auipc	ra,0xffffc
    80004eac:	d96080e7          	jalr	-618(ra) # 80000c3e <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004eb0:	0085171b          	slliw	a4,a0,0x8
    80004eb4:	0c0027b7          	lui	a5,0xc002
    80004eb8:	97ba                	add	a5,a5,a4
    80004eba:	40200713          	li	a4,1026
    80004ebe:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004ec2:	00d5151b          	slliw	a0,a0,0xd
    80004ec6:	0c2017b7          	lui	a5,0xc201
    80004eca:	97aa                	add	a5,a5,a0
    80004ecc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004ed0:	60a2                	ld	ra,8(sp)
    80004ed2:	6402                	ld	s0,0(sp)
    80004ed4:	0141                	addi	sp,sp,16
    80004ed6:	8082                	ret

0000000080004ed8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int plic_claim(void) {
    80004ed8:	1141                	addi	sp,sp,-16
    80004eda:	e406                	sd	ra,8(sp)
    80004edc:	e022                	sd	s0,0(sp)
    80004ede:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004ee0:	ffffc097          	auipc	ra,0xffffc
    80004ee4:	d5e080e7          	jalr	-674(ra) # 80000c3e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004ee8:	00d5151b          	slliw	a0,a0,0xd
    80004eec:	0c2017b7          	lui	a5,0xc201
    80004ef0:	97aa                	add	a5,a5,a0
  return irq;
}
    80004ef2:	43c8                	lw	a0,4(a5)
    80004ef4:	60a2                	ld	ra,8(sp)
    80004ef6:	6402                	ld	s0,0(sp)
    80004ef8:	0141                	addi	sp,sp,16
    80004efa:	8082                	ret

0000000080004efc <plic_complete>:

// tell the PLIC we've served this IRQ.
void plic_complete(int irq) {
    80004efc:	1101                	addi	sp,sp,-32
    80004efe:	ec06                	sd	ra,24(sp)
    80004f00:	e822                	sd	s0,16(sp)
    80004f02:	e426                	sd	s1,8(sp)
    80004f04:	1000                	addi	s0,sp,32
    80004f06:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004f08:	ffffc097          	auipc	ra,0xffffc
    80004f0c:	d36080e7          	jalr	-714(ra) # 80000c3e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004f10:	00d5151b          	slliw	a0,a0,0xd
    80004f14:	0c2017b7          	lui	a5,0xc201
    80004f18:	97aa                	add	a5,a5,a0
    80004f1a:	c3c4                	sw	s1,4(a5)
}
    80004f1c:	60e2                	ld	ra,24(sp)
    80004f1e:	6442                	ld	s0,16(sp)
    80004f20:	64a2                	ld	s1,8(sp)
    80004f22:	6105                	addi	sp,sp,32
    80004f24:	8082                	ret

0000000080004f26 <free_desc>:
  }
  return -1;
}

// mark a descriptor as free.
static void free_desc(int i) {
    80004f26:	1141                	addi	sp,sp,-16
    80004f28:	e406                	sd	ra,8(sp)
    80004f2a:	e022                	sd	s0,0(sp)
    80004f2c:	0800                	addi	s0,sp,16
  if (i >= NUM) panic("free_desc 1");
    80004f2e:	479d                	li	a5,7
    80004f30:	04a7cc63          	blt	a5,a0,80004f88 <free_desc+0x62>
  if (disk.free[i]) panic("free_desc 2");
    80004f34:	0000e797          	auipc	a5,0xe
    80004f38:	22c78793          	addi	a5,a5,556 # 80013160 <disk>
    80004f3c:	97aa                	add	a5,a5,a0
    80004f3e:	0187c783          	lbu	a5,24(a5)
    80004f42:	ebb9                	bnez	a5,80004f98 <free_desc+0x72>
  disk.desc[i].addr = 0;
    80004f44:	00451693          	slli	a3,a0,0x4
    80004f48:	0000e797          	auipc	a5,0xe
    80004f4c:	21878793          	addi	a5,a5,536 # 80013160 <disk>
    80004f50:	6398                	ld	a4,0(a5)
    80004f52:	9736                	add	a4,a4,a3
    80004f54:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004f58:	6398                	ld	a4,0(a5)
    80004f5a:	9736                	add	a4,a4,a3
    80004f5c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004f60:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004f64:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004f68:	97aa                	add	a5,a5,a0
    80004f6a:	4705                	li	a4,1
    80004f6c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004f70:	0000e517          	auipc	a0,0xe
    80004f74:	20850513          	addi	a0,a0,520 # 80013178 <disk+0x18>
    80004f78:	ffffc097          	auipc	ra,0xffffc
    80004f7c:	436080e7          	jalr	1078(ra) # 800013ae <wakeup>
}
    80004f80:	60a2                	ld	ra,8(sp)
    80004f82:	6402                	ld	s0,0(sp)
    80004f84:	0141                	addi	sp,sp,16
    80004f86:	8082                	ret
  if (i >= NUM) panic("free_desc 1");
    80004f88:	00003517          	auipc	a0,0x3
    80004f8c:	70850513          	addi	a0,a0,1800 # 80008690 <syscalls+0x2f0>
    80004f90:	00001097          	auipc	ra,0x1
    80004f94:	6f4080e7          	jalr	1780(ra) # 80006684 <panic>
  if (disk.free[i]) panic("free_desc 2");
    80004f98:	00003517          	auipc	a0,0x3
    80004f9c:	70850513          	addi	a0,a0,1800 # 800086a0 <syscalls+0x300>
    80004fa0:	00001097          	auipc	ra,0x1
    80004fa4:	6e4080e7          	jalr	1764(ra) # 80006684 <panic>

0000000080004fa8 <virtio_disk_init>:
void virtio_disk_init(void) {
    80004fa8:	1101                	addi	sp,sp,-32
    80004faa:	ec06                	sd	ra,24(sp)
    80004fac:	e822                	sd	s0,16(sp)
    80004fae:	e426                	sd	s1,8(sp)
    80004fb0:	e04a                	sd	s2,0(sp)
    80004fb2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004fb4:	00003597          	auipc	a1,0x3
    80004fb8:	6fc58593          	addi	a1,a1,1788 # 800086b0 <syscalls+0x310>
    80004fbc:	0000e517          	auipc	a0,0xe
    80004fc0:	2cc50513          	addi	a0,a0,716 # 80013288 <disk+0x128>
    80004fc4:	00002097          	auipc	ra,0x2
    80004fc8:	b68080e7          	jalr	-1176(ra) # 80006b2c <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004fcc:	100017b7          	lui	a5,0x10001
    80004fd0:	4398                	lw	a4,0(a5)
    80004fd2:	2701                	sext.w	a4,a4
    80004fd4:	747277b7          	lui	a5,0x74727
    80004fd8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004fdc:	14f71b63          	bne	a4,a5,80005132 <virtio_disk_init+0x18a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004fe0:	100017b7          	lui	a5,0x10001
    80004fe4:	43dc                	lw	a5,4(a5)
    80004fe6:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004fe8:	4709                	li	a4,2
    80004fea:	14e79463          	bne	a5,a4,80005132 <virtio_disk_init+0x18a>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004fee:	100017b7          	lui	a5,0x10001
    80004ff2:	479c                	lw	a5,8(a5)
    80004ff4:	2781                	sext.w	a5,a5
    80004ff6:	12e79e63          	bne	a5,a4,80005132 <virtio_disk_init+0x18a>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80004ffa:	100017b7          	lui	a5,0x10001
    80004ffe:	47d8                	lw	a4,12(a5)
    80005000:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005002:	554d47b7          	lui	a5,0x554d4
    80005006:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000500a:	12f71463          	bne	a4,a5,80005132 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000500e:	100017b7          	lui	a5,0x10001
    80005012:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005016:	4705                	li	a4,1
    80005018:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000501a:	470d                	li	a4,3
    8000501c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000501e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005020:	c7ffe6b7          	lui	a3,0xc7ffe
    80005024:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fe325f>
    80005028:	8f75                	and	a4,a4,a3
    8000502a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000502c:	472d                	li	a4,11
    8000502e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005030:	5bbc                	lw	a5,112(a5)
    80005032:	0007891b          	sext.w	s2,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005036:	8ba1                	andi	a5,a5,8
    80005038:	10078563          	beqz	a5,80005142 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000503c:	100017b7          	lui	a5,0x10001
    80005040:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY)) panic("virtio disk should not be ready");
    80005044:	43fc                	lw	a5,68(a5)
    80005046:	2781                	sext.w	a5,a5
    80005048:	10079563          	bnez	a5,80005152 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000504c:	100017b7          	lui	a5,0x10001
    80005050:	5bdc                	lw	a5,52(a5)
    80005052:	2781                	sext.w	a5,a5
  if (max == 0) panic("virtio disk has no queue 0");
    80005054:	10078763          	beqz	a5,80005162 <virtio_disk_init+0x1ba>
  if (max < NUM) panic("virtio disk max queue too short");
    80005058:	471d                	li	a4,7
    8000505a:	10f77c63          	bgeu	a4,a5,80005172 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000505e:	ffffb097          	auipc	ra,0xffffb
    80005062:	ffe080e7          	jalr	-2(ra) # 8000005c <kalloc>
    80005066:	0000e497          	auipc	s1,0xe
    8000506a:	0fa48493          	addi	s1,s1,250 # 80013160 <disk>
    8000506e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005070:	ffffb097          	auipc	ra,0xffffb
    80005074:	fec080e7          	jalr	-20(ra) # 8000005c <kalloc>
    80005078:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000507a:	ffffb097          	auipc	ra,0xffffb
    8000507e:	fe2080e7          	jalr	-30(ra) # 8000005c <kalloc>
    80005082:	87aa                	mv	a5,a0
    80005084:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used) panic("virtio disk kalloc");
    80005086:	6088                	ld	a0,0(s1)
    80005088:	cd6d                	beqz	a0,80005182 <virtio_disk_init+0x1da>
    8000508a:	0000e717          	auipc	a4,0xe
    8000508e:	0de73703          	ld	a4,222(a4) # 80013168 <disk+0x8>
    80005092:	cb65                	beqz	a4,80005182 <virtio_disk_init+0x1da>
    80005094:	c7fd                	beqz	a5,80005182 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005096:	6605                	lui	a2,0x1
    80005098:	4581                	li	a1,0
    8000509a:	ffffb097          	auipc	ra,0xffffb
    8000509e:	fdc080e7          	jalr	-36(ra) # 80000076 <memset>
  memset(disk.avail, 0, PGSIZE);
    800050a2:	0000e497          	auipc	s1,0xe
    800050a6:	0be48493          	addi	s1,s1,190 # 80013160 <disk>
    800050aa:	6605                	lui	a2,0x1
    800050ac:	4581                	li	a1,0
    800050ae:	6488                	ld	a0,8(s1)
    800050b0:	ffffb097          	auipc	ra,0xffffb
    800050b4:	fc6080e7          	jalr	-58(ra) # 80000076 <memset>
  memset(disk.used, 0, PGSIZE);
    800050b8:	6605                	lui	a2,0x1
    800050ba:	4581                	li	a1,0
    800050bc:	6888                	ld	a0,16(s1)
    800050be:	ffffb097          	auipc	ra,0xffffb
    800050c2:	fb8080e7          	jalr	-72(ra) # 80000076 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800050c6:	100017b7          	lui	a5,0x10001
    800050ca:	4721                	li	a4,8
    800050cc:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800050ce:	4098                	lw	a4,0(s1)
    800050d0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800050d4:	40d8                	lw	a4,4(s1)
    800050d6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800050da:	6498                	ld	a4,8(s1)
    800050dc:	0007069b          	sext.w	a3,a4
    800050e0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800050e4:	9701                	srai	a4,a4,0x20
    800050e6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800050ea:	6898                	ld	a4,16(s1)
    800050ec:	0007069b          	sext.w	a3,a4
    800050f0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800050f4:	9701                	srai	a4,a4,0x20
    800050f6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800050fa:	4705                	li	a4,1
    800050fc:	c3f8                	sw	a4,68(a5)
  for (int i = 0; i < NUM; i++) disk.free[i] = 1;
    800050fe:	00e48c23          	sb	a4,24(s1)
    80005102:	00e48ca3          	sb	a4,25(s1)
    80005106:	00e48d23          	sb	a4,26(s1)
    8000510a:	00e48da3          	sb	a4,27(s1)
    8000510e:	00e48e23          	sb	a4,28(s1)
    80005112:	00e48ea3          	sb	a4,29(s1)
    80005116:	00e48f23          	sb	a4,30(s1)
    8000511a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000511e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005122:	0727a823          	sw	s2,112(a5)
}
    80005126:	60e2                	ld	ra,24(sp)
    80005128:	6442                	ld	s0,16(sp)
    8000512a:	64a2                	ld	s1,8(sp)
    8000512c:	6902                	ld	s2,0(sp)
    8000512e:	6105                	addi	sp,sp,32
    80005130:	8082                	ret
    panic("could not find virtio disk");
    80005132:	00003517          	auipc	a0,0x3
    80005136:	58e50513          	addi	a0,a0,1422 # 800086c0 <syscalls+0x320>
    8000513a:	00001097          	auipc	ra,0x1
    8000513e:	54a080e7          	jalr	1354(ra) # 80006684 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005142:	00003517          	auipc	a0,0x3
    80005146:	59e50513          	addi	a0,a0,1438 # 800086e0 <syscalls+0x340>
    8000514a:	00001097          	auipc	ra,0x1
    8000514e:	53a080e7          	jalr	1338(ra) # 80006684 <panic>
  if (*R(VIRTIO_MMIO_QUEUE_READY)) panic("virtio disk should not be ready");
    80005152:	00003517          	auipc	a0,0x3
    80005156:	5ae50513          	addi	a0,a0,1454 # 80008700 <syscalls+0x360>
    8000515a:	00001097          	auipc	ra,0x1
    8000515e:	52a080e7          	jalr	1322(ra) # 80006684 <panic>
  if (max == 0) panic("virtio disk has no queue 0");
    80005162:	00003517          	auipc	a0,0x3
    80005166:	5be50513          	addi	a0,a0,1470 # 80008720 <syscalls+0x380>
    8000516a:	00001097          	auipc	ra,0x1
    8000516e:	51a080e7          	jalr	1306(ra) # 80006684 <panic>
  if (max < NUM) panic("virtio disk max queue too short");
    80005172:	00003517          	auipc	a0,0x3
    80005176:	5ce50513          	addi	a0,a0,1486 # 80008740 <syscalls+0x3a0>
    8000517a:	00001097          	auipc	ra,0x1
    8000517e:	50a080e7          	jalr	1290(ra) # 80006684 <panic>
  if (!disk.desc || !disk.avail || !disk.used) panic("virtio disk kalloc");
    80005182:	00003517          	auipc	a0,0x3
    80005186:	5de50513          	addi	a0,a0,1502 # 80008760 <syscalls+0x3c0>
    8000518a:	00001097          	auipc	ra,0x1
    8000518e:	4fa080e7          	jalr	1274(ra) # 80006684 <panic>

0000000080005192 <virtio_disk_rw>:
    }
  }
  return 0;
}

void virtio_disk_rw(struct buf *b, int write) {
    80005192:	7119                	addi	sp,sp,-128
    80005194:	fc86                	sd	ra,120(sp)
    80005196:	f8a2                	sd	s0,112(sp)
    80005198:	f4a6                	sd	s1,104(sp)
    8000519a:	f0ca                	sd	s2,96(sp)
    8000519c:	ecce                	sd	s3,88(sp)
    8000519e:	e8d2                	sd	s4,80(sp)
    800051a0:	e4d6                	sd	s5,72(sp)
    800051a2:	e0da                	sd	s6,64(sp)
    800051a4:	fc5e                	sd	s7,56(sp)
    800051a6:	f862                	sd	s8,48(sp)
    800051a8:	f466                	sd	s9,40(sp)
    800051aa:	f06a                	sd	s10,32(sp)
    800051ac:	ec6e                	sd	s11,24(sp)
    800051ae:	0100                	addi	s0,sp,128
    800051b0:	8aaa                	mv	s5,a0
    800051b2:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800051b4:	00c52d03          	lw	s10,12(a0)
    800051b8:	001d1d1b          	slliw	s10,s10,0x1
    800051bc:	1d02                	slli	s10,s10,0x20
    800051be:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    800051c2:	0000e517          	auipc	a0,0xe
    800051c6:	0c650513          	addi	a0,a0,198 # 80013288 <disk+0x128>
    800051ca:	00002097          	auipc	ra,0x2
    800051ce:	9f2080e7          	jalr	-1550(ra) # 80006bbc <acquire>
  for (int i = 0; i < 3; i++) {
    800051d2:	4981                	li	s3,0
  for (int i = 0; i < NUM; i++) {
    800051d4:	44a1                	li	s1,8
      disk.free[i] = 0;
    800051d6:	0000eb97          	auipc	s7,0xe
    800051da:	f8ab8b93          	addi	s7,s7,-118 # 80013160 <disk>
  for (int i = 0; i < 3; i++) {
    800051de:	4b0d                	li	s6,3
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800051e0:	0000ec97          	auipc	s9,0xe
    800051e4:	0a8c8c93          	addi	s9,s9,168 # 80013288 <disk+0x128>
    800051e8:	a08d                	j	8000524a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800051ea:	00fb8733          	add	a4,s7,a5
    800051ee:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800051f2:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    800051f4:	0207c563          	bltz	a5,8000521e <virtio_disk_rw+0x8c>
  for (int i = 0; i < 3; i++) {
    800051f8:	2905                	addiw	s2,s2,1
    800051fa:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800051fc:	05690c63          	beq	s2,s6,80005254 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005200:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    80005202:	0000e717          	auipc	a4,0xe
    80005206:	f5e70713          	addi	a4,a4,-162 # 80013160 <disk>
    8000520a:	87ce                	mv	a5,s3
    if (disk.free[i]) {
    8000520c:	01874683          	lbu	a3,24(a4)
    80005210:	fee9                	bnez	a3,800051ea <virtio_disk_rw+0x58>
  for (int i = 0; i < NUM; i++) {
    80005212:	2785                	addiw	a5,a5,1
    80005214:	0705                	addi	a4,a4,1
    80005216:	fe979be3          	bne	a5,s1,8000520c <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000521a:	57fd                	li	a5,-1
    8000521c:	c19c                	sw	a5,0(a1)
      for (int j = 0; j < i; j++) free_desc(idx[j]);
    8000521e:	01205d63          	blez	s2,80005238 <virtio_disk_rw+0xa6>
    80005222:	8dce                	mv	s11,s3
    80005224:	000a2503          	lw	a0,0(s4)
    80005228:	00000097          	auipc	ra,0x0
    8000522c:	cfe080e7          	jalr	-770(ra) # 80004f26 <free_desc>
    80005230:	2d85                	addiw	s11,s11,1
    80005232:	0a11                	addi	s4,s4,4
    80005234:	ff2d98e3          	bne	s11,s2,80005224 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005238:	85e6                	mv	a1,s9
    8000523a:	0000e517          	auipc	a0,0xe
    8000523e:	f3e50513          	addi	a0,a0,-194 # 80013178 <disk+0x18>
    80005242:	ffffc097          	auipc	ra,0xffffc
    80005246:	108080e7          	jalr	264(ra) # 8000134a <sleep>
  for (int i = 0; i < 3; i++) {
    8000524a:	f8040a13          	addi	s4,s0,-128
void virtio_disk_rw(struct buf *b, int write) {
    8000524e:	8652                	mv	a2,s4
  for (int i = 0; i < 3; i++) {
    80005250:	894e                	mv	s2,s3
    80005252:	b77d                	j	80005200 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005254:	f8042503          	lw	a0,-128(s0)
    80005258:	00a50713          	addi	a4,a0,10
    8000525c:	0712                	slli	a4,a4,0x4

  if (write)
    8000525e:	0000e797          	auipc	a5,0xe
    80005262:	f0278793          	addi	a5,a5,-254 # 80013160 <disk>
    80005266:	00e786b3          	add	a3,a5,a4
    8000526a:	01803633          	snez	a2,s8
    8000526e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT;  // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN;  // read the disk
  buf0->reserved = 0;
    80005270:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005274:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64)buf0;
    80005278:	f6070613          	addi	a2,a4,-160
    8000527c:	6394                	ld	a3,0(a5)
    8000527e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005280:	00870593          	addi	a1,a4,8
    80005284:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    80005286:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005288:	0007b803          	ld	a6,0(a5)
    8000528c:	9642                	add	a2,a2,a6
    8000528e:	46c1                	li	a3,16
    80005290:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005292:	4585                	li	a1,1
    80005294:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005298:	f8442683          	lw	a3,-124(s0)
    8000529c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64)b->data;
    800052a0:	0692                	slli	a3,a3,0x4
    800052a2:	9836                	add	a6,a6,a3
    800052a4:	058a8613          	addi	a2,s5,88
    800052a8:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    800052ac:	0007b803          	ld	a6,0(a5)
    800052b0:	96c2                	add	a3,a3,a6
    800052b2:	40000613          	li	a2,1024
    800052b6:	c690                	sw	a2,8(a3)
  if (write)
    800052b8:	001c3613          	seqz	a2,s8
    800052bc:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0;  // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE;  // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800052c0:	00166613          	ori	a2,a2,1
    800052c4:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800052c8:	f8842603          	lw	a2,-120(s0)
    800052cc:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff;  // device writes 0 on success
    800052d0:	00250693          	addi	a3,a0,2
    800052d4:	0692                	slli	a3,a3,0x4
    800052d6:	96be                	add	a3,a3,a5
    800052d8:	58fd                	li	a7,-1
    800052da:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    800052de:	0612                	slli	a2,a2,0x4
    800052e0:	9832                	add	a6,a6,a2
    800052e2:	f9070713          	addi	a4,a4,-112
    800052e6:	973e                	add	a4,a4,a5
    800052e8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800052ec:	6398                	ld	a4,0(a5)
    800052ee:	9732                	add	a4,a4,a2
    800052f0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE;  // device writes the status
    800052f2:	4609                	li	a2,2
    800052f4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800052f8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800052fc:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80005300:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005304:	6794                	ld	a3,8(a5)
    80005306:	0026d703          	lhu	a4,2(a3)
    8000530a:	8b1d                	andi	a4,a4,7
    8000530c:	0706                	slli	a4,a4,0x1
    8000530e:	96ba                	add	a3,a3,a4
    80005310:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005314:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1;  // not % NUM ...
    80005318:	6798                	ld	a4,8(a5)
    8000531a:	00275783          	lhu	a5,2(a4)
    8000531e:	2785                	addiw	a5,a5,1
    80005320:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005324:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0;  // value is queue number
    80005328:	100017b7          	lui	a5,0x10001
    8000532c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    80005330:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    80005334:	0000e917          	auipc	s2,0xe
    80005338:	f5490913          	addi	s2,s2,-172 # 80013288 <disk+0x128>
  while (b->disk == 1) {
    8000533c:	4485                	li	s1,1
    8000533e:	00b79c63          	bne	a5,a1,80005356 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005342:	85ca                	mv	a1,s2
    80005344:	8556                	mv	a0,s5
    80005346:	ffffc097          	auipc	ra,0xffffc
    8000534a:	004080e7          	jalr	4(ra) # 8000134a <sleep>
  while (b->disk == 1) {
    8000534e:	004aa783          	lw	a5,4(s5)
    80005352:	fe9788e3          	beq	a5,s1,80005342 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005356:	f8042903          	lw	s2,-128(s0)
    8000535a:	00290713          	addi	a4,s2,2
    8000535e:	0712                	slli	a4,a4,0x4
    80005360:	0000e797          	auipc	a5,0xe
    80005364:	e0078793          	addi	a5,a5,-512 # 80013160 <disk>
    80005368:	97ba                	add	a5,a5,a4
    8000536a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000536e:	0000e997          	auipc	s3,0xe
    80005372:	df298993          	addi	s3,s3,-526 # 80013160 <disk>
    80005376:	00491713          	slli	a4,s2,0x4
    8000537a:	0009b783          	ld	a5,0(s3)
    8000537e:	97ba                	add	a5,a5,a4
    80005380:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005384:	854a                	mv	a0,s2
    80005386:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000538a:	00000097          	auipc	ra,0x0
    8000538e:	b9c080e7          	jalr	-1124(ra) # 80004f26 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    80005392:	8885                	andi	s1,s1,1
    80005394:	f0ed                	bnez	s1,80005376 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005396:	0000e517          	auipc	a0,0xe
    8000539a:	ef250513          	addi	a0,a0,-270 # 80013288 <disk+0x128>
    8000539e:	00002097          	auipc	ra,0x2
    800053a2:	8cc080e7          	jalr	-1844(ra) # 80006c6a <release>
}
    800053a6:	70e6                	ld	ra,120(sp)
    800053a8:	7446                	ld	s0,112(sp)
    800053aa:	74a6                	ld	s1,104(sp)
    800053ac:	7906                	ld	s2,96(sp)
    800053ae:	69e6                	ld	s3,88(sp)
    800053b0:	6a46                	ld	s4,80(sp)
    800053b2:	6aa6                	ld	s5,72(sp)
    800053b4:	6b06                	ld	s6,64(sp)
    800053b6:	7be2                	ld	s7,56(sp)
    800053b8:	7c42                	ld	s8,48(sp)
    800053ba:	7ca2                	ld	s9,40(sp)
    800053bc:	7d02                	ld	s10,32(sp)
    800053be:	6de2                	ld	s11,24(sp)
    800053c0:	6109                	addi	sp,sp,128
    800053c2:	8082                	ret

00000000800053c4 <virtio_disk_intr>:

void virtio_disk_intr() {
    800053c4:	1101                	addi	sp,sp,-32
    800053c6:	ec06                	sd	ra,24(sp)
    800053c8:	e822                	sd	s0,16(sp)
    800053ca:	e426                	sd	s1,8(sp)
    800053cc:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800053ce:	0000e497          	auipc	s1,0xe
    800053d2:	d9248493          	addi	s1,s1,-622 # 80013160 <disk>
    800053d6:	0000e517          	auipc	a0,0xe
    800053da:	eb250513          	addi	a0,a0,-334 # 80013288 <disk+0x128>
    800053de:	00001097          	auipc	ra,0x1
    800053e2:	7de080e7          	jalr	2014(ra) # 80006bbc <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800053e6:	10001737          	lui	a4,0x10001
    800053ea:	533c                	lw	a5,96(a4)
    800053ec:	8b8d                	andi	a5,a5,3
    800053ee:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800053f0:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    800053f4:	689c                	ld	a5,16(s1)
    800053f6:	0204d703          	lhu	a4,32(s1)
    800053fa:	0027d783          	lhu	a5,2(a5)
    800053fe:	04f70863          	beq	a4,a5,8000544e <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005402:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005406:	6898                	ld	a4,16(s1)
    80005408:	0204d783          	lhu	a5,32(s1)
    8000540c:	8b9d                	andi	a5,a5,7
    8000540e:	078e                	slli	a5,a5,0x3
    80005410:	97ba                	add	a5,a5,a4
    80005412:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0) panic("virtio_disk_intr status");
    80005414:	00278713          	addi	a4,a5,2
    80005418:	0712                	slli	a4,a4,0x4
    8000541a:	9726                	add	a4,a4,s1
    8000541c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005420:	e721                	bnez	a4,80005468 <virtio_disk_intr+0xa4>

    struct buf *b = disk.info[id].b;
    80005422:	0789                	addi	a5,a5,2
    80005424:	0792                	slli	a5,a5,0x4
    80005426:	97a6                	add	a5,a5,s1
    80005428:	6788                	ld	a0,8(a5)
    b->disk = 0;  // disk is done with buf
    8000542a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000542e:	ffffc097          	auipc	ra,0xffffc
    80005432:	f80080e7          	jalr	-128(ra) # 800013ae <wakeup>

    disk.used_idx += 1;
    80005436:	0204d783          	lhu	a5,32(s1)
    8000543a:	2785                	addiw	a5,a5,1
    8000543c:	17c2                	slli	a5,a5,0x30
    8000543e:	93c1                	srli	a5,a5,0x30
    80005440:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    80005444:	6898                	ld	a4,16(s1)
    80005446:	00275703          	lhu	a4,2(a4)
    8000544a:	faf71ce3          	bne	a4,a5,80005402 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000544e:	0000e517          	auipc	a0,0xe
    80005452:	e3a50513          	addi	a0,a0,-454 # 80013288 <disk+0x128>
    80005456:	00002097          	auipc	ra,0x2
    8000545a:	814080e7          	jalr	-2028(ra) # 80006c6a <release>
}
    8000545e:	60e2                	ld	ra,24(sp)
    80005460:	6442                	ld	s0,16(sp)
    80005462:	64a2                	ld	s1,8(sp)
    80005464:	6105                	addi	sp,sp,32
    80005466:	8082                	ret
    if (disk.info[id].status != 0) panic("virtio_disk_intr status");
    80005468:	00003517          	auipc	a0,0x3
    8000546c:	31050513          	addi	a0,a0,784 # 80008778 <syscalls+0x3d8>
    80005470:	00001097          	auipc	ra,0x1
    80005474:	214080e7          	jalr	532(ra) # 80006684 <panic>

0000000080005478 <bit_isset>:
static Sz_info *bd_sizes;
static void *bd_base;  // start address of memory managed by the buddy allocator
static struct spinlock lock;

// Return 1 if bit at position index in array is set to 1
int bit_isset(char *array, int index) {
    80005478:	1141                	addi	sp,sp,-16
    8000547a:	e422                	sd	s0,8(sp)
    8000547c:	0800                	addi	s0,sp,16
  char b = array[index / 8];
  char m = (1 << (index % 8));
    8000547e:	0075f793          	andi	a5,a1,7
    80005482:	4705                	li	a4,1
    80005484:	00f7173b          	sllw	a4,a4,a5
  char b = array[index / 8];
    80005488:	41f5d79b          	sraiw	a5,a1,0x1f
    8000548c:	01d7d79b          	srliw	a5,a5,0x1d
    80005490:	9fad                	addw	a5,a5,a1
    80005492:	4037d79b          	sraiw	a5,a5,0x3
    80005496:	953e                	add	a0,a0,a5
  return (b & m) == m;
    80005498:	00054503          	lbu	a0,0(a0)
    8000549c:	8d79                	and	a0,a0,a4
    8000549e:	0ff77713          	zext.b	a4,a4
    800054a2:	8d19                	sub	a0,a0,a4
}
    800054a4:	00153513          	seqz	a0,a0
    800054a8:	6422                	ld	s0,8(sp)
    800054aa:	0141                	addi	sp,sp,16
    800054ac:	8082                	ret

00000000800054ae <bit_set>:

// Set bit at position index in array to 1
void bit_set(char *array, int index) {
    800054ae:	1141                	addi	sp,sp,-16
    800054b0:	e422                	sd	s0,8(sp)
    800054b2:	0800                	addi	s0,sp,16
  char b = array[index / 8];
    800054b4:	41f5d79b          	sraiw	a5,a1,0x1f
    800054b8:	01d7d79b          	srliw	a5,a5,0x1d
    800054bc:	9fad                	addw	a5,a5,a1
    800054be:	4037d79b          	sraiw	a5,a5,0x3
    800054c2:	953e                	add	a0,a0,a5
  char m = (1 << (index % 8));
    800054c4:	899d                	andi	a1,a1,7
    800054c6:	4705                	li	a4,1
    800054c8:	00b7173b          	sllw	a4,a4,a1
  array[index / 8] = (b | m);
    800054cc:	00054783          	lbu	a5,0(a0)
    800054d0:	8fd9                	or	a5,a5,a4
    800054d2:	00f50023          	sb	a5,0(a0)
}
    800054d6:	6422                	ld	s0,8(sp)
    800054d8:	0141                	addi	sp,sp,16
    800054da:	8082                	ret

00000000800054dc <bit_flip>:

// Flip bit at position index in array to 1
void bit_flip(char *array, int index) {
    800054dc:	1141                	addi	sp,sp,-16
    800054de:	e422                	sd	s0,8(sp)
    800054e0:	0800                	addi	s0,sp,16
  char b = array[index / 8];
    800054e2:	41f5d79b          	sraiw	a5,a1,0x1f
    800054e6:	01d7d79b          	srliw	a5,a5,0x1d
    800054ea:	9fad                	addw	a5,a5,a1
    800054ec:	4037d79b          	sraiw	a5,a5,0x3
    800054f0:	953e                	add	a0,a0,a5
  char m = (1 << (index % 8));
    800054f2:	899d                	andi	a1,a1,7
    800054f4:	4705                	li	a4,1
    800054f6:	00b7173b          	sllw	a4,a4,a1
  array[index / 8] = (b ^ m);
    800054fa:	00054783          	lbu	a5,0(a0)
    800054fe:	8fb9                	xor	a5,a5,a4
    80005500:	00f50023          	sb	a5,0(a0)
}
    80005504:	6422                	ld	s0,8(sp)
    80005506:	0141                	addi	sp,sp,16
    80005508:	8082                	ret

000000008000550a <bit_clear>:

// Clear bit at position index in array
void bit_clear(char *array, int index) {
    8000550a:	1141                	addi	sp,sp,-16
    8000550c:	e422                	sd	s0,8(sp)
    8000550e:	0800                	addi	s0,sp,16
  char b = array[index / 8];
    80005510:	41f5d79b          	sraiw	a5,a1,0x1f
    80005514:	01d7d79b          	srliw	a5,a5,0x1d
    80005518:	9fad                	addw	a5,a5,a1
    8000551a:	4037d79b          	sraiw	a5,a5,0x3
    8000551e:	953e                	add	a0,a0,a5
  char m = (1 << (index % 8));
    80005520:	899d                	andi	a1,a1,7
    80005522:	4785                	li	a5,1
    80005524:	00b797bb          	sllw	a5,a5,a1
  array[index / 8] = (b & ~m);
    80005528:	fff7c793          	not	a5,a5
    8000552c:	00054703          	lbu	a4,0(a0)
    80005530:	8ff9                	and	a5,a5,a4
    80005532:	00f50023          	sb	a5,0(a0)
}
    80005536:	6422                	ld	s0,8(sp)
    80005538:	0141                	addi	sp,sp,16
    8000553a:	8082                	ret

000000008000553c <bd_print_vector>:

// Print a bit vector as a list of ranges of 1 bits
void bd_print_vector(char *vector, int len) {
    8000553c:	715d                	addi	sp,sp,-80
    8000553e:	e486                	sd	ra,72(sp)
    80005540:	e0a2                	sd	s0,64(sp)
    80005542:	fc26                	sd	s1,56(sp)
    80005544:	f84a                	sd	s2,48(sp)
    80005546:	f44e                	sd	s3,40(sp)
    80005548:	f052                	sd	s4,32(sp)
    8000554a:	ec56                	sd	s5,24(sp)
    8000554c:	e85a                	sd	s6,16(sp)
    8000554e:	e45e                	sd	s7,8(sp)
    80005550:	0880                	addi	s0,sp,80
    80005552:	8a2e                	mv	s4,a1
  int last, lb;

  last = 1;
  lb = 0;
  for (int b = 0; b < len; b++) {
    80005554:	08b05b63          	blez	a1,800055ea <bd_print_vector+0xae>
    80005558:	89aa                	mv	s3,a0
    8000555a:	4481                	li	s1,0
  lb = 0;
    8000555c:	4a81                	li	s5,0
  last = 1;
    8000555e:	4905                	li	s2,1
    if (last == bit_isset(vector, b)) continue;
    if (last == 1) printf(" [%d, %d)", lb, b);
    80005560:	4b05                	li	s6,1
    80005562:	00003b97          	auipc	s7,0x3
    80005566:	22eb8b93          	addi	s7,s7,558 # 80008790 <syscalls+0x3f0>
    8000556a:	a821                	j	80005582 <bd_print_vector+0x46>
    lb = b;
    last = bit_isset(vector, b);
    8000556c:	85a6                	mv	a1,s1
    8000556e:	854e                	mv	a0,s3
    80005570:	00000097          	auipc	ra,0x0
    80005574:	f08080e7          	jalr	-248(ra) # 80005478 <bit_isset>
    80005578:	892a                	mv	s2,a0
    8000557a:	8aa6                	mv	s5,s1
  for (int b = 0; b < len; b++) {
    8000557c:	2485                	addiw	s1,s1,1
    8000557e:	029a0463          	beq	s4,s1,800055a6 <bd_print_vector+0x6a>
    if (last == bit_isset(vector, b)) continue;
    80005582:	85a6                	mv	a1,s1
    80005584:	854e                	mv	a0,s3
    80005586:	00000097          	auipc	ra,0x0
    8000558a:	ef2080e7          	jalr	-270(ra) # 80005478 <bit_isset>
    8000558e:	ff2507e3          	beq	a0,s2,8000557c <bd_print_vector+0x40>
    if (last == 1) printf(" [%d, %d)", lb, b);
    80005592:	fd691de3          	bne	s2,s6,8000556c <bd_print_vector+0x30>
    80005596:	8626                	mv	a2,s1
    80005598:	85d6                	mv	a1,s5
    8000559a:	855e                	mv	a0,s7
    8000559c:	00001097          	auipc	ra,0x1
    800055a0:	132080e7          	jalr	306(ra) # 800066ce <printf>
    800055a4:	b7e1                	j	8000556c <bd_print_vector+0x30>
  }
  if (lb == 0 || last == 1) {
    800055a6:	000a8563          	beqz	s5,800055b0 <bd_print_vector+0x74>
    800055aa:	4785                	li	a5,1
    800055ac:	00f91c63          	bne	s2,a5,800055c4 <bd_print_vector+0x88>
    printf(" [%d, %d)", lb, len);
    800055b0:	8652                	mv	a2,s4
    800055b2:	85d6                	mv	a1,s5
    800055b4:	00003517          	auipc	a0,0x3
    800055b8:	1dc50513          	addi	a0,a0,476 # 80008790 <syscalls+0x3f0>
    800055bc:	00001097          	auipc	ra,0x1
    800055c0:	112080e7          	jalr	274(ra) # 800066ce <printf>
  }
  printf("\n");
    800055c4:	00003517          	auipc	a0,0x3
    800055c8:	a6450513          	addi	a0,a0,-1436 # 80008028 <etext+0x28>
    800055cc:	00001097          	auipc	ra,0x1
    800055d0:	102080e7          	jalr	258(ra) # 800066ce <printf>
}
    800055d4:	60a6                	ld	ra,72(sp)
    800055d6:	6406                	ld	s0,64(sp)
    800055d8:	74e2                	ld	s1,56(sp)
    800055da:	7942                	ld	s2,48(sp)
    800055dc:	79a2                	ld	s3,40(sp)
    800055de:	7a02                	ld	s4,32(sp)
    800055e0:	6ae2                	ld	s5,24(sp)
    800055e2:	6b42                	ld	s6,16(sp)
    800055e4:	6ba2                	ld	s7,8(sp)
    800055e6:	6161                	addi	sp,sp,80
    800055e8:	8082                	ret
  lb = 0;
    800055ea:	4a81                	li	s5,0
    800055ec:	b7d1                	j	800055b0 <bd_print_vector+0x74>

00000000800055ee <bd_print>:

// Print buddy's data structures
void bd_print() {
  for (int k = 0; k < nsizes; k++) {
    800055ee:	00003697          	auipc	a3,0x3
    800055f2:	4126a683          	lw	a3,1042(a3) # 80008a00 <nsizes>
    800055f6:	12d05063          	blez	a3,80005716 <bd_print+0x128>
void bd_print() {
    800055fa:	7159                	addi	sp,sp,-112
    800055fc:	f486                	sd	ra,104(sp)
    800055fe:	f0a2                	sd	s0,96(sp)
    80005600:	eca6                	sd	s1,88(sp)
    80005602:	e8ca                	sd	s2,80(sp)
    80005604:	e4ce                	sd	s3,72(sp)
    80005606:	e0d2                	sd	s4,64(sp)
    80005608:	fc56                	sd	s5,56(sp)
    8000560a:	f85a                	sd	s6,48(sp)
    8000560c:	f45e                	sd	s7,40(sp)
    8000560e:	f062                	sd	s8,32(sp)
    80005610:	ec66                	sd	s9,24(sp)
    80005612:	e86a                	sd	s10,16(sp)
    80005614:	e46e                	sd	s11,8(sp)
    80005616:	1880                	addi	s0,sp,112
  for (int k = 0; k < nsizes; k++) {
    80005618:	4481                	li	s1,0
    printf("size %d (blksz %d nblk %d): free list: ", k, BLK_SIZE(k), NBLK(k));
    8000561a:	4a85                	li	s5,1
    8000561c:	4c41                	li	s8,16
    8000561e:	00003b97          	auipc	s7,0x3
    80005622:	182b8b93          	addi	s7,s7,386 # 800087a0 <syscalls+0x400>
    lst_print(&bd_sizes[k].free);
    80005626:	00003a17          	auipc	s4,0x3
    8000562a:	3d2a0a13          	addi	s4,s4,978 # 800089f8 <bd_sizes>
    printf("  alloc:");
    8000562e:	00003b17          	auipc	s6,0x3
    80005632:	19ab0b13          	addi	s6,s6,410 # 800087c8 <syscalls+0x428>
    if (k + 1 < nsizes) {
    80005636:	00003997          	auipc	s3,0x3
    8000563a:	3ca98993          	addi	s3,s3,970 # 80008a00 <nsizes>
      bd_print_vector(bd_sizes[k].alloc, NBLK(k + 1));
    } else {
      printf(" -\n");
    8000563e:	00003c97          	auipc	s9,0x3
    80005642:	19ac8c93          	addi	s9,s9,410 # 800087d8 <syscalls+0x438>
    }
    if (k > 0) {
      printf("  split:");
    80005646:	00003d17          	auipc	s10,0x3
    8000564a:	19ad0d13          	addi	s10,s10,410 # 800087e0 <syscalls+0x440>
    8000564e:	a00d                	j	80005670 <bd_print+0x82>
      printf(" -\n");
    80005650:	8566                	mv	a0,s9
    80005652:	00001097          	auipc	ra,0x1
    80005656:	07c080e7          	jalr	124(ra) # 800066ce <printf>
    if (k > 0) {
    8000565a:	0004879b          	sext.w	a5,s1
    8000565e:	06f04863          	bgtz	a5,800056ce <bd_print+0xe0>
  for (int k = 0; k < nsizes; k++) {
    80005662:	0009a683          	lw	a3,0(s3)
    80005666:	0485                	addi	s1,s1,1
    80005668:	0004879b          	sext.w	a5,s1
    8000566c:	08d7d663          	bge	a5,a3,800056f8 <bd_print+0x10a>
    80005670:	0004891b          	sext.w	s2,s1
    printf("size %d (blksz %d nblk %d): free list: ", k, BLK_SIZE(k), NBLK(k));
    80005674:	36fd                	addiw	a3,a3,-1
    80005676:	9e85                	subw	a3,a3,s1
    80005678:	00da96bb          	sllw	a3,s5,a3
    8000567c:	009c1633          	sll	a2,s8,s1
    80005680:	85ca                	mv	a1,s2
    80005682:	855e                	mv	a0,s7
    80005684:	00001097          	auipc	ra,0x1
    80005688:	04a080e7          	jalr	74(ra) # 800066ce <printf>
    lst_print(&bd_sizes[k].free);
    8000568c:	00549d93          	slli	s11,s1,0x5
    80005690:	000a3503          	ld	a0,0(s4)
    80005694:	956e                	add	a0,a0,s11
    80005696:	00001097          	auipc	ra,0x1
    8000569a:	a7c080e7          	jalr	-1412(ra) # 80006112 <lst_print>
    printf("  alloc:");
    8000569e:	855a                	mv	a0,s6
    800056a0:	00001097          	auipc	ra,0x1
    800056a4:	02e080e7          	jalr	46(ra) # 800066ce <printf>
    if (k + 1 < nsizes) {
    800056a8:	0009a583          	lw	a1,0(s3)
    800056ac:	0014879b          	addiw	a5,s1,1
    800056b0:	fab7d0e3          	bge	a5,a1,80005650 <bd_print+0x62>
      bd_print_vector(bd_sizes[k].alloc, NBLK(k + 1));
    800056b4:	412585bb          	subw	a1,a1,s2
    800056b8:	000a3783          	ld	a5,0(s4)
    800056bc:	97ee                	add	a5,a5,s11
    800056be:	00ba95bb          	sllw	a1,s5,a1
    800056c2:	6b88                	ld	a0,16(a5)
    800056c4:	00000097          	auipc	ra,0x0
    800056c8:	e78080e7          	jalr	-392(ra) # 8000553c <bd_print_vector>
    800056cc:	b779                	j	8000565a <bd_print+0x6c>
      printf("  split:");
    800056ce:	856a                	mv	a0,s10
    800056d0:	00001097          	auipc	ra,0x1
    800056d4:	ffe080e7          	jalr	-2(ra) # 800066ce <printf>
      bd_print_vector(bd_sizes[k].split, NBLK(k));
    800056d8:	0009a583          	lw	a1,0(s3)
    800056dc:	35fd                	addiw	a1,a1,-1
    800056de:	412585bb          	subw	a1,a1,s2
    800056e2:	000a3783          	ld	a5,0(s4)
    800056e6:	97ee                	add	a5,a5,s11
    800056e8:	00ba95bb          	sllw	a1,s5,a1
    800056ec:	6f88                	ld	a0,24(a5)
    800056ee:	00000097          	auipc	ra,0x0
    800056f2:	e4e080e7          	jalr	-434(ra) # 8000553c <bd_print_vector>
    800056f6:	b7b5                	j	80005662 <bd_print+0x74>
    }
  }
}
    800056f8:	70a6                	ld	ra,104(sp)
    800056fa:	7406                	ld	s0,96(sp)
    800056fc:	64e6                	ld	s1,88(sp)
    800056fe:	6946                	ld	s2,80(sp)
    80005700:	69a6                	ld	s3,72(sp)
    80005702:	6a06                	ld	s4,64(sp)
    80005704:	7ae2                	ld	s5,56(sp)
    80005706:	7b42                	ld	s6,48(sp)
    80005708:	7ba2                	ld	s7,40(sp)
    8000570a:	7c02                	ld	s8,32(sp)
    8000570c:	6ce2                	ld	s9,24(sp)
    8000570e:	6d42                	ld	s10,16(sp)
    80005710:	6da2                	ld	s11,8(sp)
    80005712:	6165                	addi	sp,sp,112
    80005714:	8082                	ret
    80005716:	8082                	ret

0000000080005718 <firstk>:

// What is the first k such that 2^k >= n?
int firstk(uint64 n) {
    80005718:	1141                	addi	sp,sp,-16
    8000571a:	e422                	sd	s0,8(sp)
    8000571c:	0800                	addi	s0,sp,16
  int k = 0;
  uint64 size = LEAF_SIZE;

  while (size < n) {
    8000571e:	47c1                	li	a5,16
    80005720:	00a7fb63          	bgeu	a5,a0,80005736 <firstk+0x1e>
    80005724:	872a                	mv	a4,a0
  int k = 0;
    80005726:	4501                	li	a0,0
    k++;
    80005728:	2505                	addiw	a0,a0,1
    size *= 2;
    8000572a:	0786                	slli	a5,a5,0x1
  while (size < n) {
    8000572c:	fee7eee3          	bltu	a5,a4,80005728 <firstk+0x10>
  }
  return k;
}
    80005730:	6422                	ld	s0,8(sp)
    80005732:	0141                	addi	sp,sp,16
    80005734:	8082                	ret
  int k = 0;
    80005736:	4501                	li	a0,0
    80005738:	bfe5                	j	80005730 <firstk+0x18>

000000008000573a <blk_index>:

// Compute the block index for address p at size k
int blk_index(int k, char *p) {
    8000573a:	1141                	addi	sp,sp,-16
    8000573c:	e422                	sd	s0,8(sp)
    8000573e:	0800                	addi	s0,sp,16
  int n = p - (char *)bd_base;
  return n / BLK_SIZE(k);
    80005740:	00003797          	auipc	a5,0x3
    80005744:	2b07b783          	ld	a5,688(a5) # 800089f0 <bd_base>
    80005748:	9d9d                	subw	a1,a1,a5
    8000574a:	47c1                	li	a5,16
    8000574c:	00a797b3          	sll	a5,a5,a0
    80005750:	02f5c5b3          	div	a1,a1,a5
}
    80005754:	0005851b          	sext.w	a0,a1
    80005758:	6422                	ld	s0,8(sp)
    8000575a:	0141                	addi	sp,sp,16
    8000575c:	8082                	ret

000000008000575e <addr>:

// Convert a block index at size k back into an address
void *addr(int k, int bi) {
    8000575e:	1141                	addi	sp,sp,-16
    80005760:	e422                	sd	s0,8(sp)
    80005762:	0800                	addi	s0,sp,16
  int n = bi * BLK_SIZE(k);
    80005764:	47c1                	li	a5,16
    80005766:	00a797b3          	sll	a5,a5,a0
  return (char *)bd_base + n;
    8000576a:	02b787bb          	mulw	a5,a5,a1
}
    8000576e:	00003517          	auipc	a0,0x3
    80005772:	28253503          	ld	a0,642(a0) # 800089f0 <bd_base>
    80005776:	953e                	add	a0,a0,a5
    80005778:	6422                	ld	s0,8(sp)
    8000577a:	0141                	addi	sp,sp,16
    8000577c:	8082                	ret

000000008000577e <bd_malloc>:

// allocate nbytes, but malloc won't return anything smaller than LEAF_SIZE
void *bd_malloc(uint64 nbytes) {
    8000577e:	7159                	addi	sp,sp,-112
    80005780:	f486                	sd	ra,104(sp)
    80005782:	f0a2                	sd	s0,96(sp)
    80005784:	eca6                	sd	s1,88(sp)
    80005786:	e8ca                	sd	s2,80(sp)
    80005788:	e4ce                	sd	s3,72(sp)
    8000578a:	e0d2                	sd	s4,64(sp)
    8000578c:	fc56                	sd	s5,56(sp)
    8000578e:	f85a                	sd	s6,48(sp)
    80005790:	f45e                	sd	s7,40(sp)
    80005792:	f062                	sd	s8,32(sp)
    80005794:	ec66                	sd	s9,24(sp)
    80005796:	e86a                	sd	s10,16(sp)
    80005798:	e46e                	sd	s11,8(sp)
    8000579a:	1880                	addi	s0,sp,112
    8000579c:	84aa                	mv	s1,a0
  int fk, k;

  acquire(&lock);
    8000579e:	0000e517          	auipc	a0,0xe
    800057a2:	b0250513          	addi	a0,a0,-1278 # 800132a0 <lock>
    800057a6:	00001097          	auipc	ra,0x1
    800057aa:	416080e7          	jalr	1046(ra) # 80006bbc <acquire>

  // Find a free block >= nbytes, starting with smallest k possible
  fk = firstk(nbytes);
    800057ae:	8526                	mv	a0,s1
    800057b0:	00000097          	auipc	ra,0x0
    800057b4:	f68080e7          	jalr	-152(ra) # 80005718 <firstk>
  for (k = fk; k < nsizes; k++) {
    800057b8:	00003797          	auipc	a5,0x3
    800057bc:	2487a783          	lw	a5,584(a5) # 80008a00 <nsizes>
    800057c0:	02f55d63          	bge	a0,a5,800057fa <bd_malloc+0x7c>
    800057c4:	8baa                	mv	s7,a0
    800057c6:	00551913          	slli	s2,a0,0x5
    800057ca:	84aa                	mv	s1,a0
    if (!lst_empty(&bd_sizes[k].free)) break;
    800057cc:	00003997          	auipc	s3,0x3
    800057d0:	22c98993          	addi	s3,s3,556 # 800089f8 <bd_sizes>
  for (k = fk; k < nsizes; k++) {
    800057d4:	00003a17          	auipc	s4,0x3
    800057d8:	22ca0a13          	addi	s4,s4,556 # 80008a00 <nsizes>
    if (!lst_empty(&bd_sizes[k].free)) break;
    800057dc:	0009b503          	ld	a0,0(s3)
    800057e0:	954a                	add	a0,a0,s2
    800057e2:	00001097          	auipc	ra,0x1
    800057e6:	8b6080e7          	jalr	-1866(ra) # 80006098 <lst_empty>
    800057ea:	c115                	beqz	a0,8000580e <bd_malloc+0x90>
  for (k = fk; k < nsizes; k++) {
    800057ec:	2485                	addiw	s1,s1,1
    800057ee:	02090913          	addi	s2,s2,32
    800057f2:	000a2783          	lw	a5,0(s4)
    800057f6:	fef4c3e3          	blt	s1,a5,800057dc <bd_malloc+0x5e>
  }
  if (k >= nsizes) {  // No free blocks?
    release(&lock);
    800057fa:	0000e517          	auipc	a0,0xe
    800057fe:	aa650513          	addi	a0,a0,-1370 # 800132a0 <lock>
    80005802:	00001097          	auipc	ra,0x1
    80005806:	468080e7          	jalr	1128(ra) # 80006c6a <release>
    return 0;
    8000580a:	4a81                	li	s5,0
    8000580c:	a8e9                	j	800058e6 <bd_malloc+0x168>
  if (k >= nsizes) {  // No free blocks?
    8000580e:	00003797          	auipc	a5,0x3
    80005812:	1f27a783          	lw	a5,498(a5) # 80008a00 <nsizes>
    80005816:	fef4d2e3          	bge	s1,a5,800057fa <bd_malloc+0x7c>
  }

  // Found a block; pop it and potentially split it.
  char *p = lst_pop(&bd_sizes[k].free);
    8000581a:	00549993          	slli	s3,s1,0x5
    8000581e:	00003917          	auipc	s2,0x3
    80005822:	1da90913          	addi	s2,s2,474 # 800089f8 <bd_sizes>
    80005826:	00093503          	ld	a0,0(s2)
    8000582a:	954e                	add	a0,a0,s3
    8000582c:	00001097          	auipc	ra,0x1
    80005830:	898080e7          	jalr	-1896(ra) # 800060c4 <lst_pop>
    80005834:	8aaa                	mv	s5,a0
  return n / BLK_SIZE(k);
    80005836:	00003797          	auipc	a5,0x3
    8000583a:	1ba7b783          	ld	a5,442(a5) # 800089f0 <bd_base>
    8000583e:	40f507bb          	subw	a5,a0,a5
    80005842:	4741                	li	a4,16
    80005844:	00971733          	sll	a4,a4,s1
    80005848:	02e7c7b3          	div	a5,a5,a4
  bit_flip(bd_sizes[k].alloc, blk_index(k, p) / 2);
    8000584c:	01f7d59b          	srliw	a1,a5,0x1f
    80005850:	9dbd                	addw	a1,a1,a5
    80005852:	00093783          	ld	a5,0(s2)
    80005856:	97ce                	add	a5,a5,s3
    80005858:	4015d59b          	sraiw	a1,a1,0x1
    8000585c:	6b88                	ld	a0,16(a5)
    8000585e:	00000097          	auipc	ra,0x0
    80005862:	c7e080e7          	jalr	-898(ra) # 800054dc <bit_flip>
  for (; k > fk; k--) {
    80005866:	069bd863          	bge	s7,s1,800058d6 <bd_malloc+0x158>
    // split a block at size k and mark one half allocated at size k-1
    // and put the buddy on the free list at size k-1
    char *q = p + BLK_SIZE(k - 1);  // p's buddy
    8000586a:	4b41                	li	s6,16
    bit_set(bd_sizes[k].split, blk_index(k, p));
    8000586c:	8d4a                	mv	s10,s2
  int n = p - (char *)bd_base;
    8000586e:	00003c97          	auipc	s9,0x3
    80005872:	182c8c93          	addi	s9,s9,386 # 800089f0 <bd_base>
    char *q = p + BLK_SIZE(k - 1);  // p's buddy
    80005876:	85a6                	mv	a1,s1
    80005878:	34fd                	addiw	s1,s1,-1
    8000587a:	009b1db3          	sll	s11,s6,s1
    8000587e:	01ba8c33          	add	s8,s5,s11
    bit_set(bd_sizes[k].split, blk_index(k, p));
    80005882:	000d3a03          	ld	s4,0(s10)
  int n = p - (char *)bd_base;
    80005886:	000cb903          	ld	s2,0(s9)
  return n / BLK_SIZE(k);
    8000588a:	412a893b          	subw	s2,s5,s2
    8000588e:	00bb15b3          	sll	a1,s6,a1
    80005892:	02b945b3          	div	a1,s2,a1
    bit_set(bd_sizes[k].split, blk_index(k, p));
    80005896:	013a07b3          	add	a5,s4,s3
    8000589a:	2581                	sext.w	a1,a1
    8000589c:	6f88                	ld	a0,24(a5)
    8000589e:	00000097          	auipc	ra,0x0
    800058a2:	c10080e7          	jalr	-1008(ra) # 800054ae <bit_set>
    bit_flip(bd_sizes[k - 1].alloc, blk_index(k - 1, p) / 2);
    800058a6:	1981                	addi	s3,s3,-32
    800058a8:	9a4e                	add	s4,s4,s3
  return n / BLK_SIZE(k);
    800058aa:	03b94933          	div	s2,s2,s11
    bit_flip(bd_sizes[k - 1].alloc, blk_index(k - 1, p) / 2);
    800058ae:	01f9559b          	srliw	a1,s2,0x1f
    800058b2:	012585bb          	addw	a1,a1,s2
    800058b6:	4015d59b          	sraiw	a1,a1,0x1
    800058ba:	010a3503          	ld	a0,16(s4)
    800058be:	00000097          	auipc	ra,0x0
    800058c2:	c1e080e7          	jalr	-994(ra) # 800054dc <bit_flip>
    lst_push(&bd_sizes[k - 1].free, q);
    800058c6:	85e2                	mv	a1,s8
    800058c8:	8552                	mv	a0,s4
    800058ca:	00001097          	auipc	ra,0x1
    800058ce:	830080e7          	jalr	-2000(ra) # 800060fa <lst_push>
  for (; k > fk; k--) {
    800058d2:	fb7492e3          	bne	s1,s7,80005876 <bd_malloc+0xf8>
  }
  release(&lock);
    800058d6:	0000e517          	auipc	a0,0xe
    800058da:	9ca50513          	addi	a0,a0,-1590 # 800132a0 <lock>
    800058de:	00001097          	auipc	ra,0x1
    800058e2:	38c080e7          	jalr	908(ra) # 80006c6a <release>

  return p;
}
    800058e6:	8556                	mv	a0,s5
    800058e8:	70a6                	ld	ra,104(sp)
    800058ea:	7406                	ld	s0,96(sp)
    800058ec:	64e6                	ld	s1,88(sp)
    800058ee:	6946                	ld	s2,80(sp)
    800058f0:	69a6                	ld	s3,72(sp)
    800058f2:	6a06                	ld	s4,64(sp)
    800058f4:	7ae2                	ld	s5,56(sp)
    800058f6:	7b42                	ld	s6,48(sp)
    800058f8:	7ba2                	ld	s7,40(sp)
    800058fa:	7c02                	ld	s8,32(sp)
    800058fc:	6ce2                	ld	s9,24(sp)
    800058fe:	6d42                	ld	s10,16(sp)
    80005900:	6da2                	ld	s11,8(sp)
    80005902:	6165                	addi	sp,sp,112
    80005904:	8082                	ret

0000000080005906 <size>:

// Find the size of the block that p points to.
int size(char *p) {
    80005906:	7139                	addi	sp,sp,-64
    80005908:	fc06                	sd	ra,56(sp)
    8000590a:	f822                	sd	s0,48(sp)
    8000590c:	f426                	sd	s1,40(sp)
    8000590e:	f04a                	sd	s2,32(sp)
    80005910:	ec4e                	sd	s3,24(sp)
    80005912:	e852                	sd	s4,16(sp)
    80005914:	e456                	sd	s5,8(sp)
    80005916:	e05a                	sd	s6,0(sp)
    80005918:	0080                	addi	s0,sp,64
  for (int k = 0; k < nsizes; k++) {
    8000591a:	00003a97          	auipc	s5,0x3
    8000591e:	0e6aaa83          	lw	s5,230(s5) # 80008a00 <nsizes>
  return n / BLK_SIZE(k);
    80005922:	00003797          	auipc	a5,0x3
    80005926:	0ce7b783          	ld	a5,206(a5) # 800089f0 <bd_base>
    8000592a:	40f50a3b          	subw	s4,a0,a5
    8000592e:	00003497          	auipc	s1,0x3
    80005932:	0ca4b483          	ld	s1,202(s1) # 800089f8 <bd_sizes>
    80005936:	03848493          	addi	s1,s1,56
  for (int k = 0; k < nsizes; k++) {
    8000593a:	4901                	li	s2,0
  return n / BLK_SIZE(k);
    8000593c:	4b41                	li	s6,16
  for (int k = 0; k < nsizes; k++) {
    8000593e:	03595363          	bge	s2,s5,80005964 <size+0x5e>
    if (bit_isset(bd_sizes[k + 1].split, blk_index(k + 1, p))) {
    80005942:	0019099b          	addiw	s3,s2,1
  return n / BLK_SIZE(k);
    80005946:	013b15b3          	sll	a1,s6,s3
    8000594a:	02ba45b3          	div	a1,s4,a1
    if (bit_isset(bd_sizes[k + 1].split, blk_index(k + 1, p))) {
    8000594e:	2581                	sext.w	a1,a1
    80005950:	6088                	ld	a0,0(s1)
    80005952:	00000097          	auipc	ra,0x0
    80005956:	b26080e7          	jalr	-1242(ra) # 80005478 <bit_isset>
    8000595a:	02048493          	addi	s1,s1,32
    8000595e:	e501                	bnez	a0,80005966 <size+0x60>
  for (int k = 0; k < nsizes; k++) {
    80005960:	894e                	mv	s2,s3
    80005962:	bff1                	j	8000593e <size+0x38>
      return k;
    }
  }
  return 0;
    80005964:	4901                	li	s2,0
}
    80005966:	854a                	mv	a0,s2
    80005968:	70e2                	ld	ra,56(sp)
    8000596a:	7442                	ld	s0,48(sp)
    8000596c:	74a2                	ld	s1,40(sp)
    8000596e:	7902                	ld	s2,32(sp)
    80005970:	69e2                	ld	s3,24(sp)
    80005972:	6a42                	ld	s4,16(sp)
    80005974:	6aa2                	ld	s5,8(sp)
    80005976:	6b02                	ld	s6,0(sp)
    80005978:	6121                	addi	sp,sp,64
    8000597a:	8082                	ret

000000008000597c <bd_free>:

// Free memory pointed to by p, which was earlier allocated using
// bd_malloc.
void bd_free(void *p) {
    8000597c:	7159                	addi	sp,sp,-112
    8000597e:	f486                	sd	ra,104(sp)
    80005980:	f0a2                	sd	s0,96(sp)
    80005982:	eca6                	sd	s1,88(sp)
    80005984:	e8ca                	sd	s2,80(sp)
    80005986:	e4ce                	sd	s3,72(sp)
    80005988:	e0d2                	sd	s4,64(sp)
    8000598a:	fc56                	sd	s5,56(sp)
    8000598c:	f85a                	sd	s6,48(sp)
    8000598e:	f45e                	sd	s7,40(sp)
    80005990:	f062                	sd	s8,32(sp)
    80005992:	ec66                	sd	s9,24(sp)
    80005994:	e86a                	sd	s10,16(sp)
    80005996:	e46e                	sd	s11,8(sp)
    80005998:	1880                	addi	s0,sp,112
    8000599a:	8baa                	mv	s7,a0
  void *q;
  int k;

  acquire(&lock);
    8000599c:	0000e517          	auipc	a0,0xe
    800059a0:	90450513          	addi	a0,a0,-1788 # 800132a0 <lock>
    800059a4:	00001097          	auipc	ra,0x1
    800059a8:	218080e7          	jalr	536(ra) # 80006bbc <acquire>
  for (k = size(p); k < MAXSIZE; k++) {
    800059ac:	855e                	mv	a0,s7
    800059ae:	00000097          	auipc	ra,0x0
    800059b2:	f58080e7          	jalr	-168(ra) # 80005906 <size>
    800059b6:	892a                	mv	s2,a0
    800059b8:	00003797          	auipc	a5,0x3
    800059bc:	0487a783          	lw	a5,72(a5) # 80008a00 <nsizes>
    800059c0:	37fd                	addiw	a5,a5,-1
    800059c2:	0cf55363          	bge	a0,a5,80005a88 <bd_free+0x10c>
    800059c6:	00150b13          	addi	s6,a0,1
    800059ca:	0b16                	slli	s6,s6,0x5
  int n = p - (char *)bd_base;
    800059cc:	00003d97          	auipc	s11,0x3
    800059d0:	024d8d93          	addi	s11,s11,36 # 800089f0 <bd_base>
  return n / BLK_SIZE(k);
    800059d4:	4d41                	li	s10,16
    int bi = blk_index(k, p);
    int buddy = (bi % 2 == 0) ? bi + 1 : bi - 1;
    bit_flip(bd_sizes[k].alloc, bi / 2);         // free p at size k
    800059d6:	00003c97          	auipc	s9,0x3
    800059da:	022c8c93          	addi	s9,s9,34 # 800089f8 <bd_sizes>
    800059de:	a081                	j	80005a1e <bd_free+0xa2>
    int buddy = (bi % 2 == 0) ? bi + 1 : bi - 1;
    800059e0:	fff70c1b          	addiw	s8,a4,-1
    800059e4:	a899                	j	80005a3a <bd_free+0xbe>
    if (buddy % 2 == 0) {
      p = q;
    }
    // at size k+1, mark that the merged buddy pair isn't split
    // anymore
    bit_clear(bd_sizes[k + 1].split, blk_index(k + 1, p));
    800059e6:	2905                	addiw	s2,s2,1
  int n = p - (char *)bd_base;
    800059e8:	000db583          	ld	a1,0(s11)
  return n / BLK_SIZE(k);
    800059ec:	40bb85bb          	subw	a1,s7,a1
    800059f0:	012d17b3          	sll	a5,s10,s2
    800059f4:	02f5c5b3          	div	a1,a1,a5
    bit_clear(bd_sizes[k + 1].split, blk_index(k + 1, p));
    800059f8:	000cb783          	ld	a5,0(s9)
    800059fc:	97da                	add	a5,a5,s6
    800059fe:	2581                	sext.w	a1,a1
    80005a00:	6f88                	ld	a0,24(a5)
    80005a02:	00000097          	auipc	ra,0x0
    80005a06:	b08080e7          	jalr	-1272(ra) # 8000550a <bit_clear>
  for (k = size(p); k < MAXSIZE; k++) {
    80005a0a:	020b0b13          	addi	s6,s6,32
    80005a0e:	00003797          	auipc	a5,0x3
    80005a12:	ff278793          	addi	a5,a5,-14 # 80008a00 <nsizes>
    80005a16:	439c                	lw	a5,0(a5)
    80005a18:	37fd                	addiw	a5,a5,-1
    80005a1a:	06f95763          	bge	s2,a5,80005a88 <bd_free+0x10c>
  int n = p - (char *)bd_base;
    80005a1e:	000db983          	ld	s3,0(s11)
  return n / BLK_SIZE(k);
    80005a22:	012d1ab3          	sll	s5,s10,s2
    80005a26:	413b87bb          	subw	a5,s7,s3
    80005a2a:	0357c7b3          	div	a5,a5,s5
    80005a2e:	0007871b          	sext.w	a4,a5
    int buddy = (bi % 2 == 0) ? bi + 1 : bi - 1;
    80005a32:	8b85                	andi	a5,a5,1
    80005a34:	f7d5                	bnez	a5,800059e0 <bd_free+0x64>
    80005a36:	00170c1b          	addiw	s8,a4,1
    bit_flip(bd_sizes[k].alloc, bi / 2);         // free p at size k
    80005a3a:	fe0b0793          	addi	a5,s6,-32
    80005a3e:	000cba03          	ld	s4,0(s9)
    80005a42:	9a3e                	add	s4,s4,a5
    80005a44:	01f7549b          	srliw	s1,a4,0x1f
    80005a48:	9cb9                	addw	s1,s1,a4
    80005a4a:	4014d49b          	sraiw	s1,s1,0x1
    80005a4e:	85a6                	mv	a1,s1
    80005a50:	010a3503          	ld	a0,16(s4)
    80005a54:	00000097          	auipc	ra,0x0
    80005a58:	a88080e7          	jalr	-1400(ra) # 800054dc <bit_flip>
    if (bit_isset(bd_sizes[k].alloc, bi / 2)) {  // is buddy allocated?
    80005a5c:	85a6                	mv	a1,s1
    80005a5e:	010a3503          	ld	a0,16(s4)
    80005a62:	00000097          	auipc	ra,0x0
    80005a66:	a16080e7          	jalr	-1514(ra) # 80005478 <bit_isset>
    80005a6a:	ed19                	bnez	a0,80005a88 <bd_free+0x10c>
  int n = bi * BLK_SIZE(k);
    80005a6c:	000c049b          	sext.w	s1,s8
  return (char *)bd_base + n;
    80005a70:	038a8abb          	mulw	s5,s5,s8
    80005a74:	99d6                	add	s3,s3,s5
    lst_remove(q);  // remove buddy from free list
    80005a76:	854e                	mv	a0,s3
    80005a78:	00000097          	auipc	ra,0x0
    80005a7c:	636080e7          	jalr	1590(ra) # 800060ae <lst_remove>
    if (buddy % 2 == 0) {
    80005a80:	8885                	andi	s1,s1,1
    80005a82:	f0b5                	bnez	s1,800059e6 <bd_free+0x6a>
      p = q;
    80005a84:	8bce                	mv	s7,s3
    80005a86:	b785                	j	800059e6 <bd_free+0x6a>
  }
  lst_push(&bd_sizes[k].free, p);
    80005a88:	0916                	slli	s2,s2,0x5
    80005a8a:	85de                	mv	a1,s7
    80005a8c:	00003517          	auipc	a0,0x3
    80005a90:	f6c53503          	ld	a0,-148(a0) # 800089f8 <bd_sizes>
    80005a94:	954a                	add	a0,a0,s2
    80005a96:	00000097          	auipc	ra,0x0
    80005a9a:	664080e7          	jalr	1636(ra) # 800060fa <lst_push>
  release(&lock);
    80005a9e:	0000e517          	auipc	a0,0xe
    80005aa2:	80250513          	addi	a0,a0,-2046 # 800132a0 <lock>
    80005aa6:	00001097          	auipc	ra,0x1
    80005aaa:	1c4080e7          	jalr	452(ra) # 80006c6a <release>
}
    80005aae:	70a6                	ld	ra,104(sp)
    80005ab0:	7406                	ld	s0,96(sp)
    80005ab2:	64e6                	ld	s1,88(sp)
    80005ab4:	6946                	ld	s2,80(sp)
    80005ab6:	69a6                	ld	s3,72(sp)
    80005ab8:	6a06                	ld	s4,64(sp)
    80005aba:	7ae2                	ld	s5,56(sp)
    80005abc:	7b42                	ld	s6,48(sp)
    80005abe:	7ba2                	ld	s7,40(sp)
    80005ac0:	7c02                	ld	s8,32(sp)
    80005ac2:	6ce2                	ld	s9,24(sp)
    80005ac4:	6d42                	ld	s10,16(sp)
    80005ac6:	6da2                	ld	s11,8(sp)
    80005ac8:	6165                	addi	sp,sp,112
    80005aca:	8082                	ret

0000000080005acc <blk_index_next>:

// Compute the first block at size k that doesn't contain p
int blk_index_next(int k, char *p) {
    80005acc:	1141                	addi	sp,sp,-16
    80005ace:	e422                	sd	s0,8(sp)
    80005ad0:	0800                	addi	s0,sp,16
  int n = (p - (char *)bd_base) / BLK_SIZE(k);
    80005ad2:	00003797          	auipc	a5,0x3
    80005ad6:	f1e7b783          	ld	a5,-226(a5) # 800089f0 <bd_base>
    80005ada:	8d9d                	sub	a1,a1,a5
    80005adc:	47c1                	li	a5,16
    80005ade:	00a797b3          	sll	a5,a5,a0
    80005ae2:	02f5c533          	div	a0,a1,a5
    80005ae6:	2501                	sext.w	a0,a0
  if ((p - (char *)bd_base) % BLK_SIZE(k) != 0) n++;
    80005ae8:	02f5e5b3          	rem	a1,a1,a5
    80005aec:	c191                	beqz	a1,80005af0 <blk_index_next+0x24>
    80005aee:	2505                	addiw	a0,a0,1
  return n;
}
    80005af0:	6422                	ld	s0,8(sp)
    80005af2:	0141                	addi	sp,sp,16
    80005af4:	8082                	ret

0000000080005af6 <log2>:

int log2(uint64 n) {
    80005af6:	1141                	addi	sp,sp,-16
    80005af8:	e422                	sd	s0,8(sp)
    80005afa:	0800                	addi	s0,sp,16
  int k = 0;
  while (n > 1) {
    80005afc:	4705                	li	a4,1
    80005afe:	00a77b63          	bgeu	a4,a0,80005b14 <log2+0x1e>
    80005b02:	87aa                	mv	a5,a0
  int k = 0;
    80005b04:	4501                	li	a0,0
    k++;
    80005b06:	2505                	addiw	a0,a0,1
    n = n >> 1;
    80005b08:	8385                	srli	a5,a5,0x1
  while (n > 1) {
    80005b0a:	fef76ee3          	bltu	a4,a5,80005b06 <log2+0x10>
  }
  return k;
}
    80005b0e:	6422                	ld	s0,8(sp)
    80005b10:	0141                	addi	sp,sp,16
    80005b12:	8082                	ret
  int k = 0;
    80005b14:	4501                	li	a0,0
    80005b16:	bfe5                	j	80005b0e <log2+0x18>

0000000080005b18 <bd_mark>:

// Mark memory from [start, stop), starting at size 0, as allocated.
void bd_mark(void *start, void *stop) {
    80005b18:	7119                	addi	sp,sp,-128
    80005b1a:	fc86                	sd	ra,120(sp)
    80005b1c:	f8a2                	sd	s0,112(sp)
    80005b1e:	f4a6                	sd	s1,104(sp)
    80005b20:	f0ca                	sd	s2,96(sp)
    80005b22:	ecce                	sd	s3,88(sp)
    80005b24:	e8d2                	sd	s4,80(sp)
    80005b26:	e4d6                	sd	s5,72(sp)
    80005b28:	e0da                	sd	s6,64(sp)
    80005b2a:	fc5e                	sd	s7,56(sp)
    80005b2c:	f862                	sd	s8,48(sp)
    80005b2e:	f466                	sd	s9,40(sp)
    80005b30:	f06a                	sd	s10,32(sp)
    80005b32:	ec6e                	sd	s11,24(sp)
    80005b34:	0100                	addi	s0,sp,128
    80005b36:	f8b43423          	sd	a1,-120(s0)
  int bi, bj;

  if (((uint64)start % LEAF_SIZE != 0) || ((uint64)stop % LEAF_SIZE != 0))
    80005b3a:	00b56b33          	or	s6,a0,a1
    80005b3e:	00fb7b13          	andi	s6,s6,15
    80005b42:	040b1363          	bnez	s6,80005b88 <bd_mark+0x70>
    80005b46:	8caa                	mv	s9,a0
    panic("bd_mark");

  for (int k = 0; k < nsizes; k++) {
    80005b48:	00003a17          	auipc	s4,0x3
    80005b4c:	eb8a2a03          	lw	s4,-328(s4) # 80008a00 <nsizes>
    80005b50:	4c05                	li	s8,1
    80005b52:	4901                	li	s2,0
  int n = p - (char *)bd_base;
    80005b54:	00003d97          	auipc	s11,0x3
    80005b58:	e9cd8d93          	addi	s11,s11,-356 # 800089f0 <bd_base>
  return n / BLK_SIZE(k);
    80005b5c:	4d41                	li	s10,16
    bi = blk_index(k, start);
    bj = blk_index_next(k, stop);
    for (; bi < bj; bi++) {
      if (k > 0) {
        // if a block is allocated at size k, mark it as split too.
        bit_set(bd_sizes[k].split, bi);
    80005b5e:	00003b97          	auipc	s7,0x3
    80005b62:	e9ab8b93          	addi	s7,s7,-358 # 800089f8 <bd_sizes>
  for (int k = 0; k < nsizes; k++) {
    80005b66:	07404e63          	bgtz	s4,80005be2 <bd_mark+0xca>
      if (k + 1 < nsizes) {
        bit_flip(bd_sizes[k].alloc, bi / 2);
      }
    }
  }
}
    80005b6a:	70e6                	ld	ra,120(sp)
    80005b6c:	7446                	ld	s0,112(sp)
    80005b6e:	74a6                	ld	s1,104(sp)
    80005b70:	7906                	ld	s2,96(sp)
    80005b72:	69e6                	ld	s3,88(sp)
    80005b74:	6a46                	ld	s4,80(sp)
    80005b76:	6aa6                	ld	s5,72(sp)
    80005b78:	6b06                	ld	s6,64(sp)
    80005b7a:	7be2                	ld	s7,56(sp)
    80005b7c:	7c42                	ld	s8,48(sp)
    80005b7e:	7ca2                	ld	s9,40(sp)
    80005b80:	7d02                	ld	s10,32(sp)
    80005b82:	6de2                	ld	s11,24(sp)
    80005b84:	6109                	addi	sp,sp,128
    80005b86:	8082                	ret
    panic("bd_mark");
    80005b88:	00003517          	auipc	a0,0x3
    80005b8c:	c6850513          	addi	a0,a0,-920 # 800087f0 <syscalls+0x450>
    80005b90:	00001097          	auipc	ra,0x1
    80005b94:	af4080e7          	jalr	-1292(ra) # 80006684 <panic>
      if (k + 1 < nsizes) {
    80005b98:	034ac163          	blt	s5,s4,80005bba <bd_mark+0xa2>
    for (; bi < bj; bi++) {
    80005b9c:	2485                	addiw	s1,s1,1
    80005b9e:	02998c63          	beq	s3,s1,80005bd6 <bd_mark+0xbe>
      if (k > 0) {
    80005ba2:	ff205be3          	blez	s2,80005b98 <bd_mark+0x80>
        bit_set(bd_sizes[k].split, bi);
    80005ba6:	000bb783          	ld	a5,0(s7)
    80005baa:	97da                	add	a5,a5,s6
    80005bac:	85a6                	mv	a1,s1
    80005bae:	6f88                	ld	a0,24(a5)
    80005bb0:	00000097          	auipc	ra,0x0
    80005bb4:	8fe080e7          	jalr	-1794(ra) # 800054ae <bit_set>
    80005bb8:	b7c5                	j	80005b98 <bd_mark+0x80>
        bit_flip(bd_sizes[k].alloc, bi / 2);
    80005bba:	01f4d59b          	srliw	a1,s1,0x1f
    80005bbe:	9da5                	addw	a1,a1,s1
    80005bc0:	000bb783          	ld	a5,0(s7)
    80005bc4:	97da                	add	a5,a5,s6
    80005bc6:	4015d59b          	sraiw	a1,a1,0x1
    80005bca:	6b88                	ld	a0,16(a5)
    80005bcc:	00000097          	auipc	ra,0x0
    80005bd0:	910080e7          	jalr	-1776(ra) # 800054dc <bit_flip>
    80005bd4:	b7e1                	j	80005b9c <bd_mark+0x84>
  for (int k = 0; k < nsizes; k++) {
    80005bd6:	2905                	addiw	s2,s2,1
    80005bd8:	2c05                	addiw	s8,s8,1
    80005bda:	020b0b13          	addi	s6,s6,32
    80005bde:	f94906e3          	beq	s2,s4,80005b6a <bd_mark+0x52>
  int n = p - (char *)bd_base;
    80005be2:	000db483          	ld	s1,0(s11)
  return n / BLK_SIZE(k);
    80005be6:	409c84bb          	subw	s1,s9,s1
    80005bea:	012d17b3          	sll	a5,s10,s2
    80005bee:	02f4c4b3          	div	s1,s1,a5
    80005bf2:	2481                	sext.w	s1,s1
    bj = blk_index_next(k, stop);
    80005bf4:	f8843583          	ld	a1,-120(s0)
    80005bf8:	854a                	mv	a0,s2
    80005bfa:	00000097          	auipc	ra,0x0
    80005bfe:	ed2080e7          	jalr	-302(ra) # 80005acc <blk_index_next>
    80005c02:	89aa                	mv	s3,a0
    for (; bi < bj; bi++) {
    80005c04:	fca4d9e3          	bge	s1,a0,80005bd6 <bd_mark+0xbe>
      if (k + 1 < nsizes) {
    80005c08:	000c0a9b          	sext.w	s5,s8
    80005c0c:	bf59                	j	80005ba2 <bd_mark+0x8a>

0000000080005c0e <bd_initfree_pair>:

// If a block is marked as allocated and the buddy is free, put the
// buddy on the free list at size k.
int bd_initfree_pair(int k, int bi, int right) {
    80005c0e:	7139                	addi	sp,sp,-64
    80005c10:	fc06                	sd	ra,56(sp)
    80005c12:	f822                	sd	s0,48(sp)
    80005c14:	f426                	sd	s1,40(sp)
    80005c16:	f04a                	sd	s2,32(sp)
    80005c18:	ec4e                	sd	s3,24(sp)
    80005c1a:	e852                	sd	s4,16(sp)
    80005c1c:	e456                	sd	s5,8(sp)
    80005c1e:	e05a                	sd	s6,0(sp)
    80005c20:	0080                	addi	s0,sp,64
    80005c22:	89aa                	mv	s3,a0
    80005c24:	8a32                	mv	s4,a2
  int buddy = (bi % 2 == 0) ? bi + 1 : bi - 1;
    80005c26:	00058a9b          	sext.w	s5,a1
    80005c2a:	0015f793          	andi	a5,a1,1
    80005c2e:	e7ad                	bnez	a5,80005c98 <bd_initfree_pair+0x8a>
    80005c30:	00158b1b          	addiw	s6,a1,1
  int free = 0;
  if (bit_isset(bd_sizes[k].alloc, bi / 2)) {
    80005c34:	00599793          	slli	a5,s3,0x5
    80005c38:	00003917          	auipc	s2,0x3
    80005c3c:	dc093903          	ld	s2,-576(s2) # 800089f8 <bd_sizes>
    80005c40:	993e                	add	s2,s2,a5
    80005c42:	01f5d79b          	srliw	a5,a1,0x1f
    80005c46:	9dbd                	addw	a1,a1,a5
    80005c48:	4015d59b          	sraiw	a1,a1,0x1
    80005c4c:	01093503          	ld	a0,16(s2)
    80005c50:	00000097          	auipc	ra,0x0
    80005c54:	828080e7          	jalr	-2008(ra) # 80005478 <bit_isset>
    80005c58:	84aa                	mv	s1,a0
    80005c5a:	c505                	beqz	a0,80005c82 <bd_initfree_pair+0x74>
    // one of the pair is free
    free = BLK_SIZE(k);
    80005c5c:	45c1                	li	a1,16
    80005c5e:	013595b3          	sll	a1,a1,s3
    80005c62:	0005849b          	sext.w	s1,a1
    if (right)
    80005c66:	020a0c63          	beqz	s4,80005c9e <bd_initfree_pair+0x90>
  return (char *)bd_base + n;
    80005c6a:	036585bb          	mulw	a1,a1,s6
      lst_push(&bd_sizes[k].free, addr(k, buddy));  // put buddy on free list
    80005c6e:	00003797          	auipc	a5,0x3
    80005c72:	d827b783          	ld	a5,-638(a5) # 800089f0 <bd_base>
    80005c76:	95be                	add	a1,a1,a5
    80005c78:	854a                	mv	a0,s2
    80005c7a:	00000097          	auipc	ra,0x0
    80005c7e:	480080e7          	jalr	1152(ra) # 800060fa <lst_push>
    else
      lst_push(&bd_sizes[k].free, addr(k, bi));  // put bi on free list
  }
  return free;
}
    80005c82:	8526                	mv	a0,s1
    80005c84:	70e2                	ld	ra,56(sp)
    80005c86:	7442                	ld	s0,48(sp)
    80005c88:	74a2                	ld	s1,40(sp)
    80005c8a:	7902                	ld	s2,32(sp)
    80005c8c:	69e2                	ld	s3,24(sp)
    80005c8e:	6a42                	ld	s4,16(sp)
    80005c90:	6aa2                	ld	s5,8(sp)
    80005c92:	6b02                	ld	s6,0(sp)
    80005c94:	6121                	addi	sp,sp,64
    80005c96:	8082                	ret
  int buddy = (bi % 2 == 0) ? bi + 1 : bi - 1;
    80005c98:	fff58b1b          	addiw	s6,a1,-1
    80005c9c:	bf61                	j	80005c34 <bd_initfree_pair+0x26>
  return (char *)bd_base + n;
    80005c9e:	035585bb          	mulw	a1,a1,s5
      lst_push(&bd_sizes[k].free, addr(k, bi));  // put bi on free list
    80005ca2:	00003797          	auipc	a5,0x3
    80005ca6:	d4e7b783          	ld	a5,-690(a5) # 800089f0 <bd_base>
    80005caa:	95be                	add	a1,a1,a5
    80005cac:	854a                	mv	a0,s2
    80005cae:	00000097          	auipc	ra,0x0
    80005cb2:	44c080e7          	jalr	1100(ra) # 800060fa <lst_push>
    80005cb6:	b7f1                	j	80005c82 <bd_initfree_pair+0x74>

0000000080005cb8 <bd_initfree>:

// Initialize the free lists for each size k.  For each size k, there
// are only two pairs that may have a buddy that should be on free list:
// bd_left and bd_right.
int bd_initfree(void *bd_left, void *bd_right) {
    80005cb8:	711d                	addi	sp,sp,-96
    80005cba:	ec86                	sd	ra,88(sp)
    80005cbc:	e8a2                	sd	s0,80(sp)
    80005cbe:	e4a6                	sd	s1,72(sp)
    80005cc0:	e0ca                	sd	s2,64(sp)
    80005cc2:	fc4e                	sd	s3,56(sp)
    80005cc4:	f852                	sd	s4,48(sp)
    80005cc6:	f456                	sd	s5,40(sp)
    80005cc8:	f05a                	sd	s6,32(sp)
    80005cca:	ec5e                	sd	s7,24(sp)
    80005ccc:	e862                	sd	s8,16(sp)
    80005cce:	e466                	sd	s9,8(sp)
    80005cd0:	e06a                	sd	s10,0(sp)
    80005cd2:	1080                	addi	s0,sp,96
  int free = 0;

  for (int k = 0; k < MAXSIZE; k++) {  // skip max size
    80005cd4:	00003717          	auipc	a4,0x3
    80005cd8:	d2c72703          	lw	a4,-724(a4) # 80008a00 <nsizes>
    80005cdc:	4785                	li	a5,1
    80005cde:	06e7dd63          	bge	a5,a4,80005d58 <bd_initfree+0xa0>
    80005ce2:	8aaa                	mv	s5,a0
    80005ce4:	8b2e                	mv	s6,a1
    80005ce6:	4901                	li	s2,0
  int free = 0;
    80005ce8:	4a01                	li	s4,0
  int n = p - (char *)bd_base;
    80005cea:	00003c97          	auipc	s9,0x3
    80005cee:	d06c8c93          	addi	s9,s9,-762 # 800089f0 <bd_base>
  return n / BLK_SIZE(k);
    80005cf2:	4c41                	li	s8,16
  for (int k = 0; k < MAXSIZE; k++) {  // skip max size
    80005cf4:	00003b97          	auipc	s7,0x3
    80005cf8:	d0cb8b93          	addi	s7,s7,-756 # 80008a00 <nsizes>
    80005cfc:	a039                	j	80005d0a <bd_initfree+0x52>
    80005cfe:	2905                	addiw	s2,s2,1
    80005d00:	000ba783          	lw	a5,0(s7)
    80005d04:	37fd                	addiw	a5,a5,-1
    80005d06:	04f95a63          	bge	s2,a5,80005d5a <bd_initfree+0xa2>
    int left = blk_index_next(k, bd_left);
    80005d0a:	85d6                	mv	a1,s5
    80005d0c:	854a                	mv	a0,s2
    80005d0e:	00000097          	auipc	ra,0x0
    80005d12:	dbe080e7          	jalr	-578(ra) # 80005acc <blk_index_next>
    80005d16:	89aa                	mv	s3,a0
  int n = p - (char *)bd_base;
    80005d18:	000cb483          	ld	s1,0(s9)
  return n / BLK_SIZE(k);
    80005d1c:	409b04bb          	subw	s1,s6,s1
    80005d20:	012c17b3          	sll	a5,s8,s2
    80005d24:	02f4c4b3          	div	s1,s1,a5
    80005d28:	2481                	sext.w	s1,s1
    int right = blk_index(k, bd_right);
    free += bd_initfree_pair(k, left, 0);
    80005d2a:	4601                	li	a2,0
    80005d2c:	85aa                	mv	a1,a0
    80005d2e:	854a                	mv	a0,s2
    80005d30:	00000097          	auipc	ra,0x0
    80005d34:	ede080e7          	jalr	-290(ra) # 80005c0e <bd_initfree_pair>
    80005d38:	01450d3b          	addw	s10,a0,s4
    80005d3c:	000d0a1b          	sext.w	s4,s10
    if (right <= left) continue;
    80005d40:	fa99dfe3          	bge	s3,s1,80005cfe <bd_initfree+0x46>
    free += bd_initfree_pair(k, right, 1);
    80005d44:	4605                	li	a2,1
    80005d46:	85a6                	mv	a1,s1
    80005d48:	854a                	mv	a0,s2
    80005d4a:	00000097          	auipc	ra,0x0
    80005d4e:	ec4080e7          	jalr	-316(ra) # 80005c0e <bd_initfree_pair>
    80005d52:	00ad0a3b          	addw	s4,s10,a0
    80005d56:	b765                	j	80005cfe <bd_initfree+0x46>
  int free = 0;
    80005d58:	4a01                	li	s4,0
  }
  return free;
}
    80005d5a:	8552                	mv	a0,s4
    80005d5c:	60e6                	ld	ra,88(sp)
    80005d5e:	6446                	ld	s0,80(sp)
    80005d60:	64a6                	ld	s1,72(sp)
    80005d62:	6906                	ld	s2,64(sp)
    80005d64:	79e2                	ld	s3,56(sp)
    80005d66:	7a42                	ld	s4,48(sp)
    80005d68:	7aa2                	ld	s5,40(sp)
    80005d6a:	7b02                	ld	s6,32(sp)
    80005d6c:	6be2                	ld	s7,24(sp)
    80005d6e:	6c42                	ld	s8,16(sp)
    80005d70:	6ca2                	ld	s9,8(sp)
    80005d72:	6d02                	ld	s10,0(sp)
    80005d74:	6125                	addi	sp,sp,96
    80005d76:	8082                	ret

0000000080005d78 <bd_mark_data_structures>:

// Mark the range [bd_base,p) as allocated
int bd_mark_data_structures(char *p) {
    80005d78:	7179                	addi	sp,sp,-48
    80005d7a:	f406                	sd	ra,40(sp)
    80005d7c:	f022                	sd	s0,32(sp)
    80005d7e:	ec26                	sd	s1,24(sp)
    80005d80:	e84a                	sd	s2,16(sp)
    80005d82:	e44e                	sd	s3,8(sp)
    80005d84:	1800                	addi	s0,sp,48
    80005d86:	892a                	mv	s2,a0
  int meta = p - (char *)bd_base;
    80005d88:	00003997          	auipc	s3,0x3
    80005d8c:	c6898993          	addi	s3,s3,-920 # 800089f0 <bd_base>
    80005d90:	0009b483          	ld	s1,0(s3)
    80005d94:	409504bb          	subw	s1,a0,s1
  printf("bd: %d meta bytes for managing %d bytes of memory\n", meta,
         BLK_SIZE(MAXSIZE));
    80005d98:	00003797          	auipc	a5,0x3
    80005d9c:	c687a783          	lw	a5,-920(a5) # 80008a00 <nsizes>
    80005da0:	37fd                	addiw	a5,a5,-1
  printf("bd: %d meta bytes for managing %d bytes of memory\n", meta,
    80005da2:	4641                	li	a2,16
    80005da4:	00f61633          	sll	a2,a2,a5
    80005da8:	85a6                	mv	a1,s1
    80005daa:	00003517          	auipc	a0,0x3
    80005dae:	a4e50513          	addi	a0,a0,-1458 # 800087f8 <syscalls+0x458>
    80005db2:	00001097          	auipc	ra,0x1
    80005db6:	91c080e7          	jalr	-1764(ra) # 800066ce <printf>
  bd_mark(bd_base, p);
    80005dba:	85ca                	mv	a1,s2
    80005dbc:	0009b503          	ld	a0,0(s3)
    80005dc0:	00000097          	auipc	ra,0x0
    80005dc4:	d58080e7          	jalr	-680(ra) # 80005b18 <bd_mark>
  return meta;
}
    80005dc8:	8526                	mv	a0,s1
    80005dca:	70a2                	ld	ra,40(sp)
    80005dcc:	7402                	ld	s0,32(sp)
    80005dce:	64e2                	ld	s1,24(sp)
    80005dd0:	6942                	ld	s2,16(sp)
    80005dd2:	69a2                	ld	s3,8(sp)
    80005dd4:	6145                	addi	sp,sp,48
    80005dd6:	8082                	ret

0000000080005dd8 <bd_mark_unavailable>:

// Mark the range [end, HEAPSIZE) as allocated
int bd_mark_unavailable(void *end, void *left) {
    80005dd8:	1101                	addi	sp,sp,-32
    80005dda:	ec06                	sd	ra,24(sp)
    80005ddc:	e822                	sd	s0,16(sp)
    80005dde:	e426                	sd	s1,8(sp)
    80005de0:	1000                	addi	s0,sp,32
  int unavailable = BLK_SIZE(MAXSIZE) - (end - bd_base);
    80005de2:	00003717          	auipc	a4,0x3
    80005de6:	c1e72703          	lw	a4,-994(a4) # 80008a00 <nsizes>
    80005dea:	377d                	addiw	a4,a4,-1
    80005dec:	47c1                	li	a5,16
    80005dee:	00e797b3          	sll	a5,a5,a4
    80005df2:	00003717          	auipc	a4,0x3
    80005df6:	bfe73703          	ld	a4,-1026(a4) # 800089f0 <bd_base>
    80005dfa:	8d19                	sub	a0,a0,a4
    80005dfc:	9f89                	subw	a5,a5,a0
    80005dfe:	0007849b          	sext.w	s1,a5
  if (unavailable > 0) unavailable = ROUNDUP(unavailable, LEAF_SIZE);
    80005e02:	00905a63          	blez	s1,80005e16 <bd_mark_unavailable+0x3e>
    80005e06:	37fd                	addiw	a5,a5,-1
    80005e08:	41f7d49b          	sraiw	s1,a5,0x1f
    80005e0c:	01c4d49b          	srliw	s1,s1,0x1c
    80005e10:	9cbd                	addw	s1,s1,a5
    80005e12:	98c1                	andi	s1,s1,-16
    80005e14:	24c1                	addiw	s1,s1,16
  printf("bd: 0x%x bytes unavailable\n", unavailable);
    80005e16:	85a6                	mv	a1,s1
    80005e18:	00003517          	auipc	a0,0x3
    80005e1c:	a1850513          	addi	a0,a0,-1512 # 80008830 <syscalls+0x490>
    80005e20:	00001097          	auipc	ra,0x1
    80005e24:	8ae080e7          	jalr	-1874(ra) # 800066ce <printf>

  void *bd_end = bd_base + BLK_SIZE(MAXSIZE) - unavailable;
    80005e28:	00003717          	auipc	a4,0x3
    80005e2c:	bc873703          	ld	a4,-1080(a4) # 800089f0 <bd_base>
    80005e30:	00003797          	auipc	a5,0x3
    80005e34:	bd07a783          	lw	a5,-1072(a5) # 80008a00 <nsizes>
    80005e38:	37fd                	addiw	a5,a5,-1
    80005e3a:	45c1                	li	a1,16
    80005e3c:	00f595b3          	sll	a1,a1,a5
    80005e40:	40958533          	sub	a0,a1,s1
  bd_mark(bd_end, bd_base + BLK_SIZE(MAXSIZE));
    80005e44:	95ba                	add	a1,a1,a4
    80005e46:	953a                	add	a0,a0,a4
    80005e48:	00000097          	auipc	ra,0x0
    80005e4c:	cd0080e7          	jalr	-816(ra) # 80005b18 <bd_mark>
  return unavailable;
}
    80005e50:	8526                	mv	a0,s1
    80005e52:	60e2                	ld	ra,24(sp)
    80005e54:	6442                	ld	s0,16(sp)
    80005e56:	64a2                	ld	s1,8(sp)
    80005e58:	6105                	addi	sp,sp,32
    80005e5a:	8082                	ret

0000000080005e5c <bd_init>:

// Initialize the buddy allocator: it manages memory from [base, end).
void bd_init(void *base, void *end) {
    80005e5c:	715d                	addi	sp,sp,-80
    80005e5e:	e486                	sd	ra,72(sp)
    80005e60:	e0a2                	sd	s0,64(sp)
    80005e62:	fc26                	sd	s1,56(sp)
    80005e64:	f84a                	sd	s2,48(sp)
    80005e66:	f44e                	sd	s3,40(sp)
    80005e68:	f052                	sd	s4,32(sp)
    80005e6a:	ec56                	sd	s5,24(sp)
    80005e6c:	e85a                	sd	s6,16(sp)
    80005e6e:	e45e                	sd	s7,8(sp)
    80005e70:	e062                	sd	s8,0(sp)
    80005e72:	0880                	addi	s0,sp,80
    80005e74:	8c2e                	mv	s8,a1
  char *p = (char *)ROUNDUP((uint64)base, LEAF_SIZE);
    80005e76:	fff50913          	addi	s2,a0,-1
    80005e7a:	ff097913          	andi	s2,s2,-16
    80005e7e:	0941                	addi	s2,s2,16
  int sz;

  initlock(&lock, "buddy");
    80005e80:	00003597          	auipc	a1,0x3
    80005e84:	9d058593          	addi	a1,a1,-1584 # 80008850 <syscalls+0x4b0>
    80005e88:	0000d517          	auipc	a0,0xd
    80005e8c:	41850513          	addi	a0,a0,1048 # 800132a0 <lock>
    80005e90:	00001097          	auipc	ra,0x1
    80005e94:	c9c080e7          	jalr	-868(ra) # 80006b2c <initlock>
  bd_base = (void *)p;
    80005e98:	00003797          	auipc	a5,0x3
    80005e9c:	b527bc23          	sd	s2,-1192(a5) # 800089f0 <bd_base>

  // compute the number of sizes we need to manage [base, end)
  nsizes = log2(((char *)end - p) / LEAF_SIZE) + 1;
    80005ea0:	412c04b3          	sub	s1,s8,s2
    80005ea4:	43f4d513          	srai	a0,s1,0x3f
    80005ea8:	893d                	andi	a0,a0,15
    80005eaa:	9526                	add	a0,a0,s1
    80005eac:	8511                	srai	a0,a0,0x4
    80005eae:	00000097          	auipc	ra,0x0
    80005eb2:	c48080e7          	jalr	-952(ra) # 80005af6 <log2>
  if ((char *)end - p > BLK_SIZE(MAXSIZE)) {
    80005eb6:	47c1                	li	a5,16
    80005eb8:	00a797b3          	sll	a5,a5,a0
    80005ebc:	1897cf63          	blt	a5,s1,8000605a <bd_init+0x1fe>
  nsizes = log2(((char *)end - p) / LEAF_SIZE) + 1;
    80005ec0:	2505                	addiw	a0,a0,1
    80005ec2:	00003797          	auipc	a5,0x3
    80005ec6:	b2a7af23          	sw	a0,-1218(a5) # 80008a00 <nsizes>
    nsizes++;  // round up to the next power of 2
  }

  printf("bd: memory sz is %d bytes; allocate an size array of length %d\n",
    80005eca:	00003997          	auipc	s3,0x3
    80005ece:	b3698993          	addi	s3,s3,-1226 # 80008a00 <nsizes>
    80005ed2:	0009a603          	lw	a2,0(s3)
    80005ed6:	85a6                	mv	a1,s1
    80005ed8:	00003517          	auipc	a0,0x3
    80005edc:	98050513          	addi	a0,a0,-1664 # 80008858 <syscalls+0x4b8>
    80005ee0:	00000097          	auipc	ra,0x0
    80005ee4:	7ee080e7          	jalr	2030(ra) # 800066ce <printf>
         (char *)end - p, nsizes);

  // allocate bd_sizes array
  bd_sizes = (Sz_info *)p;
    80005ee8:	00003797          	auipc	a5,0x3
    80005eec:	b127b823          	sd	s2,-1264(a5) # 800089f8 <bd_sizes>
  p += sizeof(Sz_info) * nsizes;
    80005ef0:	0009a783          	lw	a5,0(s3)
    80005ef4:	00579713          	slli	a4,a5,0x5
    80005ef8:	993a                	add	s2,s2,a4

  // initialize free list and allocate the alloc array for each size k
  for (int k = 0; k < nsizes; k++) {
    80005efa:	06f05e63          	blez	a5,80005f76 <bd_init+0x11a>
    80005efe:	4981                	li	s3,0
    lst_init(&bd_sizes[k].free);
    80005f00:	00003a97          	auipc	s5,0x3
    80005f04:	af8a8a93          	addi	s5,s5,-1288 # 800089f8 <bd_sizes>
    sz = sizeof(char) * ROUNDUP(NBLK(k) / 2, 8) / 8;
    80005f08:	00003a17          	auipc	s4,0x3
    80005f0c:	af8a0a13          	addi	s4,s4,-1288 # 80008a00 <nsizes>
    80005f10:	4b05                	li	s6,1
    lst_init(&bd_sizes[k].free);
    80005f12:	00599b93          	slli	s7,s3,0x5
    80005f16:	000ab503          	ld	a0,0(s5)
    80005f1a:	955e                	add	a0,a0,s7
    80005f1c:	00000097          	auipc	ra,0x0
    80005f20:	16c080e7          	jalr	364(ra) # 80006088 <lst_init>
    sz = sizeof(char) * ROUNDUP(NBLK(k) / 2, 8) / 8;
    80005f24:	000a2703          	lw	a4,0(s4)
    80005f28:	377d                	addiw	a4,a4,-1
    80005f2a:	4137073b          	subw	a4,a4,s3
    80005f2e:	00eb173b          	sllw	a4,s6,a4
    80005f32:	01f7579b          	srliw	a5,a4,0x1f
    80005f36:	9fb9                	addw	a5,a5,a4
    80005f38:	4017d79b          	sraiw	a5,a5,0x1
    80005f3c:	37fd                	addiw	a5,a5,-1
    80005f3e:	41f7d49b          	sraiw	s1,a5,0x1f
    80005f42:	01d4d49b          	srliw	s1,s1,0x1d
    80005f46:	9cbd                	addw	s1,s1,a5
    80005f48:	98e1                	andi	s1,s1,-8
    80005f4a:	24a1                	addiw	s1,s1,8
    bd_sizes[k].alloc = p;
    80005f4c:	000ab783          	ld	a5,0(s5)
    80005f50:	97de                	add	a5,a5,s7
    80005f52:	0127b823          	sd	s2,16(a5)
    memset(bd_sizes[k].alloc, 0, sz);
    80005f56:	848d                	srai	s1,s1,0x3
    80005f58:	8626                	mv	a2,s1
    80005f5a:	4581                	li	a1,0
    80005f5c:	854a                	mv	a0,s2
    80005f5e:	ffffa097          	auipc	ra,0xffffa
    80005f62:	118080e7          	jalr	280(ra) # 80000076 <memset>
    p += sz;
    80005f66:	9926                	add	s2,s2,s1
  for (int k = 0; k < nsizes; k++) {
    80005f68:	0985                	addi	s3,s3,1
    80005f6a:	000a2703          	lw	a4,0(s4)
    80005f6e:	0009879b          	sext.w	a5,s3
    80005f72:	fae7c0e3          	blt	a5,a4,80005f12 <bd_init+0xb6>
  }
  // allocate the split array for each size k, except for k = 0, since
  // we will not split blocks of size k = 0, the smallest size.
  for (int k = 1; k < nsizes; k++) {
    80005f76:	00003797          	auipc	a5,0x3
    80005f7a:	a8a7a783          	lw	a5,-1398(a5) # 80008a00 <nsizes>
    80005f7e:	4705                	li	a4,1
    80005f80:	06f75063          	bge	a4,a5,80005fe0 <bd_init+0x184>
    80005f84:	02000a13          	li	s4,32
    80005f88:	4985                	li	s3,1
    sz = sizeof(char) * (ROUNDUP(NBLK(k), 8)) / 8;
    80005f8a:	4b85                	li	s7,1
    bd_sizes[k].split = p;
    80005f8c:	00003b17          	auipc	s6,0x3
    80005f90:	a6cb0b13          	addi	s6,s6,-1428 # 800089f8 <bd_sizes>
  for (int k = 1; k < nsizes; k++) {
    80005f94:	00003a97          	auipc	s5,0x3
    80005f98:	a6ca8a93          	addi	s5,s5,-1428 # 80008a00 <nsizes>
    sz = sizeof(char) * (ROUNDUP(NBLK(k), 8)) / 8;
    80005f9c:	37fd                	addiw	a5,a5,-1
    80005f9e:	413787bb          	subw	a5,a5,s3
    80005fa2:	00fb97bb          	sllw	a5,s7,a5
    80005fa6:	37fd                	addiw	a5,a5,-1
    80005fa8:	41f7d49b          	sraiw	s1,a5,0x1f
    80005fac:	01d4d49b          	srliw	s1,s1,0x1d
    80005fb0:	9cbd                	addw	s1,s1,a5
    80005fb2:	98e1                	andi	s1,s1,-8
    80005fb4:	24a1                	addiw	s1,s1,8
    bd_sizes[k].split = p;
    80005fb6:	000b3783          	ld	a5,0(s6)
    80005fba:	97d2                	add	a5,a5,s4
    80005fbc:	0127bc23          	sd	s2,24(a5)
    memset(bd_sizes[k].split, 0, sz);
    80005fc0:	848d                	srai	s1,s1,0x3
    80005fc2:	8626                	mv	a2,s1
    80005fc4:	4581                	li	a1,0
    80005fc6:	854a                	mv	a0,s2
    80005fc8:	ffffa097          	auipc	ra,0xffffa
    80005fcc:	0ae080e7          	jalr	174(ra) # 80000076 <memset>
    p += sz;
    80005fd0:	9926                	add	s2,s2,s1
  for (int k = 1; k < nsizes; k++) {
    80005fd2:	2985                	addiw	s3,s3,1
    80005fd4:	000aa783          	lw	a5,0(s5)
    80005fd8:	020a0a13          	addi	s4,s4,32
    80005fdc:	fcf9c0e3          	blt	s3,a5,80005f9c <bd_init+0x140>
  }
  p = (char *)ROUNDUP((uint64)p, LEAF_SIZE);
    80005fe0:	197d                	addi	s2,s2,-1
    80005fe2:	ff097913          	andi	s2,s2,-16
    80005fe6:	0941                	addi	s2,s2,16

  // done allocating; mark the memory range [base, p) as allocated, so
  // that buddy will not hand out that memory.
  int meta = bd_mark_data_structures(p);
    80005fe8:	854a                	mv	a0,s2
    80005fea:	00000097          	auipc	ra,0x0
    80005fee:	d8e080e7          	jalr	-626(ra) # 80005d78 <bd_mark_data_structures>
    80005ff2:	8a2a                	mv	s4,a0

  // mark the unavailable memory range [end, HEAP_SIZE) as allocated,
  // so that buddy will not hand out that memory.
  int unavailable = bd_mark_unavailable(end, p);
    80005ff4:	85ca                	mv	a1,s2
    80005ff6:	8562                	mv	a0,s8
    80005ff8:	00000097          	auipc	ra,0x0
    80005ffc:	de0080e7          	jalr	-544(ra) # 80005dd8 <bd_mark_unavailable>
    80006000:	89aa                	mv	s3,a0
  void *bd_end = bd_base + BLK_SIZE(MAXSIZE) - unavailable;
    80006002:	00003a97          	auipc	s5,0x3
    80006006:	9fea8a93          	addi	s5,s5,-1538 # 80008a00 <nsizes>
    8000600a:	000aa783          	lw	a5,0(s5)
    8000600e:	37fd                	addiw	a5,a5,-1
    80006010:	44c1                	li	s1,16
    80006012:	00f497b3          	sll	a5,s1,a5
    80006016:	8f89                	sub	a5,a5,a0

  // initialize free lists for each size k
  int free = bd_initfree(p, bd_end);
    80006018:	00003597          	auipc	a1,0x3
    8000601c:	9d85b583          	ld	a1,-1576(a1) # 800089f0 <bd_base>
    80006020:	95be                	add	a1,a1,a5
    80006022:	854a                	mv	a0,s2
    80006024:	00000097          	auipc	ra,0x0
    80006028:	c94080e7          	jalr	-876(ra) # 80005cb8 <bd_initfree>

  // check if the amount that is free is what we expect
  if (free != BLK_SIZE(MAXSIZE) - meta - unavailable) {
    8000602c:	000aa783          	lw	a5,0(s5)
    80006030:	37fd                	addiw	a5,a5,-1
    80006032:	00f49633          	sll	a2,s1,a5
    80006036:	41460633          	sub	a2,a2,s4
    8000603a:	41360633          	sub	a2,a2,s3
    8000603e:	02c51463          	bne	a0,a2,80006066 <bd_init+0x20a>
    printf("free %d %d\n", free, BLK_SIZE(MAXSIZE) - meta - unavailable);
    panic("bd_init: free mem");
  }
    80006042:	60a6                	ld	ra,72(sp)
    80006044:	6406                	ld	s0,64(sp)
    80006046:	74e2                	ld	s1,56(sp)
    80006048:	7942                	ld	s2,48(sp)
    8000604a:	79a2                	ld	s3,40(sp)
    8000604c:	7a02                	ld	s4,32(sp)
    8000604e:	6ae2                	ld	s5,24(sp)
    80006050:	6b42                	ld	s6,16(sp)
    80006052:	6ba2                	ld	s7,8(sp)
    80006054:	6c02                	ld	s8,0(sp)
    80006056:	6161                	addi	sp,sp,80
    80006058:	8082                	ret
    nsizes++;  // round up to the next power of 2
    8000605a:	2509                	addiw	a0,a0,2
    8000605c:	00003797          	auipc	a5,0x3
    80006060:	9aa7a223          	sw	a0,-1628(a5) # 80008a00 <nsizes>
    80006064:	b59d                	j	80005eca <bd_init+0x6e>
    printf("free %d %d\n", free, BLK_SIZE(MAXSIZE) - meta - unavailable);
    80006066:	85aa                	mv	a1,a0
    80006068:	00003517          	auipc	a0,0x3
    8000606c:	83050513          	addi	a0,a0,-2000 # 80008898 <syscalls+0x4f8>
    80006070:	00000097          	auipc	ra,0x0
    80006074:	65e080e7          	jalr	1630(ra) # 800066ce <printf>
    panic("bd_init: free mem");
    80006078:	00003517          	auipc	a0,0x3
    8000607c:	83050513          	addi	a0,a0,-2000 # 800088a8 <syscalls+0x508>
    80006080:	00000097          	auipc	ra,0x0
    80006084:	604080e7          	jalr	1540(ra) # 80006684 <panic>

0000000080006088 <lst_init>:

// double-linked, circular list. double-linked makes remove
// fast. circular simplifies code, because don't have to check for
// empty list in insert and remove.

void lst_init(struct list *lst) {
    80006088:	1141                	addi	sp,sp,-16
    8000608a:	e422                	sd	s0,8(sp)
    8000608c:	0800                	addi	s0,sp,16
  lst->next = lst;
    8000608e:	e108                	sd	a0,0(a0)
  lst->prev = lst;
    80006090:	e508                	sd	a0,8(a0)
}
    80006092:	6422                	ld	s0,8(sp)
    80006094:	0141                	addi	sp,sp,16
    80006096:	8082                	ret

0000000080006098 <lst_empty>:

int lst_empty(struct list *lst) { return lst->next == lst; }
    80006098:	1141                	addi	sp,sp,-16
    8000609a:	e422                	sd	s0,8(sp)
    8000609c:	0800                	addi	s0,sp,16
    8000609e:	611c                	ld	a5,0(a0)
    800060a0:	40a78533          	sub	a0,a5,a0
    800060a4:	00153513          	seqz	a0,a0
    800060a8:	6422                	ld	s0,8(sp)
    800060aa:	0141                	addi	sp,sp,16
    800060ac:	8082                	ret

00000000800060ae <lst_remove>:

void lst_remove(struct list *e) {
    800060ae:	1141                	addi	sp,sp,-16
    800060b0:	e422                	sd	s0,8(sp)
    800060b2:	0800                	addi	s0,sp,16
  e->prev->next = e->next;
    800060b4:	6518                	ld	a4,8(a0)
    800060b6:	611c                	ld	a5,0(a0)
    800060b8:	e31c                	sd	a5,0(a4)
  e->next->prev = e->prev;
    800060ba:	6518                	ld	a4,8(a0)
    800060bc:	e798                	sd	a4,8(a5)
}
    800060be:	6422                	ld	s0,8(sp)
    800060c0:	0141                	addi	sp,sp,16
    800060c2:	8082                	ret

00000000800060c4 <lst_pop>:

void *lst_pop(struct list *lst) {
    800060c4:	1101                	addi	sp,sp,-32
    800060c6:	ec06                	sd	ra,24(sp)
    800060c8:	e822                	sd	s0,16(sp)
    800060ca:	e426                	sd	s1,8(sp)
    800060cc:	1000                	addi	s0,sp,32
  if (lst->next == lst) panic("lst_pop");
    800060ce:	6104                	ld	s1,0(a0)
    800060d0:	00a48d63          	beq	s1,a0,800060ea <lst_pop+0x26>
  struct list *p = lst->next;
  lst_remove(p);
    800060d4:	8526                	mv	a0,s1
    800060d6:	00000097          	auipc	ra,0x0
    800060da:	fd8080e7          	jalr	-40(ra) # 800060ae <lst_remove>
  return (void *)p;
}
    800060de:	8526                	mv	a0,s1
    800060e0:	60e2                	ld	ra,24(sp)
    800060e2:	6442                	ld	s0,16(sp)
    800060e4:	64a2                	ld	s1,8(sp)
    800060e6:	6105                	addi	sp,sp,32
    800060e8:	8082                	ret
  if (lst->next == lst) panic("lst_pop");
    800060ea:	00002517          	auipc	a0,0x2
    800060ee:	7d650513          	addi	a0,a0,2006 # 800088c0 <syscalls+0x520>
    800060f2:	00000097          	auipc	ra,0x0
    800060f6:	592080e7          	jalr	1426(ra) # 80006684 <panic>

00000000800060fa <lst_push>:

void lst_push(struct list *lst, void *p) {
    800060fa:	1141                	addi	sp,sp,-16
    800060fc:	e422                	sd	s0,8(sp)
    800060fe:	0800                	addi	s0,sp,16
  struct list *e = (struct list *)p;
  e->next = lst->next;
    80006100:	611c                	ld	a5,0(a0)
    80006102:	e19c                	sd	a5,0(a1)
  e->prev = lst;
    80006104:	e588                	sd	a0,8(a1)
  lst->next->prev = p;
    80006106:	611c                	ld	a5,0(a0)
    80006108:	e78c                	sd	a1,8(a5)
  lst->next = e;
    8000610a:	e10c                	sd	a1,0(a0)
}
    8000610c:	6422                	ld	s0,8(sp)
    8000610e:	0141                	addi	sp,sp,16
    80006110:	8082                	ret

0000000080006112 <lst_print>:

void lst_print(struct list *lst) {
    80006112:	7179                	addi	sp,sp,-48
    80006114:	f406                	sd	ra,40(sp)
    80006116:	f022                	sd	s0,32(sp)
    80006118:	ec26                	sd	s1,24(sp)
    8000611a:	e84a                	sd	s2,16(sp)
    8000611c:	e44e                	sd	s3,8(sp)
    8000611e:	1800                	addi	s0,sp,48
  for (struct list *p = lst->next; p != lst; p = p->next) {
    80006120:	6104                	ld	s1,0(a0)
    80006122:	02950063          	beq	a0,s1,80006142 <lst_print+0x30>
    80006126:	892a                	mv	s2,a0
    printf(" %p", p);
    80006128:	00002997          	auipc	s3,0x2
    8000612c:	7a098993          	addi	s3,s3,1952 # 800088c8 <syscalls+0x528>
    80006130:	85a6                	mv	a1,s1
    80006132:	854e                	mv	a0,s3
    80006134:	00000097          	auipc	ra,0x0
    80006138:	59a080e7          	jalr	1434(ra) # 800066ce <printf>
  for (struct list *p = lst->next; p != lst; p = p->next) {
    8000613c:	6084                	ld	s1,0(s1)
    8000613e:	fe9919e3          	bne	s2,s1,80006130 <lst_print+0x1e>
  }
  printf("\n");
    80006142:	00002517          	auipc	a0,0x2
    80006146:	ee650513          	addi	a0,a0,-282 # 80008028 <etext+0x28>
    8000614a:	00000097          	auipc	ra,0x0
    8000614e:	584080e7          	jalr	1412(ra) # 800066ce <printf>
    80006152:	70a2                	ld	ra,40(sp)
    80006154:	7402                	ld	s0,32(sp)
    80006156:	64e2                	ld	s1,24(sp)
    80006158:	6942                	ld	s2,16(sp)
    8000615a:	69a2                	ld	s3,8(sp)
    8000615c:	6145                	addi	sp,sp,48
    8000615e:	8082                	ret

0000000080006160 <timerinit>:
// arrange to receive timer interrupts.
// they will arrive in machine mode at
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void timerinit() {
    80006160:	1141                	addi	sp,sp,-16
    80006162:	e422                	sd	s0,8(sp)
    80006164:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r"(x));
    80006166:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    8000616a:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000;  // cycles; about 1/10th second in qemu.
  *(uint64 *)CLINT_MTIMECMP(id) = *(uint64 *)CLINT_MTIME + interval;
    8000616e:	0037979b          	slliw	a5,a5,0x3
    80006172:	02004737          	lui	a4,0x2004
    80006176:	97ba                	add	a5,a5,a4
    80006178:	0200c737          	lui	a4,0x200c
    8000617c:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80006180:	000f4637          	lui	a2,0xf4
    80006184:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80006188:	9732                	add	a4,a4,a2
    8000618a:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000618c:	00259693          	slli	a3,a1,0x2
    80006190:	96ae                	add	a3,a3,a1
    80006192:	068e                	slli	a3,a3,0x3
    80006194:	0000d717          	auipc	a4,0xd
    80006198:	12c70713          	addi	a4,a4,300 # 800132c0 <timer_scratch>
    8000619c:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000619e:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800061a0:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r"(x));
    800061a2:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r"(x));
    800061a6:	fffff797          	auipc	a5,0xfffff
    800061aa:	cba78793          	addi	a5,a5,-838 # 80004e60 <timervec>
    800061ae:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r"(x));
    800061b2:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800061b6:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r"(x));
    800061ba:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r"(x));
    800061be:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800061c2:	0807e793          	ori	a5,a5,128
static inline void w_mie(uint64 x) { asm volatile("csrw mie, %0" : : "r"(x)); }
    800061c6:	30479073          	csrw	mie,a5
}
    800061ca:	6422                	ld	s0,8(sp)
    800061cc:	0141                	addi	sp,sp,16
    800061ce:	8082                	ret

00000000800061d0 <start>:
void start() {
    800061d0:	1141                	addi	sp,sp,-16
    800061d2:	e406                	sd	ra,8(sp)
    800061d4:	e022                	sd	s0,0(sp)
    800061d6:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    800061d8:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800061dc:	7779                	lui	a4,0xffffe
    800061de:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffe32ff>
    800061e2:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800061e4:	6705                	lui	a4,0x1
    800061e6:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800061ea:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    800061ec:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    800061f0:	ffffa797          	auipc	a5,0xffffa
    800061f4:	02c78793          	addi	a5,a5,44 # 8000021c <main>
    800061f8:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    800061fc:	4781                	li	a5,0
    800061fe:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    80006202:	67c1                	lui	a5,0x10
    80006204:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80006206:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    8000620a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    8000620e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80006212:	2227e793          	ori	a5,a5,546
static inline void w_sie(uint64 x) { asm volatile("csrw sie, %0" : : "r"(x)); }
    80006216:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    8000621a:	57fd                	li	a5,-1
    8000621c:	83a9                	srli	a5,a5,0xa
    8000621e:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    80006222:	47bd                	li	a5,15
    80006224:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80006228:	00000097          	auipc	ra,0x0
    8000622c:	f38080e7          	jalr	-200(ra) # 80006160 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    80006230:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80006234:	2781                	sext.w	a5,a5
static inline void w_tp(uint64 x) { asm volatile("mv tp, %0" : : "r"(x)); }
    80006236:	823e                	mv	tp,a5
  asm volatile("mret");
    80006238:	30200073          	mret
}
    8000623c:	60a2                	ld	ra,8(sp)
    8000623e:	6402                	ld	s0,0(sp)
    80006240:	0141                	addi	sp,sp,16
    80006242:	8082                	ret

0000000080006244 <consolewrite>:
} cons;

//
// user write()s to the console go here.
//
int consolewrite(int user_src, uint64 src, int n) {
    80006244:	715d                	addi	sp,sp,-80
    80006246:	e486                	sd	ra,72(sp)
    80006248:	e0a2                	sd	s0,64(sp)
    8000624a:	fc26                	sd	s1,56(sp)
    8000624c:	f84a                	sd	s2,48(sp)
    8000624e:	f44e                	sd	s3,40(sp)
    80006250:	f052                	sd	s4,32(sp)
    80006252:	ec56                	sd	s5,24(sp)
    80006254:	0880                	addi	s0,sp,80
  int i;

  for (i = 0; i < n; i++) {
    80006256:	04c05763          	blez	a2,800062a4 <consolewrite+0x60>
    8000625a:	8a2a                	mv	s4,a0
    8000625c:	84ae                	mv	s1,a1
    8000625e:	89b2                	mv	s3,a2
    80006260:	4901                	li	s2,0
    char c;
    if (either_copyin(&c, user_src, src + i, 1) == -1) break;
    80006262:	5afd                	li	s5,-1
    80006264:	4685                	li	a3,1
    80006266:	8626                	mv	a2,s1
    80006268:	85d2                	mv	a1,s4
    8000626a:	fbf40513          	addi	a0,s0,-65
    8000626e:	ffffb097          	auipc	ra,0xffffb
    80006272:	57c080e7          	jalr	1404(ra) # 800017ea <either_copyin>
    80006276:	01550d63          	beq	a0,s5,80006290 <consolewrite+0x4c>
    uartputc(c);
    8000627a:	fbf44503          	lbu	a0,-65(s0)
    8000627e:	00000097          	auipc	ra,0x0
    80006282:	784080e7          	jalr	1924(ra) # 80006a02 <uartputc>
  for (i = 0; i < n; i++) {
    80006286:	2905                	addiw	s2,s2,1
    80006288:	0485                	addi	s1,s1,1
    8000628a:	fd299de3          	bne	s3,s2,80006264 <consolewrite+0x20>
    8000628e:	894e                	mv	s2,s3
  }

  return i;
}
    80006290:	854a                	mv	a0,s2
    80006292:	60a6                	ld	ra,72(sp)
    80006294:	6406                	ld	s0,64(sp)
    80006296:	74e2                	ld	s1,56(sp)
    80006298:	7942                	ld	s2,48(sp)
    8000629a:	79a2                	ld	s3,40(sp)
    8000629c:	7a02                	ld	s4,32(sp)
    8000629e:	6ae2                	ld	s5,24(sp)
    800062a0:	6161                	addi	sp,sp,80
    800062a2:	8082                	ret
  for (i = 0; i < n; i++) {
    800062a4:	4901                	li	s2,0
    800062a6:	b7ed                	j	80006290 <consolewrite+0x4c>

00000000800062a8 <consoleread>:
// user read()s from the console go here.
// copy (up to) a whole input line to dst.
// user_dist indicates whether dst is a user
// or kernel address.
//
int consoleread(int user_dst, uint64 dst, int n) {
    800062a8:	7159                	addi	sp,sp,-112
    800062aa:	f486                	sd	ra,104(sp)
    800062ac:	f0a2                	sd	s0,96(sp)
    800062ae:	eca6                	sd	s1,88(sp)
    800062b0:	e8ca                	sd	s2,80(sp)
    800062b2:	e4ce                	sd	s3,72(sp)
    800062b4:	e0d2                	sd	s4,64(sp)
    800062b6:	fc56                	sd	s5,56(sp)
    800062b8:	f85a                	sd	s6,48(sp)
    800062ba:	f45e                	sd	s7,40(sp)
    800062bc:	f062                	sd	s8,32(sp)
    800062be:	ec66                	sd	s9,24(sp)
    800062c0:	e86a                	sd	s10,16(sp)
    800062c2:	1880                	addi	s0,sp,112
    800062c4:	8aaa                	mv	s5,a0
    800062c6:	8a2e                	mv	s4,a1
    800062c8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800062ca:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800062ce:	00015517          	auipc	a0,0x15
    800062d2:	13250513          	addi	a0,a0,306 # 8001b400 <cons>
    800062d6:	00001097          	auipc	ra,0x1
    800062da:	8e6080e7          	jalr	-1818(ra) # 80006bbc <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    800062de:	00015497          	auipc	s1,0x15
    800062e2:	12248493          	addi	s1,s1,290 # 8001b400 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800062e6:	00015917          	auipc	s2,0x15
    800062ea:	1b290913          	addi	s2,s2,434 # 8001b498 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if (c == C('D')) {  // end-of-file
    800062ee:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1) break;
    800062f0:	5c7d                	li	s8,-1

    dst++;
    --n;

    if (c == '\n') {
    800062f2:	4ca9                	li	s9,10
  while (n > 0) {
    800062f4:	07305b63          	blez	s3,8000636a <consoleread+0xc2>
    while (cons.r == cons.w) {
    800062f8:	0984a783          	lw	a5,152(s1)
    800062fc:	09c4a703          	lw	a4,156(s1)
    80006300:	02f71763          	bne	a4,a5,8000632e <consoleread+0x86>
      if (killed(myproc())) {
    80006304:	ffffb097          	auipc	ra,0xffffb
    80006308:	966080e7          	jalr	-1690(ra) # 80000c6a <myproc>
    8000630c:	ffffb097          	auipc	ra,0xffffb
    80006310:	318080e7          	jalr	792(ra) # 80001624 <killed>
    80006314:	e535                	bnez	a0,80006380 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    80006316:	85a6                	mv	a1,s1
    80006318:	854a                	mv	a0,s2
    8000631a:	ffffb097          	auipc	ra,0xffffb
    8000631e:	030080e7          	jalr	48(ra) # 8000134a <sleep>
    while (cons.r == cons.w) {
    80006322:	0984a783          	lw	a5,152(s1)
    80006326:	09c4a703          	lw	a4,156(s1)
    8000632a:	fcf70de3          	beq	a4,a5,80006304 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000632e:	0017871b          	addiw	a4,a5,1
    80006332:	08e4ac23          	sw	a4,152(s1)
    80006336:	07f7f713          	andi	a4,a5,127
    8000633a:	9726                	add	a4,a4,s1
    8000633c:	01874703          	lbu	a4,24(a4)
    80006340:	00070d1b          	sext.w	s10,a4
    if (c == C('D')) {  // end-of-file
    80006344:	077d0563          	beq	s10,s7,800063ae <consoleread+0x106>
    cbuf = c;
    80006348:	f8e40fa3          	sb	a4,-97(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1) break;
    8000634c:	4685                	li	a3,1
    8000634e:	f9f40613          	addi	a2,s0,-97
    80006352:	85d2                	mv	a1,s4
    80006354:	8556                	mv	a0,s5
    80006356:	ffffb097          	auipc	ra,0xffffb
    8000635a:	43e080e7          	jalr	1086(ra) # 80001794 <either_copyout>
    8000635e:	01850663          	beq	a0,s8,8000636a <consoleread+0xc2>
    dst++;
    80006362:	0a05                	addi	s4,s4,1
    --n;
    80006364:	39fd                	addiw	s3,s3,-1
    if (c == '\n') {
    80006366:	f99d17e3          	bne	s10,s9,800062f4 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000636a:	00015517          	auipc	a0,0x15
    8000636e:	09650513          	addi	a0,a0,150 # 8001b400 <cons>
    80006372:	00001097          	auipc	ra,0x1
    80006376:	8f8080e7          	jalr	-1800(ra) # 80006c6a <release>

  return target - n;
    8000637a:	413b053b          	subw	a0,s6,s3
    8000637e:	a811                	j	80006392 <consoleread+0xea>
        release(&cons.lock);
    80006380:	00015517          	auipc	a0,0x15
    80006384:	08050513          	addi	a0,a0,128 # 8001b400 <cons>
    80006388:	00001097          	auipc	ra,0x1
    8000638c:	8e2080e7          	jalr	-1822(ra) # 80006c6a <release>
        return -1;
    80006390:	557d                	li	a0,-1
}
    80006392:	70a6                	ld	ra,104(sp)
    80006394:	7406                	ld	s0,96(sp)
    80006396:	64e6                	ld	s1,88(sp)
    80006398:	6946                	ld	s2,80(sp)
    8000639a:	69a6                	ld	s3,72(sp)
    8000639c:	6a06                	ld	s4,64(sp)
    8000639e:	7ae2                	ld	s5,56(sp)
    800063a0:	7b42                	ld	s6,48(sp)
    800063a2:	7ba2                	ld	s7,40(sp)
    800063a4:	7c02                	ld	s8,32(sp)
    800063a6:	6ce2                	ld	s9,24(sp)
    800063a8:	6d42                	ld	s10,16(sp)
    800063aa:	6165                	addi	sp,sp,112
    800063ac:	8082                	ret
      if (n < target) {
    800063ae:	0009871b          	sext.w	a4,s3
    800063b2:	fb677ce3          	bgeu	a4,s6,8000636a <consoleread+0xc2>
        cons.r--;
    800063b6:	00015717          	auipc	a4,0x15
    800063ba:	0ef72123          	sw	a5,226(a4) # 8001b498 <cons+0x98>
    800063be:	b775                	j	8000636a <consoleread+0xc2>

00000000800063c0 <consputc>:
void consputc(int c) {
    800063c0:	1141                	addi	sp,sp,-16
    800063c2:	e406                	sd	ra,8(sp)
    800063c4:	e022                	sd	s0,0(sp)
    800063c6:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    800063c8:	10000793          	li	a5,256
    800063cc:	00f50a63          	beq	a0,a5,800063e0 <consputc+0x20>
    uartputc_sync(c);
    800063d0:	00000097          	auipc	ra,0x0
    800063d4:	560080e7          	jalr	1376(ra) # 80006930 <uartputc_sync>
}
    800063d8:	60a2                	ld	ra,8(sp)
    800063da:	6402                	ld	s0,0(sp)
    800063dc:	0141                	addi	sp,sp,16
    800063de:	8082                	ret
    uartputc_sync('\b');
    800063e0:	4521                	li	a0,8
    800063e2:	00000097          	auipc	ra,0x0
    800063e6:	54e080e7          	jalr	1358(ra) # 80006930 <uartputc_sync>
    uartputc_sync(' ');
    800063ea:	02000513          	li	a0,32
    800063ee:	00000097          	auipc	ra,0x0
    800063f2:	542080e7          	jalr	1346(ra) # 80006930 <uartputc_sync>
    uartputc_sync('\b');
    800063f6:	4521                	li	a0,8
    800063f8:	00000097          	auipc	ra,0x0
    800063fc:	538080e7          	jalr	1336(ra) # 80006930 <uartputc_sync>
    80006400:	bfe1                	j	800063d8 <consputc+0x18>

0000000080006402 <consoleintr>:
// the console input interrupt handler.
// uartintr() calls this for input character.
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void consoleintr(int c) {
    80006402:	1101                	addi	sp,sp,-32
    80006404:	ec06                	sd	ra,24(sp)
    80006406:	e822                	sd	s0,16(sp)
    80006408:	e426                	sd	s1,8(sp)
    8000640a:	e04a                	sd	s2,0(sp)
    8000640c:	1000                	addi	s0,sp,32
    8000640e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80006410:	00015517          	auipc	a0,0x15
    80006414:	ff050513          	addi	a0,a0,-16 # 8001b400 <cons>
    80006418:	00000097          	auipc	ra,0x0
    8000641c:	7a4080e7          	jalr	1956(ra) # 80006bbc <acquire>

  switch (c) {
    80006420:	47d5                	li	a5,21
    80006422:	0af48663          	beq	s1,a5,800064ce <consoleintr+0xcc>
    80006426:	0297ca63          	blt	a5,s1,8000645a <consoleintr+0x58>
    8000642a:	47a1                	li	a5,8
    8000642c:	0ef48763          	beq	s1,a5,8000651a <consoleintr+0x118>
    80006430:	47c1                	li	a5,16
    80006432:	10f49a63          	bne	s1,a5,80006546 <consoleintr+0x144>
    case C('P'):  // Print process list.
      procdump();
    80006436:	ffffb097          	auipc	ra,0xffffb
    8000643a:	40a080e7          	jalr	1034(ra) # 80001840 <procdump>
        }
      }
      break;
  }

  release(&cons.lock);
    8000643e:	00015517          	auipc	a0,0x15
    80006442:	fc250513          	addi	a0,a0,-62 # 8001b400 <cons>
    80006446:	00001097          	auipc	ra,0x1
    8000644a:	824080e7          	jalr	-2012(ra) # 80006c6a <release>
}
    8000644e:	60e2                	ld	ra,24(sp)
    80006450:	6442                	ld	s0,16(sp)
    80006452:	64a2                	ld	s1,8(sp)
    80006454:	6902                	ld	s2,0(sp)
    80006456:	6105                	addi	sp,sp,32
    80006458:	8082                	ret
  switch (c) {
    8000645a:	07f00793          	li	a5,127
    8000645e:	0af48e63          	beq	s1,a5,8000651a <consoleintr+0x118>
      if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    80006462:	00015717          	auipc	a4,0x15
    80006466:	f9e70713          	addi	a4,a4,-98 # 8001b400 <cons>
    8000646a:	0a072783          	lw	a5,160(a4)
    8000646e:	09872703          	lw	a4,152(a4)
    80006472:	9f99                	subw	a5,a5,a4
    80006474:	07f00713          	li	a4,127
    80006478:	fcf763e3          	bltu	a4,a5,8000643e <consoleintr+0x3c>
        c = (c == '\r') ? '\n' : c;
    8000647c:	47b5                	li	a5,13
    8000647e:	0cf48763          	beq	s1,a5,8000654c <consoleintr+0x14a>
        consputc(c);
    80006482:	8526                	mv	a0,s1
    80006484:	00000097          	auipc	ra,0x0
    80006488:	f3c080e7          	jalr	-196(ra) # 800063c0 <consputc>
        cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000648c:	00015797          	auipc	a5,0x15
    80006490:	f7478793          	addi	a5,a5,-140 # 8001b400 <cons>
    80006494:	0a07a683          	lw	a3,160(a5)
    80006498:	0016871b          	addiw	a4,a3,1
    8000649c:	0007061b          	sext.w	a2,a4
    800064a0:	0ae7a023          	sw	a4,160(a5)
    800064a4:	07f6f693          	andi	a3,a3,127
    800064a8:	97b6                	add	a5,a5,a3
    800064aa:	00978c23          	sb	s1,24(a5)
        if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    800064ae:	47a9                	li	a5,10
    800064b0:	0cf48563          	beq	s1,a5,8000657a <consoleintr+0x178>
    800064b4:	4791                	li	a5,4
    800064b6:	0cf48263          	beq	s1,a5,8000657a <consoleintr+0x178>
    800064ba:	00015797          	auipc	a5,0x15
    800064be:	fde7a783          	lw	a5,-34(a5) # 8001b498 <cons+0x98>
    800064c2:	9f1d                	subw	a4,a4,a5
    800064c4:	08000793          	li	a5,128
    800064c8:	f6f71be3          	bne	a4,a5,8000643e <consoleintr+0x3c>
    800064cc:	a07d                	j	8000657a <consoleintr+0x178>
      while (cons.e != cons.w &&
    800064ce:	00015717          	auipc	a4,0x15
    800064d2:	f3270713          	addi	a4,a4,-206 # 8001b400 <cons>
    800064d6:	0a072783          	lw	a5,160(a4)
    800064da:	09c72703          	lw	a4,156(a4)
             cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    800064de:	00015497          	auipc	s1,0x15
    800064e2:	f2248493          	addi	s1,s1,-222 # 8001b400 <cons>
      while (cons.e != cons.w &&
    800064e6:	4929                	li	s2,10
    800064e8:	f4f70be3          	beq	a4,a5,8000643e <consoleintr+0x3c>
             cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    800064ec:	37fd                	addiw	a5,a5,-1
    800064ee:	07f7f713          	andi	a4,a5,127
    800064f2:	9726                	add	a4,a4,s1
      while (cons.e != cons.w &&
    800064f4:	01874703          	lbu	a4,24(a4)
    800064f8:	f52703e3          	beq	a4,s2,8000643e <consoleintr+0x3c>
        cons.e--;
    800064fc:	0af4a023          	sw	a5,160(s1)
        consputc(BACKSPACE);
    80006500:	10000513          	li	a0,256
    80006504:	00000097          	auipc	ra,0x0
    80006508:	ebc080e7          	jalr	-324(ra) # 800063c0 <consputc>
      while (cons.e != cons.w &&
    8000650c:	0a04a783          	lw	a5,160(s1)
    80006510:	09c4a703          	lw	a4,156(s1)
    80006514:	fcf71ce3          	bne	a4,a5,800064ec <consoleintr+0xea>
    80006518:	b71d                	j	8000643e <consoleintr+0x3c>
      if (cons.e != cons.w) {
    8000651a:	00015717          	auipc	a4,0x15
    8000651e:	ee670713          	addi	a4,a4,-282 # 8001b400 <cons>
    80006522:	0a072783          	lw	a5,160(a4)
    80006526:	09c72703          	lw	a4,156(a4)
    8000652a:	f0f70ae3          	beq	a4,a5,8000643e <consoleintr+0x3c>
        cons.e--;
    8000652e:	37fd                	addiw	a5,a5,-1
    80006530:	00015717          	auipc	a4,0x15
    80006534:	f6f72823          	sw	a5,-144(a4) # 8001b4a0 <cons+0xa0>
        consputc(BACKSPACE);
    80006538:	10000513          	li	a0,256
    8000653c:	00000097          	auipc	ra,0x0
    80006540:	e84080e7          	jalr	-380(ra) # 800063c0 <consputc>
    80006544:	bded                	j	8000643e <consoleintr+0x3c>
      if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    80006546:	ee048ce3          	beqz	s1,8000643e <consoleintr+0x3c>
    8000654a:	bf21                	j	80006462 <consoleintr+0x60>
        consputc(c);
    8000654c:	4529                	li	a0,10
    8000654e:	00000097          	auipc	ra,0x0
    80006552:	e72080e7          	jalr	-398(ra) # 800063c0 <consputc>
        cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80006556:	00015797          	auipc	a5,0x15
    8000655a:	eaa78793          	addi	a5,a5,-342 # 8001b400 <cons>
    8000655e:	0a07a703          	lw	a4,160(a5)
    80006562:	0017069b          	addiw	a3,a4,1
    80006566:	0006861b          	sext.w	a2,a3
    8000656a:	0ad7a023          	sw	a3,160(a5)
    8000656e:	07f77713          	andi	a4,a4,127
    80006572:	97ba                	add	a5,a5,a4
    80006574:	4729                	li	a4,10
    80006576:	00e78c23          	sb	a4,24(a5)
          cons.w = cons.e;
    8000657a:	00015797          	auipc	a5,0x15
    8000657e:	f2c7a123          	sw	a2,-222(a5) # 8001b49c <cons+0x9c>
          wakeup(&cons.r);
    80006582:	00015517          	auipc	a0,0x15
    80006586:	f1650513          	addi	a0,a0,-234 # 8001b498 <cons+0x98>
    8000658a:	ffffb097          	auipc	ra,0xffffb
    8000658e:	e24080e7          	jalr	-476(ra) # 800013ae <wakeup>
    80006592:	b575                	j	8000643e <consoleintr+0x3c>

0000000080006594 <consoleinit>:

void consoleinit(void) {
    80006594:	1141                	addi	sp,sp,-16
    80006596:	e406                	sd	ra,8(sp)
    80006598:	e022                	sd	s0,0(sp)
    8000659a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000659c:	00002597          	auipc	a1,0x2
    800065a0:	33458593          	addi	a1,a1,820 # 800088d0 <syscalls+0x530>
    800065a4:	00015517          	auipc	a0,0x15
    800065a8:	e5c50513          	addi	a0,a0,-420 # 8001b400 <cons>
    800065ac:	00000097          	auipc	ra,0x0
    800065b0:	580080e7          	jalr	1408(ra) # 80006b2c <initlock>

  uartinit();
    800065b4:	00000097          	auipc	ra,0x0
    800065b8:	32c080e7          	jalr	812(ra) # 800068e0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800065bc:	0000d797          	auipc	a5,0xd
    800065c0:	b0478793          	addi	a5,a5,-1276 # 800130c0 <devsw>
    800065c4:	00000717          	auipc	a4,0x0
    800065c8:	ce470713          	addi	a4,a4,-796 # 800062a8 <consoleread>
    800065cc:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800065ce:	00000717          	auipc	a4,0x0
    800065d2:	c7670713          	addi	a4,a4,-906 # 80006244 <consolewrite>
    800065d6:	ef98                	sd	a4,24(a5)
}
    800065d8:	60a2                	ld	ra,8(sp)
    800065da:	6402                	ld	s0,0(sp)
    800065dc:	0141                	addi	sp,sp,16
    800065de:	8082                	ret

00000000800065e0 <printint>:
  int locking;
} pr;

static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign) {
    800065e0:	7179                	addi	sp,sp,-48
    800065e2:	f406                	sd	ra,40(sp)
    800065e4:	f022                	sd	s0,32(sp)
    800065e6:	ec26                	sd	s1,24(sp)
    800065e8:	e84a                	sd	s2,16(sp)
    800065ea:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if (sign && (sign = xx < 0))
    800065ec:	c219                	beqz	a2,800065f2 <printint+0x12>
    800065ee:	08054763          	bltz	a0,8000667c <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800065f2:	2501                	sext.w	a0,a0
    800065f4:	4881                	li	a7,0
    800065f6:	fd040693          	addi	a3,s0,-48

  i = 0;
    800065fa:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800065fc:	2581                	sext.w	a1,a1
    800065fe:	00002617          	auipc	a2,0x2
    80006602:	30260613          	addi	a2,a2,770 # 80008900 <digits>
    80006606:	883a                	mv	a6,a4
    80006608:	2705                	addiw	a4,a4,1
    8000660a:	02b577bb          	remuw	a5,a0,a1
    8000660e:	1782                	slli	a5,a5,0x20
    80006610:	9381                	srli	a5,a5,0x20
    80006612:	97b2                	add	a5,a5,a2
    80006614:	0007c783          	lbu	a5,0(a5)
    80006618:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    8000661c:	0005079b          	sext.w	a5,a0
    80006620:	02b5553b          	divuw	a0,a0,a1
    80006624:	0685                	addi	a3,a3,1
    80006626:	feb7f0e3          	bgeu	a5,a1,80006606 <printint+0x26>

  if (sign) buf[i++] = '-';
    8000662a:	00088c63          	beqz	a7,80006642 <printint+0x62>
    8000662e:	fe070793          	addi	a5,a4,-32
    80006632:	00878733          	add	a4,a5,s0
    80006636:	02d00793          	li	a5,45
    8000663a:	fef70823          	sb	a5,-16(a4)
    8000663e:	0028071b          	addiw	a4,a6,2

  while (--i >= 0) consputc(buf[i]);
    80006642:	02e05763          	blez	a4,80006670 <printint+0x90>
    80006646:	fd040793          	addi	a5,s0,-48
    8000664a:	00e784b3          	add	s1,a5,a4
    8000664e:	fff78913          	addi	s2,a5,-1
    80006652:	993a                	add	s2,s2,a4
    80006654:	377d                	addiw	a4,a4,-1
    80006656:	1702                	slli	a4,a4,0x20
    80006658:	9301                	srli	a4,a4,0x20
    8000665a:	40e90933          	sub	s2,s2,a4
    8000665e:	fff4c503          	lbu	a0,-1(s1)
    80006662:	00000097          	auipc	ra,0x0
    80006666:	d5e080e7          	jalr	-674(ra) # 800063c0 <consputc>
    8000666a:	14fd                	addi	s1,s1,-1
    8000666c:	ff2499e3          	bne	s1,s2,8000665e <printint+0x7e>
}
    80006670:	70a2                	ld	ra,40(sp)
    80006672:	7402                	ld	s0,32(sp)
    80006674:	64e2                	ld	s1,24(sp)
    80006676:	6942                	ld	s2,16(sp)
    80006678:	6145                	addi	sp,sp,48
    8000667a:	8082                	ret
    x = -xx;
    8000667c:	40a0053b          	negw	a0,a0
  if (sign && (sign = xx < 0))
    80006680:	4885                	li	a7,1
    x = -xx;
    80006682:	bf95                	j	800065f6 <printint+0x16>

0000000080006684 <panic>:
  va_end(ap);

  if (locking) release(&pr.lock);
}

void panic(char *s) {
    80006684:	1101                	addi	sp,sp,-32
    80006686:	ec06                	sd	ra,24(sp)
    80006688:	e822                	sd	s0,16(sp)
    8000668a:	e426                	sd	s1,8(sp)
    8000668c:	1000                	addi	s0,sp,32
    8000668e:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006690:	00015797          	auipc	a5,0x15
    80006694:	e207a823          	sw	zero,-464(a5) # 8001b4c0 <pr+0x18>
  printf("panic: ");
    80006698:	00002517          	auipc	a0,0x2
    8000669c:	24050513          	addi	a0,a0,576 # 800088d8 <syscalls+0x538>
    800066a0:	00000097          	auipc	ra,0x0
    800066a4:	02e080e7          	jalr	46(ra) # 800066ce <printf>
  printf(s);
    800066a8:	8526                	mv	a0,s1
    800066aa:	00000097          	auipc	ra,0x0
    800066ae:	024080e7          	jalr	36(ra) # 800066ce <printf>
  printf("\n");
    800066b2:	00002517          	auipc	a0,0x2
    800066b6:	97650513          	addi	a0,a0,-1674 # 80008028 <etext+0x28>
    800066ba:	00000097          	auipc	ra,0x0
    800066be:	014080e7          	jalr	20(ra) # 800066ce <printf>
  panicked = 1;  // freeze uart output from other CPUs
    800066c2:	4785                	li	a5,1
    800066c4:	00002717          	auipc	a4,0x2
    800066c8:	34f72023          	sw	a5,832(a4) # 80008a04 <panicked>
  for (;;)
    800066cc:	a001                	j	800066cc <panic+0x48>

00000000800066ce <printf>:
void printf(char *fmt, ...) {
    800066ce:	7131                	addi	sp,sp,-192
    800066d0:	fc86                	sd	ra,120(sp)
    800066d2:	f8a2                	sd	s0,112(sp)
    800066d4:	f4a6                	sd	s1,104(sp)
    800066d6:	f0ca                	sd	s2,96(sp)
    800066d8:	ecce                	sd	s3,88(sp)
    800066da:	e8d2                	sd	s4,80(sp)
    800066dc:	e4d6                	sd	s5,72(sp)
    800066de:	e0da                	sd	s6,64(sp)
    800066e0:	fc5e                	sd	s7,56(sp)
    800066e2:	f862                	sd	s8,48(sp)
    800066e4:	f466                	sd	s9,40(sp)
    800066e6:	f06a                	sd	s10,32(sp)
    800066e8:	ec6e                	sd	s11,24(sp)
    800066ea:	0100                	addi	s0,sp,128
    800066ec:	8a2a                	mv	s4,a0
    800066ee:	e40c                	sd	a1,8(s0)
    800066f0:	e810                	sd	a2,16(s0)
    800066f2:	ec14                	sd	a3,24(s0)
    800066f4:	f018                	sd	a4,32(s0)
    800066f6:	f41c                	sd	a5,40(s0)
    800066f8:	03043823          	sd	a6,48(s0)
    800066fc:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006700:	00015d97          	auipc	s11,0x15
    80006704:	dc0dad83          	lw	s11,-576(s11) # 8001b4c0 <pr+0x18>
  if (locking) acquire(&pr.lock);
    80006708:	020d9b63          	bnez	s11,8000673e <printf+0x70>
  if (fmt == 0) panic("null fmt");
    8000670c:	040a0263          	beqz	s4,80006750 <printf+0x82>
  va_start(ap, fmt);
    80006710:	00840793          	addi	a5,s0,8
    80006714:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80006718:	000a4503          	lbu	a0,0(s4)
    8000671c:	14050f63          	beqz	a0,8000687a <printf+0x1ac>
    80006720:	4981                	li	s3,0
    if (c != '%') {
    80006722:	02500a93          	li	s5,37
    switch (c) {
    80006726:	07000b93          	li	s7,112
  consputc('x');
    8000672a:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000672c:	00002b17          	auipc	s6,0x2
    80006730:	1d4b0b13          	addi	s6,s6,468 # 80008900 <digits>
    switch (c) {
    80006734:	07300c93          	li	s9,115
    80006738:	06400c13          	li	s8,100
    8000673c:	a82d                	j	80006776 <printf+0xa8>
  if (locking) acquire(&pr.lock);
    8000673e:	00015517          	auipc	a0,0x15
    80006742:	d6a50513          	addi	a0,a0,-662 # 8001b4a8 <pr>
    80006746:	00000097          	auipc	ra,0x0
    8000674a:	476080e7          	jalr	1142(ra) # 80006bbc <acquire>
    8000674e:	bf7d                	j	8000670c <printf+0x3e>
  if (fmt == 0) panic("null fmt");
    80006750:	00002517          	auipc	a0,0x2
    80006754:	19850513          	addi	a0,a0,408 # 800088e8 <syscalls+0x548>
    80006758:	00000097          	auipc	ra,0x0
    8000675c:	f2c080e7          	jalr	-212(ra) # 80006684 <panic>
      consputc(c);
    80006760:	00000097          	auipc	ra,0x0
    80006764:	c60080e7          	jalr	-928(ra) # 800063c0 <consputc>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80006768:	2985                	addiw	s3,s3,1
    8000676a:	013a07b3          	add	a5,s4,s3
    8000676e:	0007c503          	lbu	a0,0(a5)
    80006772:	10050463          	beqz	a0,8000687a <printf+0x1ac>
    if (c != '%') {
    80006776:	ff5515e3          	bne	a0,s5,80006760 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000677a:	2985                	addiw	s3,s3,1
    8000677c:	013a07b3          	add	a5,s4,s3
    80006780:	0007c783          	lbu	a5,0(a5)
    80006784:	0007849b          	sext.w	s1,a5
    if (c == 0) break;
    80006788:	cbed                	beqz	a5,8000687a <printf+0x1ac>
    switch (c) {
    8000678a:	05778a63          	beq	a5,s7,800067de <printf+0x110>
    8000678e:	02fbf663          	bgeu	s7,a5,800067ba <printf+0xec>
    80006792:	09978863          	beq	a5,s9,80006822 <printf+0x154>
    80006796:	07800713          	li	a4,120
    8000679a:	0ce79563          	bne	a5,a4,80006864 <printf+0x196>
        printint(va_arg(ap, int), 16, 1);
    8000679e:	f8843783          	ld	a5,-120(s0)
    800067a2:	00878713          	addi	a4,a5,8
    800067a6:	f8e43423          	sd	a4,-120(s0)
    800067aa:	4605                	li	a2,1
    800067ac:	85ea                	mv	a1,s10
    800067ae:	4388                	lw	a0,0(a5)
    800067b0:	00000097          	auipc	ra,0x0
    800067b4:	e30080e7          	jalr	-464(ra) # 800065e0 <printint>
        break;
    800067b8:	bf45                	j	80006768 <printf+0x9a>
    switch (c) {
    800067ba:	09578f63          	beq	a5,s5,80006858 <printf+0x18a>
    800067be:	0b879363          	bne	a5,s8,80006864 <printf+0x196>
        printint(va_arg(ap, int), 10, 1);
    800067c2:	f8843783          	ld	a5,-120(s0)
    800067c6:	00878713          	addi	a4,a5,8
    800067ca:	f8e43423          	sd	a4,-120(s0)
    800067ce:	4605                	li	a2,1
    800067d0:	45a9                	li	a1,10
    800067d2:	4388                	lw	a0,0(a5)
    800067d4:	00000097          	auipc	ra,0x0
    800067d8:	e0c080e7          	jalr	-500(ra) # 800065e0 <printint>
        break;
    800067dc:	b771                	j	80006768 <printf+0x9a>
        printptr(va_arg(ap, uint64));
    800067de:	f8843783          	ld	a5,-120(s0)
    800067e2:	00878713          	addi	a4,a5,8
    800067e6:	f8e43423          	sd	a4,-120(s0)
    800067ea:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800067ee:	03000513          	li	a0,48
    800067f2:	00000097          	auipc	ra,0x0
    800067f6:	bce080e7          	jalr	-1074(ra) # 800063c0 <consputc>
  consputc('x');
    800067fa:	07800513          	li	a0,120
    800067fe:	00000097          	auipc	ra,0x0
    80006802:	bc2080e7          	jalr	-1086(ra) # 800063c0 <consputc>
    80006806:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006808:	03c95793          	srli	a5,s2,0x3c
    8000680c:	97da                	add	a5,a5,s6
    8000680e:	0007c503          	lbu	a0,0(a5)
    80006812:	00000097          	auipc	ra,0x0
    80006816:	bae080e7          	jalr	-1106(ra) # 800063c0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000681a:	0912                	slli	s2,s2,0x4
    8000681c:	34fd                	addiw	s1,s1,-1
    8000681e:	f4ed                	bnez	s1,80006808 <printf+0x13a>
    80006820:	b7a1                	j	80006768 <printf+0x9a>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    80006822:	f8843783          	ld	a5,-120(s0)
    80006826:	00878713          	addi	a4,a5,8
    8000682a:	f8e43423          	sd	a4,-120(s0)
    8000682e:	6384                	ld	s1,0(a5)
    80006830:	cc89                	beqz	s1,8000684a <printf+0x17c>
        for (; *s; s++) consputc(*s);
    80006832:	0004c503          	lbu	a0,0(s1)
    80006836:	d90d                	beqz	a0,80006768 <printf+0x9a>
    80006838:	00000097          	auipc	ra,0x0
    8000683c:	b88080e7          	jalr	-1144(ra) # 800063c0 <consputc>
    80006840:	0485                	addi	s1,s1,1
    80006842:	0004c503          	lbu	a0,0(s1)
    80006846:	f96d                	bnez	a0,80006838 <printf+0x16a>
    80006848:	b705                	j	80006768 <printf+0x9a>
        if ((s = va_arg(ap, char *)) == 0) s = "(null)";
    8000684a:	00002497          	auipc	s1,0x2
    8000684e:	09648493          	addi	s1,s1,150 # 800088e0 <syscalls+0x540>
        for (; *s; s++) consputc(*s);
    80006852:	02800513          	li	a0,40
    80006856:	b7cd                	j	80006838 <printf+0x16a>
        consputc('%');
    80006858:	8556                	mv	a0,s5
    8000685a:	00000097          	auipc	ra,0x0
    8000685e:	b66080e7          	jalr	-1178(ra) # 800063c0 <consputc>
        break;
    80006862:	b719                	j	80006768 <printf+0x9a>
        consputc('%');
    80006864:	8556                	mv	a0,s5
    80006866:	00000097          	auipc	ra,0x0
    8000686a:	b5a080e7          	jalr	-1190(ra) # 800063c0 <consputc>
        consputc(c);
    8000686e:	8526                	mv	a0,s1
    80006870:	00000097          	auipc	ra,0x0
    80006874:	b50080e7          	jalr	-1200(ra) # 800063c0 <consputc>
        break;
    80006878:	bdc5                	j	80006768 <printf+0x9a>
  if (locking) release(&pr.lock);
    8000687a:	020d9163          	bnez	s11,8000689c <printf+0x1ce>
}
    8000687e:	70e6                	ld	ra,120(sp)
    80006880:	7446                	ld	s0,112(sp)
    80006882:	74a6                	ld	s1,104(sp)
    80006884:	7906                	ld	s2,96(sp)
    80006886:	69e6                	ld	s3,88(sp)
    80006888:	6a46                	ld	s4,80(sp)
    8000688a:	6aa6                	ld	s5,72(sp)
    8000688c:	6b06                	ld	s6,64(sp)
    8000688e:	7be2                	ld	s7,56(sp)
    80006890:	7c42                	ld	s8,48(sp)
    80006892:	7ca2                	ld	s9,40(sp)
    80006894:	7d02                	ld	s10,32(sp)
    80006896:	6de2                	ld	s11,24(sp)
    80006898:	6129                	addi	sp,sp,192
    8000689a:	8082                	ret
  if (locking) release(&pr.lock);
    8000689c:	00015517          	auipc	a0,0x15
    800068a0:	c0c50513          	addi	a0,a0,-1012 # 8001b4a8 <pr>
    800068a4:	00000097          	auipc	ra,0x0
    800068a8:	3c6080e7          	jalr	966(ra) # 80006c6a <release>
}
    800068ac:	bfc9                	j	8000687e <printf+0x1b0>

00000000800068ae <printfinit>:
    ;
}

void printfinit(void) {
    800068ae:	1101                	addi	sp,sp,-32
    800068b0:	ec06                	sd	ra,24(sp)
    800068b2:	e822                	sd	s0,16(sp)
    800068b4:	e426                	sd	s1,8(sp)
    800068b6:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800068b8:	00015497          	auipc	s1,0x15
    800068bc:	bf048493          	addi	s1,s1,-1040 # 8001b4a8 <pr>
    800068c0:	00002597          	auipc	a1,0x2
    800068c4:	03858593          	addi	a1,a1,56 # 800088f8 <syscalls+0x558>
    800068c8:	8526                	mv	a0,s1
    800068ca:	00000097          	auipc	ra,0x0
    800068ce:	262080e7          	jalr	610(ra) # 80006b2c <initlock>
  pr.locking = 1;
    800068d2:	4785                	li	a5,1
    800068d4:	cc9c                	sw	a5,24(s1)
}
    800068d6:	60e2                	ld	ra,24(sp)
    800068d8:	6442                	ld	s0,16(sp)
    800068da:	64a2                	ld	s1,8(sp)
    800068dc:	6105                	addi	sp,sp,32
    800068de:	8082                	ret

00000000800068e0 <uartinit>:

extern volatile int panicked;  // from printf.c

void uartstart();

void uartinit(void) {
    800068e0:	1141                	addi	sp,sp,-16
    800068e2:	e406                	sd	ra,8(sp)
    800068e4:	e022                	sd	s0,0(sp)
    800068e6:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800068e8:	100007b7          	lui	a5,0x10000
    800068ec:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800068f0:	f8000713          	li	a4,-128
    800068f4:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800068f8:	470d                	li	a4,3
    800068fa:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800068fe:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006902:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006906:	469d                	li	a3,7
    80006908:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000690c:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006910:	00002597          	auipc	a1,0x2
    80006914:	00858593          	addi	a1,a1,8 # 80008918 <digits+0x18>
    80006918:	00015517          	auipc	a0,0x15
    8000691c:	bb050513          	addi	a0,a0,-1104 # 8001b4c8 <uart_tx_lock>
    80006920:	00000097          	auipc	ra,0x0
    80006924:	20c080e7          	jalr	524(ra) # 80006b2c <initlock>
}
    80006928:	60a2                	ld	ra,8(sp)
    8000692a:	6402                	ld	s0,0(sp)
    8000692c:	0141                	addi	sp,sp,16
    8000692e:	8082                	ret

0000000080006930 <uartputc_sync>:

// alternate version of uartputc() that doesn't
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void uartputc_sync(int c) {
    80006930:	1101                	addi	sp,sp,-32
    80006932:	ec06                	sd	ra,24(sp)
    80006934:	e822                	sd	s0,16(sp)
    80006936:	e426                	sd	s1,8(sp)
    80006938:	1000                	addi	s0,sp,32
    8000693a:	84aa                	mv	s1,a0
  push_off();
    8000693c:	00000097          	auipc	ra,0x0
    80006940:	234080e7          	jalr	564(ra) # 80006b70 <push_off>

  if (panicked) {
    80006944:	00002797          	auipc	a5,0x2
    80006948:	0c07a783          	lw	a5,192(a5) # 80008a04 <panicked>
    for (;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000694c:	10000737          	lui	a4,0x10000
  if (panicked) {
    80006950:	c391                	beqz	a5,80006954 <uartputc_sync+0x24>
    for (;;)
    80006952:	a001                	j	80006952 <uartputc_sync+0x22>
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006954:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006958:	0207f793          	andi	a5,a5,32
    8000695c:	dfe5                	beqz	a5,80006954 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000695e:	0ff4f513          	zext.b	a0,s1
    80006962:	100007b7          	lui	a5,0x10000
    80006966:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000696a:	00000097          	auipc	ra,0x0
    8000696e:	2a0080e7          	jalr	672(ra) # 80006c0a <pop_off>
}
    80006972:	60e2                	ld	ra,24(sp)
    80006974:	6442                	ld	s0,16(sp)
    80006976:	64a2                	ld	s1,8(sp)
    80006978:	6105                	addi	sp,sp,32
    8000697a:	8082                	ret

000000008000697c <uartstart>:
// in the transmit buffer, send it.
// caller must hold uart_tx_lock.
// called from both the top- and bottom-half.
void uartstart() {
  while (1) {
    if (uart_tx_w == uart_tx_r) {
    8000697c:	00002797          	auipc	a5,0x2
    80006980:	08c7b783          	ld	a5,140(a5) # 80008a08 <uart_tx_r>
    80006984:	00002717          	auipc	a4,0x2
    80006988:	08c73703          	ld	a4,140(a4) # 80008a10 <uart_tx_w>
    8000698c:	06f70a63          	beq	a4,a5,80006a00 <uartstart+0x84>
void uartstart() {
    80006990:	7139                	addi	sp,sp,-64
    80006992:	fc06                	sd	ra,56(sp)
    80006994:	f822                	sd	s0,48(sp)
    80006996:	f426                	sd	s1,40(sp)
    80006998:	f04a                	sd	s2,32(sp)
    8000699a:	ec4e                	sd	s3,24(sp)
    8000699c:	e852                	sd	s4,16(sp)
    8000699e:	e456                	sd	s5,8(sp)
    800069a0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }

    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0) {
    800069a2:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }

    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800069a6:	00015a17          	auipc	s4,0x15
    800069aa:	b22a0a13          	addi	s4,s4,-1246 # 8001b4c8 <uart_tx_lock>
    uart_tx_r += 1;
    800069ae:	00002497          	auipc	s1,0x2
    800069b2:	05a48493          	addi	s1,s1,90 # 80008a08 <uart_tx_r>
    if (uart_tx_w == uart_tx_r) {
    800069b6:	00002997          	auipc	s3,0x2
    800069ba:	05a98993          	addi	s3,s3,90 # 80008a10 <uart_tx_w>
    if ((ReadReg(LSR) & LSR_TX_IDLE) == 0) {
    800069be:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800069c2:	02077713          	andi	a4,a4,32
    800069c6:	c705                	beqz	a4,800069ee <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800069c8:	01f7f713          	andi	a4,a5,31
    800069cc:	9752                	add	a4,a4,s4
    800069ce:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800069d2:	0785                	addi	a5,a5,1
    800069d4:	e09c                	sd	a5,0(s1)

    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800069d6:	8526                	mv	a0,s1
    800069d8:	ffffb097          	auipc	ra,0xffffb
    800069dc:	9d6080e7          	jalr	-1578(ra) # 800013ae <wakeup>

    WriteReg(THR, c);
    800069e0:	01590023          	sb	s5,0(s2)
    if (uart_tx_w == uart_tx_r) {
    800069e4:	609c                	ld	a5,0(s1)
    800069e6:	0009b703          	ld	a4,0(s3)
    800069ea:	fcf71ae3          	bne	a4,a5,800069be <uartstart+0x42>
  }
}
    800069ee:	70e2                	ld	ra,56(sp)
    800069f0:	7442                	ld	s0,48(sp)
    800069f2:	74a2                	ld	s1,40(sp)
    800069f4:	7902                	ld	s2,32(sp)
    800069f6:	69e2                	ld	s3,24(sp)
    800069f8:	6a42                	ld	s4,16(sp)
    800069fa:	6aa2                	ld	s5,8(sp)
    800069fc:	6121                	addi	sp,sp,64
    800069fe:	8082                	ret
    80006a00:	8082                	ret

0000000080006a02 <uartputc>:
void uartputc(int c) {
    80006a02:	7179                	addi	sp,sp,-48
    80006a04:	f406                	sd	ra,40(sp)
    80006a06:	f022                	sd	s0,32(sp)
    80006a08:	ec26                	sd	s1,24(sp)
    80006a0a:	e84a                	sd	s2,16(sp)
    80006a0c:	e44e                	sd	s3,8(sp)
    80006a0e:	e052                	sd	s4,0(sp)
    80006a10:	1800                	addi	s0,sp,48
    80006a12:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006a14:	00015517          	auipc	a0,0x15
    80006a18:	ab450513          	addi	a0,a0,-1356 # 8001b4c8 <uart_tx_lock>
    80006a1c:	00000097          	auipc	ra,0x0
    80006a20:	1a0080e7          	jalr	416(ra) # 80006bbc <acquire>
  if (panicked) {
    80006a24:	00002797          	auipc	a5,0x2
    80006a28:	fe07a783          	lw	a5,-32(a5) # 80008a04 <panicked>
    80006a2c:	e7c9                	bnez	a5,80006ab6 <uartputc+0xb4>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    80006a2e:	00002717          	auipc	a4,0x2
    80006a32:	fe273703          	ld	a4,-30(a4) # 80008a10 <uart_tx_w>
    80006a36:	00002797          	auipc	a5,0x2
    80006a3a:	fd27b783          	ld	a5,-46(a5) # 80008a08 <uart_tx_r>
    80006a3e:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006a42:	00015997          	auipc	s3,0x15
    80006a46:	a8698993          	addi	s3,s3,-1402 # 8001b4c8 <uart_tx_lock>
    80006a4a:	00002497          	auipc	s1,0x2
    80006a4e:	fbe48493          	addi	s1,s1,-66 # 80008a08 <uart_tx_r>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    80006a52:	00002917          	auipc	s2,0x2
    80006a56:	fbe90913          	addi	s2,s2,-66 # 80008a10 <uart_tx_w>
    80006a5a:	00e79f63          	bne	a5,a4,80006a78 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006a5e:	85ce                	mv	a1,s3
    80006a60:	8526                	mv	a0,s1
    80006a62:	ffffb097          	auipc	ra,0xffffb
    80006a66:	8e8080e7          	jalr	-1816(ra) # 8000134a <sleep>
  while (uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE) {
    80006a6a:	00093703          	ld	a4,0(s2)
    80006a6e:	609c                	ld	a5,0(s1)
    80006a70:	02078793          	addi	a5,a5,32
    80006a74:	fee785e3          	beq	a5,a4,80006a5e <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006a78:	00015497          	auipc	s1,0x15
    80006a7c:	a5048493          	addi	s1,s1,-1456 # 8001b4c8 <uart_tx_lock>
    80006a80:	01f77793          	andi	a5,a4,31
    80006a84:	97a6                	add	a5,a5,s1
    80006a86:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006a8a:	0705                	addi	a4,a4,1
    80006a8c:	00002797          	auipc	a5,0x2
    80006a90:	f8e7b223          	sd	a4,-124(a5) # 80008a10 <uart_tx_w>
  uartstart();
    80006a94:	00000097          	auipc	ra,0x0
    80006a98:	ee8080e7          	jalr	-280(ra) # 8000697c <uartstart>
  release(&uart_tx_lock);
    80006a9c:	8526                	mv	a0,s1
    80006a9e:	00000097          	auipc	ra,0x0
    80006aa2:	1cc080e7          	jalr	460(ra) # 80006c6a <release>
}
    80006aa6:	70a2                	ld	ra,40(sp)
    80006aa8:	7402                	ld	s0,32(sp)
    80006aaa:	64e2                	ld	s1,24(sp)
    80006aac:	6942                	ld	s2,16(sp)
    80006aae:	69a2                	ld	s3,8(sp)
    80006ab0:	6a02                	ld	s4,0(sp)
    80006ab2:	6145                	addi	sp,sp,48
    80006ab4:	8082                	ret
    for (;;)
    80006ab6:	a001                	j	80006ab6 <uartputc+0xb4>

0000000080006ab8 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int uartgetc(void) {
    80006ab8:	1141                	addi	sp,sp,-16
    80006aba:	e422                	sd	s0,8(sp)
    80006abc:	0800                	addi	s0,sp,16
  if (ReadReg(LSR) & 0x01) {
    80006abe:	100007b7          	lui	a5,0x10000
    80006ac2:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006ac6:	8b85                	andi	a5,a5,1
    80006ac8:	cb81                	beqz	a5,80006ad8 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006aca:	100007b7          	lui	a5,0x10000
    80006ace:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006ad2:	6422                	ld	s0,8(sp)
    80006ad4:	0141                	addi	sp,sp,16
    80006ad6:	8082                	ret
    return -1;
    80006ad8:	557d                	li	a0,-1
    80006ada:	bfe5                	j	80006ad2 <uartgetc+0x1a>

0000000080006adc <uartintr>:

// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void uartintr(void) {
    80006adc:	1101                	addi	sp,sp,-32
    80006ade:	ec06                	sd	ra,24(sp)
    80006ae0:	e822                	sd	s0,16(sp)
    80006ae2:	e426                	sd	s1,8(sp)
    80006ae4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while (1) {
    int c = uartgetc();
    if (c == -1) break;
    80006ae6:	54fd                	li	s1,-1
    80006ae8:	a029                	j	80006af2 <uartintr+0x16>
    consoleintr(c);
    80006aea:	00000097          	auipc	ra,0x0
    80006aee:	918080e7          	jalr	-1768(ra) # 80006402 <consoleintr>
    int c = uartgetc();
    80006af2:	00000097          	auipc	ra,0x0
    80006af6:	fc6080e7          	jalr	-58(ra) # 80006ab8 <uartgetc>
    if (c == -1) break;
    80006afa:	fe9518e3          	bne	a0,s1,80006aea <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006afe:	00015497          	auipc	s1,0x15
    80006b02:	9ca48493          	addi	s1,s1,-1590 # 8001b4c8 <uart_tx_lock>
    80006b06:	8526                	mv	a0,s1
    80006b08:	00000097          	auipc	ra,0x0
    80006b0c:	0b4080e7          	jalr	180(ra) # 80006bbc <acquire>
  uartstart();
    80006b10:	00000097          	auipc	ra,0x0
    80006b14:	e6c080e7          	jalr	-404(ra) # 8000697c <uartstart>
  release(&uart_tx_lock);
    80006b18:	8526                	mv	a0,s1
    80006b1a:	00000097          	auipc	ra,0x0
    80006b1e:	150080e7          	jalr	336(ra) # 80006c6a <release>
}
    80006b22:	60e2                	ld	ra,24(sp)
    80006b24:	6442                	ld	s0,16(sp)
    80006b26:	64a2                	ld	s1,8(sp)
    80006b28:	6105                	addi	sp,sp,32
    80006b2a:	8082                	ret

0000000080006b2c <initlock>:
#include "spinlock.h"
#include "riscv.h"
#include "proc.h"
#include "defs.h"

void initlock(struct spinlock *lk, char *name) {
    80006b2c:	1141                	addi	sp,sp,-16
    80006b2e:	e422                	sd	s0,8(sp)
    80006b30:	0800                	addi	s0,sp,16
  lk->name = name;
    80006b32:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006b34:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006b38:	00053823          	sd	zero,16(a0)
}
    80006b3c:	6422                	ld	s0,8(sp)
    80006b3e:	0141                	addi	sp,sp,16
    80006b40:	8082                	ret

0000000080006b42 <holding>:

// Check whether this cpu is holding the lock.
// Interrupts must be off.
int holding(struct spinlock *lk) {
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006b42:	411c                	lw	a5,0(a0)
    80006b44:	e399                	bnez	a5,80006b4a <holding+0x8>
    80006b46:	4501                	li	a0,0
  return r;
}
    80006b48:	8082                	ret
int holding(struct spinlock *lk) {
    80006b4a:	1101                	addi	sp,sp,-32
    80006b4c:	ec06                	sd	ra,24(sp)
    80006b4e:	e822                	sd	s0,16(sp)
    80006b50:	e426                	sd	s1,8(sp)
    80006b52:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006b54:	6904                	ld	s1,16(a0)
    80006b56:	ffffa097          	auipc	ra,0xffffa
    80006b5a:	0f8080e7          	jalr	248(ra) # 80000c4e <mycpu>
    80006b5e:	40a48533          	sub	a0,s1,a0
    80006b62:	00153513          	seqz	a0,a0
}
    80006b66:	60e2                	ld	ra,24(sp)
    80006b68:	6442                	ld	s0,16(sp)
    80006b6a:	64a2                	ld	s1,8(sp)
    80006b6c:	6105                	addi	sp,sp,32
    80006b6e:	8082                	ret

0000000080006b70 <push_off>:

// push_off/pop_off are like intr_off()/intr_on() except that they are matched:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void push_off(void) {
    80006b70:	1101                	addi	sp,sp,-32
    80006b72:	ec06                	sd	ra,24(sp)
    80006b74:	e822                	sd	s0,16(sp)
    80006b76:	e426                	sd	s1,8(sp)
    80006b78:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80006b7a:	100024f3          	csrr	s1,sstatus
    80006b7e:	100027f3          	csrr	a5,sstatus
static inline void intr_off() { w_sstatus(r_sstatus() & ~SSTATUS_SIE); }
    80006b82:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80006b84:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if (mycpu()->noff == 0) mycpu()->intena = old;
    80006b88:	ffffa097          	auipc	ra,0xffffa
    80006b8c:	0c6080e7          	jalr	198(ra) # 80000c4e <mycpu>
    80006b90:	5d3c                	lw	a5,120(a0)
    80006b92:	cf89                	beqz	a5,80006bac <push_off+0x3c>
  mycpu()->noff += 1;
    80006b94:	ffffa097          	auipc	ra,0xffffa
    80006b98:	0ba080e7          	jalr	186(ra) # 80000c4e <mycpu>
    80006b9c:	5d3c                	lw	a5,120(a0)
    80006b9e:	2785                	addiw	a5,a5,1
    80006ba0:	dd3c                	sw	a5,120(a0)
}
    80006ba2:	60e2                	ld	ra,24(sp)
    80006ba4:	6442                	ld	s0,16(sp)
    80006ba6:	64a2                	ld	s1,8(sp)
    80006ba8:	6105                	addi	sp,sp,32
    80006baa:	8082                	ret
  if (mycpu()->noff == 0) mycpu()->intena = old;
    80006bac:	ffffa097          	auipc	ra,0xffffa
    80006bb0:	0a2080e7          	jalr	162(ra) # 80000c4e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006bb4:	8085                	srli	s1,s1,0x1
    80006bb6:	8885                	andi	s1,s1,1
    80006bb8:	dd64                	sw	s1,124(a0)
    80006bba:	bfe9                	j	80006b94 <push_off+0x24>

0000000080006bbc <acquire>:
void acquire(struct spinlock *lk) {
    80006bbc:	1101                	addi	sp,sp,-32
    80006bbe:	ec06                	sd	ra,24(sp)
    80006bc0:	e822                	sd	s0,16(sp)
    80006bc2:	e426                	sd	s1,8(sp)
    80006bc4:	1000                	addi	s0,sp,32
    80006bc6:	84aa                	mv	s1,a0
  push_off();  // disable interrupts to avoid deadlock.
    80006bc8:	00000097          	auipc	ra,0x0
    80006bcc:	fa8080e7          	jalr	-88(ra) # 80006b70 <push_off>
  if (holding(lk)) panic(lk->name);
    80006bd0:	8526                	mv	a0,s1
    80006bd2:	00000097          	auipc	ra,0x0
    80006bd6:	f70080e7          	jalr	-144(ra) # 80006b42 <holding>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006bda:	4705                	li	a4,1
  if (holding(lk)) panic(lk->name);
    80006bdc:	e115                	bnez	a0,80006c00 <acquire+0x44>
  while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006bde:	87ba                	mv	a5,a4
    80006be0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006be4:	2781                	sext.w	a5,a5
    80006be6:	ffe5                	bnez	a5,80006bde <acquire+0x22>
  __sync_synchronize();
    80006be8:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006bec:	ffffa097          	auipc	ra,0xffffa
    80006bf0:	062080e7          	jalr	98(ra) # 80000c4e <mycpu>
    80006bf4:	e888                	sd	a0,16(s1)
}
    80006bf6:	60e2                	ld	ra,24(sp)
    80006bf8:	6442                	ld	s0,16(sp)
    80006bfa:	64a2                	ld	s1,8(sp)
    80006bfc:	6105                	addi	sp,sp,32
    80006bfe:	8082                	ret
  if (holding(lk)) panic(lk->name);
    80006c00:	6488                	ld	a0,8(s1)
    80006c02:	00000097          	auipc	ra,0x0
    80006c06:	a82080e7          	jalr	-1406(ra) # 80006684 <panic>

0000000080006c0a <pop_off>:

void pop_off(void) {
    80006c0a:	1141                	addi	sp,sp,-16
    80006c0c:	e406                	sd	ra,8(sp)
    80006c0e:	e022                	sd	s0,0(sp)
    80006c10:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006c12:	ffffa097          	auipc	ra,0xffffa
    80006c16:	03c080e7          	jalr	60(ra) # 80000c4e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80006c1a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006c1e:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("pop_off - interruptible");
    80006c20:	e78d                	bnez	a5,80006c4a <pop_off+0x40>
  if (c->noff < 1) panic("pop_off");
    80006c22:	5d3c                	lw	a5,120(a0)
    80006c24:	02f05b63          	blez	a5,80006c5a <pop_off+0x50>
  c->noff -= 1;
    80006c28:	37fd                	addiw	a5,a5,-1
    80006c2a:	0007871b          	sext.w	a4,a5
    80006c2e:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena) intr_on();
    80006c30:	eb09                	bnez	a4,80006c42 <pop_off+0x38>
    80006c32:	5d7c                	lw	a5,124(a0)
    80006c34:	c799                	beqz	a5,80006c42 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80006c36:	100027f3          	csrr	a5,sstatus
static inline void intr_on() { w_sstatus(r_sstatus() | SSTATUS_SIE); }
    80006c3a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80006c3e:	10079073          	csrw	sstatus,a5
}
    80006c42:	60a2                	ld	ra,8(sp)
    80006c44:	6402                	ld	s0,0(sp)
    80006c46:	0141                	addi	sp,sp,16
    80006c48:	8082                	ret
  if (intr_get()) panic("pop_off - interruptible");
    80006c4a:	00002517          	auipc	a0,0x2
    80006c4e:	cd650513          	addi	a0,a0,-810 # 80008920 <digits+0x20>
    80006c52:	00000097          	auipc	ra,0x0
    80006c56:	a32080e7          	jalr	-1486(ra) # 80006684 <panic>
  if (c->noff < 1) panic("pop_off");
    80006c5a:	00002517          	auipc	a0,0x2
    80006c5e:	cde50513          	addi	a0,a0,-802 # 80008938 <digits+0x38>
    80006c62:	00000097          	auipc	ra,0x0
    80006c66:	a22080e7          	jalr	-1502(ra) # 80006684 <panic>

0000000080006c6a <release>:
void release(struct spinlock *lk) {
    80006c6a:	1101                	addi	sp,sp,-32
    80006c6c:	ec06                	sd	ra,24(sp)
    80006c6e:	e822                	sd	s0,16(sp)
    80006c70:	e426                	sd	s1,8(sp)
    80006c72:	1000                	addi	s0,sp,32
    80006c74:	84aa                	mv	s1,a0
  if (!holding(lk)) panic("release");
    80006c76:	00000097          	auipc	ra,0x0
    80006c7a:	ecc080e7          	jalr	-308(ra) # 80006b42 <holding>
    80006c7e:	c115                	beqz	a0,80006ca2 <release+0x38>
  lk->cpu = 0;
    80006c80:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006c84:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006c88:	0f50000f          	fence	iorw,ow
    80006c8c:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006c90:	00000097          	auipc	ra,0x0
    80006c94:	f7a080e7          	jalr	-134(ra) # 80006c0a <pop_off>
}
    80006c98:	60e2                	ld	ra,24(sp)
    80006c9a:	6442                	ld	s0,16(sp)
    80006c9c:	64a2                	ld	s1,8(sp)
    80006c9e:	6105                	addi	sp,sp,32
    80006ca0:	8082                	ret
  if (!holding(lk)) panic("release");
    80006ca2:	00002517          	auipc	a0,0x2
    80006ca6:	c9e50513          	addi	a0,a0,-866 # 80008940 <digits+0x40>
    80006caa:	00000097          	auipc	ra,0x0
    80006cae:	9da080e7          	jalr	-1574(ra) # 80006684 <panic>
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
