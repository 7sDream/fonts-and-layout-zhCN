#import "/lib/draw.typ": *
#import "/template/lang.typ": takri

#let start = (0, 0)
#let end = (500, 420)
#let example = "\u{1168A}\u{116AE}\u{116AB}"

#let correct = with-unit((ux, uy) => {
  // mesh(start, end, (100, 100))
  txt([#takri[#example]], (0, 80), size: 400 * ux, anchor: "lb")
})

#let broken = with-unit((ux, uy) => context {
  correct
  let fill-color = if page.fill == none { white } else { page.fill }

  point((258, 391.5), radius: 25.8, color: fill-color)

  let x = 310
  point((x, 391.5), radius: 25.4, color: black)
  // segment((x, end.at(1)), (x, start.at(1)))
})

#grid(
  columns: (1fr, 1fr),
  inset: 0pt,
  column-gutter: 10%,
  [#canvas(end, width: 100%, broken)],
  [#canvas(end, width: 100%, correct)],
)
