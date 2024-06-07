#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## Resources
== 参考资料

// To finish, here is a list of resources which may help you when designing and implementing for global scripts:
我们以一个参考资料列表作为本章结尾。

这些资料也许可以在你设计和实现各种#tr[script]的字体时提供帮助：

#let bibentry(key, body, verb: [编写的]) = cite(key, form: "author") + [ ] + verb + body + cite(key, form: "normal")

- 拉丁文#tr[diacritic]设计：
  // - [The Insects Project](http://theinsectsproject.eu) - a downloadable book on issues of Central European diacritic design
  - #bibentry(<Balik.InsectsProject.2016>)[《The Insects Project》，一本关于中欧#tr[diacritic]设计的可下载电子书]
  // - [Problems of Diacritic Design for Latin script text faces](https://gaultney.org/jvgtype/typedesign/diacritics/ProbsOfDiacDesignLowRes.pdf)
  - #bibentry(<Gaultney.ProblemsDiacritic.2008>)[《Problems of Diacritic Design for Latin script text faces》]
  // - [Polish diacritics how-to](http://www.twardoch.com/download/polishhowto/index.html) (Adam Twardoch)
  - #bibentry(<Twardoch.PolishDiacritics.1999>)[《Polish diacritics how-to》文档]
  // - Filip Blažek's [Diacritics project](http://diacritics.typo.cz)
  - #bibentry(<Blazek.DiacriticsProject.2006>, verb: [制作的])[Diacritics project 网站]
  // - [Context of Diacritics](https://www.setuptype.com/x/cod/) analyses diacritics by frequency, combination and language
  - #bibentry(<Job.ContextDiacritics.2013>, verb: [制作的])[《Context of Diacritics》在线项目]，分析了#tr[diacritic]的出现频率、互相作用以及在语言中的使用
// * Danny Trương's [Vietnamese Typography](https://vietnamesetypography.com)
- #bibentry(<Truong.VietnameseTypography>)[关于越南文#tr[typography]的在线电子书《Vietnamese Typography》]
// * Guidance on specific characters:
- 关于特定#tr[character]的设计指导：
  // - [thorn and eth](https://sites.google.com/view/briem/type-design/thorn-and-eth) (Gunnlaugur Briem)
  - #bibentry(<Briem.ThornEth>, verb: [])[关于冰岛字母 thorn 和 eth 的博客文章]
  // - [Tcomma and Tcedilla](https://typedrawers.com/discussion/318/tcomma-and-tcedilla)
  - #bibentry(<PabloImpallari.TcommaTcedilla.2013>, verb: [])[在TypeDrawers论坛上关于 Tcomma 和 Tcedilla 的提问帖]
  // - [German capital sharp s](https://typography.guru/journal/capital-sharp-s-designs/), and [OpenType feature code to support it](https://medium.com/@typefacts/the-german-capital-letter-eszett-e0936c1388f8)
  - #bibentry(<Herrmann.CapitalSharp.2013>, verb: [在TypographyGuru上发表的])[关于德文中大写Sharp S的文章]，在#bibentry(<Koeberlin.GermanCapital.2017>, verb: [的Medium文章])[《The German Capital Letter Eszett》] 中有如何支持此字母的OpenType特性代码
// * Microsoft's script development specifications: [Latin, Cyrillic, Greek](https://docs.microsoft.com/en-gb/typography/script-development/standard); [Arabic](https://docs.microsoft.com/en-gb/typography/script-development/arabic); [Buginese](https://docs.microsoft.com/en-gb/typography/script-development/buginese); [Hangul](https://docs.microsoft.com/en-gb/typography/script-development/hangul); [Hebrew](https://docs.microsoft.com/en-gb/typography/script-development/hebrew); [Bengali](https://docs.microsoft.com/en-gb/typography/script-development/bengali); [Devanagari](https://docs.microsoft.com/en-gb/typography/script-development/devanagari); [Gujarati](https://docs.microsoft.com/en-gb/typography/script-development/gujarati); [Gurmukhi](https://docs.microsoft.com/en-gb/typography/script-development/gurmukhi); [Kannada](https://docs.microsoft.com/en-gb/typography/script-development/kannada); [Malayalam](https://docs.microsoft.com/en-gb/typography/script-development/malayalam); [Oriya](https://docs.microsoft.com/en-gb/typography/script-development/oriya); [Tamil](https://docs.microsoft.com/en-gb/typography/script-development/tamil); [Telugu](https://docs.microsoft.com/en-gb/typography/script-development/telugu); [Javanese](https://docs.microsoft.com/en-gb/typography/script-development/javanese); [Khmer](https://docs.microsoft.com/en-gb/typography/script-development/khmer); [Lao](https://docs.microsoft.com/en-gb/typography/script-development/lao); [Myanmar](https://docs.microsoft.com/en-gb/typography/script-development/myanmar); [Sinhala](https://docs.microsoft.com/en-gb/typography/script-development/sinhala); [Syriac](https://docs.microsoft.com/en-gb/typography/script-development/syriac); [Thaana](https://docs.microsoft.com/en-gb/typography/script-development/thaana); [Thai](https://docs.microsoft.com/en-gb/typography/script-development/thai); [Tibetan](https://docs.microsoft.com/en-gb/typography/script-development/tibetan)
- 微软为各种#tr[script]编写了字体开发规范文档，比如拉丁、西里尔、希腊字母@Microsoft.DevelopingStandard。其他文种的文档包括：阿拉伯文@Microsoft.DevelopingArabic、布吉文、韩文、希伯来文、孟加拉文、天城文@Microsoft.DevelopingDevanagari、古吉拉特文、古尔穆基文、卡纳达文、马拉雅拉姆文、奥里亚文、泰米尔文、泰卢固文、爪哇文、高棉文、老挝文、缅甸文、僧伽罗文、叙利亚文、塔纳文、泰文、藏文，均可在侧边栏目录中找到。
// * Arabic resources:
- 阿拉伯文资源：
  // - Jonathan Kew's [Notes on some Unicode Arabic characters: recommendations for usage](https://scripts.sil.org/cms/sites/nrsi/download/arabicletterusagenotes/ArabicLetterUsageNotes.pdf)
  - #bibentry(<Kew.NotesUnicode.2005>, verb: [])[向Unicode提交的提案《Notes on some Unicode Arabic characters: recommendations for usage》]
  // - [Character Requirements for a Nastaliq font](https://scriptsource.org/cms/scripts/page.php?item_id=entry_detail&uid=q5mbdr6h3b)
  - 《Character Requirements for a Nastaliq font》@Priestla.CharacterRequirements.2013
// * Indic script resources:
- 印度系#tr[scripts]资源：
  // - The Indian Type Foundry has an [annotated feature file](https://github.com/itfoundry/devanagari-shaping/blob/master/features/core/features.fea) for Devanagari.
  - #bibentry(<IndianTypeFoundry.AnnotatedFeature.2015>)[具有完善注释的天城文字体特性文件]
// * Script databases:
- #tr[scripts]数据库：
  // [Omniglot](https://www.omniglot.com) is an online encyclopedia of scripts and languages.
  - Omniglot @Ager.OmniglotEncyclopedia 是关于语言和#tr[script]的在线百科全书
  // - [ScriptSource](https://scriptsource.org/cms/scripts/page.php) is similar, but includes an annotated version of the Unicode Character Database for each codepoint. See, for example, the page about [LATIN SMALL LETTER EZH](https://scriptsource.org/cms/scripts/page.php?item_id=character_detail_use&key=U000292).
  - ScriptSource @SILInternational.ScriptSourceWriting 也是类似的网站，但它包含一个带有注解的Unicode#tr[character]数据库。例如 `LATIN SMALL LETTER EZH`的页面@SILInternational.ScriptSource.LATINEZH
  // - Eesti Keele Institute [letter database](http://www.eki.ee/letter/) tells you what glyphs you need to support particular languages.
  - #bibentry(<EestiKeeleInstituut.LetterDatabase>, verb: [])[的 letter database 网站]可以查找到每种语言需要支持哪些#tr[glyph]
