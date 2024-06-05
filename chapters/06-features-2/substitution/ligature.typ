#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

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
