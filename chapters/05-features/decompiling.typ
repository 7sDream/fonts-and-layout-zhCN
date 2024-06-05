#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## Decompiling a font
== 反编译字体文件

// We talked near the start of the chapter about how we could take our textual feature rules and compile them into a font. What about going the other way? Sometimes it's useful, when examining how other people have solved particular layout problems, to turn a font back into a set of layout instructions. There are a variety of ways we can do this.
我们在本章开头处介绍了如何将文本格式的特性代码编译到字体中。那反过来能行吗？这会很有用，比如有时我们会想通过将字体变回#tr[layout]指令，来了解别人是如何解决某个特定的#tr[layout]问题的。有几种方式可以做到这一点。

// One is a script using the FontTools library we mentioned in the previous chapter to decompile the `GPOS` and `GSUB` tables back into feature language such as Lasse Fisker's [ft2fea](https://github.com/Tarobish/Mirza/blob/gh-pages/Tools/ftSnippets/ft2fea.py). My own script is called `otf2fea`, and can be installed by installing the `fontFeatures` Python library (`pip install fontFeatures`).
其中一种是基于我们上一章提到的 `fontTools` 程序库的脚本，比如Lasse Fisker编写的`ft2fea`@Fisker.MirzaFt2fea。我自己也有一个脚本叫`otf2fea`，它可以通过`fontFeatures`这个Python包进行安装。（`pip install fontFeatures`）

// XXX But while these worked nicely for more complex font files, neither of them worked on our simple test font, so instead, I went with the absolute easiest way - when exporting a file, Glyphs writes out a feature file and passes it to AFDKO to compile the features. Thankfully, it leaves these files sitting around afterwards, and so in `Library/Application Support/Glyphs/Temp/TTXTest-Regular/features.fea`, I find the following:
但是，虽然这些脚本对于很复杂的字体都工作的很好，但它们都无法处理我们这个简单的测试用字体。所以我就换了一个绝对是最简单的方式。当 Glyphs 导出字体文件时，它会先生成一份特性代码文件，然后使用 `AFDKO` 工具编译。而且幸运的是，编译完成后这些文件会被留下，路径是`Library/Application Support/Glyphs/Temp/TTXTest-Regular/features.fea`。下面是它的内容：

```fea
table OS/2 {
  TypoAscender 800;
  TypoDescender -200;
  TypoLineGap 200;
  winAscent 1000;
  winDescent 200;
  WeightClass 400;
  WidthClass 5;
  WidthClass 5;
  FSType 8;
  XHeight 500;
  CapHeight 700;
} OS/2;
# ...
```

// Oh, it turns out that as well as specifying `GPOS` and `GSUB` features, the feature file is also used by font editors to get metrics and other information into the OpenType tables. But let's look down at the bottom of the file:
哦，原来除了往`GPOS`和`GSUB`表里添加特性，这个文件还被字体编辑器用来想字体里添加#tr[metrics]和其他信息。我们继续看这个文件最末尾的部分：

```fea
feature kern {
  lookup kern1_latin {
    lookupflag IgnoreMarks;
    pos A B -50;
  } kern1_latin;
} kern;
```

// And here it is - our `kern` feature. This is precisely equivalent to the horrible piece of XML above.
看，这就是我们的`kern`特性。这和我们之前展示的那一大堆可怕的 XML 完全等价。
