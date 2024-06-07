#import "/template/template.typ": web-page-template
#import "/template/components.typ": note
#import "/template/lang.typ": devanagari

#import "/lib/glossary.typ": tr

#show: web-page-template

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
