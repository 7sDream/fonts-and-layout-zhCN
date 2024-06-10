#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ### Units
=== 单位

// First, though, how do you measure stuff in a font? When fonts were bits of metal, it was easy: you could use callipers or a micrometer to measure the sort, and get an answer in millimeters or printers points. But digital fonts, as we've seen in the previous chapter, are meant to be scalable; that is, usable at any size. With scalable fonts, there isn't such a thing as a 12pt Times Roman as distinct from a 16pt Times Roman; there isn't any *size* there at all.
首先有个疑问，在进行字体设计时我们怎么测量长度呢？当字体还是金属的时代这很容易，使用卡尺或者千分尺之类的工具就可以量出#tr[sort]的尺寸，用厘米或者点（pt）作为单位来记录即可。但数字字体，我们在上一章讨论过，它可以以任意大小显示。对于这些可缩放的字体来说，12pt和16pt的Times Roman并没有什么区别，它们根本没有大小这个概念。

// So coordinates and size values inside digital fonts are defined in terms of an *em square*, which is itself divided into an arbitrary number of *units*, typically 1000, 1024 or 2048. If we want to display text at 12 points, we draw the *em square* at that size, and then scale up the design to match.
数字字体内的坐标和尺寸由*#tr[em square]*来确定，它的高度会被分成任意数量个小单元，一般会是1000，1024或者2048个单位。如果我们希望显示12pt的文本，就把*#tr[em square]*定为这个尺寸，具体的字符设计就自然地缩放为相匹配的大小了。

#figure(caption: [
  #tr[glyph]在不同字号时的缩放
], include "units-graph.typ") <figure:units>

// We can see a number of things from this diagram. First, we notice that the glyph outline doesn't need to be contained within the em square itself. It's just a notional rectangular box, a kind of digital type sort. (Yes, the old lining-up-boxes model of typography again.) In this case, with Bengali script, we want to make sure that the headline is always connected, so there is a slight overlap between the glyphs to make this happen, leading to the outline of the headline jutting out the left and right side of the em square.
从@figure:units 中我们可以看出很多信息。首先，#tr[glyph]#tr[outline]不需要充满整个#tr[em square]，它只是一个用于参考的矩形框而已，就像#tr[sort]字身的数字版。（是的，又是古老的基于线和框那一套。）在图中的孟加拉文例子中，我们希望确保#tr[headline]总是连续的，所以将#tr[glyph]设计为有轻微的重叠，也就造成了这些#tr[headline]的#tr[outline]会突出于#tr[em square]的左右两侧。<pos:bengali-headline>

// Notice also that the baseline and full height of the glyph are not determined by the em square itself; the designer decides where to put the outlines within the em square, and even how high to make the outlines. This can mean that different digital fonts which are notionally the same type size actually appear at different sizes!
需要注意的是，#tr[baseline]和#tr[glyph]的高度并不由#tr[em square]决定。设计师会决定把它们放在#tr[em square]的什么位置，或者什么高度上。这也就意味着在使用相同的字号调用不同的字体时，实际的显示尺寸可以千差万别。

#figure(caption: [
  Noto Sans和Trajan字体#footnote[译注：原文使用的应该是Trajan Pro 3的图片，因直接嵌入字体数据的许可证问题，此处换成同风格的Cinzel。]中的字母H、x
], placement: none, include "notional-size.typ") <figure:notional-size>

// Here the designers of Noto Sans and Trajan have placed the outlines in the em square in different ways: Trajan uses a bigger body, a higher x-height, and fills up the square more, whereas Noto Sans leaves space at the top. (Both of them leave space at the bottom for descenders.) We'll look at the differing heights used in font design a little later, but for now just remember that because the em-square is a notional size and designers can put outlines inside it however they like, a 12pt rendering of one font may be "bigger" than a 12pt rendering of another, even if the em square is scaled to be the same size.
@figure:notional-size 展示了Noto Sans和Trajan两个字体在把#tr[outline]放进#tr[em square]时采用的不同方式：Trajan拥有一个更高的#tr[x-height]，它的体型更大，向上填满了整个方框；而Noto Sans则在上面留出了一些空间（两个字体都在下方为#tr[decender]预留了空间）。字体中的这些不同的高度会在后面的章节详述，现在只需要记住，因为#tr[em square]只是用于参考的名义上的边界，某个字体的12pt可能会比另一个字体的12pt更大，即使它们的#tr[em square]被缩放到了相同的大小。

// However, dividing this notional square up into a number of units gives us a co-ordinate system by which we can talk about where the outlines fall on the glyph. Instead of saying "make the horizontal stem width about a tenth of the height", we can say "make the horizontal stem width 205 units wide", and that'll be scalable - true for whatever size of font we're talking about.
但这个名义上的边界在被划分成小单元之后，我们就有了一个坐标系统，可以用于指定#tr[outline]位于整个#tr[glyph]的什么位置。我们不需要用“画一条大约是整体高度的1/10的水平#tr[stem]”这样的描述，只需要说“画一条205个单位宽的水平#tr[stem]”就行。而这也保持了可缩放的特性，因为对于任何字号来说这一描述都是成立的。

// We'll use these *font units* every time we talk about the dimensions within a font.
我们在讨论字体中的所有尺寸时都会使用这个单位长度。
