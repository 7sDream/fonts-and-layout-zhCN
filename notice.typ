#import "/template/template.typ": web-page-template
#import "/template/heading.typ": chapter
#import "/template/util.typ"
#import "/template/components.typ": note

#show: web-page-template

#show: doc => if util.is-web-target() { doc }

#chapter[
  在线阅读说明
]

本书使用 #link("https://typst.app/")[Typst] 作为排版系统，借助 #link("https://github.com/Myriad-Dreamin/typst-book")[typst-book] 生成在线阅读版本。

此方案其实是*在您的浏览器中*，使用 WASM 实时运行 Typst 编译器，将源码编译为 SVG 并显示。

这样的好处有：

- 即使没有安装需要的字体也能显示各种文字
- 保证显示和排版效果和 PDF 基本一致
- 所有正确绘制的图示（不包括外部图片）在明亮/黑暗模式下会智能地使用合适的颜色

缺点有：

- 您的浏览器需要支持 WASM
- 在页面加载时可能会使用较高的计算资源
- 由于按页编译的特性，所有交叉引用需要手工指定目标页面，可能会存在错误

如果您在阅读时遇到任何问题，可以#link("https://github.com/7sDream/fonts-and-layout-zhCN/issues/new")[提交 Issue]。

也可以选择#link("https://github.com/7sDream/fonts-and-layout-zhCN/releases/latest")[下载PDF]，离线阅读。
