#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ### The `post` table
=== `post` 表

// While we're on the subject of PostScript Type 1 representation, let's briefly look at the `post` table, which is used to assemble data for downloading fonts onto PostScript printers:
既然我们已经在介绍PostScript相关技术了，也顺便看看用于把字体传输到PostScript打印机上的`post`表的内容：

```xml
<post>
  <formatType value="3.0"/>
  <italicAngle value="0.0"/>
  <underlinePosition value="-75"/>
  <underlineThickness value="50"/>
  <isFixedPitch value="0"/>
  <minMemType42 value="0"/>
  <maxMemType42 value="0"/>
  <minMemType1 value="0"/>
  <maxMemType1 value="0"/>
</post>
```

// The `post` table has been through various revisions; in previous versions, it would also include a list of glyph names, but as of version 3.0, no glyph names are provided to the PostScript processor. The final four values are hints to the driver as to how much memory this font requires to process. Setting it to zero doesn't do any harm; it just means that the driver has to work it out for itself. The italic angle is specified in degrees *counter*clockwise, so a font that leans forward 10 degrees will have an italic angle of -10. `isFixedPitch` specifies a monospaced font, and the remaining two values are irrelevant because nobody should ever use underlining for anything, am I right?
`post`表有多个版本，在老版本中它还需要包含#tr[glyph]名称列表，不过3.0之后就不需要了。最后的四个值用于告诉打印机这个字体需要多少内存来进行处理。将它们设置成0并不会影响字体的功能，只是代表打印机需要自行判断使用多少内存。`italicAngle` 在表示倾斜角度时要求使用逆时针，所以向前倾斜10度的字体这个字段需要填 -10。`isFixedPitch`用于指定是否为等宽字体。剩下的两个很明显是决定下划线的位置和粗细程度。
