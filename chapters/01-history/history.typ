#import "/template/template.typ": web-page-template
#import "/template/heading.typ": chapter
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

#chapter[
  // A Brief History of Type
  字体简史
]

// Once upon a time, a *font* was a bunch of pieces of metal. The first recorded use of metal type for printing comes from China. In 13th century, banknotes were printed with anti-counterfeit devices printed using blocks of bronze;[^2] the first metal type books were produced in Korea around the same time.[^1] Two hundred years later, Johannes Gutenberg came up with a similar system for creating metal type that would spread rapidly over Europe and continue to be the most common means of printing until the 19th century.
在很久以前，*字体*这个词指的是一堆金属块。关于金属印刷的最早记录来自中国。在13世纪，带有防伪措施的纸币就已经使用铜版来印制@Pan.ZhongGuo.2001[273]；几乎同一时间，朝鲜半岛也首次出现了金属印刷的书籍@Park.HistoryPreGutenberg.2014。两百年之后，Johannes Gutenberg发明了一种类似的金属活字系统，它很快传遍了欧洲，并且作为最普遍的印刷技术一直延续到19世纪。

// To create type for printing, engravers would work the images of letters, numbers and so on into punches. Punches would then be struck into a mold called a *matrix*. The typemaker would then use the matrices to cast individual pieces of type (also known as *sorts*). A complete set of type sorts in the same size and style was collected together into a *font* of type.
为了制作印刷用字，刻字师会将字母、数字等的图形雕刻在#tr[punch]上，字冲则会被敲入称为*#tr[matrix]*的模具中。接下来，铸字师会用#tr[matrix]翻刻出一个个的字，这被称为*#tr[sort]*。同样尺寸和样式的一组#tr[sort]就构成了一套*字体*（@figure:fonts）。

#figure(caption: [
  // A box of fonts cast by the Australian Type Foundry. The font on the top left is a 14pt Greek typeface by Eric Gill.
  一套Australian Type Foundry铸造的字体。左上是Eric Gill设计的 14pt 希腊字母。
])[
  #image("fonts.jpg")
] <figure:fonts>

// Complete fonts of type would be placed into type cases, from which compositors would then select the sorts required to print a page and arrange them into lines and pages. Next, the printer would cover the face of the metal with ink and impress it onto the paper. With the advent of hot metal typesetting, which combined casting and compositing into one automated activity, the idea of a font of type fell out of fashion.
一套完整的字体会被放在#tr[type case]中，排版工将从中挑选出排版所需的#tr[sort]，并将它们逐行、逐页地排好。之后，印刷机会在金属的表面覆盖一层油墨，再压印到纸上。随着将铸字与排版合二为一的#tr[hot metal typesetting]的诞生，成套的印刷字体也逐渐落后于潮流。

// The idea was revived with the advent of digital typography. In 1964, the IBM 2260 Display Station provided one of the first text-based visual interfaces to a computer.[^3] The mainframe computer would generate the video signal and send it to the terminal, pixel by pixel: each character was 9 pixels wide and 14 pixels tall. The choice of bitmaps for each character, what we would now call the font, was hard-wired into the mainframe, and could not be changed.
随着数字印刷术的出现，这个想法又得以复兴。1964年，IBM 2260 Display Station 为计算机提供了第一个基于文本的可视化界面@DaCruz.IBM2260.2001。大型机生成视频信号，并将其逐像素发送到终端：每个字符9像素宽、14像素高。代表字符的这些#tr[bitmap]（我们今天称为字体）是被硬编码在大型机中的，无法进行修改。

// Much has changed since the early bitmap fonts, but in a sense one thing has not. The move from Gutenberg's rectangular metal sorts to rectangular 9x14 digital bitmaps ensured that computer typography would be dominated by the alignment of rectangles along a common baseline - an unfortunate situation for writing systems which don't consist of a straight line of rectangles.
从早期的#tr[bitmap]到今天，字体已经有了天翻地覆的变化，但有样东西却从未变过。从Gutenberg使用的矩形金属活字，到9x14的数字#tr[bitmap]，它们决定了计算机字体技术的主要实现方式：沿着一条#tr[baseline]排列矩形块。这对那些不依靠直线和矩形的#tr[writing system]来说是一件不幸的事。

#figure(caption: [
  // No OpenType for you!
  你可没有 OpenType！
])[#image("640px-Ghafeleye_Omr.svg.png")] <figure:Ghafeleye_Omr>

// This is one of the reasons why I'm starting this book with a description of digital font history: the way that our fonts have developed over time also shapes the challenges and difficulties of working with fonts today. At the same time, the history of digital fonts highlights some of the challenges that designers and implementers have needed to overcome, and will equip us with some concepts that we will get further into as we go through this book. So even if you're not a history fan, please don't skip this chapter - I'll try and make it as practical as possible.
这就是我把数字字体的历史作为本书开端的原因。随着时间的推移，字体的发展历程也造就了今天我们设计、实现和使用字体时的困难和挑战。不过通过本书的后续介绍，这段历史更能让我们了解一些在处理这些难题时需要用到的重要概念。所以即使你不是一个历史迷，也请不要跳过这一章——我会让它尽可能的实用。

// For example, then, in the case of the wonderful Nastaleeq script above, we can understand why this is going to be difficult to implement as a digital font. We can understand the historical reasons behind why this situation has come about. At the same time, it highlights a common challenge for the type designer working with global scripts, which is to find ways of usefully mapping the computer's Latin-centered model of baselines, bounding boxes, and so on, onto a design in which these structures may not necessarily apply. Some of these challenges can be overcome through developments in the technology; some of them will need to be worked around. We will look at these challenges in more detail over the course of the book.
例如，在@figure:Ghafeleye_Omr 所示的波斯体#tr[script]例子中，我们将能够理解为什么把它做成数字字体会很困难。我们可以理解这种情况产生的历史原因。与此同时，它也展现了#tr[global scripts]字体设计师经常面临的难题，即寻找一种把计算机中以拉丁字母为中心的模型——包括#tr[baseline]、#tr[bounding box]等——对应到设计中的手段，而这些东西在设计中却不一定适用。其中的一些挑战可以凭借技术的发展来克服，而有些问题则需要找寻变通的方案。在本书中，我们后续会更为详细地探讨这些挑战。
