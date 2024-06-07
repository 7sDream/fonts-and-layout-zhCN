#import "/template/template.typ": web-page-template
#import "/template/components.typ": note, cross-ref

#import "/lib/glossary.typ": tr

#show: web-page-template

// ### The `hmtx` table
=== `hmtx` 表

// Let's go back onto somewhat safer ground, with the `hmtx` table, containing the horizontal metrics of the font's glyphs. As we can see in the screenshots from Glyphs above, we are expecting our /A to have an LSB of 3, an RSB of 3 and a total advance width of 580, while the /B has LSB 90, RSB 40 and advance of 618.
包含横向#tr[metrics]信息的 `hmtx` 表的情况稍好一些。从#cross-ref(<figure:soource-sans-AB>, web-path: "/chapters/04-opentype/opentype-3-2.typ", web-content: [此前]) 的 Glypys 截图中可以看出，我们测试字体中的 A 的左#tr[sidebearing]（LSB）和右#tr[sidebearing]（RSB）都是3，#tr[advance width]是580。#tr[glyph] B 则是 LSB 为 90，RSB 为 40，#tr[advance width] 618。

// Mercifully, that's exactly what we see:
这和XML中显示的完全一致：

```xml
<hmtx>
  <mtx name=".notdef" width="500" lsb="93"/>
  <mtx name="A" width="580" lsb="3"/>
  <mtx name="B" width="618" lsb="90"/>
</hmtx>
```

// There are vertical counterparts to the `hhea` and `hmtx` tables (called, unsurprisingly, `vhea` and `vmtx`), but we will discuss those when we look at implementing global typography in OpenType.
`hhea`和`hmtx`中的信息会在文本横排时使用，这些信息也有对应的竖排版本，储存在 `vhea` 和 `vmtx` 表中。我们会在后面介绍如何用 OpenType 实现#tr[global scripts]的排版时再讨论它们。
