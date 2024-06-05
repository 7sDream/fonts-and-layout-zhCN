#import "/lib/draw.typ": *

#let start = (100, -20)
#let end = (800, 700)

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 100), stroke: 1 * ux + gray)
  
  let txt = txt.with(size: 15 * ux)
  let highlight-stroke = stroke(
    paint: green.darken(20%),
    thickness: 2 * ux,
    dash: (23*ux, 8*ux, 6*ux, 8*ux)
  )
  let component = (body, highlight: false) => block(
    inset: 10 * ux,
    spacing: 0pt,
    radius: 15 * ux,
    stroke: if highlight { highlight-stroke } else { 1 * ux + theme.main },
    align(center, body),
  )

  let make-data = (x, y, anchor, body, highlight: false, from: none, to: none) => {
    let (fx, fy) = if from == none { (0, 0) } else { from }
    let (tx, ty) = if to == none { (0, 0) } else { to }
    return (
      point: (x, y),
      anchor: anchor,
      body: body,
      highlight: highlight,
      from: (x + fx, y + fy),
      to: (x + tx, y + ty),
    )
  }

  let data = (
    make-data(325, 650, "rc", [
      *可选的基本字符前方部件*

      Reph*或*直接叠加的辅音
    ]),
    make-data(500, 640, "lc", [
      *基本字符*

      基本*或*“其他基本”字符；

      可以附带一个变体选择器
    ], from: (0, -20)),
    make-data(330, 590, "rt", [
      *辅音修饰组*

      任意个基本字符上方修饰符；

      任意个基本字符下方修饰符；
    ], to: (0, -20), from: (0, -50)),
    make-data(440, 510, "lc", [
      *任意个半音组*

      半音符和基本字符，可以附带一个变体选择器#linebreak()
      *或*一个附加辅音；

      可以附带一个*辅音修饰组*
    ], highlight: true),
    make-data(500, 350, "lc", [
      *词中辅音组*

      任意个基本字符前方词中辅音；

      任意个基本字符上方词中辅音；

      任意个基本字符下方词中辅音；

      任意个基本字符后方词中辅音；
    ]),
    make-data(330, 290, "rc", [
      *元音组*

      任意个基本字符前方元音；

      任意个基本字符上方元音；

      任意个基本字符下方元音；

      任意个基本字符后方元音；
    ], to: (0, 20), from: (0, -25)),
    make-data(500, 250, "lt", [
      *元音修饰组*

      任意个基本字符前方元音修饰符；

      任意个基本字符上方元音修饰符；

      任意个基本字符下方元音修饰符；

      任意个基本字符后方元音修饰符；
    ], to: (0, -20), from: (0, -100)),
    make-data(350, 140, "rt", [
      *结尾辅音组*

      任意个基本字符上方结尾辅音；

      任意个基本字符下方结尾辅音；

      任意个基本字符后方结尾辅音；

      可以附带一个结尾修饰符
    ], to: (0, -20))
  )

  let draw-data = bubble => txt(component(bubble.body, highlight: bubble.highlight), bubble.point, anchor: bubble.anchor)

  for bubble in data {
    draw-data(bubble)
  }

  for (highlight, start, end) in data.zip(data.slice(1)).map(((a, b)) => {
    (a.highlight, a.from, b.to)
  }) {
    if not highlight {
      arrow(start, end, head-scale: 4)
    }
  }

  let (x, y) = data.at(3).point
  let (hx, hy) = (300, 400)
  draw-data(make-data(hx, hy, "rc", [
    *结尾半音*
  ]))

  arrow((x, y - 50), (hx, hy + 8), head-scale: 4)
  arrow((600, 455), (600, 425), head-scale: 4)
})

#canvas(end, start: start, width: 100%, graph)
