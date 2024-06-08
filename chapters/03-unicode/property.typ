#import "/template/template.typ": web-page-template
#import "/template/components.typ": note
#import "/template/lang.typ": mandingo

#import "/lib/glossary.typ": tr

#show: web-page-template

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
这就是文字处理系统能用程序从Unicode#tr[character]数据库中获取到的信息。当然，如果你真的想学习N'ko#tr[writing system]的通用知识和如何处理它们，Unicode标准本身就是一个很好的参考资料。它的 N'ko 部分（在 19.4 小节）会告诉你这种#tr[script]的起源、结构、#tr[diacritic]、标点、数字系统等方面的信息。

#note[
  // > When dealing with computer processing of an unfamiliar writing system, the Unicode Standard is often a good place to start. It's actually pretty readable and contains a wealth of information about script issues. Indeed, if you're doing any kind of heavy cross-script work, you would almost certainly benefit from getting hold of a (printed) copy of the latest Unicode Standard as a desk reference.
  当使用计算机处理一种不熟悉的#tr[writing system]时，Unicode标准通常是一个很好的起点。它的易读性其实非常强，而且包含在处理#tr[script]时会遇到的各种问题的关键信息。事实上，在进行任何繁重的跨#tr[scripts]工作时，如果在手边能有一本（纸质版的）最新版Unicode标准文档作为参考手册，必然会大有裨益。
]
