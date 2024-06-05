#import "/lib/draw.typ": *
#import "/lib/glossary.typ": tr
#import "/template/lang.typ": armenian

#let start = (0, 0)
#let end = (300, 200)
#let base = (125, 75)
#let up = 125
#let down = 45
#let width = 136
#let line-color = gray.darken(30%)
#let lt = (base.at(0), base.at(1) + up)
#let rb = (base.at(0) + width, base.at(1) - down)

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
  point(base, radius: 3.5)
  txt([#tr[baseline]], (0, base.at(1)), size: 12 * ux, anchor: "lb", dy: 2)

  let arrow-y = base.at(1) - down - 15
  let arrow-length = 40
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

  txt(armenian[խ], base, size: 150 * ux, anchor: "lb", dx: 2)
})

#canvas(end, start: start, width: 55%, graph)
