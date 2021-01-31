import 'package:flutter/material.dart';

import 'cell.dart';

class MainController extends ChangeNotifier {
  MainController({
    this.baseLength = 20.0,
    this.width = 100,
    this.height = 60,
  }) {
    _cellList = Cell.generateCells(width, height);
    _generations = 0;
    _waitTimeMS = 1000;
    editable = true;
    isPlaying = false;
    start = false;
  }

  final double baseLength;
  final int width;
  final int height;

  List<Cell> _cellList;
  List<Cell> get cellList => _cellList;
  List<bool> cellListWhenTapDown;
  int _generations;
  String get generations => _generations.toString().padLeft(8, '0');
  int _waitTimeMS;
  int get waitTimeMS => _waitTimeMS;
  set waitTimeMS(int newWaiTimeMs) {
    _waitTimeMS = newWaiTimeMs;
    notifyListeners();
  }

  bool editable;
  bool isPlaying;
  bool start;

  @override
  void dispose() {
    super.dispose();
    start = false;
  }

  int positionToIndex(Offset position) =>
      position.dx ~/ baseLength + position.dy ~/ baseLength * width;

  Future<void> mainLoop() async {
    isPlaying = true;
    while (start) {
      _nextGenerations();
      notifyListeners();
      _generations++;
      await Future<void>.delayed(Duration(milliseconds: _waitTimeMS));
    }
    isPlaying = false;
    notifyListeners();
  }

  void invertCell(int index) {
    cellList[index] =
        cellList[index].copyWith(alive: !cellListWhenTapDown[index]);
    notifyListeners();
  }

  void clearCellList() {
    _generations = 0;
    _cellList = Cell.generateCells(width, height);
    notifyListeners();
  }

  void setCellListWhenTapDown() {
    cellListWhenTapDown = _cellList.map((e) => e.alive).toList();
  }

  /// 全ての cells について次の世代の生死を調べる
  void _nextGenerations() {
    final tmpList = List<Cell>.from(_cellList);
    for (var index = 0; index < cellList.length; index++) {
      final pointList = cellList[index].getPointAroundMe;
      var count = 0;
      for (final point in pointList) {
        if (point.x > -1 &&
            point.x < width &&
            point.y > -1 &&
            point.y < height) {
          if (cellList[Cell.pointToIndex(point, width)].alive) {
            count++;
          }
        }
      }
      if (cellList[index].alive) {
        if (count < 2 || count > 3) {
          tmpList[index] = tmpList[index].copyWith(alive: false);
        }
      } else {
        if (count == 3) {
          tmpList[index] = tmpList[index].copyWith(alive: true);
        }
      }
    }
    _cellList = tmpList;
  }
}
