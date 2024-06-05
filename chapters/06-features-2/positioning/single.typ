#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ### Single adjustment
=== #tr[single adjustment]

// A single adjustment rule just repositions a glyph or glyph class, without contextual reference to anything around it. In Japanese text, all glyphs normally fit into a standard em width and height. However, sometimes you might want to use half-width glyphs, particularly in the case of Japanese comma and Japanese full stop. Rather than designing a new glyph just to change the width, we can use a positioning adjustment:
#tr[single adjustment]用于在不需要访问上下文时，对一个#tr[glyph]或#tr[glyph class]进行重#tr[positioning]。在日文中，所有的#tr[glyph]通常都会占据一个标准宽高的#tr[em square]。但有时某些#tr[glyph]也会想要使用半宽形式，特别是日文逗号和句号。我们不需要重新设计一个只是调整了宽高的#tr[glyph]，只要用#tr[positioning]规则处理即可：

```fea
feature halt {
  pos uni3001 <-250 0 -500 0>;
  pos uni3002 <-250 0 -500 0>;
} halt;
```

// Remember that this adjusts the *placement* (placing the comma and full stop) 250 units to the left of where it would normally appear and also the *advance*, placing the following character 500 units to the left of where it would normally appear: in other words we have shaved 250 units off both the left and right sidebearings of these glyphs when the `halt` (half-width alternates) feature is selected.
这段代码既会调整#tr[glyph]的放置位置也会调整它的#tr[advance]。在放置上，会让它相对原始位置向左移动250单位；而对#tr[advance]的调整，会让下一个#tr[character]出现的位置往左移500单位。换句话说，就是当开启`halt`特性时，我们会削掉这些#tr[glyph]的左右#tr[sidebearing]各250单位。
