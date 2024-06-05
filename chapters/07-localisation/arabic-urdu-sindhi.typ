#import "/template/template.typ": web-page-template
#import "/template/components.typ": note
#import "/template/lang.typ": arabic, arabic-amiri

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## Arabic, Urdu and Sindhi
== 阿拉伯语、乌尔都语、信德语

// In the various languages which make use of the Arabic script, there are sometimes locally expected variations of the glyph set - for instance, we mentioned the variant numbers four, five and seven in Urdu. The expected form of the letter heh differs in Urdu, Sindhi, Parkari and Kurdish. In Persian, a language-specific form of kaf (ک, U+06A9 ARABIC LETTER KEHEH) is preferred over the usual form of kaf (ك, U+0643 ARABIC LETTER KAF). All of these substitutions can be made using the language-specific `locl` feature trick we saw above.
在使用阿拉伯字母的各种语言中，有时会根据当地习惯采用不同的字形集合。我们之前提到过，在乌尔都语中数字`4`、`5`、`7`会产生变化。而乌尔都语、信德语、帕卡利语/*#footnote[译注：原文为Pakari，疑似为笔误。这里拙校为Parkari，为印度-雅利安语支下的一门语言，主要在巴基斯坦的信德省的塔帕卡和纳加派克县使用，详见其#link("https://en.wikipedia.org/wiki/Parkari_Koli_language", in-footnote: true)[维基百科]。此处参考一份#link("https://www.gcedclearinghouse.org/sites/default/files/resources/190162chi.pdf", in-footnote: true)[SIL文档的中译本]译作“帕卡利语”。]*/、库尔德语对于字母`heh`也有不同的写法。字母 `kaf U+0643 ARABIC LETTER KAF`（#arabic[ك]）在波斯语中也有一个专属样式，会写成 `U+06A9 ARABIC LETTER KEHEH`（#arabic[ک]）。所有这种类型的#tr[substitution]需求都可以使用我们上面介绍的`locl`特性中的技巧来实现。

#note[
  // > "How do I know all this stuff?" Well, part of good type design is doing your research: looking into exemplars and documents showing local expectations, testing your designs with native readers, and so on. But there's also a growing number of people collating and documenting this kind of language-specific information. As we've mentioned, the Unicode Standard, and the original script encoding proposals for Unicode, give some background information on how the script works. I've also added a list of resources to the end of this chapter which collects some of the best sources for type design information.
  “我从哪能学到这些知识呢？”想做出好的设计，就得花一部分时间在研究上。比如广泛阅读当地文本，通过各种需求文档了解他们的期望，让母语读者参与测试你的设计等。现在也有越来越多的人在收集整理这种关于特定语言的文档和信息。比如Unicode标准，以及希望Unicode编码某种#tr[script]的原始提案，都会包含一些关于此#tr[scripts]的工作方式的背景信息。在本章末尾我也提供了一个在设计字体时的优秀参考资料列表。
]

#note[
  // > One of those resources is Jonathan Kew's notes on variant Arabic characters in different scripts. He mentions there that some Persian documents may encode kaf with using U+0643, so fonts supporting Persian *may* wish to substitute kaf with the "keheh" form; other documents, however, might use U+06A9 to represent Persian kaf but retain the use of U+0643 to deliberately refer to the standard Arabic kaf - in which case you may *not* want to make that glyph substitution. Think about your intended audience when substituting encoded characters.
  参考资料中有一项是Jonathan Kew写的关于阿拉伯#tr[character]在不同#tr[scripts]中产生的变化的笔记。他提到，有些波兰语的文档会使用`U+0643`来#tr[encoding]`kaf`字母。所以支持波兰语的字体*可能*会想把`kaf`#tr[substitution]为`keheh`的样子。但也有一些文档使用`U+06A9`来表示波兰版的`kaf`，从而刻意的使`U+0643`只用于代表标准的阿拉伯字母`kaf`。这样的话就又不希望进行#tr[glyph]#tr[substitution]了。所以在实际#tr[substitution]#tr[character]前，要想想你的目标受众到底是哪些群体。
]

// Arabic fonts additionally vary depending on their adherence to calligraphic tradition. When connecting letters together into word forms, calligraphers will use a wide variety of ligatures, substitutions, and adjustments to positioning to create a natural and pleasing effect, and Arabic fonts will reflect this "fluidity" to a greater of lesser degree. As you consider the appropriate ways of writing different pairs of letters together, the more ligature forms you envision for your font, the more complex you can expect the feature processing to be.
阿拉伯字体还会因为它们对书法传统的坚持程度不同而产生差异。当字母组合成单词时，偏爱书法形式的设计师将会大量使用#tr[ligature]、#tr[substitution]、#tr[position]调整等手段来制作自然流畅的书法效果。阿拉伯字体或多或少都会有一些这种“流动性”。你越希望不同的字母对能适当的组合在一起，往字体里塞的#tr[ligature]越多，你的字体特性代码就会越复杂和难以处理。

// One important trick in Arabic feature programming is to make heavy use of chaining contextual substitutions instead of ligatures. Let's consider the word كِلَا (kilā, "both"). A simple rendering of this word, without any calligraphic substitutions, might look like this: (Glyphs from Khaled Hosny's *Amiri*.)
为阿拉伯字体进行特性设计时，一个重要的技巧是少用#tr[ligature]，多用#tr[chaining]#tr[contextual]#tr[substitution]。考虑这个单词 #arabic[كِلَا]（kilā，表示“都”的意思）。不使用任何书法风格时，它看上去应该是这样的（这里使用Khaled Honsny设计的Amiri字体中的#tr[glyph]）：

#let raw-amiri = body => arabic-amiri(text(features: ("calt": 0), body))

#figure(
  placement: none,
)[#block(inset: (y: 2em))[
  #text(size: 5em)[#raw-amiri[كِلَا]]
]]

// Running
使用命令：

#[
#show regex(`\p{scx=Arabic}+`.text): raw-amiri

```bash
$ hb-hape --features='-calt' Amiri-Regular.ttf كِلَا
[uni0627.fina=4+229|uni064E=2@-208,0+0|uni0644.medi=2+197|uni0650=0@8,0+0|uni0643.init=0+659]
```
]

// confirms that no contextual shaping beyond the conversion into initial, medial and final forms is going on:
可以确定除了让#tr[character]采用正确的词首词中词尾形式外，#tr[shaper]没有进行其他操作。

// Obviously this is unacceptable. There are two ways we can improve this rendering. The first is the obvious substitution of the final lam-alif with the lam-alif ligature, like so:
// But the second, looking at the start of the word, is to form a kaf-lam ligature:
很明显这个显示效果不太好，我们可以用两种方式提升它。可以选择将词尾的`lam-alif`替换为#tr[ligature]形式（左图）。但是，如果我们关注词首，会发现它也可以形成一个`kaf-lam`#tr[ligature]（右图）。

#figure(
  placement: none,
)[#grid(
  columns: 2,
  column-gutter: 10%,
  [#image("kila-2.png", height: 7em)],
  [#image("kila-3.png", height: 7em)]
)]

// Ah, but... what if we want to do both? If we use ligature substitutions like so:
啊哈！但是，我们不能全都要吗？如果使用#tr[ligature]#tr[substitution]的话：

```fea
feature calt {
  lookupflag IgnoreMarks;
  sub kaf-ar.init lam-ar.medi by kaf-lam.init; # 1
  sub lam-ar.medi alef-ar.fina by lam-alef.fina; # 2
} calt;
```

// what is going to happen? The shaper will work through the string, seeing the glyphs ` kaf-ar.init lam-ar.medi alef-ar.fina`. It sees the first pair of glyphs, and applies Rule 1 above, meaning that the new string is `kaf-lam.init alef-ar.fina`. It tries to match any rule against this new string, but nothing matches.
这样结果会是什么呢？#tr[shaper]将会遍历输入的字符串，处理`kaf-ar.init lam-ar.medi alef-ar.fina`这个#tr[glyph]序列。他会先看到第一对#tr[glyph]，然后应用上面的第一条规则。现在序列就变成了`kaf-lam.init alef-ar.fina`。它尝试在新序列上应用规则，但没有规则能匹配上。

// Let's now rewrite this feature using chained contextual substitutions and glyph classes. Instead of creating a lam-alef ligature and a kaf-lam ligature, we split each ligature into two "marked" glyphs. Let's first do this for the lam-alef ligature. We design two glyphs, `alef-ar.fina.aleflam` and `lam-ar.medi.aleflam`, which look like this:
现在我们用#tr[chaining]#tr[contextual]#tr[substitution]和#tr[glyph]类来重写这个特性。我们不直接生成`lam-alef`和`kaf-lam`#tr[ligature]，而是使用“标记”#tr[glyph]来分别代表它们。首先来处理`lam-alef`。我们设计两个#tr[glyph]，`alef-ar.fina.aleflam` 和 `lam-ar.medi.aleflam`，见@figure:alef-lam。

#figure(
  caption: []
)[#image("alef-lam.png", width: 60%)] <figure:alef-lam>

// and then we substitute each glyph by its related "half-ligature":
然后我们将每个#tr[glyph]都#tr[substitution]为对应的“半#tr[ligature]”形式：

```fea
lookup LamAlef {
  sub lam-ar.medi by lam-ar.medi.aleflam;
  sub alef-ar.fina by alef-ar.fina.aleflam;
} LamAlef;

feature calt {
  lookupflag IgnoreMarks;
  sub lam-ar.medi' lookup LamAlef  alef-ar.fina' lookup LamAlef;
}
```

// Finally, we create our variant kaf, which we call `kaf-ar.init.lamkaf`, and now we can apply the kaf-lam substitution:
最后，设计一个`kaf`的变体`kaf-ar.init.lamkaf`，并编写`kaf-lam`的#tr[ligature]#tr[substitution]：

```fea
feature calt {
  lookupflag IgnoreMarks;
  sub kaf-ar.init' lam.medi by kaf-ar.init.lamkaf; # 1
  sub lam-ar.medi' lookup LamAlef alef-ar.fina' lookup LamAlef; # 2
}
```

// Now when the shaper sees kaf lam alef, what happens? Kaf and lam match rule 1, which substitutes the kaf for its special initial form. Next, lam alef matches rule 2, which chains into the "LamAlef" lookup; this converts the first glyph to  `lam-ar.medi.aleflam` and the second to `alef-ar.fina.aleflam`.
现在，如果#tr[shaper]看到`kaf lam alef`会是什么情况。首先`kam`和`lam`匹配规则1，这将`kaf`转变为我们设计的特殊形式`kaf-ar.init.lamkaf`。然后`lam`和`alef`匹配规则2，通过#tr[chaining]应用`LamAlef`，它将`lam`变成`lam-ar.medi.aleflam`，`alef`变成`alef-ar.fina.aleflam`。

// It's a little more convoluted, but this way we have a substitution arrangement that works not just by ligating a pair at a time, but which allows us to *continue* transforming glyphs across the string: alef-lam works, as does lam-kaf, but they also both work together.
虽然这个过程比较复杂，但通过这种组织方式，我们对#tr[substitution]可以有更加精细的控制权。现在我们不仅能将一对#tr[glyph]组合成它们的#tr[ligature]形式，而且可以在整个输入字符串中*持续*地进行#tr[glyph]转换：`alef-lam`#tr[ligature]正常形成，`lam-kaf`#tr[ligature]也可以正常形成，而且它们俩甚至可以同时出现。

#figure(
  placement: none,
)[#block(inset: (top: 1em, bottom: 2.5em))[
  #text(size: 5em)[#arabic-amiri[كِلَا]]
]]
