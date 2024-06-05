#import "/lib/draw.typ": *
#import "/lib/glossary.typ": tr

#let start = (0, 0)
#let end = (1000, 660)

#let table-border-color = rgb("5595c2")
#let table-gray-color = rgb("e4e5e9")
#let arrow-color = rgb("309843")
#let feature-color = rgb("2e7cac")
#let lookup1-color = rgb("2d9641")
#let lookup2-color = rgb("c4b455")

#let no-hlines-pen = (pen, rows) => (x, y) => if y == 0 {
  (bottom: none, rest: pen)
} else if y + 1 == rows {
  (top: none, rest: pen)
} else {
  (top: none, bottom: none, rest: pen)
}

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 100), stroke: 1 * ux + gray)

  let glyph-stream = "official".codepoints()
  let columns = glyph-stream.len()
  let pen = 2 * ux + table-border-color

  txt(
    block(width: 955 * ux, table(
      columns: (1fr,) * columns,
      align: horizon + center,
      inset: 0pt,
      fill: (x, y) => if y > 0 { table-gray-color } else { white },
      stroke: no-hlines-pen(pen, 2),
      ..glyph-stream.map(it => block(height: 50*ux, spacing: 0pt, text(fill: black, size: 32*ux, it))),
      block(height: 50*ux, spacing: 0pt),
    )),
    (30, 652),
    anchor: "lt",
  )

  arrow((210, 682-243), (210, 682-135), stroke: 30*ux + arrow-color, head-scale: 1.4)

  rect((100, 682-255), end: (900, -50), radius: 50, fill: feature-color, shadow: (:))

  txt(text(fill: white)[特性], (150, 400), anchor: "lt", size: 42*ux)

  rect((175, 682-328), end: (760, 682-520), radius: 20, fill: lookup1-color, shadow: (:))

  txt(text(fill: white)[#tr[lookup]1], (190, 682-345), anchor: "lt", size: 42*ux)

  txt(text(fill: white)[
    - 规则：`sub f f i by f_f_i`
    - 规则：`sub f f by f_f`
    - 规则：`sub f l by f_l`
  ], (190, 682-410), anchor: "lt", size: 24*ux)

  rect((175, 682-530), end: (760, 682-665), radius: 20, fill: lookup2-color, shadow: (:))

  txt(text(fill: white)[#tr[lookup]2], (190, 682-542), anchor: "lt", size: 42*ux)

  txt(text(fill: white)[
    - 规则
  ], (190, 682-610), anchor: "lt", size: 24*ux)
})

#canvas(
  end,
  start: start,
  width: 100%,
  clip: true,
  graph,
)
