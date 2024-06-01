#import "/lib/draw.typ": *
#import "/template/lang.typ": arabic, greek

#let start = (0, 0)
#let end = (1000, 100)

#let example = [
  A quote from Wikipedia: "#arabic[تعود أصل الكلمة إلى الإغريقية: #greek[δηνάριον] (ديناريوس).]"
]

#let make-arrow = ux => arrow.with(
  stroke: 2 * ux + gray.darken(30%),
  head-scale: 5,
)

#let positions = (
  20, 380, 710, 845, 990,
)

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 20), stroke: 1 * ux + gray)

  txt(example, (20, 20), size: 30 * ux, anchor: "lb")

  let arrow = make-arrow(ux)
  let ltr = (
    true, false, true, false,
  )

  let level = 0
  for (dir, (from, to)) in ltr.zip(positions.zip(positions.slice(1))) {
    if dir {
      arrow((from + 4, 60), (to - 4, 60))
      txt([从左向右(0级)], (from + 4, 60), size: 20 * ux, anchor: "lb", dy: 10)
    } else {
      arrow((to - 4, 60), (from + 4, 60))
      txt([从右向左(1级)], (to - 4, 60), size: 20 * ux, anchor: "rb", dy: 10)
    }
  }
})

#canvas(end, start: start, width: 100%, graph)
