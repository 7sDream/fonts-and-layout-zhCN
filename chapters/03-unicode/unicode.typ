#import "/template/consts.typ"
#import "/template/util.typ"
#import "/template/heading.typ": chapter
#import "/template/components.typ": note
#import "/template/font.typ": sil-pua
#import "/template/lang.typ": french, russian, greek, thai, mandingo, german

#import "/lib/glossary.typ": tr

#chapter[
  // The Unicode Standard
  Unicode 标准
]

// When humans exchange information, we use sentences, words, and - most relevantly for our purposes - letters. But computers don't know anything about letters. Computers only know about numbers, and to be honest, they don't know much about them, either. Because computers are, ultimately, great big collections of electronic switches, they only know about two numbers: zero, if a switch is off, and one, when a switch is on.
人类使用语句、单词和（与本书最相关的）字母来传递信息。但计算机不认识字母，它只认识数字。而且说句实话，它对数字其实也不是特别懂。因为实际上计算机是由大量电动开关堆砌而成，而开关只和两个数字相关：0代表开关断开，1代表开关接通。

// By lining up a row of switches, we can represent bigger numbers. These days, computers normally line up eight switches in a unit, called a *byte*. With eight switches and two states for each switch, we have $$ 2^8 = 256 $$ possible states in a byte, so we can represent a number between 0 and 255. But still, everything is a number.
通过将一个个开关连接成电路，它们能够表示更大的数字。目前，计算机通常会把八个这样的开关作为一个单元，称为一个*字节*。因为这八个开关每个都能有两种状态，一个字节共有 $2^8=256$ 种可能的状态，所以可以用来表示从0到255的数字。但无论多大，计算机中还是只有数字。

// To move from numbers to letters and store text in a computer, we need to agree on a code. We might decide that when we're expecting text, the number 1 means "a", number 2 means "b" and so on. This mapping between numbers and characters is called an *encoding*.
为了让计算机能用数字储存文本，我们需要一个被共同承认的码表。比如可以这样规定：每当我们需要文本的时候，数字1就代表a，数字2代表b，以此类推。这就在数字和#tr[character]之间建立了一个映射，我们称这种映射为*#tr[encoding]*。

// In the earliest days of computers, every manufacturer had their own particular encoding, but they soon realised that data written on one system would not be able to be read on another. There was a need for computer and telecommunications manufacturers to standardize their encodings. One of the earliest and most common encodings was ASCII, the American Standard Code for Information Interchange. First standardized in 1963, this system uses seven of the eight bits (switches) in a byte, giving an available range of $$ 2^7 = 128 $$ characters.
在计算机发展的早期，每个制造商都构造了自己的#tr[encoding]。但很快他们就意识到，这样的话某个系统上的信息无法被其他系统正确读取。计算机和通信行业的制造商们需要一个标准化的#tr[encoding]。最早的公共#tr[encoding]是在1963年被标准化的ASCII（American Standard Code for Information Interchange，美国标准信息交换码）。它使用7个比特（也就是上文说的开关），一共可以表达 $2^7=128$ 个#tr[character]。

// In ASCII, the numbers from 0 to 31 are used to encode "control characters". These do not represent printable information, but give instructions to the devices which use ASCII: start a new line, delete the previous character, start transmission, stop transmission and so on. 32 is a space, and the numbers from 33 to 64 are used to represent a range of non-alphabetic symbols, including the numerals 0 to 9. The numbers from 65 to 127 encode the 26 lower case and 26 upper case letters of the English alphabet, with some more non-alphabetic symbols squeezed in the gap.
在 ASCII 中，从0到31的数字用来#tr[encoding]“控制字符”。他们并不能显示出来，而是用于给使用 ASCII 的设备提供一些控制指令。比如开始新的一行、删除上一个字符、开始或停止信息传输等等。数字32表示空格。从33到64是一系列非字母的符号，其中包括数字0到9。从65到127则#tr[encoding]了英文的26个小写字母和26个大写字母，大小写字母之间填充了一些其他的非字母符号。

// But ASCII was, as its name implies, an *American* standard, and for most of the world, 26 lower case and 26 upper case letters is - to use something of a British understatement - not going to be enough. When Europeans needed to exchange data including accented characters, or Russians needed to write files in Cyrillic, or Greeks in Greek, the ASCII standard did not allow them to do so. But on the other hand, ASCII only used seven bits out of the byte, encoding the numbers from 0 to 127. And a byte can store any number from 0 to 255, leaving 127 free code points up for grabs.
但顾名思义，ASCII码是一个*美国*标准。对于世界上的其他地方，26个小写和大写字母——即使使用英国式轻描淡写的说法——是远远不够的。当欧洲人需要在字母上加上音调时，当俄罗斯人需要编写带有西里尔字母的文件时，当希腊人想用希腊字母时，ASCII码严词拒绝了他们。但另一方面，ASCII码只使用了一个字节中的七个比特，也就是数字0到127。但一个字节可以储存0到255的数字，于是这剩下的127个空位开始被各家争抢。

// The problem, of course, is that 127 code points was not enough for the West Europeans and the Russians and the Greeks to *all* encode all of the characters that they needed. And so, as in the days of the Judges, all the people did whatever seemed right in their own eyes; every national language group developed their own encoding, jamming whatever characters that they needed into the upper half of the ASCII table. Suddenly, all of the interchange problems that ASCII was meant to solve reappeared. Someone in France might send a message asking for a *tête-à-tête*, but his Russian colleague would be left wondering what a *tЙte-Ю-tЙte* might be. But wait! It was worse than that: a Greek PC user might greet someone with a cheery Καλημέρα, but if his friend *happened to be using a Mac*, he would find himself being wished an ακγλίώα instead.
显然 127 个空位不足放下西欧、俄罗斯、希腊等等国家所需要的所有#tr[character]。接下来，就像士师时期那样，所有人都在做他们眼中正确的事。通过将自己需要的#tr[character]放到ASCII码表的空余高位部分，每种自然语言的使用群体都创造了他们自己的#tr[encoding]。突然之间，ASCII试图解决的跨系统信息交互问题又重现了。如果一个法国人将写有#french[tête-à-tête]的信息发给他的俄罗斯同事，这位同事会看着显示的#russian[tЙte-Ю-tЙte]而感到迷惑。但等等，还有可能更糟呢！一个希腊文的PC用户可能会用#greek[Καλημέρα]愉快地向其他人打招呼，但如果他的朋友恰好使用的是Mac的话，他收到的会是#greek[ακγλίώα]。

// And then the Japanese showed up.
日文也来添乱了。

// To write Japanese you need 100 syllabic characters and anything between 2,000 and 100,000 Chinese ideographs. Suddenly 127 free code points seems like a drop in the ocean. There are a number of ways that you can solve this problem, and different Japanese computer manufacturers tried all of them. The Shift JIS encoding used two bytes (16 bits, so $$ 2^{16} = 65536 $$ different states) to represent each character; EUC-JP used a variable number of bytes, with the first byte telling you how many bytes in a character; ISO-2022-JP used magic "escape sequences" of characters to jump between ASCII and JIS. Files didn't always tell you what encoding they were using, and so it was a very common experience in Japan to open up a text file and be greeted with a screen full of mis-encoded gibberish. (The Japanese for "mis-encoded gibberish" is *mojibake*.)
为了书写日文，你需要大约100个音节#tr[character]，2000到100000个表意#tr[character]。突然一下，127个空位就变得像是沧海一粟了。有很多方法可以解决这个问题，日本的计算机制造商把它们尝试了个遍。Shift JIS#tr[encoding]使用两个字节（16个比特，共有 $2^16 = 65536$ 种状态）来表示所有#tr[character]；EUC-JP #tr[encoding]则使用可变数量的字节，其中第一个字节用于提示这个#tr[character]一共用几个字节表示；ISO-2022-JP#tr[encoding]则使用“转义序列”来在ASCII和JIS#tr[encoding]之间来回跳跃。一个文件不会告诉你它在使用什么#tr[encoding]，所以在日本，打开一个文本文件然后被一堆乱码字符吓一跳是很常见的。在日本，这种因为转码错误产生的乱码被形象的称为文字妖怪（mojibake）。

// Clearly there was a need for a new encoding; one with a broad enough scope to encode *all* the world's characters, and one which could unify the proliferation of local "standards" into a single, global information processing standard. That encoding is Unicode.
很明显，我们需要一个新的#tr[encoding]。它需要足以放下世界上*所有*#tr[character]，以此来将这些在蛮荒时代肆意增长出的各种当地标准统一成一个。这个可以用于全球信息交换的#tr[encoding]标准就是 Unicode。

// In 1984, the International Standards Organisation began the task of developing such a global information processing standard. You may sometimes hear Unicode referred to as ISO 10646, which is sort of true. In 1986, developers from Apple and Xerox began discussing a proposed encoding system which they referred to as Unicode. The Unicode working group expanded and developed in parallel to ISO 10646, and in 1991 became formally incorporated as the Unicode Consortium and publishing Unicode 1.0. At this point, ISO essentially gave up trying to do their own thing.
1984年，国际标准化组织开始了建立全球信息交换标准的任务。有时候你会遇到把Unicode称为ISO 10646的情况，这在某种程度上也是对的。在1986年，Apple和施乐的开发人员开始讨论一个#tr[encoding]系统的草案，他们称其为Unicode。在ISO 10646的构建过程中，Unicode工作小组也在不断扩张。到1991年，这个工作小组正式注册为Unicode联盟，并发布了Unicode的1.0版。后来ISO基本上就不再进行自己这边10646标准的编写了。

// This doesn't mean that ISO 10646 is dead. Instead, ISO 10646 is a formal international standard definition of a Universal Coded Character Set, also known as UCS. The UCS is deliberately synchronised with the character-to-codepoint mapping defined in the Unicode Standard, but the work remains formally independent. At the same time, the Unicode Standard defines more than just the character set; it also defines a wide range of algorithms, data processing expectations and other advisory information about dealing with global scripts.
但这并不意味着ISO 10646胎死腹中。ISO 最终将 10646 定为了一个叫做通用#tr[character set]（Universal Coded Character Set，UCS）的正式国际标准。UCS 有意地和 Unicode 标准中的#tr[character]到#tr[codepoint]的映射同步，但在形式上这两个工作是互相独立的。不过 Unicode 不只是一个#tr[character set]，它也定义了一系列可以用于#tr[global scripts]数据的推荐流程、具体算法和相关细节信息。

// ## Global Scripts in Unicode
== Unicode 中的#tr[global scripts]

// At the time of writing, the Unicode Standard is up to version 9.0, and new scripts and characters are being encoded all the time. The Unicode character set is divided into 17 planes, each covering 65536 code points, for a total of 1,114,112 possible code points. Currently, only 128,327 of those code points have been assigned characters; 137,468 code points (including the whole of the last two planes) are reserved for private use.
在写作时，Unicode 标准的最新版是9.0，不断有新的#tr[scripts]和#tr[character]被#tr[encoding]进去。Unicode#tr[character set]被分为17个平面，每个平面有65536个#tr[codepoint]，共有 1114112 个可用#tr[codepoint]。目前，只有其中128327个被分配了#tr[character]，还有（包括最后两个平面的）137468个#tr[codepoint]为自定义的私人用途而保留。

#note[
  // > Private use means that *within an organisation, community or system* you may use these code points to encode any characters you see fit. However, private use characters should not "escape" into the outside world. Some organisations maintain registries of characters they have assigned to private use code points; for example, the SIL linguistic community have encoded 248 characters for their own use. One of these is , LATIN LETTER SMALL CAPITAL L WITH BELT, which they have encoded at position U+F268. But there's nothing to stop another organisation assigning a *different* character to U+F268 within their systems. If allocations start clashing, you lose the whole point of using a common universal character set. So use private use characters... privately.
  私人使用意味着，在*一个组织、社群或系统中*，你可以按照符合你需求的方式随意使用这些#tr[codepoint]。但是，私用#tr[character]不能“逃逸”到外部世界中。一些组织会维护一个他们使用的私人#tr[codepoint]的目录以供查询：比如SIL语言学社区#tr[encoding]了他们自用的248个#tr[character]。其中一个是#sil-pua[/*\u{0F268}*/\u{1DF04}]#footnote[译注：大多数SIL PUA#tr[character]已经被Unicode正式编入，编入后这些PUA区的#tr[character]就会标注为已弃用。目前支持SIL PUA区的字体都使用了某种样式来提示U+F268已被弃用，为了显示这个#tr[character]的实际样子，此处使用的其实是其正式Unicode#tr[codepoint]U+1DF04。], LATIN LETTER SMALL CAPITAL L WITH BELT，他们将其#tr[encoding]在U+F268的位置。但这并不能阻止其他组织在其系统中把U+F268分配给*别的*#tr[character]。一旦分配发生冲突，使用公共的通用#tr[character set]就失去了意义。所以私用#tr[character]只能在内部使用。
]

// Most characters live in the first plane, Plane 0, otherwise known as the Basic Multilingual Plane. The BMP is pretty full now - there are only 128 code points left unallocated - but it covers almost all languages in current use. Plane 1 is called the Supplementary Multilingual Plane, and mainly contains historic scripts, symbols and emoji. Lots and lots of emoji. Plane 2 contains extended CJK (Chinese, Japanese and Korean) ideographs with mainly rare and historic characters, while planes 3 through 13 are currently completely unallocated. So Unicode still has a lot of room to grow.
大多数#tr[character]都在第一个平面上，也就是第0平面。它的另一个著名的名字是#tr[BMP]（Basic Multilingual Plane，BMP）。BMP现在基本满了，它只剩下最后 128 个#tr[codepoint]还没被分配。这一个平面已经足以满足当前绝大数语言的需求。第1平面被称为#tr[SMP]，主要包含古代#tr[scripts]、符号和emoji。很多很多的emoji。第2平面包含中日韩表意文字扩展区，基本上是不常见的或者古代#tr[character]。第3到13平面完全没有使用，Unicode里的可用空间还有很多。

// Within each plane, Unicode allocates each writing system a range of codepoints called a *block*. Blocks are not of fixed size, and are not exhaustive - once codepoints are allocated, they can't be moved around, so if new characters from a writing system get added and their block fills up, a separate block somewhere else in the character set will be created. For instance, groups of Latin-like characters have been added on multiple occasions. This means that there are now 17 blocks allocated for different Latin characters; one of them, Latin Extended-B, consists of 208 code points, and contains Latin characters such as Ƕ (Latin Capital Letter Hwair), letters used in the transcription of Pinyin, and African clicks like U+013C, ǃ - which may look a lot like an exclamation mark but is actually the ǃKung letter Latin Letter Retroflex Click.
在每一个平面内，Unicode 会给某个#tr[writing system]分配一系列连续的#tr[codepoint]，这称为*#tr[block]*。#tr[block]不是固定大小的，也不保证全面。也就是它不一定含有这个#tr[writing system]的所有#tr[character]，因为在#tr[codepoint]分配给了#tr[character]了后，它们就不能移动了。所以如果这个#tr[block]的所有空位都用完了，而#tr[writing system]又需要增加别的#tr[character]的话，我们就会为它在#tr[character set]的其他位置再开一个#tr[block]。比如，拉丁系#tr[character]就新多次新增过#tr[block]，至今已有17个。其中一个#tr[block]叫做拉丁扩展B区，其中包含Ƕ（拉丁大写字母 Hwair），在转写汉语拼音时使用的字母，U+013C \u{01C3} 之类表示非洲搭嘴音的符号等。最后这个符号看上去像一个感叹号，但它其实是 \u{01C3}Kung 语言中的一个发卷舌搭嘴音的字母，我们在文本转写中用`Latin Letter Retroflex Click`这个符号来表示它。

// > The distinction between ǃ (Retroflex Click) and ! (exclamation mark) illustrates a fundamental principle of Unicode: encode what you *mean*, not what you *see*. If we were to use the exclamation mark character for both uses just because they were visually identical, we would sow semantic confusion. Keeping the code points separate keeps your data unambiguous.
#note[
  \u{01C3}（卷舌搭嘴音） 和 !（感叹号）之间的区别揭示了Unicode中的一个原则：按*语义*而不是*外形*来决定是否#tr[encoding]。如果我们仅仅因为它俩看上去相似，就在这两个地方都用感叹号，这样会产生让人迷惑的语义。从#tr[codepoint]上将它们分离可以让数据不产生歧义。
]

// Here is the complete list of scripts already encoded in Unicode as of version 9.0: Adlam, Ahom, Anatolian Hieroglyphs, Arabic, Armenian, Avestan, Balinese, Bamum, Bassa Vah, Batak, Bengali, Bhaiksuki, Bopomofo, Brahmi, Braille, Buginese, Buhid, Canadian Aboriginal, Carian, Caucasian Albanian, Chakma, Cham, Cherokee, Common (that is, characters used in multiple scripts), Coptic, Cuneiform, Cypriot, Cyrillic, Deseret, Devanagari, Duployan, Egyptian Hieroglyphs, Elbasan, Ethiopic, Georgian, Glagolitic, Gothic, Grantha, Greek, Gujarati, Gurmukhi, Han (that is, Chinese, Japanese and Korean ideographs), Hangul, Hanunoo, Hatran, Hebrew, Hiragana, Imperial Aramaic, Inscriptional Pahlavi, Inscriptional Parthian, Javanese, Kaithi, Kannada, Katakana, Kayah Li, Kharoshthi, Khmer, Khojki, Khudawadi, Lao, Latin, Lepcha, Limbu, Linear A, Linear B, Lisu, Lycian, Lydian, Mahajani, Malayalam, Mandaic, Manichaean, Marchen, Meetei Mayek, Mende Kikakui, Meroitic Cursive, Meroitic Hieroglyphs, Miao, Modi, Mongolian, Mro, Multani, Myanmar, Nabataean, New Tai Lue, Newa, Nko, Ogham, Ol Chiki, Old Hungarian, Old Italic, Old North Arabian, Old Permic, Old Persian, Old South Arabian, Old Turkic, Oriya, Osage, Osmanya, Pahawh Hmong, Palmyrene, Pau Cin Hau, Phags Pa, Phoenician, Psalter Pahlavi, Rejang, Runic, Samaritan, Saurashtra, Sharada, Shavian, Siddham, SignWriting, Sinhala, Sora Sompeng, Sundanese, Syloti Nagri, Syriac, Tagalog, Tagbanwa, Tai Le, Tai Tham, Tai Viet, Takri, Tamil, Tangut, Telugu, Thaana, Thai, Tibetan, Tifinagh, Tirhuta, Ugaritic, Vai, Warang Citi, Yi.
以下是 Unicode 9.0 中#tr[encoding]了的所有#tr[scripts]：Adlam, Ahom, Anatolian Hieroglyphs, Arabic, Armenian, Avestan, Balinese, Bamum, Bassa Vah, Batak, Bengali, Bhaiksuki, Bopomofo, Brahmi, Braille, Buginese, Buhid, Canadian Aboriginal, Carian, Caucasian Albanian, Chakma, Cham, Cherokee, Common (that is, characters used in multiple scripts), Coptic, Cuneiform, Cypriot, Cyrillic, Deseret, Devanagari, Duployan, Egyptian Hieroglyphs, Elbasan, Ethiopic, Georgian, Glagolitic, Gothic, Grantha, Greek, Gujarati, Gurmukhi, Han, Hangul, Hanunoo, Hatran, Hebrew, Hiragana, Imperial Aramaic, Inscriptional Pahlavi, Inscriptional Parthian, Javanese, Kaithi, Kannada, Katakana, Kayah Li, Kharoshthi, Khmer, Khojki, Khudawadi, Lao, Latin, Lepcha, Limbu, Linear A, Linear B, Lisu, Lycian, Lydian, Mahajani, Malayalam, Mandaic, Manichaean, Marchen, Meetei Mayek, Mende Kikakui, Meroitic Cursive, Meroitic Hieroglyphs, Miao, Modi, Mongolian, Mro, Multani, Myanmar, Nabataean, New Tai Lue, Newa, Nko, Ogham, Ol Chiki, Old Hungarian, Old Italic, Old North Arabian, Old Permic, Old Persian, Old South Arabian, Old Turkic, Oriya, Osage, Osmanya, Pahawh Hmong, Palmyrene, Pau Cin Hau, Phags Pa, Phoenician, Psalter Pahlavi, Rejang, Runic, Samaritan, Saurashtra, Sharada, Shavian, Siddham, SignWriting, Sinhala, Sora Sompeng, Sundanese, Syloti Nagri, Syriac, Tagalog, Tagbanwa, Tai Le, Tai Tham, Tai Viet, Takri, Tamil, Tangut, Telugu, Thaana, Thai, Tibetan, Tifinagh, Tirhuta, Ugaritic, Vai, Warang Citi, Yi。#footnote[译注：翻译本段意义不大，其中的 Han 即为汉字。希望了解其他#tr[scripts]的读者可自行查询ISO 15924代码列表@Unicode.ISO15924。]

#note[
  // > When you're developing fonts, you will very often need to know how a particular character is encoded and whereabouts it lives in the Unicode standard - that is, its *codepoint*. For example, the Sinhala letter ayanna is at codepoint 3461 (we usually write these in hexadecimal, as 0D85). How did I know that? I could look it up in the [code charts](https://www.unicode.org/charts/), but actually I have a handy application on my computer called [UnicodeChecker](https://earthlingsoft.net/UnicodeChecker/) which not only helps me find characters and their codepoints, but tells me what the Unicode Standard says about those characters, and also what fonts on my system support them. If you're on a Mac, I recommend that; if not, I recommend finding something similar.
  当你开发字体时，你经常需要知道一个特定#tr[character]是如何#tr[encoding]的，也就是它处于Unicode标准的什么位置，这种位置就是#tr[codepoint]。比如，僧伽罗语字母ayanna在#tr[codepoint]3461（我们一般写成十六进制，0D85）处。从哪能获取这种信息呢？你可以查看Unicode#tr[character]代码表@Unicode.UnicodeCharacter，但我一般会在电脑上安装一个叫做UnicodeChecker的应用程序@Earthlingsoft.UnicodeChecker.2022。它不仅能很方便地告诉我Unicode中每个#tr[character]的各种信息，还能列出我电脑中支持这个#tr[character]的所有字体。如果你也在使用Mac系统的话，我非常推荐它。如果不是，我也推荐你找找对应平台上的类似应用#footnote[译注：UnicodeChecker只支持macOS，如果你在其他系统上有查询支持某字符的所有字体的需求，译者为此编写过跨平台的命令行工具fontfor @7sDream.Fontfor，可供一试。]。
]

// What should you do if you are developing resources for a script which is not encoded in Unicode? Well, first you should check whether or not it has already been proposed for inclusion by looking at the [Proposed New Scripts](http://www.unicode.org/pending/pending.html) web site; if not, then you should contact the Unicode mailing list to see if anyone is working on a proposal; then you should contact the [Script Encoding Initiative](http://linguistics.berkeley.edu/sei/), who will help to guide you through the process of preparing a proposal to the Unicode Technical Committee. This is not a quick process; some scripts have been in the "preliminary stage" for the past ten years, while waiting to gather expert opinions on their encoding.
如果你想为一个还没#tr[encoding]进Unicode中的#tr[scripts]开发字体的话，首先应该检查已提案#tr[scripts]#[@Unicode.ProposedNew]页面中是否已经有关于此#tr[scripts]的提案。如果没有，那么你应该通过Unicode邮件列表联系他们，看看是否有人正在编写这个提案。要是也没有人正在编写提案，你可以尝试联系一下Script Encoding Initiative#[@ScriptEncodingInitiative.ScriptEncoding]组织。在从前期准备到向Unicode技术委员会提出提案的整个流程中，他们都可以为你提供帮助。这个流程不会很快，有些#tr[scripts]在等待收集专家对其#tr[encoding]意见的“前期阶段”停留了十多年。

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
这些#tr[character]#tr[encoding]名称中的数字反映了它们使用多少比特进行#tr[encoding]。最简单的是 UTF-32：如果你按32个比特为一组，则一共有 $2^32=42,9496,7294$ 种不同的状态，这完全足以表示 Unicde 中的所有#tr[character]了。按这种方法，每个#tr[character]使用32个比特，也就是4个字节。具体来说，转换时把每个字符对应的#tr[codepoint]数字转换成二进制，然后用0填满不足32比特的剩余位置即可。

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

// ## Character properties
== #tr[character]属性

// The Unicode Standard isn't merely a collection of characters and their code points. The standard also contains the Unicode Character Database, a number of core data files containing the information that computers need in order to correctly process those characters. For example, the main database file, `UnicodeData.txt` contains a `General_Category` property which tells you if a codepoint represents a letter, number, mark, punctuation character and so on.
Unicode标准不仅只是收集所有#tr[character]并为他们分配#tr[codepoint]而已，它还建立了Unicode#tr[character]数据库。这个数据库中包含了许多核心数据文件，计算机依赖这些文件中的信息来正确处理#tr[character]。例如，主数据文件`UnicodeData.txt`中定义了#tr[general category]属性，它能告诉你某个#tr[character]是字母、数字、标点还是符号等等。

// Let's pick a few characters and see what Unicode says about them. We'll begin with codepoint U+0041, the letter `A`. First, looking in `UnicodeData.txt` we see
我们挑一些字符来看看Unicode能提供关于它们的哪些信息吧。从#tr[codepoint]`U+0041`字母`A`开始。首先，在`UnicodeData.txt`文件中有如下数据：

```
0041;LATIN CAPITAL LETTER A;Lu;0;L;;;;;N;;;;0061;
```

// After the codepoint and official name, we get the general category, which is `Lu`, or "Letter, uppercase." The next field, 0, is useful when you're combining and decomposing characters, which we'll look at later. The `L` tells us this is a strong left-to-right character, which is of critical importance when we look at bidirectionality in later chapters. Otherwise, `UnicodeData.txt` doesn't tell us much about this letter - it's not a character composed of multiple characters stuck together and it's not a number, so the next three fields are blank. The `N` means it's not a character that mirrors when the script flips from left to right (like parentheses do between English and Arabic. The next two fields are no longer used. The final fields are to do with upper and lower case versions: Latin has upper and lower cases, and this character is simple enough to have a single unambiguous lower case version, codepoint U+0061. It doesn't have upper or title case versions, because it already is upper case, duh.
在开头的#tr[codepoint]和官方#tr[character]名称之后就是#tr[general category]属性，其值为 `Lu`，含义为“字母（Letter）的大写（uppercase）形式”。下一个属性的值是 `0`，这个属性是用于指导如何进行#tr[character]的#tr[combine]和#tr[decompose]的，这方面的内容我们在后面会介绍，暂时先跳过。下一个属性值是`L`，它告诉我们`A`是一个强烈倾向于从左往右书写的#tr[character]，这一属性对于后续会介绍的文本#tr[bidi]性至关重要。除此之外`UnicodeData.txt`中的关于`A`就没有太多有用的信息了：它不是一个由多个#tr[character]组合而成的#tr[character]，也不是数字，所以后面的几个属性都是空的。下一个有值的是`N`，它表示当文本的书写方向翻转时，这个字符不需要进行镜像。可以想象一下，圆括号在阿拉伯文环境中，相对于在英文中就是需要镜像的，但`A`不需要。接下来的两个属性已经不再使用了，直接跳过它们。最后一个属性则是有关大小写转换的。拉丁字母有大小写形式，而`A`#tr[character]比较简单，它拥有一个明确的小写版本，码位为`U+0061`。它没有大写或标题形式，呃，因为它本身已经是大写了嘛。

// What else do we know about this character? Looking in `Blocks.txt` we can discover that it is part of the range, `0000..007F; Basic Latin`. `LineBreak.txt` is used by the line breaking algorithm, something we'll also look at in the chapter on layout.
关于这个#tr[character]我们还能知道些什么呢？打开 `Blocks.txt` 文件，我们能知道它处于 `0000..007F; Basic Latin` 这个范围区间。

`LineBreak.txt`中则提供了一些在断行算法中需要用到的信息，我们会在关于#tr[layout]的章节中详细介绍，现在先简单看看：

#[
#set text(0.8em)

```
0041..005A;AL     # Lu    [26] LATIN CAPITAL LETTER A..LATIN CAPITAL LETTER Z
```
]


// This tells us that the upper case A is an alphabetic character for the purposes of line breaking. `PropList.txt` is a rag-tag collection of Unicode property information, and we will find two entries for our character there:
这一行告诉我们，对于断行来说，大写字母 A 属于 `AL` 类别，含义为字母和常规符号。

`PropList.txt` 是一个混杂了各种Unicode属性信息的集合，在其中和我们的`A`#tr[character]有关的有两条：

#[
#set text(0.7em)

```
0041..0046    ; Hex_Digit # L&   [6] LATIN CAPITAL LETTER A..LATIN CAPITAL LETTER F
0041..0046    ; ASCII_Hex_Digit # L&   [6] LATIN CAPITAL LETTER A..LATIN CAPITAL LETTER F
```
]

// These tell us that it is able to be used as a hexadecimal digit, both in a more relaxed sense and strictly as a subset of ASCII. (U+FF21, a full-width version of `Ａ` used occasionally when writing Latin characters in Japanese text, is a hex digit, but it's not an ASCII hex digit.) `CaseFolding.txt` tells us:
这些信息告诉我们，`A` 能够用在十六进制数字中，在宽松环境和严格的ASCII环境中均可。作为对比，`U+FF21` 全宽的 `Ａ` 在日文文本中作为拉丁#tr[character]使用。它也属于十六进制数字，但不属于 ASCII 十六进制数字。

`CaseFolding.txt` 中的信息如下：

```
0041; C; 0061; # LATIN CAPITAL LETTER A
```

// When you want to case-fold a string containing `A`, you should replace it with codepoint `0061`, which as we've already seen, is LATIN SMALL LETTER A. Finally, in `Scripts.txt`, we discover...
这表示当你希望对一个含有`A`的字符串进行#tr[case-fold]时，需要把它替换为#tr[codepoint]`0061`，也就是`LATIN SMALL LETTER A`。

最后，在`Scripts.txt`文件中，可以发现：

#[
#set text(0.8em)

```
0041..005A    ; Latin # L&  [26] LATIN CAPITAL LETTER A..LATIN CAPITAL LETTER Z
```
]

// ..that this codepoint is part of the Latin script. You knew that, but now a computer does too.
这一条表示这个#tr[codepoint]属于拉丁文。当然，这个信息你早就知道了，但计算机有了这个文件才能知道。

// Now let's look at a more interesting example. N'ko is a script used to write the Mandinka and Bambara languages of West Africa. But if we knew nothing about it, what could the Unicode Character Database teach us? Let's look at a sample letter, U+07DE NKO LETTER KA (ߞ).
现在我们换一个更有趣的例子吧。N'ko（也被称为西非书面字母或恩科字母）是一种用于书写西非地区的曼丁戈语和班巴拉语的#tr[script]。如果我们对这种#tr[script]一无所知的话，Unicode#tr[character]数据库能够提供给我们一些什么信息呢？我们用`U+07DE NKO Letter KA`（#mandingo[ߞ]）这个字母来试试吧。

// First, from `UnicodeData.txt`:
首先，`UnicodeData.txt`中的信息有：

```
07DE;NKO LETTER KA;Lo;0;R;;;;;N;;;;;
```

// This tells me that the character is a Letter-other - neither upper nor lower case - and the lack of case conversion information at the end confirms that N'ko is a unicase script. The `R` tells me that N'ko is written from right to left, like Hebrew and Arabic. It's an alphabetic character for line breaking purposes, according to `LineBreak.txt`, and there's no reference to it in `PropList.txt`. But when we look in `ArabicShaping.txt` we find something very interesting:
这行告诉我们，这个#tr[character]属于`Lo`#tr[general category]，表示它是一个“字母（Letter）的其他（other）形式”。这里的其他形式表示既不是大写也不是小写。这行最后缺少的大小写转换信息也告诉我们，N'ko 是一种不分大小写的#tr[script]。中间的`R`则表示N'ko#tr[script]是从右往左书写的，就像希伯来文和阿拉伯文那样。

根据 `LineBreak.txt` 中的信息，对于断行来说它和`A`的类别一样，也属于普通字母这一类。在 `PropList.txt` 中没有关于它的信息。但当我们打开 `ArabicShaping.txt` 这个文件时，会发现一些有趣的信息：

```
07DE; NKO KA; D; No_Joining_Group
```

// The letter ߞ is a double-joining character, meaning that N'ko is a connected script like Arabic, and the letter Ka connects on both sides. That is, in the middle of a word like "n'ko" ("I say"), the letter looks like this: ߒߞߏ.
这个字母#mandingo[ߞ]是一个双向互连#tr[character]，这意味着N'ko是一种和阿拉伯文类似的连写#tr[script]，并且 Ka 字母和左右两边都互相连接。也就是说，在表示“我说”的单词“n'ko”里，这个字母看上去是这样的：#mandingo[ߒߞߏ]。

// This is the kind of data that text processing systems can derive programmatically from the Unicode Character Database. Of course, if you really want to know about how to handle N'ko text and the N'ko writing system in general, the Unicode Standard itself is a good reference point: its section on N'ko (section 19.4) tells you about the origins of the script, the structure, diacritical system, punctuation, number systems and so on.
这就是文字处理系统能用程序从Unicode#tr[character]数据库中获取到的信息。当然，如果你真的想学习N'ko#tr[writing system]的通用知识和如何处理它们，Unicode标准本身就是一个很好的参考资料，它的 N'ko 部分（在 19.4 小节）会告诉你这种#tr[script]的起源、结构、#tr[diacritic]、标点、数字系统等方面的信息。

#note[
  // > When dealing with computer processing of an unfamiliar writing system, the Unicode Standard is often a good place to start. It's actually pretty readable and contains a wealth of information about script issues. Indeed, if you're doing any kind of heavy cross-script work, you would almost certainly benefit from getting hold of a (printed) copy of the latest Unicode Standard as a desk reference.
  当使用计算机处理一种不熟悉的#tr[writing system]时，Unicode标准通常是一个很好的起点。它的易读性其实非常强，而且包含在处理#tr[script]时会遇到的各种问题的关键信息。事实上，在进行任何繁重的跨#tr[scripts]工作时，如果在手边能有一本（纸质版的）最新版Unicode标准文档作为参考手册，必然会大有裨益。
]

// ## Case conversion
== 大小写转换

// We've seen that N'Ko is a unicase script; its letters have no upper case and lower case forms. In fact, only a tiny minority of writing systems, such as those based on the Latin alphabet, have the concept of upper and lower case versions of a character. For some language systems like English, this is fairly simple and unambiguous. Each of the 26 letters of the Latin alphabet used in English have a single upper and lower case. However, other languages which use cases often have characters which do not have such a simple mapping. The Unicode character database, and especially the file `SpecialCasing.txt`, provides machine-readable information about case conversion.
我们已经知道，N'ko 是一种不分大小写的#tr[script]。事实上只有很小一部分书写系统拥有大小写的概念，比如那些基于拉丁字母表的#tr[scripts]。对于类似英语的一些语言来说，大小写的概念很清晰：英语中的26个拉丁字母各自都只有一个大写形式和一个小写形式。但是其他的语言不一定也遵循这样简单的映射。Unicode#tr[character]数据库中的 `SpecialCasing.txt` 文件以机器可读的格式表述了关于大小写转换的信息。

// The classic example is German. When the sharp-s character U+00DF (ß) is uppercased, it becomes the *two* characters "SS". There is clearly a round-tripping problem here, because when the characters "SS" are downcased, they become "ss", not ß. For more fun, Unicode also defines the character U+1E9E, LATIN CAPITAL LETTER SHARP S (ẞ), which downcases to ß.
一个非常经典的例子是，德语中有一个被称为sharp s的字母#german[ß]，位于 `U+00DF`。当进行大写转换时，需要将它变成*两个*#tr[character]SS。这里显然会存在一个逆向转换的问题，因为当SS转换为小写时会是ss，而不再是#german[ß]。更有趣的是，Unicode也定义了`U+1E9E LATIN CAPITAL LETTER SHARP S`（拉丁文大写字母 Sharp S），写作 #german[ẞ]。这个#tr[character]转换成小写是#german[ß]。

#note[
  // > During the writing of this book, the Council for German Orthography (*Rat für deutsche Rechtschreibung*) has recommended that the LATIN CAPITAL LETTER SHARP S be included in the German alphabet as the uppercase version of ß, which will make everything a lot easier but rob us of a very useful example of the difficulties of case conversion.
  在本书的编写过程中，德语正写法协会（#german[Rat für deutsche Rechtschreibung]）建议将`LATIN CAPITAL LETTER SHARP S`作为#german[ß]的大写形式纳入德文字母表中。这会使上述难题变得简单很多，但这样也会让我们失去一个能直观感受到大小写转换的困难程度的绝佳例子。
]

// The other classic example is Turkish. The ordinary Latin small letter "i" (U+0069) normally uppercases to "I" (U+0049) - except when the document is written in Turkish or Azerbaijani, when it uppercases to "İ". This is because there is another letter used in those languages, LATIN SMALL LETTER DOTLESS I (U+0131, ı), which uppercases to "I". So case conversion needs to be aware of the linguistic background of the text.
另一个经典例子是传统拉丁字母i（`U+0069`）。通常来说，这个字母转换为大写时会是I（U+0049），但在土耳其语或阿塞拜疆语的环境下，其大写却是İ。<position:turkish-i-uppercase>这是因为这些语言中还有另一个字母 ı（`U+0131 LATIN SMALL LETTER DOTLESS I`，拉丁文小写字母无点I），这个字母的大写才是 I。所以，大小写转换也需要考虑文本所处的语言环境。

// As well as depending on language, case conversion also depends on context. GREEK CAPITAL LETTER SIGMA (Σ) downcases to GREEK SMALL LETTER SIGMA (σ) except at the end of a word, in which case it downcases to ς, GREEK SMALL LETTER FINAL SIGMA.
除了和语言有关之外，大小写转换还需要结合上下文。#greek[Σ]（`GREEK CAPITAL LETTER SIGMA`，希腊文大写字母 Sigma）通常的小写形式为#greek[σ]（`GREEK SMALL LETTER SIGMA`，希腊文小写字母 Sigma）。但如果其出现在词尾，则小写形式会变为#greek[ς]（`GREEK SMALL LETTER FINAL SIGMA`，希腊文小写字母词尾 Sigma）。

// Another example comes from the fact that Unicode may have a *composed form* for one case, but not for another. Code point U+0390 in Unicode is occupied by GREEK SMALL LETTER IOTA WITH DIALYTIKA AND TONOS, which looks like this: ΐ. But for whatever reason, Unicode never encoded a corresponding GREEK CAPITAL LETTER IOTA WITH DIALYTIKA AND TONOS. Instead, when this is placed into upper case, three code points are required: U+0399, GREEK CAPITAL LETTER IOTA provides the Ι; then U+0308 COMBINING DIAERESIS provides the dialytika; and lastly, U+0301 COMBINING ACUTE ACCENT provides the tonos.
还有一种情况是，某些字符的一种形态的是*#tr[compose]形式*的，但另一种却不是。比如字母#greek[ΐ]（`U+0390 GREEK SMALL LETTER IOTA WITH DIALYTIKA AND TONOS`，带Dialytika和Tonos的希腊文小写字母 Iota），Unicode中没有某个单一#tr[character]对应的它的大写形态。当我们需要它的大写时，得用上三个#tr[codepoint]：`U+0399 GREEK CAPITAL LETTER IOTA`（希腊文大写字母 Iota）提供主体；`U+0308 COMBINING DIAERESIS`（组合用分音符）提供分音符（字母上方的两个点）；`U+0301 COMBINING ACUTE ACCENT`（组合用锐音符）提供声调。它们合起来才能组成大写的#greek[\u{0399}\u{0308}\u{0301}/* Ϊ́ */]。

// ## Normalization and decomposition
== #tr[normalization]和#tr[decompose] <heading:normalization-decomposition>

// The Unicode Standard has a number of stated design goals: to be *universal*, in the sense that every character in every script likely to be used on computer has an encoding; to be *efficient*, such that algorithms used by computers to input and output Unicode characters do not require too much state or overhead; and to be *unambiguous*, in that every Unicode codepoint represents the same character.
Unicode标准明面上有如下几个设计目标：通用，也即尽量#tr[encoding]所有可能在计算机中用到的所有#tr[scripts]中的所有#tr[character]；高效，处理Unicode数据的输入输出的相关算法不能引入过多的额外状态和计算开销；明确且无歧义，Unicode#tr[codepoint]和#tr[character]互相一一对应。

// But it also has an unstated design goal, which is the unstated design goal of pretty much every well-behaved piece of software engineering: *backward compatibility*. Unicode wants to maintain compatibility with all previous encoding standards, so that old documents can be reliably converted to and from Unicode without ambiguity. To a first approximation, this means every character that was ever assigned a codepoint in some encoding should be assigned a unique codepoint in Unicode.
除此之外，还有一个没有直接表述出，但和绝大多数软件工程项目一样必须考虑到的目标：*向后兼容*。Unicode希望尽量对先前的#tr[encoding]标准保持兼容，这样老旧的文档才能被可靠地在原始#tr[encoding]和Unicode间来回转换。这几乎就是说，只要先前的某个#tr[encoding]标准中有某个#tr[character]，Unicode中就必须为它赋予一个专属的#tr[codepoint]。

// This contrasts somewhat with the goal of unambiguity, as there can be multiple different ways to form a character. For instance, consider the  character n̈ (Latin small letter n with diaeresis). It occurs in Jacaltec, Malagasy, Cape Verdean Creole, and most notably, *This Is Spın̈al Tap*. Despite this obvious prominence, it is not considered noteworthy enough to be encoded in Unicode as a distinct character, and so has to be encoded using *combining characters*.
这在某种程度上和之前说的无歧义目标是相违背的。因为同一个#tr[character]在不同的古老标准中可能有不同的构建方式。比如#tr[character]n̈（带有分音符的小写拉丁字母N），它在雅卡尔泰克语、马达加斯加语、卡布佛得鲁语和著名的电影《This Is Spın̈al Tap》中都有使用。尽管如此常见，但Unicode不认为它重要到要用一个单独的#tr[character]来#tr[encoding]。最终我们用一种叫做*可#tr[combine]#tr[character]*的方式#tr[encoding]它。

// A combining character is a mark that attaches to a base character; in other words, a diacritic. To encode n̈, we take LATIN SMALL LETTER N (U+006E) and follow it with COMBINING DIAERESIS (U+0308). The layout system is responsible for arranging for those two characters to be displayed as one.
可#tr[combine]#tr[character]是一种附加到基本#tr[character]上的符号，也被称为#tr[diacritic]。为了#tr[encoding]n̈，首先需要#tr[character]`U+006E LATIN SMALL LETTER N`（拉丁文小写字母N），然后在其后加上#tr[character]`U+0308 COMBINING DIAERESIS`（#tr[combine]用分音符）。#tr[layout]系统会负责将这两个#tr[character]编排显示为一个整体\u{006E}\u{0308}。

#note[
  // > This obviously walks all over the "efficiency" design goal - applications which process text character-by-character must now be aware that something which visually looks like one character on the page, and semantically refers to one character in text, is actually made up of *two* characters in a string, purely as an artifact of Unicode's encoding rules. Poorly-written software can end up separating the two characters and processing them independently, instead of treating them as one indivisible entity.
  这显然违背了关于高效的设计目标。文本处理应用必须能够理解，有些在页面上看上去是一个#tr[character]，在文本概念中也是一个#tr[character]的东西，到了编程领域的字符串概念中却是*两个*#tr[character]。而这纯粹只是Unicode#tr[encoding]规则的产物。质量一般的软件可能会把这两个#tr[character]分开并单独处理，而不是将其视为不可分割的整体。
]

// Now consider the character ṅ (Latin small letter n with dot above). Just one dot different, but a different story entirely; this is used in the transliteration of Sanskrit, and as such was included in pre-Unicode encodings such as CS/CSX (Wujastyk, D., 1990, *Standardization of Sanskrit for Electronic Data Transfer and Screen Representation*, 8th World Sanskrit Conference, Vienna), where it was assigned codepoint 239. Many electronic versions of Sanskrit texts were prepared using the character, and so when it came to encoding it in Unicode, the backward compatibility goal meant that it needed to be encoded as a separate character, U+1E45.
现在来看另一个#tr[character]ṅ（上面带点的拉丁文小写字母N），它和n̈看起来只有“一点”区别，但后续的命运却迥然不同。这个字母用于梵文的拉丁转写，曾经被CS/CSX#tr[encoding]#footnote[1990年，第八届世界梵语大会于维也纳举行。在会议的一次关于梵文在电子数据传输中的标准化问题的小组讨论会上，#cite(form: "prose", <Wujastyk.StandardizationSanskrit.1990>)提出了此编码。]收录于#tr[codepoint]239上，许多使用梵文的电子文本都会使用这一#tr[character]。因此为了向后兼容性，Unicode需要将它视为一个单独的#tr[character]。最终它被放置在#tr[codepoint]`U+1E45`上。

// But of course, it could equally be represented in just the same way as n̈: you can form a ṅ by following a LATIN SMALL LETTER N (U+006E) with a COMBINING DOT ABOVE (U+0307). Two possible ways to encode ṅ, but only one possible way to encode n̈. So much for "unambiguous": the two strings "U+006E U+0307" and "U+1E45" represent the same character, but are not equal.
但是它也理所当然地可以用#tr[encoding]n̈的那种方式来表示：`U+006E LATIN SMALL LETTER N`（拉丁文小写字母N）和`U+0307 COMBINING DOT ABOVE`（#tr[combine]用上点）这两个字符#tr[combine]起来也是\u{006E}\u{0307}。现在，我们有两种不同的#tr[encoding]可以表示ṅ，但只有一种方式表示n̈。另外，`U+006E U+0307`和`U+1E45`这两个字符串表示同一个#tr[character]，但它们明显不相等。看起来歧义问题好像越来越严重了。

// But wait - and you're going to hear this a lot when it comes to Unicode - it gets worse! The sign for an Ohm, the unit of electrical resistance, is Ω (U+2126 OHM SIGN). Now while a fundamental principle of Unicode is that *characters encode semantics, not visual representation*, this is clearly in some sense "the same as" Ω. (U+03A9 GREEK CAPITAL LETTER OMEGA) They are semantically different but they happen to look the same; and yet, let's face it, from a user perspective it would be exceptionally frustrating if you searched in a string for a Ω but you didn't find it because the string contained a Ω instead.
别急，还有更糟的。还记得我们说过，Unicode是“按照语义，而不是外形”收录#tr[character]的。举例来说，用于表示电阻单位的 Ω（`U+2126 OHM SIGN`，欧姆标记）和Ω（`U+03A9 GREEK CAPITAL LETTER OMEGA`，希腊文大写字母Omega）就因语义不同而被分别收录。但是，让我们面对现实吧。如果在一串文本中搜索Ω，却因为在其中的是Ω而无法搜索出来，站在普通用户的角度看这也太迷惑和荒谬了。

// The way that Unicode deals with both of these problem is to define one of the encodings to be *canonical*. The Standard also defines two operations: *Canonical Decomposition* and *Canonical Composition*. Replacing each character in a string with its canonical form is called *normalization*.
Unicode处理上述问题的方式是定义一个#tr[canonical]#tr[encoding]。标准中还定义了两个操作：*#tr[canonical]#tr[decompose]*和*#tr[canonical]#tr[compose]*。将字符串中的所有#tr[character]转化为其对应的#tr[canonical]形式的过程称为*#tr[normalization]*。

#note[
  // > There's also a "compatibility decomposition", for characters which are very similar but not precisely equivalent: ℍ (U+210D DOUBLE-STRUCK CAPITAL H) can be simplified to a Latin capital letter H. But the compatibility normalizations are rarely used, so we won't go into them here.
  另外还有一种操作叫兼容#tr[decompose]，对于一些非常相似，但其实有细微差别的#tr[character]进行兼容处理。比如 ℍ（`U+210D DOUBLE-STRUCK CAPITAL H`，双线大写H），在兼容#tr[decompose]操作下会简化为拉丁大写字母H。但因为这种方式其实很少用到，我们在此不进行过多介绍。
]

// The simplest way of doing normalization is called Normalization Form D, or NFD. This just applies canonical decomposition, which means that every character which can be broken up into separate components gets broken up. As usual, the Unicode Database has all the information about how to decompose characters.
进行#tr[normalization]的最简单的方法是NFD（Normalization Form D，#tr[normalization]形式D），只需要执行一遍#tr[canonical]#tr[decompose]即可。在NFD完成后，每个#tr[character]都被分解为其组成部分。和之前一样，Unicode数据库也包含了关于如何#tr[decompose]#tr[character]的信息。

// Let's take up our example again of GREEK CAPITAL LETTER IOTA WITH DIALYTIKA AND TONOS, which is not encoded directly in Unicode. Suppose we decide to encode it as U+0399 GREEK CAPITAL LETTER IOTA followed by U+0344 COMBINING GREEK DIALYTIKA TONOS, which seems like a sensible way to do it. When we apply canonical decomposition, we find that the Unicode database specifies a decomposition U+0344 - it tells us that the combining mark breaks up into two characters: U+0308 COMBINING DIAERESIS and U+0301 COMBINING ACUTE ACCENT.
以前文提到过的“带Dialytika和Tonos的希腊文大写字母Iota”为例，它没有被Unicode直接#tr[encoding]。假设现在我们决定用`U+0399 GREEK CAPITAL LETTER IOTA`（希腊文大写字母Iota）和`U+0344 COMBINING GREEK DIALYTIKA TONOS`（#tr[combine]用希腊文Dialytika Tonos）这个非常合理的组合来表示它。当进行#tr[canonical]#tr[decompose]时，我们发现Unicode数据库为`U+0344`指定了#tr[decompose]形式，这个#tr[combine]符需要被#tr[decompose]为两个#tr[character]：`U+0308 COMBINING DIAERESIS`（#tr[combine]用分音符）和`U+0301 COMBINING ACUTE ACCENT`（#tr[combine]用锐音符）。

#let codepoint-table = (s, title: none) => {
  let cps = s.codepoints()
  block(
    breakable: false,
    width: 100%,
    align(
      center,
      table(
        columns: cps.len() + 1,
        align: center,
        if title == none {
          []
        } else {
          title
        },
        ..cps,
        [],
        ..cps.map(str.to-unicode).map(it => raw(util.to-string-zero-padding(it, 4, base: 16))),
      ),
    ),
  )
}

#codepoint-table("\u{0399}\u{0344}", title: [输入字符串])
#codepoint-table("\u{0399}\u{0308}\u{0301}", title: [NFD])

// NFD is good enough for most uses; if you are comparing two strings and they have been normalized to NFD, then checking if the strings are equal will tell you if you have the same characters. However, the Unicode Standard defines another step: if you apply canonical composition to get characters back into their preferred form, you get Normalization Form C. NFC is the recommended way of storing and exchanging text. When we apply canonical composition to our string, the iota and the diaresis combine to form U+03AA GREEK CAPITAL LETTER IOTA WITH DIALYTIKA, and the combining acute accent is left on its own:
NFD对于绝大多数应用场景来说都是个不错的选择。比如希望比较两个字符串是否相等，只需要先进行NFD，然后逐个字符比较即可。Unicode还定义了另一种处理方法：在NFD的基础上再进行一个步骤，为已#tr[decompose]的#tr[character]进行#tr[canonical]#tr[compose]，将它们重组成首选形式，这样就得到了NFC（Normalization Form C，#tr[normalization]形式C）。NFC是用于储存和交换文本的推荐方式。当进行#tr[canonical]#tr[compose]时，字母Iota和分音符会#tr[combine]成`U+03AA GREEK CAPITAL LETTER IOTA WITH DIALYTIKA`（带 Dialytika 的希腊文大写字母 Iota），剩下的组合用锐音符就原样保留：

#codepoint-table("\u{0399}\u{0344}", title: [输入字符串])
#codepoint-table("\u{0399}\u{0308}\u{0301}", title: [NFD])
#codepoint-table("\u{03aa}\u{0301}", title: [NFC])

// Note that this is an entirely different string to our input, even though it represents the same text! But the process of normalization provides an unambiguous representation of the text, a way of creating a "correct" string that can be used in comparisons, searches and so on.
虽然这个文本和我们最初的输入已经大不相同了，但它们表达的含义还是一样的。通过某种特定的#tr[normalization]后，用来表达一段文本的字符串就被唯一的确定了。这一方法可以用于字符串比较和搜索等多种场景。

#note[
  // > The OpenType feature `ccmp`, which we'll investigate in chapter 6, allows font designers to do their own normalization, and to arrange the input glyph sequence into ways which make sense for the font.
  我们在#[@chapter:substitution-positioning]中会介绍的OpenType特性`ccmp`允许字体设计师按照他们希望的方式进行#tr[normalization]，可以将输入的#tr[glyph]序列重新整理成在字体内部更易处理的形式。

  // To give two examples: first, in Syriac, there's a combining character SYRIAC PTHAHA DOTTED (U+0732), which consists of a dot above and a dot below. When positioning this mark relative to a base glyph, it's often easier to position each dot independently. So, the `ccmp` feature can split U+0732 into a dot above and a dot below, and you can then use OpenType rules to position each dot in the appropriate place for a base glyph.
  这里简单举两个例子。一是在叙利亚语中有一个#tr[combine]#tr[character]`U+0732 SYRIAC PTHAHA DOTTED`（叙利亚文带点的 Pthaha），它由一上一下两个点组合而成。当需要以某个基本#tr[character]为参考来确定这个符号的所在位置时，对这两个点分别进行处理通常是更加简单的。此时就可以用`ccmp`特性将`U+0732`分成上下两个点，然后再使用OpenType规则为基本#tr[glyph]分别定义这两个点的合适位置。

  // Second, the character í (U+00ED LATIN SMALL LETTER I WITH ACUTE) is used in Czech, Dakota, Irish and other languages. Unless you've actually provided an i-acute glyph in your font, you'll get handed the decomposed string LATIN SMALL LETTER I, COMBINING ACUTE ACCENT. LATIN SMALL LETTER I has a dot on the top, and you don't want to put a combining acute accent on *that*. `ccmp` will let you swap out the "i" for a dotless "ı" before you add your accent to it.
  第二个例子是#tr[character]í（`U+00ED LATIN SMALL LETTER I WITH ACUTE`，带锐音符的拉丁文小写字母I）。这个字母在捷克语、达科他语、爱尔兰语等语言中都会用到。一般而言，只要字体里没有单独为它绘制#tr[glyph]的话，都会将它#tr[decompose]为字母i和锐音符两个部分来处理。但是i上面有一个小点，我们不能直接将锐音符放在点的上面。这时`ccmp`特性允许我们在添加锐音符之前将字母“i”替换成没有点的“ı”。
]

// ## ICU
== ICU 程序库

// For those of you reading this book because you're planning on developing applications or libraries to handle complex text layout, there's obviously a lot of things in this chapter that you need to implement: UTF-8 encoding and decoding, correct case conversion, decomposition, normalization, and so on.
如果你阅读本书的原因是想开发一个处理复杂文本布局的应用或程序库，可能会发现上面介绍的过的许多概念都需要实现。比如UTF-8的编解码，正确的大小写转换，字符串的#tr[decompose]和#tr[normalization]等等。

// The Unicode Standard (and its associated Unicode Standard Annexes, Unicode Technical Standards and Unicode Technical Reports) define algorithms for how to handle these things and much more: how to segment text into words and lines, how to ensure that left-to-right and right-to-left text work nicely together, how to handle regular expressions, and so on. It's good to be familiar with these resources, available from [the Unicode web site](http://unicode.org/reports/), so you know what the issues are, but you don't necessarily have to implement them yourself.
Unicode标准（包括其所附带的附录、技术标准、技术报告等内容）中定义了许多算法，除了我们之前提到过的之外还有很多。例如如何将文本按词或行来分段，如何保证从左往右书写和从右往左书写的内容和谐共处，如何处理正则表达式等等。这些信息都能从Unicode技术报告#[@Unicode.UnicodeTechnical]中找到，你可以逐步探索并熟悉它们。现在你知道处理文本有多复杂了。但还好，这些内容你不需要全都自己实现。

// These days, most programming languages will have a standard set of routines to get you some of the way - at the least, you can expect UTF-8 encoding support. For the rest, the [ICU Project](http://site.icu-project.org) is a set of open-source libraries maintained by IBM (with contributions by many others, of course). Check to see if your preferred programming language has an extension which wraps the ICU library. If so, you will have access to well-tested and established implementations of all the standard algorithms used for Unicode text processing.
近些年，大多数编程语言对文本处理都有不错的支持，最差也会支持UTF-8编码。对于其他的高级功能，ICU 项目#[@UnicodeConsortium.ICU]提供了一系列开源库来处理。ICU项目由许多贡献者一起创造，现在由IBM公司进行维护。它实现了所有Unicode文本处理的标准算法，而且经过了非常全面的测试，被公认为质量上乘。你可以看看现在使用的编程语言是否有对ICU库的绑定或封装。如果有的话，那通过它你就能直接用上ICU提供的各种优良的算法实现了。
