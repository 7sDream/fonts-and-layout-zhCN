#import "consts.typ"

#let note = body => block(
  breakable: true,
  stroke: (left: 5pt + gray),
  outset: (left: -2.5pt),
  inset: (left: 10pt, rest: 5pt),
  text(fill: consts.color.note, body)
)

#let hr(above: none, bellow: none, color: black) = [
  #if above != none { v(above) }
  #line(length: 100%, stroke: 0.4pt + color)
  #if bellow != none { v(bellow) }
]

#let title-ref(target) = locate(loc => {
  let head = query(target, loc).at(0);
  if head.func() != heading {
    panic("only ref to heading, found " + head.func())
  }

  link(target)[#head.body]
})
