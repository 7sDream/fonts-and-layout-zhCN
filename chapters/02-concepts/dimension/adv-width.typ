#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

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
包含#tr[glyph]中所有“黑色部分”的矩形叫做*#tr[ink rectangle]*，或者*#tr[outline]#tr[bounding box]*。在我们之前看过的孟加拉文#tr[glyph]中，因为想要制造一种重叠的效果，会让它的#tr[horizontal advance]比#tr[outline]#tr[bounding box]要*小*，。但大多数文种都需要在#tr[glyph]的周围留有一些空间，来让读者能够更容易地逐个阅读每个#tr[glyph]，这时#tr[horizontal advance]就会稍微比#tr[outline]#tr[bounding box]宽一些。在#tr[outline]#tr[bounding box]和整个字形的#tr[bounding box]之间的这些空间叫做#tr[sidebearing]：

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
