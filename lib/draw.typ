#import "/template/theme.typ": theme, choose

#let state-size = state("size", none)
#let state-start = state("tart", none)
#let state-unit = state("unit", none)

#let make-relative = ((w, h), (sx, sy)) => ((x, y)) => (
  (x - sx) / w * 100%,
  100% - (y - sy) / h * 100%,
)

#let make-relative-to = rel => (a, b) => {
  let ra = rel(a)
  let rb = rel(b)
  ra.zip(rb).map(((a, b)) => a - b)
}

#let with-rel = (f) => context {
  let rel = make-relative(state-size.get(), state-start.get())
  f(rel)
}

#let with-unit = (f) => context {
  let unit = state-unit.get()
  f(unit.at(0), unit.at(1))
}

#let txt = (t, p, size: none, anchor: "cc", dx: 0, dy: 0) => context {
  let rel = make-relative(state-size.get(), state-start.get())

  let final-txt = if size != none {
    text(size: size, t)
  } else { t }

  let (x, y) = rel((p.at(0) + dx, p.at(1) + dy))
  let (width: w, height: h) = measure(final-txt)
  let d = (
    lt: (0pt, 0pt),
    lc: (0pt, -h/2),
    lb: (0pt, -h),
    ct: (-w/2, 0pt),
    cc: (-w/2, -h/2),
    cb: (-w/2, -h),
    rt: (-w, 0pt),
    rc: (-w, -h/2),
    rb: (-w, -h),
  ).at(anchor)
  place(dx: x + d.at(0), dy: y + d.at(1), final-txt)
}

#let point = (
  p, radius: 10,
  color: theme.main, thickness: 1pt, dash: none, fill: true,
  need-txt: false, size: none, anchor: "cc", dx: 0, dy: 0,
) => context {
  let rel = make-relative(state-size.get(), state-start.get())
  let rel-to = make-relative-to(rel)

  let (x, y) = p
  let (w, h) = rel-to((radius, radius), (0, 0)).map(calc.abs)

  if need-txt {
    let t = "(" + str(x) + ", " + str(y) + ")"
    txt(t, p, size: size, anchor: anchor, dx: dx, dy: dy)
  }

  let (u, v) = rel((x, y))
  place(dx: u - w, dy: v - h, ellipse(
    width: 2 * w,
    height: 2 * h,
    fill: if fill { color } else { none },
    stroke: stroke(
      paint: color,
      thickness: thickness,
      dash: dash,
    ),
  ))
}

#let segment = (start, end, stroke: 1pt + theme.main) => context {
  let rel = make-relative(state-size.get(), state-start.get())

  place(line(start: rel(start), end: rel(end), stroke: stroke))
}

#let shape = (..args) => context {
  let rel = make-relative(state-size.get(), state-start.get())
  let rel-to = make-relative-to(rel)

  let points = args.pos().map(point => {
    if type(point.at(0)) == array {
      if point.len() == 1 {
        rel(point.at(0))
      } else if point.len() == 2 {
        let (p, c) = point
        (rel(p), rel-to(c, p))
      } else if point.len() == 3 {
        let (p, c1, c2) = point
        (rel(p), rel-to(c1, p), rel-to(c2, p))
      } else {
        panic("Unknown point format")
      }
    } else {
      rel(point)
    }
  })

  place(path(..points, ..args.named()))
}

#let rect = (start, width: 0, height: 0, end: none, radius: 0, shadow: none, ..args) => context {
  let (ux, uy) = state-unit.get()
  let rel = make-relative(state-size.get(), state-start.get())
  let rel-to = make-relative-to(rel)

  let (width, height) = if end != none {
    rel-to(end, start)
  } else {
    (width * ux, height * uy)
  }

  let radius = radius * ux;

  let (x, y) = start
  let (rx, ry) = rel(start)

  if shadow != none {
    let dx = shadow.at("dx", default: 3)
    let dy = shadow.at("dy", default: -3)
    let darken = shadow.at("darken", default: 50%)
    let fill = shadow.at("fill", default: args.named().at("fill")).darken(darken)
    let (sx, sy) = rel((x + dx, y + dy))
    place(left + top, dx: sx, dy: sy, rect(stroke: none, width: width, height: height, radius: radius, fill: fill))
  }

  let user-args = args.named()

  if user-args.at("fill", default: none) == none {
    if "stroke" not in user-args {
      user-args.insert("stroke", 1pt + theme.main)
    }
  }

  place(left + top, dx: rx, dy: ry, rect(width: width, height: height, radius: radius, ..user-args))
}

#let bezier = (start, c1, c2, end, stroke: 1pt + theme.main) => {
  shape(
    closed: false, stroke: stroke,
    (start, start, c1),
    if c2 == none {
      end
    } else {(
      end, c2, end,
    )},
  )
}

#let arrow-head = (point, size, theta: 0deg, color: theme.main, point-at-center: false) => {
  let center = if point-at-center {
    point
  } else {
    let (ex, ey) = point
    (ex + size * calc.cos(180deg + theta), ey + size * calc.sin(180deg + theta))
  }

  let (cx, cy) = center

  let (t, r, l) = for c in range(0, 3) {
    let alpha = theta - 120deg * c
    ((cx + size * calc.cos(alpha), cy + size * calc.sin(alpha)),)
  }

  shape(t, r, center, l, stroke: none, fill: color, closed: true)
}

#let arrow = (
  start, end,
  relative: false,
  stroke: 1pt + theme.main,
  head-scale: 1.0,
) => with-unit((ux, uy) => context {
  let ((ex, ey), (rx, ry)) = if relative {
    (end.zip(start).map(((a, b)) => a + b), end)
  } else {
    (end, end.zip(start).map(((a, b)) => a - b))
  }

  let theta = calc.atan2(rx, ry)
  let size = stroke.thickness.to-absolute() / ux * head-scale;
  let center = (
    ex + size * calc.cos(180deg + theta),
    ey + size * calc.sin(180deg + theta),
  )

  segment(start, center, stroke: stroke)
  arrow-head((ex, ey), size, theta: theta, color: stroke.paint)
})

#let mesh = (start, end, step, stroke: 1pt + theme.main) => {
  let (sx, sy) = start
  let (ex, ey) = end
  let (dx, dy) = step

  for x in range(sx, ex + dx, step: dx) {
    segment((x, sy), (x, ey), stroke: stroke)
  }

  for y in range(sy, ey + dy, step: dy) {
    segment((sx, y), (ex, y), stroke: stroke)
  }
}

#let to-absolute = (l, all) => {
    if type(l) == relative {
     l.ratio * all + l.length
    } else if type(l) == ratio {
      l * all
    } else {
      l
    }
}

#let calc-real-size = (cw, ch, width, height, f) => layout(size => {
  let width = width;
  let height = height;

  if width == none and height == none {
    panic("must give one of width or height")
  }

  if type(width) != length {
    width = to-absolute(width, size.width)
  }

  if type(height) != length {
    height = to-absolute(height, size.height)
  }

  if width != none and height == none {
    height = width / cw * ch
  } else if height != none and width == none {
    width = height / ch * cw
  }

  f(width, height)
})

#let tiny-block = block.with(
    breakable: false,
    fill: none,
    stroke: none,
    radius: 0pt,
    spacing: 0pt,
    inset: 0pt,
    outset: 0pt,
    clip: false,
)

#let canvas = (end, body, start: (0, 0), width: none, height: none, clip: false) => {
  let (cw, ch) = end.zip(start).map(((a, b)) => a - b)

  calc-real-size(
    cw, ch, width, height,
    (rw, rh) => tiny-block(width: rw, height: rh, clip: clip, {
      let rel = make-relative((cw, ch), start)
      let rel-to = make-relative-to(rel)
      let r = rel-to((1, 1), (0, 0)).map(calc.abs)
      let unit = (r.at(0) * rw, r.at(1) * rh)

      state-start.update(start)
      state-size.update((cw, ch))
      state-unit.update(unit)

      let (cw, ch) = end.zip(start).map(((a, b)) => a - b)

      tiny-block(width: 100%, height: 100%, body)
    }),
  )
}
