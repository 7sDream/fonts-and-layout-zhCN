#import "/template/heading.typ": chapter

#import "/lib/glossary.typ": tr
#import "/template/components.typ": note, title-ref
#import "/template/lang.typ": arabic, arabic-amiri, balinese, devanagari, hind, sharada, taitham, telugu

#chapter[
  // OpenType for Global Scripts
  服务#tr[global scripts]的OpenType
]

// In the last chapter, we looked at OpenType features from the perspective of technology: what cool things can we make the font do? In this chapter, however, we're going to look from the perspective of language: how do we make the font support the kind of language features we need? We'll be putting together the substitution and positioning lookups from OpenType Layout that we learnt about in the previous chapter, and using them to create fonts which behave correctly and beautifully for the needs of different scripts and language systems.
上一章中，我们在分析各种OpenType特性时采用的是技术视角，也就是利用它们能做到哪些事。本章我们则会站在各种语言的角度，来看看它如何完成特定语言中的具体需求。通过结合之前学习的#tr[substitution]和#tr[positioning]#tr[lookup]，我们要为不同的语言#tr[script]系统创建既正确又漂亮的字体。

// ## Features in Practice
== 特性实践

// Up to this point, I have very confidently told you which features you need to use to achieve certain goals - for example, I said things like "We'll put a contextual rule in the `akhn` feature to make the Kssa conjunct." But when it comes to creating your own fonts, you're going to have to make decisions yourself about where to place your rules and lookups and what features you need to implement. Obviously a good guideline is to look around and copy what other people have done; the growing number of libre fonts on GitHub make it a very helpful source of examples for those learning to program fonts.
此前，每次我都会非常直接的告诉你需要用哪些特性来完成设计目标。比如我会说，我们可以在`akhn`特性中添加#tr[contextual]规则来构建不可分的`kssa`合体#tr[glyph]。但当实际制作字体时，你需要自己决定把规则和#tr[lookup]放在哪个特性里。当然，看看别人是怎么做的并复制过来也是不错的参考。现在GitHub上有越来越多的自由字体，它们对于学习字体程序设计来说是非常有帮助的示例资源。

// But while copying others is a good way to get started, it's also helpful to reason for oneself about what your font ought to do. There are two parts to being able to do this. The first is a general understanding of the OpenType Layout process and how the shaper operates, and by now you should have some awareness of this. The second is a careful look at the [feature tags list](https://docs.microsoft.com/en-us/typography/opentype/spec/featuretags) of the OpenType specification to see if any of them seem to fit what we're doing.
虽然复制别人的代码是入门的好方法，但亲自思考字体应该怎样实现某一功能也很有帮助。这可以分成两步来进行。首先要对OpenType的#tr[layout]流程有基本的理解，这方面你应该已经有些认识了。第二是仔细阅读OpenType规范中的特性列表@Microsoft.OpenTypeRegistered，分析其中哪些比较适合当前想完成的目标。

#note[
  // > Don't get *too* stressed out about choosing the right feature for your rules. If you put the rule in a strange feature but your font behaves in the way that you want it to, that's good enough; there is no OpenType Police who will tell you off for violating the specification. Heck, you can put substitution rules in the `kern` feature if you like, and people might look at you funny but it'll probably work fine. The only time this gets critical is when we are talking about
  对于选择正确的特性这件事压力不用太大。如果你最后把规则放到了一个不常用的特性里，但字体的显示行为符合你的预期，那这样就挺好。不会有OpenType警察出来说你违反了规范之类的。你可以把#tr[substitution]规则放到`kern`特性里，但除了人们会觉得有些幽默之外，它应该也能正常工作。只有在下面两种情况下，对于特性的选择才会特别关键：

  #set enum(numbering: "a)")
  // (a) features which are selected by the user interface of the application doing the layout (for example, the `smcp` feature is usually turned on when the user asks for small caps, and it would be bizarre - and arguably *wrong* - if this also turned on additional ligatures)
  + 特性是由排版软件的UI来决定是否开启的。比如`smcp`特性是当用户要求小型大写字母时启用的。如果你在这个特性中还添加了#tr[ligature]功能的话，用户就会觉得非常奇怪了，甚至说可以说是*错误的*。
  // and (b) more complex fonts with a large number of rules which need to be processed in a specific order. Getting things in the right place in the processing chain will increase the chances of your font behaving in the way you expect it to, and, more importantly, will reduce the chances of features interacting with each other in unexpected ways.
  + 当你的字体特别复杂，有大量的需要按特定顺序处理的特性。让操作都在处理过程中的正确时机发生能够增加字体按预想方式工作的几率。更重要的是，这也会减少特性以预期外的方式互相影响的几率。
]

// Let's suppose we are implementing a font for the Takri script of north-west India. There's no Script Development Standard for Takri, so we're on our own. We've designed our glyphs, but we've found a problem. When a consonant has an i-matra and an anusvara, we'd like to move the anusvara closer to the matra. So instead of:
假设我们正在为印度东北部的塔克里文设计字体。当前这种#tr[script]并没有开发规范可以参考，所以我们只能自力更生了。假设我们已经设计好了基本的#tr[glyph]，但发现有一个问题：当辅音上有`i-matra`和`anusvara`时，我们希望`anusvara`能和`matra`离得近一点。参考@figure:takri-problem。

// We've designed a new glyph `iMatra_anusvara` which contains both the matra and the correctly-positioned anusvara, and we've written a chained contextual substitution rule:
我们为此设计了一个新#tr[glyph]`iMatra_anusvara`，它包含`matra`和重新放置在了正确位置的`anusvara`。同时还编写了一个#tr[chaining]#tr[contextual]#tr[substitution]规则：

#figure(
  caption: [塔克里文字体中需要解决的一个问题]
)[#include "takri.typ"] <figure:takri-problem>

```fea
lookup iMatraAnusVara {
  sub iMatra by iMatra_anusvara;
  sub anusvara by emptyGlyph;
}

sub iMatra' lookup iMatraAnusVara @consonant' anusvara' lookup iMatraAnusVara;
```

// This replaces the matra with our matra-plus-anusvara form, and replaces the old anusvara with an empty glyph. Nice. But what feature does it belong in?
这段代码会将`matra`替换为我们新设计的`matra+anusvara`，然后将原本的`anusvara`替换为空#tr[glyph]。这看上去应该可以完成我们的目标。不过，这些代码应该写在哪个特性中呢？

// First, we decide what broad category this rule should belong to. Are we rewriting the mapping between characters and glyphs? Not really. So this doesn't go in the initial "pre-shaping" feature collection. It's something that should go towards the end of the processing chain. But it's also a substitution rule rather than a positioning rule, so it should go in the substitution part of the processing chain. It's somewhere in the middle.
首先我们先确定这些规则所处的大分类。这是在重写#tr[character]和#tr[glyph]的映射关系吗？应该不是。所以它就不属于#tr[shaping]前特性。这是一个应该放在处理流程末尾的工作吗？不，这是一个#tr[substitution]而不是#tr[positioning]操作，所以不该在最后。那么看上去它应该处于流程中间。

// Second, we ask ourselves if this is something that we want the user to control or something we want to require. We'd rather it was something that was on by default. So we look through the collection of features that shapers execute by default, and go through their descriptions in the [feature tags](https://docs.microsoft.com/en-us/typography/opentype/spec/featuretags) part of the OpenType spec.
第二步，问问自己我们希不希望用户能够控制这个操作，还是说这是一个必须的操作？答案是我们希望默认就是这个效果。那么现在就看看#tr[shaper]默认启用的那些特性吧。这可以在OpenType规范的特性列表#[@Microsoft.OpenTypeRegistered]中对每个特性的描述里找到。

// For example, we could make it a required ligature, but we're not exactly "replacing a sequence of glyphs with a single glyph which is preferred for typographic purposes." `dist` might be an option, but that's usually executed at the positioning stage. What about `abvs`, which "substitutes a ligature for a base glyph and mark that's above it"? This feature should be on by default, and is required for Indic scripts; it's normally executed near the start of the substitution phase, after those features which rewrite the input stream. This sounds like it will do the job, so we'll put it there.
我们可以把它放在必要#tr[ligature]（`rlig`）里，但这段代码好像并不完全符合“将一系列#tr[glyph]替换为它们在#tr[typography]意义上更加合适的单个#tr[glyph]”这个描述。`dist`特性看上去也是个选择，但它通常在#tr[positioning]阶段处理。`abvs`如何呢？它的描述是“将基本字符和其上的符号替换为它们的#tr[ligature]形式”、“它是默认启用的”、“对印度系#tr[scripts]来说是必要的”、“它通常在#tr[substitution]阶段的初期，所有改写输入流的特性执行完后被应用”。这听上去挺符合我们想做的事情的，我们就把代码放在`abvs`特性里吧。

// Once again, this is not an exact science, and unless you are building up extremely complex fonts, it isn't going to cause you too many problems. So try to reason about what your features are doing, but feel free to copy others, and don't worry too much about it.
再次提醒，这里并没有科学标准。而且，除非你是在创建超级复杂的字体，否则放在什么特性中并不会带来什么问题。所以，尽量尝试自己做出合理的选择，但也不要太过拘谨，去复制别人的也没问题。

// Now let's look at how to implement some specific features, starting with a few simple ones to get us started, and then getting to the more tricky stuff later.
现在我们去看看如何实现某些具体功能。先从简单的开始，然后再慢慢接触更刁钻的部分。

// ## Language-specific substitutes
== 特定语言专属#tr[substitution]

// We've already mentioned the Serbian form of the letter be (б), which should appear different to the Russian Cyrillic version. This is one example of a family of *language-specific substitutes*, which we can handle more or less in the same way.
我们#link(<position:serbian-letter-be>)[此前]提到过，塞尔维亚样式的西里尔字母`be`和俄文中的不太一样。这是按照具体语言来决定是否进行#tr[substitution]的一个需求案例，这类需求基本上都能用下面这种方式处理。

// First, we design our two glyphs, the Russian be (let's call the glyph `be-cy`) and the Serbian variant, which we'll call `be-cy.SRB`. We want a feature which is on by default, occurs early in the process, is pre-shaping (in that it rewrites the input glyph stream) and which substitutes localized forms - this is precisely what the `locl` feature was designed for. We look up the script tag for Cyrillic (`cyrl`) and the language tag for Serbian (`SRB`), and we create a rule that applies only when the input is tagged as being in the Serbian language. We want to do a one-to-one substitution - any Cyrillic be gets swapped out for a Serbian one - so we create a single substitution rule.
首先设计两个#tr[glyph]，俄文版的`be`（就叫它`be-cy`）和塞尔维亚语中的变体版本（叫它`be-cy.SRB`）。我们想在一个默认启用的，在处理流程早期，#tr[shaping]阶段前（因为它要重写输入流）生效的，用于#tr[glyph]本地化的特性。这基本上精确锁定了`locl`特性。然后我们查找到，西里尔字母和塞尔维亚语的OpenType标签分别是`cyrl`和`SRB`。接着我们创建一个只在输入文本被标记为塞尔维亚语时才会应用的规则。一个西里尔字母只会变成一个塞尔维亚版的字母，所以我们使用一换一#tr[substitution]：

```fea
feature locl {
  script cyrl;
  language SRB;
  sub be-cy by be-cy.SRB;
} locl;
```

这样就行了。

// We can apply the same kind of substitution not just to base characters but also to marks and combining characters, although we need a little thought. In Polish, there's an accent called a *kreska* which looks like an acute accent from other Latin scripts - and in fact, is expressed in Unicode as an acute accent - but is somewhat more upright and positioned to the right of the glyph. How do we create a font which distinguishes between the Western European acute accent and the Polish kreska, even though the Unicode characters are the same?
同样的方式也可以应用在符号和连接#tr[character]上，但需要费些心思。在波兰语中有一种叫做`kreska`的变音符号，它看上去就像拉丁文中的尖音符。事实上，Unicode就是用尖音符来表示它，但它显示出来应该比拉丁文中的更竖直和靠右一些。既然在Unicode中是一个#tr[character]，那在制作字体时要如何区分西欧的尖音符和波兰语中的`kreska`呢？

// First, we should note that the Polish accent appears on some letters we may not have planned for: c, n, s and z - then again, we should also be aware that these letters also get an *acute* accent in other writing systems: Yoruba, Khmer, and Sanskrit transliteration amongst others. So we can't just rely on having the Polish forms for these. We need - as with the vowels - to create two separate versions: one with the Western European acute, and one with *kreska*. We look at [Adam Twardoch's web site](http://www.twardoch.com/download/polishhowto/kreska.html) to help get the design of our Polish accents right, and we should now end up with two sets of glyphs: `aacute`, `cacute`, ... and `aacute.PLK`, `cacute.PLK` and so on.
首先，我们应该注意到波兰尖音符会出现在一些计划之外/*啥意思？*/的字母上，比如`c`、`n`、`s`和`z`上。我们也要意识到，这些字母在其他书写系统中也可能被附加尖音符。比如约鲁巴语、高棉语、梵语转写字母等。我们不能只设计波兰样式，而是需要为这些元音和尖音符的组合都设计两个版本，一个使用西欧尖音符，另一个使用波兰的`kreska`。通过参考Adam Twardoch的网站@Twardoch.PolishDiacritics.1999，我们得以正确设计波兰尖音符。现在我们有了两套#tr[glyph]。一套是 `aacute`、`cacute`……；另一套则是 `aacute.PLK`、`cacute.PLK` 等。

// Now we know what we're doing: we use the `locl` feature as before to substitute in these glyphs when the input text is in Polish:
现在该怎么做就很清晰了。当输入文本是波兰语时，使用`locl`特性将这些#tr[glyph]#tr[substitution]为正确的样式：

```fea
feature locl {
    script latn;
    language PLK;
    sub [aacute cacute ...] by [aacute.PLK cacute.PLK ...];
} locl;
```

#note[
  // > This general pattern - language-specific substitution rules in the `locl` feature - can be used for a large number of localisation customizations, particularly those based on the Latin script (simply because they tend to be one-to-one glyph replacements.) Further examples of the pattern include Navajo forms of the ogonek accent, and choosing between variants of the letter U+014A LATIN CAPITAL LETTER ENG (Ŋ) - "N-form" variants in the case of Sami languages and "n-form" variants for African ones.
  这种在`locl`特性中编写特定语言专用的#tr[substitution]规则的通用模式可以用于很多本地化自定义样式的场景中。这种模式在当地#tr[scripts]是基于拉丁文时尤其好用，因为此时基本上都是简单的一换一替换。这类例子可以在很多语言中找到，比如：反尾形符在纳瓦霍语条件下有特殊样式；`U+014A LATIN CAPITAL LETTER ENG`在萨米语系下使用N形式（Ŋ），而在非洲语言中使用n形式（#text(font: ("DejaVu Sans",))[Ŋ]）。
]

// ### A detour about diacritics
=== 再论#tr[diacritic]

// We've looked at the mark-to-base positioning and composition/decomposition substitutions in previous chapters. Why, then, do we need to design separate glyphs for `cacute` and `cacute.PLK` - can't we just design separate *accents* and have the OpenType system tie them together for us? In fact, why do we even need to include a `cacute` in our font *at all*? Can't we just have the font automatically compose the glyph out of the c base glyph and the acute mark, and automatically position it for us? Hey, why can't we do that for *all* our diacritic characters? As with many things in life, the answer is: sure, you *can*, but that doesn't mean you *should*.
在前面的章节中，我们已经探讨了#tr[glyph]的#tr[compose]和#tr[decompose]，以及在基本#tr[glyph]上添加符号的#tr[substitution]规则。那么我们为什么需要设计单独的字形来表示 `cacute` 和 `cacute.PLK` 呢？我们不能只设计单独的音调符号，然后让OpenType帮我们把它们结合起来吗？事实上，我们究竟为什么要在字体里制作单独的 `cacute` #tr[glyph]呢？我们不能让字体自动将基本的`c`#tr[glyph]和尖音符组合起来，并自动进行定位吗？嘿，我们甚至可以对所有#tr[diacritic]都使用这种方式啊。答案是：当然，这种方案是*可行*的，但这并不意味着你就*应该*这么做。

// There are a few reasons why it's best to design and include precomposed forms of all the accented glyphs you're going to support, rather than rely on automatic composition. For one thing, there's kerning: it's much easier to test and edit the kerning for "Tå" in your font editor than adding tricky kern triplets in OpenType feature code.
最好还是将所有附加了音调的#tr[glyph]都按预先#tr[compose]好的方式进行整体设计，而不是依赖使用规则来进行自动#tr[compose]。这样建议有几个原因，其中之一是能更方便地处理#tr[kern]。在字体编辑软件中直接测试和编辑诸如`Tå`这样的#tr[kern]是非常简单的，而如果使用自动#tr[compose]，你就需要非常小心地编写调整三个#tr[glyph]间距的OpenType特性代码。

// Another problem is that some software (notably Adobe InDesign) doesn't support it, and other software doesn't support it in reliable ways. This is an important area to understand because it highlights the interplay between *OpenType*'s understanding of characters and glyphs and *Unicode*'s understanding of characters and glyphs.
另一个问题是某些软件（尤其是Adobe InDesign）不支持这个功能，而在另一些软件中的支持也并不稳定。理解这个问题产生的原因非常重要，因为它告诉我们，OpenType对于#tr[character]和#tr[glyph]之间关系的理解和Unicode的理解并不一致。

// Remember how we talked about [Unicode normalization and decomposition](unicode.html#normalization-and-decomposition) in chapter 3, and how you can decompose a character like é (U+00E9 LATIN SMALL LETTER E WITH ACUTE) into two characters, U+0065 LATIN SMALL LETTER E and U+0301 COMBINING ACUTE ACCENT? That sounds very similar to the idea of having an "eacute" glyph which is made up of an "e" glyph and an "acutecomb" glyph. Similar... but unfortunately different.
我们在关于Unicode的章节中的@heading:normalization-decomposition #title-ref(<heading:normalization-decomposition>)里介绍过，你可以把#tr[character]é（`U+00E9 LATIN SMALL LETTER E WITH ACUTE`）#tr[decompose]为`U+0065 LATIN SMALL LETTER E` 和 `U+0301 COMBINING ACUTE ACCENT`两个#tr[character]。这听起来和我们想用一个`e`和一个用于#tr[combine]的尖音符组合成`eacute`#tr[glyph]非常类似。嗯，确实很类似，但不幸的是它们并不完全一致。

// As it happens, if your font provides a "e" and a "acutecomb" glyph but *not* a precomposed "eacute", then some text layout systems will *only* render an e-acute if the input text is decomposed to U+0065 U+0301 (which is exceptionally rare) and will use a fallback font to display the precomposed form U+00E9. Others will automatically decompose a U+00E9 in the input stream to U+0065 U+0301 and display the two glyphs correctly. Some systems will correctly substitute a precomposed glyph for its decomposition specified using the `ccmp` feature, but then will fail to position the marks properly in the `mark` feature.
在现实世界中，如果你的字体是把`e`和尖音符分开设计，而没有提供预#tr[compose]的`eacute`的话，那么有些排版系统就只会在输入的文本是 `U+0065 U+0301` 时（这种情况非常罕见）才能正确渲染出#tr[compose]字形。如果它遇到`U+00E9`，就只能使用回退字体来显示了。还有些软件会将用户输入文本中的 `U+00E9` 自动#tr[decompose]为 `U+0065 U+0301`，然后正确显示这两个#tr[glyph]。也有些软件能够调用`ccmap`特性中的规则，将预#tr[compose]#tr[character]#tr[substitution]为它们的#tr[decompose]#tr[glyph]，但却无法使用`mark`特性将它们正确定位。

// But having a precomposed glyph in the font will always work, both for composed Unicode characters like U+00E9 *and* for its decompositions, so that's why having the font contain all the glyphs you are likely to support is a better way to go.
但直接在字体里包含一个预#tr[compose]的#tr[glyph]在所有情况下都能正常工作，无论输入的Unicode#tr[character]是`U+00E9`还是其#tr[decompose]形式均可。所以直接在字体里放入所有希望支持的#tr[glyph]是一种更好的方式。

// ## The letter "i"
== 麻烦的字母 i

// The Latin letter "i" (and sometimes "j") turns out to need special handling. For one thing, in Turkish, as we've mentioned before, lower case "i" uppercases to "İ".
拉丁字母`i`（有时候`j`也一样）需要特殊处理。因为#link(<position:turkish-i-uppercase>)[前文]提到过，在土耳其语中`i`的大写形式是`İ`。

// Unicode knows this, so when people ask their word processors to turn their text into upper case, the word processor replaces the Latin letter "i" with the Turkish capital version, LATIN CAPITAL LETTER I WITH DOT ABOVE U+0130. Fine. Your font then gets the right character to render. However, what about the case (ha, ha) when you ask the word processor for small capitals? Small capitals are a typographic refinement, which changes the *presentation* of the characters, *but not the characters themselves*. Your font will still be asked to process a lower case Latin letter i, but to present it as a small caps version - which means you do not get the advantage of the application doing the Unicode case mapping for you. You have to do it yourself.
Unicode是知道这个信息的，所以当用户在文字处理软件中要求将一段文本转为大写时，在土耳其语环境下软件会正确的将`i`转换为土耳其版的大写字母`LATIN CAPITAL LETTER I WITH DOT ABOVE U+0130`。很好很好，这样的话字体得到的#tr[character]就是正确的，显示也正常。然而（桀桀），如果用户是让文字处理软件使用小型大写字母呢？小型大写字母是一种#tr[typography]上的精细调整，改变的是#tr[character]的*展示形式*，而*并非改变#tr[character]本身*。

#note[
  // > In fact, *any* time the font is asked to make presentational changes to glyphs, you need to implement any character-based special casing by hand. What we say here for small-caps Turkish i is also valid for German sharp-s and so on.
  实际上，当要对#tr[glyph]进行任何展示形式上的变化时，你都需要手动实现这种基于#tr[character]的特殊处理。这里我们举的是土耳其字母`i`的例子，但对于德国的 sharp s 等也是一样的情况。
]

// Additionally, you may want to inhibit Turkish "i" from forming ligatures such as "fi" and "ffi", while allowing ligatures in other Latin-based languages.
另外，你可能还希望在土耳其语环境下阻止`fi`和`ffi`等#tr[ligature]的形成，而在其他基于拉丁文语言中允许它们。

// We're going to look at *two* ways to achieve these things. I'm giving you two ways because I don't want you just to apply it as a recipe for this particular situation, but hopefully inspire you to think about how to use similar techniques to solve your own problems.
我们这里准备介绍完成这一目标的两种不同方式。之所以介绍两种方式，是希望你不要将某种方式视为专门解决这一问题的工具。我更希望这些方式能够为你提供灵感，从而能将它们灵活应用，进而能够使用类似的方式解决你将会遇到的各种其他问题。

// Here's the first way to do it, in which we'll deal with the problems one at a time. We make a special rule in the `smcp` feature for dealing with Turkish:
先来介绍第一种方案。在此方案中，我们对于上面的问题采取逐个击破的方式。首先在`smcp`特性里增加一个处理土耳其语的特殊规则：

```fea
feature smcp {
    sub i by i.sc; # 其他情况下的默认规则
    script latn;
    language TRK;
    sub i by i.sc.TRK;
}
```

// Oops, this doesn't work. Can you see why not? Remember that the language-specific part of a feature includes all the default rules. The shaper sees a "i" and the `smcp` feature, and runs through all the rules one at a time. The default rules are processed *first*, so that "i" gets substituted for "i.sc". Finally the shaper comes to the Turkish-specific rule, but by this point any "i" glyphs have already been turned into something else, so it does not match.
糟糕，这样写好像没用。你看出来为什么了吗？记住，特性中的语言专属部分是会包含默认规则的。当#tr[shaper]为`i`执行`smcp`特性时，它会执行上面的所有规则。其中默认规则先执行，现在`i`就变成了`i.sc`。然后#tr[shaper]才会去处理土耳其语专用规则，但此时`i`已经变成别的了，所以规则不会匹配。

// How about this?
那这样写呢？

```fea
feature smcp {
    sub i by i.sc; # 其他情况下的默认规则
    script latn;
    language TRK;
    sub i.sc by i.sc.TRK;
}
```

// Now the shaper gets two bites at the cherry: it first turns "i" into "i.sc", and then additionally in Turkish contexts the "i.sc" is turned into "i.sc.TRK". This works, but it's ugly.
现在#tr[shaper]就像是在游戏里有两条命了，它首先把`i`转换成`i.sc`，然后在土耳其语环境下进行额外的检查，将`i.sc`转换成`i.sc.TRK`。这是可以工作的，但有点别扭。

// The ligature situation is taken care of using `exclude_dflt`:
#tr[ligature]则需要小心翼翼地使用`exclude_dflt`来处理：

```fea
sub f i by f_i;
script latn;
language TRK exclude_dft;
```

// Now there are no ligature rules for Turkish, because we have explicitly asked not to include the default rules.
这样土耳其语环境下就不存在#tr[ligature]规则了，因为我们明确的要求它排除默认规则。

// Here's another, and perhaps neater, way to achieve the same effect. In this method, we'll create a separate "Turkish i" glyph, "i.TRK", which is visually identical to the standard Latin "i". Now in the case of Turkish, we will substitute any Latin "i"s with our "i.TRK" in a `locl` feature:
下面介绍第二种方案，它也许可以更加优雅地达到相同的效果。在本方案中，我们创建一个单独的`i.TRK`#tr[glyph]，用于表示土耳其版的`i`。他和普通的标准拉丁字母`i`在视觉上是相同的。然后在土耳其语环境下，我们使用`locl`特性把所有的拉丁`i`都#tr[substitution]成`i.TRK`：

```fea
feature locl {
  script latn;
  language TRK exclude_dflt;
  sub i by i.TRK;
} locl;
```

// What does that achieve? Well, the problem with ligatures is taken care of straight away, without any additional code. We create our `liga` feature as normal:
这段代码完成了什么事情呢？首先，#tr[ligature]的问题就直接消失了，不再需要费心编写特殊处理代码了。现在我们的#tr[ligature]特性就非常干净：

```fea
feature liga {
    sub f i by f_i;
}
```

// But we don't need to do anything specific for Turkish, because in the Turkish case, the shaper will see "f i.TRK" and the rule will not match. The small caps case is easier too:
我们不需要做什么特殊操作了，因为在土耳其语环境中#tr[shaper]看到的将会是`f i.TRK`，这样规则就不会匹配。小型大写字母的代码也很简单：

```fea
feature smcp {
    sub i by i.sc;
    sub i.TRK by i.sc.TRK;
}
```

// This has "cost" us an extra glyph in the font which is a duplicate of another glyph, but has made the feature coding much simpler. Both ways work - choose whichever best fits your mental model of how the process should operate.
使用这种方式会让我们的字体里多出一个重复的#tr[glyph]，但它能让特性代码更加简单。上面介绍的两个方案都能达成目标，你只要选择符合你脑海中模拟的处理流程的那一个就行。

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

// ## Other complex scripts
== 其他复杂#tr[scripts]

// Designing for Indic scripts such as Devanagari is pretty much the same as any other script: know your script, do your research, read the Microsoft [script development guidelines](https://docs.microsoft.com/en-gb/typography/script-development/devanagari). In terms of OpenType Layout, these guidelines contain a helpful list of features you will need to implement, and some hints for [how you should implement them]([https://docs.microsoft.com/en-gb/typography/script-development/devanagari#feature-examples).
为天城文等印度系#tr[scripts]设计字体的步骤也类似，首先要了解这种#tr[script]并进行相关研究，阅读微软的字体开发规范@Microsoft.DevelopingDevanagari。这个指导性文件内包含一个很有用的列表，列出了你需要实现的OpenType#tr[layout]特性。它还会提供一些关于如何实现这些特性的提示和帮助。

// But this is made complicated by the fact that the shaping engine contributes its own knowledge to the process. Just as how, in Arabic, the shaping engine will automatically "call" the `init`, `medi` and `fina` features to obtain the correct glyphs for characters in certain positions, Shaping engines like Harfbuzz and Uniscribe contain code which handle various special cases required by different script systems - syllable reordering in Indic scripts, *jamo* composition in Hangul, presentation forms in Hebrew, adjustment of tone mark placement in Thai, and so on.
但现实有时候会更复杂一些，因为#tr[shaping]引擎会根据它对相关领域知识的了解程度而在#tr[shaping]流程上有所不同。比如对于阿拉伯文，#tr[shaping]引擎就可能会自动调用`init`、`medi`、`fina`特性，来将词中各个位置的#tr[character]转换为正确的#tr[glyph]。HarfBuzz 和 Uniscribe 中还会有一些代码专门用于处理各种不同书写系统的特殊需求。比如印度系#tr[scripts]需要的音节重排，韩语中谚文字母的#tr[compose]，希伯来语中表达形式的字母，泰语中的音调处理等等。

// As we've already mentioned, OpenType Layout is a collaborative process, and this is especially true for complex scripts. There is a complex dance between what the shaper signals to your font and what your font signals to the shaper. To create a font which performs correctly, you need to have knowledge both of what the shaper is going to do on your behalf, and also how you are going to respond to what the shaper does.
我们重复提到过一点，OpenType的处理流程采用的是一种合作模型，对于复杂#tr[scripts]来说更是如此。这整个过程就像是一场#tr[shaper]和字体之间的复杂舞蹈，它们需要能互相理解对方发出的眼神信号并完成配合。为了能做出一个好的字体，你需要了解#tr[shaper]的工作原理，以及要怎么作才能正确配合它。

// Let's take Devanagari as an example.
我们这次用天城文作为例子。

// First, the shaper will move pre-base matras (such as the "i" vowel) before the base consonant, and any marks after the base. But what is the base consonant, and what is a mark? Here's the thing: your font helps the shaper decide.
首先，#tr[shaper]将会去掉基本辅音#tr[glyph]之前的所有matra（比如元音i）和之后的所有符号。但什么是基本辅音，什么又是符号呢？这就是互相配合的地方了，你需要告诉#tr[shaper]这些信息。

// Consider the made-up syllable "kgi" - ka, virama, ga, i-matra. Without special treatment, we can expect the vowel to apply to the base consonant "ga", like so:
考虑组成音节`kgi`的#tr[character]序列 `ka virama ga i-matra`。如果不经过特殊处理，那么元音将会附加在基本辅音`ga`上，就像这样：

#let broken = body => devanagari(text(features: ("half": 0), body))

#figure(
  placement: none,
)[#block(inset: (y: 1em))[
  #broken[#text(size: 5em)[क्गि]]
]]

// But if the ka takes a half-form, (which of course it should in this case) then the matra applies to the whole cluster and should appear at the beginning. By adding the half-form *feature* to your font
但是如果 `ka` 使用半字形式（在这个例子里肯定是应该使用的）的话，那么`matra`就可以覆盖整个音节，从而应该出现在最开始的位置。通过添加`half`特性，我们可以实现这一功能：

```fea
feature half {
    sub ka-deva halant-deva by k-deva;
} half;
```

// you signal to the layout engine that the matra should cover the whole cluster:
通过这个特性，你就给了#tr[layout]引擎一个明确希望`matra`覆盖整个音节的信息：

#figure(
  placement: none,
)[#block(inset: (top: 1em))[
  #devanagari[#text(size: 5em)[क्गि]]
]]

// Again, this is something we can see clearly with the `hb-shape` utility:
我们可以用`hb-shape`工具来清晰地展示它的工作情况：

#[
#show regex(`\p{Devanagari}+`.text) : devanagari

```bash
$ hb-shape --features='-half' Hind-Regular.otf 'क्गि'
[dvKA=0+771|dvVirama=0@-253,0+0|dvmI.a05=2+265|dvGA=2+574]
$ hb-shape --features='+half' Hind-Regular.otf 'क्गि'
[dvmI=0+265|dvK=0+519|dvGA=0+574]
```
]

// So the features defined in your font will change the way that the shaper applies glyph reordering - the script development specs calls this "dynamic character properties" - and conversely, if you do *not* provide appropriate substitutions for half-forms then your glyphs may not appear in the order you expect!
所以在字体中定义的特性会改变#tr[shaper]进行#tr[glyph]重排的方式，这在字体开发中称为“动态#tr[character]属性”。反过来，如果你*没有*进行半字形式的#tr[substitution]，那么可能#tr[glyph]的顺序就不符合你的预期了。

// Similar dynamic properties apply in other features too. The shaper will test each consonant-halant pair to see if the `half` or `rphf` (reph form,  above-base form of the letter ra) features apply to them and create a ligature. If they do, the consonant is not considered a base. 
// if the reph form is part of a mark class, it will be moved to *after* the base.
其他特性也会影响这些动态属性。#tr[shaper]会测试文本中的每个辅音-半音对，看`half`特性是否会将它们#tr[substitution]成#tr[ligature]形式。如果发生了#tr[substitution]，那么这个辅音就不被认为是基本辅音。它也会尝试应用`rphf`特性，这个特性用于将`ra`#tr[glyph]转换一个基本字符之上的的连接符，称为 reph。如果这个#tr[substitution]发生了，而且结果是属于符号类的#tr[glyph]，那么就会把它移动到基本#tr[character]之后。

// To see these reorderings in action, I created a dummy font which simply encodes each glyph by its Unicode codepoint. I then added the following features:
为了亲眼看到这种重排的发生，我制作了一个测试字体。这个字体将每个Unicode#tr[codepoint]的数字直接转换为#tr[glyph]。然后我添加了如下特性代码：

```fea
languagesystem DFLT dflt;
languagesystem dev2 dflt;

feature half {
  # ka virama -> k
  sub uni0915 uni094D by glyph01;
} half;

feature rphf {
  # ra virama -> reph
  sub uni0930 uni094D by glyph02;
} rphf;
```

// Let's use this to shape the syllable "rkki" (ra, virama, ka, virama, ka, i-matra):
我们用这个字体来对音节`rkki`（`ra virama ka virama ka i-matra`）进行#tr[shaping]：

#[
#show regex(`\p{Devanagari}+`.text) : devanagari

```bash
$ hb-shape Devanagari-Test.otf 'र्क्कि'
[glyph02=0+600|uni093F=2+600|glyph01=2+600|uni0915=2+600]
```
]

// The ra-virama turned into our reph form; the ka-virama turned into a half form; and the sequence was reordered to be "reph i-matra k ka". Oops, that's not quite right. We want the reph form to appear at the end of the sequence. We'll add another line to our feature file, stating that `glyph02` (our "reph" form) should be interpreted as a mark:
你会发现 `ra virama` 变成了reph，`ka virama`变成了半字 k，然后这个序列被重新排序为`reph i-matra k ka`。但是这个结果不太对，我们希望 reph 能够出现在序列的最后。这可以在特性文件里加一行代码来解决，我们需要将`glyph02`（它代表reph）视为符号：

```fea
markClass glyph02 <anchor 0 0> @reph_is_mark;
```

// How does that change things?
这会改变结果吗？

#[
#show regex(`\p{Devanagari}+`.text) : devanagari

```bash
$ hb-shape Devanagari-Test.otf 'र्क्कि'
[uni093F=0+600|glyph01=0+600|uni0915=0+600|glyph02=0+600]
```
]

// That's fixed it - the "mark" reph form is moved to the end of the syllable cluster, where we want it.
果然，它修复了上面的问题。reph符号现在在音节的末尾了，这就是我们所期望的结果。

#note[
  // > If you want to get clever and have a variant reph form to match the i-matra, have a look at the [feature file](https://github.com/itfoundry/hind/blob/master/family.fea) for Indian Type Foundry's Hind family.
  如果你想更智能地处理reph的各种变体，让它能和`i-matra`匹配起来，则可以参考Indian Type Foundry 的 Hind 字体源码中的特性文件@IndianTypeFoundry.HindFamily。
]

// The `rphf` and `half` features are tested against consonant-virama pairs; when a virama appears *before* a consonant, the pair is tested to see if any pre-base forms (`pref` feature), below-base forms (`blwf`) or post-base forms (`pstf`) are substituted; if so, these forms will not be considered the base consonant. Pre-base consonants identified by substitutions in the `pref` feature will also be reordered.
`rphf`和`half`特性会尝试匹配辅音-半音#tr[character]对，但如果`virama`出现在辅音之前呢？这时起作用的就会是`pref`/`blwf`/`pstf`这三个特性了，它们分别表示这个辅音应该被显示为基前/基下/基后形式。如果这些特性中的某个成功应用，那么匹配上的辅音就不被视为基本辅音。被`pref`中的#tr[substitution]命中的基前辅音也会被重新排序。

// The script development specs advise that all consonants should have a nukta form, implemented in the `nukt` feature. While you could do this by providing positioning information for the nukta on the base, the Indian Type Foundry recommends providing substitution glyphs with nuktas in order to avoid problems when forming ligatures. You will also want to provide rakaar forms using the `rkrf` feature; these will be processed after the nukta and akhand ligatures are processed, so will take the output of these features:
字体开发规范建议我们，所有的辅音都应该有对应的加点（nukta）形式，用`nukt`特性实现。你可以用提供 `nukta` 在基本辅音上的锚点位置的方式来实现它，但 Indian Type Foundry 的建议是将辅音#tr[substitution]为带有`nukta`的#tr[glyph]，以避免在后续制作#tr[ligature]时的问题。你还可以使用`rkrf`特性来制作辅音连写形式，这个特性的处理顺序在`nukt`和不可分割#tr[ligature]之后，所以它得到的输入是这些特性的输出：

```fea
feature nukt {
    sub ka-deva nukta-deva by kxa-deva;
}
feature rkrf {
    sub ka-deva halant-deva ra-deva by kra-deva;
    # 也把 nukta 特性输出的字形纳入考虑范围
    sub kxa-deva halant-deva ra-deva by kxra-deva;
}
```

// ## The Universal Shaping Engine
== 通用#tr[shaping]引擎

// In the previous section we looked at how shapers contain specialist knowledge, automatically activating particular features and performing glyph reordering based on the expectations of a particular script. The Indic shaper has a lot of linguistic information in it - it knows how to reorder glyphs around the base consonant, and it further knows that when half forms or reph forms are present, the way that reordering happens should change.
上一节中我们主要讨论的是#tr[shaper]需要内置一些知识，也就是在某些#tr[scripts]下要激活特定的特性，以它们期望的方式处理#tr[glyph]重排等。印度系#tr[scripts]尤其如此，处理它们需要大量的关于语言的信息，比如如何围绕基本辅音来重排#tr[glyph]，以及使用半字和reph时排序方式需要怎样变化。

// Of course, there's a problem with this. If the shaper contains all the knowledge about how to organise a script, that means that when a new script is encoded and fonts are created for it, we need to wait until the shaping engines are updated with new handling code to deal with the new script. Even when the code *is* added to the shaper, fonts won't be properly supported in older versions of the software, and in the case of commercial shaping engines, it may not actually make economic sense for the developer to spend time writing specific shaping code for minority scripts anyway.
很明显这样有问题。如果#tr[shaper]需要了解所处理#tr[scripts]的所有知识的话，那么就意味着每次有新#tr[scripts]被#tr[encoding]时，我们必须要等到#tr[shaper]更新代码支持这种新#tr[scripts]后才能开始为它制作字体。即使#tr[shaper]真的会更新代码，那些老旧的软件也无法正确处理新的#tr[scripts]。而对于那些作为商业软件的#tr[shaper]来说，为这些少数民族#tr[script]费心费力地编写专用处理代码基本没有什么经济价值。

// After overseeing the development of far more script-specific shapers than one person really should, Andrew Glass of Microsoft wondered whether it would be possible to develop one shaping engine for all of Unicode. A similar endeavour by SIL called Graphite attempts to acts as a universal shaping engine by moving the script-specific logic from the shaper into the font: Graphite "smart fonts" contain a bytecode program which is executed by the shaper in place of the shaper's script-specific knowledge. In Glass' idea of the Universal Shaping Engine, however, the intelligence is neither in the font nor in the shaping engine, but provided by the Unicode Character Database.
在监制了远超其职责数量的特定#tr[scripts]专用#tr[shaper]之后，微软的Andrew Glass开始思考是否有可能开发一个对整个Unicode#tr[character set]都适用的#tr[shaping]引擎。SIL的Graphite技术也在努力尝试同样的事情，它通过将特定#tr[scripts]的处理逻辑从#tr[shaper]里移动到字体里来完成通用#tr[shaping]引擎的目标。Graphite将这种字体称为“智能字体（smart fonts）”。这种字体中包含一个字节码构成的程序，#tr[shaper]会执行这段程序，而自身并不包含对任何#tr[scripts]的知识。Glass对于通用#tr[shaping]引擎（Uniersal Shaping Engine, USE）的想法和Graphite并不一样。在他的设想中，关于#tr[scripts]的知识既不在#tr[shaper]中，也不在字体里，而是由Unicode#tr[character]数据库提供。

// Each character that enters the Universal Shaping Engine is looked up in the Unicode Character Database. Based on its Indic Syllabic Category, General Category, and Indic Positional Category entries, is placed into one of twenty-four character classes, further divided into 26 sub-classes. The input characters are then formed into clusters based on these character classes, and features are applied to each cluster in turn.
通用#tr[shaping]引擎会在Unicode#tr[character]数据库中查询输入的每个#tr[character]。根据#tr[general category]、印度系音节分类（Indic Syllabic Category）、印度系位置分类（Indic Positional Category）等条目信息，将#tr[character]分为24个类别，进一步分为26个子类。接下来，输入的#tr[character]依据上述分类被组织成#tr[cluster]。最后以#tr[cluster]为单位应用特性。

// One problem that the USE attempts to solve is that the order that characters are encoded in Unicode is not the same as the order in which their respective glyphs are meant to be displayed. A USE shaper looks at the character classes of the incoming input and forms them into a cluster by matching the following characteristics:
USE试图解决#tr[character]在Unicode中的#tr[encoding]顺序和它们对应#tr[glyph]的最终显示顺序不一致的问题。USE分析输入#tr[character]的分类，然后将他们按照各自的特征组织成#tr[cluster]。这个流程如下：

#figure(
  placement: none,
  caption: [
    USE将#tr[character]组织成#tr[cluster]的流程。
    // If you want a more formal grammar for a USE cluster, you can find one in the Microsoft [script development specs](https://docs.microsoft.com/en-us/typography/script-development/use).
    更加正式的USE#tr[character]#tr[cluster]构成法可以在微软的《通用#tr[shaping]引擎字体开发规范》#[@Microsoft.DevelopingUSE]中找到。
  ]
)[#include "USE-cluster.typ"]

// But the USE expects those characters to be formed into a glyph which looks like this:
USE 允许将#tr[character]们最终组合为一个如@figure:USE-form 这样的#tr[glyph]。

#figure(
  caption: [USE中一个标准#tr[cluster]的构成]
)[#image("use-form.png")] <figure:USE-form>

// For instance, in Telugu, we know that the series of characters ఫ్ ట్ వే should be formed into a single cluster (ఫ్ట్వే), because it is made up of a base character ఫ, followed by two halant groups (virama, base consonant), and a final top-positioned vowel. The script development spec mentioned above explained how these categories are derived from the Indic Positional Category and Indic Syllabic Category information in the Unicode Character Database.
例如在泰卢固文中，我们知道 #telugu[ఫ్ ట్ వే] 这个#tr[character]序列需要被组合成 #box(baseline: -0.2em)[#telugu[ఫ్ట్వే]] 这样一个#tr[cluster]，因为它是由一个基本字符 #telugu[ఫ్]，两个半音组（半音加一个基本字符）和一个结尾的上方元音组成的。之前提到的字体开发规范中，详细介绍了如何根据Unicode#tr[character]数据库中的印度系位置分类和印度系音节分类，将#tr[character]划分为USE中定义的各种类别。

// This "computational" model of a cluster does not know anything about the linguistic rules used in real-life scripts; you can create valid USE clusters which would be shaped "correctly" according to the script grammar defined in the specification, even though they have no relationship with anything in the actual language. For example, we can imagine a Balinese sequence made up of the following characters:
这个用于组合#tr[cluster]的计算模型并不具备任何现实中的语言学知识。你可以根据规范中构成法的定义创建出一个和现实语言没有任何关联，但却依然合法的#tr[cluster]。比如，我们可以使用如下#tr[character]合成出一个想象中的巴厘文字#tr[cluster]：

/*
* ᬳ BALINESE LETTER HA, Base
* ᬴ BALINESE SIGN REREKAN, Consonant modifier above
* Halant group:
    * ᭄ BALINESE ADEG ADEG, Halant
    * ᬗ BALINESE LETTER NGA, Base
    * ᬴ BALINESE SIGN REREKAN, Consonant modifier above
* Halant group:
    * ᭄ BALINESE ADEG ADEG, Halant
    * ᬢ BALINESE LETTER TA, Base
* Vowels:
    * ᬶ BALINESE VOWEL SIGN ULU, Vowel above
    * ᬹ BALINESE VOWEL SIGN SUKU ILUT, Vowel below
    * ᬸ BALINESE VOWEL SIGN SUKU, Vowel below
    * ᬵ BALINESE VOWEL SIGN TEDUNG, Vowel post
* Vowel modifiers:
    * ᬀ BALINESE SIGN ULU RICEM, Vowel modifier above
    * ᬁ BALINESE SIGN ULU CANDRA, Vowel modifier above
    * ᬄ BALINESE SIGN BISAH, Vowel modifier post
* Final consonants:
    * ᬃ BALINESE SIGN SURANG, Consonant final above
*/
#let gobbledegook = (
  (codepoint: 0x1B33, name: "BALINESE LETTER HA", class: [基本#tr[character]]),
  (codepoint: 0x1B34, name: "BALINESE SIGN REREKAN", class: [辅音上方修饰符]),
  (
    group: [半音组],
    children: (
      (codepoint: 0x1B44, name: "BALINESE ADEG ADEG", class: [半音符号]),
      (codepoint: 0x1B17, name: "BALINESE LETTER NGA", class: [基本#tr[character]]),
      (codepoint: 0x1B34, name: "BALINESE SIGN REREKAN", class: [辅音上方修饰符]),
    )
  ),
  (
    group: [半音组],
    children: (
      (codepoint: 0x1B44, name: "BALINESE ADEG ADEG", class: [半音符号]),
      (codepoint: 0x1B22, name: "BALINESE LETTER TA", class: [基本#tr[character]]),
    ),
  ),
  (
    group: [元音组],
    children: (
      (codepoint: 0x1B36, name: "BALINESE VOWEL SIGN ULU", class: [上方元音]),
      (codepoint: 0x1B39, name: "BALINESE VOWEL SIGN SUKU ILUT", class: [下方元音]),
      (codepoint: 0x1B38, name: "BALINESE VOWEL SIGN SUKU", class: [下方元音]),
      (codepoint: 0x1B35, name: "BALINESE VOWEL SIGN TEDUNG", class: [后方元音]),
    ),
  ),
  (
    group: [元音修饰组],
    children: (
      (codepoint: 0x1B00, name: "BALINESE SIGN ULU RICEM", class: [上方元音修饰符]),
      (codepoint: 0x1B01, name: "BALINESE SIGN ULU CANDRA", class: [上方元音修饰符]),
      (codepoint: 0x1B04, name: "BALINESE SIGN BISAH", class: [后方元音修饰符]),
    ),
  ),
  (
    group: [结尾辅音],
    children: (
      (codepoint: 0x1B03, name: "BALINESE SIGN SURANG", class: [上方结尾辅音]),
    ),
  )
)

#let gobbledegook-to-list(arr) = {
  for item in arr [
    #if "group" in item [
      #list[#item.group：#gobbledegook-to-list(item.children)]
    ] else [
      #list[#box(width: 1em)[#balinese(str.from-unicode(item.codepoint))] #raw(item.name)，#item.class]
    ]
  ]
}

#gobbledegook-to-list(gobbledegook)

// It's complete gobbledegook, obviously, but nevertheless it forms a single valid graphemic cluster according to the Universal Shaping Engine, and Harfbuzz (which implements the USE) bravely attempts to shape it:
很明显这基本就是在胡编乱造，但即使这样我们还是能根据USE构成法将它们组合成一个合法的字形#tr[cluster]。HarfBuzz（它实现了USE）也会尽其所能的对它进行#tr[shaping]：

#figure(
  placement: none,
)[
#let flatten-gobbledegook(arr) = arr.fold((), (acc, item) => {
  if "group" in item {
    return (..acc, ..flatten-gobbledegook(item.children))
  } else {
    return (..acc, item.codepoint)
  }
})

#let gobbledegook-string = flatten-gobbledegook(gobbledegook).map(str.from-unicode).join()

#block(inset: (top: 2em, bottom: 5em))[#balinese(size: 5em)[#gobbledegook-string]]
]

// When USE has identified a cluster according to the rules above, the first set of features are applied - `locl`, `ccmp`, `nukt` and `akhn` in that order; next, the second set of features - `rphf` and `pref` in that order; then the third set of features - `rkrf`, `abvf`, `blwf`, `half`, `pstf`, `vatu` and `cjct` (not *necessarily* in that order).
当USE根据上述构成法确定一个#tr[cluster]后，首先会应用第一个特性集，包括 `locl`、`ccmp`、`nukt`、`akhn`，按上述顺序应用。然后是第二个特性集 `rphf`、`pref`，也是按此顺序。接下来是第三个特性集 `rkrf`、`abvf`、`blwf`、`half`、`pstf`、`vatu`、`cjct`，不一定按照以上顺序应用。

// After these three feature groups are applied, the glyphs are *reordered* so that instead of their logical order (the order that Unicode requires them to be entered in a text) they now represent their visual order (reading from left to right). Rephs are keyed into a text *before* the base character, but are logically *after* it in the glyph stream. So in the Śāradā script used in Kashmir, we can enter 𑇂 (U+111C2 SHARADA SIGN JIHVAMULIYA) 𑆯 (U+111AF SHARADA LETTER SHA), and this is reordered by the shaping engine like so:
在三个特性集应用完毕后，会将#tr[glyph]序列从逻辑顺序（Unicode要求它们在文本中的出现顺序）重新排序为显示顺序（从左到右）。Reph在文本中会写在基本字符之后，当此时就会移动到前面了。所以我们可以依次输入用于书写克什米尔语的夏拉达文中的两个字母 `U+111C2 SHARADA SIGN JIHVAMULIYA` 和 `U+111AF SHARADA LETTER SHA`，但它们会被#tr[shaping]引擎重排为如下的样子：

#[
#show regex(`\p{Sharada}+`.text): sharada

```bash
$ hb-shape NotoSansSharada-Regular.ttf '𑇂𑆯'
[Sha=0+700|Jihvamuliya.ns=0@-680,0+0]
```
]

// Notice how the Jihvamuliya (reph) has been placed after the base glyph in the glyph stream (even though it's then positioned on top).
注意这个 `Jihvamuliya`（reph）在#tr[glyph]流中的位置是在基本#tr[glyph]之后（在后续的#tr[positioning]阶段被放在了上方）。

// Similarly, glyphs representing pre-base characters (specifically pre-base vowels and pre-base vowel modifiers - and glyphs which have been identified with the `pref` feature, which we'll talk about in a minute) are moved to the beginning of the cluster but after the nearest virama to the left. Here we have a base (U+111A8 BHA), a halant (U+111C0 VIRAMA), another base (U+11193 GA), and a pre-base vowel (U+111B4 VOWEL SIGN I).
类似地，显示在基本#tr[glyph]前的#tr[glyph]（前方元音、前方元音修饰符、被`pref`特性命中的#tr[glyph]等）会被移动到#tr[glyph]#tr[cluster]中较前的位置，位于其最近的半音符的右边。比如我们依次输入基本#tr[character]`U+111A8 BHA`、半音符号`U+111C0 VIRAMA`、另一个基本#tr[character]`U+11193 GA`、基前元音`U+111B4 VOWEL SIGN I`，则重排结果为：

#[
#show regex(`\p{Sharada}+`.text): sharada

```bash
$ hb-shape NotoSansSharada-Regular.ttf '𑆨𑇀𑆓𑆴'
[Bha=0+631|virama=0+250|I=2+224|Ga=2+585]
```
]

显示为：

#figure(
  placement: none,
)[
  #sharada(size: 5em)[\u{111A8}\u{111C0}\u{11193}\u{111B4}]
]

// The i-matra has been correctly moved to before the base GA, even though it appeared after it in the input stream.
这个`i-matra` 被正确地移动到了基本#tr[character]`GA`之前。

// Pre-base *consonants*, however, are *not* reordered. If you want to put these consonants before the base in the glyph stream, you can do so by mentioning the relevant glyph in a substitution rule in the `pref` feature. For example, to move a Javanese medial ra (U+A9BF) to before the base, you create a rule like so:
但基前*辅音*不会被重排。如果你希望在#tr[glyph]流中也把它们放到基本#tr[character]前，可以通过在`pref`特性中提及相关#tr[glyph]来完成。比如我们想把 `U+A9BF JAVANESE MEDIAL RA` 移到基本#tr[character]前，则可以编写下面的规则：

```fea
feature pref {
    script java;
    sub j_Jya j_RaMed' by j_RaMed.pre;
} pref;
```

// The `j_RaMed.pre` glyph will be moved before the `j_Jya` by the shaper. When I say the glyph should be "mentioned" in a substitution rule, I do mean "mentioned"; you can, if needed, substitute a glyph *with itself*, just to tell the shaper that you would like it moved before the base. This code reorders a Tai Tham medial ra, by ensuring that the `pref` feature has "touched" it:
这样`j_RaMed.pre`就会被移动到`j_Jya`之前。我上面用的词是“提及”，它就是字面意思。如果需要的话，你也可以通过将某个#tr[glyph]#tr[substitution]为它自己的方式，来告诉#tr[shaper]你想把它移动到基本字符前。下面的代码通过在`pref`中提及了`Tai Tham Medial Ra`来确保它会被重排：

```fea
feature pref {
    script lana;
    sub uni1A55 by uni1A55;
} pref;
```

#note[
  // > In days before the Universal Shaping Engine, fonts had to cheat, by swapping the characters around using positioning rules instead. Here in Noto Sans Tai Tham, the base (TAI THAM LETTER WA) is shifted forward 540 units, while the prebase medial ra is shifted backwards 1140 units, effectively repositioning it while keeping the characters in the same order in the glyph stream:
  在通用#tr[shaping]引擎出现之前，字体需要通过使用#tr[positioning]规则来进行作弊式的#tr[character]位置交换。比如在Noto Sans Tai Tham字体中，基本#tr[character] `TAI THAM LETTER WA`向右移动了540个单位，而应显示在基本#tr[character]前的`MEDIAL RA`#tr[character]则向左移了1140个单位，在#tr[glyph]流顺序不变的情况下高效地完成了#tr[positioning]：

  #[
  #show regex(`\p{Tai Tham}+`.text): taitham

  ```bash
  $ hb-shape NotoSansTaiTham-Regular.ttf 'ᩅᩕ'
  [uni1A45=0@540,0+1103|uni1A55=0@-1140,0+100]
  ```
  ]
]

// Next, after re-ordering, positional features (`isol`, `init`, `medi`, `fina`) are applied to each cluster, and finally the usual run of substitution and positioning features are applied as normal. (See the [USE script development spec](https://docs.microsoft.com/en-us/typography/script-development/use#opentype-feature-application-ii) for the full list.)
在重排后的下一步是以#tr[cluster]为单位应用`isol`、`init`、`medi`、`fina`这几个和#tr[positioning]相关的特性。之后会执行一遍通常的#tr[substitution]和#tr[positioning]流程。（完整列表可以在通用#tr[shaping]引擎字体开发规范#[@Microsoft.DevelopingUSE]中找到。）

// The Universal Shaping Engine is a tremendous boost for those creating fonts for minority scripts; it allows font development to press ahead without having to wait for shaping engines to encode script-specific logic. However, the shaping engine still needs to hand off control of a specific script to the USE for processing, rather than handling it as a normal (non-complex) script. This means there *is* still a list of scripts within the shaping engine, and only scripts on the list get handed to the USE - or perhaps another way to put it is that the shaping engines still have script-specific routines for *some* scripts, but not for others. In fact, the list of languages which use the USE (as it were) are different between different engines - see John Hudson's [USE presentation](http://tiro.com/John/Universal_Shaping_Engine_TYPOLabs.pdf) for more details.
通用#tr[shaping]引擎对于为小语种制作字体的人来说是一个巨大的助力。他们不再需要等待#tr[shaping]引擎加入新#tr[encoding]的#tr[scripts]所需要的特殊逻辑，可以直接开始字体开发。但问题是，#tr[shaping]引擎需要决定，在接收到某种#tr[script]的文本时，它到底是使用内置知识还是使用USE流程。这就表示它还是需要一个记录哪些#tr[scripts]使用USE的内置列表。换句话说，即使实现了USE，#tr[shaping]引擎还是需要为某些#tr[scripts]保留特殊逻辑的。事实上，不同的#tr[shaping]引擎中，决定哪些语言要使用USE的列表也是不同的。关于这点你可以参考John Hudson关于USE的主题报告@Hudson.MakingFonts.2016。

// Rather than having to write a new shaper for each script, shaping engine maintainers now only have to add a line of code to the list of USE-supported scripts - but they still have to add that line of code. Supporting new scripts is easier, but not automatic. (I hope that one day, USE will become the default for new scripts, rather than the exception, but we are not there yet.)
#tr[shaping]引擎的维护人员现在只需要在USE支持的#tr[scripts]列表中添加几行代码，而不再需要为每一种新#tr[scripts]单独编写#tr[shaping]了。但几行代码也是代码，虽然不难写，不过因为有这个列表存在，支持新#tr[scripts]的流程就没法自动化。（我希望有朝一日USE能成为新#tr[scripts]的默认处理方式，而不再是像现在这样是作为一个特例存在。）

// Additionally, the USE's maximal cluster model (which allows us to produce crazy clusters such as the Balinese example above) *more or less* fits all scripts, although John Hudson has found an exception in the case of Tai Tham. In his words, "the Universal Shaping Engine turns out to be not quite universal in this sense either. But it’s pretty darn close, and is a remarkable achievement." It most certainly is.
另外，USE中构成#tr[cluster]的最复杂（也就是我们创造上面那个疯狂的巴厘文例子时使用的）模型可以说是几乎能够适用于所有#tr[scripts]。虽然John Hudson在傣曇文中发现了一个例外，但他评价说：“虽然这表明通用#tr[shaping]引擎在某些情况下并不足够通用，但它已经非常接近了。这是一个非常杰出的成就。”确实如此。

// ## Resour11ces
== 参考资料

// To finish, here is a list of resources which may help you when designing and implementing for global scripts:
我们以一个参考资料列表作为本章结尾。

这些资料也许可以在你设计和实现各种#tr[script]的字体时提供帮助：

#let bibentry(key, body, verb: [编写的]) = cite(key, form: "author") + [ ] + verb + body + cite(key, form: "normal")

- 拉丁文#tr[diacritic]设计：
  // - [The Insects Project](http://theinsectsproject.eu) - a downloadable book on issues of Central European diacritic design
  - #bibentry(<Balik.InsectsProject.2016>)[《The Insects Project》，一本关于中欧#tr[diacritic]设计的可下载电子书]
  // - [Problems of Diacritic Design for Latin script text faces](https://gaultney.org/jvgtype/typedesign/diacritics/ProbsOfDiacDesignLowRes.pdf)
  - #bibentry(<Gaultney.ProblemsDiacritic.2008>)[《Problems of Diacritic Design for Latin script text faces》]
  // - [Polish diacritics how-to](http://www.twardoch.com/download/polishhowto/index.html) (Adam Twardoch)
  - #bibentry(<Twardoch.PolishDiacritics.1999>)[《Polish diacritics how-to》文档]
  // - Filip Blažek's [Diacritics project](http://diacritics.typo.cz)
  - #bibentry(<Blazek.DiacriticsProject.2006>, verb: [制作的])[Diacritics project 网站]
  // - [Context of Diacritics](https://www.setuptype.com/x/cod/) analyses diacritics by frequency, combination and language
  - #bibentry(<Job.ContextDiacritics.2013>, verb: [制作的])[《Context of Diacritics》在线项目]，分析了#tr[diacritic]的出现频率、互相作用以及在语言中的使用
// * Danny Trương's [Vietnamese Typography](https://vietnamesetypography.com)
- #bibentry(<Truong.VietnameseTypography>)[关于越南文#tr[typography]的在线电子书《Vietnamese Typography》]
// * Guidance on specific characters:
- 关于特定#tr[character]的设计指导：
  // - [thorn and eth](https://sites.google.com/view/briem/type-design/thorn-and-eth) (Gunnlaugur Briem)
  - #bibentry(<Briem.ThornEth>, verb: [])[关于冰岛字母 thorn 和 eth 的博客文章]
  // - [Tcomma and Tcedilla](https://typedrawers.com/discussion/318/tcomma-and-tcedilla)
  - #bibentry(<PabloImpallari.TcommaTcedilla.2013>, verb: [])[在TypeDrawers论坛上关于 Tcomma 和 Tcedilla 的提问帖]
  // - [German capital sharp s](https://typography.guru/journal/capital-sharp-s-designs/), and [OpenType feature code to support it](https://medium.com/@typefacts/the-german-capital-letter-eszett-e0936c1388f8)
  - #bibentry(<Herrmann.CapitalSharp.2013>, verb: [在TypographyGuru上发表的])[关于德文中大写Sharp S的文章]，在#bibentry(<Koeberlin.GermanCapital.2017>, verb: [的Medium文章])[《The German Capital Letter Eszett》] 中有如何支持此字母的OpenType特性代码
// * Microsoft's script development specifications: [Latin, Cyrillic, Greek](https://docs.microsoft.com/en-gb/typography/script-development/standard); [Arabic](https://docs.microsoft.com/en-gb/typography/script-development/arabic); [Buginese](https://docs.microsoft.com/en-gb/typography/script-development/buginese); [Hangul](https://docs.microsoft.com/en-gb/typography/script-development/hangul); [Hebrew](https://docs.microsoft.com/en-gb/typography/script-development/hebrew); [Bengali](https://docs.microsoft.com/en-gb/typography/script-development/bengali); [Devanagari](https://docs.microsoft.com/en-gb/typography/script-development/devanagari); [Gujarati](https://docs.microsoft.com/en-gb/typography/script-development/gujarati); [Gurmukhi](https://docs.microsoft.com/en-gb/typography/script-development/gurmukhi); [Kannada](https://docs.microsoft.com/en-gb/typography/script-development/kannada); [Malayalam](https://docs.microsoft.com/en-gb/typography/script-development/malayalam); [Oriya](https://docs.microsoft.com/en-gb/typography/script-development/oriya); [Tamil](https://docs.microsoft.com/en-gb/typography/script-development/tamil); [Telugu](https://docs.microsoft.com/en-gb/typography/script-development/telugu); [Javanese](https://docs.microsoft.com/en-gb/typography/script-development/javanese); [Khmer](https://docs.microsoft.com/en-gb/typography/script-development/khmer); [Lao](https://docs.microsoft.com/en-gb/typography/script-development/lao); [Myanmar](https://docs.microsoft.com/en-gb/typography/script-development/myanmar); [Sinhala](https://docs.microsoft.com/en-gb/typography/script-development/sinhala); [Syriac](https://docs.microsoft.com/en-gb/typography/script-development/syriac); [Thaana](https://docs.microsoft.com/en-gb/typography/script-development/thaana); [Thai](https://docs.microsoft.com/en-gb/typography/script-development/thai); [Tibetan](https://docs.microsoft.com/en-gb/typography/script-development/tibetan)
- 微软为各种#tr[script]编写了字体开发规范文档，比如拉丁、西里尔、希腊字母@Microsoft.DevelopingStandard。其他文种的文档包括：阿拉伯文@Microsoft.DevelopingArabic、布吉文、韩文、希伯来文、孟加拉文、天城文@Microsoft.DevelopingDevanagari、古吉拉特文、古尔穆基文、卡纳达文、马拉雅拉姆文、奥里亚文、泰米尔文、泰卢固文、爪哇文、高棉文、老挝文、缅甸文、僧伽罗文、叙利亚文、塔纳文、泰文、藏文，均可在侧边栏目录中找到。
// * Arabic resources:
- 阿拉伯文资源：
  // - Jonathan Kew's [Notes on some Unicode Arabic characters: recommendations for usage](https://scripts.sil.org/cms/sites/nrsi/download/arabicletterusagenotes/ArabicLetterUsageNotes.pdf)
  - #bibentry(<Kew.NotesUnicode.2005>, verb: [])[向Unicode提交的提案《Notes on some Unicode Arabic characters: recommendations for usage》]
  // - [Character Requirements for a Nastaliq font](https://scriptsource.org/cms/scripts/page.php?item_id=entry_detail&uid=q5mbdr6h3b)
  - 《Character Requirements for a Nastaliq font》@Priestla.CharacterRequirements.2013
// * Indic script resources:
- 印度系#tr[scripts]资源：
  // - The Indian Type Foundry has an [annotated feature file](https://github.com/itfoundry/devanagari-shaping/blob/master/features/core/features.fea) for Devanagari.
  - #bibentry(<IndianTypeFoundry.AnnotatedFeature.2015>)[具有完善注释的天城文字体特性文件]
// * Script databases:
- #tr[scripts]数据库：
  // [Omniglot](https://www.omniglot.com) is an online encyclopedia of scripts and languages.
  - Omniglot @Ager.OmniglotEncyclopedia 是关于语言和#tr[script]的在线百科全书
  // - [ScriptSource](https://scriptsource.org/cms/scripts/page.php) is similar, but includes an annotated version of the Unicode Character Database for each codepoint. See, for example, the page about [LATIN SMALL LETTER EZH](https://scriptsource.org/cms/scripts/page.php?item_id=character_detail_use&key=U000292).
  - ScriptSource @SILInternational.ScriptSourceWriting 也是类似的网站，但它包含一个带有注解的Unicode#tr[character]数据库。例如 `LATIN SMALL LETTER EZH`的页面@SILInternational.ScriptSource.LATINEZH
  // - Eesti Keele Institute [letter database](http://www.eki.ee/letter/) tells you what glyphs you need to support particular languages.
  - #bibentry(<EestiKeeleInstituut.LetterDatabase>, verb: [])[的 letter database 网站]可以查找到每种语言需要支持哪些#tr[glyph]
