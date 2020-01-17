// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'hand.dart';

/// A clock hand that is drawn with [CustomPainter]
///
/// The hand's length scales based on the clock's size.
/// This hand is used to build the second and minute hands, and demonstrates
/// building a custom hand.
class DrawnHand extends Hand {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  const DrawnHand({
    @required Color color,
    @required this.thickness,
    @required double size,
    @required double angleRadians,
  })  : assert(color != null),
        assert(thickness != null),
        assert(size != null),
        assert(angleRadians != null),
        super(
          color: color,
          size: size,
          angleRadians: angleRadians,
        );

  /// How thick the hand should be drawn, in logical pixels.
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _HandPainter(
            handSize: size,
            lineWidth: thickness,
            angleRadians: angleRadians,
            color: color,
          ),
        ),
      ),
    );
  }
}

/// [CustomPainter] that draws a clock hand.
class _HandPainter extends CustomPainter {
  _HandPainter({
    @required this.handSize,
    @required this.lineWidth,
    @required this.angleRadians,
    @required this.color,
  })  : assert(handSize != null),
        assert(lineWidth != null),
        assert(angleRadians != null),
        assert(color != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0);

  double handSize;
  double lineWidth;
  double angleRadians;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    // We want to start at the top, not at the x-axis, so add pi/2.
    final angle = angleRadians - math.pi / 2.0;
    final length = size.shortestSide * 0.5 * handSize;
    final position = center + Offset(math.cos(angle), math.sin(angle)) * length;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.square;
    final canvasSize = size.width;
    final radius = canvasSize / 3;

    /// Paint the numbers for analog clock.
    final textPainter1 = textPaint('1', canvasSize, color);
    final offset1 = center +
        Offset(math.cos(math.pi / 3) * radius - textPainter1.size.width / 2,
            -math.sin(math.pi / 3) * radius - textPainter1.size.height / 2);
    textPainter1.paint(canvas, offset1);

    final textPainter2 = textPaint('2', canvasSize, color);
    final offset2 = center +
        Offset(math.cos(math.pi / 6) * radius - textPainter2.size.width / 2,
            -math.sin(math.pi / 6) * radius - textPainter2.size.height / 2);
    textPainter2.paint(canvas, offset2);

    final textPainter3 = textPaint('3', canvasSize, color);
    final offset3 =
        center + Offset(radius - textPainter3.width / 2, -textPainter3.width);
    textPainter3.paint(canvas, offset3);

    final textPainter4 = textPaint('4', canvasSize, color);
    final offset4 = center +
        Offset(math.cos(math.pi / 6) * radius - textPainter4.size.width / 2,
            math.sin(math.pi / 6) * radius - textPainter4.size.height / 2);
    textPainter4.paint(canvas, offset4);

    final textPainter5 = textPaint('5', canvasSize, color);
    final offset5 = center +
        Offset(math.cos(math.pi / 3) * radius - textPainter5.size.width / 2,
            math.sin(math.pi / 3) * radius - textPainter5.size.height / 2);
    textPainter5.paint(canvas, offset5);

    final textPainter6 = textPaint('6', canvasSize, color);
    final offset6 =
        center + Offset(-textPainter6.width / 2, radius - textPainter6.width);
    textPainter6.paint(canvas, offset6);

    final textPainter7 = textPaint('7', canvasSize, color);
    final offset7 = center +
        Offset(-math.cos(math.pi / 3) * radius - textPainter7.size.width / 2,
            math.sin(math.pi / 3) * radius - textPainter7.size.height / 2);
    textPainter7.paint(canvas, offset7);

    final textPainter8 = textPaint('8', canvasSize, color);
    final offset8 = center +
        Offset(-math.cos(math.pi / 6) * radius - textPainter8.size.width / 2,
            math.sin(math.pi / 6) * radius - textPainter8.size.height / 2);
    textPainter8.paint(canvas, offset8);

    final textPainter9 = textPaint('9', canvasSize, color);
    final offset9 =
        center - Offset(radius + textPainter9.width / 2, textPainter9.width);
    textPainter9.paint(canvas, offset9);

    final textPainter10 = textPaint('10', canvasSize, color);
    final offset10 = center +
        Offset(-math.cos(math.pi / 6) * radius - textPainter10.size.width / 2,
            -math.sin(math.pi / 6) * radius - textPainter10.size.height / 2);
    textPainter10.paint(canvas, offset10);

    final textPainter11 = textPaint('11', canvasSize, color);
    final offset11 = center +
        Offset(-math.cos(math.pi / 3) * radius - textPainter11.size.width / 2,
            -math.sin(math.pi / 3) * radius - textPainter11.size.height / 2);
    textPainter11.paint(canvas, offset11);

    final textPainter12 = textPaint('12', canvasSize, color);
    final offset12 = center -
        Offset(textPainter12.size.width / 2,
            radius + textPainter12.size.height / 2);
    textPainter12.paint(canvas, offset12);

    canvas.drawLine(center, position, linePaint);
  }

  @override
  bool shouldRepaint(_HandPainter oldDelegate) {
    return oldDelegate.handSize != handSize ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.angleRadians != angleRadians ||
        oldDelegate.color != color;
  }

  /**
   * A function used to paint a specific number on the canvas.
   *
   */
  TextPainter textPaint(String number, double size, Color color) {
    final textStyleRegular = TextStyle(
      color: color,
      fontSize: size / 7,
    );
    final textStyleBold = TextStyle(
      fontWeight: FontWeight.bold,
      color: color,
      fontSize: size / 5,
    );

    var textStyle = textStyleRegular;

    if (number == '3' || number == '6' || number == '9' || number == '12') {
      textStyle = textStyleBold;
    }

    final textSpan = TextSpan(
      text: number,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size,
    );
    return textPainter;
  }
}
