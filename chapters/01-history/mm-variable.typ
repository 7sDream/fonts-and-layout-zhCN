#import "/template/template.typ": web-page-template
#import "/template/components.typ": note, title-ref

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## Multiple Masters and Variable fonts
== #tr[multiple master]和#tr[variable font]

// In 1540, François Guyot released the first *typeface family* - his Double Pica included two alphabets, one upright Roman and one italic. Around four hundred years later, the concept of a "related bold" was added to the typeface family idea.[^13] Users of type now expect to be able to select roman, bold, italic, and bold italic forms of Latin fonts, but more to the point, Latin script users now use both *speed* (italic) and *weight* to create typographic differentiation and establish hierarchy. Not long after, in 1957, Adrian Frutiger's Univers was designed based on a typographic system of nine weights, five widths, and a choice of regular and oblique - a potential 90-member family, although in practice far fewer cuts of Univers were actually designed.
1540 年，François Guyot 发布了第一个*#tr[typeface family]*——他的Double Pica包含两套字母，一套是直立的罗马体、另一套是意大利体。大约四百年后，“相关粗体”的概念被添加到#tr[typeface family]中@Tracy.LettersCredit.1986[65-66]。如今，字体用户希望能选择拉丁字体的罗马体、粗体、意大利体和粗意大利体形式。更重要的是，拉丁字母的使用者们往往会同时使用*速度*（意大利体）和*重量*来展现版面差异和构建层次。在不久之后的1957年，Adrian Frutiger设计了Univers字体，它包含9个字重、5种宽度以及直立倾斜的变化，是一个共有90个成员的家族，尽管实际上只有其中的一小部分完成了设计。

// But what if nine weights is not enough? More realistically, what if the designer has only provided a regular and a related bold, and you need something in the middle? The one development Adobe attempted to make to their Type 1 PostScript font format in 1991 was the idea of *multiple masters* which aimed to solve this problem: the font would contain two or more sets of outlines, and the user could "blend" their own font from some proportion of the two. They could mix 3 parts the regular weight to 1 part bold weight to create a sort of hemi-semi-bold.
但如果九个字重还不够怎么办？更现实的是，如果设计师只提供了常规字体和对应的粗体，而你恰好需要它们之间的某个粗细又该怎么办？Adobe在1991年尝试为PostScript Type 1字体格式开发了*#tr[multiple master]*的构想（@figure:MM），其目的就是为了解决这个问题。该字体包含两套或更多的#tr[outline]，用户按照一定比例进行“混合”，就可以得到自己想要的字体。比如可以把3份常规字重与1份粗体混合，得到一种1/4粗体。

#figure(caption: [
  // > Adobe Myriad MM, with width (left to right) and weight (top to bottom) masters
  Adobe Myriad MM，带有宽度（从左到右）和字重（从上到下）#tr[master]。
])[#image("MM.png")] <figure:MM>

// It was a great idea; the designers were excited; technologically, it was a triumph. Adobe worked hard to promote the technology, redesigning old families as MM fonts. But it turned out to be way ahead of its time. For one thing, very few applications provided support for accessing the masters and generating the intermediate fonts (called "instances"). For another, handling the instances was a mess. "Users were forced to generate instances for each variation of a font they wanted to try, resulting in a hard drive littered with font files bearing such arcane names as `MinioMM_578 BD 465 CN 11 OP`."[^14]
这是一个好主意，设计师们兴奋不已。从技术上讲，这也是一次胜利。 Adobe努力推广该技术，将之前的#tr[typeface family]重新设计为#tr[multiple master]字体。但事实证明，这一技术过于超前。一方面，很少有应用程序支持访问#tr[master]或生成的中间字体（称为“#tr[instance]”）；另一方面，处理这些#tr[instance]非常麻烦。“用户被迫为他们想要尝试的每种字体生成#tr[instance]，导致硬盘上充斥着带有`MinioMM_578 BD 465 CN 11 OP`之类诡异名称的字体文件。”@Riggs.AdobeOriginals.2014

// Adobe Multiple Master Fonts, as a technology, ended up dying a quiet death. But the concept of designing fonts based on multiple masters (originally borrowed from the Ikarus system) became an established tool of digital type design. Instead of allowing the user the flexibility to create whatever instance combination they wanted, type designers would create multiple masters in their design - say, a regular and a black - and release a family by using interpolation to generate the semibold and bold family members.
作为一种技术，Adobe#tr[multiple master]字体最终悄无声息的死去了。 但是，基于#tr[multiple master]设计字体的理念（最初是从Ikarus系统借鉴来的）已成为数字字体设计的标配。字体设计师不再允许用户灵活地创建所需的#tr[instance]组合，而是在设计时创建多个#tr[master]（如常规体和超粗体），然后插值生成半粗体和粗体等#tr[typeface family]成员。

// Another attempt at the dream of infinitely tweakable in-between fonts came from Apple, as part of their GX font program. As we mentioned above, Apple's extensions to TrueType included the ability to create instances of fonts based on variations of multiple masters. But the same thing happened again: while it was typographically exciting, application support never came through, as supporting the format would require extensive software rewrites. But this time, there would be a longer lasting impact; as we will see in [the section on OpenType Font Variations](opentype.md#OpenType Font Variations), the way that GX fonts implemented these variations has been brought into in the OpenType standard.
作为GX字体程序的一部分，Apple为实现无级可调中间字体的梦想尝试了另一种方式。前文也提到过，Apple对TrueType的扩展包括基于#tr[multiple master]之间的变化创建字体#tr[instance]的功能。然而，同样的事情又再次发生了：尽管#tr[typography]行业对其感到兴奋，但在应用层面却从未得到支持，因为支持这种格式需要对软件进行大规模的重构。但这次产生的影响更加持久，正如我们将在#title-ref(<heading:opentype.font-variation>, web-path: "/chapters/04-opentype/variation.typ", web-content: [OpenType可变字体])一节中看到的那样，GX字体实现这种变体的方式已被纳入了OpenType标准中。

// OpenType finally adopted variable fonts in 2016. We're still waiting to see how applications will support the technology, but this time the success of variable fonts doesn't depend on application support. There is another, more important factor behind the rise of variable fonts: bandwidth. With fonts increasingly being hosted on the web, variable font technology means that a regular and a bold can be served in a single transaction - a web site can use multiple fonts for only slightly more bytes, and only a few more milliseconds, than a single font.
在2016年，OpenType终于支持了#tr[variable font]。我们仍然期待应用程序能支持该技术，但这次#tr[variable font]的成功并不依赖应用程序的支持。#tr[variable font]的广泛使用还有另一个更重要的因素：带宽。随着字体越来越多地托管在网络上，#tr[variable font]技术意味着可以在一次请求中同时获取常规体和粗体——网站使用多种变体相对单个字体的额外开销，可能只是几字节几毫秒而已。
