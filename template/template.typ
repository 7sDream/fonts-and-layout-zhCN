#import "page.typ": page_setting;
#import "font.typ": font-setting;
#import "l10n.typ": l10n_setting;
#import "heading.typ": heading-setting;

#let template(doc) = [
  #show: page_setting
  #show: font-setting
  #show: l10n_setting
  #show: heading-setting

  #doc
]
