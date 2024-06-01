#import "/lib/draw.typ": *
#import "/template/lang.typ": bengali

#let start = (0, 0)
#let end = (1000, 690)

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 100), stroke: 1 * ux + gray)
  let char = bengali(
    // TODO: Typst text stroke needs improvment
    // stroke: (
    //   thickness: 10 * ux,
    //   join: "miter",
    //   miter-limit: 4,
    // ),
    // fill: white.transparentize(100%),
  )[ব]
  
  let subgraph = (dx, dy, scale) => {
    txt(char, (dx, dy), size: 400 * ux * scale, anchor: "cb", dy: -5 * scale)
    rect(
      (-115 * scale + dx, 370 * scale + dy), 
      width: 230 * scale,
      height: 490 * scale,
    )
    segment(
      (-115 * scale + dx, 0 + dy),
      (-115 * scale + dx + 230 * scale, 0 + dy),
    )
    arrow(
      (80 * scale + dx, dy - 15 * scale),
      (50 * scale + dx, dy - 15 * scale),
      stroke: 2 * ux + black,
      head-scale: 2 * scale,
    )
    arrow-head(
      (82 * scale + dx, dy - 15 * scale), 4 * scale,
    )
    arrow(
      (-115 * scale + dx + 230 * scale + 20 * scale, 370 * scale + dy - 5),
      (-115 * scale + dx + 230 * scale + 20 * scale, 370 * scale + dy - 490 * scale),
      stroke: 2 * ux + black,
      head-scale: 5,
    )
    arrow-head(
      (-115 * scale + dx + 230 * scale + 20 * scale, 370 * scale + dy), 10, theta: 90deg
    )
  }

  subgraph(150, 175, 1)
  subgraph(650, 175, 1.2)

  txt([2048 个单位 = 10pt], (290, 560), anchor: "cb")
  txt([157 个单位], (250, 140), anchor: "rt")
  txt([0.766pt], (250, 100), anchor: "rt")

  txt([2048 个单位 = 12pt], (800, 640), anchor: "cb")
  txt([157 个单位], (760, 140), anchor: "rt")
  txt([0.920pt], (760, 100), anchor: "rt")
})

#canvas(end, start: start, width: 100%, graph)
