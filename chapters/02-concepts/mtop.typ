#import "/lib/draw.typ": *

#let start = (0, 0)
#let end = (1000, 300)

#let main-point = (p, style: none, cornel: false) => {
  if not style.need-rect or not cornel {
    point(p, radius: style.point.main.circle.radius, color: style.point.main.circle.color)
  } else {
    let (px, py) = p
    let half = style.point.main.rect.width / 2
    rect(
      (px - half, py + half), width: style.point.main.rect.width, height: style.point.main.rect.width,
      fill: style.point.main.rect.color,
    )
  }
}

#let ctrl-point = (m, p, style: none) => {
  point(p, radius: style.point.ctrl.radius, color: style.point.ctrl.color)
  segment(m, p, stroke: style.line.stroke)
}

#let shape-points = (style, ..args) => {
  let main-point = main-point.with(style: style)
  let ctrl-point = ctrl-point.with(style: style)
  let vertices = args.pos()
  let count = vertices.len()
  for (i, points) in vertices.enumerate() {
    if type(points.at(0)) == array {
      if points.len() == 1 {
        main-point(points.first(), cornel: true)
      } else if points.len() >= 2 {
        let main = points.first()
        let from = points.at(1)
        let to = if points.len() >= 3 {
          points.at(2)
        } else {
          main.zip(from).map(((m, f)) => 2 * m - f)
        }
        main-point(main, cornel: i != 0 and i != count - 1 and points.len() == 3)
        if i > 0 {
          ctrl-point(main, from)
        }
        if i < count - 1 {
          ctrl-point(main, to)
        }
      }
    } else {
      main-point(points, cornel: true)
    }
  }
}

#let shape-vertices = (
  ((47, 72), (0, 0), (134, 161)),
  ((353, 235), (243, 235)),
  ((617, 68), (565, 210), (700, 160)),
  ((958, 235), (858, 235)),
)

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 100), stroke: 1 * ux + gray)

  let point-color = gray.darken(30%)
  let style = (
    line: (
      stroke: 5 * ux + point-color,
    ),
    point: (
      main: (
        circle: (
          radius: 8,
          color: point-color,
        ),
        rect: (
          width: 16,
          color: point-color,
        )
      ),
      ctrl: (
        radius: 5,
        color: point-color,
      )
    ),
    need-rect: true,
  )

  shape-points(style, ..shape-vertices)
  shape(..shape-vertices, stroke: 6 * ux + black)
})

#canvas(end, start: start, width: 100%, graph)
