#import "@preview/book:0.2.5": _convert-summary
#import "/template/template.typ": template
#import "/template/consts.typ"
#import "/template/util.typ"

#set document(
  title: consts.title,
  author: (consts.author, ..consts.translators),
)

#if not util.is-pdf-target() {
  panic("To compile this file, you need provide `realpdf=1` input argument")
}

#import "book.typ": summary

#show: template

#include "cover.typ"
#include "outline.typ"

#let flatten-chapter(chapter) = {
  let result = if chapter.section == none { () } else { (chapter.link,) }
  let children = chapter.at("sub", default: none)
  if children == none { return result }
  for section in children {
    if section.kind == "chapter" {
      result = (..result, ..flatten-chapter(section))
    }
  }
  return result
}

#let flatten-summary = summary => {
  summary.map(chapter => if chapter.kind == "chapter" {
      flatten-chapter(chapter)
  } else { () }).flatten()
}

#{
  for file in flatten-summary(_convert-summary(summary)) {
    include file
  }
}

#pagebreak(weak: true)
#set text(lang: "en")
#set par(justify: false)
#bibliography("/refs.bib", title: [参考文献])
