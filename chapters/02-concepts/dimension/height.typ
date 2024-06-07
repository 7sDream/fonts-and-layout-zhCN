#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

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
