#import "/lib/draw.typ": *
#import "/template/lang.typ": arabic-amiri

#let start = (0, 0)
#let end = (500, 120)

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (50, 50))

  txt([关闭`calt`#h(1fr)#arabic-amiri(text(features: ("calt": 0, "kern": 0))[(لبے)])], (0, 110), anchor: "lt", size: 42 * ux)
  txt([开启`calt`#h(1fr)#arabic-amiri(text(features: ("calt": 1, "kern": 0))[(لبے)])], (0, 50), anchor: "lt", size: 42 * ux)
})

#canvas(end, width: 70%, graph)
