#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

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
], placement: none)[#image("metafont.png")]<figure:metafont-snail>

// The idea behind METAFONT was that, by specifying the shapes as equations, fonts then could be *parameterized*. For example, above we declared `mypen` to be a broad-nibbed pen. If we change this one line to be `mypen := pencircle xscaled 0.05w yscaled 0.05w;`, the glyph will instead be drawn with a circular pen, giving a low-contrast effect. Better, we can place the parameters (such as the pen shape, serif length, x-height) into a separate file, create multiple such parameter files and generate many different fonts from the same equations.
METAFONT 的理念是，通过方程的形式指定形状，字体就可以被*参数化*。例如，上面我们把`mypen`声明为一支宽头笔。如果我们把这一行代码改为```metafont mypen := pencircle xscaled 0.05w yscaled 0.05w;```，就可以获得低对比度的效果，类似于使用圆珠笔绘制。更好的方法是，我们可以把参数（例如笔的形状、衬线长度、#tr[x-height]）等放进单独的文件；一旦创建了多个这样的参数文件，就可以从同一组方程生成许多不同的字体。

// However, METAFONT never really caught on, for two reasons. The first is that it required type designers to approach their work from a *mathematical* perspective. As Knuth himself admitted, "asking an artist to become enough of a mathematician to understand how to write a font with 60 parameters is too much." Another reason was that, according to Jonathan Hoefler, METAFONT's assumption that letters are based around skeletal forms filled out by the strokes of a pen was "flawed";[^5] and while METAFONT does allow for defining outlines and filling them, the interface to this is even clunkier than the `draw` command shown above. However, Knuth's essay on "the concept of a meta-font"[^6] can be seen as sowing the seeds for today's variable font technology.
然而，METAFONT从未真正流行起来，原因有二。首先，它要求字体设计师用*数学*的方法来工作。Knuth 自己也承认，“要求一个艺术家像数学家那样用60个参数来绘制字体实在是太过分了。”其次，根据 Jonathan Hoefler 的说法，METAFONT 中字母由笔画沿着骨架而构建起来的假设其实是“有缺陷的”@Hoefler.JonathanHoefler.2015；尽管METAFONT确实允许定义#tr[outline]并进行填充，但其接口比上面所示的`draw`命令更加繁琐。不过无论如何，Knuth关于Meta-Font的论文#[@Knuth.ConceptMetaFont.1982]依然可以被认为是为如今的可变字体技术埋下了种子。

// As a sort of bridge between the bitmap and vector worlds, the Linotron 202 phototypesetter, introduced in 1978, stored its character designs digitally as a set of straight line segments. A design was first scanned into a bitmap format and then turned into outlines. Linotype-Paul's "non-Latin department" almost immediately began working with the Linotron 202 to develop some of the first Bengali outline fonts; Fiona Ross' PhD thesis describes some of the difficulties faced in this process and how they were overcome.[^10]
作为#tr[bitmap]和矢量世界之间的一座桥梁，Linotron 202照排机于1978年推出，它通过一组直线段来储存#tr[character]的设计。设计稿首先被扫描成#tr[bitmap]格式，然后再被转换成#tr[outline]。Linotype-Paul的非拉丁部门几乎立即就开始用Linotron 202开发首批孟加拉文字体；Fiona Ross的博士论文@Ross.EvolutionPrinted.1988 描述了这一过程中所面临的一些困难，以及他们是如何解决的。#footnote[另外，#cite(form: "prose", <Condon.ExperienceMergenthaler.1980>) 是对202照排机内部技术的极为精彩的研究。]
