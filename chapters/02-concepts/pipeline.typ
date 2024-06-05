#import "/lib/draw.typ": *
#import "/template/theme.typ": theme, choose
#import "/lib/glossary.typ": tr

#let start = (0, 0)
#let end = (1000, 1100)

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 100), stroke: 1 * ux + gray)

  let bubble-stroke = 3 * ux + theme.main
  let bubble-stroke-dashed = stroke(
    paint: theme.main,
    thickness: 3 * ux,
    dash: "dashed",
  )
  let bubble = (body, dash: false) => block(
    inset: 20 * ux,
    spacing: 0pt,
    radius: 40 * ux,
    stroke: if dash { bubble-stroke-dashed } else { bubble-stroke },
    fill: choose(rgb("ededed"), rgb("343434")),
    align(center, text(size: 50 * ux, body)),
  )
  let arrow = arrow.with(stroke: bubble-stroke, head-scale: 4)

  txt(["Hello world"], (300, 1000), size: 50 * ux, anchor: "cb")

  txt(align(center)[
    13pt 粗意大利体\
    Noto Serif\
    小型大写字母
  ], (740, 900),size: 50 * ux, anchor: "cb")

  txt(bubble[
    Unicode\ 处理
  ], (300, 720), anchor: "cb")
  arrow((300, 980), (300, 890))

  txt(bubble[
    字体管理
  ], (740, 750), anchor: "cb")
    arrow((740, 880), (740, 830))

  txt(bubble[
    文本#tr[shaping]
  ], (500, 600), anchor: "cb")
  arrow((300, 720), (470, 678))
  arrow((740, 750), (540, 678))

  txt(bubble(dash: true)[
    语言处理
  ], (500, 450), anchor: "cb")
  arrow((500, 600), (500, 525))

  txt(bubble(dash: true)[
    断行
  ], (500, 320), anchor: "cb")
  arrow((500, 450), (500, 400))

  txt(bubble(dash: true)[
    连字号
  ], (700, 410), anchor: "lc")
  arrow((570, 370), (700, 410))
  arrow((700, 410), (570, 370))

  txt(bubble(dash: true)[
    对齐
  ], (700, 300), anchor: "lc")
  arrow((570, 350), (700, 300))
  arrow((700, 300), (570, 350))

  txt(bubble[
    渲染
  ], (500, 190), anchor: "cb")
  arrow((500, 320), (500, 265))

  txt(bubble(dash: true)[
    #tr[hinting]\ 处理
  ], (300, 290), anchor: "rc")
  arrow((430, 240), (300, 260))
  arrow((300, 260), (430, 240))

  txt(bubble(dash: true)[
    #tr[rasterization]
  ], (300, 150), anchor: "rc")
  arrow((432, 210), (300, 150))
  arrow((300, 150), (432, 210))

  txt(text(
    font: ("Noto Serif",),
    style: "italic",
    weight: "bold",
    features: ("smcp",),
  )[
    Hello world
  ], (500, 70), size: 50 * ux, anchor: "ct")
  arrow((500, 190), (500, 120))
})

#canvas(end, start: start, width: 70%, graph)
