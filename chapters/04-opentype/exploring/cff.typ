#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ### The `CFF` table
=== `CFF` 表

// Finally, let's look at the table which is of least interest to typography and layout software, although font designers seem to rather obsess over it: the actual glyph outlines themselves. First, we'll look at the `CFF` table which, as mentioned above, represents OpenType fonts with PostScript outlines.
最后我们来看看排版软件最不关心，但字体设计师痴迷其中的东西：#tr[glyph]#tr[outline]。我们先以用PostScript方式表达#tr[outline]时使用的`CFF`表为例。

// What's interesting about the `CFF` table is that its representation is "alien" to OpenType. CFF is a data format borrowed wholesale from elsewhere - Adobe invented the Compact Font Format in 1996 as a "compact" (binary) way to represent its PostScript Type 1 fonts, as opposed to the longform way of representing font data in the PostScript language. It was used since PDF version 1.2 to represent font subsets within PDF documents, and later introduced into OpenType as the representation for PS outlines.
`CFF`表的一个特点是，对于OpenType来说它就像一种外来生物。确实，CFF 是一种从其他技术中借鉴而来的数据格式。1996 年，为了优化长期以来低效地用PostScript语言直接表示PostScript Type 1字体的方法，Adobe发明了紧凑字体格式（Compat Font Format）。它也用于在PDF 1.2之前的文档中储存字体子集。后来OpenType标准将其定为储存PostScript#tr[outline]的格式。

// In other words, CFF is an *independent* font format. You actually have another whole font file inside your font file. This CFF font file begins with its own "public" header before it launches into the outline definitions, giving some general information about the font:
换句话说，CFF本身就是一个*独立的*字体格式。在这个字体文件中其实包含了另一个完整的字体文件。CFF 字体文件在#tr[outline]之前有它自己的公共头部信息，用于提供关于字体的基础信息：

```xml
<CFF>
  <CFFFont name="TTXTest-Regular">
    <version value="001.000"/>
    <Notice value="copyright missing"/>
    <FullName value="TTX Test Regular"/>
    <Weight value="Regular"/>
    <isFixedPitch value="0"/>
    <ItalicAngle value="0"/>
    <UnderlineThickness value="50"/>
    <PaintType value="0"/>
    <CharstringType value="2"/>
    <FontMatrix value="0.001 0 0 0.001 0 0"/>
    <FontBBox value="3 -200 578 800"/>
    <StrokeWidth value="0"/>
    <!-- 字符集被单独储存在 GlyphOrder 元素中 -->
    <Encoding name="StandardEncoding"/>
```

// From an OpenType perspective, much of this is information we already know, but which has to be filled in to make this table conform to the CFF format. Font production software will generally copy this information from other parts of the font: the copyright notice and font name find their native OpenType home in the `name` table, the weight value can be found in the `OS/2` table, the bounding box information comes from the `head` table, and so on.
从OpenType标准的视角来说，这个头部中的大多数信息都在别处已经提供。但为了满足CFF格式标准，必须在这里也填写一遍。字体制作软件通常会从其他表中自动复制所需的信息进行填入。比如版权信息和字体名会从`name`表中获取，字重值则来自`OS/2`表，#tr[bounding box]相关信息可以从`head`表中得知。

// It's not clear if any software cares too much about the values in this header. As an experiment, I tried modifying the paint type and stroke width to attempt to create an outline font (recompiling the XML representation back into OpenType, again using `ttx`), and embedding this in a PDF document, but nothing changed.
我不确定是否有软件真的会使用这个公共头部里的信息。我尝试过修改其中的`PaintType`和`StrokeWidth`字段，然后将XML表示重新转换回字体文件并嵌入PDF文件里，但结果什么都没变。

// After the public header comes a private header, which is very much used:
公共头部之后是私有头部，这部分就很有用了：

```xml
<Private>
  <BlueScale value="0.037"/>
  <BlueShift value="7"/>
  <BlueFuzz value="0"/>
  <ForceBold value="0"/>
  <LanguageGroup value="0"/>
  <ExpansionFactor value="0.06"/>
  <initialRandomSeed value="0"/>
  <defaultWidthX value="0"/>
  <nominalWidthX value="0"/>
</Private>
```

// These mainly have to do with hinting, which we will deal with in the appropriate chapter.
这些字段大多和#tr[hinting]有关，我们会在专门的章节中再进行详细介绍。

// Finally we get to the good stuff:
再往后就是我们现在感兴趣的部分了：

```xml
<CharStrings>
  <!-- ... -->
  <CharString name="A">
    580 213 72 342 73 hstem
    3 574 vstem
    240 700 rmoveto
    -237 -700 rlineto
    91 hlineto
    67 213 rlineto
    255 hlineto
    66 -213 rlineto
    95 hlineto
    -237 700 rlineto

    -157 -415 rmoveto
    33 107 24 79 24 75 22 81 rlinecurve
    4 hlineto
    22 -81 23 -76 25 -78 34 -107 rcurveline
    endchar
```

// The definition of the characters themselves, in the PostScript language, begins with some hinting information: the total width is 580, and there's a horizontal stem that starts at 213 and goes for 72 units to 285; (the crossbar of the A) then another which goes from 285+342=627 to 627+73=700 to represent the apex of the A. The vertical stem goes from the left side bearing (3 units) all the way across the glyph.
这些就是用PostScript语言写成的#tr[glyph]定义了。定义中最开始的部分也是#tr[hinting]。其含义为：整个#tr[glyph]宽度为580；有两个水平的#tr[stem]，第一个#tr[stem]（A字中间的横梁）从坐标213处开始，高72个单位，持续到`213+72=285`；第二个#tr[stem]（A的顶部尖端部分）则从坐标`285+342=627`处开始，持续到`627+73=700`。竖向的#tr[stem]则从左#tr[sidebearing]（横坐标为3）处开始，一直横跨整个字符（这里描述的是竖向#tr[stem]的横轴长度，正如之前横向#tr[stem]是描述其纵轴高度）。

// Then there are a series of moving and drawing operations: we `rmoveto` the left side of the apex, and draw the left outmost stroke of the A, a diagonal `rlineto` the position (3,0). (PostScript uses relative coordinates: we move left 237 units and down 700 units, so we end up at (3,0).) Now we're at the bottom left corner of the A, about to draw the horizontal line at the bottom of the left leg. PostScript has a special drawing instruction, `hlineto`, for horizontal lines, which omits the vertical coordinate, which means that `91 hlineto` takes us from (3,0) to (94,0).
后续则是一些移动和绘制指令。首先 `rmoveto` 将画笔移动到顶部尖端的左侧，然后 `rlineto` 命令绘制出A字的最左边的一笔。这里 PostScript 语言使用的是相对坐标，因为最开始将画笔移动到了 `(240, 700)`，所以往左 237，往下 700 单位后就到了最左下角的 `(3, 0)`。现在要接着画左脚的底部横线，PostScript 对于水平线段有一个专用的指令 `hlineto`，使用它就无需填写纵坐标参数。所以这里代码 `91 hlineto` 就画出了从 `(3, 0)` 到 `(94, 0)` 的一条横线。

// We go around the outline until `-237 700` takes us back to the top *right* of the apex. (I've added a blank line here for clarity, although it would not be in the actual TTX outline.) This is almost the end of the outer outline. We haven't actually drawn the line between the top right of the apex and the top left where we started, but it turns out we don't need to. When we pick up the pen and move it somewhere else, which will be our next instruction, the outline gets closed for us.
在经过了一系列绘制后，通过 `-237 700` 的一次移动，最终我们回到了顶部尖端的右侧（为了能看的更清楚，我在这条语句之后加了一个空行，要注意代码中实际上是没有的），这基本就是整个最外侧#tr[outline]的样子了。我们不需要手动写出从尖端右侧到作为绘制起点的尖端左侧的横向线条，因为下一条语句是 `rmoveto`，将画笔拿起并移动到其他位置的命令会自动将当前的#tr[outline]封闭。

// We've just been dealing with straight lines so far, but moving us left 157 units and down 415 units places us in the middle of the counter of the A, where we start to see some curves - there are subtle flexes within the diagonals of the aperture. (You font designers are *clever* people.) `rlinecurve` specifies the relative positions of the start, first control point, second control point and end point of our cubic Bézier curve. We move across to the right a bit, have a curve that comes down, and that concludes our letter A.
至今为止我们都是在画直线，不过在将画笔移动到A的#tr[counter]部分之后，因为开口的内部角落处会有细微的弯曲，所以我们得开始画曲线了。`rlinecurve` 通过起始点、第一控制点、第二控制点、终结点之间的相对位置来绘制一条贝塞尔曲线。然后向右画一条小横线，再画一条向下的曲线，这样我们的字母A就完成了。
