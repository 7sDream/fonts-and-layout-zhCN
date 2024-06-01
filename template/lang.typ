#import "/template/consts.typ": font

// 阿拉伯文，多国使用
#let arabic = text.with(
  font: ("Noto Naskh Arabic",),
  // do not effect line height calculation
  top-edge: "baseline",
  lang: "ara", region: none, script: "arab"
)

// 阿拉伯文，Amiri 字体
#let arabic-amiri = text.with(
  font: ("Amiri",),
  lang: "ara", region: none, script: "arab",
)

// 法语，拉丁字母即可，无需特殊字体
#let french = text.with(
  font: (..font.western-normal,),
  lang: "fra", region: "FR", script: "latn",
)

// 俄语，西里尔字母，无需特殊字体
#let russian = text.with(
  font: (..font.western-normal,),
  lang: "rus", region: "RU", script: "cyrl"
)

// 希腊语，希腊字母，无需特殊字体
#let greek = text.with(
  font: (..font.western-normal,),
  lang: "ell", region: "GR", script: "grek",
)

// 泰语，使用泰文字母
#let thai = text.with(
  font: ("Noto Sans Thai Looped",),
  lang: "tha", region: "TH", script: "thai",
)

// 曼丁哥语，使用恩科字母（西非书面文字）
#let mandingo = text.with(
  font: ("Noto Sans Nko",),
  lang: "mnk", region: "SN", script: "nkoo",
)

// 德语，拉丁字母，无需特殊字体
#let german = text.with(
  font: (..font.western-normal,),
  lang: "deu", region: "DD", script: "latn",
)

// 藏文，多国藏区皆有使用
#let tibetan = text.with(
  font: ("Noto Serif Tibetan",),
  lang: "bod", region: none, script: "tibt",
)

// 高棉文，在高棉语（亦称柬埔寨语）中使用
#let khmer = text.with(
  font: ("Noto Sans Khmer",),
  lang: "khm", region: "KH", script: "khmr",
)

// 天城文，以印地语为例
#let devanagari = text.with(
  font: ("Noto Sans Devanagari",),
  lang: "hin", region: "IN", script: "deva",
)

// 天城文，使用`dev2`造型算法的 Hind 字体
#let hind = text.with(
  font: ("Hind",),
  lang: "hin", region: "IN", script: "dev2",
  features: ("pres",),
)

// 马拉雅拉姆文，也用于书写印地语
#let malayalam = text.with(
  font: ("Manjari",),
  weight: "thin",
  lang: "mal", region: "IN", script: "mlym",
)

// 塔克里文，印度16-19世纪文字，现已基本不使用
#let takri = text.with(
  font: ("Noto Sans Takri",),
  lang: "cdh", region: "IN", script: "takr",
)

// 泰卢固文，南印度附近使用
#let telugu = text.with(
  font: ("Noto Sans Telugu",),
  lang: "tel", region: "IN", script: "telu",
)

// 巴厘文，巴厘岛上民族书写巴厘语使用
#let balinese = text.with(
  font: ("Noto Sans Balinese",),
  lang: "ban", region: "ID", script: "bali",
)

// 夏拉达文，主要用于书写克什米尔语
#let sharada = text.with(
  font: ("Noto Sans Sharada",),
  lang: "kas", region: "IN", script: "shrd",
)

// 傣昙文，主要用于书写傣仂语，北泰语等
#let taitham = text.with(
  font: ("Noto Sans Tai Tham",),
  lang: "khb", region: "TH", script: "lana",
)

// 希伯来字母，以色列希伯来语
#let hebrew = text.with(
  font: ("SBL Hebrew",),
  lang: "heb", region: "IL", script: "hebr"
)

// 孟加拉文，书写孟加拉语
#let bengali = text.with(
  font: ("Noto Sans Bengali",),
  lang: "ben", region: "BD", script: "bng2",
)

// 亚美尼亚字母，亚美尼亚语，亚美尼亚共和国
#let armenian = text.with(
  font: ("Noto Serif Armenian",),
  lang: "hye", region: "AM", script: "armn",
)

// 传统蒙文字母
#let mongolian = text.with(
  font: ("Noto Sans Mongolian",),
  lang: "mon", region: "MN", script: "mong",
)
