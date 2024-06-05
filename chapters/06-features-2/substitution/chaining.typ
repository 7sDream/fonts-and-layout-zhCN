#import "/template/template.typ": web-page-template
#import "/template/components.typ": note
#import "/template/lang.typ": arabic

#import "/lib/glossary.typ": tr

#show: web-page-template

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
