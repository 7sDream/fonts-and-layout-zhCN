#import "/lib/draw.typ": *
#import "/lib/glossary.typ": tr
#import "/template/lang.typ": mongolian

#let start = (0, 0)
#let end = (500, 540)

#let example = rotate(90deg, mongolian[ᠪᠰ‍])

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 100), stroke: 1 * ux + gray)

  rect(
    (20, 500), end: (390, 285),
    stroke: 2 * ux + theme.main,
  )
  rect(
    (20, 285), end: (390, 100),
    stroke: 2 * ux + theme.main,
  )

  segment(
    (215, 530), (215, 35)
  )

  txt(tr[baseline], (215, 10), anchor: "cb", size: 20 * ux)

  arrow(
    (410, 495), (410, 285), stroke: 2 * ux + theme.main, head-scale: 3,
  )
  arrow-head((410, 500), 6, theta: 90deg)
  txt(block(width: 1em)[#par(leading: 0.25em)[#tr[vertical advance]]], (425, 400), anchor: "lc")

  txt(example, (195, 430), anchor: "ct", size: 360 * ux)
})

#canvas(end, start: start, width: 50%, graph)
