#import "/template/template.typ": web-page-template
#import "/template/heading.typ": chapter
#import "/template/components.typ": note
#import "/template/lang.typ": tibetan, khmer

#import "/lib/glossary.typ": tr

#show: web-page-template

#chapter[
  // How OpenType Works
  OpenType的工作原理
]

// They say that if you enjoy sausages, you shouldn't look too carefully into how they are made, and the same is true of OpenType fonts.
俗话说，如果你喜欢吃香肠，那就别关心它是怎么制作的。对于OpenType字体来说也一样。

// In this chapter we're going to look in some depth about the OpenType font format: how it actually converts the outlines, metrics and advanced typographic features of a font into a file that a computer can interpret. In an ideal world, this would be information that programmers of layout systems and font handling libraries would need, but implementation details that font designers could safely ignore.
在本章中，我们会深入OpenType字体的内部格式，了解它是如何将字体的#tr[outline]信息、#tr[metrics]信息和其他各种#tr[typography]相关的特性封装成一个计算机可读的文件的。在理想的世界中，只有开发电子排版系统或字体加载库的程序员们需要了解这方面的信息，字体设计师完全不需要懂这些。

// But we are not in an ideal world, and as we will see when we start discussing the metrics tables, the implementation details matter for font designers too - different operating systems, browsers and applications will potentially interpret the information contained within a font file in different ways leading to different layout.
但我们这个世界并不理想，所以你经常能听到字体设计师也在讨论#tr[metrics]之类的实现层面的细节。不同的操作系统、浏览器、应用程序会用不同的方式来理解和使用字体文件中的信息，也会产生不同的显示效果。

// So put on your overalls, grab your bucket, and let's take a look inside the font sausage factory.
现在穿上工作服，拿上装备，我们就要亲自深入香肠工厂好好看看了。
