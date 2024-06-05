#import "template/consts.typ"
#import "template/util.typ"
#import "template/template.typ": web-page-template

#show: web-page-template

#set page(numbering: none) if util.is-pdf-target()
#set page(paper: "a4") if util.is-web-target()

#show: align.with(center)

#v(1fr)

#text(size: 3em, weight: "bold")[#consts.title]

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
  原书版本: consts.upstream-version,
  翻译版本: sys.inputs.at("githash", default: "unknown"),
  编译器版本: str(sys.version),
  编译时间: sys.inputs.at("compile_time", default: "unknown"),
))

#if util.is-pdf-target() {
  pagebreak(weak: true, to: "odd")
}
