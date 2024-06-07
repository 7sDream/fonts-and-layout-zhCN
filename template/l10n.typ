#import "/template/consts.typ"

#let l10n_setting(doc) = [
  #set text(lang: "zh", region: "CN", script: "hans", hyphenate: true)

  #set smartquote(enabled: false)

  // https://github.com/w3c/clreq/issues/534
  #show regex("[“”]"): set text(font: (..consts.font.chinese-normal,))
  #show regex("——"): set text(font: (..consts.font.chinese-normal,))

  #show ref: it => {
    let el = it.element
    if el == none {
      return it
    }

    if el.func() == heading {
      let number = numbering(
        el.numbering,
        ..counter(heading).at(el.location())
      )
      return link(el.location())[第#[#number]#el.supplement]
    }

    return it
  }

  #doc
]
