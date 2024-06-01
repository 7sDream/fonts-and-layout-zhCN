#import "/lib/draw.typ": *
#import "/lib/glossary.typ": tr
#import "/template/lang.typ": devanagari

#let start = (0, 0)
#let end = (1000, 260)

#let (basex, basey) = (120, 70)
#let width = 740

#let example = devanagari[टाइपोग् #h(-0.25em)राफी]

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 100), stroke: 1 * ux + gray)

  let lines = (
    ([变音符号线], "rb", end.at(0), basex, basey + 153),
    ([#tr[headline]], "lb", 0, basex + width, basey + 100),
    ([#tr[baseline]], "lb", 0, basex + width, basey),
    ([半音符号线], "rb", end.at(0), basex, basey - 50),
  )

  for (body, anchor, xs, xe, y) in lines {
    segment((xs, y), (xe, y), stroke: 2 * ux + gray.darken(30%))
    txt(body, (xs, y), anchor: anchor, size: 25 * ux, dy: 4)
  }

  txt(example, (basex, basey), anchor: "lb", size: 170 * ux)
})

#canvas(end, start: start, width: 90%, graph)
