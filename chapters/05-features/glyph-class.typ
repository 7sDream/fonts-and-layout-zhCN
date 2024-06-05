#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## Glyph Classes and Named Classes
== #tr[glyph]类与命名类

// Now let’s write a set of rules to turn lower case vowels into upper case vowels:
现在我们编写一系列把所有的小写元音字母变成大写的规则：

```fea
feature liga {
  sub a by A;
  sub e by E;
  sub i by I;
  sub o by O;
  sub u by U;
} liga;
```

// That was a lot of work! Thankfully, it turns out we can write this in a more compact way. Glyph classes give us a way of grouping glyphs together and applying one rule to all of them:
这样代码好像有点长，我们能把它写成更紧凑的形式。通过将一些#tr[glyph]写成一组来组成#tr[glyph]类的方式可以批量应用规则：

```fea
feature liga {
    sub [a e i o u] by [A E I O U];
}  liga;
```

// Try this in OTLFiddle too. You'll find that when a class is used in a substitution, corresponding members are substituted on both sides.
在 `OTLFiddle` 中试试这个例子，你会发现当在#tr[substitution]规则中使用#tr[glyph]类时，会在匹配和替换两侧分别使用类中同一位置的成员。

// We can also use a glyph class on the "match" side, but not in the replacement side:
我们也可以只在匹配侧使用#tr[glyph]类：

```fea
feature liga {
    sub f [a e i o u] by f_f;
}  liga;
```

这等价于写：

```fea
feature liga {
    sub f a by f_f;
    sub f e by f_f;
    sub f i by f_f;
    # ...
}  liga;
```

// Some classes we will use more than once, and it's tedious to write them out each time. We can *define* a glyph class, naming a set of glyphs so we can use the class again later:
有些类会被多次使用，每次都明确写出其中每个#tr[glyph]就太繁琐了。在这个场景下我们可以给定义的#tr[glyph]类命名，这样就能在后面的代码中直接使用了：

```fea
@lower_vowels = [a e i o u];
@upper_vowels = [A E I O U];
```

// Now anywhere a glyph class appears, we can use a named glyph class instead (including in the definition of other glyph classes!):
现在任何可以填写#tr[glyph]类的地方，你都可以使用这些名字来代替。甚至在后续定义其他#tr[glyph]类时也可以使用：

```fea
@vowels = [@lower_vowels @upper_vowels];

feature liga {
  sub @lower_vowels by @upper_vowels;
} liga;
```
