#import "/template/template.typ": web-page-template
#import "/template/heading.typ": chapter
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

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
  你现在在读这本书，这是一个好的开始，因为这说明你很可能是关心#tr[global scripts]的。但有太多的开发人员遇到#tr[layout]问题时会想：“这应该不需要引入一个外部库吧，我自己写一个就行。你看，它确实能正常工作。更复杂的东西就以后再说吧。”他们编写了一些能处理自己用的#tr[script]（通常是拉丁文）的代码，这确实很简单，写完代码后他们心情愉悦。之后有个用户要求支持阿拉伯文或者希伯来文，这让他们再一次审视这个问题，并意识到实际上它并不简单。结果就是他们决定暂时忽略这个需求，直到永远。
  
  // > What's the moral of this story? 1) It's no more acceptable to write a text layout system that only works for one minority script than it is to make a soap dispenser that only works for white people. 2) Don't write half-assed text layout code until you've read this chapter and realised how big a deal this global scripts stuff is, and then go and use one of the libraries we'll discuss in further chapters instead.
  这个故事的寓意是什么呢？一是编写仅适用于少数#tr[scripts]的文本#tr[layout]系统，其不可接受程度不亚于制造仅适用于白人的洗手液机。二是希望在你阅读本章并意识到#tr[global scripts]处理的复杂程度前，不要草率地编写文本#tr[layout]代码。请选择使用我们在后续章节中将介绍的程序库。
]
