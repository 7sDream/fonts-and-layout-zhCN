#import "/lib/draw.typ": *
#import "/lib/glossary.typ": tr

#let start = (0, 0)
#let end = (800, 500)

#let base = (40, 100)
#let widths = (0, 270, 728)
#let ys = (365, 300, 210, 0, -80)

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 100), stroke: 1 * ux + gray)

  let (bx, by) = base
  let line-stroke = (
    paint: gray.darken(30%),
    thickness: 3 * ux,
  )
  for y in ys {
    segment(
      (bx, by + y),
      (bx + widths.last(), by + y),
      stroke: line-stroke,
    )
  }
  for x in widths {
    segment(
      (bx + x, by + ys.first()),
      (bx + x, by + ys.last()),
      stroke: line-stroke,
    )
  }

  let half = (widths.at(1) + widths.at(2)) / 2
  segment(
    (bx + half, end.at(1)),
    (bx + half, start.at(1)),
    stroke: (..line-stroke, dash: "dashed"),
  )

  txt(text(cjk-latin-spacing: none)[H東], base, anchor: "lb", size: 420 * ux, dx: -20)
})

#canvas(end, start: start, width: 65%, graph)
