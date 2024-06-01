#import "/lib/draw.typ": *

#let start = (250, 650)
#let end = (950, 1400)

#let text-size = 32
#let point-radius = 5
#let hightlight-thickness = 5
#let curve-thickness = 10
#let ctrl-curve-color = gray
#let ctrl-point-color = gray.darken(50%)
#let main-curve-color = black
#let arrow-thickness = 5
#let arrow-color = black

#let highlight = (p, stroke, radius-in, radius-out, times: 12) => {
  let (x, y) = p
  for t in range(0, times) {
    let theta = t * 360 / times;
    let start = (
      x + radius-in * calc.sin(theta * 1deg),
      y + radius-in * calc.cos(theta * 1deg),
    )
    let end = (
      x + radius-out * calc.sin(theta * 1deg),
      y + radius-out * calc.cos(theta * 1deg),
    )
    segment(start, end, stroke: stroke)
  }
}

#let graph = with-unit((ux, uy) => {
  let s = (307, 731)
  let c1 = (307, 1010)
  let c2 = (586, 1331)
  let e = (827, 1331)

  let ps = (s, c1, c2, e)

  let ctrl-stroke = curve-thickness * ux + ctrl-curve-color;
  let main-stroke = curve-thickness * ux + main-curve-color;

  for (a, b) in ps.zip(ps.slice(1)) {
    segment(a, b, stroke: ctrl-stroke)
  }

  let ctrl-point = point.with(
    radius: point-radius, color: ctrl-point-color, fill: true,
    need-txt: true, size: text-size * ux,
  )

  ctrl-point(s, anchor: "ct", dy: -20)
  ctrl-point(c1, anchor: "cb", dy: 100)
  ctrl-point(c2, anchor: "cb", dy: 20)
  ctrl-point(e, anchor: "cb", dy: 20)

  let m = c1.zip(c2).map(((a, b)) => (a + b) / 2)
  bezier(s, c1, none, m, stroke: main-stroke)
  bezier(m, c2, none, e, stroke: main-stroke)

  let highlight-stroke = stroke(
    paint: black,
    thickness: hightlight-thickness * ux ,
    cap: "round"
  )
  highlight(m, highlight-stroke, 15, 25, times: 12)

  let arrows = (m.at(0) + 30, m.at(1) - 30)
  let arrowe = (m.at(0) + 120, m.at(1) - 70)
  let arrowc = (arrows.at(0) + 50, arrowe.at(1))
  bezier(arrows, arrowc, none, arrowe, stroke: arrow-thickness * ux + arrow-color)
  arrow-head(arrows, 10, theta: 140deg, point-at-center: true)

  txt([隐含的点], arrowe, size: text-size * ux, anchor: "lc", dx: 10)
  txt([
     #box(baseline: 30%)[$ (#c1.at(0) + #c2.at(0)) / 2 , (#c1.at(1) + #c2.at(1)) / 2 $]  = (#m.at(0), #m.at(1))
  ], arrowe, size: text-size * ux, anchor: "lt", dy: -text-size)
})

#align(center, canvas(
  start: start,
  width: 60%,
  end,
  graph,
))
