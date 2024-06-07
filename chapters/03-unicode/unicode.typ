#import "/template/template.typ": web-page-template
#import "/template/heading.typ": chapter
#import "/template/components.typ": note
#import "/template/lang.typ": french, russian, greek

#import "/lib/glossary.typ": tr

#show: web-page-template

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
