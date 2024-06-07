#import "/lib/draw.typ": *
#import "/template/lang.typ": malayalam

#let start = (0, 0)
#let end = (900, 350)

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 100))
  txt(malayalam[\u{0D15}\u{0D4D} + \u{0D38} = \u{0D15}\u{0D4D}\u{0D38}], (0, 350), anchor: "lt", size: 144 * ux)
  txt(malayalam[\u{0D15}\u{0D4D} + \u{0D38} + \u{0D41} = \u{0D15}\u{0D4D}\u{0D38}\u{0D41}], (0, 160), anchor: "lt", size: 120 * ux)
})

#canvas(end, width: 80%, graph)
