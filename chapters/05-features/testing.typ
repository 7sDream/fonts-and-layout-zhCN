#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## Building a testing environment
== 构造测试环境

// XXX
// 增加内容，当前原文缺

// ### Using hb-shape for feature testing
=== 使用 hb-shape 进行特性测试

// Now is a good time to introduce the `hb-shape` tool; it's a very handy utility for debugging and testing the application of OpenType features - how they affect the glyph stream, their effect on positioning, how they apply in different language and script combinations, and how they interact with each other. Learning to use `hb-shape`, which comes as part of the [HarfBuzz](http://harfbuzz.org) OpenType shaping engine, will help you with a host of OpenType-related problems.
现在是介绍 `hb-shape` 工具的好时机。这是一个非常实用的OpenType特性调试和测试工具。通过它你能看到特性如何改变#tr[glyph]流，影响#tr[glyph]的位置，在不同的语言#tr[script]环境下的不同效果，以及如何互相影响等。`hb-shape` 工具是OpenType#tr[shaping]引擎HarfBuzz @Unknown.HarfBuzz 中的一部分，它在你遇到有关OpenType的各种问题时都能帮助你。

#note[
  // > If you're on Mac OS X, you can install the Harfbuzz utilities using homebrew, by calling `brew install harfbuzz` on the terminal.
  如果你使用 Mac OS X，你可以通过 Homebrew 安装 HarfBuzz，只需在终端中执行：#linebreak()`brew install harfbuzz`。
]

// As we've mentioned, HarfBuzz is a shaping engine, typically used by layout applications. Shaping, as we know, is the process of taking a text, a font, and some parameters and producing a set of glyphs and their positions. `hb-shape` is a diagnostic tool which runs the shaping process for us and formats the output of the process in a number of different ways. We can use it to check the kern that we added in the previous section:
HarfBuzz是#tr[shaping]引擎，常被需要进行文本#tr[layout]的应用使用。而#tr[shaping]的过程是输入文本、字体和一些其他参数，得到一系列#tr[glyph]和它们的位置的过程。`hb-shape`是一个会执行这一过程，然后将结果用不同的格式输出的诊断工具。我们可以用它来检查之前为测试字体添加的#tr[kern]：

```bash
$ hb-shape TTXTest-Regular.otf 'AA'
[A=0+580|A=1+580]
```

// This tells us that we have two "A" glyphs together. The first one is the first character in the input stream ("=0" - computer strings count from zero), and that it has a horizontal advance of 580 units ("+580"). The second one is the second character in the input stream ("=1") and also has an advance of 580 units.
这告诉我们，输出是两个`A`#tr[glyph]。其中第一个`A`来自输入文本中的第一个（输出中的`=0`表示第一个，因为计算机就是从0开始数数的）#tr[character]，它拥有580单位的#tr[horizontal advance]。第二个`A`是输入文本中的第二个（`=1`）#tr[character]，也是580单位的#tr[horizontal advance]。

// But...
但是……

```bash
$ hb-shape TTXTest-Regular.otf 'AB'
[A=0+530|B=1+618]
```

// when we have an "A" and a "B", the advance width of the "A" is only 530 units. In other words, the "B" is positioned 50 units left of where it would normally be placed; the "A" has, effectively, got 50 units narrower. In other other words, our kern worked.
当我们输入`AB`时，`A`的#tr[horizontal advance]变成了530。换句话说，也就是`B`会相对其常规位置向左移动50单位。也可以看作`A`变窄了50单位。我们的#tr[kern]成功生效了。

// We didn't need to tell HarfBuzz to do any kerning - the `kern` feature is on by default. We can explicitly turn it off by passing the `--features` option to `hb-shape`. `-<feature name>` turns off a feature and `+<feature name>` turns it on:
我们不用明确告诉HarfBuzz启用#tr[kern]功能，因为`kern`特性默认就是开启的。我们可以通过向 `--features` 选项来让`hb-shape` 开关某种特性。使用 #text(ligatures: false)[`-<特姓名>`] 可以关闭一个特性，`+<特姓名>` 则可以开启。

```bash
$ hb-shape --features="-kern" TTXTest-Regular.otf 'AB'
[A=0+580|B=1+618]
```

// As you see in this case, the advance width of the "A" is back to 580 units, because the `ab` kern pair is not being applied in this case.
当关闭`kern`特性后，因为AB间的#tr[kern]不再生效，`A`#tr[glyph]的#tr[advance]就又回到了580单位。

#note[
  // > We will see more of `hb-shape` in the next chapter, including examples of how it shows us positioning information.
  下一章我们会更多地使用`hb-shape`，也会有一些用它来显示其他#tr[positioning]信息的例子。
]
