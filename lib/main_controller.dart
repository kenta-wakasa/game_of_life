import 'package:flutter/material.dart';

class MainController extends ChangeNotifier {
  MainController({
    this.baseLength = 20.0,
    this.width = 100,
    this.height = 100,
  }) {
    _cells =
        List.generate(width * height, (index) => false);
    editable = true;
  }
  final baseLength;
  final width;
  final height;
  List<bool> _cells;
  List<bool> get cells => _cells;

  bool editable;

  int positionToIndex(Offset offset) =>
      offset.dx ~/ baseLength + offset.dy ~/ baseLength * width;

  /// 指定した [index] の bool を反転させる
  ivertCells(int index) {
    _cells[index] = !_cells[index];
    notifyListeners();
  }
}
