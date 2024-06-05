#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

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
