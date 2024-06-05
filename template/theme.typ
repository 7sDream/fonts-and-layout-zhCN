#import "@preview/book:0.2.5": target

#let theme-target = if target.contains("-") {
  target.split("-").at(1)
} else if "theme" in sys.inputs {
  sys.inputs.theme
} else {
  "light"
}

#let themes = (
  light: (
    kind: "light",
    bg: white,
    main: color.black,
    link: color.rgb("#2a7ae2"),
    note: color.rgb("#828282"),
    raw-stroke: color.rgb("#e8e8e8"),
    table-stroke: color.rgb("#ccc"),
  ),
  rust: (
    "kind": "light",
    bg: color.hsl(60deg, 9%, 87%),
    main: color.rgb("#262625"),
    link: color.rgb("#2b79a2"),
    note: color.rgb("#727272"),
    raw-stroke: color.rgb("#d8d8d8"),
    table-stroke: color.rgb("#bbb"),
  ),
  coal: (
    kind: "dark",
    bg: color.hsl(200deg, 7%, 8%),
    main: color.rgb("#98a3ad"),
    link: color.rgb("#2b79a2"),
    note: color.rgb("#787888"),
    raw-stroke: color.rgb("#282838"),
    table-stroke: color.rgb("#445"),
  ),
  navy: (
    kind: "dark",
    bg: color.hsl(226deg, 23%, 11%),
    main: color.rgb("bcbdd0"),
    link: color.rgb("2b79a2"),
    note: color.rgb("#788088"),
    raw-stroke: color.rgb("#283038"),
    table-stroke: color.rgb("#404850"),
  ),
  ayu: (
    kind: "dark",
    bg: color.hsl(210deg, 25%, 8%),
    main: color.rgb("#c5c5c5"),
    link: color.rgb("#0096cf"),
    note: color.rgb("#787878"),
    raw-stroke: color.rgb("#282828"),
    table-stroke: color.rgb("#444"),
  )
)

#let theme = if theme-target in themes { 
  themes.at(theme-target)
} else {
  panic("Unknown theme " + theme-target) 
}

#let choose = (a, b) => if theme.kind == "light" { a } else { b }

#let code-highlighting = choose(none, "/syntax/tokyo-night.tmTheme")
