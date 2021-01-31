import 'dart:math';

import 'package:flutter/material.dart';

@immutable
class Cell {
  const Cell({
    this.alive = false,
    @required this.pos,
  });

  final bool alive;
  final Point<int> pos;

  Cell copyWith({bool alive, Point<int> pos}) =>
      Cell(alive: alive ?? this.alive, pos: pos ?? this.pos);

  static List<Cell> generateCells(int width, int height) {
    final cellList = <Cell>[];
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        cellList.add(Cell(pos: Point<int>(x, y)));
      }
    }
    return cellList;
  }

  static int pointToIndex(Point<int> point, int width) {
    return point.x + point.y * width;
  }

  /// 周囲のセルの場所を返す
  List<Point<int>> get getPointAroundMe {
    final pointList = <Point<int>>[];
    for (var x = 0; x < 3; x++) {
      for (var y = 0; y < 3; y++) {
        final point = Point<int>(pos.x - 1 + x, pos.y - 1 + y);
        if (pos != point) {
          pointList.add(point);
        }
      }
    }
    return pointList;
  }
}
