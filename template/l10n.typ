#import "/template/consts.typ"

#let l10n_setting(doc) = [
  #set text(lang: "zh", region: "CN", script: "hans", hyphenate: true)

  #set smartquote(enabled: false)

  // Primary effect is fixing the issue of Chinese quotes incorrectly rendered
  // using Noto Sans, but we need to include all punctuation marks to ensure the
  // special spacing between consecutive punctuation remains intact and
  // functions correctly.
  //
  // The list comes from
  // https://github.com/w3c/clreq/issues/534#issuecomment-1958783619
  #let cn-punct = "‘“‌「『〔（［｛〈《〖【—…、。，．：；！？％〕）］｝〉》〗】’”」』"
  #show regex("[" + cn-punct + "]+"): set text(font: (..consts.font.chinese-normal,))

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
