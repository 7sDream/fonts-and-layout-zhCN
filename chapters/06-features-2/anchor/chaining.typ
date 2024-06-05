#import "/template/template.typ": web-page-template
#import "/template/components.typ": note
#import "/template/lang.typ": arabic

#import "/lib/glossary.typ": tr

#show: web-page-template

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
