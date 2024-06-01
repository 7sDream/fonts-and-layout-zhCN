#import "/lib/draw.typ": *
#import "/template/lang.typ": khmer

#let start = (0, 0)
#let end = (1000, 300)
#let color-khmer = (color, it) => text(fill: color, khmer(it))
#let red-khmer = color-khmer.with(red)
#let gray-text = text.with(fill: gray)

#let graph = with-unit((ux, uy) => {
  // mesh(start, end, (100, 100))

  let t = text[
    #red-khmer[\u{1783}]#gray-text[+]#khmer[\u{17D2}]#gray-text[+]#khmer[\u{1784}]#gray-text[=]#box[#place[#khmer[\u{1783}\u{17D2}\u{1784}]]#red-khmer[\u{1783}]
  ]
  ]

  txt(t, (10, 150), anchor: "lc", size: 200 * ux)
  txt(align(center)[
    U+1783#linebreak()
    KHMER LETTER#linebreak()
    KHO
  ], (100, 300), anchor: "ct", size: 18 * ux)
  txt(align(center)[
    U+17D2#linebreak()
    KHMER SIGN#linebreak()
    COENG
  ], (370, 300), anchor: "ct", size: 18 * ux)
  txt(align(center)[
    U+1784#linebreak()
    KHMER LETTER#linebreak()
    NGO
  ], (610, 300), anchor: "ct", size: 18 * ux)
})

#canvas(end, start: start, width: 100%, graph)
