#import "consts.typ"
#import "util.typ"

#let __metadata-head(..data) = metadata((
  kind: "head",
) + data.named())

#let __get-metadata-head(it) = {
  assert.eq(it.func(), heading)

  let next_heading = util.query-first(heading, it.location(), none)
  let end = if next_heading != none {
    next_heading.location()
  } else {
    none
  }
  return util.query-first(metadata, it.location(), end, kind: "head")
}

#let __get-head-footnote(meta) = {
  let body = if meta != none {
    meta.at("footnote", default: none)
  }
  if body != none {
    footnote(body)
  }
}

#let __heading(
  show-number: true,
  number-function: none,
  is_center: false,
  clean_footnote_counter: false,
  text_size: 1em,
  above: none,
  bellow: none,
  it,
) = [
  #set text(size: text_size, weight: "regular")

  #let head = __get-metadata-head(it)
  #let foot = __get-head-footnote(head)

  #if clean_footnote_counter {
    counter(footnote).update(0)
  }

  #let body = it.body
  #if show-number and it.numbering != none {
    let num = numbering(it.numbering, ..counter(heading).at(it.location()))
    if number-function != none {
      num = number-function(num, it)
    }
    body = num + h(0.6em) + body
  }
  #let body = strong[#body] + foot
  #if is_center {
    body = align(center, body)
  }

  #if above != none [
    #v(consts.size.par-spacing + above, weak: true)
  ]

  #body

  #if bellow != none [
    #v(consts.size.par-spacing + bellow, weak: true)
  ]
]

#let heading-setting(doc) = [
  #set heading(numbering: "1.1.1.1") if util.is-pdf-target()

  #show heading.where(level: 1): __heading.with(
    number-function: (num, it) => [第#num#it.supplement],
    is_center: true,
    clean_footnote_counter: true,
    text_size: consts.size.Huge,
    above: consts.size.chapter-spacing,
    bellow: consts.size.chapter-spacing,
  )

  #show heading.where(level: 2): __heading.with(
    text_size: consts.size.LARGE,
    above: consts.size.section-above,
  )

  #show heading.where(level: 3): __heading.with(
    text_size: consts.size.Large,
    above: consts.size.subsection-above,
  )

  #show heading.where(level: 4): __heading.with(
    text_size: consts.size.large,
    above: consts.size.subsubsection-above,
  )

  #doc
]

#let chapter(body, ..args) = [
  #if util.is-pdf-target() { pagebreak(weak: true) }
  #heading(level: 1, supplement: [章], ..args.named().at("heading", default: (:)), body)
  #if "label" in args.named() {
    args.named().at("label")
  }
  #__metadata-head(..args.named().at("meta", default: (:)))
]

#let section(body, ..args) = [
  #heading(level: 2, ..args.named().at("heading", default: (:)), body)
  #if "label" in args.named() {
    args.named().at("label")
  }
  #__metadata-head(..args.named().at("meta", default: (:)))
]

#let subsection(body, ..args) = [
  #heading(level: 3, ..args.named().at("heading", default: (:)), body)
  #if "label" in args.named() {
    args.named().at("label")
  }
  #__metadata-head(..args.named().at("meta", default: (:)))
]

#let subsubsection(body, ..args) = [
  #heading(level: 4, ..args.named().at("heading", default: (:)), body)
  #if "label" in args.named() {
    args.named().at("label")
  }
  #__metadata-head(..args.named().at("meta", default: (:)))
]
