#import "@preview/book:0.2.5": target

#let is-pdf-target = () => "realpdf" in sys.inputs
#let is-web-target = () => not is-pdf-target()

#let __build-selector(elem, start, end) = {
    let select = selector(elem)
    if start != none {
        select = select.after(start, inclusive: false)
    }
    if end != none {
        select = select.before(end, inclusive: false)
    }
    return select
}

#let query-first(elem, start, end, kind: none) = {
    let items = query(
        __build-selector(elem, start, end),
        start,
    )

    if elem != metadata or kind == none {
        return items.at(0, default: none)
    }

    for meta in items {
        let data = meta.value
        if data.kind == kind {
            return data
        }
    }

    return none
}

#let query-last(elem, start, end, kind: none) = {
    let items = query(
        __build-selector(elem, start, end),
        end,
    )

    if elem != metadata or kind == none {
        return if items.len() > 0 { items.last() } else { none }
    }

    while items.len() > 0 {
        let data = items.pop().value
        if data.kind == kind {
            return data
        }
    }

    return none
}

#let to-string-zero-padding(num, length, base: 10) = {
    assert(type(num) == int)

    let s = str(num, base: base)

    let count = length - s.len()

    if count > 0 {
        s = "0" * count + s
    }

    return s
}
