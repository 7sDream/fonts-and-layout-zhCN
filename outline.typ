#import "template/consts.typ"
#import "template/theme.typ": theme

#counter(page).update(1)

#heading(level: 1, numbering: none, outlined: false)[目录]

#show outline.entry: it => {
  let loc = it.element.location()
  let v_space = if it.level == 1 {
    v(1.5em, weak: true)
  } else {
    none
  }
  let indent = (it.level - 1) * 1.5em
  v_space + [
    #h(indent)
    #link(loc)[#text(fill: theme.link)[#it.element.body]]
    #box(width: 1fr, it.fill)
    #strong(it.page)
  ]
}

#outline(title: none)

#pagebreak()
