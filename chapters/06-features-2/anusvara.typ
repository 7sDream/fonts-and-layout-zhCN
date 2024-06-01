#import "/lib/draw.typ": *
#import "/template/lang.typ": hind

#let start = (0, 0)
#let end = (1000, 500)

#let graph = with-unit((ux, uy) => context {
  let bg = if page.fill == none { white } else { page.fill }
  rect(start, end: end, fill: bg)
  // mesh(start, end, (100, 100), stroke: 1 * ux + gray)

  txt(hind[खंहंकं], (30, 100), anchor: "lb", size: 450 * ux)

  point((792, 452), color: bg, radius: 24)
  point((910, 452), radius: 22)
})

#canvas(end, width: 35%, graph)
