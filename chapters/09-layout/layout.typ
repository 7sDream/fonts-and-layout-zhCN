#import "/template/heading.typ": chapter

#import "/lib/glossary.typ": tr
#import "/template/components.typ": note
#import "/template/lang.typ": arabic, greek, hebrew

#chapter[
  // Layout Challenges in Global Type
  #tr[global scripts]#tr[layout]中的挑战
]

// The previous chapters have been mainly aimed at font designers, but with some nods to those implementing shaping and layout systems. In this second half of the book, our discussion will be mainly aimed at font *consumers* - shapers, layout engines, and applications - rather than font producers, but with some nods to font designers.
之前的章节我们的关注点主要在字体设计上，附带介绍了一些#tr[shaping]和#tr[layout]系统如何实现的内容。在本书的后半部分，我们将会把焦点从字体的生产者转向字体的*消费者*，也就是#tr[shaper]、#tr[layout]引擎，以及应用程序们。当然其中也会有一些对字体设计师们有用的内容。

// As I may have mentioned once or twice by this point, the historical development of computers and the way that text has been handled has prioritized Latin assumptions about text layout. In the Latin model, things are very simple: a glyph is a square box, you line up each of the square boxes in your string of glyphs next to each other on a horizontal line in left to right order until they more or less fit on a line, you break the line at a space, and then you (possibly) make some adjustments to the line to make it fit nicely, and finally you move onto the next line which is underneath the previous one.
本书中多次提到，在计算机的发展历程中，文本处理的流程一直以拉丁语系的#tr[layout]方式为优先预设。在拉丁文的模型中，各种事情都非常简单。一个#tr[glyph]就是一个方块盒子，从#tr[glyph]序列中一个一个的取出#tr[glyph]，然后沿着一条水平的线从左到右逐个排列它们即可。当这些#tr[glyph]差不多占满当前行时，就在一个空格处进行断行。然后为了让这一行看起来更舒服，（可能）会对#tr[glyph]进行一些调整，让间距更加合适。最后在当前行的下方开始新的一行，重复此流程。

// But every single one of those assumptions fails in one or other script around the world. Telugu boxes don't line up next to each other. Hebrew boxes don't go left to right. Japanese boxes sometimes line up on a vertical line, sometimes on a horizontal one. Nastaleeq boxes don't line up on a perpendicular line at all. Thai lines don't break at spaces. The next line in Mongolian is to the right of the previous one, not underneath it; but in Japanese it's to the left.
但在处理世界上的其他#tr[scripts]时，这些预设中的每一条都会有不符合的情况。泰卢固文的#tr[glyph]盒子并不沿着一条线逐个排列；希伯来文不是从左往右写的；日文有时候竖着写有时候又横着写；波斯体#tr[script]甚至是斜着写的；泰语不用空格断行；蒙文的下一行在右边而不是下方；而日文的下一行又在左边……

// What we want to do in this chapter is gain a more sophisticated understanding of the needs of complex scripts as they relate to text layout, and think about how to cater for these needs.
本章的目的是深入理解复杂#tr[scripts]在文本#tr[layout]方面的需求，并思考如何满足这些需求。

#note[
  // I'm going to moralize for a moment here, and it's my book, so I can. Once upon a time, a company made a [racist soap dispenser](https://gizmodo.com/why-cant-this-soap-dispenser-identify-dark-skin-1797931773). It looked for skin reflection to see if it needed to dispense soap, and because it didn't see reflection from darker skin, it didn't work for black people. I'm sure they didn't intend to be racist, but that doesn't actually matter because [racism isn't about intention, it's about bias](https://edition.cnn.com/2014/11/26/us/ferguson-racism-or-racial-bias/index.html).
  我要在这里要进行一番道德说教。这是我的书，我想写什么就写什么。从前，有一家公司制作了一个“种族歧视的洗手液机”@Fussell.WhyCan.2017。它通过检测皮肤的反射来决定是否需要挤出洗手液，但黑人无法让它工作。我确信这并非是有意的种族歧视，但是否有意并不重要。因为“种族主义不在于意图，而在于偏见”@Blake.NewThreat.2014。

  // > Because they didn't think about situations beyond their own experience, and clearly didn't *test* situations beyond their own experience, those involved ended up creating a system that discriminated. What's this got to do with text layout? As it turns out, quite a lot.
  他们没有考虑超出自身经验的情况，并且显然也没有在超出自身经验的情境下进行测试，所以相关人员最终设计出了一个具有歧视性的系统。那么这和文本#tr[layout]有什么关系呢？事实证明它们关系匪浅。
  
  // > Now you're reading this book, which is a good start, because it probably means you care about global scripts. But so many programmers coming to layout think "I don't need to use an external library for this. I'll just do it myself. See, it's easy to get something working. We can add the complicated stuff later". So they write some code that works with *their* script (usually Latin), and yes, it is quite easy. They feel very pleased with themselves. Then later a user requires Arabic or Hebrew support, and they look at the problem again, and they realise it's actually not easy. So they put it off, and it never happens.
  你现在在读这本书，这是一个好的开始，因为这说明你很可能是关心#tr[global scripts]的。但有太多的开发人员遇到#tr[layout]问题时会想：“这应该不需要引入一个外部库吧，我自己写一个就行。你看，它确实能正常工作。更复杂的东西就以后再说吧。”他们编写了一些能处理自己用的#tr[script]（通常时拉丁文）的代码，这确实很简单，写完代码后他们心情愉悦。之后有个用户要求支持阿拉伯文或者希伯来文，这让他们再一次审视这个问题，并意识到实际上它并不简单。结果就是他们决定暂时忽略这个需求，直到永远。
  
  // > What's the moral of this story? 1) It's no more acceptable to write a text layout system that only works for one minority script than it is to make a soap dispenser that only works for white people. 2) Don't write half-assed text layout code until you've read this chapter and realised how big a deal this global scripts stuff is, and then go and use one of the libraries we'll discuss in further chapters instead.
  这个故事的寓意是什么呢？一是编写一个仅适用于少数#tr[scripts]的文本#tr[layout]系统，其不可接受程度不亚于制造一个仅适用于白人的洗手液机。二是希望在你阅读本章并意识到#tr[global scripts]处理的复杂程度之前，不要草率地编写文本#tr[layout]代码。请选择使用我们在后续章节中将介绍的程序库。
]

// ## Bidirectionality
== 双向文本

// Let's begin with the idea that the boxes are lined up left to right. Clearly, in scripts like Hebrew and Arabic, that's not correct: they go right to left. Hebrew and Arabic between them have half a billion users, so supporting right-to-left text isn't really optional, but what about other scripts?
我们先从#tr[script]是从左往右写的这一假设开始。很明显，在希伯来文和阿拉伯文之类的#tr[scripts]里不是这样的，它们从右向左写。希伯来文和阿拉伯文加起来大约有五亿用户，所以对从右向左的文本的支持并不是可有可无的。还有其他从右向左书写的#tr[scripts]吗？

// There are a number of other scripts in the Semitic family - some living, such as Mandaic, and others which are mainly of historic interest, such as Samaritan, Phoenician and Lydian; then there are scripts like N'Ko, which represents a Mande language of West Africa but whose design was heavily influenced by Arabic, and Adlam, a recently constructed script for Fulani. The point is, you can't just check if a text is Hebrew or Arabic to see if it needs special processing - you need (as with everything) to check the Unicode Character Database instead, which has a field for each character's directionality.
闪米特语族下有很多#tr[scripts]都是从右向左的。其中有些还在使用，比如曼达文；另一些则有历史意义，比如撒马利亚、腓尼基和吕底亚字母。另外还有N'ko字母，这是一种用于表记西非曼德语系的#tr[script]，其设计深受阿拉伯文影响。最近为富拉语创造的阿德拉姆文也是从右向左的。我想说的是，你不能只通过检查文本是不是希伯来或阿拉伯字母来判定它是否需要特殊处理。和之前一样，你需要查询Unicode#tr[character]数据库，其中每个#tr[character]都有一个关于书写方向的字段。

// When you have determined that a text is actually in a right-to-left script, what special processing is needed? Unfortunately, it is not just as simple as flipping the direction and taking away numbers from the X coordinate instead of adding them. The reasons for this is that, while handling *directionality* is conceptually simple, the problems come when you have to handle *bidirectionality* (often called *bidi*): documents containing text in more than one direction. That might sound obscure, but it's actually exceptionally common. A document in Arabic may refer to the name of a foreign person or place, and do so in Latin script. Or a document like this in English might be deliberately refer to some text in العربية. When this happens, just flipping the direction has disastrous results:
当你确定文本使用了从右向左的#tr[script]后需要进行哪些特殊处理呢？简单的将方向反转，把X轴上的加法变成减法是远远不够的。其原因在于，虽然文本只有一个方向时这样简单处理是可行的，但如果文本是双向（也称为 bidi）的就会出问题了。你可能觉得这种情况很少见，但实际上这相当普遍。阿拉伯文的文档中可能需要提到国外的人名和地名，此时会使用拉丁字母。英语的文档中也可能会用到#arabic[العربية]。在这些情况下，简单的翻转方向会造成惨重的后果（@figure:bidi-fail）。

#figure(
  placement: top,
  caption: [],
)[#include "bidi-fail.typ"] <figure:bidi-fail>

// “I know,” you might think, “I’ll just work out how long the Arabic bit is, move the cursor all the way to the end of it, and then work backwards from there.” But of course that won’t work either, because there might be a line break in the middle. Worse still, line breaks do interesting things to bidirectional texts. The following example shows the same text, “one two שלוש (three) ארבע (four) five”, set at two different line widths:
你可能会想：“我懂了，我只需要先计算好阿拉伯文的长度，然后把光标直接移动到它结尾（也许是开头？）的地方，接着从那开始往回走就行了。”但是这个办法也行不通，因为可能在计算中途碰到换行。更糟糕的是，换行对双向文本还有很多其他有趣的影响。下面的示例演示了相同的文本“one two #hebrew[שלוש] (three) #hebrew[ארבע] (four) five”在不同行宽下的表现差异：

#block(width: 100%)[
  #set par(justify: false)
  #set text(size: 2.4em)
  #let same-text = [one two #hebrew[שלוש ארבע] five.]
  #align(left)[
    #same-text
    #block(width: 7em)[#same-text]
  ]
]

// Notice how the word "שלוש (three)" appears as the *second* Hebrew word on the wider line, and the *first* Hebrew word on the narrower line? This is because we're thinking left to right; if you think about the lines from right to left, it's the first Hebrew word each time.
你注意到了吗？表示三的单词 #hebrew[שלוש] 在足够长的行宽时显示在四的后面，但是当行宽不足时，它却变成了第一个显示的？会有这个疑问是因为我们还是在按照从左往右的思路思考。如果你换成从右向左的视角的话，那么在两种情况下，三都是第一个显示的希伯来语单词。

// Thankfully, this is a solved problem, and the answer is the Unicode Bidirectionality Algorithm.
值得庆幸的是，这道难题已经被解决了。答案就是Unicode双向算法@Unicode.UAX9.15.1。

#note[
  // > I'm not going to describe how the Unicode Bidirectionality Algorithm works, because if I do you'll try and implement it yourself, which is a mistake - it's tricky, it has a lot of corner cases, and it's also a solved problem. if you are implementing text layout, you need to support bidi, and the best way to do that is to use either the [ICU Bidi library](https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/ubidi_8h.html), [fribidi](https://github.com/fribidi/fribidi), or an existing layout engine which already supports bidi (such as [libraqm](https://github.com/HOST-Oman/libraqm)).
  我不会解释Unicode双向算法的细节工作原理，因为我一旦解释了你就会尝试自己实现它，但这往往就是错误的开始。这个算法非常复杂，需要处理很多边界情况。而且毕竟这是个已经解决的问题了，如果你需要实现支持双向文本的#tr[layout]软件，最好的方式是使用ICU Bidi@Unknown.ICUUbidi、FriBidi@Unknown.GNUFriBidi，或者直接使用已经支持了双向文本的#tr[layout]引擎（比如libraqm@Unknown.Libraqm）。
]

// Oh, all *right*. I'll tell you a *bit* about how it works, because the process contains some important pieces of terminology that you'll need to know.
好吧，给你透露一点它的工作原理吧，因为也有部分技术细节即使对于使用者来说也很重要。

// First, let's establish the concept of a *base direction*, also called a *paragraph direction*. In this document, the base direction is left to right. In a Hebrew or Arabic document, the base direction could will be right to left. The base direction will also determine how your cursor will move.
首先，我们要介绍基础方向，也可以叫做段落方向。在本书中，基础方向是从左向右的。在希伯来或阿拉伯文的书中，基础方向可能就是从右向左的。基础方向会决定光标的移动方式。

// Unicode text is always stored on disk or in memory in *logical order*, which is the "as you say it" order. So the word "four" in Hebrew ארבע is always stored as aleph (א) resh (ר) bet (ב) ayin (ע). The task of the bidi algorithm is to swap around the characters in a text to convert it from its logical order into its *visual order* - the visual order being the order the characters will be written as the cursor tracks along the paragraph. The bidi algorithm therefore runs sometime after the text has been retrieved from wherever it is stored, and sometime before it is handed to whatever is going to draw it, and it swaps around the characters in the input stream so that they are in visual order. You can do this before the characters are handed to the shaper, but it's best to do it after they have been shaped - it's a bit more complicated this way, because after characters have been shaped they're no longer characters but glyph IDs, but your shaper will also tell you which position in the input stream refers to which glyph ID, so you can go back and map each glyph to characters for bidi processing purposes.
Unicode文本在内存或磁盘上储存时永远使用*逻辑顺序*，也就是当你念出这段文本时的发音顺序。因此，希伯来文中的单词四 #hebrew[ארבע] 在文本中永远是按照 `aleph`（#hebrew[א]）`resh`（#hebrew[ר]）`bet`（#hebrew[ב]）`ayin`（#hebrew[ע]）的顺序排列的。双向算法的任务是交换文本中的#tr[character]，将其从逻辑顺序转换为*视觉顺序*，也就是光标在段落中移动时的书写顺序。因此，双向算法的应用时机需要在文本从储存位置取出之后，进入渲染组件之前。它需要交换输入流中的#tr[character]，使他们形成视觉顺序。理论上你可以在文本进入#tr[shaper]前执行这一步，但最好还是放在#tr[shaping]完成后。这种方式会编码起来会更复杂一些，因为#tr[character]经过#tr[shaping]之后就不再是#tr[character]而是#tr[glyph]ID了。但#tr[shaper]也会告诉你每个输入流中的每个位置对应哪个#tr[glyph]。这样你就可以回过头来，将每个#tr[glyph]映射回#tr[character]，再进行双向文本处理。

// For example, in this paragraph, we have the words "Hebrew ארבע". You say (and store) the aleph first, but we want the aleph to visually appear at the end:
举例来说，我们有一段文本“Hebrew #hebrew[ארבע]”。在发音是和储存时都是`aleph`在前，但显示时我们想让`aleph`去到最后：

#block(width: 100%, stroke: 1pt + gray)[
#show regex(`\p{Hebrew}+`.text): hebrew

#table(
  columns: 3,
  stroke: none,
  [逻辑顺序], [：], [`H e b r e w   ע ב ר א`],
  [视觉顺序],[：], [`H e b r e w   א ר ב ע`],
)
]

// The first step in the algorithm is to split up the input into a set of *runs* of text of the same *embedding level*. Normally speaking, text which follows the *base direction* is embedding level 0, and any text which goes the opposite direction is marked as being level 1. This is a gross simplification, however. Let's consider the case of an English paragraph which contains an Arabic quotation, which has within it a Greek aside. In terms of solving the bidirectionality problem, you could think of this as four separate runs of text:
双向算法的第一步是将文本分割成具有相同嵌入级别的“块”。简单来说，和基础方向一致的文本属于0级嵌入，相反的则被标记为1级嵌入。这种说法是经过了大量简化之后的版本。尝试考虑下以下情形，一个英文段落中引用了一段阿拉伯文内容，然后这段内容里有一段希腊文。为了解决双向问题，你可以将这段文本分为四块：

#figure(
  placement: none,
)[#include "bidi-unembedded.typ"]

// However, Unicode defines ways of specifying that the Greek is embedded within the Arabic which is in turn embedded within the English, through the addition of U+202A LEFT-TO-RIGHT EMBEDDING and U+202B RIGHT-TO-LEFT EMBEDDING characters. While it is visually equivalent to the above, this maintains the semantic distinction between the levels:
但是，Unicode定义了一种能够清晰地指明希腊文嵌入到了阿拉伯文中，而阿拉伯文又嵌入了英文中的方式。这就是 `U+202A LEFT-TO-RIGHT EMBEDDING` 和 `U+202B RIGHT-TO-LEFT EMBEDDING`#tr[character]。虽然在视觉层面和上图没有区别，但这保持了不同嵌入级别之间的语义区别。

#figure(
  placement: none,
)[#include "bidi-embedding.typ"]

#note[
  // > There are a bunch of other similar bidi control characters defined by the Unicode standard, which we're not going to mention here, but which a conformant bidi algorithm will need to deal with.
  Unicode中定义了不少这种双向控制#tr[character]，我们这里就不具体介绍了。但一个符合标准的双向算法实现需要能完善地处理它们。
]

// Once the bidi algorithm has established the embedding levels, it can re-order the glyphs such that the text appears in visual order. Hooray - we're done with bidirectionality! Except that we're not, of course: for example, groups of numbers embedded in RTL text should *not* be swapped around; brackets and other paired characters should be *mirrored* rather than reordered:
当完成嵌入等级的计算后，双向算法就可以将#tr[glyph]重新调整为视觉顺序了。太好啦，我们搞定双向文本支持了！啊不，其实并没有……比如说，从右向左的文本中的数字*不应该*被调整方向；括号等其他成对使用的#tr[character]在被重新排序后，还需要*镜像翻转*：

#block(width: 100%, stroke: 1pt + gray)[
#show regex(`\p{Hebrew}+`.text): hebrew

#table(
  columns: 3,
  stroke: none,
  [逻辑顺序], [：], [`H e b r e w  ( 1 2 3 ע ב ר א )`],
  [错误的视觉顺序],[：], [`H e b r e w  ) 3 2 1 ע ב ר א (`],
  [正确的视觉顺序],[：], [`H e b r e w  ( 1 2 3 א ר ב ע )`],
)
]

// The Unicode Character Database contains information about which characters have *weak* directionality, such as numerals, which should be treated specially by the bidirectionality algorithm, and also which characters have mirrored pairs. The Unicode Bidirectionality Algorithm specifies the rules for handling this data correctly so that all the nasty corner cases work out fine.
Unicode#tr[character]数据库会标记出哪些#tr[character]是*弱*双向性的，在双向算法中这些#tr[character]需要进行特殊处理，比如数字就是*弱*双向#tr[character]。数据库也会标记哪些#tr[character]有着镜像翻转的成对版本。Unicode双向算法对这些特殊数据都设计好了处理规则，确保所有深藏着的边界情况都能得到妥善的处理。

// So, as a layout system implementer, how should you proceed? The recommendation in the UAX #9 which specifies the algorithm recommends that text is first handed to the bidi algorithm to resolve the levels, then the runs identified by the algorithm are passed to the shaper to be shaped independently, and then the reordering should take place. But that's just the recommendation. In reality, it doesn't actually matter *when* you shape the runs. `libraqm` resolves the levels, then reorders, then shapes; the SILE typesetter shapes, then resolves the levels, then reorders. So long as you perform all the steps on the appropriate runs, it will all work out.
所以#tr[layout]系统的开发者到底应该使用什么处理流程呢？提出双向算法的Unicode标准9号附件中建议：先使用双向算法处理文本，确定其中的嵌入级别；然后将相同级别的文本块单独送入#tr[shaper]进行#tr[shaping]；最后进行重排序。但这毕竟只是推荐，在实际实现中，何时对文本块进行#tr[shaper]其实影响不大。libraqm@Unknown.Libraqm 选择在计算嵌入级别后就进行重排序。SILE#tr[typeset]软件先进行#tr[shaping]，然后才计算嵌入级别，最后重排序。只要你适当地对每个文本块都执行了这些步骤，应该都能得到正确结果。

// For example, using `fribidi`, the routine would look something like this:
例如，使用FriBidi@Unknown.GNUFriBidi 时，整个流程如下：

#[
#set text(0.82em)

```C
/* 计算嵌入等级 */
FriBidiCharType* btypes = calloc(string_l, sizeof (FriBidiCharType));
FriBidiBracketType *bracket_types = calloc(string_l, sizeof(FriBidiBracketType);
FriBidiLevel *embedding_levels = calloc(string_l, sizeof(FriBidiLevel));

FriBidiParType base_dir = FRIBIDI_PAR_LTR; // 或者使用 _RTL
fribidi_get_bidi_types(string, string_l, &btypes);
fribidi_get_bracket_types(string, string_l, btypes, &bracket_types);
fribidi_get_par_embedding_levels_ex(btypes,
                                    bracket_types,
                                    string_l,
                                    &base_dir,
                                    &embedding_levels);

/* 为每个文本块进行造型 */
for (size_t i = 0; i < run_count; i++)
```
]

#pagebreak()

// ## Other directionality (vertical etc.)
== 其他书写方向 <heading:not-finish-point>

垂直等。

// ## Shaping challenges (Bengali etc.)
== #tr[shaping]中的难题

孟加拉文等。

// ## Arabic connection
== 阿拉伯文中的连接

// ## Line breaking & word detection
== 断行与分词

// ### CJK
=== 汉字

// ### South Asian scripts
=== 南亚#tr[scripts]
