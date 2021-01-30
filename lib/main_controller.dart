import 'package:flutter/material.dart';

class MainController extends ChangeNotifier {
  MainController({
    this.baseLength = 16.0,
    this.width = 200,
    this.height = 200,
  }) {
    _cellList = List.generate(width * height, (index) => false);
    editable = true;
    waitTimeMS = 500;
    isPlaying = false;
  }
  final baseLength;
  final width;
  final height;
  List<bool> _cellList;
  List<bool> get cellList => _cellList;

  int waitTimeMS;
  bool editable;
  bool isPlaying;

  Future<void> mainLoop() async {
    while (isPlaying) {
      _countLivingCellsAroundMe();
      notifyListeners();
      await Future.delayed(Duration(milliseconds: waitTimeMS));
    }
    notifyListeners();
  }

  int positionToIndex(Offset offset) =>
      offset.dx ~/ baseLength + offset.dy ~/ baseLength * width;

  Offset indexToPosition(int index) =>
      Offset(index % width, (index ~/ width).toDouble());

  @override
  void dispose() {
    super.dispose();
  }

  /// 指定した [index] の bool を反転させる
  ivertCells(int index) {
    _cellList[index] = !_cellList[index];
    notifyListeners();
  }

  /// 指定した [index] の bool をtrueにする
  generateCells(int index) {
    _cellList[index] = true;
    notifyListeners();
  }

  int _checkCells(List<int> indexList) {
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

  void _countLivingCellsAroundMe() {
    final List<bool> list = List.from(cellList);
    for (var index = 0; index < cellList.length; index++) {
      int count = 0;

      /// 左端の処理
      if (index % width == 0) {
        final indexList = <int>[
          index + width,
          index - width,
          index + 1 - width,
          index + 1,
          index + 1 + width,
        ];
        count = _checkCells(indexList);

        /// 右端の処理
      } else if ((index % width) == (width - 1)) {
        final indexList = <int>[
          index - 1 - width,
          index - 1,
          index - 1 + width,
          index + width,
          index - width,
        ];
        count = _checkCells(indexList);

        /// それ以外
      } else {
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
        count = _checkCells(indexList);
      }

      /// 誕生
      if (!cellList[index] && count == 3) {
        list[index] = true;
      }

      /// 生存
      else if (cellList[index] && (count == 2 || count == 3)) {
        list[index] = true;
      }

      /// 過疎
      else if (cellList[index] && count < 2) {
        list[index] = false;
      } else {
        list[index] = false;
      }

      /// 過密
      // else if (cellList[index] && count > 3) {
      //   cellList[index] = false;
      // }
    }
    _cellList = list;
  }
}
