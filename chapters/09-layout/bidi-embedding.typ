#import "/lib/draw.typ": *
#import "/template/lang.typ": arabic, greek
#import "bidi-unembedded.typ": example, make-arrow

#let start = (0, 0)
#let end = (1000, 160)

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 20), stroke: 1 * ux + gray)

  txt(example, (20, 20), size: 30 * ux, anchor: "lb")

  let arrow = make-arrow(ux)
  arrow((20, 120), (990, 120))
  arrow((970, 90), (380, 90))
  arrow((710, 60), (840, 60))

  txt([从左向右（0级）], (20, 120), size: 20 * ux, anchor: "lb", dy: 2)
  txt([从右向左（1级）], (970, 90), size: 20 * ux, anchor: "rb", dy: 2)
  txt([从左向右（2级）], (710, 60), size: 20 * ux, anchor: "lb", dy: 2)
})

#canvas(end, start: start, width: 100%, graph)
