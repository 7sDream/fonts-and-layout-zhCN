#import "/template/consts.typ"
#import "/template/template.typ": template

#set document(
  title: consts.title,
  author: (consts.author, ..consts.translators),
)

#show: template

#include "cover.typ"
#include "outline.typ"
#include "chapters/index.typ"

#pagebreak(weak: true)

#[
  #set par(justify: false)
  #bibliography("refs.bib")
]
