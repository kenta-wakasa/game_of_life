import 'package:flutter/material.dart';

class Painter extends CustomPainter {
  Painter({
    @required this.basicLength,
    @required this.width,
    @required this.height,
    @required this.cells,
  });
  double basicLength; // 1 グリッドの長さ
  int width;
  int height;
  List<bool> cells;

  void paintCells(Canvas canvas, Paint paint, List<bool> cells) {
    for (var index = 0; index < cells.length; index++) {
      if (cells[index]) {
        canvas.drawRect(
          Rect.fromLTWH(
            basicLength * (index % width),
            basicLength * (index ~/ width),
            basicLength,
            basicLength,
          ),
          paint,
        );
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // /// draw grid
    // paint.strokeWidth = .5;

    // // draw vertical grid
    // for (var index = 0; index <= width; index++) {
    //   canvas.drawLine(
    //     Offset(basicLength * index, 0),
    //     Offset(basicLength * index, basicLength * height),
    //     paint,
    //   );
    // }

    // // draw horizontal grid
    // for (var index = 0; index <= height; index++) {
    //   canvas.drawLine(
    //     Offset(basicLength * 0, basicLength * index),
    //     Offset(basicLength * width, basicLength * index),
    //     paint,
    //   );
    // }

    paint
      ..style = PaintingStyle.fill
      ..color = Colors.yellow[700];

    paintCells(canvas, paint, cells);
  }

  @override
  bool shouldRepaint(Painter oldDelegate) {
    return true;
  }
}
