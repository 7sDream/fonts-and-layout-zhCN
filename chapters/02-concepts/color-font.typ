#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

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
