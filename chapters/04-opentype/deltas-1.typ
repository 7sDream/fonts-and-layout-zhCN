#import "/lib/draw.typ": *

#let start = (0, 100)
#let end = (1000, 1000)

#let rect-point-size = 80
#let rect-point-color = green.darken(20%)
#let line-color = green.darken(20%)
#let line-size = 30
#let arrow-color = red.darken(15%)
#let arrow-line-size = 15
#let arrow-head-scale = 1.5
#let main-txt-size = 64
#let small-txt-size = 32
#let marker-point-size = 10

#let p1 = (150, 900)
#let p2 = (600, 900)
#let p3 = (600, 650)
#let p4 = (150, 650)
#let p5 = (500, 200)
#let ps = (p1, p2, p3, p4, p5)

#let graph = with-unit((ux, uy) => {
  let rect-point = it => segment(
    (it.at(0) - rect-point-size / 2, it.at(1)),
    (it.at(0) + rect-point-size / 2, it.at(1)),
    stroke: rect-point-size * ux + rect-point-color,
  )

  for p in ps {
    rect-point(p)
  }

  for (s, e) in ps.zip(ps.slice(1)) {
    segment(s, e, stroke: line-size * ux + line-color)
  }

  let arrow-relative = (
    (-60, 10),
    (100, 10),
    (150, -200),
    (300, -200),
    (180, 15),
  )

  for (s, r) in ps.zip(arrow-relative) {
    arrow(s, r, relative: true, stroke: arrow-line-size * ux + arrow-color, head-scale: arrow-head-scale)
  }

  let ptxt = p2.zip(arrow-relative.at(1)).map(((a, b)) => a + b)
  txt([粗体请#linebreak()沿此移动], ptxt, anchor: "lc", size: main-txt-size * ux,)

  let half = p3.zip(arrow-relative.at(2)).map(((a, b)) => a + b * 0.5)
  point(half, radius: marker-point-size)
  txt([50%粗体], half, anchor: "lc", size: small-txt-size * ux, dx: 30)

  let full = p3.zip(arrow-relative.at(2)).map(((a, b)) => a + b)
  point(full, radius: marker-point-size)
  txt([100%粗体], full, anchor: "lc", size: small-txt-size * ux, dx: 30)
})

#canvas(
  end, start: start,
  width: 40%,
  graph,
)
