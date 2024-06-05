#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## Characters and glyphs
== #tr[character]和#tr[glyph]

// We've been talking loosely about "letters" and "numbers" and "stuff you want to typeset". But that's a bit cumbersome; we need a better way to talk about "letters and numbers and symbols and other stuff." As it happens, we're going to need *two* specific terms to be able to talk about "letters and numbers and symbols and other stuff."
我们一直在不很严谨地使用“字母”、“数字”和“你想排版的东西”等等词语。但这有点麻烦，我们需要一个更好的方式来讨论它们。实际上，我们需要*两个*不同的术语来描述这个概念。

// The first term is a term for the things that you design in a font - they are *glyphs*. Some of the glyphs in a font are not things that you may think need to be designed: for example, the space between words is a glyph. Some fonts have a variety of different space glyphs. Font designers still need to make a decision about how wide those spaces ought to be, and so there is a need for space glyphs to be designed.
第一个术语是指在字体中实际被设计的那个东西——它们是*#tr[glyph]*。你可能认为字体中的某些#tr[glyph]可能并不需要实际的设计，比如单词之间的空格。但实际上，字体中会有各种不同的空格，字体设计师仍然需要决定，也就是设计，这些空格#tr[glyph]的宽度。

// Glyphs are the things that you draw and design in your font editor - a glyph is a specific design. My glyph for the letter "a" will be different to your glyph for the letter "a". But in a sense they're both the letter "a". Their semantic content is the same.
#tr[glyph]一般在字体编辑器中绘制，每个#tr[glyph]都是一个独特的设计。我为字母a设计的#tr[glyph]会和你设计的不同，但它们都是字母a。它们背后的语义是相同的。

// So we are back to needing a term for the generic version of any letter or number or symbol or other stuff, *regardless of how it looks*: and that term is a *character*. "a" and `a` and *a* and **a** are all different glyphs, but the same character: behind all of the different designs is the same Platonic ideal of an "a". So even though your "a" and my "a" are different, they are both the character "a"; this is something that we will look at again when it comes to the chapter on Unicode, which is a *character set*.
我们也需要一个术语来描述这种内在语义，一个去除了外形设计之后，这个“字母、数字、符号或其他东西”的通用版本：*#tr[character]*。a、`a`、_a_、*a*，这些是不同的#tr[glyph]，但都是相同的#tr[character]。在这些不同的设计背后，有一个对于a的共同的柏拉图式完美理型。所以即使你的a和我的a看起来不一样，但它们都是相同的#tr[character]a。在后续对于Unicode这个*#tr[character set]*的章节中，我们会再次讨论这些概念。
