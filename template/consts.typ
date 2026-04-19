#import "@preview/shiroa:0.3.1": get-page-width
#import "util.typ"

#let upstream-version = "72e96c3"
#let title = "全球文种的字体与布局"
#let author = "Simon Cozens"
#let translators = ("7sDream", "Xiangdong Zeng")

#let font = (
  chinese-normal: "Noto Sans CJK SC",
  chinese-emph: "LXGW WenKai GB",
  chinese-mono: "Noto Sans Mono CJK SC",
  western-normal: "Noto Sans",
  western-emph: "Libertinus Serif", // built-in font
  western-mono: "Cascadia Mono",
  emoji: "Twitter Color Emoji",
)

#let font-pair = (en, cjk, ..others) => (
  (
    "name": en,
    "covers": "latin-in-cjk",
  ),
  cjk,
  ..others.pos(),
)

#let font-group = (
  normal: font-pair(font.western-normal, font.chinese-normal, font.emoji),
  emph: font-pair(font.western-emph, font.chinese-emph, font.emoji),
  mono: font-pair(font.western-mono, font.chinese-mono, font.emoji),
)

#let _font-size-scale = if util.is-web-target() { 1.4 } else { 1.0 }

#let size = (
  pdf-page: (
    paper: "a4",
    margin: (top: 2.5cm, bottom: 2cm, left: 2cm, right: 2cm),
    numbering: "1",
  ),
  web-page: (
    width: get-page-width(),
    height: auto,
    margin: (top: 20pt, bottom: 0.5em, rest: 0pt),
    numbering: none,
  ),
  tiny: 6pt * _font-size-scale,
  script: 8pt * _font-size-scale,
  footnote: 10pt * _font-size-scale,
  small: 11pt * _font-size-scale,
  text: 12pt * _font-size-scale,
  large: 14pt * _font-size-scale,
  Large: 17pt * _font-size-scale,
  LARGE: 20pt * _font-size-scale,
  huge: 25pt * _font-size-scale,
  Huge: 25pt * _font-size-scale,
  chapter-spacing: 30pt * _font-size-scale,
  section-above: 20pt * _font-size-scale,
  subsection-above: 10pt * _font-size-scale,
  subsubsection-above: 8pt * _font-size-scale,
  par-spacing: 15pt * _font-size-scale,
)
