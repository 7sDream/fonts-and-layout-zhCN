#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

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
