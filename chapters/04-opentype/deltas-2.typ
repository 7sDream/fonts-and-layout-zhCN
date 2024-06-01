#import "/lib/draw.typ": *
#import "deltas-1.typ": start, end, graph as delta-1, p2, p3, p5, arrow-line-size, arrow-head-scale, main-txt-size

#let arrow-color = yellow

#let ps = (p2, p3, p5)

#let graph = with-unit((ux, uy) => {
  delta-1

  let arrow-relative = (
    (-300, -20),
    (-300, 150),
    (-300, -30),
  )

  for (s, r) in ps.zip(arrow-relative) {
    arrow(s, r, relative: true, stroke: arrow-line-size * ux + arrow-color, head-scale: 1.5)
  }

  let p = p5.zip(arrow-relative.last()).map(((a, b)) => a + b)
  txt([字宽压缩#linebreak()沿此移动], p, anchor: "cb", dy: 30)
})

#canvas(
  end, start: start,
  width: 40%,
  graph,
)
