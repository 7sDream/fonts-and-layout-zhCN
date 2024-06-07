#import "@preview/book:0.2.5": cross-link as web-cross-link
#import "theme.typ": theme
#import "util.typ"

#let note = body => block(
  breakable: true,
  stroke: (left: 5pt + gray),
  outset: (left: -2.5pt),
  inset: (left: 10pt, rest: 5pt),
  text(fill: theme.note, body)
)

#let hr(above: none, bellow: none, color: theme.main) = [
  #if above != none { v(above) }
  #line(length: 100%, stroke: 0.4pt + color)
  #if bellow != none { v(bellow) }
]

#let cross-ref(target, supplement: auto, web-path: none, web-content: none) = locate( loc => {
  if util.is-web-target() {
    web-cross-link(web-path, web-content, reference: target)
  } else {
    // TODO: remove fallback when all pages are ready
    let elem = query(target, loc)
    if elem.len() > 0 {
      ref(target, supplement: supplement)
    } else {
      text(fill: red)[Unknown label <#str(target)>]
    }
  }
})

#let cross-link(target, content, web-path: none) = locate(loc => {
  if util.is-web-target() {
    web-cross-link(web-path, content, reference: target)
  } else {
    link(target, content)
  }
})

#let title-ref(target, web-path: none, web-content: none) = locate(loc => {
  if util.is-web-target() {
    web-cross-link(web-path, web-content, reference: target)
  } else {
    let heads = query(target, loc);
    if heads.len() == 0 {
      return [Unknown title]
    }
    let head = heads.at(0)
    if head.func() != heading {
      panic("only ref to heading, found " + head.func())
    }
    link(target)[#head.body]
  }
})
