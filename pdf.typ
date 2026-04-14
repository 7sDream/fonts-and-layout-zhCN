#import "@preview/shiroa:0.3.1": book-meta-state, external-book, visit-summary
#import "/template/template.typ": template
#import "/template/consts.typ"
#import "/template/util.typ"

#set document(
  title: consts.title,
  author: (consts.author, ..consts.translators),
)

#if not util.is-pdf-target() {
  panic("You should use typst to build this file, not shiroa cli")
}

#show: template

#include "cover.typ"

#external-book(spec: include "book.typ")

#include "outline.typ"

#context {
  let mt = book-meta-state.final()
  for item in mt.summary {
    let file = item.at("link")
    if file == "notice.typ" or file == "cover.typ" {
      continue
    }
    visit-summary(item, (
      inc: it => include it,
      part: heading,
      chapter: it => it,
    ))
  }
}

#pagebreak(weak: true)
#set text(lang: "en")
#set par(justify: false)
#bibliography("/refs.bib", title: [参考文献])
