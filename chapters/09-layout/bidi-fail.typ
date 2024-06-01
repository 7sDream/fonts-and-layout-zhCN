#import "/lib/draw.typ": *
#import "/template/lang.typ": arabic

#let start = (0, 100)
#let end = (1000, 600)

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 100))

  let lbPoint = place(left + bottom, dx: -15 * ux, dy: 15 * ux, circle(radius: 15 * ux, fill: black))
  let box-stroke-thickness = 8 * ux
  let box-stroke = box-stroke-thickness + gray

  let eng = body => [
    #set text(size: 260 * ux, top-edge: 220 * ux)
    #lbPoint #body
  ]

  let eng-text = "textin".codepoints()

  txt(grid(
    columns: eng-text.len(),
    stroke: 8 * ux + gray,
    column-gutter: (0pt, 0pt, 0pt, 80 * ux, 0pt),
    .."textin".codepoints().map(eng),
  ), (50, 300), anchor: "lb")

  let arrows = (start, widths, fill: black) => {
    let position = start
    for width in widths {
      let new-pos = (position.at(0) + width, position.at(1))
      arrow(position, new-pos, stroke: 10 * ux + fill,head-scale: 1.5)
      position = new-pos
    }
  }

  let str-to-widths = s => s.map(it => measure(eng(it)).width / ux)

  arrows((50, 200), str-to-widths(eng-text.slice(0, 4)))
  arrows((600, 200), str-to-widths(eng-text.slice(4)))

  let arabic-text = "العر"
  let arabic-color = rgb(82, 148, 114).darken(10%).transparentize(10%)
  let arabic-right = (960, 535)
  txt(arabic(fill: arabic-color, size: 355 * ux, top-edge: "bounds")[#arabic-text], arabic-right, anchor: "rt", dx: 10)

  let arabic-box-color = rgb(94, 166, 133)
  let arabic-box-stroke = box-stroke-thickness + arabic-box-color

  let widths = (70, 85, 142, 160)
  let heights = (235, 235, 235, 315)
  let position = arabic-right
  for (width, height) in widths.zip(heights) {
    rect(position, width: -width, height: height, stroke: arabic-box-stroke)
    position = (position.at(0) - width, position.at(1))
  }

  arrows((arabic-right.at(0), 150), widths.map(it => -it), fill: green.darken(50%))
})

#canvas(end, start: start, width: 100%, graph)
