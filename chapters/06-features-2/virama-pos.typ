#import "/lib/draw.typ": *
#import "/template/lang.typ": hind

#let start = (0, 0)
#let end = (1000, 1000)

#let _diamond = (point, offset, fill, ..args) => {
  let (x, y) = point
  shape(
    (x, y - offset),
    (x + offset, y),
    (x, y + offset),
    (x - offset, y),
    fill: fill,
    ..args.named(),
  )
}

#let diamond = (point, size, border: 0, border-fill: theme.bg, ..args) => {
  let args = args.named()
  let arg-fill = args.at("fill", default: theme.main)
  let _ = args.remove("fill")
  let offset = size * calc.sqrt(2) / 2
  if border != 0 {
    _diamond(point, offset + border, border-fill, ..args)
  }
  _diamond(point, offset, arg-fill)
}

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 100), stroke: 1 * ux + gray)

  let pen = 5 * ux + theme.main;

  txt(hind[#text[छ्]], (120, 900), anchor: "lt", size: 1000 * ux)

  segment((130, 900), (741, 900), stroke: pen)
  arrow-head((120, 900), 30, theta: 180deg)
  arrow-head((751, 900), 30)
  txt([631 个单位], (435.5, 890), size: 42 * ux, anchor: "cb", dy: 20)

  rect((120, 865), width: 631, height: 620, stroke: pen)
  diamond((382, 282), 30, fill: gray, border: 6, closed: true)
  txt(text(fill: white)[`(276,57)`], (382, 282), size: 25 * ux, anchor: "cb", dy: 35)

  shape(
    (595, 180),
    (680, 180),
    (815, 15),
    (718, 15),
    closed: true,
    fill: gray,
    stroke: stroke(
      paint: theme.main,
      thickness: pen.thickness,
      dash: "dashed",
    )
  )

  segment((751, 860), (751, 45))
  diamond((574, 243), 30, fill: gray, border: 6)
  txt([`(-172,0)`], (574, 240), size: 25 * ux, anchor: "cb", dy: 30)

  arrow((751, 255), (382, 255), head-scale: 3)
  arrow((382, 215), (574, 215), head-scale: 3)

  txt([631 - 276 = 355], (750, 255), size: 35 * ux, anchor: "lc", dx: 20)
  txt([355 + -172 = 183], (750, 208), size: 35 * ux, anchor: "lc", dx: 20)
})

#canvas(end, width: 50%, graph)
