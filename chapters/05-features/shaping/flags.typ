#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ### Lookup Flags
=== #tr[lookup]选项

// One more thing about the lookup application process - each lookup can have a set of *flags* which alters the way that it operates. These flags are *enormously* useful in controlling the shaping of global scripts.
在应用#tr[lookup]步骤中，另一个值得一提的功能是每个#tr[lookup]都可以启用一些选项。这些选项可以改变#tr[lookup]的运作方式，在控制#tr[global scripts]的文本#tr[shaping]时非常有用。

// For example, in Arabic, there is a required ligature between the letters lam and alef. We could try implementing this with a simple ligature, just like our `f_f` ligature:
还是以阿拉伯文为例，它在字母 lam 和 alef 间有一个必要#tr[ligature]。我们现在就来尝试实现这个类似`f_f`的简单#tr[ligature]：

```fea
feature liga {
  lookup lamalef-ligature {
      sub lam-ar alef-ar by lam_alef-ar;
  } lamalef-ligature;
} liga;
```

// However, this would not work in all cases! It's possible for there to be  diacritical marks between the letters; the input glyph stream might be `lam-ar kasra-ar alef-ar`, and our rule will not match. No problem, we think; let's create another rule:
但这段代码并不是在所有情况下都能正常工作，因为两个字母之间可能有#tr[diacritic]。比如输入的#tr[glyph]流可能是 `lam-ar kasra-ar alef-ar`，这样我们的规则就不匹配了。没事，我们可以再创建一条规则：

```fea
feature liga {
  lookup lamalef-ligature {
      sub lam-ar alef-ar by lam_alef-ar;
      sub lam-ar kasra-ar alef-ar by lam_alef-ar kasra-ar;
  } lamalef-ligature;
} liga;
```

// Unfortunately, we find that this refuses to compile; it isn't valid AFDKO syntax. As we'll see in the next chapter, while OpenType supports more-than-one match glyphs and one replacement glyph (ligature), and one match glyph and more-than-one replacement glyphs (multiple substitution), it rather annoyingly *doesn't* support more-than-one match glyphs and more-than-one replacement glyphs (many to many substitution).
但不幸的是，这段代码无法编译，他不符合 AFDKO 语法规则。OpenType支持多换一的#tr[glyph]替换（比如#tr[ligature]），也支持一换多的#tr[glyph]替换（#tr[multiple substitution]），烦人的是它不支持多换多#tr[glyph]替换。关于这个问题下一章会详细介绍。

// However, there's another way to deal with this situation. We can tell the shaper to skip over diacritical marks in when applying this lookup.
不过还好，还有另一种处理方式。我们可以让#tr[shaper]在应用这个#tr[lookup]时跳过所有符号。

```fea
feature liga {
  lookup lamalef-ligature {
      lookupFlag IgnoreMarks;
      sub lam-ar alef-ar by lam_alef-ar;
  } lamalef-ligature;
} liga;
```

// Now when this lookup is applied, the shaper only "sees" the part of the glyph stream that contains base characters - `lam-ar alef-ar` - and the kasra glyph is "masked out". This allows the rule to apply.
现在，当应用这个#tr[lookup]时，#tr[shaper]只会关注#tr[glyph]流中的基本#tr[character]部分，也即 `lam-ar alef-ar`，而`kasra`#tr[glyph]会被掩藏。这样一来我们的规则就能被应用了。

// XXX image here.
// TODO：这里需要一张图

// How does the shaper know which are mark glyphs are which are not? We tell it! The `GDEF` table contains a number of *glyph definitions*, metadata about the properties of the glyphs in the font, and one of which is the glyph category. Each glyph can either be defined as a *base*, for an ordinary glyph; a *mark*, for a non-spacing glyph; a *ligature*, for glyphs which are formed from multiple base glyphs; or a *component*, which isn't used because nobody really knows what it's for. Glyphs which aren't explicitly in any category go into category zero, and never get ignored. The category definitions are normally set in your font editor, so if your `IgnoreMarks` lookups aren't working, check your categories in the font editor - in Glyphs, for example, you not only have to set the glyph to category `Mark` but also to subcategory `Nonspacing` for it to be placed in the mark category. You can also [specify the GDEF table](http://adobe-type-tools.github.io/afdko/OpenTypeFeatureFileSpecification.html#9.b) in feature code.
#tr[shaper]怎么知道哪些#tr[glyph]属于符号呢？答案是我们来告诉它！字体中有一个`GDEF`表，它包含了#tr[glyph]定义信息，它们是字体中#tr[glyph]的元数据。这些元数据中有一项就是#tr[glyph]所属的类别。#tr[glyph]可以属于以下分类之一：用于普通字形的基本类`base`；用于非空白#tr[glyph]的符号类`mark`；用于由多个基本#tr[glyph]组成的的#tr[ligature]类`ligature`；还有一个没人知道怎么使用的部件类`component`。没有明确指明属于哪一类的#tr[glyph]会被归属到第零类`zero`，它们没有办法被忽略。你通常可以在字体编辑器中设置这些分类，所以如果 `IgnoreMarks` 选项不起作用的话，你可以用编辑器打开字体，检查一下它的分类设置。比如我使用的 Glyphs，你不仅需要将#tr[glyph]放进`Mark`，还需要具体地放入它的下级`Nonspacing`子类，这样它们才会被放入字体的`mark`类。你也可以直接在特性代码中定义`GDEF`表@Adobe.AFDKO.Fea.9.b。

// Other flags you can apply to a lookup (and you can apply more than one) are:
#tr[lookup]上可以同时开启多个选项，包括：

/*
* `RightToLeft` (Only used for cursive attachment lookups in Nastaliq fonts. You almost certainly don't need this.)
* `IgnoreBaseGlyphs`
* `IgnoreLigatures`
* `IgnoreMarks`
* `MarkAttachmentType @class` (This has been effectively superceded by the next flag; you almost certainly don't need this.)
* `UseMarkFilteringSet @class`

`UseMarkFilteringSet` ignores all marks *except* those in the specified class. This will come in useful when you are, for example, repositioning glyphs with marks above them but you don't really care too much about marks below them.
*/
- `RightToLeft`：只用于波斯体#tr[cursive attachment]的#tr[lookup]，你基本上不需要用到它。
- `IgnoreBaseGlyphs`
- `IgnoreLigatures`
- `IgnoreMarks`
- `MarkAttachmentType @class`：因为有下面那个更高效的选项作为替代品，基本上也不需要使用这个。
- `UseMarkFilteringSet @class`：忽略除指定的 `@class` 类以外的其他所有符号。这在一些情况下很有用，比如你希望重新#tr[positioning]#tr[glyph]，但并不关心这些#tr[glyph]上带有的附加符号时。
