#import "/lib/draw.typ": *
#import "/template/theme.typ": theme
#import "mtop.typ": shape-points

#let start = (0, 0)
#let end = (1000, 680)

#let shape-c1 = (
  ((58, 318), (0, 0), (58, 550)),
  ((480, 650), (285, 650)),
  ((930, 320), (930, 628)),
)

#let shape-g2 = (
  ((58, 32), (0, 0), (58, 275)),
  ((480, 350), (285, 350), (565, 350)),
  ((950, 50), (950, 333)),
)

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 100), stroke: 1 * ux + gray)

  let point-color = gray
  let style = (
    line: (
      stroke: 7 * ux + point-color,
    ),
    point: (
      main: (
        circle: (
          radius: 10,
          color: point-color,
        ),
        rect: (
          width: 20,
          color: point-color,
        )
      ),
      ctrl: (
        radius: 7,
        color: point-color,
      )
    ),
    need-rect: false,
  )

  shape-points(style, ..shape-c1)
  shape(..shape-c1, stroke: 8 * ux + theme.main)

  shape-points(style, ..shape-g2)
  shape(..shape-g2, stroke: 8 * ux + theme.main)
})

#canvas(end, start: start, width: 50%, graph)
