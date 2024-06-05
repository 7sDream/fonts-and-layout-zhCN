#import "/lib/draw.typ": *
#import "/lib/glossary.typ": tr
#import "dim-1.typ": start, end, base, lt, rb, line-color, graph as dim1

#let bbox-calc = (lt, rb, arg) => {
  let (l, t, r, b) = arg
  return ((lt.at(0) + l, lt.at(1) - t),
  (rb.at(0) - r, rb.at(1) + b))
}

#let (bbox-lt, bbox-rb) = bbox-calc(lt, rb, (7, 11, 8, 5))

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (50, 50), stroke: 1 * ux + gray)

  rect(bbox-lt, end: bbox-rb, stroke: 1 * ux + line-color)

  let bbox-ct = (
    (bbox-lt.at(0) + bbox-rb.at(0)) / 2,
    bbox-lt.at(1),
  )
  txt(text(fill: line-color)[#tr[outline]#tr[bounding box]], bbox-ct, anchor: "cb", size: 12 * ux)

  dim1
})

#canvas(end, start: start, width: 55%, graph)
