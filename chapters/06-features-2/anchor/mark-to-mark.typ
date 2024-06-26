#import "/template/template.typ": web-page-template
#import "/template/components.typ": note
#import "/template/lang.typ": arabic

#import "/lib/glossary.typ": tr

#show: web-page-template

// ### Mark-to-mark
=== 符号叠放

// The third kind of mark positioning, mark-to-mark, does what its name implies - it allows marks to have other marks attached to them.
第三种符号#tr[positioning]规则是符号叠放。顾名思义，它用来在符号上附加符号。

// In Arabic, an alif can have a hamza mark attached to it, and can in turn have a damma attached to the hamza. We position this by defining a mark class for the damma as normal:
在阿拉伯文中，字母`alif`上可以添加`hamza`符号，然后这个整体上面还可以添加`damma`符号。我们按照之前的方式为`damma`定义一个符号类:

```fea
markClass damma <anchor 189 -103> @dammaMark;
```

// And then we specify, in the `mkmk` (mark-to-mark) feature, how to attach the hamza to the damma:
然后，在`mkmk`（mark-to-mark）特性中，定义它如何叠放在`hamza`符号上：

```fea
feature mkmk {
  position mark hamza <anchor 221 301> mark @dammaMark;
} mkmk;
```

看看结果：#arabic[أُ]

// Once again, this is the kind of feature that is often automatically generated by defining anchors in your font editor.
再次提醒，在字体编辑器中定义锚点后，这种特性通常是让软件自动生成的。
