#import "/template/heading.typ": chapter

#import "/lib/glossary.typ": tr
#import "/template/components.typ": note
#import "/template/lang.typ": arabic, devanagari, russian

#chapter(
  label: <chapter:opentype-features>
)[
  // Introduction to OpenType Features
  OpenType特性简介
]

// In the previous chapter we looked at some of the data tables hiding inside an OpenType font. And let's face it, they weren't all that interesting - metrics, character mappings, a few Bézier splines or drawing instructions. The really cool part about OpenType (and its one-time rival, Apple Advanced Typography) is the ability to *program* the font. OpenType's collaborative model, which we discussed in our chapter on history, allows the font to give instructions to the shaping engine and control its operation.
在上一章中我们介绍了OpenType字体中的一些数据表，和其中储存的#tr[metrics]、#tr[character]映射、贝塞尔曲线、绘图指令等信息。但说实话，这其实并不怎么有趣吧。OpenType（以及它曾经的对手，Apple Advanced Typography）中真正酷炫的部分是能够对字体进行*编程*。前文介绍的#link(<concept:opentype-collaborative-model>)[OpenType合作模型]概念中已经提到过，字体可以给#tr[shaping]引擎提供指令并控制它的行为。

#note[
  // > When I use the word "instruction" in this chapter, I'm using the term in the computer programming sense - programs are made up of instructions which tell the computer what to do, and we want to be telling our shaping engine what to do. In the font world, the word "instruction" also has a specific sense related to hinting of TrueType outlines, which we'll cover in the chapter on hinting.
  本章中，当使用“指令”这个词时，我是在使用其在计算机科学领域中的含义。程序就是由一些告诉电脑应该做什么的指令构成的，对于字体和#tr[shaping]引擎也是同理。在字体领域，“指令”这个词在对TrueType#tr[outline]进行#tr[hinting]时有另一种含义，这会在有关#tr[hinting]的章节中再详细介绍。
]

// "Smart fonts", such as those enabled by OpenType features, can perform a range of typographic refinements based on data within the font, from kerning, ligature substitution, making alternate glyphs available to the user, script-specific and language-specific forms, through to complete substitution, reordering and repositioning of glyphs.
“智能字体”——比如通过OpenType实现了各种特性的字体——能通过其内部数据对最终的#tr[typography]效果进行精心地打磨调整。像是#tr[kern]、#tr[ligature]、字符#tr[substitution]、可供选择的#tr[alternate glyph]、为某种#tr[script]或语言专门设计的样式、#tr[glyph]完全#tr[substitution]、重排序和#tr[positioning]等等。

// Specifically, two tables within the font - the `GPOS` and `GSUB` tables - provide for a wide range of context-sensitive font transformations. `GPOS` contains instructions for altering the position of glyph. The canonical example of context-sensitive repositioning is *kerning*, which modifies the space between two glyphs depending on what those glyphs are, but `GPOS` allows for many other kinds of repositioning instructions.
特别是字体中的 `GPOS` 和 `GSUB` 表，它们提供了许多基于上下文的字体变换功能。`GPOS` 表中包含对#tr[glyph]位置进行调整的指令。其中的经典例子就是#tr[kern]，它根据前后两个#tr[glyph]具体是什么来调整间隔大小。但除此之外 `GPOS` 还支持其他各种重#tr[positioning]指令。

// The other table, `GSUB`, contains instructions for substituting some glyphs for others based on certain conditions. The obvious example here is *ligatures*, which substitutes a pair (or more) of glyphs for another: the user types "f" and then "i" but rather than displaying those two separate glyphs, the font tells the shaping engine to fetch the single glyph "ﬁ" instead. But once again, `GSUB` allows for many, many interesting substitutions - some of which aren't merely typographic niceties but are absolutely essential when engineering fonts for complex scripts.
另一个 `GSUB` 表则包含在特定情况下将某些#tr[glyph]替换为其他#tr[glyph]的指令。最明显的例子就是#tr[ligature]，它将一对（也可以是更多）#tr[glyph]替换成另一个单独#tr[glyph]。比如用户输入了f和i，但字体可以让#tr[shaping]引擎显示另一个专门的fi#tr[glyph]，用于取代那两个f和i的#tr[glyph]。无独有偶，`GSUB`也支持其他各种有趣的#tr[substitution]指令。其中有些指令不仅能提供对#tr[typography]效果的调整，甚至会作为复杂#tr[scripts]的字体工程所必须的基础步骤。

// In this chapter, we're going to begin to look at these instructions, how we get them into our font, and how they work; in the following two chapters, we'll look more systematically at what instructions are available, and how we can use them to create fonts which support our global scripts.
在本章中我们会简单介绍这些指令以及如何在字体中使用它们，并了解它们的工作原理。在后续的两章中，我们会更系统地介绍有哪些指令可供使用，以及如何使用它们创造支持#tr[global scripts]的字体。

// ## The Adobe feature language
== Adobe 特性语言

// OpenType instructions - more usually known as "rules" - are normally written in a language that doesn't exactly have a name; it's known variously as "AFDKO" (from the "Adobe Font Development Kit for OpenType", a set of software tools one of which reads this syntax and adds the rules into binary font files), "Adobe feature language", "fea", or "feature format". Other ways of representing rules are available, (and inside the font they are stored in quite a different representation) but this is the most common way that we can write the rules to program our fonts.
OpenType 指令也被称为规则，它们通常由一种并没有具体名字的语言写成。人们可能会称它为“AFDKO”、“Adobe特性语言”、“fea”或者“特性格式”。其中 AFDKO 是Adobe OpenType 字体开发套件（Adobe Font Development Kit for OpenType）的简称。这种规则也有其他书写方式（比如当被储存到字体中时，就又是另一种不同的格式），但Adobe的这种格式是被最普遍使用的。

// There are a number of alternatives to AFDKO for specifying OpenType layout features - Microsoft's VOLT (Visual OpenType Layout Tool), my own FLUX (Font Layout UX), and High Logic Font creator all allow you to create features and proof and preview them visually. Monotype also has their own internal editor, FontDame, which lays out OpenType features in a text file. (I've also written an alternative syntax called FEE, which allows for extensions and plugins to add higher-level commands to the language.)
除了 AFDKO 之外还有其他编写OpenType#tr[layout]特性的工具：微软的 VOLT（Visual OpenType Layout Tool），我编写的FLUX（Font Layout UX），以及支持创建并可视化验证OpenType特性的High Logic FontCreator。蒙纳公司也有一个内部的编辑工具，叫做FontDame，它使用文本文件来编辑OpenType特性。（我也编写过一个类似的叫做 FEE 的语言，它支持使用插件和扩展来添加高级命令。）

// But Adobe's language is the one that almost everyone uses, and as a font engineer, you're going to need to know it very well. So let's begin.
但总的来说Adobe的语言还是使用最广泛的。而且作为字体设计师，你也需要对它有足够的了解，所以我们就选它了。

// ## Basic feature coding - substitutions and ligatures
== 编写基础特性——#tr[substitution]与#tr[ligature]

// Here is the simplest complete OpenType program:
这是一个最简单但完整的OpenType程序：

```fea
feature liga {
  sub f f by f_f;
} liga;
```

// Read this as "in the `liga` feature, substitute the glyphs `f f` by `f_f`." This assumes that we have at least two glyphs in our font, one of which is called `f` and another which is called `f_f`. Later on we'll see precisely what we mean by "feature" and why we made one called `liga`, but for now what you need to know is that we have created a rule that will be applied by the shaper whenever some text is set in our font.
此代码可以理解为：在名为`liga`的特性开启时，将#tr[glyph]`f f`替换为`f_f`。这就表明我们的字体里至少有 `f` 和 `f_f`两个#tr[glyph]。后面我们会明确定义什么叫“特性”，也会了解为什么将它起名为`liga`。现在只需要知道，通过这段代码我们就能创建一条在某些文本被设置为此字体时会被#tr[shaper]应用的规则。

// The feature language has a simple syntax. The full details are available as part of the [AFDKO Documentation](http://adobe-type-tools.github.io/afdko/OpenTypeFeatureFileSpecification.html), but the basics are fairly easy to pick up by inspection; a feature is defined like so:
这种用于编写特性的语言语法十分简单。它的完整定义可以参考AFDKO的文档，但其基本使用通过观察上例就能掌握。特性通过如下方式定义：

```fea
feature name { ... } name
```

// We created a feature called `liga` and placed a rule inside it. The rules all start with a rule name and end with a semicolon, but what is in the middle depends on the nature of the rule. The rule we created will substitute one set of glyphs for another, so it is a `sub` rule (you can also spell this `substitution`, if you like). There are various kinds of `sub` rule, and we'll look at them systematically in the next chapter, but the one we're using has two parts to it: the *match*, which consists of one glyph name, and then the *replacement* which is introduced by the keyword `by` and consists of two glyph names. There are also `pos` (or `position`) rules to change the position of glyphs; `sub` rules go in the `GSUB` table and `pos` rules go in the `GPOS` table. Simple, really.
上例就用这种方式创建了一个叫做`liga`的特性，并在其中放置了一条规则。规则语句由规则名开始，使用分号结尾，中间部分的格式则取决于使用的规则。例子中的规则用于对一些#tr[glyph]进行#tr[substitution]操作，这种规则叫做`sub`（表示subtitution，#tr[substitution]）。`sub`规则还有其他几种变体，会在下章中进行具体介绍。现在我们先专注于最简单的这个，它由两部分组成：匹配部分，由两个#tr[glyph]名组成；替换部分，由 `by` 关键字引出，只有一个#tr[glyph]名。另外还有用于改变#tr[glyph]位置的 `pos`（或写成`position`）规则。`sub` 规则放在 `GSUB` 表中，`pos` 规则放在 `GPOS` 表中。很简单，对吧！

// But how do we convert the textual rules we have written into the binary format of these tables? As a designer you might be used to using your font editor, which may also automate some or all of the process of creating OpenType rules and compiling them into the font. But this is often quite slow; it may take a few seconds to completely build and export a font, and when we're developing and testing complex layouts, we don't want to wait that long between tests. (We don't want to be installing fonts and resetting caches before generating our testing documents either, but we'll come to that later.) I like to have a nice quick build process which I can call from `Makefile` or in a command-line script, so that the font is rebuild with new layout rules every time I save the feature file.
但我们如何将文本格式的规则写入字体的二进制数据表中呢？作为设计师，你可以使用字体编辑器。它应该会自动化关于OpenType规则的部分甚至全部流程，包括代码编写、编译以及将其嵌入字体文件等。但通常来说这个过程会比较慢，经常需要数秒才能完成编译并导出字体文件。当我们在开发和测试复杂#tr[layout]的字体时，这些等待时间就有些太长了。（我们也不想每次测试前都要重新安装字体，刷新缓存。）所以我更希望有一个能在`Makefile`或命令行脚本中调用的快速编译流程，以便在我保存特性代码文件时自动使用新的规则重新构建字体。

// One way to achieve this is to use the `fontTools` library, which has a command line script to add features to an existing font file. You can export a "dummy" version of your font from your editor - just the outlines with no layout rules - and use that as a base for adding feature files:
达成这个目标的方式之一是使用 `fontTools` 程序库，它包含一个能将特性直接加入现有字体文件的命令行脚本。你可以先用字体编辑器导出一个最简版本的字体文件（只有#tr[glyph]#tr[outline]，没有任何#tr[layout]规则），将其作为添加特性的目标：

```bash
fonttools feaLib -o MyFont.otf features.fea MyFont-Dummy.otf
```

// A similar utility, `makeotf`, comes as part of the Adobe Font Development Kit for OpenType:
你也可以使用 AFDKO 中的类似工具 `makeotf`：

```bash
makeotf -o MyFont.otf -f MyFont-Dummy.otf -ff features.fea
```

// I prefer the `fontTools` version as it automatically handles the corrections needed to lay out very complex feature files.
我更喜欢 `fontTools` 的版本，因为它能自动对非常复杂的特性代码文件进行编译所必须的修正。

// Finally, if you're learning about OpenType layout and just want to test out rules in an interactive environment, my own `OTLFiddle` software might be helpful. It allows you to drop in a font, type some feature code and immediately see how it affects a given piece of text. In fact, if you're learning about OpenType feature syntax for the first time, I'd seriously encourage you to use OTLFiddle to explore the examples given in this chapter.
最后，如果你是在学习OpenType，并且想在一个交互式的环境中进行规则测试的话从o，我编写的`OTLFiddle`#[@Cozens.Otlfiddle.2020]软件可能会有所帮助。它允许你拖入一个字体文件，编写一些特性代码，然后你就能在软件的界面中直接看到这些代码会如何影响输入文本的显示效果。如果你是第一次学习OpenType特性代码的语法的话，我强烈推荐使用`OTLFiddle`软件来体验本章中的这些例子。

// Download [OTLFiddle](https://github.com/simoncozens/otlfiddle), drop in a font with the `f` and `f_f` glyphs - [Open Sans](https://fonts.google.com/specimen/Open+Sans) is my favourite test Latin font - and type the feature above into the editor. Compile the font, and type the text "official" into the box on the right - although the visual difference is quite subtle, you should be able to see in the read-out of glyphs above the image that the two `f` glyphs have indeed become a single `f_f` glyph.
现在就去下载`OTLFiddle`吧。拖入任何含有`f`和`f_f`#tr[glyph]的字体（我最喜欢用于西文测试的字体是Open Sans@Wikipedia.OpenSans），并在编辑器中输入上面的特性代码。编译字体后，在右边的文本框中输入“Official”。尽管差别非常小，但你应该能看出预览界面中的两个`f`#tr[glyph]变成了一个`f_f`#tr[glyph]。

// ## Glyph Classes and Named Classes
== #tr[glyph]类与命名类

// Now let’s write a set of rules to turn lower case vowels into upper case vowels:
现在我们编写一系列把所有的小写元音字母变成大写的规则：

```fea
feature liga {
  sub a by A;
  sub e by E;
  sub i by I;
  sub o by O;
  sub u by U;
} liga;
```

// That was a lot of work! Thankfully, it turns out we can write this in a more compact way. Glyph classes give us a way of grouping glyphs together and applying one rule to all of them:
这样代码好像有点长，我们能把它写成更紧凑的形式。通过将一些#tr[glyph]写成一组来组成#tr[glyph]类的方式可以批量应用规则：

```fea
feature liga {
    sub [a e i o u] by [A E I O U];
}  liga;
```

// Try this in OTLFiddle too. You'll find that when a class is used in a substitution, corresponding members are substituted on both sides.
在 `OTLFiddle` 中试试这个例子，你会发现当在#tr[substitution]规则中使用#tr[glyph]类时，会在匹配和替换两侧分别使用类中同一位置的成员。

// We can also use a glyph class on the "match" side, but not in the replacement side:
我们也可以只在匹配侧使用#tr[glyph]类：

```fea
feature liga {
    sub f [a e i o u] by f_f;
}  liga;
```

这等价于写：

```fea
feature liga {
    sub f a by f_f;
    sub f e by f_f;
    sub f i by f_f;
    # ...
}  liga;
```

// Some classes we will use more than once, and it's tedious to write them out each time. We can *define* a glyph class, naming a set of glyphs so we can use the class again later:
有些类会被多次使用，每次都明确写出其中每个#tr[glyph]就太繁琐了。在这个场景下我们可以给定义的#tr[glyph]类命名，这样就能在后面的代码中直接使用了：

```fea
@lower_vowels = [a e i o u];
@upper_vowels = [A E I O U];
```

// Now anywhere a glyph class appears, we can use a named glyph class instead (including in the definition of other glyph classes!):
现在任何可以填写#tr[glyph]类的地方，你都可以使用这些名字来代替。甚至在后续定义其他#tr[glyph]类时也可以使用：

```fea
@vowels = [@lower_vowels @upper_vowels];

feature liga {
  sub @lower_vowels by @upper_vowels;
} liga;
```

// ## Features and lookups
== 特性与#tr[lookup]

// We've been putting our *rules* into a *feature*. Features are part of the way that we signal to the shaper which rules to apply in which circumstances. For example, the feature called `liga` is the "ligatures" features, and is always processed in the case of text in the Latin script unless the user specifically requests it to be turned off; there is another feature (`rlig`) for required ligatures, those which should always be applied even if the user doesn't want explicit ligatures. Some features are *always* processed as a fundamental part of the shaping process - particularly the case when dealing with scripts other than Latin - while others are optional and aesthetic. We will introduce different features, and what they're recommended to be used for, as we come across them, but you can also look up any unfamiliar features in the [OpenType Feature Registry](https://docs.microsoft.com/en-us/typography/opentype/spec/featurelist)
目前的代码结构是规则包含在特性中。特性是我们用来告诉#tr[shaper]在某种特定情形下，需要使用哪些规则的一种组织结构。比如我们这里使用的`liga`其实是#tr[ligature]（ligature）特性，这一特性在处理拉丁文本时会自动开启，除非用户明确指定才会关闭。还有另一个特性叫做`rlig`，表示必要（required）#tr[ligature]。这一特性即使用户明确指出不需要#tr[ligature]也仍然会被应用。像这样永远会被使用的特性被视为文本#tr[shaping]流程中（特别是处理拉丁以外的#tr[scripts]时）的基础步骤。除此之外的则是可选特性，它们主要服务于美学上的需求。我们会逐步向你介绍这些不同的特性以及它们各自推荐的使用场景。在遇到不熟悉的特性时，你也可以通过OpenType特性列表#[@Microsoft.OpenTypeRegistered]进行查询。

// We've only seen rules and features so far but it's important to know that there's another level involved too. Inside an OpenType font, rules are arranged into *lookups*, which are associated with features. Although the language we use to write OpenType code is called "feature language", the primary element of OpenType shaping is the *lookup*. So rules are grouped into sets called *lookups*, and lookups are placed into *features* based on what they're for. You might want to refine your typography in different ways at different times, and turning on or off different combinations of features allows you to do this.
现在我们只使用了特性和规则，但其中还隐含了另一个等级的重要组织结构。在OpenType字体中，规则首先被组织成*#tr[lookup]*，然后再与特性关联。虽然我们写代码的语言叫做特性语言，但OpenType进行文本#tr[shaping]时最主要的元素其实是#tr[lookup]，它们按照自己的作用放置在相应的特性中。你可能希望字体的#tr[typography]效果能根据需求进行调整，通过开关不同的特性可以做到这一点。

// For instance, if you hit the "small caps" icon in your word processor, the word processor will ask the shaping engine to turn on the `smcp` feature. The shaping engine will run through the list of features in the font, and when it gets to the `smcp` feature, it will look at the lookups inside that feature, look at each rule within those lookups, and apply them in turn. These rules will turn the lower case letters into small caps:
比如你在 Word 中点击“小型大写字母”图标，Word 软件会让#tr[shaping]引擎打开字体的`smcp`特性。此时#tr[shaping]引擎就会遍历字体的特性列表，当他找到`smcp`特性时，会逐条查看其中的#tr[lookup]，并对每个#tr[lookup]中的规则按顺序进行应用。@figure:feature-hierarchy 展现了将小写字母转换为小型大写字母流程。

#figure(
  caption: [启用`smcp`特性],
)[#include "feature-hierarchy.typ"] <figure:feature-hierarchy>

// **To really understand OpenType programming, you need to think in terms of lookups, not features**.
*为了能够真正地理解OpenType编程，你需要站在#tr[lookup]的角度进行思考，而不是站在特性的角度。*

//  So far our lookups have been *implicit*; by not mentioning any lookups and simply placing rules inside a feature, the rules you specify are placed in a single, anonymous lookup. So this code which places rules in the `sups` feature, used when converting glyphs to their superscript forms (for example, in the case of footnote references):
至今为止的代码中，#tr[lookup]都是隐式的。像这样在特性里直接写规则的话，这些规则都会被直接放在同一个匿名#tr[lookup]中。以`sups`特性为例，其中的代码用于将#tr[glyph]转换为（可能用于书写脚注的引用标号的）上标形式：

```fea
feature sups {
  sub one by onesuperior;
  sub two by twosuperior;
  sub three by threesuperior;
} sups;
```

// is equivalent to this:
这段代码等价于：

```fea
feature sups {
  lookup sups_1 {
    sub one by onesuperior;
    sub two by twosuperior;
    sub three by threesuperior;
    } sups_1;
} sups;
```

// We can manually organise our rules within a feature by placing them within named lookups, like so:
我们也可以通过将规则放入手动命名的#tr[lookup]中来组织特性中的规则。就像下面这样：

```fea
feature pnum {
  lookup pnum_latin {
    sub zero by zero.prop;
    sub one by one.prop;
    sub two by two.prop;
    ...
  } pnum_latin;
  lookup pnum_arab {
    sub uni0660 by uni0660.prop;
    sub uni0661 by uni0661.prop;
    sub uni0662 by uni0662.prop;
    ...
  } pnum_arab;
} pnum;
```

// In fact, I would strongly encourage *always* placing rules inside an explicit `lookup` statement like this, because this helps us to remember the role that lookups play in the shaping process. As we'll see later, that will in turn help us to avoid some rather subtle bugs which are possible when multiple lookups are applied, as well as some problems that can develop from the use of lookup flags.
我永远强烈推荐把规则放进手动创建的#tr[lookup]中，因为这样可以帮助我们记住#tr[lookup]在整个#tr[shaping]过程中的角色和作用。这也能帮助我们在需要使用多个#tr[lookup]或复杂的#tr[lookup]选项时避免一些微妙的Bug。后面我们会看到其中的原因。

// Finally, you can define lookups outside of a feature, and then reference them within a feature. For one thing, this allows you to use the same lookup in more than one feature, sharing rules and reducing code duplication:
最后，你也可以在特性之外定义#tr[lookup]，并在特性内引用它们。这也就让你能在多个特性中重复使用同一个#tr[lookup]，像这样共享规则可以减少重复代码：

```fea
lookup myAlternates {
  sub A by A.001; # 替代形式
  ...
} myAlternates;

feature salt { lookup myAlternates; } salt;
feature ss01 { lookup myAlternates; } ss01;
```

// The first clause *defines* the set of rules called `myAlternates`, which is then *used* in two features: `salt` is a general feature for stylistic alternates (alternate forms of the glyph which can be selected by the user for aesthetic reasons), and `ss01` which selects the first stylistic set. The ability to name and reference sets of rules in a lookup will come in extremely useful when we look at chaining rules - when one rule calls another.
第一条语句将一些规则定义为`myAlternates`#tr[lookup]，后续它被用在 `salt` 和 `ss01` 两个特性中。`salt` 是一种通用特性，供用户选择#tr[glyph]在美学上的替代样式。而 `ss01` 特性用于启用第一种样式。这种可以为#tr[lookup]命名并通过名称引用其中的规则的功能非常有用，特别是在后续介绍#tr[chaining rules]（一个规则调用另一个规则）时。

// ## Scripts and languages
== 语言和#tr[script]

// Lookups apply to particular combinations of *language* and *script*. You can, for example, substitute generic glyph forms for localised forms which are more appropriate in certain linguistic contexts: for example, the Serbian form of the letter be (б) is expected to look different from the Russian form. Both forms can be stored in the same font, and the choice of appropriate glyph made on the basis of the language of the text.
#tr[lookup]会应用于特定的*语言#tr[script]*二元组。比如你可以在某些语言环境下，将一些#tr[glyph]从通用样式替换为当地样式。具体来说，以字母 be（#russian[б]）为例，它在塞尔维亚语中和在俄语中的样式就略有不同。这两种样式可以同时储存在字体中，然后根据文本的语言来选择使用合适的那一个。<position:serbian-letter-be>

// Again, so far we've handled this implicitly - any rules which are not tagged explicitly with the language and script combination that they refer to are considered to apply to the "default" script and "default" language. The script and language are described using four-character codes called "tags"; for example, the script tag for Malayalam is `mlm2`. You can find the list of [script tags](https://docs.microsoft.com/en-gb/typography/opentype/spec/scripttags) and [language tags](https://docs.microsoft.com/en-gb/typography/opentype/spec/languagetags) in the OpenType specification. The shaper is told, by the layout application, what language and script are being used by the input run of text. (It may also try guessing the script based on the Unicode characters in use.)
但之前我们也忽略了这个功能，使用了默认的处理方式。也就是没有被显式标记属于哪个语言#tr[script]二元组的规则统一都被视为属于“默认”语言和“默认”#tr[scripts]。这个二元组中的语言和#tr[scripts]都使用四个#tr[character]的代码表示，它们被称为“标签”。比如，马拉雅拉姆文的标签是“mlm2”。你可以在OpenType规范中的语言标签列表#[@Microsoft.OpenTypeLanguage]和#tr[scripts]标签列表#[@Microsoft.OpenTypeScript]中找到所有的可用标签。排版程序会告诉#tr[shaper]当前的输入文本属于哪种语言和#tr[script]。（它也可能会尝试根据文本包含的Unicode#tr[character]来进行猜测。）

// Inside the font, the GSUB and GPOS tables are arranged *first* by script, *then* by language, and finally by feature. But that's a confusing way for font designers to work, so AFDKO syntax allows you to do things the other way around: define your features and write script- and language-specific code inside them.
在字体内部，`GSUB`和`GPOS`表首先被按照#tr[scripts]分组，然后再按照语言分，最后才是各个特性。但这样的组织结构对于字体设计师来说比较难处理，所以 AFDKO 的语法允许使用另一种方式。我们可以在特性内部定义专门适用于某种#tr[script]和语言的代码块。

// To make this work, however, you have to define your "language systems" at the start of the feature file. For example, here is a font which will have support for Arabic and Urdu, as well as Turkish and "default" (non-language-specific) handling of the Latin script, non-language-specific handling of Arabic *script* (for instance, if the font is used for documents written in Persian; "Arabic" in this case includes Persian letters), and it will also have some rules that apply generally:
但为了使用这个功能，你需要在特性文件的开头定义你自己的“语言系统”。以下是一个在语言上支持阿拉伯语、乌尔都语、土耳其语以及“默认”语（未指定语言），在#tr[scripts]上支持拉丁文，未指定语言的阿拉伯文（阿拉伯文也被用于书写其他多种语言，比如波斯语，在这种情况下阿拉伯文也包括波斯字母），另外还包含一些通用规则的字体代码：

```fea
# languagesystem <文字标签> <语言标签>;
languagesystem DFLT dflt;
languagesystem arab dflt;
languagesystem arab ARA;
languagesystem arab URD;
languagesystem latn dflt;
languagesystem latn TRK;
```

// Once we have declared what systems we're going to work with, we can specify that particular lookups apply to particular language systems. So for instance, the Urdu digits four, five and seven have a different form to the Arabic digits. If our font is to support both Arabic and Urdu, we should make sure to substitute the expected forms of the digits when the input text is in Urdu.
一旦定义好了我们计划支持的语言#tr[script]系统，就可以为每个#tr[lookup]指明它适用于其中哪一个了。比如，乌尔都语中的数字四、五、七和阿拉伯数字不同。如果字体希望同时支持它们，就需要在输入文本是乌尔都语时进行适当的#tr[substitution]来显示符合预期的数字#tr[glyph]样式。

// We'll do this using a `locl` (localisation) feature, which only applies in the case of Urdu:
我们使用一个只在乌尔都语条件下激活的 `locl`（localisation，本地化）特性来实现这个功能：

```fea
feature locl {
    script arab;
    language URD;
    # 直到下一个 script/language 语句为止，所有查询组都只会在
    # 环境为使用阿拉伯文书写的乌尔都语时被应用
    lookup urdu_digits {
      sub four-ar by four-ar.urd;
      sub five-ar by five-ar.urd;
      sub seven-ar by seven-ar.urd;
    } urdu_digits;
} locl;
```

// As mentioned above, any lookups which appear *before* the first `script` keyword in a setting are considered to apply to all scripts and languages. If you want to specify that they should *not* appear for a particular language environment, you need to use the declaration `exclude_dflt` like so:
之前提到过，任何出现在第一个`script`/*language怎么说？*/关键字之前的#tr[lookup]都会被视为在所有#tr[scripts]和语言时都可用。如果你希望它们在某些语言环境下*不要*被使用，则可以使用 `exclude_dflt`：

```fea
feature liga {
    script latn;
    lookup fi_ligature {
      sub f i by fi; # 所有基于拉丁文的语言都激活此连字
      } fi_ligature;

    language TRK exclude_dflt; # 但土耳其语除外
} locl;
```

// You may also see `include_dflt` in other people's feature files. The default rules are included by, uh, default, so this doesn't actually do anything, but making that explicit can be useful documentation to help you figure out what rules are being applied. And speaking of what rules are being applied...
你可能会在其他的特性文件中看到 `include_dflt`。它实际上不起任何作用，但将它明确写出来可以作为一种辅助信息，帮助其他人理解这里到底应用了哪些规则。既然提到了“到底应用了哪些规则”这一话题……

// ## How OpenType shaping works
== 文本#tr[shaping]的工作流程

// While we could now carry on describing the syntax of the feature file language and giving examples of OpenType rules, this would not necessarily help us to transfer our knowledge to new situations - especially when we are dealing with scripts which have more complicated requirements and expectations. To get that transferable knowledge, we need to have a deeper understanding of what we're doing and how it is being processed by the computer.
我们已经知道特性文件中描述OpenType规则的语法了，但只知道这些并不足以让我们高效地利用现有的知识，尤其是在处理具有复杂排版需求的#tr[script]系统时。为了让这些关于文本的知识可以转化为通用的字体设计能力，我们需要深入了解计算机在整个处理过程中到底进行了哪些操作。

// So we will now pause our experiments with substitution rules, and before we get into other kinds of rule, we need to step back to look at how the process of OpenType shaping works. As we know, *shaping* is the application of the rules and features within a font to a piece of text. Let's break it down into stages.
让我们暂停对#tr[substitution]规则的实验，也先不去了解其他类型的规则。暂且后退一步，先来看看OpenType文本#tr[shaping]的整体工作原理。我们已经知道，#tr[shaping]就是将字体中规则和特性应用到一段文本上的过程。这个过程可以分为以下几个阶段。

// ### Mapping and reordering
=== 映射和重排序

// The first thing the shaper does is map the Unicode characters in the input into a series of glyph IDs, internal to the font. (I call this resulting series the "glyph stream", but that's not a common expression. Shaper implementers may call it the *buffer*.) For some scripts, this mapping is easy. You simply uses the character map (`cmap` table) to turn Unicode characters into glyph IDs internal to the font. Most scripts, however, need a bit of help when moving from the Unicode world of characters to the OpenType world of glyphs. This “help” is the logic provided by complex shapers; there are a bunch of “complex shapers” as part of an OpenType shaping engine, each handling text in a different script or family of scripts.
#tr[shaping]工作的第一步是#tr[shaper]将输入的Unicode#tr[character]映射为在字体内部使用的#tr[glyph]ID序列。我通常会将这个序列称为“#tr[glyph]流”，但这并不是通用术语，#tr[shaper]的某些实现可能就称其为“缓冲区”。对于某些#tr[scripts]来说，这种映射非常简单，只需要直接使用#tr[character]映射表（`cmap` 表）即可。但绝大多数#tr[scripts]在这一步骤中都需要一些额外的帮助。这些“帮助”通常由支持复杂#tr[scripts]的#tr[shaper]提供。基于OpenType技术的#tr[shaping]引擎内部通常会有各种复杂#tr[scripts]#tr[shaper]，每个#tr[shaper]用于支持一种（或一个家族的）#tr[script]。

// So, for example, if your text is in Arabic, it will come in as a series of codepoints which don’t contain any “topographic” information: the string ججج is made up of the same Unicode code point three times (U+062C ARABIC LETTER JEEM). But it needs to come out as three different glyphs, one for “initial jeem”, one for “medial jeem” and one for “final jeem”. In this case, there’s a part of the shaping engine which specifically knows how to help process Arabic, and it goes through the Unicode input annotating it with what position the glyphs need to be in. It knows how Arabic “works”: it knows that if you have جاج (JEEM ALIF JEEM), the first JEEM goes in initial form because it links to the ALIF but the second JEEM stays how it is because the letter ALIF does not join to its left. After it has done this annotation, it will apply the rules you specify for initial form substitutions *only* to those parts of the glyph stream which are marked as being in initial form, and so on for medial, final and isolated forms.
假设输入文本是阿拉伯文，它首先会被转化为不包含任何#tr[typography]信息的一串#tr[codepoint]。举例来说，字符串 #arabic[ججج] 由同一个Unicode#tr[codepoint]（`U+062C ARABIC LETTER JEEM`）重复三次组成，但在后续流程中它们需要被映射为三个不同的#tr[glyph]。第一个#tr[codepoint]映射为“首部JEEM”，第二个则是“中部JEEM”，最后的是“尾部JEEM”。在此情境中，#tr[shaping]引擎需要知道如何处理阿拉伯文，它映射出的#tr[glyph]需要附带上其所处位置的信息。这也就是说，#tr[shaping]引擎了解有关阿拉伯文的书写规则。比如它知道在文本 #arabic[جاج]（JEEM ALIF JEEM）中，第一个JEEM因为和 ALIF 连接，所以它需要是首部形式。而第二个 JEEM 则不变形，因为 ALIF 不应继续向左连接。在#tr[shaping]引擎进行了类似这样的位置标注之后，代码中的只针对首部样式的#tr[substitution]规则才能只应用于对应位置的#tr[glyph]们。中部、尾部以及独立样式也同理。

// Other scripts require different kinds of help to move from the Unicode world to the OpenType world. The way that Unicode defines the encoding of scripts is sometimes a little bit different from the order that those scripts are written in. As a simple example, the Devanagari sequence कि (“ki”) is encoded with the consonant ka (क) first and then the vowel i (ि) second. But visually - when you type or print - the vowel needs to appear first. So the shaping engine has to again “help” the font by reordering the glyph stream: it puts any vowels which need to visually appear first - "pre-base vowels" - before the base consonant. This is just a convenience; it’s much easier for us as the engineer to handle the glyphs `iMatra-deva ka-deva` than it would be to be handed `ka-deva iMatra-deva` as a straight Unicode-to-glyph conversion, and then be left having to shuffle the glyphs around in your font’s OpenType rules.
其他#tr[scripts]各自需要不同类型的帮助才能顺利地从Unicode世界来到OpenType世界。Unicode定义#tr[encoding]的方式和有时会和#tr[script]本身的书写顺序不太一致。一个简单的例子是天城文中的ki，写作 #devanagari[कि] 。它被#tr[encoding]为辅音ka（#devanagari[क]）加上元音i（#devanagari[ि]）。但当你书写或打印这个#tr[character]时，在视觉上却是元音i先出现。这就又到了#tr[shaping]引擎施以援手的时候了，它会将#tr[glyph]流重新排序，将这种前置元音挪动到对应的基本辅音之前。这会使我们作为工程师的工作更加简单，毕竟比起处理 `ka-deva iMatra-deva` 这种从Unicode直接转换而来的形式，调整过的 `iMatra-deva ka-deva` 就不需要我们自己写OpenType规则来调换它们的位置了。

// Notice also that when I showed you the vowel i on its own like this - ि - it was displayed with a dotted circle. The vowel mark can’t normally appear on its own - it needs to be attached to some consonant - so I have typed something that is orthographically impossible. To denote the missing consonant and to try and display something sensible, the shaping engine has inserted the dotted circle; that’s another job of the complex shaper. It knows what is a valid syllable and what isn’t, and adds dotted circles to tell you when a syllable is broken. (So if you ever see a dotted circle in the printed world, the input text was wrong.)
请注意，当我像 #devanagari[ि] 这样单独展示元音 i 时，右边会有一个虚线描绘的圆。这表示这个元音不应该单独出现，它需要附加到某些辅音上。所以这种展示方式其实是构造了违反正字法的文本。为了让显示的内容有意义，提示这里缺少了辅音，#tr[shaping]引擎会插入一个虚线圆。这就是复杂#tr[scripts]#tr[shaper]的另一个工作内容了。它知道哪些音节是有效的，哪些是不完整的。所以只要你看到了这个虚线圆，就表示输入的文本是有问题的。

// ### Rule selection
=== 规则选取

// Next then processes substitution rules from the GSUB table, and finally the positioning rules from the GPOS table. (This makes sense, because you need to know what glyphs you're going to draw before you position them...)
下一个步骤是处理`GSUB`表中的#tr[substitution]规则，然后再处理`GPOS`表中的#tr[positioning]规则。这个先后顺序十分自然，毕竟你需要知道最终要绘制的#tr[glyph]是什么，然后才能确定它们的#tr[position]。

// The first step in processing the table is finding out which rules to apply and in what order. The shaper does this by having a set of features that it is interested in processing.
处理每张表的第一步都是去决定要应用其中的哪些规则，以及要以什么顺序应用它们。#tr[shaper]会根据其内部的一个相关特性集来完成这一步。

// The general way of thinking about this order is this: first, those "pre-shaping" features which change the way characters are turned into glyphs (such as `ccmp`, `rvrn` and `locl`); next, script-specific shaping features which, for example, reorder syllable clusters (Indic scripts) or implement joining behaviours (Arabic, N'ko, etc.), then required typographic refinements such as required ligatures (think Arabic again), discretionary typographic refinements (small capitals, Japanese centered punctuation, etc.), then positioning features (such as kerning and mark positioning).[^1]
通常，你可以认为特性是按如下顺序进行处理：首先是那些可能改变#tr[character]映射到的#tr[glyph]的“#tr[shaping]前”特性，比如 `ccmp`、`rvrn`、`locl`等；然后处理针对特定#tr[scripts]的#tr[shaping]特性，比如婆罗米系#tr[scripts]需要的重排音节簇，或阿拉伯文和N'ko等#tr[script]中的特殊连接行为；再之后是#tr[typography]效果上的调整，比如必要#tr[ligature]以及小型大写字母、日文标点居中等自选排版特性；最后处理#tr[position]相关的特性，像是#tr[kern]和符号#tr[positioning]等。#footnote[
  // See John Hudson's paper [*Enabling Typography*](http://tiro.com/John/Enabling_Typography_(OTL).pdf) for an explanation of this model and its implications for particular features.
  对于此模型的详细解释及其对某些特性实现的影响，可参阅#cite(<Hudson.EnablingTypography.2014>, form: "prose")。
]

// More specifically, Uniscribe gathers the following features for the Latin script: `ccmp`, `liga`, `clig`, `dist`, `kern`, `mark`, `mkmk`. Harfbuzz does it in the order `rvrn`, either `ltra` and `ltrm` (for left to right contexts) or `rtla` and `rtlm` (for right to left context), then `frac`, `numr`, `dnom`, `rand`, `trak`, the private-use features `HARF` and `BUZZ`, then `abvm`, `blwm`, `ccmp`, `locl`, `mark`, `mkmk`, `liga`, and then either `calt`, `clig`, `curs`, `dist`, `kern`, `liga`, and `rclt` (for horizontal typesetting) or `vert` (for vertical typesetting).
更确切的说，在拉丁文环境下，Windows 中的 Uniscribe 组件会考虑使用`ccmp`、`liga`、`clig`、`dist`、`kern`、`mark`、`mkmk` 特性。HarfBuzz 的顺序则是：`rvrn`；从左往右的环境中使用` ltra`、`ltrm`，从右往左的环境换成 `rtla` 、`rtlm`；然后依次为 `frac`、`numr`、`dnom`、`rand`、`trak`、私有特性 `HARF`和`BUZZ`、`abvm`、`blwm`、`ccmp`、`locl`、`mark`、`mkmk`、`liga`；接着在横排下使用 `calt`、`clig`、`curs`、`dist`、`kern`、`liga`、`rclt`，在竖排下使用 `vert`。

// For other scripts, the order in which features are processed (at least by Uniscribe, although Harfbuzz generally follows Uniscribe's lead) can be found in Microsoft's "Script Development Specs" documents. See, for instance, the specification for [Arabic](https://docs.microsoft.com/en-gb/typography/script-development/arabic); the ordering for other scripts can be accessed using the side menu.
其他#tr[scripts]环境下的特性处理顺序可以在微软的《字体开发规范》文档中找到。至少 Uniscribe 会遵守此规范，而 HarfBuzz 通常会跟随 Uniscribe 的开发方向。打开阿拉伯文的规范#[@Microsoft.DevelopingArabic]，通过侧边菜单可以前往关于其他#tr[scripts]的页面。

// After these default feature lists required for the script, we add any features that have been requested by the layout engine - for example, the user may have pressed the button for small capitals, which would cause the layout engine to request the `smcp` feature from the font; or the layout engine may see a fraction and turn on the `numr` feature for the numbers before the slash and the `dnom` feature for numbers after it.
除了特定#tr[scripts]所需的默认特性列表外，#tr[layout]引擎可能还会要求增加某些特性。比如用户可能按下了小型大写字母的按钮，此时#tr[layout]引擎就会要求使用字体中的`smcp`特性。或者#tr[layout]引擎在发现类似3/5形式的分数时，可能为斜杠前面的数字开启`numr`特性，为之后的数字开启`dnom`特性，可以产生#text(features: ("numr",))[3]/#text(features: ("dnom",))[5]这样的效果。

// Now that we have a set of features we are looking for, we need to turn that into a list of lookups. We take the language and script of the input, and see if there is a feature defined for that language/script combination; if so, we add the lookups in that feature to our list. If not, we look at the features defined for the input script and the default language for that script. If that's not defined, then we look at the features defined for the `dflt` script.
现在我们有了一个将要被应用的特性列表，它需要被转换成#tr[lookup]列表。我们从输入中得知当前语言和#tr[scripts]后，会去检查字体中是否有为这种组合定义的特性。如果存在的话，就会将特性中的所有#tr[lookup]加入列表中。如果不存在，就会去查找输入的#tr[scripts]加默认语言的组合。如果还是不存在，会使用为 `dflt` 定义的特性。

// For example, if you have text that we know to be in Urdu (language tag `URD`) using the Arabic script (script tag `arab`), the shaper will first check if Arabic is included in the script table. If it is, the shaper will then look to see if there are any rules defined for Urdu inside the Arabic script rules; if there are, it will use them. If not, it will use the "default" rules for the Arabic script. If the script table doesn't have any rules for Arabic at all, it'll instead pretend that the script is called `DFLT` and use the feature list defined for that script.
举个例子，假设你输入了一段使用阿拉伯文（`arab`）书写的乌尔都语（`URD`）文本。此时#tr[shaper]会首先检查字体的支持#tr[scripts]列表中是否有阿拉伯文。如果有，#tr[shaper]会查找阿拉伯文的规则中是否有定义为乌尔都语使用的，有的话就会只使用这些规则。要是没有，他会使用阿拉伯文的“默认”规则。如果字体中根本没有阿拉伯文的规则，#tr[shaper]会将输入文本视为“DFLT”文，然后使用为此#tr[scripts]定义的特性列表。

// ### Lookup application
=== 应用#tr[lookup]

// Now we have a list of lookups, which each contain rules. These rules are then applied to the glyph stream, lookup by lookup.
完成上面的步骤后，我们手上就有了一个#tr[lookup]的列表，表中的每个#tr[lookup]中都有一些规则。这个列表会逐个#tr[lookup]地进行处理，将其中的规则应用到#tr[glyph]流中。

// I think of the shaping process as being like an old punched-tape computer. (If you know what a Turing machine is, that's an even better analogy.) The input glyphs that are typed by the user are written on the "tape" and then a "read head" goes over the tape cell-by-cell, checking the current lookup matches at the current position.
我认为这种#tr[shaping]流程有点像使用打孔纸带的老式计算机（图灵机会是更好的术语，如果你知道它的话）。这些输入的#tr[glyph]就像是往纸带上打了孔，然后读取头会一格一格的阅读这些纸带，来确定当前的#tr[lookup]是否匹配当前位置的内容。

#figure(
  caption: [应用#tr[lookup]的流程就像老式打孔纸带计算机],
  placement: none,
  include "slide-9.typ"
)

// If the lookup matches, the shaper takes the appropriate action (substitution in the cases we have seen so far). It then moves on to the next location. Once it has gone over the whole tape and performed any actions, the next lookup gets a go (we call this "applying" the lookup).
如果当前#tr[lookup]匹配了当前的位置，#tr[shaper]将会执行相应的行动，比如我们之前举例的#tr[glyph]#tr[substitution]。之后（无论是否执行了其中任何规则）读取头就会移动到下一格继续处理这个#tr[lookup]。直到这样逐步处理完整个纸带后，下一个#tr[lookup]才会被选为当前#tr[lookup]，纸带也重新回到开头位置，重复这一被称为“应用#tr[lookup]”的过程。

// Notice we have said that the rules are applied lookup by lookup. This is where it becomes important to explicitly arrange our rules into lookups. Consider the difference between this:
请仔细阅读上面的流程，它表示规则是按#tr[lookup]为单位执行的。这一特性就使#tr[lookup]和规则的组织关系变得重要起来。考虑如下两段代码：

#let code1 = ```fea
feature liga {
    sub a by b;
    sub b by c;
} liga;
```

#let code2 = ```fea
feature liga {
    lookup l1 { sub a by b; } l1;
    lookup l2 { sub b by c; } l2;
} liga;
```

#figure(
  placement: none,
  grid(
    columns: (1fr, 2fr),
    column-gutter: 1em,
    code1, code2,
  )
)

// How would these features be applied to the glyph stream `c a b b a g e`? 
这两个特性引用于#tr[glyph]流 `c a b b a g e` 时会有什么不同呢？

// In the first case, *both* rules are considered at each position and the first to match is applied. An `a` is substituted by a `b` and a `b` is substituted by a `c`, so the output would be `c b c c b g e`.
对于左边的代码，这两条规则属于一个#tr[lookup]，所以在每个位置上，只有匹配此位置规则会被应用。也就是 `a` #tr[substitution]为 `b`，`b` #tr[substitution]为 `c`。最终的结果为 `c b c c b g e`。

// But in the second case, the first rule is applied at each position - leading to `c b b b b g e` - *and then* the tape is rewound and the second rule is applied at each position. The final output is `c c c c c g e`.
而对于右边的代码，流程是每个位置先检查并应用第一条#tr[lookup]中的规则，这就把#tr[glyph]流变成了 `c b b b b g e`。然后纸带重新回到开头位置，开始在每个位置上处理第二条#tr[lookup]中的规则。最终结果为 `c c c c c g e`。

// In short, rules in separate lookups act in sequence, rules in a single lookup act in parallel. Making your lookups explicit ensures that you get what you mean.
简而言之，在不同#tr[lookup]中的规则会按顺序匹配，在同一#tr[lookup]中的规则会同时进行匹配。明确的写出#tr[lookup]能确保最终的处理结果是符合你期望的。

#note[
  // > There is another reason why it's good to put rules explicitly into lookups; in OpenType, there are sixteen different types of rule, and a lookup may only contain rules of the same type. The compiler which packs these rules into the font tries to be helpful and, if there are different types of rule in the same feature, splits them into separate lookups, without telling you. But we have seen that when you split rules into separate lookups, you can end up changing the effect of those rules. This can lead to nasty debugging issues.
  推荐将规则明确放入#tr[lookup]中还有另一个原因。在OpenType中有 16 种不同类型的规则，而一个#tr[lookup]中只能含有相同类型的规则。将规则打包进字体的编译器在发现一个特性中有不同类型的规则时，为了更加智能的辅助整个流程，会将它们按类型放入各自独立的#tr[lookup]中。而这一切都是默默发生的。但实际上，改变规则划分为#tr[lookup]的方式实际上会改变其最终效果，这就可能导致一些难以调查的奇怪问题。
]

// ### Lookup Flags
=== #tr[lookup]选项

// One more thing about the lookup application process - each lookup can have a set of *flags* which alters the way that it operates. These flags are *enormously* useful in controlling the shaping of global scripts.
在应用#tr[lookup]步骤中，另一个值得一提的功能是每个#tr[lookup]都可以启用一些选项。这些选项可以改变#tr[lookup]的运作方式，在控制#tr[global scripts]的文本#tr[shaping]时非常有用。

// For example, in Arabic, there is a required ligature between the letters lam and alef. We could try implementing this with a simple ligature, just like our `f_f` ligature:
还是以阿拉伯文为例，它在字母 lam 和 alef 间有一个必要#tr[ligature]。我们现在就来尝试实现这个类似`f_f`的简单#tr[ligature]：

```fea
feature liga {
  lookup lamalef-ligature {
      sub lam-ar alef-ar by lam_alef-ar;
  } lamalef-ligature;
} liga;
```

// However, this would not work in all cases! It's possible for there to be  diacritical marks between the letters; the input glyph stream might be `lam-ar kasra-ar alef-ar`, and our rule will not match. No problem, we think; let's create another rule:
但这段代码并不是在所有情况下都能正常工作，因为两个字母之间可能有#tr[diacritic]。比如输入的#tr[glyph]流可能是 `lam-ar kasra-ar alef-ar`，这样我们的规则就不匹配了。没事，我们可以再创建一条规则：

```fea
feature liga {
  lookup lamalef-ligature {
      sub lam-ar alef-ar by lam_alef-ar;
      sub lam-ar kasra-ar alef-ar by lam_alef-ar kasra-ar;
  } lamalef-ligature;
} liga;
```

// Unfortunately, we find that this refuses to compile; it isn't valid AFDKO syntax. As we'll see in the next chapter, while OpenType supports more-than-one match glyphs and one replacement glyph (ligature), and one match glyph and more-than-one replacement glyphs (multiple substitution), it rather annoyingly *doesn't* support more-than-one match glyphs and more-than-one replacement glyphs (many to many substitution).
但不幸的是，这段代码无法编译，他不符合 AFDKO 语法规则。OpenType支持多换一的#tr[glyph]替换（比如#tr[ligature]），也支持一换多的#tr[glyph]替换（#tr[multiple substitution]），烦人的是它不支持多换多#tr[glyph]替换。关于这个问题下一章会详细介绍。

// However, there's another way to deal with this situation. We can tell the shaper to skip over diacritical marks in when applying this lookup.
不过还好，还有另一种处理方式。我们可以让#tr[shaper]在应用这个#tr[lookup]时跳过所有符号。

```fea
feature liga {
  lookup lamalef-ligature {
      lookupFlag IgnoreMarks;
      sub lam-ar alef-ar by lam_alef-ar;
  } lamalef-ligature;
} liga;
```

// Now when this lookup is applied, the shaper only "sees" the part of the glyph stream that contains base characters - `lam-ar alef-ar` - and the kasra glyph is "masked out". This allows the rule to apply.
现在，当应用这个#tr[lookup]时，#tr[shaper]只会关注#tr[glyph]流中的基本#tr[character]部分，也即 `lam-ar alef-ar`，而`kasra`#tr[glyph]会被掩藏。这样一来我们的规则就能被应用了。

// XXX image here.
// TODO：这里需要一张图

// How does the shaper know which are mark glyphs are which are not? We tell it! The `GDEF` table contains a number of *glyph definitions*, metadata about the properties of the glyphs in the font, and one of which is the glyph category. Each glyph can either be defined as a *base*, for an ordinary glyph; a *mark*, for a non-spacing glyph; a *ligature*, for glyphs which are formed from multiple base glyphs; or a *component*, which isn't used because nobody really knows what it's for. Glyphs which aren't explicitly in any category go into category zero, and never get ignored. The category definitions are normally set in your font editor, so if your `IgnoreMarks` lookups aren't working, check your categories in the font editor - in Glyphs, for example, you not only have to set the glyph to category `Mark` but also to subcategory `Nonspacing` for it to be placed in the mark category. You can also [specify the GDEF table](http://adobe-type-tools.github.io/afdko/OpenTypeFeatureFileSpecification.html#9.b) in feature code.
#tr[shaper]怎么知道哪些#tr[glyph]属于符号呢？答案是我们来告诉它！字体中有一个`GDEF`表，它包含了#tr[glyph]定义信息，它们是字体中#tr[glyph]的元数据。这些元数据中有一项就是#tr[glyph]所属的类别。#tr[glyph]可以属于以下分类之一：用于普通字形的基本类`base`；用于非空白#tr[glyph]的符号类`mark`；用于由多个基本#tr[glyph]组成的的#tr[ligature]类`ligature`；还有一个没人知道怎么使用的部件类`component`。没有明确指明属于哪一类的#tr[glyph]会被归属到第零类`zero`，它们没有办法被忽略。你通常可以在字体编辑器中设置这些分类，所以如果 `IgnoreMarks` 选项不起作用的话，你可以用编辑器打开字体，检查一下它的分类设置。比如我使用的 Glyphs，你不仅需要将#tr[glyph]放进`Mark`，还需要具体地放入它的下级`Nonspacing`子类，这样它们才会被放入字体的`mark`类。你也可以直接在特性代码中定义`GDEF`表@Adobe.AFDKO.Fea.9.b。

// Other flags you can apply to a lookup (and you can apply more than one) are:
#tr[lookup]上可以同时开启多个选项，包括：

/*
* `RightToLeft` (Only used for cursive attachment lookups in Nastaliq fonts. You almost certainly don't need this.)
* `IgnoreBaseGlyphs`
* `IgnoreLigatures`
* `IgnoreMarks`
* `MarkAttachmentType @class` (This has been effectively superceded by the next flag; you almost certainly don't need this.)
* `UseMarkFilteringSet @class`

`UseMarkFilteringSet` ignores all marks *except* those in the specified class. This will come in useful when you are, for example, repositioning glyphs with marks above them but you don't really care too much about marks below them.
*/
- `RightToLeft`：只用于波斯体#tr[cursive attachment]的#tr[lookup]，你基本上不需要用到它。
- `IgnoreBaseGlyphs`
- `IgnoreLigatures`
- `IgnoreMarks`
- `MarkAttachmentType @class`：因为有下面那个更高效的选项作为替代品，基本上也不需要使用这个。
- `UseMarkFilteringSet @class`：忽略除指定的 `@class` 类以外的其他所有符号。这在一些情况下很有用，比如你希望重新#tr[positioning]#tr[glyph]，但并不关心这些#tr[glyph]上带有的附加符号时。

// ## Positioning rules
== #tr[positioning]规则

// We've talked a lot about substitution so far, but that's not the only thing we can use OpenType rules for. You will have noticed that in our "paper tape" model of OpenType shaping, we had two rows on the tape - the top row was the glyph names. What's the bottom row?
到目前为止我们使用的都是#tr[substitution]规则，但其实OpenType中还有其他类型的规则可用。你可能已经注意到了，在我们之前使用打孔纸带类比OpenType文本#tr[shaping]过程，图中的“纸带”上有每个单元格有两行内容。上面一行是#tr[glyph]名，那下面一行是用来做什么的呢？

// After all the substitution rules in our set of chosen lookups are processed from the `GSUB` table, the same thing is done with the `GPOS` table: feature selections and language/script selections are used to gather a set of lookups, which are then processed in turn.
当按照之前描述的方式处理完`GSUB`表中所有被选中的#tr[lookup]后，相同的流程会在`GPOS`表中再发生一次。同样是根据特姓名和语言#tr[script]二元组过滤出需要的#tr[lookup]列表，然后依次处理。

// In the positioning phase, the shaper associates four numbers with each glyph position. These numbers - the X position, Y position, X advance and Y advance - are called a *value record*, and describe how to draw the string of glyphs.
在#tr[positioning]阶段，#tr[shaper]需要为每个#tr[glyph]生成四个数字。这四个分别是：X轴位置，Y轴位置，X轴#tr[advance]，Y 轴#tr[advance]。这组数字称为一条“数值记录”，它用于指导如何绘制这个#tr[glyph]。

// The shaper starts by taking the advance width from metrics of each glyph and placing that in the X advance section of the value record, and placing the advance height of each glyph into the Y advance section. (The X advance only applies in horizontal typesetting and the Y advance only applies in vertical typesetting.) As designer, we might think of the X advance as the width of the glyph, but when we come to OpenType programming, it's *much* better to think of this as "where to draw the *next* glyph".
#tr[shaper]首先从每个#tr[glyph]的#tr[metrics]中取出#tr[advance width]和#tr[advance height]，将它们分别放入数值记录的X轴#tr[advance]和Y轴#tr[advance]字段中。其中的X轴#tr[advance]只在#tr[horizontal typeset]时有用，Y轴#tr[advance]则是只用在#tr[vertical typeset]中。作为设计师，我们可能会将X轴#tr[advance]视为#tr[glyph]的宽度。但在进行OpenType特性编程时，你应该把这个概念理解为“从哪里开始绘制*下一个*#tr[glyph]”。

// Similarly the "position" should be thought of as "where this glyph gets shifted." Notice in this example how the `f` is first placed 1237 units after the `o` and then repositioning 100 units up and 100 units to the right of its default position:
类似的，“X轴#tr[position]”在这里要被理解为“这个#tr[glyph]在X轴上需要偏离其原始位置多远”。比如在@figure:f-positioning-example 所示的例子中，第一个`f`的原始位置是`o`之后的1237个单位处。但后续的重#tr[positioning]流程将其相对原始位置上移了 100 个单位，右移了 100 个单位。

#figure(
  caption: [对f的重#tr[positioning]],
)[#block(inset: 5em, stroke: 0.1em + gray)[原文缺图，待补]] <figure:f-positioning-example>

// In feature syntax, these value records are denoted as four numbers between angle brackets. As well as writing rules to *substitute* glyphs in the glyph stream, we can also write *positioning* rules to adjust these value records by adding a value to it. Let's write one now!
在 AFDKO 特性语法中，数值记录使用在尖括号内的四个数字来表达。就像我们可以编写规则来#tr[substitution]#tr[glyph]流中的某个#tr[glyph]那样，我们也可以编写带有数值记录的#tr[positioning]规则来对它们的#tr[position]进行调整。我们现在就来写一个试试。

```fea
feature kern {
    lookup adjust_f {
        pos f <0 0 200 0>;
    } adjust_f;
} kern;
```

// If you try this in `OTLFiddle` you'll find that this *adds* 200 units of advance positioning to the letter `f`, making it appear wider by shifting the *following* glyph to the right. Single positioning rules like this one adjust the existing positioning information by adding each component in the rule's value record to the corresponding component in the the value record in the glyph string.
如果在 `OTLFiddle` 中尝试这段代码，你将会看到 `f` 的#tr[advance]增加了 200 个单位，这导致其后的所有#tr[glyph]都向右移动了一些。像这样的#tr[positioning]规则，会将其规则中的数值记录的各个字段值，分别加到#tr[glyph]流中匹配的数值记录的相应字段上。

// This is a single positioning rule, which applies to *any* matching glyph in the glyph stream. This is not usually what we want - if we wanted to make the `f`s wider, we could have just given them a wider advance width in the editor. (However, single positioning rules do become useful when used in combination with chaining rules, which I promise we will get to soon.)
这是一个单#tr[glyph]的#tr[positioning]规则，他会应用到#tr[glyph]流中的*每个*匹配的#tr[glyph]上，这通常不是我们想要的效果。如果我们只是想让 `f` 宽一些，直接在字体编辑器中给他设置一个大一些的#tr[advance]值就行了，没必要使用特性。不过单#tr[glyph]的#tr[positioning]规则如果和#tr[chaining rules]结合使用的话，也可能变的很有用，我保证后面会尽快介绍这种用法。

// Another form of the positioning rule can take *two* input glyphs and add value records to one or both of them. Let's now see an example of a *pair positioning* rule where we will look for the glyphs `A B` in the glyph stream, and then change the positioning information of the `B`. I added the following stylistic set features to the test "A B" font from the previous chapter:
#tr[positioning]规则的另一种形式是可以提供*两个*#tr[glyph]，然后为它们或其中之一添加数值纪录。我们以一个会匹配#tr[glyph]流中的`A B`，并改变其中 `A` #tr[glyph]的#tr[positioning]信息的字偶#tr[positioning]规则为例来介绍它。我向上一章中的示例字体中添加了四个样式集来测试这种规则：

```fea
feature ss01 { pos A B <150 0 0 0>; } ss01 ;
feature ss02 { pos A B <0 150 0 0>; } ss02 ;
feature ss03 { pos A B <0 0 150 0>; } ss03 ;
feature ss04 { pos A B <0 0 0 150>; } ss04 ;
```

// And now let's see what effect each of these features has:
我们来看看这些特性分别产生什么效果：

#include "value-records.typ"

// From this it's easy to see that the first two numbers in the value record simply shift where the glyph is drawn, with no impact on what follows. Imagine the glyph "A" positioned as normal, but then after the surrounding layout has been done, the glyph is picked up and moved up or to the right.
通过实际效果，很容易看出数值记录中的前两个数字控制绘制这个#tr[glyph]时的位置偏移量，而不影响后续的#tr[glyph]。这可以想象为，先在原位置正常画出了`A`#tr[glyph]，再把它往上或往右移动了一些。

// The third example, which we know as kerning, makes the glyph conceptually wider. The advance of the "A" is extended by 150 units, increasing its right sidebearing; changing the advance *does* affect the positioning of the glyphs which follow it.
第三个例子是让整个#tr[glyph]变得更宽了，这其实就是我们之前说的#tr[kern]。`A`#tr[glyph]的#tr[advance]增加了150个单位，也就增加了它的右#tr[sidebearing]。改变#tr[advance]会影响后续所有#tr[glyph]的#tr[position]。

// Finally, you should be able to see that the fourth example, changing the vertical advance, does absolutely nothing. You might have hoped that it would change the position of the baseline for the following glyphs, and for some scripts that might be quite a nice feature to have, but the sad fact of the matter is that applications doing horizontal layout don't take any notice of the font's vertical advances (and vice versa) and just assume that the baseline is constant. Oh well, it was worth a try.
最后，从第四个例子看出，改变#tr[vertical advance]没有任何影响。你可能期望它会改变后续#tr[glyph]的#tr[baseline]位置，实际上这对某些#tr[scripts]来说确实是个很好的功能，但可惜的是目前进行#tr[horizontal typeset]的应用软件根本不关心字体的#tr[vertical advance]（同样，进行#tr[vertical typeset]的也不关心#tr[horizontal advance]），它们将#tr[baseline]都视为恒定常量。但不管怎样，尝试一下还是值得的。

// To make this more globally relevant, let's look at the Devanagari glyph sequence "NA UUE LLA UUE DA UUE" (नॗ ळॗ दॗ) in Noto Sans Devangari:
为了让本书更加全球化，我们看看Noto Sans Devangari字体下的天城文#tr[glyph]序列 `NA UUE LLA UUE DA UUE`：

#figure(placement: none, block(inset: (bottom: 50pt))[
  #devanagari[#text(size: 128pt)[नॗ ळॗ दॗ]]
])

// You should be able to see that in the first two combinations ("NA UUE" and "LLA UUE"), the vowel sign UUE appears at the same depth; regardless of how far below the headline the base character reaches, the vowel sign is being positioned at a fixed distance below the headline. (So we're not using mark to base and anchors here, for those of you who have read ahead.)
可以看到，对于前两个单元（`NA UUE` 和 `LLA UUE`），基本#tr[glyph]的底部到#tr[headline]的距离不同，但元音符号 `UUE` 所处的深度是相同的。（所以这里没有使用锚点，如果你喜欢跳着读书的话就能理解我在说啥。）

// However, if we attached the vowel sign to the "DA" at that same fixed position, it would collide with the DA's curly tail. So in a DA+UUE sequence, we have to do a bit of *vertical* kerning: we need to move the vowel sign down a bit when it's been applied to a long descender.
但当这个元音符号需要加到`DA`上时，如果还使用这个固定的深度位置，就会和`DA`的卷曲尾巴相撞了。所以在类似 `DA` + `UUE` 的组合中，我们需要调整竖直方向的#tr[kern]，也就是让元音符号向下移一点。

// Here's the code to do that (which I've simplified to make it more readable):
以下是字体中完成这个功能的代码（我进行了简化，使其更可读一些）：

```fea
@longdescenders = [
  uni091D # JHA
  uni0926 # DA
  # 和一些带有 rakar 的连字
  uni0916_uni094D_uni0930.rkrf uni091D_uni094D_uni0930.rkrf
  uni0926_uni094D_uni0930.rkrf
];
feature dist {
  script dev2;
  language dflt;
  pos @longdescenders <0 0 0 0> uni0956 <0 -90 0 0>;
  pos @longdescenders <0 0 0 0> uni0957 <0 -145 0 0>;
}
```

// What are we doing here? Let's read it out from the top. First, we define a glyph class for those glyphs with long descenders. Next, we are putting our rules into a feature called `dist`, which is a little like `kern` but for adjusting the distances between pre- and post-base marks and their base characters. The rules will apply to the script "Devanagari v.2". (This is another one of those famous OpenType compromises; Microsoft's old Indic shaper used the script tag `deva` for Devanagari, but when they came out with a new shaper, the way to select the new behavior was to use a new language tag, `dev2`. Nowadays you almost certainly want the "version 2" behaviour for any Indic scripts you engineer.)
这段代码做了什么呢？我们从上往下一点点看。首先我们为#tr[decender]较长的#tr[glyph]定义了一个#tr[glyph class]。然后我们在`dist`特性中编写了一些规则，这个特性和`kern`有些类似，但作用是调整基本#tr[glyph]和作用在其前后的符号这两者的位置关系。这些规则会在输入“Devanagari v.2”#tr[script]时生效。（这是OpenType中另一个著名的妥协：因为微软的古早印度系#tr[scripts]#tr[shaper]使用`deva`作为天城文的标签，当新的#tr[shaper]希望用一种新的方式实现时就需要一个新的标签`dev2`。而如今，无论是为哪种印度系#tr[script]开发字体，都几乎一定是会使用“第二版”#tr[shaper]的行为。）

// For any language system using this script, we apply the following rules: when we have a long descender and a UE vowel, the consonant is positioned normally (`0`), but the vowel sign gets its position shifted by 90 units downwards. When we have a long descender and a UUE vowel, the consonant is again positioned normally, but the vowel sign gets its position shifted by 145 units downwards. That should be enough to avoid the collision.
对于使用这种#tr[script]的所有语言，都应用如下规则：当一个长#tr[decender]#tr[glyph]后面跟着元音`UE`时，辅音都按常规方式#tr[positioning]（数值记录为四个`0`），但元音需要往下移90单位。当长#tr[decender]#tr[glyph]后面跟着元音`UEE`时，辅音依旧位于常规#tr[position]，元音则向下移动145单位。这应该足够避免碰撞了。

// In the next chapter we will look at the full range of substitution and positioning rules, as well as chain and attachment rules.
在下一章中，我们会完整介绍#tr[substitution]和#tr[positioning]规则的各种形式以及#tr[chaining rules]和#tr[attachment rules]。

// ## Building a testing environment
== 构造测试环境

// XXX
// 增加内容，当前原文缺

// ### Using hb-shape for feature testing
=== 使用 hb-shape 进行特性测试

// Now is a good time to introduce the `hb-shape` tool; it's a very handy utility for debugging and testing the application of OpenType features - how they affect the glyph stream, their effect on positioning, how they apply in different language and script combinations, and how they interact with each other. Learning to use `hb-shape`, which comes as part of the [HarfBuzz](http://harfbuzz.org) OpenType shaping engine, will help you with a host of OpenType-related problems.
现在是介绍 `hb-shape` 工具的好时机。这是一个非常实用的OpenType特性调试和测试工具。通过它你能看到特性如何改变#tr[glyph]流，影响#tr[glyph]的位置，在不同的语言#tr[script]环境下的不同效果，以及如何互相影响等。`hb-shape` 工具是OpenType#tr[shaping]引擎HarfBuzz @Unknown.HarfBuzz 中的一部分，它在你遇到有关OpenType的各种问题时都能帮助你。

#note[
  // > If you're on Mac OS X, you can install the Harfbuzz utilities using homebrew, by calling `brew install harfbuzz` on the terminal.
  如果你使用 Mac OS X，你可以通过 Homebrew 安装 HarfBuzz，只需在终端中执行：#linebreak()`brew install harfbuzz`。
]

// As we've mentioned, HarfBuzz is a shaping engine, typically used by layout applications. Shaping, as we know, is the process of taking a text, a font, and some parameters and producing a set of glyphs and their positions. `hb-shape` is a diagnostic tool which runs the shaping process for us and formats the output of the process in a number of different ways. We can use it to check the kern that we added in the previous section:
HarfBuzz是#tr[shaping]引擎，常被需要进行文本#tr[layout]的应用使用。而#tr[shaping]的过程是输入文本、字体和一些其他参数，得到一系列#tr[glyph]和它们的位置的过程。`hb-shape`是一个会执行这一过程，然后将结果用不同的格式输出的诊断工具。我们可以用它来检查之前为测试字体添加的#tr[kern]：

```bash
$ hb-shape TTXTest-Regular.otf 'AA'
[A=0+580|A=1+580]
```

// This tells us that we have two "A" glyphs together. The first one is the first character in the input stream ("=0" - computer strings count from zero), and that it has a horizontal advance of 580 units ("+580"). The second one is the second character in the input stream ("=1") and also has an advance of 580 units.
这告诉我们，输出是两个`A`#tr[glyph]。其中第一个`A`来自输入文本中的第一个（输出中的`=0`表示第一个，因为计算机就是从0开始数数的）#tr[character]，它拥有580单位的#tr[horizontal advance]。第二个`A`是输入文本中的第二个（`=1`）#tr[character]，也是580单位的#tr[horizontal advance]。

// But...
但是……

```bash
$ hb-shape TTXTest-Regular.otf 'AB'
[A=0+530|B=1+618]
```

// when we have an "A" and a "B", the advance width of the "A" is only 530 units. In other words, the "B" is positioned 50 units left of where it would normally be placed; the "A" has, effectively, got 50 units narrower. In other other words, our kern worked.
当我们输入`AB`时，`A`的#tr[horizontal advance]变成了530。换句话说，也就是`B`会相对其常规位置向左移动50单位。也可以看作`A`变窄了50单位。我们的#tr[kern]成功生效了。

// We didn't need to tell HarfBuzz to do any kerning - the `kern` feature is on by default. We can explicitly turn it off by passing the `--features` option to `hb-shape`. `-<feature name>` turns off a feature and `+<feature name>` turns it on:
我们不用明确告诉HarfBuzz启用#tr[kern]功能，因为`kern`特性默认就是开启的。我们可以通过向 `--features` 选项来让`hb-shape` 开关某种特性。使用 #text(ligatures: false)[`-<特姓名>`] 可以关闭一个特性，`+<特姓名>` 则可以开启。

```bash
$ hb-shape --features="-kern" TTXTest-Regular.otf 'AB'
[A=0+580|B=1+618]
```

// As you see in this case, the advance width of the "A" is back to 580 units, because the `ab` kern pair is not being applied in this case.
当关闭`kern`特性后，因为AB间的#tr[kern]不再生效，`A`#tr[glyph]的#tr[advance]就又回到了580单位。

#note[
  // > We will see more of `hb-shape` in the next chapter, including examples of how it shows us positioning information.
  下一章我们会更多地使用`hb-shape`，也会有一些用它来显示其他#tr[positioning]信息的例子。
]

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
现在我们终于找到感兴趣的那个#tr[lookup]了，在默认语言#tr[script]的环境下打开`liga`特性最终会使用`lookup table 1`。而这个结构中又包含了一个“子表格”的列表。从这开始，规则就根据它们所属的类型进行分组了，我们这种#tr[ligature]#tr[substitution]属于`type 4`。（有关规则的各种类型，可参考后文@section:substitution-rule-types 和@section:positioning-rule-types。）

// The actual substitutions are then grouped by their *coverage*, which is another important way of making the process efficient. The shaper has, by this stage, gathered the features that are relevant to a piece of text, and now needs to decide which rules to apply to the incoming text stream. The coverage of each rule tells the shaper whether or not it's likely to be relevant by giving it the first glyph ID in the ligature set. If the shaper sees anything other than the letter "f", then we know for sure that our rules are not going to apply, so it can pass over this set of ligatures and look at the next subtable. A coverage table comes in two formats: it can either specify a *list* of glyphs, as we have here (albeit a list with only one glyph in it), or a *range* of IDs.
实际的#tr[substitution]规则根据它们的对参数的覆盖性来分组，这是让处理过程更加高效的一个重要手段。#tr[shaper]在这个阶段已经知道了有哪些特性和输入文本有关，下一步是要决定在文本上具体使用哪些规则。所谓覆盖性，就是通过只看#tr[ligature]中的第一个#tr[glyph]，#tr[shaper]就能排除掉所有和当前位置无关的规则。比如只要#tr[shaper]看到第一个输入的#tr[glyph]不是`f`，它就能够确定我们当前这条规则肯定无需应用，可以直接去处理下一个“子表格”。覆盖性表格可能有两种格式：第一种就是我们这里展示的，它直接声明一些#tr[glyph]；第二种是声明一个#tr[glyph]范围。

// OK, we're nearly there. We've found the feature we want. We are running through its list of lookups, and for each lookup, we're running through the lookup subtables. We've found the subtable that applies to the letter "f", and this leads us to two more tables, which are the actual rules for what to do when we see an "f". We look ahead into the text stream and if the next input glyph (which the OpenType specification unhelpfully calls "component", even though that also means something completely different in the font world...) is the letter "i" (glyph ID 256), then the first ligature substitution applies. We substitute that pair of glyphs - the start glyph from the coverage list and the component - by the single glyph ID 382 ("fi"). If instead the next two input glyphs have IDs 247 and 256 ("f i") then we replace the three glyphs - the start glyph from the coverage list and both components - with the single glyph ID 380, or "ffi". That is how a ligature substitution feature works.
很好，就快接近终点了。我们找到了想要的特性，得到了它所有的#tr[lookup]。对于每个#tr[lookup]，都逐个处理它的“子表格”。接着我们找到了可能影响由字母`f`开头的文本的那个“子表格”，它又给了我们两个表，也就是当看到`f`时真正需要处理的规则。然后#tr[shaper]就会向前看下一个#tr[glyph]，如果这个#tr[glyph]（OpenType非常捣乱的把它叫做“部件”，但这个词在字体设计领域中又有另一个完全不同含义……）是字母`i`（也就是ID为256的#tr[glyph]），那么第一条#tr[substitution]规则就被应用了。我们把覆盖性表格中的起始#tr[glyph]和“部件”们整体替换成ID为382的#tr[glyph]`fi`。如果后两个#tr[glyph]是ID为247的`f`和ID为256的`i`，就把加上起始#tr[glyph]的这三个#tr[glyph]整体替换成ID为380的`ffi`。这就是#tr[ligature]#tr[substitution]特性的工作过程。

// If you think that's an awful lot of effort to go to just to change the letters "f i" into "fi" then, well, you'd be right. It took, what, 11 table lookups? But remember that the GPOS and GSUB tables are extremely powerful and extremely flexible, and that power and flexibility comes at a cost. To represent all these lookups, features, languages and scripts efficiently inside a font means that there has to be a lot going on under the hood.
如果你觉得这对于把`f i`换成`fi`这种小事来说工作量有点太大了，那么你说对了，毕竟这个过程中进行了11次的表格跳转。但要记住，因为 `GPOS` 和 `GSUB` 表的功能十分强大，而且有很强的灵活性，而这两者都是有代价的。为了能够在字体中高效的表示#tr[lookup]、特性、语言、#tr[script]这些所有概念，我们必须在这种看不见的地方为之努力。

// Thankfully, unless you're implementing some of these shaping or font editing technologies yourself, you can relax - it mostly all just works.
幸运的是，除非你是在自己编写字体编辑软件或#tr[shaper]，不然日常生活还是能保持轻松的。这些技术基本上都工作得很好。

// ## Decompiling a font
== 反编译字体文件

// We talked near the start of the chapter about how we could take our textual feature rules and compile them into a font. What about going the other way? Sometimes it's useful, when examining how other people have solved particular layout problems, to turn a font back into a set of layout instructions. There are a variety of ways we can do this.
我们在本章开头处介绍了如何将文本格式的特性代码编译到字体中。那反过来能行吗？这会很有用，比如有时我们会想通过将字体变回#tr[layout]指令，来了解别人是如何解决某个特定的#tr[layout]问题的。有几种方式可以做到这一点。

// One is a script using the FontTools library we mentioned in the previous chapter to decompile the `GPOS` and `GSUB` tables back into feature language such as Lasse Fisker's [ft2fea](https://github.com/Tarobish/Mirza/blob/gh-pages/Tools/ftSnippets/ft2fea.py). My own script is called `otf2fea`, and can be installed by installing the `fontFeatures` Python library (`pip install fontFeatures`).
其中一种是基于我们上一章提到的 `fontTools` 程序库的脚本，比如Lasse Fisker编写的`ft2fea`@Fisker.MirzaFt2fea。我自己也有一个脚本叫`otf2fea`，它可以通过`fontFeatures`这个Python包进行安装。（`pip install fontFeatures`）

// XXX But while these worked nicely for more complex font files, neither of them worked on our simple test font, so instead, I went with the absolute easiest way - when exporting a file, Glyphs writes out a feature file and passes it to AFDKO to compile the features. Thankfully, it leaves these files sitting around afterwards, and so in `Library/Application Support/Glyphs/Temp/TTXTest-Regular/features.fea`, I find the following:
但是，虽然这些脚本对于很复杂的字体都工作的很好，但它们都无法处理我们这个简单的测试用字体。所以我就换了一个绝对是最简单的方式。当 Glyphs 导出字体文件时，它会先生成一份特性代码文件，然后使用 `AFDKO` 工具编译。而且幸运的是，编译完成后这些文件会被留下，路径是`Library/Application Support/Glyphs/Temp/TTXTest-Regular/features.fea`。下面是它的内容：

```fea
table OS/2 {
  TypoAscender 800;
  TypoDescender -200;
  TypoLineGap 200;
  winAscent 1000;
  winDescent 200;
  WeightClass 400;
  WidthClass 5;
  WidthClass 5;
  FSType 8;
  XHeight 500;
  CapHeight 700;
} OS/2;
# ...
```

// Oh, it turns out that as well as specifying `GPOS` and `GSUB` features, the feature file is also used by font editors to get metrics and other information into the OpenType tables. But let's look down at the bottom of the file:
哦，原来除了往`GPOS`和`GSUB`表里添加特性，这个文件还被字体编辑器用来想字体里添加#tr[metrics]和其他信息。我们继续看这个文件最末尾的部分：

```fea
feature kern {
  lookup kern1_latin {
    lookupflag IgnoreMarks;
    pos A B -50;
  } kern1_latin;
} kern;
```

// And here it is - our `kern` feature. This is precisely equivalent to the horrible piece of XML above.
看，这就是我们的`kern`特性。这和我们之前展示的那一大堆可怕的 XML 完全等价。
