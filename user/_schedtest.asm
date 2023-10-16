
user/_schedtest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "pstat.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	81 ec 1c 04 00 00    	sub    $0x41c,%esp
  if(argc < 2){
  16:	83 39 01             	cmpl   $0x1,(%ecx)
{
  19:	8b 41 04             	mov    0x4(%ecx),%eax
  if(argc < 2){
  1c:	0f 8e 4c 01 00 00    	jle    16e <main+0x16e>
    printf(2, "Usage: %s [100M-iterations]\n", argv[0]);
    exit();
  }

  int itr = atoi(argv[1]);
  22:	83 ec 0c             	sub    $0xc,%esp
  25:	ff 70 04             	push   0x4(%eax)
  28:	e8 43 03 00 00       	call   370 <atoi>
  2d:	89 c3                	mov    %eax,%ebx

  // Set the number of tickets for the current process
  int parent = 0;
  
  int pid = 0;
  int childpid = fork();
  2f:	e8 a7 03 00 00       	call   3db <fork>

  if (childpid) {
  34:	83 c4 10             	add    $0x10,%esp
  int childpid = fork();
  37:	89 c6                	mov    %eax,%esi
  if (childpid) {
  39:	85 c0                	test   %eax,%eax
  3b:	0f 85 d5 00 00 00    	jne    116 <main+0x116>
    pid = getpid();
    printf(1, "Parent pid: '%d'\n", pid);
    settickets(30);
  }
  else {
    pid = getpid();
  41:	e8 1d 04 00 00       	call   463 <getpid>
    printf(1, "Child pid: '%d'\n", pid);
    settickets(10);
  }

  int iterations = 100000000 * itr;
  46:	69 db 00 e1 f5 05    	imul   $0x5f5e100,%ebx,%ebx
    printf(1, "Child pid: '%d'\n", pid);
  4c:	52                   	push   %edx
  4d:	50                   	push   %eax
  4e:	68 a9 08 00 00       	push   $0x8a9
  53:	6a 01                	push   $0x1
  55:	e8 e6 04 00 00       	call   540 <printf>
    settickets(10);
  5a:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  61:	e8 25 04 00 00       	call   48b <settickets>
  printf(1, "iterations: '%d'\n", iterations);
  66:	83 c4 0c             	add    $0xc,%esp
  69:	53                   	push   %ebx
  6a:	68 97 08 00 00       	push   $0x897
  6f:	6a 01                	push   $0x1
  71:	e8 ca 04 00 00       	call   540 <printf>

  for (volatile int i = 0; i < iterations; i++);
  76:	31 c9                	xor    %ecx,%ecx
  78:	83 c4 10             	add    $0x10,%esp
  7b:	89 8d e4 fb ff ff    	mov    %ecx,-0x41c(%ebp)
  81:	8b 85 e4 fb ff ff    	mov    -0x41c(%ebp),%eax
  87:	39 c3                	cmp    %eax,%ebx
  89:	0f 8e 82 00 00 00    	jle    111 <main+0x111>
  8f:	90                   	nop
  90:	8b 85 e4 fb ff ff    	mov    -0x41c(%ebp),%eax
  96:	83 c0 01             	add    $0x1,%eax
  99:	89 85 e4 fb ff ff    	mov    %eax,-0x41c(%ebp)
  9f:	8b 85 e4 fb ff ff    	mov    -0x41c(%ebp),%eax
  a5:	39 d8                	cmp    %ebx,%eax
  a7:	7c e7                	jl     90 <main+0x90>
  
  if (parent) {  
  a9:	85 f6                	test   %esi,%esi
  ab:	74 64                	je     111 <main+0x111>
    struct pstat stats;
    if (getpinfo(&stats) < 0) {
  ad:	83 ec 0c             	sub    $0xc,%esp
  b0:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
  b6:	50                   	push   %eax
  b7:	e8 d7 03 00 00       	call   493 <getpinfo>
  bc:	83 c4 10             	add    $0x10,%esp
  bf:	85 c0                	test   %eax,%eax
  c1:	0f 88 bb 00 00 00    	js     182 <main+0x182>
  c7:	8d 9d e8 fc ff ff    	lea    -0x318(%ebp),%ebx
  cd:	8d b5 e8 fd ff ff    	lea    -0x218(%ebp),%esi
  d3:	eb 0a                	jmp    df <main+0xdf>
  d5:	8d 76 00             	lea    0x0(%esi),%esi
      printf(2, "Call to getpinfo() failed!\n");
      exit();
    }

    // traverse entries and display per-process information
    for (int i = 0; i < sizeof(stats.pid)/sizeof(stats.pid[0]); i++){
  d8:	83 c3 04             	add    $0x4,%ebx
  db:	39 de                	cmp    %ebx,%esi
  dd:	74 2d                	je     10c <main+0x10c>
      if (stats.pid[i]) {
  df:	8b 83 00 01 00 00    	mov    0x100(%ebx),%eax
  e5:	85 c0                	test   %eax,%eax
  e7:	74 ef                	je     d8 <main+0xd8>
          printf(1, "%d\t%d\t%d\n", stats.pid[i], stats.tickets[i], stats.ticks[i]);   
  e9:	83 ec 0c             	sub    $0xc,%esp
  ec:	ff b3 00 02 00 00    	push   0x200(%ebx)
    for (int i = 0; i < sizeof(stats.pid)/sizeof(stats.pid[0]); i++){
  f2:	83 c3 04             	add    $0x4,%ebx
          printf(1, "%d\t%d\t%d\n", stats.pid[i], stats.tickets[i], stats.ticks[i]);   
  f5:	ff 73 fc             	push   -0x4(%ebx)
  f8:	50                   	push   %eax
  f9:	68 d6 08 00 00       	push   $0x8d6
  fe:	6a 01                	push   $0x1
 100:	e8 3b 04 00 00       	call   540 <printf>
 105:	83 c4 20             	add    $0x20,%esp
    for (int i = 0; i < sizeof(stats.pid)/sizeof(stats.pid[0]); i++){
 108:	39 de                	cmp    %ebx,%esi
 10a:	75 d3                	jne    df <main+0xdf>
      }
    }
    wait();
 10c:	e8 da 02 00 00       	call   3eb <wait>
  }
  
  exit();
 111:	e8 cd 02 00 00       	call   3e3 <exit>
    pid = getpid();
 116:	e8 48 03 00 00       	call   463 <getpid>
    printf(1, "Parent pid: '%d'\n", pid);
 11b:	56                   	push   %esi
  int iterations = 100000000 * itr;
 11c:	69 db 00 e1 f5 05    	imul   $0x5f5e100,%ebx,%ebx
    parent = 1;
 122:	be 01 00 00 00       	mov    $0x1,%esi
    printf(1, "Parent pid: '%d'\n", pid);
 127:	50                   	push   %eax
 128:	68 85 08 00 00       	push   $0x885
 12d:	6a 01                	push   $0x1
 12f:	e8 0c 04 00 00       	call   540 <printf>
    settickets(30);
 134:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
 13b:	e8 4b 03 00 00       	call   48b <settickets>
  printf(1, "iterations: '%d'\n", iterations);
 140:	83 c4 0c             	add    $0xc,%esp
 143:	53                   	push   %ebx
 144:	68 97 08 00 00       	push   $0x897
 149:	6a 01                	push   $0x1
 14b:	e8 f0 03 00 00       	call   540 <printf>
  for (volatile int i = 0; i < iterations; i++);
 150:	31 c0                	xor    %eax,%eax
 152:	83 c4 10             	add    $0x10,%esp
 155:	89 85 e4 fb ff ff    	mov    %eax,-0x41c(%ebp)
 15b:	8b 85 e4 fb ff ff    	mov    -0x41c(%ebp),%eax
 161:	39 c3                	cmp    %eax,%ebx
 163:	0f 8f 27 ff ff ff    	jg     90 <main+0x90>
 169:	e9 3f ff ff ff       	jmp    ad <main+0xad>
    printf(2, "Usage: %s [100M-iterations]\n", argv[0]);
 16e:	52                   	push   %edx
 16f:	ff 30                	push   (%eax)
 171:	68 68 08 00 00       	push   $0x868
 176:	6a 02                	push   $0x2
 178:	e8 c3 03 00 00       	call   540 <printf>
    exit();
 17d:	e8 61 02 00 00       	call   3e3 <exit>
      printf(2, "Call to getpinfo() failed!\n");
 182:	50                   	push   %eax
 183:	50                   	push   %eax
 184:	68 ba 08 00 00       	push   $0x8ba
 189:	6a 02                	push   $0x2
 18b:	e8 b0 03 00 00       	call   540 <printf>
      exit();
 190:	e8 4e 02 00 00       	call   3e3 <exit>
 195:	66 90                	xchg   %ax,%ax
 197:	66 90                	xchg   %ax,%ax
 199:	66 90                	xchg   %ax,%ax
 19b:	66 90                	xchg   %ax,%ax
 19d:	66 90                	xchg   %ax,%ax
 19f:	90                   	nop

000001a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1a0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1a1:	31 c0                	xor    %eax,%eax
{
 1a3:	89 e5                	mov    %esp,%ebp
 1a5:	53                   	push   %ebx
 1a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 1b0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 1b4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 1b7:	83 c0 01             	add    $0x1,%eax
 1ba:	84 d2                	test   %dl,%dl
 1bc:	75 f2                	jne    1b0 <strcpy+0x10>
    ;
  return os;
}
 1be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1c1:	89 c8                	mov    %ecx,%eax
 1c3:	c9                   	leave
 1c4:	c3                   	ret
 1c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	53                   	push   %ebx
 1d4:	8b 55 08             	mov    0x8(%ebp),%edx
 1d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 1da:	0f b6 02             	movzbl (%edx),%eax
 1dd:	84 c0                	test   %al,%al
 1df:	75 17                	jne    1f8 <strcmp+0x28>
 1e1:	eb 3a                	jmp    21d <strcmp+0x4d>
 1e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1e7:	90                   	nop
 1e8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 1ec:	83 c2 01             	add    $0x1,%edx
 1ef:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 1f2:	84 c0                	test   %al,%al
 1f4:	74 1a                	je     210 <strcmp+0x40>
    p++, q++;
 1f6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 1f8:	0f b6 19             	movzbl (%ecx),%ebx
 1fb:	38 c3                	cmp    %al,%bl
 1fd:	74 e9                	je     1e8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 1ff:	29 d8                	sub    %ebx,%eax
}
 201:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 204:	c9                   	leave
 205:	c3                   	ret
 206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 210:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 214:	31 c0                	xor    %eax,%eax
 216:	29 d8                	sub    %ebx,%eax
}
 218:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 21b:	c9                   	leave
 21c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 21d:	0f b6 19             	movzbl (%ecx),%ebx
 220:	31 c0                	xor    %eax,%eax
 222:	eb db                	jmp    1ff <strcmp+0x2f>
 224:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 22b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 22f:	90                   	nop

00000230 <strlen>:

uint
strlen(const char *s)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 236:	80 3a 00             	cmpb   $0x0,(%edx)
 239:	74 15                	je     250 <strlen+0x20>
 23b:	31 c0                	xor    %eax,%eax
 23d:	8d 76 00             	lea    0x0(%esi),%esi
 240:	83 c0 01             	add    $0x1,%eax
 243:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 247:	89 c1                	mov    %eax,%ecx
 249:	75 f5                	jne    240 <strlen+0x10>
    ;
  return n;
}
 24b:	89 c8                	mov    %ecx,%eax
 24d:	5d                   	pop    %ebp
 24e:	c3                   	ret
 24f:	90                   	nop
  for(n = 0; s[n]; n++)
 250:	31 c9                	xor    %ecx,%ecx
}
 252:	5d                   	pop    %ebp
 253:	89 c8                	mov    %ecx,%eax
 255:	c3                   	ret
 256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25d:	8d 76 00             	lea    0x0(%esi),%esi

00000260 <memset>:

void*
memset(void *dst, int c, uint n)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	57                   	push   %edi
 264:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 267:	8b 4d 10             	mov    0x10(%ebp),%ecx
 26a:	8b 45 0c             	mov    0xc(%ebp),%eax
 26d:	89 d7                	mov    %edx,%edi
 26f:	fc                   	cld
 270:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 272:	8b 7d fc             	mov    -0x4(%ebp),%edi
 275:	89 d0                	mov    %edx,%eax
 277:	c9                   	leave
 278:	c3                   	ret
 279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000280 <strchr>:

char*
strchr(const char *s, char c)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 28a:	0f b6 10             	movzbl (%eax),%edx
 28d:	84 d2                	test   %dl,%dl
 28f:	75 12                	jne    2a3 <strchr+0x23>
 291:	eb 1d                	jmp    2b0 <strchr+0x30>
 293:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 297:	90                   	nop
 298:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 29c:	83 c0 01             	add    $0x1,%eax
 29f:	84 d2                	test   %dl,%dl
 2a1:	74 0d                	je     2b0 <strchr+0x30>
    if(*s == c)
 2a3:	38 d1                	cmp    %dl,%cl
 2a5:	75 f1                	jne    298 <strchr+0x18>
      return (char*)s;
  return 0;
}
 2a7:	5d                   	pop    %ebp
 2a8:	c3                   	ret
 2a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 2b0:	31 c0                	xor    %eax,%eax
}
 2b2:	5d                   	pop    %ebp
 2b3:	c3                   	ret
 2b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2bf:	90                   	nop

000002c0 <gets>:

char*
gets(char *buf, int max)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	57                   	push   %edi
 2c4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 2c5:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 2c8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 2c9:	31 db                	xor    %ebx,%ebx
{
 2cb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 2ce:	eb 27                	jmp    2f7 <gets+0x37>
    cc = read(0, &c, 1);
 2d0:	83 ec 04             	sub    $0x4,%esp
 2d3:	6a 01                	push   $0x1
 2d5:	56                   	push   %esi
 2d6:	6a 00                	push   $0x0
 2d8:	e8 1e 01 00 00       	call   3fb <read>
    if(cc < 1)
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	85 c0                	test   %eax,%eax
 2e2:	7e 1d                	jle    301 <gets+0x41>
      break;
    buf[i++] = c;
 2e4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2e8:	8b 55 08             	mov    0x8(%ebp),%edx
 2eb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 2ef:	3c 0a                	cmp    $0xa,%al
 2f1:	74 10                	je     303 <gets+0x43>
 2f3:	3c 0d                	cmp    $0xd,%al
 2f5:	74 0c                	je     303 <gets+0x43>
  for(i=0; i+1 < max; ){
 2f7:	89 df                	mov    %ebx,%edi
 2f9:	83 c3 01             	add    $0x1,%ebx
 2fc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2ff:	7c cf                	jl     2d0 <gets+0x10>
 301:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 303:	8b 45 08             	mov    0x8(%ebp),%eax
 306:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 30a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 30d:	5b                   	pop    %ebx
 30e:	5e                   	pop    %esi
 30f:	5f                   	pop    %edi
 310:	5d                   	pop    %ebp
 311:	c3                   	ret
 312:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000320 <stat>:

int
stat(const char *n, struct stat *st)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	56                   	push   %esi
 324:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 325:	83 ec 08             	sub    $0x8,%esp
 328:	6a 00                	push   $0x0
 32a:	ff 75 08             	push   0x8(%ebp)
 32d:	e8 f1 00 00 00       	call   423 <open>
  if(fd < 0)
 332:	83 c4 10             	add    $0x10,%esp
 335:	85 c0                	test   %eax,%eax
 337:	78 27                	js     360 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 339:	83 ec 08             	sub    $0x8,%esp
 33c:	ff 75 0c             	push   0xc(%ebp)
 33f:	89 c3                	mov    %eax,%ebx
 341:	50                   	push   %eax
 342:	e8 f4 00 00 00       	call   43b <fstat>
  close(fd);
 347:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 34a:	89 c6                	mov    %eax,%esi
  close(fd);
 34c:	e8 ba 00 00 00       	call   40b <close>
  return r;
 351:	83 c4 10             	add    $0x10,%esp
}
 354:	8d 65 f8             	lea    -0x8(%ebp),%esp
 357:	89 f0                	mov    %esi,%eax
 359:	5b                   	pop    %ebx
 35a:	5e                   	pop    %esi
 35b:	5d                   	pop    %ebp
 35c:	c3                   	ret
 35d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 360:	be ff ff ff ff       	mov    $0xffffffff,%esi
 365:	eb ed                	jmp    354 <stat+0x34>
 367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 36e:	66 90                	xchg   %ax,%ax

00000370 <atoi>:

int
atoi(const char *s)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	53                   	push   %ebx
 374:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 377:	0f be 02             	movsbl (%edx),%eax
 37a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 37d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 380:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 385:	77 1e                	ja     3a5 <atoi+0x35>
 387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 38e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 390:	83 c2 01             	add    $0x1,%edx
 393:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 396:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 39a:	0f be 02             	movsbl (%edx),%eax
 39d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3a0:	80 fb 09             	cmp    $0x9,%bl
 3a3:	76 eb                	jbe    390 <atoi+0x20>
  return n;
}
 3a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3a8:	89 c8                	mov    %ecx,%eax
 3aa:	c9                   	leave
 3ab:	c3                   	ret
 3ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	56                   	push   %esi
 3b5:	8b 45 10             	mov    0x10(%ebp),%eax
 3b8:	8b 55 08             	mov    0x8(%ebp),%edx
 3bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3be:	85 c0                	test   %eax,%eax
 3c0:	7e 13                	jle    3d5 <memmove+0x25>
 3c2:	01 d0                	add    %edx,%eax
  dst = vdst;
 3c4:	89 d7                	mov    %edx,%edi
 3c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3cd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 3d0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 3d1:	39 f8                	cmp    %edi,%eax
 3d3:	75 fb                	jne    3d0 <memmove+0x20>
  return vdst;
}
 3d5:	5e                   	pop    %esi
 3d6:	89 d0                	mov    %edx,%eax
 3d8:	5f                   	pop    %edi
 3d9:	5d                   	pop    %ebp
 3da:	c3                   	ret

000003db <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3db:	b8 01 00 00 00       	mov    $0x1,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret

000003e3 <exit>:
SYSCALL(exit)
 3e3:	b8 02 00 00 00       	mov    $0x2,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret

000003eb <wait>:
SYSCALL(wait)
 3eb:	b8 03 00 00 00       	mov    $0x3,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret

000003f3 <pipe>:
SYSCALL(pipe)
 3f3:	b8 04 00 00 00       	mov    $0x4,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret

000003fb <read>:
SYSCALL(read)
 3fb:	b8 05 00 00 00       	mov    $0x5,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret

00000403 <write>:
SYSCALL(write)
 403:	b8 10 00 00 00       	mov    $0x10,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret

0000040b <close>:
SYSCALL(close)
 40b:	b8 15 00 00 00       	mov    $0x15,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret

00000413 <kill>:
SYSCALL(kill)
 413:	b8 06 00 00 00       	mov    $0x6,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret

0000041b <exec>:
SYSCALL(exec)
 41b:	b8 07 00 00 00       	mov    $0x7,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret

00000423 <open>:
SYSCALL(open)
 423:	b8 0f 00 00 00       	mov    $0xf,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret

0000042b <mknod>:
SYSCALL(mknod)
 42b:	b8 11 00 00 00       	mov    $0x11,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret

00000433 <unlink>:
SYSCALL(unlink)
 433:	b8 12 00 00 00       	mov    $0x12,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret

0000043b <fstat>:
SYSCALL(fstat)
 43b:	b8 08 00 00 00       	mov    $0x8,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret

00000443 <link>:
SYSCALL(link)
 443:	b8 13 00 00 00       	mov    $0x13,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret

0000044b <mkdir>:
SYSCALL(mkdir)
 44b:	b8 14 00 00 00       	mov    $0x14,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret

00000453 <chdir>:
SYSCALL(chdir)
 453:	b8 09 00 00 00       	mov    $0x9,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret

0000045b <dup>:
SYSCALL(dup)
 45b:	b8 0a 00 00 00       	mov    $0xa,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret

00000463 <getpid>:
SYSCALL(getpid)
 463:	b8 0b 00 00 00       	mov    $0xb,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret

0000046b <sbrk>:
SYSCALL(sbrk)
 46b:	b8 0c 00 00 00       	mov    $0xc,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret

00000473 <sleep>:
SYSCALL(sleep)
 473:	b8 0d 00 00 00       	mov    $0xd,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret

0000047b <uptime>:
SYSCALL(uptime)
 47b:	b8 0e 00 00 00       	mov    $0xe,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret

00000483 <getreadcount>:
SYSCALL(getreadcount) 
 483:	b8 16 00 00 00       	mov    $0x16,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret

0000048b <settickets>:
SYSCALL(settickets)
 48b:	b8 17 00 00 00       	mov    $0x17,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret

00000493 <getpinfo>:
 493:	b8 18 00 00 00       	mov    $0x18,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret
 49b:	66 90                	xchg   %ax,%ax
 49d:	66 90                	xchg   %ax,%ax
 49f:	90                   	nop

000004a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
 4a4:	56                   	push   %esi
 4a5:	53                   	push   %ebx
 4a6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4a8:	89 d1                	mov    %edx,%ecx
{
 4aa:	83 ec 3c             	sub    $0x3c,%esp
 4ad:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 4b0:	85 d2                	test   %edx,%edx
 4b2:	0f 89 80 00 00 00    	jns    538 <printint+0x98>
 4b8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4bc:	74 7a                	je     538 <printint+0x98>
    x = -xx;
 4be:	f7 d9                	neg    %ecx
    neg = 1;
 4c0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 4c5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 4c8:	31 f6                	xor    %esi,%esi
 4ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 4d0:	89 c8                	mov    %ecx,%eax
 4d2:	31 d2                	xor    %edx,%edx
 4d4:	89 f7                	mov    %esi,%edi
 4d6:	f7 f3                	div    %ebx
 4d8:	8d 76 01             	lea    0x1(%esi),%esi
 4db:	0f b6 92 40 09 00 00 	movzbl 0x940(%edx),%edx
 4e2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 4e6:	89 ca                	mov    %ecx,%edx
 4e8:	89 c1                	mov    %eax,%ecx
 4ea:	39 da                	cmp    %ebx,%edx
 4ec:	73 e2                	jae    4d0 <printint+0x30>
  if(neg)
 4ee:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 4f1:	85 c0                	test   %eax,%eax
 4f3:	74 07                	je     4fc <printint+0x5c>
    buf[i++] = '-';
 4f5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
    buf[i++] = digits[x % base];
 4fa:	89 f7                	mov    %esi,%edi
 4fc:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 4ff:	8b 75 c0             	mov    -0x40(%ebp),%esi
 502:	01 df                	add    %ebx,%edi
 504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  while(--i >= 0)
    putc(fd, buf[i]);
 508:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 50b:	83 ec 04             	sub    $0x4,%esp
 50e:	88 45 d7             	mov    %al,-0x29(%ebp)
 511:	8d 45 d7             	lea    -0x29(%ebp),%eax
 514:	6a 01                	push   $0x1
 516:	50                   	push   %eax
 517:	56                   	push   %esi
 518:	e8 e6 fe ff ff       	call   403 <write>
  while(--i >= 0)
 51d:	89 f8                	mov    %edi,%eax
 51f:	83 c4 10             	add    $0x10,%esp
 522:	83 ef 01             	sub    $0x1,%edi
 525:	39 d8                	cmp    %ebx,%eax
 527:	75 df                	jne    508 <printint+0x68>
}
 529:	8d 65 f4             	lea    -0xc(%ebp),%esp
 52c:	5b                   	pop    %ebx
 52d:	5e                   	pop    %esi
 52e:	5f                   	pop    %edi
 52f:	5d                   	pop    %ebp
 530:	c3                   	ret
 531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 538:	31 c0                	xor    %eax,%eax
 53a:	eb 89                	jmp    4c5 <printint+0x25>
 53c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000540 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	57                   	push   %edi
 544:	56                   	push   %esi
 545:	53                   	push   %ebx
 546:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 549:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 54c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 54f:	0f b6 1e             	movzbl (%esi),%ebx
 552:	83 c6 01             	add    $0x1,%esi
 555:	84 db                	test   %bl,%bl
 557:	74 67                	je     5c0 <printf+0x80>
 559:	8d 4d 10             	lea    0x10(%ebp),%ecx
 55c:	31 d2                	xor    %edx,%edx
 55e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 561:	eb 34                	jmp    597 <printf+0x57>
 563:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 567:	90                   	nop
 568:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 56b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 570:	83 f8 25             	cmp    $0x25,%eax
 573:	74 18                	je     58d <printf+0x4d>
  write(fd, &c, 1);
 575:	83 ec 04             	sub    $0x4,%esp
 578:	8d 45 e7             	lea    -0x19(%ebp),%eax
 57b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 57e:	6a 01                	push   $0x1
 580:	50                   	push   %eax
 581:	57                   	push   %edi
 582:	e8 7c fe ff ff       	call   403 <write>
 587:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 58a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 58d:	0f b6 1e             	movzbl (%esi),%ebx
 590:	83 c6 01             	add    $0x1,%esi
 593:	84 db                	test   %bl,%bl
 595:	74 29                	je     5c0 <printf+0x80>
    c = fmt[i] & 0xff;
 597:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 59a:	85 d2                	test   %edx,%edx
 59c:	74 ca                	je     568 <printf+0x28>
      }
    } else if(state == '%'){
 59e:	83 fa 25             	cmp    $0x25,%edx
 5a1:	75 ea                	jne    58d <printf+0x4d>
      if(c == 'd'){
 5a3:	83 f8 25             	cmp    $0x25,%eax
 5a6:	0f 84 24 01 00 00    	je     6d0 <printf+0x190>
 5ac:	83 e8 63             	sub    $0x63,%eax
 5af:	83 f8 15             	cmp    $0x15,%eax
 5b2:	77 1c                	ja     5d0 <printf+0x90>
 5b4:	ff 24 85 e8 08 00 00 	jmp    *0x8e8(,%eax,4)
 5bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5bf:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5c3:	5b                   	pop    %ebx
 5c4:	5e                   	pop    %esi
 5c5:	5f                   	pop    %edi
 5c6:	5d                   	pop    %ebp
 5c7:	c3                   	ret
 5c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5cf:	90                   	nop
  write(fd, &c, 1);
 5d0:	83 ec 04             	sub    $0x4,%esp
 5d3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 5d6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5da:	6a 01                	push   $0x1
 5dc:	52                   	push   %edx
 5dd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 5e0:	57                   	push   %edi
 5e1:	e8 1d fe ff ff       	call   403 <write>
 5e6:	83 c4 0c             	add    $0xc,%esp
 5e9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5ec:	6a 01                	push   $0x1
 5ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 5f1:	52                   	push   %edx
 5f2:	57                   	push   %edi
 5f3:	e8 0b fe ff ff       	call   403 <write>
        putc(fd, c);
 5f8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5fb:	31 d2                	xor    %edx,%edx
 5fd:	eb 8e                	jmp    58d <printf+0x4d>
 5ff:	90                   	nop
        printint(fd, *ap, 16, 0);
 600:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 603:	83 ec 0c             	sub    $0xc,%esp
 606:	b9 10 00 00 00       	mov    $0x10,%ecx
 60b:	8b 13                	mov    (%ebx),%edx
 60d:	6a 00                	push   $0x0
 60f:	89 f8                	mov    %edi,%eax
        ap++;
 611:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 614:	e8 87 fe ff ff       	call   4a0 <printint>
        ap++;
 619:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 61c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 61f:	31 d2                	xor    %edx,%edx
 621:	e9 67 ff ff ff       	jmp    58d <printf+0x4d>
 626:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 62d:	8d 76 00             	lea    0x0(%esi),%esi
        s = (char*)*ap;
 630:	8b 45 d0             	mov    -0x30(%ebp),%eax
 633:	8b 18                	mov    (%eax),%ebx
        ap++;
 635:	83 c0 04             	add    $0x4,%eax
 638:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 63b:	85 db                	test   %ebx,%ebx
 63d:	0f 84 9d 00 00 00    	je     6e0 <printf+0x1a0>
        while(*s != 0){
 643:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 646:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 648:	84 c0                	test   %al,%al
 64a:	0f 84 3d ff ff ff    	je     58d <printf+0x4d>
 650:	8d 55 e7             	lea    -0x19(%ebp),%edx
 653:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 656:	89 de                	mov    %ebx,%esi
 658:	89 d3                	mov    %edx,%ebx
 65a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 660:	83 ec 04             	sub    $0x4,%esp
 663:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 666:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 669:	6a 01                	push   $0x1
 66b:	53                   	push   %ebx
 66c:	57                   	push   %edi
 66d:	e8 91 fd ff ff       	call   403 <write>
        while(*s != 0){
 672:	0f b6 06             	movzbl (%esi),%eax
 675:	83 c4 10             	add    $0x10,%esp
 678:	84 c0                	test   %al,%al
 67a:	75 e4                	jne    660 <printf+0x120>
      state = 0;
 67c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 67f:	31 d2                	xor    %edx,%edx
 681:	e9 07 ff ff ff       	jmp    58d <printf+0x4d>
 686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 68d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 690:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 693:	83 ec 0c             	sub    $0xc,%esp
 696:	b9 0a 00 00 00       	mov    $0xa,%ecx
 69b:	8b 13                	mov    (%ebx),%edx
 69d:	6a 01                	push   $0x1
 69f:	e9 6b ff ff ff       	jmp    60f <printf+0xcf>
 6a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 6a8:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 6ab:	83 ec 04             	sub    $0x4,%esp
 6ae:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 6b1:	8b 03                	mov    (%ebx),%eax
        ap++;
 6b3:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 6b6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6b9:	6a 01                	push   $0x1
 6bb:	52                   	push   %edx
 6bc:	57                   	push   %edi
 6bd:	e8 41 fd ff ff       	call   403 <write>
        ap++;
 6c2:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 6c5:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6c8:	31 d2                	xor    %edx,%edx
 6ca:	e9 be fe ff ff       	jmp    58d <printf+0x4d>
 6cf:	90                   	nop
  write(fd, &c, 1);
 6d0:	83 ec 04             	sub    $0x4,%esp
 6d3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6d6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 6d9:	6a 01                	push   $0x1
 6db:	e9 11 ff ff ff       	jmp    5f1 <printf+0xb1>
 6e0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 6e5:	bb e0 08 00 00       	mov    $0x8e0,%ebx
 6ea:	e9 61 ff ff ff       	jmp    650 <printf+0x110>
 6ef:	90                   	nop

000006f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f1:	a1 e4 0b 00 00       	mov    0xbe4,%eax
{
 6f6:	89 e5                	mov    %esp,%ebp
 6f8:	57                   	push   %edi
 6f9:	56                   	push   %esi
 6fa:	53                   	push   %ebx
 6fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 6fe:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 708:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70a:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70c:	39 ca                	cmp    %ecx,%edx
 70e:	73 30                	jae    740 <free+0x50>
 710:	39 c1                	cmp    %eax,%ecx
 712:	72 04                	jb     718 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 714:	39 c2                	cmp    %eax,%edx
 716:	72 f0                	jb     708 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 718:	8b 73 fc             	mov    -0x4(%ebx),%esi
 71b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 71e:	39 f8                	cmp    %edi,%eax
 720:	74 2e                	je     750 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 722:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 725:	8b 42 04             	mov    0x4(%edx),%eax
 728:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 72b:	39 f1                	cmp    %esi,%ecx
 72d:	74 38                	je     767 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 72f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 731:	5b                   	pop    %ebx
  freep = p;
 732:	89 15 e4 0b 00 00    	mov    %edx,0xbe4
}
 738:	5e                   	pop    %esi
 739:	5f                   	pop    %edi
 73a:	5d                   	pop    %ebp
 73b:	c3                   	ret
 73c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 740:	39 c1                	cmp    %eax,%ecx
 742:	72 d0                	jb     714 <free+0x24>
 744:	eb c2                	jmp    708 <free+0x18>
 746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 74d:	8d 76 00             	lea    0x0(%esi),%esi
    bp->s.size += p->s.ptr->s.size;
 750:	03 70 04             	add    0x4(%eax),%esi
 753:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 756:	8b 02                	mov    (%edx),%eax
 758:	8b 00                	mov    (%eax),%eax
 75a:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 75d:	8b 42 04             	mov    0x4(%edx),%eax
 760:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 763:	39 f1                	cmp    %esi,%ecx
 765:	75 c8                	jne    72f <free+0x3f>
    p->s.size += bp->s.size;
 767:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 76a:	89 15 e4 0b 00 00    	mov    %edx,0xbe4
    p->s.size += bp->s.size;
 770:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 773:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 776:	89 0a                	mov    %ecx,(%edx)
}
 778:	5b                   	pop    %ebx
 779:	5e                   	pop    %esi
 77a:	5f                   	pop    %edi
 77b:	5d                   	pop    %ebp
 77c:	c3                   	ret
 77d:	8d 76 00             	lea    0x0(%esi),%esi

00000780 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 780:	55                   	push   %ebp
 781:	89 e5                	mov    %esp,%ebp
 783:	57                   	push   %edi
 784:	56                   	push   %esi
 785:	53                   	push   %ebx
 786:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 789:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 78c:	8b 15 e4 0b 00 00    	mov    0xbe4,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 792:	8d 78 07             	lea    0x7(%eax),%edi
 795:	c1 ef 03             	shr    $0x3,%edi
 798:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 79b:	85 d2                	test   %edx,%edx
 79d:	0f 84 8d 00 00 00    	je     830 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7a5:	8b 48 04             	mov    0x4(%eax),%ecx
 7a8:	39 f9                	cmp    %edi,%ecx
 7aa:	73 64                	jae    810 <malloc+0x90>
  if(nu < 4096)
 7ac:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7b1:	39 df                	cmp    %ebx,%edi
 7b3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 7b6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 7bd:	eb 0a                	jmp    7c9 <malloc+0x49>
 7bf:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7c2:	8b 48 04             	mov    0x4(%eax),%ecx
 7c5:	39 f9                	cmp    %edi,%ecx
 7c7:	73 47                	jae    810 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7c9:	89 c2                	mov    %eax,%edx
 7cb:	39 05 e4 0b 00 00    	cmp    %eax,0xbe4
 7d1:	75 ed                	jne    7c0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 7d3:	83 ec 0c             	sub    $0xc,%esp
 7d6:	56                   	push   %esi
 7d7:	e8 8f fc ff ff       	call   46b <sbrk>
  if(p == (char*)-1)
 7dc:	83 c4 10             	add    $0x10,%esp
 7df:	83 f8 ff             	cmp    $0xffffffff,%eax
 7e2:	74 1c                	je     800 <malloc+0x80>
  hp->s.size = nu;
 7e4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7e7:	83 ec 0c             	sub    $0xc,%esp
 7ea:	83 c0 08             	add    $0x8,%eax
 7ed:	50                   	push   %eax
 7ee:	e8 fd fe ff ff       	call   6f0 <free>
  return freep;
 7f3:	8b 15 e4 0b 00 00    	mov    0xbe4,%edx
      if((p = morecore(nunits)) == 0)
 7f9:	83 c4 10             	add    $0x10,%esp
 7fc:	85 d2                	test   %edx,%edx
 7fe:	75 c0                	jne    7c0 <malloc+0x40>
        return 0;
  }
}
 800:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 803:	31 c0                	xor    %eax,%eax
}
 805:	5b                   	pop    %ebx
 806:	5e                   	pop    %esi
 807:	5f                   	pop    %edi
 808:	5d                   	pop    %ebp
 809:	c3                   	ret
 80a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 810:	39 cf                	cmp    %ecx,%edi
 812:	74 4c                	je     860 <malloc+0xe0>
        p->s.size -= nunits;
 814:	29 f9                	sub    %edi,%ecx
 816:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 819:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 81c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 81f:	89 15 e4 0b 00 00    	mov    %edx,0xbe4
}
 825:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 828:	83 c0 08             	add    $0x8,%eax
}
 82b:	5b                   	pop    %ebx
 82c:	5e                   	pop    %esi
 82d:	5f                   	pop    %edi
 82e:	5d                   	pop    %ebp
 82f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 830:	c7 05 e4 0b 00 00 e8 	movl   $0xbe8,0xbe4
 837:	0b 00 00 
    base.s.size = 0;
 83a:	b8 e8 0b 00 00       	mov    $0xbe8,%eax
    base.s.ptr = freep = prevp = &base;
 83f:	c7 05 e8 0b 00 00 e8 	movl   $0xbe8,0xbe8
 846:	0b 00 00 
    base.s.size = 0;
 849:	c7 05 ec 0b 00 00 00 	movl   $0x0,0xbec
 850:	00 00 00 
    if(p->s.size >= nunits){
 853:	e9 54 ff ff ff       	jmp    7ac <malloc+0x2c>
 858:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 85f:	90                   	nop
        prevp->s.ptr = p->s.ptr;
 860:	8b 08                	mov    (%eax),%ecx
 862:	89 0a                	mov    %ecx,(%edx)
 864:	eb b9                	jmp    81f <malloc+0x9f>
