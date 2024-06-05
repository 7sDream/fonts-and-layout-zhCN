#import "/template/theme.typ": theme
#import "/lib/glossary.typ": tr

#let stroke = 1pt + theme.main;

#set grid.vline(stroke: stroke)
#set grid.hline(stroke: stroke)

#let graph-cell = (it, no-stroke: false) => block(
  spacing: 0pt,
  inset: 0.5em,
  outset: 0pt,
  stroke: if no-stroke { none } else { stroke },
  it,
)

#let graph = align(center, grid(
  columns: 4,
  inset: 0.5em,
  stroke: none,
  grid.hline(),
  grid.vline(),
  grid.vline(x: 4),
  grid.cell(align: left, colspan: 4)[OpenType 字体格式],
  graph-cell(no-stroke: true)[
    #graph-cell[全局元数据]
  ],
  graph-cell[
    #graph-cell[#tr[outline]]

    A

    B

    ...
  ],
  graph-cell[
    #graph-cell[#tr[metrics]]
    全局#linebreak()#tr[metrics]

    A

    B

    ...
  ],
  graph-cell[
    #graph-cell[高级#tr[typography]特性]
    
    #tr[ligature]

    #tr[kern]

    ...
  ],
  grid.hline(),
))

#block(breakable: false, graph)
