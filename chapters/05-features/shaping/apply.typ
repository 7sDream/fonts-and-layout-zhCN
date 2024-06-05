#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ### Lookup application
=== 应用#tr[lookup]

// Now we have a list of lookups, which each contain rules. These rules are then applied to the glyph stream, lookup by lookup.
完成上面的步骤后，我们手上就有了一个#tr[lookup]的列表，表中的每个#tr[lookup]中都有一些规则。这个列表会逐个#tr[lookup]地进行处理，将其中的规则应用到#tr[glyph]流中。

// I think of the shaping process as being like an old punched-tape computer. (If you know what a Turing machine is, that's an even better analogy.) The input glyphs that are typed by the user are written on the "tape" and then a "read head" goes over the tape cell-by-cell, checking the current lookup matches at the current position.
我认为这种#tr[shaping]流程有点像使用打孔纸带的老式计算机（图灵机会是更好的术语，如果你知道它的话）。这些输入的#tr[glyph]就像是往纸带上打了孔，然后读取头会一格一格的阅读这些纸带，来确定当前的#tr[lookup]是否匹配当前位置的内容。

#figure(
  caption: [应用#tr[lookup]的流程就像老式打孔纸带计算机],
  placement: none,
  include "slide-9.typ"
)

// If the lookup matches, the shaper takes the appropriate action (substitution in the cases we have seen so far). It then moves on to the next location. Once it has gone over the whole tape and performed any actions, the next lookup gets a go (we call this "applying" the lookup).
如果当前#tr[lookup]匹配了当前的位置，#tr[shaper]将会执行相应的行动，比如我们之前举例的#tr[glyph]#tr[substitution]。之后（无论是否执行了其中任何规则）读取头就会移动到下一格继续处理这个#tr[lookup]。直到这样逐步处理完整个纸带后，下一个#tr[lookup]才会被选为当前#tr[lookup]，纸带也重新回到开头位置，重复这一被称为“应用#tr[lookup]”的过程。

// Notice we have said that the rules are applied lookup by lookup. This is where it becomes important to explicitly arrange our rules into lookups. Consider the difference between this:
请仔细阅读上面的流程，它表示规则是按#tr[lookup]为单位执行的。这一特性就使#tr[lookup]和规则的组织关系变得重要起来。考虑如下两段代码：

#let code1 = ```fea
feature liga {
    sub a by b;
    sub b by c;
} liga;
```

#let code2 = ```fea
feature liga {
    lookup l1 { sub a by b; } l1;
    lookup l2 { sub b by c; } l2;
} liga;
```

#figure(
  placement: none,
  grid(
    columns: (1fr, 2fr),
    column-gutter: 1em,
    code1, code2,
  )
)

// How would these features be applied to the glyph stream `c a b b a g e`? 
这两个特性引用于#tr[glyph]流 `c a b b a g e` 时会有什么不同呢？

// In the first case, *both* rules are considered at each position and the first to match is applied. An `a` is substituted by a `b` and a `b` is substituted by a `c`, so the output would be `c b c c b g e`.
对于左边的代码，这两条规则属于一个#tr[lookup]，所以在每个位置上，只有匹配此位置规则会被应用。也就是 `a` #tr[substitution]为 `b`，`b` #tr[substitution]为 `c`。最终的结果为 `c b c c b g e`。

// But in the second case, the first rule is applied at each position - leading to `c b b b b g e` - *and then* the tape is rewound and the second rule is applied at each position. The final output is `c c c c c g e`.
而对于右边的代码，流程是每个位置先检查并应用第一条#tr[lookup]中的规则，这就把#tr[glyph]流变成了 `c b b b b g e`。然后纸带重新回到开头位置，开始在每个位置上处理第二条#tr[lookup]中的规则。最终结果为 `c c c c c g e`。

// In short, rules in separate lookups act in sequence, rules in a single lookup act in parallel. Making your lookups explicit ensures that you get what you mean.
简而言之，在不同#tr[lookup]中的规则会按顺序匹配，在同一#tr[lookup]中的规则会同时进行匹配。明确的写出#tr[lookup]能确保最终的处理结果是符合你期望的。

#note[
  // > There is another reason why it's good to put rules explicitly into lookups; in OpenType, there are sixteen different types of rule, and a lookup may only contain rules of the same type. The compiler which packs these rules into the font tries to be helpful and, if there are different types of rule in the same feature, splits them into separate lookups, without telling you. But we have seen that when you split rules into separate lookups, you can end up changing the effect of those rules. This can lead to nasty debugging issues.
  推荐将规则明确放入#tr[lookup]中还有另一个原因。在OpenType中有 16 种不同类型的规则，而一个#tr[lookup]中只能含有相同类型的规则。将规则打包进字体的编译器在发现一个特性中有不同类型的规则时，为了更加智能的辅助整个流程，会将它们按类型放入各自独立的#tr[lookup]中。而这一切都是默默发生的。但实际上，改变规则划分为#tr[lookup]的方式实际上会改变其最终效果，这就可能导致一些难以调查的奇怪问题。
]
