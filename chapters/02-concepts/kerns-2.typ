#import "/lib/draw.typ": *
#import "/lib/glossary.typ": tr
#import "/template/lang.typ": armenian
#import "kerns-1.typ": start, end, base, lt, rb, bbox1-lt, bbox1-rb, bbox-calc, line-color, down

#let lt2 = (rb.at(0) - 40, lt.at(1))
#let rb2 = (rb.at(0) + 330, rb.at(1))
#let (bbox2-lt, bbox2-rb) = bbox-calc(lt2, rb2, (30, 48, 20, down))

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 100), stroke: 1 * ux + gray)

  rect(
    lt, end: rb,
    stroke: 6 * ux + red,
  )
  rect(
    lt2, end: rb2,
    stroke: stroke(
      paint: green,
      thickness: 6 * ux,
      dash: (10 * ux, 2 * ux),
    ),
  )

  let line-stroke = 4 * ux + line-color
  segment(
    (0, base.at(1)), (end.at(0), base.at(1)),
    stroke: line-stroke,
  )
  txt([#tr[baseline]], (0, base.at(1)), size: 48 * ux, anchor: "lb", dy: 8)

  rect(bbox1-lt, end: bbox1-rb, stroke: line-stroke)
  rect(bbox2-lt, end: bbox2-rb, stroke: (
    paint: line-color,
    thickness: line-stroke.thickness,
    dash: (10 * ux, 2 * ux),
  ))

  txt(armenian[Ր], base, size: 635 * ux, anchor: "lb", dx: 15)
  txt(armenian[ձ], (lt2.at(0), base.at(1)), size: 635 * ux, anchor: "lb", dx: 0)

  let arrow-y = rb.at(1) - 20
  arrow((rb.at(0), arrow-y), (lt2.at(0), arrow-y), head-scale: 3, stroke: line-stroke)
  txt([
    #tr[kern] -140 单位
  ], ((rb.at(0) + lt2.at(0)) / 2, arrow-y),
    anchor: "ct", dy: -25, size: 48 * ux,
  )
}) 

#canvas(end, start: start, width: 50%, graph)
