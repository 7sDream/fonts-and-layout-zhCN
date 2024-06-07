#import "/lib/glossary.typ": tr
#import "/template/theme.typ": theme

#let normal-underline-with-style = (f, body) => box[
#place(underline(
  // underline 
  stroke: 1pt + theme.main, 
  evade: false,
  background: false,
  // with transparent character
  text(fill: rgb("00000000"), body),
))
#f(body)
]

#let test-font-with-feature = (feature: (), body) => {
  let features = if type(feature) == array { feature } else { (feature,) }
  let font = ("TTX Test",)
  normal-underline-with-style(
    text.with(features: features), 
    text(font: font, body)
  )
}

#show figure: set block(breakable: true, inset: (y: 1em))

#figure(placement: none)[
#show: align.with(start)

无#tr[positioning]规则：#test-font-with-feature[ABAB]

```fea pos A B <150 0 0 0>```：#test-font-with-feature(feature: "ss01")[ABAB]

```fea pos A B <0 150 0 0>```：#test-font-with-feature(feature: "ss02")[ABAB]

```fea pos A B <0 0 150 0>```：#test-font-with-feature(feature: "ss03")[ABAB]

```fea pos A B <0 0 0 150>```：#test-font-with-feature(feature: "ss04")[ABAB]
]
