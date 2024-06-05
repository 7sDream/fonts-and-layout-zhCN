#import "/lib/draw.typ": *
#import "/lib/glossary.typ": tr

#let start = (0, 0)
#let end = (250, 220)
#let base = (100, 70)
#let up = 150
#let down = 35
#let width = 74
#let lt = (base.at(0), base.at(1) + up)
#let rb = (base.at(0) + width, base.at(1) - down)

#let bbox-lt = (93, 178)
#let bbox-width = 74
#let bbox-height = 111
#let bbox-ct = (bbox-lt.at(0) + bbox-width / 2, bbox-lt.at(1))

#let line-color = gray.darken(30%)

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (50, 50), stroke: 1 * ux + gray)

  rect(
    lt, end: rb,
    stroke: 1.4 * ux + line-color,
  )
  let line-stroke = 1 * ux + line-color
  segment(
    (0, base.at(1)), (end.at(0), base.at(1)),
    stroke: line-stroke,
  )

  let arrow-y = base.at(1) - down - 20
  let arrow-length = 12
  arrow(
    (base.at(0) + width - arrow-length, arrow-y),
    (base.at(0) + width, arrow-y),
    stroke: line-stroke,
    head-scale: 3,
  )
  arrow(
    (base.at(0) + arrow-length, arrow-y),
    (base.at(0), arrow-y),
    stroke: line-stroke,
    head-scale: 3,
  )
  txt(tr[horizontal advance], (base.at(0) + width / 2, arrow-y), size: 12 * ux)

  txt([#tr[baseline]], (0, base.at(1)), size: 12 * ux, anchor: "lb", dy: 2)

  rect(
    bbox-lt, width: bbox-width, height: bbox-height,
    stroke: 1.2 * ux + line-color,
  )
  txt(text(fill: line-color)[#tr[outline]#tr[bounding box]], bbox-ct, size: 12 * ux, anchor: "cb", dy: 2)

  txt(text(font: ("Fresca",))[b], base, size: 150 * ux, anchor: "lb", dx: -5, dy: -2)
})

#canvas(end, start: start, width: 50%, graph)
