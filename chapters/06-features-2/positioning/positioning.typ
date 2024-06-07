#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// Types of Positioning Rule
== 各种类型的#tr[positioning]规则 <section:positioning-rule-types>

// After all the substitution rules have been processed, we should have the correct sequence of glyphs that we want to lay out. The next job is to run through the lookups in the `GPOS` table in the same way, to adjust the positioning of glyphs. We have seen example of single and pair positioning rules:. We will see in this section that a number of other ways to reposition glyphs are possible.
在所有#tr[substitution]规则处理完后，我们应该就得到了字体可以正确处理的#tr[glyph]序列。下一项工作是按照相同的方式运行一遍`GPOS`表中的所有#tr[lookup]，来调整#tr[glyph]的位置。我们已经见过单#tr[character]和字偶对的#tr[positioning]规则了，在本节中会介绍将#tr[glyph]重新#tr[positioning]的其他各种方式。

// To be fair, most of these will be generated more easily and effectively by the user interface of your font editor - but not all of them. Let's dive in.
客观的说，大部分类型的规则通过使用字体编辑软件中的UI界面可以更方便的生成，但也不是所有类型都这样。让我们开始吧。
