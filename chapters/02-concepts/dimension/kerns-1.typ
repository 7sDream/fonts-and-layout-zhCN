#import "/lib/draw.typ": *
#import "/lib/glossary.typ": tr
#import "/template/lang.typ": armenian

#let start = (0, 0)
#let end = (1300, 930)
#let base = (430, 340)
#let up = 540
#let down = 195
#let width = 426
#let line-color = gray.darken(30%)
#let lt = (base.at(0), base.at(1) + up)
#let rb = (base.at(0) + width, base.at(1) - down)
#let lt2 = (rb.at(0), lt.at(1))
#let rb2 = (rb.at(0) + width, rb.at(1))
#let bbox-arg = (80, 78, 30, down)
#let bbox-calc = (lt, rb, arg) => {
  let (l, t, r, b) = arg
  return ((lt.at(0) + l, lt.at(1) - t),
  (rb.at(0) - r, rb.at(1) + b))
}
#let (bbox1-lt, bbox1-rb) = bbox-calc(lt, rb, bbox-arg)
#let (bbox2-lt, bbox2-rb) = bbox-calc(lt2, rb2, bbox-arg)

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 100), stroke: 1 * ux + gray)

  rect(
    lt, end: rb,
    stroke: 6 * ux + red,
  )
  rect(
    lt2, end: rb2,
    stroke: 6 * ux + green,
  )

  let line-stroke = 4 * ux + line-color
  segment(
    (0, base.at(1)), (end.at(0), base.at(1)),
    stroke: line-stroke,
  )
  txt([#tr[baseline]], (0, base.at(1)), size: 48 * ux, anchor: "lb", dy: 8)

  rect(bbox1-lt, end: bbox1-rb, stroke: line-stroke)
  rect(bbox2-lt, end: bbox2-rb, stroke: line-stroke)

  txt(armenian[ՐՐ], base, size: 635 * ux, anchor: "lb", dx: 15)

  let arrow-y = base.at(1) - down - 60
  let arrow-length = 70
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
  txt(tr[horizontal advance], (base.at(0) + width / 2, arrow-y), size: 48 * ux)
})

#canvas(end, start: start, width: 50%, graph)

