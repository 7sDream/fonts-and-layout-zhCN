#import "/lib/draw.typ": *
#import "/template/lang.typ": hind

// 本例需要使用 dev2 布局方法和 Hind 字体

#let start = (0, 0)
#let end = (600, 400)
#let without-pres = it => hind(text(features: ("pres": 0,), it))

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 100))

  txt([未开启`pres`特性时：], (30, 370), anchor: "lt", size: 36 * ux)
  txt(without-pres[हि + ख = हिख], (150, 280), anchor: "lt", size: 72 * ux)
  txt([开启`pres`特性时：], (30, 170), anchor: "lt", size: 36 * ux)
  txt(hind[हि + ख = हिख], (150, 80), anchor: "lt", size: 72 * ux)
})

#canvas(end, width: 70%, graph)
