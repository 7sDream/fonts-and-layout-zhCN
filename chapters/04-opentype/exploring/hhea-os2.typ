#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ### Vertical metrics: `hhea` and `OS/2`
=== 纵向#tr[metrics]：`hhea` 和 `OS/2` 表

// Before this next test, we will actually add some outlines to our font: a capital A and a capital B:
在介绍下一部分之前，我们先要往测试字体中加入一些#tr[glyph]#tr[outline]，比如@figure:soource-sans-AB 中的A和B。

#figure(
  caption: [Paul Hunt 设计的 Source Sans 字体中的 A B #tr[glyph]]
)[
  #grid(
    columns: 2,
    inset: 0pt,
    image("sourcesans-A.png"),
    image("sourcesans-B.png"),
  )
] <figure:soource-sans-AB>

// After exporting the new font and converting it to XML again using TTX, let's have a look at the `hhea` and `OS/2` tables. These tables are used to set the global defaults that a rendering engine needs to know when using this font in horizontal typesetting. They represent one of the more unfortunate compromises of the OpenType standard, which brought together font files from both the Windows and Mac platforms. It's a cardinal rule of data handling that you shouldn't store the same value in two different places; if you do, they are practically guaranteed to end up either going out of sync, or being used in different ways. OpenType manages to display *both* of these failure modes.
用 `ttx` 把添加了新#tr[glyph]的字体转换成XML后，现在可以开始介绍`hhea`和`OS/2`表了。这两张表提供了文本横排时所需的全局默认值。用两张表来做同一件事再一次体现了OpenType标准中令人遗憾的妥协，它需要同时支持 Windows 和 Mac 平台上的不同历史标准。不应该把一个值重复储存在两个地方是数据处理中的经典规则。因为如果这么做，那迟早有一天这两个地方的值会不再一致，或者会被以不同的方式使用。OpenType不幸的两点全中。

首先，我们来看`hhea`表中的（一部分）内容：

```xml
<hhea>
  <!-- ... -->
  <ascent value="1000"/>
  <descent value="-200"/>
  <lineGap value="0"/>
  <advanceWidthMax value="618"/>
  <!-- ... -->
</hhea>
```

// At this point let's pause and skip down to the parts of the `OS/2` table which deal with glyph metrics. Because you can't say `OS/2` in valid XML, `ttx` writes it funny:
同时我们也看一下`OS/2`表中关于#tr[glyph]#tr[metrics]的部分。因为`OS/2`这个标识符无法在XML中作为元素名称使用，`ttx` 将它写作 `OS_2`：

```xml
<OS_2>
  <!-- ... -->
  <fsSelection value="00000000 01000000"/>
  <sTypoAscender value="800"/>
  <sTypoDescender value="-200"/>
  <sTypoLineGap value="200"/>
  <usWinAscent value="1000"/>
  <usWinDescent value="200"/>
  <sxHeight value="500"/>
  <sCapHeight value="700"/>
  <!-- ... -->
</OS_2>
```

// Immediately you should see that the font editor (I used Glyphs to produce this font) has chosen to provide different values for things that seem to be the same: `ascent` in `hhea` is 1000, and so is `usWinAscent` in `OS/2`, but we also have `sTypoAscender` which is set to 800. `descent` and `sTypoDescender` are -200, but `usWinDescent` is 200. Most confusingly, `lineGap` in `hhea` is 0 but `sTypoLineGap` in `OS/2` is 200, but if you look into the OpenType specification, you will find that `lineGap` in `hhea` is described as "typographic line gap" and `sTypoLineGap` is described as "the typographic line gap for this font". Sounds like the same thing, doesn't it?
很容易就能发现，字体编辑器（我这里使用的是Glyphs）在看起来含义相同的两个字段里填入了不同的值：`hhea`中的`ascent`值为1000，和`OS/2`中的`usWinAscent`相同，但它里面还有一个值为 800 的`sTypoAscender`；`descent`和`sTypoDescender`都是 -200，但`usWinDescent`又是200。更让人迷惑的是，`hhea`中的`lineGap`是0，`OS/2` 中 的`sTypoLineGap` 却是 200。如果你觉得它们描述的是两个不同的参数，那看看OpenType标准规范中是怎么说的吧：`lineGap`的含义是“行间距”；`sTypoLineGap`的含义是“此字体的行间距”。这明明看上去就是一回事吧？

// Finally, bit 7 of the `fsSelection` flag is set. The description of bit 7 in the OpenType standard reads "if set, it is strongly recommended to use `OS/2.sTypoAscender - OS/2.sTypoDescender + OS/2.sTypoLineGap` as a value for default line spacing for this font."
然后，`fsSelection`字段的第七个比特位为1。这个比特在OpenType规范中定义为：“如果设置为1，则强烈推荐使用`OS/2.sTypoAscender - OS/2.sTypoDescender + OS/2.sTypoLineGap`作为此字体的默认行距”。

// What on earth is going on?
这到底是在干嘛呢？

// The problem, once again, is that not only did Macintosh and Windows have their own font formats, they each had their own interpretation of how the metrics of a font should be interpreted. Things were bad enough when the only consumers of fonts were the Windows and Mac operating systems, but now word processors, page layout programs, web browsers and a wide range of other software peek into the metrics of fonts and interpret the values in their own special way.
之所以有这些问题，不只是因为我们提到过的 Mac 和 Windows 平台的字体格式不同，更重要的原因是它们对如何理解和处理字体的#tr[metrics]也有不同意见。而现在除了这两个系统之外，又多了文字处理软件、页面排版软件、浏览器等等各种字体使用者。这些使用者各自使用不同的方式理解字体中的属性值，这就让问题更加严重了。

// In particular, when we are talking about global scripts with glyph proportions and line spacing that can differ significantly from Latin glyphs, the default mechanisms of font browsers for computing these values may not be ideal, and they may not provide identical results across platforms. So you may well need to play with some of these values yourself.
特别是我们现在还是在讨论#tr[global scripts]，某些#tr[scripts]的#tr[glyph]属性、行间距等参数可能和拉丁字符有天壤之别。字体浏览器计算这些值的默认方式可能也不一致，可能导致不同的平台上的展示效果也不相同。所以你可能需要手工仔细调整这些值。

// How are they used? To see what's going on, I made this special glyph in position `C`:
这些值到底是干什么用的？为了更好的说明，我在`C`的位置上画了一个特殊的#tr[glyph]：

#figure(
  placement: none,
  caption: [一个用于测量的特殊#tr[glyph]]
)[
  #v(4em)
  #text(font: ("TTX Test",), size: 10em)[C]
  #v(6em)
]

// On my Mac, the TextEdit application seemed to struggle with this, sometimes clipping off the top of the `1000` and anything below the center of the `-200`, and sometimes maintaining it:

// Safari, Firefox and Illustrator all do this:

// (Although when I select the glyph in Illustrator, the selection extends to slightly *more* than 500 points below the baseline. I have no idea why this is.)

在我的Mac系统上，TextEdit应用似乎很难正确处理这个#tr[glyph]。有时候最上面的`1000`和`-200`以下的所有内容都会被截断（@figure:textedit-safari 左半），但有时又不会。

Safari，Firefox和Illustrator三个软件的结果一致（@figure:textedit-safari 右半）。不过在Illustrator中选中#tr[glyph]时，反色选区会略微超过基线以下500单位的位置，我不清楚其中的原因。

#figure(
  caption: [不同应用的显示结果。左图为TextEdit，右图为Safari等]
)[
  #grid(
    fill: white,
    columns: 2,
    column-gutter: 2em,
    image("textedit.png"),
    image("safari.png"),
  )
] <figure:textedit-safari>

// The `usWinAscent` and `usWinDescent` values are used for text *clipping* on Windows. In other words, any contours above 1000 or below -200 units will be clipped on Windows applications. On a Mac, the relevant values for clipping are `hhea`'s `ascender` and `descender`. Mac uses `hhea`'s `lineGap` to determine line spacing. As we can see from our Safari example, there is no gap between the lines: the first line's descender at -200 units lines up perfectly with the second line's ascender at 1000 units. Finally, the `typo` values are used by layout applications to position the first baseline of a text block and set the default line spacing.
`usWinAscent`和`usWinDescent`这两个值是 Windows 平台用于截断文本的。也就是说，Windows 平台的软件在显示时会将 1000 以上和 -200 以下的所有东西都裁切去除。在 Mac 上，和截断相关的值是 `hhea` 表中的 `ascender` 和 `descender`。Mac用`hhea`中的`lineGap`来决定行间距，这里的值是 0。所以正如@figure:textedit-safari 中Safari所显示的那样，两行文本间没有空隙，第一行的 -200 和第二行的 1000 位于相同高度。剩下的 `typo` 系列属性用于排版系统中，用以确定文本块中第一行的#tr[baseline]位置和默认行距。

// So how should actually we set these values? Unfortunately, there is not a real consensus on the "right" way to do this - the major foundries each have their own strategies - but hopefully by being aware of what the relevant values do, you should now know what to test for and how to adjust your font's metrics where there are problems. To get you started, here is our recommended method (distilled from a discussion on [Typedrawers](http://typedrawers.com/discussion/1705)):
所以我们到底该怎么设置这些值呢？很抱歉，没有哪一种方法是绝对“正确”的，每个开发商都有自己的设置策略。但只要知道了这些值的用途，你就知道在设计字体时需要测试哪些问题，并且如何对#tr[metrics]进行相应的调整了。推荐先按如下的方式设置（来自Typedrawers论坛上的讨论帖@WeiHuang.WebfontVertical.2016）：

// * The `sTypoAscender` minus the `sTypoDescender` should equal the unit square. (Usually 1000 units.)
- `sTypoAscender - sTypoDescender` 应该等于#tr[em square]的高度。
// * `sTypoLinegap` should be the default linespacing distance for your intended language environment.
- `sTypoLinegap` 应该等于目标语言环境中的默认行距。
// * `lineGap` should be zero.
- `lineGap` 应该设置为 0。
// * `usWinAscent` and `usWinDescent` should be set so that no clipping occurs. If your font contains glyphs with tall, stacked accents - for instance, the Vietnamese letter LATIN CAPITAL LETTER A WITH BREVE AND HOOK ABOVE (Ẳ) - you will need to ensure that these values can accommodate the highest (and lowest) *possible* values of your shaped text. They should also be set so that they sum to *at least* the value of `sTypoAscender - sTypoDescender + sTypoLinegap`.
- `usWinAscent` 和 `usWinDescent` 应该被设置成不会导致任何裁切的值。如果你的字体中会往较高#tr[glyph]上继续堆叠符号的话（比如越南字母 `LATIN CAPITAL LETTER A WITH BREVE AND HOOK ABOVE` Ẳ），你需要保证这两个值比文本#tr[shaping]后可能达到的最高（或最低）值还大。另外这两个值的和至少应该大于`sTypoAscender - sTypoDescender + sTypoLinegap`。
// * `ascent` and `descent` should be set to the same values as `usWinAscent` and `usWinDescent`, remembering that `usWinDescent` is positive and `descent` is negative.
- `ascent`、`descent` 应该和 `usWinAscent`、`usWinDescent` 设置为相同的值。但要注意 `usWinDescent` 是正数，而对应的 `descent` 需要是负数。
// * Bit 7 of `fsSelection` should be turned on.
- `fsSelection`的第7位应该设置成1。

// If you don't like this strategy, there are plenty of others to choose from. The [Glyphs web site](https://www.glyphsapp.com/tutorials/vertical-metrics) describes the strategies used by Adobe, Microsoft and web fonts; [Google fonts](https://github.com/googlefonts/gf-docs/tree/main/VerticalMetrics) has another. Karsten Lucke has a [guide](https://www.kltf.de/downloads/FontMetrics-kltf.pdf) which goes into all of this in excruciating detail but finally lands on the strategy mentioned above.
如果你不喜欢这种设置策略，也可以选择其他方式。Glyphs的网站上描述了 Adobe公司、微软公司和网页字体标准中的设置策略@Scheichelbauer.ZongXiang.2012。Google Fonts也有自己的策略@GoogleFonts.VerticalMetrics。Karsten Lucke 写了一篇关于如何调整这些值的指南@Lucke.FontMetrics，不过最后也归纳为了我们上面描述的策略。

// Yes, this is a complete hot mess. Sorry.
很抱歉，但确实就是这么混乱。
