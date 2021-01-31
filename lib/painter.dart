import 'package:flutter/material.dart';
import 'package:game_of_life/cell.dart';

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
  List<Cell> cells;

  void paintCells(Canvas canvas, Paint paint, List<Cell> cells) {
    for (final cell in cells) {
      if (cell.alive) {
        canvas.drawRect(
          Rect.fromLTWH(
            basicLength * cell.pos.x,
            basicLength * cell.pos.y,
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
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.yellow[700];

    paintCells(canvas, paint, cells);
  }

  @override
  bool shouldRepaint(Painter oldDelegate) {
    return true;
  }
}
