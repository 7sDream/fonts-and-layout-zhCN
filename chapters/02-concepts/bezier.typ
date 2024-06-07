#import "/template/template.typ": web-page-template
#import "/template/components.typ": note

#import "/lib/glossary.typ": tr

#show: web-page-template

// ## Bézier curves
== 贝塞尔曲线

// We've already mentioned that outlines in digital fonts are made out of lines and Bézier curves. I'm not going to spend a lot of time getting into the mathematics of how Bézier curves work, but if you're doing any kind of implementing -  rasterising, font editing or font manipulation - you would be wise to spend some time looking through Mike Kamerman's [A Primer on Bézier Curves](https://pomax.github.io/BezierInfo-2/).
前文已经介绍过，数字字体中的#tr[outline]是由直线和贝塞尔曲线组成的。本书不会过多介绍关于贝塞尔曲线的数学支持，但如果你想实际实现一些东西——比如字体#tr[rasterization]器、编辑器、操作工具——的话，可以花时间看看Mike Kamerman的《A Primer on Bézier Curves》@Kamerman.PrimerBezier。

// What is worth considering, for our purposes, is the difference between *quadratic* and *cubic* Bézier curves. As we've seen, Bézier curves are specified by a start point, an end point, and one or more control points, which pull the curve towards them. A quadratic Bézier curve has one control point, whereas a cubic Bézier curve has two. (Higher order curves are possible, but not used in type design.)
但对于本书的主旨来说，*二次*和*三次*贝塞尔曲线的区别是值得讨论一下的。贝塞尔曲线是由一个起始点、一个终结点，和一个或多个控制点构造而成的。这些控制点会将曲线往它们所在的位置拉动。二次贝塞尔曲线有一个控制点，而三次的会有两个。更高次的贝塞尔曲线也是存在的，但没有在字体设计中使用。

// TrueType outlines use quadratic Bézier curves, whereas PostScript fonts use cubic Bézier curves; it's possible to convert from a quadratic curve to a cubic curve and get the same shape, but it's not always possible to perfectly go from a cubic curve to a quadratic curve - you have to approximate it. Again, you'll find all the details in A Primer on Bézier Curves.
TrueType中使用二次贝塞尔曲线来绘制#tr[outline]，PostScript中则是使用三次贝塞尔曲线。在不改变曲线形状的情况下，将二次曲线转换为三次曲线是可行的。但反过来却不行，得到的二次曲线会是原三次曲线的近似。关于曲线转换的详细内容，也请参考《A Primer on Bézier Curves》。

// I've said that outlines are made out of Bézier curves, but a more accurate way to say that is that they are made of a series of Bézier curves joined together. When two Bézier curves meet, they can either meet in a *smooth* join or at a *corner*. You will use both of these types of join in type design; generally, you will want things to be smooth if they would form part of the same "stroke" of a pen or brush, but there are places where you'll need corner joins too. Here you see a portion of the top edge of a letter m, which contains a smooth join and a corner join.
之前我们说#tr[outline]由贝塞尔曲线组成，实际上更准确的表述应该是它由一系列贝塞尔曲线首尾相连组成。当两条贝塞尔曲线相连时。它们可以“平滑”的连接，也可以形成“转角”。这两种连接方式在设计中都会使用。通常来说，如果是在勾勒笔或笔刷画出的笔画的话，会平滑的连接曲线。但也有一些地方是需要生硬的转角的。你可以从@figure:m-top 中看到，字母 m 的上顶端同时使用了光滑连接和转角。

#figure(caption: [
  m 上部的轮廓曲线
])[#include "mtop.typ"] <figure:m-top>

// The main condition for a smooth join is that you can draw a straight line through an on-curve point and the both off-curve points (often called "handles" because you can pull on them to drag the curve around) to the left and right of it - as you can see in the first join above. The second join has handles at differing angles, so it is a corner join.
平滑连接所需的条件是：连接点与其左右两侧的相邻控制点在同一条直线上。这种在曲线上的（起始和终结）点和控制点之间的连线通常被叫做“手柄”，因为你可以通过拉动它们来控制曲线。@figure:m-top 中的第一个连接处就是平滑的，而第二个连接处的两个手柄角度不同，它们并不在一条直线上，所以是一个转角连接。

// Your font editor will have ways of creating smooth and corner joins; the problem is that what we've called a "smooth" join, formed by aligning the angles of the handles (which is called *C1* continuity), isn't guaranteed to be *visually* smooth. Consider the following two paths:
字体编辑器通常会有各种方式来构造平滑或者转角连接。但问题是，即使是这种手柄在同一直线上的光滑连接（这也被称为*C1*连续），也不能保证它在*视觉*上是光滑的。看看@figure:g2 中的两个示例。

#figure(caption: [
  连续性的区别
])[#include "g2.typ"] <figure:g2>

// Do they look very similar? How about if you think of them as roads - which is easier to drive on? The upper path will require you to bring your steering wheel back to central for the straighter portion where the two Bézier curves join, before turning right again. The lower path continuously curves so that if you get your steering wheel in the right place at the start of the road, you hardly need to turn the wheel as you drive along it. Many font editors have facilities for matching the curvature on both sides of the on-curve point (which is known as G2 continuity), either natively or through add-ons like [SpeedPunk](https://yanone.de/software/speedpunk/) or [SuperTool](http://www.corvelsoftware.co.uk/software/supertool/).
它们看起来很相似。但如果把这两条线想象成道路的话，在哪一条路上开车更简单更舒适呢？上面那条路，你在起点处方向盘是在初始位置，而在两条贝塞尔曲线的交点处也需要把方向盘回正，然后再重新打方向继续转弯。而下面那条路，你可以在起点就把方向盘摆到一个正确的位置，而沿着这条路开的时候几乎不需要再动方向。许多字体编辑器都提供了为曲线上的点进行这种曲率匹配（也称为 G2 连续）的能力。有些软件内置这种功能，其他一些也可以通过Speed Punk#[@Yanone.SpeedPunk]或SuperTool#[@Cozens.SuperTool.2019]等插件完成。
