#import "/template/template.typ": web-page-template
#import "/template/components.typ": note
#import "/template/lang.typ": khmer

#import "/lib/glossary.typ": tr

#show: web-page-template

== OpenType可变字体 <heading:opentype.font-variation>

// Another, more flexible way of putting multiple family members in the same file is provided by OpenType Font Variations. Announced at the ATypI conference in 2016 as part of the OpenType 1.8 specification, font variations fulfill the dream of a font whereby the end user can dynamically make the letterforms heavier or lighter, condensed or expanded, or whatever other axes of variation are provided by the font designer; in other words, not only can you choose between a regular and a bold, but the user may be able to choose any point in between - semibolds, hemi-semibolds and everything else suddenly become available. (Whether or not you believe that users really *ought* to have access to infinite variations of a font is entirely another matter.)
OpenType可变字体是另一种能更灵活地将多个字体家族成员放入同一个文件中的方式。它是在 2016 年的 AtypI 会议上发布的 OpenType 1.8 版本中的新增功能。它完成了字体行业的一个久远的梦想：让用户能够通过调整设计师提供的数轴上的取值，来动态生成所需的不同字重或宽窄的字体变体。换句话说，用户们不再仅仅只能从选择常规体和粗体，而是可以根据需要，自行生成符合需求的粗细程度。（至于用户是否能用好这种拥有无限变化的字体就是另一回事了。）

// As with everything OpenType, variable fonts are achieved through additional tables; and as with everything OpenType, legacy compromises means that things are achieved in different ways depending on whether you're using PostScript or TrueType outlines. TrueType outlines are the easiest to understand, so we'll start with these.
和其他OpenType特性一样，可变字体也是通过新增数据表的方式实现的。同理，OpenType的缺点这次也没有缺席，它还是需要兼顾PostScript和TrueType两种历史实现。其中TrueType#tr[outline]比较容易理解，我们就从它开始。

// But first, we have to understand interpolation and deltas. From a designer's perspective, what you do when you design a variable font doesn't really change much from an ordinary multiple master font. First, you decide on your design axes and the points on those axes that you will design; the most common axis is the weight axis - perhaps you will go from regular to bold, or you may design thin, regular and black weights and interpolate between those points. Or you may choose to work on the width axis, designing condensed, regular and extended masters. Then you draw your glyphs, and five years later you have a font.
首先，我们来介绍插值和变化量。从设计师的视角看，设计可变字体和之前的多母版字体之间并没有太大区别。首先你需要决定字体的哪些属性可以变化，以及你要对这些属性中的哪些值进行实际设计。最常见的可变轴是字重，你可以设计常规体和粗体，或细体、常规体和浓体，然后使用插值完成中间的部分。你也可以通过设计窄、常规和宽三个母版来让字宽可变。接下来就开始画#tr[glyph]吧，五年之后你就能得到一个字体了。

// > Italic isn't a design axis; it's usually handled separately, for two reasons: first, you don't really want people to be producing semi-italic fonts, and second, often the italic shapes of characters are quite different to the upright shapes, so it's not possible or sensible to interpolate between them. I mean, you *could*. But you probably shouldn't.
#note[
  意大利体不应作为可变轴，它通常由手工单独处理。这有两个原因，一是你不太会希望人们使用“半意大利体”之类的中间形式。二是意大利体需要对#tr[character]的形状进行某些变化，导致在常规体和意大利体之间无法进行插值，或者至少插值的效果并不太好。所以虽然技术上允许，但最好别这么做。
]

#figure(
  placement: none,
)[#include "designspace.typ"]

// Once you have designed your masters, you can then interpolate instances in between those extremes; for instance, if we wanted to create a semibold instance of this font, (Noto Sans Khmer) we would take the regular and the bold masters and, for each point on the glyph, compute a position that lays some proportion of the way between the corresponding points on the two masters.
当母版设计好后，下一步就是从这些极值点插值出中间的实例。比如为了创建上图字体（Noto Sans Khmer）的半粗体，就需要拿出常规体和粗体的两个母版。#tr[glyph]中的每一个点在两个母版上的位置会有不同，按照一定的比例分配后就能计算出其在半粗体时的位置了。

// How does this work? In the diagram below, the green (regular) and red (bold) outlines represent our two different input masters. To form the semibold, we "take the average" of each point between the green and red, ending up with the yellow points, which is the outline of our semibold instance:
那么这个过程究竟是怎样的呢？@figure:interpolation 中绿色是常规体母版的#tr[outline]，红色则是粗体的。为了构建半粗体，我们取每一个点在红色和绿色线条上位置的平均值，得到黄色的点。这些点连起来就是半粗体的#tr[outline]了。

#figure(
  caption: [由常规体和粗体插值出半粗体的过程],
)[#image("interpolation.svg", width: 90%)] <figure:interpolation>

// But there's another way to think about masters and interpolation. When *designing* your font, you design with two distinct masters for each axis. Each master represents an "end" of the axis - one master for the thickest and one for the thinnest; one master for the widest, and one for the narrowest, and so on. Nothing changes here. But when the font is assembled as an OpenType variation font, it only has one set of outlines as normal. The outlines in the `CFF` or `glyf` tables represent the Ur-Outline, the One True Master, essentially a "normal" or "average" form of each glyph. The *axes* (such as width or weight) are represented in terms of how we should vary the shape of the One True Master. For each point, we have a set of *deltas*. For example, the bold axis will be given as a set of vector coordinates for each point on each glyph, describing how to get from the One True Master to the bold form:
这个过程还可以用@figure:deltas-1 描述的另一种方式来思考。当设计字体时，你还是为每个变化轴的两个极值分别设计母版。比如在字重轴上就设计一个最细的和一个最粗的，在字宽轴上就设计一个最窄的和一个最宽的等等，这些步骤还是不变。当在将设计编译成OpenType可变字体时，文件中只存在唯一的一个#tr[outline]，储存在`CFF`或者`glyf`表中。这个唯一#tr[outline]是你设计的所有母版中#tr[glyph]#tr[outline]的均值。而这些可变轴（字重或字宽）实际上存储为对这个唯一#tr[outline]的变化。对于#tr[outline]中的每个点，我们都会储存一些“变化量”。比如，字重轴会存储为#tr[glyph]中每个点上的一个向量，用于描述如何将唯一母版变化到粗体形式。

#figure(
  caption: [每个点在粗体轴上的变化量],
  placement: none,
  include "deltas-1.typ",
) <figure:deltas-1>

// The reason for using a single master and multiple deltas is that you can then *blend* together motion along multiple design axes. Instead of having separate regular, condensed, bold, and bold condensed masters, the font is represented internally as having a single master and two sets of deltas, one which makes the font more bold and one which makes it more condensed:
使用单个母版加多个变化向量的方式有一个好处：多个可变轴可以叠加应用。这样你就不用创建常规体、窄体、粗体、粗窄体四个母版了，而是只需要单个常规母版，加上分别使字体更粗和字体更窄的两套变化向量即可。

#figure(
  caption: [两个变化量的叠加应用],
  placement: none,
  include "deltas-2.typ"
) <figure:deltas-2>

// Creating a semibold condensed instance of this font requires you to do some vector mathematics. If we say that "semibold" means 50% of full bold, and "condensed" is 100% of the way down the condensed axis, then for each point, we need to compute its "semibold condensed" vector. We multiply the red *weight* vector for that point by 50%, then take the product of that vector with 100% of the yellow *condensed* vector. Then we add the resulting vector to the original position of the point on the green master.
用这种方式创建半粗窄体则需要进行一些向量计算。假设你把半粗定义50%程度的粗，窄体定义为字宽轴上的100%位置。那么对于每一个点，我们都将红色的粗体向量乘以50%，再加上100%的黄色窄体向量，这样就计算出了对应的“半粗窄体”向量。将绿色模板上的原始点按照计算出的向量方向移动即可得到半粗窄体的#tr[outline]点。

#note[
  // That was a simplification, as we'll see a bit later.
  这是简化版的描述，后续会介绍细节。
]

// So let's see how this is actually looks inside the file. We've been using Noto Sans Khmer, so let's break that open in `ttx`:
让我们看看使用了这种技术的字体文件中的实际内容。用 `ttx` 工具打开 Noto Sans Khmer 字体：

```bash
$ ttx NotoSansKhmer-GX.ttf
Dumping "NotoSansKhmer-GX.ttf" to "NotoSansKhmer-GX.ttx"...
Dumping 'GlyphOrder' table...
Dumping 'head' table...
Dumping 'hhea' table...
Dumping 'maxp' table...
Dumping 'OS/2' table...
Dumping 'hmtx' table...
Dumping 'cmap' table...
Dumping 'loca' table...
Dumping 'glyf' table...
Dumping 'name' table...
Dumping 'post' table...
Dumping 'GDEF' table...
Dumping 'GPOS' table...
Dumping 'GSUB' table...
Dumping 'fvar' table...
Dumping 'gvar' table...
```

// We've got a couple more tables this time: `fvar` and `gvar`. The `fvar` table describes the design axes, their range, and where the One True Master is situated on that axis:
这次的结果中出现了`fvar`和`gvar`这两个前面没见过的数据表。`fvar` 表用于描述设计师定义的可变轴和每个轴的变化范围，以及初始的唯一母版在可变轴上的位置。

```xml
<fvar>
  <Axis>
    <AxisTag>wdth</AxisTag>
    <MinValue>70.0</MinValue>
    <DefaultValue>100.0</DefaultValue>
    <MaxValue>100.0</MaxValue>
    <AxisNameID>256</AxisNameID>
  </Axis>
  <Axis>
    <AxisTag>wght</AxisTag>
    <MinValue>26.0</MinValue>
    <DefaultValue>90.0</DefaultValue>
    <MaxValue>190.0</MaxValue>
    <AxisNameID>257</AxisNameID>
  </Axis>
```

// This font has two design axes, width and weight. (There's also a third axis in the font, a custom axis which doesn't seem to be used. So I've removed it for clarity.)
这个字体有字宽和字重两个可变轴。（实际上还有第三个自定义的可变轴，但似乎并没有实际用到，所以这里为了描述更清晰而删掉了它。）

// The names of the axes are localised in the `name` table so that they can be displayed to users in the appropriate language. The width axis runs from compressed=70 to regular=100, and the One True Master represents the regular width; the weight axis runs from 26 to 190, with the One True Master located at 90.
可变轴的名称需要储存在`name`表中并本地化为不同的语言展示给用户。字宽轴的范围从最窄的70到常规的100，初始母版使用常规字宽。字重轴则从26到190，初始母版的值为90。

#note[
  // > There are two types of axes in the Font Variations specification: registered axes and custom axes. The idea behind a registered axis is that everyone should be able to use the axis in the same way. Weight and width are registered axes, because they're the kind of thing that a lot of fonts are going to use. So the specification also defines some semantics for the values on these axes, so that applications can produce an interface and user experience that is common across fonts. The width axis is defined as a percentage value of compression, with "100" representing the default font neither compressed nor expanded. The weight axis is supposed to work like CSS weights, with a standard regular master having a value of 400. (Noto is being naughty here.)
  在可变字体的规范中可变轴有预定义和自定义两种。因为大量字体都会使用规范中预定义的可变轴，所以这些轴的使用方式要保持一致。为此，规范为这些轴上的数值也规定了具体语义。这样应用程序就可以设计一个对多个字体都可用的统一界面。比如，字宽轴定义为伸缩的百分比，数值100就表示默认的既没有被压缩也没有被拉伸的字体。字重轴则被定义成以类似CSS中的值，标准常规母版使用400。（Noto 字体在这有些调皮了）

  // > For custom axes, where you start and end your values and where you put your default is up to you; the numbers on custom axes are dimensionless quantities that are only interpreted in relation to each other.
  自定义轴的范围和初始值就完全取决于设计师自己了。这些数值是无单位的，只能按照数字大小来进行相对比较。

  // In both cases, when we come to looking at the deltas, these values get normalized: -1 represents the bottom end of the axis, 1 represents the top end, and 0 represents the *default*. (not the middle!)
  当需要计算变化量时，这两种轴都会进行归一化。具体来说是将最小值视为 -1，最大值视为 1，默认值（而不是中位值！）被视作 0。
]

// While the purpose of Variable Fonts is to allow the user infinite flexibility, we still want the user to have access to particular instances of the font that the designer thinks work particularly well or define a good typographic hierarchy. So the `fvar` table also includes definitions for named instances, located at specific points on the design space:
虽然可变字体技术的目的是为了让用户拥有无限的调整灵活性，但我们希望用户依然可以和之前一样，从设计师精心调整过的几个特定实例间进行挑选并直接使用。所以`fvar`表中还有一部分信息是命名实例，它们可以想象成整个设计空间中某些特定的点：

```xml
<!-- Thin -->
<NamedInstance subfamilyNameID="259">
  <coord axis="wdth" value="100.0"/>
  <coord axis="wght" value="26.0"/>
</NamedInstance>
<!-- ... -->
<!-- Condensed ExtraLight -->
<NamedInstance subfamilyNameID="269">
  <coord axis="wdth" value="79.0"/>
  <coord axis="wght" value="39.0"/>
</NamedInstance>
```

// Noto Sans Khmer Thin is all the way down the bottom of the weight axis, and Condensed ExtraLight is part of the way down the weight axis and almost all the way down the bottom of the width axis.
Noto Sans Khmer 的 Thin 字体实例使用了字重轴的最小值，而 Condensed ExtraLight 则使用了接近最小的字重和最窄的字宽。

// Now we come to the `gvar` table, which in a TrueType outline font, stores the deltas themselves. We've been playing with KHMER LETTER LO (ល), which goes by the glyph name "uni179B". (I'm sure you can work out why.)
再来看看TrueType#tr[outline]表示法使用可变字体技术时会出现的`gvar`表，它用于存储变化量。就用我们之前举例过的高棉语字母 Lo（#khmer[ល]）为例，它在字体中的#tr[glyph]名是`uni179B0`（我相信你知道为什么叫这个），对应的 `gvar` 表内容如下：

```xml
<gvar>
  <version value="1"/>
  <reserved value="0"/>
  <!-- ... -->
  <glyphVariations glyph="uni179B">
    <tuple>
      <coord axis="wdth" value="-1.0"/>
      <delta pt="0" x="-141" y="-9"/>
      <delta pt="1" x="-141" y="0"/>
      <!-- ... -->
    </tuple>
    <tuple>
      <coord axis="wght" value="-1.0"/>
      <delta pt="0" x="-53" y="7"/>
      <delta pt="1" x="-53" y="0"/>
      <!-- ... -->
    </tuple>
```

// Here are the full deltas for the bottom end of the width axis (completely condensed) and the bottom end of the weight axis (thin). To create a thin version of the letter LO, start with the regular version, and move the first point left 53 units and up 7 units. To create a condensed version, move the first point left 9 units.
这里展示了字宽轴的最小值（最窄时）和字重轴的最小值（最细时）对应的变化量。如果要创建一个细体版本的 Lo 字母，以常规体母版为基础，需要将#tr[outline]中的第一个点向左移动53个单位，向上移动7个单位。如果想要紧缩体版本，则是向左141单位，向下9个单位。

// If you read on to the next few tuples, you will discover that our initial explanation of deltas was a little bit of a simplification, in a number of ways. First, rather than a single delta for weight, you may have find that a font gets thinner or bolder at different rates. So the delta above tells you how to make the font thin, but making the font bold is not just a matter of inverting the delta. One delta is used to travel from the regular into the light direction, but there's a separate delta used for travelling from the default in the boldness direction:
如果再往下看几个具体变化量的数据的话，你就会发现我们之前对它的解释在各个方面都有些简化了。首先，整个字重轴并不是只有一个变化量，这一点你可能能从字体的粗细变化并不是匀速这点上看出来。上面的这一个变化量只用于将字体变细，将字体变粗时并不仅仅是将这个向量反向这么简单，而是由另一个变化量单独负责：

```xml
    <tuple>
      <coord axis="wght" value="1.0"/>
      <delta pt="0" x="74" y="-5"/>
      <delta pt="1" x="74" y="0"/>
      <!-- ... -->
    </tuple>
```

// As well as that, creating a bold condensed font is not simply a matter of blindly multiplying a bold weight delta with a condensed width delta; you may have design-specific adjustments which need to happen when your font is both bold and condensed. This can be represented as another vector: "go this way for both bold and condensed":
另外，创建粗窄体并不只是简单的叠加应用粗体和窄体的变化量就能完成，你还需要专门设计一个在变粗和变窄同时发生时生效的变化量。这个变化量也是一个向量，表示“同时变粗变窄时要向这个方向移动”。

```xml
    <tuple>
      <coord axis="wdth" value="-1.0"/>
      <coord axis="wght" value="1.0"/>
      <delta pt="0" x="-17" y="13"/>
      <delta pt="1" x="-17" y="0"/>
      <!-- ... -->
    </tuple>
  </glyphVariations>
```

// In other words, you have a variety of deltas, and each delta is associated with a position in the design space. When the instances are generated, each set of deltas is given a weight representing how useful it is in getting to the point in design space you're aiming at. So if you want a semibold instance, deltas which make the font lighter are no use at all, so have their weight set to zero. If you want a semibold condensed, deltas which make the font bold, condensed and both bold and condensed at the same time will all be taken into account in varying proportions according to their usefulness. The vectors multiplied by their weights, and applied to the default point, and it all works out in the end.
换言之，你可以有很多个变化量，它们都位于设计空间的某个位置上。当需要生成某个字体实例时，会根据变化量所在位置对于将常规点往实例点移动产生了多少贡献来为它们赋予权重。比如你想生成一个半粗体，那使字体变窄的变化量就没有任何贡献，它的权重就是0。当生成半粗窄体时，粗体、窄体以及粗窄体三个方向的变化量都会用到，并会根据它们的作用按比例分配权重。这些向量乘以权重后再叠加应用到常规母版中的#tr[outline]点上，产生的才是最终的字体实例。

#note[
  // > Another simplification I've made is that your glyphs may change shape completely as they pass particular thresholds: when a dollar sign ($) goes from regular to bold, it sometimes loses the line through the middle of the curve, opting for just protrusions at the top and bottom. Variable fonts lets you flip over to another glyph after a particular threshold on the axis, but I'm not going to go into that.
  此处我还做了一个简化，就是当跨过某些特定的阈值时，#tr[glyph]#tr[outline]可以发生整体性的变化。比如当美元符号（\$）逐渐变粗时，这条穿过S的竖线的中间部分可能会消失，只能看见顶部和底部。可变字体允许在跨越某个变化轴的阈值时对#tr[glyph]进行替换，这里我们就不介绍得这么详细了。

  // > If you actually need to implement variable fonts, print out the [font variations overview](https://www.microsoft.com/typography/otspec/otvaroverview.htm) and sit down with it over a cup of coffee. It's not too hard to understand.
  如果你真的需要实现一个可变字体，请将《OpenType可变字体概述》#[@Microsoft.OpenTypeFont]打印出来，泡杯咖啡，然后坐下慢慢阅读吧。这项技术其实并不难理解。
]

// We've looked at TrueType outlines; what about PostScript outlines? Well, the old CFF font format didn't have support for deltas and variations, so a new format was needed. CFF2 introduces new operators `blend` and `vsindex` to handle deltas. (There are a number of other changes between CFF and CFF2, but we are not going to go into them here.)
我们已经了解完TrueType#tr[outline]下的可变字体了，那使用PostScript#tr[outline]时又如何呢？嗯，老的CFF字体格式并不支持可变轴和变化量，所以我们需要一个新格式。CFF2 引入了两个新的操作 `blend` 和 `vsindex` 来支持可变字体。（CFF2还有很多变化，但此处不过多介绍。）

// The `blend` operator tells the renderer to apply a variation across multiple axes. The following example is taken from the [CFF2 CharString Format specification](https://docs.microsoft.com/en-us/typography/opentype/spec/cff2charstr). Imagine you have an outline which starts at co-ordinate (100,200) in the One True Master, but which starts at the following co-ordinates in the other masters:
`blend` 操作让渲染器在多个轴上进行变化。我们举一个CFF2字符串格式规范#[@Microsoft.CFF2CharString]中的例子，假设在初始母版有一个以 `(100, 200)` 为起点的#tr[outline]，且其他母版下这个起点坐标如下：

/*
|---|
| Master | Co-ordinate | Delta |
|-------|----:|----:|
| Regular | (100,200) | |
| Light | (100,150) | (0,-50) |
| Bold | (100,300) | (0, +100) |
| Condensed | (50,100) | (-50,-100) |
*/
#align(center, table(
  columns: 3,
  align: (x, y) => if x * y == 0 { center } else { left },
  table.header(
    [母版], [坐标], [变化量],
  ),
  [常规], [`(100, 200)`], [],
  [细], [`(100, 150)`], [`(  0, -50)`],
  [粗], [`(100, 300)`], [`(  0, +100)`],
  [窄], [`( 50, 100)`], [`(-50, -100)`],
))

// Let's also imagine we want to find the bold condensed instance of this font.
接下来我们来看看如何生成粗窄体的实例。

// In a non-variable font, we would start the CFF program with:
在不可变的字体中，这个起点的CFF程序将会是：

```
100 200 rmoveto
```

// But we want instead want to *compute* the appropriate co-ordinate to move to, based on the deltas. So the program is written using the `blend` operator like so:
但现在我们需要根据变化量来计算这个起点的位置，这里就要用到 `blend` 操作了。它的语法如下：

```
(初始母版值) (X 方向变化量) (Y 方向变化量) (操作数数量) blend (原命令)
```

// In this case:
在我们这个具体例子中就是：

```
(100 200) (0 0 -50) (-50 100 -100) 2 blend rmoveto
```

// (I've added parentheses so you can see how the arguments are grouped, but in the font program it would just appear as `100 200 0 0 -50 ...`)
（为了便于理解这些参数是如何分组的，这里我额外加上了括号，但在实际的字体程序中只会这么写： `100 200 0 0 -50 ...`）

// When this font program is executed by the PostScript implementation, the `blend` command runs first, before the `rmoveto` command. `blend` applies the bold (second) and condensed (third) deltas to the One True Master outline, does the computation leaving behind two operands to the next command, and then disappears off the stack. What we then have left to execute is:
当字体程序被PostScript解释器运行时，会先执行`blend`命令再执行`rmoveto`命令。`blend`会将粗体（变化量中的第二个数）和窄体（第三个数）的变化量应用到初始模板的#tr[outline]点坐标上，并给出两个数值作为结果，之后自身从执行栈中消失。那么剩下要执行的就变成了：

```
(100+0-50) (200+100-100) rmoveto
```

// i.e.
也即

```
50 200 rmoveto
```

// which puts us in the right place for the bold condensed instance.
这样就将起点移动到了粗窄体的对应位置。
