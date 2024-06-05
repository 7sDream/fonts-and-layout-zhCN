#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

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
feature name { ... } name;
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

