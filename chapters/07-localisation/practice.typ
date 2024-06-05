#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

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
