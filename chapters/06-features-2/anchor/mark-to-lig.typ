#import "/lib/draw.typ": *
#import "/template/lang.typ": thai

#let start = (0, 0)
#let end = (500, 350)

#let f0nt = text.with(
  font: ("F0nt",),
  weight: 500,
  lang: "tha", region: "TH", script: "thai",
)

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (50, 50))

  txt(f0nt[\u{0E19}\u{0E15}], (20, 20), anchor: "lb", size: 420 * ux)

  point((200, 267), radius: 5, color: gray)
  shape((180, 256), (191, 326), (228, 328), (218, 257), closed: true, stroke: 1 * ux + theme.main)
  txt([部件 #thai[\u{0E19}] 的锚点], (150, 290), anchor: "rc", size: 20 * ux)
  bezier((150, 290), (170, 290), none, (185, 279), stroke: 2 * ux + theme.main)
  arrow-head((185, 279), 8, theta: -40deg, point-at-center: true)

  point((422, 273), radius: 5, color: gray)
  shape((400, 255), (410, 327), (448, 329), (438, 257), closed: true, stroke: 1 * ux + theme.main)
  txt([部件 #thai[\u{0E15}] 的锚点], (380, 297), anchor: "rc", size: 20 * ux)
  bezier((380, 297), (400, 297), none, (410, 285), stroke: 2 * ux + theme.main)
  arrow-head((410, 285), 8, theta: -40deg, point-at-center: true)
})

#canvas(end, width: 50%, graph)
