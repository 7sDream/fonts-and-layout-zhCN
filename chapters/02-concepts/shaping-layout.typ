#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

== #tr[shaping]和#tr[layout]

// I've called this book "Fonts and Layout for Global Scripts", because I wanted it to be about the whole journey of getting text through a computer and out onto a display or a piece of paper. Having the fonts designed and engineered correctly is the first step in this; but there's a lot more that needs to be done to use those fonts.
我把本书起名叫《#tr[global scripts]的字体与#tr[layout]》，因为我想让它涵盖计算机从获取文本到输出到显示器或纸上的整个过程。正确的字体设计和字体工程只是第一步，想运用好这些字体还需要很多其他的工作。

// There are a number of stages that the letters and numbers you want to typeset go through in order to become the finished product. To begin with, the user (or in some cases, the computer) will choose what font the text should be typeset in; the text, and the choice of font and other typographic details, are the inputs to the process. These two inputs pass through some or all of the following stages before the text is set:
从输入字母和数字到获得最终的#tr[typeset]结果之间有好几个步骤。首先，用户（或计算机）会选择文本应该用什么字体；然后文本、字体以及其他#tr[typography]细节将作为整个过程的输入。在文本被#tr[typeset]出来前，这些输入信息会经历@figure:pipeline 所示的部分或所有阶段。

#figure(caption: [
  计算机中文本处理的流程简图
], include "pipeline.typ") <figure:pipeline>

// We can understand most of these steps by taking the analogy of letterpress printing. A compositor will be given the text to be set and instructions about how it is to look. The first thing they'll do is find the big wooden cases of type containing the requested fonts. This is *font management*: the computer needs to find the file which corresponds to the font we want to use. It needs to go from, for example, "Arial Black" to `C:\\Windows\\Fonts\\AriBlk.TTF`, and so it needs to consult a database of font names, families, and filenames. On libre systems, the most common font management software is called [fontconfig](https://www.fontconfig.org); on a Mac, it's [NSFontManager](https://developer.apple.com/documentation/appkit/nsfontmanager?language=objc).
要理解其中的大多数步骤，可以将其类比于凸版印刷。排版工会拿到一些文本，以及关于如何呈现它们的指令。他首先要找到装有相应字体的木箱，这就是*字体管理*：计算机需要找到与我们使用的字体相对应的文件。例如，它会从“Arial Black”找到`C:\Windows\Fonts\AriBlk.TTF`。而这就需要一个有关字体名称、#tr[typeface family]信息和文件名的数据库。在自由操作系统上最常用的字体管理软件是fontconfig@Unknown.Fontconfig，在 Mac 上则是NSFontManager@Apple.NSFontManager。

// They'll also have to make sure they can read the editor's handwriting, checking they have the correct understanding of the input text. In the computer world, correctly handling some scripts may require processes of reordering and re-coding required so that the input is correctly interpreted. This is called Unicode processing, and as we will see in the next chapter, is often done using the [ICU](http://site.icu-project.org) library.
排版工还要有能力阅读编辑给的手写文本，并确认他们对这些文本的理解是否正确。在计算机世界中，可能需要经过重排序和重编码等过程才能正确解读输入的文本，尤其是对含有非拉丁#tr[script]的场景。这一过程称为Unicode处理，通常使用ICU程序库#[@UnicodeConsortium.ICU]完成，我们将在下一章中介绍这一步骤。

// > Yes, that example was a bit of a stretch. I know.
#note[好吧，我知道这个例子有点牵强。]

// Next, the hand compositor will pick the correct metal sorts for the text that they want to typeset.
接下来，排版工要挑选正确的金属#tr[sort]来#tr[typeset]文本。

#figure(
  caption: [装有金属#tr[sort]的#tr[compositing stick]],
)[#image("512px-Handsatz.jpg", width: 80%)]

// They will need to be aware of selecting variants such as small capitals and swash characters. In doing this, they will also *interpret* the text that they are given; they will not simply pick up each letter one at a time, but will consider the desired typographic output. This might mean choosing ligatures (such as a single conjoined "fi" sort in a word with the two letters "f" and "i") and other variant forms when required. At the end of this process, the input text - perhaps a handwritten or typewritten note which represents "what we want to typeset" - will be given concrete instantiation in the actual pieces of metal for printing. When a computer does this selection, we call it *shaping*. On libre systems, this is usually done by [HarfBuzz](https://www.harfbuzz.org/); the Windows equivalent is called [DirectWrite](https://docs.microsoft.com/en-us/windows/win32/directwrite/direct-write-portal) (although this also manages some of the later stages in the process as well).
他们还会选取各种变体，例如小型大写字母和花笔#tr[character]，这其实是对文本的一种*演绎*。他们不只是简单地逐个选取字母，而是会考虑所需的#tr[typography]效果。比如他们会根据需要选择连字（例如用一个fi的#tr[sort]代替单词中的字母f和i）等变体形式。这一步骤完成后，输入的文本——代表了“我们想要排版的东西”的手写或打字稿——就被转化为了用以交付印刷的金属块。当在计算机中做这些工作时，我们将其称为*文本#tr[shaping]*。在自由操作系统上，这通常交由HarfBuzz#[@Unknown.HarfBuzz]完成；在Windows上则可以采用DirectWrite API@Microsoft.DirectWriteAPI（虽然它也参与了若干后续过程）。

// At the same time that this shaping process is going on, the compositor is also performing *layout*. They take the metal sorts and arrange them on the compositing stick, being aware of limitations such as line length, and performing whatever spacing adjustments required to make the text look natural on the line: for some languages, this will involve hyphenation, the insertion of spaces of different widths, or even going back and choosing other variant metal sorts to make a nicer word image. For languages such as Thai, Japanese or Myanmar which are written without word breaks, they will need to be aware of the semantic content of the text and the typographic conventions of the script to decide the appropriate places to end a line and start a new one.
在#tr[shaping]的同时，排版工还需要进行*#tr[layout]*。他们会把金属#tr[sort]排列在#tr[compositing stick]上，同时考虑行高等限制。他们还会进行必要的间距调整，以使得文本看起来更加自然。对于一些语言，这需要引入连字符、插入不同宽度的空格，或者回过头重新选择看起来更舒服的其他变体。而对于泰文、日文和缅甸文等不需要断词的文本，则可能需要考虑其语义和排版习惯，以此来确定换行的合适位置。

// In a computer, this layout process is normally done within whatever application is handling the text - your word processor, desktop publishing software, or design tool - although there are some libraries which allow the job to be shared.
在计算机中，#tr[layout]的过程通常由操作文本的软件完成——比如文字处理软件、桌面出版软件、设计工具等——也有一些专门负责处理这一工作的公共库。

// Finally, the page of type is "locked up", inked, and printed. In a computer, this is called *rendering*, and involves *rasterizing* the font - turning the outlines into black and white (and sometimes other colored!) dots, taking instructions from the font about how to make the correct selection of dots for the font size requested. Once the type has been rasterized, it's generally up to the application to place it at the appropriate position on the screen or represent it at the appropriate point in the output file.
最后，这些排好的页面会被“固定”、上墨以及印刷。在计算机中。这一步称为*#tr[rendering]*，即对字体进行*#tr[rasterization]*。字体的#tr[outline]会被转化为黑白（有时候也会是彩色的！）的小点，而在特定字号下如何正确排布这些点则会根据字体中的指令来确定。一旦#tr[rasterization]完成，通常就会由应用程序将其放置在屏幕或输出文件的正确位置上。

// So using a font - particularly an OpenType font - is actually a complex dance between three actors: the top level providing *layout* services (language and script handling, line breaking, justification), the *shaping* engine (choosing the right glyphs for the input), and the font itself (which gives information to the shaping engine about its capabilities). John Hudson calls this the "OpenType collaborative model", and you can read more about it in his [Unicode Conference presentation](http://www.tiro.com/John/Hudson_IUC39_Beyond_Shaping.pdf).
因此，使用字体——尤其是OpenType字体——实际上是有三位演员参与的复杂舞蹈：顶层的*#tr[layout]*服务（语言和#tr[script]处理、断行、对齐等），*#tr[shaping]*引擎（为输入文本选择合适的#tr[glyph]）以及字体本身（它会告知#tr[shaping]引擎自己带有的功能）。John Hudson称之为“OpenType 合作模型”<concept:opentype-collaborative-model>，关于这个模型的更多内容，可以参考他在Unicode会议上的报告@Hudson.ShapingGeneral.2015。
