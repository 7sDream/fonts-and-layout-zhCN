#import "/template/template.typ": web-page-template
#import "/template/components.typ": note
#import "/template/lang.typ": greek, german

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## Case conversion
== 大小写转换

// We've seen that N'Ko is a unicase script; its letters have no upper case and lower case forms. In fact, only a tiny minority of writing systems, such as those based on the Latin alphabet, have the concept of upper and lower case versions of a character. For some language systems like English, this is fairly simple and unambiguous. Each of the 26 letters of the Latin alphabet used in English have a single upper and lower case. However, other languages which use cases often have characters which do not have such a simple mapping. The Unicode character database, and especially the file `SpecialCasing.txt`, provides machine-readable information about case conversion.
我们已经知道，N'ko 是一种不分大小写的#tr[script]。事实上只有很小一部分书写系统拥有大小写的概念，比如那些基于拉丁字母表的#tr[scripts]。对于类似英语的一些语言来说，大小写的概念很清晰：英语中的26个拉丁字母各自都只有一个大写形式和一个小写形式。但是其他的语言不一定也遵循这样简单的映射。Unicode#tr[character]数据库中的 `SpecialCasing.txt` 文件以机器可读的格式表述了关于大小写转换的信息。

// The classic example is German. When the sharp-s character U+00DF (ß) is uppercased, it becomes the *two* characters "SS". There is clearly a round-tripping problem here, because when the characters "SS" are downcased, they become "ss", not ß. For more fun, Unicode also defines the character U+1E9E, LATIN CAPITAL LETTER SHARP S (ẞ), which downcases to ß.
一个非常经典的例子是，德语中有一个被称为sharp s的字母#german[ß]，位于 `U+00DF`。当进行大写转换时，需要将它变成*两个*#tr[character]SS。这里显然会存在一个逆向转换的问题，因为当SS转换为小写时会是ss，而不再是#german[ß]。更有趣的是，Unicode也定义了`U+1E9E LATIN CAPITAL LETTER SHARP S`（拉丁文大写字母 Sharp S），写作 #german[ẞ]。这个#tr[character]转换成小写是#german[ß]。

#note[
  // > During the writing of this book, the Council for German Orthography (*Rat für deutsche Rechtschreibung*) has recommended that the LATIN CAPITAL LETTER SHARP S be included in the German alphabet as the uppercase version of ß, which will make everything a lot easier but rob us of a very useful example of the difficulties of case conversion.
  在本书编写过程中，德语正写法协会（#german[Rat für deutsche Rechtschreibung]）建议将`LATIN CAPITAL LETTER SHARP S`作为#german[ß]的大写形式纳入德文字母表中。这会使上述难题变得简单很多，但这样也会让我们失去一个能直观感受到大小写转换的困难程度的绝佳例子。
]

// The other classic example is Turkish. The ordinary Latin small letter "i" (U+0069) normally uppercases to "I" (U+0049) - except when the document is written in Turkish or Azerbaijani, when it uppercases to "İ". This is because there is another letter used in those languages, LATIN SMALL LETTER DOTLESS I (U+0131, ı), which uppercases to "I". So case conversion needs to be aware of the linguistic background of the text.
另一个经典例子是传统拉丁字母i（`U+0069`）。通常来说，这个字母转换为大写时会是I（U+0049），但在土耳其语或阿塞拜疆语的环境下，其大写却是İ。<position:turkish-i-uppercase>这是因为这些语言中还有另一个字母 ı（`U+0131 LATIN SMALL LETTER DOTLESS I`，拉丁文小写字母无点I），这个字母的大写才是 I。所以，大小写转换也需要考虑文本所处的语言环境。

// As well as depending on language, case conversion also depends on context. GREEK CAPITAL LETTER SIGMA (Σ) downcases to GREEK SMALL LETTER SIGMA (σ) except at the end of a word, in which case it downcases to ς, GREEK SMALL LETTER FINAL SIGMA.
除了和语言有关之外，大小写转换还需要结合上下文。#greek[Σ]（`GREEK CAPITAL LETTER SIGMA`，希腊文大写字母 Sigma）通常的小写形式为#greek[σ]（`GREEK SMALL LETTER SIGMA`，希腊文小写字母 Sigma）。但如果其出现在词尾，则小写形式会变为#greek[ς]（`GREEK SMALL LETTER FINAL SIGMA`，希腊文小写字母词尾 Sigma）。

// Another example comes from the fact that Unicode may have a *composed form* for one case, but not for another. Code point U+0390 in Unicode is occupied by GREEK SMALL LETTER IOTA WITH DIALYTIKA AND TONOS, which looks like this: ΐ. But for whatever reason, Unicode never encoded a corresponding GREEK CAPITAL LETTER IOTA WITH DIALYTIKA AND TONOS. Instead, when this is placed into upper case, three code points are required: U+0399, GREEK CAPITAL LETTER IOTA provides the Ι; then U+0308 COMBINING DIAERESIS provides the dialytika; and lastly, U+0301 COMBINING ACUTE ACCENT provides the tonos.
还有一种情况是，某些字符的一种形态的是*#tr[compose]形式*的，但另一种却不是。比如字母#greek[ΐ]（`U+0390 GREEK SMALL LETTER IOTA WITH DIALYTIKA AND TONOS`，带Dialytika和Tonos的希腊文小写字母 Iota），Unicode中没有某个单一#tr[character]对应的它的大写形态。当我们需要它的大写时，得用上三个#tr[codepoint]：`U+0399 GREEK CAPITAL LETTER IOTA`（希腊文大写字母 Iota）提供主体；`U+0308 COMBINING DIAERESIS`（组合用分音符）提供分音符（字母上方的两个点）；`U+0301 COMBINING ACUTE ACCENT`（组合用锐音符）提供声调。它们合起来才能组成大写的#greek[\u{0399}\u{0308}\u{0301}/* Ϊ́ */]。
