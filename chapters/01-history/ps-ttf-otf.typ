#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## PostScript Fonts, TrueType and OpenType
// 这里和原文意思不一样是有意的
// 主要是因为本段其实没有 OpenType 的相关内容
// 而且作为标题过长，酌情修改
== 从 PostScript 到 TrueType

// PostScript level 1 defined two kinds of fonts: Type 1 and Type 3. PostScript Type 3 fonts were also allowed to use the full capabilities of the PostScript language. Prior to this level, fonts could only be specified in terms of graphics instructions: draw a line, draw a curve, and so on. But PostScript is a fully-featured programming language. When we talk about a "PostScript printer", what we mean is a printer which contains a little computer which can "execute" the documents they are sent, because these documents are actually *computer programs* written in the PostScript language. (The little computers inside the printers tended not to be very powerful, and one common prank for bored university students would be to send the printers [ridiculously complicated programs](https://www.pvv.ntnu.no/~andersr/fractal/PostScript.html) which drew pretty graphics but tied them up with computations for hours.)
PostScript Level 1 规定了两种字体格式：Type 1 和 Type 3。PostScript Type 3字体还支持完整的 PostScript语言。在这之前，字体只能用图形指令来描述，比如画一条直线、画一个圆之类。但PostScript是一个全功能的编程语言。当我们在说“PostScript 打印机”时，我们指的其实是一台其内部的计算机能够“执行”收到的文档的打印机。这些文档本身也只是用PostScript语言写成的*计算机程序*。（打印机中集成的计算机往往性能不强，对于无聊的大学生们来说，一个常见的恶作剧就是把极端复杂的程序#[@Reggestad.PostScriptFractals.2006]发送给打印机，这些程序可以画出漂亮的图形，但却要花好几个小时进行计算。）

// Not many font designers saw the potential of using the programming capabilities of PostScript in their fonts, but one famous example which did was Erik van Blokland and Just van Rossum's *FF Beowolf*. Instead of using the PostScript `lineto` and `curveto` drawing commands to make curves and lines, Erik and Just wrote their own command called `freakto`, which used a random number generator to distort the positions of the points. Every time the font was called upon to draw a character, the random number generator was called, and a new design was generated - deconstructing the concept of a typeface, in which normally every character is reproduced identically.
提前看到在字体中运用PostScript程序的潜力的字体设计师并不多，其中一个著名的例子是Erik van Blokland和Just van Rossum设计的*FF Beowolf*（@figure:beowolf）。他们没有直接使用PostScript的`lineto`和`curveto`指令来绘制曲线和直线，而是自己实现了一个`freakto`指令，它使用随机数生成器来扭曲点的位置。每当需要来绘制一个#tr[character]时，字体就会调用随机数生成器，并生成一个新的设计。这其实解构了字体的概念，毕竟在我们的印象中，字体里的每个#tr[character]总是以相同的样子出现。

#figure(
  caption: [
    FF Beowolf字体中的字母e。
  ],
  image("beowolf.jpg", width: 60%),
) <figure:beowolf>

// While (perhaps thankfully) the concept of fully programmable fonts did not catch on, the idea that the font itself can include instructions about how it should appear in various contexts, the so-called "smartfont", became an important idea in subsequent developments in digital typography formats - notable Apple's Advanced Typography and OpenType.
尽管完全可编程字体的概念并没有流行开来（也许幸亏如此），但字体本身可以含有如何在各种情形下显示的指令（即所谓“智能字体”）的想法在后来数字#tr[typography]技术的发展中变得非常重要。在Apple Advanced Typography和OpenType中尤其如此。

// Type 3 fonts were open to everyone - Adobe published the specification for how to generate Type 3 fonts, allowing anyone to make their own fonts with the help of font editing tools such as Altsys' Fontographer. But while they allowed for the expressiveness of the PostScript language, Type 3 fonts lacked one very important aspect - hinting - meaning they did not rasterize well at small sizes. If you wanted a professional quality Type 1 font, you had to buy it from Adobe, and they kept the specification for creating Type 1 fonts to themselves. Adobe commissioned type designs from well-known designers and gained a lucrative monopoly on high-quality digital fonts, which could only be printed on printers with Adobe PostScript interpreters.
Type 3 字体向所有人开放——Adobe公开了生成Type 3 字体的规范，允许任何人通过字体编辑软件，诸如Altsys公司的Fontographer等来制作自己的字体。虽然Type 3 字体中允许使用PostScript语言强大的表现力，但它仍然缺少一个非常重要的东西——#tr[hinting]。这也意味着它们在小尺寸下的#tr[rasterization]效果不够理想。如果要使用专业质量的Type 1 字体，则必须从Adobe购买，他们没有公开创建Type 1 字体的规范。Adobe委托著名设计师创作了一系列高质量字体，并由此达成了利润丰厚的垄断。这些字体只能在使用Adobe PostScript解释器的打印机上进行打印。

// By this time, Apple and Microsoft had attempted various partnerships with Adobe, but were locked out of development - Adobe jealously guarded its PostScript Type 1 crown jewels. In 1987, they decided to counter-attack, and work together to develop a scalable font format designed to be rasterized and displayed on the computer, with the rasterizer built into the operating system. In 1989, Apple sold all its shares in Adobe, and publicly announced the TrueType format at the Seybold Desktop Publishing Conference in San Francisco. The font wars had begun.
那时，苹果和微软尝试与Adobe建立各种合作，但都被挡在了门外——Adobe把PostScript Type 1当作掌上明珠。于是在1987年他们决定反击，开始共同开发一种可缩放的字体格式。这一格式为#tr[rasterization]和屏幕显示而设计，而且在操作系统中内置了相应的#tr[rasterization]程序。1989年，Apple出售了他们手中Adobe的全部股份，并在旧金山的Seybold桌面出版大会上公开发布了TrueType格式。字体大战开始了。#footnote[#cite(form: "prose", <Shimada.FontWars.2006>)是对那个时代的极好的历史回顾。]

// This was one of the factors which caused Adobe to break its own monopoly position in 1990. They announced a piece of software called "Adobe Type Manager", which rendered Type 1 fonts on the computer instead of the printer. (It had not been written at the time of announcement, but this was intended as a defensive move to keep people loyal to the PostScript font format.) The arrival of Adobe Type Manager had two huge implications: first, by rendering the fonts on the computer, the user could now see the font output before printing it. Second, now PostScript fonts could be printed on any printer, including those with (cheaper) Printer Command Language interpreters rather than the more expensive PostScript printers. These two factors - "What You See Is What You Get" fonts printable on cheap printers - led to the "desktop publishing" revolution. At the same time, they also published the specifications for Type 1 fonts, making high quality typesetting *and* high quality type design available to all.
这是导致Adobe在1990年自发打破其垄断地位的因素之一。他们宣布推出一款名为Adobe Type Manager的软件，它能在计算机而非打印机上渲染并显示 Type 1 字体。（这一软件在发布时其实还没有写出来，这是为了让人们忠于PostScript格式而采取的一种防御措施。）Adobe Type Manager的出现带来了两大影响：首先，通过在计算机上渲染字体，用户在打印之前就能看到字体的输出。其次，现在PostScript字体可以在任何打印机上打印，这不仅包括昂贵的PostScript打印机，也包括了使用打印机命令语言解释器的（很便宜的）那种。这两个因素——可在廉价打印机上使用的“所见即所得”字体——引发了“桌面出版”革命。于此同时，他们还公开了Type 1 字体的规范，使得所有人都可以使用高质量的#tr[typeset]*和*字体设计。
