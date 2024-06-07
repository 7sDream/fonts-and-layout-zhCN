#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ### Pair adjustment
=== 字偶对调整

// We've already seen pair adjustment rules: they're called kerns. They take two glyphs or glyphclasses, and move glyphs around. We've also seen that there are two ways to express a pair adjustment rule. First, you place the value record after the two glyphs/glyph classes, and this adjusts the spacing between them.
我们已经在介绍字偶矩时见过字偶对调整规则了。这些规则对两个#tr[glyph]或#tr[glyph]类进行移动调整。它也有两种写法，第一种是直接在最后写上一个数值记录，这会调整它们两个之间的间隙。

```fea
pos A B -50;
```

// Or you can put a value record after each glyph, which tells you how each of them should be repositioned:
第二种是在每个#tr[glyph]后面写数值记录，来分别对它们进行重新#tr[positioning]：

```fea
pos @longdescenders 0 uni0956 <0 -90 0 0>;
```
