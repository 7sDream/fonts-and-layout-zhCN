#import "/template/template.typ": web-page-template
#import "/template/components.typ": note, cross-link

#import "/lib/glossary.typ": tr

#show: web-page-template

// ### Cursive attachment
=== #tr[cursive attachment]

// One theme of this book so far has been the fact that digital font technology is based on the "Gutenberg model" of connecting rectangular boxes together on a flat baseline, and we have to work around this model to accomodate scripts which don't work in that way.
本书的一个主题是数字字体技术是基于“古腾堡模型”的这一事实。它使用的是一个沿着平坦的基线逐个排列矩形块的模型。我们需要解决的问题就是如何让这个模型能够容纳并不使用上述书写方式的各种#tr[script]。

// Cursive attachment is one way that this is achieved. If a script is to appear connected, with adjacent glyphs visually joining onto each other, there is an easy way to achieve this: just ensure that every single glyph has an entry stroke and an exit stroke in the same place. In a sense, we did this with the "headline" for our Bengali metrics in [chapter 2](concepts.md#Units). Indeed, you will see some script-style fonts implemented in this way:
#tr[cursive attachment]是实现这一目标的一种方式。比如有些#tr[scripts]需要相邻的#tr[glyph]互相连接，有一个简单的方式可以搞定这个需求：只要确保每个#tr[glyph]都有位于同一位置的入笔和出笔即可。我们在#cross-link(<pos:bengali-headline>, web-path: "/chapters/02-concepts/dimension/units.typ")[前文]对孟加拉文字体#tr[metrics]中的#tr[headline]的介绍中其实就使用了这一方法。也有其他草书风格的字体会使用这种实现方式：

// TODO: 重画这个连笔英语字体的图片
#figure(
  placement: none,
)[#image("connected-1.png")]

// But having each glyph have the same entry and exit profile can look unnatural and forced, especially as you have to ensure that the curves don't just have the same *height* but have the same *curvature* at each entry and exit point. (Noto Naskh Arabic somehow manages to make it work.)
但只是让每个#tr[glyph]都有相同位置的出入笔画看上去会有些不自然。而且，为了达成这个目的并不是让出入笔画位置一致就可以的，它们还需要具有相同的曲率。（虽然Noto Naskh Arabic字体还是成功运用了这个方案）

// A more natural way to do it, particularly for Nastaliq style fonts, is to tell OpenType where the entry and exit points of your glyph are, and have it sew them together. Consider these three glyphs: two medial lams and an initial gaf.
更自然的方式是告诉OpenType每个#tr[glyph]的出入点，让它可以自动连接这两个点。这种方式对于波斯体来说尤其合适。我们以 `<gaf> <lam> <lam>` （其中`gaf` 为词首，`lam`为词中形式）这三个#tr[glyph]为例来看看。

#figure(
  placement: none,
)[#table(
  columns: (3fr, 2fr),
  fill: white,
  align: bottom,
  inset: 1pt,
  [#image("gaf-lam-lam-1.png")],
  [#image("gaf-lam-lam-2.png")],
)]

#note[
  // > (Outlines from Noto Nastaliq Urdu)
  #tr[glyph]#tr[outline]来自Noto Nastaliq Urdu字体
]

// As they are, they all sit on the same baseline and don't connect up at all. Now we will add entry and exit anchors in our font editing software, and watch what happens.
左图展示的是这些#tr[outline]在进行连接前的原本的样子，基线位于底部相同位置。右图是我们在字体编辑软件中为它们添加入口和出口锚点之后发生的变化。

// Our flat baseline is no longer flat any more! The shaper has connected the exit anchor of the gaf to the entry anchor of the first lam, and the exit anchor of the first lam to the entry anchor of the second lam. This is cursive attachment.
看上去基线不再是平的了！#tr[shaper]将`gaf`的出锚点和第一个`lam`的入锚点连在了一起，然后第一个`lam`的出锚点又连到了第二个`lam`的入锚点。这种方式就叫做#tr[cursive attachment]。

// Glyphs has done this semi-magically for us, but here is what is going on underneath. Cursive attachment is turned on using the `curs` feature, which is on by default for Arabic script. Inside the `curs` feature are a number of cursive attachment positioning rules, which define where the entry and exit anchors are:
Glyphs 软件会半自动的为我们完成这个特性，但我们还是介绍下在内部到底发生了什么。#tr[cursive attachment]经由`curs`特性开启，这个特性在阿拉伯文环境下是默认启用的。`curs`特性中会有一些#tr[cursive attachment]#tr[positioning]规则，用于规定这些出入锚点的位置：

```fea
feature curs {
    lookupflag RightToLeft IgnoreMarks;
    position cursive lam.medi <anchor 643 386> <anchor -6 180>;
    position cursive gaf.init <anchor NULL> <anchor 35 180>;
} curs;
```

// (The initial forms have a `NULL` entry anchor, and of course final forms will have a `NULL` exit anchor.) The shaper is responsible for overlaying the anchors to make the exit point and its adjacent entry point fit together. In this case, the leftmost glyph (logically, the last character to be entered) is positioned on the baseline; this is the effect of the `lookupflag RightToLeft` statement. Without that, the rightmost glyph (first character) would be positioned on the baseline.
（词首形式的#tr[glyph]的入锚点是`NULL`，同理，词尾形式的#tr[glyph]的出锚点也是`NULL`。）#tr[shaper]需要负责让两个相邻锚点正确重叠。在上例中，最后是把最左边的（也就是最后输入的）#tr[glyph]放在#tr[baseline]上，这是由 `lookupflag RightToLeft` 这个#tr[lookup]选项语句控制的。如果不加这个选项，会把最右边的（输入的第一个）#tr[glyph]放在#tr[baseline]上。
