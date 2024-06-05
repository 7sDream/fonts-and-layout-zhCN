#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ### Multiple substitution
=== #tr[multiple substitution]

// Single substitution was one-to-one. Multiple substitution is one-to-many: it decomposes one glyph into multiple different glyphs. The syntax is pretty similar, but with one thing on the left of the `by` and many things on the right.
一换多#tr[substitution]可以看作将一个#tr[glyph]分解为了几个不同的#tr[glyph]。语法和上面的差不多，只是在 `by` 前面只有一个#tr[glyph]，而在后面有多个。

// This can be useful if you have situations where composed glyphs with marks are replaced by a decomposition of another glyph and a combining mark. For example, sticking with the Arabic final form idea, if you haven't designed a specific glyph for alif madda in final form, you can get around it by doing this:
这种类型在处理带符号的#tr[glyph]时比较有用，你可以将它分解为独立的主体#tr[glyph]和符号#tr[glyph]。比如还是阿拉伯文中的例子，如果你没有专门为词尾形式的 alif madda 设计#tr[glyph]，你可以这样处理它：

```fea
feature fina {
    # Alif madda -> final alif + madda above
    sub uni0622 by uni0627.fina uni0653;
}
```

// This tells the shaper to split up final alif madda into two glyphs; you have the final form of alif, and so long as your madda mark is correctly positioned, you are essentially synthesizing a new glyph out of the two others.
这段规则告诉#tr[shaper]将词尾的 alif madda 分成两个#tr[glyph]。假设你已经设计好了词尾形式的 alif，那么你只要保证 madda 符号的正确#tr[positioning]，就可以通过这种方式来合成一个新#tr[glyph]了。

// In fact, when engineering Arabic fonts, it can be extremely useful to separate the dots (*nukta*) from the base glyphs (*rasm*). This allows you to reposition the dots independently of the base characters, and it can reduce the number of glyphs that you need to design and write rules for, as you only need to draw and engineer the "skeleton" form for each character.
在实际的阿拉伯字体工程中，将点号（nukta）和其他的基本#tr[glyph]（被称为rasm）分开处理是非常有效的。这允许你只需要绘制每个字符的基础骨架，再单独进行点的#tr[positioning]。这可以减少实际需要设计的#tr[glyph]和编写的规则数量。

// To do this, you would add empty glyphs to the font so that the Unicode codepoints can be mapped properly, but have the outline provided by other glyphs substituted in the `ccmp` (glyph composition and decomposition feature). For example, we can provide the glyph ز (zain) by having an empty `zain-ar` glyph mapped to codepoint U+0632, but in our `ccmp` feature do this:
为了使用这个方案，你需要在字体中将某些Unicode#tr[codepoint]映射到空白的#tr[glyph]。这些#tr[glyph]本身没有#tr[outline]，而是通过在`ccmp`（#tr[glyph]组合/分解）特性中将它们#tr[substitution]成其他#tr[glyph]来完成显示。例如我们想支持 zain #tr[glyph]，我们可以将 `U+0632` 映射到一个空白的 `zain-ar` #tr[glyph]，然后在`ccmp`特性中写上：

```fea
feature ccmp {
  sub zain-ar by reh-ar dot-above;
} ccmp;
```

// With this rule applied, we now no longer need to deal with zain as a special case - any future rule which applies to reh will deal correctly with the zain situation as well, so you have fewer "letters" to think about.
一旦这条规则应用，我们就不需要专门处理 zain #tr[character]了，任何处理 reh 的规则都可以顺便处理 zain。这样你需要考虑的字母就可以少一些了。
