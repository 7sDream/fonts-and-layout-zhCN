#import "/template/heading.typ": chapter
#import "/template/components.typ": note, title-ref

#import "/lib/glossary.typ": tr

#chapter[
  // A Brief History of Type
  字体简史
]

// Once upon a time, a *font* was a bunch of pieces of metal. The first recorded use of metal type for printing comes from China. In 13th century, banknotes were printed with anti-counterfeit devices printed using blocks of bronze;[^2] the first metal type books were produced in Korea around the same time.[^1] Two hundred years later, Johannes Gutenberg came up with a similar system for creating metal type that would spread rapidly over Europe and continue to be the most common means of printing until the 19th century.
在很久以前，*字体*这个词指的是一堆金属块。关于金属印刷的最早记录来自中国。在13世纪，带有防伪措施的纸币就已经使用铜版来印制@Pan.ZhongGuo.2001[273]；几乎同一时间，朝鲜半岛也首次出现了金属印刷的书籍@Park.HistoryPreGutenberg.2014。两百年之后，Johannes Gutenberg发明了一种类似的金属活字系统，它很快传遍了欧洲，并且作为最普遍的印刷技术一直延续到19世纪。

// To create type for printing, engravers would work the images of letters, numbers and so on into punches. Punches would then be struck into a mold called a *matrix*. The typemaker would then use the matrices to cast individual pieces of type (also known as *sorts*). A complete set of type sorts in the same size and style was collected together into a *font* of type.
为了制作印刷用字，刻字师会将字母、数字等的图形雕刻在#tr[punch]上，字冲则会被敲入称为*#tr[matrix]*的模具中。接下来，铸字师会用#tr[matrix]翻刻出一个个的字，这被称为*#tr[sort]*。同样尺寸和样式的一组#tr[sort]就构成了一套*字体*（@figure:fonts）。

#figure(caption: [
  // A box of fonts cast by the Australian Type Foundry. The font on the top left is a 14pt Greek typeface by Eric Gill.
  一套Australian Type Foundry铸造的字体。左上是Eric Gill设计的 14pt 希腊字母。
])[
  #image("fonts.jpg")
] <figure:fonts>

// Complete fonts of type would be placed into type cases, from which compositors would then select the sorts required to print a page and arrange them into lines and pages. Next, the printer would cover the face of the metal with ink and impress it onto the paper. With the advent of hot metal typesetting, which combined casting and compositing into one automated activity, the idea of a font of type fell out of fashion.
一套完整的字体会被放在#tr[type case]中，排版工将从中挑选出排版所需的#tr[sort]，并将它们逐行、逐页地排好。之后，印刷机会在金属的表面覆盖一层油墨，再压印到纸上。随着将铸字与排版合二为一的#tr[hot metal typesetting]的诞生，成套的印刷字体也逐渐落后于潮流。

// The idea was revived with the advent of digital typography. In 1964, the IBM 2260 Display Station provided one of the first text-based visual interfaces to a computer.[^3] The mainframe computer would generate the video signal and send it to the terminal, pixel by pixel: each character was 9 pixels wide and 14 pixels tall. The choice of bitmaps for each character, what we would now call the font, was hard-wired into the mainframe, and could not be changed.
随着数字印刷术的出现，这个想法又得以复兴。1964年，IBM 2260 Display Station 为计算机提供了第一个基于文本的可视化界面@DaCruz.IBM2260.2001。大型机生成视频信号，并将其逐像素发送到终端：每个字符9像素宽、14像素高。代表字符的这些#tr[bitmap]（我们今天称为字体）是被硬编码在大型机中的，无法进行修改。

// Much has changed since the early bitmap fonts, but in a sense one thing has not. The move from Gutenberg's rectangular metal sorts to rectangular 9x14 digital bitmaps ensured that computer typography would be dominated by the alignment of rectangles along a common baseline - an unfortunate situation for writing systems which don't consist of a straight line of rectangles.
从早期的#tr[bitmap]到今天，字体已经有了天翻地覆的变化，但有样东西却从未变过。从Gutenberg使用的矩形金属活字，到9x14的数字#tr[bitmap]，它们决定了计算机字体技术的主要实现方式：沿着一条#tr[baseline]排列矩形块。这对那些不依靠直线和矩形的#tr[writing system]来说是一件不幸的事。

#figure(caption: [
  // No OpenType for you!
  你可没有 OpenType！
])[#image("640px-Ghafeleye_Omr.svg.png")] <figure:Ghafeleye_Omr>

// This is one of the reasons why I'm starting this book with a description of digital font history: the way that our fonts have developed over time also shapes the challenges and difficulties of working with fonts today. At the same time, the history of digital fonts highlights some of the challenges that designers and implementers have needed to overcome, and will equip us with some concepts that we will get further into as we go through this book. So even if you're not a history fan, please don't skip this chapter - I'll try and make it as practical as possible.
这就是我把数字字体的历史作为本书开端的原因。随着时间的推移，字体的发展历程也造就了今天我们设计、实现和使用字体时的困难和挑战。不过通过本书的后续介绍，这段历史更能让我们了解一些在处理这些难题时需要用到的重要概念。所以即使你不是一个历史迷，也请不要跳过这一章——我会让它尽可能的实用。

// For example, then, in the case of the wonderful Nastaleeq script above, we can understand why this is going to be difficult to implement as a digital font. We can understand the historical reasons behind why this situation has come about. At the same time, it highlights a common challenge for the type designer working with global scripts, which is to find ways of usefully mapping the computer's Latin-centered model of baselines, bounding boxes, and so on, onto a design in which these structures may not necessarily apply. Some of these challenges can be overcome through developments in the technology; some of them will need to be worked around. We will look at these challenges in more detail over the course of the book.
例如，在@figure:Ghafeleye_Omr 所示的波斯体#tr[script]例子中，我们将能够理解为什么把它做成数字字体会很困难。我们可以理解这种情况产生的历史原因。与此同时，它也展现了#tr[global scripts]字体设计师经常面临的难题，即寻找一种把计算机中以拉丁字母为中心的模型——包括#tr[baseline]、#tr[bounding box]等——对应到设计中的手段，而这些东西在设计中却不一定适用。其中的一些挑战可以凭借技术的发展来克服，而有些问题则需要找寻变通的方案。在本书中，我们后续会更为详细地探讨这些挑战。

// Digital fonts go vector
== 矢量化的数字字体

// As we saw, the first computer fonts were stored in *bitmap* (also called *raster*) format. What this means is that their design was based on a rectangular grid of square pixels. For a given glyph, some portion of the grid was turned on, and the rest turned off. The computer would store each glyph as a set of numbers, 1 representing a pixel turned on and 0 representing a pixel turned off - a one or zero stored in a computer is called a *bit*, and so the instructions for drawing a letter were expressed as a *map* of *bits*:
我们提到过，第一个计算机字体是储存在*#tr[bitmap]*（Bitmap）或者说*#tr[raster]*（Raster）格式中的。这意味着它们的设计基于方形像素组成的网格。对于给定的#tr[glyph]，网格的一部分开启显示，其余则关闭。计算机会把每个#tr[glyph]储存为一组数字，1代表像素开启，0 代表像素关闭。计算机中储存的0或1被称为*比特*（bit），因而绘制一个字母的指令即可表述为一组比特的*映射*（map）。

#figure(caption: [
  // Capital aleph, from the Hebrew version of the IBM CGA 8x8 bitmap font.
  字母 Aleph，来自 IBM CGA 8x8 #tr[bitmap]字体的希伯来文版。
])[#include "aleph.typ"] <figure:aleph>

// This design, however, is not *scalable*. The only way to draw the letter at a bigger point size is to make the individual pixels bigger squares, as you can see on the right. The curves and diagonals, such as they are, become more "blocky" at large sizes, as the design does not contain any information about how they could be drawn more smoothly. Perhaps we could mitigate this by designing a new aleph based on a bigger grid with more pixels, but we would find ourselves needing to design a new font for every single imaginable size at which we wish to use our glyphs.
然而，这种设计并不是*可缩放*的。绘制更大尺寸字母的唯一方法就是使单个像素的方块更大，就像你在@figure:aleph 中看到的那样。像这样的曲线和斜线在大尺寸下会呈现出“块状感”，因为设计中完全没有包含如何使它们更平滑的信息。也许可以通过重新设计一个基于更大的网格和更多像素的Aleph字母来缓解这个问题。但我们立刻就会发现，这样就需要为这些#tr[glyph]的每个尺寸单独设计一套新的字体。

// At some point, when we want to see our glyphs on the screen, they will need to become bitmaps: screens are rectangular grids of square pixels, and we will need to know which ones to turn on and which ones to turn off. But we've seen that, while this is necessary to represent a *particular* glyph at a *particular* size, this is a bad way to represent the design of the glyph. If you think back to metal fonts, punchcutters and metalworkers would produce a new set of type for each distinct size at which the type was used, but underlying this was a single design. With a bitmap font, you have to do the punchcutting work yourself, translating the design idea into a separate concrete instance for each size. What we'd like to do is represent the *design idea*, so that the same font can be used at any type size.
在某种意义上，当我们想在屏幕上看到#tr[glyph]时，它们必须是#tr[bitmap]。因为屏幕是正方形像素组成的矩形网格，我们需要知道哪些像素应当开启、哪些又应当关闭。但我们已经看到，尽管当显示特定尺寸的#tr[glyph]时这一手段是必要的，但这对于#tr[glyph]的设计而言是一种糟糕的方式。回顾一下金属字体，刻字师和铸字师会为每种尺寸单独做一套#tr[type]，而它们都是基于相同的设计。使用#tr[bitmap]字体时，你却需要承担刻字师的工作，把设计转换为不同尺寸的具体实例。我们想做的是表现*设计理念*，以便相同的字体可以用于任何尺寸。

// We do this by telling the computer about the outlines, the contours, the shapes that we want to see, and letting the computer work out how to turn that into a series of ones and zeros, on pixels and off pixels. Because we want to represent the design not in turns of ones and zeros but in terms of lines and curves, geometric operations, we call this kind of representation a *vector* representation. The process of going from a vector representation of a design to a bitmap representation to be displayed is called *rasterization*, and we will look into it in more detail later.
为此，我们需要告诉计算机想看到的#tr[outline]形状，并让它计算出那些代表像素开启或关闭的0和1。此时我们不再用0和1来承载设计，而是用直线、曲线和几何操作，这被称为*矢量*表示。从矢量表示转化为最终显示的#tr[bitmap]表示的过程称为*#tr[rasterization]*。之后我们将对此做进一步探讨。

// The first system to represent typographical information in geometrical, vector terms - in terms of the lines and curves which make up the abstract design, not the ones and zeros of a concrete instantiation of a letter - was Dr Peter Karow's IKARUS system in 1972.[^4] The user of IKARUS (so called because it frequently crashed) would trace over a design using a graphics tablet, periodically clicking along the outline to add *control points* to mark the start point, a sharp corner, a curve, or a tangent (straight-to-curve transition):
第一个用几何矢量化形式——即描绘抽象设计的直线和曲线，而不是描述具体实例的0和1——来描述字体信息的系统是1972年Peter Karow博士发明的IKARUS@Karow.DigitalTypography.2013。起这个名字是因为它经常崩溃（IKARUS 读音类似 I crashed）。用户会使用数位板来描摹设计图，通过单击轮廓线来添加*控制点*，从而标记起始点、转角、曲线或切线（直线到曲线的过渡），见@figure:ikarus。

#figure(caption: [
  // A glyph in IKARUS, showing start points (red), straight lines (green), curve-to-straight tangents (cyan) and curves (blue).
  IKARUS 中的一个#tr[glyph]。标记出了起始点（红色）、直线（绿色）、曲线到直线的切点（青色）和曲线（蓝色）。
])[#image("ikarus.png")] <figure:ikarus>

// The system would join the line sections together and use circular arcs to construct the curves. By representing the *ideas* behind the design, IKARUS could automatically generate whole systems of fonts: not just rasterizing designs at multiple sizes, but also adding effects such as shadows, outlines and deliberate distortions of the outline which Karow called "antiquing". By 1977, IKARUS also supported interpolation between multiple masters; a designer could draw the same glyph in, for example, a normal version "A" and a bold version "B", and the software would generate a semi-bold by computing the corresponding control points some proportion of the way between A and B.
该系统使用首尾相连的圆弧来构造曲线。通过展现设计背后的“想法”，IKARUS可以自动生成整套字体。它不仅可以将设计#tr[rasterization]为不同的尺寸，还可以添加如阴影、轮廓以及Karow称之为“复古化（antiquing）”的故意扭曲轮廓的效果。到1977年，IKARUS还支持了#tr[multiple master]之间的插值。例如，设计师可以为常规版本的A和粗体的B绘制/*相同的？*/字形，软件会通过在A和B之间按某一比例计算出控制点来生成半粗体。

// In that same year, 1977, the Stanford computer scientist Don Knuth began work on a very different way of representing font outlines. His METAFONT system describes glyphs *algorithmically*, as a series of equations. The programmer - and it does need to be a programmer, rather than a designer - states that certain points have X and Y coordinates in certain relationships to other points; unlike IKARUS which describes outer and inner outlines and fills in the interior of the outline with ink, METAFONT uses the concept of a *pen* of a user-defined shape to trace the curves that the program specifies. Here, for example, is a METAFONT program to draw a "snail":
同样是在1977年，斯坦福大学的计算机科学家Donald Knuth开始研究一种非常不同的字体#tr[outline]表示方法。他的 METAFONT 系统将#tr[glyph]*以算法的方式*描述为一系列方程。程序员——它的确需要一位程序员，而不仅仅是一位设计师——声明某些点的X、Y坐标，以及点和点之间关系。与IKARUS描述内外#tr[outline]并用墨水填满内部不同，METAFONT 使用“笔”的概念，通过用户定义的形状描绘程序规定的曲线。例如这个用于绘制“涡形”的 METAFONT 程序:

/*
```
% Define a broad-nibbed pen held at a 30 degree angle.
pen mypen;
mypen := pensquare xscaled 0.05w yscaled 0.01w rotated 30;

% Point 1 is on the baseline, a quarter of the way along the em square.
x1 = 0.25 * w; y1 = 0;

% Point 2 is half-way along the baseline and at three-quarter height.
x2 = 0.5 * w; y2 = h * 0.75;

% Point 3 is below point 2 and parallel with point 1.
x3 = x2; y3 = y1;

% Point 4 is half way between 1 and 3 on the X axis and a quarter of
% the way between 2 and 1 on the Y axis.
x4 = (x1 + x3) / 2;
y4 = y1 + (y2-y1) * 0.25;

% Use our calligraphic pen
pickup mypen;

% Join 1, 2, 3 and 4 with smooth curves, followed by a line back to 1.
draw z1..z2..z3..z4--z1;
```
*/

// TODO: METAFONT syntax highlight
```
% 定义一支以 30 度角握住的宽头笔
pen mypen;
mypen := pensquare xscaled 0.05w yscaled 0.01w rotated 30;

% 点1位于基线上，宽度1/4 em的位置
x1 = 0.25 * w; y1 = 0;

% 点2位于半宽、3/4高的位置
x2 = 0.5 * w; y2 = h * 0.75;

% 点3在点2下方，和点1同高
x3 = x2; y3 = y1;

% 点4的横坐标位于点1、3的中点，纵坐标位于点1、2的1/4处
x4 = (x1 + x3) / 2; y4 = y1 + (y2-y1) * 0.25;

% 使用定义的书法笔
pickup mypen;

% 以光滑曲线连结点1、2、3、4，再用直线连回点1
draw z1..z2..z3..z4--z1;"
```

// The glyph generated by this program looks like so:
此程序生成的#tr[glyph]如下：

#figure(caption: [
  // A METAFONT snail.
  用 METAFONT 绘制的涡形。
], placement: none)[#image("metafont.png")] <figure:metafont-snail>

// The idea behind METAFONT was that, by specifying the shapes as equations, fonts then could be *parameterized*. For example, above we declared `mypen` to be a broad-nibbed pen. If we change this one line to be `mypen := pencircle xscaled 0.05w yscaled 0.05w;`, the glyph will instead be drawn with a circular pen, giving a low-contrast effect. Better, we can place the parameters (such as the pen shape, serif length, x-height) into a separate file, create multiple such parameter files and generate many different fonts from the same equations.
METAFONT 的理念是，通过方程的形式指定形状，字体就可以被*参数化*。例如，上面我们把`mypen`声明为一支宽头笔。如果我们把这一行代码改为```metafont mypen := pencircle xscaled 0.05w yscaled 0.05w;```，就可以获得低对比度的效果，类似于使用圆珠笔绘制。更好的方法是，我们可以把参数（例如笔的形状、衬线长度、#tr[x-height]）等放进单独的文件；一旦创建了多个这样的参数文件，就可以从同一组方程生成许多不同的字体。

// However, METAFONT never really caught on, for two reasons. The first is that it required type designers to approach their work from a *mathematical* perspective. As Knuth himself admitted, "asking an artist to become enough of a mathematician to understand how to write a font with 60 parameters is too much." Another reason was that, according to Jonathan Hoefler, METAFONT's assumption that letters are based around skeletal forms filled out by the strokes of a pen was "flawed";[^5] and while METAFONT does allow for defining outlines and filling them, the interface to this is even clunkier than the `draw` command shown above. However, Knuth's essay on "the concept of a meta-font"[^6] can be seen as sowing the seeds for today's variable font technology.
然而，METAFONT从未真正流行起来，原因有二。首先，它要求字体设计师用*数学*的方法来工作。Knuth 自己也承认，“要求一个艺术家像数学家那样用60个参数来绘制字体实在是太过分了。”其次，根据 Jonathan Hoefler 的说法，METAFONT 中字母由笔画沿着骨架而构建起来的假设其实是“有缺陷的”@Hoefler.JonathanHoefler.2015；尽管METAFONT确实允许定义#tr[outline]并进行填充，但其接口比上面所示的`draw`命令更加繁琐。不过无论如何，Knuth关于Meta-Font的论文#[@Knuth.ConceptMetaFont.1982]依然可以被认为是为如今的可变字体技术埋下了种子。

// As a sort of bridge between the bitmap and vector worlds, the Linotron 202 phototypesetter, introduced in 1978, stored its character designs digitally as a set of straight line segments. A design was first scanned into a bitmap format and then turned into outlines. Linotype-Paul's "non-Latin department" almost immediately began working with the Linotron 202 to develop some of the first Bengali outline fonts; Fiona Ross' PhD thesis describes some of the difficulties faced in this process and how they were overcome.[^10]
作为#tr[bitmap]和矢量世界之间的一座桥梁，Linotron 202照排机于1978年推出，它通过一组直线段来储存#tr[character]的设计。设计稿首先被扫描成#tr[bitmap]格式，然后再被转换成#tr[outline]。Linotype-Paul的非拉丁部门几乎立即就开始用Linotron 202开发首批孟加拉文字体；Fiona Ross的博士论文@Ross.EvolutionPrinted.1988 描述了这一过程中所面临的一些困难，以及他们是如何解决的。#footnote[另外，#cite(form: "prose", <Condon.ExperienceMergenthaler.1980>) 是对202照排机内部技术的极为精彩的研究。]

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

// ## PostScript Fonts, TrueType and OpenType
== PostScript字体、TrueType 和 OpenType

// PostScript level 1 defined two kinds of fonts: Type 1 and Type 3. PostScript Type 3 fonts were also allowed to use the full capabilities of the PostScript language. Prior to this level, fonts could only be specified in terms of graphics instructions: draw a line, draw a curve, and so on. But PostScript is a fully-featured programming language. When we talk about a "PostScript printer", what we mean is a printer which contains a little computer which can "execute" the documents they are sent, because these documents are actually *computer programs* written in the PostScript language. (The little computers inside the printers tended not to be very powerful, and one common prank for bored university students would be to send the printers [ridiculously complicated programs](https://www.pvv.ntnu.no/~andersr/fractal/PostScript.html) which drew pretty graphics but tied them up with computations for hours.)
PostScript Level 1 规定了两种字体格式：Type 1 和 Type 3。PostScript Type 3字体还支持完整的 PostScript语言。在这之前，字体只能用图形指令来描述，比如画一条直线、画一个圆之类。但PostScript是一个全功能的编程语言。当我们在说“PostScript 打印机”时，我们指的其实是一台其内部的计算机能够“执行”收到的文档的打印机。这些文档本身也只是用PostScript语言写成的*计算机程序*。（打印机中集成的计算机往往性能不强，对于无聊的大学生们来说，一个常见的恶作剧就是把极端复杂的程序#[@Reggestad.PostScriptFractals.2006]发送给打印机，这些程序可以画出漂亮的图形，但却要花好几个小时进行计算。）

// Not many font designers saw the potential of using the programming capabilities of PostScript in their fonts, but one famous example which did was Erik van Blokland and Just van Rossum's *FF Beowolf*. Instead of using the PostScript `lineto` and `curveto` drawing commands to make curves and lines, Erik and Just wrote their own command called `freakto`, which used a random number generator to distort the positions of the points. Every time the font was called upon to draw a character, the random number generator was called, and a new design was generated - deconstructing the concept of a typeface, in which normally every character is reproduced identically.
提前看到在字体中运用PostScript程序的潜力的字体设计师并不多，其中一个著名的例子是Erik van Blokland和Just van Rossum设计的*FF Beowolf*（@figure:beowolf）。他们没有直接使用PostScript的`lineto`和`curveto`指令来绘制曲线和直线，而是自己实现了一个`freakto`指令，它使用随机数生成器来扭曲点的位置。每当需要来绘制一个#tr[character]时，字体就会调用随机数生成器，并生成一个新的设计。这其实解构了字体的概念，毕竟在我们的印象中，字体里的每个#tr[character]总是以相同的样子出现。

#figure(
  placement: bottom,
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

// ## From TrueType to OpenType
== 从TrueType到OpenType

// But it was to no avail. There were many reasons why TrueType ended up winning the font wars. Some of these were economic in nature: the growing personal computer market meant that Microsoft and Apple had tremendous influence and power while Adobe remained targeting the high-end market. But some were technical: while PostScript fonts never really advanced beyond their initial capabilities, TrueType was constantly being developed and extended.
但这都无济于事。TrueType最终赢得字体大战的原因有很多。一些是经济上的：不断增长的个人计算机市场意味着微软和苹果有着巨大的影响和力量，而Adobe却仍将目标对准高端市场。另一些则是技术上的：PostScript 字体从未真正超出其初始功能，但TrueType则一直在不断开发和扩展。

// Apple extended TrueType, first as "TrueType GX" (to support their "QuickDraw GX" typography software released in 1995) and then as Apple Advanced Typography (AAT) in 1999. TrueType GX and AAT brought a number of enhancements to TrueType: ligatures which could be turned on and off by the user, complex contextual substitutions, alternate glyphs, and font variations (which we will look at in the next section). AAT never hit the big time; it lives on as a kind of typographic parallel universe in a number of OS X fonts (the open source font shaping engine Harfbuzz recently gained support for AAT). Its font variation support was later to be adopted as part of OpenType variable fonts, but the rest of its extensions were to be eclipsed by another development on top of TrueType: OpenType.
苹果扩展了TrueType。首先是TrueType GX（以支持其1995年发布的QuickDraw GX印刷软件），然后是1999年的Apple Advanced Typography（AAT）。TrueType GX和AAT大幅扩充了TrueType的功能：允许用户决定是否启用的#tr[ligature]、复杂的#tr[contextual]#tr[substitution]、#tr[alternate glyph]和字体变体（我们将在下一节中介绍）。但AAT也没有大获成功，它仅以几个OS X字体的形式存在于#tr[typography]的平行宇宙中（开源的字体#tr[shaping]引擎HarfBuzz最近支持了AAT）。它其中大部分扩展被基于TrueType开发的OpenType所彻底掩盖，字体变体则被吸收为OpenType#tr[variable font]功能的一部分。

// In 1997, Microsoft and Adobe made peace. They worked to develop their own set of enhancements to TrueType, which they called TrueType Open (Microsoft's software strategy throughout the 1990s was to develop software which implemented a public standard and extend it with their own feature enhancements, marginalizing users of the original standard. TrueType Open was arguably another instance of this...); the renderer for TrueType Open, Uniscribe, was added to the Windows operating system in 1999.
1997年，微软和Adobe达成了和解。他们致力于开发自己的TrueType扩展集，称为TrueType Open（Microsoft在1990年代的软件战略是开发符合公共标准的软件，并加入自己的增强功能以对其进行扩展，从而使原始标准的用户处于边缘地位。TrueType Open可以说是这种情策略的一个例子）。TrueType Open的渲染器，Uniscribe，于1999年集成进Windows操作系统。

// Later called OpenType, the development of this new technology was led by David Lemon of Adobe and Bill Hill of Microsoft,[^12] and had the design goal of *interoperability* between TrueType fonts and Adobe Type 1 PostScript fonts. In other words, as well as being an updated version of TrueType to allow extended typographic refinements, OpenType was essentially a *merger* of two very different font technologies: TrueType and PostScript Type 1. As well as being backwardly compatible with TrueType, it allowed PostScript Type 1 fonts to be wrapped up in a TrueType-like wrapper - one font format, containing two distinct systems.
这项新技术后来被称为OpenType，由Adobe的David Lemon和微软的Bill Hill领导开发#footnote[
  // When Microsoft were working on TrueType Open before the tie-up with Adobe, the technical development was led by Eliyezer Kohen and Dean Ballard.
  在微软和Adobe的合作开始前，TrueType Open由Eliyezer Kohen和Dean Ballard领导开发。
]，其设计目标是在TrueType字体和Adobe PostScript Type 1 字体之间实现*互通*。换句话说，OpenType不仅是添加了高级#tr[typography]功能的TrueType改进版，而且本质上是TrueType 和 PostScript Type 1这两种非常不同的字体技术的*并集*。除了向后兼容TrueType之外，它还允许将PostScript Type 1字体封装在类似TrueType的容器中——一种字体格式，包含两个不同的系统。

// OpenType is now the *de facto* standard and best in class digital font format, and particularly in terms of its support for the kind of things we will need to do to implement global scripts and non-Roman typography, and so that's what we'll major on in the rest of this book.
OpenType现在是数字字体的事实标准，也是最优秀的一种格式，尤其是考虑到对#tr[global scripts]和非拉丁#tr[typography]的支持。这也是在本书剩余部分中我们要重点讨论的内容。

// ## Multiple Masters and Variable fonts
== #tr[multiple master]和#tr[variable font]

// In 1540, François Guyot released the first *typeface family* - his Double Pica included two alphabets, one upright Roman and one italic. Around four hundred years later, the concept of a "related bold" was added to the typeface family idea.[^13] Users of type now expect to be able to select roman, bold, italic, and bold italic forms of Latin fonts, but more to the point, Latin script users now use both *speed* (italic) and *weight* to create typographic differentiation and establish hierarchy. Not long after, in 1957, Adrian Frutiger's Univers was designed based on a typographic system of nine weights, five widths, and a choice of regular and oblique - a potential 90-member family, although in practice far fewer cuts of Univers were actually designed.
1540 年，François Guyot 发布了第一个*#tr[typeface family]*——他的Double Pica包含两套字母，一套是直立的罗马体、另一套是意大利体。大约四百年后，“相关粗体”的概念被添加到#tr[typeface family]中@Tracy.LettersCredit.1986[65-66]。如今，字体用户希望能选择拉丁字体的罗马体、粗体、意大利体和粗意大利体形式。更重要的是，拉丁字母的使用者们往往会同时使用*速度*（意大利体）和*重量*来展现版面差异和构建层次。在不久之后的1957年，Adrian Frutiger设计了Univers字体，它包含9个字重、5种宽度以及直立倾斜的变化，是一个共有90个成员的家族，尽管实际上只有其中的一小部分完成了设计。

// But what if nine weights is not enough? More realistically, what if the designer has only provided a regular and a related bold, and you need something in the middle? The one development Adobe attempted to make to their Type 1 PostScript font format in 1991 was the idea of *multiple masters* which aimed to solve this problem: the font would contain two or more sets of outlines, and the user could "blend" their own font from some proportion of the two. They could mix 3 parts the regular weight to 1 part bold weight to create a sort of hemi-semi-bold.
但如果九个字重还不够怎么办？更现实的是，如果设计师只提供了常规字体和对应的粗体，而你恰好需要它们之间的某个粗细又该怎么办？Adobe在1991年尝试为PostScript Type 1字体格式开发了*#tr[multiple master]*的构想（@figure:MM），其目的就是为了解决这个问题。该字体包含两套或更多的#tr[outline]，用户按照一定比例进行“混合”，就可以得到自己想要的字体。比如可以把3份常规字重与1份粗体混合，得到一种1/4粗体。

#figure(caption: [
  // > Adobe Myriad MM, with width (left to right) and weight (top to bottom) masters
  Adobe Myriad MM，带有宽度（从左到右）和字重（从上到下）#tr[master]。
])[#image("MM.png")] <figure:MM>

// It was a great idea; the designers were excited; technologically, it was a triumph. Adobe worked hard to promote the technology, redesigning old families as MM fonts. But it turned out to be way ahead of its time. For one thing, very few applications provided support for accessing the masters and generating the intermediate fonts (called "instances"). For another, handling the instances was a mess. "Users were forced to generate instances for each variation of a font they wanted to try, resulting in a hard drive littered with font files bearing such arcane names as `MinioMM_578 BD 465 CN 11 OP`."[^14]
这是一个好主意，设计师们兴奋不已。从技术上讲，这也是一次胜利。 Adobe努力推广该技术，将之前的#tr[typeface family]重新设计为#tr[multiple master]字体。但事实证明，这一技术过于超前。一方面，很少有应用程序支持访问#tr[master]或生成的中间字体（称为“#tr[instance]”）；另一方面，处理这些#tr[instance]非常麻烦。“用户被迫为他们想要尝试的每种字体生成#tr[instance]，导致硬盘上充斥着带有`MinioMM_578 BD 465 CN 11 OP`之类诡异名称的字体文件。”@Riggs.AdobeOriginals.2014

// Adobe Multiple Master Fonts, as a technology, ended up dying a quiet death. But the concept of designing fonts based on multiple masters (originally borrowed from the Ikarus system) became an established tool of digital type design. Instead of allowing the user the flexibility to create whatever instance combination they wanted, type designers would create multiple masters in their design - say, a regular and a black - and release a family by using interpolation to generate the semibold and bold family members.
作为一种技术，Adobe#tr[multiple master]字体最终悄无声息的死去了。 但是，基于#tr[multiple master]设计字体的理念（最初是从Ikarus系统借鉴来的）已成为数字字体设计的标配。字体设计师不再允许用户灵活地创建所需的#tr[instance]组合，而是在设计时创建多个#tr[master]（如常规体和超粗体），然后插值生成半粗体和粗体等#tr[typeface family]成员。

// Another attempt at the dream of infinitely tweakable in-between fonts came from Apple, as part of their GX font program. As we mentioned above, Apple's extensions to TrueType included the ability to create instances of fonts based on variations of multiple masters. But the same thing happened again: while it was typographically exciting, application support never came through, as supporting the format would require extensive software rewrites. But this time, there would be a longer lasting impact; as we will see in [the section on OpenType Font Variations](opentype.md#OpenType Font Variations), the way that GX fonts implemented these variations has been brought into in the OpenType standard.
作为GX字体程序的一部分，Apple为实现无级可调中间字体的梦想尝试了另一种方式。前文也提到过，Apple对TrueType的扩展包括基于#tr[multiple master]之间的变化创建字体#tr[instance]的功能。然而，同样的事情又再次发生了：尽管#tr[typography]行业对其感到兴奋，但在应用层面却从未得到支持，因为支持这种格式需要对软件进行大规模的重构。但这次产生的影响更加持久，正如我们将在#title-ref(<heading:opentype.font-variation>)一节中看到的那样，GX字体实现这种变体的方式已被纳入了OpenType标准中。

// OpenType finally adopted variable fonts in 2016. We're still waiting to see how applications will support the technology, but this time the success of variable fonts doesn't depend on application support. There is another, more important factor behind the rise of variable fonts: bandwidth. With fonts increasingly being hosted on the web, variable font technology means that a regular and a bold can be served in a single transaction - a web site can use multiple fonts for only slightly more bytes, and only a few more milliseconds, than a single font.
在2016年，OpenType终于支持了#tr[variable font]。我们仍然期待应用程序能支持该技术，但这次#tr[variable font]的成功并不依赖应用程序的支持。#tr[variable font]的广泛使用还有另一个更重要的因素：带宽。随着字体越来越多地托管在网络上，#tr[variable font]技术意味着可以在一次请求中同时获取常规体和粗体——网站使用多种变体相对单个字体的额外开销，可能只是几字节几毫秒而已。
