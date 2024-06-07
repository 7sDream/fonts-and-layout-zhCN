#import "/lib/draw.typ": *
#import "/lib/glossary.typ": tr

#let start = (0, 0)
#let end = (1600, 1000)

#let big-card-width = 850
#let big-card-height = 700
#let big-card-radius = 50
#let big-card-fill = theme.bg
#let big-card-stroke-size = 5
#let big-card-stroke-color = gray
#let big-card-start-point = (400, 900)
#let big-card-offset = (50, -30)
#let big-card-count = 3
#let arrow-left = 200
#let arrow-right = 1400
#let arrow-y = {
  let (_, sy) = big-card-start-point
  sy - big-card-height / 2
}

#let big-card = (start) => with-unit((ux, uy) => rect(
  start,
  width: big-card-width,
  height: big-card-height,
  radius: big-card-radius,
  fill: big-card-fill,
  stroke: big-card-stroke-size * ux + big-card-stroke-color,
  shadow: (dx: 8, dy: -8, fill: big-card-stroke-color, darken: 50%),
))

#let big-cards = {
  for times in range(big-card-count - 1, -1, step: -1) {
    let p = big-card-start-point.zip(big-card-offset.map(x => x * times)).map(((a, b)) => a + b)
    if times == 0 {
      arrow((arrow-left, arrow-y), (arrow-right, arrow-y), head-scale: 5)
    }
    big-card(p)
  }
}

#let feature-card-width = 350
#let feature-card-height = 220
#let feature-card-radius = 30
#let feature-card-stroke-size = 3
#let feature-card-stroke-color = theme.main

#let feature-card = (start, color: none) => with-unit((ux, uy) => rect(
  start,
  width: feature-card-width,
  height: feature-card-height,
  radius: feature-card-radius,
  fill: color,
  stroke: feature-card-stroke-size * ux + feature-card-stroke-color,
))

#let feature-cards = with-unit((ux, uy) => {
  let (bx, by) = big-card-start-point
  let card-start = (bx + 50, by - 100)
  let card-offset = (400, -300)
  let title-text-size = 42
  let title-text-y-offset = -30
  let small-text-size = 24
  let small-text-x-offset = -80
  let small-text-y-offset = -70
  let last-text-color = rgb("bdbcbc")
  let data = (
    bg-color: (rgb("b3b2b2"), rgb("c7c6c6"), rgb("ededed"), white),
    title: (
      [ccmp feature],
      [scmp feature],
      [kern feature],
      [swsh feature],
    ),
    rules: [
      #set par(leading: 10 * ux)
      lookup 1#linebreak()
      #h(1em)rule 1#linebreak()
      lookup 2#linebreak()
      #h(1em)rule 1#linebreak()
      #h(1em)rule 2
    ],
    desc: (
      [（必要，永远启用）],
      [（用户明确要求启用）],
      [（除非用户明确关闭，否则启用）],
      [（用户未启用）],
    )
  )

  for row in range(0, 2) {
    for col in range(0, 2) {
      let offset = card-offset.zip((col, row)).map(((v, t)) => v * t)

      // card
      let (ltx, lty) = card-start.zip(offset).map(((a, b)) => a + b)
      let index = 2 * row + col
      feature-card((ltx, lty), color: data.bg-color.at(index))

      // title
      let (cx, cy) = (ltx + feature-card-width / 2, lty)
      let text-color = if index == 3 { last-text-color } else { black }
      txt(text(fill: text-color, data.title.at(index)), (cx, cy), anchor: "cc", dy: title-text-y-offset, size: title-text-size * ux)

      // rules
      txt(text(fill: text-color, data.rules), (cx, cy), anchor: "lt", dx: small-text-x-offset, dy: small-text-y-offset, size: small-text-size * ux)

      // description
      let (cbx, cby) = (cx, cy - feature-card-height)
      txt(data.desc.at(index), (cbx, cby), anchor: "ct", size: small-text-size * ux, dy: -small-text-size * 0.7)
      
      // x cross for last card
      if index == 3 {
        let offset = feature-card-radius * (1 - calc.sqrt(2) / 2)
        let (rbx, rby) = (ltx + feature-card-width, lty - feature-card-height)
        segment(
          (ltx + offset, lty - offset),
          (rbx - offset, rby + offset),
          stroke: 1 * ux + black,
        )
        segment(
          (rbx - offset, lty - offset),
          (ltx + offset, rby + offset),
          stroke: 1 * ux + black,
        )
      }
    }
  }
})

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 100))

  big-cards
  feature-cards

  let (ltx, lty) = big-card-start-point
  let (rtx, rty) = (ltx + big-card-width, lty)

  txt([_DFLT_], (ltx + 50, lty - 50), anchor: "lc", size: 42 * ux)
  txt([_#tr[scripts]代码_], (ltx + 50, lty + 60), anchor: "cb")
  arrow((ltx + 50, lty + 50), (ltx + 50 + 50, lty - 50 + 20), head-scale: 5)

  txt([_dflt_], (rtx - 50, lty - 50), anchor: "rc", size: 42 * ux)
  txt([_语言代码_], (rtx - 50 - 300, rty + 60), anchor: "rb")
  bezier((rtx - 50 - 300, rty + 60 + 20), (rtx - 50 - 100, rty + 60 + 20), none, (rtx - 50 - 60, lty - 30))
  arrow-head((rtx - 50 - 60, lty - 30), 1pt/ux * 5, theta: -60deg)

  txt([_为其他语言#tr[script]#linebreak()设计的特性集_], (580, 50), anchor: "lc", size: 42 * ux)
  bezier((580, 50), (530, 50), none, (520, 130))
  arrow-head((520, 130), 1pt/ux * 5, theta: 90deg, point-at-center: true)

  txt([Abcd], (arrow-left, arrow-y), anchor: "rc", dx: -20, size: 72 * ux)
  txt(text(features: ("smcp",))[Abcd], (arrow-right, arrow-y), anchor: "lc", dx: 20, size: 72 * ux)
  txt(image("smcp-icon.jpg", width: 100 * ux), (arrow-left + 50, arrow-y), anchor: "lc")
})

#canvas(end, start: start, width: 100%, graph)
