#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ### Kerns
=== #tr[kern]

// As we have mentioned, a layout system will draw a glyph, move the cursor horizontally the distance of the horizontal advance, and draw the next glyph at the new cursor position.
上文提到，#tr[layout]系统在绘制一个#tr[glyph]之后，会将光标水平移动一个#tr[horizontal advance]的距离，然后在新的坐标位置处开始绘制下一个#tr[glyph]。

#figure(placement: none)[#include "kerns-1.typ"]

// However, to avoid spacing inconsistencies between differing glyph shapes (particularly between a straight edge and a round) and to make the type fit more comfortably, the designer of a digital font can specify that the layout of particular pairs of glyphs should be adjusted.
然而为了让整篇文字看起来更舒适，各个#tr[glyph]（特别是竖直边缘和曲线边缘）的间距需要保持一致。数字字体设计师可以通过单独设置一对#tr[glyph]间的布局参数来调整这一间距。

#figure(caption: [间距调整])[#include "kerns-2.typ"] <figure:kern-2>

// In this case, the cursor goes *backwards* along the X dimension by 140 units, so that the backside of the ja is nestled more comfortably into the opening of the reh. This is a negative kern, but equally a designer can open up more space between a pair of characters by specifying a positive kern value. We will see how kerns are specified in the next two chapters.
在@figure:kern-2 的示例中，光标沿X轴*往回*走了140个单位，这样 ja 字母的弧线就会更加靠近 reh 字母的开口，这就是一个负的#tr[kern]。设计师也可以通过设置正的#tr[kern]来让两个#tr[glyph]的间距更大。在后续的两章中会具体介绍#tr[kern]是如何设置的。
