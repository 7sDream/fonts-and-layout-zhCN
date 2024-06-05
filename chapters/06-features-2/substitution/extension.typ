#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ### Extension Substitution
=== 扩展#tr[substitution]

// An extension substitution ("GSUB lookup type 7") isn't really a different kind of substitution so much as a different *place* to put your substitutions. If you have a very large number of rules in your font, the GSUB table will run out of space to store them. (Technically, it stores the offset to each lookup in a 16 bit field, so there can be a maximum of 65535 bytes from the lookup table to the lookup data. If previous lookups are too big, you can overflow the offset field.)
扩展#tr[substitution]（也被称为 `GSUB lookup type 7`）并不和其他类型那样是另一种#tr[substitution]方法，而更像是另一个可以存放#tr[substitution]规则的地方。如果字体中有大量的规则，`GSUB`表中的储存空间可能会被用尽。（技术上的原因是，表示#tr[lookup]所在位置的偏移量字段是一个16位的数字，所以储存#tr[lookup]的整个数据表不能超过65525个字节。如果#tr[lookup]太大，就可能会让偏移量字段溢出。）

// Most of the time you don't need to care about this: your font editor may automatically use extension lookups; in some cases, the feature file compiler will rearrange lookups to use extensions when it determines they are necessary; or it may not support extension lookups at all. But if you are getting errors and your font is not compiling because it's running out of space in the GSUB or GPOS table, you can try adding the keyword `useExtension` to your largest lookups:
大多数时候你不需要为此操心，字体编辑软件会在需要时自动使用扩展#tr[lookup]。特性文件编译器可能会重排#tr[lookup]，并在觉得必要时让其中一些使用扩展方式，或者也有可能不支持扩展#tr[lookup]。但如果在编译字体时出现`GSUB`或`GPOS`表空间不足的错误提示，你可以尝试给最大的#tr[lookup]添加一个`useExtension`关键字：

```fea
lookup EXTENDED_KERNING useExtension {
  # 大量字偶矩规则
} EXTENDED_KERNING;
```

#note[
  // > Kerning tables are obviously an example of very large *positioning* lookups, but they're the most common use of extensions. If you ever get into a situation where you're procedurally generating rules in a loop from a scripting language, you might end up with a *substitution* lookup that's so big it needs to use an extension. As mention in the previous chapter `fonttools feaLib` will reorganise rules into extensions automatically for you, whereas `makeotf` will require you to place things into extensions manually - another reason to prefer `fonttools`.
  虽然`kern`表确实是扩展#tr[lookup]最常见的用例，但显然其中数量可能会超限的其实是#tr[positioning]规则。#tr[substitution]规则太多的情况也是有可能的，比如在为某种复杂的#tr[script]系统开发字体时，需要使用程序生成的方式编写规则，最终可能会因为产生了一个巨大的#tr[substitution]#tr[lookup]，从而需要使用扩展方式。上一章中提到的`fontTools feaLib`工具会自动将规则重新组织为扩展#tr[lookup]，而`makeotf`需要你手动处理它们。这也是更推荐使用`fontTools`的另一个原因。
]
