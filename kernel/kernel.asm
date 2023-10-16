
kernel/kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 00 63 11 80       	mov    $0x80116300,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c0 30 10 80       	mov    $0x801030c0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 76 10 80       	push   $0x80107600
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 25 45 00 00       	call   80104580 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 76 10 80       	push   $0x80107607
80100097:	50                   	push   %eax
80100098:	e8 b3 43 00 00       	call   80104450 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 77 46 00 00       	call   80104760 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 99 45 00 00       	call   80104700 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 43 00 00       	call   80104490 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 bf 21 00 00       	call   80102350 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 0e 76 10 80       	push   $0x8010760e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 6d 43 00 00       	call   80104530 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 77 21 00 00       	jmp    80102350 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 1f 76 10 80       	push   $0x8010761f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 43 00 00       	call   80104530 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 dc 42 00 00       	call   801044f0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 40 45 00 00       	call   80104760 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 92 44 00 00       	jmp    80104700 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 26 76 10 80       	push   $0x80107626
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 17 16 00 00       	call   801018b0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 bb 44 00 00       	call   80104760 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 4e 3e 00 00       	call   80104120 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 39 37 00 00       	call   80103a20 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 05 44 00 00       	call   80104700 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 cc 14 00 00       	call   801017d0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 af 43 00 00       	call   80104700 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 76 14 00 00       	call   801017d0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 c2 25 00 00       	call   80102960 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 2d 76 10 80       	push   $0x8010762d
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 83 7f 10 80 	movl   $0x80107f83,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 d3 41 00 00       	call   801045a0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 41 76 10 80       	push   $0x80107641
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 2c 5b 00 00       	call   80105f50 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801004df:	90                   	nop
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 61 5a 00 00       	call   80105f50 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 55 5a 00 00       	call   80105f50 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 49 5a 00 00       	call   80105f50 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 6a 43 00 00       	call   801048d0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 c5 42 00 00       	call   80104840 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058d:	8d 76 00             	lea    0x0(%esi),%esi
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 45 76 10 80       	push   $0x80107645
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 ec 12 00 00       	call   801018b0 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005cb:	e8 90 41 00 00       	call   80104760 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 df                	cmp    %ebx,%edi
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 20 ef 10 80       	push   $0x8010ef20
80100604:	e8 f7 40 00 00       	call   80104700 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 be 11 00 00       	call   801017d0 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	89 c6                	mov    %eax,%esi
80100627:	53                   	push   %ebx
80100628:	89 d3                	mov    %edx,%ebx
8010062a:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062d:	85 c9                	test   %ecx,%ecx
8010062f:	74 04                	je     80100635 <printint+0x15>
80100631:	85 c0                	test   %eax,%eax
80100633:	78 63                	js     80100698 <printint+0x78>
    x = xx;
80100635:	89 f1                	mov    %esi,%ecx
80100637:	31 c0                	xor    %eax,%eax
  i = 0;
80100639:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010063c:	31 f6                	xor    %esi,%esi
8010063e:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 70 76 10 80 	movzbl -0x7fef8990(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100661:	85 c0                	test   %eax,%eax
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
    buf[i++] = digits[x % base];
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 0c                	je     801006a0 <printint+0x80>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
80100698:	89 c8                	mov    %ecx,%eax
    x = -xx;
8010069a:	89 f1                	mov    %esi,%ecx
8010069c:	f7 d9                	neg    %ecx
8010069e:	eb 99                	jmp    80100639 <printint+0x19>
}
801006a0:	83 c4 2c             	add    $0x2c,%esp
801006a3:	5b                   	pop    %ebx
801006a4:	5e                   	pop    %esi
801006a5:	5f                   	pop    %edi
801006a6:	5d                   	pop    %ebp
801006a7:	c3                   	ret
801006a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 54 ef 10 80    	mov    0x8010ef54,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 36 01 00 00    	jne    80100800 <cprintf+0x150>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 e0 01 00 00    	je     801008b2 <cprintf+0x202>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 6b                	je     80100744 <cprintf+0x94>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	0f 85 dc 00 00 00    	jne    801007c8 <cprintf+0x118>
    c = fmt[++i] & 0xff;
801006ec:	83 c3 01             	add    $0x1,%ebx
801006ef:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006f3:	85 c9                	test   %ecx,%ecx
801006f5:	74 42                	je     80100739 <cprintf+0x89>
    switch(c){
801006f7:	83 f9 70             	cmp    $0x70,%ecx
801006fa:	0f 84 99 00 00 00    	je     80100799 <cprintf+0xe9>
80100700:	7f 4e                	jg     80100750 <cprintf+0xa0>
80100702:	83 f9 25             	cmp    $0x25,%ecx
80100705:	0f 84 cd 00 00 00    	je     801007d8 <cprintf+0x128>
8010070b:	83 f9 64             	cmp    $0x64,%ecx
8010070e:	0f 85 24 01 00 00    	jne    80100838 <cprintf+0x188>
      printint(*argp++, 10, 1);
80100714:	8d 47 04             	lea    0x4(%edi),%eax
80100717:	b9 01 00 00 00       	mov    $0x1,%ecx
8010071c:	ba 0a 00 00 00       	mov    $0xa,%edx
80100721:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100724:	8b 07                	mov    (%edi),%eax
80100726:	e8 f5 fe ff ff       	call   80100620 <printint>
8010072b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010072e:	83 c3 01             	add    $0x1,%ebx
80100731:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100735:	85 c0                	test   %eax,%eax
80100737:	75 aa                	jne    801006e3 <cprintf+0x33>
80100739:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
8010073c:	85 ff                	test   %edi,%edi
8010073e:	0f 85 df 00 00 00    	jne    80100823 <cprintf+0x173>
}
80100744:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100747:	5b                   	pop    %ebx
80100748:	5e                   	pop    %esi
80100749:	5f                   	pop    %edi
8010074a:	5d                   	pop    %ebp
8010074b:	c3                   	ret
8010074c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100750:	83 f9 73             	cmp    $0x73,%ecx
80100753:	75 3b                	jne    80100790 <cprintf+0xe0>
      if((s = (char*)*argp++) == 0)
80100755:	8b 17                	mov    (%edi),%edx
80100757:	8d 47 04             	lea    0x4(%edi),%eax
8010075a:	85 d2                	test   %edx,%edx
8010075c:	0f 85 0e 01 00 00    	jne    80100870 <cprintf+0x1c0>
80100762:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
80100767:	bf 58 76 10 80       	mov    $0x80107658,%edi
8010076c:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010076f:	89 fb                	mov    %edi,%ebx
80100771:	89 f7                	mov    %esi,%edi
80100773:	89 c6                	mov    %eax,%esi
80100775:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100778:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010077e:	85 d2                	test   %edx,%edx
80100780:	0f 84 fe 00 00 00    	je     80100884 <cprintf+0x1d4>
80100786:	fa                   	cli
    for(;;)
80100787:	eb fe                	jmp    80100787 <cprintf+0xd7>
80100789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100790:	83 f9 78             	cmp    $0x78,%ecx
80100793:	0f 85 9f 00 00 00    	jne    80100838 <cprintf+0x188>
      printint(*argp++, 16, 0);
80100799:	8d 47 04             	lea    0x4(%edi),%eax
8010079c:	31 c9                	xor    %ecx,%ecx
8010079e:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007a3:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
801007a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007a9:	8b 07                	mov    (%edi),%eax
801007ab:	e8 70 fe ff ff       	call   80100620 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b0:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
801007b4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b7:	85 c0                	test   %eax,%eax
801007b9:	0f 85 24 ff ff ff    	jne    801006e3 <cprintf+0x33>
801007bf:	e9 75 ff ff ff       	jmp    80100739 <cprintf+0x89>
801007c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007c8:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007ce:	85 c9                	test   %ecx,%ecx
801007d0:	74 15                	je     801007e7 <cprintf+0x137>
801007d2:	fa                   	cli
    for(;;)
801007d3:	eb fe                	jmp    801007d3 <cprintf+0x123>
801007d5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007d8:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007de:	85 c9                	test   %ecx,%ecx
801007e0:	75 7e                	jne    80100860 <cprintf+0x1b0>
801007e2:	b8 25 00 00 00       	mov    $0x25,%eax
801007e7:	e8 14 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007ec:	83 c3 01             	add    $0x1,%ebx
801007ef:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007f3:	85 c0                	test   %eax,%eax
801007f5:	0f 85 e8 fe ff ff    	jne    801006e3 <cprintf+0x33>
801007fb:	e9 39 ff ff ff       	jmp    80100739 <cprintf+0x89>
    acquire(&cons.lock);
80100800:	83 ec 0c             	sub    $0xc,%esp
80100803:	68 20 ef 10 80       	push   $0x8010ef20
80100808:	e8 53 3f 00 00       	call   80104760 <acquire>
  if (fmt == 0)
8010080d:	83 c4 10             	add    $0x10,%esp
80100810:	85 f6                	test   %esi,%esi
80100812:	0f 84 9a 00 00 00    	je     801008b2 <cprintf+0x202>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100818:	0f b6 06             	movzbl (%esi),%eax
8010081b:	85 c0                	test   %eax,%eax
8010081d:	0f 85 b6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
80100823:	83 ec 0c             	sub    $0xc,%esp
80100826:	68 20 ef 10 80       	push   $0x8010ef20
8010082b:	e8 d0 3e 00 00       	call   80104700 <release>
80100830:	83 c4 10             	add    $0x10,%esp
80100833:	e9 0c ff ff ff       	jmp    80100744 <cprintf+0x94>
  if(panicked){
80100838:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010083e:	85 d2                	test   %edx,%edx
80100840:	75 26                	jne    80100868 <cprintf+0x1b8>
80100842:	b8 25 00 00 00       	mov    $0x25,%eax
80100847:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010084a:	e8 b1 fb ff ff       	call   80100400 <consputc.part.0>
8010084f:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100854:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100857:	85 c0                	test   %eax,%eax
80100859:	74 4b                	je     801008a6 <cprintf+0x1f6>
8010085b:	fa                   	cli
    for(;;)
8010085c:	eb fe                	jmp    8010085c <cprintf+0x1ac>
8010085e:	66 90                	xchg   %ax,%ax
80100860:	fa                   	cli
80100861:	eb fe                	jmp    80100861 <cprintf+0x1b1>
80100863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100867:	90                   	nop
80100868:	fa                   	cli
80100869:	eb fe                	jmp    80100869 <cprintf+0x1b9>
8010086b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010086f:	90                   	nop
      for(; *s; s++)
80100870:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100873:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100875:	84 c9                	test   %cl,%cl
80100877:	0f 85 ef fe ff ff    	jne    8010076c <cprintf+0xbc>
      if((s = (char*)*argp++) == 0)
8010087d:	89 c7                	mov    %eax,%edi
8010087f:	e9 aa fe ff ff       	jmp    8010072e <cprintf+0x7e>
80100884:	e8 77 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100889:	0f be 43 01          	movsbl 0x1(%ebx),%eax
8010088d:	83 c3 01             	add    $0x1,%ebx
80100890:	84 c0                	test   %al,%al
80100892:	0f 85 e0 fe ff ff    	jne    80100778 <cprintf+0xc8>
      if((s = (char*)*argp++) == 0)
80100898:	89 f0                	mov    %esi,%eax
8010089a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010089d:	89 fe                	mov    %edi,%esi
8010089f:	89 c7                	mov    %eax,%edi
801008a1:	e9 88 fe ff ff       	jmp    8010072e <cprintf+0x7e>
801008a6:	89 c8                	mov    %ecx,%eax
801008a8:	e8 53 fb ff ff       	call   80100400 <consputc.part.0>
801008ad:	e9 7c fe ff ff       	jmp    8010072e <cprintf+0x7e>
    panic("null fmt");
801008b2:	83 ec 0c             	sub    $0xc,%esp
801008b5:	68 5f 76 10 80       	push   $0x8010765f
801008ba:	e8 c1 fa ff ff       	call   80100380 <panic>
801008bf:	90                   	nop

801008c0 <consoleintr>:
{
801008c0:	55                   	push   %ebp
801008c1:	89 e5                	mov    %esp,%ebp
801008c3:	57                   	push   %edi
801008c4:	56                   	push   %esi
  int c, doprocdump = 0;
801008c5:	31 f6                	xor    %esi,%esi
{
801008c7:	53                   	push   %ebx
801008c8:	83 ec 18             	sub    $0x18,%esp
801008cb:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
801008ce:	68 20 ef 10 80       	push   $0x8010ef20
801008d3:	e8 88 3e 00 00       	call   80104760 <acquire>
  while((c = getc()) >= 0){
801008d8:	83 c4 10             	add    $0x10,%esp
801008db:	eb 1a                	jmp    801008f7 <consoleintr+0x37>
801008dd:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008e0:	83 fb 08             	cmp    $0x8,%ebx
801008e3:	0f 84 d7 00 00 00    	je     801009c0 <consoleintr+0x100>
801008e9:	83 fb 10             	cmp    $0x10,%ebx
801008ec:	0f 85 2d 01 00 00    	jne    80100a1f <consoleintr+0x15f>
801008f2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008f7:	ff d7                	call   *%edi
801008f9:	89 c3                	mov    %eax,%ebx
801008fb:	85 c0                	test   %eax,%eax
801008fd:	0f 88 e5 00 00 00    	js     801009e8 <consoleintr+0x128>
    switch(c){
80100903:	83 fb 15             	cmp    $0x15,%ebx
80100906:	74 7a                	je     80100982 <consoleintr+0xc2>
80100908:	7e d6                	jle    801008e0 <consoleintr+0x20>
8010090a:	83 fb 7f             	cmp    $0x7f,%ebx
8010090d:	0f 84 ad 00 00 00    	je     801009c0 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100913:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100918:	89 c2                	mov    %eax,%edx
8010091a:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100920:	83 fa 7f             	cmp    $0x7f,%edx
80100923:	77 d2                	ja     801008f7 <consoleintr+0x37>
  if(panicked){
80100925:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
8010092b:	8d 48 01             	lea    0x1(%eax),%ecx
8010092e:	83 e0 7f             	and    $0x7f,%eax
80100931:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
80100937:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
8010093d:	85 d2                	test   %edx,%edx
8010093f:	0f 85 47 01 00 00    	jne    80100a8c <consoleintr+0x1cc>
80100945:	89 d8                	mov    %ebx,%eax
80100947:	e8 b4 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010094c:	83 fb 0a             	cmp    $0xa,%ebx
8010094f:	0f 84 18 01 00 00    	je     80100a6d <consoleintr+0x1ad>
80100955:	83 fb 04             	cmp    $0x4,%ebx
80100958:	0f 84 0f 01 00 00    	je     80100a6d <consoleintr+0x1ad>
8010095e:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
80100963:	83 e8 80             	sub    $0xffffff80,%eax
80100966:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
8010096c:	75 89                	jne    801008f7 <consoleintr+0x37>
8010096e:	e9 ff 00 00 00       	jmp    80100a72 <consoleintr+0x1b2>
80100973:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100977:	90                   	nop
80100978:	b8 00 01 00 00       	mov    $0x100,%eax
8010097d:	e8 7e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
80100982:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100987:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
8010098d:	0f 84 64 ff ff ff    	je     801008f7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100993:	83 e8 01             	sub    $0x1,%eax
80100996:	89 c2                	mov    %eax,%edx
80100998:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
8010099b:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
801009a2:	0f 84 4f ff ff ff    	je     801008f7 <consoleintr+0x37>
  if(panicked){
801009a8:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
801009ae:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
801009b3:	85 d2                	test   %edx,%edx
801009b5:	74 c1                	je     80100978 <consoleintr+0xb8>
801009b7:	fa                   	cli
    for(;;)
801009b8:	eb fe                	jmp    801009b8 <consoleintr+0xf8>
801009ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(input.e != input.w){
801009c0:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009c5:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801009cb:	0f 84 26 ff ff ff    	je     801008f7 <consoleintr+0x37>
        input.e--;
801009d1:	83 e8 01             	sub    $0x1,%eax
801009d4:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
801009d9:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
801009de:	85 c0                	test   %eax,%eax
801009e0:	74 22                	je     80100a04 <consoleintr+0x144>
801009e2:	fa                   	cli
    for(;;)
801009e3:	eb fe                	jmp    801009e3 <consoleintr+0x123>
801009e5:	8d 76 00             	lea    0x0(%esi),%esi
  release(&cons.lock);
801009e8:	83 ec 0c             	sub    $0xc,%esp
801009eb:	68 20 ef 10 80       	push   $0x8010ef20
801009f0:	e8 0b 3d 00 00       	call   80104700 <release>
  if(doprocdump) {
801009f5:	83 c4 10             	add    $0x10,%esp
801009f8:	85 f6                	test   %esi,%esi
801009fa:	75 17                	jne    80100a13 <consoleintr+0x153>
}
801009fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009ff:	5b                   	pop    %ebx
80100a00:	5e                   	pop    %esi
80100a01:	5f                   	pop    %edi
80100a02:	5d                   	pop    %ebp
80100a03:	c3                   	ret
80100a04:	b8 00 01 00 00       	mov    $0x100,%eax
80100a09:	e8 f2 f9 ff ff       	call   80100400 <consputc.part.0>
80100a0e:	e9 e4 fe ff ff       	jmp    801008f7 <consoleintr+0x37>
80100a13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a16:	5b                   	pop    %ebx
80100a17:	5e                   	pop    %esi
80100a18:	5f                   	pop    %edi
80100a19:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a1a:	e9 a1 38 00 00       	jmp    801042c0 <procdump>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100a1f:	85 db                	test   %ebx,%ebx
80100a21:	0f 84 d0 fe ff ff    	je     801008f7 <consoleintr+0x37>
80100a27:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a2c:	89 c2                	mov    %eax,%edx
80100a2e:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100a34:	83 fa 7f             	cmp    $0x7f,%edx
80100a37:	0f 87 ba fe ff ff    	ja     801008f7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a3d:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
80100a40:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
80100a46:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100a49:	83 fb 0d             	cmp    $0xd,%ebx
80100a4c:	0f 85 df fe ff ff    	jne    80100931 <consoleintr+0x71>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a52:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
80100a58:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100a5f:	85 d2                	test   %edx,%edx
80100a61:	75 29                	jne    80100a8c <consoleintr+0x1cc>
80100a63:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a68:	e8 93 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a6d:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100a72:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a75:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100a7a:	68 00 ef 10 80       	push   $0x8010ef00
80100a7f:	e8 5c 37 00 00       	call   801041e0 <wakeup>
80100a84:	83 c4 10             	add    $0x10,%esp
80100a87:	e9 6b fe ff ff       	jmp    801008f7 <consoleintr+0x37>
80100a8c:	fa                   	cli
    for(;;)
80100a8d:	eb fe                	jmp    80100a8d <consoleintr+0x1cd>
80100a8f:	90                   	nop

80100a90 <consoleinit>:

void
consoleinit(void)
{
80100a90:	55                   	push   %ebp
80100a91:	89 e5                	mov    %esp,%ebp
80100a93:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a96:	68 68 76 10 80       	push   $0x80107668
80100a9b:	68 20 ef 10 80       	push   $0x8010ef20
80100aa0:	e8 db 3a 00 00       	call   80104580 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100aa5:	c7 05 0c f9 10 80 b0 	movl   $0x801005b0,0x8010f90c
80100aac:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100aaf:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100ab6:	02 10 80 
  cons.locking = 1;
80100ab9:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100ac0:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100ac3:	58                   	pop    %eax
80100ac4:	5a                   	pop    %edx
80100ac5:	6a 00                	push   $0x0
80100ac7:	6a 01                	push   $0x1
80100ac9:	e8 12 1a 00 00       	call   801024e0 <ioapicenable>
}
80100ace:	83 c4 10             	add    $0x10,%esp
80100ad1:	c9                   	leave
80100ad2:	c3                   	ret
80100ad3:	66 90                	xchg   %ax,%ax
80100ad5:	66 90                	xchg   %ax,%ax
80100ad7:	66 90                	xchg   %ax,%ax
80100ad9:	66 90                	xchg   %ax,%ax
80100adb:	66 90                	xchg   %ax,%ax
80100add:	66 90                	xchg   %ax,%ax
80100adf:	90                   	nop

80100ae0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ae0:	55                   	push   %ebp
80100ae1:	89 e5                	mov    %esp,%ebp
80100ae3:	57                   	push   %edi
80100ae4:	56                   	push   %esi
80100ae5:	53                   	push   %ebx
80100ae6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100aec:	e8 2f 2f 00 00       	call   80103a20 <myproc>
80100af1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100af7:	e8 d4 22 00 00       	call   80102dd0 <begin_op>

  if((ip = namei(path)) == 0){
80100afc:	83 ec 0c             	sub    $0xc,%esp
80100aff:	ff 75 08             	push   0x8(%ebp)
80100b02:	e8 f9 15 00 00       	call   80102100 <namei>
80100b07:	83 c4 10             	add    $0x10,%esp
80100b0a:	85 c0                	test   %eax,%eax
80100b0c:	0f 84 30 03 00 00    	je     80100e42 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b12:	83 ec 0c             	sub    $0xc,%esp
80100b15:	89 c7                	mov    %eax,%edi
80100b17:	50                   	push   %eax
80100b18:	e8 b3 0c 00 00       	call   801017d0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b1d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b23:	6a 34                	push   $0x34
80100b25:	6a 00                	push   $0x0
80100b27:	50                   	push   %eax
80100b28:	57                   	push   %edi
80100b29:	e8 b2 0f 00 00       	call   80101ae0 <readi>
80100b2e:	83 c4 20             	add    $0x20,%esp
80100b31:	83 f8 34             	cmp    $0x34,%eax
80100b34:	0f 85 01 01 00 00    	jne    80100c3b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b3a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b41:	45 4c 46 
80100b44:	0f 85 f1 00 00 00    	jne    80100c3b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b4a:	e8 71 65 00 00       	call   801070c0 <setupkvm>
80100b4f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b55:	85 c0                	test   %eax,%eax
80100b57:	0f 84 de 00 00 00    	je     80100c3b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b5d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b64:	00 
80100b65:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b6b:	0f 84 a1 02 00 00    	je     80100e12 <exec+0x332>
  sz = 0;
80100b71:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b78:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b7b:	31 db                	xor    %ebx,%ebx
80100b7d:	e9 8c 00 00 00       	jmp    80100c0e <exec+0x12e>
80100b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b88:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b8f:	75 6c                	jne    80100bfd <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100b91:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b97:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b9d:	0f 82 87 00 00 00    	jb     80100c2a <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ba3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ba9:	72 7f                	jb     80100c2a <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bab:	83 ec 04             	sub    $0x4,%esp
80100bae:	50                   	push   %eax
80100baf:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100bb5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bbb:	e8 30 63 00 00       	call   80106ef0 <allocuvm>
80100bc0:	83 c4 10             	add    $0x10,%esp
80100bc3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bc9:	85 c0                	test   %eax,%eax
80100bcb:	74 5d                	je     80100c2a <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100bcd:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bd3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bd8:	75 50                	jne    80100c2a <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bda:	83 ec 0c             	sub    $0xc,%esp
80100bdd:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100be3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100be9:	57                   	push   %edi
80100bea:	50                   	push   %eax
80100beb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bf1:	e8 2a 62 00 00       	call   80106e20 <loaduvm>
80100bf6:	83 c4 20             	add    $0x20,%esp
80100bf9:	85 c0                	test   %eax,%eax
80100bfb:	78 2d                	js     80100c2a <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bfd:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c04:	83 c3 01             	add    $0x1,%ebx
80100c07:	83 c6 20             	add    $0x20,%esi
80100c0a:	39 d8                	cmp    %ebx,%eax
80100c0c:	7e 52                	jle    80100c60 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c0e:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c14:	6a 20                	push   $0x20
80100c16:	56                   	push   %esi
80100c17:	50                   	push   %eax
80100c18:	57                   	push   %edi
80100c19:	e8 c2 0e 00 00       	call   80101ae0 <readi>
80100c1e:	83 c4 10             	add    $0x10,%esp
80100c21:	83 f8 20             	cmp    $0x20,%eax
80100c24:	0f 84 5e ff ff ff    	je     80100b88 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c2a:	83 ec 0c             	sub    $0xc,%esp
80100c2d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c33:	e8 08 64 00 00       	call   80107040 <freevm>
  if(ip){
80100c38:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c3b:	83 ec 0c             	sub    $0xc,%esp
80100c3e:	57                   	push   %edi
80100c3f:	e8 1c 0e 00 00       	call   80101a60 <iunlockput>
    end_op();
80100c44:	e8 f7 21 00 00       	call   80102e40 <end_op>
80100c49:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c54:	5b                   	pop    %ebx
80100c55:	5e                   	pop    %esi
80100c56:	5f                   	pop    %edi
80100c57:	5d                   	pop    %ebp
80100c58:	c3                   	ret
80100c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c60:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c66:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c6c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c72:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c78:	83 ec 0c             	sub    $0xc,%esp
80100c7b:	57                   	push   %edi
80100c7c:	e8 df 0d 00 00       	call   80101a60 <iunlockput>
  end_op();
80100c81:	e8 ba 21 00 00       	call   80102e40 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c86:	83 c4 0c             	add    $0xc,%esp
80100c89:	53                   	push   %ebx
80100c8a:	56                   	push   %esi
80100c8b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c91:	56                   	push   %esi
80100c92:	e8 59 62 00 00       	call   80106ef0 <allocuvm>
80100c97:	83 c4 10             	add    $0x10,%esp
80100c9a:	89 c7                	mov    %eax,%edi
80100c9c:	85 c0                	test   %eax,%eax
80100c9e:	0f 84 86 00 00 00    	je     80100d2a <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ca4:	83 ec 08             	sub    $0x8,%esp
80100ca7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100cad:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100caf:	50                   	push   %eax
80100cb0:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100cb1:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cb3:	e8 a8 64 00 00       	call   80107160 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cbb:	83 c4 10             	add    $0x10,%esp
80100cbe:	8b 10                	mov    (%eax),%edx
80100cc0:	85 d2                	test   %edx,%edx
80100cc2:	0f 84 56 01 00 00    	je     80100e1e <exec+0x33e>
80100cc8:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100cce:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100cd1:	eb 23                	jmp    80100cf6 <exec+0x216>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
80100cd8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100cdb:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100ce2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100ce8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100ceb:	85 d2                	test   %edx,%edx
80100ced:	74 51                	je     80100d40 <exec+0x260>
    if(argc >= MAXARG)
80100cef:	83 f8 20             	cmp    $0x20,%eax
80100cf2:	74 36                	je     80100d2a <exec+0x24a>
  for(argc = 0; argv[argc]; argc++) {
80100cf4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cf6:	83 ec 0c             	sub    $0xc,%esp
80100cf9:	52                   	push   %edx
80100cfa:	e8 31 3d 00 00       	call   80104a30 <strlen>
80100cff:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d01:	58                   	pop    %eax
80100d02:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d05:	83 eb 01             	sub    $0x1,%ebx
80100d08:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d0b:	e8 20 3d 00 00       	call   80104a30 <strlen>
80100d10:	83 c0 01             	add    $0x1,%eax
80100d13:	50                   	push   %eax
80100d14:	ff 34 b7             	push   (%edi,%esi,4)
80100d17:	53                   	push   %ebx
80100d18:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d1e:	e8 0d 66 00 00       	call   80107330 <copyout>
80100d23:	83 c4 20             	add    $0x20,%esp
80100d26:	85 c0                	test   %eax,%eax
80100d28:	79 ae                	jns    80100cd8 <exec+0x1f8>
    freevm(pgdir);
80100d2a:	83 ec 0c             	sub    $0xc,%esp
80100d2d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d33:	e8 08 63 00 00       	call   80107040 <freevm>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	e9 0c ff ff ff       	jmp    80100c4c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d40:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d47:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d4d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d53:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d56:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d59:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d60:	00 00 00 00 
  ustack[1] = argc;
80100d64:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d6a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d71:	ff ff ff 
  ustack[1] = argc;
80100d74:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d7a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d7c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d7e:	29 d0                	sub    %edx,%eax
80100d80:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d86:	56                   	push   %esi
80100d87:	51                   	push   %ecx
80100d88:	53                   	push   %ebx
80100d89:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d8f:	e8 9c 65 00 00       	call   80107330 <copyout>
80100d94:	83 c4 10             	add    $0x10,%esp
80100d97:	85 c0                	test   %eax,%eax
80100d99:	78 8f                	js     80100d2a <exec+0x24a>
  for(last=s=path; *s; s++)
80100d9b:	8b 45 08             	mov    0x8(%ebp),%eax
80100d9e:	8b 55 08             	mov    0x8(%ebp),%edx
80100da1:	0f b6 00             	movzbl (%eax),%eax
80100da4:	84 c0                	test   %al,%al
80100da6:	74 17                	je     80100dbf <exec+0x2df>
80100da8:	89 d1                	mov    %edx,%ecx
80100daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100db0:	83 c1 01             	add    $0x1,%ecx
80100db3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100db5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100db8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100dbb:	84 c0                	test   %al,%al
80100dbd:	75 f1                	jne    80100db0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100dbf:	83 ec 04             	sub    $0x4,%esp
80100dc2:	6a 10                	push   $0x10
80100dc4:	52                   	push   %edx
80100dc5:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100dcb:	8d 46 6c             	lea    0x6c(%esi),%eax
80100dce:	50                   	push   %eax
80100dcf:	e8 1c 3c 00 00       	call   801049f0 <safestrcpy>
  curproc->pgdir = pgdir;
80100dd4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dda:	89 f0                	mov    %esi,%eax
80100ddc:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100ddf:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100de1:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100de4:	89 c1                	mov    %eax,%ecx
80100de6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dec:	8b 40 18             	mov    0x18(%eax),%eax
80100def:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100df2:	8b 41 18             	mov    0x18(%ecx),%eax
80100df5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100df8:	89 0c 24             	mov    %ecx,(%esp)
80100dfb:	e8 90 5e 00 00       	call   80106c90 <switchuvm>
  freevm(oldpgdir);
80100e00:	89 34 24             	mov    %esi,(%esp)
80100e03:	e8 38 62 00 00       	call   80107040 <freevm>
  return 0;
80100e08:	83 c4 10             	add    $0x10,%esp
80100e0b:	31 c0                	xor    %eax,%eax
80100e0d:	e9 3f fe ff ff       	jmp    80100c51 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e12:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100e17:	31 f6                	xor    %esi,%esi
80100e19:	e9 5a fe ff ff       	jmp    80100c78 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100e1e:	be 10 00 00 00       	mov    $0x10,%esi
80100e23:	ba 04 00 00 00       	mov    $0x4,%edx
80100e28:	b8 03 00 00 00       	mov    $0x3,%eax
80100e2d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e34:	00 00 00 
80100e37:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e3d:	e9 17 ff ff ff       	jmp    80100d59 <exec+0x279>
    end_op();
80100e42:	e8 f9 1f 00 00       	call   80102e40 <end_op>
    cprintf("exec: fail\n");
80100e47:	83 ec 0c             	sub    $0xc,%esp
80100e4a:	68 81 76 10 80       	push   $0x80107681
80100e4f:	e8 5c f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e54:	83 c4 10             	add    $0x10,%esp
80100e57:	e9 f0 fd ff ff       	jmp    80100c4c <exec+0x16c>
80100e5c:	66 90                	xchg   %ax,%ax
80100e5e:	66 90                	xchg   %ax,%ax

80100e60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e66:	68 8d 76 10 80       	push   $0x8010768d
80100e6b:	68 60 ef 10 80       	push   $0x8010ef60
80100e70:	e8 0b 37 00 00       	call   80104580 <initlock>
}
80100e75:	83 c4 10             	add    $0x10,%esp
80100e78:	c9                   	leave
80100e79:	c3                   	ret
80100e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e84:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100e89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e8c:	68 60 ef 10 80       	push   $0x8010ef60
80100e91:	e8 ca 38 00 00       	call   80104760 <acquire>
80100e96:	83 c4 10             	add    $0x10,%esp
80100e99:	eb 10                	jmp    80100eab <filealloc+0x2b>
80100e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e9f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ea0:	83 c3 18             	add    $0x18,%ebx
80100ea3:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100ea9:	74 25                	je     80100ed0 <filealloc+0x50>
    if(f->ref == 0){
80100eab:	8b 43 04             	mov    0x4(%ebx),%eax
80100eae:	85 c0                	test   %eax,%eax
80100eb0:	75 ee                	jne    80100ea0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100eb2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100eb5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ebc:	68 60 ef 10 80       	push   $0x8010ef60
80100ec1:	e8 3a 38 00 00       	call   80104700 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ec6:	89 d8                	mov    %ebx,%eax
      return f;
80100ec8:	83 c4 10             	add    $0x10,%esp
}
80100ecb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ece:	c9                   	leave
80100ecf:	c3                   	ret
  release(&ftable.lock);
80100ed0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ed3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ed5:	68 60 ef 10 80       	push   $0x8010ef60
80100eda:	e8 21 38 00 00       	call   80104700 <release>
}
80100edf:	89 d8                	mov    %ebx,%eax
  return 0;
80100ee1:	83 c4 10             	add    $0x10,%esp
}
80100ee4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee7:	c9                   	leave
80100ee8:	c3                   	ret
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 10             	sub    $0x10,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100efa:	68 60 ef 10 80       	push   $0x8010ef60
80100eff:	e8 5c 38 00 00       	call   80104760 <acquire>
  if(f->ref < 1)
80100f04:	8b 43 04             	mov    0x4(%ebx),%eax
80100f07:	83 c4 10             	add    $0x10,%esp
80100f0a:	85 c0                	test   %eax,%eax
80100f0c:	7e 1a                	jle    80100f28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f17:	68 60 ef 10 80       	push   $0x8010ef60
80100f1c:	e8 df 37 00 00       	call   80104700 <release>
  return f;
}
80100f21:	89 d8                	mov    %ebx,%eax
80100f23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f26:	c9                   	leave
80100f27:	c3                   	ret
    panic("filedup");
80100f28:	83 ec 0c             	sub    $0xc,%esp
80100f2b:	68 94 76 10 80       	push   $0x80107694
80100f30:	e8 4b f4 ff ff       	call   80100380 <panic>
80100f35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 28             	sub    $0x28,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f4c:	68 60 ef 10 80       	push   $0x8010ef60
80100f51:	e8 0a 38 00 00       	call   80104760 <acquire>
  if(f->ref < 1)
80100f56:	8b 53 04             	mov    0x4(%ebx),%edx
80100f59:	83 c4 10             	add    $0x10,%esp
80100f5c:	85 d2                	test   %edx,%edx
80100f5e:	0f 8e a5 00 00 00    	jle    80101009 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f64:	83 ea 01             	sub    $0x1,%edx
80100f67:	89 53 04             	mov    %edx,0x4(%ebx)
80100f6a:	75 44                	jne    80100fb0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f6c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f70:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f73:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f75:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f7b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f7e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f81:	8b 43 10             	mov    0x10(%ebx),%eax
80100f84:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f87:	68 60 ef 10 80       	push   $0x8010ef60
80100f8c:	e8 6f 37 00 00       	call   80104700 <release>

  if(ff.type == FD_PIPE)
80100f91:	83 c4 10             	add    $0x10,%esp
80100f94:	83 ff 01             	cmp    $0x1,%edi
80100f97:	74 57                	je     80100ff0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f99:	83 ff 02             	cmp    $0x2,%edi
80100f9c:	74 2a                	je     80100fc8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa1:	5b                   	pop    %ebx
80100fa2:	5e                   	pop    %esi
80100fa3:	5f                   	pop    %edi
80100fa4:	5d                   	pop    %ebp
80100fa5:	c3                   	ret
80100fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fad:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100fb0:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100fb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fba:	5b                   	pop    %ebx
80100fbb:	5e                   	pop    %esi
80100fbc:	5f                   	pop    %edi
80100fbd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fbe:	e9 3d 37 00 00       	jmp    80104700 <release>
80100fc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fc7:	90                   	nop
    begin_op();
80100fc8:	e8 03 1e 00 00       	call   80102dd0 <begin_op>
    iput(ff.ip);
80100fcd:	83 ec 0c             	sub    $0xc,%esp
80100fd0:	ff 75 e0             	push   -0x20(%ebp)
80100fd3:	e8 28 09 00 00       	call   80101900 <iput>
    end_op();
80100fd8:	83 c4 10             	add    $0x10,%esp
}
80100fdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fde:	5b                   	pop    %ebx
80100fdf:	5e                   	pop    %esi
80100fe0:	5f                   	pop    %edi
80100fe1:	5d                   	pop    %ebp
    end_op();
80100fe2:	e9 59 1e 00 00       	jmp    80102e40 <end_op>
80100fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fee:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100ff0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ff4:	83 ec 08             	sub    $0x8,%esp
80100ff7:	53                   	push   %ebx
80100ff8:	56                   	push   %esi
80100ff9:	e8 92 25 00 00       	call   80103590 <pipeclose>
80100ffe:	83 c4 10             	add    $0x10,%esp
}
80101001:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101004:	5b                   	pop    %ebx
80101005:	5e                   	pop    %esi
80101006:	5f                   	pop    %edi
80101007:	5d                   	pop    %ebp
80101008:	c3                   	ret
    panic("fileclose");
80101009:	83 ec 0c             	sub    $0xc,%esp
8010100c:	68 9c 76 10 80       	push   $0x8010769c
80101011:	e8 6a f3 ff ff       	call   80100380 <panic>
80101016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010101d:	8d 76 00             	lea    0x0(%esi),%esi

80101020 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	53                   	push   %ebx
80101024:	83 ec 04             	sub    $0x4,%esp
80101027:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010102a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010102d:	75 31                	jne    80101060 <filestat+0x40>
    ilock(f->ip);
8010102f:	83 ec 0c             	sub    $0xc,%esp
80101032:	ff 73 10             	push   0x10(%ebx)
80101035:	e8 96 07 00 00       	call   801017d0 <ilock>
    stati(f->ip, st);
8010103a:	58                   	pop    %eax
8010103b:	5a                   	pop    %edx
8010103c:	ff 75 0c             	push   0xc(%ebp)
8010103f:	ff 73 10             	push   0x10(%ebx)
80101042:	e8 69 0a 00 00       	call   80101ab0 <stati>
    iunlock(f->ip);
80101047:	59                   	pop    %ecx
80101048:	ff 73 10             	push   0x10(%ebx)
8010104b:	e8 60 08 00 00       	call   801018b0 <iunlock>
    return 0;
  }
  return -1;
}
80101050:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101053:	83 c4 10             	add    $0x10,%esp
80101056:	31 c0                	xor    %eax,%eax
}
80101058:	c9                   	leave
80101059:	c3                   	ret
8010105a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101060:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101063:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101068:	c9                   	leave
80101069:	c3                   	ret
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101070 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101070:	55                   	push   %ebp
80101071:	89 e5                	mov    %esp,%ebp
80101073:	57                   	push   %edi
80101074:	56                   	push   %esi
80101075:	53                   	push   %ebx
80101076:	83 ec 0c             	sub    $0xc,%esp
80101079:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010107c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010107f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101082:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101086:	74 60                	je     801010e8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101088:	8b 03                	mov    (%ebx),%eax
8010108a:	83 f8 01             	cmp    $0x1,%eax
8010108d:	74 41                	je     801010d0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010108f:	83 f8 02             	cmp    $0x2,%eax
80101092:	75 5b                	jne    801010ef <fileread+0x7f>
    ilock(f->ip);
80101094:	83 ec 0c             	sub    $0xc,%esp
80101097:	ff 73 10             	push   0x10(%ebx)
8010109a:	e8 31 07 00 00       	call   801017d0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010109f:	57                   	push   %edi
801010a0:	ff 73 14             	push   0x14(%ebx)
801010a3:	56                   	push   %esi
801010a4:	ff 73 10             	push   0x10(%ebx)
801010a7:	e8 34 0a 00 00       	call   80101ae0 <readi>
801010ac:	83 c4 20             	add    $0x20,%esp
801010af:	89 c6                	mov    %eax,%esi
801010b1:	85 c0                	test   %eax,%eax
801010b3:	7e 03                	jle    801010b8 <fileread+0x48>
      f->off += r;
801010b5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010b8:	83 ec 0c             	sub    $0xc,%esp
801010bb:	ff 73 10             	push   0x10(%ebx)
801010be:	e8 ed 07 00 00       	call   801018b0 <iunlock>
    return r;
801010c3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c9:	89 f0                	mov    %esi,%eax
801010cb:	5b                   	pop    %ebx
801010cc:	5e                   	pop    %esi
801010cd:	5f                   	pop    %edi
801010ce:	5d                   	pop    %ebp
801010cf:	c3                   	ret
    return piperead(f->pipe, addr, n);
801010d0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010d3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d9:	5b                   	pop    %ebx
801010da:	5e                   	pop    %esi
801010db:	5f                   	pop    %edi
801010dc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010dd:	e9 6e 26 00 00       	jmp    80103750 <piperead>
801010e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010e8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010ed:	eb d7                	jmp    801010c6 <fileread+0x56>
  panic("fileread");
801010ef:	83 ec 0c             	sub    $0xc,%esp
801010f2:	68 a6 76 10 80       	push   $0x801076a6
801010f7:	e8 84 f2 ff ff       	call   80100380 <panic>
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101100 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 1c             	sub    $0x1c,%esp
80101109:	8b 45 0c             	mov    0xc(%ebp),%eax
8010110c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010110f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101112:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101115:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010111c:	0f 84 bb 00 00 00    	je     801011dd <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80101122:	8b 03                	mov    (%ebx),%eax
80101124:	83 f8 01             	cmp    $0x1,%eax
80101127:	0f 84 bf 00 00 00    	je     801011ec <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010112d:	83 f8 02             	cmp    $0x2,%eax
80101130:	0f 85 c8 00 00 00    	jne    801011fe <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101136:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101139:	31 f6                	xor    %esi,%esi
    while(i < n){
8010113b:	85 c0                	test   %eax,%eax
8010113d:	7f 30                	jg     8010116f <filewrite+0x6f>
8010113f:	e9 94 00 00 00       	jmp    801011d8 <filewrite+0xd8>
80101144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101148:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010114b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010114e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101151:	ff 73 10             	push   0x10(%ebx)
80101154:	e8 57 07 00 00       	call   801018b0 <iunlock>
      end_op();
80101159:	e8 e2 1c 00 00       	call   80102e40 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010115e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101161:	83 c4 10             	add    $0x10,%esp
80101164:	39 c7                	cmp    %eax,%edi
80101166:	75 5c                	jne    801011c4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101168:	01 fe                	add    %edi,%esi
    while(i < n){
8010116a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010116d:	7e 69                	jle    801011d8 <filewrite+0xd8>
      int n1 = n - i;
8010116f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101172:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101177:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101179:	39 c7                	cmp    %eax,%edi
8010117b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010117e:	e8 4d 1c 00 00       	call   80102dd0 <begin_op>
      ilock(f->ip);
80101183:	83 ec 0c             	sub    $0xc,%esp
80101186:	ff 73 10             	push   0x10(%ebx)
80101189:	e8 42 06 00 00       	call   801017d0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010118e:	57                   	push   %edi
8010118f:	ff 73 14             	push   0x14(%ebx)
80101192:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101195:	01 f0                	add    %esi,%eax
80101197:	50                   	push   %eax
80101198:	ff 73 10             	push   0x10(%ebx)
8010119b:	e8 40 0a 00 00       	call   80101be0 <writei>
801011a0:	83 c4 20             	add    $0x20,%esp
801011a3:	85 c0                	test   %eax,%eax
801011a5:	7f a1                	jg     80101148 <filewrite+0x48>
801011a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801011aa:	83 ec 0c             	sub    $0xc,%esp
801011ad:	ff 73 10             	push   0x10(%ebx)
801011b0:	e8 fb 06 00 00       	call   801018b0 <iunlock>
      end_op();
801011b5:	e8 86 1c 00 00       	call   80102e40 <end_op>
      if(r < 0)
801011ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011bd:	83 c4 10             	add    $0x10,%esp
801011c0:	85 c0                	test   %eax,%eax
801011c2:	75 14                	jne    801011d8 <filewrite+0xd8>
        panic("short filewrite");
801011c4:	83 ec 0c             	sub    $0xc,%esp
801011c7:	68 af 76 10 80       	push   $0x801076af
801011cc:	e8 af f1 ff ff       	call   80100380 <panic>
801011d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011d8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011db:	74 05                	je     801011e2 <filewrite+0xe2>
    return -1;
801011dd:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801011e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e5:	89 f0                	mov    %esi,%eax
801011e7:	5b                   	pop    %ebx
801011e8:	5e                   	pop    %esi
801011e9:	5f                   	pop    %edi
801011ea:	5d                   	pop    %ebp
801011eb:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801011ec:	8b 43 0c             	mov    0xc(%ebx),%eax
801011ef:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011f5:	5b                   	pop    %ebx
801011f6:	5e                   	pop    %esi
801011f7:	5f                   	pop    %edi
801011f8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011f9:	e9 32 24 00 00       	jmp    80103630 <pipewrite>
  panic("filewrite");
801011fe:	83 ec 0c             	sub    $0xc,%esp
80101201:	68 b5 76 10 80       	push   $0x801076b5
80101206:	e8 75 f1 ff ff       	call   80100380 <panic>
8010120b:	66 90                	xchg   %ax,%ax
8010120d:	66 90                	xchg   %ax,%ax
8010120f:	90                   	nop

80101210 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101219:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010121f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101222:	85 c9                	test   %ecx,%ecx
80101224:	0f 84 8c 00 00 00    	je     801012b6 <balloc+0xa6>
8010122a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010122c:	89 f8                	mov    %edi,%eax
8010122e:	83 ec 08             	sub    $0x8,%esp
80101231:	89 fe                	mov    %edi,%esi
80101233:	c1 f8 0c             	sar    $0xc,%eax
80101236:	03 05 cc 15 11 80    	add    0x801115cc,%eax
8010123c:	50                   	push   %eax
8010123d:	ff 75 dc             	push   -0x24(%ebp)
80101240:	e8 8b ee ff ff       	call   801000d0 <bread>
80101245:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101248:	83 c4 10             	add    $0x10,%esp
8010124b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010124e:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101253:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101256:	31 c0                	xor    %eax,%eax
80101258:	eb 32                	jmp    8010128c <balloc+0x7c>
8010125a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101260:	89 c1                	mov    %eax,%ecx
80101262:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101267:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010126a:	83 e1 07             	and    $0x7,%ecx
8010126d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010126f:	89 c1                	mov    %eax,%ecx
80101271:	c1 f9 03             	sar    $0x3,%ecx
80101274:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101279:	89 fa                	mov    %edi,%edx
8010127b:	85 df                	test   %ebx,%edi
8010127d:	74 49                	je     801012c8 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010127f:	83 c0 01             	add    $0x1,%eax
80101282:	83 c6 01             	add    $0x1,%esi
80101285:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010128a:	74 07                	je     80101293 <balloc+0x83>
8010128c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010128f:	39 d6                	cmp    %edx,%esi
80101291:	72 cd                	jb     80101260 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101293:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101296:	83 ec 0c             	sub    $0xc,%esp
80101299:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010129c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
801012a2:	e8 49 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012a7:	83 c4 10             	add    $0x10,%esp
801012aa:	3b 3d b4 15 11 80    	cmp    0x801115b4,%edi
801012b0:	0f 82 76 ff ff ff    	jb     8010122c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
801012b6:	83 ec 0c             	sub    $0xc,%esp
801012b9:	68 bf 76 10 80       	push   $0x801076bf
801012be:	e8 bd f0 ff ff       	call   80100380 <panic>
801012c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012c7:	90                   	nop
        bp->data[bi/8] |= m;  // Mark block in use.
801012c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012cb:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012ce:	09 da                	or     %ebx,%edx
801012d0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012d4:	57                   	push   %edi
801012d5:	e8 d6 1c 00 00       	call   80102fb0 <log_write>
        brelse(bp);
801012da:	89 3c 24             	mov    %edi,(%esp)
801012dd:	e8 0e ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012e2:	58                   	pop    %eax
801012e3:	5a                   	pop    %edx
801012e4:	56                   	push   %esi
801012e5:	ff 75 dc             	push   -0x24(%ebp)
801012e8:	e8 e3 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012ed:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012f0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012f2:	8d 40 5c             	lea    0x5c(%eax),%eax
801012f5:	68 00 02 00 00       	push   $0x200
801012fa:	6a 00                	push   $0x0
801012fc:	50                   	push   %eax
801012fd:	e8 3e 35 00 00       	call   80104840 <memset>
  log_write(bp);
80101302:	89 1c 24             	mov    %ebx,(%esp)
80101305:	e8 a6 1c 00 00       	call   80102fb0 <log_write>
  brelse(bp);
8010130a:	89 1c 24             	mov    %ebx,(%esp)
8010130d:	e8 de ee ff ff       	call   801001f0 <brelse>
}
80101312:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101315:	89 f0                	mov    %esi,%eax
80101317:	5b                   	pop    %ebx
80101318:	5e                   	pop    %esi
80101319:	5f                   	pop    %edi
8010131a:	5d                   	pop    %ebp
8010131b:	c3                   	ret
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101320 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101324:	31 ff                	xor    %edi,%edi
{
80101326:	56                   	push   %esi
80101327:	89 c6                	mov    %eax,%esi
80101329:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010132a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
8010132f:	83 ec 28             	sub    $0x28,%esp
80101332:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101335:	68 60 f9 10 80       	push   $0x8010f960
8010133a:	e8 21 34 00 00       	call   80104760 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010133f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101342:	83 c4 10             	add    $0x10,%esp
80101345:	eb 1b                	jmp    80101362 <iget+0x42>
80101347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101350:	39 33                	cmp    %esi,(%ebx)
80101352:	74 6c                	je     801013c0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101354:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010135a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101360:	74 26                	je     80101388 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101362:	8b 43 08             	mov    0x8(%ebx),%eax
80101365:	85 c0                	test   %eax,%eax
80101367:	7f e7                	jg     80101350 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101369:	85 ff                	test   %edi,%edi
8010136b:	75 e7                	jne    80101354 <iget+0x34>
8010136d:	85 c0                	test   %eax,%eax
8010136f:	75 76                	jne    801013e7 <iget+0xc7>
80101371:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101373:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101379:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010137f:	75 e1                	jne    80101362 <iget+0x42>
80101381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101388:	85 ff                	test   %edi,%edi
8010138a:	74 79                	je     80101405 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010138c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010138f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101391:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101394:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010139b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
801013a2:	68 60 f9 10 80       	push   $0x8010f960
801013a7:	e8 54 33 00 00       	call   80104700 <release>

  return ip;
801013ac:	83 c4 10             	add    $0x10,%esp
}
801013af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b2:	89 f8                	mov    %edi,%eax
801013b4:	5b                   	pop    %ebx
801013b5:	5e                   	pop    %esi
801013b6:	5f                   	pop    %edi
801013b7:	5d                   	pop    %ebp
801013b8:	c3                   	ret
801013b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013c3:	75 8f                	jne    80101354 <iget+0x34>
      ip->ref++;
801013c5:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
801013c8:	83 ec 0c             	sub    $0xc,%esp
      return ip;
801013cb:	89 df                	mov    %ebx,%edi
      ip->ref++;
801013cd:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013d0:	68 60 f9 10 80       	push   $0x8010f960
801013d5:	e8 26 33 00 00       	call   80104700 <release>
      return ip;
801013da:	83 c4 10             	add    $0x10,%esp
}
801013dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e0:	89 f8                	mov    %edi,%eax
801013e2:	5b                   	pop    %ebx
801013e3:	5e                   	pop    %esi
801013e4:	5f                   	pop    %edi
801013e5:	5d                   	pop    %ebp
801013e6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013e7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013ed:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801013f3:	74 10                	je     80101405 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f5:	8b 43 08             	mov    0x8(%ebx),%eax
801013f8:	85 c0                	test   %eax,%eax
801013fa:	0f 8f 50 ff ff ff    	jg     80101350 <iget+0x30>
80101400:	e9 68 ff ff ff       	jmp    8010136d <iget+0x4d>
    panic("iget: no inodes");
80101405:	83 ec 0c             	sub    $0xc,%esp
80101408:	68 d5 76 10 80       	push   $0x801076d5
8010140d:	e8 6e ef ff ff       	call   80100380 <panic>
80101412:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101420 <bfree>:
{
80101420:	55                   	push   %ebp
80101421:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
80101423:	89 d0                	mov    %edx,%eax
80101425:	c1 e8 0c             	shr    $0xc,%eax
{
80101428:	89 e5                	mov    %esp,%ebp
8010142a:	56                   	push   %esi
8010142b:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
8010142c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
80101432:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101434:	83 ec 08             	sub    $0x8,%esp
80101437:	50                   	push   %eax
80101438:	51                   	push   %ecx
80101439:	e8 92 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010143e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101440:	c1 fb 03             	sar    $0x3,%ebx
80101443:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101446:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101448:	83 e1 07             	and    $0x7,%ecx
8010144b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101450:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101456:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101458:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010145d:	85 c1                	test   %eax,%ecx
8010145f:	74 23                	je     80101484 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101461:	f7 d0                	not    %eax
  log_write(bp);
80101463:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101466:	21 c8                	and    %ecx,%eax
80101468:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010146c:	56                   	push   %esi
8010146d:	e8 3e 1b 00 00       	call   80102fb0 <log_write>
  brelse(bp);
80101472:	89 34 24             	mov    %esi,(%esp)
80101475:	e8 76 ed ff ff       	call   801001f0 <brelse>
}
8010147a:	83 c4 10             	add    $0x10,%esp
8010147d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101480:	5b                   	pop    %ebx
80101481:	5e                   	pop    %esi
80101482:	5d                   	pop    %ebp
80101483:	c3                   	ret
    panic("freeing free block");
80101484:	83 ec 0c             	sub    $0xc,%esp
80101487:	68 e5 76 10 80       	push   $0x801076e5
8010148c:	e8 ef ee ff ff       	call   80100380 <panic>
80101491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101498:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010149f:	90                   	nop

801014a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	57                   	push   %edi
801014a4:	56                   	push   %esi
801014a5:	89 c6                	mov    %eax,%esi
801014a7:	53                   	push   %ebx
801014a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014ab:	83 fa 0b             	cmp    $0xb,%edx
801014ae:	0f 86 8c 00 00 00    	jbe    80101540 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014b4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014b7:	83 fb 7f             	cmp    $0x7f,%ebx
801014ba:	0f 87 a2 00 00 00    	ja     80101562 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801014c0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801014c6:	85 c0                	test   %eax,%eax
801014c8:	74 5e                	je     80101528 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014ca:	83 ec 08             	sub    $0x8,%esp
801014cd:	50                   	push   %eax
801014ce:	ff 36                	push   (%esi)
801014d0:	e8 fb eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014d5:	83 c4 10             	add    $0x10,%esp
801014d8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014dc:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014de:	8b 3b                	mov    (%ebx),%edi
801014e0:	85 ff                	test   %edi,%edi
801014e2:	74 1c                	je     80101500 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014e4:	83 ec 0c             	sub    $0xc,%esp
801014e7:	52                   	push   %edx
801014e8:	e8 03 ed ff ff       	call   801001f0 <brelse>
801014ed:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f3:	89 f8                	mov    %edi,%eax
801014f5:	5b                   	pop    %ebx
801014f6:	5e                   	pop    %esi
801014f7:	5f                   	pop    %edi
801014f8:	5d                   	pop    %ebp
801014f9:	c3                   	ret
801014fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101500:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101503:	8b 06                	mov    (%esi),%eax
80101505:	e8 06 fd ff ff       	call   80101210 <balloc>
      log_write(bp);
8010150a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010150d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101510:	89 03                	mov    %eax,(%ebx)
80101512:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101514:	52                   	push   %edx
80101515:	e8 96 1a 00 00       	call   80102fb0 <log_write>
8010151a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010151d:	83 c4 10             	add    $0x10,%esp
80101520:	eb c2                	jmp    801014e4 <bmap+0x44>
80101522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101528:	8b 06                	mov    (%esi),%eax
8010152a:	e8 e1 fc ff ff       	call   80101210 <balloc>
8010152f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101535:	eb 93                	jmp    801014ca <bmap+0x2a>
80101537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010153e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101540:	8d 5a 14             	lea    0x14(%edx),%ebx
80101543:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101547:	85 ff                	test   %edi,%edi
80101549:	75 a5                	jne    801014f0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010154b:	8b 00                	mov    (%eax),%eax
8010154d:	e8 be fc ff ff       	call   80101210 <balloc>
80101552:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101556:	89 c7                	mov    %eax,%edi
}
80101558:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010155b:	5b                   	pop    %ebx
8010155c:	89 f8                	mov    %edi,%eax
8010155e:	5e                   	pop    %esi
8010155f:	5f                   	pop    %edi
80101560:	5d                   	pop    %ebp
80101561:	c3                   	ret
  panic("bmap: out of range");
80101562:	83 ec 0c             	sub    $0xc,%esp
80101565:	68 f8 76 10 80       	push   $0x801076f8
8010156a:	e8 11 ee ff ff       	call   80100380 <panic>
8010156f:	90                   	nop

80101570 <readsb>:
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	56                   	push   %esi
80101574:	53                   	push   %ebx
80101575:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101578:	83 ec 08             	sub    $0x8,%esp
8010157b:	6a 01                	push   $0x1
8010157d:	ff 75 08             	push   0x8(%ebp)
80101580:	e8 4b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101585:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101588:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010158a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010158d:	6a 1c                	push   $0x1c
8010158f:	50                   	push   %eax
80101590:	56                   	push   %esi
80101591:	e8 3a 33 00 00       	call   801048d0 <memmove>
  brelse(bp);
80101596:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101599:	83 c4 10             	add    $0x10,%esp
}
8010159c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010159f:	5b                   	pop    %ebx
801015a0:	5e                   	pop    %esi
801015a1:	5d                   	pop    %ebp
  brelse(bp);
801015a2:	e9 49 ec ff ff       	jmp    801001f0 <brelse>
801015a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ae:	66 90                	xchg   %ax,%ax

801015b0 <iinit>:
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	53                   	push   %ebx
801015b4:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
801015b9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015bc:	68 0b 77 10 80       	push   $0x8010770b
801015c1:	68 60 f9 10 80       	push   $0x8010f960
801015c6:	e8 b5 2f 00 00       	call   80104580 <initlock>
  for(i = 0; i < NINODE; i++) {
801015cb:	83 c4 10             	add    $0x10,%esp
801015ce:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015d0:	83 ec 08             	sub    $0x8,%esp
801015d3:	68 12 77 10 80       	push   $0x80107712
801015d8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015d9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015df:	e8 6c 2e 00 00       	call   80104450 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015e4:	83 c4 10             	add    $0x10,%esp
801015e7:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
801015ed:	75 e1                	jne    801015d0 <iinit+0x20>
  bp = bread(dev, 1);
801015ef:	83 ec 08             	sub    $0x8,%esp
801015f2:	6a 01                	push   $0x1
801015f4:	ff 75 08             	push   0x8(%ebp)
801015f7:	e8 d4 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015fc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015ff:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101601:	8d 40 5c             	lea    0x5c(%eax),%eax
80101604:	6a 1c                	push   $0x1c
80101606:	50                   	push   %eax
80101607:	68 b4 15 11 80       	push   $0x801115b4
8010160c:	e8 bf 32 00 00       	call   801048d0 <memmove>
  brelse(bp);
80101611:	89 1c 24             	mov    %ebx,(%esp)
80101614:	e8 d7 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101619:	ff 35 cc 15 11 80    	push   0x801115cc
8010161f:	ff 35 c8 15 11 80    	push   0x801115c8
80101625:	ff 35 c4 15 11 80    	push   0x801115c4
8010162b:	ff 35 c0 15 11 80    	push   0x801115c0
80101631:	ff 35 bc 15 11 80    	push   0x801115bc
80101637:	ff 35 b8 15 11 80    	push   0x801115b8
8010163d:	ff 35 b4 15 11 80    	push   0x801115b4
80101643:	68 78 77 10 80       	push   $0x80107778
80101648:	e8 63 f0 ff ff       	call   801006b0 <cprintf>
}
8010164d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101650:	83 c4 30             	add    $0x30,%esp
80101653:	c9                   	leave
80101654:	c3                   	ret
80101655:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010165c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101660 <ialloc>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	57                   	push   %edi
80101664:	56                   	push   %esi
80101665:	53                   	push   %ebx
80101666:	83 ec 1c             	sub    $0x1c,%esp
80101669:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101673:	8b 75 08             	mov    0x8(%ebp),%esi
80101676:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101679:	0f 86 91 00 00 00    	jbe    80101710 <ialloc+0xb0>
8010167f:	bf 01 00 00 00       	mov    $0x1,%edi
80101684:	eb 21                	jmp    801016a7 <ialloc+0x47>
80101686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010168d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101690:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101693:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101696:	53                   	push   %ebx
80101697:	e8 54 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010169c:	83 c4 10             	add    $0x10,%esp
8010169f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
801016a5:	73 69                	jae    80101710 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801016a7:	89 f8                	mov    %edi,%eax
801016a9:	83 ec 08             	sub    $0x8,%esp
801016ac:	c1 e8 03             	shr    $0x3,%eax
801016af:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801016b5:	50                   	push   %eax
801016b6:	56                   	push   %esi
801016b7:	e8 14 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016bc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016bf:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016c1:	89 f8                	mov    %edi,%eax
801016c3:	83 e0 07             	and    $0x7,%eax
801016c6:	c1 e0 06             	shl    $0x6,%eax
801016c9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016cd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016d1:	75 bd                	jne    80101690 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016d3:	83 ec 04             	sub    $0x4,%esp
801016d6:	6a 40                	push   $0x40
801016d8:	6a 00                	push   $0x0
801016da:	51                   	push   %ecx
801016db:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016de:	e8 5d 31 00 00       	call   80104840 <memset>
      dip->type = type;
801016e3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016e7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016ea:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016ed:	89 1c 24             	mov    %ebx,(%esp)
801016f0:	e8 bb 18 00 00       	call   80102fb0 <log_write>
      brelse(bp);
801016f5:	89 1c 24             	mov    %ebx,(%esp)
801016f8:	e8 f3 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016fd:	83 c4 10             	add    $0x10,%esp
}
80101700:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101703:	89 fa                	mov    %edi,%edx
}
80101705:	5b                   	pop    %ebx
      return iget(dev, inum);
80101706:	89 f0                	mov    %esi,%eax
}
80101708:	5e                   	pop    %esi
80101709:	5f                   	pop    %edi
8010170a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010170b:	e9 10 fc ff ff       	jmp    80101320 <iget>
  panic("ialloc: no inodes");
80101710:	83 ec 0c             	sub    $0xc,%esp
80101713:	68 18 77 10 80       	push   $0x80107718
80101718:	e8 63 ec ff ff       	call   80100380 <panic>
8010171d:	8d 76 00             	lea    0x0(%esi),%esi

80101720 <iupdate>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	56                   	push   %esi
80101724:	53                   	push   %ebx
80101725:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101728:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010172e:	83 ec 08             	sub    $0x8,%esp
80101731:	c1 e8 03             	shr    $0x3,%eax
80101734:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010173a:	50                   	push   %eax
8010173b:	ff 73 a4             	push   -0x5c(%ebx)
8010173e:	e8 8d e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101743:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101747:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010174a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010174c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010174f:	83 e0 07             	and    $0x7,%eax
80101752:	c1 e0 06             	shl    $0x6,%eax
80101755:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101759:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010175c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101760:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101763:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101767:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010176b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010176f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101773:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101777:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010177a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010177d:	6a 34                	push   $0x34
8010177f:	53                   	push   %ebx
80101780:	50                   	push   %eax
80101781:	e8 4a 31 00 00       	call   801048d0 <memmove>
  log_write(bp);
80101786:	89 34 24             	mov    %esi,(%esp)
80101789:	e8 22 18 00 00       	call   80102fb0 <log_write>
  brelse(bp);
8010178e:	89 75 08             	mov    %esi,0x8(%ebp)
80101791:	83 c4 10             	add    $0x10,%esp
}
80101794:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101797:	5b                   	pop    %ebx
80101798:	5e                   	pop    %esi
80101799:	5d                   	pop    %ebp
  brelse(bp);
8010179a:	e9 51 ea ff ff       	jmp    801001f0 <brelse>
8010179f:	90                   	nop

801017a0 <idup>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	53                   	push   %ebx
801017a4:	83 ec 10             	sub    $0x10,%esp
801017a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017aa:	68 60 f9 10 80       	push   $0x8010f960
801017af:	e8 ac 2f 00 00       	call   80104760 <acquire>
  ip->ref++;
801017b4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017b8:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801017bf:	e8 3c 2f 00 00       	call   80104700 <release>
}
801017c4:	89 d8                	mov    %ebx,%eax
801017c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017c9:	c9                   	leave
801017ca:	c3                   	ret
801017cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017cf:	90                   	nop

801017d0 <ilock>:
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	56                   	push   %esi
801017d4:	53                   	push   %ebx
801017d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017d8:	85 db                	test   %ebx,%ebx
801017da:	0f 84 b7 00 00 00    	je     80101897 <ilock+0xc7>
801017e0:	8b 53 08             	mov    0x8(%ebx),%edx
801017e3:	85 d2                	test   %edx,%edx
801017e5:	0f 8e ac 00 00 00    	jle    80101897 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017eb:	83 ec 0c             	sub    $0xc,%esp
801017ee:	8d 43 0c             	lea    0xc(%ebx),%eax
801017f1:	50                   	push   %eax
801017f2:	e8 99 2c 00 00       	call   80104490 <acquiresleep>
  if(ip->valid == 0){
801017f7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017fa:	83 c4 10             	add    $0x10,%esp
801017fd:	85 c0                	test   %eax,%eax
801017ff:	74 0f                	je     80101810 <ilock+0x40>
}
80101801:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101804:	5b                   	pop    %ebx
80101805:	5e                   	pop    %esi
80101806:	5d                   	pop    %ebp
80101807:	c3                   	ret
80101808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010180f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101810:	8b 43 04             	mov    0x4(%ebx),%eax
80101813:	83 ec 08             	sub    $0x8,%esp
80101816:	c1 e8 03             	shr    $0x3,%eax
80101819:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010181f:	50                   	push   %eax
80101820:	ff 33                	push   (%ebx)
80101822:	e8 a9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101827:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010182a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010182c:	8b 43 04             	mov    0x4(%ebx),%eax
8010182f:	83 e0 07             	and    $0x7,%eax
80101832:	c1 e0 06             	shl    $0x6,%eax
80101835:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101839:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010183c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010183f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101843:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101847:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010184b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010184f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101853:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101857:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010185b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010185e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101861:	6a 34                	push   $0x34
80101863:	50                   	push   %eax
80101864:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101867:	50                   	push   %eax
80101868:	e8 63 30 00 00       	call   801048d0 <memmove>
    brelse(bp);
8010186d:	89 34 24             	mov    %esi,(%esp)
80101870:	e8 7b e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101875:	83 c4 10             	add    $0x10,%esp
80101878:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010187d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101884:	0f 85 77 ff ff ff    	jne    80101801 <ilock+0x31>
      panic("ilock: no type");
8010188a:	83 ec 0c             	sub    $0xc,%esp
8010188d:	68 30 77 10 80       	push   $0x80107730
80101892:	e8 e9 ea ff ff       	call   80100380 <panic>
    panic("ilock");
80101897:	83 ec 0c             	sub    $0xc,%esp
8010189a:	68 2a 77 10 80       	push   $0x8010772a
8010189f:	e8 dc ea ff ff       	call   80100380 <panic>
801018a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iunlock>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	56                   	push   %esi
801018b4:	53                   	push   %ebx
801018b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018b8:	85 db                	test   %ebx,%ebx
801018ba:	74 28                	je     801018e4 <iunlock+0x34>
801018bc:	83 ec 0c             	sub    $0xc,%esp
801018bf:	8d 73 0c             	lea    0xc(%ebx),%esi
801018c2:	56                   	push   %esi
801018c3:	e8 68 2c 00 00       	call   80104530 <holdingsleep>
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 c0                	test   %eax,%eax
801018cd:	74 15                	je     801018e4 <iunlock+0x34>
801018cf:	8b 43 08             	mov    0x8(%ebx),%eax
801018d2:	85 c0                	test   %eax,%eax
801018d4:	7e 0e                	jle    801018e4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018d6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018dc:	5b                   	pop    %ebx
801018dd:	5e                   	pop    %esi
801018de:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018df:	e9 0c 2c 00 00       	jmp    801044f0 <releasesleep>
    panic("iunlock");
801018e4:	83 ec 0c             	sub    $0xc,%esp
801018e7:	68 3f 77 10 80       	push   $0x8010773f
801018ec:	e8 8f ea ff ff       	call   80100380 <panic>
801018f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018ff:	90                   	nop

80101900 <iput>:
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	57                   	push   %edi
80101904:	56                   	push   %esi
80101905:	53                   	push   %ebx
80101906:	83 ec 28             	sub    $0x28,%esp
80101909:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010190c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010190f:	57                   	push   %edi
80101910:	e8 7b 2b 00 00       	call   80104490 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101915:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101918:	83 c4 10             	add    $0x10,%esp
8010191b:	85 d2                	test   %edx,%edx
8010191d:	74 07                	je     80101926 <iput+0x26>
8010191f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101924:	74 32                	je     80101958 <iput+0x58>
  releasesleep(&ip->lock);
80101926:	83 ec 0c             	sub    $0xc,%esp
80101929:	57                   	push   %edi
8010192a:	e8 c1 2b 00 00       	call   801044f0 <releasesleep>
  acquire(&icache.lock);
8010192f:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101936:	e8 25 2e 00 00       	call   80104760 <acquire>
  ip->ref--;
8010193b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010193f:	83 c4 10             	add    $0x10,%esp
80101942:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101949:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010194c:	5b                   	pop    %ebx
8010194d:	5e                   	pop    %esi
8010194e:	5f                   	pop    %edi
8010194f:	5d                   	pop    %ebp
  release(&icache.lock);
80101950:	e9 ab 2d 00 00       	jmp    80104700 <release>
80101955:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101958:	83 ec 0c             	sub    $0xc,%esp
8010195b:	68 60 f9 10 80       	push   $0x8010f960
80101960:	e8 fb 2d 00 00       	call   80104760 <acquire>
    int r = ip->ref;
80101965:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101968:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010196f:	e8 8c 2d 00 00       	call   80104700 <release>
    if(r == 1){
80101974:	83 c4 10             	add    $0x10,%esp
80101977:	83 fe 01             	cmp    $0x1,%esi
8010197a:	75 aa                	jne    80101926 <iput+0x26>
8010197c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101982:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101985:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101988:	89 df                	mov    %ebx,%edi
8010198a:	89 cb                	mov    %ecx,%ebx
8010198c:	eb 09                	jmp    80101997 <iput+0x97>
8010198e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101990:	83 c6 04             	add    $0x4,%esi
80101993:	39 de                	cmp    %ebx,%esi
80101995:	74 19                	je     801019b0 <iput+0xb0>
    if(ip->addrs[i]){
80101997:	8b 16                	mov    (%esi),%edx
80101999:	85 d2                	test   %edx,%edx
8010199b:	74 f3                	je     80101990 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010199d:	8b 07                	mov    (%edi),%eax
8010199f:	e8 7c fa ff ff       	call   80101420 <bfree>
      ip->addrs[i] = 0;
801019a4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019aa:	eb e4                	jmp    80101990 <iput+0x90>
801019ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019b0:	89 fb                	mov    %edi,%ebx
801019b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019b5:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019bb:	85 c0                	test   %eax,%eax
801019bd:	75 2d                	jne    801019ec <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019bf:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019c2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019c9:	53                   	push   %ebx
801019ca:	e8 51 fd ff ff       	call   80101720 <iupdate>
      ip->type = 0;
801019cf:	31 c0                	xor    %eax,%eax
801019d1:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019d5:	89 1c 24             	mov    %ebx,(%esp)
801019d8:	e8 43 fd ff ff       	call   80101720 <iupdate>
      ip->valid = 0;
801019dd:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019e4:	83 c4 10             	add    $0x10,%esp
801019e7:	e9 3a ff ff ff       	jmp    80101926 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019ec:	83 ec 08             	sub    $0x8,%esp
801019ef:	50                   	push   %eax
801019f0:	ff 33                	push   (%ebx)
801019f2:	e8 d9 e6 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801019f7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019fa:	83 c4 10             	add    $0x10,%esp
801019fd:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a03:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101a06:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a09:	89 cf                	mov    %ecx,%edi
80101a0b:	eb 0a                	jmp    80101a17 <iput+0x117>
80101a0d:	8d 76 00             	lea    0x0(%esi),%esi
80101a10:	83 c6 04             	add    $0x4,%esi
80101a13:	39 fe                	cmp    %edi,%esi
80101a15:	74 0f                	je     80101a26 <iput+0x126>
      if(a[j])
80101a17:	8b 16                	mov    (%esi),%edx
80101a19:	85 d2                	test   %edx,%edx
80101a1b:	74 f3                	je     80101a10 <iput+0x110>
        bfree(ip->dev, a[j]);
80101a1d:	8b 03                	mov    (%ebx),%eax
80101a1f:	e8 fc f9 ff ff       	call   80101420 <bfree>
80101a24:	eb ea                	jmp    80101a10 <iput+0x110>
    brelse(bp);
80101a26:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a29:	83 ec 0c             	sub    $0xc,%esp
80101a2c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a2f:	50                   	push   %eax
80101a30:	e8 bb e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a35:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a3b:	8b 03                	mov    (%ebx),%eax
80101a3d:	e8 de f9 ff ff       	call   80101420 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a42:	83 c4 10             	add    $0x10,%esp
80101a45:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a4c:	00 00 00 
80101a4f:	e9 6b ff ff ff       	jmp    801019bf <iput+0xbf>
80101a54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a5f:	90                   	nop

80101a60 <iunlockput>:
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	56                   	push   %esi
80101a64:	53                   	push   %ebx
80101a65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a68:	85 db                	test   %ebx,%ebx
80101a6a:	74 34                	je     80101aa0 <iunlockput+0x40>
80101a6c:	83 ec 0c             	sub    $0xc,%esp
80101a6f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a72:	56                   	push   %esi
80101a73:	e8 b8 2a 00 00       	call   80104530 <holdingsleep>
80101a78:	83 c4 10             	add    $0x10,%esp
80101a7b:	85 c0                	test   %eax,%eax
80101a7d:	74 21                	je     80101aa0 <iunlockput+0x40>
80101a7f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a82:	85 c0                	test   %eax,%eax
80101a84:	7e 1a                	jle    80101aa0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a86:	83 ec 0c             	sub    $0xc,%esp
80101a89:	56                   	push   %esi
80101a8a:	e8 61 2a 00 00       	call   801044f0 <releasesleep>
  iput(ip);
80101a8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a92:	83 c4 10             	add    $0x10,%esp
}
80101a95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a98:	5b                   	pop    %ebx
80101a99:	5e                   	pop    %esi
80101a9a:	5d                   	pop    %ebp
  iput(ip);
80101a9b:	e9 60 fe ff ff       	jmp    80101900 <iput>
    panic("iunlock");
80101aa0:	83 ec 0c             	sub    $0xc,%esp
80101aa3:	68 3f 77 10 80       	push   $0x8010773f
80101aa8:	e8 d3 e8 ff ff       	call   80100380 <panic>
80101aad:	8d 76 00             	lea    0x0(%esi),%esi

80101ab0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ab9:	8b 0a                	mov    (%edx),%ecx
80101abb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101abe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ac1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ac4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ac8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101acb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101acf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101ad3:	8b 52 58             	mov    0x58(%edx),%edx
80101ad6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ad9:	5d                   	pop    %ebp
80101ada:	c3                   	ret
80101adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101adf:	90                   	nop

80101ae0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	57                   	push   %edi
80101ae4:	56                   	push   %esi
80101ae5:	53                   	push   %ebx
80101ae6:	83 ec 1c             	sub    $0x1c,%esp
80101ae9:	8b 75 08             	mov    0x8(%ebp),%esi
80101aec:	8b 45 0c             	mov    0xc(%ebp),%eax
80101aef:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101af2:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101af7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101afa:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101afd:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101b00:	0f 84 aa 00 00 00    	je     80101bb0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b06:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101b09:	8b 56 58             	mov    0x58(%esi),%edx
80101b0c:	39 fa                	cmp    %edi,%edx
80101b0e:	0f 82 bd 00 00 00    	jb     80101bd1 <readi+0xf1>
80101b14:	89 f9                	mov    %edi,%ecx
80101b16:	31 db                	xor    %ebx,%ebx
80101b18:	01 c1                	add    %eax,%ecx
80101b1a:	0f 92 c3             	setb   %bl
80101b1d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101b20:	0f 82 ab 00 00 00    	jb     80101bd1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b26:	89 d3                	mov    %edx,%ebx
80101b28:	29 fb                	sub    %edi,%ebx
80101b2a:	39 ca                	cmp    %ecx,%edx
80101b2c:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	85 c0                	test   %eax,%eax
80101b31:	74 73                	je     80101ba6 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b33:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b40:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b43:	89 fa                	mov    %edi,%edx
80101b45:	c1 ea 09             	shr    $0x9,%edx
80101b48:	89 d8                	mov    %ebx,%eax
80101b4a:	e8 51 f9 ff ff       	call   801014a0 <bmap>
80101b4f:	83 ec 08             	sub    $0x8,%esp
80101b52:	50                   	push   %eax
80101b53:	ff 33                	push   (%ebx)
80101b55:	e8 76 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b5a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b5d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b62:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b64:	89 f8                	mov    %edi,%eax
80101b66:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b6b:	29 f3                	sub    %esi,%ebx
80101b6d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b6f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b73:	39 d9                	cmp    %ebx,%ecx
80101b75:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b78:	83 c4 0c             	add    $0xc,%esp
80101b7b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b7c:	01 de                	add    %ebx,%esi
80101b7e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101b80:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101b83:	50                   	push   %eax
80101b84:	ff 75 e0             	push   -0x20(%ebp)
80101b87:	e8 44 2d 00 00       	call   801048d0 <memmove>
    brelse(bp);
80101b8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b8f:	89 14 24             	mov    %edx,(%esp)
80101b92:	e8 59 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b97:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b9a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b9d:	83 c4 10             	add    $0x10,%esp
80101ba0:	39 de                	cmp    %ebx,%esi
80101ba2:	72 9c                	jb     80101b40 <readi+0x60>
80101ba4:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101ba6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ba9:	5b                   	pop    %ebx
80101baa:	5e                   	pop    %esi
80101bab:	5f                   	pop    %edi
80101bac:	5d                   	pop    %ebp
80101bad:	c3                   	ret
80101bae:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101bb0:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101bb4:	66 83 fa 09          	cmp    $0x9,%dx
80101bb8:	77 17                	ja     80101bd1 <readi+0xf1>
80101bba:	8b 14 d5 00 f9 10 80 	mov    -0x7fef0700(,%edx,8),%edx
80101bc1:	85 d2                	test   %edx,%edx
80101bc3:	74 0c                	je     80101bd1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101bc5:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101bc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bcb:	5b                   	pop    %ebx
80101bcc:	5e                   	pop    %esi
80101bcd:	5f                   	pop    %edi
80101bce:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bcf:	ff e2                	jmp    *%edx
      return -1;
80101bd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bd6:	eb ce                	jmp    80101ba6 <readi+0xc6>
80101bd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bdf:	90                   	nop

80101be0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	57                   	push   %edi
80101be4:	56                   	push   %esi
80101be5:	53                   	push   %ebx
80101be6:	83 ec 1c             	sub    $0x1c,%esp
80101be9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bec:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101bef:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bf2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bf7:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101bfa:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101bfd:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101c00:	0f 84 ca 00 00 00    	je     80101cd0 <writei+0xf0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c06:	39 78 58             	cmp    %edi,0x58(%eax)
80101c09:	0f 82 fa 00 00 00    	jb     80101d09 <writei+0x129>
80101c0f:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101c12:	31 c9                	xor    %ecx,%ecx
80101c14:	89 f2                	mov    %esi,%edx
80101c16:	01 fa                	add    %edi,%edx
80101c18:	0f 92 c1             	setb   %cl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c1b:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101c21:	0f 87 e2 00 00 00    	ja     80101d09 <writei+0x129>
80101c27:	85 c9                	test   %ecx,%ecx
80101c29:	0f 85 da 00 00 00    	jne    80101d09 <writei+0x129>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2f:	85 f6                	test   %esi,%esi
80101c31:	0f 84 86 00 00 00    	je     80101cbd <writei+0xdd>
80101c37:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c3e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c48:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c4b:	89 fa                	mov    %edi,%edx
80101c4d:	c1 ea 09             	shr    $0x9,%edx
80101c50:	89 f0                	mov    %esi,%eax
80101c52:	e8 49 f8 ff ff       	call   801014a0 <bmap>
80101c57:	83 ec 08             	sub    $0x8,%esp
80101c5a:	50                   	push   %eax
80101c5b:	ff 36                	push   (%esi)
80101c5d:	e8 6e e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c62:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c65:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c68:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c6d:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c6f:	89 f8                	mov    %edi,%eax
80101c71:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c76:	29 d3                	sub    %edx,%ebx
80101c78:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c7a:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c7e:	39 d9                	cmp    %ebx,%ecx
80101c80:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c83:	83 c4 0c             	add    $0xc,%esp
80101c86:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c87:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101c89:	ff 75 dc             	push   -0x24(%ebp)
80101c8c:	50                   	push   %eax
80101c8d:	e8 3e 2c 00 00       	call   801048d0 <memmove>
    log_write(bp);
80101c92:	89 34 24             	mov    %esi,(%esp)
80101c95:	e8 16 13 00 00       	call   80102fb0 <log_write>
    brelse(bp);
80101c9a:	89 34 24             	mov    %esi,(%esp)
80101c9d:	e8 4e e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ca2:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101ca5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ca8:	83 c4 10             	add    $0x10,%esp
80101cab:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cae:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101cb1:	39 d8                	cmp    %ebx,%eax
80101cb3:	72 93                	jb     80101c48 <writei+0x68>
  }

  if(n > 0 && off > ip->size){
80101cb5:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cb8:	39 78 58             	cmp    %edi,0x58(%eax)
80101cbb:	72 3b                	jb     80101cf8 <writei+0x118>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101cbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101cc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cc3:	5b                   	pop    %ebx
80101cc4:	5e                   	pop    %esi
80101cc5:	5f                   	pop    %edi
80101cc6:	5d                   	pop    %ebp
80101cc7:	c3                   	ret
80101cc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ccf:	90                   	nop
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cd0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cd4:	66 83 f8 09          	cmp    $0x9,%ax
80101cd8:	77 2f                	ja     80101d09 <writei+0x129>
80101cda:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101ce1:	85 c0                	test   %eax,%eax
80101ce3:	74 24                	je     80101d09 <writei+0x129>
    return devsw[ip->major].write(ip, src, n);
80101ce5:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ceb:	5b                   	pop    %ebx
80101cec:	5e                   	pop    %esi
80101ced:	5f                   	pop    %edi
80101cee:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101cef:	ff e0                	jmp    *%eax
80101cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101cf8:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cfb:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101cfe:	50                   	push   %eax
80101cff:	e8 1c fa ff ff       	call   80101720 <iupdate>
80101d04:	83 c4 10             	add    $0x10,%esp
80101d07:	eb b4                	jmp    80101cbd <writei+0xdd>
      return -1;
80101d09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d0e:	eb b0                	jmp    80101cc0 <writei+0xe0>

80101d10 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d10:	55                   	push   %ebp
80101d11:	89 e5                	mov    %esp,%ebp
80101d13:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d16:	6a 0e                	push   $0xe
80101d18:	ff 75 0c             	push   0xc(%ebp)
80101d1b:	ff 75 08             	push   0x8(%ebp)
80101d1e:	e8 1d 2c 00 00       	call   80104940 <strncmp>
}
80101d23:	c9                   	leave
80101d24:	c3                   	ret
80101d25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d30 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	57                   	push   %edi
80101d34:	56                   	push   %esi
80101d35:	53                   	push   %ebx
80101d36:	83 ec 1c             	sub    $0x1c,%esp
80101d39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d3c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d41:	0f 85 85 00 00 00    	jne    80101dcc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d47:	8b 53 58             	mov    0x58(%ebx),%edx
80101d4a:	31 ff                	xor    %edi,%edi
80101d4c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d4f:	85 d2                	test   %edx,%edx
80101d51:	74 3e                	je     80101d91 <dirlookup+0x61>
80101d53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d57:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d58:	6a 10                	push   $0x10
80101d5a:	57                   	push   %edi
80101d5b:	56                   	push   %esi
80101d5c:	53                   	push   %ebx
80101d5d:	e8 7e fd ff ff       	call   80101ae0 <readi>
80101d62:	83 c4 10             	add    $0x10,%esp
80101d65:	83 f8 10             	cmp    $0x10,%eax
80101d68:	75 55                	jne    80101dbf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d6f:	74 18                	je     80101d89 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d71:	83 ec 04             	sub    $0x4,%esp
80101d74:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d77:	6a 0e                	push   $0xe
80101d79:	50                   	push   %eax
80101d7a:	ff 75 0c             	push   0xc(%ebp)
80101d7d:	e8 be 2b 00 00       	call   80104940 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d82:	83 c4 10             	add    $0x10,%esp
80101d85:	85 c0                	test   %eax,%eax
80101d87:	74 17                	je     80101da0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d89:	83 c7 10             	add    $0x10,%edi
80101d8c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d8f:	72 c7                	jb     80101d58 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d94:	31 c0                	xor    %eax,%eax
}
80101d96:	5b                   	pop    %ebx
80101d97:	5e                   	pop    %esi
80101d98:	5f                   	pop    %edi
80101d99:	5d                   	pop    %ebp
80101d9a:	c3                   	ret
80101d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d9f:	90                   	nop
      if(poff)
80101da0:	8b 45 10             	mov    0x10(%ebp),%eax
80101da3:	85 c0                	test   %eax,%eax
80101da5:	74 05                	je     80101dac <dirlookup+0x7c>
        *poff = off;
80101da7:	8b 45 10             	mov    0x10(%ebp),%eax
80101daa:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101dac:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101db0:	8b 03                	mov    (%ebx),%eax
80101db2:	e8 69 f5 ff ff       	call   80101320 <iget>
}
80101db7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dba:	5b                   	pop    %ebx
80101dbb:	5e                   	pop    %esi
80101dbc:	5f                   	pop    %edi
80101dbd:	5d                   	pop    %ebp
80101dbe:	c3                   	ret
      panic("dirlookup read");
80101dbf:	83 ec 0c             	sub    $0xc,%esp
80101dc2:	68 59 77 10 80       	push   $0x80107759
80101dc7:	e8 b4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101dcc:	83 ec 0c             	sub    $0xc,%esp
80101dcf:	68 47 77 10 80       	push   $0x80107747
80101dd4:	e8 a7 e5 ff ff       	call   80100380 <panic>
80101dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101de0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101de0:	55                   	push   %ebp
80101de1:	89 e5                	mov    %esp,%ebp
80101de3:	57                   	push   %edi
80101de4:	56                   	push   %esi
80101de5:	53                   	push   %ebx
80101de6:	89 c3                	mov    %eax,%ebx
80101de8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101deb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dee:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101df1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101df4:	0f 84 64 01 00 00    	je     80101f5e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dfa:	e8 21 1c 00 00       	call   80103a20 <myproc>
  acquire(&icache.lock);
80101dff:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e02:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e05:	68 60 f9 10 80       	push   $0x8010f960
80101e0a:	e8 51 29 00 00       	call   80104760 <acquire>
  ip->ref++;
80101e0f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e13:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101e1a:	e8 e1 28 00 00       	call   80104700 <release>
80101e1f:	83 c4 10             	add    $0x10,%esp
80101e22:	eb 07                	jmp    80101e2b <namex+0x4b>
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e28:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e2b:	0f b6 03             	movzbl (%ebx),%eax
80101e2e:	3c 2f                	cmp    $0x2f,%al
80101e30:	74 f6                	je     80101e28 <namex+0x48>
  if(*path == 0)
80101e32:	84 c0                	test   %al,%al
80101e34:	0f 84 06 01 00 00    	je     80101f40 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e3a:	0f b6 03             	movzbl (%ebx),%eax
80101e3d:	84 c0                	test   %al,%al
80101e3f:	0f 84 10 01 00 00    	je     80101f55 <namex+0x175>
80101e45:	89 df                	mov    %ebx,%edi
80101e47:	3c 2f                	cmp    $0x2f,%al
80101e49:	0f 84 06 01 00 00    	je     80101f55 <namex+0x175>
80101e4f:	90                   	nop
80101e50:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e54:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e57:	3c 2f                	cmp    $0x2f,%al
80101e59:	74 04                	je     80101e5f <namex+0x7f>
80101e5b:	84 c0                	test   %al,%al
80101e5d:	75 f1                	jne    80101e50 <namex+0x70>
  len = path - s;
80101e5f:	89 f8                	mov    %edi,%eax
80101e61:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e63:	83 f8 0d             	cmp    $0xd,%eax
80101e66:	0f 8e ac 00 00 00    	jle    80101f18 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e6c:	83 ec 04             	sub    $0x4,%esp
80101e6f:	6a 0e                	push   $0xe
80101e71:	53                   	push   %ebx
    path++;
80101e72:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e74:	ff 75 e4             	push   -0x1c(%ebp)
80101e77:	e8 54 2a 00 00       	call   801048d0 <memmove>
80101e7c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e7f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e82:	75 0c                	jne    80101e90 <namex+0xb0>
80101e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e88:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e8b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e8e:	74 f8                	je     80101e88 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e90:	83 ec 0c             	sub    $0xc,%esp
80101e93:	56                   	push   %esi
80101e94:	e8 37 f9 ff ff       	call   801017d0 <ilock>
    if(ip->type != T_DIR){
80101e99:	83 c4 10             	add    $0x10,%esp
80101e9c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ea1:	0f 85 cd 00 00 00    	jne    80101f74 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101ea7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eaa:	85 c0                	test   %eax,%eax
80101eac:	74 09                	je     80101eb7 <namex+0xd7>
80101eae:	80 3b 00             	cmpb   $0x0,(%ebx)
80101eb1:	0f 84 34 01 00 00    	je     80101feb <namex+0x20b>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101eb7:	83 ec 04             	sub    $0x4,%esp
80101eba:	6a 00                	push   $0x0
80101ebc:	ff 75 e4             	push   -0x1c(%ebp)
80101ebf:	56                   	push   %esi
80101ec0:	e8 6b fe ff ff       	call   80101d30 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ec5:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101ec8:	83 c4 10             	add    $0x10,%esp
80101ecb:	89 c7                	mov    %eax,%edi
80101ecd:	85 c0                	test   %eax,%eax
80101ecf:	0f 84 e1 00 00 00    	je     80101fb6 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	52                   	push   %edx
80101ed9:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101edc:	e8 4f 26 00 00       	call   80104530 <holdingsleep>
80101ee1:	83 c4 10             	add    $0x10,%esp
80101ee4:	85 c0                	test   %eax,%eax
80101ee6:	0f 84 3f 01 00 00    	je     8010202b <namex+0x24b>
80101eec:	8b 56 08             	mov    0x8(%esi),%edx
80101eef:	85 d2                	test   %edx,%edx
80101ef1:	0f 8e 34 01 00 00    	jle    8010202b <namex+0x24b>
  releasesleep(&ip->lock);
80101ef7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101efa:	83 ec 0c             	sub    $0xc,%esp
80101efd:	52                   	push   %edx
80101efe:	e8 ed 25 00 00       	call   801044f0 <releasesleep>
  iput(ip);
80101f03:	89 34 24             	mov    %esi,(%esp)
80101f06:	89 fe                	mov    %edi,%esi
80101f08:	e8 f3 f9 ff ff       	call   80101900 <iput>
80101f0d:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f10:	e9 16 ff ff ff       	jmp    80101e2b <namex+0x4b>
80101f15:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101f18:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f1b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101f1e:	83 ec 04             	sub    $0x4,%esp
80101f21:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101f24:	50                   	push   %eax
80101f25:	53                   	push   %ebx
    name[len] = 0;
80101f26:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101f28:	ff 75 e4             	push   -0x1c(%ebp)
80101f2b:	e8 a0 29 00 00       	call   801048d0 <memmove>
    name[len] = 0;
80101f30:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f33:	83 c4 10             	add    $0x10,%esp
80101f36:	c6 02 00             	movb   $0x0,(%edx)
80101f39:	e9 41 ff ff ff       	jmp    80101e7f <namex+0x9f>
80101f3e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f40:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f43:	85 c0                	test   %eax,%eax
80101f45:	0f 85 d0 00 00 00    	jne    8010201b <namex+0x23b>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f4e:	89 f0                	mov    %esi,%eax
80101f50:	5b                   	pop    %ebx
80101f51:	5e                   	pop    %esi
80101f52:	5f                   	pop    %edi
80101f53:	5d                   	pop    %ebp
80101f54:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f55:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f58:	89 df                	mov    %ebx,%edi
80101f5a:	31 c0                	xor    %eax,%eax
80101f5c:	eb c0                	jmp    80101f1e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f5e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f63:	b8 01 00 00 00       	mov    $0x1,%eax
80101f68:	e8 b3 f3 ff ff       	call   80101320 <iget>
80101f6d:	89 c6                	mov    %eax,%esi
80101f6f:	e9 b7 fe ff ff       	jmp    80101e2b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f74:	83 ec 0c             	sub    $0xc,%esp
80101f77:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f7a:	53                   	push   %ebx
80101f7b:	e8 b0 25 00 00       	call   80104530 <holdingsleep>
80101f80:	83 c4 10             	add    $0x10,%esp
80101f83:	85 c0                	test   %eax,%eax
80101f85:	0f 84 a0 00 00 00    	je     8010202b <namex+0x24b>
80101f8b:	8b 46 08             	mov    0x8(%esi),%eax
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	0f 8e 95 00 00 00    	jle    8010202b <namex+0x24b>
  releasesleep(&ip->lock);
80101f96:	83 ec 0c             	sub    $0xc,%esp
80101f99:	53                   	push   %ebx
80101f9a:	e8 51 25 00 00       	call   801044f0 <releasesleep>
  iput(ip);
80101f9f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fa2:	31 f6                	xor    %esi,%esi
  iput(ip);
80101fa4:	e8 57 f9 ff ff       	call   80101900 <iput>
      return 0;
80101fa9:	83 c4 10             	add    $0x10,%esp
}
80101fac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101faf:	89 f0                	mov    %esi,%eax
80101fb1:	5b                   	pop    %ebx
80101fb2:	5e                   	pop    %esi
80101fb3:	5f                   	pop    %edi
80101fb4:	5d                   	pop    %ebp
80101fb5:	c3                   	ret
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fb6:	83 ec 0c             	sub    $0xc,%esp
80101fb9:	52                   	push   %edx
80101fba:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101fbd:	e8 6e 25 00 00       	call   80104530 <holdingsleep>
80101fc2:	83 c4 10             	add    $0x10,%esp
80101fc5:	85 c0                	test   %eax,%eax
80101fc7:	74 62                	je     8010202b <namex+0x24b>
80101fc9:	8b 4e 08             	mov    0x8(%esi),%ecx
80101fcc:	85 c9                	test   %ecx,%ecx
80101fce:	7e 5b                	jle    8010202b <namex+0x24b>
  releasesleep(&ip->lock);
80101fd0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101fd3:	83 ec 0c             	sub    $0xc,%esp
80101fd6:	52                   	push   %edx
80101fd7:	e8 14 25 00 00       	call   801044f0 <releasesleep>
  iput(ip);
80101fdc:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fdf:	31 f6                	xor    %esi,%esi
  iput(ip);
80101fe1:	e8 1a f9 ff ff       	call   80101900 <iput>
      return 0;
80101fe6:	83 c4 10             	add    $0x10,%esp
80101fe9:	eb c1                	jmp    80101fac <namex+0x1cc>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101feb:	83 ec 0c             	sub    $0xc,%esp
80101fee:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101ff1:	53                   	push   %ebx
80101ff2:	e8 39 25 00 00       	call   80104530 <holdingsleep>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	74 2d                	je     8010202b <namex+0x24b>
80101ffe:	8b 7e 08             	mov    0x8(%esi),%edi
80102001:	85 ff                	test   %edi,%edi
80102003:	7e 26                	jle    8010202b <namex+0x24b>
  releasesleep(&ip->lock);
80102005:	83 ec 0c             	sub    $0xc,%esp
80102008:	53                   	push   %ebx
80102009:	e8 e2 24 00 00       	call   801044f0 <releasesleep>
}
8010200e:	83 c4 10             	add    $0x10,%esp
}
80102011:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102014:	89 f0                	mov    %esi,%eax
80102016:	5b                   	pop    %ebx
80102017:	5e                   	pop    %esi
80102018:	5f                   	pop    %edi
80102019:	5d                   	pop    %ebp
8010201a:	c3                   	ret
    iput(ip);
8010201b:	83 ec 0c             	sub    $0xc,%esp
8010201e:	56                   	push   %esi
      return 0;
8010201f:	31 f6                	xor    %esi,%esi
    iput(ip);
80102021:	e8 da f8 ff ff       	call   80101900 <iput>
    return 0;
80102026:	83 c4 10             	add    $0x10,%esp
80102029:	eb 81                	jmp    80101fac <namex+0x1cc>
    panic("iunlock");
8010202b:	83 ec 0c             	sub    $0xc,%esp
8010202e:	68 3f 77 10 80       	push   $0x8010773f
80102033:	e8 48 e3 ff ff       	call   80100380 <panic>
80102038:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010203f:	90                   	nop

80102040 <dirlink>:
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	57                   	push   %edi
80102044:	56                   	push   %esi
80102045:	53                   	push   %ebx
80102046:	83 ec 20             	sub    $0x20,%esp
80102049:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010204c:	6a 00                	push   $0x0
8010204e:	ff 75 0c             	push   0xc(%ebp)
80102051:	53                   	push   %ebx
80102052:	e8 d9 fc ff ff       	call   80101d30 <dirlookup>
80102057:	83 c4 10             	add    $0x10,%esp
8010205a:	85 c0                	test   %eax,%eax
8010205c:	75 67                	jne    801020c5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010205e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102061:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102064:	85 ff                	test   %edi,%edi
80102066:	74 29                	je     80102091 <dirlink+0x51>
80102068:	31 ff                	xor    %edi,%edi
8010206a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010206d:	eb 09                	jmp    80102078 <dirlink+0x38>
8010206f:	90                   	nop
80102070:	83 c7 10             	add    $0x10,%edi
80102073:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102076:	73 19                	jae    80102091 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102078:	6a 10                	push   $0x10
8010207a:	57                   	push   %edi
8010207b:	56                   	push   %esi
8010207c:	53                   	push   %ebx
8010207d:	e8 5e fa ff ff       	call   80101ae0 <readi>
80102082:	83 c4 10             	add    $0x10,%esp
80102085:	83 f8 10             	cmp    $0x10,%eax
80102088:	75 4e                	jne    801020d8 <dirlink+0x98>
    if(de.inum == 0)
8010208a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010208f:	75 df                	jne    80102070 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102091:	83 ec 04             	sub    $0x4,%esp
80102094:	8d 45 da             	lea    -0x26(%ebp),%eax
80102097:	6a 0e                	push   $0xe
80102099:	ff 75 0c             	push   0xc(%ebp)
8010209c:	50                   	push   %eax
8010209d:	e8 ee 28 00 00       	call   80104990 <strncpy>
  de.inum = inum;
801020a2:	8b 45 10             	mov    0x10(%ebp),%eax
801020a5:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020a9:	6a 10                	push   $0x10
801020ab:	57                   	push   %edi
801020ac:	56                   	push   %esi
801020ad:	53                   	push   %ebx
801020ae:	e8 2d fb ff ff       	call   80101be0 <writei>
801020b3:	83 c4 20             	add    $0x20,%esp
801020b6:	83 f8 10             	cmp    $0x10,%eax
801020b9:	75 2a                	jne    801020e5 <dirlink+0xa5>
  return 0;
801020bb:	31 c0                	xor    %eax,%eax
}
801020bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020c0:	5b                   	pop    %ebx
801020c1:	5e                   	pop    %esi
801020c2:	5f                   	pop    %edi
801020c3:	5d                   	pop    %ebp
801020c4:	c3                   	ret
    iput(ip);
801020c5:	83 ec 0c             	sub    $0xc,%esp
801020c8:	50                   	push   %eax
801020c9:	e8 32 f8 ff ff       	call   80101900 <iput>
    return -1;
801020ce:	83 c4 10             	add    $0x10,%esp
801020d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020d6:	eb e5                	jmp    801020bd <dirlink+0x7d>
      panic("dirlink read");
801020d8:	83 ec 0c             	sub    $0xc,%esp
801020db:	68 68 77 10 80       	push   $0x80107768
801020e0:	e8 9b e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
801020e5:	83 ec 0c             	sub    $0xc,%esp
801020e8:	68 6a 7d 10 80       	push   $0x80107d6a
801020ed:	e8 8e e2 ff ff       	call   80100380 <panic>
801020f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102100 <namei>:

struct inode*
namei(char *path)
{
80102100:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102101:	31 d2                	xor    %edx,%edx
{
80102103:	89 e5                	mov    %esp,%ebp
80102105:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102108:	8b 45 08             	mov    0x8(%ebp),%eax
8010210b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010210e:	e8 cd fc ff ff       	call   80101de0 <namex>
}
80102113:	c9                   	leave
80102114:	c3                   	ret
80102115:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102120 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102120:	55                   	push   %ebp
  return namex(path, 1, name);
80102121:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102126:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102128:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010212b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010212e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010212f:	e9 ac fc ff ff       	jmp    80101de0 <namex>
80102134:	66 90                	xchg   %ax,%ax
80102136:	66 90                	xchg   %ax,%ax
80102138:	66 90                	xchg   %ax,%ax
8010213a:	66 90                	xchg   %ax,%ax
8010213c:	66 90                	xchg   %ax,%ax
8010213e:	66 90                	xchg   %ax,%ax

80102140 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	57                   	push   %edi
80102144:	56                   	push   %esi
80102145:	53                   	push   %ebx
80102146:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102149:	85 c0                	test   %eax,%eax
8010214b:	0f 84 b4 00 00 00    	je     80102205 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102151:	8b 70 08             	mov    0x8(%eax),%esi
80102154:	89 c3                	mov    %eax,%ebx
80102156:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010215c:	0f 87 96 00 00 00    	ja     801021f8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102162:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010216e:	66 90                	xchg   %ax,%ax
80102170:	89 ca                	mov    %ecx,%edx
80102172:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102173:	83 e0 c0             	and    $0xffffffc0,%eax
80102176:	3c 40                	cmp    $0x40,%al
80102178:	75 f6                	jne    80102170 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010217a:	31 ff                	xor    %edi,%edi
8010217c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102181:	89 f8                	mov    %edi,%eax
80102183:	ee                   	out    %al,(%dx)
80102184:	b8 01 00 00 00       	mov    $0x1,%eax
80102189:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010218e:	ee                   	out    %al,(%dx)
8010218f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102194:	89 f0                	mov    %esi,%eax
80102196:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102197:	89 f0                	mov    %esi,%eax
80102199:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010219e:	c1 f8 08             	sar    $0x8,%eax
801021a1:	ee                   	out    %al,(%dx)
801021a2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021a7:	89 f8                	mov    %edi,%eax
801021a9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801021aa:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801021ae:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021b3:	c1 e0 04             	shl    $0x4,%eax
801021b6:	83 e0 10             	and    $0x10,%eax
801021b9:	83 c8 e0             	or     $0xffffffe0,%eax
801021bc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801021bd:	f6 03 04             	testb  $0x4,(%ebx)
801021c0:	75 16                	jne    801021d8 <idestart+0x98>
801021c2:	b8 20 00 00 00       	mov    $0x20,%eax
801021c7:	89 ca                	mov    %ecx,%edx
801021c9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021cd:	5b                   	pop    %ebx
801021ce:	5e                   	pop    %esi
801021cf:	5f                   	pop    %edi
801021d0:	5d                   	pop    %ebp
801021d1:	c3                   	ret
801021d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021d8:	b8 30 00 00 00       	mov    $0x30,%eax
801021dd:	89 ca                	mov    %ecx,%edx
801021df:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801021e0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801021e5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801021e8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021ed:	fc                   	cld
801021ee:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021f3:	5b                   	pop    %ebx
801021f4:	5e                   	pop    %esi
801021f5:	5f                   	pop    %edi
801021f6:	5d                   	pop    %ebp
801021f7:	c3                   	ret
    panic("incorrect blockno");
801021f8:	83 ec 0c             	sub    $0xc,%esp
801021fb:	68 d4 77 10 80       	push   $0x801077d4
80102200:	e8 7b e1 ff ff       	call   80100380 <panic>
    panic("idestart");
80102205:	83 ec 0c             	sub    $0xc,%esp
80102208:	68 cb 77 10 80       	push   $0x801077cb
8010220d:	e8 6e e1 ff ff       	call   80100380 <panic>
80102212:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102220 <ideinit>:
{
80102220:	55                   	push   %ebp
80102221:	89 e5                	mov    %esp,%ebp
80102223:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102226:	68 e6 77 10 80       	push   $0x801077e6
8010222b:	68 00 16 11 80       	push   $0x80111600
80102230:	e8 4b 23 00 00       	call   80104580 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102235:	58                   	pop    %eax
80102236:	a1 84 17 11 80       	mov    0x80111784,%eax
8010223b:	5a                   	pop    %edx
8010223c:	83 e8 01             	sub    $0x1,%eax
8010223f:	50                   	push   %eax
80102240:	6a 0e                	push   $0xe
80102242:	e8 99 02 00 00       	call   801024e0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102247:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010224a:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
8010224f:	90                   	nop
80102250:	89 ca                	mov    %ecx,%edx
80102252:	ec                   	in     (%dx),%al
80102253:	83 e0 c0             	and    $0xffffffc0,%eax
80102256:	3c 40                	cmp    $0x40,%al
80102258:	75 f6                	jne    80102250 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010225a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010225f:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102264:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102265:	89 ca                	mov    %ecx,%edx
80102267:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102268:	84 c0                	test   %al,%al
8010226a:	75 1e                	jne    8010228a <ideinit+0x6a>
8010226c:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102271:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i=0; i<1000; i++){
80102280:	83 e9 01             	sub    $0x1,%ecx
80102283:	74 0f                	je     80102294 <ideinit+0x74>
80102285:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102286:	84 c0                	test   %al,%al
80102288:	74 f6                	je     80102280 <ideinit+0x60>
      havedisk1 = 1;
8010228a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102291:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102294:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102299:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010229e:	ee                   	out    %al,(%dx)
}
8010229f:	c9                   	leave
801022a0:	c3                   	ret
801022a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022af:	90                   	nop

801022b0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	57                   	push   %edi
801022b4:	56                   	push   %esi
801022b5:	53                   	push   %ebx
801022b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022b9:	68 00 16 11 80       	push   $0x80111600
801022be:	e8 9d 24 00 00       	call   80104760 <acquire>

  if((b = idequeue) == 0){
801022c3:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
801022c9:	83 c4 10             	add    $0x10,%esp
801022cc:	85 db                	test   %ebx,%ebx
801022ce:	74 63                	je     80102333 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022d0:	8b 43 58             	mov    0x58(%ebx),%eax
801022d3:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022d8:	8b 33                	mov    (%ebx),%esi
801022da:	f7 c6 04 00 00 00    	test   $0x4,%esi
801022e0:	75 2f                	jne    80102311 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022e2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ee:	66 90                	xchg   %ax,%ax
801022f0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022f1:	89 c1                	mov    %eax,%ecx
801022f3:	83 e1 c0             	and    $0xffffffc0,%ecx
801022f6:	80 f9 40             	cmp    $0x40,%cl
801022f9:	75 f5                	jne    801022f0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022fb:	a8 21                	test   $0x21,%al
801022fd:	75 12                	jne    80102311 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801022ff:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102302:	b9 80 00 00 00       	mov    $0x80,%ecx
80102307:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010230c:	fc                   	cld
8010230d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010230f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102311:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102314:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102317:	83 ce 02             	or     $0x2,%esi
8010231a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010231c:	53                   	push   %ebx
8010231d:	e8 be 1e 00 00       	call   801041e0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102322:	a1 e4 15 11 80       	mov    0x801115e4,%eax
80102327:	83 c4 10             	add    $0x10,%esp
8010232a:	85 c0                	test   %eax,%eax
8010232c:	74 05                	je     80102333 <ideintr+0x83>
    idestart(idequeue);
8010232e:	e8 0d fe ff ff       	call   80102140 <idestart>
    release(&idelock);
80102333:	83 ec 0c             	sub    $0xc,%esp
80102336:	68 00 16 11 80       	push   $0x80111600
8010233b:	e8 c0 23 00 00       	call   80104700 <release>

  release(&idelock);
}
80102340:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102343:	5b                   	pop    %ebx
80102344:	5e                   	pop    %esi
80102345:	5f                   	pop    %edi
80102346:	5d                   	pop    %ebp
80102347:	c3                   	ret
80102348:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010234f:	90                   	nop

80102350 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	53                   	push   %ebx
80102354:	83 ec 10             	sub    $0x10,%esp
80102357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010235a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010235d:	50                   	push   %eax
8010235e:	e8 cd 21 00 00       	call   80104530 <holdingsleep>
80102363:	83 c4 10             	add    $0x10,%esp
80102366:	85 c0                	test   %eax,%eax
80102368:	0f 84 c3 00 00 00    	je     80102431 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 e0 06             	and    $0x6,%eax
80102373:	83 f8 02             	cmp    $0x2,%eax
80102376:	0f 84 a8 00 00 00    	je     80102424 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010237c:	8b 53 04             	mov    0x4(%ebx),%edx
8010237f:	85 d2                	test   %edx,%edx
80102381:	74 0d                	je     80102390 <iderw+0x40>
80102383:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102388:	85 c0                	test   %eax,%eax
8010238a:	0f 84 87 00 00 00    	je     80102417 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102390:	83 ec 0c             	sub    $0xc,%esp
80102393:	68 00 16 11 80       	push   $0x80111600
80102398:	e8 c3 23 00 00       	call   80104760 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010239d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
801023a2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a9:	83 c4 10             	add    $0x10,%esp
801023ac:	85 c0                	test   %eax,%eax
801023ae:	74 60                	je     80102410 <iderw+0xc0>
801023b0:	89 c2                	mov    %eax,%edx
801023b2:	8b 40 58             	mov    0x58(%eax),%eax
801023b5:	85 c0                	test   %eax,%eax
801023b7:	75 f7                	jne    801023b0 <iderw+0x60>
801023b9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801023bc:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801023be:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
801023c4:	74 3a                	je     80102400 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023c6:	8b 03                	mov    (%ebx),%eax
801023c8:	83 e0 06             	and    $0x6,%eax
801023cb:	83 f8 02             	cmp    $0x2,%eax
801023ce:	74 1b                	je     801023eb <iderw+0x9b>
    sleep(b, &idelock);
801023d0:	83 ec 08             	sub    $0x8,%esp
801023d3:	68 00 16 11 80       	push   $0x80111600
801023d8:	53                   	push   %ebx
801023d9:	e8 42 1d 00 00       	call   80104120 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023de:	8b 03                	mov    (%ebx),%eax
801023e0:	83 c4 10             	add    $0x10,%esp
801023e3:	83 e0 06             	and    $0x6,%eax
801023e6:	83 f8 02             	cmp    $0x2,%eax
801023e9:	75 e5                	jne    801023d0 <iderw+0x80>
  }


  release(&idelock);
801023eb:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
801023f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023f5:	c9                   	leave
  release(&idelock);
801023f6:	e9 05 23 00 00       	jmp    80104700 <release>
801023fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023ff:	90                   	nop
    idestart(b);
80102400:	89 d8                	mov    %ebx,%eax
80102402:	e8 39 fd ff ff       	call   80102140 <idestart>
80102407:	eb bd                	jmp    801023c6 <iderw+0x76>
80102409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102410:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80102415:	eb a5                	jmp    801023bc <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 15 78 10 80       	push   $0x80107815
8010241f:	e8 5c df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102424:	83 ec 0c             	sub    $0xc,%esp
80102427:	68 00 78 10 80       	push   $0x80107800
8010242c:	e8 4f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102431:	83 ec 0c             	sub    $0xc,%esp
80102434:	68 ea 77 10 80       	push   $0x801077ea
80102439:	e8 42 df ff ff       	call   80100380 <panic>
8010243e:	66 90                	xchg   %ax,%ax

80102440 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	56                   	push   %esi
80102444:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102445:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
8010244c:	00 c0 fe 
  ioapic->reg = reg;
8010244f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102456:	00 00 00 
  return ioapic->data;
80102459:	8b 15 34 16 11 80    	mov    0x80111634,%edx
8010245f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102462:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102468:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010246e:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102475:	c1 ee 10             	shr    $0x10,%esi
80102478:	89 f0                	mov    %esi,%eax
8010247a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010247d:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102480:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102483:	39 c2                	cmp    %eax,%edx
80102485:	74 16                	je     8010249d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102487:	83 ec 0c             	sub    $0xc,%esp
8010248a:	68 34 78 10 80       	push   $0x80107834
8010248f:	e8 1c e2 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
80102494:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010249a:	83 c4 10             	add    $0x10,%esp
{
8010249d:	ba 10 00 00 00       	mov    $0x10,%edx
801024a2:	31 c0                	xor    %eax,%eax
801024a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
801024a8:	89 13                	mov    %edx,(%ebx)
801024aa:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
801024ad:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801024b3:	83 c0 01             	add    $0x1,%eax
801024b6:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
801024bc:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
801024bf:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
801024c2:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801024c5:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801024c7:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
801024cd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
801024d4:	39 c6                	cmp    %eax,%esi
801024d6:	7d d0                	jge    801024a8 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024db:	5b                   	pop    %ebx
801024dc:	5e                   	pop    %esi
801024dd:	5d                   	pop    %ebp
801024de:	c3                   	ret
801024df:	90                   	nop

801024e0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024e0:	55                   	push   %ebp
  ioapic->reg = reg;
801024e1:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
801024e7:	89 e5                	mov    %esp,%ebp
801024e9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024ec:	8d 50 20             	lea    0x20(%eax),%edx
801024ef:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024f3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024f5:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024fb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024fe:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102501:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102504:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102506:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010250b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010250e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102511:	5d                   	pop    %ebp
80102512:	c3                   	ret
80102513:	66 90                	xchg   %ax,%ax
80102515:	66 90                	xchg   %ax,%ax
80102517:	66 90                	xchg   %ax,%ax
80102519:	66 90                	xchg   %ax,%ax
8010251b:	66 90                	xchg   %ax,%ax
8010251d:	66 90                	xchg   %ax,%ax
8010251f:	90                   	nop

80102520 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102520:	55                   	push   %ebp
80102521:	89 e5                	mov    %esp,%ebp
80102523:	53                   	push   %ebx
80102524:	83 ec 04             	sub    $0x4,%esp
80102527:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010252a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102530:	75 76                	jne    801025a8 <kfree+0x88>
80102532:	81 fb 00 63 11 80    	cmp    $0x80116300,%ebx
80102538:	72 6e                	jb     801025a8 <kfree+0x88>
8010253a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102540:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102545:	77 61                	ja     801025a8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102547:	83 ec 04             	sub    $0x4,%esp
8010254a:	68 00 10 00 00       	push   $0x1000
8010254f:	6a 01                	push   $0x1
80102551:	53                   	push   %ebx
80102552:	e8 e9 22 00 00       	call   80104840 <memset>

  if(kmem.use_lock)
80102557:	8b 15 74 16 11 80    	mov    0x80111674,%edx
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	85 d2                	test   %edx,%edx
80102562:	75 1c                	jne    80102580 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102564:	a1 78 16 11 80       	mov    0x80111678,%eax
80102569:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010256b:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
80102570:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102576:	85 c0                	test   %eax,%eax
80102578:	75 1e                	jne    80102598 <kfree+0x78>
    release(&kmem.lock);
}
8010257a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010257d:	c9                   	leave
8010257e:	c3                   	ret
8010257f:	90                   	nop
    acquire(&kmem.lock);
80102580:	83 ec 0c             	sub    $0xc,%esp
80102583:	68 40 16 11 80       	push   $0x80111640
80102588:	e8 d3 21 00 00       	call   80104760 <acquire>
8010258d:	83 c4 10             	add    $0x10,%esp
80102590:	eb d2                	jmp    80102564 <kfree+0x44>
80102592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102598:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010259f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025a2:	c9                   	leave
    release(&kmem.lock);
801025a3:	e9 58 21 00 00       	jmp    80104700 <release>
    panic("kfree");
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	68 66 78 10 80       	push   $0x80107866
801025b0:	e8 cb dd ff ff       	call   80100380 <panic>
801025b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025c0 <freerange>:
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	56                   	push   %esi
801025c4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025c5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025dd:	39 de                	cmp    %ebx,%esi
801025df:	72 23                	jb     80102604 <freerange+0x44>
801025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025e8:	83 ec 0c             	sub    $0xc,%esp
801025eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025f7:	50                   	push   %eax
801025f8:	e8 23 ff ff ff       	call   80102520 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	39 de                	cmp    %ebx,%esi
80102602:	73 e4                	jae    801025e8 <freerange+0x28>
}
80102604:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102607:	5b                   	pop    %ebx
80102608:	5e                   	pop    %esi
80102609:	5d                   	pop    %ebp
8010260a:	c3                   	ret
8010260b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010260f:	90                   	nop

80102610 <kinit2>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102615:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102618:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010261b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102621:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102627:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010262d:	39 de                	cmp    %ebx,%esi
8010262f:	72 23                	jb     80102654 <kinit2+0x44>
80102631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102638:	83 ec 0c             	sub    $0xc,%esp
8010263b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102641:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102647:	50                   	push   %eax
80102648:	e8 d3 fe ff ff       	call   80102520 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010264d:	83 c4 10             	add    $0x10,%esp
80102650:	39 de                	cmp    %ebx,%esi
80102652:	73 e4                	jae    80102638 <kinit2+0x28>
  kmem.use_lock = 1;
80102654:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010265b:	00 00 00 
}
8010265e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102661:	5b                   	pop    %ebx
80102662:	5e                   	pop    %esi
80102663:	5d                   	pop    %ebp
80102664:	c3                   	ret
80102665:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010266c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102670 <kinit1>:
{
80102670:	55                   	push   %ebp
80102671:	89 e5                	mov    %esp,%ebp
80102673:	56                   	push   %esi
80102674:	53                   	push   %ebx
80102675:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102678:	83 ec 08             	sub    $0x8,%esp
8010267b:	68 6c 78 10 80       	push   $0x8010786c
80102680:	68 40 16 11 80       	push   $0x80111640
80102685:	e8 f6 1e 00 00       	call   80104580 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010268a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010268d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102690:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102697:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010269a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026a0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026a6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026ac:	39 de                	cmp    %ebx,%esi
801026ae:	72 1c                	jb     801026cc <kinit1+0x5c>
    kfree(p);
801026b0:	83 ec 0c             	sub    $0xc,%esp
801026b3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026b9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026bf:	50                   	push   %eax
801026c0:	e8 5b fe ff ff       	call   80102520 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c5:	83 c4 10             	add    $0x10,%esp
801026c8:	39 de                	cmp    %ebx,%esi
801026ca:	73 e4                	jae    801026b0 <kinit1+0x40>
}
801026cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026cf:	5b                   	pop    %ebx
801026d0:	5e                   	pop    %esi
801026d1:	5d                   	pop    %ebp
801026d2:	c3                   	ret
801026d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801026e0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801026e0:	55                   	push   %ebp
801026e1:	89 e5                	mov    %esp,%ebp
801026e3:	53                   	push   %ebx
801026e4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801026e7:	a1 74 16 11 80       	mov    0x80111674,%eax
801026ec:	85 c0                	test   %eax,%eax
801026ee:	75 20                	jne    80102710 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026f0:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(r)
801026f6:	85 db                	test   %ebx,%ebx
801026f8:	74 07                	je     80102701 <kalloc+0x21>
    kmem.freelist = r->next;
801026fa:	8b 03                	mov    (%ebx),%eax
801026fc:	a3 78 16 11 80       	mov    %eax,0x80111678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102701:	89 d8                	mov    %ebx,%eax
80102703:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102706:	c9                   	leave
80102707:	c3                   	ret
80102708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010270f:	90                   	nop
    acquire(&kmem.lock);
80102710:	83 ec 0c             	sub    $0xc,%esp
80102713:	68 40 16 11 80       	push   $0x80111640
80102718:	e8 43 20 00 00       	call   80104760 <acquire>
  r = kmem.freelist;
8010271d:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(kmem.use_lock)
80102723:	a1 74 16 11 80       	mov    0x80111674,%eax
  if(r)
80102728:	83 c4 10             	add    $0x10,%esp
8010272b:	85 db                	test   %ebx,%ebx
8010272d:	74 08                	je     80102737 <kalloc+0x57>
    kmem.freelist = r->next;
8010272f:	8b 13                	mov    (%ebx),%edx
80102731:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
80102737:	85 c0                	test   %eax,%eax
80102739:	74 c6                	je     80102701 <kalloc+0x21>
    release(&kmem.lock);
8010273b:	83 ec 0c             	sub    $0xc,%esp
8010273e:	68 40 16 11 80       	push   $0x80111640
80102743:	e8 b8 1f 00 00       	call   80104700 <release>
}
80102748:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010274a:	83 c4 10             	add    $0x10,%esp
}
8010274d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102750:	c9                   	leave
80102751:	c3                   	ret
80102752:	66 90                	xchg   %ax,%ax
80102754:	66 90                	xchg   %ax,%ax
80102756:	66 90                	xchg   %ax,%ax
80102758:	66 90                	xchg   %ax,%ax
8010275a:	66 90                	xchg   %ax,%ax
8010275c:	66 90                	xchg   %ax,%ax
8010275e:	66 90                	xchg   %ax,%ax

80102760 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102760:	ba 64 00 00 00       	mov    $0x64,%edx
80102765:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102766:	a8 01                	test   $0x1,%al
80102768:	0f 84 c2 00 00 00    	je     80102830 <kbdgetc+0xd0>
{
8010276e:	55                   	push   %ebp
8010276f:	ba 60 00 00 00       	mov    $0x60,%edx
80102774:	89 e5                	mov    %esp,%ebp
80102776:	53                   	push   %ebx
80102777:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102778:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
8010277e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102781:	3c e0                	cmp    $0xe0,%al
80102783:	74 5b                	je     801027e0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102785:	89 da                	mov    %ebx,%edx
80102787:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010278a:	84 c0                	test   %al,%al
8010278c:	78 6a                	js     801027f8 <kbdgetc+0x98>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010278e:	85 d2                	test   %edx,%edx
80102790:	74 09                	je     8010279b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102792:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102795:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102798:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010279b:	0f b6 91 a0 79 10 80 	movzbl -0x7fef8660(%ecx),%edx
  shift ^= togglecode[data];
801027a2:	0f b6 81 a0 78 10 80 	movzbl -0x7fef8760(%ecx),%eax
  shift |= shiftcode[data];
801027a9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801027ab:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027ad:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801027af:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
801027b5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801027b8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027bb:	8b 04 85 80 78 10 80 	mov    -0x7fef8780(,%eax,4),%eax
801027c2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801027c6:	74 0b                	je     801027d3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
801027c8:	8d 50 9f             	lea    -0x61(%eax),%edx
801027cb:	83 fa 19             	cmp    $0x19,%edx
801027ce:	77 48                	ja     80102818 <kbdgetc+0xb8>
      c += 'A' - 'a';
801027d0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027d6:	c9                   	leave
801027d7:	c3                   	ret
801027d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027df:	90                   	nop
    shift |= E0ESC;
801027e0:	89 d8                	mov    %ebx,%eax
801027e2:	83 c8 40             	or     $0x40,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801027e5:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
801027ea:	31 c0                	xor    %eax,%eax
}
801027ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027ef:	c9                   	leave
801027f0:	c3                   	ret
801027f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    data = (shift & E0ESC ? data : data & 0x7F);
801027f8:	83 e0 7f             	and    $0x7f,%eax
801027fb:	85 d2                	test   %edx,%edx
801027fd:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102800:	0f b6 81 a0 79 10 80 	movzbl -0x7fef8660(%ecx),%eax
80102807:	83 c8 40             	or     $0x40,%eax
8010280a:	0f b6 c0             	movzbl %al,%eax
8010280d:	f7 d0                	not    %eax
8010280f:	21 d8                	and    %ebx,%eax
    return 0;
80102811:	eb d2                	jmp    801027e5 <kbdgetc+0x85>
80102813:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102817:	90                   	nop
    else if('A' <= c && c <= 'Z')
80102818:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010281b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010281e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102821:	c9                   	leave
      c += 'a' - 'A';
80102822:	83 f9 1a             	cmp    $0x1a,%ecx
80102825:	0f 42 c2             	cmovb  %edx,%eax
}
80102828:	c3                   	ret
80102829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102835:	c3                   	ret
80102836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010283d:	8d 76 00             	lea    0x0(%esi),%esi

80102840 <kbdintr>:

void
kbdintr(void)
{
80102840:	55                   	push   %ebp
80102841:	89 e5                	mov    %esp,%ebp
80102843:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102846:	68 60 27 10 80       	push   $0x80102760
8010284b:	e8 70 e0 ff ff       	call   801008c0 <consoleintr>
}
80102850:	83 c4 10             	add    $0x10,%esp
80102853:	c9                   	leave
80102854:	c3                   	ret
80102855:	66 90                	xchg   %ax,%ax
80102857:	66 90                	xchg   %ax,%ax
80102859:	66 90                	xchg   %ax,%ax
8010285b:	66 90                	xchg   %ax,%ax
8010285d:	66 90                	xchg   %ax,%ax
8010285f:	90                   	nop

80102860 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102860:	a1 80 16 11 80       	mov    0x80111680,%eax
80102865:	85 c0                	test   %eax,%eax
80102867:	0f 84 cb 00 00 00    	je     80102938 <lapicinit+0xd8>
  lapic[index] = value;
8010286d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102874:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102877:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010287a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102881:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102884:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102887:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010288e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102891:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102894:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010289b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010289e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801028a8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ab:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ae:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801028b5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028b8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801028bb:	8b 50 30             	mov    0x30(%eax),%edx
801028be:	c1 ea 10             	shr    $0x10,%edx
801028c1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801028c7:	75 77                	jne    80102940 <lapicinit+0xe0>
  lapic[index] = value;
801028c9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801028d0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028dd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028e3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028ea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ed:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028f0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028f7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028fa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028fd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102904:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102907:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010290a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102911:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102914:	8b 50 20             	mov    0x20(%eax),%edx
80102917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102920:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102926:	80 e6 10             	and    $0x10,%dh
80102929:	75 f5                	jne    80102920 <lapicinit+0xc0>
  lapic[index] = value;
8010292b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102932:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102935:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102938:	c3                   	ret
80102939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102940:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102947:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010294a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010294d:	e9 77 ff ff ff       	jmp    801028c9 <lapicinit+0x69>
80102952:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102960 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102960:	a1 80 16 11 80       	mov    0x80111680,%eax
80102965:	85 c0                	test   %eax,%eax
80102967:	74 07                	je     80102970 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102969:	8b 40 20             	mov    0x20(%eax),%eax
8010296c:	c1 e8 18             	shr    $0x18,%eax
8010296f:	c3                   	ret
    return 0;
80102970:	31 c0                	xor    %eax,%eax
}
80102972:	c3                   	ret
80102973:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010297a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102980 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102980:	a1 80 16 11 80       	mov    0x80111680,%eax
80102985:	85 c0                	test   %eax,%eax
80102987:	74 0d                	je     80102996 <lapiceoi+0x16>
  lapic[index] = value;
80102989:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102990:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102993:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102996:	c3                   	ret
80102997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299e:	66 90                	xchg   %ax,%ax

801029a0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
801029a0:	c3                   	ret
801029a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029af:	90                   	nop

801029b0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801029b0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b1:	b8 0f 00 00 00       	mov    $0xf,%eax
801029b6:	ba 70 00 00 00       	mov    $0x70,%edx
801029bb:	89 e5                	mov    %esp,%ebp
801029bd:	53                   	push   %ebx
801029be:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029c4:	ee                   	out    %al,(%dx)
801029c5:	b8 0a 00 00 00       	mov    $0xa,%eax
801029ca:	ba 71 00 00 00       	mov    $0x71,%edx
801029cf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029d0:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
801029d2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801029d5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801029db:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029dd:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
801029e0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801029e2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801029e5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801029e8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801029ee:	a1 80 16 11 80       	mov    0x80111680,%eax
801029f3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029f9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029fc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a03:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a06:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a09:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a10:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a13:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a16:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a1c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a1f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a25:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a28:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a2e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a31:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a37:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a3d:	c9                   	leave
80102a3e:	c3                   	ret
80102a3f:	90                   	nop

80102a40 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a40:	55                   	push   %ebp
80102a41:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a46:	ba 70 00 00 00       	mov    $0x70,%edx
80102a4b:	89 e5                	mov    %esp,%ebp
80102a4d:	57                   	push   %edi
80102a4e:	56                   	push   %esi
80102a4f:	53                   	push   %ebx
80102a50:	83 ec 4c             	sub    $0x4c,%esp
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	ba 71 00 00 00       	mov    $0x71,%edx
80102a59:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a5a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5d:	bf 70 00 00 00       	mov    $0x70,%edi
80102a62:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a65:	8d 76 00             	lea    0x0(%esi),%esi
80102a68:	31 c0                	xor    %eax,%eax
80102a6a:	89 fa                	mov    %edi,%edx
80102a6c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a72:	89 ca                	mov    %ecx,%edx
80102a74:	ec                   	in     (%dx),%al
80102a75:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a78:	89 fa                	mov    %edi,%edx
80102a7a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a7f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a80:	89 ca                	mov    %ecx,%edx
80102a82:	ec                   	in     (%dx),%al
80102a83:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a86:	89 fa                	mov    %edi,%edx
80102a88:	b8 04 00 00 00       	mov    $0x4,%eax
80102a8d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8e:	89 ca                	mov    %ecx,%edx
80102a90:	ec                   	in     (%dx),%al
80102a91:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a94:	89 fa                	mov    %edi,%edx
80102a96:	b8 07 00 00 00       	mov    $0x7,%eax
80102a9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9c:	89 ca                	mov    %ecx,%edx
80102a9e:	ec                   	in     (%dx),%al
80102a9f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa2:	89 fa                	mov    %edi,%edx
80102aa4:	b8 08 00 00 00       	mov    $0x8,%eax
80102aa9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aaa:	89 ca                	mov    %ecx,%edx
80102aac:	ec                   	in     (%dx),%al
80102aad:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aaf:	89 fa                	mov    %edi,%edx
80102ab1:	b8 09 00 00 00       	mov    $0x9,%eax
80102ab6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab7:	89 ca                	mov    %ecx,%edx
80102ab9:	ec                   	in     (%dx),%al
80102aba:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102abd:	89 fa                	mov    %edi,%edx
80102abf:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ac4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac5:	89 ca                	mov    %ecx,%edx
80102ac7:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ac8:	84 c0                	test   %al,%al
80102aca:	78 9c                	js     80102a68 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102acc:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102ad0:	89 f2                	mov    %esi,%edx
80102ad2:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102ad5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad8:	89 fa                	mov    %edi,%edx
80102ada:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102add:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102ae1:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102ae4:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102ae7:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102aeb:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102aee:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102af2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102af5:	31 c0                	xor    %eax,%eax
80102af7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af8:	89 ca                	mov    %ecx,%edx
80102afa:	ec                   	in     (%dx),%al
80102afb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102afe:	89 fa                	mov    %edi,%edx
80102b00:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b03:	b8 02 00 00 00       	mov    $0x2,%eax
80102b08:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b09:	89 ca                	mov    %ecx,%edx
80102b0b:	ec                   	in     (%dx),%al
80102b0c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b0f:	89 fa                	mov    %edi,%edx
80102b11:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b14:	b8 04 00 00 00       	mov    $0x4,%eax
80102b19:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1a:	89 ca                	mov    %ecx,%edx
80102b1c:	ec                   	in     (%dx),%al
80102b1d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b20:	89 fa                	mov    %edi,%edx
80102b22:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b25:	b8 07 00 00 00       	mov    $0x7,%eax
80102b2a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b2b:	89 ca                	mov    %ecx,%edx
80102b2d:	ec                   	in     (%dx),%al
80102b2e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b31:	89 fa                	mov    %edi,%edx
80102b33:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b36:	b8 08 00 00 00       	mov    $0x8,%eax
80102b3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b3c:	89 ca                	mov    %ecx,%edx
80102b3e:	ec                   	in     (%dx),%al
80102b3f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b42:	89 fa                	mov    %edi,%edx
80102b44:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b47:	b8 09 00 00 00       	mov    $0x9,%eax
80102b4c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4d:	89 ca                	mov    %ecx,%edx
80102b4f:	ec                   	in     (%dx),%al
80102b50:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b53:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b59:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b5c:	6a 18                	push   $0x18
80102b5e:	50                   	push   %eax
80102b5f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b62:	50                   	push   %eax
80102b63:	e8 18 1d 00 00       	call   80104880 <memcmp>
80102b68:	83 c4 10             	add    $0x10,%esp
80102b6b:	85 c0                	test   %eax,%eax
80102b6d:	0f 85 f5 fe ff ff    	jne    80102a68 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b73:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102b77:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b7a:	89 f0                	mov    %esi,%eax
80102b7c:	84 c0                	test   %al,%al
80102b7e:	75 78                	jne    80102bf8 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b80:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b83:	89 c2                	mov    %eax,%edx
80102b85:	83 e0 0f             	and    $0xf,%eax
80102b88:	c1 ea 04             	shr    $0x4,%edx
80102b8b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b8e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b91:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b94:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b97:	89 c2                	mov    %eax,%edx
80102b99:	83 e0 0f             	and    $0xf,%eax
80102b9c:	c1 ea 04             	shr    $0x4,%edx
80102b9f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ba2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ba5:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ba8:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bab:	89 c2                	mov    %eax,%edx
80102bad:	83 e0 0f             	and    $0xf,%eax
80102bb0:	c1 ea 04             	shr    $0x4,%edx
80102bb3:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bb6:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bb9:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102bbc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bbf:	89 c2                	mov    %eax,%edx
80102bc1:	83 e0 0f             	and    $0xf,%eax
80102bc4:	c1 ea 04             	shr    $0x4,%edx
80102bc7:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bca:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bcd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102bd0:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bd3:	89 c2                	mov    %eax,%edx
80102bd5:	83 e0 0f             	and    $0xf,%eax
80102bd8:	c1 ea 04             	shr    $0x4,%edx
80102bdb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bde:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102be1:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102be4:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102be7:	89 c2                	mov    %eax,%edx
80102be9:	83 e0 0f             	and    $0xf,%eax
80102bec:	c1 ea 04             	shr    $0x4,%edx
80102bef:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bf2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bf5:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102bf8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bfb:	89 03                	mov    %eax,(%ebx)
80102bfd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c00:	89 43 04             	mov    %eax,0x4(%ebx)
80102c03:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c06:	89 43 08             	mov    %eax,0x8(%ebx)
80102c09:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c0c:	89 43 0c             	mov    %eax,0xc(%ebx)
80102c0f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c12:	89 43 10             	mov    %eax,0x10(%ebx)
80102c15:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c18:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102c1b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102c22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c25:	5b                   	pop    %ebx
80102c26:	5e                   	pop    %esi
80102c27:	5f                   	pop    %edi
80102c28:	5d                   	pop    %ebp
80102c29:	c3                   	ret
80102c2a:	66 90                	xchg   %ax,%ax
80102c2c:	66 90                	xchg   %ax,%ax
80102c2e:	66 90                	xchg   %ax,%ax

80102c30 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c30:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102c36:	85 c9                	test   %ecx,%ecx
80102c38:	0f 8e 8a 00 00 00    	jle    80102cc8 <install_trans+0x98>
{
80102c3e:	55                   	push   %ebp
80102c3f:	89 e5                	mov    %esp,%ebp
80102c41:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c42:	31 ff                	xor    %edi,%edi
{
80102c44:	56                   	push   %esi
80102c45:	53                   	push   %ebx
80102c46:	83 ec 0c             	sub    $0xc,%esp
80102c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c50:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102c55:	83 ec 08             	sub    $0x8,%esp
80102c58:	01 f8                	add    %edi,%eax
80102c5a:	83 c0 01             	add    $0x1,%eax
80102c5d:	50                   	push   %eax
80102c5e:	ff 35 e4 16 11 80    	push   0x801116e4
80102c64:	e8 67 d4 ff ff       	call   801000d0 <bread>
80102c69:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c6b:	58                   	pop    %eax
80102c6c:	5a                   	pop    %edx
80102c6d:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102c74:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c7a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c7d:	e8 4e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c82:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c85:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c87:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c8a:	68 00 02 00 00       	push   $0x200
80102c8f:	50                   	push   %eax
80102c90:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c93:	50                   	push   %eax
80102c94:	e8 37 1c 00 00       	call   801048d0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c99:	89 1c 24             	mov    %ebx,(%esp)
80102c9c:	e8 0f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102ca1:	89 34 24             	mov    %esi,(%esp)
80102ca4:	e8 47 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102ca9:	89 1c 24             	mov    %ebx,(%esp)
80102cac:	e8 3f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cb1:	83 c4 10             	add    $0x10,%esp
80102cb4:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102cba:	7f 94                	jg     80102c50 <install_trans+0x20>
  }
}
80102cbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cbf:	5b                   	pop    %ebx
80102cc0:	5e                   	pop    %esi
80102cc1:	5f                   	pop    %edi
80102cc2:	5d                   	pop    %ebp
80102cc3:	c3                   	ret
80102cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cc8:	c3                   	ret
80102cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102cd0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	53                   	push   %ebx
80102cd4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cd7:	ff 35 d4 16 11 80    	push   0x801116d4
80102cdd:	ff 35 e4 16 11 80    	push   0x801116e4
80102ce3:	e8 e8 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ce8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ceb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102ced:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102cf2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102cf5:	85 c0                	test   %eax,%eax
80102cf7:	7e 19                	jle    80102d12 <write_head+0x42>
80102cf9:	31 d2                	xor    %edx,%edx
80102cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cff:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102d00:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102d07:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d0b:	83 c2 01             	add    $0x1,%edx
80102d0e:	39 d0                	cmp    %edx,%eax
80102d10:	75 ee                	jne    80102d00 <write_head+0x30>
  }
  bwrite(buf);
80102d12:	83 ec 0c             	sub    $0xc,%esp
80102d15:	53                   	push   %ebx
80102d16:	e8 95 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102d1b:	89 1c 24             	mov    %ebx,(%esp)
80102d1e:	e8 cd d4 ff ff       	call   801001f0 <brelse>
}
80102d23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d26:	83 c4 10             	add    $0x10,%esp
80102d29:	c9                   	leave
80102d2a:	c3                   	ret
80102d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d2f:	90                   	nop

80102d30 <initlog>:
{
80102d30:	55                   	push   %ebp
80102d31:	89 e5                	mov    %esp,%ebp
80102d33:	53                   	push   %ebx
80102d34:	83 ec 2c             	sub    $0x2c,%esp
80102d37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d3a:	68 a0 7a 10 80       	push   $0x80107aa0
80102d3f:	68 a0 16 11 80       	push   $0x801116a0
80102d44:	e8 37 18 00 00       	call   80104580 <initlock>
  readsb(dev, &sb);
80102d49:	58                   	pop    %eax
80102d4a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d4d:	5a                   	pop    %edx
80102d4e:	50                   	push   %eax
80102d4f:	53                   	push   %ebx
80102d50:	e8 1b e8 ff ff       	call   80101570 <readsb>
  log.size = sb.nlog;
80102d55:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.dev = dev;
80102d5b:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.start = sb.logstart;
80102d61:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102d66:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102d6c:	59                   	pop    %ecx
80102d6d:	5a                   	pop    %edx
80102d6e:	50                   	push   %eax
80102d6f:	53                   	push   %ebx
80102d70:	e8 5b d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d75:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d78:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d7b:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102d81:	85 db                	test   %ebx,%ebx
80102d83:	7e 1d                	jle    80102da2 <initlog+0x72>
80102d85:	31 d2                	xor    %edx,%edx
80102d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d8e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d90:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d94:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d9b:	83 c2 01             	add    $0x1,%edx
80102d9e:	39 d3                	cmp    %edx,%ebx
80102da0:	75 ee                	jne    80102d90 <initlog+0x60>
  brelse(buf);
80102da2:	83 ec 0c             	sub    $0xc,%esp
80102da5:	50                   	push   %eax
80102da6:	e8 45 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102dab:	e8 80 fe ff ff       	call   80102c30 <install_trans>
  log.lh.n = 0;
80102db0:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102db7:	00 00 00 
  write_head(); // clear the log
80102dba:	e8 11 ff ff ff       	call   80102cd0 <write_head>
}
80102dbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dc2:	83 c4 10             	add    $0x10,%esp
80102dc5:	c9                   	leave
80102dc6:	c3                   	ret
80102dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dce:	66 90                	xchg   %ax,%ax

80102dd0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102dd6:	68 a0 16 11 80       	push   $0x801116a0
80102ddb:	e8 80 19 00 00       	call   80104760 <acquire>
80102de0:	83 c4 10             	add    $0x10,%esp
80102de3:	eb 18                	jmp    80102dfd <begin_op+0x2d>
80102de5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102de8:	83 ec 08             	sub    $0x8,%esp
80102deb:	68 a0 16 11 80       	push   $0x801116a0
80102df0:	68 a0 16 11 80       	push   $0x801116a0
80102df5:	e8 26 13 00 00       	call   80104120 <sleep>
80102dfa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102dfd:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102e02:	85 c0                	test   %eax,%eax
80102e04:	75 e2                	jne    80102de8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e06:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102e0b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102e11:	83 c0 01             	add    $0x1,%eax
80102e14:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e17:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e1a:	83 fa 1e             	cmp    $0x1e,%edx
80102e1d:	7f c9                	jg     80102de8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e1f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e22:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102e27:	68 a0 16 11 80       	push   $0x801116a0
80102e2c:	e8 cf 18 00 00       	call   80104700 <release>
      break;
    }
  }
}
80102e31:	83 c4 10             	add    $0x10,%esp
80102e34:	c9                   	leave
80102e35:	c3                   	ret
80102e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e3d:	8d 76 00             	lea    0x0(%esi),%esi

80102e40 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	57                   	push   %edi
80102e44:	56                   	push   %esi
80102e45:	53                   	push   %ebx
80102e46:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e49:	68 a0 16 11 80       	push   $0x801116a0
80102e4e:	e8 0d 19 00 00       	call   80104760 <acquire>
  log.outstanding -= 1;
80102e53:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102e58:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102e5e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e61:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e64:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102e6a:	85 f6                	test   %esi,%esi
80102e6c:	0f 85 22 01 00 00    	jne    80102f94 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e72:	85 db                	test   %ebx,%ebx
80102e74:	0f 85 f6 00 00 00    	jne    80102f70 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e7a:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102e81:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e84:	83 ec 0c             	sub    $0xc,%esp
80102e87:	68 a0 16 11 80       	push   $0x801116a0
80102e8c:	e8 6f 18 00 00       	call   80104700 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e91:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102e97:	83 c4 10             	add    $0x10,%esp
80102e9a:	85 c9                	test   %ecx,%ecx
80102e9c:	7f 42                	jg     80102ee0 <end_op+0xa0>
    acquire(&log.lock);
80102e9e:	83 ec 0c             	sub    $0xc,%esp
80102ea1:	68 a0 16 11 80       	push   $0x801116a0
80102ea6:	e8 b5 18 00 00       	call   80104760 <acquire>
    log.committing = 0;
80102eab:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102eb2:	00 00 00 
    wakeup(&log);
80102eb5:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102ebc:	e8 1f 13 00 00       	call   801041e0 <wakeup>
    release(&log.lock);
80102ec1:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102ec8:	e8 33 18 00 00       	call   80104700 <release>
80102ecd:	83 c4 10             	add    $0x10,%esp
}
80102ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ed3:	5b                   	pop    %ebx
80102ed4:	5e                   	pop    %esi
80102ed5:	5f                   	pop    %edi
80102ed6:	5d                   	pop    %ebp
80102ed7:	c3                   	ret
80102ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102edf:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ee0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102ee5:	83 ec 08             	sub    $0x8,%esp
80102ee8:	01 d8                	add    %ebx,%eax
80102eea:	83 c0 01             	add    $0x1,%eax
80102eed:	50                   	push   %eax
80102eee:	ff 35 e4 16 11 80    	push   0x801116e4
80102ef4:	e8 d7 d1 ff ff       	call   801000d0 <bread>
80102ef9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102efb:	58                   	pop    %eax
80102efc:	5a                   	pop    %edx
80102efd:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102f04:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f0a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f0d:	e8 be d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102f12:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f15:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f17:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f1a:	68 00 02 00 00       	push   $0x200
80102f1f:	50                   	push   %eax
80102f20:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f23:	50                   	push   %eax
80102f24:	e8 a7 19 00 00       	call   801048d0 <memmove>
    bwrite(to);  // write the log
80102f29:	89 34 24             	mov    %esi,(%esp)
80102f2c:	e8 7f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f31:	89 3c 24             	mov    %edi,(%esp)
80102f34:	e8 b7 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f39:	89 34 24             	mov    %esi,(%esp)
80102f3c:	e8 af d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f41:	83 c4 10             	add    $0x10,%esp
80102f44:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80102f4a:	7c 94                	jl     80102ee0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f4c:	e8 7f fd ff ff       	call   80102cd0 <write_head>
    install_trans(); // Now install writes to home locations
80102f51:	e8 da fc ff ff       	call   80102c30 <install_trans>
    log.lh.n = 0;
80102f56:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102f5d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f60:	e8 6b fd ff ff       	call   80102cd0 <write_head>
80102f65:	e9 34 ff ff ff       	jmp    80102e9e <end_op+0x5e>
80102f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f70:	83 ec 0c             	sub    $0xc,%esp
80102f73:	68 a0 16 11 80       	push   $0x801116a0
80102f78:	e8 63 12 00 00       	call   801041e0 <wakeup>
  release(&log.lock);
80102f7d:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102f84:	e8 77 17 00 00       	call   80104700 <release>
80102f89:	83 c4 10             	add    $0x10,%esp
}
80102f8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f8f:	5b                   	pop    %ebx
80102f90:	5e                   	pop    %esi
80102f91:	5f                   	pop    %edi
80102f92:	5d                   	pop    %ebp
80102f93:	c3                   	ret
    panic("log.committing");
80102f94:	83 ec 0c             	sub    $0xc,%esp
80102f97:	68 a4 7a 10 80       	push   $0x80107aa4
80102f9c:	e8 df d3 ff ff       	call   80100380 <panic>
80102fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102faf:	90                   	nop

80102fb0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	53                   	push   %ebx
80102fb4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fb7:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
80102fbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fc0:	83 fa 1d             	cmp    $0x1d,%edx
80102fc3:	7f 7d                	jg     80103042 <log_write+0x92>
80102fc5:	a1 d8 16 11 80       	mov    0x801116d8,%eax
80102fca:	83 e8 01             	sub    $0x1,%eax
80102fcd:	39 c2                	cmp    %eax,%edx
80102fcf:	7d 71                	jge    80103042 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102fd1:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102fd6:	85 c0                	test   %eax,%eax
80102fd8:	7e 75                	jle    8010304f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102fda:	83 ec 0c             	sub    $0xc,%esp
80102fdd:	68 a0 16 11 80       	push   $0x801116a0
80102fe2:	e8 79 17 00 00       	call   80104760 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fe7:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102fea:	83 c4 10             	add    $0x10,%esp
80102fed:	31 c0                	xor    %eax,%eax
80102fef:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102ff5:	85 d2                	test   %edx,%edx
80102ff7:	7f 0e                	jg     80103007 <log_write+0x57>
80102ff9:	eb 15                	jmp    80103010 <log_write+0x60>
80102ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fff:	90                   	nop
80103000:	83 c0 01             	add    $0x1,%eax
80103003:	39 c2                	cmp    %eax,%edx
80103005:	74 29                	je     80103030 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103007:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
8010300e:	75 f0                	jne    80103000 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103010:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
80103017:	39 c2                	cmp    %eax,%edx
80103019:	74 1c                	je     80103037 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010301b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010301e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103021:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80103028:	c9                   	leave
  release(&log.lock);
80103029:	e9 d2 16 00 00       	jmp    80104700 <release>
8010302e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103030:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80103037:	83 c2 01             	add    $0x1,%edx
8010303a:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80103040:	eb d9                	jmp    8010301b <log_write+0x6b>
    panic("too big a transaction");
80103042:	83 ec 0c             	sub    $0xc,%esp
80103045:	68 b3 7a 10 80       	push   $0x80107ab3
8010304a:	e8 31 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010304f:	83 ec 0c             	sub    $0xc,%esp
80103052:	68 c9 7a 10 80       	push   $0x80107ac9
80103057:	e8 24 d3 ff ff       	call   80100380 <panic>
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	53                   	push   %ebx
80103064:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103067:	e8 94 09 00 00       	call   80103a00 <cpuid>
8010306c:	89 c3                	mov    %eax,%ebx
8010306e:	e8 8d 09 00 00       	call   80103a00 <cpuid>
80103073:	83 ec 04             	sub    $0x4,%esp
80103076:	53                   	push   %ebx
80103077:	50                   	push   %eax
80103078:	68 e4 7a 10 80       	push   $0x80107ae4
8010307d:	e8 2e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103082:	e8 e9 2a 00 00       	call   80105b70 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103087:	e8 14 09 00 00       	call   801039a0 <mycpu>
8010308c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010308e:	b8 01 00 00 00       	mov    $0x1,%eax
80103093:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010309a:	e8 31 0c 00 00       	call   80103cd0 <scheduler>
8010309f:	90                   	nop

801030a0 <mpenter>:
{
801030a0:	55                   	push   %ebp
801030a1:	89 e5                	mov    %esp,%ebp
801030a3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801030a6:	e8 d5 3b 00 00       	call   80106c80 <switchkvm>
  seginit();
801030ab:	e8 40 3b 00 00       	call   80106bf0 <seginit>
  lapicinit();
801030b0:	e8 ab f7 ff ff       	call   80102860 <lapicinit>
  mpmain();
801030b5:	e8 a6 ff ff ff       	call   80103060 <mpmain>
801030ba:	66 90                	xchg   %ax,%ax
801030bc:	66 90                	xchg   %ax,%ax
801030be:	66 90                	xchg   %ax,%ax

801030c0 <main>:
{
801030c0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030c4:	83 e4 f0             	and    $0xfffffff0,%esp
801030c7:	ff 71 fc             	push   -0x4(%ecx)
801030ca:	55                   	push   %ebp
801030cb:	89 e5                	mov    %esp,%ebp
801030cd:	53                   	push   %ebx
801030ce:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030cf:	83 ec 08             	sub    $0x8,%esp
801030d2:	68 00 00 40 80       	push   $0x80400000
801030d7:	68 00 63 11 80       	push   $0x80116300
801030dc:	e8 8f f5 ff ff       	call   80102670 <kinit1>
  kvmalloc();      // kernel page table
801030e1:	e8 5a 40 00 00       	call   80107140 <kvmalloc>
  mpinit();        // detect other processors
801030e6:	e8 85 01 00 00       	call   80103270 <mpinit>
  lapicinit();     // interrupt controller
801030eb:	e8 70 f7 ff ff       	call   80102860 <lapicinit>
  seginit();       // segment descriptors
801030f0:	e8 fb 3a 00 00       	call   80106bf0 <seginit>
  picinit();       // disable pic
801030f5:	e8 86 03 00 00       	call   80103480 <picinit>
  ioapicinit();    // another interrupt controller
801030fa:	e8 41 f3 ff ff       	call   80102440 <ioapicinit>
  consoleinit();   // console hardware
801030ff:	e8 8c d9 ff ff       	call   80100a90 <consoleinit>
  uartinit();      // serial port
80103104:	e8 57 2d 00 00       	call   80105e60 <uartinit>
  pinit();         // process table
80103109:	e8 62 08 00 00       	call   80103970 <pinit>
  tvinit();        // trap vectors
8010310e:	e8 dd 29 00 00       	call   80105af0 <tvinit>
  binit();         // buffer cache
80103113:	e8 28 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103118:	e8 43 dd ff ff       	call   80100e60 <fileinit>
  ideinit();       // disk 
8010311d:	e8 fe f0 ff ff       	call   80102220 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103122:	83 c4 0c             	add    $0xc,%esp
80103125:	68 8a 00 00 00       	push   $0x8a
8010312a:	68 90 a4 10 80       	push   $0x8010a490
8010312f:	68 00 70 00 80       	push   $0x80007000
80103134:	e8 97 17 00 00       	call   801048d0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103139:	83 c4 10             	add    $0x10,%esp
8010313c:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103143:	00 00 00 
80103146:	05 a0 17 11 80       	add    $0x801117a0,%eax
8010314b:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
80103150:	76 7e                	jbe    801031d0 <main+0x110>
80103152:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
80103157:	eb 20                	jmp    80103179 <main+0xb9>
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103167:	00 00 00 
8010316a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103170:	05 a0 17 11 80       	add    $0x801117a0,%eax
80103175:	39 c3                	cmp    %eax,%ebx
80103177:	73 57                	jae    801031d0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103179:	e8 22 08 00 00       	call   801039a0 <mycpu>
8010317e:	39 c3                	cmp    %eax,%ebx
80103180:	74 de                	je     80103160 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103182:	e8 59 f5 ff ff       	call   801026e0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103187:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010318a:	c7 05 f8 6f 00 80 a0 	movl   $0x801030a0,0x80006ff8
80103191:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103194:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010319b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010319e:	05 00 10 00 00       	add    $0x1000,%eax
801031a3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801031a8:	0f b6 03             	movzbl (%ebx),%eax
801031ab:	68 00 70 00 00       	push   $0x7000
801031b0:	50                   	push   %eax
801031b1:	e8 fa f7 ff ff       	call   801029b0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801031b6:	83 c4 10             	add    $0x10,%esp
801031b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031c0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031c6:	85 c0                	test   %eax,%eax
801031c8:	74 f6                	je     801031c0 <main+0x100>
801031ca:	eb 94                	jmp    80103160 <main+0xa0>
801031cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031d0:	83 ec 08             	sub    $0x8,%esp
801031d3:	68 00 00 00 8e       	push   $0x8e000000
801031d8:	68 00 00 40 80       	push   $0x80400000
801031dd:	e8 2e f4 ff ff       	call   80102610 <kinit2>
  userinit();      // first user process
801031e2:	e8 69 08 00 00       	call   80103a50 <userinit>
  mpmain();        // finish this processor's setup
801031e7:	e8 74 fe ff ff       	call   80103060 <mpmain>
801031ec:	66 90                	xchg   %ax,%ax
801031ee:	66 90                	xchg   %ax,%ax

801031f0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	57                   	push   %edi
801031f4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031f5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031fb:	53                   	push   %ebx
  e = addr+len;
801031fc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031ff:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103202:	39 de                	cmp    %ebx,%esi
80103204:	72 10                	jb     80103216 <mpsearch1+0x26>
80103206:	eb 50                	jmp    80103258 <mpsearch1+0x68>
80103208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop
80103210:	89 fe                	mov    %edi,%esi
80103212:	39 df                	cmp    %ebx,%edi
80103214:	73 42                	jae    80103258 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103216:	83 ec 04             	sub    $0x4,%esp
80103219:	8d 7e 10             	lea    0x10(%esi),%edi
8010321c:	6a 04                	push   $0x4
8010321e:	68 f8 7a 10 80       	push   $0x80107af8
80103223:	56                   	push   %esi
80103224:	e8 57 16 00 00       	call   80104880 <memcmp>
80103229:	83 c4 10             	add    $0x10,%esp
8010322c:	85 c0                	test   %eax,%eax
8010322e:	75 e0                	jne    80103210 <mpsearch1+0x20>
80103230:	89 f2                	mov    %esi,%edx
80103232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103238:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010323b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010323e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103240:	39 fa                	cmp    %edi,%edx
80103242:	75 f4                	jne    80103238 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103244:	84 c0                	test   %al,%al
80103246:	75 c8                	jne    80103210 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103248:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010324b:	89 f0                	mov    %esi,%eax
8010324d:	5b                   	pop    %ebx
8010324e:	5e                   	pop    %esi
8010324f:	5f                   	pop    %edi
80103250:	5d                   	pop    %ebp
80103251:	c3                   	ret
80103252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103258:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010325b:	31 f6                	xor    %esi,%esi
}
8010325d:	5b                   	pop    %ebx
8010325e:	89 f0                	mov    %esi,%eax
80103260:	5e                   	pop    %esi
80103261:	5f                   	pop    %edi
80103262:	5d                   	pop    %ebp
80103263:	c3                   	ret
80103264:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010326b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010326f:	90                   	nop

80103270 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	57                   	push   %edi
80103274:	56                   	push   %esi
80103275:	53                   	push   %ebx
80103276:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103279:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103280:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103287:	c1 e0 08             	shl    $0x8,%eax
8010328a:	09 d0                	or     %edx,%eax
8010328c:	c1 e0 04             	shl    $0x4,%eax
8010328f:	75 1b                	jne    801032ac <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103291:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103298:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010329f:	c1 e0 08             	shl    $0x8,%eax
801032a2:	09 d0                	or     %edx,%eax
801032a4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801032a7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801032ac:	ba 00 04 00 00       	mov    $0x400,%edx
801032b1:	e8 3a ff ff ff       	call   801031f0 <mpsearch1>
801032b6:	89 c3                	mov    %eax,%ebx
801032b8:	85 c0                	test   %eax,%eax
801032ba:	0f 84 50 01 00 00    	je     80103410 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032c0:	8b 73 04             	mov    0x4(%ebx),%esi
801032c3:	85 f6                	test   %esi,%esi
801032c5:	0f 84 35 01 00 00    	je     80103400 <mpinit+0x190>
  if(memcmp(conf, "PCMP", 4) != 0)
801032cb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032ce:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801032d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032d7:	6a 04                	push   $0x4
801032d9:	68 fd 7a 10 80       	push   $0x80107afd
801032de:	50                   	push   %eax
801032df:	e8 9c 15 00 00       	call   80104880 <memcmp>
801032e4:	83 c4 10             	add    $0x10,%esp
801032e7:	85 c0                	test   %eax,%eax
801032e9:	0f 85 11 01 00 00    	jne    80103400 <mpinit+0x190>
  if(conf->version != 1 && conf->version != 4)
801032ef:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801032f6:	3c 01                	cmp    $0x1,%al
801032f8:	74 08                	je     80103302 <mpinit+0x92>
801032fa:	3c 04                	cmp    $0x4,%al
801032fc:	0f 85 fe 00 00 00    	jne    80103400 <mpinit+0x190>
  if(sum((uchar*)conf, conf->length) != 0)
80103302:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103309:	66 85 d2             	test   %dx,%dx
8010330c:	74 22                	je     80103330 <mpinit+0xc0>
8010330e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103311:	89 f0                	mov    %esi,%eax
  sum = 0;
80103313:	31 d2                	xor    %edx,%edx
80103315:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103318:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010331f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103322:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103324:	39 c7                	cmp    %eax,%edi
80103326:	75 f0                	jne    80103318 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103328:	84 d2                	test   %dl,%dl
8010332a:	0f 85 d0 00 00 00    	jne    80103400 <mpinit+0x190>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103330:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103336:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103339:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
8010333c:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103341:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103348:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
8010334e:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103353:	01 d7                	add    %edx,%edi
80103355:	89 fa                	mov    %edi,%edx
80103357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010335e:	66 90                	xchg   %ax,%ax
80103360:	39 d0                	cmp    %edx,%eax
80103362:	73 15                	jae    80103379 <mpinit+0x109>
    switch(*p){
80103364:	0f b6 08             	movzbl (%eax),%ecx
80103367:	80 f9 02             	cmp    $0x2,%cl
8010336a:	74 54                	je     801033c0 <mpinit+0x150>
8010336c:	77 42                	ja     801033b0 <mpinit+0x140>
8010336e:	84 c9                	test   %cl,%cl
80103370:	74 5e                	je     801033d0 <mpinit+0x160>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103372:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103375:	39 d0                	cmp    %edx,%eax
80103377:	72 eb                	jb     80103364 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103379:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010337c:	85 f6                	test   %esi,%esi
8010337e:	0f 84 e1 00 00 00    	je     80103465 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103384:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103388:	74 15                	je     8010339f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010338a:	b8 70 00 00 00       	mov    $0x70,%eax
8010338f:	ba 22 00 00 00       	mov    $0x22,%edx
80103394:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103395:	ba 23 00 00 00       	mov    $0x23,%edx
8010339a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010339b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010339e:	ee                   	out    %al,(%dx)
  }
}
8010339f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033a2:	5b                   	pop    %ebx
801033a3:	5e                   	pop    %esi
801033a4:	5f                   	pop    %edi
801033a5:	5d                   	pop    %ebp
801033a6:	c3                   	ret
801033a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ae:	66 90                	xchg   %ax,%ax
    switch(*p){
801033b0:	83 e9 03             	sub    $0x3,%ecx
801033b3:	80 f9 01             	cmp    $0x1,%cl
801033b6:	76 ba                	jbe    80103372 <mpinit+0x102>
801033b8:	31 f6                	xor    %esi,%esi
801033ba:	eb a4                	jmp    80103360 <mpinit+0xf0>
801033bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801033c0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801033c4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033c7:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
801033cd:	eb 91                	jmp    80103360 <mpinit+0xf0>
801033cf:	90                   	nop
      if(ncpu < NCPU) {
801033d0:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
801033d6:	83 f9 07             	cmp    $0x7,%ecx
801033d9:	7f 19                	jg     801033f4 <mpinit+0x184>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033db:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801033e1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033e5:	83 c1 01             	add    $0x1,%ecx
801033e8:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033ee:	88 9f a0 17 11 80    	mov    %bl,-0x7feee860(%edi)
      p += sizeof(struct mpproc);
801033f4:	83 c0 14             	add    $0x14,%eax
      continue;
801033f7:	e9 64 ff ff ff       	jmp    80103360 <mpinit+0xf0>
801033fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103400:	83 ec 0c             	sub    $0xc,%esp
80103403:	68 02 7b 10 80       	push   $0x80107b02
80103408:	e8 73 cf ff ff       	call   80100380 <panic>
8010340d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103410:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103415:	eb 13                	jmp    8010342a <mpinit+0x1ba>
80103417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010341e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103420:	89 f3                	mov    %esi,%ebx
80103422:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103428:	74 d6                	je     80103400 <mpinit+0x190>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010342a:	83 ec 04             	sub    $0x4,%esp
8010342d:	8d 73 10             	lea    0x10(%ebx),%esi
80103430:	6a 04                	push   $0x4
80103432:	68 f8 7a 10 80       	push   $0x80107af8
80103437:	53                   	push   %ebx
80103438:	e8 43 14 00 00       	call   80104880 <memcmp>
8010343d:	83 c4 10             	add    $0x10,%esp
80103440:	85 c0                	test   %eax,%eax
80103442:	75 dc                	jne    80103420 <mpinit+0x1b0>
80103444:	89 da                	mov    %ebx,%edx
80103446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010344d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103450:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103453:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103456:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103458:	39 f2                	cmp    %esi,%edx
8010345a:	75 f4                	jne    80103450 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010345c:	84 c0                	test   %al,%al
8010345e:	75 c0                	jne    80103420 <mpinit+0x1b0>
80103460:	e9 5b fe ff ff       	jmp    801032c0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103465:	83 ec 0c             	sub    $0xc,%esp
80103468:	68 1c 7b 10 80       	push   $0x80107b1c
8010346d:	e8 0e cf ff ff       	call   80100380 <panic>
80103472:	66 90                	xchg   %ax,%ax
80103474:	66 90                	xchg   %ax,%ax
80103476:	66 90                	xchg   %ax,%ax
80103478:	66 90                	xchg   %ax,%ax
8010347a:	66 90                	xchg   %ax,%ax
8010347c:	66 90                	xchg   %ax,%ax
8010347e:	66 90                	xchg   %ax,%ax

80103480 <picinit>:
80103480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103485:	ba 21 00 00 00       	mov    $0x21,%edx
8010348a:	ee                   	out    %al,(%dx)
8010348b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103490:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103491:	c3                   	ret
80103492:	66 90                	xchg   %ax,%ax
80103494:	66 90                	xchg   %ax,%ax
80103496:	66 90                	xchg   %ax,%ax
80103498:	66 90                	xchg   %ax,%ax
8010349a:	66 90                	xchg   %ax,%ax
8010349c:	66 90                	xchg   %ax,%ax
8010349e:	66 90                	xchg   %ax,%ax

801034a0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	57                   	push   %edi
801034a4:	56                   	push   %esi
801034a5:	53                   	push   %ebx
801034a6:	83 ec 0c             	sub    $0xc,%esp
801034a9:	8b 75 08             	mov    0x8(%ebp),%esi
801034ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801034af:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801034b5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801034bb:	e8 c0 d9 ff ff       	call   80100e80 <filealloc>
801034c0:	89 06                	mov    %eax,(%esi)
801034c2:	85 c0                	test   %eax,%eax
801034c4:	0f 84 a5 00 00 00    	je     8010356f <pipealloc+0xcf>
801034ca:	e8 b1 d9 ff ff       	call   80100e80 <filealloc>
801034cf:	89 07                	mov    %eax,(%edi)
801034d1:	85 c0                	test   %eax,%eax
801034d3:	0f 84 84 00 00 00    	je     8010355d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034d9:	e8 02 f2 ff ff       	call   801026e0 <kalloc>
801034de:	89 c3                	mov    %eax,%ebx
801034e0:	85 c0                	test   %eax,%eax
801034e2:	0f 84 a0 00 00 00    	je     80103588 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
801034e8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034ef:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034f2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801034f5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034fc:	00 00 00 
  p->nwrite = 0;
801034ff:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103506:	00 00 00 
  p->nread = 0;
80103509:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103510:	00 00 00 
  initlock(&p->lock, "pipe");
80103513:	68 3b 7b 10 80       	push   $0x80107b3b
80103518:	50                   	push   %eax
80103519:	e8 62 10 00 00       	call   80104580 <initlock>
  (*f0)->type = FD_PIPE;
8010351e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103520:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103523:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103529:	8b 06                	mov    (%esi),%eax
8010352b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010352f:	8b 06                	mov    (%esi),%eax
80103531:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103535:	8b 06                	mov    (%esi),%eax
80103537:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010353a:	8b 07                	mov    (%edi),%eax
8010353c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103542:	8b 07                	mov    (%edi),%eax
80103544:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103548:	8b 07                	mov    (%edi),%eax
8010354a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010354e:	8b 07                	mov    (%edi),%eax
80103550:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103553:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103555:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103558:	5b                   	pop    %ebx
80103559:	5e                   	pop    %esi
8010355a:	5f                   	pop    %edi
8010355b:	5d                   	pop    %ebp
8010355c:	c3                   	ret
  if(*f0)
8010355d:	8b 06                	mov    (%esi),%eax
8010355f:	85 c0                	test   %eax,%eax
80103561:	74 1e                	je     80103581 <pipealloc+0xe1>
    fileclose(*f0);
80103563:	83 ec 0c             	sub    $0xc,%esp
80103566:	50                   	push   %eax
80103567:	e8 d4 d9 ff ff       	call   80100f40 <fileclose>
8010356c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010356f:	8b 07                	mov    (%edi),%eax
80103571:	85 c0                	test   %eax,%eax
80103573:	74 0c                	je     80103581 <pipealloc+0xe1>
    fileclose(*f1);
80103575:	83 ec 0c             	sub    $0xc,%esp
80103578:	50                   	push   %eax
80103579:	e8 c2 d9 ff ff       	call   80100f40 <fileclose>
8010357e:	83 c4 10             	add    $0x10,%esp
  return -1;
80103581:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103586:	eb cd                	jmp    80103555 <pipealloc+0xb5>
  if(*f0)
80103588:	8b 06                	mov    (%esi),%eax
8010358a:	85 c0                	test   %eax,%eax
8010358c:	75 d5                	jne    80103563 <pipealloc+0xc3>
8010358e:	eb df                	jmp    8010356f <pipealloc+0xcf>

80103590 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	56                   	push   %esi
80103594:	53                   	push   %ebx
80103595:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103598:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010359b:	83 ec 0c             	sub    $0xc,%esp
8010359e:	53                   	push   %ebx
8010359f:	e8 bc 11 00 00       	call   80104760 <acquire>
  if(writable){
801035a4:	83 c4 10             	add    $0x10,%esp
801035a7:	85 f6                	test   %esi,%esi
801035a9:	74 65                	je     80103610 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801035ab:	83 ec 0c             	sub    $0xc,%esp
801035ae:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801035b4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801035bb:	00 00 00 
    wakeup(&p->nread);
801035be:	50                   	push   %eax
801035bf:	e8 1c 0c 00 00       	call   801041e0 <wakeup>
801035c4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035c7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035cd:	85 d2                	test   %edx,%edx
801035cf:	75 0a                	jne    801035db <pipeclose+0x4b>
801035d1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035d7:	85 c0                	test   %eax,%eax
801035d9:	74 15                	je     801035f0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035db:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035e1:	5b                   	pop    %ebx
801035e2:	5e                   	pop    %esi
801035e3:	5d                   	pop    %ebp
    release(&p->lock);
801035e4:	e9 17 11 00 00       	jmp    80104700 <release>
801035e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035f0:	83 ec 0c             	sub    $0xc,%esp
801035f3:	53                   	push   %ebx
801035f4:	e8 07 11 00 00       	call   80104700 <release>
    kfree((char*)p);
801035f9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035fc:	83 c4 10             	add    $0x10,%esp
}
801035ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103602:	5b                   	pop    %ebx
80103603:	5e                   	pop    %esi
80103604:	5d                   	pop    %ebp
    kfree((char*)p);
80103605:	e9 16 ef ff ff       	jmp    80102520 <kfree>
8010360a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103610:	83 ec 0c             	sub    $0xc,%esp
80103613:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103619:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103620:	00 00 00 
    wakeup(&p->nwrite);
80103623:	50                   	push   %eax
80103624:	e8 b7 0b 00 00       	call   801041e0 <wakeup>
80103629:	83 c4 10             	add    $0x10,%esp
8010362c:	eb 99                	jmp    801035c7 <pipeclose+0x37>
8010362e:	66 90                	xchg   %ax,%ax

80103630 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	57                   	push   %edi
80103634:	56                   	push   %esi
80103635:	53                   	push   %ebx
80103636:	83 ec 28             	sub    $0x28,%esp
80103639:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010363c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010363f:	53                   	push   %ebx
80103640:	e8 1b 11 00 00       	call   80104760 <acquire>
  for(i = 0; i < n; i++){
80103645:	83 c4 10             	add    $0x10,%esp
80103648:	85 ff                	test   %edi,%edi
8010364a:	0f 8e ce 00 00 00    	jle    8010371e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103650:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103656:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103659:	89 7d 10             	mov    %edi,0x10(%ebp)
8010365c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010365f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103662:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103665:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010366b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103671:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103677:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010367d:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80103680:	0f 85 b6 00 00 00    	jne    8010373c <pipewrite+0x10c>
80103686:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103689:	eb 3b                	jmp    801036c6 <pipewrite+0x96>
8010368b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010368f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103690:	e8 8b 03 00 00       	call   80103a20 <myproc>
80103695:	8b 48 24             	mov    0x24(%eax),%ecx
80103698:	85 c9                	test   %ecx,%ecx
8010369a:	75 34                	jne    801036d0 <pipewrite+0xa0>
      wakeup(&p->nread);
8010369c:	83 ec 0c             	sub    $0xc,%esp
8010369f:	56                   	push   %esi
801036a0:	e8 3b 0b 00 00       	call   801041e0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036a5:	58                   	pop    %eax
801036a6:	5a                   	pop    %edx
801036a7:	53                   	push   %ebx
801036a8:	57                   	push   %edi
801036a9:	e8 72 0a 00 00       	call   80104120 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036ae:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801036b4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801036ba:	83 c4 10             	add    $0x10,%esp
801036bd:	05 00 02 00 00       	add    $0x200,%eax
801036c2:	39 c2                	cmp    %eax,%edx
801036c4:	75 2a                	jne    801036f0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801036c6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036cc:	85 c0                	test   %eax,%eax
801036ce:	75 c0                	jne    80103690 <pipewrite+0x60>
        release(&p->lock);
801036d0:	83 ec 0c             	sub    $0xc,%esp
801036d3:	53                   	push   %ebx
801036d4:	e8 27 10 00 00       	call   80104700 <release>
        return -1;
801036d9:	83 c4 10             	add    $0x10,%esp
801036dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036e4:	5b                   	pop    %ebx
801036e5:	5e                   	pop    %esi
801036e6:	5f                   	pop    %edi
801036e7:	5d                   	pop    %ebp
801036e8:	c3                   	ret
801036e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036f3:	8d 42 01             	lea    0x1(%edx),%eax
801036f6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
801036fc:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036ff:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103705:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103708:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010370c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103710:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103713:	39 c1                	cmp    %eax,%ecx
80103715:	0f 85 50 ff ff ff    	jne    8010366b <pipewrite+0x3b>
8010371b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010371e:	83 ec 0c             	sub    $0xc,%esp
80103721:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103727:	50                   	push   %eax
80103728:	e8 b3 0a 00 00       	call   801041e0 <wakeup>
  release(&p->lock);
8010372d:	89 1c 24             	mov    %ebx,(%esp)
80103730:	e8 cb 0f 00 00       	call   80104700 <release>
  return n;
80103735:	83 c4 10             	add    $0x10,%esp
80103738:	89 f8                	mov    %edi,%eax
8010373a:	eb a5                	jmp    801036e1 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010373c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010373f:	eb b2                	jmp    801036f3 <pipewrite+0xc3>
80103741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010374f:	90                   	nop

80103750 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	57                   	push   %edi
80103754:	56                   	push   %esi
80103755:	53                   	push   %ebx
80103756:	83 ec 18             	sub    $0x18,%esp
80103759:	8b 75 08             	mov    0x8(%ebp),%esi
8010375c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010375f:	56                   	push   %esi
80103760:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103766:	e8 f5 0f 00 00       	call   80104760 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010376b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103771:	83 c4 10             	add    $0x10,%esp
80103774:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010377a:	74 2f                	je     801037ab <piperead+0x5b>
8010377c:	eb 37                	jmp    801037b5 <piperead+0x65>
8010377e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103780:	e8 9b 02 00 00       	call   80103a20 <myproc>
80103785:	8b 48 24             	mov    0x24(%eax),%ecx
80103788:	85 c9                	test   %ecx,%ecx
8010378a:	0f 85 80 00 00 00    	jne    80103810 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103790:	83 ec 08             	sub    $0x8,%esp
80103793:	56                   	push   %esi
80103794:	53                   	push   %ebx
80103795:	e8 86 09 00 00       	call   80104120 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010379a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801037a0:	83 c4 10             	add    $0x10,%esp
801037a3:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
801037a9:	75 0a                	jne    801037b5 <piperead+0x65>
801037ab:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801037b1:	85 c0                	test   %eax,%eax
801037b3:	75 cb                	jne    80103780 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037b5:	8b 55 10             	mov    0x10(%ebp),%edx
801037b8:	31 db                	xor    %ebx,%ebx
801037ba:	85 d2                	test   %edx,%edx
801037bc:	7f 20                	jg     801037de <piperead+0x8e>
801037be:	eb 2c                	jmp    801037ec <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037c0:	8d 48 01             	lea    0x1(%eax),%ecx
801037c3:	25 ff 01 00 00       	and    $0x1ff,%eax
801037c8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801037ce:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801037d3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037d6:	83 c3 01             	add    $0x1,%ebx
801037d9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801037dc:	74 0e                	je     801037ec <piperead+0x9c>
    if(p->nread == p->nwrite)
801037de:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037e4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037ea:	75 d4                	jne    801037c0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037ec:	83 ec 0c             	sub    $0xc,%esp
801037ef:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037f5:	50                   	push   %eax
801037f6:	e8 e5 09 00 00       	call   801041e0 <wakeup>
  release(&p->lock);
801037fb:	89 34 24             	mov    %esi,(%esp)
801037fe:	e8 fd 0e 00 00       	call   80104700 <release>
  return i;
80103803:	83 c4 10             	add    $0x10,%esp
}
80103806:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103809:	89 d8                	mov    %ebx,%eax
8010380b:	5b                   	pop    %ebx
8010380c:	5e                   	pop    %esi
8010380d:	5f                   	pop    %edi
8010380e:	5d                   	pop    %ebp
8010380f:	c3                   	ret
      release(&p->lock);
80103810:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103813:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103818:	56                   	push   %esi
80103819:	e8 e2 0e 00 00       	call   80104700 <release>
      return -1;
8010381e:	83 c4 10             	add    $0x10,%esp
}
80103821:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103824:	89 d8                	mov    %ebx,%eax
80103826:	5b                   	pop    %ebx
80103827:	5e                   	pop    %esi
80103828:	5f                   	pop    %edi
80103829:	5d                   	pop    %ebp
8010382a:	c3                   	ret
8010382b:	66 90                	xchg   %ax,%ax
8010382d:	66 90                	xchg   %ax,%ax
8010382f:	90                   	nop

80103830 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103834:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
{
80103839:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010383c:	68 20 1d 11 80       	push   $0x80111d20
80103841:	e8 1a 0f 00 00       	call   80104760 <acquire>
80103846:	83 c4 10             	add    $0x10,%esp
80103849:	eb 17                	jmp    80103862 <allocproc+0x32>
8010384b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010384f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103850:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103856:	81 fb 54 40 11 80    	cmp    $0x80114054,%ebx
8010385c:	0f 84 8e 00 00 00    	je     801038f0 <allocproc+0xc0>
    if(p->state == UNUSED)
80103862:	8b 43 0c             	mov    0xc(%ebx),%eax
80103865:	85 c0                	test   %eax,%eax
80103867:	75 e7                	jne    80103850 <allocproc+0x20>
  return 0;

found:
  p->tickets = 10;
  p->state = EMBRYO;
  p->pid = nextpid++;
80103869:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
8010386e:	83 ec 0c             	sub    $0xc,%esp
  p->tickets = 10;
80103871:	c7 83 80 00 00 00 0a 	movl   $0xa,0x80(%ebx)
80103878:	00 00 00 
  p->state = EMBRYO;
8010387b:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103882:	8d 50 01             	lea    0x1(%eax),%edx
80103885:	89 43 10             	mov    %eax,0x10(%ebx)
80103888:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
8010388e:	68 20 1d 11 80       	push   $0x80111d20
80103893:	e8 68 0e 00 00       	call   80104700 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103898:	e8 43 ee ff ff       	call   801026e0 <kalloc>
8010389d:	83 c4 10             	add    $0x10,%esp
801038a0:	89 43 08             	mov    %eax,0x8(%ebx)
801038a3:	85 c0                	test   %eax,%eax
801038a5:	74 62                	je     80103909 <allocproc+0xd9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801038a7:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801038ad:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801038b0:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801038b5:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801038b8:	c7 40 14 df 5a 10 80 	movl   $0x80105adf,0x14(%eax)
  p->context = (struct context*)sp;
801038bf:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038c2:	6a 14                	push   $0x14
801038c4:	6a 00                	push   $0x0
801038c6:	50                   	push   %eax
801038c7:	e8 74 0f 00 00       	call   80104840 <memset>
  p->context->eip = (uint)forkret;
801038cc:	8b 43 1c             	mov    0x1c(%ebx),%eax

  p->readid = 0; // Initialize counter in allocproc()
  return p;
801038cf:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038d2:	c7 40 10 20 39 10 80 	movl   $0x80103920,0x10(%eax)
}
801038d9:	89 d8                	mov    %ebx,%eax
  p->readid = 0; // Initialize counter in allocproc()
801038db:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
}
801038e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038e5:	c9                   	leave
801038e6:	c3                   	ret
801038e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ee:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
801038f0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038f3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038f5:	68 20 1d 11 80       	push   $0x80111d20
801038fa:	e8 01 0e 00 00       	call   80104700 <release>
  return 0;
801038ff:	83 c4 10             	add    $0x10,%esp
}
80103902:	89 d8                	mov    %ebx,%eax
80103904:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103907:	c9                   	leave
80103908:	c3                   	ret
    p->state = UNUSED;
80103909:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80103910:	31 db                	xor    %ebx,%ebx
80103912:	eb ee                	jmp    80103902 <allocproc+0xd2>
80103914:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010391b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010391f:	90                   	nop

80103920 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103926:	68 20 1d 11 80       	push   $0x80111d20
8010392b:	e8 d0 0d 00 00       	call   80104700 <release>

  if (first) {
80103930:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103935:	83 c4 10             	add    $0x10,%esp
80103938:	85 c0                	test   %eax,%eax
8010393a:	75 04                	jne    80103940 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010393c:	c9                   	leave
8010393d:	c3                   	ret
8010393e:	66 90                	xchg   %ax,%ax
    first = 0;
80103940:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103947:	00 00 00 
    iinit(ROOTDEV);
8010394a:	83 ec 0c             	sub    $0xc,%esp
8010394d:	6a 01                	push   $0x1
8010394f:	e8 5c dc ff ff       	call   801015b0 <iinit>
    initlog(ROOTDEV);
80103954:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010395b:	e8 d0 f3 ff ff       	call   80102d30 <initlog>
}
80103960:	83 c4 10             	add    $0x10,%esp
80103963:	c9                   	leave
80103964:	c3                   	ret
80103965:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010396c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103970 <pinit>:
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103976:	68 40 7b 10 80       	push   $0x80107b40
8010397b:	68 20 1d 11 80       	push   $0x80111d20
80103980:	e8 fb 0b 00 00       	call   80104580 <initlock>
  initlock(&readcount_lock, "readid"); //initializing the process ]
80103985:	58                   	pop    %eax
80103986:	5a                   	pop    %edx
80103987:	68 47 7b 10 80       	push   $0x80107b47
8010398c:	68 80 40 11 80       	push   $0x80114080
80103991:	e8 ea 0b 00 00       	call   80104580 <initlock>
}
80103996:	83 c4 10             	add    $0x10,%esp
80103999:	c9                   	leave
8010399a:	c3                   	ret
8010399b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010399f:	90                   	nop

801039a0 <mycpu>:
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	56                   	push   %esi
801039a4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039a5:	9c                   	pushf
801039a6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039a7:	f6 c4 02             	test   $0x2,%ah
801039aa:	75 46                	jne    801039f2 <mycpu+0x52>
  apicid = lapicid();
801039ac:	e8 af ef ff ff       	call   80102960 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801039b1:	8b 35 84 17 11 80    	mov    0x80111784,%esi
801039b7:	85 f6                	test   %esi,%esi
801039b9:	7e 2a                	jle    801039e5 <mycpu+0x45>
801039bb:	31 d2                	xor    %edx,%edx
801039bd:	eb 08                	jmp    801039c7 <mycpu+0x27>
801039bf:	90                   	nop
801039c0:	83 c2 01             	add    $0x1,%edx
801039c3:	39 f2                	cmp    %esi,%edx
801039c5:	74 1e                	je     801039e5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
801039c7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801039cd:	0f b6 99 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ebx
801039d4:	39 c3                	cmp    %eax,%ebx
801039d6:	75 e8                	jne    801039c0 <mycpu+0x20>
}
801039d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039db:	8d 81 a0 17 11 80    	lea    -0x7feee860(%ecx),%eax
}
801039e1:	5b                   	pop    %ebx
801039e2:	5e                   	pop    %esi
801039e3:	5d                   	pop    %ebp
801039e4:	c3                   	ret
  panic("unknown apicid\n");
801039e5:	83 ec 0c             	sub    $0xc,%esp
801039e8:	68 4e 7b 10 80       	push   $0x80107b4e
801039ed:	e8 8e c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
801039f2:	83 ec 0c             	sub    $0xc,%esp
801039f5:	68 2c 7c 10 80       	push   $0x80107c2c
801039fa:	e8 81 c9 ff ff       	call   80100380 <panic>
801039ff:	90                   	nop

80103a00 <cpuid>:
cpuid() {
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a06:	e8 95 ff ff ff       	call   801039a0 <mycpu>
}
80103a0b:	c9                   	leave
  return mycpu()-cpus;
80103a0c:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103a11:	c1 f8 04             	sar    $0x4,%eax
80103a14:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a1a:	c3                   	ret
80103a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a1f:	90                   	nop

80103a20 <myproc>:
myproc(void) {
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	53                   	push   %ebx
80103a24:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a27:	e8 e4 0b 00 00       	call   80104610 <pushcli>
  c = mycpu();
80103a2c:	e8 6f ff ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103a31:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a37:	e8 24 0c 00 00       	call   80104660 <popcli>
}
80103a3c:	89 d8                	mov    %ebx,%eax
80103a3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a41:	c9                   	leave
80103a42:	c3                   	ret
80103a43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a50 <userinit>:
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	53                   	push   %ebx
80103a54:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a57:	e8 d4 fd ff ff       	call   80103830 <allocproc>
80103a5c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a5e:	a3 54 40 11 80       	mov    %eax,0x80114054
  if((p->pgdir = setupkvm()) == 0)
80103a63:	e8 58 36 00 00       	call   801070c0 <setupkvm>
80103a68:	89 43 04             	mov    %eax,0x4(%ebx)
80103a6b:	85 c0                	test   %eax,%eax
80103a6d:	0f 84 bd 00 00 00    	je     80103b30 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a73:	83 ec 04             	sub    $0x4,%esp
80103a76:	68 2c 00 00 00       	push   $0x2c
80103a7b:	68 64 a4 10 80       	push   $0x8010a464
80103a80:	50                   	push   %eax
80103a81:	e8 1a 33 00 00       	call   80106da0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a86:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a89:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a8f:	6a 4c                	push   $0x4c
80103a91:	6a 00                	push   $0x0
80103a93:	ff 73 18             	push   0x18(%ebx)
80103a96:	e8 a5 0d 00 00       	call   80104840 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a9b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a9e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103aa3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103aa6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103aab:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103aaf:	8b 43 18             	mov    0x18(%ebx),%eax
80103ab2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103ab6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ab9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103abd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ac1:	8b 43 18             	mov    0x18(%ebx),%eax
80103ac4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ac8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103acc:	8b 43 18             	mov    0x18(%ebx),%eax
80103acf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103ad6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ad9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ae0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ae3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103aea:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103aed:	6a 10                	push   $0x10
80103aef:	68 77 7b 10 80       	push   $0x80107b77
80103af4:	50                   	push   %eax
80103af5:	e8 f6 0e 00 00       	call   801049f0 <safestrcpy>
  p->cwd = namei("/");
80103afa:	c7 04 24 80 7b 10 80 	movl   $0x80107b80,(%esp)
80103b01:	e8 fa e5 ff ff       	call   80102100 <namei>
80103b06:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b09:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103b10:	e8 4b 0c 00 00       	call   80104760 <acquire>
  p->state = RUNNABLE;
80103b15:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b1c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103b23:	e8 d8 0b 00 00       	call   80104700 <release>
}
80103b28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b2b:	83 c4 10             	add    $0x10,%esp
80103b2e:	c9                   	leave
80103b2f:	c3                   	ret
    panic("userinit: out of memory?");
80103b30:	83 ec 0c             	sub    $0xc,%esp
80103b33:	68 5e 7b 10 80       	push   $0x80107b5e
80103b38:	e8 43 c8 ff ff       	call   80100380 <panic>
80103b3d:	8d 76 00             	lea    0x0(%esi),%esi

80103b40 <growproc>:
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	56                   	push   %esi
80103b44:	53                   	push   %ebx
80103b45:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b48:	e8 c3 0a 00 00       	call   80104610 <pushcli>
  c = mycpu();
80103b4d:	e8 4e fe ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103b52:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b58:	e8 03 0b 00 00       	call   80104660 <popcli>
  sz = curproc->sz;
80103b5d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b5f:	85 f6                	test   %esi,%esi
80103b61:	7f 1d                	jg     80103b80 <growproc+0x40>
  } else if(n < 0){
80103b63:	75 3b                	jne    80103ba0 <growproc+0x60>
  switchuvm(curproc);
80103b65:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b68:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b6a:	53                   	push   %ebx
80103b6b:	e8 20 31 00 00       	call   80106c90 <switchuvm>
  return 0;
80103b70:	83 c4 10             	add    $0x10,%esp
80103b73:	31 c0                	xor    %eax,%eax
}
80103b75:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b78:	5b                   	pop    %ebx
80103b79:	5e                   	pop    %esi
80103b7a:	5d                   	pop    %ebp
80103b7b:	c3                   	ret
80103b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b80:	83 ec 04             	sub    $0x4,%esp
80103b83:	01 c6                	add    %eax,%esi
80103b85:	56                   	push   %esi
80103b86:	50                   	push   %eax
80103b87:	ff 73 04             	push   0x4(%ebx)
80103b8a:	e8 61 33 00 00       	call   80106ef0 <allocuvm>
80103b8f:	83 c4 10             	add    $0x10,%esp
80103b92:	85 c0                	test   %eax,%eax
80103b94:	75 cf                	jne    80103b65 <growproc+0x25>
      return -1;
80103b96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b9b:	eb d8                	jmp    80103b75 <growproc+0x35>
80103b9d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ba0:	83 ec 04             	sub    $0x4,%esp
80103ba3:	01 c6                	add    %eax,%esi
80103ba5:	56                   	push   %esi
80103ba6:	50                   	push   %eax
80103ba7:	ff 73 04             	push   0x4(%ebx)
80103baa:	e8 61 34 00 00       	call   80107010 <deallocuvm>
80103baf:	83 c4 10             	add    $0x10,%esp
80103bb2:	85 c0                	test   %eax,%eax
80103bb4:	75 af                	jne    80103b65 <growproc+0x25>
80103bb6:	eb de                	jmp    80103b96 <growproc+0x56>
80103bb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bbf:	90                   	nop

80103bc0 <fork>:
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	57                   	push   %edi
80103bc4:	56                   	push   %esi
80103bc5:	53                   	push   %ebx
80103bc6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103bc9:	e8 42 0a 00 00       	call   80104610 <pushcli>
  c = mycpu();
80103bce:	e8 cd fd ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103bd3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bd9:	e8 82 0a 00 00       	call   80104660 <popcli>
  if((np = allocproc()) == 0){
80103bde:	e8 4d fc ff ff       	call   80103830 <allocproc>
80103be3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103be6:	85 c0                	test   %eax,%eax
80103be8:	0f 84 d6 00 00 00    	je     80103cc4 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103bee:	83 ec 08             	sub    $0x8,%esp
80103bf1:	ff 33                	push   (%ebx)
80103bf3:	89 c7                	mov    %eax,%edi
80103bf5:	ff 73 04             	push   0x4(%ebx)
80103bf8:	e8 b3 35 00 00       	call   801071b0 <copyuvm>
80103bfd:	83 c4 10             	add    $0x10,%esp
80103c00:	89 47 04             	mov    %eax,0x4(%edi)
80103c03:	85 c0                	test   %eax,%eax
80103c05:	0f 84 9a 00 00 00    	je     80103ca5 <fork+0xe5>
  np->sz = curproc->sz;
80103c0b:	8b 03                	mov    (%ebx),%eax
80103c0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c10:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103c12:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103c15:	89 c8                	mov    %ecx,%eax
80103c17:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103c1a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c1f:	8b 73 18             	mov    0x18(%ebx),%esi
80103c22:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c24:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c26:	8b 40 18             	mov    0x18(%eax),%eax
80103c29:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103c30:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c34:	85 c0                	test   %eax,%eax
80103c36:	74 13                	je     80103c4b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c38:	83 ec 0c             	sub    $0xc,%esp
80103c3b:	50                   	push   %eax
80103c3c:	e8 af d2 ff ff       	call   80100ef0 <filedup>
80103c41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c44:	83 c4 10             	add    $0x10,%esp
80103c47:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c4b:	83 c6 01             	add    $0x1,%esi
80103c4e:	83 fe 10             	cmp    $0x10,%esi
80103c51:	75 dd                	jne    80103c30 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103c53:	83 ec 0c             	sub    $0xc,%esp
80103c56:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c59:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c5c:	e8 3f db ff ff       	call   801017a0 <idup>
80103c61:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c64:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c67:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c6a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c6d:	6a 10                	push   $0x10
80103c6f:	53                   	push   %ebx
80103c70:	50                   	push   %eax
80103c71:	e8 7a 0d 00 00       	call   801049f0 <safestrcpy>
  pid = np->pid;
80103c76:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c79:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c80:	e8 db 0a 00 00       	call   80104760 <acquire>
  np->state = RUNNABLE;
80103c85:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c8c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c93:	e8 68 0a 00 00       	call   80104700 <release>
  return pid;
80103c98:	83 c4 10             	add    $0x10,%esp
}
80103c9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c9e:	89 d8                	mov    %ebx,%eax
80103ca0:	5b                   	pop    %ebx
80103ca1:	5e                   	pop    %esi
80103ca2:	5f                   	pop    %edi
80103ca3:	5d                   	pop    %ebp
80103ca4:	c3                   	ret
    kfree(np->kstack);
80103ca5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103ca8:	83 ec 0c             	sub    $0xc,%esp
80103cab:	ff 73 08             	push   0x8(%ebx)
80103cae:	e8 6d e8 ff ff       	call   80102520 <kfree>
    np->kstack = 0;
80103cb3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103cba:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103cbd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103cc4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103cc9:	eb d0                	jmp    80103c9b <fork+0xdb>
80103ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ccf:	90                   	nop

80103cd0 <scheduler>:
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	57                   	push   %edi
80103cd4:	56                   	push   %esi
80103cd5:	53                   	push   %ebx
80103cd6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103cd9:	e8 c2 fc ff ff       	call   801039a0 <mycpu>
  c->proc = 0;
80103cde:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ce5:	00 00 00 
  struct cpu *c = mycpu();
80103ce8:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
80103cea:	8d 40 04             	lea    0x4(%eax),%eax
80103ced:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80103cf0:	fb                   	sti
    int allTickets = 0;
80103cf1:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) allTickets = allTickets + p->tickets;
80103cf3:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cff:	90                   	nop
80103d00:	03 90 80 00 00 00    	add    0x80(%eax),%edx
80103d06:	05 8c 00 00 00       	add    $0x8c,%eax
80103d0b:	3d 54 40 11 80       	cmp    $0x80114054,%eax
80103d10:	75 ee                	jne    80103d00 <scheduler+0x30>
    long wins = random_at_most(allTickets);
80103d12:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d15:	bf 54 1d 11 80       	mov    $0x80111d54,%edi
    long wins = random_at_most(allTickets);
80103d1a:	52                   	push   %edx
80103d1b:	e8 a0 38 00 00       	call   801075c0 <random_at_most>
    acquire(&ptable.lock);
80103d20:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
    long wins = random_at_most(allTickets);
80103d27:	89 c6                	mov    %eax,%esi
    acquire(&ptable.lock);
80103d29:	e8 32 0a 00 00       	call   80104760 <acquire>
80103d2e:	83 c4 10             	add    $0x10,%esp
    int approved_tickets = 0;
80103d31:	31 d2                	xor    %edx,%edx
      if(RUNNABLE != p->state) continue;
80103d33:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103d37:	75 5f                	jne    80103d98 <scheduler+0xc8>
      approved_tickets += p->tickets;
80103d39:	03 97 80 00 00 00    	add    0x80(%edi),%edx
      if(wins>approved_tickets) continue;
80103d3f:	39 d6                	cmp    %edx,%esi
80103d41:	7f 55                	jg     80103d98 <scheduler+0xc8>
      switchuvm(p);
80103d43:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103d46:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(p);
80103d4c:	57                   	push   %edi
80103d4d:	e8 3e 2f 00 00       	call   80106c90 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103d52:	58                   	pop    %eax
80103d53:	5a                   	pop    %edx
80103d54:	ff 77 1c             	push   0x1c(%edi)
80103d57:	ff 75 e4             	push   -0x1c(%ebp)
      p->ticks = 1+p->ticks;
80103d5a:	83 87 84 00 00 00 01 	addl   $0x1,0x84(%edi)
      p->state = RUNNING;
80103d61:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      swtch(&(c->scheduler), p->context);
80103d68:	e8 de 0c 00 00       	call   80104a4b <swtch>
      switchkvm();
80103d6d:	e8 0e 2f 00 00       	call   80106c80 <switchkvm>
      break;
80103d72:	83 c4 10             	add    $0x10,%esp
      c->proc = 0;
80103d75:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103d7c:	00 00 00 
    release(&ptable.lock);
80103d7f:	83 ec 0c             	sub    $0xc,%esp
80103d82:	68 20 1d 11 80       	push   $0x80111d20
80103d87:	e8 74 09 00 00       	call   80104700 <release>
  for(;;){
80103d8c:	83 c4 10             	add    $0x10,%esp
80103d8f:	e9 5c ff ff ff       	jmp    80103cf0 <scheduler+0x20>
80103d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d98:	81 c7 8c 00 00 00    	add    $0x8c,%edi
80103d9e:	81 ff 54 40 11 80    	cmp    $0x80114054,%edi
80103da4:	75 8d                	jne    80103d33 <scheduler+0x63>
80103da6:	eb d7                	jmp    80103d7f <scheduler+0xaf>
80103da8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103daf:	90                   	nop

80103db0 <sched>:
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	56                   	push   %esi
80103db4:	53                   	push   %ebx
  pushcli();
80103db5:	e8 56 08 00 00       	call   80104610 <pushcli>
  c = mycpu();
80103dba:	e8 e1 fb ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103dbf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dc5:	e8 96 08 00 00       	call   80104660 <popcli>
  if(!holding(&ptable.lock))
80103dca:	83 ec 0c             	sub    $0xc,%esp
80103dcd:	68 20 1d 11 80       	push   $0x80111d20
80103dd2:	e8 e9 08 00 00       	call   801046c0 <holding>
80103dd7:	83 c4 10             	add    $0x10,%esp
80103dda:	85 c0                	test   %eax,%eax
80103ddc:	74 4f                	je     80103e2d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103dde:	e8 bd fb ff ff       	call   801039a0 <mycpu>
80103de3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103dea:	75 68                	jne    80103e54 <sched+0xa4>
  if(p->state == RUNNING)
80103dec:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103df0:	74 55                	je     80103e47 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103df2:	9c                   	pushf
80103df3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103df4:	f6 c4 02             	test   $0x2,%ah
80103df7:	75 41                	jne    80103e3a <sched+0x8a>
  intena = mycpu()->intena;
80103df9:	e8 a2 fb ff ff       	call   801039a0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103dfe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103e01:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103e07:	e8 94 fb ff ff       	call   801039a0 <mycpu>
80103e0c:	83 ec 08             	sub    $0x8,%esp
80103e0f:	ff 70 04             	push   0x4(%eax)
80103e12:	53                   	push   %ebx
80103e13:	e8 33 0c 00 00       	call   80104a4b <swtch>
  mycpu()->intena = intena;
80103e18:	e8 83 fb ff ff       	call   801039a0 <mycpu>
}
80103e1d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e20:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e29:	5b                   	pop    %ebx
80103e2a:	5e                   	pop    %esi
80103e2b:	5d                   	pop    %ebp
80103e2c:	c3                   	ret
    panic("sched ptable.lock");
80103e2d:	83 ec 0c             	sub    $0xc,%esp
80103e30:	68 82 7b 10 80       	push   $0x80107b82
80103e35:	e8 46 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103e3a:	83 ec 0c             	sub    $0xc,%esp
80103e3d:	68 ae 7b 10 80       	push   $0x80107bae
80103e42:	e8 39 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103e47:	83 ec 0c             	sub    $0xc,%esp
80103e4a:	68 a0 7b 10 80       	push   $0x80107ba0
80103e4f:	e8 2c c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103e54:	83 ec 0c             	sub    $0xc,%esp
80103e57:	68 94 7b 10 80       	push   $0x80107b94
80103e5c:	e8 1f c5 ff ff       	call   80100380 <panic>
80103e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e6f:	90                   	nop

80103e70 <exit>:
{
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	57                   	push   %edi
80103e74:	56                   	push   %esi
80103e75:	53                   	push   %ebx
80103e76:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103e79:	e8 a2 fb ff ff       	call   80103a20 <myproc>
  if(curproc == initproc)
80103e7e:	39 05 54 40 11 80    	cmp    %eax,0x80114054
80103e84:	0f 84 07 01 00 00    	je     80103f91 <exit+0x121>
80103e8a:	89 c3                	mov    %eax,%ebx
80103e8c:	8d 70 28             	lea    0x28(%eax),%esi
80103e8f:	8d 78 68             	lea    0x68(%eax),%edi
80103e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103e98:	8b 06                	mov    (%esi),%eax
80103e9a:	85 c0                	test   %eax,%eax
80103e9c:	74 12                	je     80103eb0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103e9e:	83 ec 0c             	sub    $0xc,%esp
80103ea1:	50                   	push   %eax
80103ea2:	e8 99 d0 ff ff       	call   80100f40 <fileclose>
      curproc->ofile[fd] = 0;
80103ea7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103ead:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103eb0:	83 c6 04             	add    $0x4,%esi
80103eb3:	39 f7                	cmp    %esi,%edi
80103eb5:	75 e1                	jne    80103e98 <exit+0x28>
  begin_op();
80103eb7:	e8 14 ef ff ff       	call   80102dd0 <begin_op>
  iput(curproc->cwd);
80103ebc:	83 ec 0c             	sub    $0xc,%esp
80103ebf:	ff 73 68             	push   0x68(%ebx)
80103ec2:	e8 39 da ff ff       	call   80101900 <iput>
  end_op();
80103ec7:	e8 74 ef ff ff       	call   80102e40 <end_op>
  curproc->cwd = 0;
80103ecc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103ed3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103eda:	e8 81 08 00 00       	call   80104760 <acquire>
  wakeup1(curproc->parent);
80103edf:	8b 53 14             	mov    0x14(%ebx),%edx
80103ee2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ee5:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103eea:	eb 10                	jmp    80103efc <exit+0x8c>
80103eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ef0:	05 8c 00 00 00       	add    $0x8c,%eax
80103ef5:	3d 54 40 11 80       	cmp    $0x80114054,%eax
80103efa:	74 1e                	je     80103f1a <exit+0xaa>
    if(p->state == SLEEPING && p->chan == chan)
80103efc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f00:	75 ee                	jne    80103ef0 <exit+0x80>
80103f02:	3b 50 20             	cmp    0x20(%eax),%edx
80103f05:	75 e9                	jne    80103ef0 <exit+0x80>
      p->state = RUNNABLE;
80103f07:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f0e:	05 8c 00 00 00       	add    $0x8c,%eax
80103f13:	3d 54 40 11 80       	cmp    $0x80114054,%eax
80103f18:	75 e2                	jne    80103efc <exit+0x8c>
      p->parent = initproc;
80103f1a:	8b 0d 54 40 11 80    	mov    0x80114054,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f20:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103f25:	eb 17                	jmp    80103f3e <exit+0xce>
80103f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f2e:	66 90                	xchg   %ax,%ax
80103f30:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80103f36:	81 fa 54 40 11 80    	cmp    $0x80114054,%edx
80103f3c:	74 3a                	je     80103f78 <exit+0x108>
    if(p->parent == curproc){
80103f3e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103f41:	75 ed                	jne    80103f30 <exit+0xc0>
      if(p->state == ZOMBIE)
80103f43:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103f47:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103f4a:	75 e4                	jne    80103f30 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f4c:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103f51:	eb 11                	jmp    80103f64 <exit+0xf4>
80103f53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f57:	90                   	nop
80103f58:	05 8c 00 00 00       	add    $0x8c,%eax
80103f5d:	3d 54 40 11 80       	cmp    $0x80114054,%eax
80103f62:	74 cc                	je     80103f30 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103f64:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f68:	75 ee                	jne    80103f58 <exit+0xe8>
80103f6a:	3b 48 20             	cmp    0x20(%eax),%ecx
80103f6d:	75 e9                	jne    80103f58 <exit+0xe8>
      p->state = RUNNABLE;
80103f6f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f76:	eb e0                	jmp    80103f58 <exit+0xe8>
  curproc->state = ZOMBIE;
80103f78:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103f7f:	e8 2c fe ff ff       	call   80103db0 <sched>
  panic("zombie exit");
80103f84:	83 ec 0c             	sub    $0xc,%esp
80103f87:	68 cf 7b 10 80       	push   $0x80107bcf
80103f8c:	e8 ef c3 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103f91:	83 ec 0c             	sub    $0xc,%esp
80103f94:	68 c2 7b 10 80       	push   $0x80107bc2
80103f99:	e8 e2 c3 ff ff       	call   80100380 <panic>
80103f9e:	66 90                	xchg   %ax,%ax

80103fa0 <wait>:
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	56                   	push   %esi
80103fa4:	53                   	push   %ebx
  pushcli();
80103fa5:	e8 66 06 00 00       	call   80104610 <pushcli>
  c = mycpu();
80103faa:	e8 f1 f9 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103faf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103fb5:	e8 a6 06 00 00       	call   80104660 <popcli>
  acquire(&ptable.lock);
80103fba:	83 ec 0c             	sub    $0xc,%esp
80103fbd:	68 20 1d 11 80       	push   $0x80111d20
80103fc2:	e8 99 07 00 00       	call   80104760 <acquire>
80103fc7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103fca:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fcc:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103fd1:	eb 13                	jmp    80103fe6 <wait+0x46>
80103fd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fd7:	90                   	nop
80103fd8:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103fde:	81 fb 54 40 11 80    	cmp    $0x80114054,%ebx
80103fe4:	74 1e                	je     80104004 <wait+0x64>
      if(p->parent != curproc)
80103fe6:	39 73 14             	cmp    %esi,0x14(%ebx)
80103fe9:	75 ed                	jne    80103fd8 <wait+0x38>
      if(p->state == ZOMBIE){
80103feb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103fef:	74 5f                	je     80104050 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ff1:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      havekids = 1;
80103ff7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ffc:	81 fb 54 40 11 80    	cmp    $0x80114054,%ebx
80104002:	75 e2                	jne    80103fe6 <wait+0x46>
    if(!havekids || curproc->killed){
80104004:	85 c0                	test   %eax,%eax
80104006:	0f 84 9a 00 00 00    	je     801040a6 <wait+0x106>
8010400c:	8b 46 24             	mov    0x24(%esi),%eax
8010400f:	85 c0                	test   %eax,%eax
80104011:	0f 85 8f 00 00 00    	jne    801040a6 <wait+0x106>
  pushcli();
80104017:	e8 f4 05 00 00       	call   80104610 <pushcli>
  c = mycpu();
8010401c:	e8 7f f9 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80104021:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104027:	e8 34 06 00 00       	call   80104660 <popcli>
  if(p == 0)
8010402c:	85 db                	test   %ebx,%ebx
8010402e:	0f 84 89 00 00 00    	je     801040bd <wait+0x11d>
  p->chan = chan;
80104034:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104037:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010403e:	e8 6d fd ff ff       	call   80103db0 <sched>
  p->chan = 0;
80104043:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010404a:	e9 7b ff ff ff       	jmp    80103fca <wait+0x2a>
8010404f:	90                   	nop
        kfree(p->kstack);
80104050:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104053:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104056:	ff 73 08             	push   0x8(%ebx)
80104059:	e8 c2 e4 ff ff       	call   80102520 <kfree>
        p->kstack = 0;
8010405e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104065:	5a                   	pop    %edx
80104066:	ff 73 04             	push   0x4(%ebx)
80104069:	e8 d2 2f 00 00       	call   80107040 <freevm>
        p->pid = 0;
8010406e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104075:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010407c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104080:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104087:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010408e:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104095:	e8 66 06 00 00       	call   80104700 <release>
        return pid;
8010409a:	83 c4 10             	add    $0x10,%esp
}
8010409d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040a0:	89 f0                	mov    %esi,%eax
801040a2:	5b                   	pop    %ebx
801040a3:	5e                   	pop    %esi
801040a4:	5d                   	pop    %ebp
801040a5:	c3                   	ret
      release(&ptable.lock);
801040a6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801040a9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801040ae:	68 20 1d 11 80       	push   $0x80111d20
801040b3:	e8 48 06 00 00       	call   80104700 <release>
      return -1;
801040b8:	83 c4 10             	add    $0x10,%esp
801040bb:	eb e0                	jmp    8010409d <wait+0xfd>
    panic("sleep");
801040bd:	83 ec 0c             	sub    $0xc,%esp
801040c0:	68 db 7b 10 80       	push   $0x80107bdb
801040c5:	e8 b6 c2 ff ff       	call   80100380 <panic>
801040ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040d0 <yield>:
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	53                   	push   %ebx
801040d4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801040d7:	68 20 1d 11 80       	push   $0x80111d20
801040dc:	e8 7f 06 00 00       	call   80104760 <acquire>
  pushcli();
801040e1:	e8 2a 05 00 00       	call   80104610 <pushcli>
  c = mycpu();
801040e6:	e8 b5 f8 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
801040eb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040f1:	e8 6a 05 00 00       	call   80104660 <popcli>
  myproc()->state = RUNNABLE;
801040f6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801040fd:	e8 ae fc ff ff       	call   80103db0 <sched>
  release(&ptable.lock);
80104102:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104109:	e8 f2 05 00 00       	call   80104700 <release>
}
8010410e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104111:	83 c4 10             	add    $0x10,%esp
80104114:	c9                   	leave
80104115:	c3                   	ret
80104116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010411d:	8d 76 00             	lea    0x0(%esi),%esi

80104120 <sleep>:
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	57                   	push   %edi
80104124:	56                   	push   %esi
80104125:	53                   	push   %ebx
80104126:	83 ec 0c             	sub    $0xc,%esp
80104129:	8b 7d 08             	mov    0x8(%ebp),%edi
8010412c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010412f:	e8 dc 04 00 00       	call   80104610 <pushcli>
  c = mycpu();
80104134:	e8 67 f8 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80104139:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010413f:	e8 1c 05 00 00       	call   80104660 <popcli>
  if(p == 0)
80104144:	85 db                	test   %ebx,%ebx
80104146:	0f 84 87 00 00 00    	je     801041d3 <sleep+0xb3>
  if(lk == 0)
8010414c:	85 f6                	test   %esi,%esi
8010414e:	74 76                	je     801041c6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104150:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80104156:	74 50                	je     801041a8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104158:	83 ec 0c             	sub    $0xc,%esp
8010415b:	68 20 1d 11 80       	push   $0x80111d20
80104160:	e8 fb 05 00 00       	call   80104760 <acquire>
    release(lk);
80104165:	89 34 24             	mov    %esi,(%esp)
80104168:	e8 93 05 00 00       	call   80104700 <release>
  p->chan = chan;
8010416d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104170:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104177:	e8 34 fc ff ff       	call   80103db0 <sched>
  p->chan = 0;
8010417c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104183:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010418a:	e8 71 05 00 00       	call   80104700 <release>
    acquire(lk);
8010418f:	89 75 08             	mov    %esi,0x8(%ebp)
80104192:	83 c4 10             	add    $0x10,%esp
}
80104195:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104198:	5b                   	pop    %ebx
80104199:	5e                   	pop    %esi
8010419a:	5f                   	pop    %edi
8010419b:	5d                   	pop    %ebp
    acquire(lk);
8010419c:	e9 bf 05 00 00       	jmp    80104760 <acquire>
801041a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801041a8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041ab:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041b2:	e8 f9 fb ff ff       	call   80103db0 <sched>
  p->chan = 0;
801041b7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801041be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041c1:	5b                   	pop    %ebx
801041c2:	5e                   	pop    %esi
801041c3:	5f                   	pop    %edi
801041c4:	5d                   	pop    %ebp
801041c5:	c3                   	ret
    panic("sleep without lk");
801041c6:	83 ec 0c             	sub    $0xc,%esp
801041c9:	68 e1 7b 10 80       	push   $0x80107be1
801041ce:	e8 ad c1 ff ff       	call   80100380 <panic>
    panic("sleep");
801041d3:	83 ec 0c             	sub    $0xc,%esp
801041d6:	68 db 7b 10 80       	push   $0x80107bdb
801041db:	e8 a0 c1 ff ff       	call   80100380 <panic>

801041e0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	53                   	push   %ebx
801041e4:	83 ec 10             	sub    $0x10,%esp
801041e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801041ea:	68 20 1d 11 80       	push   $0x80111d20
801041ef:	e8 6c 05 00 00       	call   80104760 <acquire>
801041f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041f7:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801041fc:	eb 0e                	jmp    8010420c <wakeup+0x2c>
801041fe:	66 90                	xchg   %ax,%ax
80104200:	05 8c 00 00 00       	add    $0x8c,%eax
80104205:	3d 54 40 11 80       	cmp    $0x80114054,%eax
8010420a:	74 1e                	je     8010422a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010420c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104210:	75 ee                	jne    80104200 <wakeup+0x20>
80104212:	3b 58 20             	cmp    0x20(%eax),%ebx
80104215:	75 e9                	jne    80104200 <wakeup+0x20>
      p->state = RUNNABLE;
80104217:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010421e:	05 8c 00 00 00       	add    $0x8c,%eax
80104223:	3d 54 40 11 80       	cmp    $0x80114054,%eax
80104228:	75 e2                	jne    8010420c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010422a:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
80104231:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104234:	c9                   	leave
  release(&ptable.lock);
80104235:	e9 c6 04 00 00       	jmp    80104700 <release>
8010423a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104240 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	53                   	push   %ebx
80104244:	83 ec 10             	sub    $0x10,%esp
80104247:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010424a:	68 20 1d 11 80       	push   $0x80111d20
8010424f:	e8 0c 05 00 00       	call   80104760 <acquire>
80104254:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104257:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010425c:	eb 0e                	jmp    8010426c <kill+0x2c>
8010425e:	66 90                	xchg   %ax,%ax
80104260:	05 8c 00 00 00       	add    $0x8c,%eax
80104265:	3d 54 40 11 80       	cmp    $0x80114054,%eax
8010426a:	74 34                	je     801042a0 <kill+0x60>
    if(p->pid == pid){
8010426c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010426f:	75 ef                	jne    80104260 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104271:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104275:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010427c:	75 07                	jne    80104285 <kill+0x45>
        p->state = RUNNABLE;
8010427e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104285:	83 ec 0c             	sub    $0xc,%esp
80104288:	68 20 1d 11 80       	push   $0x80111d20
8010428d:	e8 6e 04 00 00       	call   80104700 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104292:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104295:	83 c4 10             	add    $0x10,%esp
80104298:	31 c0                	xor    %eax,%eax
}
8010429a:	c9                   	leave
8010429b:	c3                   	ret
8010429c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801042a0:	83 ec 0c             	sub    $0xc,%esp
801042a3:	68 20 1d 11 80       	push   $0x80111d20
801042a8:	e8 53 04 00 00       	call   80104700 <release>
}
801042ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801042b0:	83 c4 10             	add    $0x10,%esp
801042b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801042b8:	c9                   	leave
801042b9:	c3                   	ret
801042ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	57                   	push   %edi
801042c4:	56                   	push   %esi
801042c5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801042c8:	53                   	push   %ebx
801042c9:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
801042ce:	83 ec 3c             	sub    $0x3c,%esp
801042d1:	eb 27                	jmp    801042fa <procdump+0x3a>
801042d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042d7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801042d8:	83 ec 0c             	sub    $0xc,%esp
801042db:	68 83 7f 10 80       	push   $0x80107f83
801042e0:	e8 cb c3 ff ff       	call   801006b0 <cprintf>
801042e5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042e8:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801042ee:	81 fb c0 40 11 80    	cmp    $0x801140c0,%ebx
801042f4:	0f 84 7e 00 00 00    	je     80104378 <procdump+0xb8>
    if(p->state == UNUSED)
801042fa:	8b 43 a0             	mov    -0x60(%ebx),%eax
801042fd:	85 c0                	test   %eax,%eax
801042ff:	74 e7                	je     801042e8 <procdump+0x28>
      state = "???";
80104301:	ba f2 7b 10 80       	mov    $0x80107bf2,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104306:	83 f8 05             	cmp    $0x5,%eax
80104309:	77 11                	ja     8010431c <procdump+0x5c>
8010430b:	8b 14 85 54 7c 10 80 	mov    -0x7fef83ac(,%eax,4),%edx
      state = "???";
80104312:	b8 f2 7b 10 80       	mov    $0x80107bf2,%eax
80104317:	85 d2                	test   %edx,%edx
80104319:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010431c:	53                   	push   %ebx
8010431d:	52                   	push   %edx
8010431e:	ff 73 a4             	push   -0x5c(%ebx)
80104321:	68 f6 7b 10 80       	push   $0x80107bf6
80104326:	e8 85 c3 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
8010432b:	83 c4 10             	add    $0x10,%esp
8010432e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104332:	75 a4                	jne    801042d8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104334:	83 ec 08             	sub    $0x8,%esp
80104337:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010433a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010433d:	50                   	push   %eax
8010433e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104341:	8b 40 0c             	mov    0xc(%eax),%eax
80104344:	83 c0 08             	add    $0x8,%eax
80104347:	50                   	push   %eax
80104348:	e8 53 02 00 00       	call   801045a0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010434d:	83 c4 10             	add    $0x10,%esp
80104350:	8b 17                	mov    (%edi),%edx
80104352:	85 d2                	test   %edx,%edx
80104354:	74 82                	je     801042d8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104356:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104359:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010435c:	52                   	push   %edx
8010435d:	68 41 76 10 80       	push   $0x80107641
80104362:	e8 49 c3 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104367:	83 c4 10             	add    $0x10,%esp
8010436a:	39 f7                	cmp    %esi,%edi
8010436c:	75 e2                	jne    80104350 <procdump+0x90>
8010436e:	e9 65 ff ff ff       	jmp    801042d8 <procdump+0x18>
80104373:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104377:	90                   	nop
  }
}
80104378:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010437b:	5b                   	pop    %ebx
8010437c:	5e                   	pop    %esi
8010437d:	5f                   	pop    %edi
8010437e:	5d                   	pop    %ebp
8010437f:	c3                   	ret

80104380 <settickets>:

int settickets(int n){
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	56                   	push   %esi
80104384:	53                   	push   %ebx
80104385:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104388:	83 ec 0c             	sub    $0xc,%esp
8010438b:	68 20 1d 11 80       	push   $0x80111d20
80104390:	e8 cb 03 00 00       	call   80104760 <acquire>
  pushcli();
80104395:	e8 76 02 00 00       	call   80104610 <pushcli>
  c = mycpu();
8010439a:	e8 01 f6 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
8010439f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801043a5:	e8 b6 02 00 00       	call   80104660 <popcli>
  myproc()->tickets = n;
801043aa:	89 9e 80 00 00 00    	mov    %ebx,0x80(%esi)
  release(&ptable.lock);
801043b0:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801043b7:	e8 44 03 00 00       	call   80104700 <release>
  return n;
}
801043bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043bf:	89 d8                	mov    %ebx,%eax
801043c1:	5b                   	pop    %ebx
801043c2:	5e                   	pop    %esi
801043c3:	5d                   	pop    %ebp
801043c4:	c3                   	ret
801043c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801043d0 <getpinfo>:

int getpinfo(struct pstat* ps){
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  int i;
  acquire(&ptable.lock);
801043d6:	68 20 1d 11 80       	push   $0x80111d20
801043db:	e8 80 03 00 00       	call   80104760 <acquire>
  for(p = ptable.proc, i = 0; p < &ptable.proc[NPROC]; p++, i++){
801043e0:	8b 55 08             	mov    0x8(%ebp),%edx
801043e3:	83 c4 10             	add    $0x10,%esp
801043e6:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801043eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043ef:	90                   	nop
    if (p->state != UNUSED){
801043f0:	8b 48 0c             	mov    0xc(%eax),%ecx
801043f3:	85 c9                	test   %ecx,%ecx
801043f5:	74 2c                	je     80104423 <getpinfo+0x53>
      ps->pid[i] = ptable.proc[i].pid;
801043f7:	8b 48 10             	mov    0x10(%eax),%ecx
801043fa:	89 8a 00 02 00 00    	mov    %ecx,0x200(%edx)
      ps->inuse[i] = p->state != UNUSED;
80104400:	31 c9                	xor    %ecx,%ecx
80104402:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
80104406:	0f 95 c1             	setne  %cl
80104409:	89 0a                	mov    %ecx,(%edx)
      ps->tickets[i] = p->tickets;
8010440b:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
80104411:	89 8a 00 01 00 00    	mov    %ecx,0x100(%edx)
      ps->ticks[i] = ptable.proc[i].ticks;
80104417:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
8010441d:	89 8a 00 03 00 00    	mov    %ecx,0x300(%edx)
  for(p = ptable.proc, i = 0; p < &ptable.proc[NPROC]; p++, i++){
80104423:	05 8c 00 00 00       	add    $0x8c,%eax
80104428:	83 c2 04             	add    $0x4,%edx
8010442b:	3d 54 40 11 80       	cmp    $0x80114054,%eax
80104430:	75 be                	jne    801043f0 <getpinfo+0x20>
    }
  }
  release(&ptable.lock);
80104432:	83 ec 0c             	sub    $0xc,%esp
80104435:	68 20 1d 11 80       	push   $0x80111d20
8010443a:	e8 c1 02 00 00       	call   80104700 <release>
  return 0;
}
8010443f:	31 c0                	xor    %eax,%eax
80104441:	c9                   	leave
80104442:	c3                   	ret
80104443:	66 90                	xchg   %ax,%ax
80104445:	66 90                	xchg   %ax,%ax
80104447:	66 90                	xchg   %ax,%ax
80104449:	66 90                	xchg   %ax,%ax
8010444b:	66 90                	xchg   %ax,%ax
8010444d:	66 90                	xchg   %ax,%ax
8010444f:	90                   	nop

80104450 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	53                   	push   %ebx
80104454:	83 ec 0c             	sub    $0xc,%esp
80104457:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010445a:	68 6c 7c 10 80       	push   $0x80107c6c
8010445f:	8d 43 04             	lea    0x4(%ebx),%eax
80104462:	50                   	push   %eax
80104463:	e8 18 01 00 00       	call   80104580 <initlock>
  lk->name = name;
80104468:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010446b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104471:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104474:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010447b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010447e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104481:	c9                   	leave
80104482:	c3                   	ret
80104483:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010448a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104490 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	56                   	push   %esi
80104494:	53                   	push   %ebx
80104495:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104498:	8d 73 04             	lea    0x4(%ebx),%esi
8010449b:	83 ec 0c             	sub    $0xc,%esp
8010449e:	56                   	push   %esi
8010449f:	e8 bc 02 00 00       	call   80104760 <acquire>
  while (lk->locked) {
801044a4:	8b 13                	mov    (%ebx),%edx
801044a6:	83 c4 10             	add    $0x10,%esp
801044a9:	85 d2                	test   %edx,%edx
801044ab:	74 16                	je     801044c3 <acquiresleep+0x33>
801044ad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801044b0:	83 ec 08             	sub    $0x8,%esp
801044b3:	56                   	push   %esi
801044b4:	53                   	push   %ebx
801044b5:	e8 66 fc ff ff       	call   80104120 <sleep>
  while (lk->locked) {
801044ba:	8b 03                	mov    (%ebx),%eax
801044bc:	83 c4 10             	add    $0x10,%esp
801044bf:	85 c0                	test   %eax,%eax
801044c1:	75 ed                	jne    801044b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801044c3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801044c9:	e8 52 f5 ff ff       	call   80103a20 <myproc>
801044ce:	8b 40 10             	mov    0x10(%eax),%eax
801044d1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801044d4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801044d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044da:	5b                   	pop    %ebx
801044db:	5e                   	pop    %esi
801044dc:	5d                   	pop    %ebp
  release(&lk->lk);
801044dd:	e9 1e 02 00 00       	jmp    80104700 <release>
801044e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044f0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	56                   	push   %esi
801044f4:	53                   	push   %ebx
801044f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044f8:	8d 73 04             	lea    0x4(%ebx),%esi
801044fb:	83 ec 0c             	sub    $0xc,%esp
801044fe:	56                   	push   %esi
801044ff:	e8 5c 02 00 00       	call   80104760 <acquire>
  lk->locked = 0;
80104504:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010450a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104511:	89 1c 24             	mov    %ebx,(%esp)
80104514:	e8 c7 fc ff ff       	call   801041e0 <wakeup>
  release(&lk->lk);
80104519:	89 75 08             	mov    %esi,0x8(%ebp)
8010451c:	83 c4 10             	add    $0x10,%esp
}
8010451f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104522:	5b                   	pop    %ebx
80104523:	5e                   	pop    %esi
80104524:	5d                   	pop    %ebp
  release(&lk->lk);
80104525:	e9 d6 01 00 00       	jmp    80104700 <release>
8010452a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104530 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	57                   	push   %edi
80104534:	31 ff                	xor    %edi,%edi
80104536:	56                   	push   %esi
80104537:	53                   	push   %ebx
80104538:	83 ec 18             	sub    $0x18,%esp
8010453b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010453e:	8d 73 04             	lea    0x4(%ebx),%esi
80104541:	56                   	push   %esi
80104542:	e8 19 02 00 00       	call   80104760 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104547:	8b 03                	mov    (%ebx),%eax
80104549:	83 c4 10             	add    $0x10,%esp
8010454c:	85 c0                	test   %eax,%eax
8010454e:	75 18                	jne    80104568 <holdingsleep+0x38>
  release(&lk->lk);
80104550:	83 ec 0c             	sub    $0xc,%esp
80104553:	56                   	push   %esi
80104554:	e8 a7 01 00 00       	call   80104700 <release>
  return r;
}
80104559:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010455c:	89 f8                	mov    %edi,%eax
8010455e:	5b                   	pop    %ebx
8010455f:	5e                   	pop    %esi
80104560:	5f                   	pop    %edi
80104561:	5d                   	pop    %ebp
80104562:	c3                   	ret
80104563:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104567:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104568:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010456b:	e8 b0 f4 ff ff       	call   80103a20 <myproc>
80104570:	39 58 10             	cmp    %ebx,0x10(%eax)
80104573:	0f 94 c0             	sete   %al
80104576:	0f b6 c0             	movzbl %al,%eax
80104579:	89 c7                	mov    %eax,%edi
8010457b:	eb d3                	jmp    80104550 <holdingsleep+0x20>
8010457d:	66 90                	xchg   %ax,%ax
8010457f:	90                   	nop

80104580 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104586:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104589:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010458f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104592:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104599:	5d                   	pop    %ebp
8010459a:	c3                   	ret
8010459b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010459f:	90                   	nop

801045a0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	53                   	push   %ebx
801045a4:	8b 45 08             	mov    0x8(%ebp),%eax
801045a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801045aa:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045ad:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
801045b2:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
801045b7:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045bc:	76 10                	jbe    801045ce <getcallerpcs+0x2e>
801045be:	eb 28                	jmp    801045e8 <getcallerpcs+0x48>
801045c0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801045c6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801045cc:	77 1a                	ja     801045e8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
801045ce:	8b 5a 04             	mov    0x4(%edx),%ebx
801045d1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801045d4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801045d7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801045d9:	83 f8 0a             	cmp    $0xa,%eax
801045dc:	75 e2                	jne    801045c0 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801045de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045e1:	c9                   	leave
801045e2:	c3                   	ret
801045e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045e7:	90                   	nop
801045e8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801045eb:	8d 51 28             	lea    0x28(%ecx),%edx
801045ee:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801045f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801045f6:	83 c0 04             	add    $0x4,%eax
801045f9:	39 d0                	cmp    %edx,%eax
801045fb:	75 f3                	jne    801045f0 <getcallerpcs+0x50>
}
801045fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104600:	c9                   	leave
80104601:	c3                   	ret
80104602:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104610 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	53                   	push   %ebx
80104614:	83 ec 04             	sub    $0x4,%esp
80104617:	9c                   	pushf
80104618:	5b                   	pop    %ebx
  asm volatile("cli");
80104619:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010461a:	e8 81 f3 ff ff       	call   801039a0 <mycpu>
8010461f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104625:	85 c0                	test   %eax,%eax
80104627:	74 17                	je     80104640 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104629:	e8 72 f3 ff ff       	call   801039a0 <mycpu>
8010462e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104635:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104638:	c9                   	leave
80104639:	c3                   	ret
8010463a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104640:	e8 5b f3 ff ff       	call   801039a0 <mycpu>
80104645:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010464b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104651:	eb d6                	jmp    80104629 <pushcli+0x19>
80104653:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010465a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104660 <popcli>:

void
popcli(void)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104666:	9c                   	pushf
80104667:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104668:	f6 c4 02             	test   $0x2,%ah
8010466b:	75 35                	jne    801046a2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010466d:	e8 2e f3 ff ff       	call   801039a0 <mycpu>
80104672:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104679:	78 34                	js     801046af <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010467b:	e8 20 f3 ff ff       	call   801039a0 <mycpu>
80104680:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104686:	85 d2                	test   %edx,%edx
80104688:	74 06                	je     80104690 <popcli+0x30>
    sti();
}
8010468a:	c9                   	leave
8010468b:	c3                   	ret
8010468c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104690:	e8 0b f3 ff ff       	call   801039a0 <mycpu>
80104695:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010469b:	85 c0                	test   %eax,%eax
8010469d:	74 eb                	je     8010468a <popcli+0x2a>
  asm volatile("sti");
8010469f:	fb                   	sti
}
801046a0:	c9                   	leave
801046a1:	c3                   	ret
    panic("popcli - interruptible");
801046a2:	83 ec 0c             	sub    $0xc,%esp
801046a5:	68 77 7c 10 80       	push   $0x80107c77
801046aa:	e8 d1 bc ff ff       	call   80100380 <panic>
    panic("popcli");
801046af:	83 ec 0c             	sub    $0xc,%esp
801046b2:	68 8e 7c 10 80       	push   $0x80107c8e
801046b7:	e8 c4 bc ff ff       	call   80100380 <panic>
801046bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046c0 <holding>:
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	56                   	push   %esi
801046c4:	53                   	push   %ebx
801046c5:	8b 75 08             	mov    0x8(%ebp),%esi
801046c8:	31 db                	xor    %ebx,%ebx
  pushcli();
801046ca:	e8 41 ff ff ff       	call   80104610 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046cf:	8b 06                	mov    (%esi),%eax
801046d1:	85 c0                	test   %eax,%eax
801046d3:	75 0b                	jne    801046e0 <holding+0x20>
  popcli();
801046d5:	e8 86 ff ff ff       	call   80104660 <popcli>
}
801046da:	89 d8                	mov    %ebx,%eax
801046dc:	5b                   	pop    %ebx
801046dd:	5e                   	pop    %esi
801046de:	5d                   	pop    %ebp
801046df:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
801046e0:	8b 5e 08             	mov    0x8(%esi),%ebx
801046e3:	e8 b8 f2 ff ff       	call   801039a0 <mycpu>
801046e8:	39 c3                	cmp    %eax,%ebx
801046ea:	0f 94 c3             	sete   %bl
  popcli();
801046ed:	e8 6e ff ff ff       	call   80104660 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801046f2:	0f b6 db             	movzbl %bl,%ebx
}
801046f5:	89 d8                	mov    %ebx,%eax
801046f7:	5b                   	pop    %ebx
801046f8:	5e                   	pop    %esi
801046f9:	5d                   	pop    %ebp
801046fa:	c3                   	ret
801046fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046ff:	90                   	nop

80104700 <release>:
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	56                   	push   %esi
80104704:	53                   	push   %ebx
80104705:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104708:	e8 03 ff ff ff       	call   80104610 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010470d:	8b 03                	mov    (%ebx),%eax
8010470f:	85 c0                	test   %eax,%eax
80104711:	75 15                	jne    80104728 <release+0x28>
  popcli();
80104713:	e8 48 ff ff ff       	call   80104660 <popcli>
    panic("release");
80104718:	83 ec 0c             	sub    $0xc,%esp
8010471b:	68 95 7c 10 80       	push   $0x80107c95
80104720:	e8 5b bc ff ff       	call   80100380 <panic>
80104725:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104728:	8b 73 08             	mov    0x8(%ebx),%esi
8010472b:	e8 70 f2 ff ff       	call   801039a0 <mycpu>
80104730:	39 c6                	cmp    %eax,%esi
80104732:	75 df                	jne    80104713 <release+0x13>
  popcli();
80104734:	e8 27 ff ff ff       	call   80104660 <popcli>
  lk->pcs[0] = 0;
80104739:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104740:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104747:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010474c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104752:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104755:	5b                   	pop    %ebx
80104756:	5e                   	pop    %esi
80104757:	5d                   	pop    %ebp
  popcli();
80104758:	e9 03 ff ff ff       	jmp    80104660 <popcli>
8010475d:	8d 76 00             	lea    0x0(%esi),%esi

80104760 <acquire>:
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	53                   	push   %ebx
80104764:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104767:	e8 a4 fe ff ff       	call   80104610 <pushcli>
  if(holding(lk))
8010476c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010476f:	e8 9c fe ff ff       	call   80104610 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104774:	8b 03                	mov    (%ebx),%eax
80104776:	85 c0                	test   %eax,%eax
80104778:	0f 85 9a 00 00 00    	jne    80104818 <acquire+0xb8>
  popcli();
8010477e:	e8 dd fe ff ff       	call   80104660 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104783:	b9 01 00 00 00       	mov    $0x1,%ecx
80104788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010478f:	90                   	nop
  while(xchg(&lk->locked, 1) != 0)
80104790:	8b 55 08             	mov    0x8(%ebp),%edx
80104793:	89 c8                	mov    %ecx,%eax
80104795:	f0 87 02             	lock xchg %eax,(%edx)
80104798:	85 c0                	test   %eax,%eax
8010479a:	75 f4                	jne    80104790 <acquire+0x30>
  __sync_synchronize();
8010479c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801047a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047a4:	e8 f7 f1 ff ff       	call   801039a0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801047a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
801047ac:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
801047ae:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047b1:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
801047b7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
801047bc:	77 32                	ja     801047f0 <acquire+0x90>
  ebp = (uint*)v - 2;
801047be:	89 e8                	mov    %ebp,%eax
801047c0:	eb 14                	jmp    801047d6 <acquire+0x76>
801047c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047c8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801047ce:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047d4:	77 1a                	ja     801047f0 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
801047d6:	8b 58 04             	mov    0x4(%eax),%ebx
801047d9:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801047dd:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801047e0:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801047e2:	83 fa 0a             	cmp    $0xa,%edx
801047e5:	75 e1                	jne    801047c8 <acquire+0x68>
}
801047e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047ea:	c9                   	leave
801047eb:	c3                   	ret
801047ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047f0:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
801047f4:	8d 51 34             	lea    0x34(%ecx),%edx
801047f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047fe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104800:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104806:	83 c0 04             	add    $0x4,%eax
80104809:	39 c2                	cmp    %eax,%edx
8010480b:	75 f3                	jne    80104800 <acquire+0xa0>
}
8010480d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104810:	c9                   	leave
80104811:	c3                   	ret
80104812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104818:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010481b:	e8 80 f1 ff ff       	call   801039a0 <mycpu>
80104820:	39 c3                	cmp    %eax,%ebx
80104822:	0f 85 56 ff ff ff    	jne    8010477e <acquire+0x1e>
  popcli();
80104828:	e8 33 fe ff ff       	call   80104660 <popcli>
    panic("acquire");
8010482d:	83 ec 0c             	sub    $0xc,%esp
80104830:	68 9d 7c 10 80       	push   $0x80107c9d
80104835:	e8 46 bb ff ff       	call   80100380 <panic>
8010483a:	66 90                	xchg   %ax,%ax
8010483c:	66 90                	xchg   %ax,%ax
8010483e:	66 90                	xchg   %ax,%ax

80104840 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	57                   	push   %edi
80104844:	8b 55 08             	mov    0x8(%ebp),%edx
80104847:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010484a:	89 d0                	mov    %edx,%eax
8010484c:	09 c8                	or     %ecx,%eax
8010484e:	a8 03                	test   $0x3,%al
80104850:	75 1e                	jne    80104870 <memset+0x30>
    c &= 0xFF;
80104852:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104856:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104859:	89 d7                	mov    %edx,%edi
8010485b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104861:	fc                   	cld
80104862:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104864:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104867:	89 d0                	mov    %edx,%eax
80104869:	c9                   	leave
8010486a:	c3                   	ret
8010486b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010486f:	90                   	nop
  asm volatile("cld; rep stosb" :
80104870:	8b 45 0c             	mov    0xc(%ebp),%eax
80104873:	89 d7                	mov    %edx,%edi
80104875:	fc                   	cld
80104876:	f3 aa                	rep stos %al,%es:(%edi)
80104878:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010487b:	89 d0                	mov    %edx,%eax
8010487d:	c9                   	leave
8010487e:	c3                   	ret
8010487f:	90                   	nop

80104880 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	56                   	push   %esi
80104884:	53                   	push   %ebx
80104885:	8b 75 10             	mov    0x10(%ebp),%esi
80104888:	8b 55 08             	mov    0x8(%ebp),%edx
8010488b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010488e:	85 f6                	test   %esi,%esi
80104890:	74 2e                	je     801048c0 <memcmp+0x40>
80104892:	01 c6                	add    %eax,%esi
80104894:	eb 14                	jmp    801048aa <memcmp+0x2a>
80104896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010489d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801048a0:	83 c0 01             	add    $0x1,%eax
801048a3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801048a6:	39 f0                	cmp    %esi,%eax
801048a8:	74 16                	je     801048c0 <memcmp+0x40>
    if(*s1 != *s2)
801048aa:	0f b6 0a             	movzbl (%edx),%ecx
801048ad:	0f b6 18             	movzbl (%eax),%ebx
801048b0:	38 d9                	cmp    %bl,%cl
801048b2:	74 ec                	je     801048a0 <memcmp+0x20>
      return *s1 - *s2;
801048b4:	0f b6 c1             	movzbl %cl,%eax
801048b7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801048b9:	5b                   	pop    %ebx
801048ba:	5e                   	pop    %esi
801048bb:	5d                   	pop    %ebp
801048bc:	c3                   	ret
801048bd:	8d 76 00             	lea    0x0(%esi),%esi
801048c0:	5b                   	pop    %ebx
  return 0;
801048c1:	31 c0                	xor    %eax,%eax
}
801048c3:	5e                   	pop    %esi
801048c4:	5d                   	pop    %ebp
801048c5:	c3                   	ret
801048c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048cd:	8d 76 00             	lea    0x0(%esi),%esi

801048d0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	57                   	push   %edi
801048d4:	56                   	push   %esi
801048d5:	8b 55 08             	mov    0x8(%ebp),%edx
801048d8:	8b 75 0c             	mov    0xc(%ebp),%esi
801048db:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801048de:	39 d6                	cmp    %edx,%esi
801048e0:	73 26                	jae    80104908 <memmove+0x38>
801048e2:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
801048e5:	39 ca                	cmp    %ecx,%edx
801048e7:	73 1f                	jae    80104908 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801048e9:	85 c0                	test   %eax,%eax
801048eb:	74 0f                	je     801048fc <memmove+0x2c>
801048ed:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
801048f0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801048f4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801048f7:	83 e8 01             	sub    $0x1,%eax
801048fa:	73 f4                	jae    801048f0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801048fc:	5e                   	pop    %esi
801048fd:	89 d0                	mov    %edx,%eax
801048ff:	5f                   	pop    %edi
80104900:	5d                   	pop    %ebp
80104901:	c3                   	ret
80104902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104908:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
8010490b:	89 d7                	mov    %edx,%edi
8010490d:	85 c0                	test   %eax,%eax
8010490f:	74 eb                	je     801048fc <memmove+0x2c>
80104911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104918:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104919:	39 ce                	cmp    %ecx,%esi
8010491b:	75 fb                	jne    80104918 <memmove+0x48>
}
8010491d:	5e                   	pop    %esi
8010491e:	89 d0                	mov    %edx,%eax
80104920:	5f                   	pop    %edi
80104921:	5d                   	pop    %ebp
80104922:	c3                   	ret
80104923:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104930 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104930:	eb 9e                	jmp    801048d0 <memmove>
80104932:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104940 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	53                   	push   %ebx
80104944:	8b 55 10             	mov    0x10(%ebp),%edx
80104947:	8b 45 08             	mov    0x8(%ebp),%eax
8010494a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
8010494d:	85 d2                	test   %edx,%edx
8010494f:	75 16                	jne    80104967 <strncmp+0x27>
80104951:	eb 2d                	jmp    80104980 <strncmp+0x40>
80104953:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104957:	90                   	nop
80104958:	3a 19                	cmp    (%ecx),%bl
8010495a:	75 12                	jne    8010496e <strncmp+0x2e>
    n--, p++, q++;
8010495c:	83 c0 01             	add    $0x1,%eax
8010495f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104962:	83 ea 01             	sub    $0x1,%edx
80104965:	74 19                	je     80104980 <strncmp+0x40>
80104967:	0f b6 18             	movzbl (%eax),%ebx
8010496a:	84 db                	test   %bl,%bl
8010496c:	75 ea                	jne    80104958 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010496e:	0f b6 00             	movzbl (%eax),%eax
80104971:	0f b6 11             	movzbl (%ecx),%edx
}
80104974:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104977:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104978:	29 d0                	sub    %edx,%eax
}
8010497a:	c3                   	ret
8010497b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010497f:	90                   	nop
80104980:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104983:	31 c0                	xor    %eax,%eax
}
80104985:	c9                   	leave
80104986:	c3                   	ret
80104987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010498e:	66 90                	xchg   %ax,%ax

80104990 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	57                   	push   %edi
80104994:	56                   	push   %esi
80104995:	53                   	push   %ebx
80104996:	8b 75 08             	mov    0x8(%ebp),%esi
80104999:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010499c:	89 f0                	mov    %esi,%eax
8010499e:	eb 15                	jmp    801049b5 <strncpy+0x25>
801049a0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801049a4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801049a7:	83 c0 01             	add    $0x1,%eax
801049aa:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
801049ae:	88 48 ff             	mov    %cl,-0x1(%eax)
801049b1:	84 c9                	test   %cl,%cl
801049b3:	74 13                	je     801049c8 <strncpy+0x38>
801049b5:	89 d3                	mov    %edx,%ebx
801049b7:	83 ea 01             	sub    $0x1,%edx
801049ba:	85 db                	test   %ebx,%ebx
801049bc:	7f e2                	jg     801049a0 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
801049be:	5b                   	pop    %ebx
801049bf:	89 f0                	mov    %esi,%eax
801049c1:	5e                   	pop    %esi
801049c2:	5f                   	pop    %edi
801049c3:	5d                   	pop    %ebp
801049c4:	c3                   	ret
801049c5:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
801049c8:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
801049cb:	83 e9 01             	sub    $0x1,%ecx
801049ce:	85 d2                	test   %edx,%edx
801049d0:	74 ec                	je     801049be <strncpy+0x2e>
801049d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
801049d8:	83 c0 01             	add    $0x1,%eax
801049db:	89 ca                	mov    %ecx,%edx
801049dd:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
801049e1:	29 c2                	sub    %eax,%edx
801049e3:	85 d2                	test   %edx,%edx
801049e5:	7f f1                	jg     801049d8 <strncpy+0x48>
}
801049e7:	5b                   	pop    %ebx
801049e8:	89 f0                	mov    %esi,%eax
801049ea:	5e                   	pop    %esi
801049eb:	5f                   	pop    %edi
801049ec:	5d                   	pop    %ebp
801049ed:	c3                   	ret
801049ee:	66 90                	xchg   %ax,%ax

801049f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	53                   	push   %ebx
801049f5:	8b 55 10             	mov    0x10(%ebp),%edx
801049f8:	8b 75 08             	mov    0x8(%ebp),%esi
801049fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801049fe:	85 d2                	test   %edx,%edx
80104a00:	7e 25                	jle    80104a27 <safestrcpy+0x37>
80104a02:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a06:	89 f2                	mov    %esi,%edx
80104a08:	eb 16                	jmp    80104a20 <safestrcpy+0x30>
80104a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a10:	0f b6 08             	movzbl (%eax),%ecx
80104a13:	83 c0 01             	add    $0x1,%eax
80104a16:	83 c2 01             	add    $0x1,%edx
80104a19:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a1c:	84 c9                	test   %cl,%cl
80104a1e:	74 04                	je     80104a24 <safestrcpy+0x34>
80104a20:	39 d8                	cmp    %ebx,%eax
80104a22:	75 ec                	jne    80104a10 <safestrcpy+0x20>
    ;
  *s = 0;
80104a24:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104a27:	89 f0                	mov    %esi,%eax
80104a29:	5b                   	pop    %ebx
80104a2a:	5e                   	pop    %esi
80104a2b:	5d                   	pop    %ebp
80104a2c:	c3                   	ret
80104a2d:	8d 76 00             	lea    0x0(%esi),%esi

80104a30 <strlen>:

int
strlen(const char *s)
{
80104a30:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a31:	31 c0                	xor    %eax,%eax
{
80104a33:	89 e5                	mov    %esp,%ebp
80104a35:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a38:	80 3a 00             	cmpb   $0x0,(%edx)
80104a3b:	74 0c                	je     80104a49 <strlen+0x19>
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi
80104a40:	83 c0 01             	add    $0x1,%eax
80104a43:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104a47:	75 f7                	jne    80104a40 <strlen+0x10>
    ;
  return n;
}
80104a49:	5d                   	pop    %ebp
80104a4a:	c3                   	ret

80104a4b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104a4b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104a4f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104a53:	55                   	push   %ebp
  pushl %ebx
80104a54:	53                   	push   %ebx
  pushl %esi
80104a55:	56                   	push   %esi
  pushl %edi
80104a56:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a57:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104a59:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104a5b:	5f                   	pop    %edi
  popl %esi
80104a5c:	5e                   	pop    %esi
  popl %ebx
80104a5d:	5b                   	pop    %ebx
  popl %ebp
80104a5e:	5d                   	pop    %ebp
  ret
80104a5f:	c3                   	ret

80104a60 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	53                   	push   %ebx
80104a64:	83 ec 04             	sub    $0x4,%esp
80104a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a6a:	e8 b1 ef ff ff       	call   80103a20 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a6f:	8b 00                	mov    (%eax),%eax
80104a71:	39 c3                	cmp    %eax,%ebx
80104a73:	73 1b                	jae    80104a90 <fetchint+0x30>
80104a75:	8d 53 04             	lea    0x4(%ebx),%edx
80104a78:	39 d0                	cmp    %edx,%eax
80104a7a:	72 14                	jb     80104a90 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a7f:	8b 13                	mov    (%ebx),%edx
80104a81:	89 10                	mov    %edx,(%eax)
  return 0;
80104a83:	31 c0                	xor    %eax,%eax
}
80104a85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a88:	c9                   	leave
80104a89:	c3                   	ret
80104a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a95:	eb ee                	jmp    80104a85 <fetchint+0x25>
80104a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9e:	66 90                	xchg   %ax,%ax

80104aa0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	53                   	push   %ebx
80104aa4:	83 ec 04             	sub    $0x4,%esp
80104aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104aaa:	e8 71 ef ff ff       	call   80103a20 <myproc>

  if(addr >= curproc->sz)
80104aaf:	3b 18                	cmp    (%eax),%ebx
80104ab1:	73 2d                	jae    80104ae0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104ab3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ab6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104ab8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104aba:	39 d3                	cmp    %edx,%ebx
80104abc:	73 22                	jae    80104ae0 <fetchstr+0x40>
80104abe:	89 d8                	mov    %ebx,%eax
80104ac0:	eb 0d                	jmp    80104acf <fetchstr+0x2f>
80104ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ac8:	83 c0 01             	add    $0x1,%eax
80104acb:	39 d0                	cmp    %edx,%eax
80104acd:	73 11                	jae    80104ae0 <fetchstr+0x40>
    if(*s == 0)
80104acf:	80 38 00             	cmpb   $0x0,(%eax)
80104ad2:	75 f4                	jne    80104ac8 <fetchstr+0x28>
      return s - *pp;
80104ad4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104ad6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ad9:	c9                   	leave
80104ada:	c3                   	ret
80104adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104adf:	90                   	nop
80104ae0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104ae3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ae8:	c9                   	leave
80104ae9:	c3                   	ret
80104aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104af0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	56                   	push   %esi
80104af4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104af5:	e8 26 ef ff ff       	call   80103a20 <myproc>
80104afa:	8b 55 08             	mov    0x8(%ebp),%edx
80104afd:	8b 40 18             	mov    0x18(%eax),%eax
80104b00:	8b 40 44             	mov    0x44(%eax),%eax
80104b03:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b06:	e8 15 ef ff ff       	call   80103a20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b0b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b0e:	8b 00                	mov    (%eax),%eax
80104b10:	39 c6                	cmp    %eax,%esi
80104b12:	73 1c                	jae    80104b30 <argint+0x40>
80104b14:	8d 53 08             	lea    0x8(%ebx),%edx
80104b17:	39 d0                	cmp    %edx,%eax
80104b19:	72 15                	jb     80104b30 <argint+0x40>
  *ip = *(int*)(addr);
80104b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b1e:	8b 53 04             	mov    0x4(%ebx),%edx
80104b21:	89 10                	mov    %edx,(%eax)
  return 0;
80104b23:	31 c0                	xor    %eax,%eax
}
80104b25:	5b                   	pop    %ebx
80104b26:	5e                   	pop    %esi
80104b27:	5d                   	pop    %ebp
80104b28:	c3                   	ret
80104b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b35:	eb ee                	jmp    80104b25 <argint+0x35>
80104b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b3e:	66 90                	xchg   %ax,%ax

80104b40 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	57                   	push   %edi
80104b44:	56                   	push   %esi
80104b45:	53                   	push   %ebx
80104b46:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104b49:	e8 d2 ee ff ff       	call   80103a20 <myproc>
80104b4e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b50:	e8 cb ee ff ff       	call   80103a20 <myproc>
80104b55:	8b 55 08             	mov    0x8(%ebp),%edx
80104b58:	8b 40 18             	mov    0x18(%eax),%eax
80104b5b:	8b 40 44             	mov    0x44(%eax),%eax
80104b5e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b61:	e8 ba ee ff ff       	call   80103a20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b66:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b69:	8b 00                	mov    (%eax),%eax
80104b6b:	39 c7                	cmp    %eax,%edi
80104b6d:	73 31                	jae    80104ba0 <argptr+0x60>
80104b6f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104b72:	39 c8                	cmp    %ecx,%eax
80104b74:	72 2a                	jb     80104ba0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b76:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104b79:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b7c:	85 d2                	test   %edx,%edx
80104b7e:	78 20                	js     80104ba0 <argptr+0x60>
80104b80:	8b 16                	mov    (%esi),%edx
80104b82:	39 d0                	cmp    %edx,%eax
80104b84:	73 1a                	jae    80104ba0 <argptr+0x60>
80104b86:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104b89:	01 c3                	add    %eax,%ebx
80104b8b:	39 da                	cmp    %ebx,%edx
80104b8d:	72 11                	jb     80104ba0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b92:	89 02                	mov    %eax,(%edx)
  return 0;
80104b94:	31 c0                	xor    %eax,%eax
}
80104b96:	83 c4 0c             	add    $0xc,%esp
80104b99:	5b                   	pop    %ebx
80104b9a:	5e                   	pop    %esi
80104b9b:	5f                   	pop    %edi
80104b9c:	5d                   	pop    %ebp
80104b9d:	c3                   	ret
80104b9e:	66 90                	xchg   %ax,%ax
    return -1;
80104ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ba5:	eb ef                	jmp    80104b96 <argptr+0x56>
80104ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bae:	66 90                	xchg   %ax,%ax

80104bb0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	56                   	push   %esi
80104bb4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bb5:	e8 66 ee ff ff       	call   80103a20 <myproc>
80104bba:	8b 55 08             	mov    0x8(%ebp),%edx
80104bbd:	8b 40 18             	mov    0x18(%eax),%eax
80104bc0:	8b 40 44             	mov    0x44(%eax),%eax
80104bc3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104bc6:	e8 55 ee ff ff       	call   80103a20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bcb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bce:	8b 00                	mov    (%eax),%eax
80104bd0:	39 c6                	cmp    %eax,%esi
80104bd2:	73 44                	jae    80104c18 <argstr+0x68>
80104bd4:	8d 53 08             	lea    0x8(%ebx),%edx
80104bd7:	39 d0                	cmp    %edx,%eax
80104bd9:	72 3d                	jb     80104c18 <argstr+0x68>
  *ip = *(int*)(addr);
80104bdb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104bde:	e8 3d ee ff ff       	call   80103a20 <myproc>
  if(addr >= curproc->sz)
80104be3:	3b 18                	cmp    (%eax),%ebx
80104be5:	73 31                	jae    80104c18 <argstr+0x68>
  *pp = (char*)addr;
80104be7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bea:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104bec:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104bee:	39 d3                	cmp    %edx,%ebx
80104bf0:	73 26                	jae    80104c18 <argstr+0x68>
80104bf2:	89 d8                	mov    %ebx,%eax
80104bf4:	eb 11                	jmp    80104c07 <argstr+0x57>
80104bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bfd:	8d 76 00             	lea    0x0(%esi),%esi
80104c00:	83 c0 01             	add    $0x1,%eax
80104c03:	39 d0                	cmp    %edx,%eax
80104c05:	73 11                	jae    80104c18 <argstr+0x68>
    if(*s == 0)
80104c07:	80 38 00             	cmpb   $0x0,(%eax)
80104c0a:	75 f4                	jne    80104c00 <argstr+0x50>
      return s - *pp;
80104c0c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c0e:	5b                   	pop    %ebx
80104c0f:	5e                   	pop    %esi
80104c10:	5d                   	pop    %ebp
80104c11:	c3                   	ret
80104c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c18:	5b                   	pop    %ebx
    return -1;
80104c19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c1e:	5e                   	pop    %esi
80104c1f:	5d                   	pop    %ebp
80104c20:	c3                   	ret
80104c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c2f:	90                   	nop

80104c30 <syscall>:



void
syscall(void)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	56                   	push   %esi
80104c34:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104c35:	e8 e6 ed ff ff       	call   80103a20 <myproc>

  num = curproc->tf->eax;

  acquire(&readcount_lock); //aquire the spinlock
80104c3a:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104c3d:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
80104c3f:	8b 40 18             	mov    0x18(%eax),%eax
80104c42:	8b 70 1c             	mov    0x1c(%eax),%esi
  acquire(&readcount_lock); //aquire the spinlock
80104c45:	68 80 40 11 80       	push   $0x80114080
80104c4a:	e8 11 fb ff ff       	call   80104760 <acquire>
  if (num == SYS_read){
80104c4f:	83 c4 10             	add    $0x10,%esp
80104c52:	83 fe 05             	cmp    $0x5,%esi
80104c55:	74 69                	je     80104cc0 <syscall+0x90>
    readcount++; //addcounter for read
  }
  release(&readcount_lock);//release the spinlock
80104c57:	83 ec 0c             	sub    $0xc,%esp
80104c5a:	68 80 40 11 80       	push   $0x80114080
80104c5f:	e8 9c fa ff ff       	call   80104700 <release>

  if (num == SYS_getreadcount){
80104c64:	83 c4 10             	add    $0x10,%esp
80104c67:	83 fe 16             	cmp    $0x16,%esi
80104c6a:	75 24                	jne    80104c90 <syscall+0x60>
    curproc->readid = readcount; 
80104c6c:	a1 60 40 11 80       	mov    0x80114060,%eax
80104c71:	89 43 7c             	mov    %eax,0x7c(%ebx)
  }

  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c74:	8b 04 b5 e0 7c 10 80 	mov    -0x7fef8320(,%esi,4),%eax
    curproc->tf->eax = syscalls[num]();
80104c7b:	ff d0                	call   *%eax
80104c7d:	89 c2                	mov    %eax,%edx
80104c7f:	8b 43 18             	mov    0x18(%ebx),%eax
80104c82:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c85:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c88:	5b                   	pop    %ebx
80104c89:	5e                   	pop    %esi
80104c8a:	5d                   	pop    %ebp
80104c8b:	c3                   	ret
80104c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c90:	8d 46 ff             	lea    -0x1(%esi),%eax
80104c93:	83 f8 17             	cmp    $0x17,%eax
80104c96:	76 48                	jbe    80104ce0 <syscall+0xb0>
            curproc->pid, curproc->name, num);
80104c98:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104c9b:	56                   	push   %esi
80104c9c:	50                   	push   %eax
80104c9d:	ff 73 10             	push   0x10(%ebx)
80104ca0:	68 a5 7c 10 80       	push   $0x80107ca5
80104ca5:	e8 06 ba ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104caa:	8b 43 18             	mov    0x18(%ebx),%eax
80104cad:	83 c4 10             	add    $0x10,%esp
80104cb0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104cb7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cba:	5b                   	pop    %ebx
80104cbb:	5e                   	pop    %esi
80104cbc:	5d                   	pop    %ebp
80104cbd:	c3                   	ret
80104cbe:	66 90                	xchg   %ax,%ax
  release(&readcount_lock);//release the spinlock
80104cc0:	83 ec 0c             	sub    $0xc,%esp
    readcount++; //addcounter for read
80104cc3:	83 05 60 40 11 80 01 	addl   $0x1,0x80114060
  release(&readcount_lock);//release the spinlock
80104cca:	68 80 40 11 80       	push   $0x80114080
80104ccf:	e8 2c fa ff ff       	call   80104700 <release>
80104cd4:	83 c4 10             	add    $0x10,%esp
80104cd7:	eb 9b                	jmp    80104c74 <syscall+0x44>
80104cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ce0:	8b 04 b5 e0 7c 10 80 	mov    -0x7fef8320(,%esi,4),%eax
80104ce7:	85 c0                	test   %eax,%eax
80104ce9:	74 ad                	je     80104c98 <syscall+0x68>
80104ceb:	eb 8e                	jmp    80104c7b <syscall+0x4b>
80104ced:	66 90                	xchg   %ax,%ax
80104cef:	90                   	nop

80104cf0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	57                   	push   %edi
80104cf4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104cf5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104cf8:	53                   	push   %ebx
80104cf9:	83 ec 34             	sub    $0x34,%esp
80104cfc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104cff:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d02:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104d05:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d08:	57                   	push   %edi
80104d09:	50                   	push   %eax
80104d0a:	e8 11 d4 ff ff       	call   80102120 <nameiparent>
80104d0f:	83 c4 10             	add    $0x10,%esp
80104d12:	85 c0                	test   %eax,%eax
80104d14:	74 5e                	je     80104d74 <create+0x84>
    return 0;
  ilock(dp);
80104d16:	83 ec 0c             	sub    $0xc,%esp
80104d19:	89 c3                	mov    %eax,%ebx
80104d1b:	50                   	push   %eax
80104d1c:	e8 af ca ff ff       	call   801017d0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104d21:	83 c4 0c             	add    $0xc,%esp
80104d24:	6a 00                	push   $0x0
80104d26:	57                   	push   %edi
80104d27:	53                   	push   %ebx
80104d28:	e8 03 d0 ff ff       	call   80101d30 <dirlookup>
80104d2d:	83 c4 10             	add    $0x10,%esp
80104d30:	89 c6                	mov    %eax,%esi
80104d32:	85 c0                	test   %eax,%eax
80104d34:	74 4a                	je     80104d80 <create+0x90>
    iunlockput(dp);
80104d36:	83 ec 0c             	sub    $0xc,%esp
80104d39:	53                   	push   %ebx
80104d3a:	e8 21 cd ff ff       	call   80101a60 <iunlockput>
    ilock(ip);
80104d3f:	89 34 24             	mov    %esi,(%esp)
80104d42:	e8 89 ca ff ff       	call   801017d0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104d47:	83 c4 10             	add    $0x10,%esp
80104d4a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104d4f:	75 17                	jne    80104d68 <create+0x78>
80104d51:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104d56:	75 10                	jne    80104d68 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d5b:	89 f0                	mov    %esi,%eax
80104d5d:	5b                   	pop    %ebx
80104d5e:	5e                   	pop    %esi
80104d5f:	5f                   	pop    %edi
80104d60:	5d                   	pop    %ebp
80104d61:	c3                   	ret
80104d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104d68:	83 ec 0c             	sub    $0xc,%esp
80104d6b:	56                   	push   %esi
80104d6c:	e8 ef cc ff ff       	call   80101a60 <iunlockput>
    return 0;
80104d71:	83 c4 10             	add    $0x10,%esp
}
80104d74:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104d77:	31 f6                	xor    %esi,%esi
}
80104d79:	5b                   	pop    %ebx
80104d7a:	89 f0                	mov    %esi,%eax
80104d7c:	5e                   	pop    %esi
80104d7d:	5f                   	pop    %edi
80104d7e:	5d                   	pop    %ebp
80104d7f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104d80:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104d84:	83 ec 08             	sub    $0x8,%esp
80104d87:	50                   	push   %eax
80104d88:	ff 33                	push   (%ebx)
80104d8a:	e8 d1 c8 ff ff       	call   80101660 <ialloc>
80104d8f:	83 c4 10             	add    $0x10,%esp
80104d92:	89 c6                	mov    %eax,%esi
80104d94:	85 c0                	test   %eax,%eax
80104d96:	0f 84 bc 00 00 00    	je     80104e58 <create+0x168>
  ilock(ip);
80104d9c:	83 ec 0c             	sub    $0xc,%esp
80104d9f:	50                   	push   %eax
80104da0:	e8 2b ca ff ff       	call   801017d0 <ilock>
  ip->major = major;
80104da5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104da9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104dad:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104db1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104db5:	b8 01 00 00 00       	mov    $0x1,%eax
80104dba:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104dbe:	89 34 24             	mov    %esi,(%esp)
80104dc1:	e8 5a c9 ff ff       	call   80101720 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104dc6:	83 c4 10             	add    $0x10,%esp
80104dc9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104dce:	74 30                	je     80104e00 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104dd0:	83 ec 04             	sub    $0x4,%esp
80104dd3:	ff 76 04             	push   0x4(%esi)
80104dd6:	57                   	push   %edi
80104dd7:	53                   	push   %ebx
80104dd8:	e8 63 d2 ff ff       	call   80102040 <dirlink>
80104ddd:	83 c4 10             	add    $0x10,%esp
80104de0:	85 c0                	test   %eax,%eax
80104de2:	78 67                	js     80104e4b <create+0x15b>
  iunlockput(dp);
80104de4:	83 ec 0c             	sub    $0xc,%esp
80104de7:	53                   	push   %ebx
80104de8:	e8 73 cc ff ff       	call   80101a60 <iunlockput>
  return ip;
80104ded:	83 c4 10             	add    $0x10,%esp
}
80104df0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104df3:	89 f0                	mov    %esi,%eax
80104df5:	5b                   	pop    %ebx
80104df6:	5e                   	pop    %esi
80104df7:	5f                   	pop    %edi
80104df8:	5d                   	pop    %ebp
80104df9:	c3                   	ret
80104dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104e00:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104e03:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104e08:	53                   	push   %ebx
80104e09:	e8 12 c9 ff ff       	call   80101720 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104e0e:	83 c4 0c             	add    $0xc,%esp
80104e11:	ff 76 04             	push   0x4(%esi)
80104e14:	68 60 7d 10 80       	push   $0x80107d60
80104e19:	56                   	push   %esi
80104e1a:	e8 21 d2 ff ff       	call   80102040 <dirlink>
80104e1f:	83 c4 10             	add    $0x10,%esp
80104e22:	85 c0                	test   %eax,%eax
80104e24:	78 18                	js     80104e3e <create+0x14e>
80104e26:	83 ec 04             	sub    $0x4,%esp
80104e29:	ff 73 04             	push   0x4(%ebx)
80104e2c:	68 5f 7d 10 80       	push   $0x80107d5f
80104e31:	56                   	push   %esi
80104e32:	e8 09 d2 ff ff       	call   80102040 <dirlink>
80104e37:	83 c4 10             	add    $0x10,%esp
80104e3a:	85 c0                	test   %eax,%eax
80104e3c:	79 92                	jns    80104dd0 <create+0xe0>
      panic("create dots");
80104e3e:	83 ec 0c             	sub    $0xc,%esp
80104e41:	68 53 7d 10 80       	push   $0x80107d53
80104e46:	e8 35 b5 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
80104e4b:	83 ec 0c             	sub    $0xc,%esp
80104e4e:	68 62 7d 10 80       	push   $0x80107d62
80104e53:	e8 28 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104e58:	83 ec 0c             	sub    $0xc,%esp
80104e5b:	68 44 7d 10 80       	push   $0x80107d44
80104e60:	e8 1b b5 ff ff       	call   80100380 <panic>
80104e65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e70 <sys_dup>:
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	56                   	push   %esi
80104e74:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e75:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e78:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e7b:	50                   	push   %eax
80104e7c:	6a 00                	push   $0x0
80104e7e:	e8 6d fc ff ff       	call   80104af0 <argint>
80104e83:	83 c4 10             	add    $0x10,%esp
80104e86:	85 c0                	test   %eax,%eax
80104e88:	78 36                	js     80104ec0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e8a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e8e:	77 30                	ja     80104ec0 <sys_dup+0x50>
80104e90:	e8 8b eb ff ff       	call   80103a20 <myproc>
80104e95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e98:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e9c:	85 f6                	test   %esi,%esi
80104e9e:	74 20                	je     80104ec0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104ea0:	e8 7b eb ff ff       	call   80103a20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104ea5:	31 db                	xor    %ebx,%ebx
80104ea7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eae:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104eb0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104eb4:	85 d2                	test   %edx,%edx
80104eb6:	74 18                	je     80104ed0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104eb8:	83 c3 01             	add    $0x1,%ebx
80104ebb:	83 fb 10             	cmp    $0x10,%ebx
80104ebe:	75 f0                	jne    80104eb0 <sys_dup+0x40>
}
80104ec0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104ec3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104ec8:	89 d8                	mov    %ebx,%eax
80104eca:	5b                   	pop    %ebx
80104ecb:	5e                   	pop    %esi
80104ecc:	5d                   	pop    %ebp
80104ecd:	c3                   	ret
80104ece:	66 90                	xchg   %ax,%ax
  filedup(f);
80104ed0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104ed3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104ed7:	56                   	push   %esi
80104ed8:	e8 13 c0 ff ff       	call   80100ef0 <filedup>
  return fd;
80104edd:	83 c4 10             	add    $0x10,%esp
}
80104ee0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ee3:	89 d8                	mov    %ebx,%eax
80104ee5:	5b                   	pop    %ebx
80104ee6:	5e                   	pop    %esi
80104ee7:	5d                   	pop    %ebp
80104ee8:	c3                   	ret
80104ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ef0 <sys_read>:
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	56                   	push   %esi
80104ef4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ef5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ef8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104efb:	53                   	push   %ebx
80104efc:	6a 00                	push   $0x0
80104efe:	e8 ed fb ff ff       	call   80104af0 <argint>
80104f03:	83 c4 10             	add    $0x10,%esp
80104f06:	85 c0                	test   %eax,%eax
80104f08:	78 5e                	js     80104f68 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f0a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f0e:	77 58                	ja     80104f68 <sys_read+0x78>
80104f10:	e8 0b eb ff ff       	call   80103a20 <myproc>
80104f15:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f18:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f1c:	85 f6                	test   %esi,%esi
80104f1e:	74 48                	je     80104f68 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f20:	83 ec 08             	sub    $0x8,%esp
80104f23:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f26:	50                   	push   %eax
80104f27:	6a 02                	push   $0x2
80104f29:	e8 c2 fb ff ff       	call   80104af0 <argint>
80104f2e:	83 c4 10             	add    $0x10,%esp
80104f31:	85 c0                	test   %eax,%eax
80104f33:	78 33                	js     80104f68 <sys_read+0x78>
80104f35:	83 ec 04             	sub    $0x4,%esp
80104f38:	ff 75 f0             	push   -0x10(%ebp)
80104f3b:	53                   	push   %ebx
80104f3c:	6a 01                	push   $0x1
80104f3e:	e8 fd fb ff ff       	call   80104b40 <argptr>
80104f43:	83 c4 10             	add    $0x10,%esp
80104f46:	85 c0                	test   %eax,%eax
80104f48:	78 1e                	js     80104f68 <sys_read+0x78>
  return fileread(f, p, n);
80104f4a:	83 ec 04             	sub    $0x4,%esp
80104f4d:	ff 75 f0             	push   -0x10(%ebp)
80104f50:	ff 75 f4             	push   -0xc(%ebp)
80104f53:	56                   	push   %esi
80104f54:	e8 17 c1 ff ff       	call   80101070 <fileread>
80104f59:	83 c4 10             	add    $0x10,%esp
}
80104f5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f5f:	5b                   	pop    %ebx
80104f60:	5e                   	pop    %esi
80104f61:	5d                   	pop    %ebp
80104f62:	c3                   	ret
80104f63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f67:	90                   	nop
    return -1;
80104f68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f6d:	eb ed                	jmp    80104f5c <sys_read+0x6c>
80104f6f:	90                   	nop

80104f70 <sys_write>:
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	56                   	push   %esi
80104f74:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f75:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f78:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f7b:	53                   	push   %ebx
80104f7c:	6a 00                	push   $0x0
80104f7e:	e8 6d fb ff ff       	call   80104af0 <argint>
80104f83:	83 c4 10             	add    $0x10,%esp
80104f86:	85 c0                	test   %eax,%eax
80104f88:	78 5e                	js     80104fe8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f8a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f8e:	77 58                	ja     80104fe8 <sys_write+0x78>
80104f90:	e8 8b ea ff ff       	call   80103a20 <myproc>
80104f95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f98:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f9c:	85 f6                	test   %esi,%esi
80104f9e:	74 48                	je     80104fe8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fa0:	83 ec 08             	sub    $0x8,%esp
80104fa3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fa6:	50                   	push   %eax
80104fa7:	6a 02                	push   $0x2
80104fa9:	e8 42 fb ff ff       	call   80104af0 <argint>
80104fae:	83 c4 10             	add    $0x10,%esp
80104fb1:	85 c0                	test   %eax,%eax
80104fb3:	78 33                	js     80104fe8 <sys_write+0x78>
80104fb5:	83 ec 04             	sub    $0x4,%esp
80104fb8:	ff 75 f0             	push   -0x10(%ebp)
80104fbb:	53                   	push   %ebx
80104fbc:	6a 01                	push   $0x1
80104fbe:	e8 7d fb ff ff       	call   80104b40 <argptr>
80104fc3:	83 c4 10             	add    $0x10,%esp
80104fc6:	85 c0                	test   %eax,%eax
80104fc8:	78 1e                	js     80104fe8 <sys_write+0x78>
  return filewrite(f, p, n);
80104fca:	83 ec 04             	sub    $0x4,%esp
80104fcd:	ff 75 f0             	push   -0x10(%ebp)
80104fd0:	ff 75 f4             	push   -0xc(%ebp)
80104fd3:	56                   	push   %esi
80104fd4:	e8 27 c1 ff ff       	call   80101100 <filewrite>
80104fd9:	83 c4 10             	add    $0x10,%esp
}
80104fdc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fdf:	5b                   	pop    %ebx
80104fe0:	5e                   	pop    %esi
80104fe1:	5d                   	pop    %ebp
80104fe2:	c3                   	ret
80104fe3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fe7:	90                   	nop
    return -1;
80104fe8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fed:	eb ed                	jmp    80104fdc <sys_write+0x6c>
80104fef:	90                   	nop

80104ff0 <sys_close>:
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	56                   	push   %esi
80104ff4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ff5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104ff8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ffb:	50                   	push   %eax
80104ffc:	6a 00                	push   $0x0
80104ffe:	e8 ed fa ff ff       	call   80104af0 <argint>
80105003:	83 c4 10             	add    $0x10,%esp
80105006:	85 c0                	test   %eax,%eax
80105008:	78 3e                	js     80105048 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010500a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010500e:	77 38                	ja     80105048 <sys_close+0x58>
80105010:	e8 0b ea ff ff       	call   80103a20 <myproc>
80105015:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105018:	8d 5a 08             	lea    0x8(%edx),%ebx
8010501b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010501f:	85 f6                	test   %esi,%esi
80105021:	74 25                	je     80105048 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105023:	e8 f8 e9 ff ff       	call   80103a20 <myproc>
  fileclose(f);
80105028:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010502b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105032:	00 
  fileclose(f);
80105033:	56                   	push   %esi
80105034:	e8 07 bf ff ff       	call   80100f40 <fileclose>
  return 0;
80105039:	83 c4 10             	add    $0x10,%esp
8010503c:	31 c0                	xor    %eax,%eax
}
8010503e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105041:	5b                   	pop    %ebx
80105042:	5e                   	pop    %esi
80105043:	5d                   	pop    %ebp
80105044:	c3                   	ret
80105045:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105048:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010504d:	eb ef                	jmp    8010503e <sys_close+0x4e>
8010504f:	90                   	nop

80105050 <sys_fstat>:
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	56                   	push   %esi
80105054:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105055:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105058:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010505b:	53                   	push   %ebx
8010505c:	6a 00                	push   $0x0
8010505e:	e8 8d fa ff ff       	call   80104af0 <argint>
80105063:	83 c4 10             	add    $0x10,%esp
80105066:	85 c0                	test   %eax,%eax
80105068:	78 46                	js     801050b0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010506a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010506e:	77 40                	ja     801050b0 <sys_fstat+0x60>
80105070:	e8 ab e9 ff ff       	call   80103a20 <myproc>
80105075:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105078:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010507c:	85 f6                	test   %esi,%esi
8010507e:	74 30                	je     801050b0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105080:	83 ec 04             	sub    $0x4,%esp
80105083:	6a 14                	push   $0x14
80105085:	53                   	push   %ebx
80105086:	6a 01                	push   $0x1
80105088:	e8 b3 fa ff ff       	call   80104b40 <argptr>
8010508d:	83 c4 10             	add    $0x10,%esp
80105090:	85 c0                	test   %eax,%eax
80105092:	78 1c                	js     801050b0 <sys_fstat+0x60>
  return filestat(f, st);
80105094:	83 ec 08             	sub    $0x8,%esp
80105097:	ff 75 f4             	push   -0xc(%ebp)
8010509a:	56                   	push   %esi
8010509b:	e8 80 bf ff ff       	call   80101020 <filestat>
801050a0:	83 c4 10             	add    $0x10,%esp
}
801050a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050a6:	5b                   	pop    %ebx
801050a7:	5e                   	pop    %esi
801050a8:	5d                   	pop    %ebp
801050a9:	c3                   	ret
801050aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801050b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050b5:	eb ec                	jmp    801050a3 <sys_fstat+0x53>
801050b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050be:	66 90                	xchg   %ax,%ax

801050c0 <sys_link>:
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	57                   	push   %edi
801050c4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050c5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801050c8:	53                   	push   %ebx
801050c9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050cc:	50                   	push   %eax
801050cd:	6a 00                	push   $0x0
801050cf:	e8 dc fa ff ff       	call   80104bb0 <argstr>
801050d4:	83 c4 10             	add    $0x10,%esp
801050d7:	85 c0                	test   %eax,%eax
801050d9:	0f 88 fb 00 00 00    	js     801051da <sys_link+0x11a>
801050df:	83 ec 08             	sub    $0x8,%esp
801050e2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801050e5:	50                   	push   %eax
801050e6:	6a 01                	push   $0x1
801050e8:	e8 c3 fa ff ff       	call   80104bb0 <argstr>
801050ed:	83 c4 10             	add    $0x10,%esp
801050f0:	85 c0                	test   %eax,%eax
801050f2:	0f 88 e2 00 00 00    	js     801051da <sys_link+0x11a>
  begin_op();
801050f8:	e8 d3 dc ff ff       	call   80102dd0 <begin_op>
  if((ip = namei(old)) == 0){
801050fd:	83 ec 0c             	sub    $0xc,%esp
80105100:	ff 75 d4             	push   -0x2c(%ebp)
80105103:	e8 f8 cf ff ff       	call   80102100 <namei>
80105108:	83 c4 10             	add    $0x10,%esp
8010510b:	89 c3                	mov    %eax,%ebx
8010510d:	85 c0                	test   %eax,%eax
8010510f:	0f 84 df 00 00 00    	je     801051f4 <sys_link+0x134>
  ilock(ip);
80105115:	83 ec 0c             	sub    $0xc,%esp
80105118:	50                   	push   %eax
80105119:	e8 b2 c6 ff ff       	call   801017d0 <ilock>
  if(ip->type == T_DIR){
8010511e:	83 c4 10             	add    $0x10,%esp
80105121:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105126:	0f 84 b5 00 00 00    	je     801051e1 <sys_link+0x121>
  iupdate(ip);
8010512c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010512f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105134:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105137:	53                   	push   %ebx
80105138:	e8 e3 c5 ff ff       	call   80101720 <iupdate>
  iunlock(ip);
8010513d:	89 1c 24             	mov    %ebx,(%esp)
80105140:	e8 6b c7 ff ff       	call   801018b0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105145:	58                   	pop    %eax
80105146:	5a                   	pop    %edx
80105147:	57                   	push   %edi
80105148:	ff 75 d0             	push   -0x30(%ebp)
8010514b:	e8 d0 cf ff ff       	call   80102120 <nameiparent>
80105150:	83 c4 10             	add    $0x10,%esp
80105153:	89 c6                	mov    %eax,%esi
80105155:	85 c0                	test   %eax,%eax
80105157:	74 5b                	je     801051b4 <sys_link+0xf4>
  ilock(dp);
80105159:	83 ec 0c             	sub    $0xc,%esp
8010515c:	50                   	push   %eax
8010515d:	e8 6e c6 ff ff       	call   801017d0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105162:	8b 03                	mov    (%ebx),%eax
80105164:	83 c4 10             	add    $0x10,%esp
80105167:	39 06                	cmp    %eax,(%esi)
80105169:	75 3d                	jne    801051a8 <sys_link+0xe8>
8010516b:	83 ec 04             	sub    $0x4,%esp
8010516e:	ff 73 04             	push   0x4(%ebx)
80105171:	57                   	push   %edi
80105172:	56                   	push   %esi
80105173:	e8 c8 ce ff ff       	call   80102040 <dirlink>
80105178:	83 c4 10             	add    $0x10,%esp
8010517b:	85 c0                	test   %eax,%eax
8010517d:	78 29                	js     801051a8 <sys_link+0xe8>
  iunlockput(dp);
8010517f:	83 ec 0c             	sub    $0xc,%esp
80105182:	56                   	push   %esi
80105183:	e8 d8 c8 ff ff       	call   80101a60 <iunlockput>
  iput(ip);
80105188:	89 1c 24             	mov    %ebx,(%esp)
8010518b:	e8 70 c7 ff ff       	call   80101900 <iput>
  end_op();
80105190:	e8 ab dc ff ff       	call   80102e40 <end_op>
  return 0;
80105195:	83 c4 10             	add    $0x10,%esp
80105198:	31 c0                	xor    %eax,%eax
}
8010519a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010519d:	5b                   	pop    %ebx
8010519e:	5e                   	pop    %esi
8010519f:	5f                   	pop    %edi
801051a0:	5d                   	pop    %ebp
801051a1:	c3                   	ret
801051a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801051a8:	83 ec 0c             	sub    $0xc,%esp
801051ab:	56                   	push   %esi
801051ac:	e8 af c8 ff ff       	call   80101a60 <iunlockput>
    goto bad;
801051b1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801051b4:	83 ec 0c             	sub    $0xc,%esp
801051b7:	53                   	push   %ebx
801051b8:	e8 13 c6 ff ff       	call   801017d0 <ilock>
  ip->nlink--;
801051bd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051c2:	89 1c 24             	mov    %ebx,(%esp)
801051c5:	e8 56 c5 ff ff       	call   80101720 <iupdate>
  iunlockput(ip);
801051ca:	89 1c 24             	mov    %ebx,(%esp)
801051cd:	e8 8e c8 ff ff       	call   80101a60 <iunlockput>
  end_op();
801051d2:	e8 69 dc ff ff       	call   80102e40 <end_op>
  return -1;
801051d7:	83 c4 10             	add    $0x10,%esp
    return -1;
801051da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051df:	eb b9                	jmp    8010519a <sys_link+0xda>
    iunlockput(ip);
801051e1:	83 ec 0c             	sub    $0xc,%esp
801051e4:	53                   	push   %ebx
801051e5:	e8 76 c8 ff ff       	call   80101a60 <iunlockput>
    end_op();
801051ea:	e8 51 dc ff ff       	call   80102e40 <end_op>
    return -1;
801051ef:	83 c4 10             	add    $0x10,%esp
801051f2:	eb e6                	jmp    801051da <sys_link+0x11a>
    end_op();
801051f4:	e8 47 dc ff ff       	call   80102e40 <end_op>
    return -1;
801051f9:	eb df                	jmp    801051da <sys_link+0x11a>
801051fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051ff:	90                   	nop

80105200 <sys_unlink>:
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	57                   	push   %edi
80105204:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105205:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105208:	53                   	push   %ebx
80105209:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010520c:	50                   	push   %eax
8010520d:	6a 00                	push   $0x0
8010520f:	e8 9c f9 ff ff       	call   80104bb0 <argstr>
80105214:	83 c4 10             	add    $0x10,%esp
80105217:	85 c0                	test   %eax,%eax
80105219:	0f 88 54 01 00 00    	js     80105373 <sys_unlink+0x173>
  begin_op();
8010521f:	e8 ac db ff ff       	call   80102dd0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105224:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105227:	83 ec 08             	sub    $0x8,%esp
8010522a:	53                   	push   %ebx
8010522b:	ff 75 c0             	push   -0x40(%ebp)
8010522e:	e8 ed ce ff ff       	call   80102120 <nameiparent>
80105233:	83 c4 10             	add    $0x10,%esp
80105236:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105239:	85 c0                	test   %eax,%eax
8010523b:	0f 84 58 01 00 00    	je     80105399 <sys_unlink+0x199>
  ilock(dp);
80105241:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105244:	83 ec 0c             	sub    $0xc,%esp
80105247:	57                   	push   %edi
80105248:	e8 83 c5 ff ff       	call   801017d0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010524d:	58                   	pop    %eax
8010524e:	5a                   	pop    %edx
8010524f:	68 60 7d 10 80       	push   $0x80107d60
80105254:	53                   	push   %ebx
80105255:	e8 b6 ca ff ff       	call   80101d10 <namecmp>
8010525a:	83 c4 10             	add    $0x10,%esp
8010525d:	85 c0                	test   %eax,%eax
8010525f:	0f 84 fb 00 00 00    	je     80105360 <sys_unlink+0x160>
80105265:	83 ec 08             	sub    $0x8,%esp
80105268:	68 5f 7d 10 80       	push   $0x80107d5f
8010526d:	53                   	push   %ebx
8010526e:	e8 9d ca ff ff       	call   80101d10 <namecmp>
80105273:	83 c4 10             	add    $0x10,%esp
80105276:	85 c0                	test   %eax,%eax
80105278:	0f 84 e2 00 00 00    	je     80105360 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010527e:	83 ec 04             	sub    $0x4,%esp
80105281:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105284:	50                   	push   %eax
80105285:	53                   	push   %ebx
80105286:	57                   	push   %edi
80105287:	e8 a4 ca ff ff       	call   80101d30 <dirlookup>
8010528c:	83 c4 10             	add    $0x10,%esp
8010528f:	89 c3                	mov    %eax,%ebx
80105291:	85 c0                	test   %eax,%eax
80105293:	0f 84 c7 00 00 00    	je     80105360 <sys_unlink+0x160>
  ilock(ip);
80105299:	83 ec 0c             	sub    $0xc,%esp
8010529c:	50                   	push   %eax
8010529d:	e8 2e c5 ff ff       	call   801017d0 <ilock>
  if(ip->nlink < 1)
801052a2:	83 c4 10             	add    $0x10,%esp
801052a5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801052aa:	0f 8e 0a 01 00 00    	jle    801053ba <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
801052b0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052b5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801052b8:	74 66                	je     80105320 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801052ba:	83 ec 04             	sub    $0x4,%esp
801052bd:	6a 10                	push   $0x10
801052bf:	6a 00                	push   $0x0
801052c1:	57                   	push   %edi
801052c2:	e8 79 f5 ff ff       	call   80104840 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052c7:	6a 10                	push   $0x10
801052c9:	ff 75 c4             	push   -0x3c(%ebp)
801052cc:	57                   	push   %edi
801052cd:	ff 75 b4             	push   -0x4c(%ebp)
801052d0:	e8 0b c9 ff ff       	call   80101be0 <writei>
801052d5:	83 c4 20             	add    $0x20,%esp
801052d8:	83 f8 10             	cmp    $0x10,%eax
801052db:	0f 85 cc 00 00 00    	jne    801053ad <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
801052e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052e6:	0f 84 94 00 00 00    	je     80105380 <sys_unlink+0x180>
  iunlockput(dp);
801052ec:	83 ec 0c             	sub    $0xc,%esp
801052ef:	ff 75 b4             	push   -0x4c(%ebp)
801052f2:	e8 69 c7 ff ff       	call   80101a60 <iunlockput>
  ip->nlink--;
801052f7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052fc:	89 1c 24             	mov    %ebx,(%esp)
801052ff:	e8 1c c4 ff ff       	call   80101720 <iupdate>
  iunlockput(ip);
80105304:	89 1c 24             	mov    %ebx,(%esp)
80105307:	e8 54 c7 ff ff       	call   80101a60 <iunlockput>
  end_op();
8010530c:	e8 2f db ff ff       	call   80102e40 <end_op>
  return 0;
80105311:	83 c4 10             	add    $0x10,%esp
80105314:	31 c0                	xor    %eax,%eax
}
80105316:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105319:	5b                   	pop    %ebx
8010531a:	5e                   	pop    %esi
8010531b:	5f                   	pop    %edi
8010531c:	5d                   	pop    %ebp
8010531d:	c3                   	ret
8010531e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105320:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105324:	76 94                	jbe    801052ba <sys_unlink+0xba>
80105326:	be 20 00 00 00       	mov    $0x20,%esi
8010532b:	eb 0b                	jmp    80105338 <sys_unlink+0x138>
8010532d:	8d 76 00             	lea    0x0(%esi),%esi
80105330:	83 c6 10             	add    $0x10,%esi
80105333:	3b 73 58             	cmp    0x58(%ebx),%esi
80105336:	73 82                	jae    801052ba <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105338:	6a 10                	push   $0x10
8010533a:	56                   	push   %esi
8010533b:	57                   	push   %edi
8010533c:	53                   	push   %ebx
8010533d:	e8 9e c7 ff ff       	call   80101ae0 <readi>
80105342:	83 c4 10             	add    $0x10,%esp
80105345:	83 f8 10             	cmp    $0x10,%eax
80105348:	75 56                	jne    801053a0 <sys_unlink+0x1a0>
    if(de.inum != 0)
8010534a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010534f:	74 df                	je     80105330 <sys_unlink+0x130>
    iunlockput(ip);
80105351:	83 ec 0c             	sub    $0xc,%esp
80105354:	53                   	push   %ebx
80105355:	e8 06 c7 ff ff       	call   80101a60 <iunlockput>
    goto bad;
8010535a:	83 c4 10             	add    $0x10,%esp
8010535d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105360:	83 ec 0c             	sub    $0xc,%esp
80105363:	ff 75 b4             	push   -0x4c(%ebp)
80105366:	e8 f5 c6 ff ff       	call   80101a60 <iunlockput>
  end_op();
8010536b:	e8 d0 da ff ff       	call   80102e40 <end_op>
  return -1;
80105370:	83 c4 10             	add    $0x10,%esp
    return -1;
80105373:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105378:	eb 9c                	jmp    80105316 <sys_unlink+0x116>
8010537a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105380:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105383:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105386:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010538b:	50                   	push   %eax
8010538c:	e8 8f c3 ff ff       	call   80101720 <iupdate>
80105391:	83 c4 10             	add    $0x10,%esp
80105394:	e9 53 ff ff ff       	jmp    801052ec <sys_unlink+0xec>
    end_op();
80105399:	e8 a2 da ff ff       	call   80102e40 <end_op>
    return -1;
8010539e:	eb d3                	jmp    80105373 <sys_unlink+0x173>
      panic("isdirempty: readi");
801053a0:	83 ec 0c             	sub    $0xc,%esp
801053a3:	68 84 7d 10 80       	push   $0x80107d84
801053a8:	e8 d3 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801053ad:	83 ec 0c             	sub    $0xc,%esp
801053b0:	68 96 7d 10 80       	push   $0x80107d96
801053b5:	e8 c6 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801053ba:	83 ec 0c             	sub    $0xc,%esp
801053bd:	68 72 7d 10 80       	push   $0x80107d72
801053c2:	e8 b9 af ff ff       	call   80100380 <panic>
801053c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ce:	66 90                	xchg   %ax,%ax

801053d0 <sys_open>:

int
sys_open(void)
{
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	57                   	push   %edi
801053d4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801053d8:	53                   	push   %ebx
801053d9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053dc:	50                   	push   %eax
801053dd:	6a 00                	push   $0x0
801053df:	e8 cc f7 ff ff       	call   80104bb0 <argstr>
801053e4:	83 c4 10             	add    $0x10,%esp
801053e7:	85 c0                	test   %eax,%eax
801053e9:	0f 88 8e 00 00 00    	js     8010547d <sys_open+0xad>
801053ef:	83 ec 08             	sub    $0x8,%esp
801053f2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801053f5:	50                   	push   %eax
801053f6:	6a 01                	push   $0x1
801053f8:	e8 f3 f6 ff ff       	call   80104af0 <argint>
801053fd:	83 c4 10             	add    $0x10,%esp
80105400:	85 c0                	test   %eax,%eax
80105402:	78 79                	js     8010547d <sys_open+0xad>
    return -1;

  begin_op();
80105404:	e8 c7 d9 ff ff       	call   80102dd0 <begin_op>

  if(omode & O_CREATE){
80105409:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010540d:	75 79                	jne    80105488 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010540f:	83 ec 0c             	sub    $0xc,%esp
80105412:	ff 75 e0             	push   -0x20(%ebp)
80105415:	e8 e6 cc ff ff       	call   80102100 <namei>
8010541a:	83 c4 10             	add    $0x10,%esp
8010541d:	89 c6                	mov    %eax,%esi
8010541f:	85 c0                	test   %eax,%eax
80105421:	0f 84 7e 00 00 00    	je     801054a5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105427:	83 ec 0c             	sub    $0xc,%esp
8010542a:	50                   	push   %eax
8010542b:	e8 a0 c3 ff ff       	call   801017d0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105430:	83 c4 10             	add    $0x10,%esp
80105433:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105438:	0f 84 ba 00 00 00    	je     801054f8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010543e:	e8 3d ba ff ff       	call   80100e80 <filealloc>
80105443:	89 c7                	mov    %eax,%edi
80105445:	85 c0                	test   %eax,%eax
80105447:	74 23                	je     8010546c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105449:	e8 d2 e5 ff ff       	call   80103a20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010544e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105450:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105454:	85 d2                	test   %edx,%edx
80105456:	74 58                	je     801054b0 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105458:	83 c3 01             	add    $0x1,%ebx
8010545b:	83 fb 10             	cmp    $0x10,%ebx
8010545e:	75 f0                	jne    80105450 <sys_open+0x80>
    if(f)
      fileclose(f);
80105460:	83 ec 0c             	sub    $0xc,%esp
80105463:	57                   	push   %edi
80105464:	e8 d7 ba ff ff       	call   80100f40 <fileclose>
80105469:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010546c:	83 ec 0c             	sub    $0xc,%esp
8010546f:	56                   	push   %esi
80105470:	e8 eb c5 ff ff       	call   80101a60 <iunlockput>
    end_op();
80105475:	e8 c6 d9 ff ff       	call   80102e40 <end_op>
    return -1;
8010547a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010547d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105482:	eb 65                	jmp    801054e9 <sys_open+0x119>
80105484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105488:	83 ec 0c             	sub    $0xc,%esp
8010548b:	31 c9                	xor    %ecx,%ecx
8010548d:	ba 02 00 00 00       	mov    $0x2,%edx
80105492:	6a 00                	push   $0x0
80105494:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105497:	e8 54 f8 ff ff       	call   80104cf0 <create>
    if(ip == 0){
8010549c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010549f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801054a1:	85 c0                	test   %eax,%eax
801054a3:	75 99                	jne    8010543e <sys_open+0x6e>
      end_op();
801054a5:	e8 96 d9 ff ff       	call   80102e40 <end_op>
      return -1;
801054aa:	eb d1                	jmp    8010547d <sys_open+0xad>
801054ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801054b0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801054b3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801054b7:	56                   	push   %esi
801054b8:	e8 f3 c3 ff ff       	call   801018b0 <iunlock>
  end_op();
801054bd:	e8 7e d9 ff ff       	call   80102e40 <end_op>

  f->type = FD_INODE;
801054c2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801054c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054cb:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801054ce:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801054d1:	89 d0                	mov    %edx,%eax
  f->off = 0;
801054d3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801054da:	f7 d0                	not    %eax
801054dc:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054df:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801054e2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054e5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801054e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054ec:	89 d8                	mov    %ebx,%eax
801054ee:	5b                   	pop    %ebx
801054ef:	5e                   	pop    %esi
801054f0:	5f                   	pop    %edi
801054f1:	5d                   	pop    %ebp
801054f2:	c3                   	ret
801054f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054f7:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801054f8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801054fb:	85 c9                	test   %ecx,%ecx
801054fd:	0f 84 3b ff ff ff    	je     8010543e <sys_open+0x6e>
80105503:	e9 64 ff ff ff       	jmp    8010546c <sys_open+0x9c>
80105508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010550f:	90                   	nop

80105510 <sys_mkdir>:

int
sys_mkdir(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105516:	e8 b5 d8 ff ff       	call   80102dd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010551b:	83 ec 08             	sub    $0x8,%esp
8010551e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105521:	50                   	push   %eax
80105522:	6a 00                	push   $0x0
80105524:	e8 87 f6 ff ff       	call   80104bb0 <argstr>
80105529:	83 c4 10             	add    $0x10,%esp
8010552c:	85 c0                	test   %eax,%eax
8010552e:	78 30                	js     80105560 <sys_mkdir+0x50>
80105530:	83 ec 0c             	sub    $0xc,%esp
80105533:	31 c9                	xor    %ecx,%ecx
80105535:	ba 01 00 00 00       	mov    $0x1,%edx
8010553a:	6a 00                	push   $0x0
8010553c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010553f:	e8 ac f7 ff ff       	call   80104cf0 <create>
80105544:	83 c4 10             	add    $0x10,%esp
80105547:	85 c0                	test   %eax,%eax
80105549:	74 15                	je     80105560 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010554b:	83 ec 0c             	sub    $0xc,%esp
8010554e:	50                   	push   %eax
8010554f:	e8 0c c5 ff ff       	call   80101a60 <iunlockput>
  end_op();
80105554:	e8 e7 d8 ff ff       	call   80102e40 <end_op>
  return 0;
80105559:	83 c4 10             	add    $0x10,%esp
8010555c:	31 c0                	xor    %eax,%eax
}
8010555e:	c9                   	leave
8010555f:	c3                   	ret
    end_op();
80105560:	e8 db d8 ff ff       	call   80102e40 <end_op>
    return -1;
80105565:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010556a:	c9                   	leave
8010556b:	c3                   	ret
8010556c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105570 <sys_mknod>:

int
sys_mknod(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105576:	e8 55 d8 ff ff       	call   80102dd0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010557b:	83 ec 08             	sub    $0x8,%esp
8010557e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105581:	50                   	push   %eax
80105582:	6a 00                	push   $0x0
80105584:	e8 27 f6 ff ff       	call   80104bb0 <argstr>
80105589:	83 c4 10             	add    $0x10,%esp
8010558c:	85 c0                	test   %eax,%eax
8010558e:	78 60                	js     801055f0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105590:	83 ec 08             	sub    $0x8,%esp
80105593:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105596:	50                   	push   %eax
80105597:	6a 01                	push   $0x1
80105599:	e8 52 f5 ff ff       	call   80104af0 <argint>
  if((argstr(0, &path)) < 0 ||
8010559e:	83 c4 10             	add    $0x10,%esp
801055a1:	85 c0                	test   %eax,%eax
801055a3:	78 4b                	js     801055f0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801055a5:	83 ec 08             	sub    $0x8,%esp
801055a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055ab:	50                   	push   %eax
801055ac:	6a 02                	push   $0x2
801055ae:	e8 3d f5 ff ff       	call   80104af0 <argint>
     argint(1, &major) < 0 ||
801055b3:	83 c4 10             	add    $0x10,%esp
801055b6:	85 c0                	test   %eax,%eax
801055b8:	78 36                	js     801055f0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801055ba:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801055be:	83 ec 0c             	sub    $0xc,%esp
801055c1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801055c5:	ba 03 00 00 00       	mov    $0x3,%edx
801055ca:	50                   	push   %eax
801055cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801055ce:	e8 1d f7 ff ff       	call   80104cf0 <create>
     argint(2, &minor) < 0 ||
801055d3:	83 c4 10             	add    $0x10,%esp
801055d6:	85 c0                	test   %eax,%eax
801055d8:	74 16                	je     801055f0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055da:	83 ec 0c             	sub    $0xc,%esp
801055dd:	50                   	push   %eax
801055de:	e8 7d c4 ff ff       	call   80101a60 <iunlockput>
  end_op();
801055e3:	e8 58 d8 ff ff       	call   80102e40 <end_op>
  return 0;
801055e8:	83 c4 10             	add    $0x10,%esp
801055eb:	31 c0                	xor    %eax,%eax
}
801055ed:	c9                   	leave
801055ee:	c3                   	ret
801055ef:	90                   	nop
    end_op();
801055f0:	e8 4b d8 ff ff       	call   80102e40 <end_op>
    return -1;
801055f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055fa:	c9                   	leave
801055fb:	c3                   	ret
801055fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105600 <sys_chdir>:

int
sys_chdir(void)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	56                   	push   %esi
80105604:	53                   	push   %ebx
80105605:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105608:	e8 13 e4 ff ff       	call   80103a20 <myproc>
8010560d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010560f:	e8 bc d7 ff ff       	call   80102dd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105614:	83 ec 08             	sub    $0x8,%esp
80105617:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010561a:	50                   	push   %eax
8010561b:	6a 00                	push   $0x0
8010561d:	e8 8e f5 ff ff       	call   80104bb0 <argstr>
80105622:	83 c4 10             	add    $0x10,%esp
80105625:	85 c0                	test   %eax,%eax
80105627:	78 77                	js     801056a0 <sys_chdir+0xa0>
80105629:	83 ec 0c             	sub    $0xc,%esp
8010562c:	ff 75 f4             	push   -0xc(%ebp)
8010562f:	e8 cc ca ff ff       	call   80102100 <namei>
80105634:	83 c4 10             	add    $0x10,%esp
80105637:	89 c3                	mov    %eax,%ebx
80105639:	85 c0                	test   %eax,%eax
8010563b:	74 63                	je     801056a0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010563d:	83 ec 0c             	sub    $0xc,%esp
80105640:	50                   	push   %eax
80105641:	e8 8a c1 ff ff       	call   801017d0 <ilock>
  if(ip->type != T_DIR){
80105646:	83 c4 10             	add    $0x10,%esp
80105649:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010564e:	75 30                	jne    80105680 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105650:	83 ec 0c             	sub    $0xc,%esp
80105653:	53                   	push   %ebx
80105654:	e8 57 c2 ff ff       	call   801018b0 <iunlock>
  iput(curproc->cwd);
80105659:	58                   	pop    %eax
8010565a:	ff 76 68             	push   0x68(%esi)
8010565d:	e8 9e c2 ff ff       	call   80101900 <iput>
  end_op();
80105662:	e8 d9 d7 ff ff       	call   80102e40 <end_op>
  curproc->cwd = ip;
80105667:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010566a:	83 c4 10             	add    $0x10,%esp
8010566d:	31 c0                	xor    %eax,%eax
}
8010566f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105672:	5b                   	pop    %ebx
80105673:	5e                   	pop    %esi
80105674:	5d                   	pop    %ebp
80105675:	c3                   	ret
80105676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010567d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105680:	83 ec 0c             	sub    $0xc,%esp
80105683:	53                   	push   %ebx
80105684:	e8 d7 c3 ff ff       	call   80101a60 <iunlockput>
    end_op();
80105689:	e8 b2 d7 ff ff       	call   80102e40 <end_op>
    return -1;
8010568e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105691:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105696:	eb d7                	jmp    8010566f <sys_chdir+0x6f>
80105698:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569f:	90                   	nop
    end_op();
801056a0:	e8 9b d7 ff ff       	call   80102e40 <end_op>
    return -1;
801056a5:	eb ea                	jmp    80105691 <sys_chdir+0x91>
801056a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ae:	66 90                	xchg   %ax,%ax

801056b0 <sys_exec>:

int
sys_exec(void)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	57                   	push   %edi
801056b4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056b5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801056bb:	53                   	push   %ebx
801056bc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056c2:	50                   	push   %eax
801056c3:	6a 00                	push   $0x0
801056c5:	e8 e6 f4 ff ff       	call   80104bb0 <argstr>
801056ca:	83 c4 10             	add    $0x10,%esp
801056cd:	85 c0                	test   %eax,%eax
801056cf:	0f 88 87 00 00 00    	js     8010575c <sys_exec+0xac>
801056d5:	83 ec 08             	sub    $0x8,%esp
801056d8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801056de:	50                   	push   %eax
801056df:	6a 01                	push   $0x1
801056e1:	e8 0a f4 ff ff       	call   80104af0 <argint>
801056e6:	83 c4 10             	add    $0x10,%esp
801056e9:	85 c0                	test   %eax,%eax
801056eb:	78 6f                	js     8010575c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801056ed:	83 ec 04             	sub    $0x4,%esp
801056f0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801056f6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801056f8:	68 80 00 00 00       	push   $0x80
801056fd:	6a 00                	push   $0x0
801056ff:	56                   	push   %esi
80105700:	e8 3b f1 ff ff       	call   80104840 <memset>
80105705:	83 c4 10             	add    $0x10,%esp
80105708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105710:	83 ec 08             	sub    $0x8,%esp
80105713:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105719:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105720:	50                   	push   %eax
80105721:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105727:	01 f8                	add    %edi,%eax
80105729:	50                   	push   %eax
8010572a:	e8 31 f3 ff ff       	call   80104a60 <fetchint>
8010572f:	83 c4 10             	add    $0x10,%esp
80105732:	85 c0                	test   %eax,%eax
80105734:	78 26                	js     8010575c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105736:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010573c:	85 c0                	test   %eax,%eax
8010573e:	74 30                	je     80105770 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105740:	83 ec 08             	sub    $0x8,%esp
80105743:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105746:	52                   	push   %edx
80105747:	50                   	push   %eax
80105748:	e8 53 f3 ff ff       	call   80104aa0 <fetchstr>
8010574d:	83 c4 10             	add    $0x10,%esp
80105750:	85 c0                	test   %eax,%eax
80105752:	78 08                	js     8010575c <sys_exec+0xac>
  for(i=0;; i++){
80105754:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105757:	83 fb 20             	cmp    $0x20,%ebx
8010575a:	75 b4                	jne    80105710 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010575c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010575f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105764:	5b                   	pop    %ebx
80105765:	5e                   	pop    %esi
80105766:	5f                   	pop    %edi
80105767:	5d                   	pop    %ebp
80105768:	c3                   	ret
80105769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105770:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105777:	00 00 00 00 
  return exec(path, argv);
8010577b:	83 ec 08             	sub    $0x8,%esp
8010577e:	56                   	push   %esi
8010577f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105785:	e8 56 b3 ff ff       	call   80100ae0 <exec>
8010578a:	83 c4 10             	add    $0x10,%esp
}
8010578d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105790:	5b                   	pop    %ebx
80105791:	5e                   	pop    %esi
80105792:	5f                   	pop    %edi
80105793:	5d                   	pop    %ebp
80105794:	c3                   	ret
80105795:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010579c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057a0 <sys_pipe>:

int
sys_pipe(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	57                   	push   %edi
801057a4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057a5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801057a8:	53                   	push   %ebx
801057a9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057ac:	6a 08                	push   $0x8
801057ae:	50                   	push   %eax
801057af:	6a 00                	push   $0x0
801057b1:	e8 8a f3 ff ff       	call   80104b40 <argptr>
801057b6:	83 c4 10             	add    $0x10,%esp
801057b9:	85 c0                	test   %eax,%eax
801057bb:	0f 88 8b 00 00 00    	js     8010584c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801057c1:	83 ec 08             	sub    $0x8,%esp
801057c4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057c7:	50                   	push   %eax
801057c8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801057cb:	50                   	push   %eax
801057cc:	e8 cf dc ff ff       	call   801034a0 <pipealloc>
801057d1:	83 c4 10             	add    $0x10,%esp
801057d4:	85 c0                	test   %eax,%eax
801057d6:	78 74                	js     8010584c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057d8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801057db:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801057dd:	e8 3e e2 ff ff       	call   80103a20 <myproc>
    if(curproc->ofile[fd] == 0){
801057e2:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801057e6:	85 f6                	test   %esi,%esi
801057e8:	74 16                	je     80105800 <sys_pipe+0x60>
801057ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801057f0:	83 c3 01             	add    $0x1,%ebx
801057f3:	83 fb 10             	cmp    $0x10,%ebx
801057f6:	74 3d                	je     80105835 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
801057f8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801057fc:	85 f6                	test   %esi,%esi
801057fe:	75 f0                	jne    801057f0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105800:	8d 73 08             	lea    0x8(%ebx),%esi
80105803:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105807:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010580a:	e8 11 e2 ff ff       	call   80103a20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010580f:	31 d2                	xor    %edx,%edx
80105811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105818:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010581c:	85 c9                	test   %ecx,%ecx
8010581e:	74 38                	je     80105858 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105820:	83 c2 01             	add    $0x1,%edx
80105823:	83 fa 10             	cmp    $0x10,%edx
80105826:	75 f0                	jne    80105818 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105828:	e8 f3 e1 ff ff       	call   80103a20 <myproc>
8010582d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105834:	00 
    fileclose(rf);
80105835:	83 ec 0c             	sub    $0xc,%esp
80105838:	ff 75 e0             	push   -0x20(%ebp)
8010583b:	e8 00 b7 ff ff       	call   80100f40 <fileclose>
    fileclose(wf);
80105840:	58                   	pop    %eax
80105841:	ff 75 e4             	push   -0x1c(%ebp)
80105844:	e8 f7 b6 ff ff       	call   80100f40 <fileclose>
    return -1;
80105849:	83 c4 10             	add    $0x10,%esp
    return -1;
8010584c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105851:	eb 16                	jmp    80105869 <sys_pipe+0xc9>
80105853:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105857:	90                   	nop
      curproc->ofile[fd] = f;
80105858:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
8010585c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010585f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105861:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105864:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105867:	31 c0                	xor    %eax,%eax
}
80105869:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010586c:	5b                   	pop    %ebx
8010586d:	5e                   	pop    %esi
8010586e:	5f                   	pop    %edi
8010586f:	5d                   	pop    %ebp
80105870:	c3                   	ret
80105871:	66 90                	xchg   %ax,%ax
80105873:	66 90                	xchg   %ax,%ax
80105875:	66 90                	xchg   %ax,%ax
80105877:	66 90                	xchg   %ax,%ax
80105879:	66 90                	xchg   %ax,%ax
8010587b:	66 90                	xchg   %ax,%ax
8010587d:	66 90                	xchg   %ax,%ax
8010587f:	90                   	nop

80105880 <sys_fork>:
#include "pstat.h" //include the pstat header

int
sys_fork(void)
{
  return fork();
80105880:	e9 3b e3 ff ff       	jmp    80103bc0 <fork>
80105885:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010588c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105890 <sys_exit>:
}

int
sys_exit(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	83 ec 08             	sub    $0x8,%esp
  exit();
80105896:	e8 d5 e5 ff ff       	call   80103e70 <exit>
  return 0;  // not reached
}
8010589b:	31 c0                	xor    %eax,%eax
8010589d:	c9                   	leave
8010589e:	c3                   	ret
8010589f:	90                   	nop

801058a0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801058a0:	e9 fb e6 ff ff       	jmp    80103fa0 <wait>
801058a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058b0 <sys_kill>:
}

int
sys_kill(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801058b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058b9:	50                   	push   %eax
801058ba:	6a 00                	push   $0x0
801058bc:	e8 2f f2 ff ff       	call   80104af0 <argint>
801058c1:	83 c4 10             	add    $0x10,%esp
801058c4:	85 c0                	test   %eax,%eax
801058c6:	78 18                	js     801058e0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801058c8:	83 ec 0c             	sub    $0xc,%esp
801058cb:	ff 75 f4             	push   -0xc(%ebp)
801058ce:	e8 6d e9 ff ff       	call   80104240 <kill>
801058d3:	83 c4 10             	add    $0x10,%esp
}
801058d6:	c9                   	leave
801058d7:	c3                   	ret
801058d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058df:	90                   	nop
801058e0:	c9                   	leave
    return -1;
801058e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058e6:	c3                   	ret
801058e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ee:	66 90                	xchg   %ax,%ax

801058f0 <sys_getpid>:

int
sys_getpid(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801058f6:	e8 25 e1 ff ff       	call   80103a20 <myproc>
801058fb:	8b 40 10             	mov    0x10(%eax),%eax
}
801058fe:	c9                   	leave
801058ff:	c3                   	ret

80105900 <sys_sbrk>:

int
sys_sbrk(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105904:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105907:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010590a:	50                   	push   %eax
8010590b:	6a 00                	push   $0x0
8010590d:	e8 de f1 ff ff       	call   80104af0 <argint>
80105912:	83 c4 10             	add    $0x10,%esp
80105915:	85 c0                	test   %eax,%eax
80105917:	78 27                	js     80105940 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105919:	e8 02 e1 ff ff       	call   80103a20 <myproc>
  if(growproc(n) < 0)
8010591e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105921:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105923:	ff 75 f4             	push   -0xc(%ebp)
80105926:	e8 15 e2 ff ff       	call   80103b40 <growproc>
8010592b:	83 c4 10             	add    $0x10,%esp
8010592e:	85 c0                	test   %eax,%eax
80105930:	78 0e                	js     80105940 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105932:	89 d8                	mov    %ebx,%eax
80105934:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105937:	c9                   	leave
80105938:	c3                   	ret
80105939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105940:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105945:	eb eb                	jmp    80105932 <sys_sbrk+0x32>
80105947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010594e:	66 90                	xchg   %ax,%ax

80105950 <sys_sleep>:

int
sys_sleep(void)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105954:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105957:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010595a:	50                   	push   %eax
8010595b:	6a 00                	push   $0x0
8010595d:	e8 8e f1 ff ff       	call   80104af0 <argint>
80105962:	83 c4 10             	add    $0x10,%esp
80105965:	85 c0                	test   %eax,%eax
80105967:	78 64                	js     801059cd <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105969:	83 ec 0c             	sub    $0xc,%esp
8010596c:	68 e0 40 11 80       	push   $0x801140e0
80105971:	e8 ea ed ff ff       	call   80104760 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105976:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105979:	8b 1d c0 40 11 80    	mov    0x801140c0,%ebx
  while(ticks - ticks0 < n){
8010597f:	83 c4 10             	add    $0x10,%esp
80105982:	85 d2                	test   %edx,%edx
80105984:	75 2b                	jne    801059b1 <sys_sleep+0x61>
80105986:	eb 58                	jmp    801059e0 <sys_sleep+0x90>
80105988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598f:	90                   	nop
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105990:	83 ec 08             	sub    $0x8,%esp
80105993:	68 e0 40 11 80       	push   $0x801140e0
80105998:	68 c0 40 11 80       	push   $0x801140c0
8010599d:	e8 7e e7 ff ff       	call   80104120 <sleep>
  while(ticks - ticks0 < n){
801059a2:	a1 c0 40 11 80       	mov    0x801140c0,%eax
801059a7:	83 c4 10             	add    $0x10,%esp
801059aa:	29 d8                	sub    %ebx,%eax
801059ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801059af:	73 2f                	jae    801059e0 <sys_sleep+0x90>
    if(myproc()->killed){
801059b1:	e8 6a e0 ff ff       	call   80103a20 <myproc>
801059b6:	8b 40 24             	mov    0x24(%eax),%eax
801059b9:	85 c0                	test   %eax,%eax
801059bb:	74 d3                	je     80105990 <sys_sleep+0x40>
      release(&tickslock);
801059bd:	83 ec 0c             	sub    $0xc,%esp
801059c0:	68 e0 40 11 80       	push   $0x801140e0
801059c5:	e8 36 ed ff ff       	call   80104700 <release>
      return -1;
801059ca:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
801059cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801059d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059d5:	c9                   	leave
801059d6:	c3                   	ret
801059d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059de:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801059e0:	83 ec 0c             	sub    $0xc,%esp
801059e3:	68 e0 40 11 80       	push   $0x801140e0
801059e8:	e8 13 ed ff ff       	call   80104700 <release>
}
801059ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
801059f0:	83 c4 10             	add    $0x10,%esp
801059f3:	31 c0                	xor    %eax,%eax
}
801059f5:	c9                   	leave
801059f6:	c3                   	ret
801059f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059fe:	66 90                	xchg   %ax,%ax

80105a00 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	53                   	push   %ebx
80105a04:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105a07:	68 e0 40 11 80       	push   $0x801140e0
80105a0c:	e8 4f ed ff ff       	call   80104760 <acquire>
  xticks = ticks;
80105a11:	8b 1d c0 40 11 80    	mov    0x801140c0,%ebx
  release(&tickslock);
80105a17:	c7 04 24 e0 40 11 80 	movl   $0x801140e0,(%esp)
80105a1e:	e8 dd ec ff ff       	call   80104700 <release>
  return xticks;
}
80105a23:	89 d8                	mov    %ebx,%eax
80105a25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a28:	c9                   	leave
80105a29:	c3                   	ret
80105a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a30 <sys_getreadcount>:

int //modify systemcall implementation
sys_getreadcount(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	83 ec 08             	sub    $0x8,%esp
  return myproc()->readid;
80105a36:	e8 e5 df ff ff       	call   80103a20 <myproc>
80105a3b:	8b 40 7c             	mov    0x7c(%eax),%eax
}
80105a3e:	c9                   	leave
80105a3f:	c3                   	ret

80105a40 <sys_settickets>:

int //modify systemcall implementation
sys_settickets(int ntickets)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	83 ec 10             	sub    $0x10,%esp
  // int ntickets;
  if(argint(0, &ntickets) < 0)
80105a46:	8d 45 08             	lea    0x8(%ebp),%eax
80105a49:	50                   	push   %eax
80105a4a:	6a 00                	push   $0x0
80105a4c:	e8 9f f0 ff ff       	call   80104af0 <argint>
80105a51:	83 c4 10             	add    $0x10,%esp
80105a54:	85 c0                	test   %eax,%eax
80105a56:	78 28                	js     80105a80 <sys_settickets+0x40>
    return -1;
  myproc()->tickets = ntickets;
80105a58:	e8 c3 df ff ff       	call   80103a20 <myproc>
  return settickets(ntickets);
80105a5d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->tickets = ntickets;
80105a60:	89 c2                	mov    %eax,%edx
80105a62:	8b 45 08             	mov    0x8(%ebp),%eax
80105a65:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
  return settickets(ntickets);
80105a6b:	50                   	push   %eax
80105a6c:	e8 0f e9 ff ff       	call   80104380 <settickets>
80105a71:	83 c4 10             	add    $0x10,%esp
}
80105a74:	c9                   	leave
80105a75:	c3                   	ret
80105a76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a7d:	8d 76 00             	lea    0x0(%esi),%esi
80105a80:	c9                   	leave
    return -1;
80105a81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a86:	c3                   	ret
80105a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a8e:	66 90                	xchg   %ax,%ax

80105a90 <sys_getpinfo>:

int //modify systemcall implementation
sys_getpinfo(struct pstat *ps)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	83 ec 0c             	sub    $0xc,%esp
  // struct pstat *ps;
  if(argptr(0,(char**)&ps, sizeof(struct pstat)) <0){
80105a96:	8d 45 08             	lea    0x8(%ebp),%eax
80105a99:	68 00 04 00 00       	push   $0x400
80105a9e:	50                   	push   %eax
80105a9f:	6a 00                	push   $0x0
80105aa1:	e8 9a f0 ff ff       	call   80104b40 <argptr>
80105aa6:	83 c4 10             	add    $0x10,%esp
80105aa9:	85 c0                	test   %eax,%eax
80105aab:	78 13                	js     80105ac0 <sys_getpinfo+0x30>
    return -1;
  }
  return getpinfo(ps);
80105aad:	83 ec 0c             	sub    $0xc,%esp
80105ab0:	ff 75 08             	push   0x8(%ebp)
80105ab3:	e8 18 e9 ff ff       	call   801043d0 <getpinfo>
80105ab8:	83 c4 10             	add    $0x10,%esp
  //return 0;
80105abb:	c9                   	leave
80105abc:	c3                   	ret
80105abd:	8d 76 00             	lea    0x0(%esi),%esi
80105ac0:	c9                   	leave
    return -1;
80105ac1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ac6:	c3                   	ret

80105ac7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105ac7:	1e                   	push   %ds
  pushl %es
80105ac8:	06                   	push   %es
  pushl %fs
80105ac9:	0f a0                	push   %fs
  pushl %gs
80105acb:	0f a8                	push   %gs
  pushal
80105acd:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105ace:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105ad2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105ad4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ad6:	54                   	push   %esp
  call trap
80105ad7:	e8 c4 00 00 00       	call   80105ba0 <trap>
  addl $4, %esp
80105adc:	83 c4 04             	add    $0x4,%esp

80105adf <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105adf:	61                   	popa
  popl %gs
80105ae0:	0f a9                	pop    %gs
  popl %fs
80105ae2:	0f a1                	pop    %fs
  popl %es
80105ae4:	07                   	pop    %es
  popl %ds
80105ae5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ae6:	83 c4 08             	add    $0x8,%esp
  iret
80105ae9:	cf                   	iret
80105aea:	66 90                	xchg   %ax,%ax
80105aec:	66 90                	xchg   %ax,%ax
80105aee:	66 90                	xchg   %ax,%ax

80105af0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105af0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105af1:	31 c0                	xor    %eax,%eax
{
80105af3:	89 e5                	mov    %esp,%ebp
80105af5:	83 ec 08             	sub    $0x8,%esp
80105af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aff:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105b00:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105b07:	c7 04 c5 22 41 11 80 	movl   $0x8e000008,-0x7feebede(,%eax,8)
80105b0e:	08 00 00 8e 
80105b12:	66 89 14 c5 20 41 11 	mov    %dx,-0x7feebee0(,%eax,8)
80105b19:	80 
80105b1a:	c1 ea 10             	shr    $0x10,%edx
80105b1d:	66 89 14 c5 26 41 11 	mov    %dx,-0x7feebeda(,%eax,8)
80105b24:	80 
  for(i = 0; i < 256; i++)
80105b25:	83 c0 01             	add    $0x1,%eax
80105b28:	3d 00 01 00 00       	cmp    $0x100,%eax
80105b2d:	75 d1                	jne    80105b00 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b2f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105b34:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b37:	c7 05 22 43 11 80 08 	movl   $0xef000008,0x80114322
80105b3e:	00 00 ef 
80105b41:	66 a3 20 43 11 80    	mov    %ax,0x80114320
80105b47:	c1 e8 10             	shr    $0x10,%eax
80105b4a:	66 a3 26 43 11 80    	mov    %ax,0x80114326
  initlock(&tickslock, "time");
80105b50:	68 a5 7d 10 80       	push   $0x80107da5
80105b55:	68 e0 40 11 80       	push   $0x801140e0
80105b5a:	e8 21 ea ff ff       	call   80104580 <initlock>
}
80105b5f:	83 c4 10             	add    $0x10,%esp
80105b62:	c9                   	leave
80105b63:	c3                   	ret
80105b64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b6f:	90                   	nop

80105b70 <idtinit>:

void
idtinit(void)
{
80105b70:	55                   	push   %ebp
  pd[0] = size-1;
80105b71:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105b76:	89 e5                	mov    %esp,%ebp
80105b78:	83 ec 10             	sub    $0x10,%esp
80105b7b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105b7f:	b8 20 41 11 80       	mov    $0x80114120,%eax
80105b84:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105b88:	c1 e8 10             	shr    $0x10,%eax
80105b8b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105b8f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105b92:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105b95:	c9                   	leave
80105b96:	c3                   	ret
80105b97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b9e:	66 90                	xchg   %ax,%ax

80105ba0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
80105ba3:	57                   	push   %edi
80105ba4:	56                   	push   %esi
80105ba5:	53                   	push   %ebx
80105ba6:	83 ec 1c             	sub    $0x1c,%esp
80105ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105bac:	8b 43 30             	mov    0x30(%ebx),%eax
80105baf:	83 f8 40             	cmp    $0x40,%eax
80105bb2:	0f 84 68 01 00 00    	je     80105d20 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105bb8:	83 e8 20             	sub    $0x20,%eax
80105bbb:	83 f8 1f             	cmp    $0x1f,%eax
80105bbe:	0f 87 8c 00 00 00    	ja     80105c50 <trap+0xb0>
80105bc4:	ff 24 85 4c 7e 10 80 	jmp    *-0x7fef81b4(,%eax,4)
80105bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bcf:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105bd0:	e8 db c6 ff ff       	call   801022b0 <ideintr>
    lapiceoi();
80105bd5:	e8 a6 cd ff ff       	call   80102980 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bda:	e8 41 de ff ff       	call   80103a20 <myproc>
80105bdf:	85 c0                	test   %eax,%eax
80105be1:	74 1d                	je     80105c00 <trap+0x60>
80105be3:	e8 38 de ff ff       	call   80103a20 <myproc>
80105be8:	8b 50 24             	mov    0x24(%eax),%edx
80105beb:	85 d2                	test   %edx,%edx
80105bed:	74 11                	je     80105c00 <trap+0x60>
80105bef:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105bf3:	83 e0 03             	and    $0x3,%eax
80105bf6:	66 83 f8 03          	cmp    $0x3,%ax
80105bfa:	0f 84 e8 01 00 00    	je     80105de8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105c00:	e8 1b de ff ff       	call   80103a20 <myproc>
80105c05:	85 c0                	test   %eax,%eax
80105c07:	74 0f                	je     80105c18 <trap+0x78>
80105c09:	e8 12 de ff ff       	call   80103a20 <myproc>
80105c0e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105c12:	0f 84 b8 00 00 00    	je     80105cd0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c18:	e8 03 de ff ff       	call   80103a20 <myproc>
80105c1d:	85 c0                	test   %eax,%eax
80105c1f:	74 1d                	je     80105c3e <trap+0x9e>
80105c21:	e8 fa dd ff ff       	call   80103a20 <myproc>
80105c26:	8b 40 24             	mov    0x24(%eax),%eax
80105c29:	85 c0                	test   %eax,%eax
80105c2b:	74 11                	je     80105c3e <trap+0x9e>
80105c2d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c31:	83 e0 03             	and    $0x3,%eax
80105c34:	66 83 f8 03          	cmp    $0x3,%ax
80105c38:	0f 84 0f 01 00 00    	je     80105d4d <trap+0x1ad>
    exit();
}
80105c3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c41:	5b                   	pop    %ebx
80105c42:	5e                   	pop    %esi
80105c43:	5f                   	pop    %edi
80105c44:	5d                   	pop    %ebp
80105c45:	c3                   	ret
80105c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105c50:	e8 cb dd ff ff       	call   80103a20 <myproc>
80105c55:	8b 7b 38             	mov    0x38(%ebx),%edi
80105c58:	85 c0                	test   %eax,%eax
80105c5a:	0f 84 a2 01 00 00    	je     80105e02 <trap+0x262>
80105c60:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105c64:	0f 84 98 01 00 00    	je     80105e02 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105c6a:	0f 20 d1             	mov    %cr2,%ecx
80105c6d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c70:	e8 8b dd ff ff       	call   80103a00 <cpuid>
80105c75:	8b 73 30             	mov    0x30(%ebx),%esi
80105c78:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105c7b:	8b 43 34             	mov    0x34(%ebx),%eax
80105c7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105c81:	e8 9a dd ff ff       	call   80103a20 <myproc>
80105c86:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105c89:	e8 92 dd ff ff       	call   80103a20 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c8e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105c91:	51                   	push   %ecx
80105c92:	57                   	push   %edi
80105c93:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105c96:	52                   	push   %edx
80105c97:	ff 75 e4             	push   -0x1c(%ebp)
80105c9a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105c9b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105c9e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ca1:	56                   	push   %esi
80105ca2:	ff 70 10             	push   0x10(%eax)
80105ca5:	68 08 7e 10 80       	push   $0x80107e08
80105caa:	e8 01 aa ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80105caf:	83 c4 20             	add    $0x20,%esp
80105cb2:	e8 69 dd ff ff       	call   80103a20 <myproc>
80105cb7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cbe:	e8 5d dd ff ff       	call   80103a20 <myproc>
80105cc3:	85 c0                	test   %eax,%eax
80105cc5:	0f 85 18 ff ff ff    	jne    80105be3 <trap+0x43>
80105ccb:	e9 30 ff ff ff       	jmp    80105c00 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105cd0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105cd4:	0f 85 3e ff ff ff    	jne    80105c18 <trap+0x78>
    yield();
80105cda:	e8 f1 e3 ff ff       	call   801040d0 <yield>
80105cdf:	e9 34 ff ff ff       	jmp    80105c18 <trap+0x78>
80105ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ce8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105ceb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105cef:	e8 0c dd ff ff       	call   80103a00 <cpuid>
80105cf4:	57                   	push   %edi
80105cf5:	56                   	push   %esi
80105cf6:	50                   	push   %eax
80105cf7:	68 b0 7d 10 80       	push   $0x80107db0
80105cfc:	e8 af a9 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105d01:	e8 7a cc ff ff       	call   80102980 <lapiceoi>
    break;
80105d06:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d09:	e8 12 dd ff ff       	call   80103a20 <myproc>
80105d0e:	85 c0                	test   %eax,%eax
80105d10:	0f 85 cd fe ff ff    	jne    80105be3 <trap+0x43>
80105d16:	e9 e5 fe ff ff       	jmp    80105c00 <trap+0x60>
80105d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d1f:	90                   	nop
    if(myproc()->killed)
80105d20:	e8 fb dc ff ff       	call   80103a20 <myproc>
80105d25:	8b 70 24             	mov    0x24(%eax),%esi
80105d28:	85 f6                	test   %esi,%esi
80105d2a:	0f 85 c8 00 00 00    	jne    80105df8 <trap+0x258>
    myproc()->tf = tf;
80105d30:	e8 eb dc ff ff       	call   80103a20 <myproc>
80105d35:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105d38:	e8 f3 ee ff ff       	call   80104c30 <syscall>
    if(myproc()->killed)
80105d3d:	e8 de dc ff ff       	call   80103a20 <myproc>
80105d42:	8b 48 24             	mov    0x24(%eax),%ecx
80105d45:	85 c9                	test   %ecx,%ecx
80105d47:	0f 84 f1 fe ff ff    	je     80105c3e <trap+0x9e>
}
80105d4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d50:	5b                   	pop    %ebx
80105d51:	5e                   	pop    %esi
80105d52:	5f                   	pop    %edi
80105d53:	5d                   	pop    %ebp
      exit();
80105d54:	e9 17 e1 ff ff       	jmp    80103e70 <exit>
80105d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105d60:	e8 4b 02 00 00       	call   80105fb0 <uartintr>
    lapiceoi();
80105d65:	e8 16 cc ff ff       	call   80102980 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d6a:	e8 b1 dc ff ff       	call   80103a20 <myproc>
80105d6f:	85 c0                	test   %eax,%eax
80105d71:	0f 85 6c fe ff ff    	jne    80105be3 <trap+0x43>
80105d77:	e9 84 fe ff ff       	jmp    80105c00 <trap+0x60>
80105d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105d80:	e8 bb ca ff ff       	call   80102840 <kbdintr>
    lapiceoi();
80105d85:	e8 f6 cb ff ff       	call   80102980 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d8a:	e8 91 dc ff ff       	call   80103a20 <myproc>
80105d8f:	85 c0                	test   %eax,%eax
80105d91:	0f 85 4c fe ff ff    	jne    80105be3 <trap+0x43>
80105d97:	e9 64 fe ff ff       	jmp    80105c00 <trap+0x60>
80105d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105da0:	e8 5b dc ff ff       	call   80103a00 <cpuid>
80105da5:	85 c0                	test   %eax,%eax
80105da7:	0f 85 28 fe ff ff    	jne    80105bd5 <trap+0x35>
      acquire(&tickslock);
80105dad:	83 ec 0c             	sub    $0xc,%esp
80105db0:	68 e0 40 11 80       	push   $0x801140e0
80105db5:	e8 a6 e9 ff ff       	call   80104760 <acquire>
      ticks++;
80105dba:	83 05 c0 40 11 80 01 	addl   $0x1,0x801140c0
      wakeup(&ticks);
80105dc1:	c7 04 24 c0 40 11 80 	movl   $0x801140c0,(%esp)
80105dc8:	e8 13 e4 ff ff       	call   801041e0 <wakeup>
      release(&tickslock);
80105dcd:	c7 04 24 e0 40 11 80 	movl   $0x801140e0,(%esp)
80105dd4:	e8 27 e9 ff ff       	call   80104700 <release>
80105dd9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105ddc:	e9 f4 fd ff ff       	jmp    80105bd5 <trap+0x35>
80105de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105de8:	e8 83 e0 ff ff       	call   80103e70 <exit>
80105ded:	e9 0e fe ff ff       	jmp    80105c00 <trap+0x60>
80105df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105df8:	e8 73 e0 ff ff       	call   80103e70 <exit>
80105dfd:	e9 2e ff ff ff       	jmp    80105d30 <trap+0x190>
80105e02:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105e05:	e8 f6 db ff ff       	call   80103a00 <cpuid>
80105e0a:	83 ec 0c             	sub    $0xc,%esp
80105e0d:	56                   	push   %esi
80105e0e:	57                   	push   %edi
80105e0f:	50                   	push   %eax
80105e10:	ff 73 30             	push   0x30(%ebx)
80105e13:	68 d4 7d 10 80       	push   $0x80107dd4
80105e18:	e8 93 a8 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105e1d:	83 c4 14             	add    $0x14,%esp
80105e20:	68 aa 7d 10 80       	push   $0x80107daa
80105e25:	e8 56 a5 ff ff       	call   80100380 <panic>
80105e2a:	66 90                	xchg   %ax,%ax
80105e2c:	66 90                	xchg   %ax,%ax
80105e2e:	66 90                	xchg   %ax,%ax

80105e30 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105e30:	a1 20 49 11 80       	mov    0x80114920,%eax
80105e35:	85 c0                	test   %eax,%eax
80105e37:	74 17                	je     80105e50 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e39:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e3e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105e3f:	a8 01                	test   $0x1,%al
80105e41:	74 0d                	je     80105e50 <uartgetc+0x20>
80105e43:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e48:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105e49:	0f b6 c0             	movzbl %al,%eax
80105e4c:	c3                   	ret
80105e4d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e55:	c3                   	ret
80105e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e5d:	8d 76 00             	lea    0x0(%esi),%esi

80105e60 <uartinit>:
{
80105e60:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e61:	31 c9                	xor    %ecx,%ecx
80105e63:	89 c8                	mov    %ecx,%eax
80105e65:	89 e5                	mov    %esp,%ebp
80105e67:	57                   	push   %edi
80105e68:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105e6d:	56                   	push   %esi
80105e6e:	89 fa                	mov    %edi,%edx
80105e70:	53                   	push   %ebx
80105e71:	83 ec 1c             	sub    $0x1c,%esp
80105e74:	ee                   	out    %al,(%dx)
80105e75:	be fb 03 00 00       	mov    $0x3fb,%esi
80105e7a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105e7f:	89 f2                	mov    %esi,%edx
80105e81:	ee                   	out    %al,(%dx)
80105e82:	b8 0c 00 00 00       	mov    $0xc,%eax
80105e87:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e8c:	ee                   	out    %al,(%dx)
80105e8d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105e92:	89 c8                	mov    %ecx,%eax
80105e94:	89 da                	mov    %ebx,%edx
80105e96:	ee                   	out    %al,(%dx)
80105e97:	b8 03 00 00 00       	mov    $0x3,%eax
80105e9c:	89 f2                	mov    %esi,%edx
80105e9e:	ee                   	out    %al,(%dx)
80105e9f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105ea4:	89 c8                	mov    %ecx,%eax
80105ea6:	ee                   	out    %al,(%dx)
80105ea7:	b8 01 00 00 00       	mov    $0x1,%eax
80105eac:	89 da                	mov    %ebx,%edx
80105eae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105eaf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105eb4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105eb5:	3c ff                	cmp    $0xff,%al
80105eb7:	0f 84 7c 00 00 00    	je     80105f39 <uartinit+0xd9>
  uart = 1;
80105ebd:	c7 05 20 49 11 80 01 	movl   $0x1,0x80114920
80105ec4:	00 00 00 
80105ec7:	89 fa                	mov    %edi,%edx
80105ec9:	ec                   	in     (%dx),%al
80105eca:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ecf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105ed0:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105ed3:	bf cc 7e 10 80       	mov    $0x80107ecc,%edi
80105ed8:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105edd:	6a 00                	push   $0x0
80105edf:	6a 04                	push   $0x4
80105ee1:	e8 fa c5 ff ff       	call   801024e0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105ee6:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105eea:	83 c4 10             	add    $0x10,%esp
80105eed:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80105ef0:	a1 20 49 11 80       	mov    0x80114920,%eax
80105ef5:	85 c0                	test   %eax,%eax
80105ef7:	74 32                	je     80105f2b <uartinit+0xcb>
80105ef9:	89 f2                	mov    %esi,%edx
80105efb:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105efc:	a8 20                	test   $0x20,%al
80105efe:	75 21                	jne    80105f21 <uartinit+0xc1>
80105f00:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f05:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105f08:	83 ec 0c             	sub    $0xc,%esp
80105f0b:	6a 0a                	push   $0xa
80105f0d:	e8 8e ca ff ff       	call   801029a0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f12:	83 c4 10             	add    $0x10,%esp
80105f15:	83 eb 01             	sub    $0x1,%ebx
80105f18:	74 07                	je     80105f21 <uartinit+0xc1>
80105f1a:	89 f2                	mov    %esi,%edx
80105f1c:	ec                   	in     (%dx),%al
80105f1d:	a8 20                	test   $0x20,%al
80105f1f:	74 e7                	je     80105f08 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f21:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f26:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105f2a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105f2b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105f2f:	83 c7 01             	add    $0x1,%edi
80105f32:	88 45 e7             	mov    %al,-0x19(%ebp)
80105f35:	84 c0                	test   %al,%al
80105f37:	75 b7                	jne    80105ef0 <uartinit+0x90>
}
80105f39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f3c:	5b                   	pop    %ebx
80105f3d:	5e                   	pop    %esi
80105f3e:	5f                   	pop    %edi
80105f3f:	5d                   	pop    %ebp
80105f40:	c3                   	ret
80105f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f4f:	90                   	nop

80105f50 <uartputc>:
  if(!uart)
80105f50:	a1 20 49 11 80       	mov    0x80114920,%eax
80105f55:	85 c0                	test   %eax,%eax
80105f57:	74 4f                	je     80105fa8 <uartputc+0x58>
{
80105f59:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f5a:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f5f:	89 e5                	mov    %esp,%ebp
80105f61:	56                   	push   %esi
80105f62:	53                   	push   %ebx
80105f63:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f64:	a8 20                	test   $0x20,%al
80105f66:	75 29                	jne    80105f91 <uartputc+0x41>
80105f68:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f6d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105f78:	83 ec 0c             	sub    $0xc,%esp
80105f7b:	6a 0a                	push   $0xa
80105f7d:	e8 1e ca ff ff       	call   801029a0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f82:	83 c4 10             	add    $0x10,%esp
80105f85:	83 eb 01             	sub    $0x1,%ebx
80105f88:	74 07                	je     80105f91 <uartputc+0x41>
80105f8a:	89 f2                	mov    %esi,%edx
80105f8c:	ec                   	in     (%dx),%al
80105f8d:	a8 20                	test   $0x20,%al
80105f8f:	74 e7                	je     80105f78 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f91:	8b 45 08             	mov    0x8(%ebp),%eax
80105f94:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f99:	ee                   	out    %al,(%dx)
}
80105f9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f9d:	5b                   	pop    %ebx
80105f9e:	5e                   	pop    %esi
80105f9f:	5d                   	pop    %ebp
80105fa0:	c3                   	ret
80105fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fa8:	c3                   	ret
80105fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fb0 <uartintr>:

void
uartintr(void)
{
80105fb0:	55                   	push   %ebp
80105fb1:	89 e5                	mov    %esp,%ebp
80105fb3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105fb6:	68 30 5e 10 80       	push   $0x80105e30
80105fbb:	e8 00 a9 ff ff       	call   801008c0 <consoleintr>
}
80105fc0:	83 c4 10             	add    $0x10,%esp
80105fc3:	c9                   	leave
80105fc4:	c3                   	ret

80105fc5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105fc5:	6a 00                	push   $0x0
  pushl $0
80105fc7:	6a 00                	push   $0x0
  jmp alltraps
80105fc9:	e9 f9 fa ff ff       	jmp    80105ac7 <alltraps>

80105fce <vector1>:
.globl vector1
vector1:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $1
80105fd0:	6a 01                	push   $0x1
  jmp alltraps
80105fd2:	e9 f0 fa ff ff       	jmp    80105ac7 <alltraps>

80105fd7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105fd7:	6a 00                	push   $0x0
  pushl $2
80105fd9:	6a 02                	push   $0x2
  jmp alltraps
80105fdb:	e9 e7 fa ff ff       	jmp    80105ac7 <alltraps>

80105fe0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105fe0:	6a 00                	push   $0x0
  pushl $3
80105fe2:	6a 03                	push   $0x3
  jmp alltraps
80105fe4:	e9 de fa ff ff       	jmp    80105ac7 <alltraps>

80105fe9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105fe9:	6a 00                	push   $0x0
  pushl $4
80105feb:	6a 04                	push   $0x4
  jmp alltraps
80105fed:	e9 d5 fa ff ff       	jmp    80105ac7 <alltraps>

80105ff2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105ff2:	6a 00                	push   $0x0
  pushl $5
80105ff4:	6a 05                	push   $0x5
  jmp alltraps
80105ff6:	e9 cc fa ff ff       	jmp    80105ac7 <alltraps>

80105ffb <vector6>:
.globl vector6
vector6:
  pushl $0
80105ffb:	6a 00                	push   $0x0
  pushl $6
80105ffd:	6a 06                	push   $0x6
  jmp alltraps
80105fff:	e9 c3 fa ff ff       	jmp    80105ac7 <alltraps>

80106004 <vector7>:
.globl vector7
vector7:
  pushl $0
80106004:	6a 00                	push   $0x0
  pushl $7
80106006:	6a 07                	push   $0x7
  jmp alltraps
80106008:	e9 ba fa ff ff       	jmp    80105ac7 <alltraps>

8010600d <vector8>:
.globl vector8
vector8:
  pushl $8
8010600d:	6a 08                	push   $0x8
  jmp alltraps
8010600f:	e9 b3 fa ff ff       	jmp    80105ac7 <alltraps>

80106014 <vector9>:
.globl vector9
vector9:
  pushl $0
80106014:	6a 00                	push   $0x0
  pushl $9
80106016:	6a 09                	push   $0x9
  jmp alltraps
80106018:	e9 aa fa ff ff       	jmp    80105ac7 <alltraps>

8010601d <vector10>:
.globl vector10
vector10:
  pushl $10
8010601d:	6a 0a                	push   $0xa
  jmp alltraps
8010601f:	e9 a3 fa ff ff       	jmp    80105ac7 <alltraps>

80106024 <vector11>:
.globl vector11
vector11:
  pushl $11
80106024:	6a 0b                	push   $0xb
  jmp alltraps
80106026:	e9 9c fa ff ff       	jmp    80105ac7 <alltraps>

8010602b <vector12>:
.globl vector12
vector12:
  pushl $12
8010602b:	6a 0c                	push   $0xc
  jmp alltraps
8010602d:	e9 95 fa ff ff       	jmp    80105ac7 <alltraps>

80106032 <vector13>:
.globl vector13
vector13:
  pushl $13
80106032:	6a 0d                	push   $0xd
  jmp alltraps
80106034:	e9 8e fa ff ff       	jmp    80105ac7 <alltraps>

80106039 <vector14>:
.globl vector14
vector14:
  pushl $14
80106039:	6a 0e                	push   $0xe
  jmp alltraps
8010603b:	e9 87 fa ff ff       	jmp    80105ac7 <alltraps>

80106040 <vector15>:
.globl vector15
vector15:
  pushl $0
80106040:	6a 00                	push   $0x0
  pushl $15
80106042:	6a 0f                	push   $0xf
  jmp alltraps
80106044:	e9 7e fa ff ff       	jmp    80105ac7 <alltraps>

80106049 <vector16>:
.globl vector16
vector16:
  pushl $0
80106049:	6a 00                	push   $0x0
  pushl $16
8010604b:	6a 10                	push   $0x10
  jmp alltraps
8010604d:	e9 75 fa ff ff       	jmp    80105ac7 <alltraps>

80106052 <vector17>:
.globl vector17
vector17:
  pushl $17
80106052:	6a 11                	push   $0x11
  jmp alltraps
80106054:	e9 6e fa ff ff       	jmp    80105ac7 <alltraps>

80106059 <vector18>:
.globl vector18
vector18:
  pushl $0
80106059:	6a 00                	push   $0x0
  pushl $18
8010605b:	6a 12                	push   $0x12
  jmp alltraps
8010605d:	e9 65 fa ff ff       	jmp    80105ac7 <alltraps>

80106062 <vector19>:
.globl vector19
vector19:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $19
80106064:	6a 13                	push   $0x13
  jmp alltraps
80106066:	e9 5c fa ff ff       	jmp    80105ac7 <alltraps>

8010606b <vector20>:
.globl vector20
vector20:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $20
8010606d:	6a 14                	push   $0x14
  jmp alltraps
8010606f:	e9 53 fa ff ff       	jmp    80105ac7 <alltraps>

80106074 <vector21>:
.globl vector21
vector21:
  pushl $0
80106074:	6a 00                	push   $0x0
  pushl $21
80106076:	6a 15                	push   $0x15
  jmp alltraps
80106078:	e9 4a fa ff ff       	jmp    80105ac7 <alltraps>

8010607d <vector22>:
.globl vector22
vector22:
  pushl $0
8010607d:	6a 00                	push   $0x0
  pushl $22
8010607f:	6a 16                	push   $0x16
  jmp alltraps
80106081:	e9 41 fa ff ff       	jmp    80105ac7 <alltraps>

80106086 <vector23>:
.globl vector23
vector23:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $23
80106088:	6a 17                	push   $0x17
  jmp alltraps
8010608a:	e9 38 fa ff ff       	jmp    80105ac7 <alltraps>

8010608f <vector24>:
.globl vector24
vector24:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $24
80106091:	6a 18                	push   $0x18
  jmp alltraps
80106093:	e9 2f fa ff ff       	jmp    80105ac7 <alltraps>

80106098 <vector25>:
.globl vector25
vector25:
  pushl $0
80106098:	6a 00                	push   $0x0
  pushl $25
8010609a:	6a 19                	push   $0x19
  jmp alltraps
8010609c:	e9 26 fa ff ff       	jmp    80105ac7 <alltraps>

801060a1 <vector26>:
.globl vector26
vector26:
  pushl $0
801060a1:	6a 00                	push   $0x0
  pushl $26
801060a3:	6a 1a                	push   $0x1a
  jmp alltraps
801060a5:	e9 1d fa ff ff       	jmp    80105ac7 <alltraps>

801060aa <vector27>:
.globl vector27
vector27:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $27
801060ac:	6a 1b                	push   $0x1b
  jmp alltraps
801060ae:	e9 14 fa ff ff       	jmp    80105ac7 <alltraps>

801060b3 <vector28>:
.globl vector28
vector28:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $28
801060b5:	6a 1c                	push   $0x1c
  jmp alltraps
801060b7:	e9 0b fa ff ff       	jmp    80105ac7 <alltraps>

801060bc <vector29>:
.globl vector29
vector29:
  pushl $0
801060bc:	6a 00                	push   $0x0
  pushl $29
801060be:	6a 1d                	push   $0x1d
  jmp alltraps
801060c0:	e9 02 fa ff ff       	jmp    80105ac7 <alltraps>

801060c5 <vector30>:
.globl vector30
vector30:
  pushl $0
801060c5:	6a 00                	push   $0x0
  pushl $30
801060c7:	6a 1e                	push   $0x1e
  jmp alltraps
801060c9:	e9 f9 f9 ff ff       	jmp    80105ac7 <alltraps>

801060ce <vector31>:
.globl vector31
vector31:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $31
801060d0:	6a 1f                	push   $0x1f
  jmp alltraps
801060d2:	e9 f0 f9 ff ff       	jmp    80105ac7 <alltraps>

801060d7 <vector32>:
.globl vector32
vector32:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $32
801060d9:	6a 20                	push   $0x20
  jmp alltraps
801060db:	e9 e7 f9 ff ff       	jmp    80105ac7 <alltraps>

801060e0 <vector33>:
.globl vector33
vector33:
  pushl $0
801060e0:	6a 00                	push   $0x0
  pushl $33
801060e2:	6a 21                	push   $0x21
  jmp alltraps
801060e4:	e9 de f9 ff ff       	jmp    80105ac7 <alltraps>

801060e9 <vector34>:
.globl vector34
vector34:
  pushl $0
801060e9:	6a 00                	push   $0x0
  pushl $34
801060eb:	6a 22                	push   $0x22
  jmp alltraps
801060ed:	e9 d5 f9 ff ff       	jmp    80105ac7 <alltraps>

801060f2 <vector35>:
.globl vector35
vector35:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $35
801060f4:	6a 23                	push   $0x23
  jmp alltraps
801060f6:	e9 cc f9 ff ff       	jmp    80105ac7 <alltraps>

801060fb <vector36>:
.globl vector36
vector36:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $36
801060fd:	6a 24                	push   $0x24
  jmp alltraps
801060ff:	e9 c3 f9 ff ff       	jmp    80105ac7 <alltraps>

80106104 <vector37>:
.globl vector37
vector37:
  pushl $0
80106104:	6a 00                	push   $0x0
  pushl $37
80106106:	6a 25                	push   $0x25
  jmp alltraps
80106108:	e9 ba f9 ff ff       	jmp    80105ac7 <alltraps>

8010610d <vector38>:
.globl vector38
vector38:
  pushl $0
8010610d:	6a 00                	push   $0x0
  pushl $38
8010610f:	6a 26                	push   $0x26
  jmp alltraps
80106111:	e9 b1 f9 ff ff       	jmp    80105ac7 <alltraps>

80106116 <vector39>:
.globl vector39
vector39:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $39
80106118:	6a 27                	push   $0x27
  jmp alltraps
8010611a:	e9 a8 f9 ff ff       	jmp    80105ac7 <alltraps>

8010611f <vector40>:
.globl vector40
vector40:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $40
80106121:	6a 28                	push   $0x28
  jmp alltraps
80106123:	e9 9f f9 ff ff       	jmp    80105ac7 <alltraps>

80106128 <vector41>:
.globl vector41
vector41:
  pushl $0
80106128:	6a 00                	push   $0x0
  pushl $41
8010612a:	6a 29                	push   $0x29
  jmp alltraps
8010612c:	e9 96 f9 ff ff       	jmp    80105ac7 <alltraps>

80106131 <vector42>:
.globl vector42
vector42:
  pushl $0
80106131:	6a 00                	push   $0x0
  pushl $42
80106133:	6a 2a                	push   $0x2a
  jmp alltraps
80106135:	e9 8d f9 ff ff       	jmp    80105ac7 <alltraps>

8010613a <vector43>:
.globl vector43
vector43:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $43
8010613c:	6a 2b                	push   $0x2b
  jmp alltraps
8010613e:	e9 84 f9 ff ff       	jmp    80105ac7 <alltraps>

80106143 <vector44>:
.globl vector44
vector44:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $44
80106145:	6a 2c                	push   $0x2c
  jmp alltraps
80106147:	e9 7b f9 ff ff       	jmp    80105ac7 <alltraps>

8010614c <vector45>:
.globl vector45
vector45:
  pushl $0
8010614c:	6a 00                	push   $0x0
  pushl $45
8010614e:	6a 2d                	push   $0x2d
  jmp alltraps
80106150:	e9 72 f9 ff ff       	jmp    80105ac7 <alltraps>

80106155 <vector46>:
.globl vector46
vector46:
  pushl $0
80106155:	6a 00                	push   $0x0
  pushl $46
80106157:	6a 2e                	push   $0x2e
  jmp alltraps
80106159:	e9 69 f9 ff ff       	jmp    80105ac7 <alltraps>

8010615e <vector47>:
.globl vector47
vector47:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $47
80106160:	6a 2f                	push   $0x2f
  jmp alltraps
80106162:	e9 60 f9 ff ff       	jmp    80105ac7 <alltraps>

80106167 <vector48>:
.globl vector48
vector48:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $48
80106169:	6a 30                	push   $0x30
  jmp alltraps
8010616b:	e9 57 f9 ff ff       	jmp    80105ac7 <alltraps>

80106170 <vector49>:
.globl vector49
vector49:
  pushl $0
80106170:	6a 00                	push   $0x0
  pushl $49
80106172:	6a 31                	push   $0x31
  jmp alltraps
80106174:	e9 4e f9 ff ff       	jmp    80105ac7 <alltraps>

80106179 <vector50>:
.globl vector50
vector50:
  pushl $0
80106179:	6a 00                	push   $0x0
  pushl $50
8010617b:	6a 32                	push   $0x32
  jmp alltraps
8010617d:	e9 45 f9 ff ff       	jmp    80105ac7 <alltraps>

80106182 <vector51>:
.globl vector51
vector51:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $51
80106184:	6a 33                	push   $0x33
  jmp alltraps
80106186:	e9 3c f9 ff ff       	jmp    80105ac7 <alltraps>

8010618b <vector52>:
.globl vector52
vector52:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $52
8010618d:	6a 34                	push   $0x34
  jmp alltraps
8010618f:	e9 33 f9 ff ff       	jmp    80105ac7 <alltraps>

80106194 <vector53>:
.globl vector53
vector53:
  pushl $0
80106194:	6a 00                	push   $0x0
  pushl $53
80106196:	6a 35                	push   $0x35
  jmp alltraps
80106198:	e9 2a f9 ff ff       	jmp    80105ac7 <alltraps>

8010619d <vector54>:
.globl vector54
vector54:
  pushl $0
8010619d:	6a 00                	push   $0x0
  pushl $54
8010619f:	6a 36                	push   $0x36
  jmp alltraps
801061a1:	e9 21 f9 ff ff       	jmp    80105ac7 <alltraps>

801061a6 <vector55>:
.globl vector55
vector55:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $55
801061a8:	6a 37                	push   $0x37
  jmp alltraps
801061aa:	e9 18 f9 ff ff       	jmp    80105ac7 <alltraps>

801061af <vector56>:
.globl vector56
vector56:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $56
801061b1:	6a 38                	push   $0x38
  jmp alltraps
801061b3:	e9 0f f9 ff ff       	jmp    80105ac7 <alltraps>

801061b8 <vector57>:
.globl vector57
vector57:
  pushl $0
801061b8:	6a 00                	push   $0x0
  pushl $57
801061ba:	6a 39                	push   $0x39
  jmp alltraps
801061bc:	e9 06 f9 ff ff       	jmp    80105ac7 <alltraps>

801061c1 <vector58>:
.globl vector58
vector58:
  pushl $0
801061c1:	6a 00                	push   $0x0
  pushl $58
801061c3:	6a 3a                	push   $0x3a
  jmp alltraps
801061c5:	e9 fd f8 ff ff       	jmp    80105ac7 <alltraps>

801061ca <vector59>:
.globl vector59
vector59:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $59
801061cc:	6a 3b                	push   $0x3b
  jmp alltraps
801061ce:	e9 f4 f8 ff ff       	jmp    80105ac7 <alltraps>

801061d3 <vector60>:
.globl vector60
vector60:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $60
801061d5:	6a 3c                	push   $0x3c
  jmp alltraps
801061d7:	e9 eb f8 ff ff       	jmp    80105ac7 <alltraps>

801061dc <vector61>:
.globl vector61
vector61:
  pushl $0
801061dc:	6a 00                	push   $0x0
  pushl $61
801061de:	6a 3d                	push   $0x3d
  jmp alltraps
801061e0:	e9 e2 f8 ff ff       	jmp    80105ac7 <alltraps>

801061e5 <vector62>:
.globl vector62
vector62:
  pushl $0
801061e5:	6a 00                	push   $0x0
  pushl $62
801061e7:	6a 3e                	push   $0x3e
  jmp alltraps
801061e9:	e9 d9 f8 ff ff       	jmp    80105ac7 <alltraps>

801061ee <vector63>:
.globl vector63
vector63:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $63
801061f0:	6a 3f                	push   $0x3f
  jmp alltraps
801061f2:	e9 d0 f8 ff ff       	jmp    80105ac7 <alltraps>

801061f7 <vector64>:
.globl vector64
vector64:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $64
801061f9:	6a 40                	push   $0x40
  jmp alltraps
801061fb:	e9 c7 f8 ff ff       	jmp    80105ac7 <alltraps>

80106200 <vector65>:
.globl vector65
vector65:
  pushl $0
80106200:	6a 00                	push   $0x0
  pushl $65
80106202:	6a 41                	push   $0x41
  jmp alltraps
80106204:	e9 be f8 ff ff       	jmp    80105ac7 <alltraps>

80106209 <vector66>:
.globl vector66
vector66:
  pushl $0
80106209:	6a 00                	push   $0x0
  pushl $66
8010620b:	6a 42                	push   $0x42
  jmp alltraps
8010620d:	e9 b5 f8 ff ff       	jmp    80105ac7 <alltraps>

80106212 <vector67>:
.globl vector67
vector67:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $67
80106214:	6a 43                	push   $0x43
  jmp alltraps
80106216:	e9 ac f8 ff ff       	jmp    80105ac7 <alltraps>

8010621b <vector68>:
.globl vector68
vector68:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $68
8010621d:	6a 44                	push   $0x44
  jmp alltraps
8010621f:	e9 a3 f8 ff ff       	jmp    80105ac7 <alltraps>

80106224 <vector69>:
.globl vector69
vector69:
  pushl $0
80106224:	6a 00                	push   $0x0
  pushl $69
80106226:	6a 45                	push   $0x45
  jmp alltraps
80106228:	e9 9a f8 ff ff       	jmp    80105ac7 <alltraps>

8010622d <vector70>:
.globl vector70
vector70:
  pushl $0
8010622d:	6a 00                	push   $0x0
  pushl $70
8010622f:	6a 46                	push   $0x46
  jmp alltraps
80106231:	e9 91 f8 ff ff       	jmp    80105ac7 <alltraps>

80106236 <vector71>:
.globl vector71
vector71:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $71
80106238:	6a 47                	push   $0x47
  jmp alltraps
8010623a:	e9 88 f8 ff ff       	jmp    80105ac7 <alltraps>

8010623f <vector72>:
.globl vector72
vector72:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $72
80106241:	6a 48                	push   $0x48
  jmp alltraps
80106243:	e9 7f f8 ff ff       	jmp    80105ac7 <alltraps>

80106248 <vector73>:
.globl vector73
vector73:
  pushl $0
80106248:	6a 00                	push   $0x0
  pushl $73
8010624a:	6a 49                	push   $0x49
  jmp alltraps
8010624c:	e9 76 f8 ff ff       	jmp    80105ac7 <alltraps>

80106251 <vector74>:
.globl vector74
vector74:
  pushl $0
80106251:	6a 00                	push   $0x0
  pushl $74
80106253:	6a 4a                	push   $0x4a
  jmp alltraps
80106255:	e9 6d f8 ff ff       	jmp    80105ac7 <alltraps>

8010625a <vector75>:
.globl vector75
vector75:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $75
8010625c:	6a 4b                	push   $0x4b
  jmp alltraps
8010625e:	e9 64 f8 ff ff       	jmp    80105ac7 <alltraps>

80106263 <vector76>:
.globl vector76
vector76:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $76
80106265:	6a 4c                	push   $0x4c
  jmp alltraps
80106267:	e9 5b f8 ff ff       	jmp    80105ac7 <alltraps>

8010626c <vector77>:
.globl vector77
vector77:
  pushl $0
8010626c:	6a 00                	push   $0x0
  pushl $77
8010626e:	6a 4d                	push   $0x4d
  jmp alltraps
80106270:	e9 52 f8 ff ff       	jmp    80105ac7 <alltraps>

80106275 <vector78>:
.globl vector78
vector78:
  pushl $0
80106275:	6a 00                	push   $0x0
  pushl $78
80106277:	6a 4e                	push   $0x4e
  jmp alltraps
80106279:	e9 49 f8 ff ff       	jmp    80105ac7 <alltraps>

8010627e <vector79>:
.globl vector79
vector79:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $79
80106280:	6a 4f                	push   $0x4f
  jmp alltraps
80106282:	e9 40 f8 ff ff       	jmp    80105ac7 <alltraps>

80106287 <vector80>:
.globl vector80
vector80:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $80
80106289:	6a 50                	push   $0x50
  jmp alltraps
8010628b:	e9 37 f8 ff ff       	jmp    80105ac7 <alltraps>

80106290 <vector81>:
.globl vector81
vector81:
  pushl $0
80106290:	6a 00                	push   $0x0
  pushl $81
80106292:	6a 51                	push   $0x51
  jmp alltraps
80106294:	e9 2e f8 ff ff       	jmp    80105ac7 <alltraps>

80106299 <vector82>:
.globl vector82
vector82:
  pushl $0
80106299:	6a 00                	push   $0x0
  pushl $82
8010629b:	6a 52                	push   $0x52
  jmp alltraps
8010629d:	e9 25 f8 ff ff       	jmp    80105ac7 <alltraps>

801062a2 <vector83>:
.globl vector83
vector83:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $83
801062a4:	6a 53                	push   $0x53
  jmp alltraps
801062a6:	e9 1c f8 ff ff       	jmp    80105ac7 <alltraps>

801062ab <vector84>:
.globl vector84
vector84:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $84
801062ad:	6a 54                	push   $0x54
  jmp alltraps
801062af:	e9 13 f8 ff ff       	jmp    80105ac7 <alltraps>

801062b4 <vector85>:
.globl vector85
vector85:
  pushl $0
801062b4:	6a 00                	push   $0x0
  pushl $85
801062b6:	6a 55                	push   $0x55
  jmp alltraps
801062b8:	e9 0a f8 ff ff       	jmp    80105ac7 <alltraps>

801062bd <vector86>:
.globl vector86
vector86:
  pushl $0
801062bd:	6a 00                	push   $0x0
  pushl $86
801062bf:	6a 56                	push   $0x56
  jmp alltraps
801062c1:	e9 01 f8 ff ff       	jmp    80105ac7 <alltraps>

801062c6 <vector87>:
.globl vector87
vector87:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $87
801062c8:	6a 57                	push   $0x57
  jmp alltraps
801062ca:	e9 f8 f7 ff ff       	jmp    80105ac7 <alltraps>

801062cf <vector88>:
.globl vector88
vector88:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $88
801062d1:	6a 58                	push   $0x58
  jmp alltraps
801062d3:	e9 ef f7 ff ff       	jmp    80105ac7 <alltraps>

801062d8 <vector89>:
.globl vector89
vector89:
  pushl $0
801062d8:	6a 00                	push   $0x0
  pushl $89
801062da:	6a 59                	push   $0x59
  jmp alltraps
801062dc:	e9 e6 f7 ff ff       	jmp    80105ac7 <alltraps>

801062e1 <vector90>:
.globl vector90
vector90:
  pushl $0
801062e1:	6a 00                	push   $0x0
  pushl $90
801062e3:	6a 5a                	push   $0x5a
  jmp alltraps
801062e5:	e9 dd f7 ff ff       	jmp    80105ac7 <alltraps>

801062ea <vector91>:
.globl vector91
vector91:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $91
801062ec:	6a 5b                	push   $0x5b
  jmp alltraps
801062ee:	e9 d4 f7 ff ff       	jmp    80105ac7 <alltraps>

801062f3 <vector92>:
.globl vector92
vector92:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $92
801062f5:	6a 5c                	push   $0x5c
  jmp alltraps
801062f7:	e9 cb f7 ff ff       	jmp    80105ac7 <alltraps>

801062fc <vector93>:
.globl vector93
vector93:
  pushl $0
801062fc:	6a 00                	push   $0x0
  pushl $93
801062fe:	6a 5d                	push   $0x5d
  jmp alltraps
80106300:	e9 c2 f7 ff ff       	jmp    80105ac7 <alltraps>

80106305 <vector94>:
.globl vector94
vector94:
  pushl $0
80106305:	6a 00                	push   $0x0
  pushl $94
80106307:	6a 5e                	push   $0x5e
  jmp alltraps
80106309:	e9 b9 f7 ff ff       	jmp    80105ac7 <alltraps>

8010630e <vector95>:
.globl vector95
vector95:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $95
80106310:	6a 5f                	push   $0x5f
  jmp alltraps
80106312:	e9 b0 f7 ff ff       	jmp    80105ac7 <alltraps>

80106317 <vector96>:
.globl vector96
vector96:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $96
80106319:	6a 60                	push   $0x60
  jmp alltraps
8010631b:	e9 a7 f7 ff ff       	jmp    80105ac7 <alltraps>

80106320 <vector97>:
.globl vector97
vector97:
  pushl $0
80106320:	6a 00                	push   $0x0
  pushl $97
80106322:	6a 61                	push   $0x61
  jmp alltraps
80106324:	e9 9e f7 ff ff       	jmp    80105ac7 <alltraps>

80106329 <vector98>:
.globl vector98
vector98:
  pushl $0
80106329:	6a 00                	push   $0x0
  pushl $98
8010632b:	6a 62                	push   $0x62
  jmp alltraps
8010632d:	e9 95 f7 ff ff       	jmp    80105ac7 <alltraps>

80106332 <vector99>:
.globl vector99
vector99:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $99
80106334:	6a 63                	push   $0x63
  jmp alltraps
80106336:	e9 8c f7 ff ff       	jmp    80105ac7 <alltraps>

8010633b <vector100>:
.globl vector100
vector100:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $100
8010633d:	6a 64                	push   $0x64
  jmp alltraps
8010633f:	e9 83 f7 ff ff       	jmp    80105ac7 <alltraps>

80106344 <vector101>:
.globl vector101
vector101:
  pushl $0
80106344:	6a 00                	push   $0x0
  pushl $101
80106346:	6a 65                	push   $0x65
  jmp alltraps
80106348:	e9 7a f7 ff ff       	jmp    80105ac7 <alltraps>

8010634d <vector102>:
.globl vector102
vector102:
  pushl $0
8010634d:	6a 00                	push   $0x0
  pushl $102
8010634f:	6a 66                	push   $0x66
  jmp alltraps
80106351:	e9 71 f7 ff ff       	jmp    80105ac7 <alltraps>

80106356 <vector103>:
.globl vector103
vector103:
  pushl $0
80106356:	6a 00                	push   $0x0
  pushl $103
80106358:	6a 67                	push   $0x67
  jmp alltraps
8010635a:	e9 68 f7 ff ff       	jmp    80105ac7 <alltraps>

8010635f <vector104>:
.globl vector104
vector104:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $104
80106361:	6a 68                	push   $0x68
  jmp alltraps
80106363:	e9 5f f7 ff ff       	jmp    80105ac7 <alltraps>

80106368 <vector105>:
.globl vector105
vector105:
  pushl $0
80106368:	6a 00                	push   $0x0
  pushl $105
8010636a:	6a 69                	push   $0x69
  jmp alltraps
8010636c:	e9 56 f7 ff ff       	jmp    80105ac7 <alltraps>

80106371 <vector106>:
.globl vector106
vector106:
  pushl $0
80106371:	6a 00                	push   $0x0
  pushl $106
80106373:	6a 6a                	push   $0x6a
  jmp alltraps
80106375:	e9 4d f7 ff ff       	jmp    80105ac7 <alltraps>

8010637a <vector107>:
.globl vector107
vector107:
  pushl $0
8010637a:	6a 00                	push   $0x0
  pushl $107
8010637c:	6a 6b                	push   $0x6b
  jmp alltraps
8010637e:	e9 44 f7 ff ff       	jmp    80105ac7 <alltraps>

80106383 <vector108>:
.globl vector108
vector108:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $108
80106385:	6a 6c                	push   $0x6c
  jmp alltraps
80106387:	e9 3b f7 ff ff       	jmp    80105ac7 <alltraps>

8010638c <vector109>:
.globl vector109
vector109:
  pushl $0
8010638c:	6a 00                	push   $0x0
  pushl $109
8010638e:	6a 6d                	push   $0x6d
  jmp alltraps
80106390:	e9 32 f7 ff ff       	jmp    80105ac7 <alltraps>

80106395 <vector110>:
.globl vector110
vector110:
  pushl $0
80106395:	6a 00                	push   $0x0
  pushl $110
80106397:	6a 6e                	push   $0x6e
  jmp alltraps
80106399:	e9 29 f7 ff ff       	jmp    80105ac7 <alltraps>

8010639e <vector111>:
.globl vector111
vector111:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $111
801063a0:	6a 6f                	push   $0x6f
  jmp alltraps
801063a2:	e9 20 f7 ff ff       	jmp    80105ac7 <alltraps>

801063a7 <vector112>:
.globl vector112
vector112:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $112
801063a9:	6a 70                	push   $0x70
  jmp alltraps
801063ab:	e9 17 f7 ff ff       	jmp    80105ac7 <alltraps>

801063b0 <vector113>:
.globl vector113
vector113:
  pushl $0
801063b0:	6a 00                	push   $0x0
  pushl $113
801063b2:	6a 71                	push   $0x71
  jmp alltraps
801063b4:	e9 0e f7 ff ff       	jmp    80105ac7 <alltraps>

801063b9 <vector114>:
.globl vector114
vector114:
  pushl $0
801063b9:	6a 00                	push   $0x0
  pushl $114
801063bb:	6a 72                	push   $0x72
  jmp alltraps
801063bd:	e9 05 f7 ff ff       	jmp    80105ac7 <alltraps>

801063c2 <vector115>:
.globl vector115
vector115:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $115
801063c4:	6a 73                	push   $0x73
  jmp alltraps
801063c6:	e9 fc f6 ff ff       	jmp    80105ac7 <alltraps>

801063cb <vector116>:
.globl vector116
vector116:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $116
801063cd:	6a 74                	push   $0x74
  jmp alltraps
801063cf:	e9 f3 f6 ff ff       	jmp    80105ac7 <alltraps>

801063d4 <vector117>:
.globl vector117
vector117:
  pushl $0
801063d4:	6a 00                	push   $0x0
  pushl $117
801063d6:	6a 75                	push   $0x75
  jmp alltraps
801063d8:	e9 ea f6 ff ff       	jmp    80105ac7 <alltraps>

801063dd <vector118>:
.globl vector118
vector118:
  pushl $0
801063dd:	6a 00                	push   $0x0
  pushl $118
801063df:	6a 76                	push   $0x76
  jmp alltraps
801063e1:	e9 e1 f6 ff ff       	jmp    80105ac7 <alltraps>

801063e6 <vector119>:
.globl vector119
vector119:
  pushl $0
801063e6:	6a 00                	push   $0x0
  pushl $119
801063e8:	6a 77                	push   $0x77
  jmp alltraps
801063ea:	e9 d8 f6 ff ff       	jmp    80105ac7 <alltraps>

801063ef <vector120>:
.globl vector120
vector120:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $120
801063f1:	6a 78                	push   $0x78
  jmp alltraps
801063f3:	e9 cf f6 ff ff       	jmp    80105ac7 <alltraps>

801063f8 <vector121>:
.globl vector121
vector121:
  pushl $0
801063f8:	6a 00                	push   $0x0
  pushl $121
801063fa:	6a 79                	push   $0x79
  jmp alltraps
801063fc:	e9 c6 f6 ff ff       	jmp    80105ac7 <alltraps>

80106401 <vector122>:
.globl vector122
vector122:
  pushl $0
80106401:	6a 00                	push   $0x0
  pushl $122
80106403:	6a 7a                	push   $0x7a
  jmp alltraps
80106405:	e9 bd f6 ff ff       	jmp    80105ac7 <alltraps>

8010640a <vector123>:
.globl vector123
vector123:
  pushl $0
8010640a:	6a 00                	push   $0x0
  pushl $123
8010640c:	6a 7b                	push   $0x7b
  jmp alltraps
8010640e:	e9 b4 f6 ff ff       	jmp    80105ac7 <alltraps>

80106413 <vector124>:
.globl vector124
vector124:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $124
80106415:	6a 7c                	push   $0x7c
  jmp alltraps
80106417:	e9 ab f6 ff ff       	jmp    80105ac7 <alltraps>

8010641c <vector125>:
.globl vector125
vector125:
  pushl $0
8010641c:	6a 00                	push   $0x0
  pushl $125
8010641e:	6a 7d                	push   $0x7d
  jmp alltraps
80106420:	e9 a2 f6 ff ff       	jmp    80105ac7 <alltraps>

80106425 <vector126>:
.globl vector126
vector126:
  pushl $0
80106425:	6a 00                	push   $0x0
  pushl $126
80106427:	6a 7e                	push   $0x7e
  jmp alltraps
80106429:	e9 99 f6 ff ff       	jmp    80105ac7 <alltraps>

8010642e <vector127>:
.globl vector127
vector127:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $127
80106430:	6a 7f                	push   $0x7f
  jmp alltraps
80106432:	e9 90 f6 ff ff       	jmp    80105ac7 <alltraps>

80106437 <vector128>:
.globl vector128
vector128:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $128
80106439:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010643e:	e9 84 f6 ff ff       	jmp    80105ac7 <alltraps>

80106443 <vector129>:
.globl vector129
vector129:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $129
80106445:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010644a:	e9 78 f6 ff ff       	jmp    80105ac7 <alltraps>

8010644f <vector130>:
.globl vector130
vector130:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $130
80106451:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106456:	e9 6c f6 ff ff       	jmp    80105ac7 <alltraps>

8010645b <vector131>:
.globl vector131
vector131:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $131
8010645d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106462:	e9 60 f6 ff ff       	jmp    80105ac7 <alltraps>

80106467 <vector132>:
.globl vector132
vector132:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $132
80106469:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010646e:	e9 54 f6 ff ff       	jmp    80105ac7 <alltraps>

80106473 <vector133>:
.globl vector133
vector133:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $133
80106475:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010647a:	e9 48 f6 ff ff       	jmp    80105ac7 <alltraps>

8010647f <vector134>:
.globl vector134
vector134:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $134
80106481:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106486:	e9 3c f6 ff ff       	jmp    80105ac7 <alltraps>

8010648b <vector135>:
.globl vector135
vector135:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $135
8010648d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106492:	e9 30 f6 ff ff       	jmp    80105ac7 <alltraps>

80106497 <vector136>:
.globl vector136
vector136:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $136
80106499:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010649e:	e9 24 f6 ff ff       	jmp    80105ac7 <alltraps>

801064a3 <vector137>:
.globl vector137
vector137:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $137
801064a5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801064aa:	e9 18 f6 ff ff       	jmp    80105ac7 <alltraps>

801064af <vector138>:
.globl vector138
vector138:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $138
801064b1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801064b6:	e9 0c f6 ff ff       	jmp    80105ac7 <alltraps>

801064bb <vector139>:
.globl vector139
vector139:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $139
801064bd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801064c2:	e9 00 f6 ff ff       	jmp    80105ac7 <alltraps>

801064c7 <vector140>:
.globl vector140
vector140:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $140
801064c9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801064ce:	e9 f4 f5 ff ff       	jmp    80105ac7 <alltraps>

801064d3 <vector141>:
.globl vector141
vector141:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $141
801064d5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801064da:	e9 e8 f5 ff ff       	jmp    80105ac7 <alltraps>

801064df <vector142>:
.globl vector142
vector142:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $142
801064e1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801064e6:	e9 dc f5 ff ff       	jmp    80105ac7 <alltraps>

801064eb <vector143>:
.globl vector143
vector143:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $143
801064ed:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801064f2:	e9 d0 f5 ff ff       	jmp    80105ac7 <alltraps>

801064f7 <vector144>:
.globl vector144
vector144:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $144
801064f9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801064fe:	e9 c4 f5 ff ff       	jmp    80105ac7 <alltraps>

80106503 <vector145>:
.globl vector145
vector145:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $145
80106505:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010650a:	e9 b8 f5 ff ff       	jmp    80105ac7 <alltraps>

8010650f <vector146>:
.globl vector146
vector146:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $146
80106511:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106516:	e9 ac f5 ff ff       	jmp    80105ac7 <alltraps>

8010651b <vector147>:
.globl vector147
vector147:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $147
8010651d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106522:	e9 a0 f5 ff ff       	jmp    80105ac7 <alltraps>

80106527 <vector148>:
.globl vector148
vector148:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $148
80106529:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010652e:	e9 94 f5 ff ff       	jmp    80105ac7 <alltraps>

80106533 <vector149>:
.globl vector149
vector149:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $149
80106535:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010653a:	e9 88 f5 ff ff       	jmp    80105ac7 <alltraps>

8010653f <vector150>:
.globl vector150
vector150:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $150
80106541:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106546:	e9 7c f5 ff ff       	jmp    80105ac7 <alltraps>

8010654b <vector151>:
.globl vector151
vector151:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $151
8010654d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106552:	e9 70 f5 ff ff       	jmp    80105ac7 <alltraps>

80106557 <vector152>:
.globl vector152
vector152:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $152
80106559:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010655e:	e9 64 f5 ff ff       	jmp    80105ac7 <alltraps>

80106563 <vector153>:
.globl vector153
vector153:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $153
80106565:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010656a:	e9 58 f5 ff ff       	jmp    80105ac7 <alltraps>

8010656f <vector154>:
.globl vector154
vector154:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $154
80106571:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106576:	e9 4c f5 ff ff       	jmp    80105ac7 <alltraps>

8010657b <vector155>:
.globl vector155
vector155:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $155
8010657d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106582:	e9 40 f5 ff ff       	jmp    80105ac7 <alltraps>

80106587 <vector156>:
.globl vector156
vector156:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $156
80106589:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010658e:	e9 34 f5 ff ff       	jmp    80105ac7 <alltraps>

80106593 <vector157>:
.globl vector157
vector157:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $157
80106595:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010659a:	e9 28 f5 ff ff       	jmp    80105ac7 <alltraps>

8010659f <vector158>:
.globl vector158
vector158:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $158
801065a1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801065a6:	e9 1c f5 ff ff       	jmp    80105ac7 <alltraps>

801065ab <vector159>:
.globl vector159
vector159:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $159
801065ad:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801065b2:	e9 10 f5 ff ff       	jmp    80105ac7 <alltraps>

801065b7 <vector160>:
.globl vector160
vector160:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $160
801065b9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801065be:	e9 04 f5 ff ff       	jmp    80105ac7 <alltraps>

801065c3 <vector161>:
.globl vector161
vector161:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $161
801065c5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801065ca:	e9 f8 f4 ff ff       	jmp    80105ac7 <alltraps>

801065cf <vector162>:
.globl vector162
vector162:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $162
801065d1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801065d6:	e9 ec f4 ff ff       	jmp    80105ac7 <alltraps>

801065db <vector163>:
.globl vector163
vector163:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $163
801065dd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801065e2:	e9 e0 f4 ff ff       	jmp    80105ac7 <alltraps>

801065e7 <vector164>:
.globl vector164
vector164:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $164
801065e9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801065ee:	e9 d4 f4 ff ff       	jmp    80105ac7 <alltraps>

801065f3 <vector165>:
.globl vector165
vector165:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $165
801065f5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801065fa:	e9 c8 f4 ff ff       	jmp    80105ac7 <alltraps>

801065ff <vector166>:
.globl vector166
vector166:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $166
80106601:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106606:	e9 bc f4 ff ff       	jmp    80105ac7 <alltraps>

8010660b <vector167>:
.globl vector167
vector167:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $167
8010660d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106612:	e9 b0 f4 ff ff       	jmp    80105ac7 <alltraps>

80106617 <vector168>:
.globl vector168
vector168:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $168
80106619:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010661e:	e9 a4 f4 ff ff       	jmp    80105ac7 <alltraps>

80106623 <vector169>:
.globl vector169
vector169:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $169
80106625:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010662a:	e9 98 f4 ff ff       	jmp    80105ac7 <alltraps>

8010662f <vector170>:
.globl vector170
vector170:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $170
80106631:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106636:	e9 8c f4 ff ff       	jmp    80105ac7 <alltraps>

8010663b <vector171>:
.globl vector171
vector171:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $171
8010663d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106642:	e9 80 f4 ff ff       	jmp    80105ac7 <alltraps>

80106647 <vector172>:
.globl vector172
vector172:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $172
80106649:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010664e:	e9 74 f4 ff ff       	jmp    80105ac7 <alltraps>

80106653 <vector173>:
.globl vector173
vector173:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $173
80106655:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010665a:	e9 68 f4 ff ff       	jmp    80105ac7 <alltraps>

8010665f <vector174>:
.globl vector174
vector174:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $174
80106661:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106666:	e9 5c f4 ff ff       	jmp    80105ac7 <alltraps>

8010666b <vector175>:
.globl vector175
vector175:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $175
8010666d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106672:	e9 50 f4 ff ff       	jmp    80105ac7 <alltraps>

80106677 <vector176>:
.globl vector176
vector176:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $176
80106679:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010667e:	e9 44 f4 ff ff       	jmp    80105ac7 <alltraps>

80106683 <vector177>:
.globl vector177
vector177:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $177
80106685:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010668a:	e9 38 f4 ff ff       	jmp    80105ac7 <alltraps>

8010668f <vector178>:
.globl vector178
vector178:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $178
80106691:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106696:	e9 2c f4 ff ff       	jmp    80105ac7 <alltraps>

8010669b <vector179>:
.globl vector179
vector179:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $179
8010669d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801066a2:	e9 20 f4 ff ff       	jmp    80105ac7 <alltraps>

801066a7 <vector180>:
.globl vector180
vector180:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $180
801066a9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801066ae:	e9 14 f4 ff ff       	jmp    80105ac7 <alltraps>

801066b3 <vector181>:
.globl vector181
vector181:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $181
801066b5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801066ba:	e9 08 f4 ff ff       	jmp    80105ac7 <alltraps>

801066bf <vector182>:
.globl vector182
vector182:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $182
801066c1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801066c6:	e9 fc f3 ff ff       	jmp    80105ac7 <alltraps>

801066cb <vector183>:
.globl vector183
vector183:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $183
801066cd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801066d2:	e9 f0 f3 ff ff       	jmp    80105ac7 <alltraps>

801066d7 <vector184>:
.globl vector184
vector184:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $184
801066d9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801066de:	e9 e4 f3 ff ff       	jmp    80105ac7 <alltraps>

801066e3 <vector185>:
.globl vector185
vector185:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $185
801066e5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801066ea:	e9 d8 f3 ff ff       	jmp    80105ac7 <alltraps>

801066ef <vector186>:
.globl vector186
vector186:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $186
801066f1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801066f6:	e9 cc f3 ff ff       	jmp    80105ac7 <alltraps>

801066fb <vector187>:
.globl vector187
vector187:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $187
801066fd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106702:	e9 c0 f3 ff ff       	jmp    80105ac7 <alltraps>

80106707 <vector188>:
.globl vector188
vector188:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $188
80106709:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010670e:	e9 b4 f3 ff ff       	jmp    80105ac7 <alltraps>

80106713 <vector189>:
.globl vector189
vector189:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $189
80106715:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010671a:	e9 a8 f3 ff ff       	jmp    80105ac7 <alltraps>

8010671f <vector190>:
.globl vector190
vector190:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $190
80106721:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106726:	e9 9c f3 ff ff       	jmp    80105ac7 <alltraps>

8010672b <vector191>:
.globl vector191
vector191:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $191
8010672d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106732:	e9 90 f3 ff ff       	jmp    80105ac7 <alltraps>

80106737 <vector192>:
.globl vector192
vector192:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $192
80106739:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010673e:	e9 84 f3 ff ff       	jmp    80105ac7 <alltraps>

80106743 <vector193>:
.globl vector193
vector193:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $193
80106745:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010674a:	e9 78 f3 ff ff       	jmp    80105ac7 <alltraps>

8010674f <vector194>:
.globl vector194
vector194:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $194
80106751:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106756:	e9 6c f3 ff ff       	jmp    80105ac7 <alltraps>

8010675b <vector195>:
.globl vector195
vector195:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $195
8010675d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106762:	e9 60 f3 ff ff       	jmp    80105ac7 <alltraps>

80106767 <vector196>:
.globl vector196
vector196:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $196
80106769:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010676e:	e9 54 f3 ff ff       	jmp    80105ac7 <alltraps>

80106773 <vector197>:
.globl vector197
vector197:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $197
80106775:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010677a:	e9 48 f3 ff ff       	jmp    80105ac7 <alltraps>

8010677f <vector198>:
.globl vector198
vector198:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $198
80106781:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106786:	e9 3c f3 ff ff       	jmp    80105ac7 <alltraps>

8010678b <vector199>:
.globl vector199
vector199:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $199
8010678d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106792:	e9 30 f3 ff ff       	jmp    80105ac7 <alltraps>

80106797 <vector200>:
.globl vector200
vector200:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $200
80106799:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010679e:	e9 24 f3 ff ff       	jmp    80105ac7 <alltraps>

801067a3 <vector201>:
.globl vector201
vector201:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $201
801067a5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801067aa:	e9 18 f3 ff ff       	jmp    80105ac7 <alltraps>

801067af <vector202>:
.globl vector202
vector202:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $202
801067b1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801067b6:	e9 0c f3 ff ff       	jmp    80105ac7 <alltraps>

801067bb <vector203>:
.globl vector203
vector203:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $203
801067bd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801067c2:	e9 00 f3 ff ff       	jmp    80105ac7 <alltraps>

801067c7 <vector204>:
.globl vector204
vector204:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $204
801067c9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801067ce:	e9 f4 f2 ff ff       	jmp    80105ac7 <alltraps>

801067d3 <vector205>:
.globl vector205
vector205:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $205
801067d5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801067da:	e9 e8 f2 ff ff       	jmp    80105ac7 <alltraps>

801067df <vector206>:
.globl vector206
vector206:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $206
801067e1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801067e6:	e9 dc f2 ff ff       	jmp    80105ac7 <alltraps>

801067eb <vector207>:
.globl vector207
vector207:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $207
801067ed:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801067f2:	e9 d0 f2 ff ff       	jmp    80105ac7 <alltraps>

801067f7 <vector208>:
.globl vector208
vector208:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $208
801067f9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801067fe:	e9 c4 f2 ff ff       	jmp    80105ac7 <alltraps>

80106803 <vector209>:
.globl vector209
vector209:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $209
80106805:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010680a:	e9 b8 f2 ff ff       	jmp    80105ac7 <alltraps>

8010680f <vector210>:
.globl vector210
vector210:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $210
80106811:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106816:	e9 ac f2 ff ff       	jmp    80105ac7 <alltraps>

8010681b <vector211>:
.globl vector211
vector211:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $211
8010681d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106822:	e9 a0 f2 ff ff       	jmp    80105ac7 <alltraps>

80106827 <vector212>:
.globl vector212
vector212:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $212
80106829:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010682e:	e9 94 f2 ff ff       	jmp    80105ac7 <alltraps>

80106833 <vector213>:
.globl vector213
vector213:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $213
80106835:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010683a:	e9 88 f2 ff ff       	jmp    80105ac7 <alltraps>

8010683f <vector214>:
.globl vector214
vector214:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $214
80106841:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106846:	e9 7c f2 ff ff       	jmp    80105ac7 <alltraps>

8010684b <vector215>:
.globl vector215
vector215:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $215
8010684d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106852:	e9 70 f2 ff ff       	jmp    80105ac7 <alltraps>

80106857 <vector216>:
.globl vector216
vector216:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $216
80106859:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010685e:	e9 64 f2 ff ff       	jmp    80105ac7 <alltraps>

80106863 <vector217>:
.globl vector217
vector217:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $217
80106865:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010686a:	e9 58 f2 ff ff       	jmp    80105ac7 <alltraps>

8010686f <vector218>:
.globl vector218
vector218:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $218
80106871:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106876:	e9 4c f2 ff ff       	jmp    80105ac7 <alltraps>

8010687b <vector219>:
.globl vector219
vector219:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $219
8010687d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106882:	e9 40 f2 ff ff       	jmp    80105ac7 <alltraps>

80106887 <vector220>:
.globl vector220
vector220:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $220
80106889:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010688e:	e9 34 f2 ff ff       	jmp    80105ac7 <alltraps>

80106893 <vector221>:
.globl vector221
vector221:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $221
80106895:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010689a:	e9 28 f2 ff ff       	jmp    80105ac7 <alltraps>

8010689f <vector222>:
.globl vector222
vector222:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $222
801068a1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801068a6:	e9 1c f2 ff ff       	jmp    80105ac7 <alltraps>

801068ab <vector223>:
.globl vector223
vector223:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $223
801068ad:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801068b2:	e9 10 f2 ff ff       	jmp    80105ac7 <alltraps>

801068b7 <vector224>:
.globl vector224
vector224:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $224
801068b9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801068be:	e9 04 f2 ff ff       	jmp    80105ac7 <alltraps>

801068c3 <vector225>:
.globl vector225
vector225:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $225
801068c5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801068ca:	e9 f8 f1 ff ff       	jmp    80105ac7 <alltraps>

801068cf <vector226>:
.globl vector226
vector226:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $226
801068d1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801068d6:	e9 ec f1 ff ff       	jmp    80105ac7 <alltraps>

801068db <vector227>:
.globl vector227
vector227:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $227
801068dd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801068e2:	e9 e0 f1 ff ff       	jmp    80105ac7 <alltraps>

801068e7 <vector228>:
.globl vector228
vector228:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $228
801068e9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801068ee:	e9 d4 f1 ff ff       	jmp    80105ac7 <alltraps>

801068f3 <vector229>:
.globl vector229
vector229:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $229
801068f5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801068fa:	e9 c8 f1 ff ff       	jmp    80105ac7 <alltraps>

801068ff <vector230>:
.globl vector230
vector230:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $230
80106901:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106906:	e9 bc f1 ff ff       	jmp    80105ac7 <alltraps>

8010690b <vector231>:
.globl vector231
vector231:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $231
8010690d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106912:	e9 b0 f1 ff ff       	jmp    80105ac7 <alltraps>

80106917 <vector232>:
.globl vector232
vector232:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $232
80106919:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010691e:	e9 a4 f1 ff ff       	jmp    80105ac7 <alltraps>

80106923 <vector233>:
.globl vector233
vector233:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $233
80106925:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010692a:	e9 98 f1 ff ff       	jmp    80105ac7 <alltraps>

8010692f <vector234>:
.globl vector234
vector234:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $234
80106931:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106936:	e9 8c f1 ff ff       	jmp    80105ac7 <alltraps>

8010693b <vector235>:
.globl vector235
vector235:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $235
8010693d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106942:	e9 80 f1 ff ff       	jmp    80105ac7 <alltraps>

80106947 <vector236>:
.globl vector236
vector236:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $236
80106949:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010694e:	e9 74 f1 ff ff       	jmp    80105ac7 <alltraps>

80106953 <vector237>:
.globl vector237
vector237:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $237
80106955:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010695a:	e9 68 f1 ff ff       	jmp    80105ac7 <alltraps>

8010695f <vector238>:
.globl vector238
vector238:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $238
80106961:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106966:	e9 5c f1 ff ff       	jmp    80105ac7 <alltraps>

8010696b <vector239>:
.globl vector239
vector239:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $239
8010696d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106972:	e9 50 f1 ff ff       	jmp    80105ac7 <alltraps>

80106977 <vector240>:
.globl vector240
vector240:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $240
80106979:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010697e:	e9 44 f1 ff ff       	jmp    80105ac7 <alltraps>

80106983 <vector241>:
.globl vector241
vector241:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $241
80106985:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010698a:	e9 38 f1 ff ff       	jmp    80105ac7 <alltraps>

8010698f <vector242>:
.globl vector242
vector242:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $242
80106991:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106996:	e9 2c f1 ff ff       	jmp    80105ac7 <alltraps>

8010699b <vector243>:
.globl vector243
vector243:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $243
8010699d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801069a2:	e9 20 f1 ff ff       	jmp    80105ac7 <alltraps>

801069a7 <vector244>:
.globl vector244
vector244:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $244
801069a9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801069ae:	e9 14 f1 ff ff       	jmp    80105ac7 <alltraps>

801069b3 <vector245>:
.globl vector245
vector245:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $245
801069b5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801069ba:	e9 08 f1 ff ff       	jmp    80105ac7 <alltraps>

801069bf <vector246>:
.globl vector246
vector246:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $246
801069c1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801069c6:	e9 fc f0 ff ff       	jmp    80105ac7 <alltraps>

801069cb <vector247>:
.globl vector247
vector247:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $247
801069cd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801069d2:	e9 f0 f0 ff ff       	jmp    80105ac7 <alltraps>

801069d7 <vector248>:
.globl vector248
vector248:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $248
801069d9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801069de:	e9 e4 f0 ff ff       	jmp    80105ac7 <alltraps>

801069e3 <vector249>:
.globl vector249
vector249:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $249
801069e5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801069ea:	e9 d8 f0 ff ff       	jmp    80105ac7 <alltraps>

801069ef <vector250>:
.globl vector250
vector250:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $250
801069f1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801069f6:	e9 cc f0 ff ff       	jmp    80105ac7 <alltraps>

801069fb <vector251>:
.globl vector251
vector251:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $251
801069fd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106a02:	e9 c0 f0 ff ff       	jmp    80105ac7 <alltraps>

80106a07 <vector252>:
.globl vector252
vector252:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $252
80106a09:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106a0e:	e9 b4 f0 ff ff       	jmp    80105ac7 <alltraps>

80106a13 <vector253>:
.globl vector253
vector253:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $253
80106a15:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106a1a:	e9 a8 f0 ff ff       	jmp    80105ac7 <alltraps>

80106a1f <vector254>:
.globl vector254
vector254:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $254
80106a21:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106a26:	e9 9c f0 ff ff       	jmp    80105ac7 <alltraps>

80106a2b <vector255>:
.globl vector255
vector255:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $255
80106a2d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106a32:	e9 90 f0 ff ff       	jmp    80105ac7 <alltraps>
80106a37:	66 90                	xchg   %ax,%ax
80106a39:	66 90                	xchg   %ax,%ax
80106a3b:	66 90                	xchg   %ax,%ax
80106a3d:	66 90                	xchg   %ax,%ax
80106a3f:	90                   	nop

80106a40 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	57                   	push   %edi
80106a44:	56                   	push   %esi
80106a45:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106a46:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106a4c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a52:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106a55:	39 d3                	cmp    %edx,%ebx
80106a57:	73 56                	jae    80106aaf <deallocuvm.part.0+0x6f>
80106a59:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106a5c:	89 c6                	mov    %eax,%esi
80106a5e:	89 d7                	mov    %edx,%edi
80106a60:	eb 12                	jmp    80106a74 <deallocuvm.part.0+0x34>
80106a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106a68:	83 c2 01             	add    $0x1,%edx
80106a6b:	89 d3                	mov    %edx,%ebx
80106a6d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106a70:	39 fb                	cmp    %edi,%ebx
80106a72:	73 38                	jae    80106aac <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80106a74:	89 da                	mov    %ebx,%edx
80106a76:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106a79:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106a7c:	a8 01                	test   $0x1,%al
80106a7e:	74 e8                	je     80106a68 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106a80:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106a87:	c1 e9 0a             	shr    $0xa,%ecx
80106a8a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106a90:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106a97:	85 c0                	test   %eax,%eax
80106a99:	74 cd                	je     80106a68 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80106a9b:	8b 10                	mov    (%eax),%edx
80106a9d:	f6 c2 01             	test   $0x1,%dl
80106aa0:	75 1e                	jne    80106ac0 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106aa2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106aa8:	39 fb                	cmp    %edi,%ebx
80106aaa:	72 c8                	jb     80106a74 <deallocuvm.part.0+0x34>
80106aac:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106aaf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ab2:	89 c8                	mov    %ecx,%eax
80106ab4:	5b                   	pop    %ebx
80106ab5:	5e                   	pop    %esi
80106ab6:	5f                   	pop    %edi
80106ab7:	5d                   	pop    %ebp
80106ab8:	c3                   	ret
80106ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106ac0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106ac6:	74 26                	je     80106aee <deallocuvm.part.0+0xae>
      kfree(v);
80106ac8:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106acb:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106ad1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106ad4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106ada:	52                   	push   %edx
80106adb:	e8 40 ba ff ff       	call   80102520 <kfree>
      *pte = 0;
80106ae0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106ae3:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106ae6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106aec:	eb 82                	jmp    80106a70 <deallocuvm.part.0+0x30>
        panic("kfree");
80106aee:	83 ec 0c             	sub    $0xc,%esp
80106af1:	68 66 78 10 80       	push   $0x80107866
80106af6:	e8 85 98 ff ff       	call   80100380 <panic>
80106afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106aff:	90                   	nop

80106b00 <mappages>:
{
80106b00:	55                   	push   %ebp
80106b01:	89 e5                	mov    %esp,%ebp
80106b03:	57                   	push   %edi
80106b04:	56                   	push   %esi
80106b05:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106b06:	89 d3                	mov    %edx,%ebx
80106b08:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106b0e:	83 ec 1c             	sub    $0x1c,%esp
80106b11:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b14:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106b18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b1d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b20:	8b 45 08             	mov    0x8(%ebp),%eax
80106b23:	29 d8                	sub    %ebx,%eax
80106b25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b28:	eb 3f                	jmp    80106b69 <mappages+0x69>
80106b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106b30:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106b37:	c1 ea 0a             	shr    $0xa,%edx
80106b3a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106b40:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b47:	85 c0                	test   %eax,%eax
80106b49:	74 75                	je     80106bc0 <mappages+0xc0>
    if(*pte & PTE_P)
80106b4b:	f6 00 01             	testb  $0x1,(%eax)
80106b4e:	0f 85 86 00 00 00    	jne    80106bda <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106b54:	0b 75 0c             	or     0xc(%ebp),%esi
80106b57:	83 ce 01             	or     $0x1,%esi
80106b5a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106b5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106b5f:	39 c3                	cmp    %eax,%ebx
80106b61:	74 6d                	je     80106bd0 <mappages+0xd0>
    a += PGSIZE;
80106b63:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106b69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106b6c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106b6f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106b72:	89 d8                	mov    %ebx,%eax
80106b74:	c1 e8 16             	shr    $0x16,%eax
80106b77:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106b7a:	8b 07                	mov    (%edi),%eax
80106b7c:	a8 01                	test   $0x1,%al
80106b7e:	75 b0                	jne    80106b30 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106b80:	e8 5b bb ff ff       	call   801026e0 <kalloc>
80106b85:	85 c0                	test   %eax,%eax
80106b87:	74 37                	je     80106bc0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106b89:	83 ec 04             	sub    $0x4,%esp
80106b8c:	68 00 10 00 00       	push   $0x1000
80106b91:	6a 00                	push   $0x0
80106b93:	50                   	push   %eax
80106b94:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106b97:	e8 a4 dc ff ff       	call   80104840 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b9c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106b9f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106ba2:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106ba8:	83 c8 07             	or     $0x7,%eax
80106bab:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106bad:	89 d8                	mov    %ebx,%eax
80106baf:	c1 e8 0a             	shr    $0xa,%eax
80106bb2:	25 fc 0f 00 00       	and    $0xffc,%eax
80106bb7:	01 d0                	add    %edx,%eax
80106bb9:	eb 90                	jmp    80106b4b <mappages+0x4b>
80106bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106bbf:	90                   	nop
}
80106bc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106bc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106bc8:	5b                   	pop    %ebx
80106bc9:	5e                   	pop    %esi
80106bca:	5f                   	pop    %edi
80106bcb:	5d                   	pop    %ebp
80106bcc:	c3                   	ret
80106bcd:	8d 76 00             	lea    0x0(%esi),%esi
80106bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106bd3:	31 c0                	xor    %eax,%eax
}
80106bd5:	5b                   	pop    %ebx
80106bd6:	5e                   	pop    %esi
80106bd7:	5f                   	pop    %edi
80106bd8:	5d                   	pop    %ebp
80106bd9:	c3                   	ret
      panic("remap");
80106bda:	83 ec 0c             	sub    $0xc,%esp
80106bdd:	68 d4 7e 10 80       	push   $0x80107ed4
80106be2:	e8 99 97 ff ff       	call   80100380 <panic>
80106be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bee:	66 90                	xchg   %ax,%ax

80106bf0 <seginit>:
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106bf6:	e8 05 ce ff ff       	call   80103a00 <cpuid>
  pd[0] = size-1;
80106bfb:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c00:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106c06:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106c0d:	ff 00 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c10:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106c17:	ff 00 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106c1a:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106c21:	ff 00 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c24:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106c2b:	ff 00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c2e:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106c35:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c38:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106c3f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106c42:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106c49:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c4c:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106c53:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106c56:	05 10 18 11 80       	add    $0x80111810,%eax
80106c5b:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106c5f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106c63:	c1 e8 10             	shr    $0x10,%eax
80106c66:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106c6a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106c6d:	0f 01 10             	lgdtl  (%eax)
}
80106c70:	c9                   	leave
80106c71:	c3                   	ret
80106c72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c80 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c80:	a1 24 49 11 80       	mov    0x80114924,%eax
80106c85:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c8a:	0f 22 d8             	mov    %eax,%cr3
}
80106c8d:	c3                   	ret
80106c8e:	66 90                	xchg   %ax,%ax

80106c90 <switchuvm>:
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	57                   	push   %edi
80106c94:	56                   	push   %esi
80106c95:	53                   	push   %ebx
80106c96:	83 ec 1c             	sub    $0x1c,%esp
80106c99:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106c9c:	85 f6                	test   %esi,%esi
80106c9e:	0f 84 cb 00 00 00    	je     80106d6f <switchuvm+0xdf>
  if(p->kstack == 0)
80106ca4:	8b 46 08             	mov    0x8(%esi),%eax
80106ca7:	85 c0                	test   %eax,%eax
80106ca9:	0f 84 da 00 00 00    	je     80106d89 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106caf:	8b 46 04             	mov    0x4(%esi),%eax
80106cb2:	85 c0                	test   %eax,%eax
80106cb4:	0f 84 c2 00 00 00    	je     80106d7c <switchuvm+0xec>
  pushcli();
80106cba:	e8 51 d9 ff ff       	call   80104610 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106cbf:	e8 dc cc ff ff       	call   801039a0 <mycpu>
80106cc4:	89 c3                	mov    %eax,%ebx
80106cc6:	e8 d5 cc ff ff       	call   801039a0 <mycpu>
80106ccb:	89 c7                	mov    %eax,%edi
80106ccd:	e8 ce cc ff ff       	call   801039a0 <mycpu>
80106cd2:	83 c7 08             	add    $0x8,%edi
80106cd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106cd8:	e8 c3 cc ff ff       	call   801039a0 <mycpu>
80106cdd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ce0:	ba 67 00 00 00       	mov    $0x67,%edx
80106ce5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106cec:	83 c0 08             	add    $0x8,%eax
80106cef:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106cf6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106cfb:	83 c1 08             	add    $0x8,%ecx
80106cfe:	c1 e8 18             	shr    $0x18,%eax
80106d01:	c1 e9 10             	shr    $0x10,%ecx
80106d04:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106d0a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106d10:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106d15:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d1c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106d21:	e8 7a cc ff ff       	call   801039a0 <mycpu>
80106d26:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d2d:	e8 6e cc ff ff       	call   801039a0 <mycpu>
80106d32:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106d36:	8b 5e 08             	mov    0x8(%esi),%ebx
80106d39:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d3f:	e8 5c cc ff ff       	call   801039a0 <mycpu>
80106d44:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d47:	e8 54 cc ff ff       	call   801039a0 <mycpu>
80106d4c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106d50:	b8 28 00 00 00       	mov    $0x28,%eax
80106d55:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106d58:	8b 46 04             	mov    0x4(%esi),%eax
80106d5b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d60:	0f 22 d8             	mov    %eax,%cr3
}
80106d63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d66:	5b                   	pop    %ebx
80106d67:	5e                   	pop    %esi
80106d68:	5f                   	pop    %edi
80106d69:	5d                   	pop    %ebp
  popcli();
80106d6a:	e9 f1 d8 ff ff       	jmp    80104660 <popcli>
    panic("switchuvm: no process");
80106d6f:	83 ec 0c             	sub    $0xc,%esp
80106d72:	68 da 7e 10 80       	push   $0x80107eda
80106d77:	e8 04 96 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106d7c:	83 ec 0c             	sub    $0xc,%esp
80106d7f:	68 05 7f 10 80       	push   $0x80107f05
80106d84:	e8 f7 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106d89:	83 ec 0c             	sub    $0xc,%esp
80106d8c:	68 f0 7e 10 80       	push   $0x80107ef0
80106d91:	e8 ea 95 ff ff       	call   80100380 <panic>
80106d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d9d:	8d 76 00             	lea    0x0(%esi),%esi

80106da0 <inituvm>:
{
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	57                   	push   %edi
80106da4:	56                   	push   %esi
80106da5:	53                   	push   %ebx
80106da6:	83 ec 1c             	sub    $0x1c,%esp
80106da9:	8b 45 08             	mov    0x8(%ebp),%eax
80106dac:	8b 75 10             	mov    0x10(%ebp),%esi
80106daf:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106db2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106db5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106dbb:	77 49                	ja     80106e06 <inituvm+0x66>
  mem = kalloc();
80106dbd:	e8 1e b9 ff ff       	call   801026e0 <kalloc>
  memset(mem, 0, PGSIZE);
80106dc2:	83 ec 04             	sub    $0x4,%esp
80106dc5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106dca:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106dcc:	6a 00                	push   $0x0
80106dce:	50                   	push   %eax
80106dcf:	e8 6c da ff ff       	call   80104840 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106dd4:	58                   	pop    %eax
80106dd5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ddb:	5a                   	pop    %edx
80106ddc:	6a 06                	push   $0x6
80106dde:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106de3:	31 d2                	xor    %edx,%edx
80106de5:	50                   	push   %eax
80106de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106de9:	e8 12 fd ff ff       	call   80106b00 <mappages>
  memmove(mem, init, sz);
80106dee:	89 75 10             	mov    %esi,0x10(%ebp)
80106df1:	83 c4 10             	add    $0x10,%esp
80106df4:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106df7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106dfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dfd:	5b                   	pop    %ebx
80106dfe:	5e                   	pop    %esi
80106dff:	5f                   	pop    %edi
80106e00:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106e01:	e9 ca da ff ff       	jmp    801048d0 <memmove>
    panic("inituvm: more than a page");
80106e06:	83 ec 0c             	sub    $0xc,%esp
80106e09:	68 19 7f 10 80       	push   $0x80107f19
80106e0e:	e8 6d 95 ff ff       	call   80100380 <panic>
80106e13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e20 <loaduvm>:
{
80106e20:	55                   	push   %ebp
80106e21:	89 e5                	mov    %esp,%ebp
80106e23:	57                   	push   %edi
80106e24:	56                   	push   %esi
80106e25:	53                   	push   %ebx
80106e26:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106e29:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80106e2c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80106e2f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106e35:	0f 85 a2 00 00 00    	jne    80106edd <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80106e3b:	85 ff                	test   %edi,%edi
80106e3d:	74 7d                	je     80106ebc <loaduvm+0x9c>
80106e3f:	90                   	nop
  pde = &pgdir[PDX(va)];
80106e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106e43:	8b 55 08             	mov    0x8(%ebp),%edx
80106e46:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80106e48:	89 c1                	mov    %eax,%ecx
80106e4a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106e4d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80106e50:	f6 c1 01             	test   $0x1,%cl
80106e53:	75 13                	jne    80106e68 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80106e55:	83 ec 0c             	sub    $0xc,%esp
80106e58:	68 33 7f 10 80       	push   $0x80107f33
80106e5d:	e8 1e 95 ff ff       	call   80100380 <panic>
80106e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106e68:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e6b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106e71:	25 fc 0f 00 00       	and    $0xffc,%eax
80106e76:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106e7d:	85 c9                	test   %ecx,%ecx
80106e7f:	74 d4                	je     80106e55 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80106e81:	89 fb                	mov    %edi,%ebx
80106e83:	b8 00 10 00 00       	mov    $0x1000,%eax
80106e88:	29 f3                	sub    %esi,%ebx
80106e8a:	39 c3                	cmp    %eax,%ebx
80106e8c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e8f:	53                   	push   %ebx
80106e90:	8b 45 14             	mov    0x14(%ebp),%eax
80106e93:	01 f0                	add    %esi,%eax
80106e95:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80106e96:	8b 01                	mov    (%ecx),%eax
80106e98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e9d:	05 00 00 00 80       	add    $0x80000000,%eax
80106ea2:	50                   	push   %eax
80106ea3:	ff 75 10             	push   0x10(%ebp)
80106ea6:	e8 35 ac ff ff       	call   80101ae0 <readi>
80106eab:	83 c4 10             	add    $0x10,%esp
80106eae:	39 d8                	cmp    %ebx,%eax
80106eb0:	75 1e                	jne    80106ed0 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80106eb2:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106eb8:	39 fe                	cmp    %edi,%esi
80106eba:	72 84                	jb     80106e40 <loaduvm+0x20>
}
80106ebc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ebf:	31 c0                	xor    %eax,%eax
}
80106ec1:	5b                   	pop    %ebx
80106ec2:	5e                   	pop    %esi
80106ec3:	5f                   	pop    %edi
80106ec4:	5d                   	pop    %ebp
80106ec5:	c3                   	ret
80106ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ecd:	8d 76 00             	lea    0x0(%esi),%esi
80106ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ed3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ed8:	5b                   	pop    %ebx
80106ed9:	5e                   	pop    %esi
80106eda:	5f                   	pop    %edi
80106edb:	5d                   	pop    %ebp
80106edc:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80106edd:	83 ec 0c             	sub    $0xc,%esp
80106ee0:	68 d4 7f 10 80       	push   $0x80107fd4
80106ee5:	e8 96 94 ff ff       	call   80100380 <panic>
80106eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ef0 <allocuvm>:
{
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	57                   	push   %edi
80106ef4:	56                   	push   %esi
80106ef5:	53                   	push   %ebx
80106ef6:	83 ec 1c             	sub    $0x1c,%esp
80106ef9:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80106efc:	85 f6                	test   %esi,%esi
80106efe:	0f 88 98 00 00 00    	js     80106f9c <allocuvm+0xac>
80106f04:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80106f06:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106f09:	0f 82 a1 00 00 00    	jb     80106fb0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106f0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f12:	05 ff 0f 00 00       	add    $0xfff,%eax
80106f17:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f1c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80106f1e:	39 f0                	cmp    %esi,%eax
80106f20:	0f 83 8d 00 00 00    	jae    80106fb3 <allocuvm+0xc3>
80106f26:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106f29:	eb 44                	jmp    80106f6f <allocuvm+0x7f>
80106f2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f2f:	90                   	nop
    memset(mem, 0, PGSIZE);
80106f30:	83 ec 04             	sub    $0x4,%esp
80106f33:	68 00 10 00 00       	push   $0x1000
80106f38:	6a 00                	push   $0x0
80106f3a:	50                   	push   %eax
80106f3b:	e8 00 d9 ff ff       	call   80104840 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106f40:	58                   	pop    %eax
80106f41:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f47:	5a                   	pop    %edx
80106f48:	6a 06                	push   $0x6
80106f4a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f4f:	89 fa                	mov    %edi,%edx
80106f51:	50                   	push   %eax
80106f52:	8b 45 08             	mov    0x8(%ebp),%eax
80106f55:	e8 a6 fb ff ff       	call   80106b00 <mappages>
80106f5a:	83 c4 10             	add    $0x10,%esp
80106f5d:	85 c0                	test   %eax,%eax
80106f5f:	78 5f                	js     80106fc0 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80106f61:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106f67:	39 f7                	cmp    %esi,%edi
80106f69:	0f 83 89 00 00 00    	jae    80106ff8 <allocuvm+0x108>
    mem = kalloc();
80106f6f:	e8 6c b7 ff ff       	call   801026e0 <kalloc>
80106f74:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106f76:	85 c0                	test   %eax,%eax
80106f78:	75 b6                	jne    80106f30 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106f7a:	83 ec 0c             	sub    $0xc,%esp
80106f7d:	68 51 7f 10 80       	push   $0x80107f51
80106f82:	e8 29 97 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106f87:	83 c4 10             	add    $0x10,%esp
80106f8a:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106f8d:	74 0d                	je     80106f9c <allocuvm+0xac>
80106f8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f92:	8b 45 08             	mov    0x8(%ebp),%eax
80106f95:	89 f2                	mov    %esi,%edx
80106f97:	e8 a4 fa ff ff       	call   80106a40 <deallocuvm.part.0>
    return 0;
80106f9c:	31 d2                	xor    %edx,%edx
}
80106f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fa1:	89 d0                	mov    %edx,%eax
80106fa3:	5b                   	pop    %ebx
80106fa4:	5e                   	pop    %esi
80106fa5:	5f                   	pop    %edi
80106fa6:	5d                   	pop    %ebp
80106fa7:	c3                   	ret
80106fa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106faf:	90                   	nop
    return oldsz;
80106fb0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80106fb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fb6:	89 d0                	mov    %edx,%eax
80106fb8:	5b                   	pop    %ebx
80106fb9:	5e                   	pop    %esi
80106fba:	5f                   	pop    %edi
80106fbb:	5d                   	pop    %ebp
80106fbc:	c3                   	ret
80106fbd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106fc0:	83 ec 0c             	sub    $0xc,%esp
80106fc3:	68 69 7f 10 80       	push   $0x80107f69
80106fc8:	e8 e3 96 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106fcd:	83 c4 10             	add    $0x10,%esp
80106fd0:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106fd3:	74 0d                	je     80106fe2 <allocuvm+0xf2>
80106fd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106fd8:	8b 45 08             	mov    0x8(%ebp),%eax
80106fdb:	89 f2                	mov    %esi,%edx
80106fdd:	e8 5e fa ff ff       	call   80106a40 <deallocuvm.part.0>
      kfree(mem);
80106fe2:	83 ec 0c             	sub    $0xc,%esp
80106fe5:	53                   	push   %ebx
80106fe6:	e8 35 b5 ff ff       	call   80102520 <kfree>
      return 0;
80106feb:	83 c4 10             	add    $0x10,%esp
    return 0;
80106fee:	31 d2                	xor    %edx,%edx
80106ff0:	eb ac                	jmp    80106f9e <allocuvm+0xae>
80106ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ff8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80106ffb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ffe:	5b                   	pop    %ebx
80106fff:	5e                   	pop    %esi
80107000:	89 d0                	mov    %edx,%eax
80107002:	5f                   	pop    %edi
80107003:	5d                   	pop    %ebp
80107004:	c3                   	ret
80107005:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010700c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107010 <deallocuvm>:
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	8b 55 0c             	mov    0xc(%ebp),%edx
80107016:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107019:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010701c:	39 d1                	cmp    %edx,%ecx
8010701e:	73 10                	jae    80107030 <deallocuvm+0x20>
}
80107020:	5d                   	pop    %ebp
80107021:	e9 1a fa ff ff       	jmp    80106a40 <deallocuvm.part.0>
80107026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010702d:	8d 76 00             	lea    0x0(%esi),%esi
80107030:	89 d0                	mov    %edx,%eax
80107032:	5d                   	pop    %ebp
80107033:	c3                   	ret
80107034:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010703b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010703f:	90                   	nop

80107040 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	57                   	push   %edi
80107044:	56                   	push   %esi
80107045:	53                   	push   %ebx
80107046:	83 ec 0c             	sub    $0xc,%esp
80107049:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010704c:	85 f6                	test   %esi,%esi
8010704e:	74 59                	je     801070a9 <freevm+0x69>
  if(newsz >= oldsz)
80107050:	31 c9                	xor    %ecx,%ecx
80107052:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107057:	89 f0                	mov    %esi,%eax
80107059:	89 f3                	mov    %esi,%ebx
8010705b:	e8 e0 f9 ff ff       	call   80106a40 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107060:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107066:	eb 0f                	jmp    80107077 <freevm+0x37>
80107068:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010706f:	90                   	nop
80107070:	83 c3 04             	add    $0x4,%ebx
80107073:	39 fb                	cmp    %edi,%ebx
80107075:	74 23                	je     8010709a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107077:	8b 03                	mov    (%ebx),%eax
80107079:	a8 01                	test   $0x1,%al
8010707b:	74 f3                	je     80107070 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010707d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107082:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107085:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107088:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010708d:	50                   	push   %eax
8010708e:	e8 8d b4 ff ff       	call   80102520 <kfree>
80107093:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107096:	39 fb                	cmp    %edi,%ebx
80107098:	75 dd                	jne    80107077 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010709a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010709d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070a0:	5b                   	pop    %ebx
801070a1:	5e                   	pop    %esi
801070a2:	5f                   	pop    %edi
801070a3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801070a4:	e9 77 b4 ff ff       	jmp    80102520 <kfree>
    panic("freevm: no pgdir");
801070a9:	83 ec 0c             	sub    $0xc,%esp
801070ac:	68 85 7f 10 80       	push   $0x80107f85
801070b1:	e8 ca 92 ff ff       	call   80100380 <panic>
801070b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070bd:	8d 76 00             	lea    0x0(%esi),%esi

801070c0 <setupkvm>:
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	56                   	push   %esi
801070c4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801070c5:	e8 16 b6 ff ff       	call   801026e0 <kalloc>
801070ca:	85 c0                	test   %eax,%eax
801070cc:	74 5e                	je     8010712c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
801070ce:	83 ec 04             	sub    $0x4,%esp
801070d1:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801070d3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
801070d8:	68 00 10 00 00       	push   $0x1000
801070dd:	6a 00                	push   $0x0
801070df:	50                   	push   %eax
801070e0:	e8 5b d7 ff ff       	call   80104840 <memset>
801070e5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801070e8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801070eb:	83 ec 08             	sub    $0x8,%esp
801070ee:	8b 4b 08             	mov    0x8(%ebx),%ecx
801070f1:	8b 13                	mov    (%ebx),%edx
801070f3:	ff 73 0c             	push   0xc(%ebx)
801070f6:	50                   	push   %eax
801070f7:	29 c1                	sub    %eax,%ecx
801070f9:	89 f0                	mov    %esi,%eax
801070fb:	e8 00 fa ff ff       	call   80106b00 <mappages>
80107100:	83 c4 10             	add    $0x10,%esp
80107103:	85 c0                	test   %eax,%eax
80107105:	78 19                	js     80107120 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107107:	83 c3 10             	add    $0x10,%ebx
8010710a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107110:	75 d6                	jne    801070e8 <setupkvm+0x28>
}
80107112:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107115:	89 f0                	mov    %esi,%eax
80107117:	5b                   	pop    %ebx
80107118:	5e                   	pop    %esi
80107119:	5d                   	pop    %ebp
8010711a:	c3                   	ret
8010711b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010711f:	90                   	nop
      freevm(pgdir);
80107120:	83 ec 0c             	sub    $0xc,%esp
80107123:	56                   	push   %esi
80107124:	e8 17 ff ff ff       	call   80107040 <freevm>
      return 0;
80107129:	83 c4 10             	add    $0x10,%esp
}
8010712c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010712f:	31 f6                	xor    %esi,%esi
}
80107131:	89 f0                	mov    %esi,%eax
80107133:	5b                   	pop    %ebx
80107134:	5e                   	pop    %esi
80107135:	5d                   	pop    %ebp
80107136:	c3                   	ret
80107137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010713e:	66 90                	xchg   %ax,%ax

80107140 <kvmalloc>:
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107146:	e8 75 ff ff ff       	call   801070c0 <setupkvm>
8010714b:	a3 24 49 11 80       	mov    %eax,0x80114924
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107150:	05 00 00 00 80       	add    $0x80000000,%eax
80107155:	0f 22 d8             	mov    %eax,%cr3
}
80107158:	c9                   	leave
80107159:	c3                   	ret
8010715a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107160 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	83 ec 08             	sub    $0x8,%esp
80107166:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107169:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010716c:	89 c1                	mov    %eax,%ecx
8010716e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107171:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107174:	f6 c2 01             	test   $0x1,%dl
80107177:	75 17                	jne    80107190 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107179:	83 ec 0c             	sub    $0xc,%esp
8010717c:	68 96 7f 10 80       	push   $0x80107f96
80107181:	e8 fa 91 ff ff       	call   80100380 <panic>
80107186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010718d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107190:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107193:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107199:	25 fc 0f 00 00       	and    $0xffc,%eax
8010719e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801071a5:	85 c0                	test   %eax,%eax
801071a7:	74 d0                	je     80107179 <clearpteu+0x19>
  *pte &= ~PTE_U;
801071a9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801071ac:	c9                   	leave
801071ad:	c3                   	ret
801071ae:	66 90                	xchg   %ax,%ax

801071b0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	56                   	push   %esi
801071b5:	53                   	push   %ebx
801071b6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801071b9:	e8 02 ff ff ff       	call   801070c0 <setupkvm>
801071be:	89 45 e0             	mov    %eax,-0x20(%ebp)
801071c1:	85 c0                	test   %eax,%eax
801071c3:	0f 84 e9 00 00 00    	je     801072b2 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801071c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801071cc:	85 c9                	test   %ecx,%ecx
801071ce:	0f 84 b2 00 00 00    	je     80107286 <copyuvm+0xd6>
801071d4:	31 f6                	xor    %esi,%esi
801071d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071dd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801071e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801071e3:	89 f0                	mov    %esi,%eax
801071e5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801071e8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801071eb:	a8 01                	test   $0x1,%al
801071ed:	75 11                	jne    80107200 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801071ef:	83 ec 0c             	sub    $0xc,%esp
801071f2:	68 a0 7f 10 80       	push   $0x80107fa0
801071f7:	e8 84 91 ff ff       	call   80100380 <panic>
801071fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107200:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107202:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107207:	c1 ea 0a             	shr    $0xa,%edx
8010720a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107210:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107217:	85 c0                	test   %eax,%eax
80107219:	74 d4                	je     801071ef <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010721b:	8b 00                	mov    (%eax),%eax
8010721d:	a8 01                	test   $0x1,%al
8010721f:	0f 84 9f 00 00 00    	je     801072c4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107225:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107227:	25 ff 0f 00 00       	and    $0xfff,%eax
8010722c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010722f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107235:	e8 a6 b4 ff ff       	call   801026e0 <kalloc>
8010723a:	89 c3                	mov    %eax,%ebx
8010723c:	85 c0                	test   %eax,%eax
8010723e:	74 64                	je     801072a4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107240:	83 ec 04             	sub    $0x4,%esp
80107243:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107249:	68 00 10 00 00       	push   $0x1000
8010724e:	57                   	push   %edi
8010724f:	50                   	push   %eax
80107250:	e8 7b d6 ff ff       	call   801048d0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107255:	58                   	pop    %eax
80107256:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010725c:	5a                   	pop    %edx
8010725d:	ff 75 e4             	push   -0x1c(%ebp)
80107260:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107265:	89 f2                	mov    %esi,%edx
80107267:	50                   	push   %eax
80107268:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010726b:	e8 90 f8 ff ff       	call   80106b00 <mappages>
80107270:	83 c4 10             	add    $0x10,%esp
80107273:	85 c0                	test   %eax,%eax
80107275:	78 21                	js     80107298 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107277:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010727d:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107280:	0f 82 5a ff ff ff    	jb     801071e0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107286:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107289:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010728c:	5b                   	pop    %ebx
8010728d:	5e                   	pop    %esi
8010728e:	5f                   	pop    %edi
8010728f:	5d                   	pop    %ebp
80107290:	c3                   	ret
80107291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107298:	83 ec 0c             	sub    $0xc,%esp
8010729b:	53                   	push   %ebx
8010729c:	e8 7f b2 ff ff       	call   80102520 <kfree>
      goto bad;
801072a1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801072a4:	83 ec 0c             	sub    $0xc,%esp
801072a7:	ff 75 e0             	push   -0x20(%ebp)
801072aa:	e8 91 fd ff ff       	call   80107040 <freevm>
  return 0;
801072af:	83 c4 10             	add    $0x10,%esp
    return 0;
801072b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801072b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072bf:	5b                   	pop    %ebx
801072c0:	5e                   	pop    %esi
801072c1:	5f                   	pop    %edi
801072c2:	5d                   	pop    %ebp
801072c3:	c3                   	ret
      panic("copyuvm: page not present");
801072c4:	83 ec 0c             	sub    $0xc,%esp
801072c7:	68 ba 7f 10 80       	push   $0x80107fba
801072cc:	e8 af 90 ff ff       	call   80100380 <panic>
801072d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072df:	90                   	nop

801072e0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801072e6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801072e9:	89 c1                	mov    %eax,%ecx
801072eb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801072ee:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801072f1:	f6 c2 01             	test   $0x1,%dl
801072f4:	0f 84 00 01 00 00    	je     801073fa <uva2ka.cold>
  return &pgtab[PTX(va)];
801072fa:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072fd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107303:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107304:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107309:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107310:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107312:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107317:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010731a:	05 00 00 00 80       	add    $0x80000000,%eax
8010731f:	83 fa 05             	cmp    $0x5,%edx
80107322:	ba 00 00 00 00       	mov    $0x0,%edx
80107327:	0f 45 c2             	cmovne %edx,%eax
}
8010732a:	c3                   	ret
8010732b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010732f:	90                   	nop

80107330 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	57                   	push   %edi
80107334:	56                   	push   %esi
80107335:	53                   	push   %ebx
80107336:	83 ec 0c             	sub    $0xc,%esp
80107339:	8b 75 14             	mov    0x14(%ebp),%esi
8010733c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010733f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107342:	85 f6                	test   %esi,%esi
80107344:	75 51                	jne    80107397 <copyout+0x67>
80107346:	e9 a5 00 00 00       	jmp    801073f0 <copyout+0xc0>
8010734b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010734f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107350:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107356:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010735c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107362:	74 75                	je     801073d9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107364:	89 fb                	mov    %edi,%ebx
80107366:	29 c3                	sub    %eax,%ebx
80107368:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010736e:	39 f3                	cmp    %esi,%ebx
80107370:	0f 47 de             	cmova  %esi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107373:	29 f8                	sub    %edi,%eax
80107375:	83 ec 04             	sub    $0x4,%esp
80107378:	01 c1                	add    %eax,%ecx
8010737a:	53                   	push   %ebx
8010737b:	52                   	push   %edx
8010737c:	89 55 10             	mov    %edx,0x10(%ebp)
8010737f:	51                   	push   %ecx
80107380:	e8 4b d5 ff ff       	call   801048d0 <memmove>
    len -= n;
    buf += n;
80107385:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107388:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010738e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107391:	01 da                	add    %ebx,%edx
  while(len > 0){
80107393:	29 de                	sub    %ebx,%esi
80107395:	74 59                	je     801073f0 <copyout+0xc0>
  if(*pde & PTE_P){
80107397:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010739a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010739c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010739e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801073a1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801073a7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801073aa:	f6 c1 01             	test   $0x1,%cl
801073ad:	0f 84 4e 00 00 00    	je     80107401 <copyout.cold>
  return &pgtab[PTX(va)];
801073b3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073b5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801073bb:	c1 eb 0c             	shr    $0xc,%ebx
801073be:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801073c4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801073cb:	89 d9                	mov    %ebx,%ecx
801073cd:	83 e1 05             	and    $0x5,%ecx
801073d0:	83 f9 05             	cmp    $0x5,%ecx
801073d3:	0f 84 77 ff ff ff    	je     80107350 <copyout+0x20>
  }
  return 0;
}
801073d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801073dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073e1:	5b                   	pop    %ebx
801073e2:	5e                   	pop    %esi
801073e3:	5f                   	pop    %edi
801073e4:	5d                   	pop    %ebp
801073e5:	c3                   	ret
801073e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ed:	8d 76 00             	lea    0x0(%esi),%esi
801073f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801073f3:	31 c0                	xor    %eax,%eax
}
801073f5:	5b                   	pop    %ebx
801073f6:	5e                   	pop    %esi
801073f7:	5f                   	pop    %edi
801073f8:	5d                   	pop    %ebp
801073f9:	c3                   	ret

801073fa <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801073fa:	a1 00 00 00 00       	mov    0x0,%eax
801073ff:	0f 0b                	ud2

80107401 <copyout.cold>:
80107401:	a1 00 00 00 00       	mov    0x0,%eax
80107406:	0f 0b                	ud2
80107408:	66 90                	xchg   %ax,%ax
8010740a:	66 90                	xchg   %ax,%ax
8010740c:	66 90                	xchg   %ax,%ax
8010740e:	66 90                	xchg   %ax,%ax

80107410 <sgenrand>:

/* initializing the array with a NONZERO seed */
void
sgenrand(seed)
    unsigned long seed;	
{
80107410:	55                   	push   %ebp
80107411:	b8 44 49 11 80       	mov    $0x80114944,%eax
80107416:	89 e5                	mov    %esp,%ebp
80107418:	8b 55 08             	mov    0x8(%ebp),%edx
    /* setting initial seeds to mt[N] using         */
    /* the generator Line 25 of Table 1 in          */
    /* [KNUTH 1981, The Art of Computer Programming */
    /*    Vol. 2 (2nd Ed.), pp102]                  */
    mt[0]= seed & 0xffffffff;
8010741b:	89 15 40 49 11 80    	mov    %edx,0x80114940
    for (mti=1; mti<N; mti++)
80107421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
80107428:	69 d2 cd 0d 01 00    	imul   $0x10dcd,%edx,%edx
    for (mti=1; mti<N; mti++)
8010742e:	83 c0 04             	add    $0x4,%eax
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
80107431:	89 50 fc             	mov    %edx,-0x4(%eax)
    for (mti=1; mti<N; mti++)
80107434:	3d 00 53 11 80       	cmp    $0x80115300,%eax
80107439:	75 ed                	jne    80107428 <sgenrand+0x18>
8010743b:	c7 05 60 a4 10 80 70 	movl   $0x270,0x8010a460
80107442:	02 00 00 
}
80107445:	5d                   	pop    %ebp
80107446:	c3                   	ret
80107447:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010744e:	66 90                	xchg   %ax,%ax

80107450 <genrand>:

long
genrand()
{
80107450:	55                   	push   %ebp
80107451:	89 e5                	mov    %esp,%ebp
80107453:	53                   	push   %ebx
    unsigned long y;
    static unsigned long mag01[2]={0x0, MATRIX_A};
    /* mag01[x] = x * MATRIX_A  for x=0,1 */

    if (mti >= N) { /* generate N words at one time */
80107454:	a1 60 a4 10 80       	mov    0x8010a460,%eax
80107459:	3d 6f 02 00 00       	cmp    $0x26f,%eax
8010745e:	7f 41                	jg     801074a1 <genrand+0x51>
        mt[N-1] = mt[M-1] ^ (y >> 1) ^ mag01[y & 0x1];

        mti = 0;
    }
  
    y = mt[mti++];
80107460:	8b 0c 85 40 49 11 80 	mov    -0x7feeb6c0(,%eax,4),%ecx
80107467:	8d 50 01             	lea    0x1(%eax),%edx
8010746a:	89 15 60 a4 10 80    	mov    %edx,0x8010a460
    y ^= TEMPERING_SHIFT_U(y);
80107470:	89 ca                	mov    %ecx,%edx
    y ^= TEMPERING_SHIFT_S(y) & TEMPERING_MASK_B;
    y ^= TEMPERING_SHIFT_T(y) & TEMPERING_MASK_C;
    y ^= TEMPERING_SHIFT_L(y);

    return y & RAND_MAX; /* for long  generation */
}
80107472:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107475:	c9                   	leave
    y ^= TEMPERING_SHIFT_U(y);
80107476:	c1 ea 0b             	shr    $0xb,%edx
80107479:	31 ca                	xor    %ecx,%edx
    y ^= TEMPERING_SHIFT_S(y) & TEMPERING_MASK_B;
8010747b:	89 d0                	mov    %edx,%eax
8010747d:	c1 e0 07             	shl    $0x7,%eax
80107480:	25 80 56 2c 9d       	and    $0x9d2c5680,%eax
80107485:	31 d0                	xor    %edx,%eax
    y ^= TEMPERING_SHIFT_T(y) & TEMPERING_MASK_C;
80107487:	89 c2                	mov    %eax,%edx
80107489:	c1 e2 0f             	shl    $0xf,%edx
8010748c:	81 e2 00 00 c6 ef    	and    $0xefc60000,%edx
80107492:	31 c2                	xor    %eax,%edx
    y ^= TEMPERING_SHIFT_L(y);
80107494:	89 d0                	mov    %edx,%eax
80107496:	c1 e8 12             	shr    $0x12,%eax
80107499:	31 d0                	xor    %edx,%eax
    return y & RAND_MAX; /* for long  generation */
8010749b:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
801074a0:	c3                   	ret
        if (mti == N+1)   /* if sgenrand() has not been called, */
801074a1:	3d 71 02 00 00       	cmp    $0x271,%eax
801074a6:	0f 84 d1 00 00 00    	je     8010757d <genrand+0x12d>
801074ac:	8b 0d 40 49 11 80    	mov    0x80114940,%ecx
    mt[0]= seed & 0xffffffff;
801074b2:	31 c0                	xor    %eax,%eax
801074b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
801074b8:	83 c0 01             	add    $0x1,%eax
801074bb:	81 e1 00 00 00 80    	and    $0x80000000,%ecx
801074c1:	89 cb                	mov    %ecx,%ebx
801074c3:	8b 0c 85 40 49 11 80 	mov    -0x7feeb6c0(,%eax,4),%ecx
801074ca:	89 ca                	mov    %ecx,%edx
801074cc:	81 e2 ff ff ff 7f    	and    $0x7fffffff,%edx
801074d2:	09 da                	or     %ebx,%edx
            mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1];
801074d4:	89 d3                	mov    %edx,%ebx
801074d6:	83 e2 01             	and    $0x1,%edx
801074d9:	d1 eb                	shr    %ebx
801074db:	33 1c 85 70 4f 11 80 	xor    -0x7feeb090(,%eax,4),%ebx
801074e2:	33 1c 95 f8 7f 10 80 	xor    -0x7fef8008(,%edx,4),%ebx
801074e9:	89 1c 85 3c 49 11 80 	mov    %ebx,-0x7feeb6c4(,%eax,4)
        for (kk=0;kk<N-M;kk++) {
801074f0:	3d e3 00 00 00       	cmp    $0xe3,%eax
801074f5:	75 c1                	jne    801074b8 <genrand+0x68>
801074f7:	8b 0d cc 4c 11 80    	mov    0x80114ccc,%ecx
801074fd:	8d 76 00             	lea    0x0(%esi),%esi
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
80107500:	83 c0 01             	add    $0x1,%eax
80107503:	81 e1 00 00 00 80    	and    $0x80000000,%ecx
80107509:	89 cb                	mov    %ecx,%ebx
8010750b:	8b 0c 85 40 49 11 80 	mov    -0x7feeb6c0(,%eax,4),%ecx
80107512:	89 ca                	mov    %ecx,%edx
80107514:	81 e2 ff ff ff 7f    	and    $0x7fffffff,%edx
8010751a:	09 da                	or     %ebx,%edx
            mt[kk] = mt[kk+(M-N)] ^ (y >> 1) ^ mag01[y & 0x1];
8010751c:	89 d3                	mov    %edx,%ebx
8010751e:	83 e2 01             	and    $0x1,%edx
80107521:	d1 eb                	shr    %ebx
80107523:	33 1c 85 b0 45 11 80 	xor    -0x7feeba50(,%eax,4),%ebx
8010752a:	33 1c 95 f8 7f 10 80 	xor    -0x7fef8008(,%edx,4),%ebx
80107531:	89 1c 85 3c 49 11 80 	mov    %ebx,-0x7feeb6c4(,%eax,4)
        for (;kk<N-1;kk++) {
80107538:	3d 6f 02 00 00       	cmp    $0x26f,%eax
8010753d:	75 c1                	jne    80107500 <genrand+0xb0>
        y = (mt[N-1]&UPPER_MASK)|(mt[0]&LOWER_MASK);
8010753f:	8b 0d 40 49 11 80    	mov    0x80114940,%ecx
80107545:	a1 fc 52 11 80       	mov    0x801152fc,%eax
8010754a:	89 ca                	mov    %ecx,%edx
8010754c:	25 00 00 00 80       	and    $0x80000000,%eax
80107551:	81 e2 ff ff ff 7f    	and    $0x7fffffff,%edx
80107557:	09 d0                	or     %edx,%eax
        mt[N-1] = mt[M-1] ^ (y >> 1) ^ mag01[y & 0x1];
80107559:	89 c2                	mov    %eax,%edx
8010755b:	83 e0 01             	and    $0x1,%eax
8010755e:	d1 ea                	shr    %edx
80107560:	33 15 70 4f 11 80    	xor    0x80114f70,%edx
80107566:	33 14 85 f8 7f 10 80 	xor    -0x7fef8008(,%eax,4),%edx
8010756d:	89 15 fc 52 11 80    	mov    %edx,0x801152fc
80107573:	ba 01 00 00 00       	mov    $0x1,%edx
80107578:	e9 ed fe ff ff       	jmp    8010746a <genrand+0x1a>
    mt[0]= seed & 0xffffffff;
8010757d:	b8 44 49 11 80       	mov    $0x80114944,%eax
80107582:	b9 00 53 11 80       	mov    $0x80115300,%ecx
80107587:	ba 05 11 00 00       	mov    $0x1105,%edx
8010758c:	c7 05 40 49 11 80 05 	movl   $0x1105,0x80114940
80107593:	11 00 00 
    for (mti=1; mti<N; mti++)
80107596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010759d:	8d 76 00             	lea    0x0(%esi),%esi
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
801075a0:	69 d2 cd 0d 01 00    	imul   $0x10dcd,%edx,%edx
    for (mti=1; mti<N; mti++)
801075a6:	83 c0 04             	add    $0x4,%eax
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
801075a9:	89 50 fc             	mov    %edx,-0x4(%eax)
    for (mti=1; mti<N; mti++)
801075ac:	39 c1                	cmp    %eax,%ecx
801075ae:	75 f0                	jne    801075a0 <genrand+0x150>
801075b0:	e9 f7 fe ff ff       	jmp    801074ac <genrand+0x5c>
801075b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801075c0 <random_at_most>:

// Assumes 1 <= max <= RAND_MAX
// Returns in the half-open interval [1, max]
long random_at_most(long max) {
801075c0:	55                   	push   %ebp
  unsigned long
    // max <= RAND_MAX < ULONG_MAX, so this is okay.
    num_bins = (unsigned long) max + 1,
    num_rand = (unsigned long) RAND_MAX + 1,
    bin_size = num_rand / num_bins,
801075c1:	31 d2                	xor    %edx,%edx
long random_at_most(long max) {
801075c3:	89 e5                	mov    %esp,%ebp
801075c5:	56                   	push   %esi
801075c6:	53                   	push   %ebx
    num_bins = (unsigned long) max + 1,
801075c7:	8b 45 08             	mov    0x8(%ebp),%eax
    bin_size = num_rand / num_bins,
801075ca:	bb 00 00 00 80       	mov    $0x80000000,%ebx
    num_bins = (unsigned long) max + 1,
801075cf:	8d 48 01             	lea    0x1(%eax),%ecx
    bin_size = num_rand / num_bins,
801075d2:	89 d8                	mov    %ebx,%eax
801075d4:	f7 f1                	div    %ecx
801075d6:	89 c6                	mov    %eax,%esi
  long x;
  do {
   x = genrand();
  }
  // This is carefully written not to overflow
  while (num_rand - defect <= (unsigned long)x);
801075d8:	29 d3                	sub    %edx,%ebx
801075da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
   x = genrand();
801075e0:	e8 6b fe ff ff       	call   80107450 <genrand>
801075e5:	89 c1                	mov    %eax,%ecx
  while (num_rand - defect <= (unsigned long)x);
801075e7:	39 d8                	cmp    %ebx,%eax
801075e9:	73 f5                	jae    801075e0 <random_at_most+0x20>

  long ret = x/bin_size;
801075eb:	31 d2                	xor    %edx,%edx
  if (!ret)
      ret++;

  // Truncated division is intentional
  return ret;
}
801075ed:	5b                   	pop    %ebx
  long ret = x/bin_size;
801075ee:	f7 f6                	div    %esi
      ret++;
801075f0:	39 f1                	cmp    %esi,%ecx
}
801075f2:	5e                   	pop    %esi
801075f3:	5d                   	pop    %ebp
      ret++;
801075f4:	83 d0 00             	adc    $0x0,%eax
}
801075f7:	c3                   	ret
