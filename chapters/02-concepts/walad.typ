#import "/lib/draw.typ": *
#import "/lib/glossary.typ": tr
#import "/template/lang.typ": arabic

#let start = (0, 0)
#let end = (1000, 950)

#let black-text = arabic(fill: black)[وَلَد]
#let gray-text = arabic(fill: gray)[ولد]

#let (bx, by) = (30, 200)
#let base = (bx, by)

#let boxes = (
  (
    box: (370, 350),
  ),
  (
    box: (200, 570),
    movement: (-110, 600),
    dashbox: (150, 90),
  ),
  (
    box: (340, 300),
    movement: (-145, 450),
    dashbox: (150, 90),
  ),
)

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 100), stroke: 1 * ux + gray)

  txt(black-text, base, anchor: "lb", size: 810 * ux, dy: 20)
  txt(gray-text, (bx, by), anchor: "lb", size: 810 * ux, dy: 20)

  let line-stroke = (
    thickness: 4 * ux,
    paint: gray.darken(30%),
  )
  let pos = base
  for arg in boxes {
    let (width, height) = arg.box
    rect(pos, width: width, height: -height, stroke: line-stroke)
    point(pos, radius: 12)
    let next-pos = (pos.at(0) + width, pos.at(1))
    arrow(
      (pos.at(0), pos.at(1) - 40),
      (next-pos.at(0), next-pos.at(1) - 40),
      stroke: (..line-stroke, paint: black),
      head-scale: 4,
    )
    pos = next-pos
    if "movement" in arg {
      let (ox, oy) = arg.movement
      let endpos = (pos.at(0) + ox, pos.at(1) + oy)
      arrow(
        pos, endpos,
        stroke: (..line-stroke, paint: black, dash: "dashed"), 
        head-scale: 5
      )
      if "dashbox" in arg {
        let (width, height) = arg.dashbox
        let lb = (endpos.at(0) - width / 2, endpos.at(1))
        rect(
          lb, width: width, height: -height,
          stroke: (..line-stroke, dash: "dashed")
        )
      }
    }
  }
  point(pos, radius: 12)
})

#canvas(end, start: start, width: 60%, graph)
