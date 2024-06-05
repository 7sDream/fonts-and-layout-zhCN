#import "/template/template.typ": web-page-template
#import "/template/heading.typ": chapter
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

#chapter(
  label: <chapter:substitution-positioning>
)[
  // Substitution and Positioning Rules
  #tr[substitution]和#tr[positioning]规则
]

// As we have seen, OpenType Layout involves first *substituting* glyphs to rewrite the input stream, and then *positioning* glyphs to put them in the right place. We do this by writing collections of *rules* (called lookups). There are several different types of rule, which instruct the shaper to perform the substitution or positioning in subtly different ways.
从上一章我们能知道，OpenType的#tr[layout]过程分为了两个阶段，首先是#tr[substitution]规则将输入的#tr[glyph]流重写，然后是#tr[positioning]规则将#tr[glyph]们安排到正确的位置上。我们通过编写规则集（也就是#tr[lookup]）可以控制这一过程。而规则具有不同的类型，它们分别用不同的方式来执行具体的#tr[substitution]和#tr[positioning]操作。

// In this chapter, we'll examine each of these types of rule, by taking examples of how they can be used to layout global scripts. In the next chapter, we'll look at things the other way around - given something we want to do with a script, how can we get OpenType to do it? But to get to that stage, we need to be familiar with the possibilities that we have at our disposal.
在本章中，我们将会介绍所有类型的规则，并举例说明它们在处理#tr[global scripts]的#tr[layout]过程中起到了什么作用。下一章开始则会换一个方向，介绍在给定某种#tr[script]的条件下，OpenType是如何处理它的。但在开始灵活运用之前，我们首先要足够了解工具箱中的各种工具。
