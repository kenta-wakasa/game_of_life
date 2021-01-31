import 'package:flutter/material.dart';

class MainController extends ChangeNotifier {
  MainController({
    this.baseLength = 20.0,
    this.width = 100,
    this.height = 60,
  }) {
    _cellList = List.generate(width * height, (index) => false);

    editable = true;
    _generations = 0;
    _waitTimeMS = 1000;
    isPlaying = false;
    start = true;
  }
  final double baseLength;
  final int width;
  final int height;
  int _generations;
  String get generations => _generations.toString().padLeft(8, '0');
  int _waitTimeMS;
  int get waitTimeMS => _waitTimeMS;
  set waitTimeMS(int newWaiTimeMs) {
    _waitTimeMS = newWaiTimeMs;
    notifyListeners();
  }

  List<bool> _cellList;
  List<bool> get cellList => _cellList;
  List<bool> _cellListWhenTapDown;
  bool editable;
  bool isPlaying;
  bool start;

  int positionToIndex(Offset offset) =>
      offset.dx ~/ baseLength + offset.dy ~/ baseLength * width;

  Offset indexToPosition(int index) =>
      Offset((index % width).toDouble(), (index ~/ width).toDouble());

  @override
  void dispose() {
    super.dispose();
    start = false;
  }

  Future<void> mainLoop() async {
    isPlaying = true;
    while (start) {
      _countLivingCellsAroundMe();
      notifyListeners();
      _generations++;
      await Future<void>.delayed(Duration(milliseconds: _waitTimeMS));
    }
    isPlaying = false;
    notifyListeners();
  }

  void clearCells() {
    _generations = 0;
    _cellList = List.generate(width * height, (index) => false);
    notifyListeners();
  }

  void setCellListWhenTapDown() {
    _cellListWhenTapDown = List.from(_cellList);
  }

  /// 指定した [index] の bool を反転させる
  void ivertCells(int index) {
    _cellList[index] = !_cellListWhenTapDown[index];
    notifyListeners();
  }

  /// 与えられた indexList をもとに true の数を求める
  int _countLivingCells(List<int> indexList) {
    var count = 0;
    for (final index in indexList) {
      if (index > -1 && index < cellList.length) {
        if (cellList[index]) {
          count++;
        }
      }
    }
    return count;
  }

  /// すべての cells に対して周囲 8 マス の true 数を数え
  /// それに応じて自分の生死を決める。
  void _countLivingCellsAroundMe() {
    final list = List<bool>.from(cellList);
    for (var index = 0; index < cellList.length; index++) {
      var count = 0;

      /// 左端の処理
      if (index % width == 0) {
        final indexList = <int>[
          index + width,
          index - width,
          index + 1 - width,
          index + 1,
          index + 1 + width,
        ];
        count = _countLivingCells(indexList);
      }

      /// 右端の処理
      else if ((index % width) == (width - 1)) {
        final indexList = <int>[
          index - 1 - width,
          index - 1,
          index - 1 + width,
          index + width,
          index - width,
        ];
        count = _countLivingCells(indexList);
      }

      /// 通常の場合
      else {
        final indexList = <int>[
          index - 1 - width,
          index - 1,
          index - 1 + width,
          index - width,
          index + width,
          index + 1 - width,
          index + 1,
          index + 1 + width,
        ];
        count = _countLivingCells(indexList);
      }

      /// 誕生
      if (!cellList[index] && count == 3) {
        list[index] = true;
      }

      /// 生存
      else if (cellList[index] && (count == 2 || count == 3)) {
        list[index] = true;
      }

      /// 過疎, 過密
      else {
        list[index] = false;
      }
    }
    _cellList = list;
  }
}
