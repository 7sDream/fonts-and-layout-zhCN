#import "/template/template.typ": web-page-template
#import "/template/components.typ": note
#import "/template/lang.typ": telugu, balinese, sharada, taitham

#import "/lib/glossary.typ": tr

#show: web-page-template

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
