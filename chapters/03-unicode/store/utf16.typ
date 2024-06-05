#import "/template/template.typ": web-page-template
#import "/template/components.typ": note
#import "/template/lang.typ": thai

#import "/lib/glossary.typ": tr

#show: web-page-template

// ### UTF-16
=== UTF-16

// UTF-32 is a very simple and transparent encoding - four bytes is one character, always, and one character is always four bytes - so it's often used as a way of processing Unicode data inside of a program. Data is read in, in whatever character encoding it happens to be, and is silently converted to UTF-32 so that it can be processed efficiently. The program does what it needs to do with it, and then re-encodes it when it's time to write the data out again. Many programming languages already allow you to read and write numbers that are four bytes long, so representing Unicode code points as numbers isn't a problem. (A "wide character", in languages such as C or Python, is a 32-bit wide data type, ideal for processing UTF-32 data.) But UTF-32 is not very efficient. The first byte is always going to be zero, and the top seven bits of the second byte are always going to be zero too. So UTF-32 is not often used as an on-disk storage format: we don't like the idea of spending nearly 50% of our disk space on bytes that are guaranteed to be empty.
UTF-32是一种非常简明的#tr[encoding]，它永远用四个字节描述一个#tr[character]。这一特点让它经常用于程序的内部流程。一个程序的输入可能使用各种#tr[encoding]，但在处理前将其转换为UTF-32可以使后续流程更加方便高效。在完成处理后，再根据需求将结果转换成需要的#tr[encoding]输出。许多编程语言都允许直接读写内存中的四字节数字，所以直接将Unicode#tr[codepoint]作为#tr[encoding]并没有什么问题。（在C和Python等语言中，这种处理Unicode的32比特类型也被称作宽字符。）但是UTF-32在空间上并不高效，因为第一个字节永远是0，而且第二个字节的前7个比特也永远是0。所以UTF-32不太会作为磁盘存储格式，毕竟我们不希望为了存这些0而浪费近50%的空间。

// So can we find a compromise where we use fewer bytes but still represent the majority of characters we're likely to use, in a relatively straightforward way? UTF-16 uses a group of 16 bits (2 bytes) instead of 32, on the basis that the first two bytes of UTF-32 are almost always unused. UTF-16 simply drops those upper two bytes, and instead uses two bytes to represent the Unicode characters from 0 to 65535, the characters within the Basic Multilingual Plane. This worked fine for the majority of characters that people were likely to use. (At least, before emoji inflicted themselves upon the world.) If you want to encode the Thai letter *to pa-tak* (ฏ) which lives at code point 3599 in the Unicode standard, we write 3599 in binary: `0000111000001111` and get two bytes `0E 0F`, and that's the UTF-16 encoding.
我们能找到一种使用更少的字节，但依旧能表达需要使用的大多数#tr[character]，而且规则相对简单的#tr[encoding]吗？UTF-16可能是一个选择。基于UTF-32的前两个字节基本全是0这一情况，UTF-16选择只使用16个比特（2个字节）为一组。UTF-16基本上就是抛弃了前两个字节，用剩下的两个来表示Unicode里0到65535这一范围——也就是前文说的#tr[BMP]——中的#tr[character]。这对于大多数人日常使用的#tr[character]来说已经足够了。（至少在emoji入侵这个世界之前是够的。）使用这一方式，如果我们希望#tr[encoding]泰文字母 `to pa-tak`（#thai[\u{0E0F}]），因为它在Unicode标准中的#tr[codepoint]是3599，我们只需要将3599转换成二进制得到`0000111000001111`，再将它写成`0E 0F`两个字节，这就是UTF-16的#tr[encoding]结果了。

#note[
  // > From now on, we'll represent Unicode codepoints in the standard way: the prefix `U+` to signify a Unicode codepoint, and then the codepoint in hexadecimal. So *to pa-tak* is U+0E0F.
  从现在开始，我们会使用一种标准格式来表示Unicode#tr[codepoint]：前缀 `U+` 表示这是一个Unicode#tr[codepoint]，其后写上#tr[codepoint]数字的十六进制形式。比如`to pa-tak`写作 `U+0E0F`。
]

// But what if, as in the case of FATHER CHRISTMAS, we want to access code points above 65535? Converting it into binary gives us a number which is three bytes long, and we want to represent all our characters within two bytes.
但如果我们需要表示码位超过65535的#tr[character]，比如之前的圣诞老人emoji，该怎么办呢？将它的#tr[codepoint]转换成二进制之后需要三个字节才能放下，但是我们只希望使用两个字节。

// This is where the compromise comes in: to make it easy and efficient to represent characters in the BMP, UTF-16 gives up the ability to easily and efficiently represent characters outside that plane. Instead, it uses a mechanism called *surrogate pairs* to encode a character from the supplementary planes. A surrogate pair is a 2-byte sequence that looks like it ought to be a valid Unicode character, but is actually from a reserved range which represents a move to another plane. So  UTF-16 uses 16 bits for a character inside the BMP, but two 16 bit sequences for those outside; in other words, UTF-16 is *generally* a fixed-width encoding, but in certain circumstances a character can be either two or four bytes.
这就是我们妥协的地方了。为了让#tr[BMP]中的#tr[character]能够简单高效的表示，UTF-16牺牲了表示此平面之外的#tr[character]的效率和简洁性。它使用一种叫做#tr[surrogate pair]的机制来#tr[encoding]其他补充平面的#tr[character]。#tr[surrogate pair]是一个二字节序列，它看上去像是有效的Unicode#tr[character]，但其实它位于一段被预留的区间，用于表示在其他平面上的位置移动。所以UTF-16使用16个比特表示BMP中的#tr[character]，但对于其他字符则需要两个16比特才能表示。也就是说，UTF-16*通常来说*可以当作是定宽#tr[encoding]的。但在特定情况下，一个字符可能是用两个或四个字节表示。

// Surrogate pairs work like this:
#tr[surrogate pair]的工作原理如下：

// * First, subtract `0x010000` from the code point you want to encode. Now you have a 20 bit number.
- 首先，将你想#tr[encoding]的#tr[codepoint]减去`0x010000`，会得到一个可以用20比特表示的数字。
// Split the 20 bit number into two 10 bit numbers. Add `0xD800` to the first, to give a number in the range `0xD800..0xDBFF`. Add `0xDC00` to the second, to give a number in the range `0xDC00..0xDFFF`. These are your two 16-bit code blocks.
- 将这个20比特的数分成两个10比特的数。#linebreak()给第一个数加上`0xD800`，得到的数在`0xD800...0xDBFF`范围内。#linebreak()给第二个数加上`0xDC00`，得到的数在`0xDC00...0xDFFF`范围内。#linebreak()这就是最终的两个16比特的数据块。

// So for FATHER CHRISTMAS, we start with U+1F385.
还是以圣诞老人为例，#tr[codepoint]是`U+1F385`：

/*
* Take away `0x010000` to get `F385`, or `00001111001110000101`.

* Split this into `0000111100 1110000101` or `03C 385`.

* `0xD800` + `0x03C` = `D83C`

* `0xDC00` + `0x385` = `DF85`.
*/
- 减去`0x010000`之后我们得到`F385`，也就是`00001111001110000101`。
- 将它分成`0000111100 1110000101`，十六进制写作`03C 385`。
- `0xD800` + `0x03C` = `D83C`。
- `0xDC00` + `0x385` = `DF85`。

//So FATHER CHRISTMAS in UTF-16 is `D8 3C DF 85`.
所以圣诞老人的UTF-16#tr[encoding]是`D8 3C DF 85`。

#note[
  // > Because most characters in use are in the BMP, and because the surrogate pairs *could* be interpreted as Unicode code points, some software may not bother to interpret surrogate pair processing. The good news is that emoji characters all live in the supplemental plane, which has forced programmers to become more aware of the issue...
  因为大多数#tr[character]都在BMP内，而且#tr[surrogate pair]也*可以*被当作Unicode#tr[codepoint]来*理解*，所以有些软件会不对#tr[surrogate pair]进行额外的解析处理。好消息是因为emoji都位于补充平面上，这让程序开发者不得不重视起这一问题来……
]
