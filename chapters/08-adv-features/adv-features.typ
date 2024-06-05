#import "/template/template.typ": web-page-template
#import "/template/heading.typ": chapter
#import "/template/components.typ": note, cross-ref

#import "/lib/glossary.typ": tr

#show: web-page-template

#chapter(meta: (
  footnote: [译注：作者尚未开始编写本章，原文亦只有小节标题。#cross-ref(<heading:not-finish-point>, web-path: "/chapters/09-layout/other-dir.typ", web-content: [第9.2节])及之后也是此情况，不注。]
))[
  // Advanced Feature Programming
  高级特性编程
]
