#import "/lib/draw.typ": *
#import "/template/lang.typ": arabic-amiri

#let start = (0, 0)
#let end = (300, 140)

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (50, 50))

  txt([关闭ss01：#arabic-amiri()[ربن]], (0, 130), anchor: "lt", size: 42 * ux)
  txt([开启ss01：#arabic-amiri(text(features: ("ss01",))[ربن])], (0, 60), anchor: "lt", size: 42 * ux)
})

#canvas(end, width: 40%, graph)
