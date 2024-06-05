#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## How OpenType shaping works
== 文本#tr[shaping]的工作流程

// While we could now carry on describing the syntax of the feature file language and giving examples of OpenType rules, this would not necessarily help us to transfer our knowledge to new situations - especially when we are dealing with scripts which have more complicated requirements and expectations. To get that transferable knowledge, we need to have a deeper understanding of what we're doing and how it is being processed by the computer.
我们已经知道特性文件中描述OpenType规则的语法了，但只知道这些并不足以让我们高效地利用现有的知识，尤其是在处理具有复杂排版需求的#tr[script]系统时。为了让这些关于文本的知识可以转化为通用的字体设计能力，我们需要深入了解计算机在整个处理过程中到底进行了哪些操作。

// So we will now pause our experiments with substitution rules, and before we get into other kinds of rule, we need to step back to look at how the process of OpenType shaping works. As we know, *shaping* is the application of the rules and features within a font to a piece of text. Let's break it down into stages.
让我们暂停对#tr[substitution]规则的实验，也先不去了解其他类型的规则。暂且后退一步，先来看看OpenType文本#tr[shaping]的整体工作原理。我们已经知道，#tr[shaping]就是将字体中规则和特性应用到一段文本上的过程。这个过程可以分为以下几个阶段。
