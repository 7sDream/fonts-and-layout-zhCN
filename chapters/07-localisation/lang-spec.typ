#import "/template/template.typ": web-page-template
#import "/template/components.typ": note, cross-link, title-ref, cross-ref

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## Language-specific substitutes
== 特定语言专属#tr[substitution]

// We've already mentioned the Serbian form of the letter be (б), which should appear different to the Russian Cyrillic version. This is one example of a family of *language-specific substitutes*, which we can handle more or less in the same way.
我们#cross-link(<position:serbian-letter-be>, web-path: "/chapters/05-features/lang-script.typ")[此前]提到过，塞尔维亚样式的西里尔字母`be`和俄文中的不太一样。这是按照具体语言来决定是否进行#tr[substitution]的一个需求案例，这类需求基本上都能用下面这种方式处理。

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
我们在关于Unicode的章节中的#cross-ref(<heading:normalization-decomposition>, web-path: "/chapters/03-unicode/norm-decomp.typ", web-content: [一个小节]) #title-ref(<heading:normalization-decomposition>, web-path: "/chapters/03-unicode/norm-decomp.typ", web-content: [#tr[normalization]和#tr[decompose]])里介绍过，你可以把#tr[character]é（`U+00E9 LATIN SMALL LETTER E WITH ACUTE`）#tr[decompose]为`U+0065 LATIN SMALL LETTER E` 和 `U+0301 COMBINING ACUTE ACCENT`两个#tr[character]。这听起来和我们想用一个`e`和一个用于#tr[combine]的尖音符组合成`eacute`#tr[glyph]非常类似。嗯，确实很类似，但不幸的是它们并不完全一致。

// As it happens, if your font provides a "e" and a "acutecomb" glyph but *not* a precomposed "eacute", then some text layout systems will *only* render an e-acute if the input text is decomposed to U+0065 U+0301 (which is exceptionally rare) and will use a fallback font to display the precomposed form U+00E9. Others will automatically decompose a U+00E9 in the input stream to U+0065 U+0301 and display the two glyphs correctly. Some systems will correctly substitute a precomposed glyph for its decomposition specified using the `ccmp` feature, but then will fail to position the marks properly in the `mark` feature.
在现实世界中，如果你的字体是把`e`和尖音符分开设计，而没有提供预#tr[compose]的`eacute`的话，那么有些排版系统就只会在输入的文本是 `U+0065 U+0301` 时（这种情况非常罕见）才能正确渲染出#tr[compose]字形。如果它遇到`U+00E9`，就只能使用回退字体来显示了。还有些软件会将用户输入文本中的 `U+00E9` 自动#tr[decompose]为 `U+0065 U+0301`，然后正确显示这两个#tr[glyph]。也有些软件能够调用`ccmap`特性中的规则，将预#tr[compose]#tr[character]#tr[substitution]为它们的#tr[decompose]#tr[glyph]，但却无法使用`mark`特性将它们正确定位。

// But having a precomposed glyph in the font will always work, both for composed Unicode characters like U+00E9 *and* for its decompositions, so that's why having the font contain all the glyphs you are likely to support is a better way to go.
但直接在字体里包含一个预#tr[compose]的#tr[glyph]在所有情况下都能正常工作，无论输入的Unicode#tr[character]是`U+00E9`还是其#tr[decompose]形式均可。所以直接在字体里放入所有希望支持的#tr[glyph]是一种更好的方式。
