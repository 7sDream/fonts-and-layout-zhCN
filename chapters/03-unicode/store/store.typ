#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## How data is stored
== 数据如何储存

// When computers store data in eight-bit bytes, representing numbers from 0 to 255, and your character set contains fewer than 255 characters, everything is easy. A character fits within a byte, so each byte in a file represents one character. One number maps to one letter, and you're done.
我们已经知道，计算机使用包含8个比特的字节来储存数据，每个字节可以表示数字0到255。如果我们的#tr[character set]中的#tr[character]数量小于255的话，事情就变得很简单：只需要每个字节储存相应#tr[character]所对应的数字即可。

// But when your character set has a potential 1,112,064 code points, you need a strategy for how you're going to store those code points in bytes of eight bits. This strategy is called a *character encoding*, and the Unicode Standard defines three of them: UTF-8, UTF-16 and UTF-32. (UTF stands for *Unicode Transformation Format*, because you're transforming code points into bytes and vice versa.)
但当这个字符集有1112064个#tr[codepoint]时，把它们储存成字节序列就需要一些策略了。我们将决定如何把#tr[character set]储存为字节序列的策略称为*#tr[character]#tr[encoding]*。Unicode 标准中定义了三种字符#tr[encoding]：UTF-8、UTF-16和UTF-32。这里UTF表示Unicode转换格式（Unicode Transformation Format），顾名思义，它就是用于Unicode#tr[codepoint]和字节序列之间的互相转换的。

#note[
  // > There are a number of other character encodings in use, which are not part of the Standard, such as UTF-7, UTF-EBCDIC and the Chinese Unicode encoding GB18030. If you need them, you'll know about it.
  在Unicode标准之外还有很多其他的#tr[character]#tr[encoding]，比如 UTF-7、UTF-EBCDIC和中国国标中定义的基于Unicode的#tr[encoding] GB18030。这些#tr[encoding]可以随着实践按需了解。
]

// The names of the character encodings reflect the number of bits used in encoding. It's easiest to start with UTF-32: if you take a group of 32 bits, you have $$ 2^{32} = 4,294,967,296 $$ possible states, which is more than sufficient to represent every character that's ever likely to be in Unicode. Every character is represented as a group of 32 bits, stretched across four 8-bit bytes. To encode a code point in UTF-32, just turn it into binary, pad it out to four bytes, and you're done.
这些#tr[character]#tr[encoding]名称中的数字反映了它们使用多少比特进行#tr[encoding]。最简单的是 UTF-32：如果你按32个比特为一组，则一共有 $2^32=42,9496,7294$ 种不同的状态，这完全足以表示 Unicode 中的所有#tr[character]了。按这种方法，每个#tr[character]使用32个比特，也就是4个字节。具体来说，转换时把每个字符对应的#tr[codepoint]数字转换成二进制，然后用0填满不足32比特的剩余位置即可。

// For example, the character 🎅 (FATHER CHRISTMAS) lives in Finland, just inside the Arctic circle, and in the Unicode Standard, at codepoint 127877. In binary, this is 11111001110001111, which we can encode in four bytes using UTF-32 as follows:
据说圣诞老人住在芬兰的一个临近北极圈的地方，但 #box(image("/fonts/father-christmas.svg", alt: emoji.santa.man, height: 1em), baseline: 0.1em) 作为一个#tr[character]，它位于Unicode中的127877#tr[codepoint]上。按照 UTF-32的方法，先把127877转换为二进制`11111001110001111`，再将它#tr[encoding]成四个字节，结果如下：

#let utf-32-example-table = c => {
  let codepoint = str.to-unicode(c.text)
  let bs = (0, 0, 0, 0)
  while codepoint != 0 {
    bs.insert(4, calc.rem(codepoint, 256))
    codepoint = int(codepoint / 256)
  }
  bs = bs.slice(-4)
  let binary = bs.map(it => if it == 0 {
    ""
  } else {
    str(it, base: 2)
  })
  let padded = binary.map(it => "0" * (8 - it.len()) + it)
  let hex = bs.map(it => str(it, base: 16)).map(it => "0" * (2 - it.len()) + it)
  let decimal = bs.map(str)

  table(
    columns: 5,
    align: (start, end, end, end, end),
    [二进制],
    ..binary.map(raw),
    [前补0],
    ..padded.map(raw),
    [十六进制],
    ..hex.map(raw),
    [十进制],
    ..decimal.map(raw),
  )
}

#align(center)[#utf-32-example-table[🎅]]

#note[
  // > Hexadecimal is a number system which is often used in computer work: whereas decimal "rolls over" to the second place after each 9 (8, 9, 10, 11), hexadecimal counts up to fifteen before rolling over (8, 9, A, B, C, D, E, F, 10, 11). This means that two hexadecimal digits can encode numbers from 00 to FF (or 0 to 255 in decimal), which is precisely the same range as one byte.
  十六进制是在计算机语境中常用的一种数字进制：我们日常用的十进制逢十进一（8、9、10、11），十六进制同理，会逢十六进一（8、9、A、B、C、D、E、F、10、11）。两位的十六进制数可以从00数到FF（按十进制就是0到255），正好和一个字节的数字范围一致。
]

#note[
  // > There's only one slight complication: whether the bytes should appear in the order `00 01 F3 85` or in reverse order `85 F3 01 00`. By default, UTF-32 stores data "big-end first" (`00 01 F3 85`) but some systems prefer to put the "little-end" first. They let you know that they're doing this by encoding a special character (ZERO WIDTH NO BREAKING SPACE) at the start of the file. How this character is encoded tells you how the rest of the file is laid out: if you see `00 00 FE FF` at the start of the file, we're big-endian, and if the file starts `FF FE 00 00`, we're little-endian. When ZWNBS is used in this way, it's called a BOM (Byte Order Mark) and is not interpreted as the first character of a document.
  还有最后一个略显复杂的步骤：我们需要决定这四个字节是按`00 01 F3 85`还是按`85 F3 01 00`的顺序出现。默认情况下，UTF-32按照大端序（`00 01 F3 85`）储存数据，但也有些系统会偏好使用小端序。为了区分这两种顺序，这些系统会在文件的起始位置添加一个特殊的零宽不折行空格（`ZERO WIDTH NO BREAKING SPACE`）#tr[character]。这个字符如何被#tr[encoding]就表示了后续文件使用何种顺序：如果你在文件开头看到`00 00 FE FF`，就表示后续文件内容使用大端序；同理，`FF FE 00 00`就表示小端序。当这个特殊的字符用于提示储存顺序时，我们把它叫做字节顺序标记（Byte Order Mark，BOM），此时它就不被视为文档内容的首个#tr[character]了。
]
