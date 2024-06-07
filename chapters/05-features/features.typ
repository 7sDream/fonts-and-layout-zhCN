#import "/template/template.typ": web-page-template
#import "/template/heading.typ": chapter
#import "/template/components.typ": note, cross-link

#import "/lib/glossary.typ": tr

#show: web-page-template

#chapter(
  label: <chapter:opentype-features>
)[
  // Introduction to OpenType Features
  OpenType特性简介
]

// In the previous chapter we looked at some of the data tables hiding inside an OpenType font. And let's face it, they weren't all that interesting - metrics, character mappings, a few Bézier splines or drawing instructions. The really cool part about OpenType (and its one-time rival, Apple Advanced Typography) is the ability to *program* the font. OpenType's collaborative model, which we discussed in our chapter on history, allows the font to give instructions to the shaping engine and control its operation.
在上一章中我们介绍了OpenType字体中的一些数据表，和其中储存的#tr[metrics]、#tr[character]映射、贝塞尔曲线、绘图指令等信息。但说实话，这其实并不怎么有趣吧。OpenType（以及它曾经的对手，Apple Advanced Typography）中真正酷炫的部分是能够对字体进行*编程*。前文介绍的#cross-link(<concept:opentype-collaborative-model>, web-path: "/chapters/01-concepts/shaping-layout.typ")[OpenType合作模型]概念中已经提到过，字体可以给#tr[shaping]引擎提供指令并控制它的行为。

#note[
  // > When I use the word "instruction" in this chapter, I'm using the term in the computer programming sense - programs are made up of instructions which tell the computer what to do, and we want to be telling our shaping engine what to do. In the font world, the word "instruction" also has a specific sense related to hinting of TrueType outlines, which we'll cover in the chapter on hinting.
  本章中，当使用“指令”这个词时，我是在使用其在计算机科学领域中的含义。程序就是由一些告诉电脑应该做什么的指令构成的，对于字体和#tr[shaping]引擎也是同理。在字体领域，“指令”这个词在对TrueType#tr[outline]进行#tr[hinting]时有另一种含义，这会在有关#tr[hinting]的章节中再详细介绍。
]

// "Smart fonts", such as those enabled by OpenType features, can perform a range of typographic refinements based on data within the font, from kerning, ligature substitution, making alternate glyphs available to the user, script-specific and language-specific forms, through to complete substitution, reordering and repositioning of glyphs.
“智能字体”——比如通过OpenType实现了各种特性的字体——能通过其内部数据对最终的#tr[typography]效果进行精心地打磨调整。像是#tr[kern]、#tr[ligature]、字符#tr[substitution]、可供选择的#tr[alternate glyph]、为某种#tr[script]或语言专门设计的样式、#tr[glyph]完全#tr[substitution]、重排序和#tr[positioning]等等。

// Specifically, two tables within the font - the `GPOS` and `GSUB` tables - provide for a wide range of context-sensitive font transformations. `GPOS` contains instructions for altering the position of glyph. The canonical example of context-sensitive repositioning is *kerning*, which modifies the space between two glyphs depending on what those glyphs are, but `GPOS` allows for many other kinds of repositioning instructions.
特别是字体中的 `GPOS` 和 `GSUB` 表，它们提供了许多基于上下文的字体变换功能。`GPOS` 表中包含对#tr[glyph]位置进行调整的指令。其中的经典例子就是#tr[kern]，它根据前后两个#tr[glyph]具体是什么来调整间隔大小。但除此之外 `GPOS` 还支持其他各种重#tr[positioning]指令。

// The other table, `GSUB`, contains instructions for substituting some glyphs for others based on certain conditions. The obvious example here is *ligatures*, which substitutes a pair (or more) of glyphs for another: the user types "f" and then "i" but rather than displaying those two separate glyphs, the font tells the shaping engine to fetch the single glyph "ﬁ" instead. But once again, `GSUB` allows for many, many interesting substitutions - some of which aren't merely typographic niceties but are absolutely essential when engineering fonts for complex scripts.
另一个 `GSUB` 表则包含在特定情况下将某些#tr[glyph]替换为其他#tr[glyph]的指令。最明显的例子就是#tr[ligature]，它将一对（也可以是更多）#tr[glyph]替换成另一个单独#tr[glyph]。比如用户输入了f和i，但字体可以让#tr[shaping]引擎显示另一个专门的fi#tr[glyph]，用于取代那两个f和i的#tr[glyph]。无独有偶，`GSUB`也支持其他各种有趣的#tr[substitution]指令。其中有些指令不仅能提供对#tr[typography]效果的调整，甚至会作为复杂#tr[scripts]的字体工程所必须的基础步骤。

// In this chapter, we're going to begin to look at these instructions, how we get them into our font, and how they work; in the following two chapters, we'll look more systematically at what instructions are available, and how we can use them to create fonts which support our global scripts.
在本章中我们会简单介绍这些指令以及如何在字体中使用它们，并了解它们的工作原理。在后续的两章中，我们会更系统地介绍有哪些指令可供使用，以及如何使用它们创造支持#tr[global scripts]的字体。
