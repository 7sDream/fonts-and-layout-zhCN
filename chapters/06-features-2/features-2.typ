#import "/template/consts.typ"
#import "/template/heading.typ": chapter
#import "/template/components.typ": note
#import "/template/lang.typ": arabic, arabic-amiri, hind, thai

#import "/lib/glossary.typ": tr

#chapter(
  label: <chapter:substitution-positioning>
)[
  // Substitution and Positioning Rules
  替换和定位规则
]

// As we have seen, OpenType Layout involves first *substituting* glyphs to rewrite the input stream, and then *positioning* glyphs to put them in the right place. We do this by writing collections of *rules* (called lookups). There are several different types of rule, which instruct the shaper to perform the substitution or positioning in subtly different ways.
从上一章我们知道，OpenType的#tr[layout]过程有两个阶段，首先是#tr[substitution]规则将输入的#tr[glyph]流重写，然后是#tr[positioning]规则将#tr[glyph]们安排到正确的位置上。我们通过编写规则集（也就是#tr[lookup]）可以控制这一过程。而规则有不同的类型，它们用不同的方式执行具体的#tr[substitution]和#tr[positioning]操作。

// In this chapter, we'll examine each of these types of rule, by taking examples of how they can be used to layout global scripts. In the next chapter, we'll look at things the other way around - given something we want to do with a script, how can we get OpenType to do it? But to get to that stage, we need to be familiar with the possibilities that we have at our disposal.
在本章中，我们将会介绍所有类型的规则，并举例说明它们在处理#tr[global scripts]的#tr[layout]过程中起到了什么作用。下一章开始则会换一个方向，介绍在给定某种#tr[script]的条件下，OpenType是如何处理它的。但在开始灵活运用之前，我们首先要足够了解工具箱中的各种工具。

// Types of Substitution Rule
== 各种类型的#tr[substitution]规则<section:substitution-rule-types>

// The simplest type of substitution feature available in the `GSUB` table is a single, one-to-one substitution: when the feature is turned on, one glyph becomes another glyph. A good example of this is small capitals: when your small capitals feature is turned on, you substitute "A" by "A.sc", "B" by "B.sc" and so on. Arabic joining is another example: the shaper will automatically turn on the `fina` feature for the final glyph in a conjoined form, but we need to tell it which substitution to make.
`GSUB`表中最简单的#tr[substitution]特性是一换一#tr[substitution]。当这类特性开启时会让某个#tr[glyph]变成另一个。我们之前介绍过的小型大写字母特性会把`A`变成`A.sc`，把`B`变成`B.sc`，这就是一个不错的例子。另一个例子是阿拉伯文中的连体变形，#tr[shaper]会自动为连体形式的尾部#tr[glyph]打开`fina`特性，我们就在这个特性里编写规则来告诉#tr[shaper]需要如何进行#tr[substitution]。

// The possible syntaxes for a single substitution are:
一换一#tr[glyph]替换的语法有如下几种：

```fea
sub <glyph> by <glyph>;
substitute <glyphclass> by <glyph>;
substitute <glyphclass> by <glyphclass>;
```

// The first form is the simplest: just change this for that. The second form means "change all members of this glyph class into the given glyph". The third form means "substitute the corresponding glyph from class B for the one in class A". So to implement small caps, we could do this:
第一种形式最简单，就是把一个#tr[glyph]换成另一个。第二种形式的含义是将某个#tr[glyph]类中的所有成员都换成给定的#tr[glyph]。第三种形式表示用B#tr[glyph]类中的对应#tr[glyph]#tr[substitution]A类中相同位置的#tr[glyph]。所以，我们可以这样实现小型大写字母特性：

```fea
feature smcp {
  substitute [a-z] by [A.sc - Z.sc];
}
```

// To implement Arabic final forms, we would do something like this:
而阿拉伯字母的词尾形式可以这样实现：

```fea
feature fina {
    sub uni0622 by uni0622.fina; # Alif madda
    sub uni0623 by uni0623.fina; # Alif hamza
    sub uni0624 by uni0624.fina; # Waw hamza
    ...
}
```

// Again, in these particular situations, your font editing software may pick up on glyphs with those "magic" naming conventions and automatically generate the features for you. Single substitutions are simple; let's move on to the next category.
值得一提的是，在这些特定的例子中，你的字体编辑软件可能会根据#tr[glyph]的这种“约定俗成”的命名方式自动为你生成对应的特性。一换一#tr[substitution]就是这么简单，我们继续来看下一类吧。

// ### Multiple substitution
=== #tr[multiple substitution]

// Single substitution was one-to-one. Multiple substitution is one-to-many: it decomposes one glyph into multiple different glyphs. The syntax is pretty similar, but with one thing on the left of the `by` and many things on the right.
一换多#tr[substitution]可以看作将一个#tr[glyph]分解为了几个不同的#tr[glyph]。语法和上面的差不多，只是在 `by` 前面只有一个#tr[glyph]，而在后面有多个。

// This can be useful if you have situations where composed glyphs with marks are replaced by a decomposition of another glyph and a combining mark. For example, sticking with the Arabic final form idea, if you haven't designed a specific glyph for alif madda in final form, you can get around it by doing this:
这种类型在处理带符号的#tr[glyph]时比较有用，你可以将它分解为独立的主体#tr[glyph]和符号#tr[glyph]。比如还是阿拉伯文中的例子，如果你没有专门为词尾形式的 alif madda 设计#tr[glyph]，你可以这样处理它：

```fea
feature fina {
    # Alif madda -> final alif + madda above
    sub uni0622 by uni0627.fina uni0653;
}
```

// This tells the shaper to split up final alif madda into two glyphs; you have the final form of alif, and so long as your madda mark is correctly positioned, you are essentially synthesizing a new glyph out of the two others.
这段规则告诉#tr[shaper]将词尾的 alif madda 分成两个#tr[glyph]。假设你已经设计好了词尾形式的 alif，那么你只要保证 madda 符号的正确#tr[positioning]，就可以通过这种方式来合成一个新#tr[glyph]了。

// In fact, when engineering Arabic fonts, it can be extremely useful to separate the dots (*nukta*) from the base glyphs (*rasm*). This allows you to reposition the dots independently of the base characters, and it can reduce the number of glyphs that you need to design and write rules for, as you only need to draw and engineer the "skeleton" form for each character.
在实际的阿拉伯字体工程中，将点号（nukta）和其他的基本#tr[glyph]（被称为rasm）分开处理是非常有效的。这允许你只需要绘制每个字符的基础骨架，再单独进行点的#tr[positioning]。这可以减少实际需要设计的#tr[glyph]和编写的规则数量。

// To do this, you would add empty glyphs to the font so that the Unicode codepoints can be mapped properly, but have the outline provided by other glyphs substituted in the `ccmp` (glyph composition and decomposition feature). For example, we can provide the glyph ز (zain) by having an empty `zain-ar` glyph mapped to codepoint U+0632, but in our `ccmp` feature do this:
为了使用这个方案，你需要在字体中将某些Unicode#tr[codepoint]映射到空白的#tr[glyph]。这些#tr[glyph]本身没有#tr[outline]，而是通过在`ccmp`（#tr[glyph]组合/分解）特性中将它们#tr[substitution]成其他#tr[glyph]来完成显示。例如我们想支持 zain #tr[glyph]，我们可以将 `U+0632` 映射到一个空白的 `zain-ar` #tr[glyph]，然后在`ccmp`特性中写上：

```fea
feature ccmp {
  sub zain-ar by reh-ar dot-above;
} ccmp;
```

// With this rule applied, we now no longer need to deal with zain as a special case - any future rule which applies to reh will deal correctly with the zain situation as well, so you have fewer "letters" to think about.
一旦这条规则应用，我们就不需要专门处理 zain #tr[character]了，任何处理 reh 的规则都可以顺便处理 zain。这样你需要考虑的字母就可以少一些了。

// ### Alternate substitution
=== #tr[alternate substitution]

// After one-to-many, we have what OpenType calls "one from many"; that is, one glyph can be substituted by *one out of a set of* glyphs. On the face of it, this doesn't make much sense - how can the engine choose which "one out of the set" it should substitute? Well, the answer is: it doesn't. This substitution is designed for features where the shaping engine is expected to pass a set of glyphs to the user interface, so that the user can choose which one they want.
除了一换多之外，OpenType中还支持一种“多选一”#tr[substitution]，也即可以将一个#tr[glyph]替换为“集合中的某一个”其他#tr[glyph]。第一次知道这种功能时可能会觉得它没什么意义，毕竟排版引擎怎么知道到底应该#tr[substitution]成集合中的哪个#tr[glyph]呢？答案是它根本不做选择。这个功能的实际设计思路是，#tr[shaper]引擎需要将这一系列#tr[glyph]提供给上层用户界面，让用户来选择想要哪一个。

// One such feature is `aalt`, "access all alternates", which is used by the "glyph palette" window in various pieces of design software. The idea behind this feature is that a user selects a glyph, and the design software asks the shaping engine to return the set of all possible glyphs that the user might want to use instead of that glyph - all the different swash, titling, small capitals or other variants:
`aalt`（All Alternates，所有备选）就是一个这样的特性。在各个设计软件中，用户选择了某个#tr[glyph]时，软件会向#tr[shaper]引擎询问用户实际想要的可能是哪些#tr[glyph]，并把这些比如花体、标题字或者小型大写字母等变体的#tr[glyph]显示在一个称为#tr[glyph]样式版的窗口中。

```fea
feature aalt {
  sub A from [A.swash A.ss01 A.ss02 A.ss03 A.sc];
  sub B from [B.swash B.ss01 B.ss02 B.ss03 B.sc];
  ...
}
```

// Again, this is the sort of thing your font editor might do for you automatically (this is why we use computers, after all).
同样，字体编辑软件也可能会自动实现这个特性。（毕竟这就是我们使用计算机的原因嘛。）

// Another use of this substitution comes in mathematics handling. The `ssty` feature returns a list of alternate glyphs to be used in superscript or subscript circumstances: the first glyph in the set should be for first-level sub/superscripts, and the second glyph for second-level sub/superscripts. (Any other glyphs returned will be ignored, as math typesetting models only recognise two levels of scripting.)
另一个可能用到这种#tr[substitution]类型的场景是数学公式的处理。`ssty`特性会为一个#tr[glyph]提供多种用于上标或下标处的变体。其中第一个#tr[alternate glyph]用于第一级的上下标，第二个#tr[alternate glyph]用于第二级。（后续的其他#tr[glyph]会被忽略，因为数学排版模型中只使用两层上下标。）

#note[
  // > If you peruse the registered feature tags list in the OpenType specification you might find various references to features which should be implemented by GSUB lookup type 3, but the dirty little secret of the OpenType feature tags list is that many of the features are, shall we say... *aspirational*. They were proposed, accepted, and are now documented in the specification, and frankly they seemed like a really good idea at the time. But nobody ever actually got around to implementing them.
  如果你仔细阅读 OpenType 规范中已注册的特性标签列表，也许会发现很多需要用 GSUB lookup type 3 实现的特性。但关于这个特性列表有个隐含的小秘密，那就是其中很多特性都……怎么说呢，都太理想化了。它们作为提案是被接受了的，所以现在被写进了规范文档中。而且坦率地说，这些特性看起来都设计得非常好。但实际上没人真的有时间去实现它们。

  // > The `rand` feature, for example, should perform randomisation, which ought to be an excellent use case for "choose one glyph from a set". The Harfbuzz shaper has only recently implemented that feature, but we're still waiting for any application software to request it. Shame, really.
  比如`rand`特性，它用来产生随机效果，听起来像是“从一些#tr[glyph]中选一个”这类规则绝佳的用武之地。但 HarfBuzz #tr[shaper]直到最近才刚刚实现了对这一特性的支持，而且我们还在等待能有应用程序实际使用它。这真的有些惭愧。
]

// ### Ligature substitution
=== #tr[ligature]#tr[substitution]

// We've done one to one, and we've done one to many - *ligature substitution* is a many-to-one substitution. You substitute multiple glyphs on the left `by` the one on the right.
我们介绍完了一换一和一换多，现在该来介绍#tr[ligature]这种多换一#tr[substitution]了。它可以将`by`左边的多个#tr[glyph]#tr[substitution]为右边的一个#tr[glyph]。

// The classic example for Latin script is how the two glyphs "f" and "i" become the single glyph "fi", but we've done that one already. In the Khmer script, when two consonants appear without a vowel between them, the second consonant is written below the first and in a special form. This consonant stack is called a "coeng", and the convention in Unicode is to encode the stack as CONSONANT 1, U+17D2 KHMER SIGN COENG, CONSONANT 2. (You need the explicit coeng because Khmer is written without word boundaries, and a word-ending consonant followed by a word-beginning consonant shouldn't trigger a stack.)
这里最经典的例子就是拉丁文中将f和i转换成单个#tr[glyph]fi，但这个例子我们已经讲过了。我们这里换一个高棉文的例子：当高棉文的两个辅音中间没有元音时，第二个辅音需要被写成比第一个略低的特殊形式。这种特殊的堆叠形式称为 “coeng”，Unicode编码这一行为的方式是 `CONSONANT 1, U+17D2 KHMER SIGN COENG, CONSONANT 2`。（因为高棉文是没有分词的，而一个词末尾的辅音和下一个词开头的辅音并不触发coeng堆叠形式，所以我们需要显式的写出这个符号。）

// So, whenever we see U+17D2 KHMER SIGN COENG followed by a consonant, we should transform this into the special form of the consonant and tuck it below the base consonant.
所以当看见 `U+17D2 KHMER SIGN COENG`后面跟着一个辅音时，就需要把这个辅音改成特殊形式，然后把它放在基本辅音的下方。

#figure(
  placement: none,
)[#include "khmer.typ"]

// As you can see from the diagram above, the first consonant doesn't change; we just need to transform the coeng sign plus the second consonant into the coeng form of that consonant, and then position it appropriately under the first consonant. We know how to muck about with positioning, but for now we need to turn those two glyphs into one glyph. We can use a ligature substitution lookup to do this. We create a `rlig` (required ligature) feature, which is a ligature that is "required to be used in normal conditions" and "important for some scripts to insure correct glyph formation", and replace the two glyphs U+17D2 KHMER SIGN COENG plus a consonant, with the coeng forms:
从上述流程图可以看出，第一个辅音没有改变。我们只需要将coeng符号和在其后的第二个辅音变成对应的coeng形式，然后放到第一个辅音下方的合适位置。我们知道如何调整位置，但首先我们得将后两个#tr[glyph]变成一个，这就需要用到#tr[ligature]#tr[substitution]#tr[lookup]。我们创建 `rlig`（必要#tr[ligature]）特性，这个特性中的#tr[ligature]是“必须在通常情况下开启”和“用于确保某些#tr[scripts]中的#tr[glyph]被正确处理”的。在这个特性中我们编写规则将 `U+17D2 KHMER SIGN COENG` 和其后的一个辅音一起转换成coeng形式：

```fea
feature rlig {
  sub uni17D2 uni1780 by uni1780.coeng;
  sub uni17D2 uni1781 by uni1781.coeng;
  #...
}
```

// In the next chapter, we'll explore in the next chapter why, instead of ligatures for Arabic rules, you might want to use the following lookup type instead: contextual substitutions.
在下一章中我们会研究阿拉伯文，并介绍为什么它的#tr[ligature]需要使用另一种#tr[substitution]类型，#tr[contextual]#tr[substitution]。

/// ### Chaining Substitutions
=== #tr[chaining substitution]

// The substitutions we've seen so far have applied globally - whenever the input glyph matches the rule, the substitution gets made. But what if we want to say that the rule should only apply in certain circumstances?
我们之前介绍的#tr[substitution]都是全局的，也就是只要输入#tr[glyph]匹配规则，#tr[substitution]就一定会发生。但如果我们希望某条规则只在特定情况下应用呢？

// The next three lookups do just this. They set the *context* in which a rule applies, and then they specify another lookup or lookups which are invoked at the given positions. The context is made up of what comes before the sequence we want to match (the prefix, or *backtrack*), the input sequence and lookups, and what comes after the input sequence (the suffix, or *lookahead*).
后面就要介绍三个这样的#tr[lookup]。它们关注规则匹配时的上下文，并且可以在给定位置调用另一个（或一些）查询组。上下文由匹配部分前的内容（称为前缀，也叫*回溯*）、整个输入序列、#tr[lookup]、匹配部分后的内容（称为后缀，也叫*前瞻*）四部分组成。

// Let's take a couple of examples to explain this concept. We'll start with a Latin one, taken from the [Libertinus](https://github.com/alif-type/libertinus) fonts. When a Latin capital letter is followed by an accent, then we want to substitute *some* of those accents by specially designed forms to fit over the capitals:
让我们来用于一些例子来解释这个概念。首先我们看一个Libertinus字体#[@Maclennan.Libertinus.2013]中的拉丁文的例子。当拉丁文大写字母后跟一个音调符号时，我们希望为其中某些音调符号设计一些和前面的字母更加贴合的特殊样式：

```fea
@capitals = [A B C D E F G H I J K L M N O P Q R S U X Z...];
@accents  = [gravecomb acutecomb uni0302 tildecomb ...];

lookup ccmp_cap_accents {
  sub acutecomb by acute.cap;
  sub gravecomb by grave.cap;
  sub uni0302 by circumflex.cap;
  sub uni0306 by breve.cap;
} ccmp_cap_accents;

feature ccmp {
    sub @capitals @accents' lookup ccmp_cap_accents;
} ccmp;
```

// What this says is: when we see a capital followed by an accent, we're going to substitute the accent (it's the replacement sequence, so it gets an apostrophe). But *how* we do the substitution depends on another lookup we now reference: acute accents for capital acutes, grave accents for capital graves, and so on. The tilde accent does not have a capital form, so is not replaced.
这段代码的含义是，当大写字母后跟着音调符号时，#tr[substitution]这些音调符号（参与替换的序列后面需要加一个撇号）。但具体怎么#tr[substitution]则取决于这条规则引用的另一个#tr[lookup]，这里使用的#tr[lookup]将尖音符、重音符等都替换为适合大写的形式。波浪号没有大写形式，所以不会被替换。

// We can also use this trick to perform a *many to many* substitution, which OpenType does not directly support. In Urdu the `yehbarree-ar.fina` glyph "goes backwards" with a large negative right sidebearing, and if not handled carefully can bump into glyphs behind it. When `threedotsdownbelow-ar` occurs before a `yehbarre-ar.fina`, we want to insert an `extender` glyph to give a little more room for the dots. Here's what we want to achieve:
我们可以使用一些技巧来用这种方式做到OpenType当前不支持的多换多#tr[substitution]。在乌尔都语中，`yeharree-ar.fina`#tr[glyph]有一个巨大的负右#tr[sidebearing]。如果处理不当的话，它可能会导致显示位置向回走到上一个#tr[glyph]去。当 `yehbarre-ar.fina`前面出现`threedotsdownbelow-ar`#tr[glyph]时，我们希望通过插入一个扩充#tr[glyph]来让这些点有足够的空间可以显示。这个功能可以这么表述：

```fea
feature rlig {
lookup bari_ye_collision {
   sub threedotsdownbelow-ar yehbarree-ar.fina by threedotsdownbelow-ar extender yehbarree-ar.fina;
} bari_ye_collision;
} rlig;
```

// But of course we can't do this because OpenType doesn't support many-to-many substitutions. This is where chaining rules come in. To write a chaining rule, first we create a lookup which explains *what* we want to do:
但我们没法这么做，因为OpenType不支持多换多#tr[substitution]，这就是#tr[chaining rules]有用的地方了。首先需要创建一个描述我们具体想做什么的#tr[lookup]：

```fea
lookup add_extender_before {
   sub yehbarree-ar.fina by extender yehbarree-ar.fina;
} add_extender_before;
```

然后，创建一个表示在什么时候需要做这件事的#tr[lookup]：

```fea
feature rlig {
lookup bari_ye_collision {
  sub threedotsdownbelow-ar yehbarree-ar.fina' lookup add_extender_before;
} bari_ye_collision;
} rlig;
```

// Read this as "when a `threedotsdownbelow-ar` precedes a `yehbarree-ar.fina`, then call the `add_extender_before` lookup." This lookup applies to that `yehbarree-ar.fina` glyph and replaces it with `extender yehbarree-ar.fina`, giving the dots a bit more space.
上面这段代码可以理解为：当 `threedotsdownbelow-ar` 后跟着 `yehbarree-ar.fina` 时，调用 `add_extender_before` #tr[lookup]。这个#tr[lookup]应用于`yehbarree-ar.fina`#tr[glyph]，将它替换为 `extender yehbarree-ar.fina`，从而给前面的点提供更多空间。

// Let's take another example from the Amiri font, which contains many calligraphic substitutions and special forms. One of these substitutions is that the sequence beh rah (بر) *and all similar forms based on the same shape* is replaced by another pair of glyphs with a better calligraphic cadence. (Actually, this needs to be done in two cases: when the beh-rah is at the start of the word, and when it is at the end. But we're going to focus on the one where it is at the end.) How do we do this?
接下来看一个Amiri字体中的例子。这个字体包含很多用于模拟书法和特殊形态的#tr[substitution]，其中之一是将 `beh rah`（#arabic[بر]）（以及所有与此具有相同结构的类似构体）替换为更有书法感的另一对#tr[glyph]。确切的说，这个功能需要处理两种情况，一种是 `beh rah` 在开头，一种在结尾。但这里我们就只关注在结尾的形式。这个功能要如何完成呢？

// First, we declare our feature and say that we're not interested in mark glyphs. Then, when we see a beh-like glyph (which includes not only beh, but yeh, noon, beh with three dots, and so on) in its medial form and a rah-like glyph (or jeh, or zain...) in its final form, then *both* of those glyphs will be subject to a secondary lookup.
首先，我们定义一个特性，让它不关系符号#tr[glyph]。然后当出现类似 `beh` #tr[glyph]（并不只是 `beh`，也包括`yeh`、`noon`、带三个点的`beh`等）的词中形式和类似`rah`#tr[glyph]（如`jeh`、`zain`等）的词尾形式时，这两个#tr[glyph]都需要被另一个#tr[lookup]处理。

```fea
@aBaa.medi = [ uni0777.medi uni0680.medi ]; # and others ...
@aRaa.fina = [ uni0691.fina uni0692.fina ]; # and others ...

feature calt {
  lookupflag IgnoreMarks;
  sub [@aBaa.medi]' lookup BaaRaaFina
      [@aRaa.fina]' lookup BaaRaaFina;
} calt;
```

// The secondary lookup will turn beh-like glyphs into a beh-rah ligature form of beh, and all of the rah-like glyphs into a beh-rah ligature form of rah:
后一个#tr[lookup]将会把类似`beh`的#tr[glyph]转换为它在`beh-rah`#tr[ligature]中的形式，对于类似`rah`的字形也是同理：

```fea
lookup BaaRaaFina {
  sub @aBaa.medi by @aBaa.medi_BaaRaaFina;
  sub @aRaa.fina by @aRaa.fina_BaaRaaFina;
} BaaRaaFina;
```

// Because this lookup will only be executed when beh and rah appear together, and because it will be executed twice in the rule we gave above, it will change both the beh-like glyph *and* the rah-like glyph for their contextual calligraphic variants.
因为这个#tr[lookup]只会在 `beh` 和 `rah` 一起出现时才被使用，而且会被使用两次，所以它会把类似 `beh` 和 `rah` 的字符都转换为其对应的书法变体。

// Let's try another example from another script, with a slightly different syntax. Devanagari is an abugida script, where each consonant has an implicit vowel "a" sound. If you want to change that vowel, you precede the consonant with a *matra*. The "i" matra looks a little bit like the Latin letter f, but its hook is normally designed to stretch across the length of the consonant it follows and "point to" the stem of the consonant. Of course, this gives us a problem: the consonants have differing widths. What we need to do, then, is design a bunch of i-matra glyphs of different widths, and when i-matra is followed by a consonant, substitute it by the variant matra glyph with the appropriate width. For example:
再来看看另一种#tr[script]中的例子，这次的语法会略有不同。天城文是一种元音附标#tr[script]，它的所有辅音都有一个隐含的元音a。如果需要改变这个元音，需要在辅音前添加一个`matra`。表示i的`matra`看上去有点像拉丁字母 f，不过它的长度需要根据附加到的辅音的长度进行拉伸，以保证它指向辅音的#tr[stem]。当然这存在一个问题，辅音的宽度也是不一样的。所以我们需要设计一系列不同宽度的 `i-matra` #tr[glyph]。当 `i-matra` 跟着一个辅音时，需要被#tr[substitution]为合适宽度的变体形式。例如这样：

```fea
@width1_consonants = [ra-deva rra-deva];
@width2_consonants = [ttha-deva tha-deva];
@width3_consonants = [ka-deva nga-deva]; # and others ...
# ...

feature pres {
  lookup imatra {
    sub iMatra-deva' @width1_consonants by iMatra-deva.1;
    sub iMatra-deva' @width2_consonants by iMatra-deva.2;
    sub iMatra-deva' @width3_consonants by iMatra-deva.3;
    #...
  } imatra;
} pres;
```

// Notice that here we are using a syntax which allows us to define both the "what we want to do" lookup (the substitution) and the "when we want to do it" lookup in the same line. The feature compiler will implicitly convert what we have written to:
注意这里我们用了另一种语法，它允许我们在“何时进行”的#tr[lookup]的规则行中直接定义“想做什么”的#tr[lookup]。编译器会将这段代码转换为：

```fea
lookup i1 { sub iMatra-deva' by iMatra-deva.1 } i1;
lookup i2 { sub iMatra-deva' by iMatra-deva.2 } i2;
lookup i3 { sub iMatra-deva' by iMatra-deva.3 } i3;

feature pres {
  lookup imatra {
    sub iMatra-deva' lookup i1 @width1_consonants;
    sub iMatra-deva' lookup i2 @width2_consonants;
    sub iMatra-deva' lookup i3 @width3_consonants;
    # ...
  } imatra;
} pres;
```

#note[
  // > Again I would encourage you to use the more explicit syntax yourself in all but the simplest of cases to avoid surprises.
  我依旧建议你尽量使用明确的语法来避免奇怪的问题，但这种最简单的情况可以例外。
]

// We put this in the `pres` (pre-base substitution) feature, which is designed for substituting pre-base vowels with their conjunct forms, and is normally turned on by shapers when handling Devanagari. The following figure shows the effect of the feature above:
我们将这些规则放在 `pres`（基本字符前部#tr[substitution]）特性中，这个特性专门用于将在基本字符前的元音替换为其连接形式，在处理天城文时#tr[shaper]通常会启用它。下图展示了上述特性的效果：

#figure(
  placement: none,
)[#include "i-matra.typ"] <figure:i-matra>

// In some cases, you may want to forego a substitution or set of substitutions in particular contexts. For example, in Malayalam, the sequence ka, virama, sa) should appear as a stacked Akhand character "Kssa" - except if the sa is followed by certain vowel sounds which change the form of the sa.
在某些场景中，可能希望根据上下文的情况放弃某个#tr[substitution]。比如在马拉雅拉姆文中，序列`ka virama sa`应该被堆叠显示为一个不可分#tr[character]`Kssa`。但如果这个 `sa` 后面跟着的是几个特殊元音的话，就不能使用堆叠形式，而是要去改变这个`sa`的形式。

#figure(
  placement: none,
)[#include "manjari.typ"]

// We'll achieve this in two steps. First, we'll put a contextual rule in the `akhn` feature to make the Kssa conjunct. Even though this is a simple substitution we need to write it in the contextual form (using apostrophes, but with an empty backtrack and empty lookahead):
我们可以通过两步来达成这个效果。首先，我们在 `akhn` 特性中加入组建Kass#tr[character]的上下文规则。虽然这就是一个很简单的操作，我们也得用#tr[contextual]#tr[substitution]：

```fea
feature akhn {
  sub ka-malayalam' halant-malayalam' sa-malayalam' by kssa;
}
```

// This creates the kssa akhand form. Now we need another rule to say "but if you see ka, virama, sa and then a matra, don't do that substitution." To do this, we use the `ignore` keyword:
这样 Kssa 的不可分形式就创建好了。接下来我们需要另一个规则，使 `ka virama sa` 后面是 `marta` 的时候上述组成 `Kssa` 的#tr[substitution]不要进行。这里需要使用 `ignore` 关键字：

```fea
@matras = [uMatra-malayalam uuMatra-malayalam ...];

feature akhn {
  ignore sub ka-malayalam' halant-malayalam' sa-malayalam' @matras;
  sub ka-malayalam' halant-malayalam' sa-malayalam' by kssa;
}
```

// This `ignore` rule ends processing of the current lookup if the context matches. You can have multiple `ignore` rules: once one of them is matched, processing of the current lookup is terminated. For instance, we also want to forego the akhand form in the sequence "ksra" (because we're going to want to use the "sra" ligature in that sequence instead):
一个#tr[lookup]内可以有多条`ignore`规则，一旦某条`ignore`规则匹配成功，它会结束当前#tr[lookup]的处理流程。比如，当序列是`ksra`时，就不能组成不可分的`kssa`#tr[character]，因为此时我们希望使用 `sra` #tr[ligature]：

```fea
feature akhn {
  ignore sub ka-malayalam' halant-malayalam' sa-malayalam' @matras;
  ignore sub ka-malayalam' halant-malayalam' sa-malayalam' halant-malayalam' 'ra-malayalam;
  sub ka-malayalam' halant-malayalam' sa-malayalam' by kssa;
}
```

// We said that `ignore` only terminates processing of a *lookup*. If you only want to skip over a given number of rules, but consider later rules in the same feature, you need to isolate the relevant `ignore`/`sub` rules inside their own lookup:
但要注意 `ignore` 只会终止当前的*#tr[lookup]*。如果你想跳过一些规则，让当前特性中的其他规则继续尝试匹配，你需要把 `ignore/sub` 规则放在独立隔离的#tr[lookup]中：

```fea
feature akhn {
  lookup Ksa {
    ignore sub ka-malayalam' halant-malayalam' sa-malayalam' @matras;
    ignore sub ka-malayalam' halant-malayalam' sa-malayalam' halant-malayalam' 'ra-malayalam;
    sub ka-malayalam' halant-malayalam' sa-malayalam' by kssa;
    # "ksra" 被忽略了
  }
  # 但这里的规则还会继续尝试匹配
}
```

// We can combine contextual substitutions with lookup flags for situations when we want the context to only be interested in certain kinds of glyph. For example, the Arabic font [Amiri](https://github.com/alif-type/amiri) has an optional stylistic feature whereby if the letter beh follows a waw or rah (for example, in the word ربن - the name "Rabban", or the word "ribbon" in Urdu) then the nukta on the beh is dropped down:
在#tr[contextual]#tr[substitution]的#tr[lookup]中也可以使用#tr[lookup]选项，让它只关心特定种类的#tr[glyph]。比如，阿拉伯字体Amiri#[@Maclennan.Amiri.2015]支持一个可选样式 `ss01`。当此样式开启时，只要`beh`后是`waw`或者`rah`（比如 #arabic[ربن] 就符合描述，它表示姓名Rabban，或者乌尔都单词ribbon），那么就会把 `beh` 的点形变音符号往下落一些，见@figure:amiri-beh。

#figure(
  caption: [Amiri字体中的可选样式]
)[#include "amiri-beh.typ"] <figure:amiri-beh>

我们现在知道怎么实现它：

```fea
feature ss01 {
  sub @RaaWaw @aBaaDotBelow' by @aBaaLowDotBelow;
} ss01;
```

// The problem is that the text might be vocalised. We still want this rule to apply even if, for example, there is a fatah placed above the rah (رَبَن). We could, of course, attempt to write a context which would apply to rah and waw plus marks all possible combinations of the mark characters, but the easier solution is to tell the shaper that we are not interested in mark characters when applying this rule, only base characters - another use for lookup flags.
这样写的问题是没有考虑文本中的变音符号。我们希望，例如在 `rah` 上有 `fatah` 符号时（#arabic[رَبَن]），这个规则依然能够匹配上。当然，我们可以尝试去写一条匹配`rah` + `waw` + 任何可能符号的规则，但处理这种情况的最简单方法就是告诉#tr[shaper]在处理这条规则时我们不关心符号#tr[character]。#tr[lookup]选项大显身手的时候到了。

```fea
feature ss01 {
  lookupflag IgnoreMarks;
  sub @RaaWaw @aBaaDotBelow' by @aBaaLowDotBelow;
} ss01;
```

// ### Extension Substitution
=== 扩展#tr[substitution]

// An extension substitution ("GSUB lookup type 7") isn't really a different kind of substitution so much as a different *place* to put your substitutions. If you have a very large number of rules in your font, the GSUB table will run out of space to store them. (Technically, it stores the offset to each lookup in a 16 bit field, so there can be a maximum of 65535 bytes from the lookup table to the lookup data. If previous lookups are too big, you can overflow the offset field.)
扩展#tr[substitution]（也被称为 `GSUB lookup type 7`）并不和其他类型那样是另一种#tr[substitution]方法，而更像是另一个可以放置#tr[substitution]的位置。如果字体中有大量规则，`GSUB`表可能的储存空间可能会用完。（技术上的原因是，表示#tr[lookup]位置的偏移量是一个16位的数字，所以储存#tr[lookup]的整个数据表不能超过65525字节。如果#tr[lookup]太大，可能会让偏移量字段溢出。）

// Most of the time you don't need to care about this: your font editor may automatically use extension lookups; in some cases, the feature file compiler will rearrange lookups to use extensions when it determines they are necessary; or it may not support extension lookups at all. But if you are getting errors and your font is not compiling because it's running out of space in the GSUB or GPOS table, you can try adding the keyword `useExtension` to your largest lookups:
大多数时候你不需要为此操心，字体编辑软件会在需要时自动使用扩展#tr[lookup]。特性文件编译器可能会重排#tr[lookup]，并在觉得必要时让其中一些使用扩展方式，或者也有可能不支持扩展#tr[lookup]。但如果在编译字体时出现`GSUB`或`GPOS`表空间不足的错误提示，你可以尝试给最大的#tr[lookup]添加一个`useExtension`关键字：

```fea
lookup EXTENDED_KERNING useExtension {
  # 大量字偶矩规则
} EXTENDED_KERNING;
```

#note[
  // > Kerning tables are obviously an example of very large *positioning* lookups, but they're the most common use of extensions. If you ever get into a situation where you're procedurally generating rules in a loop from a scripting language, you might end up with a *substitution* lookup that's so big it needs to use an extension. As mention in the previous chapter `fonttools feaLib` will reorganise rules into extensions automatically for you, whereas `makeotf` will require you to place things into extensions manually - another reason to prefer `fonttools`.
  虽然`kern`表确实是扩展#tr[lookup]最常见的用例，但显然其中可能会数量超限的其实是#tr[positioning]规则。#tr[substitution]规则太多的情况也是有可能的，比如为某种复杂的#tr[script]系统开发字体时，需要使用程序生成的方式编写规则，最终可能会因为产生了一个巨大的#tr[substitution]#tr[lookup]，从而需要使用扩展方式。上一章中到的`fontTools feaLib`工具会自动将规则重新组织为扩展#tr[lookup]，而`makeotf`需要你手动处理它们。这也是更推荐用`fontTools`的另一个原因。
]

// ### Reverse chained contextual substitution
=== 逆向#tr[chaining]#tr[substitution]

// The final substitution type is designed for Nastaliq style Arabic fonts (often used in Urdu and Persian typesetting). In that style, even though the input text is processed in right-to-left order, the calligraphic shape of the word is built up in left-to-right order: the form of each glyph is determined by the glyph which *precedes* it in the input order but *follows* it in the writing order.
最后一个#tr[substitution]类型是为波斯体的阿拉伯文字体设计的，通常用于乌尔都或波斯文的#tr[typeset]中。在这种书体中，虽然输入文本是按从右向左的方式处理的，但词语在书法上的形状需要按照从左向右的顺序构建。因为每个#tr[glyph]的样式需要根据在输入文本中之前、书写顺序上是之后的那个#tr[glyph]决定。

// So reverse chained contextual substitution is a substitution that is applied by the shaper *backwards in time*: it starts at the end of the input stream, and works backwards, and the reason this is so powerful is because it allows you to contextually condition the "current" lookup based on the results from "future" lookups.
逆向#tr[chaining]#tr[contextual]#tr[substitution]是一种会被#tr[shaper]在时间上反向应用的#tr[substitution]。它会从输入流的末尾开始，从后向前进行工作。它功能强大的原因是允许你以“未来的”#tr[lookup]的匹配结果作为上下文，来决定当前#tr[lookup]的结果。

// As an example, try to work out how you would convert *all* the numerator digits in a fraction into their numerator form. Tal Leming suggests doing something like this:
举个例子，你可以尝试思考，如何才能为文本中所有分数的分子数字都应用上分子的样式？Tal Leming 提议可以这么做：

```fea
lookup Numerator1 {
    sub @figures' fraction by @figuresNumerator;
} Numerator1;

lookup Numerator2 {
    sub @figures' @figuresNumerator fraction by @figuresNumerator;
} Numerator2;

lookup Numerator3 {
    sub @figures' @figuresNumerator @figuresNumerator fraction by @figuresNumerator;
} Numerator3;

lookup Numerator4 {
    sub @figures' @figuresNumerator @figuresNumerator @figuresNumerator fraction by @figuresNumerator;
} Numerator4;
# ...
```

// But this is obviously limited: the number of digits processed will be equal to the number of rules you write. To write it for any number of digits, you have to think about the problem in reverse. Start thinking not from the position of the *first* digit, but from the position of the *last* digit and work backwards. If a digit appears just before a slash, it gets converted to its numerator form. If a digit appears just before a digit which has already been converted to numerator form, this digit also gets turned into numerator form. Applying these two rules in a reverse substitution chain gives us:
但这明显是有局限的，我们可以处理的分子数字的长度被我们写了多少条规则所限制。为了能处理任意长度的分子，你需要逆向思考。也就是不从分子中的第一位数开始考虑，而是从最后一位开始，从后向前处理。如果有个数字出现在斜线之前，就把这个数字转换成分子形式；如果有个数字出现在已经转换成了分子形式的数字之前，就也把这个数字转换成分子形式。我们希望反向应用这两条规则，需要这样写：

```fea
rsub @figures' fraction by @figuresNumerator;
rsub @figures' @figuresNumerator by @figuresNumerator;
```

#note[
  // > Notice that although the lookups are *processed* with the input stream in reverse order, they are still *written* with the input stream in normal order of appearance.
  注意，虽然这些#tr[lookup]会从后向前处理输入的文本，但最终还是会按照正常从前向后的顺序进行输出和显示。
]

// XXX Nastaliq
// 原作者应该是希望在这里加一个波斯体的例子，待补

// Types of Positioning Rule
== 各种类型的#tr[positioning]规则 <section:positioning-rule-types>

// After all the substitution rules have been processed, we should have the correct sequence of glyphs that we want to lay out. The next job is to run through the lookups in the `GPOS` table in the same way, to adjust the positioning of glyphs. We have seen example of single and pair positioning rules:. We will see in this section that a number of other ways to reposition glyphs are possible.
在所有#tr[substitution]规则处理完后，我们应该就得到了字体可以正确处理的#tr[glyph]序列。下一项工作是按照相同的方式运行一遍`GPOS`表中的所有#tr[lookup]，来调整#tr[glyph]的位置。我们已经见过单#tr[character]和字偶对的#tr[positioning]规则了，在本节中会介绍将#tr[glyph]重新#tr[positioning]的其他各种方式。

// To be fair, most of these will be generated more easily and effectively by the user interface of your font editor - but not all of them. Let's dive in.
客观的说，大部分类型的规则通过使用字体编辑软件中的UI界面可以更方便的生成，但也不是所有类型都这样。让我们开始吧。

// ### Single adjustment
=== #tr[single adjustment]

// A single adjustment rule just repositions a glyph or glyph class, without contextual reference to anything around it. In Japanese text, all glyphs normally fit into a standard em width and height. However, sometimes you might want to use half-width glyphs, particularly in the case of Japanese comma and Japanese full stop. Rather than designing a new glyph just to change the width, we can use a positioning adjustment:
#tr[single adjustment]用于在不需要访问上下文时，对一个#tr[glyph]或#tr[glyph class]进行重#tr[positioning]。在日文中，所有的#tr[glyph]通常都会占据一个标准宽高的#tr[em square]。但有时某些#tr[glyph]也会想要使用半宽形式，特别是日文逗号和句号。我们不需要重新设计一个只是调整了宽高的#tr[glyph]，只要用#tr[positioning]规则处理即可：

```fea
feature halt {
  pos uni3001 <-250 0 -500 0>;
  pos uni3002 <-250 0 -500 0>;
} halt;
```

// Remember that this adjusts the *placement* (placing the comma and full stop) 250 units to the left of where it would normally appear and also the *advance*, placing the following character 500 units to the left of where it would normally appear: in other words we have shaved 250 units off both the left and right sidebearings of these glyphs when the `halt` (half-width alternates) feature is selected.
这段代码既会调整#tr[glyph]的放置位置也会调整它的#tr[advance]。在放置上，会让它相对原始位置向左移动250单位；而对#tr[advance]的调整，会让下一个#tr[character]出现的位置往左移500单位。换句话说，就是当开启`halt`特性时，我们会削掉这些#tr[glyph]的左右#tr[sidebearing]各250单位。

// ### Pair adjustment
=== 字偶对调整

// We've already seen pair adjustment rules: they're called kerns. They take two glyphs or glyphclasses, and move glyphs around. We've also seen that there are two ways to express a pair adjustment rule. First, you place the value record after the two glyphs/glyph classes, and this adjusts the spacing between them.
我们已经在介绍字偶矩时见过字偶对调整规则了。这些规则对两个#tr[glyph]或#tr[glyph]类进行移动调整。它也有两种写法，第一种是直接在最后写上一个数值记录，这会调整它们两个之间的间隙。

```fea
pos A B -50;
```

// Or you can put a value record after each glyph, which tells you how each of them should be repositioned:
第二种是在每个#tr[glyph]后面写数值记录，来分别对它们进行重新#tr[positioning]：

```fea
pos @longdescenders 0 uni0956 <0 -90 0 0>;
```

// ### Cursive attachment
=== #tr[cursive attachment]

// One theme of this book so far has been the fact that digital font technology is based on the "Gutenberg model" of connecting rectangular boxes together on a flat baseline, and we have to work around this model to accomodate scripts which don't work in that way.
本书的一个主题是数字字体技术是基于“古腾堡模型”的这一事实。它使用的是一个沿着平坦的基线逐个排列矩形块的模型。我们需要解决的问题就是如何让这个模型能够容纳并不使用上述书写方式的各种#tr[script]。

// Cursive attachment is one way that this is achieved. If a script is to appear connected, with adjacent glyphs visually joining onto each other, there is an easy way to achieve this: just ensure that every single glyph has an entry stroke and an exit stroke in the same place. In a sense, we did this with the "headline" for our Bengali metrics in [chapter 2](concepts.md#Units). Indeed, you will see some script-style fonts implemented in this way:
#tr[cursive attachment]是实现这一目标的一种方式。比如有些#tr[scripts]需要相邻的#tr[glyph]互相连接，有一个简单的方式可以搞定这个需求：只要确保每个#tr[glyph]都有位于同一位置的入笔和出笔即可。我们在#link(<pos:bengali-headline>)[前文]对孟加拉文字体#tr[metrics]中的#tr[headline]的介绍中其实就使用了这一方法。也有其他草书风格的字体会使用这种实现方式：

// TODO: 重画这个连笔英语字体的图片
#figure(
  placement: none,
)[#image("connected-1.png")]

// But having each glyph have the same entry and exit profile can look unnatural and forced, especially as you have to ensure that the curves don't just have the same *height* but have the same *curvature* at each entry and exit point. (Noto Naskh Arabic somehow manages to make it work.)
但只是让每个#tr[glyph]都有相同位置的出入笔画看上去会有些不自然。而且，为了达成这个目的并不是让出入笔画位置一致就可以的，它们还需要具有相同的曲率。（虽然Noto Naskh Arabic字体还是成功运用了这个方案）

// A more natural way to do it, particularly for Nastaliq style fonts, is to tell OpenType where the entry and exit points of your glyph are, and have it sew them together. Consider these three glyphs: two medial lams and an initial gaf.
更自然的方式是告诉OpenType每个#tr[glyph]的出入点，让它可以自动连接这两个点。这种方式对于波斯体来说尤其合适。我们以 `<gaf> <lam> <lam>` （其中`gaf` 为词首，`lam`为词中形式）这三个#tr[glyph]为例来看看。

#figure(
  placement: none,
)[#table(
  columns: (3fr, 2fr),
  align: bottom,
  inset: 1pt,
  [#image("gaf-lam-lam-1.png")],
  [#image("gaf-lam-lam-2.png")],
)]

#note[
  // > (Outlines from Noto Nastaliq Urdu)
  #tr[glyph]#tr[outline]来自Noto Nastaliq Urdu字体
]

// As they are, they all sit on the same baseline and don't connect up at all. Now we will add entry and exit anchors in our font editing software, and watch what happens.
左图展示的是这些#tr[outline]在进行连接前的原本的样子，基线位于底部相同位置。右图是我们在字体编辑软件中为它们添加入口和出口锚点之后发生的变化。

// Our flat baseline is no longer flat any more! The shaper has connected the exit anchor of the gaf to the entry anchor of the first lam, and the exit anchor of the first lam to the entry anchor of the second lam. This is cursive attachment.
看上去基线不再是平的了！#tr[shaper]将`gaf`的出锚点和第一个`lam`的入锚点连在了一起，然后第一个`lam`的出锚点又连到了第二个`lam`的入锚点。这种方式就叫做#tr[cursive attachment]。

// Glyphs has done this semi-magically for us, but here is what is going on underneath. Cursive attachment is turned on using the `curs` feature, which is on by default for Arabic script. Inside the `curs` feature are a number of cursive attachment positioning rules, which define where the entry and exit anchors are:
Glyphs 软件会半自动的为我们完成这个特性，但我们还是介绍下在内部到底发生了什么。#tr[cursive attachment]经由`curs`特性开启，这个特性在阿拉伯文环境下是默认启用的。`curs`特性中会有一些#tr[cursive attachment]#tr[positioning]规则，用于规定这些出入锚点的位置：

```fea
feature curs {
    lookupflag RightToLeft IgnoreMarks;
    position cursive lam.medi <anchor 643 386> <anchor -6 180>;
    position cursive gaf.init <anchor NULL> <anchor 35 180>;
} curs;
```

// (The initial forms have a `NULL` entry anchor, and of course final forms will have a `NULL` exit anchor.) The shaper is responsible for overlaying the anchors to make the exit point and its adjacent entry point fit together. In this case, the leftmost glyph (logically, the last character to be entered) is positioned on the baseline; this is the effect of the `lookupflag RightToLeft` statement. Without that, the rightmost glyph (first character) would be positioned on the baseline.
（词首形式的#tr[glyph]的入锚点是`NULL`，同理，词尾形式的#tr[glyph]的出锚点也是`NULL`。）#tr[shaper]需要负责让两个相邻锚点正确重叠。在上例中，最后是把最左边的（也就是最后输入的）#tr[glyph]放在#tr[baseline]上，这是由 `lookupflag RightToLeft` 这个#tr[lookup]选项语句控制的。如果不加这个选项，会把最右边的（输入的第一个）#tr[glyph]放在#tr[baseline]上。

// ## Anchor attachment
== 锚点衔接

// XXX
// 原文少一段介绍待补

// ### Mark positioning
=== 符号#tr[positioning]

// Anchors can also be used to position "mark" glyphs (such as accents) above "base" glyphs. The anusvara (nasalisation) mark in Devanagari is usually placed above a consonant, but where exactly does it go? It often goes above the descending stroke - but not always:
锚点也能够用来#tr[positioning]位于基本#tr[glyph]顶部的“符号”#tr[glyph]（比如变音符等）。天城文中在元音上会有表示鼻音化的随韵符，但它们的位置很难准确指定。它们通常位于#tr[decender]笔画的正上方，但也不总是这样：

#figure(placement: none)[#include "anusvara.typ"]

// Again, your font editor will usually help you to create the anchors which make this work, but let's see what is going on underneath. (We're looking at the Hind font from Indian Type Foundry.)
和之前一样，字体编辑软件通常会帮助你完成创建锚点的工作，但我们还是来看看这到底是怎么完成的。（本例我们使用的是 Indian Type Foundary 的 Hind 字体）

// According to Microsoft's [Devanagari script guidelines](https://docs.microsoft.com/en-us/typography/script-development/devanagari#shaping-engine), we should use the `abvm` feature for positioning the anusvara. First, we declare an anchor on the anusvara mark. We do this by asking for a mark class (even though there's only one glyph in this class), called `@MC_abvm.bindu`.
根据微软的天城文字体开发规范@Microsoft.DevelopingDevanagari，应该使用`abvm`特性来完成对随韵符的#tr[positioning]。首先，我们需要在随韵符#tr[glyph]中声明一个锚点，这可以通过创建一个符号类（虽然里面只有一个#tr[glyph]）来完成。我们把这个类叫做 `@MC_abvm.bindu`。

```fea
markClass dvAnusvara <anchor -94 642> @MC_abvm.bindu;
```

// This specifies a point (with coordinates -94,642) on the `dvAnusvara` glyph which we will use for attachment.
这在`dvAnusvara`#tr[glyph]中指定了一个坐标为 `(-94, 642)` 的点作为它的锚点。

// Next, in our `abvm` feature, we will declare how this mark is attached to the base glyphs, using the `pos base` (or `position base`) command: `pos base *baseGlyph* anchor mark *markclass*`
下一步，我们需要在 `abvm` 特性中定义这个符号需要衔接到基本#tr[glyph]的什么位置。这可以使用`pos base`（或者`position base`）命令，语法为：```fea pos base *baseGlyph* *anchor* mark *markclass*```。

```fea
feature abvm {
  pos base dvAA <anchor 704 642> mark @MC_abvm.bindu;
  pos base dvAI <anchor 592 642> mark @MC_abvm.bindu;
  pos base dvB_DA <anchor 836 642> mark @MC_abvm.bindu;
  #...
} abvm;
```

// This says "you can attach any marks in the class `MV_abvm.bindu` to the glyph `dvAA` at position 704,642; on glyph `dvAI`, they should be attached at position 592,642" and so on.
这段代码的意思是：你可以把`MV_abvm.bindu`符号类中的任何符号衔接到`dvAA`#tr[glyph]的 `(704, 642)` 座标处；对于`dvAI`#tr[glyph]，衔接到坐标 `(592, 642)`；以此类推。

// ### Mark-to-ligature
=== #tr[ligature]上的符号

// This next positioning lookup type deals with how ligature substitutions and marks inter-relate. Suppose we have ligated two Thai characters: NO NU (น) and TO TAO (ต) using a ligature substitution rule:
下一个#tr[positioning]#tr[lookup]类型用于处理#tr[ligature]和符号之间的关系。假设我们在制作泰语#tr[character] `NO NU`（#thai[น]） 和 `TO TAO`（#thai[ต]） 的#tr[ligature]#tr[substitution]：

```fea
lookupflag IgnoreMarks;
sub uni0E19' uni0E15' by uni0E190E15.liga;
```

// We've ignored any marks here to make the ligature work - but what if there *were* marks? If the input text had a tone mark over the NO NU (น้), how should that be positioned relative to the ligature? We've taken the NO NU away, so now we have `uni0E190E15.liga` and a tone mark that needs positioning. How do we even know which *side* of the ligature to attach the mark to - does it go on the NO NU part of the TO TAO part?
在#tr[substitution]流程中我们为了让#tr[ligature]正常形成而忽略了所有符号，但如果真的有符号出现会怎么样呢？如果输入文本在 `NO NU` 上加了一个音调（#thai[น้]），在形成#tr[ligature]后这个音调会被放在哪呢？在这个过程中，原本的两个字母都消失了，只剩下了`uni0E190E15.liga`和一个需要被#tr[positioning]的音调符号。我们甚至都无法知道这个音调原本是加在哪个字母上的。

// Mark-to-ligature positioning helps to solve this problem. It allows us to define anchors on the ligature which represent where to put anchors for each component part. Here is how we do it:
#tr[ligature]上的符号#tr[positioning]可以帮助解决这个问题。它允许我们在#tr[ligature]#tr[glyph]上定义多个锚点，分别表示各个组成部件上的符号位置。写法如下：

```fea
feature mark {
    position ligature uni0E190E15.liga  # 声明连字中的定位规则
                                        # 第一个部件: NO NU
      <anchor 325 1400> mark @TOP_MARKS # 第一个部件的锚点

      ligcomponent                      # 分隔不同部件

                                        # 第二个部件: TO TAO
      <anchor 825 1450> mark @TOP_MARKS # 第二个部件的锚点
    ;
} mark;
```

// So we write `position ligature` and the name of the ligated glyph or glyph class, and then, for each component which made up the ligature substitution, we give one or more mark-to-base positioning rules; then we separate each component by the keyword `ligcomponent`.
语法是先写 `position ligature` 加上#tr[ligature]#tr[glyph]的名字或#tr[glyph]类，然后为每个参与#tr[ligature]#tr[substitution]的部件添加一个或多个锚点衔接#tr[positioning]规则。这些部件之间使用关键字 `ligcomponent`隔开。

// The result is a set of anchors that can be used to attach marks to the appropriate part of ligated glyphs:
它的效果就是在#tr[ligature]#tr[glyph]产生了一系列可以为每个部件添加符号的锚点：

#figure(
  caption: [#tr[ligature]上的符号#tr[positioning]],
  placement: none,
)[#include "mark-to-lig.typ"]

// ### Mark-to-mark
=== 符号叠放

// The third kind of mark positioning, mark-to-mark, does what its name implies - it allows marks to have other marks attached to them.
第三种符号#tr[positioning]规则是符号叠放。顾名思义，它用来在符号上附加符号。

// In Arabic, an alif can have a hamza mark attached to it, and can in turn have a damma attached to the hamza. We position this by defining a mark class for the damma as normal:
在阿拉伯文中，字母`alif`上可以添加`hamza`符号，然后这个整体上面还可以添加`damma`符号。我们按照之前的方式为`damma`定义一个符号类:

```fea
markClass damma <anchor 189 -103> @dammaMark;
```

// And then we specify, in the `mkmk` (mark-to-mark) feature, how to attach the hamza to the damma:
然后，在`mkmk`（mark-to-mark）特性中，定义它如何叠放在`hamza`符号上：

```fea
feature mkmk {
  position mark hamza <anchor 221 301> mark @dammaMark;
} mkmk;
```

看看结果：#arabic[أُ]

// Once again, this is the kind of feature that is often automatically generated by defining anchors in your font editor.
再次提醒，在字体编辑器中定义锚点后，这种特性通常是让软件自动生成的。

// ### Contextual and chaining contextual positioning
=== #tr[chaining]#tr[positioning]

// These two lookup types operate in exactly the same way as their substitution cousins, except with the use of the `pos` command instead of `sub`. You provide (optional) backtrack, input marked with apostrophe, and (optional) lookahead as usual.
剩下两种#tr[lookup]类型的工作方式和它们在#tr[substitution]规则中类似，唯一的差别是需要把`sub`命令换成`pos`命令。其他的关于可选的前瞻、回溯，以及用撇号标识操作主体的语法都和之前一样。

// In a contextual positioning rule, your intersperse the input glyphs with value records. For example, you can create not just kern *pairs* but kern *triplets* (or more):
在#tr[contextual]#tr[positioning]规则中，可以在#tr[glyph]之间插入数值记录。比如你可以创建#tr[kern]的升级版，调整三个#tr[glyph]间的间距：

```fea
position @number' -25 colon' -25 @number';
```

// This rule reduces the space around a colon when it is surrounded by numbers.
这条规则在冒号两边都是数字时缩减了间距。

// As with a chained contextual substitution rule, in a chained contextual positioning rule, you can intersperse the input glyphs with other positioning lookups. This is where things get *very* clever. Let's take an example from the Amiri font. Suppose we have the sequence lam, beh, yeh barree (لبے). Amiri wants to wrap the yeh barree underneath the glyph sequence and to move the nukta of the beh out of the way for a more calligraphic feel.
正如#tr[chaining]#tr[contextual]#tr[substitution]一样，在#tr[chaining]#tr[contextual]#tr[positioning]时你可以调用其他#tr[positioning]#tr[lookup]来处理输入#tr[glyph]。这是字体让变得智能起来的重要功能，我们来看 Amiri 字体中的一个例子。假设现在输入序列是`lam beh yeh barree`（#arabic[لبے]），Amiri字体为了展现一种更加书法化的样式，希望将`beh`中的`nauka`符号脱落，并且让`yeh barree`穿过整个#tr[glyph]：

#figure(
  placement: none,
)[#include "amiri-kern.typ"]

// It does this with a chained contextual substitution:
它使用#tr[chaining]#tr[contextual]#tr[substitution]实现这一目的：

```fea
lookup ToothYaaBariFina {
  sub @aBaa.medi by @aBaa.medi_YaaBari; # nukta 脱落
  # ...
  sub @aYaaBari.fina by @aYaaBari.fina_PostToothFina; # 延长 yeh
} ToothYaaBariFina;

feature calt {
  # ...
  sub [@aBaa.medi]'     lookup ToothYaaBariFina
      [@aYaaBari.fina]' lookup ToothYaaBariFina;
}
```

// This almost works. The problem is that the barree of the yeh is now sticking out too far to the right for a narrow glyph like lam, and poking its nose into the words to the right of it. What we need to do is add some advance width to the lam in *this particular situation*. Let's reword that: if we have a narrow initial letter, followed by a beh in yeh-barree form, then we need to adjust the advance width of the initial letter. But we can't say exactly how much we need to adjust it by at this stage, because it depends on what the initial letter is; so we need to turn that into a lookup.
这基本上是可行的。但是`yah barree`现在拖得太长了，以至于如果词首是像`lam`之类的窄#tr[glyph]的话，这条尾巴就会伸进它右边的单词里了。我们需要做的是，在这种特殊场景下为`lam`增加一些#tr[advance width]。我们来整理一下：如果词首是一个比较窄的字母，然后跟着`beh`和`yah-barree`，那么我们就需要调整词首字母的#tr[advance width]。但我们没法直接给出到底要调整多少，因为它取决于词首字母是什么。所以我们将这个调整写成另一个#tr[lookup]。

// We can translate that description above into feature code. First, we set up the context for the positioning lookup:
我们逐步将上面的描述转换为特性代码。首先，我们写一个控制在何时启用#tr[advance]调整的上下文#tr[lookup]：

```fea
@narrowInit = [@aAyn.init @aFaa.init @aHeh.init @aLam.init @aMem.init @aSen.init @aTaa.init uni06BE.init]

feature kern {
  pos @narrowInit' lookup AvoidYehBaree @aBaa.medi_YaaBari;
}
```

// Next we write a lookup which adjusts the advance width of each of the "narrow" initial characters appropriately to stop the yeh baree poking out:
然后再写具体如何调整#tr[advance width]的#tr[lookup]，其中每个词首窄#tr[character]都按照`yeh baree`伸出多少来进行调整：

```fea
lookup AvoidYehBaree {
  pos @aAyn.init <0 0 215 0>;
  #...
  pos @aLam.init <0 0 466 0>;
  #...
} AvoidYehBaree;
```

// And here's the result of those two features - the contextual alternate, and the kerning feature - working together:
把`calt`（#tr[contextual]替代）和`kern`两个特性同时开启，就得到下面的效果：

#figure(
  placement: none,
)[#include "amiri-kern-2.typ"]

// That, thankfully, is probably as complicated as it's going to get.
不用太担心，这几乎就是最复杂的场景了。

// Using hb-shape to check positioning rules
== 使用 `hb-shape` 检查#tr[positioning]规则

// In the previous chapter we introduced the Harfbuzz utility `hb-shape`, which is used for debugging the application of OpenType rules in the shaper. As well as looking at the glyphs in the output stream and seeing their advance widths, `hb-shape` also helps us to know how these glyphs have been repositioned in the Y dimension too.
在上一章中我们介绍了HarfBuzz的`hb-shape`工具，并用它调试了#tr[shaper]对OpenType规则的应用。我们看到它可以显示#tr[glyph]在原输入流中的位置，以及它们的#tr[advance width]信息。其实它也可以帮助我们了解#tr[glyph]在Y轴方向上进行了怎样的重#tr[positioning]。

// For example, suppose we are using a mark-to-base feature to position a virama on the Devanagari letter CHA:
比如这个在天城文字母`CHA`上使用锚点对`virama`符号进行#tr[positioning]的例子：

```fea
markClass @mGC_blwm.virama_n172_0 <anchor -172 0> @MC_blwm.virama;
pos base dvCHA <anchor 276 57> mark @MC_blwm.virama;
```

// What this says is "the attachment point for the virama is at coordinate (-172,0); on the letter CHA, we should arrange things so that attachment point falls at coordinate (276,57)." Where does the virama end up? `hb-shape` can tell us:
这段代码的含义是：`virama`的锚点在坐标`(-172, 0)`处；在`CHA`字母上如果要附加`virama`符号，就将其锚点放在坐标`(276, 57)`处。那么`virama`现在到底位于什么#tr[position]呢？使用`hb-shape`可以得知：

#[
#show raw: set text(font: consts.font.western-mono + ("Hind",))

```bash
$ hb-shape build/Hind-Regular.otf 'छ्'
[dvCHA=0+631|dvVirama=0@-183,57+0]
```
]

// So we have a CHA character which is 631 units wide. Next we have a virama which is zero units wide! But when it is drawn, its position is moved - that's what the "@-183,57" component means: we've finished drawing the CHA, and then we move the "pen" negative 183 units in the X direction (183 units to the left) and up 57 units before drawing the virama.
首先我们看到，`CHA`#tr[character]有631单位宽。然后下一个是0宽度的`virama`！不过它的绘制位置移动了，输出中的 `@183,57`的意思是：当画完`CHA`字母后，将画笔向X轴负方向（也就是向左）移动183单位，再向上移动57个单位，然后再绘制`virama`。

// Why is it 183 units? First, let's see what would happen *without* the mark-to-base positioning. We can do this by asking `hb-shape` to turn off the `blwm` feature when processing:
为什么是 183 个单位呢？我们先来看看在进行#tr[positioning]前是什么样的。这可通过关闭`blwm`特性来实现：

#[
#show raw: set text(font: consts.font.western-mono + ("Hind",))

```bash
$ hb-shape --features='-blwm' Hind-Regular.otf 'छ्'
[dvCHA=0+631|dvVirama=0+0]
```
]

// As you can see, no special positioning has been done. Another utility, `hb-view` can render the glyphs with the feature set we ask for. If we ask to turn off the `blwm` feature and see what the result is like, this is what we get:
正如你所见，这样的话就没有什么特殊的#tr[positioning]操作了。我们可以使用`hb-view`工具来渲染当前特性集下#tr[glyph]的实际样子。结果如下：

#[
#show raw: set text(font: consts.font.western-mono + ("Hind",))

```bash
$ hb-view --features='-blwm' Hind-Regular.otf 'छ्' -O png > test.png
```
]

#figure(
  placement: none,
)[#image("hind-bad-virama.png", width: 30%)]

#note[
  // > You can also make `hb-view` output PNG files, PDFs, and other file formats, which is useful for higher resolution testing. (Look at `hb-view --help-output` for more options.) But the old-school ANSI block graphics is quite cute, and shows what we need in this case.
  你可以让`hb-view`输出PNG、PDF等各种格式（`hb-view --help-output`可以查看相关选项），这对高分辨率测试很有用。但老式的ANSI块状#tr[character]组成的图形很有意思，而且在这个例子中也够用了。
]

// Obviously, this is badly positioned (that's why we have the `blwm` feature). What needs to happen to make it right?
很明显，这个符号的位置不对（所以我们才需要`blwm`特性）。现在如果想让它回到正确的位置，需要怎么做呢？

#figure(
  placement: none,
)[#include "virama-pos.typ"]

// As you can see, the glyph is 631 units wide (Harfbuzz told us that), so we need to go back 355 units to get to the CHA's anchor position. The virama's anchor is 172 units to the left of that, so in total we end up going back 183 units. We also raise the glyph up 57 units from its default position.
我来解释一下这张图。`CHA`这个#tr[glyph]的宽度是631（HarfBuzz告诉我们的），所以我们要往回355个单位才能走到`CHA`中锚点的水平位置。`virama`的锚点在局部坐标-172单位处，所以整体上来看我们需要将它往左移183单位。为了锚点对齐，还需要将它向上移动57单位。

// This example was one which we could probably have tested and debugged from inside our font editor. But as our features become more complex, `hb-shape` and `hb-view` become more and more useful for understanding what the shaper is doing with our font files.
这个例子中的测试和调试工作可能在字体编辑软件中就能完成。但当特性变得越来越复杂的时候，`hb-shape`和`hb-view`就会变得越来越有用。它们可以帮助你理解#tr[shaper]到底是如何和你的字体文件协同工作的。
