#import "/template/template.typ": web-page-template
#import "/template/components.typ": note
#import "/template/lang.typ": thai

#import "/lib/glossary.typ": tr

#show: web-page-template

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
