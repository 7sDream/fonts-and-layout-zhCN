#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ### Mark positioning
=== 符号#tr[positioning]

// Anchors can also be used to position "mark" glyphs (such as accents) above "base" glyphs. The anusvara (nasalisation) mark in Devanagari is usually placed above a consonant, but where exactly does it go? It often goes above the descending stroke - but not always:
锚点也能够用来#tr[positioning]位于基本#tr[glyph]顶部的“符号”#tr[glyph]（比如变音符等）。天城文中在元音上会有表示鼻音化的随韵符，但它们的位置很难准确指定。它们通常位于#tr[decender]笔画的正上方，但也不总是这样：

#figure(placement: none)[#include "anusvara.typ"]

// Again, your font editor will usually help you to create the anchors which make this work, but let's see what is going on underneath. (We're looking at the Hind font from Indian Type Foundry.)
和之前一样，字体编辑软件通常会帮助你完成创建锚点的工作，但我们还是来看看这到底是怎么完成的。（本例我们使用的是 Indian Type Foundary 的 Hind 字体）

// According to Microsoft's [Devanagari script guidelines](https://docs.microsoft.com/en-us/typography/script-development/devanagari#shaping-engine), we should use the `abvm` feature for positioning the anusvara. First, we declare an anchor on the anusvara mark. We do this by asking for a mark class (even though there's only one glyph in this class), called `@MC_abvm.bindu`.
根据微软的天城文字体开发规范@Microsoft.DevelopingDevanagari，应该使用`abvm`特性来完成对随韵符的#tr[positioning]。首先，我们需要在随韵符#tr[glyph]中声明一个锚点，这可以通过创建一个符号类（虽然里面只有一个#tr[glyph]）来完成。我们把这个类叫做 `@MC_abvm.bindu`。

```fea
markClass dvAnusvara <anchor -94 642> @MC_abvm.bindu;
```

// This specifies a point (with coordinates -94,642) on the `dvAnusvara` glyph which we will use for attachment.
这在`dvAnusvara`#tr[glyph]中指定了一个坐标为 `(-94, 642)` 的点作为它的锚点。

// Next, in our `abvm` feature, we will declare how this mark is attached to the base glyphs, using the `pos base` (or `position base`) command: `pos base *baseGlyph* anchor mark *markclass*`
下一步，我们需要在 `abvm` 特性中定义这个符号需要衔接到基本#tr[glyph]的什么位置。这可以使用`pos base`（或者`position base`）命令，语法为：```fea pos base *baseGlyph* *anchor* mark *markclass*```。

```fea
feature abvm {
  pos base dvAA <anchor 704 642> mark @MC_abvm.bindu;
  pos base dvAI <anchor 592 642> mark @MC_abvm.bindu;
  pos base dvB_DA <anchor 836 642> mark @MC_abvm.bindu;
  #...
} abvm;
```

// This says "you can attach any marks in the class `MV_abvm.bindu` to the glyph `dvAA` at position 704,642; on glyph `dvAI`, they should be attached at position 592,642" and so on.
这段代码的意思是：你可以把`MV_abvm.bindu`符号类中的任何符号衔接到`dvAA`#tr[glyph]的 `(704, 642)` 座标处；对于`dvAI`#tr[glyph]，衔接到坐标 `(592, 642)`；以此类推。
