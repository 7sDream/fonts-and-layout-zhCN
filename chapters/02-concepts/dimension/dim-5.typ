#import "/lib/draw.typ": *
#import "/lib/glossary.typ": tr

#let start = (0, 0)
#let end = (300, 170)
#let base = (128, 45)
#let up = 123
#let down = 45
#let width = 85
#let line-color = gray.darken(30%)
#let lt = (base.at(0), base.at(1) + up)
#let rb = (base.at(0) + width, base.at(1) - down)

#let bbox-calc = (lt, rb, arg) => {
  let (l, t, r, b) = arg
  return ((lt.at(0) + l, lt.at(1) - t),
  (rb.at(0) - r, rb.at(1) + b))
}

#let (bbox-lt, bbox-rb) = bbox-calc(lt, rb, (9, 37, 8, 61))
#let bbox-ct = (
  (bbox-lt.at(0) + bbox-rb.at(0)) / 2,
  bbox-lt.at(1),
)

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (50, 50), stroke: 1 * ux + gray)

  rect(
    lt, end: rb,
    stroke: 1.4 * ux + line-color,
  )
  rect(
    bbox-lt, end: bbox-rb,
    stroke: 1 * ux + line-color,
  )
  txt(text(fill: line-color)[#tr[bounding box]], bbox-lt, anchor: "lb", size: 12 * ux, dy: 4)

  let line-stroke = 1 * ux + line-color
  segment(
    (0, base.at(1)), (end.at(0), base.at(1)),
    stroke: line-stroke,
  )
  txt([#tr[baseline]], (0, base.at(1)), size: 12 * ux, anchor: "lb", dy: 2)

  txt([x+], base, size: 145 * ux, anchor: "lb", dx: -75)
})

#canvas(end, start: start, width: 50%, graph)
