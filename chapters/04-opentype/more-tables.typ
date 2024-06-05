#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## And more tables!
== 更多数据表

// We've looked at all of the compulsory tables in an OpenType font; there are many other tables which can also be present. There are tables which handle vertical typesetting, and tables which allow you to position the baseline at different places for different scripts; tables which give hints on how to justify lines, or resize mathematical symbols; tables which help with hinting, and tables which contain bitmaps, vector graphics, and color font information. For more on how these tables work, it's best to read the [OpenType specification itself](https://docs.microsoft.com/en-us/typography/opentype/spec/).
我们介绍完了OpenType中所有必须的数据表，但实际应用中还可能会出现其他表。按用途分可能有：用于竖排文本；为不同的文种调整基线位置；提供关于如何对齐线条和缩放数学符号的信息；辅助提供#tr[hinting]；使用#tr[bitmap]或矢量图形表示#tr[glyph]；彩色字体等。关于这些数据表的工作方式，最好直接阅读OpenType规范@Microsoft.OpenTypeSpecification。

// In fact, why stop there? There's nothing to stop you defining your own table structure and adding it to your font; the font is just a database. If you want to add a `SHKS` table which contains the complete works of Shakespeare, you can do that; software which doesn't recognise the table will simply ignore it, so it'll still be a perfectly valid font. (Yes, I have tried this.) TTX will even happily dump it out for you, even if it doesn't know how to interpret it. The Graphite font rendering software, developed by SIL, uses this method to embed advanced features inside the fonts, such as automatic collision avoidance and word kerning (character kerning across a space boundary), in custom Graphite-specific tables.
我们也不用拘泥于这些已经定义好的数据表格式。事实上OpenType并不限制在字体中使用自创的数据表结构，毕竟字体就是一个数据库。即使你想在字体中加入一个叫`SHKS`的表用于存放莎士比亚的所有作品也是可以的。虽然无法识别这个表的用途的应用软件会将它忽略，但它仍然会是一个有效的字体文件（我真的试过这么做）。而 TTX 工具即使不知道如何解读，也会照常将表中的数据导出。由 SIL 开发的 Graphite 字体渲染软件就使用这种自定义数据表的方式向字体中嵌入了更多高级特性，比如自动避让和词偶距（在单词之间的空格处生效的#tr[kern]）等。

// Finally, there is one more table which we haven't mentioned, but without which nothing would work: the very first table in the font, called the Offset Table, tells the system which tables are contained in the font file and where they are located within the file. If we were to look at our dummy OpenType font file in a hex editor, we would see some familiar names at the start of the file:
最后，我还想介绍一个非常重要的，甚至没有它的话字体就无法正常工作的数据表。它位于文件的开头，叫做偏移量表。它告诉系统字体文件中到底包含哪些数据表，以及每张表在文件中的位置。如果我们使用十六进制编辑器直接打开字体文件，在开头的部分就会看见很多熟悉的名字：

```
00000000: 4f54 544f 000a 0080 0003 0020 4346 4620  OTTO....... CFF
00000010: 400e 39a4 0000 043c 0000 01de 4753 5542  @.9....<....GSUB
00000020: 0001 0000 0000 061c 0000 000a 4f53 2f32  ............OS/2
00000030: 683d 6762 0000 0110 0000 0060 636d 6170  h=gb.......`cmap
00000040: 0017 0132 0000 03d0 0000 004a 6865 6164  ...2.......Jhead
00000050: 0975 3eb0 0000 00ac 0000 0036 6868 6561  .u>........6hhea
00000060: 062f 01a9 0000 00e4 0000 0024 686d 7478  ./.........$hmtx
00000070: 06a2 00ba 0000 0628 0000 000c 6d61 7870  .......(....maxp
```

// `OTTO` is a magic string to tell us this is an OpenType font. Then there is a few bytes of bookkeeping information, followed by the name of each table, a checksum of its content, its offset within the file, and its length. So here we see that the `CFF ` table lives at offset `0x0000043c` (or byte 1084) and stretches for `0x000001de` (478) bytes long.
`OTTO`是代表OpenType字体的魔术字。在几个表示字体信息的字节之后就是数据表偏移量记录。每项记录由表名、表数据的校验和、在文件中的位置以及数据长度组成。比如上面的数据显示，`CFF` 表位于 `0x0000043c`（也就是第1084个字节）的位置，长度为`0x000001de`（478）个字节。
