#import "/template/template.typ": web-page-template
#import "/template/components.typ": note, cross-link

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## The letter "i"
== 麻烦的字母 i

// The Latin letter "i" (and sometimes "j") turns out to need special handling. For one thing, in Turkish, as we've mentioned before, lower case "i" uppercases to "İ".
拉丁字母`i`（有时候`j`也一样）需要特殊处理。因为#cross-link(<position:turkish-i-uppercase>, web-path: "/chapters/03-unicode/case.typ")[前文]提到过，在土耳其语中`i`的大写形式是`İ`。

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
