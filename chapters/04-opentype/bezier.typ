#import "/template/consts.typ"
#import "/lib/draw.typ": *

#let width = 500
#let height = 800
#let axis-step = 100
#let axis-thickness = 2
#let curve-thickness = 5
#let point-radius = 10
#let point-thickness = 3
#let text-size = 30

#let the-canvas = body => canvas(
  (width, height),
  width: 100%,
  body,
)

#let coordinate-mesh = with-unit((ux, uy) => mesh(
  (0, 0), (width, height), (axis-step, axis-step),
  stroke: axis-thickness * ux + consts.color.table-stroke
))

#let draw-bezier = (..args, color: none) => with-unit((ux, uy) => {
    let ps = args.pos()
    bezier(..ps, stroke: curve-thickness * ux + color)

    for (i, p) in ps.enumerate() {
      if p == none {
        continue
      }
      point(
        p, radius: point-radius, color: color, thickness: point-thickness * ux,
        fill: i == 0 or i + 1 == ps.len(),
        need-txt: true, size: text-size * ux, anchor: "rc", dx: -text-size
      )
    }
})

#let g1 = the-canvas({
  coordinate-mesh

  let s = (290, 627)
  let c1 = (312, 546)
  let c2 = (335, 470)
  let e = (360, 292)

  draw-bezier(s, c1, c2, e, color: blue)
})

#let g2 = the-canvas({
  coordinate-mesh

  let s = (290, 627)
  let c1 = (320, 518)
  let e = (360, 292)

  draw-bezier(s, c1, none, e, color: red)
})

#grid(
  columns: 2,
  column-gutter: 2em,
  fill: none,
  stroke: none,
  inset: 0pt,
  g1, g2,
)
