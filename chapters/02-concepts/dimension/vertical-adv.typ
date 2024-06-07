#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ### Vertical advance
=== #tr[vertical advance]

// Not all scripts are written horizontally! Computers are still pretty bad at dealing with vertical scripts, which is why we need books like this, and why we need readers like you to push the boundaries and improve the situation.
不是所有#tr[scripts]都是水平书写的！直到现在，计算机在处理垂直#tr[scripts]时的表现依旧很差，这就是我们编写这本书的原因。我们需要像你这样的读者来帮助改善这一情况，进一步扩展技术的边界。

// In a vertical environment, the baseline is considered the middle of the glyph, and the distance to be advanced between em-squares is the *vertical advance*:
在垂直排版环境中，#tr[baseline]被放置在#tr[glyph]的中间。#tr[em square]间的步进距离称为*#tr[vertical advance]*（@figure:vertical-advance）。

#figure(
  caption: [垂直步进],
)[#include "vertical-advance.typ"] <figure:vertical-advance>

// For fonts which have mixed Latin and CJK (Chinese, Japanese, Korean), just ignore the Latin baseline and cap heights and put the glyph outlines in the middle of the em square.
对于支持 CJK（中日韩文）和拉丁字母混排的字体来说，可以忽略拉丁字母的#tr[baseline]和#tr[cap height]，将非拉丁#tr[glyph]#tr[outline]直接放置在#tr[em square]中间（@figure:vertical-2）。

#figure(
  caption: [汉字和拉丁字母混排文本],
  placement: none,
)[#include "vertical-2.typ"] <figure:vertical-2>

// > Font editors usually support vertical layout metrics for Chinese and Japanese; support for vertical Mongolian is basically non-existant. (To be fair, horizontal Mongolian doesn't fare much better.) However, the W3C (Worldwide Web Consortium) has just released the [Writing Models Level 3](https://www.w3.org/TR/css-writing-modes-3/) specification for browser implementors, which should help with computer support of vertical writing - these days, it seems to be browsers rather than desktop publishing applications which are driving the adoption of new typographic technology!
#note[
  字体编辑器通常都支持中文和日文的垂直#tr[layout]#tr[metrics]，但对垂直蒙文的支持基本上可以说是不存在。（公平的说，即使是水平蒙文也没有得到多少支持。）不过万维网联盟（Worldwide Web Consortium，W3C）刚刚发布了针对浏览器的Writing Models Level 3#[@W3C.CSSWritingLevel3.2019]实现规范，它有望帮助计算机对于垂直书写的支持更快落地。最近似乎是浏览器而不是桌面出版程序在推动新#tr[typography]技术的发展和采用。
]
