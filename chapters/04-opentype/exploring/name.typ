#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ### The `name` table
=== `name` 表

// Any textual data stored within a font goes in the `name` table; not just the name of the font itself, but the version, copyright, creator and many other strings are found inside a font. For our purposes, one of the loveliest things about OpenType is that these strings are localisable, in that they can be specified in multiple languages; your bold font can appear as Bold, Gras, Fett, or Grassetto depending on the user's language preference.
字体中所有文本型的信息都储存在`name`表里，不只是字体名，还包括版本号、版权信息、创作者等。OpenType 中很棒的一点是这些文本都可以被本地化，也就是一个信息可以有多个语言的版本。比如粗体可以根据用户的语言偏好而被显示为 Bold、Gras或Fett。

// Unfortunately, as with the rest of OpenType, the ugliest thing is that it is a compromise between multiple font platform vendors, and all of them need to be supported in different ways. Multiple platforms times multiple languages means a proliferation of entries for the same field. So, for instance, there may be a number of entries for the font's designer: one entry for when the font is used on the Mac (platform ID 1, in OpenType speak) and one for when it is used on Windows (platform ID 3).
但很不幸，OpenType 的老毛病在这里也依旧存在。因为要同时支持多个字体供应商的古老标准，这些文本信息也需要为这些字体平台重复多次。多平台X多语言，这就意味着每一个字段都会膨胀为一堆条目。比如，字体设计者这个字段，就分别在Mac上使用的条目（按照OpenType标准的说法叫做平台ID为1），和另一个在Windows上使用的条目（平台ID为3）。

#note[
  // > There's also a platform ID 0, for the "Unicode platform", and platform ID 2, for ISO 10646. Yes, these platforms are technically identical, but politically distinct. But don't worry; nobody ever uses those anyway.
  其实也有代表Unicode的平台 0和代表ISO 10646的平台2。这两个平台在技术上是同一个，但在政治原则上是不同的。别担心，对应这两个平台的条目都没人使用。
]

// There may be further entries *for each platform* if the creator's name should appear differently in different scripts: a Middle Eastern type designer may wish their name to appear in Arabic when the font is used in an Arabic environment, or in Latin script otherwise.
如果某个字段需要在不同的#tr[scripts]环境下显示为不同的值，那么每个平台下可能还会细分更多的条目。比如一个中东的字体设计师，可能希望字体创建者名称在阿拉伯文环境下显示为阿拉伯文，但在其他环境下显示为对应的拉丁字母转写。

// Name entry records on the Mac platform are usually entered in the Latin script. While it's *in theory* possible to create string entries in other scripts, nobody really seems to do this. For the Windows platform (`platformID=3`), if you're using a script other than Latin for a name record, encode your strings in UTF-16BE, choose the appropriate [language ID](https://www.microsoft.com/typography/otspec180/name.htm) from the OpenType specification, and you should be OK.
