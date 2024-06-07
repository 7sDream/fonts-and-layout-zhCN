#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ### UTF-8
=== UTF-8

// But UTF-16 still uses *two whole bytes* for every ASCII and Western European Latin character, which sadly are the only characters that any programmers actually care about. So of course, that would never do.
但UTF-16依然会使用*整整两个字节*来表示所有的ASCII和西欧拉丁#tr[character]。没错，在这些几乎是程序处理中最常用和关心的#tr[character]上浪费空间是绝对不行的。

// UTF-8 takes the trade-off introduced by UTF-16 a little further: characters in the ASCII set are represented as single bytes, just as they were originally in ASCII, while code points above 127 are represented using a variable number of bytes: codepoints from `0x80` to `0x7FF` are two bytes, from `0x800` to `0xffff` are three bytes, and higher characters are four bytes.
UTF-8将UTF-16做出的妥协和权衡向前更进了一步：ASCII#tr[character]只使用一个字节表示，就像原本的ASCII码表一样。超过127的#tr[codepoint]使用可变数量的字节表示：`0x80`到`0x7FF`使用两个字节，`0x800`到`0xFFFF`用三个字节，更大的用四个字节。

// The conversion is best done by an existing computer program or library - you shouldn't have to do UTF-8 encoding by hand - but for reference, this is what you do. First, work out how many bytes the encoding is going to need, based on the Unicode code point. Then, convert the code point to binary, split it up and insert it into the pattern below, and pad with leading zeros:
你不需要手动进行UTF-8#tr[encoding]，这个过程最好使用现成的程序或库来处理。不过为了提供参考，我们也简单介绍一下。首先，基于你想#tr[encoding]的#tr[character]的#tr[codepoint]，根据上述的范围决定一共需要几个字节。然后将#tr[codepoint]转换为二进制并分为几段，插入下面的模板中（记得补0）：

#align(
  center,
  table(
    columns: 5,
    align: (right,) + (center,) * 4,
    [#tr[codepoint]],
    [第一字节],
    [第二字节],
    [第三字节],
    [第四字节],
    [`0x00-0x7F`],
    [`0xxxxxxx`],
    [],
    [],
    [],
    [`0x80-0x7FF`],
    [`110xxxxx`],
    [`10xxxxxx`],
    [],
    [],
    [`0x800-0xFFFF`],
    [`1110xxxx`],
    [`10xxxxxx`],
    [`10xxxxxx`],
    [],
    [`0x10000-0x10FFFF`],
    [`11110xxx`],
    [`10xxxxxx`],
    [`10xxxxxx`],
    [`10xxxxxx`],
  ),
)

// > Originally UTF-8 allowed sequences up to seven bytes long to encode characters all the way up to `0x7FFFFFFF`, but this was restricted when UTF-8 became an Internet standard to match the range of UTF-16. Once we need to encode more than a million characters in Unicode, UTF-8 will be insufficient. However, we are still some way away from that situation.
#note[
  最初的UTF-8允许用最长7个字节的序列来#tr[encoding]直到`0x7FFFFFFF`的#tr[character]，但这一点在UTF-8成为互联网标准时，为了和UTF-16的范围保持一致而被限制了。一旦我们在Unicode中容纳的#tr[character]超过百万个之后，UTF-8就不能胜任了。但还好，这一情况离我们还比较远。
]

// FATHER CHRISTMAS is going to take four bytes, because he is above `0x10000`. The binary representation of his codepoint U+1F385 is `11111001110000101`, so, inserting his bits into the pattern from the right, we get:
圣诞老人#tr[character]用UTF-8#tr[encoding]需要四个字节，因为它比`0x10000`大。其#tr[codepoint]`U+1F385`的二进制表示为`11111001110000101`。将这些比特（从右往左）插入上述模板，我们得到：

#align(
  center,
  table(
    columns: 5,
    align: (right,) + (center,) * 4,
    [`0x10000-0x10FFFF`],
    [`11110xxx`],
    [`10x`*`11111`*],
    [`10`*`001110`*],
    [`10`*`000101`*],
  ),
)

最后，将未填充的`x`补上0，得到：

#align(
  center,
  table(
    columns: 4,
    align: center,
    [`11110`*`000`*],
    [`10`*`011111`*],
    [`10`*`001110`*],
    [`10`*`000101`*],
    [`F0`],
    [`9F`],
    [`8E`],
    [`85`],
  ),
)

// UTF-8 is not a bad trade-off. It's variable width, which means more work to process, but the benefit of that is efficiency - characters don't take up any more bytes than they need to. And the processing work is mitigated by the fact that the initial byte signals how long the byte sequence is. The leading bytes of the sequence also provide an unambiguous synchronisation point for processing software - if you don't recognise where you are inside a byte stream, just back up a maximum of four characters until you see a byte starting `0`, `110`, `1110` or `11110` and go from there.
UTF-8所做的权衡其实并不差。它是变宽的，这也就意味着处理它更麻烦。但好处是它的空间利用非常高效：#tr[character]实际使用的字节数永远不会比它实际需要的更多。设计中的一个小巧思也减轻了处理负担，那就是从首个字节中就能知道这个字节序列有多长。而且首字节的这种特性也提供了软件处理过程中所需的清晰的同步位置。比如当程序不知道目前所处的是序列中的第几个字节时，它只需要简单的往后看最多四个字节，只要发现某个字节由`0`、`110`、`1110`或`11110`开头，就能够从这里继续往下处理了。

// Because of this, UTF-8 has become the *de facto* encoding standard of the Internet, with around 90% of web pages using it. If you have data that you're going to be shaping with an OpenType shaping engine, it's most likely going to begin in UTF-8 before being transformed to UTF-32 internally.
由于上述原因，UTF-8成为了互联网上文本#tr[encoding]的*事实标准*，大约90%的网页都使用它。如果你的数据需要被OpenType#tr[shaping]引擎处理的话，很可能它需要是UTF-8#tr[encoding]的，引擎的内部流程会将它转化为UTF-32处理。
