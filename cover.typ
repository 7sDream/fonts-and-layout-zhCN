#import "template/consts.typ"

#set page(numbering: none)

#show: align.with(center)

#v(1fr)

#text(size: 3em)[#consts.title]

#v(1em)

_一本关于字体设计、Unicode和计算机中复杂文本处理的免费书籍_

_#consts.author 著_

_#consts.translators.join("、") 译_

#v(3fr)

#let info_table = info => context {
  let key_widths = info.keys().map(k => measure(emph(k)).width)
  let max_width = calc.max(..key_widths)
  let keys = for (key, width) in info.keys().zip(key_widths) {
    let chars = key.clusters()
    if chars.len() >= 2 and width < max_width {
      let space = (max_width - width).to-absolute() / (chars.len() - 1)
      let result = chars.join(h(space))
      (result,)
    } else {
      ([#key],)
    }
  }
  let cells = keys.zip(info.values()).map(((k, v)) => (k, [：], v).map(emph)).flatten()

  table(
    columns: (auto, 1em, auto),
    align: left,
    stroke: none,
    inset: (x: 0pt, y: 5pt),
    ..cells,
  )
}

#info_table((
  版本: consts.upstream-version,
  翻译版本: sys.inputs.at("githash", default: "unknown"),
  编译时间: sys.inputs.at("compile_time", default: "unknown"),
))

#pagebreak(weak: true, to: "odd")
