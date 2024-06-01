#import "/template/heading.typ": chapter
#import "/template/components.typ": note
#import "/template/lang.typ": arabic, devanagari

#import "/lib/glossary.typ": tr

#chapter(label: <chapter:font-concepts>)[
  // Font Concepts
  字体中的术语和概念
]

== #tr[shaping]和#tr[layout]

// I've called this book "Fonts and Layout for Global Scripts", because I wanted it to be about the whole journey of getting text through a computer and out onto a display or a piece of paper. Having the fonts designed and engineered correctly is the first step in this; but there's a lot more that needs to be done to use those fonts.
我把本书起名叫《#tr[global scripts]的字体与#tr[layout]》，因为我想让它涵盖计算机从获取文本到输出到显示器或纸上的整个过程。正确的字体设计和字体工程只是第一步，想运用好这些字体还需要很多其他的工作。

// There are a number of stages that the letters and numbers you want to typeset go through in order to become the finished product. To begin with, the user (or in some cases, the computer) will choose what font the text should be typeset in; the text, and the choice of font and other typographic details, are the inputs to the process. These two inputs pass through some or all of the following stages before the text is set:
从输入字母和数字到获得最终的#tr[typeset]结果之间有好几个步骤。首先，用户（或计算机）会选择文本应该用什么字体；然后文本、字体以及其他#tr[typography]细节将作为整个过程的输入。在文本被#tr[typeset]出来前，这些输入信息会经历@figure:pipeline 所示的部分或所有阶段。

#figure(caption: [
  计算机中文本处理的流程简图
], include "pipeline.typ") <figure:pipeline>

// We can understand most of these steps by taking the analogy of letterpress printing. A compositor will be given the text to be set and instructions about how it is to look. The first thing they'll do is find the big wooden cases of type containing the requested fonts. This is *font management*: the computer needs to find the file which corresponds to the font we want to use. It needs to go from, for example, "Arial Black" to `C:\\Windows\\Fonts\\AriBlk.TTF`, and so it needs to consult a database of font names, families, and filenames. On libre systems, the most common font management software is called [fontconfig](https://www.fontconfig.org); on a Mac, it's [NSFontManager](https://developer.apple.com/documentation/appkit/nsfontmanager?language=objc).
要理解其中的大多数步骤，可以将其类比于凸版印刷。排版工会拿到一些文本，以及关于如何呈现它们的指令。他首先要找到装有相应字体的木箱，这就是*字体管理*：计算机需要找到与我们使用的字体相对应的文件。例如，它会从“Arial Black”找到`C:\Windows\Fonts\AriBlk.TTF`。而这就需要一个有关字体名称、#tr[typeface family]信息和文件名的数据库。在自由操作系统上最常用的字体管理软件是fontconfig@Unknown.Fontconfig，在 Mac 上则是NSFontManager@Apple.NSFontManager。

// They'll also have to make sure they can read the editor's handwriting, checking they have the correct understanding of the input text. In the computer world, correctly handling some scripts may require processes of reordering and re-coding required so that the input is correctly interpreted. This is called Unicode processing, and as we will see in the next chapter, is often done using the [ICU](http://site.icu-project.org) library.
排版工还要有能力阅读编辑给的手写文本，并确认他们对这些文本的理解是否正确。在计算机世界中，可能需要经过重排序和重编码等过程才能正确解读输入的文本，尤其是对含有非拉丁#tr[script]的场景。这一过程称为Unicode处理，通常使用ICU程序库#[@UnicodeConsortium.ICU]完成，我们将在下一章中介绍这一步骤。

// > Yes, that example was a bit of a stretch. I know.
#note[好吧，我知道这个例子有点牵强。]

// Next, the hand compositor will pick the correct metal sorts for the text that they want to typeset.
接下来，排版工要挑选正确的金属#tr[sort]来#tr[typeset]文本。

#figure(
  caption: [装有金属#tr[sort]的#tr[compositing stick]],
)[#image("512px-Handsatz.jpg", width: 80%)]

// They will need to be aware of selecting variants such as small capitals and swash characters. In doing this, they will also *interpret* the text that they are given; they will not simply pick up each letter one at a time, but will consider the desired typographic output. This might mean choosing ligatures (such as a single conjoined "fi" sort in a word with the two letters "f" and "i") and other variant forms when required. At the end of this process, the input text - perhaps a handwritten or typewritten note which represents "what we want to typeset" - will be given concrete instantiation in the actual pieces of metal for printing. When a computer does this selection, we call it *shaping*. On libre systems, this is usually done by [HarfBuzz](https://www.harfbuzz.org/); the Windows equivalent is called [DirectWrite](https://docs.microsoft.com/en-us/windows/win32/directwrite/direct-write-portal) (although this also manages some of the later stages in the process as well).
他们还会选取各种变体，例如小型大写字母和花笔#tr[character]，这其实是对文本的一种*演绎*。他们不只是简单地逐个选取字母，而是会考虑所需的#tr[typography]效果。比如他们会根据需要选择连字（例如用一个fi的#tr[sort]代替单词中的字母f和i）等变体形式。这一步骤完成后，输入的文本——代表了“我们想要排版的东西”的手写或打字稿——就被转化为了用以交付印刷的金属块。当在计算机中做这些工作时，我们将其称为*文本#tr[shaping]*。在自由操作系统上，这通常交由HarfBuzz#[@Unknown.HarfBuzz]完成；在Windows上则可以采用DirectWrite API@Microsoft.DirectWriteAPI（虽然它也参与了若干后续过程）。

// At the same time that this shaping process is going on, the compositor is also performing *layout*. They take the metal sorts and arrange them on the compositing stick, being aware of limitations such as line length, and performing whatever spacing adjustments required to make the text look natural on the line: for some languages, this will involve hyphenation, the insertion of spaces of different widths, or even going back and choosing other variant metal sorts to make a nicer word image. For languages such as Thai, Japanese or Myanmar which are written without word breaks, they will need to be aware of the semantic content of the text and the typographic conventions of the script to decide the appropriate places to end a line and start a new one.
在#tr[shaping]的同时，排版工还需要进行*#tr[layout]*。他们会把金属#tr[sort]排列在#tr[compositing stick]上，同时考虑行高等限制。他们还会进行必要的间距调整，以使得文本看起来更加自然。对于一些语言，这需要引入连字符、插入不同宽度的空格，或者回过头重新选择看起来更舒服的其他变体。而对于泰文、日文和缅甸文等不需要断词的文本，则可能需要考虑其语义和排版习惯，以此来确定换行的合适位置。

// In a computer, this layout process is normally done within whatever application is handling the text - your word processor, desktop publishing software, or design tool - although there are some libraries which allow the job to be shared.
在计算机中，#tr[layout]的过程通常由操作文本的软件完成——比如文字处理软件、桌面出版软件、设计工具等——也有一些专门负责处理这一工作的公共库。

// Finally, the page of type is "locked up", inked, and printed. In a computer, this is called *rendering*, and involves *rasterizing* the font - turning the outlines into black and white (and sometimes other colored!) dots, taking instructions from the font about how to make the correct selection of dots for the font size requested. Once the type has been rasterized, it's generally up to the application to place it at the appropriate position on the screen or represent it at the appropriate point in the output file.
最后，这些排好的页面会被“固定”、上墨以及印刷。在计算机中。这一步称为*#tr[rendering]*，即对字体进行*#tr[rasterization]*。字体的#tr[outline]会被转化为黑白（有时候也会是彩色的！）的小点，而在特定字号下如何正确排布这些点则会根据字体中的指令来确定。一旦#tr[rasterization]完成，通常就会由应用程序将其放置在屏幕或输出文件的正确位置上。

// So using a font - particularly an OpenType font - is actually a complex dance between three actors: the top level providing *layout* services (language and script handling, line breaking, justification), the *shaping* engine (choosing the right glyphs for the input), and the font itself (which gives information to the shaping engine about its capabilities). John Hudson calls this the "OpenType collaborative model", and you can read more about it in his [Unicode Conference presentation](http://www.tiro.com/John/Hudson_IUC39_Beyond_Shaping.pdf).
因此，使用字体——尤其是OpenType字体——实际上是有三位演员参与的复杂舞蹈：顶层的*#tr[layout]*服务（语言和#tr[script]处理、断行、对齐等），*#tr[shaping]*引擎（为输入文本选择合适的#tr[glyph]）以及字体本身（它会告知#tr[shaping]引擎自己带有的功能）。John Hudson称之为“OpenType 合作模型”<concept:opentype-collaborative-model>，关于这个模型的更多内容，可以参考他在Unicode会议上的报告@Hudson.ShapingGeneral.2015。

// ## Characters and glyphs
== #tr[character]和#tr[glyph]

// We've been talking loosely about "letters" and "numbers" and "stuff you want to typeset". But that's a bit cumbersome; we need a better way to talk about "letters and numbers and symbols and other stuff." As it happens, we're going to need *two* specific terms to be able to talk about "letters and numbers and symbols and other stuff."
我们一直在不很严谨地使用“字母”、“数字”和“你想排版的东西”等等词语。但这有点麻烦，我们需要一个更好的方式来讨论它们。实际上，我们需要*两个*不同的术语来描述这个概念。

// The first term is a term for the things that you design in a font - they are *glyphs*. Some of the glyphs in a font are not things that you may think need to be designed: for example, the space between words is a glyph. Some fonts have a variety of different space glyphs. Font designers still need to make a decision about how wide those spaces ought to be, and so there is a need for space glyphs to be designed.
第一个术语是指在字体中实际被设计的那个东西——它们是*#tr[glyph]*。你可能认为字体中的某些#tr[glyph]可能并不需要实际的设计，比如单词之间的空格。但实际上，字体中会有各种不同的空格，字体设计师仍然需要决定，也就是设计，这些空格#tr[glyph]的宽度。

// Glyphs are the things that you draw and design in your font editor - a glyph is a specific design. My glyph for the letter "a" will be different to your glyph for the letter "a". But in a sense they're both the letter "a". Their semantic content is the same.
#tr[glyph]一般在字体编辑器中绘制，每个#tr[glyph]都是一个独特的设计。我为字母a设计的#tr[glyph]会和你设计的不同，但它们都是字母a。它们背后的语义是相同的。

// So we are back to needing a term for the generic version of any letter or number or symbol or other stuff, *regardless of how it looks*: and that term is a *character*. "a" and `a` and *a* and **a** are all different glyphs, but the same character: behind all of the different designs is the same Platonic ideal of an "a". So even though your "a" and my "a" are different, they are both the character "a"; this is something that we will look at again when it comes to the chapter on Unicode, which is a *character set*.
我们也需要一个术语来描述这种内在语义，一个去除了外形设计之后，这个“字母、数字、符号或其他东西”的通用版本：*#tr[character]*。a、`a`、_a_、*a*，这些是不同的#tr[glyph]，但都是相同的#tr[character]。在这些不同的设计背后，有一个对于a的共同的柏拉图式完美理型。所以即使你的a和我的a看起来不一样，但它们都是相同的#tr[character]a。在后续对于Unicode这个*#tr[character set]*的章节中，我们会再次讨论这些概念。

// ## Dimensions, sidebearings and kerns
== #tr[dimension]、#tr[sidebearing]和#tr[kern]

// As mentioned above, part of the design for a font is deciding how wide, how tall, how deep each glyph is going to be, how much space they should have around them, and so on. The dimensions of a glyph have their own set of terminology, which we'll look at now.
如上所述，字体设计中有部分工作是在决定每个#tr[glyph]的宽高，以及周围有多少空白部分等等。这些#tr[dimension]信息都有它们自己的术语，接下来将逐步介绍它们。

// ### Units
=== 单位

// First, though, how do you measure stuff in a font? When fonts were bits of metal, it was easy: you could use callipers or a micrometer to measure the sort, and get an answer in millimeters or printers points. But digital fonts, as we've seen in the previous chapter, are meant to be scalable; that is, usable at any size. With scalable fonts, there isn't such a thing as a 12pt Times Roman as distinct from a 16pt Times Roman; there isn't any *size* there at all.
首先有个疑问，在进行字体设计时我们怎么测量长度呢？当字体还是金属的时代这很容易，使用卡尺或者千分尺之类的工具就可以量出#tr[sort]的尺寸，用厘米或者点作为单位来记录即可。但数字字体，我们在上一章讨论过，可以以任意大小显示。对于这些可缩放的字体来说，12pt和16pt的Times Roman并没有什么区别，它们根本没有大小这个概念。

// So coordinates and size values inside digital fonts are defined in terms of an *em square*, which is itself divided into an arbitrary number of *units*, typically 1000, 1024 or 2048. If we want to display text at 12 points, we draw the *em square* at that size, and then scale up the design to match.
数字字体内的坐标和尺寸由*#tr[em square]*来确定，它的高度会被分成任意数量个小单元，一般会是1000，1024或者2048个单位。如果我们希望显示12pt的文本，就把*#tr[em square]*定为这个尺寸，具体的字符设计就自然地缩放为相匹配的大小了。

#figure(caption: [
  #tr[glyph]在不同字号时的缩放
], include "units.typ") <figure:units>

// We can see a number of things from this diagram. First, we notice that the glyph outline doesn't need to be contained within the em square itself. It's just a notional rectangular box, a kind of digital type sort. (Yes, the old lining-up-boxes model of typography again.) In this case, with Bengali script, we want to make sure that the headline is always connected, so there is a slight overlap between the glyphs to make this happen, leading to the outline of the headline jutting out the left and right side of the em square.
从@figure:units 中我们可以看出很多信息。首先，#tr[glyph]#tr[outline]不需要充满整个#tr[em square]，它只是一个用于参考的矩形框而已，就像#tr[sort]字身的数字版。（是的，又是古老的基于线和框那一套。）在图中的孟加拉文例子中，我们希望确保#tr[headline]总是连续的，所以将#tr[glyph]设计为有轻微的重叠，也就造成了这些#tr[headline]的#tr[outline]会突出于#tr[em square]的左右两侧。<pos:bengali-headline>

// Notice also that the baseline and full height of the glyph are not determined by the em square itself; the designer decides where to put the outlines within the em square, and even how high to make the outlines. This can mean that different digital fonts which are notionally the same type size actually appear at different sizes!
需要注意的是，#tr[baseline]和#tr[glyph]的高度并不由#tr[em square]决定。设计师会决定把它们放在#tr[em square]的什么位置，或者什么高度上。这也就意味着在使用相同的字号调用不同的字体时，实际的显示尺寸可以千差万别。

#figure(caption: [
  Noto Sans和Trajan字体#footnote[译注：原文使用的应该是Trajan Pro 3的图片，因直接嵌入字体数据时的许可证问题，此处换成同风格的Cinzel。]中的字母H、x
], placement: none, include "notional-size.typ") <figure:notional-size>

// Here the designers of Noto Sans and Trajan have placed the outlines in the em square in different ways: Trajan uses a bigger body, a higher x-height, and fills up the square more, whereas Noto Sans leaves space at the top. (Both of them leave space at the bottom for descenders.) We'll look at the differing heights used in font design a little later, but for now just remember that because the em-square is a notional size and designers can put outlines inside it however they like, a 12pt rendering of one font may be "bigger" than a 12pt rendering of another, even if the em square is scaled to be the same size.
@figure:notional-size 展示了Noto Sans和Trajan两个字体在把#tr[outline]放进#tr[em square]时采用的不同方式：Trajan拥有一个更高的#tr[x-height]，它的体型更大，向上填满了整个方框；而Noto Sans则在上面留出了一些空间（两个字体都在下方为#tr[decender]预留了空间）。字体中的这些不同的高度会在后面的章节详述，现在只需要记住，因为#tr[em square]只是用于参考的名义上的边界，某个字体的12pt可能会比另一个字体的12pt更大，即使它们的#tr[em square]被缩放到了相同的大小。

// However, dividing this notional square up into a number of units gives us a co-ordinate system by which we can talk about where the outlines fall on the glyph. Instead of saying "make the horizontal stem width about a tenth of the height", we can say "make the horizontal stem width 205 units wide", and that'll be scalable - true for whatever size of font we're talking about.
但这个名义上的边界在被划分成小单元之后，我们就有了一个坐标系统，可以用于指定#tr[outline]位于整个#tr[glyph]的什么位置。我们不需要用“画一条大约是整体高度的1/10的水平#tr[stem]”这样的描述，只需要说“画一条205个单位宽的水平#tr[stem]”就行。而这也保持了可缩放的特性，因为对于任何字号这一描述都是成立的。

// We'll use these *font units* every time we talk about the dimensions within a font.
我们在讨论字体中的所有尺寸时都会使用这个单位长度。

// ### Advance widths
=== #tr[advance width]

// You may have also noticed that while we call it an em *square*, there's nothing really square about it. It's more of an em *rectangle*. Let's think about the dimensions of this rectangle.
你也许已经注意到，虽然我们把它称作em*方*框，但它实际上并不是正方形，也许称它为em*矩形框*更为合适。让我们仔细看看这个矩形的尺寸。

// Let's first assume that we're designing a horizontal font; in that case, one of the most important dimensions of each glyph is the width of the em square - not just the black part of the glyph, but also including the space around it. You will often hear this referred to as the *advance width*, or the *horizontal advance*. This is because most layout systems, working on the typographic model we saw at the beginning of this book, keep track of the X and Y co-ordinates of where they are going to write glyphs to the screen or page; after each glyph, the writing position advances. For a horizontal font, a variable within the layout system (sometimes called the *cursor*) advances along the X dimension, and the amount that the cursor advances is... the horizontal advance.
首先假定我们是在设计一个沿水平方向书写的字体。这样的话，每个#tr[glyph]最重要的一个尺寸就是#tr[em square]的宽度。这不仅包括#tr[glyph]中被填充为黑色的那部分，也包括了其周围的空白空间。这个尺寸经常被称为*#tr[advance width]*，或者*#tr[horizontal advance]*。这是因为，遵循本书介绍的这种#tr[typography]模型的占绝大多数的#tr[layout]系统，都会记录下一个需要输出到屏幕或纸张上的#tr[glyph]的XY坐标。在输出一个#tr[glyph]之后，这个表示书写位置的坐标就会前移动一段距离。对于水平的字体来说，#tr[layout]系统中的一个变量（常被称为*#tr[cursor]*）会沿着X轴不断前进，#tr[cursor]每次水平前进的距离就是#tr[horizontal advance]。

#figure(caption: [
  // a rather beautiful Armenian letter xeh
  一个非常美丽的亚美尼亚字母xeh
], placement: none)[#include "dim-1.typ"] <figure:dim-1>

// Glyphs in horizontal fonts are assembled along a horizontal baseline, and the horizontal advance tells the layout system how far along the baseline to advance. In this glyph, (a rather beautiful Armenian letter xeh) the horizontal advance is 1838 units. The layout system will draw this glyph by aligning the dot representing the *origin* of the glyph at the current cursor position, inking in all the black parts and then incrementing the X coordinate of the cursor by 1838 units.
水平字体中的#tr[glyph]将会沿着水平的#tr[baseline]排列，#tr[horizontal advance]用于告诉#tr[layout]系统要沿着#tr[baseline]向前走多远。在@figure:dim-1 所示的#tr[glyph]中，#tr[horizontal advance]是1838个单位。#tr[layout]系统在绘制这个#tr[glyph]时，会将#tr[glyph]*原点*和当前#tr[cursor]位置对齐，然后填充所有黑色部分，最后将光标的X坐标向前移动1838个单位。

// Note that the horizontal advance is determined by the em square, not by the outlines.
需要注意，#tr[horizontal advance]的实际长度也是由#tr[em square]的大小决定，和#tr[glyph]#tr[outline]无关。

#figure(placement: none)[#include "dim-2.typ"]

// The rectangle containing all the "black parts" of the glyph is sometimes called the *ink rectangle* or the *outline bounding box*.  In the Bengali glyph we saw above, the horizontal advance was *smaller* than the outline bounding box, because we wanted to create an overlapping effect. But glyphs in most scripts need a little space around them so the reader can easily distinguish them from the glyphs on either side, so the horizontal advance is usually wider than the outline bounding box. The space between the outline bounding box and the glyph's bounding box is called its sidebearings:
包含#tr[glyph]中所有“黑色部分”的矩形叫做*#tr[ink rectangle]*，或者*#tr[outline]#tr[bounding box]*。在我们之前看过的孟加拉文#tr[glyph]中，#tr[horizontal advance]会比#tr[outline]#tr[bounding box]要*小*，因为我们想要制造这种重叠的效果。但大多数文种都需要在#tr[glyph]的周围留有一些空间，来让读者能够更容易地逐个阅读每个#tr[glyph]，这时#tr[horizontal advance]就会稍微比#tr[outline]#tr[bounding box]宽一些。在#tr[outline]#tr[bounding box]和整个字形的#tr[bounding box]之间的这些空间叫做#tr[sidebearing]：

#figure(placement: none)[#include "dim-4.typ"]

// As in the case of Bengali, there will be times where the ink rectangle will poke out of the side of the horizontal advance; in other words, the sidebearings are negative:
对于孟加拉文，有时#tr[ink rectangle]会超出#tr[horizontal advance]的边界。也就是说，#tr[sidebearing]可以是负数：

#figure(placement: none)[#include "dim-3.typ"] <figure:dim-3>

// In metal type, having bits of metal poking out of the normal boundaries of the type block was called a *kern*. You can see kerns at the top and bottom of this italic letter "f".
在金属排版时代，这种超出活字字身的部分叫做*#tr[kern.origin]*（kern）。你可以从@figure:metal-kern 中看到，在意大利体f的上下部分都存在#tr[kern.origin]。

#figure(caption: [
  金属活字的出格现象
])[#image("metal-kern.png", width: 50%)] <figure:metal-kern>

但在数字时代，kern这个词被赋予了完全不同的含义……

// ### Kerns
=== #tr[kern]

// As we have mentioned, a layout system will draw a glyph, move the cursor horizontally the distance of the horizontal advance, and draw the next glyph at the new cursor position.
上文提到，#tr[layout]系统在绘制一个#tr[glyph]之后，会将光标水平移动一个#tr[horizontal advance]的距离，然后在新的坐标位置处开始绘制下一个#tr[glyph]。

#figure(placement: none)[#include "kerns-1.typ"]

// However, to avoid spacing inconsistencies between differing glyph shapes (particularly between a straight edge and a round) and to make the type fit more comfortably, the designer of a digital font can specify that the layout of particular pairs of glyphs should be adjusted.
然而为了让整篇文字看起来更舒适，各个#tr[glyph]（特别是竖直边缘和曲线边缘）的间距需要保持一致。数字字体设计师可以通过单独设置一对#tr[glyph]间的布局参数来调整这一间距。

#figure(caption: [间距调整])[#include "kerns-2.typ"] <figure:kern-2>

// In this case, the cursor goes *backwards* along the X dimension by 140 units, so that the backside of the ja is nestled more comfortably into the opening of the reh. This is a negative kern, but equally a designer can open up more space between a pair of characters by specifying a positive kern value. We will see how kerns are specified in the next two chapters.
在@figure:kern-2 的示例中，光标沿X轴*往回*走了140个单位，这样 ja 字母的弧线就会更加靠近 reh 字母的开口，这就是一个负的#tr[kern]。设计师也可以通过设置正的#tr[kern]来让两个#tr[glyph]的间距更大。在下两章中会具体介绍#tr[kern]是如何设置的。

// ### Heights
=== 高度

// But first, let's think a little bit about the different measurements of height used in a glyph. Again, we're going to be assuming that we are designing for a horizontal writing system.
但现在让我们先看看#tr[glyph]中不同的高度值。我们仍然假设是在为水平方向的#tr[writing system]设计字体。

// The first height to think about is the *baseline*. We have mentioned this already, as the imaginary line on which the glyphs are assembled. In a sense, it's not really a height - in terms of a co-ordinate grid, this is the origin; the y co-ordinate is zero. This doesn't necessarily mean that the "black part" of the glyph starts at the baseline. Some glyphs, such as this plus sign, have the black parts floating above the baseline:
首先我们来看*#tr[baseline]*。这个概念我们之前提到过，它是一条用于整齐排列#tr[glyph]的虚拟的线。以坐标系的语境来看，它并没有高度，而是作为原点（X轴）存在，它的Y轴坐标为零。但这并不意味着#tr[glyph]的“黑色部分”需要从#tr[baseline]处开始。对于某些字形，比如加号（@figure:dim-5），它的黑色部分就是浮在#tr[baseline]之上的。

#figure(caption: [
  加号#tr[glyph]并不从#tr[baseline]开始。
], placement: none)[#include "dim-5.typ"] <figure:dim-5>

// In this case, the baseline is coordinate zero; the glyph begins 104 units above the baseline. But the plus sign needs to be placed above the baseline, and having a baseline as the origin tells us how far above it needs to be placed.
在本例中，基线作为坐标轴零点，#tr[glyph]从其上方 104 个单位处开始绘制。

// Within a font, you will often have various heights which need to "line up" to make the font look consistent. For example, in the Latin script, all capital letters are more or less lined up at the same height (modulo some optical correction) - this is called the "cap height". All of the ascenders and descenders will fall at the same position, as will the tops of the lower-case letters (this last height is called the "x-height"). As we have seen, these notional lines can be positioned anywhere in the em-square you like, as your design calls for it; and different designs, even within the same script, will have them at differing heights: we saw in our example above that Trajan has a very high x-height relative to its cap height, and a taller cap height in absolute terms than Noto Serif. The different design heights for a font are called their *vertical metrics*. Here are some vertical metrics for a typical Latin typeface, all given in font units:
除了基线之外，为了让整个版面观感更加一致，字体中还有其他几条需要对齐的线。例如，在拉丁字母中，所有大写字母的高度或多或少都是对齐的（在进行了一些视错觉矫正之后），这个高度被称为“#tr[cap height]”。所有的#tr[ascender]、#tr[decender]也都会分别落在相同的高度，而没有#tr[ascender]和#tr[decender]的小写字母们也有一个统一的高度，叫做“#tr[x-height]”。这些参考线可以按照你的设计需要，放置在#tr[em square]中的任何高度上。换句话说，即使是同一种#tr[script]，在不同的设计中它们也可以具有不同的高度值。本书前文中就有一个这样的例子，Trajan字体的#tr[cap height]就比Noto Serif字体要高一些，而且它的#tr[x-height]相对于#tr[cap height]的占比也要更高一些。这些设计中的不同的高度叫做字体的“垂直#tr[metrics]”。@figure:latin-heights 是典型的拉丁文字体中会存在的垂直#tr[metrics]，均使用单位长度描述。

#figure(
  caption: [字体中的垂直#tr[metrics]],
  placement: none,
)[#include "latin-heights.typ"] <figure:latin-heights>

// For some scripts, though, these concepts won't make any sense - Chinese, Japanese and Korean fonts, for instance, just have an em square. In other cases, glyphs aren't arranged according to their baselines in the way that Latin expects; particularly Indic scripts like Devanagari, arrange glyphs along other lines, the so-called "headline":
然而对于某些#tr[scripts]来说，这些概念一点意义也没有。比如中日韩文的字体就只有#tr[em square]。其他一些#tr[scripts]的#tr[glyph]可能根本不会像拉丁字母那样沿着#tr[baseline]整齐排列，特别是印度语系的#tr[scripts]。比如天城文会沿着“#tr[headline]”排列：

#figure(
  caption: [天城文文本示例#footnote[译注：此例文为“#tr[typography]”的印地语。图中变音符号线原文为matra line，半音符号线原文为rakar line。]],
  placement: none
)[#include "devanagari.typ"] <figure:devanagari>

// For the purposes of font technology, this headline doesn't really exist. OpenType is based on the Latin model of arranging glyphs along the baseline, and so even in a script with a headline, the font needs to be designed with the baseline in mind, and you still have to declare nominal x-heights, ascender heights, descender heights and so on when you design the vertical metrics of your glyph. The Latin pull of digital typography is, unfortunately, really strong.
在数字字体技术的视角下，这个#tr[headline]并不存在。OpenType 是基于拉丁字母模型的，#tr[glyph]只能沿着#tr[baseline]排列。字体设计者必须按照#tr[baseline]的思维来思考，并且也需要为#tr[glyph]声明这些名义上的#tr[x-height]、#tr[ascender]高度、#tr[decender]高度等垂直#tr[metrics]值。非常不幸，拉丁模型对数字#tr[typography]技术的影响太大了。

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

// ### Advance and Positioning
=== #tr[advance]和#tr[position]

// *advance*, whether horizontal or vertical, tells you how far to increment the cursor after drawing a glyph. But there are situations where you also want to change *where* you draw a glyph. Let's take an example: placing the fatha (mark for the vowel "a") over an Arabic consonant in the world ولد (boy):
无论是水平或垂直的*#tr[advance]*，都是在告诉我们#tr[cursor]需要在绘制完当前#tr[glyph]后移动多远。但有时你也会希望改变绘制这个#tr[glyph]的*位置*。比如这个阿拉伯语的例子：需要将 fatha（标识元音a的符号）放在单词#arabic[وَلَد]（孩子）中的辅音上：

#figure(caption: [
  “孩子”的阿拉伯文
], placement: none)[#include "walad.typ"] <figure:walad>

// We place the first two glyphs (counting from the left, even though this is Arabic) normally along the baseline, moving the cursor forward by the advance distance each time. When we come to the fatha, though, our advance is zero - we don't move forward at all. At the same time, we don't just draw the fatha on the baseline; we have to move the "pen" up and to the left in order to place the fatha in the right place over the consonant that it modifies. Notice that when we come to the third glyph, we have to move the "pen" again but this time by a different amount - the fatha is placed higher over the lam than over the waw.
我们沿着基线正常放置开头（从左往右算，即使是阿拉伯文）的两个#tr[glyph]，每次将#tr[cursor]向前步进一段距离。当遇到fatha符号，发现它的步进值是0，也就是完全不需要向前移动。但此同并不能直接在基线上绘制这个符号，我们需要将“画笔”往左上角移动，来让 fatha 符号位于它需要标注的辅音上方的正确位置处。对于第三个#tr[glyph]，为了绘制它上面的 fatha，“画笔”也需要进行类似的移动，但移动的距离不同：字母lam（#arabic[ل]）上的 fatha 会比字母waw（#arabic[و]）上的高一些。

// This tells us that when rendering glyphs, we need two concepts of where things go: *advance* tells us where the *next* glyph is to be placed, *position* tells us where the current glyph is placed. Normally, the position is zero: the glyph is simply placed on the baseline, and the advance is the full width of the glyph. However, when it comes to marks or other combining glyphs, it is normal to have an advance of zero and the glyph moved around using positioning information.
这告诉我们，当#tr[rendering]#tr[glyph]时，我们需要两个概念：*#tr[advance]*告诉我们*下一个*#tr[glyph]放在哪，*#tr[position]*则告诉我们当前#tr[glyph]放在哪。通常来说，#tr[position]会是0值，表示#tr[glyph]直接放置在#tr[baseline]上。但是，当遇到诸如需要结合到其他#tr[glyph]上的附加符号时，通常会将步进设置为0，然后使用#tr[position]信息来将当前#tr[glyph]移动到所需位置。

// If you just perform layout using purely advance information, your mark positioning will go wrong; you need to use both advance and glyph position information provided by the shaper to correctly position your glyphs. Here is some pseudocode for a simple rendering process:
如果只有步进信息的话，我们无法把这种附加符号放到正确的位置上。#tr[shaper]提供的步进和位置信息都是非常重要的。以下是#tr[rendering]过程的伪代码示例：

```python
def render_string(glyphString, xPosition, yPosition):
    cursorX = xPosition
    cursorY = yPosition
    for glyph in glyphString:
        drawGlyph(glyph,
            x = cursorX + glyph.xPosition,
            y = cursorY + glyph.yPosition)
        cursorX += glyph.horizontalAdvance
        cursorY += glyph.verticalAdvance
```

// ## Bézier curves
== 贝塞尔曲线

// We've already mentioned that outlines in digital fonts are made out of lines and Bézier curves. I'm not going to spend a lot of time getting into the mathematics of how Bézier curves work, but if you're doing any kind of implementing -  rasterising, font editing or font manipulation - you would be wise to spend some time looking through Mike Kamerman's [A Primer on Bézier Curves](https://pomax.github.io/BezierInfo-2/).
前文已经介绍过，数字字体中的#tr[outline]是由直线和贝塞尔曲线组成的。本书不会过多介绍关于贝塞尔曲线的数学支持，但如果你想实际实现一些东西——比如字体#tr[rasterization]器、编辑器、操作工具——的话，可以花时间看看Mike Kamerman的《A Primer on Bézier Curves》@Kamerman.PrimerBezier。

// What is worth considering, for our purposes, is the difference between *quadratic* and *cubic* Bézier curves. As we've seen, Bézier curves are specified by a start point, an end point, and one or more control points, which pull the curve towards them. A quadratic Bézier curve has one control point, whereas a cubic Bézier curve has two. (Higher order curves are possible, but not used in type design.)
但对于本书的主旨来说，*二次*和*三次*贝塞尔曲线的区别是值得讨论一下的。贝塞尔曲线是由一个起始点、一个终结点，和一个或多个控制点构造而成的。这些控制点会将曲线往它们所在的位置拉动。二次贝塞尔曲线有一个控制点，而三次的会有两个。更高次的贝塞尔曲线也是存在的，但没有在字体设计中使用。

// TrueType outlines use quadratic Bézier curves, whereas PostScript fonts use cubic Bézier curves; it's possible to convert from a quadratic curve to a cubic curve and get the same shape, but it's not always possible to perfectly go from a cubic curve to a quadratic curve - you have to approximate it. Again, you'll find all the details in A Primer on Bézier Curves.
TrueType中使用二次贝塞尔曲线来绘制#tr[outline]，PostScript中则是使用三次贝塞尔曲线。在不改变曲线形状的情况下，将二次曲线转换为三次曲线是可行的。但反过来却不行，得到的二次曲线会是原三次曲线的近似。关于曲线转换的详细内容，也请参考《A Primer on Bézier Curves》。

// I've said that outlines are made out of Bézier curves, but a more accurate way to say that is that they are made of a series of Bézier curves joined together. When two Bézier curves meet, they can either meet in a *smooth* join or at a *corner*. You will use both of these types of join in type design; generally, you will want things to be smooth if they would form part of the same "stroke" of a pen or brush, but there are places where you'll need corner joins too. Here you see a portion of the top edge of a letter m, which contains a smooth join and a corner join.
之前我们说#tr[outline]由贝塞尔曲线组成，实际上更准确的表述应该是它由一系列贝塞尔曲线首尾相连组成。当两条贝塞尔曲线相连时。它们可以“平滑”的连接，也可以形成“转角”。这两种连接方式在设计中都会使用。通常来说，如果是在勾勒笔或笔刷画出的笔画的话，会平滑的连接曲线。但也有一些地方是需要生硬的转角的。你可以从@figure:m-top 中看到，字母 m 的上顶端同时使用了光滑连接和转角。

#figure(caption: [
  m 上部的轮廓曲线
])[#include "mtop.typ"] <figure:m-top>

// The main condition for a smooth join is that you can draw a straight line through an on-curve point and the both off-curve points (often called "handles" because you can pull on them to drag the curve around) to the left and right of it - as you can see in the first join above. The second join has handles at differing angles, so it is a corner join.
平滑连接所需的条件是：连接点与其左右两侧的相邻控制点在同一条直线上。这种在曲线上的（起始和终结）点和控制点之间的连线通常被叫做“手柄”，因为你可以通过拉动它们来控制曲线。@figure:m-top 中的第一个连接处就是平滑的，而第二个连接处的两个手柄角度不同，它们并不在一条直线上，所以是一个转角连接。

// Your font editor will have ways of creating smooth and corner joins; the problem is that what we've called a "smooth" join, formed by aligning the angles of the handles (which is called *C1* continuity), isn't guaranteed to be *visually* smooth. Consider the following two paths:
字体编辑器通常会有各种方式来构造平滑或者转角连接。但问题是，即使是这种手柄在同一直线上的光滑连接（这也被称为*C1*连续），也不能保证它在*视觉*上是光滑的。看看@figure:g2 中的两个示例。

#figure(caption: [
  连续性的区别
])[#include "g2.typ"] <figure:g2>

// Do they look very similar? How about if you think of them as roads - which is easier to drive on? The upper path will require you to bring your steering wheel back to central for the straighter portion where the two Bézier curves join, before turning right again. The lower path continuously curves so that if you get your steering wheel in the right place at the start of the road, you hardly need to turn the wheel as you drive along it. Many font editors have facilities for matching the curvature on both sides of the on-curve point (which is known as G2 continuity), either natively or through add-ons like [SpeedPunk](https://yanone.de/software/speedpunk/) or [SuperTool](http://www.corvelsoftware.co.uk/software/supertool/).
它们看起来很相似。但如果把这两条线想象成道路的话，在哪一条路上开车更简单更舒适呢？上面那条路，你在起点处方向盘是在初始位置，而在两条贝塞尔曲线的交点处也需要把方向盘回正，然后再重新打方向继续转弯。而下面那条路，你可以在起点就把方向盘摆到一个正确的位置，而沿着这条路开的时候几乎不需要再动方向。许多字体编辑器都提供了为曲线上的点进行这种曲率匹配（也称为 G2 连续）的能力。有些软件内置这种功能，其他一些也可以通过Speed Punk#[@Yanone.SpeedPunk]或SuperTool#[@Cozens.SuperTool.2019]等插件完成。

// ## Color and bitmap fonts
== 彩色与#tr[bitmap]字体

// We've seen that OpenType is now the leading font format in the digital world, and that it contains glyphs made out of Bézier curves. But you can actually draw glyphs in other ways and embed them in OpenType fonts too.
我们已经知道OpenType是目前数字世界中字体格式的领军人物，它其中的#tr[glyph]使用贝塞尔曲线构造。但你其实也可以通过其他的方式绘制#tr[glyph]并把它们嵌入OpenType字体中。

// As we saw in the history chapter, the earliest fonts were bitmap fonts: all of the glyphs were pictures made out of pixels, which were not scalable. But the early fonts had quite small bitmaps, and so didn't look good when they were scaled up. If the bitmap picture inside your font is big enough, you would actually be scaling it *down* at most sizes, and that looks a lot better.
在介绍字体历史的章节中，最早出现的数字字体是#tr[bitmap]的：所有#tr[glyph]实际上是像素组成的图片，它们没法缩放。但这是因为早期的字体中的#tr[bitmap]都很小，所以在放大显示时观感不佳。但如果字体中的#tr[bitmap]图足够大的话，实际上大多数情况下是在*缩小*它们的尺寸，而这就比放大的效果要好多了。

// And of course, another thing that's happened since the 1960s is that computer displays support more than one colour. The rise of emoji means that we now expect to have fonts with multi-colored glyphs - meaning that the font determines the colors to paint the glyph in, instead of having the application specify the color.
自从20世纪60年代以来，计算机显示领域发生的另一个巨大变化是它支持了多色显示。emoji 的大量出现也让我们希望字体能够显示出多种颜色的#tr[glyph]，这就意味着现在字体需要决定#tr[glyph]用什么颜色来绘制。在此之前这都是由应用程序来控制的。

// OpenType gives you a range of options for embedding colored and bitmapped images into your fonts: monochrome bitmaps, color bitmaps, color fonts, "Apple-style color fonts", and SVG fonts. These options can be mixed and matched; you can use more than one of these technologies in the same font, to allow for a greater range of application compatibility. For example, at the time of writing, a font with "color font" (COLR) outlines and SVG outlines will have the SVG outlines displayed on Firefox and the COLR outlines displayed on Internet Explorer and Chrome (which do not support SVG). The color bitmap font format (CBDT) is only really used by Google for emoji on Android.
OpenType 为在字体中嵌入带有颜色的#tr[bitmap]图片提供了多种选择：灰度#tr[bitmap]图、彩色#tr[bitmap]图、彩色字形、“Apple格式彩色图片”、SVG。你可以在字体里混合使用上述的多种技术，来提供最大的应用程序兼容性。比如在本书写作时，如果字体同时含有“彩色（`COLR`）”#tr[outline]和 SVG，则Firefox可以显示其中的 SVG，在还不支持 SVG 字体的 IE 和 Chrome 中则可以显示 `COLR` 彩色字形。彩色#tr[bitmap]图（`CBDT`）格式则只用在Google公司Android系统中的emoji上。

// See ["Color Fonts! WTF?"](https://www.colorfonts.wtf) for the latest news on support for color fonts by applications and browsers.
Color Fonts! WTF? 网站#[@Unknown.ColorFonts]介绍了各个应用和浏览器对于彩色字体格式支持情况的最新消息。
