#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## TrueType Representation
== TrueType#tr[outline]表示法

// So that was the PostScript format, which is the normal way of exporting OpenType fonts. But Glyphs allows us to output our test font with TrueType outlines, and if we do that, we see that things have changed:
以上我们介绍了 PostScript 格式，这也是导出 OpenType 字体时常用的#tr[outline]格式。但 Glyphs 也允许我们使用TrueType格式输出#tr[outline]。如果我们导出字体时开启了此选项，就能看到有些表发生了变化：

```bash
$ ttx -l TTXTest-Regular.ttf
Listing table info for "TTXTest-Regular.ttf":
    tag     checksum   length   offset
    ----  ----------  -------  -------
    DSIG  0x00000001        8     1960
    GSUB  0x00010000       10     1948
    OS/2  0x683D6762       96      764
    cmap  0x007700CF       74      860
    cvt   0x00000000        6     1416
    fpgm  0x47A67342      479      936
    gasp  0x001A0023       16     1932
    glyf  0xABA0B11E      368      252
    head  0x09740B40       54      660
    hhea  0x062F01A9       36      728
    hmtx  0x06A200BA       12      716
    loca  0x00840118        8      652
    maxp  0x00780451       32      620
    name  0xDF876A4F      465     1424
    post  0xFFDE0057       40     1892
```

// An OpenType font with TrueType outlines does not have a `CFF` table, but instead contains a number of other tables; two of which contain data about the glyphs themselves:
使用TrueType#tr[outline]的OpenType字体没有`CFF`表，但相对的会多出一些其他表。其中有两张表包含了#tr[glyph]信息：

/*
|`glyf`|Glyph data|
|`loca`|Index to location|
*/
#align(center, table(
  columns: 2,
  align: left,
  [`glyf`], [#tr[glyph]数据],
  [`loca`], [位置索引],
))

// And four which are used for hinting and rasterizing, which we will deal with in the appropriate chapter:
另外四张表用于#tr[hinting]和#tr[rasterization]过程，这些我们会在相应的章节中再详细介绍：

/*
|`prep`|The Control Value "pre-program"|
|`fpgm`|Font program|
|`cvt`|Data values used by the hint program|
|`gasp`|Information about how to render the font on grayscale devices|
*/
#align(center, table(
  columns: 2,
  align: left,
  [`prep`], [控制值预处理程序],
  [`fpgm`], [字体程序],
  [`cvt`], [#tr[hinting]程序中使用的数据值],
  [`gasp`], [关于如何在支持灰度的设备上渲染字体的信息],
))

// The names of the first two of these hinting tables are somewhat misleading. The "font program" (`fpgm`) is run once before the font is used, in order to set up definitions and functions for hinting, whereas the "pre-program" (`prep`) actually contains the size-specific font hinting instructions and is executed every time the font changes size. Yes, this is completely brain-dead.
前两个表名非常容易造成错误理解。字体程序（`fgpm`）是在字体被使用之前，用来初始化#tr[hinting]中需要用到的各种定义和函数的程序。而预处理程序（pre-program，`prep`）实际上是包含了和特定字体大小相关的#tr[hinting]指令，它在字体每次改变大小时都需要执行。这些名字起的确实有些烧脑。

// How are glyphs represented in TrueType outlines? The binary representation in the table is in a series of fixed-width arrays, containing instructions, relative coordinates and flags, (see the OpenType specification if you need to deal with the binary tables) but `ttx` expands them to a very friendly format for us:
那么TrueType到底使用什么方式表达#tr[glyph]#tr[outline]呢？在二进制文件中，这些表实际储存了一系列定长数组，它们包含了绘图指令，相对坐标和控制选项（如果你需要直接处理字体文件，可以参考OpenType规范文件）。而 `ttx` 工具会将他们转换为更加友好的格式：

```xml
<TTGlyph name="A" xMin="3" yMin="0" xMax="577" yMax="700">
  <contour>
    <pt x="240" y="700" on="1"/>
    <pt x="340" y="700" on="1"/>
    <pt x="577" y="0" on="1"/>
    <pt x="482" y="0" on="1"/>
    <pt x="416" y="213" on="1"/>
    <pt x="161" y="213" on="1"/>
    <pt x="94" y="0" on="1"/>
    <pt x="3" y="0" on="1"/>
  </contour>
  <contour>
    <pt x="394" y="285" on="1"/>
    <pt x="360" y="392" on="1"/>
    <pt x="320" y="518" on="0"/>
    <pt x="290" y="627" on="1"/>
    <pt x="286" y="627" on="1"/>
    <pt x="258" y="527" on="0"/>
    <pt x="233" y="449" on="1"/>
    <pt x="228" y="430" on="0"/>
    <pt x="216" y="392" on="1"/>
    <pt x="183" y="285" on="1"/>
  </contour>
  <instructions><assembly>
    </assembly></instructions>
</TTGlyph>
```

// Here we can see the two contours of our A, as a series of on-curve and off-curve points. Remember that TrueType uses *quadratic* Bézier curves, so within our aperture we only see one off-curve point between the on-point curves. Glyphs has converted our Béziers for us:
很明显 A 由两条#tr[contour]组成，这些线条由线上点和线外点控制。还记得 TrueType 使用的是*二次*贝塞尔曲线吧？所以在两个线上点之间，我们最多只会看见一个线外点。Glyph 在导出时自动帮我们进行了贝塞尔曲线的转换（@figure:bezier-convert）。

#figure(
  placement: none,
  caption: [三次贝塞尔曲线转换为二次]
)[#include "bezier.typ"] <figure:bezier-convert>

// Sometimes you might open up a `glyf` table and find something confusing:
有些时候`glyf`表里也会出现一些奇怪的东西：

```xml
<TTGlyph name="C" xMin="125" yMin="-20" xMax="1231" yMax="1483">
  <contour>
    <pt x="827" y="1331" on="1"/>
    <pt x="586" y="1331" on="0"/>
    <pt x="307" y="1010" on="0"/>
    <pt x="307" y="731" on="1"/>
      ...
```

// There are two off-curve points between the on-curves! Does this mean that we're suddenly using cubic Bézier curves in our TrueType outlines? Nope, the font is doing something clever here to save space: there is an "implied" on-curve point located half-way between the off-curves points. Software handling these curves needs to insert the implied on-curve point.
在线上点之间竟然连续出现了两个线外点！这难道不是在TrueType #tr[outline]中使用了三次贝塞尔曲线吗？不不不，这只是字体文件为了节省空间而进行了某些聪明的省略罢了。这种写法表示在两个线外点的正中间有一个隐含的线上点。软件在处理这些曲线时，还是需要把这个被省略的点给加回去的。

#figure(
  placement: none,
  caption: [两个线外点间隐含的线上点]
)[#include "implied.typ"]


// What about the `loca` table? The `glyf` table contains all contours for all the glyphs, one after another as a big long binary lump. When you're trying to find a glyph, you look up its glyph index in the `loca` table, and it'll tell you which byte of the `glyf` table you need to jump to.
那 `loca` 表又是干什么用的呢？因为 `glyf` 表是直接以二进制形式连续储存所有#tr[glyph]的#tr[contour]的，我们需要从`loca`表中找到这个#tr[glyph]在`glyf`数据中的位置，才能知道从哪开始读取#tr[outline]信息并绘制它。
