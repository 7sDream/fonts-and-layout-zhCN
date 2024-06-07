#import "/template/theme.typ": theme
#import "/lib/draw.typ": *

#let start = (0, 0)
#let end = (1000, 600)

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 100))

  let p1 = (22, 166)
  let p2 = (148, 576)
  let p3 = (977, 274)
  let p4 = (742, 16)

  let main-point = point.with(radius: 18, thickness: 4 * ux)
  main-point(p1)
  main-point(p4)
  main-point(p2, fill: false)
  main-point(p3, fill: false)

  let line-stroke = stroke(
    paint: theme.main,
    thickness: 4 * ux,
    cap: "round",
  )
  bezier(p1, p2, p3, p4, stroke: line-stroke)
  segment(p1, p2, stroke: line-stroke)
  segment(p4, p3, stroke: line-stroke)

  let f = t => {
    let ((p1x, p1y), (p2x, p2y), (p3x, p3y), (p4x, p4y)) = (p1, p2, p3, p4)
    let qt = 1 - t
    let a1 = qt * qt * qt
    let a2 = 3 * qt * qt * t
    let a3 = 3 * qt * t * t
    let a4 = t * t * t
    (
      a1 * p1x + a2 * p2x + a3 * p3x + a4 * p4x,
      a1 * p1y + a2 * p2y + a3 * p3y + a4 * p4y,
    )
  }

  let (inp1, inp2, inp3) = range(1, 4).map(a => f(a / 4))
  
  let points = (p1, inp1, inp2, inp3, p4)
  for (i, (from, to)) in points.zip(points.slice(1)).enumerate() {
    if i != 0 {
      point(from, radius: 18, thickness: 4 * ux, dash: "dashed", fill: false)
    }
    segment(from, to,stroke: stroke(
      paint: theme.main,
      thickness: 3 * ux,
      dash: "dotted",
    ))
  }
})

#canvas(end, start: start, width: 100%, graph)
