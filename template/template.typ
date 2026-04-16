#import "consts.typ"
#import "util.typ"
#import "@preview/shiroa:0.3.1": paged-load-trampoline, templates

#import "page.typ": page-setting
#import "font.typ": font-setting
#import "l10n.typ": l10n-setting
#import "heading.typ": heading-setting

#let template(doc) = [
  #show: page-setting
  #show: font-setting
  #show: l10n-setting
  #show: heading-setting

  #doc
]

#let web-page-template(title: none, description: none, doc) = if util.is-pdf-target() {
  doc
} else [
  #set document(
    title: consts.title,
    author: (consts.author, ..consts.translators),
  )

  #show: templates.template-rules.with(
    book-meta: include "/book.typ",
    title: if title == none { "NO TITLE" } else { title },
    description: if description == none { "" } else { description },
    plain-body: doc,
  )

  #show: template

  #doc

  #context {
    // show footnotes if have
    if counter(footnote).at(here()).sum() > 0 {
      pagebreak()
    } else {
      v(2em)
    }
  }

  #set text(lang: "en")
  #set par(justify: false)
  #bibliography("/refs.bib", title: none)
]
