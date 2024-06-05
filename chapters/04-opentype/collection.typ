#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## Font Collections
== 字体集

// In OpenType, each instance of a font's family lives in its own file. So Robert Slimbach's Minion Pro family - available in two widths, four weights, four optical sizes, and roman and italic styles - ships as $$ 2 * 4 * 4 * 2 = 64 $$ separate `.otf` files. In many cases, some of the information contained in the font will be the same in each file - the character maps, the ligature and other substitution features, and so on.
在 OpenType 中，字体家族中的每一个字体实例都分别储存在独立的文件中。比如由 Robert Slimbach 制作的，拥有两种宽度、四个字重、四个大小、罗马体和意大利体两种样式的 Minbion Pro 字体家族，就被分成了共计 $2*4*4*2 = 64$ 个`otf`文件。在大多数情况下，这些字体文件中的某些信息会是相同的，比如#tr[character]映射表、#tr[ligature]和其他#tr[character]#tr[substitution]特性等。

// Font collections provide a way of both sharing this common information and packaging families more conveniently to the user. Originally called TrueType Collections, a font collection is a single file (with the extension `.ttc`) containing multiple fonts. Each font within the collection has its own Offset Table, and this naturally allows it to share tables. For instance, a collection might share a `GSUB` table between family members; in this case, the `GSUB` entry in each member's Offset Table would point to the same location in the file.
源自TrueType的字体集则是一种便于相同信息共享和字体家族打包的储存方式。字体集使用单个文件（后缀名为`ttc`）来储存多个字体。每个字体有自己的偏移量表，这样就天然的支持了数据表的共享。比如，只需将所有字体偏移量表中的`GSUB`条目指向文件中的同一位置，就可以让字体家族成员都使用同一个`GSUB`表。

// A collection is, then, a bunch of TrueType fonts all welded together, with a header on top telling you where to locate the Offset Table of each font. Here's the start of Helvetica Neue:
字体集中的TrueType字体连续储存，在整个文件的开始处则又有一个偏移量表，来指明每个字体的位置。如下是 Helvetica Neue 字体集的起始数据：

```
00000000: 7474 6366 0002 0000 0000 000b 0000 0044  ttcf...........D
00000010: 0000 0170 0000 029c 0000 03c8 0000 04f4  ...p............
```

// `ttcf` tells us that this is a TrueType collection, then the next four bytes tell us this is using version 2.0 of the TTC file format. After that we get the number of fonts in the collection (`0x0000000b` = 11), followed by 11 offsets: the Offset Table of the first font starts at byte 0x44 of this file, the next at 0x170, and so on.
`ttcf`文件头告诉我们这是一个TrueType字体集文件，接下来的四个字节表示这是TTC文件格式的2.0版。之后的 `0x0000000b = 11` 则是集合中的字体数量，再后面 11 个字节就是这些字体在文件中的位置。比如这里显示第一个字体在`0x44`，第二个在`0x170`等。
