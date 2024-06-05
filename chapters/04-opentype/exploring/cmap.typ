#import "/template/template.typ": web-page-template
#import "/template/components.typ": note
#import "/template/lang.typ": tibetan

#import "/lib/glossary.typ": tr

#show: web-page-template

// ### The `cmap` table
=== `cmap` 表

// A font can contain whatever glyphs, in whatever encoding and order, it likes. If you want to start your font with a Tibetan letter ga (ག) as glyph ID 1, nothing is going to stop you. But for the font to work, you need to provide information about how users should access the glyphs they want to use - or in other words, how your glyph IDs map to the Unicode (or other character set) code points that their text consists of. The `cmap` table is that character map.
字体设计者可以按照自己的偏好来决定字体中要包含哪些#tr[glyph]，使用什么#tr[encoding]，用什么顺序排列。如果你想把藏文字母ga（#tibetan[ག]）安排在#tr[glyph]ID 1 的位置，没有任何规则会阻止你。但为了让这个字体能正常工作，你还需要提供一些让用户知道在什么时候调用这个#tr[glyph]的信息。也就是调用方需要知道怎么把Unicode（或者其他#tr[encoding]）中的#tr[character]映射到绘制的#tr[glyph]上。`cmap` 表的作用就是提供这个#tr[character]映射信息。

// If a user's text has the letter `A` (Unicode code point `0x41`), which glyph in the font should be used? Here's how it looks in our dummy font:
如果有一段包含`A`（Unicode#tr[codepoint]为`0x41`）的文本，那么哪个#tr[glyph]会被调用呢？我们测试字体中的`cmap`信息如下：

```xml
<cmap>
  <tableVersion version="0"/>
  <cmap_format_4 platformID="0" platEncID="3" language="0">
    <map code="0x41" name="A"/><!-- LATIN CAPITAL LETTER A -->
    <map code="0x42" name="B"/><!-- LATIN CAPITAL LETTER B -->
  </cmap_format_4>
  <cmap_format_6 platformID="1" platEncID="0" language="0">
    <map code="0x41" name="A"/>
    <map code="0x42" name="B"/>
  </cmap_format_6>
  <cmap_format_4 platformID="3" platEncID="1" language="0">
    <map code="0x41" name="A"/><!-- LATIN CAPITAL LETTER A -->
    <map code="0x42" name="B"/><!-- LATIN CAPITAL LETTER B -->
  </cmap_format_4>
</cmap>
```

// The `ttx` software used to generate the textual dump of the font has been overly helpful in this case - it has taken the mapping of characters to glyph *ID*s, and has then replaced the IDs by names. The `cmap` table itself just contains glyph IDs.
在这里`ttx`为了生成便于阅读的文本格式而进行了额外工作。它将映射表中的#tr[glyph]ID转换为了对应的名称。原始的`cmap`表中储存的只是#tr[glyph]ID。

// Looking back at the `GlyphOrder` pseudo-table that `ttx` has generated for us:
通过 `ttx` 在生成的XML中附加的 `GlyphOrder` 表，我们可以知道原始的#tr[glyph]ID信息：

```xml
<GlyphOrder>
  <!-- id 属性仅供人类阅读使用，当程序解析时将被忽略 -->
  <GlyphID id="0" name=".notdef"/>
  <GlyphID id="1" name="A"/>
  <GlyphID id="2" name="B"/>
</GlyphOrder>
```

// We see that if the user wants Unicode codepoint `0x41`, we need to use glyph number 1 in the font. The shaping engine will use this information to turn code points in input documents into glyph IDs.
这下我们就知道，如果用户需要Unicode#tr[codepoint]`0x41`对应的字形，就会自动使用ID为1的#tr[glyph]。#tr[shaping]引擎就是这样将输入的字符串转换为#tr[glyph]ID列表。
