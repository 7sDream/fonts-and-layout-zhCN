#import "/lib/draw.typ": *
#import "/template/lang.typ": bengali

#let start = (0, 0)
#let end = (800, 300)

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 50), stroke: 1 * ux + gray)

  let lb = (0, 60)
  txt([#text(font: ("Noto Sans",))[Hx]#text(font: ("Cinzel",), size: 1.25em)[Hx]], lb, size: 260 * ux, anchor: "lb", dx: -10)

  let widths = (175, 150, 250, 226)
  let common-heights = (228, -60)
  let heightss = (
    (140, 185),
    (140, 185),
    (195,),
    (195,),
  )

  for (width, heights) in widths.zip(heightss) {
    for height in (..heights, ..common-heights) {
      rect(
        lb, width: width, height: -height,
        stroke: 1.5 * ux + black
      )
    }
    lb = (lb.at(0) + width, lb.at(1))
  }
})

#canvas(end, start: start, width: 100%, graph)
