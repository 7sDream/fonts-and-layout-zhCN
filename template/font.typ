#import "consts.typ"

#let font-setting(doc) = [
  #set text(
    font: consts.font-group.normal,
    size: consts.size.text,
    fallback: false,
  )

  #show raw: set text(
    font: consts.font-group.mono,
    //This is a hack for https://github.com/typst/typst/issues/1331
    size: 1.25em,
    fallback: false,
  )

  #show emph: set text(font: consts.font-group.emph)

  #show regex("[“”]"): set text(font: (..consts.font.chinese-normal,))

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
