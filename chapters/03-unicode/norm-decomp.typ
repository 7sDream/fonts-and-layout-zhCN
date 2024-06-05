#import "/template/template.typ": web-page-template
#import "/template/components.typ": note, cross-ref
#import "/template/util.typ"

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## Normalization and decomposition
== #tr[normalization]和#tr[decompose] <heading:normalization-decomposition>

// The Unicode Standard has a number of stated design goals: to be *universal*, in the sense that every character in every script likely to be used on computer has an encoding; to be *efficient*, such that algorithms used by computers to input and output Unicode characters do not require too much state or overhead; and to be *unambiguous*, in that every Unicode codepoint represents the same character.
Unicode标准明面上有如下几个设计目标：通用，也即尽量#tr[encoding]所有可能在计算机中用到的所有#tr[scripts]中的所有#tr[character]；高效，处理Unicode数据的输入输出的相关算法不能引入过多的额外状态和计算开销；明确且无歧义，Unicode#tr[codepoint]和#tr[character]互相一一对应。

// But it also has an unstated design goal, which is the unstated design goal of pretty much every well-behaved piece of software engineering: *backward compatibility*. Unicode wants to maintain compatibility with all previous encoding standards, so that old documents can be reliably converted to and from Unicode without ambiguity. To a first approximation, this means every character that was ever assigned a codepoint in some encoding should be assigned a unique codepoint in Unicode.
除此之外，还有一个没有直接表述出，但和绝大多数软件工程项目一样必须考虑到的目标：*向后兼容*。Unicode希望尽量对先前的#tr[encoding]标准保持兼容，这样老旧的文档才能被可靠地在原始#tr[encoding]和Unicode间来回转换。这几乎就是说，只要先前的某个#tr[encoding]标准中有某个#tr[character]，Unicode中就必须为它赋予一个专属的#tr[codepoint]。

// This contrasts somewhat with the goal of unambiguity, as there can be multiple different ways to form a character. For instance, consider the  character n̈ (Latin small letter n with diaeresis). It occurs in Jacaltec, Malagasy, Cape Verdean Creole, and most notably, *This Is Spın̈al Tap*. Despite this obvious prominence, it is not considered noteworthy enough to be encoded in Unicode as a distinct character, and so has to be encoded using *combining characters*.
这在某种程度上和之前说的无歧义目标是相违背的。因为同一个#tr[character]在不同的古老标准中可能有不同的构建方式。比如#tr[character]n̈（带有分音符的小写拉丁字母N），它在雅卡尔泰克语、马达加斯加语、卡布佛得鲁语和著名的电影《This Is Spın̈al Tap》中都有使用。尽管如此常见，但Unicode不认为它重要到要用一个单独的#tr[character]来#tr[encoding]。最终我们用一种叫做*可#tr[combine]#tr[character]*的方式#tr[encoding]它。

// A combining character is a mark that attaches to a base character; in other words, a diacritic. To encode n̈, we take LATIN SMALL LETTER N (U+006E) and follow it with COMBINING DIAERESIS (U+0308). The layout system is responsible for arranging for those two characters to be displayed as one.
可#tr[combine]#tr[character]是附加到基本#tr[character]上的符号，也称为#tr[diacritic]。为了#tr[encoding]n̈，首先需要#tr[character]`U+006E LATIN SMALL LETTER N`（拉丁文小写字母N），然后在其后加上`U+0308 COMBINING DIAERESIS`（#tr[combine]用分音符）。#tr[layout]系统会负责将这两个#tr[character]编排显示为一个整体\u{006E}\u{0308}。

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
  我们在#cross-ref(<chapter:substitution-positioning>, web-path: "/chapters/06-features-2/features-2.typ", web-content: [后文])中会介绍的OpenType特性`ccmp`允许字体设计师按照他们希望的方式进行#tr[normalization]，可以将输入的#tr[glyph]序列重新整理成在字体内部更易处理的形式。

  // To give two examples: first, in Syriac, there's a combining character SYRIAC PTHAHA DOTTED (U+0732), which consists of a dot above and a dot below. When positioning this mark relative to a base glyph, it's often easier to position each dot independently. So, the `ccmp` feature can split U+0732 into a dot above and a dot below, and you can then use OpenType rules to position each dot in the appropriate place for a base glyph.
  这里简单举两个例子。一是在叙利亚语中有一个#tr[combine]#tr[character]`U+0732 SYRIAC PTHAHA DOTTED`（叙利亚文带点的 Pthaha），它由一上一下两个点组合而成。当需要以某个基本#tr[character]为参考来确定这个符号的所在位置时，对这两个点分别进行处理通常是更加简单的。此时就可以用`ccmp`特性将`U+0732`分成上下两个点，然后再使用OpenType规则为基本#tr[glyph]分别定义这两个点的合适位置。

  // Second, the character í (U+00ED LATIN SMALL LETTER I WITH ACUTE) is used in Czech, Dakota, Irish and other languages. Unless you've actually provided an i-acute glyph in your font, you'll get handed the decomposed string LATIN SMALL LETTER I, COMBINING ACUTE ACCENT. LATIN SMALL LETTER I has a dot on the top, and you don't want to put a combining acute accent on *that*. `ccmp` will let you swap out the "i" for a dotless "ı" before you add your accent to it.
  第二个例子是#tr[character]í（`U+00ED LATIN SMALL LETTER I WITH ACUTE`，带锐音符的拉丁文小写字母I）。这个字母在捷克语、达科他语、爱尔兰语等语言中都会用到。一般而言，只要字体里没有单独为它绘制#tr[glyph]的话，都会将它#tr[decompose]为字母i和锐音符两个部分来处理。但是i上面有一个小点，我们不能直接将锐音符放在点的上面。这时`ccmp`特性允许我们在添加锐音符之前将字母i替换成没有点的ı。
]
