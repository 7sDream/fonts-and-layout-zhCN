#import "/template/theme.typ": theme

#let data = ```
11000110
01100110
01100110
11010110
11001100
11000110
11000110
00000000
```.text.split("\n").map(str.codepoints).map(it => it.map(v => v == "1"))

#let bitmap-grid = (body) => grid(
  columns: (1fr,) * 8 ,
  stroke: 1pt + theme.main,
  inset: 0pt,
  ..range(0, 64).map(
    index => layout(size => block(height: size.width)[
      #let row = calc.floor(index / 8)
      #let col = calc.rem(index, 8)
      #if body != none { body(row, col, size.width) }
    ])
  ),
)

#let bitmap-image = bitmap-grid((row, col, width) => block(
  width: 100%, height: 100%, 
  fill: if data.at(row).at(col) { theme.main } else { none }
))

#let bitmap-value = bitmap-grid((row, col, width) => align(horizon + center)[
  #set text(size: width / 2)
  #if data.at(row).at(col) { [1] } else { [0] }
])

#let right = 60%
#let left = right * 7 / 16
#let gap = 100% - left - right
#block(width: 100%, grid(
  columns: (left, right),
  column-gutter: gap,
  align: bottom,
  bitmap-image,
  grid.cell(rowspan: 2, bitmap-image),
  bitmap-value,
))
