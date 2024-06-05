#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## The Adobe feature language
== Adobe 特性语言

// OpenType instructions - more usually known as "rules" - are normally written in a language that doesn't exactly have a name; it's known variously as "AFDKO" (from the "Adobe Font Development Kit for OpenType", a set of software tools one of which reads this syntax and adds the rules into binary font files), "Adobe feature language", "fea", or "feature format". Other ways of representing rules are available, (and inside the font they are stored in quite a different representation) but this is the most common way that we can write the rules to program our fonts.
OpenType 指令也被称为规则，它们通常由一种并没有具体名字的语言写成。人们可能会称它为“AFDKO”、“Adobe特性语言”、“fea”或者“特性格式”。其中 AFDKO 是Adobe OpenType 字体开发套件（Adobe Font Development Kit for OpenType）的简称。这种规则也有其他书写方式（比如当被储存到字体中时，就又是另一种不同的格式），但Adobe的这种格式是被最普遍使用的。

// There are a number of alternatives to AFDKO for specifying OpenType layout features - Microsoft's VOLT (Visual OpenType Layout Tool), my own FLUX (Font Layout UX), and High Logic Font creator all allow you to create features and proof and preview them visually. Monotype also has their own internal editor, FontDame, which lays out OpenType features in a text file. (I've also written an alternative syntax called FEE, which allows for extensions and plugins to add higher-level commands to the language.)
除了 AFDKO 之外还有其他编写OpenType#tr[layout]特性的工具：微软的 VOLT（Visual OpenType Layout Tool），我编写的FLUX（Font Layout UX），以及支持创建并可视化验证OpenType特性的High Logic FontCreator。蒙纳公司也有一个内部的编辑工具，叫做FontDame，它使用文本文件来编辑OpenType特性。（我也编写过一个类似的叫做 FEE 的语言，它支持使用插件和扩展来添加高级命令。）

// But Adobe's language is the one that almost everyone uses, and as a font engineer, you're going to need to know it very well. So let's begin.
但总的来说Adobe的语言还是使用最广泛的。而且作为字体设计师，你也需要对它有足够的了解，所以我们就选它了。
