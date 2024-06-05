#import "/lib/draw.typ": *
#import "/template/lang.typ": khmer

#let start = (0, 0)
#let end = (900, 580)

#let graph = with-unit((ux, uy) => {
  // mesh((0, 0), (1000, 600), (100, 100), stroke: 1pt + gray)

  shape(
    ((150, 200), (150, 150)),
    ((150, 400), (150, 350)),
    ((250, 500), (200, 500)),
    ((750, 500), (700, 500)),
    ((850, 400), (850, 450)),
    ((850, 200), (850, 250)),
    ((750, 100), (800, 100)),
    ((250, 100), (300, 100)),
    closed: true,
    fill: choose(gray.lighten(20%), gray.darken(20%)),
  )

  point((100, 150), radius: 10)
  arrow((100, 150), (100, 480), stroke: 3*ux + theme.main, head-scale: 5)
  txt(rotate(-90deg, reflow: true)[字宽], (110, 300), anchor: "lc", size: 30 * ux)

  point((500, 70), radius: 10)
  arrow((500, 70), (230, 70), stroke: 3*ux + theme.main, head-scale: 5)
  arrow((500, 70), (770, 70), stroke: 3*ux + theme.main, head-scale: 5)
  txt([字重], (500, 40), anchor: "ct", size: 30*ux)

  let xs = (250, 500, 750)
  let weights = ((300, [细]), (400, [常规]), (700, [粗]))
  let ys = (180, 450)
  let widths = ((100%, ""), (50%, [窄]))

  for (y, (width, width-desc)) in ys.zip(widths) {
    for (x, (weight, weight-desc)) in xs.zip(weights) {

      txt(text(weight: weight, stretch: width)[#khmer[\u{179B}]], (x, y), size: 100 * ux)
      txt(weight-desc + width-desc + [体], (x, y + 60), size: 32 * ux, anchor: "cb")
    }
  }

  txt([设计空间], (500, 330), size: 32 * ux)
})

#canvas(end, start: start, width: 80%, graph)
