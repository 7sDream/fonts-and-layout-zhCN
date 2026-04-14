#import "/lib/draw.typ": *
#import "deltas-1.typ": (
  arrow-head-scale, arrow-line-size, end, graph as delta-1, main-txt-size, p2,
  p3, p5, start,
)

#let arrow-color = yellow

#let ps = (p2, p3, p5)

#let graph = {
  delta-1

  with-unit((ux, uy) => {
    let arrow-relative = (
      (-300, -20),
      (-300, 150),
      (-300, -30),
    )

    for (s, r) in ps.zip(arrow-relative) {
      arrow(
        s,
        r,
        relative: true,
        stroke: arrow-line-size * ux + arrow-color,
        head-scale: 1.5,
      )
    }

    let p = p5.zip(arrow-relative.last()).map(((a, b)) => a + b)
    txt([字宽压缩#linebreak()沿此移动], p, anchor: "cb", dy: 30)
  })
}

#canvas(
  end,
  start: start,
  width: 40%,
  graph,
)
