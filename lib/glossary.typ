#let __GLOSSARY = (
  "global scripts": ([全球文种], []),
  shaping: ([造型], []),
  layout: ([布局], []),
  type: ([字], []),
  punch: ([字冲], []),
  matrix: ([字模], []),
  sort: ([活字], []),
  "type case": ([字盘], []),
  "hot metal typesetting": ([热金属排印], []),
  bitmap: ([点阵], []),
  baseline: ([基线], []),
  typography: ([字体排印], []),
  "writing system": ([书写系统], []),
  script: ([文字], []),
  scripts: ([文种], []),
  "script.class": ([文种], []),
  "bounding box": ([边界框], []),
  raster: ([栅格], []),
  glyph: ([字形], []),
  outline: ([轮廓], []),
  master: ([母版], []),
  "multiple master": ([多重母版], []),
  rasterization: ([栅格化], []),
  x-height: ([x字高], []),
  character: ([字符], []),
  hinting: ([渲染提示], []),
  serif: ([衬线], []),
  stem: ([字干], []),
  "cap height": ([大写高度], []),
  "contextual": ([上下文相关], []),
  typeset: ([排版], []),
  ligature: ([连字], []),
  "alternate glyph": ([备选字形], []),
  "variable font": ([可变字体], []),
  "typeface family": ([字体家族], []),
  instance: ([样本], []),
  "compositing stick": ([手盘], []),
  rendering: ([渲染], []),
  "character set": ([字符集], []),
  dimension: ([尺寸], []),
  sidebearing: ([跨距], []),
  "kern.origin": ([出格], []),
  kern: ([字偶距], []),
  "em square": ([em方框], []),
  headline: ([字头线], []),
  decender: ([降部], []),
  advance: ([步进], []),
  "advance width": ([步进宽度], []),
  "advance height": ([步进高度], []),
  "horizontal advance": ([水平步进], []),
  cursor: ([光标], []),
  "ink rectangle": ([着墨矩形], []),
  ascender: ([升部], []),
  metrics: ([度量], []),
  "vertical advance": ([垂直步进], []),
  position: ([位置], []),
  shaper: ([造型器], []),
  encoding: ([编码], []),
  codepoint: ([码位], []),
  BMP: ([基本多文种平面], []),
  SMP: ([多文种补充平面], []),
  block: ([区块], []),
  "surrogate pair": ([代理对], []),
  "general category": ([大类], []),
  combine: ([组合], []),
  compose: ([合成], []),
  decompose: ([分解], []),
  bidi: ([双向], []),
  case-fold: ([大小写折叠], []),
  normalization: ([正态化], []),
  diacritic: ([变音符号], []),
  canonical: ([正则], []),
  spline: ([样条], []),
  substitution: ([替换], []),
  positioning: ([定位], []),
  counter: ([字怀], []),
  contour: ([轮廓线], []),
  lookup: ([查询组], []),
  "chaining": ([链式], []),
  "chaining rules": ([链式规则], []),
  "horizontal typeset": ([横排], []),
  "vertical typeset": ([竖排], []),
  "glyph class": ([字形类], []),
  "anchor attachment": ([锚点衔接], []),
  "attachment rules": ([附加规则], []),
  "multiple substitution": ([增量替换], []),
  "alternate substitution": ([备选替换], []),
  "chaining substitution": ([链式替换], []),
  "single adjustment": ([单字调整], []),
  "cursive attachment": ([连笔衔接], []),
  "cluster": ([簇], []),
)

#let __glossary_meta(..data) = metadata((
  kind: "glossary",
  ..data.named(),
))

#let tr(body, origin: false, force: none) = {
  if type(body) == content {
    if body.has("text") {
      body = body.at("text")
    } else {
      panic("Unsupport complicate content")
    }
  }

  if body not in __GLOSSARY {
    panic("Unknown glossary '" + body + "'")
  }

  let translation = if type(force) == content {
    force
  } else {
    __GLOSSARY.at(body).at(0)
  }

  if origin {
    ranslation = translation + [（#body）]
  }

  translation + __glossary_meta(origin: body)
}

#let glossary_table = [
  #let cells = ();
  #for entry in __GLOSSARY.pairs() {
    let key = entry.at(0)
    let value = entry.at(1)

    cells.push([#key])
    cells.push([#value.at(0)])
    cells.push([#value.at(1)])
  }

  #table(
    columns: 3,
    ..cells,
  )
]
