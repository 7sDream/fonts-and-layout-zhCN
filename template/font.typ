#import "consts.typ"
#import "theme.typ": theme

#let font-setting(doc) = [
  #set text(
    fill: theme.main,
    font: consts.font-group.normal,
    size: consts.size.text,
    fallback: false,
  )

  #show raw: it => {
    set text(
      font: consts.font-group.mono,
      //This is a hack for https://github.com/typst/typst/issues/1331
      size: 1.25em,
      fallback: false,
    )
    show emph: set text(font: consts.font-group.mono)

    it
  }

  #show emph: set text(font: consts.font-group.emph)

  #doc
]

#let special(body, font: none) = text(
  font: if type(font) == array {
    font
  } else {
    (font,)
  },
  body,
)

#let sil-pua = special.with(font: "Andika")
