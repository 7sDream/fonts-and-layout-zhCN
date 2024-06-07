#import "/template/template.typ": web-page-template
#import "/template/components.typ": note
#import "/template/lang.typ": russian

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## Scripts and languages
== 语言和#tr[script]

// Lookups apply to particular combinations of *language* and *script*. You can, for example, substitute generic glyph forms for localised forms which are more appropriate in certain linguistic contexts: for example, the Serbian form of the letter be (б) is expected to look different from the Russian form. Both forms can be stored in the same font, and the choice of appropriate glyph made on the basis of the language of the text.
#tr[lookup]会应用于特定的*语言#tr[script]*二元组。比如你可以在某些语言环境下，将一些#tr[glyph]从通用样式替换为当地样式。具体来说，以字母 be（#russian[б]）为例，它在塞尔维亚语中和在俄语中的样式就略有不同。这两种样式可以同时储存在字体中，然后根据文本的语言来选择使用合适的那一个。<position:serbian-letter-be>

// Again, so far we've handled this implicitly - any rules which are not tagged explicitly with the language and script combination that they refer to are considered to apply to the "default" script and "default" language. The script and language are described using four-character codes called "tags"; for example, the script tag for Malayalam is `mlm2`. You can find the list of [script tags](https://docs.microsoft.com/en-gb/typography/opentype/spec/scripttags) and [language tags](https://docs.microsoft.com/en-gb/typography/opentype/spec/languagetags) in the OpenType specification. The shaper is told, by the layout application, what language and script are being used by the input run of text. (It may also try guessing the script based on the Unicode characters in use.)
但之前我们也忽略了这个功能，使用了默认的处理方式。也就是没有被显式标记属于哪个语言#tr[script]二元组的规则统一都被视为属于“默认”语言和“默认”#tr[scripts]。这个二元组中的语言和#tr[scripts]都使用四个#tr[character]的代码表示，它们被称为“标签”。比如，马拉雅拉姆文的标签是“mlm2”。你可以在OpenType规范中的语言标签列表#[@Microsoft.OpenTypeLanguage]和#tr[scripts]标签列表#[@Microsoft.OpenTypeScript]中找到所有的可用标签。排版程序会告诉#tr[shaper]当前的输入文本属于哪种语言和#tr[script]。（它也可能会尝试根据文本包含的Unicode#tr[character]来进行猜测。）

// Inside the font, the GSUB and GPOS tables are arranged *first* by script, *then* by language, and finally by feature. But that's a confusing way for font designers to work, so AFDKO syntax allows you to do things the other way around: define your features and write script- and language-specific code inside them.
在字体内部，`GSUB`和`GPOS`表首先被按照#tr[scripts]分组，然后再按照语言分，最后才是各个特性。但这样的组织结构对于字体设计师来说比较难处理，所以 AFDKO 的语法允许使用另一种方式。我们可以在特性内部定义专门适用于某种#tr[script]和语言的代码块。

// To make this work, however, you have to define your "language systems" at the start of the feature file. For example, here is a font which will have support for Arabic and Urdu, as well as Turkish and "default" (non-language-specific) handling of the Latin script, non-language-specific handling of Arabic *script* (for instance, if the font is used for documents written in Persian; "Arabic" in this case includes Persian letters), and it will also have some rules that apply generally:
但为了使用这个功能，你需要在特性文件的开头定义你自己的“语言系统”。以下是一个在语言上支持阿拉伯语、乌尔都语、土耳其语以及“默认”语（未指定语言），在#tr[scripts]上支持拉丁文，未指定语言的阿拉伯文（阿拉伯文也被用于书写其他多种语言，比如波斯语，在这种情况下阿拉伯文也包括波斯字母），另外还包含一些通用规则的字体代码：

```fea
# languagesystem <文字标签> <语言标签>;
languagesystem DFLT dflt;
languagesystem arab dflt;
languagesystem arab ARA;
languagesystem arab URD;
languagesystem latn dflt;
languagesystem latn TRK;
```

// Once we have declared what systems we're going to work with, we can specify that particular lookups apply to particular language systems. So for instance, the Urdu digits four, five and seven have a different form to the Arabic digits. If our font is to support both Arabic and Urdu, we should make sure to substitute the expected forms of the digits when the input text is in Urdu.
一旦定义好了我们计划支持的语言#tr[script]系统，就可以为每个#tr[lookup]指明它适用于其中哪一个了。比如，乌尔都语中的数字四、五、七和阿拉伯数字不同。如果字体希望同时支持它们，就需要在输入文本是乌尔都语时进行适当的#tr[substitution]来显示符合预期的数字#tr[glyph]样式。

// We'll do this using a `locl` (localisation) feature, which only applies in the case of Urdu:
我们使用一个只在乌尔都语条件下激活的 `locl`（localisation，本地化）特性来实现这个功能：

```fea
feature locl {
    script arab;
    language URD;
    # 直到下一个 script/language 语句为止，所有查询组都只会在
    # 环境为使用阿拉伯文书写的乌尔都语时被应用
    lookup urdu_digits {
      sub four-ar by four-ar.urd;
      sub five-ar by five-ar.urd;
      sub seven-ar by seven-ar.urd;
    } urdu_digits;
} locl;
```

// As mentioned above, any lookups which appear *before* the first `script` keyword in a setting are considered to apply to all scripts and languages. If you want to specify that they should *not* appear for a particular language environment, you need to use the declaration `exclude_dflt` like so:
之前提到过，任何出现在第一个`script`/*language怎么说？*/关键字之前的#tr[lookup]都会被视为在所有#tr[scripts]和语言时都可用。如果你希望它们在某些语言环境下*不要*被使用，则可以使用 `exclude_dflt`：

```fea
feature liga {
    script latn;
    lookup fi_ligature {
      sub f i by fi; # 所有基于拉丁文的语言都激活此连字
      } fi_ligature;

    language TRK exclude_dflt; # 但土耳其语除外
} locl;
```

// You may also see `include_dflt` in other people's feature files. The default rules are included by, uh, default, so this doesn't actually do anything, but making that explicit can be useful documentation to help you figure out what rules are being applied. And speaking of what rules are being applied...
你可能会在其他的特性文件中看到 `include_dflt`。它实际上不起任何作用，但将它明确写出来可以作为一种辅助信息，帮助其他人理解这里到底应用了哪些规则。既然提到了“到底应用了哪些规则”这一话题……
