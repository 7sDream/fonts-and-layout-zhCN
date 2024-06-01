#import "/lib/draw.typ": *
#import "/lib/glossary.typ": tr
#import "dim-2.typ": start, end, lt, rb, bbox-lt, bbox-rb, line-color, graph as dim2

#let end = (end.at(0), end.at(1))

#let sidebearing-y = bbox-lt.at(1) - 30
#let l-start = (lt.at(0), sidebearing-y)
#let l-end = (bbox-lt.at(0), sidebearing-y)
#let l-center = ((l-start.at(0) + l-end.at(0)) / 2, sidebearing-y)
#let r-start = (bbox-rb.at(0), sidebearing-y)
#let r-end = (rb.at(0), sidebearing-y)
#let r-center = ((r-start.at(0) + r-end.at(0)) / 2, sidebearing-y)

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (50, 50), stroke: 1 * ux + gray)

  let sidebearning-stroke = 1.4 * ux + line-color
  segment(l-start, l-end, stroke: sidebearning-stroke)
  segment(r-start,r-end, stroke: sidebearning-stroke)

  let l-arrow-start = (l-center.at(0) - 40, l-center.at(1) + 10)
  bezier(
    l-arrow-start,
    (l-center.at(0) - 20, l-center.at(1) + 18),
    (l-center.at(0) - 1, l-center.at(1) + 15),
    l-center,
    stroke: sidebearning-stroke,
  )
  arrow-head(l-center, 4, theta: -80deg)
  txt([左#tr[sidebearing]], l-arrow-start, anchor: "rc", size: 12 * ux)

  let r-arrow-start = (r-center.at(0) + 40, r-center.at(1) + 10)
  bezier(
    r-arrow-start,
    (r-center.at(0) + 20, r-center.at(1) + 18),
    (r-center.at(0) + 1, r-center.at(1) + 15),
    r-center,
    stroke: sidebearning-stroke,
  )
  arrow-head(r-center, 4, theta: -110deg)
  txt([右#tr[sidebearing]], r-arrow-start, anchor: "lc", size: 12 * ux)

  dim2
})

#canvas(end, start: start, width: 55%, graph)
