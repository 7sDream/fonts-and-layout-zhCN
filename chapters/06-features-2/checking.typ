#import "/template/template.typ": web-page-template
#import "/template/components.typ": note
#import "/template/consts.typ"

#import "/lib/glossary.typ": tr

#show: web-page-template

// Using hb-shape to check positioning rules
== 使用 `hb-shape` 检查#tr[positioning]规则

// In the previous chapter we introduced the Harfbuzz utility `hb-shape`, which is used for debugging the application of OpenType rules in the shaper. As well as looking at the glyphs in the output stream and seeing their advance widths, `hb-shape` also helps us to know how these glyphs have been repositioned in the Y dimension too.
在上一章中我们介绍了HarfBuzz的`hb-shape`工具，并用它调试了#tr[shaper]对OpenType规则的应用。我们看到它可以显示#tr[glyph]在原输入流中的位置，以及它们的#tr[advance width]信息。其实它也可以帮助我们了解#tr[glyph]在Y轴方向上进行了怎样的重#tr[positioning]。

// For example, suppose we are using a mark-to-base feature to position a virama on the Devanagari letter CHA:
比如这个在天城文字母`CHA`上使用锚点对`virama`符号进行#tr[positioning]的例子：

```fea
markClass @mGC_blwm.virama_n172_0 <anchor -172 0> @MC_blwm.virama;
pos base dvCHA <anchor 276 57> mark @MC_blwm.virama;
```

// What this says is "the attachment point for the virama is at coordinate (-172,0); on the letter CHA, we should arrange things so that attachment point falls at coordinate (276,57)." Where does the virama end up? `hb-shape` can tell us:
这段代码的含义是：`virama`的锚点在坐标`(-172, 0)`处；在`CHA`字母上如果要附加`virama`符号，就将其锚点放在坐标`(276, 57)`处。那么`virama`现在到底位于什么#tr[position]呢？使用`hb-shape`可以得知：

#[
#show raw: set text(font: consts.font.western-mono + ("Hind",))

```bash
$ hb-shape build/Hind-Regular.otf 'छ्'
[dvCHA=0+631|dvVirama=0@-183,57+0]
```
]

// So we have a CHA character which is 631 units wide. Next we have a virama which is zero units wide! But when it is drawn, its position is moved - that's what the "@-183,57" component means: we've finished drawing the CHA, and then we move the "pen" negative 183 units in the X direction (183 units to the left) and up 57 units before drawing the virama.
首先我们看到，`CHA`#tr[character]有631单位宽。然后下一个是0宽度的`virama`！不过它的绘制位置移动了，输出中的 `@183,57`的意思是：当画完`CHA`字母后，将画笔向X轴负方向（也就是向左）移动183单位，再向上移动57个单位，然后再绘制`virama`。

// Why is it 183 units? First, let's see what would happen *without* the mark-to-base positioning. We can do this by asking `hb-shape` to turn off the `blwm` feature when processing:
为什么是 183 个单位呢？我们先来看看在进行#tr[positioning]前是什么样的。这可通过关闭`blwm`特性来实现：

#[
#show raw: set text(font: consts.font.western-mono + ("Hind",))

```bash
$ hb-shape --features='-blwm' Hind-Regular.otf 'छ्'
[dvCHA=0+631|dvVirama=0+0]
```
]

// As you can see, no special positioning has been done. Another utility, `hb-view` can render the glyphs with the feature set we ask for. If we ask to turn off the `blwm` feature and see what the result is like, this is what we get:
正如你所见，这样的话就没有什么特殊的#tr[positioning]操作了。我们可以使用`hb-view`工具来渲染当前特性集下#tr[glyph]的实际样子。结果如下：

#[
#show raw: set text(font: consts.font.western-mono + ("Hind",))

```bash
$ hb-view --features='-blwm' Hind-Regular.otf 'छ्' -O png > test.png
```
]

#figure(
  placement: none,
)[#image("hind-bad-virama.png", width: 30%)]

#note[
  // > You can also make `hb-view` output PNG files, PDFs, and other file formats, which is useful for higher resolution testing. (Look at `hb-view --help-output` for more options.) But the old-school ANSI block graphics is quite cute, and shows what we need in this case.
  你可以让`hb-view`输出PNG、PDF等各种格式（`hb-view --help-output`可以查看相关选项），这对高分辨率测试很有用。但老式的ANSI块状#tr[character]组成的图形很有意思，而且在这个例子中也够用了。
]

// Obviously, this is badly positioned (that's why we have the `blwm` feature). What needs to happen to make it right?
很明显，这个符号的位置不对（所以我们才需要`blwm`特性）。现在如果想让它回到正确的位置，需要怎么做呢？

#figure(
  placement: none,
)[#include "virama-pos.typ"]

// As you can see, the glyph is 631 units wide (Harfbuzz told us that), so we need to go back 355 units to get to the CHA's anchor position. The virama's anchor is 172 units to the left of that, so in total we end up going back 183 units. We also raise the glyph up 57 units from its default position.
我来解释一下这张图。`CHA`这个#tr[glyph]的宽度是631（HarfBuzz告诉我们的），所以我们要往回355个单位才能走到`CHA`中锚点的水平位置。`virama`的锚点在局部坐标-172单位处，所以整体上来看我们需要将它往左移183单位。为了锚点对齐，还需要将它向上移动57单位。

// This example was one which we could probably have tested and debugged from inside our font editor. But as our features become more complex, `hb-shape` and `hb-view` become more and more useful for understanding what the shaper is doing with our font files.
这个例子中的测试和调试工作可能在字体编辑软件中就能完成。但当特性变得越来越复杂的时候，`hb-shape`和`hb-view`就会变得越来越有用。它们可以帮助你理解#tr[shaper]到底是如何和你的字体文件协同工作的。
