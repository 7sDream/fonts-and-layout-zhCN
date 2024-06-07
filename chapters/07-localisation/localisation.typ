#import "/template/template.typ": web-page-template
#import "/template/heading.typ": chapter
#import "/template/components.typ": note, title-ref
#import "/template/lang.typ": arabic, arabic-amiri, balinese, devanagari, hind, sharada, taitham, telugu

#import "/lib/glossary.typ": tr

#show: web-page-template

#chapter[
  // OpenType for Global Scripts
  服务#tr[global scripts]的OpenType
]

// In the last chapter, we looked at OpenType features from the perspective of technology: what cool things can we make the font do? In this chapter, however, we're going to look from the perspective of language: how do we make the font support the kind of language features we need? We'll be putting together the substitution and positioning lookups from OpenType Layout that we learnt about in the previous chapter, and using them to create fonts which behave correctly and beautifully for the needs of different scripts and language systems.
上一章中，我们在分析各种OpenType特性时采用的是技术视角，也就是利用它们能做到哪些事。本章我们则会站在各种语言的角度，来看看它如何完成特定语言中的具体需求。通过结合之前学习的#tr[substitution]和#tr[positioning]#tr[lookup]，我们要为不同的语言#tr[script]系统创建既正确又漂亮的字体。
