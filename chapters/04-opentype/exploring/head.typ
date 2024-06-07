#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ### The `head` table
=== `head` 表

// `head` is a general header table with some computed metadata and other top-level information about the font as a whole:
`head`表中储存的是整个字体的基本信息和一些计算出的元数据：

```xml
<head>
  <!-- 此表中的大部分数据会在编译时自动计算和更新 -->
  <tableVersion value="1.0"/>
  <fontRevision value="1.0"/>
  <checkSumAdjustment value="0x9fe5c40f"/>
  <magicNumber value="0x5f0f3cf5"/>
  <flags value="00000000 00000011"/>
  <unitsPerEm value="1000"/>
  <created value="Tue Sep 20 15:02:17 2016"/>
  <modified value="Tue Sep 20 15:02:17 2016"/>
  <xMin value="93"/>
  <yMin value="-200"/>
  <xMax value="410"/>
  <yMax value="800"/>
  <macStyle value="00000000 00000000"/>
  <lowestRecPPEM value="3"/>
  <fontDirectionHint value="2"/>
  <indexToLocFormat value="0"/>
  <glyphDataFormat value="0"/>
</head>
```

// The most interesting values here for font designers and layout programmers are `unitsPerEm` through `macStyle`.
这些值中，字体设计师和排版程序开发者们最关心的是从`unitsPerEm`到`macStyle`的部分。

// The `unitsPerEm` value, which defines the scaling of the font to an em, must be a power of two for fonts using TrueType outlines. The most common values are 1000 for CFF fonts and 1024 for TrueType fonts; you may occasionally come across fonts with other values. (Open Sans, for instance, has an upem of 2048.)
`unitsPerEm`定义了字体中单位长度和`em`之间的比例关系。在使用TrueType#tr[outline]的字体中必须设置成2的整数次方，一般会使用1024。使用CFF表示法的字体则一般设置成1000。偶尔也会碰到使用其他值的字体，比如Open Sans字体的`unitsPerEm`值为2048。

#note[
  // > If you are writing a font renderer, you should not make assumptions about this value!
  在编写字体渲染器时不应对这个值有任何预先假设！
]

// `created` and `modified` are mostly self-explanatory; in OpenType's binary representation they are actually stored as seconds since January 1st 1904, (Mac versions prior to OS X used this as their *epoch*, or reference point.) but `ttx` has kindly converted this to a more readable time value.
`created`和`modified`这两个值的意义不言自明。但需要知道的是，它们在二进制表示中其实储存的是从1904年1月1日到目标时间的秒数。Mac 系统在 OS X 版本前用这个特定日期作为其时间零点，或者叫参考点。`ttx` 工具把这个秒数自动转换为了更加易读的日期时间表示。

// `xMin` through `yMax` represent the highest and lowest coordinates used in the font. In this case, the `.notdef` glyph - the only glyph with any outlines - stretched from -200 below the baseline to 800 units above it, has a left sidebearing of 93, and its right edge falls at X coordinate 410.
`xMin`到`yMax`这四个值告诉我们字体中使用的坐标的最大最小值。在本例中，唯一有实际#tr[outline]的`.notdef`#tr[glyph]在竖直方向上具有从-200到800的跨度（这里负数表示位置在#tr[baseline]之下，正数则是#tr[baseline]之上）。它的左#tr[sidebearing]为93，右边缘则位于X坐标410的位置。

// The `macStyle` value is a bit field, used, as its name implies, to determine the style of the font on Mac systems. It consists of two bytes; the one on the left is not used, and the bits in the one of the right have the following meanings:
`macStyle`值中的每个比特位表示一个状态开关，正如其名称所示，Mac系统用这个值来确定字体的样式。它包含两个字节，其中左侧字节的没有使用，右侧字节的每一位的含义如下：

/*
|-|----------|
|0|Bold |
|1|Italic |
|2|Underline |
|3|Outline |
|4|Shadow |
|5|Condensed |
|6|Extended |
|7|(unused) |
|-|-----------|
*/
#align(center, table(
  columns: 2,
  align: left,
  ..for (i, v) in (
    [粗体],
    [意大利体],
    [下划线],
    [#tr[outline]],
    [阴影],
    [窄体],
    [宽体],
    [(未使用)]
  ).enumerate() { (str(i), v,) }
))

// So a bold italic condensed font should have a `macStyle` value of `00000000 00100011` (remember that we count from the right in binary).
所以，一个粗窄意大利体字体的`macStyle`值就会是 `00000000 00100011`（注意字节中最低的位在最右边）。
