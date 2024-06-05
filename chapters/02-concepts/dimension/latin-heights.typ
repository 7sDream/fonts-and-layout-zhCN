#import "/lib/draw.typ": *
#import "/lib/glossary.typ": tr
#import "/template/theme.typ": theme
#import "/template/lang.typ": armenian

#let start = (0, 0)
#let end = (1000, 400)
#let basex = 200
#let basey = 120
#let base = (basex, basey)
#let ascender = 242
#let cap = 228
#let xheight = 172
#let decender = -80
#let width = 780

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 100), stroke: 1 * ux + gray)

  let line-left = basex - 30
  for y-offset in (ascender, cap, xheight, 0, decender) {
    let y = basey + y-offset
    segment(
      (if y-offset != 0 { line-left } else { basex }, y),
      (base.at(0) + width, y),
      stroke: 2 * ux + theme.main,
    )
  }
  rect(
    (basex, basey + ascender),
    width: width,
    height: ascender - decender,
  )

  txt([#tr[ascender]：1556], (line-left, basey + ascender), anchor: "rb", size: 20 * ux,dx: -10, dy: -2)
  txt([#tr[cap height]：1462], (line-left, basey + cap), anchor: "rc", size: 20 * ux,dx: -10)
  txt([#tr[x-height]：1096], (line-left, basey + xheight), anchor: "rc", size: 20 * ux,dx: -10)
  txt([#tr[decender]：-492], (line-left, basey + decender), anchor: "rb", size: 20 * ux,dx: -10)

  txt([Hxgh], base, anchor: "lb", size: 320 * ux)
})

#canvas(end, start: start, width: 100%, graph)
