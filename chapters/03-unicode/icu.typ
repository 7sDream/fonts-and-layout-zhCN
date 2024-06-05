#import "/template/template.typ": web-page-template
#import "/template/components.typ": note
#import "/template/util.typ"

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## ICU
== ICU 程序库

// For those of you reading this book because you're planning on developing applications or libraries to handle complex text layout, there's obviously a lot of things in this chapter that you need to implement: UTF-8 encoding and decoding, correct case conversion, decomposition, normalization, and so on.
如果你阅读本书的原因是想开发一个处理复杂文本布局的应用或程序库，可能会发现上面介绍的过的许多概念都需要实现。比如UTF-8的编解码，正确的大小写转换，字符串的#tr[decompose]和#tr[normalization]等等。

// The Unicode Standard (and its associated Unicode Standard Annexes, Unicode Technical Standards and Unicode Technical Reports) define algorithms for how to handle these things and much more: how to segment text into words and lines, how to ensure that left-to-right and right-to-left text work nicely together, how to handle regular expressions, and so on. It's good to be familiar with these resources, available from [the Unicode web site](http://unicode.org/reports/), so you know what the issues are, but you don't necessarily have to implement them yourself.
Unicode标准（包括其所附带的附录、技术标准、技术报告等内容）中定义了许多算法，除了我们之前提到过的之外还有很多。例如如何将文本按词或行来分段，如何保证从左往右书写和从右往左书写的内容和谐共处，如何处理正则表达式等等。这些信息都能从Unicode技术报告#[@Unicode.UnicodeTechnical]中找到，你可以逐步探索并熟悉它们。现在你知道处理文本有多复杂了。但还好，这些内容你不需要全都自己实现。

// These days, most programming languages will have a standard set of routines to get you some of the way - at the least, you can expect UTF-8 encoding support. For the rest, the [ICU Project](http://site.icu-project.org) is a set of open-source libraries maintained by IBM (with contributions by many others, of course). Check to see if your preferred programming language has an extension which wraps the ICU library. If so, you will have access to well-tested and established implementations of all the standard algorithms used for Unicode text processing.
近些年，大多数编程语言对文本处理都有不错的支持，最差也会支持UTF-8编码。对于其他的高级功能，ICU 项目#[@UnicodeConsortium.ICU]提供了一系列开源库来处理。ICU项目由许多贡献者一起创造，现在由IBM公司进行维护。它实现了所有Unicode文本处理的标准算法，而且经过了非常全面的测试，被公认为质量上乘。你可以看看现在使用的编程语言是否有对ICU库的绑定或封装。如果有的话，那通过它你就能直接用上ICU提供的各种优良的算法实现了。
