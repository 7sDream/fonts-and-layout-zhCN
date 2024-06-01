#let upstream-version = "b92b2dc"
#let title = "全球文种类的字体与布局"
#let author = "Simon Cozens"
#let translators = ("7sDream", "Xiangdong Zeng")

#let font = (
    chinese-normal: ("Noto Sans SC",),
    chinese-emph: ("LXGW WenKai GB",),
    chinese-mono: ("Noto Sans SC",),

    western-normal: ("Noto Sans",),
    western-emph: ("Linux Libertine",),
    western-mono: ("Cascadia Mono", "Noto Sans Mono"),

    // No color in PDF, we use svg directly for now
    emoji: (/*"Twitter Color Emoji", */),
)

#let font-group = (
    normal: (..font.western-normal, ..font.chinese-normal, ..font.emoji),
    emph: (..font.western-emph, ..font.chinese-emph, ..font.emoji),
    mono: (..font.western-mono, ..font.chinese-mono, ..font.emoji),
)

#let size = (
  page: (
    paper: "a4",
    margin: (top: 2.5cm, bottom: 2cm, left: 2cm, right: 2cm),
  ),

  tiny: 6pt,
  script: 8pt,
  footnote: 10pt,
  small: 11pt,
  text: 12pt,
  large: 14pt,
  Large: 17pt,
  LARGE: 20pt,
  huge: 25pt,
  Huge: 25pt,

  chapter-spacing: 30pt,
  section-above: 20pt,
  subsection-above: 10pt,
  subsubsection-above: 8pt,
  par-spacing: 15pt,
)

#let color = (
    link: color.rgb("#2a7ae2"),
    note: color.rgb("#828282"),
    raw-stroke: color.rgb("#e8e8e8"),
    table-stroke: color.rgb("#ccc")
)
