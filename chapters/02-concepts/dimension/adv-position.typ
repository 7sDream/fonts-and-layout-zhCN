#import "/template/template.typ": web-page-template
#import "/template/components.typ": note
#import "/template/lang.typ": arabic

#import "/lib/glossary.typ": tr

#show: web-page-template

// ### Advance and Positioning
=== #tr[advance]和#tr[position]

// *advance*, whether horizontal or vertical, tells you how far to increment the cursor after drawing a glyph. But there are situations where you also want to change *where* you draw a glyph. Let's take an example: placing the fatha (mark for the vowel "a") over an Arabic consonant in the world ولد (boy):
无论是水平或垂直的*#tr[advance]*，都是在告诉我们#tr[cursor]需要在绘制完当前#tr[glyph]后移动多远。但有时你也会希望改变绘制这个#tr[glyph]的*位置*。比如这个阿拉伯语的例子：需要将 fatha（标识元音a的符号）放在单词#arabic[وَلَد]（孩子）中的辅音上：

#figure(caption: [
  “孩子”的阿拉伯文
], placement: none)[#include "walad.typ"] <figure:walad>

// We place the first two glyphs (counting from the left, even though this is Arabic) normally along the baseline, moving the cursor forward by the advance distance each time. When we come to the fatha, though, our advance is zero - we don't move forward at all. At the same time, we don't just draw the fatha on the baseline; we have to move the "pen" up and to the left in order to place the fatha in the right place over the consonant that it modifies. Notice that when we come to the third glyph, we have to move the "pen" again but this time by a different amount - the fatha is placed higher over the lam than over the waw.
我们沿着基线正常放置开头（从左往右算，即使是阿拉伯文）的两个#tr[glyph]，每次将#tr[cursor]向前步进一段距离。当遇到fatha符号，发现它的步进值是0，也就是完全不需要向前移动。但此时并不能直接在基线上绘制这个符号，我们需要将“画笔”往左上角移动，来让 fatha 符号位于它需要标注的辅音上方的正确位置处。对于第三个#tr[glyph]，为了绘制它上面的 fatha，“画笔”也需要进行类似的移动，但移动的距离不同：字母lam（#arabic[ل]）上的 fatha 会比字母waw（#arabic[و]）上的高一些。

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
