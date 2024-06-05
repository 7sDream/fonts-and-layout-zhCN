#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// Types of Substitution Rule
== 各种类型的#tr[substitution]规则 <section:substitution-rule-types>

// The simplest type of substitution feature available in the `GSUB` table is a single, one-to-one substitution: when the feature is turned on, one glyph becomes another glyph. A good example of this is small capitals: when your small capitals feature is turned on, you substitute "A" by "A.sc", "B" by "B.sc" and so on. Arabic joining is another example: the shaper will automatically turn on the `fina` feature for the final glyph in a conjoined form, but we need to tell it which substitution to make.
`GSUB`表中最简单的#tr[substitution]特性是一换一#tr[substitution]。当这类特性开启时会让某个#tr[glyph]变成另一个。我们之前介绍过的小型大写字母特性会把`A`变成`A.sc`，把`B`变成`B.sc`，这就是一个不错的例子。另一个例子是阿拉伯文中的连体变形，#tr[shaper]会自动为连体形式的尾部#tr[glyph]打开`fina`特性，我们就在这个特性里编写规则来告诉#tr[shaper]需要如何进行#tr[substitution]。

// The possible syntaxes for a single substitution are:
一换一#tr[glyph]替换的语法有如下几种：

```fea
sub <glyph> by <glyph>;
substitute <glyphclass> by <glyph>;
substitute <glyphclass> by <glyphclass>;
```

// The first form is the simplest: just change this for that. The second form means "change all members of this glyph class into the given glyph". The third form means "substitute the corresponding glyph from class B for the one in class A". So to implement small caps, we could do this:
第一种形式最简单，就是把一个#tr[glyph]换成另一个。第二种形式的含义是将某个#tr[glyph]类中的所有成员都换成给定的#tr[glyph]。第三种形式表示用B#tr[glyph]类中的对应#tr[glyph]#tr[substitution]A类中相同位置的#tr[glyph]。所以，我们可以这样实现小型大写字母特性：

```fea
feature smcp {
  substitute [a-z] by [A.sc - Z.sc];
}
```

// To implement Arabic final forms, we would do something like this:
而阿拉伯字母的词尾形式可以这样实现：

```fea
feature fina {
    sub uni0622 by uni0622.fina; # Alif madda
    sub uni0623 by uni0623.fina; # Alif hamza
    sub uni0624 by uni0624.fina; # Waw hamza
    ...
}
```

// Again, in these particular situations, your font editing software may pick up on glyphs with those "magic" naming conventions and automatically generate the features for you. Single substitutions are simple; let's move on to the next category.
值得一提的是，在这些特定的例子中，你的字体编辑软件可能会根据#tr[glyph]的这种“约定俗成”的命名方式自动为你生成对应的特性。一换一#tr[substitution]就是这么简单，我们继续来看下一类吧。
