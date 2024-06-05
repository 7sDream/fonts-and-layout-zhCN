#import "/template/template.typ": web-page-template
#import "/template/components.typ": note
#import "/template/lang.typ": devanagari

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## Positioning rules
== #tr[positioning]规则

// We've talked a lot about substitution so far, but that's not the only thing we can use OpenType rules for. You will have noticed that in our "paper tape" model of OpenType shaping, we had two rows on the tape - the top row was the glyph names. What's the bottom row?
到目前为止我们使用的都是#tr[substitution]规则，但其实OpenType中还有其他类型的规则可用。你可能已经注意到了，在我们之前使用打孔纸带类比OpenType文本#tr[shaping]过程，图中的“纸带”上有每个单元格有两行内容。上面一行是#tr[glyph]名，那下面一行是用来做什么的呢？

// After all the substitution rules in our set of chosen lookups are processed from the `GSUB` table, the same thing is done with the `GPOS` table: feature selections and language/script selections are used to gather a set of lookups, which are then processed in turn.
当按照之前描述的方式处理完`GSUB`表中所有被选中的#tr[lookup]后，相同的流程会在`GPOS`表中再发生一次。同样是根据特姓名和语言#tr[script]二元组过滤出需要的#tr[lookup]列表，然后依次处理。

// In the positioning phase, the shaper associates four numbers with each glyph position. These numbers - the X position, Y position, X advance and Y advance - are called a *value record*, and describe how to draw the string of glyphs.
在#tr[positioning]阶段，#tr[shaper]需要为每个#tr[glyph]生成四个数字。这四个分别是：X轴位置，Y轴位置，X轴#tr[advance]，Y 轴#tr[advance]。这组数字称为一条“数值记录”，它用于指导如何绘制这个#tr[glyph]。

// The shaper starts by taking the advance width from metrics of each glyph and placing that in the X advance section of the value record, and placing the advance height of each glyph into the Y advance section. (The X advance only applies in horizontal typesetting and the Y advance only applies in vertical typesetting.) As designer, we might think of the X advance as the width of the glyph, but when we come to OpenType programming, it's *much* better to think of this as "where to draw the *next* glyph".
#tr[shaper]首先从每个#tr[glyph]的#tr[metrics]中取出#tr[advance width]和#tr[advance height]，将它们分别放入数值记录的X轴#tr[advance]和Y轴#tr[advance]字段中。其中的X轴#tr[advance]只在#tr[horizontal typeset]时有用，Y轴#tr[advance]则是只用在#tr[vertical typeset]中。作为设计师，我们可能会将X轴#tr[advance]视为#tr[glyph]的宽度。但在进行OpenType特性编程时，你应该把这个概念理解为“从哪里开始绘制*下一个*#tr[glyph]”。

// Similarly the "position" should be thought of as "where this glyph gets shifted." Notice in this example how the `f` is first placed 1237 units after the `o` and then repositioning 100 units up and 100 units to the right of its default position:
类似的，“X轴#tr[position]”在这里要被理解为“这个#tr[glyph]在X轴上需要偏离其原始位置多远”。比如在@figure:f-positioning-example 所示的例子中，第一个`f`的原始位置是`o`之后的1237个单位处。但后续的重#tr[positioning]流程将其相对原始位置上移了 100 个单位，右移了 100 个单位。

#figure(
  caption: [对f的重#tr[positioning]],
)[#block(inset: 5em, stroke: 0.1em + gray)[原文缺图，待补]] <figure:f-positioning-example>

// In feature syntax, these value records are denoted as four numbers between angle brackets. As well as writing rules to *substitute* glyphs in the glyph stream, we can also write *positioning* rules to adjust these value records by adding a value to it. Let's write one now!
在 AFDKO 特性语法中，数值记录使用在尖括号内的四个数字来表达。就像我们可以编写规则来#tr[substitution]#tr[glyph]流中的某个#tr[glyph]那样，我们也可以编写带有数值记录的#tr[positioning]规则来对它们的#tr[position]进行调整。我们现在就来写一个试试。

```fea
feature kern {
    lookup adjust_f {
        pos f <0 0 200 0>;
    } adjust_f;
} kern;
```

// If you try this in `OTLFiddle` you'll find that this *adds* 200 units of advance positioning to the letter `f`, making it appear wider by shifting the *following* glyph to the right. Single positioning rules like this one adjust the existing positioning information by adding each component in the rule's value record to the corresponding component in the the value record in the glyph string.
如果在 `OTLFiddle` 中尝试这段代码，你将会看到 `f` 的#tr[advance]增加了 200 个单位，这导致其后的所有#tr[glyph]都向右移动了一些。像这样的#tr[positioning]规则，会将其规则中的数值记录的各个字段值，分别加到#tr[glyph]流中匹配的数值记录的相应字段上。

// This is a single positioning rule, which applies to *any* matching glyph in the glyph stream. This is not usually what we want - if we wanted to make the `f`s wider, we could have just given them a wider advance width in the editor. (However, single positioning rules do become useful when used in combination with chaining rules, which I promise we will get to soon.)
这是一个单#tr[glyph]的#tr[positioning]规则，他会应用到#tr[glyph]流中的*每个*匹配的#tr[glyph]上，这通常不是我们想要的效果。如果我们只是想让 `f` 宽一些，直接在字体编辑器中给他设置一个大一些的#tr[advance]值就行了，没必要使用特性。不过单#tr[glyph]的#tr[positioning]规则如果和#tr[chaining rules]结合使用的话，也可能变的很有用，我保证后面会尽快介绍这种用法。

// Another form of the positioning rule can take *two* input glyphs and add value records to one or both of them. Let's now see an example of a *pair positioning* rule where we will look for the glyphs `A B` in the glyph stream, and then change the positioning information of the `B`. I added the following stylistic set features to the test "A B" font from the previous chapter:
#tr[positioning]规则的另一种形式是可以提供*两个*#tr[glyph]，然后为它们或其中之一添加数值纪录。我们以一个会匹配#tr[glyph]流中的`A B`，并改变其中 `A` #tr[glyph]的#tr[positioning]信息的字偶#tr[positioning]规则为例来介绍它。我向上一章中的示例字体中添加了四个样式集来测试这种规则：

```fea
feature ss01 { pos A B <150 0 0 0>; } ss01 ;
feature ss02 { pos A B <0 150 0 0>; } ss02 ;
feature ss03 { pos A B <0 0 150 0>; } ss03 ;
feature ss04 { pos A B <0 0 0 150>; } ss04 ;
```

// And now let's see what effect each of these features has:
我们来看看这些特性分别产生什么效果：

#include "value-records.typ"

// From this it's easy to see that the first two numbers in the value record simply shift where the glyph is drawn, with no impact on what follows. Imagine the glyph "A" positioned as normal, but then after the surrounding layout has been done, the glyph is picked up and moved up or to the right.
通过实际效果，很容易看出数值记录中的前两个数字控制绘制这个#tr[glyph]时的位置偏移量，而不影响后续的#tr[glyph]。这可以想象为，先在原位置正常画出了`A`#tr[glyph]，再把它往上或往右移动了一些。

// The third example, which we know as kerning, makes the glyph conceptually wider. The advance of the "A" is extended by 150 units, increasing its right sidebearing; changing the advance *does* affect the positioning of the glyphs which follow it.
第三个例子是让整个#tr[glyph]变得更宽了，这其实就是我们之前说的#tr[kern]。`A`#tr[glyph]的#tr[advance]增加了150个单位，也就增加了它的右#tr[sidebearing]。改变#tr[advance]会影响后续所有#tr[glyph]的#tr[position]。

// Finally, you should be able to see that the fourth example, changing the vertical advance, does absolutely nothing. You might have hoped that it would change the position of the baseline for the following glyphs, and for some scripts that might be quite a nice feature to have, but the sad fact of the matter is that applications doing horizontal layout don't take any notice of the font's vertical advances (and vice versa) and just assume that the baseline is constant. Oh well, it was worth a try.
最后，从第四个例子看出，改变#tr[vertical advance]没有任何影响。你可能期望它会改变后续#tr[glyph]的#tr[baseline]位置，实际上这对某些#tr[scripts]来说确实是个很好的功能，但可惜的是目前进行#tr[horizontal typeset]的应用软件根本不关心字体的#tr[vertical advance]（同样，进行#tr[vertical typeset]的也不关心#tr[horizontal advance]），它们将#tr[baseline]都视为恒定常量。但不管怎样，尝试一下还是值得的。

// To make this more globally relevant, let's look at the Devanagari glyph sequence "NA UUE LLA UUE DA UUE" (नॗ ळॗ दॗ) in Noto Sans Devangari:
为了让本书更加全球化，我们看看Noto Sans Devangari字体下的天城文#tr[glyph]序列 `NA UUE LLA UUE DA UUE`：

#figure(placement: none, block(inset: (bottom: 50pt))[
  #devanagari[#text(size: 128pt)[नॗ ळॗ दॗ]]
])

// You should be able to see that in the first two combinations ("NA UUE" and "LLA UUE"), the vowel sign UUE appears at the same depth; regardless of how far below the headline the base character reaches, the vowel sign is being positioned at a fixed distance below the headline. (So we're not using mark to base and anchors here, for those of you who have read ahead.)
可以看到，对于前两个单元（`NA UUE` 和 `LLA UUE`），基本#tr[glyph]的底部到#tr[headline]的距离不同，但元音符号 `UUE` 所处的深度是相同的。（所以这里没有使用锚点，如果你喜欢跳着读书的话就能理解我在说啥。）

// However, if we attached the vowel sign to the "DA" at that same fixed position, it would collide with the DA's curly tail. So in a DA+UUE sequence, we have to do a bit of *vertical* kerning: we need to move the vowel sign down a bit when it's been applied to a long descender.
但当这个元音符号需要加到`DA`上时，如果还使用这个固定的深度位置，就会和`DA`的卷曲尾巴相撞了。所以在类似 `DA` + `UUE` 的组合中，我们需要调整竖直方向的#tr[kern]，也就是让元音符号向下移一点。

// Here's the code to do that (which I've simplified to make it more readable):
以下是字体中完成这个功能的代码（我进行了简化，使其更可读一些）：

```fea
@longdescenders = [
  uni091D # JHA
  uni0926 # DA
  # 和一些带有 rakar 的连字
  uni0916_uni094D_uni0930.rkrf uni091D_uni094D_uni0930.rkrf
  uni0926_uni094D_uni0930.rkrf
];
feature dist {
  script dev2;
  language dflt;
  pos @longdescenders <0 0 0 0> uni0956 <0 -90 0 0>;
  pos @longdescenders <0 0 0 0> uni0957 <0 -145 0 0>;
}
```

// What are we doing here? Let's read it out from the top. First, we define a glyph class for those glyphs with long descenders. Next, we are putting our rules into a feature called `dist`, which is a little like `kern` but for adjusting the distances between pre- and post-base marks and their base characters. The rules will apply to the script "Devanagari v.2". (This is another one of those famous OpenType compromises; Microsoft's old Indic shaper used the script tag `deva` for Devanagari, but when they came out with a new shaper, the way to select the new behavior was to use a new language tag, `dev2`. Nowadays you almost certainly want the "version 2" behaviour for any Indic scripts you engineer.)
这段代码做了什么呢？我们从上往下一点点看。首先我们为#tr[decender]较长的#tr[glyph]定义了一个#tr[glyph class]。然后我们在`dist`特性中编写了一些规则，这个特性和`kern`有些类似，但作用是调整基本#tr[glyph]和作用在其前后的符号这两者的位置关系。这些规则会在输入“Devanagari v.2”#tr[script]时生效。（这是OpenType中另一个著名的妥协：因为微软的古早印度系#tr[scripts]#tr[shaper]使用`deva`作为天城文的标签，当新的#tr[shaper]希望用一种新的方式实现时就需要一个新的标签`dev2`。而如今，无论是为哪种印度系#tr[script]开发字体，都几乎一定是会使用“第二版”#tr[shaper]的行为。）

// For any language system using this script, we apply the following rules: when we have a long descender and a UE vowel, the consonant is positioned normally (`0`), but the vowel sign gets its position shifted by 90 units downwards. When we have a long descender and a UUE vowel, the consonant is again positioned normally, but the vowel sign gets its position shifted by 145 units downwards. That should be enough to avoid the collision.
对于使用这种#tr[script]的所有语言，都应用如下规则：当一个长#tr[decender]#tr[glyph]后面跟着元音`UE`时，辅音都按常规方式#tr[positioning]（数值记录为四个`0`），但元音需要往下移90单位。当长#tr[decender]#tr[glyph]后面跟着元音`UEE`时，辅音依旧位于常规#tr[position]，元音则向下移动145单位。这应该足够避免碰撞了。

// In the next chapter we will look at the full range of substitution and positioning rules, as well as chain and attachment rules.
在下一章中，我们会完整介绍#tr[substitution]和#tr[positioning]规则的各种形式以及#tr[chaining rules]和#tr[attachment rules]。
