#import "consts.typ"
#import "util.typ"
#import "components.typ": hr, note

#let __current_chapter_title(loc) = {
  let current_page = loc.page()

  let next_heading = util.query-first(
    selector(heading.where(level: 1, outlined: true)),
    loc, none,
  )
  if next_heading != none and next_heading.location().page() == current_page {
    return next_heading.body
  }

  let prev_heading = util.query-last(
    selector(heading.where(level: 1, outlined: true)),
    none, loc,
  )

  if prev_heading == none {
    return none
  }

  return prev_heading.body
}

#let page_setting(doc) = [
  #set page(
    paper: consts.size.page.paper,
    margin: consts.size.page.margin,
    numbering: "1",
    header: locate(loc => {
      let current_page = loc.page()
      let title = __current_chapter_title(loc)
      if title == none {
        return none
      }
      [
        #block(spacing: 0pt)[
          #if calc.odd(current_page) { h(1fr) }
          #title
        ]
        #block(above: 0.4em)[#hr()]
      ]
    }),
  )

  // 段落
  #set par(first-line-indent: 0pt, justify: true, linebreaks: "optimized")

  // 列表
  #set list(marker: ([•], [◦], [‣]))

  // 链接
  #show ref: set text(fill: consts.color.link)
  #show link: set text(fill: consts.color.link)
  #show cite: set text(fill: consts.color.link)

  // 脚注
  #show footnote: set text(fill: consts.color.link)
  #show footnote.entry: set text(size: consts.size.footnote)
  #set footnote.entry(indent: 0pt)

  // 参考文献
  #set bibliography(style: "gb-7714-2015-numeric")

  // 图表
  #set figure(placement: auto)
  #show figure.caption: it => align(left)[#note(it)]

  // 代码块
  #set raw(syntaxes: (
    "/syntax/OpenType-Feature.sublime-syntax",
  ))
  #show raw.where(block: true): set block(
    stroke: 1pt + consts.color.raw-stroke,
    breakable: true,
    width: 100%,
    inset: 5pt,
  )
  #show raw.where(block: true): set par(justify: false)

  // 表格
  #set table(stroke: 1pt + consts.color.table-stroke)
  #set table.hline(stroke: 1pt + consts.color.table-stroke)
  #set table.vline(stroke: 1pt + consts.color.table-stroke)

  #doc
]
