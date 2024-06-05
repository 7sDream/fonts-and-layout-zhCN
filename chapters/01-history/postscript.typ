#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## PostScript
== PostScript

// Also in 1978, John Warnock was working at Xerox PARC in Palo Alto. His research project, on which he worked together with Chuck Geschke, was to develop a way of driving laser printers, describing way that the graphics and text should be laid out on a page and how they should look. Prior to this point, every printer manufacturer had their own graphics format; the idea behind the Interpress project was to create a language which could be shared between different printers. However, other manufacturers were not interested in the Interpress idea, and it also had a "careful silence on the issue of fonts",[^7] so the project was shelved.
同样是在1978年，John Warnock在施乐公司的帕洛阿尔托研究中心工作。他和同事Chuck Geschke负责研究一种描述图形和文字在页面上的排布和呈现的方法，以及由此驱动激光打印机的技术。在这之前，每家打印机制造商都有自己的图形格式，因而这个被称为Interpress的项目背后的理念就是创造一种能在不同打印机之间共享的语言。然而，其他的打印机制造商对Interpress并不感兴趣，而且因为它“对字体保持了谨慎的沉默”@Reid.PostScriptInterpress.1985，最终遭到了搁置。

// Still, it was a good idea, and Geschke and Warnock left Xerox in 1982 to found their own company to further develop the ideas of Interpress into a system called PostScript. The company was named after a small stream at the back of Warnock's house: Adobe. Adobe PostScript debuted in 1984, with the first PostScript printer appearing in 1985.
不过这仍然是一个极好的想法。随着Geschke和Warnock在1982年离开施乐并创办自己的公司，Interpress进一步发展成为了PostScript。这家公司由 Warnock家后面的一条小溪命名，它就是Adobe。Adobe PostScript在1984年首次亮相，而第一台PostScript打印机则在1985年问世。

// The first version of PostScript was not *at all* silent on the issue of fonts, and contained a number of innovations which have shaped font technology to this day. The first is the development of *hinting*. Although vector fonts can be scaled up and down in ways that bitmap fonts cannot, we mentioned that at some point, they need to be rasterized. This is evidently the case for on-screen view, where the screen is made up of discrete phosphor-coated glass, liquid crystal or LED cells; but it is also the case when the designs are printed: digital printers also work on the concept of discrete "dots" of ink.
PostScript的第一个版本对字体不再沉默，并且包含了一系列时至今日依然深刻影响字体技术的创新。其一就是*#tr[hinting]*。正如我们之前所提及的，相比#tr[bitmap]字体，尽管矢量字体可以任意放大缩小，但它们依然需要被#tr[rasterization]。显然这是出于屏幕显示的考量，毕竟屏幕是由离散的荧光玻璃、液晶或者LED单元组成的；但它也适用于印刷场景：数字打印机的工作原理也是基于离散“墨点”的。

// One way to rasterize would be to simply say that a pixel is "on" if more than a certain proportion - 50%, for example - of its surface is covered by the outline. Unfortunately, when the pixels are quite large compared to the outline (when the font is being displayed at small sizes), this strategy leads to quite unattractive results.
一种最简单的#tr[rasterization]可以描述为，如果一个像素的一部分（比如50%）落在了#tr[outline]包围的区域内，它就被“开启”。不幸的是，当像素相对于#tr[outline]比较大的时候（也就是当字体以较小尺寸显示时），这一策略将会导致糟糕的结果。

#figure(caption: [
  // The perils of simplistic rasterization
  过于简单的#tr[rasterization]带来的问题。
])[#image("bad-rasterization.png")] <figure:bad-rasterization>

// We see that key parts of serifs and strokes are missing, and that stem widths have become uneven. Rasterization can also lead to points which should be aligned (such as the tops of the downstrokes of the m) becoming misaligned, although this has not happened in this example.
从@figure:bad-rasterization 中可以看出，#tr[serif]和笔画的关键部分都有缺失，#tr[stem]的粗细也不均匀。#tr[rasterization]还会使本应对齐的点（比如m中后两笔的顶端）不再对齐，虽然图中并没有反映出来。

// *Hinting* is a way of giving information to the rasterization process to help communicate what is important about the design: which stems need to be preserved and have the same width as others, where the baselines, x-heights, cap heights and other important places are that pixels should align in nice straight lines. PostScript's hinting improved the rasterization of fonts at small point sizes.
*#tr[hinting]*会告诉#tr[rasterization]程序，对于设计师而言哪些因素是重要的：哪些#tr[stem]需要保留；哪些笔画的宽度要一致；#tr[baseline]、#tr[x-height]、#tr[cap height]和其他重要的位置信息，像素又该怎样与之对齐。通过PostScript的#tr[hinting]，小字号下的字体#tr[rasterization]效果得以大幅提升。

// The second innovation was the way that PostScript implemented curves. Whereas IKARUS used sections of circles joined together[^8] and METAFONT used cleverly computed cubic splines,[^9] PostScript represented shapes in terms of *Bézier curves*.
第二项创新则是PostScript中曲线的描述方式。与IKARUS用相连的圆弧#footnote[技术上被称为biarc@Wikipedia.Biarc。]和METAFONT用精心计算的三次样条曲线#footnote[我在这里略做了简化。METAFONT84和PostScript一样使用了三次贝塞尔曲线，但它的控制点是隐式的，由John Hobby算法自动生成，而PostScript则是显式指定。我不了解METAFONT79中的情况。]都不同，PostScript用*贝塞尔曲线*来描述形状。

// ### The Bézier Curve
=== 贝塞尔曲线

// Pierre Bézier was an engineer at Renault who specializing in the design of tools; initially these were manual tools, but in the mid 1950s he became interested in automated tools for precise drilling and milling. As manager of the technical development divison of Renault, he began work on a CADCAM (computed-aided design and manufacturing system) called UNISURF. UNISURF needed a way to allow designers to draw and manipulate curves and surfaces on a computer, both for technical drawing and design and for conversion into programs for computer-controlled machine tools.
Pierre Bézier是雷诺汽车的一位工程师，他专精于工具的设计和制造。起初都是一些手工工具，但在1950年代中期，他逐渐对能够精密钻铣的自动化工具产生兴趣。作为雷诺技术开发部主任，他开始着手研发一套CADCAM（计算机辅助设计与制造）软件，称为UNISURF。在UNISURF中，既要让设计师能在计算机上绘制和操作曲线，同时又要保证能把曲线转换为用于控制机械工具的计算机程序。

// To do this, Bézier adapted an algorithm invented by Paul de Casteljau, who was doing the same kind of things as Bézier was but over at the *other* French car company, Citroën. De Casteljau's algorithm takes a mathematical description of a curve and - essentially - rasterizes it: turning the *equation* which describes the curve into a *set of points* which can be joined together to draw the curve. Bézier's contribution - as well as popularising the de Casteljau algorithm - was to make it suitable for designers to manipulate by introducing the notion of *control points*. Bézier curves have a start point and an end point and then one or more *offcurve points* which "pull" the curve towards them.
为此，Bézier改良了一套由Paul de Casteljau发明的算法，后者和Bézier从事类似的工作，不过是在*另一家*法国汽车公司雪铁龙。de Casteljau的算法给出了曲线的一种数学描述，或者说是#tr[rasterization]的手段，即将描述曲线的*方程*转化为*一组点*，这些点可以连接在一起构成曲线。Bézier的贡献，除了推广de Casteljau的算法，还有引入了*控制点*，使得设计师能够上手操作。贝塞尔曲线包含一个起始点和一个终结点，以及一个或多个可以“拉动”曲线的*线外点*。

// Here is a Bézier curve of order three (start and end, and two off-curve points). It also known as a cubic Bézier curve because it is described using an equation which is a cubic polynomial. We'll talk about this in more detail in the next chapter.
@figure:cubic-bezier 是一条三阶贝塞尔曲线（一个起始点、一个终结点和两个线外点）。它也被称为三次贝塞尔曲线，因为也可以使用三次多项式来描述它。我们将在下一章探讨更多的细节。

#figure(caption: [
  // A cubic Bézier curve
  一条三次贝塞尔曲线。
])[#include "decasteljau.typ"] <figure:cubic-bezier>

// I have also shown three points generated by applying de Casteljau's algorithm in three places, and an approximation of the curve generated by joining the de Casteljau points with straight lines - in a sense, doing something similar to what the Linotron 202 did with the outlines of its font data.
图中我还标出了三个根据de Casteljau算法生成出来的点以及连接它们的直线，这是原曲线的一个近似——某种意义上，这和Linotron 202对字体#tr[outline]数据做的处理是类似的。

// Bézier curves were found to give the designer of curves - such as those used for Renault's car bodies - an easy and intuitive way to express the shapes they wanted. By dragging around control points, designers can "sculpt" a curve. The cubic Bézier curve, with its start and end point and two off-curve control points, was adopted into PostScript as a command for graphics drawing, and from there, it made its way into the design of digital fonts.
事实证明，贝塞尔曲线为设计师提供了一种方便且直观的方式来表达脑海中的形象——比如雷诺汽车的外轮廓。通过拖拽控制点，设计师可以自由地调整曲线。带有起始点、终结点和两个线外点的三次贝塞尔曲线被吸收进了PostScript，并作为一条图形指令。从此，它也就走进了数字字体设计的世界。
