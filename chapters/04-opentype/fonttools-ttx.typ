#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## FontTools and ttx
== FontTools 和 `ttx` 工具

// To crack open that OTF file and look at the tables inside, we're going to use a set of Python programs called `fonttools`. `fonttools` was originally written by Just van Rossum, but is now maintained by Cosimo Lupo and a cast of hundreds. If you don't have `fonttools` already installed, you can get hold of it by issuing the following commands at a command prompt:
为了能拆开 OTF 文件并且直接看看这些数据表，我们需要一套被称为`fontTools`的Python程序。`fontTools`最初由Just van Rossum编写，现在则由 Cosimo Lupo 和数百位贡献者一起维护。如果你还未安装 `fontTools`，可以使用如下命令来安装它：

#note[
  // > If you're a Mac user and you're not familiar with using a terminal emulator, pick up a copy of *Learning Unix for OS X* by Dave Taylor. If you're a Windows user, I'm afraid you're on your own; Windows has never made it particularly easy to operate the computer through the command prompt, and it's too painful to explain it here. If you're on Linux, you already know what you're doing.
  如果你是Mac用户，且不熟悉终端和命令行操作，可以看看Dave Taylor写的《Learn Unix for OS X》一书。如果你是Windows用户，你可能需要自行研究了。Windows的命令行功能不太易用，使用它进行系统交互会比较痛苦，我在这就不过多解释了。如果你是Linux用户的话，我相信你已经很熟悉下面的操作了。
]

```bash
easy_install pip
pip install fonttools
```

// If you have the Homebrew package manager installed, which is highly recommended for developing on Mac computers, you can get `fonttools` through Homebrew:
如果你安装了在Mac上做开发工作时推荐使用的Homebrew包管理器的话，也可以用它来获取 `fontTools`：

```bash
brew install fonttools
```

#note[
  // > Homebrew is a system which allows you to easily install and manage a number of useful free software packages on Mac OS X. You can get it from http://brew.sh/
  Homebrew 是 Mac OS X 系统上的一个用于轻松安装和管理自由软件包的工具。你可以在其官网获取它：#link("http://brew.sh/")。
]

// The core of the `fonttools` package is a library, some code which helps Python programmers to write programs for manipulating font files. But `fonttools` includes a number of programs already written using the library, and one of these is called `ttx`.
`fontTools`的核心是一个帮助Python开发者编写字体处理功能的程序库。但它同时也包含了几个用这个库编写而成的可以直接使用的程序。`ttx` 工具就是其中之一。

// As we mentioned above, an OpenType font file is a database. The database, with its various tables, is stored in a file using a format called SFNT, which stands for "spline font" or "scalable font". OpenType, TrueType, PostScript and a few other font types all use the SFNT representation to lay out their tables into a binary file. But because the SFNT representation is *binary* - that is to say, not human readable - it's not very easy for us either to investigate what's going on in the font or to make changes to it. The `ttx` utility helps us with that. It is used to turn an SFNT database into a textual representation, XML, and back again. The XML format is still designed primarily to be read by computers rather than humans, but it at least allows us to peek inside the contents of an OpenType font which would otherwise be totally opaque to us.
上面已经介绍过，OpenType字体文件其实是一个包含多个数据表的数据库。这些数据表使用 SFNT 格式储存在文件中。SFNT代表#tr[spline]字体（spline font）或可缩放字体（scalable font）。OpenType、TrueType、PostScript等字体格式都会使用SFNT来储存数据表。但SFNT是一种人类无法直接阅读的二进制格式，想了解字体内部的构造或者修改它就比较困难。`ttx`工具就是来帮我们处理这个难题的。它可以将SFNT数据库转换为XML格式的文本形式，同时支持反向转换。XML其实也是一种偏向于给计算机看的格式，但至少比之前那种人类完全不可理解要好的多了。借助它，我们可以略微窥探一下OpenType字体中的实际内容。
