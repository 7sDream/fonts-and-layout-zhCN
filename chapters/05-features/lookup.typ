#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## Features and lookups
== 特性与#tr[lookup]

// We've been putting our *rules* into a *feature*. Features are part of the way that we signal to the shaper which rules to apply in which circumstances. For example, the feature called `liga` is the "ligatures" features, and is always processed in the case of text in the Latin script unless the user specifically requests it to be turned off; there is another feature (`rlig`) for required ligatures, those which should always be applied even if the user doesn't want explicit ligatures. Some features are *always* processed as a fundamental part of the shaping process - particularly the case when dealing with scripts other than Latin - while others are optional and aesthetic. We will introduce different features, and what they're recommended to be used for, as we come across them, but you can also look up any unfamiliar features in the [OpenType Feature Registry](https://docs.microsoft.com/en-us/typography/opentype/spec/featurelist)
目前的代码结构是规则包含在特性中。特性是我们用来告诉#tr[shaper]在某种特定情形下，需要使用哪些规则的一种组织结构。比如我们这里使用的`liga`其实是#tr[ligature]（ligature）特性，这一特性在处理拉丁文本时会自动开启，除非用户明确指定才会关闭。还有另一个特性叫做`rlig`，表示必要（required）#tr[ligature]。这一特性即使用户明确指出不需要#tr[ligature]也仍然会被应用。像这样永远会被使用的特性被视为文本#tr[shaping]流程中（特别是处理拉丁以外的#tr[scripts]时）的基础步骤。除此之外的则是可选特性，它们主要服务于美学上的需求。我们会逐步向你介绍这些不同的特性以及它们各自推荐的使用场景。在遇到不熟悉的特性时，你也可以通过OpenType特性列表#[@Microsoft.OpenTypeRegistered]进行查询。

// We've only seen rules and features so far but it's important to know that there's another level involved too. Inside an OpenType font, rules are arranged into *lookups*, which are associated with features. Although the language we use to write OpenType code is called "feature language", the primary element of OpenType shaping is the *lookup*. So rules are grouped into sets called *lookups*, and lookups are placed into *features* based on what they're for. You might want to refine your typography in different ways at different times, and turning on or off different combinations of features allows you to do this.
现在我们只使用了特性和规则，但其中还隐含了另一个等级的重要组织结构。在OpenType字体中，规则首先被组织成*#tr[lookup]*，然后再与特性关联。虽然我们写代码的语言叫做特性语言，但OpenType进行文本#tr[shaping]时最主要的元素其实是#tr[lookup]，它们按照自己的作用放置在相应的特性中。你可能希望字体的#tr[typography]效果能根据需求进行调整，通过开关不同的特性可以做到这一点。

// For instance, if you hit the "small caps" icon in your word processor, the word processor will ask the shaping engine to turn on the `smcp` feature. The shaping engine will run through the list of features in the font, and when it gets to the `smcp` feature, it will look at the lookups inside that feature, look at each rule within those lookups, and apply them in turn. These rules will turn the lower case letters into small caps:
比如你在 Word 中点击“小型大写字母”图标，Word 软件会让#tr[shaping]引擎打开字体的`smcp`特性。此时#tr[shaping]引擎就会遍历字体的特性列表，当他找到`smcp`特性时，会逐条查看其中的#tr[lookup]，并对每个#tr[lookup]中的规则按顺序进行应用。@figure:feature-hierarchy 展现了将小写字母转换为小型大写字母流程。

#figure(
  caption: [启用`smcp`特性],
)[#include "feature-hierarchy.typ"] <figure:feature-hierarchy>

// **To really understand OpenType programming, you need to think in terms of lookups, not features**.
*为了能够真正地理解OpenType编程，你需要站在#tr[lookup]的角度进行思考，而不是站在特性的角度。*

//  So far our lookups have been *implicit*; by not mentioning any lookups and simply placing rules inside a feature, the rules you specify are placed in a single, anonymous lookup. So this code which places rules in the `sups` feature, used when converting glyphs to their superscript forms (for example, in the case of footnote references):
至今为止的代码中，#tr[lookup]都是隐式的。像这样在特性里直接写规则的话，这些规则都会被直接放在同一个匿名#tr[lookup]中。以`sups`特性为例，其中的代码用于将#tr[glyph]转换为（可能用于书写脚注的引用标号的）上标形式：

```fea
feature sups {
  sub one by onesuperior;
  sub two by twosuperior;
  sub three by threesuperior;
} sups;
```

// is equivalent to this:
这段代码等价于：

```fea
feature sups {
  lookup sups_1 {
    sub one by onesuperior;
    sub two by twosuperior;
    sub three by threesuperior;
    } sups_1;
} sups;
```

// We can manually organise our rules within a feature by placing them within named lookups, like so:
我们也可以通过将规则放入手动命名的#tr[lookup]中来组织特性中的规则。就像下面这样：

```fea
feature pnum {
  lookup pnum_latin {
    sub zero by zero.prop;
    sub one by one.prop;
    sub two by two.prop;
    ...
  } pnum_latin;
  lookup pnum_arab {
    sub uni0660 by uni0660.prop;
    sub uni0661 by uni0661.prop;
    sub uni0662 by uni0662.prop;
    ...
  } pnum_arab;
} pnum;
```

// In fact, I would strongly encourage *always* placing rules inside an explicit `lookup` statement like this, because this helps us to remember the role that lookups play in the shaping process. As we'll see later, that will in turn help us to avoid some rather subtle bugs which are possible when multiple lookups are applied, as well as some problems that can develop from the use of lookup flags.
我永远强烈推荐把规则放进手动创建的#tr[lookup]中，因为这样可以帮助我们记住#tr[lookup]在整个#tr[shaping]过程中的角色和作用。这也能帮助我们在需要使用多个#tr[lookup]或复杂的#tr[lookup]选项时避免一些微妙的Bug。后面我们会看到其中的原因。

// Finally, you can define lookups outside of a feature, and then reference them within a feature. For one thing, this allows you to use the same lookup in more than one feature, sharing rules and reducing code duplication:
最后，你也可以在特性之外定义#tr[lookup]，并在特性内引用它们。这也就让你能在多个特性中重复使用同一个#tr[lookup]，像这样共享规则可以减少重复代码：

```fea
lookup myAlternates {
  sub A by A.001; # 替代形式
  ...
} myAlternates;

feature salt { lookup myAlternates; } salt;
feature ss01 { lookup myAlternates; } ss01;
```

// The first clause *defines* the set of rules called `myAlternates`, which is then *used* in two features: `salt` is a general feature for stylistic alternates (alternate forms of the glyph which can be selected by the user for aesthetic reasons), and `ss01` which selects the first stylistic set. The ability to name and reference sets of rules in a lookup will come in extremely useful when we look at chaining rules - when one rule calls another.
第一条语句将一些规则定义为`myAlternates`#tr[lookup]，后续它被用在 `salt` 和 `ss01` 两个特性中。`salt` 是一种通用特性，供用户选择#tr[glyph]在美学上的替代样式。而 `ss01` 特性用于启用第一种样式。这种可以为#tr[lookup]命名并通过名称引用其中的规则的功能非常有用，特别是在后续介绍#tr[chaining rules]（一个规则调用另一个规则）时。
