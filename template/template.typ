#import "consts.typ"
#import "util.typ"

#import "page.typ": page_setting
#import "font.typ": font-setting
#import "l10n.typ": l10n_setting
#import "heading.typ": heading-setting

#let template(doc) = [
  #show: page_setting
  #show: font-setting
  #show: l10n_setting
  #show: heading-setting

  #doc
]

#let web-page-template(doc) = if util.is-web-target() [
  #set document(
    title: consts.title,
    author: (consts.author, ..consts.translators),
  )

  #show: template
  #doc

  #context {  // show footnotes if have
    if counter(footnote).at(here()).sum() > 0 {
      pagebreak()
    } else {
      v(2em)
    }
  }

  #set text(lang: "en")
  #set par(justify: false)
  #bibliography("/refs.bib", title: none)
] else [
  #doc
]
