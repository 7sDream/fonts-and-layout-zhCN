#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

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
  # ...
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
