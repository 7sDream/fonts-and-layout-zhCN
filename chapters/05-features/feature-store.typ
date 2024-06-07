#import "/template/template.typ": web-page-template
#import "/template/components.typ": note, cross-ref

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## How features are stored
== 特性如何储存

#note[
  // > You probably want to skip this section the first time you read this book. Come to think of it, you may want to skip it on subsequent reads, too.
  如果这是你第一次阅读本书，可能会想暂时跳过本段内容。但还是看看吧，毕竟不管是第几次都是会想跳过的。
]

// We'll start our investigation of features once again by experiment, and from the simplest possible source. As we mentioned, the canonical example of a `GPOS` feature is kerning. (The `kern` feature - again one which is generally turned on by default by the font.)
我们还是通过实验来介绍特性的储存，而且这次只使用最简单的特性代码。正如前文所说，最经典的`GPOS`特性的例子就是#tr[kern]。而且通常来说，`kern`这个特性都是被字体默认开启的。

// > As with all things OpenType, there are two ways to do it. There's also a `kern` *table*, but that's a holdover from the older TrueType format. If you're using CFF PostScript outlines, you need to use the `GPOS` table for kerning as we describe here - and of course, using `GPOS` lets you do far more interesting things than the old `kern` table did. Still, you may still come across fonts with TrueType outlines and an old-style `kern` table.
#note[
  OpenType的老生常谈又来了，还是有两种方式来完成#tr[kern]功能。除了我们一直介绍的这种之外还有一张就叫做`kern`的数据表，这是老版本的TrueType格式的遗留物。如果你使用的是PostScript的CFF格式的#tr[outline]描述，就只能使用`GPOS`表来实现#tr[kern]了。当然，使用`GPOS`表可以让你实现老`kern`表无法完成的更多更有趣的功能。但在生活中你还是可能会见到一些使用TrueType格式和老式`kern`表的字体。
]

// We're going to take our test font from the previous chapter. Right now it has no `GPOS` table, and the `GSUB` table contains no features, lookups or rules; just a version number:
我们使用上一章的测试字体，现在它里面还没有`GPOS`表，而且`GSUB`表里也没有任何特性、#tr[lookup]和规则存在。里面只有一个版本号：

```xml
<GSUB>
  <Version value="0x00010000"/>
</GSUB>
```

// Now, within the Glyphs editor we will add negative 50 points of kerning between the characters A and B:
现在打开 Glyphs 编辑器，在AB#tr[character]间添加一个 -50 单位的#tr[kern]。

#figure()[#image("kern.png", width: 35%)]

// We'll now dump out the font again with `ttx`, but this time just the `GPOS` table:
然后重新用 `ttx` 处理字体文件，但这次我们只导出 `GPOS` 表：

```bash
$ ttx -t GPOS TTXTest-Regular.otf
Dumping "TTXTest-Regular.otf" to "TTXTest-Regular.ttx"...
Dumping 'GPOS' table...
```

得到的结果如下：

```xml
<GPOS>
  <Version value="0x00010000"/>
  <ScriptList>
    <!-- ScriptCount=1 -->
    <ScriptRecord index="0">
      <ScriptTag value="DFLT"/>
      <Script>
        <DefaultLangSys>
          <ReqFeatureIndex value="65535"/>
          <!-- FeatureCount=1 -->
          <FeatureIndex index="0" value="0"/>
        </DefaultLangSys>
        <!-- LangSysCount=0 -->
      </Script>
    </ScriptRecord>
  </ScriptList>
  <FeatureList>
    <!-- FeatureCount=1 -->
    <FeatureRecord index="0">
      <FeatureTag value="kern"/>
      <Feature>
        <!-- LookupCount=1 -->
        <LookupListIndex index="0" value="0"/>
      </Feature>
    </FeatureRecord>
  </FeatureList>
  <LookupList>
    <!-- LookupCount=1 -->
    <Lookup index="0">
      <!-- LookupType=2 -->
      <LookupFlag value="8"/>
      <!-- SubTableCount=1 -->
      <PairPos index="0" Format="1">
        <Coverage Format="1">
          <Glyph value="A"/>
        </Coverage>
        <ValueFormat1 value="4"/>
        <ValueFormat2 value="0"/>
        <!-- PairSetCount=1 -->
        <PairSet index="0">
          <!-- PairValueCount=1 -->
          <PairValueRecord index="0">
            <SecondGlyph value="B"/>
            <Value1 XAdvance="-50"/>
          </PairValueRecord>
        </PairSet>
      </PairPos>
    </Lookup>
  </LookupList>
</GPOS>
```

// Let's face it: this is disgusting. The hierarchical nature of rules, lookups, features, scripts and languages mean that reading the raw contents of these tables is incredibly difficult. (Believe it or not, TTX has actually *simplified* the real representation somewhat for us.) We'll break it down and make sense of it all later in the chapter.
说实话吧，这太糟糕了。这种语言#tr[script]、特性、#tr[lookup]、规则之间奇怪的层级嵌套关系根本无法阅读。（你可能不信，这还是`ttx`工具将真实的储存结构*简化*了之后的样子。）现在我们试图将它逐步分解，并尝试解释每一部分的意义。

// The OpenType font format is designed above all for efficiency. Putting a bunch of glyphs next to each other on a screen is not meant to be a compute-intensive process (and it *is* something that happens rather a lot when using a computer); even though, as we've seen, OpenType fonts can do all kinds of complicated magic, the user isn't going to be very amused if *using a font* is the thing that's slowing their computer down. This has to be quick.
OpenType字体格式的首要设计原则是高效。将一大堆#tr[glyph]一个接一个地显示在屏幕上绝不能是一个非常吃性能的过程，因为这是计算机上及其常见的使用场景。虽然OpenType可以完成我们介绍过的那么多复杂花样，但如果使用字体会拖慢电脑速度的话，用户是不会感到高兴的。这个过程就是得很快才行。

// As well as speed and ease of access, the OpenType font format is designed to be efficient in terms of size on disk. Repetition of information is avoided (well, all right, except for when it comes to vertical metrics...) in favour of sharing records between different users. Multiple different formats for storing information are provided, so that font editors can choose the most size-efficient method.
OpenType字体格式的设计不仅着眼于速度和便于取用，还希望高效利用磁盘空间。它避免信息重复（啊，好吧，竖排的那些#tr[metrics]值除外……），以便在不同的用户间共享记录。/*这句啥意思？*/ 它提供了多种信息存储方式，这样字体编辑器可以选择空间利用率最高的方法。

// But because of this focus on efficiency, and because of the sheer amount of different things that a font needs to be able to do, the layout of the font on the disk is... somewhat overengineered.
但就是因为如此关注效率，再加上字体需要能完成各种各样的功能，字体文件在磁盘上的格式有些……过度设计了。

// Here's an example of what actually goes on inside a `GSUB` table. I've created a simple font with three features. Two of them refer to localisation into Urdu and Farsi, but we're going to ignore them for now. We're only going to focus on the `liga` feature for the Latin script, which, in this font, does two things: substitutes `/f/i` for `/fi`, and `/f/f/i` for `/f_f_i`.
我用一个`GSUB`的例子来介绍字体内部到底是什么样的。为此，我创建了一个有三个特性的简单字体。其中两个特性是关于乌尔都语和波斯语本地化的，这两个我们先忽略，只关注拉丁文的`liga`特性。这个特性会完成两件事：将`f i`#tr[substitution]为`fi`，`f f i` #tr[substitution]为 `f_f_i`。

// In Adobe feature language, that looks like:
代码如下：

```fea
languagesystem DFLT dflt;
languagesystem arab URD;
languagesystem arab FAR;

feature locl {
  script arab;
  language URD;
  # ...
  language FAR;
  # ...
}

feature liga {
  sub f i by fi;
  sub f f i by f_f_i;
}
```

// Now let's look at how that is implemented under the hood:
@figure:gsub-impl-internal 展示了在它在字体内部的实现。

#figure(
  caption: [字体内部的结构图示]
)[#image("gsub.png")] <figure:gsub-impl-internal>

// Again, what a terrible mess. Let's take things one at a time. On the left, we have three important tables. (When I say tables here, I don't mean top-level OpenType tables like `GSUB`. These are all data structures *inside* the `GSUB` table, and the OpenType standard, perhaps unhelpfully, calls them "tables".) Within the `GPOS` and `GSUB` table there is a *script list*, a *feature list* and a *lookup list*. There's only one of each of these tables inside `GPOS` and `GSUB`; the other data structures in the map (those without bold borders) can appear multiple times: one for each script, one for each language system, one for each feature, one for each lookup and so on.
这看起来更是一团糟，不过让我们一个一个的来梳理。在最左边显示了三个非常重要的表。（我现在说的表不是指`GSUB`的这种OpenType的顶层数据表，而是指`GSUB`表内部的数据结构，但OpenType标准有点帮倒忙地把这些结构也叫做表。）`GSUB`和`GPOS`表的内部实现都包含#tr[scripts]列表（`Script List`）、特性列表（`Feature List`）和#tr[lookup]列表（`Lookup List`），这三种列表每种只有一个。其他数据结构（图中没有加粗黑边框的那些）可以多次出现。可能是每种#tr[script]一个，每种语言一个，或者每个特性一个，每个查询组一个之类的。

// When we're laying out text, the first thing that happens is that it is separated into runs of the same script and language. (Most documents are in a single script, after all.) This means that the shaper can look up the script we're using in the script list (or grab the default script otherwise), and find the relevant *script table*. Then we look up the language system in the language system table, and this tells us the list of features we need to care about.
当处理文本时，首先需要将它按照语言和#tr[script]划分成块（虽然大多数文档都只使用一种#tr[script]）。此时#tr[shaper]就可以在#tr[scripts]列表中查找正在使用的#tr[script]（没找到就用默认的那个），从而获取到相应的#tr[script]表格（`Script Table`）。然后找到其中所需的语言表格，这个表格会告诉我们有哪些特性可以使用。

// Once we've looked up the feature, we're good to go, right? No, not really. To allow the same feature to be shared between languages, the font doesn't store the features directly "under" the language table. Instead, we look up the relevant features in the *feature list table*. Similarly, the features are implemented in terms of a bunch of lookups, which can also be shared between features, so they are stored in the *lookup list table*.
找到特性之后就好办了对吧？并不太对。为了让某些特性可以在多种语言间共享，字体中的语言表格里并不直接存储特性的内容，我们还需要在特性列表里找到这些特性。与之类似，因为特性是由一堆#tr[lookup]组成的，它们也能在不同的特性间共享，所以也不直接储存在特性中，而是在#tr[lookup]列表里。

// Now we finally have the lookups that we're interested in. Turning on the `liga` feature for the default script and language leads us eventually to lookup table 1, which contains a list of lookup "subtables". Here, the rules that can be applied are grouped by their type. (See the sections "Types of positioning feature" and "types of substitution feature" above.) Our ligature substitutions are lookup type 4.
现在我们终于找到感兴趣的那个#tr[lookup]了，在默认语言#tr[script]的环境下打开`liga`特性最终会使用`lookup table 1`。而这个结构中又包含了一个“子表格”的列表。从这开始，规则就根据它们所属的类型进行分组了，我们这种#tr[ligature]#tr[substitution]属于`type 4`。（有关规则的各种类型，可参考后文#cross-ref(<section:substitution-rule-types>, web-path: "/chapters/06-features-2/substitution.typ", web-content: [#tr[substitution]规则的各种类型])和#cross-ref(<section:positioning-rule-types>, web-path: "/chapters/06-features-2/positioning.typ", web-content: [#tr[positioning]规则的各种类型])）

// The actual substitutions are then grouped by their *coverage*, which is another important way of making the process efficient. The shaper has, by this stage, gathered the features that are relevant to a piece of text, and now needs to decide which rules to apply to the incoming text stream. The coverage of each rule tells the shaper whether or not it's likely to be relevant by giving it the first glyph ID in the ligature set. If the shaper sees anything other than the letter "f", then we know for sure that our rules are not going to apply, so it can pass over this set of ligatures and look at the next subtable. A coverage table comes in two formats: it can either specify a *list* of glyphs, as we have here (albeit a list with only one glyph in it), or a *range* of IDs.
实际的#tr[substitution]规则根据它们的对参数的覆盖性来分组，这是让处理过程更加高效的一个重要手段。#tr[shaper]在这个阶段已经知道了有哪些特性和输入文本有关，下一步是要决定在文本上具体使用哪些规则。所谓覆盖性，就是通过只看#tr[ligature]中的第一个#tr[glyph]，#tr[shaper]就能排除掉所有和当前位置无关的规则。比如只要#tr[shaper]看到第一个输入的#tr[glyph]不是`f`，它就能够确定我们当前这条规则肯定无需应用，可以直接去处理下一个“子表格”。覆盖性表格可能有两种格式：第一种就是我们这里展示的，它直接声明一些#tr[glyph]；第二种是声明一个#tr[glyph]范围。

// OK, we're nearly there. We've found the feature we want. We are running through its list of lookups, and for each lookup, we're running through the lookup subtables. We've found the subtable that applies to the letter "f", and this leads us to two more tables, which are the actual rules for what to do when we see an "f". We look ahead into the text stream and if the next input glyph (which the OpenType specification unhelpfully calls "component", even though that also means something completely different in the font world...) is the letter "i" (glyph ID 256), then the first ligature substitution applies. We substitute that pair of glyphs - the start glyph from the coverage list and the component - by the single glyph ID 382 ("fi"). If instead the next two input glyphs have IDs 247 and 256 ("f i") then we replace the three glyphs - the start glyph from the coverage list and both components - with the single glyph ID 380, or "ffi". That is how a ligature substitution feature works.
很好，就快接近终点了。我们找到了想要的特性，得到了它所有的#tr[lookup]。对于每个#tr[lookup]，都逐个处理它的“子表格”。接着我们找到了可能影响由字母`f`开头的文本的那个“子表格”，它又给了我们两个表，也就是当看到`f`时真正需要处理的规则。然后#tr[shaper]就会向前看下一个#tr[glyph]，如果这个#tr[glyph]（OpenType非常捣乱的把它叫做“部件”，但这个词在字体设计领域中又有另一个完全不同含义……）是字母`i`（也就是ID为256的#tr[glyph]），那么第一条#tr[substitution]规则就被应用了。我们把覆盖性表格中的起始#tr[glyph]和“部件”们整体替换成ID为382的#tr[glyph]`fi`。如果后两个#tr[glyph]是ID为247的`f`和ID为256的`i`，就把加上起始#tr[glyph]的这三个#tr[glyph]整体替换成ID为380的`ffi`。这就是#tr[ligature]#tr[substitution]特性的工作过程。

// If you think that's an awful lot of effort to go to just to change the letters "f i" into "fi" then, well, you'd be right. It took, what, 11 table lookups? But remember that the GPOS and GSUB tables are extremely powerful and extremely flexible, and that power and flexibility comes at a cost. To represent all these lookups, features, languages and scripts efficiently inside a font means that there has to be a lot going on under the hood.
如果你觉得这对于把`f i`换成`fi`这种小事来说工作量有点太大了，那么你说对了，毕竟这个过程中进行了11次的表格跳转。但要记住，因为 `GPOS` 和 `GSUB` 表的功能十分强大，而且有很强的灵活性，而这两者都是有代价的。为了能够在字体中高效的表示#tr[lookup]、特性、语言、#tr[script]这些所有概念，我们必须在这种看不见的地方为之努力。

// Thankfully, unless you're implementing some of these shaping or font editing technologies yourself, you can relax - it mostly all just works.
幸运的是，除非你是在自己编写字体编辑软件或#tr[shaper]，不然日常生活还是能保持轻松的。这些技术基本上都工作得很好。
